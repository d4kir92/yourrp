--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local _db_name = "yrp_storages"

--[[ ITEM ]]--
SQL_ADD_COLUMN( _db_name, "name", "TEXT DEFAULT 'Unnamed Storage'" )
SQL_ADD_COLUMN( _db_name, "sizew", "INT DEFAULT 2" )
SQL_ADD_COLUMN( _db_name, "sizeh", "INT DEFAULT 2" )
SQL_ADD_COLUMN( _db_name, "posx", "TEXT DEFAULT '0'" )
SQL_ADD_COLUMN( _db_name, "posy", "TEXT DEFAULT '0'" )
SQL_ADD_COLUMN( _db_name, "posz", "TEXT DEFAULT '0'" )
SQL_ADD_COLUMN( _db_name, "angp", "TEXT DEFAULT '0'" )
SQL_ADD_COLUMN( _db_name, "angy", "TEXT DEFAULT '0'" )
SQL_ADD_COLUMN( _db_name, "angr", "TEXT DEFAULT '0'" )
SQL_ADD_COLUMN( _db_name, "ClassName", "TEXT DEFAULT 'error'" )
SQL_ADD_COLUMN( _db_name, "ParentID", "TEXT DEFAULT ''" )
SQL_ADD_COLUMN( _db_name, "map", "TEXT DEFAULT ''" )

--db_drop_table(_db_name)

function SaveStorages( str )
  printGM( "db", "SaveStorages( " .. string.upper( tostring( str ) ) .. " )" )
  local _ents = ents.GetAll()
  for i, ent in pairs( _ents ) do
    if ent:GetNWString( "storage_uid", "" ) != "" then
      local _pos = string.Explode( " ", tostring( ent:GetPos() ) )
      local _posx = _pos[1]
      local _posy = _pos[2]
      local _posz = _pos[3]
      local _ang = string.Explode( " ", tostring( ent:GetAngles() ) )
      local _angp = _ang[1]
      local _angy = _ang[2]
      local _angr = _ang[3]

      SQL_UPDATE( _db_name, "posx = '" .. _posx .. "', posy = '" .. _posy .. "', posz = '" .. _posz .. "', angp = '" .. _angp .. "', angy = '" .. _angy .. "', angr = '" .. _angr .. "'", "uniqueID = '" .. ent:GetNWString( "storage_uid" ) .. "'" )
    end
  end
end

function LoadStorages()
  local _storages = SQL_SELECT( _db_name, "*", "map = '" .. game.GetMap() .. "'" )

  if _storages == nil or _storages == false then
    _storages = {}
  end

  for i, stor in pairs( _storages ) do
    local _tmp = ents.Create( stor.ClassName )
    _tmp:SetNWString( "storage_uid", stor.uniqueID )
    if _tmp != NULL then
      _tmp:SetPos( Vector( stor.posx, stor.posy, stor.posz ) )
      _tmp:SetAngles( Angle( stor.angp, stor.angy, stor.angr ) )
      _tmp:Spawn()
      _tmp:DropToFloor()
      timer.Simple( 0.01, function()
        _tmp:GetPhysicsObject():EnableMotion( false )
      end)
    end
  end
end

function InitStorage( ent, sizew, sizeh )
  timer.Simple( 0.1, function()
    local _storage = nil
    local _uid = tonumber( ent:GetNWString( "storage_uid", "0" ) )
    if _uid != 0 then
      --[[ FOUND STORAGE ]]--
      _storage = SQL_SELECT( _db_name, "*", "uniqueID = " .. _uid )
    else
      --[[ NEW STORAGE ]]--
      printGM( "note", "NEW STORAGE( " .. tostring( ent ) .. ", " .. sizew .. ", " .. sizeh .. " )" )
      local _pos = string.Explode( " ", tostring( ent:GetPos() ) )
      local _posx = _pos[1]
      local _posy = _pos[2]
      local _posz = _pos[3]
      local _ang = string.Explode( " ", tostring( ent:GetAngles() ) )
      local _angp = _ang[1]
      local _angy = _ang[2]
      local _angr = _ang[3]
      local _r = SQL_INSERT_INTO( _db_name, "map, sizew, sizeh, ClassName, posx, posy, posz, angp, angy, angr", "'" .. game.GetMap() .. "', " .. sizew .. ", " .. sizeh .. ", '" .. ent:GetClass() .. "', '" .. _posx .. "', '" .. _posy .. "', '" .. _posz .. "', '" .. _angp .. "', '" .. _angy .. "', '" .. _angr .. "'"  )
      local _storages = SQL_SELECT( _db_name, "*", nil )
      for i, stor in pairs( _storages ) do
        if tonumber( stor.uniqueID ) > _uid then
          _uid = tonumber( stor.uniqueID )
        end
      end
      ent:SetNWString( "storage_uid", _uid )
      _storage = SQL_SELECT( _db_name, "*", "uniqueID = " .. ent:GetNWString( "storage_uid" ) )
    end
    _storage = _storage[1]
    ent:SetNWBool( "storagename", _storage.name )
    ent:SetNWBool( "hasinventory", true )
    return _storage
  end)
end

util.AddNetworkString( "openStorage" )
function openStorage( ply, uid )
  local _storages = {}

  --[[ Add World Storage ]]--
  if uid != nil then
    local _result = SQL_SELECT( _db_name, "*", "uniqueID = " .. uid )
    _result = _result[1]
    table.insert( _storages, _result )
  end

  --[[ Add Storages from Player ]]--
  local _ply_storages = SQL_SELECT( _db_name, "*", "ParentID = '" .. ply:SteamID() .. "'" )
  if _ply_storages != false and _ply_storages != nil then
    for i, plystor in pairs( _ply_storages ) do
      table.insert( _storages, plystor )
    end
  end

  net.Start( "openStorage" )
    net.WriteTable( _storages )
  net.Send( ply )
end
net.Receive( "openStorage", function( len, ply )
  openStorage( ply )
end)
