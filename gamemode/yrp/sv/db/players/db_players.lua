--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local _db_name = "yrp_players"

SQL_ADD_COLUMN(_db_name, "SteamID", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(_db_name, "SteamName", "TEXT DEFAULT ' '")

SQL_ADD_COLUMN(_db_name, "CurrentCharacter", "INT DEFAULT 1")
SQL_ADD_COLUMN(_db_name, "Timestamp", "INT DEFAULT 1")
SQL_ADD_COLUMN(_db_name, "uptime_total", "INT DEFAULT 0")
SQL_ADD_COLUMN(_db_name, "uptime_current", "INT DEFAULT 0")

--db_drop_table(_db_name)
--db_is_empty(_db_name)

util.AddNetworkString("setting_players")
net.Receive("setting_players", function(len, ply)
	if ply:CanAccess("bool_players") then
		net.Start("setting_players")
		net.Send(ply)
	end
end)

g_db_reseted = false
function save_clients(str)
	YRP.msg("db", string.upper("[Saving all clients] [" .. str .. "]"))
	if !g_db_reseted then
		for k, ply in pairs(player.GetAll()) do

			local steamid = ply:SteamID() or ply:UniqueID()
			local _result = SQL_UPDATE(_db_name, "Timestamp = " .. os.time(), "SteamID = '" .. steamid .. "'")

			if ply:Alive() then
				local _char_id = ply:CharID()
				if worked(_char_id, "CharID failed @save_clients") then
					local _ply_pos = "position = '" .. tostring(ply:GetPos()) .. "'"
					if worked(_ply_pos, "_ply_pos failed @save_clients") then
						SQL_UPDATE("yrp_characters", _ply_pos, "uniqueID = " .. _char_id)
					end

					local _ply_ang = "angle = '" .. tostring(ply:EyeAngles()) .. "'"
					if worked(_ply_ang, "_ply_ang failed @save_clients") then
						SQL_UPDATE("yrp_characters", _ply_ang, "uniqueID = " .. _char_id)
					end

					if worked(ply:GetDString("money", "0"), "money failed @save_clients") and isnumber(tonumber(ply:GetDString("money"))) then
						local _money = "money = '" .. ply:GetDString("money", "0") .. "'"
						local _mo_result = SQL_UPDATE("yrp_characters", _money, "uniqueID = " .. _char_id)
					end

					if worked(ply:GetDString("moneybank", "0"), "moneybank failed @save_clients") and isnumber(tonumber(ply:GetDString("moneybank"))) then
						local _moneybank = "moneybank = '" .. ply:GetDString("moneybank", "0") .. "'"
						local _mb_result = SQL_UPDATE("yrp_characters", _moneybank, "uniqueID = " .. _char_id)
					end

					if worked(GetMapNameDB(), "getmap failed @save_clients") then
						local _map = "map = '" .. GetMapNameDB() .. "'"
						SQL_UPDATE("yrp_characters", _map, "uniqueID = " .. _char_id)
					end
				end
			end
		end
		local _all_players = player.GetCount() or 0
		if _all_players > 0 then
			local _text = "=> [Saved " .. tostring(_all_players) .. " client"
			if _all_players > 1 then
				_text = _text .. "s"
			end
			_text = _text .. "]"
			YRP.msg("db", string.upper(_text))
		else
			YRP.msg("db", string.upper("=> [No clients on server]"))
		end
	else
		YRP.msg("db", "no saving, because db reset")
	end

	SQL_DELETE_FROM("permaprops", "content LIKE '%yrp_teleporter%'")
	SQL_DELETE_FROM("permaprops", "content LIKE '%yrp_holo%'")
	--local pp = SQL_SELECT("permaprops", "*")
end

function updateRoleUses(rid)
	rid = tonumber(rid)
	local _count = 0
	for k, p in pairs(player.GetAll()) do
		if tonumber(p:GetDString("roleUniqueID")) == rid then
			_count = _count + 1
		end
	end
	SQL_UPDATE("yrp_ply_roles", "int_uses = '" .. _count .. "'", "uniqueID = '" .. rid .. "'")
end

function SetRole(ply, rid, force, pmid)
	if canGetRole(ply, rid, false) or force then
		set_role(ply, rid)
		set_role_values(ply, pmid)
	else
		set_role(ply, 1)
		set_role_values(ply)
	end
	ply:SetDBool("switchrole", false)
end

function GiveRole(ply, rid, force)
	SetRole(ply, rid, force, nil)
end

function YFAR(str, f, r)
	-- Y Find And Replace
	local s, e = string.find(str, f)
	if s then
		local pre = string.sub(str, 0, s - 1)
		local pos = string.sub(str, e + 1)
		str = pre .. r .. pos
		return str
	end
end

function IsCardIDUnique(id)
	local charTab = SQL_SELECT("yrp_characters", "*", "text_idcardid = '" .. id .. "'" )
	if wk(charTab) then
		return false
	end
	return true
end

function CreateNewIDCardID(charid, try)
	try = try or 0

	local letters = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}
	local numbers = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}
	local digits = {
		"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
		"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
	}

	local idstructure = GetIDStructure()

	while (string.find(idstructure, "!D")) do
		idstructure = YFAR(idstructure, "!D", table.Random(digits))
	end

	while (string.find(idstructure, "!L")) do
		idstructure = YFAR(idstructure, "!L", table.Random(letters))
	end

	while (string.find(idstructure, "!N")) do
		idstructure = YFAR(idstructure, "!N", table.Random(numbers))
	end

	-- Remove bad symbols
	local result = {}
	for i, v in pairs(string.Explode("", idstructure)) do
		if string.byte(v) != 167 and string.byte(v) != 194 then
			table.insert(result, v)
		end
	end
	local idcardid = table.concat(result, "")

	if IsCardIDUnique(idstructure) then
		SQL_UPDATE("yrp_characters", "text_idcardid = '" .. idcardid .. "'", "uniqueID = '" .. charid .. "'")
	elseif try < 32 then
		try = try + 1
		CreateNewIDCardID(charid, try)
	end
end

function RecreateNewIDCardID()
	for i, char in pairs(SQL_SELECT("yrp_characters", "*", nil)) do
		CreateNewIDCardID(char.uniqueID)
	end

	for i, ply in pairs(player.GetAll()) do
		local char = SQL_SELECT("yrp_characters", "*", "uniqueID = '" .. ply:CharID() .. "'")
		if wk(char) then
			char = char[1]
			ply:SetDString("idcardid", char.text_idcardid)
		end
	end
end

function SetIDCardID(ply)
	local char = ply:GetChaTab()
	local idstructure = GetIDStructure()
	if idstructure != char.text_idstructure then
		SQL_UPDATE("yrp_characters", "text_idstructure = '" .. idstructure .. "'", "uniqueID = '" .. ply:CharID() .. "'")
		CreateNewIDCardID(ply:CharID())
	end
	char = ply:GetChaTab()
	ply:SetDString("idcardid", char.text_idcardid)
end

function set_role(ply, rid)
	hook.Run("yrp_get_role_pre", ply, rid)
	ply:SetDBool("serverdedicated", game.IsDedicated())

	local _char_id = ply:CharID()
	if _char_id != nil then
		local old_rid = ply:GetChaTab()
		if wk(old_rid) then
			old_rid = old_rid.roleID
			local _result = SQL_UPDATE("yrp_characters", "roleID = " .. rid, "uniqueID = " .. ply:CharID())
			local _role = SQL_SELECT("yrp_ply_roles", "*", "uniqueID = " .. rid)
			local _old_uid = ply:GetDString("roleUniqueID", "1")
			ply:SetDString("roleUniqueID", rid)

			SetIDCardID(ply)

			if _role != nil then
				_role = tonumber(_role[1].int_groupID)
				if isnumber(_role) then
					local _result2 = SQL_UPDATE("yrp_characters", "groupID = " .. _role, "uniqueID = " .. ply:CharID())
					ply:SetDString("groupUniqueID", _role)
				else
					YRP.msg("note", "_role = " .. _role)
				end
			else
				YRP.msg("note", "_role failed")
			end
			updateRoleUses(_old_uid)
			updateRoleUses(rid)
			hook.Run("yrp_get_role_post", ply, rid)
		end
	end
end

function GetFactionTable(uid)
	local group = SQL_SELECT("yrp_ply_groups", "*", "uniqueID = '" .. uid .. "'")
	if wk(group) then
		group = group[1]
		group.int_parentgroup = tonumber(group.int_parentgroup)
		group.uniqueID = tonumber(group.uniqueID)
		if group.int_parentgroup == group.uniqueID then
			local undergroup = SQL_SELECT("yrp_ply_groups", "*", "uniqueID = '" .. "0" .. "'")
			if wk(undergroup) then
				undergroup = undergroup[1]
				return undergroup
			end
		elseif group.int_parentgroup != 0 then
			local undergroup = SQL_SELECT("yrp_ply_groups", "*", "uniqueID = '" .. group.int_parentgroup .. "'")
			if wk(undergroup) then
				undergroup = undergroup[1]
				return GetFactionTable(undergroup.uniqueID)
			end
		end
		return group
	end
	local undergroup = SQL_SELECT("yrp_ply_groups", "*", "uniqueID = '" .. "0" .. "'")
	if wk(undergroup) then
		undergroup = undergroup[1]
		return undergroup
	end
	return {}
end

function set_role_values(ply, pmid)
	hitquit(ply)
	if yrp_db_loaded() then
		if IsNoClipTagsEnabled() then
			ply:SetDBool("show_tags", true)
		end

		local rolTab = ply:GetRolTab()
		local groTab = ply:GetGroTab()
		local ChaTab = ply:GetChaTab()

		if worked(rolTab, "set_role_values rolTab") and worked(ChaTab, "set_role_values ChaTab") then
			if ChaTab.storage != nil then
				local _storage = string.Explode(",", ChaTab.storage)
				YRP.msg("debug", "[set_role_values] " .. ply:YRPName() .. " give permanent Licenses")
				for i, lic in pairs(_storage) do
					local _lic = SQL_SELECT("yrp_shop_items", "*", "type = 'licenses' AND uniqueID = '" .. lic .. "'")
					if _lic != nil and _lic != false then
						_lic = _lic[1]
						ply:AddLicense(_lic.ClassName)
					end
				end
			end
			if ChaTab.playermodelID != nil then
				pmid = tonumber(pmid) or tonumber(ChaTab.playermodelID)
				local pms = GetPMTableOfRole(rolTab.uniqueID)
				if pms[pmid] == nil then
					pmid = 1
				end
				local pm = pms[pmid]
				if wk(pm) then
					ply:SetDString("string_playermodel", pm.string_model)
					ply:SetModel(pm.string_model)

					local randsize = math.Rand(pm.float_size_min, pm.float_size_max)
					ply:SetModelScale(randsize, 0)
				end
			end
			ply:SetDString("Gender", ChaTab.gender)
		else
			YRP.msg("note", "[SET ROLE VALUES] No role or/and no character -> Suicide")
			ply:KillSilent()
		end

		--[RE]--check_inv(ply, ply:CharID())

		if worked(rolTab, "set_role_values rolTab") then
			ply:SetDString("roleIcon", rolTab.string_icon)
			ply:SetDString("roleColor", rolTab.string_color)
			ply:SetDInt("speedwalk", rolTab.int_speedwalk)
			ply:SetDInt("speedrun", rolTab.int_speedrun)
			ply:SetWalkSpeed(ply:GetDInt("speedwalk"))
			ply:SetRunSpeed(ply:GetDInt("speedrun"))

			ply:SetMaxHealth(tonumber(rolTab.int_hpmax))
			ply:SetHealth(tonumber(rolTab.int_hp))
			ply:SetDInt("HealthReg", tonumber(rolTab.int_hpup))

			ply:SetDInt("MaxArmor", tonumber(rolTab.int_armax))
			ply:SetDInt("ArmorReg", tonumber(rolTab.int_arup))
			ply:SetArmor(tonumber(rolTab.int_ar))

			ply:SetDFloat("GetMaxStamina", tonumber(rolTab.int_stmax))
			ply:SetDFloat("GetCurStamina", tonumber(rolTab.int_st))
			ply:SetDFloat("staminup", tonumber(rolTab.float_stup))
			ply:SetDFloat("stamindown", tonumber(rolTab.float_stdn))

			local abtype = rolTab.string_ability
			ply:SetDString("GetAbilityType", abtype)
			if abtype == "none" then
				ply:SetDInt("GetMaxAbility", 1)
				ply:SetDInt("GetCurAbility", 0)
				ply:SetDFloat("GetRegAbility", 0)
				ply:SetDFloat("GetRegTick", 0)
			elseif abtype == "rage" then
				ply:SetDInt("GetMaxAbility", 100)
				ply:SetDInt("GetCurAbility", 0)
				ply:SetDFloat("GetRegAbility", 0)
				ply:SetDFloat("GetRegTick", 0)
			elseif abtype == "mana" then
				ply:SetDInt("GetMaxAbility", 100)
				ply:SetDInt("GetCurAbility", 0)
				ply:SetDFloat("GetRegAbility", 0.4)
				ply:SetDFloat("GetRegTick", 1)
			elseif abtype == "energy" then
				ply:SetDInt("GetMaxAbility", 100)
				ply:SetDInt("GetCurAbility", 0)
				ply:SetDFloat("GetRegAbility", 1)
				ply:SetDFloat("GetRegTick", 0.1)
			elseif abtype == "force" then
				ply:SetDInt("GetMaxAbility", 100)
				ply:SetDInt("GetCurAbility", 0)
				ply:SetDFloat("GetRegAbility", 1)
				ply:SetDFloat("GetRegTick", 0.1)
			end

			ply:SetJumpPower(tonumber(rolTab.int_powerjump)) -- * rolTab.playermodelsize)
			ply:SetDString("salary", rolTab.int_salary)
			ply:SetDString("roleName", rolTab.string_name)
			ply:SetDBool("isInstructor", tobool(rolTab.bool_instructor))
			ply:SetDString("roleDescription", rolTab.string_description)

			ply:SetDBool("isVoteable", tobool(rolTab.bool_voteable))

			ply:SetDInt("salarytime", rolTab.int_salarytime)
			ply:SetDInt("nextsalarytime", CurTime() + rolTab.int_salarytime)

			ply:SetDBool("bool_hunger", tobool(rolTab.bool_hunger))
			ply:SetDBool("bool_thirst", tobool(rolTab.bool_thirst))
			ply:SetDBool("bool_stamina", tobool(rolTab.bool_stamina))

			ply:SetDBool("bool_canbeagent", tobool(rolTab.bool_canbeagent))
			ply:SetDBool("isadminonly", tobool(rolTab.bool_adminonly))

			--ply:SetDInt("int_role_cooldown", tonumber(rolTab.int_cooldown))
			ply:SetDString("int_roleondeath", rolTab.int_roleondeath)

			ply:SetDInt("int_securitylevel", rolTab.int_securitylevel)

			local _licenseIDs = string.Explode(",", rolTab.string_licenses)
			for i, lic in pairs(_licenseIDs) do
				if tonumber(lic) != nil then
					ply:AddLicense(lic)
				end
			end

			ply:SetDString("maxamount", rolTab.int_maxamount)

			ply:SetDString("sweps", rolTab.string_sweps)

			--sweps
			local tmpSWEPTable = string.Explode(",", SQL_STR_OUT(rolTab.string_sweps))
			for k, swep in pairs(tmpSWEPTable) do
				if swep != nil and swep != NULL and swep != "" then
					if ply:Alive() then
						ply:Give(swep)
					end
				end
			end

			--custom flags
			local allflags = SQL_SELECT("yrp_flags", "*", nil)
			for i, flag in pairs(allflags) do
				ply:SetDBool("bool_" .. flag.string_name, false)
			end

			local customflags = string.Explode(",", rolTab.string_customflags)
			for i, flag in pairs(customflags) do
				if wk(flag) then
					local fl = SQL_SELECT("yrp_flags", "*", "uniqueID = '" .. flag .. "'")
					if wk(fl) then
						fl = fl[1]
						ply:SetDBool("bool_" .. fl.string_name, true)
					end
				end
			end

			ply:SetDFloat("float_dmgtype_burn", tonumber(rolTab.float_dmgtype_burn))
			ply:SetDFloat("float_dmgtype_bullet", tonumber(rolTab.float_dmgtype_bullet))
			ply:SetDFloat("float_dmgtype_energybeam", tonumber(rolTab.float_dmgtype_energybeam))

			-- Darkrp Team
			--ply:SetTeam(rolTab.uniqueID) -- disables damage against npcs
		else
			YRP.msg("note", "[SET ROLE VALUES] No role selected -> Suicide")
			ply:KillSilent()
		end

		if wk(groTab) then
			ply:SetDString("groupName", groTab.string_name)
			ply:SetDString("groupUniqueID", groTab.uniqueID)
			ply:SetDString("groupColor", groTab.string_color)
			ply:SetDString("groupIcon", groTab.string_icon)

			if GetGlobalDBool("bool_team_color", true) then
				ply:SetPlayerColor(StringToVector(groTab.string_color))
			end

			ply:SetDBool("groupiscp", tobool(groTab.bool_iscp))

			local faction = GetFactionTable(groTab.uniqueID)
			ply:SetDString("factionName", faction.string_name)
			ply:SetDString("factionUniqueID", faction.uniqueID)
			ply:SetDString("factionColor", faction.string_color)
		else
			YRP.msg("note", "[SET ROLE VALUES] No group selected -> Suicide")
			ply:KillSilent()
		end
		ply:SetDBool("loaded", true)
	end
end

function set_ply_pos(ply, map, pos, ang)
	timer.Simple(0.1, function()
		if map == GetMapNameDB() then
			local tmpPos = string.Split(pos, " ")
			ply:SetPos(Vector(tonumber(tmpPos[1]), tonumber(tmpPos[2]), tonumber(tmpPos[3])))

			local tmpAng = string.Split(ang, " ")
			ply:SetEyeAngles(Angle(tonumber(tmpAng[1]), tonumber(tmpAng[2]), tonumber(tmpAng[3])))
		else
			YRP.msg("db", "[" .. ply:SteamName() .. "] is new on this map.")
		end
	end)
end

function open_character_selection(ply)
	if IsValid(ply) and ply:IsPlayer() and ply:IsFullyAuthenticated() then
		YRP.msg("db", "[" .. ply:SteamName() .. "] -> open character selection.")
		local steamid = ply:SteamID() or ply:UniqueID()

		net.Start("openCharacterMenu")
		net.Send(ply)
	else
		timer.Simple(1, function()
			open_character_selection(ply)
		end)
	end
end

function add_yrp_player(ply, steamid)
	YRP.msg("db", "[" .. ply:SteamName() .. "] -> Add player to database.")

	steamid = steamid or ply:SteamID() or ply:UniqueID()

	ply:KillSilent()

	if steamid != nil and steamid != false then
		local _SteamName = tostring(SQL_STR_IN(ply:SteamName()))
		local _ostime = os.time()

		local cols = "SteamID, "
		cols = cols .. "SteamName, "
		cols = cols .. "Timestamp"

		local vals = "'" .. steamid .. "', "
		vals = vals .. "'" .. _SteamName .. "', "
		vals = vals .. "'" .. _ostime .. "'"

		local _insert = SQL_INSERT_INTO("yrp_players", cols, vals)
		if _insert == nil then
			YRP.msg("db", "[" .. ply:SteamName() .. "] -> Successfully added player to database.")

			ply:SetServerKeybinds()
		else
			YRP.msg("error", "add_yrp_player failed! _insert: " .. tostring(_insert))
		end
	end
end

function check_yrp_player(ply, steamid)
	YRP.msg("db", "[" .. ply:SteamName() .. "] -> Checking if player is in database.")

	steamid = steamid or ply:SteamID() or ply:UniqueID()

	if steamid != nil and steamid != false or game.SinglePlayer() then
		local _result = SQL_SELECT("yrp_players", "*", "SteamID = '" .. steamid .. "'")

		if _result == nil then
			add_yrp_player(ply, steamid)
		elseif wk(_result) then
			YRP.msg("db", "[" .. ply:SteamName() .. "] is in database.")
			if #_result > 1 then
				YRP.msg("db", "[" .. ply:SteamName() .. "] is more then 1 time in database (" .. #_result .. ")")
				for k, v in pairs(_result) do
					if k > 1 then
						YRP.msg("db", "[" .. ply:SteamName() .. "] delete other entry.")
						SQL_DELETE_FROM("yrp_players", "uniqueID = " .. v.uniqueID)
					end
				end
			end
		else
			YRP.msg("note", "[check_yrp_player] FAILED (" .. tostring(_result) .. ")")
		end
	else
		YRP.msg("error", "SteamID FAILED [" .. tostring(steamid) .. "]")
		timer.Simple(1, function()
			YRP.msg("db", "[" .. ply:SteamName() .. "] -> Retry check.")
			check_yrp_player(ply, steamid)
		end)
	end
end

function check_yrp_client(ply, steamid)
	YRP.msg("db", "[" .. ply:SteamName() .. "] -> Check client (" .. ply:SteamID() .. ")")

	check_yrp_player(ply, steamid)

	save_clients("check_yrp_client")
end

util.AddNetworkString("openCharacterMenu")
util.AddNetworkString("setPlayerValues")
util.AddNetworkString("setRoleValues")

util.AddNetworkString("getPlyList")

util.AddNetworkString("getCharakterList")
util.AddNetworkString("getrpdescription")
net.Receive("getCharakterList", function(len, ply)
	local _character_table = ply:GetChaTab()
	if wk(_character_table) then
		_character_table.rpname = SQL_STR_OUT(_character_table.rpname)
		_character_table.rpdescription = SQL_STR_OUT(_character_table.rpdescription)
		net.Start("getCharakterList")
			net.WriteTable(_character_table)
		net.Send(ply)
	else
		YRP.msg("note", "[getCharakterList] Character Table from " .. ply:YRPName() .. " is broken.")
	end
end)

util.AddNetworkString("give_getGroTab")

net.Receive("give_getGroTab", function(len, ply)
	local _tmpGroupList = SQL_SELECT("yrp_ply_groups", "*", nil)
	if _tmpGroupList != nil then
		net.Start("give_getGroTab")
			net.WriteTable(_tmpGroupList)
		net.Send(ply)
	else
		YRP.msg("note", "give_getGroTab: _tmpGroupList failed!")
	end
end)

util.AddNetworkString("give_getRolTab")

net.Receive("give_getRolTab", function(len, ply)
	local _groupID = net.ReadString()
	local _tmpRolTab = SQL_SELECT("yrp_ply_roles", "*", "int_groupID = " .. tonumber(_groupID))
	if _tmpRolTab != nil then
		net.Start("give_getRolTab")
			net.WriteTable(_tmpRolTab)
		net.Send(ply)
	else
		YRP.msg("note", "give_getRolTab: _tmpRolTab failed!")
	end
end)

net.Receive("getPlyList", function(len, ply)
	local _tmpChaList = SQL_SELECT("yrp_characters", "*", nil)
	local _tmpRoleList = SQL_SELECT("yrp_ply_roles", "*", nil)
	local _tmpGroupList = SQL_SELECT("yrp_ply_groups", "*", nil)
	if _tmpChaList != nil and _tmpRoleList != nil and _tmpGroupList != nil then

		net.Start("getPlyList")
			net.WriteTable(_tmpChaList)
			net.WriteTable(_tmpGroupList)
			net.WriteTable(_tmpRoleList)
		net.Send(ply)
	else
		YRP.msg("note", "getPlyList: _tmpChaList and _tmpRoleList and _tmpGroupList failed!")
	end
end)

util.AddNetworkString("giveRole")

net.Receive("giveRole", function(len, ply)
	local _tmpSteamID = net.ReadString()
	local uniqueIDRole = net.ReadInt(16)
	for k, _ply in pairs(player.GetAll()) do
		if tostring(_ply:SteamID()) == tostring(_tmpSteamID) then
			RemRolVals(_ply)
			set_role(_ply, uniqueIDRole)
			set_role_values(_ply)
			YRP.msg("note", tostring(_ply:Nick()) .. " is now the role: " .. tostring(uniqueIDRole))
			return true
		end
	end
end)

function isWhitelisted(ply, id)
	local _role = SQL_SELECT("yrp_ply_roles", "*", "uniqueID = " .. id)
	if wk(_role) then
		_role = _role[1]

		local steamid = ply:SteamID() or ply:UniqueID()
		local _plyAllowedAll = SQL_SELECT("yrp_role_whitelist", "*", "SteamID = '" .. steamid .. "'")
		if worked(_plyAllowedAll, "_plyAllowedAll", true) then
			_plyAllowedAll = _plyAllowedAll[1]
			if _plyAllowedAll.roleID == "-1" or _plyAllowedAll.groupID == "-1" then
				YRP.msg("gm", ply:RPName() .. " is ALL whitelisted")
				return true
			end
		end

		local _plyAllowedRole = SQL_SELECT("yrp_role_whitelist", "*", "SteamID = '" .. steamid .. "' AND roleID = " .. id)
		local _plyAllowedGroup = SQL_SELECT("yrp_role_whitelist", "*", "SteamID = '" .. steamid .. "' AND groupID = " .. _role.int_groupID .. " AND roleID = -1")
		if ply:HasAccess() then
			YRP.msg("gm", ply:RPName() .. " has access.")
			return true
		else
			if worked(_plyAllowedRole, "_plyAllowedRole", true) then
				YRP.msg("gm", ply:RPName() .. " is role whitelisted.")
				return true
			elseif worked(_plyAllowedGroup, "_plyAllowedGroup", true) then
				YRP.msg("gm", ply:RPName() .. " is group whitelisted.")
				return true
			else
				YRP.msg("gm", ply:RPName() .. " is not role and not group whitelisted.")
				return false
			end
		end
	end
	YRP.msg("gm", ply:RPName() .. " is not whitelisted.")
	return false
end

util.AddNetworkString("voteNo")
net.Receive("voteNo", function(len, ply)
	ply:SetDString("voteStatus", "no")
end)

util.AddNetworkString("voteYes")
net.Receive("voteYes", function(len, ply)
	ply:SetDString("voteStatus", "yes")
end)

local voting = false
local votePly = nil
local voteCount = 30
function startVote(ply, table)
	if !voting then
		voting = true
		for k, v in pairs(player.GetAll()) do
			v:SetDString("voteStatus", "not voted")
			v:SetDBool("voting", true)
			v:SetDString("voteName", ply:RPName())
			v:SetDString("voteRole", table[1].string_name)
		end
		votePly = ply
		voteCount = 30
		timer.Create("voteRunning", 1, 0, function()
			for k, v in pairs(player.GetAll()) do
				v:SetDInt("voteCD", voteCount)
			end
			if voteCount <= 0 then
				voting = false
				local _yes = 0
				local _no = 0
				for k, v in pairs(player.GetAll()) do
					v:SetDBool("voting", false)
					if v:GetDString("voteStatus", "not voted") == "yes" then
						_yes = _yes + 1
					elseif v:GetDString("voteStatus", "not voted") == "no" then
						_no = _no + 1
					end
				end
				if _yes > _no and (_yes + _no) > 1 then
					SetRole(votePly, table[1].uniqueID)
				else
					YRP.msg("gm", "VOTE: not enough yes")
				end
				timer.Remove("voteRunning")
			end
			voteCount = voteCount - 1
		end)
	else
		YRP.msg("gm", "a vote is currently running")
	end
end

function canGetRole(ply, roleID, want)
	local tmpTableRole = SQL_SELECT("yrp_ply_roles" , "*", "uniqueID = '" .. roleID .. "'")
	local chatab = ply:GetChaTab()

	if wk(tmpTableRole) then
		tmpTableRole = tmpTableRole[1]
		if tonumber(tmpTableRole.int_uses) < tonumber(tmpTableRole.int_maxamount) or tonumber(tmpTableRole.int_maxamount) == 0 or tonumber(tmpTableRole.uniqueID) == ply:GetRoleUID() then
			-- Admin only
			if tonumber(tmpTableRole.bool_adminonly) == 1 then
				if !ply:HasAccess() then
					local text = "ADMIN-ONLY Role: " .. ply:YRPName() .. " is not yourrp - admin."
					YRP.msg("gm", "[canGetRole] " .. "ADMIN-ONLY Role: " .. ply:YRPName() .. " is not yourrp - admin.")
					net.Start("yrp_info2")
						net.WriteString(text)
					net.Send(ply)
					return false
				else
					return true
				end
			end

			-- Locked
			if tonumber(tmpTableRole.bool_locked) == 1 then
				YRP.msg("note", "[canGetRole] " .. "locked")
				return false
			end

			-- level check
			if wk(chatab) then
				if tonumber(chatab.int_level) < tonumber(tmpTableRole.int_requireslevel) then
					local text = ply:YRPName() .. " is not high enough (is: " .. tonumber(chatab.int_level) .. " need: " .. tonumber(tmpTableRole.int_requireslevel) .. ")!"
					YRP.msg("gm", "[canGetRole] " .. text)
					net.Start("yrp_info2")
						net.WriteString(text)
					net.Send(ply)
					return false
				end
			else
				if 1 < tonumber(tmpTableRole.int_requireslevel) then
					local text = ply:YRPName() .. " is not high enough (is: " .. 1 .. " need: " .. tonumber(tmpTableRole.int_requireslevel) .. ")!"
					YRP.msg("gm", "[canGetRole] " .. text)
					net.Start("yrp_info2")
						net.WriteString(text)
					net.Send(ply)
					return false
				end
			end

			if tonumber(ply:GetDInt("ts_role_" .. ply:GetRoleUID(), 0)) > CurTime() and want then
				local text = ply:YRPName() .. " is on cooldown for this role!"
				YRP.msg("gm", "[canGetRole] " .. text)
				net.Start("yrp_info2")
					net.WriteString(text)
				net.Send(ply)
				return false
			end

			-- Whitelist + Prerole
			if tonumber(tmpTableRole.bool_whitelist) == 1 or tonumber(tmpTableRole.int_prerole) > 0 then
				YRP.msg("gm", "[canGetRole] " .. "Whitelist-Role or Prerole-Role")
				if !isWhitelisted(ply, roleID) then
					local text = ply:YRPName() .. " is not whitelisted."
					YRP.msg("gm", "[canGetRole] " .. text)
					net.Start("yrp_info2")
						net.WriteString(text)
					net.Send(ply)
					return false
				end
			end

			-- Usergroups
			local ugs = string.Explode(",", tmpTableRole.string_usergroups)
			local ug = string.upper(ply:GetUserGroup())
			local found = table.HasValue(ugs, ug) or table.HasValue(ugs, "ALL")
			if !found then
				local text = ply:YRPName() .. " is not allowed to use this role (UserGroup)."
				YRP.msg("gm", "[canGetRole] " .. text)
				net.Start("yrp_info2")
					net.WriteString(text)
				net.Send(ply)
				return false
			end
			return true
		else
			local text = ply:YRPName() .. " maxamount reached."
			YRP.msg("gm", "[canGetRole] " .. text)
			net.Start("yrp_info2")
				net.WriteString(text)
			net.Send(ply)
			return false
		end
	end
	YRP.msg("note", "[canGetRole] " .. "FAILED: " .. tostring(roleID))
	return false
end

function RemRolVals(ply)
	local rolTab = ply:GetRolTab()
	if wk(rolTab) then
		local _sweps = string.Explode(",", SQL_STR_OUT(rolTab.string_sweps))
		for k, v in pairs(_sweps) do
			ply:StripWeapon(v)
		end
	end
end

function canVoteRole(ply, roleID)
	local tmpTableRole = SQL_SELECT("yrp_ply_roles" , "*", "uniqueID = " .. roleID)

	if worked(tmpTableRole, "tmpTableRole") then
		local uses = tonumber(tmpTableRole[1].int_uses)
		local maxamount = tonumber(tmpTableRole[1].int_maxamount)
		if uses < tonumber(#player.GetAll()) * (tonumber(tmpTableRole[1].int_amountpercentage) / 100) and uses < maxamount or maxamount <= 0 then
			if tonumber(tmpTableRole[1].bool_voteable) == 1 then
				return true
			end
		end
	end
	YRP.msg("note", "[canVoteRole] " .. "not voteable, max reached")
	return false
end

util.AddNetworkString("wantRole")
net.Receive("wantRole", function(len, ply)
	local uniqueIDRole = net.ReadInt(16)
	local pmid = net.ReadInt(16)

	YRP.msg("note", ply:YRPName() .. " wants the role " .. uniqueIDRole)

	if canGetRole(ply, uniqueIDRole, true) then
		ply:SetDBool("switchrole", true)
		--Remove Sweps from old role
		RemRolVals(ply)

		if GetGlobalDBool("bool_players_die_on_role_switch", false) then
			ply:Kill()
		end

		--New role
		SetRole(ply, uniqueIDRole, false, pmid)

		local reusetime = math.Round(CurTime() + ply:GetRoleCooldown(), 0)
		ply:SetDInt("ts_role_" .. ply:GetRoleUID(), reusetime)
	elseif canVoteRole(ply, uniqueIDRole) then
		local _role = SQL_SELECT("yrp_ply_roles" , "*", "uniqueID = " .. uniqueIDRole)
		startVote(ply, _role)
	else
		net.Start("yrp_info2")
			net.WriteString("not allowed to get this role")
		net.Send(ply)
	end
end)
