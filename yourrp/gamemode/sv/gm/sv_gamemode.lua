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
  if ply:IsSuperAdmin() or ply:IsAdmin() then
    return true
  else
    return false
  end
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

function GM:PlayerCanHearPlayersVoice( listener, talker )
  return true, true
  --[[if listener:GetPos():Distance( talker:GetPos()) < 1000 then
    return true, true
  else
    return false, false
  end]]--
end

function GM:PlayerInitialSpawn( ply )
  printGM( "gm", "PlayerInitialSpawn " .. ply:Nick() )
  ply:KillSilent()
end

function GM:PlayerAuthed( ply, steamid, uniqueid )
  printGM( "gm", "PlayerAuthed " .. ply:Nick() )
  ply:KillSilent()
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
  ply:SetNWBool( "cuffed", false )

  ply:Give( "yrp_key" )
  ply:Give( "yrp_unarmed" )

  addKeys( ply )

  local plyTab = ply:GetPlyTab()
  local chaTab = ply:GetChaTab()

  set_role_values( ply )

  if chaTab != nil then
    ply:SetMoney( tonumber( chaTab.money ) )
    ply:SetNWString( "moneybank", chaTab.moneybank )
    ply:SetNWString( "rpname", chaTab.rpname )

    ply:SetSkin( chaTab.skin )
    ply:SetBodygroup( 1, chaTab.bg1 )
    ply:SetBodygroup( 2, chaTab.bg2 )
    ply:SetBodygroup( 3, chaTab.bg3 )
    ply:SetBodygroup( 4, chaTab.bg4 )
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

  local yrp_general = db_select( "yrp_general", "*", nil )
  yrp_general = yrp_general[1]
  ply:SetNWBool( "toggle_metabolism", tobool( yrp_general.toggle_metabolism ) )
  ply:SetNWBool( "toggle_building", tobool( yrp_general.toggle_building ) )

  if ply:IsAdmin() or ply:IsSuperAdmin() then
    ply:Give( "yrp_arrest_stick" )
  end

  teleportToSpawnpoint( ply )
end
