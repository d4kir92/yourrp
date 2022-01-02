--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_agents"
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "target", "TEXT DEFAULT 'No Target'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "reward", "INTEGER DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "description", "TEXT DEFAULT 'NO DESCRIPTION'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "contract_SteamID", "TEXT DEFAULT ''" )

util.AddNetworkString( "yrp_placehit" )
util.AddNetworkString( "yrp_gethits" )
util.AddNetworkString( "yrp_accepthit" )

net.Receive( "yrp_placehit", function(len, ply)
	local _steamid = net.ReadString()
	local _reward = net.ReadString()
	local _desc = net.ReadString()

	YRP.msg( "note", "[AGENTS] received hit info: " .. _steamid .. ", " .. _reward .. ", " .. _desc)
	_reward = tonumber(_reward)
	if ply:canAfford(_reward) then
		ply:addMoney(- _reward)
		YRP.msg( "note", "Set hit" )
		local _res = YRP_SQL_INSERT_INTO(DATABASE_NAME, "target, reward, description, contract_SteamID", "'" .. _steamid .. "', " .. _reward .. ", '" .. _desc .. "', '" .. ply:SteamID() .. "'" )

	else
		YRP.msg( "note", "Cant afford hit" )
	end
end)

net.Receive( "yrp_gethits", function(len, ply)
	local _hits = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
	if _hits != nil then
		net.Start( "yrp_gethits" )
			net.WriteTable(_hits)
		net.Send(ply)
	end
end)

util.AddNetworkString( "yrp_get_contracts" )
net.Receive( "yrp_get_contracts", function(len, ply)
	local _hits = YRP_SQL_SELECT(DATABASE_NAME, "*", "contract_SteamID = '" .. ply:SteamID() .. "'" )
	if _hits != nil then
		net.Start( "yrp_get_contracts" )
			net.WriteTable(_hits)
		net.Send(ply)
	end
end)

function hitdone(target, agent)
	YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = " .. target:GetNW2String( "hituid" ) )

	target:SetNW2Bool( "iswanted", false)
	target:SetNW2String( "hitreward", "" )
	target:SetNW2String( "hituid", "" )
	agent:SetNW2String( "hittargetName", "" )
	agent:SetNW2Entity( "hittarget", NULL)
end

function hitquit( agent)
	agent:SetNW2String( "hittargetName", "" )
	agent:SetNW2Entity( "hittarget", NULL)
end

net.Receive( "yrp_accepthit", function(len, ply)
	local _uid = net.ReadString()
	local _hit = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = " .. _uid)

	if _hit != nil then
		_hit = _hit[1]
		for i, p in pairs(player.GetAll() ) do
			if _hit.target == p:SteamID() then
				p:SetNW2Bool( "iswanted", true)
				p:SetNW2String( "hitreward", _hit.reward)
				p:SetNW2String( "hituid", _hit.uniqueID)
				ply:SetNW2String( "hittargetName", p:RPName() )
				ply:SetNW2Entity( "hittarget", p)
				break
			end
		end
	end
end)
