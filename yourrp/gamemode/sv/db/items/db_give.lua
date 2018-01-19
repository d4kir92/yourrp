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
    self:AddSwep( cname )
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

if Player.old_stripweapon == nil then
  Player.old_stripweapon = Player.StripWeapon
end

function Player:StripWeapon( cname )
  local _char_id = self:CharID()

  if self:GetNWBool( "toggle_inventory", false ) then
    local _items = db_select( "yrp_inventory", "*", "CharID = " .. _char_id )
    if _items != nil then
      for k, item in pairs( _items ) do
        local _id = string.sub( item.item, 3 )
        local _res = db_select( "yrp_item", "*", "uniqueID = " .. _id )
        if _res != false and _res != nil then
          _res = _res[1]
          if _res.ClassName == cname then
            self:RemoveItemFromIventory( _id )
          end
        end
      end
    end
  end
  self:old_stripweapon( cname )
end

if Player.old_stripweapons == nil then
  Player.old_stripweapons = Player.StripWeapons
end

function Player:StripWeapons()
  local _char_id = self:CharID()

  if self:GetNWBool( "toggle_inventory", false ) then
    local _items = db_select( "yrp_inventory", "*", "CharID = " .. _char_id )
    if _items != nil then
      for k, item in pairs( _items ) do
        local _id = string.sub( item.item, 3 )
        local _res = db_select( "yrp_item", "*", "uniqueID = " .. _id )
        if _res != false and _res != nil then
          _res = _res[1]
          self:RemoveItemFromIventory( _id )
        end
      end
    end
  end
  self:old_stripweapons()
end

util.AddNetworkString( "drop_item" )

net.Receive( "drop_item", function( len, ply )
  local _weapon = ply:GetActiveWeapon()
  if _weapon != NULL and _weapon != nil and _weapon:GetModel() != "" then
    local _wclass = _weapon:GetClass() or ""
    ply:DropItem( _wclass )
    ply:StripWeapon( _wclass )
  end
end)
