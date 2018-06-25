--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local HANDLER_DATABASE = {}

function RemFromHandler_Database( ply )
	table.RemoveByValue( HANDLER_DATABASE, ply )
	printGM( "gm", ply:YRPName() .. " disconnected from Database" )
end

function AddToHandler_Database( ply )
	if !table.HasValue( HANDLER_DATABASE, ply ) then
		table.insert( HANDLER_DATABASE, ply )
		printGM( "gm", ply:YRPName() .. " connected to Database" )
	else
		printGM( "gm", ply:YRPName() .. " already connected to Database" )
	end
end

util.AddNetworkString( "Connect_Settings_Database" )
net.Receive( "Connect_Settings_Database", function( len, ply )
	if ply:CanAccess( "database" ) then
		AddToHandler_Database( ply )

		net.Start( "Connect_Settings_Database" )
			net.WriteTable( {} )
		net.Send( ply )
	end
end)

util.AddNetworkString( "Disconnect_Settings_Database" )
net.Receive( "Disconnect_Settings_Database", function( len, ply )
	RemFromHandler_Database( ply )
end)
