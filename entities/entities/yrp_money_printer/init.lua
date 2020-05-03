--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("getMoneyPrintMenu")

util.AddNetworkString("upgradeCPU")
net.Receive("upgradeCPU", function(len, ply)
	local mp = net.ReadEntity()
	if mp:GetClass() == "yrp_money_printer" then
		local cost = mp:GetDInt("cpuCost")
		if ply:canAfford(cost) and mp:GetDInt("cpu") < mp:GetDInt("cpuMax") then
			ply:addMoney(-cost)
			mp:SetDInt("cpu", mp:GetDInt("cpu") + 1)

			mp.delay = CurTime()
		end
	end
end)

util.AddNetworkString("upgradeCooler")
net.Receive("upgradeCooler", function(len, ply)
	local mp = net.ReadEntity()
	if mp:GetClass() == "yrp_money_printer" then
		local cost = mp:GetDInt("coolerCost")
		if ply:canAfford(cost) and mp:GetDInt("cooler") < mp:GetDInt("coolerMax") then
			ply:addMoney(-cost)
			mp:SetDInt("cooler", mp:GetDInt("cooler") + 1)

			mp.delay = CurTime()
		end
	end
end)

util.AddNetworkString("upgradePrinter")
net.Receive("upgradePrinter", function(len, ply)
	local mp = net.ReadEntity()
	if mp:GetClass() == "yrp_money_printer" then
		local cost = mp:GetDInt("printerCost")
		if ply:canAfford(cost) and mp:GetDInt("printer") < mp:GetDInt("printerMax") then
			ply:addMoney(-cost)
			mp:SetDInt("printer", mp:GetDInt("printer") + 1)
		end
	end
end)

util.AddNetworkString("upgradeStorage")
net.Receive("upgradeStorage", function(len, ply)
	local mp = net.ReadEntity()
	if mp:GetClass() == "yrp_money_printer" then
		local cost = mp:GetDInt("storageCost")
		if ply:canAfford(cost) and mp:GetDInt("storage") < mp:GetDInt("storageMax") then
			ply:addMoney(-cost)
			mp:SetDInt("storage", mp:GetDInt("storage") + 1)
			mp:SetDInt("moneyMax", mp:GetDInt("moneyMax") + 1000)
			mp:SetDInt("fuelMax", mp:GetDInt("fuelMax") + 10)
		end
	end
end)

util.AddNetworkString("fuelUp")
net.Receive("fuelUp", function(len, ply)
	local mp = net.ReadEntity()
	if mp:GetClass() == "yrp_money_printer" then
		local cost = mp:GetDInt("fuelCost")
		if ply:canAfford(cost) and mp:GetDInt("fuel", 0) < mp:GetDInt("fuelMax", 0) then
			ply:addMoney(-cost)
			mp:SetDInt("fuel", mp:GetDInt("fuel", 0) + 10)
			if mp:GetDInt("fuel", 0) > mp:GetDInt("fuelMax", 0) then
				mp:SetDInt("fuel", mp:GetDInt("fuelMax", 0))
			end
		end
	end
end)

util.AddNetworkString("repairMP")
net.Receive("repairMP", function(len, ply)
	local mp = net.ReadEntity()
	if mp:GetClass() == "yrp_money_printer" then
		local cost = mp:GetDInt("hpCost")
		if ply:canAfford(cost) and mp:GetDInt("hp") < mp:GetDInt("hpMax") then
			ply:addMoney(-cost)
			mp:SetDInt("hp", mp:GetDInt("hp") + 10)
			if mp:GetDInt("hp") > mp:GetDInt("hpMax") then
				mp:SetDInt("hp", mp:GetDInt("hpMax"))
			end
		end
	end
end)

util.AddNetworkString("withdrawMoney")
net.Receive("withdrawMoney", function(len, ply)
	local mp = net.ReadEntity()
	if mp:GetClass() == "yrp_money_printer" then
		local withdraw = mp:GetDInt("money", 0)

		ply:addMoney(withdraw)

		mp:SetDInt("money", 0)
	end
end)

util.AddNetworkString("startMoneyPrinter")
net.Receive("startMoneyPrinter", function(len, ply)
	local mp = net.ReadEntity()
	if mp:GetDBool("working", false) then
		mp:SetDBool("working", false)
	elseif !mp:GetDBool("working") then
		if mp:GetDInt("fuel", 0) > 0 then
			mp:SetDBool("working", true)
		end
	end
end)

function ENT:Initialize()
	self:SetModel("models/props_c17/consolebox01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end

	self:SetDString("yrp_use_message", "Open Moneyprinter Settings")

	self:SetDBool("working", false)

	self:SetDInt("cpu", 1)
	self:SetDInt("cpuMax", 10)
	self:SetDInt("cpuCost", 500)

	self:SetDInt("cooler", 1)
	self:SetDInt("coolerMax", 10)
	self:SetDInt("coolerCost", 300)

	self:SetDInt("printer", 1)
	self:SetDInt("printerMax", 6)
	self:SetDInt("printerCost", 500)

	self:SetDInt("storage", 1)
	self:SetDInt("storageMax", 5)
	self:SetDInt("storageCost", 600)

	self:SetDInt("fuel", 10)
	self:SetDInt("fuelMax", 60)
	self:SetDInt("fuelCost", 50)

	self:SetDInt("money", 0)
	self:SetDInt("moneyMax", 5000)

	self:SetDInt("hp", 100)
	self:SetDInt("hpMax", 100)
	self:SetDInt("hpCost", 600)

	self:SetDFloat("temp", 0.0)
	self:SetDFloat("tempMax", 90.0)

	self.tick = CurTime()
	self.delay = CurTime()
	self.countdown = 10 * self:GetDInt("cpuMax") + 5 * self:GetDInt("coolerMax") + 2
end

function ENT:OnTakeDamage( dmginfo )
	if !self.m_bApplyingDamage then
		self.m_bApplyingDamage = true
		self:SetDInt("hp", self:GetDInt("hp", 0) - dmginfo:GetDamage())

		if self:GetDInt("hp", 0) <= 0 then
			 self:Destroy()
		end
		self.m_bApplyingDamage = false
	end
end

function ENT:Destroy()
	local explosion = ents.Create("env_explosion")
	if wk(explosion) then
		explosion:SetKeyValue("spawnflags", 144)
		explosion:SetKeyValue("iMagnitude", 15)  -- Damage
		explosion:SetKeyValue("iRadiusOverride", 200) -- Radius
		explosion:SetPos(self:GetPos()) -- inside money printer
		explosion:Spawn()
		explosion:Fire("explode", "", 0)
	end

	self:Remove()
end

function ENT:Use(activator, caller)
	net.Start("getMoneyPrintMenu")
		net.WriteEntity(self)
	net.Send(caller)
end

local heated = false
local overheated = false
function ENT:Think()
	if CurTime() < self.tick then return end
	self.tick = CurTime() + 0.1
	if self:GetDBool("working") then
		if self:GetDFloat("temp", 0.0) > 70.0 then
			overheated = true
		else
			overheated = false
		end
		if self:GetDInt("cooler", 0) > self:GetDInt("cpu", 0) then
			self:SetDFloat("temp", self:GetDFloat("temp", 0.0) - 0.1)
			if self:GetDFloat("temp", 0.0) < 34.0 and heated then
				self:SetDFloat("temp", 34.0)
			end
		elseif self:GetDInt("cooler", 0) + 1 < self:GetDInt("cpu", 0) then
			self:SetDFloat("temp", self:GetDFloat("temp", 0.0) + 0.2)
		else
			if overheated then
				self:SetDFloat("temp", self:GetDFloat("temp", 0.0) - 0.1)
			else
				self:SetDFloat("temp", self:GetDFloat("temp", 0.0) + 0.1)
			end
			if self:GetDFloat("temp", 0.0) > 34.0 then
				heated = true
			end
		end
	else
		self:SetDFloat("temp", self:GetDFloat("temp", 0.0) - 0.3)
		heated = false
	end
	if self:GetDFloat("temp", 0.0) < 0.0 then
		self:SetDFloat("temp", 0.0)
	end

	-- To much heat, explode
	if self:GetDFloat("temp", 0.0) > self:GetDFloat("tempMax", 90.0) then
		self:Destroy()
	end

	if self:GetDInt("money") != nil then
		if self:GetDInt("fuel", 0) > 0 and self:GetDBool("working") then

			self.workingsound = sound.Add({
				name = "moneyprintersound",
				channel = CHAN_AUTO,
				volume = 1.0 / self:GetDInt("cooler"),
				level = 60,
				pitch = { 90, 110 },
				sound = "ambient/machines/combine_terminal_idle1.wav"
			})

			self:EmitSound("moneyprintersound") -- "ambient/machines/combine_terminal_idle1.wav", 75, 100, 1/self:GetDInt("cooler"), CHAN_AUTO)

			if CurTime() < self.delay then return end
			local test = self.countdown - self:GetDInt("cpu") * 10 - self:GetDInt("cooler") * 5
			self.delay = CurTime() + test

			self:SetDInt("fuel", self:GetDInt("fuel") - 1)
			if self:GetDInt("fuel", 0) < 0 then
				self:SetDInt("fuel", 0)
			end

			self:SetDInt("money", self:GetDInt("money") + (30 * self:GetDInt("printer")))
			if self:GetDInt("money") > self:GetDInt("moneyMax") then
				self:SetDInt("money", self:GetDInt("moneyMax"))
			end

			if GetGlobalDBool("bool_money_printer_spawn_money", false) and self:GetDInt("money", 0) > 0 then
				local m = self:GetDInt("money", 0)
				local ent_m = ents.Create("yrp_money")
				ent_m:SetMoney(m)
				ent_m:SetPos(self:GetPos() + Vector(0, 0, 30))
				ent_m:Spawn()

				self:SetDInt("money", 0)
			end
		else
			self:StopSound("moneyprintersound")
			self:SetDBool("working", false)
		end
	end
end

function ENT:OnRemove()
	self:StopSound("moneyprintersound")
	self:SetDBool("working", false)
end
