--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local _debug = true

concommand.Add( "yrp__debug", function( ply, cmd, args )
	_debug = !_debug
	ply:SetNWBool( "yrp_debug", _debug )
  if _debug then
    printGM( "note", "Debug ON" )
  elseif !_debug then
    printGM( "note", "Debug OFF" )
  end
end )

function worked( obj, name, _silence )
  if obj != nil and obj != false then
    return true
  else
    if _debug and !_silence then
      printGM( "note", "NOT WORKED: " .. tostring( obj ) .. " " .. tostring( name ) )
    end
    return false
  end
end

function pa( panel )
	if tostring( panel ) != "[NULL Panel]" then
		return true
	end
	return false
end

function check_yrp_cl_errors( str )
	if !file.Exists( "yrp/cl_errors.txt", "DATA" ) then
		if !file.Exists( "yrp", "DATA" ) then
	    printGM( "db", "yrp existiert nicht" )
	    file.CreateDir( "yrp" )
	  end
    printGM( "db", "yrp/cl_errors.txt existiert nicht" )
		file.Write( "yrp/cl_errors.txt", str )
		return false
  end
	return true
end

local first_time_error = false
local _cl_errors = {}
function update_error_table_cl()
  local _read = file.Read( "clientside_errors.txt", "GAME" )

	if worked( _read, "_read failed", true ) then
		local _file_exists = check_yrp_cl_errors( _read )
		if !_file_exists then
			first_time_error = true
		else
			first_time_error = false
		end

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
		        if (( !first_time_error and string.find( v, "[ERROR] gamemodes/", 1, true ) ) or string.find( v, "[ERROR] gamemodes/", 1, true )) and !table.HasValue( _errors, v ) then
		          table.insert( _errors, v )
		        end
		      end
		    end

				--update data file
		    file.Write( "yrp/cl_errors.txt", _read )

		    return _errors
			elseif first_time_error then
				local _errors = {}
		    for k, v in pairs( _explode ) do
	        if string.find( v, "[ERROR] gamemodes/", 1, true ) and !table.HasValue( _errors, v ) then
	          table.insert( _errors, v )
	        end
		    end

				--update data file
		    file.Write( "yrp/cl_errors.txt", _read )

		    return _errors
			else
				--printGM( "gm", "No new error" )
			end
	  end
	end
  return {}
end

local _url = "https://docs.google.com/forms/d/e/1FAIpQLSdTOU5NjdzpUjOyYbymXOeM3oyFfoVFBNKOAcBZbX3UxgAK6A/formResponse"
function send_error( realm, str )
  printGM( "db", "send_error( " .. realm .. ", " .. str .. " )" )

  local entry = {}
	timer.Create( "wait_for_gamemode"..str, 1, 0, function()
		if gmod.GetGamemode() != nil then
			if SERVER then
				if !game.IsDedicated() then
					printGM( "note", "not dedicated" )
					return
				end
			end
			if CLIENT then
				local _steamid = LocalPlayer():SteamID()
				str = str .. " " .. tostring( _steamid )
			end
		  entry["entry.915525654"] = tostring( str )
		  entry["entry.58745995"] = tostring( realm )
		  entry["entry.1306533151"] = db_sql_str2( string.lower( game.GetMap() ) ) or "MAPNAME"
		  entry["entry.2006356340"] = gmod.GetGamemode():GetGameDescription() or "GAMEMODENAME"
		  entry["entry.1883727441"] = gmod.GetGamemode().rpbase or "UNKNOWN"
		  entry["entry.1883727441"] = gmod.GetGamemode().Version or "0.0.0"
		  entry["entry.2045173320"] = string.upper( gmod.GetGamemode().VersionSort ) or "UNKNOWN"
			entry["entry.1106559712"] = game.GetIPAddress() or "0.0.0.0:99999"
			if first_time_error then
				entry["entry.1893317510"] = "YES"
			elseif !first_time_error then
				entry["entry.1893317510"] = "NO"
			else
				entry["entry.1893317510"] = "-"
			end
			entry["entry.471979789"] = string.upper( tostring( !game.SinglePlayer() ) )

		  http.Post( _url, entry, function( result )
		    if result then end
		  end, function( failed )
		    printGM( "note", "ERROR-API: " .. tostring( failed ) )
		  end )

			timer.Remove( "wait_for_gamemode"..str )
		end
	end)
end

local _sended = {}
function send_errors( realm, tbl )
  if _sended[realm] == nil then
     _sended[realm] = {}
  end
  for k, v in pairs( tbl ) do
    if !table.HasValue( _sended[realm], v ) then
      if k > #tbl-10 then
        send_error( realm, v )
      end
      table.insert( _sended[realm], v )
    end
  end
end

timer.Create( "update_error_tables", 60, 0, function()
  _cl_errors = update_error_table_cl()
  send_errors( "client", _cl_errors )
end)
