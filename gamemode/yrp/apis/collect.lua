--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )
--local _url1 = "https://docs.google.com/forms/d/e/1FAIpQLSe9L51y9uV7EExUuxE2VWuwWagVpLMO-BDD8OXEaXTr2u1rUw/formResponse"
--local _url2 = "https://docs.google.com/forms/d/e/1FAIpQLSfJfrnPqXh91wYsWUByr1S1lAQjfNH047NA12CEDCMINdwnhw/formResponse"

if SERVER then
	function ServerHasPassword()
		if GetConVar("sv_password"):GetString() ~= "" then
			return true
		else
			return false
		end
	end

	--[[
	function send_server_info(status, time)
		if isnumber(time) then
			local _sec = time % 60
			local _min = (time - _sec) / 60
			status = status .. " ("

			if _min > 0 then
				status = status .. " " .. tostring(_min) .. " " .. lang_string("minutes")
			end

			if _sec ~= 0 then
				status = status .. " " .. tostring(_sec) .. " " .. lang_string("seconds")
			end

			status = status .. " )"
		end

		--printGM( "db", "[Send Server Info: " .. tostring( status ) .. "]" )
		local entry = {}

		timer.Create("wait_for_server", 1, 0, function()
			if gmod.GetGamemode() ~= nil and game.GetIPAddress() ~= "0.0.0.0:0" and not game.SinglePlayer() then
				if game.IsDedicated() then
					entry["entry.1233170431"] = GetHostName() or "UNKNOWN"
					entry["entry.524147216"] = game.GetIPAddress() or "UNKNOWN"
					entry["entry.1924789651"] = gmod.GetGamemode().rpbase or "UNKNOWN"
					entry["entry.2036955482"] = gmod.GetGamemode().Version or "UNKNOWN"
					entry["entry.1879186298"] = string.upper(tostring(gmod.GetGamemode().VersionSort)) or "UNKNOWN"
					entry["entry.989542136"] = GetMapName() or "UNKNOWN"
					entry["entry.1836113647"] = gmod.GetGamemode():GetGameDescription() or "UNKNOWN"
					entry["entry.1862304741"] = tostring(game.MaxPlayers()) or "UNKNOWN"
					entry["entry.1969171778"] = tostring(#player.GetAll()) or "UNKNOWN"
					entry["entry.1821263531"] = string.upper(tostring(game.IsDedicated())) or "UNKNOWN"
					entry["entry.452849918"] = string.upper(tostring(ServerHasPassword()))

					http.Post(_url1, entry, function(result)
					end, function(failed)
						printGM("note", "Collect-API 1: " .. tostring(failed))
					end)
				else
					entry["entry.1233170431"] = GetHostName() or "UNKNOWN"
					entry["entry.524147216"] = game.GetIPAddress() or "UNKNOWN"
					entry["entry.1924789651"] = gmod.GetGamemode().rpbase or "UNKNOWN"
					entry["entry.2036955482"] = gmod.GetGamemode().Version or "UNKNOWN"
					entry["entry.1879186298"] = string.upper(tostring(gmod.GetGamemode().VersionSort)) or "UNKNOWN"
					entry["entry.989542136"] = GetMapName() or "UNKNOWN"
					entry["entry.1836113647"] = gmod.GetGamemode():GetGameDescription() or "UNKNOWN"
					entry["entry.1862304741"] = tostring(game.MaxPlayers()) or "UNKNOWN"
					entry["entry.1969171778"] = tostring(#player.GetAll()) or "UNKNOWN"
					entry["entry.1821263531"] = string.upper(tostring(game.IsDedicated())) or "UNKNOWN"

					http.Post(_url2, entry, function(result)
					end, function(failed)
						printGM("note", "Collect-API 2: " .. tostring(failed))
					end)
				end

				timer.Remove("wait_for_server")
			end
		end)
	end

	local _tick = 5 * 60 - 1

	timer.Create("update_server_info", _tick, 0, function()
		send_server_info("auto", _tick)
	end)

	timer.Simple(10, function()
		send_server_info("startup")
	end)
	]]--
end
