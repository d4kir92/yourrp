--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function GM:PlayerDisconnected( ply )
  printGM( "gm", "[PlayerDisconnected] " .. ply:YRPName() )
  save_clients( "PlayerDisconnected" )

  local _rol_tab = ply:GetRolTab()
  if _rol_tab != nil then
    if tonumber( _rol_tab.maxamount ) > 0 then
      ply:SetNWString( "roleUniqueID", "1" )
      updateRoleUses( _rol_tab.uniqueID )
    end
  end
end

function GM:PlayerConnect( name, ip )
	printGM( "gm", "[PlayerConnect] Name: " .. name .. " ( IP: " .. ip .. " )" )
  PrintMessage( HUD_PRINTTALK, name .. " is connecting to the Server." )
end

function GM:PlayerInitialSpawn( ply )
  printGM( "gm", "[PlayerInitialSpawn] " .. ply:YRPName() )
  --ply:KillSilent()
  if ply:HasCharacterSelected() then
    local rolTab = ply:GetRolTab()
    if rolTab != nil then
      timer.Simple( 1, function()

        SetRole( ply, rolTab.uniqueID )
        teleportToSpawnpoint( ply )
      end)
    end
  end
end

function GM:PlayerSelectSpawn( ply )
  printGM( "gm", "[PlayerSelectSpawn] " .. ply:YRPName() )

	local spawns = ents.FindByClass( "info_player_start" )
	local random_entry = math.random( #spawns )

	return spawns[ random_entry ]

end

function GM:PlayerAuthed( ply, steamid, uniqueid )
  ply:KillSilent()

  printGM( "gm", "[PlayerAuthed] " .. ply:YRPName() )

  SetDesign( ply )

  --ply:KillSilent()
  ply:resetUptimeCurrent()
  check_yrp_client( ply )
end

function GM:PlayerLoadout( ply )
  printGM( "gm", "[PlayerLoadout] " .. ply:YRPName() .. " get his role equipment." )
  if ply:HasCharacterSelected() then
    --ply:CheckInventory()

    --[[ Status Reset ]]--
    ply:SetNWBool( "cuffed", false )
    ply:SetNWBool( "broken_leg_left", false )
    ply:SetNWBool( "broken_leg_right", false )
    ply:SetNWBool( "broken_arm_left", false )
    ply:SetNWBool( "broken_arm_right", false )

    ply:ForceGive( "yrp_key" )
    ply:ForceGive( "yrp_unarmed" )

    local plyTab = ply:GetPlyTab()

    local _rol_tab = ply:GetRolTab()
    if _rol_tab != nil then
      SetRole( ply, _rol_tab.uniqueID )
    else
      printGM( "gm", "Give role failed -> KillSilent -> " .. ply:YRPName() )
      if !ply:IsBot() then
        ply:KillSilent()
      end
    end

    local chaTab = ply:GetChaTab()
    if chaTab != nil then
      ply:SetNWString( "money", chaTab.money )
      ply:SetNWString( "moneybank", chaTab.moneybank )
      ply:SetNWString( "rpname", chaTab.rpname )

      setbodygroups( ply )
    else
      printGM( "gm", "Give char failed -> KillSilent -> " .. ply:YRPName() )
      if !ply:IsBot() then
        ply:KillSilent()
      end
    end

    ply:SetNWInt( "hunger", 100 )
    ply:SetNWInt( "thirst", 100 )

    local monTab = SQL_SELECT( "yrp_money", "*", nil )
    if monTab != nil then
      local monPre = monTab[1].value
      local monPos = monTab[2].value
      ply:SetNWString( "moneyPre", monPre )
      ply:SetNWString( "moneyPost", monPos )
    end

    local _yrp_general = SQL_SELECT( "yrp_general", "*", nil )
    if _yrp_general != nil then
      _yrp_general = _yrp_general[1]
      ply:SetNWBool( "toggle_inventory", tobool( _yrp_general.toggle_inventory ) )
      --ply:SetNWBool( "toggle_hunger", tobool( _yrp_general.toggle_hunger ) )
      --ply:SetNWBool( "toggle_thirst", tobool( _yrp_general.toggle_thirst ) )
      ply:SetNWBool( "toggle_stamina", tobool( _yrp_general.toggle_stamina ) )
      ply:SetNWBool( "toggle_building", tobool( _yrp_general.toggle_building ) )
      ply:SetNWBool( "toggle_hud", tobool( _yrp_general.toggle_hud ) )
      ply:SetNWBool( "toggle_smartphone", tobool( _yrp_general.toggle_smartphone ) )
      ply:SetNWInt( "view_distance", _yrp_general.view_distance )
    else
      printGM( "note", "yrp_general failed" )
    end

    if ply:HasAccess() then
      ply:ForceGive( "yrp_arrest_stick" )
      ply:ForceGive( "weapon_physgun" )
      ply:ForceGive( "weapon_physcannon" )
    end
  end

  ply:UpdateBackpack()
  
  RenderNormal( ply )
end

hook.Add( "PlayerSpawn", "yrp_player_spawn_PlayerSpawn", function( ply )
  printGM( "gm", "[PlayerSpawn] " .. tostring( ply:YRPName() ) .. " spawned." )
  if ply:GetNWBool( "can_respawn", false ) then
    ply:SetNWBool( "can_respawn", false )

    timer.Simple( 0.01, function()
      teleportToSpawnpoint( ply )
    end)
  end
end)

hook.Add( "PostPlayerDeath", "yrp_player_spawn_PostPlayerDeath", function( ply )
  printGM( "gm", "[PostPlayerDeath] " .. tostring( ply:YRPName() ) .. " is dead." )
  ply:StopBleeding()

  ply:SetNWBool( "can_respawn", true )
end)

--[[
function GM:PlayerDeathThink( ply )
  --printGM( "gm", "[PlayerDeathThink] " .. tostring( ply:YRPName() ) .. "" )
end
]]--

function IsNoDefaultWeapon( weapon )
  local _class = weapon:GetClass()
  if weapon:GetModel() != "" and _class != "yrp_key" and _class != "yrp_unarmed" then
    return true
  else
    return false
  end
end

function IsNoAdminWeapon( weapon )
  local _class = weapon:GetClass()
  if !weapon.AdminSpawnable and _class != "weapon_physgun" and _class != "weapon_physcannon" and _class != "gmod_tool" then
    return true
  else
    return false
  end
end

hook.Add( "DoPlayerDeath", "yrp_player_spawn_DoPlayerDeath", function( ply, attacker, dmg )
  printGM( "gm", "[DoPlayerDeath] " .. tostring( ply:YRPName() ) .. " do death." )
  local _reward = tonumber( ply:GetNWString( "hitreward" ) )
  if isnumber( _reward ) and attacker:IsPlayer() then
    if attacker:IsAgent() then
      printGM( "note", "Hit done! " .. _reward )
      attacker:addMoney( _reward )
      hitdone( ply, attacker )
    end
  end

  if IsDropItemsOnDeathEnabled() then
    local _weapons = ply:GetWeapons()
    local _cooldown_item = 120
    for i, wep in pairs( _weapons ) do
      if IsNoAdminWeapon( wep ) and IsNoDefaultWeapon( wep ) then
        ply:DropWeapon( wep )
        timer.Simple( _cooldown_item, function()
          wep:Remove()
        end)
      end
    end
  end
end)

function GM:ShutDown()
  save_clients( "Shutdown/Changelevel" )
  SaveStorages( "Shutdown/Changelevel" )
end

function GM:GetFallDamage( ply, speed )
  if IsRealisticFallDamageEnabled() then
    local _damage = speed / 8
    if speed > ply:GetModelScale()*120 then
      if IsBonefracturingEnabled() then
        local _rand = math.Round( math.Rand( 0, 1 ), 0 )
        if _rand == 0 then
          ply:SetNWBool( "broken_leg_right", true )
        elseif _rand == 1 then
          ply:SetNWBool( "broken_leg_left", true )
        end
      end
      return _damage*ply:GetMaxHealth()/100
    else
      return 0
    end
  else
    return 10
  end
end

function GM:PlayerSwitchWeapon( ply, oldWeapon, newWeapon )

  if newWeapon:IsScripted() then
    --[[ Set default HoldType of currentweapon ]]--
    if newWeapon:GetNWString( "swep_holdtype", "" ) == "" then
      local _hold_type = newWeapon.HoldType or newWeapon:GetHoldType() or "normal"
      newWeapon:SetNWString( "swep_holdtype", _hold_type )
    end

    if !ply:GetNWBool( "inCombat" ) then
      ply:SetNWBool( "weaponlowered", false )

      if ply:GetNWBool( "weaponlowered" ) == false then
        timer.Simple( 0.1, function()
          lowering_weapon( ply )
        end)
      end
    else
      ply:SetNWBool( "weaponlowered", false )
    end
  end

  if ply:GetNWBool( "cuffed" ) or ply.leiche != nil then
    return true
  end
end

function GM:CanPlayerSuicide( ply )
  return true
end

hook.Add( "EntityTakeDamage", "yrp_entity_take_damage", function( ent, dmginfo )
	if IsEntity(ent) and !ent:IsPlayer() and !ent:IsNPC() then
    dmginfo:ScaleDamage( GetHitFactorEntity() )
  end
  if ent:IsVehicle() then
		dmginfo:ScaleDamage( GetHitFactorVehicle() )
  end
end)

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )
  if dmginfo:GetAttacker() != ply then
		ply:SetNWBool( "inCombat", true )
    if timer.Exists( ply:SteamID() .. " outOfCombat" ) then
      timer.Remove( ply:SteamID() .. " outOfCombat" )
    end
    timer.Create( ply:SteamID() .. " outOfCombat", 6, 1, function()
      if ply != NULL then
        ply:SetNWBool( "inCombat", false )
        lowering_weapon( ply )
        timer.Remove( ply:SteamID() .. " outOfCombat" )
      end
    end)
	end

  if IsRealisticDamageEnabled() then
    if IsBleedingEnabled() then
      local _rand = math.Rand( 0, 100 )
      if _rand < GetBleedingChance() then
        ply:StartBleeding()
        ply:SetBleedingPosition( ply:GetPos() - dmginfo:GetDamagePosition() )
      end
    end
  	if hitgroup == HITGROUP_HEAD then
      if IsHeadshotDeadlyPlayer() then
        dmginfo:ScaleDamage( ply:GetMaxHealth() )
      else
    		dmginfo:ScaleDamage( GetHitFactorPlayerHead() )
      end
   	elseif hitgroup == HITGROUP_CHEST then
      dmginfo:ScaleDamage( GetHitFactorPlayerChes() )
    elseif hitgroup == HITGROUP_STOMACH then
  		dmginfo:ScaleDamage( GetHitFactorPlayerStom() )
    elseif hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM then
      dmginfo:ScaleDamage( GetHitFactorPlayerArms() )
      if IsBonefracturingEnabled() then
        local _break = math.Round( math.Rand( 0, 100 ), 0 )
        if _break <= GetBrokeChanceArms() then
          if hitgroup == HITGROUP_LEFTARM then
            ply:SetNWBool( "broken_arm_left", true )

            ply:SetActiveWeapon( "yrp_unarmed" )
        		ply:SelectWeapon( "yrp_unarmed" )
          elseif hitgroup == HITGROUP_RIGHTARM then
            ply:SetNWBool( "broken_arm_right", true )

            ply:SetActiveWeapon( "yrp_unarmed" )
        		ply:SelectWeapon( "yrp_unarmed" )
          end
        end
      end
    elseif hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then
      dmginfo:ScaleDamage( GetHitFactorPlayerLegs() )
      if IsBonefracturingEnabled() then
        local _break = math.Round( math.Rand( 0, 100 ), 0 )
        if _break <= GetBrokeChanceLegs() then
          if hitgroup == HITGROUP_LEFTLEG then
            ply:SetNWBool( "broken_leg_left", true )
          elseif hitgroup == HITGROUP_RIGHTLEG then
            ply:SetNWBool( "broken_leg_right", true )
          end
        end
      end
  	else
      dmginfo:ScaleDamage( 1 )
    end
  else
    dmginfo:ScaleDamage( 1 )
  end
end

function GM:ScaleNPCDamage( npc, hitgroup, dmginfo )
  if IsRealisticDamageEnabled() then
  	if hitgroup == HITGROUP_HEAD then
      if IsHeadshotDeadlyNpc() then
        dmginfo:ScaleDamage( npc:Health() )
      else
    		dmginfo:ScaleDamage( GetHitFactorNpcHead() )
      end
   	elseif hitgroup == HITGROUP_CHEST then
      dmginfo:ScaleDamage( GetHitFactorNpcChes() )
    elseif hitgroup == HITGROUP_STOMACH then
  		dmginfo:ScaleDamage( GetHitFactorNpcStom() )
    elseif hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM then
      dmginfo:ScaleDamage( GetHitFactorNpcArms() )
    elseif hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then
      dmginfo:ScaleDamage( GetHitFactorNpcLegs() )
  	else
      dmginfo:ScaleDamage( 1 )
    end
  else
    dmginfo:ScaleDamage( 1 )
  end
end


--[[ SPEAK Channels ]] --
util.AddNetworkString( "press_speak_next" )
util.AddNetworkString( "press_speak_prev" )

net.Receive( "press_speak_next", function( len, ply )
  ply:SetNWInt( "speak_channel", ply:GetNWInt( "speak_channel", 0 ) + 1 )
  if ply:GetNWInt( "speak_channel", 0 ) > 1 then
    if ply:GetNWBool( "yrp_voice_global", false ) then
      if ply:GetNWInt( "speak_channel", 0 ) > 2 then
        ply:SetNWInt( "speak_channel", 0 )
      end
    else
      ply:SetNWInt( "speak_channel", 0 )
    end
  end
end)

net.Receive( "press_speak_prev", function( len, ply )
  ply:SetNWInt( "speak_channel", ply:GetNWInt( "speak_channel", 0 ) - 1 )
  if ply:GetNWInt( "speak_channel", 0 ) < 0 then
    if ply:GetNWBool( "yrp_voice_global", false ) then
      ply:SetNWInt( "speak_channel", 2 )
    else
      ply:SetNWInt( "speak_channel", 1 )
    end
  end
end)

util.AddNetworkString( "yrp_voice_start" )

net.Receive( "yrp_voice_start", function( len, ply )
  ply:SetNWBool( "yrp_speaking", true )
  if ply:GetNWString( "speak_channel" ) == 2 then
    for k, v in pairs( player.GetAll() ) do
      v:SetNWString( "voice_global_steamid", ply:SteamID() )
      v:SetNWString( "voice_global_rolename", ply:GetNWString( "RoleName" ) )
    end
  end
end)

util.AddNetworkString( "yrp_voice_end" )

net.Receive( "yrp_voice_end", function( len, ply )
  ply:SetNWBool( "yrp_speaking", false )
end)

function hearfaded( talker, listener )
  if talker:GetNWInt( "speak_channel" ) == 0 or talker:GetNWInt( "speak_channel" ) == 1 and talker:GetNWString( "groupUniqueID" ) != listener:GetNWInt( "groupUniqueID" ) then
    --print("hearfaded true")
    return true
  else
    --print("hearfaded false")
    return false
  end
end

function canhear( talker, listener )
  if talker:GetNWInt( "speak_channel" ) == 2 then
    --print( "Talker: " .. talker:Nick() .. " | List: " .. listener:Nick() .. " can hear global" )
    return true
  elseif talker:GetNWInt( "speak_channel" ) == 1 and talker:GetNWString( "groupUniqueID" ) == listener:GetNWInt( "groupUniqueID" ) then
    --print( "Talker: " .. talker:Nick() .. " | List: " .. listener:Nick() .. " can hear group")
    return true
  elseif talker:GetPos():Distance( listener:GetPos() ) < 300 then
    --print( "Talker: " .. talker:Nick() .. " | List: " .. listener:Nick() .. " can hear local ")
    return true
  else
    --print( "Talker: " .. talker:Nick() .. " | List: " .. listener:Nick() .. " can >>NOT<< hear")
    return false
  end
end

function GM:PlayerCanHearPlayersVoice( listener, talker )

  if listener == talker then return false end

  local _is_talker = talker
  local _is_listener = listener
  if talker:GetNWBool( "yrp_speaking" ) then
    _is_talker = talker
    _is_listener = listener
  elseif listener:GetNWBool( "yrp_speaking" ) then
    _is_talker = listener
    _is_listener = talker
  else
    return false
  end

  return canhear( talker, listener ), hearfaded( talker, listener )
  --return canhear( _is_talker, _is_listener ), hearfaded( _is_talker, _is_listener )
end

function setbodygroups( ply )
  local chaTab = ply:GetChaTab()
  if chaTab != nil then
    ply:SetSkin( chaTab.skin )
    ply:SetBodygroup( 0, chaTab.bg0 )
    ply:SetBodygroup( 1, chaTab.bg1 )
    ply:SetBodygroup( 2, chaTab.bg2 )
    ply:SetBodygroup( 3, chaTab.bg3 )
    ply:SetBodygroup( 4, chaTab.bg4 )
    ply:SetBodygroup( 5, chaTab.bg5 )
    ply:SetBodygroup( 6, chaTab.bg6 )
    ply:SetBodygroup( 7, chaTab.bg7 )
  end
end

function setPlayerModel( ply )
  local tmpRolePlayermodel = ply:GetPlayerModel()
  if tmpRolePlayermodel != nil and tmpRolePlayermodel != false and tmpRolePlayermodel != "" then
    ply:SetModel( tmpRolePlayermodel )
  else
    ply:SetModel( "models/player/skeleton.mdl" )
  end
  setbodygroups( ply )
end

function GM:PlayerSetModel( ply )
  setPlayerModel( ply )
end

util.AddNetworkString( "player_is_ready" )
net.Receive( "player_is_ready", function( len, ply )
  printGM( "note", ply:YRPName() .. " finished loading." )

  open_character_selection( ply )

  ply:SetNWBool( "finishedloading", true )

  ply:KillSilent()

  net.Start( "yrp_noti" )
    net.WriteString( "playerisready" )
    net.WriteString( ply:Nick() )
  net.Broadcast()
end)

function GM:PlayerSpray( ply )
  local _sel = SQL_SELECT( "yrp_general", "toggle_graffiti", "uniqueID = 1" )
  if _sel != nil then
    _sel = _sel[1]
    if tobool( _sel.toggle_graffiti ) then
      return false
    end
  end
  return true
end

function GM:ShowHelp( ply )
  return false
end
