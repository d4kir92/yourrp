--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

util.AddNetworkString("yrp_drop_table")
net.Receive("yrp_drop_table", function(len, ply)
	local tab = net.ReadString()
	db_drop_table( tab )
end)

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

		local tables = SQL_QUERY("SELECT name FROM sqlite_master WHERE type='table';")

		local nw_yrp = {}
		local nw_yrp_related = {}
		local nw_other = {}
		for i, tab in pairs( tables ) do
			if table.HasValue(GetDBNames(), tab.name) then
				if tab.name != "yrp_sql" then
					table.insert(nw_yrp, tab)
				end
			elseif string.StartWith(tab.name, "yrp_") then
				table.insert(nw_yrp_related, tab)
			elseif tab.name != "sqlite_sequence" then
				table.insert(nw_other, tab)
			end
		end

		local nw_sql = SQL_SELECT( "yrp_sql", "*", nil )
		if wk(nw_sql) then
			nw_sql = nw_sql[1]
		end

		net.Start( "Connect_Settings_Database" )
			net.WriteTable( nw_yrp )
			net.WriteTable( nw_yrp_related )
			net.WriteTable( nw_other )
			net.WriteTable( nw_sql )
		net.Send( ply )
	end
end)

util.AddNetworkString( "Disconnect_Settings_Database" )
net.Receive( "Disconnect_Settings_Database", function( len, ply )
	RemFromHandler_Database( ply )
end)

util.AddNetworkString( "get_sql_info" )
