--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

util.AddNetworkString( "db_update_hunger" )
util.AddNetworkString( "db_update_thirst" )
util.AddNetworkString( "db_update_stamina" )
util.AddNetworkString( "db_update_hud" )
util.AddNetworkString( "db_update_inventory" )
util.AddNetworkString( "db_update_dropitemsondeath" )
util.AddNetworkString( "db_update_graffiti" )
util.AddNetworkString( "dbUpdateNWBool2" )
util.AddNetworkString( "db_update_view_distance" )
util.AddNetworkString( "db_update_realistic_damage" )
util.AddNetworkString( "db_update_realistic_falldamage" )
util.AddNetworkString( "db_update_smartphone" )
util.AddNetworkString( "db_update_dealer_immortal" )
util.AddNetworkString( "db_update_weapon_lowering" )
util.AddNetworkString( "db_update_crosshair" )
util.AddNetworkString( "db_update_anti_bhop" )

util.AddNetworkString( "db_update_noclip_crow" )
util.AddNetworkString( "db_update_noclip_tags" )
util.AddNetworkString( "db_update_noclip_stealth" )
util.AddNetworkString( "db_update_noclip_effect" )

util.AddNetworkString( "db_update_tag_info" )
util.AddNetworkString( "db_update_tag_name" )
util.AddNetworkString( "db_update_tag_role" )
util.AddNetworkString( "db_update_tag_group" )
util.AddNetworkString( "db_update_tag_hp" )
util.AddNetworkString( "db_update_tag_ar" )

util.AddNetworkString( "db_update_server_changelevel" )
util.AddNetworkString( "db_update_playerscandropweapons" )
util.AddNetworkString( "db_update_appearancemenu" )

util.AddNetworkString( "db_update_showgroup" )
util.AddNetworkString( "db_update_showrole" )

util.AddNetworkString( "db_update_suicidedisabled" )

util.AddNetworkString( "db_update_collection" )

local _db_name = "yrp_general"

SQL_ADD_COLUMN( _db_name, "name_gamemode", "TEXT DEFAULT 'YourRP'" )
SQL_ADD_COLUMN( _db_name, "name_advert", "TEXT DEFAULT 'Advert'" )
SQL_ADD_COLUMN( _db_name, "time_restart", "TEXT DEFAULT '10'" )
SQL_ADD_COLUMN( _db_name, "access_jail", "TEXT DEFAULT -1" )

SQL_ADD_COLUMN( _db_name, "toggle_metabolism", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "toggle_building", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "toggle_hunger", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "toggle_thirst", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "toggle_stamina", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "toggle_hud", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "toggle_inventory", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "toggle_dropitemsondeath", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "toggle_graffiti", "INT DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "view_distance", "INT DEFAULT 200" )
SQL_ADD_COLUMN( _db_name, "toggle_realistic_damage", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "toggle_realistic_falldamage", "INT DEFAULT 1" )

SQL_ADD_COLUMN( _db_name, "toggle_smartphone", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "toggle_dealer_immortal", "INT DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "toggle_weapon_lowering", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "toggle_crosshair", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "toggle_anti_bhop", "INT DEFAULT 1" )

SQL_ADD_COLUMN( _db_name, "toggle_noclip_crow", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "toggle_noclip_stealth", "INT DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "toggle_noclip_tags", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "toggle_noclip_effect", "INT DEFAULT 1" )

SQL_ADD_COLUMN( _db_name, "tag_info", "INT DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "tag_name", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "tag_role", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "tag_group", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "tag_hp", "INT DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "tag_ar", "INT DEFAULT 0" )

SQL_ADD_COLUMN( _db_name, "server_changelevel", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "playerscandropweapons", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "appearancemenu", "INT DEFAULT 1" )

SQL_ADD_COLUMN( _db_name, "showgroup", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "showrole", "INT DEFAULT 1" )

SQL_ADD_COLUMN( _db_name, "suicidedisabled", "INT DEFAULT 1" )

SQL_ADD_COLUMN( _db_name, "collection", "INT DEFAULT 0" )

--db_drop_table( _db_name )
--db_is_empty( _db_name )

if SQL_SELECT( _db_name, "*", "uniqueID = 1" ) == nil then
  SQL_INSERT_INTO_DEFAULTVALUES( _db_name )
end

local _name_advert = ""
function get_advert_name()
  local _tmp = SQL_SELECT( _db_name, "name_advert", nil )
  if _tmp != nil then
    _tmp = _tmp[1]
    _name_advert = _tmp.value
  end
end
get_advert_name()

-- Scoreboard Commands
util.AddNetworkString( "ply_kick" )
net.Receive( "ply_kick", function( len, ply )
  if ply:HasAccess() then
    local _target = net.ReadEntity()
    _target:Kick( "You get kicked by " .. ply:YRPName() )
  end
end)
util.AddNetworkString( "ply_ban" )
net.Receive( "ply_ban", function( len, ply )
  if ply:HasAccess() then
    local _target = net.ReadEntity()
    _target:Ban( 24*60, false )
    _target:Kick( "You get banned for 24 hours by " .. ply:YRPName() )
  end
end)

util.AddNetworkString( "tp_tpto" )
net.Receive( "tp_tpto", function( len, ply )
  if ply:HasAccess() then
    local _target = net.ReadEntity()
    teleportToPoint( ply, _target:GetPos() )
  end
end)
util.AddNetworkString( "tp_bring" )
net.Receive( "tp_bring", function( len, ply )
  if ply:HasAccess() then
    local _target = net.ReadEntity()
    teleportToPoint( _target, ply:GetPos() )
  end
end)
util.AddNetworkString( "tp_jail" )
net.Receive( "tp_jail", function( len, ply )
  if ply:HasAccess() then
    local _target = net.ReadEntity()
    teleportToJailpoint( _target )
    _target:SetNWBool( "injail", true )
    _target:SetNWInt( "jailtime", 5*60 )
  end
end)
util.AddNetworkString( "tp_unjail" )
net.Receive( "tp_unjail", function( len, ply )
  if ply:HasAccess() then
    local _target = net.ReadEntity()
    teleportToReleasepoint( _target )
    _target:SetNWBool( "injail", false )
  end
end)

function DoRagdoll( ply )
  ply:SetNWBool( "ragdolled", true )

  local tmp = ents.Create( "prop_ragdoll" )
  tmp:SetModel( ply:GetModel() )
  tmp:SetModelScale( ply:GetModelScale(), 0 )
  tmp:SetPos( ply:GetPos() + Vector( 0, 0, 0 ) )
  tmp:Spawn()

  ply:SetParent( tmp )
  ply:SetNWEntity( "ragdoll", tmp )

  RenderCloaked( ply )
end

function DoUnRagdoll( ply )
  ply:SetNWBool( "ragdolled", false )

  local ragdoll = ply:GetNWEntity( "ragdoll" )
  ply:SetParent( nil )
  ply:SetPos( ragdoll:GetPos() )
  ragdoll:Remove()

  RenderNormal( ply )
end

util.AddNetworkString( "ragdoll" )
net.Receive( "ragdoll", function( len, ply )
  if ply:HasAccess() then
    local _target = net.ReadEntity()
    DoRagdoll( _target )
  end
end)
util.AddNetworkString( "unragdoll" )
net.Receive( "unragdoll", function( len, ply )
  if ply:HasAccess() then
    local _target = net.ReadEntity()
    DoUnRagdoll( _target )
  end
end)
util.AddNetworkString( "freeze" )
net.Receive( "freeze", function( len, ply )
  if ply:HasAccess() then
    local _target = net.ReadEntity()
    _target:Freeze( true )
    RenderFrozen( ply )
  end
end)
util.AddNetworkString( "unfreeze" )
net.Receive( "unfreeze", function( len, ply )
  if ply:HasAccess() then
    local _target = net.ReadEntity()
    _target:Freeze( false )
    RenderNormal( ply )
  end
end)
util.AddNetworkString( "god" )
net.Receive( "god", function( len, ply )
  if ply:HasAccess() then
    local _target = net.ReadEntity()
    _target:GodEnable()
    _target:AddFlags( FL_GODMODE )
    _target:SetNWBool( "godmode", true )
  end
end)
util.AddNetworkString( "ungod" )
net.Receive( "ungod", function( len, ply )
  if ply:HasAccess() then
    local _target = net.ReadEntity()
    _target:GodDisable()
    _target:RemoveFlags( FL_GODMODE )
    _target:SetNWBool( "godmode", false )
  end
end)
util.AddNetworkString( "cloak" )
net.Receive( "cloak", function( len, ply )
  if ply:HasAccess() then
    local _target = net.ReadEntity()
    _target:SetNWBool( "cloaked", true )

    RenderCloaked( ply )
  end
end)
util.AddNetworkString( "uncloak" )
net.Receive( "uncloak", function( len, ply )
  if ply:HasAccess() then
    local _target = net.ReadEntity()
    _target:SetNWBool( "cloaked", false )

    RenderNormal( ply )
  end
end)
util.AddNetworkString( "blind" )
net.Receive( "blind", function( len, ply )
  if ply:HasAccess() then
    local _target = net.ReadEntity()
    _target:SetNWBool( "blinded", true )
  end
end)
util.AddNetworkString( "unblind" )
net.Receive( "unblind", function( len, ply )
  if ply:HasAccess() then
    local _target = net.ReadEntity()
    _target:SetNWBool( "blinded", false )
  end
end)
util.AddNetworkString( "ignite" )
net.Receive( "ignite", function( len, ply )
  if ply:HasAccess() then
    local _target = net.ReadEntity()
    _target:Ignite( 10, 10 )
  end
end)
util.AddNetworkString( "extinguish" )
net.Receive( "extinguish", function( len, ply )
  if ply:HasAccess() then
    local _target = net.ReadEntity()
    _target:Extinguish()
  end
end)
util.AddNetworkString( "slay" )
net.Receive( "slay", function( len, ply )
  if ply:HasAccess() then
    local _target = net.ReadEntity()
    _target:Kill()
  end
end)
util.AddNetworkString( "slap" )
net.Receive( "slap", function( len, ply )
  if ply:HasAccess() then
    local _target = net.ReadEntity()
    _target:SetVelocity( Vector( 0, 0, 600 ) )
  end
end)

local yrp_general = {}

local _init_general = SQL_SELECT( _db_name, "*", nil )
if _init_general != false and _init_general != nil then
  yrp_general = _init_general[1]
end

function ServerCollection()
  return tobool( yrp_general.collection )
end

function IsDropItemsOnDeathEnabled()
  return tobool( yrp_general.toggle_dropitemsondeath or false )
end

function IsWeaponLoweringEnabled()
  return tobool( yrp_general.toggle_weapon_lowering or false )
end

function IsDealerImmortal()
  return tobool( yrp_general.toggle_dealer_immortal )
end

function IsNoClipEffectEnabled()
  return tobool( yrp_general.toggle_noclip_effect )
end

function IsNoClipStealthEnabled()
  return tobool( yrp_general.toggle_noclip_stealth )
end

function IsNoClipTagsEnabled()
  return tobool( yrp_general.toggle_noclip_tags )
end

function IsNoClipCrowEnabled()
  return tobool( yrp_general.toggle_noclip_crow )
end

function IsRealisticFallDamageEnabled()
  return tobool( yrp_general.toggle_realistic_falldamage )
end

function IsRealisticDamageEnabled()
  return tobool( yrp_general.toggle_realistic_damage )
end

function IsServerChangelevelEnabled()
  return tobool( yrp_general.server_changelevel )
end

function PlayersCanDropWeapons()
  return tobool( yrp_general.playerscandropweapons )
end

function ShowGroup()
  return tobool( yrp_general.showgroup )
end

function ShowRole()
  return tobool( yrp_general.showrole )
end

function IsSuicideDisabled()
  return tobool( yrp_general.suicidedisabled )
end

net.Receive( "db_update_suicidedisabled", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.suicidedisabled = _nw
    SQL_UPDATE( "yrp_general", "suicidedisabled = " .. yrp_general.suicidedisabled, nil )
    printGM( "note", ply:YRPName() .. " " .. bool_status( _nw ) .. " suicidedisabled" )
  end
end)

net.Receive( "db_update_showrole", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.showrole = _nw
    SQL_UPDATE( "yrp_general", "showrole = " .. yrp_general.showrole, nil )
    printGM( "note", ply:YRPName() .. " " .. bool_status( _nw ) .. " showrole" )
    for i, p in pairs( player.GetAll() ) do
      p:SetNWBool( "showrole", tobool(_nw) )
    end
  end
end)

net.Receive( "db_update_showgroup", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.showgroup = _nw
    SQL_UPDATE( "yrp_general", "showgroup = " .. yrp_general.showgroup, nil )
    printGM( "note", ply:YRPName() .. " " .. bool_status( _nw ) .. " showgroup" )
    for i, p in pairs( player.GetAll() ) do
      p:SetNWBool( "showgroup", tobool(_nw) )
    end
  end
end)

net.Receive( "db_update_appearancemenu", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.appearancemenu = _nw
    SQL_UPDATE( "yrp_general", "appearancemenu = " .. yrp_general.appearancemenu, nil )
    printGM( "note", ply:YRPName() .. " " .. bool_status( _nw ) .. " appearancemenu" )
    for i, p in pairs( player.GetAll() ) do
      p:SetNWBool( "appearancemenu", tobool(_nw) )
    end
  end
end)

net.Receive( "db_update_playerscandropweapons", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.playerscandropweapons = _nw
    SQL_UPDATE( "yrp_general", "playerscandropweapons = " .. yrp_general.playerscandropweapons, nil )
    printGM( "note", ply:YRPName() .. " " .. bool_status( _nw ) .. " playerscandropweapons" )
  end
end)

net.Receive( "db_update_server_changelevel", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.server_changelevel = _nw
    SQL_UPDATE( "yrp_general", "server_changelevel = " .. yrp_general.server_changelevel, nil )
    printGM( "note", ply:YRPName() .. " " .. bool_status( _nw ) .. " server_changelevel" )
  end
end)

net.Receive( "db_update_tag_ar", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.tag_ar = _nw
    SQL_UPDATE( "yrp_general", "tag_ar = " .. yrp_general.tag_ar, nil )
    printGM( "note", ply:YRPName() .. " " .. bool_status( _nw ) .. " tag_ar" )
  end
  for i, p in pairs( player.GetAll() ) do
    p:SetNWBool( "tag_ar", tobool(_nw) )
  end
end)

net.Receive( "db_update_tag_hp", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.tag_hp = _nw
    SQL_UPDATE( "yrp_general", "tag_hp = " .. yrp_general.tag_hp, nil )
    printGM( "note", ply:YRPName() .. " " .. bool_status( _nw ) .. " tag_hp" )
  end
  for i, p in pairs( player.GetAll() ) do
    p:SetNWBool( "tag_hp", tobool(_nw) )
  end
end)

net.Receive( "db_update_tag_group", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.tag_group = _nw
    SQL_UPDATE( "yrp_general", "tag_group = " .. yrp_general.tag_group, nil )
    printGM( "note", ply:YRPName() .. " " .. bool_status( _nw ) .. " tag_group" )
  end
  for i, p in pairs( player.GetAll() ) do
    p:SetNWBool( "tag_group", tobool(_nw) )
  end
end)

net.Receive( "db_update_tag_role", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.tag_role = _nw
    SQL_UPDATE( "yrp_general", "tag_role = " .. yrp_general.tag_role, nil )
    printGM( "note", ply:YRPName() .. " " .. bool_status( _nw ) .. " tag_info" )
  end
  for i, p in pairs( player.GetAll() ) do
    p:SetNWBool( "tag_role", tobool(_nw) )
  end
end)

net.Receive( "db_update_tag_name", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.tag_name = _nw
    SQL_UPDATE( "yrp_general", "tag_name = " .. yrp_general.tag_name, nil )
    printGM( "note", ply:YRPName() .. " " .. bool_status( _nw ) .. " tag_name" )
  end
  for i, p in pairs( player.GetAll() ) do
    p:SetNWBool( "tag_name", tobool(_nw) )
  end
end)

net.Receive( "db_update_tag_info", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.tag_info = _nw
    SQL_UPDATE( "yrp_general", "tag_info = " .. yrp_general.tag_info, nil )
    printGM( "note", ply:YRPName() .. " " .. bool_status( _nw ) .. " tag_info" )
  end
  for i, p in pairs( player.GetAll() ) do
    p:SetNWBool( "tag_info", tobool(_nw) )
  end
end)

net.Receive( "db_update_anti_bhop", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.toggle_anti_bhop = _nw
    SQL_UPDATE( "yrp_general", "toggle_anti_bhop = " .. yrp_general.toggle_anti_bhop, nil )
    printGM( "note", ply:YRPName() .. " " .. bool_status( _nw ) .. " anti_bhop" )
  end
  for i, p in pairs( player.GetAll() ) do
    p:SetNWBool( "anti_bhop", tobool(_nw) )
  end
end)

net.Receive( "db_update_collection", function( len, ply )
  local _nw = tonumber( net.ReadString() )
  if isnumber( _nw ) then
    yrp_general.collection = _nw
    SQL_UPDATE( "yrp_general", "collection = " .. yrp_general.collection, nil )
  end
end)

net.Receive( "db_update_crosshair", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.toggle_crosshair = _nw
    SQL_UPDATE( "yrp_general", "toggle_crosshair = " .. yrp_general.toggle_crosshair, nil )
    printGM( "note", ply:YRPName() .. " " .. bool_status( _nw ) .. " crosshair" )
  end
  for i, p in pairs( player.GetAll() ) do
    p:SetNWBool( "yrp_crosshair", tobool(_nw) )
  end
end)

net.Receive( "db_update_weapon_lowering", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.toggle_weapon_lowering = _nw
    SQL_UPDATE( "yrp_general", "toggle_weapon_lowering = " .. yrp_general.toggle_weapon_lowering, nil )
    printGM( "note", ply:YRPName() .. " " .. bool_status( _nw ) .. " weapon_lowering" )
  end
end)

net.Receive( "db_update_dealer_immortal", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.toggle_dealer_immortal = _nw
    SQL_UPDATE( "yrp_general", "toggle_dealer_immortal = " .. yrp_general.toggle_dealer_immortal, nil )
    printGM( "note", ply:YRPName() .. " " .. bool_status( _nw ) .. " dealer_immortal" )
  end
end)

net.Receive( "db_update_noclip_effect", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.toggle_noclip_effect = _nw
    SQL_UPDATE( "yrp_general", "toggle_noclip_effect = " .. yrp_general.toggle_noclip_effect, nil )
    printGM( "note", ply:YRPName() .. " " .. bool_status( _nw ) .. " noclip_effect" )
  end
end)

net.Receive( "db_update_noclip_crow", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.toggle_noclip_crow = _nw
    SQL_UPDATE( "yrp_general", "toggle_noclip_crow = " .. yrp_general.toggle_noclip_crow, nil )
    printGM( "note", ply:YRPName() .. " " .. bool_status( _nw ) .. " noclip_stealth" )
  end
end)

net.Receive( "db_update_noclip_tags", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.toggle_noclip_tags = _nw
    SQL_UPDATE( "yrp_general", "toggle_noclip_tags = " .. yrp_general.toggle_noclip_tags, nil )
    printGM( "note", ply:YRPName() .. " " .. bool_status( _nw ) .. " noclip_tags" )
  end
  for i, ply in pairs( player.GetAll() ) do
    ply:SetNWBool( "show_tags", tobool( yrp_general.toggle_noclip_tags ) )
  end
end)

net.Receive( "db_update_noclip_stealth", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.toggle_noclip_stealth = _nw
    SQL_UPDATE( "yrp_general", "toggle_noclip_stealth = " .. yrp_general.toggle_noclip_stealth, nil )
    printGM( "note", ply:YRPName() .. " " .. bool_status( _nw ) .. " noclip_stealth" )
  end
end)

net.Receive( "db_update_smartphone", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.toggle_smartphone = _nw
    SQL_UPDATE( "yrp_general", "toggle_smartphone = " .. yrp_general.toggle_smartphone, nil )
    printGM( "note", ply:YRPName() .. " " .. bool_status( _nw ) .. " smartphone" )
  end
  for i, ply in pairs( player.GetAll() ) do
    ply:SetNWBool( "toggle_smartphone", yrp_general.toggle_smartphone )
  end
end)

net.Receive( "db_update_realistic_damage", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.toggle_realistic_damage = _nw
    SQL_UPDATE( "yrp_general", "toggle_realistic_damage = " .. yrp_general.toggle_realistic_damage, nil )
    printGM( "note", ply:YRPName() .. " " .. bool_status( _nw ) .. " realistic_damage" )
  end
end)

net.Receive( "db_update_realistic_falldamage", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.toggle_realistic_falldamage = _nw
    SQL_UPDATE( "yrp_general", "toggle_realistic_falldamage = " .. yrp_general.toggle_realistic_falldamage, nil )
    printGM( "note", ply:YRPName() .. " " .. bool_status( _nw ) .. " realistic_falldamage" )
  end
end)

net.Receive( "db_update_graffiti", function( len, ply )
  local _nw_bool = tonumber( net.ReadInt( 4 ) )
  SQL_UPDATE( "yrp_general", "toggle_graffiti = " .. _nw_bool, nil )
  printGM( "note", ply:YRPName() .. " " .. bool_status( _nw_bool ) .. " grafiti" )

  for k, v in pairs( player.GetAll() ) do
    v:SetNWBool( "toggle_graffiti", tobool( _nw_bool ) )
  end
end)

net.Receive( "db_update_dropitemsondeath", function( len, ply )
  local _nw_bool = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw_bool ) then
    yrp_general.toggle_dropitemsondeath = _nw_bool
    SQL_UPDATE( "yrp_general", "toggle_dropitemsondeath = " .. yrp_general.toggle_dropitemsondeath, nil )
    printGM( "note", ply:YRPName() .. " " .. bool_status( yrp_general.toggle_dropitemsondeath ) .. " dropitemsondeath" )

    for k, v in pairs( player.GetAll() ) do
      v:SetNWBool( "toggle_dropitemsondeath", tobool( _nw_bool ) )
    end
  end
end)

net.Receive( "db_update_inventory", function( len, ply )
  local _nw_bool = tonumber( net.ReadInt( 4 ) )
  SQL_UPDATE( "yrp_general", "toggle_inventory = " .. _nw_bool, nil ) -- LATER _nw_bool, nil )
  printGM( "note", ply:YRPName() .. " " .. bool_status( _nw_bool ) .. " inventory" )

  for k, v in pairs( player.GetAll() ) do
    v:SetNWBool( "toggle_inventory", tobool( _nw_bool ) )
  end
end)

net.Receive( "db_update_hunger", function( len, ply )
  local _nw_bool = tonumber( net.ReadInt( 4 ) )
  SQL_UPDATE( "yrp_general", "toggle_hunger = " .. _nw_bool, nil )
  printGM( "note", ply:YRPName() .. " " .. bool_status( _nw_bool ) .. " hunger" )

  for k, v in pairs( player.GetAll() ) do
    v:SetNWBool( "toggle_hunger", tobool( _nw_bool ) )
  end
end)

net.Receive( "db_update_thirst", function( len, ply )
  local _nw_bool = tonumber( net.ReadInt( 4 ) )
  SQL_UPDATE( "yrp_general", "toggle_thirst = " .. _nw_bool, nil )
  printGM( "note", ply:YRPName() .. " " .. bool_status( _nw_bool ) .. " thirst" )

  for k, v in pairs( player.GetAll() ) do
    v:SetNWBool( "toggle_thirst", tobool( _nw_bool ) )
  end
end)

net.Receive( "db_update_stamina", function( len, ply )
  local _nw_bool = tonumber( net.ReadInt( 4 ) )
  SQL_UPDATE( "yrp_general", "toggle_stamina = " .. _nw_bool, nil )
  printGM( "note", ply:YRPName() .. " " .. bool_status( _nw_bool ) .. " stamina" )

  for k, v in pairs( player.GetAll() ) do
    v:SetNWBool( "toggle_stamina", tobool( _nw_bool ) )
  end
end)

net.Receive( "db_update_hud", function( len, ply )
  local _nw_bool = tonumber( net.ReadInt( 4 ) )
  SQL_UPDATE( "yrp_general", "toggle_hud = " .. _nw_bool, nil )
  printGM( "note", ply:YRPName() .. " " .. bool_status( _nw_bool ) .. " hud" )

  for k, v in pairs( player.GetAll() ) do
    v:SetNWBool( "toggle_hud", tobool( _nw_bool ) )
  end
end)

net.Receive( "dbUpdateNWBool2", function( len, ply )
  local _nw_bool = tonumber( net.ReadInt( 4 ) )
  SQL_UPDATE( "yrp_general", "toggle_building = " .. _nw_bool, nil )
  printGM( "note", ply:YRPName() .. " " .. bool_status( _nw_bool ) .. " building" )

  for k, v in pairs( player.GetAll() ) do
    v:SetNWBool( "toggle_building", tobool( _nw_bool ) )
  end
end)

net.Receive( "db_update_view_distance", function( len, ply )
  local _nw_int = tonumber( net.ReadInt( 16 ) )
  SQL_UPDATE( "yrp_general", "view_distance = " .. _nw_int, nil )
  printGM( "note", ply:YRPName() .. " SETS view_distance TO " .. tostring( _nw_int ) )

  for k, v in pairs( player.GetAll() ) do
    v:SetNWInt( "view_distance", _nw_int )
  end
end)

concommand.Add( "yrp_restart", function( ply, cmd, args )
	if ply:IsPlayer() then
		if ply:HasAccess() then
	    printGM( "note", "RESTARTING SERVER by " .. ply:Nick() )
      game.ConsoleCommand( "changelevel " .. GetMapNameDB() .. "\n" )
		else
	    printGM( "note", ply:Nick() .. " tried to restart server!" )
	  end
	else
    printGM( "note", "RESTARTING SERVER by [CONSOLE]" )
    game.ConsoleCommand( "changelevel " .. GetMapNameDB() .. "\n" )
  end
end )

util.AddNetworkString( "updateGeneral" )
util.AddNetworkString( "updateAdvert" )

net.Receive( "updateAdvert", function( len, ply )
  _name_advert = net.ReadString()
  SQL_UPDATE( "yrp_general", "name_advert = '" .. _name_advert .. "'", nil )
  for i, p in pairs( player.GetAll() ) do
    p:SetNWString( "channel_advert", _name_advert )
  end
end)

net.Receive( "getGamemodename", function( len, ply )
  net.Start( "getGamemodename" )
    net.WriteString( GAMEMODE.BaseName )
  net.Send( ply )
end)

net.Receive( "dbGetGeneral", function( len, ply )
  local _tmp = SQL_SELECT( "yrp_general", "*", nil )
  if worked( _tmp, "yrp_general failed @1" ) then
    _tmp = _tmp[1]
    net.Start( "dbGetGeneral" )
      net.WriteTable( _tmp )
    net.Send( ply )
  end
end)

net.Receive( "updateGeneral", function( len, ply )
  local _str = net.ReadString()

  local _result = SQL_UPDATE( "yrp_general", "time_restart = '" .. _str .. "'", nil )
end)
