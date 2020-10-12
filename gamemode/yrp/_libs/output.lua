--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local _text = {}
_text.pre = "#YRP# "
_text.gmname = "YourRP"
_text.loaddb = "LOAD DB: "
_text.successdb = " created successfully."
_text.spacePre = "\n__________________________________________________________________________[" .. "YRP" .. "]_"
_text.spacePos = "¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯[" .. "YRP" .. "]¯\n"

function strEmpty(str)
	if isstring(str) then
		if string.Trim(str) == "" then
			return true
		else
			return false
		end
	end
	return true
end

function strUrl(str)
	if !strEmpty(str) and #string.Explode(".", str) > 1 then
		return true
	end
	return false
end

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
	if chan == "printtable" or chan == "missing" or chan == "error" then
		return true
	elseif GetGlobalDBool("yrp_general_loaded") then
		if !IsChannelRegistered(chan) and GetGlobalDBool("bool_msg_channel_" .. chan) then
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
	return "YRP"
end

--local r = GetRealm()
local rc = GetRealmColor()
local _msgcache = {}
function YRP.msg(chan, str_msg, tochat, force)
	if !isstring(chan) then return false end
	if !isstring(str_msg) then return false end

	local cn = GetChannelName(chan)
	if force or MSGChannelEnabled(cn) then
		if str_msg == nil or str_msg == false then
			str_msg = tostring(str_msg)
		end
		local cc = GetChannelColor(cn)
		local _yrp = GetGamemodeShortname()
		local _yrpc = Color(0, 100, 225)

		msgs = string.Explode("\n", str_msg)
		for i, msg in pairs(msgs) do
			MsgC(rc, "[")
			MsgC(_yrpc, _yrp)
			MsgC(rc, "|")
			MsgC(cc, cn)
			if cn == "DB" and GetSQLModeName != nil then
				MsgC(cc, ":" .. GetSQLModeName())
			elseif cn == "DB" then
				MsgC(cc, ":" .. "UNKNOWN")
			end
			MsgC(rc, "] ")

			MsgC(rc, msg)
		
			if force then
				MsgC(rc, " ")
				MsgC(Color(255, 0, 0), "[FORCED]")
			end

			MsgC("\n")

			local str = "[" .. _yrp .. "|" .. cn .. "] " .. msg
			if force then
				str = str .. " [FORCED]"
			end
			if tochat and SERVER then
				PrintMessage(3, "\n ")
				PrintMessage(3, str)
			end
			if SERVER and AddToFakeServerConsole != nil then
				AddToFakeServerConsole(str)
			end

			if cn == "ERROR" or cn == "MISSING" then
				local REALM = "CLIENT"
				if SERVER then
					REALM = "SERVER"
				end
				if CLIENT then
					if LocalPlayer().LoadedGamemode != nil then
						send_error(REALM, "[" .. cn .. "] " .. msg .. " LoadedGamemode: " .. tostring(LocalPlayer():LoadedGamemode()), true)
					end
				else
					send_error(REALM, "[" .. cn .. "] " .. msg, true)
				end
				if CLIENT and cn == "ERROR" and createD != nil then
					local err = createD("DFrame", nil, YRP.ctr(600), YRP.ctr(60), YRP.ctr(60), YRP.ctr(400))
					err:ShowCloseButton(false)
					err:SetDraggable(false)
					err:SetTitle("")
					function err:Paint(pw, ph)
						draw.WordBox(YRP.ctr(12), 0, 0, "[YourRP] [" .. YRP.lang_string("LID_error") .. "] " .. "Look into the console!", "Y_14_500", Color(255, 0, 0), Color(0, 0, 0))
					end
					timer.Simple(8, function()
						err:Remove()
					end)
				end
			end
		end
	end
end

function printTab(table, name)
	hr_pre("debug")
	local _header = "PrintTable: "
	name = name or ""
	if !strEmpty(name) then
		name = name .. " "
	end
	_header = _header .. name .. "(" .. tostring(table) .. ")"
	YRP.msg("note", _header)

	if istable(table) then
		PrintTable(table)
	else
		YRP.msg("note", "printTab " .. tostring(table) .. " is not a table!")
	end
	hr_pos("debug")
end

local countries = {}
countries["AE"] = "United Arab Emirates"
countries["AR"] = "Argentina"
countries["AT"] = "Austria"
countries["AU"] = "Australia"

countries["BE"] = "Belgium"
countries["BG"] = "Bulgaria"
countries["BR"] = "Brazil"
countries["BY"] = "Belarus"

countries["CA"] = "Canada"
countries["CH"] = "Switzerland"
countries["CL"] = "Chile"
countries["CN"] = "China"
countries["CZ"] = "Czech Republic"

countries["DE"] = "Germany"
countries["DK"] = "Denmark"
countries["DO"] = "Dominican Republic"

countries["EE"] = "Estonia"
countries["EG"] = "Egypt"
countries["ES"] = "Spain"

countries["FI"] = "Finland"
countries["FR"] = "France"

countries["GB"] = "Great Britain"
countries["GG"] = "Guernsey"
countries["GI"] = "Gibraltar"
countries["GR"] = "Greece"

countries["HO"] = "Hong Kong"
countries["HR"] = "Croatia"
countries["HU"] = "Hungary"

countries["ID"] = "Indonesia"
countries["IE"] = "Ireland"
countries["IL"] = "Israel"
countries["IR"] = "Iran"
countries["IS"] = "Iceland"
countries["IT"] = "Italy"

countries["JE"] = "Jersey"
countries["JO"] = "Jordan"
countries["JP"] = "Japan"

countries["KG"] = "Kyrgyzstan"
countries["KR"] = "Korea"
countries["KW"] = "Kuwait"
countries["KZ"] = "Kazakhstan"

countries["LI"] = "Liechtenstein"
countries["LT"] = "Lithuania"
countries["LU"] = "Luxembourg"
countries["LV"] = "Latvia"

countries["MA"] = "Morocco"
countries["MD"] = "Moldova"
countries["ME"] = "Montenegro"
countries["MK"] = "North Macedonia"
countries["MX"] = "Mexico"
countries["MY"] = "Malaysia"

countries["NL"] = "Netherlands"
countries["NO"] = "Norway"
countries["NZ"] = "New Zealand"

countries["PA"] = "Panama"
countries["PE"] = "Peru"
countries["PH"] = "Philippines"
countries["PL"] = "Poland"
countries["PT"] = "Portugal"

countries["QA"] = "Qatar"

countries["RE"] = "Réunion"
countries["RO"] = "Romania"
countries["RS"] = "Serbia"
countries["RU"] = "Russia"

countries["SA"] = "Saudi Arabia"
countries["SE"] = "Sweden"
countries["SG"] = "Singapore"
countries["SK"] = "Slovakia"

countries["TH"] = "Thailand"
countries["TR"] = "Turkey"
countries["TW"] = "Taiwan"

countries["UA"] = "Ukraine"
countries["US"] = "USA"

countries["VE"] = "Venezuela"
countries["VN"] = "Vietnam"

countries["ZA"] = "South Africa"

function GetCountryName(id)
	id = string.upper(id)
	local countryname = countries[id]
	if wk(countryname) then
		return countryname
	else
		return id
	end
end
