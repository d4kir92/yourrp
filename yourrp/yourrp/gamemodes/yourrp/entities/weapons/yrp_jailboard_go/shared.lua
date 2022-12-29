
SWEP.Author = "D4KiR"
SWEP.Contact = "youtube.com/c/D4KiR"
SWEP.Purpose = "Shows the jailboard"
SWEP.Instructions = "-"

SWEP.Category = "[YourRP] Civil Protection"

SWEP.PrintName = "JailboardGo"

SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.DrawAmmo = false

SWEP.DrawCrosshair = false

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.notdropable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"

SWEP.DrawCrosshair = false

SWEP.HoldType = "pistol"
function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end

function SWEP:Reload()

end

function SWEP:Think()

end

function SWEP:PrimaryAttack()
	if SERVER then

		local ply = self:GetOwner()

		local tmpTable = YRP_SQL_SELECT( "yrp_jail", "*", nil)

		if !IsNotNilAndNotFalse(tmpTable) then
			tmpTable = {}
		end

		for i, v in pairs(tmpTable) do
			local cells = YRP_SQL_SELECT( "yrp_" .. GetMapNameDB(), "*", "type = 'jailpoint' and uniqueID = '" .. v.cell .. "'" )
			if IsNotNilAndNotFalse( cells) then
				cells = cells[1]
				v.cellname = cells.name
			else
				v.cellname = "DELETED CELL"
			end
		end

		net.Start( "nws_yrp_openLawBoard" )
			net.WriteTable(tmpTable)
		net.Send(ply)
	end
end

function SWEP:SecondaryAttack()

end
