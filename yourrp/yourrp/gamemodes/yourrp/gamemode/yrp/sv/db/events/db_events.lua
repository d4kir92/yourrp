--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_events"

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_eventname", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_chars", "TEXT DEFAULT ''" )

util.AddNetworkString( "setting_events" )
net.Receive( "setting_events", function(len, ply)
	if ply:CanAccess( "bool_events" ) then
		net.Start( "setting_events" )
		net.Send(ply)
	end
end)

function YRPSendEvents(ply)
	local tab = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)

	if !IsNotNilAndNotFalse(tab) then -- when empty, send empty
		tab = {}
	end

	net.Start( "yrp_get_events" )
		net.WriteTable(tab)
	net.Send(ply)
end

util.AddNetworkString( "yrp_get_events" )
net.Receive( "yrp_get_events", function(len, ply)
	if ply:CanAccess( "bool_events" ) then
		YRPSendEvents(ply)
	end
end)

util.AddNetworkString( "yrp_event_add" )
net.Receive( "yrp_event_add", function(len, ply)
	if ply:CanAccess( "bool_events" ) then
		local name = net.ReadString()

		if name and name != "" then
			YRP_SQL_INSERT_INTO(DATABASE_NAME, "string_eventname", "'" .. name .. "'" )
			YRPSendEvents(ply)
		end
	end
end)

util.AddNetworkString( "yrp_event_remove" )
net.Receive( "yrp_event_remove", function(len, ply)
	if ply:CanAccess( "bool_events" ) then
		local uid = net.ReadString()

		if uid and uid != "" then
			YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. uid .. "'" )
			YRPSendEvents(ply)
		end
	end
end)

function YRPSendEventChars(ply, uid)
	local tab = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'" )

	if IsNotNilAndNotFalse(tab) then
		tab = tab[1]
	else
		tab = {}
	end

	net.Start( "yrp_get_event_chars", ply)
		net.WriteTable(tab)
	net.Send(ply)
end

util.AddNetworkString( "yrp_get_event_chars" )
net.Receive( "yrp_get_event_chars", function(len, ply)
	local uid = net.ReadString()
	YRPSendEventChars(ply, uid)
end)

util.AddNetworkString( "yrp_event_get_chars" )
net.Receive( "yrp_event_get_chars", function(len, ply)
	local steamid = net.ReadString()
	local tab = YRP_SQL_SELECT( "yrp_characters", "*", "SteamID = '" .. steamid .. "' AND bool_eventchar = '1'" )

	if !IsNotNilAndNotFalse(tab) then
		tab = {}
	end

	net.Start( "yrp_event_get_chars" )
		net.WriteTable(tab)
	net.Send(ply)
end)

util.AddNetworkString( "yrp_event_char_add" )
net.Receive( "yrp_event_char_add", function(len, ply)
	if ply:CanAccess( "bool_events" ) then
		local uid = net.ReadString()
		local steamid = net.ReadString()
		local charuid = net.ReadString()
		local charname = net.ReadString()

		local tab = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'" )

		if IsNotNilAndNotFalse(tab) then
			tab = tab[1]
			
			local str = tab.string_chars
			if str != "" then
				str = str .. ";"
			end
			str = str .. steamid .. "," .. charuid .. "," .. charname

			YRP_SQL_UPDATE(DATABASE_NAME, {["string_chars"] = str}, "uniqueID = '" .. uid .. "'" )
		end

		YRPSendEventChars(ply, uid)
	end
end)

util.AddNetworkString( "yrp_event_char_remove" )
net.Receive( "yrp_event_char_remove", function(len, ply)
	if ply:CanAccess( "bool_events" ) then
		local euid = net.ReadString()
		local cuid = net.ReadString()

		if euid and euid != "" then
			local tab = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. euid .. "'" )

			if IsNotNilAndNotFalse(tab) then
				tab = tab[1]
				local newchars = ""
				tab = string.Split(tab.string_chars, ";" )
				for i, v in pairs(tab) do
					local test = string.Explode( ",", v)
					if test[2] != cuid then
						if  newchars != "" then
							newchars = newchars .. ";"
						end
						newchars = newchars .. v
					end
				end

				YRP_SQL_UPDATE(DATABASE_NAME, {["string_chars"] = newchars}, "uniqueID = '" .. euid .. "'" )
			end

			YRPSendEventChars(ply, euid)
		end
	end
end)



function YRPSpawnAsCharacter(ply, cuid, force)
	local roltab = ply:YRPGetRoleTable()
	if IsNotNilAndNotFalse(roltab) then
		YRPUpdateRoleUses(roltab.uniqueID)
	end

	ply:SetYRPBool( "yrp_chararchived", false )

	if cuid != ply:CharID() then
		if GetGlobalYRPBool( "bool_removebuildingownercharswitch", false) then
			BuildingRemoveOwner( ply:YRPSteamID() )
		end
		hook.Run( "yrp_switched_character", ply, ply:CharID(), cuid)
	end
	if IsNotNilAndNotFalse( cuid ) then
		YRP_SQL_UPDATE( "yrp_players", {["CurrentCharacter"] = cuid}, "SteamID = '" .. ply:YRPSteamID() .. "'" )
		if !force then
			YRP_SQL_UPDATE( "yrp_players", {["NormalCharacter"] = cuid}, "SteamID = '" .. ply:YRPSteamID() .. "'" )
		end
		ply:SetYRPInt( "yrp_charid", cuid)
		ply:SetYRPBool( "yrp_spawning", true)

		YRPPlayerLoadout( ply )

		ply:SetYRPBool( "yrp_characterselection", false )

		timer.Simple(0.1, function()
			if EntityAlive( ply ) then
				ply:Spawn()
			end
		end)
	else
		YRP.msg( "gm", "No valid character selected ( " .. tostring( char) .. " )" )
	end
end



local antinoti3spam = {}
util.AddNetworkString( "yrp_info3" )
function YRPNotiToPly(msg)
	if not table.HasValue( antinoti3spam, ply) then
		table.insert( antinoti3spam, ply)

		net.Start( "yrp_info3" )
			net.WriteString(msg)
		net.Broadcast()

		timer.Simple(5, function()
			table.RemoveByValue( antinoti3spam, ply)
		end)
	end
end

util.AddNetworkString( "yrp_event_start" )
net.Receive( "yrp_event_start", function(len, ply)
	local euid = net.ReadString()

	local tab = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. euid .. "'" )
	if IsNotNilAndNotFalse(tab) then
		tab = tab[1]

		SetGlobalYRPBool( "yrp_event_running", true)

		local chars = string.Explode( ";", tab.string_chars)
		for i, charstring in pairs( chars) do
			local chartab = string.Explode( ",", charstring)
			for n, p in pairs(player.GetAll() ) do
				if p:YRPSteamID() == chartab[1] then
					p:KillSilent()
					YRPSpawnAsCharacter(p, chartab[2], true)
				end
			end
		end

		YRPNotiToPly( "Event started! ( " .. tab.string_eventname .. " )" )
	end
end)

util.AddNetworkString( "yrp_event_end" )
net.Receive( "yrp_event_end", function(len, ply)
	local euid = net.ReadString()

	local tab = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. euid .. "'" )
	if IsNotNilAndNotFalse(tab) then
		tab = tab[1]

		SetGlobalYRPBool( "yrp_event_running", false)

		local chars = string.Explode( ";", tab.string_chars)
		for i, charstring in pairs( chars) do
			local chartab = string.Explode( ",", charstring)
			for n, p in pairs(player.GetAll() ) do
				if p:YRPSteamID() == chartab[1] then
					p:KillSilent()
					local plytab = p:GetPlyTab()
					if plytab then
						YRPSpawnAsCharacter(p, plytab.NormalCharacter)
					end
				end
			end
		end

		YRPNotiToPly( "Event ended! ( " .. tab.string_eventname .. " )" )
	end
end)
