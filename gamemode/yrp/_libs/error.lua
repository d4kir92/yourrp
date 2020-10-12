--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- #ERROR #BUGS

function wk(obj)
	if obj != nil and obj != false then
		return true
	else
		return false
	end
end

function worked(obj, name, _silence)
	if obj != nil and obj != false then
		return true
	else
		if !_silence then
			YRP.msg("note", "NOT WORKED: " .. tostring(obj) .. " " .. tostring(name))
		end
		return false
	end
end

function ea(ent)
	if tostring(ent) != "[NULL Entity]" and ent != nil and ent != NULL then
		if ent:IsValid() then
			return true
		end
	end
	return false
end

function pa(panel)
	if tostring(panel) != "[NULL Panel]" and panel != nil then
		return true
	end
	return false
end

function check_yrp_sv_errors(str)
	if !file.Exists("yrp/sv_errors.txt", "DATA") then
		if !file.Exists("yrp", "DATA") then
			YRP.msg("db", "yrp existiert nicht")
			file.CreateDir("yrp")
		end
		YRP.msg("db", "yrp/sv_errors.txt existiert nicht")
		file.Write("yrp/sv_errors.txt", 0)
		return false
	end
	return true
end

function check_yrp_cl_errors(str)
	if !file.Exists("yrp/cl_errors.txt", "DATA") then
		if !file.Exists("yrp", "DATA") then
			YRP.msg("db", "yrp existiert nicht")
			file.CreateDir("yrp")
		end
		YRP.msg("db", "yrp/cl_errors.txt existiert nicht")
		file.Write("yrp/cl_errors.txt", 0)
		return false
	end
	return true
end

function yts(str , str2)
	return string.find(string.lower(str), string.lower(str2))
end

function ErrorValidToSend(str)
	str = tostring(str)

	if game.SinglePlayer() then
		return false
	end
	if game.GetIPAddress() == "loopback" then
		return false
	end

	if CLIENT and LocalPlayer():GetDBool("isserverdedicated") == false then
		return false
	elseif SERVER and game.IsDedicated() == false then
		return false
	end

	if string.StartWith(str, "[") and (yts(str, "/yrp/") or yts(str, "yourrp")) and !yts(str, "database or disk is full") and !yts(str , "<eof>") then
		return true
	else
		return false
	end
end

local first_time_error = false
local _sv_errors = {}
function update_error_table_sv()
	local _read = file.Read("lua_errors_server.txt", "GAME")

	if worked(_read, "_read failed", true) then
		local _file_exists = check_yrp_sv_errors(_read)
		if !_file_exists then
			first_time_error = true
		else
			first_time_error = false
		end

		local _yrp_read = file.Read("yrp/sv_errors.txt", "DATA")
		if worked(_yrp_read, "_yrp_read failed") then
			_yrp_read = tonumber(_yrp_read)
			if !isnumber(_yrp_read) then
				file.Write("yrp/sv_errors.txt", 0)
				_yrp_read = 0
			end
			_read = string.Replace(_read, "\r\n\r\n\r\n", "\r\n\r\n")
			local _explode = string.Explode("\r\n\r\n", _read)

			if table.Count(_explode) < _yrp_read then
				--if error file is smaller, update data
				file.Write("yrp/sv_errors.txt", table.Count(_explode))
			elseif table.Count(_explode) > _yrp_read then
				--if error file is bigger, get all errors
				local _errors = {}
				for k, v in pairs(_explode) do
					if k > _yrp_read then
						if !table.HasValue(_errors, v) and !first_time_error then
							if ErrorValidToSend(v) then
								table.insert(_errors, v)
							end
						end
					end
				end

				--update data file
				file.Write("yrp/sv_errors.txt", table.Count(_explode))

				return _errors
			elseif first_time_error then
				--update data file
				file.Write("yrp/sv_errors.txt", table.Count(_explode))
				return _errors
			else
				--YRP.msg("gm", "No new error")
			end
		end
	end
	return {}
end

local _cl_errors = {}
function update_error_table_cl()
	local _read = file.Read("clientside_errors.txt", "GAME")

	if worked(_read, "_read failed", true) then
		local _file_exists = check_yrp_cl_errors(_read)
		if !_file_exists then
			first_time_error = true
		else
			first_time_error = false
		end

		local _yrp_read = file.Read("yrp/cl_errors.txt", "DATA")
		if worked(_yrp_read, "_yrp_read failed") then
			_yrp_read = tonumber(_yrp_read)
			if !isnumber(_yrp_read) then
				file.Write("yrp/sv_errors.txt", 0)
				_yrp_read = 0
			end
			_read = string.Replace(_read, "\r\n\r\n\r\n", "\r\n\r\n")
			local _explode = string.Explode("\r\n\r\n", _read)

			if table.Count(_explode) < _yrp_read then
				--if error file is smaller, update data
				file.Write("yrp/cl_errors.txt", table.Count(_explode))

			elseif table.Count(_explode) > _yrp_read then
				--if error file is bigger, get all errors

				local _errors = {}
				for k, v in pairs(_explode) do
					if k > _yrp_read then
						if !table.HasValue(_errors, v) and !first_time_error then
							if ErrorValidToSend(v) then
								table.insert(_errors, v)
							end
						end
					end
				end

				--update data file
				file.Write("yrp/cl_errors.txt", table.Count(_explode))

				return _errors
			elseif first_time_error then
				--update data file
				file.Write("yrp/cl_errors.txt", table.Count(_explode))
				return _errors
			else
				--YRP.msg("gm", "No new error")
			end
		end
	end
	return {}
end

function isdbfull(str)
	if CLIENT then
		if string.find(str, "full") then
			local FRAME = createD("DFrame", nil, YRP.ctr(1800), YRP.ctr(300), 0, 0)
			FRAME:SetTitle("")
			FRAME:Center()
			FRAME:MakePopup()
			function FRAME:Paint(pw, ph)
				surfaceWindow(self, pw, ph, "INFO")
				surfaceText("YOUR DATABASE IS FULL! (Your Disk)", "Y_22_500", pw/2, YRP.ctr(100), Color(255, 255, 255, 255), 1, 1)
			end
		end
	end
end

function ismalformed(str)
	if string.find(str, "database disk image is malformed") then
		if CLIENT then
			local FRAME = createD("DFrame", nil, YRP.ctr(1800), YRP.ctr(300), 0, 0)
			FRAME:SetTitle("")
			FRAME:Center()
			FRAME:MakePopup()
			function FRAME:Paint(pw, ph)
				surfaceWindow(self, pw, ph, "INFO")
				surfaceText("YOUR DATABASE IS MALFORMED, please join the Discord and tell the DEVs!", "Y_22_500", pw/2, YRP.ctr(100), Color(255, 255, 255, 255), 1, 1)
				surfaceText("Stop Game, delete .../garrysmod/garrysmod/cl.db to fix this problem", "Y_22_500", pw/2, YRP.ctr(150), Color(255, 255, 255, 255), 1, 1)
			end

			FRAME.discord = createD("DButton", FRAME, YRP.ctr(400), YRP.ctr(50), YRP.ctr(900-200), YRP.ctr(200))
			FRAME.discord:SetText("")
			function FRAME.discord:Paint(pw, ph)
				surfaceButton(self, pw, ph, "JOIN DISCORD")
			end
			function FRAME.discord:DoClick()
				gui.OpenURL("https://discord.gg/sEgNZxg")
			end
		end
	end
end

local _url = "https://docs.google.com/forms/d/e/1FAIpQLSdTOU5NjdzpUjOyYbymXOeM3oyFfoVFBNKOAcBZbX3UxgAK6A/formResponse" -- deleted
local _url2 = "https://docs.google.com/forms/d/e/1FAIpQLSdTOU5NjdzpUjOyYbymXOeM3oyFfoVFBNKOAcBZbX3UxgAK6A/formResponse" -- deleted
function send_error(realm, str, force)
	local entry = {}

	local dedi = "UNKNOWN"
	if CLIENT then
		dedi = tostring(LocalPlayer():GetDBool("isserverdedicated"))
	elseif SERVER then
		dedi = tostring(game.IsDedicated())
	end
	dedi = string.upper(dedi)

	--[[if ErrorValidToSend(str) or force then
		timer.Create("wait_for_gamemode" .. str, 1, 0, function()
			if gmod.GetGamemode() != nil and SERVER or (CLIENT and wk(LocalPlayer().LoadedGamemode) and LocalPlayer():LoadedGamemode()) then
				isdbfull(str)
				ismalformed(str)

				if game.GetIPAddress() == "loopback" then
					timer.Remove("wait_for_gamemode" .. str)
					return false
				end

				entry["entry.915525654"] = "[D: " .. tostring(dedi) .. "] " .. tostring(str)
				entry["entry.58745995"] = tostring(realm)
				entry["entry.1306533151"] = GetMapName() or "MAPNAME"
				entry["entry.2006356340"] = gmod.GetGamemode():GetGameDescription() or "GAMEMODENAME"
				entry["entry.1883727441"] = tostring(gmod.GetGamemode().VersionStable)
				entry["entry.1007479965"] = tostring(gmod.GetGamemode().VersionBeta)
				entry["entry.1274096098"] = tostring(gmod.GetGamemode().VersionCanary)
				entry["entry.2045173320"] = string.upper(gmod.GetGamemode().VersionSort) or "UNKNOWN"
				entry["entry.1106559712"] = game.GetIPAddress() or "0.0.0.0:99999"
				entry["entry.1029765769"] = dedi
				if CLIENT then
					local lply = LocalPlayer()
					local _steamid = "UNKNOWN"
					if ea(lply) then
						_steamid = lply:SteamID()
					end
					entry["entry.1898856001"] = tostring(_steamid)
				else
					entry["entry.1898856001"] = "SERVER"
				end

				if first_time_error then
					entry["entry.1893317510"] = "YES"
				elseif !first_time_error then
					entry["entry.1893317510"] = "NO"
				else
					entry["entry.1893317510"] = "-"
				end
				entry["entry.471979789"] = string.upper(tostring(!game.SinglePlayer()))

				if realm != "server_all" then
					-[[http.Post(_url, entry, function(result)
						if result then
							YRP.msg("gm", "[SENT ERROR TO DEVELOPER] " .. str)
						end
					end, function(failed)
						if tostring(failed) != "unsuccessful" then
							YRP.msg("error", "ERROR1: " .. tostring(failed))
						end
					end)
				else
					http.Post(_url2, entry, function(result)
						if result then
							YRP.msg("gm", "[SENT ERROR TO DEVELOPER 2] " .. str)
						end
					end, function(failed)
						if tostring(failed) != "unsuccessful" then
							YRP.msg("error", "ERROR2: " .. tostring(failed))
						end
					end)
				end

				timer.Remove("wait_for_gamemode" .. str)
			end
		end)
	end]]
end

local _sended = {}
function send_errors(realm, tbl)
	if _sended[realm] == nil then
		 _sended[realm] = {}
	end
	for k, v in pairs(tbl) do
		if !table.HasValue(_sended[realm], v) then
			send_error(realm, v)
			table.insert(_sended[realm], v)
		end
	end
end

local tick = 0

function ErrorMod()
	return YRPErrorMod()
end

function CanSendError()
	if !IsYRPOutdated() then
		if game.MaxPlayers() > 1 then
			if CLIENT then
				local lply = LocalPlayer()
				if lply:IsValid() then
					if tick % 10 == 0 then
						return true
					end
				end
			elseif SERVER then
				if tick % 10 == 0 then
					return true
				end
			end
		end
	else
		if tick % 120 == 0 and IsYRPOutdated() != nil then
			if IsYRPOutdated() then
				YRP.msg("note", "Gamemode is outdated!")
			end
		end
	end
	return false
end

function SendAllErrors(str)
	if str != nil then
		--YRP.msg("debug", "[SendAllErrors] " .. str)
	end
	_cl_errors = update_error_table_cl()
	send_errors("client", _cl_errors)

	_sv_errors = update_error_table_sv()
	send_errors("server", _sv_errors)
end

SendAllErrors("instant")

local first = true
timer.Create("update_error_tables", 60, 0, function()
	if first then
		first = false
	else
		if CanSendError() then
			SendAllErrors("update_error_tables")
		end
	end
	tick = tick + 1
end)
