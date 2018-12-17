--Copyright (C) 2017-2018 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local _text = {}
_text.pre = "#YRP# "
_text.gmname = "YourRP"
_text.loaddb = "LOAD DB: "
_text.successdb = " created successfully."
_text.spacePre = "\n__________________________________________________________________________[" .. "YRP" .. "]_"
_text.spacePos = "¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯[" .. "YRP" .. "]¯\n"

function hr()
	print("- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -")
end

function hr_pre()
	print(_text.spacePre)
end

function hr_pos()
	print(_text.spacePos)
end

function bool_status(b)
	if tobool(b) then
		return YRP.lang_string("LID_enabled")
	elseif !tobool(b) then
		return YRP.lang_string("LID_disabled")
	end
end

local darkrp_debug = false
function printGM(channel, text)
	local _realm = "SHARED"
	local _string = tostring(text)
	if _string != "nil" then
		local _pool = "unknown"
		if SERVER then
			_pool = "sv"
		elseif CLIENT then
			_pool = "cl"
		end

		local _tmpText = string.Explode("\n", _string)

		local _color = Color(255, 0, 0)
		local _color2 = Color(255, 0, 0)
		local _color3 = Color(255, 0, 0)

		local _channelName = "FAIL"
		if CLIENT then
			_color = Color(255, 222, 102)
			_realm = "CLIENT"
		elseif SERVER then
			_color = Color(137, 222, 255)
			_realm = "SERVER"
		end
		_color3 = _color

		if channel == "note" then
			_color2 = Color(255, 120, 0)
			_channelName = "NOTE"
		elseif channel == "db" then
			_color2 = Color(255, 255, 0)
			_channelName = "DB:" .. tostring(GetSQLModeName())
		elseif channel == "server" then
			_color2 = Color(255, 255, 0)
			_channelName = "SV"
		elseif channel == "admin" then
			_color2 = Color(255, 255, 0)
			_channelName = "ADMIN"
		elseif channel == "gm" then
			_color2 = Color(255, 255, 0)
			_channelName = "GM"
		elseif channel == nil then
			_color2 = Color(255, 255, 0)
			_channelName = ""
		elseif channel == "instructor" then
			_color2 = Color(255, 255, 0)
			_channelName = "INSTRUCTOR"
		elseif channel == "error" then
			_color2 = Color(255, 0, 0)
			_channelName = "!ERROR!"
			_color3 = _color2
			send_errors(_realm, _tmpText)
		elseif channel == "lang" then
			_color2 = Color(255, 255, 0)
			_channelName = "LANG"
		elseif channel == "darkrp" then
			_color2 = Color(255, 0, 0)
			_channelName = "DarkRP-Int."
			if !darkrp_debug then
				return
			end
		end
		for k, v in pairs(_tmpText) do
			if _channelName != "" then
				MsgC(_color, "[", Color(255, 255, 0), _text.gmname, _color, "|", _color2, _channelName, _color, "] ", _color3, v)
				MsgC("\n")
			else
				MsgC(_color, "[", Color(255, 255, 0), _text.gmname, _color, "] ", _color3, v)
				MsgC("\n")
			end
		end
	end
end

function printTab(table, name)
	hr_pre()
	local _header = "PrintTable: "
	name = name or ""
	if name != "" then
		name = name .. " "
	end
	_header = _header .. name .. "(" .. tostring(table) .. ")"
	printGM("note", _header)

	if istable(table) then
		PrintTable(table)
	else
		printGM("note", "printTab " .. tostring(table) .. " is not a table!")
	end
	hr_pos()
end
