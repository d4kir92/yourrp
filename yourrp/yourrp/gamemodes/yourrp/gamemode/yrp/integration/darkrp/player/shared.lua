--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

local Player = FindMetaTable( "Player" )

AddCSLuaFile( "client.lua" )

if CLIENT then
	include( "client.lua" )
else
	include( "server.lua" )
end

function Player:getAgendaTable()
	--Description: Get the agenda a player can see. Note: when a player is not the manager of an agenda, it returns the agenda of the manager.
	--[[local tab = {}
	tab.Title = "NICE"
	return tab]]
	return false
end

function Player:canKeysLock( door)
	--Description: Whether the player can lock a given door.
	if door == NULL then return end
	return YRPCanLock(self, door)
end

function Player:canKeysUnlock( door)
	--Description: Whether the player can unlock a given door.
	if door == NULL then return end
	return YRPCanLock(self, door)	
end

SetGlobalYRPBool( "DarkRP_LockDown", false)
function Player:getDarkRPVar( var)
	--Description: Get the value of a DarkRPVar, which is shared between server and client.
	local notavailable = "feature not available yet"

	if var == "money" then
		return tonumber(self:GetYRPString( "money", "-1" ) )
	elseif var == "salary" then
		return tonumber(self:GetYRPString( "salary", "-1" ) )
	elseif var == "job" then
		return self:GetYRPString( "roleName", "" )
	elseif var == "rpname" then
		return self:RPName() or self:SteamName()
	elseif var == "HasGunlicense" then
		return false
	elseif var == "Energy" then
		return self:Hunger()
	elseif var == "wanted" then
		return self:GetYRPBool( "iswanted", false)
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
		return self:GetYRPBool( "iswanted", false)
	elseif var == "hitTarget" then
		return self:GetYRPEntity( "hittarget" )
	elseif var == "hitPrice" then
		return tonumber(self:GetYRPString( "hitreward" ) )
	elseif var == "lastHitTime" then
		return 0 -- notavailable
	elseif var == "Thirst" then
		return self:Thirst()
	else
		local _nw_var = self:GetYRPInt( var )
		local _nw_var2 = self:GetYRPString( var )
		if _nw_var != nil then
			if tonumber(_nw_var) == nil then
				return _nw_var
			elseif isnumber(_nw_var) != nil then
				return tonumber(_nw_var)
			else
				return _nw_var
			end
		else
			if self[ var ] then
				return self[ var ]
			elseif tonumber(_nw_var2) == nil then
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
	--YRPDarkrpNotFound( "getEyeSightHitEntity(searchDistance, hitDistance, filter)" )
	return NULL, 0
end

function Player:getHitPrice()
	--Description: Get the price the hitman demands for his work.
	return self:getHitTarget():GetYRPString( "hitreward", -1)
end

function Player:getHitTarget()
	--Description: Get the target of a hitman.
	return self:GetYRPEntity( "hittarget", NULL)
end

function YRPConvertToDarkRPJobName(name)
	if IsNotNilAndNotFalse(name) then
		name = string.Replace(name, " ", "_" )
		local jobname = "TEAM_" .. name
		return string.upper(jobname)
	else
		return "FAILED"
	end
end

function YRPConvertToDarkRPCategory( tab, cat )
	local t = {}

	t.uniqueID = tab.uniqueID or -1
	t.name = tab.name or tab.string_name or "-"
	t.categorises = cat
	t.startExpanded = true
	if tab.string_color and type( tab.string_color ) == "string" then
		t.color = StringToColor(tab.string_color)
	elseif tab.color then
		t.color = tab.color
	else
		t.color = Color( 0, 255, 0, 255)
	end
	t.sortOrder = 100

	return t
end

function Player:getJobTable()
	--Description: Get the job table of a player.
	local _job = {}

	_job.team = self:GetRoleUID()

	_job.name = self:GetYRPString( "roleName", "INVALID" )

	local _pms = string.Explode( ",", self:GetYRPString( "playermodels", "INVALID" ) )
	local pms = {}
	for i, v in pairs( _pms ) do
		if !strEmpty( v ) then
			table.insert( pms, v )
		end
	end
	if table.Count( pms ) <= 0 then
		pms = "models/player/skeleton.mdl"
	end
	_job.model = pms

	_job.description = self:GetYRPString( "roleDescription", "INVALID" )
	local _weapons = string.Explode( ",", self:GetYRPString( "sweps", "INVALID" ) )
	_job.weapons = _weapons
	_job.max = tonumber(self:GetYRPString( "maxamount", -1) )
	_job.salary = tonumber(self:GetYRPString( "salary", "INVALID" ) )
	_job.admin = tonumber(self:GetYRPBool( "isadminonly" ) ) or 0
	_job.vote = self:GetYRPBool( "isVoteable" ) or false
	if self:GetLicenseIDs() then
		_job.hasLicense = true
	else
		_job.hasLicense = false
	end
	_job.candemote = self:GetYRPBool( "isInstructor" ) or false
	_job.category = self:GetYRPString( "groupName", "INVALID" )
	_job.command = YRPConvertToDarkRPJobName(_job.name)
	_job.color = self:GetRoleColor()

	return _job
end

function YRPMakeJobTable( id )
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
	
	job.color = Color( 0, 0, 0, 255 )
	job.uniqueID = id
	job.int_groupID = 1

	job.fake = true

	return job
end

if RPExtraTeams == nil then
	RPExtraTeams = {}
	for i = 0, 2000 do
		RPExtraTeams[i] = YRPMakeJobTable( i )
		if i == 0 then
			RPExtraTeams[i].name = "LOADING"
			RPExtraTeams[i].model = "models/player/skeleton.mdl"
			RPExtraTeams[i].fake = false
		end
	end
end
jobByCmd = jobByCmd or {}
function GetRPExtraTeams()
	for i, ply in pairs(player.GetAll() ) do
		local _job = ply:getJobTable()
		RPExtraTeams[ply:Team()] = _job
	end
	return RPExtraTeams
end
GetRPExtraTeams()

RPExtraTeamDoors = RPExtraTeamDoors or {}

function Player:getPocketItems()
	--Description: Get a player's pocket items.
	--YRPDarkrpNotFound( "getPocketItems()" )
	return self:GetWeapons()
end

function Player:getWantedReason()
	--Description: Get the reason why someone is wanted
	YRPDarkrpNotFound( "getWantedReason()" )
	return "old getWantedReason"
end

function Player:hasDarkRPPrivilege(priv)
	--Description: Whether the player has a certain privilege.
	YRPDarkrpNotFound( "hasDarkRPPrivilege( " .. tostring(priv) .. " )" )
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
	return self:GetYRPBool( "injail", false)
end

function Player:isChief()
	--Description: Whether this player is a Chief.
	YRPDarkrpNotFound( "isChief()" )
	return false
end

function Player:isCook()
	--Description: Whether this player is a cook. This function is only available if hungermod is enabled.
	YRPDarkrpNotFound( "isCook()" )
	return false
end

function Player:isCP()
	--Description: Whether this player is part of the police force (mayor, cp, chief).
	return self:GetYRPBool( "bool_iscp", false) or self:GetYRPBool( "groupiscp", false)
end

function Player:isHitman()
	--Description: Whether this player is a hitman.
	return self:GetYRPBool( "bool_canbeagent", false)
end

function Player:isMayor()
	--Description: Whether this player is a mayor.
	return self:GetYRPBool( "bool_ismayor", false)
end

function Player:isMedic()
	--Description: Whether this player is a medic.
	return self:GetYRPBool( "bool_ismedic", false)
end

function Player:isCook()
	--Description: Whether this player is a cook.
	return self:GetYRPBool( "bool_iscook", false)
end

function Player:isWanted()
	--Description: Whether this player is wanted
	return self:GetYRPBool( "iswanted", false)
end

function Player:nickSortedPlayers()
	--Description: A table of players sorted by RP name.
	YRPDarkrpNotFound( "nickSortedPlayers()" )
	return {}
end

Player.DarkRPVars = {}
Player.DarkRPVars.money = 0
Player.DarkRPVars.job = ""

--
local function RetrievePlayerVar(userID, var, value)
	--RetrievePlayerVar
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
	local var, value = DarkRP.readNetDarkRPVar()

	RetrievePlayerVar(userID, var, value)
end
net.Receive( "DarkRP_PlayerVar", doRetrieve)

local function doRetrieveRemoval()
	--doRetrieveRemoval
end
net.Receive( "DarkRP_PlayerVarRemoval", doRetrieveRemoval)

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
net.Receive( "DarkRP_InitializeVars", InitializeDarkRPVars)
--timer.Simple(0, fp{RunConsoleCommand, "_sendDarkRPvars"})

net.Receive( "DarkRP_DarkRPVarDisconnect", function(len)
	local userID = net.ReadUInt(16)
	DarkRPVars[userID] = nil
end)

timer.Create( "DarkRPCheckifitcamethrough", 15, 0, function()
	for _, v in ipairs(player.GetAll() ) do
		if v:getDarkRPVar( "rpname" ) then continue end

		RunConsoleCommand( "_sendDarkRPvars" )
		return
	end

	timer.Remove( "DarkRPCheckifitcamethrough" )
end)

CustomVehicles = {}
CustomShipments = {}
