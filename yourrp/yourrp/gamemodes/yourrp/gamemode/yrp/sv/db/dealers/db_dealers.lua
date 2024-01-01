--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
local DATABASE_NAME = "yrp_dealers"
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "name", "TEXT DEFAULT 'Unnamed dealer'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "tabs", "TEXT DEFAULT ''")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "WorldModel", "TEXT DEFAULT 'models/player/skeleton.mdl'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "map", "TEXT DEFAULT 'gm_construct'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "storagepoints", "TEXT DEFAULT ''")
if YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = 1") == nil then
	local _global_shop = YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, uniqueID", "'LID_buymenu', 1")
end

local _minus = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '-1'")
if _minus ~= nil then
	YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '-1'")
end

util.AddNetworkString("nws_yrp_dealer_add")
function dealer_rem(uid)
	uid = tonumber(uid)
	local _del = YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. uid .. "'")
end

function CleanUpDealers()
	local _dealers = YRP_SQL_SELECT("yrp_dealers", "*", "map = '" .. GetMapNameDB() .. "'")
	local _map_dealers = YRP_SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = 'dealer'")
	if IsNotNilAndNotFalse(_map_dealers) and IsNotNilAndNotFalse(_dealers) then
		for i, dealer in pairs(_dealers) do
			local found = false
			for j, map_dealer in pairs(_map_dealers) do
				if dealer.uniqueID == map_dealer.linkID then
					found = true
				end
			end

			if not found and tonumber(dealer.uniqueID) ~= 1 then
				YRP.msg("db", "Removed unused dealer: " .. dealer.name .. " [UID: " .. dealer.uniqueID .. "]")
				dealer_rem(dealer.uniqueID)
			end
		end
	end
end

CleanUpDealers()
function dealer_add(ply)
	local _uid = math.Round(math.Rand(1, 999999), 0)
	local _insert = YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, map", "'" .. _uid .. "', '" .. GetMapNameDB() .. "'")
	local _db_sel = YRP_SQL_SELECT(DATABASE_NAME, "uniqueID", "name = '" .. _uid .. "'")
	if _db_sel ~= nil then
		_db_sel = _db_sel[1]
		local _db_upd = YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["name"] = "Unnamed Dealer"
			}, "uniqueID = " .. _db_sel.uniqueID
		)

		local _pos = ply:GetPos()
		local _ang = ply:EyeAngles()
		local _vals = "'dealer', '" .. _pos.x .. "," .. _pos.y .. "," .. _pos.z .. "', '" .. _ang.p .. "," .. _ang.y .. "," .. _ang.r .. "', '" .. _db_sel.uniqueID .. "'"
		YRP_SQL_INSERT_INTO("yrp_" .. GetMapNameDB(), "type, position, angle, linkID", _vals)
	end
end

net.Receive(
	"nws_yrp_dealer_add",
	function(len, ply)
		dealer_add(ply)
	end
)

util.AddNetworkString("nws_yrp_dealer_add_tab")
net.Receive(
	"nws_yrp_dealer_add_tab",
	function(len, ply)
		local _dealer_uid = net.ReadString()
		local _tab_uid = net.ReadString()
		local _dealer = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = " .. _dealer_uid)
		if _dealer ~= nil then
			_dealer = _dealer[1]
			local _tabs = string.Explode(",", _dealer.tabs)
			if _tabs[1] == "" then
				_tabs = {}
			end

			table.insert(_tabs, _tab_uid)
			local tabs = string.Implode(",", _tabs)
			local _up = YRP_SQL_UPDATE(
				DATABASE_NAME,
				{
					["tabs"] = tabs
				}, "uniqueID = " .. _dealer_uid
			)
		end
	end
)

util.AddNetworkString("nws_yrp_dealer_rem_tab")
net.Receive(
	"nws_yrp_dealer_rem_tab",
	function(len, ply)
		local _dealer_uid = net.ReadString()
		local _tab_uid = net.ReadString()
		local _dealer = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = " .. _dealer_uid)
		if _dealer ~= nil then
			_dealer = _dealer[1]
			_dealer.tabs = string.Explode(",", _dealer.tabs)
			table.RemoveByValue(_dealer.tabs, _tab_uid)
			_dealer.tabs = string.Implode(",", _dealer.tabs)
			YRP_SQL_UPDATE(
				DATABASE_NAME,
				{
					["tabs"] = _dealer.tabs
				}, "uniqueID = " .. _dealer_uid
			)
		end
	end
)

util.AddNetworkString("nws_yrp_dealer_edit_name")
net.Receive(
	"nws_yrp_dealer_edit_name",
	function(len, ply)
		local _dealer_uid = net.ReadString()
		local _dealer_new_name = net.ReadString()
		local _dealer = YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["name"] = _dealer_new_name
			}, "uniqueID = " .. _dealer_uid
		)

		for i, npc in pairs(ents.GetAll()) do
			if npc:GetYRPString("dealerID", "FAILED") == tostring(_dealer_uid) then
				npc:SetYRPString("name", _dealer_new_name)
			end
		end
	end
)

util.AddNetworkString("nws_yrp_dealer_edit_worldmodel")
net.Receive(
	"nws_yrp_dealer_edit_worldmodel",
	function(len, ply)
		local _dealer_uid = net.ReadString()
		local _dealer_new_wm = net.ReadString()
		local _dealer = YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["WorldModel"] = _dealer_new_wm
			}, "uniqueID = " .. _dealer_uid
		)

		for i, npc in pairs(ents.GetAll()) do
			if npc:GetYRPString("dealerID", "FAILED") == tostring(_dealer_uid) then
				npc:SetModel(_dealer_new_wm)
				npc:LookupSequence("idle_all_01")
				npc:ResetSequence("idle_all_01")
			end
		end
	end
)

util.AddNetworkString("nws_yrp_dealer_edit_storagepoints")
net.Receive(
	"nws_yrp_dealer_edit_storagepoints",
	function(len, ply)
		local _dealer_uid = net.ReadString()
		local _dealer_storagepoints = net.ReadString()
		local _dealer = YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["storagepoints"] = _dealer_storagepoints
			}, "uniqueID = " .. _dealer_uid
		)
	end
)