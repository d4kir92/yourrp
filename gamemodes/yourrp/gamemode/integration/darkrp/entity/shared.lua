--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local Entity = FindMetaTable( "Entity" )

AddCSLuaFile( "client.lua" )

if CLIENT then
  include( "client.lua" )
else
  include( "server.lua" )
end

function Entity:getDoorData()
  --Description: Internal function to get the door/vehicle data.
  printDRP( "getDoorData()" )
  printDRP( yrp._not )
  return {}
end

function Entity:getDoorOwner()
  --Description: Get the owner of a door.
  printDRP( "getDoorOwner()" )
  printDRP( yrp._not )
  return NULL
end

function Entity:getKeysAllowedToOwn()
  --Description: The list of people of which the master door owner has added as allowed to own.
  printDRP( "getKeysAllowedToOwn()" )
  printDRP( yrp._not )
  return {}
end

function Entity:getKeysCoOwners()
  --Description: The list of people who co-own the door.
  printDRP( "getKeysCoOwners()" )
  printDRP( yrp._not )
  return {}
end

function Entity:getKeysDoorGroup()
  --Description: The door group of a door if it exists.
  printDRP( "getKeysDoorGroup()" )
  printDRP( yrp._not )
  return ""
end

function Entity:getKeysDoorTeams()
  --Description: The teams that are allowed to open this door.
  printDRP( "getKeysDoorTeams()" )
  printDRP( yrp._not )
  return {}
end

function Entity:getKeysNonOwnable()
  --Description: Whether ownability of this door/vehicle is disabled.
  printDRP( "getKeysNonOwnable()" )
  printDRP( yrp._not )
  return false
end

function Entity:getKeysTitle()
  --Description: Get the title of this door or vehicle.
  printDRP( "getKeysTitle()" )
  printDRP( yrp._not )
  return ""
end

function Entity:isDoor()
  --Description: Whether this entity is considered a door in DarkRP.
  printDRP( "isDoor()" )
  printDRP( yrp._not )
  return false
end

function Entity:isKeysAllowedToOwn( ply )
  --Description: Whether this player is allowed to co-own a door, as decided by the master door owner.
  printDRP( "isKeysAllowedToOwn( ply )" )
  printDRP( yrp._not )
  return false
end

function Entity:isKeysOwnable()
  --Description: Whether this door can be bought.
  printDRP( "isKeysOwnable()" )
  printDRP( yrp._not )
  return false
end

function Entity:isKeysOwned()
  --Description: Whether this door is owned by someone.
  printDRP( "isKeysOwned()" )
  printDRP( yrp._not )
  return false
end

function Entity:isKeysOwnedBy( ply )
  --Description: Whether this door is owned or co-owned by this player
  printDRP( "isKeysOwnedBy( ply )" )
  printDRP( yrp._not )
  return false
end

function Entity:isMasterOwner( ply )
  --Description: Whether the player is the main owner of the door (as opposed to a co-owner).
  printDRP( "isMasterOwner( ply )" )
  printDRP( yrp._not )
  return false
end

function Entity:isMoneyBag()
  --Description: Whether this entity is a money bag
  printDRP( "isMoneyBag()" )
  printDRP( yrp._not )
  return false
end
