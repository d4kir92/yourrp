--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local function YRPHasPassword()
	local pw = GetConVar("sv_password")
	if pw then
		pw = pw:GetString()
		if pw == "" then
			return false
		else
			return true
		end
	end

	return false
end

if SERVER then
	YRP_INFO_WAS_SENDED = YRP_INFO_WAS_SENDED or false
	local posturl = "https://docs.google.com/forms/u/0/d/e/1FAIpQLScCz8AxHm8xMqiPUKWyhHf9qsAWxMcNX1Hy9PvQI5MIcFsh0A/formResponse"
	function YRPSendServerInfo()
		if game.IsDedicated() then
			if GAMEMODE then
				YRP.msg("note", "> Send Server Info <")
				local entry = {}
				-- IP
				entry["entry.2055994870"] = tostring(game.GetIPAddress())
				-- Servername
				if not strEmpty(GetHostName()) then
					entry["entry.1657413344"] = "SN:" .. tostring(GetHostName())
				elseif not strEmpty(YRPGetHostName()) then
					entry["entry.1657413344"] = "SN:" .. tostring(YRPGetHostName())
				else
					entry["entry.1657413344"] = "SN:" .. "BROKEN"
				end

				-- Gamemodename
				entry["entry.893976623"] = "GN:" .. GetGlobalYRPString("text_gamemode_name", "lol")
				-- MaxPlayers
				entry["entry.1756035654"] = tostring(game.MaxPlayers())
				-- Version
				entry["entry.1557578272"] = tostring(GAMEMODE.VersionStable)
				entry["entry.1794275840"] = tostring(GAMEMODE.VersionBeta)
				entry["entry.2054105289"] = tostring(GAMEMODE.VersionCanary)
				entry["entry.422385934"] = tostring(GAMEMODE.VersionBuild)
				-- ART (GITHUB, WORKSHOP)
				entry["entry.646409012"] = "VA:" .. GetGlobalYRPString("YRP_VERSIONART", "X")
				-- CollectionID
				entry["entry.976366368"] = tostring(YRPCollectionID())
				-- Has Password? -- NO SERVER PASSWORD WILL BE SEND HERE, just if it has a password or not
				entry["entry.2007904323"] = string.upper(tostring(YRPHasPassword()))
				if not YRP_INFO_WAS_SENDED then
					http.Post(
						posturl,
						entry,
						function(body, length, headers, code)
							if code == 200 then
								-- worked
								YRP.msg("note", "[Send Server] Info: Success")
								YRP_INFO_WAS_SENDED = true
							else
								YRP.msg("note", "[Send Server] Info HTTP CODE: " .. tostring(code))
							end
						end,
						function(failed)
							YRP.msg("note", "[Send Server] Info failed: " .. tostring(failed))
						end
					)
				else
					YRP.msg("note", "[Send Server] Already Send")
				end
			else
				timer.Simple(1, YRPSendServerInfo)
			end
		end
	end

	hook.Add(
		"PostGamemodeLoaded",
		"yrp_PostGamemodeLoaded",
		function()
			RunConsoleCommand("sv_hibernate_think", 1)
			timer.Simple(
				2,
				function()
					MsgC(Color(255, 255, 0), ">>> Server is online <<<" .. "\t\t\tYourRP Version: " .. YRPGetVersionFull() .. "\n")
				end
			)

			timer.Simple(10, YRPSendServerInfo)
		end
	)
end