--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local Player = FindMetaTable("Player")
function Player:abortHit(message)
	--Description: Abort a hit
	YRPDarkrpNotFound("abortHit( " .. message .. " )")
end

function Player:addCustomEntity(tblEnt)
	--Description: Add a custom entity to the player's limit.
	YRPDarkrpNotFound("addCustomEntity(table)")
end

function Player:addPocketItem(ent)
end

--Description: Add an item to the pocket of the player.
--YRPDarkrpNotFound("addPocketItem(ent)")
function Player:applyPlayerClassVars(applyHealth)
	--Description: Applies all variables in a player's associated GMod player class to the player.
	if applyHealth then
		self:SetHealth(self:GetMaxHealth())
	end
end

function Player:arrest(time, Arrester)
	--Description: Arrest a player.
	--YRPDarkrpNotFound( "arrest( " .. tostring(time) .. ", " .. Arrester:Nick() .. " )" )
	self:SetYRPInt("jailtime", time)
	timer.Simple(
		0.02,
		function()
			self:SetYRPBool("injail", true)
		end
	)
end

function Player:changeAllowed(team)
	return true
end

--Description: Returns whether a player is allowed to get a certain job.
function Player:changeTeam(team, force, suppressNotification)
	--Description: Change the team of a player.
	if canGetRole(self, team) then
		if GetGlobalYRPBool("bool_players_die_on_role_switch", false) then
			self:KillSilent()
		end

		YRPSetRole("changeTeam", self, team, false, nil)
		if GetGlobalYRPBool("bool_players_die_on_role_switch", false) then
			self:Spawn()
		end

		return true
	end

	return false
end

function Player:doPropertyTax()
	--Description: Tax a player based on the amount of doors and vehicles they have.
	YRPDarkrpNotFound("doPropertyTax()")
end

function Player:dropDRPWeapon(weapon)
end

--Description: Drop the weapon with animations.
--YRPDarkrpNotFound( "dropDRPWeapon(weapon)" )
function Player:dropPocketItem(ent)
	--Description: Make the player drop an item from the pocket.
	YRPDarkrpNotFound("dropPocketItem(ent)")
end

function Player:finishHit()
	--Description: End a hit without a message
	YRPDarkrpNotFound("finishHit()")
end

function Player:getHitCustomer()
	--Description: Get the customer for the current hit
	YRPDarkrpNotFound("getHitCustomer()")

	return NULL
end

function Player:getHitmanTeams()
	--Description: Get all the hitman teams.
	YRPDarkrpNotFound("getHitmanTeams()")

	return {}
end

function Player:getPreferredModel(teamNr)
	--Description: Get the preferred model of a player for a job.
	YRPDarkrpNotFound("getPreferredModel( " .. teamNr .. " )")

	return ""
end

function Player:hungerUpdate()
	--Description: Makes the player slightly more hungry. Called in a timer by default.
	YRPDarkrpNotFound("hungerUpdate()")
end

function Player:initiateTax()
	--Description: Internal function, starts the timer that taxes the player every once in a while.
	YRPDarkrpNotFound("initiateTax()")
end

function Player:keysUnOwnAll()
end

--Description: Unown every door and vehicle owned by this player.
--YRPDarkrpNotFound( "keysUnOwnAll()" )
function Player:newHungerData()
	--Description: Create the initial hunger data ( called on PlayerInitialSpawn).
	YRPDarkrpNotFound("newHungerData()")
end

function Player:placeHit(customer, target, price)
	--Description: Place an actual hit.
	YRPDarkrpNotFound("placeHit( customer, target, price)")
end

function Player:removeCustomEntity(tblEnt)
	--Description: Remove a custom entity to the player's limit.
	YRPDarkrpNotFound("removeCustomEntity(tblEnt)")
end

function Player:removeDarkRPVar(variable, target)
	--Description: Remove a shared variable. Exactly the same as ply:setDarkRPVar(nil).
	YRPDarkrpNotFound("removeDarkRPVar( variable, target)")
end

function Player:removePocketItem(item)
	--Description: Remove an item from the pocket of the player.
	YRPDarkrpNotFound("removePocketItem(item)")
end

function Player:requestHit(customer, target, price)
	--Description: Request a hit to a hitman.
	YRPDarkrpNotFound("requestHit( customer, target, price)")

	return false
end

function Player:requestWarrant(suspect, actor, reason)
	--Description: File a request for a search warrant.
	YRPDarkrpNotFound("requestWarrant(suspect, actor, reason)")
end

function Player:sendDarkRPVars()
	--Description: Internal function. Sends all visibleDarkRPVars of all players to this player.
	YRPDarkrpNotFound("sendDarkRPVars()")
end

function Player:sendDoorData()
	--Description: Internal function. Sends all door data to a player.
	YRPDarkrpNotFound("sendDoorData()")
end

local unhandled = {}
unhandled["agenda"] = true
unhandled["salary"] = true
unhandled["job"] = true
unhandled["wantedReason"] = true
unhandled["HasGunlicense"] = true
function Player:setSelfDarkRPVar(variable, value, target)
	--Description: Set a shared variable. Make sure the variable is registered with DarkRP.registerDarkRPVar!
	if value == nil then return false end
	target = target or self
	if variable then
		if variable == "Thirst" then
			target:Drink(value - target:GetYRPFloat("thirst", 0.0))
		elseif variable == "Energy" then
			target:Eat(value - target:GetYRPFloat("hunger", 0.0))
		elseif variable == "rpname" then
			target:SetRPName(value, "setDarkRPVar")
		elseif variable == "money" then
			target:SetMoney(value)
		elseif variable == "wanted" then
			target:SetYRPBool("iswanted", value)
		elseif variable == "level" then
			self:SetLevel(value)
		elseif variable == "xp" then
			self:SetXP(value)
		elseif variable == "energy" then
			self:YRPSetHunger(value)
		elseif variable == "jailpos" then
			YRP:msg("note", "Use yourrp jailpos swep!")
		elseif variable == "AFK" then
			target:SetAFK(true)
		elseif variable == "AFKDemoted" then
			target:SetAFK(false)
		elseif unhandled[variable] == nil then
			--
			YRPDarkrpNotFound("setDarkRPVar( " .. tostring(variable) .. ", " .. tostring(value) .. ", " .. tostring(target) .. " )")
			if target == self then
				self[variable] = value
			else
				target[variable] = value
			end

			if isnumber(value) then
				target:SetYRPInt(variable, value)
			elseif string.lower(variable) ~= "usergroup" then
				target:SetYRPString(variable, value)
			end
		end
	end
end

function Player:setHitCustomer(customer)
	--Description: Set the customer who pays for the hit.
	YRPDarkrpNotFound("setHitCustomer( customer)")
end

function Player:setHitPrice(price)
	--Description: Set the price of a hit
	YRPDarkrpNotFound("setHitPrice(price)")
end

function Player:setHitTarget(target)
	--Description: Set the target of a hit
	YRPDarkrpNotFound("setHitTarget(target)")
end

function Player:setRPName(name, firstrun)
	--Description: Set the RPName of a player.
	--YRPDarkrpNotFound( "setRPName(name, firstrun)" )
	name = YRPCleanUpName(name)
	self:SetRPName(name, "darkrp setRPName")
end

function Player:setDarkRPVar(variable, value)
	--Description: Set a shared variable that is only seen by the player to whom this variable applies.
	--YRPDarkrpNotFound( "setDarkRPVar( variable, value)" )
	self:setSelfDarkRPVar(variable, value, self)
end

function Player:teamBan(team, time)
end

--Description: Ban someone from getting a certain job.
--YRPDarkrpNotFound( "teamBan(team, time)" )
function Player:teamBanTimeLeft(team)
	--Description: Returns the time left on a player's teamban.
	YRPDarkrpNotFound("teamBanTimeLeft(team)")
end

function Player:teamUnBan(team)
	--Description: Unban someone from a team.
	YRPDarkrpNotFound("teamUnBan(team)")
end

function Player:unArrest(Unarrester)
	--Description: Unarrest a player.
	if IsValid(Unarrester) then
		self:SetYRPBool("injail", false)
	end
end

function Player:unWanted(actor)
	--Description: Clear the wanted status for this person.
	--YRPDarkrpNotFound( "unWanted( actor)" )
	self:SetYRPBool("iswanted", false)
end

function Player:unWarrant(unwarranter)
	--Description: Remove the search warrant for this person.
	YRPDarkrpNotFound("unWarrant(unwarranter)")
end

function Player:updateJob(job)
end

--Description: Set the job name of a player ( doesn't change the actual team).
--YRPDarkrpNotFound( "nws_yrp_updateJob(job)" )
function Player:wanted(actor, reason, time)
end

--Description: Make this person wanted by the police.
--YRPDarkrpNotFound( "wanted( actor, reason, time)" )
function Player:warrant(warranter, reason)
end

--Description: Get a search warrant for this person.
--YRPDarkrpNotFound( "warrant(warranter, reason)" )
DarkRP.hooks.playerArrested = Player.arrest
