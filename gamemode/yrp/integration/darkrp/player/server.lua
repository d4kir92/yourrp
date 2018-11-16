--Copyright (C) 2017-2018 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local Player = FindMetaTable("Player")

function Player:abortHit(message)
	--Description: Abort a hit
	printGM("darkrp", "abortHit(" .. message .. ")")
	printGM("darkrp", DarkRP._not)
end

function Player:addCustomEntity(tblEnt)
	--Description: Add a custom entity to the player's limit.
	printGM("darkrp", "addCustomEntity(table)")
	printGM("darkrp", DarkRP._not)
end

function Player:addPocketItem(ent)
	--Description: Add an item to the pocket of the player.
	printGM("darkrp", "addPocketItem(ent)")
	printGM("darkrp", DarkRP._not)
end

function Player:applyPlayerClassVars(applyHealth)
	--Description: Applies all variables in a player's associated GMod player class to the player.
	if applyHealth then
		self:SetHealth(self:GetMaxHealth())
	end
end

function Player:arrest(time, Arrester)
	--Description: Arrest a player.
	printGM("darkrp", "arrest(" .. tostring(time) .. ", " .. Arrester:Nick() .. ")")
	self:SetNWBool("injail", true)
	self:SetNWInt("jailtime", time)
end

function Player:canKeysLock(door)
	--Description: Whether the player can lock a given door.
	printGM("darkrp", "canKeysLock(door)")
	printGM("darkrp", DarkRP._not)
	return false
end

function Player:canKeysUnlock(door)
	--Description: Whether the player can unlock a given door.
	printGM("darkrp", "canKeysUnlock(door)")
	printGM("darkrp", DarkRP._not)
	return false
end

function Player:changeAllowed(team)
	--Description: Returns whether a player is allowed to get a certain job.
	printGM("darkrp", "changeAllowed(" .. tostring(team) .. ")")
	printGM("darkrp", DarkRP._not)
	return false
end

function Player:changeTeam(team, force, suppressNotification)
	--Description: Change the team of a player.
	printGM("darkrp", "changeTeam(" .. tostring(team) .. ", " .. tostring(force) .. ", " .. tostring(suppressNotification) .. ")")
	printGM("darkrp", DarkRP._not)
	return false
end

function Player:doPropertyTax()
	--Description: Tax a player based on the amount of doors and vehicles they have.
	printGM("darkrp", "doPropertyTax()")
	printGM("darkrp", DarkRP._not)
end

function Player:dropDRPWeapon(weapon)
	--Description: Drop the weapon with animations.
	printGM("darkrp", "dropDRPWeapon(weapon)")
	printGM("darkrp", DarkRP._not)
end

function Player:dropPocketItem(ent)
	--Description: Make the player drop an item from the pocket.
	printGM("darkrp", "dropPocketItem(ent)")
	printGM("darkrp", DarkRP._not)
end

function Player:finishHit()
	--Description: End a hit without a message
	printGM("darkrp", "finishHit()")
	printGM("darkrp", DarkRP._not)
end

function Player:getHitCustomer()
	--Description: Get the customer for the current hit
	printGM("darkrp", "getHitCustomer()")
	printGM("darkrp", DarkRP._not)
	return NULL
end

function Player:getHitmanTeams()
	--Description: Get all the hitman teams.
	printGM("darkrp", "getHitmanTeams()")
	printGM("darkrp", DarkRP._not)
	return {}
end

function Player:getPreferredModel(teamNr)
	--Description: Get the preferred model of a player for a job.
	printGM("darkrp", "getPreferredModel(" .. teamNr .. ")")
	printGM("darkrp", DarkRP._not)
	return ""
end

function Player:hungerUpdate()
	--Description: Makes the player slightly more hungry. Called in a timer by default.
	printGM("darkrp", "hungerUpdate()")
	printGM("darkrp", DarkRP._not)
end

function Player:initiateTax()
	--Description: Internal function, starts the timer that taxes the player every once in a while.
	printGM("darkrp", "initiateTax()")
	printGM("darkrp", DarkRP._not)
end

function Player:keysUnOwnAll()
	--Description: Unown every door and vehicle owned by this player.
	printGM("darkrp", "keysUnOwnAll()")
	printGM("darkrp", DarkRP._not)
end

function Player:newHungerData()
	--Description: Create the initial hunger data (called on PlayerInitialSpawn).
	printGM("darkrp", "newHungerData()")
	printGM("darkrp", DarkRP._not)
end

function Player:placeHit(customer, target, price)
	--Description: Place an actual hit.
	printGM("darkrp", "placeHit(customer, target, price)")
	printGM("darkrp", DarkRP._not)
end

function Player:removeCustomEntity(tblEnt)
	--Description: Remove a custom entity to the player's limit.
	printGM("darkrp", "removeCustomEntity(tblEnt)")
	printGM("darkrp", DarkRP._not)
end

function Player:removeDarkRPVar(variable, target)
	--Description: Remove a shared variable. Exactly the same as ply:setDarkRPVar(nil).
	printGM("darkrp", "removeDarkRPVar(variable, target)")
	printGM("darkrp", DarkRP._not)
end

function Player:removePocketItem(item)
	--Description: Remove an item from the pocket of the player.
	printGM("darkrp", "removePocketItem(item)")
	printGM("darkrp", DarkRP._not)
end

function Player:requestHit(customer, target, price)
	--Description: Request a hit to a hitman.
	printGM("darkrp", "requestHit(customer, target, price)")
	printGM("darkrp", DarkRP._not)
	return false
end

function Player:requestWarrant(suspect, actor, reason)
	--Description: File a request for a search warrant.
	printGM("darkrp", "requestWarrant(suspect, actor, reason)")
	printGM("darkrp", DarkRP._not)
end

function Player:sendDarkRPVars()
	--Description: Internal function. Sends all visibleDarkRPVars of all players to this player.
	printGM("darkrp", "sendDarkRPVars()")
	printGM("darkrp", DarkRP._not)
	timer.Simple(10, function()
		printGM("darkrp", "10 sec later")
		printGM("darkrp", "sendDarkRPVars()")
		printGM("darkrp", DarkRP._not)
	end)
end

function Player:sendDoorData()
	--Description: Internal function. Sends all door data to a player.
	printGM("darkrp", "sendDoorData()")
	printGM("darkrp", DarkRP._not)
end

function Player:setDarkRPVar(variable, value, target)
	--Description: Set a shared variable. Make sure the variable is registered with DarkRP.registerDarkRPVar!
	printGM("darkrp", "setDarkRPVar(variable, value, target)")
	printGM("darkrp", DarkRP._not)
end

function Player:setHitCustomer(customer)
	--Description: Set the customer who pays for the hit.
	printGM("darkrp", "setHitCustomer(customer)")
	printGM("darkrp", DarkRP._not)
end

function Player:setHitPrice(price)
	--Description: Set the price of a hit
	printGM("darkrp", "setHitPrice(price)")
	printGM("darkrp", DarkRP._not)
end

function Player:setHitTarget(target)
	--Description: Set the target of a hit
	printGM("darkrp", "setHitTarget(target)")
	printGM("darkrp", DarkRP._not)
end

function Player:setRPName(name, firstrun)
	--Description: Set the RPName of a player.
	printGM("darkrp", "setRPName(name, firstrun)")
	printGM("darkrp", DarkRP._not)
end

function Player:setSelfDarkRPVar(variable, value)
	--Description: Set a shared variable that is only seen by the player to whom this variable applies.
	printGM("darkrp", "setSelfDarkRPVar(variable, value)")
	printGM("darkrp", DarkRP._not)
end

function Player:teamBan(team, time)
	--Description: Ban someone from getting a certain job.
	printGM("darkrp", "teamBan(team, time)")
	printGM("darkrp", DarkRP._not)
end

function Player:teamBanTimeLeft(team)
	--Description: Returns the time left on a player's teamban.
	printGM("darkrp", "teamBanTimeLeft(team)")
	printGM("darkrp", DarkRP._not)
end

function Player:teamUnBan(team)
	--Description: Unban someone from a team.
	printGM("darkrp", "teamUnBan(team)")
	printGM("darkrp", DarkRP._not)
end

function Player:unArrest(Unarrester)
	--Description: Unarrest a player.
	printGM("darkrp", "unArrest(" .. Unarrester:YRPName() .. ")")
	self:SetNWBool("injail", false)
end

function Player:unWanted(actor)
	--Description: Clear the wanted status for this person.
	printGM("darkrp", "unWanted(actor)")
	printGM("darkrp", DarkRP._not)
end

function Player:unWarrant(unwarranter)
	--Description: Remove the search warrant for this person.
	printGM("darkrp", "unWarrant(unwarranter)")
	printGM("darkrp", DarkRP._not)
end

function Player:updateJob(job)
	--Description: Set the job name of a player (doesn't change the actual team).
	printGM("darkrp", "updateJob(job)")
	printGM("darkrp", DarkRP._not)
end

function Player:wanted(actor, reason, time)
	--Description: Make this person wanted by the police.
	printGM("darkrp", "wanted(actor, reason, time)")
	printGM("darkrp", DarkRP._not)
end

function Player:warrant(warranter, reason)
	--Description: Get a search warrant for this person.
	printGM("darkrp", "warrant(warranter, reason)")
	printGM("darkrp", DarkRP._not)
end
