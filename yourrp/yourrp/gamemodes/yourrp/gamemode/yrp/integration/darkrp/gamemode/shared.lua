--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
AddCSLuaFile("client.lua")
if CLIENT then
	include("client.lua")
else
	include("server.lua")
end

function DarkRP.error(message, stack, hints, path, line)
	--Description: Throw a simplerr formatted error. Also halts the stack, which means that statements after calling this function will not execute.
	YRPDarkrpNotFound("error( " .. message .. ", " .. tostring(stack) .. ", hints, " .. tostring(path) .. ", " .. tostring(line) .. " )")

	return false, "this say nothing"
end

function DarkRP.errorNoHalt(message, stack, hints, path, line)
	--Description: Throw a simplerr formatted error. Unlike DarkRP.error, this does not halt the stack. This means that statements after
	--						 calling this function will be executed like normal.
	YRPDarkrpNotFound("errorNoHalt( " .. message .. ", " .. tostring(stack) .. ", hints, " .. tostring(path) .. ", " .. tostring(line) .. " )")

	return false, "this say nothing"
end

function DarkRP.addChatCommandsLanguage(languageCode, translations)
	--Description: Add a translation table for chat command descriptions. See darkrpmod/lua/darkrp_language/chatcommands.lua for an example.
	YRPDarkrpNotFound("addChatCommandsLanguage( " .. languageCode .. ", table)")
end

function DarkRP.addHitmanTeam(teamnumber)
end

--Description: Make this team a hitman.
--YRPDarkrpNotFound( "addHitmanTeam( " .. teamnumber .. " )" )
function DarkRP.addLanguage(Languagename, Languagecontents)
end

--Description: Create a language/translation.
--YRPDarkrpNotFound( "addLanguage( " .. Languagename .. ", table)" )
function DarkRP.addPhrase(Languagename, key, translation)
	--Description: Add a phrase to the existing translation.
	--YRPDarkrpNotFound( "addPhrase( " .. Languagename .. ", " .. key .. ", " .. translation .. " )" )
	if Languagename == "en" and not string.StartWith(YRP.trans("LID_" .. key), "LID_") then
		YRP.set_lang_string("LID_" .. key, translation)
	end
end

function DarkRP.addPlayerGesture(anim, text)
end

--Description: Add a player gesture to the DarkRP animations menu (the one that opens with the keys weapon.). Note: This function must be called BOTH serverside AND clientside!
--YRPDarkrpNotFound( "addPlayerGesture( " .. anim .. ", " .. text .. " )" )
function DarkRP.addToCategory(item, kind, cat)
	--Description: Create a category for the F4 menu.
	YRPDarkrpNotFound("addToCategory(item, " .. kind .. ", " .. cat .. " )")
end

function DarkRP.chatCommandAlias(command, alias)
	--Description: Create an alias for a chat command
	YRPDarkrpNotFound("addToCategory( " .. command .. ", alias)")
end

function DarkRP.createAgenda(title, manager, listeners)
	--Description: Create an agenda for groups of jobs to communicate.
	YRPDarkrpNotFound("createAgenda( " .. title .. ", " .. tostring(manager) .. ", listeners)")
end

function DarkRP.createAmmoType(name, tbl)
end

--Description: Create an ammo type.
--YRPDarkrpNotFound( "createAmmoType( " .. name .. ", tbl)" )
function DarkRP.createCategory(tbl)
	--Description: Create a category for the F4 menu.
	--YRPDarkrpNotFound( "createCategory( " .. table.ToString( tbl or {}, "tbl", false ) .." )" )
	if SERVER and YRPIMPORTDARKRP and tbl.categorises == "jobs" then
		local group = YRP_SQL_SELECT("yrp_ply_groups", "*", "string_name = '" .. tbl.name .. "'")
		if group == nil then
			MsgC(Color(0, 255, 0), "[YRPImportCategory]", " Add Group ( ", tbl.name, " )", "\n")
			local res = YRP_SQL_INSERT_INTO("yrp_ply_groups", "string_name, string_color", YRP_SQL_STR_IN(tbl.name) .. ", " .. YRP_SQL_STR_IN(YRPColorToString(tbl.color)))
			if res ~= nil then
				MsgC(Color(0, 255, 0), "[YRPImportCategory]", " FAILED? ( ", res, " )", "\n")
			end
		else
			MsgC(Color(0, 255, 0), "[YRPImportCategory]", " Already Added? ( ", tbl.name, " )", "\n")
		end
	end
end

function DarkRP.YRPCreateDemoteGroup(name, tbl)
	--Description: Create a demote group. When you get banned ( demoted) from one of the jobs in this group, you will be banned from every job in this group.
	YRPDarkrpNotFound("YRPCreateDemoteGroup( " .. name .. ", tbl)")
end

function DarkRP.createEntity(name, tbl)
end

--Description: Create an entity for DarkRP.
--YRPDarkrpNotFound( "createEntity( " .. name .. ", tbl)" )
AddEntity = DarkRP.createEntity
function DarkRP.createEntityGroup(name, teamNrs)
end

--Description: Create an entity group for DarkRP.
--YRPDarkrpNotFound("createEntityGroup( " .. name .. ", " .. tostring(teamNrs) .. " )")
AddDoorGroup = DarkRP.createEntityGroup
function DarkRP.createFood(name, tbl)
	--Description: Create food for DarkRP.
	YRPDarkrpNotFound("createFood( " .. name .. ", tbl)")
end

function DarkRP.createGroupChat(functionOrJob, teamNr)
	--Description: Create a group chat.
	YRPDarkrpNotFound("createGroupChat(functionOrJob, " .. tostring(teamNr) .. " )")
end

function DarkRP.createJob(name, tbl)
	--Description: Create a job for DarkRP.
	--YRPDarkrpNotFound( "createJob( " .. name .. ", tbl)" )
	if SERVER and YRPIMPORTDARKRP and tbl and tbl.category then
		local groupid = 1
		local group = YRP_SQL_SELECT("yrp_ply_groups", "*", "string_name = '" .. tbl.category .. "'")
		if group == nil then
			MsgC(Color(0, 255, 0), "[YRPImportJob]", " Group not found ( ", tbl.category, " )", "\n")
		elseif group and group[1] then
			group = group[1]
			groupid = tonumber(group.uniqueID)
		end

		if YRP_SQL_SELECT("yrp_ply_roles", "*", "string_name = '" .. name .. "' AND int_groupID = '" .. groupid .. "'") == nil then
			MsgC(Color(255, 255, 0), "[YRPImportJob]", " Add Role: ", name, "\n")
			local cols = "string_name, string_identifier, string_color, int_salary, int_groupID, string_description, int_maxamount"
			name = name or "unnamed"
			tbl.command = tbl.command or ""
			tbl.color = YRPColorToString(tbl.color)
			tbl.salary = tbl.salary or 0
			tbl.description = tbl.description or "-"
			tbl.max = tbl.max or 0
			local vals = ""
			vals = vals .. YRP_SQL_STR_IN(name)
			vals = vals .. ","
			vals = vals .. YRP_SQL_STR_IN(tbl.command)
			vals = vals .. ","
			vals = vals .. YRP_SQL_STR_IN(tbl.color)
			vals = vals .. ","
			vals = vals .. YRP_SQL_STR_IN(tbl.salary)
			vals = vals .. ","
			vals = vals .. YRP_SQL_STR_IN(groupid)
			vals = vals .. ","
			vals = vals .. YRP_SQL_STR_IN(tbl.description)
			vals = vals .. ","
			vals = vals .. YRP_SQL_STR_IN(tbl.max)
			local res = YRP_SQL_INSERT_INTO("yrp_ply_roles", cols, vals)
			if res == nil then
				local rols = YRP_SQL_SELECT("yrp_ply_roles", "string_name, uniqueID", nil)
				local rol = rols[#rols]
				local ruid = rol.uniqueID
				-- SWEPS
				for i, swepcn in pairs(tbl.weapons) do
					AddSwepToRole(ruid, swepcn)
				end

				-- Playermodels
				if type(tbl.model) == "string" then
					if strEmpty(tbl.model) then
						tbl.model = "models/player/skeleton.mdl"
					else
						tbl.model = {tbl.model}
					end
				end

				YRPAddPlayermodelsToRole(tbl.model, "pms for " .. name, 1, 1, ruid)
			end
		else
			MsgC(Color(255, 255, 0), "[YRPImportJob]", " Already added? ( ", name, " )", "\n")
		end
	end

	return -1
end

function DarkRP.createShipment(name, tbl)
end

--Description: Create a vehicle for DarkRP.
--YRPDarkrpNotFound( "createShipment( " .. name .. ", " .. table.ToString( tbl or {}, "tbl", false ) .. " )" )
function DarkRP.createVehicle(name, tbl)
	--Description: Create a shipment for DarkRP.
	YRPDarkrpNotFound("createVehicle( " .. name .. ", tbl)")
end

DarkRP.chatCommands = DarkRP.chatCommands or {}
local validChatCommand = {
	command = isstring,
	description = isstring,
	delay = isnumber,
}

local checkChatCommand = function(tbl)
	for k in pairs(validChatCommand) do
		if not validChatCommand[k](tbl[k]) then return false, k end
	end

	return true
end

function DarkRP.declareChatCommand(tbl)
	--Description: Declare a chat command ( describe it)
	DarkRP.chatCommands = DarkRP.chatCommands or {}
	local valid, element = checkChatCommand(tbl)
	if not valid then
		DarkRP.error("Incorrect chat command! " .. element .. " is invalid!", 2)
	end

	tbl.command = string.lower(tbl.command)
	DarkRP.chatCommands[tbl.command] = DarkRP.chatCommands[tbl.command] or tbl
	for k, v in pairs(tbl) do
		DarkRP.chatCommands[tbl.command][k] = v
	end
end

DarkRP.declareChatCommand(
	{
		command = "advert",
		description = "Create a billboard holding an advertisement.",
		delay = 1.5
	}
)

function DarkRP.explodeArg(arg)
	--Description: String arguments exploded into a table. It accounts for substrings in quotes, which makes it more intelligent than string.Explode
	YRPDarkrpNotFound("explodeArg( " .. arg .. " )")

	return {}
end

function DarkRP.findPlayer(info)
	--Description: Find a single player based on vague information.
	YRPDarkrpNotFound("findPlayer( " .. info .. " )")

	return NULL
end

function DarkRP.findPlayers(info)
	--Description: Find a list of players based on vague information.
	YRPDarkrpNotFound("findPlayers( " .. info .. " )")

	return {}
end

function DarkRP.formatMoney(amount)
	return formatMoney(amount)
end

--Description: Format a number as a money value. Includes currency symbol.
function DarkRP.getAgendas()
	return {}
end

--Description: Get all agendas. Note: teams that share an agenda use the exact
--						 same agenda table. E.g. when you change the agenda of the CP,
--						 the agenda of the Chief will automatically be updated as well.
--						 Make sure this property is maintained when modifying the agenda
--						 table. Not maintaining that property will lead to players not
--						 seeing the right agenda text.
function DarkRP.getAvailableVehicles()
	--Description: Get the available vehicles that DarkRP supports.
	YRPDarkrpNotFound("getAvailableVehicles()")

	return {}
end

CATEGORIES = CATEGORIES or {}
CATEGORIES.jobs = CATEGORIES.jobs or {}
CATEGORIES.entities = CATEGORIES.entities or {}
CATEGORIES.shipments = CATEGORIES.shipments or {}
CATEGORIES.weapons = CATEGORIES.weapons or {}
CATEGORIES.ammo = CATEGORIES.ammo or {}
CATEGORIES.vehicles = CATEGORIES.vehicles or {}
function DarkRP.getCategories()
	return CATEGORIES
end

function DarkRP.getChatCommand(command)
	DarkRP.chatCommands = DarkRP.chatCommands or {}
	--Description: Get the information on a chat command.

	return DarkRP.chatCommands[string.lower(command)]
end

function DarkRP.getChatCommandDescription(command)
	return "OLD getChatCommandDescription"
end

function DarkRP.getChatCommands()
	DarkRP.chatCommands = DarkRP.chatCommands or {}

	return DarkRP.chatCommands
end

function DarkRP.getDemoteGroup(teamNr)
	return {}
end

function DarkRP.getDemoteGroups()
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
	if RPExtraTeams[jobByCmd[command]] or jobByCmd[command] then
		return RPExtraTeams[jobByCmd[command]], jobByCmd[command]
	else
		return RPExtraTeams[1], 1
	end
end

function DarkRP.getLaws()
	return {}
end

function DarkRP.getMissingPhrases(languageCode)
	--Description: Get all the phrases a language is missing.
	YRPDarkrpNotFound("getMissingPhrases( " .. languageCode .. " )")

	return "Old getMissingPhrases"
end

function DarkRP.getPhrase(key, parameters)
	--Description: Get a phrase from the selected language.
	key = tostring(key)
	--YRPDarkrpNotFound( "getPhrase( " .. key .. ", parameters)" )
	if key == "job" then
		key = "role"
	elseif key == "wallet" then
		key = "money"
	end

	local _translation = YRP.trans("LID_" .. key)

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
end

function DarkRP.removeDemoteGroup(name)
	--Description: Remove an demotegroup from DarkRP. NOTE: Must be called from
	--						 BOTH server AND client to properly get it removed!
	YRPDarkrpNotFound("removeDemoteGroup(name)")
end

function DarkRP.removeEntity(i)
	--Description: Remove an entity from DarkRP. NOTE: Must be called from BOTH
	--						 server AND client to properly get it removed!
	YRPDarkrpNotFound("removeEntity( " .. i .. " )")
end

function DarkRP.removeEntityGroup(name)
	--Description: Remove an entitygroup from DarkRP. NOTE: Must be called from
	--						 BOTH server AND client to properly get it removed!
	YRPDarkrpNotFound("removeEntityGroup(name)")
end

function DarkRP.removeFoodItem(i)
	--Description: Remove a food item from DarkRP. NOTE: Must be called from BOTH
	--						 server AND client to properly get it removed!
	YRPDarkrpNotFound("removeFoodItem( " .. i .. " )")
end

function DarkRP.removeFromCategory(item, kind)
	--Description: "Create a category for the F4 menu." <- Remove not create :D
	YRPDarkrpNotFound("removeFromCategory(item, kind)")
end

function DarkRP.removeGroupChat(i)
	--Description: Remove a groupchat from DarkRP. NOTE: Must be called from BOTH
	--						 server AND client to properly get it removed!
	YRPDarkrpNotFound("removeGroupChat( " .. i .. " )")
end

function DarkRP.removeJob(i)
	--Description: Remove a job from DarkRP.
	YRPDarkrpNotFound("removeJob( " .. i .. " )")
end

function DarkRP.removePlayerGesture(anim)
	--Description: Removes a player gesture from the DarkRP animations menu (the
	--						 one that opens with the keys weapon.). Note: This function must
	--						 be called BOTH serverside AND clientside!
	YRPDarkrpNotFound("removePlayerGesture( anim)")
end

function DarkRP.removeShipment(i)
	--Description: Remove a shipment from DarkRP. NOTE: Must be called from BOTH
	--						 server AND client to properly get it removed!
	YRPDarkrpNotFound("removeShipment( " .. i .. " )")
end

function DarkRP.removeVehicle(i)
	--Description: Remove a vehicle from DarkRP. NOTE: Must be called from BOTH
	--						 server AND client to properly get it removed!
	YRPDarkrpNotFound("removeVehicle( " .. i .. " )")
end

function DarkRP.simplerrRun(f, args)
	--Description: Run a function with the given parameters and send any runtime
	--						 errors to admins.
	YRPDarkrpNotFound("simplerrRun(f, args)")

	return {}
end

DarkRPEntities = DarkRPEntities or {}
-- "MYSQLite"
local debug = debug
local error = error
local ErrorNoHalt = ErrorNoHalt
local hook = hook
local pairs = pairs
local require = require
local sql = sql
local string = string
local table = table
local timer = timer
local tostring = tostring
local mysqlOO
local TMySQL
local _G = _G
local multistatements
local MySQLite_config = MySQLite_config or RP_MySQLConfig or FPP_MySQLConfig
local moduleLoaded
local function loadMySQLModule()
	if moduleLoaded or not MySQLite_config or not MySQLite_config.EnableMySQL then return end
	local moo, tmsql = file.Exists("bin/gmsv_mysqloo_*.dll", "LUA"), file.Exists("bin/gmsv_tmysql4_*.dll", "LUA")
	if not moo and not tmsql then
		error("Could not find a suitable MySQL module. Supported modules are MySQLOO and tmysql4.")
	end

	moduleLoaded = true
	require(moo and tmsql and MySQLite_config.Preferred_module or moo and "mysqloo" or "tmysql4")
	multistatements = CLIENT_MULTI_STATEMENTS
	mysqlOO = mysqloo
	TMySQL = tmysql
	if MySQLite_config.Preferred_module == "tmysql4" then
		if not tmysql.Version or tmysql.Version < 4.1 then
			MsgC(Color(0, 255, 0), "Using older tmysql version, please consider updating!\n")
			MsgC(Color(0, 255, 0), "Newer Version: https://github.com/SuperiorServers/gm_tmysql4\n")
		end

		-- Turns tmysql.Connect into tmysql.Initialize if they're using an older version.
		TMySQL.Connect = tmysql.Version and tmysql.Version >= 4.1 and TMySQL.Connect or TMySQL.initialize
		TMySQL.SetOption = tmysql.Version and tmysql.Version >= 4.1 and TMySQL.SetOption or TMySQL.Option
	end
end

loadMySQLModule()
module("MySQLite")
-- Helper function to return the first value found when iterating over a table.
-- Replaces the now deprecated table.GetFirstValue
local function arbitraryTableValue(tbl)
	for _, v in pairs(tbl) do
		return v
	end
end

function initialize(config)
	MySQLite_config = config or MySQLite_config
	if not MySQLite_config then
		ErrorNoHalt("Warning: No MySQL config!")
	end

	loadMySQLModule()
	if MySQLite_config.EnableMySQL then
		connectToMySQL(MySQLite_config.Host, MySQLite_config.Username, MySQLite_config.Password, MySQLite_config.Database_name, MySQLite_config.Database_port)
	else
		timer.Simple(
			0,
			function()
				_G.GAMEMODE.DatabaseInitialized = _G.GAMEMODE.DatabaseInitialized or function() end
				hook.Call("DatabaseInitialized", _G.GAMEMODE)
			end
		)
	end
end

local CONNECTED_TO_MYSQL = false
local msOOConnect
databaseObject = nil
local queuedQueries
local cachedQueries
function isMySQL()
	return CONNECTED_TO_MYSQL
end

function begin()
	if not CONNECTED_TO_MYSQL then
		sql.Begin()
	else
		if queuedQueries then
			debug.Trace()
			error("Transaction ongoing!")
		end

		queuedQueries = {}
	end
end

function commit(onFinished)
	if not CONNECTED_TO_MYSQL then
		sql.Commit()
		if onFinished then
			onFinished()
		end

		return
	end

	if not queuedQueries then
		error("No queued queries! Call begin() first!")
	end

	if #queuedQueries == 0 then
		queuedQueries = nil
		if onFinished then
			onFinished()
		end

		return
	end

	-- Copy the table so other scripts can create their own queue
	local queue = table.Copy(queuedQueries)
	queuedQueries = nil
	-- Handle queued queries in order
	local queuePos = 0
	local call
	-- Recursion invariant: queuePos > 0 and queue[queuePos] <= #queue
	call = function(...)
		queuePos = queuePos + 1
		if queue[queuePos].callback then
			queue[queuePos].callback(...)
		end

		-- Base case, end of the queue
		if queuePos + 1 > #queue then
			-- All queries have finished
			if onFinished then
				onFinished()
			end

			return
		end

		-- Recursion
		local nextQuery = queue[queuePos + 1]
		query(nextQuery.query, call, nextQuery.onError)
	end

	query(queue[1].query, call, queue[1].onError)
end

function queueQuery(sqlText, callback, errorCallback)
	if CONNECTED_TO_MYSQL then
		table.insert(
			queuedQueries,
			{
				query = sqlText,
				callback = callback,
				onError = errorCallback
			}
		)

		return
	end

	-- SQLite is instantaneous, simply running the query is equal to queueing it
	query(sqlText, callback, errorCallback)
end

local function msOOQuery(sqlText, callback, errorCallback, queryValue)
	local queryObject = databaseObject:query(sqlText)
	local data
	queryObject.onData = function(Q, D)
		data = data or {}
		data[#data + 1] = D
	end

	queryObject.onError = function(Q, E)
		if databaseObject:status() == mysqlOO.DATABASE_NOT_CONNECTED then
			table.insert(cachedQueries, {sqlText, callback, queryValue})
			-- Immediately try reconnecting
			msOOConnect(MySQLite_config.Host, MySQLite_config.Username, MySQLite_config.Password, MySQLite_config.Database_name, MySQLite_config.Database_port)

			return
		end

		local supp = errorCallback and errorCallback(E, sqlText)
		if not supp then
			error(E .. " (" .. sqlText .. ")")
		end
	end

	queryObject.onSuccess = function()
		local res = queryValue and data and data[1] and arbitraryTableValue(data[1]) or not queryValue and data or nil
		if callback then
			callback(res, queryObject:lastInsert())
		end
	end

	queryObject:start()
end

local function tmsqlQuery(sqlText, callback, errorCallback, queryValue)
	local call = function(res)
		res = res[1] -- For now only support one result set
		if not res.status then
			local supp = errorCallback and errorCallback(res.error, sqlText)
			if not supp then
				error(res.error .. " (" .. sqlText .. ")")
			end

			return
		end

		-- compatibility with other backends
		if not res.data or #res.data == 0 then
			res.data = nil
		end

		if queryValue and callback then return callback(res.data and res.data[1] and arbitraryTableValue(res.data[1]) or nil) end
		if callback then
			callback(res.data, res.lastid)
		end
	end

	databaseObject:Query(sqlText, call)
end

local function SQLiteQuery(sqlText, callback, errorCallback, queryValue)
	sql.m_strError = "" -- reset last error
	local lastError = sql.LastError()
	local Result = queryValue and sql.QueryValue(sqlText) or sql.Query(sqlText)
	if sql.LastError() and sql.LastError() ~= lastError then
		local err = sql.LastError()
		local supp = errorCallback and errorCallback(err, sqlText)
		if supp == false then
			error(err .. " (" .. sqlText .. ")", 2)
		end

		return
	end

	if callback then
		callback(Result)
	end

	return Result
end

function query(sqlText, callback, errorCallback)
	local qFunc = (CONNECTED_TO_MYSQL and ((mysqlOO and msOOQuery) or (TMySQL and tmsqlQuery))) or SQLiteQuery

	return qFunc(sqlText, callback, errorCallback, false)
end

function queryValue(sqlText, callback, errorCallback)
	local qFunc = (CONNECTED_TO_MYSQL and ((mysqlOO and msOOQuery) or (TMySQL and tmsqlQuery))) or SQLiteQuery

	return qFunc(sqlText, callback, errorCallback, true)
end

local function onConnected()
	CONNECTED_TO_MYSQL = true
	-- Run the queries that were called before the connection was made
	for k, v in pairs(cachedQueries or {}) do
		cachedQueries[k] = nil
		if v[3] then
			queryValue(v[1], v[2])
		else
			query(v[1], v[2])
		end
	end

	cachedQueries = {}
	local GM = _G.GAMEMODE or _G.GM
	hook.Call("DatabaseInitialized", GM.DatabaseInitialized and GM or nil)
end

msOOConnect = function(host, username, password, database_name, database_port)
	databaseObject = mysqlOO.connect(host, username, password, database_name, database_port)
	if timer.Exists("darkrp_check_mysql_status") then
		timer.Remove("darkrp_check_mysql_status")
	end

	databaseObject.onConnectionFailed = function(_, msg)
		timer.Simple(
			5,
			function()
				msOOConnect(MySQLite_config.Host, MySQLite_config.Username, MySQLite_config.Password, MySQLite_config.Database_name, MySQLite_config.Database_port)
			end
		)

		error("Connection failed! " .. tostring(msg) .. "\nTrying again in 5 seconds.")
	end

	databaseObject.onConnected = onConnected
	databaseObject:connect()
end

local function tmsqlConnect(host, username, password, database_name, database_port)
	local db, err = TMySQL.Connect(host, username, password, database_name, database_port, nil, MySQLite_config.MultiStatements and multistatements or nil)
	if err then
		error("Connection failed! " .. err .. "\n")
	end

	databaseObject = db
	onConnected()
	if TMySQL.Version and TMySQL.Version >= 4.1 then
		hook.Add(
			"Think",
			"MySQLite:tmysqlPoll",
			function()
				db:Poll()
			end
		)
	end
end

function connectToMySQL(host, username, password, database_name, database_port)
	database_port = database_port or 3306
	local func = mysqlOO and msOOConnect or TMySQL and tmsqlConnect or function() end
	func(host, username, password, database_name, database_port)
end

function SQLStr(sqlStr)
	local escape = not CONNECTED_TO_MYSQL and sql.SQLStr or mysqlOO and function(str) return "\"" .. databaseObject:escape(tostring(str)) .. "\"" end or TMySQL and function(str) return "\"" .. databaseObject:Escape(tostring(str)) .. "\"" end

	return escape(sqlStr)
end

function tableExists(tbl, callback, errorCallback)
	if not CONNECTED_TO_MYSQL then
		local exists = sql.TableExists(tbl)
		callback(exists)

		return exists
	end

	queryValue(
		string.format("SHOW TABLES LIKE %s", SQLStr(tbl)),
		function(v)
			callback(v ~= nil)
		end, errorCallback
	)
end