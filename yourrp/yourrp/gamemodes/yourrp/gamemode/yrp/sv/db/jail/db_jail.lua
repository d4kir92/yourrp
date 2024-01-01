--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
local DBNotes = "yrp_jail_notes"
YRP_SQL_ADD_COLUMN(DBNotes, "SteamID", "TEXT DEFAULT ''")
YRP_SQL_ADD_COLUMN(DBNotes, "note", "TEXT DEFAULT ''")
util.AddNetworkString("nws_yrp_getPlayerNotes")
net.Receive(
	"nws_yrp_getPlayerNotes",
	function(len, ply)
		local p = net.ReadEntity()
		if YRPEntityAlive(p) then
			local notes = YRP_SQL_SELECT(DBNotes, "*", "SteamID = '" .. p:YRPSteamID() .. "'")
			if not IsNotNilAndNotFalse(notes) then
				notes = {}
			end

			net.Start("nws_yrp_getPlayerNotes")
			net.WriteTable(notes)
			net.Send(ply)
		end
	end
)

util.AddNetworkString("nws_yrp_addJailNote")
net.Receive(
	"nws_yrp_addJailNote",
	function(len, ply)
		local steamid = net.ReadString()
		local note = net.ReadString()
		YRP_SQL_INSERT_INTO(DBNotes, "note, SteamID", "'" .. note .. "', '" .. steamid .. "'")
	end
)

util.AddNetworkString("nws_yrp_removeJailNote")
net.Receive(
	"nws_yrp_removeJailNote",
	function(len, ply)
		local uid = net.ReadString()
		YRP_SQL_DELETE_FROM(DBNotes, "uniqueID = '" .. uid .. "'")
	end
)

local DATABASE_NAME = "yrp_jail"
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "SteamID", "TEXT DEFAULT ''")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "nick", "TEXT DEFAULT ''")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "reason", "TEXT DEFAULT '-'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "time", "INT DEFAULT 1")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "cell", "INT DEFAULT 1")
function teleportToReleasepoint(ply)
	ply:SetYRPBool("injail", false)
	ply:SetYRPInt("jailtime", 0)
	local _tmpTele = YRP_SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = '" .. "releasepoint" .. "'")
	if IsNotNilAndNotFalse(_tmpTele) then
		ply:Spawn()
		local _tmp = string.Explode(",", _tmpTele[1].position)
		tp_to(ply, Vector(_tmp[1], _tmp[2], _tmp[3]))
		_tmp = string.Explode(",", _tmpTele[1].angle)
		ply:SetEyeAngles(Angle(_tmp[1], _tmp[2], _tmp[3]))
	else
		local _str = YRP.trans("LID_noreleasepoint")
		YRP.msg("note", "[teleportToReleasepoint] " .. _str)
		net.Start("nws_yrp_noti")
		net.WriteString("noreleasepoint")
		net.WriteString("")
		net.Broadcast()
	end
end

function teleportToJailpoint(ply, tim, police)
	if tim ~= nil then
		ply:SetYRPInt("jailtime", tim)
		timer.Simple(
			0.2,
			function()
				ply:SetYRPBool("injail", true)
			end
		)

		-- CELL
		local _tmpTable = YRP_SQL_SELECT("yrp_jail", "*", "SteamID = '" .. ply:YRPSteamID() .. "'")
		local uid = 0
		if IsNotNilAndNotFalse(_tmpTable) then
			uid = _tmpTable[1].cell
		end

		local _tmpCell = YRP_SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "uniqueID = '" .. uid .. "'")
		-- "CELL DELETED"
		local _tmpTele = YRP_SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = '" .. "jailpoint" .. "'")
		-- CELL
		if IsNotNilAndNotFalse(_tmpCell) then
			_tmpCell = _tmpCell[1]
			local _tmp = string.Explode(",", _tmpCell.position)
			local vec = Vector(_tmp[1], _tmp[2], _tmp[3])
			tp_to(ply, vec)
			_tmp = string.Explode(",", _tmpCell.angle)
			ply:SetEyeAngles(Angle(_tmp[1], _tmp[2], _tmp[3]))
		elseif IsNotNilAndNotFalse(_tmpTele) then
			-- CELL DELETED
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
					ply:SetYRPInt("int_arrests", ply:GetYRPInt("int_arrests", 0) + 1)
					YRP_SQL_UPDATE(
						"yrp_characters",
						{
							["int_arrests"] = ply:GetYRPInt("int_arrests", 0)
						}, "uniqueID = '" .. ply:CharID() .. "'"
					)

					if police and police:IsPlayer() then
						YRP_SQL_INSERT_INTO("yrp_logs", "string_timestamp, string_typ, string_target_steamid, string_source_steamid", "'" .. os.time() .. "', 'LID_arrests', '" .. ply:SteamID() .. "', '" .. police:SteamID() .. "'")
					end

					tp_to(ply, vec)
					_tmp = string.Explode(",", v.angle)
					ply:SetEyeAngles(Angle(_tmp[1], _tmp[2], _tmp[3]))
					ply:StripWeapons()
					break -- important
				end
			end
		else
			local _str = YRP.trans("LID_nojailpoint")
			YRP.msg("note", "[teleportToJailpoint] " .. _str)
			net.Start("nws_yrp_noti")
			net.WriteString("nojailpoint")
			net.WriteString("")
			net.Broadcast()
		end
	else
		YRP.msg("note", "[teleportToJailpoint] No Time SET!")
	end
end

function clean_up_jail(ply)
	local _tmpTable = YRP_SQL_SELECT("yrp_jail", "*", "SteamID = '" .. ply:YRPSteamID() .. "'")
	if IsNotNilAndNotFalse(_tmpTable) then
		YRP_SQL_DELETE_FROM("yrp_jail", "SteamID = '" .. ply:YRPSteamID() .. "'")
	end

	teleportToReleasepoint(ply)
end

util.AddNetworkString("nws_yrp_dbAddJail")
net.Receive(
	"nws_yrp_dbAddJail",
	function(len, ply)
		local _tmpDBTable = net.ReadString()
		local _tmpDBCol = net.ReadString()
		local _tmpDBVal = net.ReadString()
		local _SteamID = net.ReadString()
		for i, p in pairs(player.GetAll()) do
			if _SteamID == p:YRPSteamID() then
				if sql.TableExists(_tmpDBTable) then
					YRP_SQL_INSERT_INTO(_tmpDBTable, _tmpDBCol, _tmpDBVal)
					local _tmpTable = YRP_SQL_SELECT("yrp_jail", "*", "SteamID = '" .. _SteamID .. "'")
					YRP.msg("note", p:Nick() .. " added to jail")
					p:SetYRPInt("jailtime", _tmpTable[1].time)
					timer.Simple(
						0.02,
						function()
							p:SetYRPBool("injail", true)
						end
					)
				else
					YRP.msg("error", "dbInsertInto: " .. _tmpDBTable .. " is not existing")
				end

				break
			end
		end
	end
)

util.AddNetworkString("nws_yrp_dbRemJail")
net.Receive(
	"nws_yrp_dbRemJail",
	function(len, ply)
		local _uid = net.ReadString()
		local _SteamID = YRP_SQL_SELECT("yrp_jail", "*", "uniqueID = '" .. _uid .. "'")
		local _res = YRP_SQL_DELETE_FROM("yrp_jail", "uniqueID = " .. _uid)
		if IsNotNilAndNotFalse(_SteamID) then
			_SteamID = _SteamID[1].SteamID
			local _tmpTable = YRP_SQL_SELECT("yrp_jail", "*", "SteamID = '" .. _SteamID .. "'")
			local _in_jailboard = YRP_SQL_SELECT("yrp_jail", "*", "SteamID = '" .. _SteamID .. "'")
			if _in_jailboard ~= nil then
				for k, v in pairs(player.GetAll()) do
					if v:YRPSteamID() == _SteamID then
						v:SetYRPInt("jailtime", _in_jailboard[1].time)
						timer.Simple(
							0.02,
							function()
								v:SetYRPBool("injail", true)
							end
						)
					end
				end
			else
				for k, v in pairs(player.GetAll()) do
					if v:YRPSteamID() == _SteamID then
						v:SetYRPBool("injail", false)
						v:SetYRPInt("jailtime", 0)
					end
				end
			end
		end
	end
)