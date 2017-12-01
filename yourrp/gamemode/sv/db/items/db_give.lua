--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local PlayerMeta = FindMetaTable( "Player" )

if PlayerMeta.EquipItem == nil then
  PlayerMeta.EquipItem = PlayerMeta.Give
end

function get_item_size( item )
  local _mins = item:OBBMins()
  local _maxs = item:OBBMaxs()

  local _values = {}
  _values.x = math.Round( math.abs( _mins.x - _maxs.x )/8, 0 )
  _values.y = math.Round( math.abs( _mins.y - _maxs.y )/8, 0 )
  _values.z = math.Round( math.abs( _mins.z - _maxs.z )/8, 0 )

  local _sort = {}
  for axis, value in SortedPairsByValue( _values, true ) do
    local _tbl = {}
    _tbl.axis = axis
    _tbl.value = value
    table.insert( _sort, _tbl )
  end
  --PrintTable( _sort )

  local _center = item:OBBCenter()
  return _sort[1].axis, _sort[1].value, _sort[2].axis, _sort[2].value, math.Round( _center.x, 2 ) .. " " .. math.Round( _center.y, 2 ) .. " " .. math.Round( _center.z, 2 )
end

function PlayerMeta:Give( cname, noammo )
  local _no_ammo = noammo
  if _no_ammo == nil then
    _no_ammo = false
  end

  local _item = self:EquipItem( cname )
  local _aw, _w, _ah, _h, i_center = get_item_size( _item )

  _item.ClassName = _item:GetClass() or _item.ClassName or "NO CLASSNAME"
  _item.PrintName = _item:GetPrintName() or _item.PrintName or "NO PRINTNAME"
  _item.Model = _item:GetModel() or _item.Model or "NO MODEL"
  _item.i_w = _w
  _item.i_h = _h
  _item.i_aw = _aw
  _item.i_ah = _ah
  _item.i_center = i_center or "0 0 0"
  self:StripWeapon( cname )
  print("NEW GIVE " .. tostring( cname ) .. " " .. tostring( _no_ammo ) )

  local _char_id = self:CharID()
  --[[if is_field_empty( _char_id, "weaponp1" ) then
    update_field( _char_id, "weaponp1", _item )
    self:EquipItem( cname, noammo )
    return true
  end
  if is_field_empty( _char_id, "weaponp2" ) then
    update_field( _char_id, "weaponp2", _item )
    self:EquipItem( cname, noammo )
    return true
  end
  if is_field_empty( _char_id, "weapons" ) then
    update_field( _char_id, "weapons", _item )
    self:EquipItem( cname, noammo )
    return true
  end
  if is_field_empty( _char_id, "weaponm" ) then
    update_field( _char_id, "weaponm", _item )
    self:EquipItem( cname, noammo )
    return true
  end
  if is_field_empty( _char_id, "weapong" ) then
    update_field( _char_id, "weapong", _item )
    self:EquipItem( cname, noammo )
    return true
  end
  ]]--

  insert_in_inventory( self, _item )
end
