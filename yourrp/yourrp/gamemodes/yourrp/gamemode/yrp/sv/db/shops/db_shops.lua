--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
local DATABASE_NAME = "yrp_shops"
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "name", "TEXT DEFAULT 'UNNAMED'")
util.AddNetworkString("nws_yrp_get_shops")
function send_shops(ply)
	local _all = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
	local _nm = _all
	if _nm == nil or _nm == false then
		_nm = {}
	end

	net.Start("nws_yrp_get_shops")
	net.WriteTable(_nm)
	net.Send(ply)
end

net.Receive(
	"nws_yrp_get_shops",
	function(len, ply)
		if ply:CanAccess("bool_shops") then
			send_shops(ply)
		end
	end
)

util.AddNetworkString("nws_yrp_shop_add")
net.Receive(
	"nws_yrp_shop_add",
	function(len, ply)
		local _new = YRP_SQL_INSERT_INTO(DATABASE_NAME, "name", "'new shop'")
		YRP.msg("db", "shop_add: " .. db_WORKED(_new))
		send_shops(ply)
	end
)

util.AddNetworkString("nws_yrp_shop_rem")
net.Receive(
	"nws_yrp_shop_rem",
	function(len, ply)
		local _uid = net.ReadString()
		local _new = YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = " .. _uid)
		YRP.msg("db", "shop_rem: " .. tostring(_uid))
		send_shops(ply)
	end
)

util.AddNetworkString("nws_yrp_shop_edit_name")
net.Receive(
	"nws_yrp_shop_edit_name",
	function(len, ply)
		local _uid = net.ReadString()
		local _new_name = net.ReadString()
		local _new = YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["name"] = _new_name
			}, "uniqueID = " .. _uid
		)

		YRP.msg("db", "shop_edit_name: " .. tostring(_uid))
	end
)

function HasShopPermanent(tab)
	local _cats = YRP_SQL_SELECT("yrp_shop_categories", "*", "shopID = '" .. tab .. "'")
	local _nw = {}
	if _cats ~= nil then
		_nw = _cats
	end

	for i, cat in pairs(_nw) do
		local _s_items = YRP_SQL_SELECT("yrp_shop_items", "*", "categoryID = " .. cat.uniqueID)
		if IsNotNilAndNotFalse(_s_items) then
			for j, item in pairs(_s_items) do
				if tonumber(item.permanent) == 1 then return true end --or item.permanent == "1" then
			end
		end
	end

	return false
end

util.AddNetworkString("nws_yrp_shop_get_tabs")
function YRPOpenBuyMenu(ply, uid)
	--YRP.msg( "note", "OpenBuyMenu | ply: " .. tostring(ply:RPName() ) .. " | uid: " .. tostring(uid) )
	local _dealer = YRP_SQL_SELECT("yrp_dealers", "*", "uniqueID = '" .. uid .. "'")
	if _dealer ~= nil then
		_dealer = _dealer[1]
		local _tabs = string.Explode(",", _dealer.tabs)
		local _nw_tabs = {}
		if _tabs[1] ~= "" then
			for i, tab in pairs(_tabs) do
				local _tab = YRP_SQL_SELECT("yrp_shops", "*", "uniqueID = '" .. tab .. "'")
				if _tab ~= false and _tab ~= nil then
					_tab = _tab[1]
					_tab.haspermanent = HasShopPermanent(tab)
					table.insert(_nw_tabs, _tab)
				end
			end
		end

		net.Start("nws_yrp_shop_get_tabs")
		net.WriteTable(_dealer)
		net.WriteTable(_nw_tabs)
		net.Send(ply)
	else
		YRP.msg("note", "Dealer not found")
	end
end

net.Receive(
	"nws_yrp_shop_get_tabs",
	function(len, ply)
		local _uid = net.ReadString()
		YRPOpenBuyMenu(ply, _uid)
	end
)

util.AddNetworkString("nws_yrp_shop_get_all_tabs")
net.Receive(
	"nws_yrp_shop_get_all_tabs",
	function(len, ply)
		local _tabs = YRP_SQL_SELECT(DATABASE_NAME, "name, uniqueID", nil)
		local _nw = {}
		if _tabs ~= nil then
			_nw = _tabs
		end

		net.Start("nws_yrp_shop_get_all_tabs")
		net.WriteTable(_nw)
		net.Send(ply)
	end
)