--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local HP = Material("vgui/material/icon_favorite.png")
local AR = Material("vgui/material/icon_security.png")
local HU = Material("vgui/material/icon_restaurant.png")
local TH = Material("vgui/material/icon_drink.png")
local ST = Material("vgui/material/icon_flash.png")
local XP = Material("vgui/material/icon_star.png")
local BA = Material("vgui/material/icon_battery.png")
local CA = Material("vgui/material/icon_timer.png")
local WP = Material("vgui/material/icon_add.png")
local WS = Material("vgui/material/icon_add_circle.png")
local MO = Material("vgui/material/icon_add.png")
local SA = Material("vgui/material/icon_add_circle.png")
local RA = YRP.GetDesignIcon("radiation")
function drawC(x, y, radius, seg, color)
	surface.SetDrawColor(color)
	draw.NoTexture()
	local cir = {}
	table.insert(
		cir,
		{
			x = x,
			y = y,
			u = 0.5,
			v = 0.5
		}
	)

	for i = 0, seg do
		local a = math.rad((i / seg) * -360)
		table.insert(
			cir,
			{
				x = x + math.sin(a) * radius,
				y = y + math.cos(a) * radius,
				u = math.sin(a) / 2 + 0.5,
				v = math.cos(a) / 2 + 0.5
			}
		)
	end

	local a = math.rad(0) -- This is needed for non absolute segment counts
	table.insert(
		cir,
		{
			x = x + math.sin(a) * radius,
			y = y + math.cos(a) * radius,
			u = math.sin(a) / 2 + 0.5,
			v = math.cos(a) / 2 + 0.5
		}
	)

	surface.DrawPoly(cir)
end

function HUDCirclesDrawIcon(ele, icon, perc, text)
	perc = math.Round(perc, 3)
	local lply = LocalPlayer()
	if lply:HudElementVisible(ele) then
		local color = lply:HudValue(ele, "BA")
		local h = lply:HudValue(ele, "SIZE_H")
		local x = lply:HudValue(ele, "POSI_X")
		local y = lply:HudValue(ele, "POSI_Y")
		local size = h
		local midx = x + h / 2
		local midy = y + h / 2
		local br = YRP.ctr(12)
		local barsize = h - br * 2
		local fill = barsize * perc
		--draw.RoundedBox(0, x, y, h, h, Color( 255, 255, 0, 100) )
		-- BAR
		render.ClearStencil()
		render.SetStencilEnable(true)
		render.SetStencilWriteMask(1)
		render.SetStencilTestMask(1)
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
		render.SetStencilFailOperation(STENCILOPERATION_INCR)
		render.SetStencilPassOperation(STENCILOPERATION_KEEP)
		render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
		render.SetStencilReferenceValue(1)
		drawC(midx, midy, barsize / 2, 32, Color(0, 0, 0, 255))
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
		draw.RoundedBox(0, x + br, y + br + barsize - fill, barsize, fill, color)
		render.SetStencilEnable(false)
		-- BR
		render.ClearStencil()
		render.SetStencilEnable(true)
		render.SetStencilWriteMask(1)
		render.SetStencilTestMask(1)
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
		render.SetStencilFailOperation(STENCILOPERATION_INCR)
		render.SetStencilPassOperation(STENCILOPERATION_KEEP)
		render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
		render.SetStencilReferenceValue(1)
		drawC(midx, midy, (h / 2) - 6, 32, Color(0, 0, 0, 100))
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NOTEQUAL)
		drawC(midx, midy, h / 2, 32, Color(0, 0, 0, 255))
		render.SetStencilEnable(false)
		if icon then
			surface.SetDrawColor(Color(255, 255, 255, 255))
			surface.SetMaterial(icon)
			surface.DrawTexturedRect(x + h / 2 - 32, y + h / 2 - 32, 64, 64)
		end

		local fontsize = lply:HudValue(ele, "TS")
		if fontsize <= 0 then
			fontsize = 14
		end

		local font = "Y_" .. fontsize .. "_500"
		draw.SimpleText(text or perc * 100 .. "%", font, x + size / 2, y + size / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 255))
	end
end

function HUDCirclesDrawText(ele, text)
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

		local font = "Y_" .. fontsize .. "_500"
		local ax = lply:HudValue(ele, "AX")
		local ay = lply:HudValue(ele, "AY")
		local midx = x + (ax * w) / 2
		local midy = y + (ay * h) / 2
		draw.SimpleText(text, font, midx, midy, Color(255, 255, 255, 255), ax, ay, 2, Color(0, 0, 0, 255))
	end
end

function HUDCircles()
	local lply = LocalPlayer()
	if YRP and YRP.GetDesignIcon and lply:LoadedGamemode() and YRPIsScoreboardVisible and not YRPIsScoreboardVisible() and GetGlobalYRPBool("bool_yrp_hud", false) and lply:GetHudDesignName() == "Circles" then
		HUDCirclesDrawIcon("HP", HP, lply:Health() / lply:GetMaxHealth())
		HUDCirclesDrawIcon("AR", AR, lply:Armor() / lply:GetMaxArmor())
		HUDCirclesDrawIcon("HU", HU, lply:Hunger() / lply:GetMaxHunger())
		HUDCirclesDrawIcon("TH", TH, lply:Thirst() / lply:GetMaxThirst())
		HUDCirclesDrawIcon("ST", ST, lply:Stamina() / lply:GetMaxStamina())
		HUDCirclesDrawIcon("RA", RA, lply:Radiation() / lply:GetMaxRadiation())
		if IsLevelSystemEnabled() then
			local tab = {}
			tab["LEVEL"] = lply:Level()
			HUDCirclesDrawIcon("XP", XP, lply:XP() / lply:GetMaxXP(), YRP.trans("LID_levelx", tab) .. " ( " .. lply:XP() .. "%)")
		end

		if lply:Battery() < 100 then
			HUDCirclesDrawIcon("BA", BA, lply:Battery() / lply:GetMaxBattery())
		end

		if lply:CastTimeCurrent() / lply:CastTimeMax() > 0 then
			HUDCirclesDrawIcon("CA", CA, lply:CastTimeCurrent() / lply:CastTimeMax(), lply:GetCastName() .. " ( " .. math.Round(lply:CastTimeCurrent() / lply:CastTimeMax() * 100, 0) .. "%)")
		end

		HUDCirclesDrawText("RO", lply:GetRoleName())
		HUDCirclesDrawText("NA", lply:RPName())
		HUDCirclesDrawText("CR", os.date("%H:%M", os.time()))
		HUDCirclesDrawText("CC", lply:YRPFormattedCharPlayTime())
		HUDCirclesDrawText("PE", YRP.trans("LID_fps") .. ": " .. GetFPS())
		HUDCirclesDrawText("NE", YRP.trans("LID_ping") .. ": " .. lply:Ping())
		local wep = lply:GetActiveWeapon()
		if wep ~= NULL then
			local clip1 = wep:Clip1()
			local maxclip1 = wep:GetMaxClip1()
			local ammo1 = lply:GetAmmoCount(wep:GetPrimaryAmmoType())
			local am1t = ""
			if clip1 > -1 then
				am1t = am1t .. clip1 .. "/" .. maxclip1
			end

			if ammo1 > -1 then
				if am1t ~= "" then
					am1t = am1t .. "|"
				end

				am1t = am1t .. ammo1
			end

			if not strEmpty(am1t) then
				HUDCirclesDrawIcon("WP", WP, clip1 / maxclip1, am1t)
			end

			local clip2 = wep:Clip2()
			local maxclip2 = wep:GetMaxClip2()
			local ammo2 = lply:GetAmmoCount(wep:GetSecondaryAmmoType())
			local am2t = ""
			if clip2 > -1 then
				am2t = am2t .. clip2 .. "/" .. maxclip2
			end

			if ammo2 > -1 then
				if am2t ~= "" then
					am2t = am2t .. "|"
				end

				am2t = am2t .. ammo2
			end

			if not strEmpty(am2t) then
				HUDCirclesDrawIcon("WS", WS, clip2 / maxclip2, am2t)
			end

			HUDCirclesDrawText("WN", wep:GetPrintName())
		end

		HUDCirclesDrawText("SN", GetGlobalYRPString("text_server_name", "SERVERNAME"))
		HUDCirclesDrawIcon("MO", MO, 1, lply:FormattedMoney())
		HUDCirclesDrawIcon("SA", SA, lply:CurrentSalaryTime() / lply:SalaryTime(), lply:FormattedSalary())
		HUDSimpleCompass()
	end
end

timer.Simple(
	1,
	function()
		hook.Add("HUDPaint", "yrp_hud_design_Circles", HUDCircles)
	end
)