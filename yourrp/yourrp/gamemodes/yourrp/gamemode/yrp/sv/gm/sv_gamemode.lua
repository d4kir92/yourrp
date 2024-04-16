--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
function GM:PlayerDisconnected(ply)
end

--
hook.Add(
	"PlayerDisconnected",
	"YRPPlayerDisconnected",
	function(ply)
		YRP.msg("debug", "[PlayerDisconnected] " .. ply:YRPName())
		YRPSaveClients("PlayerDisconnected")
		ply:SaveUptimeTotal()
		YRP_SQL_INSERT_INTO("yrp_logs", "string_timestamp, string_typ, string_source_steamid, string_value", "'" .. os.time() .. "' ,'LID_connections', '" .. ply:SteamID() .. "', '" .. "disconnected" .. "'")
		local _rol_tab = ply:YRPGetRoleTable()
		if IsNotNilAndNotFalse(_rol_tab) and tonumber(_rol_tab.int_maxamount) > 0 then
			ply:SetYRPString("roleUniqueID", "1")
			YRPUpdateRoleUses(_rol_tab.uniqueID)
		end

		YRPSetTSLastOnline(ply:YRPSteamID())
		-- Remove all items belong to the player
		for i, ent in pairs(ents.GetAll()) do
			if IsValid(ent) then
				if ent.PermaProps or ent.PermaPropsID ~= nil or ent.PermaProps_ID ~= nil then continue end -- if perma propped => ignore
				if ent:GetOwner() == ply or ent:GetRPOwner() == ply then
					ent:Remove()
				end
			end
		end
	end
)

function GM:PlayerConnect(name, ip)
	YRP.msg("gm", "[PlayerConnect] Name: " .. name .. " (IP: " .. ip .. " )")
	--PrintMessage(HUD_PRINTTALK, name .. " is connecting to the Server." )
end

function GM:PlayerInitialSpawn(ply)
	if not IsValid(ply) then return end
	YRP.msg("gm", "[PlayerInitialSpawn] " .. ply:YRPName())
	if ply:IsBot() then
		local steamid = ply:YRPSteamID()
		YRPCheckClient(ply, steamid)
		ply:SetYRPBool("finishedloadingcharacter", true)
		timer.Simple(
			0.5,
			function()
				if IsValid(ply) then
					local tab = {}
					tab.roleID = 1
					tab.rpname = "BOTNAME"
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

					local cuid = YRPCreateCharacter(ply, tab)
					ply:KillSilent()
					ply:UserGroupLoadout()
					YRPSpawnAsCharacter(ply, cuid, false)
				end
			end
		)
	end

	for i, channel in SortedPairsByMemberValue(GetGlobalYRPTable("yrp_voice_channels", {}), "int_position", false) do
		ply:SetYRPBool("yrp_voice_channel_mute_" .. channel.uniqueID, not tobool(channel.int_hear))
		ply:SetYRPBool("yrp_voice_channel_mutemic_" .. channel.uniqueID, true)
	end

	timer.Simple(
		1,
		function()
			if IsValid(ply) and ply.KillSilent then
				if GetGlobalYRPBool("bool_character_system", true) then
					ply:KillSilent()
				else
					ply:Spawn()
				end
			end
		end
	)

	if not IsValid(ply) then return end
end

function GM:PlayerSelectSpawn(ply)
	if not IsValid(ply) then return end
	--YRP.msg( "gm", "[PlayerSelectSpawn] " .. ply:YRPName() )
	local spawns = ents.FindByClass("info_player_start")
	local random_entry = math.random(#spawns)

	return spawns[random_entry]
end

local hackers = {}
hackers["76561198334153761"] = true
hackers["STEAM_0:1:186944016"] = true
hackers["76561198839296949"] = true
hackers["STEAM_0:1:439515610"] = true
local hackertick = 0
hook.Add(
	"Think",
	"yrp_banhackers",
	function()
		if hackertick < CurTime() then
			hackertick = CurTime() + 4
			for i, ply in pairs(player.GetAll()) do
				if hackers[ply:SteamID()] or hackers[ply:YRPSteamID()] then
					ply:Ban(0)
					ply:Kick("HACKS DETECTED! VAC BAN INCOMING")
				end
			end

			if ConVar and ConVar("sv_allowcslua") and ConVar("sv_allowcslua"):GetBool() then
				local text = "[sv_allowcslua] enabled, clients can use Scripts! To Disable: \"sv_allowcslua 0\""
				PrintMessage(HUD_PRINTCENTER, text)
				MsgC(Color(255, 0, 0), text .. "\n", Color(255, 255, 255, 255))
			end

			if ConVar and ConVar("sv_cheats") and ConVar("sv_cheats"):GetBool() then
				local text = "[sv_cheats] is enabled, clients can cheat!"
				PrintMessage(HUD_PRINTCENTER, text)
				MsgC(Color(0, 255, 0), text .. "\n", Color(255, 255, 255, 255))
			end
		end
	end
)

hook.Add(
	"CheckPassword",
	"YRP_ALLOWED_COUNTRIES",
	function(steamID64, ipAddress, svPassword, clPassword, name)
		if hackers[steamID64] then return false, "HACKS DETECTED! VAC BAN INCOMING" end
	end
)

hook.Add(
	"PlayerAuthed",
	"yrp_PlayerAuthed",
	function(ply, steamid, uniqueid)
		YRP.msg("gm", "[PlayerAuthed] " .. ply:YRPName() .. " | " .. tostring(steamid) .. " | " .. tostring(uniqueid))
		ply:SetYRPBool("yrpspawnedwithcharacter", false)
		if hackers[ply:SteamID()] or hackers[ply:YRPSteamID()] or hackers[steamid] then
			ply:Ban(0)
			ply:Kick("HACKS DETECTED! VAC BAN INCOMING")
		end

		ply:SetYRPBool("yrp_characterselection", true)
		ply:resetUptimeCurrent()
		YRPCheckClient(ply, steamid or uniqueID)
		if IsValid(ply) and ply.KillSilent then
			ply:KillSilent()
		end

		YRPSetAllCharsToDefaultRole(ply)
		if IsVoidCharEnabled() or GetGlobalYRPBool("bool_character_system", true) == false then
			local chars = YRP_SQL_SELECT("yrp_characters", "*", "SteamID = '" .. ply:YRPSteamID() .. "'")
			if not IsNotNilAndNotFalse(chars) then
				local tab = {}
				tab.roleID = 1
				tab.rpname = ply:Nick()
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

				YRPCreateCharacter(ply, tab)
				yrpmsg("[YourRP] [VOIDCHAR] HAS NO CHAR, create one")
			end
		end

		ply.DarkRPVars = {}
		ply.DarkRPVars.money = 0
		ply.DarkRPVars.salary = 0
		ply.DarkRPVars.job = ""
		ply.DarkRPVars.Energy = 0
		timer.Simple(
			0.01,
			function()
				if IsValid(ply) then
					ply.yrpauthed = true
				end
			end
		)
	end
)

YRP = YRP or {}
function YRP:Loadout(ply)
	if not IsValid(ply) then return end
	--YRP.msg( "gm", "[Loadout] " .. ply:YRPName() .. " get YourRP Loadout." )
	ply:SetYRPBool("bool_loadouted", false)
	ply:SetYRPInt("speak_channel", 0)
	ply:LockdownLoadout()
	ply:LevelSystemLoadout()
	ply:YRPCharacterLoadout()
	ply:SetYRPBool("bool_loadouted", true)
	local rd = ply:GetRagdollEntity()
	if IsValid(rd) then
		rd:Remove()
	end
end

function YRPSetBodyGroups(ply)
	if not IsValid(ply) then return end
	ply:YRPUpdateAppearance()
	local rolTab = ply:YRPGetRoleTable()
	if IsNotNilAndNotFalse(rolTab) and tonumber(rolTab.bool_savebodygroups) == 1 then
		local chaTab = ply:YRPGetCharacterTable()
		if IsNotNilAndNotFalse(chaTab) then
			ply:SetSkin(chaTab.skin)
			ply:SetupHands()
			for i = 0, 19 do
				ply:SetBodygroup(i, chaTab["bg" .. i])
			end
		end
	end
end

function YRPUpdateBodyGroups(ply, pmid, bgs)
	if not IsValid(ply) then return false end
	if IsNilOrFalse(ply:YRPGetCharacterTable()) then return false end
	local tab = {}
	bgs = bgs or {}
	tab.playermodelID = pmid or ply:YRPGetCharacterTable().playermodelID or 1
	tab.skin = ply:YRPGetCharacterTable().skin or 0
	for i = 0, 19 do
		tab["bg" .. i] = bgs[i] or ply:YRPGetCharacterTable()["bg" .. i]
	end

	YRP_SQL_UPDATE("yrp_characters", tab, "uniqueID = '" .. ply:CharID() .. "'")
	YRPSetBodyGroups(ply)

	return true
end

function YRPPlyUpdateStorage(ply)
	if not IsValid(ply) then return false end
	local chaTab = ply:YRPGetCharacterTable()
	if IsNotNilAndNotFalse(chaTab) and not IsVoidCharEnabled() then
		ply:SetYRPString("storage", chaTab.storage)
	end

	return true
end

function YRPPlayerLoadout(ply)
	if IsValid(ply) then
		YRP.msg("note", "[PlayerLoadout] for " .. ply:YRPName())
		ply:SetYRPString("licenseIDs1", "")
		ply:SetYRPString("licenseIDs2", "")
		ply:SetYRPString("licenseIDs3", "")
		ply:SetYRPInt("licenseIDsVersion", ply:GetYRPInt("licenseIDsVersion", 0) + 1)
		ply:StripWeapons()
		--YRP.msg( "gm", "[PlayerLoadout] " .. ply:YRPName() .. " get his role equipment." )
		YRP:Loadout(ply)
		if ply:HasCharacterSelected() then
			--[[ Status Reset ]]
			--
			ply:SetYRPBool("cuffed", false)
			ply:SetYRPBool("broken_leg_left", false)
			ply:SetYRPBool("broken_leg_right", false)
			ply:SetYRPBool("broken_arm_left", false)
			ply:SetYRPBool("broken_arm_right", false)
			--ply:Give( "yrp_unarmed" )
			local plyT = ply:GetPlyTab()
			if IsNotNilAndNotFalse(plyT) then
				ply:SetupCharID()
				local _rol_tab = ply:YRPGetRoleTable()
				if IsNotNilAndNotFalse(_rol_tab) then
					YRPSetRole(ply, _rol_tab.uniqueID)
					YRPSetPlayerModel(ply)
				else
					YRP.msg("note", "Give role failed -> KillSilent -> " .. ply:YRPName() .. " role: " .. tostring(_rol_tab))
					local chatab = ply:YRPGetCharacterTable()
					if IsNotNilAndNotFalse(chatab) then
						CheckIfRoleExists(ply, chatab.roleID)
					end

					ply:KillSilent()
				end

				local chaTab = ply:YRPGetCharacterTable()
				if IsNotNilAndNotFalse(chaTab) then
					if not IsVoidCharEnabled() then
						ply:SetYRPString("money", chaTab.money)
						ply:SetYRPString("moneybank", chaTab.moneybank)
						ply:SetYRPString("rpname", chaTab.rpname)
						ply:SetYRPString("rpdescription", chaTab.rpdescription)
						for i, v in pairs(string.Explode("\n", chaTab.rpdescription)) do
							ply:SetYRPString("rpdescription" .. i, v)
						end

						YRPPlyUpdateStorage(ply)
						YRPSetBodyGroups(ply)
					end
				else
					YRP.msg("note", "Give char failed -> KillSilent -> " .. ply:YRPName() .. " char: " .. tostring(chaTab))
					--if !ply:IsBot() then
					ply:KillSilent()
					--end
				end

				--ply:EquipWeapons()
				ply:YRPSetHunger(100)
				ply.DarkRPVars = ply.DarkRPVars or {}
				ply.DarkRPVars.Energy = 100
				ply:SetYRPFloat("thirst", 100)
				ply:SetYRPFloat("GetCurRadiation", 0)
			else
				YRP.msg("note", "[PlayerLoadout] can't get player-database.")
			end
		end

		ply:SetYRPBool("moneyready", true)
		--YRP.msg( "note", "[PlayerLoadout] " .. ply:YRPName() .. " has no character selected." )
		ply:UpdateBackpack()
	else
		YRP.msg("note", "[PlayerLoadout] is invalid or bot.")
	end
end

hook.Add(
	"PlayerLoadout",
	"yrp_PlayerLoadout",
	function(ply)
		--YRP.msg( "gm", "[PlayerLoadout] " .. tostring(ply:YRPName() ) .. " loadout." )
		timer.Simple(
			0.01,
			function()
				if IsValid(ply) then
					YRPPlayerLoadout(ply)
				end
			end
		)

		return true
	end
)

function YRPPlayerSpawn(ply, transition)
	local rolTab = ply:YRPGetRoleTable()
	if rolTab and not strEmpty(rolTab.string_playerspawn) then
		local code = rolTab.string_playerspawn
		timer.Simple(
			0.2,
			function()
				if IsValid(ply) then
					pcall(
						function(pl)
							RSPLY = pl or ply
							code = "local ply = RSPLY; " .. code
							local err = RunString(code, "role:" .. rolTab.uniqueID, false)
							if type(err) == "string" then
								YRP.msg("note", "ERROR [PlayerSpawn]: " .. tostring(err) .. " code: " .. tostring(code))
							end

							RSPLY = nil
						end, ply
					)
				end
			end
		)
	end
end

hook.Add(
	"PlayerSpawn",
	"____yrp_player_spawn_PlayerSpawn",
	function(ply, transition)
		if not IsValid(ply) then return end
		--YRP.msg( "gm", "[PlayerSpawn] " .. tostring(ply:YRPName() ) .. " spawned." )
		if ply:GetYRPBool("can_respawn", false) then
			ply:SetYRPBool("can_respawn", false)
			ply:SetupHands()
			YRPPlayerSpawn(ply, transition)
			if ply:GetYRPBool("switchrole", false) == false then
				timer.Simple(
					1.5,
					function()
						if ply:HasCharacterSelected() and ply:LoadedGamemode() then
							YRPTeleportToSpawnpoint(ply, "playerspawn")
							ply:SetYRPBool("yrp_spawning", false)
						end
					end
				)
			end
		end
	end
)

-- Choose the model for hands according to their player model.
function GM:PlayerSetHandsModel(ply, ent)
	local simplemodel = player_manager.TranslateToPlayerModelName(ply:GetModel())
	local info = player_manager.TranslatePlayerHands(simplemodel)
	if info then
		if info.model then
			ent:SetModel(info.model)
		end

		if info.skin then
			ent:SetSkin(info.skin)
		end

		if info.body then
			ent:SetBodyGroups(info.body)
		end
	end
end

hook.Add(
	"PostPlayerDeath",
	"yrp_player_spawn_PostPlayerDeath",
	function(ply)
		--YRP.msg( "gm", "[PostPlayerDeath] " .. tostring(ply:YRPName() ) .. " is dead." )
		if IsValid(ply) then
			ply:StopBleeding()
			ply:InteruptCasting()
			ply:SetYRPInt("yrp_stars", 0)
			ply:SetYRPFloat("permille", 0.0)
			ply:SetYRPBool("can_respawn", true)
		end
	end
)

function AddStar(ply)
	if IsValid(ply) then
		StartCombat(ply)
		local stars = ply:GetYRPInt("yrp_stars", 0) + 1
		local rand = math.random(0, 100)
		local chance = 100 / stars
		if rand <= chance then
			ply:SetYRPInt("yrp_stars", ply:GetYRPInt("yrp_stars", 0) + 1)
			if ply:GetYRPInt("yrp_stars", 0) > 5 then
				ply:SetYRPInt("yrp_stars", 5)
			end
		end
	end
end

function GM:PlayerDeath(ply, inflictor, attacker)
	ply.NextSpawnTime = CurTime() + 2
	ply.DeathTime = CurTime()
	if IsValid(attacker) and attacker:GetClass() == "trigger_hurt" then
		attacker = ply
	end

	if IsValid(attacker) and attacker:IsVehicle() and IsValid(attacker:GetDriver()) then
		attacker = attacker:GetDriver()
	end

	if not IsValid(inflictor) and IsValid(attacker) then
		inflictor = attacker
	end

	if IsValid(inflictor) and inflictor == attacker and (inflictor:IsPlayer() or inflictor:IsNPC()) then
		inflictor = inflictor:GetActiveWeapon()
		if not IsValid(inflictor) then
			inflictor = attacker
		end
	end

	if IsValid(attacker) and attacker == ply then
		net.Start("PlayerKilledSelf") -- GMOD net message
		net.WriteEntity(ply)
		net.Broadcast()

		return
	end

	if IsValid(attacker) and attacker:IsPlayer() then
		net.Start("PlayerKilledByPlayer") -- GMOD net message
		net.WriteEntity(ply)
		net.WriteString(inflictor:GetClass())
		net.WriteEntity(attacker)
		net.Broadcast()

		return
	end

	if ply and IsValid(inflictor) and IsValid(attacker) then
		net.Start("PlayerKilled") -- GMOD net message
		net.WriteEntity(ply)
		net.WriteString(inflictor:GetClass())
		net.WriteString(attacker:GetClass())
		net.Broadcast()
	end
end

hook.Add(
	"PlayerDeath",
	"yrp_stars_playerdeath",
	function(victim, inflictor, attacker)
		if attacker:IsPlayer() then
			AddStar(attacker)
		end

		YRPDoUnRagdoll(victim)
		if GetGlobalYRPBool("bool_characters_removeondeath", false) then
			YRP_SQL_UPDATE(
				"yrp_characters",
				{
					["bool_archived"] = 1
				}, "uniqueID = '" .. victim:CharID() .. "'"
			)

			victim:SetYRPBool("yrp_chararchived", true)
		end
	end
)

hook.Add(
	"OnNPCKilled",
	"yrp_stars_onnpckilled",
	function(npc, attacker, inflictor)
		AddStar(attacker)
	end
)

function IsNoDefaultWeapon(cname)
	if cname ~= "yrp_key" and cname ~= "yrp_unarmed" then
		return true
	else
		return false
	end
end

function IsNoAdminWeapon(cname)
	if cname ~= "weapon_physgun" and cname ~= "weapon_physcannon" and cname ~= "gmod_tool" and cname ~= "yrp_arrest_stick" then
		return true
	else
		return false
	end
end

function IsNoUserGroupWeapon(ply, cname)
	local _ugsweps = string.Explode(",", ply:GetYRPString("usergroup_sweps", ""))
	if not table.HasValue(_ugsweps, cname) then
		return true
	else
		return false
	end
end

function IsNoRoleSwep(ply, cname)
	if GetGlobalYRPBool("bool_drop_items_role", false) then
		local _rol_tab = ply:YRPGetRoleTable()
		if IsNotNilAndNotFalse(_rol_tab) then
			local _sweps = string.Explode(",", _rol_tab.string_sweps)
			if not table.HasValue(_sweps, cname) then
				return true
			else
				return false
			end
		end
	else
		return true
	end
end

function IsNoGroupSwep(ply, cname)
	if GetGlobalYRPBool("bool_drop_items_role", false) then
		local _gro_tab = ply:YRPGetGroupTable()
		if IsNotNilAndNotFalse(_gro_tab) then
			local _sweps = string.Explode(",", _gro_tab.string_sweps)
			if not table.HasValue(_sweps, cname) then
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
	local _rol_tab = ply:YRPGetRoleTable()
	if IsNotNilAndNotFalse(_rol_tab) then
		local _sweps = string.Explode(",", _rol_tab.string_ndsweps)
		if not table.HasValue(_sweps, cname) then
			return true
		else
			return false
		end
	end
end

local PLAYER = FindMetaTable("Player")
PLAYER.OldCreateRagdoll = PLAYER.OldCreateRagdoll or PLAYER.CreateRagdoll
function PLAYER:YRPCreateRagdoll()
	if PLAYER.OldCreateRagdoll ~= PLAYER.CreateRagdoll then
		self:PrintMessage(HUD_PRINTCENTER, "[REVIVE] There is another REVIVE SYSTEM INSTALLED")
	end

	local ply = self
	local oldragdoll = ply:GetRagdollEntity()
	if IsValid(oldragdoll) then
		oldragdoll:Remove()
	end

	local rd = ents.Create("prop_ragdoll")
	if IsValid(rd) and ply:GetModel() ~= nil then
		rd:SetModel(ply:GetModel())
		for id = 0, 19 do
			local val = ply:GetBodygroup(id)
			if val then
				rd:SetBodygroup(id, val)
			end
		end

		rd:SetPos(ply:GetPos())
		rd:SetAngles(ply:GetAngles())
		rd:SetVelocity(ply:GetVelocity())
		rd:Spawn()
		rd.ply = ply
		rd.index = rd:EntIndex()
		rd.removeable = false
		rd:SetYRPEntity("yrp_player", ply)
		ply:SetYRPEntity("yrp_ragdoll", rd)
		ply:SetYRPInt("ent_ragdollindex", rd:EntIndex())
		timer.Simple(
			GetGlobalYRPInt("int_deathtimestamp_max", 60),
			function()
				if IsValid(ply) then
					local ragdoll = ply:GetRagdollEntity()
					if IsValid(ragdoll) and ragdoll.index == ply:GetYRPInt("ent_ragdollindex") then
						ragdoll:Remove()
					end
				end
			end
		)
	else
		if not IsValid(rd) then
			YRP.msg("note", "[DoPlayerDeath] Spawn Defi Ragdoll... FAILED: rd is not valid")
		elseif ply:GetModel() ~= nil then
			YRP.msg("note", "[DoPlayerDeath] GetModel... FAILED: nil")
		end
	end
end

function PLAYER:AddPlayTime(force)
	-- char changed or FORCED
	if self.yrp_ts_oldchar ~= self:CharID() or force then
		-- Calculate Time
		-- ADD TIME FOR OLD CHAR
		if self.yrp_ts_oldchar then
			local playtime = os.time() - self:GetYRPInt("ts_spawned", os.time())
			local tab = YRP_SQL_SELECT("yrp_characters", "uniqueID, text_playtime", "uniqueID = '" .. self.yrp_ts_oldchar .. "'")
			if IsNotNilAndNotFalse(tab) then
				local oldplaytime = tab[1].text_playtime
				YRP_SQL_UPDATE(
					"yrp_characters",
					{
						["text_playtime"] = oldplaytime + playtime
					}, "uniqueID = '" .. self.yrp_ts_oldchar .. "'"
				)
			end
		end

		-- Set For New Char
		self:SetYRPInt("ts_spawned", os.time())
		self.yrp_ts_oldchar = self:CharID()
	end
end

function GM:DoPlayerDeath(ply, attacker, dmginfo)
	ply:YRPCreateRagdoll()
	if PLAYER.OldCreateRagdoll ~= PLAYER.CreateRagdoll then
		ply:CreateRagdoll()
	end

	ply:AddDeaths(1)
	if attacker:IsValid() and attacker:IsPlayer() then
		if attacker == ply then
			attacker:AddFrags(-1)
		else
			attacker:AddFrags(1)
		end
	end

	ply:SetYRPInt("int_deathtimestamp_min", CurTime() + GetGlobalYRPInt("int_deathtimestamp_min", 20))
	ply:SetYRPInt("int_deathtimestamp_max", CurTime() + GetGlobalYRPInt("int_deathtimestamp_max", 60))
end

hook.Add(
	"DoPlayerDeath",
	"yrp_player_spawn_DoPlayerDeath",
	function(ply, attacker, dmg)
		if attacker.SteamID and ply.SteamID then
			YRP_SQL_INSERT_INTO("yrp_logs", "string_timestamp, string_typ, string_source_steamid, string_target_steamid, string_value", "'" .. os.time() .. "' ,'LID_kills', '" .. attacker:SteamID() .. "', '" .. ply:SteamID() .. "', '" .. dmg:GetDamage() .. "'")
		end

		--YRP.msg( "gm", "[DoPlayerDeath] " .. tostring(ply:YRPName() ) .. " do death." )
		local _reward = tonumber(ply:GetYRPString("hitreward"))
		if isnumber(_reward) and attacker:IsPlayer() and attacker:IsAgent() then
			YRP.msg("note", "Hit done! " .. _reward)
			attacker:addMoney(_reward)
			hitdone(ply, attacker)
		end

		local roleondeathuid = ply:GetRoleOnDeathRoleUID()
		if roleondeathuid > 0 then
			YRPSetRole(ply, roleondeathuid, false)
		end

		if IsDropItemsOnDeathEnabled() then
			local _weapons = ply:GetWeapons()
			local _cooldown_item = 60
			for i, wep in pairs(_weapons) do
				if wep:GetModel() ~= "" and IsNoDefaultWeapon(wep:GetClass()) and IsNoRoleSwep(ply, wep:GetClass()) and IsNoGroupSwep(ply, wep:GetClass()) and IsNoUserGroupWeapon(ply, wep:GetClass()) then
					local wepClass = wep:GetClass()
					timer.Simple(
						0.04 * i,
						function()
							ply:DropSWEP(wepClass, true)
							timer.Simple(
								_cooldown_item,
								function()
									if wep:IsValid() and wep:GetOwner() == "" then
										wep:Remove()
									end
								end
							)
						end
					)
				end
				--ply:DropSWEPSilence(wep:GetClass() )
			end
		end

		if IsDropMoneyOnDeathEnabled() and not ply:GetYRPBool("switchrole", false) then
			local _money = ply:GetMoney()
			local _max = GetMaxAmountOfDroppedMoney()
			if _money > _max then
				_money = _max
			end

			if _money > 0 then
				local money = ents.Create("yrp_money")
				if IsNotNilAndNotFalse(money) then
					money:SetPos(ply:GetPos())
					money:Spawn()
					money:SetMoney(_money)
					ply:addMoney(-_money)
				end
			end
		end
	end
)

local function YRPDeathKeys(pl)
	return pl:KeyPressed(IN_ATTACK) or pl:KeyPressed(IN_ATTACK2) or pl:KeyPressed(IN_JUMP)
end

function GM:PlayerDeathThink(pl)
	pl.deadts = pl.deadts or 0
	if pl:GetYRPInt("int_deathtimestamp_max", 0) > CurTime() then
		if GetGlobalYRPBool("bool_deathscreen", false) == false and YRPDeathKeys(pl) and pl.deadts < CurTime() then
			pl.deadts = CurTime() + 0.3
			pl:PrintMessage(HUD_PRINTCENTER, string.format(YRP.trans("LID_youreunconsious") .. ". (%0.1f" .. "s)", pl:GetYRPInt("int_deathtimestamp_max", 0) - CurTime()))
		end

		return false
	end

	if YRPDeathKeys(pl) then
		if pl:IsBot() then
			pl:Spawn()
		end

		if GetGlobalYRPBool("bool_deathscreen", false) == false then
			pl:Spawn()
		end
	end
end

function GM:ShutDown()
	YRPSaveClients("Shutdown/Changelevel")
	--SaveStorages( "Shutdown/Changelevel" )
end

function GM:GetFallDamage(ply, speed)
	local _damage = speed * YRPCustomFalldamageMultiplier()
	if ply:GetYRPString("GetAbilityType", "none") == "force" then return 0 end
	if IsCustomFalldamageEnabled() then
		if speed > ply:GetModelScale() * 120 then
			if IsBonefracturingEnabled() then
				local _rand = math.Round(math.Rand(0, 1), 0)
				if _rand == 0 then
					ply:SetYRPBool("broken_leg_right", true)
				elseif _rand == 1 then
					ply:SetYRPBool("broken_leg_left", true)
				end
			end

			if IsCustomFalldamagePercentageEnabled() then
				return _damage * ply:GetMaxHealth() / 100
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

hook.Add(
	"PlayerSwitchWeapon",
	"yrp_playerswitchweapon",
	function(ply, oldWeapon, newWeapon)
		ply:InteruptCasting()
		if newWeapon:IsScripted() and newWeapon:GetYRPString("swep_holdtype", "") == "" then
			local _hold_type = newWeapon.HoldType or newWeapon:GetHoldType() or "normal"
			newWeapon:SetYRPString("swep_holdtype", _hold_type)
		end

		if ply:GetYRPBool("cuffed") or ply.leiche ~= nil then return true end
	end
)

function IsAllowedToSuicide(ply)
	if not IsValid(ply) then return end
	if ply:HasAccess("IsAllowedToSuicide", true) then
		return true
	elseif IsSuicideDisabled() or ply:IsFlagSet(FL_FROZEN) or ply:GetYRPBool("ragdolled", false) or ply:GetYRPBool("injail", false) then
		return false
	else
		return true
	end
end

function GM:CanPlayerSuicide(ply)
	if not IsValid(ply) then return end

	return IsAllowedToSuicide(ply)
end

hook.Add(
	"EntityTakeDamage",
	"YRP_EntityTakeDamage",
	function(ent, dmginfo)
		if IsInsideSafezone(ent) or (ent:IsPlayer() and (ent:HasGodMode() or ent:GetYRPBool("godmode", false))) then
			dmginfo:ScaleDamage(0)
		else
			local attacker = dmginfo:GetAttacker()
			if IsValid(attacker) and IsInsideSafezone(attacker) then
				dmginfo:ScaleDamage(0)
			else
				if IsEntity(ent) and not ent:IsPlayer() and not ent:IsNPC() then
					local hitfactor = GetHitFactorEntities() or 1
					dmginfo:ScaleDamage(hitfactor)
				elseif ent:IsVehicle() then
					local hitfactor = GetHitFactorVehicles() or 1
					dmginfo:ScaleDamage(hitfactor)
				elseif ent:IsPlayer() then
					if GetGlobalYRPBool("bool_antipropkill", true) and IsValid(dmginfo:GetAttacker()) and dmginfo:GetAttacker():GetClass() == "prop_physics" then
						dmginfo:ScaleDamage(0)
					end

					if dmginfo:GetDamageType() == DMG_BURN then
						dmginfo:ScaleDamage(ent:GetYRPFloat("float_dmgtype_burn", 1.0))
					elseif dmginfo:GetDamageType() == DMG_BULLET then
						dmginfo:ScaleDamage(ent:GetYRPFloat("float_dmgtype_bullet", 1.0))
					elseif dmginfo:GetDamageType() == DMG_ENERGYBEAM then
						dmginfo:ScaleDamage(ent:GetYRPFloat("float_dmgtype_energybeam", 1.0))
					else
						dmginfo:ScaleDamage(1)
					end
				else
					dmginfo:ScaleDamage(1)
				end
			end
		end
	end
)

function SlowThink(ent)
	if IsSlowingEnabled() then
		local speedrun = tonumber(ent:GetYRPInt("speedrun", 0))
		local speedwalk = tonumber(ent:GetYRPInt("speedwalk", 0))
		if speedrun == tonumber(ent:GetRunSpeed()) or speedwalk == tonumber(ent:GetWalkSpeed()) then
			ent:SetRunSpeed(speedrun * GetSlowingFactor())
			ent:SetWalkSpeed(speedwalk * GetSlowingFactor())
			ent:SetYRPBool("slowed", true)
			timer.Simple(
				GetSlowingTime(),
				function()
					if IsValid(ent) then
						ent:SetRunSpeed(speedrun)
						ent:SetWalkSpeed(speedwalk)
						ent:SetYRPBool("slowed", false)
					end
				end
			)
		end
	end
end

function StartCombat(ply)
	if ply:IsValid() and ply:IsPlayer() then
		ply:SetYRPBool("inCombat", true)
		local steamid = ply:YRPSteamID()
		if timer.Exists(steamid .. " outOfCombat") then
			timer.Remove(steamid .. " outOfCombat")
		end

		timer.Create(
			steamid .. " outOfCombat",
			5,
			1,
			function()
				if YRPEntityAlive(ply) then
					ply:SetYRPBool("inCombat", false)
					if timer.Exists(steamid .. " outOfCombat") then
						timer.Remove(steamid .. " outOfCombat")
					end
				else
					if timer.Exists(steamid .. " outOfCombat") then
						timer.Remove(steamid .. " outOfCombat")
					end
				end
			end
		)
	end
end

hook.Add(
	"ScalePlayerDamage",
	"YRP_ScalePlayerDamage",
	function(ply, hitgroup, dmginfo)
		if ply and ply.IsFullyAuthenticated and ply:IsFullyAuthenticated() then
			if IsInsideSafezone(ply) or ply:HasGodMode() or ply:GetYRPBool("godmode", false) then
				dmginfo:ScaleDamage(0)
			else
				local attacker = dmginfo:GetAttacker()
				if IsValid(attacker) and IsInsideSafezone(attacker) then
					dmginfo:ScaleDamage(0)
				else
					if IsValid(dmginfo:GetAttacker()) and dmginfo:GetAttacker() ~= ply then
						StartCombat(ply)
					end

					SlowThink(ply)
					if GetGlobalYRPBool("bool_antipropkill", true) and IsValid(dmginfo:GetAttacker()) and dmginfo:GetAttacker():GetClass() == "prop_physics" then
						dmginfo:ScaleDamage(0)
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
									ply:SetYRPBool("broken_arm_left", true)
									if not ply:HasWeapon("yrp_unarmed") then
										ply:Give("yrp_unarmed")
									end

									ply:SelectWeapon("yrp_unarmed")
								elseif hitgroup == HITGROUP_RIGHTARM then
									ply:SetYRPBool("broken_arm_right", true)
									if not ply:HasWeapon("yrp_unarmed") then
										ply:Give("yrp_unarmed", true)
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
									ply:SetYRPBool("broken_leg_left", true)
								elseif hitgroup == HITGROUP_RIGHTLEG then
									ply:SetYRPBool("broken_leg_right", true)
								end
							end
						end
					else
						dmginfo:ScaleDamage(1)
					end

					local damage = dmginfo:GetDamage()
					damage = math.Round(damage, 2)
					if IsValid(attacker) and attacker:IsPlayer() then
						YRP_SQL_INSERT_INTO("yrp_logs", "string_timestamp, string_typ, string_source_steamid, string_target_steamid, string_value", "'" .. os.time() .. "' ,'LID_health', '" .. attacker:SteamID() .. "', '" .. ply:SteamID() .. "', '" .. dmginfo:GetDamage() .. "'")
					elseif IsValid(attacker) then
						YRP_SQL_INSERT_INTO("yrp_logs", "string_timestamp, string_typ, string_target_steamid, string_value, string_alttarget", "'" .. os.time() .. "' ,'LID_health', '" .. ply:SteamID() .. "', '" .. damage .. "', " .. YRP_SQL_STR_IN(attacker:GetName() .. attacker:GetClass()) .. "")
					end
				end
			end
		end
	end
)

hook.Add(
	"ScaleNPCDamage",
	"YRP_ScaleNPCDamage",
	function(npc, hitgroup, dmginfo)
		local attacker = dmginfo:GetAttacker()
		if IsValid(attacker) and IsInsideSafezone(attacker) then
			dmginfo:ScaleDamage(0)
		elseif IsInsideSafezone(npc) then
			dmginfo:ScaleDamage(0)
		elseif hitgroup == HITGROUP_HEAD then
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
	end
)

util.AddNetworkString("nws_yrp_voice_start")
net.Receive(
	"nws_yrp_voice_start",
	function(len, ply)
		ply:SetYRPBool("yrp_speaking", true)
	end
)

util.AddNetworkString("nws_yrp_voice_end")
net.Receive(
	"nws_yrp_voice_end",
	function(len, ply)
		ply:SetYRPBool("yrp_speaking", false)
	end
)

util.AddNetworkString("nws_yrp_mute_voice")
net.Receive(
	"nws_yrp_mute_voice",
	function(len, ply)
		ply:SetYRPBool("mute_voice", not ply:GetYRPBool("mute_voice", false))
	end
)

util.AddNetworkString("nws_yrp_voice_range_up")
net.Receive(
	"nws_yrp_voice_range_up",
	function(len, ply)
		ply:SetYRPInt("voice_range", math.Clamp(ply:GetYRPInt("voice_range", 2) + 1, 0, 4))
	end
)

util.AddNetworkString("nws_yrp_voice_range_dn")
net.Receive(
	"nws_yrp_voice_range_dn",
	function(len, ply)
		ply:SetYRPInt("voice_range", math.Clamp(ply:GetYRPInt("voice_range", 2) - 1, 0, 4))
	end
)

-- VOICE CHANNELS
local DATABASE_NAME = "yrp_voice_channels"
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_name", "TEXT DEFAULT 'Unnamed'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_hear", "INTEGER DEFAULT '0'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_mode", "TEXT DEFAULT '0'") -- 0 = Normal, 1 = Global
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_position", "INT DEFAULT '0'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_active_usergroups", "TEXT DEFAULT 'superadmin,user'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_active_groups", "TEXT DEFAULT '1'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_active_roles", "TEXT DEFAULT '1'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_passive_usergroups", "TEXT DEFAULT 'superadmin,user'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_passive_groups", "TEXT DEFAULT '1'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_passive_roles", "TEXT DEFAULT '1'")
--YRP_SQL_DROP_TABLE(DATABASE_NAME)
local yrp_voice_channels = {}
if YRP_SQL_SELECT(DATABASE_NAME, "*") == nil then
	YRP_SQL_INSERT_INTO(DATABASE_NAME, "string_name, int_hear, string_mode, string_active_usergroups, string_passive_usergroups", "'DEFAULT', '1', '0', 'superadmin, admin, user', 'superadmin, admin, user'")
end

function GenerateVoiceTable()
	yrp_voice_channels = {}
	local channels = YRP_SQL_SELECT(DATABASE_NAME, "*")
	if IsNotNilAndNotFalse(channels) then
		for i, channel in pairs(channels) do
			yrp_voice_channels[tonumber(channel.uniqueID)] = {}
			yrp_voice_channels[tonumber(channel.uniqueID)].uniqueID = tonumber(channel.uniqueID)
			-- NAME
			yrp_voice_channels[tonumber(channel.uniqueID)]["string_name"] = channel.string_name
			-- Hear?
			yrp_voice_channels[tonumber(channel.uniqueID)]["int_hear"] = tobool(channel.int_hear)
			-- MODE
			yrp_voice_channels[tonumber(channel.uniqueID)]["string_mode"] = tonumber(channel.string_mode)
			-- POSITION
			yrp_voice_channels[tonumber(channel.uniqueID)]["int_position"] = tonumber(channel.int_position)
			-- ACTIVE
			local augs = {}
			if channel.string_active_usergroups then
				augs = string.Explode(",", channel.string_active_usergroups)
			end

			yrp_voice_channels[tonumber(channel.uniqueID)]["string_active_usergroups"] = {}
			for _, ug in pairs(augs) do
				if not strEmpty(ug) then
					yrp_voice_channels[tonumber(channel.uniqueID)]["string_active_usergroups"][ug] = true
				end
			end

			local agrps = {}
			if channel.string_active_groups then
				agrps = string.Explode(",", channel.string_active_groups)
			end

			yrp_voice_channels[tonumber(channel.uniqueID)]["string_active_groups"] = {}
			for _, grp in pairs(agrps) do
				if not strEmpty(grp) then
					yrp_voice_channels[tonumber(channel.uniqueID)]["string_active_groups"][tonumber(grp)] = true
				end
			end

			local arols = {}
			if channel.string_active_roles then
				arols = string.Explode(",", channel.string_active_roles)
			end

			yrp_voice_channels[tonumber(channel.uniqueID)]["string_active_roles"] = {}
			for _, rol in pairs(arols) do
				if not strEmpty(rol) then
					yrp_voice_channels[tonumber(channel.uniqueID)]["string_active_roles"][tonumber(rol)] = true
				end
			end

			-- PASSIVE
			local pugs = {}
			if channel.string_passive_usergroups then
				pugs = string.Explode(",", channel.string_passive_usergroups)
			end

			yrp_voice_channels[tonumber(channel.uniqueID)]["string_passive_usergroups"] = {}
			for _, ug in pairs(pugs) do
				if not strEmpty(ug) then
					yrp_voice_channels[tonumber(channel.uniqueID)]["string_passive_usergroups"][ug] = true
				end
			end

			local pgrps = {}
			if channel.string_passive_groups then
				pgrps = string.Explode(",", channel.string_passive_groups)
			end

			yrp_voice_channels[tonumber(channel.uniqueID)]["string_passive_groups"] = {}
			for _, grp in pairs(pgrps) do
				if not strEmpty(grp) then
					yrp_voice_channels[tonumber(channel.uniqueID)]["string_passive_groups"][tonumber(grp)] = true
				end
			end

			local prols = {}
			if channel.string_passive_roles then
				prols = string.Explode(",", channel.string_passive_roles)
			end

			yrp_voice_channels[tonumber(channel.uniqueID)]["string_passive_roles"] = {}
			for _, rol in pairs(prols) do
				if not strEmpty(rol) then
					yrp_voice_channels[tonumber(channel.uniqueID)]["string_passive_roles"][tonumber(rol)] = true
				end
			end
		end
	else
		yrp_voice_channels = {}
	end

	SetGlobalYRPTable("yrp_voice_channels", yrp_voice_channels)
end

GenerateVoiceTable()
util.AddNetworkString("nws_yrp_vm_get_active_usergroups")
net.Receive(
	"nws_yrp_vm_get_active_usergroups",
	function(len, ply)
		local ugs = YRP_SQL_SELECT("yrp_usergroups", "uniqueID, string_name", nil)
		if IsNotNilAndNotFalse(ugs) then
			net.Start("nws_yrp_vm_get_active_usergroups")
			net.WriteTable(ugs)
			net.Send(ply)
		end
	end
)

util.AddNetworkString("nws_yrp_vm_get_active_groups")
net.Receive(
	"nws_yrp_vm_get_active_groups",
	function(len, ply)
		local grps = YRP_SQL_SELECT("yrp_ply_groups", "uniqueID, string_name", nil)
		if IsNotNilAndNotFalse(grps) then
			net.Start("nws_yrp_vm_get_active_groups")
			net.WriteTable(grps)
			net.Send(ply)
		end
	end
)

util.AddNetworkString("nws_yrp_vm_get_active_roles")
net.Receive(
	"nws_yrp_vm_get_active_roles",
	function(len, ply)
		local rols = YRP_SQL_SELECT("yrp_ply_roles", "uniqueID, string_name", nil)
		if IsNotNilAndNotFalse(rols) then
			net.Start("nws_yrp_vm_get_active_roles")
			net.WriteTable(rols)
			net.Send(ply)
		end
	end
)

util.AddNetworkString("nws_yrp_vm_get_passive_usergroups")
net.Receive(
	"nws_yrp_vm_get_passive_usergroups",
	function(len, ply)
		local ugs = YRP_SQL_SELECT("yrp_usergroups", "uniqueID, string_name", nil)
		if IsNotNilAndNotFalse(ugs) then
			net.Start("nws_yrp_vm_get_passive_usergroups")
			net.WriteTable(ugs)
			net.Send(ply)
		end
	end
)

util.AddNetworkString("nws_yrp_vm_get_passive_groups")
net.Receive(
	"nws_yrp_vm_get_passive_groups",
	function(len, ply)
		local grps = YRP_SQL_SELECT("yrp_ply_groups", "uniqueID, string_name", nil)
		if IsNotNilAndNotFalse(grps) then
			net.Start("nws_yrp_vm_get_passive_groups")
			net.WriteTable(grps)
			net.Send(ply)
		end
	end
)

util.AddNetworkString("nws_yrp_vm_get_passive_roles")
net.Receive(
	"nws_yrp_vm_get_passive_roles",
	function(len, ply)
		local rols = YRP_SQL_SELECT("yrp_ply_roles", "uniqueID, string_name", nil)
		if IsNotNilAndNotFalse(rols) then
			net.Start("nws_yrp_vm_get_passive_roles")
			net.WriteTable(rols)
			net.Send(ply)
		end
	end
)

util.AddNetworkString("nws_yrp_voice_channel_add")
net.Receive(
	"nws_yrp_voice_channel_add",
	function(len, ply)
		local name = net.ReadString()
		local hear = tonum(net.ReadBool())
		local augs = table.concat(net.ReadTable(), ",")
		local agrps = table.concat(net.ReadTable(), ",")
		local arols = table.concat(net.ReadTable(), ",")
		local pugs = table.concat(net.ReadTable(), ",")
		local pgrps = table.concat(net.ReadTable(), ",")
		local prols = table.concat(net.ReadTable(), ",")
		YRP_SQL_INSERT_INTO(DATABASE_NAME, "string_name, int_hear, string_active_usergroups, string_active_groups, string_active_roles, string_passive_usergroups, string_passive_groups, string_passive_roles, int_position", "" .. YRP_SQL_STR_IN(name) .. ", '" .. hear .. "', '" .. augs .. "', '" .. agrps .. "', '" .. arols .. "', '" .. pugs .. "', '" .. pgrps .. "', '" .. prols .. "', '" .. table.Count(GetGlobalYRPTable("yrp_voice_channels", {})) .. "'")
		GenerateVoiceTable()
		local c = 0
		for i, channel in SortedPairsByMemberValue(GetGlobalYRPTable("yrp_voice_channels", {}), "int_position") do
			channel.int_position = tonumber(channel.int_position)
			if channel.int_position ~= c then
				YRP_SQL_UPDATE(
					DATABASE_NAME,
					{
						["int_position"] = c
					}, "uniqueID = '" .. channel.uniqueID .. "'"
				)
			end

			c = c + 1
		end

		GenerateVoiceTable()
	end
)

util.AddNetworkString("nws_yrp_voice_channel_save")
net.Receive(
	"nws_yrp_voice_channel_save",
	function(len, ply)
		local name = net.ReadString()
		local hear = tonum(net.ReadBool())
		local augs = table.concat(net.ReadTable(), ",")
		local agrps = table.concat(net.ReadTable(), ",")
		local arols = table.concat(net.ReadTable(), ",")
		local pugs = table.concat(net.ReadTable(), ",")
		local pgrps = table.concat(net.ReadTable(), ",")
		local prols = table.concat(net.ReadTable(), ",")
		local uid = net.ReadString()
		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["string_name"] = name,
				["int_hear"] = hear,
				["string_active_usergroups"] = augs,
				["string_active_groups"] = agrps,
				["string_active_roles"] = arols,
				["string_passive_usergroups"] = pugs,
				["string_passive_groups"] = pgrps,
				["string_passive_roles"] = prols
			}, "uniqueID = '" .. uid .. "'"
		)

		GenerateVoiceTable()
	end
)

util.AddNetworkString("nws_yrp_voice_channel_rem")
net.Receive(
	"nws_yrp_voice_channel_rem",
	function(len, ply)
		local uid = net.ReadString()
		YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. uid .. "'")
		GenerateVoiceTable()
		local c = 0
		for i, channel in SortedPairsByMemberValue(GetGlobalYRPTable("yrp_voice_channels", {}), "int_position") do
			channel.int_position = tonumber(channel.int_position)
			if channel.int_position ~= c then
				YRP_SQL_UPDATE(
					DATABASE_NAME,
					{
						["int_position"] = c
					}, "uniqueID = '" .. channel.uniqueID .. "'"
				)
			end

			c = c + 1
		end

		GenerateVoiceTable()
	end
)

util.AddNetworkString("nws_yrp_channel_up")
net.Receive(
	"nws_yrp_channel_up",
	function(len, ply)
		local uid = net.ReadString()
		uid = tonumber(uid)
		if GetGlobalYRPTable("yrp_voice_channels", {}) then
			local int_position = GetGlobalYRPTable("yrp_voice_channels", {})[uid].int_position
			local c = 0
			for i, channel in SortedPairsByMemberValue(GetGlobalYRPTable("yrp_voice_channels", {}), "int_position") do
				channel.int_position = tonumber(channel.int_position)
				if c == int_position then
					YRP_SQL_UPDATE(
						DATABASE_NAME,
						{
							["int_position"] = c - 1
						}, "uniqueID = '" .. channel.uniqueID .. "'"
					)
				elseif c == int_position - 1 then
					YRP_SQL_UPDATE(
						DATABASE_NAME,
						{
							["int_position"] = c + 1
						}, "uniqueID = '" .. channel.uniqueID .. "'"
					)
				elseif channel.int_position ~= c then
					YRP_SQL_UPDATE(
						DATABASE_NAME,
						{
							["int_position"] = c
						}, "uniqueID = '" .. channel.uniqueID .. "'"
					)
				end

				c = c + 1
			end

			GenerateVoiceTable()
		end

		timer.Simple(
			0.1,
			function()
				net.Start("nws_yrp_channel_up")
				net.Send(ply)
			end
		)
	end
)

util.AddNetworkString("nws_yrp_channel_dn")
net.Receive(
	"nws_yrp_channel_dn",
	function(len, ply)
		local uid = net.ReadString()
		uid = tonumber(uid)
		if GetGlobalYRPTable("yrp_voice_channels", {}) then
			local int_position = GetGlobalYRPTable("yrp_voice_channels", {})[uid].int_position
			local c = 0
			for i, channel in SortedPairsByMemberValue(GetGlobalYRPTable("yrp_voice_channels", {}), "int_position") do
				channel.int_position = tonumber(channel.int_position)
				if c == int_position then
					YRP_SQL_UPDATE(
						DATABASE_NAME,
						{
							["int_position"] = c + 1
						}, "uniqueID = '" .. channel.uniqueID .. "'"
					)
				elseif c == int_position + 1 then
					YRP_SQL_UPDATE(
						DATABASE_NAME,
						{
							["int_position"] = c - 1
						}, "uniqueID = '" .. channel.uniqueID .. "'"
					)
				elseif channel.int_position ~= c then
					YRP_SQL_UPDATE(
						DATABASE_NAME,
						{
							["int_position"] = c
						}, "uniqueID = '" .. channel.uniqueID .. "'"
					)
				end

				c = c + 1
			end

			GenerateVoiceTable()
		end

		timer.Simple(
			0.1,
			function()
				net.Start("nws_yrp_channel_dn")
				net.Send(ply)
			end
		)
	end
)

function YRPCountActiveChannels(ply)
	if not IsValid(ply) then return end
	local c = 0
	local cm = 0
	for i, channel in SortedPairsByMemberValue(GetGlobalYRPTable("yrp_voice_channels", {}), "int_position", false) do
		if IsActiveInChannel(ply, channel.uniqueID, true) then
			c = c + 1
			if IsActiveInChannel(ply, channel.uniqueID) then
				cm = cm + 1
			end
		end
	end

	ply:SetYRPInt("yrp_voice_channel_active", c)
	ply:SetYRPInt("yrp_voice_channel_active_mic", cm)
end

function YRPCountPassiveChannels(ply)
	if not IsValid(ply) then return end
	local c = 0
	local cm = 0
	for i, channel in SortedPairsByMemberValue(GetGlobalYRPTable("yrp_voice_channels", {}), "int_position", false) do
		if IsInChannel(ply, channel.uniqueID, true) then
			c = c + 1
			if IsInChannel(ply, channel.uniqueID) then
				cm = cm + 1
			end
		end
	end

	ply:SetYRPInt("yrp_voice_channel_passive", c)
	ply:SetYRPInt("yrp_voice_channel_passive_voice", cm)
end

function YRPSwitchToVoiceChannel(ply, uid)
	if not IsValid(ply) then return end
	if not ply:GetYRPBool("yrp_voice_channel_mutemic_" .. uid, true) then
		ply:SetYRPBool("yrp_voice_channel_mutemic_" .. uid, true)
	else
		--[[for i, channel in SortedPairsByMemberValue(GetGlobalYRPTable( "yrp_voice_channels", {}), "int_position", false) do
			if !ply:GetYRPBool( "yrp_voice_channel_mutemic_" .. channel.uniqueID, true) then
				ply:SetYRPBool( "yrp_voice_channel_mute_" .. channel.uniqueID, false)
			end
		end]]
		for i, channel in SortedPairsByMemberValue(GetGlobalYRPTable("yrp_voice_channels", {}), "int_position", false) do
			if channel.uniqueID == uid then
				ply:SetYRPBool("yrp_voice_channel_mutemic_" .. channel.uniqueID, false)
				ply:SetYRPBool("yrp_voice_channel_mute_" .. channel.uniqueID, true)
			else
				ply:SetYRPBool("yrp_voice_channel_mutemic_" .. channel.uniqueID, true)
			end
		end
	end

	YRPCountActiveChannels(ply)
	YRPCountPassiveChannels(ply)
end

util.AddNetworkString("nws_yrp_mutemic_channel")
net.Receive(
	"nws_yrp_mutemic_channel",
	function(len, ply)
		local uid = net.ReadString()
		uid = uid or "0"
		uid = tonumber(uid)
		if not ply:GetYRPBool("yrp_voice_channel_mute_" .. uid, false) then
			ply:SetYRPBool("yrp_voice_channel_mute_" .. uid, true)
		end

		ply:SetYRPBool("yrp_voice_channel_mutemic_" .. uid, not ply:GetYRPBool("yrp_voice_channel_mutemic_" .. uid, false))
		YRPCountActiveChannels(ply)
		YRPCountPassiveChannels(ply)
	end
)

util.AddNetworkString("nws_yrp_mute_channel")
net.Receive(
	"nws_yrp_mute_channel",
	function(len, ply)
		local uid = net.ReadString()
		if not ply:GetYRPBool("yrp_voice_channel_mutemic_" .. uid, false) then
			ply:SetYRPBool("yrp_voice_channel_mutemic_" .. uid, true)
		end

		ply:SetYRPBool("yrp_voice_channel_mute_" .. uid, not ply:GetYRPBool("yrp_voice_channel_mute_" .. uid, false))
		YRPCountActiveChannels(ply)
		YRPCountPassiveChannels(ply)
	end
)

util.AddNetworkString("nws_yrp_mutemic_channel_all")
net.Receive(
	"nws_yrp_mutemic_channel_all",
	function(len, ply)
		ply:SetYRPBool("mutemic_channel_all", not ply:GetYRPBool("mutemic_channel_all", false))
		for i, channel in SortedPairsByMemberValue(GetGlobalYRPTable("yrp_voice_channels", {}), "int_position", false) do
			ply:SetYRPBool("yrp_voice_channel_mutemic_" .. channel.uniqueID, ply:GetYRPBool("mutemic_channel_all", false))
		end

		YRPCountActiveChannels(ply)
		YRPCountPassiveChannels(ply)
	end
)

util.AddNetworkString("nws_yrp_mute_channel_all")
net.Receive(
	"nws_yrp_mute_channel_all",
	function(len, ply)
		ply:SetYRPBool("mute_channel_all", not ply:GetYRPBool("mute_channel_all", false))
		for i, channel in SortedPairsByMemberValue(GetGlobalYRPTable("yrp_voice_channels", {}), "int_position", false) do
			ply:SetYRPBool("yrp_voice_channel_mute_" .. channel.uniqueID, ply:GetYRPBool("mute_channel_all", false))
		end

		YRPCountActiveChannels(ply)
		YRPCountPassiveChannels(ply)
	end
)

function YRPMoveAllToNext(ply)
	if not IsValid(ply) then return end
	local found = false
	for i, channel in SortedPairsByMemberValue(GetGlobalYRPTable("yrp_voice_channels", {}), "int_position", false) do
		if IsActiveInChannel(ply, channel.uniqueID, true) then
			if not found and ply:GetYRPBool("yrp_voice_channel_mutemic_" .. channel.uniqueID) == false then
				ply:SetYRPBool("yrp_voice_channel_mutemic_" .. channel.uniqueID, true)
				ply:SetYRPBool("yrp_voice_channel_mute_" .. channel.uniqueID, false)
				found = true
			elseif found and ply:GetYRPBool("yrp_voice_channel_mute_" .. channel.uniqueID) == false then
				ply:SetYRPBool("yrp_voice_channel_mutemic_" .. channel.uniqueID, false)
				ply:SetYRPBool("yrp_voice_channel_mute_" .. channel.uniqueID, true)
				found = false
			end
		end
	end

	if found then
		for i, channel in SortedPairsByMemberValue(GetGlobalYRPTable("yrp_voice_channels", {}), "int_position", false) do
			if IsActiveInChannel(ply, channel.uniqueID, true) and found and ply:GetYRPBool("yrp_voice_channel_mute_" .. channel.uniqueID) == false then
				ply:SetYRPBool("yrp_voice_channel_mutemic_" .. channel.uniqueID, false)
				ply:SetYRPBool("yrp_voice_channel_mute_" .. channel.uniqueID, true)
				found = false
			end
		end
	end

	if not found then
		for i, channel in SortedPairsByMemberValue(GetGlobalYRPTable("yrp_voice_channels", {}), "int_position", false) do
			if IsActiveInChannel(ply, channel.uniqueID, true) and ply:GetYRPBool("yrp_voice_channel_mute_" .. channel.uniqueID) == false then
				ply:SetYRPBool("yrp_voice_channel_mutemic_" .. channel.uniqueID, false)
				ply:SetYRPBool("yrp_voice_channel_mute_" .. channel.uniqueID, true)
				break
			end
		end
	end
end

util.AddNetworkString("nws_yrp_next_voice_channel")
net.Receive(
	"nws_yrp_next_voice_channel",
	function(len, ply)
		if not IsValid(ply) then return end
		YRPMoveAllToNext(ply)
		YRPCountActiveChannels(ply)
		YRPCountPassiveChannels(ply)
	end
)

util.AddNetworkString("nws_yrp_ToggleVoiceMenu")
net.Receive(
	"nws_yrp_ToggleVoiceMenu",
	function(len, ply)
		ply:SetYRPBool("yrp_ToggleVoiceMenu", not ply:GetYRPBool("yrp_ToggleVoiceMenu", true))
	end
)

util.AddNetworkString("nws_yrp_voice_set_max_active")
net.Receive(
	"nws_yrp_voice_set_max_active",
	function(len, ply)
		local maxi = tonumber(net.ReadString())
		YRP_SQL_UPDATE(
			"yrp_general",
			{
				["int_max_channels_active"] = maxi
			}, "uniqueID = '1'"
		)

		SetGlobalYRPInt("int_max_channels_active", maxi)
	end
)

util.AddNetworkString("nws_yrp_voice_set_max_passive")
net.Receive(
	"nws_yrp_voice_set_max_passive",
	function(len, ply)
		local maxi = tonumber(net.ReadString())
		YRP_SQL_UPDATE(
			"yrp_general",
			{
				["int_max_channels_passive"] = maxi
			}, "uniqueID = '1'"
		)

		SetGlobalYRPInt("int_max_channels_passive", maxi)
	end
)

timer.Simple(
	0,
	function()
		if GetGlobalYRPBool("bool_voice", false) or GetGlobalYRPBool("bool_voice_3d", false) then
			hook.Add(
				"PlayerCanHearPlayersVoice",
				"YRP_voicesystem",
				function(listener, talker)
					if GetGlobalYRPBool("bool_voice", false) then
						if listener == talker then return false end
						local canhear = false
						for i, channel in SortedPairsByMemberValue(GetGlobalYRPTable("yrp_voice_channels", {}), "int_position", false) do
							-- If Talker allowed to talk and both are in that channel
							if IsActiveInChannel(talker, channel.uniqueID) and (IsInChannel(listener, channel.uniqueID) or IsActiveInChannel(listener, channel.uniqueID)) then
								canhear = true
								break
							end
						end

						if canhear and not talker:GetYRPBool("mute_voice", false) then
							return true
						else
							if YRPIsInMaxVoiceRange(listener, talker) and YRPIsInSpeakRange(listener, talker) then return true end
						end
						-- new

						return false
					elseif GetGlobalYRPBool("bool_voice_3d", false) then
						if YRPIsInMaxVoiceRange(listener, talker) and YRPIsInSpeakRange(listener, talker) then return true end

						return false
					end
				end
			)
		else
			YRP.msg("note", "YourRP Voicechat and Voicechat3D is disabled")
		end
	end
)

function YRPSetPlayerModel(ply)
	local tmpRolePlayermodel = ply:GetPlayerModel()
	if IsNotNilAndNotFalse(tmpRolePlayermodel) and not strEmpty(tmpRolePlayermodel) then
		ply:SetModel(tmpRolePlayermodel)
	else
		ply:SetModel("models/player/skeleton.mdl")
		YRP.msg("note", ply:YRPName() .. " HAS NO PLAYERMODEL")
	end

	YRPSetBodyGroups(ply)
end

function GM:PlayerSetModel(ply)
	YRPSetPlayerModel(ply)
end

function GM:PlayerSpray(ply)
	if GetGlobalYRPBool("bool_graffiti_disabled", false) then
		return true
	else
		return false
	end
end

function GM:PlayerSwitchFlashlight(pl, enabled)
	local _tmp = YRP_SQL_SELECT("yrp_usergroups", "*", "string_name = '" .. string.lower(pl:GetUserGroup()) .. "'")
	if IsNotNilAndNotFalse(_tmp) then
		_tmp = _tmp[1]
		if tobool(_tmp.bool_flashlight) then return true end
	end

	return false
end

function GM:ShowHelp(ply)
	return false
end

hook.Add(
	"PostCleanupMap",
	"yrp_PostCleanupMap_doors",
	function()
		YRP.msg("note", "RELOAD DOORS")
		YRPLoadDoors()
	end
)

function YRPWarning(text)
	MsgC(Color(0, 255, 0), "[WARNING] " .. text .. "\n")
end

function YRPInfo(text)
	MsgC(Color(255, 255, 0), "[INFO] " .. text .. "\n")
end

function YRPCheckAddons(force)
	local tabwar = {}
	local tabinf = {}
	local count = 0
	for i, v in pairs(engine.GetAddons()) do
		v.searchtitle = string.lower(v.title)
		-- 167545348 Manual Weapon Pickup, breaks GIVE function
		if v.wsid == "167545348" then
			table.insert(tabwar, "[" .. v.wsid .. "] [" .. v.title .. "] breaks Give Function of Weapons\n> For Example in Shops or other addons that want to give a weapon\n> F8 -> General -> Disable \"Auto pickup\" => for manual pickup of weapons")
			count = count + 1
		end

		-- "Workshop Downloader Addons"
		if (string.find(v.searchtitle, "workshop", 1, true) and string.find(v.searchtitle, "download", 1, true)) or string.find(v.searchtitle, "addon share", 1, true) or string.find(v.searchtitle, "fastdl", 1, true) then
			table.insert(tabwar, "[" .. v.wsid .. "] [" .. v.title .. "] already implemented in YourRP!")
			count = count + 1
		end

		-- "FPS Booster Addons"
		if not string.find(v.searchtitle, "afps", 1, true) and string.find(v.searchtitle, "fps", 1, true) and (string.find(v.searchtitle, "boost", 1, true) or string.find(v.searchtitle, "tweak", 1, true) or string.find(v.searchtitle, "fps+", 1, true)) then
			table.insert(tabwar, "[" .. v.wsid .. "] [" .. v.title .. "] already implemented in YourRP, if it is improving FPS!")
			count = count + 1
		end

		-- "Talk Icon Addons"
		if string.find(v.searchtitle, "talk icon", 1, true) then
			table.insert(tabinf, "[" .. v.wsid .. "] [" .. v.title .. "] YourRP also have an Talk Icon...")
			count = count + 1
		end
	end

	-- OUTPUT
	if force then
		YRPHR(Color(100, 100, 255))
		YRP.msg("note", "YRPCheckAddons() ...")
	end

	if count > 0 then
		for i, v in pairs(tabinf) do
			YRPInfo(v)
		end

		for i, v in pairs(tabwar) do
			YRPWarning(v)
		end
	end

	if force then
		YRPHR(Color(100, 100, 255))
	end
end

hook.Add(
	"PostGamemodeLoaded",
	"yrp_PostGamemodeLoaded_CheckAddons",
	function()
		timer.Simple(
			2.1,
			function()
				YRPCheckAddons(true)
			end
		)
	end
)

hook.Add("PlayerShouldTaunt", "yrp_allowtaunts", function(ply, act) return true end)
function YRPRemoveEmptyLines(str)
	local tab = string.Explode("\n", str, false)
	local newtab = {}
	for i, v in pairs(tab) do
		if not strEmpty(v) then
			table.insert(newtab, v)
		end
	end

	str = table.concat(newtab, "\n")

	return str
end

function YRPRemoveCommentsShort(str)
	local tab = string.Explode("\n", str, false)
	for i, v in pairs(tab) do
		if string.StartWith(v, "--") then
			tab[i] = ""
		end
	end

	str = table.concat(tab, "\n")

	return str
end

function YRPRemoveCommentsLong(str, c)
	local res = str
	c = c + 1
	if c > 9999 then return res end
	local s1, _ = string.find(res, "--[[", 1, true)
	if s1 then
		local _, e2 = string.find(res, "]]", s1, true)
		if e2 then
			local remstr = string.sub(res, s1, e2)
			if remstr and not strEmpty(remstr) then
				res = string.Replace(res, remstr, "")
				res = YRPRemoveCommentsLong(res, c)
			end
		end
	end

	return res
end

function YRPImportDarkrp(str, name)
	YRPIMPORTDARKRP = true
	if str and name then
		local err = RunString(str, "YRPIMPORTDARKRP_RS: " .. name, false)
		if err and string.find(err, "table index is nil", 1, true) == nil then
			MsgC(Color(0, 255, 0), "ERROR: ", err, "\n")
		end
	else
		MsgC(Color(255, 0, 0, 255), "ERROR: ", "str or name is nil", str, name, "\n")
	end

	YRPIMPORTDARKRP = false
end

function YRPImportFileToTable(filename, name)
	if filename == nil then return end
	local str = file.Read(filename, "GAME")
	if str and name then
		str = YRPRemoveCommentsLong(str, 0)
		str = YRPRemoveCommentsShort(str)
		str = YRPRemoveEmptyLines(str)
		YRPImportDarkrp(str, name)
	end
end

util.AddNetworkString("nws_yrp_import_darkrp")
net.Receive(
	"nws_yrp_import_darkrp",
	function(len, ply)
		if not ply:HasAccess("nws_yrp_import_darkrp") then return end
		YRPHR()
		YRPMsg("[START IMPORT DARKRP]", Color(0, 255, 0))
		YRPImportFileToTable("lua/darkrp_customthings/categories.lua", "categories")
		YRPImportFileToTable("lua/darkrp_customthings/jobs.lua", "jobs")
		YRPMsg("[DONE IMPORT DARKRP]", Color(0, 255, 0))
		YRPHR()
	end
)
