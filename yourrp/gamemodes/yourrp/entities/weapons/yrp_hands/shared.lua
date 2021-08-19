
SWEP.Author = "D4KiR"
SWEP.Contact = "youtube.com/c/D4KiR"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "[YourRP] Roleplay"

SWEP.PrintName = "Arms"
SWEP.Language = "en"
SWEP.LanguageString = "LID_arms"

SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.DrawAmmo = false

SWEP.DrawCrosshair = false

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = "models/weapons/c_medkit.mdl"
SWEP.WorldModel = ""
SWEP.notdropable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"

SWEP.DrawCrosshair = false

SWEP.HoldType = "normal"
function SWEP:Initialize()
	self:SetHoldType(self.HoldType)

	self.Time = 0
	self.Range = 150
end

function SWEP:Think()
	if self.Drag and (not self.Owner:KeyDown(IN_ATTACK) or not IsValid(self.Drag.Entity)) then
		self.Drag = nil
	end
	if self.Owner:KeyPressed(IN_RELOAD) and not IsValid(animMenu) then
		if CLIENT then
			local ply = FindMetaTable( "Player" )
			animMenu = vgui.Create( "DFrame" )
			animMenu:SetTitle( "Animations" )
			animMenu:SetSize( 180, 600 )
			animMenu:Center()
			animMenu:MakePopup()
			animMenu.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
				draw.RoundedBox( 0, 0, 0, w, h, Color( 231, 76, 60, 0 ) ) -- Draw a red box instead of the frame
			end

			local cheer = vgui.Create( "DButton", animMenu )
			cheer:SetText( "Cheer!" )
			cheer:SetTextColor( Color( 255, 255, 255 ) )
			cheer:SetPos( 0, 30 )
			cheer:SetSize( 180, 30 )
			cheer.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 128, 185, 250 ) ) -- Draw a blue button
			end
			cheer.DoClick = function()
				ply:ConCommand( "resetanims" )
				ply:ConCommand( "act cheer" )
				animMenu:Close()
			end

			local robot = vgui.Create( "DButton", animMenu )
			robot:SetText( "Robot!" )
			robot:SetTextColor( Color( 255, 255, 255 ) )
			robot:SetPos( 0, 65 )
			robot:SetSize( 180, 30 )
			robot.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 128, 185, 250 ) ) -- Draw a blue button
			end
			robot.DoClick = function()
				ply:ConCommand( "resetanims" )
				ply:ConCommand( "act robot" )
				animMenu:Close()
			end
			local surrender = vgui.Create( "DButton", animMenu )
			surrender:SetText( "Surrender!" )
			surrender:SetTextColor( Color( 255, 255, 255 ) )
			surrender:SetPos( 0, 100 )
			surrender:SetSize( 180, 30 )
			surrender.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 128, 185, 250 ) ) -- Draw a blue button
			end
			surrender.DoClick = function()
				ply:ConCommand( "resetanims" )
				ply:ConCommand( "surrender" )
				animMenu:Close()
			end
			local laugh = vgui.Create( "DButton", animMenu )
			laugh:SetText( "Laugh!" )
			laugh:SetTextColor( Color( 255, 255, 255 ) )
			laugh:SetPos( 0, 135 )
			laugh:SetSize( 180, 30 )
			laugh.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 128, 185, 250 ) ) -- Draw a blue button
			end
			laugh.DoClick = function()
				ply:ConCommand( "resetanims" )
				ply:ConCommand( "act laugh" )
				animMenu:Close()
			end
			local muscle = vgui.Create( "DButton", animMenu )
			muscle:SetText( "Dance!" )
			muscle:SetTextColor( Color( 255, 255, 255 ) )
			muscle:SetPos( 0, 170 )
			muscle:SetSize( 180, 30 )
			muscle.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 128, 185, 250 ) ) -- Draw a blue button
			end
			muscle.DoClick = function()
				ply:ConCommand( "resetanims" )
				ply:ConCommand( "act muscle" )
				animMenu:Close()
			end
			local cheer = vgui.Create( "DButton", animMenu )
			cheer:SetText( "Salute!" )
			cheer:SetTextColor( Color( 255, 255, 255 ) )
			cheer:SetPos( 0, 205 )
			cheer:SetSize( 180, 30 )
			cheer.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 128, 185, 250 ) ) -- Draw a blue button
			end
			cheer.DoClick = function()
				ply:ConCommand( "resetanims" )
				ply:ConCommand( "act salute" )
				animMenu:Close()
			end
			local disagree = vgui.Create( "DButton", animMenu )
			disagree:SetText( "No!" )
			disagree:SetTextColor( Color( 255, 255, 255 ) )
			disagree:SetPos( 0, 240 )
			disagree:SetSize( 180, 30 )
			disagree.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 128, 185, 250 ) ) -- Draw a blue button
			end
			disagree.DoClick = function()
				ply:ConCommand( "resetanims" )
				ply:ConCommand( "act disagree" )
				animMenu:Close()
			end
			local halt = vgui.Create( "DButton", animMenu )
			halt:SetText( "Halt!" )
			halt:SetTextColor( Color( 255, 255, 255 ) )
			halt:SetPos( 0, 275 )
			halt:SetSize( 180, 30 )
			halt.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 128, 185, 250 ) ) -- Draw a blue button
			end
			halt.DoClick = function()
				ply:ConCommand( "resetanims" )
				ply:ConCommand( "act halt" )
				animMenu:Close()
			end
			local reset = vgui.Create( "DButton", animMenu )
			reset:SetText( "Reset Anims!" )
			reset:SetTextColor( Color( 255, 255, 255 ) )
			reset:SetPos( 0, 310 )
			reset:SetSize( 180, 30 )
			reset.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 230, 64, 75, 250 ) ) -- Draw a blue button
			end
			reset.DoClick = function()
				ply:ConCommand( "resetanims" )
				animMenu:Close()
			end
		end
	end
end

function SWEP:PrimaryAttack()
	local Pos = self.Owner:GetShootPos()
	local Aim = self.Owner:GetAimVector()

	local Tr = util.TraceLine{
		start = Pos,
		endpos = Pos + Aim *self.Range,
		filter = player.GetAll(),
	}

	local HitEnt = Tr.Entity
	if self.Drag then
		HitEnt = self.Drag.Entity
	else
		if not IsValid( HitEnt ) or HitEnt:GetMoveType() ~= MOVETYPE_VPHYSICS or
			HitEnt:IsVehicle() or HitEnt:GetNWBool( "NoDrag", false ) or
			HitEnt.BlockDrag or
			IsValid( HitEnt:GetParent() ) then
			return
		end

		if not self.Drag then
			self.Drag = {
				OffPos = HitEnt:WorldToLocal(Tr.HitPos),
				Entity = HitEnt,
				Fraction = Tr.Fraction,
			}
		end
	end

	if CLIENT or not IsValid( HitEnt ) then return end

	local Phys = HitEnt:GetPhysicsObject()

	if IsValid( Phys ) then
		local Pos2 = Pos + Aim * self.Range * self.Drag.Fraction
		local OffPos = HitEnt:LocalToWorld( self.Drag.OffPos )
		local Dif = Pos2 - OffPos
		local Nom = (Dif:GetNormal() *math.min(1, Dif:Length() / 100) * 500 -Phys:GetVelocity()) * Phys:GetMass()

		Phys:ApplyForceOffset( Nom, OffPos )
		Phys:AddAngleVelocity( -Phys:GetAngleVelocity() /4 )
	end
end

function SWEP:SecondaryAttack()
	--
end

if CLIENT then
	local x, y = ScrW() / 2, ScrH() / 2
	local mainColor = Color( 40, 40, 255, 255 )
	local textColor = Color( 255, 255, 255, 255 )

	function SWEP:DrawHUD()
		if IsValid( self.Owner:GetVehicle() ) then return end
		local Pos = self.Owner:GetShootPos()
		local Aim = self.Owner:GetAimVector()

		local Tr = util.TraceLine{
			start = Pos,
			endpos = Pos + Aim * self.Range,
			filter = player.GetAll(),
		}

		local HitEnt = Tr.Entity
		if IsValid( HitEnt ) and HitEnt:GetMoveType() == MOVETYPE_VPHYSICS and
			not self.rDag and
			not HitEnt:IsVehicle() and
			not IsValid( HitEnt:GetParent() ) and
			not HitEnt:GetNWBool("NoDrag", false) then

			self.Time = math.min( 1, self.Time +2 *FrameTime() )
		else
			self.Time = math.max( 0, self.Time -2 *FrameTime() )
		end

		if self.Time > 0 then
			textColor.a = mainColor.a *self.Time

			draw.SimpleText(YRP.lang_string("LID_drag"), "Y_30_500", x, y, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		if self.Drag and IsValid( self.Drag.Entity ) then
			local Pos2 = Pos + Aim * 100 * self.Drag.Fraction
			local OffPos = self.Drag.Entity:LocalToWorld( self.Drag.OffPos )
			local Dif = Pos2 - OffPos

			local A = OffPos:ToScreen()
			local B = Pos2:ToScreen()

			surface.SetDrawColor(mainColor)

			for size = 1, 4 do
				surface.DrawCircle( A.x, A.y, size, mainColor )
				surface.DrawCircle( B.x, B.y, size, mainColor )
			end
			surface.DrawLine( A.x, A.y, B.x, B.y )
		end
	end
end

function SWEP:PreDrawViewModel( vm, pl, wep )
	return true
end
