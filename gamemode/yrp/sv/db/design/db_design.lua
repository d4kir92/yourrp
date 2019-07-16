--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_design"

--[[ OLD
SQL_ADD_COLUMN(_db_name, "color", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(_db_name, "style", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(_db_name, "design", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(_db_name, "rounded", "INT DEFAULT '0'")
SQL_ADD_COLUMN(_db_name, "transparent", "INT DEFAULT '1'")
SQL_ADD_COLUMN(_db_name, "border", "INT DEFAULT '0'")
]]-- OLD

SQL_ADD_COLUMN(DATABASE_NAME, "string_hud_design", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME, "string_interface_design", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME, "string_fontname", "TEXT DEFAULT 'Ubuntu'")

if SQL_SELECT(DATABASE_NAME, "*", "uniqueID = 1") == nil then
	SQL_INSERT_INTO(DATABASE_NAME, "string_hud_design, string_interface_design, string_fontname", "'Simple', 'Simple', 'Ubuntu'")
end

local HUDS = {}
function RegisterHUDDesign(tab)
	if tab.name == nil then
		printGM("note", "RegisterDesign Failed! Missing Design Name")
		return false
	elseif tab.author == nil then
		printGM("note", "RegisterDesign Failed! Missing Design Author")
		return false
	end
	HUDS[tab.name] = tab
	return true
end

hook.Add("RegisterHUDDesign", "RegisterHUDDesign_none", function()
	local HUD_None = {}
	HUD_None.name = "Disabled"
	HUD_None.author = "YourRP"
	HUD_None.progress = 100
	RegisterHUDDesign(HUD_None)
end)

hook.Add("RegisterHUDDesign", "RegisterHUDDesign_simple", function()
	local HUD_Simple = {}
	HUD_Simple.name = "Simple"
	HUD_Simple.author = "D4KiR"
	HUD_Simple.progress = 100
	RegisterHUDDesign(HUD_Simple)
end)

hook.Add("RegisterHUDDesign", "RegisterHUDDesign_fallout_76", function()
	local HUD_FO76 = {}
	HUD_FO76.name = "Fallout 76"
	HUD_FO76.author = "D4KiR"
	HUD_FO76.progress = 100
	RegisterHUDDesign(HUD_FO76)
end)



--[[ LOADOUT ]]--
local Player = FindMetaTable("Player")
function Player:DesignLoadout()
	self:SetNW2Int("yrp_loading", 0)
	self:HudLoadout()
	self:InterfaceLoadout()
	printGM("debug", "[DesignLoadout] " .. self:YRPName())
	local setting = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'")
	if wk(setting) then
		setting = setting[1]
		self:SetNW2String("string_hud_design", setting.string_hud_design)
		self:SetNW2String("string_interface_design", setting.string_interface_design)
	end
	self:SetNW2Int("yrp_loading", 100)
end

local once = false
util.AddNetworkString("ply_changed_resolution")
net.Receive("ply_changed_resolution", function(len, ply)
	YRP.msg("note", ply:YRPName() .. " changed the Resolution.")
	if !once then
		once = true
		return
	end
	ply:DesignLoadout()
end)

util.AddNetworkString("change_hud_design")
net.Receive("change_hud_design", function(len, ply)
	local string_hud_design = net.ReadString()
	printGM("db", "[DESIGN] string_hud_design changed to " .. string_hud_design)
	SQL_UPDATE(DATABASE_NAME, "string_hud_design = '" .. string_hud_design .. "'", "uniqueID = '1'")
	for i, pl in pairs(player.GetAll()) do
		pl:SetNW2String("string_hud_design", string_hud_design)
	end
end)

-- Interface
local INTERFACES = {}
function RegisterInterfaceDesign(tab)
	if tab.name == nil then
		printGM("note", "RegisterDesign Failed! Missing Design Name")
		return false
	elseif tab.author == nil then
		printGM("note", "RegisterDesign Failed! Missing Design Author")
		return false
	end
	INTERFACES[tab.name] = tab
	return true
end

local IF_Simple = {}
IF_Simple.name = "Simple"
IF_Simple.author = "D4KiR"
IF_Simple.progress = 20
RegisterInterfaceDesign(IF_Simple)

util.AddNetworkString("change_interface_design")
net.Receive("change_interface_design", function(len, ply)
	local string_interface_design = net.ReadString()
	printGM("db", "[DESIGN] string_interface_design changed to " .. string_interface_design)
	SQL_UPDATE(DATABASE_NAME, "string_interface_design = '" .. string_interface_design .. "'", "uniqueID = '1'")
	for i, pl in pairs(player.GetAll()) do
		pl:SetNW2String("string_interface_design", string_interface_design)
	end
end)

-- F8 Design Page
util.AddNetworkString("get_design_settings")
net.Receive("get_design_settings", function(len, ply)
	if ply:CanAccess("bool_design") then
		hook.Call("RegisterHUDDesign")
		local setting = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'")
		if wk(setting) then
			setting = setting[1]
			net.Start("get_design_settings")
				net.WriteTable(setting)
				net.WriteTable(HUDS)
				net.WriteTable(INTERFACES)
			net.Send(ply)
		end
	end
end)

util.AddNetworkString("yrp_set_font")
function SendFontName(ply)
	local tab = {}
	tab.table = DATABASE_NAME
	tab.cols = {}
	tab.cols[1] = "string_fontname"
	tab.where = "uniqueID = '1'"

	local dbtab = SQL.SELECT(tab)
	if wk(dbtab) then
		dbtab = dbtab[1]

		net.Start("yrp_set_font")
			net.WriteString(dbtab.string_fontname)
		net.Send(ply)
	end
end

net.Receive("yrp_set_font", function(len, ply)
	SendFontName(ply)
end)

util.AddNetworkString("yrp_update_font")
net.Receive("yrp_update_font", function(len, ply)
	local string_fontname = net.ReadString()
	printGM("db", "[DESIGN] string_fontname changed to " .. string_fontname)
	SQL_UPDATE(DATABASE_NAME, "string_fontname = '" .. string_fontname .. "'", "uniqueID = '1'")

	for i, p in pairs(player.GetAll()) do
		SendFontName(p)
	end
end)
