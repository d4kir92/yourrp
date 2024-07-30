--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
local DATABASE_NAME = "yrp_events"
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_eventname", "TEXT DEFAULT ''")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_chars", "TEXT DEFAULT ''")
YRP:AddNetworkString("nws_yrp_setting_events")
net.Receive(
	"nws_yrp_setting_events",
	function(len, ply)
		if ply:CanAccess("bool_events") then
			net.Start("nws_yrp_setting_events")
			net.Send(ply)
		end
	end
)

function YRPSendEvents(ply)
	local tab = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
	-- when empty, send empty
	if not IsNotNilAndNotFalse(tab) then
		tab = {}
	end

	net.Start("nws_yrp_get_events")
	net.WriteTable(tab)
	net.Send(ply)
end

YRP:AddNetworkString("nws_yrp_get_events")
net.Receive(
	"nws_yrp_get_events",
	function(len, ply)
		if ply:CanAccess("bool_events") then
			YRPSendEvents(ply)
		end
	end
)

YRP:AddNetworkString("nws_yrp_event_add")
net.Receive(
	"nws_yrp_event_add",
	function(len, ply)
		if ply:CanAccess("bool_events") then
			local name = net.ReadString()
			if name and name ~= "" then
				YRP_SQL_INSERT_INTO(DATABASE_NAME, "string_eventname", "'" .. name .. "'")
				YRPSendEvents(ply)
			end
		end
	end
)

YRP:AddNetworkString("nws_yrp_event_remove")
net.Receive(
	"nws_yrp_event_remove",
	function(len, ply)
		if ply:CanAccess("bool_events") then
			local uid = net.ReadString()
			if uid and uid ~= "" then
				YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. uid .. "'")
				YRPSendEvents(ply)
			end
		end
	end
)

function YRPSendEventChars(ply, uid)
	local tab = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
	if IsNotNilAndNotFalse(tab) then
		tab = tab[1]
	else
		tab = {}
	end

	net.Start("nws_yrp_get_event_chars", ply)
	net.WriteTable(tab)
	net.Send(ply)
end

YRP:AddNetworkString("nws_yrp_get_event_chars")
net.Receive(
	"nws_yrp_get_event_chars",
	function(len, ply)
		local uid = net.ReadString()
		YRPSendEventChars(ply, uid)
	end
)

YRP:AddNetworkString("nws_yrp_event_get_chars")
net.Receive(
	"nws_yrp_event_get_chars",
	function(len, ply)
		local steamid = net.ReadString()
		local tab = YRP_SQL_SELECT("yrp_characters", "*", "SteamID = '" .. steamid .. "' AND bool_eventchar = '1'")
		if not IsNotNilAndNotFalse(tab) then
			tab = {}
		end

		net.Start("nws_yrp_event_get_chars")
		net.WriteTable(tab)
		net.Send(ply)
	end
)

YRP:AddNetworkString("nws_yrp_event_char_add")
net.Receive(
	"nws_yrp_event_char_add",
	function(len, ply)
		if ply:CanAccess("bool_events") then
			local uid = net.ReadString()
			local steamid = net.ReadString()
			local charuid = net.ReadString()
			local charname = net.ReadString()
			local tab = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
			if IsNotNilAndNotFalse(tab) then
				tab = tab[1]
				local str = tab.string_chars
				if str ~= "" then
					str = str .. ";"
				end

				str = str .. steamid .. "," .. charuid .. "," .. charname
				YRP_SQL_UPDATE(
					DATABASE_NAME,
					{
						["string_chars"] = str
					}, "uniqueID = '" .. uid .. "'"
				)
			end

			YRPSendEventChars(ply, uid)
		end
	end
)

YRP:AddNetworkString("nws_yrp_event_char_remove")
net.Receive(
	"nws_yrp_event_char_remove",
	function(len, ply)
		if ply:CanAccess("bool_events") then
			local euid = net.ReadString()
			local cuid = net.ReadString()
			if euid and euid ~= "" then
				local tab = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. euid .. "'")
				if IsNotNilAndNotFalse(tab) then
					tab = tab[1]
					local newchars = ""
					tab = string.Split(tab.string_chars, ";")
					for i, v in pairs(tab) do
						local test = string.Explode(",", v)
						if test[2] ~= cuid then
							if newchars ~= "" then
								newchars = newchars .. ";"
							end

							newchars = newchars .. v
						end
					end

					YRP_SQL_UPDATE(
						DATABASE_NAME,
						{
							["string_chars"] = newchars
						}, "uniqueID = '" .. euid .. "'"
					)
				end

				YRPSendEventChars(ply, euid)
			end
		end
	end
)

function YRPSpawnAsCharacter(ply, cuid, force)
	local roltab = ply:YRPGetRoleTable()
	if IsNotNilAndNotFalse(roltab) then
		YRPUpdateRoleUses(roltab.uniqueID)
	end

	ply:SetYRPBool("yrp_chararchived", false)
	if cuid ~= ply:CharID() then
		if GetGlobalYRPBool("bool_removebuildingownercharswitch", false) then
			YRPBuildingRemoveOwner(ply:YRPSteamID())
		end

		hook.Run("yrp_switched_character", ply, ply:CharID(), cuid)
	end

	if IsNotNilAndNotFalse(cuid) then
		YRP_SQL_UPDATE(
			"yrp_players",
			{
				["CurrentCharacter"] = cuid
			}, "SteamID = '" .. ply:YRPSteamID() .. "'"
		)

		if not force then
			YRP_SQL_UPDATE(
				"yrp_players",
				{
					["NormalCharacter"] = cuid
				}, "SteamID = '" .. ply:YRPSteamID() .. "'"
			)
		end

		ply:SetYRPInt("yrp_charid", cuid)
		ply:SetYRPBool("yrp_spawning", true)
		YRPPlayerLoadout(ply)
		ply:SetYRPBool("yrp_characterselection", false)
		timer.Simple(
			0.1,
			function()
				if YRPEntityAlive(ply) then
					ply:Spawn()
				end
			end
		)
	else
		YRP:msg("gm", "No valid character selected ( " .. tostring(char) .. " )")
	end
end

YRP:AddNetworkString("nws_yrp_info3")
function YRPNotiBro(msg)
	if msg then
		net.Start("nws_yrp_info3")
		net.WriteString(msg)
		net.Broadcast()
	end
end

YRP:AddNetworkString("nws_yrp_event_start")
net.Receive(
	"nws_yrp_event_start",
	function(len, ply)
		local euid = net.ReadString()
		local tab = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. euid .. "'")
		if IsNotNilAndNotFalse(tab) then
			tab = tab[1]
			SetGlobalYRPBool("yrp_event_running", true)
			local chars = string.Explode(";", tab.string_chars)
			for i, charstring in pairs(chars) do
				local chartab = string.Explode(",", charstring)
				for n, p in pairs(player.GetAll()) do
					if p:YRPSteamID() == chartab[1] then
						p:KillSilent()
						YRPSpawnAsCharacter(p, chartab[2], true)
					end
				end
			end

			tab.string_eventname = tab.string_eventname or "NO EVENT NAME"
			YRPNotiBro("Event started! ( " .. tostring(tab.string_eventname) .. " )")
		end
	end
)

YRP:AddNetworkString("nws_yrp_event_end")
net.Receive(
	"nws_yrp_event_end",
	function(len, ply)
		local euid = net.ReadString()
		local tab = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. euid .. "'")
		if IsNotNilAndNotFalse(tab) then
			tab = tab[1]
			SetGlobalYRPBool("yrp_event_running", false)
			local chars = string.Explode(";", tab.string_chars)
			for i, charstring in pairs(chars) do
				local chartab = string.Explode(",", charstring)
				for n, p in pairs(player.GetAll()) do
					if p:YRPSteamID() == chartab[1] then
						p:KillSilent()
						local plytab = p:GetPlyTab()
						if plytab then
							YRPSpawnAsCharacter(p, plytab.NormalCharacter)
						end
					end
				end
			end

			tab.string_eventname = tab.string_eventname or "NO EVENT NAME"
			YRPNotiBro("Event ended! ( " .. tab.string_eventname .. " )")
		end
	end
)
