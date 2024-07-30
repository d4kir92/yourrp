--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
function fake_true()
	return true
end

local Simple = {}
function HUDSimpleBG(tab)
	local lply = LocalPlayer()
	if lply:HudValue(tab.element, "VISI") and lply:HudValue(tab.element, "BACK") and lply:HudElementVisible(tab.element) then
		tab.visiblefunc = tab.visiblefunc or fake_true
		if tab.visiblefunc() then
			Simple[tab.element] = Simple[tab.element] or {}
			Simple[tab.element]["background"] = Simple[tab.element]["background"] or {}
			if GetGlobalYRPInt("YRPHUDVersion", -1) ~= Simple[tab.element]["background"]["version"] then
				Simple[tab.element]["background"]["version"] = GetGlobalYRPInt("YRPHUDVersion", -1)
				local w = lply:HudValue(tab.element, "SIZE_W")
				local h = lply:HudValue(tab.element, "SIZE_H")
				local x = lply:HudValue(tab.element, "POSI_X")
				local y = lply:HudValue(tab.element, "POSI_Y")
				Simple[tab.element]["background"].w = w
				Simple[tab.element]["background"].h = h
				Simple[tab.element]["background"].fx = x
				Simple[tab.element]["background"].fy = y
				Simple[tab.element]["background"].r = 0
				if lply:HudValue(tab.element, "ROUN") then
					Simple[tab.element]["background"].r = tab.r or YRP:ctr(15)
				end

				Simple[tab.element]["background"].color = lply:HudValue(tab.element, "BG")
			else
				if tab.a ~= nil then
					Simple[tab.element]["background"].color = lply:HudValue(tab.element, "BG")
					Simple[tab.element]["background"].color.a = tab.a
				end

				Simple[tab.element]["background"].x = HUDMOTIONX(Simple[tab.element]["background"].fx)
				Simple[tab.element]["background"].y = HUDMOTIONY(Simple[tab.element]["background"].fy)
				draw.RoundedBox(Simple[tab.element]["background"].r, Simple[tab.element]["background"].x, Simple[tab.element]["background"].y, Simple[tab.element]["background"].w, Simple[tab.element]["background"].h, Simple[tab.element]["background"].color)
			end
		end
	end
end

function HUDSimpleBAR(tab)
	local lply = LocalPlayer()
	if lply:HudValue(tab.element, "VISI") and lply:HudElementVisible(tab.element) then
		Simple[tab.element] = Simple[tab.element] or {}
		Simple[tab.element]["bar"] = Simple[tab.element]["bar"] or {}
		Simple[tab.element]["icon"] = Simple[tab.element]["icon"] or {}
		Simple[tab.element]["text"] = Simple[tab.element]["text"] or {}
		if GetGlobalYRPInt("YRPHUDVersion", -1) ~= Simple[tab.element]["bar"]["version"] then
			Simple[tab.element]["bar"]["version"] = GetGlobalYRPInt("YRPHUDVersion", -1)
			local w = lply:HudValue(tab.element, "SIZE_W")
			local h = lply:HudValue(tab.element, "SIZE_H")
			local x = lply:HudValue(tab.element, "POSI_X")
			local y = lply:HudValue(tab.element, "POSI_Y")
			Simple[tab.element]["bar"].fw = w
			Simple[tab.element]["bar"].fh = h
			Simple[tab.element]["bar"].fx = x
			Simple[tab.element]["bar"].fy = y
			Simple[tab.element]["bar"].w = w
			Simple[tab.element]["bar"].h = h
			Simple[tab.element]["bar"].x = x
			Simple[tab.element]["bar"].y = y
			Simple[tab.element]["bar"].r = 0
			if lply:HudValue(tab.element, "ROUN") then
				Simple[tab.element]["bar"].r = tab.r or YRP:ctr(15)
			end

			Simple[tab.element]["bar"].color = lply:HudValue(tab.element, "BA")
			Simple[tab.element]["text"].ax = lply:HudValue(tab.element, "AX")
			Simple[tab.element]["text"].ay = lply:HudValue(tab.element, "AY")
			local ax = Simple[tab.element]["text"].ax
			local ay = Simple[tab.element]["text"].ay
			if lply:HudValue(tab.element, "ROUN") then
				Simple[tab.element]["text"].fx = x + h / 2 + (w - h) / 2 * ax
				Simple[tab.element]["text"].fy = y + h / 16 + (h - h / 8) / 2 * ay
			else
				Simple[tab.element]["text"].fx = x + h / 16 + (w - h / 8) / 2 * ax
				Simple[tab.element]["text"].fy = y + h / 16 + (h - h / 8) / 2 * ay
			end

			Simple[tab.element]["text"].text = tab.element
			local fontsize = lply:HudValue(tab.element, "TS")
			if fontsize <= 0 then
				fontsize = 14
			end

			Simple[tab.element]["text"].font = "Y_" .. fontsize .. "_500"
			Simple[tab.element]["text"].color = lply:HudValue(tab.element, "TE")
			Simple[tab.element]["text"].brcolor = lply:HudValue(tab.element, "TB")
			if Simple[tab.element]["bar"].fw > Simple[tab.element]["bar"].fh then
				Simple[tab.element]["icon"].w = Simple[tab.element]["bar"].fh * 0.75
				Simple[tab.element]["icon"].h = Simple[tab.element]["bar"].fh * 0.75
				Simple[tab.element]["icon"].w = Simple[tab.element]["icon"].w - Simple[tab.element]["icon"].w % 4
				Simple[tab.element]["icon"].h = Simple[tab.element]["icon"].h - Simple[tab.element]["icon"].h % 4
				local br = (Simple[tab.element]["bar"].fh - Simple[tab.element]["icon"].h) / 2
				Simple[tab.element]["icon"].fx = Simple[tab.element]["bar"].x + br
				Simple[tab.element]["icon"].fy = Simple[tab.element]["bar"].y + br
			else
				Simple[tab.element]["icon"].w = Simple[tab.element]["bar"].fw * 0.75
				Simple[tab.element]["icon"].h = Simple[tab.element]["bar"].fw * 0.75
				Simple[tab.element]["icon"].w = Simple[tab.element]["icon"].w - Simple[tab.element]["icon"].w % 4
				Simple[tab.element]["icon"].h = Simple[tab.element]["icon"].h - Simple[tab.element]["icon"].h % 4
				local br = (Simple[tab.element]["bar"].fw - Simple[tab.element]["icon"].w) / 2
				Simple[tab.element]["icon"].fx = Simple[tab.element]["bar"].x + br
				Simple[tab.element]["icon"].fy = Simple[tab.element]["bar"].y + br
			end
		else
			Simple[tab.element]["bar"].x = HUDMOTIONX(Simple[tab.element]["bar"].fx)
			Simple[tab.element]["bar"].y = HUDMOTIONY(Simple[tab.element]["bar"].fy)
			Simple[tab.element]["text"].x = HUDMOTIONX(Simple[tab.element]["text"].fx)
			Simple[tab.element]["text"].y = HUDMOTIONY(Simple[tab.element]["text"].fy)
			Simple[tab.element]["icon"].x = HUDMOTIONX(Simple[tab.element]["icon"].fx)
			Simple[tab.element]["icon"].y = HUDMOTIONY(Simple[tab.element]["icon"].fy)
			if tab.max ~= nil and tab.cur ~= nil then
				if Simple[tab.element]["bar"].fw > Simple[tab.element]["bar"].fh then
					Simple[tab.element]["bar"].h = Simple[tab.element]["bar"].fh
					Simple[tab.element]["bar"].w = Simple[tab.element]["bar"].fw / tab.max * tab.cur
				else
					Simple[tab.element]["bar"].h = Simple[tab.element]["bar"].fh / tab.max * tab.cur
					Simple[tab.element]["bar"].y = Simple[tab.element]["bar"].fy + Simple[tab.element]["bar"].fh - Simple[tab.element]["bar"].h
				end

				YRPHudBox(Simple[tab.element]["bar"])
			end

			if lply:HudValue(tab.element, "ICON") and tab.icon and YRP:GetDesignIcon(tab.icon) then
				local ico = tab.icon
				YRP:DrawIcon(YRP:GetDesignIcon(ico), Simple[tab.element]["icon"].w, Simple[tab.element]["icon"].h, Simple[tab.element]["icon"].x, Simple[tab.element]["icon"].y, Color(255, 255, 255, 255))
			end

			Simple[tab.element]["text"].text = ""
			if tab.text ~= nil and lply:HudValue(tab.element, "TEXT") then
				Simple[tab.element]["text"].text = tab.text
			end

			if tab.percentage ~= nil and lply:HudValue(tab.element, "PERC") then
				Simple[tab.element]["text"].text = Simple[tab.element]["text"].text .. " " .. tab.percentage
			end

			if tab.tcolor ~= nil then
				Simple[tab.element]["text"].color = tab.tcolor
			end

			if tab.tfont ~= nil then
				Simple[tab.element]["text"].font = tab.tfont
			end

			YRPHudText(Simple[tab.element]["text"])
		end
	end
end

function HUDSimpleBR(tab)
	local lply = LocalPlayer()
	if lply:HudValue(tab.element, "VISI") and lply:HudValue(tab.element, "BORD") and lply:HudElementVisible(tab.element) then
		tab.visiblefunc = tab.visiblefunc or fake_true
		if lply:HudValue(tab.element, "VISI") and tab.visiblefunc() then
			Simple[tab.element] = Simple[tab.element] or {}
			Simple[tab.element]["border"] = Simple[tab.element]["border"] or {}
			if Simple[tab.element]["border"].fx and Simple[tab.element]["border"].fy then
				Simple[tab.element]["border"].x = HUDMOTIONX(Simple[tab.element]["border"].fx)
				Simple[tab.element]["border"].y = HUDMOTIONY(Simple[tab.element]["border"].fy)
			end

			if GetGlobalYRPInt("YRPHUDVersion", -1) ~= Simple[tab.element]["border"]["version"] then
				Simple[tab.element]["border"]["version"] = GetGlobalYRPInt("YRPHUDVersion", -1)
				local w = lply:HudValue(tab.element, "SIZE_W")
				local h = lply:HudValue(tab.element, "SIZE_H")
				local x = lply:HudValue(tab.element, "POSI_X")
				local y = lply:HudValue(tab.element, "POSI_Y")
				Simple[tab.element]["border"].r = 0
				Simple[tab.element]["border"].w = w
				Simple[tab.element]["border"].h = h
				Simple[tab.element]["border"].fx = x
				Simple[tab.element]["border"].fy = y
				Simple[tab.element]["border"].r = 0
				if lply:HudValue(tab.element, "ROUN") then
					Simple[tab.element]["border"].r = tab.r or YRP:ctr(15)
				end

				Simple[tab.element]["border"].color = lply:HudValue(tab.element, "BR")
				Simple[tab.element]["border"].br = YRP:ctr(6)
			elseif lply:HudValue(tab.element, "ROUN") then
				HudBoxBrRounded(Simple[tab.element]["border"])
			else
				HudBoxBr(Simple[tab.element]["border"])
			end
		end
	end
end

function GetFadeAlpha(ox, cx, ow)
	local alpha = 1
	local pos = (cx - ox) / ow
	if pos <= 0.01 then
		alpha = 0
	elseif pos >= 0.99 then
		alpha = 0
	elseif pos <= 0.11 then
		alpha = (pos - 0.01) % 0.10000001 * 10
	elseif pos >= 0.89 then
		alpha = 1 - (pos + 0.01) % 0.10000001 * 10
	elseif pos > 0.468 and pos < 0.532 then
		alpha = 0.1
	else
		alpha = 1
	end

	return alpha
end

function HUDSimpleCompass()
	local lply = LocalPlayer()
	local tab = {}
	local coord = lply:CoordAngle()
	if coord % 90 > 4 and coord % 90 < 86 then
		tab.text = lply:CoordAngle() - lply:CoordAngle() % 5 .. "°"
	elseif coord >= 355 or coord <= 5 then
		tab.text = YRP:trans("LID_north_short")
	elseif coord >= 175 and coord <= 185 then
		tab.text = YRP:trans("LID_south_short")
	elseif coord >= 265 and coord <= 275 then
		tab.text = YRP:trans("LID_west_short")
	elseif coord >= 85 and coord <= 95 then
		tab.text = YRP:trans("LID_east_short")
	else
		tab.text = "FAILED! " .. coord
	end

	tab.visiblefunc = tab.visiblefunc or fake_true
	if lply:HudValue("COM", "VISI") and tab.visiblefunc() then
		Simple["COM"] = Simple["COM"] or {}
		Simple["COM"]["needle"] = Simple["COM"]["needle"] or {}
		Simple["COM"]["degree"] = Simple["COM"]["degree"] or {}
		Simple["COM"]["north"] = Simple["COM"]["north"] or {}
		Simple["COM"]["south"] = Simple["COM"]["south"] or {}
		Simple["COM"]["east"] = Simple["COM"]["east"] or {}
		Simple["COM"]["west"] = Simple["COM"]["west"] or {}
		if GetGlobalYRPInt("YRPHUDVersion", -1) ~= Simple["COM"]["degree"]["version"] then
			Simple["COM"]["degree"]["version"] = GetGlobalYRPInt("YRPHUDVersion", -1)
			local w = lply:HudValue("COM", "SIZE_W")
			local h = lply:HudValue("COM", "SIZE_H")
			local x = lply:HudValue("COM", "POSI_X")
			local y = lply:HudValue("COM", "POSI_Y")
			Simple["COM"]["needle"].r = 0
			Simple["COM"]["needle"].w = YRP:ctr(4)
			Simple["COM"]["needle"].h = h / 4
			Simple["COM"]["needle"].fx = x + w / 2
			Simple["COM"]["needle"].fy = y
			Simple["COM"]["needle"].color = Color(255, 255, 255, 255)
			local fontsize = lply:HudValue("COM", "TS")
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
			if fontsizes[fsid + 1] ~= nil then
				nextfontsize = fontsizes[fsid + 1]
			elseif fontsizes[fsid] ~= nil then
				nextfontsize = fontsizes[fsid]
			end

			Simple["COM"]["degree"].w = w
			Simple["COM"]["degree"].h = h
			Simple["COM"]["degree"].fx = x + w / 2
			Simple["COM"]["degree"].fy = y + h * 0.50
			Simple["COM"]["degree"].ax = 1
			Simple["COM"]["degree"].ay = 1
			Simple["COM"]["degree"].font = "Y_" .. fontsize .. "_500"
			Simple["COM"]["degree"].color = lply:HudValue("COM", "TE")
			Simple["COM"]["degree"].brcolor = lply:HudValue("COM", "TB")
			Simple["COM"]["north"].w = w
			Simple["COM"]["north"].h = h
			Simple["COM"]["north"].fx = x + w / 2
			Simple["COM"]["north"].fy = y + h * 0.50
			Simple["COM"]["north"].ax = 1
			Simple["COM"]["north"].ay = 1
			Simple["COM"]["north"].font = "Y_" .. nextfontsize .. "_500"
			Simple["COM"]["north"].color = lply:HudValue("COM", "TE")
			Simple["COM"]["north"].brcolor = lply:HudValue("COM", "TB")
			Simple["COM"]["north"].text = YRP:trans("LID_north_short")
			Simple["COM"]["south"].w = w
			Simple["COM"]["south"].h = h
			Simple["COM"]["south"].fx = x + w / 2
			Simple["COM"]["south"].fy = y + h * 0.50
			Simple["COM"]["south"].ax = 1
			Simple["COM"]["south"].ay = 1
			Simple["COM"]["south"].font = "Y_" .. nextfontsize .. "_500"
			Simple["COM"]["south"].color = lply:HudValue("COM", "TE")
			Simple["COM"]["south"].brcolor = lply:HudValue("COM", "TB")
			Simple["COM"]["south"].text = YRP:trans("LID_south_short")
			Simple["COM"]["east"].w = w
			Simple["COM"]["east"].h = h
			Simple["COM"]["east"].fx = x + w / 2
			Simple["COM"]["east"].fy = y + h * 0.50
			Simple["COM"]["east"].ax = 1
			Simple["COM"]["east"].ay = 1
			Simple["COM"]["east"].font = "Y_" .. nextfontsize .. "_500"
			Simple["COM"]["east"].color = lply:HudValue("COM", "TE")
			Simple["COM"]["east"].brcolor = lply:HudValue("COM", "TB")
			Simple["COM"]["east"].text = YRP:trans("LID_east_short")
			Simple["COM"]["west"].w = w
			Simple["COM"]["west"].h = h
			Simple["COM"]["west"].fx = x + w / 2
			Simple["COM"]["west"].fy = y + h * 0.50
			Simple["COM"]["west"].ax = 1
			Simple["COM"]["west"].ay = 1
			Simple["COM"]["west"].font = "Y_" .. nextfontsize .. "_500"
			Simple["COM"]["west"].color = lply:HudValue("COM", "TE")
			Simple["COM"]["west"].brcolor = lply:HudValue("COM", "TB")
			Simple["COM"]["west"].text = YRP:trans("LID_west_short")
			for i = 0, 360, 30 do
				if i % 90 ~= 0 then
					Simple["COM"][i .. "num"] = {}
					Simple["COM"][i .. "num"].w = 2
					Simple["COM"][i .. "num"].h = 12
					Simple["COM"][i .. "num"].fx = x + 2 / 2
					Simple["COM"][i .. "num"].fy = y + h / 2
					Simple["COM"][i .. "num"].ax = 1
					Simple["COM"][i .. "num"].ay = 1
					Simple["COM"][i .. "num"].text = (i + 180) % 360
					Simple["COM"][i .. "num"].color = Color(255, 255, 255, 200)
					Simple["COM"][i .. "num"].font = "Y_" .. fontsize .. "_500"
					Simple["COM"][i .. "num"].color = lply:HudValue("COM", "TE")
					Simple["COM"][i .. "num"].brcolor = lply:HudValue("COM", "TB")
				end
			end
		else
			local w = lply:HudValue("COM", "SIZE_W")
			local h = lply:HudValue("COM", "SIZE_H")
			local x = lply:HudValue("COM", "POSI_X")
			local y = lply:HudValue("COM", "POSI_Y")
			Simple["COM"]["needle"].x = HUDMOTIONX(Simple["COM"]["needle"].fx)
			Simple["COM"]["needle"].y = HUDMOTIONY(Simple["COM"]["needle"].fy)
			Simple["COM"]["degree"].x = HUDMOTIONX(Simple["COM"]["degree"].fx)
			Simple["COM"]["degree"].y = HUDMOTIONY(Simple["COM"]["degree"].fy)
			Simple["COM"]["north"].x = HUDMOTIONX(Simple["COM"]["north"].fx)
			Simple["COM"]["north"].y = HUDMOTIONY(Simple["COM"]["north"].fy)
			Simple["COM"]["south"].x = HUDMOTIONX(Simple["COM"]["south"].fx)
			Simple["COM"]["south"].y = HUDMOTIONY(Simple["COM"]["south"].fy)
			Simple["COM"]["east"].x = HUDMOTIONX(Simple["COM"]["east"].fx)
			Simple["COM"]["east"].y = HUDMOTIONY(Simple["COM"]["east"].fy)
			Simple["COM"]["west"].x = HUDMOTIONX(Simple["COM"]["west"].fx)
			Simple["COM"]["west"].y = HUDMOTIONY(Simple["COM"]["west"].fy)
			for i = 0, 360, 30 do
				if i % 90 ~= 0 then
					Simple["COM"][i .. "num"].x = HUDMOTIONX(Simple["COM"][i .. "num"].fx)
					Simple["COM"][i .. "num"].y = HUDMOTIONY(Simple["COM"][i .. "num"].fy)
				end
			end

			draw.RoundedBox(0, HUDMOTIONX(x), HUDMOTIONY(y + YRP:ctr(12)), w, YRP:ctr(4), Color(255, 255, 255, 50))
			draw.RoundedBox(0, HUDMOTIONX(x), HUDMOTIONY(y + h - YRP:ctr(12) - YRP:ctr(4)), w, YRP:ctr(4), Color(255, 255, 255, 50))
			x = Simple["COM"]["degree"].x - Simple["COM"]["north"].w / 2
			w = Simple["COM"]["north"].w
			local fw = (w * (lply:CoordAngle() / 360)) * -1
			-- striche
			for i = 0, 360, 30 do
				if i % 90 ~= 0 then
					--Simple["COM"][i].x = x + (fw + w * i / 360) % w
					--YRPHudBox(Simple["COM"][i])
					Simple["COM"][i .. "num"].x = x + (fw + w * i / 360) % w
					local alpha = GetFadeAlpha(x, Simple["COM"][i .. "num"].x, w)
					Simple["COM"][i .. "num"].color = Color(255, 255, 255, alpha * 255)
					Simple["COM"][i .. "num"].brcolor = Color(0, 0, 0, alpha * 255 * 0.7)
					YRPHudText(Simple["COM"][i .. "num"])
				end
			end

			-- North
			Simple["COM"]["north"].x = x + (fw + w * 0.5) % w
			Simple["COM"]["north"].text = YRP:trans("LID_north_short")
			local alpha = GetFadeAlpha(x, Simple["COM"]["north"].x, w)
			Simple["COM"]["north"].color = Color(255, 255, 255, alpha * 255)
			Simple["COM"]["north"].brcolor = Color(0, 0, 0, alpha * 255 * 0.7)
			YRPHudText(Simple["COM"]["north"])
			-- South
			Simple["COM"]["south"].x = x + (fw + w * 0.0) % w
			Simple["COM"]["south"].text = YRP:trans("LID_south_short")
			alpha = GetFadeAlpha(x, Simple["COM"]["south"].x, w)
			Simple["COM"]["south"].color = Color(255, 255, 255, alpha * 255)
			Simple["COM"]["south"].brcolor = Color(0, 0, 0, alpha * 255 * 0.7)
			YRPHudText(Simple["COM"]["south"])
			-- East
			Simple["COM"]["east"].x = x + (fw + w * 0.75) % w
			Simple["COM"]["east"].text = YRP:trans("LID_east_short")
			alpha = GetFadeAlpha(x, Simple["COM"]["east"].x, w)
			Simple["COM"]["east"].color = Color(255, 255, 255, alpha * 255)
			Simple["COM"]["east"].brcolor = Color(0, 0, 0, alpha * 255 * 0.7)
			YRPHudText(Simple["COM"]["east"])
			-- West
			Simple["COM"]["west"].x = x + (fw + w * 0.25) % w
			Simple["COM"]["west"].text = YRP:trans("LID_west_short")
			alpha = GetFadeAlpha(x, Simple["COM"]["west"].x, w)
			Simple["COM"]["west"].color = Color(255, 255, 255, alpha * 255)
			Simple["COM"]["west"].brcolor = Color(0, 0, 0, alpha * 255 * 0.7)
			YRPHudText(Simple["COM"]["west"])
			-- Degree Number
			Simple["COM"]["degree"].text = tab.text
			YRPHudText(Simple["COM"]["degree"])
			-- Needle
			--YRPHudBox(Simple["COM"]["needle"])
			local triangle = {
				{
					x = Simple["COM"]["needle"].x - 5,
					y = Simple["COM"]["needle"].y + h - 7
				},
				{
					x = Simple["COM"]["needle"].x,
					y = Simple["COM"]["needle"].y + h - 7 - 8
				},
				{
					x = Simple["COM"]["needle"].x + 5,
					y = Simple["COM"]["needle"].y + h - 7
				}
			}

			surface.SetDrawColor(255, 255, 255, 180)
			draw.NoTexture()
			surface.DrawPoly(triangle)
			local triangle2 = {
				{
					x = Simple["COM"]["needle"].x - 5,
					y = Simple["COM"]["needle"].y + 7
				},
				{
					x = Simple["COM"]["needle"].x + 5,
					y = Simple["COM"]["needle"].y + 7
				},
				{
					x = Simple["COM"]["needle"].x,
					y = Simple["COM"]["needle"].y + 7 + 8
				},
			}

			surface.SetDrawColor(255, 255, 255, 180)
			draw.NoTexture()
			surface.DrawPoly(triangle2)
		end
	end
end

local _fps = 144
local _fps_delay = 0
function FPS_Think()
	if CurTime() > _fps_delay then
		_fps_delay = CurTime() + 0.5
		_fps = math.Round(1 / RealFrameTime())
	end
end

hook.Add("HUDPaint", "yrp_think_fps", FPS_Think)
function GetFPS()
	return _fps
end

local fps = 0
local fpsmin = 9999
local fpsmax = 0
local fpsavg = fps
local fpstavg = 0
local fpscou = 0
local fps_delay = 0
local fpscolor = Color(0, 0, 0, 255)
local ping = 0
local pingmin = 9999
local pingmax = 0
local pingavg = ping
local pingtavg = 0
local pingcou = 0
local ping_delay = 0
local pingcolor = Color(0, 0, 0, 255)
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
function HUDSimple()
	local lply = LocalPlayer()
	if YRP and YRP.GetDesignIcon and lply:LoadedGamemode() and YRPIsScoreboardVisible and not YRPIsScoreboardVisible() and GetGlobalYRPBool("bool_yrp_hud", false) and lply:GetHudDesignName() == "Simple" then
		local batterypower = system.BatteryPower()
		-- Background
		for i = 1, 10 do
			local BOX = {}
			BOX.element = "BOX" .. i
			HUDSimpleBG(BOX)
		end

		local SN = {}
		SN.element = "SN"
		HUDSimpleBG(SN)
		local NA = {}
		NA.element = "NA"
		HUDSimpleBG(NA)
		local ID = {}
		ID.element = "ID"
		HUDSimpleBG(ID)
		local CR = {}
		CR.element = "CR"
		local CC = {}
		CC.element = "CC"
		HUDSimpleBG(CR)
		local HP = {}
		HP.element = "HP"
		HUDSimpleBG(HP)
		local AR = {}
		AR.element = "AR"
		HUDSimpleBG(AR)
		if IsLevelSystemEnabled() then
			local XP = {}
			XP.element = "XP"
			HUDSimpleBG(XP)
		end

		local MO = {}
		MO.element = "MO"
		HUDSimpleBG(MO)
		local SA = {}
		SA.element = "SA"
		HUDSimpleBG(SA)
		local RO = {}
		RO.element = "RO"
		HUDSimpleBG(RO)
		if GetGlobalYRPBool("bool_stamina", false) then
			local ST = {}
			ST.element = "ST"
			HUDSimpleBG(ST)
		end

		if GetGlobalYRPBool("bool_radiation", false) then
			local RA = {}
			RA.element = "RA"
			HUDSimpleBG(RA)
		end

		if lply:HudElementVisible("HU") then
			local HU = {}
			HU.element = "HU"
			HUDSimpleBG(HU)
		end

		if GetGlobalYRPBool("bool_thirst", false) then
			local TH = {}
			TH.element = "TH"
			HUDSimpleBG(TH)
		end

		if GetGlobalYRPBool("bool_permille", false) then
			local AL = {}
			AL.element = "AL"
			HUDSimpleBG(AL)
		end

		if lply:GetYRPBool("iscasting", false) then
			local CA = {}
			CA.element = "CA"
			HUDSimpleBG(CA)
		end

		local AB = {}
		AB.element = "AB"
		HUDSimpleBG(AB)
		local WP = {}
		WP.element = "WP"
		WP.visible = false
		local WS = {}
		WS.element = "WS"
		WS.visible = false
		local WN = {}
		WN.element = "WN"
		local weapon = lply:GetActiveWeapon()
		if IsValid(weapon) then
			local clip1 = weapon:Clip1()
			local clip1max = weapon:GetMaxClip1()
			local ammo1 = lply:GetAmmoCount(weapon:GetPrimaryAmmoType())
			local clip2 = weapon:Clip2()
			local clip2max = weapon:GetMaxClip2()
			local ammo2 = lply:GetAmmoCount(weapon:GetSecondaryAmmoType())
			if clip1 > 0 or ammo1 > 0 then
				WP.visible = true
				WP.cur = clip1
				WP.max = clip1max
				WP.text = ""
				if clip1 > 0 then
					WP.text = clip1 .. " / " .. clip1max
				end

				if ammo1 > 0 then
					if WP.text ~= "" then
						WP.text = WP.text .. " | "
					end

					WP.text = WP.text .. ammo1
				end
			end

			if clip2 > 0 or ammo2 > 0 then
				WS.visible = true
				WS.cur = clip2
				WS.max = clip2max
				WS.text = ""
				if clip2 > 0 then
					WS.text = clip2 .. " / " .. clip2max
				end

				if ammo2 > 0 then
					if WS.text ~= "" then
						WS.text = WS.text .. " | "
					end

					WS.text = WS.text .. ammo2
				end
			end

			WN.cur = 1
			WN.max = 1
			WN.text = lply:GetActiveWeapon():GetPrintName()
		end

		if WP.visible then
			HUDSimpleBG(WP)
		end

		if WS.visible then
			HUDSimpleBG(WS)
		end

		HUDSimpleBG(WN)
		if batterypower <= 100 then
			local BA = {}
			BA.element = "BA"
			HUDSimpleBG(BA)
		end

		if not strEmpty(lply:Condition()) then
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
		local PM = {}
		PM.element = "PM"
		HUDSimpleBG(PM)
		-- Midground
		for i = 1, 10 do
			local BOX = {}
			BOX.element = "BOX" .. i
			BOX.cur = 1
			BOX.max = 1
			BOX.text = ""
			HUDSimpleBAR(BOX)
		end

		SN = {}
		SN.element = "SN"
		SN.cur = 0
		SN.max = 1
		SN.text = GetGlobalYRPString("text_server_name", "SERVERNAME")
		HUDSimpleBAR(SN)
		NA = {}
		NA.element = "NA"
		NA.cur = 0
		NA.max = 1
		NA.text = lply:RPName()
		NA.icon = icons["NA"]
		HUDSimpleBAR(NA)
		ID = {}
		ID.element = "ID"
		ID.cur = 0
		ID.max = 1
		ID.text = lply:GetYRPString("idcardid", "")
		ID.icon = icons["ID"]
		HUDSimpleBAR(ID)
		CR = {}
		CR.element = "CR"
		CR.cur = 0
		CR.max = 1
		CR.text = os.date("%H:%M", os.time())
		CR.icon = icons["CR"]
		HUDSimpleBAR(CR)
		CC = {}
		CC.element = "CC"
		CC.cur = 0
		CC.max = 1
		CC.text = lply:YRPFormattedCharPlayTime()
		CC.icon = icons["CC"]
		HUDSimpleBAR(CC)
		HP = {}
		HP.element = "HP"
		HP.cur = lply:Health()
		HP.max = lply:GetMaxHealth()
		HP.text = lply:Health() .. "/" .. lply:GetMaxHealth()
		HP.percentage = math.Round(lply:Health() / lply:GetMaxHealth() * 100, 0) .. "%"
		HP.icon = icons["HP"]
		HUDSimpleBAR(HP)
		AR = {}
		AR.element = "AR"
		AR.cur = lply:Armor()
		AR.max = lply:GetMaxArmor()
		AR.text = lply:Armor() .. "/" .. lply:GetMaxArmor()
		AR.percentage = math.Round(lply:Armor() / lply:GetMaxArmor() * 100) .. "%"
		AR.icon = icons["AR"]
		HUDSimpleBAR(AR)
		XP = {}
		if IsLevelSystemEnabled() then
			XP.element = "XP"
			XP.cur = lply:XP()
			XP.max = lply:GetMaxXP()
			if XP.cur < XP.max then
				XP.text = YRP:trans("LID_xp") .. ": " .. lply:XP() .. "/" .. lply:GetMaxXP() .. " ( " .. math.Round(lply:XP() / lply:GetMaxXP() * 100, 0) .. "%) " .. YRP:trans("LID_level") .. " " .. lply:Level()
			else
				XP.text = YRP:trans("LID_level") .. " " .. lply:Level()
			end

			HUDSimpleBAR(XP)
		end

		MO = {}
		MO.element = "MO"
		MO.cur = 1
		MO.max = 1
		MO.text = lply:FormattedMoney()
		MO.icon = icons["MO"]
		HUDSimpleBAR(MO)
		SA = {}
		SA.element = "SA"
		SA.cur = lply:CurrentSalaryTime()
		SA.max = lply:SalaryTime()
		SA.text = "+" .. lply:FormattedSalary()
		SA.icon = icons["SA"]
		HUDSimpleBAR(SA)
		RO = {}
		RO.element = "RO"
		RO.cur = 0
		RO.max = 1
		RO.text = lply:GetRoleName()
		RO.icon = icons["RO"]
		--RO.tcolor = lply:GetRoleColor()
		HUDSimpleBAR(RO)
		if GetGlobalYRPBool("bool_stamina", false) then
			local ST = {}
			ST.element = "ST"
			ST.cur = lply:Stamina()
			ST.max = lply:GetMaxStamina()
			ST.text = lply:Stamina() .. " / " .. lply:GetMaxStamina()
			ST.percentage = math.Round(lply:Stamina() / lply:GetMaxStamina() * 100, 0) .. "%"
			ST.icon = icons["ST"]
			HUDSimpleBAR(ST)
		end

		if GetGlobalYRPBool("bool_hunger", false) then
			local HU = {}
			HU.element = "HU"
			HU.cur = lply:Hunger()
			HU.max = lply:GetMaxHunger()
			HU.text = math.Round(lply:Hunger(), 1) .. " / " .. math.Round(lply:GetMaxHunger(), 0)
			HU.percentage = math.Round(lply:Hunger() / lply:GetMaxHunger() * 100, 0) .. "%"
			HU.icon = icons["HU"]
			HUDSimpleBAR(HU)
		end

		if GetGlobalYRPBool("bool_thirst", false) then
			local TH = {}
			TH.element = "TH"
			TH.cur = lply:Thirst()
			TH.max = lply:GetMaxThirst()
			TH.text = math.Round(lply:Thirst(), 1) .. " / " .. math.Round(lply:GetMaxThirst(), 0)
			TH.percentage = math.Round(lply:Thirst() / lply:GetMaxThirst() * 100, 0) .. "%"
			TH.icon = icons["TH"]
			HUDSimpleBAR(TH)
		end

		if GetGlobalYRPBool("bool_permille", false) then
			local AL = {}
			AL.element = "AL"
			AL.cur = lply:Permille()
			AL.max = lply:GetMaxPermille()
			AL.text = math.Round(lply:Permille(), 1) .. " / " .. math.Round(lply:GetMaxPermille(), 0)
			AL.percentage = math.Round(lply:Permille() / lply:GetMaxPermille() * 4, 0) .. "‰"
			AL.icon = icons["AL"]
			HUDSimpleBAR(AL)
		end

		if GetGlobalYRPBool("bool_radiation", false) then
			local RA = {}
			RA.element = "RA"
			RA.cur = lply:Radiation()
			RA.max = lply:GetMaxRadiation()
			RA.text = lply:Radiation() .. " / " .. lply:GetMaxRadiation()
			RA.percentage = math.Round(lply:Radiation() / lply:GetMaxRadiation() * 100, 0) .. "%"
			RA.icon = icons["RA"]
			HUDSimpleBAR(RA)
		end

		if lply:GetYRPBool("iscasting", false) then
			local CA = {}
			CA.element = "CA"
			CA.cur = lply:CastTimeCurrent()
			CA.max = lply:CastTimeMax()
			CA.text = lply:GetCastName()
			CA.percentage = math.Round(lply:CastTimeCurrent() / lply:CastTimeMax() * 100, 1) .. "%"
			CA.icon = icons["CA"]
			HUDSimpleBAR(CA)
		end

		AB = {}
		AB.element = "AB"
		AB.cur = lply:Ability()
		AB.max = lply:GetMaxAbility()
		AB.text = math.Round(lply:Ability(), 0) .. " / " .. math.Round(lply:GetMaxAbility(), 0)
		AB.percentage = math.Round(lply:Ability() / lply:GetMaxAbility() * 100, 1) .. "%"
		AB.icon = icons["AB"]
		HUDSimpleBAR(AB)
		if WP.visible then
			HUDSimpleBAR(WP)
		end

		if WS.visible then
			HUDSimpleBAR(WS)
		end

		HUDSimpleBAR(WN)
		if batterypower <= 100 then
			if batterypower > 100 then
				batterypower = 100
			end

			local BA = {}
			BA.element = "BA"
			BA.cur = batterypower
			BA.max = 100
			BA.text = batterypower .. "%"
			BA.icon = icons["BA"]
			HUDSimpleBAR(BA)
		end

		if not strEmpty(lply:Condition()) then
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
			if lply:HudValue("PE", "EXTR") then
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
			end

			if fps < 30 then
				fpscolor = Color(0, 255, 0)
			elseif fps < 60 then
				fpscolor = Color(255, 255, 0)
			else
				fpscolor = Color(0, 255, 0)
			end
		end

		PE.text = YRP:trans("LID_fps") .. ": " .. fps
		if lply:HudValue("PE", "EXTR") then
			PE.text = PE.text .. " (▼" .. fpsmin .. " Ø" .. fpsavg .. " ▲" .. fpsmax .. " )"
		end

		PE.tcolor = fpscolor
		HUDSimpleBAR(PE)
		if CurTime() > ping_delay then
			ping_delay = CurTime() + 0.5
			ping = lply:Ping()
			if lply:HudValue("NE", "EXTR") then
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
			end

			if ping > 100 then
				pingcolor = Color(0, 255, 0)
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
		NE.text = YRP:trans("LID_ping") .. ": " .. ping
		if lply:HudValue("NE", "EXTR") then
			NE.text = NE.text .. " (▼" .. pingmin .. " Ø" .. pingavg .. " ▲" .. pingmax .. " )"
		end

		NE.tcolor = pingcolor
		HUDSimpleBAR(NE)
		HUDSimpleCompass()
		MI = {}
		MI.element = "MI"
		MI.cur = 0
		MI.max = 1
		local _x = math.Round(lply:GetPos().x, 0)
		local _y = math.Round(lply:GetPos().y, 0)
		MI.text = "x: " .. tostring(_x) .. " y: " .. tostring(_y)
		HUDSimpleBAR(MI)
		if lply:Lockdown() then
			local LO = {}
			LO.element = "LO"
			LO.text = "[" .. GTS("lockdown") .. "] " .. lply:LockdownText()
			HUDSimpleBAR(LO)
		end

		-- Foreground
		for i = 1, 10 do
			local BOX = {}
			BOX.element = "BOX" .. i
			HUDSimpleBR(BOX)
		end

		HP = {}
		HP.element = "HP"
		HUDSimpleBR(HP)
		AR = {}
		AR.element = "AR"
		HUDSimpleBR(AR)
		if IsLevelSystemEnabled() then
			XP = {}
			XP.element = "XP"
			HUDSimpleBR(XP)
		end

		MO = {}
		MO.element = "MO"
		HUDSimpleBR(MO)
		SA = {}
		SA.element = "SA"
		HUDSimpleBR(SA)
		RO = {}
		RO.element = "RO"
		HUDSimpleBR(RO)
		if GetGlobalYRPBool("bool_stamina", false) then
			local ST = {}
			ST.element = "ST"
			HUDSimpleBR(ST)
		end

		if GetGlobalYRPBool("bool_radiation", false) then
			local RA = {}
			RA.element = "RA"
			HUDSimpleBR(RA)
		end

		if GetGlobalYRPBool("bool_hunger", false) then
			local HU = {}
			HU.element = "HU"
			HUDSimpleBR(HU)
		end

		if GetGlobalYRPBool("bool_thirst", false) then
			local TH = {}
			TH.element = "TH"
			HUDSimpleBR(TH)
		end

		if GetGlobalYRPBool("bool_permille", false) then
			local AL = {}
			AL.element = "AL"
			HUDSimpleBR(AL)
		end

		if lply:GetYRPBool("iscasting", false) then
			local CA = {}
			CA.element = "CA"
			HUDSimpleBR(CA)
		end

		AB = {}
		AB.element = "AB"
		HUDSimpleBR(AB)
		WP.element = "WP"
		if WP.visible then
			HUDSimpleBR(WP)
		end

		WS.element = "WS"
		if WS.visible then
			HUDSimpleBR(WS)
		end

		WN.element = "WN"
		HUDSimpleBR(WN)
		if batterypower <= 100 then
			local BA = {}
			BA.element = "BA"
			HUDSimpleBR(BA)
		end

		if not strEmpty(lply:Condition()) then
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
		NA = {}
		NA.element = "NA"
		HUDSimpleBR(NA)
		ID = {}
		ID.element = "ID"
		HUDSimpleBR(ID)
		SN = {}
		SN.element = "SN"
		HUDSimpleBR(SN)
	end
end

timer.Simple(
	1,
	function()
		hook.Add("HUDPaint", "yrp_hud_design_Simple", HUDSimple)
	end
)
