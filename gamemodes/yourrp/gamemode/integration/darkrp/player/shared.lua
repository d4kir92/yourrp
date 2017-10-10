--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local Player = FindMetaTable( "Player" )

AddCSLuaFile( "client.lua" )

if CLIENT then
  include( "client.lua" )
else
  include( "server.lua" )
end

function Player:getAgendaTable()
  --Description: Get the agenda a player can see. Note: when a player is not the manager of an agenda, it returns the agenda of the manager.
  printDRP( "getAgendaTable()" )
  printDRP( yrp._not )
  return {}
end

local DarkRPVars = {}
function Player:getDarkRPVar( var )
  --Description: Get the value of a DarkRPVar, which is shared between server and client.
  printDRP( "getDarkRPVar( " .. var .. " )" )
  local vars = DarkRPVars[self:UserID()]
  return vars and vars[var] or nil
end

function Player:getEyeSightHitEntity( searchDistance, hitDistance, filter )
  --Description: Get the entity that is closest to a player's line of sight and its distance.
  printDRP( "getEyeSightHitEntity( searchDistance, hitDistance, filter )" )
  printDRP( yrp._not )
  return NULL, 0
end

function Player:getHitPrice()
  --Description: Get the price the hitman demands for his work.
  printDRP( "getHitPrice()" )
  printDRP( yrp._not )
  return 0
end

function Player:getHitTarget()
  --Description: Get the target of a hitman.
  printDRP( "getHitTarget()" )
  printDRP( yrp._not )
  return NULL
end

function Player:getJobTable()
  --Description: Get the job table of a player.
  printDRP( "getJobTable()" )
  printDRP( yrp._not )
  return {}
end

function Player:getPocketItems()
  --Description: Get a player's pocket items.
  printDRP( "getPocketItems()" )
  printDRP( yrp._not )
  return {}
end

function Player:getWantedReason()
  --Description: Get the reason why someone is wanted
  printDRP( "getWantedReason()" )
  printDRP( yrp._not )
  return "old getWantedReason"
end

function Player:hasDarkRPPrivilege( priv )
  --Description: Whether the player has a certain privilege.
  printDRP( "hasDarkRPPrivilege( " .. tostring( priv ) .. " )" )
  printDRP( yrp._not )
  return false
end

function Player:hasHit()
  --Description: Whether this hitman has a hit.
  printDRP( "hasHit()" )
  printDRP( yrp._not )
  return false
end

function Player:isArrested()
  --Description: Whether this player is arrested
  --printDRP( "isArrested()" )
  return self:GetNWBool( "inJail", false )
end

function Player:isChief()
  --Description: Whether this player is a Chief.
  printDRP( "isChief()" )
  printDRP( yrp._not )
  return false
end

function Player:isCook()
  --Description: Whether this player is a cook. This function is only available if hungermod is enabled.
  printDRP( "isCook()" )
  printDRP( yrp._not )
  return false
end

function Player:isCP()
  --Description: Whether this player is part of the police force (mayor, cp, chief).
  printDRP( "isCP()" )
  printDRP( yrp._not )
  return true
end

function Player:isHitman()
  --Description: Whether this player is a hitman.
  printDRP( "isHitman()" )
  printDRP( yrp._not )
  return false
end

function Player:isMayor()
  --Description: Whether this player is a mayor.
  printDRP( "isMayor()" )
  printDRP( yrp._not )
  return false
end

function Player:isMedic()
  --Description: Whether this player is a medic.
  printDRP( "isMedic()" )
  printDRP( yrp._not )
  return false
end

function Player:isWanted()
  --Description: Whether this player is wanted
  printDRP( "isWanted()" )
  printDRP( yrp._not )
  return false
end

function Player:nickSortedPlayers()
  --Description: A table of players sorted by RP name.
  printDRP( "nickSortedPlayers()" )
  printDRP( yrp._not )
  return {}
end
