--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local Player = FindMetaTable("Player")

function Player:abortHit(message)
	--Description: Abort a hit
	YRP.msg("darkrp", "abortHit(" .. message .. ")")
	YRP.msg("darkrp", DarkRP._not)
end

function Player:addCustomEntity(tblEnt)
	--Description: Add a custom entity to the player's limit.
	YRP.msg("darkrp", "addCustomEntity(table)")
	YRP.msg("darkrp", DarkRP._not)
end

function Player:addPocketItem(ent)
	--Description: Add an item to the pocket of the player.
	YRP.msg("darkrp", "addPocketItem(ent)")
	YRP.msg("darkrp", DarkRP._not)
end

function Player:applyPlayerClassVars(applyHealth)
	--Description: Applies all variables in a player's associated GMod player class to the player.
	if applyHealth then
		self:SetHealth(self:GetMaxHealth())
	end
end

function Player:arrest(time, Arrester)
	--Description: Arrest a player.
	YRP.msg("darkrp", "arrest(" .. tostring(time) .. ", " .. Arrester:Nick() .. ")")

	self:SetDInt("jailtime", time)
	timer.Simple(0.02, function()
		self:SetDBool("injail", true)
	end)
end

function Player:changeAllowed(team)
	--Description: Returns whether a player is allowed to get a certain job.
	YRP.msg("darkrp", "changeAllowed(" .. tostring(team) .. ")")
	YRP.msg("darkrp", DarkRP._not)
	return false
end

function Player:changeTeam(team, force, suppressNotification)
	--Description: Change the team of a player.
	YRP.msg("darkrp", "changeTeam(" .. tostring(team) .. ", " .. tostring(force) .. ", " .. tostring(suppressNotification) .. ")")
	YRP.msg("darkrp", DarkRP._not)
	return false
end

function Player:doPropertyTax()
	--Description: Tax a player based on the amount of doors and vehicles they have.
	YRP.msg("darkrp", "doPropertyTax()")
	YRP.msg("darkrp", DarkRP._not)
end

function Player:dropDRPWeapon(weapon)
	--Description: Drop the weapon with animations.
	YRP.msg("darkrp", "dropDRPWeapon(weapon)")
	YRP.msg("darkrp", DarkRP._not)
end

function Player:dropPocketItem(ent)
	--Description: Make the player drop an item from the pocket.
	YRP.msg("darkrp", "dropPocketItem(ent)")
	YRP.msg("darkrp", DarkRP._not)
end

function Player:finishHit()
	--Description: End a hit without a message
	YRP.msg("darkrp", "finishHit()")
	YRP.msg("darkrp", DarkRP._not)
end

function Player:getHitCustomer()
	--Description: Get the customer for the current hit
	YRP.msg("darkrp", "getHitCustomer()")
	YRP.msg("darkrp", DarkRP._not)
	return NULL
end

function Player:getHitmanTeams()
	--Description: Get all the hitman teams.
	YRP.msg("darkrp", "getHitmanTeams()")
	YRP.msg("darkrp", DarkRP._not)
	return {}
end

function Player:getPreferredModel(teamNr)
	--Description: Get the preferred model of a player for a job.
	YRP.msg("darkrp", "getPreferredModel(" .. teamNr .. ")")
	YRP.msg("darkrp", DarkRP._not)
	return ""
end

function Player:hungerUpdate()
	--Description: Makes the player slightly more hungry. Called in a timer by default.
	YRP.msg("darkrp", "hungerUpdate()")
	YRP.msg("darkrp", DarkRP._not)
end

function Player:initiateTax()
	--Description: Internal function, starts the timer that taxes the player every once in a while.
	YRP.msg("darkrp", "initiateTax()")
	YRP.msg("darkrp", DarkRP._not)
end

function Player:keysUnOwnAll()
	--Description: Unown every door and vehicle owned by this player.
	YRP.msg("darkrp", "keysUnOwnAll()")
	YRP.msg("darkrp", DarkRP._not)
end

function Player:newHungerData()
	--Description: Create the initial hunger data (called on PlayerInitialSpawn).
	YRP.msg("darkrp", "newHungerData()")
	YRP.msg("darkrp", DarkRP._not)
end

function Player:placeHit(customer, target, price)
	--Description: Place an actual hit.
	YRP.msg("darkrp", "placeHit(customer, target, price)")
	YRP.msg("darkrp", DarkRP._not)
end

function Player:removeCustomEntity(tblEnt)
	--Description: Remove a custom entity to the player's limit.
	YRP.msg("darkrp", "removeCustomEntity(tblEnt)")
	YRP.msg("darkrp", DarkRP._not)
end

function Player:removeDarkRPVar(variable, target)
	--Description: Remove a shared variable. Exactly the same as ply:setDarkRPVar(nil).
	YRP.msg("darkrp", "removeDarkRPVar(variable, target)")
	YRP.msg("darkrp", DarkRP._not)
end

function Player:removePocketItem(item)
	--Description: Remove an item from the pocket of the player.
	YRP.msg("darkrp", "removePocketItem(item)")
	YRP.msg("darkrp", DarkRP._not)
end

function Player:requestHit(customer, target, price)
	--Description: Request a hit to a hitman.
	YRP.msg("darkrp", "requestHit(customer, target, price)")
	YRP.msg("darkrp", DarkRP._not)
	return false
end

function Player:requestWarrant(suspect, actor, reason)
	--Description: File a request for a search warrant.
	YRP.msg("darkrp", "requestWarrant(suspect, actor, reason)")
	YRP.msg("darkrp", DarkRP._not)
end

function Player:sendDarkRPVars()
	--Description: Internal function. Sends all visibleDarkRPVars of all players to this player.
	YRP.msg("darkrp", "sendDarkRPVars()")
	YRP.msg("darkrp", DarkRP._not)
	timer.Simple(10, function()
		YRP.msg("darkrp", "10 sec later")
		YRP.msg("darkrp", "sendDarkRPVars()")
		YRP.msg("darkrp", DarkRP._not)
	end)
end

function Player:sendDoorData()
	--Description: Internal function. Sends all door data to a player.
	YRP.msg("darkrp", "sendDoorData()")
	YRP.msg("darkrp", DarkRP._not)
end

function Player:setDarkRPVar(variable, value, target)
	--Description: Set a shared variable. Make sure the variable is registered with DarkRP.registerDarkRPVar!
	YRP.msg("darkrp", "setDarkRPVar(" .. tostring(variable) .. ", " .. tostring(value) .. ", " .. tostring(target) .. ")")
	if value == nil then return false end

	target = target or self

	if variable == "Thirst" then
		target:Drink(value - target:GetDFloat("thirst", 0.0))
	elseif variable == "Energy" then
		target:Eat(value - target:GetDFloat("hunger", 0.0))
	end

	if isnumber(value) then
		target:SetNWInt(variable, value)
	else
		target:SetNWString(variable, value)
	end
end

function Player:setHitCustomer(customer)
	--Description: Set the customer who pays for the hit.
	YRP.msg("darkrp", "setHitCustomer(customer)")
	YRP.msg("darkrp", DarkRP._not)
end

function Player:setHitPrice(price)
	--Description: Set the price of a hit
	YRP.msg("darkrp", "setHitPrice(price)")
	YRP.msg("darkrp", DarkRP._not)
end

function Player:setHitTarget(target)
	--Description: Set the target of a hit
	YRP.msg("darkrp", "setHitTarget(target)")
	YRP.msg("darkrp", DarkRP._not)
end

function Player:setRPName(name, firstrun)
	--Description: Set the RPName of a player.
	YRP.msg("darkrp", "setRPName(name, firstrun)")
	YRP.msg("darkrp", DarkRP._not)
end

function Player:setSelfDarkRPVar(variable, value)
	--Description: Set a shared variable that is only seen by the player to whom this variable applies.
	YRP.msg("darkrp", "setSelfDarkRPVar(variable, value)")
	self:setDarkRPVar(variable, value, self)
end

function Player:teamBan(team, time)
	--Description: Ban someone from getting a certain job.
	YRP.msg("darkrp", "teamBan(team, time)")
	YRP.msg("darkrp", DarkRP._not)
end

function Player:teamBanTimeLeft(team)
	--Description: Returns the time left on a player's teamban.
	YRP.msg("darkrp", "teamBanTimeLeft(team)")
	YRP.msg("darkrp", DarkRP._not)
end

function Player:teamUnBan(team)
	--Description: Unban someone from a team.
	YRP.msg("darkrp", "teamUnBan(team)")
	YRP.msg("darkrp", DarkRP._not)
end

function Player:unArrest(Unarrester)
	--Description: Unarrest a player.
	YRP.msg("darkrp", "unArrest(" .. Unarrester:YRPName() .. ")")
	self:SetDBool("injail", false)
end

function Player:unWanted(actor)
	--Description: Clear the wanted status for this person.
	YRP.msg("darkrp", "unWanted(actor)")
	YRP.msg("darkrp", DarkRP._not)
end

function Player:unWarrant(unwarranter)
	--Description: Remove the search warrant for this person.
	YRP.msg("darkrp", "unWarrant(unwarranter)")
	YRP.msg("darkrp", DarkRP._not)
end

function Player:updateJob(job)
	--Description: Set the job name of a player (doesn't change the actual team).
	YRP.msg("darkrp", "updateJob(job)")
	YRP.msg("darkrp", DarkRP._not)
end

function Player:wanted(actor, reason, time)
	--Description: Make this person wanted by the police.
	YRP.msg("darkrp", "wanted(actor, reason, time)")
	YRP.msg("darkrp", DarkRP._not)
end

function Player:warrant(warranter, reason)
	--Description: Get a search warrant for this person.
	YRP.msg("darkrp", "warrant(warranter, reason)")
	YRP.msg("darkrp", DarkRP._not)
end

DarkRP.hooks.playerArrested = Player.arrest