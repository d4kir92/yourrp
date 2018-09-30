--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

printGM( "note", "Loading cl_includes.lua" )

include( "db/db_database.lua" )

include( "gm/cl_startup.lua" )
include( "gm/hud/cl_hud_crosshair.lua" )
include( "gm/hud/cl_hud_map.lua" )
include( "gm/hud/cl_hud_player.lua" )
include( "gm/hud/cl_hud_view.lua" )
include( "gm/menus/cl_feedback.lua" )
include( "gm/menus/cl_help.lua" )
include( "gm/menus/cl_buymenu.lua" )
include( "gm/menus/cl_character.lua" )
include( "gm/menus/cl_door_options.lua" )
include( "gm/menus/cl_interact.lua" )
include( "gm/menus/cl_inventory.lua" )
include( "gm/menus/cl_appearance.lua" )
include( "gm/menus/cl_rolesmenu.lua" )
include( "gm/menus/cl_scoreboard.lua" )
include( "gm/menus/cl_scoreboard_simple.lua" )
include( "gm/menus/cl_vehicle_options.lua" )
include( "gm/menus/settings/cl_settings.lua" )
include( "gm/menus/cl_smartphone.lua" )
include( "gm/menus/cl_emotes.lua" )

include( "gm/apps/cl_app_settings_yrp.lua" )
include( "gm/apps/cl_app_settings_sp.lua" )
include( "gm/apps/cl_app_dark_web.lua" )

include( "gm/designs/cl_d_material1.lua" )
include( "gm/designs/cl_d_futuristic.lua" )

include( "gm/cl_hud.lua" )
include( "gm/cl_chat.lua" )
include( "gm/cl_think.lua" )

printGM( "note", "Loaded cl_includes.lua" )
