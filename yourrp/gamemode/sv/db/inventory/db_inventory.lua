--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_characters.lua

local _db_name = "yrp_inventory"

sql_add_column( _db_name, "CharID", "INT DEFAULT 0" )
sql_add_column( _db_name, "f_x", "INT DEFAULT 0" )
sql_add_column( _db_name, "f_y", "INT DEFAULT 0" )
sql_add_column( _db_name, "i_w", "INT DEFAULT 0" )
sql_add_column( _db_name, "i_h", "INT DEFAULT 0" )
sql_add_column( _db_name, "i_x", "INT DEFAULT 0" )
sql_add_column( _db_name, "i_y", "INT DEFAULT 0" )
sql_add_column( _db_name, "ClassName", "TEXT DEFAULT '[EMPTY]'" )
sql_add_column( _db_name, "PrintName", "TEXT DEFAULT ''" )

--db_drop_table( _db_name )
db_is_empty( _db_name )

util.AddNetworkString( "get_inventory" )

function get_inventory( id )
  local _result = {}
  for x = 1, 8 do
    _result["f_x"..x] = {}
    for y = 1, 8 do
      _result["f_x"..x]["f_y"..y] = db_select( "yrp_inventory", "*", "f_x = " .. x .. " AND f_y = " .. y )
      if _result["f_x"..x]["f_y"..y] == nil then
        return nil
      else
        if _result["f_x"..x]["f_y"..y][1] != nil then
          _result["f_x"..x]["f_y"..y] = _result["f_x"..x]["f_y"..y][1]
        end
      end
    end
  end
  return _result
end

function send_inventory( ply )
  local _char_id = ply:CharID()
  local _inv = get_inventory( _char_id )
  if _inv == nil then
    print("KEIN INVENTAR VORHANDEN")
    for x = 1, 8 do
      for y = 1, 8 do
        db_insert_into( "yrp_inventory", "CharID, f_x, f_y", _char_id .. ", " .. x .. ", " .. y )
      end
    end
    _inv = get_inventory( _char_id )
  end

  net.Start( "get_inventory" )
    net.WriteTable( _inv )
  net.Send( ply )
end

net.Receive( "get_inventory", function( len, ply )
  --send_inventory( ply )
end)

function find_free_space( ply )
  local _char_id = ply:CharID()
  for y=1, 8 do
    for x=1, 8 do
      _pl = db_select( "yrp_inventory", "*", "CharID = " .. _char_id .. " AND ClassName = '" .. "[EMPTY]" .. "' AND f_x = " .. x .. " AND f_y = " .. y )
      if _pl != nil then
        return x, y
      end
    end
  end
  return false
end

function insert_in_inventory( ply, item )
  local _item = {}
  _item.ClassName = item:GetClass() or item.ClassName or "NO CLASSNAME"
  _item.PrintName = item:GetPrintName() or item.PrintName or "NO PRINTNAME"
  local _x, _y = find_free_space( ply )
  if _x != false then
    db_update( "yrp_inventory", "i_x = 1, i_y = 1, ClassName = '" .. _item.ClassName .. "', PrintName = '" .. _item.PrintName .. "'", "CharID = "..ply:CharID() .. " AND f_x = " .. _x .. " AND f_y = " .. _y )
    local _result = db_select( "yrp_inventory", "*", "CharID = " .. ply:CharID() .. " AND f_x = " .. 1 .. " AND f_y = " .. 1 )
  end

  --send_inventory( ply )
end

--[[
hook.Add( "PlayerCanPickupWeapon", "noDoublePickup", function( ply, wep )
  insert_in_inventory( ply, wep )
	return false
end )
]]--
