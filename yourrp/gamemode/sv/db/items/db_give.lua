--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local Player = FindMetaTable( "Player" )

if Player.old_give == nil then
  Player.old_give = Player.Give
end

function Player:Give( cname, noammo )
  local _no_ammo = noammo
  if _no_ammo == nil then
    _no_ammo = false
  end

  if self:GetNWBool( "toggle_inventory", false ) then
    self:AddItem( cname )
  else
    return self:old_give( cname, noammo )
  end
end

if Player.old_give_ammo == nil then
  Player.old_give_ammo = Player.GiveAmmo
end

function Player:GiveAmmo( amount, atype, hidePopup )
  local _hide_popup = hidePopup
  if _hide_popup == nil then
    _hide_popup = false
  end

  if self:GetNWBool( "toggle_inventory", false ) then
    self:old_give_ammo( amount, atype )
    --self:AddItemAmmo( amount, atype )
  else
    self:old_give_ammo( amount, atype )
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
