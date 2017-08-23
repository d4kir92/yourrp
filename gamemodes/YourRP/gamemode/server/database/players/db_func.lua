//Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local metaPly = FindMetaTable( "Player" )

function metaPly:SteamName()
  return self:GetName()
end

function metaPly:RPName()
  local rpName = self:GetNWString( "SurName", "" ) .. ", " .. self:GetNWString( "FirstName", "" )
  return rpName
end

function metaPly:Nick()
  return self:SteamName() .. " [" .. self:RPName() .. "]"
end

function metaPly:isCP()
  print("FAKE Function")
  return false
end

function metaPly:updateMoney( money )
  dbUpdate( "yrp_players", "money = " .. money, "steamID = '" .. self:SteamID().. "'")
end

function metaPly:updateMoneyBank( money )
  dbUpdate( "yrp_players", "moneybank = " .. money, "steamID = '" .. self:SteamID().. "'")
end

function metaPly:canAfford( money )
  local _tmpMoney = tonumber( money )
  if isnumber( _tmpMoney ) then
    if _tmpMoney > 0 then
      return true
    elseif tonumber( self:GetNWInt( "money" ) ) >= math.abs( _tmpMoney ) then
      return true
    else
      return false
    end
  end
end

function metaPly:addMoney( money )
  if isnumber( money ) then
    if self:canAfford( money ) then
      self:SetNWInt( "money", self:GetNWInt( "money" ) + math.Round( money, 2 ) )
      self:updateMoney( self:GetNWInt( "money" ) )
    else
      printGM( "note", self:Nick() .. " cant afford this" )
    end
  end
end

function metaPly:setMoney( money )
  if isnumber( money ) then
    if self:canAfford( money ) then
      self:SetNWInt( "money", math.Round( money, 2 ) )
      self:updateMoney( self:GetNWInt( "money" ) )
    else
      printGM( "note", self:Nick() .. " cant afford this" )
    end
  end
end

function metaPly:canAffordBank( money )
  local _tmpMoney = tonumber( money )
  if isnumber( _tmpMoney ) then
    if _tmpMoney > 0 then
      return true
    elseif tonumber( self:GetNWInt( "moneybank" ) ) >= math.abs( _tmpMoney ) then
      return true
    else
      return false
    end
  end
end

function metaPly:addMoneyBank( money )
  if isnumber( money ) then
    if self:canAffordBank( money ) then
      self:SetNWInt( "moneybank", self:GetNWInt( "moneybank" ) + math.Round( money, 2 ) )
      self:updateMoneyBank( self:GetNWInt( "moneybank" ) )
    else
      printGM( "note", self:Nick() .. " cant afford this, BANK" )
    end
  end
end

function getMonth()
  return tonumber( os.date( "%m" , os.time() ) )
end

function getYear()
  return tonumber( os.date( "%Y" , os.time() ) )
end

function awayFor( ply )
  local tmpTable = sql.Query( "SELECT timestamp FROM yrp_players WHERE steamID = '" .. ply:SteamID() .. "'" )
  if tmpTable != nil and tmpTable != false then
    local tmpTimeStamp = tmpTable[1].timestamp

    local tmpAway = os.time() - tmpTimeStamp
    local tmpString = ""
    if tmpAway > 0 then
      tmpString = ply:Nick() .. " was away for " .. string.NiceTime( tmpAway )
      printGM( "gm", tmpString )
    end

    return tmpAway
  else
    //Table Empty
  end
end

function saveClients( string )
  for k, ply in pairs( player.GetAll() ) do
    local q = ""
    q = q .. "UPDATE yrp_players "
    q = q .. "SET "
    if ply:Alive() then
      q = q .. "position = '" .. tostring( ply:GetPos() ) .. "', "
      q = q .. "angle = '" .. tostring( ply:EyeAngles() ) .. "', "
    end
    q = q .. "money = " .. ply:GetNWInt( "money") .. ", "
    q = q .. "map = '" .. string.lower( game.GetMap() ) .. "', "
    q = q .. "timestamp = " .. os.time() .. " "
    q = q .. "WHERE "
    q = q .. "steamID = '" .. ply:SteamID() .. "'"
    sql.Query( q )
    awayFor( ply )
  end
  printGM( "db", "Saved " .. player.GetCount() .. " Clients." )
end

function updateUses()
  local tmpTableRoles = sql.Query( "SELECT * FROM yrp_roles" )
  if tmpTableRoles != false then
    local tmpTablePlayers = sql.Query( "SELECT * FROM yrp_players" )
    if tmpTablePlayers != false and tmpTablePlayers != nil then
      for k, v in pairs( tmpTableRoles ) do
        v.uses = 0
      end

      for k, v in pairs( tmpTableRoles ) do
        for l, w in pairs( tmpTablePlayers ) do
          if w.roleID == v.uniqueID then
            v.uses = v.uses + 1
          end
        end
      end

      for k, v in pairs( tmpTableRoles ) do
        local tmpResult = sql.Query( "UPDATE yrp_roles SET uses = " .. v.uses .. " WHERE uniqueID = '" .. v.uniqueID .. "'" )
      end
    end
  end
end

function GM:PlayerSetModel( ply )
  local tmpRoleID = sql.Query( "SELECT roleID FROM yrp_players WHERE steamID = '" .. ply:SteamID() .. "'" )
  if tmpRoleID != nil then
    local tmpRolePlayermodel = sql.Query( "SELECT playermodel, playermodelsize FROM yrp_roles WHERE uniqueID = '" .. tmpRoleID[1].roleID .. "'" )
    if tmpRolePlayermodel != nil and tmpRolePlayermodel != false then
    	ply:SetModel( tmpRolePlayermodel[1].playermodel )
      local modelsize = tonumber( tmpRolePlayermodel[1].playermodelsize )
      yrpSetModelScale( ply, modelsize )
    end
  end
end

function GM:PlayerLoadout( ply )
  ply:Give( "yrp_key" )

  addKeys( ply )

  setRoleValues( ply )
  teleportToSpawnpoint( ply )
  timer.Simple( 1,function()
    //local hullMins = ply:OBBMins()/2
    //local hullMaxs = ply:OBBMaxs()/2
    //ply:SetHull( hullMins, hullMaxs )
  end)
end

function setPlyPos( ply, map, pos, ang )
  ply:KillSilent()

  ply:Spawn()
  timer.Simple( 0.1, function()
    if map == game.GetMap() then
      local tmpPos = string.Split( pos, " " )
      ply:SetPos( Vector( tonumber( tmpPos[1] ), tonumber( tmpPos[2] ), tonumber( tmpPos[3] ) ) )

      local tmpAng = string.Split( ang, " " )
      ply:SetEyeAngles( Angle( tonumber( tmpAng[1] ), tonumber( tmpAng[2] ), tonumber( tmpAng[3] ) ) )
    else
      printGM( "db", ply:Nick() .. " is new on this map" )
    end
  end)
end

function updateHud( ply )
  local q3 = ""
  q3 = q3 .. "SELECT * FROM yrp_players WHERE steamID = '" .. ply:SteamID() .. "'"
  local plyValues = sql.Query( q3 )
  if plyValues != nil and plyValues != false then
    ply:SetNWInt( "money", plyValues[1].money )
    ply:SetNWInt( "moneybank", plyValues[1].moneybank )
    ply:SetNWInt( "capital", plyValues[1].capital )
    ply:SetNWString( "SurName", plyValues[1].nameSur )
    ply:SetNWString( "FirstName", plyValues[1].nameFirst )

    local tmpRoleID = sql.Query( "SELECT * FROM yrp_roles WHERE uniqueID = " .. plyValues[1].roleID )
    if tmpRoleID != nil then
      ply:SetNWString( "roleID", tmpRoleID[1].roleID )
    else
      tmpRoleID = sql.Query( "SELECT * FROM yrp_roles WHERE uniqueID = 1" )
      if tmpRoleID != nil then
        ply:SetNWString( "roleName", tmpRoleID[1].roleID )
        ply:SetNWString( "roleUniqueID", tmpRoleID[1].uniqueID )
      end
    end
    if tmpRoleID != nil then
      local tmpGroupID = sql.Query( "SELECT * FROM yrp_groups WHERE uniqueID = " .. tmpRoleID[1].groupID )
      if tmpGroupID != nil then
        ply:SetNWString( "groupName", tmpGroupID[1].groupID )
        ply:SetNWString( "groupUniqueID", tmpGroupID[1].uniqueID )
      end
    end
  else
    //
  end

  local _moneyTable = dbSelect( "yrp_money", "*", nil )
  for k, v in pairs( _moneyTable ) do
    if v.name == "moneypre" then
      ply:SetNWString( "moneyPre", v.value )
    elseif v.name == "moneypost" then
      ply:SetNWString( "moneypost", v.value )
    end
  end
end

function checkClient( ply )
  printGM( "db", "checkClient: " .. ply:SteamName() .. " (" .. ply:SteamID() .. ")" )
  awayFor( ply )

  local query = ""
  query = query .. "SELECT * FROM yrp_players WHERE steamID = '" .. ply:SteamID() .. "'"
  local result = sql.Query( query )

  if !result then
    printGM( "db", ply:SteamName() .. " is not in db: yrp_players, creating " .. ply:SteamName() )

    ply:KillSilent()
    
    local q2 = ""
    q2 = q2 .. "INSERT INTO yrp_players ( steamID, nick, roleID, map ) "
    q2 = q2 .. "VALUES ( "
    q2 = q2 .. "'" .. tostring( ply:SteamID() ) .. "', "
    q2 = q2 .. "'" .. tostring( ply:Nick() ) .. "', "
    q2 = q2 .. "1, "
    q2 = q2 .. "'" .. string.lower( game.GetMap() ) .. "' "
    q2 = q2 .. " )"
    sql.Query( q2 )

    printGM( "db", "Give new player " .. ply:SteamName() .. " the StartMoney." )
    local _moneyTable = dbSelect( "yrp_money", "*", nil )
    for k, v in pairs( _moneyTable ) do
      if v.name == "moneystart" then
        ply:SetNWInt( "money", v.value )
        dbUpdate( "yrp_players", "money = " .. v.value, "steamID = '" .. ply:SteamID() .. "'" )
        break
      end
    end

    net.Start( "openCharakterMenu" )
    net.Send( ply )
  else
    if result[1].nameSur == "ID_SURNAME" or result[1].nameFirst == "ID_FIRSTNAME" then
      net.Start( "openCharakterMenu" )
      net.Send( ply )
    end

    local q3 = ""
    q3 = q3 .. "SELECT * FROM yrp_players WHERE steamID = '" .. ply:SteamID() .. "'"
    local plyValues = sql.Query( q3 )
    setPlyPos( ply, plyValues[1].map, plyValues[1].position, plyValues[1].angle )
  end

  updateHud( ply )

  updateGroupTable()

  saveClients( "Check Client" )
end
