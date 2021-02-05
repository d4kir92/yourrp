--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local _db_name = "yrp_agents"
SQL_ADD_COLUMN(_db_name, "target", "TEXT DEFAULT 'No Target'")
SQL_ADD_COLUMN(_db_name, "reward", "INTEGER DEFAULT 1")
SQL_ADD_COLUMN(_db_name, "description", "TEXT DEFAULT 'NO DESCRIPTION'")
SQL_ADD_COLUMN(_db_name, "contract_SteamID", "TEXT DEFAULT ' '")

--db_drop_table(_db_name)
--db_is_empty(_db_name)

util.AddNetworkString("yrp_placehit")
util.AddNetworkString("yrp_gethits")
util.AddNetworkString("yrp_accepthit")

net.Receive("yrp_placehit", function(len, ply)
	local _steamid = net.ReadString()
	local _reward = net.ReadString()
	local _desc = net.ReadString()

	YRP.msg("note", "[AGENTS] received hit info: " .. _steamid .. ", " .. _reward .. ", " .. SQL_STR_IN(_desc))
	_reward = tonumber(_reward)
	if ply:canAfford(_reward) then
		ply:addMoney(- _reward)
		YRP.msg("note", "Set hit")
		local _res = SQL_INSERT_INTO(_db_name, "target, reward, description, contract_SteamID", "'" .. _steamid .. "', " .. _reward .. ", '" .. SQL_STR_IN(_desc) .. "', '" .. ply:SteamID() .. "'")

	else
		YRP.msg("note", "Cant afford hit")
	end
end)

net.Receive("yrp_gethits", function(len, ply)
	local _hits = SQL_SELECT(_db_name, "*", nil)
	if _hits != nil then
		net.Start("yrp_gethits")
			net.WriteTable(_hits)
		net.Send(ply)
	end
end)

util.AddNetworkString("yrp_get_contracts")
net.Receive("yrp_get_contracts", function(len, ply)
	local _hits = SQL_SELECT(_db_name, "*", "contract_SteamID = '" .. ply:SteamID() .. "'")
	if _hits != nil then
		net.Start("yrp_get_contracts")
			net.WriteTable(_hits)
		net.Send(ply)
	end
end)

function hitdone(target, agent)
	SQL_DELETE_FROM(_db_name, "uniqueID = " .. target:GetDString("hituid"))

	target:SetDBool("iswanted", false)
	target:SetDString("hitreward", "")
	target:SetDString("hituid", "")
	agent:SetDString("hittargetName", "")
	agent:SetDEntity("hittarget", NULL)
end

function hitquit(agent)
	agent:SetDString("hittargetName", "")
	agent:SetDEntity("hittarget", NULL)
end

net.Receive("yrp_accepthit", function(len, ply)
	local _uid = net.ReadString()
	local _hit = SQL_SELECT(_db_name, "*", "uniqueID = " .. _uid)

	if _hit != nil then
		_hit = _hit[1]
		for i, p in pairs(player.GetAll()) do
			if _hit.target == p:SteamID() then
				p:SetDBool("iswanted", true)
				p:SetDString("hitreward", _hit.reward)
				p:SetDString("hituid", _hit.uniqueID)
				ply:SetDString("hittargetName", p:RPName())
				ply:SetDEntity("hittarget", p)
				break
			end
		end
	end
end)
