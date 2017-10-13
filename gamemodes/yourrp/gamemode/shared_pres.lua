--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--shared_pres.lua

GM.Name = "YourRP"
GM.ShortName = "YRP"	--Not longer then 4!
GM.Author = "D4KiR"
GM.Email = ""
GM.Website = "youtube.com/c/D4KiR"
GM.Twitter = "twitter.com/D4KIR"
GM.Version = "0.9.0.5"
GM.VersionSort = "unstable"
GM.dedicated = "-"
GM.Help = ""

if SERVER then
	util.AddNetworkString( "getServerVersion" )
	net.Receive( "getServerVersion", function( len, ply )
		net.Start( "getServerVersion" )
			net.WriteString( GAMEMODE.Version )
			net.WriteBool( game.IsDedicated() )
		net.Send( ply )
	end)
end

DeriveGamemode( "sandbox" )

yrp = {}
yrp.pre = "#YRP# "
yrp.gmname = "YourRP"
yrp.spacePre = "\n__________________________________________________________________________[" .. GM.ShortName .. "]_"
yrp.spacePos = "¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯[" .. GM.ShortName .. "]¯\n"
yrp.langfound = 0
yrp.errorPre = "ERROR! PLEASE, tell the [" .. GM.Name .. "] DEVS: "
yrp.errorPos = "!"
yrp.loaddb = "LOAD DB: "
yrp.successdb = " created successfully."

yrp.colors = {}
function addColor( string, r, g, b, a )
	yrp.colors[string] = {}
	yrp.colors[string].r = r
	yrp.colors[string].g = g
	yrp.colors[string].b = b
	yrp.colors[string].a = a
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

function worked( obj, name )
  if obj != nil and obj != false then
    return true
  else
    printGM( "note", "not worked: " .. tostring( obj ) .. " " .. tostring( name ) )
    return false
  end
end

function printGMPre( channel, string )
	print( yrp.spacePre )
	printGM( channel, string )
end

function printGMPos( )
	print( yrp.spacePos )
end

function printGMImp( channel, string )
	print( yrp.spacePre )
	printGM( channel, string )
	print( yrp.spacePos )
end

function printGM( channel, _string )
	local string = tostring( _string )
	if string != "nil" then
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
		elseif channel == "lang" then
			_color2 = Color( 255, 255, 0 )
			_channelName = "LANGUAGE"
		elseif channel == "darkrp" then
			_color2 = Color( 255, 0, 0 )
			_channelName = "DarkRP-Integration"
		end
		for k, v in pairs(_tmpText) do
			if _channelName != "" then
				MsgC( _color, "[", Color( 255, 255, 0 ), yrp.gmname, _color, "] [", _color2, _channelName, _color, "] " .. v )
				MsgC( "\n" )
			else
				MsgC( _color, "[", Color( 255, 255, 0 ), yrp.gmname, _color, "] " .. v )
				MsgC( "\n" )
			end
		end
	end
end

function printDRP( string )
	printGM( "darkrp", string )
end

function printERROR( string )
	printGM( "error", string )
end

function getAllVehicles()
  local _getVehicles = list.Get( "Vehicles" )

  local _simfphys = list.Get( "simfphys_vehicles" )
	for k, v in pairs( _simfphys ) do
		v.Custom = "simfphys"
		v.WorldModel = v.WorldModel or v.Model or ""
    v.ClassName = v.ClassName or v.Class or ""
    v.PrintName = v.PrintName or v.Name or ""
		v.Skin = v.Skin or "-1"
		if k != nil then
			v.ClassName = k
		end
    table.insert( _getVehicles, v )
  end

	local _scars = list.Get( "SCarVehicles" )
	for k, v in pairs( _scars ) do
		v.Custom = "scars"
		v.WorldModel = v.WorldModel or v.Model or ""
    v.ClassName = v.ClassName or v.Class or ""
    v.PrintName = v.PrintName or v.Name or ""
    table.insert( _getVehicles, v )
  end

	local _swvehicles = list.Get( "SWVehicles" )
	for k, v in pairs( _swvehicles ) do
		v.Custom = "swvehicles"
		v.WorldModel = v.WorldModel or v.Model or v.EntModel .. ""
    v.ClassName = v.ClassName or v.Class or ""
    v.PrintName = v.PrintName or v.Name or ""
    table.insert( _getVehicles, v )
  end

  local vehicles = {}
  local count = 0
  for k, v in pairs( _getVehicles ) do
    count = count + 1
    vehicles[count] = {}
    vehicles[count].WorldModel = v.WorldModel or v.Model or ""
    vehicles[count].ClassName = v.ClassName or v.Class or ""
    vehicles[count].PrintName = v.PrintName or v.Name or ""
		if v.EMV != nil then
			vehicles[count].Skin = v.Skin or v.EMV.Skin or "-1"
		else
			vehicles[count].Skin = v.Skin or "-1"
		end
		vehicles[count].Custom = v.Custom or ""
		vehicles[count].KeyValues = v.KeyValues or {}
  end

  return vehicles
end
