--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local Player = FindMetaTable("Player")

hook.Add("WeaponEquip", "yrp_weaponequip", function(wep, owner)
	local atype = wep:GetPrimaryAmmoType()
	local swep = weapons.GetStored(wep:GetClass())
	local oldammo = owner:GetAmmoCount(atype)

	local ENT = weapons.GetStored(wep:GetClass())
	if wk(ENT) then
		timer.Simple(0, function()
			owner:SetAmmo(owner:GetAmmoCount(atype) - (owner:GetAmmoCount(atype) - oldammo), atype)
		end)
	end
end)


function GM:PlayerCanPickupWeapon(ply, wep)
	if ( ply:HasWeapon( wep:GetClass() ) ) then return false end

	if wep.dropped and wep:GetNW2Bool("canpickup", false) or wep.dropped == nil then
		return true
	elseif ply:KeyPressed(IN_USE) then
		ply.noammo = true
		return true
	end
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

function Player:DropSWEP(cname, force)
	if (self:IsAllowedToDropSWEPRole(cname) and self:IsAllowedToDropSWEPUG(cname)) or force then
		self.dropdelay = self.dropdelay or CurTime() - 1
		if self.dropdelay < CurTime() or force then
			self.dropdelay = CurTime() + 1
			local wep = self:GetWeapon(cname)
			wep:SetNW2Bool("canpickup", false)
			--[[local clip1 = wep:Clip1()
			local clip2 = wep:Clip2()
			local clip1max = wep:GetMaxClip1()
			local clip2max = wep:GetMaxClip2()
			]]
			self:RemoveWeapon(cname)

			local ent = ents.Create(cname)

			if ent.WorldModel == "" then
				ent.WorldModel = "models/props_junk/garbage_takeoutcarton001a.mdl"
			end

			ent:SetPos(self:GetPos() + Vector(0, 0, 56) + self:EyeAngles():Forward() * 16)
			ent:SetAngles(self:GetAngles())
			ent:SetNW2Bool("canpickup", false)
			ent.dropped = true
			ent:Spawn()
			--[[ent:SetNW2Int("clip1", clip1)
			ent:SetNW2Int("clip2", clip2)
			ent:SetNW2Int("clip1max", clip1max)
			ent:SetNW2Int("clip2max", clip2max)]]

			local ttl = math.Clamp(GetGlobalInt("int_ttlsweps", 60), 1, 3600)
			timer.Simple(ttl, function()
				if ea(ent) and !ent:GetOwner():IsValid() then
					ent:Remove()
				end
			end)

			if ent:GetPhysicsObject():IsValid() then
				ent:GetPhysicsObject():SetVelocity(self:EyeAngles():Forward() * 360)
			end
		else
			-- on cooldown
		end
	else
		net.Start("dropswep")
			net.WriteBool(false)
		net.Send(self)
	end
end

function Player:DropSWEPSilence(cname)
	self:RemoveWeapon(cname)
end

function Player:IsAllowedToDropSWEPRole(cname)
	local ndsweps = SQL_SELECT("yrp_ply_roles", "string_ndsweps", "uniqueID = '" .. self:GetNW2String("roleUniqueID", "0") .. "'")
	if wk(ndsweps) then
		ndsweps = ndsweps[1]
		ndsweps = string.Explode(",", ndsweps.string_ndsweps)
		if table.HasValue(ndsweps, cname) then
			return false
		else
			return true
		end
	end
	return true
end

function Player:IsAllowedToDropSWEPUG(cname)
	local ndsweps = SQL_SELECT("yrp_usergroups", "string_nonesweps", "string_name = '" .. string.lower(self:GetUserGroup()) .. "'")
	if wk(ndsweps) then
		ndsweps = ndsweps[1]
		ndsweps = string.Explode(",", ndsweps.string_nonesweps)
		if table.HasValue(ndsweps, cname) then
			return false
		else
			return true
		end
	end
	return true
end

util.AddNetworkString("dropswep")
net.Receive("dropswep", function(len, ply)
	local _enabled = PlayersCanDropWeapons()

	if _enabled then
		local _weapon = ply:GetActiveWeapon()

		if _weapon != NULL and _weapon != nil and _weapon.notdropable == nil then
			local _wclass = _weapon:GetClass() or ""
			ply:DropSWEP(_wclass)
		end
	else
		YRP.msg("note", ply:YRPName() .. " PlayersCanDropWeapons == FALSE")
	end
end)
