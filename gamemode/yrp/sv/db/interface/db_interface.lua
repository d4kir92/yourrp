--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_interface"

SQL_ADD_COLUMN(DATABASE_NAME, "name", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME, "value", "TEXT DEFAULT ' '")

--SQL_DROP_TABLE(DATABASE_NAME)

function AddIFElement(tab)
	for name, value in pairs(tab.floats) do
		local _name = "float_IF_" .. tab.element .. "_" .. name
		if SQL_SELECT(DATABASE_NAME, "*", "name = '" .. _name .. "'") == nil then
			SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. _name .. "', '" .. value .. "'")
		end
	end
	for name, value in pairs(tab.bools) do
		local _name = "bool_IF_" .. tab.element .. "_" .. name
		if SQL_SELECT(DATABASE_NAME, "*", "name = '" .. _name .. "'") == nil then
			SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. _name .. "', '" .. value .. "'")
		end
	end
	for name, value in pairs(tab.colors) do
		local _name = "color_IF_" .. tab.element .. "_" .. name
		if SQL_SELECT(DATABASE_NAME, "*", "name = '" .. _name .. "'") == nil then
			SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. _name .. "', '" .. value .. "'")
		end
	end
	if tab.ints != nil then
		for name, value in pairs(tab.ints) do
			local _name = "int_IF_" .. tab.element .. "_" .. name
			if SQL_SELECT(DATABASE_NAME, "*", "name = '" .. _name .. "'") == nil then
				SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. _name .. "', '" .. value .. "'")
			end
		end
	end
end

local Simple = {}
Simple.element = "Simple"
Simple.floats = {}
Simple.bools = {}
Simple.colors = {}

Simple.colors.YFrame_HT = "255, 255, 255, 255"
Simple.colors.YFrame_HB = "40, 40, 40, 255"
Simple.colors.YFrame_BG = "0, 0, 0, 200"

Simple.colors.YButton_NC = "255, 255, 255, 255"
Simple.colors.YButton_HC = "255, 255, 0, 255"
Simple.colors.YButton_SC = "0, 255, 0, 255"
Simple.colors.YButton_NT = "0, 0, 0, 255"
Simple.colors.YButton_HT = "0, 0, 0, 255"
Simple.colors.YButton_ST = "0, 0, 0, 255"

Simple.ints = {}
AddIFElement(Simple)

--[[ LOADOUT ]]--
local Player = FindMetaTable("Player")
function Player:InterfaceLoadout()
	printGM("debug", "[InterfaceLoadout] " .. self:YRPName())
	local ifeles = SQL_SELECT(DATABASE_NAME, "*", nil)
	if wk(ifeles) then
		for i, ele in pairs(ifeles) do
			if ele.name != nil then
				if string.StartWith(ele.name, "float_") then
					self:SetDFloat(ele.name, tonumber(ele.value))
				elseif string.StartWith(ele.name, "bool_") then
					self:SetDBool(ele.name, tobool(ele.value))
				elseif string.StartWith(ele.name, "color_") then
					self:SetDString(ele.name, ele.value)
				elseif string.StartWith(ele.name, "int_") then
					self:SetDInt(ele.name, ele.value)
				end
			end
		end
	end
	self:SetDInt("interface_version", self:GetDInt("interface_version", 0) + 1)
end

function IFLoadoutAll()
	for i, ply in pairs(player.GetAll()) do
		ply:InterfaceLoadout()
	end
end

util.AddNetworkString("get_interface_settings")
net.Receive("get_interface_settings", function(len, ply)
	local element = net.ReadString()
	local tab = SQL_SELECT(DATABASE_NAME, "*", "name LIKE '" .. "%_IF_" .. element .. "_%'")
	if wk(tab) then
		table.SortByMember(tab, "name", true)
		net.Start("get_interface_settings")
			net.WriteTable(tab)
		net.Send(ply)
	end
end)

util.AddNetworkString("update_interface_color")
net.Receive("update_interface_color", function(len, ply)
	local name = net.ReadString()
	local color = net.ReadString()
	YRP.msg("db", "value = '" .. color .. "'" .. "name = '" .. name .. "'")
	SQL_UPDATE(DATABASE_NAME, "value = '" .. color .. "'", "name = '" .. name .. "'")
	IFLoadoutAll()
end)
