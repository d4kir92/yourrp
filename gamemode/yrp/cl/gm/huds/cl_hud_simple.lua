--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

function fake_true()
	return true
end

local Simple = {}
function HUDSimpleBG(tab)
	local lply = LocalPlayer()
	tab.visiblefunc = tab.visiblefunc or fake_true
	if lply:GetHudBool(tab.element, "VISI") and tab.visiblefunc() then
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

function HUDSimpleBAR(tab)
	local lply = LocalPlayer()
	if lply:GetHudBool(tab.element, "VISI") then
		Simple[tab.element] = Simple[tab.element] or {}
		Simple[tab.element]["bar"] = Simple[tab.element]["bar"] or {}
		Simple[tab.element]["text"] = Simple[tab.element]["text"] or {}

		if lply:GetNWInt("hud_version", 0) != Simple[tab.element]["bar"]["version"] then
			Simple[tab.element]["bar"]["version"] = lply:GetNWInt("hud_version", 0)

			local w = lply:GetHudValue(tab.element, "SIZE_W")
			local h = lply:GetHudValue(tab.element, "SIZE_H")
			local x = lply:GetHudValue(tab.element, "POSI_X")
			local y = lply:GetHudValue(tab.element, "POSI_Y")

			Simple[tab.element]["bar"].fw = w
			Simple[tab.element]["bar"].h = h
			Simple[tab.element]["bar"].x = x
			Simple[tab.element]["bar"].y = y

			Simple[tab.element]["bar"].r = 0
			if lply:GetHudBool(tab.element, "ROUN") then
				Simple[tab.element]["bar"].r = tab.r or Simple[tab.element]["bar"].h / 2
			end

			Simple[tab.element]["bar"].color = lply:GetHudColor(tab.element, "BA")

			Simple[tab.element]["text"].x = x + w / 2
			Simple[tab.element]["text"].y = y + h / 2
			Simple[tab.element]["text"].ax = 1
			Simple[tab.element]["text"].ay = 1
			Simple[tab.element]["text"].text = tab.element
			Simple[tab.element]["text"].font = "Roboto24"
			Simple[tab.element]["text"].color = Color(255, 255, 255, 255)
			Simple[tab.element]["text"].brcolor = Color(0, 0, 0, 255)
		else
			Simple[tab.element]["bar"].w = Simple[tab.element]["bar"].fw / tab.max * tab.cur
			HudBox(Simple[tab.element]["bar"])

			Simple[tab.element]["text"].text = ""
			if tab.text != nil and lply:GetHudBool(tab.element, "TEXT") then
				Simple[tab.element]["text"].text = tab.text
			end
			if tab.percentage != nil and lply:GetHudBool(tab.element, "PERC") then
				Simple[tab.element]["text"].text = Simple[tab.element]["text"].text .. " " .. tab.percentage
			end
			HudTextBr(Simple[tab.element]["text"])
		end
	end
end

function HUDSimpleBR(tab)
	local lply = LocalPlayer()
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

			Simple[tab.element]["degree"].w = w
			Simple[tab.element]["degree"].h = h
			Simple[tab.element]["degree"].x = x + w / 2
			Simple[tab.element]["degree"].y = y + h * 0.30
			Simple[tab.element]["degree"].ax = 1
			Simple[tab.element]["degree"].ay = 1
			Simple[tab.element]["degree"].font = "Roboto14"
			Simple[tab.element]["degree"].color = Color(255, 255, 255)
			Simple[tab.element]["degree"].brcolor = Color(0, 0, 0)

			Simple[tab.element]["north"].w = w
			Simple[tab.element]["north"].h = h
			Simple[tab.element]["north"].x = x + w / 2
			Simple[tab.element]["north"].y = y + h * 0.70
			Simple[tab.element]["north"].ax = 1
			Simple[tab.element]["north"].ay = 1
			Simple[tab.element]["north"].font = "Roboto14"
			Simple[tab.element]["north"].color = Color(255, 255, 255)
			Simple[tab.element]["north"].brcolor = Color(0, 0, 0)
			Simple[tab.element]["north"].text = "N"

			Simple[tab.element]["south"].w = w
			Simple[tab.element]["south"].h = h
			Simple[tab.element]["south"].x = x + w / 2
			Simple[tab.element]["south"].y = y + h * 0.70
			Simple[tab.element]["south"].ax = 1
			Simple[tab.element]["south"].ay = 1
			Simple[tab.element]["south"].font = "Roboto14"
			Simple[tab.element]["south"].color = Color(255, 255, 255)
			Simple[tab.element]["south"].brcolor = Color(0, 0, 0)
			Simple[tab.element]["south"].text = "S"

			Simple[tab.element]["east"].w = w
			Simple[tab.element]["east"].h = h
			Simple[tab.element]["east"].x = x + w / 2
			Simple[tab.element]["east"].y = y + h * 0.70
			Simple[tab.element]["east"].ax = 1
			Simple[tab.element]["east"].ay = 1
			Simple[tab.element]["east"].font = "Roboto14"
			Simple[tab.element]["east"].color = Color(255, 255, 255)
			Simple[tab.element]["east"].brcolor = Color(0, 0, 0)
			Simple[tab.element]["east"].text = "E"

			Simple[tab.element]["west"].w = w
			Simple[tab.element]["west"].h = h
			Simple[tab.element]["west"].x = x + w / 2
			Simple[tab.element]["west"].y = y + h * 0.70
			Simple[tab.element]["west"].ax = 1
			Simple[tab.element]["west"].ay = 1
			Simple[tab.element]["west"].font = "Roboto14"
			Simple[tab.element]["west"].color = Color(255, 255, 255)
			Simple[tab.element]["west"].brcolor = Color(0, 0, 0)
			Simple[tab.element]["west"].text = "W"
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

local fps = 0
local fps_delay = 0
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
		local ST = {}
		ST.element = "ST"
		HUDSimpleBG(ST)
		local CH = {}
		CH.element = "CH"
		CH.r = ctr(16)
		CH.visiblefunc = IsChatVisible
		HUDSimpleBG(CH)
		local HU = {}
		HU.element = "HU"
		HUDSimpleBG(HU)
		local TH = {}
		TH.element = "TH"
		HUDSimpleBG(TH)
		if lply:GetNWBool("iscasting", false) then
			local CA = {}
			CA.element = "CA"
			HUDSimpleBG(CA)
		end
		local AB = {}
		AB.element = "AB"
		HUDSimpleBG(AB)
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
		HUDSimpleBAR(HP)
		AR = {}
		AR.element = "AR"
		AR.cur = lply:Armor()
		AR.max = lply:GetMaxArmor()
		AR.text = lply:Armor() .. "/" .. lply:GetMaxArmor()
		AR.percentage = lply:Armor() / lply:GetMaxArmor() * 100 .. "%"
		HUDSimpleBAR(AR)
		XP = {}
		XP.element = "XP"
		XP.cur = 1
		XP.max = 1
		XP.text = YRP.lang_string("LID_level") .. " " .. lply:Level() .. " " .. lply:GetGroupName() .. " " .. lply:GetRoleName()
		HUDSimpleBAR(XP)
		MO = {}
		MO.element = "MO"
		MO.cur = CurTime() + lply:SalaryTime() - 1 - lply:NextSalaryTime()
		MO.max = lply:SalaryTime()
		MO.text = lply:FormattedMoney() .. " (+" .. lply:FormattedSalary() .. ")"
		HUDSimpleBAR(MO)
		ST = {}
		ST.element = "ST"
		ST.cur = lply:Stamina()
		ST.max = lply:GetMaxStamina()
		ST.text = lply:Stamina() .. "/" .. lply:GetMaxStamina()
		ST.percentage = lply:Stamina() / lply:GetMaxStamina() * 100 .. "%"
		HUDSimpleBAR(ST)
		HU = {}
		HU.element = "HU"
		HU.cur = lply:Hunger()
		HU.max = lply:GetMaxHunger()
		HU.text = math.Round(lply:Hunger(), 1) .. "/" .. math.Round(lply:GetMaxHunger(), 1)
		HU.percentage = math.Round(lply:Hunger() / lply:GetMaxHunger() * 100, 1) .. "%"
		HUDSimpleBAR(HU)
		TH = {}
		TH.element = "TH"
		TH.cur = lply:Thirst()
		TH.max = lply:GetMaxThirst()
		TH.text = math.Round(lply:Thirst(), 1) .. "/" .. math.Round(lply:GetMaxThirst(), 1)
		TH.percentage = math.Round(lply:Thirst() / lply:GetMaxThirst() * 100, 1) .. "%"
		HUDSimpleBAR(TH)
		if lply:GetNWBool("iscasting", false) then
			local CA = {}
			CA.element = "CA"
			CA.cur = lply:CastTimeCurrent()
			CA.max = lply:CastTimeMax()
			CA.text = lply:GetCastName()
			CA.percentage = math.Round(lply:CastTimeCurrent() / lply:CastTimeMax() * 100, 1) .. "%"
			HUDSimpleBAR(CA)
		end
		AB = {}
		AB.element = "AB"
		AB.cur = lply:Ability()
		AB.max = lply:GetMaxAbility()
		AB.text = math.Round(lply:Ability(), 1) .. "/" .. math.Round(lply:GetMaxAbility(), 1)
		AB.percentage = math.Round(lply:Ability() / lply:GetMaxAbility() * 100, 1) .. "%"
		HUDSimpleBAR(AB)
		local weapon = lply:GetActiveWeapon()
		if IsValid(weapon) then
			local clip1 = weapon:Clip1()
			local clip1max = weapon:GetMaxClip1()
			local clip2 = weapon:Clip2()
			local clip2max = weapon:GetMaxClip2()
			local ammo1 = lply:GetAmmoCount(weapon:GetPrimaryAmmoType())
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
			local BA = {}
			BA.element = "BA"
			BA.cur = batterypower
			BA.max = 100
			BA.text = batterypower .. "%"
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
			fps_delay = CurTime() + 1
			fps = math.Round(1 / RealFrameTime())
		end
		PE.text = YRP.lang_string("LID_fps") .. ": " .. fps
		HUDSimpleBAR(PE)
		NE = {}
		NE.element = "NE"
		NE.cur = 0
		NE.max = 1
		NE.text = YRP.lang_string("LID_ping") .. ": " .. lply:Ping()
		HUDSimpleBAR(NE)

		COM = {}
		COM.element = "COM"
		COM.text = lply:CoordAngle() .. "°"
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
		ST = {}
		ST.element = "ST"
		HUDSimpleBR(ST)
		CH = {}
		CH.element = "CH"
		CH.r = ctr(16)
		CH.visiblefunc = IsChatVisible
		HUDSimpleBR(CH)
		HU = {}
		HU.element = "HU"
		HUDSimpleBR(HU)
		TH = {}
		TH.element = "TH"
		HUDSimpleBR(TH)
		if lply:GetNWBool("iscasting", false) then
			local CA = {}
			CA.element = "CA"
			HUDSimpleBR(CA)
		end
		AB = {}
		AB.element = "AB"
		HUDSimpleBR(AB)
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
