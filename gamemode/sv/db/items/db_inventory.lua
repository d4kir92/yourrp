--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local INV_W = 8
local INV_H = 8

sql_add_column( "yrp_inventory", "CharID", "INT DEFAULT 0" )
sql_add_column( "yrp_inventory", "field", "TEXT DEFAULT ''" )
sql_add_column( "yrp_inventory", "item", "TEXT DEFAULT '-1'" )

--db_drop_table( "yrp_inventory" )
--db_is_empty( "yrp_inventory" )

local Player = FindMetaTable( "Player" )

function Player:GetInventory()
  local _char_id = self:CharID()
  local _inv = {}
  for y = 1, INV_H do
    _inv["y"..y] = {}
    for x = 1, INV_W do
      _inv["y"..y]["x"..x] = db_select( "yrp_inventory", "*", "CharID = " .. _char_id .. " AND field = '" .. x .. "," .. y .. "'" )
      if _inv["y"..y]["x"..x] != nil then
        _inv["y"..y]["x"..x] = _inv["y"..y]["x"..x][1]
      end
    end
  end

  --[[
  print("")
  print("PrintInventory")
  print("\tx1\tx2\tx3\tx4\tx5\tx6\tx7\tx8")
  for y = 1, INV_H do
    local _y_line = "y" .. y .. "\t"
    for x = 1, INV_W do
      if _inv["y"..y]["x"..x] != nil then
        _y_line = _y_line .. tostring(_inv["y"..y]["x"..x].item) .. "\t"
      end
    end
    print(_y_line)
  end
  print("")
  ]]--


  for y = 1, INV_H do
    for x = 1, INV_W do
      if _inv["y"..y]["x"..x] != nil then
        if _inv["y"..y]["x"..x].item != "-1" then
          if string.find( _inv["y"..y]["x"..x].item, "i," ) then
            local _item_uid = string.Explode( ",", _inv["y"..y]["x"..x].item )
            _item_uid = _item_uid[2]

            _inv["y"..y]["x"..x].item = db_select( "yrp_item", "*", "uniqueID = " .. _item_uid )
            if _inv["y"..y]["x"..x].item != nil then
              _inv["y"..y]["x"..x].item = _inv["y"..y]["x"..x].item[1]
            end
          end
        end
      end
    end
  end

  --[[ EQ Items ]] --
  _inv["w1"] = db_select( "yrp_inventory", "*", "CharID = " .. _char_id .. " AND field = 'w1'" )
  if _inv["w1"] != nil then
    _inv["w1"] = _inv["w1"][1]
    if _inv["w1"].item != "-1" then
      local _item_uid = string.Explode( ",", _inv["w1"].item )
      _item_uid = _item_uid[2]

      _inv["w1"].item = db_select( "yrp_item", "*", "uniqueID = " .. _item_uid )
      if _inv["w1"].item != nil then
        _inv["w1"].item = _inv["w1"].item[1]
      end
    end
  end

  _inv["w2"] = db_select( "yrp_inventory", "*", "CharID = " .. _char_id .. " AND field = 'w2'" )
  if _inv["w2"] != nil then
    _inv["w2"] = _inv["w2"][1]
    if _inv["w2"].item != "-1" then
      local _item_uid = string.Explode( ",", _inv["w2"].item )
      _item_uid = _item_uid[2]

      _inv["w2"].item = db_select( "yrp_item", "*", "uniqueID = " .. _item_uid )
      if _inv["w2"].item != nil then
        _inv["w2"].item = _inv["w2"].item[1]
      end
    end
  end

  _inv["w3"] = db_select( "yrp_inventory", "*", "CharID = " .. _char_id .. " AND field = 'w3'" )
  if _inv["w3"] != nil then
    _inv["w3"] = _inv["w3"][1]
    if _inv["w3"].item != "-1" then
      local _item_uid = string.Explode( ",", _inv["w3"].item )
      _item_uid = _item_uid[2]

      _inv["w3"].item = db_select( "yrp_item", "*", "uniqueID = " .. _item_uid )
      if _inv["w3"].item != nil then
        _inv["w3"].item = _inv["w3"].item[1]
      end
    end
  end

  _inv["w4"] = db_select( "yrp_inventory", "*", "CharID = " .. _char_id .. " AND field = 'w4'" )
  if _inv["w4"] != nil then
    _inv["w4"] = _inv["w4"][1]
    if _inv["w4"].item != "-1" then
      local _item_uid = string.Explode( ",", _inv["w4"].item )
      _item_uid = _item_uid[2]

      _inv["w4"].item = db_select( "yrp_item", "*", "uniqueID = " .. _item_uid )
      if _inv["w4"].item != nil then
        _inv["w4"].item = _inv["w4"].item[1]
      end
    end
  end

  _inv["w5"] = db_select( "yrp_inventory", "*", "CharID = " .. _char_id .. " AND field = 'w5'" )
  if _inv["w5"] != nil then
    _inv["w5"] = _inv["w5"][1]
    if _inv["w5"].item != "-1" then
      local _item_uid = string.Explode( ",", _inv["w5"].item )
      _item_uid = _item_uid[2]

      _inv["w5"].item = db_select( "yrp_item", "*", "uniqueID = " .. _item_uid )
      if _inv["w5"].item != nil then
        _inv["w5"].item = _inv["w5"].item[1]
      end
    end
  end

  return _inv
end

function Player:CheckInventory()
  local _char_id = self:CharID()

  if _char_id != nil then

    --[[ Create Inventory ]]--
    for y = 1, INV_H do
      for x = 1, INV_W do
        local _sel = db_select( "yrp_inventory", "*", "CharID = " .. _char_id .. " AND field = '" .. x .."," .. y .. "'" )
        if _sel == nil then
          local _res = db_insert_into( "yrp_inventory", "CharID, field", _char_id .. ", '" .. x .."," .. y .. "'" )
          if _res != nil then
            printGM( "note", "CreateInventory failed" )
          end
        end
      end
    end

    --[[ EQ ]]--
    if db_select( "yrp_inventory", "*", "CharID = " .. _char_id .. " AND field = 'w1'" ) == nil then
      local _res = db_insert_into( "yrp_inventory", "CharID, field", _char_id .. ", 'w1'" )
    end
    if db_select( "yrp_inventory", "*", "CharID = " .. _char_id .. " AND field = 'w2'" ) == nil then
      local _res = db_insert_into( "yrp_inventory", "CharID, field", _char_id .. ", 'w2'" )
    end
    if db_select( "yrp_inventory", "*", "CharID = " .. _char_id .. " AND field = 'w3'" ) == nil then
      local _res = db_insert_into( "yrp_inventory", "CharID, field", _char_id .. ", 'w3'" )
    end
    if db_select( "yrp_inventory", "*", "CharID = " .. _char_id .. " AND field = 'w4'" ) == nil then
      local _res = db_insert_into( "yrp_inventory", "CharID, field", _char_id .. ", 'w4'" )
    end
    if db_select( "yrp_inventory", "*", "CharID = " .. _char_id .. " AND field = 'w5'" ) == nil then
      local _res = db_insert_into( "yrp_inventory", "CharID, field", _char_id .. ", 'w5'" )
    end

    local _result = db_select( "yrp_inventory", "*", "CharID = " .. _char_id )
    if _result != nil then

      self:GetInventory()
    end
  end
end

function Player:HasItem( cname )
  if self:GetNWBool( "toggle_inventory", false ) then
    local _char_id = self:CharID()
    local _inv = db_select( "yrp_inventory", "*", "CharID = " .. _char_id )
    for k, item in pairs( _inv ) do
      local _item = string.sub( item.item, 3 )
      local _res = db_select( "yrp_item", "*", "uniqueID = " .. _item .. " AND ClassName = '" .. db_sql_str( cname ) .. "'" )
      if _res != nil and _res != false then
        _res = _res[1]
      end
      if istable( _res ) then
        return true
      end
    end
    return false
  else
    return self:HasWeapon( cname )
  end
end

function Player:AddSwep( cname )
  if self:GetNWBool( "toggle_inventory", false ) then
    local _eq = self:EnoughSpaceInEQ()
    if _eq != nil and _eq != false then
      self:EquipItem( cname, _eq.field )
    else
      self:AddItem( cname )
    end
  else
    self:old_give( cname )
  end
end

function Player:UseSweps()
  local _char_id = self:CharID()
  if _char_id != nil then
    for i = 1, 5 do
      local _res = db_select( "yrp_inventory", "*", "CharID = " .. _char_id .. " AND field = 'w" .. i .. "'" )
      if _res != nil and _res != false then
        _res = _res[1]
        local _uid = string.sub( _res.item, 3 )

        local _swep = db_select( "yrp_item", "*", "uniqueID = " .. _uid )
        if _swep != nil and _swep != false then
          _swep = _swep[1]
          self.canpickup = true
          _swep = self:old_give( _swep.ClassName, true )
          self.canpickup = false
        end
      end
    end
  end
end

function Player:EnoughSpaceInEQ()
  local _char_id = self:CharID()
  local _eq = {}
  for i = 1, 5 do
    _eq[i] = db_select( "yrp_inventory", "*", "CharID = " .. _char_id .. " AND field = '" .. "w" .. i .. "'" )
    if _eq[i] != nil then
      _eq[i] = _eq[i][1]
    end
  end

  for k, eq in pairs( _eq ) do
    if tostring( eq.item ) == "-1" then
      return eq
    end
  end
  return false
end

function Player:EnoughSpaceInField( _x, _y, w, h )
  local _char_id = self:CharID()

  for y = _y, _y+h-1 do
    for x = _x, _x+w-1 do
      local _select = db_select( "yrp_inventory", "*", "CharID = " .. _char_id .. " AND field = '" .. x .. "," .. y .. "' AND item = '-1'" )
      if _select == nil or _select == false then
        return false
      end
    end
  end
  return true
end

function Player:FindFreeSpaceInInventory( item, posx, posy )
  local _char_id = self:CharID()

  local _x = posx or 1
  local _y = posy or 1

  for y = _y, INV_H do
    for x = _x, INV_W do
      local _select = db_select( "yrp_inventory", "*", "CharID = " .. _char_id .. " AND field = '" .. x .. "," .. y .. "' AND item = '-1'" )
      if _select != nil then
        _select = _select[1]
        local _field_zone = self:EnoughSpaceInField( x, y, item.w, item.h )
        if _field_zone then
          return x, y
        end
      end
    end
  end

  return false
end

function Player:GetItem( uid )
  return get_item( uid )
end

function Player:DropItem( cname )
  local _ent = ents.Create( cname )
  if _ent != nil then
    _ent:SetPos( self:GetPos())
    self.canpickup = false

    local _pos = _ent:GetPos()
    local _angle = Angle( 0, 0, 0 )

    if enough_space( _ent, _pos + Vector( 0, 0, 2 ) ) then
      local __pos = get_ground_pos( _ent, _pos + Vector( 0, 0, 2 ) )
      _ent:SetPos( __pos )
      _ent:Spawn()
    else
      for i = 1, 3 do
        for j = 0, 360, 45 do
          _angle:RotateAroundAxis( _ent:GetForward(), 45 )
          local _enough_space = enough_space( _ent, _pos + Vector( 0, 0, 2 ) + _angle:Forward() * 44 * i )
          if _enough_space then
            local __pos = get_ground_pos( _ent, _pos + Vector( 0, 0, 2 ) + _angle:Forward() * 44 * i )
            _ent:SetPos( __pos )
            _ent:Spawn()
            return
          end
        end
      end
    end
  end
end

function Player:FindFreeSpaceInEquipment()
  local _char_id = self:CharID()
  local _w1 = db_select( "yrp_inventory", "*", "field = 'w1' AND CharID = " .. _char_id )
  if _w1[1] != nil then
    _w1 = _w1[1]
    if _w1.item == "-1" then
      return "w1"
    end
  elseif _w1 == false then
    return "w1"
  end
  local _w2 = db_select( "yrp_inventory", "*", "field = 'w2' AND CharID = " .. _char_id )
  if _w2[1] != nil then
    _w2 = _w2[1]
    if _w2.item == "-1" then
      return "w2"
    end
  elseif _w2 == false then
    return "w2"
  end
  local _w3 = db_select( "yrp_inventory", "*", "field = 'w3' AND CharID = " .. _char_id )
  if _w3[1] != nil then
    _w3 = _w3[1]
    if _w3.item == "-1" then
      return "w3"
    end
  elseif _w3 == false then
    return "w3"
  end
  local _w4 = db_select( "yrp_inventory", "*", "field = 'w4' AND CharID = " .. _char_id )
  if _w4[1] != nil then
    _w4 = _w4[1]
    if _w4.item == "-1" then
      return "w4"
    end
  elseif _w4 == false then
    return "w4"
  end
  local _w5 = db_select( "yrp_inventory", "*", "field = 'w5' AND CharID = " .. _char_id )
  if _w5[1] != nil then
    _w5 = _w5[1]
    if _w5.item == "-1" then
      return "w5"
    end
  elseif _w5 == false then
    return "w5"
  end

  return false
end

function Player:AddItem( cname, posx, posy, origin, move_item )
  local _item = create_item( cname, origin )
  local _x = posx
  local _y = posy
  local _field = self:FindFreeSpaceInEquipment()
  if _field != false and move_item != true then
    self:EquipItem( cname, _field )
  else
    if _x == nil and _y == nil then
      _x, _y = self:FindFreeSpaceInInventory( _item )
    else
      _x, _y = self:FindFreeSpaceInInventory( _item, _x, _y )
    end
    if _x != false then
      --[[ Item starting ]]--
      local _sets = "item = 'i," .. _item.uniqueID .. "'"
      local _whil = "CharID = " .. self:CharID() .. " AND field = '" .. _x .. "," .. _y .. "'"
      local _res = db_update( "yrp_inventory", _sets, _whil )

      --[[ Item Linking ]]--
      for y = _y, _y+_item.h-1 do
        for x = _x, _x+_item.w-1 do
          if x != _x or y !=_y then
            _sets = "item = 'l," .. _item.uniqueID .. "'"
            _whil = "CharID = " .. self:CharID() .. " AND field = '" .. x .. "," .. y .. "'"
            _res = db_update( "yrp_inventory", _sets, _whil )
          end
        end
      end
    else
      self:DropItem( cname )
    end
  end
end

function Player:GetNearbyItems()
  local _ents = ents.GetAll()
  local _env = {}
  for k, ent in pairs( _ents ) do
    if ent:GetPos():Distance( self:GetPos() ) < 60 and ent:GetClass() != "[NULL ENTITY]" and ent:IsWeapon() and ent:GetOwner() == NULL then
      if ent:GetNWString( "yrp_uid", "hasnouid" ) == "hasnouid" then
        local _item = create_item( ent:GetClass(), "nearby" )
        ent:SetNWString( "yrp_uid",  _item.uniqueID )
        table.insert( _env, _item )
      elseif ent:GetNWString( "yrp_uid", "hasnouid" ) != "hasnouid" then
        local _item = get_item( ent:GetNWString( "yrp_uid" ) )
        table.insert( _env, _item )
      end
    end
  end
  return _env
end

util.AddNetworkString( "get_inventory" )

function Player:SendInventory()
  local _tbl = {}
  _tbl.env = self:GetNearbyItems()
  _tbl.inv = self:GetInventory()

  net.Start( "get_inventory" )
    net.WriteTable( _tbl )
  net.Send( self )
end

net.Receive( "get_inventory", function( len, ply )
  if ply:GetNWBool( "toggle_inventory", false ) then
    ply:SendInventory()
  end
end)

util.AddNetworkString( "item_move" )

function Player:RemoveItemFromIventory( uid )
  local _item = db_update( "yrp_inventory", "item = '-1'", "CharID = " .. self:CharID() .. " AND item = 'i," .. uid .. "'" )
  local _item_links = db_update( "yrp_inventory", "item = '-1'", "CharID = " .. self:CharID() .. " AND item = 'l," .. uid .. "'" )
end

function Player:MoveItem( uid, x, y, origin )
  --[[ Remove item from inventory ]]--
  self:RemoveItemFromIventory( uid )

  --[[ get item from database ]]--
  local _item = db_select( "yrp_item", "*", "uniqueID = " .. uid )
  if _item != nil then
    _item = _item[1]

    --[[ Add item from database into inventory ]]--
    self:AddItem( _item.ClassName, x, y, origin, true )
  else
    printGM( "note", "item " .. uid .. " is not in database." )
  end
end

net.Receive( "item_move", function( len, ply )
  local _x = net.ReadString()
  local _y = net.ReadString()
  local _uid = net.ReadString()
  local _new_origin = net.ReadString()

  local _item = ply:GetItem( _uid )
  if _item.origin == "nearby" then
    local _ents = ents.GetAll()
    for k, ent in pairs( _ents ) do
      if _uid == ent:GetNWString( "yrp_uid" ) then
        ent:Remove()
        break
      end
    end
  elseif _item.origin == "eq" then
    ply:StripWeapon( _item.ClassName )
  elseif _item.origin == "inv" then

  end

  --[[ NEW ORIGIN ]]--
  if _new_origin == "eq" then
    ply:RemoveItemFromIventory( _uid )
    local _item = db_select( "yrp_item", "*", "uniqueID = " .. _uid )
    if _item != nil then
      _item = _item[1]
      ply:EquipItem( _item.ClassName, _x )
    end
  elseif _new_origin == "inv" then
    ply:MoveItem( _uid, _x, _y, _new_origin )
  else
    ply:RemoveItemFromIventory( _uid )
    ply:DropItem( _item.ClassName )
  end

  timer.Simple( 0.04, function()
    ply:SendInventory()
  end)
end)

function Player:EquipItem( cname, field )
  local _item = create_item( cname, "eq" )

  local _sets = "item = 'i," .. _item.uniqueID .. "'"
  local _whil = "CharID = " .. self:CharID() .. " AND field = '" .. field .. "'"
  local _res = db_update( "yrp_inventory", _sets, _whil )

  local _swep = {}
  _swep.in_inv = true

  self.canpickup = true
  _swep = self:old_give( cname, true )
  self.canpickup = false
end

function GM:PlayerCanPickupWeapon( ply, wep )
  if ply:GetNWBool( "toggle_inventory", false ) == false then
    return true
  elseif ply.canpickup == true then
    ply.canpickup = false
    return true
  else
    return false
  end
end
hook.Remove( "PlayerCanPickupWeapon", "yrp_remove_pickup_hook" )
