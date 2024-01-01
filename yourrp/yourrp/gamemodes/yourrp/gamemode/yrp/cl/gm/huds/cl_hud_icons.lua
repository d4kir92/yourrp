--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local HP = Material("vgui/material/icon_favorite.png")
local AR = Material("vgui/material/icon_security.png")
local ST = Material("vgui/material/icon_flash.png")
local BA = Material("vgui/material/icon_battery.png")
local HU = Material("vgui/material/icon_restaurant.png")
local TH = Material("vgui/material/icon_drink.png")
local XP = Material("vgui/material/icon_star.png")
local MO = Material("icon16/money.png")
local SA = Material("icon16/money_add.png")
local CA = Material("vgui/material/icon_timer.png")
local RA = YRP.GetDesignIcon("radiation")
function HUDIconsDrawText(ele, text)
	local lply = LocalPlayer()
	if lply:HudElementVisible(ele) then
		local w = lply:HudValue(ele, "SIZE_W")
		local h = lply:HudValue(ele, "SIZE_H")
		local x = lply:HudValue(ele, "POSI_X")
		local y = lply:HudValue(ele, "POSI_Y")
		local fontsize = lply:HudValue(ele, "TS")
		if fontsize <= 0 then
			fontsize = 14
		end

		local ax = lply:HudValue(ele, "AX")
		local ay = lply:HudValue(ele, "AY")
		if ay == 3 then
			ay = 0
		elseif ay == 4 then
			ay = 2
		end

		x = x + h / 16 + (w - h / 8) / 2 * ax
		y = y + h / 16 + (h - h / 8) / 2 * ay
		local font = "Y_" .. fontsize .. "_500"
		draw.SimpleText(text, font, x, y, Color(255, 255, 255, 255), ax, ay, 1, Color(0, 0, 0, 255))
	end
end

function HUDIconsDrawIcon(ele, icon, perc, text)
	perc = math.Round(perc, 3)
	local lply = LocalPlayer()
	if lply:HudElementVisible(ele) then
		local h = lply:HudValue(ele, "SIZE_H")
		local x = lply:HudValue(ele, "POSI_X")
		local y = lply:HudValue(ele, "POSI_Y")
		local size = h
		--draw.RoundedBox(0, x, y, h, h, Color( 0, 0, 0, 60) )
		if icon then
			surface.SetDrawColor(0, 0, 0, 200)
			surface.SetMaterial(icon)
			surface.DrawTexturedRect(x, y, size, size)
		end

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
		surface.SetDrawColor(Color(0, 255, 0))
		surface.DrawTexturedRect(x, y + size - size * perc, size, size * perc)
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
		if icon then
			surface.SetDrawColor(lply:HudValue(ele, "BA"))
			surface.SetMaterial(icon)
			surface.DrawTexturedRect(x, y, size, size)
		end

		render.SetStencilEnable(false)
		local fontsize = lply:HudValue(ele, "TS")
		if fontsize <= 0 then
			fontsize = 14
		end

		local font = "Y_" .. fontsize .. "_500"
		draw.SimpleText(text or perc * 100 .. "%", font, x + size / 2, y + size / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
	end
end

local fps = 0
local fps_delay = CurTime()
local ping = 0
local ping_delay = CurTime()
function HUDIcons()
	local lply = LocalPlayer()
	if YRP and YRP.GetDesignIcon and lply:LoadedGamemode() and YRPIsScoreboardVisible and not YRPIsScoreboardVisible() and GetGlobalYRPBool("bool_yrp_hud", false) and lply:GetHudDesignName() == "Icons" then
		HUDIconsDrawIcon("HP", HP, lply:Health() / lply:GetMaxHealth())
		HUDIconsDrawIcon("AR", AR, lply:Armor() / lply:GetMaxArmor())
		HUDIconsDrawIcon("ST", ST, lply:Stamina() / lply:GetMaxStamina())
		HUDIconsDrawIcon("HU", HU, lply:Hunger() / lply:GetMaxStamina())
		HUDIconsDrawIcon("TH", TH, lply:Thirst() / lply:GetMaxStamina())
		HUDIconsDrawIcon("RA", RA, lply:Radiation() / lply:GetMaxRadiation())
		if IsLevelSystemEnabled() then
			local tab = {}
			tab["LEVEL"] = lply:Level()
			HUDIconsDrawIcon("XP", XP, lply:XP() / lply:GetMaxXP(), YRP.trans("LID_levelx", tab) .. " ( " .. math.Round(lply:XP() / lply:GetMaxXP() * 100, 0) .. "%)")
		end

		HUDIconsDrawIcon("MO", MO, 1, lply:FormattedMoney())
		HUDIconsDrawIcon("SA", SA, lply:CurrentSalaryTime() / lply:SalaryTime(), lply:FormattedSalary())
		if lply:GetYRPBool("iscasting", false) then
			HUDIconsDrawIcon("CA", CA, lply:CastTimeCurrent() / lply:CastTimeMax(), lply:GetCastName())
		end

		local battery = system.BatteryPower()
		HUDIconsDrawIcon("BA", BA, battery / 255)
		HUDIconsDrawText("CR", os.date("%H:%M", os.time()))
		HUDIconsDrawText("CC", lply:YRPFormattedCharPlayTime())
		HUDIconsDrawText("RO", lply:GetRoleName())
		HUDIconsDrawText("NA", lply:RPName())
		if CurTime() > fps_delay then
			fps_delay = CurTime() + 0.5
			fps = GetFPS()
		end

		HUDIconsDrawText("PE", YRP.trans("LID_fps") .. ": " .. fps)
		if CurTime() > ping_delay then
			ping_delay = CurTime() + 0.5
			ping = lply:Ping()
		end

		HUDIconsDrawText("NE", YRP.trans("LID_ping") .. ": " .. ping)
		local weapon = lply:GetActiveWeapon()
		if IsValid(weapon) then
			local wpname = weapon:GetPrintName()
			local clip1 = weapon:Clip1()
			local clip1max = weapon:GetMaxClip1()
			local ammo1 = lply:GetAmmoCount(weapon:GetPrimaryAmmoType())
			local clip2 = weapon:Clip2()
			local clip2max = weapon:GetMaxClip2()
			local ammo2 = lply:GetAmmoCount(weapon:GetSecondaryAmmoType())
			HUDIconsDrawText("WN", wpname)
			HUDIconsDrawText("WP", clip1 .. "/" .. clip1max .. " | " .. ammo1)
			HUDIconsDrawText("WS", clip2 .. "/" .. clip2max .. " | " .. ammo2)
		end

		if lply:Lockdown() then
			HUDIconsDrawText("LO", "[" .. GTS("lockdown") .. "] " .. lply:LockdownText())
		end

		local COM = {}
		COM.element = "COM"
		HUDSimpleBG(COM)
		COM = {}
		COM.element = "COM"
		COM.text = lply:CoordAngle() - lply:CoordAngle() % 5 .. "°"
		HUDSimpleCompass(COM)
		COM = {}
		COM.element = "COM"
		HUDSimpleBR(COM)
	end
end

timer.Simple(
	1,
	function()
		hook.Add("HUDPaint", "yrp_hud_design_Icons", HUDIcons)
	end
)