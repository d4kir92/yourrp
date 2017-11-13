--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local Entity = FindMetaTable( "Entity" )

function Entity:drawOwnableInfo()
  --Description: Draw the ownability information on a door or vehicle.
  printDRP( "drawOwnableInfo()" )
  printDRP( g_yrp._not )
end
