--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

yrp._not = "not needed. If you need this function, please tell D4KiR!"

AddCSLuaFile( "darkrp/fn.lua" )
AddCSLuaFile( "darkrp/config.lua" )

AddCSLuaFile( "darkrp/gamemode/shared.lua" )
AddCSLuaFile( "darkrp/player/shared.lua" )
AddCSLuaFile( "darkrp/entity/shared.lua" )

include( "darkrp/fn.lua" )
include( "darkrp/config.lua" )

include( "darkrp/gamemode/shared.lua" )
include( "darkrp/player/shared.lua" )
include( "darkrp/entity/shared.lua" )

local Vector = FindMetaTable( "Vector" )

function Vector:isInSight( filter, ply )
  --Description: Decides whether the vector could be seen by the player if they
  --             were to look at it.
  printDRP( "isInSight( filter, ply )" )
  printDRP( yrp._not )
  return false, Vector( 0, 0, 0 )
end
