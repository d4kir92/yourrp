--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

local YRP_SMARTPHONE = {}
YRP_SMARTPHONE["color_back"] = Color( 0, 0, 0, 255 )
YRP_SMARTPHONE["color_case"] = Color( 0, 0, 0, 255 )

local yrp_smartphone = {}

local dbfile = "yrp_smartphone/yrp_smartphone.json"

function YRPSmartphoneMSG( msg )
	MsgC( Color( 0, 255, 0 ), "[YourRP] [SMARTPHONE] " .. msg .. "\n" )
end

function YRPSmartphoneCheckFile()
	if !file.Exists( "yrp_smartphone", "DATA" ) then
		YRPSmartphoneMSG( "Created Tutorial Folder" )
		file.CreateDir( "yrp_smartphone" )
	end
	if !file.Exists( dbfile, "DATA" ) then
		YRPSmartphoneMSG( "Created New Tutorial File" )
		file.Write( dbfile, util.TableToJSON( YRP_SMARTPHONE, true ) )
	end
end

function YRPSmartphoneLoad()
	YRPSmartphoneCheckFile()
	YRPSmartphoneMSG( "Load Smartphone" )
	
	yrp_smartphone = util.JSONToTable( file.Read( dbfile, "DATA" ) )
end

function YRPSmartphoneSave()
	YRPSmartphoneCheckFile()
	YRPSmartphoneMSG( "Save Smartphone" )
	
	file.Write( dbfile, util.TableToJSON( yrp_smartphone, true ) )
end

function setSpBackColor(color)
	yrp_smartphone["color_back"] = StringToColor( color )
	YRPSmartphoneSave()
end

function getSpBackColor()
	if yrp_smartphone["color_back"] != nil then
		return Color( yrp_smartphone["color_back"] )
	else
		return Color( 255, 0, 0, 255 )
	end
end

function setSpCaseColor(color)
	yrp_smartphone["color_case"] = StringToColor( color )
	YRPSmartphoneSave()
end

function getSpCaseColor()
	if yrp_smartphone["color_case"] != nil then
		return Color( yrp_smartphone["color_case"] )
	else
		return Color( 255, 0, 0, 255 )
	end
end

function YRPCheckSmartphone()
	YRPSmartphoneLoad()
end
YRPCheckSmartphone()
