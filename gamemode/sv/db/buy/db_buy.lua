--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local _db_name = "yrp_buy"

sql_add_column( _db_name, "ClassName", "TEXT DEFAULT ''" )
sql_add_column( _db_name, "PrintName", "TEXT DEFAULT ''" )
sql_add_column( _db_name, "WorldModel", "TEXT DEFAULT ''" )
sql_add_column( _db_name, "price", "INTEGER DEFAULT 100" )
sql_add_column( _db_name, "tab", "TEXT DEFAULT ''" )
sql_add_column( _db_name, "Skin", "TEXT DEFAULT ''" )

--db_drop_table( _db_name )
--db_is_empty( _db_name )

util.AddNetworkString( "getBuyList" )

util.AddNetworkString( "addNewBuyItem" )
util.AddNetworkString( "removeBuyItem" )

util.AddNetworkString( "buyItem" )

function SpawnVehicle( item )
  local vehicles = get_all_vehicles()
  local vehicle = {}
  for k, v in pairs( vehicles ) do
    if v.ClassName == item.ClassName and v.PrintName == item.PrintName and v.WorldModel == item.WorldModel then
      vehicle = v
      if v.Custom == "simfphys" then
        local spawnname = item.ClassName
        local _vehicle = list.Get( "simfphys_vehicles" )[ spawnname ]

        local car = simfphys.SpawnVehicleSimple( spawnname, Vector( 1000, 1000, -12700 ), Angle( 0, 0, 0 ) )

        return car
      end
      break
    end
  end
  if vehicle.ClassName != nil then
    local car = ents.Create( vehicle.ClassName )
    if not car then return end
    car:SetModel( vehicle.WorldModel )
    if  vehicle.Skin != "-1" then
      car:SetSkin( vehicle.Skin )
    end
    if vehicle.KeyValues then
      for k, v in pairs( vehicle.KeyValues ) do
        car:SetKeyValue( k, v )
      end
    end
    car:Spawn()
    car:Activate()
    car.ClassOverride = Class
    --car:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    return car
  else
    printGM( "note", "vehicle not available anymore" )
    return NULL
  end
end

function spawnItem( ply, item, tab )
  local _distSpace = 8
  local _distMax = 2000
  local _angle = ply:EyeAngles()
  local ent = {}
  if tab == "vehicles" then
    ent = SpawnVehicle( item )
    local newVehicle = db_insert_into( "yrp_vehicles", "ClassName, ownerCharID", "'" .. db_sql_str( item.ClassName ) .. "', '" .. ply:CharID() .. "'" )
    local getVehicles = db_select( "yrp_vehicles", "*", nil )
    ent:SetNWInt( "vehicleID", getVehicles[#getVehicles].uniqueID)
    ent:SetNWString( "ownerRPName", ply:RPName() )

    if ent == NULL then
      printGM( "note", "spawnItem failed: ent == NULL" )
      return
    end
  else
    ent = ents.Create( item.ClassName )
    if ent == NULL then return end
    --ent:Spawn()
  end

  ent:SetPos( ply:GetPos() + Vector( 0, 0, math.abs( ent:OBBMins().z ) ) + Vector( 0, 0, 64 ) )
  for dist = 0, _distMax, _distSpace do
    for ang = 0, 360, 45 do
      if ang != 0 then
        _angle = _angle + Angle( 0, 45, 0 )
      end
      local tr = {}
    	tr.start = ent:GetPos() + _angle:Forward() * dist
    	tr.endpos = ent:GetPos() + _angle:Forward() * dist
    	tr.filter = ent
    	tr.mins = ent:OBBMins()*1.1 --1.1 because so that no one get stuck
    	tr.maxs = ent:OBBMaxs()*1.1 --1.1 because so that no one get stuck
    	tr.mask = MASK_SHOT_HULL

      local _result = util.TraceHull( tr )
      if !_result.Hit then
        ent:SetPos( ent:GetPos() + _angle:Forward() * dist )
        if tab == "vehicles" then
          ent:SetVelocity( Vector( 0, 0, -500 ) )
        else
          ent:Spawn()
        end
        return true
      end
    end
  end
  return false
end

net.Receive( "buyItem", function( len, ply )
  local _tab = net.ReadString()
  local _uniqueID = net.ReadString()

  local _item = db_select( "yrp_buy", "*", "uniqueID = " .. tonumber( _uniqueID ) )
  if _item != nil then
    _item = _item[1]
    if ply:canAfford( -tonumber( _item.price ) ) then
      printGM( "note", ply:Nick() .. " can afford " .. tostring( _item.ClassName ) )
      ply:addMoney( -tonumber( _item.price ) )
      spawnItem( ply, _item, _tab )
    else
      printGM( "note", ply:Nick() .. " can not afford " .. tostring( _item.ClassName ) )
    end
  else
    printGM( "error", "buyItem fail [ tab: " .. tostring(_tab) .. " uid: " .. tostring( _uniqueID ) .. " item: " .. tostring(_item) .. " ]" )
    printGM( "error", "buyItem fail [ " .. sql_show_last_error() .. " ]" )
  end
end)

net.Receive( "removeBuyItem", function( len, ply )
  local _uniqueID = net.ReadString()
  db_delete_from( "yrp_buy", "uniqueID = " .. tonumber( _uniqueID )  )
end)

net.Receive( "addNewBuyItem", function( len, ply )
  local _tmpTab = net.ReadString()
  local _classname = net.ReadString()
  local _printname = net.ReadString()
  local _worldmodel = net.ReadString()
  local _price = net.ReadString()
  local _skin = net.ReadString()

  db_insert_into( "yrp_buy", "tab, ClassName, PrintName, WorldModel, price, skin", "'" .. db_sql_str( _tmpTab ) .. "', '" .. db_sql_str( _classname ) .. "', '" .. db_sql_str( _printname ) .. "', '" .. db_sql_str( _worldmodel ) .. "', " .. tonumber( _price ) .. ", '" .. tonumber( _skin ) .. "'" )

  local _tmpTable = db_select( "yrp_buy", "*", "tab = '" .. db_sql_str( _tmpTab ) .. "'" )
  if _tmpTable == nil then
    _tmpTable = {}
  end

  net.Start( "getBuyList" )
    net.WriteString( _tmpTab )
    net.WriteTable( _tmpTable )
  net.Send( ply )
end)

net.Receive( "getBuyList", function( len, ply )
  local _tmpTab = net.ReadString()
  local _tmpTable = db_select( "yrp_buy", "*", "tab = '" .. db_sql_str( _tmpTab ) .. "'" )
  if _tmpTable == nil then
    _tmpTable = {}
  end
  net.Start( "getBuyList" )
    net.WriteString( _tmpTab )
    net.WriteTable( _tmpTable )
  net.Send( ply )
end)
