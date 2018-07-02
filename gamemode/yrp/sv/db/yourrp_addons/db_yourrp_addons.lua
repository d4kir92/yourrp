--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local yrp_addons = {}

local HANDLER_YOURRP_ADDONS = {}

function RemFromHandler_YourRP_Addons( ply )
	table.RemoveByValue( HANDLER_YOURRP_ADDONS, ply )
	printGM( "gm", ply:YRPName() .. " disconnected from YourRP_Addons" )
end

function AddToHandler_YourRP_Addons( ply )
	if !table.HasValue( HANDLER_YOURRP_ADDONS, ply ) then
		table.insert( HANDLER_YOURRP_ADDONS, ply )
		printGM( "gm", ply:YRPName() .. " connected to YourRP_Addons" )
	else
		printGM( "gm", ply:YRPName() .. " already connected to YourRP_Addons" )
	end
end

util.AddNetworkString( "Connect_Settings_YourRP_Addons" )
net.Receive( "Connect_Settings_YourRP_Addons", function( len, ply )
	if ply:CanAccess( "yourrp_addons" ) then
		AddToHandler_YourRP_Addons( ply )

		net.Start( "Connect_Settings_YourRP_Addons" )
			net.WriteTable( yrp_addons )
		net.Send( ply )
	end
end)

util.AddNetworkString( "Disconnect_Settings_YourRP_Addons" )
net.Receive( "Disconnect_Settings_YourRP_Addons", function( len, ply )
	RemFromHandler_YourRP_Addons( ply )
end)

function AddYRPAddon(tab)
	printGM("db", "Add YourRP Addon")
	if type(tab) != "table" then return false end
	tab.name = tab.name or ""
	tab.author = tab.author or "NO AUTHOR"
	tab.description = tab.description or ""
	tab.icon = tab.icon or ""
	tab.workshopid = tab.workshopid or ""
	tab.discord = tab.discord or ""
	tab.settings = tab.settings or ""
	if tab.name != "" then
		yrp_addons[tab.name .. " by " .. tab.author] = tab
		return true
	end
end
printTab(yrp_addons)
