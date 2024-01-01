--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local Player = FindMetaTable("Player")
AddCSLuaFile("client.lua")
if CLIENT then
	include("client.lua")
else
	include("server.lua")
end

function Player:getAgendaTable()
	return false
end

--Description: Get the agenda a player can see. Note: when a player is not the manager of an agenda, it returns the agenda of the manager.
--[[local tab = {}
	tab.Title = "NICE"
	return tab]]
function Player:canKeysLock(door)
	--Description: Whether the player can lock a given door.
	if door == NULL then return end

	return YRPCanLock(self, door)
end

function Player:canKeysUnlock(door)
	--Description: Whether the player can unlock a given door.
	if door == NULL then return end

	return YRPCanLock(self, door)
end

SetGlobalYRPBool("DarkRP_LockDown", false)
function Player:getDarkRPVar(var)
	--Description: Get the value of a DarkRPVar, which is shared between server and client.
	local notavailable = "feature not available yet"
	if var == "money" then
		return tonumber(self:GetYRPString("money", "-1"))
	elseif var == "salary" then
		return tonumber(self:GetYRPString("salary", "-1"))
	elseif var == "job" then
		return self:GetYRPString("roleName", "")
	elseif var == "rpname" then
		return self:RPName() or self:SteamName()
	elseif var == "HasGunlicense" then
		return false
	elseif var == "Energy" then
		return self:Hunger()
	elseif var == "wanted" then
		return self:GetYRPBool("iswanted", false)
	elseif var == "wantedReason" then
		return notavailable
	elseif var == "agenda" then
		return ""
	elseif var == "AFK" then
		return self:AFK()
	elseif var == "AFKDemoted" then
		return false
	elseif var == "Arrested" then
		return self:isArrested()
	elseif var == "hasHit" then
		return self:GetYRPBool("iswanted", false)
	elseif var == "hitTarget" then
		return self:GetYRPEntity("hittarget")
	elseif var == "hitPrice" then
		return tonumber(self:GetYRPString("hitreward"))
	elseif var == "lastHitTime" then
		return 0
	elseif var == "Thirst" then
		return self:Thirst()
	else -- notavailable -- notavailable
		local _nw_var = self:GetYRPInt(var)
		local _nw_var2 = self:GetYRPString(var)
		if _nw_var ~= nil then
			if tonumber(_nw_var) == nil then
				return _nw_var
			elseif isnumber(_nw_var) ~= nil then
				return tonumber(_nw_var)
			else
				return _nw_var
			end
		else
			if self[var] then
				return self[var]
			elseif tonumber(_nw_var2) == nil then
				return _nw_var2
			elseif isnumber(_nw_var2) ~= nil then
				return tonumber(_nw_var2)
			else
				return _nw_var2
			end
		end
	end

	return 0
end

function Player:getEyeSightHitEntity(searchDistance, hitDistance, filter)
	return NULL, 0
end

--Description: Get the entity that is closest to a player's line of sight and its distance.
--YRPDarkrpNotFound( "getEyeSightHitEntity(searchDistance, hitDistance, filter)" )
function Player:getHitPrice()
	return self:getHitTarget():GetYRPString("hitreward", -1)
end

--Description: Get the price the hitman demands for his work.
function Player:getHitTarget()
	return self:GetYRPEntity("hittarget", NULL)
end

--Description: Get the target of a hitman.
function YRPConvertToDarkRPJobName(name)
	if IsNotNilAndNotFalse(name) then
		name = string.Replace(name, " ", "_")
		local jobname = "TEAM_" .. name

		return string.upper(jobname)
	else
		return "FAILED"
	end
end

function YRPConvertToDarkRPCategory(tab, cat)
	local t = {}
	t.uniqueID = tab.uniqueID or -1
	t.name = tab.name or tab.string_name or "-"
	t.categorises = cat
	t.startExpanded = true
	if tab.string_color and type(tab.string_color) == "string" then
		t.color = StringToColor(tab.string_color)
	elseif tab.color then
		t.color = tab.color
	else
		t.color = Color(0, 255, 0, 255)
	end

	t.sortOrder = 100

	return t
end

function YRPMakeJobTable(id)
	local job = {}
	job.team = id
	job.name = "LOADING"
	job.model = "models/player/skeleton.mdl"
	job.description = ""
	job.weapons = ""
	job.max = 1
	job.salary = 0
	job.admin = 0
	job.vote = false
	job.hasLicense = false
	job.candemote = false
	job.category = ""
	job.command = ""
	job.color = Color(0, 0, 0, 255)
	job.uniqueID = id
	job.int_groupID = 1
	job.fake = true

	return job
end

if RPExtraTeams == nil then
	RPExtraTeams = {}
	for i = 0, 2000 do
		RPExtraTeams[i] = YRPMakeJobTable(i)
		if i == 0 then
			RPExtraTeams[i].name = "LOADING"
			RPExtraTeams[i].model = "models/player/skeleton.mdl"
			RPExtraTeams[i].fake = false
		end
	end
end

jobByCmd = jobByCmd or {}
function GetRPExtraTeams()
	for i, ply in pairs(player.GetAll()) do
		local _job = ply:getJobTable()
		RPExtraTeams[ply:Team()] = _job
	end

	return RPExtraTeams
end

GetRPExtraTeams()
RPExtraTeamDoors = RPExtraTeamDoors or {}
function Player:getJobTable()
	--Description: Get the job table of a player.
	local darkrpJobTab = RPExtraTeams[self:Team()]
	local _job = {}
	_job.team = self:GetRoleUID()
	_job.name = self:GetYRPString("roleName", "INVALID")
	local _pms = {}
	if darkrpJobTab then
		_pms = darkrpJobTab.model
	end

	local pms = {}
	if type(_pms) == "table" then
		for i, v in pairs(_pms) do
			if not strEmpty(v) then
				table.insert(pms, v)
			end
		end

		if table.Count(pms) <= 0 then
			pms = "models/player/skeleton.mdl"
		end
	else
		pms = _pms
	end

	_job.model = pms
	_job.description = self:GetYRPString("roleDescription", "INVALID")
	local _weapons = string.Explode(",", self:GetYRPString("sweps", "INVALID"))
	_job.weapons = _weapons
	_job.max = tonumber(self:GetYRPString("maxamount", -1))
	_job.salary = tonumber(self:GetYRPString("salary", "INVALID"))
	_job.admin = tonumber(self:GetYRPBool("isadminonly")) or 0
	_job.vote = self:GetYRPBool("isVoteable") or false
	if self:GetLicenseIDs() then
		_job.hasLicense = true
	else
		_job.hasLicense = false
	end

	_job.candemote = self:GetYRPBool("isInstructor") or false
	_job.category = self:GetYRPString("groupName", "INVALID")
	_job.command = YRPConvertToDarkRPJobName(_job.name)
	_job.color = self:GetRoleColor()

	return _job
end

function Player:getPocketItems()
	return self:GetWeapons()
end

--Description: Get a player's pocket items.
--YRPDarkrpNotFound( "getPocketItems()" )
function Player:getWantedReason()
	--Description: Get the reason why someone is wanted
	YRPDarkrpNotFound("getWantedReason()")

	return "old getWantedReason"
end

function Player:hasDarkRPPrivilege(priv)
	--Description: Whether the player has a certain privilege.
	YRPDarkrpNotFound("hasDarkRPPrivilege( " .. tostring(priv) .. " )")

	return false
end

function Player:hasHit()
	--Description: Whether this hitman has a hit.
	if self:getHitTarget() ~= NULL then
		return true
	else
		return false
	end
end

function Player:isArrested()
	return self:GetYRPBool("injail", false)
end

--Description: Whether this player is arrested
function Player:isChief()
	--Description: Whether this player is a Chief.
	YRPDarkrpNotFound("isChief()")

	return false
end

function Player:isCook()
	--Description: Whether this player is a cook. This function is only available if hungermod is enabled.
	YRPDarkrpNotFound("isCook()")

	return false
end

function Player:isCP()
	return self:GetYRPBool("bool_iscp", false) or self:GetYRPBool("groupiscp", false)
end

--Description: Whether this player is part of the police force (mayor, cp, chief).
function Player:isHitman()
	return self:GetYRPBool("bool_canbeagent", false)
end

--Description: Whether this player is a hitman.
function Player:isMayor()
	return self:GetYRPBool("bool_ismayor", false)
end

--Description: Whether this player is a mayor.
function Player:isMedic()
	return self:GetYRPBool("bool_ismedic", false)
end

--Description: Whether this player is a medic.
function Player:isCook()
	return self:GetYRPBool("bool_iscook", false)
end

--Description: Whether this player is a cook.
function Player:isWanted()
	return self:GetYRPBool("iswanted", false)
end

--Description: Whether this player is wanted
function Player:nickSortedPlayers()
	--Description: A table of players sorted by RP name.
	YRPDarkrpNotFound("nickSortedPlayers()")

	return {}
end

local function RetrievePlayerVar(userID, var, value)
end

local DarkRPVarById = {}
local UNKNOWN_DARKRPVAR = 255
function DarkRP.readNetDarkRPVar()
	local DarkRPVarId = net.ReadUInt(DARKRP_ID_BITS)
	local DarkRPVar = DarkRPVarById[DarkRPVarId]
	if DarkRPVarId == UNKNOWN_DARKRPVAR then
		local name, value = readUnknown()

		return name, value
	end

	local val = DarkRPVar.readFn(value)

	return DarkRPVar.name, val
end

local function doRetrieve()
	local userID = net.ReadUInt(16)
	local var, valu = DarkRP.readNetDarkRPVar()
	RetrievePlayerVar(userID, var, valu)
end

net.Receive("nws_yrp_darkRP_PlayerVar", doRetrieve)
local function doRetrieveRemoval()
end

--doRetrieveRemoval
net.Receive("nws_yrp_darkRP_PlayerVarRemoval", doRetrieveRemoval)
local function InitializeDarkRPVars(len)
	local plyCount = net.ReadUInt(8)
	for i = 1, plyCount do
		local userID = net.ReadUInt(16)
		local varCount = net.ReadUInt(DarkRP.DARKRP_ID_BITS + 2)
		for j = 1, varCount do
			local var, valu = DarkRP.readNetDarkRPVar()
			RetrievePlayerVar(userID, var, valu)
		end
	end
end

net.Receive("nws_yrp_darkRP_InitializeVars", InitializeDarkRPVars)
--timer.Simple(0, fp{RunConsoleCommand, "_sendDarkRPvars"})
net.Receive(
	"nws_yrp_darkRP_DarkRPVarDisconnect",
	function(len)
		local userID = net.ReadUInt(16)
		DarkRPVars[userID] = nil
	end
)

timer.Create(
	"DarkRPCheckifitcamethrough",
	15,
	0,
	function()
		for _, v in ipairs(player.GetAll()) do
			if v:getDarkRPVar("rpname") then continue end
			RunConsoleCommand("_sendDarkRPvars")

			return
		end

		timer.Remove("DarkRPCheckifitcamethrough")
	end
)

CustomVehicles = {}
CustomShipments = {}