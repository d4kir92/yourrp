--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DBNotes = "yrp_jail_notes"
SQL_ADD_COLUMN(DBNotes, "SteamID", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DBNotes, "note", "TEXT DEFAULT ''")

util.AddNetworkString("getPlayerNotes")
net.Receive("getPlayerNotes", function(len, ply)
	local p = net.ReadEntity()

	local notes = SQL_SELECT(DBNotes, "*", "SteamID = '" .. p:SteamID() .. "'")

	if !wk(notes) then
		notes = {}
	end
	net.Start("getPlayerNotes")
		net.WriteTable(notes)
	net.Send(ply)
end)

util.AddNetworkString("AddJailNote")
net.Receive("AddJailNote", function(len, ply)
	local steamid = net.ReadString()
	local note = net.ReadString()

	SQL_INSERT_INTO(DBNotes, "note, SteamID", "'" .. note .. "', '" .. steamid .. "'")
end)

util.AddNetworkString("RemoveJailNote")
net.Receive("RemoveJailNote", function(len, ply)
	local uid = net.ReadString()

	SQL_DELETE_FROM(DBNotes, "uniqueID = '" .. uid .. "'")
end)


local _db_name = "yrp_jail"

SQL_ADD_COLUMN(_db_name, "SteamID", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(_db_name, "nick", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(_db_name, "reason", "TEXT DEFAULT '-'")
SQL_ADD_COLUMN(_db_name, "time", "INT DEFAULT 1")
SQL_ADD_COLUMN(_db_name, "cell", "INT DEFAULT 1")

--db_drop_table(_db_name)
--db_is_empty(_db_name)

function teleportToReleasepoint(ply)
	ply:SetDBool("injail", false)
	ply:SetDInt("jailtime", 0)

	local _tmpTele = SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = '" .. "releasepoint" .. "'")

	if wk(_tmpTele) then
		ply:Spawn()
		local _tmp = string.Explode(",", _tmpTele[1].position)
		tp_to(ply, Vector(_tmp[1], _tmp[2], _tmp[3]))
		_tmp = string.Explode(",", _tmpTele[1].angle)
		ply:SetEyeAngles(Angle(_tmp[1], _tmp[2], _tmp[3]))
	else
		local _str = YRP.lang_string("LID_noreleasepoint")
		YRP.msg("note", "[teleportToReleasepoint] " .. _str)

		net.Start("yrp_noti")
			net.WriteString("noreleasepoint")
			net.WriteString("")
		net.Broadcast()
	end
end

function teleportToJailpoint(ply, tim, police)
	if tim != nil then
		ply:SetDInt("jailtime", tim)
		timer.Simple(0.2, function()
			ply:SetDBool("injail", true)
		end)

		-- CELL
		local _tmpTable = SQL_SELECT("yrp_jail", "*", "SteamID = '" .. ply:SteamID() .. "'")
		local uid = 0
		if wk(_tmpTable) then
			uid = _tmpTable[1].cell
		end
		local _tmpCell = SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "uniqueID = '" .. uid .. "'")

		-- "CELL DELETED"
		local _tmpTele = SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = '" .. "jailpoint" .. "'")

		if wk(_tmpCell) then -- CELL
			_tmpCell = _tmpCell[1]

			local _tmp = string.Explode(",", _tmpCell.position)
			local vec = Vector(_tmp[1], _tmp[2], _tmp[3])
			tp_to(ply, vec)

			_tmp = string.Explode(",", _tmpCell.angle)
			ply:SetEyeAngles(Angle(_tmp[1], _tmp[2], _tmp[3]))
		elseif wk(_tmpTele) then -- CELL DELETED
			for i, v in pairs(_tmpTele) do
				local _tmp = string.Explode(",", v.position)
				local vec = Vector(_tmp[1], _tmp[2], _tmp[3])
				local oplys = ents.FindInSphere(vec, 80)
				local empty = true
				for j, p in pairs(oplys) do
					if p:IsPlayer() then
						empty = false
					end
				end
				if empty then
					-- DONE
					ply:SetDInt("int_arrests", ply:GetDInt("int_arrests", 0) + 1)
					SQL_UPDATE("yrp_characters", "int_arrests = '" .. ply:GetDInt("int_arrests", 0) .. "'", "uniqueID = '" .. ply:CharID() .. "'")
					if police and police:IsPlayer() then
						SQL_INSERT_INTO("yrp_logs",	"string_timestamp, string_typ, string_target_steamid, string_source_steamid", "'" .. os.time() .. "', 'LID_arrests', '" .. ply:SteamID64() .. "', '" .. police:SteamID64() .. "'")
					end

					tp_to(ply, vec)
					_tmp = string.Explode(",", v.angle)
					ply:SetEyeAngles(Angle(_tmp[1], _tmp[2], _tmp[3]))

					ply:StripWeapons()
					break -- important
				end
			end
		else
			local _str = YRP.lang_string("LID_nojailpoint")
			YRP.msg("note", "[teleportToJailpoint] " .. _str)

			net.Start("yrp_noti")
				net.WriteString("nojailpoint")
				net.WriteString("")
			net.Broadcast()
		end
	else
		YRP.msg("note", "[teleportToJailpoint] No Time SET!")
	end
end


function clean_up_jail(ply)
	local _tmpTable = SQL_SELECT("yrp_jail", "*", "SteamID = '" .. ply:SteamID() .. "'")
	if wk(_tmpTable) then
		SQL_DELETE_FROM("yrp_jail", "SteamID = '" .. ply:SteamID() .. "'")
	end

	teleportToReleasepoint(ply)
end

util.AddNetworkString("dbAddJail")

net.Receive("dbAddJail", function(len, ply)
	local _tmpDBTable = net.ReadString()
	local _tmpDBCol = net.ReadString()
	local _tmpDBVal = net.ReadString()
	
	local _SteamID = net.ReadString()
	for i, p in pairs(player.GetAll()) do
		if _SteamID == p:SteamID() then
			if sql.TableExists(_tmpDBTable) then
				SQL_INSERT_INTO(_tmpDBTable, _tmpDBCol, _tmpDBVal)

				local _tmpTable = SQL_SELECT("yrp_jail", "*", "SteamID = '" .. _SteamID .. "'")

				YRP.msg("note", p:Nick() .. " added to jail")

				p:SetDInt("jailtime", _tmpTable[1].time)
				timer.Simple(0.02, function()
					p:SetDBool("injail", true)
				end)
			else
				YRP.msg("error", "dbInsertInto: " .. _tmpDBTable .. " is not existing")
			end
			break
		end
	end
end)

util.AddNetworkString("dbRemJail")

net.Receive("dbRemJail", function(len, ply)
	local _uid = net.ReadString()

	local _SteamID = SQL_SELECT("yrp_jail", "*", "uniqueID = '" .. _uid .. "'")

	local _res = SQL_DELETE_FROM("yrp_jail", "uniqueID = " .. _uid)

	if wk(_SteamID) then
		_SteamID = _SteamID[1].SteamID
		local _tmpTable = SQL_SELECT("yrp_jail", "*", "SteamID = '" .. _SteamID .. "'")

		local _in_jailboard = SQL_SELECT("yrp_jail", "*", "SteamID = '" .. _SteamID .. "'")
		if _in_jailboard != nil then
			for k, v in pairs(player.GetAll()) do
				if v:SteamID() == _SteamID then
					v:SetDInt("jailtime", _in_jailboard[1].time)
					timer.Simple(0.02, function()
						v:SetDBool("injail", true)
					end)
				end
			end
		else
			for k, v in pairs(player.GetAll()) do
				if v:SteamID() == _SteamID then
					v:SetDBool("injail", false)
					v:SetDInt("jailtime", 0)
				end
			end
		end
	end
end)
