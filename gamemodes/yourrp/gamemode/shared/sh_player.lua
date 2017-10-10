--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local Player = FindMetaTable( "Player" )

function Player:GetPlyTab()
  if SERVER then
    if worked( self:SteamID(), "SteamID fail" ) then
      local _yrp_players = dbSelect( "yrp_players", "*", "SteamID = '" .. self:SteamID() .. "'" )
      if worked( _yrp_players, "GetPlyTab fail" ) then
        self.plytab = _yrp_players[1]
        return self.plytab
      else
        printGM( "note", "GetPlyTab ALL PLAYERS")
        local _all = dbSelect( "yrp_players", "*", nil )
        if _all != nil then
          PrintTable( _all )
        end
      end
    end
  end
  return {}
end

function Player:GetChaTab()
  if SERVER then
    local _tmp = self:GetPlyTab()
    if worked( _tmp, "GetPlyTab in GetChaTab" ) then
      if worked( _tmp.CurrentCharacter, "_tmp.CurrentCharacter in GetChaTab" ) then
        local yrp_characters = dbSelect( "yrp_characters", "*", "uniqueID = " .. _tmp.CurrentCharacter )
        if worked( yrp_characters, "yrp_characters GetChaTab" ) then
          self.chatab = yrp_characters[1]
          return self.chatab
        else
          printGM( "note", "GetChaTab ALL Characters")
          local _all = dbSelect( "yrp_characters", "*", nil )
          if _all != nil then
            PrintTable( _all )
          end
        end
      end
    end
  end
  return {}
end

function Player:GetRolTab()
  if SERVER then
    local yrp_characters = self:GetChaTab()
    if worked( yrp_characters, "yrp_characters in GetRolTab" ) then
      if worked( yrp_characters.roleID, "yrp_characters.roleID in GetRolTab" ) then
        local yrp_roles = dbSelect( "yrp_roles", "*", "uniqueID = " .. yrp_characters.roleID )
        if worked( yrp_roles, "yrp_roles GetRolTab" ) then
          self.roltab = yrp_roles[1]
          return self.roltab
        else
          printGM( "note", "GetRolTab ALL Roles")
          local _all = dbSelect( "yrp_roles", "*", nil )
          if _all != nil then
            PrintTable( _all )
          end
        end
      end
    end
  end
  return {}
end

function Player:GetGroTab()
  if SERVER then
    local yrp_characters = self:GetChaTab()
    if worked( yrp_characters, "yrp_characters in GetGroTab" ) then
      if worked( yrp_characters.groupID, "yrp_characters.groupID in GetGroTab" ) then
        local yrp_groups = dbSelect( "yrp_groups", "*", "uniqueID = " .. yrp_characters.groupID )
        if worked( yrp_groups, "yrp_groups GetGroTab" ) then
          self.grotab = yrp_groups[1]
          return self.grotab
        else
          printGM( "note", "GetGroTab ALL Groups")
          local _all = dbSelect( "yrp_groups", "*", nil )
          if _all != nil then
            PrintTable( _all )
          end
        end
      end
    end
  end
  return {}
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

function Player:CheckMoney()
  if SERVER then
    timer.Simple( 4, function()
      local _m = self:GetNWString( "money", 0 )
      local money = tonumber( _m )
      if worked( money, "ply:money CheckMoney" ) then
        dbUpdate( "yrp_characters", "money = '" .. money .. "'", "uniqueID = " .. self:CharID() )
      end
      _mb = self:GetNWString( "moneybank", 0 )
      local moneybank = tonumber( _mb )
      if worked( moneybank, "ply:moneybank CheckMoney" ) then
        dbUpdate( "yrp_characters", "moneybank = '" .. moneybank .. "'", "uniqueID = " .. self:CharID() )
      end
    end)
  end
end

function Player:UpdateMoney()
  if SERVER then
    local money = tonumber( self:GetNWString( "money", 0 ) )
    if worked( money, "ply:money UpdateMoney" ) then
      dbUpdate( "yrp_characters", "money = '" .. money .. "'", "uniqueID = " .. self:CharID() )
    end
    local moneybank = tonumber( self:GetNWString( "moneybank", 0 ) )
    if worked( moneybank, "ply:moneybank UpdateMoney" ) then
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
      return self.pm
    end
  end
  return {}
end

if SERVER then
  function Player:updateMoney( money )
    self:UpdateMoney()
  end

  function Player:updateMoneyBank( money )
    self:UpdateMoney()
  end

  function Player:addMoney( money )
    if isnumber( money ) then
      self:SetNWString( "money", tonumber( self:GetNWString( "money" ) ) + math.Round( money, 2 ) )
      self:UpdateMoney()
    end
  end

  function Player:SetMoney( money )
    if isnumber( money ) then
      self:SetNWString( "money", math.Round( money, 2 ) )
      self:UpdateMoney()
    end
  end

  function Player:addMoneyBank( money )
    if isnumber( money ) then
      self:SetNWString( "moneybank", tonumber( self:GetNWString( "moneybank" ) ) + math.Round( money, 2 ) )
      self:UpdateMoney()
    end
  end
end

function Player:canAfford( money )
  local _tmpMoney = tonumber( money )
  if isnumber( _tmpMoney ) then
    if tonumber( self:GetNWString( "money" ) ) >= math.abs( _tmpMoney ) then
      return true
    else
      return false
    end
  else
    return false
  end
end

function Player:canAffordBank( money )
  local _tmpMoney = tonumber( money )
  if isnumber( _tmpMoney ) then
    if tonumber( self:GetNWString( "moneybank" ) ) >= math.abs( _tmpMoney ) then
      return true
    else
      return false
    end
  end
end
