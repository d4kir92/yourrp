--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local Entity = FindMetaTable( "Entity" )

function Entity:SetWorldStorage( b )
  self:SetNWString( "isaworldstorage", tobool( b ) )
end

local Player = FindMetaTable( "Player" )

if Player.LegacyGive == nil then
  Player.LegacyGive = Player.Give
end

function Player:GetEQ( slot )
  local _slot_uid = SQL_SELECT( "yrp_characters", slot, "uniqueID = '" .. self:CharID() .. "'" )
  if wk( _slot_uid ) then
    _slot_uid = _slot_uid[1][slot]
    local _item = SQL_SELECT( "yrp_items", "*", "storageID = '" .. _slot_uid .. "'" )
    if wk( _item ) then
      _item = _item[1]
      return _item
    end
  end
  return nil
end

function Player:EquipWeapons()
  local _char = SQL_SELECT( "yrp_characters", "*", "uniqueID = '" .. self:CharID() .. "'" )
  if wk( _char ) then
    _char = _char[1]

    local _wpp1 = self:GetEQ( "eqwpp1" )
    if wk( _wpp1 ) then
      self:ForceEquip( _wpp1.ClassName )
    end
    local _wpp2 = self:GetEQ( "eqwpp2" )
    if wk( _wpp2 ) then
      self:ForceEquip( _wpp2.ClassName )
    end
    local _wps1 = self:GetEQ( "eqwps1" )
    if wk( _wps1 ) then
      self:ForceEquip( _wps1.ClassName )
    end
    local _wps2 = self:GetEQ( "eqwps2" )
    if wk( _wps2 ) then
      self:ForceEquip( _wps2.ClassName )
    end
    local _wpg = self:GetEQ( "eqwpg" )
    if wk( _wpg ) then
      self:ForceEquip( _wpg.ClassName )
    end

    self:UpdateBackpack()
  end
end

function Player:EquipWeapon( slot, item )
  local _slot = SQL_SELECT( "yrp_characters", slot, "uniqueID = '" .. self:CharID() .. "'" )
  if wk( _slot ) then
    _slot = _slot[1][slot]
    _slot = SQL_SELECT( "yrp_storages", "*", "uniqueID = '" .. _slot .. "'" )
    if wk( _slot ) then
      _slot = _slot[1]

      if tonumber( item.sizew ) <= tonumber( _slot.sizew ) and tonumber( item.sizeh ) <= tonumber( _slot.sizeh ) then
        local _wp = SQL_SELECT( "yrp_items", "*", "storageID = '" .. _slot.uniqueID .. "'" )

        if !wk( _wp ) then
          item = CreateItem( item, _slot )

          net.Start( "moveitem_slot2" )
            net.WriteTable( _slot )
            net.WriteTable( item )
          net.Send( self )

          self:UpdateBackpack()
          self:ForceEquip( item.ClassName )
          return true
        else
          _wp = _wp[1]
          return false
        end
      end
    end
  end
  return false
end

function Player:PutInWeaponSlot( item )
  printGM( "db", "Player:PutInWeaponSlot( item )" )
  local _wpp1 = self:EquipWeapon( "eqwpp1", item )
  if _wpp1 then
    return true
  end
  local _wpp2 = self:EquipWeapon( "eqwpp2", item )
  if _wpp2 then
    return true
  end
  local _wps1 = self:EquipWeapon( "eqwps1", item )
  if _wps1 then
    return true
  end
  local _wps2 = self:EquipWeapon( "eqwps2", item )
  if _wps2 then
    return true
  end
  local _wpg = self:EquipWeapon( "eqwpg", item )
  if _wpg then
    return true
  end
  return false
end

function Player:PutInBackpack( item )
  printGM( "db", "Player:PutInBackpack( item )" )
  return false
end

function Player:RemoveWeapon( cname )
  for i, swep in pairs( self:GetWeapons() ) do
    if swep:GetClass() == cname then
      swep:Remove()
      return true
    end
  end
  return false
end

function Player:RemoveSwep( cname, slot )
  local _eq = self:GetEQ( slot )
  if _eq != nil then
    if cname == _eq.ClassName then
      local test = SQL_DELETE_FROM( "yrp_items", "uniqueID = '" .. _eq.uniqueID .. "'" )
    end
  end
end

function Player:RemoveVisual( cname )
  local _wpp1 = self:RemoveSwep( cname, "eqwpp1" )
  local _wpp2 = self:RemoveSwep( cname, "eqwpp2" )
  local _wps1 = self:RemoveSwep( cname, "eqwps1" )
  local _wps1 = self:RemoveSwep( cname, "eqwps2" )
  local _wpg = self:RemoveSwep( cname, "eqwpg" )
end

function Player:DropSWEP( cname )
  local _cname = cname

  self:RemoveWeapon( _cname )

  self:RemoveVisual( _cname )

  local ent = ents.Create( _cname )
  ent:SetPos( self:GetPos() + Vector( 0, 0, 56 ) + self:EyeAngles():Forward() * 20  )
  ent:Spawn()

  ent:GetPhysicsObject():SetVelocity( self:EyeAngles():Forward() * 200 )
end

function Player:PutInInventory( cname, noammo )
  printGM( "db", "Player:PutInInventory( " .. cname .. ", " .. tostring( noammo ) .. " )" )
  local ent = ents.Create( cname )
  ent:Spawn()
  --local sizew, sizeh = GetEntityItemSize( ent )
  local item = FormatEntityToItem( ent )
  item.posx = 1
  item.posy = 1
  ent:Remove()

  if item.entity:IsWeapon() then
    local _worked = self:PutInWeaponSlot( item )
    if _worked then
      return true
    end
  end
  local _worked = self:PutInBackpack( item )
  if _worked then
    return true
  end

  self:DropSWEP( item.ClassName )
end

function Player:ForceEquip( cname, noammo )
  printGM( "gm", "ForceEquip( " .. cname .. " )" )
  self.canpickup = true
  return self:LegacyGive( cname, noammo )
end

function Player:Give( cname, noammo )
  printGM( "gm", "Give( " .. cname .. " )" )
  local _noAmmo = noammo
  if _noAmmo == nil then
    _noAmmo = false
  end

  if self:GetNWBool( "toggle_inventory", false ) then
    return self:PutInInventory( cname, noammo )
  else
    return self:LegacyGive( cname, noammo )
  end
end

if Player.LegacyGiveAmmo == nil then
  Player.LegacyGiveAmmo = Player.GiveAmmo
end

function Player:GiveAmmo( amount, atype, hidePopup )
  local _hide_popup = hidePopup
  if _hide_popup == nil then
    _hide_popup = false
  end

  if self:GetNWBool( "toggle_inventory", false ) then
    self:LegacyGiveAmmo( amount, atype )
    --self:AddItemAmmo( amount, atype )
  else
    self:LegacyGiveAmmo( amount, atype )
  end
end

hook.Add( "KeyPress", "yrp_keypress_use", function( ply, key )
  if ( key == IN_USE ) then
    local plytr = ply:GetEyeTrace()
    if plytr.Hit then
      if IsValid( plytr.Entity ) then
        if plytr.Entity:IsWeapon() and ply:GetPos():Distance( plytr.Entity:GetPos() ) < 80 then
          ply:Give( plytr.Entity:GetClass() )
          plytr.Entity:Remove()
        end
      end
    end
  end
end )

if Player.LegacyStripWeapon == nil then
  Player.LegacyStripWeapon = Player.StripWeapon
end

function Player:StripWeapon( cname )
  local _char_id = self:CharID()

  if self:GetNWBool( "toggle_inventory", false ) then

  end
  self:LegacyStripWeapon( cname )
end

if Player.LegacyStripWeapons == nil then
  Player.LegacyStripWeapons = Player.StripWeapons
end

function Player:StripWeapons()
  local _char_id = self:CharID()

  if self:GetNWBool( "toggle_inventory", false ) then

  end
  self:LegacyStripWeapons()
end

function GM:PlayerCanPickupWeapon( ply, wep )
  if !ply:GetNWBool( "toggle_inventory", false ) then
    --[[ Inventory OFF ]]--
    return true
  else
    --[[ Inventory ON ]]--
    if ply.canpickup == true then
      ply.canpickup = false
      return true
    else
      return false
    end
  end
  return true
end
hook.Remove( "PlayerCanPickupWeapon", "yrp_remove_pickup_hook" )

util.AddNetworkString( "drop_item" )
net.Receive( "drop_item", function( len, ply )
  local _weapon = ply:GetActiveWeapon()
  if _weapon != NULL and _weapon != nil and _weapon.notdropable == nil then
    local _wclass = _weapon:GetClass() or ""
    ply:DropSWEP( _wclass )
    ply:StripWeapon( _wclass )
  end
end)

util.AddNetworkString( "dropswep" )
net.Receive( "dropswep", function( len, ply )
  local _enabled = PlayersCanDropWeapons()
  if _enabled then
    local _weapon = ply:GetActiveWeapon()
    if _weapon != NULL and _weapon != nil and _weapon.notdropable == nil then
      local _wclass = _weapon:GetClass() or ""
      ply:DropSWEP( _wclass )
      _weapon:SetOwner( NULL )
    end
  else
    printGM( "note", ply:YRPName() .. " PlayersCanDropWeapons == FALSE" )
  end
  net.Start( "dropswep" )
    net.WriteBool( _enabled )
  net.Send( ply )
end)
