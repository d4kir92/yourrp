--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

DarkRP = {}
DarkRP.disabledDefaults = {}
DarkRP.disabledDefaults.modules = {}
DarkRP.disabledDefaults.modules.hitmenu = true

yrp._not = "If you see this, please test all your darkrp addons, if some addon is not fully working, please tell D4KiR!"

AddCSLuaFile( "darkrp/fn.lua" )
AddCSLuaFile( "darkrp/config/config.lua" )
AddCSLuaFile( "darkrp/config/jobrelated.lua" )

AddCSLuaFile( "darkrp/gamemode/shared.lua" )
AddCSLuaFile( "darkrp/player/shared.lua" )
AddCSLuaFile( "darkrp/entity/shared.lua" )

include( "darkrp/fn.lua" )

include( "darkrp/gamemode/shared.lua" )
include( "darkrp/player/shared.lua" )
include( "darkrp/entity/shared.lua" )

include( "darkrp/config/config.lua" )
include( "darkrp/config/jobrelated.lua" )

local Vector = FindMetaTable( "Vector" )

function Vector:isInSight( filter, ply )
  --Description: Decides whether the vector could be seen by the player if they
  --             were to look at it.
  printDRP( "isInSight( filter, ply )" )
  printDRP( yrp._not )
  return false, Vector( 0, 0, 0 )
end
