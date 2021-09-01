--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

if SERVER then
	local posturl = "https://docs.google.com/forms/u/0/d/e/1FAIpQLSe9Po-FzCYFCNIlXbZfywXOIPooZ48_FqvEAwHrnRdTBolmHg/formResponse"
	function SendServerInfo()
		if game.IsDedicated() then
			if GAMEMODE then
				YRP.msg("note", "SendServerInfo")
				local entry = {}

				-- IP
				entry["entry.447060141"] = tostring(game.GetIPAddress())

				-- Servername
				entry["entry.38355044"] = "SN:" .. tostring(GetHostName())

				-- Gamemodename
				entry["entry.809731523"] = "GN:" .. GetGlobalString("text_gamemode_name", "lol")

				-- MaxPlayers
				entry["entry.1368236947"] = tostring(game.MaxPlayers())

				-- VERSION
				entry["entry.1556630983"] = tostring(GAMEMODE.VersionStable)
				entry["entry.1322118780"] = tostring(GAMEMODE.VersionBeta)
				entry["entry.1406407238"] = tostring(GAMEMODE.VersionCanary)
				entry["entry.1022287670"] = tostring(GAMEMODE.VersionBuild)

				-- CollectionID
				entry["entry.1569548085"] = tostring(YRPCollectionID())

				http.Post(posturl, entry,
				function(body, length, headers, code)
					if code == 200 then
						-- worked
					else
						YRP.msg("error", "SendServerInfo failed: " .. "HTTP " .. tostring(code))
					end
				end,
				function( failed )
					YRP.msg("error", "SendServerInfo failed: " .. tostring(failed))
				end)
			else
				timer.Simple(1, SendServerInfo)
			end
		end
			
		if table.Count(player.GetAll()) <= 0 then
			RunConsoleCommand("sv_hibernate_think", 0)
		end
	end

	hook.Add("PostGamemodeLoaded", "yrp_PostGamemodeLoaded", function()
		RunConsoleCommand("sv_hibernate_think", 1)
		timer.Simple(2, function()
			MsgC(Color(255, 255, 0), ">>> Server is online <<<\n")
		end)
		timer.Simple(10, SendServerInfo)
	end)
end
