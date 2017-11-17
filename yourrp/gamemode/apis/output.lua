--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local g_text = g_text or {}
g_text.pre = "#YRP# "
g_text.gmname = "YourRP"
g_text.loaddb = "LOAD DB: "
g_text.successdb = " created successfully."
g_text.spacePre = "\n__________________________________________________________________________[" .. "YRP" .. "]_"
g_text.spacePos = "¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯[" .. "YRP" .. "]¯\n"

function hr()
	print( "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -" )
end

function hr_pre()
	print( g_text.spacePre )
end

function hr_pos()
	print( g_text.spacePos )
end

local darkrp_debug = false
function printGM( channel, text )
	local _string = tostring( text )
	if _string != "nil" then
		local _pool = "unknown"
		if SERVER then
			_pool = "sv"
		elseif CLIENT then
			_pool = "cl"
		end

		local _tmpText = string.Explode( "\n", _string )

		local _color = Color( 255, 0, 0 )
		local _color2 = Color( 255, 0, 0 )
		local _color3 = Color( 255, 0, 0 )

		local _channelName = "FAIL"
		if CLIENT then
			_color = Color( 255, 222, 102 )
		elseif SERVER then
			_color = Color( 137, 222, 255 )
		end
		_color3 = _color

		if channel == "note" then
			_color2 = Color( 255, 120, 0 )
			_channelName = "NOTE"
		elseif channel == "db" then
			_color2 = Color( 255, 255, 0 )
			_channelName = "DATABASE"
		elseif channel == "server" then
			_color2 = Color( 255, 255, 0 )
			_channelName = "SERVER"
		elseif channel == "user" then
			_color2 = Color( 255, 255, 0 )
			_channelName = "USER"
		elseif channel == "admin" then
			_color2 = Color( 255, 255, 0 )
			_channelName = "ADMIN"
		elseif channel == "gm" then
			_color2 = Color( 255, 255, 0 )
			_channelName = "GAMEMODE"
		elseif channel == nil then
			_color2 = Color( 255, 255, 0 )
			_channelName = ""
		elseif channel == "instructor" then
			_color2 = Color( 255, 255, 0 )
			_channelName = "INSTRUCTOR"
		elseif channel == "error" then
			_color2 = Color( 255, 0, 0 )
			_channelName = "ERROR"
			_color3 = _color2
		elseif channel == "lang" then
			_color2 = Color( 255, 255, 0 )
			_channelName = "LANGUAGE"
		elseif channel == "darkrp" then
			_color2 = Color( 255, 0, 0 )
			_channelName = "DarkRP-Int."
			if !darkrp_debug then
				return
			end
		end
		for k, v in pairs(_tmpText) do
			if _channelName != "" then
				MsgC( _color, "[", Color( 255, 255, 0 ), g_text.gmname, _color, "|" .. string.upper( _pool ) .. "|", _color2, _channelName, _color, "] ", _color3, v )
				MsgC( "\n" )
			else
				MsgC( _color, "[", Color( 255, 255, 0 ), g_text.gmname, _color, "] ", _color3, v )
				MsgC( "\n" )
			end
		end
	end
end
