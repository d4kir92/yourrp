--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

sql_add_column( "yrp_inventory", "CharID", "INT DEFAULT 0" )
sql_add_column( "yrp_inventory", "f_x", "TEXT DEFAULT '0'" )
sql_add_column( "yrp_inventory", "f_y", "TEXT DEFAULT '0'" )
sql_add_column( "yrp_inventory", "i_w", "INT DEFAULT 0" )
sql_add_column( "yrp_inventory", "i_h", "INT DEFAULT 0" )
sql_add_column( "yrp_inventory", "i_aw", "TEXT DEFAULT 'x'" )
sql_add_column( "yrp_inventory", "i_ah", "TEXT DEFAULT 'y'" )
sql_add_column( "yrp_inventory", "i_center", "TEXT DEFAULT ''" )
sql_add_column( "yrp_inventory", "ClassName", "TEXT DEFAULT '[EMPTY]'" )
sql_add_column( "yrp_inventory", "PrintName", "TEXT DEFAULT ''" )
sql_add_column( "yrp_inventory", "Model", "TEXT DEFAULT ''" )

--db_drop_table( "yrp_inventory" )
--db_is_empty( "yrp_inventory" )

local INV_W = 8

util.AddNetworkString( "get_inventory" )

function get_inv( id )
  local _result = {}
  for y = 1, 8 do
    _result["f_y"..y] = {}
    for x = 1, INV_W do
      _result["f_y"..y]["f_x"..x] = db_select( "yrp_inventory", "*", "f_x = '" .. x .. "' AND f_y = '" .. y .. "' AND CharID = " .. id )
      if _result["f_y"..y]["f_x"..x] == nil then
        return nil
      else
        if _result["f_y"..y]["f_x"..x][1] != nil then
          _result["f_y"..y]["f_x"..x] = _result["f_y"..y]["f_x"..x][1]
        end
      end
    end
  end
  return _result
end

function check_inv( ply, id )
  printGM( "db", "Check Inv" )
  local _inv = get_inv( id )
  if _inv == nil then
    printGM( "note", ply:Nick() .. " has no inventory. Creating one." )
    for y = 1, 8 do
      for x = 1, INV_W do
        db_insert_into( "yrp_inventory", "CharID, f_x, f_y", id .. ", '" .. x .. "', '" .. y .. "'" )
      end
    end
  end
  if db_select( "yrp_inventory", "CharID, f_x, f_y", id .. ", 'w1', 'w1'" ) == false then
    printGM( "db", "weapon slots" )
    --Weapons
    db_insert_into( "yrp_inventory", "CharID, f_x, f_y", id .. ", 'w1', 'w1'" )
    db_insert_into( "yrp_inventory", "CharID, f_x, f_y", id .. ", 'w2', 'w2'" )
    db_insert_into( "yrp_inventory", "CharID, f_x, f_y", id .. ", 'w3', 'w3'" )
    db_insert_into( "yrp_inventory", "CharID, f_x, f_y", id .. ", 'w4', 'w4'" )
    db_insert_into( "yrp_inventory", "CharID, f_x, f_y", id .. ", 'w5', 'w5'" )
  end
  if db_select( "yrp_inventory", "CharID, f_x, f_y", id .. ", 'bp', 'bp'" ) == false then
    printGM( "db", "backpack slot" )
    --Backpack
    db_insert_into( "yrp_inventory", "CharID, f_x, f_y", id .. ", 'bp', 'bp'" )
  end
  if db_select( "yrp_inventory", "CharID, f_x, f_y", id .. ", 'helm', 'helm'" ) == false then
    printGM( "db", "equipment slots" )
    --Equipment

    --helm
    db_insert_into( "yrp_inventory", "CharID, f_x, f_y", id .. ", 'helm', 'helm'" )
  end
end

function send_inventory( ply )
  local _char_id = ply:CharID()
  local _inv = check_inv( ply, _char_id )
  _inv = get_inv( _char_id )

  net.Start( "get_inventory" )
    net.WriteTable( _inv )
  net.Send( ply )
end

net.Receive( "get_inventory", function( len, ply )
  send_inventory( ply )
end)

function print_inventory( ply )
  local _char_id = ply:CharID()

  for y = 1, 8 do
    local _str = ""
    for x = 1, INV_W do
      local _select = db_select( "yrp_inventory", "*", "CharID = " .. _char_id .. " AND f_x = '" .. x .. "' AND f_y = '" .. y .. "'" )
      if _select != nil then
        _select = _select[1]
        if _select.ClassName == "[EMPTY]" then
          _str = _str .. "E" .. " "
        else
          if #_select.ClassName < 3 then
            _str = _str .. _select.ClassName .. " "
          else
            _str = _str .. "C" .. " "
          end
        end
      end
    end
    print(_str)
  end
end

function is_in_inventory( ply, cname )
  local _char_id = ply:CharID()
  if _char_id != nil then
    local _result = db_select( "yrp_inventory", "*", "CharID = " .. _char_id .. " AND ClassName = '" .. cname .. "'" )
    if _result == nil then
      return false
    else
      return true
    end
    return false
  end
end

function find_free_space( ply, w, h, posx, posy )
  print_inventory( ply )
  local _char_id = ply:CharID()

  local _stx = 1
  local _sty = 1
  local _enx = INV_W
  local _eny = 8
  if posx != nil then
    _stx = posx
    _sty = posy
    _enx = posx+w
    _eny = posy+h
  end

  local _inv = {}
  for y = _sty, _eny do
    _inv[y] = {}
    for x = _stx, _enx do
      local _enough_space = true
      local _select = db_select( "yrp_inventory", "*", "CharID = " .. _char_id .. " AND f_x = '" .. x .. "' AND f_y = '" .. y .. "' AND ClassName = '[EMPTY]'" )
      if _select != nil then
        _select = _select[1]

        for _y = y, y + h-1 do
          for _x = x, x + w-1 do
            local _sel = db_select( "yrp_inventory", "*", "CharID = " .. _char_id .. " AND f_x = '" .. _x .. "' AND f_y = '" .. _y .. "'" )
            if _sel != nil then
              _sel = _sel[1]

              if _sel.ClassName != "[EMPTY]" then
                _enough_space = false
              end
              if isnumber( tonumber( _sel.ClassName ) ) then
                _enough_space = false
              end
            else
              _enough_space = false
            end
          end
        end
      else
        _enough_space = false
      end
      if _enough_space then
        return x, y
      end
    end
  end
  return false
end

function insert_in_inventory( ply, _item, posx, posy )
  print("insert")

  local _x, _y = find_free_space( ply, _item.i_w, _item.i_h, posx, posy )
  if _x != false then
    local _sets = "ClassName = '" .. _item.ClassName .. "'"
    _sets = _sets .. ", PrintName = '" .. _item.PrintName .. "'"
    _sets = _sets .. ", Model = '" .. _item.Model .. "'"
    _sets = _sets .. ", i_w = " .. _item.i_w
    _sets = _sets .. ", i_h = " .. _item.i_h
    _sets = _sets .. ", i_aw = '" .. _item.i_aw .. "'"
    _sets = _sets .. ", i_ah = '" .. _item.i_ah .. "'"
    _sets = _sets .. ", i_center = '" .. _item.i_center .. "'"

    print(_sets)

    db_update( "yrp_inventory", _sets, "CharID = "..ply:CharID() .. " AND f_x = '" .. _x .. "' AND f_y = '" .. _y .. "'" )

    local _result = db_select( "yrp_inventory", "*", "CharID = " .. ply:CharID() .. " AND f_x = '" .. _x .. "' AND f_y = '" .. _y .. "'" )
    if _result != nil then
      _result = _result[#_result]
      for __y = _y, (_y+_item.i_h-1) do
        for __x = _x, (_x+_item.i_w-1) do
          if __x != _x or __y != _y then
            print("uniqueID insert")
            local _result2 = db_update( "yrp_inventory", "ClassName = '" .. tostring( _result.uniqueID ) .. "'", "CharID = " .. ply:CharID() .. " AND f_x = '" .. __x .. "' AND f_y = '" .. __y .. "'" )
          end
        end
      end
    end
    print_inventory( ply )
  else
    local _drop = ents.Create( _item.ClassName )
    _drop:SetPos( ply:GetPos() + ply:GetForward() * 100 )
    _drop:Spawn()
  end
end

function rem_item( id, uid )
  print("rem_item " .. id .. " " .. uid)
  local _result = db_update( "yrp_inventory", "ClassName = '[EMPTY]', PrintName = '', Model = ''", "CharID = " .. id .. " AND uniqueID = " .. uid )
  local _result2 = db_update( "yrp_inventory", "ClassName = '[EMPTY]', PrintName = '', Model = ''", "CharID = " .. id .. " AND ClassName = '" .. uid .. "'" )
end

function rem_item_at_pos( id, x, y, uid )
  print("rem_item_at_pos " .. id .. " " .. x .. " " .. y .. " " .. uid)
  local _result = db_update( "yrp_inventory", "ClassName = '[EMPTY]', PrintName = '', Model = ''", "CharID = " .. id .. " AND f_x = '" .. x .. "' AND f_y = '" .. y .. "'" )
  local _result2 = db_update( "yrp_inventory", "ClassName = '[EMPTY]', PrintName = '', Model = ''", "CharID = " .. id .. " AND ClassName = '" .. uid .. "'" )
end

util.AddNetworkString( "item_drop" )

net.Receive( "item_drop", function( len, ply )
  local _uid = net.ReadString()
  local _char_id = ply:CharID()
  local _result = db_select( "yrp_inventory", "*", "uniqueID = " .. _uid .. " AND CharID = " .. _char_id )
  PrintTable( _result )
  if _result != nil then
    _result = _result[1]

    print(_result.ClassName)
    local _drop = ents.Create( _result.ClassName )
    if _drop != NULL then
      _drop:SetPos( ply:GetPos() + ply:GetForward() * 100 )
      _drop:Spawn()
    end

    rem_item_at_pos( _char_id, _result.f_x, _result.f_y, _uid )
  end
  print_inventory( ply )
end)

util.AddNetworkString( "item_move" )

function is_enough_space( id, x, y )
  local _enough_space = true

  for _y = y, 8 do
    for _x = x, INV_W do
      local _select = db_select( "yrp_inventory", "*", "CharID = " .. id .. " AND f_x = '" .. _x .. "' AND f_y = '" .. _y .. "' AND ClassName = '[EMPTY]'" )
      if _select != nil then
        _select = _select[1]
        if _select.ClassName != "[EMPTY]" then
          --occupied
          _enough_space = false
        end
      else
        --outside of inventory
        _enough_space = false
      end
    end
  end

  --enough space
  return true
end

function insert_in_equipment( ply, _item, field )
  print("insert in eq")


  local _sets = "ClassName = '" .. _item.ClassName .. "'"
  _sets = _sets .. ", PrintName = '" .. _item.PrintName .. "'"
  _sets = _sets .. ", Model = '" .. _item.Model .. "'"
  _sets = _sets .. ", i_w = " .. _item.i_w
  _sets = _sets .. ", i_h = " .. _item.i_h
  _sets = _sets .. ", i_aw = '" .. _item.i_aw .. "'"
  _sets = _sets .. ", i_ah = '" .. _item.i_ah .. "'"
  _sets = _sets .. ", i_center = '" .. _item.i_center .. "'"

  print(_sets)

  db_update( "yrp_inventory", _sets, "CharID = "..ply:CharID() .. " AND f_x = '" .. field .. "' AND f_y = '" .. field .. "'" )
end

net.Receive( "item_move", function( len, ply )
  local _x = net.ReadString()
  local _y = net.ReadString()
  local _uid = net.ReadString()
  local _char_id = ply:CharID()

  print("item_move")
  print(_x,_y,_uid)

  if !isnumber( tonumber( _x ) ) then
    local _sel = db_select( "yrp_inventory", "*", "CharID = " .. _char_id .. " AND uniqueID = " .. _uid )
    if _sel != nil then
      _sel = _sel[1]

      local _item = {}
      _item.ClassName = _sel.ClassName or "NO CLASSNAME"
      _item.PrintName = _sel.PrintName or "NO PRINTNAME"
      _item.Model = _sel.Model or "NO MODEL"
      _item.i_w = _sel.i_w or 1
      _item.i_h = _sel.i_h or 1
      _item.i_aw = _sel.i_aw or "x"
      _item.i_ah = _sel.i_ah or "y"
      _item.i_center = _sel.i_center or "0 0 0"

      rem_item( _char_id, _sel.uniqueID )

      insert_in_equipment( ply, _item, _x, _y )

      send_inventory( ply )
    end
  elseif is_enough_space( _char_id, _x, _y ) then
    print("ENOUGH SPACE")
    local _sel = db_select( "yrp_inventory", "*", "CharID = " .. _char_id .. " AND uniqueID = " .. _uid )
    if _sel != nil then
      _sel = _sel[1]

      local _item = {}
      _item.ClassName = _sel.ClassName or "NO CLASSNAME"
      _item.PrintName = _sel.PrintName or "NO PRINTNAME"
      _item.Model = _sel.Model or "NO MODEL"
      _item.i_w = _sel.i_w or 1
      _item.i_h = _sel.i_h or 1
      _item.i_aw = _sel.i_aw or "x"
      _item.i_ah = _sel.i_ah or "y"
      _item.i_center = _sel.i_center or "0 0 0"

      rem_item( _char_id, _sel.uniqueID )

      insert_in_inventory( ply, _item, _x, _y )

      send_inventory( ply )
    else
      print("ÄHM")
    end
  else
    print( "ELSE" )
    send_inventory( ply )
  end
end)

util.AddNetworkString( "get_equipment" )

function get_field( field, id )
  print("get_field(" .. field .. ", " .. id .. ")")
  local _result = db_select( "yrp_inventory", "*", "CharID = " .. id .. " AND f_x = '" .. field .. "' AND f_y = '" .. field .. "'" )
  print(_result)
  _result = _result[1]
  return _result
end

function get_equipment( id )
  print("get_equipment(" .. id .. ")")
  local _result = {}

  _result.weaponp1 = get_field( "w1", id )
  _result.weaponp2 = get_field( "w2", id )
  _result.weapons = get_field( "w3", id )
  _result.weaponm = get_field( "w4", id )
  _result.weapong = get_field( "w5", id )

  return _result
end

function send_equipment( ply )
  local _char_id = ply:CharID()
  local _em = get_equipment( _char_id )

  net.Start( "get_equipment" )
    net.WriteTable( _em )
  net.Send( ply )
end

net.Receive( "get_equipment", function( len, ply )
  send_equipment( ply )
end)

hook.Add( "PlayerCanPickupWeapon", "yrp_weapon_pickup", function()
  return false
end)
