--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

hook.Add("PlayerStartTaunt", "yrp_taunt_start", function(ply, act, length)
	ply:SetDBool("taunting", true)
	timer.Simple(length, function()
		ply:SetDBool("taunting", false)
	end)
end)

util.AddNetworkString("client_lang")
net.Receive("client_lang", function(len, ply)
	local _lang = net.ReadString()
	YRP.msg("db", ply:YRPName() .. " using language: " .. string.upper(_lang))
	ply:SetDString("client_lang", _lang or "NONE")
end)

function YDeath(ply)
	ply:Kill()
end

function reg_hp(ply)
	local hpreg = ply:GetDInt("HealthReg", nil)
	if wk(hpreg) and ply:Alive() then
		if ply:Health() <= 0 then
			YDeath(ply)
		end
		ply:Heal(hpreg)
		if ply:Health() <= 0 then
			YDeath(ply)
		end
	end
end

function reg_ar(ply)
	local arreg = ply:GetDInt("ArmorReg")
	if arreg != nil then
		ply:SetArmor(ply:Armor() + arreg)
		if ply:Armor() > ply:GetDInt("MaxArmor") then
			ply:SetArmor(ply:GetDInt("MaxArmor"))
		elseif ply:Armor() < 0 then
			ply:SetArmor(0)
		end
	end
end

function IsCookPlaying()
	for i, v in pairs(player.GetAll()) do
		if v:isCook() then
			return true
		end
	end
	return false
end

function con_hg(ply, time)
	if GetGlobalDBool("bool_onlywhencook", false) and !IsCookPlaying() then return false end
	local newval = tonumber(ply:GetDFloat("hunger", 0.0)) - 0.01 * GetGlobalDFloat("float_scale_hunger", 1.0)
	newval = math.Clamp(newval, 0.0, 100.0)
	ply:SetDFloat("hunger", newval)

	if tonumber(ply:GetDFloat("hunger", 0.0)) < 20.0 then
		ply:TakeDamage(ply:GetMaxHealth() / 50)
	elseif GetGlobalDBool("bool_hunger_health_regeneration", false) then
		local tickrate = tonumber(GetGlobalDString("text_hunger_health_regeneration_tickrate", 1))
		if tickrate >= 1 and time % tickrate == 0 then
			ply:SetHealth(ply:Health() + 1)
			if ply:Health() > ply:GetMaxHealth() then
				ply:SetHealth(ply:GetMaxHealth())
			end
		end
	end
end

function con_th(ply)
	if true and !IsCookPlaying() then return false end
	local newval = tonumber(ply:GetDFloat("thirst", 0.0)) - 0.01 * GetGlobalDFloat("float_scale_thirst", 1.0)
	newval = math.Clamp(newval, 0.0, 100.0)
	ply:SetDFloat("thirst", newval)
	if tonumber(ply:GetDFloat("thirst", 0.0)) < 20.0 then
		ply:TakeDamage(ply:GetMaxHealth() / 50)
	end
end

function con_hy(ply)
	local newval = tonumber(ply:GetDFloat("GetCurHygiene", 0.0)) - 0.01 * GetGlobalDFloat("float_scale_hygiene", 1.0)
	newval = math.Clamp(newval, 0.0, 100.0)
	ply:SetDFloat("GetCurHygiene", newval)
	if tonumber(ply:GetDFloat("GetCurHygiene", 0.0)) < 20.0 then
		ply:TakeDamage(ply:GetMaxHealth() / 50)
	end
end

function con_ra(ply)
	if IsInsideRadiation(ply) then
		ply:SetDFloat("GetCurRadiation", math.Clamp(tonumber(ply:GetDFloat("GetCurRadiation", 0.0)) + 0.01 * GetGlobalDFloat("float_scale_radiation_in", 50.0), 0, 100))
	else
		ply:SetDFloat("GetCurRadiation", math.Clamp(tonumber(ply:GetDFloat("GetCurRadiation", 0.0)) - 0.01 * GetGlobalDFloat("float_scale_radiation_out", 8.0), 0, 100))
	end
	if tonumber(ply:GetDFloat("GetCurRadiation", 0.0)) > 80.0 then
		ply:TakeDamage(ply:GetMaxHealth() / 50)
	end
end

function con_st(ply, _time)
	if GetGlobalDBool("bool_onlywhencook", false) and !IsCookPlaying() then
		ply:SetDFloat("GetCurStamina", 100)
		return false
	end
	ply.jumping = ply.jumping or false

	if ply:IsOnGround() and ply.jumping then
		ply.jumping = false
	end

	if ply:GetMoveType() != MOVETYPE_NOCLIP and !ply:InVehicle() then
		if !ply:IsOnGround() then
			if !ply.jumping then
				ply.jumping = true

				local newval = ply:GetDFloat("GetCurStamina", 0) - GetGlobalDFloat("float_scale_stamina_jump", 30)
				newval = math.Round(math.Clamp(newval, 0, ply:GetDFloat("GetMaxStamina", 100)), 1)
				ply:SetDFloat("GetCurStamina", newval)
			end
		end
	end

	if _time % 1.0 == 0 then
		if ply:GetMoveType() != MOVETYPE_NOCLIP and !ply:InVehicle() then
			if ply:KeyDown(IN_SPEED) and (ply:KeyDown(IN_FORWARD) or ply:KeyDown(IN_BACK) or ply:KeyDown(IN_MOVERIGHT) or ply:KeyDown(IN_MOVELEFT)) then
				local newval = ply:GetDFloat("GetCurStamina", 0) - (ply:GetDFloat("stamindown", 1))
				newval = math.Round(math.Clamp(newval, 0, ply:GetDFloat("GetMaxStamina", 100)), 1)
				ply:SetDFloat("GetCurStamina", newval)
			elseif ply:GetDFloat("thirst", 0) > 20 then
				local newval = ply:GetDFloat("GetCurStamina", 0) + ply:GetDFloat("staminup", 1)
				newval = math.Round(math.Clamp(newval, 0, ply:GetDFloat("GetMaxStamina", 100)), 1)
				ply:SetDFloat("GetCurStamina", newval)
			end
		end

		if !ply:Slowed() then
			local rs = ply:GetDInt("speedrun", 0)
			local ws = ply:GetDInt("speedwalk", 0)
			local factor = 1
			if ply:GetDFloat("GetCurStamina", 0) <= 20 or ply:GetDFloat("thirst", 0) < 20 then
				factor = 0.6
			end

			if IsBonefracturingEnabled() and !ply:Slowed() then
				if ply:GetDBool("broken_leg_left") and ply:GetDBool("broken_leg_right") then
					factor = 0.5
				elseif ply:GetDBool("broken_leg_left") or ply:GetDBool("broken_leg_right") then
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

function anti_bunnyhop(ply)
	if !ply:GetDBool("jump_resetting", false) then
		if ply:KeyDown(IN_JUMP) and ply:GetDBool("canjump", true) then
			ply:SetDBool("canjump", false)
		elseif ply:OnGround() and ply:GetDFloat("GetCurStamina", 0) >= GetGlobalDFloat("float_scale_stamina_jump", 30) and !ply:GetDBool("canjump", false) then
			ply:SetDBool("jump_resetting", true)
			timer.Simple(0.4, function()
				ply:SetDBool("jump_resetting", false)
				ply:SetDBool("canjump", true)
			end)
		end
	end
end

function reg_ab(ply)
	local reg = ply:GetDFloat("GetRegAbility", 0.0)
	local tick = ply:GetDFloat("GetRegTick", 1.0)

	ply.abdelay = ply.abdelay or 0
	ply.abdelay = math.Round(ply.abdelay, 1)

	if reg != 0.0 and ply.abdelay < CurTime() then
		ply.abdelay = CurTime() + tick
		ply:SetDInt("GetCurAbility", math.Clamp(ply:GetDInt("GetCurAbility", 0) + reg, 0, ply:GetDInt("GetMaxAbility")))
	end
end

function time_jail(ply)
	if ply:GetDBool("injail", false) then
		ply:SetDInt("jailtime", ply:GetDInt("jailtime", 0) - 1)
		if tonumber(ply:GetDInt("jailtime", 0)) <= 0 then
			clean_up_jail(ply)
		end
	end
end

function check_salary(ply)
	local _m = ply:GetDString("money", "FAILED")
	local _ms = ply:GetDString("salary", "FAILED")
	if _m != "FAILED" and _ms != "FAILED" then
		local _money = tonumber(_m)
		local _salary = tonumber(_ms)

		if _money != nil and _salary != nil then
			if CurTime() >= ply:GetDInt("nextsalarytime", 0) and ply:HasCharacterSelected() and ply:Alive() then
				ply:SetDInt("nextsalarytime", CurTime() + ply:GetDInt("salarytime"))

				ply:SetDString("money", _money + _salary)
				ply:UpdateMoney()
			end
		else
			YRP.msg("error", "CheckMoney in check_salary [ money: " .. tostring(_money) .. " salary: " .. tostring(_salary) .. " ]")
			ply:CheckMoney()
		end
	end
end

function dealerAlive(uid)
	for j, npc in pairs(ents.GetAll()) do
		if npc:IsNPC() and tonumber(npc:GetDString("dealerID", "0")) == tonumber(uid) then
			return true
		end
	end
	return false
end

function teleporterAlive(uid)
	for j, tel in pairs(ents.GetAll()) do
		if tel:GetClass() == "yrp_teleporter" then
			if tel:GetDInt("yrp_teleporter_uid", -1) != -1 and tonumber(tel:GetDInt("yrp_teleporter_uid", -1)) == tonumber(uid) then
				return true
			end
			tel.PermaProps = true
		end
	end
	return false
end

function holoAlive(uid)
	for j, tel in pairs(ents.GetAll()) do
		if tel:GetClass() == "yrp_holo" then
			if tel:GetDInt("yrp_holo_uid", nil) != nil and tonumber(tel:GetDInt("yrp_holo_uid", nil)) == tonumber(uid) then
				return true
			end
			tel.PermaProps = true
		end
	end
	return false
end

local _time = 0
local TICK = 0.1
local DEC = 1
timer.Remove("ServerThink")
timer.Create("ServerThink", TICK, 0, function()
	local _all_players = player.GetAll()

	if _time % 1.0 == 0 then	-- Every second
		for k, ply in pairs(_all_players) do
			ply:addSecond()
			if ply:GetDBool("loaded", false) then
				if !ply:GetDBool("inCombat") then
					reg_hp(ply)	 --HealthReg
					reg_ar(ply)	 --ArmorReg
					if ply:GetDInt("yrp_stars", 0) != 0 then
						ply:SetDInt("yrp_stars", 0)
					end
				end

				if ply:IsBleeding() then
					local effect = EffectData()
					effect:SetOrigin(ply:GetPos() - ply:GetBleedingPosition())
					effect:SetScale(1)
					util.Effect("bloodimpact", effect)
					ply:TakeDamage(0.5, ply, ply)
				end

				if GetGlobalDBool("bool_hunger", false) and ply:GetDBool("bool_hunger", false) then
					con_hg(ply, _time)
				end
				if GetGlobalDBool("bool_thirst", false) and ply:GetDBool("bool_thirst", false) then
					con_th(ply)
				end
				if GetGlobalDBool("bool_hygiene", false) then
					con_hy(ply)
				end
				if GetGlobalDBool("bool_radiation", false) then
					con_ra(ply)
				end

				time_jail(ply)
				check_salary(ply)

				anti_bunnyhop(ply)
			end
		end
	end

	for k, ply in pairs(_all_players) do -- Every 0.1 seconds
		if ply:GetDBool("loaded", false) then
			-- Every 0.1
			reg_ab(ply)

			if GetGlobalDBool("bool_stamina", false) and ply:GetDBool("bool_stamina", false) then
				con_st(ply, _time)
			end
		end
	end

	if _time % 60.0 == 1 then
		if YRP.XPPerMinute != nil then
			local xp_per_minute = YRP.XPPerMinute()
			for i, p in pairs(player.GetAll()) do
				p:AddXP(xp_per_minute)
			end
		end
	end

	if _time % 30.0 == 1 or GetGlobalDBool("yrp_update_teleporters", false) or GetGlobalDBool("yrp_update_holos", false) then
		if GetGlobalDBool("yrp_update_teleporters", true) != false then
			SetGlobalDBool("yrp_update_teleporters", false)
		end
		if GetGlobalDBool("yrp_update_holos", true) != false then
			SetGlobalDBool("yrp_update_holos", false)
		end

		local _dealers = SQL_SELECT("yrp_dealers", "*", "map = '" .. GetMapNameDB() .. "'")
		if wk(_dealers) then
			for i, dealer in pairs(_dealers) do
				if tonumber(dealer.uniqueID) != 1 and !dealerAlive(dealer.uniqueID) then
					local _del = SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = 'dealer' AND linkID = '" .. dealer.uniqueID .. "'")
					if _del != nil then
						YRP.msg("gm", "DEALER [" .. dealer.name .. "] NOT ALIVE, reviving!")
						_del = _del[1]
						local _dealer = ents.Create("yrp_dealer")
						_dealer:SetDString("dealerID", dealer.uniqueID)
						_dealer:SetDString("name", dealer.name)
						local _pos = string.Explode(",", _del.position)
						_pos = Vector(_pos[1], _pos[2], _pos[3])
						_dealer:SetPos(_pos)
						local _ang = string.Explode(",", _del.angle)
						_ang = Angle(0, _ang[2], 0)
						_dealer:SetAngles(_ang)
						_dealer:SetModel(dealer.WorldModel)
						_dealer:Spawn()

						timer.Simple(1, function()
							_dealer.Entity:LookupSequence("idle_all_01")
							_dealer.Entity:ResetSequence("idle_all_01")
						end)
					end
				end
			end
		end

		local teleporters = SQL_SELECT("yrp_teleporters", "*", "string_map = '" .. game.GetMap() .. "'")
		if wk(teleporters) then
			if table.Count(teleporters) < 100 then
				for i, teleporter in pairs(teleporters) do
					if !teleporterAlive(teleporter.uniqueID) then
						local tp = ents.Create("yrp_teleporter")
						if ( IsValid( tp ) ) then
							local pos = string.Explode(",", teleporter.string_position)
							pos = Vector(pos[1], pos[2], pos[3])
							tp:SetPos(pos - tp:GetUp() * 5)
							local ang = string.Explode(",", teleporter.string_angle)
							ang = Angle(ang[1], ang[2], ang[3])
							tp:SetAngles(ang)
							tp:SetDInt("yrp_teleporter_uid", tonumber(teleporter.uniqueID))
							tp:SetDString("string_name", teleporter.string_name)
							tp:SetDString("string_target", teleporter.string_target)
							tp:Spawn()
							tp.PermaProps = true
						end
					end
				end
			else
				YRP.msg("note", "There are a lot of Teleporters!")
			end
		end

		local holos = SQL_SELECT("yrp_holos", "*", "string_map = '" .. game.GetMap() .. "'")
		if wk(holos) then
			if table.Count(holos) < 100 then
				for i, holo in pairs(holos) do
					if !holoAlive(holo.uniqueID) then
						local tp = ents.Create("yrp_holo")
						if ( IsValid( tp ) ) then
							local pos = string.Explode(",", holo.string_position)
							pos = Vector(pos[1], pos[2], pos[3])
							tp:SetPos(pos - tp:GetUp() * 5)
							local ang = string.Explode(",", holo.string_angle)
							ang = Angle(ang[1], ang[2], ang[3])
							tp:SetAngles(ang)
							tp:SetDInt("yrp_holo_uid", tonumber(holo.uniqueID))
							tp:SetDString("string_name", holo.string_name)
							tp:SetDString("string_target", holo.string_target)
							tp:Spawn()
							tp.PermaProps = true
						end
					end
				end
			else
				YRP.msg("note", "There are a lot of holos!")
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
		local _str = "Auto-Save (Uptime: " .. _left .. " " .. "minutes" .. ")"
		save_clients(_str)
		--SaveStorages(_str)
	end

	if GAMEMODE:IsAutomaticServerReloadingEnabled() then
		local _changelevel = 21600
		if _time >= _changelevel then
			YRP.msg("gm", "Auto Reload")
			timer.Simple(1, function()
				game.ConsoleCommand("changelevel " .. GetMapNameDB() .. "\n")
			end)
		elseif _time >= _changelevel-30 then
			local _str = "Auto Reload in " .. _changelevel-_time .. " sec"
			YRP.msg("gm", _str)
			net.Start("yrp_info2")
				net.WriteString(_str)
			net.Broadcast()
		end
	end

	if _time == 10 then
		YRPCheckVersion()
	elseif _time == 30 then
		IsServerInfoOutdated()
	end
	_time = _time + TICK
	_time = math.Round(_time, DEC)
end)

function RestartServer()
	game.ConsoleCommand("_restart")
end

function UpdateSpawnerNPCTable()
	local t = {}
	local all = SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = 'spawner_npc'")
	if wk(all) then
		for i, v in pairs(all) do
			local spawner = {}
			spawner.pos = v.position
			spawner.uniqueID = v.uniqueID
			if !table.HasValue(t, spawner) then
				table.insert(t, spawner)
			end
		end
	end
	SetGlobalDTable("yrp_spawner_npc", t)
end
UpdateSpawnerNPCTable()

function UpdateSpawnerENTTable()
	local t = {}
	local all = SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = 'spawner_ent'")
	if wk(all) then
		for i, v in pairs(all) do
			local spawner = {}
			spawner.pos = v.position
			spawner.uniqueID = v.uniqueID
			if !table.HasValue(t, spawner) then
				table.insert(t, spawner)
			end
		end
	end
	SetGlobalDTable("yrp_spawner_ent", t)
end
UpdateSpawnerENTTable()

function UpdateJailpointTable()
	local t = {}
	local all = SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = 'jailpoint'")
	if wk(all) then
		for i, v in pairs(all) do
			local spawner = {}
			spawner.pos = v.position
			spawner.uniqueID = v.uniqueID
			spawner.name = v.name
			if !table.HasValue(t, spawner) then
				table.insert(t, spawner)
			end
		end
	end
	SetGlobalDTable("yrp_jailpoints", t)
end
UpdateJailpointTable()

function UpdateReleasepointTable()
	local t = {}
	local all = SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = 'releasepoint'")
	if wk(all) then
		for i, v in pairs(all) do
			local spawner = {}
			spawner.pos = v.position
			spawner.uniqueID = v.uniqueID
			if !table.HasValue(t, spawner) then
				table.insert(t, spawner)
			end
		end
	end
	SetGlobalDTable("yrp_releasepoints", t)
end
UpdateReleasepointTable()

function UpdateRadiationTable()
	local t = {}
	local all = SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = 'radiation'")
	if wk(all) then
		for i, v in pairs(all) do
			local spawner = {}
			spawner.pos = v.position
			spawner.uniqueID = v.uniqueID
			spawner.name = v.name
			if !table.HasValue(t, spawner) then
				table.insert(t, spawner)
			end
		end
	end
	SetGlobalDTable("yrp_radiation", t)
end
UpdateRadiationTable()

function UpdateSafezoneTable()
	local t = {}
	local all = SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = 'safezone'")
	if wk(all) then
		for i, v in pairs(all) do
			local spawner = {}
			spawner.pos = v.position
			spawner.uniqueID = v.uniqueID
			spawner.name = v.name
			if !table.HasValue(t, spawner) then
				table.insert(t, spawner)
			end
		end
	end
	SetGlobalDTable("yrp_safezone", t)
end
UpdateSafezoneTable()

local YNPCs = {}
local YENTs = {}
local delay = CurTime()
hook.Add("Think", "yrp_spawner_think", function()
	if delay < CurTime() then
		delay = CurTime() + 1

		local t = GetGlobalDTable("yrp_spawner_npc")
		for _, v in pairs(t) do
			local pos = StringToVector(v.pos)
			if YNPCs[v.uniqueID] == nil then
				YNPCs[v.uniqueID] = {}
				YNPCs[v.uniqueID].npcs = {}
				YNPCs[v.uniqueID].delay = CurTime()
			end

			local npc_spawner = SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = 'spawner_npc' AND uniqueID = '" .. v.uniqueID .. "'")
			if wk(npc_spawner) then
				npc_spawner = npc_spawner[1]
				npc_spawner.int_amount = tonumber(npc_spawner.int_amount)
				npc_spawner.int_respawntime = tonumber(npc_spawner.int_respawntime)
				for _, npc in pairs(YNPCs[v.uniqueID].npcs) do
					if !npc:IsValid() then
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
						teleportToPoint(npc, pos)

						table.insert(YNPCs[v.uniqueID].npcs, npc)
					end
				end
			end
		end

		local t = GetGlobalDTable("yrp_spawner_ent")
		for _, v in pairs(t) do
			local pos = StringToVector(v.pos)
			if YENTs[v.uniqueID] == nil then
				YENTs[v.uniqueID] = {}
				YENTs[v.uniqueID].ents = {}
				YENTs[v.uniqueID].delay = CurTime()
			end

			local ent_spawner = SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = 'spawner_ent' AND uniqueID = '" .. v.uniqueID .. "'")
			if wk(ent_spawner) then
				ent_spawner = ent_spawner[1]
				ent_spawner.int_amount = tonumber(ent_spawner.int_amount)
				ent_spawner.int_respawntime = tonumber(ent_spawner.int_respawntime)
				for _, ent in pairs(YENTs[v.uniqueID].ents) do
					if !ent:IsValid() then
						YRP.msg("gm", "A ENT Died, start respawning...")
						table.RemoveByValue(YENTs[v.uniqueID].ents, ent)
						YENTs[v.uniqueID].delay = CurTime() + ent_spawner.int_respawntime
					end
				end

				if YENTs[v.uniqueID].delay < CurTime() and table.Count(YENTs[v.uniqueID].ents) < ent_spawner.int_amount then
					ent_spawner.delay = CurTime() + ent_spawner.int_respawntime
					local ent = ents.Create(ent_spawner.string_classname)
					if ent:IsValid() then
						ent:Spawn()
						teleportToPoint(ent, pos)

						table.insert(YENTs[v.uniqueID].ents, ent)
					end
				end
			end
		end
	end
end)

hook.Add( "KeyPress", "yrp_keypress_use_door", function( ply, key )
	if ( key == IN_USE ) then
		local tr = util.TraceLine( {
			start = ply:EyePos(),
			endpos = ply:EyePos() + ply:EyeAngles():Forward() * GetGlobalDInt("int_door_distance", 200),
			filter = function( ent ) if ( ent:GetClass() == "func_door" ) then return true end end
		} )

		local ent = tr.Entity
		if IsValid(ent) then
			local hitclass = ent:GetClass()
			if hitclass == "func_door" then
				local door = ent
				openDoor(ply, door)
			end
		end
	end
end )