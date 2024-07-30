--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
YRP:AddNetworkString("nws_yrp_getMoneyPrintMenu")
YRP:AddNetworkString("nws_yrp_upgradeCPU")
net.Receive(
	"nws_yrp_upgradeCPU",
	function(len, ply)
		local mp = net.ReadEntity()
		if IsValid(mp) and mp:GetClass() == "yrp_money_printer" then
			local cost = mp:GetYRPInt("cpuCost")
			if ply:canAfford(cost) and mp:GetYRPInt("cpu") < mp:GetYRPInt("cpuMax") then
				ply:addMoney(-cost)
				mp:SetYRPInt("cpu", mp:GetYRPInt("cpu") + 1)
				mp.delay = CurTime()
			end
		end
	end
)

YRP:AddNetworkString("nws_yrp_upgradeCooler")
net.Receive(
	"nws_yrp_upgradeCooler",
	function(len, ply)
		local mp = net.ReadEntity()
		if IsValid(mp) and mp:GetClass() == "yrp_money_printer" then
			local cost = mp:GetYRPInt("coolerCost")
			if ply:canAfford(cost) and mp:GetYRPInt("cooler") < mp:GetYRPInt("coolerMax") then
				ply:addMoney(-cost)
				mp:SetYRPInt("cooler", mp:GetYRPInt("cooler") + 1)
				mp.delay = CurTime()
			end
		end
	end
)

YRP:AddNetworkString("nws_yrp_upgradePrinter")
net.Receive(
	"nws_yrp_upgradePrinter",
	function(len, ply)
		local mp = net.ReadEntity()
		if IsValid(mp) and mp:GetClass() == "yrp_money_printer" then
			local cost = mp:GetYRPInt("printerCost")
			if ply:canAfford(cost) and mp:GetYRPInt("printer") < mp:GetYRPInt("printerMax") then
				ply:addMoney(-cost)
				mp:SetYRPInt("printer", mp:GetYRPInt("printer") + 1)
			end
		end
	end
)

YRP:AddNetworkString("nws_yrp_upgradeStorage")
net.Receive(
	"nws_yrp_upgradeStorage",
	function(len, ply)
		local mp = net.ReadEntity()
		if IsValid(mp) and mp:GetClass() == "yrp_money_printer" then
			local cost = mp:GetYRPInt("storageCost")
			if ply:canAfford(cost) and mp:GetYRPInt("storage") < mp:GetYRPInt("storageMax") then
				ply:addMoney(-cost)
				mp:SetYRPInt("storage", mp:GetYRPInt("storage") + 1)
				mp:SetYRPInt("moneyMax", mp:GetYRPInt("moneyMax") + 1000)
				mp:SetYRPInt("fuelMax", mp:GetYRPInt("fuelMax") + 10)
			end
		end
	end
)

YRP:AddNetworkString("nws_yrp_fuelUp")
net.Receive(
	"nws_yrp_fuelUp",
	function(len, ply)
		local mp = net.ReadEntity()
		if IsValid(mp) and mp:GetClass() == "yrp_money_printer" then
			local cost = mp:GetYRPInt("fuelCost")
			if ply:canAfford(cost) and mp:GetYRPInt("fuel", 0) < mp:GetYRPInt("fuelMax", 0) then
				ply:addMoney(-cost)
				mp:SetYRPInt("fuel", mp:GetYRPInt("fuel", 0) + 10)
				if mp:GetYRPInt("fuel", 0) > mp:GetYRPInt("fuelMax", 0) then
					mp:SetYRPInt("fuel", mp:GetYRPInt("fuelMax", 0))
				end
			end
		end
	end
)

YRP:AddNetworkString("nws_yrp_repairMP")
net.Receive(
	"nws_yrp_repairMP",
	function(len, ply)
		local mp = net.ReadEntity()
		if IsValid(mp) and mp:GetClass() == "yrp_money_printer" then
			local cost = mp:GetYRPInt("hpCost")
			if ply:canAfford(cost) and mp:GetYRPInt("hp") < mp:GetYRPInt("hpMax") then
				ply:addMoney(-cost)
				mp:SetYRPInt("hp", mp:GetYRPInt("hp") + 10)
				if mp:GetYRPInt("hp") > mp:GetYRPInt("hpMax") then
					mp:SetYRPInt("hp", mp:GetYRPInt("hpMax"))
				end
			end
		end
	end
)

YRP:AddNetworkString("nws_yrp_withdrawMoney")
net.Receive(
	"nws_yrp_withdrawMoney",
	function(len, ply)
		local mp = net.ReadEntity()
		if IsValid(mp) and mp:GetClass() == "yrp_money_printer" then
			local withdraw = mp:GetYRPInt("money", 0)
			ply:addMoney(withdraw)
			mp:SetYRPInt("money", 0)
		end
	end
)

YRP:AddNetworkString("nws_yrp_startMoneyPrinter")
net.Receive(
	"nws_yrp_startMoneyPrinter",
	function(len, ply)
		local mp = net.ReadEntity()
		if IsValid(mp) then
			if mp:GetYRPBool("working", false) then
				mp:SetYRPBool("working", false)
			elseif not mp:GetYRPBool("working") then
				if mp:GetYRPInt("fuel", 0) > 0 then
					mp:SetYRPBool("working", true)
				end
			end
		end
	end
)

function ENT:Initialize()
	self:SetModel("models/props_c17/consolebox01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end

	self:SetYRPString("yrp_use_message", "Open Moneyprinter Settings")
	self:SetYRPBool("working", false)
	self:SetYRPInt("cpu", 1)
	self:SetYRPInt("cpuMax", 10)
	self:SetYRPInt("cpuCost", 500)
	self:SetYRPInt("cooler", 1)
	self:SetYRPInt("coolerMax", 10)
	self:SetYRPInt("coolerCost", 300)
	self:SetYRPInt("printer", 1)
	self:SetYRPInt("printerMax", 6)
	self:SetYRPInt("printerCost", 500)
	self:SetYRPInt("storage", 1)
	self:SetYRPInt("storageMax", 5)
	self:SetYRPInt("storageCost", 600)
	self:SetYRPInt("fuel", 10)
	self:SetYRPInt("fuelMax", 60)
	self:SetYRPInt("fuelCost", 50)
	self:SetYRPInt("money", 0)
	self:SetYRPInt("moneyMax", 5000)
	self:SetYRPInt("hp", 100)
	self:SetYRPInt("hpMax", 100)
	self:SetYRPInt("hpCost", 600)
	self:SetYRPFloat("temp", 0.0)
	self:SetYRPFloat("tempMax", 90.0)
	self.tick = CurTime()
	self.delay = CurTime()
	self.countdown = 10 * self:GetYRPInt("cpuMax") + 5 * self:GetYRPInt("coolerMax") + 2
end

function ENT:OnTakeDamage(dmginfo)
	if not self.m_bApplyingDamage then
		self.m_bApplyingDamage = true
		self:SetYRPInt("hp", self:GetYRPInt("hp", 0) - dmginfo:GetDamage())
		if self:GetYRPInt("hp", 0) <= 0 then
			self:Destroy()
		end

		self.m_bApplyingDamage = false
	end
end

function ENT:Destroy()
	local exp = ents.Create("env_explosion")
	if IsValid(exp) then
		exp:SetKeyValue("spawnflags", 144)
		exp:SetKeyValue("iMagnitude", 15) -- Damage
		exp:SetKeyValue("iRadiusOverride", 200) -- Radius
		exp:SetPos(self:GetPos()) -- inside money printer
		exp:Spawn()
		exp:Fire("explode", "", 0)
	end

	self:Remove()
end

function ENT:Use(activator, caller)
	net.Start("nws_yrp_getMoneyPrintMenu")
	net.WriteEntity(self)
	net.Send(caller)
end

local heated = false
local overheated = false
function ENT:Think()
	if CurTime() < self.tick then return end
	self.tick = CurTime() + 1
	local temp = self:GetYRPFloat("temp", 0.0)
	if self:GetYRPBool("working") then
		if temp > 70.0 then
			overheated = true
		else
			overheated = false
		end

		if self:GetYRPInt("cooler", 0) > self:GetYRPInt("cpu", 0) then
			temp = temp - 1
			if temp < 34.0 and heated then
				temp = 34.0
			end
		elseif self:GetYRPInt("cooler", 0) + 1 < self:GetYRPInt("cpu", 0) then
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

	self:SetYRPFloat("temp", temp)
	-- To much heat, explode
	if self:GetYRPFloat("temp", 0.0) > self:GetYRPFloat("tempMax", 90.0) then
		self:Destroy()
	end

	if self:GetYRPInt("money") ~= nil then
		if self:GetYRPInt("fuel", 0) > 0 and self:GetYRPBool("working") then
			self.workingsound = sound.Add(
				{
					name = "moneyprintersound",
					channel = CHAN_AUTO,
					volume = 1.0 / self:GetYRPInt("cooler"),
					level = 60,
					pitch = {90, 110},
					sound = "ambient/machines/combine_terminal_idle1.wav"
				}
			)

			self:EmitSound("moneyprintersound") -- "ambient/machines/combine_terminal_idle1.wav", 75, 100, 1/self:GetYRPInt( "cooler" ), CHAN_AUTO)
			if CurTime() < self.delay then return end
			local test = self.countdown - self:GetYRPInt("cpu") * 10 - self:GetYRPInt("cooler") * 5
			self.delay = CurTime() + test
			self:SetYRPInt("fuel", self:GetYRPInt("fuel") - 1)
			if self:GetYRPInt("fuel", 0) < 0 then
				self:SetYRPInt("fuel", 0)
			end

			self:SetYRPInt("money", self:GetYRPInt("money") + (30 * self:GetYRPInt("printer")))
			if self:GetYRPInt("money") > self:GetYRPInt("moneyMax") then
				self:SetYRPInt("money", self:GetYRPInt("moneyMax"))
			end

			if GetGlobalYRPBool("bool_money_printer_spawn_money", false) and self:GetYRPInt("money", 0) > 0 then
				local m = self:GetYRPInt("money", 0)
				local ent_m = ents.Create("yrp_money")
				ent_m:SetMoney(m)
				ent_m:SetPos(self:GetPos() + Vector(0, 0, 30))
				ent_m:Spawn()
				self:SetYRPInt("money", 0)
			end
		else
			self:StopSound("moneyprintersound")
			self:SetYRPBool("working", false)
		end
	end
end

function ENT:OnRemove()
	self:StopSound("moneyprintersound")
	self:SetYRPBool("working", false)
end
