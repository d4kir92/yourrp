--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

util.AddNetworkString( "restartServer" )
util.AddNetworkString( "updateServer" )
util.AddNetworkString( "cancelRestartServer" )

util.AddNetworkString( "get_workshop_collection" )
net.Receive( "get_workshop_collection", function( len, ply )
	local _wscnr = SQL_SELECT( "yrp_general", "text_server_collectionid", "uniqueID = '1'" )
	if wk( _wscnr ) then
		_wscnr = _wscnr[1].text_server_collectionid
	end
	local _wsc = engine.GetAddons()
	net.Start( "get_workshop_collection" )
		net.WriteString( _wscnr )
		net.WriteTable( _wsc )
	net.Send( ply )
end)

--Restart Server
net.Receive( "restartServer", function( len, ply )
	printGM( "gm", "RunConsoleCommand(_restart)" )
	RunConsoleCommand( "_restart" )
end)

net.Receive( "updateServer", function( len, ply )
	local _tmpString = net.ReadString()
	local _result = SQL_UPDATE( "yrp_general", "text_gamemode_name = '" .. SQL_STR_IN( _tmpString ) .. "'" )
	if worked( _result, "text_gamemode_name failed" ) then
	end
	local countdown = net.ReadInt( 16 )
	timer.Create( "timerRestartServer", 1, 0, function()
		local message = "Updating Server in " .. countdown .. " seconds"
		if countdown == 0 then
			message = "Server is updating."
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
			game.ConsoleCommand( "changelevel " .. GetMapNameDB() .. "\n" )
		end
	end)
end)

net.Receive( "cancelRestartServer", function( len, ply )
	timer.Remove( "timerRestartServer" )
	local message = "Restart Server CANCELED!"
	PrintMessage( HUD_PRINTCENTER, message )
	printGM( "server", message )
end)

function changeUserGroup( ply, cmd, args )
	printGM("note", "This Command (yrp_usergroup) is only for this round!")
	printGM("note", "Use an admin tool to make yourself permanent to an UserGroup")
	local _cmdpre = "[" .. string.upper( "yrp_usergroup" ) .. "] "
	local message = ""
	if #args == 2 then
		if !ply:IsPlayer() then
			--[[ if server tries ]]--
			for k, v in pairs( player.GetAll() ) do
				if string.find( string.lower( v:Nick() ), string.lower( args[1] ) ) or string.find( string.lower( v:SteamName() ), string.lower( args[1] ) ) then
					v:SetUserGroup( args[2] )
					printGM( "note", _cmdpre .. v:YRPName() .. " is now the usergroup " .. args[2] )
					return
				end
			end
			printGM( "note", _cmdpre .. "Player [" .. args[1] .. "] not found." )
		elseif ply:HasAccess() or ply:IPAddress() == "loopback" then
			--[[ if admin/superadmin/owner tries ]]--
			for k, v in pairs( player.GetAll() ) do
				if string.find( string.lower( v:Nick() ), string.lower( args[1] ) ) or string.find( string.lower( v:SteamName() ), string.lower( args[1] ) ) then
					v:SetUserGroup( args[2] )
					printGM( "note", _cmdpre .. v:YRPName() .. " is now the usergroup " .. args[2] )
					return
				end
			end
			printGM( "note", _cmdpre .. args[1] .. " not found." )
		elseif ply:IsPlayer() then
			--[[ if no rcon rights tries ]]--
			message = ply:SteamName() .. " tried to give " .. args[1] .. " the usergroup " .. args[2] .. "."
			printGM( "note", _cmdpre .. message )
		end
	else
		--[[ Failed command ]]--
		if #args > 2 then
			printGM( "note", _cmdpre .. "To much arguments (yrp_usergroup STEAMNAME/RPNAME UserGroup)" )
			printGM( "note", _cmdpre .. "Example: yrp_usergroup \"D4KiR | Arno\" superadmin" )
		else
			printGM( "note", _cmdpre .. "Not enough arguments (yrp_usergroup STEAMNAME/RPNAME UserGroup)" )
			printGM( "note", _cmdpre .. "Example: yrp_usergroup \"D4KiR | Arno\" superadmin" )
		end
	end
end

concommand.Add( "yrp_force_sqlite", function( ply, cmd, args )
	SetSQLMode(0, true)
end )

concommand.Add( "yrp_usergroup", function( ply, cmd, args )
	changeUserGroup( ply, cmd, args )
end )
