--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local _hudVersion = 6

local dbNameHUD = "yrp_cl_hud"

local yrp_cl_db = {}
yrp_cl_db["_loaded"] = false

function HudV(name)
	return yrp_cl_db[name] or 0
end

function set_hud_db_val(name, value)
	yrp_cl_db[name] = value
end

function HUDTab(to, px, py, sw, sh, aw, ah, tx, ty, sf, tt, it, tr)
	local tmp = {}
	tmp.to = to
	tmp.px = px
	tmp.py = py
	tmp.sw = sw
	tmp.sh = sh
	tmp.aw = aw
	tmp.ah = ah
	tmp.tx = tx
	tmp.ty = ty
	tmp.sf = sf
	tmp.tt = tt
	tmp.it = it
	tmp.tr = tr
	return tmp
end

function colTab(r, g, b, a)
	local tmp = {}
	tmp.r = r
	tmp.g = g
	tmp.b = b
	tmp.a = a
	return tmp
end

function checkDBHUD(name, value)
	local tmpValue = SQL_SELECT("yrp_cl_hud", "value", "name = '" .. name .. "'")
	if tmpValue == nil then
		SQL_INSERT_INTO("yrp_cl_hud", "name, value", "'" .. name .. "', " .. value)
		return false
	else
		return true
	end
end

function checkDBColor(name)
	--rgb
	checkDBHUD(name .. "r", 255)
	checkDBHUD(name .. "g", 255)
	checkDBHUD(name .. "b", 255)

	--a
	checkDBHUD(name .. "a", 255)
end

function checkDBHUDGroup(name)
	--Toggle
	checkDBHUD(name .. "to", 1)

	--Position
	checkDBHUD(name .. "px", 1)
	checkDBHUD(name .. "py", 1)

	--Size
	checkDBHUD(name .. "sw", 1)
	checkDBHUD(name .. "sh", 1)
	checkDBHUD(name .. "sf", 1)

	--anchor
	checkDBHUD(name .. "aw", 1)
	checkDBHUD(name .. "ah", 1)

	--align
	checkDBHUD(name .. "tx", 1)
	checkDBHUD(name .. "ty", 1)

	--toggletext
	checkDBHUD(name .. "tt", 1)

	--icontoggle
	checkDBHUD(name .. "it", 1)

	--toggleradial
	checkDBHUD(name .. "tr", 1)
end

function loadDBHUD(name)
	local tmpValue = SQL_SELECT("yrp_cl_hud", "value", "name = '" .. name .. "'")
	if worked(tmpValue, "loadDBHUD failed!") then
		yrp_cl_db[name] = tonumber(tmpValue[1].value)
	end
end

function loadDBColorGroup(name)
	--rgb
	loadDBHUD(name .. "r")
	loadDBHUD(name .. "g")
	loadDBHUD(name .. "b")

	--a
	loadDBHUD(name .. "a")
end

function loadDBHUDGroup(name)
	--Toggle
	loadDBHUD(name .. "to")

	--Position
	loadDBHUD(name .. "px")
	loadDBHUD(name .. "py")

	--Size
	loadDBHUD(name .. "sw")
	loadDBHUD(name .. "sh")
	loadDBHUD(name .. "sf")

	--anchor
	loadDBHUD(name .. "aw")
	loadDBHUD(name .. "ah")

	--align
	loadDBHUD(name .. "tx")
	loadDBHUD(name .. "ty")

	--toggletext
	loadDBHUD(name .. "tt")

	--icontoggle
	loadDBHUD(name .. "it")

	--toggleradial
	loadDBHUD(name .. "tr")
end

local defaultFS = 26
function loadCompleteHUD()
	local dbName = dbNameHUD
	printGM("db", "loading HUD")

	loadDBHUDGroup("hp") --Health
	loadDBHUDGroup("ar") --Armor
	loadDBHUDGroup("mh") --Hunger
	loadDBHUDGroup("mt") --Thirst
	loadDBHUDGroup("ms") --Stamina
	loadDBHUDGroup("ma") --Mana
	loadDBHUDGroup("ca") --Cast
	loadDBHUDGroup("mo") --Money
	loadDBHUDGroup("xp") --Xp

	loadDBHUDGroup("mm") --Minimap
	loadDBHUDGroup("wn") --WeaponName
	loadDBHUDGroup("wp") --WeaponPrimary
	loadDBHUDGroup("ws") --WeaponSecondary
	loadDBHUDGroup("tt") --Tooltip
	loadDBHUDGroup("st") --Status
	loadDBHUDGroup("vt") --Vote
	loadDBHUDGroup("cb") --ChatBox
	loadDBHUDGroup("ut") --Uptime

	loadDBHUDGroup("bl") --Batterylife
	loadDBHUDGroup("rt") --RealTime

	--crosshair
	loadDBHUD("cht")
	loadDBHUD("chl")
	loadDBHUD("chg")
	loadDBHUD("chh")
	loadDBHUD("chbr")

	--colors
	loadDBColorGroup("colbg")
	loadDBColorGroup("colbr")
	loadDBColorGroup("colchc")
	loadDBColorGroup("colchbr")
	loadDBColorGroup("mdp")
	loadDBHUD("mdpm")
	loadDBColorGroup("mds")

	loadDBHUD("_hudversion")

	--loaded
	yrp_cl_db["_loaded"] = true
	printGM("db", "loaded HUD")
end

function dbUpdateHUD(_name, _value)
	if worked(_name, "dbUpdateHUD _name " .. tostring(_name)) and worked(_value, "dbUpdateHUD _value " .. tostring(_value)) then
		SQL_UPDATE("yrp_cl_hud", "value = " .. _value, "name = '" .. _name .. "'")
		loadDBHUD(_name)
	end
end

function dbUpdateColor(name, tab)
	dbUpdateHUD(name .. "r", tab.r)
	dbUpdateHUD(name .. "g", tab.g)
	dbUpdateHUD(name .. "b", tab.b)

	dbUpdateHUD(name .. "a", tab.a)
end

function dbUpdateHUDGroup(name, tab)
	dbUpdateHUD(name .. "to", tab.to)

	dbUpdateHUD(name .. "px", tab.px)
	dbUpdateHUD(name .. "py", tab.py)

	dbUpdateHUD(name .. "sw", tab.sw)
	dbUpdateHUD(name .. "sh", tab.sh)
	dbUpdateHUD(name .. "sf", tab.sf)

	dbUpdateHUD(name .. "aw", tab.aw)
	dbUpdateHUD(name .. "ah", tab.ah)

	dbUpdateHUD(name .. "tx", tab.tx)
	dbUpdateHUD(name .. "ty", tab.ty)

	dbUpdateHUD(name .. "tt", tab.tt)

	dbUpdateHUD(name .. "it", tab.it)

	dbUpdateHUD(name .. "tr", tab.tr)
end

function dbUpdateColor(name, tab)
	dbUpdateHUD(name .. "r", tab.r)
	dbUpdateHUD(name .. "g", tab.g)
	dbUpdateHUD(name .. "b", tab.b)

	dbUpdateHUD(name .. "a", tab.a)
end

function setDefaultHUD()
	_hudversion	=	_hudVersion
	_loaded	=	true

	local hp = HUDTab(1, 20, -80, 440, 60, 0, 2, 1, 1, 24, 1, 1, 1)
	dbUpdateHUDGroup("hp", hp)

	local ar = HUDTab(1, 20, -140, 440, 60, 0, 2, 1, 1, 24, 1, 1, 1)
	dbUpdateHUDGroup("ar", ar)

	local mh = HUDTab(1, 20, -320, 440, 60, 0, 2, 1, 1, 24, 1, 1, 1)
	dbUpdateHUDGroup("mh", mh)

	local mt = HUDTab(1, 20, -380, 440, 60, 0, 2, 1, 1, 24, 1, 1, 1)
	dbUpdateHUDGroup("mt", mt)

	local ms = HUDTab(1, -300, -140, 600, 60, 1, 2, 1, 1, 24, 1, 1, 1)
	dbUpdateHUDGroup("ms", ms)

	local ma = HUDTab(0, 20, -440, 440, 60, 0, 2, 1, 1, 24, 1, 1, 1)
	dbUpdateHUDGroup("ma", ma)

	local ca = HUDTab(1, -300, -220, 600, 60, 1, 2, 1, 1, 24, 1, 1, 1)
	dbUpdateHUDGroup("ca", ca)

	local mo = HUDTab(1, 20, -260, 440, 60, 0, 2, 1, 1, 18, 1, 1, 1)
	dbUpdateHUDGroup("mo", mo)

	local xp = HUDTab(1, 20, -200, 440, 60, 0, 2, 1, 1, 18, 1, 1, 1)
	dbUpdateHUDGroup("xp", xp)

	local mm = HUDTab(0, 20, 20, 600, 600, 0, 0, 1, 1, 18, 1, 1, 1)
	dbUpdateHUDGroup("mm", mm)

	local wn = HUDTab(1, 480, -80, 440, 60, 0, 2, 1, 1, 24, 1, 1, 1)
	dbUpdateHUDGroup("wn", wn)

	local wp = HUDTab(1, 480, -140, 440, 60, 0, 2, 1, 1, 24, 1, 1, 1)
	dbUpdateHUDGroup("wp", wp)

	local ws = HUDTab(1, 480, -200, 440, 60, 0, 2, 1, 1, 24, 1, 1, 1)
	dbUpdateHUDGroup("ws", ws)

	local tt = HUDTab(1, 20, 20, 900, 600, 0, 0, 1, 1, 24, 1, 1, 1)
	dbUpdateHUDGroup("tt", tt)

	local st = HUDTab(1, -380, 40, 760, 60, 1, 0, 1, 1, 18, 1, 1, 1)
	dbUpdateHUDGroup("st", st)

	local vt = HUDTab(1, -380, 120, 760, 300, 1, 0, 1, 1, 18, 1, 1, 1)
	dbUpdateHUDGroup("vt", vt)

	local cb = HUDTab(1, 20, -980, 900, 520, 0, 2, 1, 1, 18, 1, 1, 1)
	dbUpdateHUDGroup("cb", cb)

	local ut = HUDTab(0, -400, 140, 400, 240, 2, 0, 1, 1, 18, 1, 1, 1)
	dbUpdateHUDGroup("ut", ut)

	local bl = HUDTab(1, -400, 0, 400, 60, 2, 0, 1, 1, 18, 1, 1, 1)
	dbUpdateHUDGroup("bl", bl)

	local rt = HUDTab(0, -400, 60, 400, 60, 2, 0, 1, 1, 18, 1, 1, 1)
	dbUpdateHUDGroup("rt", rt)

	--crosshair
	dbUpdateHUD("cht", 1)
	dbUpdateHUD("chl", 10)
	dbUpdateHUD("chg", 10)
	dbUpdateHUD("chh", 1)
	dbUpdateHUD("chbr", 1)

	--colors
	local bg = colTab(0, 0, 0, 200)
	dbUpdateColor("colbg", bg)

	local br = colTab(0, 0, 0, 255)
	dbUpdateColor("colbr", br)

	local chc = colTab(0, 255, 0, 255)
	dbUpdateColor("colchc", chc)

	local chbr = colTab(0, 0, 0, 255)
	dbUpdateColor("colchbr", chbr)

	local mdp = colTab(66, 66, 66, 255)
	dbUpdateColor("mdp", mdp)
	dbUpdateHUD("mdpm", 0)

	local mds = colTab(13, 71, 161, 255)
	dbUpdateColor("mds", mds)

	loadCompleteHUD()
end

function resetHud()
	printGM("note", "yrp_cl_hud reseted")

	setDefaultHUD()

	update_db_fonts()
end

--db_drop_table("yrp_cl_hud")

function loadDatabaseHUD()
	local ply = LocalPlayer()
	local dbName = dbNameHUD
	printGM("db", "Load Database: HUD")

	if !sql.TableExists(dbName) then
		printGM("db", "CREATE Database " .. dbName)
		local query = "CREATE TABLE " .. dbName .. " ("
		query = query .. "name TEXT, "
		query = query .. "value INT"

		query = query .. ");"
		local result = sql.Query(query)
		if result == false then
			sql_show_last_error()
		end
	end

	checkDBHUDGroup("hp") --Health
	checkDBHUDGroup("ar") --Armor
	checkDBHUDGroup("mh") --Hunger
	checkDBHUDGroup("mt") --Thirst
	checkDBHUDGroup("ms") --Stamina
	checkDBHUDGroup("ma") --Mana
	checkDBHUDGroup("ca") --Cast
	checkDBHUDGroup("mo") --Money
	checkDBHUDGroup("xp") --XP

	checkDBHUDGroup("mm") --Minimap
	checkDBHUDGroup("wn") --WeaponName
	checkDBHUDGroup("wp") --WeaponPrimary
	checkDBHUDGroup("ws") --WeaponSecondary
	checkDBHUDGroup("tt") --Tooltip
	checkDBHUDGroup("st") --Status
	checkDBHUDGroup("vt") --Vote
	checkDBHUDGroup("cb") --ChatBox
	checkDBHUDGroup("ut") --uptime
	checkDBHUDGroup("bl") --Batterylife
	checkDBHUDGroup("rt") --RealTime

	--crosshair
	checkDBHUD("cht", 1)
	checkDBHUD("chl", 1)
	checkDBHUD("chg", 1)
	checkDBHUD("chh", 1)
	checkDBHUD("chbr", 1)

	--colors
	checkDBColor("colbg")
	checkDBColor("colbr")
	checkDBColor("colchc")
	checkDBColor("colchbr")
	checkDBColor("mdp")
	checkDBHUD("mdpm", 0)
	checkDBColor("mds")

	local _checkVersion = checkDBHUD("_hudversion", _hudVersion)
	local _resetHud = false
	local _hudText = ""
	if !_checkVersion then
		_hudText = "Hud is outdated, resetting it!"
		_resetHud = true
	else
		local _dbSelect = SQL_SELECT("yrp_cl_hud", "value", "name = '" .. "_hudversion" .. "'")
		if _dbSelect != nil and _dbSelect != false then
			if tonumber(_dbSelect[1].value) != _hudVersion then
				_hudText = "Newer version of hud available, resetting it!"
				dbUpdateHUD("_hudversion", _hudVersion)
				_resetHud = true
			else
				_hudText = "Hud up-to-date!"
			end
		else
			printGM("note", "loadDatabaseHUD _hudversion fail")
		end
	end
	printGM("note", _hudText)

	if _resetHud then
		resetHud()
	end

	loadCompleteHUD()
end

function is_hud_db_loaded()
	return yrp_cl_db["_loaded"]
end

function initDatabase()
	printGM("db", "initDatabase()")
	loadDatabaseHUD()
end
initDatabase()
