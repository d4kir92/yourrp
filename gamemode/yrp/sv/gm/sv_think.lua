--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

hook.Add("PlayerStartTaunt", "yrp_taunt_start", function(ply, act, length)
	ply:SetDBool("taunting", true)
	timer.Simple(length, function()
		ply:SetDBool("taunting", false)
	end)
end)

util.AddNetworkString("client_lang")
net.Receive("client_lang", function(len, ply)
	local _lang = net.ReadString()
	printGM("db", ply:YRPName() .. " using language: " .. string.upper(_lang))
	ply:SetDString("client_lang", _lang or "NONE")
end)

function reg_hp(ply)
	local hpreg = ply:GetDInt("HealthReg")
	if hpreg != nil then
		ply:Heal(hpreg)
		if ply:Health() > ply:GetMaxHealth() then
			ply:SetHealth(ply:GetMaxHealth())
		elseif ply:Health() < 0 then
			ply:Kill()
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

function con_hg(ply, time)
	ply:SetDFloat("hunger", tonumber(ply:GetDFloat("hunger", 0.0)) - 0.01)
	if tonumber(ply:GetDFloat("hunger", 0.0)) < 0.0 then
		ply:SetDFloat("hunger", 0.0)
	end
	if tonumber(ply:GetDFloat("hunger", 0.0)) < 20.0 then
		ply:TakeDamage(ply:GetMaxHealth() / 100)
	elseif GetGlobalDBool("bool_hunger_health_regeneration", false) then
		local tickrate = tonumber(ply:GetDString("text_hunger_health_regeneration_tickrate", 1))
		if tickrate >= 1 and time % tickrate == 0 then
			ply:SetHealth(ply:Health() + 1)
			if ply:Health() > ply:GetMaxHealth() then
				ply:SetHealth(ply:GetMaxHealth())
			end
		end
	end
end

function con_th(ply)
	ply:SetDFloat("thirst", tonumber(ply:GetDFloat("thirst", 0.0)) - 0.02)
	if tonumber(ply:GetDFloat("thirst", 0.0)) < 0.0 then
		ply:SetDFloat("thirst", 0.0)
	end
	if tonumber(ply:GetDFloat("thirst", 0.0)) < 20.0 then
		ply:TakeDamage(ply:GetMaxHealth() / 100)
	end
end

function con_st(ply)
	if ply:GetMoveType() != MOVETYPE_NOCLIP and !ply:IsOnGround() or ply:KeyDown(IN_SPEED) and (ply:KeyDown(IN_FORWARD) or ply:KeyDown(IN_BACK) or ply:KeyDown(IN_MOVERIGHT) or ply:KeyDown(IN_MOVELEFT)) and !ply:InVehicle() then
		ply:SetDInt("GetCurStamina", ply:GetDInt("GetCurStamina", 0) - (ply:GetDInt("stamindown", 1)))
		if ply:GetDInt("GetCurStamina", 0) < 0 then
			ply:SetDInt("GetCurStamina", 0)
		end
	elseif ply:GetDFloat("thirst", 0) > 20 then
		ply:SetDInt("GetCurStamina", ply:GetDInt("GetCurStamina", 0) + ply:GetDInt("staminup", 1))
		if ply:GetDInt("GetCurStamina", 0) > ply:GetDInt("GetMaxStamina", 100) then
			ply:SetDInt("GetCurStamina", ply:GetDInt("GetMaxStamina", 100))
		end
	end

	if !ply:Slowed() then
		if ply:GetDInt("GetCurStamina", 0) < 20 or ply:GetDFloat("thirst", 0) < 20 then
			ply:SetRunSpeed(ply:GetDInt("speedrun", 0) * 0.6)
			ply:SetWalkSpeed(ply:GetDInt("speedwalk", 0) * 0.6)
			ply:SetCanWalk(false)
		else
			ply:SetRunSpeed(ply:GetDInt("speedrun", 0))
			ply:SetWalkSpeed(ply:GetDInt("speedwalk", 0))
			ply:SetCanWalk(true)
		end
	end
end

hook.Add("Tick", "yrp_keydown", function()
	for k, ply in pairs(player.GetAll()) do
		anti_bunnyhop(ply)
	end
end)

function anti_bunnyhop(ply)
	if ply:KeyDown(IN_JUMP) and ply:GetDBool("canjump", true) then
		ply:SetDBool("canjump", false)
	elseif ply:OnGround() and !ply:GetDBool("jump_resetting", false) and !ply:GetDBool("canjump", false) then
		ply:SetDBool("jump_resetting", true)
		timer.Simple(0.4, function()
			ply:SetDBool("jump_resetting", false)
			ply:SetDBool("canjump", true)
		end)
	end
end

function broken(ply)
	if IsBonefracturingEnabled() and !ply:Slowed() then
		if ply:GetDBool("broken_leg_left") and ply:GetDBool("broken_leg_right") then
			--[[ Both legs broken ]]--
			ply:SetRunSpeed(ply:GetDInt("speedrun", 0)*0.5)
			ply:SetWalkSpeed(ply:GetDInt("speedwalk", 0)*0.5)
			ply:SetCanWalk(false)
		elseif ply:GetDBool("broken_leg_left") or ply:GetDBool("broken_leg_right") then
			--[[ One leg broken ]]--
			ply:SetRunSpeed(ply:GetDInt("speedrun", 0)*0.25)
			ply:SetWalkSpeed(ply:GetDInt("speedwalk", 0)*0.25)
			ply:SetCanWalk(false)
		else
			ply:SetRunSpeed(ply:GetDInt("speedrun", 0))
			ply:SetWalkSpeed(ply:GetDInt("speedwalk", 0))
			ply:SetCanWalk(true)
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
			printGM("error", "CheckMoney in check_salary [ money: " .. tostring(_money) .. " salary: " .. tostring(_salary) .. " ]")
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

local _time = 0
local TICK = 0.01
local DEC = 2
timer.Create("ServerThink", TICK, 0, function()
	local _all_players = player.GetAll()

	if _time % 1.0 < TICK then	-- Every second
		for k, ply in pairs(_all_players) do
			ply:addSecond()
			if ply:GetDBool("loaded", false) then
				anti_bunnyhop(ply)

				if !ply:GetDBool("inCombat") then
					reg_hp(ply)	 --HealthReg
					reg_ar(ply)	 --ArmorReg
					ply:SetDInt("yrp_stars", 0)
				end

				if ply:IsBleeding() then
					local effect = EffectData()
					effect:SetOrigin(ply:GetPos() - ply:GetBleedingPosition())
					effect:SetScale(1)
					util.Effect("bloodimpact", effect)
					ply:TakeDamage(0.5, ply, ply)
				end

				if GetGlobalDBool("bool_hunger", false) then
					con_hg(ply, _time)
				end
				if GetGlobalDBool("bool_thirst", false) then
					con_th(ply)
				end
				if GetGlobalDBool("bool_stamina", false) then
					con_st(ply)
				end

				time_jail(ply)
				check_salary(ply)
				broken(ply)
			end
		end
	end

	for k, ply in pairs(_all_players) do -- Every 0.1 seconds
		if ply:GetDBool("loaded", false) then
			-- Every 0.1
			reg_ab(ply)
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

	if _time % 30.0 == 0 then
		for i, ply in pairs(_all_players) do
			if ply:GetRoleName() == nil and ply:Alive() and !ply:IsBot() then
				ply:KillSilent()
			end
		end

		local _dealers = SQL_SELECT("yrp_dealers", "*", "map = '" .. GetMapNameDB() .. "'")
		if wk(_dealers) then
			for i, dealer in pairs(_dealers) do
				if tonumber(dealer.uniqueID) != 1 and !dealerAlive(dealer.uniqueID) then
					local _del = SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = 'dealer' AND linkID = '" .. dealer.uniqueID .. "'")
					pTab(_del)
					if _del != nil then
						printGM("gm", "DEALER [" .. dealer.name .. "] NOT ALIVE, reviving!")
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
	end

	if _time % GetBackupCreateTime() == 0 then
		RemoveOldBackups()
		CreateBackup()

		SearchForCollectionID()
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
			printGM("gm", "Auto Reload")
			timer.Simple(1, function()
				game.ConsoleCommand("changelevel " .. GetMapNameDB() .. "\n")
			end)
		elseif _time >= _changelevel-30 then
			local _str = "Auto Reload in " .. _changelevel-_time .. " sec"
			printGM("gm", _str)
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

function UpdateSpawnerTable()
	local t = {}
	local all = SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = 'spawner'")
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
	SetGlobalDTable("yrp_spawner", t)
end
UpdateSpawnerTable()

function UpdateJailpointTable()
	local t = {}
	local all = SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = 'jailpoint'")
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

local YNPCs = {}
local delay = CurTime()
hook.Add("Think", "yrp_spawner_think", function()
	if delay < CurTime() then
		delay = CurTime() + 1

		local t = GetGlobalDTable("yrp_spawner")
		for _, v in pairs(t) do
			local pos = StringToVector(v.pos)
			if YNPCs[v.uniqueID] == nil then
				YNPCs[v.uniqueID] = {}
				YNPCs[v.uniqueID].npcs = {}
				YNPCs[v.uniqueID].delay = CurTime()
			end

			local npc_spawner = SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "uniqueID = '" .. v.uniqueID .. "'")
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
	end
end)

hook.Add( "KeyPress", "keypress_use_hi", function( ply, key )
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