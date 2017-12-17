--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local PlayerMeta = FindMetaTable( "Player" )

if PlayerMeta.old_give == nil then
  PlayerMeta.old_give = PlayerMeta.Give
end

function PlayerMeta:Give( cname, noammo )
  local _no_ammo = noammo
  if _no_ammo == nil then
    _no_ammo = false
  end

  if self:GetNWBool( "toggle_inventory", false ) then
    self:AddItem( cname )
  else
    self:old_give( cname, noammo )
  end
end

if PlayerMeta.old_give_ammo == nil then
  PlayerMeta.old_give_ammo = PlayerMeta.GiveAmmo
end

function PlayerMeta:GiveAmmo( amount, atype, hidePopup )
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
