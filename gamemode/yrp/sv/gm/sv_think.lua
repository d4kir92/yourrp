--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

hook.Add("PlayerStartTaunt", "yrp_taunt_start", function(ply, act, length)
	ply:SetNWBool("taunting", true)
	timer.Simple(length, function()
		ply:SetNWBool("taunting", false)
	end)
end)

util.AddNetworkString("client_lang")
net.Receive("client_lang", function(len, ply)
	local _lang = net.ReadString()
	printGM("note", ply:YRPName() .. " using language: " .. string.upper(_lang))
	ply:SetNWString("client_lang", _lang or "NONE")
end)

function reg_hp(ply)
	local hpreg = ply:GetNWInt("HealthReg")
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
	local arreg = ply:GetNWInt("ArmorReg")
	if arreg != nil then
		ply:SetArmor(ply:Armor() + arreg)
		if ply:Armor() > ply:GetNWInt("MaxArmor") then
			ply:SetArmor(ply:GetNWInt("MaxArmor"))
		elseif ply:Armor() < 0 then
			ply:SetArmor(0)
		end
	end
end

function con_hg(ply, time)
	ply:SetNWFloat("hunger", tonumber(ply:GetNWFloat("hunger", 0.0)) - 0.01)
	if tonumber(ply:GetNWFloat("hunger", 0.0)) < 0.0 then
		ply:SetNWFloat("hunger", 0.0)
	end
	if tonumber(ply:GetNWFloat("hunger", 0.0)) < 20.0 then
		ply:TakeDamage(ply:GetMaxHealth() / 100)
	elseif ply:GetNWBool("bool_hunger_health_regeneration", false) then
		local tickrate = tonumber(ply:GetNWString("text_hunger_health_regeneration_tickrate", 1))
		if tickrate >= 1 and time % tickrate == 0 then
			ply:SetHealth(ply:Health() + 1)
			if ply:Health() > ply:GetMaxHealth() then
				ply:SetHealth(ply:GetMaxHealth())
			end
		end
	end
end

function con_th(ply)
	ply:SetNWFloat("thirst", tonumber(ply:GetNWFloat("thirst", 0.0)) - 0.02)
	if tonumber(ply:GetNWFloat("thirst", 0.0)) < 0.0 then
		ply:SetNWFloat("thirst", 0.0)
	end
	if tonumber(ply:GetNWFloat("thirst", 0.0)) < 20.0 then
		ply:TakeDamage(ply:GetMaxHealth() / 100)
	end
end

function con_st(ply)
	if ply:GetMoveType() != MOVETYPE_NOCLIP and !ply:IsOnGround() or ply:KeyDown(IN_SPEED) and (ply:KeyDown(IN_FORWARD) or ply:KeyDown(IN_BACK) or ply:KeyDown(IN_MOVERIGHT) or ply:KeyDown(IN_MOVELEFT)) and !ply:InVehicle() then
		ply:SetNWInt("GetCurStamina", ply:GetNWInt("GetCurStamina", 0) - (ply:GetNWInt("stamindown", 1)))
		if ply:GetNWInt("GetCurStamina", 0) < 0 then
			ply:SetNWInt("GetCurStamina", 0)
		end
	elseif ply:GetNWFloat("thirst", 0) > 20 then
		ply:SetNWInt("GetCurStamina", ply:GetNWInt("GetCurStamina", 0) + ply:GetNWInt("staminup", 1))
		if ply:GetNWInt("GetCurStamina", 0) > ply:GetNWInt("GetMaxStamina", 100) then
			ply:SetNWInt("GetCurStamina", ply:GetNWInt("GetMaxStamina", 100))
		end
	end

	if !ply:Slowed() then
		if ply:GetNWInt("GetCurStamina", 0) < 20 or ply:GetNWFloat("thirst", 0) < 20 then
			ply:SetRunSpeed(ply:GetNWInt("speedrun", 0) * 0.6)
			ply:SetWalkSpeed(ply:GetNWInt("speedwalk", 0) * 0.6)
			ply:SetCanWalk(false)
		else
			ply:SetRunSpeed(ply:GetNWInt("speedrun", 0))
			ply:SetWalkSpeed(ply:GetNWInt("speedwalk", 0))
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
	if ply:KeyDown(IN_JUMP) and ply:GetNWBool("canjump", true) then
		ply:SetNWBool("canjump", false)
	elseif ply:OnGround() and !ply:GetNWBool("jump_resetting", false) and !ply:GetNWBool("canjump", false) then
		ply:SetNWBool("jump_resetting", true)
		timer.Simple(0.4, function()
			ply:SetNWBool("jump_resetting", false)
			ply:SetNWBool("canjump", true)
		end)
	end
end

function broken(ply)
	if IsBonefracturingEnabled() and !ply:Slowed() then
		if ply:GetNWBool("broken_leg_left") and ply:GetNWBool("broken_leg_right") then
			--[[ Both legs broken ]]--
			ply:SetRunSpeed(ply:GetNWInt("speedrun", 0)*0.5)
			ply:SetWalkSpeed(ply:GetNWInt("speedwalk", 0)*0.5)
			ply:SetCanWalk(false)
		elseif ply:GetNWBool("broken_leg_left") or ply:GetNWBool("broken_leg_right") then
			--[[ One leg broken ]]--
			ply:SetRunSpeed(ply:GetNWInt("speedrun", 0)*0.25)
			ply:SetWalkSpeed(ply:GetNWInt("speedwalk", 0)*0.25)
			ply:SetCanWalk(false)
		else
			ply:SetRunSpeed(ply:GetNWInt("speedrun", 0))
			ply:SetWalkSpeed(ply:GetNWInt("speedwalk", 0))
			ply:SetCanWalk(true)
		end
	end
end

function reg_ab(ply)
	ply:SetNWInt("GetCurAbility", ply:GetNWInt("GetCurAbility", 0) + ply:GetNWInt("GetRegAbility", 1))

	if ply:GetNWInt("GetCurAbility") > ply:GetNWInt("GetMaxAbility") then
		ply:SetNWInt("GetCurAbility", ply:GetNWInt("GetMaxAbility"))
	elseif ply:GetNWInt("GetCurAbility") < 0 then
		ply:SetNWInt("GetCurAbility", 0)
	end
end

function time_jail(ply)
	if ply:GetNWBool("injail", false) then
		ply:SetNWInt("jailtime", ply:GetNWInt("jailtime", 0) - 1)
		if tonumber(ply:GetNWInt("jailtime", 0)) <= 0 then
			clean_up_jail(ply)
		end
	end
end

function check_salary(ply)
	if worked(ply:GetNWString("money"), "sv_think money fail") and worked(ply:GetNWString("salary"), "sv_think salary fail") then
		if CurTime() >= ply:GetNWInt("nextsalarytime", 0) and ply:HasCharacterSelected() and ply:Alive() then
			ply:SetNWInt("nextsalarytime", CurTime() + ply:GetNWInt("salarytime"))

			local _m = ply:GetNWString("money", "FAILED")
			local _ms = ply:GetNWString("salary", "FAILED")
			if _m == "FAILED" or _ms == "FAILED" then
				printGM("note", "_m or _ms failed _m: " .. _m .. " _ms: " .. _ms)
				return false
			end
			local _money = tonumber(_m)
			local _salary = tonumber(_ms)
			if _money != nil and _salary != nil then
				ply:SetNWString("money", _money + _salary)
				ply:UpdateMoney()
			else
				printGM("error", "CheckMoney in check_salary [ money: " .. tostring(_money) .. " salary: " .. tostring(_salary) .. " ]")
				ply:CheckMoney()
			end
		end
	end
end

function dealerAlive(uid)
	for j, npc in pairs(ents.GetAll()) do
		if npc:IsNPC() then
			if tostring(npc:GetNWString("dealerID", "FAILED")) == tostring(uid) then
				return true
			end
		end
	end
	return false
end

local _time = 0
timer.Create("ServerThink", 1, 0, function()
	local _all_players = player.GetAll()

	for k, ply in pairs(_all_players) do
		ply:addSecond()

		if ply:GetNWBool("loaded", false) then
			anti_bunnyhop(ply)

			if !ply:GetNWBool("inCombat") then
				reg_hp(ply)	 --HealthReg
				reg_ar(ply)	 --ArmorReg
				ply:SetNWInt("yrp_stars", 0)
			end

			if ply:IsBleeding() then
				local effect = EffectData()
				effect:SetOrigin(ply:GetPos() - ply:GetBleedingPosition())
				effect:SetScale(1)
				util.Effect("bloodimpact", effect)
				ply:TakeDamage(0.5, ply, ply)
			end

			if ply:GetNWBool("bool_hunger", false) then
				con_hg(ply, _time)
			end
			if ply:GetNWBool("bool_thirst", false) then
				con_th(ply)
			end
			if ply:GetNWBool("bool_stamina", false) then
				con_st(ply)
			end

			reg_ab(ply)
			time_jail(ply)
			check_salary(ply)
			broken(ply)
		end
	end

	if _time % 30 == 0 then
		for i, ply in pairs(_all_players) do
			if ply:GetRoleName() == nil and ply:Alive() then
				if !ply:IsBot() then
					ply:KillSilent()
				end
			end
		end
		local _dealers = SQL_SELECT("yrp_dealers", "*", "map = '" .. GetMapNameDB() .. "'")
		if _dealers != nil and _dealers != false then
			for i, dealer in pairs(_dealers) do
				if tostring(dealer.uniqueID) != "1" then
					if !dealerAlive(dealer.uniqueID) then
						local _del = SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = 'dealer' AND linkID = '" .. dealer.uniqueID .. "'")
						if _del != nil then
							printGM("gm", "DEALER [" .. dealer.name .. "] NOT ALIVE, reviving!")
							_del = _del[1]
							local _dealer = ents.Create("yrp_dealer")
							_dealer:SetNWString("dealerID", dealer.uniqueID)
							_dealer:SetNWString("name", dealer.name)
							local _pos = string.Explode(",", _del.position)
							_pos = Vector(_pos[1], _pos[2], _pos[3])
							_dealer:SetPos(_pos)
							local _ang = string.Explode(",", _del.angle)
							_ang = Angle(0, _ang[2], 0)
							_dealer:SetAngles(_ang)
							_dealer:SetModel(dealer.WorldModel)
							_dealer:Spawn()

							local sequence = _dealer.Entity:LookupSequence("idle_all_01")
							_dealer.Entity:ResetSequence("idle_all_01")
							
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
		local _str = "Auto-Save (Uptime: " .. _left .. " " .. YRP.lang_string("LID_minutes") .. ")"
		save_clients(_str)
		SaveStorages(_str)
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
	_time = _time + 1
end)

function RestartServer()
	game.ConsoleCommand("_restart")
end
