--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
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
		return Color(137, 222, 255)
	elseif CLIENT then
		return Color(255, 222, 102)
	else
		return Color(255, 255, 0)
	end
end

function strUrl(str)
	if not strEmpty(str) and #string.Explode(".", str) > 1 then return true end

	return false
end

function yrpmsg(msg)
	MsgC(GetRealmColor(), msg, "\n")
end

function bool_status(b)
	if tobool(b) then
		return YRP:trans("LID_enabled")
	elseif not tobool(b) then
		return YRP:trans("LID_disabled")
	end
end

function GetChannelName(chan)
	chan = string.lower(chan)
	if chan == "n" or chan == "noti" or chan == "note" or chan == "notification" then
		return "N"
	elseif chan == "db" or chan == "database" then
		return "DB"
	elseif chan == "gm" or chan == "gamemode" then
		return "GM"
	elseif chan == "l" or chan == "lang" or chan == "language" then
		return "L"
	elseif chan == "c" or chan == "chat" then
		return "C"
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
		return string.upper(chan)
	end
end

local channelcolors = {}
channelcolors["n"] = Color(255, 255, 0)
channelcolors["db"] = Color(0, 255, 0)
channelcolors["gm"] = Color(0, 100, 225)
channelcolors["l"] = Color(100, 255, 100)
channelcolors["c"] = Color(0, 0, 255, 255)
channelcolors["debug"] = Color(255, 255, 255, 255)
channelcolors["printtable"] = Color(255, 255, 255, 255)
channelcolors["missing"] = Color(255, 100, 100)
channelcolors["access"] = Color(255, 50, 50)
channelcolors["error"] = Color(0, 255, 0)
function GetChannelColor(chan)
	chan = string.lower(chan)
	if channelcolors[chan] ~= nil then
		return channelcolors[chan]
	else
		return Color(0, 255, 0)
	end
end

local msgchannels = {}
msgchannels["n"] = true
msgchannels["db"] = true
msgchannels["gm"] = true
msgchannels["l"] = true
msgchannels["c"] = true
msgchannels["debug"] = true
msgchannels["printtable"] = true
msgchannels["missing"] = true
msgchannels["access"] = true
msgchannels["error"] = true
msgchannels["darkrp"] = true
function IsChannelRegistered(chan)
	chan = string.lower(chan)
	if msgchannels[chan] then
		return true
	else
		return false
	end
end

function MSGChannelEnabled(chan)
	if not isstring(chan) then return false end
	chan = string.lower(chan)
	if chan == "printtable" or chan == "missing" or chan == "error" or chan == "access" then
		return true
	elseif GetGlobalYRPBool("yrp_general_loaded") then
		if not IsChannelRegistered(chan) then
			YRP:msg("error", "!!!" .. chan .. "!!!")
		elseif GetGlobalYRPBool("bool_msg_channel_" .. chan) == true then
			return true
		end

		return false
	else
		return true
	end
end

function GetGamemodeShortname()
	return "Y"
end

--local r = GetRealm()
local rc = GetRealmColor()
local _msgcache = {}
local yrpmsgantispam = {}
function YRP:msg(chan, str_msg, tochat, force)
	if not isstring(chan) then return false end
	if not isstring(str_msg) then return false end
	if force or strEmpty(str_msg) or not table.HasValue(yrpmsgantispam, str_msg) then
		if not table.HasValue(yrpmsgantispam, str_msg) then
			table.insert(yrpmsgantispam, str_msg)
			timer.Simple(
				3,
				function()
					table.RemoveByValue(yrpmsgantispam, str_msg)
				end
			)
		end

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
				if cn == "DB" and GetSQLModeName ~= nil then
					MsgC(cc, ":" .. GetSQLModeName())
				elseif cn == "DB" then
					MsgC(cc, ":" .. "UNKNOWN")
				end

				MsgC(rc, "] ")
				MsgC(rc, msg)
				if force then
					MsgC(rc, " ")
					MsgC(Color(0, 255, 0), "[FORCED]")
				end

				MsgC("\n")
				local str = "[" .. _yrp .. "|" .. cn .. "] " .. msg
				if force then
					str = str .. " [FORCED]"
				end

				if tochat and SERVER then
					PrintMessage(3, "\n")
					PrintMessage(3, msg)
				end

				if SERVER and AddToFakeServerConsole ~= nil then
					AddToFakeServerConsole(str)
				end

				local REALM = "CLIENT"
				if SERVER then
					REALM = "SERVER"
				end

				if cn == "ERROR" or cn == "MISSING" or cn == "ACCESS" then
					if YRPNewError and YRPNewError(str) then
						YRPAddError(str, str, REALM)
					end

					if CLIENT and cn == "ERROR" and YRPCreateD ~= nil then
						local err = YRPCreateD("DFrame", nil, YRP:ctr(600), YRP:ctr(60), YRP:ctr(60), YRP:ctr(400))
						err:ShowCloseButton(false)
						err:SetDraggable(false)
						err:SetTitle("")
						function err:Paint(pw, ph)
							draw.WordBox(YRP:ctr(12), 0, 0, "[YourRP] [" .. YRP:trans("LID_error") .. "] " .. "Look into the console!", "Y_14_500", Color(0, 255, 0), Color(0, 0, 0, 255))
						end

						timer.Simple(
							8,
							function()
								err:Remove()
							end
						)
					end
				elseif cn == "DARKRP" then
					if YRPNewError and YRPNewError(str) then
						YRPAddError(str, str, REALM)
					end
				end
			end
		end
	end
end

function YRPTableToColor(tbl)
	return Color(tbl.r, tbl.g, tbl.b, tbl.a)
end

function YRPTableToColorStr(tbl)
	return tbl.r .. "," .. tbl.g .. "," .. tbl.b .. "," .. tbl.a
end

function YRPColorToString(col)
	col.a = col.a or 255

	return col.r .. "," .. col.g .. "," .. col.b .. "," .. col.a
end

function printTab(ta, name)
	local _header = "PrintTable: "
	name = name or ""
	if not strEmpty(name) then
		name = name .. " "
	end

	_header = _header .. name .. "( " .. tostring(ta) .. " )"
	YRP:msg("note", _header)
	if istable(table) then
		PrintTable(ta)
	else
		YRP:msg("note", "printTab " .. tostring(ta) .. " is not a table!")
	end
end

local countries = {}
countries["AD"] = "Andorra"
countries["AE"] = "United Arab Emirates"
countries["AF"] = "Afghanistan"
countries["AG"] = "Antigua and Barbuda"
countries["AI"] = "Anguilla"
countries["AL"] = "Albania"
countries["AM"] = "Amharic"
countries["AM"] = "Armenia"
countries["AO"] = "Angola"
countries["AQ"] = "Antarctica"
countries["AR"] = "Argentina"
countries["AS"] = "American Samoa"
countries["AT"] = "Austria"
countries["AU"] = "Australia"
countries["AW"] = "Aruba"
countries["AX"] = "Åland Islands"
countries["AZ"] = "Azerbaijan"
countries["AZ"] = "Azerbaijani"
countries["BA"] = "Bosnia and Herzegovina"
countries["BB"] = "Barbados"
countries["BD"] = "Bangladesh"
countries["BE"] = "Belgium"
countries["BF"] = "Burkina Faso"
countries["BG"] = "Bulgaria"
countries["BH"] = "Bahrain"
countries["BI"] = "Burundi"
countries["BJ"] = "Benin"
countries["BM"] = "Bermuda"
countries["BN"] = "Brunei Darussalam"
countries["BO"] = "Bolivia, Plurinational State of"
countries["BQ"] = "Bonaire, Sint Eustatius and Saba"
countries["BR"] = "Brazil"
countries["BS"] = "Bahamas"
countries["BT"] = "Bhutan"
countries["BW"] = "Botswana"
countries["BY"] = "Belarus"
countries["BZ"] = "Belize"
countries["CA"] = "Canada"
countries["CC"] = "Cocos (Keeling) Islands"
countries["CD"] = "Congo, the Republic of the"
countries["CF"] = "Central African Republic"
countries["CG"] = "Congo, the Democratic Republic of the"
countries["CH"] = "Switzerland"
countries["CI"] = "Côte d'Ivoire"
countries["CK"] = "Cook Islands"
countries["CL"] = "Chile"
countries["CM"] = "Cameroon"
countries["CN"] = "China"
countries["CO"] = "Colombia"
countries["CO"] = "Corsican"
countries["CR"] = "Costa Rica"
countries["CU"] = "Cuba"
countries["CV"] = "Cabo Verde"
countries["CW"] = "Curaçao"
countries["CX"] = "Christmas Island"
countries["CY"] = "Cyprus"
countries["CY"] = "Zypern"
countries["CZ"] = "Czech Republic"
countries["DE"] = "Germany"
countries["DJ"] = "Djibouti"
countries["DK"] = "Denmark"
countries["DM"] = "Dominica"
countries["DO"] = "Dominican Republic"
countries["DZ"] = "Algeria"
countries["DZ"] = "Dzongkha"
countries["EC"] = "Ecuador"
countries["EE"] = "Estonia"
countries["EG"] = "Egypt"
countries["EH"] = "Western Sahara"
countries["ER"] = "Eritrea"
countries["ES"] = "Spain"
countries["ET"] = "Ethiopia"
countries["FI"] = "Finland"
countries["FJ"] = "Fiji"
countries["FK"] = "Falkland Islands (Malvinas)"
countries["FM"] = "Micronesia, Federated States of"
countries["FO"] = "Faroe Islands"
countries["FR"] = "France"
countries["GA"] = "Gabon"
countries["GB"] = "Great Britain"
countries["GD"] = "Grenada"
countries["GE"] = "Georgia"
countries["GG"] = "Guernsey"
countries["GH"] = "Ghana"
countries["GI"] = "Gibraltar"
countries["GL"] = "Greenland"
countries["GM"] = "Gambia"
countries["GN"] = "Guinea"
countries["GP"] = "Guadeloupe"
countries["GR"] = "Greece"
countries["GT"] = "Guatemala"
countries["GU"] = "Guam"
countries["GW"] = "Guinea-Bissau"
countries["GY"] = "Guyana"
countries["HK"] = "Hong Kong"
countries["HM"] = "Heard Island and McDonald Islands"
countries["HN"] = "Honduras"
countries["HO"] = "Hong Kong"
countries["HR"] = "Croatia"
countries["HT"] = "Haiti"
countries["HU"] = "Hungary"
countries["ID"] = "Indonesia"
countries["IE"] = "Ireland"
countries["IL"] = "Israel"
countries["IM"] = "Isle of Man"
countries["IN"] = "India"
countries["IO"] = "British Indian Ocean Territory"
countries["IQ"] = "Iraq"
countries["IR"] = "Iran, Islamic Republic of"
countries["IR"] = "Iran"
countries["IS"] = "Iceland"
countries["IT"] = "Italy"
countries["JE"] = "Jersey"
countries["JM"] = "Jamaica"
countries["JO"] = "Jordan"
countries["JP"] = "Japan"
countries["KE"] = "Kenya"
countries["KG"] = "Kyrgyzstan"
countries["KH"] = "Cambodia"
countries["KI"] = "Kiribati"
countries["KM"] = "Comoros"
countries["KN"] = "Saint Kitts and Nevis"
countries["KP"] = "Korea, Democratic People's Republic of"
countries["KR"] = "Korea, Republic of"
countries["KR"] = "Korea"
countries["KW"] = "Kuwait"
countries["KY"] = "Cayman Islands"
countries["KZ"] = "Kazakhstan"
countries["LA"] = "Lao People's Democratic Republic"
countries["LB"] = "Lebanon"
countries["LC"] = "Saint Lucia"
countries["LI"] = "Liechtenstein"
countries["LK"] = "Sri Lanka"
countries["LR"] = "Liberia"
countries["LS"] = "Lesotho"
countries["LT"] = "Lithuania"
countries["LU"] = "Luxembourg"
countries["LV"] = "Latvia"
countries["LY"] = "Libya"
countries["MA"] = "Morocco"
countries["MC"] = "Monaco"
countries["MD"] = "Moldova, Republic of"
countries["MD"] = "Moldova"
countries["ME"] = "Montenegro"
countries["MF"] = "Saint Martin (French part)"
countries["MG"] = "Madagascar"
countries["MH"] = "Marshall Islands"
countries["MK"] = "Macedonia, the former Yugoslav Republic of"
countries["MK"] = "North Macedonia"
countries["ML"] = "Mali"
countries["MM"] = "Myanmar"
countries["MN"] = "Mongolia"
countries["MO"] = "Macao"
countries["MP"] = "Northern Mariana Islands"
countries["MQ"] = "Martinique"
countries["MR"] = "Mauritania"
countries["MS"] = "Montserrat"
countries["MT"] = "Malta"
countries["MT"] = "The Republic of Malta"
countries["MU"] = "Mauritius"
countries["MV"] = "Maldives"
countries["MW"] = "Malawi"
countries["MX"] = "Mexico"
countries["MY"] = "Malaysia"
countries["MZ"] = "Mozambique"
countries["NA"] = "Namibia"
countries["NC"] = "New Caledonia"
countries["NE"] = "Niger"
countries["NF"] = "Norfolk Island"
countries["NG"] = "Nigeria"
countries["NI"] = "Nicaragua"
countries["NL"] = "Netherlands"
countries["NO"] = "Norway"
countries["NP"] = "Nepal"
countries["NR"] = "Nauru"
countries["NU"] = "Niue"
countries["NZ"] = "New Zealand"
countries["OM"] = "Oman"
countries["PA"] = "Panama"
countries["PE"] = "Peru"
countries["PG"] = "Papua New Guinea"
countries["PH"] = "Philippines"
countries["PK"] = "Pakistan"
countries["PL"] = "Poland"
countries["PM"] = "Saint Pierre and Miquelon"
countries["PN"] = "Pitcairn"
countries["PR"] = "Puerto Rico"
countries["PS"] = "Palestine, State of"
countries["PT"] = "Portugal"
countries["PW"] = "Palau"
countries["PY"] = "Paraguay"
countries["QA"] = "Qatar"
countries["RE"] = "Réunion"
countries["RO"] = "Romania"
countries["RS"] = "Serbia"
countries["RU"] = "Russia"
countries["RW"] = "Rwanda"
countries["SA"] = "Saudi Arabia"
countries["SB"] = "Solomon Islands"
countries["SC"] = "Seychelles"
countries["SD"] = "Sudan"
countries["SE"] = "Sweden"
countries["SG"] = "Singapore"
countries["SH"] = "Saint Helena, Ascension and Tristan da Cunha"
countries["SI"] = "Slovenia"
countries["SI"] = "Slovenija"
countries["SJ"] = "Svalbard and Jan Mayen"
countries["SK"] = "Slovakia"
countries["SL"] = "Sierra Leone"
countries["SM"] = "San Marino"
countries["SN"] = "Senegal"
countries["SO"] = "Somalia"
countries["SR"] = "Suriname"
countries["SS"] = "South Sudan"
countries["ST"] = "Sao Tome and Principe"
countries["SX"] = "Sint Maarten (Dutch part)"
countries["SY"] = "Syrian Arab Republic"
countries["SZ"] = "Swaziland"
countries["TC"] = "Turks and Caicos Islands"
countries["TD"] = "Chad"
countries["TG"] = "Togo"
countries["TH"] = "Thailand"
countries["TJ"] = "Tajikistan"
countries["TK"] = "Tokelau"
countries["TL"] = "Timor-Leste"
countries["TM"] = "Turkmenistan"
countries["TN"] = "Tunisia"
countries["TO"] = "Tonga"
countries["TR"] = "Turkey"
countries["TT"] = "Trinidad and Tobago"
countries["TV"] = "Tuvalu"
countries["TW"] = "Taiwan, Province of China"
countries["TW"] = "Taiwan"
countries["TZ"] = "Tanzania, United Republic of"
countries["UA"] = "Ukraine"
countries["UG"] = "Uganda"
countries["UM"] = "United States Minor Outlying Islands"
countries["US"] = "USA"
countries["UY"] = "UNKNOWN??"
countries["UY"] = "Uruguay"
countries["UZ"] = "Uzbekistan"
countries["VC"] = "Saint Vincent and the Grenadines"
countries["VE"] = "Venezuela, Bolivarian Republic of"
countries["VE"] = "Venezuela"
countries["VG"] = "Virgin Islands, British"
countries["VI"] = "Virgin Islands, U.S."
countries["VN"] = "Vietnam"
countries["VU"] = "Vanuatu"
countries["WF"] = "Wallis and Futuna"
countries["WS"] = "Samoa"
countries["YE"] = "Yemen"
countries["YT"] = "Mayotte"
countries["ZA"] = "South Africa"
countries["ZM"] = "Zambia"
countries["ZW"] = "Zimbabwe"
function YRPGetCountryName(id, from)
	if id == nil then
		YRP:msg("error", "[YRPGetCountryName] NO INPUT: " .. tostring(id) .. " from: " .. tostring(from))

		return ""
	end

	id = string.upper(id)
	local countryname = countries[id]
	if IsNotNilAndNotFalse(countryname) then
		return countryname
	elseif string.len(id) == 2 then
		YRP:msg("error", "[YRPGetCountryName] Missing Country: " .. tostring(id))

		return id
	else
		YRP:msg("error", "[YRPGetCountryName] Input Wrong: " .. tostring(id) .. " from: " .. tostring(from))

		return id
	end
end
