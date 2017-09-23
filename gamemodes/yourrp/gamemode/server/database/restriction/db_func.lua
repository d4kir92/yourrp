--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_func.lua
hook.Add( "PlayerSpawnVehicle", "yrp_vehicles_restriction", function( ply )
  local _tmp = dbSelect( "yrp_restrictions", "vehicles", "usergroup = '" .. ply:GetUserGroup() .. "'" )
  if _tmp != false and _tmp != nil then
    if tobool( _tmp[1].vehicles ) then
      return true
    else
      printGM( "note", ply:Nick() .. " [" .. ply:GetUserGroup() .. "] tried to spawn a vehicle." )
      return false
    end
  end
end)

hook.Add( "PlayerGiveSWEP", "yrp_weapons_restriction", function( ply )
  local _tmp = dbSelect( "yrp_restrictions", "weapons", "usergroup = '" .. ply:GetUserGroup() .. "'" )
  if _tmp != false and _tmp != nil then
    if tobool( _tmp[1].weapons ) then
      return true
    else
      printGM( "note", ply:Nick() .. " [" .. ply:GetUserGroup() .. "] tried to spawn a weapon." )
      return false
    end
  end
end)

hook.Add( "PlayerSpawnSENT", "yrp_entities_restriction", function( ply )
  local _tmp = dbSelect( "yrp_restrictions", "entities", "usergroup = '" .. ply:GetUserGroup() .. "'" )
  if _tmp != false and _tmp != nil then
    if tobool( _tmp[1].entities ) then
      return true
    else
      printGM( "note", ply:Nick() .. " [" .. ply:GetUserGroup() .. "] tried to spawn an entity." )
      return false
    end
  end
end)

hook.Add( "PlayerSpawnEffect", "yrp_effects_restriction", function( ply )
  local _tmp = dbSelect( "yrp_restrictions", "effects", "usergroup = '" .. ply:GetUserGroup() .. "'" )
  if _tmp != false and _tmp != nil then
    if tobool( _tmp[1].effects ) then
      return true
    else
      printGM( "note", ply:Nick() .. " [" .. ply:GetUserGroup() .. "] tried to spawn an effect." )
      return false
    end
  end
end)

hook.Add( "PlayerSpawnNPC", "yrp_npcs_restriction", function( ply )
  local _tmp = dbSelect( "yrp_restrictions", "npcs", "usergroup = '" .. ply:GetUserGroup() .. "'" )
  if _tmp != false and _tmp != nil then
    if tobool( _tmp[1].npcs ) then
      return true
    else
      printGM( "note", ply:Nick() .. " [" .. ply:GetUserGroup() .. "] tried to spawn a npc." )
      return false
    end
  end
end)

hook.Add( "PlayerSpawnProp", "yrp_props_restriction", function( ply )
  local _tmp = dbSelect( "yrp_restrictions", "props", "usergroup = '" .. ply:GetUserGroup() .. "'" )
  if _tmp != false and _tmp != nil then
    if tobool( _tmp[1].props ) then
      return true
    else
      printGM( "note", ply:Nick() .. " [" .. ply:GetUserGroup() .. "] tried to spawn a prop." )
      return false
    end
  end
end)

hook.Add( "PlayerSpawnRagdoll", "yrp_ragdolls_restriction", function( ply )
  local _tmp = dbSelect( "yrp_restrictions", "ragdolls", "usergroup = '" .. ply:GetUserGroup() .. "'" )
  if _tmp != false and _tmp != nil then
    if tobool( _tmp[1].ragdolls ) then
      return true
    else
      printGM( "note", ply:Nick() .. " [" .. ply:GetUserGroup() .. "] tried to spawn a ragdoll." )
      return false
    end
  end
end)
