--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
local DATABASE_NAME = "yrp_hud"
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "name", "TEXT DEFAULT ''")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "value", "TEXT DEFAULT ''")
if YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = 1") == nil then
	YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'Version', '1'")
end

--YRP_SQL_DROP_TABLE(DATABASE_NAME)
function AddHUDElement(tab, reset)
	for name, value in pairs(tab.floats) do
		local _name = "float_HUD_" .. tab.element .. "_" .. name
		if YRP_SQL_SELECT(DATABASE_NAME, "*", "name = '" .. _name .. "'") == nil then
			YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. _name .. "', '" .. value .. "'")
		end

		if reset then
			YRP_SQL_UPDATE(
				DATABASE_NAME,
				{
					["value"] = value
				}, "name = '" .. _name .. "'"
			)
		end
	end

	for name, value in pairs(tab.bools) do
		local _name = "bool_HUD_" .. tab.element .. "_" .. name
		if YRP_SQL_SELECT(DATABASE_NAME, "*", "name = '" .. _name .. "'") == nil then
			YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. _name .. "', '" .. value .. "'")
		end

		if reset then
			YRP_SQL_UPDATE(
				DATABASE_NAME,
				{
					["value"] = value
				}, "name = '" .. _name .. "'"
			)
		end
	end

	for name, value in pairs(tab.colors) do
		local _name = "color_HUD_" .. tab.element .. "_" .. name
		if YRP_SQL_SELECT(DATABASE_NAME, "*", "name = '" .. _name .. "'") == nil then
			YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. _name .. "', '" .. value .. "'")
		end

		if reset then
			YRP_SQL_UPDATE(
				DATABASE_NAME,
				{
					["value"] = value
				}, "name = '" .. _name .. "'"
			)
		end
	end

	if tab.ints ~= nil then
		for name, value in pairs(tab.ints) do
			local _name = "int_HUD_" .. tab.element .. "_" .. name
			if YRP_SQL_SELECT(DATABASE_NAME, "*", "name = '" .. _name .. "'") == nil then
				YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. _name .. "', '" .. value .. "'")
			end

			if reset then
				YRP_SQL_UPDATE(
					DATABASE_NAME,
					{
						["value"] = value
					}, "name = '" .. _name .. "'"
				)
			end
		end
	end

	if tab.strings ~= nil then
		for name, value in pairs(tab.strings) do
			local _name = "text_HUD_" .. tab.element .. "_" .. name
			if YRP_SQL_SELECT(DATABASE_NAME, "*", "name = '" .. _name .. "'") == nil then
				YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. _name .. "', '" .. value .. "'")
			end

			if reset then
				YRP_SQL_UPDATE(
					DATABASE_NAME,
					{
						["value"] = value
					}, "name = '" .. _name .. "'"
				)
			end
		end
	end
end

function DefaultHUDSettings(reset)
	for i = 1, 10 do
		BOX = {}
		BOX.element = "BOX" .. i
		BOX.floats = {}
		BOX.floats.POSI_X = 0.5 + (i - 1) * 50 / 1920
		BOX.floats.POSI_Y = 0.5
		BOX.floats.SIZE_W = 50 / 1920
		BOX.floats.SIZE_H = 50 / 1080
		BOX.bools = {}
		BOX.bools.VISI = 0
		BOX.bools.ROUN = 0
		BOX.bools.ICON = 1
		BOX.bools.TEXT = 1
		BOX.bools.PERC = 1
		BOX.bools.BACK = 1
		BOX.bools.BORD = 0
		BOX.bools.EXTR = 1
		BOX.colors = {}
		BOX.colors.TE = "255, 255, 255, 255"
		BOX.colors.TB = "255, 255, 255, 255"
		BOX.colors.BG = "255, 255, 255, 255"
		BOX.colors.BA = "255, 255, 255, 255"
		BOX.colors.BR = "255, 255, 255, 255"
		BOX.ints = {}
		BOX.ints.AX = 1
		BOX.ints.AY = 1
		BOX.ints.TS = 18
		BOX.strings = {}
		BOX.strings.CTEX = ""
		AddHUDElement(BOX, reset)
	end

	reset = reset or false
	local HP = {}
	HP.element = "HP"
	HP.floats = {}
	HP.floats.POSI_X = 0.0026041667442769
	HP.floats.POSI_Y = 0.87037038803101
	HP.floats.SIZE_W = 0.11458333581686
	HP.floats.SIZE_H = 0.027777777984738
	HP.bools = {}
	HP.bools.VISI = 1
	HP.bools.ROUN = 0
	HP.bools.ICON = 1
	HP.bools.TEXT = 1
	HP.bools.PERC = 1
	HP.bools.BACK = 1
	HP.bools.BORD = 0
	HP.bools.EXTR = 1
	HP.colors = {}
	HP.colors.TE = "255, 255, 255, 255"
	HP.colors.TB = "0, 0, 0, 255"
	HP.colors.BG = "0, 0, 0, 120"
	HP.colors.BA = "200, 52, 52, 180"
	HP.colors.BR = "200, 52, 52, 180"
	HP.ints = {}
	HP.ints.AX = 1
	HP.ints.AY = 1
	HP.ints.TS = 24
	AddHUDElement(HP, reset)
	local AR = {}
	AR.element = "AR"
	AR.floats = {}
	AR.floats.POSI_X = 0.0026041667442769
	AR.floats.POSI_Y = 0.90277779102325
	AR.floats.SIZE_W = 0.11458333581686
	AR.floats.SIZE_H = 0.027777777984738
	AR.bools = {}
	AR.bools.VISI = 1
	AR.bools.ROUN = 0
	AR.bools.ICON = 1
	AR.bools.TEXT = 1
	AR.bools.PERC = 1
	AR.bools.BACK = 1
	AR.bools.BORD = 0
	AR.bools.EXTR = 1
	AR.colors = {}
	AR.colors.TE = "255, 255, 255, 255"
	AR.colors.TB = "0, 0, 0, 255"
	AR.colors.BG = "0, 0, 0, 120"
	AR.colors.BA = "100, 100, 255, 180"
	AR.colors.BR = "100, 100, 255, 180"
	AR.ints = {}
	AR.ints.AX = 1
	AR.ints.AY = 1
	AR.ints.TS = 24
	AddHUDElement(AR, reset)
	local XP = {}
	XP.element = "XP"
	XP.floats = {}
	XP.floats.POSI_X = 0.25260415673256
	XP.floats.POSI_Y = 0.0
	XP.floats.SIZE_W = 0.49479165673256
	XP.floats.SIZE_H = 0.018518518656492
	XP.bools = {}
	XP.bools.VISI = 1
	XP.bools.ROUN = 0
	XP.bools.ICON = 1
	XP.bools.TEXT = 1
	XP.bools.PERC = 1
	XP.bools.BACK = 1
	XP.bools.BORD = 0
	XP.bools.EXTR = 1
	XP.colors = {}
	XP.colors.TE = "255, 255, 255, 255"
	XP.colors.TB = "0, 0, 0, 255"
	XP.colors.BG = "0, 0, 0, 120"
	XP.colors.BA = "25, 100, 227, 180"
	XP.colors.BR = "25, 100, 227, 180"
	XP.ints = {}
	XP.ints.AX = 1
	XP.ints.AY = 1
	XP.ints.TS = 18
	AddHUDElement(XP, reset)
	local MO = {}
	MO.element = "MO"
	MO.floats = {}
	MO.floats.POSI_X = 0.8828125
	MO.floats.POSI_Y = 0.0046296296641231
	MO.floats.SIZE_W = 0.11458333581686
	MO.floats.SIZE_H = 0.027777777984738
	MO.bools = {}
	MO.bools.VISI = 1
	MO.bools.ROUN = 0
	MO.bools.ICON = 1
	MO.bools.TEXT = 1
	MO.bools.PERC = 1
	MO.bools.BACK = 1
	MO.bools.BORD = 0
	MO.bools.EXTR = 1
	MO.colors = {}
	MO.colors.TE = "255, 255, 255, 255"
	MO.colors.TB = "0, 0, 0, 255"
	MO.colors.BG = "0, 0, 0, 120"
	MO.colors.BA = "33, 108, 42, 180"
	MO.colors.BR = "33, 108, 42, 180"
	MO.ints = {}
	MO.ints.AX = 1
	MO.ints.AY = 1
	MO.ints.TS = 24
	AddHUDElement(MO, reset)
	local SA = {}
	SA.element = "SA"
	SA.floats = {}
	SA.floats.POSI_X = 0.8828125
	SA.floats.POSI_Y = 0.037037037312984
	SA.floats.SIZE_W = 0.11458333581686
	SA.floats.SIZE_H = 0.027777777984738
	SA.bools = {}
	SA.bools.VISI = 0
	SA.bools.ROUN = 0
	SA.bools.ICON = 1
	SA.bools.TEXT = 1
	SA.bools.PERC = 1
	SA.bools.BACK = 1
	SA.bools.BORD = 0
	SA.bools.EXTR = 1
	SA.colors = {}
	SA.colors.TE = "255, 255, 255, 255"
	SA.colors.TB = "0, 0, 0, 255"
	SA.colors.BG = "0, 0, 0, 120"
	SA.colors.BA = "33, 108, 42, 255"
	SA.colors.BR = "33, 108, 42, 255"
	SA.ints = {}
	SA.ints.AX = 1
	SA.ints.AY = 1
	SA.ints.TS = 24
	AddHUDElement(SA, reset)
	local RO = {}
	RO.element = "RO"
	RO.floats = {}
	RO.floats.POSI_X = 0.265625
	RO.floats.POSI_Y = 0.87037038803101
	RO.floats.SIZE_W = 0.11458333581686
	RO.floats.SIZE_H = 0.027777777984738
	RO.bools = {}
	RO.bools.VISI = 0
	RO.bools.ROUN = 0
	RO.bools.ICON = 1
	RO.bools.TEXT = 1
	RO.bools.PERC = 1
	RO.bools.BACK = 1
	RO.bools.BORD = 0
	RO.bools.EXTR = 1
	RO.colors = {}
	RO.colors.TE = "255, 255, 255, 255"
	RO.colors.TB = "0, 0, 0, 255"
	RO.colors.BG = "0, 0, 0, 120"
	RO.colors.BA = "0, 0, 0, 100"
	RO.colors.BR = "255, 255, 255, 180"
	RO.ints = {}
	RO.ints.AX = 1
	RO.ints.AY = 1
	RO.ints.TS = 18
	AddHUDElement(RO, reset)
	local ST = {}
	ST.element = "ST"
	ST.floats = {}
	ST.floats.POSI_X = 0.41666665673256
	ST.floats.POSI_Y = 0.96759259700775
	ST.floats.SIZE_W = 0.16666667163372
	ST.floats.SIZE_H = 0.027777777984738
	ST.bools = {}
	ST.bools.VISI = 1
	ST.bools.ROUN = 0
	ST.bools.ICON = 1
	ST.bools.TEXT = 0
	ST.bools.PERC = 1
	ST.bools.BACK = 1
	ST.bools.BORD = 0
	ST.bools.EXTR = 1
	ST.colors = {}
	ST.colors.TE = "255, 255, 255, 255"
	ST.colors.TB = "0, 0, 0, 255"
	ST.colors.BG = "0, 0, 0, 120"
	ST.colors.BA = "200, 200, 50, 180"
	ST.colors.BR = "200, 200, 50, 180"
	ST.ints = {}
	ST.ints.AX = 1
	ST.ints.AY = 1
	ST.ints.TS = 24
	AddHUDElement(ST, reset)
	local CH = {}
	CH.element = "CH"
	CH.floats = {}
	CH.floats.POSI_X = 0.0026041667442769
	CH.floats.POSI_Y = 0.43055555224419
	CH.floats.SIZE_W = 0.25
	CH.floats.SIZE_H = 0.4351851940155
	CH.bools = {}
	CH.bools.VISI = 1
	CH.bools.ROUN = 0
	CH.bools.ICON = 1
	CH.bools.TEXT = 1
	CH.bools.PERC = 1
	CH.bools.BACK = 1
	CH.bools.BORD = 0
	CH.bools.EXTR = 1
	CH.colors = {}
	CH.colors.TE = "255, 255, 255, 255"
	CH.colors.TB = "0, 0, 0, 255"
	CH.colors.BG = "0, 0, 0, 120"
	CH.colors.BA = "255, 255, 255, 180"
	CH.colors.BR = "0, 0, 0, 255"
	CH.ints = {}
	CH.ints.AX = 1
	CH.ints.AY = 1
	CH.ints.TS = 20
	AddHUDElement(CH, reset)
	local HU = {}
	HU.element = "HU"
	HU.floats = {}
	HU.floats.POSI_X = 0.0026041667442769
	HU.floats.POSI_Y = 0.96759259700775
	HU.floats.SIZE_W = 0.11458333581686
	HU.floats.SIZE_H = 0.027777777984738
	HU.bools = {}
	HU.bools.VISI = 1
	HU.bools.ROUN = 0
	HU.bools.ICON = 1
	HU.bools.TEXT = 0
	HU.bools.PERC = 1
	HU.bools.BACK = 1
	HU.bools.BORD = 0
	HU.bools.EXTR = 1
	HU.colors = {}
	HU.colors.TE = "255, 255, 255, 255"
	HU.colors.TB = "0, 0, 0, 255"
	HU.colors.BG = "0, 0, 0, 120"
	HU.colors.BA = "150, 88, 52, 180"
	HU.colors.BR = "150, 88, 52, 180"
	HU.ints = {}
	HU.ints.AX = 1
	HU.ints.AY = 1
	HU.ints.TS = 24
	AddHUDElement(HU, reset)
	local TH = {}
	TH.element = "TH"
	TH.floats = {}
	TH.floats.POSI_X = 0.0026041667442769
	TH.floats.POSI_Y = 0.9351851940155
	TH.floats.SIZE_W = 0.11458333581686
	TH.floats.SIZE_H = 0.027777777984738
	TH.bools = {}
	TH.bools.VISI = 1
	TH.bools.ROUN = 0
	TH.bools.ICON = 1
	TH.bools.TEXT = 0
	TH.bools.PERC = 1
	TH.bools.BACK = 1
	TH.bools.BORD = 0
	TH.bools.EXTR = 1
	TH.colors = {}
	TH.colors.TE = "255, 255, 255, 255"
	TH.colors.TB = "0, 0, 0, 255"
	TH.colors.BG = "0, 0, 0, 120"
	TH.colors.BA = "52, 70, 150, 180"
	TH.colors.BR = "52, 70, 150, 180"
	TH.ints = {}
	TH.ints.AX = 1
	TH.ints.AY = 1
	TH.ints.TS = 24
	AddHUDElement(TH, reset)
	local AL = {}
	AL.element = "AL"
	AL.floats = {}
	AL.floats.POSI_X = 0.0026041667442769
	AL.floats.POSI_Y = 0.9351851940155
	AL.floats.SIZE_W = 0.11458333581686
	AL.floats.SIZE_H = 0.027777777984738
	AL.bools = {}
	AL.bools.VISI = 1
	AL.bools.ROUN = 0
	AL.bools.ICON = 1
	AL.bools.TEXT = 0
	AL.bools.PERC = 1
	AL.bools.BACK = 1
	AL.bools.BORD = 0
	AL.bools.EXTR = 1
	AL.colors = {}
	AL.colors.TE = "255, 255, 255, 255"
	AL.colors.TB = "0, 0, 0, 255"
	AL.colors.BG = "0, 0, 0, 120"
	AL.colors.BA = "52, 70, 150, 180"
	AL.colors.BR = "52, 70, 150, 180"
	AL.ints = {}
	AL.ints.AX = 1
	AL.ints.AY = 1
	AL.ints.TS = 24
	AddHUDElement(AL, reset)
	local CA = {}
	CA.element = "CA"
	CA.floats = {}
	CA.floats.POSI_X = 0.41666665673256
	CA.floats.POSI_Y = 0.9351851940155
	CA.floats.SIZE_W = 0.16666667163372
	CA.floats.SIZE_H = 0.027777777984738
	CA.bools = {}
	CA.bools.VISI = 1
	CA.bools.ROUN = 0
	CA.bools.ICON = 1
	CA.bools.TEXT = 1
	CA.bools.PERC = 1
	CA.bools.BACK = 1
	CA.bools.BORD = 0
	CA.bools.EXTR = 1
	CA.colors = {}
	CA.colors.TE = "255, 255, 255, 255"
	CA.colors.TB = "0, 0, 0, 255"
	CA.colors.BG = "0, 0, 0, 120"
	CA.colors.BA = "132, 116, 188, 180"
	CA.colors.BR = "132, 116, 188, 180"
	CA.ints = {}
	CA.ints.AX = 1
	CA.ints.AY = 1
	CA.ints.TS = 24
	AddHUDElement(CA, reset)
	local AB = {}
	AB.element = "AB"
	AB.floats = {}
	AB.floats.POSI_X = 0.25
	AB.floats.POSI_Y = 0.96759259700775
	AB.floats.SIZE_W = 0.11458333581686
	AB.floats.SIZE_H = 0.027777777984738
	AB.bools = {}
	AB.bools.VISI = 1
	AB.bools.ROUN = 0
	AB.bools.ICON = 1
	AB.bools.TEXT = 0
	AB.bools.PERC = 1
	AB.bools.BACK = 1
	AB.bools.BORD = 0
	AB.bools.EXTR = 1
	AB.colors = {}
	AB.colors.TE = "255, 255, 255, 255"
	AB.colors.TB = "0, 0, 0, 255"
	AB.colors.BG = "0, 0, 0, 120"
	AB.colors.BA = "58, 143, 255, 180"
	AB.colors.BR = "58, 143, 255, 180"
	AB.ints = {}
	AB.ints.AX = 1
	AB.ints.AY = 1
	AB.ints.TS = 24
	AddHUDElement(AB, reset)
	local WP = {}
	WP.element = "WP"
	WP.floats = {}
	WP.floats.POSI_X = 0.8828125
	WP.floats.POSI_Y = 0.9351851940155
	WP.floats.SIZE_W = 0.11458333581686
	WP.floats.SIZE_H = 0.027777777984738
	WP.bools = {}
	WP.bools.VISI = 1
	WP.bools.ROUN = 0
	WP.bools.ICON = 1
	WP.bools.TEXT = 1
	WP.bools.PERC = 1
	WP.bools.BACK = 1
	WP.bools.BORD = 0
	WP.bools.EXTR = 1
	WP.colors = {}
	WP.colors.TE = "255, 255, 255, 255"
	WP.colors.TB = "0, 0, 0, 255"
	WP.colors.BG = "0, 0, 0, 120"
	WP.colors.BA = "40, 40, 40, 180"
	WP.colors.BR = "40, 40, 40, 180"
	WP.ints = {}
	WP.ints.AX = 1
	WP.ints.AY = 1
	WP.ints.TS = 24
	AddHUDElement(WP, reset)
	local WS = {}
	WS.element = "WS"
	WS.floats = {}
	WS.floats.POSI_X = 0.8828125
	WS.floats.POSI_Y = 0.90277779102325
	WS.floats.SIZE_W = 0.11458333581686
	WS.floats.SIZE_H = 0.027777777984738
	WS.bools = {}
	WS.bools.VISI = 1
	WS.bools.ROUN = 0
	WS.bools.ICON = 1
	WS.bools.TEXT = 1
	WS.bools.PERC = 1
	WS.bools.BACK = 1
	WS.bools.BORD = 0
	WS.bools.EXTR = 1
	WS.colors = {}
	WS.colors.TE = "255, 255, 255, 255"
	WS.colors.TB = "0, 0, 0, 255"
	WS.colors.BG = "0, 0, 0, 120"
	WS.colors.BA = "40, 40, 40, 180"
	WS.colors.BR = "40, 40, 40, 180"
	WS.ints = {}
	WS.ints.AX = 1
	WS.ints.AY = 1
	WS.ints.TS = 24
	AddHUDElement(WS, reset)
	local WN = {}
	WN.element = "WN"
	WN.floats = {}
	WN.floats.POSI_X = 0.8828125
	WN.floats.POSI_Y = 0.96759259700775
	WN.floats.SIZE_W = 0.11458333581686
	WN.floats.SIZE_H = 0.027777777984738
	WN.bools = {}
	WN.bools.VISI = 1
	WN.bools.ROUN = 0
	WN.bools.ICON = 1
	WN.bools.TEXT = 1
	WN.bools.PERC = 1
	WN.bools.BACK = 1
	WN.bools.BORD = 0
	WN.bools.EXTR = 1
	WN.colors = {}
	WN.colors.TE = "255, 255, 255, 255"
	WN.colors.TB = "0, 0, 0, 255"
	WN.colors.BG = "0, 0, 0, 120"
	WN.colors.BA = "40, 40, 40, 180"
	WN.colors.BR = "40, 40, 40, 180"
	WN.ints = {}
	WN.ints.AX = 1
	WN.ints.AY = 1
	WN.ints.TS = 24
	AddHUDElement(WN, reset)
	local MI = {}
	MI.element = "MI"
	MI.floats = {}
	MI.floats.POSI_X = 0.0052083334885538
	MI.floats.POSI_Y = 0.0092592593282461
	MI.floats.SIZE_W = 0.15625
	MI.floats.SIZE_H = 0.27777779102325
	MI.bools = {}
	MI.bools.VISI = 0
	MI.bools.ROUN = 0
	MI.bools.ICON = 1
	MI.bools.TEXT = 1
	MI.bools.PERC = 1
	MI.bools.BACK = 1
	MI.bools.BORD = 0
	MI.bools.EXTR = 1
	MI.colors = {}
	MI.colors.TE = "255, 255, 255, 255"
	MI.colors.TB = "0, 0, 0, 255"
	MI.colors.BG = "0, 0, 0, 120"
	MI.colors.BA = "0, 0, 0, 180"
	MI.colors.BR = "0, 0, 0, 180"
	MI.ints = {}
	MI.ints.AX = 1
	MI.ints.AY = 4
	MI.ints.TS = 24
	AddHUDElement(MI, reset)
	local BA = {}
	BA.element = "BA"
	BA.floats = {}
	BA.floats.POSI_X = 0.8828125
	BA.floats.POSI_Y = 0.0046296296641231
	BA.floats.SIZE_W = 0.11458333581686
	BA.floats.SIZE_H = 0.027777777984738
	BA.bools = {}
	BA.bools.VISI = 1
	BA.bools.ROUN = 0
	BA.bools.ICON = 1
	BA.bools.TEXT = 1
	BA.bools.PERC = 1
	BA.bools.BACK = 1
	BA.bools.BORD = 0
	BA.bools.EXTR = 1
	BA.colors = {}
	BA.colors.TE = "255, 255, 255, 255"
	BA.colors.TB = "0, 0, 0, 255"
	BA.colors.BG = "0, 0, 0, 120"
	BA.colors.BA = "255, 255, 0, 180"
	BA.colors.BR = "255, 255, 0, 180"
	BA.ints = {}
	BA.ints.AX = 1
	BA.ints.AY = 1
	BA.ints.TS = 24
	AddHUDElement(BA, reset)
	local CON = {}
	CON.element = "CON"
	CON.floats = {}
	CON.floats.POSI_X = 0.41666665673256
	CON.floats.POSI_Y = 0.1064814850688
	CON.floats.SIZE_W = 0.16666667163372
	CON.floats.SIZE_H = 0.027777777984738
	CON.bools = {}
	CON.bools.VISI = 1
	CON.bools.ROUN = 0
	CON.bools.ICON = 1
	CON.bools.TEXT = 1
	CON.bools.PERC = 1
	CON.bools.BACK = 1
	CON.bools.BORD = 0
	CON.bools.EXTR = 1
	CON.colors = {}
	CON.colors.TE = "255, 255, 255, 255"
	CON.colors.TB = "0, 0, 0, 255"
	CON.colors.BG = "0, 0, 0, 120"
	CON.colors.BA = "0, 0, 0, 180"
	CON.colors.BR = "0, 0, 0, 180"
	CON.ints = {}
	CON.ints.AX = 1
	CON.ints.AY = 1
	CON.ints.TS = 24
	AddHUDElement(CON, reset)
	local PE = {}
	PE.element = "PE"
	PE.floats = {}
	PE.floats.POSI_X = 0.0026041667442769
	PE.floats.POSI_Y = 0.0046296296641231
	PE.floats.SIZE_W = 0.08333333581686
	PE.floats.SIZE_H = 0.018518518656492
	PE.bools = {}
	PE.bools.VISI = 1
	PE.bools.ROUN = 0
	PE.bools.ICON = 1
	PE.bools.TEXT = 1
	PE.bools.PERC = 1
	PE.bools.BACK = 0
	PE.bools.BORD = 0
	PE.bools.EXTR = 0
	PE.colors = {}
	PE.colors.TE = "255, 255, 255, 255"
	PE.colors.TB = "0, 0, 0, 255"
	PE.colors.BG = "0, 0, 0, 120"
	PE.colors.BA = "0, 0, 0, 180"
	PE.colors.BR = "0, 0, 0, 180"
	PE.ints = {}
	PE.ints.AX = 0
	PE.ints.AY = 1
	PE.ints.TS = 18
	AddHUDElement(PE, reset)
	local NE = {}
	NE.element = "NE"
	NE.floats = {}
	NE.floats.POSI_X = 0.0026041667442769
	NE.floats.POSI_Y = 0.023148147389293
	NE.floats.SIZE_W = 0.08333333581686
	NE.floats.SIZE_H = 0.018518518656492
	NE.bools = {}
	NE.bools.VISI = 1
	NE.bools.ROUN = 0
	NE.bools.ICON = 1
	NE.bools.TEXT = 1
	NE.bools.PERC = 1
	NE.bools.BACK = 0
	NE.bools.BORD = 0
	NE.bools.EXTR = 0
	NE.colors = {}
	NE.colors.TE = "255, 255, 255, 255"
	NE.colors.TB = "0, 0, 0, 255"
	NE.colors.BG = "0, 0, 0, 120"
	NE.colors.BA = "0, 0, 0, 180"
	NE.colors.BR = "0, 0, 0, 180"
	NE.ints = {}
	NE.ints.AX = 0
	NE.ints.AY = 1
	NE.ints.TS = 18
	AddHUDElement(NE, reset)
	local COM = {}
	COM.element = "COM"
	COM.floats = {}
	COM.floats.POSI_X = 0.25260415673256
	COM.floats.POSI_Y = 0.023148147389293
	COM.floats.SIZE_W = 0.49479165673256
	COM.floats.SIZE_H = 0.046296294778585
	COM.bools = {}
	COM.bools.VISI = 1
	COM.bools.ROUN = 0
	COM.bools.ICON = 1
	COM.bools.TEXT = 1
	COM.bools.PERC = 1
	COM.bools.BACK = 0
	COM.bools.BORD = 0
	COM.bools.EXTR = 1
	COM.colors = {}
	COM.colors.TE = "255, 255, 255, 255"
	COM.colors.TB = "0, 0, 0, 255"
	COM.colors.BG = "0, 0, 0, 120"
	COM.colors.BA = "0, 0, 0, 180"
	COM.colors.BR = "0, 0, 0, 180"
	COM.ints = {}
	COM.ints.AX = 1
	COM.ints.AY = 1
	COM.ints.TS = 18
	AddHUDElement(COM, reset)
	local LO = {}
	LO.element = "LO"
	LO.floats = {}
	LO.floats.POSI_X = 0.36979165673256
	LO.floats.POSI_Y = 0.13888889551163
	LO.floats.SIZE_W = 0.26041665673256
	LO.floats.SIZE_H = 0.074074074625969
	LO.bools = {}
	LO.bools.VISI = 1
	LO.bools.ROUN = 0
	LO.bools.ICON = 1
	LO.bools.TEXT = 1
	LO.bools.PERC = 1
	LO.bools.BACK = 1
	LO.bools.BORD = 0
	LO.bools.EXTR = 1
	LO.colors = {}
	LO.colors.TE = "255, 0, 0, 255"
	LO.colors.TB = "0, 0, 0, 255"
	LO.colors.BG = "0, 0, 0, 120"
	LO.colors.BA = "0, 0, 0, 180"
	LO.colors.BR = "0, 0, 0, 180"
	LO.ints = {}
	LO.ints.AX = 1
	LO.ints.AY = 1
	LO.ints.TS = 30
	AddHUDElement(LO, reset)
	local NA = {}
	NA.element = "NA"
	NA.floats = {}
	NA.floats.POSI_X = 0.265625
	NA.floats.POSI_Y = 0.90277779102325
	NA.floats.SIZE_W = 0.11458333581686
	NA.floats.SIZE_H = 0.027777777984738
	NA.bools = {}
	NA.bools.VISI = 0
	NA.bools.ROUN = 0
	NA.bools.ICON = 1
	NA.bools.TEXT = 1
	NA.bools.PERC = 1
	NA.bools.BACK = 0
	NA.bools.BORD = 0
	NA.bools.EXTR = 1
	NA.colors = {}
	NA.colors.TE = "255, 255, 255, 255"
	NA.colors.TB = "0, 0, 0, 255"
	NA.colors.BG = "0, 0, 0, 120"
	NA.colors.BA = "0, 0, 0, 180"
	NA.colors.BR = "0, 0, 0, 180"
	NA.ints = {}
	NA.ints.AX = 1
	NA.ints.AY = 1
	NA.ints.TS = 18
	AddHUDElement(NA, reset)
	local ID = {}
	ID.element = "ID"
	ID.floats = {}
	ID.floats.POSI_X = 0.265625
	ID.floats.POSI_Y = 0.90277779102325
	ID.floats.SIZE_W = 0.11458333581686
	ID.floats.SIZE_H = 0.027777777984738
	ID.bools = {}
	ID.bools.VISI = 1
	ID.bools.ROUN = 0
	ID.bools.ICON = 1
	ID.bools.TEXT = 1
	ID.bools.PERC = 1
	ID.bools.BACK = 1
	ID.bools.BORD = 0
	ID.bools.EXTR = 1
	ID.colors = {}
	ID.colors.TE = "255, 255, 255, 255"
	ID.colors.TB = "0, 0, 0, 255"
	ID.colors.BG = "0, 0, 0, 120"
	ID.colors.BA = "0, 0, 0, 180"
	ID.colors.BR = "0, 0, 0, 180"
	ID.ints = {}
	ID.ints.AX = 1
	ID.ints.AY = 1
	ID.ints.TS = 18
	AddHUDElement(ID, reset)
	local AV = {}
	AV.element = "AV"
	AV.floats = {}
	AV.floats.POSI_X = 0.19270832836628
	AV.floats.POSI_Y = 0.87037038803101
	AV.floats.SIZE_W = 0.0703125
	AV.floats.SIZE_H = 0.125
	AV.bools = {}
	AV.bools.VISI = 0
	AV.bools.ROUN = 0
	AV.bools.ICON = 1
	AV.bools.TEXT = 1
	AV.bools.PERC = 1
	AV.bools.BACK = 1
	AV.bools.BORD = 0
	AV.bools.EXTR = 1
	AV.colors = {}
	AV.colors.TE = "255, 255, 255, 255"
	AV.colors.TB = "0, 0, 0, 255"
	AV.colors.BG = "0, 0, 0, 120"
	AV.colors.BA = "150, 52, 52, 180"
	AV.colors.BR = "150, 52, 52, 180"
	AV.ints = {}
	AV.ints.AX = 1
	AV.ints.AY = 1
	AV.ints.TS = 24
	AddHUDElement(AV, reset)
	local PM = {}
	PM.element = "PM"
	PM.floats = {}
	PM.floats.POSI_X = 0.11979166418314
	PM.floats.POSI_Y = 0.87037038803101
	PM.floats.SIZE_W = 0.0703125
	PM.floats.SIZE_H = 0.125
	PM.bools = {}
	PM.bools.VISI = 1
	PM.bools.ROUN = 0
	PM.bools.ICON = 1
	PM.bools.TEXT = 1
	PM.bools.PERC = 1
	PM.bools.BACK = 1
	PM.bools.BORD = 0
	PM.bools.EXTR = 1
	PM.colors = {}
	PM.colors.TE = "255, 255, 255, 255"
	PM.colors.TB = "0, 0, 0, 255"
	PM.colors.BG = "0, 0, 0, 120"
	PM.colors.BA = "150, 52, 52, 180"
	PM.colors.BR = "150, 52, 52, 180"
	PM.ints = {}
	PM.ints.AX = 1
	PM.ints.AY = 1
	PM.ints.TS = 24
	AddHUDElement(PM, reset)
	local CR = {}
	CR.element = "CR"
	CR.floats = {}
	CR.floats.POSI_X = 0.46875
	CR.floats.POSI_Y = 0.074074074625969
	CR.floats.SIZE_W = 0.0625
	CR.floats.SIZE_H = 0.027777777984738
	CR.bools = {}
	CR.bools.VISI = 1
	CR.bools.ROUN = 0
	CR.bools.ICON = 1
	CR.bools.TEXT = 1
	CR.bools.PERC = 1
	CR.bools.BACK = 0
	CR.bools.BORD = 0
	CR.bools.EXTR = 1
	CR.colors = {}
	CR.colors.TE = "255, 255, 255, 255"
	CR.colors.TB = "0, 0, 0, 255"
	CR.colors.BG = "0, 0, 0, 120"
	CR.colors.BA = "100, 100, 100, 255"
	CR.colors.BR = "0, 0, 0, 180"
	CR.ints = {}
	CR.ints.AX = 1
	CR.ints.AY = 1
	CR.ints.TS = 24
	AddHUDElement(CR, reset)
	local CC = {}
	CC.element = "CC"
	CC.floats = {}
	CC.floats.POSI_X = 0.46875
	CC.floats.POSI_Y = 0.1
	CC.floats.SIZE_W = 0.0625
	CC.floats.SIZE_H = 0.027777777984738
	CC.bools = {}
	CC.bools.VISI = 1
	CC.bools.ROUN = 0
	CC.bools.ICON = 1
	CC.bools.TEXT = 1
	CC.bools.PERC = 1
	CC.bools.BACK = 0
	CC.bools.BORD = 0
	CC.bools.EXTR = 1
	CC.colors = {}
	CC.colors.TE = "255, 255, 255, 255"
	CC.colors.TB = "0, 0, 0, 255"
	CC.colors.BG = "0, 0, 0, 120"
	CC.colors.BA = "100, 100, 255, 255"
	CC.colors.BR = "0, 0, 0, 180"
	CC.ints = {}
	CC.ints.AX = 1
	CC.ints.AY = 1
	CC.ints.TS = 24
	AddHUDElement(CC, reset)
	local SL = {}
	SL.element = "SL"
	SL.floats = {}
	SL.floats.POSI_X = 0.0026041667442769
	SL.floats.POSI_Y = 0.046296294778585
	SL.floats.SIZE_W = 0.0703125
	SL.floats.SIZE_H = 0.125
	SL.bools = {}
	SL.bools.VISI = 0
	SL.bools.ROUN = 0
	SL.bools.ICON = 1
	SL.bools.TEXT = 1
	SL.bools.PERC = 1
	SL.bools.BACK = 1
	SL.bools.BORD = 0
	SL.bools.EXTR = 1
	SL.colors = {}
	SL.colors.TE = "255, 255, 255, 255"
	SL.colors.TB = "0, 0, 0, 255"
	SL.colors.BG = "0, 0, 0, 120"
	SL.colors.BA = "150, 52, 52, 180"
	SL.colors.BR = "150, 52, 52, 180"
	SL.ints = {}
	SL.ints.AX = 1
	SL.ints.AY = 1
	SL.ints.TS = 24
	AddHUDElement(SL, reset)
	local SN = {}
	SN.element = "SN"
	SN.floats = {}
	SN.floats.POSI_X = 0.0026041667442769
	SN.floats.POSI_Y = 0.17592592537403
	SN.floats.SIZE_W = 0.14322917163372
	SN.floats.SIZE_H = 0.046296294778585
	SN.bools = {}
	SN.bools.VISI = 0
	SN.bools.ROUN = 0
	SN.bools.ICON = 1
	SN.bools.TEXT = 1
	SN.bools.PERC = 1
	SN.bools.BACK = 1
	SN.bools.BORD = 0
	SN.bools.EXTR = 1
	SN.colors = {}
	SN.colors.TE = "255, 255, 255, 255"
	SN.colors.TB = "0, 0, 0, 255"
	SN.colors.BG = "0, 0, 0, 120"
	SN.colors.BA = "150, 52, 52, 180"
	SN.colors.BR = "150, 52, 52, 180"
	SN.ints = {}
	SN.ints.AX = 1
	SN.ints.AY = 1
	SN.ints.TS = 24
	AddHUDElement(SN, reset)
	local RA = {}
	RA.element = "RA"
	RA.floats = {}
	RA.floats.POSI_X = 0.41666665673256
	RA.floats.POSI_Y = 0.96759259700775
	RA.floats.SIZE_W = 0.16666667163372
	RA.floats.SIZE_H = 0.027777777984738
	RA.bools = {}
	RA.bools.VISI = 1
	RA.bools.ROUN = 0
	RA.bools.ICON = 1
	RA.bools.TEXT = 0
	RA.bools.PERC = 1
	RA.bools.BACK = 1
	RA.bools.BORD = 0
	RA.bools.EXTR = 1
	RA.colors = {}
	RA.colors.TE = "255, 255, 255, 255"
	RA.colors.TB = "0, 0, 0, 255"
	RA.colors.BG = "0, 0, 0, 120"
	RA.colors.BA = "40, 223, 40, 180"
	RA.colors.BR = "40, 223, 40, 180"
	RA.ints = {}
	RA.ints.AX = 1
	RA.ints.AY = 1
	RA.ints.TS = 24
	AddHUDElement(RA, reset)
	local VO = {}
	VO.element = "VO"
	VO.floats = {}
	VO.floats.POSI_X = 0.8828125
	VO.floats.POSI_Y = 0.0046296296641231
	VO.floats.SIZE_W = 0.11458333581686
	VO.floats.SIZE_H = 0.027777777984738
	VO.bools = {}
	VO.bools.VISI = 1
	VO.bools.ROUN = 0
	VO.bools.ICON = 1
	VO.bools.TEXT = 1
	VO.bools.PERC = 1
	VO.bools.BACK = 1
	VO.bools.BORD = 0
	VO.bools.EXTR = 1
	VO.colors = {}
	VO.colors.TE = "255, 255, 255, 255"
	VO.colors.TB = "0, 0, 0, 255"
	VO.colors.BG = "0, 0, 0, 120"
	VO.colors.BA = "33, 108, 42, 180"
	VO.colors.BR = "33, 108, 42, 180"
	VO.ints = {}
	VO.ints.AX = 1
	VO.ints.AY = 1
	VO.ints.TS = 24
	AddHUDElement(VO, reset)
end

DefaultHUDSettings()
--[[ LOADOUT ]]
--
YRPHUDVersion = YRPHUDVersion or -1
function HudLoadoutAll()
	local hudeles = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
	if IsNotNilAndNotFalse(hudeles) then
		for i, v in pairs(hudeles) do
			if string.StartWith(v.name, "float_HUD_") then
				SetGlobalYRPFloat(v.name, tonumber(v.value))
			elseif string.StartWith(v.name, "int_HUD_") then
				SetGlobalYRPInt(v.name, tonumber(v.value))
			elseif string.StartWith(v.name, "bool_HUD_") then
				SetGlobalYRPBool(v.name, tobool(v.value))
			elseif string.StartWith(v.name, "text_HUD_") then
				SetGlobalYRPString(v.name, tostring(v.value))
			elseif string.StartWith(v.name, "color_HUD_") then
				SetGlobalYRPString(v.name, tostring(v.value))
			elseif v.name == "Version" then
				YRPHUDVersion = YRPHUDVersion + 1
				SetGlobalYRPInt("YRPHUDVersion", YRPHUDVersion)
			else
				MsgC(Color(0, 255, 0), "Failed To HUD", v.name, v.value, "\n")
			end
		end
	end
end

HudLoadoutAll()
YRP:AddNetworkString("nws_yrp_update_hud_x")
net.Receive(
	"nws_yrp_update_hud_x",
	function(len, ply)
		local element = net.ReadString()
		local x = net.ReadFloat()
		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["value"] = x
			}, "name = 'float_HUD_" .. element .. "_POSI_X'"
		)

		HudLoadoutAll()
	end
)

YRP:AddNetworkString("nws_yrp_update_hud_y")
net.Receive(
	"nws_yrp_update_hud_y",
	function(len, ply)
		local element = net.ReadString()
		local y = net.ReadFloat()
		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["value"] = y
			}, "name = 'float_HUD_" .. element .. "_POSI_Y'"
		)

		HudLoadoutAll()
	end
)

YRP:AddNetworkString("nws_yrp_update_hud_w")
net.Receive(
	"nws_yrp_update_hud_w",
	function(len, ply)
		local element = net.ReadString()
		local w = net.ReadFloat()
		if w > 0.0 then
			YRP_SQL_UPDATE(
				DATABASE_NAME,
				{
					["value"] = w
				}, "name = 'float_HUD_" .. element .. "_SIZE_W'"
			)

			HudLoadoutAll()
		end
	end
)

YRP:AddNetworkString("nws_yrp_update_hud_h")
net.Receive(
	"nws_yrp_update_hud_h",
	function(len, ply)
		local element = net.ReadString()
		local h = net.ReadFloat()
		if h > 0.0 then
			YRP_SQL_UPDATE(
				DATABASE_NAME,
				{
					["value"] = h
				}, "name = 'float_HUD_" .. element .. "_SIZE_H'"
			)

			HudLoadoutAll()
		end
	end
)

YRP:AddNetworkString("nws_yrp_get_hud_element_settings")
net.Receive(
	"nws_yrp_get_hud_element_settings",
	function(len, ply)
		--local element = net.ReadString()
		local ele = YRP_SQL_SELECT(DATABASE_NAME, "*", nil) --"name LIKE '" .. "bool_HUD_" .. element .. "_%'" )
		local nettab = {}
		for i, e in pairs(ele) do
			nettab[e.name] = e.value
		end

		net.Start("nws_yrp_get_hud_element_settings")
		net.WriteTable(nettab)
		net.Send(ply)
	end
)

YRP:AddNetworkString("nws_yrp_update_hud_bool")
net.Receive(
	"nws_yrp_update_hud_bool",
	function(len, ply)
		local element = net.ReadString()
		local art = net.ReadString()
		local b = net.ReadBool()
		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["value"] = tonum(b)
			}, "name = 'bool_HUD_" .. element .. "_" .. art .. "'"
		)

		HudLoadoutAll()
	end
)

YRP:AddNetworkString("nws_yrp_update_hud_text")
net.Receive(
	"nws_yrp_update_hud_text",
	function(len, ply)
		local element = net.ReadString()
		local text = net.ReadString()
		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["value"] = text
			}, "name = 'text_HUD_" .. element .. "_" .. "CTEX'"
		)

		HudLoadoutAll()
	end
)

YRP:AddNetworkString("nws_yrp_update_hud_text_position")
net.Receive(
	"nws_yrp_update_hud_text_position",
	function(len, ply)
		local element = net.ReadString()
		local ax = tonumber(net.ReadInt(4))
		local ay = tonumber(net.ReadInt(4))
		if ay == 0 then
			ay = 3
		elseif ay == 2 then
			ay = 4
		end

		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["value"] = ax
			}, "name = 'int_HUD_" .. element .. "_" .. "AX'"
		)

		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["value"] = ay
			}, "name = 'int_HUD_" .. element .. "_" .. "AY'"
		)

		HudLoadoutAll()
	end
)

YRP:AddNetworkString("nws_yrp_update_hud_ts")
net.Receive(
	"nws_yrp_update_hud_ts",
	function(len, ply)
		local element = net.ReadString()
		local ts = net.ReadInt(8)
		if ts > 0 then
			YRP_SQL_UPDATE(
				DATABASE_NAME,
				{
					["value"] = ts
				}, "name = 'int_HUD_" .. element .. "_TS'"
			)

			HudLoadoutAll()
		end
	end
)

YRP:AddNetworkString("nws_yrp_update_hud_color")
net.Receive(
	"nws_yrp_update_hud_color",
	function(len, ply)
		local element = net.ReadString()
		local art = net.ReadString()
		local color = net.ReadString()
		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["value"] = color
			}, "name = 'color_HUD_" .. element .. "_" .. art .. "'"
		)

		HudLoadoutAll()
	end
)

YRP:AddNetworkString("nws_yrp_reset_hud_settings")
net.Receive(
	"nws_yrp_reset_hud_settings",
	function(len, ply)
		YRP:msg("db", "Reset Hud Settings by " .. ply:YRPName())
		DefaultHUDSettings(true)
		YRPDesignLoadout("reset_hud_settings")
	end
)
