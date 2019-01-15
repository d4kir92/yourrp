--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

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
FO76["BR"] = {}
function FO76BG(tab)
	local lply = LocalPlayer()
	FO76["BG"][tab.element] = FO76["BG"][tab.element] or {}
	FO76["BR"][tab.element] = FO76["BR"][tab.element] or {}
	if lply:GetNWInt("hud_version", 0) != FO76["BG"][tab.element]["version"] then
		FO76["BG"][tab.element]["version"] = lply:GetNWInt("hud_version", 0)

		local w = lply:GetHudValue(tab.element, "SIZE_W")
		local h = lply:GetHudValue(tab.element, "SIZE_H")
		local x = lply:GetHudValue(tab.element, "POSI_X")
		local y = lply:GetHudValue(tab.element, "POSI_Y")

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
	else
		HudBox(FO76["BG"][tab.element])
		HudBoxBr(FO76["BR"][tab.element])
	end
end

function FO76Element(tab)
	local lply = LocalPlayer()
	FO76["BG"][tab.element] = FO76["BG"][tab.element] or {}
	FO76["BGBar"][tab.element] = FO76["BGBar"][tab.element] or {}
	FO76["Bar"][tab.element] = FO76["Bar"][tab.element] or {}
	FO76["TEXT"][tab.element] = FO76["TEXT"][tab.element] or {}
	FO76["BR"][tab.element] = FO76["BR"][tab.element] or {}
	if lply:GetNWInt("hud_version", 0) != FO76["BG"][tab.element]["version"] then
		FO76["BG"][tab.element]["version"] = lply:GetNWInt("hud_version", 0)

		local w = lply:GetHudValue(tab.element, "SIZE_W")
		local h = lply:GetHudValue(tab.element, "SIZE_H")
		local x = lply:GetHudValue(tab.element, "POSI_X")
		local y = lply:GetHudValue(tab.element, "POSI_Y")

		tab.thickness = ScrV(0.016)
		tab.br = 0.08

		FO76["BG"][tab.element].r = 0
		FO76["BG"][tab.element].w = w - h
		FO76["BG"][tab.element].h = tab.thickness
		FO76["BG"][tab.element].x = x + h
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
		m.x = x + h
		m.y = y + (h - tab.thickness) / 2
		m.w = w - h
		m.h = tab.thickness

		FO76["Bar"][tab.element].r = 0
		local br = h * tab.br
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
		FO76["TEXT"][tab.element].font = "Roboto18B"
		FO76["TEXT"][tab.element].color = FOColor()

		FO76["BR"][tab.element].r = 0
		FO76["BR"][tab.element].w = w - h
		FO76["BR"][tab.element].h = tab.thickness
		FO76["BR"][tab.element].x = x + h
		FO76["BR"][tab.element].y = y + (h - tab.thickness) / 2
		FO76["BR"][tab.element].color = Color(0, 0, 0, 255)
	else
		HudBox(FO76["BG"][tab.element])
		HudBox(FO76["BGBar"][tab.element])

		if tab.cur != nil and tab.max != nil then
			FO76["Bar"][tab.element].w = FO76["Bar"][tab.element].fw * tab.cur / tab.max
		end
		HudBox(FO76["Bar"][tab.element])

		if tab.text != nil then
			FO76["TEXT"][tab.element].text = tab.text
			HudText(FO76["TEXT"][tab.element])
		end

		HudBoxBr(FO76["BR"][tab.element])
	end
end

local test = true
function HUDFO76Compass(tab)
	local lply = LocalPlayer()
	if lply:GetHudBool(tab.element, "VISI") then
		FO76[tab.element] = FO76[tab.element] or {}
		FO76[tab.element]["BG"] = FO76[tab.element]["BG"] or {}
		FO76[tab.element]["Bar"] = FO76[tab.element]["Bar"] or {}
		FO76[tab.element]["degree"] = FO76[tab.element]["degree"] or {}
		FO76[tab.element]["north"] = FO76[tab.element]["north"] or {}
		FO76[tab.element]["south"] = FO76[tab.element]["south"] or {}
		FO76[tab.element]["east"] = FO76[tab.element]["east"] or {}
		FO76[tab.element]["west"] = FO76[tab.element]["west"] or {}

		if lply:GetNWInt("hud_version", 0) != FO76[tab.element]["degree"]["version"] or test then
			test = false
			FO76[tab.element]["degree"]["version"] = lply:GetNWInt("hud_version", 0)

			local w = lply:GetHudValue(tab.element, "SIZE_W")
			local h = lply:GetHudValue(tab.element, "SIZE_H")
			local x = lply:GetHudValue(tab.element, "POSI_X")
			local y = lply:GetHudValue(tab.element, "POSI_Y")

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
			FO76[tab.element]["degree"].font = "Roboto14"
			FO76[tab.element]["degree"].color = FOColor()
			FO76[tab.element]["degree"].brcolor = Color(0, 0, 0)

			FO76[tab.element]["north"].w = h / 8
			FO76[tab.element]["north"].h = h
			FO76[tab.element]["north"].x = x + w / 2
			FO76[tab.element]["north"].y = y + h * 0.70
			FO76[tab.element]["north"].ax = 1
			FO76[tab.element]["north"].ay = 1
			FO76[tab.element]["north"].font = "Roboto14"
			FO76[tab.element]["north"].color = FOColor()
			FO76[tab.element]["north"].brcolor = Color(0, 0, 0)
			FO76[tab.element]["north"].text = YRP.lang_string("LID_north_short")

			FO76[tab.element]["south"].w = h / 8
			FO76[tab.element]["south"].h = h
			FO76[tab.element]["south"].x = x + w / 2
			FO76[tab.element]["south"].y = y + h * 0.70
			FO76[tab.element]["south"].ax = 1
			FO76[tab.element]["south"].ay = 1
			FO76[tab.element]["south"].font = "Roboto14"
			FO76[tab.element]["south"].color = FOColor()
			FO76[tab.element]["south"].brcolor = Color(0, 0, 0)
			FO76[tab.element]["south"].text = YRP.lang_string("LID_south_short")

			FO76[tab.element]["east"].w = h / 8
			FO76[tab.element]["east"].h = h
			FO76[tab.element]["east"].x = x + w / 2
			FO76[tab.element]["east"].y = y + h * 0.70
			FO76[tab.element]["east"].ax = 1
			FO76[tab.element]["east"].ay = 1
			FO76[tab.element]["east"].font = "Roboto14"
			FO76[tab.element]["east"].color = FOColor()
			FO76[tab.element]["east"].brcolor = Color(0, 0, 0)
			FO76[tab.element]["east"].text = YRP.lang_string("LID_east_short")

			FO76[tab.element]["west"].w = h / 8
			FO76[tab.element]["west"].h = h
			FO76[tab.element]["west"].x = x + w / 2
			FO76[tab.element]["west"].y = y + h * 0.70
			FO76[tab.element]["west"].ax = 1
			FO76[tab.element]["west"].ay = 1
			FO76[tab.element]["west"].font = "Roboto14"
			FO76[tab.element]["west"].color = FOColor()
			FO76[tab.element]["west"].brcolor = Color(0, 0, 0)
			FO76[tab.element]["west"].text = YRP.lang_string("LID_west_short")
		else
			HudBox(FO76[tab.element]["BG"])

			HudBox(FO76[tab.element]["Bar"])

			local x = FO76[tab.element]["degree"].x - FO76[tab.element]["degree"].w / 2
			local w = FO76[tab.element]["degree"].w
			local fw = (w * (lply:CoordAngle() / 360)) * -1

			-- North
			FO76[tab.element]["north"].x = x + (fw + w * 0.5) % w
			FO76[tab.element]["north"].text = "N"
			local hr_n = table.Copy(FO76[tab.element]["north"])
			hr_n.y = hr_n.y - hr_n.h * 0.35
			hr_n.x = hr_n.x - ctr(4)
			hr_n.w = ctr(8)
			hr_n.h = hr_n.h * 0.3
			HudBox(hr_n)
			HudTextBr(FO76[tab.element]["north"])

			-- South
			FO76[tab.element]["south"].x = x + (fw + w * 0.0) % w
			FO76[tab.element]["south"].text = "S"
			local hr_s = table.Copy(FO76[tab.element]["south"])
			hr_s.y = hr_s.y - hr_s.h * 0.35
			hr_s.x = hr_s.x - ctr(4)
			hr_s.w = ctr(8)
			hr_s.h = hr_s.h * 0.3
			HudBox(hr_s)
			HudTextBr(FO76[tab.element]["south"])

			-- East
			FO76[tab.element]["east"].x = x + (fw + w * 0.75) % w
			FO76[tab.element]["east"].text = "E"
			local hr_e = table.Copy(FO76[tab.element]["east"])
			hr_e.y = hr_e.y - hr_e.h * 0.35
			hr_e.x = hr_e.x - ctr(4)
			hr_e.w = ctr(8)
			hr_e.h = hr_e.h * 0.3
			HudBox(hr_e)
			HudTextBr(FO76[tab.element]["east"])

			-- West
			FO76[tab.element]["west"].x = x + (fw + w * 0.25) % w
			FO76[tab.element]["west"].text = "W"
			local hr_w = table.Copy(FO76[tab.element]["west"])
			hr_w.y = hr_w.y - hr_w.h * 0.35
			hr_w.x = hr_w.x - ctr(4)
			hr_w.w = ctr(8)
			hr_w.h = hr_w.h * 0.3
			HudBox(hr_w)
			HudTextBr(FO76[tab.element]["west"])
		end
	end
end

function HUD_FO76()
	local lply = LocalPlayer()
	if lply:GetNWString("string_hud_design") == "Fallout 76" then
		local HP = {}
		HP.element = "HP"
		HP.text = YRP.lang_string("LID_hp")
		HP.cur = lply:Health()
		HP.max = lply:GetMaxHealth()
		FO76Element(HP)

		local AR = {}
		AR.element = "AR"
		AR.text = YRP.lang_string("LID_ar")
		AR.cur = lply:Armor()
		AR.max = lply:GetMaxArmor()
		FO76Element(AR)

		local ST = {}
		ST.element = "ST"
		ST.text = YRP.lang_string("LID_st")
		ST.cur = lply:Stamina()
		ST.max = lply:GetMaxStamina()
		FO76Element(ST)

		local HU = {}
		HU.element = "HU"
		HU.text = YRP.lang_string("LID_hu")
		HU.cur = lply:Hunger()
		HU.max = lply:GetMaxHunger()
		FO76Element(HU)

		local TH = {}
		TH.element = "TH"
		TH.text = YRP.lang_string("LID_th")
		TH.cur = lply:Hunger()
		TH.max = lply:GetMaxHunger()
		FO76Element(TH)

		local AB = {}
		AB.element = "AB"
		AB.text = YRP.lang_string("LID_ab")
		AB.cur = lply:Hunger()
		AB.max = lply:GetMaxHunger()
		FO76Element(AB)

		local XP = {}
		XP.element = "XP"
		XP.text = YRP.lang_string("LID_xp")
		XP.cur = 1
		XP.max = 1
		FO76Element(XP)

		if IsChatVisible() then
			local CH = {}
			CH.element = "CH"
			FO76BG(CH)
		end

		local COM = {}
		COM.element = "COM"
		HUDFO76Compass(COM)
	end
end


hook.Add("HUDPaint", "yrp_hud_design_Fallout76", HUD_FO76)
