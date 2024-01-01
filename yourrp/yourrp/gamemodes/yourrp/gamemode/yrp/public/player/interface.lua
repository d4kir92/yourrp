--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
function YRPGetInterfaceDesign()
	return GetGlobalYRPString("string_interface_design", "Material")
end

local tabifcolors = {}
function YRPInterfaceValue(element, art)
	local ifloats = {}
	local ibools = {}
	local icolors = {"BG", "HT", "HI", "HB", "NC", "HC", "PC", "SC", "NT", "HT", "ST", "FG"}
	local iints = {}
	if table.HasValue(ifloats, art) then
		return 0.0
	elseif table.HasValue(ibools, art) then
		return false
	elseif table.HasValue(icolors, art) then
		local icolor = GetGlobalYRPString("color_IF_" .. YRPGetInterfaceDesign() .. "_" .. element .. "_" .. art, "0, 0, 0, 100")
		if icolor and type(icolor) == "string" then
			if tabifcolors[icolor] == nil then
				tabifcolors[icolor] = StringToColor(icolor)
			end

			local col = tabifcolors[icolor]
			if col and col.r and col.g and col.b then
				col.a = col.a or 255

				return Color(col.r, col.g, col.b, col.a)
			else
				return Color(255, 0, 0, 255)
			end
		else
			return Color(255, 0, 0, 200)
		end
	elseif table.HasValue(iints, art) then
		return 0
	end

	local text = "Element: " .. element .. " ART: " .. art .. " not found."
	YRP.msg("error", text)

	return text
end

function YRPInterfaceElement(element)
	local ifloats = {}
	local ibools = {}
	local icolors = {"BG", "HT", "HI", "HB", "NC", "HC", "PC", "SC", "NT", "HT", "ST"}
	local iints = {}
	local ele = {}
	for i, v in pairs(ifloats) do
		ele[v] = YRPInterfaceValue(element, v)
	end

	for i, v in pairs(ibools) do
		ele[v] = YRPInterfaceValue(element, v)
	end

	for i, v in pairs(icolors) do
		ele[v] = YRPInterfaceValue(element, v)
	end

	for i, v in pairs(iints) do
		ele[v] = YRPInterfaceValue(element, v)
	end

	return ele
end