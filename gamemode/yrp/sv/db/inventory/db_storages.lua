--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local Player = FindMetaTable("Player")

-- DROP SWEPS
function GM:PlayerCanPickupWeapon(ply, wep)

	return wep:GetDBool("ispickupable", true)
end

function Player:RemoveWeapon(cname)
	for i, swep in pairs(self:GetWeapons()) do
		if swep:GetClass() == cname then
			swep:Remove()

			return true
		end
	end

	return false
end

function Player:DropSWEP(cname)
	local _cname = cname
	local cont = true

	if cont then
		self:RemoveWeapon(_cname)

		local ent = ents.Create(_cname)

		if ent.WorldModel == "" then
			ent.WorldModel = "models/hunter/blocks/cube025x025x025.mdl"
		end

		ent:SetPos(self:GetPos() + Vector(0, 0, 56) + self:EyeAngles():Forward() * 16)
		ent:SetAngles(self:GetAngles())
		ent:SetDBool("ispickupable", false)
		ent:Spawn()

		timer.Simple(1, function()
			if ea(ent) then
				ent:SetDBool("ispickupable", true)
			end
		end)

		if ent:GetPhysicsObject():IsValid() then
			ent:GetPhysicsObject():SetVelocity(self:EyeAngles():Forward() * 360)
		end
	end
end

function Player:DropSWEPSilence(cname)
	local _cname = cname
	self:RemoveWeapon(_cname)
end

function Player:IsAllowedToDropSWEP(cname)
	local ndsweps = SQL_SELECT("yrp_ply_roles", "string_ndsweps", "uniqueID = '" .. self:GetDString("roleUniqueID", "0") .. "'")
	if wk(ndsweps) then
		ndsweps = ndsweps[1]
		ndsweps = string.Explode(",", ndsweps.string_ndsweps)
		if table.HasValue(ndsweps, cname) then
			return false
		else
			return true
		end
	end
end

util.AddNetworkString("dropswep")
net.Receive("dropswep", function(len, ply)
	local _enabled = PlayersCanDropWeapons()
	local _dropped = false

	if _enabled then
		local _weapon = ply:GetActiveWeapon()

		if _weapon != NULL and _weapon != nil and _weapon.notdropable == nil then
			local _wclass = _weapon:GetClass() or ""
			if ply:IsAllowedToDropSWEP(_wclass) then
				ply:DropSWEP(_wclass)
				_dropped = true
			end
		end
	else
		printGM("note", ply:YRPName() .. " PlayersCanDropWeapons == FALSE")
	end

	net.Start("dropswep")
	net.WriteBool(_dropped)
	net.Send(ply)
end)
