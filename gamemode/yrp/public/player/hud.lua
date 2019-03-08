--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local Player = FindMetaTable("Player")

function Player:GetHudDesignName()
	return self:GetNWString("string_hud_design", "notloaded")
end

-- string element for example "health", art for example "SIZE_W"
function Player:HudValue(element, art)
	local hfloats = {"POSI_X", "POSI_Y", "SIZE_W", "SIZE_H"}
	local hbools = {"VISI", "ROUN", "ICON", "TEXT", "PERC", "BACK", "BORD"}
	local hcolors = {"TE", "TB", "BG", "BA", "BR"}
	local hints = {"AX", "AY", "TS"}
	if table.HasValue(hfloats, art) then
		local f_val = self:GetNWFloat("float_HUD_" .. element .. "_" .. art, -1.0)

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
		return self:GetNWBool("bool_HUD_" .. element .. "_" .. art, false)
	elseif table.HasValue(hcolors, art) then
		local hcolor = self:GetNWString("color_HUD_" .. element .. "_" .. art, "255, 0, 0")
		hcolor = string.Explode(",", hcolor)
		return Color(hcolor[1], hcolor[2], hcolor[3], hcolor[4] or 255)
	elseif table.HasValue(hints, art) then
		return tonumber(self:GetNWInt("int_HUD_" .. element .. "_" .. art, -1))
	end
	return "ART: " .. art .. " not found."
end

function Player:HudElement(element)
	local hfloats = {"POSI_X", "POSI_Y", "SIZE_W", "SIZE_H"}
	local hbools = {"VISI", "ROUN", "ICON", "TEXT", "PERC", "BACK", "BORD"}
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

function Player:LockdownText()
	local lockdown = ""
	if self:GetNWBool("bool_lockdown", false) then
		lockdown = "[" .. string.upper(YRP.lang_string("LID_lockdown")) .. "]"
		lockdown = lockdown .. " " .. ply:GetNWString("string_lockdowntext", "") .. " " .. lockdown
	end
	return lockdown
end
