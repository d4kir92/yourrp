--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

//##############################################################################
//utils
util.AddNetworkString( "setQuestionToggle" )
util.AddNetworkString( "updateQuestions" )
//##############################################################################

//##############################################################################
//net.Receives
net.Receive( "dbGetQuestions", function( len, ply )
  local tmpTable = sql.Query( "SELECT * FROM yrp_questions" )
  net.Start( "dbGetQuestions" )
    net.WriteTable( tmpTable )
  net.Send( ply )
end)

net.Receive( "setQuestionToggle", function( len, ply )
  local tmpString = net.ReadString()
  local tmpInt = net.ReadString()
  sql.Query( "UPDATE yrp_questions SET toggle = '" .. tmpString .. "' WHERE nr = '" .. tmpInt .. "'" )
end)

net.Receive( "updateQuestions", function( len, ply )
  local tmpTextArt = net.ReadString()
  local tmpString = net.ReadString()
  local tmpInt = net.ReadString()
  sql.Query( "UPDATE yrp_questions SET " .. tmpTextArt .. " = '" .. tmpString .. "' WHERE nr = '" .. tmpInt .. "'" )
end)
//##############################################################################
