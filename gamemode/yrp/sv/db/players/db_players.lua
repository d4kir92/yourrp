--Copyright (C) 2017-2018 Arno Zura (https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local _db_name = "yrp_players"

SQL_ADD_COLUMN(_db_name, "SteamID", "TEXT DEFAULT ' '" )
SQL_ADD_COLUMN(_db_name, "SteamID64", "TEXT DEFAULT ' '" )
SQL_ADD_COLUMN(_db_name, "SteamName", "TEXT DEFAULT ' '" )

SQL_ADD_COLUMN(_db_name, "CurrentCharacter", "INT DEFAULT 1" )
SQL_ADD_COLUMN(_db_name, "Timestamp", "INT DEFAULT 1" )
SQL_ADD_COLUMN(_db_name, "uptime_total", "INT DEFAULT 0" )
SQL_ADD_COLUMN(_db_name, "uptime_current", "INT DEFAULT 0" )

--db_drop_table(_db_name )
--db_is_empty(_db_name )

util.AddNetworkString("setting_players" )
net.Receive("setting_players", function(len, ply )
	if ply:CanAccess("players" ) then
		net.Start("setting_players" )
		net.Send(ply )
	end
end)

g_db_reseted = false
function save_clients(string )
	printGM("db", string.upper("[Saving all clients] [" .. string .. "]" ) )
	if !g_db_reseted then
		for k, ply in pairs(player.GetAll() ) do

			local _result = SQL_UPDATE(_db_name, "Timestamp = " .. os.time(), "SteamID = '" .. ply:SteamID() .. "'" )

			if ply:Alive() then
				local _char_id = ply:CharID()
				if worked(_char_id, "CharID failed @save_clients" ) then
					local _ply_pos = "position = '" .. tostring(ply:GetPos() ) .. "'"
					if worked(_ply_pos, "_ply_pos failed @save_clients" ) then
						SQL_UPDATE("yrp_characters", _ply_pos, "uniqueID = " .. _char_id )
					end

					local _ply_ang = "angle = '" .. tostring(ply:EyeAngles() ) .. "'"
					if worked(_ply_ang, "_ply_ang failed @save_clients" ) then
						SQL_UPDATE("yrp_characters", _ply_ang, "uniqueID = " .. _char_id )
					end

					if worked(ply:GetNWString("money" ), "money failed @save_clients" ) and isnumber(tonumber(ply:GetNWString("money" ) ) ) then
						local _money = "money = '" .. ply:GetNWString("money" ) .. "'"
						local _mo_result = SQL_UPDATE("yrp_characters", _money, "uniqueID = " .. _char_id )
					end

					if worked(ply:GetNWString("moneybank" ), "moneybank failed @save_clients" ) and isnumber(tonumber(ply:GetNWString("moneybank" ) ) ) then
						local _moneybank = "moneybank = '" .. ply:GetNWString("moneybank" ) .. "'"
						local _mb_result = SQL_UPDATE("yrp_characters", _moneybank, "uniqueID = " .. _char_id )
					end

					if worked(GetMapNameDB(), "getmap failed @save_clients" ) then
						local _map = "map = '" .. GetMapNameDB() .. "'"
						SQL_UPDATE("yrp_characters", _map, "uniqueID = " .. _char_id )
					end
				end
			end
		end
		local _all_players = player.GetCount() or 0
		if _all_players > 0 then
			local _text = "=> [Saved " .. tostring(_all_players ) .. " client"
			if _all_players > 1 then
				_text = _text .. "s"
			end
			_text = _text .. "]"
			printGM("db", string.upper(_text ) )
		else
			printGM("db", string.upper("=> [No clients on server]" ) )
		end
	else
		printGM("db", "no saving, because db reset" )
	end
end

function updateRoleUses(rid )
	local _count = 0
	for k, p in pairs(player.GetAll() ) do
		if tonumber(p:GetNWInt("roleUniqueID" ) ) == tonumber(rid ) then
			_count = _count + 1
		end
	end
	SQL_UPDATE("yrp_roles", "uses = " .. _count, "uniqueID = " .. rid )
end

function SetRole(ply, rid, force )
	if canGetRole(ply, rid ) or force then
		set_role(ply, rid )
		set_role_values(ply )
	else
		set_role(ply, 1 )
		set_role_values(ply )
	end
end

function set_role(ply, rid )
	ply:SetNWBool("serverdedicated", game.IsDedicated())

	if ply:HasCharacterSelected() then
		local _char_id = ply:CharID()
		if _char_id != nil then
			local _result = SQL_UPDATE("yrp_characters", "roleID = " .. rid, "uniqueID = " .. ply:CharID() )
			local _gid = SQL_SELECT("yrp_roles", "*", "uniqueID = " .. rid )
			local _old_uid = ply:GetNWString("roleUniqueID", "1" )
			ply:SetNWString("roleUniqueID", rid )
			if _gid != nil then
				_gid = _gid[1].groupID
				local _result2 = SQL_UPDATE("yrp_characters", "groupID = " .. _gid, "uniqueID = " .. ply:CharID() )
				ply:SetNWString("groupUniqueID", _gid )
			end
			updateRoleUses(_old_uid )
			updateRoleUses(rid )
		end
	end
end

function GetFactionTable(uid)
	local group = SQL_SELECT("yrp_ply_groups", "*", "uniqueID = '" .. uid .. "'")
	if wk(group) then
		group = group[1]
		local undergroup = SQL_SELECT("yrp_ply_groups", "*", "uniqueID = '" .. group.int_parentgroup .. "'")
		if wk(undergroup) then
			undergroup = undergroup[1]
			return GetFactionTable(undergroup.uniqueID)
		end
		return group
	end
end

function set_role_values(ply )
	if ply:HasCharacterSelected() then
		hitquit(ply )

		if yrp_db_loaded() then
			if IsNoClipTagsEnabled() then
				ply:SetNWBool("show_tags", true )
			end

			local rolTab = ply:GetRolTab()
			local groTab = ply:GetGroTab()
			local ChaTab = ply:GetChaTab()

			ply:SetNWString("licenseIDs", "" )

			if worked(rolTab, "set_role_values rolTab" ) and worked(ChaTab, "set_role_values ChaTab" ) then
				local _storage = string.Explode(",", ChaTab.storage )
				printGM("note", ply:YRPName() .. " Give permanent Licenses" )
				for i, lic in pairs(_storage ) do
					local _lic = SQL_SELECT("yrp_shop_items", "*", "type = 'licenses' AND uniqueID = '" .. lic .. "'" )
					if _lic != nil and _lic != false then
						_lic = _lic[1]
						ply:AddLicense(_lic.ClassName )
					end
				end

				if ChaTab.playermodelID != nil then
					local tmpID = tonumber(ChaTab.playermodelID )
					if rolTab.playermodels != nil and rolTab.playermodels != "" then
						local tmp = combineStringTables(rolTab.playermodels, rolTab.playermodelsnone )
						if worked(tmp[tmpID], "set_role_values playermodel" ) then
							ply:SetModel(tmp[tmpID] )
						end
					end
				end
				ply:SetNWString("Gender", ChaTab.gender )
			else
				printGM("note", "[SET ROLE VALUES] No role or/and no character -> Suicide")
				if !ply:IsBot() then
					ply:KillSilent()
				end
			end

			--[RE]--check_inv(ply, ply:CharID() )

			if worked(rolTab, "set_role_values rolTab" ) then

				ply:SetModelScale(rolTab.playermodelsize, 0 )
				ply:SetNWInt("speedwalk", rolTab.speedwalk*rolTab.playermodelsize )
				ply:SetNWInt("speedrun", rolTab.speedrun*rolTab.playermodelsize )
				ply:SetWalkSpeed(ply:GetNWInt("speedwalk" ) )
				ply:SetRunSpeed(ply:GetNWInt("speedrun" ) )

				ply:SetMaxHealth(tonumber(rolTab.hpmax ) )
				ply:SetHealth(tonumber(rolTab.hp ) )
				ply:SetNWInt("GetHealthReg", tonumber(rolTab.hpreg ) )

				ply:SetNWInt("GetMaxArmor", tonumber(rolTab.armax ) )
				ply:SetNWInt("GetArmorReg", tonumber(rolTab.arreg ) )
				ply:SetArmor(tonumber(rolTab.ar ) )

				ply:SetNWInt("GetMaxStamina", tonumber(rolTab.stmax ) )
				ply:SetNWInt("GetCurStamina", tonumber(rolTab.st ) )
				ply:SetNWInt("staminup", tonumber(rolTab.stregup ) )
				ply:SetNWInt("stamindown", tonumber(rolTab.stregdn ) )

				ply:SetNWInt("GetMaxAbility", tonumber(rolTab.abmax ) )
				ply:SetNWInt("GetRegAbility", tonumber(rolTab.abreg ) )
				ply:SetNWInt("GetCurAbility", tonumber(rolTab.ab ) )

				ply:SetJumpPower(tonumber(rolTab.powerjump ) ) -- * rolTab.playermodelsize )
				ply:SetNWString("salary", rolTab.salary )
				ply:SetNWString("roleName", rolTab.roleID )
				ply:SetNWBool("isInstructor", tobool(rolTab.instructor ) )
				ply:SetNWString("roleDescription", rolTab.description )

				ply:SetNWBool("isVoteable", tobool(rolTab.voteable ) )

				ply:SetNWInt("salarytime", rolTab.salarytime )
				ply:SetNWInt("nextsalarytime", CurTime() + rolTab.salarytime )
				ply:SetNWBool("yrp_voice_global", tobool(rolTab.voiceglobal) )

				ply:SetNWBool("canbeagent", tobool(rolTab.canbeagent ) )
				ply:SetNWBool("iscivil", tobool(rolTab.iscivil ) )
				ply:SetNWBool("isadminonly", tobool(rolTab.adminonly ) )

				local _licenseIDs = string.Explode(",", rolTab.licenseIDs )
				for i, lic in pairs(_licenseIDs ) do
					if tonumber(lic) != nil then
						ply:AddLicense(lic )
					end
				end

				ply:SetNWString("maxamount", rolTab.maxamount )

				ply:SetNWString("sweps", rolTab.sweps )
				ply:SetNWString("playermodels", rolTab.playermodels )
				ply:SetNWString("playermodelsnone", rolTab.playermodelsnone )

				--sweps
				local tmpSWEPTable = string.Explode(",", SQL_STR_OUT(rolTab.sweps ) )
				for k, swep in pairs(tmpSWEPTable ) do
					if swep != nil and swep != NULL and swep != "" then
						ply:Give(swep )
					end
				end
			else
				printGM("note", "[SET ROLE VALUES] No role selected -> Suicide")
				if !ply:IsBot() then
					ply:KillSilent()
				end
			end

			if groTab != nil then
				ply:SetNWString("groupName", groTab.string_name )
				ply:SetNWString("groupUniqueID", groTab.uniqueID )
				ply:SetNWString("groupColor", groTab.string_color )
				ply:SetTeam(tonumber(groTab.uniqueID ) )

				local faction = GetFactionTable(groTab.uniqueID)
				ply:SetNWString("factionName", faction.string_name )
				ply:SetNWString("factionUniqueID", faction.uniqueID )
				ply:SetNWString("factionColor", faction.string_color )
			else
				printGM("note", "[SET ROLE VALUES] No group selected -> Suicide" )
				if !ply:IsBot() then
					ply:KillSilent()
				end
			end
			ply:SetNWBool("loaded", true )
		end
	end
end

function set_ply_pos(ply, map, pos, ang )
	timer.Simple(0.1, function()
		if map == GetMapNameDB() then
			local tmpPos = string.Split(pos, " " )
			ply:SetPos(Vector(tonumber(tmpPos[1] ), tonumber(tmpPos[2] ), tonumber(tmpPos[3] ) ) )

			local tmpAng = string.Split(ang, " " )
			ply:SetEyeAngles(Angle(tonumber(tmpAng[1] ), tonumber(tmpAng[2] ), tonumber(tmpAng[3] ) ) )
		else
			printGM("db", "[" .. ply:SteamName() .. "] is new on this map." )
		end
	end)
end

function open_character_selection(ply )
	if ply:IsFullyAuthenticated() then

			printGM("db", "[" .. ply:SteamName() .. "] -> open character selection." )
			local tmpTable = SQL_SELECT("yrp_characters", "*", "SteamID = '" .. ply:SteamID() .. "'" )
			if tmpTable == nil then
				tmpTable = {}
			end
			net.Start("openCharacterMenu" )
				net.WriteTable(tmpTable )
			net.Send(ply )

	end
end

function add_yrp_player(ply )
	printGM("db", "[" .. ply:SteamName() .. "] -> Add player to database." )

	if !ply:IsBot() then
		ply:KillSilent()
	end

	local _SteamID = ply:SteamID()
	local _SteamID64 = ply:SteamID64() or ""
	local _SteamName = tostring(db_sql_str(ply:SteamName() ) )
	local _ostime = os.time()

	local cols = "SteamID, "
	if !game.SinglePlayer() then
		cols = cols .. "SteamID64, "
	end
	cols = cols .. "SteamName, "
	cols = cols .. "Timestamp"

	local vals = "'" .. _SteamID .. "', "
	if !game.SinglePlayer() then
		vals = vals .. "'" .. _SteamID64 .. "', "
	end
	vals = vals .. "'" .. _SteamName .. "', "
	vals = vals .. "'" .. _ostime .. "'"

	local _insert = SQL_INSERT_INTO("yrp_players", cols, vals )
	if worked(_insert, "inserting new player failed @db_players." ) then
		printGM("db", "[" .. ply:SteamName() .. "] -> Successfully added player to database." )
	end
end

function check_yrp_player(ply )
	printGM("db", "[" .. ply:SteamName() .. "] -> Checking if player is in database." )

	if ply:SteamID64() != nil or game.SinglePlayer() then
		local _result = SQL_SELECT("yrp_players", "*", "SteamID = '" .. ply:SteamID() .. "'")

		if _result == nil then
			add_yrp_player(ply )
		elseif _result != nil then
			printGM("db", "[" .. ply:SteamName() .. "] is in database." )
			if #_result > 1 then
				printGM("db", "[" .. ply:SteamName() .. "] is more then 1 time in database (" .. #_result .. ")" )
				for k, v in pairs(_result ) do
					if k > 1 then
						printGM("db", "[" .. ply:SteamName() .. "] delete other entry." )
						SQL_DELETE_FROM("yrp_players", "uniqueID = " .. v.uniqueID )
					end
				end
			end
		end
	else
		timer.Simple(1, function()
			printGM("db", "[" .. ply:SteamName() .. "] -> Retry check." )
			check_yrp_player(ply )
		end)
	end
end

function check_yrp_client(ply )
	printGM("db", "[" .. ply:SteamName() .. "] -> Check client (" .. ply:SteamID() .. ")" )

	check_yrp_player(ply )

	save_clients("check_yrp_client" )
end

util.AddNetworkString("openCharacterMenu" )
util.AddNetworkString("setPlayerValues" )
util.AddNetworkString("setRoleValues" )

util.AddNetworkString("getPlyList" )

util.AddNetworkString("getCharakterList" )

net.Receive("getCharakterList", function(len, ply )
	local _tmpPlyList = ply:GetChaTab()
	if _tmpPlyList != nil then
		net.Start("getCharakterList" )
			net.WriteTable(_tmpPlyList )
		net.Send(ply )
	end
end)

util.AddNetworkString("give_getGroTab" )

net.Receive("give_getGroTab", function(len, ply )
	local _tmpGroupList = SQL_SELECT("yrp_ply_groups", "*", nil )
	if _tmpGroupList != nil then
		net.Start("give_getGroTab" )
			net.WriteTable(_tmpGroupList )
		net.Send(ply )
	else
		printGM("note", "give_getGroTab: _tmpGroupList failed!" )
	end
end)

util.AddNetworkString("give_getRolTab" )

net.Receive("give_getRolTab", function(len, ply )
	local _groupID = net.ReadString()
	local _tmpRolTab = SQL_SELECT("yrp_roles", "*", "groupID = " .. tonumber(_groupID ) )
	if _tmpRolTab != nil then
		net.Start("give_getRolTab" )
			net.WriteTable(_tmpRolTab )
		net.Send(ply )
	else
		printGM("note", "give_getRolTab: _tmpRolTab failed!" )
	end
end)

net.Receive("getPlyList", function(len, ply )
	local _tmpChaList = SQL_SELECT("yrp_characters", "*", nil )
	local _tmpRoleList = SQL_SELECT("yrp_roles", "*", nil )
	local _tmpGroupList = SQL_SELECT("yrp_ply_groups", "*", nil )
	if _tmpChaList != nil and _tmpRoleList != nil and _tmpGroupList != nil then

		net.Start("getPlyList" )
			net.WriteTable(_tmpChaList )
			net.WriteTable(_tmpGroupList )
			net.WriteTable(_tmpRoleList )
		net.Send(ply )
	else
		printGM("note", "getPlyList: _tmpChaList and _tmpRoleList and _tmpGroupList failed!" )
	end
end)

util.AddNetworkString("giveRole" )

net.Receive("giveRole", function(len, ply )
	local _tmpSteamID = net.ReadString()
	local uniqueIDRole = net.ReadInt(16 )
	for k, _ply in pairs(player.GetAll() ) do
		if tostring(_ply:SteamID() ) == tostring(_tmpSteamID ) then
			RemRolVals(_ply )
			set_role(_ply, uniqueIDRole )
			set_role_values(_ply )
			printGM("note", tostring(_ply:Nick() ) .. " is now the role: " .. tostring(uniqueIDRole ) )
			return true
		end
	end
end)

function isWhitelisted(ply, id )
	local _role = SQL_SELECT("yrp_roles", "*", "uniqueID = " .. id )
	if _role != nil then
		_role = _role[1]

		local _plyAllowedAll = SQL_SELECT("yrp_role_whitelist", "*", "SteamID = '" .. ply:SteamID() .. "'" )
		if worked(_plyAllowedAll, "_plyAllowedAll", true ) then
			_plyAllowedAll = _plyAllowedAll[1]
			if _plyAllowedAll.roleID == "-1" or _plyAllowedAll.groupID == "-1" then
				printGM("gm", ply:RPName() .. " is ALL whitelisted" )
				return true
			end
		end

		local _plyAllowedRole = SQL_SELECT("yrp_role_whitelist", "*", "SteamID = '" .. ply:SteamID() .. "' AND roleID = " .. id )

		local _plyAllowedGroup = SQL_SELECT("yrp_role_whitelist", "*", "SteamID = '" .. ply:SteamID() .. "' AND groupID = " .. _role.groupID .. " AND roleID = -1" )

		if ply:HasAccess() then
			printGM("gm", ply:RPName() .. " has access." )
			return true
		else
			if worked(_plyAllowedRole, "_plyAllowedRole", true ) then
				printGM("gm", ply:RPName() .. " is role whitelisted." )
				return true
			elseif worked(_plyAllowedGroup, "_plyAllowedGroup", true ) then
				printGM("gm", ply:RPName() .. " is group whitelisted." )
				return true
			end
		end
	end
	printGM("gm", ply:RPName() .. " is not whitelisted." )
	return false
end

util.AddNetworkString("voteNo" )
net.Receive("voteNo", function(len, ply )
	ply:SetNWString("voteStatus", "no" )
end)

util.AddNetworkString("voteYes" )
net.Receive("voteYes", function(len, ply )
	ply:SetNWString("voteStatus", "yes" )
end)

local voting = false
local votePly = nil
local voteCount = 30
function startVote(ply, table )
	if !voting then
		voting = true
		for k, v in pairs(player.GetAll() ) do
			v:SetNWString("voteStatus", "not voted" )
			v:SetNWBool("voting", true )
			v:SetNWString("voteName", ply:RPName() )
			v:SetNWString("voteRole", table[1].roleID )
		end
		votePly = ply
		voteCount = 30
		timer.Create("voteRunning", 1, 0, function()
			for k, v in pairs(player.GetAll() ) do
				v:SetNWInt("voteCD", voteCount )
			end
			if voteCount <= 0 then
				voting = false
				local _yes = 0
				local _no = 0
				for k, v in pairs(player.GetAll() ) do
					v:SetNWBool("voting", false )
					if v:GetNWString("voteStatus", "not voted" ) == "yes" then
						_yes = _yes + 1
					elseif v:GetNWString("voteStatus", "not voted" ) == "no" then
						_no = _no + 1
					end
				end
				if _yes > _no and (_yes + _no ) > 1 then
					--setRole(votePly:SteamID(), table[1].uniqueID )
				else
					printGM("note", "VOTE: not enough yes" )
				end
				timer.Remove("voteRunning" )
			end
			voteCount = voteCount - 1
		end)
	else
		printGM("note", "a vote is currently running" )
	end
end

function canGetRole(ply, roleID )
	local tmpTableRole = SQL_SELECT("yrp_roles" , "*", "uniqueID = " .. roleID )

	if worked(tmpTableRole, "tmpTableRole" ) then
		if tonumber(ply:GetNWString("roleUniqueID", "0" ) ) == tonumber(roleID ) then
			return true
		else
			if tonumber(tmpTableRole[1].uses ) < tonumber(tmpTableRole[1].maxamount ) or tonumber(tmpTableRole[1].maxamount ) == -1 then
				if tonumber(tmpTableRole[1].adminonly ) == 1 then
					if ply:HasAccess() then
						-- printGM("note", ply:YRPName() .. " is admin" )
						-- continue
					else
						printGM("gm", "ADMIN-ONLY Role: " .. ply:YRPName() .. " is not admin or superadmin" )
						return false
					end
				elseif tonumber(tmpTableRole[1].whitelist ) == 1 or tonumber(tmpTableRole[1].prerole ) != -1 then
					printGM("gm", "Whitelist-Role or Prerole-Role" )
					if !isWhitelisted(ply, roleID ) then
						printGM("gm", ply:YRPName() .. " is not whitelisted" )
						return false
					else
						-- printGM("gm", ply:SteamName() .. " is whitelisted" )
					end
				end
				return true
			else
				printGM("gm", ply:YRPName() .. " maxamount reached." )
				return false
			end
		end
	end
	return false
end

function RemRolVals(ply )
	local rolTab = ply:GetRolTab()
	if rolTab != nil then
		local _sweps = string.Explode(",", SQL_STR_OUT(rolTab.sweps ) )
		for k, v in pairs(_sweps ) do
			ply:StripWeapon(v )
		end
	end
end

function canVoteRole(ply, roleID )
	local tmpTableRole = SQL_SELECT("yrp_roles" , "*", "uniqueID = " .. roleID )

	if worked(tmpTableRole, "tmpTableRole" ) then
		if tmpTableRole[1].uses < tmpTableRole[1].maxamount or tonumber(tmpTableRole[1].maxamount ) == -1 then
			if tonumber(tmpTableRole[1].voteable ) == 1 then
				return true
			end
		end
	end
	return false
end

net.Receive("wantRole", function(len, ply )
	local uniqueIDRole = net.ReadInt(16 )

	if canGetRole(ply, uniqueIDRole ) then
		--Remove Sweps from old role
		RemRolVals(ply )

		--New role
		SetRole(ply, uniqueIDRole )
	elseif canVoteRole(ply, uniqueIDRole ) then
		local _role = SQL_SELECT("yrp_roles" , "*", "uniqueID = " .. uniqueIDRole )
		startVote(ply, _role )
	else
		net.Start("yrp_info2" )
			net.WriteString("not allowed to get this role" )
		net.Broadcast()
	end
end)
