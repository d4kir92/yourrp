--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
YRP:AddNetworkString("nws_yrp_openLawBoard")
function ENT:Initialize()
	self:SetModel("models/props_combine/combine_intmonitor001.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

function ENT:Use(activator, caller)
	local tmpTable = YRP_SQL_SELECT("yrp_jail", "*", nil)
	if not IsNotNilAndNotFalse(tmpTable) then
		tmpTable = {}
	end

	for i, v in pairs(tmpTable) do
		local cells = YRP_SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = 'jailpoint' and uniqueID = '" .. v.cell .. "'")
		if IsNotNilAndNotFalse(cells) then
			cells = cells[1]
			v.cellname = cells.name
		else
			v.cellname = "DELETED CELL"
		end
	end

	net.Start("nws_yrp_openLawBoard")
	net.WriteTable(tmpTable)
	net.Send(caller)
end

function ENT:Think()
end

YRP:AddNetworkString("nws_yrp_jail")
net.Receive(
	"nws_yrp_jail",
	function(len, ply)
		if not ply:GetYRPBool("bool_canusewarnsystem", false) then return end
		local target = net.ReadEntity()
		if not IsValid(target) then return end
		local jail = YRP_SQL_SELECT("yrp_jail", "*", "SteamID = '" .. target:YRPSteamID() .. "'")
		if IsNotNilAndNotFalse(jail) then
			jail = jail[1]
			local tim = jail.time or 2 * 60
			teleportToJailpoint(target, tim, ply)
		end
	end
)

YRP:AddNetworkString("nws_yrp_unjail")
net.Receive(
	"nws_yrp_unjail",
	function(len, ply)
		if not ply:GetYRPBool("bool_canusewarnsystem", false) then return end
		local target = net.ReadEntity()
		if not IsValid(target) then return end
		YRP_SQL_DELETE_FROM("yrp_jail", "SteamID = '" .. target:YRPSteamID() .. "'")
		teleportToReleasepoint(target)
	end
)
