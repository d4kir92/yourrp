--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
hook.Add(
	"PlayerStartTaunt",
	"yrp_taunt_start",
	function(ply, act, length)
		ply:SetYRPBool("taunting", true)
		timer.Simple(
			length,
			function()
				if IsValid(ply) then
					ply:SetYRPBool("taunting", false)
				end
			end
		)
	end
)

util.AddNetworkString("nws_yrp_client_lang")
net.Receive(
	"nws_yrp_client_lang",
	function(len, ply)
		local _lang = net.ReadString()
		--YRP.msg( "db", ply:YRPName() .. " using language: " .. string.upper(_lang) )
		ply:SetYRPString("client_lang", _lang or "NONE")
	end
)

function YDeath(ply)
	ply:Kill()
end

function YRPConHP(ply)
	local hpreg = ply:GetYRPInt("HealthReg", nil)
	if IsNotNilAndNotFalse(hpreg) and ply:Alive() then
		if ply:Health() <= 0 then
			YDeath(ply)
		end

		ply:Heal(hpreg)
		if ply:Health() <= 0 then
			YDeath(ply)
		end
	end
end

function YRPConAR(ply)
	local arreg = ply:GetYRPInt("ArmorReg")
	if arreg ~= nil then
		ply:SetArmor(ply:Armor() + arreg)
		if ply:Armor() > ply:GetYRPInt("MaxArmor") then
			ply:SetArmor(ply:GetYRPInt("MaxArmor"))
		elseif ply:Armor() < 0 then
			ply:SetArmor(0)
		end
	end
end

function IsCookPlaying()
	for i, v in pairs(player.GetAll()) do
		if v:isCook() then return true end
	end

	return false
end

function YRPConHG(ply, time)
	if not IsValid(ply) then return false end
	if GetGlobalYRPBool("bool_onlywhencook", false) and not IsCookPlaying() then return false end
	local newval = tonumber(ply:GetYRPFloat("hunger", 0.0)) - 0.01 * GetGlobalYRPFloat("float_scale_hunger", 1.0)
	newval = math.Clamp(newval, 0.0, 100.0)
	ply:YRPSetHunger(newval)
	ply.DarkRPVars = ply.DarkRPVars or {}
	ply.DarkRPVars.Energy = newval
	if tonumber(ply:GetYRPFloat("hunger", 0.0)) < 20.0 then
		ply:TakeDamage(ply:GetMaxHealth() / 50, ply)
	elseif GetGlobalYRPBool("bool_hunger_health_regeneration", false) then
		local tickrate = tonumber(GetGlobalYRPString("text_hunger_health_regeneration_tickrate", 1))
		if tickrate >= 1 and time % tickrate == 0 then
			ply:SetHealth(math.Clamp(ply:Health() + 1, 0, ply:GetMaxHealth()))
		end
	end
end

function YRPConTH(ply)
	if not IsValid(ply) then return end
	local newval2 = tonumber(ply:GetYRPFloat("permille", 0.0)) - 0.01 * GetGlobalYRPFloat("float_scale_permille", 1.0)
	newval2 = math.Clamp(newval2, 0.0, ply:GetMaxPermille())
	if ply:GetYRPFloat("permille") ~= newval2 then
		ply:SetYRPFloat("permille", newval2)
	end

	if GetGlobalYRPBool("bool_onlywhencook", false) and not IsCookPlaying() then return false end
	local newval = tonumber(ply:GetYRPFloat("thirst", 0.0)) - 0.01 * GetGlobalYRPFloat("float_scale_thirst", 1.0)
	newval = math.Clamp(newval, 0.0, 100.0)
	ply:SetYRPFloat("thirst", newval)
	if tonumber(ply:GetYRPFloat("thirst", 0.0)) < 20.0 then
		ply:TakeDamage(ply:GetMaxHealth() / 50)
	end
end

function YRPConRA(ply)
	if not IsValid(ply) then return end
	if IsInsideRadiation(ply) then
		ply:SetYRPFloat("GetCurRadiation", math.Clamp(tonumber(ply:GetYRPFloat("GetCurRadiation", 0.0)) + 0.01 * GetGlobalYRPFloat("float_scale_radiation_in", 50.0), 0, 100))
	else
		ply:SetYRPFloat("GetCurRadiation", math.Clamp(tonumber(ply:GetYRPFloat("GetCurRadiation", 0.0)) - 0.01 * GetGlobalYRPFloat("float_scale_radiation_out", 8.0), 0, 100))
	end

	if tonumber(ply:GetYRPFloat("GetCurRadiation", 0.0)) > 80.0 then
		ply:TakeDamage(ply:GetMaxHealth() / 50, ply)
	end
end

function YRPConST(ply, _time)
	if not IsValid(ply) then return false end
	if ply:GetMoveType() == MOVETYPE_NOCLIP then
		local newval = ply:GetYRPFloat("GetCurStamina", 0) + 20
		newval = math.Round(math.Clamp(newval, 0, ply:GetYRPFloat("GetMaxStamina", 100)), 1)
		if ply:GetYRPFloat("GetCurStamina") ~= newval then
			ply:SetYRPFloat("GetCurStamina", newval)
		end
	end

	if ply.yrpjumping == nil then
		ply.yrpjumping = 1
	end

	if ply:GetMoveType() ~= MOVETYPE_NOCLIP and ply:GetMoveType() ~= MOVETYPE_LADDER and not ply:InVehicle() then
		ply.yrpjumpposz = ply.yrpjumpposz or ply:GetPos().z
		local onGround = true
		local height = nil
		local tr = util.TraceHull(
			{
				start = ply:GetPos(),
				endpos = ply:GetPos() + ply:GetUp() * -100,
				filter = ents.GetAll(),
				mins = Vector(-16, -16, -16),
				maxs = Vector(16, 16, 16),
				mask = MASK_SHOT_HULL
			}
		)

		--ply:GetPos(), ply:GetPos() * ply:GetUp() * -100, ents.GetAll())
		if tr.HitPos then
			height = ply:GetPos() - tr.HitPos
			height = height.z
			if height > 10 then
				onGround = false
			end
		end

		if height == 100 then
			height = 0
			onGround = true
		end

		if ply.yrpjumping == -2 then
			ply.yrpjumping = -1
			timer.Simple(
				1,
				function()
					ply.yrpjumping = 0
				end
			)
		elseif ply.yrpjumping == 0 then
			ply.yrpjumping = 1
		end

		-- LEAVE GROUND
		if ply.yrpjumping == 1 and not onGround then
			ply.yrpjumpposz = ply:GetPos().z
			ply.yrpjumping = 2
		elseif ply.yrpjumping == 2 then
			-- AFTER LEAVE GROUND
			-- UP, CONTINUE
			if ply.yrpjumpposz < ply:GetPos().z then
				ply.yrpjumping = 3
			else -- DOWN, RESET
				ply.yrpjumping = 1
				ply.yrpjumpposz = ply:GetPos().z
			end
		elseif ply.yrpjumping == 3 and onGround then
			-- FULL JUMP, remove stamina
			ply.yrpjumping = 1
			local newval = ply:GetYRPFloat("GetCurStamina", 0) - GetGlobalYRPFloat("float_scale_stamina_jump", 30)
			newval = math.Round(math.Clamp(newval, 0, ply:GetYRPFloat("GetMaxStamina", 100)), 1)
			if ply:GetYRPFloat("GetCurStamina") ~= newval then
				ply:SetYRPFloat("GetCurStamina", newval)
			end
		end
	else
		ply.yrpjumping = -2
	end

	if _time % 1.0 == 0 then
		if not ply:InVehicle() and ply:IsOnGround() then
			if ply:GetMoveType() ~= MOVETYPE_NOCLIP and (ply:KeyDown(IN_SPEED) and (ply:KeyDown(IN_FORWARD) or ply:KeyDown(IN_BACK) or ply:KeyDown(IN_MOVERIGHT) or ply:KeyDown(IN_MOVELEFT))) then
				local newval = ply:GetYRPFloat("GetCurStamina", 0) - ply:GetYRPFloat("stamindown", 1) * GetGlobalYRPFloat("float_scale_stamina_down", 1.0)
				newval = math.Round(math.Clamp(newval, 0, ply:GetYRPFloat("GetMaxStamina", 100)), 1)
				if ply:GetYRPFloat("GetCurStamina") ~= newval then
					ply:SetYRPFloat("GetCurStamina", newval)
				end
			elseif ply:GetYRPFloat("thirst", 0) > 20 then
				local factor = 1
				if ply:GetMoveType() == MOVETYPE_NOCLIP then
					factor = 10
				end

				local newval = ply:GetYRPFloat("GetCurStamina", 0) + ply:GetYRPFloat("staminup", 1) * GetGlobalYRPFloat("float_scale_stamina_up", 1.0) * factor
				newval = math.Round(math.Clamp(newval, 0, ply:GetYRPFloat("GetMaxStamina", 100)), 1)
				if ply:GetYRPFloat("GetCurStamina") ~= newval then
					ply:SetYRPFloat("GetCurStamina", newval)
				end
			end
		end

		if not ply:Slowed() then
			local rs = ply:GetYRPInt("speedrun", 0)
			local ws = ply:GetYRPInt("speedwalk", 0)
			local factor = 1
			if ply:GetYRPFloat("GetCurStamina", 0) <= 20 or ply:GetYRPFloat("thirst", 0) < 20 then
				factor = 0.6
			end

			if IsBonefracturingEnabled() and not ply:Slowed() then
				if ply:GetYRPBool("broken_leg_left") and ply:GetYRPBool("broken_leg_right") then
					factor = 0.5
				elseif ply:GetYRPBool("broken_leg_left") or ply:GetYRPBool("broken_leg_right") then
					factor = 0.25
				end
			end

			if factor == 1 then
				ply:SetCanWalk(true)
			else
				ply:SetCanWalk(false)
			end

			ply:SetRunSpeed(rs * factor)
			ply:SetWalkSpeed(ws * factor)
		end
	end
end

function YRPRegAB(ply)
	local reg = ply:GetYRPFloat("GetRegAbility", 0.0)
	local tick = ply:GetYRPFloat("GetRegTick", 1.0)
	ply.abdelay = ply.abdelay or 0
	ply.abdelay = math.Round(ply.abdelay, 1)
	if reg ~= 0.0 and ply.abdelay < CurTime() then
		ply.abdelay = CurTime() + tick
		ply:SetYRPInt("GetCurAbility", math.Clamp(ply:GetYRPInt("GetCurAbility", 0) + reg, 0, ply:GetYRPInt("GetMaxAbility")))
	end
end

function YRPTimeJail(ply)
	if ply:GetYRPBool("injail", false) then
		ply:SetYRPInt("jailtime", ply:GetYRPInt("jailtime", 0) - 1)
		if tonumber(ply:GetYRPInt("jailtime", 0)) <= 0 then
			clean_up_jail(ply)
		end
	end
end

function YRPCheckSalary(ply)
	if ply:GetYRPBool("moneyready", false) then
		local _m = ply:GetYRPString("money")
		local _ms = ply:GetYRPString("salary")
		if ply:Alive() and ply:HasCharacterSelected() and _m and _ms then
			local _money = tonumber(_m)
			local _salary = tonumber(_ms)
			if _money ~= nil and _salary ~= nil and CurTime() >= ply:GetYRPInt("nextsalarytime", 0) and ply:HasCharacterSelected() and ply:Alive() then
				ply:SetYRPInt("nextsalarytime", CurTime() + ply:GetYRPInt("salarytime"))
				ply:SetYRPString("money", _money + _salary)
				ply:UpdateMoney()
			end
		end
	end
	--YRP.msg( "note", "[CheckSalary] Player is not ready to get salary: " .. ply:YRPName() )
end

function YRPIsDealerAlive(uid)
	for j, ent in pairs(ents.GetAll()) do
		if ent and IsValid(ent) and ent:IsNPC() and tonumber(ent:GetYRPString("dealerID", "0")) == tonumber(uid) then return true end
	end

	return false
end

function YRPIsTeleporterAlive(uid)
	for j, tel in pairs(ents.GetAll()) do
		if tel and tel:GetClass() == "yrp_teleporter" then
			if tonumber(tel:GetYRPInt("yrp_teleporter_uid", -1)) ~= -1 and tonumber(tel:GetYRPInt("yrp_teleporter_uid", -1)) == tonumber(uid) then return true end
			tel.PermaProps = true
			tel.PermaProps_ID = 0
			tel.PermaPropsID = 0
		end
	end

	return false
end

util.AddNetworkString("nws_yrp_autoreload")
local _time = 0
local TICK = 0.1
local DEC = 1
local isTPsInstalled = true
timer.Remove("ServerThink")
timer.Create(
	"ServerThink",
	TICK,
	0,
	function()
		-- Every second
		if _time % 1.0 == 0 then
			for k, ply in pairs(player.GetAll()) do
				ply:AddPlayTime()
				local afkticktime = tonumber(GetGlobalYRPInt("int_afkkicktime", 0))
				if afkticktime > 0 and ply:AFK() and not ply:HasAccess("afk", true) and CurTime() - tonumber(ply:GetYRPFloat("afkts", 0)) >= afkticktime then
					ply:SetYRPBool("isafk", false)
					ply:Kick("AFK")
				end

				if ply:GetYRPBool("loaded", false) then
					if not ply:GetYRPBool("inCombat") then
						YRPConHP(ply) --HealthReg
						YRPConAR(ply) --ArmorReg
						if ply:GetYRPInt("yrp_stars", 0) ~= 0 then
							ply:SetYRPInt("yrp_stars", 0)
						end
					end

					if ply:IsBleeding() then
						local effect = EffectData()
						effect:SetOrigin(ply:GetPos() - ply:GetBleedingPosition())
						effect:SetScale(1)
						util.Effect("bloodimpact", effect)
						if ply:Alive() then
							ply:TakeDamage(0.5, ply, ply)
						end
					end

					if GetGlobalYRPBool("bool_hunger", false) and ply:GetYRPBool("bool_hunger", false) and YRPConHG then
						YRPConHG(ply, _time)
					end

					if GetGlobalYRPBool("bool_thirst", false) and ply:GetYRPBool("bool_thirst", false) and YRPConTH then
						YRPConTH(ply)
					end

					if GetGlobalYRPBool("bool_radiation", false) and YRPConRA then
						YRPConRA(ply)
					end

					YRPTimeJail(ply)
					YRPCheckSalary(ply)
				end
			end

			if GetGlobalYRPBool("bool_radiation", false) then
				for k, ent in pairs(ents.GetAll()) do
					if ent and YRPEntityAlive(ent) and ent:IsNPC() then
						YRPConRA(ent)
					end
				end
			end
		end

		-- Every 0.1 seconds
		for k, ply in pairs(player.GetAll()) do
			if ply:GetYRPBool("loaded", false) then
				-- Every 0.1
				YRPRegAB(ply)
				if GetGlobalYRPBool("bool_stamina", false) and ply:GetYRPBool("bool_stamina", false) then
					YRPConST(ply, _time)
				end
			end
		end

		if _time % 60.0 == 1 and YRP.XPPerMinute ~= nil then
			local xp_per_minute = YRP.XPPerMinute()
			for i, p in pairs(player.GetAll()) do
				p:AddXP(xp_per_minute)
			end
		end

		if _time % 30.0 == 1 or GetGlobalYRPBool("nws_yrp_update_teleporters", false) then
			if GetGlobalYRPBool("nws_yrp_update_teleporters", true) ~= false then
				SetGlobalYRPBool("nws_yrp_update_teleporters", false)
			end

			local _dealers = YRP_SQL_SELECT("yrp_dealers", "*", "map = '" .. GetMapNameDB() .. "'")
			if IsNotNilAndNotFalse(_dealers) then
				for i, dealer in pairs(_dealers) do
					if tonumber(dealer.uniqueID) ~= 1 and not YRPIsDealerAlive(dealer.uniqueID) then
						local _del = YRP_SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = 'dealer' AND linkID = '" .. dealer.uniqueID .. "'")
						if _del ~= nil then
							YRP.msg("gm", "DEALER [" .. dealer.name .. "] NOT ALIVE, reviving!")
							_del = _del[1]
							local _dealer = ents.Create("yrp_dealer")
							if _dealer then
								_dealer:SetYRPString("dealerID", dealer.uniqueID)
								_dealer:SetYRPString("name", dealer.name)
								local _pos = string.Explode(",", _del.position)
								_pos = Vector(_pos[1], _pos[2], _pos[3])
								_dealer:SetPos(_pos)
								local _ang = string.Explode(",", _del.angle)
								_ang = Angle(0, _ang[2], 0)
								_dealer:SetAngles(_ang)
								_dealer:SetModel(dealer.WorldModel)
								_dealer:Spawn()
								timer.Simple(
									1,
									function()
										if YRPEntityAlive(_dealer.Entity) then
											_dealer.Entity:LookupSequence("idle_all_01")
											_dealer.Entity:ResetSequence("idle_all_01")
										end
									end
								)
							end
						end
					end
				end
			end

			if YRP_SQL_TABLE_EXISTS("yrp_teleporters") and isTPsInstalled then
				local teleporters = YRP_SQL_SELECT("yrp_teleporters", "*", "string_map = '" .. game.GetMap() .. "'")
				if IsNotNilAndNotFalse(teleporters) then
					if table.Count(teleporters) >= 100 then
						YRP.msg("note", "There are to many Teleporters created!")
					end

					for i, teleporter in pairs(teleporters) do
						if not YRPIsTeleporterAlive(teleporter.uniqueID) then
							local tp = ents.Create("yrp_teleporter")
							if IsValid(tp) then
								local pos = string.Explode(",", teleporter.string_position)
								pos = Vector(pos[1], pos[2], pos[3])
								tp:SetPos(pos - tp:GetUp() * 5)
								local ang = string.Explode(",", teleporter.string_angle)
								ang = Angle(ang[1], ang[2], ang[3])
								tp:SetAngles(ang)
								tp:SetYRPInt("yrp_teleporter_uid", tonumber(teleporter.uniqueID))
								tp:SetYRPString("string_name", teleporter.string_name)
								tp:SetYRPString("string_target", teleporter.string_target)
								tp:Spawn()
								tp.PermaProps = true
								tp.PermaProps_ID = 0
								tp.PermaPropsID = 0
								YRP.msg("note", "[YourRP Teleporters] " .. "Was dead, respawned")
							else
								YRP.msg("note", "FAILED TO CREATE TELEPORTER, is [YourRP Teleporters] missing?")
								isTPsInstalled = false
								break
							end
						end
					end
				end
			end
		end

		if _time % GetBackupCreateTime() == 0 then
			RemoveOldBackups()
			CreateBackup()
		end

		local _auto_save = 300
		if _time % _auto_save == 0 then
			local _mod = _time % 60
			local _left = _time / 60 - _mod
			local _str = "Auto-Save (Uptime: " .. _left .. " " .. "minutes" .. " )"
			YRPSaveClients(_str)
			--SaveStorages(_str)
		end

		local _changelevel = 43200 -- 43200 = 60 * 60 * 12 (12 Hours)
		if GetGlobalYRPBool("bool_server_reload", false) and _time >= _changelevel then
			YRP.msg("gm", "Auto Reload Map to prevent Lags/Stutter.")
			timer.Simple(
				1,
				function()
					game.ConsoleCommand("changelevel " .. GetMapNameDB() .. "\n")
				end
			)
		end

		if GetGlobalYRPBool("bool_server_reload_notification", false) and _time >= _changelevel - 30 then
			local _str = "Auto Reload in " .. _changelevel - _time .. " sec"
			YRP.msg("gm", _str)
			net.Start("nws_yrp_autoreload")
			net.WriteString(string.format("%0.1f", _changelevel - _time))
			net.Broadcast()
		end

		if _time % 1 == 0 and HasDarkrpmodification() then
			YRPHR(Color(0, 255, 0))
			MsgC(Color(0, 255, 0), "You have locally \"darkrpmodification\", remove it to make YourRP work!", Color(255, 255, 255, 255), "\n")
			YRPHR(Color(0, 255, 0))
			YRPTestDarkrpmodification()
		end

		if _time % 1 == 0 and not HasYRPContent() then
			YRPHR(Color(255, 255, 0))
			MsgC(Color(255, 255, 0), "You don't have \"YourRP Content\" on your Server Collection, add it to make YourRP work!", Color(255, 255, 255, 255), "\n")
			MsgC(Color(255, 255, 0), "Or is STEAM down?", Color(255, 255, 255, 255), "\n")
			YRPHR(Color(255, 255, 0))
			YRPTestContentAddons()
		end

		if _time % 60 == 0 and YRPCheckAddons then
			YRPCheckAddons()
		end

		if _time % 1 == 0 and YRPRemoveBuildingOwner and YRPRemoveBuildingOwner() and GetAllDoors then
			for i, door in pairs(GetAllDoors()) do
				local charId = door:GetYRPInt("ownerCharID")
				if charId ~= 0 then
					local steamId = YRPGetSteamIdByCharId(charId)
					local ply = YRPGetPlayerBySteamID(steamId)
					if ply == nil and steamId then
						local ts = YRPGetTSLastOnline(steamId)
						if os.time() - ts >= YRPRemoveBuildingOwnerTime() then
							YRPBuildingRemoveOwner(steamId)
						end
					end
				end
			end
		end

		if _time == 10 or _time > 10 and _time % 3600 == 0 then
			YRPCheckVersion("think")
		end

		--IsServerInfoOutdated()
		_time = _time + TICK
		_time = math.Round(_time, DEC)
	end
)

function YRPRestartServer()
	RunConsoleCommand("map", game.GetMap())
end

function UpdateSpawnerNPCTable()
	local t = {}
	local all = YRP_SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = 'spawner_npc'")
	if IsNotNilAndNotFalse(all) then
		for i, v in pairs(all) do
			local spawner = {}
			spawner.pos = v.position
			spawner.uniqueID = v.uniqueID
			if not table.HasValue(t, spawner) then
				table.insert(t, spawner)
			end
		end
	end

	SetGlobalYRPTable("yrp_spawner_npc", t)
end

UpdateSpawnerNPCTable()
function UpdateSpawnerENTTable()
	local t = {}
	local all = YRP_SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = 'spawner_ent'")
	if IsNotNilAndNotFalse(all) then
		for i, v in pairs(all) do
			local spawner = {}
			spawner.pos = v.position
			spawner.uniqueID = v.uniqueID
			if not table.HasValue(t, spawner) then
				table.insert(t, spawner)
			end
		end
	end

	SetGlobalYRPTable("yrp_spawner_ent", t)
end

UpdateSpawnerENTTable()
function UpdateJailpointTable()
	local t = {}
	local all = YRP_SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = 'jailpoint'")
	if IsNotNilAndNotFalse(all) then
		for i, v in pairs(all) do
			local spawner = {}
			spawner.pos = v.position
			spawner.uniqueID = v.uniqueID
			spawner.name = v.name
			if not table.HasValue(t, spawner) then
				table.insert(t, spawner)
			end
		end
	end

	SetGlobalYRPTable("yrp_jailpoints", t)
end

UpdateJailpointTable()
function UpdateReleasepointTable()
	local t = {}
	local all = YRP_SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = 'releasepoint'")
	if IsNotNilAndNotFalse(all) then
		for i, v in pairs(all) do
			local spawner = {}
			spawner.pos = v.position
			spawner.uniqueID = v.uniqueID
			if not table.HasValue(t, spawner) then
				table.insert(t, spawner)
			end
		end
	end

	SetGlobalYRPTable("yrp_releasepoints", t)
end

UpdateReleasepointTable()
function UpdateRadiationTable()
	local t = {}
	local all = YRP_SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = 'radiation'")
	if IsNotNilAndNotFalse(all) then
		for i, v in pairs(all) do
			local spawner = {}
			spawner.pos = v.position
			spawner.uniqueID = v.uniqueID
			spawner.name = v.name
			if not table.HasValue(t, spawner) then
				table.insert(t, spawner)
			end
		end
	end

	SetGlobalYRPTable("yrp_radiation", t)
end

UpdateRadiationTable()
function UpdateSafezoneTable()
	local t = {}
	local all = YRP_SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = 'safezone'")
	if IsNotNilAndNotFalse(all) then
		for i, v in pairs(all) do
			local safezone = {}
			safezone.pos = v.position
			safezone.uniqueID = v.uniqueID
			safezone.name = v.name
			if not table.HasValue(t, safezone) then
				table.insert(t, safezone)
			end
		end
	end

	SetGlobalYRPTable("yrp_safezone", t)
end

UpdateSafezoneTable()
function UpdateZoneTable()
	local t = {}
	local all = YRP_SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = 'zone'")
	if IsNotNilAndNotFalse(all) then
		for i, v in pairs(all) do
			local zone = {}
			zone.pos = v.position
			zone.uniqueID = v.uniqueID
			zone.name = v.name
			zone.color = v.color
			if not table.HasValue(t, zone) then
				table.insert(t, zone)
			end
		end
	end

	SetGlobalYRPTable("yrp_zone", t)
end

UpdateZoneTable()
local YNPCs = {}
local YENTs = {}
local delay = CurTime()
hook.Add(
	"Think",
	"yrp_spawner_think",
	function()
		if delay < CurTime() then
			delay = CurTime() + 1
			local t = GetGlobalYRPTable("yrp_spawner_npc")
			for _, v in pairs(t) do
				local pos = StringToVector(v.pos)
				if YNPCs[v.uniqueID] == nil then
					YNPCs[v.uniqueID] = {}
					YNPCs[v.uniqueID].npcs = {}
					YNPCs[v.uniqueID].delay = CurTime()
				end

				local npc_spawner = YRP_SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = 'spawner_npc' AND uniqueID = '" .. v.uniqueID .. "'")
				if IsNotNilAndNotFalse(npc_spawner) then
					npc_spawner = npc_spawner[1]
					npc_spawner.int_amount = tonumber(npc_spawner.int_amount)
					npc_spawner.int_respawntime = tonumber(npc_spawner.int_respawntime)
					for _, npc in pairs(YNPCs[v.uniqueID].npcs) do
						if not npc:IsValid() then
							YRP.msg("gm", "A NPC Died, start respawning...")
							table.RemoveByValue(YNPCs[v.uniqueID].npcs, npc)
							YNPCs[v.uniqueID].delay = CurTime() + npc_spawner.int_respawntime
						end
					end

					if YNPCs[v.uniqueID].delay < CurTime() and table.Count(YNPCs[v.uniqueID].npcs) < npc_spawner.int_amount then
						npc_spawner.delay = CurTime() + npc_spawner.int_respawntime
						local npc = ents.Create(npc_spawner.string_classname)
						if npc:IsValid() then
							npc:Spawn()
							if not strEmpty(npc_spawner.string_swep) then
								npc:Give(npc_spawner.string_swep)
							end

							YRPTeleportToPoint(npc, pos)
							table.insert(YNPCs[v.uniqueID].npcs, npc)
						end
					end
				end
			end

			local tEnts = GetGlobalYRPTable("yrp_spawner_ent")
			for _, v in pairs(tEnts) do
				local pos = StringToVector(v.pos)
				if YENTs[v.uniqueID] == nil then
					YENTs[v.uniqueID] = {}
					YENTs[v.uniqueID].ents = {}
					YENTs[v.uniqueID].delay = CurTime()
				end

				local ent_spawner = YRP_SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = 'spawner_ent' AND uniqueID = '" .. v.uniqueID .. "'")
				if IsNotNilAndNotFalse(ent_spawner) then
					ent_spawner = ent_spawner[1]
					ent_spawner.int_amount = tonumber(ent_spawner.int_amount)
					ent_spawner.int_respawntime = tonumber(ent_spawner.int_respawntime)
					for _, ent in pairs(YENTs[v.uniqueID].ents) do
						if not ent:IsValid() then
							YRP.msg("gm", "A ENT Died, start respawning...")
							table.RemoveByValue(YENTs[v.uniqueID].ents, ent)
							YENTs[v.uniqueID].delay = CurTime() + ent_spawner.int_respawntime
						end
					end

					if YENTs[v.uniqueID].delay < CurTime() and table.Count(YENTs[v.uniqueID].ents) < ent_spawner.int_amount then
						ent_spawner.delay = CurTime() + ent_spawner.int_respawntime
						local ent = ents.Create(ent_spawner.string_classname)
						if ent:IsValid() then
							local _, err = pcall(YRPEntSpawn, ent)
							if err then
								YRPMsg(err)
							end

							YRPTeleportToPoint(ent, pos)
							table.insert(YENTs[v.uniqueID].ents, ent)
						end
					end
				end
			end
		end
	end, hook.MONITOR_HIGH
)

hook.Add(
	"KeyPress",
	"yrp_keypress_use_door",
	function(ply, key)
		if key == IN_USE then
			local tr = util.TraceLine(
				{
					start = ply:EyePos(),
					endpos = ply:EyePos() + ply:EyeAngles():Forward() * GetGlobalYRPInt("int_door_distance", 200),
					filter = function(ent)
						if ent:YRPIsDoor() then return true end
					end
				}
			)

			local ent = tr.Entity
			if IsValid(ent) and ent:YRPIsDoor() then
				local door = ent
				YRPOpenDoor(ply, door)
			end
		end
	end
)
