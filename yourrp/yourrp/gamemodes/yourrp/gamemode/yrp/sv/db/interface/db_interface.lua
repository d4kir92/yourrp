--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
local DATABASE_NAME = "yrp_interface"
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "name", "TEXT DEFAULT ''")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "value", "TEXT DEFAULT ''")
--YRP_SQL_DROP_TABLE(DATABASE_NAME)
local INTERFACES = {}
function AddIFElement(tab)
	for name, value in pairs(tab.floats) do
		local _name = "float_IF_" .. tab.element .. "_" .. name
		if YRP_SQL_SELECT(DATABASE_NAME, "*", "name = '" .. _name .. "'") == nil then
			YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. _name .. "', '" .. value .. "'")
		end
	end

	for name, value in pairs(tab.bools) do
		local _name = "bool_IF_" .. tab.element .. "_" .. name
		if YRP_SQL_SELECT(DATABASE_NAME, "*", "name = '" .. _name .. "'") == nil then
			YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. _name .. "', '" .. value .. "'")
		end
	end

	for name, value in pairs(tab.colors) do
		local _name = "color_IF_" .. tab.element .. "_" .. name
		if YRP_SQL_SELECT(DATABASE_NAME, "*", "name = '" .. _name .. "'") == nil then
			YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. _name .. "', '" .. value .. "'")
		end
	end

	if tab.ints ~= nil then
		for name, value in pairs(tab.ints) do
			local _name = "int_IF_" .. tab.element .. "_" .. name
			if YRP_SQL_SELECT(DATABASE_NAME, "*", "name = '" .. _name .. "'") == nil then
				YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. _name .. "', '" .. value .. "'")
			end
		end
	end

	INTERFACES[tab.element] = tab
end

local Material = {}
Material.element = "Material"
Material.floats = {}
Material.bools = {}
Material.bools.Rounded = 0
Material.colors = {}
Material.colors.YFrame_HT = "255, 255, 255, 255" -- Header Textcolor
Material.colors.YFrame_HB = "45, 45, 45, 255" -- Header Backgroundcolor
Material.colors.YFrame_NC = "35, 35, 35, 255" -- Normal Color
Material.colors.YFrame_PC = "55, 55, 55, 255" -- Pressed Color
Material.colors.YFrame_HI = "80, 80, 80, 255" -- Highlight Color
Material.colors.YFrame_BG = "25, 25, 25, 255" -- Background Color
Material.colors.YButton_NT = "0, 0, 0, 255" -- Normal Textcolor
Material.colors.YButton_NC = "93, 166, 251, 255" -- Normal Color
Material.colors.YButton_HC = "148, 197, 255, 255" -- Hovered Color
Material.colors.YButton_PC = "50, 144, 254, 255" -- Pressed Color
Material.colors.YButton_SC = "50, 144, 254, 255" -- Selected Color
Material.colors.Chat_BG = "0, 0, 0, 100" -- ChatBackground Color
Material.colors.Chat_FG = "255, 255, 255, 20" -- ChatForeground Color
Material.ints = {}
AddIFElement(Material)
local Blur = {}
Blur.element = "Blur"
Blur.floats = {}
Blur.bools = {}
Blur.bools.Rounded = 0
Blur.colors = {}
Blur.colors.YFrame_HT = "255, 255, 255, 255" -- Header Textcolor
Blur.colors.YFrame_HB = "40, 40, 40, 80" -- Header Backgroundcolor
Blur.colors.YFrame_NC = "40, 40, 40, 80" -- Normal Color
Blur.colors.YFrame_PC = "50, 50, 50, 80"
Blur.colors.YFrame_HI = "80, 80, 80, 80" -- Highlight Color
Blur.colors.YFrame_BG = "255, 255, 255, 80" -- Background Color
Blur.colors.YButton_NT = "0, 0, 0, 255" -- Normal Textcolor
Blur.colors.YButton_NC = "200, 200, 200, 80" -- Normal Color
Blur.colors.YButton_HC = "255, 255, 255, 80" -- Hovered Color
Blur.colors.YButton_PC = "150, 150, 150, 80" -- Pressed Color
Blur.colors.YButton_SC = "220, 220, 220, 80" -- Selected Color
Blur.colors.Chat_BG = "0, 0, 0, 100" -- ChatBackground Color
Blur.colors.Chat_FG = "255, 255, 255, 20" -- ChatForeground Color
Blur.ints = {}
AddIFElement(Blur)
--[[ LOADOUT ]]
--
YRPIFVersion = YRPIFVersion or -1
function IFLoadoutAll()
	local ifeles = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
	if IsNotNilAndNotFalse(ifeles) then
		for i, ele in pairs(ifeles) do
			if ele.name ~= nil then
				if string.StartWith(ele.name, "float_") then
					SetGlobalYRPFloat(ele.name, tonumber(ele.value))
				elseif string.StartWith(ele.name, "bool_") then
					SetGlobalYRPBool(ele.name, tobool(ele.value))
				elseif string.StartWith(ele.name, "color_") then
					SetGlobalYRPString(ele.name, tostring(ele.value))
				elseif string.StartWith(ele.name, "int_") then
					SetGlobalYRPInt(ele.name, tonumber(ele.value))
				end
			end
		end
	end

	YRPIFVersion = YRPIFVersion + 1
	SetGlobalYRPInt("interface_version", YRPIFVersion)
end

IFLoadoutAll()
util.AddNetworkString("nws_yrp_get_interface_settings")
net.Receive(
	"nws_yrp_get_interface_settings",
	function(len, ply)
		local element = net.ReadString()
		local tab = YRP_SQL_SELECT(DATABASE_NAME, "*", "name LIKE '" .. "%_IF_" .. element .. "_%'")
		if IsNotNilAndNotFalse(tab) then
			table.SortByMember(tab, "name", true)
			net.Start("nws_yrp_get_interface_settings")
			net.WriteTable(tab)
			net.Send(ply)
		end
	end
)

util.AddNetworkString("nws_yrp_update_interface_color")
net.Receive(
	"nws_yrp_update_interface_color",
	function(len, ply)
		local name = net.ReadString()
		local color = net.ReadString()
		YRP.msg("db", "value = '" .. color .. "'" .. "name = '" .. name .. "'")
		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["value"] = color
			}, "name = '" .. name .. "'"
		)

		IFLoadoutAll()
	end
)

function ResetDesign()
	local tab = INTERFACES[GetGlobalYRPString("string_interface_design", "")]
	if tab ~= nil then
		for name, value in pairs(tab.floats) do
			local _name = "float_IF_" .. GetGlobalYRPString("string_interface_design", "Material") .. "_" .. name
			YRP_SQL_UPDATE(
				DATABASE_NAME,
				{
					["value"] = value
				}, "name = '" .. _name .. "'"
			)
		end

		for name, value in pairs(tab.bools) do
			local _name = "bool_IF_" .. GetGlobalYRPString("string_interface_design", "Material") .. "_" .. name
			YRP_SQL_UPDATE(
				DATABASE_NAME,
				{
					["value"] = value
				}, "name = '" .. _name .. "'"
			)
		end

		for name, value in pairs(tab.colors) do
			local _name = "color_IF_" .. GetGlobalYRPString("string_interface_design", "Material") .. "_" .. name
			YRP_SQL_UPDATE(
				DATABASE_NAME,
				{
					["value"] = value
				}, "name = '" .. _name .. "'"
			)
		end

		for name, value in pairs(tab.ints) do
			local _name = "int_IF_" .. GetGlobalYRPString("string_interface_design", "Material") .. "_" .. name
			YRP_SQL_UPDATE(
				DATABASE_NAME,
				{
					["value"] = value
				}, "name = '" .. _name .. "'"
			)
		end
	end

	IFLoadoutAll()
end

util.AddNetworkString("nws_yrp_reset_interface_design")
net.Receive(
	"nws_yrp_reset_interface_design",
	function(len, ply)
		ResetDesign()
	end
)