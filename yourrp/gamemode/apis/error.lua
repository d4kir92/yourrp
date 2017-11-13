--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function worked( obj, name )
  if obj != nil and obj != false then
    return true
  else
    printGM( "note", "NOT WORKED: " .. tostring( obj ) .. " " .. tostring( name ) )
    return false
  end
end
