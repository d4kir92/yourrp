--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

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

function bool_status(b)
	if tobool(b) then
		return YRP.lang_string("LID_enabled")
	elseif !tobool(b) then
		return YRP.lang_string("LID_disabled")
	end
end

function GetRealm()
	if SERVER then
		return "sv"
	elseif CLIENT then
		return "cl"
	else
		return "sh"
	end
end

function GetRealmColor()
	if SERVER then
		return Color(137, 222, 255)
	elseif CLIENT then
		return Color(255, 222, 102)
	else
		return Color(255, 255, 0)
	end
end

function GetChannelName(chan)
	chan = string.lower(chan)
	if chan == "noti" or chan == "note" or chan == "notification" then
		return "NOTI"
	elseif chan == "db" or chan == "database" then
		return "DB"
	elseif chan == "gm" or chan == "gamemode" then
		return "GM"
	elseif chan == "lang" or chan == "language" then
		return "LANG"
	elseif chan == "chat" then
		return "CHAT"
	elseif chan == "darkrp" or chan == "drp" then
		return "DARKRP"
	elseif chan == "deb" or chan == "debug" then
		return "DEBUG"
	elseif chan == "ptab" then
		return "PRINTTABLE"
	elseif chan == "mis" or chan == "miss" then
		return "MISSING"
	elseif chan == "err" or chan == "error" then
		return "ERROR"
	else
		return string.upper(chan)
	end
end

local channelcolors = {}
channelcolors["noti"] = Color(255, 255, 0)
channelcolors["db"] = Color(0, 255, 0)
channelcolors["gm"] = Color(0, 100, 225)
channelcolors["lang"] = Color(100, 255, 100)
channelcolors["chat"] = Color(0, 0, 255)
channelcolors["debug"] = Color(255, 255, 255)
channelcolors["printtable"] = Color(255, 255, 255)
channelcolors["missing"] = Color(255, 100, 100)
channelcolors["error"] = Color(255, 0, 0)
function GetChannelColor(chan)
	chan = string.lower(chan)
	if channelcolors[chan] != nil then
		return channelcolors[chan]
	else
		return Color(255, 0, 0)
	end
end

local msgchannels = {}
msgchannels["noti"] = true
msgchannels["db"] = true
msgchannels["gm"] = true
msgchannels["lang"] = true
msgchannels["chat"] = true
msgchannels["debug"] = true
msgchannels["printtable"] = true
msgchannels["missing"] = true
msgchannels["error"] = true
function IsChannelRegistered(chan)
	chan = string.lower(chan)
	if msgchannels[chan] then
		return true
	else
		return false
	end
end

function MSGChannelEnabled(chan)
	chan = string.lower(chan)
	if GetGlobalBool("bool_msg_channel_" .. chan, false) or chan == "printtable" or chan == "missing" or chan == "error" then
		return true
	elseif GetGlobalBool("yrp_general_loaded", false) then
		if !IsChannelRegistered(chan) and GetGlobalBool("bool_msg_channel_" .. chan, true) then
			YRP.msg("error", "!!!" .. chan .. "!!!")
		end
		return false
	else
		return true
	end
end

function hr_pre(chan)
	if MSGChannelEnabled(chan) then
		print(_text.spacePre)
	end
end

function hr_pos(chan)
	if MSGChannelEnabled(chan) then
		print(_text.spacePos)
	end
end

function GetGamemodeShortname()
	if GAMEMODE != nil then
		return GAMEMODE.ShortName
	else
		return "YRP"
	end
end

local r = GetRealm()
local rc = GetRealmColor()
local _msgcache = {}
function YRP.msg(chan, msg, tochat)
	local cn = GetChannelName(chan)
	if MSGChannelEnabled(cn) then
		if msg == nil or msg == false then
			msg = tostring(msg)
		end
		local cc = GetChannelColor(cn)
		local _yrp = GetGamemodeShortname()
		local _yrpc = Color(0, 100, 225)

		msgs = string.Explode("\n", msg)
		for i, msg in pairs(msgs) do
			MsgC(rc, "[")
			MsgC(_yrpc, _yrp)
			MsgC(rc, "|")
			MsgC(cc, cn)
			MsgC(rc, "] ")

			MsgC(rc, msg)

			MsgC("\n")

			if tochat and SERVER then
				PrintMessage(3, "\n ")
				PrintMessage(3, "[" .. _yrp .. "|" .. cn .. "] " .. msg)
			end

			if cn == "ERROR" or cn == "MISSING" then
				local REALM = "CLIENT"
				if SERVER then
					REALM = "SERVER"
				end
				send_error(REALM, "[" .. cn .. "] " .. msg)
			end
		end
	end
end

local darkrp_debug = false
function printGM(channel, text, tochat)
	YRP.msg(channel, text, tochat)
	--[[local _realm = "SHARED"
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
	]]--
end

function printTab(table, name)
	hr_pre("debug")
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
	hr_pos("debug")
end
