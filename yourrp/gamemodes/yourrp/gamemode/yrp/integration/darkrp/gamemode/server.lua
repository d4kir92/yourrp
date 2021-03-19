--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

function DarkRP.addJailPos(pos)
	--Description: Add a jail position to the map. This jail position will be saved in the database.
	YRP.msg("darkrp", "addJailPos(" .. tostring(pos) .. ")")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.addTeamSpawnPos(team, pos)
	--Description: Add a spawn position to the database. The position will not replace other spawn positions.
	YRP.msg("darkrp", "addJailPos(" .. tostring(team) .. ", " .. tostring(pos) .. ")")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.createMoneyBag(pos, amount)
	--Description: Create a money bag.
	YRP.msg("darkrp", "createMoneyBag(" .. tostring(pos) .. ", ".. tostring(amount) .. ")")

	local _moneyEnt = ents.Create("yrp_money")
	_moneyEnt:SetPos(pos)
	_moneyEnt:Spawn()
	_moneyEnt:SetMoney(amount)
	return _moneyEnt
end

function DarkRP.createPlayerData(ply, name, wallet, salary)
	--Description: Internal function: creates an entry in the database for a player who has joined for the first time.
	YRP.msg("darkrp", "createPlayerData(ply, " .. name .. ", ".. tostring(wallet) .. ", ".. tostring(salary) .. ")")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.createQuestion(question, quesid, target, delay, callback, fromPly, toPly, ...)
	--Description: Ask someone a question.
	YRP.msg("darkrp", "createQuestion(question, quesid, target, delay, callback, fromPly, toPly, ...)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.createVote(question, voteid, target, delay, callback, excludeVoters, fail, ...)
	--Description: Create a vote.
	YRP.msg("darkrp", "createVote(	question, voteid, target, delay, callback, excludeVoters, fail, ...)")
	YRP.msg("darkrp", DarkRP._not)
	return {}
end

function DarkRP.customEntityLimitReached(tblEnt)
	--Description: Set a shared variable.
	YRP.msg("darkrp", "customEntityLimitReached(tblEnt)")
	YRP.msg("darkrp", DarkRP._not)
	return false
end

function DarkRP.defineChatCommand(command, callback)
	--Description: Create a chat command that calls the function
	YRP.msg("darkrp", "defineChatCommand(" .. command .. ", callback)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.definePrivilegedChatCommand(command, privilege, callback)
	--Description: Create a chat command that calls the function if the player has the right CAMI privilege.
	--						 Will automatically notify the user when they don't have access. Note that chat command functions
	--						 registered with this function can NOT override the chat that will appear after the command has been executed
	YRP.msg("darkrp", "definePrivilegedChatCommand(" .. command .. ", " .. privilege .. ", callback)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.destroyLastVote()
	--Description: Destroy the last created vote.
	YRP.msg("darkrp", "destroyLastVote()")
	YRP.msg("darkrp", DarkRP._not)
	return false
end

function DarkRP.destroyQuestion(id)
	--Description: Destroy a question by ID.
	YRP.msg("darkrp", "destroyQuestion(" .. id .. ")")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.destroyQuestionsWithEnt(ent)
	--Description: Destroy all questions that have something to do with this ent.
	YRP.msg("darkrp", "destroyQuestionsWithEnt(ent)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.destroyVotesWithEnt(ent)
	--Description: Destroy all votes that have something to do with this ent.
	YRP.msg("darkrp", "destroyVotesWithEnt(ent)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.doorIndexToEnt(index)
	--Description: Get the entity of a door index (inverse of ent:doorIndexToEnt()). Note: the door MUST have been created by the map!
	YRP.msg("darkrp", "doorIndexToEnt(" .. tostring(index) .. ")")
	YRP.msg("darkrp", DarkRP._not)
	return NULL
end

function DarkRP.doorToEntIndex(index)
	--Description: Get an ENT index from a door index.
	YRP.msg("darkrp", "doorToEntIndex(" .. tostring(index) .. ")")
	YRP.msg("darkrp", DarkRP._not)
	return -1
end

function DarkRP.findEmptyPos(pos, ignore, distance, step, area)
	--Description: Find an empty position as close as possible to the given position (Note: this algorithm is slow!).
	YRP.msg("darkrp", "findEmptyPos(pos, ignore, distance, step, area)")
	YRP.msg("darkrp", DarkRP._not)
	return Vector(0, 0, 0)
end

function DarkRP.getChatSound(text)
	--Description: Get a chat sound (play a noise when someone says something) associated with the given phrase.
	YRP.msg("darkrp", "getChatSound(" .. text .. ")")
	YRP.msg("darkrp", DarkRP._not)
	return {}
end

function DarkRP.getHits()
	--Description: Get all the active hits
	YRP.msg("darkrp", "getHits()")
	YRP.msg("darkrp", DarkRP._not)
	return {}
end

function DarkRP.initDatabase()
	--Description: Initialize the DarkRP database.
	YRP.msg("darkrp", "initDatabase()")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.isEmpty(pos, ignore)
	--Description: Destroy a question by ID.
	YRP.msg("darkrp", "isEmpty(" .. tostring(pos) .. ", ignore)")
	YRP.msg("darkrp", DarkRP._not)
	return false
end

function DarkRP.jailPosCount()
	--Description: The amount of jail positions in the current map.
	YRP.msg("darkrp", "jailPosCount()")
	YRP.msg("darkrp", DarkRP._not)
	return 0
end

function DarkRP.lockdown(ply)
	--Description: Start a lockdown.
	YRP.msg("darkrp", "lockdown(ply)")
	YRP.msg("darkrp", DarkRP._not)
	return "Old lockdown"
end

function DarkRP.log(message, colour, noFileSave)
	--Description: Log a message in DarkRP
	YRP.msg("darkrp", "log(" .. message .. ", " .. tostring(colour) .. ", " .. tostring(noFileSave) .. ")")
	YRP.msg("darkrp", DarkRP._not)
end

util.AddNetworkString("sendNotify")
function DarkRP.notify(ply, msgType, time, message)
	--Description: Log a message in DarkRP
	if ply:IsPlayer() and wk(message) then
		net.Start("sendNotify")
			net.WriteString(message)
		net.Send(ply)
	else
		YRP.msg("gm", "[DarkRP.notify] message is NIL")
	end
end

function DarkRP.notifyAll(msgType, time, message)
	--Description: Make a notification pop up on the everyone's screen.
	YRP.msg("darkrp", "notifyAll(msgType, time, " .. message .. ")")
	net.Start("sendNotify")
		net.WriteString(message)
	net.Broadcast()
end

function DarkRP.offlinePlayerData(SteamID, callback, failure)
	--Description: Get a player's information from the database using a SteamID for use when the player is offline.
	YRP.msg("darkrp", "offlinePlayerData(SteamID, callback, " .. tostring(failure) .. ")")
	YRP.msg("darkrp", DarkRP._not)
	--return?
end

function DarkRP.payDay()
	--Description: Give a player their salary.
	YRP.msg("darkrp", "payDay()")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.payPlayer(sender, receiver, amount)
	--Description: Make one player give money to the other player.
	if sender:canAfford(amount) then
		sender:AddMoney(-amount)
		receiver:AddMoney(amount)
	else
		YRP.msg("note", sender:RPName() .. " don't have enough money to payplayer " .. receiver:RPName())
	end
end

function DarkRP.printConsoleMessage(ply, msg)
	--Description: Prints a message to a given player's console. This function also handles server consoles too (EntIndex = 0).
	YRP.msg("darkrp", "printConsoleMessage(ply, " .. msg .. ")")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.printMessageAll(msgType, message)
	--Description: Make a notification pop up in the middle of everyone's screen.
	YRP.msg("darkrp", "printMessageAll(msgType, " .. message .. ")")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.removeTeamSpawnPos(team, pos)
	--Description: Remove a single spawn position.
	YRP.msg("darkrp", "removeTeamSpawnPos(team, pos)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.resetLaws()
	--Description: Reset to default laws.
	YRP.msg("darkrp", "resetLaws()")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.restorePlayerData()
	--Description: Internal function that restores a player's DarkRP information when they join.
	YRP.msg("darkrp", "restorePlayerData()")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.retrieveJailPos(index)
	--Description: Retrieve a jail position.
	YRP.msg("darkrp", "retrieveJailPos(" .. tostring(index) .. ")")
	YRP.msg("darkrp", DarkRP._not)
	return Vector(0, 0, 0)
end

function DarkRP.retrievePlayerData(ply, callback, failure)
	--Description: Get a player's information from the database.
	YRP.msg("darkrp", "retrievePlayerData(ply, callback, failure)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.retrieveRPNames(name, callback)
	--Description: Whether a given RP name is taken by someone else.
	YRP.msg("darkrp", "retrieveRPNames(name, callback)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.retrieveSalary(ply, callback)
	--Description: Get a player's salary from the database.
	YRP.msg("darkrp", "retrieveSalary(ply, callback)")
	YRP.msg("darkrp", DarkRP._not)
	return 0
end

function DarkRP.retrieveTeamSpawnPos(team)
	--Description: Retrieve a random spawn position for a job.
	YRP.msg("darkrp", "retrieveTeamSpawnPos(team)")
	YRP.msg("darkrp", DarkRP._not)
	return Vector(0, 0, 0)
end

function DarkRP.setChatSound(text, sounds)
	--Description: Set a chat sound (play a noise when someone says something)
	YRP.msg("darkrp", "setChatSound(text, sounds)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.setJailPos(pos)
	--Description: Remove all jail positions in this map and create a new one. To
	--						 add a jailpos without removing previous ones use
	--						 DarkRP.addJailPos. This jail position will be saved in the
	--						 database.
	YRP.msg("darkrp", "setJailPos(pos)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.storeDoorData(ent)
	--Description: Store the information about a door in the database.
	YRP.msg("darkrp", "storeDoorData(ent)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.storeDoorGroup(ent, group)
	--Description: Store the group of a door in the database.
	YRP.msg("darkrp", "storeDoorGroup(ent, group)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.storeJailPos(ply, addingPos)
	--Description: Store a jailposition from a player's location.
	YRP.msg("darkrp", "storeJailPos(ply, addingPos)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.storeMoney(ply, amount)
	--Description: Internal function. Store a player's money in the database. Do
	--						 not call this if you just want to set someone's money, the
	--						 player will not see the change!
	YRP.msg("darkrp", "storeMoney(ply, amount)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.storeOfflineMoney(sid64, amount)
	--Description: Store the wallet amount of an offline player. Use
	--						 DarkRP.offlinePlayerData to fetch the current wallet amount.
	YRP.msg("darkrp", "storeOfflineMoney(sid64, amount)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.storeRPName(ply, name)
	--Description: Store an RP name in the database.
	YRP.msg("darkrp", "storeRPName(ply, name)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.storeTeamDoorOwnability(ent)
	--Description: Store the ownability information of a door in the database.
	YRP.msg("darkrp", "storeTeamDoorOwnability(ent)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.storeTeamSpawnPos(team, pos)
	--Description: Store a spawn position of a job in the database (replaces all
	--						 other spawn positions).
	YRP.msg("darkrp", "storeTeamSpawnPos(team, pos)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.talkToPerson(receiver, col1, text1, col2, text2, sender)
	--Description: Send a chat message to a player.
	YRP.msg("darkrp", "talkToPerson(receiver, col1, text1, col2, text2, sender)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.talkToRange(ply, playerName, message, size)
	--Description: Send a chat message to people close to a player.
	YRP.msg("darkrp", "talkToRange(ply, playerName, message, size)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.toggleSleep(ply, command)
	--Description: Old function to toggle sleep. I'm not proud of it.
	YRP.msg("darkrp", "toggleSleep(ply, command)")
	YRP.msg("darkrp", DarkRP._not)
	return ""
end

function DarkRP.unLockdown(ply)
	--Description: Stop the lockdown.
	YRP.msg("darkrp", "unLockdown(ply)")
	YRP.msg("darkrp", DarkRP._not)
	return ""
end

function DarkRP.writeNetDoorVar(name, var)
	--Description: Internal function. You probably shouldn't need this. DarkRP
	--						 calls this function when sending DoorVar net messages. This
	--						 function writes the net data for a specific DoorVar.
	YRP.msg("darkrp", "writeNetDoorVar(name, var)")
	YRP.msg("darkrp", DarkRP._not)
end
