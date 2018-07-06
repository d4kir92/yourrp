--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function disk_full(error)
	if string.find(error, "database or disk is full") then
		if SERVER then
			PrintMessage(HUD_PRINTCENTER, "database or disk is full, please make more space!")
			net.Start("yrp_noti")
			net.WriteString("database_full_server")
			net.WriteString("")
			net.Broadcast()
		elseif CLIENT then
			local ply = LocalPlayer()
			ply:PrintMessage(HUD_PRINTTALK, "database or disk is full, please make more space!")
			notification.AddLegacy("[YourRP] Database or disk is full, please make more space!", NOTIFY_ERROR, 40)
			printGM("error", GetSQLModeName() .. ": " .. tostring(ply:SteamID()) .. " (database or disk is full)")
		end
	end
end

function sql_show_last_error()
	--printGM( "db", "sql_show_last_error()" )
	local _last_error = tostring(sql.LastError()) or ""

	if SERVER then
		PrintMessage(HUD_PRINTCENTER, "[YourRP|DATABASE] SERVER-DATABASE:")
		PrintMessage(HUD_PRINTCENTER, _last_error)
	elseif CLIENT then
		local ply = LocalPlayer()

		if ea(ply) then
			ply:PrintMessage(HUD_PRINTTALK, "[YourRP|DATABASE] CLIENT-DATABASE:")
			ply:PrintMessage(HUD_PRINTTALK, _last_error)
		end
	end

	timer.Simple(3, function()
		disk_full(_last_error)
	end)

	return _last_error
end

local _db_dc = {}
table.insert(_db_dc, " ")
table.insert(_db_dc, "'")
table.insert(_db_dc, "´")
table.insert(_db_dc, "`")
table.insert(_db_dc, "#")
table.insert(_db_dc, "*")
table.insert(_db_dc, "+")
table.insert(_db_dc, "-")
table.insert(_db_dc, "(")
table.insert(_db_dc, ")")
table.insert(_db_dc, "[")
table.insert(_db_dc, "]")
table.insert(_db_dc, "{")
table.insert(_db_dc, "}")
table.insert(_db_dc, "^")
table.insert(_db_dc, "°")
table.insert(_db_dc, "!")
table.insert(_db_dc, "§")
table.insert(_db_dc, "$")
table.insert(_db_dc, "&")
table.insert(_db_dc, "/")
table.insert(_db_dc, "=")
table.insert(_db_dc, "\"")
table.insert(_db_dc, "?")
table.insert(_db_dc, ".")
table.insert(_db_dc, ",")
table.insert(_db_dc, ";")
table.insert(_db_dc, "<")
table.insert(_db_dc, ">")
table.insert(_db_dc, "ü")
table.insert(_db_dc, "ö")
table.insert(_db_dc, "ä")
table.insert(_db_dc, "Ü")
table.insert(_db_dc, "Ö")
table.insert(_db_dc, "Ä")

function SQL_STR_IN(str)
	local _res = tostring(str)

	for k, sym in pairs(_db_dc) do
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

	for k, sym in pairs(_db_dc) do
		local _pre = ""

		if k < 10 then
			_pre = "0"
		end

		_res = string.Replace(_res, "%" .. _pre .. k, sym)
	end

	_res = string.Replace(_res, "%", "'")

	return _res
end

function db_int(int)
	local _int = tonumber(int)

	if isnumber(_int) then
		return _int
	else
		printGM("error", GetSQLModeName() .. ": " .. tostring(int) .. " is not a number! return -1")

		return -1
	end
end

function db_drop_table(db_table)
	local _result = sql.Query("DROP TABLE " .. db_table)

	if _result ~= nil then
		printGM("error", GetSQLModeName() .. ": " .. "db_drop_table " .. tostring(db_table) .. " failed! ( result: " .. tostring(_result) .. " )")
		sql_show_last_error()
	end
end

function db_sql_str(str)
	if isstring(str) then
		local _newString = sql.SQLStr(str, true)
		_newString = string.Replace(_newString, "\"", "´´")
		_newString = string.Replace(_newString, "'", "´")

		return _newString
	else
		printGM("error", GetSQLModeName() .. ": " .. "db_sql_str: (" .. tostring(str) .. ") is not a string.")
	end
end

function SQL_STR_IN(str)
	if isstring(str) then
		local _newString = sql.SQLStr(str, true)
		_newString = string.Replace(_newString, "\"", "´´")
		_newString = string.Replace(_newString, "'", "´")
		_newString = string.Replace(_newString, "-", "_")

		return _newString
	else
		printGM("error", GetSQLModeName() .. ": " .. "db_in_str: (" .. tostring(str) .. ") is not a string.")
	end
end

function retry_load_database(db_name)
	printGM("error", GetSQLModeName() .. ": " .. "retry_load_database " .. tostring(db_name))
	--SQL_INIT_DATABASE( db_name )
end

local _show_db_if_not_empty = false

function db_is_empty(db_name)
	local _tmp = SQL_SELECT(db_name, "*", nil)

	if worked(_tmp, db_name .. " is empty!") then
		if _show_db_if_not_empty then
			hr_pre()
			printGM("db", db_name)
			printTab(_tmp, db_name)
			hr_pos()
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
end

function SetSQLMode(sqlmode, force)
	YRPSQL.int_mode = tonumber(sqlmode)
	if force then
		printGM("db", "Update SQLMODE to: " .. YRPSQL.int_mode)
		local _q = "UPDATE "
		_q = _q .. "yrp_sql"
		_q = _q .. " SET " .. "int_mode = " .. YRPSQL.int_mode
		_q = _q .. " WHERE uniqueID = 1"
		_q = _q .. ";"
		sql.Query(_q)
	end
end

function SQL_TABLE_EXISTS(db_table)
	-- printGM( "db", "SQL_TABLE_EXISTS( " .. tostring( db_table ) .. " )" )
	if GetSQLMode() == 0 then
		if sql.TableExists(db_table) then
			return true
		else
			printGM("note", "Table [" .. tostring(db_table) .. "] not exists.")

			return false
		end
	elseif GetSQLMode() == 1 then
		local _r = SQL_SELECT(db_table, "*", nil)

		if _r == nil or istable(_r) then
			return true
		else
			printGM("note", "Table [" .. tostring(db_table) .. "] not exists.")

			return false
		end
	end
end

function SQL_QUERY(query)
	query = tostring(query)

	--printGM( "db", "SQL_QUERY( " .. tostring( query ) .. " )" )
	if not string.find(query, ";") then
		printGM("error", GetSQLModeName() .. ": " .. "Query has no ; [" .. query .. "]")

		return false
	end

	if GetSQLMode() == 0 then
		local _result = sql.Query(query)

		if _result == nil then
			return _result
		elseif _result == false then
			return _result
		else
			--printGM( "db", "ELSE" )
			return _result
		end
	elseif GetSQLMode() == 1 then
		if YRPSQL.db ~= nil then
			local que = YRPSQL.db:query(query)

			que.onError = function(q, e)
				if string.find(e, "Unknown column") == nil and string.find(e, "doesn't exist") == nil then
					printGM("error", GetSQLModeName() .. ": " .. "SQL_QUERY - ERROR: " .. tostring(e))
					printGM("error", GetSQLModeName() .. ": " .. tostring(query))
					q:error()
				end
			end

			que:start()
			que:wait(true)
			local _test = que:getData()

			if istable(_test) then
				if #_test == 0 then return nil end --printGM( "db", "SQL_QUERY TABLE EMPTY 1" )

				return _test
			elseif _test == nil then
				--printGM( "db", "SQL_QUERY TABLE EMPTY 2" )
				return false
			else
				printGM("db", "SQL_QUERY TABLE MISSING (" .. tostring(_test) .. ")")

				return false
			end
		else
			printGM("db", "CURRENTLY NOT CONNECTED TO MYSQL SERVER")
		end
	end
end

function SQL_DROP_TABLE(db_table)
	local _result = SQL_QUERY("DROP TABLE " .. db_table .. ";")

	if _result ~= nil then
		printGM("error", GetSQLModeName() .. ": " .. "SQL_DROP_TABLE " .. tostring(db_table) .. " failed! ( result: " .. tostring(_result) .. " )")
		sql_show_last_error()
	else
		printGM("db", "DROPPED " .. tostring(db_table) .. " TABLE")
	end
end

function SQL_CREATE_TABLE(db_table)
	printGM("db", "SQL_CREATE_TABLE( " .. tostring(db_table) .. " )")

	if GetSQLMode() == 0 then
		local _q = "CREATE TABLE "
		_q = _q .. db_table .. " ( "
		_q = _q .. "uniqueID		INTEGER				 PRIMARY KEY autoincrement"
		_q = _q .. " )"
		_q = _q .. ";"
		local _result = SQL_QUERY(_q)

		return _result
	elseif GetSQLMode() == 1 then
		local _q = "CREATE TABLE "
		_q = _q .. YRPSQL.schema .. "." .. db_table .. " ( "
		_q = _q .. "uniqueID		INTEGER				 PRIMARY KEY AUTO_INCREMENT"
		_q = _q .. " )"
		_q = _q .. ";"
		local _result = SQL_QUERY(_q)

		return _result
	end
end

function SQL_SELECT(db_table, db_columns, db_where)
	--printGM( "db", "SQL_SELECT( " .. tostring( db_table ) .. ", " .. tostring( db_columns ) .. ", " .. tostring( db_where ) .. " )" )
	if GetSQLMode() == 0 then
		local _q = "SELECT "
		_q = _q .. db_columns
		_q = _q .. " FROM " .. tostring(db_table)

		if db_where ~= nil then
			_q = _q .. " WHERE "
			_q = _q .. db_where
		end

		_q = _q .. ";"

		return SQL_QUERY(_q)
	elseif GetSQLMode() == 1 then
		local _q = "SELECT "
		_q = _q .. db_columns
		_q = _q .. " FROM " .. YRPSQL.schema .. "." .. tostring(db_table)

		if db_where ~= nil then
			_q = _q .. " WHERE "
			_q = _q .. db_where
		end

		_q = _q .. ";"

		return SQL_QUERY(_q)
	end
end

function SQL_UPDATE(db_table, db_sets, db_where)
	--printGM( "db", "SQL_UPDATE( " .. tostring( db_table ) .. ", " .. tostring( db_sets ) .. ", " .. tostring( db_where ) .. " )" )
	if GetSQLMode() == 0 then
		local _q = "UPDATE "
		_q = _q .. db_table
		_q = _q .. " SET " .. db_sets

		if db_where ~= nil then
			_q = _q .. " WHERE "
			_q = _q .. db_where
		end

		_q = _q .. ";"
		return SQL_QUERY(_q)
	elseif GetSQLMode() == 1 then
		local _q = "UPDATE "
		_q = _q .. YRPSQL.schema .. "." .. db_table
		_q = _q .. " SET " .. db_sets

		if db_where ~= nil then
			_q = _q .. " WHERE "
			_q = _q .. db_where
		end

		_q = _q .. ";"

		return SQL_QUERY(_q)
	end
end

function SQL_INSERT_INTO_DEFAULTVALUES(db_table)
	--printGM( "db", "SQL_INSERT_INTO_DEFAULTVALUES( " .. tostring( db_table ) .. " )" )
	if GetSQLMode() == 0 then
		if SQL_TABLE_EXISTS(db_table) then
			local _q = "INSERT INTO "
			_q = _q .. db_table
			_q = _q .. " DEFAULT VALUES;"
			local _result = SQL_QUERY(_q)

			if _result ~= nil then
				printGM("error", GetSQLModeName() .. ": " .. "SQL_INSERT_INTO_DEFAULTVALUES failed! query: " .. tostring(_q) .. " result: " .. tostring(_result) .. " lastError: " .. sql_show_last_error())
			end

			return _result
		end
	elseif GetSQLMode() == 1 then
		if SQL_TABLE_EXISTS(db_table) then
			local _q = "INSERT INTO "
			_q = _q .. "'" .. YRPSQL.schema .. "." .. db_table .. "'"
			local _cols = {}
			local _vals = {}

			for i, col in pairs(YRPSQL[db_table]) do
				table.insert(_cols, i)
				table.insert(_vals, col)
			end

			_cols = string.Implode(",", _cols)
			_vals = string.Implode(",", _vals)
			local _result = SQL_INSERT_INTO(db_table, _cols, _vals)

			if _result ~= nil then
				printGM("error", GetSQLModeName() .. ": " .. "SQL_INSERT_INTO_DEFAULTVALUES failed! query: " .. tostring(_q) .. " result: " .. tostring(_result))
			end

			return _result
		end
	end
end

function SQL_INSERT_INTO(db_table, db_columns, db_values)
	printGM( "db", "SQL_INSERT_INTO( " .. tostring( db_table ) .. " | " .. tostring( db_columns ) .. " | " .. tostring( db_values ) .. " )" )
	if GetSQLMode() == 0 then
		if SQL_TABLE_EXISTS(db_table) then
			local _q = "INSERT INTO "
			_q = _q .. db_table
			_q = _q .. " ( "
			_q = _q .. db_columns
			_q = _q .. " ) VALUES ( "
			_q = _q .. db_values
			_q = _q .. " );"
			local _result = SQL_QUERY(_q)

			if _result ~= nil then
				printGM("error", GetSQLModeName() .. ": " .. "SQL_INSERT_INTO: has failed! query: " .. tostring(_q) .. " result: " .. tostring(_result) .. " lastError: " .. sql_show_last_error())
			end

			return _result
		end
	elseif GetSQLMode() == 1 then
		if SQL_TABLE_EXISTS(db_table) then
			local _v = string.Explode(", ", db_values)
			local _ins = {}

			for i, col in pairs(string.Explode(", ", db_columns)) do
				_ins[col] = _v[i]
			end

			local _tmp = YRPSQL[db_table]
			db_columns = ""
			db_values = ""
			local _count = 0

			for col, value in pairs(_tmp) do
				for c, v in pairs(_ins) do
					if c == col then
						_tmp[col] = v
						break
					end
				end

				if db_columns ~= "" then
					db_columns = db_columns .. "," .. col
					db_values = db_values .. "," .. _tmp[col]
				else
					db_columns = col
					db_values = _tmp[col]
				end
			end

			local _q = "INSERT INTO "
			_q = _q .. YRPSQL.schema .. "." .. db_table
			_q = _q .. " ( "
			_q = _q .. db_columns
			_q = _q .. " ) VALUES ( "
			_q = _q .. db_values
			_q = _q .. " );"
			local _result = SQL_QUERY(_q)

			if _result ~= nil then
				printGM("error", GetSQLModeName() .. ": " .. "SQL_INSERT_INTO: has failed! query: " .. tostring(_q) .. " result: " .. tostring(_result))
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

			if db_where ~= nil then
				_q = _q .. " WHERE "
				_q = _q .. db_where
				_q = _q .. " ;"
			end

			local _result = SQL_QUERY(_q)

			if _result ~= nil then
				printGM("error", GetSQLModeName() .. ": " .. "SQL_DELETE_FROM: has failed! query: " .. tostring(_q) .. " result: " .. tostring(_result) .. " lastError: " .. sql_show_last_error())
			end
		end
	elseif GetSQLMode() == 1 then
		if SQL_TABLE_EXISTS(db_table) then
			local _q = "DELETE FROM "
			_q = _q .. db_table

			if db_where ~= nil then
				_q = _q .. " WHERE "
				_q = _q .. db_where
				_q = _q .. " );"
			end

			local _result = SQL_QUERY(_q)

			if _result ~= nil then
				printGM("error", GetSQLModeName() .. ": " .. "SQL_DELETE_FROM: has failed! query: " .. tostring(_q) .. " result: " .. tostring(_result))
			end
		end
	end
end

function SQL_CHECK_IF_COLUMN_EXISTS(db_name, column_name)
	--printGM( "db", "SQL_CHECK_IF_COLUMN_EXISTS( " .. tostring( db_name ) .. ", " .. tostring( column_name ) .. " )" )
	if GetSQLMode() == 0 then
		local _result = SQL_SELECT(db_name, column_name, nil)

		if _result == false then
			return false
		else
			return true
		end
	elseif GetSQLMode() == 1 then
		local _result = SQL_SELECT(db_name, column_name, nil)

		if _result == false then
			return false
		else
			return true
		end
	end
end

function SQL_ADD_COLUMN(table_name, column_name, datatype)
	--printGM( "db", "SQL_ADD_COLUMN( " .. tostring( table_name ) .. ", " .. tostring( column_name ) .. ", " .. tostring( datatype ) .. " )" )
	local _result = SQL_CHECK_IF_COLUMN_EXISTS(table_name, column_name)

	if GetSQLMode() == 0 then
		if not _result then
			local _q = "ALTER TABLE " .. table_name .. " ADD " .. column_name .. " " .. datatype .. ";"
			local _r = SQL_QUERY(_q)

			if _r ~= nil then
				printGM("error", GetSQLModeName() .. ": " .. "SQL_ADD_COLUMN failed! query: " .. tostring(_q) .. " result: " .. tostring(_result) .. " lastError: " .. sql_show_last_error())
			end

			return _r
		end
	elseif GetSQLMode() == 1 then
		--[[ MYSQL DEFAULT VALUES FIX ]]
		--
		if YRPSQL[table_name] == nil then
			YRPSQL[table_name] = {}
		end

		if YRPSQL[table_name][column_name] == nil then
			local _start, _end = string.find(datatype, "DEFAULT ", 1)

			if _end ~= nil then
				local _default_value = string.sub(datatype, _end + 1)
				YRPSQL[table_name][column_name] = _default_value
			elseif string.find(datatype, "TEXT") ~= nil then
				YRPSQL[table_name][column_name] = "' '"
			elseif string.find(datatype, "INT") ~= nil then
				YRPSQL[table_name][column_name] = "1"
			end
		end

		if not _result then
			if string.find(datatype, "TEXT") then
				datatype = "TEXT"
			end

			local _q = "ALTER TABLE " .. YRPSQL.schema .. "." .. table_name .. " ADD " .. column_name .. " " .. datatype .. ";"
			local _r = SQL_QUERY(_q)

			if _r ~= nil then
				printGM("error", GetSQLModeName() .. ": " .. "SQL_ADD_COLUMN failed! query: " .. tostring(_q) .. " result: " .. tostring(_r))
			end

			return _r
		end
	end
end

if SERVER then
	printGM("db", "Connect to Database")
	local _sql_settings = sql.Query("SELECT * FROM yrp_sql")

	if wk(_sql_settings) then
		_sql_settings = _sql_settings[1]
		YRPSQL.schema = _sql_settings.string_database
		YRPSQL.int_mode = tonumber(_sql_settings.int_mode)
	end

	if GetSQLMode() == 1 then
		-- MYSQL
		require("mysqloo")

		if (mysqloo.VERSION ~= "9" or not mysqloo.MINOR_VERSION or tonumber(mysqloo.MINOR_VERSION) < 1) then
			MsgC(Color(255, 0, 0), "You are using an outdated mysqloo version\n")
			MsgC(Color(255, 0, 0), "Download the latest mysqloo9 from here\n")
			MsgC(Color(86, 156, 214), "https://github.com/syl0r/MySQLOO/releases")
			YRPSQL.outdated = true
		end
		if not YRPSQL.outdated then
			YRPSQL.mysql_worked = false

			timer.Simple( 10, function()
				if not YRPSQL.mysql_worked then
					printGM("note", "Took to long to connect to mysql server, switch back to sqlite")
					SetSQLMode(0, true)
				end
			end)

			printGM("db", "Connection info:")
			printGM("db", "Hostname: " .. _sql_settings.string_host)
			printGM("db", "Username: " .. _sql_settings.string_username)
			printGM("note", "Password: " .. _sql_settings.string_password .. " (DON'T SHOW THIS TO OTHERS)")
			printGM("db", "Database/Schema: " .. _sql_settings.string_database)
			printGM("db", "Port: " .. _sql_settings.int_port)

			printGM("db", "Setup MYSQL Connection-Table")
			YRPSQL.db = mysqloo.connect(_sql_settings.string_host, _sql_settings.string_username, _sql_settings.string_password, _sql_settings.string_database, tonumber(_sql_settings.int_port))

			YRPSQL.db.onConnected = function()
				printGM("note", "CONNECTED!")
				YRPSQL.mysql_worked = true
				SetSQLMode(1)
			end

			--SQL_QUERY( "SET @@global.sql_mode='MYSQL40'" )
			YRPSQL.db.onConnectionFailed = function()
				printGM("note", "CONNECTION failed (propably wrong connection info or server offline), changing to SQLITE!")
				SetSQLMode(0, true)
			end

			printGM("db", "Connect to MYSQL Server, if stuck => connection info is wrong or server offline! (default mysql port: 3306)")
			YRPSQL.db:connect()
			YRPSQL.db:wait()
		end
	end
end
printGM("db", "Current SQL Mode: " .. GetSQLModeName())

function SQL_INIT_DATABASE(db_name)
	printGM("db", "SQL_INIT_DATABASE( " .. tostring(db_name) .. " )")

	if GetSQLMode() == 0 then
		if not SQL_TABLE_EXISTS(db_name) then
			printGM( "note", tostring( db_name ) .. " not exists" )
			local _result = SQL_CREATE_TABLE(db_name)

			if _result ~= nil then
				printGM("error", GetSQLModeName() .. ": " .. "SQL_INIT_DATABASE failed! result: " .. tostring(_result) .. " lastError: " .. sql_show_last_error())
			end

			if not sql.TableExists(tostring(db_name)) then
				printGM("error", GetSQLModeName() .. ": " .. "CREATE TABLE " .. tostring(db_name) .. " fail")
				sql_show_last_error()
				retry_load_database(db_name)
			end
		else
			printGM("db", "Table " .. db_name .. " already exists.")
		end
	elseif GetSQLMode() == 1 then
		if not SQL_TABLE_EXISTS(db_name) then
			printGM( "note", tostring( db_name ) .. " not exists" )
			local _result = SQL_CREATE_TABLE(db_name)

			if _result ~= nil then
				printGM("error", GetSQLModeName() .. ": " .. "SQL_INIT_DATABASE failed! result: " .. tostring(_result) .. " lastError: " .. sql_show_last_error())
			end

			if not sql.TableExists(tostring(db_name)) then
				printGM("error", GetSQLModeName() .. ": " .. "CREATE TABLE " .. tostring(db_name) .. " fail")
				sql_show_last_error()
				retry_load_database(db_name)
			end
		else
			printGM("db", "Table " .. db_name .. " already exists.")
		end
	end
end
