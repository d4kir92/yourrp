if not SERVER then return end
local BUDGET_MAX = 150
local BUDGET_REFILL = 60
local BUDGET_MAX_ADMIN = 600
local BUDGET_REFILL_ADMIN = 250
local WARN_INTERVAL = 5
yrp_net_receive = yrp_net_receive or net.Receive
local warned = {}

function YRPNetBudgetAllows(ply)
	if not IsValid(ply) or not ply:IsPlayer() then return true end
	local max = BUDGET_MAX
	local refill = BUDGET_REFILL
	if ply:HasAccess("YRPNetBudget", true) then
		max = BUDGET_MAX_ADMIN
		refill = BUDGET_REFILL_ADMIN
	end

	local now = CurTime()
	local budget = ply.yrp_net_budget or max
	local last = ply.yrp_net_last or now
	budget = math.min(max, budget + (now - last) * refill)
	ply.yrp_net_last = now
	if budget < 1 then
		ply.yrp_net_budget = budget

		return false
	end

	ply.yrp_net_budget = budget - 1

	return true
end

local function WarnOnce(ply, name)
	local sid = ply:SteamID() or "unknown"
	if (warned[sid] or 0) > CurTime() then return end
	warned[sid] = CurTime() + WARN_INTERVAL
	YRP:msg("error", "[NET] Rate limit reached by " .. ply:SteamName() .. " ( " .. sid .. " ) on " .. tostring(name))
end

function net.Receive(name, callback)
	return yrp_net_receive(
		name,
		function(len, ply)
			if YRP.netstrings and YRP.netstrings[name] and not YRPNetBudgetAllows(ply) then
				WarnOnce(ply, name)

				return
			end

			return callback(len, ply)
		end
	)
end

hook.Add(
	"PlayerDisconnected",
	"yrp_net_ratelimit_cleanup",
	function(ply)
		if IsValid(ply) then
			warned[ply:SteamID() or "unknown"] = nil
		end
	end
)
