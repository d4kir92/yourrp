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

SQL_ADD_COLUMN(DATABASE_NAME, "string_hud_design", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "string_interface_design", "TEXT DEFAULT ''")

if SQL_SELECT(DATABASE_NAME, "*", "uniqueID = 1") == nil then
	SQL_INSERT_INTO(DATABASE_NAME, "string_hud_design, string_interface_design", "'Simple', 'Simple'")
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

local HUD_Simple = {}
HUD_Simple.name = "Simple"
HUD_Simple.author = "D4KiR"
HUD_Simple.progress = 100
RegisterHUDDesign(HUD_Simple)

local HUD_FO76 = {}
HUD_FO76.name = "Fallout 76"
HUD_FO76.author = "D4KiR"
HUD_FO76.progress = 100
RegisterHUDDesign(HUD_FO76)

--[[ LOADOUT ]]--
local Player = FindMetaTable("Player")
function Player:DesignLoadout()
	printGM("debug", "[DesignLoadout] " .. self:YRPName())
	local setting = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'")
	if wk(setting) then
		setting = setting[1]
		self:SetNWString("string_hud_design", setting.string_hud_design)
	end
end

util.AddNetworkString("get_design_settings")
net.Receive("get_design_settings", function(len, ply)
	if ply:CanAccess("bool_design") then
		local setting = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'")
		if wk(setting) then
			setting = setting[1]
			net.Start("get_design_settings")
				net.WriteTable(setting)
				net.WriteTable(HUDS)
			net.Send(ply)
		end
	end
end)

util.AddNetworkString("change_hud_design")
net.Receive("change_hud_design", function(len, ply)
	local string_hud_design = net.ReadString()
	printGM("db", "[DESIGN] string_hud_design changed to " .. string_hud_design)
	SQL_UPDATE(DATABASE_NAME, "string_hud_design = '" .. string_hud_design .. "'", "uniqueID = '1'")
	for i, pl in pairs(player.GetAll()) do
		pl:SetNWString("string_hud_design", string_hud_design)
	end
end)
