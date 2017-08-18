//Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

//shared_pres.lua

GM.Name = 				"YourRP"
GM.ShortName =		"YRP"	//Not longer then 4!
GM.Author =				"D4KiR"
GM.Email =				""
GM.Website =			"youtube.com/c/D4KiR"
GM.Twitter =			"twitter.com/D4KIR"
GM.Version =			"0.3.5"
GM.VersionSort = 	""
GM.Help =					""

DeriveGamemode( "sandbox" )

yrp = {}
yrp.pre = "#YRP# "
yrp.gmname = "YourRP"
yrp.spacePre = "\n__________________________________________________________________________[" .. GM.ShortName .. "]_"
yrp.spacePos = "¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯[" .. GM.ShortName .. "]¯\n"
yrp.langfound = 0
yrp.errorPre = "ERROR! PLEASE, tell the [" .. GM.Name .. "] DEVS: "
yrp.errorPos = "!"

//Pre's
//yrp.file = yrp.pre .. "#FILE "

deb = {}
deb.pre = yrp.pre .. "##DEBUG## "
deb.size = deb.pre .. "#SIZE "

colors = {}
function addColor( string, r, g, b, a )
	colors[string] = {}
	colors[string].r = r
	colors[string].g = g
	colors[string].b = b
	colors[string].a = a
end

addColor( "epicBlue", 23, 113, 240, 100 )
addColor( "darkBG", 0, 0, 0, 200 )
addColor( "epicOrange", 255, 140, 0, 200 )

function Logo()
	printGM( nil, "#############################" )
  printGM( nil, "#                           #" )
  printGM( nil, "#    #   #  ####   ####     #" )
  printGM( nil, "#     # #   #   #  #   #    #" )
  printGM( nil, "#      #    ####   ####     #" )
  printGM( nil, "#      #    # #    #        #" )
	printGM( nil, "#      #    #  #   #        #" )
	printGM( nil, "#                           #" )
	printGM( nil, "#############################" )
end

function finishedLoading()
	print(yrp.spacePre)
	Logo()
	printGM( nil, "Loaded " .. GAMEMODE.Name .. " [v" .. GAMEMODE.Version .. "] successfully!")
	printGM( nil, "[Created by " .. GAMEMODE.Author.."]")
	printGM( nil, "Youtube: "..GAMEMODE.Website)
	printGM( nil, "Twitter: "..GAMEMODE.Twitter)
	printGM( nil, "")
	printGM( nil, "Server: " .. GetHostName())
	printGM( nil, "Map: " .. string.lower( game.GetMap() ))
	print(yrp.spacePos)
end

if SERVER then
  util.AddNetworkString( "getGamemodename" )

  local tmp = sql.Query( "SELECT value FROM yrp_general WHERE name = 'gamemodename'" )
	if tmp != false and tmp != nil then
	  GM.Name = tmp[1].value
	  timer.Simple( 1, function()
	    finishedLoading()
	  end)
	end
end

if CLIENT then
  timer.Simple( 1, function()
    net.Start( "getGamemodename" )
    net.SendToServer()
    timer.Simple( 1, function()
      finishedLoading()
    end)
  end)

  net.Receive( "getGamemodename", function( len, ply )
    GAMEMODE.Name = net.ReadString()
  end)
end

function printGM( channel, string )
	if string != nil then
		local _tmpText = string.Explode( "\n", string )
		local _color = Color( 255, 0, 0 )
		local _color2 = Color( 255, 0, 0 )
		local _channelName = "FAIL"
		if CLIENT then
			_color = Color( 255, 222, 102 )
		elseif SERVER then
			_color = Color( 137, 222, 255 )
		end
		if channel == "note" then
			_color2 = Color( 255, 120, 0 )
			_channelName = "NOTIFICATION"
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
		end
		for k, v in pairs(_tmpText) do
			if _channelName != "" then
				MsgC( _color, "[", Color( 255, 255, 0 ), yrp.gmname, _color, "] [", _color2, _channelName, _color, "] " .. v .. "\n" )
			else
				MsgC( _color, "[", Color( 255, 255, 0 ), yrp.gmname, _color, "] ", _color, v .. "\n" )
			end
		end
	end
end

function printError( string )
	printGM( "error", string )
end
