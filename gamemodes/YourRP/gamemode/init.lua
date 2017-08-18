//init.lua
//##############################################################################
//AddCSLuaFiles
AddCSLuaFile( "shared_pres.lua" )

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

AddCSLuaFile( "client/db_database.lua" )

AddCSLuaFile( "client/cl_fonts.lua" )
AddCSLuaFile( "client/cl_think.lua" )
AddCSLuaFile( "client/cl_chat.lua" )

//Settings
AddCSLuaFile( "client/settings/cl_settings.lua" )
//Settings Client
AddCSLuaFile( "client/settings/cl_settings_client.lua" )
AddCSLuaFile( "client/settings/cl_settings_client_charakter.lua" )
AddCSLuaFile( "client/settings/cl_settings_client_hud.lua" )

AddCSLuaFile( "client/settings/cl_settings_yourrp.lua" )
AddCSLuaFile( "client/settings/cl_settings_settings.lua" )
//YourRP
AddCSLuaFile( "client/settings/cl_settings_yourrp_workshop.lua" )
AddCSLuaFile( "client/settings/cl_settings_yourrp_wiki.lua" )
AddCSLuaFile( "client/settings/cl_settings_yourrp_contact.lua" )
//Settings Server
AddCSLuaFile( "client/settings/cl_settings_server.lua" )
AddCSLuaFile( "client/settings/cl_settings_server_general.lua" )
AddCSLuaFile( "client/settings/cl_settings_server_questions.lua" )
AddCSLuaFile( "client/settings/cl_settings_server_roles.lua" )
AddCSLuaFile( "client/settings/cl_settings_server_give.lua" )
AddCSLuaFile( "client/settings/cl_settings_server_map.lua" )
AddCSLuaFile( "client/settings/cl_settings_server_whitelist.lua" )
AddCSLuaFile( "client/settings/cl_settings_server_buysystem.lua" )
AddCSLuaFile( "client/settings/cl_settings_server_moneysystem.lua" )
AddCSLuaFile( "client/settings/cl_settings_server_jailsystem.lua" )

//Hud
AddCSLuaFile( "client/cl_hud.lua" )
AddCSLuaFile( "client/hud/cl_hud_map.lua" )
AddCSLuaFile( "client/hud/cl_hud_player.lua" )
AddCSLuaFile( "client/hud/cl_hud_view.lua" )

AddCSLuaFile( "client/charakter/cl_charakter.lua" )

AddCSLuaFile( "client/roles/cl_rolesmenu.lua" )

AddCSLuaFile( "client/interact/cl_interact.lua" )

AddCSLuaFile( "client/buy/cl_buy.lua" )

AddCSLuaFile( "client/door/cl_door_options.lua" )
//##############################################################################

//##############################################################################
//Includes
include( "shared_pres.lua" )

include( "server/sv_sizer.lua" )

include( "server/db_database.lua" )

include( "shared.lua" )

include( "server/sv_func.lua" )
include( "server/sv_think.lua" )
//##############################################################################

//##############################################################################
//utils
util.AddNetworkString( "restartServer" )
util.AddNetworkString( "cancelRestartServer" )
//##############################################################################

//##############################################################################
//Restart Server
net.Receive( "restartServer", function( len, ply )
  local tmpString = net.ReadString()
  sql.Query( "UPDATE yrp_general SET value = '" .. tmpString .. "' WHERE name = 'gamemodename'" )
	local tmpInt = net.ReadInt( 16 )
	sql.Query( "UPDATE yrp_general SET value = '" .. tmpInt .. "' WHERE name = 'startmoney'" )

  local countdown = net.ReadInt( 16 )
  timer.Create( "timerRestartServer", 1, 0, function()
		local message = "Restarting Server in " .. countdown .. " seconds"
		if countdown == 0 then
			message = "Server is restarting."
		end
    if countdown > 10 then
      if (countdown%10) == 0 then
        PrintMessage( HUD_PRINTCENTER, message )
        printGM( "server", message )
      end
    elseif countdown <= 10 then
      PrintMessage( HUD_PRINTCENTER, message )
      printGM( "server", message )
    end
    countdown = countdown - 1
    if countdown == -1 then
      timer.Remove( "timerRestartServer" )
      game.ConsoleCommand( "map " .. string.lower( game.GetMap() ) .. "\n" )
    end
  end)
end)

net.Receive( "cancelRestartServer", function( len, ply )
  timer.Remove( "timerRestartServer" )
  local message = "Restart Server CANCELED!"
  PrintMessage( HUD_PRINTCENTER, message )
  printGM( "server", message )
end)
//##############################################################################
function yrpSetModelScale( ply, size )
  ply:SetModelScale( size, 0 )

  if size >= 1 then
    ply:SetStepSize( 18*size )
  else
    ply:SetStepSize( 18 )
  end
end

function GM:PlayerAuthed( ply, steamid, uniqueid )
  checkClient( ply )
end

function GM:PlayerDisconnected( ply )
  saveClients( "PlayerDisconnected" )
end

function GM:ShutDown()
  saveClients( "Shutdown/Changelevel" )
end

function GM:GetFallDamage( ply, speed )
	return ( speed / 8 )
end

function GM:Initialize()
  timer.Simple( 1, function()
    addMapDoors()

    getMapCoords()
  end)
end
