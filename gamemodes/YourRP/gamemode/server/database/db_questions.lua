//db_questions.lua

include( "questions/db_net.lua" )

//##############################################################################
function dbQuestionsInit()
  if sql.TableExists( "yrp_questions" ) then
    printGM( "db", "yrp_questions exists" )
  else
    sql.Query( "CREATE TABLE yrp_questions ( nr varchar(255), toggle varchar(255), question varchar(255), a_true varchar(255), a_false varchar(255) )" )
		if sql.TableExists( "yrp_questions" ) then
			printGM( "db", "CREATE TABLE yrp_questions success" )
      sql.Query( "INSERT INTO yrp_questions( nr, toggle, question, a_true, a_false ) VALUES ( 0, 1, 'questions_toggle', '', '')" )
      sql.Query( "INSERT INTO yrp_questions( nr, toggle, question, a_true, a_false ) VALUES ( 1, 1, 'Are you crazy?', 'Yes', 'No')" )
      sql.Query( "INSERT INTO yrp_questions( nr, toggle, question, a_true, a_false ) VALUES ( 2, 1, 'Are you crazy?', 'Yes', 'No')" )
      sql.Query( "INSERT INTO yrp_questions( nr, toggle, question, a_true, a_false ) VALUES ( 3, 1, 'Are you crazy?', 'Yes', 'No')" )
      sql.Query( "INSERT INTO yrp_questions( nr, toggle, question, a_true, a_false ) VALUES ( 4, 1, 'Are you crazy?', 'Yes', 'No')" )
      sql.Query( "INSERT INTO yrp_questions( nr, toggle, question, a_true, a_false ) VALUES ( 5, 1, 'Are you crazy?', 'Yes', 'No')" )
      sql.Query( "INSERT INTO yrp_questions( nr, toggle, question, a_true, a_false ) VALUES ( 6, 1, 'Are you crazy?', 'Yes', 'No')" )
		else
			printError( "CREATE TABLE yrp_questions fail" )
		end
  end
end
//##############################################################################
