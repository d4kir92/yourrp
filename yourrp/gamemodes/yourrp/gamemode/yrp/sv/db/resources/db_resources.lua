--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

-- #Resources #Content #Addons

hr_pre("gm")

YRP.msg("gm", "Loading Resources (Workshop-Downloader)")
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
local _wscount = table.Count(_wsitems)
local form = math.log10(_wscount) - math.log10(_wscount) % 1 + 1

local header = ""
header = header .. " NR"
for i = 1, form do
	header = header .. " "
end
header = header .. " NAME"
YRP.msg("gm", header)

local i = 0
local d = 0
for k, ws in pairs(_wsitems) do
	i = i + 1

	if ws.mounted and ws.downloaded then
		YRP.msg("gm", "+[" .. string.format("%0" .. form .. "d", k) .. "] [" .. tostring(ws.title) .. "]")

		resource.AddWorkshop(tostring(ws.wsid))
		d = d + 1
	else
		YRP.msg("gm", ">>> Addon [" .. ws.title .. "] not mounted or downloaded <<<")
	end
end
YRP.msg("gm", "")
YRP.msg("gm", "=> " .. tostring(d) .. "/" .. tostring(i) .. " Workshop files that will be send to Clients")
YRP.msg("gm", "")

YRP.msg("gm", "Loaded Resources (Workshop-Downloader)")
hr_pos("gm")
