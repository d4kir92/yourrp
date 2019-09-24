--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local Player = FindMetaTable("Player")

-- GIVE
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
			if swep != nil then
				local pammo = wep.Primary.Ammo or wep:GetPrimaryAmmoType()
				local sammo = wep.Secondary.Ammo or wep:GetSecondaryAmmoType()

				swep.Primary.OldDefaultClip = swep.Primary.OldDefaultClip or swep.Primary.DefaultClip
				swep.Secondary.OldDefaultClip = swep.Secondary.OldDefaultClip or swep.Secondary.DefaultClip
				swep.Primary.DefaultClip = 0
				swep.Secondary.DefaultClip = 0

				self:GiveAmmo(swep.Primary.OldDefaultClip, pammo)
				self:GiveAmmo(swep.Secondary.OldDefaultClip, sammo)
			end
		end
	else
		YRP.msg("note", tostring(weaponClassName) .. " must be a none swep.")
	end
	return wep
end

if Player.OldGiveAmmo == nil then
	Player.OldGiveAmmo = Player.GiveAmmo
end

function Player:GiveAmmo(amount, typ, hidePopup)
	hidePopup = hidePopup or false
	self:OldGiveAmmo(amount, typ, hidePopup)
	return amount
end

hook.Add("WeaponEquip", "yrp_weaponequip", function(wep, owner)
	local swep = weapons.GetStored(wep:GetClass())

	if swep != nil then
		swep.Primary.OldDefaultClip = swep.Primary.OldDefaultClip or swep.Primary.DefaultClip
		swep.Secondary.OldDefaultClip = swep.Secondary.OldDefaultClip or swep.Secondary.DefaultClip
		swep.Primary.DefaultClip = 0
		swep.Secondary.DefaultClip = 0

		local pammo = wep.Primary.Ammo or wep:GetPrimaryAmmoType()
		local sammo = wep.Secondary.Ammo or wep:GetSecondaryAmmoType()
		owner:GiveAmmo(wep:GetDInt("clip1", 0), pammo)
		owner:GiveAmmo(wep:GetDInt("clip2", 0), sammo)
	end
end)

function GM:PlayerCanPickupWeapon(ply, wep)
	if ( ply:HasWeapon( wep:GetClass() ) ) then return false end

	local canpickup = ply.canpickup
	ply.canpickup = false

	local swep = weapons.GetStored(wep:GetClass())
	if IsValid(swep) then
		wep.PrimaryAmmo = 0
		wep.Secondary = 0
		--swep.Primary.DefaultClip = 0
		--swep.Secondary.DefaultClip = 0
	end

	if canpickup then
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

function Player:DropSWEP(cname)
	local wep = self:GetWeapon(cname)
	local clip1 = wep:Clip1()
	local clip2 = wep:Clip2()
	local clip1max = wep:GetMaxClip1()
	local clip2max = wep:GetMaxClip2()

	self:RemoveWeapon(cname)

	local ent = ents.Create(cname)

	if ent.WorldModel == "" then
		ent.WorldModel = "models/hunter/blocks/cube025x025x025.mdl"
	end

	ent:SetPos(self:GetPos() + Vector(0, 0, 56) + self:EyeAngles():Forward() * 16)
	ent:SetAngles(self:GetAngles())
	self.canpickup = false
	ent:Spawn()
	ent:SetDInt("clip1", clip1)
	ent:SetDInt("clip2", clip2)
	ent:SetDInt("clip1max", clip1max)
	ent:SetDInt("clip2max", clip2max)

	if ent:GetPhysicsObject():IsValid() then
		ent:GetPhysicsObject():SetVelocity(self:EyeAngles():Forward() * 360)
	end
end

function Player:DropSWEPSilence(cname)
	self:RemoveWeapon(cname)
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
