--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local icons = {}
icons["RA"] = "64_radiation"
icons["HP"] = "64_heart"
icons["AR"] = "64_shield-alt"
icons["MO"] = "64_money-bill"
icons["SA"] = "64_money-bill-alt"
icons["ST"] = "64_running"
icons["HU"] = "64_hamburger"
icons["TH"] = "64_glass-cheers"
icons["AL"] = "64_wine-bottle"
icons["CA"] = "64_magic"
icons["AB"] = "64_tint"
icons["BA"] = "64_battery-full"
icons["ID"] = "64_address-card"
icons["CR"] = "64_clock"
icons["CC"] = "64_clock"
icons["RO"] = "64_user-graduate"
icons["NA"] = "64_user"
icons["PE"] = "64_window-restore"
icons["NE"] = "wifi"
icons["XP"] = "64_atom"
icons["WP"] = "bullet"
icons["WS"] = "bullet_secondary"
local function DrawThinCompass(px, py, sw, sh)
	local lply = LocalPlayer()
	if IsValid(lply) then
		local dir = lply:CoordAngle()
		for i = 0, 24 - 1 do
			local ang = i * 15
			local dif = math.AngleDifference(ang, dir)
			local ndist = 20
			local offang = (ndist * 14) / 3
			if math.abs(dif) < offang then
				local alpha = math.Clamp(0.8 - (math.abs(dif) / offang), 0, 1) * 255
				local pos = -dif / 15 * sw / 10
				local text = ang
				local font = "Y_16_500"
				local dfont = "Y_18_500"
				local white = Color(200, 200, 200, alpha)
				if YRP:GetDesignIcon("keyboard_arrow_down") then
					surface.SetDrawColor(100, 100, 255)
					surface.SetMaterial(YRP:GetDesignIcon("keyboard_arrow_down"))
					surface.DrawTexturedRect(ScrW() / 2 - 24 / 2, py - 6, 24, 24)
				end

				if ang == 0 then
					direction = YRP:trans("LID_north_short")
					surface.SetDrawColor(100, 100, 255, alpha)
				elseif ang == 180 then
					direction = YRP:trans("LID_south_short")
				elseif ang == 90 then
					direction = YRP:trans("LID_east_short")
				elseif ang == 270 then
					direction = YRP:trans("LID_west_short")
				elseif ang == 45 then
					direction = YRP:trans("LID_north_short") .. YRP:trans("LID_east_short")
				elseif ang == 135 then
					direction = YRP:trans("LID_south_short") .. YRP:trans("LID_east_short")
				elseif ang == 225 then
					direction = YRP:trans("LID_south_short") .. YRP:trans("LID_west_short")
				elseif ang == 315 then
					direction = YRP:trans("LID_north_short") .. YRP:trans("LID_west_short")
				else
					direction = ""
				end

				if ang ~= 0 then
					surface.SetDrawColor(white)
				end

				surface.DrawRect(px + sw / 2 - 25 - pos, py + 38, 50, 3)
				draw.DrawText(text, font, px + sw / 2 - pos, py + 53, Color(255, 255, 255, 250), TEXT_ALIGN_CENTER)
				draw.DrawText(direction, dfont, px + sw / 2 - pos, py + 10, Color(255, 255, 255, 250), TEXT_ALIGN_CENTER)
			end
		end
	end
end

local animationTime = 4
local HUD_THIN = {}
function YRPDrawThin(tab)
	local lply = LocalPlayer()
	local name = tab.name
	HUD_THIN[name] = HUD_THIN[name] or {}
	if tab.cur and tab.max then
		tab.cur = math.Clamp(tab.cur, 0, tab.max)
	elseif tab.cur and tab.cur < 0 then
		tab.cur = 0
	end

	if HUD_THIN[name].oldcur and tab.max and HUD_THIN[name].oldcur > tab.max then
		HUD_THIN[name].oldcur = tab.max
	end

	if GetGlobalYRPInt("YRPHUDVersion", -1) ~= HUD_THIN[name]["hud_version"] then
		HUD_THIN[name]["hud_version"] = GetGlobalYRPInt("YRPHUDVersion", -1)
		HUD_THIN[name].x = tab.x or lply:HudValue(name, "POSI_X")
		HUD_THIN[name].y = tab.y or lply:HudValue(name, "POSI_Y")
		HUD_THIN[name].w = tab.w or lply:HudValue(name, "SIZE_W")
		HUD_THIN[name].h = tab.h or lply:HudValue(name, "SIZE_H")
		HUD_THIN[name].sicon = lply:HudValue(name, "ICON")
		HUD_THIN[name].stext = lply:HudValue(name, "TEXT")
		HUD_THIN[name].sback = lply:HudValue(name, "BACK")
		HUD_THIN[name].colorbg = lply:HudValue(name, "BG")
		HUD_THIN[name].colorbar = lply:HudValue(name, "BA")
		HUD_THIN[name].colortext = lply:HudValue(name, "TE")
		HUD_THIN[name].iconmat = icons[name]
		HUD_THIN[name].ix = HUD_THIN[name].x + HUD_THIN[name].h * 0.2
		HUD_THIN[name].iy = HUD_THIN[name].y + HUD_THIN[name].h * 0.2
		HUD_THIN[name].ih = HUD_THIN[name].h * 0.6
		if tab.valuetext then
			HUD_THIN[name].ts = math.Clamp(math.Round(HUD_THIN[name].h * 0.6, 0), 6, 100)
		else
			HUD_THIN[name].ts = math.Clamp(math.Round(HUD_THIN[name].h * 0.5, 0), 6, 100)
		end

		HUD_THIN[name].font = "Y_" .. HUD_THIN[name].ts .. "_500"
		HUD_THIN[name].text = tab.text
		if HUD_THIN[name].iconmat and HUD_THIN[name].sicon then
			HUD_THIN[name].tx = HUD_THIN[name].x + HUD_THIN[name].h
			HUD_THIN[name].ty = HUD_THIN[name].y + HUD_THIN[name].h * 0.2
		elseif not HUD_THIN[name].sicon then
			HUD_THIN[name].tx = HUD_THIN[name].x + HUD_THIN[name].h * 0.2
			HUD_THIN[name].ty = HUD_THIN[name].y + HUD_THIN[name].h * 0.2
		else
			HUD_THIN[name].tx = HUD_THIN[name].x + HUD_THIN[name].w / 2
			HUD_THIN[name].ty = HUD_THIN[name].y + HUD_THIN[name].h / 2
		end

		if HUD_THIN[name].text then
			HUD_THIN[name].tvx = HUD_THIN[name].x + HUD_THIN[name].w - HUD_THIN[name].h * 0.2
			HUD_THIN[name].tvy = HUD_THIN[name].y + HUD_THIN[name].h * 0.2
			HUD_THIN[name].tvax = TEXT_ALIGN_RIGHT
			HUD_THIN[name].tvay = TEXT_ALIGN_TOP
		else
			HUD_THIN[name].tvx = HUD_THIN[name].x + HUD_THIN[name].w / 2
			HUD_THIN[name].tvy = HUD_THIN[name].y + HUD_THIN[name].h / 2
			HUD_THIN[name].tvax = TEXT_ALIGN_CENTER
			HUD_THIN[name].tvay = TEXT_ALIGN_CENTER
		end

		if HUD_THIN[name].sicon then
			HUD_THIN[name].vx = HUD_THIN[name].x + HUD_THIN[name].h
			HUD_THIN[name].vy = HUD_THIN[name].y + HUD_THIN[name].h * 0.8
			HUD_THIN[name].vw = HUD_THIN[name].w - HUD_THIN[name].h * 1.2
			HUD_THIN[name].vh = HUD_THIN[name].h * 0.1
		else
			HUD_THIN[name].vx = HUD_THIN[name].x + HUD_THIN[name].h * 0.2
			HUD_THIN[name].vy = HUD_THIN[name].y + HUD_THIN[name].h * 0.8
			HUD_THIN[name].vw = HUD_THIN[name].w - HUD_THIN[name].h * 0.4
			HUD_THIN[name].vh = HUD_THIN[name].h * 0.1
		end

		HUD_THIN[name].oldcur = 0
		HUD_THIN[name].loaded = true
	end

	if HUD_THIN[name].loaded and lply:HudElementVisible(name) then
		if tab.cur then
			HUD_THIN[name].oldcur = Lerp(FrameTime() * animationTime, HUD_THIN[name].oldcur, tab.cur) -- animation
		end

		-- Background
		if HUD_THIN[name].sback then
			draw.RoundedBox(0, HUDMOTIONX(HUD_THIN[name].x), HUDMOTIONY(HUD_THIN[name].y), HUD_THIN[name].w, HUD_THIN[name].h, HUD_THIN[name].colorbg)
		end

		-- Icon
		if HUD_THIN[name].iconmat and HUD_THIN[name].sicon then
			local iconmat = YRP:GetDesignIcon(HUD_THIN[name].iconmat)
			if iconmat then
				surface.SetDrawColor(Color(255, 255, 255, 255))
				surface.SetMaterial(iconmat)
				surface.DrawTexturedRect(HUDMOTIONX(HUD_THIN[name].ix), HUDMOTIONY(HUD_THIN[name].iy), HUD_THIN[name].ih, HUD_THIN[name].ih)
			end
		end

		-- Text
		if HUD_THIN[name].stext and HUD_THIN[name].text then
			if HUD_THIN[name].iconmat and HUD_THIN[name].sicon then
				draw.SimpleText(YRP:trans(HUD_THIN[name].text), HUD_THIN[name].font, HUDMOTIONX(HUD_THIN[name].tx), HUDMOTIONY(HUD_THIN[name].ty), HUD_THIN[name].colortext, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			else
				draw.SimpleText(YRP:trans(HUD_THIN[name].text), HUD_THIN[name].font, HUDMOTIONX(HUD_THIN[name].tx), HUDMOTIONY(HUD_THIN[name].ty), HUD_THIN[name].colortext, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			end
		end

		-- Value
		if tab.valuetext then
			draw.SimpleText(tab.valuetext, HUD_THIN[name].font, HUDMOTIONX(HUD_THIN[name].tvx), HUDMOTIONY(HUD_THIN[name].tvy), HUD_THIN[name].colortext, HUD_THIN[name].tvax, HUD_THIN[name].tvay)
		elseif tab.cur then
			local cur = tab.cur
			if lply:HudValue(name, "PERC") then
				--
				cur = math.Round(tab.cur / tab.max * 100, 1) .. "%"
			end

			draw.SimpleText(cur, HUD_THIN[name].font, HUDMOTIONX(HUD_THIN[name].tvx), HUDMOTIONY(HUD_THIN[name].tvy), HUD_THIN[name].colortext, HUD_THIN[name].tvax, HUD_THIN[name].tvay)
		end

		-- BAR
		if tab.cur and tab.max then
			draw.RoundedBox(0, HUDMOTIONX(HUD_THIN[name].vx), HUDMOTIONY(HUD_THIN[name].vy), HUD_THIN[name].vw, 2, Color(0, 0, 0, 100))
			draw.RoundedBox(0, HUDMOTIONX(HUD_THIN[name].vx), HUDMOTIONY(HUD_THIN[name].vy), HUD_THIN[name].vw * HUD_THIN[name].oldcur / tab.max, 2, HUD_THIN[name].colorbar)
		end
	end
end

function YRPHUDThin()
	local lply = LocalPlayer()
	if YRP and YRP.GetDesignIcon and lply:LoadedGamemode() and YRPIsScoreboardVisible and not YRPIsScoreboardVisible() and GetGlobalYRPBool("bool_yrp_hud", false) and lply:GetHudDesignName() == "Thin" then
		if lply:HudElementVisible("COM") then
			DrawThinCompass(lply:HudValue("COM", "POSI_X"), lply:HudValue("COM", "POSI_Y"), lply:HudValue("COM", "SIZE_W"), lply:HudValue("COM", "SIZE_H"))
		end

		for i = 1, 10 do
			local BOX = {}
			BOX.name = "BOX" .. i
			BOX.valuetext = lply:HudValue(BOX.name, "CTEX")
			YRPDrawThin(BOX)
		end

		local HP = {}
		HP.name = "HP"
		HP.text = "LID_health"
		HP.cur = lply:Health()
		HP.max = lply:GetMaxHealth()
		YRPDrawThin(HP)
		local AR = {}
		AR.name = "AR"
		AR.text = "LID_armor"
		AR.cur = lply:Armor()
		AR.max = lply:GetMaxArmor()
		YRPDrawThin(AR)
		local HU = {}
		HU.name = "HU"
		HU.text = "LID_hunger"
		HU.cur = lply:Hunger()
		HU.max = lply:GetMaxHunger()
		YRPDrawThin(HU)
		local TH = {}
		TH.name = "TH"
		TH.text = "LID_thirst"
		TH.cur = lply:Thirst()
		TH.max = lply:GetMaxThirst()
		YRPDrawThin(TH)
		local ST = {}
		ST.name = "ST"
		ST.text = "LID_stamina"
		ST.cur = lply:Stamina()
		ST.max = lply:GetMaxStamina()
		YRPDrawThin(ST)
		local PE = {}
		PE.name = "PE"
		PE.text = "LID_fps"
		PE.cur = math.Clamp(GetFPS(), 0, 144)
		PE.max = 144
		PE.ignorepercent = true
		YRPDrawThin(PE)
		local NE = {}
		NE.name = "NE"
		NE.text = "LID_ping"
		NE.cur = math.Clamp(lply:Ping(), 0, 200)
		NE.max = 200
		NE.ignorepercent = true
		YRPDrawThin(NE)
		local XP = {}
		XP.name = "XP"
		XP.text = "LID_xp"
		XP.cur = lply:XP()
		XP.max = lply:GetMaxXP()
		XP.valuetext = "(" .. lply:Level() .. ") " .. lply:XP() .. "/" .. lply:MaxXP() .. " ( " .. math.Round(lply:XP() / lply:MaxXP() * 100, 1) .. "%)"
		YRPDrawThin(XP)
		local BA = {}
		BA.name = "BA"
		BA.text = "LID_battery"
		BA.cur = system.BatteryPower()
		BA.max = 100
		YRPDrawThin(BA)
		local CA = {}
		CA.name = "CA"
		CA.text = lply:GetCastName()
		CA.cur = lply:CastTimeCurrent()
		CA.max = lply:CastTimeMax()
		CA.valuetext = math.Round(lply:CastTimeCurrent() / lply:CastTimeMax() * 100, 1) .. "%"
		YRPDrawThin(CA)
		local RA = {}
		RA.name = "RA"
		RA.text = "LID_radiation"
		RA.cur = lply:Radiation()
		RA.max = lply:GetMaxRadiation()
		YRPDrawThin(RA)
		local weapon = lply:GetActiveWeapon()
		if IsValid(weapon) then
			local clip1 = weapon:Clip1()
			local clip1max = weapon:GetMaxClip1()
			local ammo1 = lply:GetAmmoCount(weapon:GetPrimaryAmmoType())
			local clip2 = weapon:Clip2()
			local clip2max = weapon:GetMaxClip2()
			local ammo2 = lply:GetAmmoCount(weapon:GetSecondaryAmmoType())
			local wpammo = ""
			if clip1 >= 0 and clip1max >= 0 then
				wpammo = wpammo .. clip1 .. "/" .. clip1max
			end

			if ammo1 >= 0 then
				if not strEmpty(wpammo) then
					wpammo = wpammo .. " | " .. ammo1
				else
					wpammo = wpammo .. ammo1
				end
			end

			local WP = {}
			WP.name = "WP"
			WP.text = "LID_ammo"
			WP.cur = clip1
			WP.max = clip1max
			WP.valuetext = wpammo
			YRPDrawThin(WP)
			local wsammo = ""
			if clip2 >= 0 and clip2max >= 0 then
				wsammo = wsammo .. clip2 .. "/" .. clip2max
			end

			if ammo2 >= 0 then
				if not strEmpty(wsammo) then
					wsammo = wsammo .. " | " .. ammo2
				else
					wsammo = wsammo .. ammo2
				end
			end

			local WS = {}
			WS.name = "WS"
			WS.text = "LID_ammo"
			WS.cur = clip2
			WS.max = clip2
			WS.valuetext = wsammo
			YRPDrawThin(WS)
		end

		local NA = {}
		NA.name = "NA"
		NA.text = "LID_name"
		NA.valuetext = lply:RPName()
		YRPDrawThin(NA)
		local RO = {}
		RO.name = "RO"
		RO.text = "LID_role"
		RO.valuetext = lply:GetRoleName()
		YRPDrawThin(RO)
		local ID = {}
		ID.name = "ID"
		ID.text = "LID_id"
		ID.valuetext = lply:IDCardID()
		YRPDrawThin(ID)
		local SN = {}
		SN.name = "SN"
		SN.valuetext = YRPGetHostName()
		YRPDrawThin(SN)
		local MO = {}
		MO.name = "MO"
		MO.text = "LID_money"
		MO.valuetext = lply:FormattedMoney()
		YRPDrawThin(MO)
		local SA = {}
		SA.name = "SA"
		SA.text = "LID_salary"
		SA.valuetext = "+" .. lply:FormattedSalary(1)
		YRPDrawThin(SA)
		local CON = {}
		CON.name = "CON"
		CON.valuetext = lply:Condition()
		YRPDrawThin(CON)
		if lply:GetActiveWeapon() and lply:GetActiveWeapon().GetPrintName then
			local WN = {}
			WN.name = "WN"
			WN.valuetext = lply:GetActiveWeapon():GetPrintName()
			YRPDrawThin(WN)
		end

		local CR = {}
		CR.name = "CR"
		CR.text = "LID_clock"
		CR.cur = os.date("%H", os.time()) * 60 * 60 + os.date("%M", os.time()) * 60
		CR.max = 60 * 60 * 24
		CR.valuetext = os.date("%H:%M", os.time())
		YRPDrawThin(CR)
		local CC = {}
		CC.name = "CC"
		CC.text = "LID_playtime"
		CC.valuetext = lply:YRPFormattedCharPlayTime()
		YRPDrawThin(CC)
		local LO = {}
		LO.name = "LO"
		LO.valuetext = "[" .. GTS("lockdown") .. "] " .. lply:LockdownText()
		YRPDrawThin(LO)
	end
end

hook.Add("HUDPaint", "yrp_hud_design_Thin", YRPHUDThin)
