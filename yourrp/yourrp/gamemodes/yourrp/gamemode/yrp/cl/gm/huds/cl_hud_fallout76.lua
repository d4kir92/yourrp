--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
function FOColor()
	return Color(249, 247, 196, 255)
end

function FOColorBG()
	return Color(236, 118, 97, 200)
end

local FO76 = {}
FO76["BG"] = {}
FO76["BGBar"] = {}
FO76["Bar"] = {}
FO76["TEXT"] = {}
FO76["CENTERTEXT"] = {}
FO76["BR"] = {}
function FO76BG(tab)
	local lply = LocalPlayer()
	FO76["BG"][tab.element] = FO76["BG"][tab.element] or {}
	FO76["BR"][tab.element] = FO76["BR"][tab.element] or {}
	if lply:HudValue("hud_version", 0) ~= FO76["BG"][tab.element]["version"] then
		FO76["BG"][tab.element]["version"] = lply:HudValue("hud_version", 0)
		local w = lply:HudValue(tab.element, "SIZE_W")
		local h = lply:HudValue(tab.element, "SIZE_H")
		local x = lply:HudValue(tab.element, "POSI_X")
		local y = lply:HudValue(tab.element, "POSI_Y")
		tab.thickness = ScrV(0.016)
		tab.br = 0.08
		FO76["BG"][tab.element].r = 0
		FO76["BG"][tab.element].w = w
		FO76["BG"][tab.element].h = h
		FO76["BG"][tab.element].x = x
		FO76["BG"][tab.element].y = y
		FO76["BG"][tab.element].color = Color(0, 0, 0, 100)
		FO76["BR"][tab.element].r = 0
		FO76["BR"][tab.element].w = w
		FO76["BR"][tab.element].h = h
		FO76["BR"][tab.element].x = x
		FO76["BR"][tab.element].y = y
		FO76["BR"][tab.element].color = Color(0, 0, 0, 255)
	elseif lply:HudElementVisible(tab.element) then
		YRPHudBox(FO76["BG"][tab.element])
		HudBoxBr(FO76["BR"][tab.element])
	end
end

function FO76Element(tab)
	local lply = LocalPlayer()
	FO76["BG"][tab.element] = FO76["BG"][tab.element] or {}
	FO76["BGBar"][tab.element] = FO76["BGBar"][tab.element] or {}
	FO76["Bar"][tab.element] = FO76["Bar"][tab.element] or {}
	FO76["TEXT"][tab.element] = FO76["TEXT"][tab.element] or {}
	FO76["CENTERTEXT"][tab.element] = FO76["CENTERTEXT"][tab.element] or {}
	FO76["BR"][tab.element] = FO76["BR"][tab.element] or {}
	if lply:HudValue("hud_version", 0) ~= FO76["BGBar"][tab.element]["version"] then
		FO76["BGBar"][tab.element]["version"] = lply:HudValue("hud_version", 0)
		local w = lply:HudValue(tab.element, "SIZE_W")
		local h = lply:HudValue(tab.element, "SIZE_H")
		local x = lply:HudValue(tab.element, "POSI_X")
		local y = lply:HudValue(tab.element, "POSI_Y")
		tab.thickness = ScrV(0.016)
		tab.br = 0.08
		FO76["BG"][tab.element].r = 0
		if lply:HudValue(tab.element, "TEXT") then
			FO76["BG"][tab.element].w = w - h
		else
			FO76["BG"][tab.element].w = w
		end

		FO76["BG"][tab.element].h = tab.thickness
		if lply:HudValue(tab.element, "TEXT") then
			FO76["BG"][tab.element].x = x + h
		else
			FO76["BG"][tab.element].x = x
		end

		FO76["BG"][tab.element].y = y + (h - tab.thickness) / 2
		FO76["BG"][tab.element].color = Color(0, 0, 0, 100)
		FO76["BGBar"][tab.element].r = 0
		local br = h * tab.br
		br = br + (1 - h * tab.br % 1)
		FO76["BGBar"][tab.element].w = FO76["BG"][tab.element].w - 2 * br
		FO76["BGBar"][tab.element].h = FO76["BG"][tab.element].h - 2 * br
		FO76["BGBar"][tab.element].x = FO76["BG"][tab.element].x + 1 * br
		FO76["BGBar"][tab.element].y = FO76["BG"][tab.element].y + 1 * br
		FO76["BGBar"][tab.element].color = FOColorBG()
		local m = {}
		if lply:HudValue(tab.element, "TEXT") then
			m.x = x + h
		else
			m.x = x
		end

		m.y = y + (h - tab.thickness) / 2
		if lply:HudValue(tab.element, "TEXT") then
			m.w = w - h
		else
			m.w = w
		end

		m.h = tab.thickness
		FO76["Bar"][tab.element].r = 0
		br = h * tab.br
		br = br + (1 - h * tab.br % 1)
		FO76["Bar"][tab.element].fw = m.w - 2 * br
		FO76["Bar"][tab.element].w = FO76["Bar"][tab.element].fw
		FO76["Bar"][tab.element].h = m.h - 2 * br
		FO76["Bar"][tab.element].x = m.x + 1 * br
		FO76["Bar"][tab.element].y = m.y + 1 * br
		FO76["Bar"][tab.element].color = FOColor()
		FO76["TEXT"][tab.element].x = x + h / 2
		FO76["TEXT"][tab.element].y = y + h / 2
		FO76["TEXT"][tab.element].ax = 1
		FO76["TEXT"][tab.element].ay = 1
		FO76["TEXT"][tab.element].font = "Y_18_500"
		FO76["TEXT"][tab.element].color = FOColor()
		FO76["CENTERTEXT"][tab.element].x = x + w / 2
		FO76["CENTERTEXT"][tab.element].y = y + h / 2
		FO76["CENTERTEXT"][tab.element].ax = 1
		FO76["CENTERTEXT"][tab.element].ay = 1
		FO76["CENTERTEXT"][tab.element].font = "Y_18_500"
		FO76["CENTERTEXT"][tab.element].color = Color(0, 0, 0, 255)
		FO76["BR"][tab.element].r = 0
		if lply:HudValue(tab.element, "TEXT") then
			FO76["BR"][tab.element].w = w - h
		else
			FO76["BR"][tab.element].w = w
		end

		FO76["BR"][tab.element].h = tab.thickness
		if lply:HudValue(tab.element, "TEXT") then
			FO76["BR"][tab.element].x = x + h
		else
			FO76["BR"][tab.element].x = x
		end

		FO76["BR"][tab.element].y = y + (h - tab.thickness) / 2
		FO76["BR"][tab.element].color = Color(0, 0, 0, 255)
	elseif lply:HudElementVisible(tab.element) then
		YRPHudBox(FO76["BG"][tab.element])
		YRPHudBox(FO76["BGBar"][tab.element])
		if tab.cur ~= nil and tab.max ~= nil then
			FO76["Bar"][tab.element].w = FO76["Bar"][tab.element].fw * tab.cur / tab.max
		end

		YRPHudBox(FO76["Bar"][tab.element])
		if tab.text ~= nil and lply:HudValue(tab.element, "TEXT") then
			FO76["TEXT"][tab.element].text = tab.text
			YRPHudText(FO76["TEXT"][tab.element])
		else
			FO76["TEXT"][tab.element].text = ""
		end

		if tab.centertext ~= nil and lply:HudValue(tab.element, "TEXT") then
			FO76["CENTERTEXT"][tab.element].text = tab.centertext
			YRPHudText(FO76["CENTERTEXT"][tab.element])
		else
			FO76["CENTERTEXT"][tab.element].text = ""
		end

		HudBoxBr(FO76["BR"][tab.element])
	end
end

FO76["NAME"] = {}
function FO76Name(tab)
	local lply = LocalPlayer()
	FO76["NAME"][tab.element] = FO76["NAME"][tab.element] or {}
	if lply:HudValue("hud_version", 0) ~= FO76["NAME"][tab.element]["version"] then
		FO76["NAME"][tab.element]["version"] = lply:HudValue("hud_version", 0)
		local w = lply:HudValue(tab.element, "SIZE_W")
		local h = lply:HudValue(tab.element, "SIZE_H")
		local x = lply:HudValue(tab.element, "POSI_X")
		local y = lply:HudValue(tab.element, "POSI_Y")
		local ax = lply:HudValue(tab.element, "AX")
		local ay = lply:HudValue(tab.element, "AY")
		local fontsize = lply:HudValue(tab.element, "TS")
		if fontsize <= 0 then
			fontsize = 14
		end

		if ax == 1 then
			x = x + w / 2
		elseif ax == 2 then
			x = x + w
		end

		if ay == 1 then
			y = y + h / 2
		elseif ay == 2 then
			y = y + w
		end

		FO76["NAME"][tab.element].x = x
		FO76["NAME"][tab.element].y = y
		FO76["NAME"][tab.element].ax = ax or 1
		FO76["NAME"][tab.element].ay = ay or 1
		FO76["NAME"][tab.element].font = "Y_" .. fontsize .. "_500"
		FO76["NAME"][tab.element].color = tab.tcolor or FOColor()
	elseif lply:HudElementVisible(tab.element) then
		FO76["NAME"][tab.element].text = tab.text
		YRPHudText(FO76["NAME"][tab.element])
	end
end

FO76["NUM"] = {}
function FO76Numbers(tab)
	local lply = LocalPlayer()
	FO76["NUM"][tab.element] = FO76["NUM"][tab.element] or {}
	if lply:HudValue("hud_version", 0) ~= FO76["NUM"][tab.element]["version"] then
		FO76["NUM"][tab.element]["version"] = lply:HudValue("hud_version", 0)
		local w = lply:HudValue(tab.element, "SIZE_W")
		local h = lply:HudValue(tab.element, "SIZE_H")
		local x = lply:HudValue(tab.element, "POSI_X")
		local y = lply:HudValue(tab.element, "POSI_Y")
		local fontsize = lply:HudValue(tab.element, "TS")
		if fontsize <= 0 then
			fontsize = 14
		end

		FO76["NUM"][tab.element].w = w
		FO76["NUM"][tab.element].h = h
		FO76["NUM"][tab.element].x = x + w / 2
		FO76["NUM"][tab.element].y = y + h / 2
		FO76["NUM"][tab.element].ax = 1
		FO76["NUM"][tab.element].ay = 1
		FO76["NUM"][tab.element].font = "Y_" .. fontsize .. "_500"
		FO76["NUM"][tab.element].color = FOColor()
	elseif lply:HudElementVisible(tab.element) then
		FO76["NUM"][tab.element].text = tab.text
		YRPHudText(FO76["NUM"][tab.element])
	end
end

FO76["CHAT"] = {}
function FO76Chat(tab)
	local lply = LocalPlayer()
	FO76["CHAT"][tab.element] = FO76["CHAT"][tab.element] or {}
	if lply:HudValue("hud_version", 0) ~= FO76["CHAT"][tab.element]["version"] then
		FO76["CHAT"][tab.element]["version"] = lply:HudValue("hud_version", 0)
		local w = lply:HudValue(tab.element, "SIZE_W")
		local h = lply:HudValue(tab.element, "SIZE_H")
		local x = lply:HudValue(tab.element, "POSI_X")
		local y = lply:HudValue(tab.element, "POSI_Y")
		FO76["CHAT"][tab.element].r = 0
		FO76["CHAT"][tab.element].w = w
		FO76["CHAT"][tab.element].h = h
		FO76["CHAT"][tab.element].x = x
		FO76["CHAT"][tab.element].y = y
		FO76["CHAT"][tab.element].color = Color(0, 0, 0, 100)
	else
		YRPHudBox(FO76["CHAT"][tab.element])
	end
end

local test = true
function HUDFO76Compass(tab)
	local lply = LocalPlayer()
	if lply:HudValue(tab.element, "VISI") then
		FO76[tab.element] = FO76[tab.element] or {}
		FO76[tab.element]["BG"] = FO76[tab.element]["BG"] or {}
		FO76[tab.element]["Bar"] = FO76[tab.element]["Bar"] or {}
		FO76[tab.element]["degree"] = FO76[tab.element]["degree"] or {}
		FO76[tab.element]["north"] = FO76[tab.element]["north"] or {}
		FO76[tab.element]["south"] = FO76[tab.element]["south"] or {}
		FO76[tab.element]["east"] = FO76[tab.element]["east"] or {}
		FO76[tab.element]["west"] = FO76[tab.element]["west"] or {}
		if lply:HudValue("hud_version", 0) ~= FO76[tab.element]["degree"]["version"] or test then
			test = false
			FO76[tab.element]["degree"]["version"] = lply:HudValue("hud_version", 0)
			local w = lply:HudValue(tab.element, "SIZE_W")
			local h = lply:HudValue(tab.element, "SIZE_H")
			local x = lply:HudValue(tab.element, "POSI_X")
			local y = lply:HudValue(tab.element, "POSI_Y")
			FO76[tab.element]["BG"].r = 0
			FO76[tab.element]["BG"].w = w
			FO76[tab.element]["BG"].h = h / 4
			FO76[tab.element]["BG"].x = x
			FO76[tab.element]["BG"].y = y
			FO76[tab.element]["BG"].color = Color(0, 0, 0, 100)
			FO76[tab.element]["Bar"].r = 0
			FO76[tab.element]["Bar"].w = w
			FO76[tab.element]["Bar"].h = h / 8
			FO76[tab.element]["Bar"].x = x
			FO76[tab.element]["Bar"].y = y + h / 2 - h / 4
			FO76[tab.element]["Bar"].color = FOColor()
			FO76[tab.element]["degree"].w = w
			FO76[tab.element]["degree"].h = h
			FO76[tab.element]["degree"].x = x + w / 2
			FO76[tab.element]["degree"].y = y + h * 0.30
			FO76[tab.element]["degree"].ax = 1
			FO76[tab.element]["degree"].ay = 1
			FO76[tab.element]["degree"].font = "Y_14_500"
			FO76[tab.element]["degree"].color = FOColor()
			FO76[tab.element]["degree"].brcolor = Color(0, 0, 0, 255)
			FO76[tab.element]["north"].w = h / 8
			FO76[tab.element]["north"].h = h
			FO76[tab.element]["north"].x = x + w / 2
			FO76[tab.element]["north"].y = y + h * 0.70
			FO76[tab.element]["north"].ax = 1
			FO76[tab.element]["north"].ay = 1
			FO76[tab.element]["north"].font = "Y_14_500"
			FO76[tab.element]["north"].color = FOColor()
			FO76[tab.element]["north"].brcolor = Color(0, 0, 0, 255)
			FO76[tab.element]["north"].text = YRP.trans("LID_north_short")
			FO76[tab.element]["south"].w = h / 8
			FO76[tab.element]["south"].h = h
			FO76[tab.element]["south"].x = x + w / 2
			FO76[tab.element]["south"].y = y + h * 0.70
			FO76[tab.element]["south"].ax = 1
			FO76[tab.element]["south"].ay = 1
			FO76[tab.element]["south"].font = "Y_14_500"
			FO76[tab.element]["south"].color = FOColor()
			FO76[tab.element]["south"].brcolor = Color(0, 0, 0, 255)
			FO76[tab.element]["south"].text = YRP.trans("LID_south_short")
			FO76[tab.element]["east"].w = h / 8
			FO76[tab.element]["east"].h = h
			FO76[tab.element]["east"].x = x + w / 2
			FO76[tab.element]["east"].y = y + h * 0.70
			FO76[tab.element]["east"].ax = 1
			FO76[tab.element]["east"].ay = 1
			FO76[tab.element]["east"].font = "Y_14_500"
			FO76[tab.element]["east"].color = FOColor()
			FO76[tab.element]["east"].brcolor = Color(0, 0, 0, 255)
			FO76[tab.element]["east"].text = YRP.trans("LID_east_short")
			FO76[tab.element]["west"].w = h / 8
			FO76[tab.element]["west"].h = h
			FO76[tab.element]["west"].x = x + w / 2
			FO76[tab.element]["west"].y = y + h * 0.70
			FO76[tab.element]["west"].ax = 1
			FO76[tab.element]["west"].ay = 1
			FO76[tab.element]["west"].font = "Y_14_500"
			FO76[tab.element]["west"].color = FOColor()
			FO76[tab.element]["west"].brcolor = Color(0, 0, 0, 255)
			FO76[tab.element]["west"].text = YRP.trans("LID_west_short")
		else
			YRPHudBox(FO76[tab.element]["BG"])
			YRPHudBox(FO76[tab.element]["Bar"])
			local x = FO76[tab.element]["degree"].x - FO76[tab.element]["degree"].w / 2
			local w = FO76[tab.element]["degree"].w
			local fw = (w * (lply:CoordAngle() / 360)) * -1
			-- North
			FO76[tab.element]["north"].x = x + (fw + w * 0.5) % w
			FO76[tab.element]["north"].text = "N"
			local hr_n = table.Copy(FO76[tab.element]["north"])
			hr_n.y = hr_n.y - hr_n.h * 0.35
			hr_n.x = hr_n.x - YRP.ctr(4)
			hr_n.w = YRP.ctr(8)
			hr_n.h = hr_n.h * 0.3
			YRPHudBox(hr_n)
			YRPHudText(FO76[tab.element]["north"])
			-- South
			FO76[tab.element]["south"].x = x + (fw + w * 0.0) % w
			FO76[tab.element]["south"].text = "S"
			local hr_s = table.Copy(FO76[tab.element]["south"])
			hr_s.y = hr_s.y - hr_s.h * 0.35
			hr_s.x = hr_s.x - YRP.ctr(4)
			hr_s.w = YRP.ctr(8)
			hr_s.h = hr_s.h * 0.3
			YRPHudBox(hr_s)
			YRPHudText(FO76[tab.element]["south"])
			-- East
			FO76[tab.element]["east"].x = x + (fw + w * 0.75) % w
			FO76[tab.element]["east"].text = "E"
			local hr_e = table.Copy(FO76[tab.element]["east"])
			hr_e.y = hr_e.y - hr_e.h * 0.35
			hr_e.x = hr_e.x - YRP.ctr(4)
			hr_e.w = YRP.ctr(8)
			hr_e.h = hr_e.h * 0.3
			YRPHudBox(hr_e)
			YRPHudText(FO76[tab.element]["east"])
			-- West
			FO76[tab.element]["west"].x = x + (fw + w * 0.25) % w
			FO76[tab.element]["west"].text = "W"
			local hr_w = table.Copy(FO76[tab.element]["west"])
			hr_w.y = hr_w.y - hr_w.h * 0.35
			hr_w.x = hr_w.x - YRP.ctr(4)
			hr_w.w = YRP.ctr(8)
			hr_w.h = hr_w.h * 0.3
			YRPHudBox(hr_w)
			YRPHudText(FO76[tab.element]["west"])
		end
	end
end

local fps = GetFPS()
local fpsmin = 9999
local fpsmax = 0
local fpsavg = fps
local fpstavg = 0
local fpscou = 0
local fps_delay = 0
local fpscolor = Color(0, 0, 0, 255)
local ping = 5
local pingmin = 9999
local pingmax = 0
local pingavg = ping
local pingtavg = 0
local pingcou = 0
local ping_delay = 0
local pingcolor = Color(0, 0, 0, 255)
function HUD_FO76()
	local lply = LocalPlayer()
	if YRP and YRP.GetDesignIcon and lply:LoadedGamemode() and YRPIsScoreboardVisible and not YRPIsScoreboardVisible() and GetGlobalYRPBool("bool_yrp_hud", false) and lply:GetHudDesignName() == "Fallout 76" then
		local HP = {}
		HP.element = "HP"
		HP.text = YRP.trans("LID_hp")
		HP.cur = lply:Health()
		HP.max = lply:GetMaxHealth()
		FO76Element(HP)
		local AR = {}
		AR.element = "AR"
		AR.text = YRP.trans("LID_ar")
		AR.cur = lply:Armor()
		AR.max = lply:GetMaxArmor()
		FO76Element(AR)
		local ST = {}
		ST.element = "ST"
		ST.text = YRP.trans("LID_st")
		ST.cur = lply:Stamina()
		ST.max = lply:GetMaxStamina()
		FO76Element(ST)
		local HU = {}
		HU.element = "HU"
		HU.text = YRP.trans("LID_hu")
		HU.cur = lply:Hunger()
		HU.max = lply:GetMaxHunger()
		FO76Element(HU)
		local TH = {}
		TH.element = "TH"
		TH.text = YRP.trans("LID_th")
		TH.cur = lply:Hunger()
		TH.max = lply:GetMaxHunger()
		FO76Element(TH)
		local RA = {}
		RA.element = "RA"
		RA.text = YRP.trans("LID_ra")
		RA.cur = lply:Radiation()
		RA.max = lply:GetMaxRadiation()
		FO76Element(RA)
		local AB = {}
		AB.element = "AB"
		AB.text = YRP.trans("LID_ab")
		AB.cur = lply:Ability()
		AB.max = lply:GetMaxAbility()
		FO76Element(AB)
		local XP = {}
		if IsLevelSystemEnabled() then
			XP.element = "XP"
			XP.text = YRP.trans("LID_xp")
			XP.cur = lply:XP()
			XP.max = lply:GetMaxXP()
			XP.centertext = lply:Level()
			FO76Element(XP)
		end

		local COM = {}
		COM.element = "COM"
		HUDFO76Compass(COM)
		local weapon = lply:GetActiveWeapon()
		if IsValid(weapon) then
			local clip1 = weapon:Clip1()
			local clip1max = weapon:GetMaxClip1()
			local clip2 = weapon:Clip2()
			local clip2max = weapon:GetMaxClip2()
			local ammo1 = lply:GetAmmoCount(weapon:GetPrimaryAmmoType())
			local ammo2 = lply:GetAmmoCount(weapon:GetSecondaryAmmoType())
			if ammo1 ~= nil then
				local WP = {}
				WP.element = "WP"
				WP.cur = clip1
				WP.max = clip1max
				WP.text = clip1 .. "/" .. ammo1
				FO76Numbers(WP)
			end

			if ammo2 ~= nil then
				local WS = {}
				WS.element = "WS"
				WS.cur = clip2
				WS.max = clip2max
				WS.text = clip2 .. "/" .. ammo2
				FO76Numbers(WS)
			end

			local WN = {}
			WN.element = "WN"
			WN.text = weapon:GetPrintName()
			FO76Name(WN)
		end

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
				pingcolor = Color(0, 255, 0)
			elseif ping > 50 then
				pingcolor = Color(255, 255, 0)
			else
				pingcolor = Color(0, 255, 0)
			end
		end

		local NE = {}
		NE.element = "NE"
		NE.text = YRP.trans("LID_ping") .. ": " .. ping .. " (▼" .. pingmin .. " Ø" .. pingavg .. " ▲" .. pingmax .. " )"
		NE.tcolor = pingcolor
		FO76Name(NE)
		local PE = {}
		PE.element = "PE"
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
				fpscolor = Color(0, 255, 0)
			elseif fps < 60 then
				fpscolor = Color(255, 255, 0)
			else
				fpscolor = Color(0, 255, 0)
			end
		end

		PE.text = YRP.trans("LID_fps") .. ": " .. fps .. " (▼" .. fpsmin .. " Ø" .. fpsavg .. " ▲" .. fpsmax .. " )"
		PE.tcolor = fpscolor
		FO76Name(PE)
		local MO = {}
		MO.element = "MO"
		MO.text = lply:FormattedMoney() .. " (+" .. lply:FormattedSalary() .. " )"
		FO76Name(MO)
		local CR = {}
		CR.element = "CR"
		CR.text = os.date("%H:%M", os.time())
		FO76Name(CR)
		local CC = {}
		CC.element = "CC"
		CC.text = lply:YRPFormattedCharPlayTime()
		FO76Name(CC)
		local ID = {}
		ID.element = "ID"
		ID.text = lply:GetYRPString("idcardid", "")
		FO76Name(ID)
		local batterypower = system.BatteryPower()
		if batterypower <= 100 then
			local BA = {}
			BA.element = "BA"
			BA.text = YRP.trans("LID_ba")
			BA.cur = batterypower
			BA.max = 100
			FO76Element(BA)
		end

		if not strEmpty(lply:Condition()) then
			local CON = {}
			CON.element = "CON"
			CON.text = lply:Condition()
			FO76Name(CON)
		end

		if lply:Lockdown() then
			local LO = {}
			LO.element = "LO"
			LO.text = "[" .. GTS("lockdown") .. "] " .. lply:LockdownText()
			LO.tcolor = Color(0, 255, 0)
			FO76Name(LO)
		end

		if lply:GetYRPBool("iscasting", false) then
			local CA = {}
			CA.element = "CA"
			CA.cur = lply:CastTimeCurrent()
			CA.max = lply:CastTimeMax()
			CA.percentage = math.Round(lply:CastTimeCurrent() / lply:CastTimeMax() * 100, 0) .. "%"
			CA.text = string.upper(lply:GetCastName()) .. " " .. CA.percentage
			CA.icon = Material("icon16/hourglass.png")
			FO76Name(CA)
		end
	end
end

timer.Simple(
	1,
	function()
		hook.Add("HUDPaint", "yrp_hud_design_Fallout76", HUD_FO76)
	end
)