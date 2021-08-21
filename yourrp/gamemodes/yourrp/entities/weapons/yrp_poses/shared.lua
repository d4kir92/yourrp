
SWEP.Author = "D4KiR"
SWEP.Contact = "youtube.com/c/D4KiR"
SWEP.Purpose = ""
SWEP.Instructions = "Leftclick - Do Pose\nRightclick - Reset Pose\nReload - Open Menu"

SWEP.Category = "[YourRP] Roleplay"

SWEP.PrintName = "Pose"
SWEP.Language = "en"
SWEP.LanguageString = "LID_poses"

SWEP.Slot = 5
SWEP.SlotPos = 0

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

SWEP.DrawCrosshair = true

SWEP.HoldType = "normal"
function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end

-- Poses
local yrp_poses = {}

yrp_poses["salute"] = {}
yrp_poses["salute"]["ValveBiped.Bip01_R_UpperArm"] = {}
yrp_poses["salute"]["ValveBiped.Bip01_R_UpperArm"].ang = Angle(120, -90, 0)
yrp_poses["salute"]["ValveBiped.Bip01_R_Forearm"] = {}
yrp_poses["salute"]["ValveBiped.Bip01_R_Forearm"].ang = Angle(-10, -116, 90)
yrp_poses["salute"]["ValveBiped.Bip01_Head1"] = {}
yrp_poses["salute"]["ValveBiped.Bip01_Head1"].ang = Angle(0, -10, 0)

yrp_poses["crossarms"] = {}
yrp_poses["crossarms"]["ValveBiped.Bip01_L_UpperArm"] = {}
yrp_poses["crossarms"]["ValveBiped.Bip01_L_UpperArm"].ang = Angle(-20, -65, 0)
yrp_poses["crossarms"]["ValveBiped.Bip01_L_Forearm"] = {}
yrp_poses["crossarms"]["ValveBiped.Bip01_L_Forearm"].ang = Angle(55, -90, 0)
yrp_poses["crossarms"]["ValveBiped.Bip01_L_Hand"] = {}
yrp_poses["crossarms"]["ValveBiped.Bip01_L_Hand"].ang = Angle(0, 0, -15)
yrp_poses["crossarms"]["ValveBiped.Bip01_L_Thigh"] = {}
yrp_poses["crossarms"]["ValveBiped.Bip01_L_Thigh"].ang = Angle(-6, 0, 0)
yrp_poses["crossarms"]["ValveBiped.Bip01_R_UpperArm"] = {}
yrp_poses["crossarms"]["ValveBiped.Bip01_R_UpperArm"].ang = Angle(20, -60, -60)
yrp_poses["crossarms"]["ValveBiped.Bip01_R_Forearm"] = {}
yrp_poses["crossarms"]["ValveBiped.Bip01_R_Forearm"].ang = Angle(10, -90, 0)
yrp_poses["crossarms"]["ValveBiped.Bip01_R_Hand"] = {}
yrp_poses["crossarms"]["ValveBiped.Bip01_R_Hand"].ang = Angle(0, -30, 15)
yrp_poses["crossarms"]["ValveBiped.Bip01_R_Thigh"] = {}
yrp_poses["crossarms"]["ValveBiped.Bip01_R_Thigh"].ang = Angle(6, 0, 0)
--[[
0		ValveBiped.Bip01_Pelvis
1       ValveBiped.Bip01_L_Thigh
2       ValveBiped.Bip01_L_Calf
3       ValveBiped.Bip01_L_Foot
4       ValveBiped.Bip01_L_Toe0
5       LeftAnkle
6       LeftKneeLow
7       LeftKneeUp
8       LeftUpLegRoll
9       LeftKneeRoll
10      ValveBiped.Bip01_R_Thigh
11      ValveBiped.Bip01_R_Calf
12      ValveBiped.Bip01_R_Foot
13      ValveBiped.Bip01_R_Toe0
14      RightAnkle
15      RightKneeLow
16      RightKneeUp
17      RightUpLegRoll
18      RightKneeRoll
]]
yrp_poses["crossarmsbehind"] = {}
yrp_poses["crossarmsbehind"]["ValveBiped.Bip01_L_UpperArm"] = {}
yrp_poses["crossarmsbehind"]["ValveBiped.Bip01_L_UpperArm"].ang = Angle(0, 8, 0)
yrp_poses["crossarmsbehind"]["ValveBiped.Bip01_L_Forearm"] = {}
yrp_poses["crossarmsbehind"]["ValveBiped.Bip01_L_Forearm"].ang = Angle(60, 0, 90)
yrp_poses["crossarmsbehind"]["ValveBiped.Bip01_L_Thigh"] = {}
yrp_poses["crossarmsbehind"]["ValveBiped.Bip01_L_Thigh"].ang = Angle(-6, 0, 0)
yrp_poses["crossarmsbehind"]["ValveBiped.Bip01_R_UpperArm"] = {}
yrp_poses["crossarmsbehind"]["ValveBiped.Bip01_R_UpperArm"].ang = Angle(0, 10, 0)
yrp_poses["crossarmsbehind"]["ValveBiped.Bip01_R_Forearm"] = {}
yrp_poses["crossarmsbehind"]["ValveBiped.Bip01_R_Forearm"].ang = Angle(-60, 0, -90)
yrp_poses["crossarmsbehind"]["ValveBiped.Bip01_R_Thigh"] = {}
yrp_poses["crossarmsbehind"]["ValveBiped.Bip01_R_Thigh"].ang = Angle(6, 0, 0)

yrp_poses["handcuffed"] = {}
yrp_poses["handcuffed"]["ValveBiped.Bip01_L_UpperArm"] = {}
yrp_poses["handcuffed"]["ValveBiped.Bip01_L_UpperArm"].ang = Angle(20, 10, 0)
yrp_poses["handcuffed"]["ValveBiped.Bip01_R_UpperArm"] = {}
yrp_poses["handcuffed"]["ValveBiped.Bip01_R_UpperArm"].ang = Angle(-20, 10, 0)
yrp_poses["handcuffed"]["ValveBiped.Bip01_Head1"] = {}
yrp_poses["handcuffed"]["ValveBiped.Bip01_Head1"].ang = Angle(0, -20, 0)

yrp_poses["surrender"] = {}
yrp_poses["surrender"]["ValveBiped.Bip01_L_UpperArm"] = {}
yrp_poses["surrender"]["ValveBiped.Bip01_L_UpperArm"].ang = Angle(-135, 0, 0)
yrp_poses["surrender"]["ValveBiped.Bip01_L_Forearm"] = {}
yrp_poses["surrender"]["ValveBiped.Bip01_L_Forearm"].ang = Angle(-45, 0, -90)
yrp_poses["surrender"]["ValveBiped.Bip01_R_UpperArm"] = {}
yrp_poses["surrender"]["ValveBiped.Bip01_R_UpperArm"].ang = Angle(135, 0, 0)
yrp_poses["surrender"]["ValveBiped.Bip01_R_Forearm"] = {}
yrp_poses["surrender"]["ValveBiped.Bip01_R_Forearm"].ang = Angle(45, 0, 90)

yrp_poses["surrenderbehind"] = {}
yrp_poses["surrenderbehind"]["ValveBiped.Bip01_L_UpperArm"] = {}
yrp_poses["surrenderbehind"]["ValveBiped.Bip01_L_UpperArm"].ang = Angle(-135, -44, -60)
yrp_poses["surrenderbehind"]["ValveBiped.Bip01_L_Forearm"] = {}
yrp_poses["surrenderbehind"]["ValveBiped.Bip01_L_Forearm"].ang = Angle(0, -110, 0)
yrp_poses["surrenderbehind"]["ValveBiped.Bip01_L_Hand"] = {}
yrp_poses["surrenderbehind"]["ValveBiped.Bip01_L_Hand"].ang = Angle(0, 10, -20)
yrp_poses["surrenderbehind"]["ValveBiped.Bip01_R_UpperArm"] = {}
yrp_poses["surrenderbehind"]["ValveBiped.Bip01_R_UpperArm"].ang = Angle(135, -40, 60)
yrp_poses["surrenderbehind"]["ValveBiped.Bip01_R_Forearm"] = {}
yrp_poses["surrenderbehind"]["ValveBiped.Bip01_R_Forearm"].ang = Angle(0, -110, 0)
yrp_poses["surrenderbehind"]["ValveBiped.Bip01_R_Hand"] = {}
yrp_poses["surrenderbehind"]["ValveBiped.Bip01_R_Hand"].ang = Angle(0, 0, 10)

yrp_poses["pointto"] = {}
yrp_poses["pointto"]["ValveBiped.Bip01_R_UpperArm"] = {}
yrp_poses["pointto"]["ValveBiped.Bip01_R_UpperArm"].ang = Angle(30, -90, 0)
yrp_poses["pointto"]["ValveBiped.Bip01_R_Forearm"] = {}
yrp_poses["pointto"]["ValveBiped.Bip01_R_Forearm"].ang = Angle(0, 0, 0)
yrp_poses["pointto"]["ValveBiped.Bip01_R_Finger01"] = {} -- daumen
yrp_poses["pointto"]["ValveBiped.Bip01_R_Finger01"].ang = Angle(0, 0, 0)
yrp_poses["pointto"]["ValveBiped.Bip01_R_Finger11"] = {} -- zeige finger
yrp_poses["pointto"]["ValveBiped.Bip01_R_Finger11"].ang = Angle(0, 0, 0)
yrp_poses["pointto"]["ValveBiped.Bip01_R_Finger2"] = {} -- mittel finger
yrp_poses["pointto"]["ValveBiped.Bip01_R_Finger2"].ang = Angle(0, -110, 0)
yrp_poses["pointto"]["ValveBiped.Bip01_R_Finger3"] = {} -- heirats finger
yrp_poses["pointto"]["ValveBiped.Bip01_R_Finger3"].ang = Angle(0, -110, 0)
yrp_poses["pointto"]["ValveBiped.Bip01_R_Finger4"] = {} -- kleiner finger
yrp_poses["pointto"]["ValveBiped.Bip01_R_Finger4"].ang = Angle(-20, -110, 0)

yrp_poses["hololink"] = {}
yrp_poses["hololink"]["ValveBiped.Bip01_R_UpperArm"] = {}
yrp_poses["hololink"]["ValveBiped.Bip01_R_UpperArm"].ang = Angle(10, -45, 0)
yrp_poses["hololink"]["ValveBiped.Bip01_R_Forearm"] = {}
yrp_poses["hololink"]["ValveBiped.Bip01_R_Forearm"].ang = Angle(0, -45, 0)
yrp_poses["hololink"]["ValveBiped.Bip01_R_Hand"] = {}
yrp_poses["hololink"]["ValveBiped.Bip01_R_Hand"].ang = Angle(0, 0, 90)
yrp_poses["hololink"]["ValveBiped.Bip01_Head1"] = {}
yrp_poses["hololink"]["ValveBiped.Bip01_Head1"].ang = Angle(0, -30, -10)

yrp_poses["comlink"] = {}
yrp_poses["comlink"]["ValveBiped.Bip01_R_UpperArm"] = {}
yrp_poses["comlink"]["ValveBiped.Bip01_R_UpperArm"].ang = Angle(45, -75, 0)
yrp_poses["comlink"]["ValveBiped.Bip01_R_Forearm"] = {}
yrp_poses["comlink"]["ValveBiped.Bip01_R_Forearm"].ang = Angle(-55, -95, 0)
yrp_poses["comlink"]["ValveBiped.Bip01_R_Hand"] = {}
yrp_poses["comlink"]["ValveBiped.Bip01_R_Hand"].ang = Angle(0, 0, 0)
yrp_poses["comlink"]["ValveBiped.Bip01_Head1"] = {}
yrp_poses["comlink"]["ValveBiped.Bip01_Head1"].ang = Angle(0, -22, -10)

yrp_poses["typing"] = {}
yrp_poses["typing"]["ValveBiped.Bip01_R_UpperArm"] = {}
yrp_poses["typing"]["ValveBiped.Bip01_R_UpperArm"].ang = Angle(20, -45, 0)
yrp_poses["typing"]["ValveBiped.Bip01_R_Forearm"] = {}
yrp_poses["typing"]["ValveBiped.Bip01_R_Forearm"].ang = Angle(0, 0, -45)
yrp_poses["typing"]["ValveBiped.Bip01_R_Hand"] = {}
yrp_poses["typing"]["ValveBiped.Bip01_R_Hand"].ang = Angle(0, 15, 0)
yrp_poses["typing"]["ValveBiped.Bip01_L_UpperArm"] = {}
yrp_poses["typing"]["ValveBiped.Bip01_L_UpperArm"].ang = Angle(-20, -45, 0)
yrp_poses["typing"]["ValveBiped.Bip01_L_Forearm"] = {}
yrp_poses["typing"]["ValveBiped.Bip01_L_Forearm"].ang = Angle(0, 0, 45)
yrp_poses["typing"]["ValveBiped.Bip01_L_Hand"] = {}
yrp_poses["typing"]["ValveBiped.Bip01_L_Hand"].ang = Angle(0, 25, 0)
yrp_poses["typing"]["ValveBiped.Bip01_Head1"] = {}
yrp_poses["typing"]["ValveBiped.Bip01_Head1"].ang = Angle(0, -32, 0)

yrp_poses["thinking"] = {}
yrp_poses["thinking"]["ValveBiped.Bip01_L_UpperArm"] = {}
yrp_poses["thinking"]["ValveBiped.Bip01_L_UpperArm"].ang = Angle(-20, -65, 0)
yrp_poses["thinking"]["ValveBiped.Bip01_L_Forearm"] = {}
yrp_poses["thinking"]["ValveBiped.Bip01_L_Forearm"].ang = Angle(55, -90, 0)
yrp_poses["thinking"]["ValveBiped.Bip01_L_Hand"] = {}
yrp_poses["thinking"]["ValveBiped.Bip01_L_Hand"].ang = Angle(0, 0, -15)
yrp_poses["thinking"]["ValveBiped.Bip01_R_UpperArm"] = {}
yrp_poses["thinking"]["ValveBiped.Bip01_R_UpperArm"].ang = Angle(20, -65, -60)
yrp_poses["thinking"]["ValveBiped.Bip01_R_Forearm"] = {}
yrp_poses["thinking"]["ValveBiped.Bip01_R_Forearm"].ang = Angle(40, -110, 30)
yrp_poses["thinking"]["ValveBiped.Bip01_R_Hand"] = {}
yrp_poses["thinking"]["ValveBiped.Bip01_R_Hand"].ang = Angle(0, 0, 15)
yrp_poses["thinking"]["ValveBiped.Bip01_Head1"] = {}
yrp_poses["thinking"]["ValveBiped.Bip01_Head1"].ang = Angle(0, 12, 0)

yrp_poses["hip"] = {}
yrp_poses["hip"]["ValveBiped.Bip01_L_UpperArm"] = {}
yrp_poses["hip"]["ValveBiped.Bip01_L_UpperArm"].ang = Angle(-45, 0, -30)
yrp_poses["hip"]["ValveBiped.Bip01_L_Forearm"] = {}
yrp_poses["hip"]["ValveBiped.Bip01_L_Forearm"].ang = Angle(90, 0, 90)
yrp_poses["hip"]["ValveBiped.Bip01_L_Hand"] = {}
yrp_poses["hip"]["ValveBiped.Bip01_L_Hand"].ang = Angle(0, 45, -45)
yrp_poses["hip"]["ValveBiped.Bip01_L_Thigh"] = {}
yrp_poses["hip"]["ValveBiped.Bip01_L_Thigh"].ang = Angle(-6, 0, 0)
yrp_poses["hip"]["ValveBiped.Bip01_R_UpperArm"] = {}
yrp_poses["hip"]["ValveBiped.Bip01_R_UpperArm"].ang = Angle(45, 0, 20)
yrp_poses["hip"]["ValveBiped.Bip01_R_Forearm"] = {}
yrp_poses["hip"]["ValveBiped.Bip01_R_Forearm"].ang = Angle(-90, 0, -90)
yrp_poses["hip"]["ValveBiped.Bip01_R_Hand"] = {}
yrp_poses["hip"]["ValveBiped.Bip01_R_Hand"].ang = Angle(0, 45, 45)
yrp_poses["hip"]["ValveBiped.Bip01_R_Thigh"] = {}
yrp_poses["hip"]["ValveBiped.Bip01_R_Thigh"].ang = Angle(6, 0, 0)
yrp_poses["hip"]["ValveBiped.Bip01_Head1"] = {}
yrp_poses["hip"]["ValveBiped.Bip01_Head1"].ang = Angle(0, -6, 0)

function YRPResetPoses(ply)
	for i = 0, 100 do
		ply["poses"][i] = ply["poses"][i] or Angle(0, 0, 0)
		ply["poses"][i] = LerpAngle(16 * FrameTime(), ply["poses"][i], Angle(0, 0, 0))
		
		ply:ManipulateBonePosition( i, Vector(0, 0, 0) )
		ply:ManipulateBoneAngles( i, ply["poses"][i] )
	end
end

function YRPDoPoses()
	for i, ply in pairs(player.GetAll()) do
		ply.pose = ply:GetNW2String("yrp_pose", "salute")
		
		ply.posestatus = ply.posestatus or ""

		local weapon = ply:GetActiveWeapon()
		if IsValid(weapon) then
			if weapon:GetClass() != "yrp_poses" then
				ply.posestatus = "reset"
			else
				local vel = ply:GetVelocity()
				vel = Vector(vel[1], vel[2], 0)
				if ply:IsSprinting() or !ply:IsOnGround() or vel:Length() > 110 then
					ply.posestatus = "reset"
				elseif yrp_poses[ply.pose] then
					if ply:GetNW2Bool("yrp_pose_status", false) then
						ply.posestatus = "do"
					else
						ply.posestatus = "reset"
					end
				elseif !strEmpty(ply.pose) then
					MsgC(Color(255, 0, 0), "missing pose: " .. tostring(ply.pose))
					ply.posestatus = "reset"
				else
					ply.posestatus = "reset"
				end
			end
		end

		if ply.oldposestatus != ply.posestatus then
			ply.oldposestatus = ply.posestatus
			ply.yrp_pose_delay = CurTime() + 0.8
			ply.yrp_pose_delay_update = 0.02
		elseif ply.yrp_pose_delay < CurTime() then
			ply.yrp_pose_delay_update = 0.3
		end
		
		if ply.yrp_pose_delay > CurTime() then
			ply["poses"] = ply["poses"] or {}
			if ply.posestatus == "do" then
				for i, v in pairs(yrp_poses[ply.pose]) do
					local boneID = ply:LookupBone( i )
					if boneID and v.ang then
						ply["poses"][boneID] = ply["poses"][boneID] or Angle(0, 0, 0)
						ply["poses"][boneID] = LerpAngle(12 * FrameTime(), ply["poses"][boneID], v.ang)
					end
				end
			end
		end
	
		ply.yrp_pose_delay_nw = ply.yrp_pose_delay_nw or 0
		if ply.yrp_pose_delay_nw < CurTime() then
			ply.yrp_pose_delay_nw = CurTime() + ply.yrp_pose_delay_update
			if ply.posestatus == "do" then
				for i, v in pairs(yrp_poses[ply.pose]) do
					local boneID = ply:LookupBone( i )
					if boneID and v.ang then
						ply:ManipulateBoneAngles( boneID, ply["poses"][boneID] )
					end
				end
			else
				YRPResetPoses(ply)
			end
		end
	end
end

hook.Add("Think", "yrp_pose_think", function()
	if SERVER then
		YRPDoPoses()
	end
end)

if SERVER then
	util.AddNetworkString("yrp_change_pose")
	net.Receive("yrp_change_pose", function(len, ply)
		local pose = net.ReadString()
		if pose then
			ply:SetNW2Bool("yrp_pose_status", false)

			ply:SetNW2String("yrp_pose", pose)

			timer.Simple(0.33, function()
				if IsValid(ply) then
					ply:SetNW2Bool("yrp_pose_status", true)
				end
			end)
		end
	end)
end

function SWEP:Reload()
	self:SetWeaponHoldType(self.HoldType)

	if SERVER then
		local ply = self:GetOwner()
		ply:SetNW2Bool("yrp_pose_status", false)
		YRPResetPoses(ply)
	end

	if CLIENT then
		self.delay = self.delay or 0

		if CurTime() < self.delay then
			return
		end	
		self.delay = CurTime() + 1

		if input.IsShiftDown() and LocalPlayer():HasAccess() then
			if !pa(self.config) then
				local ply = LocalPlayer()
				ply.yrp_ang = Angle(0, 0, 0)

				self.config = createD("YFrame", nil, YRP.ctr(600), YRP.ctr(1000), 0, 0)
				self.config:SetTitle("CONFIG")
				self.config:Center()
				self.config:MakePopup()

				local bones = {}
				bones["ValveBiped.Bip01_Head1"] = {}
				bones["ValveBiped.Bip01_L_Clavicle"] = {}
				bones["ValveBiped.Bip01_L_UpperArm"] = {}
				bones["ValveBiped.Bip01_L_Forearm"] = {}
				bones["ValveBiped.Bip01_L_Hand"] = {}
				bones["ValveBiped.Bip01_L_Finger2"] = {}
				bones["ValveBiped.Bip01_L_Finger21"] = {}
				bones["ValveBiped.Bip01_L_Finger22"] = {}
				bones["ValveBiped.Bip01_L_Finger1"] = {}
				bones["ValveBiped.Bip01_L_Finger11"] = {}
				bones["ValveBiped.Bip01_L_Finger12"] = {}
				bones["ValveBiped.Bip01_L_Finger0"] = {}
				bones["ValveBiped.Bip01_L_Finger01"] = {}
				bones["ValveBiped.Bip01_L_Finger02"] = {}

				local y = 0
				for name, values in pairs(bones) do
					local btn = createD("YButton", self.config:GetContent(), YRP.ctr(500), YRP.ctr(50), 0, y * YRP.ctr(50 + 10))
					btn:SetText(name)
					btn.win = self.config
					function btn:DoClick()
						local win = createD("YFrame", nil, YRP.ctr(800), YRP.ctr(800), YRP.ctr(800), YRP.ctr(800))
						win:SetTitle(name)
						win:MakePopup()

						win.pit = createD("DNumSlider", win:GetContent(), YRP.ctr(700), YRP.ctr(50), 0, 0)
						win.pit:SetMin(-360)
						win.pit:SetMax(360)
						win.pit:SetValue(0)
						function win.pit:OnValueChanged( value )
							ply.yrp_ang.p = value
							local boneID = ply:LookupBone( name )
							if boneID then
								ply:ManipulateBoneAngles( boneID, ply.yrp_ang )
							end
						end

						win.yaw = createD("DNumSlider", win:GetContent(), YRP.ctr(700), YRP.ctr(50), 0, YRP.ctr(50 + 10))
						win.yaw:SetMin(-360)
						win.yaw:SetMax(360)
						win.yaw:SetValue(0)
						function win.yaw:OnValueChanged( value )
							ply.yrp_ang.y = value
							local boneID = ply:LookupBone( name )
							if boneID then
								ply:ManipulateBoneAngles( boneID, ply.yrp_ang )
							end
						end

						win.rol = createD("DNumSlider", win:GetContent(), YRP.ctr(700), YRP.ctr(50), 0, YRP.ctr(50 + 10 + 50 + 10))
						win.rol:SetMin(-360)
						win.rol:SetMax(360)
						win.rol:SetValue(0)
						function win.rol:OnValueChanged( value )
							ply.yrp_ang.r = value
							local boneID = ply:LookupBone( name )
							if boneID then
								ply:ManipulateBoneAngles( boneID, ply.yrp_ang )
							end
						end

						self.win:Remove()
					end
					
					y = y + 1
				end
			elseif pa(self.config) then
				self.config:Remove()
			end
		else
			if !pa(self.poses) then
				self.poses = createD("YFrame", nil, YRP.ctr(600), YRP.ctr(960), 0, 0)
				self.poses:SetTitle("LID_poses")
				self.poses:Center()
				self.poses:MakePopup()

				local y = 0
				for name, values in pairs(yrp_poses) do
					local btn = createD("YButton", self.poses:GetContent(), YRP.ctr(560), YRP.ctr(50), 0, y * YRP.ctr(50 + 10))
					btn:SetText("LID_" .. name)
					btn.win = self.poses
					function btn:DoClick()
						net.Start("yrp_change_pose")
							net.WriteString(name)
						net.SendToServer()

						if pa(self.win) then
							self.win:Close()
						end
					end

					y = y + 1
				end
			elseif pa(self.poses) then
				self.poses:Remove()
			end
		end
	end
end

function SWEP:Think()

end

function SWEP:PrimaryAttack()
	if SERVER then
		self:SetWeaponHoldType(self.HoldType)
	
		local ply = self:GetOwner()
		ply:SetNW2Bool("yrp_pose_status", true)
	end
end

function SWEP:SecondaryAttack()
	if SERVER then
		self:SetWeaponHoldType(self.HoldType)
	
		local ply = self:GetOwner()
		ply:SetNW2Bool("yrp_pose_status", false)
	end
end
