--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function allowedToUseDoor( id, ply )
  if ply:IsSuperAdmin() or ply:IsAdmin() then
    return true
  else
    local _tmpBuildingTable = dbSelect( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings", "*", "uniqueID = '" .. id .. "'" )
    --PrintTable(_tmpBuildingTable)
    if _tmpBuildingTable[1] != nil then

      --PrintTable( _tmpBuildingTable )
      if tostring( _tmpBuildingTable[1].ownerCharID ) == "" and tonumber( _tmpBuildingTable[1].groupID ) == -1 then
        return true
      else
        local _tmpChaTab = dbSelect( "yrp_characters", "*", "uniqueID = " .. _tmpBuildingTable[1].ownerCharID )
        local _tmpGroupTable = dbSelect( "yrp_groups", "*", "uniqueID = " .. _tmpChaTab[1].groupID )

        --PrintTable(_tmpGroupTable)
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
        local _tmpTable = dbSelect( "yrp_characters", "keynrs", "uniqueID = " .. ply:CharID() )
        if worked( _tmpTable, "addKeys 1" ) then
          _tmpTable = string.Explode( ",", _tmpTable[1].keynrs )
          for l, w in pairs( _tmpTable ) do
            if worked( w, "addKeys 2" ) and w != "" then
              v:AddKeyNr( w )
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
    dbInsertIntoDEFAULTVALUES( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings" )

    local _tmpBuildingTable = dbSelect( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings", "*", nil )
    dbInsertInto( "yrp_" .. string.lower( game.GetMap() ) .. "_doors", "buildingID", "" .. _tmpBuildingTable[#_tmpBuildingTable].uniqueID .. "" )

    local _tmpDoorsTable = dbSelect( "yrp_" .. string.lower( game.GetMap() ) .. "_doors", "*", nil )
  end

  local _allFuncDoors = ents.FindByClass( "func_door" )
  for k, v in pairs( _allFuncDoors ) do
    dbInsertIntoDEFAULTVALUES( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings" )

    local _tmpBuildingTable = dbSelect( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings", "*", nil )
    dbInsertInto( "yrp_" .. string.lower( game.GetMap() ) .. "_doors", "buildingID", "" .. _tmpBuildingTable[#_tmpBuildingTable].uniqueID .. "" )

    local _tmpDoorsTable = dbSelect( "yrp_" .. string.lower( game.GetMap() ) .. "_doors", "*", nil )
  end

  local _allFuncRDoors = ents.FindByClass( "func_door_rotating" )
  for k, v in pairs( _allFuncRDoors ) do
    dbInsertIntoDEFAULTVALUES( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings" )

    local _tmpBuildingTable = dbSelect( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings", "*", nil )
    dbInsertInto( "yrp_" .. string.lower( game.GetMap() ) .. "_doors", "buildingID", "" .. _tmpBuildingTable[#_tmpBuildingTable].uniqueID .. "" )

    local _tmpDoorsTable = dbSelect( "yrp_" .. string.lower( game.GetMap() ) .. "_doors", "*", nil )
  end

  printGM( "db", "Done finding them (" .. #_allPropDoors+#_allFuncDoors+#_allFuncRDoors .. " found)" )
  return #_allPropDoors+#_allFuncDoors+#_allFuncRDoors
end

function loadDoors()
  printGM( "note", "loadDoors start!")
  local _allPropDoors = ents.FindByClass( "prop_door_rotating" )
  local _allFuncDoors = ents.FindByClass( "func_door" )
  local _allFuncRDoors = ents.FindByClass( "func_door_rotating" )
  local _tmpDoors = dbSelect( "yrp_" .. string.lower( game.GetMap() ) .. "_doors", "*", nil )
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

  local _tmpBuildings = dbSelect( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings", "*", nil )
  for k, v in pairs( _allPropDoors ) do
    for l, w in pairs( _tmpBuildings ) do
      if tonumber( w.uniqueID ) == tonumber( v:GetNWInt( "buildingID" ) ) then
        if w.ownerCharID != "" then

          local _tmpRPName = dbSelect( "yrp_characters", "*", "uniqueID = " .. w.ownerCharID )
          if _tmpRPName[1].rpname != nil then
            v:SetNWString( "ownerRPName", _tmpRPName[1].rpname )
          end
        else
          if tonumber( w.groupID ) != -1 then
            local _tmpGroupName = dbSelect( "yrp_groups", "groupID", "uniqueID = " .. w.groupID )
            if _tmpGroupName != nil then
              v:SetNWString( "ownerGroup", tostring( _tmpGroupName[1].groupID ) )
            end
          end
        end
        break
      end
    end
  end

  printGM( "note", "loadDoors complete!")
end

function checkMapDoors()
  printGM( "db", "checkMapDoors()" )
  local _tmpTable = dbSelect( "yrp_" .. string.lower( game.GetMap() ) .. "_doors", "*", nil )
  local _tmpTable2 = dbSelect( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings", "*", nil )
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
