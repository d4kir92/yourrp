--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

print("Loading _libs_includes.lua")

add_luas("collect.lua")
add_luas("output.lua")
add_luas("version.lua")
add_luas("error.lua")
add_luas("math.lua")
add_luas("lib_sql.lua")
add_luas("sql.lua")
add_luas("trace.lua")
add_luas("vehicles.lua")
add_luas("date.lua")
add_luas("sp.lua")
add_luas("table.lua")
--add_luas("items.lua")

AddCSLuaFile("derma.lua")
AddCSLuaFile("yrp_derma.lua")
AddCSLuaFile("derma/yframe.lua")
AddCSLuaFile("derma/ybutton.lua")
AddCSLuaFile("derma/ylabel.lua")
AddCSLuaFile("derma/ypanel.lua")
AddCSLuaFile("derma/ycolormenu.lua")
AddCSLuaFile("derma/ycolormenubutton.lua")
AddCSLuaFile("derma/DYRPCollapsibleCategory.lua")
AddCSLuaFile("derma/DYRPDBList.lua")
AddCSLuaFile("derma/DYRPTextEntry.lua")
AddCSLuaFile("derma/DYRPNumberWang.lua")
AddCSLuaFile("derma/DYRPPanelPlus.lua")
AddCSLuaFile("derma/DYRPTabs.lua")
AddCSLuaFile("derma/DYRPMenu.lua")
AddCSLuaFile("derma/DYRPHorizontalMenu.lua")
AddCSLuaFile("interface/base.lua")

AddCSLuaFile("derma/ystorage.lua")
AddCSLuaFile("derma/ybag.lua")
AddCSLuaFile("derma/yitem.lua")
AddCSLuaFile("derma/yslot.lua")

if CLIENT then
	include("derma.lua")
	include("yrp_derma.lua")
	include("derma/yframe.lua")
	include("derma/ybutton.lua")
	include("derma/ylabel.lua")
	include("derma/ypanel.lua")
	include("derma/ycolormenu.lua")
	include("derma/ycolormenubutton.lua")
	include("derma/DYRPCollapsibleCategory.lua")
	include("derma/DYRPDBList.lua")
	include("derma/DYRPTextEntry.lua")
	include("derma/DYRPNumberWang.lua")
	include("derma/DYRPPanelPlus.lua")
	include("derma/DYRPTabs.lua")
	include("derma/DYRPMenu.lua")
	include("derma/DYRPHorizontalMenu.lua")
	include("interface/base.lua")

	include("derma/ystorage.lua")
	include("derma/ybag.lua")
	include("derma/yitem.lua")
	include("derma/yslot.lua")
end

print("Loaded _libs_includes.lua")
