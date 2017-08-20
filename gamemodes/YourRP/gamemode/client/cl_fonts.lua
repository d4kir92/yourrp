//Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

//cl_fonts.lua

//##############################################################################
//Change Fonts
function changeFontSize()
	printGM( "db", "changeFontSize" )

	surface.CreateFont( "HudDefault", {
		font = "BankGothic_Bold", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = calculateToResu( 40 ),
		weight = 2000,
		blursize = 0,
		scanlines = 0,
		antialias = false,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	surface.CreateFont( "SettingsNormal", {
		font = "BankGothic_Bold", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = calculateToResu( 30 ),
		weight = 2000,
		blursize = 0,
		scanlines = 0,
		antialias = false,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	surface.CreateFont( "SettingsHeader", {
		font = "BankGothic_Bold", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = calculateToResu( 50 ),
		weight = 2000,
		blursize = 0,
		scanlines = 0,
		antialias = false,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	surface.CreateFont( "HudBars", {
		font = "BankGothic_Bold", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = calculateToResu( 28 ),
		weight = 3000,
		blursize = 0,
		scanlines = 0,
		antialias = false,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = true,
	} )

	surface.CreateFont( "roleInfoHeader", {
		font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = calculateToResu( 32 ),
		weight = 2,
		blursize = 0,
		scanlines = 0,
		antialias = false,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = true,
	} )

	surface.CreateFont( "roleInfoText", {
		font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = calculateToResu( 30 ),
		weight = 1,
		blursize = 0,
		scanlines = 0,
		antialias = false,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = true,
	} )

	surface.CreateFont( "charTitle", {
		font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = calculateToResu( 30 ),
		weight = 1,
		blursize = 0,
		scanlines = 0,
		antialias = false,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	surface.CreateFont( "charHeader", {
		font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = calculateToResu( 26 ),
		weight = 1,
		blursize = 0,
		scanlines = 0,
		antialias = false,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	surface.CreateFont( "charText", {
		font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = calculateToResu( 30 ),
		weight = 1,
		blursize = 0,
		scanlines = 0,
		antialias = false,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	surface.CreateFont( "pmT", {
		font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = calculateToResu( 26 ),
		weight = 1,
		blursize = 0,
		scanlines = 0,
		antialias = false,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = true,
	} )

	surface.CreateFont( "weaponT", {
		font = "Roboto-Thin", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = calculateToResu( 24 ),
		weight = 1,
		blursize = 0,
		scanlines = 0,
		antialias = false,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = true,
	} )

	surface.CreateFont( "HudVersion", {
		font = "Roboto-Bold", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = calculateToResu( 60 ),
		weight = 600,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = true,
	} )

	surface.CreateFont( "HudMinimap", {
		font = "Roboto-Bold", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = calculateToResu( 30 ),
		weight = 200,
		blursize = 0,
		scanlines = 0,
		antialias = false,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = true,
	} )

	surface.CreateFont( "SettingsNormal", {
		font = "Roboto-Thin", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = calculateToResu( 30 ),
		weight = 1,
		blursize = 0,
		scanlines = 0,
		antialias = false,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = true,
	} )

	surface.CreateFont( "ScoreBoardTitle", {
		font = "Roboto-Thin", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = calculateToResu( 60 ),
		weight = 1,
		blursize = 0,
		scanlines = 0,
		antialias = false,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = true,
	} )

	surface.CreateFont( "ScoreBoardNormal", {
		font = "Roboto-Thin", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = calculateToResu( 30 ),
		weight = 1,
		blursize = 0,
		scanlines = 0,
		antialias = false,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = true,
	} )

	surface.CreateFont( "ATM_Header", {
		font = "Roboto-Thin", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = calculateToResu( 160 ),
		weight = 1,
		blursize = 0,
		scanlines = 0,
		antialias = false,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = true,
	} )

	surface.CreateFont( "ATM_Normal", {
		font = "Roboto-Thin", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = calculateToResu( 100 ),
		weight = 1,
		blursize = 0,
		scanlines = 0,
		antialias = false,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = true,
	} )

	surface.CreateFont( "ATM_Name", {
		font = "Roboto-Thin", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = calculateToResu( 60 ),
		weight = 1,
		blursize = 0,
		scanlines = 0,
		antialias = false,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = true,
	} )
end
changeFontSize()
//##############################################################################
