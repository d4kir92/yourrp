--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local HP = Material("icon16/heart.png")
local AR = Material("icon16/shield.png")

function HUDDrawIcon(ele, icon, perc)
	local lply = LocalPlayer()
	local h = lply:HudValue(ele, "SIZE_H")
	local x = lply:HudValue(ele, "POSI_X")
	local y = lply:HudValue(ele, "POSI_Y")
	surface.SetDrawColor(0, 0, 0, 255)
	surface.SetMaterial(icon)
	surface.DrawTexturedRect(x, y, h, h)
	render.ClearStencil()
	render.SetStencilEnable(true)

		render.SetStencilWriteMask(1)
		render.SetStencilTestMask(1)

		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)

		render.SetStencilFailOperation(STENCILOPERATION_INCR)
		render.SetStencilPassOperation(STENCILOPERATION_KEEP)
		render.SetStencilZFailOperation(STENCILOPERATION_KEEP)

		render.SetStencilReferenceValue(1)

		draw.RoundedBox(0, x, y + h - h * perc, h, h * perc, Color(255, 0, 0))

		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)

		surface.SetDrawColor(lply:HudValue(ele, "BA"))
		surface.SetMaterial(icon)
		surface.DrawTexturedRect(x, y, h, h)

	render.SetStencilEnable(false)

	local fontsize = lply:HudValue(ele, "TS")
	if fontsize <= 0 then
		fontsize = 14
	end
	local font = "Roboto" .. fontsize

	draw.SimpleText(perc * 100 .. "%", font, x + h / 2, y + h / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function HUDIcons()
	local lply = LocalPlayer()

	if GetGlobalBool("bool_yrp_hud", false) and lply:GetDString("string_hud_design") == "Icons" then
		HUDDrawIcon("HP", HP, lply:Health() / lply:GetMaxHealth())
		HUDDrawIcon("AR", AR, lply:Armor() / lply:GetMaxArmor())
	end
end
hook.Add("HUDPaint", "yrp_hud_design_Icons", HUDIcons)
