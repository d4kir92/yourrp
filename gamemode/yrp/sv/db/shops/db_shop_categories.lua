--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local _db_name = "yrp_shop_categories"

SQL_ADD_COLUMN(_db_name, "name", "TEXT DEFAULT 'UNNAMED'")
SQL_ADD_COLUMN(_db_name, "shopID", "INT DEFAULT -1")

--db_drop_table(_db_name)
--db_is_empty(_db_name)

util.AddNetworkString("get_shop_categories")

function send_categories(ply, uid)
	local _cats = SQL_SELECT(_db_name, "*", "shopID = " .. uid)
	local _nw = _cats
	if _nw == nil then
		_nw = {}
	end
	net.Start("get_shop_categories")
		net.WriteTable(_nw)
	net.Send(ply)
end

net.Receive("get_shop_categories", function(len, ply)
	local _shopID = net.ReadString()
	send_categories(ply, _shopID)
end)

util.AddNetworkString("category_add")

net.Receive("category_add", function(len, ply)
	local _shopid = net.ReadString()
	local _new = SQL_INSERT_INTO(_db_name, "shopID", _shopid)
	printGM("db", "category_add: " .. _shopid)

	send_categories(ply, _shopid)
end)

util.AddNetworkString("category_rem")

net.Receive("category_rem", function(len, ply)
	local _uid = net.ReadString()
	local _shopid = net.ReadString()
	local _new = SQL_DELETE_FROM(_db_name, "uniqueID = " .. _uid)
	printGM("db", "category_rem: " .. _uid)

	send_categories(ply, _shopid)
end)

util.AddNetworkString("category_edit_name")

net.Receive("category_edit_name", function(len, ply)
	local _uid = net.ReadString()
	local _new_name = net.ReadString()
	local _shopid = net.ReadString()
	local _new = SQL_UPDATE(_db_name, "name = '" .. SQL_STR_IN(_new_name) .. "'", "uniqueID = " .. _uid)
	printGM("db", "category_edit_name: " .. db_worked(_new))
end)

util.AddNetworkString("yrp_shop_get_categories")

net.Receive("yrp_shop_get_categories", function(len, ply)
	local _uid = net.ReadString()
	local _cats = SQL_SELECT(_db_name, "*", "shopID = '" .. _uid .. "'")
	local _nw = {}
	if _cats != nil then
		_nw = _cats
	end

	net.Start("yrp_shop_get_categories")
		net.WriteString(_uid)
		net.WriteTable(_nw)
	net.Send(ply)
end)
