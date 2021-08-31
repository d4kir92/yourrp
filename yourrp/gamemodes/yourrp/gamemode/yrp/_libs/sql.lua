--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

function disk_full(error)
	if string.find(error, "database or disk is full") then
		if SERVER then
			PrintMessage(HUD_PRINTCENTER, "database or disk is full, please make more space!")
			net.Start("yrp_noti")
			net.WriteString("database_full_server")
			net.WriteString("")
			net.Broadcast()
		elseif CLIENT then
			local lply = LocalPlayer()
			lply:PrintMessage(HUD_PRINTTALK, "database or disk is full, please make more space!")
			notification.AddLegacy("[YourRP] Database or disk is full, please make more space!", NOTIFY_ERROR, 40)
			YRP.msg("error", GetSQLModeName() .. ": " .. tostring(lply:SteamID()) .. " (database or disk is full)")
		end
	end
end

function sql_show_last_error()
	--YRP.msg("db", "sql_show_last_error()")
	local _last_error = tostring(sql.LastError()) or ""

	if SERVER then
		PrintMessage(HUD_PRINTCENTER, "[YourRP|DATABASE] SERVER-DATABASE:")
		PrintMessage(HUD_PRINTCENTER, _last_error)
	elseif CLIENT then
		local lply = LocalPlayer()

		if ea(lply) then
			lply:PrintMessage(HUD_PRINTTALK, "[YourRP|DATABASE] CLIENT-DATABASE:")
			lply:PrintMessage(HUD_PRINTTALK, _last_error)
		end
	end

	timer.Simple(3, function()
		disk_full(_last_error)
	end)

	return _last_error
end

local YRP_DB_DC = {}
table.insert(YRP_DB_DC, " ")
table.insert(YRP_DB_DC, "'")
table.insert(YRP_DB_DC, "´")
table.insert(YRP_DB_DC, "`")
table.insert(YRP_DB_DC, "#")
table.insert(YRP_DB_DC, "*")
table.insert(YRP_DB_DC, "+")
table.insert(YRP_DB_DC, "-")
table.insert(YRP_DB_DC, "(")
table.insert(YRP_DB_DC, ")")
table.insert(YRP_DB_DC, "[")
table.insert(YRP_DB_DC, "]")
table.insert(YRP_DB_DC, "{")
table.insert(YRP_DB_DC, "}")
table.insert(YRP_DB_DC, "^")
table.insert(YRP_DB_DC, "°")
table.insert(YRP_DB_DC, "!")
table.insert(YRP_DB_DC, "§")
table.insert(YRP_DB_DC, "$")
table.insert(YRP_DB_DC, "&")
table.insert(YRP_DB_DC, "/")
table.insert(YRP_DB_DC, "=")
table.insert(YRP_DB_DC, "\"")
table.insert(YRP_DB_DC, "?")
table.insert(YRP_DB_DC, ".")
table.insert(YRP_DB_DC, ",")
table.insert(YRP_DB_DC, ";")
table.insert(YRP_DB_DC, "<")
table.insert(YRP_DB_DC, ">")
table.insert(YRP_DB_DC, "ü")
table.insert(YRP_DB_DC, "ö")
table.insert(YRP_DB_DC, "ä")
table.insert(YRP_DB_DC, "Ü")
table.insert(YRP_DB_DC, "Ö")
table.insert(YRP_DB_DC, "Ä")

function SQL_STR_IN(str)
	local _res = tostring(str)

	for k, sym in pairs(YRP_DB_DC) do
		local _pre = ""

		if k < 10 then
			_pre = "0"
		end

		_res = string.Replace(_res, sym, "%" .. _pre .. k)
	end

	_res = sql.SQLStr(_res, true)

	return _res
end

function SQL_STR_OUT(str)
	local _res = str

	if type(_res) == "string" then
		for k, sym in pairs(YRP_DB_DC) do
			local _pre = ""

			if k < 10 then
				_pre = "0"
			end

			_res = string.Replace(_res, "%" .. _pre .. k, sym)
		end

		return _res
	else
		return ""
	end
end

function db_int(int)
	local _int = tonumber(int)

	if isnumber(_int) then
		return _int
	else
		YRP.msg("error", GetSQLModeName() .. ": " .. tostring(int) .. " is not a number! return -1")

		return -1
	end
end

function db_drop_table(db_table)
	local _result = sql.Query("DROP TABLE " .. db_table)

	if _result != nil then
		YRP.msg("error", GetSQLModeName() .. ": " .. "db_drop_table " .. tostring(db_table) .. " failed! (result: " .. tostring(_result) .. ")")
		sql_show_last_error()
	end
end

function retry_load_database(db_name)
	YRP.msg("error", GetSQLModeName() .. ": " .. "retry_load_database " .. tostring(db_name))
	--SQL_INIT_DATABASE(db_name)
end

local _show_db_if_not_empty = false

function db_is_empty(db_name)
	local _tmp = SQL_SELECT(db_name, "*", nil)

	if worked(_tmp, db_name .. " is empty!") then
		if _show_db_if_not_empty then
			hr_pre("db")
			YRP.msg("db", db_name)
			printTab(_tmp, db_name)
			hr_pos("db")
		end

		return false
	else
		return true
	end
end

function db_worked(query)
	if query == nil then
		return "worked"
	else
		return "not worked"
	end
end

-- NEW SQL API
YRPSQL = YRPSQL or {}
YRPSQL.int_mode = 0

function GetSQLMode()
	return tonumber(YRPSQL.int_mode)
end

function GetSQLModeName()
	if GetSQLMode() == 0 then
		return "SQLITE"
	elseif GetSQLMode() == 1 then
		return "MYSQL"
	end
	return "!BROKEN!"
end

function SetSQLMode(sqlmode, force)
	YRPSQL.int_mode = tonumber(sqlmode)
	if force then
		YRP.msg("db", "Update SQLMODE to: " .. YRPSQL.int_mode)
		local _q = "UPDATE "
		_q = _q .. "yrp_sql"
		_q = _q .. " SET " .. "int_mode = " .. YRPSQL.int_mode
		_q = _q .. " WHERE uniqueID = 1"
		_q = _q .. ";"
		sql.Query(_q)
	end
end

function SQL_TABLE_EXISTS(db_table)
	-- YRP.msg("db", "SQL_TABLE_EXISTS(" .. tostring(db_table) .. ")")
	if GetSQLMode() == 0 then
		local _r = SQL_SELECT(db_table, "*", nil)

		if _r == nil or istable(_r) then
			return true
		else
			--YRP.msg("note", "Table [" .. tostring(db_table) .. "] not exists.")

			return false
		end
	elseif GetSQLMode() == 1 then
		local _r = SQL_SELECT(db_table, "*", nil)

		if _r == nil or istable(_r) then
			return true
		else
			--YRP.msg("note", "Table [" .. tostring(db_table) .. "] not exists.")

			return false
		end
	end
end

function SQL_QUERY(query)
	query = tostring(query)

	--YRP.msg("db", "SQL_QUERY(" .. tostring(query) .. ")")
	if !string.find(query, ";") then
		YRP.msg("error", GetSQLModeName() .. ": " .. "Query has no ; [" .. query .. "]")

		return false
	end

	if GetSQLMode() == 0 then
		local _result = sql.Query(query)

		if _result == nil then
			return _result
		elseif _result == false then
			return _result
		else
			--YRP.msg("db", "ELSE")
			return _result
		end
	elseif GetSQLMode() == 1 then
		if YRPSQL.db != nil then
			local que = YRPSQL.db:query(query)

			que.onError = function(q, e)
				if string.find(e, "Unknown column") == nil and string.find(e, "doesn't exist") == nil then
					YRP.msg("error", GetSQLModeName() .. ": " .. "SQL_QUERY - ERROR: " .. tostring(e) .. " lastError: " .. sql_show_last_error() .. " query: " .. tostring(query))
					q:error()
				end
			end

			que:start()
			que:wait(true)
			local _test = que:getData()

			if istable(_test) then
				if #_test == 0 then return nil end --YRP.msg("db", "SQL_QUERY TABLE EMPTY 1")

				return _test
			elseif _test == nil then
				--YRP.msg("db", "SQL_QUERY TABLE EMPTY 2")
				return false
			else
				YRP.msg("db", "SQL_QUERY TABLE MISSING (" .. tostring(_test) .. ")")

				return false
			end
		else
			YRP.msg("db", "CURRENTLY NOT CONNECTED TO MYSQL SERVER")
		end
	end
end

function SQL_DROP_TABLE(db_table)
	local _result = SQL_QUERY("DROP TABLE " .. db_table .. ";")

	if _result != nil then
		YRP.msg("error", GetSQLModeName() .. ": " .. "SQL_DROP_TABLE " .. tostring(db_table) .. " failed! (result: " .. tostring(_result) .. ")")
		sql_show_last_error()
	else
		YRP.msg("db", "DROPPED " .. tostring(db_table) .. " TABLE")
	end
end

function SQL_CREATE_TABLE(db_table)
	YRP.msg("db", "Create Table (" .. tostring(db_table) .. ")")

	if GetSQLMode() == 0 then
		local _q = "CREATE TABLE "
		_q = _q .. db_table .. " ("
		_q = _q .. "uniqueID		INTEGER				 PRIMARY KEY autoincrement"
		_q = _q .. ")"
		_q = _q .. ";"
		local _result = SQL_QUERY(_q)

		return _result
	elseif GetSQLMode() == 1 then
		local _q = "CREATE TABLE "
		_q = _q .. YRPSQL.schema .. "." .. db_table .. " ("
		_q = _q .. "uniqueID		INTEGER				 PRIMARY KEY AUTO_INCREMENT"
		_q = _q .. ")"
		_q = _q .. ";"
		local _result = SQL_QUERY(_q)

		return _result
	end
end

function SQL_SELECT(db_table, db_columns, db_where, db_extra)
	--YRP.msg("db", "SQL_SELECT(" .. tostring(db_table) .. ", " .. tostring(db_columns) .. ", " .. tostring(db_where) .. ")")
	if GetSQLMode() == 0 then
		local _q = "SELECT "
		_q = _q .. db_columns
		_q = _q .. " FROM " .. tostring(db_table)

		if db_where != nil then
			_q = _q .. " WHERE "
			_q = _q .. db_where
		end

		if db_extra then
			_q = _q .. " " .. db_extra
		end
		
		_q = _q .. ";"

		return SQL_QUERY(_q)
	elseif GetSQLMode() == 1 then
		local _q = "SELECT "
		_q = _q .. db_columns
		_q = _q .. " FROM " .. YRPSQL.schema .. "." .. tostring(db_table)

		if db_where != nil then
			_q = _q .. " WHERE "
			_q = _q .. db_where
		end

		if db_extra then
			_q = _q .. " " .. db_extra
		end

		_q = _q .. ";"

		return SQL_QUERY(_q)
	end
end

function SQL_UPDATE(db_table, db_sets, db_where)
	--YRP.msg("db", "SQL_UPDATE(" .. tostring(db_table) .. ", " .. tostring(db_sets) .. ", " .. tostring(db_where) .. ")")
	if GetSQLMode() == 0 then
		local _q = "UPDATE "
		_q = _q .. db_table
		_q = _q .. " SET " .. db_sets

		if db_where != nil then
			_q = _q .. " WHERE "
			_q = _q .. db_where
		end

		_q = _q .. ";"

		local ret = SQL_QUERY(_q)

		if ret != nil then
			YRP.msg("error", GetSQLModeName() .. ": " .. "SQL_UPDATE: has failed! query: " .. tostring(_q) .. " result: " .. tostring(ret) .. " lastError: " .. sql_show_last_error())
		end

		return ret
	elseif GetSQLMode() == 1 then
		local _q = "UPDATE "
		_q = _q .. YRPSQL.schema .. "." .. db_table
		_q = _q .. " SET " .. db_sets

		if db_where != nil then
			_q = _q .. " WHERE "
			_q = _q .. db_where
		end

		_q = _q .. ";"

		return SQL_QUERY(_q)
	end
end

function SQL_INSERT_INTO(db_table, db_columns, db_values)
	YRP.msg("debug", "SQL_INSERT_INTO(" .. tostring(db_table) .. " | " .. tostring(db_columns) .. " | " .. tostring(db_values) .. ")")
	if GetSQLMode() == 0 then
		if SQL_TABLE_EXISTS(db_table) then
			local _q = "INSERT INTO "
			_q = _q .. db_table
			_q = _q .. " ("
			_q = _q .. db_columns
			_q = _q .. ") VALUES ("
			_q = _q .. db_values
			_q = _q .. ");"

			local _result = SQL_QUERY(_q)

			if _result != nil then
				YRP.msg("error", GetSQLModeName() .. ": " .. "SQL_INSERT_INTO: has failed! query: " .. tostring(_q) .. " result: " .. tostring(_result) .. " lastError: " .. sql_show_last_error())
			end

			return _result
		end
	elseif GetSQLMode() == 1 then
		if SQL_TABLE_EXISTS(db_table) then
			local _q = "INSERT INTO "
			_q = _q .. db_table
			_q = _q .. " ("
			_q = _q .. db_columns
			_q = _q .. ") VALUES ("
			_q = _q .. db_values
			_q = _q .. ");"
			local _result = SQL_QUERY(_q)

			if _result != nil then
				YRP.msg("error", GetSQLModeName() .. ": " .. "SQL_INSERT_INTO: has failed! query: " .. tostring(_q) .. " result: " .. tostring(_result) .. " lastError: " .. sql_show_last_error())
			end
			return _result

			--[[local newcols = string.Explode(",", db_columns)
			for i, v in pairs(newcols) do
				local col = string.Replace(v, " ", "")
				newcols[i] = col
			end

			-- new
			local newdb_values = {}
			--db_values = "1, 1, 1, 1"
			db_values = string.Replace(db_values, "', '", "','")
			db_values = string.Replace(db_values, "', ", "',")
			db_values = string.Replace(db_values, ", '", ",'")
			db_values = string.Replace(db_values, ", ", ",")
			local count = 1
			for i, v in pairs(newcols) do
				local val = ""
				local value = string.find(db_values, "'")
				local comma = string.find(db_values, ",")
				if value != nil and comma != nil then
					if value < comma then
						db_values = string.sub(db_values, value + 1)
						local _s, _e = string.find(db_values, "'")
						val = string.sub(db_values, 1, _e - 1)
						db_values = string.sub(db_values, _e + 1)
						val = "'" .. val .. "'"
					elseif value > comma then
						local _s, _e = string.find(db_values, ",")
						val = string.sub(db_values, 1, _e - 1)
						db_values = string.sub(db_values, _e + 1)
					else
						YRP.msg("note", "[SQL_INSERT_INTO] ELSE")
					end
				elseif value != nil then
					db_values = string.sub(db_values, value + 1)
					local _s, _e = string.find(db_values, "'")
					val = string.sub(db_values, 1, _e - 1)
					db_values = string.sub(db_values, _e + 1)
					val = "'" .. val .. "'"
				elseif comma != nil then
					local _s, _e = string.find(db_values, ",")
					val = string.sub(db_values, 1, _e - 1)
					db_values = string.sub(db_values, _e)
				else
					val = db_values
				end
				local _cs, _ce = string.find(db_values, ",")
				if _cs then
					db_values = string.sub(db_values, _cs + 1)
				end
				newdb_values[count] = val
				count = count + 1
			end

			db_columns = table.concat(newcols, ",")
			db_values = table.concat(newdb_values, ",")

			local _q = "INSERT INTO "
			_q = _q .. YRPSQL.schema .. "." .. db_table
			_q = _q .. " ("
			_q = _q .. db_columns
			_q = _q .. ") VALUES ("
			_q = _q .. db_values
			_q = _q .. ");"
			local _result = SQL_QUERY(_q)

			if _result != nil then
				YRP.msg("error", GetSQLModeName() .. ": " .. "SQL_INSERT_INTO: has failed! result: " .. tostring(_result) .. " lastError: " .. sql_show_last_error() .. " query: " .. tostring(_q))
			end

			return _result]]
		end
	end
end

function SQL_INSERT_INTO_DEFAULTVALUES(db_table)
	--YRP.msg("db", "SQL_INSERT_INTO_DEFAULTVALUES(" .. tostring(db_table) .. ")")
	if GetSQLMode() == 0 then
		if SQL_TABLE_EXISTS(db_table) then
			local _q = "INSERT INTO "
			_q = _q .. db_table
			_q = _q .. " DEFAULT VALUES;"
			local _result = SQL_QUERY(_q)

			if _result != nil then
				YRP.msg("error", GetSQLModeName() .. ": " .. "SQL_INSERT_INTO_DEFAULTVALUES failed! query: " .. tostring(_q) .. " result: " .. tostring(_result) .. " lastError: " .. sql_show_last_error())
			end

			return _result
		end
	elseif GetSQLMode() == 1 then
		if SQL_TABLE_EXISTS(db_table) then
			local _result = SQL_QUERY("INSERT INTO " .. db_table .. " VALUES();")

			if _result != nil then
				YRP.msg("error", GetSQLModeName() .. ": " .. "SQL_INSERT_INTO_DEFAULTVALUES failed! result: " .. tostring(_result) .. " lastError: " .. sql_show_last_error())
			end

			return _result
		end
	end
end

function SQL_DELETE_FROM(db_table, db_where)
	if GetSQLMode() == 0 then
		if SQL_TABLE_EXISTS(db_table) then
			local _q = "DELETE FROM "
			_q = _q .. db_table

			if db_where != nil then
				_q = _q .. " WHERE "
				_q = _q .. db_where
				_q = _q .. ";"
			end

			local _result = SQL_QUERY(_q)

			if _result != nil then
				YRP.msg("error", GetSQLModeName() .. ": " .. "SQL_DELETE_FROM: has failed! query: " .. tostring(_q) .. " result: " .. tostring(_result) .. " lastError: " .. sql_show_last_error())
			end
		end
	elseif GetSQLMode() == 1 then
		if SQL_TABLE_EXISTS(db_table) then
			local _q = "DELETE FROM "
			_q = _q .. db_table

			if db_where != nil then
				_q = _q .. " WHERE "
				_q = _q .. db_where
				_q = _q .. ";"
			end

			local _result = SQL_QUERY(_q)

			if _result != nil then
				YRP.msg("error", GetSQLModeName() .. ": " .. "SQL_DELETE_FROM: has failed! query: " .. tostring(_q) .. " result: " .. tostring(_result))
			end
		end
	end
end

function SQL_CHECK_IF_COLUMN_EXISTS(db_table, column_name)
	--YRP.msg("db", "SQL_CHECK_IF_COLUMN_EXISTS(" .. tostring(db_table) .. ", " .. tostring(column_name) .. ")")
	if GetSQLMode() == 0 then
		local _result = SQL_SELECT(db_table, column_name, nil)

		if _result == false then
			return false
		else
			return true
		end
	elseif GetSQLMode() == 1 then
		local _result = SQL_SELECT(db_table, column_name, nil)

		if _result == false then
			return false
		else
			return true
		end
	end
end

function SQL_HAS_COLUMN(db_table, column_name)
	local _r = SQL_QUERY("SHOW COLUMNS FROM " .. YRPSQL.schema .. "." .. tostring(db_table) .. " LIKE '" .. column_name .. "';")
	return _r
end

function SQL_ADD_COLUMN(db_table, column_name, datatype)
	if GetSQLMode() == 0 then
		local _q = "ALTER TABLE " .. db_table .. " ADD " .. column_name .. " " .. datatype .. ";"
		local _r = SQL_QUERY(_q)

		return _r
	elseif GetSQLMode() == 1 then
		if string.find(datatype, "TEXT") then
			datatype = string.Replace(datatype, "TEXT", "VARCHAR(255)")
		end
		local _r = nil
		if !SQL_HAS_COLUMN(db_table, column_name) then
			local _q = "ALTER TABLE " .. YRPSQL.schema .. "." .. tostring(db_table) .. " ADD " .. column_name .. " " .. datatype .. ";" -- FAST
			_r = SQL_QUERY(_q)
		else
			local _q = "ALTER TABLE " .. YRPSQL.schema .. "." .. tostring(db_table) .. " CHANGE " .. column_name .. " " .. column_name .. " " .. datatype .. ";" -- SLOW
			_r = SQL_QUERY(_q)
		end

		return _r
	end
end

if SERVER then
	local _sql_settings = sql.Query("SELECT * FROM yrp_sql")

	if wk(_sql_settings) then
		_sql_settings = _sql_settings[1]
		YRPSQL.schema = _sql_settings.string_database
		SetSQLMode(_sql_settings.int_mode)
	end

	if GetSQLMode() == 1 then
		YRP.msg("db", "Connect to MYSQL Database")

		-- MYSQL
		require("mysqloo")

		if (mysqloo.VERSION != "9" or !mysqloo.MINOR_VERSION or tonumber(mysqloo.MINOR_VERSION) < 1) then
			MsgC(Color(255, 0, 0), "You are using an outdated mysqloo version\n")
			MsgC(Color(255, 0, 0), "Download the latest mysqloo9 from here\n")
			MsgC(Color(86, 156, 214), "https://github.com/syl0r/MySQLOO/releases")
			YRPSQL.outdated = true
		end

		if !YRPSQL.outdated then
			YRPSQL.mysql_worked = false

			timer.Simple(10, function()
				if !YRPSQL.mysql_worked then
					YRP.msg("note", "Took to long to connect to mysql server, switch back to sqlite")
					SetSQLMode(0, true)
				end
			end)

			YRP.msg("db", "Connection info:")
			YRP.msg("db", "Hostname: " .. _sql_settings.string_host)
			YRP.msg("db", "Username: " .. _sql_settings.string_username)
			YRP.msg("note", "Password: " .. _sql_settings.string_password .. " (DON'T SHOW THIS TO OTHERS)")
			YRP.msg("db", "Database/Schema: " .. _sql_settings.string_database)
			YRP.msg("db", "Port: " .. _sql_settings.int_port)

			YRP.msg("db", "Setup MYSQL Connection-Table")
			YRPSQL.db = mysqloo.connect(_sql_settings.string_host, _sql_settings.string_username, _sql_settings.string_password, _sql_settings.string_database, tonumber(_sql_settings.int_port))

			YRPSQL.db.onConnected = function()
				YRP.msg("note", ">>> CONNECTED! <<<")
				YRPSQL.mysql_worked = true
				SetSQLMode(1)
			end

			--SQL_QUERY("SET @@global.sql_mode='MYSQL40'")
			YRPSQL.db.onConnectionFailed = function(db, serr)
				YRP.msg("note", ">>> CONNECTION failed (propably wrong connection info or server offline), changing to SQLITE!")
				YRP.msg("error", serr)
				SetSQLMode(0, true)
			end

			YRP.msg("db", ">>> Connect to MYSQL Server, if stuck => connection info is wrong or server offline! (default mysql port: 3306)")
			YRPSQL.db:connect()
			YRPSQL.db:wait()
		end
	end
end
YRP.msg("db", "Current SQL Mode: " .. GetSQLModeName())

function SQL_INIT_DATABASE(db_name)
	--YRP.msg("db", "SQL_INIT_DATABASE(" .. tostring(db_name) .. ")")

	if GetSQLMode() == 0 then
		if !SQL_TABLE_EXISTS(db_name) then
			local _result = SQL_CREATE_TABLE(db_name)

			if !SQL_TABLE_EXISTS(db_name) then
				YRP.msg("error", GetSQLModeName() .. ": " .. "CREATE TABLE " .. tostring(db_name) .. " (table not exists) lastError: " .. sql_show_last_error())
				retry_load_database(db_name)
			end
		end
	elseif GetSQLMode() == 1 then
		if !SQL_TABLE_EXISTS(db_name) then
			local _result = SQL_CREATE_TABLE(db_name)

			if !SQL_TABLE_EXISTS(db_name) then
				YRP.msg("error", GetSQLModeName() .. ": " .. "CREATE TABLE " .. tostring(db_name) .. " fail")
				sql_show_last_error()
				retry_load_database(db_name)
			end
		end
	end
end
