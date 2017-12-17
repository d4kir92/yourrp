--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

hr_pre()

printGM( "db", "Loading Resources" )

--yourrp content
resource.AddWorkshop( "1189643820" )

--handcuffs
resource.AddWorkshop( "314312925" )

--Food and Household items
resource.AddWorkshop( "108024198" )

--Server Workshop Collection
printGM( "note", "Workshop files that will be send to Clients" )
local _wsitems = engine.GetAddons()
printGM( "note", "[" .. #_wsitems .. " Workshop items]" )
printGM( "note", " Nr.\tID\t\tName" )
for k, ws in pairs( _wsitems ) do
	if ws.mounted then
		printGM( "note", "+[" .. k .. "]\t[" .. tostring( ws.wsid ) .. "]\t[" .. tostring( ws.title ) .. "]" )

    resource.AddWorkshop( tostring( ws.wsid ) )
	end
end

printGM( "db", "Loaded Resources" )
hr_pos()
