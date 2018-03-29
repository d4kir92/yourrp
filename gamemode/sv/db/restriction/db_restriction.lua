--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local _db_name = "yrp_restrictions"

SQL_ADD_COLUMN( _db_name, "usergroup", "TEXT DEFAULT ''" )
SQL_ADD_COLUMN( _db_name, "vehicles", "INT DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "weapons", "INT DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "duplicator", "INT DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "entities", "INT DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "effects", "INT DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "npcs", "INT DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "props", "INT DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "ragdolls", "INT DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "noclip", "INT DEFAULT 0" )

if SQL_SELECT( _db_name, "*", "usergroup = 'owner'" ) == nil then
  SQL_INSERT_INTO( _db_name, "usergroup, vehicles, weapons, duplicator, entities, effects, npcs, props, ragdolls, noclip", "'owner', 1, 1, 1, 1, 1, 1, 1, 1, 1" )
end
if SQL_SELECT( _db_name, "*", "usergroup = 'superadmin'" ) == nil then
  SQL_INSERT_INTO( _db_name, "usergroup, vehicles, weapons, duplicator, entities, effects, npcs, props, ragdolls, noclip", "'superadmin', 1, 1, 1, 1, 1, 1, 1, 1, 1" )
end
if SQL_SELECT( _db_name, "*", "usergroup = 'admin'" ) == nil then
  SQL_INSERT_INTO( _db_name, "usergroup, vehicles, weapons, duplicator, entities, effects, npcs, props, ragdolls, noclip", "'admin', 1, 1, 1, 1, 1, 1, 1, 1, 1" )
end
if SQL_SELECT( _db_name, "*", "usergroup = 'user'" ) == nil then
  SQL_INSERT_INTO( _db_name, "usergroup", "'user'" )
end

--db_drop_table( _db_name )
--db_is_empty( _db_name )

hook.Add( "PlayerSpawnVehicle", "yrp_vehicles_restriction", function( ply )
  local _tmp = SQL_SELECT( "yrp_restrictions", "vehicles", "usergroup = '" .. ply:GetUserGroup() .. "'" )
  if worked( _tmp, "PlayerSpawnVehicle failed" ) then
    _tmp = _tmp[1]
    if tobool( _tmp.vehicles ) then
      return true
    else
      printGM( "note", ply:Nick() .. " [" .. ply:GetUserGroup() .. "] tried to spawn a vehicle." )

      net.Start( "yrp_info" )
        net.WriteString( "vehicles" )
      net.Send( ply )

      return false
    end
  end
end)

hook.Add( "PlayerGiveSWEP", "yrp_weapons_restriction", function( ply )
  local _tmp = SQL_SELECT( "yrp_restrictions", "weapons", "usergroup = '" .. ply:GetUserGroup() .. "'" )
  if worked( _tmp, "PlayerGiveSWEP failed" ) then
    _tmp = _tmp[1]
    if tobool( _tmp.weapons ) then
      return true
    else
      printGM( "note", ply:Nick() .. " [" .. ply:GetUserGroup() .. "] tried to spawn a weapon." )

      net.Start( "yrp_info" )
        net.WriteString( "weapon" )
      net.Send( ply )

      return false
    end
  end
end)

hook.Add( "PlayerSpawnSENT", "yrp_entities_restriction", function( ply )
  local _tmp = SQL_SELECT( "yrp_restrictions", "entities", "usergroup = '" .. ply:GetUserGroup() .. "'" )
  if worked( _tmp, "PlayerSpawnSENT failed" ) then
    _tmp = _tmp[1]
    if tobool( _tmp.entities ) then
      return true
    else
      printGM( "note", ply:Nick() .. " [" .. ply:GetUserGroup() .. "] tried to spawn an entity." )

      net.Start( "yrp_info" )
        net.WriteString( "entities" )
      net.Send( ply )

      return false
    end
  end
end)

hook.Add( "PlayerSpawnEffect", "yrp_effects_restriction", function( ply )
  local _tmp = SQL_SELECT( "yrp_restrictions", "effects", "usergroup = '" .. ply:GetUserGroup() .. "'" )
  if worked( _tmp, "PlayerSpawnEffect failed" ) then
    _tmp = _tmp[1]
    if tobool( _tmp.effects ) then
      return true
    else
      printGM( "note", ply:Nick() .. " [" .. ply:GetUserGroup() .. "] tried to spawn an effect." )

      net.Start( "yrp_info" )
        net.WriteString( "effects" )
      net.Send( ply )

      return false
    end
  end
end)

hook.Add( "PlayerSpawnNPC", "yrp_npcs_restriction", function( ply )
  local _tmp = SQL_SELECT( "yrp_restrictions", "npcs", "usergroup = '" .. ply:GetUserGroup() .. "'" )
  if worked( _tmp, "PlayerSpawnNPC failed" ) then
    _tmp = _tmp[1]
    if tobool( _tmp.npcs ) then
      return true
    else
      printGM( "note", ply:Nick() .. " [" .. ply:GetUserGroup() .. "] tried to spawn a npc." )

      net.Start( "yrp_info" )
        net.WriteString( "npcs" )
      net.Send( ply )

      return false
    end
  end
end)

hook.Add( "PlayerSpawnProp", "yrp_props_restriction", function( ply )
  local _tmp = SQL_SELECT( "yrp_restrictions", "props", "usergroup = '" .. ply:GetUserGroup() .. "'" )
  if worked( _tmp, "PlayerSpawnProp failed" ) then
    _tmp = _tmp[1]
    if tobool( _tmp.props ) then
      return true
    else
      printGM( "note", ply:Nick() .. " [" .. ply:GetUserGroup() .. "] tried to spawn a prop." )

      net.Start( "yrp_info" )
        net.WriteString( "props" )
      net.Send( ply )

      return false
    end
  end
end)

hook.Add( "PlayerSpawnRagdoll", "yrp_ragdolls_restriction", function( ply )
  local _tmp = SQL_SELECT( "yrp_restrictions", "ragdolls", "usergroup = '" .. ply:GetUserGroup() .. "'" )
  if worked( _tmp, "PlayerSpawnRagdoll failed" ) then
    _tmp = _tmp[1]
    if tobool( _tmp.ragdolls ) then
      return true
    else
      printGM( "note", ply:Nick() .. " [" .. ply:GetUserGroup() .. "] tried to spawn a ragdoll." )

      net.Start( "yrp_info" )
        net.WriteString( "ragdolls" )
      net.Send( ply )

      return false
    end
  end
end)

hook.Add( "PlayerNoClip", "yrp_noclip_restriction", function( ply, bool )

  if !bool then
    setPlayerModel( ply )
    ply:SetRenderMode( RENDERMODE_NORMAL )
    ply:SetColor( Color( 255, 255, 255, 255 ) )
    for i, wp in pairs(ply:GetWeapons()) do
      wp:SetRenderMode( RENDERMODE_NORMAL )
      wp:SetColor( Color( 255, 255, 255, 255 ) )
    end
  else
    local _tmp = SQL_SELECT( "yrp_restrictions", "noclip", "usergroup = '" .. ply:GetUserGroup() .. "'" )
    if worked( _tmp, "PlayerNoClip failed" ) then
      _tmp = _tmp[1]
      if tobool( _tmp.noclip ) then

        if IsNoClipCrowEnabled() then
          ply:SetModel( "models/crow.mdl" )
        end

        local _alpha = 255
        if IsNoClipEffectEnabled() then
          if IsNoClipStealthEnabled() then
            if ply:GetModel() == "models/crow.mdl" then
              _alpha = 180
            else
              _alpha = 10
            end
          else
            if ply:GetModel() == "models/crow.mdl" then
              _alpha = 240
            else
              _alpha = 100
            end
          end
        end
        ply:SetRenderMode( RENDERMODE_TRANSALPHA )
        ply:SetColor( Color( 255, 255, 255, _alpha ) )
        for i, wp in pairs(ply:GetWeapons()) do
          wp:SetRenderMode( RENDERMODE_TRANSALPHA )
          wp:SetColor( Color( 255, 255, 255, _alpha ) )
        end

        return true
      else
        printGM( "note", ply:Nick() .. " [" .. ply:GetUserGroup() .. "] tried to noclip." )

        net.Start( "yrp_info" )
          net.WriteString( "noclip" )
        net.Send( ply )

        return false
      end
    end
  end
end)


util.AddNetworkString( "getRistrictions" )
util.AddNetworkString( "db_jailaccess" )
util.AddNetworkString( "dbUpdate" )

net.Receive( "getRistrictions", function( len, ply )
  local _usergroups = {}
  for k, v in pairs( player.GetAll() ) do
    local _ug = v:GetUserGroup()
    if SQL_SELECT( _db_name, "*", "usergroup = '" .. _ug .. "'" ) == nil then
      printGM( "note", "usergroup: " .. _ug .. " not found, adding to db" )
      SQL_INSERT_INTO( _db_name, "usergroup", "'" .. _ug .. "'" )
    end
  end

  local _tmp = SQL_SELECT( _db_name, "*", nil )
  net.Start( "getRistrictions" )
  if _tmp != nil then
    net.WriteTable( _tmp )
  else
    net.WriteTable( {} )
  end
  net.Send( ply )

end)

util.AddNetworkString( "remove_res_usergroup" )

net.Receive( "remove_res_usergroup", function( len, ply )
  local _ug = net.ReadString()
  SQL_DELETE_FROM( _db_name, "usergroup = '" .. _ug .. "'" )
end)

net.Receive( "db_jailaccess", function( len, ply )
  local _dbTable = net.ReadString()
  local _dbSets = net.ReadString()

  local _result = SQL_UPDATE( _dbTable, _dbSets, "uniqueID = 1" )
  if _result != nil then
    printGM( "error", "access_jail failed!" )
  end
end)

net.Receive( "dbUpdate", function( len, ply )
  local _dbTable = net.ReadString()
  local _dbSets = net.ReadString()
  local _dbWhile = net.ReadString()
  SQL_UPDATE( _dbTable, _dbSets, _dbWhile )
  local _usergroup_ = string.Explode( " ", _dbWhile )
  local _restriction_ = string.Explode( " ", db_in_str( _dbSets ) )
  printGM( "note", ply:SteamName() .. " SETS " .. _dbSets .. " WHERE " .. _dbWhile )
end)
