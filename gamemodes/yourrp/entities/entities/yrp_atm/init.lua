--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

util.AddNetworkString( "ATMPressPrev" )
util.AddNetworkString( "ATMPressNext" )

local ent = nil

function ENT:Initialize()
	self:SetModel( "models/yrp/yrp_atm.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )

  local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end

	self:SetNWString( "status", "startup" )
	timer.Simple( 4, function()
		self:SetNWString( "status", "logo" )
		timer.Simple( 3, function()
			self:SetNWString( "status", "home" )
		end)
	end)

	self.pressed = false

	self.menu = {}
	self.menu.home = false
	self.menu.withdraw = false

	self.buttons = {}

	self.namePos = 1

	self:SetNWString( "prevstatus", "" )

	ent = self
end

function ENT:OnRemove()
	if self.withdraw != nil then
  	self.withdraw:Remove()
	end
end

function ENT:Use( activator, caller )
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

	for k, v in pairs( self.buttons ) do
		if v != nil and v != NULL then
			v:Remove()
		end
	end
end

function ENT:ATMPressPrev( ply )
	local _tmpPlayers = dbSelect( "yrp_characters", "*", nil )
	self.namePos = self.namePos - 4
	if self.namePos < 1 then
		self.namePos = 1
	end
	local names = {}
	local SteamIDs = {}
	local i = 1
	self.names = {}
	self.SteamIDs = {}
	for k, v in pairs( _tmpPlayers ) do
		if k >= self.namePos then
			if v.rpname != nil and v.rpname != NULL then
				names[i] = v.rpname
				SteamIDs[i] = v.uniqueID
			else
				names[i] = ""
				SteamIDs[i] = ""
			end
			i = i + 1
			if self.namePos > self.namePos+4 then
				break
			end
		end
	end
	self:SetNWString( "name1", tostring(names[1]) )
	self:SetNWString( "SteamID1", tostring(SteamIDs[1]) )
	self:SetNWString( "name2", tostring(names[2]) )
	self:SetNWString( "SteamID2", tostring(SteamIDs[2]) )
	self:SetNWString( "name3", tostring(names[3]) )
	self:SetNWString( "SteamID3", tostring(SteamIDs[3]) )
	self:SetNWString( "name4", tostring(names[4]) )
	self:SetNWString( "SteamID4", tostring(SteamIDs[4]) )
end

function ENT:ATMPressNext( ply )
	local _tmpPlayers = dbSelect( "yrp_players", "*", nil )
	self.namePos = self.namePos + 4
	local names = {}
	local SteamIDs = {}
	local i = 1
	self.names = {}
	self.SteamIDs = {}
	for k, v in pairs( _tmpPlayers ) do
		if k >= self.namePos then
			if v.rpname != nil and v.rpname != NULL then
				names[i] = v.rpname
				SteamIDs[i] = v.uniqueID
			else
				names[i] = ""
				SteamIDs[i] = ""
			end
			i = i + 1
			if self.namePos > self.namePos+4 then
				break
			end
		end
	end
	self:SetNWString( "name1", tostring(names[1]) )
	self:SetNWString( "SteamID1", tostring(SteamIDs[1]) )
	self:SetNWString( "name2", tostring(names[2]) )
	self:SetNWString( "SteamID2", tostring(SteamIDs[2]) )
	self:SetNWString( "name3", tostring(names[3]) )
	self:SetNWString( "SteamID3", tostring(SteamIDs[3]) )
	self:SetNWString( "name4", tostring(names[4]) )
	self:SetNWString( "SteamID4", tostring(SteamIDs[4]) )
end

function ENT:createButtonNumber( parent, up, forward, right, add )
	local tmp = ents.Create( "yrp_button2" )
	tmp:SetPos( parent:GetPos() + parent:GetUp() * up + parent:GetForward() * forward + parent:GetRight() * (right-4) )
	tmp:SetAngles( parent:GetAngles() + Angle( 45, 0, 0 ) )
	tmp:SetParent( parent )
	tmp:Spawn()
	tmp:SetColor( Color( 255, 0, 0, 0 ) )
	tmp:SetRenderMode( RENDERMODE_TRANSALPHA )
	tmp.parent = parent

	function tmp:Use( activator, caller, useType, value )
		if !pressed then
			pressed = true
			if add != "<" then
				tmp.parent:SetNWString( "othermoney", tmp.parent:GetNWString( "othermoney", "" ) .. add )
			else
				local stringExp = string.sub( tmp.parent:GetNWString( "othermoney" ), 1, string.len( tmp.parent:GetNWString( "othermoney" ) ) - 1 )
				tmp.parent:SetNWString( "othermoney", stringExp )
			end
			timer.Simple( 0.2, function()
				pressed = false
			end)
		end
	end

	return tmp
end

function ENT:createButton( parent, up, forward, right, status, _money, func )
	local tmp = ents.Create( "yrp_button" )
	tmp:SetPos( parent:GetPos() + parent:GetUp() * up + parent:GetForward() * forward + parent:GetRight() * (right-4) )
	tmp:SetAngles( parent:GetAngles() + Angle( 45, 0, 0 ) )
	tmp:SetParent( parent )
	tmp:Spawn()
	tmp:SetColor( Color( 255, 0, 0, 0 ) )
	tmp:SetRenderMode( RENDERMODE_TRANSALPHA )
	tmp.parent = parent
	tmp.money = tonumber( _money )

	function tmp:Use( activator, caller, useType, value )
		if !pressed then
			pressed = true

			if func != nil then
				if func == "ATMPressNext" then
					self.parent:ATMPressNext( activator )
				elseif func == "ATMPressPrev" then
					self.parent:ATMPressPrev( activator )
				elseif func == "ATMPressPlayer1" then
					self.parent:SetNWString( "name", self.parent:GetNWString( "name1" ))
					self.parent:SetNWString( "SteamID64", self.parent:GetNWString( "SteamID1" ) )
				elseif func == "ATMPressPlayer2" then
					self.parent:SetNWString( "name", self.parent:GetNWString( "name2" ))
					self.parent:SetNWString( "SteamID64", self.parent:GetNWString( "SteamID2" ) )
				elseif func == "ATMPressPlayer3" then
					self.parent:SetNWString( "name", self.parent:GetNWString( "name3" ))
					self.parent:SetNWString( "SteamID64", self.parent:GetNWString( "SteamID3" ) )
				elseif func == "ATMPressPlayer4" then
					self.parent:SetNWString( "name", self.parent:GetNWString( "name4" ))
					self.parent:SetNWString( "SteamID64", self.parent:GetNWString( "SteamID4" ) )
				elseif func == "confirm" then
					if self.parent:GetNWString( "prevstatus" ) == "withdraw" then
						self.money = -tonumber( self.parent:GetNWString( "othermoney", "0" ) )
					elseif self.parent:GetNWString( "prevstatus" ) == "deposit" then
						self.money = tonumber( self.parent:GetNWString( "othermoney", "0" ) )
					elseif self.parent:GetNWString( "prevstatus" ) == "transfer" then
						self.money = tonumber( self.parent:GetNWString( "othermoney", "0" ) )

						if self.money != nil and isnumber( self.money ) then
							if self.money > 0 then
								if activator:canAffordBank( self.money ) then
									local dbSelectActivator = dbSelect( "yrp_characters", "*", "uniqueID = " .. activator:CharID() )
									dbSelectActivator[1].moneybank = dbSelectActivator[1].moneybank-self.money
									dbUpdate( "yrp_characters", "moneybank = " .. dbSelectActivator[1].moneybank, "uniqueID = " .. activator:CharID() )

									local dbSelectTarget = dbSelect( "yrp_characters", "*", "uniqueID = " .. tostring( self.parent:GetNWString( "SteamID64" ) ) )
									if dbSelectTarget != nil then
										dbSelectTarget[1].moneybank = dbSelectTarget[1].moneybank+self.money
										dbUpdate( "yrp_characters", "moneybank = " .. dbSelectTarget[1].moneybank, "uniqueID = '" .. self.parent:GetNWString( "SteamID64" ) .. "'")

										activator:SetNWInt( "moneybank", dbSelectActivator[1].moneybank )
										for k, v in pairs( player.GetAll() ) do
											if v:SteamID64() == dbSelectTarget[1].SteamID64 then
												v:SetNWInt( "moneybank", dbSelectTarget[1].moneybank )
												break
											end
										end
										printGM( "note", activator:RPName() .. " transfered " .. activator:GetNWString( "moneyPre" ) .. self.money .. activator:GetNWString( "moneyPost" ) .. " to " .. dbSelectTarget[1].rpname )
									end
								end
							end
						else
							printGM( "note", "self.money is not a number." )
						end
						self.money = nil
					end
				end
			end

			if status != nil then
				self.parent:SetNWString( "status", status )
			end
			timer.Simple( 0.2, function()
				pressed = false
			end)

			if self.money != nil and isnumber( self.money ) then
				if self.money > 0 then
					if activator:canAfford( self.money ) then
						activator:addMoneyBank( self.money )
						activator:addMoney( -self.money )
					end
				else
					if activator:canAffordBank( self.money ) then
						activator:addMoneyBank( self.money )
						activator:addMoney( -self.money )
					end
				end
			end

			self.parent:ChangeMenu()
		end
	end

	return tmp
end

function ENT:Think()
	if self:GetNWString( "status" ) == "home" then
		if !self.menu.home then
			self.menu.home = true

			self.buttons.withdraw = self:createButton( self, 49.74, 7.14, 8.8, "withdraw", nil, nil )
			self.buttons.deposit = self:createButton( self, 48.0, 8.84, 8.8, "deposit", nil, nil )
			self.buttons.transfer = self:createButton( self, 46.36, 10.54, 8.8, "transfer", nil, "ATMPressPrev" )
		end
	elseif self:GetNWString( "status" ) == "withdraw" then
		if !self.menu.withdraw then
			self.menu.withdraw = true

			self:SetNWString( "prevstatus", "withdraw" )

			self.buttons.withdraw5 = self:createButton( self, 49.74, 7.14, 8.8, nil, -5, nil )
			self.buttons.withdraw10 = self:createButton( self, 48.0, 8.84, 8.8, nil, -10, nil )
			self.buttons.withdraw20 = self:createButton( self, 46.36, 10.54, 8.8, nil, -20, nil )

			self.buttons.withdraw50 = self:createButton( self, 49.74, 7.14, -0.8, nil, -50, nil )
			self.buttons.withdraw100 = self:createButton( self, 48.0, 8.84, -0.8, nil, -100, nil )
			self.buttons.withdraw200 = self:createButton( self, 46.36, 10.54, -0.8, "other", nil, nil )

			self.buttons.withdrawBack = self:createButton( self, 43.48, 13.32, 8.8, "home", nil, nil )
		end
	elseif self:GetNWString( "status" ) == "deposit" then
		if !self.menu.deposit then
			self.menu.deposit = true

			self:SetNWString( "prevstatus", "deposit" )

			self.buttons.deposit5 = self:createButton( self, 49.74, 7.14, 8.8, nil, 5, nil )
			self.buttons.deposit10 = self:createButton( self, 48.0, 8.84, 8.8, nil, 10, nil )
			self.buttons.deposit20 = self:createButton( self, 46.36, 10.54, 8.8, nil, 20, nil )

			self.buttons.deposit50 = self:createButton( self, 49.74, 7.14, -0.8, nil, 50, nil )
			self.buttons.deposit100 = self:createButton( self, 48.0, 8.84, -0.8, nil, 100, nil )
			self.buttons.deposit200 = self:createButton( self, 46.36, 10.54, -0.8, "other", nil, nil )

			self.buttons.depositBack = self:createButton( self, 43.48, 13.32, 8.8, "home", nil, nil )
		end
	elseif self:GetNWString( "status" ) == "transfer" then
		if !self.menu.transfer then
			self.menu.transfer = true

			self:SetNWString( "prevstatus", "transfer" )

			if self:GetNWString( "name1" ) != "nil" then
				self.buttons.transferName1 = self:createButton( self, 49.74, 7.14, 8.8, "other", nil, "ATMPressPlayer1" )
			end
			if self:GetNWString( "name2" ) != "nil" then
				self.buttons.transferName2 = self:createButton( self, 48.0, 8.84, 8.8, "other", nil, "ATMPressPlayer2" )
			end
			self.buttons.transferPrev = self:createButton( self, 46.36, 10.54, 8.8, nil, nil, "ATMPressPrev" )

			if self:GetNWString( "name3" ) != "nil" then
				self.buttons.transferName3 = self:createButton( self, 49.74, 7.14, -0.8, "other", nil, "ATMPressPlayer3" )
			end
			if self:GetNWString( "name4" ) != "nil" then
				self.buttons.transferName4 = self:createButton( self, 48.0, 8.84, -0.8, "other", nil, "ATMPressPlayer4" )
			end
			self.buttons.transferNext = self:createButton( self, 46.36, 10.54, -0.8, nil, nil, "ATMPressNext" )

			self.buttons.transferBack = self:createButton( self, 43.48, 13.32, 8.8, "home", nil, nil )
		end
	elseif self:GetNWString( "status" ) == "other" then
		if !self.menu.other then
			self.menu.other = true

			self.buttons.remove = self:createButtonNumber( self, 50.5, 6.7, -0.8, "<" )

			self.buttons.add1 = self:createButtonNumber( self, 48.8, 8.4, 6.4, "1" )
			self.buttons.add2 = self:createButtonNumber( self, 48.8, 8.4, 4.0, "2" )
			self.buttons.add3 = self:createButtonNumber( self, 48.8, 8.4, 1.6, "3" )
			self.buttons.add4 = self:createButtonNumber( self, 47.1, 10.1, 6.4, "4" )
			self.buttons.add5 = self:createButtonNumber( self, 47.1, 10.1, 4.0, "5" )
			self.buttons.add6 = self:createButtonNumber( self, 47.1, 10.1, 1.6, "6" )
			self.buttons.add7 = self:createButtonNumber( self, 45.5, 11.8, 6.4, "7" )
			self.buttons.add8 = self:createButtonNumber( self, 45.5, 11.8, 4.0, "8" )
			self.buttons.add9 = self:createButtonNumber( self, 45.5, 11.8, 1.6, "9" )
			self.buttons.add0 = self:createButtonNumber( self, 45.5, 11.8, -0.8, "0" )

			self.buttons.confirm = self:createButton( self, 43.48, 13.32, -0.8, "home", nil, "confirm" )

			self.buttons.otherBack = self:createButton( self, 43.48, 13.32, 8.8, "home", nil, nil )
		end
	else
		if self:GetNWString( "status" ) != "startup" and self:GetNWString( "status" ) != "logo" then
			if !self.menu.fail then
				self.buttons.failBack = self:createButton( self, 43.48, 13.32, 8.8, "home", nil )
			end
		end
	end
end
