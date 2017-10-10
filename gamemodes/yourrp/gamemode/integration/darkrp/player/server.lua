--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local Player = FindMetaTable( "Player" )

function Player:abortHit( message )
  --Description: Abort a hit
  printDRP( "abortHit( " .. message .. " )" )
  printDRP( yrp._not )
end

function Player:addCustomEntity( tblEnt )
  --Description: Add a custom entity to the player's limit.
  printDRP( "addCustomEntity( table )" )
  printDRP( yrp._not )
end

function Player:addPocketItem( ent )
  --Description: Add an item to the pocket of the player.
  printDRP( "addPocketItem( ent )" )
  printDRP( yrp._not )
end

function Player:applyPlayerClassVars( applyHealth )
  --Description: Applies all variables in a player's associated GMod player class to the player.
  printDRP( "applyPlayerClassVars( " .. tostring( applyHealth ) .. " )" )
  printDRP( yrp._not )
end

function Player:arrest( time, Arrester )
  --Description: Arrest a player.
  printDRP( "arrest( " .. tostring( time ) .. ", " .. Arrester:Nick() .. " )" )
  self:SetNWBool( "inJail", true )
  self:SetNWInt( "jailtime", time )
end

function Player:canKeysLock( door )
  --Description: Whether the player can lock a given door.
  printDRP( "canKeysLock( door )" )
  printDRP( yrp._not )
  return false
end

function Player:canKeysUnlock( door )
  --Description: Whether the player can unlock a given door.
  printDRP( "canKeysUnlock( door )" )
  printDRP( yrp._not )
  return false
end

function Player:changeAllowed( team )
  --Description: Returns whether a player is allowed to get a certain job.
  printDRP( "arrest( " .. tostring( team ) .. " )" )
  printDRP( yrp._not )
  return false
end

function Player:changeTeam( team, force, suppressNotification )
  --Description: Change the team of a player.
  printDRP( "changeTeam( " .. tostring( team ) .. ", " .. tostring( force ) .. ", " .. tostring( suppressNotification ) .. " )" )
  printDRP( yrp._not )
  return false
end

function Player:doPropertyTax()
  --Description: Tax a player based on the amount of doors and vehicles they have.
  printDRP( "doPropertyTax()" )
  printDRP( yrp._not )
end

function Player:dropDRPWeapon( weapon )
  --Description: Drop the weapon with animations.
  printDRP( "dropDRPWeapon( weapon )" )
  printDRP( yrp._not )
end

function Player:dropPocketItem( ent )
  --Description: Make the player drop an item from the pocket.
  printDRP( "dropPocketItem( ent )" )
  printDRP( yrp._not )
end

function Player:finishHit()
  --Description: End a hit without a message
  printDRP( "finishHit()" )
  printDRP( yrp._not )
end

function Player:getHitCustomer()
  --Description: Get the customer for the current hit
  printDRP( "getHitCustomer()" )
  printDRP( yrp._not )
  return NULL
end

function Player:getHitmanTeams()
  --Description: Get all the hitman teams.
  printDRP( "getHitmanTeams()" )
  printDRP( yrp._not )
  return {}
end

function Player:getPreferredModel( teamNr )
  --Description: Get the preferred model of a player for a job.
  printDRP( "getPreferredModel( " .. teamNr .. " )" )
  printDRP( yrp._not )
  return ""
end

function Player:hungerUpdate()
  --Description: Makes the player slightly more hungry. Called in a timer by default.
  printDRP( "hungerUpdate()" )
  printDRP( yrp._not )
end

function Player:initiateTax()
  --Description: Internal function, starts the timer that taxes the player every once in a while.
  printDRP( "initiateTax()" )
  printDRP( yrp._not )
end

function Player:keysUnOwnAll()
  --Description: Unown every door and vehicle owned by this player.
  printDRP( "keysUnOwnAll()" )
  printDRP( yrp._not )
end

function Player:newHungerData()
  --Description: Create the initial hunger data (called on PlayerInitialSpawn).
  printDRP( "newHungerData()" )
  printDRP( yrp._not )
end

function Player:placeHit( customer, target, price )
  --Description: Place an actual hit.
  printDRP( "placeHit( customer, target, price )" )
  printDRP( yrp._not )
end

function Player:removeCustomEntity( tblEnt )
  --Description: Remove a custom entity to the player's limit.
  printDRP( "removeCustomEntity( tblEnt )" )
  printDRP( yrp._not )
end

function Player:removeDarkRPVar( variable, target )
  --Description: Remove a shared variable. Exactly the same as ply:setDarkRPVar(nil).
  printDRP( "removeDarkRPVar( variable, target )" )
  printDRP( yrp._not )
end

function Player:removePocketItem( item )
  --Description: Remove an item from the pocket of the player.
  printDRP( "removePocketItem( item )" )
  printDRP( yrp._not )
end

function Player:requestHit( customer, target, price )
  --Description: Request a hit to a hitman.
  printDRP( "requestHit( customer, target, price )" )
  printDRP( yrp._not )
  return false
end

function Player:requestWarrant( suspect, actor, reason )
  --Description: File a request for a search warrant.
  printDRP( "requestWarrant( suspect, actor, reason )" )
  printDRP( yrp._not )
end

function Player:sendDarkRPVars()
  --Description: Internal function. Sends all visibleDarkRPVars of all players to this player.
  printDRP( "sendDarkRPVars()" )
  printDRP( yrp._not )
end

function Player:sendDoorData()
  --Description: Internal function. Sends all door data to a player.
  printDRP( "sendDoorData()" )
  printDRP( yrp._not )
end

function Player:setDarkRPVar( variable, value, target )
  --Description: Set a shared variable. Make sure the variable is registered with DarkRP.registerDarkRPVar!
  printDRP( "setDarkRPVar( variable, value, target )" )
  printDRP( yrp._not )
end

function Player:setHitCustomer( customer )
  --Description: Set the customer who pays for the hit.
  printDRP( "setHitCustomer( customer )" )
  printDRP( yrp._not )
end

function Player:setHitPrice( price )
  --Description: Set the price of a hit
  printDRP( "setHitPrice( price )" )
  printDRP( yrp._not )
end

function Player:setHitTarget( target )
  --Description: Set the target of a hit
  printDRP( "setHitTarget( target )" )
  printDRP( yrp._not )
end

function Player:setRPName( name, firstrun )
  --Description: Set the RPName of a player.
  printDRP( "setRPName( name, firstrun )" )
  printDRP( yrp._not )
end

function Player:setSelfDarkRPVar( variable, value )
  --Description: Set a shared variable that is only seen by the player to whom this variable applies.
  printDRP( "setSelfDarkRPVar( variable, value )" )
  printDRP( yrp._not )
end

function Player:teamBan( team, time )
  --Description: Ban someone from getting a certain job.
  printDRP( "teamBan( team, time )" )
  printDRP( yrp._not )
end

function Player:teamBanTimeLeft( team )
  --Description: Returns the time left on a player's teamban.
  printDRP( "teamBanTimeLeft( team )" )
  printDRP( yrp._not )
end

function Player:teamUnBan( team )
  --Description: Unban someone from a team.
  printDRP( "teamUnBan( team )" )
  printDRP( yrp._not )
end

function Player:unArrest( Unarrester )
  --Description: Unarrest a player.
  printDRP( "unArrest( Unarrester )" )
  self:SetNWBool( "inJail", false )
end

function Player:unWanted( actor )
  --Description: Clear the wanted status for this person.
  printDRP( "unWanted( actor )" )
  printDRP( yrp._not )
end

function Player:unWarrant( unwarranter )
  --Description: Remove the search warrant for this person.
  printDRP( "unWarrant( unwarranter )" )
  printDRP( yrp._not )
end

function Player:updateJob( job )
  --Description: Set the job name of a player (doesn't change the actual team).
  printDRP( "updateJob( job )" )
  printDRP( yrp._not )
end

function Player:wanted( actor, reason, time )
  --Description: Make this person wanted by the police.
  printDRP( "wanted( actor, reason, time )" )
  printDRP( yrp._not )
end

function Player:warrant( warranter, reason )
  --Description: Get a search warrant for this person.
  printDRP( "warrant( warranter, reason )" )
  printDRP( yrp._not )
end
