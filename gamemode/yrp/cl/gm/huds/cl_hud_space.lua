--Copyright (C) 2017-2019 Arno Zura (https: /  / www.gnu.org / licenses / gpl.txt)

local HP = "vgui/material/icon_favorite.png"
local AR = "vgui/material/icon_security.png"
local ST = "vgui/material/icon_flash.png"
local BA = "vgui/material/icon_battery.png"
local HU = "vgui/material/icon_restaurant.png"
local TH = "vgui/material/icon_drink.png"
local XP = "vgui/material/icon_star.png"
local MO = "icon16/money.png"
local SA = "icon16/money_add.png"
local CA = "vgui/material/icon_timer.png"
local AB = "icon16/wand.png"

local SPACE = {}
local ELES = {}
function HUDSpace()
	local lply = LocalPlayer()

	if GetGlobalDBool("bool_yrp_hud", false) and lply:GetDString("string_hud_design") == "Space" then
		ELES["HP"] = {
			lply:Health(),
			lply:GetMaxHealth(),
			HP
		}
		ELES["AR"] = {
			lply:Armor(),
			lply:GetMaxArmor(),
			AR
		}

		ELES["AB"] = {
			lply:Ability(),
			lply:GetMaxAbility(),
			AB,
			lply:Ability() / lply:GetMaxAbility() * 100 .. "%",
		}

		ELES["ST"] = {
			lply:Stamina(),
			lply:GetMaxStamina(),
			ST
		}
		ELES["HU"] = {
			lply:Hunger(),
			lply:GetMaxHunger(),
			HU
		}
		ELES["TH"] = {
			lply:Thirst(),
			lply:GetMaxThirst(),
			TH
		}

		local weapon = lply:GetActiveWeapon()
		if weapon:IsValid() then
			local clip1 = weapon:Clip1()
			local clip1max = weapon:GetMaxClip1()
			local ammo1 = lply:GetAmmoCount(weapon:GetPrimaryAmmoType())

			local clip2 = weapon:Clip2()
			local clip2max = weapon:GetMaxClip2()
			local ammo2 = lply:GetAmmoCount(weapon:GetSecondaryAmmoType())
			ELES["WP"] = {
				clip1,
				clip1max,
				nil,
				clip1 .. "/" .. clip1max .. " | " .. ammo1,
			}
			local a2 = ammo2
			if clip2max > 0 then
				--a2 = clip2 .. "/" .. clip2max .. " | " .. a2
			end
			ELES["WS"] = {
				clip2,
				clip2max,
				nil,
				a2,
			}

			ELES["WN"] = {
				1,
				1,
				nil,
				weapon:GetPrintName()
			}
		end

		ELES["MO"] = {
			lply:Money(),
			nil,
			MO,
			lply:FormattedMoneyRounded()
		}
		ELES["SA"] = {
			lply:Salary(),
			nil,
			SA,
			lply:FormattedSalaryRounded()
		}

		ELES["CA"] = {
			lply:CastTimeCurrent(),
			lply:CastTimeMax(),
			CA,
			lply:GetCastName()
		}

		ELES["BA"] = {
			system.BatteryPower(),
			100,
			BA,
			system.BatteryPower() .. "%"
		}

		local t = {}
		t["LEVEL"] = lply:Level()
		ELES["XP"] = {
			lply:XP(),
			lply:GetMaxXP(),
			XP,
			YRP.lang_string("LID_levelx", t) .. " (" .. lply:XP() .. "/" .. lply:GetMaxXP() .. ")"
		}

		ELES["CH"] = {
			0,
			nil,
			nil,
			nil,
			1
		}

		ELES["CR"] = {
			0,
			nil,
			nil,
			os.date("%H:%M" , os.time()),
			2
		}
		ELES["PE"] = {
			0,
			nil,
			nil,
			YRP.lang_string("LID_fps") .. ": " .. GetFPS(),
			2
		}
		ELES["NE"] = {
			0,
			nil,
			nil,
			YRP.lang_string("LID_ping") .. ": " .. lply:Ping(),
			2
		}

		ELES["SN"] = {
			0,
			nil,
			nil,
			SQL_STR_OUT(GetGlobalDString("text_server_name", "SERVERNAME")),
			2
		}

		ELES["LO"] = {
			0,
			nil,
			nil,
			"[" .. GTS("lockdown") .. "] " .. lply:LockdownText(),
			2
		}

		ELES["RO"] = {
			0,
			nil,
			nil,
			lply:GetRoleName(),
			2
		}

		ELES["NA"] = {
			0,
			nil,
			nil,
			lply:RPName(),
			2
		}

		ELES["ID"] = {
			0,
			nil,
			nil,
			lply:GetDString("idcardid", ""),
			2
		}

		ELES["CON"] = {
			0,
			nil,
			nil,
			lply:Condition()
		}

		ELES["FR"] = {
			0,
			nil,
			nil,
			YRP.lang_string("LID_frequency") .. ": " .. tostring(lply:GetDFloat("voice_channel", 0.1, 1)),
			2
		}

		if lply:GetDInt("hud_version", 0) != SPACE["version"] then
			-- LOAD VARIABLES
			SPACE["version"] = lply:GetDInt("hud_version", 0)
			for ele, etab in pairs(ELES) do
				local DB = lply:HudElement(ele)

				local icon_size = 0
				if etab[3] != nil then
					icon_size = DB.SIZE_H
				end
				local BR = YRP.ctr(10)
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

				if etab[3] != nil then
					SPACE[ele].BackgroundW = DB.SIZE_W - icon_size - BR
					SPACE[ele].BackgroundH = DB.SIZE_H
					SPACE[ele].BackgroundX = DB.POSI_X + icon_size + BR
					SPACE[ele].BackgroundY = DB.POSI_Y

					SPACE[ele].IconW = icon_size
					SPACE[ele].IconH = icon_size
					SPACE[ele].IconX = DB.POSI_X
					SPACE[ele].IconY = DB.POSI_Y
					SPACE[ele].IconMaterial = Material(etab[3])
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
						ay = SPACE[ele].BackgroundH * 0.46
					elseif SPACE[ele].ay == 2 then
						ay = SPACE[ele].BackgroundH
						SPACE[ele].ay = 4
					end
					SPACE[ele].XFontCenter = SPACE[ele].BackgroundX + ax
					SPACE[ele].YFontCenter = SPACE[ele].BackgroundY + ay
					SPACE[ele].fs = math.Clamp(DB.SIZE_H * 0.8, 4, 72)
					SPACE[ele].fs = math.Round(SPACE[ele].fs, 0)
					SPACE[ele].font = "Y_" .. SPACE[ele].fs .. "_600"
				elseif etab[5] == 1 then
					--
				elseif etab[5] == 2 then
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
						ay = SPACE[ele].h * 0.46
					elseif SPACE[ele].ay == 2 then
						ay = SPACE[ele].h
						SPACE[ele].ay = 4
					end
					SPACE[ele].XFontCenter = SPACE[ele].x + ax
					SPACE[ele].YFontCenter = SPACE[ele].y + ay
					SPACE[ele].fs = math.Clamp(DB.SIZE_H * 0.8, 4, 72)
					SPACE[ele].fs = math.Round(SPACE[ele].fs, 0)
					SPACE[ele].font = "Y_" .. SPACE[ele].fs .. "_600"
				end
			end
		elseif table.Count(SPACE) > 0 then
			-- DRAW HUD
			for ele, etab in pairs(ELES) do
				if SPACE[ele] != nil then
					local c = tonumber(etab[1])
					local m = tonumber(etab[2])

					local Visible = SPACE[ele].Visible
					if Visible and c != nil and lply:HudElementVisible(ele) then
						local Alpha = lply:HudElementAlpha(ele, 160)
						local text = etab[4] or c
						SPACE[ele].newc = 1
						if etab[4] == nil and m != nil then
							text = text .. "/" .. m
						end
						if m != nil then
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

						if etab[5] == nil then
							local BarW = SPACE[ele].BarW
							local BarH = SPACE[ele].BarH
							local BarX = SPACE[ele].BarX
							local BarY = SPACE[ele].BarY
							local BarColor = SPACE[ele].BarColor

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
							if etab[3] != nil then
								if IconMaterial != nil then
									surface.SetDrawColor(BarColor.r, BarColor.g, BarColor.b, 180)
									surface.SetMaterial(IconMaterial)
									surface.DrawTexturedRect(IconX, IconY, IconW, IconH)
								end
							end

							-- TEXT
							draw.SimpleText(text, font, XFontCenter, YFontCenter, Color(255,255,255,255), AX, AY)
						elseif etab[5] == 1 then
							draw.RoundedBox(6, x, y, w, h, Color(0, 0, 0, 160 * Alpha))
						elseif etab[5] == 2 then
							draw.SimpleText(text, font, XFontCenter, YFontCenter, Color(255,255,255,255), AX, AY)
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
hook.Add("HUDPaint", "yrp_hud_design_Space", HUDSpace)
