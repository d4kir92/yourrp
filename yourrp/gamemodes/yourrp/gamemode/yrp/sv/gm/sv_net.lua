--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

util.AddNetworkString("restartServer")
util.AddNetworkString("updateServer")
util.AddNetworkString("cancelRestartServer")

util.AddNetworkString("get_workshop_collection")
net.Receive("get_workshop_collection", function(len, ply)
	local _wscnr = SQL_SELECT("yrp_general", "text_server_collectionid", "uniqueID = '1'")
	if wk(_wscnr) then
		_wscnr = _wscnr[1].text_server_collectionid
	end
	local _wsc = engine.GetAddons()
	net.Start("get_workshop_collection")
		net.WriteString(_wscnr)
		net.WriteTable(_wsc)
	net.Send(ply)
end)

--Restart Server
net.Receive("restartServer", function(len, ply)
	if ply:HasAccess() then
		YRP.msg("gm", "RunConsoleCommand(_restart)")
		RunConsoleCommand("_restart")
	end
end)

net.Receive("updateServer", function(len, ply)
	if ply:HasAccess() then
		local _tmpString = net.ReadString()
		local _result = SQL_UPDATE("yrp_general", {["text_gamemode_name"] = _tmpString})
		if worked(_result, "text_gamemode_name failed") then
		end
		local countdown = net.ReadInt(16)
		timer.Create("timerRestartServer", 1, 0, function()
			local message = "Updating Server in " .. countdown .. " seconds"
			if countdown == 0 then
				message = "Server is updating."
			end
			if countdown > 10 then
				if (countdown%10) == 0 then
					PrintMessage(HUD_PRINTCENTER, message)
					YRP.msg("server", message)
				end
			elseif countdown <= 10 then
				PrintMessage(HUD_PRINTCENTER, message)
				YRP.msg("server", message)
			end
			countdown = countdown - 1
			if countdown == -1 then
				timer.Remove("timerRestartServer")
				game.ConsoleCommand("changelevel " .. GetMapNameDB() .. "\n")
			end
		end)
	end
end)

net.Receive("cancelRestartServer", function(len, ply)
	if ply:HasAccess() then
		timer.Remove("timerRestartServer")
		local message = "Restart Server CANCELED!"
		PrintMessage(HUD_PRINTCENTER, message)
		YRP.msg("server", message)
	end
end)

function changeUserGroup(ply, cmd, args)
	YRP.msg("note", "This Command (yrp_usergroup) is only for this round!")
	YRP.msg("note", "Use an admin tool to make yourself permanent to an UserGroup")
	local _cmdpre = "[" .. string.upper("yrp_usergroup") .. "] "
	local message = ""
	if #args == 2 then
		if !ply:IsPlayer() then
			--[[ if server tries ]]--
			for k, v in pairs(player.GetAll()) do
				if string.find(string.lower(v:Nick()), string.lower(args[1])) or string.find(string.lower(v:SteamName()), string.lower(args[1])) then
					v:SetUserGroup(args[2])
					YRP.msg("note", _cmdpre .. v:YRPName() .. " is now the usergroup " .. args[2])
					return
				end
			end
			YRP.msg("note", _cmdpre .. "Player [" .. args[1] .. "] not found.")
		elseif ply:HasAccess() or ply:IPAddress() == "loopback" then
			--[[ if admin/superadmin/owner tries ]]--
			for k, v in pairs(player.GetAll()) do
				if string.find(string.lower(v:Nick()), string.lower(args[1])) or string.find(string.lower(v:SteamName()), string.lower(args[1])) then
					v:SetUserGroup(args[2])
					YRP.msg("note", _cmdpre .. v:YRPName() .. " is now the usergroup " .. args[2])
					return
				end
			end
			YRP.msg("note", _cmdpre .. args[1] .. " not found.")
		elseif ply:IsPlayer() then
			--[[ if no rcon rights tries ]]--
			message = ply:SteamName() .. " tried to give " .. args[1] .. " the usergroup " .. args[2] .. "."
			YRP.msg("note", _cmdpre .. message)
		end
	else
		--[[ Failed command ]]--
		if #args > 2 then
			YRP.msg("note", _cmdpre .. "To much arguments (yrp_usergroup STEAMNAME/RPNAME UserGroup)")
			YRP.msg("note", _cmdpre .. "Example: yrp_usergroup \"D4KiR | Arno\" superadmin")
		else
			YRP.msg("note", _cmdpre .. "Not enough arguments (yrp_usergroup STEAMNAME/RPNAME UserGroup)")
			YRP.msg("note", _cmdpre .. "Example: yrp_usergroup \"D4KiR | Arno\" superadmin")
		end
	end
end

concommand.Add("darkrp", function(ply, cmd, args)
	if args[1] and args[1] == "forcerpname" then
		local playername = args[2]
		local newrpname = args[3]

		local player = GetPlayerByName(playername)

		if ea(player) then
			player:SetRPName(newrpname, "console forcerpname")
		else
			YRP.msg("note", "[forcerpname] Player not found")
		end
	else
		YRP.msg("error", "[darkrp] Missing console command in yourrp, please tell dev")
		YRP.msg("error", "[darkrp] args[1] " .. tostring(args[1]))
	end
end)

concommand.Add("yrp_force_sqlite", function(ply, cmd, args)
	SetSQLMode(0, true)

	timer.Simple(1, function()
		game.ConsoleCommand("changelevel " .. game.GetMap() .. "\n")
	end)
end)

concommand.Add("yrp_usergroup", function(ply, cmd, args)
	changeUserGroup(ply, cmd, args)
end)

concommand.Add("yrp_givelicense", function(ply, cmd, args)
	if #args != 2 then
		YRP.msg("note", "to much/less commands")
	end

	local name = args[1]
	local lname = args[2]

	local ply = GetPlayerByName(name)

	local lid = GetLicenseIDByName(lname)

	if IsValid(ply) and wk(lid) then
		GiveLicense(ply, lid)
	else
		YRP.msg("note", "[yrp_givelicense] Not found")
	end
end)


