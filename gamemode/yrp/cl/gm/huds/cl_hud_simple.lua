--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

function fake_true()
	return true
end

local Simple = {}
function HUDSimpleBG(tab)
	local lply = LocalPlayer()
	if lply:GetHudBool(tab.element, "VISI") and lply:GetHudBool(tab.element, "BACK") then
		tab.visiblefunc = tab.visiblefunc or fake_true
		if tab.visiblefunc() then
			Simple[tab.element] = Simple[tab.element] or {}
			Simple[tab.element]["background"] = Simple[tab.element]["background"] or {}

			if lply:GetNWInt("hud_version", 0) != Simple[tab.element]["background"]["version"] then
				Simple[tab.element]["background"]["version"] = lply:GetNWInt("hud_version", 0)

				local w = lply:GetHudValue(tab.element, "SIZE_W")
				local h = lply:GetHudValue(tab.element, "SIZE_H")
				local x = lply:GetHudValue(tab.element, "POSI_X")
				local y = lply:GetHudValue(tab.element, "POSI_Y")

				Simple[tab.element]["background"].w = w
				Simple[tab.element]["background"].h = h
				Simple[tab.element]["background"].x = x
				Simple[tab.element]["background"].y = y

				Simple[tab.element]["background"].r = 0
				if lply:GetHudBool(tab.element, "ROUN") then
					Simple[tab.element]["background"].r = tab.r or Simple[tab.element]["background"].h / 2
				end

				Simple[tab.element]["background"].color = lply:GetHudColor(tab.element, "BG")
			else
				HudBox(Simple[tab.element]["background"])
			end
		end
	end
end

function HUDSimpleBAR(tab)
	local lply = LocalPlayer()
	if lply:GetHudBool(tab.element, "VISI") then
		Simple[tab.element] = Simple[tab.element] or {}
		Simple[tab.element]["bar"] = Simple[tab.element]["bar"] or {}
		Simple[tab.element]["icon"] = Simple[tab.element]["icon"] or {}
		Simple[tab.element]["text"] = Simple[tab.element]["text"] or {}

		if lply:GetNWInt("hud_version", 0) != Simple[tab.element]["bar"]["version"] then
			Simple[tab.element]["bar"]["version"] = lply:GetNWInt("hud_version", 0)

			local w = lply:GetHudValue(tab.element, "SIZE_W")
			local h = lply:GetHudValue(tab.element, "SIZE_H")
			local x = lply:GetHudValue(tab.element, "POSI_X")
			local y = lply:GetHudValue(tab.element, "POSI_Y")

			Simple[tab.element]["bar"].fw = w
			Simple[tab.element]["bar"].fh = h
			Simple[tab.element]["bar"].fx = x
			Simple[tab.element]["bar"].fy = y

			Simple[tab.element]["bar"].w = w
			Simple[tab.element]["bar"].h = h
			Simple[tab.element]["bar"].x = x
			Simple[tab.element]["bar"].y = y

			Simple[tab.element]["bar"].r = 0
			if lply:GetHudBool(tab.element, "ROUN") then
				Simple[tab.element]["bar"].r = tab.r or Simple[tab.element]["bar"].h / 2
			end

			Simple[tab.element]["bar"].color = lply:GetHudColor(tab.element, "BA")

			Simple[tab.element]["text"].ax = lply:GetHudInt(tab.element, "AX")
			Simple[tab.element]["text"].ay = lply:GetHudInt(tab.element, "AY")
			local ax = Simple[tab.element]["text"].ax
			local ay = Simple[tab.element]["text"].ay
			if ay == 3 then
				ay = 0
			elseif ay == 4 then
				ay = 2
			end
			if lply:GetHudBool(tab.element, "ROUN") then
				Simple[tab.element]["text"].x = x + h/2 + (w - h) / 2 * ax
				Simple[tab.element]["text"].y = y + h/16 + (h - h/8) / 2 * ay
			else
				Simple[tab.element]["text"].x = x + h/16 + (w - h/8) / 2 * ax
				Simple[tab.element]["text"].y = y + h/16 + (h - h/8) / 2 * ay
			end
			Simple[tab.element]["text"].text = tab.element
			local fontsize = lply:GetHudInt(tab.element, "TS")
			if fontsize <= 0 then
				fontsize = 14
			end
			Simple[tab.element]["text"].font = "Roboto" .. fontsize
			Simple[tab.element]["text"].color = lply:GetHudColor(tab.element, "TE")
			Simple[tab.element]["text"].brcolor = lply:GetHudColor(tab.element, "TB")

			if Simple[tab.element]["bar"].fw > Simple[tab.element]["bar"].fh then
				Simple[tab.element]["icon"].w = Simple[tab.element]["bar"].fh * 0.6
				Simple[tab.element]["icon"].h = Simple[tab.element]["bar"].fh * 0.6
				Simple[tab.element]["icon"].x = Simple[tab.element]["bar"].x + Simple[tab.element]["bar"].fh * 0.2
				Simple[tab.element]["icon"].y = Simple[tab.element]["bar"].y + Simple[tab.element]["bar"].fh * 0.2
			else
				Simple[tab.element]["icon"].w = Simple[tab.element]["bar"].fw * 0.6
				Simple[tab.element]["icon"].h = Simple[tab.element]["bar"].fw * 0.6
				Simple[tab.element]["icon"].x = Simple[tab.element]["bar"].x + Simple[tab.element]["bar"].fw * 0.2
				Simple[tab.element]["icon"].y = Simple[tab.element]["bar"].y + Simple[tab.element]["bar"].fw * 0.2
			end
		else
			if Simple[tab.element]["bar"].fw > Simple[tab.element]["bar"].fh then
				Simple[tab.element]["bar"].h = Simple[tab.element]["bar"].fh
				Simple[tab.element]["bar"].w = Simple[tab.element]["bar"].fw / tab.max * tab.cur
			else
				Simple[tab.element]["bar"].h = Simple[tab.element]["bar"].fh / tab.max * tab.cur
				Simple[tab.element]["bar"].y = Simple[tab.element]["bar"].fy + Simple[tab.element]["bar"].fh - Simple[tab.element]["bar"].h
			end
			HudBox(Simple[tab.element]["bar"])

			if lply:GetHudBool(tab.element, "ICON") and tab.icon != nil then
				local ico = tab.icon
				YRP.DrawIcon(ico, Simple[tab.element]["icon"].w, Simple[tab.element]["icon"].h, Simple[tab.element]["icon"].x, Simple[tab.element]["icon"].y, Color(255, 255, 255))
			end

			Simple[tab.element]["text"].text = ""
			if tab.text != nil and lply:GetHudBool(tab.element, "TEXT") then
				Simple[tab.element]["text"].text = tab.text
			end
			if tab.percentage != nil and lply:GetHudBool(tab.element, "PERC") then
				Simple[tab.element]["text"].text = Simple[tab.element]["text"].text .. " " .. tab.percentage
			end
			if tab.tcolor != nil then
				Simple[tab.element]["text"].color = tab.tcolor
			end
			HudTextBr(Simple[tab.element]["text"])
		end
	end
end

function HUDSimpleBR(tab)
	local lply = LocalPlayer()
	if lply:GetHudBool(tab.element, "VISI") and lply:GetHudBool(tab.element, "BORD") then
		tab.visiblefunc = tab.visiblefunc or fake_true
		if lply:GetHudBool(tab.element, "VISI") and tab.visiblefunc() then
			Simple[tab.element] = Simple[tab.element] or {}
			Simple[tab.element]["border"] = Simple[tab.element]["border"] or {}

			if lply:GetNWInt("hud_version", 0) != Simple[tab.element]["border"]["version"] then
				Simple[tab.element]["border"]["version"] = lply:GetNWInt("hud_version", 0)

				local w = lply:GetHudValue(tab.element, "SIZE_W")
				local h = lply:GetHudValue(tab.element, "SIZE_H")
				local x = lply:GetHudValue(tab.element, "POSI_X")
				local y = lply:GetHudValue(tab.element, "POSI_Y")

				Simple[tab.element]["border"].r = 0

				Simple[tab.element]["border"].w = w
				Simple[tab.element]["border"].h = h
				Simple[tab.element]["border"].x = x
				Simple[tab.element]["border"].y = y

				Simple[tab.element]["border"].r = 0
				if lply:GetHudBool(tab.element, "ROUN") then
					Simple[tab.element]["border"].r = tab.r or Simple[tab.element]["border"].h / 2
				end

				Simple[tab.element]["border"].color = lply:GetHudColor(tab.element, "BR")
				Simple[tab.element]["border"].br = ctr(2)
			elseif lply:GetHudBool(tab.element, "ROUN") then
				HudBoxBrRounded(Simple[tab.element]["border"])
			else
				HudBoxBr(Simple[tab.element]["border"])
			end
		end
	end
end

function HUDSimpleCompass(tab)
	local lply = LocalPlayer()
	tab.visiblefunc = tab.visiblefunc or fake_true
	if lply:GetHudBool(tab.element, "VISI") and tab.visiblefunc() then
		Simple[tab.element] = Simple[tab.element] or {}
		Simple[tab.element]["needle"] = Simple[tab.element]["needle"] or {}
		Simple[tab.element]["degree"] = Simple[tab.element]["degree"] or {}
		Simple[tab.element]["north"] = Simple[tab.element]["north"] or {}
		Simple[tab.element]["south"] = Simple[tab.element]["south"] or {}
		Simple[tab.element]["east"] = Simple[tab.element]["east"] or {}
		Simple[tab.element]["west"] = Simple[tab.element]["west"] or {}

		if lply:GetNWInt("hud_version", 0) != Simple[tab.element]["degree"]["version"] then
			Simple[tab.element]["degree"]["version"] = lply:GetNWInt("hud_version", 0)

			local w = lply:GetHudValue(tab.element, "SIZE_W")
			local h = lply:GetHudValue(tab.element, "SIZE_H")
			local x = lply:GetHudValue(tab.element, "POSI_X")
			local y = lply:GetHudValue(tab.element, "POSI_Y")

			Simple[tab.element]["needle"].r = 0
			Simple[tab.element]["needle"].w = ctr(4)
			Simple[tab.element]["needle"].h = h / 4
			Simple[tab.element]["needle"].x = x + w / 2 - Simple[tab.element]["needle"].w / 2
			Simple[tab.element]["needle"].y = y + h - h / 4
			Simple[tab.element]["needle"].color = Color(255, 255, 255)

			local fontsize = lply:GetHudInt(tab.element, "TS")
			if fontsize <= 0 then
				fontsize = 8
			end

			local fontsizes = GetFontSizeTable()
			local fsid = 0
			for i, size in pairs(fontsizes) do
				if fontsize == size then
					fsid = i + 1
				end
			end
			local nextfontsize = fontsize
			if fontsizes[fsid + 1] != nil then
				nextfontsize = fontsizes[fsid + 1]
			elseif fontsizes[fsid] != nil then
				nextfontsize = fontsizes[fsid]
			end

			Simple[tab.element]["degree"].w = w
			Simple[tab.element]["degree"].h = h
			Simple[tab.element]["degree"].x = x + w / 2
			Simple[tab.element]["degree"].y = y + h * 0.30
			Simple[tab.element]["degree"].ax = 1
			Simple[tab.element]["degree"].ay = 1
			Simple[tab.element]["degree"].font = "Roboto" .. fontsize
			Simple[tab.element]["degree"].color = lply:GetHudColor(tab.element, "TE")
			Simple[tab.element]["degree"].brcolor = lply:GetHudColor(tab.element, "TB")

			Simple[tab.element]["north"].w = w
			Simple[tab.element]["north"].h = h
			Simple[tab.element]["north"].x = x + w / 2
			Simple[tab.element]["north"].y = y + h * 0.70
			Simple[tab.element]["north"].ax = 1
			Simple[tab.element]["north"].ay = 1
			Simple[tab.element]["north"].font = "Roboto" .. nextfontsize
			Simple[tab.element]["north"].color = Color(0, 255, 0)
			Simple[tab.element]["north"].brcolor = lply:GetHudColor(tab.element, "TB")
			Simple[tab.element]["north"].text = YRP.lang_string("LID_north_short")

			Simple[tab.element]["south"].w = w
			Simple[tab.element]["south"].h = h
			Simple[tab.element]["south"].x = x + w / 2
			Simple[tab.element]["south"].y = y + h * 0.70
			Simple[tab.element]["south"].ax = 1
			Simple[tab.element]["south"].ay = 1
			Simple[tab.element]["south"].font = "Roboto" .. fontsize
			Simple[tab.element]["south"].color = lply:GetHudColor(tab.element, "TE")
			Simple[tab.element]["south"].brcolor = lply:GetHudColor(tab.element, "TB")
			Simple[tab.element]["south"].text = YRP.lang_string("LID_south_short")

			Simple[tab.element]["east"].w = w
			Simple[tab.element]["east"].h = h
			Simple[tab.element]["east"].x = x + w / 2
			Simple[tab.element]["east"].y = y + h * 0.70
			Simple[tab.element]["east"].ax = 1
			Simple[tab.element]["east"].ay = 1
			Simple[tab.element]["east"].font = "Roboto" .. fontsize
			Simple[tab.element]["east"].color = lply:GetHudColor(tab.element, "TE")
			Simple[tab.element]["east"].brcolor = lply:GetHudColor(tab.element, "TB")
			Simple[tab.element]["east"].text = YRP.lang_string("LID_east_short")

			Simple[tab.element]["west"].w = w
			Simple[tab.element]["west"].h = h
			Simple[tab.element]["west"].x = x + w / 2
			Simple[tab.element]["west"].y = y + h * 0.70
			Simple[tab.element]["west"].ax = 1
			Simple[tab.element]["west"].ay = 1
			Simple[tab.element]["west"].font = "Roboto" .. fontsize
			Simple[tab.element]["west"].color = lply:GetHudColor(tab.element, "TE")
			Simple[tab.element]["west"].brcolor = lply:GetHudColor(tab.element, "TB")
			Simple[tab.element]["west"].text = YRP.lang_string("LID_west_short")
		else
			HudBox(Simple[tab.element]["needle"])

			Simple[tab.element]["degree"].text = tab.text

			HudTextBr(Simple[tab.element]["degree"])

			local x = Simple[tab.element]["degree"].x - Simple[tab.element]["north"].w / 2
			local w = Simple[tab.element]["north"].w
			local fw = (w * (lply:CoordAngle() / 360)) * -1

			-- North
			Simple[tab.element]["north"].x = x + (fw + w * 0.5) % w
			Simple[tab.element]["north"].text = "N"
			HudTextBr(Simple[tab.element]["north"])

			-- South
			Simple[tab.element]["south"].x = x + (fw + w * 0.0) % w
			Simple[tab.element]["south"].text = "S"
			HudTextBr(Simple[tab.element]["south"])

			-- East
			Simple[tab.element]["east"].x = x + (fw + w * 0.75) % w
			Simple[tab.element]["east"].text = "E"
			HudTextBr(Simple[tab.element]["east"])

			-- West
			Simple[tab.element]["west"].x = x + (fw + w * 0.25) % w
			Simple[tab.element]["west"].text = "W"
			HudTextBr(Simple[tab.element]["west"])
		end
	end
end

function GetFPS()
	return math.Round(1 / RealFrameTime())
end

local fps = 0
local fpsmin = 9999
local fpsmax = 0
local fpsavg = fps
local fpstavg = 0
local fpscou = 0
local fps_delay = 0
local fpscolor = Color(0, 0, 0)

local ping = 0
local pingmin = 9999
local pingmax = 0
local pingavg = ping
local pingtavg = 0
local pingcou = 0
local ping_delay = 0
local pingcolor = Color(0, 0, 0)
function HUDSimple()
	local lply = LocalPlayer()
	if lply:GetNWString("string_hud_design") == "Simple" then

		local batterypower = system.BatteryPower()

		-- Background
		local HP = {}
		HP.element = "HP"
		HUDSimpleBG(HP)
		local AR = {}
		AR.element = "AR"
		HUDSimpleBG(AR)
		local XP = {}
		XP.element = "XP"
		HUDSimpleBG(XP)
		local MO = {}
		MO.element = "MO"
		HUDSimpleBG(MO)
		if lply:GetNWBool("bool_stamina", false) then
			local ST = {}
			ST.element = "ST"
			HUDSimpleBG(ST)
		end
		if lply:GetNWBool("bool_yrp_chat", false) then
			local CH = {}
			CH.element = "CH"
			CH.r = ctr(16)
			CH.visiblefunc = IsChatVisible
			HUDSimpleBG(CH)
		end
		if lply:GetNWBool("bool_hunger", false) then
			local HU = {}
			HU.element = "HU"
			HUDSimpleBG(HU)
		end
		if lply:GetNWBool("bool_thirst", false) then
			local TH = {}
			TH.element = "TH"
			HUDSimpleBG(TH)
		end
		if lply:GetNWBool("iscasting", false) then
			local CA = {}
			CA.element = "CA"
			HUDSimpleBG(CA)
		end
		--[[local AB = {}
		AB.element = "AB"
		HUDSimpleBG(AB)
		]]
		local WP = {}
		WP.element = "WP"
		HUDSimpleBG(WP)
		local WS = {}
		WS.element = "WS"
		HUDSimpleBG(WS)
		local WN = {}
		WN.element = "WN"
		HUDSimpleBG(WN)
		if batterypower <= 100 then
			local BA = {}
			BA.element = "BA"
			HUDSimpleBG(BA)
		end
		if lply:Condition() != "" then
			local CON = {}
			CON.element = "CON"
			HUDSimpleBG(CON)
		end
		local PE = {}
		PE.element = "PE"
		HUDSimpleBG(PE)
		local NE = {}
		NE.element = "NE"
		HUDSimpleBG(NE)
		local COM = {}
		COM.element = "COM"
		HUDSimpleBG(COM)
		local MI = {}
		MI.element = "MI"
		HUDSimpleBG(MI)

		-- Midground
		HP = {}
		HP.element = "HP"
		HP.cur = lply:Health()
		HP.max = lply:GetMaxHealth()
		HP.text = lply:Health() .. "/" .. lply:GetMaxHealth()
		HP.percentage = lply:Health() / lply:GetMaxHealth() * 100 .. "%"
		HP.icon = Material("icon16/heart.png")
		HUDSimpleBAR(HP)
		AR = {}
		AR.element = "AR"
		AR.cur = lply:Armor()
		AR.max = lply:GetMaxArmor()
		AR.text = lply:Armor() .. "/" .. lply:GetMaxArmor()
		AR.percentage = lply:Armor() / lply:GetMaxArmor() * 100 .. "%"
		AR.icon = Material("icon16/shield.png")
		HUDSimpleBAR(AR)
		XP = {}
		XP.element = "XP"
		XP.cur = lply:XP()
		XP.max = lply:GetMaxXP()
		XP.text = "(" .. YRP.lang_string("LID_xp") .. ": " .. lply:XP() .. "/" .. lply:GetMaxXP() .. " " .. math.Round(lply:XP() / lply:GetMaxXP() * 100) .. "%) " .. YRP.lang_string("LID_level") .. " " .. lply:Level() .. " " .. lply:GetGroupName() .. " " .. lply:GetRoleName()
		HUDSimpleBAR(XP)
		MO = {}
		MO.element = "MO"
		MO.cur = CurTime() + lply:SalaryTime() - 1 - lply:NextSalaryTime()
		MO.max = lply:SalaryTime()
		MO.text = lply:FormattedMoneyRounded(1) .. " (+" .. lply:FormattedSalaryRounded(1) .. ")"
		MO.icon = Material("icon16/money.png")
		HUDSimpleBAR(MO)
		if lply:GetNWBool("bool_stamina", false) then
			local ST = {}
			ST.element = "ST"
			ST.cur = lply:Stamina()
			ST.max = lply:GetMaxStamina()
			ST.text = lply:Stamina() .. "/" .. lply:GetMaxStamina()
			ST.percentage = lply:Stamina() / lply:GetMaxStamina() * 100 .. "%"
			ST.icon = Material("icon16/lightning.png")
			HUDSimpleBAR(ST)
		end
		if lply:GetNWBool("bool_hunger", false) then
			local HU = {}
			HU.element = "HU"
			HU.cur = lply:Hunger()
			HU.max = lply:GetMaxHunger()
			HU.text = math.Round(lply:Hunger(), 1) .. "/" .. math.Round(lply:GetMaxHunger(), 1)
			HU.percentage = math.Round(lply:Hunger() / lply:GetMaxHunger() * 100, 1) .. "%"
			HU.icon = Material("icon16/cake.png")
			HUDSimpleBAR(HU)
		end
		if lply:GetNWBool("bool_thirst", false) then
			local TH = {}
			TH.element = "TH"
			TH.cur = lply:Thirst()
			TH.max = lply:GetMaxThirst()
			TH.text = math.Round(lply:Thirst(), 1) .. "/" .. math.Round(lply:GetMaxThirst(), 1)
			TH.percentage = math.Round(lply:Thirst() / lply:GetMaxThirst() * 100, 1) .. "%"
			TH.icon = Material("icon16/cup.png")
			HUDSimpleBAR(TH)
		end
		if lply:GetNWBool("iscasting", false) then
			local CA = {}
			CA.element = "CA"
			CA.cur = lply:CastTimeCurrent()
			CA.max = lply:CastTimeMax()
			CA.text = lply:GetCastName()
			CA.percentage = math.Round(lply:CastTimeCurrent() / lply:CastTimeMax() * 100, 1) .. "%"
			CA.icon = Material("icon16/hourglass.png")
			HUDSimpleBAR(CA)
		end
		--[[
		AB = {}
		AB.element = "AB"
		AB.cur = lply:Ability()
		AB.max = lply:GetMaxAbility()
		AB.text = math.Round(lply:Ability(), 1) .. "/" .. math.Round(lply:GetMaxAbility(), 1)
		AB.percentage = math.Round(lply:Ability() / lply:GetMaxAbility() * 100, 1) .. "%"
		AB.icon = Material("icon16/wand.png")
		HUDSimpleBAR(AB)
		]]
		local weapon = lply:GetActiveWeapon()
		if IsValid(weapon) then
			local clip1 = weapon:Clip1()
			local clip1max = weapon:GetMaxClip1()
			local ammo1 = lply:GetAmmoCount(weapon:GetPrimaryAmmoType())

			local clip2 = weapon:Clip2()
			local clip2max = weapon:GetMaxClip2()
			local ammo2 = lply:GetAmmoCount(weapon:GetSecondaryAmmoType())

			if ammo1 != nil then
				WP = {}
				WP.element = "WP"
				WP.cur = clip1
				WP.max = clip1max
				WP.text = clip1 .. "/" .. clip1max.. " | " .. ammo1
				HUDSimpleBAR(WP)
			end
			if ammo2 != nil then
				WS = {}
				WS.element = "WS"
				WS.cur = clip2
				WS.max = clip2max
				WS.text = clip2 .. "/" .. clip2max .. " | " .. ammo2
				HUDSimpleBAR(WS)
			end
			WN = {}
			WN.element = "WN"
			WN.cur = 1
			WN.max = 1
			WN.text = lply:GetActiveWeapon():GetPrintName()
			HUDSimpleBAR(WN)
		end
		if batterypower <= 100 then
			if batterypower > 100 then
				batterypower = 100
			end
			local BA = {}
			BA.element = "BA"
			BA.cur = batterypower
			BA.max = 100
			BA.text = batterypower .. "%"
			BA.icon = Material("icon16/computer.png")
			HUDSimpleBAR(BA)
		end
		if lply:Condition() != "" then
			local CON = {}
			CON.element = "CON"
			CON.cur = 1
			CON.max = 1
			CON.text = lply:Condition()
			HUDSimpleBAR(CON)
		end

		PE = {}
		PE.element = "PE"
		PE.cur = 0
		PE.max = 1
		if CurTime() > fps_delay then
			fps_delay = CurTime() + 0.5
			fps = GetFPS()
			if fps < fpsmin then
				fpsmin = fps
			elseif fps > fpsmax then
				fpsmax = fps
			end

			fpscou = fpscou + 1
			fpstavg = fpstavg + fps
			if fpscou > 9 then
				fpsavg = math.Round(fpstavg / 10, 0)
				fpscou = 0
				fpstavg = 0
			end

			if fps < 30 then
				fpscolor = Color(255, 0, 0)
			elseif fps < 60 then
				fpscolor = Color(255, 255, 0)
			else
				fpscolor = Color(0, 255, 0)
			end
		end
		PE.text = YRP.lang_string("LID_fps") .. ": " .. fps .. " (▼" .. fpsmin .. " Ø" .. fpsavg .. " ▲" .. fpsmax .. ")"
		PE.tcolor = fpscolor
		HUDSimpleBAR(PE)

		if CurTime() > ping_delay then
			ping_delay = CurTime() + 0.5
			ping = lply:Ping()
			if ping < pingmin then
				pingmin = ping
			elseif ping > pingmax then
				pingmax = ping
			end

			pingcou = pingcou + 1
			pingtavg = pingtavg + ping
			if pingcou > 9 then
				pingavg = math.Round(pingtavg / 10, 0)
				pingcou = 0
				pingtavg = 0
			end

			if ping > 100 then
				pingcolor = Color(255, 0, 0)
			elseif ping > 50 then
				pingcolor = Color(255, 255, 0)
			else
				pingcolor = Color(0, 255, 0)
			end
		end
		NE = {}
		NE.element = "NE"
		NE.cur = 0
		NE.max = 1
		NE.text = YRP.lang_string("LID_ping") .. ": " .. ping .. " (▼" .. pingmin .. " Ø" .. pingavg .. " ▲" .. pingmax .. ")"
		NE.tcolor = pingcolor
		HUDSimpleBAR(NE)

		COM = {}
		COM.element = "COM"
		COM.text = lply:CoordAngle() - lply:CoordAngle() % 5 .. "°"
		HUDSimpleCompass(COM)

		MI = {}
		MI.element = "MI"
		MI.cur = 0
		MI.max = 1
		local _x = math.Round(lply:GetPos().x, 0)
		local _y = math.Round(lply:GetPos().y, 0)
		MI.text = "x: " .. tostring(_x) .. " y: " .. tostring(_y)
		HUDSimpleBAR(MI)

		-- Foreground
		HP = {}
		HP.element = "HP"
		HUDSimpleBR(HP)
		AR = {}
		AR.element = "AR"
		HUDSimpleBR(AR)
		XP = {}
		XP.element = "XP"
		HUDSimpleBR(XP)
		MO = {}
		MO.element = "MO"
		HUDSimpleBR(MO)
		if lply:GetNWBool("bool_stamina", false) then
			local ST = {}
			ST.element = "ST"
			HUDSimpleBR(ST)
		end
		if lply:GetNWBool("bool_yrp_chat", false) then
			local CH = {}
			CH.element = "CH"
			CH.r = ctr(16)
			CH.visiblefunc = IsChatVisible
			HUDSimpleBR(CH)
		end
		if lply:GetNWBool("bool_hunger", false) then
			local HU = {}
			HU.element = "HU"
			HUDSimpleBR(HU)
		end
		if lply:GetNWBool("bool_thirst", false) then
			local TH = {}
			TH.element = "TH"
			HUDSimpleBR(TH)
		end
		if lply:GetNWBool("iscasting", false) then
			local CA = {}
			CA.element = "CA"
			HUDSimpleBR(CA)
		end
		--[[
		AB = {}
		AB.element = "AB"
		HUDSimpleBR(AB)
		]]
		WP = {}
		WP.element = "WP"
		HUDSimpleBR(WP)
		WS = {}
		WS.element = "WS"
		HUDSimpleBR(WS)
		WN = {}
		WN.element = "WN"
		HUDSimpleBR(WN)
		if batterypower <= 100 then
			local BA = {}
			BA.element = "BA"
			HUDSimpleBR(BA)
		end
		if lply:Condition() != "" then
			local CON = {}
			CON.element = "CON"
			HUDSimpleBR(CON)
		end
		PE = {}
		PE.element = "PE"
		HUDSimpleBR(PE)
		NE = {}
		NE.element = "NE"
		HUDSimpleBR(NE)
		COM = {}
		COM.element = "COM"
		HUDSimpleBR(COM)
		MI = {}
		MI.element = "MI"
		HUDSimpleBR(MI)
	end
end
hook.Add("HUDPaint", "yrp_hud_design_Simple", HUDSimple)
