--[[
Copyright (C) 2017-2024 D4KiR

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
( at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.	If not, see < http://www.gnu.org/licenses/ >.
]]
--
YRP = YRP or {}
_yrp = {}
-- ADD LUAS
function add_luas(str)
	AddCSLuaFile(str)
	include(str)
end

if SERVER then
	local nws = {}
	function YRP:AddNetworkString(name)
		if name == nil then return end
		if nws[name] == nil then
			util.AddNetworkString(name)
		else
			YRP:msg("error", "DOUBLE NETWORK STRING" .. name)
		end
	end
end

add_luas("yrp/net/entity.lua")
add_luas("yrp/net/global.lua")
add_luas("yrp/_libs/_libs_includes.lua")
add_luas("yrp/shared/sh_includes.lua")
add_luas("yrp/integration/integration.lua")
add_luas("yrp/public/yrp.lua")
add_luas("yrp/public/player.lua")
add_luas("yrp/public/entity.lua")
add_luas("yrp/public/gamemode.lua")
