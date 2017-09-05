--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_general.lua

util.AddNetworkString( "dbUpdateNWBool" )

include( "general/db_net.lua" )
include( "general/db_func.lua" )

local dbName = "yrp_general"

sqlAddColumn( dbName, "name", "TEXT DEFAULT ''" )
sqlAddColumn( dbName, "value", "TEXT DEFAULT ''" )

if dbSelect( dbName, "*", "name = 'gamemodename'" ) == nil then
  dbInsertInto( dbName, "name, value", "'gamemodename', 'YourRP'" )
end
if dbSelect( dbName, "*", "name = 'advert'" ) == nil then
  dbInsertInto( dbName, "name, value", "'advert', 'Advert'" )
end
if dbSelect( dbName, "*", "name = 'restart_time'" ) == nil then
  dbInsertInto( dbName, "name, value", "'restart_time', '10'" )
end
if dbSelect( dbName, "*", "name = 'metabolism'" ) == nil then
  dbInsertInto( dbName, "name, value", "'metabolism', '1'" )
end

function getAdvertName()
  local tmpTable = dbSelect( dbName, "*", nil )
  for k, v in pairs( tmpTable ) do
    if v.name == "advert" then
      _advertname = v.value
    end
  end
end
getAdvertName()

net.Receive( "dbUpdateNWBool", function( len, ply )
  local _dbTable = net.ReadString()
  local _dbSets = net.ReadString()
  local _dbWhile = net.ReadString()
  local _NWBool = net.ReadBool()
  dbUpdate( _dbTable, _dbSets, _dbWhile )
  local _usergroup_ = string.Explode( " ", _dbWhile )
  local _restriction_ = string.Explode( " ", _dbSets )
  printGM( "note", ply:SteamName() .. " SETS " .. _dbSets .. " WHERE " .. _dbWhile )

  for k, v in pairs( player.GetAll() ) do
    v:SetNWBool( "metabolism", _NWBool )
  end
end)

concommand.Add( "yrp_restart", function( ply, cmd, args )
	if ply:IsPlayer() then
		if ply:IsSuperAdmin() then
	    printGM( "note", "RESTARTING SERVER by " .. ply:Nick() )
      game.ConsoleCommand( "changelevel " .. string.lower( game.GetMap() ) .. "\n" )
		else
	    printGM( "note", ply:Nick() .. " tried to restart server!" )
	  end
	else
    printGM( "note", "RESTARTING SERVER by [CONSOLE]" )
    game.ConsoleCommand( "changelevel " .. string.lower( game.GetMap() ) .. "\n" )
  end
end )
