--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local Player = FindMetaTable("Player")

function Player:YRPEat(num)
	if isnumber(num) then
		self:SetNWFloat("hunger", self:GetNWFloat("hunger", 0.0) + num)
		if self:GetNWFloat("hunger", 0.0) > 100.0 then
			self:SetNWFloat("hunger", 100.0)
		end
	end
end

function Player:YRPDrink(num)
	if isnumber(num) then
		self:SetNWFloat("thirst", self:GetNWFloat("thirst", 0.0) + num)
		if self:GetNWFloat("thirst", 0.0) > 100.0 then
			self:SetNWFloat("thirst", 100.0)
		end
	end
end

function Player:YRPGetLanguage()
	return YRP.get_language_name(self:GetNWString("client_lang", YRP.lang_string("LID_none")))
end

function Player:YRPGetLanguageShort()
	return self:GetNWString("client_lang", YRP.lang_string("LID_none"))
end

function Player:GetBackpack()
	return self:GetNWEntity("backpack")
end

function Player:HasAccess()
	return self:GetNWBool("bool_adminaccess", false)
end

function Player:LoadedGamemode()
	return self:GetNWBool("finishedloading", false)
end

function Player:GetPlyTab()
	if SERVER then
		if self:IsValid() and self:IsPlayer() then
			if self:LoadedGamemode() then
				if worked(self:SteamID(), "SteamID fail", true) then
					local yrp_players = SQL_SELECT("yrp_players", "*", "SteamID = '" .. self:SteamID() .. "'")
					if worked(yrp_players, "GetPlyTab fail", true) then
						self.plytab = yrp_players[1]
						return self.plytab
					end
				else
					YRP.msg("error", "[GetPlyTab] SteamID() FAILED: " .. tostring(self:SteamID()) )
				end
			else
				--printGM("note", "[GetPlyTab] Gamemode not fully loaded for " .. self:YRPName())
			end
		else
			printGM("error", "[GetPlyTab] player is invalid. (" .. tostring(self:SteamID()) .. ") IsPlayer()?: " .. tostring(self:IsPlayer()))
		end
	end
	return false
end

function Player:IsCharacterValid()
	if SERVER then
		if self:IsValid() and self:IsPlayer() then
			if self:LoadedGamemode() then
				local _cha_tab = self:GetChaTab()
				if _cha_tab == false then
					return false
				else
					return true
				end
			else
				--YRP.msg("note", "[IsCharacterValid] Gamemode not fully loaded for " .. self:YRPName())
			end
		else
			YRP.msg("note", "[IsCharacterValid] not valid or not a player " .. self:YRPName())
		end
	end
end

function Player:HasCharacterSelected()
	if SERVER then
		if self:IsValid() and self:IsPlayer() then
			if self:LoadedGamemode() then
				--printGM("note", self:YRPName() .. " HasCharacterSelected?")
				local _ply_tab = self:GetPlyTab()
				if _ply_tab != false and tostring(_ply_tab.CurrentCharacter) != "NULL" and _ply_tab.CurrentCharacter != NULL then
					return true
				end
			else
				--YRP.msg("note", "[HasCharacterSelected] Gamemode not fully loaded for " .. self:YRPName())
			end
		else
			YRP.msg("note", "[HasCharacterSelected] not valid or not a player " .. self:YRPName())
		end
	end
	return false
end

function Player:GetChaTab()
	if SERVER then
		if self:IsValid() and self:IsPlayer() then
			if self:LoadedGamemode() then
				local _tmp = self:GetPlyTab()
				if wk(_tmp) then
					local yrp_characters = SQL_SELECT("yrp_characters", "*", "uniqueID = " .. _tmp.CurrentCharacter)
					if worked(yrp_characters, "yrp_characters GetChaTab", true) then
						self.chatab = yrp_characters[1]
						return self.chatab
					else
						YRP.msg("error", "[GetChaTab] failed: " .. "yrp_characters failed (" .. tostring(_tmp.CurrentCharacter) .. ")")
					end
				else
					YRP.msg("error", "[GetChaTab] failed: " .. "PlyTab failed")
				end
			else
				--YRP.msg("note", "[GetChaTab] Gamemode not fully loaded for " .. self:YRPName())
			end
		else
			YRP.msg("note", "[GetChaTab] not valid or not a player " .. self:YRPName())
		end
	end
	return false
end

function Player:GetRolTab()
	if SERVER then
		if self:IsValid() and self:IsPlayer() then
			if self:LoadedGamemode() then
				local yrp_characters = self:GetChaTab()
				if worked(yrp_characters, "yrp_characters in GetRolTab", true) and worked(yrp_characters.roleID, "yrp_characters.roleID in GetRolTab", true) then
					local yrp_roles = SQL_SELECT("yrp_ply_roles", "*", "uniqueID = " .. yrp_characters.roleID)
					if worked(yrp_roles, "yrp_roles GetRolTab", true) then
						self.roltab = yrp_roles[1]

						return self.roltab
					end
				end
			else
				--YRP.msg("note", "[GetRolTab] Gamemode not fully loaded for " .. self:YRPName())
			end
		else
			YRP.msg("note", "[GetRolTab] not valid or not a player " .. self:YRPName())
		end
	end
	return false
end

function Player:GetGroTab()
	if SERVER then
		if self:IsValid() and self:IsPlayer() then
			if self:LoadedGamemode() then
				local yrp_characters = self:GetChaTab()
				if worked(yrp_characters, "yrp_characters in GetGroTab", true) and worked(yrp_characters.groupID, "yrp_characters.groupID in GetGroTab", true) then
					local yrp_groups = SQL_SELECT("yrp_ply_groups", "*", "uniqueID = " .. yrp_characters.groupID)
					if worked(yrp_groups, "yrp_groups GetGroTab", true) then
						self.grotab = yrp_groups[1]
						return self.grotab
					end
				end
			else
				--YRP.msg("note", "[GetGroTab] Gamemode not fully loaded for " .. self:YRPName())
			end
		else
			YRP.msg("note", "[GetGroTab] not valid or not a player " .. self:YRPName())
		end
	end
	return false
end

function Player:CharID()
	if SERVER then
		if self:IsValid() and self:IsPlayer() then
			if self:LoadedGamemode() then
				local char = self:GetChaTab()
				if worked(char, "char CharID", true) then
					self.charid = char.uniqueID
					return self.charid
				end
			else
				--YRP.msg("note", "[CharID] Gamemode not fully loaded for " .. self:YRPName())
			end
		else
			YRP.msg("note", "[CharID] not valid or not a player " .. self:YRPName())
		end
	end
	return false
end

function Player:CheckMoney()
	if SERVER then
		timer.Simple(4, function()
			local _m = self:GetNWString("money", "FAILED")
			if _m == "FAILED" then
				printGM("error", "CheckMoney failed")
				return false
			end
			local _money = tonumber(_m)
			if worked(_money, "ply:money CheckMoney", true) and self:CharID() != false then
				SQL_UPDATE("yrp_characters", "money = '" .. _money .. "'", "uniqueID = " .. self:CharID()) --attempt to nil value
			end
			_mb = self:GetNWString("moneybank", "FAILED")
			if _mb == "FAILED" then
				printGM("error", "CheckMoney failed")
				return false
			end
			local _moneybank = tonumber(_mb)
			if worked(_moneybank, "ply:moneybank CheckMoney", true) and self:CharID() != false then
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
				local money = self:GetNWString("money", "FAILED")
				if money == "FAILED" then
					return false
				end
				if worked(money, "ply:money UpdateMoney", true) then
					SQL_UPDATE("yrp_characters", "money = '" .. money .. "'", "uniqueID = " .. _char_id)
				end
				local moneybank = tonumber(self:GetNWString("moneybank", "FAILED"))
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
	return self:GetNWString("string_playermodel", "models/player/skeleton.mdl")
end

function Player:IsAgent()
	return self:GetNWBool("canbeagent")
end

if SERVER then
	function Player:Unbroke()
		self:SetNWBool("broken_leg_right", false)
		self:SetNWBool("broken_leg_left", false)
		self:SetNWBool("broken_arm_right", false)
		self:SetNWBool("broken_arm_left", false)
	end

	function Player:StopCasting()
		--[[ successfull casting ]]--
		self:SetNWBool("iscasting", false)

		self:SetNWString("castname", "")
		self:SetNWFloat("castcur", 0.0)

		local _args = {}
		_args.attacker = self
		_args.target = self:GetNWEntity("casttarget")
		hook.Run("yrp_castdone_" .. self:GetNWString("castnet"), _args)
	end

	function Player:InteruptCasting()
		self:SetNWString("castname", "")
		self:SetNWFloat("castcur", 0.0)

		--[[ failed casting ]]--
		self:SetNWBool("iscasting", false)
		if timer.Exists(self:SteamID() .. "castduration") then
			timer.Remove(self:SteamID() .. "castduration")
		end
	end

	function Player:StartCasting(net_str, lang_str, mode, target, duration, range, cost, canmove)
		--[[ cancel other spells ]]--
		self:InteruptCasting()

		--[[ Setup ]]--
		self:SetNWString("castnet", net_str)
		self:SetNWInt("castmode", mode or 0)
		self:SetNWBool("castcanmove", canmove or false)
		if !self:GetNWBool("castcanmove") then
			self:SetNWVector("castposition", self:GetPos())
		end
		self:SetNWString("castname", lang_str)
		self:SetNWFloat("castmax", duration or 1.0)
		if self:GetNWInt("castmode") == 0 then
			self:SetNWFloat("castcur", 0.0)
		elseif self:GetNWInt("castmode") == 1 then
			self:SetNWFloat("castcur", self:GetNWFloat("castmax"))
		end
		self:SetNWEntity("casttarget", target or self)
		self:SetNWFloat("castrange", range or 0.0)

		--[[ Start casting ]]--
		self:SetNWBool("iscasting", true)
		timer.Create(self:SteamID() .. "castduration", 0.1, 0, function()

			--printGM("note", self:GetNWString("castname") .. " " .. tostring(self:GetNWFloat("castcur")))

			--[[ Casting ]]--
			if self:GetNWInt("castmode") == 0 then
				self:SetNWFloat("castcur", self:GetNWFloat("castcur") + 0.1)
				if !self:GetNWBool("castcanmove") then
					local _o_pos = self:GetNWVector("castposition")
					local _c_pos = self:GetPos()
					local _space = 3

					--[[ x, y moved ]]--
					if _c_pos.x + _space < _o_pos.x or _c_pos.x - _space > _o_pos.x or _c_pos.y + _space < _o_pos.y or _c_pos.y - _space > _o_pos.y then
						self:InteruptCasting()
					end
					if self:GetPos():Distance(target:GetPos()) > self:GetNWFloat("castrange") then
						self:InteruptCasting()
					end
				end
				if self:GetNWFloat("castcur") >= self:GetNWFloat("castmax") then
					self:StopCasting()
					timer.Remove(self:SteamID() .. "castduration")
				end

			--[[ Channeling ]]--
			elseif self:GetNWInt("castmode") == 1 then
				self:SetNWFloat("castcur", self:GetNWFloat("castcur") - 0.1)
				if self:GetNWFloat("castcur") <= 0.0 then
					self:StopCasting()
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
		if isnumber(money) and self:GetNWString("money") != nil then
			local newmoney = math.Round(tonumber(self:GetNWString("money")), 2) + math.Round(money, 2)
			self:SetNWString("money", math.Round(newmoney, 2))
			self:UpdateMoney()
		end
	end

	function Player:YRPGetMoney()
		return math.Round(tonumber(self:GetNWString("money", "0")), 2)
	end

	function Player:YRPGetMoneyBank()
		return math.Round(tonumber(self:GetNWString("moneybank", "0")), 2)
	end

	function Player:SetMoney(money)
		if isnumber(money) then
			self:SetNWString("money", math.Round(money, 2))
			self:UpdateMoney()
		end
	end

	function Player:SetMoneyBank(money)
		if isnumber(money) then
			self:SetNWString("moneybank", math.Round(money, 2))
			self:UpdateMoney()
		end
	end

	function Player:addMoneyBank(money)
		if money != nil then
			if isnumber(money) and self:GetNWString("moneybank") != nil then
				local newmoney = math.Round(tonumber(self:GetNWString("moneybank")), 2) + math.Round(money, 2)
				self:SetNWString("moneybank", math.Round(newmoney, 2))
				self:UpdateMoney()
			end
		end
	end

	function Player:resetUptimeCurrent()
		local _res = SQL_UPDATE("yrp_players", "uptime_current = " .. 0, "SteamID = '" .. self:SteamID() .. "'")
	end

	function Player:getuptimecurrent()
		local _ret = SQL_SELECT("yrp_players", "uptime_current", "SteamID = '" .. self:SteamID() .. "'")
		if _ret != nil and _ret != false then
			return _ret[1].uptime_current
		end
		return 0
	end

	function Player:getuptimetotal()
		local _ret = SQL_SELECT("yrp_players", "uptime_total", "SteamID = '" .. self:SteamID() .. "'")
		if _ret != nil and _ret != false then
			return _ret[1].uptime_total
		end
		return 0
	end

	function Player:addSecond()
		local _sec_total = self:getuptimetotal()
		local _sec_current = self:getuptimecurrent()
		if _sec_current != nil and _sec_total != nil and _sec_current != false and _sec_total != false then
			local _res = SQL_UPDATE("yrp_players", "uptime_total = " .. _sec_total + 1 .. ", uptime_current = " .. _sec_current + 1, "SteamID = '" .. self:SteamID() .. "'")
			self:SetNWFloat("uptime_current", self:getuptimecurrent())
			self:SetNWFloat("uptime_total", self:getuptimetotal())
			self:SetNWFloat("uptime_server", os.clock())
		end
	end

	function Player:Heal(amount)
		self:SetHealth(self:Health() + amount)
		if self:Health() > self:GetMaxHealth() then
			self:SetHealth(self:GetMaxHealth())
		end
	end

	function Player:StartBleeding()
		self:SetNWBool("isbleeding", true)
	end

	function Player:StopBleeding()
		self:SetNWBool("isbleeding", false)
	end

	function Player:SetBleedingPosition(pos)
		self:SetNWVector("bleedingpos", pos)
	end
end

function Player:GetBleedingPosition()
	return self:GetNWVector("bleedingpos", Vector(0, 0, 0))
end

function Player:IsBleeding()
	return self:GetNWBool("isbleeding", false)
end

function Player:canAfford(money)
	if money == nil then return false end
	if self:GetNWString("money") == nil then return false end

	local _tmpMoney = math.abs(tonumber(money))
	if isnumber(_tmpMoney) then
		if tonumber(self:GetNWString("money")) >= _tmpMoney then
			return true
		else
			return false
		end
	else
		return false
	end
end

function Player:canAffordBank(money)
	if money == nil then return false end
	if self:GetNWString("moneybank") == nil then return false end

	local _tmpMoney = math.abs(tonumber(money))
	if isnumber(_tmpMoney) then
		if tonumber(self:GetNWString("moneybank")) >= _tmpMoney then
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
	return self:GetNWString("rpname", self:SteamName())
end

function Player:Name()
	return self:GetNWString("rpname", self:SteamName())
end

function Player:Nick()
	return self:YRPRPName() or "FAILED"
end

function Player:YRPName()
	return "[" .. self:SteamName() .. " (" .. self:RPName() .. ")]"
end

function Player:Team()
	return tonumber(self:GetNWString("groupUniqueID", "-1"))
end

timer.Simple(10, function()
	function team.GetName(index)
		for k, v in pairs(player.GetAll()) do
			if v:Team() == index then
				return v:GetNWString("groupName", "NO TEAM")
			end
		end
		return "FAIL"
	end

	function team.GetColor(index)
		for k, v in pairs(player.GetAll()) do
			if v:Team() == index then
				local _color = v:GetNWString("groupColor", "255,0,0")
				_color = string.Explode(",", _color)
				return Color(_color[1], _color[2], _color[3])
			end
			return Color(255, 0, 0)
		end
	end
end)

function Player:YRPGetRoleName()
	local _rn = self:GetNWString("roleName", "NO ROLE SELECTED")
	return _rn
end

function Player:YRPGetFactionName()
	local _gn = self:GetNWString("factionName", "NO Faction SELECTED")
	return _gn
end

function Player:YRPGetFactionColor()
	local _gc = self:GetNWString("factionColor", "255,0,0")
	_gc = string.Explode(",", _gc)
	_gc = Color(_gc[1], _gc[2], _gc[3], _gc[4] or 255)
	return _gc
end

function Player:YRPGetGroupName()
	local _gn = self:GetNWString("groupName", "NO GROUP SELECTED")
	return _gn
end

function Player:YRPGetGroupColor()
	local _gc = self:GetNWString("groupColor", "255,0,0")
	_gc = string.Explode(",", _gc)
	_gc = Color(_gc[1], _gc[2], _gc[3], _gc[4] or 255)
	return _gc
end

function Player:YRPGetUserGroupColor()
	local _gc = self:GetNWString("usergroupColor", "255,0,0")
	_gc = string.Explode(",", _gc)
	_gc = Color(_gc[1], _gc[2], _gc[3], _gc[4] or 255)
	return _gc
end

function Player:HasLicense(license)
	local _licenseIDs = self:GetNWString("licenseIDs", "")

	local _licenses = string.Explode(",", _licenseIDs)
	if table.HasValue(_licenses, license) then
		return true
	elseif tonumber(license) == -1 then
		return true
	end
	return false
end
