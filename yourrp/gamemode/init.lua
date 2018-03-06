--[[
Copyright (C) 2017-2018 Arno Zura

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

--[[ AddCSLuaFiles ]]--
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

AddCSLuaFile( "cl/db/db_database.lua")
AddCSLuaFile( "cl/db/db_hud.lua")
AddCSLuaFile( "cl/db/db_keybinds.lua")
AddCSLuaFile( "cl/db/db_fonts.lua")
AddCSLuaFile( "cl/db/db_version.lua")
AddCSLuaFile( "cl/db/db_tutorials.lua")
AddCSLuaFile( "cl/db/db_apps.lua")
AddCSLuaFile( "cl/db/db_smartphone.lua")

AddCSLuaFile( "cl/cl_includes.lua" )
AddCSLuaFile( "cl/gm/cl_startup.lua" )
AddCSLuaFile( "cl/gm/cl_hud.lua" )
AddCSLuaFile( "cl/gm/cl_chat.lua" )
AddCSLuaFile( "cl/gm/cl_think.lua" )
AddCSLuaFile( "cl/gm/hud/cl_hud_crosshair.lua" )
AddCSLuaFile( "cl/gm/hud/cl_hud_map.lua" )
AddCSLuaFile( "cl/gm/hud/cl_hud_player.lua" )
AddCSLuaFile( "cl/gm/hud/player/cl_hud_hp.lua" )
AddCSLuaFile( "cl/gm/hud/player/cl_hud_ar.lua" )
AddCSLuaFile( "cl/gm/hud/player/cl_hud_ma.lua" )
AddCSLuaFile( "cl/gm/hud/player/cl_hud_mh.lua" )
AddCSLuaFile( "cl/gm/hud/player/cl_hud_mt.lua" )
AddCSLuaFile( "cl/gm/hud/player/cl_hud_ms.lua" )
AddCSLuaFile( "cl/gm/hud/player/cl_hud_ca.lua" )
AddCSLuaFile( "cl/gm/hud/player/cl_hud_mo.lua" )
AddCSLuaFile( "cl/gm/hud/player/cl_hud_xp.lua" )
AddCSLuaFile( "cl/gm/hud/player/cl_hud_wn.lua" )
AddCSLuaFile( "cl/gm/hud/player/cl_hud_wp.lua" )
AddCSLuaFile( "cl/gm/hud/player/cl_hud_ws.lua" )
AddCSLuaFile( "cl/gm/hud/player/cl_hud_mm.lua" )
AddCSLuaFile( "cl/gm/hud/player/cl_hud_st.lua" )
AddCSLuaFile( "cl/gm/hud/player/cl_hud_vt.lua" )
AddCSLuaFile( "cl/gm/hud/player/cl_hud_bl.lua" )
AddCSLuaFile( "cl/gm/hud/player/cl_hud_thirdperson.lua" )
AddCSLuaFile( "cl/gm/hud/cl_hud_view.lua" )
AddCSLuaFile( "cl/gm/menus/cl_help.lua" )
AddCSLuaFile( "cl/gm/menus/cl_buymenu.lua" )
AddCSLuaFile( "cl/gm/menus/cl_character.lua" )
AddCSLuaFile( "cl/gm/menus/cl_door_options.lua" )
AddCSLuaFile( "cl/gm/menus/cl_interact.lua" )
AddCSLuaFile( "cl/gm/menus/cl_inventory.lua" )
AddCSLuaFile( "cl/gm/menus/cl_rolesmenu.lua" )
AddCSLuaFile( "cl/gm/menus/cl_scoreboard.lua" )
AddCSLuaFile( "cl/gm/menus/cl_vehicle_options.lua" )
AddCSLuaFile( "cl/gm/menus/settings/cl_settings.lua" )
AddCSLuaFile( "cl/gm/menus/settings/cl_settings_client_charakter.lua" )
AddCSLuaFile( "cl/gm/menus/settings/cl_settings_client_hud.lua" )
AddCSLuaFile( "cl/gm/menus/settings/cl_settings_client_keybinds.lua" )
AddCSLuaFile( "cl/gm/menus/settings/cl_settings_server_general.lua" )
AddCSLuaFile( "cl/gm/menus/settings/cl_settings_server_realistic.lua" )
AddCSLuaFile( "cl/gm/menus/settings/cl_settings_server_give.lua" )
AddCSLuaFile( "cl/gm/menus/settings/cl_settings_server_map.lua" )
AddCSLuaFile( "cl/gm/menus/settings/cl_settings_server_money.lua" )
AddCSLuaFile( "cl/gm/menus/settings/cl_settings_server_licenses.lua" )
AddCSLuaFile( "cl/gm/menus/settings/cl_settings_server_shops.lua" )
AddCSLuaFile( "cl/gm/menus/settings/cl_settings_server_restriction.lua" )
AddCSLuaFile( "cl/gm/menus/settings/cl_settings_server_roles.lua" )
AddCSLuaFile( "cl/gm/menus/settings/cl_settings_server_whitelist.lua" )
AddCSLuaFile( "cl/gm/menus/settings/cl_settings_yourrp_add_langu.lua" )
AddCSLuaFile( "cl/gm/menus/settings/cl_settings_yourrp_contact.lua" )
AddCSLuaFile( "cl/gm/menus/settings/cl_settings_yourrp_workshop.lua" )
AddCSLuaFile( "cl/gm/menus/cl_smartphone.lua" )

AddCSLuaFile( "cl/gm/apps/cl_app_settings_yrp.lua" )
AddCSLuaFile( "cl/gm/apps/cl_app_settings_sp.lua" )
AddCSLuaFile( "cl/gm/apps/cl_app_dark_web.lua" )

--[[ includes ]]--
include( "shared.lua" )

include( "sv/sv_includes.lua" )
