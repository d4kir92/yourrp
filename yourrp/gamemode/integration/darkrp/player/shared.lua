--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local Player = FindMetaTable( "Player" )

AddCSLuaFile( "client.lua" )

if CLIENT then
  include( "client.lua" )
else
  include( "server.lua" )
end

function Player:getAgendaTable()
  --Description: Get the agenda a player can see. Note: when a player is not the manager of an agenda, it returns the agenda of the manager.
  printGM( "darkrp", "getAgendaTable()" )
  printGM( "darkrp", DarkRP._not )
  return false
end

SetGlobalBool( "DarkRP_LockDown", false )
function Player:getDarkRPVar( var )
  --Description: Get the value of a DarkRPVar, which is shared between server and client.
  if var == "money" then
    return self:GetNWString( "money", "FAIL" )
  elseif var == "salary" then
    return self:GetNWString( "salary", "FAIL" )
  elseif var == "job" then
    return self:GetNWString( "roleName", "FAIL" )
  elseif var == "rpname" then
    return self:RPName() or "FAIL"
  elseif var == "HasGunlicense" then
    return true
  else
    local _nw_var = self:GetNWString( var, "-1" )
    if tonumber( _nw_var ) == nil then
      return _nw_var
    elseif isnumber( _nw_var ) != nil then
      return tonumber( _nw_var )
    else
      return _nw_var
    end
  end
end

function Player:getEyeSightHitEntity( searchDistance, hitDistance, filter )
  --Description: Get the entity that is closest to a player's line of sight and its distance.
  printGM( "darkrp", "getEyeSightHitEntity( searchDistance, hitDistance, filter )" )
  printGM( "darkrp", DarkRP._not )
  return NULL, 0
end

function Player:getHitPrice()
  --Description: Get the price the hitman demands for his work.
  printGM( "darkrp", "getHitPrice()" )
  printGM( "darkrp", DarkRP._not )
  return 0
end

function Player:getHitTarget()
  --Description: Get the target of a hitman.
  printGM( "darkrp", "getHitTarget()" )
  printGM( "darkrp", DarkRP._not )
  return NULL
end

function to_darkrp_job( tab )
  if istable( tab ) then
    local _ret_tab = {}
    _ret_tab.color = Color( 0, 0, 0, 255 )
    _ret_tab.model = tab.playermodels
    _ret_tab.description = tab.description
    _ret_tab.weapons = string.Explode( ",", db_out_str( tab.sweps ) )
    _ret_tab.command = tostring( tab.roleID )
    _ret_tab.max = tonumber( tab.maxamount )
    _ret_tab.salary = tonumber( tab.salary )
    _ret_tab.admin = tonumber( tab.adminonly )
    _ret_tab.vote = tobool( tab.voteable )
    _ret_tab.hasLicense = false -- NEED TO BE EDITED, later
    _ret_tab.customCheck = nil

    return _ret_tab
  else
    printGM( "error", "to_darkrp_job [ tab: " .. tostring( tab ) .. " is not a table ]" )
  end
end

RPExtraTeams = {}

function Player:getJobTable()
  --Description: Get the job table of a player.
  printGM( "darkrp", "getJobTable()" )
  local _job = self:GetRolTab()

  if istable( _job ) then
    _job = to_darkrp_job( _job )
    return _job
  else
    printGM( "note", "currently not available for clientside" )
    return {}
  end
end

function Player:getPocketItems()
  --Description: Get a player's pocket items.
  printGM( "darkrp", "getPocketItems()" )
  printGM( "darkrp", DarkRP._not )
  return {}
end

function Player:getWantedReason()
  --Description: Get the reason why someone is wanted
  printGM( "darkrp", "getWantedReason()" )
  printGM( "darkrp", DarkRP._not )
  return "old getWantedReason"
end

function Player:hasDarkRPPrivilege( priv )
  --Description: Whether the player has a certain privilege.
  printGM( "darkrp", "hasDarkRPPrivilege( " .. tostring( priv ) .. " )" )
  printGM( "darkrp", DarkRP._not )
  return false
end

function Player:hasHit()
  --Description: Whether this hitman has a hit.
  printGM( "darkrp", "hasHit()" )
  printGM( "darkrp", DarkRP._not )
  return false
end

function Player:isArrested()
  --Description: Whether this player is arrested
  --printGM( "darkrp", "isArrested()" )
  return self:GetNWBool( "inJail", false )
end

function Player:isChief()
  --Description: Whether this player is a Chief.
  printGM( "darkrp", "isChief()" )
  printGM( "darkrp", DarkRP._not )
  return false
end

function Player:isCook()
  --Description: Whether this player is a cook. This function is only available if hungermod is enabled.
  printGM( "darkrp", "isCook()" )
  printGM( "darkrp", DarkRP._not )
  return false
end

function Player:isCP()
  --Description: Whether this player is part of the police force (mayor, cp, chief).
  printGM( "darkrp", "isCP()" )
  printGM( "darkrp", DarkRP._not )
  return true
end

function Player:isHitman()
  --Description: Whether this player is a hitman.
  printGM( "darkrp", "isHitman()" )
  printGM( "darkrp", DarkRP._not )
  return false
end

function Player:isMayor()
  --Description: Whether this player is a mayor.
  printGM( "darkrp", "isMayor()" )
  printGM( "darkrp", DarkRP._not )
  return false
end

function Player:isMedic()
  --Description: Whether this player is a medic.
  printGM( "darkrp", "isMedic()" )
  printGM( "darkrp", DarkRP._not )
  return false
end

function Player:isWanted()
  --Description: Whether this player is wanted
  printGM( "darkrp", "isWanted()" )
  printGM( "darkrp", DarkRP._not )
  return false
end

function Player:nickSortedPlayers()
  --Description: A table of players sorted by RP name.
  printGM( "darkrp", "nickSortedPlayers()" )
  printGM( "darkrp", DarkRP._not )
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
timer.Simple(0, fp{RunConsoleCommand, "_sendDarkRPvars"})

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
