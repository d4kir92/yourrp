--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

function FOColor()
	return Color(249, 247, 196, 255)
end

function FOColorBG()
	return Color(236, 118, 97, 200)
end

local FO76 = {}
FO76["Health"] = {}
FO76["Health"]["version"] = 0
FO76["Health"]["border"] = {}
FO76["Health"]["bg"] = {}
FO76["Health"]["barbg"] = {}
FO76["Health"]["bar"] = {}
FO76["Health"]["text"] = {}
function FO76Health()
	local lply = LocalPlayer()
	if lply:GetNWInt("hud_version", 0) != FO76["version"] then
		FO76["version"] = lply:GetNWInt("hud_version", 0)

		local w = lply:GetHudValue("HP", "W")
		local h = lply:GetHudValue("HP", "H")
		local x = lply:GetHudValue("HP", "X")
		local y = lply:GetHudValue("HP", "Y")

		FO76["Health"].space = ScrV(0)
		if true then -- lply:Hud("health", "text") != nil then -- if hp_text == true then
			FO76["Health"].space = ScrV(0.04)
		end
		FO76["Health"].br = ScrV(0.0028)

		FO76["Health"]["border"].br = ScrV(0.001)
		FO76["Health"]["border"].r = 0
		FO76["Health"]["border"].w = w - FO76["Health"].space
		FO76["Health"]["border"].h = ScrV(0.014)
		FO76["Health"]["border"].x = x + FO76["Health"].space
		FO76["Health"]["border"].y = y
		FO76["Health"]["border"].color = Color(0, 0, 0, 255)
		FO76["Health"]["border"] = GetBorderTab(FO76["Health"]["border"])

		FO76["Health"]["bg"].r = 0
		FO76["Health"]["bg"].w = w - FO76["Health"].space
		FO76["Health"]["bg"].h = ScrV(0.014)
		FO76["Health"]["bg"].x = x + FO76["Health"].space
		FO76["Health"]["bg"].y = y
		FO76["Health"]["bg"].color = Color(0, 0, 0, 100)

		FO76["Health"]["barbg"].r = 0
		FO76["Health"]["barbg"].w = w - FO76["Health"].space - 2 * FO76["Health"].br
		FO76["Health"]["barbg"].h = ScrV(0.014) - 2 * FO76["Health"].br
		FO76["Health"]["barbg"].x = x + FO76["Health"].space + FO76["Health"].br
		FO76["Health"]["barbg"].y = y + FO76["Health"].br
		FO76["Health"]["barbg"].color = FOColorBG()

		FO76["Health"]["bar"].r = 0
		FO76["Health"]["bar"].fw = w - FO76["Health"].space - 2 * FO76["Health"].br
		FO76["Health"]["bar"].h = ScrV(0.014) - 2 * FO76["Health"].br
		FO76["Health"]["bar"].x = x + FO76["Health"].space + FO76["Health"].br
		FO76["Health"]["bar"].y = y + FO76["Health"].br
		FO76["Health"]["bar"].color = FOColor()

		FO76["Health"]["text"].x = x + FO76["Health"].space / 2
		FO76["Health"]["text"].y = math.Round(y + (FO76["Health"]["bg"].h / 2) )
		FO76["Health"]["text"].color = FOColor()
		FO76["Health"]["text"].text = "HP"
		FO76["Health"]["text"].font = "Roboto24B"
		FO76["Health"]["text"].ax = 1
		FO76["Health"]["text"].ay = 1
	else
		FO76["Health"]["bar"].w = FO76["Health"]["bar"].fw * (lply:Health() / lply:GetMaxHealth())

		HudBox(FO76["Health"]["bg"])
		HudBox(FO76["Health"]["barbg"])
		HudBox(FO76["Health"]["bar"])
		HudText(FO76["Health"]["text"])

		--HudBoxBr(FO76["Health"]["border"])
	end
end

function HUD_FO76()
	local lply = LocalPlayer()
	if lply:GetNWString("string_hud_design") == "Fallout 76" then
		FO76Health()
	end
end

hook.Add("HUDPaint", "yrp_hud_design_Fallout76", HUD_FO76)
