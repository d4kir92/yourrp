--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local AR = Material("vgui/material/icon_favorite.png")

local delay = 0
local rot = 0
local rotdir = 0.2
function HUDAnimatedDrawIcon(ele, icon, perc, text)
	if CurTime() > delay then
		delay = CurTime() + 0.01
		rot = rot + rotdir
		if rot > 10 then
			rotdir = -0.2
		elseif rot < -10 then
			rotdir = 0.2
		end
	end

	perc = math.Round(perc, 3)
	local lply = LocalPlayer()
	local h = lply:HudValue(ele, "SIZE_H")
	local x = lply:HudValue(ele, "POSI_X")
	local y = lply:HudValue(ele, "POSI_Y")
	local size = h

	draw.RoundedBox(h, x, y, h, h, Color(0, 0, 0, 120))

	render.ClearStencil()
	render.SetStencilEnable(true)
		render.SetStencilWriteMask(1)
		render.SetStencilTestMask(1)
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
		render.SetStencilFailOperation(STENCILOPERATION_INCR)
		render.SetStencilPassOperation(STENCILOPERATION_KEEP)
		render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
		render.SetStencilReferenceValue(1)

		draw.NoTexture()
		surface.SetDrawColor(Color(0, 0, 255, 200))
		surface.DrawTexturedRectRotated(x + h / 2, y + h * 1.5 - h * perc, h * 2, h, rot)

		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)

		draw.RoundedBox(h, x, y, h, h, Color(40, 40, 255, 200))

	render.SetStencilEnable(false)

	render.ClearStencil()
	render.SetStencilEnable(true)
		render.SetStencilWriteMask(1)
		render.SetStencilTestMask(1)
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
		render.SetStencilFailOperation(STENCILOPERATION_INCR)
		render.SetStencilPassOperation(STENCILOPERATION_KEEP)
		render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
		render.SetStencilReferenceValue(1)

		draw.NoTexture()
		surface.SetDrawColor(Color(0, 0, 255, 200))
		surface.DrawTexturedRect(x, y - h * perc, h * 2, h)

		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NOTEQUAL)

		draw.RoundedBox(h, x, y, h, h, Color(0, 0, 255, 220))

	render.SetStencilEnable(false)

	local fontsize = lply:HudValue(ele, "TS")
	if fontsize <= 0 then
		fontsize = 14
	end
	local font = "YRP_" .. fontsize .. "_500"

	draw.SimpleTextOutlined(perc * 100 .. "%", font, x + size / 2, y + size / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0))
end

function HUDAnimated()
	local lply = LocalPlayer()

	if GetGlobalDBool("bool_yrp_hud", false) and lply:GetDString("string_hud_design") == "Animated" then
		HUDAnimatedDrawIcon("AR", AR, lply:Armor() / lply:GetMaxArmor(), lply:Armor())
	end
end
hook.Add("HUDPaint", "yrp_hud_design_Animated", HUDAnimated)
