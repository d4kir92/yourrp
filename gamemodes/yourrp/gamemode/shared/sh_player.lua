--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local Player = FindMetaTable( "Player" )

function Player:GetPlyTab()
  if SERVER then
    if worked( self:SteamID(), "SteamID fail" ) then
      local _yrp_players = dbSelect( "yrp_players", "*", "SteamID = '" .. self:SteamID() .. "'" )
      if worked( _yrp_players, "GetPlyTab fail" ) then
        self.plytab = _yrp_players[1]
      else
        printGM( "note", "GetPlyTab ALL PLAYERS")
        local _all = dbSelect( "yrp_players", "*", nil )
        PrintTable( _all )
      end
    end
  end
  return self.plytab
end

function Player:GetChaTab()
  if SERVER then
    local yrp_players = self:GetPlyTab()
    if worked( yrp_players, "GetPlyTab in GetChaTab" ) then
      local yrp_characters = dbSelect( "yrp_characters", "*", "uniqueID = " .. yrp_players.CurrentCharacter )
      if worked( yrp_characters, "yrp_characters GetChaTab" ) then
        self.chatab = yrp_characters[1]
      end
    end
  end
  return self.chatab
end

function Player:GetRolTab()
  if SERVER then
    local yrp_characters = self:GetChaTab()
    if worked( yrp_characters, "yrp_characters GetRolTab" ) then
      local yrp_roles = dbSelect( "yrp_roles", "*", "uniqueID = " .. yrp_characters.roleID )
      if worked( yrp_roles, "yrp_roles GetRolTab" ) then
        self.roltab = yrp_roles[1]
      end
    end
  end
  return self.roltab
end

function Player:GetGroTab()
  if SERVER then
    local yrp_characters = self:GetChaTab()
    if worked( yrp_characters, "yrp_characters GetGroTab" ) then
      local yrp_groups = dbSelect( "yrp_groups", "*", "uniqueID = " .. yrp_characters.groupID )
      if worked( yrp_groups, "yrp_groups GetGroTab" ) then
        self.grotab = yrp_groups[1]
      end
    end
  end
  return self.grotab
end

function Player:CharID()
  if SERVER then
    local char = self:GetChaTab()
    if worked( char, "char CharID" ) then
      self.charid = char.uniqueID
    end
  end
  if self.charid == nil then
    self.charid = -1
  end
  return self.charid
end

function Player:UpdateMoney()
  if SERVER then
    local money = tonumber( self:GetNWString( "money" ) )
    if worked( money, "money UpdateMoney" ) then
      dbUpdate( "yrp_characters", "money = '" .. money .. "'", "uniqueID = " .. self:CharID() )
    end
    local moneybank = tonumber( self:GetNWString( "moneybank" ) )
    if worked( moneybank, "moneybank UpdateMoney" ) then
      dbUpdate( "yrp_characters", "moneybank = '" .. moneybank .. "'", "uniqueID = " .. self:CharID() )
    end
  end
end

function Player:GetPlayerModel()
  if SERVER then
    local yrp_characters = self:GetChaTab()
    if worked( yrp_characters, "yrp_characters (GetPlayerModel)" ) then
      local pmID = tonumber( yrp_characters.playermodelID )
      local yrp_role = self:GetRolTab()
      local tmp = string.Explode( ",", yrp_role.playermodels )
      local pm = tmp[pmID]

      if pm == "" then
        self.pm = "models/player/skeleton.mdl"
      elseif pm != "" then
        self.pm = pm
      end
    end
  end
  return self.pm
end
