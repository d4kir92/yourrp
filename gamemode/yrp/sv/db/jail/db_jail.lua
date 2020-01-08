--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

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

	if _tmpTele != nil then
		ply:Spawn()
		local _tmp = string.Explode(",", _tmpTele[1].position)
		tp_to(ply, Vector(_tmp[1], _tmp[2], _tmp[3]))
		_tmp = string.Explode(",", _tmpTele[1].angle)
		ply:SetEyeAngles(Angle(_tmp[1], _tmp[2], _tmp[3]))
	else
		local _str = YRP.lang_string("LID_noreleasepoint")
		printGM("note", "[teleportToReleasepoint] " .. _str)

		net.Start("yrp_noti")
			net.WriteString("noreleasepoint")
			net.WriteString("")
		net.Broadcast()
	end
end

function teleportToJailpoint(ply, tim)
	ply:SetDBool("injail", true)
	if tim != nil then
		local _tmpTele = SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = '" .. "jailpoint" .. "'")

		if wk(_tmpTele) then
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
					ply:SetDInt("int_arrests", ply:GetDTInt("int_arrests", 0))
					SQL_UPDATE("yrp_characters", "int_arrests = '" .. ply:GetDTInt("int_arrests", 0) .. "'", "uniqueID = '" .. ply:CharID() .. "'")

					tp_to(ply, vec)
					_tmp = string.Explode(",", v.angle)
					ply:SetEyeAngles(Angle(_tmp[1], _tmp[2], _tmp[3]))

					ply:StripWeapons()
				end
			end
		else
			local _str = YRP.lang_string("LID_nojailpoint")
			printGM("note", "[teleportToJailpoint] " .. _str)

			net.Start("yrp_noti")
				net.WriteString("nojailpoint")
				net.WriteString("")
			net.Broadcast()
		end
	end
end


function clean_up_jail(ply)
	local _tmpTable = SQL_SELECT("yrp_jail", "*", "SteamID = '" .. ply:SteamID() .. "'")
	if _tmpTable != nil then
		SQL_DELETE_FROM("yrp_jail", "SteamID = '" .. ply:SteamID() .. "'")
	end

	teleportToReleasepoint(ply)
end

util.AddNetworkString("dbAddJail")

net.Receive("dbAddJail", function(len, ply)
	local _tmpDBTable = net.ReadString()
	local _tmpDBCol = net.ReadString()
	local _tmpDBVal = net.ReadString()
	if sql.TableExists(_tmpDBTable) then
		SQL_INSERT_INTO(_tmpDBTable, _tmpDBCol, _tmpDBVal)
	else
		printGM("error", "dbInsertInto: " .. _tmpDBTable .. " is not existing")
	end

	local _SteamID = net.ReadString()
	local _tmpTable = SQL_SELECT("yrp_jail", "*", "SteamID = '" .. _SteamID .. "'")
	for k, v in pairs(player.GetAll()) do
		if v:SteamID() == _SteamID then
			printGM("note", v:Nick() .. " added to jail")
			v:SetDBool("injail", true)
			v:SetDInt("jailtime", _tmpTable[1].time)
		end
	end
end)

util.AddNetworkString("dbRemJail")

net.Receive("dbRemJail", function(len, ply)
	local _uid = net.ReadString()

	local _SteamID = SQL_SELECT("yrp_jail", "*", "uniqueID = '" .. _uid .. "'")

	local _res = SQL_DELETE_FROM("yrp_jail", "uniqueID = " .. _uid)

	_SteamID = _SteamID[1].SteamID

	local _tmpTable = SQL_SELECT("yrp_jail", "*", "SteamID = '" .. _SteamID .. "'")

	local _in_jailboard = SQL_SELECT("yrp_jail", "*", "SteamID = '" .. _SteamID .. "'")
	if _in_jailboard != nil then
		for k, v in pairs(player.GetAll()) do
			if v:SteamID() == _SteamID then
				v:SetDBool("injail", true)
				v:SetDInt("jailtime", _in_jailboard[1].time)
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
end)

local notes = "yrp_jail_notes"
SQL_ADD_COLUMN(_db_name, "SteamID", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(_db_name, "note", "TEXT DEFAULT ''")
