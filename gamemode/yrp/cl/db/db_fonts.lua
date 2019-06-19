--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local font = "Ubuntu"
local fontscale = 1
local fonts = {}

function YRP.AddFont(fontname, scale)
	fonts[string.lower(fontname)] = scale
end

YRP.AddFont("Aniron", 1.2)
YRP.AddFont("AmazDooMLeft", 1)
YRP.AddFont("Arial", 0.94)

YRP.AddFont("Caribbean", 0.7)
YRP.AddFont("Comfortaa", 1.1)

YRP.AddFont("Gang of Three", 0.9)

YRP.AddFont("Halo", 0.58)
YRP.AddFont("Harry Potter", 1)

YRP.AddFont("Kelt", 1)
YRP.AddFont("Kimberley Bl", 0.96)

YRP.AddFont("Mali", 1.6)
YRP.AddFont("Military Font 7", 0.72)

YRP.AddFont("Overseer", 1)

YRP.AddFont("pixelmix", 0.7)
YRP.AddFont("Pokemon Solid", 2)
YRP.AddFont("pricedown bl", 1.34)

YRP.AddFont("Roboto", 1)

YRP.AddFont("Space Age", 1.1)
YRP.AddFont("Star Jedi", 1.3)
YRP.AddFont("Starcraft", 0.72)
YRP.AddFont("Swanky and Moo Moo", 1.3)

YRP.AddFont("Tahoma", 1)

YRP.AddFont("Ubuntu", 1)

YRP.AddFont("ZombieA", 0.74)

function YRP.GetFonts()
	return fonts
end

function YRP.GetFont()
	return font
end

function YRP.SetFont(fontname)
	font = fontname
	fontscale = fonts[fontname]
	changeFontSize()
end

net.Receive("yrp_set_font", function(len)
	local fname = net.ReadString()
	YRP.SetFont(fname)
end)
timer.Simple(1, function()
	net.Start("yrp_set_font")
	net.SendToServer()
end)

function GetFontSizeTable()
	local tab = {}
	table.insert(tab, 8)
	table.insert(tab, 9)
	table.insert(tab, 10)
	table.insert(tab, 11)
	table.insert(tab, 12)
	table.insert(tab, 14)
	table.insert(tab, 18)
	table.insert(tab, 24)
	table.insert(tab, 30)
	table.insert(tab, 36)
	table.insert(tab, 48)
	table.insert(tab, 60)
	table.insert(tab, 72)
	table.insert(tab, 96)
	return tab
end

local _weight = 500

function createFont(_name, _font, _size, __weight, _outline, _shadow)
	if wk(_name) and wk(_font) then
		surface.CreateFont(_name, {
			font = _font, -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
			extended = true,
			size = _size * fontscale,
			weight = _weight or _weight,
			blursize = 0,
			scanlines = 0,
			antialias = true,
			underline = false,
			italic = false,
			strikeout = false,
			symbol = false,
			rotary = false,
			shadow = _shadow or false,
			additive = false,
			outline = _outline or false
		})
	end
end

function changeFontSizeOf(_font, _size)
	printGM("note", "changeFontSizeOf" .. _font .. _size)
	createFont(_font, YRP.GetFont(), _size, _weight, false)
end

function changeFontSize()
	printGM("db", "changeFontSize")

	for i, s in pairs(GetFontSizeTable()) do
		createFont("YRP_" .. s .. "_500", YRP.GetFont(), s, 500, false)
		createFont("YRP_" .. s .. "_600", YRP.GetFont(), s, 600, false)
		createFont("YRP_" .. s .. "_700", YRP.GetFont(), s, 700, false)

		createFont("YRP_O_" .. s .. "_500", YRP.GetFont(), s, 500, true)
		createFont("YRP_O_" .. s .. "_600", YRP.GetFont(), s, 600, true)
		createFont("YRP_O_" .. s .. "_700", YRP.GetFont(), s, 700, true)
	end

	for i, s in pairs(GetFontSizeTable()) do
		createFont("Roboto" .. s, YRP.GetFont(), s, _weight, false)
		createFont("Roboto" .. s .. "B", YRP.GetFont(), s, 700, false)
	end

	--[[ DESIGNS ]]--
	createFont("mat1header", YRP.GetFont(), 22, _weight, false)
	createFont("mat1text", YRP.GetFont(), 18, 0, false)

	--[[ EMOTES ]]--
	createFont("emotes", YRP.GetFont(), 22, _weight, false)

	--[[ 3D2D ]]--
	createFont("3d2d_string", YRP.GetFont(), 22, _weight, false)

	--[[ Settings ]]--
	createFont("Settings_Normal", YRP.GetFont(), 22, _weight, false)
	createFont("Settings_Header", YRP.GetFont(), 26, _weight, false)

	createFont("apph1", YRP.GetFont(), fontr(36), _weight, false)
	createFont("appt", YRP.GetFont(), fontr(30), _weight, false)

	createFont("appname", YRP.GetFont(), ctrb(28), _weight, false)

	createFont("plates", YRP.GetFont(), 30, _weight, false)
	createFont("plyinfo", YRP.GetFont(), 18, _weight, false)

	createFont("mdMenu", YRP.GetFont(), 17, 700, false)

	createFont("windowTitle", YRP.GetFont(), 18, 700, false)

	createFont("HudSettings", YRP.GetFont(), 24, _weight, false)

	createFont("HudDefault", YRP.GetFont(), 72, _weight, false)

	createFont("SettingsNormal", YRP.GetFont(), 24, _weight, false)
	createFont("SettingsHeader", YRP.GetFont(), 30, _weight, false)

	createFont("roleInfoHeader", YRP.GetFont(), 24, _weight, false)
	createFont("roleInfoText", YRP.GetFont(), 20, _weight, false)

	createFont("charTitle", YRP.GetFont(), 20, 700, false)
	createFont("charHeader", YRP.GetFont(), 20, 700, false)
	createFont("charText", YRP.GetFont(), 20, 700, false)

	createFont("pmT", YRP.GetFont(), 18, _weight, false)
	createFont("weaponT", YRP.GetFont(), 14, _weight, false)

	createFont("HudBars", YRP.GetFont(), 24, _weight, false)
	createFont("HudHeader", YRP.GetFont(), 36, _weight, false)
	createFont("HudVersion", YRP.GetFont(), 30, 700, false)

	createFont("72", YRP.GetFont(), 72, _weight, false)
	--Creating
	createFont("mmsf", YRP.GetFont(), 24, _weight, false)
	createFont("hpsf", YRP.GetFont(), 24, _weight, false)
	createFont("arsf", YRP.GetFont(), 24, _weight, false)
	createFont("wpsf", YRP.GetFont(), 24, _weight, false)
	createFont("wssf", YRP.GetFont(), 24, _weight, false)
	createFont("wnsf", YRP.GetFont(), 24, _weight, false)
	createFont("ttsf", YRP.GetFont(), 24, _weight, false)
	createFont("mosf", YRP.GetFont(), 24, _weight, false)
	createFont("mhsf", YRP.GetFont(), 24, _weight, false)
	createFont("mtsf", YRP.GetFont(), 24, _weight, false)
	createFont("mssf", YRP.GetFont(), 24, _weight, false)
	createFont("vtsf", YRP.GetFont(), 24, _weight, false)
	createFont("cbsf", YRP.GetFont(), 24, _weight, false)
	createFont("masf", YRP.GetFont(), 24, _weight, false)
	createFont("casf", YRP.GetFont(), 24, _weight, false)
	createFont("stsf", YRP.GetFont(), 24, _weight, false)
	createFont("xpsf", YRP.GetFont(), 24, _weight, false)
	createFont("utsf", YRP.GetFont(), 24, _weight, false)
	createFont("blsf", YRP.GetFont(), 24, _weight, false)
	createFont("rtsf", YRP.GetFont(), 24, _weight, false)

	createFont("sef", YRP.GetFont(), 24, 1, false)

	createFont("ScoreBoardTitle", YRP.GetFont(), 24, _weight, false)
	createFont("ScoreBoardNormal", YRP.GetFont(), 20, _weight, false)

	createFont("ATM_Header", YRP.GetFont(), 80, _weight, false)
	createFont("ATM_Normal", YRP.GetFont(), 60, _weight, false)
	createFont("ATM_Name", YRP.GetFont(), 40, _weight, false)

	--DarkRP Fonts
	createFont("DarkRPHUD1", YRP.GetFont(), 16, _weight, false)
	createFont("DarkRPHUD2", YRP.GetFont(), 24, _weight, false)
	createFont("Trebuchet18", YRP.GetFont(), 16, _weight, false)
	createFont("Trebuchet20", YRP.GetFont(), 20, _weight, false)
	createFont("Trebuchet24", YRP.GetFont(), 24, _weight, false)
	createFont("Trebuchet48", YRP.GetFont(), 48, _weight, false)
	createFont("TabLarge", YRP.GetFont(), 16, 700, false)
	createFont("UiBold", YRP.GetFont(), 16, 800, false)
	createFont("HUDNumber5", YRP.GetFont(), 30, 800, false)
	createFont("ScoreboardHeader", YRP.GetFont(), 32, _weight, false)
	createFont("ScoreboardSubtitle", YRP.GetFont(), 24, _weight, false)
	createFont("ScoreboardPlayerName", YRP.GetFont(), 19, _weight, false)
	createFont("ScoreboardPlayerName2", YRP.GetFont(), 15, _weight, false)
	createFont("ScoreboardPlayerNameBig", YRP.GetFont(), 24, _weight, false)
	createFont("AckBarWriting", YRP.GetFont(), 20, _weight, false)
	createFont("DarkRP_tipjar", YRP.GetFont(), 100, _weight, false)
end
changeFontSize()
