--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local leftedPlys = {}
function GM:PlayerDisconnected(ply)
	printGM("gm", "[PlayerDisconnected] " .. ply:YRPName())
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
end

function GM:PlayerConnect(name, ip)
	printGM("gm", "[PlayerConnect] Name: " .. name .. " (IP: " .. ip .. ")")
	PrintMessage(HUD_PRINTTALK, name .. " is connecting to the Server.")
end

function GM:PlayerInitialSpawn(ply)
	--printGM("gm", "[PlayerInitialSpawn] " .. ply:YRPName())

	if !IsValid(ply) then return end

	if IsValid(ply) and ply.KillSilent then
		ply:KillSilent()
	end

	if ply:HasCharacterSelected() then
		local rolTab = ply:GetRolTab()
		if wk(rolTab) then
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
	printGM("gm", "[PlayerAuthed] " .. ply:YRPName() .. " | " .. tostring(steamid) .. " | " .. tostring(uniqueid))

	ply:SetDBool("isserverdedicated", game.IsDedicated())

	ply:resetUptimeCurrent()
	check_yrp_client(ply, steamid or uniqueID)

	if IsValid(ply) and ply.KillSilent then
		ply:KillSilent()
	end
end)

YRP = YRP or {}

function YRP:Loadout(ply)
	printGM("gm", "[Loadout] " .. ply:YRPName() .. " get YourRP Loadout.")
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
		printGM("gm", "[PlayerLoadout] " .. ply:YRPName() .. " get his role equipment.")
		YRP:Loadout(ply)

		if ply:HasCharacterSelected() then
			--[[ Status Reset ]]--
			ply:SetDBool("cuffed", false)
			ply:SetDBool("broken_leg_left", false)
			ply:SetDBool("broken_leg_right", false)
			ply:SetDBool("broken_arm_left", false)
			ply:SetDBool("broken_arm_right", false)

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
					ply:SetDString("rpdescription", SQL_STR_OUT(chaTab.rpdescription))
					for i, v in pairs(string.Explode("\n", chaTab.rpdescription)) do
						ply:SetDString("rpdescription" .. i, SQL_STR_OUT(v))
					end

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
				ply:SetDFloat("GetCurHygiene", 100)
				ply:SetDFloat("GetCurRadiation", 0)
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
		if IsValid(ply.rd) then
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
			YRP.msg("error", "Spawn Defi Ragdoll... FAILED: ply.rd is not valid")
		end
	end
end

hook.Add("DoPlayerDeath", "yrp_player_spawn_DoPlayerDeath", function(ply, attacker, dmg)

	if attacker.SteamID64 and ply.SteamID64 then
		SQL_INSERT_INTO("yrp_logs",	"string_timestamp, string_typ, string_source_steamid, string_target_steamid, string_value",	"'" .. os.time() .. "' ,'LID_kills', '" .. attacker:SteamID64() .. "', '" .. ply:SteamID64() .. "', '" .. dmg:GetDamage() .. "'")
	end

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
			if wep:GetModel() != "" and IsNoDefaultWeapon(wep:GetClass()) and IsNoRoleSwep(ply, wep:GetClass()) and IsNoUserGroupWeapon(ply, wep:GetClass()) and IsNoNotDroppableRoleSwep(ply, wep:GetClass()) then
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

hook.Add("ScalePlayerDamage", "YRP_ScalePlayerDamage", function(ply, hitgroup, dmginfo)
	if ply:IsFullyAuthenticated() then

		if IsInsideSafezone(ply) then
			dmginfo:ScaleDamage(0)
		else
			if dmginfo:GetAttacker() != ply then
				StartCombat(ply)
			end

			SlowThink(ply)

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

							--ply:SetActiveWeapon("yrp_unarmed")
							ply:SelectWeapon("yrp_unarmed")
						elseif hitgroup == HITGROUP_RIGHTARM then
							ply:SetDBool("broken_arm_right", true)

							--ply:SetActiveWeapon("yrp_unarmed")
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
		end
	end

	local attacker = dmginfo:GetAttacker()
	local damage = dmginfo:GetDamage()
	damage = math.Round(damage, 2)
	if attacker:IsPlayer() then
		SQL_INSERT_INTO("yrp_logs",	"string_timestamp, string_typ, string_source_steamid, string_target_steamid, string_value", "'" .. os.time() .. "' ,'LID_health', '" .. attacker:SteamID64() .. "', '" .. ply:SteamID64() .. "', '" .. dmginfo:GetDamage() .. "'")
	else
		SQL_INSERT_INTO("yrp_logs",	"string_timestamp, string_typ, string_target_steamid, string_value, string_alttarget", "'" .. os.time() .. "' ,'LID_health', '" .. ply:SteamID64() .. "', '" .. damage .. "', '" .. attacker:GetName() .. attacker:GetClass() .. "'")	
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

util.AddNetworkString("leave_channel_sound")
util.AddNetworkString("join_channel_sound")
function SendJoinLeave(ply, old, new)
	for i, p in pairs(player.GetAll()) do
		if p != ply then
			if old == p:GetDFloat("voice_channel", 0.1, 1) then
				net.Start("leave_channel_sound")
				net.Send(p)
			elseif new == p:GetDFloat("voice_channel", 0.1, 1) then
				net.Start("join_channel_sound")
				net.Send(p)
			end
		end
	end
end

--[[ SPEAK Channels ]] --
util.AddNetworkString("press_speak_next")
net.Receive("press_speak_next", function(len, ply)
	if GetGlobalDBool("bool_voice", false) then
		if GetGlobalDBool("bool_voice_channels", false) then
			ply:SetDInt("speak_channel", ply:GetDInt("speak_channel", 0) + 1)
			if ply:GetDInt("speak_channel", 0) == 2 then
				if !ply:GetDBool("yrp_voice_faction", false) then
					ply:SetDInt("speak_channel", 3)
				end
			end
			if ply:GetDInt("speak_channel", 0) == 3 then
				if !ply:GetDBool("yrp_voice_global", false) then
					ply:SetDInt("speak_channel", 0)
				end
			end
			if ply:GetDInt("speak_channel", 0) > 3 then
				ply:SetDInt("speak_channel", 0)
			end
		elseif GetGlobalDBool("bool_voice_radio", false) then
			ply.speakinterval = ply.speakinterval or 0
			ply.speakdir = ply.speakdir or 1
			ply.speakdelay = ply.speakdelay or CurTime()
			if ply.speakdelay < CurTime() then
				ply.speakdelay = CurTime() + 0.1
				ply.speakdir = 0
			end
			if ply.speakdir == 1 then
				ply.speakinterval = 1
			else
				ply.speakinterval = 0.1
			end
			ply.speakdir = 1
			local oldchannel = ply:GetDFloat("voice_channel", 0.1, 1)
			local newchannel = oldchannel + ply.speakinterval
			local min = 0.1
			if ply:GetDBool("yrp_voice_global", false) then
				min = 0.0
			end
			newchannel = math.Clamp(newchannel, min, 110,0)
			ply:SetDFloat("voice_channel", newchannel)

			SendJoinLeave(ply, oldchannel, newchannel)
		end
	end
end)

util.AddNetworkString("press_speak_prev")
net.Receive("press_speak_prev", function(len, ply)
	if GetGlobalDBool("bool_voice", false) then
		if GetGlobalDBool("bool_voice_channels", false) then
			ply:SetDInt("speak_channel", ply:GetDInt("speak_channel", 0) - 1)
			if ply:GetDInt("speak_channel", 0) < 0 then
				if ply:GetDBool("yrp_voice_global", false) then
					ply:SetDInt("speak_channel", 3)
				elseif ply:GetDBool("yrp_voice_faction", false) then
					ply:SetDInt("speak_channel", 2)
				else
					ply:SetDInt("speak_channel", 1)
				end
			elseif ply:GetDInt("speak_channel", 0) == 2 then
				if !ply:GetDBool("yrp_voice_faction", false) then
					ply:SetDInt("speak_channel", 1)
				end
			end
		elseif GetGlobalDBool("bool_voice_radio", false) then
			ply.speakinterval = ply.speakinterval or 0
			ply.speakdir = ply.speakdir or -1
			ply.speakdelay = ply.speakdelay or CurTime()
			if ply.speakdelay < CurTime() then
				ply.speakdelay = CurTime() + 0.1
				ply.speakdir = 0
			end
			if ply.speakdir == -1 then
				ply.speakinterval = 1
			else
				ply.speakinterval = 0.1
			end
			ply.speakdir = -1
			local oldchannel = ply:GetDFloat("voice_channel", 0.1, 1)
			local newchannel = oldchannel - ply.speakinterval
			local min = 0.1
			if ply:GetDBool("yrp_voice_global", false) then
				min = 0.0
			end
			newchannel = math.Clamp(newchannel, min, 110,0)
			ply:SetDFloat("voice_channel", newchannel)

			SendJoinLeave(ply, oldchannel, newchannel)
		end
	end
end)

util.AddNetworkString("yrp_voice_start")
net.Receive("yrp_voice_start", function(len, ply)
	if GetGlobalDBool("bool_voice", false) then
		ply:SetDBool("yrp_speaking", true)
		if ply:GetDString("speak_channel") == 3 then
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

util.AddNetworkString("yrp_mute_voice")
net.Receive("yrp_mute_voice", function(len, ply)
	ply:SetDBool("mute_voice", !ply:GetDBool("mute_voice", false))
end)

function HearFaded(listener, talker)
	local t_speak_channel = tonumber(talker:GetDInt("speak_channel", 0))
	local t_guid = tonumber(talker:GetDString("groupUniqueID", "0"))
	local l_guid = tonumber(listener:GetDString("groupUniqueID", "0"))
	local t_fuid = tonumber(talker:GetDString("factionUniqueID", "0"))
	local l_fuid = tonumber(listener:GetDString("factionUniqueID", "0"))
	if t_speak_channel == 0 or t_speak_channel == 1 and t_guid != l_guid or t_speak_channel == 2 and t_fuid != l_fuid then
		return true -- if talker is local or global and not in same group
	else
		return false
	end
	return false
end

function CanHear(listener, talker)
	local t_speak_channel = tonumber(talker:GetDInt("speak_channel", 0))
	local t_guid = tonumber(talker:GetDString("groupUniqueID", "0"))
	local l_guid = tonumber(listener:GetDString("groupUniqueID", "0"))
	local t_fuid = tonumber(talker:GetDString("factionUniqueID", "0"))
	local l_fuid = tonumber(listener:GetDString("factionUniqueID", "0"))
	local dist = listener:GetPos():Distance(talker:GetPos())
	--p(t_speak_channel,"GROUP",t_guid,l_guid, "FACTION", t_fuid ,l_fuid)
	if t_speak_channel == 3 then -- GLOBAL
		--p(listener, talker, "GLOBAL ||| t_speak_channel == 3")
		return true -- if talker is globalvoice
	elseif t_speak_channel == 2 and t_fuid == l_fuid then
		--p(listener, talker, "SAME FACTION ||| t_speak_channel == 2 and t_fuid == l_fuid")
		return true -- if talker is factionvoice and same faction
	elseif t_speak_channel == 1 and t_guid == l_guid then
		--p(listener, talker, "SAME GROUP ||| t_speak_channel == 1 and t_guid == l_guid")
		return true -- if talker is groupvoice and same group
	elseif t_speak_channel == 0 and dist < GetVoiceChatLocalRange() and IsLocalGroupVoiceChatEnabled() then
		--p(listener, talker, "GROUP LOCAL VOICE RANGE |||| dist < GetVoiceChatLocalRange() and IsLocalGroupVoiceChatEnabled()")
		return true -- is near groupvoicerange
	elseif dist < GetVoiceChatLocalRange() then -- LOCAL
		--p(listener, talker, "LOCAL VOICE RANGE |||| dist < GetVoiceChatLocalRange()")
		return true -- if near local range
	else
		return false
	end
end

function HearFadedChannel(listener, talker)
	local l_speak_channel = tonumber(listener:GetDFloat("voice_channel", 0.1, 1))
	local t_speak_channel = tonumber(talker:GetDFloat("voice_channel", 0.1, 1))
	local dist = listener:GetPos():Distance(talker:GetPos())
	if t_speak_channel != l_speak_channel and t_speak_channel == 0.0 or dist < GetMaxVoiceRange() then
		return true
	end
	return false
end

function CanHearChannel(listener, talker)
	local l_speak_channel = tonumber(listener:GetDFloat("voice_channel", 0.1, 1))
	local t_speak_channel = tonumber(talker:GetDFloat("voice_channel", 0.1, 1))
	local dist = listener:GetPos():Distance(talker:GetPos())
	if (listener:GetDBool("mute_voice", false) and dist < GetMaxVoiceRange()) or !listener:GetDBool("bool_canusefrequencies", false) then
		return true, true
	elseif t_speak_channel == l_speak_channel or t_speak_channel == 0.0 or dist < GetMaxVoiceRange() then
		return true
	end
	return false
end

function IsInMaxVoiceRange(listener, talker)
	local dist = listener:GetPos():Distance(talker:GetPos())
	local result = dist <= GetGlobalDInt("int_voice_max_range", 1)
	--p(listener, talker, result)
	return result
end

function GM:PlayerCanHearPlayersVoice(listener, talker)
	if IsVoiceEnabled() then
		if listener != talker then
			if Is3DVoiceEnabled() then
				if IsVoiceChannelsEnabled() then
					return CanHear(listener, talker), HearFaded(listener, talker)	-- 3D Voice chat + voice channels
				elseif IsVoiceRadioEnabled() then
					return CanHearChannel(listener, talker)--, HearFadedChannel(listener, talker)
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

	for i, p in pairs(player.GetAll()) do
		SendDEntities(p, "PostCleanupMap")
	end

	loadDoors()
	LoadWorldStorages()
end




-- TEST - TODO
--[[
function sendToDiscord(msg)
	msg = msg or ""

	local data = {
		["username"] = "TESTNAME",
		["icon_url"] = "http://i.imgur.com/XLgutLX.png",
		["text"] = "test"
	}

	local newdata = util.TableToJSON(data)

	http.Post(
	"https://discordapp.com/api/webhooks/646291405194657802/TOkSVYZeXojEa0OR4bCOOZHv7AZdY76IdZ6OVJK3WRG4EAW4pYnRronMnhrrpGnIA45M",
	newdata,
	function( result, ... )
		if result then
			p( "Done!" )
			p(result, ...)
		end
	end,
	function( failed )
		p( failed )
	end,
	{["Content-Type"] = "application/json"}
	)
end
--sendToDiscord("TEST")
]]
