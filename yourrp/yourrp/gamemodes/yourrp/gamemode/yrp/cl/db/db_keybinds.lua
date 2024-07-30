--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local _type = type
local file = file
local util = util
local timer = timer
local tonumber = tonumber
local isnumber = isnumber
local YRP_KeybindsLoaded = false
local YRP_KEYBINDS = {}
YRP_KEYBINDS["menu_character_selection"] = KEY_F2
YRP_KEYBINDS["menu_role"] = KEY_F4
YRP_KEYBINDS["menu_buy"] = KEY_F11
YRP_KEYBINDS["menu_settings"] = KEY_F8
YRP_KEYBINDS["menu_inventory"] = KEY_I
YRP_KEYBINDS["menu_options_vehicle"] = KEY_O
YRP_KEYBINDS["menu_options_door"] = KEY_O
YRP_KEYBINDS["menu_appearance"] = KEY_P
YRP_KEYBINDS["menu_emotes"] = KEY_MINUS
YRP_KEYBINDS["menu_laws"] = KEY_L
YRP_KEYBINDS["menu_char"] = KEY_Z
YRP_KEYBINDS["menu_keybinds"] = KEY_J
YRP_KEYBINDS["menu_interact"] = KEY_F6
YRP_KEYBINDS["macro_menu"] = KEY_INSERT
YRP_KEYBINDS["voice_menu"] = KEY_H
YRP_KEYBINDS["chat_menu"] = KEY_PERIOD
YRP_KEYBINDS["menu_group"] = KEY_N
YRP_KEYBINDS["view_switch"] = KEY_T
YRP_KEYBINDS["view_zoom_out"] = KEY_PAD_PLUS
YRP_KEYBINDS["view_zoom_in"] = KEY_PAD_MINUS
YRP_KEYBINDS["view_up"] = KEY_PAD_8
YRP_KEYBINDS["view_down"] = KEY_PAD_5
YRP_KEYBINDS["view_right"] = KEY_PAD_6
YRP_KEYBINDS["view_left"] = KEY_PAD_4
YRP_KEYBINDS["view_spin_right"] = KEY_PAD_9
YRP_KEYBINDS["view_spin_left"] = KEY_PAD_7
YRP_KEYBINDS["toggle_mouse"] = KEY_F3
YRP_KEYBINDS["toggle_map"] = KEY_M
YRP_KEYBINDS["drop_item"] = KEY_G
YRP_KEYBINDS["sp_open"] = KEY_UP
YRP_KEYBINDS["sp_close"] = KEY_DOWN
YRP_KEYBINDS["voice_mute"] = KEY_HOME
YRP_KEYBINDS["voice_range_up"] = KEY_PAGEUP
YRP_KEYBINDS["voice_range_dn"] = KEY_PAGEDOWN
for i = 1, 49 do
	YRP_KEYBINDS["m_" .. i] = 0
end

local yrp_keybinds = {}
yrp_keybinds.version = 4
local dbfile = "yrp_keybinds/yrp_keybinds.json"
function YRPKeybindsMSG(msg)
	MsgC(Color(0, 255, 0), "[YourRP] [KEYBINDS] " .. msg .. "\n")
end

function YRPKeybindsCheckFile()
	if not file.Exists("yrp_keybinds", "DATA") then
		YRPKeybindsMSG("Created Keybind Folder")
		file.CreateDir("yrp_keybinds")
	end

	if dbfile and not file.Exists(dbfile, "DATA") then
		YRPKeybindsMSG("Created New Keybind File")
		file.Write(dbfile, util.TableToJSON(YRP_KEYBINDS, true))
	elseif dbfile then
		local data = file.Read(dbfile, "DATA")
		if data then
			local testfile = util.JSONToTable(data)
			if testfile == nil or table.Count(testfile) <= 0 then
				YRP:msg("note", "[KEYBINDS] File is empty.")
				file.Write(dbfile, util.TableToJSON(YRP_KEYBINDS, true))
				data = file.Read(dbfile, "DATA")
				if data then
					testfile = util.JSONToTable(data)
					if testfile == nil or table.Count(testfile) <= 0 then
						YRP:msg("error", "[KEYBINDS] File is still empty.")
					end
				else
					YRP:msg("error", "[KEYBINDS] FAILED TO READ KEYBINDS FILE #2 fi: " .. tostring(data))
				end
			end
		else
			YRP:msg("error", "[KEYBINDS] FAILED TO READ KEYBINDS FILE #1 fi: " .. tostring(data))
		end
	end

	if not file.Exists("yrp_keybinds", "DATA") then
		YRP:msg("note", "[KEYBINDS] FAILED TO CREATE KEYBIND FOLDER, NO SPACE ON DISK??")
	end

	if not file.Exists(dbfile, "DATA") then
		YRP:msg("note", "[KEYBINDS] FAILED TO CREATE KEYBIND FILE, NO SPACE ON DISK??")
	end
end

function YRPKeybindsSave()
	YRPKeybindsCheckFile()
	YRPKeybindsMSG("Save Keybinds")
	if dbfile then
		file.Write(dbfile, util.TableToJSON(yrp_keybinds, true))
	end
end

function YRPKeybindsLoad()
	if not IsValid(LocalPlayer()) then
		timer.Simple(0.1, YRPKeybindsLoad)

		return false
	end

	YRPKeybindsCheckFile()
	YRPKeybindsMSG("Load Keybinds")
	if file.Exists(dbfile, "DATA") then
		yrp_keybinds = util.JSONToTable(file.Read(dbfile, "DATA"))
		if yrp_keybinds then
			for name, key in pairs(yrp_keybinds) do
				yrp_keybinds[name] = tonumber(key)
			end

			local missing = false
			for name, key in pairs(YRP_KEYBINDS) do
				-- missing entry
				if yrp_keybinds[name] == nil then
					yrp_keybinds[name] = tonumber(key)
					missing = true
				end
			end

			if missing then
				YRPKeybindsSave()
			end
		else
			local fi = file.Read(dbfile, "DATA")
			YRP:msg("error", "FAILED TO LOAD KEYBINDS! fi: [" .. tostring(fi) .. "]")
		end
	else
		YRP:msg("note", "[KEYBINDS] FILE DOESN'T EXISTS, NO SPACE ON DISK??")
	end

	if _type(yrp_keybinds) ~= "table" then
		local fi = file.Read(dbfile, "DATA")
		YRP:msg("error", "[KEYBINDS] [" .. LocalPlayer():YRPName() .. "|" .. LocalPlayer():SteamID() .. "] KeybindsLoad FAILED, broken file? [" .. tostring(fi) .. "]")
	else
		YRP_KeybindsLoaded = true
	end
end

YRPKeybindsLoad()
function KBTab()
	if YRP_KeybindsLoaded then
		return yrp_keybinds
	else
		return {}
	end
end

function YRPGetKeybinds()
	if YRP_KeybindsLoaded then
		return yrp_keybinds
	else
		return {}
	end
end

function YRPGetKeybind(name)
	if YRP_KeybindsLoaded then
		if name == nil then return -1 end
		if name and _type(tonumber(name)) == "number" then return name end
		name = tostring(name)
		if YRP_KeybindsLoaded and yrp_keybinds and name and yrp_keybinds[name] ~= nil then
			return tonumber(yrp_keybinds[name])
		elseif YRP_KeybindsLoaded and yrp_keybinds then
			local data = file.Read(dbfile, "DATA")
			if data then
				local dbf = util.JSONToTable(data)
				if dbf then
					YRP:msg("error", "[KEYBINDS] Failed to get Keybind: " .. tostring(name) .. " result: " .. tostring(yrp_keybinds[name]))
					YRP:msg("error", "[KEYBINDS] Content: " .. tostring(table.ToString(dbf, "File")))

					return -1
				else
					YRP:msg("error", "[KEYBINDS] Failed to Parse to Table")

					return -1
				end
			else
				YRP:msg("note", "[KEYBINDS] Failed to get FILE Data, NO SPACE ON DISK??")

				return -1
			end
		else
			YRP:msg("error", "[KEYBINDS] Failed to Parse to Table")

			return -1
		end
	else
		return -1
	end

	YRP:msg("error", "[KEYBINDS] Unknown error")

	return -1
end

function YRPSetKeybind(name, value, force)
	if YRP_KeybindsLoaded then
		if value ~= 0 and yrp_keybinds then
			for n, v in pairs(yrp_keybinds) do
				if n == "version" or force then continue end
				if tonumber(value) == tonumber(v) and name ~= n and not string.StartWith(n, "menu_options_") then return false end
			end
		end

		yrp_keybinds[name] = value
		YRPKeybindsSave()

		return true
	else
		return false
	end
end

function YRPGetKeybindName(kbname, show)
	local _kb = kbname or ""
	if YRP_KeybindsLoaded then
		if not string.StartWith(kbname, "in_") and YRPGetKeybind(kbname) then
			_kb = YRPGetKeybind(kbname)
		end

		if isnumber(tonumber(_kb)) then
			_kb = input.GetKeyName(_kb)
		end

		if string.StartWith(kbname, "in_") then
			_kb = YRP:trans("LID_" .. kbname)
		end

		if IsNotNilAndNotFalse(_kb) then
			_kb = string.upper(_kb)
		end
	end

	return tostring(_kb)
end

function YRPResetKeybinds()
	for i, keybind in pairs(YRP_KEYBINDS) do
		YRPSetKeybind(i, keybind)
	end
end

net.Receive(
	"nws_yrp_setServerKeybinds",
	function(len)
		local keytab = net.ReadTable()
		for i, ktab in pairs(keytab) do
			YRPSetKeybind(ktab.name, ktab.value)
		end
	end
)
