--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_net.lua

util.AddNetworkString( "getBuyList" )

util.AddNetworkString( "addNewBuyItem" )
util.AddNetworkString( "removeBuyItem" )

util.AddNetworkString( "buyItem" )

function SpawnVehicle( class )
  local vehicle = {}
  for k, v in pairs( list.Get("Vehicles") ) do
    if v.Class == class then
      vehicle = v
    end
  end
  local car = ents.Create( vehicle.Class )
  if not car then return end
  car:SetModel( vehicle.Model )
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
end

function spawnItem( ply, ClassName, tab )
  local _distSpace = 8
  local _distMax = 2000
  local _angle = ply:EyeAngles()
  local ent = {}
  if tab == "vehicles" then
    ent = SpawnVehicle( ClassName )
  else
    ent = ents.Create( ClassName )
    if ent == NULL then return end
    ent:Spawn()
  end

  ent:SetPos( ply:GetPos() + Vector( 0, 0, math.abs( ent:OBBMins().z ) ) + Vector( 0, 0, 32 ) )
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
        return true
      end
    end
  end
  return false
end

net.Receive( "buyItem", function( len, ply )
  local _tab = net.ReadString()
  local _uniqueID = net.ReadString()

  local _item = dbSelect( "yrp_buy", "*", "uniqueID = " .. tonumber( _uniqueID ) )
  if ply:canAfford( -tonumber( _item[1].price ) ) then
    printGM( "note", ply:Nick() .. " can afford " .. tostring( _item[1].ClassName ) )
    ply:addMoney( -tonumber( _item[1].price ) )
    spawnItem( ply, _item[1].ClassName, _tab )
  else
    printGM( "note", ply:Nick() .. " can not afford " .. tostring( _item[1].ClassName ) )
  end
end)

net.Receive( "removeBuyItem", function( len, ply )
  local _uniqueID = net.ReadString()
  dbDeleteFrom( "yrp_buy", "uniqueID = " .. tonumber( _uniqueID )  )
end)

net.Receive( "addNewBuyItem", function( len, ply )
  local _tmpTab = net.ReadString()
  local _classname = net.ReadString()
  local _printname = net.ReadString()
  local _worldmodel = net.ReadString()
  local _price = net.ReadString()
  dbInsertInto( "yrp_buy", "tab, ClassName, PrintName, WorldModel, price", "'" .. _tmpTab .. "', '" .. _classname .. "', '" .. _printname .. "', '" .. _worldmodel .. "', " .. tonumber( _price ) )

  local _tmpTable = dbSelect( "yrp_buy", "*", "tab = '" .. _tmpTab .. "'" )
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
  local _tmpTable = dbSelect( "yrp_buy", "*", "tab = '" .. _tmpTab .. "'" )
  if _tmpTable == nil then
    _tmpTable = {}
  end
  net.Start( "getBuyList" )
    net.WriteString( _tmpTab )
    net.WriteTable( _tmpTable )
  net.Send( ply )
end)
