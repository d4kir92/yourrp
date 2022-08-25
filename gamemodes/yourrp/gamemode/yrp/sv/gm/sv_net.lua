--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

util.AddNetworkString( "restartServer" )
util.AddNetworkString( "updateServer" )
util.AddNetworkString( "cancelRestartServer" )

--Restart Server
net.Receive( "restartServer", function(len, ply)
	if ply:HasAccess() then
		YRP.msg( "gm", "RunConsoleCommand(map)" )
		RunConsoleCommand( "map", game.GetMap() )
	end
end)

net.Receive( "updateServer", function(len, ply)
	if ply:HasAccess() then
		local _tmpString = net.ReadString()
		local _result = YRP_SQL_UPDATE( "yrp_general", {["text_gamemode_name"] = _tmpString})
		if worked(_result, "text_gamemode_name failed" ) then
		end
		local countdown = net.ReadInt(16)
		timer.Create( "timerRestartServer", 1, 0, function()
			local message = "Updating Server in " .. countdown .. " seconds"
			if countdown == 0 then
				message = "Server is updating."
			end
			if countdown > 10 then
				if ( countdown%10) == 0 then
					PrintMessage(HUD_PRINTCENTER, message)
					YRP.msg( "server", message)
				end
			elseif countdown <= 10 then
				PrintMessage(HUD_PRINTCENTER, message)
				YRP.msg( "server", message)
			end
			countdown = countdown - 1
			if countdown == -1 then
				timer.Remove( "timerRestartServer" )
				game.ConsoleCommand( "changelevel " .. GetMapNameDB() .. "\n" )
			end
		end)
	end
end)

net.Receive( "cancelRestartServer", function(len, ply)
	if ply:HasAccess() then
		timer.Remove( "timerRestartServer" )
		local message = "Restart Server CANCELED!"
		PrintMessage(HUD_PRINTCENTER, message)
		YRP.msg( "server", message)
	end
end)

function YRPChangeUserGroup(ply, cmd, args)
	YRP.msg( "note", "This Command (yrp_usergroup) is only for this round!" )
	YRP.msg( "note", "Use an admin tool to make yourself permanent to an UserGroup" )
	local _cmdpre = "[" .. string.upper( "yrp_usergroup" ) .. "] "
	local message = ""
	if #args == 2 then
		if !ply:IsPlayer() then
			--[[ if server tries ]]--
			for k, v in pairs(player.GetAll() ) do
				if string.find(string.lower( v:Nick() ), string.lower( args[1]) ) or string.find(string.lower( v:SteamName() ), string.lower( args[1]) ) then
					v:SetUserGroup( args[2])
					YRP.msg( "note", _cmdpre .. v:YRPName() .. " is now the usergroup " .. args[2])
					return
				end
			end
			YRP.msg( "note", _cmdpre .. "Player [" .. args[1] .. "] not found." )
		elseif ply:HasAccess() or ply:IPAddress() == "loopback" then
			--[[ if admin/superadmin/owner tries ]]--
			for k, v in pairs(player.GetAll() ) do
				if string.find(string.lower( v:Nick() ), string.lower( args[1]) ) or string.find(string.lower( v:SteamName() ), string.lower( args[1]) ) then
					v:SetUserGroup( args[2])
					YRP.msg( "note", _cmdpre .. v:YRPName() .. " is now the usergroup " .. args[2])
					return
				end
			end
			YRP.msg( "note", _cmdpre .. args[1] .. " not found." )
		elseif ply:IsPlayer() then
			--[[ if no rcon rights tries ]]--
			message = ply:SteamName() .. " tried to give " .. args[1] .. " the usergroup " .. args[2] .. "."
			YRP.msg( "note", _cmdpre .. message)
		end
	else
		--[[ Failed command ]]--
		if #args > 2 then
			YRP.msg( "note", _cmdpre .. "To much arguments (yrp_usergroup STEAMNAME/RPNAME UserGroup)" )
			YRP.msg( "note", _cmdpre .. "Example: yrp_usergroup \"D4KiR | Arno\" superadmin" )
		else
			YRP.msg( "note", _cmdpre .. "Not enough arguments (yrp_usergroup STEAMNAME/RPNAME UserGroup)" )
			YRP.msg( "note", _cmdpre .. "Example: yrp_usergroup \"D4KiR | Arno\" superadmin" )
		end
	end
end

concommand.Add( "darkrp", function(ply, cmd, args)
	if args[1] and args[1] == "forcerpname" then
		local playername = args[2]
		local newrpname = args[3]

		local player = GetPlayerByName(playername)

		if ea(player) then
			player:SetRPName( newrpname, "darkrp forcerpname" )
		else
			YRP.msg( "note", "[forcerpname] Player not found" )
		end
	elseif args[1] and args[1] == "name" then
		local newrpname = args[2]

		if ea(ply) then
			ply:SetRPName( newrpname, "darkrp name" )
		end
	elseif args[1] and args[1] == "wanted" then
		YRP.msg( "error", "[darkrp] wanted: args[1]: " .. tostring( args[1] ) .. " args[2]: " .. tostring( args[2] ) .. " args[3]: " .. tostring( args[3] ) )
	elseif args[1] and args[1] == "unwanted" then
		YRP.msg( "error", "[darkrp] unwanted: " .. tostring( args[1] ) .. " args[2]: " .. tostring( args[2] ) .. " args[3]: " .. tostring( args[3] ) )
	elseif args[1] and args[1] == "warrant" then
		YRP.msg( "error", "[darkrp] warrant: " .. tostring( args[1] ) .. " args[2]: " .. tostring( args[2] ) .. " args[3]: " .. tostring( args[3] ) )
	elseif args[1] and args[1] == "unwarrant" then
		YRP.msg( "error", "[darkrp] unwarrant: " .. tostring( args[1] ) .. " args[2]: " .. tostring( args[2] ) .. " args[3]: " .. tostring( args[3] ) )
	elseif args[1] and args[1] == "addjailpos" then
		--
	elseif args[1] and args[1] == "unownalldoors" then
		--
	elseif args[1] and args[1] == "cheque" then
		--
	elseif args[1] and args[1] == "dropmoney" then
		YRPDropMoney(ply, args[2])
	elseif args[1] and args[1] == "teamban" then
		--
	elseif args[1] and args[1] == "drop" then
		local _weapon = ply:GetActiveWeapon()
		if _weapon != nil and PlayersCanDropWeapons() then
			if ea(_weapon) then
				ply:DropSWEP( _weapon:GetClass() )
			end
		else
			YRP.msg( "note", ply:YRPName() .. " drop weapon is disabled!" )
		end
	elseif args[1] and jobByCmd[args[1]] then
		local jobtab = RPExtraTeams[jobByCmd[args[1]]]
		if jobtab then
			if GetGlobalYRPBool( "bool_players_die_on_role_switch", false) then
				ply:OldKillSilent()
			end
			YRPSetRole(ply, jobtab.uniqueID)
			if GetGlobalYRPBool( "bool_players_die_on_role_switch", false) then
				ply:Spawn()
			end
		end
	else
		YRP.msg( "error", "[darkrp] console command: args[1]: " .. tostring( args[1] ) .. " args[2]: " .. tostring( args[2] ) .. " args[3]: " .. tostring( args[3] ) )
	end
end)

concommand.Add( "yrp_force_sqlite", function(ply, cmd, args)
	SetSQLMode(0, true)

	timer.Simple(1, function()
		game.ConsoleCommand( "changelevel " .. game.GetMap() .. "\n" )
	end)
end)

concommand.Add( "yrp_usergroup", function(ply, cmd, args)
	YRPChangeUserGroup(ply, cmd, args)
end)

concommand.Add( "yrp_givelicense", function(ply, cmd, args)
	if #args != 2 then
		YRP.msg( "note", "to much/less commands" )
	end

	local name = args[1]
	local lname = args[2]

	local ply = GetPlayerByName(name)

	local lid = GetLicenseIDByName(lname)

	if IsValid(ply) and wk(lid) then
		GiveLicense(ply, lid)
	else
		YRP.msg( "note", "[yrp_givelicense] Not found" )
	end
end)

concommand.Add( "yrp_allowallcountries", function(ply, cmd, args)
	SetGlobalYRPBool( "yrp_allowallcountries", !GetGlobalYRPBool( "yrp_allowallcountries", false ) )

	MsgC( Color( 255, 255, 0 ), "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -" .. "\n" )
	if GetGlobalYRPBool( "yrp_allowallcountries", false ) then
		MsgC( YRPColGreen(), "[YourRP] Allow All Countries is Enabled." .. "\n" )
	else
		MsgC( YRPColGreen(), "[YourRP] Allow All Countries is Disabled." .. "\n" )
	end
	MsgC( Color( 255, 255, 0 ), "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -" .. "\n" )
end)

