--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

YRP.msg("gm", "Loading sv_includes.lua")

include("db/db_database.lua")

include("gm/sv_playerisready.lua")
include("gm/sv_gamemode.lua")
include("gm/sv_net.lua")
include("gm/sv_map.lua")
include("gm/sv_think.lua")
include("gm/sv_chat.lua")
include("gm/sv_teleport.lua")
include("gm/sv_startup.lua")

YRP.msg("gm", "Loaded sv_includes.lua")
