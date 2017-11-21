--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_map.lua

local _db_name = "yrp_" .. string.lower( game.GetMap() ) .. "_doors"
sql_add_column( _db_name, "buildingID", "INTEGER DEFAULT -1" )
sql_add_column( _db_name, "level", "INTEGER DEFAULT 1" )
sql_add_column( _db_name, "keynr", "INTEGER DEFAULT -1" )

--db_drop_table( _db_name )
--db_is_empty( _db_name )

_db_name = "yrp_" .. string.lower( game.GetMap() ) .. "_buildings"
sql_add_column( _db_name, "groupID", "INTEGER DEFAULT -1" )
sql_add_column( _db_name, "buildingprice", "TEXT DEFAULT 100" )
sql_add_column( _db_name, "ownerCharID", "TEXT DEFAULT ''" )
sql_add_column( _db_name, "name", "TEXT DEFAULT 'Building'" )

--db_drop_table( _db_name )
--db_is_empty( _db_name )

function allowedToUseDoor( id, ply )
  if ply:IsSuperAdmin() or ply:IsAdmin() then
    return true
  else
    local _tmpBuildingTable = db_select( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings", "*", "uniqueID = '" .. id .. "'" )
    if _tmpBuildingTable[1] != nil then

      if tostring( _tmpBuildingTable[1].ownerCharID ) == "" and tonumber( _tmpBuildingTable[1].groupID ) == -1 then
        return true
      else
        local _tmpChaTab = db_select( "yrp_characters", "*", "uniqueID = " .. _tmpBuildingTable[1].ownerCharID )
        local _tmpGroupTable = db_select( "yrp_groups", "*", "uniqueID = " .. _tmpChaTab[1].groupID )

        if tostring( _tmpBuildingTable[1].ownerCharID ) == tostring( ply:CharID() ) or tonumber( _tmpBuildingTable[1].groupID ) == tonumber( _tmpGroupTable[1].uniqueID ) then
          return true
        else
          return false
        end
      end
    else
      return false
    end
  end
end

function addKeys( ply )
  if ply:IsPlayer() then
    for k, v in pairs( ply:GetWeapons() ) do
      if v.ClassName == "yrp_key" then
        local _charID = ply:CharID()
        if _charID != nil then
          local _tmpTable = db_select( "yrp_characters", "keynrs", "uniqueID = " .. ply:CharID() )
          if worked( _tmpTable, "addKeys 1" ) then
            _tmpTable = string.Explode( ",", _tmpTable[1].keynrs )
            for l, w in pairs( _tmpTable ) do
              if worked( w, "addKeys 2" ) and w != "" then
                v:AddKeyNr( w )
              end
            end
          end
        end
        break
      end
    end
  end
end

function searchForDoors()
  printGM( "db", "Search Map for Doors/Buildings" )

  local _allPropDoors = ents.FindByClass( "prop_door_rotating" )
  for k, v in pairs( _allPropDoors ) do
    db_insert_into_DEFAULTVALUES( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings" )

    local _tmpBuildingTable = db_select( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings", "*", nil )
    db_insert_into( "yrp_" .. string.lower( game.GetMap() ) .. "_doors", "buildingID", "" .. _tmpBuildingTable[#_tmpBuildingTable].uniqueID .. "" )

    local _tmpDoorsTable = db_select( "yrp_" .. string.lower( game.GetMap() ) .. "_doors", "*", nil )
  end

  local _allFuncDoors = ents.FindByClass( "func_door" )
  for k, v in pairs( _allFuncDoors ) do
    db_insert_into_DEFAULTVALUES( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings" )

    local _tmpBuildingTable = db_select( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings", "*", nil )
    db_insert_into( "yrp_" .. string.lower( game.GetMap() ) .. "_doors", "buildingID", "" .. _tmpBuildingTable[#_tmpBuildingTable].uniqueID .. "" )

    local _tmpDoorsTable = db_select( "yrp_" .. string.lower( game.GetMap() ) .. "_doors", "*", nil )
  end

  local _allFuncRDoors = ents.FindByClass( "func_door_rotating" )
  for k, v in pairs( _allFuncRDoors ) do
    db_insert_into_DEFAULTVALUES( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings" )

    local _tmpBuildingTable = db_select( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings", "*", nil )
    db_insert_into( "yrp_" .. string.lower( game.GetMap() ) .. "_doors", "buildingID", "" .. _tmpBuildingTable[#_tmpBuildingTable].uniqueID .. "" )

    local _tmpDoorsTable = db_select( "yrp_" .. string.lower( game.GetMap() ) .. "_doors", "*", nil )
  end

  printGM( "db", "Done finding them (" .. #_allPropDoors+#_allFuncDoors+#_allFuncRDoors .. " found)" )
  return #_allPropDoors+#_allFuncDoors+#_allFuncRDoors
end

function loadDoors()
  printGM( "note", "loadDoors start!")
  local _allPropDoors = ents.FindByClass( "prop_door_rotating" )
  local _allFuncDoors = ents.FindByClass( "func_door" )
  local _allFuncRDoors = ents.FindByClass( "func_door_rotating" )
  local _tmpDoors = db_select( "yrp_" .. string.lower( game.GetMap() ) .. "_doors", "*", nil )
  local _count = 0
  if worked( _tmpDoors, "_tmpDoors empty" ) then
    for k, v in pairs( _allPropDoors ) do
      if worked( _tmpDoors[k], "loadDoors 2" ) then
        v:SetNWInt( "buildingID", tonumber( _tmpDoors[k].buildingID ) )
        v:SetNWInt( "uniqueID", k )
      else
        printGM( "note", "more doors, then in list!" )
      end
      _count = k
    end
    for k, v in pairs( _allFuncDoors ) do
      if _tmpDoors[k+_count] != nil then
        v:SetNWInt( "buildingID", tonumber( _tmpDoors[k+_count].buildingID ) )
        v:SetNWInt( "uniqueID", k+_count )
      else
        printGM( "note", "more doors, then in list!" )
      end
    end
    for k, v in pairs( _allFuncRDoors ) do
      if _tmpDoors[k+_count] != nil then
        v:SetNWInt( "buildingID", tonumber( _tmpDoors[k+_count].buildingID ) )
        v:SetNWInt( "uniqueID", k+_count )
      else
        printGM( "note", "more doors, then in list!" )
      end
    end
  end

  local _tmpBuildings = db_select( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings", "*", nil )
  for k, v in pairs( _allPropDoors ) do
    for l, w in pairs( _tmpBuildings ) do
      if tonumber( w.uniqueID ) == tonumber( v:GetNWInt( "buildingID" ) ) then
        if w.ownerCharID != "" then

          local _tmpRPName = db_select( "yrp_characters", "*", "uniqueID = " .. w.ownerCharID )
          if _tmpRPName != nil then
            _tmpRPName = _tmpRPName[1]
            if _tmpRPName.rpname != nil then
              v:SetNWString( "ownerRPName", _tmpRPName.rpname )
            end
          end
        else
          if tonumber( w.groupID ) != -1 then
            local _tmpGroupName = db_select( "yrp_groups", "groupID", "uniqueID = " .. w.groupID )
            if _tmpGroupName != nil then
              _tmpGroupName = _tmpGroupName[1]
              if _tmpGroupName != nil then
                v:SetNWString( "ownerGroup", tostring( _tmpGroupName[1].groupID ) )
              end
            end
          end
        end
        break
      end
    end
  end

  printGM( "note", "loadDoors complete!")
end

function check_map_doors()
  printGM( "db", "check_map_doors()" )
  local _tmpTable = db_select( "yrp_" .. string.lower( game.GetMap() ) .. "_doors", "*", nil )
  local _tmpTable2 = db_select( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings", "*", nil )
  local amountDoors = 0
  if _tmpTable == nil or _tmpTable2 == nil then
    amountDoors = searchForDoors()
  else
    printGM( "db", "yrp_" .. string.lower( game.GetMap() ) .. "_doors: found Doors" )
    local _allPropDoors = ents.FindByClass( "prop_door_rotating" )
    local _allFuncDoors = ents.FindByClass( "func_door" )
    local _allFuncRDoors = ents.FindByClass( "func_door_rotating" )
    if ( #_tmpTable ) < ( #_allPropDoors + #_allFuncDoors + #_allFuncRDoors ) then
      printGM( "db", "yrp_" .. string.lower( game.GetMap() ) .. "_doors: new doors found!" )
      amountDoors = searchForDoors()
    end
  end

  loadDoors()
end

util.AddNetworkString( "getBuildingInfo")
util.AddNetworkString( "getBuildings" )
util.AddNetworkString( "changeBuildingName" )
util.AddNetworkString( "changeBuildingID" )
util.AddNetworkString( "changeBuildingPrice" )

util.AddNetworkString( "getBuildingGroups")

util.AddNetworkString( "setBuildingOwnerGroup" )

util.AddNetworkString( "buyBuilding" )
util.AddNetworkString( "removeOwner" )
util.AddNetworkString( "sellBuilding" )

util.AddNetworkString( "createKey" )
util.AddNetworkString( "resetKey" )

util.AddNetworkString( "lockDoor" )

function canLock( ent, nr )
  local _tmpTable = db_select( "yrp_" .. string.lower( game.GetMap() ) .. "_doors", "keynr", "buildingID = " .. ent:GetNWInt( "buildingID" ) )
  if _tmpTable != nil then
    if _tmpTable[1] != nil then
      if _tmpTable[1].keynr == nr then
        return true
      else
        return false
      end
    end
  end
  return false
end

function unlockDoor( ent, nrs )
  for k, v in pairs( nrs ) do
    if canLock( ent, v ) then
      ent:Fire( "Unlock" )
      return true
    end
  end
  return false
end

function lockDoor( ent, nrs )
  for k, v in pairs( nrs ) do
    if canLock( ent, v ) then
      ent:Fire( "Lock", "", 0 )
      return true
    end
  end
  return false
end

function createKey( ent, id )
  local _tmp = id
  _tmp = _tmp .. math.Round( math.Rand( 100000, 999999 ), 0 )
  ent.keynr = _tmp
  db_update( "yrp_" .. string.lower( game.GetMap() ) .. "_doors", "keynr = " .. _tmp, "buildingID = " .. id )
  return _tmp
end

function getNumber( ent, id )
  if ent.keynr == nil then
    ent.keynr = createKey( ent, id )
  end
  return ent.keynr
end

net.Receive( "resetKey", function( len, ply )
  local _door = net.ReadEntity()
  local _tmpBuildingID = net.ReadInt( 16 )

  createKey( _door, _tmpBuildingID )
end)

net.Receive( "createKey", function( len, ply )
  local _door = net.ReadEntity()
  local _tmpBuildingID = net.ReadInt( 16 )

  for k, v in pairs( ply:GetWeapons() ) do
    if v.ClassName == "yrp_key" then

      local _keynr = getNumber( _door, _tmpBuildingID )
      local _oldkeynrs = db_select( "yrp_characters", "keynrs", "uniqueID = " .. ply:CharID() )
      local _tmpTable = string.Explode( ",", _oldkeynrs[1].keynrs )

      local hasValue = table.HasValue( _tmpTable, _keynr )

      if !hasValue then
        v:AddKeyNr( _keynr )

        local _newkeynrs = ""
        for l, w in pairs( _tmpTable ) do
          if w != "" then
            _newkeynrs = _newkeynrs .. w
            _newkeynrs = _newkeynrs .. ","
          end
        end
        _newkeynrs = _newkeynrs .. _keynr

        db_update( "yrp_characters", "keynrs = '" .. _newkeynrs .. "'", "uniqueID = " .. ply:CharID() )
      else
        printGM( "note", "Key already exists")
      end
      break
    end
  end
end)

net.Receive( "removeOwner", function( len, ply )
  local _tmpBuildingID = net.ReadInt( 16 )
  local _tmpTable = db_select( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings", "*", "uniqueID = '" .. _tmpBuildingID .. "'" )

  local result = db_update( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings", "ownerCharID = '', groupID = -1", "uniqueID = '" .. _tmpBuildingID .. "'" )

  local _tmpDoors = ents.FindByClass( "prop_door_rotating" )
  for k, v in pairs( _tmpDoors ) do
    if tonumber( v:GetNWInt( "buildingID" ) ) == tonumber( _tmpBuildingID ) then
      v:SetNWString( "ownerRPName", "" )
      v:SetNWString( "ownerGroup", "" )
      createKey( v, _tmpBuildingID )
    end
  end
  local _tmpFDoors = ents.FindByClass( "func_door" )
  for k, v in pairs( _tmpFDoors ) do
    if tonumber( v:GetNWInt( "buildingID" ) ) == tonumber( _tmpBuildingID ) then
      v:SetNWString( "ownerRPName", "" )
      v:SetNWString( "ownerGroup", "" )
      createKey( v, _tmpBuildingID )
    end
  end
  local _tmpFRDoors = ents.FindByClass( "func_door_rotating" )
  for k, v in pairs( _tmpFRDoors ) do
    if tonumber( v:GetNWInt( "buildingID" ) ) == tonumber( _tmpBuildingID ) then
      v:SetNWString( "ownerRPName", "" )
      v:SetNWString( "ownerGroup", "" )
      createKey( v, _tmpBuildingID )
    end
  end
end)

net.Receive( "sellBuilding", function( len, ply )
  local _tmpBuildingID = net.ReadInt( 16 )
  local _tmpTable = db_select( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings", "*", "uniqueID = '" .. _tmpBuildingID .. "'" )

  db_update( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings", "ownerCharID = '', groupID = -1", "uniqueID = '" .. _tmpBuildingID .. "'" )
  local _tmpDoors = ents.FindByClass( "prop_door_rotating" )

  for k, v in pairs( _tmpDoors ) do
    if tonumber( v:GetNWInt( "buildingID" ) ) == tonumber( _tmpBuildingID ) then
      v:SetNWString( "ownerRPName", "" )
      v:SetNWString( "ownerGroup", "" )
      createKey( v, _tmpBuildingID )
      v:Fire("Unlock")
      db_update( "yrp_" .. string.lower( game.GetMap() ) .. "_doors", "keynr = -1", "buildingID = " .. tonumber( v:GetNWInt( "buildingID" ) ) )
    end
  end

  local _tmpFDoors = ents.FindByClass( "func_door" )

  for k, v in pairs( _tmpFDoors ) do
    if tonumber( v:GetNWInt( "buildingID" ) ) == tonumber( _tmpBuildingID ) then
      v:SetNWString( "ownerRPName", "" )
      v:SetNWString( "ownerGroup", "" )
      createKey( v, _tmpBuildingID )
      v:Fire("Unlock")
      db_update( "yrp_" .. string.lower( game.GetMap() ) .. "_doors", "keynr = -1", "buildingID = " .. tonumber( v:GetNWInt( "buildingID" ) ) )
    end
  end

  local _tmpFRDoors = ents.FindByClass( "func_door_rotating" )

  for k, v in pairs( _tmpFRDoors ) do
    if tonumber( v:GetNWInt( "buildingID" ) ) == tonumber( _tmpBuildingID ) then
      v:SetNWString( "ownerRPName", "" )
      v:SetNWString( "ownerGroup", "" )
      createKey( v, _tmpBuildingID )
      v:Fire("Unlock")
      db_update( "yrp_" .. string.lower( game.GetMap() ) .. "_doors", "keynr = -1", "buildingID = " .. tonumber( v:GetNWInt( "buildingID" ) ) )
    end
  end

  ply:addMoney( ( _tmpTable[1].buildingprice / 2 ) )
end)

net.Receive( "buyBuilding", function( len, ply )
  if ply:GetNWBool( "toggle_building", false ) then
    local _tmpBuildingID = net.ReadInt( 16 )
    local _tmpTable = db_select( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings", "*", "uniqueID = '" .. _tmpBuildingID .. "'" )

    if ply:canAfford( _tmpTable[1].buildingprice ) and _tmpTable[1].ownerCharID == "" and tonumber( _tmpTable[1].groupID ) == -1 then
      ply:addMoney( - ( _tmpTable[1].buildingprice ) )
      db_update( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings", "ownerCharID = '" .. ply:CharID() .. "'", "uniqueID = '" .. _tmpBuildingID .. "'" )
      local _tmpDoors = ents.FindByClass( "prop_door_rotating" )
      local _tmpPlys = db_select( "yrp_characters", "rpname", "uniqueID = " .. ply:CharID() )
      for k, v in pairs( _tmpDoors ) do
        if tonumber( v:GetNWInt( "buildingID" ) ) == tonumber( _tmpBuildingID ) then
          v:SetNWString( "ownerRPName", _tmpPlys[1].rpname )
        end
      end
      local _tmpFDoors = ents.FindByClass( "func_door" )
      for k, v in pairs( _tmpFDoors ) do
        if tonumber( v:GetNWInt( "buildingID" ) ) == tonumber( _tmpBuildingID ) then
          v:SetNWString( "ownerRPName", _tmpPlys[1].rpname )
        end
      end
      local _tmpFRDoors = ents.FindByClass( "func_door_rotating" )
      for k, v in pairs( _tmpFRDoors ) do
        if tonumber( v:GetNWInt( "buildingID" ) ) == tonumber( _tmpBuildingID ) then
          v:SetNWString( "ownerRPName", _tmpPlys[1].rpname )
        end
      end

      printGM( "user", ply:RPName() .. " has buyed a door")
    else
      printGM( "user", ply:RPName() .. " has not enough money to buy door")
    end
  else
    printGM( "note", "buildings disabled" )
  end
end)

net.Receive( "setBuildingOwnerGroup", function( len, ply )
  local _tmpBuildingID = net.ReadInt( 16 )
  local _tmpGroupID = net.ReadInt( 16 )

  db_update( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings", "groupID = " .. _tmpGroupID, "uniqueID = " .. _tmpBuildingID )

  local _tmpGroupName = db_select( "yrp_groups", "groupID", "uniqueID = " .. _tmpGroupID )
  local _tmpDoors = ents.FindByClass( "prop_door_rotating" )
  for k, v in pairs( _tmpDoors ) do
    if tonumber( v:GetNWInt( "buildingID" ) ) == tonumber( _tmpBuildingID ) then
      v:SetNWString( "ownerGroup", _tmpGroupName[1].groupID )
    end
  end
  local _tmpFDoors = ents.FindByClass( "func_door" )
  for k, v in pairs( _tmpFDoors ) do
    if tonumber( v:GetNWInt( "buildingID" ) ) == tonumber( _tmpBuildingID ) then
      v:SetNWString( "ownerGroup", _tmpGroupName[1].groupID )
    end
  end
  local _tmpFRDoors = ents.FindByClass( "func_door_rotating" )
  for k, v in pairs( _tmpFRDoors ) do
    if tonumber( v:GetNWInt( "buildingID" ) ) == tonumber( _tmpBuildingID ) then
      v:SetNWString( "ownerGroup", _tmpGroupName[1].groupID )
    end
  end
end)

net.Receive( "getBuildingGroups", function( len, ply )
  local _tmpTable = db_select( "yrp_groups", "*", nil )

  net.Start( "getBuildingGroups" )
    net.WriteTable( _tmpTable )
  net.Send( ply )
end)

net.Receive( "changeBuildingPrice", function( len, ply )
  local _tmpBuildingID = net.ReadInt( 16 )
  local _tmpNewPrice = net.ReadString()
  _tmpNewPrice = tonumber( _tmpNewPrice ) or 99

  local _result = db_update( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings", "buildingprice = " .. _tmpNewPrice , "uniqueID = " .. _tmpBuildingID )
  worked( _result, "changeBuildingPrice failed" )
end)


function hasDoors( id )
  local _allDoors = db_select( "yrp_" .. string.lower( game.GetMap() ) .. "_doors", "*", nil )
  for k, v in pairs( _allDoors ) do
    if tonumber( v.buildingID ) == tonumber( id ) then
      return true
    end
  end
  return false
end

function lookForEmptyBuildings()
  local _allBuildings = db_select( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings", "*", nil )

  for k, v in pairs( _allBuildings ) do
    if !hasDoors( v.uniqueID ) then
      db_delete_from( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings", "uniqueID = " .. tonumber( v.uniqueID ) )
    end
  end
end

net.Receive( "changeBuildingID", function( len, ply )
  local _tmpDoor = net.ReadEntity()
  local _tmpBuildingID = net.ReadInt( 16 )

  _tmpDoor:SetNWInt( "buildingID", tonumber( _tmpBuildingID ) )
  db_update( "yrp_" .. string.lower( game.GetMap() ) .. "_doors", "buildingID = " .. tonumber( _tmpBuildingID ) , "uniqueID = " .. _tmpDoor:GetNWInt( "uniqueID" ) )

  lookForEmptyBuildings()
end)

net.Receive( "changeBuildingName", function( len, ply )
  local _tmpBuildingID = net.ReadInt( 16 )
  local _tmpNewName = net.ReadString()
  if _tmpBuildingID != nil then
    printGM( "note", "renamed Building: " .. _tmpNewName )
    db_update( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings", "name = '" .. _tmpNewName .. "'" , "uniqueID = " .. _tmpBuildingID )
  else
    printGM( "note", "changeBuildingName failed" )
  end
end)

net.Receive( "getBuildings", function( len, ply )
  local _tmpTable = db_select( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings", "*", nil )
  net.Start( "getBuildings" )
    net.WriteTable( _tmpTable )
  net.Send( ply )
end)

net.Receive( "getBuildingInfo", function( len, ply )
  local _tmpDoorID = net.ReadInt( 16 )
  local _tmpBuildingID = net.ReadInt( 16 )
  if _tmpBuildingID != nil then

    local _tmpTable = db_select( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings", "*", "uniqueID = '" .. _tmpBuildingID .. "'" )

    local owner = ""
    if _tmpTable != nil then
      _tmpTable = _tmpTable[1]
      if _tmpTable.ownerCharID != "" then
        local _tmpChaTab = db_select( "yrp_characters", "*", "uniqueID = " .. _tmpTable.ownerCharID )
        if _tmpChaTab != nil then
          _tmpChaTab = _tmpChaTab[1]
          owner = _tmpChaTab.rpname
        end
      elseif _tmpTable.groupID != "" then
        local _tmpGroTab = db_select( "yrp_groups", "*", "uniqueID = " .. _tmpTable.groupID )
        if _tmpGroTab != nil then
          _tmpGroTab = _tmpGroTab[1]
          owner = _tmpGroTab.groupID
        end
      end

      if _tmpTable != nil then
        if allowedToUseDoor( _tmpBuildingID, ply ) then
          net.Start( "getBuildingInfo" )
            net.WriteBool( true )
            net.WriteInt( _tmpDoorID, 16 )
            net.WriteInt( _tmpBuildingID, 16 )
            net.WriteTable( _tmpTable )
            net.WriteString( owner )
          net.Send( ply )
        end
      end
    else
      net.Start( "getBuildingInfo" )
        net.WriteBool( false )
      net.Send( ply )
    end
  end
end)
