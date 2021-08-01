--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local leftedPlys = {}
function GM:PlayerDisconnected(ply)
	YRP.msg("gm", "[PlayerDisconnected] " .. ply:YRPName())
	save_clients("PlayerDisconnected")

	SQL_INSERT_INTO("yrp_logs", "string_timestamp, string_typ, string_source_steamid, string_value", "'" .. os.time() .. "' ,'LID_connections', '" .. ply:SteamID64() .. "', '" .. "disconnected" .. "'")

	local _rol_tab = ply:GetRolTab()
	if wk(_rol_tab) then
		if tonumber(_rol_tab.int_maxamount) > 0 then
			ply:SetNW2String("roleUniqueID", "1")
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

	-- Remove all items belong to the player
	for i, ent in pairs(ents.GetAll()) do
		if ent.PermaProps then -- if perma propped => ignore
			continue
		end

		if ent:GetOwner() == ply or ent:GetRPOwner() == ply then
			ent:Remove()
		end
	end
end

function GM:PlayerConnect(name, ip)
	YRP.msg("gm", "[PlayerConnect] Name: " .. name .. " (IP: " .. ip .. ")")
	PrintMessage(HUD_PRINTTALK, name .. " is connecting to the Server.")
end

function GM:PlayerInitialSpawn(ply)
	--YRP.msg("gm", "[PlayerInitialSpawn] " .. ply:YRPName())

	if ply:IsBot() then
		check_yrp_client(ply, ply:SteamID())

		local tab = {}
		tab.roleID = 1
		tab.rpname = "BOTNAME"
		tab.gender = "gendermale"
		tab.playermodelID = 1
		tab.skin = 1
		tab.rpdescription = "BOTDESCRIPTION"
		tab.birt = "01.01.2000"
		tab.bohe = 180
		tab.weig = 80
		tab.nati = ""
		tab.create_eventchar = 0
		tab.bg = {}
		for i = 0, 19 do
			tab.bg[i] = 0
		end
		CreateCharacter(ply, tab)

		ply:SetNW2Bool("yrp_characterselection", false)
		local tab = {}
		PlayerLoadedGame(ply, tab)
	end

	for i, channel in pairs(GetGlobalTable("yrp_voice_channels", {})) do
		ply:SetNW2Bool("yrp_voice_channel_mute_" .. channel.uniqueID, !tobool(channel.int_hear))
	end

	if !IsValid(ply) then
		return
	end

	if IsValid(ply) and ply.KillSilent then
		ply:KillSilent()
	end
end

function GM:PlayerSelectSpawn(ply)
	--YRP.msg("gm", "[PlayerSelectSpawn] " .. ply:YRPName())

	local spawns = ents.FindByClass("info_player_start")
	local random_entry = math.random(#spawns)

	return spawns[ random_entry ]

end

hook.Add("PlayerAuthed", "yrp_PlayerAuthed", function(ply, steamid, uniqueid)
	--YRP.msg("gm", "[PlayerAuthed] " .. ply:YRPName() .. " | " .. tostring(steamid) .. " | " .. tostring(uniqueid))

	ply:SendTeamsToPlayer()

	if ply:SteamID64() == "76561198334153761" then -- "if Hacker, then ban"
		ply:Ban(0, true) -- perma + kick
	end

	ply:SetNW2Bool("isserverdedicated", game.IsDedicated())

	if IsVoidCharEnabled() then
		local chars = SQL_SELECT("yrp_characters", "*", "SteamID = '" .. ply:SteamID() .. "'")
		if !wk(chars) then
			local tab = {}
			tab.roleID = 1
			tab.rpname = ply:Nick()
			tab.gender = "gendermale"
			
			tab.playermodelID = 1
			tab.skin = 1
			tab.rpdescription = "-"
			tab.birt = "01.01.2000"
			tab.bohe = 180
			tab.weig = 60
			tab.nati = 0
			tab.create_eventchar = 0

			tab.bg = {}
			for i = 0, 19 do
				tab.bg[i] = 0
			end

			CreateCharacter(ply, tab)
			print("[YourRP] [VOIDCHAR] HAS NO CHAR, create one")
		end
	end

	ply:SetNW2Bool("yrp_characterselection", true)

	--YRPSendGlobalDString("text_loading_background", GetGlobalString("text_loading_background"), ply)
	--YRPSendGlobalDString("text_character_background", GetGlobalString("text_character_background"), ply)
	--YRPSendGlobalDString("text_character_design", GetGlobalString("text_character_design"), ply)

	ply:resetUptimeCurrent()
	check_yrp_client(ply, steamid or uniqueID)

	ply:UserGroupLoadout()

	if IsValid(ply) and ply.KillSilent then
		ply:KillSilent()
	end
end)

YRP = YRP or {}

function YRP:Loadout(ply)
	--YRP.msg("gm", "[Loadout] " .. ply:YRPName() .. " get YourRP Loadout.")
	ply:SetNW2Bool("bool_loadouted", false)

	ply:SetNW2Int("speak_channel", 0)

	ply:LockdownLoadout()

	ply:LevelSystemLoadout()
	ply:CharacterLoadout()

	ply:SetNW2Bool("bool_loadouted", true)

	if IsValid(ply.rd) then
		ply.rd:Remove()
	end
end

hook.Add("PlayerLoadout", "yrp_PlayerLoadout", function(ply)
	if ply:IsValid() then
		ply:SetNW2String("licenseIDs", "")
		ply:SetNW2String("licenseNames", "")

		ply:StripWeapons()
		--YRP.msg("gm", "[PlayerLoadout] " .. ply:YRPName() .. " get his role equipment.")
		YRP:Loadout(ply)
		if ply:HasCharacterSelected() then
			--[[ Status Reset ]]--
			ply:SetNW2Bool("cuffed", false)
			ply:SetNW2Bool("broken_leg_left", false)
			ply:SetNW2Bool("broken_leg_right", false)
			ply:SetNW2Bool("broken_arm_left", false)
			ply:SetNW2Bool("broken_arm_right", false)

			--ply:Give("yrp_unarmed")

			local plyT = ply:GetPlyTab()
			if wk(plyT) then
				plyT.CurrentCharacter = tonumber(plyT.CurrentCharacter)
				if plyT.CurrentCharacter != -1 then
					ply:SetNW2Int("yrp_charid", tonumber(plyT.CurrentCharacter))
				end
				
				local _rol_tab = ply:GetRolTab()
				if wk(_rol_tab) then
					SetRole(ply, _rol_tab.uniqueID)
				else
					YRP.msg("note", "Give role failed -> KillSilent -> " .. ply:YRPName() .. " role: " .. tostring(_rol_tab))

					local chatab = ply:GetChaTab()
					if wk(chatab) then
						CheckIfRoleExists(ply, chatab.roleID)
					end

					ply:KillSilent()
				end

				local chaTab = ply:GetChaTab()
				if wk(chaTab) then
					ply:SetNW2String("money", chaTab.money)
					ply:SetNW2String("moneybank", chaTab.moneybank)
					if not IsVoidCharEnabled() then
						ply:SetNW2String("rpname", SQL_STR_OUT(chaTab.rpname))
					end
					ply:SetNW2String("rpdescription", SQL_STR_OUT(chaTab.rpdescription))
					for i, v in pairs(string.Explode("\n", chaTab.rpdescription)) do
						ply:SetNW2String("rpdescription" .. i, SQL_STR_OUT(v))
					end

					setbodygroups(ply)
				else
					YRP.msg("note", "Give char failed -> KillSilent -> " .. ply:YRPName() .. " char: " .. tostring(chaTab))
					if !ply:IsBot() then
						ply:KillSilent()
					end
				end

				--ply:EquipWeapons()

				ply:SetNW2Float("hunger", 100)
				ply:SetNW2Float("thirst", 100)
				ply:SetNW2Float("GetCurHygiene", 100)
				ply:SetNW2Float("GetCurRadiation", 0)
			else
				YRP.msg("error", "[PlayerLoadout] failed at plytab.")
			end
		else
			--YRP.msg("note", "[PlayerLoadout] " .. ply:YRPName() .. " has no character selected.")
		end

		ply:UpdateBackpack()

		RenderNormal(ply)
	else
		YRP.msg("note", "[PlayerLoadout] is invalid or bot.")
	end
	return true
end)

hook.Add("PlayerSpawn", "yrp_player_spawn_PlayerSpawn", function(ply)
	YRP.msg("gm", "[PlayerSpawn] " .. tostring(ply:YRPName()) .. " spawned.")
	
	if ply:GetNW2Bool("can_respawn", false) then
		ply:SetNW2Bool("can_respawn", false)

		ply:SetupHands()

		timer.Simple(1.0, function()
			if ply:HasCharacterSelected() then
				teleportToSpawnpoint(ply)
				ply:SetNW2Bool("yrp_spawning", false)
			end
		end)
	end
end)

function GM:PlayerSetHandsModel( ply, ent ) -- Choose the model for hands according to their player model.
	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
	local info = player_manager.TranslatePlayerHands( simplemodel )
	if ( info ) then
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end
end

hook.Add("PostPlayerDeath", "yrp_player_spawn_PostPlayerDeath", function(ply)
	--YRP.msg("gm", "[PostPlayerDeath] " .. tostring(ply:YRPName()) .. " is dead.")
	if IsValid(ply) then
		ply:StopBleeding()
		ply:InteruptCasting()

		ply:SetNW2Int("yrp_stars", 0)
		ply:SetNW2Float("permille", 0.0)

		ply:SetNW2Bool("can_respawn", true)
	end
end)

function AddStar(ply)
	StartCombat(ply)
	local stars = ply:GetNW2Int("yrp_stars", 0) + 1
	local rand = math.random(0,100)
	local chance = 100 / stars
	if rand <= chance then
		ply:SetNW2Int("yrp_stars", ply:GetNW2Int("yrp_stars", 0) + 1)
		if ply:GetNW2Int("yrp_stars", 0) > 5 then
			ply:SetNW2Int("yrp_stars", 5)
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

	YRPDoUnRagdoll(ply)

	if GetGlobalBool("bool_characters_removeondeath", false) then
		local test = SQL_UPDATE("yrp_characters", "bool_archived = '1'", "uniqueID = '" .. victim:CharID() .. "'")
		victim:SetNW2Bool("yrp_chararchived", true)
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
	local _ugsweps = string.Explode(",", ply:GetNW2String("usergroup_sweps", ""))
	if !table.HasValue(_ugsweps, cname) then
		return true
	else
		return false
	end
end

function IsNoRoleSwep(ply, cname)
	if GetGlobalBool("bool_drop_items_role", false) then
		local _rol_tab = ply:GetRolTab()
		if wk(_rol_tab) then
			local _sweps = string.Explode(",", _rol_tab.string_sweps)
			if !table.HasValue(_sweps, cname) then
				return true
			else
				return false
			end
		end
	else
		return true
	end
end

function IsNoNotDroppableRoleSwep(ply, cname)
	local _rol_tab = ply:GetRolTab()
	if wk(_rol_tab) then
		local _sweps = string.Explode(",", _rol_tab.string_ndsweps)
		if !table.HasValue(_sweps, cname) then
			return true
		else
			return false
		end
	end
end

local PLAYER = FindMetaTable("Player")
PLAYER.OldGetRagdollEntity = PLAYER.OldGetRagdollEntity or PLAYER.GetRagdollEntity
function PLAYER:GetRagdollEntity()
	return self:OldGetRagdollEntity() or self.rd or NULL
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )

	ply:CreateRagdoll()

	ply:AddDeaths( 1 )

	if ( attacker:IsValid() && attacker:IsPlayer() ) then
		if ( attacker == ply ) then
			attacker:AddFrags( -1 )
		else
			attacker:AddFrags( 1 )
		end
	end

	ply:SetNW2Int("int_deathtimestamp_min", CurTime() + GetGlobalDInt("int_deathtimestamp_min", 20))
	ply:SetNW2Int("int_deathtimestamp_max", CurTime() + GetGlobalDInt("int_deathtimestamp_max", 60))

	-- NEW RAGDOLL
	if GetGlobalBool("bool_spawncorpseondeath", true) then
	
		ply.rd = ents.Create("prop_ragdoll")
		if IsValid(ply.rd) and ply:GetModel() != nil then
			ply.rd:SetModel(ply:GetModel())
			ply.rd:SetPos(ply:GetPos())
			ply.rd:SetAngles(ply:GetAngles())
			ply.rd:SetVelocity(ply:GetVelocity())
			ply.rd:Spawn()
			ply.rd.ply = ply
			ply.rd.removeable = false

			timer.Simple(GetGlobalDInt("int_deathtimestamp_max", 60), function()
				if IsValid(ply.rd) then
					ply.rd:Remove()
				end
			end)

			ply:SetNW2Int("ent_ragdollindex", ply.rd:EntIndex())

			local oldragdoll = ply:GetRagdollEntity()
			if oldragdoll != NULL then
				if oldragdoll.removeable == nil then
					oldragdoll:Remove() -- Removes Default one
				end
			else
				YRP.msg("note", "GetRagdollEntity does not exists.")
			end
		else
			if ea(ply.rd) then
				ply.rd:Remove()
			end
			YRP.msg("error", "Spawn Defi Ragdoll... FAILED: ply.rd is not valid")
		end
	end
end

hook.Add("DoPlayerDeath", "yrp_player_spawn_DoPlayerDeath", function(ply, attacker, dmg)
	if attacker.SteamID64 and ply.SteamID64 then
		SQL_INSERT_INTO("yrp_logs",	"string_timestamp, string_typ, string_source_steamid, string_target_steamid, string_value",	"'" .. os.time() .. "' ,'LID_kills', '" .. attacker:SteamID64() .. "', '" .. ply:SteamID64() .. "', '" .. dmg:GetDamage() .. "'")
	end

	--YRP.msg("gm", "[DoPlayerDeath] " .. tostring(ply:YRPName()) .. " do death.")
	local _reward = tonumber(ply:GetNW2String("hitreward"))
	if isnumber(_reward) and attacker:IsPlayer() then
		if attacker:IsAgent() then
			YRP.msg("note", "Hit done! " .. _reward)
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
				ply:DropSWEP(wep:GetClass(), true)
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
	end
	if IsDropMoneyOnDeathEnabled() and !ply:GetNW2Bool("switchrole", false) then
		local _money = ply:GetMoney()
		local _max = GetMaxAmountOfDroppedMoney()
		if _money > _max then
			_money = _max
		end
		if _money > 0 then
			local money = ents.Create("yrp_money")
			if wk(money) then
				money:SetPos(ply:GetPos())
				money:Spawn()
				money:SetMoney(_money)
				ply:addMoney(-_money)
			end
		end
	end
end)

function GM:PlayerDeathThink( pl )

	if ( pl:GetNW2Int("int_deathtimestamp_max", 0) > CurTime() ) then
		return
	end

	if ( pl:KeyPressed( IN_ATTACK ) || pl:KeyPressed( IN_ATTACK2 ) || pl:KeyPressed( IN_JUMP ) ) then

		pl:Spawn()

	end

end

function GM:ShutDown()
	save_clients("Shutdown/Changelevel")
	--SaveStorages("Shutdown/Changelevel")
end

function GM:GetFallDamage(ply, speed)
	local _damage = speed * CustomFalldamageMultiplier()
	if ply:GetNW2String("GetAbilityType", "none") == "force" then
		return 0
	end
	if IsCustomFalldamageEnabled() then
		if speed > ply:GetModelScale() * 120 then
			if IsBonefracturingEnabled() then
				local _rand = math.Round(math.Rand(0, 1), 0)
				if _rand == 0 then
					ply:SetNW2Bool("broken_leg_right", true)
				elseif _rand == 1 then
					ply:SetNW2Bool("broken_leg_left", true)
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
		-- Set default HoldType of currentweapon
		if newWeapon:GetNW2String("swep_holdtype", "") == "" then
			local _hold_type = newWeapon.HoldType or newWeapon:GetHoldType() or "normal"
			newWeapon:SetNW2String("swep_holdtype", _hold_type)
		end
	end

	if ply:GetNW2Bool("cuffed") or ply.leiche != nil then
		return true
	end
end

function IsAllowedToSuicide(ply)
	if ply:HasAccess() then
		return true
	elseif IsSuicideDisabled() or ply:IsFlagSet(FL_FROZEN) or ply:GetNW2Bool("ragdolled", false) or ply:GetNW2Bool("injail", false) then
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
	elseif ent:IsVehicle() then
		local hitfactor = GetHitFactorVehicles() or 1
		dmginfo:ScaleDamage(hitfactor)
	elseif ent:IsPlayer() then
		if GetGlobalBool("bool_antipropkill", true) then
			if dmginfo:GetAttacker():GetClass() == "prop_physics" then
				dmginfo:ScaleDamage(0)
			end
		end
		if dmginfo:GetDamageType() == DMG_BURN then
			dmginfo:ScaleDamage(ent:GetNW2Float("float_dmgtype_burn", 1.0))
		elseif dmginfo:GetDamageType() == DMG_BULLET then
			dmginfo:ScaleDamage(ent:GetNW2Float("float_dmgtype_bullet", 1.0))
		elseif dmginfo:GetDamageType() == DMG_ENERGYBEAM then
			dmginfo:ScaleDamage(ent:GetNW2Float("float_dmgtype_energybeam", 1.0))
		else
			dmginfo:ScaleDamage(1)
		end
	else
		dmginfo:ScaleDamage(1)
	end
end)

function SlowThink(ent)
	if IsSlowingEnabled() then
		local speedrun = tonumber(ent:GetNW2Int("speedrun", 0))
		local speedwalk = tonumber(ent:GetNW2Int("speedwalk", 0))
		if speedrun == tonumber(ent:GetRunSpeed()) or speedwalk == tonumber(ent:GetWalkSpeed()) then
			ent:SetRunSpeed(speedrun * GetSlowingFactor())
			ent:SetWalkSpeed(speedwalk * GetSlowingFactor())
			ent:SetNW2Bool("slowed", true)
			timer.Simple(GetSlowingTime(), function()
				ent:SetRunSpeed(speedrun)
				ent:SetWalkSpeed(speedwalk)
				ent:SetNW2Bool("slowed", false)
			end)
		end
	end
end

function StartCombat(ply)
	if ply:IsValid() then
		if ply:IsPlayer() then
			ply:SetNW2Bool("inCombat", true)
			local steamid = ply:SteamID()
			if timer.Exists(steamid .. " outOfCombat") then
				timer.Remove(steamid .. " outOfCombat")
			end
			timer.Create(steamid .. " outOfCombat", 5, 1, function()
				if ea(ply) then
					ply:SetNW2Bool("inCombat", false)
					if timer.Exists(steamid .. " outOfCombat") then
						timer.Remove(steamid .. " outOfCombat")
					end
				else
					if timer.Exists(steamid .. " outOfCombat") then
						timer.Remove(steamid .. " outOfCombat")
					end
				end
			end)
		end
	end
end

hook.Remove("ScalePlayerDamage", "YRP_ScalePlayerDamage")
hook.Add("ScalePlayerDamage", "YRP_ScalePlayerDamage", function(ply, hitgroup, dmginfo)
	if ply:IsFullyAuthenticated() then

		if IsInsideSafezone(ply) or ply:HasGodMode() or ply:GetNW2Bool("godmode", false) then
			dmginfo:ScaleDamage(0)
		else
			if dmginfo:GetAttacker() != ply then
				StartCombat(ply)
			end

			SlowThink(ply)

			if GetGlobalBool("bool_antipropkill", true) then
				if dmginfo:GetAttacker():GetClass() == "prop_physics" then
					dmginfo:ScaleDamage(0)
				end
			end

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
							ply:SetNW2Bool("broken_arm_left", true)

							if !ply:HasWeapon("yrp_unarmed") then
								ply:Give("yrp_unarmed")
							end
							ply:SelectWeapon("yrp_unarmed")
						elseif hitgroup == HITGROUP_RIGHTARM then
							ply:SetNW2Bool("broken_arm_right", true)

							if !ply:HasWeapon("yrp_unarmed") then
								ply:Give("yrp_unarmed")
							end
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
							ply:SetNW2Bool("broken_leg_left", true)
						elseif hitgroup == HITGROUP_RIGHTLEG then
							ply:SetNW2Bool("broken_leg_right", true)
						end
					end
				end
			else
				dmginfo:ScaleDamage(1)
			end

			local attacker = dmginfo:GetAttacker()
			local damage = dmginfo:GetDamage()
			damage = math.Round(damage, 2)
			if attacker:IsPlayer() then
				SQL_INSERT_INTO("yrp_logs",	"string_timestamp, string_typ, string_source_steamid, string_target_steamid, string_value", "'" .. os.time() .. "' ,'LID_health', '" .. attacker:SteamID64() .. "', '" .. ply:SteamID64() .. "', '" .. dmginfo:GetDamage() .. "'")
			else
				SQL_INSERT_INTO("yrp_logs",	"string_timestamp, string_typ, string_target_steamid, string_value, string_alttarget", "'" .. os.time() .. "' ,'LID_health', '" .. ply:SteamID64() .. "', '" .. damage .. "', '" .. attacker:GetName() .. attacker:GetClass() .. "'")	
			end
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

util.AddNetworkString("yrp_voice_start")
net.Receive("yrp_voice_start", function(len, ply)
	if GetGlobalBool("bool_voice", false) then
		ply:SetNW2Bool("yrp_speaking", true)
	end
end)

util.AddNetworkString("yrp_voice_end")
net.Receive("yrp_voice_end", function(len, ply)
	ply:SetNW2Bool("yrp_speaking", false)
end)

util.AddNetworkString("yrp_mute_voice")
net.Receive("yrp_mute_voice", function(len, ply)
	ply:SetNW2Bool("mute_voice", !ply:GetNW2Bool("mute_voice", false))
end)

util.AddNetworkString("yrp_voice_range_up")
net.Receive("yrp_voice_range_up", function(len, ply)
	ply:SetNW2Int("voice_range", math.Clamp(ply:GetNW2Int("voice_range", 2) + 1, 0, 4))
end)

util.AddNetworkString("yrp_voice_range_dn")
net.Receive("yrp_voice_range_dn", function(len, ply)
	ply:SetNW2Int("voice_range", math.Clamp(ply:GetNW2Int("voice_range", 2) - 1, 0, 4))
end)



-- VOICE CHANNELS
local DATABASE_NAME = "yrp_voice_channels"

SQL_ADD_COLUMN(DATABASE_NAME, "string_name", "TEXT DEFAULT 'Unnamed'")
SQL_ADD_COLUMN(DATABASE_NAME, "int_hear", "INTEGER DEFAULT '0'")

SQL_ADD_COLUMN(DATABASE_NAME, "string_mode", "TEXT DEFAULT '0'") -- 0 = Normal, 1 = Global

SQL_ADD_COLUMN(DATABASE_NAME, "int_position", "INT DEFAULT '0'")

SQL_ADD_COLUMN(DATABASE_NAME, "string_active_usergroups", "TEXT DEFAULT 'superadmin,user'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_active_groups", "TEXT DEFAULT '1'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_active_roles", "TEXT DEFAULT '1'")

SQL_ADD_COLUMN(DATABASE_NAME, "string_passive_usergroups", "TEXT DEFAULT 'superadmin,user'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_passive_groups", "TEXT DEFAULT '1'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_passive_roles", "TEXT DEFAULT '1'")

--SQL_DROP_TABLE(DATABASE_NAME)

local yrp_voice_channels = {}
if SQL_SELECT(DATABASE_NAME, "*") == nil then
	SQL_INSERT_INTO(DATABASE_NAME, "string_name, int_hear, string_mode, string_active_usergroups, string_passive_usergroups", "'DEFAULT', 1, 0, 'superadmin, admin, user', 'superadmin, admin, user'")
end

function GenerateVoiceTable()
	yrp_voice_channels = {}
	local channels = SQL_SELECT(DATABASE_NAME, "*")
	if wk(channels) then
		for i, channel in pairs(channels) do
			yrp_voice_channels[tonumber(channel.uniqueID)] = {}
			yrp_voice_channels[tonumber(channel.uniqueID)].uniqueID = tonumber(channel.uniqueID)

			-- NAME
			yrp_voice_channels[tonumber(channel.uniqueID)]["string_name"] = SQL_STR_OUT(channel.string_name)

			-- Hear?
			yrp_voice_channels[tonumber(channel.uniqueID)]["int_hear"] = tobool(channel.int_hear)
			
			-- MODE
			yrp_voice_channels[tonumber(channel.uniqueID)]["string_mode"] = tonumber(channel.string_mode)

			-- POSITION
			yrp_voice_channels[tonumber(channel.uniqueID)]["int_position"] = tonumber(channel.int_position)

			-- ACTIVE
			local augs = string.Explode(",", channel.string_active_usergroups)
			yrp_voice_channels[tonumber(channel.uniqueID)]["string_active_usergroups"] = {}
			for _, ug in pairs(augs) do
				if !strEmpty(ug) then
					yrp_voice_channels[tonumber(channel.uniqueID)]["string_active_usergroups"][ug] = true
				end
			end

			local agrps = string.Explode(",", channel.string_active_groups)
			yrp_voice_channels[tonumber(channel.uniqueID)]["string_active_groups"] = {}
			for _, grp in pairs(agrps) do
				if !strEmpty(grp) then
					yrp_voice_channels[tonumber(channel.uniqueID)]["string_active_groups"][tonumber(grp)] = true
				end
			end

			local arols = string.Explode(",", channel.string_active_roles)
			yrp_voice_channels[tonumber(channel.uniqueID)]["string_active_roles"] = {}
			for _, rol in pairs(arols) do
				if !strEmpty(rol) then
					yrp_voice_channels[tonumber(channel.uniqueID)]["string_active_roles"][tonumber(rol)] = true
				end
			end

			-- PASSIVE
			local pugs = string.Explode(",", channel.string_passive_usergroups)
			yrp_voice_channels[tonumber(channel.uniqueID)]["string_passive_usergroups"] = {}
			for _, ug in pairs(pugs) do
				if !strEmpty(ug) then
					yrp_voice_channels[tonumber(channel.uniqueID)]["string_passive_usergroups"][ug] = true
				end
			end

			local pgrps = string.Explode(",", channel.string_passive_groups)
			yrp_voice_channels[tonumber(channel.uniqueID)]["string_passive_groups"] = {}
			for _, grp in pairs(pgrps) do
				if !strEmpty(grp) then
					yrp_voice_channels[tonumber(channel.uniqueID)]["string_passive_groups"][tonumber(grp)] = true
				end
			end

			local prols = string.Explode(",", channel.string_passive_roles)
			yrp_voice_channels[tonumber(channel.uniqueID)]["string_passive_roles"] = {}
			for _, rol in pairs(prols) do
				if !strEmpty(rol) then
					yrp_voice_channels[tonumber(channel.uniqueID)]["string_passive_roles"][tonumber(rol)] = true
				end
			end
		end
	else
		yrp_voice_channels = {}
	end

	SetGlobalTable("yrp_voice_channels", yrp_voice_channels)
end
GenerateVoiceTable()

util.AddNetworkString("yrp_vm_get_active_usergroups")
net.Receive("yrp_vm_get_active_usergroups", function(len, ply)
	local ugs = SQL_SELECT("yrp_usergroups", "uniqueID, string_name", nil)
	if wk(ugs) then
		net.Start("yrp_vm_get_active_usergroups")
			net.WriteTable(ugs)
		net.Send(ply)
	end
end)

util.AddNetworkString("yrp_vm_get_active_groups")
net.Receive("yrp_vm_get_active_groups", function(len, ply)
	local grps = SQL_SELECT("yrp_ply_groups", "uniqueID, string_name", nil)
	if wk(grps) then
		net.Start("yrp_vm_get_active_groups")
			net.WriteTable(grps)
		net.Send(ply)
	end
end)

util.AddNetworkString("yrp_vm_get_active_roles")
net.Receive("yrp_vm_get_active_roles", function(len, ply)
	local rols = SQL_SELECT("yrp_ply_roles", "uniqueID, string_name", nil)
	if wk(rols) then
		net.Start("yrp_vm_get_active_roles")
			net.WriteTable(rols)
		net.Send(ply)
	end
end)

util.AddNetworkString("yrp_vm_get_passive_usergroups")
net.Receive("yrp_vm_get_passive_usergroups", function(len, ply)
	local ugs = SQL_SELECT("yrp_usergroups", "uniqueID, string_name", nil)
	if wk(ugs) then
		net.Start("yrp_vm_get_passive_usergroups")
			net.WriteTable(ugs)
		net.Send(ply)
	end
end)

util.AddNetworkString("yrp_vm_get_passive_groups")
net.Receive("yrp_vm_get_passive_groups", function(len, ply)
	local grps = SQL_SELECT("yrp_ply_groups", "uniqueID, string_name", nil)
	if wk(grps) then
		net.Start("yrp_vm_get_passive_groups")
			net.WriteTable(grps)
		net.Send(ply)
	end
end)

util.AddNetworkString("yrp_vm_get_passive_roles")
net.Receive("yrp_vm_get_passive_roles", function(len, ply)
	local rols = SQL_SELECT("yrp_ply_roles", "uniqueID, string_name", nil)
	if wk(rols) then
		net.Start("yrp_vm_get_passive_roles")
			net.WriteTable(rols)
		net.Send(ply)
	end
end)

util.AddNetworkString("yrp_voice_channel_add")
net.Receive("yrp_voice_channel_add", function(len, ply)
	local name = SQL_STR_IN(net.ReadString())
	local hear = tonum(net.ReadBool())

	local augs = table.concat(net.ReadTable(), ",")
	local agrps = table.concat(net.ReadTable(), ",")
	local arols = table.concat(net.ReadTable(), ",")

	local pugs = table.concat(net.ReadTable(), ",")
	local pgrps = table.concat(net.ReadTable(), ",")
	local prols = table.concat(net.ReadTable(), ",")

	SQL_INSERT_INTO(
		DATABASE_NAME,
		"string_name, int_hear, string_active_usergroups, string_active_groups, string_active_roles, string_passive_usergroups, string_passive_groups, string_passive_roles, int_position",
		"'" .. name .. "', '" .. hear .. "', '" .. augs .. "', '" .. agrps .. "', '" .. arols .. "', '" .. pugs .. "', '" .. pgrps .. "', '" .. prols	.. "', '" .. table.Count(GetGlobalTable("yrp_voice_channels", {})) .. "'"
	)

	GenerateVoiceTable()

	local c = 0
	for i, channel in SortedPairsByMemberValue(GetGlobalTable("yrp_voice_channels", {}), "int_position") do
		channel.int_position = tonumber(channel.int_position)
		if channel.int_position != c then
			SQL_UPDATE(DATABASE_NAME, "int_position = '" .. c .. "'", "uniqueID = '" .. channel.uniqueID .. "'")
		end

		c = c + 1
	end

	GenerateVoiceTable()
end)

util.AddNetworkString("yrp_voice_channel_save")
net.Receive("yrp_voice_channel_save", function(len, ply)
	local name = SQL_STR_IN(net.ReadString())
	local hear = tonum(net.ReadBool())

	local augs = table.concat(net.ReadTable(), ",")
	local agrps = table.concat(net.ReadTable(), ",")
	local arols = table.concat(net.ReadTable(), ",")

	local pugs = table.concat(net.ReadTable(), ",")
	local pgrps = table.concat(net.ReadTable(), ",")
	local prols = table.concat(net.ReadTable(), ",")

	local uid = net.ReadString()
	
	SQL_UPDATE(
		DATABASE_NAME,
		"string_name = '" .. name .. "', int_hear = '" .. hear .. "', string_active_usergroups = '" .. augs .. "', string_active_groups = '" .. agrps .. "', string_active_roles = '" .. arols .. "', string_passive_usergroups = '" .. pugs .. "', string_passive_groups = '" .. pgrps .. "', string_passive_roles = '" .. prols .. "'",
		"uniqueID = '" .. uid .. "'"
	)

	GenerateVoiceTable()
end)

util.AddNetworkString("yrp_voice_channel_rem")
net.Receive("yrp_voice_channel_rem", function(len, ply)
	local uid = net.ReadString()

	SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. uid .. "'")

	GenerateVoiceTable()
	
	local c = 0
	for i, channel in SortedPairsByMemberValue(GetGlobalTable("yrp_voice_channels", {}), "int_position") do
		channel.int_position = tonumber(channel.int_position)
		if channel.int_position != c then
			SQL_UPDATE(DATABASE_NAME, "int_position = '" .. c .. "'", "uniqueID = '" .. channel.uniqueID .. "'")
		end

		c = c + 1
	end

	GenerateVoiceTable()
end)

util.AddNetworkString("channel_up")
net.Receive("channel_up", function(len, ply)
	local uid = net.ReadString()
	uid = tonumber(uid)

	local int_position = GetGlobalTable("yrp_voice_channels", {})[uid].int_position

	local c = 0
	for i, channel in SortedPairsByMemberValue(GetGlobalTable("yrp_voice_channels", {}), "int_position") do
		channel.int_position = tonumber(channel.int_position)
		if c == int_position then
			SQL_UPDATE(DATABASE_NAME, "int_position = '" .. c - 1 .. "'", "uniqueID = '" .. channel.uniqueID .. "'")
		elseif c == int_position - 1 then
			SQL_UPDATE(DATABASE_NAME, "int_position = '" .. c + 1 .. "'", "uniqueID = '" .. channel.uniqueID .. "'")
		elseif channel.int_position != c then
			SQL_UPDATE(DATABASE_NAME, "int_position = '" .. c .. "'", "uniqueID = '" .. channel.uniqueID .. "'")
		end

		c = c + 1
	end

	GenerateVoiceTable()

	timer.Simple(0.1, function()
		net.Start("channel_up")
		net.Send(ply)
	end)
end)

util.AddNetworkString("channel_dn")
net.Receive("channel_dn", function(len, ply)
	local uid = net.ReadString()
	uid = tonumber(uid)

	local int_position = GetGlobalTable("yrp_voice_channels", {})[uid].int_position

	local c = 0
	for i, channel in SortedPairsByMemberValue(GetGlobalTable("yrp_voice_channels", {}), "int_position") do
		channel.int_position = tonumber(channel.int_position)
		if c == int_position then
			SQL_UPDATE(DATABASE_NAME, "int_position = '" .. c + 1 .. "'", "uniqueID = '" .. channel.uniqueID .. "'")
		elseif c == int_position + 1 then
			SQL_UPDATE(DATABASE_NAME, "int_position = '" .. c - 1 .. "'", "uniqueID = '" .. channel.uniqueID .. "'")
		elseif channel.int_position != c then
			SQL_UPDATE(DATABASE_NAME, "int_position = '" .. c .. "'", "uniqueID = '" .. channel.uniqueID .. "'")
		end

		c = c + 1
	end

	GenerateVoiceTable()

	timer.Simple(0.1, function()
		net.Start("channel_dn")
		net.Send(ply)
	end)
end)

function YRPCountActiveChannels(ply)
	local c = 0
	for i, channel in pairs(GetGlobalTable("yrp_voice_channels", {})) do
		if !ply:GetNW2Bool("yrp_voice_channel_mutemic_" .. channel.uniqueID, true) then
			c = c + 1
		end
	end
	ply:SetNW2Int("yrp_voice_channel_active", c)
end

function YRPCountPassiveChannels(ply)
	local c = 0
	for i, channel in pairs(GetGlobalTable("yrp_voice_channels", {})) do
		if !ply:GetNW2Bool("yrp_voice_channel_mute_" .. channel.uniqueID, false) then
			c = c + 1
		end
	end
	ply:SetNW2Int("yrp_voice_channel_passive", c)
end

util.AddNetworkString("mutemic_channel")
net.Receive("mutemic_channel", function(len, ply)
	local uid = net.ReadString()

	ply:SetNW2Bool("yrp_voice_channel_mutemic_" .. uid, !ply:GetNW2Bool("yrp_voice_channel_mutemic_" .. uid, true))
	YRPCountActiveChannels(ply)
end)

util.AddNetworkString("mute_channel")
net.Receive("mute_channel", function(len, ply)
	local uid = net.ReadString()

	ply:SetNW2Bool("yrp_voice_channel_mute_" .. uid, !ply:GetNW2Bool("yrp_voice_channel_mute_" .. uid, false))
	YRPCountPassiveChannels(ply)
end)

util.AddNetworkString("mutemic_channel_all")
net.Receive("mutemic_channel_all", function(len, ply)
	ply:SetNW2Bool("mutemic_channel_all", !ply:GetNW2Bool("mutemic_channel_all", false))

	for i, channel in pairs(GetGlobalTable("yrp_voice_channels", {})) do
		ply:SetNW2Bool("yrp_voice_channel_mutemic_" .. channel.uniqueID, ply:GetNW2Bool("mutemic_channel_all", false))
	end
	YRPCountActiveChannels(ply)
end)

util.AddNetworkString("mute_channel_all")
net.Receive("mute_channel_all", function(len, ply)
	ply:SetNW2Bool("mute_channel_all", !ply:GetNW2Bool("mute_channel_all", false))

	for i, channel in pairs(GetGlobalTable("yrp_voice_channels", {})) do
		ply:SetNW2Bool("yrp_voice_channel_mute_" .. channel.uniqueID, ply:GetNW2Bool("mute_channel_all", false))
	end
	YRPCountPassiveChannels(ply)
end)

function GM:PlayerCanHearPlayersVoice(listener, talker)
	if listener == talker then
		--return false
	end
	local canhear = false
	for i, channel in pairs(GetGlobalTable("yrp_voice_channels", {})) do
		if IsActiveInChannel(talker, channel.uniqueID) and IsInChannel(listener, channel.uniqueID) then -- If Talker allowed to talk and both are in that channel
			canhear = true
			break
		end
	end

	if canhear and !talker:GetNW2Bool("mute_voice", false) then
		return true
	else
		if IsInMaxVoiceRange(listener, talker) then
			if IsInSpeakRange(listener, talker) then
				return true
			end
		end
	end
end

function setbodygroups(ply)
	local chaTab = ply:GetChaTab()
	if wk(chaTab) then
		ply:SetSkin(chaTab.skin)
		ply:SetupHands()
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
	if GetGlobalBool("bool_graffiti_disabled", false) then
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

	if YRP_NETWORK_TYPE == 0 then
		for i, p in pairs(player.GetAll()) do
			SendDEntities(p, "PostCleanupMap")
		end
	end

	loadDoors()
	LoadWorldStorages()
end
