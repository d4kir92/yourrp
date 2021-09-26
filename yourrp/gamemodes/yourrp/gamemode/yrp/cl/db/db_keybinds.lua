--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

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

YRP_KEYBINDS["menu_interact"] = KEY_F6

YRP_KEYBINDS["sp_open"] = KEY_UP
YRP_KEYBINDS["sp_close"] = KEY_DOWN

YRP_KEYBINDS["voice_mute"] = KEY_HOME
YRP_KEYBINDS["voice_range_up"] = KEY_PAGEUP
YRP_KEYBINDS["voice_range_dn"] = KEY_PAGEDOWN

YRP_KEYBINDS["macro_menu"] = KEY_INSERT

YRP_KEYBINDS["voice_menu"] = KEY_H
YRP_KEYBINDS["chat_menu"] = KEY_PERIOD

for i = 1, 49 do
	YRP_KEYBINDS["m_" .. i] = 0
end

local yrp_keybinds = {}
yrp_keybinds.version = 4

local yrp_keybinds_loaded = false

local dbfile = "yrp_keybinds/yrp_keybinds.json"

function YRPKeybindsMSG( msg )
	MsgC( Color( 0, 255, 0 ), "[YourRP] [KEYBINDS] " .. msg .. "\n" )
end

function YRPKeybindsCheckFile()
	if !file.Exists( "yrp_keybinds", "DATA" ) then
		YRPKeybindsMSG( "Created Keybind Folder" )
		file.CreateDir( "yrp_keybinds" )
	end
	if !file.Exists( dbfile, "DATA" ) then
		YRPKeybindsMSG( "Created New Keybind File" )
		file.Write( dbfile, util.TableToJSON( YRP_KEYBINDS, true ) )
	end

	if !file.Exists( "yrp_keybinds", "DATA" ) then
		YRP.msg("error", "FAILED TO CREATE KEYBIND FOLDER")
	end
	if !file.Exists( dbfile, "DATA" ) then
		YRP.msg("error", "FAILED TO CREATE KEYBIND FILE")
	end
end

function YRPKeybindsLoad()
	YRPKeybindsCheckFile()
	YRPKeybindsMSG( "Load Keybinds" )
	
	yrp_keybinds = util.JSONToTable( file.Read( dbfile, "DATA" ) )
end

function YRPKeybindsSave()
	YRPKeybindsCheckFile()
	YRPKeybindsMSG( "Save Keybinds" )
	
	file.Write( dbfile, util.TableToJSON( yrp_keybinds, true ) )
end

function KBTab()
	if yrp_keybinds_loaded then
		return yrp_keybinds
	else
		return {}
	end
end

function YRPGetKeybinds()
	if yrp_keybinds_loaded then
		return yrp_keybinds
	else
		return {}
	end
end

function get_keybind(name)
	if yrp_keybinds_loaded then
		name = tostring(name)
		return tonumber(yrp_keybinds[name])
	else
		return -1
	end
end

function set_keybind(name, value, force)
	if yrp_keybinds_loaded then

		if value != 0 and yrp_keybinds then
			for n, v in pairs(yrp_keybinds) do
				if n == "version" or force then
					continue
				end
				if tonumber(value) == tonumber(v) and name != n and !string.StartWith(n, "menu_options_") then
					return false
				end
			end
		end

		yrp_keybinds[name] = value

		YRPKeybindsSave()

		return true
	else
		return false
	end
end

function GetKeybindName(kbname, show)
	local _kb = kbname or ""
	if !string.StartWith( kbname, "in_" ) and get_keybind(kbname) then
		_kb = get_keybind(kbname)
	end
	if isnumber(tonumber(_kb)) then
		_kb = input.GetKeyName(_kb)
	end
	if string.StartWith(kbname, "in_") then
		_kb = YRP.lang_string("LID_" .. kbname)
	end
	if wk(_kb) then
		_kb = string.upper(_kb)
	end
	return tostring(_kb)
end

function YRPCheckKeybinds()
	YRPKeybindsLoad()

	if yrp_keybinds then
		local foundmissing = false
		for i, v in pairs( YRP_KEYBINDS ) do
			if yrp_keybinds[i] == nil then
				foundmissing = true
				YRPKeybindsMSG( "Missing Keybind, adding it", Color( 255, 255, 0 ) )
				yrp_keybinds[i] = v
			end
		end
	else
		YRP.msg( "error", "yrp_keybinds is broken: " .. tostring( file.Read( dbfile, "DATA" ) ) )
	end

	if foundmissing then
		YRPKeybindsSave()
	end

	yrp_keybinds_loaded = true
end
YRPCheckKeybinds()

function YRPResetKeybinds()
	for i, keybind in pairs(YRP_KEYBINDS) do
		set_keybind(i, keybind)
	end
end

net.Receive("SetServerKeybinds", function(len)
	local keytab = net.ReadTable()
	for i, ktab in pairs(keytab) do
		set_keybind(ktab.name, ktab.value)
	end
end)
