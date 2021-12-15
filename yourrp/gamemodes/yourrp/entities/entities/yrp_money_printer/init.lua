--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

util.AddNetworkString( "getMoneyPrintMenu" )

util.AddNetworkString( "upgradeCPU" )
net.Receive( "upgradeCPU", function(len, ply)
	local mp = net.ReadEntity()
	if mp:GetClass() == "yrp_money_printer" then
		local cost = mp:GetNW2Int( "cpuCost" )
		if ply:canAfford( cost) and mp:GetNW2Int( "cpu" ) < mp:GetNW2Int( "cpuMax" ) then
			ply:addMoney(-cost)
			mp:SetNW2Int( "cpu", mp:GetNW2Int( "cpu" ) + 1)

			mp.delay = CurTime()
		end
	end
end)

util.AddNetworkString( "upgradeCooler" )
net.Receive( "upgradeCooler", function(len, ply)
	local mp = net.ReadEntity()
	if mp:GetClass() == "yrp_money_printer" then
		local cost = mp:GetNW2Int( "coolerCost" )
		if ply:canAfford( cost) and mp:GetNW2Int( "cooler" ) < mp:GetNW2Int( "coolerMax" ) then
			ply:addMoney(-cost)
			mp:SetNW2Int( "cooler", mp:GetNW2Int( "cooler" ) + 1)

			mp.delay = CurTime()
		end
	end
end)

util.AddNetworkString( "upgradePrinter" )
net.Receive( "upgradePrinter", function(len, ply)
	local mp = net.ReadEntity()
	if mp:GetClass() == "yrp_money_printer" then
		local cost = mp:GetNW2Int( "printerCost" )
		if ply:canAfford( cost) and mp:GetNW2Int( "printer" ) < mp:GetNW2Int( "printerMax" ) then
			ply:addMoney(-cost)
			mp:SetNW2Int( "printer", mp:GetNW2Int( "printer" ) + 1)
		end
	end
end)

util.AddNetworkString( "upgradeStorage" )
net.Receive( "upgradeStorage", function(len, ply)
	local mp = net.ReadEntity()
	if mp:GetClass() == "yrp_money_printer" then
		local cost = mp:GetNW2Int( "storageCost" )
		if ply:canAfford( cost) and mp:GetNW2Int( "storage" ) < mp:GetNW2Int( "storageMax" ) then
			ply:addMoney(-cost)
			mp:SetNW2Int( "storage", mp:GetNW2Int( "storage" ) + 1)
			mp:SetNW2Int( "moneyMax", mp:GetNW2Int( "moneyMax" ) + 1000)
			mp:SetNW2Int( "fuelMax", mp:GetNW2Int( "fuelMax" ) + 10)
		end
	end
end)

util.AddNetworkString( "fuelUp" )
net.Receive( "fuelUp", function(len, ply)
	local mp = net.ReadEntity()
	if mp:GetClass() == "yrp_money_printer" then
		local cost = mp:GetNW2Int( "fuelCost" )
		if ply:canAfford( cost) and mp:GetNW2Int( "fuel", 0) < mp:GetNW2Int( "fuelMax", 0) then
			ply:addMoney(-cost)
			mp:SetNW2Int( "fuel", mp:GetNW2Int( "fuel", 0) + 10)
			if mp:GetNW2Int( "fuel", 0) > mp:GetNW2Int( "fuelMax", 0) then
				mp:SetNW2Int( "fuel", mp:GetNW2Int( "fuelMax", 0) )
			end
		end
	end
end)

util.AddNetworkString( "repairMP" )
net.Receive( "repairMP", function(len, ply)
	local mp = net.ReadEntity()
	if mp:GetClass() == "yrp_money_printer" then
		local cost = mp:GetNW2Int( "hpCost" )
		if ply:canAfford( cost) and mp:GetNW2Int( "hp" ) < mp:GetNW2Int( "hpMax" ) then
			ply:addMoney(-cost)
			mp:SetNW2Int( "hp", mp:GetNW2Int( "hp" ) + 10)
			if mp:GetNW2Int( "hp" ) > mp:GetNW2Int( "hpMax" ) then
				mp:SetNW2Int( "hp", mp:GetNW2Int( "hpMax" ) )
			end
		end
	end
end)

util.AddNetworkString( "withdrawMoney" )
net.Receive( "withdrawMoney", function(len, ply)
	local mp = net.ReadEntity()
	if mp:GetClass() == "yrp_money_printer" then
		local withdraw = mp:GetNW2Int( "money", 0)

		ply:addMoney(withdraw)

		mp:SetNW2Int( "money", 0)
	end
end)

util.AddNetworkString( "startMoneyPrinter" )
net.Receive( "startMoneyPrinter", function(len, ply)
	local mp = net.ReadEntity()
	if mp:GetNW2Bool( "working", false) then
		mp:SetNW2Bool( "working", false)
	elseif !mp:GetNW2Bool( "working" ) then
		if mp:GetNW2Int( "fuel", 0) > 0 then
			mp:SetNW2Bool( "working", true)
		end
	end
end)

function ENT:Initialize()
	self:SetModel( "models/props_c17/consolebox01a.mdl" )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if (phys:IsValid() ) then
		phys:Wake()
	end

	self:SetNW2String( "yrp_use_message", "Open Moneyprinter Settings" )

	self:SetNW2Bool( "working", false)

	self:SetNW2Int( "cpu", 1)
	self:SetNW2Int( "cpuMax", 10)
	self:SetNW2Int( "cpuCost", 500)

	self:SetNW2Int( "cooler", 1)
	self:SetNW2Int( "coolerMax", 10)
	self:SetNW2Int( "coolerCost", 300)

	self:SetNW2Int( "printer", 1)
	self:SetNW2Int( "printerMax", 6)
	self:SetNW2Int( "printerCost", 500)

	self:SetNW2Int( "storage", 1)
	self:SetNW2Int( "storageMax", 5)
	self:SetNW2Int( "storageCost", 600)

	self:SetNW2Int( "fuel", 10)
	self:SetNW2Int( "fuelMax", 60)
	self:SetNW2Int( "fuelCost", 50)

	self:SetNW2Int( "money", 0)
	self:SetNW2Int( "moneyMax", 5000)

	self:SetNW2Int( "hp", 100)
	self:SetNW2Int( "hpMax", 100)
	self:SetNW2Int( "hpCost", 600)

	self:SetNW2Float( "temp", 0.0)
	self:SetNW2Float( "tempMax", 90.0)

	self.tick = CurTime()
	self.delay = CurTime()
	self.countdown = 10 * self:GetNW2Int( "cpuMax" ) + 5 * self:GetNW2Int( "coolerMax" ) + 2
end

function ENT:OnTakeDamage( dmginfo )
	if !self.m_bApplyingDamage then
		self.m_bApplyingDamage = true
		self:SetNW2Int( "hp", self:GetNW2Int( "hp", 0) - dmginfo:GetDamage() )

		if self:GetNW2Int( "hp", 0) <= 0 then
			 self:Destroy()
		end
		self.m_bApplyingDamage = false
	end
end

function ENT:Destroy()
	local explosion = ents.Create( "env_explosion" )
	if wk(explosion) then
		explosion:SetKeyValue( "spawnflags", 144)
		explosion:SetKeyValue( "iMagnitude", 15)  -- Damage
		explosion:SetKeyValue( "iRadiusOverride", 200) -- Radius
		explosion:SetPos(self:GetPos() ) -- inside money printer
		explosion:Spawn()
		explosion:Fire( "explode", "", 0)
	end

	self:Remove()
end

function ENT:Use( activator, caller)
	net.Start( "getMoneyPrintMenu" )
		net.WriteEntity(self)
	net.Send( caller)
end

local heated = false
local overheated = false
function ENT:Think()
	if CurTime() < self.tick then return end
	self.tick = CurTime() + 1

	local temp = self:GetNW2Float( "temp", 0.0)
	if self:GetNW2Bool( "working" ) then
		if temp > 70.0 then
			overheated = true
		else
			overheated = false
		end
		if self:GetNW2Int( "cooler", 0) > self:GetNW2Int( "cpu", 0) then
			temp = temp - 1
			if temp < 34.0 and heated then
				temp = 34.0
			end
		elseif self:GetNW2Int( "cooler", 0) + 1 < self:GetNW2Int( "cpu", 0) then
			temp = temp + 2
		else
			if overheated then
				temp = temp - 1
			else
				temp = temp + 1
			end
			if temp > 34.0 then
				heated = true
			end
		end
	else
		temp = temp - 0.3
		heated = false
	end
	if temp < 0.0 then
		temp = 0.0
	end
	self:SetNW2Float( "temp", temp)

	-- To much heat, explode
	if self:GetNW2Float( "temp", 0.0) > self:GetNW2Float( "tempMax", 90.0) then
		self:Destroy()
	end

	if self:GetNW2Int( "money" ) != nil then
		if self:GetNW2Int( "fuel", 0) > 0 and self:GetNW2Bool( "working" ) then

			self.workingsound = sound.Add({
				name = "moneyprintersound",
				channel = CHAN_AUTO,
				volume = 1.0 / self:GetNW2Int( "cooler" ),
				level = 60,
				pitch = { 90, 110 },
				sound = "ambient/machines/combine_terminal_idle1.wav"
			})
			
			self:EmitSound( "moneyprintersound" ) -- "ambient/machines/combine_terminal_idle1.wav", 75, 100, 1/self:GetNW2Int( "cooler" ), CHAN_AUTO)

			if CurTime() < self.delay then return end
			local test = self.countdown - self:GetNW2Int( "cpu" ) * 10 - self:GetNW2Int( "cooler" ) * 5
			self.delay = CurTime() + test

			self:SetNW2Int( "fuel", self:GetNW2Int( "fuel" ) - 1)
			if self:GetNW2Int( "fuel", 0) < 0 then
				self:SetNW2Int( "fuel", 0)
			end

			self:SetNW2Int( "money", self:GetNW2Int( "money" ) + (30 * self:GetNW2Int( "printer" ) ))
			if self:GetNW2Int( "money" ) > self:GetNW2Int( "moneyMax" ) then
				self:SetNW2Int( "money", self:GetNW2Int( "moneyMax" ) )
			end

			if GetGlobalBool( "bool_money_printer_spawn_money", false) and self:GetNW2Int( "money", 0) > 0 then
				local m = self:GetNW2Int( "money", 0)
				local ent_m = ents.Create( "yrp_money" )
				ent_m:SetMoney(m)
				ent_m:SetPos(self:GetPos() + Vector(0, 0, 30) )
				ent_m:Spawn()

				self:SetNW2Int( "money", 0)
			end
		else
			self:StopSound( "moneyprintersound" )
			self:SetNW2Bool( "working", false)
		end
	end
end

function ENT:OnRemove()
	self:StopSound( "moneyprintersound" )
	self:SetNW2Bool( "working", false)
end


