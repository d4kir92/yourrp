--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local metaPly = FindMetaTable( "Player" )

function metaPly:updateMoney( money )
  self:UpdateMoney()
end

function metaPly:updateMoneyBank( money )
  self:UpdateMoney()
end

function metaPly:canAfford( money )
  local _tmpMoney = tonumber( money )
  if isnumber( _tmpMoney ) then
    if tonumber( self:GetNWInt( "money" ) ) >= math.abs( _tmpMoney ) then
      return true
    else
      return false
    end
  else
    return false
  end
end

function metaPly:addMoney( money )
  if isnumber( money ) then
    self:SetNWInt( "money", self:GetNWInt( "money" ) + math.Round( money, 2 ) )
    self:UpdateMoney()
  end
end

function metaPly:SetMoney( money )
  if isnumber( money ) then
    self:SetNWInt( "money", math.Round( money, 2 ) )
    self:UpdateMoney()
  end
end

function metaPly:canAffordBank( money )
  local _tmpMoney = tonumber( money )
  if isnumber( _tmpMoney ) then
    if tonumber( self:GetNWInt( "moneybank" ) ) >= math.abs( _tmpMoney ) then
      return true
    else
      return false
    end
  end
end

function metaPly:addMoneyBank( money )
  if isnumber( money ) then
    self:SetNWInt( "moneybank", self:GetNWInt( "moneybank" ) + math.Round( money, 2 ) )
    self:UpdateMoney()
  end
end

function getMonth()
  return tonumber( os.date( "%m" , os.time() ) )
end

function getYear()
  return tonumber( os.date( "%Y" , os.time() ) )
end

function saveClients( string )
  for k, ply in pairs( player.GetAll() ) do
    local q = ""
    q = q .. "UPDATE yrp_players "
    q = q .. "SET "
    q = q .. "timestamp = " .. os.time() .. " "
    q = q .. "WHERE "
    q = q .. "SteamID = '" .. ply:SteamID() .. "'"  --no SteamID64, why? -> on disconnect not available
    sql.Query( q )

    if ply:Alive() then
      local pos = tostring( ply:GetPos() )
      local ang = tostring( ply:EyeAngles() )
      local money = ply:GetNWInt( "money" )
      local map = string.lower( game.GetMap() )
      local result = dbUpdate( "yrp_characters", "position = '" .. pos .. "', angle = '" .. ang .. "', money = " .. money .. ", map = '" .. map .. "'", "uniqueID = " .. ply:CharID() )
    end

  end
  printGM( "db", "Saved " .. player.GetCount() .. " Clients." )
end

function GM:PlayerSetModel( ply )
  local tmpRolePlayermodel = ply:GetPlayerModel()
  if tmpRolePlayermodel != nil and tmpRolePlayermodel != false then
    ply:SetModel( tmpRolePlayermodel )
  else
    ply:SetModel( "models/player/skeleton.mdl" )
  end
end

function SetRolVals( ply, rolTab, groTab )
  local ChaTab = ply:GetChaTab()
  if worked( ChaTab, "SetRolVals ChaTab" ) then
    local tmpID = tonumber( ChaTab.playermodelID )
    local tmp = string.Explode( ",", rolTab.playermodels )
    if worked( tmp[tmpID], "SetRolVals playermodel" ) then
      ply:SetModel( tmp[tmpID] )
    end
  end
  ply:SetModelScale( rolTab.playermodelsize, 0 )
  ply:SetNWInt( "speedwalk", rolTab.speedwalk*rolTab.playermodelsize )
  ply:SetNWInt( "speedrun", rolTab.speedrun*rolTab.playermodelsize )
  ply:SetWalkSpeed( ply:GetNWInt( "speedwalk" ) )
  ply:SetRunSpeed( ply:GetNWInt( "speedrun" ) )
  ply:SetMaxHealth( tonumber( rolTab.hpmax ) )
  ply:SetHealth( tonumber( rolTab.hp ) )
  ply:SetNWInt( "GetHealthReg", tonumber( rolTab.hpreg ) )
  ply:SetNWInt( "GetMaxArmor", tonumber( rolTab.armax ) )
  ply:SetNWInt( "GetArmorReg", tonumber( rolTab.arreg ) )
  ply:SetArmor( tonumber( rolTab.ar ) )
  ply:SetJumpPower( tonumber( rolTab.powerjump ) * rolTab.playermodelsize )
  ply:SetNWInt( "capital", rolTab.capital )
  ply:SetNWString( "roleName", rolTab.roleID )
  ply:SetNWString( "roleUniqueID", rolTab.uniqueID )

  --sweps
  local tmpSWEPTable = string.Explode( ",", rolTab.sweps )
  for k, swep in pairs( tmpSWEPTable ) do
    if swep != nil and swep != NULL and swep != "" then
      ply:Give( swep )
    end
  end

  if groTab != nil then
    ply:SetNWString( "groupName", groTab.groupID )
    ply:SetNWString( "groupUniqueID", groTab.uniqueID )
  else
    printGM( "note", "give group failed" )
  end
end

function GM:PlayerLoadout( ply )
  ply:SetNWBool( "cuffed", false )

  ply:Give( "yrp_key" )
  ply:Give( "yrp_unarmed" )

  addKeys( ply )

  local plyTab = ply:GetPlyTab()
  local chaTab = ply:GetChaTab()
  local rolTab = ply:GetRolTab()
  local groTab = ply:GetGroTab()

  if worked( rolTab ) and worked( groTab ) then
    SetRolVals( ply, rolTab, groTab )
  else
    printGM( "note", "give role failed" )
    ply:KillSilent()
  end

  if chaTab != nil then
    ply:SetNWInt( "money", chaTab.money )
    ply:SetNWInt( "moneybank", chaTab.moneybank )
    ply:SetNWString( "rpname", chaTab.rpname )
  else
    printGM( "note", "give char failed" )
    ply:KillSilent()
  end

  ply:SetNWInt( "hunger", 100 )
  ply:SetNWInt( "thirst", 100 )
  ply:SetNWInt( "stamina", 100 )

  local monTab = dbSelect( "yrp_money", "*", nil )
  local monPre = monTab[1].value
  local monPos = monTab[2].value
  ply:SetNWString( "moneyPre", monPre )
  ply:SetNWString( "moneyPost", monPos )

  local yrp_general = dbSelect( "yrp_general", "*", nil )
  for k, v in pairs( yrp_general ) do
    if tostring( v.name ) == "metabolism" then
      ply:SetNWBool( "metabolism", tobool( v.value ) )
      break
    end
  end

  teleportToSpawnpoint( ply )
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

function openCharacterSelection( ply )
  printGM( "db", "openCharacterSelection(ply)")
  local tmpTable = dbSelect( "yrp_characters", "*", "SteamID = '" .. ply:SteamID() .. "'" )
  if tmpTable == nil then
    tmpTable = {}
  end
  net.Start( "openCharacterMenu" )
    net.WriteTable( tmpTable )
  net.Send( ply )
end

function checkClient( ply )
  printGM( "db", "checkClient: " .. ply:SteamName() .. " (" .. ply:SteamID() .. ")" )

  if ply:IPAddress() == "loopback" then
    ply:SetUserGroup( "superadmin" )
  end

  local result = dbSelect( "yrp_players", "*", "SteamID = '" .. ply:SteamID() .. "'")

  if !result then
    printGM( "db", ply:SteamName() .. " is not in db: yrp_players, creating " .. ply:SteamName() )

    ply:KillSilent()

    local q2 = "INSERT INTO yrp_players ( "
    if !game.SinglePlayer() then
      q2 = q2 .. "SteamID64, "
    end
    q2 = q2 .. "SteamID, SteamName, Timestamp ) "
    q2 = q2 .. "VALUES ( "
    if !game.SinglePlayer() then
      q2 = q2 .. "'" .. tostring( ply:SteamID64() ) .. "', "
    end
    q2 = q2 .. "'" .. tostring( ply:SteamID() ) .. "', "
    q2 = q2 .. "'" .. tostring( dbSQLStr( ply:SteamName() ) ) .. "', "
    q2 = q2 .. "'" .. os.time() .. "'"
    q2 = q2 .. " )"
    local result = sql.Query( q2 )
  else
    if #result > 1 then
      for k, v in pairs( result ) do
        if k > 1 then
          dbDeleteFrom( "yrp_players", "uniqueID = " .. v.uniqueID )
        end
      end
    end
  end
  openCharacterSelection( ply )

  saveClients( "Check Client" )
end
