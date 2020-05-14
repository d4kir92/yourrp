--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

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
			YRP.msg("db", "[ServerInfo] Sending...")

			local entry = {}
			entry["entry.1546304774"] = tostring(sv.ip)
			entry["entry.701722785"] = tostring(sv.name)
			entry["entry.2033271728"] = tostring(sv.game)
			entry["entry.10628146"] = tostring(sv.maxplayers)
			entry["entry.1206099686"] = tostring(sv.collectionid)
			entry["entry.303744727"] = tostring(sv.versionid)
			entry["entry.1940143037"] = tostring(sv.versionstable)
			entry["entry.2104377567"] = tostring(sv.versionbeta)
			entry["entry.1969286222"] = tostring(sv.versioncanary)
			entry["entry.398751929"] = tostring(sv.art)

			local url = "https://docs.google.com/forms/d/e/1FAIpQLSdmM5ZkekAXvtf1RMsPI7ZJeetqyFb5L06vjAuFmHNx96_MEQ/formResponse"
			http.Post(url, entry, function(result)
				YRP.msg("db", "[ServerInfo] Success.")
			end, function(failed)
				YRP.msg("note", "[ServerInfo] FAILED: " .. tostring(failed))
			end)
		elseif game.IsDedicated() and !game.SinglePlayer() and ServerHasPassword() then
			YRP.msg("db", "[ServerInfo] Server has password => not setting in public list.")

			local entry = {}
			entry["entry.1546304774"] = tostring(sv.ip)
			entry["entry.701722785"] = tostring(sv.name)
			entry["entry.2033271728"] = tostring(sv.game)
			entry["entry.10628146"] = tostring(sv.maxplayers)
			entry["entry.1206099686"] = tostring(sv.collectionid)
			entry["entry.1981636793"] = tostring(sv.versionid)
			entry["entry.1940143037"] = tostring(sv.versionstable)
			entry["entry.1026307624"] = tostring(sv.versionbeta)
			entry["entry.167550390"] = tostring(sv.versioncanary)
			entry["entry.398751929"] = tostring(sv.art)

			local url = "https://docs.google.com/forms/d/e/1FAIpQLSdGoAN4FbsiuVdhKFSr88zmHZ5DAbdFOLU7QBgDyv7TIZFduA/formResponse"
			http.Post(url, entry, function(result)
				--YRP.msg("db", "[ServerInfo] Success.")
			end, function(failed)
				YRP.msg("error", "[ServerInfo] FAILED: " .. tostring(failed))
			end)
		elseif !game.IsDedicated() then
			YRP.msg("db", "[ServerInfo] Server is not a dedicated one => not setting public")
		elseif game.SinglePlayer() then
			YRP.msg("db", "[ServerInfo] Server is in singleplayer mode => not setting public")
		end
	end

	function IsServerInfoOutdated()
		YRP.msg("db", "[ServerInfo] IsServerInfoOutdated.")
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
							else
								YRP.msg("db", "[ServerInfo] " .. tostring(str) .. " is outdated.")
								utd[str] = false
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
			YRP.msg("db", "[ServerInfo] up to date!")
		end,
		function(e)
			YRP.msg("error", "UpdateServerInfo ERROR: " .. tostring(e))
		end)
	end
end
