--[[
Copyright (C) 2017 Arno Zura

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see < http://www.gnu.org/licenses/ >.
]]--

--[[
AddCSLuaFiles
]]--
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

AddCSLuaFile( "cl/cl_includes.lua" )
AddCSLuaFile( "cl/gm/cl_startup.lua" )
AddCSLuaFile( "cl/gm/cl_hud.lua" )
AddCSLuaFile( "cl/gm/cl_chat.lua" )
AddCSLuaFile( "cl/gm/cl_think.lua" )
AddCSLuaFile( "cl/gm/hud/cl_hud_crosshair.lua" )
AddCSLuaFile( "cl/gm/hud/cl_hud_map.lua" )
AddCSLuaFile( "cl/gm/hud/cl_hud_player.lua" )
AddCSLuaFile( "cl/gm/hud/cl_hud_view.lua" )
AddCSLuaFile( "cl/gm/menus/cl_buy.lua" )
AddCSLuaFile( "cl/gm/menus/cl_character.lua" )
AddCSLuaFile( "cl/gm/menus/cl_door_options.lua" )
AddCSLuaFile( "cl/gm/menus/cl_interact.lua" )
AddCSLuaFile( "cl/gm/menus/cl_rolesmenu.lua" )
AddCSLuaFile( "cl/gm/menus/cl_scoreboard.lua" )
AddCSLuaFile( "cl/gm/menus/cl_vehicle_options.lua" )
AddCSLuaFile( "cl/gm/menus/settings/cl_settings.lua" )
AddCSLuaFile( "cl/gm/menus/settings/cl_settings_client_charakter.lua" )
AddCSLuaFile( "cl/gm/menus/settings/cl_settings_client_hud.lua" )
AddCSLuaFile( "cl/gm/menus/settings/cl_settings_server_general.lua" )
AddCSLuaFile( "cl/gm/menus/settings/cl_settings_server_give.lua" )
AddCSLuaFile( "cl/gm/menus/settings/cl_settings_server_map.lua" )
AddCSLuaFile( "cl/gm/menus/settings/cl_settings_server_money.lua" )
AddCSLuaFile( "cl/gm/menus/settings/cl_settings_server_restriction.lua" )
AddCSLuaFile( "cl/gm/menus/settings/cl_settings_server_roles.lua" )
AddCSLuaFile( "cl/gm/menus/settings/cl_settings_server_whitelist.lua" )
AddCSLuaFile( "cl/gm/menus/settings/cl_settings_yourrp_add_langu.lua" )
AddCSLuaFile( "cl/gm/menus/settings/cl_settings_yourrp_contact.lua" )
AddCSLuaFile( "cl/gm/menus/settings/cl_settings_yourrp_workshop.lua" )

--[[
includes
]]--
include( "shared.lua" )

include( "sv/sv_includes.lua" )
