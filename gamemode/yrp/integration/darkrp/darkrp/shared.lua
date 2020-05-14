--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

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
	YRP.msg("darkrp", "DarkRP:registerDarkRPVar(" .. tostring(name) .. ", " .. tostring(writeFn) .. ", " .. tostring(readFn) .. ")")
	YRP.msg("darkrp", DarkRP._not)
	maxId = maxId + 1

  -- UNKNOWN_DARKRPVAR is reserved for unknown values
  if maxId >= UNKNOWN_DARKRPVAR then
		return false
	end

  DarkRPVars[name] = {id = maxId, name = name, writeFn = writeFn, readFn = readFn}
  DarkRPVarById[maxId] = DarkRPVars[name]
end
