--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

if SERVER then
	local posturl = "https://docs.google.com/forms/u/0/d/e/1FAIpQLSe9Po-FzCYFCNIlXbZfywXOIPooZ48_FqvEAwHrnRdTBolmHg/formResponse"
	function SendServerInfo()
		if game.IsDedicated() then
			if GAMEMODE then
				YRP.msg("note", "> Send Server Info <")
				local entry = {}

				-- IP
				entry["entry.447060141"] = tostring(game.GetIPAddress())

				-- Servername
				if !strEmpty(GetHostName()) then
					entry["entry.38355044"] = "SN:" .. tostring(GetHostName())
				else
					entry["entry.38355044"] = "SN:" .. tostring(YRPGetHostName())
				end

				-- Gamemodename
				entry["entry.809731523"] = "GN:" .. GetGlobalString("text_gamemode_name", "lol")

				-- MaxPlayers
				entry["entry.1368236947"] = tostring(game.MaxPlayers())

				-- Version
				entry["entry.1556630983"] = tostring(GAMEMODE.VersionStable)
				entry["entry.1322118780"] = tostring(GAMEMODE.VersionBeta)
				entry["entry.1406407238"] = tostring(GAMEMODE.VersionCanary)
				entry["entry.1022287670"] = tostring(GAMEMODE.VersionBuild)

				-- ART (GITHUB, WORKSHOP)
				entry["entry.858261986"] = "VA:" .. tostring(VERSIONART)

				-- CollectionID
				entry["entry.1569548085"] = tostring(YRPCollectionID())

				http.Post(posturl, entry,
				function(body, length, headers, code)
					if code == 200 then
						-- worked
						YRP.msg("note", "Send Server Info: Success")
					else
						YRP.msg("error", "Send Server Info HTTP CODE: " .. tostring(code))
					end
				end,
				function( failed )
					YRP.msg("error", "Send Server Info failed: " .. tostring(failed))
				end)
			else
				timer.Simple(1, SendServerInfo)
			end
		end
			
		RunConsoleCommand("sv_hibernate_think", 0)
	end

	hook.Add("PostGamemodeLoaded", "yrp_PostGamemodeLoaded", function()
		RunConsoleCommand("sv_hibernate_think", 1)
		timer.Simple(2, function()
			MsgC( Color(255, 255, 0), ">>> Server is online <<<" .. "\t\t\tYourRP Version: " .. YRPGetVersionFull() .. "\n" )
		end)
		timer.Simple(10, SendServerInfo)
	end)
end
