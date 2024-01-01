--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
AddCSLuaFile("client.lua")
if CLIENT then
	include("client.lua")
else
	include("server.lua")
end

local maxId = 0
local DarkRPVars = {}
local DarkRPVarById = {}
-- the amount of bits assigned to the value that determines which DarkRPVar we're sending/receiving
local DARKRP_ID_BITS = 8
local UNKNOWN_DARKRPVAR = 255 -- Should be equal to 2^DARKRP_ID_BITS - 1
DarkRP.DARKRP_ID_BITS = DARKRP_ID_BITS
function DarkRP:registerDarkRPVar(name, writeFn, readFn)
	maxId = maxId + 1
	-- UNKNOWN_DARKRPVAR is reserved for unknown values
	if maxId >= UNKNOWN_DARKRPVAR then return false end
	DarkRPVars[name] = {
		id = maxId,
		name = name,
		writeFn = writeFn,
		readFn = readFn
	}

	DarkRPVarById[maxId] = DarkRPVars[name]
end

TEAM_CITIZEN = 1
TEAM_HOBO = 2
TEAM_MEDIC = 3
TEAM_POLICE = 4
TEAM_GANG = 5
TEAM_MOB = 6
TEAM_GUN = 7