--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function getMonth()
  return tonumber( os.date( "%m" , os.time() ) )
end

function getYear()
  return tonumber( os.date( "%Y" , os.time() ) )
end

function saveClients( string )
  printGM( "db", "saveClients start." )
  for k, ply in pairs( player.GetAll() ) do
    local q = ""
    q = q .. "UPDATE yrp_players "
    q = q .. "SET "
    q = q .. "timestamp = " .. os.time() .. " "
    q = q .. "WHERE "
    q = q .. "SteamID = '" .. ply:SteamID() .. "'"
    sql.Query( q )

    if ply:Alive() then
      local CharID = ply:CharID()
      local pos = "position = '" .. tostring( ply:GetPos() ) .. "'"
      dbUpdate( "yrp_characters", pos, "uniqueID = " .. CharID )

      local ang = "angle = '" .. tostring( ply:EyeAngles() ) .. "'"
      dbUpdate( "yrp_characters", ang, "uniqueID = " .. CharID )

      if ply:GetNWString( "money" ) != nil and ply:GetNWString( "money" ) != "" then
        local money = "money = '" .. ply:GetNWString( "money" ) .. "'"
        dbUpdate( "yrp_characters", money, "uniqueID = " .. CharID )
      end

      if ply:GetNWString( "moneybank" ) != nil and ply:GetNWString( "moneybank" ) != ""  then
        local moneybank = "moneybank = '" .. ply:GetNWString( "moneybank" ) .. "'"
        dbUpdate( "yrp_characters", moneybank, "uniqueID = " .. CharID )
      end

      if string.lower( game.GetMap() ) != nil and string.lower( game.GetMap() ) != "" then
        local map = "map = '" .. string.lower( game.GetMap() ) .. "'"
        dbUpdate( "yrp_characters", map, "uniqueID = " .. CharID )
      end
    end
  end
  printGM( "db", "saveClients done: Saved " .. player.GetCount() .. " Client(s)." )
end

function GM:PlayerSetModel( ply )
  local tmpRolePlayermodel = ply:GetPlayerModel()
  if tmpRolePlayermodel != nil and tmpRolePlayermodel != false then
    ply:SetModel( tmpRolePlayermodel )
  else
    ply:SetModel( "models/player/skeleton.mdl" )
  end
end

function SetRole( ply, rid )
  local result = dbUpdate( "yrp_characters", "roleID = " .. rid, "uniqueID = " .. ply:CharID() )
  local gid = dbSelect( "yrp_roles", "*", "uniqueID = " .. rid )
  gid = gid[1].groupID
  local result2 = dbUpdate( "yrp_characters", "groupID = " .. gid, "uniqueID = " .. ply:CharID() )
  local result3 = dbUpdate( "yrp_characters", "playermodelID = " .. 1, "uniqueID = " .. ply:CharID() )
  local result4 = dbUpdate( "yrp_characters", "skin = 0, bg1 = 0, bg2 = 0, bg3 = 0, bg4 = 0", "uniqueID = " .. ply:CharID() )
  ply:SetSkin( 0 )
  for i=1, 4 do
    ply:SetBodygroup( i, 0 )
  end
end

function SetRolVals( ply )
  local rolTab = ply:GetRolTab()
  local groTab = ply:GetGroTab()
  local ChaTab = ply:GetChaTab()
  if worked( rolTab, "SetRolVals rolTab" ) and worked( ChaTab, "SetRolVals ChaTab" ) then
    if ChaTab.playermodelID != nil then
      local tmpID = tonumber( ChaTab.playermodelID )
      if rolTab.playermodels != nil and rolTab.playermodels != "" then
        local tmp = string.Explode( ",", rolTab.playermodels )
        if worked( tmp[tmpID], "SetRolVals playermodel" ) then
          ply:SetModel( tmp[tmpID] )
        end
      end
    end
  end
  if worked( rolTab, "SetRolVals rolTab" ) then
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

  SetRolVals( ply )

  if chaTab != nil then
    ply:SetMoney( tonumber( chaTab.money ) )
    ply:SetNWString( "moneybank", chaTab.moneybank )
    ply:SetNWString( "rpname", chaTab.rpname )

    ply:SetSkin( chaTab.skin )
    ply:SetBodygroup( 1, chaTab.bg1 )
    ply:SetBodygroup( 2, chaTab.bg2 )
    ply:SetBodygroup( 3, chaTab.bg3 )
    ply:SetBodygroup( 4, chaTab.bg4 )
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

  if ply:IsAdmin() or ply:IsSuperAdmin() then
    ply:Give( "yrp_arrest_stick" )
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

function addYrpPlayer( ply )
  local result = dbSelect( "yrp_players", "*", "SteamID = '" .. ply:SteamID() .. "'")

  if result == nil then
    printGM( "db", ply:SteamName() .. " is not in db: yrp_players, creating " .. ply:SteamName() )

    ply:KillSilent()

    local _SteamID = ply:SteamID()
    local _SteamID64 = ply:SteamID64() or ""
    local _SteamName = tostring( dbSQLStr( ply:SteamName() ) )
    local _ostime = os.time()

    local cols = "SteamID, "
    if !game.SinglePlayer() then
      cols = cols .. "SteamID64, "
    end
    cols = cols .. "SteamName, "
    cols = cols .. "Timestamp"

    local vals = "'" .. _SteamID .. "', "
    if !game.SinglePlayer() then
      vals = vals .. "'" .. _SteamID64 .. "', "
    end
    vals = vals .. "'" .. _SteamName .. "', "
    vals = vals .. "'" .. _ostime .. "'"

    local _insert = dbInsertInto( "yrp_players", cols, vals )
  elseif result != nil then
    if #result > 1 then
      for k, v in pairs( result ) do
        if k > 1 then
          dbDeleteFrom( "yrp_players", "uniqueID = " .. v.uniqueID )
        end
      end
    end
  end
end

function checkYrpPlayer( ply )
  printGM( "db", "checkYrpPlayer " .. ply:Nick() )

  if ply:SteamID64() != nil or game.SinglePlayer() then
    addYrpPlayer( ply )
  else
    timer.Simple( 1, function()
      checkYrpPlayer( ply )
    end)
  end
end

function checkYrpClient( ply )
  printGM( "db", "checkYRPClient: " .. ply:SteamName() .. " (" .. ply:SteamID() .. ")" )

  if ply:IPAddress() == "loopback" then
    ply:SetUserGroup( "superadmin" )
  end

  checkYrpPlayer( ply )

  openCharacterSelection( ply )

  saveClients( "Check Client" )
end
