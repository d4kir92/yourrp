--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_hud"

SQL_ADD_COLUMN(DATABASE_NAME, "name", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "value", "TEXT DEFAULT ''")

if SQL_SELECT(DATABASE_NAME, "*", "uniqueID = 1") == nil then
	SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'Version', '1'")
end

--SQL_DROP_TABLE(DATABASE_NAME)

function AddElement(tab)
	for name, value in pairs(tab.floats) do
		local _name = "float_HUD_" .. tab.element .. "_" .. name
		if SQL_SELECT(DATABASE_NAME, "*", "name = '" .. _name .. "'") == nil then
			SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. _name .. "', '" .. value .. "'")
		end
	end
	for name, value in pairs(tab.bools) do
		local _name = "bool_HUD_" .. tab.element .. "_" .. name
		if SQL_SELECT(DATABASE_NAME, "*", "name = '" .. _name .. "'") == nil then
			SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. _name .. "', '" .. value .. "'")
		end
	end
	for name, value in pairs(tab.colors) do
		local _name = "color_HUD_" .. tab.element .. "_" .. name
		if SQL_SELECT(DATABASE_NAME, "*", "name = '" .. _name .. "'") == nil then
			SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. _name .. "', '" .. value .. "'")
		end
	end
	if tab.ints != nil then
		for name, value in pairs(tab.ints) do
			local _name = "int_HUD_" .. tab.element .. "_" .. name
			if SQL_SELECT(DATABASE_NAME, "*", "name = '" .. _name .. "'") == nil then
				SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. _name .. "', '" .. value .. "'")
			end
		end
	end
end

local HP = {}
HP.element = "HP"
HP.floats = {}
HP.floats.POSI_X = 0.0052083334885538
HP.floats.POSI_Y = 0.96296298503876
HP.floats.SIZE_W = 0.11458333581686
HP.floats.SIZE_H = 0.027777777984738
HP.bools = {}
HP.bools.VISI = 1
HP.bools.ROUN = 0
HP.bools.ICON = 1
HP.bools.TEXT = 1
HP.bools.PERC = 1
HP.bools.BACK = 1
HP.bools.BORD = 1
HP.colors = {}
HP.colors.TE = "255, 255, 255, 255"
HP.colors.TB = "0, 0, 0, 255"
HP.colors.BG = "0, 0, 0, 200"
HP.colors.BA = "150, 52, 52, 255"
HP.colors.BR = "150, 52, 52, 255"
HP.ints = {}
HP.ints.AX = 1
HP.ints.AY = 1
HP.ints.TS = 24
AddElement(HP)

local AR = {}
AR.element = "AR"
AR.floats = {}
AR.floats.POSI_X = 0.0052083334885538
AR.floats.POSI_Y = 0.9351851940155
AR.floats.SIZE_W = 0.11458333581686
AR.floats.SIZE_H = 0.027777777984738
AR.bools = {}
AR.bools.VISI = 1
AR.bools.ROUN = 0
AR.bools.ICON = 1
AR.bools.TEXT = 1
AR.bools.PERC = 1
AR.bools.BACK = 1
AR.bools.BORD = 1
AR.colors = {}
AR.colors.TE = "255, 255, 255, 255"
AR.colors.TB = "0, 0, 0, 255"
AR.colors.BG = "0, 0, 0, 200"
AR.colors.BA = "52, 150, 72, 255"
AR.colors.BR = "52, 150, 72, 255"
AR.ints = {}
AR.ints.AX = 1
AR.ints.AY = 1
AR.ints.TS = 24
AddElement(AR)

local XP = {}
XP.element = "XP"
XP.floats = {}
XP.floats.POSI_X = 0.25
XP.floats.POSI_Y = 0.0
XP.floats.SIZE_W = 0.5
XP.floats.SIZE_H = 0.018518518656492
XP.bools = {}
XP.bools.VISI = 1
XP.bools.ROUN = 0
XP.bools.ICON = 1
XP.bools.TEXT = 1
XP.bools.PERC = 1
XP.bools.BACK = 1
XP.bools.BORD = 1
XP.colors = {}
XP.colors.TE = "255, 255, 255, 255"
XP.colors.TB = "0, 0, 0, 255"
XP.colors.BG = "0, 0, 0, 200"
XP.colors.BA = "181, 255, 107, 255"
XP.colors.BR = "181, 255, 107, 255"
XP.ints = {}
XP.ints.AX = 1
XP.ints.AY = 1
XP.ints.TS = 18
AddElement(XP)

local MO = {}
MO.element = "MO"
MO.floats = {}
MO.floats.POSI_X = 0.88020831346512
MO.floats.POSI_Y = 0.0092592593282461
MO.floats.SIZE_W = 0.11458333581686
MO.floats.SIZE_H = 0.027777777984738
MO.bools = {}
MO.bools.VISI = 1
MO.bools.ROUN = 0
MO.bools.ICON = 1
MO.bools.TEXT = 1
MO.bools.PERC = 1
MO.bools.BACK = 1
MO.bools.BORD = 1
MO.colors = {}
MO.colors.TE = "255, 255, 255, 255"
MO.colors.TB = "0, 0, 0, 255"
MO.colors.BG = "0, 0, 0, 200"
MO.colors.BA = "33, 108, 42, 255"
MO.colors.BR = "33, 108, 42, 255"
MO.ints = {}
MO.ints.AX = 1
MO.ints.AY = 1
MO.ints.TS = 24
AddElement(MO)

local ST = {}
ST.element = "ST"
ST.floats = {}
ST.floats.POSI_X = 0.41666665673256
ST.floats.POSI_Y = 0.96296298503876
ST.floats.SIZE_W = 0.16666667163372
ST.floats.SIZE_H = 0.027777777984738
ST.bools = {}
ST.bools.VISI = 1
ST.bools.ROUN = 0
ST.bools.ICON = 1
ST.bools.TEXT = 0
ST.bools.PERC = 1
ST.bools.BACK = 1
ST.bools.BORD = 1
ST.colors = {}
ST.colors.TE = "255, 255, 255, 255"
ST.colors.TB = "0, 0, 0, 255"
ST.colors.BG = "0, 0, 0, 200"
ST.colors.BA = "150, 150, 60, 255"
ST.colors.BR = "150, 150, 60, 255"
ST.ints = {}
ST.ints.AX = 1
ST.ints.AY = 1
ST.ints.TS = 24
AddElement(ST)

local CH = {}
CH.element = "CH"
CH.floats = {}
CH.floats.POSI_X = 0.0052083334885538
CH.floats.POSI_Y = 0.5
CH.floats.SIZE_W = 0.234375
CH.floats.SIZE_H = 0.39814814925194
CH.bools = {}
CH.bools.VISI = 1
CH.bools.ROUN = 0
CH.bools.ICON = 1
CH.bools.TEXT = 1
CH.bools.PERC = 1
CH.bools.BACK = 1
CH.bools.BORD = 1
CH.colors = {}
CH.colors.TE = "255, 255, 255, 255"
CH.colors.TB = "0, 0, 0, 255"
CH.colors.BG = "0, 0, 0, 200"
CH.colors.BA = "255, 255, 255, 255"
CH.colors.BR = "0, 0, 0, 255"
CH.ints = {}
CH.ints.AX = 1
CH.ints.AY = 1
CH.ints.TS = 24
AddElement(CH)

local HU = {}
HU.element = "HU"
HU.floats = {}
HU.floats.POSI_X = 0.125
HU.floats.POSI_Y = 0.9351851940155
HU.floats.SIZE_W = 0.11458333581686
HU.floats.SIZE_H = 0.027777777984738
HU.bools = {}
HU.bools.VISI = 1
HU.bools.ROUN = 0
HU.bools.ICON = 1
HU.bools.TEXT = 0
HU.bools.PERC = 1
HU.bools.BACK = 1
HU.bools.BORD = 1
HU.colors = {}
HU.colors.TE = "255, 255, 255, 255"
HU.colors.TB = "0, 0, 0, 255"
HU.colors.BG = "0, 0, 0, 200"
HU.colors.BA = "150, 88, 52, 255"
HU.colors.BR = "150, 88, 52, 255"
HU.ints = {}
HU.ints.AX = 1
HU.ints.AY = 1
HU.ints.TS = 24
AddElement(HU)

local TH = {}
TH.element = "TH"
TH.floats = {}
TH.floats.POSI_X = 0.125
TH.floats.POSI_Y = 0.96296298503876
TH.floats.SIZE_W = 0.11458333581686
TH.floats.SIZE_H = 0.027777777984738
TH.bools = {}
TH.bools.VISI = 1
TH.bools.ROUN = 0
TH.bools.ICON = 1
TH.bools.TEXT = 0
TH.bools.PERC = 1
TH.bools.BACK = 1
TH.bools.BORD = 1
TH.colors = {}
TH.colors.TE = "255, 255, 255, 255"
TH.colors.TB = "0, 0, 0, 255"
TH.colors.BG = "0, 0, 0, 200"
TH.colors.BA = "52, 70, 150, 255"
TH.colors.BR = "52, 70, 150, 255"
TH.ints = {}
TH.ints.AX = 1
TH.ints.AY = 1
TH.ints.TS = 24
AddElement(TH)

local CA = {}
CA.element = "CA"
CA.floats = {}
CA.floats.POSI_X = 0.41666665673256
CA.floats.POSI_Y = 0.92592591047287
CA.floats.SIZE_W = 0.16666667163372
CA.floats.SIZE_H = 0.027777777984738
CA.bools = {}
CA.bools.VISI = 1
CA.bools.ROUN = 0
CA.bools.ICON = 1
CA.bools.TEXT = 1
CA.bools.PERC = 1
CA.bools.BACK = 1
CA.bools.BORD = 1
CA.colors = {}
CA.colors.TE = "255, 255, 255, 255"
CA.colors.TB = "0, 0, 0, 255"
CA.colors.BG = "0, 0, 0, 200"
CA.colors.BA = "132, 116, 188, 255"
CA.colors.BR = "132, 116, 188, 255"
CA.ints = {}
CA.ints.AX = 1
CA.ints.AY = 1
CA.ints.TS = 24
AddElement(CA)

local AB = {}
AB.element = "AB"
AB.floats = {}
AB.floats.POSI_X = 0.0052083334885538
AB.floats.POSI_Y = 0.90740740299225
AB.floats.SIZE_W = 0.11458333581686
AB.floats.SIZE_H = 0.027777777984738
AB.bools = {}
AB.bools.VISI = 1
AB.bools.ROUN = 0
AB.bools.ICON = 1
AB.bools.TEXT = 1
AB.bools.PERC = 1
AB.bools.BACK = 1
AB.bools.BORD = 1
AB.colors = {}
AB.colors.TE = "255, 255, 255, 255"
AB.colors.TB = "0, 0, 0, 255"
AB.colors.BG = "0, 0, 0, 200"
AB.colors.BA = "58, 143, 255, 255"
AB.colors.BR = "58, 143, 255, 255"
AB.ints = {}
AB.ints.AX = 1
AB.ints.AY = 1
AB.ints.TS = 24
AddElement(AB)

local WP = {}
WP.element = "WP"
WP.floats = {}
WP.floats.POSI_X = 0.88020831346512
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
WP.bools.BORD = 1
WP.colors = {}
WP.colors.TE = "255, 255, 255, 255"
WP.colors.TB = "0, 0, 0, 255"
WP.colors.BG = "0, 0, 0, 200"
WP.colors.BA = "181, 255, 107, 255"
WP.colors.BR = "181, 255, 107, 255"
WP.ints = {}
WP.ints.AX = 1
WP.ints.AY = 1
WP.ints.TS = 24
AddElement(WP)

local WS = {}
WS.element = "WS"
WS.floats = {}
WS.floats.POSI_X = 0.88020831346512
WS.floats.POSI_Y = 0.90740740299225
WS.floats.SIZE_W = 0.11458333581686
WS.floats.SIZE_H = 0.027777777984738
WS.bools = {}
WS.bools.VISI = 1
WS.bools.ROUN = 0
WS.bools.ICON = 1
WS.bools.TEXT = 1
WS.bools.PERC = 1
WS.bools.BACK = 1
WS.bools.BORD = 1
WS.colors = {}
WS.colors.TE = "255, 255, 255, 255"
WS.colors.TB = "0, 0, 0, 255"
WS.colors.BG = "0, 0, 0, 200"
WS.colors.BA = "181, 255, 107, 255"
WS.colors.BR = "181, 255, 107, 255"
WS.ints = {}
WS.ints.AX = 1
WS.ints.AY = 1
WS.ints.TS = 24
AddElement(WS)

local WN = {}
WN.element = "WN"
WN.floats = {}
WN.floats.POSI_X = 0.88020831346512
WN.floats.POSI_Y = 0.96296298503876
WN.floats.SIZE_W = 0.11458333581686
WN.floats.SIZE_H = 0.027777777984738
WN.bools = {}
WN.bools.VISI = 1
WN.bools.ROUN = 0
WN.bools.ICON = 1
WN.bools.TEXT = 1
WN.bools.PERC = 1
WN.bools.BACK = 1
WN.bools.BORD = 1
WN.colors = {}
WN.colors.TE = "255, 255, 255, 255"
WN.colors.TB = "0, 0, 0, 255"
WN.colors.BG = "0, 0, 0, 200"
WN.colors.BA = "181, 255, 107, 255"
WN.colors.BR = "181, 255, 107, 255"
WN.ints = {}
WN.ints.AX = 1
WN.ints.AY = 1
WN.ints.TS = 24
AddElement(WN)

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
MI.bools.BORD = 1
MI.colors = {}
MI.colors.TE = "255, 255, 255, 255"
MI.colors.TB = "0, 0, 0, 255"
MI.colors.BG = "0, 0, 0, 200"
MI.colors.BA = "0, 0, 0, 255"
MI.colors.BR = "0, 0, 0, 255"
MI.ints = {}
MI.ints.AX = 1
MI.ints.AY = 4
MI.ints.TS = 24
AddElement(MI)

local BA = {}
BA.element = "BA"
BA.floats = {}
BA.floats.POSI_X = 0.76041668653488
BA.floats.POSI_Y = 0.0092592593282461
BA.floats.SIZE_W = 0.11458333581686
BA.floats.SIZE_H = 0.027777777984738
BA.bools = {}
BA.bools.VISI = 1
BA.bools.ROUN = 0
BA.bools.ICON = 1
BA.bools.TEXT = 1
BA.bools.PERC = 1
BA.bools.BACK = 1
BA.bools.BORD = 1
BA.colors = {}
BA.colors.TE = "255, 255, 255, 255"
BA.colors.TB = "0, 0, 0, 255"
BA.colors.BG = "0, 0, 0, 200"
BA.colors.BA = "255, 255, 0, 255"
BA.colors.BR = "255, 255, 0, 255"
BA.ints = {}
BA.ints.AX = 1
BA.ints.AY = 1
BA.ints.TS = 24
AddElement(BA)

local CON = {}
CON.element = "CON"
CON.floats = {}
CON.floats.POSI_X = 0.41666665673256
CON.floats.POSI_Y = 0.064814813435078
CON.floats.SIZE_W = 0.16666667163372
CON.floats.SIZE_H = 0.027777777984738
CON.bools = {}
CON.bools.VISI = 1
CON.bools.ROUN = 0
CON.bools.ICON = 1
CON.bools.TEXT = 1
CON.bools.PERC = 1
CON.bools.BACK = 1
CON.bools.BORD = 1
CON.colors = {}
CON.colors.TE = "255, 255, 255, 255"
CON.colors.TB = "0, 0, 0, 255"
CON.colors.BG = "0, 0, 0, 200"
CON.colors.BA = "0, 0, 0, 255"
CON.colors.BR = "0, 0, 0, 255"
CON.ints = {}
CON.ints.AX = 1
CON.ints.AY = 1
CON.ints.TS = 24
AddElement(CON)

local PE = {}
PE.element = "PE"
PE.floats = {}
PE.floats.POSI_X = 0.0052083334885538
PE.floats.POSI_Y = 0.47222220897675
PE.floats.SIZE_W = 0.05208333209157
PE.floats.SIZE_H = 0.018518518656492
PE.bools = {}
PE.bools.VISI = 1
PE.bools.ROUN = 0
PE.bools.ICON = 1
PE.bools.TEXT = 1
PE.bools.PERC = 1
PE.bools.BACK = 0
PE.bools.BORD = 0
PE.colors = {}
PE.colors.TE = "255, 255, 255, 255"
PE.colors.TB = "0, 0, 0, 255"
PE.colors.BG = "0, 0, 0, 200"
PE.colors.BA = "0, 0, 0, 255"
PE.colors.BR = "0, 0, 0, 255"
PE.ints = {}
PE.ints.AX = 0
PE.ints.AY = 1
PE.ints.TS = 18
AddElement(PE)

local NE = {}
NE.element = "NE"
NE.floats = {}
NE.floats.POSI_X = 0.0052083334885538
NE.floats.POSI_Y = 0.45370370149612
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
NE.colors = {}
NE.colors.TE = "255, 255, 255, 255"
NE.colors.TB = "0, 0, 0, 255"
NE.colors.BG = "0, 0, 0, 200"
NE.colors.BA = "0, 0, 0, 255"
NE.colors.BR = "0, 0, 0, 255"
NE.ints = {}
NE.ints.AX = 0
NE.ints.AY = 1
NE.ints.TS = 18
AddElement(NE)

for i, tab in pairs(SQL_SELECT(DATABASE_NAME, "*", "name LIKE 'float_HUD_NE%'")) do
	YRP.msg("deb", tab.name .. "=" .. tab.value)
end

local COM = {}
COM.element = "COM"
COM.floats = {}
COM.floats.POSI_X = 0.41666665673256
COM.floats.POSI_Y = 0.027777777984738
COM.floats.SIZE_W = 0.16666667163372
COM.floats.SIZE_H = 0.027777777984738
COM.bools = {}
COM.bools.VISI = 1
COM.bools.ROUN = 0
COM.bools.ICON = 1
COM.bools.TEXT = 1
COM.bools.PERC = 1
COM.bools.BACK = 1
COM.bools.BORD = 0
COM.colors = {}
COM.colors.TE = "255, 255, 255, 255"
COM.colors.TB = "0, 0, 0, 255"
COM.colors.BG = "0, 0, 0, 200"
COM.colors.BA = "0, 0, 0, 255"
COM.colors.BR = "0, 0, 0, 255"
COM.ints = {}
COM.ints.AX = 1
COM.ints.AY = 1
COM.ints.TS = 12
AddElement(COM)

--[[ LOADOUT ]]--
local Player = FindMetaTable("Player")
function Player:HudLoadout()
	printGM("debug", "[HudLoadout] " .. self:YRPName())
	local hudeles = SQL_SELECT(DATABASE_NAME, "*", nil)
	if wk(hudeles) then
		for i, ele in pairs(hudeles) do
			if string.StartWith(ele.name, "float_") then
				self:SetNWFloat(ele.name, tonumber(ele.value))
			elseif string.StartWith(ele.name, "bool_") then
				self:SetNWBool(ele.name, tobool(ele.value))
			elseif string.StartWith(ele.name, "color_") then
				self:SetNWString(ele.name, ele.value)
			elseif string.StartWith(ele.name, "int_") then
				self:SetNWInt(ele.name, ele.value)
			end
		end
	end
	self:SetNWInt("hud_version", self:GetNWInt("hud_version", 0) + 1)
end

function HudLoadoutAll()
	for i, ply in pairs(player.GetAll()) do
		ply:HudLoadout()
	end
end

util.AddNetworkString("update_hud_x")
net.Receive("update_hud_x", function(len, ply)
	local element = net.ReadString()
	local x = net.ReadFloat()
	SQL_UPDATE(DATABASE_NAME, "value = '" .. x .. "'", "name = '" .. "float_HUD_" .. element .. "_POSI_X" .. "'")
	HudLoadoutAll()
end)

util.AddNetworkString("update_hud_y")
net.Receive("update_hud_y", function(len, ply)
	local element = net.ReadString()
	local y = net.ReadFloat()
	SQL_UPDATE(DATABASE_NAME, "value = '" .. y .. "'", "name = '" .. "float_HUD_" .. element .. "_POSI_Y" .. "'")
	HudLoadoutAll()
end)

util.AddNetworkString("update_hud_w")
net.Receive("update_hud_w", function(len, ply)
	local element = net.ReadString()
	local w = net.ReadFloat()
	if w > 0.0 then
		SQL_UPDATE(DATABASE_NAME, "value = '" .. w .. "'", "name = '" .. "float_HUD_" .. element .. "_SIZE_W" .. "'")
		HudLoadoutAll()
	end
end)

util.AddNetworkString("update_hud_h")
net.Receive("update_hud_h", function(len, ply)
	local element = net.ReadString()
	local h = net.ReadFloat()
	if h > 0.0 then
		SQL_UPDATE(DATABASE_NAME, "value = '" .. h .. "'", "name = '" .. "float_HUD_" .. element .. "_SIZE_H" .. "'")
		HudLoadoutAll()
	end
end)

util.AddNetworkString("get_hud_element_settings")
net.Receive("get_hud_element_settings", function(len, ply)
	local element = net.ReadString()
	local ele = SQL_SELECT(DATABASE_NAME, "*", "name LIKE '" .. "bool_HUD_" .. element .. "_%'")
	local nettab = {}
	for i, e in pairs(ele) do
		nettab[e.name] = e.value
	end
	net.Start("get_hud_element_settings")
		net.WriteTable(nettab)
	net.Send(ply)
end)

function tonum(bo)
	if bo then
		return 1
	else
		return 0
	end
end

util.AddNetworkString("update_hud_bool")
net.Receive("update_hud_bool", function(len, ply)
	local element = net.ReadString()
	local art = net.ReadString()
	local b = net.ReadBool()
	SQL_UPDATE(DATABASE_NAME, "value = '" .. tonum(b) .. "'", "name = '" .. "bool_HUD_" .. element .. "_" .. art .. "'")
	HudLoadoutAll()
end)

util.AddNetworkString("update_hud_text_position")
net.Receive("update_hud_text_position", function(len, ply)
	local element = net.ReadString()
	local ax = tonumber(net.ReadInt(4))
	local ay = tonumber(net.ReadInt(4))
	if ay == 0 then
		ay = 3
	elseif ay == 2 then
		ay = 4
	end
	SQL_UPDATE(DATABASE_NAME, "value = '" .. ax .. "'", "name = '" .. "int_HUD_" .. element .. "_" .. "AX" .. "'")
	SQL_UPDATE(DATABASE_NAME, "value = '" .. ay .. "'", "name = '" .. "int_HUD_" .. element .. "_" .. "AY" .. "'")
	HudLoadoutAll()
end)

util.AddNetworkString("update_hud_ts")
net.Receive("update_hud_ts", function(len, ply)
	local element = net.ReadString()
	local ts = net.ReadInt(8)
	if ts > 0 then
		SQL_UPDATE(DATABASE_NAME, "value = '" .. ts .. "'", "name = '" .. "int_HUD_" .. element .. "_TS" .. "'")
		HudLoadoutAll()
	end
end)

util.AddNetworkString("update_hud_color")
net.Receive("update_hud_color", function(len, ply)
	local element = net.ReadString()
	local art = net.ReadString()
	local color = net.ReadString()
	SQL_UPDATE(DATABASE_NAME, "value = '" .. color .. "'", "name = '" .. "color_HUD_" .. element .. "_" .. art .. "'")
	HudLoadoutAll()
end)