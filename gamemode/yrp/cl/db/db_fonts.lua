--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local font = font or "Ubuntu"
local fontscale = fontscale or 1
local fonts = fonts or {}

function YRP.AddFont(fontname, scale)
	fontname = fontname or ""
	local fontID = string.lower(fontname)
	if fontID != "" and fonts[fontID] == nil and scale != nil then
		local fontentry = {}
		fontentry.name = fontname
		fontentry.scale = scale
		fonts[fontID] = fontentry
	end
end

YRP.AddFont("AmazDooMLeft", 1)
YRP.AddFont("Aniron", 1.2)
YRP.AddFont("Arial", 0.94)

YRP.AddFont("Caribbean", 0.7)
YRP.AddFont("Comfortaa", 1.1)

YRP.AddFont("Gang of Three", 0.9)

YRP.AddFont("Halo", 0.58)
YRP.AddFont("Harry Potter", 1)

YRP.AddFont("Impact", 1)

YRP.AddFont("Kelt", 1)
YRP.AddFont("Kimberley Bl", 0.96)

YRP.AddFont("Mali", 1.6)
YRP.AddFont("Metro", 0.5)
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

local savedfonts = {}

function YRP.SetFont(fontname)
	if wk(fontname) then
		local fontID = string.lower(fontname)
		local fontTab = fonts[fontID]
		if wk(fontTab) then
			font = fontTab.name or ""
			fontscale = fontTab.scale or ""
			table.Empty(savedfonts)
			YRP.msg("note", "Changed font to: " .. font .. " Scale(" .. fontscale .. ")")
			changeFontSize()
		else
			YRP.msg("error", "fontname: " .. tostring(fontname) .. " fontTab: " .. tostring(fontTab))
		end
	end
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

function yrp_create_font(_name, _font, _size, _weight, _outline, _shadow)
	if wk(_name) and wk(_font) and wk(_size) then
		if table.HasValue(savedfonts, _name) then
			--
		else
			table.insert(savedfonts, _name)
			surface.CreateFont(_name, {
				font = _font, -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
				extended = true,
				size = YRP.ctr(_size * fontscale * 2),
				weight = _weight or 14,
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
end

local oldfont = ""
function changeFontSize()
	if YRP.GetFont() != oldfont then
		oldfont = YRP.GetFont()
		printGM("db", "changeFontSize")

		for s = 4, 100 do
			yrp_create_font("Y_" .. s .. "_500", YRP.GetFont(), s, 500, false)
			yrp_create_font("Y_" .. s .. "_700", YRP.GetFont(), s, 700, false)
		end

		--DarkRP Fonts
		yrp_create_font("DarkRPHUD1", YRP.GetFont(), 16, 500, false)
		yrp_create_font("DarkRPHUD2", YRP.GetFont(), 24, 500, false)
		yrp_create_font("Trebuchet18", YRP.GetFont(), 16, 500, false)
		yrp_create_font("Trebuchet20", YRP.GetFont(), 20, 500, false)
		yrp_create_font("Trebuchet24", YRP.GetFont(), 24, 500, false)
		yrp_create_font("Trebuchet48", YRP.GetFont(), 48, 500, false)
		yrp_create_font("TabLarge", YRP.GetFont(), 16, 700, false)
		yrp_create_font("UiBold", YRP.GetFont(), 16, 700, false)
		yrp_create_font("HUDNumber5", YRP.GetFont(), 30, 700, false)
		yrp_create_font("ScoreboardHeader", YRP.GetFont(), 32, 500, false)
		yrp_create_font("ScoreboardSubtitle", YRP.GetFont(), 24, 500, false)
		yrp_create_font("ScoreboardPlayerName", YRP.GetFont(), 19, 500, false)
		yrp_create_font("ScoreboardPlayerName2", YRP.GetFont(), 15, 500, false)
		yrp_create_font("ScoreboardPlayerNameBig", YRP.GetFont(), 24, 500, false)
		yrp_create_font("AckBarWriting", YRP.GetFont(), 20, 500, false)
		yrp_create_font("DarkRP_tipjar", YRP.GetFont(), 100, 500, false)
	end
end
changeFontSize()

local files, _ = file.Find("resource/fonts/*.ttf", "GAME")
for i, f in pairs(files) do
	if string.EndsWith(f, "-regular.ttf") then
		local fo = string.Replace(f, "-regular.ttf", "")
		YRP.AddFont(fo, 1)
	end
end
