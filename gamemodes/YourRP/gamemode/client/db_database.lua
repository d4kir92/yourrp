
cl_db = {}
cl_db["_load"] = 0

function dbTableExists( dbTable )
  if sql.TableExists( dbTable ) then
    return true
  else
    printGM( "note", dbTable .. " is not existing.")
    return false
  end
end

function dbSelect( dbTable, dbColumns, dbWhere )
  local q = "SELECT "
  q = q .. dbColumns
  q = q .. " FROM "
  q = q .. dbTable
  if dbWhere != nil then
    q = q .. " WHERE "
    q = q .. dbWhere
  end
  local _result = sql.Query( q )
  return _result
end

function dbInsertInto( dbTable, dbColumns, dbValues )
  local q = "INSERT INTO "
  q = q .. dbTable
  q = q .. " ( "
  q = q .. dbColumns
  q = q .. " ) VALUES ( "
  q = q .. dbValues
  q = q .. " )"
  local result = sql.Query( q )
end

function dbUpdate( dbTable, dbSets, dbWhere )
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
  end
end

function sqlAddColumn( tableName, columnName, datatype )
  local result = sqlCheckIfColumnExists( tableName, columnName )
  if result == false then
    local q = "ALTER TABLE " .. tableName .. " ADD " .. columnName .. " " .. datatype .. ""
    local _result = sql.Query( q )
  else
    //printGM( columnName .. " vorhanden" )
  end
end

function updateDBHud( name, value )
  local query = "UPDATE yrp_cl_hud "
  query = query .. "SET value = " .. tonumber( value ) .. " "
  query = query .. "WHERE name = '" .. tostring( name ) .. "'"

  local result = sql.Query( query )
end

function loadDBHud( name )
  local tmpValue = sql.Query( "SELECT value FROM yrp_cl_hud WHERE name = '" .. name .. "' LIMIT 1" )
  cl_db[name] = tmpValue[1].value
end

function loadCompleteHud()
  loadDBHud( "mmt" )
  loadDBHud( "mmx" )
  loadDBHud( "mmy" )
  loadDBHud( "mmw" )
  loadDBHud( "mmh" )

  loadDBHud( "hpt" )
  loadDBHud( "hpx" )
  loadDBHud( "hpy" )
  loadDBHud( "hpw" )
  loadDBHud( "hph" )

  loadDBHud( "art" )
  loadDBHud( "arx" )
  loadDBHud( "ary" )
  loadDBHud( "arw" )
  loadDBHud( "arh" )

  loadDBHud( "rit" )
  loadDBHud( "rix" )
  loadDBHud( "riy" )
  loadDBHud( "riw" )
  loadDBHud( "rih" )

  loadDBHud( "ttt" )
  loadDBHud( "ttx" )
  loadDBHud( "tty" )
  loadDBHud( "ttw" )
  loadDBHud( "tth" )

  loadDBHud( "mot" )
  loadDBHud( "mox" )
  loadDBHud( "moy" )
  loadDBHud( "mow" )
  loadDBHud( "moh" )

  loadDBHud( "vox" )
  loadDBHud( "voy" )
end

function setDefaultHud()
  dbUpdate( "yrp_cl_hud", "value = 1", "name = 'mmt'" )
  dbUpdate( "yrp_cl_hud", "value = 20", "name = 'mmx'" )
  dbUpdate( "yrp_cl_hud", "value = 1740", "name = 'mmy'" )
  dbUpdate( "yrp_cl_hud", "value = 400", "name = 'mmw'" )
  dbUpdate( "yrp_cl_hud", "value = 400", "name = 'mmh'" )

  dbUpdate( "yrp_cl_hud", "value = 1", "name = 'hpt'" )
  dbUpdate( "yrp_cl_hud", "value = 420", "name = 'hpx'" )
  dbUpdate( "yrp_cl_hud", "value = 2080", "name = 'hpy'" )
  dbUpdate( "yrp_cl_hud", "value = 400", "name = 'hpw'" )
  dbUpdate( "yrp_cl_hud", "value = 60", "name = 'hph'" )

  dbUpdate( "yrp_cl_hud", "value = 1", "name = 'art'" )
  dbUpdate( "yrp_cl_hud", "value = 420", "name = 'arx'" )
  dbUpdate( "yrp_cl_hud", "value = 2020", "name = 'ary'" )
  dbUpdate( "yrp_cl_hud", "value = 400", "name = 'arw'" )
  dbUpdate( "yrp_cl_hud", "value = 60", "name = 'arh'" )

  dbUpdate( "yrp_cl_hud", "value = 1", "name = 'rit'" )
  dbUpdate( "yrp_cl_hud", "value = 420", "name = 'rix'" )
  dbUpdate( "yrp_cl_hud", "value = 1740", "name = 'riy'" )
  dbUpdate( "yrp_cl_hud", "value = 400", "name = 'riw'" )
  dbUpdate( "yrp_cl_hud", "value = 60", "name = 'rih'" )

  dbUpdate( "yrp_cl_hud", "value = 1", "name = 'ttt'" )
  dbUpdate( "yrp_cl_hud", "value = 20", "name = 'ttx'" )
  dbUpdate( "yrp_cl_hud", "value = 1530", "name = 'tty'" )
  dbUpdate( "yrp_cl_hud", "value = 400", "name = 'ttw'" )
  dbUpdate( "yrp_cl_hud", "value = 210", "name = 'tth'" )

  dbUpdate( "yrp_cl_hud", "value = 1", "name = 'mot'" )
  dbUpdate( "yrp_cl_hud", "value = 420", "name = 'mox'" )
  dbUpdate( "yrp_cl_hud", "value = 1800", "name = 'moy'" )
  dbUpdate( "yrp_cl_hud", "value = 400", "name = 'mow'" )
  dbUpdate( "yrp_cl_hud", "value = 60", "name = 'moh'" )


  dbUpdate( "yrp_cl_hud", "value = 1920", "name = 'vox'" )
  dbUpdate( "yrp_cl_hud", "value = 540", "name = 'voy'" )

  loadCompleteHud()
end

function resetHud()
  printGM( "note", "yrp_cl_hud resetet" )

  setDefaultHud()
end

function loadDatabaseHud()
  local ply = LocalPlayer()
  printGM( "db", "Load Database: Hud" )
  local tmp = 0   //for making sure that all values are inserted

  //sql.Query("DROP TABLE yrp_cl_hud")

  if !sql.TableExists( "yrp_cl_hud" ) then
    local query = "CREATE TABLE yrp_cl_hud ( "
    query = query .. "name      TEXT, "
    query = query .. "value     INT"
    query = query .. " )"
    local result = sql.Query( query )
  end

  if !dbSelect( "yrp_cl_hud", "name, value", "name = 'mmt'" ) then
    dbInsertInto( "yrp_cl_hud", "name, value", "'mmt', 1" )
    dbInsertInto( "yrp_cl_hud", "name, value", "'mmx', 20" )
    dbInsertInto( "yrp_cl_hud", "name, value", "'mmy', 1740" )
    dbInsertInto( "yrp_cl_hud", "name, value", "'mmw', 400" )
    dbInsertInto( "yrp_cl_hud", "name, value", "'mmh', 400" )
  end

  if !dbSelect( "yrp_cl_hud", "name, value", "name = 'hpt'" ) then
    dbInsertInto( "yrp_cl_hud", "name, value", "'hpt', 1" )
    dbInsertInto( "yrp_cl_hud", "name, value", "'hpx', 420" )
    dbInsertInto( "yrp_cl_hud", "name, value", "'hpy', 2080" )
    dbInsertInto( "yrp_cl_hud", "name, value", "'hpw', 400" )
    dbInsertInto( "yrp_cl_hud", "name, value", "'hph', 60" )
  end

  if !dbSelect( "yrp_cl_hud", "name, value", "name = 'art'" ) then
    dbInsertInto( "yrp_cl_hud", "name, value", "'art', 1" )
    dbInsertInto( "yrp_cl_hud", "name, value", "'arx', 420" )
    dbInsertInto( "yrp_cl_hud", "name, value", "'ary', 2020" )
    dbInsertInto( "yrp_cl_hud", "name, value", "'arw', 400" )
    dbInsertInto( "yrp_cl_hud", "name, value", "'arh', 60" )
  end

  if !dbSelect( "yrp_cl_hud", "name, value", "name = 'rit'" ) then
    dbInsertInto( "yrp_cl_hud", "name, value", "'rit', 1" )
    dbInsertInto( "yrp_cl_hud", "name, value", "'rix', 420" )
    dbInsertInto( "yrp_cl_hud", "name, value", "'riy', 1740" )
    dbInsertInto( "yrp_cl_hud", "name, value", "'riw', 400" )
    dbInsertInto( "yrp_cl_hud", "name, value", "'rih', 60" )
  end

  if !dbSelect( "yrp_cl_hud", "name, value", "name = 'ttt'" ) then
    dbInsertInto( "yrp_cl_hud", "name, value", "'ttt', 1" )
    dbInsertInto( "yrp_cl_hud", "name, value", "'ttx', 20" )
    dbInsertInto( "yrp_cl_hud", "name, value", "'tty', 1530" )
    dbInsertInto( "yrp_cl_hud", "name, value", "'ttw', 400" )
    dbInsertInto( "yrp_cl_hud", "name, value", "'tth', 210" )
  end

  if !dbSelect( "yrp_cl_hud", "name, value", "name = 'mot'" ) then
    dbInsertInto( "yrp_cl_hud", "name, value", "'mot', 1" )
    dbInsertInto( "yrp_cl_hud", "name, value", "'mox', 420" )
    dbInsertInto( "yrp_cl_hud", "name, value", "'moy', 1800" )
    dbInsertInto( "yrp_cl_hud", "name, value", "'mow', 400" )
    dbInsertInto( "yrp_cl_hud", "name, value", "'moh', 60" )
  end

  if !dbSelect( "yrp_cl_hud", "name, value", "name = 'vox'" ) then
    dbInsertInto( "yrp_cl_hud", "name, value", "'vox', 1920" )
    dbInsertInto( "yrp_cl_hud", "name, value", "'voy', 540" )
  end

  timer.Create( "timerLoadDBHud", 0.01, 0, function()
    if sql.TableExists( "yrp_cl_hud" ) then
      timer.Remove( "timerLoadDBHud" )

      loadCompleteHud()

      timer.Simple( 0.01, function()
        cl_db["_load"] = 1
        //PrintTable( cl_db )   //Shows Current Table Values
      end)
    end
  end)
end

function initDatabase()
  loadDatabaseHud()
end
initDatabase()
