--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local Player = FindMetaTable("Player")

function Player:YRPEat(num)
	if isnumber(num) then
		self:SetNW2Float("hunger", self:GetNW2Float("hunger", 0.0) + num)
		if self:GetNW2Float("hunger", 0.0) > 100.0 then
			self:SetNW2Float("hunger", 100.0)
		end
	end
end

function Player:YRPDrink(num)
	if isnumber(num) then
		self:SetNW2Float("thirst", self:GetNW2Float("thirst", 0.0) + num)
		if self:GetNW2Float("thirst", 0.0) > 100.0 then
			self:SetNW2Float("thirst", 100.0)
		end
	end
end

function Player:YRPGetLanguage()
	return YRP.get_language_name(self:GetNW2String("client_lang", YRP.lang_string("LID_none")))
end

function Player:YRPGetLanguageShort()
	return self:GetNW2String("client_lang", YRP.lang_string("LID_none"))
end

function Player:GetBackpack()
	return self:GetNW2Entity("backpack")
end

function Player:HasAccess()
	return self:GetNW2Bool("bool_adminaccess", false)
end

function Player:LoadedGamemode()
	return self:GetNW2Bool("finishedloading", false)
end

function Player:GetPlyTab()
	if SERVER then
		if self:IsValid() and self:IsPlayer() and !self:IsBot() then
			if self:LoadedGamemode() then
				local steamid = self:SteamID()
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
		if self:IsValid() and self:IsPlayer() and !self:IsBot() then
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
		if self:IsValid() and self:IsPlayer() and !self:IsBot() then
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
		if self:IsValid() and self:IsPlayer() and !self:IsBot() then
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
		if self:IsValid() and self:IsPlayer() and !self:IsBot() then
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
		if self:IsValid() and self:IsPlayer() and !self:IsBot() then
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
	if SERVER then
		if self:IsValid() and self:IsPlayer() and !self:IsBot() then
			if self:LoadedGamemode() then
				local char = self:GetChaTab()
				if wk(char) then
					self.charid = char.uniqueID
					return self.charid
				end
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
			local _m = self:GetNW2String("money", "FAILED")
			if _m == "FAILED" then
				printGM("error", "CheckMoney failed")
				return false
			end
			local _money = tonumber(_m)
			if wk(_money) and self:CharID() != false then
				SQL_UPDATE("yrp_characters", "money = '" .. _money .. "'", "uniqueID = " .. self:CharID()) --attempt to nil value
			end
			_mb = self:GetNW2String("moneybank", "FAILED")
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
	return self:GetNW2Bool("canbeagent")
end

if SERVER then
	function Player:Unbroke()
		self:SetNW2Bool("broken_leg_right", false)
		self:SetNW2Bool("broken_leg_left", false)
		self:SetNW2Bool("broken_arm_right", false)
		self:SetNW2Bool("broken_arm_left", false)
	end

	function Player:StopCasting()
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
	end

	function Player:StartCasting(net_str, lang_str, mode, target, duration, range, cost, canmove)
		--[[ cancel other spells ]]--
		self:InteruptCasting()

		--[[ Setup ]]--
		self:SetNW2String("castnet", net_str)
		self:SetNW2Int("castmode", mode or 0)
		self:SetNW2Bool("castcanmove", canmove or false)
		if !self:GetNW2Bool("castcanmove") then
			self:SetNW2Vector("castposition", self:GetPos())
		end
		self:SetNW2String("castname", lang_str)
		self:SetNW2Float("castmax", duration or 1.0)
		if self:GetNW2Int("castmode") == 0 then
			self:SetNW2Float("castcur", 0.0)
		elseif self:GetNW2Int("castmode") == 1 then
			self:SetNW2Float("castcur", self:GetNW2Float("castmax"))
		end
		self:SetNW2Entity("casttarget", target or self)
		self:SetNW2Float("castrange", range or 0.0)

		--[[ Start casting ]]--
		self:SetNW2Bool("iscasting", true)
		timer.Create(self:SteamID() .. "castduration", 0.1, 0, function()

			--printGM("note", self:GetNW2String("castname") .. " " .. tostring(self:GetNW2Float("castcur")))

			--[[ Casting ]]--
			if self:GetNW2Int("castmode") == 0 then
				self:SetNW2Float("castcur", self:GetNW2Float("castcur") + 0.1)
				if !self:GetNW2Bool("castcanmove") then
					local _o_pos = self:GetNW2Vector("castposition")
					local _c_pos = self:GetPos()
					local _space = 3

					--[[ x, y moved ]]--
					if _c_pos.x + _space < _o_pos.x or _c_pos.x - _space > _o_pos.x or _c_pos.y + _space < _o_pos.y or _c_pos.y - _space > _o_pos.y then
						self:InteruptCasting()
					end
					if self:GetPos():Distance(target:GetPos()) > self:GetNW2Float("castrange") then
						self:InteruptCasting()
					end
				end
				if self:GetNW2Float("castcur") >= self:GetNW2Float("castmax") then
					self:StopCasting()
					timer.Remove(self:SteamID() .. "castduration")
				end

			--[[ Channeling ]]--
			elseif self:GetNW2Int("castmode") == 1 then
				self:SetNW2Float("castcur", self:GetNW2Float("castcur") - 0.1)
				if self:GetNW2Float("castcur") <= 0.0 then
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
		if isnumber(money) and self:GetNW2String("money") != nil then
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
		if money != nil then
			if isnumber(money) and self:GetNW2String("moneybank") != nil then
				local newmoney = math.Round(tonumber(self:GetNW2String("moneybank")), 2) + math.Round(money, 2)
				self:SetNW2String("moneybank", math.Round(newmoney, 2))
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
			self:SetNW2Float("uptime_current", self:getuptimecurrent())
			self:SetNW2Float("uptime_total", self:getuptimetotal())
			self:SetNW2Float("uptime_server", os.clock())
		end
	end

	function Player:Heal(amount)
		self:SetHealth(self:Health() + amount)
		if self:Health() > self:GetMaxHealth() then
			self:SetHealth(self:GetMaxHealth())
		end
	end

	function Player:StartBleeding()
		self:SetNW2Bool("isbleeding", true)
	end

	function Player:StopBleeding()
		self:SetNW2Bool("isbleeding", false)
	end

	function Player:SetBleedingPosition(pos)
		self:SetNW2Vector("bleedingpos", pos)
	end
end

function Player:GetBleedingPosition()
	return self:GetNW2Vector("bleedingpos", Vector(0, 0, 0))
end

function Player:IsBleeding()
	return self:GetNW2Bool("isbleeding", false)
end

function Player:canAfford(money)
	if money == nil then return false end
	if self:GetNW2String("money") == nil then return false end

	local _tmpMoney = math.abs(tonumber(money))
	if isnumber(_tmpMoney) then
		if tonumber(self:GetNW2String("money")) >= _tmpMoney then
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
	return tonumber(self:GetNW2String("groupUniqueID", "-1"))
end

timer.Simple(10, function()
	function team.GetName(index)
		for k, v in pairs(player.GetAll()) do
			if v:Team() == index then
				return v:GetNW2String("groupName", "NO TEAM")
			end
		end
		return "FAIL"
	end

	function team.GetColor(index)
		for k, v in pairs(player.GetAll()) do
			if v:Team() == index then
				local _color = v:GetNW2String("groupColor", "255,0,0")
				_color = string.Explode(",", _color)
				return Color(_color[1], _color[2], _color[3])
			end
			return Color(255, 0, 0)
		end
	end
end)

function Player:YRPGetRoleName()
	local _rn = self:GetNW2String("roleName", "NO ROLE SELECTED")
	return _rn
end

function Player:YRPGetFactionName()
	local _gn = self:GetNW2String("factionName", "NO Faction SELECTED")
	return _gn
end

function Player:YRPGetFactionColor()
	local _gc = self:GetNW2String("factionColor", "255,0,0")
	_gc = string.Explode(",", _gc)
	_gc = Color(_gc[1], _gc[2], _gc[3], _gc[4] or 255)
	return _gc
end

function Player:YRPGetGroupName()
	local _gn = self:GetNW2String("groupName", "NO GROUP SELECTED")
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
