--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

-- #Resources #Content #Addons

hr_pre("gm")

printGM("gm", "Loading Resources")
printGM("gm", "")



-- YourRP Content
resource.AddWorkshop("1189643820")

-- Food and Household items
resource.AddWorkshop("108024198")

-- Bandage
resource.AddWorkshop("816191432")

-- Cuffs
resource.AddWorkshop("314312925")

-- Key
resource.AddWorkshop("182308069")

--Server Workshop Collection
local _wsitems = engine.GetAddons()
printGM("gm", "Nr.\t\tName")
--printGM("gm", " Nr.\tID\t\tName")
local i = 0
local d = 0
for k, ws in pairs(_wsitems) do
	i = i + 1

	if ws.mounted and ws.downloaded then
		printGM("gm", "+[" .. k .. "]\t[" .. tostring(ws.title) .. "]")
		--printGM("note", "+[" .. k .. "]\t[" .. tostring(ws.wsid) .. "]\t[" .. tostring(ws.title) .. "]")

		resource.AddWorkshop(tostring(ws.wsid))
		d = d + 1
	else
		YRP.msg("gm", ">>> Addon [" .. ws.title .. "] not mounted or downloaded <<<")
	end
end
printGM("gm", "")
printGM("gm", "=> " .. tostring(d) .. "/" .. tostring(i) .. " Workshop files that will be send to Clients")
printGM("gm", "")

printGM("gm", "Loaded Resources")
hr_pos("gm")
