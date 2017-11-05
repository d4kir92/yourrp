--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function DarkRP.addJailPos( pos )
  --Description: Add a jail position to the map. This jail position will be saved in the database.
  printDRP( "addJailPos( " .. tostring( pos ) .. " )" )
  printDRP( yrp._not )
end

function DarkRP.addTeamSpawnPos( team, pos )
  --Description: Add a spawn position to the database. The position will not replace other spawn positions.
  printDRP( "addJailPos( " .. tostring( team ) .. ", " .. tostring( pos ) .. " )" )
  printDRP( yrp._not )
end

function DarkRP.createMoneyBag( pos, amount )
  --Description: Create a money bag.
  printDRP( "createMoneyBag( " .. tostring( pos ) .. ", ".. tostring( amount ) .. " )" )

  local _moneyEnt = ents.Create( "yrp_money" )
  _moneyEnt:SetPos( pos )
  _moneyEnt:Spawn()
  _moneyEnt:SetMoney( amount )
  return _moneyEnt
end

function DarkRP.createPlayerData( ply, name, wallet, salary )
  --Description: Internal function: creates an entry in the database for a player who has joined for the first time.
  printDRP( "createPlayerData( ply, " .. name .. ", ".. tostring( wallet ) .. ", ".. tostring( salary ) .. " )" )
  printDRP( yrp._not )
end

function DarkRP.createQuestion( question, quesid, target, delay, callback, fromPly, toPly, ... )
  --Description: Ask someone a question.
  printDRP( "createQuestion( question, quesid, target, delay, callback, fromPly, toPly, ... )" )
  printDRP( yrp._not )
end

function DarkRP.createVote( question, voteid, target, delay, callback, excludeVoters, fail, ... )
  --Description: Create a vote.
  printDRP( "createVote(  question, voteid, target, delay, callback, excludeVoters, fail, ... )" )
  printDRP( yrp._not )
  return {}
end

function DarkRP.customEntityLimitReached( tblEnt )
  --Description: Set a shared variable.
  printDRP( "customEntityLimitReached( tblEnt )" )
  printDRP( yrp._not )
  return false
end

function DarkRP.defineChatCommand( command, callback )
  --Description: Create a chat command that calls the function
  printDRP( "defineChatCommand( " .. command .. ", callback )" )
  printDRP( yrp._not )
end

function DarkRP.definePrivilegedChatCommand( command, privilege, callback )
  --Description: Create a chat command that calls the function if the player has the right CAMI privilege.
  --             Will automatically notify the user when they don't have access. Note that chat command functions
  --             registered with this function can NOT override the chat that will appear after the command has been executed
  printDRP( "definePrivilegedChatCommand( " .. command .. ", " .. privilege .. ", callback )" )
  printDRP( yrp._not )
end

function DarkRP.destroyLastVote()
  --Description: Destroy the last created vote.
  printDRP( "destroyLastVote()" )
  printDRP( yrp._not )
  return false
end

function DarkRP.destroyQuestion( id )
  --Description: Destroy a question by ID.
  printDRP( "destroyQuestion( " .. id .. " )" )
  printDRP( yrp._not )
end

function DarkRP.destroyQuestionsWithEnt( ent )
  --Description: Destroy all questions that have something to do with this ent.
  printDRP( "destroyQuestionsWithEnt( ent )" )
  printDRP( yrp._not )
end

function DarkRP.destroyVotesWithEnt( ent )
  --Description: Destroy all votes that have something to do with this ent.
  printDRP( "destroyVotesWithEnt( ent )" )
  printDRP( yrp._not )
end

function DarkRP.doorIndexToEnt( index )
  --Description: Get the entity of a door index (inverse of ent:doorIndexToEnt()). Note: the door MUST have been created by the map!
  printDRP( "doorIndexToEnt( " .. tostring( index ) .. " )" )
  printDRP( yrp._not )
  return NULL
end

function DarkRP.doorToEntIndex( index )
  --Description: Get an ENT index from a door index.
  printDRP( "doorToEntIndex( " .. tostring( index ) .. " )" )
  printDRP( yrp._not )
  return -1
end

function DarkRP.findEmptyPos( pos, ignore, distance, step, area )
  --Description: Find an empty position as close as possible to the given position (Note: this algorithm is slow!).
  printDRP( "findEmptyPos( pos, ignore, distance, step, area )" )
  printDRP( yrp._not )
  return Vector( 0, 0, 0 )
end

function DarkRP.getChatSound( text )
  --Description: Get a chat sound (play a noise when someone says something) associated with the given phrase.
  printDRP( "getChatSound( " .. text .. " )" )
  printDRP( yrp._not )
  return {}
end

function DarkRP.getHits()
  --Description: Get all the active hits
  printDRP( "getHits()" )
  printDRP( yrp._not )
  return {}
end

function DarkRP.initDatabase()
  --Description: Initialize the DarkRP database.
  printDRP( "initDatabase()" )
  printDRP( yrp._not )
end

function DarkRP.isEmpty( pos, ignore )
  --Description: Destroy a question by ID.
  printDRP( "isEmpty( " .. tostring( pos ) .. ", ignore )" )
  printDRP( yrp._not )
  return false
end

function DarkRP.jailPosCount()
  --Description: The amount of jail positions in the current map.
  printDRP( "jailPosCount()" )
  printDRP( yrp._not )
  return 0
end

function DarkRP.lockdown( ply )
  --Description: Start a lockdown.
  printDRP( "lockdown( ply )" )
  printDRP( yrp._not )
  return "Old lockdown"
end

function DarkRP.log( message, colour, noFileSave )
  --Description: Log a message in DarkRP
  printDRP( "log( " .. message .. ", " .. tostring( colour ) .. ", " .. tostring( noFileSave ) .. " )" )
  printDRP( yrp._not )
end

util.AddNetworkString( "sendNotify" )
function DarkRP.notify( ply, msgType, time, message )
  --Description: Log a message in DarkRP
  printDRP( "notify( ply, msgType, time, " .. message .. " )" )

  net.Start( "sendNotify" )
    net.WriteString( message )
  net.Send( ply )
end

function DarkRP.notifyAll( msgType, time, message)
  --Description: Make a notification pop up on the everyone's screen.
  printDRP( "notifyAll( msgType, time, " .. message .. " )" )
  net.Start( "sendNotify" )
    net.WriteString( message )
  net.Broadcast()
end

function DarkRP.offlinePlayerData( SteamID, callback, failure )
  --Description: Get a player's information from the database using a SteamID for use when the player is offline.
  printDRP( "notifyAll( msgType, time, " .. message .. " )" )
  printDRP( yrp._not )
  --return?
end

function DarkRP.payDay()
  --Description: Give a player their salary.
  printDRP( "payDay()" )
  printDRP( yrp._not )
end

function DarkRP.payPlayer( sender, receiver, amount )
  --Description: Make one player give money to the other player.
  printDRP( "payPlayer( sender, receiver, " .. tostring( amount ) .. " )" )
  printDRP( yrp._not )
end

function DarkRP.printConsoleMessage( ply, msg )
  --Description: Prints a message to a given player's console. This function also handles server consoles too (EntIndex = 0).
  printDRP( "printConsoleMessage( ply, " .. msg .. " )" )
  printDRP( yrp._not )
end

function DarkRP.printMessageAll( msgType, message )
  --Description: Make a notification pop up in the middle of everyone's screen.
  printDRP( "printMessageAll( msgType, " .. message .. " )" )
  printDRP( yrp._not )
end

function DarkRP.removeTeamSpawnPos( team, pos )
  --Description: Remove a single spawn position.
  printDRP( "removeTeamSpawnPos( team, pos )" )
  printDRP( yrp._not )
end

function DarkRP.resetLaws()
  --Description: Reset to default laws.
  printDRP( "resetLaws()" )
  printDRP( yrp._not )
end

function DarkRP.restorePlayerData()
  --Description: Internal function that restores a player's DarkRP information when they join.
  printDRP( "restorePlayerData()" )
  printDRP( yrp._not )
end

function DarkRP.retrieveJailPos( index )
  --Description: Retrieve a jail position.
  printDRP( "retrieveJailPos( index )" )
  printDRP( yrp._not )
  return Vector( 0, 0, 0 )
end

function DarkRP.retrievePlayerData( ply, callback, failure )
  --Description: Get a player's information from the database.
  printDRP( "retrievePlayerData( ply, callback, failure )" )
  printDRP( yrp._not )
end

function DarkRP.retrieveRPNames( name, callback )
  --Description: Whether a given RP name is taken by someone else.
  printDRP( "retrieveRPNames( name, callback )" )
  printDRP( yrp._not )
end

function DarkRP.retrieveSalary( ply, callback )
  --Description: Get a player's salary from the database.
  printDRP( "retrieveSalary( ply, callback )" )
  printDRP( yrp._not )
  return 0
end

function DarkRP.retrieveTeamSpawnPos( team )
  --Description: Retrieve a random spawn position for a job.
  printDRP( "retrieveTeamSpawnPos( team )" )
  printDRP( yrp._not )
  return Vector( 0, 0, 0 )
end

function DarkRP.setChatSound( text, sounds )
  --Description: Set a chat sound (play a noise when someone says something)
  printDRP( "setChatSound( text, sounds )" )
  printDRP( yrp._not )
end

function DarkRP.setJailPos( pos )
  --Description: Remove all jail positions in this map and create a new one. To
  --             add a jailpos without removing previous ones use
  --             DarkRP.addJailPos. This jail position will be saved in the
  --             database.
  printDRP( "setJailPos( pos )" )
  printDRP( yrp._not )
end

function DarkRP.storeDoorData( ent )
  --Description: Store the information about a door in the database.
  printDRP( "storeDoorData( ent )" )
  printDRP( yrp._not )
end

function DarkRP.storeDoorGroup( ent, group )
  --Description: Store the group of a door in the database.
  printDRP( "storeDoorGroup( ent, group )" )
  printDRP( yrp._not )
end

function DarkRP.storeJailPos( ply, addingPos )
  --Description: Store a jailposition from a player's location.
  printDRP( "storeJailPos( ply, addingPos )" )
  printDRP( yrp._not )
end

function DarkRP.storeMoney( ply, amount )
  --Description: Internal function. Store a player's money in the database. Do
  --             not call this if you just want to set someone's money, the
  --             player will not see the change!
  printDRP( "storeMoney( ply, amount )" )
  printDRP( yrp._not )
end

function DarkRP.storeOfflineMoney( sid64, amount )
  --Description: Store the wallet amount of an offline player. Use
  --             DarkRP.offlinePlayerData to fetch the current wallet amount.
  printDRP( "storeOfflineMoney( sid64, amount )" )
  printDRP( yrp._not )
end

function DarkRP.storeRPName( ply, name )
  --Description: Store an RP name in the database.
  printDRP( "storeRPName( ply, name )" )
  printDRP( yrp._not )
end

function DarkRP.storeTeamDoorOwnability( ent )
  --Description: Store the ownability information of a door in the database.
  printDRP( "storeTeamDoorOwnability( ent )" )
  printDRP( yrp._not )
end

function DarkRP.storeTeamSpawnPos( team, pos )
  --Description: Store a spawn position of a job in the database (replaces all
  --             other spawn positions).
  printDRP( "storeTeamSpawnPos( team, pos )" )
  printDRP( yrp._not )
end

function DarkRP.talkToPerson( receiver, col1, text1, col2, text2, sender )
  --Description: Send a chat message to a player.
  printDRP( "talkToPerson( receiver, col1, text1, col2, text2, sender )" )
  printDRP( yrp._not )
end

function DarkRP.talkToRange( ply, playerName, message, size )
  --Description: Send a chat message to people close to a player.
  printDRP( "talkToRange( ply, playerName, message, size )" )
  printDRP( yrp._not )
end

function DarkRP.toggleSleep( ply, command )
  --Description: Old function to toggle sleep. I'm not proud of it.
  printDRP( "toggleSleep( ply, command )" )
  printDRP( yrp._not )
  return ""
end

function DarkRP.unLockdown( ply )
  --Description: Stop the lockdown.
  printDRP( "unLockdown( ply )" )
  printDRP( yrp._not )
  return ""
end

function DarkRP.writeNetDoorVar( name, var )
  --Description: Internal function. You probably shouldn't need this. DarkRP
  --             calls this function when sending DoorVar net messages. This
  --             function writes the net data for a specific DoorVar.
  printDRP( "writeNetDoorVar( name, var )" )
  printDRP( yrp._not )
end
