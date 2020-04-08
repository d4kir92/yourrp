--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_design"

SQL_ADD_COLUMN(DATABASE_NAME, "string_hud_design", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "string_interface_design", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "string_fontname", "TEXT DEFAULT 'Impact'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_hud_profile", "TEXT DEFAULT 'YourRP Default'")
SQL_ADD_COLUMN(DATABASE_NAME, "int_headerheight", "INT DEFAULT '100'")

local fir = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = 1")
if fir == nil then
	SQL_INSERT_INTO(DATABASE_NAME, "string_hud_design, string_interface_design, string_fontname", "'Simple', 'Material', 'Roboto'")
elseif wk(fir) then
	fir = fir[1]
	if fir.string_interface_design == "Simple" or fir.string_hud_design == "Material" then
		SQL_UPDATE(DATABASE_NAME, "string_hud_design = 'Simple'", "uniqueID = '" .. "1" .. "'")
		SQL_UPDATE(DATABASE_NAME, "string_interface_design = 'Material'", "uniqueID = '" .. "1" .. "'")
	end
end

--SQL_DROPTABLE(DATABASE_NAME)

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

hook.Add("RegisterHUDDesign", "RegisterHUDDesign_space", function()
	local HUD_Space = {}
	HUD_Space.name = "Space"
	HUD_Space.author = "D4KiR"
	HUD_Space.progress = 90
	RegisterHUDDesign(HUD_Space)
end)

hook.Add("RegisterHUDDesign", "RegisterHUDDesign_fallout_76", function()
	local HUD_FO76 = {}
	HUD_FO76.name = "Fallout 76"
	HUD_FO76.author = "D4KiR"
	HUD_FO76.progress = 100
	RegisterHUDDesign(HUD_FO76)
end)

hook.Add("RegisterHUDDesign", "RegisterHUDDesign_icons", function()
	local HUD_Icons = {}
	HUD_Icons.name = "Icons"
	HUD_Icons.author = "D4KiR"
	HUD_Icons.progress = 100
	RegisterHUDDesign(HUD_Icons)
end)

hook.Add("RegisterHUDDesign", "RegisterHUDDesign_circles", function()
	local HUD_Circles = {}
	HUD_Circles.name = "Circles"
	HUD_Circles.author = "D4KiR"
	HUD_Circles.progress = 90
	RegisterHUDDesign(HUD_Circles)
end)

--[[ LOADOUT ]]--
local Player = FindMetaTable("Player")
function Player:DesignLoadout(from)
	self:SetDInt("yrp_loading", 0)
	self:HudLoadout()
	self:InterfaceLoadout()
	printGM("debug", "[DesignLoadout] " .. self:YRPName() .. " " .. from)
	local setting = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'")
	if wk(setting) then
		setting = setting[1]
		self:SetDString("string_hud_design", setting.string_hud_design)
		SetGlobalDString("string_interface_design", setting.string_interface_design)
		SetGlobalDString("string_hud_profile", setting.string_hud_profile)
		SetGlobalDInt("int_headerheight", setting.int_headerheight)
	end
	self:SetDInt("yrp_loading", 100)
end

util.AddNetworkString("rebuildHud")
net.Receive("rebuildHud", function(len, ply)
	YRP.msg("note", "FAILED HUD => REBUILD HUD")
	ply:DesignLoadout("rebuildHud")
end)

local once = false
util.AddNetworkString("ply_changed_resolution")
net.Receive("ply_changed_resolution", function(len, ply)
	YRP.msg("note", ply:YRPName() .. " changed the Resolution.")
	if !once then
		once = true
		return
	end
	--ply:DesignLoadout("ply_changed_resolution")
end)

util.AddNetworkString("change_hud_design")
net.Receive("change_hud_design", function(len, ply)
	local string_hud_design = net.ReadString()
	printGM("db", "[DESIGN] string_hud_design changed to " .. string_hud_design)
	SQL_UPDATE(DATABASE_NAME, "string_hud_design = '" .. string_hud_design .. "'", "uniqueID = '1'")
	for i, pl in pairs(player.GetAll()) do
		pl:SetDString("string_hud_design", string_hud_design)
	end
end)

-- Interface
INTERFACES = INTERFACES or {}
function RegisterInterfaceDesign(tab)
	if tab.name == nil then
		printGM("note", "RegisterDesign Failed! Missing Design Name")
		return false
	elseif tab.author == nil then
		printGM("note", "RegisterDesign Failed! Missing Design Author")
		return false
	end
	INTERFACES[tab.name] = tab
	YRP.msg("db", "Added Interface Design (" .. tostring(tab.name) .. ")")
	return true
end

local IF_Material = {}
IF_Material.name = "Material"
IF_Material.author = "D4KiR"
IF_Material.progress = 100
RegisterInterfaceDesign(IF_Material)

local IF_Blur = {}
IF_Blur.name = "Blur"
IF_Blur.author = "D4KiR"
IF_Blur.progress = 50
RegisterInterfaceDesign(IF_Blur)

util.AddNetworkString("change_interface_design")
net.Receive("change_interface_design", function(len, ply)
	local string_interface_design = net.ReadString()
	printGM("db", "[DESIGN] string_interface_design changed to " .. string_interface_design)
	SQL_UPDATE(DATABASE_NAME, "string_interface_design = '" .. string_interface_design .. "'", "uniqueID = '1'")
	SetGlobalDString("string_interface_design", string_interface_design)

	ResetDesign()
end)

-- F8 Design Page
util.AddNetworkString("get_design_settings")
net.Receive("get_design_settings", function(len, ply)
	if ply:CanAccess("bool_design") then
		hook.Call("RegisterHUDDesign")
		local setting = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'")
		local hud_profiles = GetHudProfiles()
		if wk(setting) then
			setting = setting[1]
			net.Start("get_design_settings")
				net.WriteTable(setting)
				net.WriteTable(HUDS)
				net.WriteTable(INTERFACES)
				net.WriteTable(hud_profiles)
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

util.AddNetworkString("yrp_change_headerheight")
net.Receive("yrp_change_headerheight", function(len, ply)
	local newheaderheight = net.ReadString()
	newheaderheight = tonumber(newheaderheight)

	SQL_UPDATE(DATABASE_NAME, "int_headerheight = '" .. newheaderheight .. "'", "uniqueID = '1'")
	SetGlobalDInt("int_headerheight", newheaderheight)
end)