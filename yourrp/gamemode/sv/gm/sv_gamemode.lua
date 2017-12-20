--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function GM:PlayerDisconnected( ply )
  save_clients( "PlayerDisconnected" )
end

function GM:ShutDown()
  save_clients( "Shutdown/Changelevel" )
end

function GM:GetFallDamage( ply, speed )
  local _damage = speed / 8
  if speed > ply:GetModelScale()*120 then
    return _damage
  else
    return 0
  end
end

function GM:PlayerSwitchWeapon( ply, oldWeapon, newWeapon )
  if ply:GetNWBool( "cuffed" ) or ply.leiche != nil then
    return true
  end
  return false
end

function GM:CanPlayerSuicide( ply )
  return true
end

function GM:EntityTakeDamage( target, dmginfo )
	if target:IsPlayer() then
		target:SetNWBool( "inCombat", true )
    if timer.Exists( target:Nick() .. " outOfCombat" ) then
      timer.Remove( target:Nick() .. " outOfCombat" )
    end
    timer.Create( target:Nick() .. " outOfCombat", 6, 1, function()
      target:SetNWBool( "inCombat", false )
      timer.Remove( target:Nick() .. " outOfCombat" )
    end)
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

function GM:PlayerCanHearPlayersVoice( listener, talker )
  if talker:GetNWInt( "speak_channel", 0 ) == 1 and talker:GetNWString( "groupUniqueID" ) == listener:GetNWString( "groupUniqueID" ) then
    return true, false
	elseif talker:GetNWInt( "speak_channel", 0 ) == 2 then
    return true, false
  elseif talker:GetNWInt( "speak_channel", 0 ) == 0 then
    return true, true
  end
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
  check_yrp_client( ply )
end

function GM:PlayerSetModel( ply )
  local tmpRolePlayermodel = ply:GetPlayerModel()
  if tmpRolePlayermodel != nil and tmpRolePlayermodel != false then
    ply:SetModel( tmpRolePlayermodel )
  else
    ply:SetModel( "models/player/skeleton.mdl" )
  end
end

function GM:PlayerLoadout( ply )
  printGM( "note", "Get PlayerLoadout for player: " .. ply:Nick() )
  if ply:HasCharacterSelected() then
    ply:CheckInventory()
    ply:SetNWBool( "cuffed", false )

    if !ply:HasItem( "yrp_key" ) then
      ply:AddSwep( "yrp_key" )
    end

    if !ply:HasItem( "yrp_unarmed" ) then
      ply:AddSwep( "yrp_unarmed" )
    end

    addKeys( ply )

    local plyTab = ply:GetPlyTab()
    local chaTab = ply:GetChaTab()

    set_role_values( ply )

    if chaTab != nil then
      local chaTab = ply:GetChaTab()
      ply:SetNWString( "money", chaTab.money )
      ply:SetNWString( "moneybank", chaTab.moneybank )
      ply:SetNWString( "rpname", chaTab.rpname )

      ply:SetSkin( chaTab.skin )
      ply:SetBodygroup( 0, chaTab.bg0 )
      ply:SetBodygroup( 1, chaTab.bg1 )
      ply:SetBodygroup( 2, chaTab.bg2 )
      ply:SetBodygroup( 3, chaTab.bg3 )
      ply:SetBodygroup( 4, chaTab.bg4 )
      ply:SetBodygroup( 5, chaTab.bg5 )
      ply:SetBodygroup( 6, chaTab.bg6 )
      ply:SetBodygroup( 7, chaTab.bg7 )
    else
      printGM( "note", "give char failed" )
      ply:KillSilent()
    end

    ply:SetNWInt( "hunger", 100 )
    ply:SetNWInt( "thirst", 100 )
    ply:SetNWInt( "stamina", 100 )

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
      ply:SetNWBool( "toggle_inventory", tobool( _yrp_general.toggle_inventory ) )
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
  timer.Simple( 0.01, function()
    teleportToSpawnpoint( ply )
  end)
end)
