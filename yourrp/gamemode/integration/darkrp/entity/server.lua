--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local Entity = FindMetaTable( "Entity" )

function Entity:addKeysAllowedToOwn( ply )
  --Description: Make this player allowed to co-own the door or vehicle.
  printGM( "darkrp", "addKeysAllowedToOwn( ply )" )
  printGM( "darkrp", g_yrp._not )
end

function Entity:addKeysDoorOwner( ply )
  --Description: Make this player a co-owner of the door.
  printGM( "darkrp", "addKeysDoorOwner( ply )" )
  printGM( "darkrp", g_yrp._not )
end

function Entity:addKeysDoorTeam( team )
  --Description: Allow a team to lock/unlock a door..
  printGM( "darkrp", "addKeysDoorTeam( team )" )
  printGM( "darkrp", g_yrp._not )
end

function Entity:doorIndex()
  --Description: Get the door index of a door. Use this to store door
  --             information in the database.
  printGM( "darkrp", "doorIndex()" )
  printGM( "darkrp", g_yrp._not )
  return 0
end

function Entity:isLocked()
  --Description: Whether this door/vehicle is locked.
  printGM( "darkrp", "isLocked()" )
  printGM( "darkrp", g_yrp._not )
  return false
end

function Entity:keysLock()
  --Description: Lock this door or vehicle.
  printGM( "darkrp", "keysLock()" )
  printGM( "darkrp", g_yrp._not )
end

function Entity:keysOwn( ply )
  --Description: Make the player the master owner of the door
  printGM( "darkrp", "keysOwn( ply )" )
  printGM( "darkrp", g_yrp._not )
end

function Entity:keysUnLock()
  --Description: Unlock this door or vehicle.
  printGM( "darkrp", "keysUnLock()" )
  printGM( "darkrp", g_yrp._not )
end

function Entity:keysUnOwn( ply )
  --Description: Make this player unown the door/vehicle.
  printGM( "darkrp", "keysUnOwn( ply )" )
  printGM( "darkrp", g_yrp._not )
end

function Entity:removeAllKeysAllowedToOwn()
  --Description: Disallow all people from owning the door.
  printGM( "darkrp", "removeAllKeysAllowedToOwn()" )
  printGM( "darkrp", g_yrp._not )
end

function Entity:removeAllKeysDoorTeams()
  --Description: Disallow all teams from locking/unlocking a door.
  printGM( "darkrp", "removeAllKeysDoorTeams()" )
  printGM( "darkrp", g_yrp._not )
end

function Entity:removeAllKeysExtraOwners()
  --Description: Remove all co-owners from a door.
  printGM( "darkrp", "removeAllKeysExtraOwners()" )
  printGM( "darkrp", g_yrp._not )
end

function Entity:removeKeysAllowedToOwn( ply )
  --Description: Remove a player from being allowed to co-own a door.
  printGM( "darkrp", "removeKeysAllowedToOwn( ply )" )
  printGM( "darkrp", g_yrp._not )
end

function Entity:removeKeysDoorOwner( ply )
  --Description: Remove this player as co-owner
  printGM( "darkrp", "removeKeysDoorOwner( ply )" )
  printGM( "darkrp", g_yrp._not )
end

function Entity:removeKeysDoorTeam( team )
  --Description: Disallow a team from locking/unlocking a door.
  printGM( "darkrp", "removeKeysDoorTeam( team )" )
  printGM( "darkrp", g_yrp._not )
end

function Entity:setDoorGroup( group )
  --Description: Set the door group of a door.
  printGM( "darkrp", "setDoorGroup( group )" )
  printGM( "darkrp", g_yrp._not )
end

function Entity:setKeysNonOwnable( ownable )
  --Description: Set whether this door or vehicle is ownable or not.
  printGM( "darkrp", "setKeysNonOwnable( ownable )" )
  printGM( "darkrp", g_yrp._not )
end

function Entity:setKeysTitle( title )
  --Description: Set the title of a door or vehicle.
  printGM( "darkrp", "setKeysTitle( title )" )
  printGM( "darkrp", g_yrp._not )
end
