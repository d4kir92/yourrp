--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

YRPKEYBINDS = YRPKEYBINDS or {}
YRPKEYBINDS["menu_character_selection"] = KEY_F2
YRPKEYBINDS["menu_role"] = KEY_F4
YRPKEYBINDS["menu_buy"] = KEY_F11
YRPKEYBINDS["menu_settings"] = KEY_F8
YRPKEYBINDS["menu_inventory"] = KEY_I
YRPKEYBINDS["menu_options_vehicle"] = KEY_O
YRPKEYBINDS["menu_options_door"] = KEY_O
YRPKEYBINDS["menu_appearance"] = KEY_P
YRPKEYBINDS["menu_emotes"] = KEY_MINUS
YRPKEYBINDS["menu_laws"] = KEY_L

YRPKEYBINDS["menu_char"] = KEY_H
YRPKEYBINDS["menu_keybinds"] = KEY_J

YRPKEYBINDS["view_switch"] = KEY_T
YRPKEYBINDS["view_zoom_out"] = KEY_PAD_PLUS
YRPKEYBINDS["view_zoom_in"] = KEY_PAD_MINUS
YRPKEYBINDS["view_up"] = KEY_PAD_8
YRPKEYBINDS["view_down"] = KEY_PAD_5
YRPKEYBINDS["view_right"] = KEY_PAD_6
YRPKEYBINDS["view_left"] = KEY_PAD_4
YRPKEYBINDS["view_spin_right"] = KEY_PAD_9
YRPKEYBINDS["view_spin_left"] = KEY_PAD_7

YRPKEYBINDS["toggle_mouse"] = KEY_F3
YRPKEYBINDS["toggle_map"] = KEY_M
YRPKEYBINDS["drop_item"] = KEY_G

YRPKEYBINDS["menu_interact"] = KEY_K

YRPKEYBINDS["sp_open"] = KEY_UP
YRPKEYBINDS["sp_close"] = KEY_DOWN

YRPKEYBINDS["voice_mute"] = KEY_HOME
YRPKEYBINDS["voice_range_up"] = KEY_PAGEUP
YRPKEYBINDS["voice_range_dn"] = KEY_PAGEDOWN

YRPKEYBINDS["macro_menu"] = KEY_INSERT

YRPKEYBINDS["voice_menu"] = KEY_COMMA
YRPKEYBINDS["chat_menu"] = KEY_PERIOD

YRPKEYBINDS["menu_talents"] = KEY_N

for i = 1, 49 do
	YRPKEYBINDS["m_" .. i] = 0
end

net.Receive("SetServerKeybinds", function(len)
	local keytab = net.ReadTable()
	for i, ktab in pairs(keytab) do
		set_keybind(ktab.name, ktab.value)
	end
end)

local yrp_keybinds = {}
yrp_keybinds.version = 2

function KBTab()
	return yrp_keybinds
end

function GetKeyBinds()
	return yrp_keybinds
end

local DATABASE_NAME = "yrp_keybinds"

function get_keybind(name)
	name = tostring(name)
	return tonumber(yrp_keybinds[name]) or -1
end

function set_keybind(name, value, force)
	if value != 0 then
		for n, v in pairs(yrp_keybinds) do
			if n == "version" or force then
				continue
			end
			if tonumber(value) == tonumber(v) and name != n and !string.StartWith(n, "menu_options_") then
				return false
			end
		end
	end

	local result = SQL_UPDATE(DATABASE_NAME, "'" .. name .. "' = '" .. value .. "'", "uniqueID = '" .. 1 .. "'")
	yrp_keybinds[name] = value
	return true
end

function GetKeybindName(kbname)
	local _kb = kbname
	if !string.StartWith(kbname, "in_") then
		_kb = get_keybind(kbname) or "UNKNOWN"
	end
	if isnumber(tonumber(_kb)) then
		_kb = input.GetKeyName(_kb)
	end
	if string.StartWith(kbname, "in_") then
		_kb = YRP.lang_string("LID_" .. kbname)
	end
	return tostring(_kb)
end

--db_drop_table("yrp_keybinds")
function check_yrp_keybinds()
	SQL_INIT_DATABASE(DATABASE_NAME)

	SQL_UPDATE(DATABASE_NAME, "speak_next = '0'")
	SQL_UPDATE(DATABASE_NAME, "speak_prev = '0'")

	local _check_version = SQL_SELECT(DATABASE_NAME, "version", "uniqueID = 1")
	if _check_version != false and _check_version != nil then
		YRP.msg("note", "Checking keybinds version")
		_check_version = _check_version[1]
		if tonumber(_check_version.version) != tonumber(yrp_keybinds.version) then

			YRP.msg("note", "Keybinds OUTDATED!")
			db_drop_table(DATABASE_NAME)
			SQL_INIT_DATABASE(DATABASE_NAME)
		else
			YRP.msg("note", "Keybinds up to date")
		end
	end

	SQL_ADD_COLUMN(DATABASE_NAME, "version", "INT DEFAULT " .. yrp_keybinds.version)
	-- Keybind Cols
	for i, keybind in pairs(YRPKEYBINDS) do
		SQL_ADD_COLUMN(DATABASE_NAME, i, "INT DEFAULT " .. keybind)
	end


	local _tmp = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = 1")
	if _tmp == nil then
		local _result = SQL_INSERT_INTO_DEFAULTVALUES(DATABASE_NAME)
		_tmp = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = 1")
		if _tmp == nil or _tmp == false then
			YRP.msg("error", DATABASE_NAME .. " has no entries.")
		end
	end

	if !db_is_empty(DATABASE_NAME) then
		local _tmp2 = SQL_SELECT(DATABASE_NAME, "*", nil)
		_tmp2 = _tmp2[1]

		yrp_keybinds = _tmp2
	end
end
check_yrp_keybinds()

function YResetKeybinds()
	for i, keybind in pairs(YRPKEYBINDS) do
		set_keybind(i, keybind)
	end
end
