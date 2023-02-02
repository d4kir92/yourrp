--Copyright (C) 2017-2023 D4KiR (https://www.gnu.org/licenses/gpl.txt)

local _text = {}
_text.pre = "#YRP# "
_text.gmname = "YourRP"
_text.loaddb = "LOAD DB: "
_text.successdb = " created successfully."

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
		return Color( 137, 222, 255 )
	elseif CLIENT then
		return Color( 255, 222, 102 )
	else
		return Color( 255, 255, 0 )
	end
end

function strUrl(str)
	if !strEmpty(str) and #string.Explode( ".", str) > 1 then
		return true
	end
	return false
end

function yrpmsg(msg)
	MsgC( GetRealmColor(), msg, "\n" )
end

function bool_status( b)
	if tobool( b) then
		return YRP.lang_string( "LID_enabled" )
	elseif !tobool( b) then
		return YRP.lang_string( "LID_disabled" )
	end
end

function GetChannelName( chan)
	chan = string.lower( chan)
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
	elseif chan == "mis" or chan == "miss" or chan == "missing" then
		return "MISSING"
	elseif chan == "acc" or chan == "acce" or chan == "access" then
		return "ACCESS"
	elseif chan == "err" or chan == "error" then
		return "ERROR"
	else
		return string.upper( chan)
	end
end

local channelcolors = {}
channelcolors["noti"] = Color( 255, 255, 0)
channelcolors["db"] = Color( 0, 255, 0 )
channelcolors["gm"] = Color( 0, 100, 225)
channelcolors["lang"] = Color( 100, 255, 100)
channelcolors["chat"] = Color( 0, 0, 255, 255 )
channelcolors["debug"] = Color( 255, 255, 255, 255 )
channelcolors["printtable"] = Color( 255, 255, 255, 255 )
channelcolors["missing"] = Color( 255, 100, 100)
channelcolors["access"] = Color( 255, 50, 50)
channelcolors["error"] = Color( 0, 255, 0 )
function GetChannelColor( chan)
	chan = string.lower( chan)
	if channelcolors[chan] != nil then
		return channelcolors[chan]
	else
		return Color( 0, 255, 0 )
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
msgchannels["access"] = true
msgchannels["error"] = true
msgchannels["darkrp"] = true
function IsChannelRegistered( chan)
	chan = string.lower( chan)
	if msgchannels[chan] then
		return true
	else
		return false
	end
end

function MSGChannelEnabled( chan)
	if !isstring( chan) then return false end

	chan = string.lower( chan)
	if chan == "printtable" or chan == "missing" or chan == "error" or chan == "access" then
		return true
	elseif GetGlobalYRPBool( "yrp_general_loaded" ) then
		if !IsChannelRegistered( chan) then
			YRP.msg( "error", "!!!" .. chan .. "!!!" )
		elseif GetGlobalYRPBool( "bool_msg_channel_" .. chan) == true then
			return true
		end
		return false
	else
		return true
	end
end

function GetGamemodeShortname()
	return "YRP"
end

--local r = GetRealm()
local rc = GetRealmColor()
local _msgcache = {}

local yrpmsgantispam = {}
function YRP.msg( chan, str_msg, tochat, force )
	if !isstring( chan ) then return false end
	if !isstring( str_msg ) then return false end

	if force or strEmpty(str_msg) or not table.HasValue(yrpmsgantispam, str_msg) then
		if not table.HasValue(yrpmsgantispam, str_msg) then
			table.insert(yrpmsgantispam, str_msg)
			
			timer.Simple(3, function()
				table.RemoveByValue(yrpmsgantispam, str_msg)
			end)
		end

		local cn = GetChannelName( chan)
		if force or MSGChannelEnabled( cn) then
			if str_msg == nil or str_msg == false then
				str_msg = tostring(str_msg)
			end
			local cc = GetChannelColor( cn)
			local _yrp = GetGamemodeShortname()
			local _yrpc = Color( 0, 100, 225)

			msgs = string.Explode( "\n", str_msg)
			for i, msg in pairs(msgs) do
				MsgC( rc, "[" )
				MsgC( _yrpc, _yrp )
				MsgC( rc, "|" )
				MsgC( cc, cn )
				if cn == "DB" and GetSQLModeName != nil then
					MsgC( cc, ":" .. GetSQLModeName() )
				elseif cn == "DB" then
					MsgC( cc, ":" .. "UNKNOWN" )
				end
				MsgC( rc, "] " )

				MsgC( rc, msg )
			
				if force then
					MsgC( rc, " " )
					MsgC( Color( 0, 255, 0 ), "[FORCED]" )
				end

				MsgC( "\n" )

				local str = "[" .. _yrp .. "|" .. cn .. "] " .. msg
				if force then
					str = str .. " [FORCED]"
				end
				if tochat and SERVER then
					PrintMessage( 3, "\n" )
					PrintMessage( 3, msg )
				end
				if SERVER and AddToFakeServerConsole != nil then
					AddToFakeServerConsole(str)
				end

				local REALM = "CLIENT"
				if SERVER then
					REALM = "SERVER"
				end

				if cn == "ERROR" or cn == "MISSING" or cn == "ACCESS" then			
					if YRPNewError(str) then
						YRPAddError(str, str, REALM)
					end

					if CLIENT and cn == "ERROR" and YRPCreateD != nil then
						local err = YRPCreateD( "DFrame", nil, YRP.ctr(600), YRP.ctr(60), YRP.ctr(60), YRP.ctr(400) )
						err:ShowCloseButton(false)
						err:SetDraggable(false)
						err:SetTitle( "" )
						function err:Paint(pw, ph)
							draw.WordBox(YRP.ctr(12), 0, 0, "[YourRP] [" .. YRP.lang_string( "LID_error" ) .. "] " .. "Look into the console!", "Y_14_500", Color( 0, 255, 0 ), Color( 0, 0, 0, 255 ) )
						end
						timer.Simple(8, function()
							err:Remove()
						end)
					end
				elseif cn == "DARKRP" then
					if YRPNewError(str) then
						YRPAddError(str, str, REALM)
					end
				end
			end
		end
	end
end

function YRPTableToColor( tbl )
	return Color( tbl.r , tbl.g , tbl.b, tbl.a )
end

function YRPTableToColorStr(tbl)
	return tbl.r .. "," .. tbl.g .. "," .. tbl.b .. "," .. tbl.a
end

function YRPColorToString( col)
	col.a = col.a or 255
	return col.r .. "," .. col.g .. "," .. col.b .. "," .. col.a
end

function printTab(table, name)
	local _header = "PrintTable: "
	name = name or ""
	if !strEmpty(name) then
		name = name .. " "
	end
	_header = _header .. name .. "( " .. tostring(table) .. " )"
	YRP.msg( "note", _header)

	if istable(table) then
		PrintTable(table)
	else
		YRP.msg( "note", "printTab " .. tostring(table) .. " is not a table!" )
	end
end

local countries = {}
countries["AE"] = "United Arab Emirates"
countries["AM"] = "Amharic"
countries["AR"] = "Argentina"
countries["AT"] = "Austria"
countries["AU"] = "Australia"
countries["AZ"] = "Azerbaijani"

countries["BE"] = "Belgium"
countries["BG"] = "Bulgaria"
countries["BR"] = "Brazil"
countries["BY"] = "Belarus"

countries["CA"] = "Canada"
countries["CH"] = "Switzerland"
countries["CL"] = "Chile"
countries["CN"] = "China"
countries["CY"] = "Zypern"
countries["CZ"] = "Czech Republic"

countries["DE"] = "Germany"
countries["DK"] = "Denmark"
countries["DO"] = "Dominican Republic"
countries["DZ"] = "Dzongkha"

countries["EE"] = "Estonia"
countries["EG"] = "Egypt"
countries["ES"] = "Spain"

countries["FI"] = "Finland"
countries["FR"] = "France"

countries["GB"] = "Great Britain"
countries["GE"] = "Georgia"
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
countries["MT"] = "The Republic of Malta"
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

function YRPGetCountryName( id, from )
	if id == nil then
		YRP.msg( "error", "[YRPGetCountryName] NO INPUT: " .. tostring( id ) .. " from: " .. tostring( from ) )
		return ""
	end
	id = string.upper( id )
	local countryname = countries[id]
	if IsNotNilAndNotFalse( countryname ) then
		return countryname
	elseif string.len( id ) == 2 then
		YRP.msg( "error", "[YRPGetCountryName] Missing Country: " .. tostring( id ) )
		return id
	else
		YRP.msg( "error", "[YRPGetCountryName] Input Wrong: " .. tostring( id ) .. " from: " .. tostring( from ) )
		return id
	end
end
