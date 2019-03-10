--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

hr_pre("gm")

printGM("gm", "Loading Resources")
printGM("gm", "")

-- YourRP Content
resource.AddWorkshop("1189643820")

-- FONTS
resource.AddFile("resource/fonts/Roboto-Regular.ttf")
resource.AddFile("resource/fonts/Roboto-Thin.ttf")
resource.AddFile("resource/fonts/Roboto-Bold.ttf")

-- Food and Household items
--resource.AddWorkshop("108024198")

--Server Workshop Collection
local _wsitems = engine.GetAddons()
printGM("gm", #_wsitems .. " Workshop files that will be send to Clients")
printGM("gm", "")
printGM("gm", "Nr.\t\tName")
--printGM("gm", " Nr.\tID\t\tName")
local _mounted = 0
for k, ws in pairs(_wsitems) do
	if ws.mounted then
		printGM("gm", "+[" .. k .. "]\t[" .. tostring(ws.title) .. "]")
		--printGM("note", "+[" .. k .. "]\t[" .. tostring(ws.wsid) .. "]\t[" .. tostring(ws.title) .. "]")

		resource.AddWorkshop(tostring(ws.wsid))
		_mounted = _mounted + 1
	end
end
printGM("gm", "")
printGM("gm", "=> " .. tostring(_mounted) .. "/" .. tostring(#_wsitems) .. " mounted")
printGM("gm", "")

printGM("gm", "Loaded Resources")
hr_pos("gm")
