--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local _db_name = "yrp_" .. GetMapNameDB() .. "_doors"
SQL_ADD_COLUMN( _db_name, "buildingID", "TEXT DEFAULT '-1'" )
SQL_ADD_COLUMN( _db_name, "level", "INTEGER DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "keynr", "INTEGER DEFAULT -1" )

--db_drop_table( _db_name )
--db_is_empty( _db_name )

_db_name = "yrp_" .. GetMapNameDB() .. "_buildings"
SQL_ADD_COLUMN( _db_name, "groupID", "INTEGER DEFAULT -1" )
SQL_ADD_COLUMN( _db_name, "buildingprice", "TEXT DEFAULT 100" )
SQL_ADD_COLUMN( _db_name, "ownerCharID", "TEXT DEFAULT ''" )
SQL_ADD_COLUMN( _db_name, "name", "TEXT DEFAULT 'Building'" )

--db_drop_table( _db_name )
--db_is_empty( _db_name )

function allowedToUseDoor( id, ply )
  if ply:HasAccess() then
    return true
  else
    local _tmpBuildingTable = SQL_SELECT( "yrp_" .. GetMapNameDB() .. "_buildings", "*", "uniqueID = '" .. id .. "'" )
    if _tmpBuildingTable[1] != nil then

      if tostring( _tmpBuildingTable[1].ownerCharID ) == "" and tonumber( _tmpBuildingTable[1].groupID ) == -1 then
        return true
      else
        local _tmpChaTab = SQL_SELECT( "yrp_characters", "*", "uniqueID = " .. _tmpBuildingTable[1].ownerCharID )
        if wk( _tmpChaTab ) then
          local _tmpGroupTable = SQL_SELECT( "yrp_groups", "*", "uniqueID = " .. _tmpChaTab[1].groupID )

          if tostring( _tmpBuildingTable[1].ownerCharID ) == tostring( ply:CharID() ) or tonumber( _tmpBuildingTable[1].groupID ) == tonumber( _tmpGroupTable[1].uniqueID ) then
            return true
          else
            return false
          end
        else
          printGM( "error", "_tmpChaTab: " .. tostring( _tmpChaTab ) )
          return false
        end
      end
    else
      return false
    end
  end
end

function searchForDoors()
  printGM( "db", "[Buildings] Search Map for Doors" )

  local _allPropDoors = ents.FindByClass( "prop_door_rotating" )
  for k, v in pairs( _allPropDoors ) do
    SQL_INSERT_INTO_DEFAULTVALUES( "yrp_" .. GetMapNameDB() .. "_buildings" )

    local _tmpBuildingTable = SQL_SELECT( "yrp_" .. GetMapNameDB() .. "_buildings", "*", nil )
    SQL_INSERT_INTO( "yrp_" .. GetMapNameDB() .. "_doors", "buildingID", "'" .. _tmpBuildingTable[#_tmpBuildingTable].uniqueID .. "'" )

    local _tmpDoorsTable = SQL_SELECT( "yrp_" .. GetMapNameDB() .. "_doors", "*", nil )
  end

  local _allFuncDoors = ents.FindByClass( "func_door" )
  for k, v in pairs( _allFuncDoors ) do
    SQL_INSERT_INTO_DEFAULTVALUES( "yrp_" .. GetMapNameDB() .. "_buildings" )

    local _tmpBuildingTable = SQL_SELECT( "yrp_" .. GetMapNameDB() .. "_buildings", "*", nil )
    SQL_INSERT_INTO( "yrp_" .. GetMapNameDB() .. "_doors", "buildingID", "'" .. _tmpBuildingTable[#_tmpBuildingTable].uniqueID .. "'" )

    local _tmpDoorsTable = SQL_SELECT( "yrp_" .. GetMapNameDB() .. "_doors", "*", nil )
  end

  local _allFuncRDoors = ents.FindByClass( "func_door_rotating" )
  for k, v in pairs( _allFuncRDoors ) do
    SQL_INSERT_INTO_DEFAULTVALUES( "yrp_" .. GetMapNameDB() .. "_buildings" )

    local _tmpBuildingTable = SQL_SELECT( "yrp_" .. GetMapNameDB() .. "_buildings", "*", nil )
    SQL_INSERT_INTO( "yrp_" .. GetMapNameDB() .. "_doors", "buildingID", "'" .. _tmpBuildingTable[#_tmpBuildingTable].uniqueID .. "'" )

    local _tmpDoorsTable = SQL_SELECT( "yrp_" .. GetMapNameDB() .. "_doors", "*", nil )
  end

  printGM( "db", "[Buildings] Done finding them (" .. #_allPropDoors+#_allFuncDoors+#_allFuncRDoors .. " doors found)" )
  return #_allPropDoors+#_allFuncDoors+#_allFuncRDoors
end

function loadDoors()
  printGM( "db", "[Buildings] Loading map doors!" )
  local _allPropDoors = ents.FindByClass( "prop_door_rotating" )
  local _allFuncDoors = ents.FindByClass( "func_door" )
  local _allFuncRDoors = ents.FindByClass( "func_door_rotating" )
  local _tmpDoors = SQL_SELECT( "yrp_" .. GetMapNameDB() .. "_doors", "*", nil )
  local _count = 1

  if worked( _tmpDoors, "[Buildings] No Map Doors found", true ) then
    --for k, v in pairs( _tmpDoors ) do
      for l, door in pairs( _allPropDoors ) do
        if worked( _tmpDoors[_count], "loadDoors 2" ) then
          door:SetNWString( "buildingID", _tmpDoors[_count].buildingID )
          door:SetNWString( "uniqueID", _count )
        else
          printGM( "note", "[Buildings] more doors, then in list!" )
        end
        _count = _count + 1
      end

      for l, door in pairs( _allFuncDoors ) do
        if _tmpDoors[_count] != nil then
          door:SetNWString( "buildingID", _tmpDoors[_count].buildingID )
          door:SetNWString( "uniqueID", _count )
        else
          printGM( "note", "[Buildings] more doors, then in list!" )
        end
        _count = _count + 1
      end

      for l, door in pairs( _allFuncRDoors ) do
        if _tmpDoors[_count] != nil then
          door:SetNWString( "buildingID", _tmpDoors[_count].buildingID )
          door:SetNWString( "uniqueID", _count )

        else
          printGM( "note", "[Buildings] more doors, then in list!" )
        end
        _count = _count + 1
      end
    --end
  end

  local _tmpBuildings = SQL_SELECT( "yrp_" .. GetMapNameDB() .. "_buildings", "*", nil )
  for k, v in pairs( _allPropDoors ) do
    for l, w in pairs( _tmpBuildings ) do
      if tonumber( w.uniqueID ) == tonumber( v:GetNWString( "buildingID" ) ) then
        if w.ownerCharID != "" then

          local _tmpRPName = SQL_SELECT( "yrp_characters", "*", "uniqueID = " .. w.ownerCharID )
          if _tmpRPName != nil then
            _tmpRPName = _tmpRPName[1]
            if _tmpRPName.rpname != nil then
              v:SetNWString( "ownerRPName", _tmpRPName.rpname )
            end
          end
        else
          if tonumber( w.groupID ) != -1 then
            local _tmpGroupName = SQL_SELECT( "yrp_groups", "groupID", "uniqueID = " .. w.groupID )
            if _tmpGroupName != nil then
              _tmpGroupName = _tmpGroupName[1]
              if _tmpGroupName != nil then
                v:SetNWString( "ownerGroup", tostring( _tmpGroupName.groupID ) )
              end
            end
          end
        end
        break
      end
    end
  end

  printGM( "db", "[Buildings] Map doors loaded!" )
end

function check_map_doors()
  printGM( "db", "[Buildings] Looking for doors" )
  local _tmpTable = SQL_SELECT( "yrp_" .. GetMapNameDB() .. "_doors", "*", nil )
  local _tmpTable2 = SQL_SELECT( "yrp_" .. GetMapNameDB() .. "_buildings", "*", nil )
  local amountDoors = 0
  if _tmpTable == nil or _tmpTable2 == nil then
    amountDoors = searchForDoors()
  else
    printGM( "db", "[Buildings] Found Doors! (" .. tostring( #_tmpTable ) .. " Doors)" )
    local _allPropDoors = ents.FindByClass( "prop_door_rotating" )
    local _allFuncDoors = ents.FindByClass( "func_door" )
    local _allFuncRDoors = ents.FindByClass( "func_door_rotating" )
    if ( #_tmpTable ) < ( #_allPropDoors + #_allFuncDoors + #_allFuncRDoors ) then
      printGM( "db", "[Buildings] New doors found!" )
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

util.AddNetworkString( "lockDoor" )

function canLock( ply, tab )
  if tab.ownerCharID != "" then
    if tostring( ply:CharID() ) == tostring( tab.ownerCharID ) then
      return true
    end
    return false
  elseif tab.groupID != "-1" then
    if ply:GetNWString( "GroupUniqueID", "Failed" ) == tab.groupID then
      return true
    end
    return false
  elseif tab.ownerCharID == "" and tab.groupID == "-1" then
    return false
  else
    printGM( "error", "canLock ELSE" )
    return false
  end
end

function unlockDoor( ply, ent, nr )
  local _tmpBuildingTable = SQL_SELECT( "yrp_" .. GetMapNameDB() .. "_buildings", "*", "uniqueID = '" .. nr .. "'" )
  if _tmpBuildingTable != nil then
    _tmpBuildingTable = _tmpBuildingTable[1]
    if canLock( ply, _tmpBuildingTable ) then
      ent:Fire( "Unlock" )
      return true
    end
  else
    return false
  end
end

function lockDoor( ply, ent, nr )
  local _tmpBuildingTable = SQL_SELECT( "yrp_" .. GetMapNameDB() .. "_buildings", "*", "uniqueID = '" .. nr .. "'" )
  if _tmpBuildingTable != nil then
    _tmpBuildingTable = _tmpBuildingTable[1]
    if canLock( ply, _tmpBuildingTable ) then
      ent:Fire( "Lock" )
      return true
    end
  else
    return false
  end
end

net.Receive( "removeOwner", function( len, ply )
  local _tmpBuildingID = net.ReadString()
  local _tmpTable = SQL_SELECT( "yrp_" .. GetMapNameDB() .. "_buildings", "*", "uniqueID = '" .. _tmpBuildingID .. "'" )

  local result = SQL_UPDATE( "yrp_" .. GetMapNameDB() .. "_buildings", "ownerCharID = '', groupID = -1", "uniqueID = '" .. _tmpBuildingID .. "'" )

  local _tmpDoors = ents.FindByClass( "prop_door_rotating" )
  for k, v in pairs( _tmpDoors ) do
    if tonumber( v:GetNWString( "buildingID" ) ) == tonumber( _tmpBuildingID ) then
      v:SetNWString( "ownerRPName", "" )
      v:SetNWString( "ownerGroup", "" )
    end
  end
  local _tmpFDoors = ents.FindByClass( "func_door" )
  for k, v in pairs( _tmpFDoors ) do
    if tonumber( v:GetNWString( "buildingID" ) ) == tonumber( _tmpBuildingID ) then
      v:SetNWString( "ownerRPName", "" )
      v:SetNWString( "ownerGroup", "" )
    end
  end
  local _tmpFRDoors = ents.FindByClass( "func_door_rotating" )
  for k, v in pairs( _tmpFRDoors ) do
    if tonumber( v:GetNWString( "buildingID" ) ) == tonumber( _tmpBuildingID ) then
      v:SetNWString( "ownerRPName", "" )
      v:SetNWString( "ownerGroup", "" )
    end
  end
end)

net.Receive( "sellBuilding", function( len, ply )
  local _tmpBuildingID = net.ReadString()
  local _tmpTable = SQL_SELECT( "yrp_" .. GetMapNameDB() .. "_buildings", "*", "uniqueID = '" .. _tmpBuildingID .. "'" )

  SQL_UPDATE( "yrp_" .. GetMapNameDB() .. "_buildings", "ownerCharID = '', groupID = -1", "uniqueID = '" .. _tmpBuildingID .. "'" )
  local _tmpDoors = ents.FindByClass( "prop_door_rotating" )

  for k, v in pairs( _tmpDoors ) do
    if tonumber( v:GetNWString( "buildingID" ) ) == tonumber( _tmpBuildingID ) then
      v:SetNWString( "ownerRPName", "" )
      v:SetNWString( "ownerGroup", "" )
      v:Fire("Unlock")
      SQL_UPDATE( "yrp_" .. GetMapNameDB() .. "_doors", "keynr = -1", "buildingID = " .. tonumber( v:GetNWString( "buildingID" ) ) )
    end
  end

  local _tmpFDoors = ents.FindByClass( "func_door" )

  for k, v in pairs( _tmpFDoors ) do
    if tonumber( v:GetNWString( "buildingID" ) ) == tonumber( _tmpBuildingID ) then
      v:SetNWString( "ownerRPName", "" )
      v:SetNWString( "ownerGroup", "" )
      v:Fire("Unlock")
      SQL_UPDATE( "yrp_" .. GetMapNameDB() .. "_doors", "keynr = -1", "buildingID = " .. tonumber( v:GetNWString( "buildingID" ) ) )
    end
  end

  local _tmpFRDoors = ents.FindByClass( "func_door_rotating" )

  for k, v in pairs( _tmpFRDoors ) do
    if tonumber( v:GetNWString( "buildingID" ) ) == tonumber( _tmpBuildingID ) then
      v:SetNWString( "ownerRPName", "" )
      v:SetNWString( "ownerGroup", "" )
      v:Fire("Unlock")
      SQL_UPDATE( "yrp_" .. GetMapNameDB() .. "_doors", "keynr = -1", "buildingID = " .. tonumber( v:GetNWString( "buildingID" ) ) )
    end
  end

  ply:addMoney( ( _tmpTable[1].buildingprice / 2 ) )
end)

net.Receive( "buyBuilding", function( len, ply )
  if ply:GetNWBool( "toggle_building", false ) then
    local _tmpBuildingID = net.ReadString()
    local _tmpTable = SQL_SELECT( "yrp_" .. GetMapNameDB() .. "_buildings", "*", "uniqueID = '" .. _tmpBuildingID .. "'" )

    if ply:canAfford( _tmpTable[1].buildingprice ) and _tmpTable[1].ownerCharID == "" and tonumber( _tmpTable[1].groupID ) == -1 then
      ply:addMoney( - ( _tmpTable[1].buildingprice ) )
      SQL_UPDATE( "yrp_" .. GetMapNameDB() .. "_buildings", "ownerCharID = '" .. ply:CharID() .. "'", "uniqueID = '" .. _tmpBuildingID .. "'" )
      local _tmpDoors = ents.FindByClass( "prop_door_rotating" )
      local _tmpPlys = SQL_SELECT( "yrp_characters", "rpname", "uniqueID = " .. ply:CharID() )
      for k, v in pairs( _tmpDoors ) do
        if tonumber( v:GetNWString( "buildingID" ) ) == tonumber( _tmpBuildingID ) then
          v:SetNWString( "ownerRPName", _tmpPlys[1].rpname )
        end
      end
      local _tmpFDoors = ents.FindByClass( "func_door" )
      for k, v in pairs( _tmpFDoors ) do
        if tonumber( v:GetNWString( "buildingID" ) ) == tonumber( _tmpBuildingID ) then
          v:SetNWString( "ownerRPName", _tmpPlys[1].rpname )
        end
      end
      local _tmpFRDoors = ents.FindByClass( "func_door_rotating" )
      for k, v in pairs( _tmpFRDoors ) do
        if tonumber( v:GetNWString( "buildingID" ) ) == tonumber( _tmpBuildingID ) then
          v:SetNWString( "ownerRPName", _tmpPlys[1].rpname )
        end
      end

      printGM( "gm", ply:RPName() .. " has buyed a door")
    else
      printGM( "gm", ply:RPName() .. " has not enough money to buy door")
    end
  else
    printGM( "note", "buildings disabled" )
  end
end)

net.Receive( "setBuildingOwnerGroup", function( len, ply )
  local _tmpBuildingID = net.ReadString()
  local _tmpGroupID = net.ReadInt( 16 )

  SQL_UPDATE( "yrp_" .. GetMapNameDB() .. "_buildings", "groupID = " .. _tmpGroupID, "uniqueID = " .. _tmpBuildingID )

  local _tmpGroupName = SQL_SELECT( "yrp_groups", "groupID", "uniqueID = " .. _tmpGroupID )
  local _tmpDoors = ents.FindByClass( "prop_door_rotating" )
  for k, v in pairs( _tmpDoors ) do
    if tonumber( v:GetNWString( "buildingID" ) ) == tonumber( _tmpBuildingID ) then
      v:SetNWString( "ownerGroup", _tmpGroupName[1].groupID )
    end
  end
  local _tmpFDoors = ents.FindByClass( "func_door" )
  for k, v in pairs( _tmpFDoors ) do
    if tonumber( v:GetNWString( "buildingID" ) ) == tonumber( _tmpBuildingID ) then
      v:SetNWString( "ownerGroup", _tmpGroupName[1].groupID )
    end
  end
  local _tmpFRDoors = ents.FindByClass( "func_door_rotating" )
  for k, v in pairs( _tmpFRDoors ) do
    if tonumber( v:GetNWString( "buildingID" ) ) == tonumber( _tmpBuildingID ) then
      v:SetNWString( "ownerGroup", _tmpGroupName[1].groupID )
    end
  end
end)

net.Receive( "getBuildingGroups", function( len, ply )
  local _tmpTable = SQL_SELECT( "yrp_groups", "*", nil )

  net.Start( "getBuildingGroups" )
    net.WriteTable( _tmpTable )
  net.Send( ply )
end)

net.Receive( "changeBuildingPrice", function( len, ply )
  local _tmpBuildingID = net.ReadString()
  local _tmpNewPrice = net.ReadString()
  _tmpNewPrice = tonumber( _tmpNewPrice ) or 99

  local _result = SQL_UPDATE( "yrp_" .. GetMapNameDB() .. "_buildings", "buildingprice = " .. _tmpNewPrice , "uniqueID = " .. _tmpBuildingID )
  worked( _result, "changeBuildingPrice failed" )
end)


function hasDoors( id )
  local _allDoors = SQL_SELECT( "yrp_" .. GetMapNameDB() .. "_doors", "*", nil )
  for k, v in pairs( _allDoors ) do
    if tonumber( v.buildingID ) == tonumber( id ) then
      return true
    end
  end
  return false
end

function lookForEmptyBuildings()
  local _allBuildings = SQL_SELECT( "yrp_" .. GetMapNameDB() .. "_buildings", "*", nil )

  for k, v in pairs( _allBuildings ) do
    if !hasDoors( v.uniqueID ) then
      SQL_DELETE_FROM( "yrp_" .. GetMapNameDB() .. "_buildings", "uniqueID = " .. tonumber( v.uniqueID ) )
    end
  end
end

net.Receive( "changeBuildingID", function( len, ply )
  local _tmpDoor = net.ReadEntity()
  local _tmpBuildingID = net.ReadString()

  _tmpDoor:SetNWString( "buildingID", _tmpBuildingID )
  SQL_UPDATE( "yrp_" .. GetMapNameDB() .. "_doors", "buildingID = " .. tonumber( _tmpBuildingID ) , "uniqueID = " .. _tmpDoor:GetNWString( "uniqueID" ) )

  lookForEmptyBuildings()
end)

net.Receive( "changeBuildingName", function( len, ply )
  local _tmpBuildingID = net.ReadString()
  local _tmpNewName = net.ReadString()
  if _tmpBuildingID != nil then
    printGM( "note", "renamed Building: " .. _tmpNewName )
    SQL_UPDATE( "yrp_" .. GetMapNameDB() .. "_buildings", "name = '" .. SQL_STR_IN( _tmpNewName ) .. "'" , "uniqueID = " .. _tmpBuildingID )
  else
    printGM( "note", "changeBuildingName failed" )
  end
end)

net.Receive( "getBuildings", function( len, ply )
  local _tmpTable = SQL_SELECT( "yrp_" .. GetMapNameDB() .. "_buildings", "*", nil )
  for k, building in pairs( _tmpTable ) do
    building.name = SQL_STR_OUT( building.name )
  end
  net.Start( "getBuildings" )
    net.WriteTable( _tmpTable )
  net.Send( ply )
end)

net.Receive( "getBuildingInfo", function( len, ply )
  local _tmpDoor = net.ReadEntity()
  local _tmpBuildingID = _tmpDoor:GetNWString( "buildingID" )

  if _tmpBuildingID != nil then
    local _tmpTable = SQL_SELECT( "yrp_" .. GetMapNameDB() .. "_buildings", "*", "uniqueID = '" .. _tmpBuildingID .. "'" )

    local owner = ""
    if _tmpTable != nil then
      _tmpTable = _tmpTable[1]
      _tmpTable.name = SQL_STR_OUT( _tmpTable.name )
      if _tmpTable.ownerCharID != "" then
        local _tmpChaTab = SQL_SELECT( "yrp_characters", "*", "uniqueID = " .. _tmpTable.ownerCharID )
        if _tmpChaTab != nil then
          _tmpChaTab = _tmpChaTab[1]
          owner = _tmpChaTab.rpname
        end
      elseif _tmpTable.groupID != "" then
        local _tmpGroTab = SQL_SELECT( "yrp_groups", "*", "uniqueID = " .. _tmpTable.groupID )
        if _tmpGroTab != nil then
          _tmpGroTab = _tmpGroTab[1]
          owner = _tmpGroTab.groupID
        end
      end

      if _tmpTable != nil then
        if allowedToUseDoor( _tmpBuildingID, ply ) then
          net.Start( "getBuildingInfo" )
            net.WriteBool( true )
            net.WriteEntity( _tmpDoor )
            net.WriteString( _tmpBuildingID )
            net.WriteTable( _tmpTable )
            net.WriteString( owner )
          net.Send( ply )
        end
      end
    else
      printGM( "note", "getBuildingInfo -> _tmpTable == NIL" )
      net.Start( "getBuildingInfo" )
        net.WriteBool( false )
      net.Send( ply )
    end
  else
    printGM( "note", "getBuildingInfo -> BuildingID == NIL" )
  end
end)
