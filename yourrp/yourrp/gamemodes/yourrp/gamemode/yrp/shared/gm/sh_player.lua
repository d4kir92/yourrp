--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
function YRPIsChatEnabled(from)
	return GetGlobalYRPBool("bool_yrp_chat", false)
end

function YRPIsChatCommandsEnabled()
	return GetGlobalYRPBool("bool_yrp_chat_commands", false)
end

function YRPGetPlayerByName(name)
	if name == nil then return NULL end
	name = string.lower(name)
	for i, ply in pairs(player.GetAll()) do
		if ply:IsPlayer() and string.find(string.lower(ply:RPName()), name, 1, true) or string.find(string.lower(ply:SteamName()), name, 1, true) or string.find(string.lower(ply:Nick()), name, 1, true) or string.find(string.lower(ply:GetName()), name, 1, true) then return ply end
	end

	return NULL
end

function YRPGetPlayerByRPName(name)
	if name == nil then return NULL end
	name = string.lower(name)
	for i, ply in pairs(player.GetAll()) do
		if string.find(string.lower(ply:RPName()), name, 1, true) then return ply end
	end

	return NULL
end

function YRPGetPlayerBySteamName(name)
	if name == nil then return NULL end
	name = string.lower(name)
	for i, ply in pairs(player.GetAll()) do
		if string.find(string.lower(ply:SteamName()), name, 1, true) then return ply end
	end

	return NULL
end

local Player = FindMetaTable("Player")
function Player:YRPSteamID()
	return self:SteamID() or self:UniqueID()
end

function Player:YRPCharPlayTime()
	return os.time() - self:GetYRPInt("ts_spawned") + tonumber(self:GetYRPString("text_playtime", "0"))
end

function Player:YRPFormattedCharPlayTime()
	local time = self:YRPCharPlayTime()
	--local seco = time % 60
	local minu = math.floor(time / 60 % 60, 0)
	if minu < 10 then
		minu = "0" .. minu
	end

	local hour = math.floor(time / 3600, 0)

	return hour .. ":" .. minu
end

Player.oldIsTyping = Player.oldIsTyping or Player.IsTyping
function Player:IsTyping()
	if YRPIsChatEnabled("IsTyping") then
		return self:GetYRPBool("istyping", false)
	else
		return self:oldIsTyping()
	end
end

if CLIENT then
	hook.Add(
		"Think",
		"YRPSyncDarkRPVars",
		function()
			local ply = LocalPlayer()
			if ply and ply.DarkRPVars then
				ply.DarkRPVars.Energy = ply:GetYRPFloat("hunger", 0)
				ply.DarkRPVars.salary = ply:Salary()
				ply.DarkRPVars.money = ply:Money()
			end
		end
	)
end

if SERVER then
	function Player:YRPSetHunger(num)
		self:SetYRPFloat("hunger", num)
	end

	function Player:YRPEat(num)
		num = tonumber(num)
		if isnumber(num) then
			local eatsounds = {"npc/barnacle/barnacle_crunch2.wav", "npc/barnacle/barnacle_crunch3.wav", "physics/body/body_medium_break4.wav"}
			local name, _ = table.Random(eatsounds)
			util.PrecacheSound(name)
			self:EmitSound(name)
			local newhunger = math.Clamp(self:GetYRPFloat("hunger", 0.0) + num, 0, 100.0)
			self:YRPSetHunger(newhunger)
			self.DarkRPVars = self.DarkRPVars or {}
			self.DarkRPVars.Energy = newhunger
		end
	end

	function Player:YRPDrink(num, permille)
		num = tonumber(num)
		if isnumber(num) then
			local drinksounds = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav", "drink1.wav"}
			local name, _ = table.Random(drinksounds)
			util.PrecacheSound(name)
			self:EmitSound(name)
			local newthirst = math.Clamp(self:GetYRPFloat("thirst", 0.0) + num, 0, self:GetMaxThirst())
			self:SetYRPFloat("thirst", newthirst)
		end

		if GetGlobalYRPBool("bool_permille", false) and permille ~= nil then
			permille = tonumber(permille)
			if isnumber(permille) and permille > 0 then
				local newpermille = math.Clamp(self:GetYRPFloat("permille", 0.0) + permille, 0, self:GetMaxPermille())
				self:SetYRPFloat("permille", newpermille)
			end
		end
	end
end

function Player:YRPGetLanguage()
	return YRP.get_language_name(self:GetYRPString("client_lang", YRP.trans("LID_none")))
end

function Player:YRPGetLanguageShort()
	return self:GetYRPString("client_lang", YRP.trans("LID_none"))
end

local accessTab = {}
function Player:HasAccess(from, skip)
	local hasAccess = self:GetYRPBool("bool_adminaccess", false) or self:IsSuperAdmin()
	if not hasAccess and SERVER and skip == nil then
		if from == nil then
			local trace = tostring(debug.traceback())
			trace = string.Replace(trace, "\t", "")
			trace = string.Replace(trace, "\n", "-> ")
			YRP.msg("access", "[HasAccess] Missing \"from\": " .. trace)
		elseif not table.HasValue(accessTab, from) then
			table.insert(accessTab, from)
			YRP.msg("access", "[HasAccess] Tried to Access: " .. tostring(from))
		end
	end

	return hasAccess
end

function Player:YRPHasStorageItem(uid)
	if not IsNotNilAndNotFalse(uid) then return false end
	if self.yrpstorage == nil or self:GetYRPString("storage", "") ~= self.yrpstoragestr then
		self.yrpstoragestr = self:GetYRPString("storage", "")
		self.yrpstorage = string.Explode(",", self.yrpstoragestr)
	end

	if self.yrpstorage then return table.HasValue(self.yrpstorage, string.format("%d", uid)) end

	return false
end

function Player:LoadedGamemode()
	if self:IsBot() then return true end

	return self:GetYRPBool("finishedloading", false)
end

function Player:IsInCharacterSelection()
	if self:IsBot() then return false end
	if GetGlobalYRPBool("bool_character_system") and not IsVoidCharEnabled() then
		return self:GetYRPBool("yrp_characterselection", false)
	else
		return false
	end
end

function Player:GetPlyTab()
	if SERVER then
		if self:IsValid() then
			if self:GetYRPBool("finishedloadingcharacter", false) then
				local steamid = self:YRPSteamID()
				if steamid ~= nil and steamid ~= false and steamid ~= "" then
					local yrp_players = YRP_SQL_SELECT("yrp_players", "*", "SteamID = '" .. steamid .. "'")
					if IsNotNilAndNotFalse(yrp_players) then
						self.plytab = yrp_players[1]

						return self.plytab
					else
						YRP.msg("note", "[GetPlyTab] table: " .. tostring(yrp_players) .. " SteamID [" .. tostring(steamid) .. "]")
					end
				else
					YRP.msg("note", "[GetPlyTab] SteamID failed [" .. tostring(steamid) .. "]")
				end
			end
		else
			YRP.msg("error", "[GetPlyTab] player is invalid. ( " .. tostring(self:YRPSteamID()) .. " ) IsPlayer()?: " .. tostring(self:IsPlayer()))
		end
	end

	return false
end

function Player:IsCharacterValid()
	if SERVER then
		if self:IsValid() then
			if not GetGlobalYRPBool("bool_character_system") then
				return true
			else
				if self:GetYRPBool("finishedloadingcharacter", false) then
					local _cha_tab = self:YRPGetCharacterTable()
					if _cha_tab == false then
						return false
					else
						return true
					end
				end
			end
		else
			YRP.msg("note", "[IsCharacterValid] not valid or not a player " .. self:YRPName())
		end
	end
end

function Player:HasCharacterSelected()
	if SERVER then
		if self:IsValid() then
			if not GetGlobalYRPBool("bool_character_system") then
				return true
			else
				if self:GetYRPBool("finishedloadingcharacter", false) then
					local _ply_tab = self:GetPlyTab()
					if IsNotNilAndNotFalse(_ply_tab) and tostring(_ply_tab.CurrentCharacter) ~= "NULL" and _ply_tab.CurrentCharacter ~= NULL then
						local chatab = YRP_SQL_SELECT("yrp_characters", "*", "uniqueID = '" .. _ply_tab.CurrentCharacter .. "'")
						if IsNotNilAndNotFalse(chatab) then return true end
					end
				end
			end
		else
			YRP.msg("note", "[HasCharacterSelected] not valid or not a player " .. self:YRPName())
		end
	end

	return false
end

function Player:YRPGetCharacterTable()
	if SERVER then
		if self:IsValid() then
			if self:GetYRPBool("finishedloadingcharacter", false) then
				local _tmp = self:GetPlyTab()
				if IsNotNilAndNotFalse(_tmp) then
					local yrp_characters = YRP_SQL_SELECT("yrp_characters", "*", "uniqueID = '" .. _tmp.CurrentCharacter .. "'")
					if IsNotNilAndNotFalse(yrp_characters) then
						self.chatab = yrp_characters[1]

						return self.chatab
					elseif yrp_characters == nil then
						YRP.msg("note", "[GetChaTab] Character not exists.")
					else
						YRP.msg("error", "[GetChaTab] yrp_characters failed [" .. tostring(yrp_characters) .. "]")
					end
				else
					YRP.msg("note", "[GetChaTab] failed: " .. "PlyTab: " .. tostring(_tmp))
				end
			end
		else
			YRP.msg("note", "[GetChaTab] not valid or not a player " .. self:YRPName())
		end
	end

	return false
end

function Player:YRPGetRoleTable()
	if SERVER then
		if self:IsValid() then
			if self:GetYRPBool("finishedloadingcharacter", false) then
				local yrp_characters = self:YRPGetCharacterTable()
				if IsNotNilAndNotFalse(yrp_characters) and IsNotNilAndNotFalse(yrp_characters.roleID) then
					local yrp_roles = YRP_SQL_SELECT("yrp_ply_roles", "*", "uniqueID = " .. yrp_characters.roleID)
					if IsNotNilAndNotFalse(yrp_roles) then
						self.roltab = yrp_roles[1]

						return self.roltab
					elseif yrp_roles == nil then
						YRP.msg("note", "[GetRolTab] Role not exists.")
					else
						YRP.msg("error", "[GetRolTab] yrp_roles failed [" .. tostring(yrp_roles) .. "]")
					end
				end
			end
		else
			YRP.msg("note", "[GetRolTab] not valid or not a player " .. self:YRPName())
		end
	end

	return false
end

function Player:YRPGetGroupTable()
	if SERVER then
		if self:IsValid() then
			if self:GetYRPBool("finishedloadingcharacter", false) then
				local yrp_characters = self:YRPGetCharacterTable()
				if IsNotNilAndNotFalse(yrp_characters) and IsNotNilAndNotFalse(yrp_characters.groupID) then
					local yrp_groups = YRP_SQL_SELECT("yrp_ply_groups", "*", "uniqueID = " .. yrp_characters.groupID)
					if IsNotNilAndNotFalse(yrp_groups) then
						self.grotab = yrp_groups[1]

						return self.grotab
					end
				end
			end
		else
			YRP.msg("note", "[GetGroTab] not valid or not a player " .. self:YRPName())
		end
	end

	return false
end

function Player:CharID()
	return self:GetYRPInt("yrp_charid", -1)
end

function Player:UpdateMoney()
	if SERVER and self:HasCharacterSelected() then
		local _char_id = self:CharID()
		if _char_id ~= false then
			local money = self:GetYRPString("money", "FAILED")
			if money == "FAILED" then return false end
			if YRPWORKED(money, "ply:money UpdateMoney", true) then
				YRP_SQL_UPDATE(
					"yrp_characters",
					{
						["money"] = money
					}, "uniqueID = " .. _char_id
				)
			end

			local moneybank = tonumber(self:GetYRPString("moneybank", "FAILED"))
			if moneybank == "FAILED" then return false end
			if YRPWORKED(moneybank, "ply:moneybank UpdateMoney", true) then
				YRP_SQL_UPDATE(
					"yrp_characters",
					{
						["moneybank"] = moneybank
					}, "uniqueID = " .. _char_id
				)
			end
		end
	end
end

function Player:GetPlayerModel()
	if self:GetYRPString("string_playermodel", "models/player/skeleton.mdl") ~= "models/player/skeleton.mdl" then
		return self:GetYRPString("string_playermodel", "models/player/skeleton.mdl")
	else
		return "models/player/skeleton.mdl"
	end
end

function Player:IsAgent()
	return self:GetYRPBool("bool_canbeagent")
end

if SERVER then
	function Player:Unbroke()
		self:SetYRPBool("broken_leg_right", false)
		self:SetYRPBool("broken_leg_left", false)
		self:SetYRPBool("broken_arm_right", false)
		self:SetYRPBool("broken_arm_left", false)
	end

	function Player:StopCasting(cost)
		cost = cost or 0
		if self:GetYRPString("GetAbilityType", "none") ~= "none" and self:GetYRPInt("GetCurAbility", 0) >= cost then
			self:SetYRPInt("GetCurAbility", self:GetYRPInt("GetCurAbility", 0) - cost)
		elseif self:GetYRPString("GetAbilityType", "none") ~= "none" then
			return
		end

		--[[ successfull casting ]]
		--
		self:SetYRPBool("iscasting", false)
		self:SetYRPString("castname", "")
		self:SetYRPFloat("castcur", 0.0)
		local _args = {}
		_args.attacker = self
		_args.target = self:GetYRPEntity("casttarget")
		hook.Run("yrp_castdone_" .. self:GetYRPString("castnet"), _args)
	end

	function Player:InteruptCasting()
		self:SetYRPString("castname", "")
		self:SetYRPFloat("castcur", 0.0)
		--[[ failed casting ]]
		--
		self:SetYRPBool("iscasting", false)
		if timer.Exists(self:YRPSteamID() .. "castduration") then
			timer.Remove(self:YRPSteamID() .. "castduration")
		end

		hook.Run("yrp_interupt_" .. self:GetYRPString("castnet", ""))
	end

	function Player:ShowStatus(lang_str, min, max)
		--[[ Setup ]]
		--
		self:SetYRPString("castname", lang_str)
		self:SetYRPFloat("castmax", max)
		self:SetYRPFloat("castcur", min)
		--[[ Start casting ]]
		--
		self:SetYRPBool("iscasting", true)
	end

	function Player:StartCasting(net_str, lang_str, mode, target, duration, range, cost, canmove)
		--[[ cancel other spells ]]
		--
		self:InteruptCasting()
		target = target or self
		if self:GetYRPString("GetAbilityType", "none") ~= "none" and self:GetYRPInt("GetCurAbility", 0) < cost then return end
		--[[ Setup ]]
		--
		self:SetYRPString("castnet", net_str)
		self:SetYRPInt("castmode", mode or 0)
		self:SetYRPBool("castcanmove", canmove or false)
		if not self:GetYRPBool("castcanmove") then
			self:SetYRPVector("castposition", self:GetPos())
		end

		self:SetYRPString("castname", lang_str)
		self:SetYRPFloat("castmax", duration or 1.0)
		if self:GetYRPInt("castmode") == 0 then
			self:SetYRPFloat("castcur", 0.0)
		elseif self:GetYRPInt("castmode") == 1 then
			self:SetYRPFloat("castcur", self:GetYRPFloat("castmax"))
		end

		self:SetYRPEntity("casttarget", target)
		self:SetYRPFloat("castrange", range or 0.0)
		local tick = 0.1
		--[[ Start casting ]]
		--
		self:SetYRPBool("iscasting", true)
		timer.Create(
			self:YRPSteamID() .. "castduration",
			tick,
			0,
			function()
				--YRP.msg( "note", self:GetYRPString( "castname" ) .. " " .. tostring(self:GetYRPFloat( "castcur" ) ))
				--[[ Casting ]]
				--
				if self:GetYRPInt("castmode") == 0 then
					self:SetYRPFloat("castcur", self:GetYRPFloat("castcur") + tick)
					if not self:GetYRPBool("castcanmove") then
						local _o_pos = self:GetYRPVector("castposition")
						local _c_pos = self:GetPos()
						local _space = 3
						--[[ x, y moved ]]
						--
						if _c_pos.x + _space < _o_pos.x or _c_pos.x - _space > _o_pos.x or _c_pos.y + _space < _o_pos.y or _c_pos.y - _space > _o_pos.y then
							self:InteruptCasting()
						end

						if not IsValid(target) then return end
						if self:OBBCenter():Distance(target:OBBCenter()) > self:GetYRPFloat("castrange") then
							self:InteruptCasting()
						end
					end

					if self:GetYRPFloat("castcur") >= self:GetYRPFloat("castmax") then
						self:StopCasting(cost)
						timer.Remove(self:YRPSteamID() .. "castduration")
					end
				elseif self:GetYRPInt("castmode") == 1 then
					self:SetYRPFloat("castcur", self:GetYRPFloat("castcur") - tick)
					if self:GetYRPFloat("castcur") <= 0.0 then
						self:StopCasting(cost)
						timer.Remove(self:YRPSteamID() .. "castduration")
					end
				end
			end
		)
	end

	function Player:updateMoney(money)
		self:UpdateMoney()
	end

	function Player:updateMoneyBank(money)
		self:UpdateMoney()
	end

	function Player:addMoney(money)
		if IsNotNilAndNotFalse(money) and isnumber(money) and isnumber(tonumber(self:GetYRPString("money"))) then
			local newmoney = math.Round(tonumber(self:GetYRPString("money")), 2) + math.Round(money, 2)
			if self:GetYRPBool("moneyready", false) then
				self:SetYRPString("money", math.Round(newmoney, 2))
				self:UpdateMoney()
			else
				YRP.msg("note", "[addMoney] player not ready for getting money: " .. self:YRPName())
			end
		end
	end

	function Player:YRPGetMoney()
		return math.Round(tonumber(self:GetYRPString("money", "0")), 2)
	end

	function Player:YRPGetMoneyBank()
		return math.Round(tonumber(self:GetYRPString("moneybank", "0")), 2)
	end

	function Player:SetMoney(money)
		if isnumber(money) then
			if self:GetYRPBool("moneyready", false) then
				self:SetYRPString("money", math.Round(money, 2))
				self:UpdateMoney()
			else
				YRP.msg("note", "[SetMoney] player not ready for getting money: " .. self:YRPName())
			end
		end
	end

	function Player:SetMoneyBank(money)
		if isnumber(money) then
			if self:GetYRPBool("moneyready", false) then
				self:SetYRPString("moneybank", math.Round(money, 2))
				self:UpdateMoney()
			else
				YRP.msg("note", "[SetMoneyBank] player not ready for getting money: " .. self:YRPName())
			end
		end
	end

	function Player:addMoneyBank(money)
		if money ~= nil and isnumber(money) and self:GetYRPString("moneybank") ~= nil then
			local newmoney = math.Round(tonumber(self:GetYRPString("moneybank")), 2) + math.Round(money, 2)
			self:SetYRPString("moneybank", math.Round(newmoney, 2))
			self:UpdateMoney()
		end
	end

	function Player:resetUptimeCurrent()
		local _res = YRP_SQL_UPDATE(
			"yrp_players",
			{
				["uptime_current"] = 0
			}, "SteamID = '" .. self:YRPSteamID() .. "'"
		)
	end

	function Player:SaveUptimeTotal()
		local uptime_total = self:UptimeTotal()
		local _res = YRP_SQL_UPDATE(
			"yrp_players",
			{
				["uptime_total"] = uptime_total
			}, "SteamID = '" .. self:YRPSteamID() .. "'"
		)
	end

	function Player:Heal(amount)
		local newhp = math.Clamp(self:Health() + amount, 0, self:GetMaxHealth())
		self:SetHealth(newhp)
	end

	function Player:StartBleeding()
		self:SetYRPBool("isbleeding", true)
	end

	function Player:StopBleeding()
		self:SetYRPBool("isbleeding", false)
	end

	function Player:SetBleedingPosition(pos)
		self:SetYRPVector("bleedingpos", pos)
	end
end

function Player:UptimeCurrent()
	return os.time() - self:GetYRPFloat("uptime_current", 0)
end

function Player:UptimeTotal()
	return self:UptimeCurrent() + self:GetYRPFloat("uptime_total", 0)
end

function Player:FormattedUptimeCurrent()
	if self:UptimeCurrent() == os.time() then return "BOT" end
	local hms = os.date("!%H:%M", self:UptimeCurrent())
	local days = math.floor(self:UptimeCurrent() / (24 * 3600))
	-- years + months + days
	if days >= 365 then
		local years = math.floor(days / 365)
		local months = math.floor(days / 365 / 12)
		days = days % 30

		return string.format("%1d:%02d:%02d:%s", years, months, days, hms)
	elseif days >= 30 then
		-- months + days + hours
		local months = math.floor(days / 365 / 12)
		days = days % 30

		return string.format("%02d:%02d:%s", months, days, hms)
	elseif days > 0 then
		return string.format("%02d:%s", days, hms)
	end
	-- hours + minutes

	return hms
end

function Player:FormattedUptimeTotal()
	if self:UptimeTotal() == os.time() then return "BOT" end
	local hms = os.date("!%H:%M:%S", self:UptimeTotal())
	local days = math.floor(self:UptimeTotal() / (24 * 3600))
	-- years + months + days
	if days >= 365 then
		local years = math.floor(days / 365)
		local months = math.floor(days / 365 / 12)
		days = days % 30

		return string.format("%1d:%02d:%02d:%s", years, months, days, hms)
	elseif days >= 30 then
		-- months + days + hours
		local months = math.floor(days / 365 / 12)
		days = days % 30

		return string.format("%02d:%02d:%s", months, days, hms)
	elseif days > 0 then
		return string.format("%02d:%s", days, hms)
	end
	-- hours + minutes

	return hms
end

function Player:GetBleedingPosition()
	return self:GetYRPVector("bleedingpos", Vector(0, 0, 0))
end

function Player:canAfford(money)
	if self:GetYRPBool("moneyready", false) then
		if money == nil then return false end
		if self:GetYRPString("money", 0) == nil then return false end
		if isnumber(tonumber(money)) then
			money = math.abs(tonumber(money))
			local curmoney = tonumber(self:GetYRPString("money", 0))
			if curmoney >= money then
				return true
			else
				return false
			end

			return false
		else
			YRP.msg("note", "canAfford needs a number as input!")

			return false
		end
	else
		YRP.msg("note", "[canAfford] player not ready for getting money: " .. self:YRPName())
	end
end

function Player:canAffordBank(money)
	if self:GetYRPBool("moneyready", false) then
		if money == nil then return false end
		if self:GetYRPString("moneybank") == nil then return false end
		local _tmpMoney = math.abs(tonumber(money))
		if isnumber(_tmpMoney) and tonumber(self:GetYRPString("moneybank")) then
			if tonumber(self:GetYRPString("moneybank")) >= _tmpMoney then
				return true
			else
				return false
			end
		end
	else
		YRP.msg("note", "[canAffordBank] player not ready for getting money: " .. self:YRPName())
	end
end

function Player:YRPRPName()
	if IsValid(self) then
		return string.Replace(self:GetYRPString("rpname", self:SteamName()), "'", "")
	else
		return "INVALID PLAYER"
	end
end

Player.SteamName = Player.SteamName or Player.Name
function Player:Name()
	if self.YRPRPName then
		return self:YRPRPName()
	elseif self.SteamName then
		return self:SteamName()
	end

	return self:Name()
end

Player.GetName = Player.Name
Player.Nick = Player.Name
function Player:YRPName()
	if not IsValid(self) then return "FAIL" end

	return "[" .. self:SteamName() .. " ( " .. self:RPName() .. " )]"
end

function Player:Team()
	return tonumber(self:GetYRPString("roleUniqueID", "0"))
end

timer.Simple(
	2,
	function()
		function team.GetName(index)
			if RPExtraTeams[index] then
				return RPExtraTeams[index].name
			else
				return "FAILED TO FIND TEAMNAME"
			end
		end
	end
)

function Player:YRPGetRoleColor()
	local _rc = self:GetYRPString("roleColor", "255,0,0")
	_rc = string.Explode(",", _rc)
	_rc = Color(_rc[1], _rc[2], _rc[3], _rc[4] or 255)

	return _rc
end

function Player:YRPGetRoleName()
	if IsValid(self) then
		local _rn = self:GetYRPString("roleName", "")

		return _rn
	else
		return "PLAYER INVALID"
	end
end

function Player:YRPGetFactionUID()
	local _uid = tonumber(self:GetYRPString("factionUniqueID", "0"))

	return _uid
end

function Player:YRPGetFactionName()
	local _gn = self:GetYRPString("factionName", "")

	return _gn
end

function Player:YRPGetFactionColor()
	local _gc = self:GetYRPString("factionColor", "255,0,0")
	_gc = string.Explode(",", _gc)
	_gc = Color(_gc[1], _gc[2], _gc[3], _gc[4] or 255)

	return _gc
end

function Player:YRPGetGroupUID()
	local _gn = self:GetYRPString("groupUniqueID", "0")

	return tonumber(_gn)
end

function Player:YRPGetGroupName()
	local _gn = self:GetYRPString("groupName", "")

	return _gn
end

function Player:YRPGetGroupColor()
	local _gc = self:GetYRPString("groupColor", "255,0,0")
	_gc = string.Explode(",", _gc)
	_gc = Color(_gc[1], _gc[2], _gc[3], _gc[4] or 255)

	return _gc
end

function Player:YRPGetUserGroupColor()
	local _gc = self:GetYRPString("usergroupColor", "255,0,0")
	_gc = string.Explode(",", _gc)
	_gc = Color(_gc[1], _gc[2], _gc[3], _gc[4] or 255)

	return _gc
end

function Player:HasLicense(license)
	local tab = self:GetLicenseIDs()
	if license and tab[tonumber(license)] then
		return true
	elseif tonumber(license) == -1 then
		return true
	end

	return false
end

function Player:GetAllLicenses()
	local lids = self:GetLicenseIDs()
	local tab = GetGlobalYRPTable("yrp_licenses")
	local res = {}
	for i, v in pairs(tab) do
		if lids[tonumber(i)] then
			table.insert(res, v)
		end
	end

	return table.concat(res, ", ")
end

-- DOORS
function IsOwnedBy(ply, door)
	if door:YRPIsDoor() then
		return ply:CharID() == door:GetYRPInt("ownerCharID", 0)
	elseif door:IsVehicle() then
		return ply:CharID() == door:GetYRPInt("ownerCharID", 0)
	end

	return false
end

function YRPCanLock(ply, door, open)
	if door:YRPIsDoor() then
		if ply:GetSecurityLevel() >= door:SecurityLevel() then
			if door:GetYRPInt("ownerCharID", 0) > 0 then
				if ply:CharID() == door:GetYRPInt("ownerCharID", 0) then return true end --YRP.msg( "note", "[canLock] " .. "IsOwner" )
				if door:IsCoOwner(ply) then return true end
				YRP.msg("note", "[canLock] " .. "Building has owner, but not this one! (from Player: " .. ply:RPName() .. " )")

				return false
			elseif door:GetYRPString("ownerGroup", "") ~= "" then
				if tonumber(ply:GetYRPString("groupUniqueID", "-98")) == tonumber(door:GetYRPInt("ownerGroupUID", -99)) then
					return true
				elseif YRPIsUnderGroupOf(ply, tonumber(door:GetYRPInt("ownerGroupUID", -99))) then
					return true
				elseif open and door:GetYRPString("ownerGroup", "") == "PUBLIC" then
					return true
				end

				if open == nil then
					YRP.msg("note", "[canLock] " .. "Building has group owner, but not this group! (from Player: " .. ply:RPName() .. " )")
				end

				return false
			elseif door:GetYRPInt("ownerCharID", 0) == 0 and door:GetYRPString("ownerGroup", "") == "" then
				if open then
					return true
				else
					YRP.msg("note", "[canLock] " .. "Building has no owner! (from Player: " .. ply:RPName() .. " )")

					return false
				end
			else
				YRP.msg("error", "[canLock] " .. "Unknown Error")

				return false
			end

			return true
		else
			YRP.msg("note", "[canLock] " .. "Building has higher securitylevel! (from Player: " .. ply:RPName() .. " )")

			return false
		end
	else
		return canVehicleLock(ply, door)
	end

	return false
end

function canVehicleLock(ply, veh)
	if veh:GetYRPInt("ownerCharID", 0) ~= 0 then
		if ply:CharID() == veh:GetYRPInt("ownerCharID", 0) then return true end

		return false
	elseif veh:GetYRPInt("ownerCharID", 0) == 0 then
		if veh:GetRPOwner() == ply then return true end

		return false
	else
		YRP.msg("error", "canVehicleLock ELSE")

		return false
	end
end

hook.Add(
	"StartCommand",
	"YRP_StartCommand",
	function(ply, cmd)
		if ply and ply:GetYRPBool("ragdolled", false) and cmd:KeyDown(IN_ATTACK) then
			cmd:RemoveKey(IN_ATTACK)
		end
	end
)
