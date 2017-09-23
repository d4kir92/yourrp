--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local Entity = FindMetaTable( "Entity" )

function Entity:addKeysAllowedToOwn( ply )
  --Description: Make this player allowed to co-own the door or vehicle.
  printDRP( "addKeysAllowedToOwn( ply )" )
  printDRP( yrp._not )
end

function Entity:addKeysDoorOwner( ply )
  --Description: Make this player a co-owner of the door.
  printDRP( "addKeysDoorOwner( ply )" )
  printDRP( yrp._not )
end

function Entity:addKeysDoorTeam( team )
  --Description: Allow a team to lock/unlock a door..
  printDRP( "addKeysDoorTeam( team )" )
  printDRP( yrp._not )
end

function Entity:doorIndex()
  --Description: Get the door index of a door. Use this to store door
  --             information in the database.
  printDRP( "doorIndex()" )
  printDRP( yrp._not )
  return 0
end

function Entity:isLocked()
  --Description: Whether this door/vehicle is locked.
  printDRP( "isLocked()" )
  printDRP( yrp._not )
  return false
end

function Entity:keysLock()
  --Description: Lock this door or vehicle.
  printDRP( "keysLock()" )
  printDRP( yrp._not )
end

function Entity:keysOwn( ply )
  --Description: Make the player the master owner of the door
  printDRP( "keysOwn( ply )" )
  printDRP( yrp._not )
end

function Entity:keysUnLock()
  --Description: Unlock this door or vehicle.
  printDRP( "keysUnLock()" )
  printDRP( yrp._not )
end

function Entity:keysUnOwn( ply )
  --Description: Make this player unown the door/vehicle.
  printDRP( "keysUnOwn( ply )" )
  printDRP( yrp._not )
end

function Entity:removeAllKeysAllowedToOwn()
  --Description: Disallow all people from owning the door.
  printDRP( "removeAllKeysAllowedToOwn()" )
  printDRP( yrp._not )
end

function Entity:removeAllKeysDoorTeams()
  --Description: Disallow all teams from locking/unlocking a door.
  printDRP( "removeAllKeysDoorTeams()" )
  printDRP( yrp._not )
end

function Entity:removeAllKeysExtraOwners()
  --Description: Remove all co-owners from a door.
  printDRP( "removeAllKeysExtraOwners()" )
  printDRP( yrp._not )
end

function Entity:removeKeysAllowedToOwn( ply )
  --Description: Remove a player from being allowed to co-own a door.
  printDRP( "removeKeysAllowedToOwn( ply )" )
  printDRP( yrp._not )
end

function Entity:removeKeysDoorOwner( ply )
  --Description: Remove this player as co-owner
  printDRP( "removeKeysDoorOwner( ply )" )
  printDRP( yrp._not )
end

function Entity:removeKeysDoorTeam( team )
  --Description: Disallow a team from locking/unlocking a door.
  printDRP( "removeKeysDoorTeam( team )" )
  printDRP( yrp._not )
end

function Entity:setDoorGroup( group )
  --Description: Set the door group of a door.
  printDRP( "setDoorGroup( group )" )
  printDRP( yrp._not )
end

function Entity:setKeysNonOwnable( ownable )
  --Description: Set whether this door or vehicle is ownable or not.
  printDRP( "setKeysNonOwnable( ownable )" )
  printDRP( yrp._not )
end

function Entity:setKeysTitle( title )
  --Description: Set the title of a door or vehicle.
  printDRP( "setKeysTitle( title )" )
  printDRP( yrp._not )
end
