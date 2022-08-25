--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- Colors --
local col_green = Color( 0, 255, 0, 255 )
function YRPColGreen()
	return col_green
end
local col_red = Color( 255, 0, 0, 255 )
function YRPColRed()
	return col_red
end
local col_blue = Color( 0, 0, 255, 255 )
function YRPColBlue()
	return col_blue
end
local col_yellow = Color( 255, 255, 0, 255 )
function YRPColYellow()
	return col_yellow
end

color_dark1 = Color( 60, 60, 60 )
-- Colors --

add_luas( "collect.lua" )
add_luas( "output.lua" )
add_luas( "version.lua" )
add_luas( "error.lua" )
add_luas( "math.lua" )
add_luas( "lib_sql.lua" )
add_luas( "sql.lua" )
add_luas( "trace.lua" )
add_luas( "vehicles.lua" )
add_luas( "date.lua" )
add_luas( "sp.lua" )
add_luas( "table.lua" )
--add_luas( "items.lua" )

AddCSLuaFile( "derma.lua" )
AddCSLuaFile( "yrp_derma.lua" )
AddCSLuaFile( "derma/yframe.lua" )
AddCSLuaFile( "derma/ygroupbox.lua" )
AddCSLuaFile( "derma/ybutton.lua" )
AddCSLuaFile( "derma/ycollapsiblecategory.lua" )
AddCSLuaFile( "derma/ylabel.lua" )
AddCSLuaFile( "derma/ypanel.lua" )
AddCSLuaFile( "derma/ycolormenu.lua" )
AddCSLuaFile( "derma/ycolormenubutton.lua" )
AddCSLuaFile( "derma/DYRPCollapsibleCategory.lua" )
AddCSLuaFile( "derma/DYRPDBList.lua" )
AddCSLuaFile( "derma/DYRPTextEntry.lua" )
AddCSLuaFile( "derma/DYRPNumberWang.lua" )
AddCSLuaFile( "derma/DYRPPanelPlus.lua" )
AddCSLuaFile( "derma/DYRPTabs.lua" )
AddCSLuaFile( "derma/DYRPMenu.lua" )
AddCSLuaFile( "derma/DYRPHorizontalMenu.lua" )
AddCSLuaFile( "derma/yvoice.lua" )
AddCSLuaFile( "interface/base.lua" )

AddCSLuaFile( "derma/ynumberwang.lua" )

AddCSLuaFile( "derma/ystorage.lua" )
AddCSLuaFile( "derma/ybag.lua" )
AddCSLuaFile( "derma/yitem.lua" )
AddCSLuaFile( "derma/yslot.lua" )

AddCSLuaFile( "derma/ytabs.lua" )
AddCSLuaFile( "derma/ymodelpanel.lua" )

if CLIENT then
	include( "derma.lua" )
	include( "yrp_derma.lua" )
	include( "derma/yframe.lua" )
	include( "derma/ygroupbox.lua" )
	include( "derma/ybutton.lua" )
	include( "derma/ycollapsiblecategory.lua" )
	include( "derma/ylabel.lua" )
	include( "derma/ypanel.lua" )
	include( "derma/ycolormenu.lua" )
	include( "derma/ycolormenubutton.lua" )
	include( "derma/DYRPCollapsibleCategory.lua" )
	include( "derma/DYRPDBList.lua" )
	include( "derma/DYRPTextEntry.lua" )
	include( "derma/DYRPNumberWang.lua" )
	include( "derma/DYRPPanelPlus.lua" )
	include( "derma/DYRPTabs.lua" )
	include( "derma/DYRPMenu.lua" )
	include( "derma/DYRPHorizontalMenu.lua" )
	include( "derma/yvoice.lua" )
	include( "interface/base.lua" )

	include( "derma/ynumberwang.lua" )

	include( "derma/ystorage.lua" )
	include( "derma/ybag.lua" )
	include( "derma/yitem.lua" )
	include( "derma/yslot.lua" )

	include( "derma/ytabs.lua" )
	include( "derma/ymodelpanel.lua" )
end
