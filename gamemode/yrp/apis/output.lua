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
	if !isstring(chan) then return false end

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
	local cn = GetChannelName(chan)
	if MSGChannelEnabled(cn) then
		print(_text.spacePre)
	end
end

function hr_pos(chan)
	local cn = GetChannelName(chan)
	if MSGChannelEnabled(cn) then
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

--local r = GetRealm()
local rc = GetRealmColor()
local _msgcache = {}
function YRP.msg(chan, msg, tochat)
	if !isstring(chan) then return false end
	if !isstring(msg) then return false end

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
			if cn == "DB" then
				MsgC(cc, ":" .. GetSQLModeName())
			end
			MsgC(rc, "] ")

			MsgC(rc, msg)

			MsgC("\n")

			local str = "[" .. _yrp .. "|" .. cn .. "] " .. msg
			if tochat and SERVER then
				PrintMessage(3, "\n ")
				PrintMessage(3, str)
			end
			if SERVER then
				if AddToFakeServerConsole != nil then
					AddToFakeServerConsole(str)
				end
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

local countries = {}
countries["AT"] = "Austria"
countries["AU"] = "Australia"

countries["BE"] = "Belgium"
countries["BR"] = "Brazil"

countries["CA"] = "Canada"
countries["CH"] = "Switzerland"
countries["CN"] = "China"
countries["CZ"] = "Czech Republic"

countries["DE"] = "Germany"
countries["DK"] = "Denmark"

countries["EG"] = "Egypt"
countries["ES"] = "Spain"

countries["FR"] = "France"

countries["GB"] = "Great Britain"
countries["GG"] = "Guernsey"
countries["GR"] = "Greece"

countries["HU"] = "Hungary"

countries["IE"] = "Ireland"
countries["IT"] = "Italy"

countries["JP"] = "Japan"

countries["KZ"] = "Kazakhstan"

countries["MX"] = "Mexico"

countries["NL"] = "Netherlands"
countries["NZ"] = "New Zealand"

countries["PL"] = "Poland"
countries["PT"] = "Portugal"

countries["RO"] = "Romania"
countries["RU"] = "Russia"

countries["SE"] = "Sweden"

countries["TH"] = "Thailand"
countries["TR"] = "Turkey"
countries["TW"] = "Taiwan"

countries["UA"] = "Ukraine"
countries["US"] = "USA"
function GetCountryName(id)
	id = string.upper(id)
	local countryname = countries[id]
	if wk(countryname) then
		return countryname
	else
		return id
	end
end
