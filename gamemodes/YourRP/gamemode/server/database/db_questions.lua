--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

//db_questions.lua

include( "questions/db_net.lua" )

//##############################################################################
function dbQuestionsInit()
  local dbName = "yrp_questions"


  printGMPre( "db", yrp.loaddb .. dbName )
  if sql.TableExists( dbName ) then
    printGM( "db", dbName .. " exists" )
  else
    printGM( "note", dbName .. " not exists" )
    sql.Query( "CREATE TABLE " .. dbName .. " ( nr varchar(255), toggle varchar(255), question varchar(255), a_true varchar(255), a_false varchar(255) )" )
		if sql.TableExists( dbName ) then
			printGM( "db", dbName .. yrp.successdb )
      sql.Query( "INSERT INTO yrp_questions( nr, toggle, question, a_true, a_false ) VALUES ( 0, 1, 'questions_toggle', '', '')" )
      sql.Query( "INSERT INTO yrp_questions( nr, toggle, question, a_true, a_false ) VALUES ( 1, 1, 'Are you crazy?', 'Yes', 'No')" )
      sql.Query( "INSERT INTO yrp_questions( nr, toggle, question, a_true, a_false ) VALUES ( 2, 1, 'Are you crazy?', 'Yes', 'No')" )
      sql.Query( "INSERT INTO yrp_questions( nr, toggle, question, a_true, a_false ) VALUES ( 3, 1, 'Are you crazy?', 'Yes', 'No')" )
      sql.Query( "INSERT INTO yrp_questions( nr, toggle, question, a_true, a_false ) VALUES ( 4, 1, 'Are you crazy?', 'Yes', 'No')" )
      sql.Query( "INSERT INTO yrp_questions( nr, toggle, question, a_true, a_false ) VALUES ( 5, 1, 'Are you crazy?', 'Yes', 'No')" )
      sql.Query( "INSERT INTO yrp_questions( nr, toggle, question, a_true, a_false ) VALUES ( 6, 1, 'Are you crazy?', 'Yes', 'No')" )
		else
			printERROR( "CREATE TABLE " .. dbName .. " fail" )
      retryLoadDatabase()
		end
  end
  printGMPos()
end
//##############################################################################
