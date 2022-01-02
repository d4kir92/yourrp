--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

util.AddNetworkString( "yrp_drop_table" )
net.Receive( "yrp_drop_table", function(len, ply)
	local tab = net.ReadString()
	YRP_SQL_DROP_TABLE(tab)
end)

local HANDLER_DATABASE = {}

function RemFromHandler_Database(ply)
	table.RemoveByValue(HANDLER_DATABASE, ply)
end

function AddToHandler_Database(ply)
	if !table.HasValue(HANDLER_DATABASE, ply) then
		table.insert(HANDLER_DATABASE, ply)
	end
end

util.AddNetworkString( "Connect_Settings_Database" )
net.Receive( "Connect_Settings_Database", function(len, ply)
	if ply:CanAccess( "bool_ac_database" ) then
		AddToHandler_Database(ply)

		local tables = sql.Query( "SELECT name FROM sqlite_master WHERE type='table';" )

		local nw_yrp = {}
		local nw_yrp_related = {}
		local nw_other = {}
		for i, tab in pairs(tables) do
			if table.HasValue(GetDBNames(), tab.name) then
				if tab.name != "yrp_sql" then
					table.insert(nw_yrp, tab)
				end
			elseif string.StartWith(tab.name, "yrp_" ) then
				table.insert(nw_yrp_related, tab)
			elseif tab.name != "sqlite_sequence" then
				table.insert(nw_other, tab)
			end
		end

		local nw_sql = sql.Query( "SELECT * FROM yrp_sql WHERE uniqueID = 1;" )
		if wk(nw_sql) then
			nw_sql = nw_sql[1]
		end

		net.Start( "Connect_Settings_Database" )
			net.WriteTable(nw_yrp)
			net.WriteTable(nw_yrp_related)
			net.WriteTable(nw_other)
			net.WriteTable(nw_sql)
		net.Send(ply)
	end
end)

util.AddNetworkString( "Disconnect_Settings_Database" )
net.Receive( "Disconnect_Settings_Database", function(len, ply)
	RemFromHandler_Database(ply)
end)

util.AddNetworkString( "get_sql_info" )

util.AddNetworkString( "yrp_drop_tables" )
net.Receive( "yrp_drop_tables", function(len, ply)
	local _drop_tables = net.ReadTable()
	local _ug = string.lower(ply:GetUserGroup() )
	local _can = YRP_SQL_SELECT( "yrp_usergroups", "bool_ac_database", "string_name = '" .. _ug .. "'" )
	if wk(_can) then
		_can = _can[1]
		CreateBackup()
		if tobool(_can.bool_ac_database) then
			for i, tab in pairs(_drop_tables) do
				YRP_SQL_DROP_TABLE(tab)
			end
			game.ConsoleCommand( "changelevel " .. GetMapNameDB() .. "\n" )
		end
	end
end)

function GetBackupCreateTime()
	local _create = sql.Query( "SELECT int_backup_create FROM yrp_sql WHERE uniqueID = 1;" )
	if wk(_create) then
		_create = tonumber(_create[1].int_backup_create)
		if isnumber(_create) then
			_create = _create * 60 * 60
			return _create
		else
			YRP.msg( "error", "[GetBackupCreateTime] is not a number: " .. tostring(_create) )
			return 60
		end
	else
		YRP.msg( "note", "GetBackupCreateTime FAILED" )
		return 60
	end
end

function CreateYRPBackupsFolder()
	if !file.Exists( "yrp_backups", "DATA" ) then
		file.CreateDir( "yrp_backups" )
		if file.Exists( "yrp_backups", "DATA" ) then
			return true
		else
			YRP.msg( "note", "yrp_backups folder failed to create" )
			return false
		end
	else
		return true
	end
end

function RemoveOldBackups()
	--YRP.msg( "db", "[BACKUP] Remove old ones" )
	if CreateYRPBackupsFolder() then
		local backups = file.Find( "yrp_backups/sv_backup_*.txt", "DATA" )
		local _remove_after = sql.Query( "SELECT int_backup_delete FROM yrp_sql WHERE uniqueID = 1;" )

		if wk(_remove_after) then
			_remove_after = tonumber(_remove_after[1].int_backup_delete)

			for i, fi in pairs( backups) do
				if os.time() - (_remove_after * 60 * 60 * 24) > file.Time( "yrp_backups/" .. fi, "DATA" ) then
					file.Delete( "yrp_backups/" .. fi, "DATA" )
					YRP.msg( "note", "[BACKUP] " .. "Removed: " .. fi)
				end
			end
		else
			MsgC( Color(255, 0, 0), "RemoveOldBackups IS BROKEN (Corrupted sv.db file? Modified Gamemode?)\n" )
		end
	end
end

function CreateBackup()
	YRP.msg( "db", "[BACKUP] Create backup" )
	if CreateYRPBackupsFolder() then
		local _fi = "yrp_backups/" .. "sv" .. "_" .. "backup" .. "_" .. os.time() .. "___" ..  os.date( "%Y_%m_%d___%H_%M_%S", os.time() ) .. ".txt"
		file.Write(_fi, file.Read( "sv.db", "GAME" ) )
		if !file.Exists(_fi, "DATA" ) then
			YRP.msg( "note", "Failed to create" )
		end
	end
end

util.AddNetworkString( "makebackup" )
net.Receive( "makebackup", function(len, ply)
	CreateBackup()
end)
