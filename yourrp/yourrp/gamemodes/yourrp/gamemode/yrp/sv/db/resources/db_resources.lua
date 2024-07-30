--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
-- #Resources #Content #Addons
YRPWDLOADED = YRPWDLOADED or false
YRPLOADEDGMAS = YRPLOADEDGMAS or {}
function YRPWorkshopDownload()
	if YRPWDLOADED == false then
		YRPWDLOADED = true
		YRPHR()
		YRP:msg("gm", "Loading Resources (Workshop-Downloader)")
		YRPSP()
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
		YRP:msg("gm", header)
		local i = 0
		local d = 0
		for k, ws in pairs(_wsitems) do
			i = i + 1
			if ws.mounted and ws.downloaded then
				YRP:msg("gm", "+[" .. string.format("%0" .. form .. "d", k) .. "] [" .. tostring(ws.title) .. "]")
				resource.AddWorkshop(tostring(ws.wsid))
				YRPLOADEDGMAS[tonumber(ws.wsid)] = true
				d = d + 1
			else
				YRP:msg("gm", ">>> Addon [" .. ws.title .. "] not mounted or not downloaded <<<")
			end
		end

		--[[local gmas, ordner = file.Find( "cache/srcds/*.gma", "GAME"  )
		if gmas then
			for i, gma in pairs( gmas ) do
				gma = string.Replace( gma, ".gma", "" )
				gma = tonumber( gma )
				if not YRPLOADEDGMAS[gma] then
					resource.AddWorkshop( tostring( gma ) )
					YRPLOADEDGMAS[gma] = true
					d = d + 1
					i = i + 1
				end
			end
		end]]
		YRPSP()
		YRP:msg("gm", "=> " .. tostring(d) .. "/" .. tostring(i) .. " Workshop files that will be send to Clients")
		YRPSP()
		YRP:msg("gm", "Loaded Resources (Workshop-Downloader)")
		YRPHR()
	end
end

timer.Simple(
	0,
	function()
		YRPWorkshopDownload()
	end
)
