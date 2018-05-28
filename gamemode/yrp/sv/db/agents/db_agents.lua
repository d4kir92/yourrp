--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local _db_name = "yrp_agents"
SQL_ADD_COLUMN( _db_name, "target", "TEXT DEFAULT 'No Target'" )
SQL_ADD_COLUMN( _db_name, "reward", "INTEGER DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "description", "TEXT DEFAULT 'NO DESCRIPTION'" )
SQL_ADD_COLUMN( _db_name, "contract_SteamID", "TEXT DEFAULT ' '" )

--db_drop_table( _db_name )
--db_is_empty( _db_name )

util.AddNetworkString( "yrp_placehit" )
util.AddNetworkString( "yrp_gethits" )
util.AddNetworkString( "yrp_accepthit" )

net.Receive( "yrp_placehit", function( len, ply )
  local _steamid = net.ReadString()
  local _reward = net.ReadString()
  local _desc = net.ReadString()

  printGM( "note", "[AGENTS] received hit info: " .. _steamid .. ", " .. _reward .. ", " .. SQL_STR_IN( _desc ) )
  _reward = tonumber( _reward )
  if ply:canAfford( _reward ) then
    ply:addMoney( - _reward )
    printGM( "note", "Set hit" )
    local _res = SQL_INSERT_INTO( _db_name, "target, reward, description, contract_SteamID", "'" .. _steamid .. "', " .. _reward .. ", '" .. SQL_STR_IN( _desc ) .. "', '" .. ply:SteamID() .. "'" )

  else
    printGM( "note", "Cant afford hit" )
  end
end)

net.Receive( "yrp_gethits", function( len, ply )
  local _hits = SQL_SELECT( _db_name, "*", nil )
  if _hits != nil then
    net.Start( "yrp_gethits" )
      net.WriteTable( _hits )
    net.Send( ply )
  end
end)

util.AddNetworkString( "yrp_get_contracts" )
net.Receive( "yrp_get_contracts", function( len, ply )
  local _hits = SQL_SELECT( _db_name, "*", "contract_SteamID = '" .. ply:SteamID() .. "'" )
  if _hits != nil then
    net.Start( "yrp_get_contracts" )
      net.WriteTable( _hits )
    net.Send( ply )
  end
end)

function hitdone( target, agent )
  SQL_DELETE_FROM( _db_name, "uniqueID = " .. target:GetNWString( "hituid" ) )

  target:SetNWBool( "iswanted", false )
  target:SetNWString( "hitreward", "" )
  target:SetNWString( "hituid", "" )
  agent:SetNWString( "hittargetName", "" )
  agent:SetNWEntity( "hittarget", NULL )
end

function hitquit( agent )
  agent:SetNWString( "hittargetName", "" )
  agent:SetNWEntity( "hittarget", NULL )
end

net.Receive( "yrp_accepthit", function( len, ply )
  local _uid = net.ReadString()
  local _hit = SQL_SELECT( _db_name, "*", "uniqueID = " .. _uid )

  if _hit != nil then
    _hit = _hit[1]
    for i, p in pairs( player.GetAll() ) do
      if _hit.target == p:SteamID() then
        p:SetNWBool( "iswanted", true )
        p:SetNWString( "hitreward", _hit.reward )
        p:SetNWString( "hituid", _hit.uniqueID )
        ply:SetNWString( "hittargetName", p:RPName() )
        ply:SetNWEntity( "hittarget", p )
        break
      end
    end
  end
end)
