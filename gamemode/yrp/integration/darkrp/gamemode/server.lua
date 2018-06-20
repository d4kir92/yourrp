--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function DarkRP.addJailPos( pos )
	--Description: Add a jail position to the map. This jail position will be saved in the database.
	printGM( "darkrp", "addJailPos( " .. tostring( pos ) .. " )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.addTeamSpawnPos( team, pos )
	--Description: Add a spawn position to the database. The position will not replace other spawn positions.
	printGM( "darkrp", "addJailPos( " .. tostring( team ) .. ", " .. tostring( pos ) .. " )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.createMoneyBag( pos, amount )
	--Description: Create a money bag.
	printGM( "darkrp", "createMoneyBag( " .. tostring( pos ) .. ", ".. tostring( amount ) .. " )" )

	local _moneyEnt = ents.Create( "yrp_money" )
	_moneyEnt:SetPos( pos )
	_moneyEnt:Spawn()
	_moneyEnt:SetMoney( amount )
	return _moneyEnt
end

function DarkRP.createPlayerData( ply, name, wallet, salary )
	--Description: Internal function: creates an entry in the database for a player who has joined for the first time.
	printGM( "darkrp", "createPlayerData( ply, " .. name .. ", ".. tostring( wallet ) .. ", ".. tostring( salary ) .. " )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.createQuestion( question, quesid, target, delay, callback, fromPly, toPly, ... )
	--Description: Ask someone a question.
	printGM( "darkrp", "createQuestion( question, quesid, target, delay, callback, fromPly, toPly, ... )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.createVote( question, voteid, target, delay, callback, excludeVoters, fail, ... )
	--Description: Create a vote.
	printGM( "darkrp", "createVote(	question, voteid, target, delay, callback, excludeVoters, fail, ... )" )
	printGM( "darkrp", DarkRP._not )
	return {}
end

function DarkRP.customEntityLimitReached( tblEnt )
	--Description: Set a shared variable.
	printGM( "darkrp", "customEntityLimitReached( tblEnt )" )
	printGM( "darkrp", DarkRP._not )
	return false
end

function DarkRP.defineChatCommand( command, callback )
	--Description: Create a chat command that calls the function
	printGM( "darkrp", "defineChatCommand( " .. command .. ", callback )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.definePrivilegedChatCommand( command, privilege, callback )
	--Description: Create a chat command that calls the function if the player has the right CAMI privilege.
	--						 Will automatically notify the user when they don't have access. Note that chat command functions
	--						 registered with this function can NOT override the chat that will appear after the command has been executed
	printGM( "darkrp", "definePrivilegedChatCommand( " .. command .. ", " .. privilege .. ", callback )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.destroyLastVote()
	--Description: Destroy the last created vote.
	printGM( "darkrp", "destroyLastVote()" )
	printGM( "darkrp", DarkRP._not )
	return false
end

function DarkRP.destroyQuestion( id )
	--Description: Destroy a question by ID.
	printGM( "darkrp", "destroyQuestion( " .. id .. " )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.destroyQuestionsWithEnt( ent )
	--Description: Destroy all questions that have something to do with this ent.
	printGM( "darkrp", "destroyQuestionsWithEnt( ent )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.destroyVotesWithEnt( ent )
	--Description: Destroy all votes that have something to do with this ent.
	printGM( "darkrp", "destroyVotesWithEnt( ent )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.doorIndexToEnt( index )
	--Description: Get the entity of a door index (inverse of ent:doorIndexToEnt()). Note: the door MUST have been created by the map!
	printGM( "darkrp", "doorIndexToEnt( " .. tostring( index ) .. " )" )
	printGM( "darkrp", DarkRP._not )
	return NULL
end

function DarkRP.doorToEntIndex( index )
	--Description: Get an ENT index from a door index.
	printGM( "darkrp", "doorToEntIndex( " .. tostring( index ) .. " )" )
	printGM( "darkrp", DarkRP._not )
	return -1
end

function DarkRP.findEmptyPos( pos, ignore, distance, step, area )
	--Description: Find an empty position as close as possible to the given position (Note: this algorithm is slow!).
	printGM( "darkrp", "findEmptyPos( pos, ignore, distance, step, area )" )
	printGM( "darkrp", DarkRP._not )
	return Vector( 0, 0, 0 )
end

function DarkRP.getChatSound( text )
	--Description: Get a chat sound (play a noise when someone says something) associated with the given phrase.
	printGM( "darkrp", "getChatSound( " .. text .. " )" )
	printGM( "darkrp", DarkRP._not )
	return {}
end

function DarkRP.getHits()
	--Description: Get all the active hits
	printGM( "darkrp", "getHits()" )
	printGM( "darkrp", DarkRP._not )
	return {}
end

function DarkRP.initDatabase()
	--Description: Initialize the DarkRP database.
	printGM( "darkrp", "initDatabase()" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.isEmpty( pos, ignore )
	--Description: Destroy a question by ID.
	printGM( "darkrp", "isEmpty( " .. tostring( pos ) .. ", ignore )" )
	printGM( "darkrp", DarkRP._not )
	return false
end

function DarkRP.jailPosCount()
	--Description: The amount of jail positions in the current map.
	printGM( "darkrp", "jailPosCount()" )
	printGM( "darkrp", DarkRP._not )
	return 0
end

function DarkRP.lockdown( ply )
	--Description: Start a lockdown.
	printGM( "darkrp", "lockdown( ply )" )
	printGM( "darkrp", DarkRP._not )
	return "Old lockdown"
end

function DarkRP.log( message, colour, noFileSave )
	--Description: Log a message in DarkRP
	printGM( "darkrp", "log( " .. message .. ", " .. tostring( colour ) .. ", " .. tostring( noFileSave ) .. " )" )
	printGM( "darkrp", DarkRP._not )
end

util.AddNetworkString( "sendNotify" )
function DarkRP.notify( ply, msgType, time, message )
	--Description: Log a message in DarkRP
	printGM( "darkrp", "notify( ply, msgType, time, " .. tostring( message ) .. " )" )
	if ply:IsPlayer() and wk( message ) then
		net.Start( "sendNotify" )
			net.WriteString( message )
		net.Send( ply )
	else
		printGM( "gm", "[DarkRP.notify] message is NIL" )
	end
end

function DarkRP.notifyAll( msgType, time, message)
	--Description: Make a notification pop up on the everyone's screen.
	printGM( "darkrp", "notifyAll( msgType, time, " .. message .. " )" )
	net.Start( "sendNotify" )
		net.WriteString( message )
	net.Broadcast()
end

function DarkRP.offlinePlayerData( SteamID, callback, failure )
	--Description: Get a player's information from the database using a SteamID for use when the player is offline.
	printGM( "darkrp", "offlinePlayerData( SteamID, callback, " .. tostring( failure ) .. " )" )
	printGM( "darkrp", DarkRP._not )
	--return?
end

function DarkRP.payDay()
	--Description: Give a player their salary.
	printGM( "darkrp", "payDay()" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.payPlayer( sender, receiver, amount )
	--Description: Make one player give money to the other player.
	printGM( "darkrp", "payPlayer( sender, receiver, " .. tostring( amount ) .. " )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.printConsoleMessage( ply, msg )
	--Description: Prints a message to a given player's console. This function also handles server consoles too (EntIndex = 0).
	printGM( "darkrp", "printConsoleMessage( ply, " .. msg .. " )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.printMessageAll( msgType, message )
	--Description: Make a notification pop up in the middle of everyone's screen.
	printGM( "darkrp", "printMessageAll( msgType, " .. message .. " )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.removeTeamSpawnPos( team, pos )
	--Description: Remove a single spawn position.
	printGM( "darkrp", "removeTeamSpawnPos( team, pos )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.resetLaws()
	--Description: Reset to default laws.
	printGM( "darkrp", "resetLaws()" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.restorePlayerData()
	--Description: Internal function that restores a player's DarkRP information when they join.
	printGM( "darkrp", "restorePlayerData()" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.retrieveJailPos( index )
	--Description: Retrieve a jail position.
	printGM( "darkrp", "retrieveJailPos( " .. tostring( index ) .. " )" )
	printGM( "darkrp", DarkRP._not )
	return Vector( 0, 0, 0 )
end

function DarkRP.retrievePlayerData( ply, callback, failure )
	--Description: Get a player's information from the database.
	printGM( "darkrp", "retrievePlayerData( ply, callback, failure )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.retrieveRPNames( name, callback )
	--Description: Whether a given RP name is taken by someone else.
	printGM( "darkrp", "retrieveRPNames( name, callback )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.retrieveSalary( ply, callback )
	--Description: Get a player's salary from the database.
	printGM( "darkrp", "retrieveSalary( ply, callback )" )
	printGM( "darkrp", DarkRP._not )
	return 0
end

function DarkRP.retrieveTeamSpawnPos( team )
	--Description: Retrieve a random spawn position for a job.
	printGM( "darkrp", "retrieveTeamSpawnPos( team )" )
	printGM( "darkrp", DarkRP._not )
	return Vector( 0, 0, 0 )
end

function DarkRP.setChatSound( text, sounds )
	--Description: Set a chat sound (play a noise when someone says something)
	printGM( "darkrp", "setChatSound( text, sounds )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.setJailPos( pos )
	--Description: Remove all jail positions in this map and create a new one. To
	--						 add a jailpos without removing previous ones use
	--						 DarkRP.addJailPos. This jail position will be saved in the
	--						 database.
	printGM( "darkrp", "setJailPos( pos )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.storeDoorData( ent )
	--Description: Store the information about a door in the database.
	printGM( "darkrp", "storeDoorData( ent )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.storeDoorGroup( ent, group )
	--Description: Store the group of a door in the database.
	printGM( "darkrp", "storeDoorGroup( ent, group )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.storeJailPos( ply, addingPos )
	--Description: Store a jailposition from a player's location.
	printGM( "darkrp", "storeJailPos( ply, addingPos )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.storeMoney( ply, amount )
	--Description: Internal function. Store a player's money in the database. Do
	--						 not call this if you just want to set someone's money, the
	--						 player will not see the change!
	printGM( "darkrp", "storeMoney( ply, amount )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.storeOfflineMoney( sid64, amount )
	--Description: Store the wallet amount of an offline player. Use
	--						 DarkRP.offlinePlayerData to fetch the current wallet amount.
	printGM( "darkrp", "storeOfflineMoney( sid64, amount )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.storeRPName( ply, name )
	--Description: Store an RP name in the database.
	printGM( "darkrp", "storeRPName( ply, name )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.storeTeamDoorOwnability( ent )
	--Description: Store the ownability information of a door in the database.
	printGM( "darkrp", "storeTeamDoorOwnability( ent )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.storeTeamSpawnPos( team, pos )
	--Description: Store a spawn position of a job in the database (replaces all
	--						 other spawn positions).
	printGM( "darkrp", "storeTeamSpawnPos( team, pos )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.talkToPerson( receiver, col1, text1, col2, text2, sender )
	--Description: Send a chat message to a player.
	printGM( "darkrp", "talkToPerson( receiver, col1, text1, col2, text2, sender )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.talkToRange( ply, playerName, message, size )
	--Description: Send a chat message to people close to a player.
	printGM( "darkrp", "talkToRange( ply, playerName, message, size )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.toggleSleep( ply, command )
	--Description: Old function to toggle sleep. I'm not proud of it.
	printGM( "darkrp", "toggleSleep( ply, command )" )
	printGM( "darkrp", DarkRP._not )
	return ""
end

function DarkRP.unLockdown( ply )
	--Description: Stop the lockdown.
	printGM( "darkrp", "unLockdown( ply )" )
	printGM( "darkrp", DarkRP._not )
	return ""
end

function DarkRP.writeNetDoorVar( name, var )
	--Description: Internal function. You probably shouldn't need this. DarkRP
	--						 calls this function when sending DoorVar net messages. This
	--						 function writes the net data for a specific DoorVar.
	printGM( "darkrp", "writeNetDoorVar( name, var )" )
	printGM( "darkrp", DarkRP._not )
end
