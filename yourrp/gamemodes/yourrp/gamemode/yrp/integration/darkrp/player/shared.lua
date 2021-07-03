--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local Player = FindMetaTable("Player")

AddCSLuaFile("client.lua")

if CLIENT then
	include("client.lua")
else
	include("server.lua")
end

function Player:getAgendaTable()
	--Description: Get the agenda a player can see. Note: when a player is not the manager of an agenda, it returns the agenda of the manager.
	--YRP.msg("darkrp", "getAgendaTable()")
	--YRP.msg("darkrp", DarkRP._not)
	return false
end

function Player:canKeysLock(door)
	--Description: Whether the player can lock a given door.
	if door == NULL then return end
	return canLock(self, door)
end

function Player:canKeysUnlock(door)
	--Description: Whether the player can unlock a given door.
	if door == NULL then return end
	return canLock(self, door)	
end

SetGlobalBool("DarkRP_LockDown", false)
function Player:getDarkRPVar(var)
	--Description: Get the value of a DarkRPVar, which is shared between server and client.
	local notavailable = "feature not available yet"

	if var == "money" then
		return tonumber(self:GetNW2String("money", "-1"))
	elseif var == "salary" then
		return tonumber(self:GetNW2String("salary", "-1"))
	elseif var == "job" then
		return self:GetNW2String("roleName", "")
	elseif var == "rpname" then
		return self:RPName() or self:SteamName()
	elseif var == "HasGunlicense" then
		return false
	elseif var == "Energy" then
		return self:Hunger()
	elseif var == "wanted" then
		return self:GetNW2Bool("iswanted", false)
	elseif var == "wantedReason" then
		return notavailable
	elseif var == "agenda" then
		return ""
	elseif var == "AFK" then
		return self:AFK()
	elseif var == "AFKDemoted" then
		return false -- notavailable
	elseif var == "Arrested" then
		return self:isArrested()
	elseif var == "hasHit" then
		return self:GetNW2Bool("iswanted", false)
	elseif var == "hitTarget" then
		return self:GetNW2Entity("hittarget")
	elseif var == "hitPrice" then
		return tonumber(self:GetNW2String("hitreward"))
	elseif var == "lastHitTime" then
		return 0 -- notavailable
	elseif var == "Thirst" then
		return self:Thirst()
	else
		local _nw_var = self:GetNW2Int(var)
		local _nw_var2 = self:GetNW2String(var)
		if _nw_var != nil then
			if tonumber(_nw_var) == nil then
				return _nw_var
			elseif isnumber(_nw_var) != nil then
				return tonumber(_nw_var)
			else
				return _nw_var
			end
		else
			if tonumber(_nw_var2) == nil then
				return _nw_var2
			elseif isnumber(_nw_var2) != nil then
				return tonumber(_nw_var2)
			else
				return _nw_var2
			end
		end
	end
	return 0
end

function Player:getEyeSightHitEntity(searchDistance, hitDistance, filter)
	--Description: Get the entity that is closest to a player's line of sight and its distance.
	YRP.msg("darkrp", "getEyeSightHitEntity(searchDistance, hitDistance, filter)")
	YRP.msg("darkrp", DarkRP._not)
	return NULL, 0
end

function Player:getHitPrice()
	--Description: Get the price the hitman demands for his work.
	return self:getHitTarget():GetNW2String("hitreward", -1)
end

function Player:getHitTarget()
	--Description: Get the target of a hitman.
	return self:GetNW2Entity("hittarget", NULL)
end

function ConvertToDarkRPJobName(name)
	if wk(name) then
		name = string.Replace(name, " ", "_")
		local jobname = "TEAM_" .. name
		return jobname
	else
		return "FAILED"
	end
end

function Player:getJobTable()
	--Description: Get the job table of a player.
	local _job = {}

	_job.name = self:GetNW2String("roleName", "INVALID")
	local _pms = string.Explode(",", self:GetNW2String("playermodels", "INVALID"))
	_job.model = _pms
	_job.description = self:GetNW2String("roleDescription", "INVALID")
	local _weapons = string.Explode(",", self:GetNW2String("sweps", "INVALID"))
	_job.weapons = _weapons
	_job.command = "NONE"
	_job.max = tonumber(self:GetNW2String("maxamount", -1))
	_job.salary = tonumber(self:GetNW2String("salary", "INVALID"))
	_job.admin = tonumber(self:GetNW2Bool("isadminonly")) or 0
	_job.vote = self:GetNW2Bool("isVoteable") or false
	if self:GetNW2String("licenseIDs", "") != "" then
		_job.hasLicense = true
	else
		_job.hasLicense = false
	end
	_job.candemote = self:GetNW2Bool("isInstructor") or false
	_job.category = self:GetNW2String("groupName", "INVALID")
	_job.command = ConvertToDarkRPJobName(_job.name)

	return _job
end

RPExtraTeams = RPExtraTeams or {}
function GetRPExtraTeams()
	RPExtraTeams = RPExtraTeams or {}
	for i, ply in pairs(player.GetAll()) do
		local _job = ply:getJobTable()
		RPExtraTeams[ply:Team()] = _job
		--table.insert(RPExtraTeams, _job) -- old
	end
	return RPExtraTeams
end
GetRPExtraTeams()

function Player:getPocketItems()
	--Description: Get a player's pocket items.
	YRP.msg("darkrp", "getPocketItems()")
	YRP.msg("darkrp", DarkRP._not)
	return {}
end

function Player:getWantedReason()
	--Description: Get the reason why someone is wanted
	YRP.msg("darkrp", "getWantedReason()")
	YRP.msg("darkrp", DarkRP._not)
	return "old getWantedReason"
end

function Player:hasDarkRPPrivilege(priv)
	--Description: Whether the player has a certain privilege.
	YRP.msg("darkrp", "hasDarkRPPrivilege(" .. tostring(priv) .. ")")
	YRP.msg("darkrp", DarkRP._not)
	return false
end

function Player:hasHit()
	--Description: Whether this hitman has a hit.
	if self:getHitTarget() != NULL then
		return true
	else
		return false
	end
end

function Player:isArrested()
	--Description: Whether this player is arrested
	--YRP.msg("darkrp", "isArrested()")
	return self:GetNW2Bool("injail", false)
end

function Player:isChief()
	--Description: Whether this player is a Chief.
	YRP.msg("darkrp", "isChief()")
	YRP.msg("darkrp", DarkRP._not)
	return false
end

function Player:isCook()
	--Description: Whether this player is a cook. This function is only available if hungermod is enabled.
	YRP.msg("darkrp", "isCook()")
	YRP.msg("darkrp", DarkRP._not)
	return false
end

function Player:isCP()
	--Description: Whether this player is part of the police force (mayor, cp, chief).
	return self:GetNW2Bool("bool_iscp", false) or self:GetNW2Bool("groupiscp", false)
end

function Player:isHitman()
	--Description: Whether this player is a hitman.
	return self:GetNW2Bool("bool_canbeagent", false)
end

function Player:isMayor()
	--Description: Whether this player is a mayor.
	return self:GetNW2Bool("bool_ismayor", false)
end

function Player:isMedic()
	--Description: Whether this player is a medic.
	return self:GetNW2Bool("bool_ismedic", false)
end

function Player:isCook()
	--Description: Whether this player is a cook.
	return self:GetNW2Bool("bool_iscook", false)
end

function Player:isWanted()
	--Description: Whether this player is wanted
	return self:GetNW2Bool("iswanted", false)
end

function Player:nickSortedPlayers()
	--Description: A table of players sorted by RP name.
	YRP.msg("darkrp", "nickSortedPlayers()")
	YRP.msg("darkrp", DarkRP._not)
	return {}
end

--
local function RetrievePlayerVar(userID, var, value)
		--RetrievePlayerVar
end

local function doRetrieve()
		local userID = net.ReadUInt(16)
		local var, value = DarkRP.readNetDarkRPVar()

		RetrievePlayerVar(userID, var, value)
end
net.Receive("DarkRP_PlayerVar", doRetrieve)

local function doRetrieveRemoval()
		--doRetrieveRemoval
end
net.Receive("DarkRP_PlayerVarRemoval", doRetrieveRemoval)

local function InitializeDarkRPVars(len)
		local plyCount = net.ReadUInt(8)

		for i = 1, plyCount, 1 do
				local userID = net.ReadUInt(16)
				local varCount = net.ReadUInt(DarkRP.DARKRP_ID_BITS + 2)

				for j = 1, varCount, 1 do
						local var, value = DarkRP.readNetDarkRPVar()
						RetrievePlayerVar(userID, var, value)
				end
		end
end
net.Receive("DarkRP_InitializeVars", InitializeDarkRPVars)
--timer.Simple(0, fp{RunConsoleCommand, "_sendDarkRPvars"})

net.Receive("DarkRP_DarkRPVarDisconnect", function(len)
		local userID = net.ReadUInt(16)
		DarkRPVars[userID] = nil
end)

timer.Create("DarkRPCheckifitcamethrough", 15, 0, function()
		for _, v in ipairs(player.GetAll()) do
				if v:getDarkRPVar("rpname") then continue end

				RunConsoleCommand("_sendDarkRPvars")
				return
		end

		timer.Remove("DarkRPCheckifitcamethrough")
end)
