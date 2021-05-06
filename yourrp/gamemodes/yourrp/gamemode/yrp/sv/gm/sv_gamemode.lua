--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local leftedPlys = {}
function GM:PlayerDisconnected(ply)
	YRP.msg("gm", "[PlayerDisconnected] " .. ply:YRPName())
	save_clients("PlayerDisconnected")

	SQL_INSERT_INTO("yrp_logs", "string_timestamp, string_typ, string_source_steamid, string_value", "'" .. os.time() .. "' ,'LID_connections', '" .. ply:SteamID64() .. "', '" .. "disconnected" .. "'")

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

	ply:SetDBool("isserverdedicated", game.IsDedicated())

	ply:resetUptimeCurrent()
	check_yrp_client(ply, steamid or uniqueID)

	if IsValid(ply) and ply.KillSilent then
		ply:KillSilent()
	end
end)

YRP = YRP or {}

function YRP:Loadout(ply)
	--YRP.msg("gm", "[Loadout] " .. ply:YRPName() .. " get YourRP Loadout.")
	ply:SetDBool("bool_loadouted", false)

	ply:SetDInt("speak_channel", 0)

	ply:UserGroupLoadout()

	ply:LockdownLoadout()

	ply:LevelSystemLoadout()
	ply:CharacterLoadout()

	ply:SetDBool("bool_loadouted", true)

	if IsValid(ply.rd) then
		ply.rd:Remove()
	end
end

hook.Add("PlayerLoadout", "yrp_PlayerLoadout", function(ply)
	if ply:IsValid() then
		ply:SetDString("licenseIDs", "")
		ply:SetDString("licenseNames", "")

		ply:StripWeapons()
		--YRP.msg("gm", "[PlayerLoadout] " .. ply:YRPName() .. " get his role equipment.")
		YRP:Loadout(ply)

		if ply:HasCharacterSelected() then
			--[[ Status Reset ]]--
			ply:SetDBool("cuffed", false)
			ply:SetDBool("broken_leg_left", false)
			ply:SetDBool("broken_leg_right", false)
			ply:SetDBool("broken_arm_left", false)
			ply:SetDBool("broken_arm_right", false)

			--ply:Give("yrp_unarmed")

			local plyT = ply:GetPlyTab()
			if wk(plyT) then
				plyT.CurrentCharacter = tonumber(plyT.CurrentCharacter)
				if plyT.CurrentCharacter != -1 then
					ply:SetDInt("yrp_charid", tonumber(plyT.CurrentCharacter))
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
					ply:SetDString("money", chaTab.money)
					ply:SetDString("moneybank", chaTab.moneybank)
					ply:SetDString("rpname", SQL_STR_OUT(chaTab.rpname))
					ply:SetDString("rpdescription", SQL_STR_OUT(chaTab.rpdescription))
					for i, v in pairs(string.Explode("\n", chaTab.rpdescription)) do
						ply:SetDString("rpdescription" .. i, SQL_STR_OUT(v))
					end

					setbodygroups(ply)
				else
					YRP.msg("note", "Give char failed -> KillSilent -> " .. ply:YRPName() .. " char: " .. tostring(chaTab))
					if !ply:IsBot() then
						ply:KillSilent()
					end
				end

				--ply:EquipWeapons()

				ply:SetDFloat("hunger", 100)
				ply:SetDFloat("thirst", 100)
				ply:SetDFloat("GetCurHygiene", 100)
				ply:SetDFloat("GetCurRadiation", 0)
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
	if ply:GetDBool("can_respawn", false) then
		ply:SetDBool("can_respawn", false)

		ply:SetupHands()

		timer.Simple(1.0, function()
			if ply:HasCharacterSelected() then
				teleportToSpawnpoint(ply)
				ply:SetDBool("yrp_spawning", false)
			else
				teleportToSpawnpoint(ply)
				ply:SetDBool("yrp_spawning", false)
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

		ply:SetDInt("yrp_stars", 0)
		ply:SetDFloat("permille", 0.0)

		ply:SetDBool("can_respawn", true)
	end
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

	if GetGlobalDBool("bool_characters_removeondeath", false) then
		local test = SQL_UPDATE("yrp_characters", "bool_archived = '1'", "uniqueID = '" .. victim:CharID() .. "'")
		victim:SetDBool("yrp_chararchived", true)
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
	if GetGlobalDBool("bool_drop_items_role", false) then
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

	ply:SetDInt("int_deathtimestamp_min", CurTime() + GetGlobalDInt("int_deathtimestamp_min", 20))
	ply:SetDInt("int_deathtimestamp_max", CurTime() + GetGlobalDInt("int_deathtimestamp_max", 60))

	-- NEW RAGDOLL
	if GetGlobalDBool("bool_spawncorpseondeath", true) then
	
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

			ply:SetDInt("ent_ragdollindex", ply.rd:EntIndex())

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
	local _reward = tonumber(ply:GetDString("hitreward"))
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
	if IsDropMoneyOnDeathEnabled() and !ply:GetDBool("switchrole", false) then
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

	if ( pl:GetDInt("int_deathtimestamp_max", 0) > CurTime() ) then
		return
	end

	if ( pl:IsBot() || pl:KeyPressed( IN_ATTACK ) || pl:KeyPressed( IN_ATTACK2 ) || pl:KeyPressed( IN_JUMP ) ) then

		pl:Spawn()

	end

end

function GM:ShutDown()
	save_clients("Shutdown/Changelevel")
	--SaveStorages("Shutdown/Changelevel")
end

function GM:GetFallDamage(ply, speed)
	local _damage = speed * CustomFalldamageMultiplier()
	if ply:GetDString("GetAbilityType", "none") == "force" then
		return 0
	end
	if IsCustomFalldamageEnabled() then
		if speed > ply:GetModelScale() * 120 then
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
		-- Set default HoldType of currentweapon
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
	elseif ent:IsVehicle() then
		local hitfactor = GetHitFactorVehicles() or 1
		dmginfo:ScaleDamage(hitfactor)
	elseif ent:IsPlayer() then
		if GetGlobalDBool("bool_antipropkill", true) then
			if dmginfo:GetAttacker():GetClass() == "prop_physics" then
				dmginfo:ScaleDamage(0)
			end
		end
		if dmginfo:GetDamageType() == DMG_BURN then
			dmginfo:ScaleDamage(ent:GetDFloat("float_dmgtype_burn", 1.0))
		elseif dmginfo:GetDamageType() == DMG_BULLET then
			dmginfo:ScaleDamage(ent:GetDFloat("float_dmgtype_bullet", 1.0))
		elseif dmginfo:GetDamageType() == DMG_ENERGYBEAM then
			dmginfo:ScaleDamage(ent:GetDFloat("float_dmgtype_energybeam", 1.0))
		else
			dmginfo:ScaleDamage(1)
		end
	else
		dmginfo:ScaleDamage(1)
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

		if IsInsideSafezone(ply) or ply:HasGodMode() or ply:GetDBool("godmode", false) then
			dmginfo:ScaleDamage(0)
		else
			if dmginfo:GetAttacker() != ply then
				StartCombat(ply)
			end

			SlowThink(ply)

			if GetGlobalDBool("bool_antipropkill", true) then
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
							ply:SetDBool("broken_arm_left", true)

							if !ply:HasWeapon("yrp_unarmed") then
								ply:Give("yrp_unarmed")
							end
							ply:SelectWeapon("yrp_unarmed")
						elseif hitgroup == HITGROUP_RIGHTARM then
							ply:SetDBool("broken_arm_right", true)

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
							ply:SetDBool("broken_leg_left", true)
						elseif hitgroup == HITGROUP_RIGHTLEG then
							ply:SetDBool("broken_leg_right", true)
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
	if GetGlobalDBool("bool_voice", false) then
		ply:SetDBool("yrp_speaking", true)
	end
end)

util.AddNetworkString("yrp_voice_end")
net.Receive("yrp_voice_end", function(len, ply)
	ply:SetDBool("yrp_speaking", false)
end)

util.AddNetworkString("yrp_mute_voice")
net.Receive("yrp_mute_voice", function(len, ply)
	ply:SetDBool("mute_voice", !ply:GetDBool("mute_voice", false))
end)

util.AddNetworkString("yrp_voice_range_up")
net.Receive("yrp_voice_range_up", function(len, ply)
	ply:SetDInt("voice_range", math.Clamp(ply:GetDInt("voice_range", 2) + 1, 0, 4))
end)

util.AddNetworkString("yrp_voice_range_dn")
net.Receive("yrp_voice_range_dn", function(len, ply)
	ply:SetDInt("voice_range", math.Clamp(ply:GetDInt("voice_range", 2) - 1, 0, 4))
end)



-- VOICE CHANNELS
local DATABASE_NAME = "yrp_voice_channels"

SQL_ADD_COLUMN(DATABASE_NAME, "string_name", "TEXT DEFAULT 'Unnamed'")

SQL_ADD_COLUMN(DATABASE_NAME, "string_mode", "TEXT DEFAULT '0'") -- 0 = Normal, 1 = Global

SQL_ADD_COLUMN(DATABASE_NAME, "int_position", "TEXT DEFAULT '0'")

SQL_ADD_COLUMN(DATABASE_NAME, "string_active_usergroups", "TEXT DEFAULT 'superadmin,user'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_active_groups", "TEXT DEFAULT '1'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_active_roles", "TEXT DEFAULT '1'")

SQL_ADD_COLUMN(DATABASE_NAME, "string_passive_usergroups", "TEXT DEFAULT 'superadmin,user'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_passive_groups", "TEXT DEFAULT '1'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_passive_roles", "TEXT DEFAULT '1'")

--SQL_DROP_TABLE(DATABASE_NAME)

local yrp_voice_channels = {}
if SQL_SELECT(DATABASE_NAME, "*") == nil then
	SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_mode, string_active_usergroups, string_passive_usergroups", "'DEFAULT', 0, 'superadmin, admin, user', 'superadmin, admin, user'")
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

	SetGlobalDTable("yrp_voice_channels", yrp_voice_channels)
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

	local augs = table.concat(net.ReadTable(), ",")
	local agrps = table.concat(net.ReadTable(), ",")
	local arols = table.concat(net.ReadTable(), ",")

	local pugs = table.concat(net.ReadTable(), ",")
	local pgrps = table.concat(net.ReadTable(), ",")
	local prols = table.concat(net.ReadTable(), ",")

	SQL_INSERT_INTO(
		DATABASE_NAME,
		"string_name, string_active_usergroups, string_active_groups, string_active_roles, string_passive_usergroups, string_passive_groups, string_passive_roles, int_position",
		"'" .. name .. "', '" .. augs .. "', '" .. agrps .. "', '" .. arols .. "', '" .. pugs .. "', '" .. pgrps .. "', '" .. prols	.. "', '" .. table.Count(GetGlobalDTable("yrp_voice_channels", {})) .. "'"
	)

	GenerateVoiceTable()

	local c = 0
	for i, channel in SortedPairsByMemberValue(GetGlobalDTable("yrp_voice_channels", {}), "int_position") do
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

	local augs = table.concat(net.ReadTable(), ",")
	local agrps = table.concat(net.ReadTable(), ",")
	local arols = table.concat(net.ReadTable(), ",")

	local pugs = table.concat(net.ReadTable(), ",")
	local pgrps = table.concat(net.ReadTable(), ",")
	local prols = table.concat(net.ReadTable(), ",")

	local uid = net.ReadString()
	
	SQL_UPDATE(
		DATABASE_NAME,
		"string_name = '" .. name .. "', string_active_usergroups = '" .. augs .. "', string_active_groups = '" .. agrps .. "', string_active_roles = '" .. arols .. "', string_passive_usergroups = '" .. pugs .. "', string_passive_groups = '" .. pgrps .. "', string_passive_roles = '" .. prols .. "'",
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
	for i, channel in SortedPairsByMemberValue(GetGlobalDTable("yrp_voice_channels", {}), "int_position") do
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

	local int_position = GetGlobalDTable("yrp_voice_channels", {})[uid].int_position

	local c = 0
	for i, channel in SortedPairsByMemberValue(GetGlobalDTable("yrp_voice_channels", {}), "int_position") do
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

	local int_position = GetGlobalDTable("yrp_voice_channels", {})[uid].int_position

	local c = 0
	for i, channel in SortedPairsByMemberValue(GetGlobalDTable("yrp_voice_channels", {}), "int_position") do
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

util.AddNetworkString("mutemic_channel")
net.Receive("mutemic_channel", function(len, ply)
	local uid = net.ReadString()

	ply:SetDBool("yrp_voice_channel_mutemic_" .. uid, !ply:GetDBool("yrp_voice_channel_mutemic_" .. uid, true))
end)

util.AddNetworkString("mute_channel")
net.Receive("mute_channel", function(len, ply)
	local uid = net.ReadString()

	ply:SetDBool("yrp_voice_channel_mute_" .. uid, !ply:GetDBool("yrp_voice_channel_mute_" .. uid, false))
end)

function GM:PlayerCanHearPlayersVoice(listener, talker)
	if listener == talker then
		--return false
	end
	local canhear = false
	for i, channel in pairs(GetGlobalDTable("yrp_voice_channels", {})) do
		if IsActiveInChannel(talker, channel) and IsInChannel(listener, channel) then -- If Talker allowed to talk and both are in that channel
			canhear = true
			break
		end
	end

	if canhear and !talker:GetDBool("mute_voice", false) then
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

	for i, p in pairs(player.GetAll()) do
		SendDEntities(p, "PostCleanupMap")
	end

	loadDoors()
	LoadWorldStorages()
end

