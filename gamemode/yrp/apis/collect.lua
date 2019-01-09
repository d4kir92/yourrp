--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

if SERVER then
	function ServerHasPassword()
		if GetConVar("sv_password"):GetString() != "" then
			return true
		else
			return false
		end
	end

	function SendServerInfo(sv)
		if game.IsDedicated() and !game.SinglePlayer() and !ServerHasPassword() then
			printGM("db", "[ServerInfo] Sending")

			local entry = {}
			entry["entry.1546304774"] = sv.ip
			entry["entry.701722785"] = sv.name
			entry["entry.2033271728"] = sv.game
			entry["entry.10628146"] = sv.maxplayers
			entry["entry.1206099686"] = sv.collectionid
			entry["entry.303744727"] = sv.versionid
			entry["entry.1940143037"] = sv.versionstable
			entry["entry.2104377567"] = sv.versionbeta
			entry["entry.1969286222"] = sv.versioncanary
			entry["entry.398751929"] = sv.art

			local url = "https://docs.google.com/forms/d/e/1FAIpQLSdmM5ZkekAXvtf1RMsPI7ZJeetqyFb5L06vjAuFmHNx96_MEQ/formResponse"
			http.Post(url, entry, function(result)
				printGM("db", "[ServerInfo] Success")
			end, function(failed)
				printGM("note", "[ServerInfo] FAILED: " .. tostring(failed))
			end)
		elseif game.IsDedicated() and !game.SinglePlayer() and ServerHasPassword() then
			printGM("db", "[ServerInfo] Server has password => not setting in public list.")

			local entry = {}
			entry["entry.1546304774"] = sv.ip
			entry["entry.701722785"] = sv.name
			entry["entry.2033271728"] = sv.game
			entry["entry.10628146"] = sv.maxplayers
			entry["entry.1206099686"] = sv.collectionid
			entry["entry.1981636793"] = sv.versionid
			entry["entry.1940143037"] = sv.versionstable
			entry["entry.1026307624"] = sv.versionbeta
			entry["entry.167550390"] = sv.versioncanary
			entry["entry.398751929"] = sv.art

			local url = "https://docs.google.com/forms/d/e/1FAIpQLSdGoAN4FbsiuVdhKFSr88zmHZ5DAbdFOLU7QBgDyv7TIZFduA/formResponse"
			http.Post(url, entry, function(result)
				--printGM("db", "[ServerInfo] Success")
			end, function(failed)
				printGM("error", "[ServerInfo] FAILED: " .. tostring(failed))
			end)
		elseif !game.IsDedicated() then
			printGM("db", "[ServerInfo] Server is not a dedicated one => not setting public")
		elseif game.SinglePlayer() then
			printGM("db", "[ServerInfo] Server is in singleplayer mode => not setting public")
		end
	end

	function IsServerInfoOutdated()
		printGM("db", "[ServerInfo] IsServerInfoOutdated")
		local url = "https://docs.google.com/spreadsheets/d/16REluG2RFpoHry-S8nQWyO2jRs7ju_yyJFqQqKJ_xQM/edit?usp=sharing"
		http.Fetch(url,
		function(body, len, headers, code)
			local b = body
			b = string.Explode("\n", b)

			local sv = {}
			sv.ip = game.GetIPAddress() or "UNKNOWN"
			sv.name = GetHostName() or "UNKNOWN"
			sv.game = gmod.GetGamemode():GetGameDescription() or "UNKNOWN"
			sv.maxplayers = tostring(game.MaxPlayers()) or "UNKNOWN"
			sv.collectionid = YRPCollectionID() or "0"
			if sv.collectionid == "0" then
				sv.collectionid = ""
			end
			sv.versionid = tostring(gmod.GetGamemode().VersionStable) .. "|" .. tostring(gmod.GetGamemode().VersionBeta) .. "|" .. tostring(gmod.GetGamemode().VersionCanary)
			sv.versionstable = tostring(gmod.GetGamemode().VersionStable)
			sv.versionbeta = tostring(gmod.GetGamemode().VersionBeta)
			sv.versioncanary = tostring(gmod.GetGamemode().VersionCanary)
			sv.art = string.upper(tostring(gmod.GetGamemode().VersionSort)) or "UNKNOWN"

			local utd = {}
			for i, val in pairs(sv) do
				utd[i] = false
			end
			local found = false
			for i, line in pairs(b) do
				if !found then
					for j, val in pairs(sv) do
						local test = string.find(line, val)
						if test != nil then

							local ssub = string.sub(line, test, test + string.len(val) - 1)
							if ssub == sv.ip then
								found = true
								break
							end
						end
					end
					if found then
						for str, val in pairs(sv) do
							local test = string.find(line, val)
							if test != nil then
								utd[str] = true
							end
						end
						break
					end
				end
			end
			for i, val in pairs(utd) do
				if !val then
					SendServerInfo(sv)
					return false
				end
			end
			printGM("db", "[ServerInfo] up to date!")
		end,
		function(e)
			printGM("error", "UpdateServerInfo ERROR: " .. tostring(e))
		end)
	end
end
