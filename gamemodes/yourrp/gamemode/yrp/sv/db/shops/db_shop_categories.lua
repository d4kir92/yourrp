--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_shop_categories"

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "name", "TEXT DEFAULT 'UNNAMED'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "shopID", "INT DEFAULT -1" )

util.AddNetworkString( "get_shop_categories" )

function send_categories(ply, uid)
	local _cats = YRP_SQL_SELECT(DATABASE_NAME, "*", "shopID = " .. uid)
	local _nw = _cats
	if _nw == nil then
		_nw = {}
	end
	net.Start( "get_shop_categories" )
		net.WriteTable(_nw)
	net.Send(ply)
end

net.Receive( "get_shop_categories", function(len, ply)
	local _shopID = net.ReadString()
	send_categories(ply, _shopID)
end)

util.AddNetworkString( "category_add" )

net.Receive( "category_add", function(len, ply)
	local _shopid = net.ReadString()
	local _new = YRP_SQL_INSERT_INTO(DATABASE_NAME, "shopID", _shopid)
	YRP.msg( "db", "category_add: " .. _shopid)

	send_categories(ply, _shopid)
end)

util.AddNetworkString( "category_rem" )

net.Receive( "category_rem", function(len, ply)
	local _uid = net.ReadString()
	local _shopid = net.ReadString()
	local _new = YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = " .. _uid)
	YRP.msg( "db", "category_rem: " .. _uid)

	send_categories(ply, _shopid)
end)

util.AddNetworkString( "category_edit_name" )

net.Receive( "category_edit_name", function(len, ply)
	local _uid = net.ReadString()
	local _new_name = net.ReadString()
	local _shopid = net.ReadString()
	local _new = YRP_SQL_UPDATE(DATABASE_NAME, {["name"] = _new_name}, "uniqueID = " .. _uid)
	YRP.msg( "db", "category_edit_name: " .. db_worked(_new) )
end)

util.AddNetworkString( "yrp_shop_get_categories" )

net.Receive( "yrp_shop_get_categories", function(len, ply)
	local _uid = net.ReadString()
	local _cats = YRP_SQL_SELECT(DATABASE_NAME, "*", "shopID = '" .. _uid .. "'" )
	local _nw = {}
	if _cats != nil then
		_nw = _cats
	end

	net.Start( "yrp_shop_get_categories" )
		net.WriteString(_uid)
		net.WriteTable(_nw)
	net.Send(ply)
end)
