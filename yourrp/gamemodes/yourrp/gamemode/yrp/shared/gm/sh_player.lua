--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

function GetPlayerByName(name)
	for i, ply in pairs(player.GetAll()) do
		if ply:IsPlayer() and string.find(string.lower(ply:RPName()), string.lower(name)) or string.find(string.lower(ply:SteamName()), string.lower(name)) then
			return ply
		end
	end

	return NULL
end

function GetPlayerByRPName(name)
	for i, ply in pairs(player.GetAll()) do
		if string.find(ply:RPName(), name) then
			return ply
		end
	end

	return NULL
end

function GetPlayerBySteamName(name)
	for i, ply in pairs(player.GetAll()) do
		if string.find(ply:SteamName(), name) then
			return ply
		end
	end

	return NULL
end

local Player = FindMetaTable("Player")

Player.oldIsTyping = Player.IsTyping
function Player:IsTyping()
	if GetGlobalBool("bool_yrp_chat", false) then
		return self:GetNW2Bool("istyping", false)
	else
		return self:oldIsTyping()
	end
end

function Player:YRPEat(num)
	num = tonumber(num)
	if isnumber(num) then
		local eatsounds = {
			"npc/barnacle/barnacle_crunch2.wav",
			"npc/barnacle/barnacle_crunch3.wav",
			"physics/body/body_medium_break4.wav"
		}
		local name, nr = table.Random(eatsounds)
		util.PrecacheSound(name)
		self:EmitSound(name)

		local newhunger = math.Clamp(self:GetNW2Float("hunger", 0.0) + num, 0, 100.0)
		self:SetNW2Float("hunger", newhunger)
	end
end

function Player:YRPDrink(num, permille)
	num = tonumber(num)
	if isnumber(num) then
		local drinksounds = {
			"npc/barnacle/barnacle_gulp1.wav",
			"npc/barnacle/barnacle_gulp2.wav",
			"drink1.wav"
		}
		local name, nr = table.Random(drinksounds)
		util.PrecacheSound(name)
		self:EmitSound(name)

		local newthirst = math.Clamp(self:GetNW2Float("thirst", 0.0) + num, 0, self:GetMaxThirst())
		self:SetNW2Float("thirst", newthirst)
	end

	if permille != nil then
		permille = tonumber(permille)
		if isnumber(permille) and permille > 0 then
			local newpermille = math.Clamp(self:GetNW2Float("permille", 0.0) + permille, 0, self:GetMaxPermille())
			self:SetNW2Float("permille", newpermille)
		end
	end
end

function Player:YRPGetLanguage()
	return YRP.get_language_name(self:GetNW2String("client_lang", YRP.lang_string("LID_none")))
end

function Player:YRPGetLanguageShort()
	return self:GetNW2String("client_lang", YRP.lang_string("LID_none"))
end

function Player:HasAccess()
	return self:GetNW2Bool("bool_adminaccess", false) or self:IsSuperAdmin()
end

function Player:LoadedGamemode()
	return self:GetNW2Bool("finishedloading", false)
end

function Player:GetPlyTab()
	if SERVER then
		if self:IsValid() then
			if self:GetNW2Bool("finishedloadingcharacter", false) then
				local steamid = self:SteamID() or self:UniqueID()
				if steamid != nil and steamid != false and steamid != "" then
					local yrp_players = SQL_SELECT("yrp_players", "*", "SteamID = '" .. steamid .. "'")
					if wk(yrp_players) then
						self.plytab = yrp_players[1]
						return self.plytab
					else
						YRP.msg("note", "[GetPlyTab] table: " .. tostring(yrp_players) .. " SteamID [" .. tostring(steamid) .. "]")
					end
				else
					YRP.msg("error", "[GetPlyTab] SteamID failed [" .. tostring(steamid) .. "]" )
				end
			end
		else
			YRP.msg("error", "[GetPlyTab] player is invalid. (" .. tostring(self:SteamID()) .. ") IsPlayer()?: " .. tostring(self:IsPlayer()))
		end
	end
	return false
end

function Player:IsCharacterValid()
	if SERVER then
		if self:IsValid() then
			if self:GetNW2Bool("finishedloadingcharacter", false) then
				local _cha_tab = self:GetChaTab()
				if _cha_tab == false then
					return false
				else
					return true
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
			if self:GetNW2Bool("finishedloadingcharacter", false) then
				--YRP.msg("note", self:YRPName() .. " HasCharacterSelected?")
				local _ply_tab = self:GetPlyTab()
				if wk(_ply_tab) and tostring(_ply_tab.CurrentCharacter) != "NULL" and _ply_tab.CurrentCharacter != NULL then
					return true
				end
			end
		else
			YRP.msg("note", "[HasCharacterSelected] not valid or not a player " .. self:YRPName())
		end
	end
	return false
end

function Player:GetChaTab()
	if SERVER then
		if self:IsValid() then
			if self:GetNW2Bool("finishedloadingcharacter", false) then
				local _tmp = self:GetPlyTab()
				if wk(_tmp) then
					local yrp_characters = SQL_SELECT("yrp_characters", "*", "uniqueID = '" .. _tmp.CurrentCharacter .. "'")
					if wk(yrp_characters) then
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

function Player:GetRolTab()
	if SERVER then
		if self:IsValid() then
			if self:GetNW2Bool("finishedloadingcharacter", false) then
				local yrp_characters = self:GetChaTab()
				if wk(yrp_characters) and wk(yrp_characters.roleID) then
					local yrp_roles = SQL_SELECT("yrp_ply_roles", "*", "uniqueID = " .. yrp_characters.roleID)
					if wk(yrp_roles) then
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

function Player:GetGroTab()
	if SERVER then
		if self:IsValid() then
			if self:GetNW2Bool("finishedloadingcharacter", false) then
				local yrp_characters = self:GetChaTab()
				if wk(yrp_characters) and wk(yrp_characters.groupID) then
					local yrp_groups = SQL_SELECT("yrp_ply_groups", "*", "uniqueID = " .. yrp_characters.groupID)
					if wk(yrp_groups) then
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
	if self:IsBot() then
		return 0
	else
		return self:GetNW2Int("yrp_charid", -1)
	end
end

function Player:CheckMoney()
	if SERVER then
		timer.Simple(4, function()
			local _m = self:GetNW2String("money", "FAILED")
			if _m == "FAILED" then
				YRP.msg("error", "CheckMoney failed")
				return false
			end
			local _money = tonumber(_m)
			if wk(_money) and self:CharID() != false then
				SQL_UPDATE("yrp_characters", "money = '" .. _money .. "'", "uniqueID = " .. self:CharID()) --attempt to nil value
			end
			_mb = self:GetNW2String("moneybank", "FAILED")
			if _mb == "FAILED" then
				YRP.msg("error", "CheckMoney failed")
				return false
			end
			local _moneybank = tonumber(_mb)
			if wk(_moneybank) and self:CharID() != false then
				SQL_UPDATE("yrp_characters", "moneybank = '" .. _moneybank .. "'", "uniqueID = " .. self:CharID())
			end
		end)
	end
end

function Player:UpdateMoney()
	if SERVER then
		if self:HasCharacterSelected() then
			local _char_id = self:CharID()
			if _char_id != false then
				local money = self:GetNW2String("money", "FAILED")
				if money == "FAILED" then
					return false
				end
				if worked(money, "ply:money UpdateMoney", true) then
					SQL_UPDATE("yrp_characters", "money = '" .. money .. "'", "uniqueID = " .. _char_id)
				end
				local moneybank = tonumber(self:GetNW2String("moneybank", "FAILED"))
				if moneybank == "FAILED" then
					return false
				end
				if worked(moneybank, "ply:moneybank UpdateMoney", true) then
					SQL_UPDATE("yrp_characters", "moneybank = '" .. moneybank .. "'", "uniqueID = " .. _char_id)
				end
			end
		end
	end
end

function Player:GetPlayerModel()
	return self:GetNW2String("string_playermodel", "models/player/skeleton.mdl")
end

function Player:IsAgent()
	return self:GetNW2Bool("bool_canbeagent")
end

if SERVER then
	function Player:Unbroke()
		self:SetNW2Bool("broken_leg_right", false)
		self:SetNW2Bool("broken_leg_left", false)
		self:SetNW2Bool("broken_arm_right", false)
		self:SetNW2Bool("broken_arm_left", false)
	end

	function Player:StopCasting(cost)
		cost = cost or 0

		if self:GetNW2String("GetAbilityType", "none") != "none" and self:GetNW2Int("GetCurAbility", 0) >= cost then
			self:SetNW2Int("GetCurAbility", self:GetNW2Int("GetCurAbility", 0) - cost)
		elseif self:GetNW2String("GetAbilityType", "none") != "none" then
			return
		end

		--[[ successfull casting ]]--
		self:SetNW2Bool("iscasting", false)

		self:SetNW2String("castname", "")
		self:SetNW2Float("castcur", 0.0)

		local _args = {}
		_args.attacker = self
		_args.target = self:GetNW2Entity("casttarget")

		hook.Run("yrp_castdone_" .. self:GetNW2String("castnet"), _args)
	end

	function Player:InteruptCasting()
		self:SetNW2String("castname", "")
		self:SetNW2Float("castcur", 0.0)

		--[[ failed casting ]]--
		self:SetNW2Bool("iscasting", false)
		if timer.Exists(self:SteamID() .. "castduration") then
			timer.Remove(self:SteamID() .. "castduration")
		end
		hook.Run("yrp_interupt_" .. self:GetNW2String("castnet", ""))
	end

	function Player:ShowStatus(lang_str, min, max)
		--[[ Setup ]]--
		self:SetNW2String("castname", lang_str)
		self:SetNW2Float("castmax", max)
		self:SetNW2Float("castcur", min)

		--[[ Start casting ]]--
		self:SetNW2Bool("iscasting", true)
	end

	function Player:StartCasting(net_str, lang_str, mode, target, duration, range, cost, canmove)
		--[[ cancel other spells ]]--
		self:InteruptCasting()

		target = target or self

		if self:GetNW2String("GetAbilityType", "none") != "none" and self:GetNW2Int("GetCurAbility", 0) < cost then
			return
		end

		--[[ Setup ]]--
		self:SetNW2String("castnet", net_str)
		self:SetNW2Int("castmode", mode or 0)
		self:SetNW2Bool("castcanmove", canmove or false)
		if !self:GetNW2Bool("castcanmove") then
			self:SetNWVector("castposition", self:GetPos())
		end
		self:SetNW2String("castname", lang_str)
		self:SetNW2Float("castmax", duration or 1.0)
		if self:GetNW2Int("castmode") == 0 then
			self:SetNW2Float("castcur", 0.0)
		elseif self:GetNW2Int("castmode") == 1 then
			self:SetNW2Float("castcur", self:GetNW2Float("castmax"))
		end
		self:SetNW2Entity("casttarget", target)
		self:SetNW2Float("castrange", range or 0.0)

		local tick = 0.1

		--[[ Start casting ]]--
		self:SetNW2Bool("iscasting", true)
		timer.Create(self:SteamID() .. "castduration", tick, 0, function()

			--YRP.msg("note", self:GetNW2String("castname") .. " " .. tostring(self:GetNW2Float("castcur")))

			--[[ Casting ]]--
			if self:GetNW2Int("castmode") == 0 then
				self:SetNW2Float("castcur", self:GetNW2Float("castcur") + tick)
				if !self:GetNW2Bool("castcanmove") then
					local _o_pos = self:GetNWVector("castposition")
					local _c_pos = self:GetPos()
					local _space = 3

					--[[ x, y moved ]]--
					if _c_pos.x + _space < _o_pos.x or _c_pos.x - _space > _o_pos.x or _c_pos.y + _space < _o_pos.y or _c_pos.y - _space > _o_pos.y then
						self:InteruptCasting()
					end
					if !IsValid(target) then return end
					if self:OBBCenter():Distance(target:OBBCenter()) > self:GetNW2Float("castrange") then
						self:InteruptCasting()
					end
				end
				if self:GetNW2Float("castcur") >= self:GetNW2Float("castmax") then
					self:StopCasting(cost)
					timer.Remove(self:SteamID() .. "castduration")
				end

			--[[ Channeling ]]--
			elseif self:GetNW2Int("castmode") == 1 then
				self:SetNW2Float("castcur", self:GetNW2Float("castcur") - tick)
				if self:GetNW2Float("castcur") <= 0.0 then
					self:StopCasting(cost)
					timer.Remove(self:SteamID() .. "castduration")
				end
			end

		end)
	end

	function Player:updateMoney(money)
		self:UpdateMoney()
	end

	function Player:updateMoneyBank(money)
		self:UpdateMoney()
	end

	function Player:addMoney(money)
		if wk(money) and isnumber(money) and isnumber(tonumber(self:GetNW2String("money"))) then
			local newmoney = math.Round(tonumber(self:GetNW2String("money")), 2) + math.Round(money, 2)
			self:SetNW2String("money", math.Round(newmoney, 2))
			self:UpdateMoney()
		end
	end

	function Player:YRPGetMoney()
		return math.Round(tonumber(self:GetNW2String("money", "0")), 2)
	end

	function Player:YRPGetMoneyBank()
		return math.Round(tonumber(self:GetNW2String("moneybank", "0")), 2)
	end

	function Player:SetMoney(money)
		if isnumber(money) then
			self:SetNW2String("money", math.Round(money, 2))
			self:UpdateMoney()
		end
	end

	function Player:SetMoneyBank(money)
		if isnumber(money) then
			self:SetNW2String("moneybank", math.Round(money, 2))
			self:UpdateMoney()
		end
	end

	function Player:addMoneyBank(money)
		if money != nil and isnumber(money) and self:GetNW2String("moneybank") != nil then
			local newmoney = math.Round(tonumber(self:GetNW2String("moneybank")), 2) + math.Round(money, 2)
			self:SetNW2String("moneybank", math.Round(newmoney, 2))
			self:UpdateMoney()
		end
	end

	function Player:resetUptimeCurrent()
		local _res = SQL_UPDATE("yrp_players", "uptime_current = " .. 0, "SteamID = '" .. self:SteamID() .. "'")
	end

	function Player:getuptimetotal()
		local _ret = SQL_SELECT("yrp_players", "uptime_total", "SteamID = '" .. self:SteamID() .. "'")
		if _ret != nil and _ret != false then
			return _ret[1].uptime_total
		end
		return 0
	end

	function Player:getuptimecurrent()
		return os.clock() - self:GetNW2Float("uptime_current", 0)
	end

	function Player:addSecond()
		local _sec_total = self:getuptimetotal()
		local _sec_current = self:getuptimecurrent()
		if _sec_current != nil and _sec_total != nil and _sec_current != false and _sec_total != false then
			local _res = SQL_UPDATE("yrp_players", "uptime_total = " .. _sec_total + 1 .. ", uptime_current = " .. _sec_current + 1, "SteamID = '" .. self:SteamID() .. "'")
			--self:SetNW2Float("uptime_total", self:getuptimetotal())
			--self:SetNW2Float("uptime_server", os.clock())
		end
	end

	function Player:Heal(amount)
		local newhp = math.Clamp(self:Health() + amount, 0, self:GetMaxHealth())
		self:SetHealth(newhp)
	end

	function Player:StartBleeding()
		self:SetNW2Bool("isbleeding", true)
	end

	function Player:StopBleeding()
		self:SetNW2Bool("isbleeding", false)
	end

	function Player:SetBleedingPosition(pos)
		self:SetNWVector("bleedingpos", pos)
	end
end

function Player:GetBleedingPosition()
	return self:GetNWVector("bleedingpos", Vector(0, 0, 0))
end

function Player:canAfford(money)
	if money == nil then return false end
	if self:GetNW2String("money", 0) == nil then return false end

	if isnumber(tonumber(money)) then
		money = math.abs(tonumber(money))
		local curmoney = tonumber(self:GetNW2String("money", 0))
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
end

function Player:canAffordBank(money)
	if money == nil then return false end
	if self:GetNW2String("moneybank") == nil then return false end

	local _tmpMoney = math.abs(tonumber(money))
	if isnumber(_tmpMoney) then
		if tonumber(self:GetNW2String("moneybank")) >= _tmpMoney then
			return true
		else
			return false
		end
	end
end

function Player:SteamName()
	if self:IsValid() then
		return self:GetName() or "FAILED"
	else
		return "FAILED"
	end
end

function Player:YRPRPName()
	return self:GetNW2String("rpname", self:SteamName())
end

function Player:Name()
	return self:GetNW2String("rpname", self:SteamName())
end

function Player:Nick()
	return self:YRPRPName() or "FAILED"
end

function Player:YRPName()
	return "[" .. self:SteamName() .. " (" .. self:RPName() .. ")]"
end

function Player:Team()
	return tonumber(self:GetNW2String("roleUniqueID", "-1"))
end

timer.Simple(10, function()
	function team.GetName(index)
		for k, v in pairs(player.GetAll()) do
			if v:Team() == index then
				return v:GetNW2String("roleName", "NO TEAM") -- darkrp team is role!
			end
		end
		return "FAILED TO FIND TEAMNAME"
	end

	function team.GetColor(index)
		for k, v in pairs(player.GetAll()) do
			if v:Team() == index then
				local _color = v:GetNW2String("roleColor", "255,0,0") -- darkrp team is role!
				_color = string.Explode(",", _color)
				return Color(_color[1], _color[2], _color[3])
			end
		end
		return Color(255, 0, 0)
	end
end)

function Player:YRPGetRoleColor()
	local _rc = self:GetNW2String("roleColor", "255,0,0")
	_rc = string.Explode(",", _rc)
	_rc = Color(_rc[1], _rc[2], _rc[3], _rc[4] or 255)
	return _rc
end

function Player:YRPGetRoleName()
	local _rn = self:GetNW2String("roleName", "")
	return _rn
end

function Player:YRPGetFactionUID()
	local _uid = tonumber(self:GetNW2String("factionUniqueID", "0"))
	return _uid
end

function Player:YRPGetFactionName()
	local _gn = self:GetNW2String("factionName", "")
	return _gn
end

function Player:YRPGetFactionColor()
	local _gc = self:GetNW2String("factionColor", "255,0,0")
	_gc = string.Explode(",", _gc)
	_gc = Color(_gc[1], _gc[2], _gc[3], _gc[4] or 255)
	return _gc
end

function Player:YRPGetGroupUID()
	local _gn = self:GetNW2String("groupUniqueID", "0")
	return tonumber(_gn)
end

function Player:YRPGetGroupName()
	local _gn = self:GetNW2String("groupName", "")
	return _gn
end

function Player:YRPGetGroupColor()
	local _gc = self:GetNW2String("groupColor", "255,0,0")
	_gc = string.Explode(",", _gc)
	_gc = Color(_gc[1], _gc[2], _gc[3], _gc[4] or 255)
	return _gc
end

function Player:YRPGetUserGroupColor()
	local _gc = self:GetNW2String("usergroupColor", "255,0,0")
	_gc = string.Explode(",", _gc)
	_gc = Color(_gc[1], _gc[2], _gc[3], _gc[4] or 255)
	return _gc
end

function Player:HasLicense(license)
	local _licenseIDs = self:GetNW2String("licenseIDs", "")

	local _licenses = string.Explode(",", _licenseIDs)
	if table.HasValue(_licenses, license) then
		return true
	elseif tonumber(license) == -1 then
		return true
	end
	return false
end

-- DOORS
function IsOwnedBy(ply, door)
	if door:isDoor() then
		return tostring(ply:CharID()) == tostring(door:GetNW2String("ownerCharID", ""))
	elseif door:isVehicle() then
		return tostring(ply:CharID()) == tostring(door:GetNW2Int("ownerCharID", 0))
	end
	return false
end

function canLock(ply, door)
	if door:isDoor() then
		if !strEmpty(door:GetNW2String("ownerCharID", "")) then
			if tostring(ply:CharID()) == tostring(door:GetNW2String("ownerCharID", "")) then
				YRP.msg("note", "[canLock] " .. "IsOwner")
				return true
			end
			return false
		elseif door:GetNW2String("ownerGroup", "") != "" then
			if tonumber(ply:GetNW2String("groupUniqueID", "-98")) == tonumber(door:GetNW2Int("ownerGroupUID", -99)) then
				return true
			elseif IsUnderGroupOf(ply, tonumber(door:GetNW2Int("ownerGroupUID", -99))) then
				return true
			end
			return false
		elseif strEmpty(door:GetNW2String("ownerCharID", "")) and door:GetNW2String("ownerGroup", "") == "" then
			YRP.msg("note", "[canLock] " .. "Building has no owner! (from Player: " .. ply:RPName() .. ")")
			return false
		else
			YRP.msg("error", "[canLock] " .. "Unknown Error")
			return false
		end
	else
		return canVehicleLock(ply, door)
	end
end

function canVehicleLock(ply, veh)
	if tostring(veh:GetNW2Int("ownerCharID", 0)) != "0" then
		if tostring(ply:CharID()) == tostring(tab.ownerCharID) then
			return true
		end
		return false
	elseif tostring(veh:GetNW2Int("ownerCharID", 0)) == "0" then
		if veh:GetRPOwner() == ply then
			return true
		end
		return false
	else
		YRP.msg("error", "canVehicleLock ELSE")
		return false
	end
end