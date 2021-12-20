--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_players"

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "SteamID", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "SteamName", "TEXT DEFAULT ''" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "CurrentCharacter", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "NormalCharacter", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "Timestamp", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "uptime_total", "INT DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "uptime_current", "INT DEFAULT 0" )

util.AddNetworkString( "setting_players" )
util.AddNetworkString( "YRPOpenCharacterMenu" )
util.AddNetworkString( "setPlayerValues" )
util.AddNetworkString( "setRoleValues" )
util.AddNetworkString( "getPlyList" )
util.AddNetworkString( "getCharakterList" )
util.AddNetworkString( "getrpdescription" )

net.Receive( "setting_players", function(len, ply)
	if ply:CanAccess( "bool_players" ) then
		net.Start( "setting_players" )
		net.Send(ply)
	end
end)

g_db_reseted = false
function save_clients(str)
	--YRP.msg( "db", string.upper( "[Saving all clients] [" .. str .. "]" ) )
	if YRP_SQL_TABLE_EXISTS(DATABASE_NAME) then
		if !g_db_reseted then
			for k, ply in pairs(player.GetAll() ) do

				local steamid = ply:SteamID() or ply:UniqueID()
				local _result = YRP_SQL_UPDATE(DATABASE_NAME, {["Timestamp"] = os.time()}, "SteamID = '" .. steamid .. "'" )

				ply:AddPlayTime(true)
				
				if ply:Alive() and YRP_SQL_TABLE_EXISTS( "yrp_characters" ) then
					local _char_id = ply:CharID()
					if worked(_char_id, "CharID failed @save_clients" ) then
						YRP_SQL_UPDATE( "yrp_characters", {["position"] = tostring(ply:GetPos() )}, "uniqueID = " .. _char_id)
						YRP_SQL_UPDATE( "yrp_characters", {["angle"] = tostring(ply:EyeAngles() )}, "uniqueID = " .. _char_id)
						if worked(ply:GetNW2String( "money", "0" ), "money failed @save_clients" ) and isnumber(tonumber(ply:GetNW2String( "money" ) )) then
							local _mo_result = YRP_SQL_UPDATE( "yrp_characters", {["money"] = ply:GetNW2String( "money", "0" )}, "uniqueID = " .. _char_id)
						end
						if worked(ply:GetNW2String( "moneybank", "0" ), "moneybank failed @save_clients" ) and isnumber(tonumber(ply:GetNW2String( "moneybank" ) )) then
							local _mb_result = YRP_SQL_UPDATE( "yrp_characters", {["moneybank"] = ply:GetNW2String( "moneybank", "0" )}, "uniqueID = " .. _char_id)
						end
						if worked(GetMapNameDB(), "getmap failed @save_clients" ) then
							YRP_SQL_UPDATE( "yrp_characters", {["map"] = GetMapNameDB()}, "uniqueID = " .. _char_id)
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
				--YRP.msg( "db", string.upper(_text) )
			else
				--YRP.msg( "db", string.upper( "=> [No clients on server]" ) )
			end
		else
			YRP.msg( "db", "no saving, because db reset" )
		end
	end

	local pp = {}
	if YRP_SQL_TABLE_EXISTS( "permaprops" ) then
		pp = YRP_SQL_SELECT( "permaprops", "*" )
		if pp then
			YRP_SQL_DELETE_FROM( "permaprops", "content LIKE '%yrp_teleporter%'" )
			YRP_SQL_DELETE_FROM( "permaprops", "content LIKE '%yrp_holo%'" )
		end
	end
end

function updateRoleUses(rid)
	rid = tonumber(rid)
	local _count = 0
	for k, p in pairs(player.GetAll() ) do
		if tonumber(p:GetNW2String( "roleUniqueID" ) ) == rid then
			_count = _count + 1
		end
	end
	YRP_SQL_UPDATE( "yrp_ply_roles", {["int_uses"] = _count}, "uniqueID = '" .. rid .. "'" )
end

local defaultsweps = {}
defaultsweps["yrp_key"] = true
defaultsweps["yrp_unarmed"] = true

function SetRole(ply, rid, force, pmid)
	if (IsVoidCharEnabled() or GetGlobalBool( "bool_character_system", true) == false) and !ply:Alive() then
		--ply:Spawn()
	end

	if true then
		ply:StripWeapons()
		--ply:StripAmmo()

		ply:UserGroupLoadout()

		YRPGiveSpecs(ply)
	end

	-- SWEPS
	local ChaTab = ply:YRPGetCharacterTable()
	local rolTab = YRP_SQL_SELECT( "yrp_ply_roles", "*", "uniqueID = '" .. rid .. "'" )
	if GetGlobalBool( "bool_weapon_system", true) and wk(ChaTab) and wk(rolTab) and tonumber(ChaTab.roleID) != tonumber(rid) then
		rolTab = rolTab[1]

		local tmpSWEPTable = string.Explode( ",", rolTab.string_sweps_onspawn)

		local pr = 0
		local se = 0
		local si = 0
		local ga = 0
		
		local pri = {}
		local sec = {}
		local sid = {}
		local gad = {}

		for k, swep in pairs(tmpSWEPTable) do
			if swep != nil and swep != NULL and swep != "" then
				if ply:Alive() then
					local slots = YRPGetSlotsOfSWEP(swep)
					if slots.slot_primary and pr + 1 <= GetGlobalInt( "yrp_max_slots_primary", 0) then
						pr = pr + 1
						table.insert(pri, swep)
					elseif slots.slot_secondary and se + 1 <= GetGlobalInt( "yrp_max_slots_secondary", 0) then
						se = se + 1
						table.insert(sec, swep)
					elseif slots.slot_sidearm and si + 1 <= GetGlobalInt( "yrp_max_slots_sidearm", 0) then
						si = si + 1
						table.insert(sid, swep)
					elseif slots.slot_gadget and ga + 1 <= GetGlobalInt( "yrp_max_slots_gadget", 0) then
						ga = ga + 1
						table.insert(gad, swep)
					else
						YRP.msg( "note", "SLOTS OF ROLE FULL! ( " .. tostring(rolTab.string_name) .. " )" )
					end
				end
			end
		end

		YRPUpdateCharSlot(ply, "primary", 		pri)
		YRPUpdateCharSlot(ply, "secondary", 	sec)
		YRPUpdateCharSlot(ply, "sidearm", 		sid)
		YRPUpdateCharSlot(ply, "gadget", 		gad)
	end

	if GetGlobalBool( "bool_weapon_system", true) then
		for i, slot in pairs(YRPGetCharSWEPS(ply) ) do
			for x, wep in pairs(slot) do
				if !strEmpty( wep ) then
					ply:Give(wep)
				end
			end
		end
		
		local rolTab = YRP_SQL_SELECT( "yrp_ply_roles", "*", "uniqueID = '" .. rid .. "'" )
		if wk(rolTab) then
			rolTab = rolTab[1]
			local tmpSWEPTable = string.Explode( ",", rolTab.string_sweps_onspawn)
			for k, swep in pairs(tmpSWEPTable) do
				if swep != nil and swep != NULL and swep != "" then
					if ply:Alive() then
						local slots = YRPGetSlotsOfSWEP(swep)
						if slots.slot_no then
							ply:Give(swep)
						end
					end
				end
			end
		end
	elseif wk(rolTab) then
		rolTab = rolTab[1]
		for i, swep in pairs(string.Explode( ",", rolTab.string_sweps) ) do
			ply:Give(swep)
		end
	end

	if canGetRole(ply, rid, false) or force then
		set_role(ply, rid)
		set_role_values(ply, pmid)
	else
		set_role(ply, 1)
		set_role_values(ply)
	end

	ply:SetNW2Bool( "yrpspawnedwithcharacter", true)
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
	local charTab = YRP_SQL_SELECT( "yrp_characters", "*", "text_idcardid = '" .. id .. "'" )
	if wk( charTab) then
		return false
	end
	return true
end

function CreateNewIDCardID( charid, try)
	try = try or 0

	local letters = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}
	local numbers = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}
	local digits = {
		"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
		"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
	}

	local idstructure = GetIDStructure()

	while (string.find(idstructure, "!D" ) ) do
		idstructure = YFAR(idstructure, "!D", table.Random( digits) )
	end

	while (string.find(idstructure, "!L" ) ) do
		idstructure = YFAR(idstructure, "!L", table.Random(letters) )
	end

	while (string.find(idstructure, "!N" ) ) do
		idstructure = YFAR(idstructure, "!N", table.Random(numbers) )
	end

	-- Remove bad symbols
	local result = {}
	for i, v in pairs(string.Explode( "", idstructure) ) do
		if string.byte( v) != 167 and string.byte( v) != 194 then
			table.insert(result, v)
		end
	end
	local idcardid = table.concat(result, "" )

	if IsCardIDUnique(idstructure) then
		YRP_SQL_UPDATE( "yrp_characters", {["text_idcardid"] = idcardid}, "uniqueID = '" .. charid .. "'" )
	elseif try < 32 then
		try = try + 1
		CreateNewIDCardID( charid, try)
	end
end

function RecreateNewIDCardID()
	for i, char in pairs(YRP_SQL_SELECT( "yrp_characters", "*", nil) ) do
		CreateNewIDCardID( char.uniqueID)
	end

	for i, ply in pairs(player.GetAll() ) do
		local char = YRP_SQL_SELECT( "yrp_characters", "*", "uniqueID = '" .. ply:CharID() .. "'" )
		if wk( char) then
			char = char[1]
			ply:SetNW2String( "idcardid", char.text_idcardid)
		end
	end
end

function SetIDCardID(ply)
	local char = ply:YRPGetCharacterTable()
	local idstructure = GetIDStructure()
	if idstructure != char.text_idstructure then
		YRP_SQL_UPDATE( "yrp_characters", {["text_idstructure"] = idstructure}, "uniqueID = '" .. ply:CharID() .. "'" )
		CreateNewIDCardID(ply:CharID() )
	end
	char = ply:YRPGetCharacterTable()
	ply:SetNW2String( "idcardid", char.text_idcardid)
end

function set_role(ply, rid)
	hook.Run( "yrp_get_role_pre", ply, rid)

	local _char_id = ply:CharID()
	if _char_id != nil then
		local old_rid = ply:YRPGetCharacterTable()
		if wk(old_rid) then
			old_rid = old_rid.roleID
			local _result = YRP_SQL_UPDATE( "yrp_characters", {["roleID"] = rid}, "uniqueID = " .. ply:CharID() )
			local _role = YRP_SQL_SELECT( "yrp_ply_roles", "*", "uniqueID = " .. rid)
			local _old_uid = ply:GetNW2String( "roleUniqueID", "1" )
			ply:SetNW2String( "roleUniqueID", rid)

			SetIDCardID(ply)

			if _role != nil then
				_role = tonumber(_role[1].int_groupID)
				if isnumber(_role) then
					local _result2 = YRP_SQL_UPDATE( "yrp_characters", {["groupID"] = _role}, "uniqueID = " .. ply:CharID() )
					ply:SetNW2String( "groupUniqueID", _role)
				else
					YRP.msg( "note", "_role = " .. _role)
				end
			else
				YRP.msg( "note", "_role failed" )
			end
			updateRoleUses(_old_uid)
			updateRoleUses(rid)
			hook.Run( "yrp_get_role_post", ply, rid)
		end
	end
end

function GetFactionTable(uid)
	local group = YRP_SQL_SELECT( "yrp_ply_groups", "*", "uniqueID = '" .. uid .. "'" )
	if wk(group) then
		group = group[1]
		group.int_parentgroup = tonumber(group.int_parentgroup)
		group.uniqueID = tonumber(group.uniqueID)
		if group.int_parentgroup == group.uniqueID then
			local undergroup = YRP_SQL_SELECT( "yrp_ply_groups", "*", "uniqueID = '" .. "0" .. "'" )
			if wk(undergroup) then
				undergroup = undergroup[1]
				return undergroup
			end
		elseif group.int_parentgroup != 0 then
			local undergroup = YRP_SQL_SELECT( "yrp_ply_groups", "*", "uniqueID = '" .. group.int_parentgroup .. "'" )
			if wk(undergroup) then
				undergroup = undergroup[1]
				return GetFactionTable(undergroup.uniqueID)
			end
		end
		return group
	end
	local undergroup = YRP_SQL_SELECT( "yrp_ply_groups", "*", "uniqueID = '" .. "0" .. "'" )
	if wk(undergroup) then
		undergroup = undergroup[1]
		return undergroup
	end
	return {}
end

function set_role_values(ply, pmid)
	hitquit(ply)
	if yrp_db_loaded() then
		local rolTab = ply:YRPGetRoleTable()
		local groTab = ply:YRPGetGroupTable()
		local ChaTab = ply:YRPGetCharacterTable()

		if worked(rolTab, "set_role_values rolTab" ) and worked(ChaTab, "set_role_values ChaTab" ) then
			if ChaTab.storage != nil then
				local _storage = string.Explode( ",", ChaTab.storage)
				YRP.msg( "debug", "[set_role_values] " .. ply:YRPName() .. " give permanent Licenses" )
				for i, lic in pairs(_storage) do
					local _lic = YRP_SQL_SELECT( "yrp_shop_items", "*", "type = 'licenses' AND uniqueID = '" .. lic .. "'" )
					if _lic != nil and _lic != false then
						_lic = _lic[1]
						ply:AddLicense(_lic.ClassName)
					end
				end
			end
			if ChaTab.playermodelID != nil then
				pmid = tonumber(pmid) or tonumber( ChaTab.playermodelID )
				local pms =  GetPMsOfCharacter( ply, rolTab.uniqueID )
				if pms[pmid] == nil then
					pmid = 1
				end
				local pm = pms[pmid]
				if wk(pm) and pm.string_model then
					ply:SetNW2String( "string_playermodel", pm.string_model)
					ply:SetModel(pm.string_model)

					local randsize = math.Rand(pm.float_size_min, pm.float_size_max)
					ply:SetModelScale(randsize, 0)
				end
			end
		else
			YRP.msg( "note", "[SET ROLE VALUES] No role or/and no character -> Suicide" )
			ply:KillSilent()
		end

		--[RE]--check_inv(ply, ply:CharID() )

		if worked(rolTab, "set_role_values rolTab" ) then
			ply:SetNW2String( "roleIcon", rolTab.string_icon)
			ply:SetNW2String( "roleColor", rolTab.string_color)
			ply:SetNW2Int( "speedwalk", rolTab.int_speedwalk)
			ply:SetNW2Int( "speedrun", rolTab.int_speedrun)
			ply:SetWalkSpeed(ply:GetNW2Int( "speedwalk" ) )
			ply:SetRunSpeed(ply:GetNW2Int( "speedrun" ) )

			ply:SetMaxHealth(tonumber(rolTab.int_hpmax) )
			ply:SetHealth(tonumber(rolTab.int_hp) )
			ply:SetNW2Int( "HealthReg", tonumber(rolTab.int_hpup) )

			ply:SetNW2Int( "MaxArmor", tonumber(rolTab.int_armax) )
			ply:SetNW2Int( "ArmorReg", tonumber(rolTab.int_arup) )
			ply:SetArmor(tonumber(rolTab.int_ar) )

			ply:SetNW2Float( "GetMaxStamina", tonumber(rolTab.int_stmax) )
			ply:SetNW2Float( "GetCurStamina", tonumber(rolTab.int_st) )
			ply:SetNW2Float( "staminup", tonumber(rolTab.float_stup) )
			ply:SetNW2Float( "stamindown", tonumber(rolTab.float_stdn) )

			local abtype = rolTab.string_ability
			ply:SetNW2String( "GetAbilityType", abtype)
			if abtype == "none" then
				ply:SetNW2Int( "GetMaxAbility", 1)
				ply:SetNW2Int( "GetCurAbility", 0)
				ply:SetNW2Float( "GetRegAbility", 0)
				ply:SetNW2Float( "GetRegTick", 0)
			elseif abtype == "rage" then
				ply:SetNW2Int( "GetMaxAbility", 100)
				ply:SetNW2Int( "GetCurAbility", 0)
				ply:SetNW2Float( "GetRegAbility", 0)
				ply:SetNW2Float( "GetRegTick", 0)
			elseif abtype == "mana" then
				ply:SetNW2Int( "GetMaxAbility", 100)
				ply:SetNW2Int( "GetCurAbility", 0)
				ply:SetNW2Float( "GetRegAbility", 0.4)
				ply:SetNW2Float( "GetRegTick", 1)
			elseif abtype == "energy" then
				ply:SetNW2Int( "GetMaxAbility", 100)
				ply:SetNW2Int( "GetCurAbility", 0)
				ply:SetNW2Float( "GetRegAbility", 1)
				ply:SetNW2Float( "GetRegTick", 0.1)
			elseif abtype == "force" then
				ply:SetNW2Int( "GetMaxAbility", 100)
				ply:SetNW2Int( "GetCurAbility", 0)
				ply:SetNW2Float( "GetRegAbility", 1)
				ply:SetNW2Float( "GetRegTick", 0.1)
			end

			ply:SetJumpPower(tonumber(rolTab.int_powerjump) ) -- * rolTab.playermodelsize)
			ply:SetNW2String( "salary", rolTab.int_salary)
			ply:SetNW2String( "roleName", rolTab.string_name)
			
			ply.DarkRPVars = ply.DarkRPVars or {}
			ply.DarkRPVars.job = rolTab.string_name

			ply:SetNW2Bool( "isInstructor", tobool(rolTab.bool_instructor) )
			ply:SetNW2String( "roleDescription", rolTab.string_description)

			ply:SetNW2Bool( "isVoteable", tobool(rolTab.bool_voteable) )

			ply:SetNW2Int( "salarytime", rolTab.int_salarytime)
			ply:SetNW2Int( "nextsalarytime", CurTime() + rolTab.int_salarytime)

			ply:SetNW2Bool( "bool_hunger", tobool(rolTab.bool_hunger) )
			ply:SetNW2Bool( "bool_thirst", tobool(rolTab.bool_thirst) )
			ply:SetNW2Bool( "bool_stamina", tobool(rolTab.bool_stamina) )

			ply:SetNW2Bool( "bool_canbeagent", tobool(rolTab.bool_canbeagent) )
			ply:SetNW2Bool( "isadminonly", tobool(rolTab.bool_adminonly) )

			--ply:SetNW2Int( "int_role_cooldown", tonumber(rolTab.int_cooldown) )
			ply:SetNW2String( "int_roleondeath", rolTab.int_roleondeath)

			ply:SetNW2Int( "int_securitylevel", rolTab.int_securitylevel)

			ply:SetNW2Int( "int_namelength", rolTab.int_namelength)

			ply:SetNW2String( "string_hud", rolTab.string_hud)
			ply:SetNW2String( "string_hud_mask", rolTab.string_hud_mask)

			local _licenseIDs = string.Explode( ",", rolTab.string_licenses)
			for i, lic in pairs(_licenseIDs) do
				if tonumber(lic) != nil then
					ply:AddLicense(lic)
				end
			end

			ply:SetNW2String( "maxamount", rolTab.int_maxamount)

			ply:SetNW2String( "sweps", rolTab.string_sweps)
			ply:SetNW2String( "sweps_onspawn", rolTab.string_sweps_onspawn)

			-- ammos
			local tammos = rolTab.string_ammos or ""
			tammos = string.Explode( ";", tammos)
			local ammos = {}
			for i, v in pairs(tammos) do
				local t = string.Split( v, ":" )
				ammos[t[1]] = t[2]
			end
			for name, amount in pairs( ammos) do
				local ammo = ply:GetAmmoCount(name)
				ply:SetAmmo( ammo + amount, name)
			end

			--custom flags
			local allflags = YRP_SQL_SELECT( "yrp_flags", "*", nil)
			for i, flag in pairs( allflags) do
				ply:SetNW2Bool( "bool_" .. flag.string_name, false)
			end

			local customflags = string.Explode( ",", rolTab.string_customflags)
			for i, flag in pairs( customflags) do
				if wk(flag) then
					local fl = YRP_SQL_SELECT( "yrp_flags", "*", "uniqueID = '" .. flag .. "'" )
					if wk(fl) then
						fl = fl[1]
						ply:SetNW2Bool( "bool_" .. fl.string_name, true)
					end
				end
			end

			ply:SetNW2Float( "float_dmgtype_burn", tonumber(rolTab.float_dmgtype_burn) )
			ply:SetNW2Float( "float_dmgtype_bullet", tonumber(rolTab.float_dmgtype_bullet) )
			ply:SetNW2Float( "float_dmgtype_energybeam", tonumber(rolTab.float_dmgtype_energybeam) )

			-- Darkrp Team
			ply:SetTeam(rolTab.uniqueID) -- disables damage against npcs
		else
			YRP.msg( "note", "[SET ROLE VALUES] No role selected -> Suicide" )
			ply:KillSilent()
		end

		if wk(groTab) then
			ply:SetNW2String( "groupName", groTab.string_name)
			ply:SetNW2String( "groupUniqueID", groTab.uniqueID)
			ply:SetNW2String( "groupColor", groTab.string_color)
			ply:SetNW2String( "groupIcon", groTab.string_icon)

			if GetGlobalBool( "bool_team_color", true) then
				timer.Simple(0.12, function()
					if IsValid(ply) then
						ply:SetPlayerColor( StringToPlayerVector( groTab.string_color) )
					end
				end)
			end

			ply:SetNW2Bool( "groupiscp", tobool(groTab.bool_iscp) )

			local faction = GetFactionTable(groTab.uniqueID)
			ply:SetNW2String( "factionName", faction.string_name )
			ply:SetNW2String( "factionUniqueID", faction.uniqueID)
			ply:SetNW2String( "factionColor", faction.string_color )

			ply:SetNW2String( "sweps_group", groTab.string_sweps)

			--sweps
			local tmpSWEPTable = string.Explode( ",", groTab.string_sweps)
			for k, swep in pairs(tmpSWEPTable) do
				if swep != nil and swep != NULL and swep != "" then
					if ply:Alive() then
						ply:Give(swep)
					end
				end
			end

			-- ammos
			local tammos = groTab.string_ammos or ""
			tammos = string.Explode( ";", tammos)
			local ammos = {}
			for i, v in pairs(tammos) do
				local t = string.Split( v, ":" )
				ammos[t[1]] = t[2]
			end
			for name, amount in pairs( ammos) do
				local ammo = ply:GetAmmoCount(name)
				ply:SetAmmo( ammo + amount, name)
			end
		else
			YRP.msg( "note", "[SET ROLE VALUES] No group selected -> Suicide" )
			ply:KillSilent()
		end

		ply:SetNW2Bool( "loaded", true)
	end
end

function set_ply_pos(ply, map, pos, ang)
	timer.Simple(0.1, function()
		if map == GetMapNameDB() then
			local tmpPos = string.Split(pos, " " )
			ply:SetPos( Vector(tonumber(tmpPos[1]), tonumber(tmpPos[2]), tonumber(tmpPos[3]) ))

			local tmpAng = string.Split( ang, " " )
			ply:SetEyeAngles(Angle(tonumber(tmpAng[1]), tonumber(tmpAng[2]), tonumber(tmpAng[3]) ))
		else
			YRP.msg( "db", "[" .. ply:SteamName() .. "] is new on this map." )
		end
	end)
end

function YRPOpenCharacterSelection(ply)
	if IsValid(ply) and ply:IsPlayer() and ply:IsFullyAuthenticated() then
		--YRP.msg( "db", "[" .. ply:SteamName() .. "] -> open character selection." )
		local steamid = ply:SteamID() or ply:UniqueID()

		net.Start( "YRPOpenCharacterMenu" )
		net.Send(ply)
	else
		timer.Simple(0.001, function()
			YRPOpenCharacterSelection(ply)
		end)
	end
end

function add_yrp_player(ply, steamid)
	YRP.msg( "db", "[" .. ply:SteamName() .. "] -> Add player to database." )

	steamid = steamid or ply:SteamID() or ply:UniqueID()

	ply:KillSilent()

	if steamid != nil and steamid != false then
		local _SteamName = tostring(ply:SteamName() )
		local _ostime = os.time()

		local cols = "SteamID, "
		cols = cols .. "SteamName, "
		cols = cols .. "Timestamp"

		local vals = "'" .. steamid .. "', "
		vals = vals .. "" .. YRP_SQL_STR_IN( _SteamName ) .. ", "
		vals = vals .. "'" .. _ostime .. "'"

		local _insert = YRP_SQL_INSERT_INTO( "yrp_players", cols, vals)
		if _insert == nil then
			YRP.msg( "db", "[" .. ply:SteamName() .. "] -> Successfully added player to database." )

			ply:SetServerKeybinds()
		else
			YRP.msg( "error", "add_yrp_player failed! _insert: " .. tostring(_insert) )
		end
	end
end

function check_yrp_player(ply, steamid)
	--YRP.msg( "db", "[" .. ply:SteamName() .. "] -> Checking if player is in database." )

	steamid = steamid or ply:SteamID() or ply:UniqueID()

	if steamid != nil and steamid != false or game.SinglePlayer() then
		local _result = YRP_SQL_SELECT( "yrp_players", "*", "SteamID = '" .. steamid .. "'" )

		if _result == nil then
			add_yrp_player(ply, steamid)
		elseif wk(_result) then
			--YRP.msg( "db", "[" .. ply:SteamName() .. "] is in database." )
			if #_result > 1 then
				YRP.msg( "db", "[" .. ply:SteamName() .. "] is more then 1 time in database ( " .. #_result .. " )" )
				for k, v in pairs(_result) do
					if k > 1 then
						YRP.msg( "db", "[" .. ply:SteamName() .. "] delete other entry." )
						YRP_SQL_DELETE_FROM( "yrp_players", "uniqueID = " .. v.uniqueID)
					end
				end
			end
		else
			YRP.msg( "note", "[check_yrp_player] FAILED ( " .. tostring(_result) .. " )" )
		end
	else
		YRP.msg( "error", "SteamID FAILED [" .. tostring(steamid) .. "]" )
		timer.Simple(1, function()
			YRP.msg( "db", "[" .. ply:SteamName() .. "] -> Retry check." )
			check_yrp_player(ply, steamid)
		end)
	end
end

function check_yrp_client(ply, steamid)
	--YRP.msg( "db", "[" .. ply:SteamName() .. "] -> Check client ( " .. ply:SteamID() .. " )" )

	check_yrp_player(ply, steamid)

	save_clients( "check_yrp_client" )
end

net.Receive( "getCharakterList", function(len, ply)
	local _character_table = ply:YRPGetCharacterTable()
	if wk(_character_table) then
		_character_table.rpname = _character_table.rpname
		_character_table.rpdescription = _character_table.rpdescription
		net.Start( "getCharakterList" )
			net.WriteTable(_character_table)
		net.Send(ply)
	else
		YRP.msg( "note", "[getCharakterList] Character Table from " .. ply:YRPName() .. " is broken." )
	end
end)

util.AddNetworkString( "give_getGroTab" )

net.Receive( "give_getGroTab", function(len, ply)
	local _tmpGroupList = YRP_SQL_SELECT( "yrp_ply_groups", "*", nil)
	if _tmpGroupList != nil then
		net.Start( "give_getGroTab" )
			net.WriteTable(_tmpGroupList)
		net.Send(ply)
	else
		YRP.msg( "note", "give_getGroTab: _tmpGroupList failed!" )
	end
end)

util.AddNetworkString( "give_getRolTab" )

net.Receive( "give_getRolTab", function(len, ply)
	local _groupID = net.ReadString()
	local _tmpRolTab = YRP_SQL_SELECT( "yrp_ply_roles", "*", "int_groupID = " .. tonumber(_groupID) )
	if _tmpRolTab != nil then
		net.Start( "give_getRolTab" )
			net.WriteTable(_tmpRolTab)
		net.Send(ply)
	else
		YRP.msg( "note", "give_getRolTab: _tmpRolTab failed!" )
	end
end)

net.Receive( "getPlyList", function(len, ply)
	local _tmpChaList = YRP_SQL_SELECT( "yrp_characters", "*", nil)
	local _tmpRoleList = YRP_SQL_SELECT( "yrp_ply_roles", "*", nil)
	local _tmpGroupList = YRP_SQL_SELECT( "yrp_ply_groups", "*", nil)
	if _tmpChaList != nil and _tmpRoleList != nil and _tmpGroupList != nil then

		net.Start( "getPlyList" )
			net.WriteTable(_tmpChaList)
			net.WriteTable(_tmpGroupList)
			net.WriteTable(_tmpRoleList)
		net.Send(ply)
	else
		YRP.msg( "note", "getPlyList: _tmpChaList and _tmpRoleList and _tmpGroupList failed!" )
	end
end)

util.AddNetworkString( "giveRole" )

net.Receive( "giveRole", function(len, ply)
	local _tmpSteamID = net.ReadString()
	local uniqueIDRole = net.ReadInt(16)
	for k, _ply in pairs(player.GetAll() ) do
		if IsValid(_ply) and tostring(_ply:SteamID() ) == tostring(_tmpSteamID) then
			YRPRemRolVals(_ply)
			RemGroVals(_ply)
			set_role(_ply, uniqueIDRole)
			set_role_values(_ply)
			YRP.msg( "note", tostring(_ply:Nick() ) .. " is now the role: " .. tostring(uniqueIDRole) )
			return true
		end
	end
end)

util.AddNetworkString( "yrp_whitelist_infoplayer" )
function YRPWhitelistInfoPlayer(ply, msg)
	net.Start( "yrp_whitelist_infoplayer" )
		net.WriteString(msg)
	net.Send(ply)
end

function YRPIsWhitelisted( ply, id )
	local _role = YRP_SQL_SELECT( "yrp_ply_roles", "*", "uniqueID = " .. id)
	if wk(_role) then
		_role = _role[1]
		
		local steamid = ply:SteamID() or ply:UniqueID()
		local _plyAllowedAll = YRP_SQL_SELECT( "yrp_role_whitelist", "*", "SteamID = '" .. steamid .. "'" )
		if worked(_plyAllowedAll, "_plyAllowedAll", true) then
			_plyAllowedAll = _plyAllowedAll[1]
			if _plyAllowedAll.roleID == "-1" and _plyAllowedAll.groupID == "-1" then
				YRP.msg( "gm", "[YRPIsWhitelisted]" .. ply:RPName() .. " is ALL whitelisted" )
				return true
			end
		end
		
		local _group = YRP_SQL_SELECT( "yrp_ply_groups", "*", "uniqueID = " .. _role.int_groupID )
		if wk(_group) then
			_group = _group[1]

			local _plyAllowedGroup = YRP_SQL_SELECT( "yrp_role_whitelist", "*", "SteamID = '" .. steamid .. "' AND groupID = " .. _group.uniqueID)
			if tonumber(_group.bool_whitelist) == 1 then
				if wk( _plyAllowedGroup ) then
					YRP.msg( "gm", "[YRPIsWhitelisted]" .. ply:RPName() .. " is group whitelisted." )
					return true
				else
					YRP.msg( "gm", "[YRPIsWhitelisted]" .. ply:RPName() .. " is not group whitelisted." )
					return false
				end
			end
		end

		if tonumber(_role.bool_whitelist) == 1 or tonumber(_role.int_prerole) > 0 then
			local _plyAllowedRole = YRP_SQL_SELECT( "yrp_role_whitelist", "*", "SteamID = '" .. steamid .. "' AND roleID = " .. id)
			if ply:HasAccess() then
				YRP.msg( "gm", "[YRPIsWhitelisted]" .. ply:RPName() .. " has access." )
				return true
			else
				if wk(_plyAllowedRole) then
					YRP.msg( "gm", "[YRPIsWhitelisted]" .. ply:RPName() .. " is role whitelisted." )
					return true
				else
					YRPWhitelistInfoPlayer(ply, "LID_youarenotwhitelisted" )
					YRP.msg( "gm", "[YRPIsWhitelisted]" .. ply:RPName() .. " is not role whitelisted." )
					return false
				end
			end
		else
			return true
		end
	end
	YRPWhitelistInfoPlayer(ply, "ROLE DOESN'T EXISTS ANYMORE" )
	YRP.msg( "gm", "[YRPIsWhitelisted]" .. "ROLE DOESN'T EXISTS ANYMORE" )
	return false
end

util.AddNetworkString( "voteNo" )
net.Receive( "voteNo", function(len, ply)
	ply:SetNW2String( "voteStatus", "no" )
end)

util.AddNetworkString( "voteYes" )
net.Receive( "voteYes", function(len, ply)
	ply:SetNW2String( "voteStatus", "yes" )
end)

local voting = false
local votePly = nil
local voteCount = 30
function startVote(ply, table)
	if !voting then
		voting = true
		for k, v in pairs(player.GetAll() ) do
			v:SetNW2String( "voteStatus", "not voted" )
			v:SetNW2Bool( "voting", true)
			v:SetNW2String( "voteName", ply:RPName() )
			v:SetNW2String( "voteRole", table[1].string_name)
		end
		votePly = ply
		voteCount = 30
		timer.Create( "voteRunning", 1, 0, function()
			for k, v in pairs(player.GetAll() ) do
				v:SetNW2Int( "voteCD", voteCount)
			end
			if voteCount <= 0 then
				voting = false
				local _yes = 0
				local _no = 0
				for k, v in pairs(player.GetAll() ) do
					v:SetNW2Bool( "voting", false)
					if v:GetNW2String( "voteStatus", "not voted" ) == "yes" then
						_yes = _yes + 1
					elseif v:GetNW2String( "voteStatus", "not voted" ) == "no" then
						_no = _no + 1
					end
				end
				if _yes > _no and (_yes + _no) > 1 then
					SetRole( votePly, table[1].uniqueID)
				else
					YRP.msg( "gm", "VOTE: not enough yes" )
				end
				timer.Remove( "voteRunning" )
			end
			voteCount = voteCount - 1
		end)
	else
		YRP.msg( "gm", "a vote is currently running" )
	end
end

function canGetRole(ply, roleID, want)
	if roleID == nil then
		YRP.msg( "note", "[canGetRole] roleID is nil" )
		return
	end

	local tmpTableRole = YRP_SQL_SELECT( "yrp_ply_roles" , "*", "uniqueID = '" .. roleID .. "'" )
	local chatab = ply:YRPGetCharacterTable()

	if wk(tmpTableRole) then
		tmpTableRole = tmpTableRole[1]
		if tonumber(tmpTableRole.int_uses) < tonumber(tmpTableRole.int_maxamount) or tonumber(tmpTableRole.int_maxamount) == 0 or tonumber(tmpTableRole.uniqueID) == ply:GetRoleUID() then
			-- Admin only
			if tonumber(tmpTableRole.bool_adminonly) == 1 then
				if !ply:HasAccess() then
					local text = "ADMIN-ONLY Role: " .. ply:YRPName() .. " is not yourrp - admin."
					YRP.msg( "gm", "[canGetRole] " .. "ADMIN-ONLY Role: " .. ply:YRPName() .. " is not yourrp - admin." )

					YRPNotiToPly(text, ply)
					return false
				else
					return true
				end
			end

			-- Locked
			if tonumber(tmpTableRole.bool_locked) == 1 then
				YRP.msg( "note", "[canGetRole] " .. "locked" )
				return false
			end

			-- level check
			if wk( chatab) then
				if tonumber( chatab.int_level) < tonumber(tmpTableRole.int_requireslevel) then
					local text = ply:YRPName() .. " is not high enough (is: " .. tonumber( chatab.int_level) .. " need: " .. tonumber(tmpTableRole.int_requireslevel) .. " )!"
					YRP.msg( "gm", "[canGetRole] " .. text)
					
					YRPNotiToPly(text, ply)
					return false
				end
			else
				if 1 < tonumber(tmpTableRole.int_requireslevel) then
					local text = ply:YRPName() .. " is not high enough (is: " .. 1 .. " need: " .. tonumber(tmpTableRole.int_requireslevel) .. " )!"
					YRP.msg( "gm", "[canGetRole] " .. text)
					
					YRPNotiToPly(text, ply)
					return false
				end
			end

			if tonumber(ply:GetNW2Int( "ts_role_" .. ply:GetRoleUID(), 0) ) > CurTime() and want then
				local text = ply:YRPName() .. " is on cooldown for this role!"
				YRP.msg( "gm", "[canGetRole] " .. text)
				
				YRPNotiToPly(text, ply)
				return false
			end

			-- Whitelist + Prerole
			if tonumber(tmpTableRole.bool_whitelist) == 1 or tonumber(tmpTableRole.int_prerole) > 0 then
				--YRP.msg( "gm", "[canGetRole] " .. "Whitelist-Role or Prerole-Role" )
				if !YRPIsWhitelisted(ply, roleID) then
					local text = ply:YRPName() .. " is not whitelisted."
					YRP.msg( "gm", "[canGetRole] " .. text)
					
					--YRPNotiToPly(text, ply)
					return false
				end
			end

			-- Usergroups
			local ugs = string.Explode( ",", tmpTableRole.string_usergroups)
			local ug = string.upper(ply:GetUserGroup() )
			local found = table.HasValue(ugs, ug) or table.HasValue(ugs, "ALL" )
			if !found then
				local text = ply:YRPName() .. " is not allowed to use this role (UserGroup)."
				YRP.msg( "gm", "[canGetRole] " .. text)
				
				YRPNotiToPly(text, ply)
				return false
			end
			return true
		else
			local text = ply:YRPName() .. " maxamount reached."
			YRP.msg( "gm", "[canGetRole] " .. text)
			
			YRPNotiToPly(text, ply)
			return false
		end
	end
	YRP.msg( "note", "[canGetRole] " .. "FAILED: " .. tostring(roleID) )
	return false
end

function YRPRemRolVals(ply)
	local rolTab = ply:YRPGetRoleTable()
	if wk(rolTab) then
		local _sweps = string.Explode( ",", rolTab.string_sweps)
		for k, v in pairs(_sweps) do
			if ply:HasWeapon( v ) then
				ply:StripWeapon( v )
			end
		end
	end
end

function RemGroVals(ply)
	local groTab = ply:YRPGetGroupTable()
	if wk(groTab) then
		local _sweps = string.Explode( ",", groTab.string_sweps)
		for k, v in pairs(_sweps) do
			ply:StripWeapon( v)
		end
	end
end

function canVoteRole(ply, roleID)
	local tmpTableRole = YRP_SQL_SELECT( "yrp_ply_roles" , "*", "uniqueID = " .. roleID)

	if worked(tmpTableRole, "tmpTableRole" ) then
		local uses = tonumber(tmpTableRole[1].int_uses)
		local maxamount = tonumber(tmpTableRole[1].int_maxamount)
		if uses < tonumber(player.GetCount() ) * (tonumber(tmpTableRole[1].int_amountpercentage) / 100) and uses < maxamount or maxamount <= 0 then
			if tonumber(tmpTableRole[1].bool_voteable) == 1 then
				return true
			end
		end
	end
	YRP.msg( "note", "[canVoteRole] " .. "not voteable, max reached" )
	return false
end

util.AddNetworkString( "wantRole" )
net.Receive( "wantRole", function(len, ply)
	local uniqueIDRole = net.ReadInt(16)
	local pmid = net.ReadInt(16)

	YRP.msg( "note", ply:YRPName() .. " wants the role " .. uniqueIDRole)

	if canGetRole(ply, uniqueIDRole, true) then
		ply:SetNW2Bool( "switchrole", true)
		--Remove Sweps from old role
		YRPRemRolVals(ply)
		RemGroVals(ply)

		if GetGlobalBool( "bool_players_die_on_role_switch", false) then
			ply:KillSilent()
		end

		--New role
		SetRole(ply, uniqueIDRole, false, pmid)

		if GetGlobalBool( "bool_players_die_on_role_switch", false) then
			ply:Spawn()
			YRPTeleportToSpawnpoint(ply, "switchrole" )
		end
	
		local reusetime = math.Round(CurTime() + ply:GetRoleCooldown(), 0)
		ply:SetNW2Int( "ts_role_" .. ply:GetRoleUID(), reusetime)

		ply:SetNW2Bool( "switchrole", false)
	elseif canVoteRole(ply, uniqueIDRole) then
		local _role = YRP_SQL_SELECT( "yrp_ply_roles" , "*", "uniqueID = " .. uniqueIDRole)
		startVote(ply, _role)
	else
		YRPNotiToPly(text, "not allowed to get this role" )
	end
end)

local Player = FindMetaTable( "Player" )

function Player:SetupCharID()
	local charid = YRP_SQL_SELECT( DATABASE_NAME, "*", "steamid = '" .. self:SteamID() .. "'" )
	
	if charid and charid[1] then
		charid = charid[1].CurrentCharacter
		self:SetNW2Int( "yrp_charid", tonumber( charid ) )
	end
end
