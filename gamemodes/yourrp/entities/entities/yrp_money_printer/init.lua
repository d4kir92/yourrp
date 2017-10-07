--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

util.AddNetworkString( "getMoneyPrintMenu" )

util.AddNetworkString( "upgradeCPU" )
net.Receive( "upgradeCPU", function( len, ply )
	local mp = net.ReadEntity()
	local cost = mp:GetNWInt( "cpuCost" )
	if ply:canAfford( cost ) and mp:GetNWInt( "cpu" ) < mp:GetNWInt( "cpuMax" ) then
		ply:addMoney( -cost )
		mp:SetNWInt( "cpu", mp:GetNWInt( "cpu" ) + 1 )

		mp.delay = CurTime()
	end
end)

util.AddNetworkString( "upgradeCooler" )
net.Receive( "upgradeCooler", function( len, ply )
	local mp = net.ReadEntity()
	local cost = mp:GetNWInt( "cooler" ) * mp:GetNWInt( "coolerCost" )
	if ply:canAfford( cost ) and mp:GetNWInt( "cooler" ) < mp:GetNWInt( "coolerMax" ) then
		ply:addMoney( -cost )
		mp:SetNWInt( "cooler", mp:GetNWInt( "cooler" ) + 1 )

		mp.delay = CurTime()
	end
end)

util.AddNetworkString( "upgradePrinter" )
net.Receive( "upgradePrinter", function( len, ply )
	local mp = net.ReadEntity()
	local cost = mp:GetNWInt( "printerCost" )
	if ply:canAfford( cost ) and mp:GetNWInt( "printer" ) < mp:GetNWInt( "printerMax" ) then
		ply:addMoney( -cost )
		mp:SetNWInt( "printer", mp:GetNWInt( "printer" ) + 1 )
	end
end)

util.AddNetworkString( "upgradeStorage" )
net.Receive( "upgradeStorage", function( len, ply )
	local mp = net.ReadEntity()
	local cost = mp:GetNWInt( "storageCost" )
	if ply:canAfford( cost ) and mp:GetNWInt( "storage" ) < mp:GetNWInt( "storageMax" ) then
		ply:addMoney( -cost )
		mp:SetNWInt( "storage", mp:GetNWInt( "storage" ) + 1 )
		mp:SetNWInt( "moneyMax", mp:GetNWInt( "moneyMax" ) + 1000 )
		mp:SetNWInt( "fuelMax", mp:GetNWInt( "fuelMax" ) + 10 )
	end
end)

util.AddNetworkString( "fuelUp" )
net.Receive( "fuelUp", function( len, ply )
	local mp = net.ReadEntity()
	local cost = mp:GetNWInt( "fuelCost" )
	if ply:canAfford( cost ) and mp:GetNWInt( "fuel" ) < mp:GetNWInt( "fuelMax" ) then
		ply:addMoney( -cost )
		mp:SetNWInt( "fuel", mp:GetNWInt( "fuel" ) + 10 )
		if mp:GetNWInt( "fuel" ) > mp:GetNWInt( "fuelMax" ) then
			mp:SetNWInt( "fuel", mp:GetNWInt( "fuelMax" ) )
		end
	end
end)

util.AddNetworkString( "withdrawMoney" )
net.Receive( "withdrawMoney", function( len, ply )
	local mp = net.ReadEntity()
	local withdraw = mp:GetNWInt( "money" )

	ply:addMoney( withdraw )

	mp:SetNWInt( "money", 0 )
end)

util.AddNetworkString( "startMoneyPrinter" )
net.Receive( "startMoneyPrinter", function( len, ply )
	local mp = net.ReadEntity()
	if mp:GetNWBool( "working" ) then
		mp:SetNWBool( "working", false )
	elseif !mp:GetNWBool( "working" ) then
		if mp:GetNWInt( "fuel" ) > 0 then
			mp:SetNWBool( "working", true )
		end
	end
end)

function ENT:Initialize()
	self:SetModel( "models/props_c17/consolebox01a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

  local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end

	self:SetNWBool( "working", false )

	self:SetNWInt( "cpu", 1 )
	self:SetNWInt( "cpuMax", 10 )
	self:SetNWInt( "cpuCost", 400 )

	self:SetNWInt( "cooler", 1 )
	self:SetNWInt( "coolerMax", 4 )
	self:SetNWInt( "coolerCost", 80 )

	self:SetNWInt( "printer", 1 )
	self:SetNWInt( "printerMax", 6 )
	self:SetNWInt( "printerCost", 100 )

	self:SetNWInt( "storage", 1 )
	self:SetNWInt( "storageMax", 5 )
	self:SetNWInt( "storageCost", 120 )

	self:SetNWInt( "fuel", 10 )
	self:SetNWInt( "fuelMax", 60 )
	self:SetNWInt( "fuelCost", 10 )

	self:SetNWInt( "money", 0 )
	self:SetNWInt( "moneyMax", 1000 )

	self.delay = CurTime()
	self.countdown = 10*self:GetNWInt( "cpuMax" ) + 5*self:GetNWInt( "coolerMax" ) + 2
end

function ENT:Use( activator, caller )
	net.Start( "getMoneyPrintMenu" )
		net.WriteEntity( self )
	net.Send( caller )
end

function ENT:Think()
	if self:GetNWInt( "money" ) != nil then
		if self:GetNWInt( "fuel" ) > 0 and self:GetNWBool( "working" ) then

			self.workingsound = sound.Add( {
				name = "moneyprintersound",
				channel = CHAN_AUTO,
				volume = 1.0/self:GetNWInt( "cooler" ),
				level = 100,
				pitch = { 90, 110 },
				sound = "ambient/machines/combine_terminal_idle1.wav"
			} )

			self:EmitSound( "moneyprintersound" ) -- "ambient/machines/combine_terminal_idle1.wav", 75, 100, 1/self:GetNWInt( "cooler" ), CHAN_AUTO )

			if CurTime() < self.delay then return end
			local test = self.countdown - self:GetNWInt( "cpu" )*10 - self:GetNWInt( "cooler" )*5
			self.delay = CurTime() + test

			self:SetNWInt( "fuel", self:GetNWInt( "fuel" ) - 1 )
			if self:GetNWInt( "fuel" ) < 0 then
				self:SetNWInt( "fuel", 0 )
			end

			self:SetNWInt( "money", self:GetNWInt( "money" ) + ( 10 * self:GetNWInt( "printer" ) ) )
			if self:GetNWInt( "money" ) > self:GetNWInt( "moneyMax" ) then
				self:SetNWInt( "money", self:GetNWInt( "moneyMax" ) )
			end
		else
			self:StopSound( "moneyprintersound" )
			self:SetNWBool( "working", false )
		end
	end
end

function ENT:OnRemove()
  self:StopSound( "moneyprintersound" )
	self:SetNWBool( "working", false )
end
