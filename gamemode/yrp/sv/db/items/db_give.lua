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

function Player:ForceGive( cname, noammo )
  printGM( "gm", "ForceGive( " .. cname .. " )" )
  self.canpickup = true
  return self:Give( cname, noammo )
end

function Player:Give( cname, noammo )
  printGM( "gm", "Give( " .. cname .. " )" )
  local _noAmmo = noammo
  if _noAmmo == nil then
    _noAmmo = false
  end

  if self:GetNWBool( "toggle_inventory", false ) then
    self.canpickup = true
    return self:LegacyGive( cname, noammo )
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
    ply:DropItem( _wclass )
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
      ply:DropWeapon( _weapon )
      _weapon:SetOwner( NULL )
    end
  else
    printGM( "note", ply:YRPName() .. " PlayersCanDropWeapons == FALSE" )
  end
  net.Start( "dropswep" )
    net.WriteBool( _enabled )
  net.Send( ply )
end)
