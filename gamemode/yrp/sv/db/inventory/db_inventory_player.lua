--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local Player = FindMetaTable("Player")

-- GIVE
--[[
	if Player.OldGive == nil then
	Player.OldGive = Player.Give
end

function Player:Give(weaponClassName, bNoAmmo)
	bNoAmmo = bNoAmmo or false
	self.canpickup = true
	local wep = self:OldGive(weaponClassName, false)
	if wk(wep) then
		if wep.Clip1 then
			local clip1 = wep:Clip1()
			local clip2 = wep:Clip2()
			local clip1max = wep:GetMaxClip1()
			local clip2max = wep:GetMaxClip2()
			wep:SetDInt("clip1", clip1)
			wep:SetDInt("clip2", clip2)
			wep:SetDInt("clip1max", clip1max)
			wep:SetDInt("clip2max", clip2max)

			local swep = weapons.GetStored(wep:GetClass())
			if swep != nil and wk(swep.Primary) then
				local pammo = swep.Primary.Ammo or wep:GetPrimaryAmmoType()
				local sammo = swep.Secondary.Ammo or wep:GetSecondaryAmmoType()

				swep.Primary.OldDefaultClip = swep.Primary.OldDefaultClip or swep.Primary.DefaultClip
				swep.Secondary.OldDefaultClip = swep.Secondary.OldDefaultClip or swep.Secondary.DefaultClip
				swep.Primary.DefaultClip = 0
				swep.Secondary.DefaultClip = 0

				self:GiveAmmo(swep.Primary.OldDefaultClip, pammo)
				self:GiveAmmo(swep.Secondary.OldDefaultClip, sammo)
			end
		end
	else
		YRP.msg("note", tostring(weaponClassName) .. " must be a none swep or missing from collection.")
	end
	return wep
end

if Player.OldGiveAmmo == nil then
	Player.OldGiveAmmo = Player.GiveAmmo
end

function Player:GiveAmmo(amount, typ, hidePopup)
	hidePopup = hidePopup or false
	amount = amount or 0
	if amount > 0 then
		self:OldGiveAmmo(amount, typ, hidePopup)
	end
	return amount
end
]]

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

	if wep.dropped and wep:GetDBool("canpickup", false) or wep.dropped == nil then
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
			wep:SetDBool("canpickup", false)
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
			ent:SetDBool("canpickup", false)
			ent.dropped = true
			ent:Spawn()
			--[[ent:SetDInt("clip1", clip1)
			ent:SetDInt("clip2", clip2)
			ent:SetDInt("clip1max", clip1max)
			ent:SetDInt("clip2max", clip2max)]]

			local ttl = math.Clamp(GetGlobalDInt("int_ttlsweps", 60), 1, 3600)
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
