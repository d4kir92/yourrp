--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local SPACE = {}
local ELES = {}
function YRPHUDSpace()
	local lply = LocalPlayer()
	if YRP and YRP.GetDesignIcon and lply:LoadedGamemode() then
		local HP = YRP:GetDesignIcon("64_heart")
		local AR = YRP:GetDesignIcon("64_shield-alt")
		local ST = YRP:GetDesignIcon("64_running")
		local BA = YRP:GetDesignIcon("64_battery-full")
		local HU = YRP:GetDesignIcon("64_hamburger")
		local TH = YRP:GetDesignIcon("64_glass-cheers")
		local AL = YRP:GetDesignIcon("64_wine-bottle")
		local XP = YRP:GetDesignIcon("64_atom")
		local MO = YRP:GetDesignIcon("64_money-bill")
		local SA = YRP:GetDesignIcon("64_money-bill-alt")
		local CA = YRP:GetDesignIcon("64_magic")
		local AB = YRP:GetDesignIcon("64_tint")
		local RA = YRP:GetDesignIcon("64_radiation")
		local ID = YRP:GetDesignIcon("64_address-card")
		local CR = YRP:GetDesignIcon("64_clock")
		local CC = YRP:GetDesignIcon("64_clock")
		local RO = YRP:GetDesignIcon("64_user-graduate")
		local NA = YRP:GetDesignIcon("64_user")
		if GetGlobalYRPBool("bool_yrp_hud", false) and lply:GetHudDesignName() == "Space" then
			ELES["HP"] = {lply:Health(), lply:GetMaxHealth(), HP}
			ELES["AR"] = {lply:Armor(), lply:GetMaxArmor(), AR}
			ELES["AB"] = {lply:Ability(), lply:GetMaxAbility(), AB, lply:Ability() / lply:GetMaxAbility() * 100 .. "%",}
			ELES["ST"] = {lply:Stamina(), lply:GetMaxStamina(), ST}
			ELES["HU"] = {lply:Hunger(), lply:GetMaxHunger(), HU}
			ELES["TH"] = {lply:Thirst(), lply:GetMaxThirst(), TH}
			ELES["AL"] = {lply:Permille(), lply:GetMaxPermille(), AL, lply:Permille() / lply:GetMaxPermille() * 100 .. "‰",}
			local weapon = lply:GetActiveWeapon()
			if weapon:IsValid() then
				local clip1 = weapon:Clip1()
				local clip1max = weapon:GetMaxClip1()
				local ammo1 = lply:GetAmmoCount(weapon:GetPrimaryAmmoType())
				local clip2 = weapon:Clip2()
				local clip2max = weapon:GetMaxClip2()
				local ammo2 = lply:GetAmmoCount(weapon:GetSecondaryAmmoType())
				ELES["WP"] = {clip1, clip1max, nil, clip1 .. "/" .. clip1max .. " | " .. ammo1,}
				local a2 = ammo2
				ELES["WS"] = {clip2, clip2max, nil, a2,}
				ELES["WN"] = {1, 1, nil, weapon:GetPrintName()}
			end

			ELES["MO"] = {lply:Money(), nil, MO, lply:FormattedMoney()}
			ELES["SA"] = {lply:Salary(), nil, SA, lply:FormattedSalary()}
			ELES["CA"] = {lply:CastTimeCurrent(), lply:CastTimeMax(), CA, lply:GetCastName()}
			ELES["BA"] = {system.BatteryPower(), 100, BA, system.BatteryPower() .. "%"}
			local t = {}
			t["LEVEL"] = lply:Level()
			ELES["XP"] = {lply:XP(), lply:GetMaxXP(), XP, YRP:trans("LID_levelx", t) .. " ( " .. lply:XP() .. "/" .. lply:GetMaxXP() .. " )"}
			ELES["CH"] = {0, nil, nil, nil, 1}
			ELES["CR"] = {0, nil, CR, os.date("%H:%M", os.time()),}
			--2
			ELES["CC"] = {0, nil, CC, lply:YRPFormattedCharPlayTime(),}
			--2
			ELES["PE"] = {0, nil, nil, YRP:trans("LID_fps") .. ": " .. GetFPS(), 2}
			ELES["NE"] = {0, nil, nil, YRP:trans("LID_ping") .. ": " .. lply:Ping(), 2}
			ELES["SN"] = {0, nil, nil, GetGlobalYRPString("text_server_name", "SERVERNAME"), 2}
			ELES["RA"] = {lply:Radiation(), lply:GetMaxRadiation(), RA}
			ELES["LO"] = {0, nil, nil, "[" .. GTS("lockdown") .. "] " .. lply:LockdownText(), 2}
			ELES["RO"] = {0, nil, RO, lply:GetRoleName()}
			ELES["NA"] = {0, nil, NA, lply:RPName()}
			ELES["ID"] = {0, nil, ID, lply:GetYRPString("idcardid", ""),}
			--2
			ELES["CON"] = {0, nil, nil, lply:Condition()}
			for id = 1, 10 do
				ELES["BOX" .. id] = {0, nil, nil, nil, 3}
			end

			if GetGlobalYRPInt("YRPHUDVersion", -1) ~= SPACE["version"] then
				-- LOAD VARIABLES
				SPACE["version"] = GetGlobalYRPInt("YRPHUDVersion", -1)
				for ele, etab in pairs(ELES) do
					local DB = lply:HudElement(ele)
					local icon_size = 0
					if etab[3] ~= nil then
						icon_size = DB.SIZE_H
					end

					local BR = YRP:ctr(10)
					SPACE[ele] = {}
					SPACE[ele].Visible = DB.VISI or false
					SPACE[ele].w = DB.SIZE_W
					SPACE[ele].h = DB.SIZE_H
					SPACE[ele].x = DB.POSI_X
					SPACE[ele].y = DB.POSI_Y
					SPACE[ele].WCenter = DB.POSI_X + DB.SIZE_W / 2
					SPACE[ele].HCenter = DB.POSI_Y + DB.SIZE_H / 2
					local ax = 0
					local ay = 0
					SPACE[ele].ax = DB.AX
					SPACE[ele].ay = DB.AY
					if etab[3] ~= nil then
						SPACE[ele].BackgroundW = DB.SIZE_W - icon_size - BR
						SPACE[ele].BackgroundH = DB.SIZE_H
						SPACE[ele].BackgroundX = DB.POSI_X + icon_size + BR
						SPACE[ele].BackgroundY = DB.POSI_Y
						SPACE[ele].IconW = icon_size
						SPACE[ele].IconH = icon_size
						SPACE[ele].IconX = DB.POSI_X
						SPACE[ele].IconY = DB.POSI_Y
						SPACE[ele].IconMaterial = etab[3]
					else
						SPACE[ele].BackgroundW = DB.SIZE_W
						SPACE[ele].BackgroundH = DB.SIZE_H
						SPACE[ele].BackgroundX = DB.POSI_X
						SPACE[ele].BackgroundY = DB.POSI_Y
					end

					SPACE[ele].BarW = SPACE[ele].BackgroundW - 2 * BR
					SPACE[ele].BarH = SPACE[ele].BackgroundH - 2 * BR
					SPACE[ele].BarX = SPACE[ele].BackgroundX + BR
					SPACE[ele].BarY = SPACE[ele].BackgroundY + BR
					SPACE[ele].BarColor = DB.BA
					if etab[5] == nil then
						if SPACE[ele].ax == 0 then
							ax = 0
						elseif SPACE[ele].ax == 1 then
							ax = SPACE[ele].BackgroundW / 2
						elseif SPACE[ele].ax == 2 then
							ax = SPACE[ele].BackgroundW
						end

						if SPACE[ele].ay == 0 then
							ay = 0
							SPACE[ele].ay = 3
						elseif SPACE[ele].ay == 1 then
							ay = SPACE[ele].BackgroundH * 0.5
						elseif SPACE[ele].ay == 2 then
							ay = SPACE[ele].BackgroundH
							SPACE[ele].ay = 4
						end

						SPACE[ele].XFontCenter = SPACE[ele].BackgroundX + ax
						SPACE[ele].YFontCenter = SPACE[ele].BackgroundY + ay
						SPACE[ele].fs = math.Clamp(DB.SIZE_H * 0.8, 4, 72)
						SPACE[ele].fs = math.Round(SPACE[ele].fs, 0)
						SPACE[ele].fs = lply:HudValue(ele, "TS")
						SPACE[ele].font = "Y_" .. SPACE[ele].fs .. "_500"
					elseif etab[5] == 2 then
						--
						if SPACE[ele].ax == 0 then
							ax = 0
						elseif SPACE[ele].ax == 1 then
							ax = SPACE[ele].w / 2
						elseif SPACE[ele].ax == 2 then
							ax = SPACE[ele].w
						end

						if SPACE[ele].ay == 0 then
							ay = 0
							SPACE[ele].ay = 3
						elseif SPACE[ele].ay == 1 then
							ay = SPACE[ele].h * 0.5
						elseif SPACE[ele].ay == 2 then
							ay = SPACE[ele].h
							SPACE[ele].ay = 4
						end

						SPACE[ele].XFontCenter = SPACE[ele].x + ax
						SPACE[ele].YFontCenter = SPACE[ele].y + ay
						SPACE[ele].fs = math.Clamp(DB.SIZE_H * 0.8, 4, 72)
						SPACE[ele].fs = math.Round(SPACE[ele].fs, 0)
						SPACE[ele].fs = lply:HudValue(ele, "TS")
						SPACE[ele].font = "Y_" .. SPACE[ele].fs .. "_500"
					end
				end
			elseif table.Count(SPACE) > 0 and lply:Alive() then
				-- DRAW HUD
				for ele, etab in pairs(ELES) do
					if SPACE[ele] ~= nil then
						local c = tonumber(etab[1])
						local m = tonumber(etab[2])
						local Visible = SPACE[ele].Visible
						if Visible and c ~= nil and lply:HudElementVisible(ele) then
							local Alpha = lply:HudElementAlpha(ele, 160)
							local text = etab[4] or c
							SPACE[ele].newc = 1
							if etab[4] == nil and m ~= nil then
								text = text .. "/" .. m
							end

							if m ~= nil then
								SPACE[ele].newc = c / m
							end

							SPACE[ele].oldc = SPACE[ele].oldc or 0
							if SPACE[ele].newc == 0 then
								SPACE[ele].oldc = 0
							end

							SPACE[ele].oldc = Lerp(10 * FrameTime(), SPACE[ele].oldc, SPACE[ele].newc)
							local w = SPACE[ele].w
							local h = SPACE[ele].h
							local x = SPACE[ele].x
							local y = SPACE[ele].y
							--local WCenter = SPACE[ele].WCenter
							--local HCenter = SPACE[ele].HCenter
							local BackgroundW = SPACE[ele].BackgroundW
							local BackgroundH = SPACE[ele].BackgroundH
							local BackgroundX = SPACE[ele].BackgroundX
							local BackgroundY = SPACE[ele].BackgroundY
							local AX = SPACE[ele].ax
							local AY = SPACE[ele].ay
							local XFontCenter = SPACE[ele].XFontCenter
							local YFontCenter = SPACE[ele].YFontCenter
							local font = SPACE[ele].font
							local BarColor = SPACE[ele].BarColor
							if etab[5] == nil then
								local BarW = SPACE[ele].BarW
								local BarH = SPACE[ele].BarH
								local BarX = SPACE[ele].BarX
								local BarY = SPACE[ele].BarY
								local IconW = SPACE[ele].IconW
								local IconH = SPACE[ele].IconH
								local IconX = SPACE[ele].IconX
								local IconY = SPACE[ele].IconY
								local IconMaterial = SPACE[ele].IconMaterial
								-- Background
								draw.RoundedBox(h / 4, BackgroundX, BackgroundY, BackgroundW, BackgroundH, Color(0, 0, 0, 160))
								-- BAR
								draw.RoundedBox(BarH / 4, BarX, BarY, BarW, BarH, Color(BarColor.r, BarColor.g, BarColor.b, 30))
								draw.RoundedBox(BarH / 4, BarX, BarY, BarW * SPACE[ele].oldc, BarH, Color(BarColor.r, BarColor.g, BarColor.b, 180))
								-- ICON
								if etab[3] ~= nil and IconMaterial ~= nil then
									surface.SetDrawColor(BarColor.r, BarColor.g, BarColor.b, 180)
									surface.SetMaterial(IconMaterial)
									surface.DrawTexturedRect(IconX, IconY, IconW, IconH)
								end

								-- TEXT
								draw.SimpleText(text, font, XFontCenter, YFontCenter, Color(255, 255, 255, 255), AX, AY)
							elseif etab[5] == 1 then
								draw.RoundedBox(6, x, y, w, h, Color(0, 0, 0, Alpha))
							elseif etab[5] == 2 then
								draw.SimpleText(text, font, XFontCenter, YFontCenter, Color(255, 255, 255, 255), AX, AY)
							elseif etab[5] == 3 then
								draw.RoundedBox(0, x, y, w, h, Color(BarColor.r, BarColor.g, BarColor.b, BarColor.a))
							end
						end
					else
						SPACE["version"] = 0
					end
				end

				HUDSimpleCompass()
			end
		end
	end
end

hook.Add("HUDPaint", "yrp_hud_design_Space", YRPHUDSpace)
