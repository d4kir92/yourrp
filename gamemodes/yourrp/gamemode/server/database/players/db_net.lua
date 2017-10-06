--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

util.AddNetworkString( "openCharacterMenu" )
util.AddNetworkString( "setPlayerValues" )
util.AddNetworkString( "setRoleValues" )

util.AddNetworkString( "getPlyList" )

util.AddNetworkString( "getCharakterList" )

net.Receive( "getCharakterList", function( len, ply )
  local _tmpPlyList = ply:GetChaTab()
  if _tmpPlyList != nil then
    net.Start( "getCharakterList" )
      net.WriteTable( _tmpPlyList )
    net.Send( ply )
  end
end)

net.Receive( "getPlyList", function( len, ply )
  local _tmpChaList = dbSelect( "yrp_characters", "*", nil )
  local _tmpRoleList = dbSelect( "yrp_roles", "*", nil )
  local _tmpGroupList = dbSelect( "yrp_groups", "*", nil )
  if _tmpChaList != nil and _tmpRoleList != nil and _tmpGroupList != nil then
    net.Start( "getPlyList" )
      net.WriteTable( _tmpChaList )
      net.WriteTable( _tmpRoleList )
      net.WriteTable( _tmpGroupList )
    net.Send( ply )
  end
end)

util.AddNetworkString( "giveRole" )

net.Receive( "giveRole", function( len, ply )
  local _tmpSteamID = net.ReadString()
  local uniqueIDRole = net.ReadInt( 16 )
  SetRole( ply, uniqueIDRole )
  SetRolVals( ply )
end)

function isWhitelisted( ply, id )
  local _plyAllowed = dbSelect( "yrp_role_whitelist", "*", "SteamID = '" .. ply:SteamID() .. "' AND roleID = " .. id )
  if ply:IsSuperAdmin() or ply:IsAdmin() then
    return true
  else
    if worked( _plyAllowed ) then
      return true
    else
      return false
    end
  end
end

util.AddNetworkString( "voteNo" )
net.Receive( "voteNo", function( len, ply )
  ply:SetNWString( "voteStatus", "no" )
end)

util.AddNetworkString( "voteYes" )
net.Receive( "voteYes", function( len, ply )
  ply:SetNWString( "voteStatus", "yes" )
end)

local voting = false
local votePly = nil
local voteCount = 30
function startVote( ply, table )
  if !voting then
    voting = true
    for k, v in pairs( player.GetAll() ) do
      v:SetNWString( "voteStatus", "not voted" )
      v:SetNWBool( "voting", true )
      v:SetNWString( "voteQuestion", ply:RPName() .. " want the role: " .. table[1].roleID )
    end
    votePly = ply
    voteCount = 30
    timer.Create( "voteRunning", 1, 0, function()
      for k, v in pairs( player.GetAll() ) do
        v:SetNWInt( "voteCD", voteCount )
      end
      if voteCount <= 0 then
        voting = false
        local _yes = 0
        local _no = 0
        for k, v in pairs( player.GetAll() ) do
          v:SetNWBool( "voting", false )
          if v:GetNWString( "voteStatus", "not voted" ) == "yes" then
            _yes = _yes + 1
          elseif v:GetNWString( "voteStatus", "not voted" ) == "no" then
            _no = _no + 1
          end
        end
        if _yes > _no and ( _yes + _no ) > 1 then
          --setRole( votePly:SteamID(), table[1].uniqueID )
        else
          printGM( "note", "VOTE: not enough yes" )
        end
        timer.Remove( "voteRunning" )
      end
      voteCount = voteCount - 1
    end)
  else
    printGM( "note", "a vote is currently running" )
  end
end

function canGetRole( ply, roleID )
  local tmpTableRole = dbSelect( "yrp_roles" , "*", "uniqueID = " .. roleID )

  if worked( tmpTableRole ) then
    local tmpTableGroup = sql.Query( "SELECT * FROM yrp_groups WHERE uniqueID = " .. tmpTableRole[1].groupID )
    if tmpTableRole[1].uses < tmpTableRole[1].maxamount or tonumber( tmpTableRole[1].maxamount ) == -1 then
      if tmpTableRole[1].adminonly == 1 then
        printGM( "user", "Adminonly-Role" )
        if ply:IsAdmin() or ply:IsSuperAdmin() then
          -- continue
        else
          printGM( "user", "ADMIN-ONLY Role: " .. ply:Nick() .. " is not admin or superadmin" )
          return false
        end
      elseif tonumber( tmpTableRole[1].whitelist ) == 1 then
        printGM( "user", "Whitelist-Role" )
        if tonumber( tmpTableRole[1].voteable ) == 1 then
          printGM( "user", "Voteable-Role" )
          if !isWhitelisted( ply, roleID ) then
            printGM( "user", "Start-Whitelist Vote" )
            startVote( ply, tmpTableRole )
            return false
          else
            printGM( "user", ply:Nick() .. " already whitelisted" )
          end
        else
          printGM( "user", "No Voteable-Role" )
          if !isWhitelisted( ply, roleID ) then
            printGM( "user", ply:Nick() .. " is not whitelisted" )
            return false
          else
            printGM( "user", ply:Nick() .. " is whitelisted" )
          end
        end
      end
    end
    return true
  end
  return false
end

net.Receive( "wantRole", function( len, ply )
  local uniqueIDRole = net.ReadInt( 16 )

  if canGetRole( ply, uniqueIDRole ) then

    SetRole( ply, uniqueIDRole )

    SetRolVals( ply )
  end
end)
