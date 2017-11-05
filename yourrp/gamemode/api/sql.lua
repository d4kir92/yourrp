--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function dbSQLStr( string )
  local _newString = sql.SQLStr( string, true )
  _newString = string.Replace( _newString, "'", " " )
  _newString = string.Replace( _newString, "\"", " " )
  return _newString
end

function dbTableExists( dbTable )
  if sql.TableExists( dbTable ) then
    return true
  else
    printGM( "note", dbTable .. " is not existing.")
    return false
  end
end

function dbSelect( dbTable, dbColumns, dbWhere )
  if dbTableExists( dbTable ) then
    local q = "SELECT "
    q = q .. dbColumns
    q = q .. " FROM "
    q = q .. dbTable
    if dbWhere != nil then
      q = q .. " WHERE "
      q = q .. dbWhere
    end
    local _result = sql.Query( q )
    if _result == nil then
      --printGM( "note", dbTable .. ": " .. q .." | NO DATA - can be ignored" )
      return _result
    elseif _result == false then
      printERROR( dbTable .. ": " .. q .. " FALSE" )
      --retryLoadDatabase()
      return _result
    else
      return _result
    end
  end
end


function dbInsertIntoDEFAULTVALUES( dbTable )
  if dbTableExists( dbTable ) then
    local q = "INSERT INTO "
    q = q .. dbTable
    q = q .. " DEFAULT VALUES"
    local result = sql.Query( q )
    if result != nil then
      printERROR( "dbInsertIntoDEFAULTVALUES: " .. q .. " has failed!")
    end
  end
end

function dbInsertInto( dbTable, dbColumns, dbValues )
  if dbTableExists( dbTable ) then
    local q = "INSERT INTO "
    q = q .. dbTable
    q = q .. " ( "
    q = q .. dbColumns
    q = q .. " ) VALUES ( "
    q = q .. dbValues
    q = q .. " )"
    local result = sql.Query( q )
    if result != nil then
      printERROR( "dbInsertInto: has failed!")
      print( sql.LastError() )
    end
  end
end

function dbDeleteFrom( dbTable, dbWhere )
  if dbTableExists( dbTable ) then
    local q = "DELETE FROM "
    q = q .. dbTable
    if dbWhere != nil then
      q = q .. " WHERE "
      q = q .. dbWhere
    end
    local _result = sql.Query( q )
  end
end

function dbUpdate( dbTable, dbSets, dbWhere )
  local _tmp = string.Explode( " = ", dbSets )
  for k, v in pairs( _tmp ) do
    if k%2 == 0 then
      if !dbSQLStr( v ) then
        printGM( "note", "dbUpdate FALSE" )
        return false
      end
    end
  end
  if dbTableExists( dbTable ) then
    local q = "UPDATE "
    q = q .. dbTable
    q = q .. " SET "
    q = q .. dbSets
    if dbWhere != nil then
      q = q .. " WHERE "
      q = q .. dbWhere
    end
    local _result = sql.Query( q )
    if _result != nil then
      printGM( "db", "Update not worked" )
    end
  end
end

function sqlCheckIfColumnExists( tableName, columnName )
  local q = "SELECT " .. columnName .. " FROM " .. tableName .. ""
  local result = sql.Query( q )
  if tostring( result ) == "false" then
    return false
  else
    return true
  end
end

function sqlAddColumn( tableName, columnName, datatype )
  local result = sqlCheckIfColumnExists( tableName, columnName )
  if result == false then
    local q = "ALTER TABLE " .. tableName .. " ADD " .. columnName .. " " .. datatype .. ""
    local _result = sql.Query( q )
  end
end

function initDatabase( dbName )
  printGMPre( "db", yrp.loaddb .. dbName )
  if sql.TableExists( dbName ) then
    printGM( "db", dbName .. " exists" )
  else
    printGM( "note", dbName .. " not exists" )
    local query = ""
    query = query .. "CREATE TABLE " .. dbName .. " ( "
    query = query .. "uniqueID    INTEGER         PRIMARY KEY autoincrement"
    query = query .. " )"
    sql.Query( query )
		if sql.TableExists( dbName ) then
      printGM( "db", dbName .. yrp.successdb )
		else
			printERROR( "CREATE TABLE " .. dbName .. " fail" )
      retryLoadDatabase()
		end
  end
  printGMPos()
end
