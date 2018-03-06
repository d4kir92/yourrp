--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local _db_name = "yrp_shop_items"

sql_add_column( _db_name, "name", "TEXT DEFAULT 'UNNAMED'" )
sql_add_column( _db_name, "description", "TEXT DEFAULT 'UNNAMED'" )
sql_add_column( _db_name, "price", "TEXT DEFAULT '100'" )
sql_add_column( _db_name, "categoryID", "INT DEFAULT -1" )
sql_add_column( _db_name, "quantity", "INT DEFAULT -1" )
sql_add_column( _db_name, "cooldown", "INT DEFAULT -1" )
sql_add_column( _db_name, "licenseID", "INT DEFAULT -1" )
sql_add_column( _db_name, "permanent", "INT DEFAULT 0" )
sql_add_column( _db_name, "type", "TEXT DEFAULT 'weapons'" )
sql_add_column( _db_name, "ClassName", "TEXT DEFAULT 'weapon_crowbar'" )
sql_add_column( _db_name, "PrintName", "TEXT DEFAULT 'unnamed item'" )
sql_add_column( _db_name, "WorldModel", "TEXT DEFAULT ''" )

--db_drop_table( _db_name )
--db_is_empty( _db_name )

util.AddNetworkString( "get_shop_items" )

function send_shop_items( ply, uid )
  local _s_items = db_select( _db_name, "*", "categoryID = " .. uid )

  local _nw = _s_items
  if _nw == nil then
    _nw = {}
  end
  net.Start( "get_shop_items" )
    net.WriteTable( _nw )
  net.Send( ply )
end

net.Receive( "get_shop_items", function( len, ply )
  local _catID = net.ReadString()

  send_shop_items( ply, _catID )
end)

util.AddNetworkString( "shop_item_add" )

net.Receive( "shop_item_add", function( len, ply )
  local _catID = net.ReadString()
  local _new = db_insert_into( _db_name, "categoryID", _catID )
  printGM( "db", "shop_item_add: " .. db_worked( _new ) )

  send_shop_items( ply, _catID )
end)

util.AddNetworkString( "shop_item_rem" )

net.Receive( "shop_item_rem", function( len, ply )
  local _uid = net.ReadString()
  local _catID = net.ReadString()
  local _new = db_delete_from( _db_name, "uniqueID = " .. _uid )
  printGM( "db", "shop_item_rem: " .. db_worked( _new ) )

  send_shop_items( ply, _catID )
end)

util.AddNetworkString( "shop_item_edit_name" )

net.Receive( "shop_item_edit_name", function( len, ply )
  local _uid = net.ReadString()
  local _new_name = net.ReadString()
  local _catID = net.ReadString()
  local _new = db_update( _db_name, "name = '" .. db_in_str( _new_name ) .. "'", "uniqueID = " .. _uid )
  printGM( "db", "shop_item_edit_name: " .. db_worked( _new ) )
end)

util.AddNetworkString( "shop_item_edit_desc" )

net.Receive( "shop_item_edit_desc", function( len, ply )
  local _uid = net.ReadString()
  local _new_desc = net.ReadString()
  local _catID = net.ReadString()
  local _new = db_update( _db_name, "description = '" .. db_in_str( _new_desc ) .. "'", "uniqueID = " .. _uid )
  printGM( "db", "shop_item_edit_desc: " .. db_worked( _new ) )
end)

util.AddNetworkString( "shop_item_edit_price" )

net.Receive( "shop_item_edit_price", function( len, ply )
  local _uid = net.ReadString()
  local _new_price = net.ReadString()
  local _catID = net.ReadString()
  local _new = db_update( _db_name, "price = '" .. db_in_str( _new_price ) .. "'", "uniqueID = " .. _uid )
  printGM( "db", "shop_item_edit_price: " .. db_worked( _new ) )
end)

util.AddNetworkString( "shop_item_edit_quan" )

net.Receive( "shop_item_edit_quan", function( len, ply )
  local _uid = net.ReadString()
  local _new_quan = net.ReadString()
  local _catID = net.ReadString()
  local _new = db_update( _db_name, "quantity = '" .. _new_quan .. "'", "uniqueID = " .. _uid )
  printGM( "db", "shop_item_edit_quan: " .. db_worked( _new ) )
end)

util.AddNetworkString( "shop_item_edit_cool" )

net.Receive( "shop_item_edit_cool", function( len, ply )
  local _uid = net.ReadString()
  local _new_cool = net.ReadString()
  local _catID = net.ReadString()
  local _new = db_update( _db_name, "cooldown = '" .. db_in_str( _new_cool ) .. "'", "uniqueID = " .. _uid )
  printGM( "db", "shop_item_edit_cool: " .. db_worked( _new ) )
end)

util.AddNetworkString( "shop_item_edit_lice" )

net.Receive( "shop_item_edit_lice", function( len, ply )
  local _uid = net.ReadString()
  local _new_lice = net.ReadString()
  local _catID = net.ReadString()
  local _new = db_update( _db_name, "licenseID = '" .. db_in_str( _new_lice ) .. "'", "uniqueID = " .. _uid )
  printGM( "db", "shop_item_edit_lice: " .. db_worked( _new ) )
end)

util.AddNetworkString( "shop_item_edit_perm" )

net.Receive( "shop_item_edit_perm", function( len, ply )
  local _uid = net.ReadString()
  local _new_perm = net.ReadString()
  local _catID = net.ReadString()
  local _new = db_update( _db_name, "permanent = '" .. db_in_str( _new_perm ) .. "'", "uniqueID = " .. _uid )
  printGM( "db", "shop_item_edit_perm: " .. db_worked( _new ) )
end)

util.AddNetworkString( "shop_get_items" )

net.Receive( "shop_get_items", function( len, ply )
  local _uid = net.ReadString()
  local _items = db_select( _db_name, "*", "categoryID = '" .. _uid .. "'")
  local _nw = {}
  if _items != nil then
    _nw = _items
  end

  net.Start( "shop_get_items" )
    net.WriteTable( _nw )
  net.Send( ply )
end)

util.AddNetworkString( "shop_item_edit_base" )

net.Receive( "shop_item_edit_base", function( len, ply )
  local _uid = net.ReadString()
  local _wm = net.ReadString()
  local _cn = net.ReadString()
  local _pn = net.ReadString()
  local _type = net.ReadString()

  local _new = db_update( _db_name, "WorldModel = '" .. _wm .. "', ClassName = '" .. _cn .. "', PrintName = '" .. _pn .. "', type = '" .. _type .. "'", "uniqueID = " .. _uid )
  printGM( "db", "shop_item_edit_base: " .. db_worked( _new ) )
end)

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

util.AddNetworkString( "item_buy" )

net.Receive( "item_buy", function( len, ply )
  local _tab = net.ReadTable()

  local _item = db_select( _db_name, "*", "uniqueID = " .. _tab.uniqueID )
  if _item != nil then
    _item = _item[1]
    if ply:canAfford( tonumber( _item.price ) ) then

      ply:addMoney( -tonumber( _item.price ) )
      spawnItem( ply, _item, _item.type )
    end
  end
end)
