--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local dbNameHud = "yrp_cl_hud"
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
  if dbTableExists( dbTable ) then
    local q = "SELECT "
    q = q .. dbColumns
    q = q .. " FROM "
    q = q .. dbTable
    if dbWhere != nil then
      q = q .. " WHERE "
      q = q .. dbWhere .. ";"
    end
    local _result = sql.Query( q )
    if _result == nil then
      printGM( "note", dbTable .. ": " .. q .." | NO DATA - can be ignored" )
      return _result
    elseif _result == false then
      printERROR( dbTable .. ": " .. q .. " FALSE" )
      return _result
    else
      return _result
    end
  end
end

function dbInsertInto( dbTable, dbColumns, dbValues )
  local q = "INSERT INTO "
  q = q .. dbTable
  q = q .. " ( "
  q = q .. dbColumns
  q = q .. " ) VALUES ( "
  q = q .. dbValues
  q = q .. " );"
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
      q = q .. dbWhere .. ";"
    end
    local _result = sql.Query( q )
  end
end

function sqlAddColumn( tableName, columnName, datatype )
  local result = sqlCheckIfColumnExists( tableName, columnName )
  if result == false then
    local q = "ALTER TABLE " .. tableName .. " ADD " .. columnName .. " " .. datatype .. ";"
    local _result = sql.Query( q )
  else
    --printGM( columnName .. " vorhanden" )
  end
end

function updateDBHud( name, value )
  local query = "UPDATE yrp_cl_hud "
  query = query .. "SET value = " .. tonumber( value ) .. " "
  query = query .. "WHERE name = '" .. tostring( name ) .. "';"
  local dbName = dbNameHud
  local result = sql.Query( query )
  loadDBHud( dbName, name )
end

function loadDBHud( dbName, name )
  --printGM( "loadDBHud " .. name )
  local tmpValue = sql.Query( "SELECT value FROM " .. dbName .. " WHERE name = '" .. name .. "';" )
  if tmpValue != nil and tmpValue != false then
    cl_db[name] = tonumber( tmpValue[1].value )
  else
    printGM( "loadDBHud FAILED" )
    --loadDatabaseHud()
  end
end

local defaultFS = 26
function loadCompleteHud()
  local dbName = dbNameHud
  printGM( "db", "loading Hud" )

  loadDBHud( dbName, "colbgt" )
  loadDBHud( dbName, "colbgr" )
  loadDBHud( dbName, "colbgg" )
  loadDBHud( dbName, "colbgb" )
  loadDBHud( dbName, "colbga" )

  loadDBHud( dbName, "colbrt" )
  loadDBHud( dbName, "colbrr" )
  loadDBHud( dbName, "colbrg" )
  loadDBHud( dbName, "colbrb" )
  loadDBHud( dbName, "colbra" )

  loadDBHud( dbName, "colcht" )
  loadDBHud( dbName, "colchr" )
  loadDBHud( dbName, "colchg" )
  loadDBHud( dbName, "colchb" )
  loadDBHud( dbName, "colcha" )

  loadDBHud( dbName, "colchbrt" )
  loadDBHud( dbName, "colchbrr" )
  loadDBHud( dbName, "colchbrg" )
  loadDBHud( dbName, "colchbrb" )
  loadDBHud( dbName, "colchbra" )

  loadDBHud( dbName, "cht" )
  loadDBHud( dbName, "chl" )
  loadDBHud( dbName, "chg" )
  loadDBHud( dbName, "chh" )
  loadDBHud( dbName, "chbr" )

  loadDBHud( dbName, "mmt" )
  loadDBHud( dbName, "mmx" )
  loadDBHud( dbName, "mmy" )
  loadDBHud( dbName, "mmw" )
  loadDBHud( dbName, "mmh" )

  loadDBHud( dbName, "hpt" )
  loadDBHud( dbName, "hpx" )
  loadDBHud( dbName, "hpy" )
  loadDBHud( dbName, "hpw" )
  loadDBHud( dbName, "hph" )

  loadDBHud( dbName, "art" )
  loadDBHud( dbName, "arx" )
  loadDBHud( dbName, "ary" )
  loadDBHud( dbName, "arw" )
  loadDBHud( dbName, "arh" )

  loadDBHud( dbName, "wst" )
  loadDBHud( dbName, "wsx" )
  loadDBHud( dbName, "wsy" )
  loadDBHud( dbName, "wsw" )
  loadDBHud( dbName, "wsh" )

  loadDBHud( dbName, "wpt" )
  loadDBHud( dbName, "wpx" )
  loadDBHud( dbName, "wpy" )
  loadDBHud( dbName, "wpw" )
  loadDBHud( dbName, "wph" )

  loadDBHud( dbName, "wnt" )
  loadDBHud( dbName, "wnx" )
  loadDBHud( dbName, "wny" )
  loadDBHud( dbName, "wnw" )
  loadDBHud( dbName, "wnh" )

  loadDBHud( dbName, "rit" )
  loadDBHud( dbName, "rix" )
  loadDBHud( dbName, "riy" )
  loadDBHud( dbName, "riw" )
  loadDBHud( dbName, "rih" )

  loadDBHud( dbName, "ttt" )
  loadDBHud( dbName, "ttx" )
  loadDBHud( dbName, "tty" )
  loadDBHud( dbName, "ttw" )
  loadDBHud( dbName, "tth" )

  loadDBHud( dbName, "mot" )
  loadDBHud( dbName, "mox" )
  loadDBHud( dbName, "moy" )
  loadDBHud( dbName, "mow" )
  loadDBHud( dbName, "moh" )

  loadDBHud( dbName, "mht" )
  loadDBHud( dbName, "mhx" )
  loadDBHud( dbName, "mhy" )
  loadDBHud( dbName, "mhw" )
  loadDBHud( dbName, "mhh" )

  loadDBHud( dbName, "mtt" )
  loadDBHud( dbName, "mtx" )
  loadDBHud( dbName, "mty" )
  loadDBHud( dbName, "mtw" )
  loadDBHud( dbName, "mth" )

  loadDBHud( dbName, "mst" )
  loadDBHud( dbName, "msx" )
  loadDBHud( dbName, "msy" )
  loadDBHud( dbName, "msw" )
  loadDBHud( dbName, "msh" )

  loadDBHud( dbName, "vtt" )
  loadDBHud( dbName, "vtx" )
  loadDBHud( dbName, "vty" )
  loadDBHud( dbName, "vtw" )
  loadDBHud( dbName, "vth" )

  loadDBHud( dbName, "cbt" )
  loadDBHud( dbName, "cbx" )
  loadDBHud( dbName, "cby" )
  loadDBHud( dbName, "cbw" )
  loadDBHud( dbName, "cbh" )

  loadDBHud( dbName, "mat" )
  loadDBHud( dbName, "max" )
  loadDBHud( dbName, "may" )
  loadDBHud( dbName, "maw" )
  loadDBHud( dbName, "mah" )

  loadDBHud( dbName, "cat" )
  loadDBHud( dbName, "cax" )
  loadDBHud( dbName, "cay" )
  loadDBHud( dbName, "caw" )
  loadDBHud( dbName, "cah" )

  loadDBHud( dbName, "stt" )
  loadDBHud( dbName, "stx" )
  loadDBHud( dbName, "sty" )
  loadDBHud( dbName, "stw" )
  loadDBHud( dbName, "sth" )

  loadDBHud( dbName, "vox" )
  loadDBHud( dbName, "voy" )

  loadDBHud( dbName, "mmf" )
  loadDBHud( dbName, "hpf" )
  loadDBHud( dbName, "arf" )
  loadDBHud( dbName, "wpf" )
  loadDBHud( dbName, "wsf" )
  loadDBHud( dbName, "wnf" )
  loadDBHud( dbName, "rif" )
  loadDBHud( dbName, "ttf" )
  loadDBHud( dbName, "mof" )
  loadDBHud( dbName, "mhf" )
  loadDBHud( dbName, "mtf" )
  loadDBHud( dbName, "msf" )
  loadDBHud( dbName, "vtf" )
  loadDBHud( dbName, "cbf" )
  loadDBHud( dbName, "vof" )
  loadDBHud( dbName, "maf" )
  loadDBHud( dbName, "caf" )
  loadDBHud( dbName, "stf" )

  loadDBHud( dbName, "sef" )

  timer.Simple( 0.1, function ()
    cl_db["_load"] = 1
  end)

  printGM( "db", "loaded Hud" )
end

function setDefaultHud()
  local dbName = dbNameHud
  dbUpdate( dbName, "value = 1", "name = 'colbgt'" )
  dbUpdate( dbName, "value = 0", "name = 'colbgr'" )
  dbUpdate( dbName, "value = 0", "name = 'colbgg'" )
  dbUpdate( dbName, "value = 0", "name = 'colbgb'" )
  dbUpdate( dbName, "value = 200", "name = 'colbga'" )

  dbUpdate( dbName, "value = 1", "name = 'colbrt'" )
  dbUpdate( dbName, "value = 0", "name = 'colbrr'" )
  dbUpdate( dbName, "value = 0", "name = 'colbrg'" )
  dbUpdate( dbName, "value = 0", "name = 'colbrb'" )
  dbUpdate( dbName, "value = 255", "name = 'colbra'" )

  dbUpdate( dbName, "value = 1", "name = 'colcht'" )
  dbUpdate( dbName, "value = 0", "name = 'colchr'" )
  dbUpdate( dbName, "value = 255", "name = 'colchg'" )
  dbUpdate( dbName, "value = 0", "name = 'colchb'" )
  dbUpdate( dbName, "value = 255", "name = 'colcha'" )

  dbUpdate( dbName, "value = 1", "name = 'colchbrt'" )
  dbUpdate( dbName, "value = 0", "name = 'colchbrr'" )
  dbUpdate( dbName, "value = 0", "name = 'colchbrg'" )
  dbUpdate( dbName, "value = 0", "name = 'colchbrb'" )
  dbUpdate( dbName, "value = 255", "name = 'colchbra'" )

  dbUpdate( dbName, "value = 1", "name = 'cht'" )
  dbUpdate( dbName, "value = 10", "name = 'chl'" )
  dbUpdate( dbName, "value = 10", "name = 'chg'" )
  dbUpdate( dbName, "value = 1", "name = 'chh'" )
  dbUpdate( dbName, "value = 1", "name = 'chbr'" )

  dbUpdate( dbName, "value = 1", "name = 'mmt'" )
  dbUpdate( dbName, "value = 20", "name = 'mmx'" )
  dbUpdate( dbName, "value = 1780", "name = 'mmy'" )
  dbUpdate( dbName, "value = 360", "name = 'mmw'" )
  dbUpdate( dbName, "value = 360", "name = 'mmh'" )

  dbUpdate( dbName, "value = 1", "name = 'hpt'" )
  dbUpdate( dbName, "value = 380", "name = 'hpx'" )
  dbUpdate( dbName, "value = 2080", "name = 'hpy'" )
  dbUpdate( dbName, "value = 400", "name = 'hpw'" )
  dbUpdate( dbName, "value = 60", "name = 'hph'" )

  dbUpdate( dbName, "value = 1", "name = 'art'" )
  dbUpdate( dbName, "value = 380", "name = 'arx'" )
  dbUpdate( dbName, "value = 2020", "name = 'ary'" )
  dbUpdate( dbName, "value = 400", "name = 'arw'" )
  dbUpdate( dbName, "value = 60", "name = 'arh'" )

  dbUpdate( dbName, "value = 1", "name = 'wst'" )
  dbUpdate( dbName, "value = " .. ScrW() * ctrF( ScrH() ) - 400 - 20, "name = 'wsx'" )
  dbUpdate( dbName, "value = 1960", "name = 'wsy'" )
  dbUpdate( dbName, "value = 400", "name = 'wsw'" )
  dbUpdate( dbName, "value = 60", "name = 'wsh'" )

  dbUpdate( dbName, "value = 1", "name = 'wpt'" )
  dbUpdate( dbName, "value = " .. ScrW() * ctrF( ScrH() ) - 400 - 20, "name = 'wpx'" )
  dbUpdate( dbName, "value = 2020", "name = 'wpy'" )
  dbUpdate( dbName, "value = 400", "name = 'wpw'" )
  dbUpdate( dbName, "value = 60", "name = 'wph'" )

  dbUpdate( dbName, "value = 1", "name = 'wnt'" )
  dbUpdate( dbName, "value = " .. ScrW() * ctrF( ScrH() ) - 400 - 20, "name = 'wnx'" )
  dbUpdate( dbName, "value = 2080", "name = 'wny'" )
  dbUpdate( dbName, "value = 400", "name = 'wnw'" )
  dbUpdate( dbName, "value = 60", "name = 'wnh'" )

  dbUpdate( dbName, "value = 1", "name = 'rit'" )
  dbUpdate( dbName, "value = 380", "name = 'rix'" )
  dbUpdate( dbName, "value = 1780", "name = 'riy'" )
  dbUpdate( dbName, "value = 400", "name = 'riw'" )
  dbUpdate( dbName, "value = 60", "name = 'rih'" )

  dbUpdate( dbName, "value = 1", "name = 'ttt'" )
  dbUpdate( dbName, "value = 20", "name = 'ttx'" )
  dbUpdate( dbName, "value = 20", "name = 'tty'" )
  dbUpdate( dbName, "value = 600", "name = 'ttw'" )
  dbUpdate( dbName, "value = 400", "name = 'tth'" )

  dbUpdate( dbName, "value = 1", "name = 'mot'" )
  dbUpdate( dbName, "value = 380", "name = 'mox'" )
  dbUpdate( dbName, "value = 1840", "name = 'moy'" )
  dbUpdate( dbName, "value = 400", "name = 'mow'" )
  dbUpdate( dbName, "value = 60", "name = 'moh'" )

  dbUpdate( dbName, "value = 1", "name = 'mht'" )
  dbUpdate( dbName, "value = 380", "name = 'mhx'" )
  dbUpdate( dbName, "value = 1900", "name = 'mhy'" )
  dbUpdate( dbName, "value = 400", "name = 'mhw'" )
  dbUpdate( dbName, "value = 60", "name = 'mhh'" )

  dbUpdate( dbName, "value = 1", "name = 'mtt'" )
  dbUpdate( dbName, "value = 380", "name = 'mtx'" )
  dbUpdate( dbName, "value = 1960", "name = 'mty'" )
  dbUpdate( dbName, "value = 400", "name = 'mtw'" )
  dbUpdate( dbName, "value = 60", "name = 'mth'" )

  dbUpdate( dbName, "value = 1", "name = 'mst'" )
  dbUpdate( dbName, "value = " .. ScrW()/2 * ctrF( ScrH() ) - 200, "name = 'msx'" )
  dbUpdate( dbName, "value = 1920", "name = 'msy'" )
  dbUpdate( dbName, "value = 400", "name = 'msw'" )
  dbUpdate( dbName, "value = 60", "name = 'msh'" )

  dbUpdate( dbName, "value = 1", "name = 'vtt'" )
  dbUpdate( dbName, "value = " .. ScrW()/2 * ctrF( ScrH() ) - 500, "name = 'vtx'" )
  dbUpdate( dbName, "value = 0", "name = 'vty'" )
  dbUpdate( dbName, "value = 1000", "name = 'vtw'" )
  dbUpdate( dbName, "value = 160", "name = 'vth'" )

  dbUpdate( dbName, "value = 1", "name = 'cbt'" )
  dbUpdate( dbName, "value = 20", "name = 'cbx'" )
  dbUpdate( dbName, "value = 1300", "name = 'cby'" )
  dbUpdate( dbName, "value = 900", "name = 'cbw'" )
  dbUpdate( dbName, "value = 460", "name = 'cbh'" )

  dbUpdate( dbName, "value = 1", "name = 'mat'" )
  dbUpdate( dbName, "value = " .. ScrW()/2 * ctrF( ScrH() ) - 200, "name = 'max'" )
  dbUpdate( dbName, "value = 1840", "name = 'may'" )
  dbUpdate( dbName, "value = 400", "name = 'maw'" )
  dbUpdate( dbName, "value = 60", "name = 'mah'" )

  dbUpdate( dbName, "value = 1", "name = 'cat'" )
  dbUpdate( dbName, "value = " .. ScrW()/2 * ctrF( ScrH() ) - 200, "name = 'cax'" )
  dbUpdate( dbName, "value = 1760", "name = 'cay'" )
  dbUpdate( dbName, "value = 400", "name = 'caw'" )
  dbUpdate( dbName, "value = 60", "name = 'cah'" )

  dbUpdate( dbName, "value = 1", "name = 'stt'" )
  dbUpdate( dbName, "value = " .. ScrW()/2 * ctrF( ScrH() ) - 200, "name = 'stx'" )
  dbUpdate( dbName, "value = 500", "name = 'sty'" )
  dbUpdate( dbName, "value = 400", "name = 'stw'" )
  dbUpdate( dbName, "value = 60", "name = 'sth'" )

  dbUpdate( dbName, "value = 1920", "name = 'vox'" )
  dbUpdate( dbName, "value = 540", "name = 'voy'" )

  dbUpdate( dbName, "value = 16", "name = 'mmf'" )
  dbUpdate( dbName, "value = " .. defaultFS, "name = 'hpf'" )
  dbUpdate( dbName, "value = " .. defaultFS, "name = 'arf'" )
  dbUpdate( dbName, "value = " .. defaultFS, "name = 'wpf'" )
  dbUpdate( dbName, "value = " .. defaultFS, "name = 'wsf'" )
  dbUpdate( dbName, "value = " .. defaultFS, "name = 'wnf'" )
  dbUpdate( dbName, "value = 16", "name = 'rif'" )
  dbUpdate( dbName, "value = " .. defaultFS, "name = 'ttf'" )
  dbUpdate( dbName, "value = 18", "name = 'mof'" )
  dbUpdate( dbName, "value = " .. defaultFS, "name = 'mhf'" )
  dbUpdate( dbName, "value = " .. defaultFS, "name = 'mtf'" )
  dbUpdate( dbName, "value = " .. defaultFS, "name = 'msf'" )
  dbUpdate( dbName, "value = " .. defaultFS, "name = 'vtf'" )
  dbUpdate( dbName, "value = 16", "name = 'cbf'" )
  dbUpdate( dbName, "value = " .. defaultFS, "name = 'vof'" )
  dbUpdate( dbName, "value = " .. defaultFS, "name = 'maf'" )
  dbUpdate( dbName, "value = " .. defaultFS, "name = 'caf'" )
  dbUpdate( dbName, "value = " .. defaultFS, "name = 'stf'" )

  dbUpdate( dbName, "value = 18", "name = 'sef'" )

  loadCompleteHud()
end

function resetHud()
  printGM( "note", "yrp_cl_hud resetet" )

  setDefaultHud()
end

--sql.Query( "DROP TABLE yrp_cl_hud" )

function loadDatabaseHud()
  local ply = LocalPlayer()
  local dbName = dbNameHud
  printGM( "db", "Load Database: Hud" )

  if !sql.TableExists( dbName ) then
    printGM( "db", "CREATE Database " .. dbName )
    local query = "CREATE TABLE " .. dbName .. " ( "
    query = query .. "name TEXT, "
    query = query .. "value INTEGER"

    query = query .. " );"
    local result = sql.Query( query )
    if result == false then
      print( sql.LastError() )
    end
  end

  if !dbSelect( dbName, "name, value", "name = 'colbgt'" ) then
    dbInsertInto( dbName, "name, value", "'colbgt', 1" )
    dbInsertInto( dbName, "name, value", "'colbgr', 0" )
    dbInsertInto( dbName, "name, value", "'colbgg', 0" )
    dbInsertInto( dbName, "name, value", "'colbgb', 0" )
    dbInsertInto( dbName, "name, value", "'colbga', 200" )
  end

  if !dbSelect( dbName, "name, value", "name = 'colbrt'" ) then
    dbInsertInto( dbName, "name, value", "'colbrt', 1" )
    dbInsertInto( dbName, "name, value", "'colbrr', 0" )
    dbInsertInto( dbName, "name, value", "'colbrg', 0" )
    dbInsertInto( dbName, "name, value", "'colbrb', 0" )
    dbInsertInto( dbName, "name, value", "'colbra', 255" )
  end

  if !dbSelect( dbName, "name, value", "name = 'colcht'" ) then
    dbInsertInto( dbName, "name, value", "'colcht', 1" )
    dbInsertInto( dbName, "name, value", "'colchr', 0" )
    dbInsertInto( dbName, "name, value", "'colchg', 255" )
    dbInsertInto( dbName, "name, value", "'colchb', 0" )
    dbInsertInto( dbName, "name, value", "'colcha', 255" )
  end

  if !dbSelect( dbName, "name, value", "name = 'colchbrt'" ) then
    dbInsertInto( dbName, "name, value", "'colchbrt', 1" )
    dbInsertInto( dbName, "name, value", "'colchbrr', 0" )
    dbInsertInto( dbName, "name, value", "'colchbrg', 0" )
    dbInsertInto( dbName, "name, value", "'colchbrb', 0" )
    dbInsertInto( dbName, "name, value", "'colchbra', 255" )
  end

  if !dbSelect( dbName, "name, value", "name = 'cht'" ) then
    dbInsertInto( dbName, "name, value", "'cht', 1" )
    dbInsertInto( dbName, "name, value", "'chl', 10" )
    dbInsertInto( dbName, "name, value", "'chg', 10" )
    dbInsertInto( dbName, "name, value", "'chh', 1" )
    dbInsertInto( dbName, "name, value", "'chbr', 1" )
  end

  if !dbSelect( dbName, "name, value", "name = 'mmt'" ) then
    dbInsertInto( dbName, "name, value", "'mmt', 1" )
    dbInsertInto( dbName, "name, value", "'mmx', 20" )
    dbInsertInto( dbName, "name, value", "'mmy', 1780" )
    dbInsertInto( dbName, "name, value", "'mmw', 360" )
    dbInsertInto( dbName, "name, value", "'mmh', 360" )
  end

  if !dbSelect( dbName, "name, value", "name = 'hpt'" ) then
    dbInsertInto( dbName, "name, value", "'hpt', 1" )
    dbInsertInto( dbName, "name, value", "'hpx', 380" )
    dbInsertInto( dbName, "name, value", "'hpy', 2080" )
    dbInsertInto( dbName, "name, value", "'hpw', 400" )
    dbInsertInto( dbName, "name, value", "'hph', 60" )
  end

  if !dbSelect( dbName, "name, value", "name = 'art'" ) then
    dbInsertInto( dbName, "name, value", "'art', 1" )
    dbInsertInto( dbName, "name, value", "'arx', 380" )
    dbInsertInto( dbName, "name, value", "'ary', 2020" )
    dbInsertInto( dbName, "name, value", "'arw', 400" )
    dbInsertInto( dbName, "name, value", "'arh', 60" )
  end

  if !dbSelect( dbName, "name, value", "name = 'wpt'" ) then
    dbInsertInto( dbName, "name, value", "'wst', 1" )
    dbInsertInto( dbName, "name, value", "'wsx', " .. ScrW() * ctrF( ScrH() ) - 400 - 20 )
    dbInsertInto( dbName, "name, value", "'wsy', 1960" )
    dbInsertInto( dbName, "name, value", "'wsw', 400" )
    dbInsertInto( dbName, "name, value", "'wsh', 60" )

    dbInsertInto( dbName, "name, value", "'wpt', 1" )
    dbInsertInto( dbName, "name, value", "'wpx', " .. ScrW() * ctrF( ScrH() ) - 400 - 20 )
    dbInsertInto( dbName, "name, value", "'wpy', 2020" )
    dbInsertInto( dbName, "name, value", "'wpw', 400" )
    dbInsertInto( dbName, "name, value", "'wph', 60" )

    dbInsertInto( dbName, "name, value", "'wnt', 1" )
    dbInsertInto( dbName, "name, value", "'wnx', " .. ScrW() * ctrF( ScrH() ) - 400 - 20 )
    dbInsertInto( dbName, "name, value", "'wny', 2080" )
    dbInsertInto( dbName, "name, value", "'wnw', 400" )
    dbInsertInto( dbName, "name, value", "'wnh', 60" )
  end

  if !dbSelect( dbName, "name, value", "name = 'rit'" ) then
    dbInsertInto( dbName, "name, value", "'rit', 1" )
    dbInsertInto( dbName, "name, value", "'rix', 380" )
    dbInsertInto( dbName, "name, value", "'riy', 1780" )
    dbInsertInto( dbName, "name, value", "'riw', 400" )
    dbInsertInto( dbName, "name, value", "'rih', 60" )
  end

  if !dbSelect( dbName, "name, value", "name = 'ttt'" ) then
    dbInsertInto( dbName, "name, value", "'ttt', 1" )
    dbInsertInto( dbName, "name, value", "'ttx', 20" )
    dbInsertInto( dbName, "name, value", "'tty', 20" )
    dbInsertInto( dbName, "name, value", "'ttw', 600" )
    dbInsertInto( dbName, "name, value", "'tth', 400" )
  end

  if !dbSelect( dbName, "name, value", "name = 'mot'" ) then
    dbInsertInto( dbName, "name, value", "'mot', 1" )
    dbInsertInto( dbName, "name, value", "'mox', 380" )
    dbInsertInto( dbName, "name, value", "'moy', 1840" )
    dbInsertInto( dbName, "name, value", "'mow', 400" )
    dbInsertInto( dbName, "name, value", "'moh', 60" )
  end

  if !dbSelect( dbName, "name, value", "name = 'mht'" ) then
    dbInsertInto( dbName, "name, value", "'mht', 1" )
    dbInsertInto( dbName, "name, value", "'mhx', 380" )
    dbInsertInto( dbName, "name, value", "'mhy', 1900" )
    dbInsertInto( dbName, "name, value", "'mhw', 400" )
    dbInsertInto( dbName, "name, value", "'mhh', 60" )
  end

  if !dbSelect( dbName, "name, value", "name = 'mtt'" ) then
    dbInsertInto( dbName, "name, value", "'mtt', 1" )
    dbInsertInto( dbName, "name, value", "'mtx', 380" )
    dbInsertInto( dbName, "name, value", "'mty', 1960" )
    dbInsertInto( dbName, "name, value", "'mtw', 400" )
    dbInsertInto( dbName, "name, value", "'mth', 60" )
  end

  if !dbSelect( dbName, "name, value", "name = 'mst'" ) then
    dbInsertInto( dbName, "name, value", "'mst', 1" )
    dbInsertInto( dbName, "name, value", "'msx', " .. ScrW()/2 * ctrF( ScrH() ) - 200 )
    dbInsertInto( dbName, "name, value", "'msy', 1920" )
    dbInsertInto( dbName, "name, value", "'msw', 400" )
    dbInsertInto( dbName, "name, value", "'msh', 60" )
  end

  if !dbSelect( dbName, "name, value", "name = 'vtt'" ) then
    dbInsertInto( dbName, "name, value", "'vtt', 1" )
    dbInsertInto( dbName, "name, value", "'vtx', " .. ScrW()/2 * ctrF( ScrH() ) - 500 )
    dbInsertInto( dbName, "name, value", "'vty', 0" )
    dbInsertInto( dbName, "name, value", "'vtw', 1000" )
    dbInsertInto( dbName, "name, value", "'vth', 160" )
  end

  if !dbSelect( dbName, "name, value", "name = 'cbt'" ) then
    dbInsertInto( dbName, "name, value", "'cbt', 1" )
    dbInsertInto( dbName, "name, value", "'cbx', 20" )
    dbInsertInto( dbName, "name, value", "'cby', 1300" )
    dbInsertInto( dbName, "name, value", "'cbw', 900" )
    dbInsertInto( dbName, "name, value", "'cbh', 460" )
  end

  if !dbSelect( dbName, "name, value", "name = 'mat'" ) then
    dbInsertInto( dbName, "name, value", "'mat', 1" )
    dbInsertInto( dbName, "name, value", "'max', " .. ScrW()/2 * ctrF( ScrH() ) - 200 )
    dbInsertInto( dbName, "name, value", "'may', 1840" )
    dbInsertInto( dbName, "name, value", "'maw', 400" )
    dbInsertInto( dbName, "name, value", "'mah', 60" )
  end

  if !dbSelect( dbName, "name, value", "name = 'cat'" ) then
    dbInsertInto( dbName, "name, value", "'cat', 1" )
    dbInsertInto( dbName, "name, value", "'cax', " .. ScrW()/2 * ctrF( ScrH() ) - 200 )
    dbInsertInto( dbName, "name, value", "'cay', 1760" )
    dbInsertInto( dbName, "name, value", "'caw', 400" )
    dbInsertInto( dbName, "name, value", "'cah', 60" )
  end

  if !dbSelect( dbName, "name, value", "name = 'stt'" ) then
    dbInsertInto( dbName, "name, value", "'stt', 1" )
    dbInsertInto( dbName, "name, value", "'stx', " .. ScrW()/2 * ctrF( ScrH() ) - 200 )
    dbInsertInto( dbName, "name, value", "'sty', 500" )
    dbInsertInto( dbName, "name, value", "'stw', 400" )
    dbInsertInto( dbName, "name, value", "'sth', 60" )
  end

  if !dbSelect( dbName, "name, value", "name = 'vox'" ) then
    dbInsertInto( dbName, "name, value", "'vox', 1920" )
    dbInsertInto( dbName, "name, value", "'voy', 540" )
  end

  --Fontsizes
  if !dbSelect( dbName, "name, value", "name = 'mmf'" ) then
    dbInsertInto( dbName, "name, value", "'mmf', 16" )
  end

  if !dbSelect( dbName, "name, value", "name = 'hpf'" ) then
    dbInsertInto( dbName, "name, value", "'hpf', " .. defaultFS )
  end

  if !dbSelect( dbName, "name, value", "name = 'arf'" ) then
    dbInsertInto( dbName, "name, value", "'arf', " .. defaultFS )
  end

  if !dbSelect( dbName, "name, value", "name = 'wpf'" ) then
    dbInsertInto( dbName, "name, value", "'wpf', " .. defaultFS )
  end

  if !dbSelect( dbName, "name, value", "name = 'wsf'" ) then
    dbInsertInto( dbName, "name, value", "'wsf', " .. defaultFS )
  end

  if !dbSelect( dbName, "name, value", "name = 'wnf'" ) then
    dbInsertInto( dbName, "name, value", "'wnf', " .. defaultFS )
  end

  if !dbSelect( dbName, "name, value", "name = 'rif'" ) then
    dbInsertInto( dbName, "name, value", "'rif', 16" )
  end

  if !dbSelect( dbName, "name, value", "name = 'ttf'" ) then
    dbInsertInto( dbName, "name, value", "'ttf', " .. defaultFS )
  end

  if !dbSelect( dbName, "name, value", "name = 'mof'" ) then
    dbInsertInto( dbName, "name, value", "'mof', 18" )
  end

  if !dbSelect( dbName, "name, value", "name = 'mhf'" ) then
    dbInsertInto( dbName, "name, value", "'mhf', " .. defaultFS )
  end

  if !dbSelect( dbName, "name, value", "name = 'mtf'" ) then
    dbInsertInto( dbName, "name, value", "'mtf', " .. defaultFS )
  end

  if !dbSelect( dbName, "name, value", "name = 'msf'" ) then
    dbInsertInto( dbName, "name, value", "'msf', " .. defaultFS )
  end

  if !dbSelect( dbName, "name, value", "name = 'vtf'" ) then
    dbInsertInto( dbName, "name, value", "'vtf', " .. defaultFS )
  end

  if !dbSelect( dbName, "name, value", "name = 'cbf'" ) then
    dbInsertInto( dbName, "name, value", "'cbf', 16" )
  end

  if !dbSelect( dbName, "name, value", "name = 'vof'" ) then
    dbInsertInto( dbName, "name, value", "'vof', " .. defaultFS )
  end

  if !dbSelect( dbName, "name, value", "name = 'sef'" ) then
    dbInsertInto( dbName, "name, value", "'sef', 18" )
  end

  if !dbSelect( dbName, "name, value", "name = 'maf'" ) then
    dbInsertInto( dbName, "name, value", "'maf', 16" )
  end

  if !dbSelect( dbName, "name, value", "name = 'caf'" ) then
    dbInsertInto( dbName, "name, value", "'caf', 16" )
  end

  if !dbSelect( dbName, "name, value", "name = 'stf'" ) then
    dbInsertInto( dbName, "name, value", "'stf', 16" )
  end

  loadCompleteHud()
end

function initDatabase()
  printGM( "db", "initDatabase()" )
  loadDatabaseHud()
end
initDatabase()
