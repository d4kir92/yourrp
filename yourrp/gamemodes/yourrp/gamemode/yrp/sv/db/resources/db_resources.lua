--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

-- #Resources #Content #Addons

hr_pre("gm")

YRP.msg("gm", "Loading Resources")
YRP.msg("gm", "")



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
YRP.msg("gm", "Nr.\t\tName")
--YRP.msg("gm", " Nr.\tID\t\tName")
local i = 0
local d = 0
for k, ws in pairs(_wsitems) do
	i = i + 1

	if ws.mounted and ws.downloaded then
		YRP.msg("gm", "+[" .. k .. "]\t[" .. tostring(ws.title) .. "]")
		--YRP.msg("note", "+[" .. k .. "]\t[" .. tostring(ws.wsid) .. "]\t[" .. tostring(ws.title) .. "]")

		resource.AddWorkshop(tostring(ws.wsid))
		d = d + 1
	else
		YRP.msg("gm", ">>> Addon [" .. ws.title .. "] not mounted or downloaded <<<")
	end
end
YRP.msg("gm", "")
YRP.msg("gm", "=> " .. tostring(d) .. "/" .. tostring(i) .. " Workshop files that will be send to Clients")
YRP.msg("gm", "")

YRP.msg("gm", "Loaded Resources")
hr_pos("gm")
