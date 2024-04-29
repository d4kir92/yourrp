--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
local DATABASE_NAME = "yrp_players"
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "SteamID", "TEXT DEFAULT ''")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "SteamName", "TEXT DEFAULT ''")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "CurrentCharacter", "INT DEFAULT 1")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "NormalCharacter", "INT DEFAULT 1")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "Timestamp", "INT DEFAULT 1")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "uptime_total", "INT DEFAULT 0")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "uptime_current", "INT DEFAULT 0")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "TS_LastOnline", "INT DEFAULT 1")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_chatdelay", "INT DEFAULT 4")
function YRPGetTSLastOnline(steamId)
	local tab = YRP_SQL_SELECT("yrp_players", "*", "SteamID = '" .. steamId .. "'")
	if tab and tab[1] then
		tab = tab[1]

		return tab.TS_LastOnline
	end

	return 1
end

function YRPSetTSLastOnline(steamId)
	if steamId then
		YRP_SQL_UPDATE(
			"yrp_players",
			{
				["TS_LastOnline"] = os.time()
			}, "SteamID = '" .. steamId .. "'"
		)
	end
end

util.AddNetworkString("nws_yrp_chatdelay")
net.Receive(
	"nws_yrp_chatdelay",
	function(len, ply)
		local delay = net.ReadInt(8)
		local steamId = ply:SteamID()
		YRP_SQL_UPDATE(
			"yrp_players",
			{
				["int_chatdelay"] = delay
			}, "SteamID = '" .. steamId .. "'"
		)

		ply:SetYRPInt("int_chatdelay", delay)
	end
)

util.AddNetworkString("nws_yrp_setting_players")
util.AddNetworkString("YRPOpenCharacterMenu")
util.AddNetworkString("nws_yrp_setPlayerValues")
util.AddNetworkString("nws_yrp_setRoleValues")
util.AddNetworkString("nws_yrp_getPlyList")
util.AddNetworkString("nws_yrp_getCharakterList")
util.AddNetworkString("nws_yrp_getrpdescription")
net.Receive(
	"nws_yrp_setting_players",
	function(len, ply)
		if ply:CanAccess("bool_players") then
			net.Start("nws_yrp_setting_players")
			net.Send(ply)
		end
	end
)

g_db_reseted = false
function YRPSaveClients(str)
	--YRP.msg( "db", string.upper( "[Saving all clients] [" .. str .. "]" ) )
	if YRP_SQL_TABLE_EXISTS(DATABASE_NAME) then
		if not g_db_reseted then
			for k, ply in pairs(player.GetAll()) do
				local steamid = ply:YRPSteamID()
				local _result = YRP_SQL_UPDATE(
					DATABASE_NAME,
					{
						["Timestamp"] = os.time()
					}, "SteamID = '" .. steamid .. "'"
				)

				ply:AddPlayTime(true)
				if ply:Alive() and YRP_SQL_TABLE_EXISTS("yrp_characters") then
					local _char_id = ply:CharID()
					if YRPWORKED(_char_id, "CharID failed @YRPSaveClients") then
						YRP_SQL_UPDATE(
							"yrp_characters",
							{
								["position"] = tostring(ply:GetPos())
							}, "uniqueID = " .. _char_id
						)

						YRP_SQL_UPDATE(
							"yrp_characters",
							{
								["angle"] = tostring(ply:EyeAngles())
							}, "uniqueID = " .. _char_id
						)

						if YRPWORKED(ply:GetYRPString("money", "0"), "money failed @YRPSaveClients") and isnumber(tonumber(ply:GetYRPString("money"))) then
							local _mo_result = YRP_SQL_UPDATE(
								"yrp_characters",
								{
									["money"] = ply:GetYRPString("money", "0")
								}, "uniqueID = " .. _char_id
							)
						end

						if YRPWORKED(ply:GetYRPString("moneybank", "0"), "moneybank failed @YRPSaveClients") and isnumber(tonumber(ply:GetYRPString("moneybank"))) then
							local _mb_result = YRP_SQL_UPDATE(
								"yrp_characters",
								{
									["moneybank"] = ply:GetYRPString("moneybank", "0")
								}, "uniqueID = " .. _char_id
							)
						end

						if YRPWORKED(GetMapNameDB(), "getmap failed @YRPSaveClients") then
							YRP_SQL_UPDATE(
								"yrp_characters",
								{
									["map"] = GetMapNameDB()
								}, "uniqueID = " .. _char_id
							)
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
			end
		else
			YRP.msg("db", "no saving, because db reset")
		end
	end

	local pp = {}
	if YRP_SQL_TABLE_EXISTS("permaprops") then
		pp = YRP_SQL_SELECT("permaprops", "*")
		if pp then
			YRP_SQL_DELETE_FROM("permaprops", "content LIKE '%yrp_teleporter%'")
			YRP_SQL_DELETE_FROM("permaprops", "content LIKE '%yrp_holo%'")
		end
	end
end

function YRPUpdateRoleUses(rid)
	rid = tonumber(rid)
	local _count = 0
	for k, p in pairs(player.GetAll()) do
		if tonumber(p:GetYRPString("roleUniqueID")) == rid then
			_count = _count + 1
		end
	end

	YRP_SQL_UPDATE(
		"yrp_ply_roles",
		{
			["int_uses"] = _count
		}, "uniqueID = '" .. rid .. "'"
	)
end

local defaultsweps = {}
defaultsweps["yrp_key"] = true
defaultsweps["yrp_unarmed"] = true
local _hl2Weapons = {}
table.insert(_hl2Weapons, "weapon_357")
table.insert(_hl2Weapons, "weapon_alyxgun")
table.insert(_hl2Weapons, "weapon_annabelle")
table.insert(_hl2Weapons, "weapon_ar2")
table.insert(_hl2Weapons, "weapon_brickbat")
table.insert(_hl2Weapons, "weapon_bugbait")
table.insert(_hl2Weapons, "weapon_crossbow")
table.insert(_hl2Weapons, "weapon_crowbar")
table.insert(_hl2Weapons, "weapon_frag")
table.insert(_hl2Weapons, "weapon_physgun")
table.insert(_hl2Weapons, "weapon_physcannon")
table.insert(_hl2Weapons, "weapon_pistol")
table.insert(_hl2Weapons, "weapon_rpg")
table.insert(_hl2Weapons, "weapon_shotgun")
table.insert(_hl2Weapons, "weapon_smg1")
table.insert(_hl2Weapons, "weapon_striderbuster")
table.insert(_hl2Weapons, "weapon_stunstick")
table.insert(_hl2Weapons, "weapon_slam")
function YRPDoesWeaponExists(cname)
	if list.Get("Weapon")[cname] then
		return true
	elseif weapons.Get(cname) then
		return true
	elseif weapons.GetStored(cname) then
		return true
	elseif scripted_ents.GetStored(cname) then
		return true
	else
		for i, v in pairs(weapons.GetList()) do
			if v.ClassName == cname then return true end
		end

		for i, v in pairs(_hl2Weapons) do
			if v == cname then return true end
		end
	end

	return false
end

function YRPPlayerGive(ply, cname, bNoAmmo)
	if cname == nil then return false end
	if strEmpty(cname) then return false end
	if YRPDoesWeaponExists(cname) == false then return false end
	if YRPEntityAlive(ply) and ply:Alive() and not strEmpty(cname) then
		ply:Give(cname, bNoAmmo or false)

		return true
	end
end

function YRPSetRole(ply, rid, force, pmid, bgs)
	if rid == nil then
		YRP.msg("note", "[YRPSetRole] No roleid")

		return false
	end

	rid = tonumber(rid)
	if rid == nil then
		YRP.msg("note", "[YRPSetRole] rid == nil")

		return false
	end

	ply:StripWeapons()
	ply:UserGroupLoadout()
	YRPGiveSpecs(ply)
	if rid ~= ply:GetRoleUID() then
		YRPUpdateBodyGroups(ply, pmid, bgs)
	end

	-- SWEPS
	local ChaTab = ply:YRPGetCharacterTable()
	local rolTab = YRP_SQL_SELECT("yrp_ply_roles", "*", "uniqueID = '" .. rid .. "'")
	if (GetGlobalYRPBool("bool_weapon_system", true) and IsNotNilAndNotFalse(ChaTab) and IsNotNilAndNotFalse(rolTab)) and (ply:GetYRPBool("yrp_reset_charloadout") or rid ~= ply:GetRoleUID()) then
		rolTab = rolTab[1]
		ply:SetYRPBool("yrp_reset_charloadout", false)
		local tmpSWEPTable = string.Explode(",", rolTab.string_sweps_onspawn)
		local pr = 0
		local se = 0
		local si = 0
		local ga = 0
		local pri = {}
		local sec = {}
		local sid = {}
		local gad = {}
		for k, swep in pairs(tmpSWEPTable) do
			if swep ~= nil and swep ~= NULL and swep ~= "" then
				local slots = YRPGetSlotsOfSWEP(swep)
				if slots.slot_primary and pr + 1 <= GetGlobalYRPInt("yrp_max_slots_primary", 0) then
					pr = pr + 1
					table.insert(pri, swep)
				elseif slots.slot_secondary and se + 1 <= GetGlobalYRPInt("yrp_max_slots_secondary", 0) then
					se = se + 1
					table.insert(sec, swep)
				elseif slots.slot_sidearm and si + 1 <= GetGlobalYRPInt("yrp_max_slots_sidearm", 0) then
					si = si + 1
					table.insert(sid, swep)
				elseif slots.slot_gadget and ga + 1 <= GetGlobalYRPInt("yrp_max_slots_gadget", 0) then
					ga = ga + 1
					table.insert(gad, swep)
				else
					YRP.msg("note", "SLOTS OF ROLE FULL! ( " .. tostring(rolTab.string_name) .. " )")
				end
			end
		end

		YRPUpdateCharSlot(ply, "primary", pri)
		YRPUpdateCharSlot(ply, "secondary", sec)
		YRPUpdateCharSlot(ply, "sidearm", sid)
		YRPUpdateCharSlot(ply, "gadget", gad)
	end

	if GetGlobalYRPBool("bool_weapon_system", true) then
		for i, slot in pairs(YRPGetCharSWEPS(ply)) do
			for x, wep in pairs(slot) do
				if not strEmpty(wep) then
					YRPPlayerGive(ply, wep)
				end
			end
		end

		local rolTab2 = YRP_SQL_SELECT("yrp_ply_roles", "*", "uniqueID = '" .. rid .. "'")
		if IsNotNilAndNotFalse(rolTab2) then
			rolTab2 = rolTab2[1]
			local tmpSWEPTable = string.Explode(",", rolTab2.string_sweps_onspawn)
			for k, swep in pairs(tmpSWEPTable) do
				if swep ~= nil and swep ~= NULL and swep ~= "" and ply:Alive() then
					local slots = YRPGetSlotsOfSWEP(swep)
					if slots.slot_no then
						YRPPlayerGive(ply, swep)
					end
				end
			end
		end
	elseif IsNotNilAndNotFalse(rolTab) then
		rolTab = rolTab[1]
		for i, swep in pairs(string.Explode(",", rolTab.string_sweps)) do
			YRPPlayerGive(ply, swep)
		end
	end

	if canGetRole(ply, rid, false) or force then
		YRPSetRoleData(ply, rid)
		YRPSetRoleValues(ply, pmid)
	else
		YRPSetRoleData(ply, 1)
		YRPSetRoleValues(ply)
	end

	ply:SetYRPBool("yrpspawnedwithcharacter", true)
end

function YRPGiveRole(ply, rid, force)
	YRPSetRole(ply, rid, force, nil)
end

function YFAR(str, f, r)
	-- Y Find And Replace
	local s, e = string.find(str, f, 1, true)
	if s then
		local pre = string.sub(str, 0, s - 1)
		local pos = string.sub(str, e + 1)
		str = pre .. r .. pos

		return str
	end
end

function IsCardIDUnique(id)
	local charTab = YRP_SQL_SELECT("yrp_characters", "*", "text_idcardid = '" .. id .. "'")
	if IsNotNilAndNotFalse(charTab) then return false end

	return true
end

function CreateNewIDCardID(charid, try)
	try = try or 0
	local letters = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}
	local numbers = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}
	local digits = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}
	local idstructure = GetIDStructure()
	while string.find(idstructure, "!D", 1, true) do
		idstructure = YFAR(idstructure, "!D", table.Random(digits))
	end

	while string.find(idstructure, "!L", 1, true) do
		idstructure = YFAR(idstructure, "!L", table.Random(letters))
	end

	while string.find(idstructure, "!N", 1, true) do
		idstructure = YFAR(idstructure, "!N", table.Random(numbers))
	end

	-- Remove bad symbols
	local result = {}
	for i, v in pairs(string.Explode("", idstructure)) do
		if string.byte(v) ~= 167 and string.byte(v) ~= 194 then
			table.insert(result, v)
		end
	end

	local idcardid = table.concat(result, "")
	if IsCardIDUnique(idstructure) then
		YRP_SQL_UPDATE(
			"yrp_characters",
			{
				["text_idcardid"] = idcardid
			}, "uniqueID = '" .. charid .. "'"
		)
	elseif try < 32 then
		try = try + 1
		CreateNewIDCardID(charid, try)
	end
end

function RecreateNewIDCardID()
	for i, char in pairs(YRP_SQL_SELECT("yrp_characters", "*", nil)) do
		CreateNewIDCardID(char.uniqueID)
	end

	for i, ply in pairs(player.GetAll()) do
		local char = YRP_SQL_SELECT("yrp_characters", "*", "uniqueID = '" .. ply:CharID() .. "'")
		if IsNotNilAndNotFalse(char) then
			char = char[1]
			ply:SetYRPString("idcardid", char.text_idcardid)
		end
	end
end

function SetIDCardID(ply)
	local char = ply:YRPGetCharacterTable()
	local idstructure = GetIDStructure()
	if idstructure ~= char.text_idstructure then
		YRP_SQL_UPDATE(
			"yrp_characters",
			{
				["text_idstructure"] = idstructure
			}, "uniqueID = '" .. ply:CharID() .. "'"
		)

		CreateNewIDCardID(ply:CharID())
	end

	char = ply:YRPGetCharacterTable()
	ply:SetYRPString("idcardid", char.text_idcardid)
end

function YRPSetRoleData(ply, rid)
	hook.Run("yrp_get_role_pre", ply, rid)
	local _char_id = ply:CharID()
	if _char_id ~= nil then
		local old_rid = ply:YRPGetCharacterTable()
		if IsNotNilAndNotFalse(old_rid) then
			old_rid = old_rid.roleID
			local _result = YRP_SQL_UPDATE(
				"yrp_characters",
				{
					["roleID"] = rid
				}, "uniqueID = " .. ply:CharID()
			)

			local gid = YRP_SQL_SELECT("yrp_ply_roles", "*", "uniqueID = " .. rid)
			local _old_uid = ply:GetYRPString("roleUniqueID", "1")
			ply:SetYRPString("roleUniqueID", rid)
			SetIDCardID(ply)
			if gid and gid[1] then
				gid = tonumber(gid[1].int_groupID)
				if isnumber(gid) then
					local _result2 = YRP_SQL_UPDATE(
						"yrp_characters",
						{
							["groupID"] = gid
						}, "uniqueID = " .. ply:CharID()
					)

					ply:SetYRPString("groupUniqueID", gid)
				else
					YRP.msg("note", "_role = " .. tostring(gid))
				end
			else
				YRP.msg("note", "_role failed")
			end

			YRPUpdateRoleUses(_old_uid)
			YRPUpdateRoleUses(rid)
			hook.Run("yrp_get_role_post", ply, rid)
		end
	end
end

function GetFactionTable(uid)
	local group = YRP_SQL_SELECT("yrp_ply_groups", "*", "uniqueID = '" .. uid .. "'")
	if IsNotNilAndNotFalse(group) then
		group = group[1]
		group.int_parentgroup = tonumber(group.int_parentgroup)
		group.uniqueID = tonumber(group.uniqueID)
		if group.int_parentgroup == group.uniqueID then
			local undergroup = YRP_SQL_SELECT("yrp_ply_groups", "*", "uniqueID = '" .. "0" .. "'")
			if IsNotNilAndNotFalse(undergroup) then
				undergroup = undergroup[1]

				return undergroup
			end
		elseif group.int_parentgroup ~= 0 then
			local undergroup = YRP_SQL_SELECT("yrp_ply_groups", "*", "uniqueID = '" .. group.int_parentgroup .. "'")
			if IsNotNilAndNotFalse(undergroup) then
				undergroup = undergroup[1]

				return GetFactionTable(undergroup.uniqueID)
			end
		end

		return group
	end

	local undergroup = YRP_SQL_SELECT("yrp_ply_groups", "*", "uniqueID = '" .. "0" .. "'")
	if IsNotNilAndNotFalse(undergroup) then
		undergroup = undergroup[1]

		return undergroup
	end

	return {}
end

function YRPSetRoleValues(ply, pmid)
	hitquit(ply)
	if yrp_db_loaded() then
		local rolTab = ply:YRPGetRoleTable()
		local groTab = ply:YRPGetGroupTable()
		local ChaTab = ply:YRPGetCharacterTable()
		if YRPWORKED(rolTab, "YRPSetRoleValues rolTab") and YRPWORKED(ChaTab, "YRPSetRoleValues ChaTab") then
			if ChaTab.storage ~= nil then
				local _storage = string.Explode(",", ChaTab.storage)
				YRP.msg("gm", "[YRPSetRoleValues] " .. ply:YRPName() .. " give permanent Licenses")
				for i, lic in pairs(_storage) do
					local _lic = YRP_SQL_SELECT("yrp_shop_items", "*", "type = 'licenses' AND uniqueID = '" .. lic .. "'")
					if _lic ~= nil and _lic ~= false then
						_lic = _lic[1]
						GiveLicense(ply, _lic.ClassName)
					end
				end

				ply:SetYRPInt("licenseIDsVersion", ply:GetYRPInt("licenseIDsVersion", 0) + 1)
			end

			if ChaTab.playermodelID ~= nil then
				pmid = tonumber(pmid) or tonumber(ChaTab.playermodelID)
				local pms = GetPMsOfCharacter(ply, rolTab.uniqueID)
				if pms[pmid] == nil then
					pmid = 1
				end

				local pm = pms[pmid]
				if IsNotNilAndNotFalse(pm) and pm.string_model then
					ply:SetYRPString("string_playermodel", pm.string_model)
					ply:SetModel(pm.string_model)
					local randsize = math.Rand(pm.float_size_min, pm.float_size_max)
					ply:SetModelScale(randsize, 0)
				end
			end
		else
			YRP.msg("note", "[SET ROLE VALUES] No role or/and no character -> Suicide")
			ply:KillSilent()
		end

		--[RE]--check_inv(ply, ply:CharID() )
		if YRPWORKED(rolTab, "YRPSetRoleValues rolTab") then
			ply:SetYRPString("roleIcon", rolTab.string_icon)
			ply:SetYRPString("roleColor", rolTab.string_color)
			ply:SetYRPInt("speedwalk", tonumber(rolTab.int_speedwalk))
			ply:SetYRPInt("speedrun", tonumber(rolTab.int_speedrun))
			ply:SetWalkSpeed(ply:GetYRPInt("speedwalk"))
			ply:SetRunSpeed(ply:GetYRPInt("speedrun"))
			ply:SetMaxHealth(tonumber(rolTab.int_hpmax))
			ply:SetHealth(tonumber(rolTab.int_hp))
			ply:SetYRPInt("HealthReg", tonumber(rolTab.int_hpup))
			ply:SetYRPInt("MaxArmor", tonumber(rolTab.int_armax))
			ply:SetYRPInt("ArmorReg", tonumber(rolTab.int_arup))
			ply:SetArmor(tonumber(rolTab.int_ar))
			ply:SetYRPFloat("GetMaxStamina", tonumber(rolTab.int_stmax))
			ply:SetYRPFloat("GetCurStamina", tonumber(rolTab.int_st))
			ply:SetYRPFloat("staminup", tonumber(rolTab.float_stup))
			ply:SetYRPFloat("stamindown", tonumber(rolTab.float_stdn))
			local abtype = rolTab.string_ability
			ply:SetYRPString("GetAbilityType", abtype)
			if abtype == "none" then
				ply:SetYRPInt("GetMaxAbility", 1)
				ply:SetYRPInt("GetCurAbility", 0)
				ply:SetYRPFloat("GetRegAbility", 0)
				ply:SetYRPFloat("GetRegTick", 0)
			elseif abtype == "rage" then
				ply:SetYRPInt("GetMaxAbility", 100)
				ply:SetYRPInt("GetCurAbility", 0)
				ply:SetYRPFloat("GetRegAbility", 0)
				ply:SetYRPFloat("GetRegTick", 0)
			elseif abtype == "mana" then
				ply:SetYRPInt("GetMaxAbility", 100)
				ply:SetYRPInt("GetCurAbility", 0)
				ply:SetYRPFloat("GetRegAbility", 0.4)
				ply:SetYRPFloat("GetRegTick", 1)
			elseif abtype == "energy" then
				ply:SetYRPInt("GetMaxAbility", 100)
				ply:SetYRPInt("GetCurAbility", 0)
				ply:SetYRPFloat("GetRegAbility", 1)
				ply:SetYRPFloat("GetRegTick", 0.1)
			elseif abtype == "force" then
				ply:SetYRPInt("GetMaxAbility", 100)
				ply:SetYRPInt("GetCurAbility", 0)
				ply:SetYRPFloat("GetRegAbility", 1)
				ply:SetYRPFloat("GetRegTick", 0.1)
			end

			ply:SetJumpPower(tonumber(rolTab.int_powerjump)) -- * rolTab.playermodelsize)
			ply:SetYRPString("salary", rolTab.int_salary)
			ply.salary = rolTab.int_salary
			ply:SetYRPString("roleName", rolTab.string_name)
			ply.DarkRPVars = ply.DarkRPVars or {}
			ply.DarkRPVars.job = rolTab.string_name
			ply:SetYRPBool("isInstructor", tobool(rolTab.bool_instructor))
			ply:SetYRPString("roleDescription", rolTab.string_description)
			ply:SetYRPBool("isVoteable", tobool(rolTab.bool_voteable))
			ply:SetYRPInt("salarytime", tonumber(rolTab.int_salarytime))
			ply:SetYRPInt("nextsalarytime", CurTime() + tonumber(rolTab.int_salarytime))
			ply:SetYRPBool("bool_hunger", tobool(rolTab.bool_hunger))
			ply:SetYRPBool("bool_thirst", tobool(rolTab.bool_thirst))
			ply:SetYRPBool("bool_stamina", tobool(rolTab.bool_stamina))
			ply:SetYRPBool("bool_canbeagent", tobool(rolTab.bool_canbeagent))
			ply:SetYRPBool("isadminonly", tobool(rolTab.bool_adminonly))
			--ply:SetYRPInt( "int_role_cooldown", tonumber(rolTab.int_cooldown) )
			ply:SetYRPString("int_roleondeath", rolTab.int_roleondeath)
			ply:SetYRPInt("int_securitylevel", rolTab.int_securitylevel)
			ply:SetYRPInt("int_namelength", rolTab.int_namelength)
			ply:SetYRPString("string_hud", rolTab.string_hud)
			ply:SetYRPString("string_hud_mask", rolTab.string_hud_mask)
			local _licenseIDs = string.Explode(",", rolTab.string_licenses)
			for i, lic in pairs(_licenseIDs) do
				if tonumber(lic) ~= nil then
					GiveLicense(ply, lic)
				end
			end

			ply:SetYRPInt("licenseIDsVersion", ply:GetYRPInt("licenseIDsVersion", 0) + 1)
			ply:SetYRPString("maxamount", rolTab.int_maxamount)
			ply:SetYRPString("sweps", rolTab.string_sweps)
			ply:SetYRPString("sweps_onspawn", rolTab.string_sweps_onspawn)
			-- ammos
			local tammos = rolTab.string_ammos or ""
			tammos = string.Explode(";", tammos)
			local ammos = {}
			for i, v in pairs(tammos) do
				local t = string.Split(v, ":")
				ammos[t[1]] = t[2]
			end

			for name, amount in pairs(ammos) do
				local ammo = ply:GetAmmoCount(name)
				ply:SetAmmo(ammo + amount, name)
			end

			--custom flags
			local allflags = YRP_SQL_SELECT("yrp_flags", "*", nil) -- hobo, police
			for i, flag in pairs(allflags) do
				ply:SetYRPBool("bool_" .. flag.string_name, false)
			end

			local customflags = string.Explode(",", rolTab.string_customflags)
			for i, flag in pairs(customflags) do
				if IsNotNilAndNotFalse(flag) then
					local fl = YRP_SQL_SELECT("yrp_flags", "*", "uniqueID = '" .. flag .. "'")
					if IsNotNilAndNotFalse(fl) then
						fl = fl[1]
						ply:SetYRPBool("bool_" .. fl.string_name, true)
					end
				end
			end

			ply:SetYRPFloat("float_dmgtype_burn", tonumber(rolTab.float_dmgtype_burn))
			ply:SetYRPFloat("float_dmgtype_bullet", tonumber(rolTab.float_dmgtype_bullet))
			ply:SetYRPFloat("float_dmgtype_energybeam", tonumber(rolTab.float_dmgtype_energybeam))
			-- Darkrp Team
			if GetGlobalYRPBool("bool_team_set", true) then
				ply:SetTeam(rolTab.uniqueID) -- disables damage against npcs
			end
		else
			YRP.msg("note", "[SET ROLE VALUES] No role selected -> Suicide")
			ply:KillSilent()
		end

		if IsNotNilAndNotFalse(groTab) then
			ply:SetYRPString("groupName", groTab.string_name)
			ply:SetYRPString("groupUniqueID", groTab.uniqueID)
			ply:SetYRPString("groupColor", groTab.string_color)
			ply:SetYRPString("groupIcon", groTab.string_icon)
			if GetGlobalYRPBool("bool_team_color", true) then
				timer.Simple(
					0.12,
					function()
						if IsValid(ply) then
							ply:SetPlayerColor(StringToPlayerVector(groTab.string_color))
						end
					end
				)
			end

			ply:SetYRPBool("groupiscp", tobool(groTab.bool_iscp))
			local faction = GetFactionTable(groTab.uniqueID)
			ply:SetYRPString("factionName", faction.string_name)
			ply:SetYRPString("factionUniqueID", faction.uniqueID)
			ply:SetYRPString("factionColor", faction.string_color)
			ply:SetYRPString("sweps_group", groTab.string_sweps)
			--sweps
			local tmpSWEPTable = string.Explode(",", groTab.string_sweps)
			for k, swep in pairs(tmpSWEPTable) do
				if swep ~= nil and swep ~= NULL and swep ~= "" and ply:Alive() then
					YRPPlayerGive(ply, swep)
				end
			end

			-- ammos
			local tammos = groTab.string_ammos or ""
			tammos = string.Explode(";", tammos)
			local ammos = {}
			for i, v in pairs(tammos) do
				local t = string.Split(v, ":")
				ammos[t[1]] = t[2]
			end

			for name, amount in pairs(ammos) do
				local ammo = ply:GetAmmoCount(name)
				ply:SetAmmo(ammo + amount, name)
			end
		else
			YRP.msg("note", "[SET ROLE VALUES] No group selected -> Suicide")
			ply:KillSilent()
		end

		ply:SetYRPBool("loaded", true)
	end
end

function set_ply_pos(ply, map, pos, ang)
	timer.Simple(
		0.1,
		function()
			if map == GetMapNameDB() then
				local tmpPos = string.Split(pos, " ")
				ply:SetPos(Vector(tonumber(tmpPos[1]), tonumber(tmpPos[2]), tonumber(tmpPos[3])))
				local tmpAng = string.Split(ang, " ")
				ply:SetEyeAngles(Angle(tonumber(tmpAng[1]), tonumber(tmpAng[2]), tonumber(tmpAng[3])))
			else
				YRP.msg("db", "[" .. ply:SteamName() .. "] is new on this map.")
			end
		end
	)
end

function YRPCLIENTOpenCharacterSelection(ply)
	if IsValid(ply) and ply:IsPlayer() and ply:IsFullyAuthenticated() then
		YRP.msg("db", "[" .. ply:SteamName() .. "] -> open character selection.")
		net.Start("YRPOpenCharacterMenu")
		net.Send(ply)
	else
		timer.Simple(
			0.01,
			function()
				YRPCLIENTOpenCharacterSelection(ply)
			end
		)
	end
end

function YRPAddPlayer(ply, steamid)
	YRP.msg("db", "[" .. ply:SteamName() .. "] -> Add player to database.")
	steamid = steamid or ply:YRPSteamID()
	ply:KillSilent()
	if steamid ~= nil and steamid ~= false then
		local _SteamName = tostring(ply:SteamName())
		local _ostime = os.time()
		local cols = "SteamID, "
		cols = cols .. "SteamName, "
		cols = cols .. "Timestamp"
		local vals = "'" .. steamid .. "', "
		vals = vals .. "" .. YRP_SQL_STR_IN(_SteamName) .. ", "
		vals = vals .. "'" .. _ostime .. "'"
		local _insert = YRP_SQL_INSERT_INTO("yrp_players", cols, vals)
		if _insert == nil then
			YRP.msg("db", "[" .. ply:SteamName() .. "] -> Successfully added player to database.")
			ply:SetServerKeybinds()
		else
			YRP.msg("error", "YRPAddPlayer failed! _insert: " .. tostring(_insert))
		end
	end
end

function YRPCheckPlayer(ply, steamid)
	--YRP.msg( "db", "[" .. ply:SteamName() .. "] -> Checking if player is in database." )
	steamid = steamid or ply:YRPSteamID()
	if steamid ~= nil and steamid ~= false or game.SinglePlayer() then
		local _result = YRP_SQL_SELECT("yrp_players", "*", "SteamID = '" .. steamid .. "'")
		if _result == nil then
			YRPAddPlayer(ply, steamid)
		elseif IsNotNilAndNotFalse(_result) then
			--YRP.msg( "db", "[" .. ply:SteamName() .. "] is in database." )
			if #_result > 1 then
				YRP.msg("db", "[" .. ply:SteamName() .. "] is more then 1 time in database ( " .. #_result .. " )")
				for k, v in pairs(_result) do
					if k > 1 then
						YRP.msg("db", "[" .. ply:SteamName() .. "] delete other entry.")
						YRP_SQL_DELETE_FROM("yrp_players", "uniqueID = " .. v.uniqueID)
					end
				end
			end
		else
			YRP.msg("note", "[YRPCheckPlayer] FAILED ( " .. tostring(_result) .. " )")
		end
	else
		YRP.msg("error", "SteamID FAILED [" .. tostring(steamid) .. "]")
		timer.Simple(
			1,
			function()
				YRP.msg("db", "[" .. ply:SteamName() .. "] -> Retry check.")
				YRPCheckPlayer(ply, steamid)
			end
		)
	end
end

function YRPCheckClient(ply, steamid)
	--YRP.msg( "db", "[" .. ply:SteamName() .. "] -> Check client ( " .. ply:YRPSteamID() .. " )" )
	YRPCheckPlayer(ply, steamid)
	YRPSaveClients("YRPCheckClient")
end

net.Receive(
	"nws_yrp_getCharakterList",
	function(len, ply)
		local _character_table = ply:YRPGetCharacterTable()
		if IsNotNilAndNotFalse(_character_table) then
			_character_table.rpname = _character_table.rpname
			_character_table.rpdescription = _character_table.rpdescription
			net.Start("nws_yrp_getCharakterList")
			net.WriteTable(_character_table)
			net.Send(ply)
		else
			YRP.msg("note", "[getCharakterList] Character Table from " .. ply:YRPName() .. " is broken.")
		end
	end
)

util.AddNetworkString("nws_yrp_give_getGroTab")
net.Receive(
	"nws_yrp_give_getGroTab",
	function(len, ply)
		local _tmpGroupList = YRP_SQL_SELECT("yrp_ply_groups", "string_name, uniqueID", nil)
		if _tmpGroupList ~= nil then
			net.Start("nws_yrp_give_getGroTab")
			net.WriteTable(_tmpGroupList)
			net.Send(ply)
		else
			YRP.msg("note", "give_getGroTab: _tmpGroupList failed!")
		end
	end
)

util.AddNetworkString("nws_yrp_give_getRolTab")
net.Receive(
	"nws_yrp_give_getRolTab",
	function(len, ply)
		local _groupID = net.ReadString()
		local _tmpRolTab = YRP_SQL_SELECT("yrp_ply_roles", "string_name, uniqueID", "int_groupID = " .. tonumber(_groupID))
		if _tmpRolTab ~= nil then
			net.Start("nws_yrp_give_getRolTab")
			net.WriteTable(_tmpRolTab)
			net.Send(ply)
		else
			YRP.msg("note", "give_getRolTab: _tmpRolTab failed!")
		end
	end
)

net.Receive(
	"nws_yrp_getPlyList",
	function(len, ply)
		local _tmpChaList = YRP_SQL_SELECT("yrp_characters", "*", nil)
		local _tmpRoleList = YRP_SQL_SELECT("yrp_ply_roles", "*", nil)
		local _tmpGroupList = YRP_SQL_SELECT("yrp_ply_groups", "*", nil)
		if _tmpChaList ~= nil and _tmpRoleList ~= nil and _tmpGroupList ~= nil then
			net.Start("nws_yrp_getPlyList")
			net.WriteTable(_tmpChaList)
			net.WriteTable(_tmpGroupList)
			net.WriteTable(_tmpRoleList)
			net.Send(ply)
		else
			YRP.msg("note", "getPlyList: _tmpChaList and _tmpRoleList and _tmpGroupList failed!")
		end
	end
)

util.AddNetworkString("nws_yrp_giveRole")
net.Receive(
	"nws_yrp_giveRole",
	function(len, ply)
		local _tmpSteamID = net.ReadString()
		local uniqueIDRole = net.ReadInt(16)
		if not ply:CanAccess("bool_players") then return end
		for k, _ply in pairs(player.GetAll()) do
			if IsValid(_ply) and tostring(_ply:YRPSteamID()) == tostring(_tmpSteamID) then
				YRPRemRolVals(_ply)
				YRPRemGroVals(_ply)
				YRPSetRole(_ply, uniqueIDRole, true)
				YRP.msg("note", tostring(_ply:Nick()) .. " is now the role: " .. tostring(uniqueIDRole))

				return true
			end
		end
	end
)

util.AddNetworkString("nws_yrp_whitelist_infoplayer")
function YRPWhitelistInfoPlayer(ply, msg)
	net.Start("nws_yrp_whitelist_infoplayer")
	net.WriteString(msg)
	net.Send(ply)
end

function YRPIsWhitelisted(ply, id)
	local _role = YRP_SQL_SELECT("yrp_ply_roles", "*", "uniqueID = " .. id)
	if IsNotNilAndNotFalse(_role) then
		_role = _role[1]
		local steamid = ply:YRPSteamID()
		local _plyAllowedAll = YRP_SQL_SELECT("yrp_role_whitelist", "*", "SteamID = '" .. steamid .. "'")
		if YRPWORKED(_plyAllowedAll, "_plyAllowedAll", true) then
			_plyAllowedAll = _plyAllowedAll[1]
			if _plyAllowedAll.roleID == "-1" and _plyAllowedAll.groupID == "-1" then
				YRP.msg("gm", "[YRPIsWhitelisted]" .. ply:RPName() .. " is ALL whitelisted")

				return true
			end
		end

		local _group = YRP_SQL_SELECT("yrp_ply_groups", "*", "uniqueID = " .. _role.int_groupID)
		if IsNotNilAndNotFalse(_group) then
			_group = _group[1]
			local _plyAllowedGroup = YRP_SQL_SELECT("yrp_role_whitelist", "*", "SteamID = '" .. steamid .. "' AND groupID = " .. _group.uniqueID)
			if tonumber(_group.bool_whitelist) == 1 then
				if IsNotNilAndNotFalse(_plyAllowedGroup) then
					YRP.msg("gm", "[YRPIsWhitelisted]" .. ply:RPName() .. " is group whitelisted.")

					return true
				else
					YRP.msg("gm", "[YRPIsWhitelisted]" .. ply:RPName() .. " is not group whitelisted.")

					return false
				end
			end
		end

		if tonumber(_role.bool_whitelist) == 1 or tonumber(_role.int_prerole) > 0 then
			local _plyAllowedRole = YRP_SQL_SELECT("yrp_role_whitelist", "*", "SteamID = '" .. steamid .. "' AND roleID = " .. id)
			if ply:HasAccess("YRPIsWhitelisted", true) then
				YRP.msg("gm", "[YRPIsWhitelisted]" .. ply:RPName() .. " has access.")

				return true
			else
				if IsNotNilAndNotFalse(_plyAllowedRole) then
					YRP.msg("gm", "[YRPIsWhitelisted]" .. ply:RPName() .. " is role whitelisted.")

					return true
				else
					YRPWhitelistInfoPlayer(ply, "LID_youarenotwhitelisted")
					YRP.msg("gm", "[YRPIsWhitelisted]" .. ply:RPName() .. " is not role whitelisted.")

					return false
				end
			end
		else
			return true
		end
	end

	YRPWhitelistInfoPlayer(ply, "ROLE DOESN'T EXISTS ANYMORE")
	YRP.msg("gm", "[YRPIsWhitelisted]" .. "ROLE DOESN'T EXISTS ANYMORE")

	return false
end

util.AddNetworkString("nws_yrp_voteNo")
net.Receive(
	"nws_yrp_voteNo",
	function(len, ply)
		ply:SetYRPString("voteStatus", "no")
	end
)

util.AddNetworkString("nws_yrp_voteYes")
net.Receive(
	"nws_yrp_voteYes",
	function(len, ply)
		ply:SetYRPString("voteStatus", "yes")
	end
)

local voting = false
local votePly = nil
local voteCount = 30
function startVote(ply, tabl)
	if not voting then
		voting = true
		for k, v in pairs(player.GetAll()) do
			v:SetYRPString("voteStatus", "not voted")
			v:SetYRPBool("voting", true)
			v:SetYRPString("voteName", ply:RPName())
			v:SetYRPString("voteRole", tabl[1].string_name)
		end

		votePly = ply
		voteCount = 30
		timer.Create(
			"voteRunning",
			1,
			0,
			function()
				for k, v in pairs(player.GetAll()) do
					v:SetYRPInt("voteCD", voteCount)
				end

				if voteCount <= 0 then
					voting = false
					local _yes = 0
					local _no = 0
					for k, v in pairs(player.GetAll()) do
						v:SetYRPBool("voting", false)
						if v:GetYRPString("voteStatus", "not voted") == "yes" then
							_yes = _yes + 1
						elseif v:GetYRPString("voteStatus", "not voted") == "no" then
							_no = _no + 1
						end
					end

					if _yes > _no and (_yes + _no) > 1 then
						YRPSetRole(votePly, table[1].uniqueID)
					else
						YRP.msg("gm", "VOTE: not enough yes")
					end

					timer.Remove("voteRunning")
				end

				voteCount = voteCount - 1
			end
		)
	else
		YRP.msg("gm", "a vote is currently running")
	end
end

function canGetRole(ply, roleID, want)
	if roleID == nil then
		YRP.msg("note", "[canGetRole] roleID is nil")

		return
	end

	local tmpTableRole = YRP_SQL_SELECT("yrp_ply_roles", "*", "uniqueID = '" .. roleID .. "'")
	local chatab = ply:YRPGetCharacterTable()
	if IsNotNilAndNotFalse(tmpTableRole) then
		tmpTableRole = tmpTableRole[1]
		if tonumber(tmpTableRole.int_uses) < tonumber(tmpTableRole.int_maxamount) or tonumber(tmpTableRole.int_maxamount) == 0 or tonumber(tmpTableRole.uniqueID) == ply:GetRoleUID() then
			-- Admin only
			if tonumber(tmpTableRole.bool_adminonly) == 1 then
				if not ply:HasAccess("canGetRole") then
					local text = "ADMIN-ONLY Role: " .. ply:YRPName() .. " is not yourrp - admin."
					YRP.msg("gm", "[canGetRole] " .. "ADMIN-ONLY Role: " .. ply:YRPName() .. " is not yourrp - admin.")
					YRPNotiToPly(text, ply)

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
			if IsNotNilAndNotFalse(chatab) then
				if tonumber(chatab.int_level) < tonumber(tmpTableRole.int_requireslevel) then
					local text = ply:YRPName() .. " is not high enough (is: " .. tonumber(chatab.int_level) .. " need: " .. tonumber(tmpTableRole.int_requireslevel) .. " )!"
					YRP.msg("gm", "[canGetRole] " .. text)
					YRPNotiToPly(text, ply)

					return false
				end
			else
				if 1 < tonumber(tmpTableRole.int_requireslevel) then
					local text = ply:YRPName() .. " is not high enough (is: " .. 1 .. " need: " .. tonumber(tmpTableRole.int_requireslevel) .. " )!"
					YRP.msg("gm", "[canGetRole] " .. text)
					YRPNotiToPly(text, ply)

					return false
				end
			end

			if tonumber(ply:GetYRPInt("ts_role_" .. ply:GetRoleUID(), 0)) > CurTime() and want then
				local text = ply:YRPName() .. " is on cooldown for this role!"
				YRP.msg("gm", "[canGetRole] " .. text)
				YRPNotiToPly(text, ply)

				return false
			end

			-- Whitelist + Prerole
			if (tonumber(tmpTableRole.bool_whitelist) == 1 or tonumber(tmpTableRole.int_prerole) > 0) and not YRPIsWhitelisted(ply, roleID) then
				local text = ply:YRPName() .. " is not whitelisted."
				YRP.msg("gm", "[canGetRole] " .. text)
				--YRPNotiToPly(text, ply)

				return false
			end

			-- Usergroups
			local ugs = string.Explode(",", tmpTableRole.string_usergroups)
			local ug = string.upper(ply:GetUserGroup())
			local found = table.HasValue(ugs, ug) or table.HasValue(ugs, "ALL")
			if not found then
				local text = ply:YRPName() .. " is not allowed to use this role (UserGroup)."
				YRP.msg("gm", "[canGetRole] " .. text)
				YRPNotiToPly(text, ply)

				return false
			end

			return true
		else
			local text = ply:YRPName() .. " maxamount reached."
			YRP.msg("gm", "[canGetRole] " .. text)
			YRPNotiToPly(text, ply)

			return false
		end
	end

	YRP.msg("note", "[canGetRole] " .. "FAILED: " .. tostring(roleID))

	return false
end

function YRPStripWeapon(ply, cname)
	ply:StripWeapon(cname)
end

function YRPRemRolVals(ply)
	if not IsValid(ply) then return end
	local rolTab = ply:YRPGetRoleTable()
	if IsNotNilAndNotFalse(rolTab) then
		local _sweps = string.Explode(",", rolTab.string_sweps)
		for k, v in pairs(_sweps) do
			if v and ply:HasWeapon(v) then
				local _, err = pcall(YRPStripWeapon, ply, v)
				if err then
					YRPMsg(err)
				end
			end
		end
	end
end

function YRPRemGroVals(ply)
	if not IsValid(ply) then return end
	local groTab = ply:YRPGetGroupTable()
	if IsNotNilAndNotFalse(groTab) then
		local _sweps = string.Explode(",", groTab.string_sweps)
		for k, v in pairs(_sweps) do
			local _, err = pcall(YRPStripWeapon, ply, v)
			if err then
				YRPMsg(err)
			end
		end
	end
end

function canVoteRole(ply, roleID)
	local tmpTableRole = YRP_SQL_SELECT("yrp_ply_roles", "*", "uniqueID = " .. roleID)
	if YRPWORKED(tmpTableRole, "tmpTableRole") then
		local uses = tonumber(tmpTableRole[1].int_uses)
		local maxamount = tonumber(tmpTableRole[1].int_maxamount)
		if uses < tonumber(player.GetCount()) * (tonumber(tmpTableRole[1].int_amountpercentage) / 100) and uses < maxamount or maxamount <= 0 and tonumber(tmpTableRole[1].bool_voteable) == 1 then return true end
	end

	YRP.msg("note", "[canVoteRole] " .. "not voteable, max reached")

	return false
end

util.AddNetworkString("nws_yrp_wantRole")
net.Receive(
	"nws_yrp_wantRole",
	function(len, ply)
		local uniqueIDRole = net.ReadInt(16)
		local pmid = net.ReadInt(16)
		local bgs = net.ReadTable()
		YRP.msg("note", ply:YRPName() .. " wants the role " .. uniqueIDRole)
		if canGetRole(ply, uniqueIDRole, true) then
			ply:SetYRPBool("switchrole", true)
			--Remove Sweps from old role
			YRPRemRolVals(ply)
			YRPRemGroVals(ply)
			if GetGlobalYRPBool("bool_players_die_on_role_switch", false) then
				ply:KillSilent()
			end

			--New role
			YRPSetRole(ply, uniqueIDRole, false, pmid, bgs)
			if GetGlobalYRPBool("bool_players_die_on_role_switch", false) then
				ply:Spawn()
				YRPTeleportToSpawnpoint(ply, "switchrole")
			end

			local reusetime = math.Round(CurTime() + ply:GetRoleCooldown(), 0)
			ply:SetYRPInt("ts_role_" .. ply:GetRoleUID(), reusetime)
			ply:SetYRPBool("switchrole", false)
		elseif canVoteRole(ply, uniqueIDRole) then
			local _role = YRP_SQL_SELECT("yrp_ply_roles", "*", "uniqueID = " .. uniqueIDRole)
			startVote(ply, _role)
		else
			YRPNotiToPly("Not allowed to get this role", ply)
		end
	end
)

local Player = FindMetaTable("Player")
function Player:SetupCharID()
	if IsValid(self) then
		local charid = YRP_SQL_SELECT(DATABASE_NAME, "*", "steamid = '" .. self:YRPSteamID() .. "'")
		if charid and charid[1] then
			charid = charid[1].CurrentCharacter
			self:SetYRPInt("yrp_charid", tonumber(charid))
		end
	end
end
