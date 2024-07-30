--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local Player = FindMetaTable("Player")
hook.Remove("WeaponEquip", "yrp_weaponequip")
hook.Add(
	"WeaponEquip",
	"yrp_weaponequip",
	function(wep, owner)
		local atype = wep:GetPrimaryAmmoType()
		local oldammo = owner:GetAmmoCount(atype)
		local clip1 = wep:GetYRPInt("clip1", -1)
		timer.Simple(
			0,
			function()
				if IsValid(wep) and wep:GetYRPBool("yrpdropped", false) then
					owner:SetAmmo(owner:GetAmmoCount(atype) - (owner:GetAmmoCount(atype) - oldammo), atype)
					wep:SetClip1(clip1)
				end
			end
		)
	end
)

function GM:PlayerCanPickupWeapon(ply, wep)
	if ply:HasWeapon(wep:GetClass()) then return false end
	if wep:GetYRPBool("yrpdropped", false) then
		if wep:GetYRPBool("canpickup", false) then
			if GetGlobalYRPBool("bool_autopickup", true) then
				return true
			else
				if ply:KeyPressed(IN_USE) then
					ply.noammo = true

					return true
				else
					return false
				end
			end
		else
			return false
		end
	end

	return true
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

function YRPEntSpawn(ent)
	if ent and ent.Spawn then
		ent:Spawn()

		return true
	end

	return false
end

function Player:DropSWEP(cname, force)
	if (self:IsAllowedToDropSWEPRole(cname) and self:IsAllowedToDropSWEPUG(cname)) or force then
		self.dropdelay = self.dropdelay or CurTime() - 1
		if self.dropdelay < CurTime() or force then
			self.dropdelay = CurTime() + 1
			local wep = self:GetWeapon(cname)
			if IsValid(wep) then
				wep:SetYRPBool("canpickup", false)
			end

			self:RemoveWeapon(cname)
			local ent = ents.Create(cname)
			if ent.WorldModel == "" then
				ent.WorldModel = "models/props_junk/garbage_takeoutcarton001a.mdl"
			end

			if IsValid(ent) then
				ent:SetPos(self:GetPos() + Vector(0, 0, 56) + self:EyeAngles():Forward() * 16)
				ent:SetAngles(self:GetAngles())
				ent:SetYRPBool("yrpdropped", true)
				ent:SetYRPBool("canpickup", false)
				timer.Simple(
					0.8,
					function()
						if IsValid(ent) then
							ent:SetYRPBool("canpickup", true)
						end
					end
				)

				timer.Simple(
					0.0,
					function()
						if IsValid(ent) and ent.Spawn then
							local _, err = pcall(YRPEntSpawn, ent)
							if err then
								YRPMsg(err)
							end

							if IsValid(wep) and wep.GetClip1 then
								ent:SetYRPInt("clip1", wep:GetClip1())
							end

							if force == nil and ent:GetPhysicsObject():IsValid() and IsValid(self) then
								ent:GetPhysicsObject():SetVelocity(self:EyeAngles():Forward() * 360)
							end

							local ttl = math.Clamp(GetGlobalYRPInt("int_ttlsweps", 60), 0, 3600)
							timer.Simple(
								ttl,
								function()
									if YRPEntityAlive(ent) and ent.GetOwner and not YRPEntityAlive(ent:GetOwner()) then
										if ttl <= 1 then
											YRP:msg("note", "SWEP was removed TTL: " .. ttl)
										end

										ent:Remove()
									end
								end
							)
						end
					end
				)
			end
		end
	else
		net.Start("nws_yrp_dropswep")
		net.WriteBool(false)
		net.Send(self)
	end
end

function Player:DropSWEPSilence(cname)
	self:RemoveWeapon(cname)
end

function Player:IsAllowedToDropSWEPRole(cname)
	local ndsweps = YRP_SQL_SELECT("yrp_ply_roles", "string_ndsweps", "uniqueID = '" .. self:GetYRPString("roleUniqueID", "0") .. "'")
	if IsNotNilAndNotFalse(ndsweps) then
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
	local ndsweps = YRP_SQL_SELECT("yrp_usergroups", "string_nonesweps", "string_name = '" .. string.lower(self:GetUserGroup()) .. "'")
	if IsNotNilAndNotFalse(ndsweps) then
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

YRP:AddNetworkString("nws_yrp_dropswep")
net.Receive(
	"nws_yrp_dropswep",
	function(len, ply)
		local _enabled = PlayersCanDropWeapons()
		if _enabled then
			local _weapon = ply:GetActiveWeapon()
			if _weapon ~= NULL and _weapon ~= nil and _weapon.notdropable == nil then
				local _wclass = _weapon:GetClass() or ""
				ply:DropSWEP(_wclass)
			end
		else
			YRP:msg("note", ply:YRPName() .. " PlayersCanDropWeapons == FALSE")
		end
	end
)
