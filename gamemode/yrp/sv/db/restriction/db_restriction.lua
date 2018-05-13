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

SQL_ADD_COLUMN( _db_name, "canuseremovetool", "INT DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "canusephysgunpickup", "INT DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "canusedynamitetool", "INT DEFAULT 0" )

SQL_ADD_COLUMN( _db_name, "canignite", "INT DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "candrive", "INT DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "canchangecollision", "INT DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "canchangegravity", "INT DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "canchangekeepupright", "INT DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "canchangebodygroups", "INT DEFAULT 0" )

if SQL_SELECT( _db_name, "*", "usergroup = 'owner'" ) == nil then
  SQL_INSERT_INTO( _db_name, "usergroup, vehicles, weapons, duplicator, entities, effects, npcs, props, ragdolls, noclip, canuseremovetool, canusephysgunpickup, canusedynamitetool, canignite, candrive, canchangecollision, canchangegravity, canchangekeepupright, canchangebodygroups", "'owner', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1" )
end
if SQL_SELECT( _db_name, "*", "usergroup = 'superadmin'" ) == nil then
  SQL_INSERT_INTO( _db_name, "usergroup, vehicles, weapons, duplicator, entities, effects, npcs, props, ragdolls, noclip, canuseremovetool, canusephysgunpickup, canusedynamitetool, canignite, candrive, canchangecollision, canchangegravity, canchangekeepupright, canchangebodygroups", "'superadmin', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1" )
end
if SQL_SELECT( _db_name, "*", "usergroup = 'admin'" ) == nil then
  SQL_INSERT_INTO( _db_name, "usergroup, vehicles, weapons, duplicator, entities, effects, npcs, props, ragdolls, noclip, canuseremovetool, canusephysgunpickup, canusedynamitetool, canignite, candrive, canchangecollision, canchangegravity, canchangekeepupright, canchangebodygroups", "'admin', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1" )
end
if SQL_SELECT( _db_name, "*", "usergroup = 'user'" ) == nil then
  SQL_INSERT_INTO( _db_name, "usergroup", "'user'" )
end

--db_drop_table( _db_name )
--db_is_empty( _db_name )

hook.Add( "PlayerSpawnVehicle", "yrp_vehicles_restriction", function( pl, model, name, table )
  if ea( pl ) then
    local _tmp = SQL_SELECT( "yrp_restrictions", "vehicles", "usergroup = '" .. tostring( pl:GetUserGroup() ) .. "'" )
    if worked( _tmp, "PlayerSpawnVehicle failed" ) then
      _tmp = _tmp[1]
      if tobool( _tmp.vehicles ) then
        return true
      else
        printGM( "note", pl:Nick() .. " [" .. pl:GetUserGroup() .. "] tried to spawn a vehicle." )

        net.Start( "yrp_info" )
          net.WriteString( "vehicles" )
        net.Send( pl )

        return false
      end
    end
  end
end)

hook.Add( "PlayerGiveSWEP", "yrp_weapons_restriction", function( pl )
  if ea( pl ) then
    local _tmp = SQL_SELECT( "yrp_restrictions", "weapons", "usergroup = '" .. pl:GetUserGroup() .. "'" )
    if worked( _tmp, "PlayerGiveSWEP failed" ) then
      _tmp = _tmp[1]
      if tobool( _tmp.weapons ) then
        return true
      else
        printGM( "note", pl:Nick() .. " [" .. pl:GetUserGroup() .. "] tried to spawn a weapon." )

        net.Start( "yrp_info" )
          net.WriteString( "weapon" )
        net.Send( pl )

        return false
      end
    end
  end
end)

hook.Add( "PlayerSpawnSENT", "yrp_entities_restriction", function( pl )
  if ea( pl ) then
    local _tmp = SQL_SELECT( "yrp_restrictions", "entities", "usergroup = '" .. pl:GetUserGroup() .. "'" )
    if worked( _tmp, "PlayerSpawnSENT failed" ) then
      _tmp = _tmp[1]
      if tobool( _tmp.entities ) then
        return true
      else
        printGM( "note", pl:Nick() .. " [" .. pl:GetUserGroup() .. "] tried to spawn an entity." )

        net.Start( "yrp_info" )
          net.WriteString( "entities" )
        net.Send( pl )

        return false
      end
    end
  end
end)

hook.Add( "PlayerSpawnEffect", "yrp_effects_restriction", function( pl )
  if ea( pl ) then
    local _tmp = SQL_SELECT( "yrp_restrictions", "effects", "usergroup = '" .. pl:GetUserGroup() .. "'" )
    if worked( _tmp, "PlayerSpawnEffect failed" ) then
      _tmp = _tmp[1]
      if tobool( _tmp.effects ) then
        return true
      else
        printGM( "note", pl:Nick() .. " [" .. pl:GetUserGroup() .. "] tried to spawn an effect." )

        net.Start( "yrp_info" )
          net.WriteString( "effects" )
        net.Send( pl )

        return false
      end
    end
  end
end)

hook.Add( "PlayerSpawnNPC", "yrp_npcs_restriction", function( pl )
  if ea( pl ) then
    local _tmp = SQL_SELECT( "yrp_restrictions", "npcs", "usergroup = '" .. pl:GetUserGroup() .. "'" )
    if worked( _tmp, "PlayerSpawnNPC failed" ) then
      _tmp = _tmp[1]
      if tobool( _tmp.npcs ) then
        return true
      else
        printGM( "note", pl:Nick() .. " [" .. pl:GetUserGroup() .. "] tried to spawn a npc." )

        net.Start( "yrp_info" )
          net.WriteString( "npcs" )
        net.Send( pl )

        return false
      end
    end
  end
end)

hook.Add( "PlayerSpawnProp", "yrp_props_restriction", function( pl )
  if ea( pl ) then
    local _tmp = SQL_SELECT( "yrp_restrictions", "props", "usergroup = '" .. pl:GetUserGroup() .. "'" )
    if worked( _tmp, "PlayerSpawnProp failed" ) then
      _tmp = _tmp[1]
      if tobool( _tmp.props ) then
        return true
      else
        printGM( "note", pl:Nick() .. " [" .. pl:GetUserGroup() .. "] tried to spawn a prop." )

        net.Start( "yrp_info" )
          net.WriteString( "props" )
        net.Send( pl )

        return false
      end
    end
  end
end)

hook.Add( "PlayerSpawnRagdoll", "yrp_ragdolls_restriction", function( pl, model )
  if ea( pl ) then
    local _tmp = SQL_SELECT( "yrp_restrictions", "ragdolls", "usergroup = '" .. tostring( pl:GetUserGroup() ) .. "'" )
    if worked( _tmp, "PlayerSpawnRagdoll failed" ) then
      _tmp = _tmp[1]
      if tobool( _tmp.ragdolls ) then
        return true
      else
        printGM( "note", pl:Nick() .. " [" .. pl:GetUserGroup() .. "] tried to spawn a ragdoll." )

        net.Start( "yrp_info" )
          net.WriteString( "ragdolls" )
        net.Send( pl )

        return false
      end
    end
  end
end)

function RenderEquipment( ply, name, mode, color )
print( ply, name, mode, color )
  local _eq = ply:GetNWEntity( name )
  if ea( _eq ) then
    _eq:SetRenderMode( mode )
    _eq:SetColor( color )
    _eq:SetNWInt( name .. "mode", mode )
    _eq:SetNWString( name .. "color", color.r .. "," .. color.g .. "," .. color.b .. "," .. color.a )
  end
end

function RenderEquipments( ply, mode, color )
  RenderEquipment( ply, "backpack", mode, color )

  RenderEquipment( ply, "weaponprimary1", mode, color )
  RenderEquipment( ply, "weaponprimary2", mode, color )
  RenderEquipment( ply, "weaponsecondary1", mode, color )
  RenderEquipment( ply, "weaponsecondary2", mode, color )
  RenderEquipment( ply, "weapongadget", mode, color )
end

function RenderNoClip( ply, alpha )
  if ea( ply ) then
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
    RenderEquipments( ply, RENDERMODE_TRANSALPHA, Color( 255, 255, 255, _alpha ) )
  end
end

function RenderFrozen( ply )
  if ea( ply ) then
    ply:SetRenderMode( RENDERMODE_NORMAL )
    ply:SetColor( Color( 0, 0, 255 ) )
    for i, wp in pairs(ply:GetWeapons()) do
      wp:SetRenderMode( RENDERMODE_TRANSALPHA )
      wp:SetColor( Color( 0, 0, 255 ) )
    end
    RenderEquipments( ply, RENDERMODE_TRANSALPHA, Color( 0, 0, 255 ) )
  end
end

function RenderCloaked( ply )
  if ea( ply ) then
    local _alpha = 0
    ply:SetRenderMode( RENDERMODE_TRANSALPHA )
    ply:SetColor( Color( 255, 255, 255, _alpha ) )
    for i, wp in pairs(ply:GetWeapons()) do
      wp:SetRenderMode( RENDERMODE_TRANSALPHA )
      wp:SetColor( Color( 255, 255, 255, _alpha ) )
    end
    RenderEquipments( ply, RENDERMODE_TRANSALPHA, Color( 255, 255, 255, _alpha ) )
  end
end

function RenderNormal( ply )
  if ea( ply ) then
    if ply:GetNWBool( "cloaked", false ) then
      RenderCloaked( ply )
    elseif ply:IsFlagSet( FL_FROZEN ) then
      RenderFrozen( ply )
    else
      setPlayerModel( ply )
      ply:SetRenderMode( RENDERMODE_NORMAL )
      ply:SetColor( Color( 255, 255, 255, 255 ) )
      for i, wp in pairs(ply:GetWeapons()) do
        wp:SetRenderMode( RENDERMODE_NORMAL )
        wp:SetColor( Color( 255, 255, 255, 255 ) )
      end
      RenderEquipments( ply, RENDERMODE_NORMAL, Color( 255, 255, 255, 255 ) )
    end
  end
end

hook.Add( "PlayerNoClip", "yrp_noclip_restriction", function( pl, bool )
  if ea( pl ) then
    if !bool then
      -- TURNED OFF
      RenderNormal( pl )

      local _pos = pl:GetPos()

      -- Stuck?
      local tr = {
        start = _pos,
        endpos = _pos,
        mins = pl:OBBMins(),
        maxs = pl:OBBMaxs(),
        filter = pl
      }
      local _t = util.TraceHull( tr )

      if _t.Hit then
        -- Up
        local trup = {
          start = _pos+Vector(0,0,100),
          endpos = _pos,
          mins = Vector(1,1,0),
          maxs = Vector(-1,-1,0),
          filter = pl
        }
        local _tup = util.TraceHull( trup )

        -- Down
        local trdn = {
          start = _pos,
          endpos = _pos+Vector(0,0,100),
          mins = Vector(1,1,0),
          maxs = Vector(-1,-1,0),
          filter = pl
        }
        local _tdn = util.TraceHull( trdn )

        timer.Simple( 0.001, function()
          if !_tup.StartSolid and _tdn.StartSolid then
            pl:SetPos( _tup.HitPos + Vector( 0, 0, 1 ) )
          elseif _tup.StartSolid and !_tdn.StartSolid then
            pl:SetPos( _tdn.HitPos - Vector( 0, 0, 72+1 ) )
          elseif !_tup.StartSolid and !_tdn.StartSolid then
            _pos = _pos + Vector( 0, 0, 36 )
            if _pos:Distance( _tup.HitPos ) < _pos:Distance( _tdn.HitPos ) then
              pl:SetPos( _tup.HitPos + Vector( 0, 0, 1 ) )
            elseif _pos:Distance( _tup.HitPos ) > _pos:Distance( _tdn.HitPos ) then
              pl:SetPos( _tdn.HitPos - Vector( 0, 0, 72+6 ) )
            end
          end
        end)
      end
    else
      -- TURNED ON
      local _tmp = SQL_SELECT( "yrp_restrictions", "noclip", "usergroup = '" .. pl:GetUserGroup() .. "'" )
      if worked( _tmp, "PlayerNoClip failed" ) then
        _tmp = _tmp[1]
        if tobool( _tmp.noclip ) then

          if IsNoClipCrowEnabled() then
            pl:SetModel( "models/crow.mdl" )
          end

          RenderNoClip( pl )
          return true
        else
          printGM( "note", pl:Nick() .. " [" .. pl:GetUserGroup() .. "] tried to noclip." )

          net.Start( "yrp_info" )
            net.WriteString( "noclip" )
          net.Send( pl )

          return false
        end
      end
    end
  end
end)

hook.Add( "PhysgunPickup", "yrp_physgun_pickup", function( pl, ent )
  if ea( pl ) then
    --printGM( "gm", "PhysgunPickup: " .. pl:YRPName() )
    local _tmp = SQL_SELECT( "yrp_restrictions", "canusephysgunpickup", "usergroup = '" .. pl:GetUserGroup() .. "'" )
    if _tmp != nil and _tmp != false then
      _tmp = _tmp[1]
      if tobool( _tmp.canusephysgunpickup ) then
        return true
      else
        net.Start( "yrp_info" )
          net.WriteString( "canusephysgunpickup" )
        net.Send( pl )
        return false
      end
    else
      return false
    end
  end
end)

hook.Add( "CanTool", "yrp_can_tool", function( pl, tr, tool )
  if ea( pl ) then
    --printGM( "gm", "CanTool: " .. tool )
    if tool == "remover" then
      local _tmp = SQL_SELECT( "yrp_restrictions", "canuseremovetool", "usergroup = '" .. pl:GetUserGroup() .. "'" )
      if _tmp != nil and _tmp != false then
        _tmp = _tmp[1]
        if tobool( _tmp.canuseremovetool ) then
          return true
        else
          net.Start( "yrp_info" )
            net.WriteString( "canuseremovetool" )
          net.Send( pl )
          return false
        end
      else
        return false
      end
    elseif tool == "dynamite" then
      local _tmp = SQL_SELECT( "yrp_restrictions", "canusedynamitetool", "usergroup = '" .. pl:GetUserGroup() .. "'" )
      if _tmp != nil and _tmp != false then
        _tmp = _tmp[1]
        if tobool( _tmp.canusedynamitetool ) then
          return true
        else
          net.Start( "yrp_info" )
            net.WriteString( "canusedynamitetool" )
          net.Send( pl )
          return false
        end
      else
        return false
      end
    end
  end
end)

hook.Add( "CanProperty", "yrp_canproperty", function( pl, property, ent )
  if ea( pl ) then
    printGM( "gm", "CanProperty: " .. property )
    if property == "ignite" then
      local _tmp = SQL_SELECT( "yrp_restrictions", "canignite", "usergroup = '" .. pl:GetUserGroup() .. "'" )
      if _tmp != nil and _tmp != false then
        _tmp = _tmp[1]
        if tobool( _tmp.canignite ) then
          return true
        else
          net.Start( "yrp_info" )
            net.WriteString( "canignite" )
          net.Send( pl )
          return false
        end
      else
        return false
      end
    elseif property == "remover" then
      local _tmp = SQL_SELECT( "yrp_restrictions", "canuseremovetool", "usergroup = '" .. pl:GetUserGroup() .. "'" )
      if _tmp != nil and _tmp != false then
        _tmp = _tmp[1]
        if tobool( _tmp.canuseremovetool ) then
          return true
        else
          net.Start( "yrp_info" )
            net.WriteString( "canuseremovetool" )
          net.Send( pl )
          return false
        end
      else
        return false
      end
    elseif property == "drive" then
      local _tmp = SQL_SELECT( "yrp_restrictions", "candrive", "usergroup = '" .. pl:GetUserGroup() .. "'" )
      if _tmp != nil and _tmp != false then
        _tmp = _tmp[1]
        if tobool( _tmp.candrive ) then
          return true
        else
          net.Start( "yrp_info" )
            net.WriteString( "candrive" )
          net.Send( pl )
          return false
        end
      else
        return false
      end
    elseif property == "collision" then
      local _tmp = SQL_SELECT( "yrp_restrictions", "canchangecollision", "usergroup = '" .. pl:GetUserGroup() .. "'" )
      if _tmp != nil and _tmp != false then
        _tmp = _tmp[1]
        if tobool( _tmp.canchangecollision ) then
          return true
        else
          net.Start( "yrp_info" )
            net.WriteString( "canchangecollision" )
          net.Send( pl )
          return false
        end
      else
        return false
      end
    elseif property == "keepupright" then
      local _tmp = SQL_SELECT( "yrp_restrictions", "canchangekeepupright", "usergroup = '" .. pl:GetUserGroup() .. "'" )
      if _tmp != nil and _tmp != false then
        _tmp = _tmp[1]
        if tobool( _tmp.canchangekeepupright ) then
          return true
        else
          net.Start( "yrp_info" )
            net.WriteString( "canchangekeepupright" )
          net.Send( pl )
          return false
        end
      else
        return false
      end
    elseif property == "bodygroups" then
      local _tmp = SQL_SELECT( "yrp_restrictions", "canchangebodygroups", "usergroup = '" .. pl:GetUserGroup() .. "'" )
      if _tmp != nil and _tmp != false then
        _tmp = _tmp[1]
        if tobool( _tmp.canchangebodygroups ) then
          return true
        else
          net.Start( "yrp_info" )
            net.WriteString( "canchangebodygroups" )
          net.Send( pl )
          return false
        end
      else
        return false
      end
    elseif property == "gravity" then
      local _tmp = SQL_SELECT( "yrp_restrictions", "canchangegravity", "usergroup = '" .. pl:GetUserGroup() .. "'" )
      if _tmp != nil and _tmp != false then
        _tmp = _tmp[1]
        if tobool( _tmp.canchangegravity ) then
          return true
        else
          net.Start( "yrp_info" )
            net.WriteString( "canchangegravity" )
          net.Send( pl )
          return false
        end
      else
        return false
      end
    elseif property == "persist" then
      if pl:HasAccess() then
        return true
      else
        net.Start( "yrp_info" )
          net.WriteString( "persist" )
        net.Send( pl )
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
  local _result = SQL_UPDATE( _dbTable, _dbSets, _dbWhile )
  local _usergroup_ = string.Explode( " ", _dbWhile )
  local _restriction_ = string.Explode( " ", SQL_STR_IN( _dbSets ) )
  printGM( "note", ply:SteamName() .. " SETS " .. _dbSets .. " WHERE " .. _dbWhile )
end)
