--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local _version_online = {}
function YRPOnlineVersion()
	return _version_online
end

function YRPCheckVersion()
	http.Fetch( "https://docs.google.com/document/d/1mvyVK5OzHajMuq6Od74-RFaaRV7flbR2pYBiyuWVGxA/edit?usp=sharing",
	function( body, len, headers, code )
		local StartPos = string.find( body, "#", 1, false )
		local EndPos = string.find( body, "*", 1, false )
		local versionOnline = string.sub( body, StartPos+1, EndPos-1 )
		_version_online = string.Explode( ".", versionOnline )

		if CLIENT then
			_version_client = string.Explode( ".", GAMEMODE.Version )
			if #_version_client == #_version_online then
				for k, v in pairs( _version_client ) do
					if tonumber( _version_client[k] ) < tonumber( _version_online[k] ) then
						_cl_outdated = true
					elseif tonumber( _version_client[k] ) > tonumber( _version_online[k] ) then
						_cl_outdated = false
						ChangeChannel( "canary" )
					elseif tonumber( _version_client[k] ) == tonumber( _version_online[k] ) then
						_cl_outdated = false
					end
				end
			else
				printGM( "error", "VERSION CHECK ERROR CL" )
			end
			return _cl_outdated
		end
		if SERVER then
			_version_server = string.Explode( ".", GAMEMODE.Version )
			if #_version_server == #_version_online then
				for k, v in pairs( _version_server ) do
					if tonumber( _version_server[k] ) < tonumber( _version_online[k] ) then
						_sv_outdated = true
					elseif tonumber( _version_server[k] ) > tonumber( _version_online[k] ) then
						_sv_outdated = false
						ChangeChannel( "canary" )
					elseif tonumber( _version_server[k] ) == tonumber( _version_online[k] ) then
						_sv_outdated = false
					end
				end
			else
				printGM( "error", "VERSION CHECK ERROR SV" )
			end
			return _sv_outdated
		end
	end,
		function( error )
			--
		end
	)
end
YRPCheckVersion()

local _sv_outdated = false
local _cl_outdated = false
local _version_client = {}
local _version_server = {}

function YRPVersion()
	if SERVER then
		return _version_server
	elseif CLIENT then
		return _version_client
	end
end

function IsYRPOutdated()
	if CLIENT then
		return _cl_outdated
	elseif SERVER then
		return _sv_outdated
	end
end

if SERVER then
	util.AddNetworkString( "getServerVersion" )
	net.Receive( "getServerVersion", function( len, ply )
		net.Start( "getServerVersion" )
			net.WriteString( GAMEMODE.Version )
			net.WriteBool( game.IsDedicated() )
		net.Send( ply )
	end)

  util.AddNetworkString( "getGamemodename" )
	timer.Simple( 4, function()
	  local tmp = SQL_SELECT( "yrp_general", "text_gamemode_name", nil )
		if tmp != false and tmp != nil then
		  GAMEMODE.BaseName = SQL_STR_OUT( tmp[1].text_gamemode_name )
		end
	end)
end
