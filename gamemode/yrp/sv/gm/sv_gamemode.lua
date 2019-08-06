--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

function CheckIfCollectionIDIsCorrect()
	if YRPCollectionID != nil then
		local collectionID = tonumber(YRPCollectionID())
		if collectionID <= 0 then
			printGM("note", "Current CollectionID is not correct.")
			return false
		end
	end
	return false
end

local collections = {}

function TestCollection(cid)
	--printGM("db", "TestCollection(" .. cid .. ")")
	cid = tonumber(cid)
	if collections[cid].done then
		-- Check if same size
		local addons = engine.GetAddons()
		if table.Count(collections[cid].ids) == table.Count(addons) then
			for i, addon in pairs(addons) do
				addon.wsid = tonumber(addon.wsid)
				if !table.HasValue(collections[cid].ids, addon.wsid) then
					printGM("db", "[TestCollection] Collection " .. cid .. " is not the right collection.")
					return false
				end
			end

			printGM("db", "[TestCollection] Found right collection: " .. cid)
			if YRPCollectionID() != cid then
				printGM("db", "[TestCollection] Current Collection is wrong, updating CollectionID.")
				SetYRPCollectionID(cid)
			else
				printGM("db", "[TestCollection] Current Collection is right.")
			end
			return true
		end
	end
end

function GetCollection(cid, maincid)
	cid = tonumber(cid)
	if isnumber(cid) then
		maincid = maincid or cid
		maincid = tonumber(maincid)
		if isnumber(maincid) then
			if maincid == cid then
				collections[maincid] = {}
				collections[maincid].id = collections[maincid].id or maincid
				collections[maincid].ids = collections[maincid].ids or {}
				collections[maincid].idstest = collections[maincid].idstest or {}
				collections[maincid].othercollections = {}
				collections[maincid].done = collections[maincid].done or false
			end

			if !table.HasValue(collections[maincid].othercollections, cid) then
				table.insert(collections[maincid].othercollections, cid)

				local url = "https://steamcommunity.com/sharedfiles/filedetails/?id=" .. cid
				http.Fetch(url,
					function(body, len, headers, code)
						local _st, _en = string.find(body, "collectionChildren")
						local wsids = ""
						if _st then
							wsids = string.sub(body, _st)
						end

						local ids = string.Explode("\"collectionItem\"", wsids)
						for i, v in pairs(ids) do
							local searchfor = "?id="
							local _s, _e = string.find(v, searchfor)
							if _s then
								_s = _s + string.len(searchfor)
							 	local id = string.sub(v, _s)
								searchfor = "\""
								_s, _e = string.find(id, searchfor)
								_s = _s + string.len(searchfor)
								id = string.sub(id, 1, _e - 1)
								id = tonumber(id)
								if isnumber(id) and id != cid then
									local id_url = "https://steamcommunity.com/sharedfiles/filedetails/?id=" .. id
									http.Fetch(id_url,
										function(bo, le, he, co)
											table.insert(collections[maincid].idstest, id)
											local _found = string.find(bo, "Addon</a>")
											if _found then
												table.insert(collections[maincid].ids, id)
											end
											if table.Count(collections[maincid].idstest) == table.Count(engine.GetAddons()) and collections[maincid].done then
												TestCollection(maincid)
											end
										end,
										function(err)
											printGM("note", "[GetCollection - ID] Error. (" .. tostring(err) .. ")")
										end
									)
									---table.insert(collections[maincid].ids, id)
								end
							end
						end

						_st, _en = string.find(wsids, "childrenTitle")
						local coids = ""
						if _st then
							coids = string.sub(wsids, _st)
						end

						local linkedcollections = {}
						if coids != "" then
							local othercollections = string.Explode("\"workshopItem ", coids)
							for i, v in pairs(othercollections) do
								local searchfor = "?id="
								local _s, _e = string.find(v, searchfor)
								if _s then
									_s = _s + string.len(searchfor)
								 	local id = string.sub(v, _s)
									searchfor = "\""
									_s, _e = string.find(id, searchfor)
									_s = _s + string.len(searchfor)
									id = string.sub(id, 1, _e - 1)
									id = tonumber(id)
									if isnumber(id) and id != cid and id != maincid then
										table.insert(linkedcollections, id)
									end
								end
							end
						end

						collections[maincid].linkedcollections = collections[maincid].linkedcollections or 0
						collections[maincid].linkedcollections = collections[maincid].linkedcollections + table.Count(linkedcollections)

						collections[maincid].linkedcollectionsadded = collections[maincid].linkedcollectionsadded or 0
						if cid != maincid then
							collections[maincid].linkedcollectionsadded = collections[maincid].linkedcollectionsadded + 1
						end

						if cid != maincid then
							printGM("db", "[GetCollection] Collected IDs for " .. maincid .. " [" .. collections[maincid].linkedcollectionsadded .. "|" .. collections[maincid].linkedcollections .. "] Child-Collection:" .. cid)
						end

						for i, v in pairs(linkedcollections) do
							GetCollection(v, maincid)
						end

						if collections[maincid].linkedcollections == collections[maincid].linkedcollectionsadded then
							collections[maincid].done = true
						end
					end,
					function(err)
						printGM("note", "[GetCollection] Error in GetCollection. (" .. tostring(err) .. ")")
					end
				)
			end
		end
	end
end

function SearchForCollectionID()
	local files = file.Find("*", "BASE_PATH")
	local collectionIDs = {}

	for k, v in pairs(files) do
		local f = file.Read(v, "BASE_PATH")
		if isstring(f) then
			f = string.Replace(f, "\n", " ")
			f = string.Replace(f, "\r", " ")
			local cidstart = string.find(f, "+host_workshop_collection ")

			if cidstart then
				local cid = string.sub(f, cidstart + string.len("+host_workshop_collection "))
				local _s, _e = string.find(cid, " ")
				if _s then
					if _e != nil then
						cid = tonumber(string.sub(cid, 1, _e - 1))
					else
						cid = tonumber(string.sub(cid, 1))
					end
					if isnumber(cid) then
						if cid > 0 and !table.HasValue(collectionIDs, cid) then
							table.insert(collectionIDs, cid)
						end
					else
						YRP.msg("note", "Cid is not a number [" .. tostring(cid) .. "] f [" .. tostring(f) .. "]")
					end
				end
			end
		end
	end
	if !CheckIfCollectionIDIsCorrect() then
		for i, cid in pairs(collectionIDs) do
			printGM("db", "SearchForCollectionID: " .. cid)
			GetCollection(cid)
		end
	end
end
SearchForCollectionID()

local leftedPlys = {}
function GM:PlayerDisconnected(ply)
	printGM("gm", "[PlayerDisconnected] " .. ply:YRPName())
	save_clients("PlayerDisconnected")

	local _rol_tab = ply:GetRolTab()
	if wk(_rol_tab) then
		if tonumber(_rol_tab.int_maxamount) > 0 then
			ply:SetDString("roleUniqueID", "1")
			updateRoleUses(_rol_tab.uniqueID)
		end
	end

	if YRPRemoveBuildingOwner() then
		local entry = {}
		entry.SteamID = ply:SteamID()
		entry.timestamp = CurTime()
		table.insert(leftedPlys, entry)
		timer.Simple(YRPRemoveBuildingOwnerTime(), function()
			local found = false
			for i, e in pairs(leftedPlys) do
				for j, p in pairs(player.GetAll()) do
					if p:SteamID() == e.SteamID then
						found = true
					end
				end
				if !found then
					BuildingRemoveOwner(e.SteamID)
				end
				table.RemoveByValue(leftedPlys, e)
			end
		end)
	end
end

function GM:PlayerConnect(name, ip)
	printGM("gm", "[PlayerConnect] Name: " .. name .. " (IP: " .. ip .. ")")
	PrintMessage(HUD_PRINTTALK, name .. " is connecting to the Server.")
end

util.AddNetworkString("yrp_askforinfo")
function GM:PlayerInitialSpawn(ply)
	--printGM("gm", "[PlayerInitialSpawn] " .. ply:YRPName())
	--ply:KillSilent()
	net.Start("yrp_askforinfo")
	net.Send(ply)

	if ply:HasCharacterSelected() then
		local rolTab = ply:GetRolTab()
		if rolTab != nil then
			timer.Simple(1, function()

				SetRole(ply, rolTab.uniqueID)
				teleportToSpawnpoint(ply)
			end)
		end
	end
end

function GM:PlayerSelectSpawn(ply)
	--printGM("gm", "[PlayerSelectSpawn] " .. ply:YRPName())

	local spawns = ents.FindByClass("info_player_start")
	local random_entry = math.random(#spawns)

	return spawns[ random_entry ]

end

hook.Add("PlayerAuthed", "yrp_PlayerAuthed", function(ply, steamid, uniqueid)
	ply:KillSilent()

	printGM("gm", "[PlayerAuthed] " .. ply:YRPName() .. " | " .. tostring(steamid) .. " | " .. tostring(uniqueid))

	ply:SetDBool("isserverdedicated", game.IsDedicated())

	--ply:KillSilent()
	ply:resetUptimeCurrent()
	check_yrp_client(ply, steamid or uniqueID)

	ply:DesignLoadout()
	ply:GeneralLoadout()

	SendDGlobals(ply)
	SendDEntities(ply)
end)

YRP = YRP or {}

function YRP:Loadout(ply)
	printGM("gm", "[Loadout] " .. ply:YRPName() .. " get YourRP Loadout.")
	ply:SetDBool("bool_loadouted", false)

	ply:SetDInt("speak_channel", 0)

	ply:DesignLoadout()
	ply:UserGroupLoadout()
	ply:GeneralLoadout()

	ply:LockdownLoadout()

	ply:LevelSystemLoadout()
	ply:CharacterLoadout()

	ply:SetDBool("bool_loadouted", true)
end

hook.Add("PlayerLoadout", "yrp_PlayerLoadout", function(ply)
	if ply:IsValid() then
		ply:StripWeapons()
		printGM("gm", "[PlayerLoadout] " .. ply:YRPName() .. " get his role equipment.")
		YRP:Loadout(ply)

		if ply:HasCharacterSelected() then
			--[[ Status Reset ]]--
			ply:SetDBool("cuffed", false)
			ply:SetDBool("broken_leg_left", false)
			ply:SetDBool("broken_leg_right", false)
			ply:SetDBool("broken_arm_left", false)
			ply:SetDBool("broken_arm_right", false)

			ply:Give("yrp_key")
			ply:Give("yrp_unarmed")

			local plyTab = ply:GetPlyTab()
			if wk(plyTab) then
				local _rol_tab = ply:GetRolTab()
				if wk(_rol_tab) then
					SetRole(ply, _rol_tab.uniqueID)
				else
					printGM("note", "Give role failed -> KillSilent -> " .. ply:YRPName() .. " role: " .. tostring(_rol_tab))

					local chatab = ply:GetChaTab()
					if wk(chatab) then
						CheckIfRoleExists(ply, chatab.roleID)
					end

					ply:KillSilent()
				end

				local chaTab = ply:GetChaTab()
				if wk(chaTab) then
					ply:SetDString("money", chaTab.money)
					ply:SetDString("moneybank", chaTab.moneybank)
					ply:SetDString("rpname", SQL_STR_OUT(chaTab.rpname))

					setbodygroups(ply)
				else
					printGM("note", "Give char failed -> KillSilent -> " .. ply:YRPName() .. " char: " .. tostring(chaTab))
					if !ply:IsBot() then
						ply:KillSilent()
					end
				end

				--ply:EquipWeapons()

				ply:SetDFloat("hunger", 100)
				ply:SetDFloat("thirst", 100)
			else
				YRP.msg("error", "[PlayerLoadout] failed at plytab.")
			end
		else
			printGM("note", "[PlayerLoadout] " .. ply:YRPName() .. " has no character selected.")
		end

		ply:UpdateBackpack()

		RenderNormal(ply)
	else
		YRP.msg("note", "[PlayerLoadout] is invalid or bot.")
	end
	return true
end)

hook.Add("PlayerSpawn", "yrp_player_spawn_PlayerSpawn", function(ply)
	--printGM("gm", "[PlayerSpawn] " .. tostring(ply:YRPName()) .. " spawned.")
	if ply:GetDBool("can_respawn", false) then
		ply:SetDBool("can_respawn", false)

		timer.Simple(0.01, function()
			teleportToSpawnpoint(ply)
		end)
	end
end)

hook.Add("PostPlayerDeath", "yrp_player_spawn_PostPlayerDeath", function(ply)
	--printGM("gm", "[PostPlayerDeath] " .. tostring(ply:YRPName()) .. " is dead.")
	ply:StopBleeding()
	ply:InteruptCasting()

	ply:SetDInt("yrp_stars", 0)

	ply:SetDBool("can_respawn", true)
end)

function AddStar(ply)
	StartCombat(ply)
	local stars = ply:GetDInt("yrp_stars", 0) + 1
	local rand = math.random(0,100)
	local chance = 100 / stars
	if rand <= chance then
		ply:SetDInt("yrp_stars", ply:GetDInt("yrp_stars", 0) + 1)
		if ply:GetDInt("yrp_stars", 0) > 5 then
			ply:SetDInt("yrp_stars", 5)
		end
	end
end

function GM:PlayerDeath(ply, inflictor, attacker)
	ply.NextSpawnTime = CurTime() + 2
	ply.DeathTime = CurTime()

	if (IsValid(attacker) and attacker:GetClass() == "trigger_hurt") then
		attacker = ply
	end

	if (IsValid(attacker) and attacker:IsVehicle() and IsValid(attacker:GetDriver())) then
		attacker = attacker:GetDriver()
	end

	if (!IsValid(inflictor) and IsValid(attacker)) then
		inflictor = attacker
	end

	if (IsValid(inflictor) and inflictor == attacker and (inflictor:IsPlayer() or inflictor:IsNPC())) then
		inflictor = inflictor:GetActiveWeapon()
		if (!IsValid(inflictor)) then
			inflictor = attacker
		end
	end

	if (attacker == ply) then
		net.Start("PlayerKilledSelf")
			net.WriteEntity(ply)
		net.Broadcast()
		return
	end

	if (attacker:IsPlayer()) then
		net.Start("PlayerKilledByPlayer")
			net.WriteEntity(ply)
			net.WriteString(inflictor:GetClass())
			net.WriteEntity(attacker)
		net.Broadcast()
		return
	end

	net.Start("PlayerKilled")
		net.WriteEntity(ply)
		net.WriteString(inflictor:GetClass())
		net.WriteString(attacker:GetClass())
	net.Broadcast()
end

hook.Add("PlayerDeath", "yrp_stars_playerdeath", function(victim, inflictor, attacker)
	if attacker:IsPlayer() then
		AddStar(attacker)
	end
end)

hook.Add("OnNPCKilled", "yrp_stars_onnpckilled", function(npc, attacker, inflictor)
	AddStar(attacker)
end)

function IsNoDefaultWeapon(cname)
	if cname != "yrp_key" and cname != "yrp_unarmed" then
		return true
	else
		return false
	end
end

function IsNoAdminWeapon(cname)
	if cname != "weapon_physgun" and cname != "weapon_physcannon" and cname != "gmod_tool" and cname != "yrp_arrest_stick" then
		return true
	else
		return false
	end
end

function IsNoUserGroupWeapon(ply, cname)
	local _ugsweps = string.Explode(",", ply:GetDString("usergroup_sweps", ""))
	if !table.HasValue(_ugsweps, cname) then
		return true
	else
		return false
	end
end

function IsNoRoleSwep(ply, cname)
	local _rol_tab = ply:GetRolTab()
	if wk(_rol_tab) then
		local _sweps = string.Explode(",", _rol_tab.string_sweps)
		if !table.HasValue(_sweps, cname) then
			return true
		else
			return false
		end
	end
end

hook.Add("DoPlayerDeath", "yrp_player_spawn_DoPlayerDeath", function(ply, attacker, dmg)
	--printGM("gm", "[DoPlayerDeath] " .. tostring(ply:YRPName()) .. " do death.")
	local _reward = tonumber(ply:GetDString("hitreward"))
	if isnumber(_reward) and attacker:IsPlayer() then
		if attacker:IsAgent() then
			printGM("note", "Hit done! " .. _reward)
			attacker:addMoney(_reward)
			hitdone(ply, attacker)
		end
	end

	local roleondeathuid = ply:GetRoleOnDeathRoleUID()
	if roleondeathuid > 0 then
		SetRole(ply, roleondeathuid, false)
	end

	if IsDropItemsOnDeathEnabled() then
		local _weapons = ply:GetWeapons()
		local _cooldown_item = 120
		for i, wep in pairs(_weapons) do
			if wep:GetModel() != "" and IsNoDefaultWeapon(wep:GetClass()) and IsNoRoleSwep(ply, wep:GetClass()) and IsNoUserGroupWeapon(ply, wep:GetClass()) then
				ply:DropSWEP(wep:GetClass())
				timer.Simple(_cooldown_item, function()
					if wep:IsValid() then
						if wep:GetOwner() == "" then
							wep:Remove()
						end
					end
				end)
			else
				--ply:DropSWEPSilence(wep:GetClass())
			end
		end
		--ply:DropBackpackStorage()
	end
	if IsDropMoneyOnDeathEnabled() and !ply:GetDBool("switchrole", false) then
		local _money = ply:GetMoney()
		local _max = GetMaxAmountOfDroppedMoney()
		if _money > _max then
			_money = _max
		end
		if _money > 0 then
			local money = ents.Create("yrp_money")
			money:SetPos(ply:GetPos())
			money:Spawn()
			money:SetMoney(_money)
			ply:addMoney(-_money)
		end
	end
end)

function GM:ShutDown()
	save_clients("Shutdown/Changelevel")
	--SaveStorages("Shutdown/Changelevel")
end

function GM:GetFallDamage(ply, speed)
	local _damage = speed * CustomFalldamageMultiplier()
	if IsCustomFalldamageEnabled() then
		if speed > ply:GetModelScale()*120 then
			if IsBonefracturingEnabled() then
				local _rand = math.Round(math.Rand(0, 1), 0)
				if _rand == 0 then
					ply:SetDBool("broken_leg_right", true)
				elseif _rand == 1 then
					ply:SetDBool("broken_leg_left", true)
				end
			end
			if IsCustomFalldamagePercentageEnabled() then
				return _damage*ply:GetMaxHealth()/100
			else
				return _damage
			end
		else
			return 0
		end
	else
		return 10
	end
end

function GM:PlayerSwitchWeapon(ply, oldWeapon, newWeapon)

	if newWeapon:IsScripted() then
		--[[ Set default HoldType of currentweapon ]]--
		if newWeapon:GetDString("swep_holdtype", "") == "" then
			local _hold_type = newWeapon.HoldType or newWeapon:GetHoldType() or "normal"
			newWeapon:SetDString("swep_holdtype", _hold_type)
		end
	end

	if ply:GetDBool("cuffed") or ply.leiche != nil then
		return true
	end
end

function IsAllowedToSuicide(ply)
	if ply:HasAccess() then
		return true
	elseif IsSuicideDisabled() or ply:IsFlagSet(FL_FROZEN) or ply:GetDBool("ragdolled", false) or ply:GetDBool("injail", false) then
		return false
	else
		return true
	end
end

function GM:CanPlayerSuicide(ply)
	return IsAllowedToSuicide(ply)
end

hook.Add("EntityTakeDamage", "YRP_EntityTakeDamage", function(ent, dmginfo)
	if IsEntity(ent) and !ent:IsPlayer() and !ent:IsNPC() then
		local hitfactor = GetHitFactorEntities() or 1
		dmginfo:ScaleDamage(hitfactor)
	end
	if ent:IsVehicle() then
		local hitfactor = GetHitFactorVehicles() or 1
		dmginfo:ScaleDamage(hitfactor)
	end
end)

function SlowThink(ent)
	if IsSlowingEnabled() then
		local speedrun = tonumber(ent:GetDInt("speedrun", 0))
		local speedwalk = tonumber(ent:GetDInt("speedwalk", 0))
		if speedrun == tonumber(ent:GetRunSpeed()) or speedwalk == tonumber(ent:GetWalkSpeed()) then
			ent:SetRunSpeed(speedrun * GetSlowingFactor())
			ent:SetWalkSpeed(speedwalk * GetSlowingFactor())
			ent:SetDBool("slowed", true)
			timer.Simple(GetSlowingTime(), function()
				ent:SetRunSpeed(speedrun)
				ent:SetWalkSpeed(speedwalk)
				ent:SetDBool("slowed", false)
			end)
		end
	end
end

function StartCombat(ply)
	if ply:IsValid() then
		if ply:IsPlayer() then
			ply:SetDBool("inCombat", true)
			local steamid = ply:SteamID()
			if timer.Exists(steamid .. " outOfCombat") then
				timer.Remove(steamid .. " outOfCombat")
			end
			timer.Create(steamid .. " outOfCombat", 5, 1, function()
				if ea(ply) then
					ply:SetDBool("inCombat", false)
					if timer.Exists(steamid .. " outOfCombat") then
						timer.Remove(steamid .. " outOfCombat")
					end
				end
			end)
		end
	end
end

hook.Add("ScalePlayerDamage", "YRP_ScalePlayerDamage", function(ply, hitgroup, dmginfo)
	if ply:IsFullyAuthenticated() then
		if dmginfo:GetAttacker() != ply then
			StartCombat(ply)
		end

		SlowThink(ply)

		if true then
			if IsBleedingEnabled() then
				local _rand = math.Rand(0, 100)
				if _rand < GetBleedingChance() then
					ply:StartBleeding()
					ply:SetBleedingPosition(ply:GetPos() - dmginfo:GetDamagePosition())
				end
			end
			if hitgroup == HITGROUP_HEAD then
				if IsHeadshotDeadlyPlayer() then
					dmginfo:ScaleDamage(ply:GetMaxHealth())
				else
					dmginfo:ScaleDamage(GetHitFactorPlayerHead())
				end
		 	elseif hitgroup == HITGROUP_CHEST then
				dmginfo:ScaleDamage(GetHitFactorPlayerChes())
			elseif hitgroup == HITGROUP_STOMACH then
				dmginfo:ScaleDamage(GetHitFactorPlayerStom())
			elseif hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM then
				dmginfo:ScaleDamage(GetHitFactorPlayerArms())
				if IsBonefracturingEnabled() then
					local _break = math.Round(math.Rand(0, 100), 0)
					if _break <= GetBrokeChanceArms() then
						if hitgroup == HITGROUP_LEFTARM then
							ply:SetDBool("broken_arm_left", true)

							ply:SetActiveWeapon("yrp_unarmed")
							ply:SelectWeapon("yrp_unarmed")
						elseif hitgroup == HITGROUP_RIGHTARM then
							ply:SetDBool("broken_arm_right", true)

							ply:SetActiveWeapon("yrp_unarmed")
							ply:SelectWeapon("yrp_unarmed")
						end
					end
				end
			elseif hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then
				dmginfo:ScaleDamage(GetHitFactorPlayerLegs())
				if IsBonefracturingEnabled() then
					local _break = math.Round(math.Rand(0, 100), 0)
					if _break <= GetBrokeChanceLegs() then
						if hitgroup == HITGROUP_LEFTLEG then
							ply:SetDBool("broken_leg_left", true)
						elseif hitgroup == HITGROUP_RIGHTLEG then
							ply:SetDBool("broken_leg_right", true)
						end
					end
				end
			else
				dmginfo:ScaleDamage(1)
			end
		else
			dmginfo:ScaleDamage(1)
		end
	end
end)

hook.Add("ScaleNPCDamage", "YRP_ScaleNPCDamage", function(npc, hitgroup, dmginfo)
	if true then
		if hitgroup == HITGROUP_HEAD then
			if IsHeadshotDeadlyNpc() then
				dmginfo:ScaleDamage(npc:Health())
			else
				dmginfo:ScaleDamage(GetHitFactorNpcHead())
			end
	 	elseif hitgroup == HITGROUP_CHEST then
			dmginfo:ScaleDamage(GetHitFactorNpcChes())
		elseif hitgroup == HITGROUP_STOMACH then
			dmginfo:ScaleDamage(GetHitFactorNpcStom())
		elseif hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM then
			dmginfo:ScaleDamage(GetHitFactorNpcArms())
		elseif hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then
			dmginfo:ScaleDamage(GetHitFactorNpcLegs())
		else
			dmginfo:ScaleDamage(1)
		end
	else
		dmginfo:ScaleDamage(1)
	end
end)


--[[ SPEAK Channels ]] --
util.AddNetworkString("press_speak_next")
net.Receive("press_speak_next", function(len, ply)
	if GetGlobalDBool("bool_voice", false) and GetGlobalDBool("bool_voice_channels", false) then
		ply:SetDInt("speak_channel", ply:GetDInt("speak_channel", 0) + 1)
		if ply:GetDInt("speak_channel", 0) > 1 then
			if ply:GetDBool("yrp_voice_global", false) then
				if ply:GetDInt("speak_channel", 0) > 2 then
					ply:SetDInt("speak_channel", 0)
				end
			else
				ply:SetDInt("speak_channel", 0)
			end
		end
	else
		ply:SetDInt("speak_channel", 0)
	end
end)

util.AddNetworkString("press_speak_prev")
net.Receive("press_speak_prev", function(len, ply)
	if GetGlobalDBool("bool_voice", false) and GetGlobalDBool("bool_voice_channels", false) then
		ply:SetDInt("speak_channel", ply:GetDInt("speak_channel", 0) - 1)
		if ply:GetDInt("speak_channel", 0) < 0 then
			if ply:GetDBool("yrp_voice_global", false) then
				ply:SetDInt("speak_channel", 2)
			else
				ply:SetDInt("speak_channel", 1)
			end
		end
	else
		ply:SetDInt("speak_channel", 0)
	end
end)

util.AddNetworkString("yrp_voice_start")
net.Receive("yrp_voice_start", function(len, ply)
	if GetGlobalDBool("bool_voice", false) then
		ply:SetDBool("yrp_speaking", true)
		if ply:GetDString("speak_channel") == 2 then
			for k, v in pairs(player.GetAll()) do
				v:SetDString("voice_global_steamid", ply:SteamID())
				v:SetDString("voice_global_rolename", ply:GetDString("RoleName"))
			end
		end
	end
end)

util.AddNetworkString("yrp_voice_end")
net.Receive("yrp_voice_end", function(len, ply)
	ply:SetDBool("yrp_speaking", false)
end)

function hearfaded(listener, talker)
	local t_speak_channel = tonumber(talker:GetDInt("speak_channel"))
	local t_guid = tonumber(talker:GetDString("groupUniqueID"))
	local l_guid = tonumber(listener:GetDString("groupUniqueID"))
	if t_speak_channel == 0 or t_speak_channel == 1 and t_guid != l_guid then
		return true -- if talker is local or global and not in same group
	else
		return false
	end
	return false
end

function canhear(listener, talker)
	local t_speak_channel = tonumber(talker:GetDInt("speak_channel"))
	local t_guid = tonumber(talker:GetDString("groupUniqueID"))
	local l_guid = tonumber(listener:GetDString("groupUniqueID"))
	local dist = listener:GetPos():Distance(talker:GetPos())
	if t_speak_channel == 2 then -- GLOBAL
		--print(listener, talker, "GLOBAL ||| t_speak_channel == 2")
		return true -- if talker is globalvoice
	elseif t_speak_channel == 1 and t_guid == l_guid then
		--print(listener, talker, "SAME GROUP ||| t_speak_channel == 1 and t_guid == l_guid")
		return true -- if talker is groupvoice and same group
	elseif t_speak_channel == 1 and dist < GetVoiceChatLocalRange() and IsLocalGroupVoiceChatEnabled() then
		--print(listener, talker, "GROUP LOCAL VOICE RANGE |||| dist < GetVoiceChatLocalRange() and IsLocalGroupVoiceChatEnabled()")
		return true -- is near groupvoicerange
	elseif dist < GetVoiceChatLocalRange() then -- LOCAL
		--print(listener, talker, "LOCAL VOICE RANGE |||| dist < GetVoiceChatLocalRange()")
		return true -- if near local range
	else
		return false
	end
end

function IsInMaxVoiceRange(listener, talker)
	local dist = listener:GetPos():Distance(talker:GetPos())
	local result = dist <= GetGlobalDInt("int_voice_max_range", 1)
	--print(listener, talker, result)
	return result
end

function GM:PlayerCanHearPlayersVoice(listener, talker)
	if IsVoiceEnabled() then
		if listener != talker then
			if Is3DVoiceEnabled() then
				if IsVoiceChannelsEnabled() then
					return canhear(listener, talker), hearfaded(listener, talker)	-- 3D Voice chat + voice channels
				else
					return IsInMaxVoiceRange(listener, talker), true	-- 3D Voice enabled
				end
			else
				return true, false -- 3D Voice chat disabled
			end
		else
			return false
		end
	else
		return false -- Voice disabled
	end
end

function setbodygroups(ply)
	local chaTab = ply:GetChaTab()
	if wk(chaTab) then
		ply:SetSkin(chaTab.skin)
		for i = 0, 19 do
			ply:SetBodygroup(i, chaTab["bg" .. i])
		end
	end
end

function setPlayerModel(ply)
	local tmpRolePlayermodel = ply:GetPlayerModel()
	if wk(tmpRolePlayermodel) and !strEmpty(tmpRolePlayermodel) then
		ply:SetModel(tmpRolePlayermodel)
	else
		ply:SetModel("models/player/skeleton.mdl")
	end
	setbodygroups(ply)
end

function GM:PlayerSetModel(ply)
	setPlayerModel(ply)
end

function GM:PlayerSpray(ply)
	if GetGlobalDBool("bool_graffiti_disabled", false) then
		return true
	else
		return false
	end
end

function GM:PlayerSwitchFlashlight(pl, enabled)
	local _tmp = SQL_SELECT("yrp_usergroups", "*", "string_name = '" .. string.lower(pl:GetUserGroup()) .. "'")
	if wk(_tmp) then
		_tmp = _tmp[1]
		if tobool(_tmp.bool_flashlight) then
			return true
		end
	end
	return false
end

function GM:ShowHelp(ply)
	return false
end

function GM:PostCleanupMap()
	-- Rebuild Doors
	YRP.msg("note", "RELOAD DOORS")
	loadDoors()
end
