//Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )
//db_players.lua

include( "players/db_net.lua" )
include( "players/db_func.lua" )

function dbPlayersAddValues( dbTable )
  sqlAddColumn( dbTable, "steamID", "TEXT" )
  sqlAddColumn( dbTable, "nick", "TEXT" )
  sqlAddColumn( dbTable, "nameFirst", "TEXT    DEFAULT 'ID_FIRSTNAME'" )
  sqlAddColumn( dbTable, "nameSur", "TEXT    DEFAULT 'ID_SURNAME'" )
  sqlAddColumn( dbTable, "money", "INT     DEFAULT 0" )
  sqlAddColumn( dbTable, "moneybank", "INT     DEFAULT 500" )
  sqlAddColumn( dbTable, "position", "TEXT" )
  sqlAddColumn( dbTable, "angle", "TEXT" )
  sqlAddColumn( dbTable, "gender", "TEXT    DEFAULT 'male'" )
  sqlAddColumn( dbTable, "capital", "INT     DEFAULT 0" )
  sqlAddColumn( dbTable, "roleID", "INT     DEFAULT 1" )
  sqlAddColumn( dbTable, "map", "TEXT" )
  sqlAddColumn( dbTable, "timestamp", "INT" )
  sqlAddColumn( dbTable, "keynrs", "TEXT    DEFAULT ''" )
end

function dbPlayersInit()
  //sql.Query( "DROP TABLE yrp_players")

  if sql.TableExists( "yrp_players" ) then
    printGM( "db", "yrp_players exists" )
  else
    local query = ""
    query = query .. "CREATE TABLE yrp_players ( "
    query = query .. "uniqueID  INTEGER PRIMARY KEY autoincrement"
    query = query .. " )"
    sql.Query( query )
		if sql.TableExists( "yrp_players" ) then
			printGM( "db", "CREATE TABLE yrp_players success" )
		else
			printError( "CREATE TABLE yrp_players fail" )
		end
  end
  dbPlayersAddValues( "yrp_players" )
end
