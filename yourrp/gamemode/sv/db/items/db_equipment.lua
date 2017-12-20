--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
--[[
sql_add_column( "yrp_equipment", "CharID", "INT DEFAULT 0" )
sql_add_column( "yrp_equipment", "field", "TEXT DEFAULT ''" )
sql_add_column( "yrp_equipment", "ClassName", "TEXT DEFAULT '[EMPTY]'" )
sql_add_column( "yrp_equipment", "PrintName", "TEXT DEFAULT ''" )
sql_add_column( "yrp_equipment", "Model", "TEXT DEFAULT ''" )
sql_add_column( "yrp_equipment", "w", "INT DEFAULT 1" )
sql_add_column( "yrp_equipment", "h", "INT DEFAULT 1" )
sql_add_column( "yrp_equipment", "aw", "TEXT DEFAULT 'x'" )
sql_add_column( "yrp_equipment", "ah", "TEXT DEFAULT 'y'" )
sql_add_column( "yrp_equipment", "awh", "INT DEFAULT 0" )
sql_add_column( "yrp_equipment", "ahh", "INT DEFAULT 0" )

--db_drop_table( "yrp_equipment" )
--db_is_empty( "yrp_equipment" )

util.AddNetworkString( "get_equipment" )

function is_field_empty( id, field )
  local _result = db_select( "yrp_equipment", "*", "CharID = " .. id .. " AND field = '" .. field .. "'" )
  if _result != nil then
    _result = _result[1]
    if _result.ClassName == "[EMPTY]" then
      return true
    else
      return false
    end
  else
    return false
  end
end

function update_field( id, field, item )
  local _item = {}
  _item.ClassName = item:GetClass() or item.ClassName or "NO CLASSNAME"
  _item.PrintName = item:GetPrintName() or item.PrintName or "NO PRINTNAME"
  _item.Model = item:GetModel() or item.Model or "NO MODEL"
  _item.w = item.w or 1
  _item.h = item.h or 1
  _item.aw = item.aw or "x"
  _item.ah = item.ah or "y"
  _item.awh = item.awh or 0
  _item.ahh = item.ahh or 0
  local _db_sets = "ClassName = '" .. _item.ClassName .. "'"
  _db_sets = _db_sets .. ", PrintName = '" .. _item.PrintName .. "'"
  _db_sets = _db_sets .. ", Model = '" .. _item.Model .. "'"
  _db_sets = _db_sets .. ", w = " .. _item.w
  _db_sets = _db_sets .. ", h = " .. _item.h
  _db_sets = _db_sets .. ", aw = '" .. _item.aw .. "'"
  _db_sets = _db_sets .. ", ah = '" .. _item.ah .. "'"
  _db_sets = _db_sets ..", awh = " .. _item.awh
  _db_sets = _db_sets ..", ahh = " .. _item.ahh

  db_update( "yrp_equipment", _db_sets, "CharID = " .. id .. " AND field = '" .. field .. "'" )
end

function is_in_equipment( ply, cname )
  local _char_id = ply:CharID()
  local _result = db_select( "yrp_equipment", "*", "CharID = " .. _char_id .. " AND ClassName = '" .. cname .. "'" )
  if _result == nil then
    return false
  else
    return true
  end
end

function get_field( id, field )
  local _result = db_select( "yrp_equipment", "*", "CharID = " .. id .. " AND field = '" .. field .. "'" )
  if _result == nil then
    db_insert_into( "yrp_equipment", "CharID, field", id .. ", '" .. field .. "'" )
  end
  _result = db_select( "yrp_equipment", "*", "CharID = " .. id .. " AND field = '" .. field .. "'" )
  if _result != nil then
    _result = _result[1]
  end
  return _result
end

function get_equipment( id )
  local _result = {}
  _result.helm = get_field( id, "helm" )
  _result.shoulders = get_field( id, "shoulders" )
  _result.cap = get_field( id, "cap" )
  _result.chest = get_field( id, "chest" )

  _result.gloves = get_field( id, "gloves" )
  _result.belt = get_field( id, "belt" )
  _result.pants = get_field( id, "pants" )
  _result.boots = get_field( id, "boots" )

  _result.backpack = get_field( id, "backpack" )

  _result.weaponp1 = get_field( id, "weaponp1" )
  _result.weaponp2 = get_field( id, "weaponp2" )
  _result.weapons = get_field( id, "weapons" )
  _result.weaponm = get_field( id, "weaponm" )
  _result.weapong = get_field( id, "weapong" )

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

function give_hand( ply, id, field )
  if !is_field_empty( id, field ) then
    local _hand = db_select( "yrp_equipment", "*", "CharID = " .. id .. " AND field = '" .. field .. "'" )
    if _hand != nil then
      _hand = _hand[1]

      print("OLD GIVE " .. _hand.ClassName)
      local _item = ply:EquipItem( _hand.ClassName )
    end
  end
end

function equip_hands( ply )
  local _char_id = ply:CharID()
  give_hand( ply, _char_id, "weaponp1" )
  give_hand( ply, _char_id, "weaponp2" )
  give_hand( ply, _char_id, "weapons" )
  give_hand( ply, _char_id, "weaponm" )
  give_hand( ply, _char_id, "weapong" )
end
]]--
