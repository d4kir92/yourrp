--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

util.AddNetworkString( "charGetGroups" )
util.AddNetworkString( "charGetRoles" )
util.AddNetworkString( "charGetRoleInfo" )

util.AddNetworkString( "charGetCharacters" )

util.AddNetworkString( "DeleteCharacter" )
util.AddNetworkString( "CreateCharacter" )

util.AddNetworkString( "EnterWorld" )

local function PlayerInitialSpawn( ply )
  printGM( "gm", "PlayerInitialSpawn" )
	ply:KillSilent()
end
hook.Add( "PlayerInitialSpawn", "some_unique_name", PlayerInitialSpawn )

net.Receive( "charGetGroups", function( len, ply )
  local tmpTable = dbSelect( "yrp_groups", "*", nil )
  if tmpTable == nil then
    tmpTable = {}
  end
  net.Start( "charGetGroups" )
    net.WriteTable( tmpTable )
  net.Send( ply )
end)

net.Receive( "charGetRoles", function( len, ply )
  local groupID = net.ReadString()
  local netTable = {}
  local tmpTable = dbSelect( "yrp_roles", "*", "groupID = " .. groupID )
  if tmpTable != nil then
    local count = 1
    for k, v in pairs( tmpTable ) do
      local insert = true
      if tonumber( v.adminonly ) == 1 then
        if ply:IsAdmin() or ply:IsSuperAdmin() then
          insert = true
        else
          insert = false
        end
      else
        if tonumber( v.maxamount ) > 0 then
          if tonumber( v.uses ) < tonumber( v.maxamount ) then
            insert = true
          else
            insert = false
          end
        end
        if insert then
          if tonumber( v.whitelist ) == 1 then
            insert = isWhitelisted( ply, v.uniqueID )
          end
        end
      end
      if insert then
        netTable[count] = {}
        netTable[count] = v
        count = count + 1
      end
    end
  end
  net.Start( "charGetRoles" )
    net.WriteTable( netTable )
  net.Send( ply )
end)

net.Receive( "charGetRoleInfo", function( len, ply )
  local roleID = net.ReadString()
  local tmpTable = dbSelect( "yrp_roles", "*", "uniqueID = " .. roleID )
  if tmpTable == nil then
    tmpTable = {}
  end
  net.Start( "charGetRoleInfo" )
    net.WriteTable( tmpTable )
  net.Send( ply )
end)

net.Receive( "charGetCharacters", function( len, ply )
  printGM( "db", "charGetCharacters" )
  local netTable = {}

  local chaTab = dbSelect( "yrp_characters", "*", "SteamID = '" .. ply:SteamID() .. "'")

  local _charCount = 0
  if worked( chaTab, "charGetCharacters" ) then
    for k, v in pairs( chaTab ) do
      if worked( v.roleID, "charGetCharacters roleID" ) and worked( v.groupID, "charGetCharacters groupID" ) then
        _charCount = _charCount + 1
        netTable[_charCount] = {}
        netTable[_charCount].char = v
        local tmp = dbSelect( "yrp_roles", "*", "uniqueID = " .. v.roleID )
        if worked( tmp, "charGetCharacters role" ) then
          netTable[_charCount].role = tmp[1]
        end
        local tmp2 = dbSelect( "yrp_groups", "*", "uniqueID = " .. v.groupID )
        if worked( tmp2, "charGetCharacters group" ) then
          netTable[_charCount].group = tmp2[1]
        end
      end
    end
  end
  local plytab = ply:GetPlyTab()
  netTable.plytab = plytab

  net.Start( "charGetCharacters" )
    net.WriteTable( netTable )
  net.Send( ply )
end)

net.Receive( "DeleteCharacter", function( len, ply )
  local charID = net.ReadString()

  local result = dbDeleteFrom( "yrp_characters", "uniqueID = " .. charID )
  if result == nil then
    printGM( "db", "DeleteCharacter: success"  )
  else
    printGM( "note", "DeleteCharacter: fail"  )
  end
end)

net.Receive( "CreateCharacter", function( len, ply )
  local ch = net.ReadTable()

  local role = dbSelect( "yrp_roles", "*", "uniqueID = " .. ch.roleID )

  local cols = "SteamID, rpname, gender, roleID, groupID, playermodelID, money, moneybank, map, skin, bg1, bg2, bg3, bg4"
  local vals = "'" .. ply:SteamID() .. "', "
  vals = vals .. "'" .. ch.rpname .. "', "
  vals = vals .. "'" .. ch.gender .. "', "
  vals = vals .. role[1].uniqueID .. ", "
  vals = vals .. role[1].groupID .. ", "
  vals = vals .. "'" .. ch.playermodelID .. "', "
  vals = vals .. 250 .. ", "
  vals = vals .. 500 .. ", "
  vals = vals .. "'" .. game.GetMap() .. "', "
  vals = vals .. ch.skin .. ", "
  vals = vals .. ch.bg[2] .. ", "
  vals = vals .. ch.bg[3] .. ", "
  vals = vals .. ch.bg[4] .. ", "
  vals = vals .. ch.bg[5]
  dbInsertInto( "yrp_characters", cols, vals )

  local chars = dbSelect( "yrp_characters", "*", nil )
  if worked( chars ) then
    local result = dbUpdate( "yrp_players", "CurrentCharacter = " .. chars[#chars].uniqueID, "SteamID = '" .. ply:SteamID() .. "'" )
  end
end)

net.Receive( "EnterWorld", function( len, ply )
  local char = net.ReadString()
  local result = dbUpdate( "yrp_players", "CurrentCharacter = " .. char , "SteamID = '" .. ply:SteamID() .. "'" )
  ply:Spawn()
end)
