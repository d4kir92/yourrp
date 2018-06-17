--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

hr_pre()

printGM( "db", "Loading Resources" )
printGM( "db", "" )

-- yourrp content
-- resource.AddWorkshop( "1189643820" )

-- FONTS
resource.AddFile( "resource/fonts/Roboto-Regular.ttf" )
resource.AddFile( "resource/fonts/Roboto-Thin.ttf" )
resource.AddFile( "resource/fonts/Roboto-Bold.ttf" )

-- Food and Household items
resource.AddWorkshop( "108024198" )

--Server Workshop Collection
local _wsitems = engine.GetAddons()
printGM( "db", #_wsitems .. " Workshop files that will be send to Clients" )
printGM( "db", "" )
printGM( "db", "Nr.\t\tName" )
--printGM( "db", " Nr.\tID\t\tName" )
local _mounted = 0
for k, ws in pairs( _wsitems ) do
	if ws.mounted then
		printGM( "db", "+[" .. k .. "]\t[" .. tostring( ws.title ) .. "]" )
		--printGM( "note", "+[" .. k .. "]\t[" .. tostring( ws.wsid ) .. "]\t[" .. tostring( ws.title ) .. "]" )

    resource.AddWorkshop( tostring( ws.wsid ) )
		_mounted = _mounted + 1
	end
end
printGM( "db", "" )
printGM( "db", "=> " .. tostring( _mounted ) .. "/" .. tostring( #_wsitems ) .. " mounted" )
printGM( "db", "" )

printGM( "db", "Loaded Resources" )
hr_pos()
