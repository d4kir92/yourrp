--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function GM:PlayerDisconnected( ply )
  save_clients( "PlayerDisconnected" )
end

function GM:ShutDown()
  save_clients( "Shutdown/Changelevel" )
end

function GM:GetFallDamage( ply, speed )
  if IsRealisticFallDamageEnabled() then
    local _damage = speed / 8
    if speed > ply:GetModelScale()*120 then
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

function GM:EntityTakeDamage( target, dmginfo )
	if target:IsPlayer() and dmginfo:GetAttacker() != target then
		target:SetNWBool( "inCombat", true )
    if timer.Exists( target:SteamID() .. " outOfCombat" ) then
      timer.Remove( target:SteamID() .. " outOfCombat" )
    end
    timer.Create( target:SteamID() .. " outOfCombat", 6, 1, function()
      if target != NULL then
        target:SetNWBool( "inCombat", false )
        lowering_weapon( target )
        timer.Remove( target:SteamID() .. " outOfCombat" )
      end
    end)
	end

	if IsEntity(target) and !target:IsPlayer() and !target:IsNPC() then
		dmginfo:SetDamage( GetHitFactorEntity() )
  end
  if target:IsVehicle() then
		dmginfo:SetDamage( GetHitFactorVehicle() )
  end
end

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )
  if IsRealisticDamageEnabled() then
    if IsBleedingEnabled() then
      ply:StartBleeding()

      ply:SetBleedingPosition( ply:GetPos() - dmginfo:GetDamagePosition() )
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
    elseif hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then
      dmginfo:ScaleDamage( GetHitFactorPlayerLegs() )
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

function GM:PlayerInitialSpawn( ply )
  printGM( "gm", "PlayerInitialSpawn " .. ply:Nick() )
  --ply:KillSilent()
  if ply:HasCharacterSelected() then
    local rolTab = ply:GetRolTab()
    if rolTab != nil then
      timer.Simple( 1, function()

        set_role( ply, rolTab.uniqueID )
        set_role_values( ply )
      end)
    end
  end
end

function GM:PlayerAuthed( ply, steamid, uniqueid )
  printGM( "gm", "PlayerAuthed " .. ply:Nick() )
  --ply:KillSilent()
  ply:resetUptimeCurrent()
  check_yrp_client( ply )
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

function GM:PlayerLoadout( ply )
  printGM( "note", "[" .. tostring( ply:RPName() ) .. "] get his role equipment. (PlayerLoadout)" )
  if ply:HasCharacterSelected() then
    ply:CheckInventory()
    ply:SetNWBool( "cuffed", false )

    ply:old_give( "yrp_key" )
    ply:old_give( "yrp_unarmed" )

    addKeys( ply )

    local plyTab = ply:GetPlyTab()
    local chaTab = ply:GetChaTab()

    set_role_values( ply )

    local chaTab = ply:GetChaTab()
    if chaTab != nil then
      ply:SetNWString( "money", chaTab.money )
      ply:SetNWString( "moneybank", chaTab.moneybank )
      ply:SetNWString( "rpname", chaTab.rpname )

      setbodygroups( ply )
    else
      printGM( "note", "Give char failed -> KillSilent -> " .. ply:Nick() )
      ply:KillSilent()
    end

    ply:SetNWInt( "hunger", 100 )
    ply:SetNWInt( "thirst", 100 )

    local monTab = db_select( "yrp_money", "*", nil )
    if monTab != nil then
      local monPre = monTab[1].value
      local monPos = monTab[2].value
      ply:SetNWString( "moneyPre", monPre )
      ply:SetNWString( "moneyPost", monPos )
    end

    local _yrp_general = db_select( "yrp_general", "*", nil )
    if _yrp_general != nil then
      _yrp_general = _yrp_general[1]
      ply:SetNWBool( "toggle_inventory", false ) -- LATER tobool( _yrp_general.toggle_inventory ) )
      ply:SetNWBool( "toggle_hunger", tobool( _yrp_general.toggle_hunger ) )
      ply:SetNWBool( "toggle_thirst", tobool( _yrp_general.toggle_thirst ) )
      ply:SetNWBool( "toggle_stamina", tobool( _yrp_general.toggle_stamina ) )
      ply:SetNWBool( "toggle_building", tobool( _yrp_general.toggle_building ) )
      ply:SetNWBool( "toggle_hud", tobool( _yrp_general.toggle_hud ) )
      ply:SetNWInt( "view_distance", _yrp_general.view_distance )
    else
      printGM( "note", "yrp_general failed" )
    end

    if ply:IsAdmin() or ply:IsSuperAdmin() then
      if !ply:HasItem( "yrp_arrest_stick" ) then
        ply:AddSwep( "yrp_arrest_stick" )
      end
      if !ply:HasItem( "weapon_physgun" ) then
        ply:AddSwep( "weapon_physgun" )
      end
      if !ply:HasItem( "weapon_physcannon" ) then
        ply:AddSwep( "weapon_physcannon" )
      end
    end

    ply:UseSweps()
  end
end

hook.Add( "PlayerSpawn", "yrp_PlayerSpawn", function( ply )
  printGM( "note", "[" .. tostring( ply:RPName() ) .. "] spawned. (PlayerSpawn)" )
  if ply:GetNWBool( "can_respawn", true ) then
    ply:SetNWBool( "can_respawn", false )
    timer.Simple( 0.01, function()
      teleportToSpawnpoint( ply )
    end)
  end
end)

hook.Add( "PostPlayerDeath", "yrp_PostPlayerDeath", function( ply )
  printGM( "note", "[" .. tostring( ply:RPName() ) .. "] is dead. (PostPlayerDeath)" )
  ply:StopBleeding()

  ply:SetNWBool( "can_respawn", true )
  local _sel = db_select( "yrp_general", "toggle_clearinventoryondead", "uniqueID = 1" )
  if _sel != nil then
    _sel = _sel[1]
    if tobool( _sel.toggle_clearinventoryondead ) then
      ply:StripWeapons()
      if ply:IsSuperAdmin() or ply:IsAdmin() then
        net.Start( "yrp_noti" )
          net.WriteString( "inventoryclearing" )
          net.WriteString( "enabled" )
        net.Send( ply )
      end
    end
  end
end)

util.AddNetworkString( "player_is_ready" )
net.Receive( "player_is_ready", function( len, ply )
  net.Start( "yrp_noti" )
    net.WriteString( "playerisready" )
    net.WriteString( ply:Nick() )
  net.Broadcast()
end)

function GM:PlayerSpray( ply )
  local _sel = db_select( "yrp_general", "toggle_graffiti", "uniqueID = 1" )
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
