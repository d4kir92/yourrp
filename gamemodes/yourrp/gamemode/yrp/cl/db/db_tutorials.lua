--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

local YRP_TUTORIALS = {}
YRP_TUTORIALS["tut_all"] = 1
YRP_TUTORIALS["tut_cs"] = 1
YRP_TUTORIALS["tut_mr"] = 1
YRP_TUTORIALS["tut_mb"] = 1
YRP_TUTORIALS["tut_ms"] = 1
YRP_TUTORIALS["tut_tmo"] = 1
YRP_TUTORIALS["tut_vo"] = 1
YRP_TUTORIALS["tut_vi"] = 1
YRP_TUTORIALS["tut_tma"] = 1
YRP_TUTORIALS["tut_mi"] = 1
YRP_TUTORIALS["tut_sp"] = 1
YRP_TUTORIALS["tut_feedback"] = 1
YRP_TUTORIALS["tut_welcome"] = 1
YRP_TUTORIALS["tut_hudhelp"] = 1
YRP_TUTORIALS["tut_f1info"] = 1
YRP_TUTORIALS["tut_all"] = 1

local yrp_tutorials = {}

local dbfile = "yrp_tutorials/yrp_tutorials.json"

function YRPTutorialsMSG( msg )
	MsgC( YRPColGreen(), "[YourRP] [TUTORIALS] " .. msg .. "\n" )
end

function YRPTutorialsCheckFile()
	if !file.Exists( "yrp_tutorials", "DATA" ) then
		YRPTutorialsMSG( "Created Tutorial Folder" )
		file.CreateDir( "yrp_tutorials" )
	end
	if !file.Exists( dbfile, "DATA" ) then
		YRPTutorialsMSG( "Created New Tutorial File" )
		file.Write( dbfile, util.TableToJSON( YRP_TUTORIALS, true ) )
	end
end

function YRPTutorialsLoad()
	YRPTutorialsCheckFile()
	YRPTutorialsMSG( "Load Tutorials" )
	
	yrp_tutorials = util.JSONToTable( file.Read( dbfile, "DATA" ) )
end

function YRPTutorialsSave()
	YRPTutorialsCheckFile()
	YRPTutorialsMSG( "Save Tutorials" )
	
	file.Write( dbfile, util.TableToJSON( yrp_tutorials, true ) )
end

function done_tutorial(str, time)
	if tobool(get_tutorial(str) ) then
		if time == nil then
			time = 0
		end
		timer.Simple(time, function()
			yrp_tutorials[str] = 0
			YRPTutorialsSave()
		end)
	end
end

function reset_tutorial(str)
	yrp_tutorials[str] = 1
	YRPTutorialsSave()
end

function get_tutorial(str)
	return tobool(yrp_tutorials[str])
end

function YRPCheckTutorials()
	YRPTutorialsLoad()
end
YRPCheckTutorials()
