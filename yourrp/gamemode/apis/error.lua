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

function check_yrp_cl_errors( str )
	if !file.Exists( "yrp/cl_errors.txt", "DATA" ) then
		if !file.Exists( "yrp", "DATA" ) then
	    printGM( "db", "yrp existiert nicht" )
	    file.CreateDir( "yrp" )
	  end
    printGM( "db", "yrp/cl_errors.txt existiert nicht" )
		file.Write( "yrp/cl_errors.txt", str )
  end
end

local _cl_errors = {}
function update_error_table_cl()

  local _read = file.Read( "clientside_errors.txt", "GAME" )

	if worked( _read, "_read failed" ) then
		check_yrp_cl_errors( str )

	  local _yrp_read = file.Read( "yrp/cl_errors.txt", "DATA" )
		if worked( _yrp_read, "_yrp_read failed" ) then

		  local _explode_yrp_read = string.Explode( "\n", _yrp_read )
		  local _explode = string.Explode( "\n", _read )

		  if #_explode < #_explode_yrp_read then
				--if error file is smaller, update data
		    file.Write( "yrp/cl_errors.txt", _read )

		  elseif #_explode > #_explode_yrp_read then
				--if error file is bigger, get all errors
		    local _errors = {}
		    for k, v in pairs( _explode ) do
		      if k > #_explode_yrp_read then
		        if string.find( v, "[ERROR] gamemodes/yourrp/", 1, true ) and !table.HasValue( _errors, v ) then
		          table.insert( _errors, v )
		        end
		      end
		    end

				--update data file
		    file.Write( "yrp/cl_errors.txt", _read )

		    return _errors
			end
	  end
	end
  return {}
end

local _url = "https://docs.google.com/forms/d/e/1FAIpQLSdTOU5NjdzpUjOyYbymXOeM3oyFfoVFBNKOAcBZbX3UxgAK6A/formResponse"
function send_error( realm, str )
  printGM( "db", "send_error( " .. realm .. ", " .. str .. " )" )
  local entry = {}
  entry["entry.915525654"] = tostring( str )
  entry["entry.58745995"] = tostring( realm )
  entry["entry.1306533151"] = game.GetMap() or "MAPNAME"
	if gmod.GetGamemode() != nil then
	  entry["entry.2006356340"] = gmod.GetGamemode():GetGameDescription() or "GAMEMODENAME"
	  entry["entry.1883727441"] = gmod.GetGamemode().rpbase or "UNKNOWN"
	  entry["entry.1883727441"] = entry["entry.1883727441"] .. " (" .. gmod.GetGamemode().Version .. ")"
	  entry["entry.2045173320"] = gmod.GetGamemode().VersionSort or "UNKNOWN"
	else
		entry["entry.2006356340"] = "GAMEMODENAME"
	  entry["entry.1883727441"] = "UNKNOWN"
	  entry["entry.2045173320"] = "UNKNOWN"
	end

  http.Post( _url, entry, function( result )
    if result then end
  end, function( failed )
    print( failed )
  end )
end

g_sended = {}
function send_errors( realm, tbl )

  if g_sended[realm] == nil then
     g_sended[realm] = {}
  end
  for k, v in pairs( tbl ) do
    if !table.HasValue( g_sended[realm], v ) then
      if k > #tbl-10 then
        send_error( realm, v )
      end
      table.insert( g_sended[realm], v )
    end
  end
end

timer.Create( "update_error_tables", 10, 0, function()
  _cl_errors = update_error_table_cl()
  send_errors( "client", _cl_errors )
end)
