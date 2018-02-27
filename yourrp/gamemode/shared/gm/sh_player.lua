--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local Player = FindMetaTable( "Player" )

function Player:LoadedGamemode()
  return self:GetNWBool( "finishedloading", false )
end

function Player:GetPlyTab()
  if SERVER then
    if self:LoadedGamemode() then
      if tostring( self ) != "Player [NULL]" then
        if worked( self:SteamID(), "SteamID fail", true ) then
          local yrp_players = db_select( "yrp_players", "*", "SteamID = '" .. self:SteamID() .. "'" )
          if worked( yrp_players, "GetPlyTab fail", true ) then
            self.plytab = yrp_players[1]
            return self.plytab
          end
        end
      end
    end
  end
  return nil
end

function Player:IsCharacterValid()
  if SERVER then
    if self:LoadedGamemode() then
      local _cha_tab = self:GetChaTab()
      if _cha_tab == nil then
        return false
      else
        --printTab( _cha_tab )
        return true
      end
    end
  end
end

function Player:HasCharacterSelected()
  if SERVER then
    if self:LoadedGamemode() then
      --printGM( "note", self:Name() .. " HasCharacterSelected?" )
      local _ply_tab = self:GetPlyTab()
      --printTab( _ply_tab )
      if _ply_tab != nil then
        if tostring( _ply_tab.CurrentCharacter ) == "NULL" or _ply_tab.CurrentCharacter == NULL then
          --open_character_selection( self )
        else
          return true
        end
      end
    end
  end
  return false
end

function Player:GetChaTab()
  if SERVER then
    if self:LoadedGamemode() then
      local _tmp = self:GetPlyTab()
      if self:HasCharacterSelected() then
        local yrp_characters = db_select( "yrp_characters", "*", "uniqueID = " .. _tmp.CurrentCharacter )
        if worked( yrp_characters, "yrp_characters GetChaTab", true ) then
          self.chatab = yrp_characters[1]
          return self.chatab
        else
          --open_character_selection( self )
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
    if self:LoadedGamemode() then
      if self:HasCharacterSelected() then
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
    end
  end
  return nil
end

function Player:GetGroTab()
  if SERVER then
    if self:LoadedGamemode() then
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
  end
  if self.grotab != nil then
    return self.grotab
  else
    return nil
  end
end

function Player:CharID()
  if SERVER then
    if self:LoadedGamemode() then
      local char = self:GetChaTab()
      if worked( char, "char CharID", true ) then
        self.charid = char.uniqueID
        return self.charid
      end
    end
  end
  if self.charid != nil then
    return self.charid
  else
    --SPAM printGM( "note", self:Name() .. " CharID == NIL! " .. tostring( self.charid ) )
    return nil
  end
end

function Player:CheckMoney()
  if SERVER then
    timer.Simple( 4, function()
      local _m = self:GetNWString( "money", "FAILED" )
      if _m == "FAILED" then
        printGM( "error", "CheckMoney failed" )
        return false
      end
      local _money = tonumber( _m )
      if worked( _money, "ply:money CheckMoney", true ) and self:CharID() != nil then
        db_update( "yrp_characters", "money = '" .. _money .. "'", "uniqueID = " .. self:CharID() ) --attempt to nil value
      end
      _mb = self:GetNWString( "moneybank", "FAILED" )
      if _mb == "FAILED" then
        printGM( "error", "CheckMoney failed" )
        return false
      end
      local _moneybank = tonumber( _mb )
      if worked( _moneybank, "ply:moneybank CheckMoney", true ) and self:CharID() != nil then
        db_update( "yrp_characters", "moneybank = '" .. _moneybank .. "'", "uniqueID = " .. self:CharID() )
      end
    end)
  end
end

function Player:UpdateMoney()
  if SERVER then
    local money = self:GetNWString( "money", "FAILED" )
    if money == "FAILED" then
      return false
    end
    if worked( money, "ply:money UpdateMoney", true ) then
      db_update( "yrp_characters", "money = '" .. money .. "'", "uniqueID = " .. self:CharID() )
    end
    local moneybank = tonumber( self:GetNWString( "moneybank", "FAILED" ) )
    if moneybank == "FAILED" then
      return false
    end
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

function Player:IsAgent()
  return self:GetNWBool( "canbeagent" )
end

if SERVER then
  function Player:Unbroke()
    self:SetNWBool( "broken_leg_right", false )
    self:SetNWBool( "broken_leg_left", false )
    self:SetNWBool( "broken_arm_right", false )
    self:SetNWBool( "broken_arm_left", false )
  end

  function Player:StopCasting()
    --[[ successfull casting ]]--
    self:SetNWBool( "iscasting", false )

    local _args = {}
    _args.attacker = self
    _args.target = self:GetNWEntity( "casttarget" )
    hook.Run( "yrp_castdone_" .. self:GetNWString( "castnet" ), _args )
  end

  function Player:InteruptCasting()
    --[[ failed casting ]]--
    self:SetNWBool( "iscasting", false )
    if timer.Exists( self:SteamID() .. "castduration" ) then
      timer.Remove( self:SteamID() .. "castduration" )
    end
  end

  function Player:StartCasting( net_str, lang_str, mode, target, duration, range, cost, canmove )
    --[[ cancel other spells ]]--
    self:InteruptCasting()

    --[[ Setup ]]--
    self:SetNWString( "castnet", net_str )
    self:SetNWInt( "castmode", mode or 0 )
    self:SetNWBool( "castcanmove", canmove or false )
    if !self:GetNWBool( "castcanmove" ) then
      self:SetNWVector( "castposition", self:GetPos() )
    end
    self:SetNWString( "castname", lang_str )
    self:SetNWFloat( "castmax", duration or 1.0 )
    if self:GetNWInt( "castmode" ) == 0 then
      self:SetNWFloat( "castcur", 0.0 )
    elseif self:GetNWInt( "castmode" ) == 1 then
      self:SetNWFloat( "castcur", self:GetNWFloat( "castmax" ) )
    end
    self:SetNWEntity( "casttarget", target or self )
    self:SetNWFloat( "castrange", range or 0.0 )

    --[[ Start casting ]]--
    self:SetNWBool( "iscasting", true )
    timer.Create( self:SteamID() .. "castduration", 0.1, 0, function()

      --printGM( "note", self:GetNWString( "castname" ) .. " " .. tostring( self:GetNWFloat( "castcur" ) ) )

      --[[ Casting ]]--
      if self:GetNWInt( "castmode" ) == 0 then
        self:SetNWFloat( "castcur", self:GetNWFloat( "castcur" ) + 0.1 )
        if !self:GetNWBool( "castcanmove" ) then
          local _o_pos = self:GetNWVector( "castposition" )
          local _c_pos = self:GetPos()
          local _space = 3

          --[[ x, y moved ]]--
          if _c_pos.x + _space < _o_pos.x or _c_pos.x - _space > _o_pos.x or _c_pos.y + _space < _o_pos.y or _c_pos.y - _space > _o_pos.y then
            self:InteruptCasting()
          end
          if self:GetPos():Distance( target:GetPos() ) > self:GetNWFloat( "castrange" ) then
            self:InteruptCasting()
          end
        end
        if self:GetNWFloat( "castcur" ) >= self:GetNWFloat( "castmax" ) then
          self:StopCasting()
          timer.Remove( self:SteamID() .. "castduration" )
        end

      --[[ Channeling ]]--
      elseif self:GetNWInt( "castmode" ) == 1 then
        self:SetNWFloat( "castcur", self:GetNWFloat( "castcur" ) - 0.1 )
        if self:GetNWFloat( "castcur" ) <= 0.0 then
          self:StopCasting()
          timer.Remove( self:SteamID() .. "castduration" )
        end
      end

    end)
  end

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

  function Player:resetUptimeCurrent()
    local _res = db_update( "yrp_players", "uptime_current = " .. 0, "SteamID = '" .. self:SteamID() .. "'" )
  end

  function Player:getuptimecurrent()
    local _ret = db_select( "yrp_players", "uptime_current", "SteamID = '" .. self:SteamID() .. "'" )
    if _ret != nil and _ret != false then
      return _ret[1].uptime_current
    end
    return 0
  end

  function Player:getuptimetotal()
    local _ret = db_select( "yrp_players", "uptime_total", "SteamID = '" .. self:SteamID() .. "'" )
    if _ret != nil and _ret != false then
      return _ret[1].uptime_total
    end
    return 0
  end

  function Player:addSecond()
    local _sec_total = self:getuptimetotal()
    local _sec_current = self:getuptimecurrent()
    if _sec_current != nil and _sec_total != nil and _sec_current != false and _sec_total != false then
      local _res = db_update( "yrp_players", "uptime_total = " .. _sec_total + 1 .. ", uptime_current = " .. _sec_current + 1, "SteamID = '" .. self:SteamID() .. "'" )
      self:SetNWFloat( "uptime_current", self:getuptimecurrent() )
      self:SetNWFloat( "uptime_total", self:getuptimetotal() )
      self:SetNWFloat( "uptime_server", os.clock() )
    end
  end

  function Player:CheckHeal()
    if self:Health() > self:GetNWInt( "preHealth", 0 ) + 5 then
      self:StopBleeding()
    end
    self:SetNWInt( "preHealth", self:Health() )
  end

  function Player:Heal( amount )
    self:SetHealth( self:Health() + amount )
    if self:Health() > self:GetMaxHealth() then
      self:SetHealth( self:GetMaxHealth() )
    end
  end

  function Player:StartBleeding()
    self:SetNWBool( "isbleeding", true )
  end

  function Player:StopBleeding()
    self:SetNWBool( "isbleeding", false )
  end

  function Player:SetBleedingPosition( pos )
    self:SetNWVector( "bleedingpos", pos )
  end
end

function Player:GetBleedingPosition()
  return self:GetNWVector( "bleedingpos", Vector( 0, 0, 0 ) )
end

function Player:IsBleeding()
  return self:GetNWBool( "isbleeding", false )
end

function Player:canAfford( money )
  local _tmpMoney = tonumber( money )
  if isnumber( _tmpMoney ) and self:GetNWString( "money" ) != nil then
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
  return tostring( self:GetName() )
end

function Player:RPName()
  return tostring( self:GetNWString( "rpname", "" ) )
end

function Player:Nick()
  return tostring( self:RPName() )
end

function Player:Name()
  return "[" .. self:SteamName() .. " (".. self:RPName() .. ")]" -- " {Alive: " .. string.upper( tostring(self:Alive()) ) .. "}"
end

function Player:Team()
  return tonumber( self:GetNWString( "groupUniqueID", "-1" ) )
end

timer.Simple( 10, function()
  function team.GetName( index )
    for k, v in pairs( player.GetAll() ) do
      if v:Team() == index then
        return v:GetNWString( "groupName", "NO TEAM" )
      end
    end
    return "FAIL"
  end

  function team.GetColor( index )
    for k, v in pairs( player.GetAll() ) do
      if v:Team() == index then
        local _color = v:GetNWString( "groupColor", "255,0,0" )
        _color = string.Explode( ",", _color )
        return Color( _color[1], _color[2], _color[3] )
      end
      return Color( 255, 0, 0 )
    end
  end
end)

function Player:GetRoleName()
  local _rn = self:GetNWString( "roleName" )
  if _rn != "" then
    return _rn
  else
    return nil
  end
end
