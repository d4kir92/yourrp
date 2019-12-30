--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local Player = FindMetaTable("Player")

function Player:YRPEat(num)
	if isnumber(num) then
		self:SetDFloat("hunger", self:GetDFloat("hunger", 0.0) + num)
		if self:GetDFloat("hunger", 0.0) > 100.0 then
			self:SetDFloat("hunger", 100.0)
		end
	end
end

function Player:YRPDrink(num)
	if isnumber(num) then
		self:SetDFloat("thirst", self:GetDFloat("thirst", 0.0) + num)
		if self:GetDFloat("thirst", 0.0) > 100.0 then
			self:SetDFloat("thirst", 100.0)
		end
	end
end

function Player:YRPGetLanguage()
	return YRP.get_language_name(self:GetDString("client_lang", YRP.lang_string("LID_none")))
end

function Player:YRPGetLanguageShort()
	return self:GetDString("client_lang", YRP.lang_string("LID_none"))
end

function Player:HasAccess()
	return self:GetDBool("bool_adminaccess", false) or self:IsSuperAdmin()
end

function Player:LoadedGamemode()
	return self:GetDBool("finishedloading", false)
end

function Player:GetPlyTab()
	if SERVER then
		if self:IsValid() then
			if self:LoadedGamemode() then
				local steamid = self:SteamID() or self:UniqueID()
				if steamid != nil and steamid != false and steamid != "" then
					local yrp_players = SQL_SELECT("yrp_players", "*", "SteamID = '" .. steamid .. "'")
					if wk(yrp_players) then
						self.plytab = yrp_players[1]
						return self.plytab
					else
						YRP.msg("error", "[GetPlyTab] table: " .. tostring(yrp_players) .. " SteamID [" .. tostring(steamid) .. "]")
					end
				else
					YRP.msg("error", "[GetPlyTab] SteamID failed [" .. tostring(steamid) .. "]" )
				end
			end
		else
			printGM("error", "[GetPlyTab] player is invalid. (" .. tostring(self:SteamID()) .. ") IsPlayer()?: " .. tostring(self:IsPlayer()))
		end
	end
	return false
end

function Player:IsCharacterValid()
	if SERVER then
		if self:IsValid() then
			if self:LoadedGamemode() then
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
			if self:LoadedGamemode() then
				--printGM("note", self:YRPName() .. " HasCharacterSelected?")
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
			if self:LoadedGamemode() then
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
					YRP.msg("error", "[GetChaTab] failed: " .. "PlyTab: " .. tostring(_tmp))
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
			if self:LoadedGamemode() then
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
			if self:LoadedGamemode() then
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
		return 1
	else
		return tonumber(self:GetDString("charid", "-1"))
	end
end

function Player:CheckMoney()
	if SERVER then
		timer.Simple(4, function()
			local _m = self:GetDString("money", "FAILED")
			if _m == "FAILED" then
				printGM("error", "CheckMoney failed")
				return false
			end
			local _money = tonumber(_m)
			if wk(_money) and self:CharID() != false then
				SQL_UPDATE("yrp_characters", "money = '" .. _money .. "'", "uniqueID = " .. self:CharID()) --attempt to nil value
			end
			_mb = self:GetDString("moneybank", "FAILED")
			if _mb == "FAILED" then
				printGM("error", "CheckMoney failed")
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
				local money = self:GetDString("money", "FAILED")
				if money == "FAILED" then
					return false
				end
				if worked(money, "ply:money UpdateMoney", true) then
					SQL_UPDATE("yrp_characters", "money = '" .. money .. "'", "uniqueID = " .. _char_id)
				end
				local moneybank = tonumber(self:GetDString("moneybank", "FAILED"))
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
	return self:GetDString("string_playermodel", "models/player/skeleton.mdl")
end

function Player:IsAgent()
	return self:GetDBool("canbeagent")
end

if SERVER then
	function Player:Unbroke()
		self:SetDBool("broken_leg_right", false)
		self:SetDBool("broken_leg_left", false)
		self:SetDBool("broken_arm_right", false)
		self:SetDBool("broken_arm_left", false)
	end

	function Player:StopCasting(cost)
		cost = cost or 0

		if self:GetDString("GetAbilityType", "none") != "none" and self:GetDInt("GetCurAbility", 0) >= cost then
			self:SetDInt("GetCurAbility", self:GetDInt("GetCurAbility", 0) - cost)
		elseif self:GetDString("GetAbilityType", "none") != "none" then
			return
		end

		--[[ successfull casting ]]--
		self:SetDBool("iscasting", false)

		self:SetDString("castname", "")
		self:SetDFloat("castcur", 0.0)

		local _args = {}
		_args.attacker = self
		_args.target = self:GetDEntity("casttarget")

		hook.Run("yrp_castdone_" .. self:GetDString("castnet"), _args)
	end

	function Player:InteruptCasting()
		self:SetDString("castname", "")
		self:SetDFloat("castcur", 0.0)

		--[[ failed casting ]]--
		self:SetDBool("iscasting", false)
		if timer.Exists(self:SteamID() .. "castduration") then
			timer.Remove(self:SteamID() .. "castduration")
		end
		hook.Run("yrp_interupt_" .. self:GetDString("castnet", ""))
	end

	function Player:ShowStatus(lang_str, min, max)
		--[[ Setup ]]--
		self:SetDString("castname", lang_str)
		self:SetDFloat("castmax", max)
		self:SetDFloat("castcur", min)

		--[[ Start casting ]]--
		self:SetDBool("iscasting", true)
	end

	function Player:StartCasting(net_str, lang_str, mode, target, duration, range, cost, canmove)
		--[[ cancel other spells ]]--
		self:InteruptCasting()

		target = target or self

		if self:GetDString("GetAbilityType", "none") != "none" and self:GetDInt("GetCurAbility", 0) < cost then
			return
		end

		--[[ Setup ]]--
		self:SetDString("castnet", net_str)
		self:SetDInt("castmode", mode or 0)
		self:SetDBool("castcanmove", canmove or false)
		if !self:GetDBool("castcanmove") then
			self:SetNWVector("castposition", self:GetPos())
		end
		self:SetDString("castname", lang_str)
		self:SetDFloat("castmax", duration or 1.0)
		if self:GetDInt("castmode") == 0 then
			self:SetDFloat("castcur", 0.0)
		elseif self:GetDInt("castmode") == 1 then
			self:SetDFloat("castcur", self:GetDFloat("castmax"))
		end
		self:SetDEntity("casttarget", target)
		self:SetDFloat("castrange", range or 0.0)

		local tick = 0.1

		--[[ Start casting ]]--
		self:SetDBool("iscasting", true)
		timer.Create(self:SteamID() .. "castduration", tick, 0, function()

			--printGM("note", self:GetDString("castname") .. " " .. tostring(self:GetDFloat("castcur")))

			--[[ Casting ]]--
			if self:GetDInt("castmode") == 0 then
				self:SetDFloat("castcur", self:GetDFloat("castcur") + tick)
				if !self:GetDBool("castcanmove") then
					local _o_pos = self:GetNWVector("castposition")
					local _c_pos = self:GetPos()
					local _space = 3

					--[[ x, y moved ]]--
					if _c_pos.x + _space < _o_pos.x or _c_pos.x - _space > _o_pos.x or _c_pos.y + _space < _o_pos.y or _c_pos.y - _space > _o_pos.y then
						self:InteruptCasting()
					end
					if self:OBBCenter():Distance(target:OBBCenter()) > self:GetDFloat("castrange") then
						self:InteruptCasting()
					end
				end
				if self:GetDFloat("castcur") >= self:GetDFloat("castmax") then
					self:StopCasting(cost)
					timer.Remove(self:SteamID() .. "castduration")
				end

			--[[ Channeling ]]--
			elseif self:GetDInt("castmode") == 1 then
				self:SetDFloat("castcur", self:GetDFloat("castcur") - tick)
				if self:GetDFloat("castcur") <= 0.0 then
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
		if wk(money) and isnumber(money) and self:GetDString("money") != nil then
			local newmoney = math.Round(tonumber(self:GetDString("money")), 2) + math.Round(money, 2)
			self:SetDString("money", math.Round(newmoney, 2))
			self:UpdateMoney()
		end
	end

	function Player:YRPGetMoney()
		return math.Round(tonumber(self:GetDString("money", "0")), 2)
	end

	function Player:YRPGetMoneyBank()
		return math.Round(tonumber(self:GetDString("moneybank", "0")), 2)
	end

	function Player:SetMoney(money)
		if isnumber(money) then
			self:SetDString("money", math.Round(money, 2))
			self:UpdateMoney()
		end
	end

	function Player:SetMoneyBank(money)
		if isnumber(money) then
			self:SetDString("moneybank", math.Round(money, 2))
			self:UpdateMoney()
		end
	end

	function Player:addMoneyBank(money)
		if money != nil and isnumber(money) and self:GetDString("moneybank") != nil then
			local newmoney = math.Round(tonumber(self:GetDString("moneybank")), 2) + math.Round(money, 2)
			self:SetDString("moneybank", math.Round(newmoney, 2))
			self:UpdateMoney()
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
			self:SetDFloat("uptime_current", self:getuptimecurrent())
			self:SetDFloat("uptime_total", self:getuptimetotal())
			self:SetDFloat("uptime_server", os.clock())
		end
	end

	function Player:Heal(amount)
		self:SetHealth(self:Health() + amount)
		if self:Health() > self:GetMaxHealth() then
			self:SetHealth(self:GetMaxHealth())
		end
	end

	function Player:StartBleeding()
		self:SetDBool("isbleeding", true)
	end

	function Player:StopBleeding()
		self:SetDBool("isbleeding", false)
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
	if self:GetDString("money") == nil then return false end

	local _tmpMoney = math.abs(tonumber(money))
	if isnumber(_tmpMoney) then
		if tonumber(self:GetDString("money")) >= _tmpMoney then
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
	if self:GetDString("moneybank") == nil then return false end

	local _tmpMoney = math.abs(tonumber(money))
	if isnumber(_tmpMoney) then
		if tonumber(self:GetDString("moneybank")) >= _tmpMoney then
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
	return self:GetDString("rpname", self:SteamName())
end

function Player:Name()
	return self:GetDString("rpname", self:SteamName())
end

function Player:Nick()
	return self:YRPRPName() or "FAILED"
end

function Player:YRPName()
	return "[" .. self:SteamName() .. " (" .. self:RPName() .. ")]"
end

function Player:Team()
	return tonumber(self:GetDString("groupUniqueID", "-1"))
end

timer.Simple(10, function()
	function team.GetName(index)
		for k, v in pairs(player.GetAll()) do
			if v:Team() == index then
				return v:GetDString("roleName", "NO TEAM") -- darkrp team is role!
			end
		end
		return "FAILED TO FIND TEAMNAME"
	end

	function team.GetColor(index)
		for k, v in pairs(player.GetAll()) do
			if v:Team() == index then
				local _color = v:GetDString("roleColor", "255,0,0") -- darkrp team is role!
				_color = string.Explode(",", _color)
				return Color(_color[1], _color[2], _color[3])
			end
		end
		return Color(255, 0, 0)
	end
end)

function Player:YRPGetRoleColor()
	local _rc = self:GetDString("roleColor", "255,0,0")
	_rc = string.Explode(",", _rc)
	_rc = Color(_rc[1], _rc[2], _rc[3], _rc[4] or 255)
	return _rc
end

function Player:YRPGetRoleName()
	local _rn = self:GetDString("roleName", "NO ROLE SELECTED")
	return _rn
end

function Player:YRPGetFactionUID()
	local _uid = tonumber(self:GetDString("factionUniqueID", "0"))
	return _uid
end

function Player:YRPGetFactionName()
	local _gn = self:GetDString("factionName", "NO Faction SELECTED")
	return _gn
end

function Player:YRPGetFactionColor()
	local _gc = self:GetDString("factionColor", "255,0,0")
	_gc = string.Explode(",", _gc)
	_gc = Color(_gc[1], _gc[2], _gc[3], _gc[4] or 255)
	return _gc
end

function Player:YRPGetGroupUID()
	local _gn = self:GetDString("groupUniqueID", "0")
	return tonumber(_gn)
end

function Player:YRPGetGroupName()
	local _gn = self:GetDString("groupName", "NO GROUP SELECTED")
	return _gn
end

function Player:YRPGetGroupColor()
	local _gc = self:GetDString("groupColor", "255,0,0")
	_gc = string.Explode(",", _gc)
	_gc = Color(_gc[1], _gc[2], _gc[3], _gc[4] or 255)
	return _gc
end

function Player:YRPGetUserGroupColor()
	local _gc = self:GetDString("usergroupColor", "255,0,0")
	_gc = string.Explode(",", _gc)
	_gc = Color(_gc[1], _gc[2], _gc[3], _gc[4] or 255)
	return _gc
end

function Player:HasLicense(license)
	local _licenseIDs = self:GetDString("licenseIDs", "")

	local _licenses = string.Explode(",", _licenseIDs)
	if table.HasValue(_licenses, license) then
		return true
	elseif tonumber(license) == -1 then
		return true
	end
	return false
end

