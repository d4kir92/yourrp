--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local Player = FindMetaTable("Player")

if CLIENT then
	function Player:GetHudDesignName()
		return self:GetDString("string_hud_design", "notloaded")
	end

	-- string element for example "health", art for example "SIZE_W"
	function Player:HudValue(element, art)
		local hfloats = {"POSI_X", "POSI_Y", "SIZE_W", "SIZE_H"}
		local hbools = {"VISI", "ROUN", "ICON", "TEXT", "PERC", "BACK", "BORD", "EXTR"}
		local hcolors = {"TE", "TB", "BG", "BA", "BR"}
		local hints = {"AX", "AY", "TS"}

		if YRPHUD != nil then
			if table.HasValue(hfloats, art) then
				--local f_val = self:GetDFloat("float_HUD_" .. element .. "_" .. art, -1.0)
				local f_val = YRPHUD("float_HUD_" .. element .. "_" .. art, -1.0)
				if art == "POSI_X" or  art == "SIZE_W" then
					f_val = f_val * ScW()
					if art == "POSI_X" and BiggerThen16_9() then
						f_val = f_val + PosX()
					end
				else
					f_val = f_val * ScH()
				end
				return math.Round(f_val, 0)
			elseif table.HasValue(hbools, art) then
				return YRPHUD("bool_HUD_" .. element .. "_" .. art, false) --self:GetDBool("bool_HUD_" .. element .. "_" .. art, false)
			elseif table.HasValue(hcolors, art) then
				if element == "AB" then
					local abcolors = {}
					abcolors["none"] = Color(0, 0, 0, 0)
					abcolors["mana"] = Color(100, 100, 255, 255)
					abcolors["rage"] = Color(255, 0, 0, 255)
					abcolors["energy"] = Color(255, 255, 0, 255)
					abcolors["force"] = Color(100, 100, 255, 255)
					return abcolors[self:GetDString("GetAbilityType", "none")]
				else
					local hcolor = YRPHUD("color_HUD_" .. element .. "_" .. art, "255, 0, 0") -- self:GetDString("color_HUD_" .. element .. "_" .. art, "255, 0, 0")
					hcolor = string.Explode(",", hcolor)
					return Color(hcolor[1], hcolor[2], hcolor[3], hcolor[4] or 255)
				end
			elseif table.HasValue(hints, art) then
				local ay = YRPHUD("int_HUD_" .. element .. "_" .. art, -1)
				if art == "AY" then
					if ay == 3 then
						ay = 0
					elseif ay == 4 then
						ay = 2
					end
				end
				return ay
			end
			return "ART: " .. art .. " not found."
		end
		return ""
	end

	function Player:HudElement(element)
		local hfloats = {"POSI_X", "POSI_Y", "SIZE_W", "SIZE_H"}
		local hbools = {"VISI", "ROUN", "ICON", "TEXT", "PERC", "BACK", "BORD", "EXTR"}
		local hcolors = {"TE", "TB", "BG", "BA", "BR"}
		local hints = {"AX", "AY", "TS"}

		local ele = {}
		for i, v in pairs(hfloats) do
			ele[v] = self:HudValue(element, v)
		end
		for i, v in pairs(hbools) do
			ele[v] = self:HudValue(element, v)
		end
		for i, v in pairs(hcolors) do
			ele[v] = self:HudValue(element, v)
		end
		for i, v in pairs(hints) do
			ele[v] = self:HudValue(element, v)
		end
		return ele
	end

	function Player:HudElementVisible(element)
		if self:HudValue(element, "VISI") == false then
			return false
		end
		if element == "CA" then
			return self:GetDBool("iscasting", false)
		elseif element == "LO" then
			return self:Lockdown()
		elseif element == "HU" then
			return GetGlobalDBool("bool_hunger", false) and self:GetDBool("bool_hunger", false)
		elseif element == "TH" then
			return GetGlobalDBool("bool_thirst", false) and self:GetDBool("bool_thirst", false)
		elseif element == "AL" then
			return GetGlobalDBool("bool_permille", false)
		elseif element == "ST" then
			return GetGlobalDBool("bool_stamina", false) and self:GetDBool("bool_stamina", false)
		elseif element == "RA" then
			return GetGlobalDBool("bool_radiation", false)
		elseif element == "HY" then
			return GetGlobalDBool("bool_hygiene", false)
		elseif element == "XP" then
			return IsLevelSystemEnabled()
		elseif element == "WP" then
			local weapon = self:GetActiveWeapon()
			if weapon:IsValid() then
				local clip1 = weapon:Clip1()
				local clip1max = weapon:GetMaxClip1()
				local ammo1 = self:GetAmmoCount(weapon:GetPrimaryAmmoType())
				return clip1max > 0
			end
			return false
		elseif element == "WS" then
			local weapon = self:GetActiveWeapon()
			if weapon:IsValid() then
				local clip2 = weapon:Clip2()
				local clip2max = weapon:GetMaxClip2()
				local ammo2 = self:GetAmmoCount(weapon:GetSecondaryAmmoType())
				return ammo2 > 0
			end
			return false
		elseif element == "BA" then
			return system.BatteryPower() < 100
		elseif element == "CON" then
			return !strEmpty(self:Condition())
		elseif element == "AB" then
			return self:GetDString("GetAbilityType", "none") != "none"
		elseif element == "HP" then
		elseif element == "AR" then
		elseif element == "WN" then
			local weapon = self:GetActiveWeapon()
			if weapon:IsValid() then
				return true
			else
				return false
			end
		else
			-- 
		end
		return true
	end

	function Player:HudElementAlpha(element, a)
		if element == "CH" then
			return ChatAlpha()
		end
		return a
	end
end

function Player:Lockdown()
	return self:GetDBool("bool_lockdown", false)
end

function Player:LockdownText()
	return self:GetDString("string_lockdowntext", "")
end
