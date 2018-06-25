--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local HANDLER_STATUS = {}

function RemFromHandler_Status( ply )
	table.RemoveByValue( HANDLER_STATUS, ply )
	printGM( "gm", ply:YRPName() .. " disconnected from Status" )
end

function AddToHandler_Status( ply )
	if !table.HasValue( HANDLER_STATUS, ply ) then
		table.insert( HANDLER_STATUS, ply )
		printGM( "gm", ply:YRPName() .. " connected to Status" )
	else
		printGM( "gm", ply:YRPName() .. " already connected to Status" )
	end
end

util.AddNetworkString( "Connect_Settings_Status" )
net.Receive( "Connect_Settings_Status", function( len, ply )
	if ply:CanAccess( "status" ) then
		AddToHandler_Status( ply )

		net.Start( "Connect_Settings_Status" )
			net.WriteTable( {} )
		net.Send( ply )
	end
end)

util.AddNetworkString( "Disconnect_Settings_Status" )
net.Receive( "Disconnect_Settings_Status", function( len, ply )
	RemFromHandler_Status( ply )
end)
