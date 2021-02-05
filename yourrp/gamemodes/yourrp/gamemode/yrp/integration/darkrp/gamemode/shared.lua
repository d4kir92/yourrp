--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

AddCSLuaFile("client.lua")

if CLIENT then
	include("client.lua")
else
	include("server.lua")
end

function DarkRP.addChatCommandsLanguage(languageCode, translations)
	--Description: Add a translation table for chat command descriptions. See darkrpmod/lua/darkrp_language/chatcommands.lua for an example.
	YRP.msg("darkrp", "addChatCommandsLanguage(" .. languageCode .. ", table)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.addHitmanTeam(teamnumber)
	--Description: Make this team a hitman.
	YRP.msg("darkrp", "addHitmanTeam(" .. teamnumber .. ")")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.addLanguage(Languagename, Languagecontents)
	--Description: Create a language/translation.
	YRP.msg("darkrp", "addLanguage(" .. Languagename .. ", table)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.addPhrase(Languagename, key, translation)
	--Description: Add a phrase to the existing translation.
	YRP.msg("darkrp", "addPhrase(" .. Languagename .. ", " .. key .. ", " .. translation .. ")")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.addPlayerGesture(anim, text)
	--Description: Add a player gesture to the DarkRP animations menu (the one that opens with the keys weapon.). Note: This function must be called BOTH serverside AND clientside!
	YRP.msg("darkrp", "addPlayerGesture(" .. anim .. ", " .. text .. ")")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.addToCategory(item, kind, cat)
	--Description: Create a category for the F4 menu.
	YRP.msg("darkrp", "addToCategory(table, " .. kind .. ", " .. cat .. ")")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.chatCommandAlias(command, alias)
	--Description: Create an alias for a chat command
	YRP.msg("darkrp", "addToCategory(" .. command .. ", alias)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.createAgenda(title, manager, listeners)
	--Description: Create an agenda for groups of jobs to communicate.
	YRP.msg("darkrp", "createAgenda(" .. title .. ", " .. tostring(manager) .. ", listeners)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.createAmmoType(name, tbl)
	--Description: Create an ammo type.
	YRP.msg("darkrp", "createAmmoType(" .. name .. ", tbl)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.createCategory(tbl)
	--Description: Create a category for the F4 menu.
	YRP.msg("darkrp", "createCategory(tbl)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.createDemoteGroup(name, tbl)
	--Description: Create a demote group. When you get banned (demoted) from one of the jobs in this group, you will be banned from every job in this group.
	YRP.msg("darkrp", "createDemoteGroup(" .. name .. ", tbl)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.createEntity(name, tbl)
	--Description: Create an entity for DarkRP.
	YRP.msg("darkrp", "createEntity(" .. name .. ", tbl)")
	printTab(tbl, name)
end
AddEntity = DarkRP.createEntity

function DarkRP.createEntityGroup(name, teamNrs)
	--Description: Create an entity group for DarkRP.
	YRP.msg("darkrp", "createEntityGroup(" .. name .. ", " .. tostring(teamNrs) .. ")")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.createFood(name, tbl)
	--Description: Create food for DarkRP.
	YRP.msg("darkrp", "createFood(" .. name .. ", tbl)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.createGroupChat(functionOrJob, teamNr)
	--Description: Create a group chat.
	YRP.msg("darkrp", "createGroupChat(functionOrJob, " .. tostring(teamNr) .. ")")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.createJob(name, tbl)
	--Description: Create a job for DarkRP.
	YRP.msg("darkrp", "createJob(" .. name .. ", tbl)")
	YRP.msg("darkrp", DarkRP._not)
	return -1
end

function DarkRP.createShipment(name, tbl)
	--Description: Create a vehicle for DarkRP.
	YRP.msg("darkrp", "createShipment(" .. name .. ", tbl)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.createVehicle(name, tbl)
	--Description: Create a shipment for DarkRP.
	YRP.msg("darkrp", "createVehicle(" .. name .. ", tbl)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.declareChatCommand(table)
	--Description: Declare a chat command (describe it)
	YRP.msg("darkrp", "declareChatCommand(table)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.error(message, stack, hints, path, line)
	--Description: Throw a simplerr formatted error. Also halts the stack, which means that statements after calling this function will not execute.
	YRP.msg("darkrp", "error(" .. message .. ", " .. tostring(stack) .. ", hints, " .. path .. ", " .. tostring(line) .. ")")
	YRP.msg("darkrp", DarkRP._not)

	return false, "this say nothing"
end

function DarkRP.errorNoHalt(message, stack, hints, path, line)
	--Description: Throw a simplerr formatted error. Unlike DarkRP.error, this does not halt the stack. This means that statements after
	--						 calling this function will be executed like normal.
	YRP.msg("darkrp", "errorNoHalt(" .. message .. ", " .. tostring(stack) .. ", hints, " .. path .. ", " .. tostring(line) .. ")")
	YRP.msg("darkrp", DarkRP._not)

	return false, "this say nothing"
end

function DarkRP.explodeArg(arg)
	--Description: String arguments exploded into a table. It accounts for substrings in quotes, which makes it more intelligent than string.Explode
	YRP.msg("darkrp", "explodeArg(" .. arg .. ")")
	YRP.msg("darkrp", DarkRP._not)

	return {}
end

function DarkRP.findPlayer(info)
	--Description: Find a single player based on vague information.
	YRP.msg("darkrp", "findPlayer(" .. info .. ")")
	YRP.msg("darkrp", DarkRP._not)
	return NULL
end

function DarkRP.findPlayers(info)
	--Description: Find a list of players based on vague information.
	YRP.msg("darkrp", "findPlayers(" .. info .. ")")
	YRP.msg("darkrp", DarkRP._not)
	return {}
end

function DarkRP.formatMoney(amount)
	--Description: Format a number as a money value. Includes currency symbol.
	--YRP.msg("darkrp", "formatMoney(" .. tostring(amount) .. ")")
	if CLIENT then
		local lply = LocalPlayer()
		return formatMoney(amount, ply)
	else
		return formatMoney(amount)
	end
end

function DarkRP.getAgendas()
	--Description: Get all agendas. Note: teams that share an agenda use the exact
	--						 same agenda table. E.g. when you change the agenda of the CP,
	--						 the agenda of the Chief will automatically be updated as well.
	--						 Make sure this property is maintained when modifying the agenda
	--						 table. Not maintaining that property will lead to players not
	--						 seeing the right agenda text.
	YRP.msg("darkrp", "getAgendas()")
	YRP.msg("darkrp", DarkRP._not)
	return {}
end

function DarkRP.getAvailableVehicles()
	--Description: Get the available vehicles that DarkRP supports.
	YRP.msg("darkrp", "getAvailableVehicles()")
	YRP.msg("darkrp", DarkRP._not)
	return {}
end

function DarkRP.getCategories()
	--Description: Get all categories for all F4 menu tabs.
	YRP.msg("darkrp", "getCategories() not fully implemented")
	local tab = {}
	tab.jobs = RPExtraTeams
	return {}
end

function DarkRP.getChatCommand(command)
	--Description: Get the information on a chat command.
	YRP.msg("darkrp", "getChatCommand(" .. command .. ")")
	YRP.msg("darkrp", DarkRP._not)
	return {}
end

function DarkRP.getChatCommandDescription(command)
	--Description: Get the translated description of a chat command.
	YRP.msg("darkrp", "getChatCommandDescription(" .. command .. ")")
	YRP.msg("darkrp", DarkRP._not)
	return "OLD getChatCommandDescription"
end

function DarkRP.getChatCommands()
	--Description: Get every chat command.
	YRP.msg("darkrp", "getChatCommands()")
	YRP.msg("darkrp", DarkRP._not)
	return {}
end

function DarkRP.getDemoteGroup(teamNr)
	--Description: Get the demote group of a team. Every team in the same group will return the same object.
	YRP.msg("darkrp", "getDemoteGroup(" .. tostring(teamNr) .. ")")
	YRP.msg("darkrp", DarkRP._not)
	--set(Disjoint-Set) the demote group identifier
end

function DarkRP.getDemoteGroups()
	--Description: Get all demote groups Every team in the same group will return the same object.
	YRP.msg("darkrp", "getDemoteGroups()")
	YRP.msg("darkrp", DarkRP._not)
	--set(table) Table in which the keys are team numbers and the values Disjoint-Set.
end

function DarkRP.getDoorVars()
	--Description: Internal function, retrieves all the registered door variables.
	YRP.msg("darkrp", "getDoorVars()")
	YRP.msg("darkrp", DarkRP._not)
	return {}
end

function DarkRP.getDoorVarsByName()
	--Description: Internal function, retrieves all the registered door variables, indeded by their names.
	YRP.msg("darkrp", "getDoorVarsByName()")
	YRP.msg("darkrp", DarkRP._not)
	return {}
end

function DarkRP.getFoodItems()
	--Description: Get all food items.
	YRP.msg("darkrp", "getFoodItems()")
	YRP.msg("darkrp", DarkRP._not)
	--set (table) Table with food items.
end

function DarkRP.getGroupChats()
	--Description: Get all group chats.
	YRP.msg("darkrp", "getGroupChats()")
	YRP.msg("darkrp", DarkRP._not)
	--set (table) Table with food items.
end

function DarkRP.getIncompleteChatCommands()
	--Description: chat commands that have been defined, but not declared. Information about these chat commands is missing.
	YRP.msg("darkrp", "getIncompleteChatCommands()")
	YRP.msg("darkrp", DarkRP._not)
	return {}
end

function DarkRP.getJobByCommand(command)
	--Description: Get the job table and number from the command of the job.
	YRP.msg("darkrp", "getJobByCommand(" .. command .. ")")
	YRP.msg("darkrp", DarkRP._not)
	return {}, 0
end

function DarkRP.getLaws()
	--Description: Get the table of all current laws.
	YRP.msg("darkrp", "getLaws()")
	YRP.msg("darkrp", DarkRP._not)
	return {}
end

function DarkRP.getMissingPhrases(languageCode)
	--Description: Get all the phrases a language is missing.
	YRP.msg("darkrp", "getMissingPhrases(" .. languageCode .. ")")
	YRP.msg("darkrp", DarkRP._not)
	return "Old getMissingPhrases"
end

function DarkRP.getPhrase(key, parameters)
	--Description: Get a phrase from the selected language.
	key = tostring(key)
	YRP.msg("darkrp", "getPhrase(" .. key .. ", parameters)")
	--YRP.msg("darkrp", DarkRP._not)
	if key == "job" then
		key = "role"
	elseif key == "wallet" then
		key = "money"
	end
	local _translation = YRP.lang_string(key)
	return _translation
end

function DarkRP.getSortedChatCommands()
	--Description: Get every chat command, sorted by their name.
	YRP.msg("darkrp", "getSortedChatCommands()")
	YRP.msg("darkrp", DarkRP._not)
	return {}
end

function DarkRP.registerDoorVar(name, writeFn, readFn)
	--Description: Register a door variable by name. You should definitely
	--						 register door variables. Registering DarkRPVars will make
	--						 networking much more efficient.
	YRP.msg("darkrp", "registerDoorVar(name, writeFn, readFn)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.removeAgenda(name)
	--Description: Remove a agenda from DarkRP. NOTE: Must be called from BOTH
	--						 server AND client to properly get it removed!
	YRP.msg("darkrp", "removeAgenda(name)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.removeAmmoType(i)
	--Description: Remove an ammotype from DarkRP. NOTE: Must be called from BOTH
	--						 server AND client to properly get it removed!
	YRP.msg("darkrp", "removeAmmoType(i)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.removeChatCommand(command)
	--Description: Remove a chat command
	YRP.msg("darkrp", "removeChatCommand(command)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.removeDemoteGroup(name)
	--Description: Remove an demotegroup from DarkRP. NOTE: Must be called from
	--						 BOTH server AND client to properly get it removed!
	YRP.msg("darkrp", "removeDemoteGroup(name)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.removeEntity(i)
	--Description: Remove an entity from DarkRP. NOTE: Must be called from BOTH
	--						 server AND client to properly get it removed!
	YRP.msg("darkrp", "removeEntity(i)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.removeEntityGroup(name)
	--Description: Remove an entitygroup from DarkRP. NOTE: Must be called from
	--						 BOTH server AND client to properly get it removed!
	YRP.msg("darkrp", "removeEntityGroup(name)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.removeFoodItem(i)
	--Description: Remove a food item from DarkRP. NOTE: Must be called from BOTH
	--						 server AND client to properly get it removed!
	YRP.msg("darkrp", "removeFoodItem(i)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.removeFromCategory(item, kind)
	--Description: "Create a category for the F4 menu." <- Remove not create :D
	YRP.msg("darkrp", "removeFromCategory(item, kind)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.removeGroupChat(i)
	--Description: Remove a groupchat from DarkRP. NOTE: Must be called from BOTH
	--						 server AND client to properly get it removed!
	YRP.msg("darkrp", "removeGroupChat(i)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.removeJob(i)
	--Description: Remove a job from DarkRP.
	YRP.msg("darkrp", "removeJob(i)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.removePlayerGesture(anim)
	--Description: Removes a player gesture from the DarkRP animations menu (the
	--						 one that opens with the keys weapon.). Note: This function must
	--						 be called BOTH serverside AND clientside!
	YRP.msg("darkrp", "removePlayerGesture(anim)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.removeShipment(i)
	--Description: Remove a shipment from DarkRP. NOTE: Must be called from BOTH
	--						 server AND client to properly get it removed!
	YRP.msg("darkrp", "removeShipment(i)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.removeVehicle(i)
	--Description: Remove a vehicle from DarkRP. NOTE: Must be called from BOTH
	--						 server AND client to properly get it removed!
	YRP.msg("darkrp", "removeVehicle(i)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.simplerrRun(f, args)
	--Description: Run a function with the given parameters and send any runtime
	--						 errors to admins.
	YRP.msg("darkrp", "simplerrRun(f, args)")
	YRP.msg("darkrp", DarkRP._not)
	return {}
end
