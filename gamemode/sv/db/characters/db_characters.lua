--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local _db_name = "yrp_characters"

SQL_ADD_COLUMN( _db_name, "SteamID", "TEXT" )

SQL_ADD_COLUMN( _db_name, "roleID", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "groupID", "INT DEFAULT 1" )

SQL_ADD_COLUMN( _db_name, "playermodelID", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "skin", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "bg0", "INT DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "bg1", "INT DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "bg2", "INT DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "bg3", "INT DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "bg4", "INT DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "bg5", "INT DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "bg6", "INT DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "bg7", "INT DEFAULT 0" )

SQL_ADD_COLUMN( _db_name, "storage", "TEXT DEFAULT ''" )

SQL_ADD_COLUMN( _db_name, "keynrs", "TEXT DEFAULT ''" )
SQL_ADD_COLUMN( _db_name, "rpname", "TEXT DEFAULT 'ID_RPNAME'" )
SQL_ADD_COLUMN( _db_name, "rpdescription", "TEXT DEFAULT ''" )
SQL_ADD_COLUMN( _db_name, "gender", "TEXT DEFAULT 'gendermale'" )
SQL_ADD_COLUMN( _db_name, "money", "TEXT DEFAULT '250'" )
SQL_ADD_COLUMN( _db_name, "moneybank", "TEXT DEFAULT '500'" )
SQL_ADD_COLUMN( _db_name, "position", "TEXT" )
SQL_ADD_COLUMN( _db_name, "angle", "TEXT" )
SQL_ADD_COLUMN( _db_name, "map", "TEXT" )

--[[ EQUIPMENT ]]--
SQL_ADD_COLUMN( _db_name, "eqbp1", "TEXT DEFAULT ''" )
SQL_ADD_COLUMN( _db_name, "eqbag1", "TEXT DEFAULT ''" )
SQL_ADD_COLUMN( _db_name, "eqbag2", "TEXT DEFAULT ''" )
SQL_ADD_COLUMN( _db_name, "eqbag3", "TEXT DEFAULT ''" )
SQL_ADD_COLUMN( _db_name, "eqbag4", "TEXT DEFAULT ''" )

--db_drop_table( _db_name )
--db_is_empty( _db_name )

local Player = FindMetaTable( "Player" )

function Player:UpdateBackpack()
  if self.backpack != nil and self.backpack != NULL then
    self.backpack:Remove()
  end

  if self:HasCharacterSelected() then
    self:DoAnimationEvent( ACT_IDLE_ANGRY )

    local _uid = SQL_SELECT( "yrp_characters", "eqbp1", "uniqueID = '" .. self:CharID() .. "'" )
    _uid = _uid[1].eqbp1
    local _bp = SQL_SELECT( "yrp_items", "*", "storageID = '" .. _uid .. "'" )
    if _bp != nil then
      _bp = _bp[1]

      local _spine = self:LookupBone( "ValveBiped.Bip01_Spine4" )
      self.backpack = ents.Create( "prop_dynamic" )
      self.backpack:SetModel( _bp.WorldModel )
      self.backpack:SetModelScale( 0.5, 0 )

      self.backpack:Spawn()

      local pos, ang = self:GetBonePosition( _spine )
      local _cor = self:GetPos() - pos
      local _cor2 = self:GetAngles() - ang

      self.backpack:FollowBone( self, _spine )
      self.backpack:SetLocalPos( Vector( 0, 0, 0 ) + Vector( -10, -10, 0 ) )
	    self.backpack:SetLocalAngles( Angle( 0, 0, 0 ) + Angle( 90, -15, 90 ) )
      --self.backpack:SetPos( self:GetPos() - pos -_cor + Vector( -8, -8, 0 ) )
      --self.backpack:SetAngles( _cor2 ) --+ Angle( 0, self:GetAngles().y, 0 ) )
    end
    return _bp
  end
end

util.AddNetworkString( "update_backpack" )
net.Receive( "update_backpack", function( len, ply )
  local _bp = ply:UpdateBackpack()

  if _bp != nil then
    local _uid = _bp.intern_storageID

    local _stor = SQL_SELECT( "yrp_storages", "*", "uniqueID = '" .. _uid .. "'")
    _stor = _stor[1]

    net.Start( "update_backpack" )
      net.WriteBool( true )
      net.WriteTable( _stor )
    net.Send( ply )
  else
    net.Start( "update_backpack" )
      net.WriteBool( false )
    net.Send( ply )
  end
end)

util.AddNetworkString( "update_slot_backpack" )
net.Receive( "update_slot_backpack", function( len, ply )
  local _charid = ply:CharID()
  local _uid = SQL_SELECT( _db_name, "eqbp1", "uniqueID = '" .. _charid .. "'" )
  if _uid != nil then
    _uid = _uid[1].eqbp1
    local _backpack_storage = SQL_SELECT( "yrp_storages", "*", "uniqueID = '" .. _uid .. "'" )
    if _backpack_storage == nil then
      _backpack_storage = CreateEquipmentStorage( ply, "eqbp1", _charid )
      _backpack_storage = SQL_SELECT( "yrp_storages", "*", "uniqueID = '" .. _backpack_storage .. "'" )
    end
    _backpack_storage = _backpack_storage[1]
    net.Start( "update_slot_backpack" )
      net.WriteTable( _backpack_storage )
    net.Send( ply )
  end
end)

util.AddNetworkString( "moneyreset" )
net.Receive( "moneyreset", function( len, ply )
  printGM( "db", "<[MONEY RESET]>" )
  SQL_UPDATE( "yrp_characters", "money = '" .. "0" .. "'", nil )
  SQL_UPDATE( "yrp_characters", "moneybank = '" .. "0" .. "'", nil )
  for i, pl in pairs( player.GetAll() ) do
    pl:SetMoney( 0 )
  end
end)

util.AddNetworkString( "change_rpname" )
net.Receive( "change_rpname", function( len, ply )
  local _new_rp_name = net.ReadString()
  SQL_UPDATE( "yrp_characters", "rpname = '" .. db_sql_str( _new_rp_name ) .. "'", "uniqueID = " .. ply:CharID() )
  ply:SetNWString( "rpname", db_sql_str( _new_rp_name ) )
end)

util.AddNetworkString( "change_rpdescription" )
net.Receive( "change_rpdescription", function( len, ply )
  local _new_rp_description = net.ReadString()
  SQL_UPDATE( "yrp_characters", "rpdescription = '" .. db_sql_str( _new_rp_description ) .. "'", "uniqueID = " .. ply:CharID() )
  ply:SetNWString( "rpdescription", db_sql_str( _new_rp_description ) )
end)

util.AddNetworkString( "charGetGroups" )
util.AddNetworkString( "charGetRoles" )
util.AddNetworkString( "charGetRoleInfo" )

util.AddNetworkString( "yrp_get_characters" )

util.AddNetworkString( "DeleteCharacter" )
util.AddNetworkString( "CreateCharacter" )

util.AddNetworkString( "EnterWorld" )

net.Receive( "charGetGroups", function( len, ply )
  local tmpTable = SQL_SELECT( "yrp_groups", "*", nil )
  if tmpTable == nil then
    tmpTable = {}
  end
  net.Start( "charGetGroups" )
    net.WriteTable( tmpTable )
  net.Send( ply )
end)

net.Receive( "charGetRoles", function( len, ply )
  local groupID = net.ReadString()
  local netTable = {}
  local tmpTable = SQL_SELECT( "yrp_roles", "*", "groupID = " .. tonumber( groupID ) )
  if tmpTable != nil then
    local count = 1
    for k, v in pairs( tmpTable ) do
      local insert = true
      if tonumber( v.adminonly ) == 1 then
        if ply:HasAccess() then
          insert = true
        else
          insert = false
        end
      else
        if tonumber( v.maxamount ) > 0 then
          if tonumber( v.uses ) < tonumber( v.maxamount ) then
            insert = true
          else
            insert = false
          end
        end
        if insert then
          if tonumber( v.whitelist ) == 1 then
            insert = isWhitelisted( ply, v.uniqueID )
          end
        end
      end
      if insert then
        netTable[count] = {}
        netTable[count] = v
        count = count + 1
      end
    end
  end
  net.Start( "charGetRoles" )
    net.WriteTable( netTable )
  net.Send( ply )
end)

net.Receive( "charGetRoleInfo", function( len, ply )
  local roleID = net.ReadString()
  local tmpTable = SQL_SELECT( "yrp_roles", "*", "uniqueID = " .. tonumber( roleID ) )
  if tmpTable == nil then
    tmpTable = {}
  end
  net.Start( "charGetRoleInfo" )
    net.WriteTable( tmpTable )
  net.Send( ply )
end)

function send_characters( ply )
  local netTable = {}

  local chaTab = SQL_SELECT( "yrp_characters", "*", "SteamID = '" .. ply:SteamID() .. "'")

  local _charCount = 0
  if worked( chaTab, "yrp_get_characters" ) then
    for k, v in pairs( chaTab ) do
      if v.roleID != nil and v.groupID != nil then
        _charCount = _charCount + 1
        netTable[_charCount] = {}
        netTable[_charCount].char = v
        local tmp = SQL_SELECT( "yrp_roles", "*", "uniqueID = " .. tonumber( v.roleID ) )
        if worked( tmp, "charGetCharacters role" ) then
          tmp = tmp[1]
          netTable[_charCount].role = tmp
        else
          local tmpDefault = SQL_SELECT( "yrp_roles", "*", "uniqueID = " .. "1" )
          if worked( tmpDefault, "charGetCharacters tmpDefault" ) then
            tmpDefault = tmpDefault[1]
            netTable[_charCount].role = tmpDefault
          end
        end
        local tmp2 = SQL_SELECT( "yrp_roles", "*", "uniqueID = '" .. tonumber( v.roleID ) .. "'" )
        if tmp2 != nil and tmp2 != false then
          tmp2 = tmp2[1]
          local tmp3 = SQL_SELECT( "yrp_groups", "*", "uniqueID = '" .. tonumber( tmp2.groupID ) .. "'" )
          if worked( tmp3, "charGetCharacters group" ) then
            tmp3 = tmp3[1]
            netTable[_charCount].group = tmp3
          end
        end
      end
    end
  end
  local plytab = ply:GetPlyTab()
  if plytab != nil then
    netTable.plytab = plytab

    net.Start( "yrp_get_characters" )
      net.WriteTable( netTable )
    net.Send( ply )
  end
end

net.Receive( "yrp_get_characters", function( len, ply )
  printGM( "db", ply:YRPName() .. " ask for characters" )
  send_characters( ply )
end)

net.Receive( "DeleteCharacter", function( len, ply )
  local charID = net.ReadString()

  local result = SQL_DELETE_FROM( "yrp_characters", "uniqueID = '" .. tonumber( charID ) .. "'" )
  if result == nil then
    printGM( "db", "DeleteCharacter: success"  )
    ply:KillSilent()
    local _first_character = SQL_SELECT( "yrp_characters", "*", "SteamID = '" .. ply:SteamID() .. "'" )
    if _first_character != nil then
      _first_character = _first_character[1]
      local result = SQL_UPDATE( "yrp_players", "CurrentCharacter = " .. tonumber( _first_character.uniqueID ), "SteamID = '" .. ply:SteamID() .. "'" )
      local test = SQL_SELECT( "yrp_players", "*", nil )
    end
    ply:Spawn()
  else
    printGM( "note", "DeleteCharacter: fail"  )
  end
  send_characters( ply )
end)

net.Receive( "CreateCharacter", function( len, ply )
  local ch = net.ReadTable()

  local role = SQL_SELECT( "yrp_roles", "*", "uniqueID = " .. tonumber( ch.roleID ) )

  local cols = "SteamID, rpname, gender, roleID, groupID, playermodelID, money, moneybank, map, skin, bg0, bg1, bg2, bg3, bg4, bg5, bg6, bg7"
  local vals = "'" .. ply:SteamID() .. "', "
  vals = vals .. "'" .. db_sql_str( ch.rpname ) .. "', "
  vals = vals .. "'" .. db_sql_str( ch.gender ) .. "', "
  vals = vals .. tonumber( role[1].uniqueID ) .. ", "
  vals = vals .. tonumber( role[1].groupID ) .. ", "
  vals = vals .. tonumber( ch.playermodelID ) .. ", "
  vals = vals .. 250 .. ", "
  vals = vals .. 500 .. ", "
  vals = vals .. "'" .. GetMapNameDB() .. "', "
  vals = vals .. tonumber( ch.skin ) .. ", "
  vals = vals .. tonumber( ch.bg[0] ) .. ", "
  vals = vals .. tonumber( ch.bg[1] ) .. ", "
  vals = vals .. tonumber( ch.bg[2] ) .. ", "
  vals = vals .. tonumber( ch.bg[3] ) .. ", "
  vals = vals .. tonumber( ch.bg[4] ) .. ", "
  vals = vals .. tonumber( ch.bg[5] ) .. ", "
  vals = vals .. tonumber( ch.bg[6] ) .. ", "
  vals = vals .. tonumber( ch.bg[7] )
  SQL_INSERT_INTO( "yrp_characters", cols, vals )

  local chars = SQL_SELECT( "yrp_characters", "*", nil )
  if worked( chars, "CreateCharacter" ) then
    local result = SQL_UPDATE( "yrp_players", "CurrentCharacter = " .. tonumber( chars[#chars].uniqueID ), "SteamID = '" .. ply:SteamID() .. "'" )
  end
  send_characters( ply )
end)

net.Receive( "EnterWorld", function( len, ply )
  local char = net.ReadString()
  local result = SQL_UPDATE( "yrp_players", "CurrentCharacter = " .. tonumber( char ), "SteamID = '" .. ply:SteamID() .. "'" )
  local test = SQL_SELECT( "yrp_players", "*", nil )
  ply:Spawn()
end)

util.AddNetworkString( "get_menu_bodygroups" )

net.Receive( "get_menu_bodygroups", function( len, ply )
  local _charid = ply:CharID()
  local _result = SQL_SELECT( "yrp_characters", "bg0, bg1, bg2, bg3, bg4, bg5, bg6, bg7, skin, playermodelID", "uniqueID = " .. tonumber( _charid ) )
  _result = _result[1]
  local _role = ply:GetRolTab()
  _result.playermodels = _role.playermodels
  _result.playermodelsnone = _role.playermodelsnone
  if _result.playermodels == "" and _result.playermodelsnone == "" then
    -- nothing
  else
    net.Start( "get_menu_bodygroups" )
      net.WriteTable( _result )
    net.Send( ply )
  end
end)

util.AddNetworkString( "inv_bg_up" )

net.Receive( "inv_bg_up", function( len, ply )
  local _cur = net.ReadInt( 16 )
  local _id = net.ReadInt( 16 )
  ply:SetBodygroup( _id, _cur )
  local _charid = ply:CharID()
  SQL_UPDATE( "yrp_characters", "bg" .. tonumber( _id ) .. " = " .. tonumber( _cur ), "uniqueID = " .. tonumber( _charid ) )
end)

util.AddNetworkString( "inv_bg_do" )

net.Receive( "inv_bg_do", function( len, ply )
  local _cur = net.ReadInt( 16 )
  local _id = net.ReadInt( 16 )
  ply:SetBodygroup( _id, _cur )
  local _charid = ply:CharID()
  SQL_UPDATE( "yrp_characters", "bg" .. tonumber( _id ) .. " = " .. tonumber( _cur ), "uniqueID = " .. tonumber( _charid ) )
end)

util.AddNetworkString( "inv_skin_up" )

net.Receive( "inv_skin_up", function( len, ply )
  local _cur = net.ReadInt( 16 )
  ply:SetSkin( _cur )
  local _charid = ply:CharID()
  SQL_UPDATE( "yrp_characters", "skin" .. " = " .. tonumber( _cur ), "uniqueID = " .. tonumber( _charid ) )
end)

util.AddNetworkString( "inv_skin_do" )

net.Receive( "inv_skin_do", function( len, ply )
  local _cur = net.ReadInt( 16 )
  ply:SetSkin( _cur )
  local _charid = ply:CharID()
  SQL_UPDATE( "yrp_characters", "skin" .. " = " .. tonumber( _cur ), "uniqueID = " .. tonumber( _charid ) )
end)

util.AddNetworkString( "inv_pm_up" )

net.Receive( "inv_pm_up", function( len, ply )
  local _cur = net.ReadInt( 16 )
  local _pms = combineStringTables( ply:GetRolTab().playermodels, ply:GetRolTab().playermodelsnone )
  ply:SetModel( _pms[_cur] )
  local _charid = ply:CharID()
  SQL_UPDATE( "yrp_characters", "playermodelID" .. " = " .. tonumber( _cur ), "uniqueID = " .. tonumber( _charid ) )
  ply:UpdateBackpack()
end)

util.AddNetworkString( "inv_pm_do" )

net.Receive( "inv_pm_do", function( len, ply )
  local _cur = net.ReadInt( 16 )
  local _pms = combineStringTables( ply:GetRolTab().playermodels, ply:GetRolTab().playermodelsnone )
  ply:SetModel( _pms[_cur] )
  local _charid = ply:CharID()
  SQL_UPDATE( "yrp_characters", "playermodelID" .. " = " .. tonumber( _cur ), "uniqueID = " .. tonumber( _charid ) )
  ply:UpdateBackpack()
end)
