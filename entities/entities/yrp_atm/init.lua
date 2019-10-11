--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("ATMPressPrev")
util.AddNetworkString("ATMPressNext")

function ENT:Initialize()
	self:SetModel("models/yrp/yrp_atm.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end

	self:SetDString("status", "startup")
	timer.Simple(4, function()
		if self:IsValid() then
			self:SetDString("status", "logo")
		end
		timer.Simple(3, function()
			if self:IsValid() then
				self:SetDString("status", "home")
			end
		end)
	end)

	self.pressed = false

	self.menu = {}
	self.menu.home = false
	self.menu.withdraw = false

	self.buttons = {}

	self.namePos = 1

	self:SetDString("prevstatus", "")

	ent = self
end

function ENT:OnRemove()
	if self.withdraw != nil then
		self.withdraw:Remove()
	end
end

function ENT:Use(activator, caller)
	return
end

local pressed = false

function ENT:ChangeMenu()
	self.menu.home = false
	self.menu.withdraw = false
	self.menu.deposit = false
	self.menu.transfer = false
	self.menu.other = falsecha

	self.menu.fail = false

	for k, v in pairs(self.buttons) do
		if v != nil and v != NULL then
			v:Remove()
		end
	end
end

function ENT:ATMPressPrev(ply)
	local _tmpPlayers = SQL_SELECT("yrp_characters", "*", nil)
	self.namePos = self.namePos - 4
	if self.namePos < 1 then
		self.namePos = 1
	end
	local names = {}
	local SteamIDs = {}
	local i = 1
	self.names = {}
	self.SteamIDs = {}
	for k, v in pairs(_tmpPlayers) do
		if k >= self.namePos then
			if v.rpname != nil and v.rpname != NULL then
				names[i] = v.rpname
				SteamIDs[i] = v.uniqueID
			else
				names[i] = ""
				SteamIDs[i] = ""
			end
			i = i + 1
			if self.namePos > self.namePos + 4 then
				break
			end
		end
	end
	self:SetDString("name1", tostring(names[1]))
	self:SetDString("SteamID1", tostring(SteamIDs[1]))
	self:SetDString("name2", tostring(names[2]))
	self:SetDString("SteamID2", tostring(SteamIDs[2]))
	self:SetDString("name3", tostring(names[3]))
	self:SetDString("SteamID3", tostring(SteamIDs[3]))
	self:SetDString("name4", tostring(names[4]))
	self:SetDString("SteamID4", tostring(SteamIDs[4]))
end

function ENT:ATMPressNext(ply)
	local _tmpPlayers = SQL_SELECT("yrp_players", "*", nil)
	self.namePos = self.namePos + 4
	local names = {}
	local SteamIDs = {}
	local i = 1
	self.names = {}
	self.SteamIDs = {}
	for k, v in pairs(_tmpPlayers) do
		if k >= self.namePos then
			if v.rpname != nil and v.rpname != NULL then
				names[i] = v.rpname
				SteamIDs[i] = v.uniqueID
			else
				names[i] = ""
				SteamIDs[i] = ""
			end
			i = i + 1
			if self.namePos > self.namePos + 4 then
				break
			end
		end
	end
	self:SetDString("name1", tostring(names[1]))
	self:SetDString("SteamID1", tostring(SteamIDs[1]))
	self:SetDString("name2", tostring(names[2]))
	self:SetDString("SteamID2", tostring(SteamIDs[2]))
	self:SetDString("name3", tostring(names[3]))
	self:SetDString("SteamID3", tostring(SteamIDs[3]))
	self:SetDString("name4", tostring(names[4]))
	self:SetDString("SteamID4", tostring(SteamIDs[4]))
end

function ENT:createButtonNumber(parent, up, forward, right, add)
	local tmp = ents.Create("yrp_button2")
	tmp:SetPos(parent:GetPos() + parent:GetUp() * up + parent:GetForward() * forward + parent:GetRight() * (right-4))
	tmp:SetAngles(parent:GetAngles() + Angle(45, 0, 0))
	tmp:SetParent(parent)
	tmp:Spawn()
	tmp:SetColor(Color(255, 0, 0, 0))
	tmp:SetRenderMode(RENDERMODE_TRANSALPHA)
	tmp.parent = parent

	function tmp:Use(activator, caller, useType, value)
		if !pressed then
			pressed = true
			self:EmitSound("buttons/button14.wav", 75, 100, 1, CHAN_AUTO )
			if add != "<" then
				tmp.parent:SetDString("othermoney", tmp.parent:GetDString("othermoney", "") .. add)
			else
				local stringExp = string.sub(tmp.parent:GetDString("othermoney"), 1, string.len(tmp.parent:GetDString("othermoney")) - 1)
				tmp.parent:SetDString("othermoney", stringExp)
			end
			timer.Simple(0.2, function()
				pressed = false
			end)
		end
	end

	return tmp
end

function ENT:createButton(parent, up, forward, right, status, _money, func)
	local tmp = ents.Create("yrp_button")
	tmp:SetPos(parent:GetPos() + parent:GetUp() * up + parent:GetForward() * forward + parent:GetRight() * (right-4))
	tmp:SetAngles(parent:GetAngles() + Angle(45, 0, 0))
	tmp:SetParent(parent)
	tmp:Spawn()
	tmp:SetColor(Color(255, 0, 0, 0))
	tmp:SetRenderMode(RENDERMODE_TRANSALPHA)
	tmp.parent = parent
	tmp.money = tonumber(_money)

	function tmp:Use(activator, caller, useType, value)
		if !pressed then
			pressed = true
			self:EmitSound("buttons/button14.wav", 75, 100, 1, CHAN_AUTO )
			if func != nil then
				if func == "ATMPressNext" then
					self.parent:ATMPressNext(activator)
				elseif func == "ATMPressPrev" then
					self.parent:ATMPressPrev(activator)
				elseif func == "ATMPressPlayer1" then
					self.parent:SetDString("name", self.parent:GetDString("name1"))
					self.parent:SetDString("SteamID", self.parent:GetDString("SteamID1"))
				elseif func == "ATMPressPlayer2" then
					self.parent:SetDString("name", self.parent:GetDString("name2"))
					self.parent:SetDString("SteamID", self.parent:GetDString("SteamID2"))
				elseif func == "ATMPressPlayer3" then
					self.parent:SetDString("name", self.parent:GetDString("name3"))
					self.parent:SetDString("SteamID", self.parent:GetDString("SteamID3"))
				elseif func == "ATMPressPlayer4" then
					self.parent:SetDString("name", self.parent:GetDString("name4"))
					self.parent:SetDString("SteamID", self.parent:GetDString("SteamID4"))
				elseif func == "confirm" then
					if self.parent:GetDString("prevstatus") == "withdraw" then
						self.money = -tonumber(self.parent:GetDString("othermoney", "0"))
					elseif self.parent:GetDString("prevstatus") == "deposit" then
						self.money = tonumber(self.parent:GetDString("othermoney", "0"))
					elseif self.parent:GetDString("prevstatus") == "transfer" then
						self.money = tonumber(self.parent:GetDString("othermoney", "0"))

						if self.money != nil and isnumber(self.money) then
							if self.money > 0 then
								if activator:canAffordBank(self.money) then
									local dbSelectActivator = SQL_SELECT("yrp_characters", "*", "uniqueID = " .. activator:CharID())
									local dbSelectTarget = SQL_SELECT("yrp_characters", "*", "uniqueID = " .. tostring(self.parent:GetDString("SteamID")))
									if dbSelectActivator != nil and dbSelectTarget != nil then
										if dbSelectTarget[1].SteamID != activator:SteamID() then
											dbSelectActivator[1].moneybank = dbSelectActivator[1].moneybank-self.money
											SQL_UPDATE("yrp_characters", "moneybank = " .. dbSelectActivator[1].moneybank, "uniqueID = " .. activator:CharID())

											dbSelectTarget[1].moneybank = dbSelectTarget[1].moneybank+self.money
											SQL_UPDATE("yrp_characters", "moneybank = " .. dbSelectTarget[1].moneybank, "uniqueID = '" .. self.parent:GetDString("SteamID") .. "'")

											activator:SetDString("moneybank", dbSelectActivator[1].moneybank)
											for k, v in pairs(player.GetAll()) do
												if v:SteamID() == dbSelectTarget[1].SteamID then
													v:SetDString("moneybank", dbSelectTarget[1].moneybank)
													break
												end
											end
											printGM("note", activator:RPName() .. " transfered " .. GetGlobalDString("text_money_pre", "") .. self.money .. GetGlobalDString("text_money_pos", "") .. " to " .. dbSelectTarget[1].rpname)
										end
									end
								end
							end
						else
							printGM("note", "self.money is not a number.")
						end
						self.money = nil
					end
				end
			end

			if status != nil then
				self.parent:SetDString("status", status)
			end
			timer.Simple(0.2, function()
				pressed = false
			end)

			if self.money != nil and isnumber(tonumber(self.money)) then
				if self.money > 0 then
					if activator:canAfford(self.money) then
						activator:addMoneyBank(self.money)
						activator:addMoney(-self.money)
					end
				else
					if activator:canAffordBank(self.money) then
						activator:addMoneyBank(self.money)
						activator:addMoney(-self.money)
					end
				end
			end

			self.parent:ChangeMenu()
		end
	end

	return tmp
end

function ENT:Think()
	if self:GetDString("status") == "home" then
		if !self.menu.home then
			self.menu.home = true

			self.buttons.withdraw = self:createButton(self, 49.74, 7.14, 8.8, "withdraw", nil, nil)
			self.buttons.deposit = self:createButton(self, 48.0, 8.84, 8.8, "deposit", nil, nil)
			self.buttons.transfer = self:createButton(self, 46.36, 10.54, 8.8, "transfer", nil, "ATMPressPrev")
		end
	elseif self:GetDString("status") == "withdraw" then
		if !self.menu.withdraw then
			self.menu.withdraw = true

			self:SetDString("prevstatus", "withdraw")

			self.buttons.withdraw5 = self:createButton(self, 49.74, 7.14, 8.8, nil, -5, nil)
			self.buttons.withdraw10 = self:createButton(self, 48.0, 8.84, 8.8, nil, -10, nil)
			self.buttons.withdraw20 = self:createButton(self, 46.36, 10.54, 8.8, nil, -20, nil)

			self.buttons.withdraw50 = self:createButton(self, 49.74, 7.14, -0.8, nil, -50, nil)
			self.buttons.withdraw100 = self:createButton(self, 48.0, 8.84, -0.8, nil, -100, nil)
			self.buttons.withdraw200 = self:createButton(self, 46.36, 10.54, -0.8, "other", nil, nil)

			self.buttons.withdrawBack = self:createButton(self, 43.48, 13.32, 8.8, "home", nil, nil)
		end
	elseif self:GetDString("status") == "deposit" then
		if !self.menu.deposit then
			self.menu.deposit = true

			self:SetDString("prevstatus", "deposit")

			self.buttons.deposit5 = self:createButton(self, 49.74, 7.14, 8.8, nil, 5, nil)
			self.buttons.deposit10 = self:createButton(self, 48.0, 8.84, 8.8, nil, 10, nil)
			self.buttons.deposit20 = self:createButton(self, 46.36, 10.54, 8.8, nil, 20, nil)

			self.buttons.deposit50 = self:createButton(self, 49.74, 7.14, -0.8, nil, 50, nil)
			self.buttons.deposit100 = self:createButton(self, 48.0, 8.84, -0.8, nil, 100, nil)
			self.buttons.deposit200 = self:createButton(self, 46.36, 10.54, -0.8, "other", nil, nil)

			self.buttons.depositBack = self:createButton(self, 43.48, 13.32, 8.8, "home", nil, nil)
		end
	elseif self:GetDString("status") == "transfer" then
		if !self.menu.transfer then
			self.menu.transfer = true

			self:SetDString("prevstatus", "transfer")

			if self:GetDString("name1") != "nil" then
				self.buttons.transferName1 = self:createButton(self, 49.74, 7.14, 8.8, "other", nil, "ATMPressPlayer1")
			end
			if self:GetDString("name2") != "nil" then
				self.buttons.transferName2 = self:createButton(self, 48.0, 8.84, 8.8, "other", nil, "ATMPressPlayer2")
			end
			self.buttons.transferPrev = self:createButton(self, 46.36, 10.54, 8.8, nil, nil, "ATMPressPrev")

			if self:GetDString("name3") != "nil" then
				self.buttons.transferName3 = self:createButton(self, 49.74, 7.14, -0.8, "other", nil, "ATMPressPlayer3")
			end
			if self:GetDString("name4") != "nil" then
				self.buttons.transferName4 = self:createButton(self, 48.0, 8.84, -0.8, "other", nil, "ATMPressPlayer4")
			end
			self.buttons.transferNext = self:createButton(self, 46.36, 10.54, -0.8, nil, nil, "ATMPressNext")

			self.buttons.transferBack = self:createButton(self, 43.48, 13.32, 8.8, "home", nil, nil)
		end
	elseif self:GetDString("status") == "other" then
		if !self.menu.other then
			self.menu.other = true

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
		if self:GetDString("status") != "startup" and self:GetDString("status") != "logo" then
			if !self.menu.fail then
				self.buttons.failBack = self:createButton(self, 43.48, 13.32, 8.8, "home", nil)
			end
		end
	end
end
