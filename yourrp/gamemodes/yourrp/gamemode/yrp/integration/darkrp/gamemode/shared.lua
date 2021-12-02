--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

AddCSLuaFile("client.lua")

if CLIENT then
	include("client.lua")
else
	include("server.lua")
end

function DarkRP.addChatCommandsLanguage(languageCode, translations)
	--Description: Add a translation table for chat command descriptions. See darkrpmod/lua/darkrp_language/chatcommands.lua for an example.
	YRPDarkrpNotFound("addChatCommandsLanguage(" .. languageCode .. ", table)")
end

function DarkRP.addHitmanTeam(teamnumber)
	--Description: Make this team a hitman.
	YRPDarkrpNotFound("addHitmanTeam(" .. teamnumber .. ")")
end

function DarkRP.addLanguage(Languagename, Languagecontents)
	--Description: Create a language/translation.
	--YRPDarkrpNotFound("addLanguage(" .. Languagename .. ", table)")
end

function DarkRP.addPhrase(Languagename, key, translation)
	--Description: Add a phrase to the existing translation.
	--YRPDarkrpNotFound("addPhrase(" .. Languagename .. ", " .. key .. ", " .. translation .. ")")
	if Languagename == "en" and !string.StartWith( YRP.lang_string("LID_" .. key), "LID_" ) then
		YRP.set_lang_string("LID_" .. key, translation)
	end
end

function DarkRP.addPlayerGesture(anim, text)
	--Description: Add a player gesture to the DarkRP animations menu (the one that opens with the keys weapon.). Note: This function must be called BOTH serverside AND clientside!
	YRPDarkrpNotFound("addPlayerGesture(" .. anim .. ", " .. text .. ")")
end

function DarkRP.addToCategory(item, kind, cat)
	--Description: Create a category for the F4 menu.
	YRPDarkrpNotFound("addToCategory(item, " .. kind .. ", " .. cat .. ")")
end

function DarkRP.chatCommandAlias(command, alias)
	--Description: Create an alias for a chat command
	YRPDarkrpNotFound("addToCategory(" .. command .. ", alias)")
end

function DarkRP.createAgenda(title, manager, listeners)
	--Description: Create an agenda for groups of jobs to communicate.
	YRPDarkrpNotFound("createAgenda(" .. title .. ", " .. tostring(manager) .. ", listeners)")
end

function DarkRP.createAmmoType(name, tbl)
	--Description: Create an ammo type.
	--YRPDarkrpNotFound("createAmmoType(" .. name .. ", tbl)")
end

function DarkRP.createCategory( tbl )
	--Description: Create a category for the F4 menu.
	--YRPDarkrpNotFound("createCategory(" .. table.ToString( tbl or {}, "tbl", false ) ..")")
	if SERVER then
		if YRPIMPORTDARKRP then
			if tbl.categorises == "jobs" then
				local group = YRP_SQL_SELECT( "yrp_ply_groups", "*", "string_name = '" .. tbl.name .. "'" )
				if group == nil then
					MsgC( Color( 0, 255, 0 ), "[YRPImportCategory]", " Add Group (", tbl.name, ")", "\n" )
					local res = YRP_SQL_INSERT_INTO( "yrp_ply_groups", "string_name, string_color", YRP_SQL_STR_IN( tbl.name ) .. ", " .. YRP_SQL_STR_IN( YRPColorToString( tbl.color ) ) )
					if res != nil then
						MsgC( Color( 255, 0, 0 ), "[YRPImportCategory]", " FAILED? (", res, ")", "\n" )
					end
				else
					MsgC( Color( 255, 0, 0 ), "[YRPImportCategory]", " Already Added? (", tbl.name, ")", "\n" )
				end
			end
		end
	end
end

function DarkRP.createDemoteGroup(name, tbl)
	--Description: Create a demote group. When you get banned (demoted) from one of the jobs in this group, you will be banned from every job in this group.
	YRPDarkrpNotFound("createDemoteGroup(" .. name .. ", tbl)")
end

function DarkRP.createEntity(name, tbl)
	--Description: Create an entity for DarkRP.
	--YRPDarkrpNotFound("createEntity(" .. name .. ", tbl)")
end
AddEntity = DarkRP.createEntity

function DarkRP.createEntityGroup(name, teamNrs)
	--Description: Create an entity group for DarkRP.
	YRPDarkrpNotFound("createEntityGroup(" .. name .. ", " .. tostring(teamNrs) .. ")")
end

function DarkRP.createFood(name, tbl)
	--Description: Create food for DarkRP.
	YRPDarkrpNotFound("createFood(" .. name .. ", tbl)")
end

function DarkRP.createGroupChat(functionOrJob, teamNr)
	--Description: Create a group chat.
	YRPDarkrpNotFound("createGroupChat(functionOrJob, " .. tostring(teamNr) .. ")")
end

function DarkRP.createJob(name, tbl)
	--Description: Create a job for DarkRP.
	--YRPDarkrpNotFound("createJob(" .. name .. ", tbl)")
	if SERVER then
		if YRPIMPORTDARKRP then
			local groupid = 1
			local group = YRP_SQL_SELECT( "yrp_ply_groups", "*", "string_name = '" .. tbl.category .. "'" )
			if group == nil then
				MsgC( Color( 255, 0, 0 ), "[YRPImportJob]", " Group not found (", tbl.category, ")", "\n" )
			elseif group and group[1] then
				group = group[1]
				groupid = tonumber( group.uniqueID )
			end

			if YRP_SQL_SELECT( "yrp_ply_roles", "*", "string_name = '" .. name .. "' AND int_groupID = '" .. groupid .. "'" ) == nil then
				MsgC( Color( 255, 255, 0 ), "[YRPImportJob]", " Add Role: ", name, "\n" )
				
				local cols = "string_name, string_identifier, string_color, int_salary, int_groupID, string_description, int_maxamount"

				name = name or "unnamed"
				tbl.command =  tbl.command or ""
				tbl.color = YRPColorToString( tbl.color )
				tbl.salary = tbl.salary or 0
				tbl.description = tbl.description or "-"
				tbl.max = tbl.max or 0

				local vals = ""
				vals = vals .. YRP_SQL_STR_IN( name )
				vals = vals .. ","
				vals = vals .. YRP_SQL_STR_IN( tbl.command )
				vals = vals .. ","
				vals = vals .. YRP_SQL_STR_IN( tbl.color )
				vals = vals .. ","
				vals = vals .. YRP_SQL_STR_IN( tbl.salary )
				vals = vals .. ","
				vals = vals .. YRP_SQL_STR_IN( groupid )
				vals = vals .. ","
				vals = vals .. YRP_SQL_STR_IN( tbl.description )
				vals = vals .. ","
				vals = vals .. YRP_SQL_STR_IN( tbl.max )

				local res = YRP_SQL_INSERT_INTO( "yrp_ply_roles", cols, vals )
				if res == nil then
					local rols = YRP_SQL_SELECT( "yrp_ply_roles", "string_name, uniqueID", nil )
					local rol = rols[#rols]
					local ruid = rol.uniqueID

					-- SWEPS
					for i, swepcn in pairs( tbl.weapons ) do
						AddSwepToRole( ruid, swepcn )
					end

					-- Playermodels
					if type( tbl.model ) == "string" then
						tbl.model = { tbl.model }
					end
					YRPAddPlayermodelsToRole( tbl.model, "pms for " .. name, 1, 1, ruid )
				end
			else
				MsgC( Color( 255, 255, 0 ), "[YRPImportJob]", " Already added? (", name, ")", "\n" )
			end
		end
	end
	return -1
end

function DarkRP.createShipment(name, tbl)
	--Description: Create a vehicle for DarkRP.
	--YRPDarkrpNotFound("createShipment(" .. name .. ", " .. table.ToString( tbl or {}, "tbl", false ) .. ")")
end

function DarkRP.createVehicle(name, tbl)
	--Description: Create a shipment for DarkRP.
	YRPDarkrpNotFound("createVehicle(" .. name .. ", tbl)")
end

local declarechatcmds = {}
function DarkRP.declareChatCommand(tab)
	--Description: Declare a chat command (describe it)
	--YRPDarkrpNotFound(table.ToString( tab or {}, "declareChatCommand", false ))
	declarechatcmds[tab.command] = tab
end

function DarkRP.error(message, stack, hints, path, line)
	--Description: Throw a simplerr formatted error. Also halts the stack, which means that statements after calling this function will not execute.
	YRPDarkrpNotFound("error(" .. message .. ", " .. tostring(stack) .. ", hints, " .. path .. ", " .. tostring(line) .. ")")

	return false, "this say nothing"
end

function DarkRP.errorNoHalt(message, stack, hints, path, line)
	--Description: Throw a simplerr formatted error. Unlike DarkRP.error, this does not halt the stack. This means that statements after
	--						 calling this function will be executed like normal.
	YRPDarkrpNotFound("errorNoHalt(" .. message .. ", " .. tostring(stack) .. ", hints, " .. path .. ", " .. tostring(line) .. ")")

	return false, "this say nothing"
end

function DarkRP.explodeArg(arg)
	--Description: String arguments exploded into a table. It accounts for substrings in quotes, which makes it more intelligent than string.Explode
	YRPDarkrpNotFound("explodeArg(" .. arg .. ")")

	return {}
end

function DarkRP.findPlayer(info)
	--Description: Find a single player based on vague information.
	YRPDarkrpNotFound("findPlayer(" .. info .. ")")
	return NULL
end

function DarkRP.findPlayers(info)
	--Description: Find a list of players based on vague information.
	YRPDarkrpNotFound("findPlayers(" .. info .. ")")
	return {}
end

function DarkRP.formatMoney(amount)
	--Description: Format a number as a money value. Includes currency symbol.
	return formatMoney(amount)
end

function DarkRP.getAgendas()
	--Description: Get all agendas. Note: teams that share an agenda use the exact
	--						 same agenda table. E.g. when you change the agenda of the CP,
	--						 the agenda of the Chief will automatically be updated as well.
	--						 Make sure this property is maintained when modifying the agenda
	--						 table. Not maintaining that property will lead to players not
	--						 seeing the right agenda text.

	return {}
end

function DarkRP.getAvailableVehicles()
	--Description: Get the available vehicles that DarkRP supports.
	YRPDarkrpNotFound("getAvailableVehicles()")
	return {}
end

CATEGORIES = CATEGORIES or {}

function DarkRP.getCategories()
	--Description: Get all categories for all F4 menu tabs.
	return CATEGORIES
end

function DarkRP.getChatCommand(command)
	--Description: Get the information on a chat command.
	YRPDarkrpNotFound("getChatCommand(" .. command .. ")")
	return {}
end

function DarkRP.getChatCommandDescription(command)
	--Description: Get the translated description of a chat command.
	YRPDarkrpNotFound("getChatCommandDescription(" .. command .. ")")
	return "OLD getChatCommandDescription"
end

YRPDarkrpDefineChatCmds = YRPDarkrpDefineChatCmds or {}
function DarkRP.getChatCommands()
	--Description: Get every chat command.
	--YRPDarkrpNotFound("getChatCommands()")
	return YRPDarkrpDefineChatCmds
end

function DarkRP.getDemoteGroup(teamNr)
	--Description: Get the demote group of a team. Every team in the same group will return the same object.
	--set(Disjoint-Set) the demote group identifier
	return {}
end

function DarkRP.getDemoteGroups()
	--Description: Get all demote groups Every team in the same group will return the same object.
	return {}
end

function DarkRP.getDoorVars()
	--Description: Internal function, retrieves all the registered door variables.
	YRPDarkrpNotFound("getDoorVars()")
	return {}
end

function DarkRP.getDoorVarsByName()
	--Description: Internal function, retrieves all the registered door variables, indeded by their names.
	YRPDarkrpNotFound("getDoorVarsByName()")
	return {}
end

function DarkRP.getFoodItems()
	--Description: Get all food items.
	YRPDarkrpNotFound("getFoodItems()")
	--set (table) Table with food items.
end

function DarkRP.getGroupChats()
	--Description: Get all group chats.
	YRPDarkrpNotFound("getGroupChats()")
	--set (table) Table with food items.
end

function DarkRP.getIncompleteChatCommands()
	--Description: chat commands that have been defined, but not declared. Information about these chat commands is missing.
	YRPDarkrpNotFound("getIncompleteChatCommands()")
	return {}
end

jobByCmd = jobByCmd or {}
function DarkRP.getJobByCommand(command)
	--Description: Get the job table and number from the command of the job.
	if not jobByCmd[command] then return nil, nil end
    return RPExtraTeams[jobByCmd[command]], jobByCmd[command]
end

function DarkRP.getLaws()
	--Description: Get the table of all current laws.
	--YRPDarkrpNotFound("getLaws()")
	return {}
end

function DarkRP.getMissingPhrases(languageCode)
	--Description: Get all the phrases a language is missing.
	YRPDarkrpNotFound("getMissingPhrases(" .. languageCode .. ")")
	return "Old getMissingPhrases"
end

function DarkRP.getPhrase(key, parameters)
	--Description: Get a phrase from the selected language.
	key = tostring(key)
	--YRPDarkrpNotFound("getPhrase(" .. key .. ", parameters)")

	if key == "job" then
		key = "role"
	elseif key == "wallet" then
		key = "money"
	end
	local _translation = YRP.lang_string( "LID_" .. key )
	return _translation
end

function DarkRP.getSortedChatCommands()
	--Description: Get every chat command, sorted by their name.
	YRPDarkrpNotFound("getSortedChatCommands()")
	return {}
end

function DarkRP.registerDoorVar(name, writeFn, readFn)
	--Description: Register a door variable by name. You should definitely
	--						 register door variables. Registering DarkRPVars will make
	--						 networking much more efficient.
	YRPDarkrpNotFound("registerDoorVar(name, writeFn, readFn)")
end

function DarkRP.removeAgenda(name)
	--Description: Remove a agenda from DarkRP. NOTE: Must be called from BOTH
	--						 server AND client to properly get it removed!
	YRPDarkrpNotFound("removeAgenda(name)")
end

function DarkRP.removeAmmoType(i)
	--Description: Remove an ammotype from DarkRP. NOTE: Must be called from BOTH
	--						 server AND client to properly get it removed!
	YRPDarkrpNotFound("removeAmmoType(i)")
end

function DarkRP.removeChatCommand(command)
	--Description: Remove a chat command
	--YRPDarkrpNotFound("removeChatCommand(" .. command .. ")")
end

function DarkRP.removeDemoteGroup(name)
	--Description: Remove an demotegroup from DarkRP. NOTE: Must be called from
	--						 BOTH server AND client to properly get it removed!
	YRPDarkrpNotFound("removeDemoteGroup(name)")
end

function DarkRP.removeEntity(i)
	--Description: Remove an entity from DarkRP. NOTE: Must be called from BOTH
	--						 server AND client to properly get it removed!
	YRPDarkrpNotFound("removeEntity(" .. i .. ")")
end

function DarkRP.removeEntityGroup(name)
	--Description: Remove an entitygroup from DarkRP. NOTE: Must be called from
	--						 BOTH server AND client to properly get it removed!
	YRPDarkrpNotFound("removeEntityGroup(name)")
end

function DarkRP.removeFoodItem(i)
	--Description: Remove a food item from DarkRP. NOTE: Must be called from BOTH
	--						 server AND client to properly get it removed!
	YRPDarkrpNotFound("removeFoodItem(" .. i .. ")")
end

function DarkRP.removeFromCategory(item, kind)
	--Description: "Create a category for the F4 menu." <- Remove not create :D
	YRPDarkrpNotFound("removeFromCategory(item, kind)")
end

function DarkRP.removeGroupChat(i)
	--Description: Remove a groupchat from DarkRP. NOTE: Must be called from BOTH
	--						 server AND client to properly get it removed!
	YRPDarkrpNotFound("removeGroupChat(" .. i .. ")")
end

function DarkRP.removeJob(i)
	--Description: Remove a job from DarkRP.
	YRPDarkrpNotFound("removeJob(" .. i .. ")")
end

function DarkRP.removePlayerGesture(anim)
	--Description: Removes a player gesture from the DarkRP animations menu (the
	--						 one that opens with the keys weapon.). Note: This function must
	--						 be called BOTH serverside AND clientside!
	YRPDarkrpNotFound("removePlayerGesture(anim)")
end

function DarkRP.removeShipment(i)
	--Description: Remove a shipment from DarkRP. NOTE: Must be called from BOTH
	--						 server AND client to properly get it removed!
	YRPDarkrpNotFound("removeShipment(" .. i .. ")")
end

function DarkRP.removeVehicle(i)
	--Description: Remove a vehicle from DarkRP. NOTE: Must be called from BOTH
	--						 server AND client to properly get it removed!
	YRPDarkrpNotFound("removeVehicle(" .. i .. ")")
end

function DarkRP.simplerrRun(f, args)
	--Description: Run a function with the given parameters and send any runtime
	--						 errors to admins.
	YRPDarkrpNotFound("simplerrRun(f, args)")
	return {}
end

