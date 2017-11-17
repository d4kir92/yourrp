--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

g_debug = false

concommand.Add( "yrp__debug", function( ply, cmd, args )
	g_debug = !g_debug
  if g_debug then
    printGM( "note", "Debug ON" )
  elseif !g_debug then
    printGM( "note", "Debug OFF" )
  end
end )

function worked( obj, name )
  if obj != nil and obj != false then
    return true
  else
    if g_debug then
      printGM( "note", "NOT WORKED: " .. tostring( obj ) .. " " .. tostring( name ) )
    end
    return false
  end
end
