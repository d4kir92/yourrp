--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("getMoneyPrintMenu")

util.AddNetworkString("upgradeCPU")
net.Receive("upgradeCPU", function(len, ply)
	local mp = net.ReadEntity()
	local cost = mp:GetNW2Int("cpuCost")
	if ply:canAfford(cost) and mp:GetNW2Int("cpu") < mp:GetNW2Int("cpuMax") then
		ply:addMoney(-cost)
		mp:SetNW2Int("cpu", mp:GetNW2Int("cpu") + 1)

		mp.delay = CurTime()
	end
end)

util.AddNetworkString("upgradeCooler")
net.Receive("upgradeCooler", function(len, ply)
	local mp = net.ReadEntity()
	local cost = mp:GetNW2Int("coolerCost")
	if ply:canAfford(cost) and mp:GetNW2Int("cooler") < mp:GetNW2Int("coolerMax") then
		ply:addMoney(-cost)
		mp:SetNW2Int("cooler", mp:GetNW2Int("cooler") + 1)

		mp.delay = CurTime()
	end
end)

util.AddNetworkString("upgradePrinter")
net.Receive("upgradePrinter", function(len, ply)
	local mp = net.ReadEntity()
	local cost = mp:GetNW2Int("printerCost")
	if ply:canAfford(cost) and mp:GetNW2Int("printer") < mp:GetNW2Int("printerMax") then
		ply:addMoney(-cost)
		mp:SetNW2Int("printer", mp:GetNW2Int("printer") + 1)
	end
end)

util.AddNetworkString("upgradeStorage")
net.Receive("upgradeStorage", function(len, ply)
	local mp = net.ReadEntity()
	local cost = mp:GetNW2Int("storageCost")
	if ply:canAfford(cost) and mp:GetNW2Int("storage") < mp:GetNW2Int("storageMax") then
		ply:addMoney(-cost)
		mp:SetNW2Int("storage", mp:GetNW2Int("storage") + 1)
		mp:SetNW2Int("moneyMax", mp:GetNW2Int("moneyMax") + 1000)
		mp:SetNW2Int("fuelMax", mp:GetNW2Int("fuelMax") + 10)
	end
end)

util.AddNetworkString("fuelUp")
net.Receive("fuelUp", function(len, ply)
	local mp = net.ReadEntity()
	local cost = mp:GetNW2Int("fuelCost")
	if ply:canAfford(cost) and mp:GetNW2Int("fuel") < mp:GetNW2Int("fuelMax") then
		ply:addMoney(-cost)
		mp:SetNW2Int("fuel", mp:GetNW2Int("fuel") + 10)
		if mp:GetNW2Int("fuel") > mp:GetNW2Int("fuelMax") then
			mp:SetNW2Int("fuel", mp:GetNW2Int("fuelMax"))
		end
	end
end)

util.AddNetworkString("repairMP")
net.Receive("repairMP", function(len, ply)
	local mp = net.ReadEntity()
	local cost = mp:GetNW2Int("hpCost")
	if ply:canAfford(cost) and mp:GetNW2Int("hp") < mp:GetNW2Int("hpMax") then
		ply:addMoney(-cost)
		mp:SetNW2Int("hp", mp:GetNW2Int("hp") + 10)
		if mp:GetNW2Int("hp") > mp:GetNW2Int("hpMax") then
			mp:SetNW2Int("hp", mp:GetNW2Int("hpMax"))
		end
	end
end)

util.AddNetworkString("withdrawMoney")
net.Receive("withdrawMoney", function(len, ply)
	local mp = net.ReadEntity()
	local withdraw = mp:GetNW2Int("money")

	ply:addMoney(withdraw)

	mp:SetNW2Int("money", 0)
end)

util.AddNetworkString("startMoneyPrinter")
net.Receive("startMoneyPrinter", function(len, ply)
	local mp = net.ReadEntity()
	if mp:GetNW2Bool("working") then
		mp:SetNW2Bool("working", false)
	elseif !mp:GetNW2Bool("working") then
		if mp:GetNW2Int("fuel") > 0 then
			mp:SetNW2Bool("working", true)
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

	self:SetNW2String("yrp_use_message", "Open Moneyprinter Settings")

	self:SetNW2Bool("working", false)

	self:SetNW2Int("cpu", 1)
	self:SetNW2Int("cpuMax", 10)
	self:SetNW2Int("cpuCost", 400)

	self:SetNW2Int("cooler", 1)
	self:SetNW2Int("coolerMax", 10)
	self:SetNW2Int("coolerCost", 80)

	self:SetNW2Int("printer", 1)
	self:SetNW2Int("printerMax", 6)
	self:SetNW2Int("printerCost", 100)

	self:SetNW2Int("storage", 1)
	self:SetNW2Int("storageMax", 5)
	self:SetNW2Int("storageCost", 120)

	self:SetNW2Int("fuel", 10)
	self:SetNW2Int("fuelMax", 60)
	self:SetNW2Int("fuelCost", 10)

	self:SetNW2Int("money", 0)
	self:SetNW2Int("moneyMax", 1000)

	self:SetNW2Int("hp", 100)
	self:SetNW2Int("hpMax", 100)
	self:SetNW2Int("hpCost", 20)

	self:SetNW2Float("temp", 0.0)
	self:SetNW2Float("tempMax", 90.0)

	self.tick = CurTime()
	self.delay = CurTime()
	self.countdown = 10 * self:GetNW2Int("cpuMax") + 5 * self:GetNW2Int("coolerMax") + 2
end

function ENT:OnTakeDamage( dmginfo )
	if !self.m_bApplyingDamage then
		self.m_bApplyingDamage = true
		self:SetNW2Int("hp", self:GetNW2Int("hp", 0) - dmginfo:GetDamage())

		if self:GetNW2Int("hp", 0) <= 0 then
			 self:Destroy()
		end
		self.m_bApplyingDamage = false
	end
end

function ENT:Destroy()
	local explosion = ents.Create("env_explosion")
	explosion:SetKeyValue("spawnflags", 144)
	explosion:SetKeyValue("iMagnitude", 15)  -- Damage
	explosion:SetKeyValue("iRadiusOverride", 200) -- Radius
	explosion:SetPos(self:GetPos()) -- inside money printer
	explosion:Spawn()
	explosion:Fire("explode", "", 0)

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
	if self:GetNW2Bool("working") then
		if self:GetNW2Float("temp", 0.0) > 70.0 then
			overheated = true
		else
			overheated = false
		end
		if self:GetNW2Int("cooler", 0) > self:GetNW2Int("cpu", 0) then
			self:SetNW2Float("temp", self:GetNW2Float("temp", 0.0) - 0.1)
			if self:GetNW2Float("temp", 0.0) < 34.0 and heated then
				self:SetNW2Float("temp", 34.0)
			end
		elseif self:GetNW2Int("cooler", 0) + 1 < self:GetNW2Int("cpu", 0) then
			self:SetNW2Float("temp", self:GetNW2Float("temp", 0.0) + 0.2)
		else
			if overheated then
				self:SetNW2Float("temp", self:GetNW2Float("temp", 0.0) - 0.1)
			else
				self:SetNW2Float("temp", self:GetNW2Float("temp", 0.0) + 0.1)
			end
			if self:GetNW2Float("temp", 0.0) > 34.0 then
				heated = true
			end
		end
	else
		self:SetNW2Float("temp", self:GetNW2Float("temp", 0.0) - 0.3)
		heated = false
	end
	if self:GetNW2Float("temp", 0.0) < 0.0 then
		self:SetNW2Float("temp", 0.0)
	end

	-- To much heat, explode
	if self:GetNW2Float("temp", 0.0) > self:GetNW2Float("tempMax", 90.0) then
		self:Destroy()
	end

	if self:GetNW2Int("money") != nil then
		if self:GetNW2Int("fuel") > 0 and self:GetNW2Bool("working") then

			self.workingsound = sound.Add({
				name = "moneyprintersound",
				channel = CHAN_AUTO,
				volume = 1.0 / self:GetNW2Int("cooler"),
				level = 60,
				pitch = { 90, 110 },
				sound = "ambient/machines/combine_terminal_idle1.wav"
			})

			self:EmitSound("moneyprintersound") -- "ambient/machines/combine_terminal_idle1.wav", 75, 100, 1/self:GetNW2Int("cooler"), CHAN_AUTO)

			if CurTime() < self.delay then return end
			local test = self.countdown - self:GetNW2Int("cpu") * 10 - self:GetNW2Int("cooler") * 5
			self.delay = CurTime() + test

			self:SetNW2Int("fuel", self:GetNW2Int("fuel") - 1)
			if self:GetNW2Int("fuel") < 0 then
				self:SetNW2Int("fuel", 0)
			end

			self:SetNW2Int("money", self:GetNW2Int("money") + (10 * self:GetNW2Int("printer")))
			if self:GetNW2Int("money") > self:GetNW2Int("moneyMax") then
				self:SetNW2Int("money", self:GetNW2Int("moneyMax"))
			end
		else
			self:StopSound("moneyprintersound")
			self:SetNW2Bool("working", false)
		end
	end
end

function ENT:OnRemove()
	self:StopSound("moneyprintersound")
	self:SetNW2Bool("working", false)
end
