--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

SQL = SQL or {}
SQL.mode = "SQLITE"

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

function SQL.STR_IN(str)
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

function SQL.STR_OUT(str)
	local _res = str

	for k, sym in pairs(_db_dc) do
		local _pre = ""

		if k < 10 then
			_pre = "0"
		end

		_res = string.Replace(_res, "%" .. _pre .. k, sym)
	end

	return _res
end

function SQL.MODE()
	return SQL.mode
end

function SQL.GETMODE()
	return SQL.MODE()
end

function SQL.SETMODE(sqlmode, force)
	SQL.mode = tostring(sqlmode)
	if force then
		YRP.msg("db", "Update SQLMODE to: " .. SQL.mode)
		local _q = "UPDATE "
		_q = _q .. "yrp_sql"
		_q = _q .. " SET " .. "string_mode = " .. SQL.mode
		_q = _q .. " WHERE uniqueID = 1"
		_q = _q .. ";"
		sql.Query(_q)
	end
end

function SQL.TABLE_EXISTS(db_table)
	-- YRP.msg("db", "SQL_TABLE_EXISTS(" .. tostring(db_table) .. ")")
	if SQL.MODE() == "SQLITE" then
		local _result = SQL_SELECT(db_table, "*", nil)

		if _result == nil or istable(_result) then
			return true
		else
			YRP.msg("note", "Table [" .. tostring(db_table) .. "] not exists.")
			return false
		end
	elseif SQL.MODE() == "MYSQL" then
		local _r = SQL_SELECT(db_table, "*", nil)

		if _r == nil or istable(_r) then
			return true
		else
			YRP.msg("note", "Table [" .. tostring(db_table) .. "] not exists.")

			return false
		end
	end
end

function SQL.QUERY(query)
	query = tostring(query)
	if !string.find(query, ";") then
		YRP.msg("error", "[SQL.QUERY] " .. GetSQLModeName() .. ": " .. "Query has no ; [" .. query .. "]")
		return false
	end

	if SQL.MODE() == "SQLITE" then
		local _result = sql.Query(query)

		if _result == nil then
			--
		elseif _result == false then
			--
		else
			--
		end
		return _result
	elseif SQL.MODE() == "MYSQL" then
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

function SQL.ADD_COLUMN(table_name, column_name, datatype)
	--YRP.msg("db", "SQL.SELECT")
	if SQL.MODE() == "SQLITE" then
		local _q = "ALTER TABLE " .. table_name .. " ADD " .. column_name .. " " .. datatype .. ";"
		local _r = SQL_QUERY(_q)

		return _r
	else

	end
end

function SQL.SELECT(tab)
	--YRP.msg("db", "SQL.SELECT")
	if SQL.TABLE_EXISTS(tab.table) then
		local _q = "SELECT "
		for i, col in pairs(tab.cols) do
			col = SQL_STR_OUT(col)
			if i > 1 then
				_q = _q .. ", " .. col
			else
				_q = _q .. col
			end
		end
		_q = _q .. " FROM " .. tab.table

		if tab.where != nil then
			_q = _q .. " WHERE "
			_q = _q .. tab.where
		end

		if tab.manual != nil then
			_q = _q .. " "
			_q = _q .. tab.manual
		end

		_q = _q .. ";"

		local rettab = SQL.QUERY(_q)
		if istable(rettab) then
			for i, v in pairs(rettab) do
				for j, w in pairs(v) do
					w = SQL.STR_OUT(w)
					if isnumber(tonumber(w)) then
						rettab[i][j] = tonumber(w)
					end
				end
			end
		end
		return rettab
	else
		return false
	end
end

function SQL.INSERT_INTO(tab)
	--YRP.msg("db", "SQL.SELECT")
	if SQL.MODE() == "SQLITE" then
		if SQL.TABLE_EXISTS(tab.table) then
			local _q = "INSERT INTO "
			_q = _q .. tab.table
			_q = _q .. " ("
			local count = 0
			for i, col in pairs(tab.cols) do
				count = count + 1
				_q = _q .. i
				if count < table.Count(tab.cols) then
					_q = _q .. ", "
				end
			end
			_q = _q .. ") VALUES ("
			count = 0
			for i, col in pairs(tab.cols) do
				count = count + 1
				_q = _q .. "'" .. col .. "'"
				if count < table.Count(tab.cols) then
					_q = _q .. ", "
				end
			end
			_q = _q .. ");"

			local _result = SQL.QUERY(_q)
		end
	else
		YRP.msg("note", "MYSQL not available")
	end
end


function SQL.UPDATE(tab)
	--YRP.msg("db", "SQL.UPDATE")
	if SQL.MODE() == "SQLITE" then
		if SQL.TABLE_EXISTS(tab.table) then
			local _q = "UPDATE "
			_q = _q .. tab.table
			_q = _q .. " SET "

			local count = 0
			for col, val in pairs(tab.sets) do
				count = count + 1
				_q = _q .. col .. " = '" .. val .. "'"
				if count < table.Count(tab.sets) then
					_q = _q .. ", "
				end
			end

			if tab.where != nil then
				_q = _q .. " WHERE "
				_q = _q .. tab.where
			end

			_q = _q .. ";"

			local _result = SQL.QUERY(_q)
		end
	else
		YRP.msg("note", "MYSQL not available")
	end
end

function SQL.DELETE_FROM(tab)
	--YRP.msg("db", "SQL.UPDATE")
	if SQL.MODE() == "SQLITE" then
		if SQL.TABLE_EXISTS(tab.table) then

			local _q = "DELETE FROM "
			_q = _q .. tab.table
			_q = _q .. " WHERE "
			_q = _q .. tab.where
			_q = _q .. " ;"

			local _result = SQL.QUERY(_q)
		end
	else
		YRP.msg("note", "MYSQL not available")
	end
end
