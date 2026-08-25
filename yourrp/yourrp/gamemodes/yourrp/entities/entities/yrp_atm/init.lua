--Copyright (C) 2017-2026 D4KiR (https://www.gnu.org/licenses/gpl.txt)
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	self:SetModel("models/yrp/yrp_atm.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
	self:SetYRPString("status", "startup")
	timer.Simple(4, function()
		if self:IsValid() then self:SetYRPString("status", "logo") end
		timer.Simple(3, function() if self:IsValid() then self:SetYRPString("status", "home") end end)
	end)

	self.pressed = false
	self.menu = {}
	self.menu.home = false
	self.menu.withdraw = false
	self.buttons = {}
	self.namePos = 1
	self:SetYRPString("prevstatus", "")
end

function ENT:OnRemove()
	if self.withdraw ~= nil then self.withdraw:Remove() end
end

function ENT:Use(activator, caller)
	return
end

local OTHERMONEY_MAX_DIGITS = 9
function ENT:ChangeMenu()
	self.menu.home = false
	self.menu.withdraw = false
	self.menu.deposit = false
	self.menu.transfer = false
	self.menu.other = false
	self.menu.fail = false
	for k, v in pairs(self.buttons) do
		if v ~= nil and v ~= NULL then v:Remove() end
	end
end

function ENT:ATMPressPrev(ply)
	local _tmpPlayers = YRP_SQL_SELECT("yrp_characters", "*", nil)
	self.namePos = self.namePos - 4
	if self.namePos < 1 then self.namePos = 1 end
	local names = {}
	local SteamIDs = {}
	local i = 1
	self.names = {}
	self.SteamIDs = {}
	if _tmpPlayers then
		for k, v in pairs(_tmpPlayers) do
			if k >= self.namePos then
				if v.rpname ~= nil and v.rpname ~= NULL then
					names[i] = v.rpname
					SteamIDs[i] = v.uniqueID
				else
					names[i] = ""
					SteamIDs[i] = ""
				end

				i = i + 1
				if i > 4 then break end
			end
		end
	end

	for n = 1, 4 do
		if names[n] and SteamIDs[n] and not strEmpty(tostring(names[n])) then
			self:SetYRPString("name" .. n, tostring(names[n]))
			self:SetYRPString("SteamID" .. n, tostring(SteamIDs[n]))
		else
			self:SetYRPString("name" .. n, "nil")
			self:SetYRPString("SteamID" .. n, "nil")
		end
	end
end

function ENT:ATMPressNext(ply)
	local _tmpPlayers = YRP_SQL_SELECT("yrp_characters", "*", nil)
	if not IsNotNilAndNotFalse(_tmpPlayers) or self.namePos + 4 > #_tmpPlayers then return end
	self.namePos = self.namePos + 4
	local names = {}
	local SteamIDs = {}
	local i = 1
	self.names = {}
	self.SteamIDs = {}
	if _tmpPlayers then
		for k, v in pairs(_tmpPlayers) do
			if k >= self.namePos then
				if v.rpname ~= nil and v.rpname ~= NULL then
					names[i] = v.rpname
					SteamIDs[i] = v.uniqueID
				else
					names[i] = ""
					SteamIDs[i] = ""
				end

				i = i + 1
				if i > 4 then break end
			end
		end
	end

	for n = 1, 4 do
		if names[n] and SteamIDs[n] and not strEmpty(tostring(names[n])) then
			self:SetYRPString("name" .. n, tostring(names[n]))
			self:SetYRPString("SteamID" .. n, tostring(SteamIDs[n]))
		else
			self:SetYRPString("name" .. n, "nil")
			self:SetYRPString("SteamID" .. n, "nil")
		end
	end
end

function ENT:createButtonNumber(parent, up, forward, right, add)
	local tmp = ents.Create("yrp_button2")
	tmp:SetPos(parent:GetPos() + parent:GetUp() * up + parent:GetForward() * forward + parent:GetRight() * (right - 4))
	tmp:SetAngles(parent:GetAngles() + Angle(45, 0, 0))
	tmp:SetParent(parent)
	tmp:Spawn()
	tmp:SetColor(Color(255, 0, 0, 0))
	tmp:SetRenderMode(RENDERMODE_TRANSALPHA)
	tmp.parent = parent
	function tmp:Use(activator, caller, useType, value)
		if not IsValid(parent) or parent.pressed then return end
		parent.pressed = true
		local filename = "buttons/button14.wav"
		util.PrecacheSound(filename)
		self:EmitSound(filename, 75, 100, 1, CHAN_AUTO)
		local cur = parent:GetYRPString("othermoney", "")
		if add ~= "<" then
			if string.len(cur) < OTHERMONEY_MAX_DIGITS then parent:SetYRPString("othermoney", cur .. add) end
		else
			parent:SetYRPString("othermoney", string.sub(cur, 1, string.len(cur) - 1))
		end

		timer.Simple(0.2, function() if IsValid(parent) then parent.pressed = false end end)
	end
	return tmp
end

function ATMTransfer(atm, activator, amount)
	if not activator:canAffordBank(amount) then return end
	local targetID = tonumber(atm:GetYRPString("SteamID"))
	if targetID == nil then
		YRP:msg("note", "[ATM] no valid transfer target")
		return
	end

	local dbSelectActivator = YRP_SQL_SELECT("yrp_characters", "*", "uniqueID = " .. activator:CharID())
	local dbSelectTarget = YRP_SQL_SELECT("yrp_characters", "*", "uniqueID = " .. targetID)
	if not IsNotNilAndNotFalse(dbSelectActivator) or dbSelectActivator[1] == nil then return end
	if not IsNotNilAndNotFalse(dbSelectTarget) or dbSelectTarget[1] == nil then return end
	if dbSelectTarget[1].SteamID == activator:YRPSteamID() then return end
	local fromBank = (tonumber(dbSelectActivator[1].moneybank) or 0) - amount
	local toBank = (tonumber(dbSelectTarget[1].moneybank) or 0) + amount
	YRP_SQL_UPDATE("yrp_characters", {
		["moneybank"] = fromBank
	}, "uniqueID = " .. activator:CharID())

	YRP_SQL_UPDATE("yrp_characters", {
		["moneybank"] = toBank
	}, "uniqueID = " .. targetID)

	activator:SetYRPString("moneybank", fromBank)
	for k, v in pairs(player.GetAll()) do
		if tonumber(v:CharID()) == targetID then
			v:SetYRPString("moneybank", toBank)
			break
		end
	end

	YRP:msg("note", activator:RPName() .. " transfered " .. GetGlobalYRPString("text_money_pre", "") .. amount .. GetGlobalYRPString("text_money_pos", "") .. " to " .. dbSelectTarget[1].rpname)
end

function ENT:createButton(parent, up, forward, right, status, _money, func)
	local tmp = ents.Create("yrp_button")
	tmp:SetPos(parent:GetPos() + parent:GetUp() * up + parent:GetForward() * forward + parent:GetRight() * (right - 4))
	tmp:SetAngles(parent:GetAngles() + Angle(45, 0, 0))
	tmp:SetParent(parent)
	tmp:Spawn()
	tmp:SetColor(Color(255, 0, 0, 0))
	tmp:SetRenderMode(RENDERMODE_TRANSALPHA)
	tmp.parent = parent
	tmp.money = tonumber(_money)
	function tmp:Use(activator, caller, useType, value)
		if not IsValid(parent) or parent.pressed then return end
		if not IsValid(activator) or not activator:IsPlayer() then return end
		parent.pressed = true
		timer.Simple(0.2, function() if IsValid(parent) then parent.pressed = false end end)
		local filename = "buttons/button14.wav"
		util.PrecacheSound(filename)
		self:EmitSound(filename, 75, 100, 1, CHAN_AUTO)
		local money = self.money
		if func == "ATMPressNext" then
			parent:ATMPressNext(activator)
		elseif func == "ATMPressPrev" then
			parent:ATMPressPrev(activator)
		elseif func == "ATMPressPlayer1" then
			parent:SetYRPString("name", parent:GetYRPString("name1"))
			parent:SetYRPString("SteamID", parent:GetYRPString("SteamID1"))
		elseif func == "ATMPressPlayer2" then
			parent:SetYRPString("name", parent:GetYRPString("name2"))
			parent:SetYRPString("SteamID", parent:GetYRPString("SteamID2"))
		elseif func == "ATMPressPlayer3" then
			parent:SetYRPString("name", parent:GetYRPString("name3"))
			parent:SetYRPString("SteamID", parent:GetYRPString("SteamID3"))
		elseif func == "ATMPressPlayer4" then
			parent:SetYRPString("name", parent:GetYRPString("name4"))
			parent:SetYRPString("SteamID", parent:GetYRPString("SteamID4"))
		elseif func == "confirm" then
			money = nil
			local amount = tonumber(parent:GetYRPString("othermoney", ""))
			local prev = parent:GetYRPString("prevstatus")
			if amount == nil or amount <= 0 then
				YRP:msg("note", "[ATM] no valid amount entered")
			elseif prev == "withdraw" then
				money = -amount
			elseif prev == "deposit" then
				money = amount
			elseif prev == "transfer" then
				ATMTransfer(parent, activator, amount)
			end
		end

		if status ~= nil then parent:SetYRPString("status", status) end
		if money ~= nil then
			if money > 0 then
				if activator:canAfford(money) then
					activator:addMoneyBank(money)
					activator:addMoney(-money)
				end
			elseif activator:canAffordBank(money) then
				activator:addMoneyBank(money)
				activator:addMoney(-money)
			end
		end

		parent:ChangeMenu()
	end
	return tmp
end

function ENT:Think()
	if self:GetYRPString("status") == "home" then
		if not self.menu.home then
			self.menu.home = true
			self.buttons.withdraw = self:createButton(self, 49.74, 7.14, 8.8, "withdraw", nil, nil)
			self.buttons.deposit = self:createButton(self, 48.0, 8.84, 8.8, "deposit", nil, nil)
			self.buttons.transfer = self:createButton(self, 46.36, 10.54, 8.8, "transfer", nil, "ATMPressPrev")
		end
	elseif self:GetYRPString("status") == "withdraw" then
		if not self.menu.withdraw then
			self.menu.withdraw = true
			self:SetYRPString("prevstatus", "withdraw")
			self.buttons.withdraw5 = self:createButton(self, 49.74, 7.14, 8.8, "home", -5, nil)
			self.buttons.withdraw10 = self:createButton(self, 48.0, 8.84, 8.8, "home", -10, nil)
			self.buttons.withdraw20 = self:createButton(self, 46.36, 10.54, 8.8, "home", -20, nil)
			self.buttons.withdraw50 = self:createButton(self, 49.74, 7.14, -0.8, "home", -50, nil)
			self.buttons.withdraw100 = self:createButton(self, 48.0, 8.84, -0.8, "home", -100, nil)
			self.buttons.withdraw200 = self:createButton(self, 46.36, 10.54, -0.8, "other", nil, nil)
			self.buttons.withdrawBack = self:createButton(self, 43.48, 13.32, 8.8, "home", nil, nil)
		end
	elseif self:GetYRPString("status") == "deposit" then
		if not self.menu.deposit then
			self.menu.deposit = true
			self:SetYRPString("prevstatus", "deposit")
			self.buttons.deposit5 = self:createButton(self, 49.74, 7.14, 8.8, "home", 5, nil)
			self.buttons.deposit10 = self:createButton(self, 48.0, 8.84, 8.8, "home", 10, nil)
			self.buttons.deposit20 = self:createButton(self, 46.36, 10.54, 8.8, "home", 20, nil)
			self.buttons.deposit50 = self:createButton(self, 49.74, 7.14, -0.8, "home", 50, nil)
			self.buttons.deposit100 = self:createButton(self, 48.0, 8.84, -0.8, "home", 100, nil)
			self.buttons.deposit200 = self:createButton(self, 46.36, 10.54, -0.8, "other", nil, nil)
			self.buttons.depositBack = self:createButton(self, 43.48, 13.32, 8.8, "home", nil, nil)
		end
	elseif self:GetYRPString("status") == "transfer" then
		if not self.menu.transfer then
			self.menu.transfer = true
			self:SetYRPString("prevstatus", "transfer")
			if self:GetYRPString("name1") ~= "nil" then self.buttons.transferName1 = self:createButton(self, 49.74, 7.14, 8.8, "other", nil, "ATMPressPlayer1") end
			if self:GetYRPString("name2") ~= "nil" then self.buttons.transferName2 = self:createButton(self, 48.0, 8.84, 8.8, "other", nil, "ATMPressPlayer2") end
			self.buttons.transferPrev = self:createButton(self, 46.36, 10.54, 8.8, nil, nil, "ATMPressPrev")
			if self:GetYRPString("name3") ~= "nil" then self.buttons.transferName3 = self:createButton(self, 49.74, 7.14, -0.8, "other", nil, "ATMPressPlayer3") end
			if self:GetYRPString("name4") ~= "nil" then self.buttons.transferName4 = self:createButton(self, 48.0, 8.84, -0.8, "other", nil, "ATMPressPlayer4") end
			self.buttons.transferNext = self:createButton(self, 46.36, 10.54, -0.8, nil, nil, "ATMPressNext")
			self.buttons.transferBack = self:createButton(self, 43.48, 13.32, 8.8, "home", nil, nil)
		end
	elseif self:GetYRPString("status") == "other" then
		if not self.menu.other then
			self.menu.other = true
			self:SetYRPString("othermoney", "")
			self.buttons.remove = self:createButtonNumber(self, 50.5, 6.7, -0.8, "<")
			self.buttons.add1 = self:createButtonNumber(self, 48.8, 8.4, 6.4, "1")
			self.buttons.add2 = self:createButtonNumber(self, 48.8, 8.4, 4.0, "2")
			self.buttons.add3 = self:createButtonNumber(self, 48.8, 8.4, 1.6, "3")
			self.buttons.add4 = self:createButtonNumber(self, 47.1, 10.1, 6.4, "4")
			self.buttons.add5 = self:createButtonNumber(self, 47.1, 10.1, 4.0, "5")
			self.buttons.add6 = self:createButtonNumber(self, 47.1, 10.1, 1.6, "6")
			self.buttons.add7 = self:createButtonNumber(self, 45.5, 11.8, 6.4, "7")
			self.buttons.add8 = self:createButtonNumber(self, 45.5, 11.8, 4.0, "8")
			self.buttons.add9 = self:createButtonNumber(self, 45.5, 11.8, 1.6, "9")
			self.buttons.add0 = self:createButtonNumber(self, 45.5, 11.8, -0.8, "0")
			self.buttons.confirm = self:createButton(self, 43.48, 13.32, -0.8, "home", nil, "confirm")
			self.buttons.otherBack = self:createButton(self, 43.48, 13.32, 8.8, "home", nil, nil)
		end
	else
		if self:GetYRPString("status") ~= "startup" and self:GetYRPString("status") ~= "logo" and not self.menu.fail then
			self.menu.fail = true
			self.buttons.failBack = self:createButton(self, 43.48, 13.32, 8.8, "home", nil)
		end
	end
end
