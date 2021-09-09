--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

local yrp_tutorials = {}

local DATABASE_NAME = "yrp_tutorials"

function done_tutorial(str, time)
	if tobool(get_tutorial(str)) then
		if time == nil then
			time = 0
		end
		timer.Simple(time, function()
			yrp_tutorials[str] = 0
			SQL_UPDATE(DATABASE_NAME, {[str] = 0}, "uniqueID = 1")
		end)
	end
end

function reset_tutorial(str)
	yrp_tutorials[str] = 1
	SQL_UPDATE(DATABASE_NAME, {[str] = 1}, "uniqueID = 1")
end

function get_tutorial(str)
	return tobool(yrp_tutorials[str])
end

--db_drop_table(DATABASE_NAME)
function check_yrp_tutorials()
	SQL_INIT_DATABASE(DATABASE_NAME)

	SQL_ADD_COLUMN(DATABASE_NAME, "tut_all", "INT DEFAULT 1")
	SQL_ADD_COLUMN(DATABASE_NAME, "tut_cs", "INT DEFAULT 1")
	SQL_ADD_COLUMN(DATABASE_NAME, "tut_mr", "INT DEFAULT 1")
	SQL_ADD_COLUMN(DATABASE_NAME, "tut_mb", "INT DEFAULT 1")
	SQL_ADD_COLUMN(DATABASE_NAME, "tut_ms", "INT DEFAULT 1")
	SQL_ADD_COLUMN(DATABASE_NAME, "tut_tmo", "INT DEFAULT 1")
	SQL_ADD_COLUMN(DATABASE_NAME, "tut_vo", "INT DEFAULT 1")
	SQL_ADD_COLUMN(DATABASE_NAME, "tut_vi", "INT DEFAULT 1")
	SQL_ADD_COLUMN(DATABASE_NAME, "tut_tma", "INT DEFAULT 1")
	SQL_ADD_COLUMN(DATABASE_NAME, "tut_mi", "INT DEFAULT 1")
	SQL_ADD_COLUMN(DATABASE_NAME, "tut_sn", "INT DEFAULT 1")
	SQL_ADD_COLUMN(DATABASE_NAME, "tut_sp", "INT DEFAULT 1")
	SQL_ADD_COLUMN(DATABASE_NAME, "tut_feedback", "INT DEFAULT 1")
	SQL_ADD_COLUMN(DATABASE_NAME, "tut_welcome", "INT DEFAULT 1")
	SQL_ADD_COLUMN(DATABASE_NAME, "tut_hudhelp", "INT DEFAULT 1")
	SQL_ADD_COLUMN(DATABASE_NAME, "tut_f1info", "INT DEFAULT 1")

	local _tmp = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = 1")
	if _tmp == nil then
		local _result = SQL_INSERT_INTO_DEFAULTVALUES(DATABASE_NAME)
		_tmp = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = 1")
		if _tmp == nil or _tmp == false then
			YRP.msg("error", DATABASE_NAME .. " has no entries.")
		end
	end

	local _tuts = SQL_SELECT(DATABASE_NAME, "*", nil)
	if _tuts != nil and _tuts != false then
		yrp_tutorials = _tuts[1]
	end
end
check_yrp_tutorials()
