--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
local DATABASE_NAME = "yrp_agents"
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "target", "TEXT DEFAULT 'No Target'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "reward", "INTEGER DEFAULT 1")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "description", "TEXT DEFAULT 'NO DESCRIPTION'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "contract_SteamID", "TEXT DEFAULT ''")
YRP:AddNetworkString("nws_yrp_placehit")
YRP:AddNetworkString("nws_yrp_gethits")
YRP:AddNetworkString("nws_yrp_accepthit")
net.Receive(
	"nws_yrp_placehit",
	function(len, ply)
		local _steamid = net.ReadString()
		local _reward = net.ReadString()
		local _desc = net.ReadString()
		YRP:msg("note", "[AGENTS] received hit info: " .. _steamid .. ", " .. _reward .. ", " .. _desc)
		_reward = tonumber(_reward)
		if ply:canAfford(_reward) then
			ply:addMoney(-_reward)
			YRP:msg("note", "Set hit")
			local _res = YRP_SQL_INSERT_INTO(DATABASE_NAME, "target, reward, description, contract_SteamID", "'" .. _steamid .. "', " .. _reward .. ", '" .. _desc .. "', '" .. ply:YRPSteamID() .. "'")
		else
			YRP:msg("note", "Cant afford hit")
		end
	end
)

net.Receive(
	"nws_yrp_gethits",
	function(len, ply)
		local _hits = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
		if _hits ~= nil then
			net.Start("nws_yrp_gethits")
			net.WriteTable(_hits)
			net.Send(ply)
		end
	end
)

YRP:AddNetworkString("nws_yrp_get_contracts")
net.Receive(
	"nws_yrp_get_contracts",
	function(len, ply)
		local _hits = YRP_SQL_SELECT(DATABASE_NAME, "*", "contract_SteamID = '" .. ply:YRPSteamID() .. "'")
		if _hits ~= nil then
			net.Start("nws_yrp_get_contracts")
			net.WriteTable(_hits)
			net.Send(ply)
		end
	end
)

function hitdone(target, agent)
	YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = " .. target:GetYRPString("hituid"))
	target:SetYRPBool("iswanted", false)
	target:SetYRPString("hitreward", "")
	target:SetYRPString("hituid", "")
	agent:SetYRPString("hittargetName", "")
	agent:SetYRPEntity("hittarget", NULL)
end

function hitquit(agent)
	agent:SetYRPString("hittargetName", "")
	agent:SetYRPEntity("hittarget", NULL)
end

net.Receive(
	"nws_yrp_accepthit",
	function(len, ply)
		local _uid = net.ReadString()
		local _hit = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = " .. _uid)
		if _hit ~= nil then
			_hit = _hit[1]
			for i, p in pairs(player.GetAll()) do
				if _hit.target == p:YRPSteamID() then
					p:SetYRPBool("iswanted", true)
					p:SetYRPString("hitreward", _hit.reward)
					p:SetYRPString("hituid", _hit.uniqueID)
					ply:SetYRPString("hittargetName", p:RPName())
					ply:SetYRPEntity("hittarget", p)
					break
				end
			end
		end
	end
)
