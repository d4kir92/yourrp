--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_keybinds"

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "name", "TEXT DEFAULT ''")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "value", "INT DEFAULT 0")

if YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = 1") == nil then
	YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'Version', '1'")
end

--YRP_SQL_DROP_TABLE(DATABASE_NAME)

util.AddNetworkString("SetServerKeybinds")
local PLAYER = FindMetaTable("Player")
function PLAYER:SetServerKeybinds()
	local selresult = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
	if wk( selresult ) then
		net.Start( "SetServerKeybinds" )
			net.WriteTable( selresult )
		net.Send( self )
	else
		YRP.msg( "note", "Keybinds broken??" )
	end
end

util.AddNetworkString("setserverdefaultkeybind")
net.Receive("setserverdefaultkeybind", function(len, ply)
	local keybinds = net.ReadTable()
	for name, value in pairs(keybinds) do
		local selresult = YRP_SQL_SELECT(DATABASE_NAME, "*", "name = '" .. name .. "'")
		if selresult != nil then
			YRP_SQL_UPDATE(DATABASE_NAME, {["value"] = value}, "name = '" .. name .. "'")
		else
			YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. name .. "', '" .. value .. "'")
		end
	end
end)

util.AddNetworkString("forcesetkeybinds")
net.Receive("forcesetkeybinds", function(len, ply)
	for i, p in pairs(player.GetAll()) do
		p:SetServerKeybinds()
	end
end)
