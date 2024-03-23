--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
function DarkRP.addJailPos(pos)
end

--Description: Add a jail position to the map. This jail position will be saved in the database.
--YRPDarkrpNotFound( "addJailPos( " .. tostring(pos) .. " )" )
function DarkRP.addTeamSpawnPos(team, pos)
	--Description: Add a spawn position to the database. The position will not replace other spawn positions.
	YRPDarkrpNotFound("addTeamSpawnPos( " .. tostring(team) .. ", " .. tostring(pos) .. " )")
end

function DarkRP.createMoneyBag(pos, amount)
	--Description: Create a money bag.
	local _moneyEnt = ents.Create("yrp_money")
	_moneyEnt:SetPos(pos)
	_moneyEnt:Spawn()
	_moneyEnt:SetMoney(amount)

	return _moneyEnt
end

function DarkRP.createPlayerData(ply, name, wallet, salary)
	--Description: Internal function: creates an entry in the database for a player who has joined for the first time.
	YRPDarkrpNotFound("createPlayerData(ply, " .. name .. ", " .. tostring(wallet) .. ", " .. tostring(salary) .. " )")
end

function DarkRP.createQuestion(question, quesid, target, delay, callback, fromPly, toPly, ...)
	--Description: Ask someone a question.
	YRPDarkrpNotFound("createQuestion(question, quesid, target, delay, callback, fromPly, toPly, ...)")
end

function DarkRP.createVote(question, voteid, target, delay, callback, excludeVoters, fail, ...)
	--Description: Create a vote.
	YRPDarkrpNotFound("createVote(	question, voteid, target, delay, callback, excludeVoters, fail, ...)")

	return {}
end

function DarkRP.customEntityLimitReached(tblEnt)
	--Description: Set a shared variable.
	YRPDarkrpNotFound("customEntityLimitReached(tblEnt)")

	return false
end

YRPDarkrpDefineChatCmds = YRPDarkrpDefineChatCmds or {}
function DarkRP.defineChatCommand(command, callback)
	--Description: Create a chat command that calls the function
	--YRPDarkrpNotFound( "defineChatCommand( " .. command .. ", callback)" )
	YRPDarkrpDefineChatCmds[command] = callback
end

function DarkRP.definePrivilegedChatCommand(command, privilege, callback)
end

--Description: Create a chat command that calls the function if the player has the right CAMI privilege.
--						 Will automatically notify the user when they don't have access. Note that chat command functions
--						 registered with this function can NOT override the chat that will appear after the command has been executed
--YRPDarkrpNotFound( "definePrivilegedChatCommand( " .. command .. ", " .. privilege .. ", callback)" )
function DarkRP.destroyLastVote()
	--Description: Destroy the last created vote.
	YRPDarkrpNotFound("destroyLastVote()")

	return false
end

function DarkRP.destroyQuestion(id)
	--Description: Destroy a question by ID.
	YRPDarkrpNotFound("destroyQuestion( " .. id .. " )")
end

function DarkRP.destroyQuestionsWithEnt(ent)
	--Description: Destroy all questions that have something to do with this ent.
	YRPDarkrpNotFound("destroyQuestionsWithEnt(ent)")
end

function DarkRP.destroyVotesWithEnt(ent)
	--Description: Destroy all votes that have something to do with this ent.
	YRPDarkrpNotFound("destroyVotesWithEnt(ent)")
end

function DarkRP.doorIndexToEnt(index)
	--Description: Get the entity of a door index (inverse of ent:doorIndexToEnt() ). Note: the door MUST have been created by the map!
	YRPDarkrpNotFound("doorIndexToEnt( " .. tostring(index) .. " )")

	return NULL
end

function DarkRP.doorToEntIndex(index)
	--Description: Get an ENT index from a door index.
	YRPDarkrpNotFound("doorToEntIndex( " .. tostring(index) .. " )")

	return -1
end

function DarkRP.findEmptyPos(pos, ignore, distance, step, area)
	return Vector(0, 0, 0)
end

--Description: Find an empty position as close as possible to the given position (Note: this algorithm is slow!).
--YRPDarkrpNotFound( "findEmptyPos(pos, ignore, distance, step, area)" )
function DarkRP.getChatSound(text)
	--Description: Get a chat sound (play a noise when someone says something) associated with the given phrase.
	YRPDarkrpNotFound("getChatSound( " .. text .. " )")

	return {}
end

function DarkRP.getHits()
	--Description: Get all the active hits
	YRPDarkrpNotFound("getHits()")

	return {}
end

function DarkRP.initDatabase()
	--Description: Initialize the DarkRP database.
	YRPDarkrpNotFound("initDatabase()")
end

function DarkRP.isEmpty(pos, ignore)
	--Description: Destroy a question by ID.
	YRPDarkrpNotFound("isEmpty( " .. tostring(pos) .. ", ignore)")

	return false
end

function DarkRP.jailPosCount()
	--Description: The amount of jail positions in the current map.
	YRPDarkrpNotFound("jailPosCount()")

	return 0
end

function DarkRP.lockdown(ply)
	return "Old lockdown"
end

--Description: Start a lockdown.
--YRPDarkrpNotFound( "lockdown(ply)" )
function DarkRP.log(message, colour, noFileSave)
end

util.AddNetworkString("nws_yrp_sendNotify")
function DarkRP.notify(ply, msgType, time, message)
	--Description: Log a message in DarkRP
	if ply and ply:IsPlayer() and IsNotNilAndNotFalse(message) then
		net.Start("nws_yrp_sendNotify")
		net.WriteString(message)
		net.Send(ply)
	else
		YRP.msg("gm", "[DarkRP.notify] message is NIL")
	end
end

function DarkRP.notifyAll(msgType, time, message)
	--Description: Make a notification pop up on the everyone's screen.
	--YRPDarkrpNotFound( "notifyAll(msgType, time, " .. message .. " )" )
	net.Start("nws_yrp_sendNotify")
	net.WriteString(message)
	net.Broadcast()
end

function DarkRP.offlinePlayerData(SteamID, callback, failure)
end

--Description: Get a player's information from the database using a SteamID for use when the player is offline.
--YRPDarkrpNotFound( "offlinePlayerData(SteamID, callback, " .. tostring(failure) .. " )" )
--return?
function DarkRP.payDay()
	--Description: Give a player their salary.
	YRPDarkrpNotFound("payDay()")
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
	YRPDarkrpNotFound("printConsoleMessage(ply, " .. msg .. " )")
end

function DarkRP.printMessageAll(msgType, message)
end

--Description: Make a notification pop up in the middle of everyone's screen.
--YRPDarkrpNotFound( "printMessageAll(msgType, " .. message .. " )" )
function DarkRP.removeTeamSpawnPos(team, pos)
	--Description: Remove a single spawn position.
	YRPDarkrpNotFound("removeTeamSpawnPos(team, pos)")
end

function DarkRP.resetLaws()
	--Description: Reset to default laws.
	YRPDarkrpNotFound("resetLaws()")
end

function DarkRP.restorePlayerData()
	--Description: Internal function that restores a player's DarkRP information when they join.
	YRPDarkrpNotFound("restorePlayerData()")
end

function DarkRP.retrieveJailPos(index)
	--Description: Retrieve a jail position.
	YRPDarkrpNotFound("retrieveJailPos( " .. tostring(index) .. " )")

	return Vector(0, 0, 0)
end

function DarkRP.retrievePlayerData(ply, callback, failure)
	--Description: Get a player's information from the database.
	YRPDarkrpNotFound("retrievePlayerData(ply, callback, failure)")
end

function DarkRP.retrieveRPNames(name, callback)
	--Description: Whether a given RP name is taken by someone else.
	local inuse = false
	for i, v in pairs(player.GetAll()) do
		if v:YRPRPName() == name then
			inuse = true
			break
		end
	end

	if callback then
		callback(inuse)
	end

	return inuse
end

function DarkRP.retrieveSalary(ply, callback)
	return ply:Salary()
end

--Description: Get a player's salary from the database.
function DarkRP.retrieveTeamSpawnPos(team)
	--Description: Retrieve a random spawn position for a job.
	YRPDarkrpNotFound("retrieveTeamSpawnPos(team)")

	return Vector(0, 0, 0)
end

function DarkRP.setChatSound(text, sounds)
	--Description: Set a chat sound (play a noise when someone says something)
	YRPDarkrpNotFound("setChatSound(text, sounds)")
end

function DarkRP.setJailPos(pos)
	--Description: Remove all jail positions in this map and create a new one. To
	--						 add a jailpos without removing previous ones use
	--						 DarkRP.addJailPos. This jail position will be saved in the
	--						 database.
	YRPDarkrpNotFound("setJailPos(pos)")
end

function DarkRP.storeDoorData(ent)
	--Description: Store the information about a door in the database.
	YRPDarkrpNotFound("storeDoorData(ent)")
end

function DarkRP.storeDoorGroup(ent, group)
	--Description: Store the group of a door in the database.
	YRPDarkrpNotFound("storeDoorGroup(ent, group)")
end

function DarkRP.storeJailPos(ply, addingPos)
	--Description: Store a jailposition from a player's location.
	YRPDarkrpNotFound("storeJailPos(ply, addingPos)")
end

function DarkRP.storeMoney(ply, amount)
end

--Description: Internal function. Store a player's money in the database. Do
--						 not call this if you just want to set someone's money, the
--						 player will not see the change!
--YRPDarkrpNotFound( "storeMoney(ply, amount)" )
function DarkRP.storeOfflineMoney(sid64, amount)
	--Description: Store the wallet amount of an offline player. Use
	--						 DarkRP.offlinePlayerData to fetch the current wallet amount.
	YRPDarkrpNotFound("storeOfflineMoney(sid64, amount)")
end

function DarkRP.storeRPName(ply, name)
end

--Description: Store an RP name in the database.
--YRPDarkrpNotFound( "storeRPName(ply, name)" )
function DarkRP.storeTeamDoorOwnability(ent)
	--Description: Store the ownability information of a door in the database.
	YRPDarkrpNotFound("storeTeamDoorOwnability(ent)")
end

function DarkRP.storeTeamSpawnPos(team, pos)
	--Description: Store a spawn position of a job in the database (replaces all
	--						 other spawn positions).
	YRPDarkrpNotFound("storeTeamSpawnPos(team, pos)")
end

function DarkRP.talkToPerson(receiver, col1, text1, col2, text2, sender)
end

--Description: Send a chat message to a player.
--YRPDarkrpNotFound( "talkToPerson(receiver, col1, text1, col2, text2, sender)" )
function DarkRP.talkToRange(ply, playerName, message, size)
end

--Description: Send a chat message to people close to a player.
--YRPDarkrpNotFound( "talkToRange(ply, playerName, message, size)" )
function DarkRP.toggleSleep(ply, command)
	--Description: Old function to toggle sleep. I'm not proud of it.
	YRPDarkrpNotFound("toggleSleep(ply, command)")

	return ""
end

function DarkRP.unLockdown(ply)
	--Description: Stop the lockdown.
	YRPDarkrpNotFound("unLockdown(ply)")

	return ""
end

function DarkRP.writeNetDoorVar(name, var)
	--Description: Internal function. You probably shouldn't need this. DarkRP
	--						 calls this function when sending DoorVar net messages. This
	--						 function writes the net data for a specific DoorVar.
	YRPDarkrpNotFound("writeNetDoorVar(name, var)")
end