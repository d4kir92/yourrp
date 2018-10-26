--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local _debug = true

if CLIENT then
	LocalPlayer():SetNWBool( "yrp_debug", false )
end
concommand.Add( "yrp__debug", function( ply, cmd, args )
	_debug = !_debug
	ply:SetNWBool( "yrp_debug", _debug )
	if _debug then
		printGM( "note", "Debug ON" )
	elseif !_debug then
		printGM( "note", "Debug OFF" )
	end
end )

function wk( obj )
	if obj != nil and obj != false then
		return true
	else
		return false
	end
end

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

function ea( ent )
	if tostring( ent ) != "[NULL Entity]" and ent != nil and ent != NULL then
		if ent:IsValid() then
			return true
		end
	end
	return false
end

function pa( panel )
	if tostring( panel ) != "[NULL Panel]" and panel != nil then
		return true
	end
	return false
end

function check_yrp_sv_errors( str )
	if !file.Exists( "yrp/sv_errors.txt", "DATA" ) then
		if !file.Exists( "yrp", "DATA" ) then
			printGM( "db", "yrp existiert nicht" )
			file.CreateDir( "yrp" )
		end
		printGM( "db", "yrp/sv_errors.txt existiert nicht" )
		file.Write( "yrp/sv_errors.txt", str )
		return false
	end
	return true
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

function yts( str , str2 )
	return string.find( string.lower( str ), string.lower( str2 ) )
end

function ErrorValidToSend( str )
	if ( yts( str, "/yrp/" ) or yts( str, "yourrp" ) ) and !yts( str, "database or disk is full" ) and !yts( str , "<eof>" ) then
		return true
	else
		return false
	end
end

local first_time_error = false
local _sv_errors = {}
function update_error_table_sv()
	local _read = file.Read( "lua_errors_server.txt", "GAME" )

	if worked( _read, "_read failed", true ) then
		local _file_exists = check_yrp_sv_errors( _read )
		if !_file_exists then
			first_time_error = true
		else
			first_time_error = false
		end

		local _yrp_read = file.Read( "yrp/sv_errors.txt", "DATA" )
		if worked( _yrp_read, "_yrp_read failed" ) then

			local _explode_yrp_read = string.Explode( "\n", _yrp_read )
			local _explode = string.Explode( "\n", _read )

			if #_explode < #_explode_yrp_read then
				--if error file is smaller, update data
				file.Write( "yrp/sv_errors.txt", _read )

			elseif #_explode > #_explode_yrp_read then
				--if error file is bigger, get all errors

				local _errors = {}
				for k, v in pairs( _explode ) do
					if k > #_explode_yrp_read then
						if !table.HasValue( _errors, v ) and !first_time_error then
							if ErrorValidToSend( v ) then
								table.insert( _errors, v )
							end
						end
					end
				end

				--update data file
				file.Write( "yrp/sv_errors.txt", _read )

				return _errors
			elseif first_time_error then
				local _errors = {}
				for k, v in pairs( _explode ) do
					if !table.HasValue( _errors, v ) then
						if ErrorValidToSend( v ) then
							table.insert( _errors, v )
						end
					end
				end

				--update data file
				file.Write( "yrp/sv_errors.txt", _read )

				return _errors
			else
				--printGM( "gm", "No new error" )
			end
		end
	end
	return {}
end

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
						if !table.HasValue( _errors, v ) and !first_time_error then
							if ErrorValidToSend( v ) then
								table.insert( _errors, v )
							end
						end
					end
				end

				--update data file
				file.Write( "yrp/cl_errors.txt", _read )

				return _errors
			elseif first_time_error then
				local _errors = {}
				for k, v in pairs( _explode ) do
					if !table.HasValue( _errors, v ) then
						if ErrorValidToSend( v ) then
							table.insert( _errors, v )
						end
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

function isdbfull( str )
	if CLIENT then
		if string.find( str, "full" ) then
			local FRAME = createD( "DFrame", nil, ctr( 1800 ), ctr( 300 ), 0, 0 )
			FRAME:SetTitle( "" )
			FRAME:Center()
			FRAME:MakePopup()
			function FRAME:Paint( pw, ph )
				surfaceWindow( self, pw, ph, "INFO" )
				surfaceText( "YOUR DATABASE IS FULL! (Your Disk)", "mat1header", pw/2, ctr( 100 ), Color( 255, 255, 255, 255 ), 1, 1 )
			end
		end
	end
end

function ismalformed( str )
	if string.find( str, "database disk image is malformed" ) then
		if CLIENT then
			local FRAME = createD( "DFrame", nil, ctr( 1800 ), ctr( 300 ), 0, 0 )
			FRAME:SetTitle( "" )
			FRAME:Center()
			FRAME:MakePopup()
			function FRAME:Paint( pw, ph )
				surfaceWindow( self, pw, ph, "INFO" )
				surfaceText( "YOUR DATABASE IS MALFORMED, please join the Discord and tell the DEVs!", "mat1header", pw/2, ctr( 100 ), Color( 255, 255, 255, 255 ), 1, 1 )
				surfaceText( "Stop Game, delete .../garrysmod/garrysmod/cl.db to fix this problem", "mat1header", pw/2, ctr( 150 ), Color( 255, 255, 255, 255 ), 1, 1 )
			end

			FRAME.discord = createD( "DButton", FRAME, ctr( 400 ), ctr( 50 ), ctr( 900-200 ), ctr( 200 ) )
			FRAME.discord:SetText( "" )
			function FRAME.discord:Paint( pw, ph )
				surfaceButton( self, pw, ph, "JOIN DISCORD" )
			end
			function FRAME.discord:DoClick()
				gui.OpenURL( "https://discord.gg/sEgNZxg" )
			end
		end
	end
end

local _url = "https://docs.google.com/forms/d/e/1FAIpQLSdTOU5NjdzpUjOyYbymXOeM3oyFfoVFBNKOAcBZbX3UxgAK6A/formResponse"
local _url2 = "https://docs.google.com/forms/d/e/1FAIpQLSdTOU5NjdzpUjOyYbymXOeM3oyFfoVFBNKOAcBZbX3UxgAK6A/formResponse"
function send_error( realm, str )
	local entry = {}
	timer.Create( "wait_for_gamemode" .. str, 1, 0, function()
		if gmod.GetGamemode() != nil then
			isdbfull( str )
			ismalformed( str )
			entry["entry.956735581"] = string.upper( tostring( game.IsDedicated() ) )
			entry["entry.915525654"] = tostring( str )
			entry["entry.58745995"] = tostring( realm )
			entry["entry.1306533151"] = GetMapName() or "MAPNAME"
			entry["entry.2006356340"] = gmod.GetGamemode():GetGameDescription() or "GAMEMODENAME"
			entry["entry.1883727441"] = gmod.GetGamemode().rpbase or "UNKNOWN"
			entry["entry.1883727441"] = gmod.GetGamemode().Version or "0.0.0"
			entry["entry.2045173320"] = string.upper( gmod.GetGamemode().VersionSort ) or "UNKNOWN"
			entry["entry.1106559712"] = game.GetIPAddress() or "0.0.0.0:99999"
			if CLIENT then
				local ply = LocalPlayer()
				local _steamid = "UNKNOWN"
				if ea( ply ) then
					_steamid = ply:SteamID()
				end
				entry["entry.1898856001"] = tostring( _steamid )
			else
				entry["entry.1898856001"] = "SERVER"
			end

			if first_time_error then
				entry["entry.1893317510"] = "YES"
			elseif !first_time_error then
				entry["entry.1893317510"] = "NO"
			else
				entry["entry.1893317510"] = "-"
			end
			entry["entry.471979789"] = string.upper( tostring( !game.SinglePlayer() ) )

			if realm != "server_all" then
				http.Post( _url, entry, function( result )
					if result then
						printGM( "gm", "[SENT ERROR TO DEVELOPER] " .. str )
					end
				end, function( failed )
					if tostring( failed ) != "unsuccessful" then
						printGM( "error", "ERROR1-API: " .. tostring( failed ) )
					end
				end )
			else
				http.Post( _url2, entry, function( result )
					if result then
						printGM( "gm", "[SENT ERROR TO DEVELOPER 2] " .. str )
					end
				end, function( failed )
					if tostring( failed ) != "unsuccessful" then
						printGM( "error", "ERROR2-API: " .. tostring( failed ) )
					end
				end )
			end

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
			send_error( realm, v )
			table.insert( _sended[realm], v )
		end
	end
end

function IsNearVersion( distance )
	local _version = YRPVersion()
	local _version_online = YRPOnlineVersion()

	for k, v in pairs( _version ) do
		if k < #_version_online then
			if tonumber( _version[k] ) < tonumber( _version_online[k] ) then
				break
			end
		else
			if tonumber( _version[k] ) + distance >= tonumber( _version_online[k] ) then
				return true
			end
		end
	end

	return false
end

local tick = 0

function ErrorMod()
	return YRPErrorMod()
end

function CanSendError()
	if game.MaxPlayers() > 1 then
		if CLIENT then
			if LocalPlayer():GetNWBool("serverdedicated", false) then
				if LocalPlayer():GetNWBool("bool_server_debug", true) then
					if tick % LocalPlayer():GetNWInt("int_server_debug_tick", 60) == 0 then
						return true
					end
				else
					if tick % 3600 == 0 then
						return true
					end
				end
			end
		elseif SERVER and game.IsDedicated() then
			if YRPDebug() then
				if tick % ErrorMod() == 0 then
					return true
				end
			else
				if tick % 3600 == 0 then
					return true
				end
			end
		end
	end
	return false
end

function SendAllErrors( str )
	if str != nil then
		printGM( "note", "[SendAllErrors] " .. str )
	end
	if !IsYRPOutdated() or IsNearVersion( 1 ) then
		_cl_errors = update_error_table_cl()
		send_errors( "client", _cl_errors )

		_sv_errors = update_error_table_sv()
		send_errors( "server", _sv_errors )
	end
end

timer.Create( "update_error_tables", 1, 0, function()
	if CanSendError() then
		SendAllErrors()
	end
	tick = tick + 1
end)
