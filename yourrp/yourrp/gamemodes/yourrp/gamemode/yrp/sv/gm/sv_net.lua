--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
YRP:AddNetworkString("nws_yrp_restartServer")
YRP:AddNetworkString("nws_yrp_updateServer")
YRP:AddNetworkString("nws_yrp_cancelRestartServer")
--Restart Server
net.Receive(
	"nws_yrp_restartServer",
	function(len, ply)
		if not ply:HasAccess("nws_yrp_restartServer") then return end
		YRP:msg("gm", "RunConsoleCommand(map)")
		RunConsoleCommand("map", game.GetMap())
	end
)

net.Receive(
	"nws_yrp_updateServer",
	function(len, ply)
		if not ply:HasAccess("nws_yrp_updateServer") then return end
		local _tmpString = net.ReadString()
		local _result = YRP_SQL_UPDATE(
			"yrp_general",
			{
				["text_gamemode_name"] = _tmpString
			}
		)

		local countdown = net.ReadInt(16)
		timer.Create(
			"timerRestartServer",
			1,
			0,
			function()
				local message = "Updating Server in " .. countdown .. " seconds"
				if countdown == 0 then
					message = "Server is updating."
				end

				if countdown > 10 then
					if (countdown % 10) == 0 then
						PrintMessage(HUD_PRINTCENTER, message)
						YRP:msg("server", message)
					end
				elseif countdown <= 10 then
					PrintMessage(HUD_PRINTCENTER, message)
					YRP:msg("server", message)
				end

				countdown = countdown - 1
				if countdown == -1 then
					timer.Remove("timerRestartServer")
					game.ConsoleCommand("changelevel " .. GetMapNameDB() .. "\n")
				end
			end
		)
	end
)

net.Receive(
	"nws_yrp_cancelRestartServer",
	function(len, ply)
		if not ply:HasAccess("nws_yrp_cancelRestartServer") then return end
		timer.Remove("timerRestartServer")
		local message = "Restart Server CANCELED!"
		PrintMessage(HUD_PRINTCENTER, message)
		YRP:msg("server", message)
	end
)

function YRPChangeUserGroup(ply, cmd, args)
	YRP:msg("note", "This Command (yrp_usergroup) is only for this round!")
	YRP:msg("note", "Use an admin tool to make yourself permanent to an UserGroup")
	local _cmdpre = "[" .. string.upper("yrp_usergroup") .. "] "
	local message = ""
	if #args == 2 then
		if not ply:IsPlayer() then
			--[[ if server tries ]]
			--
			for k, v in pairs(player.GetAll()) do
				if string.find(string.lower(v:Nick()), string.lower(args[1]), 1, true) or string.find(string.lower(v:SteamName()), string.lower(args[1]), 1, true) then
					v:SetUserGroup(args[2])
					YRP:msg("note", _cmdpre .. v:YRPName() .. " is now the usergroup " .. args[2])

					return
				end
			end

			YRP:msg("note", _cmdpre .. "Player [" .. args[1] .. "] not found.")
		elseif ply:HasAccess("YRPChangeUserGroup", true) or ply:IPAddress() == "loopback" then
			--[[ if admin/superadmin/owner tries ]]
			--
			for k, v in pairs(player.GetAll()) do
				if string.find(string.lower(v:Nick()), string.lower(args[1]), 1, true) or string.find(string.lower(v:SteamName()), string.lower(args[1]), 1, true) then
					v:SetUserGroup(args[2])
					YRP:msg("note", _cmdpre .. v:YRPName() .. " is now the usergroup " .. args[2])

					return
				end
			end

			YRP:msg("note", _cmdpre .. args[1] .. " not found.")
		elseif ply:IsPlayer() then
			--[[ if no rcon rights tries ]]
			--
			message = ply:SteamName() .. " tried to give " .. args[1] .. " the usergroup " .. args[2] .. "."
			YRP:msg("note", _cmdpre .. message)
		end
	else
		--[[ Failed command ]]
		--
		if #args > 2 then
			YRP:msg("note", _cmdpre .. "To much arguments (yrp_usergroup STEAMNAME/RPNAME UserGroup)")
			YRP:msg("note", _cmdpre .. "Example: yrp_usergroup \"D4KiR | Arno\" superadmin")
		else
			YRP:msg("note", _cmdpre .. "Not enough arguments (yrp_usergroup STEAMNAME/RPNAME UserGroup)")
			YRP:msg("note", _cmdpre .. "Example: yrp_usergroup \"D4KiR | Arno\" superadmin")
		end
	end
end

local unhandled = {}
unhandled["addjailpos"] = true
unhandled["unownalldoors"] = true
unhandled["cheque"] = true
unhandled["admintellall"] = true
unhandled["energy"] = true
unhandled["teamban"] = true
concommand.Add(
	"darkrp",
	function(ply, cmd, args)
		if args[1] and strEmpty(args[1]) then return end
		if args[1] then
			args[1] = string.lower(args[1])
		end

		if args[1] and args[1] == "forcerpname" then
			local playername = args[2]
			local newrpname = args[3]
			local pl = YRPGetPlayerByName(playername)
			if YRPEntityAlive(pl) then
				pl:SetRPName(newrpname, "darkrp forcerpname")
			else
				YRP:msg("note", "[forcerpname] Player not found")
			end
		elseif args[1] and args[1] == "name" then
			local newrpname = args[2]
			if YRPEntityAlive(ply) then
				ply:SetRPName(newrpname, "darkrp name")
			end
		elseif args[1] and args[1] == "wanted" then
			YRP:msg("note", "[darkrp] wanted: args[1]: " .. tostring(args[1]) .. " args[2]: " .. tostring(args[2]) .. " args[3]: " .. tostring(args[3]))
		elseif args[1] and args[1] == "unwanted" then
			YRP:msg("note", "[darkrp] unwanted: " .. tostring(args[1]) .. " args[2]: " .. tostring(args[2]) .. " args[3]: " .. tostring(args[3]))
		elseif args[1] and args[1] == "warrant" then
			YRP:msg("note", "[darkrp] warrant: " .. tostring(args[1]) .. " args[2]: " .. tostring(args[2]) .. " args[3]: " .. tostring(args[3]))
		elseif args[1] and args[1] == "unwarrant" then
			YRP:msg("note", "[darkrp] unwarrant: " .. tostring(args[1]) .. " args[2]: " .. tostring(args[2]) .. " args[3]: " .. tostring(args[3]))
		elseif args[1] and args[1] == "dropmoney" then
			YRPDropMoney(ply, args[2])
		elseif args[1] and args[1] == "job" then
			YRP:msg("note", string.format("%s tried to change job/role", ply:SteamName()))
		elseif args[1] and args[1] == "job" then
			local playername = args[2]
			local rolename = args[3]
			if playername and rolename then
				local p = YRPGetPlayerByName(playername)
				local rid = _G["TEAM_" .. string.upper(rolename)]
				if p and rid then
					YRPSetRole("darkrp - job", p, rid)
				else
					YRP:msg("error", "playername: " .. tostring(playername) .. " p: " .. tostring(p) .. " rid: " .. tostring(rid) .. " rolename: " .. tostring(rolename))
				end
			end

			YRP:msg("note", string.format("%s tried to change job/role", ply:SteamName()))
		elseif args[1] and args[1] == "drop" then
			local _weapon = ply:GetActiveWeapon()
			if _weapon ~= nil and PlayersCanDropWeapons() then
				if YRPEntityAlive(_weapon) then
					ply:DropSWEP(_weapon:GetClass())
				end
			else
				YRP:msg("note", ply:YRPName() .. " drop weapon is disabled!")
			end
		elseif args[1] and jobByCmd[string.upper(args[1])] then
			local jobtab = RPExtraTeams[jobByCmd[string.upper(args[1])]]
			if jobtab then
				if GetGlobalYRPBool("bool_players_die_on_role_switch", false) then
					ply:KillSilent()
				end

				YRPSetRole("darkrp", ply, jobtab.uniqueID)
				if GetGlobalYRPBool("bool_players_die_on_role_switch", false) then
					ply:Spawn()
				end
			end
		elseif args[1] and unhandled[args[1]] == nil then
			if args[1] and not string.StartsWith(string.lower(args[1]), "team_") then
				YRP:msg("error", "[darkrp] console command: args[1]: " .. tostring(args[1]) .. " args[2]: " .. tostring(args[2]) .. " args[3]: " .. tostring(args[3]))
			end
		end
	end
)

concommand.Add(
	"yrp_force_sqlite",
	function(ply, cmd, args)
		SetSQLMode(0, true)
		timer.Simple(
			1,
			function()
				game.ConsoleCommand("changelevel " .. game.GetMap() .. "\n")
			end
		)
	end
)

concommand.Add(
	"yrp_usergroup",
	function(ply, cmd, args)
		YRPChangeUserGroup(ply, cmd, args)
	end
)

concommand.Add(
	"yrp_givelicense",
	function(ply, cmd, args)
		if #args ~= 2 then
			YRP:msg("note", "to much/less commands")
		end

		local name = args[1]
		local lname = args[2]
		local pl = YRPGetPlayerByName(name)
		local lid = GetLicenseIDByName(lname)
		if IsValid(pl) and IsNotNilAndNotFalse(lid) then
			GiveLicense(pl, lid)
		else
			YRP:msg("note", "[yrp_givelicense] Not found")
		end
	end
)

concommand.Add(
	"yrp_allowallcountries",
	function(ply, cmd, args)
		SetGlobalYRPBool("yrp_allowallcountries", not GetGlobalYRPBool("yrp_allowallcountries", false))
		MsgC(Color(255, 255, 0), "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -" .. "\n")
		if GetGlobalYRPBool("yrp_allowallcountries", false) then
			MsgC(Color(0, 255, 0), "[YourRP] Allow All Countries is Enabled." .. "\n")
		else
			MsgC(Color(0, 255, 0), "[YourRP] Allow All Countries is Disabled." .. "\n")
		end

		MsgC(Color(255, 255, 0), "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -" .. "\n")
	end
)
