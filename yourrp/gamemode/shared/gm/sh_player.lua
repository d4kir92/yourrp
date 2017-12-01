--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local Player = FindMetaTable( "Player" )

function Player:GetPlyTab()
  if SERVER then
    if worked( self:SteamID(), "SteamID fail", true ) then
      local yrp_players = db_select( "yrp_players", "*", "SteamID = '" .. self:SteamID() .. "'" )
      if worked( yrp_players, "GetPlyTab fail", true ) then
        self.plytab = yrp_players[1]
        return self.plytab
      end
    end
  end
  if self.plytab != nil then
    return self.plytab
  else
    return nil
  end
end

function Player:GetChaTab()
  if SERVER then
    local _tmp = self:GetPlyTab()
    if worked( _tmp, "GetPlyTab in GetChaTab", true ) then
      if worked( _tmp.CurrentCharacter, "_tmp.CurrentCharacter in GetChaTab", true ) then
        local yrp_characters = db_select( "yrp_characters", "*", "uniqueID = " .. _tmp.CurrentCharacter )
        if worked( yrp_characters, "yrp_characters GetChaTab", true ) then
          self.chatab = yrp_characters[1]
          return self.chatab
        end
      end
    end
  end
  if self.chatab != nil then
    return self.chatab
  else
    return nil
  end
end

function Player:GetRolTab()
  if SERVER then
    local yrp_characters = self:GetChaTab()
    if worked( yrp_characters, "yrp_characters in GetRolTab", true ) then
      if worked( yrp_characters.roleID, "yrp_characters.roleID in GetRolTab", true ) then
        local yrp_roles = db_select( "yrp_roles", "*", "uniqueID = " .. yrp_characters.roleID )
        if worked( yrp_roles, "yrp_roles GetRolTab", true ) then
          self.roltab = yrp_roles[1]
          return self.roltab
        end
      end
    end
  end
  if self.roltab != nil then
    return self.roltab
  else
    return nil
  end
end

function Player:GetGroTab()
  if SERVER then
    local yrp_characters = self:GetChaTab()
    if worked( yrp_characters, "yrp_characters in GetGroTab", true ) then
      if worked( yrp_characters.groupID, "yrp_characters.groupID in GetGroTab", true ) then
        local yrp_groups = db_select( "yrp_groups", "*", "uniqueID = " .. yrp_characters.groupID )
        if worked( yrp_groups, "yrp_groups GetGroTab", true ) then
          self.grotab = yrp_groups[1]
          return self.grotab
        end
      end
    end
  end
  if self.grotab != nil then
    return self.grotab
  else
    return nil
  end
end

function Player:CharID()
  if SERVER then
    local char = self:GetChaTab()
    if worked( char, "char CharID", true ) then
      self.charid = char.uniqueID
      return self.charid
    end
  end
  if self.charid != nil then
    return self.charid
  else
    return nil
  end
end

function Player:CheckMoney()
  if SERVER then
    timer.Simple( 4, function()
      local _m = self:GetNWString( "money", 0 )
      local _money = tonumber( _m )
      if worked( _money, "ply:money CheckMoney", true ) and self:CharID() != nil then
        db_update( "yrp_characters", "money = '" .. _money .. "'", "uniqueID = " .. self:CharID() ) --attempt to nil value
      end
      _mb = self:GetNWString( "moneybank", 0 )
      local _moneybank = tonumber( _mb )
      if worked( _moneybank, "ply:moneybank CheckMoney", true ) and self:CharID() != nil then
        db_update( "yrp_characters", "moneybank = '" .. _moneybank .. "'", "uniqueID = " .. self:CharID() )
      end
    end)
  end
end

function Player:UpdateMoney()
  if SERVER then
    local money = tonumber( self:GetNWString( "money", 0 ) )
    if worked( money, "ply:money UpdateMoney", true ) then
      db_update( "yrp_characters", "money = '" .. money .. "'", "uniqueID = " .. self:CharID() )
    end
    local moneybank = tonumber( self:GetNWString( "moneybank", 0 ) )
    if worked( moneybank, "ply:moneybank UpdateMoney", true ) then
      db_update( "yrp_characters", "moneybank = '" .. moneybank .. "'", "uniqueID = " .. self:CharID() )
    end
  end
end

function Player:GetPlayerModel()
  if SERVER then
    local yrp_characters = self:GetChaTab()
    if worked( yrp_characters, "yrp_characters (GetPlayerModel)", true ) then
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
  return nil
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

function Player:SteamName()
  return self:GetName()
end

function Player:RPName()
  return self:GetNWString( "rpname", "" )
end

function Player:Nick()
  return self:SteamName() .. " [" .. self:RPName() .. "]"
end

function Player:Team()
  return self:GetNWString( "groupName", "NO TEAM" )
end
