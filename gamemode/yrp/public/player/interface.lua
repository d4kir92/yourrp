--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local Player = FindMetaTable("Player")

function Player:GetInterfaceDesign()
	return GetGlobalDString("string_interface_design", "Simple")
end

function Player:InterfaceValue(element, art)
	local ifloats = {}
	local ibools = {}
	local icolors = {"BG", "HT", "HI", "HB", "NC", "HC", "PC", "SC", "NT", "HT", "ST"}
	local iints = {}
	if table.HasValue(ifloats, art) then
		return 0.0
	elseif table.HasValue(ibools, art) then
		return false
	elseif table.HasValue(icolors, art) then
		local icolor = self:GetDString("color_IF_" .. self:GetInterfaceDesign() .. "_" .. element .. "_" .. art, "255, 0, 0")
		icolor = string.Explode(",", icolor)
		return Color(icolor[1], icolor[2], icolor[3], icolor[4] or 255)
	elseif table.HasValue(iints, art) then
		return 0
	end
	return "Element: " .. element .. " ART: " .. art .. " not found."
end

function Player:InterfaceElement(element)
	local ifloats = {}
	local ibools = {}
	local icolors = {"BG", "HT", "HI", "HB", "NC", "HC", "PC", "SC", "NT", "HT", "ST"}
	local iints = {}

	local ele = {}
	for i, v in pairs(ifloats) do
		ele[v] = self:InterfaceValue(element, v)
	end
	for i, v in pairs(ibools) do
		ele[v] = self:InterfaceValue(element, v)
	end
	for i, v in pairs(icolors) do
		ele[v] = self:InterfaceValue(element, v)
	end
	for i, v in pairs(iints) do
		ele[v] = self:InterfaceValue(element, v)
	end
	return ele
end
