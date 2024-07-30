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
-- CATEGORIES
yrp_poses["standing"] = {}
yrp_poses["kneeling"] = {}
yrp_poses["standing"]["salute"] = {}
yrp_poses["standing"]["salute"]["ValveBiped.Bip01_R_UpperArm"] = {}
yrp_poses["standing"]["salute"]["ValveBiped.Bip01_R_UpperArm"].ang = Angle(120, -90, 0)
yrp_poses["standing"]["salute"]["ValveBiped.Bip01_R_Forearm"] = {}
yrp_poses["standing"]["salute"]["ValveBiped.Bip01_R_Forearm"].ang = Angle(-10, -116, 90)
yrp_poses["standing"]["salute"]["ValveBiped.Bip01_Head1"] = {}
yrp_poses["standing"]["salute"]["ValveBiped.Bip01_Head1"].ang = Angle(0, -10, 0)
yrp_poses["standing"]["facepalm"] = {}
yrp_poses["standing"]["facepalm"]["ValveBiped.Bip01_R_UpperArm"] = {}
yrp_poses["standing"]["facepalm"]["ValveBiped.Bip01_R_UpperArm"].ang = Angle(20, -90, -60)
yrp_poses["standing"]["facepalm"]["ValveBiped.Bip01_R_Forearm"] = {}
yrp_poses["standing"]["facepalm"]["ValveBiped.Bip01_R_Forearm"].ang = Angle(45, -80, 0)
yrp_poses["standing"]["facepalm"]["ValveBiped.Bip01_R_Hand"] = {}
yrp_poses["standing"]["facepalm"]["ValveBiped.Bip01_R_Hand"].ang = Angle(0, -30, 80)
yrp_poses["standing"]["facepalm"]["ValveBiped.Bip01_R_Thigh"] = {}
yrp_poses["standing"]["facepalm"]["ValveBiped.Bip01_R_Thigh"].ang = Angle(6, 0, 0)
yrp_poses["standing"]["facepalm"]["ValveBiped.Bip01_Head1"] = {}
yrp_poses["standing"]["facepalm"]["ValveBiped.Bip01_Head1"].ang = Angle(0, -20, 0)
yrp_poses["standing"]["crossarms"] = {}
yrp_poses["standing"]["crossarms"]["ValveBiped.Bip01_L_UpperArm"] = {}
yrp_poses["standing"]["crossarms"]["ValveBiped.Bip01_L_UpperArm"].ang = Angle(-20, -65, 0)
yrp_poses["standing"]["crossarms"]["ValveBiped.Bip01_L_Forearm"] = {}
yrp_poses["standing"]["crossarms"]["ValveBiped.Bip01_L_Forearm"].ang = Angle(55, -90, 0)
yrp_poses["standing"]["crossarms"]["ValveBiped.Bip01_L_Hand"] = {}
yrp_poses["standing"]["crossarms"]["ValveBiped.Bip01_L_Hand"].ang = Angle(0, 0, -15)
yrp_poses["standing"]["crossarms"]["ValveBiped.Bip01_L_Thigh"] = {}
yrp_poses["standing"]["crossarms"]["ValveBiped.Bip01_L_Thigh"].ang = Angle(-6, 0, 0)
yrp_poses["standing"]["crossarms"]["ValveBiped.Bip01_R_UpperArm"] = {}
yrp_poses["standing"]["crossarms"]["ValveBiped.Bip01_R_UpperArm"].ang = Angle(20, -60, -60)
yrp_poses["standing"]["crossarms"]["ValveBiped.Bip01_R_Forearm"] = {}
yrp_poses["standing"]["crossarms"]["ValveBiped.Bip01_R_Forearm"].ang = Angle(10, -90, 0)
yrp_poses["standing"]["crossarms"]["ValveBiped.Bip01_R_Hand"] = {}
yrp_poses["standing"]["crossarms"]["ValveBiped.Bip01_R_Hand"].ang = Angle(0, -30, 15)
yrp_poses["standing"]["crossarms"]["ValveBiped.Bip01_R_Thigh"] = {}
yrp_poses["standing"]["crossarms"]["ValveBiped.Bip01_R_Thigh"].ang = Angle(6, 0, 0)
yrp_poses["standing"]["crossarmsbehind"] = {}
yrp_poses["standing"]["crossarmsbehind"]["ValveBiped.Bip01_L_UpperArm"] = {}
yrp_poses["standing"]["crossarmsbehind"]["ValveBiped.Bip01_L_UpperArm"].ang = Angle(0, 8, 0)
yrp_poses["standing"]["crossarmsbehind"]["ValveBiped.Bip01_L_Forearm"] = {}
yrp_poses["standing"]["crossarmsbehind"]["ValveBiped.Bip01_L_Forearm"].ang = Angle(60, 0, 90)
yrp_poses["standing"]["crossarmsbehind"]["ValveBiped.Bip01_L_Thigh"] = {}
yrp_poses["standing"]["crossarmsbehind"]["ValveBiped.Bip01_L_Thigh"].ang = Angle(-6, 0, 0)
yrp_poses["standing"]["crossarmsbehind"]["ValveBiped.Bip01_R_UpperArm"] = {}
yrp_poses["standing"]["crossarmsbehind"]["ValveBiped.Bip01_R_UpperArm"].ang = Angle(0, 10, 0)
yrp_poses["standing"]["crossarmsbehind"]["ValveBiped.Bip01_R_Forearm"] = {}
yrp_poses["standing"]["crossarmsbehind"]["ValveBiped.Bip01_R_Forearm"].ang = Angle(-60, 0, -90)
yrp_poses["standing"]["crossarmsbehind"]["ValveBiped.Bip01_R_Thigh"] = {}
yrp_poses["standing"]["crossarmsbehind"]["ValveBiped.Bip01_R_Thigh"].ang = Angle(6, 0, 0)
yrp_poses["standing"]["handcuffed"] = {}
yrp_poses["standing"]["handcuffed"]["ValveBiped.Bip01_L_UpperArm"] = {}
yrp_poses["standing"]["handcuffed"]["ValveBiped.Bip01_L_UpperArm"].ang = Angle(20, 10, 0)
yrp_poses["standing"]["handcuffed"]["ValveBiped.Bip01_R_UpperArm"] = {}
yrp_poses["standing"]["handcuffed"]["ValveBiped.Bip01_R_UpperArm"].ang = Angle(-20, 10, 0)
yrp_poses["standing"]["handcuffed"]["ValveBiped.Bip01_Head1"] = {}
yrp_poses["standing"]["handcuffed"]["ValveBiped.Bip01_Head1"].ang = Angle(0, -20, 0)
yrp_poses["kneeling"]["handcuffed"] = {}
yrp_poses["kneeling"]["handcuffed"]["ValveBiped.Bip01_L_UpperArm"] = {}
yrp_poses["kneeling"]["handcuffed"]["ValveBiped.Bip01_L_UpperArm"].ang = Angle(20, 10, 0)
yrp_poses["kneeling"]["handcuffed"]["ValveBiped.Bip01_L_Thigh"] = {}
yrp_poses["kneeling"]["handcuffed"]["ValveBiped.Bip01_L_Thigh"].ang = Angle(0, -45, 0)
yrp_poses["kneeling"]["handcuffed"]["ValveBiped.Bip01_L_Calf"] = {}
yrp_poses["kneeling"]["handcuffed"]["ValveBiped.Bip01_L_Calf"].ang = Angle(0, 128, 0)
yrp_poses["kneeling"]["handcuffed"]["ValveBiped.Bip01_L_Foot"] = {}
yrp_poses["kneeling"]["handcuffed"]["ValveBiped.Bip01_L_Foot"].ang = Angle(0, 45, 0)
yrp_poses["kneeling"]["handcuffed"]["ValveBiped.Bip01_R_UpperArm"] = {}
yrp_poses["kneeling"]["handcuffed"]["ValveBiped.Bip01_R_UpperArm"].ang = Angle(-20, 10, 0)
yrp_poses["kneeling"]["handcuffed"]["ValveBiped.Bip01_R_Thigh"] = {}
yrp_poses["kneeling"]["handcuffed"]["ValveBiped.Bip01_R_Thigh"].ang = Angle(0, -50, 0)
yrp_poses["kneeling"]["handcuffed"]["ValveBiped.Bip01_R_Calf"] = {}
yrp_poses["kneeling"]["handcuffed"]["ValveBiped.Bip01_R_Calf"].ang = Angle(0, 135, 0)
yrp_poses["kneeling"]["handcuffed"]["ValveBiped.Bip01_R_Foot"] = {}
yrp_poses["kneeling"]["handcuffed"]["ValveBiped.Bip01_R_Foot"].ang = Angle(0, 45, 0)
yrp_poses["kneeling"]["handcuffed"]["ValveBiped.Bip01_Head1"] = {}
yrp_poses["kneeling"]["handcuffed"]["ValveBiped.Bip01_Head1"].ang = Angle(0, -20, 0)
yrp_poses["kneeling"]["handcuffed"]["ValveBiped.Bip01_Pelvis"] = {}
yrp_poses["kneeling"]["handcuffed"]["ValveBiped.Bip01_Pelvis"].pos = Vector(0, 0, -26)
yrp_poses["standing"]["surrender"] = {}
yrp_poses["standing"]["surrender"]["ValveBiped.Bip01_L_UpperArm"] = {}
yrp_poses["standing"]["surrender"]["ValveBiped.Bip01_L_UpperArm"].ang = Angle(-135, 0, 0)
yrp_poses["standing"]["surrender"]["ValveBiped.Bip01_L_Forearm"] = {}
yrp_poses["standing"]["surrender"]["ValveBiped.Bip01_L_Forearm"].ang = Angle(-45, 0, -90)
yrp_poses["standing"]["surrender"]["ValveBiped.Bip01_R_UpperArm"] = {}
yrp_poses["standing"]["surrender"]["ValveBiped.Bip01_R_UpperArm"].ang = Angle(135, 0, 0)
yrp_poses["standing"]["surrender"]["ValveBiped.Bip01_R_Forearm"] = {}
yrp_poses["standing"]["surrender"]["ValveBiped.Bip01_R_Forearm"].ang = Angle(45, 0, 90)
yrp_poses["kneeling"]["surrender"] = {}
yrp_poses["kneeling"]["surrender"]["ValveBiped.Bip01_L_UpperArm"] = {}
yrp_poses["kneeling"]["surrender"]["ValveBiped.Bip01_L_UpperArm"].ang = Angle(-135, 0, 0)
yrp_poses["kneeling"]["surrender"]["ValveBiped.Bip01_L_Forearm"] = {}
yrp_poses["kneeling"]["surrender"]["ValveBiped.Bip01_L_Forearm"].ang = Angle(-45, 0, -90)
yrp_poses["kneeling"]["surrender"]["ValveBiped.Bip01_L_Thigh"] = {}
yrp_poses["kneeling"]["surrender"]["ValveBiped.Bip01_L_Thigh"].ang = Angle(0, -45, 0)
yrp_poses["kneeling"]["surrender"]["ValveBiped.Bip01_L_Calf"] = {}
yrp_poses["kneeling"]["surrender"]["ValveBiped.Bip01_L_Calf"].ang = Angle(0, 128, 0)
yrp_poses["kneeling"]["surrender"]["ValveBiped.Bip01_L_Foot"] = {}
yrp_poses["kneeling"]["surrender"]["ValveBiped.Bip01_L_Foot"].ang = Angle(0, 45, 0)
yrp_poses["kneeling"]["surrender"]["ValveBiped.Bip01_R_UpperArm"] = {}
yrp_poses["kneeling"]["surrender"]["ValveBiped.Bip01_R_UpperArm"].ang = Angle(135, 0, 0)
yrp_poses["kneeling"]["surrender"]["ValveBiped.Bip01_R_Forearm"] = {}
yrp_poses["kneeling"]["surrender"]["ValveBiped.Bip01_R_Forearm"].ang = Angle(45, 0, 90)
yrp_poses["kneeling"]["surrender"]["ValveBiped.Bip01_R_Thigh"] = {}
yrp_poses["kneeling"]["surrender"]["ValveBiped.Bip01_R_Thigh"].ang = Angle(0, -50, 0)
yrp_poses["kneeling"]["surrender"]["ValveBiped.Bip01_R_Calf"] = {}
yrp_poses["kneeling"]["surrender"]["ValveBiped.Bip01_R_Calf"].ang = Angle(0, 135, 0)
yrp_poses["kneeling"]["surrender"]["ValveBiped.Bip01_R_Foot"] = {}
yrp_poses["kneeling"]["surrender"]["ValveBiped.Bip01_R_Foot"].ang = Angle(0, 45, 0)
yrp_poses["kneeling"]["surrender"]["ValveBiped.Bip01_Pelvis"] = {}
yrp_poses["kneeling"]["surrender"]["ValveBiped.Bip01_Pelvis"].pos = Vector(0, 0, -26)
yrp_poses["standing"]["surrenderbehind"] = {}
yrp_poses["standing"]["surrenderbehind"]["ValveBiped.Bip01_L_UpperArm"] = {}
yrp_poses["standing"]["surrenderbehind"]["ValveBiped.Bip01_L_UpperArm"].ang = Angle(-135, -44, -60)
yrp_poses["standing"]["surrenderbehind"]["ValveBiped.Bip01_L_Forearm"] = {}
yrp_poses["standing"]["surrenderbehind"]["ValveBiped.Bip01_L_Forearm"].ang = Angle(0, -110, 0)
yrp_poses["standing"]["surrenderbehind"]["ValveBiped.Bip01_L_Hand"] = {}
yrp_poses["standing"]["surrenderbehind"]["ValveBiped.Bip01_L_Hand"].ang = Angle(0, 10, -20)
yrp_poses["standing"]["surrenderbehind"]["ValveBiped.Bip01_R_UpperArm"] = {}
yrp_poses["standing"]["surrenderbehind"]["ValveBiped.Bip01_R_UpperArm"].ang = Angle(135, -40, 60)
yrp_poses["standing"]["surrenderbehind"]["ValveBiped.Bip01_R_Forearm"] = {}
yrp_poses["standing"]["surrenderbehind"]["ValveBiped.Bip01_R_Forearm"].ang = Angle(0, -110, 0)
yrp_poses["standing"]["surrenderbehind"]["ValveBiped.Bip01_R_Hand"] = {}
yrp_poses["standing"]["surrenderbehind"]["ValveBiped.Bip01_R_Hand"].ang = Angle(0, 0, 10)
yrp_poses["kneeling"]["surrenderbehind"] = {}
yrp_poses["kneeling"]["surrenderbehind"]["ValveBiped.Bip01_L_UpperArm"] = {}
yrp_poses["kneeling"]["surrenderbehind"]["ValveBiped.Bip01_L_UpperArm"].ang = Angle(-135, -44, -60)
yrp_poses["kneeling"]["surrenderbehind"]["ValveBiped.Bip01_L_Forearm"] = {}
yrp_poses["kneeling"]["surrenderbehind"]["ValveBiped.Bip01_L_Forearm"].ang = Angle(0, -110, 0)
yrp_poses["kneeling"]["surrenderbehind"]["ValveBiped.Bip01_L_Hand"] = {}
yrp_poses["kneeling"]["surrenderbehind"]["ValveBiped.Bip01_L_Hand"].ang = Angle(0, 10, -20)
yrp_poses["kneeling"]["surrenderbehind"]["ValveBiped.Bip01_L_Thigh"] = {}
yrp_poses["kneeling"]["surrenderbehind"]["ValveBiped.Bip01_L_Thigh"].ang = Angle(0, -45, 0)
yrp_poses["kneeling"]["surrenderbehind"]["ValveBiped.Bip01_L_Calf"] = {}
yrp_poses["kneeling"]["surrenderbehind"]["ValveBiped.Bip01_L_Calf"].ang = Angle(0, 128, 0)
yrp_poses["kneeling"]["surrenderbehind"]["ValveBiped.Bip01_L_Foot"] = {}
yrp_poses["kneeling"]["surrenderbehind"]["ValveBiped.Bip01_L_Foot"].ang = Angle(0, 45, 0)
yrp_poses["kneeling"]["surrenderbehind"]["ValveBiped.Bip01_R_UpperArm"] = {}
yrp_poses["kneeling"]["surrenderbehind"]["ValveBiped.Bip01_R_UpperArm"].ang = Angle(135, -40, 60)
yrp_poses["kneeling"]["surrenderbehind"]["ValveBiped.Bip01_R_Forearm"] = {}
yrp_poses["kneeling"]["surrenderbehind"]["ValveBiped.Bip01_R_Forearm"].ang = Angle(0, -110, 0)
yrp_poses["kneeling"]["surrenderbehind"]["ValveBiped.Bip01_R_Hand"] = {}
yrp_poses["kneeling"]["surrenderbehind"]["ValveBiped.Bip01_R_Hand"].ang = Angle(0, 0, 10)
yrp_poses["kneeling"]["surrenderbehind"]["ValveBiped.Bip01_R_Thigh"] = {}
yrp_poses["kneeling"]["surrenderbehind"]["ValveBiped.Bip01_R_Thigh"].ang = Angle(0, -50, 0)
yrp_poses["kneeling"]["surrenderbehind"]["ValveBiped.Bip01_R_Calf"] = {}
yrp_poses["kneeling"]["surrenderbehind"]["ValveBiped.Bip01_R_Calf"].ang = Angle(0, 135, 0)
yrp_poses["kneeling"]["surrenderbehind"]["ValveBiped.Bip01_R_Foot"] = {}
yrp_poses["kneeling"]["surrenderbehind"]["ValveBiped.Bip01_R_Foot"].ang = Angle(0, 45, 0)
yrp_poses["kneeling"]["surrenderbehind"]["ValveBiped.Bip01_Pelvis"] = {}
yrp_poses["kneeling"]["surrenderbehind"]["ValveBiped.Bip01_Pelvis"].pos = Vector(0, 0, -26)
yrp_poses["standing"]["report"] = {}
yrp_poses["standing"]["report"]["ValveBiped.Bip01_R_UpperArm"] = {}
yrp_poses["standing"]["report"]["ValveBiped.Bip01_R_UpperArm"].ang = Angle(30, -180, -90)
yrp_poses["standing"]["report"]["ValveBiped.Bip01_R_Forearm"] = {}
yrp_poses["standing"]["report"]["ValveBiped.Bip01_R_Forearm"].ang = Angle(0, 0, 0)
yrp_poses["standing"]["report"]["ValveBiped.Bip01_R_Finger01"] = {} -- daumen
yrp_poses["standing"]["report"]["ValveBiped.Bip01_R_Finger01"].ang = Angle(0, 0, 0)
yrp_poses["standing"]["report"]["ValveBiped.Bip01_R_Finger11"] = {} -- zeige finger
yrp_poses["standing"]["report"]["ValveBiped.Bip01_R_Finger11"].ang = Angle(0, 0, 0)
yrp_poses["standing"]["report"]["ValveBiped.Bip01_R_Finger21"] = {} -- mittel finger
yrp_poses["standing"]["report"]["ValveBiped.Bip01_R_Finger21"].ang = Angle(0, -110, 0)
yrp_poses["standing"]["report"]["ValveBiped.Bip01_R_Finger31"] = {} -- heirats finger
yrp_poses["standing"]["report"]["ValveBiped.Bip01_R_Finger31"].ang = Angle(0, -110, 0)
yrp_poses["standing"]["report"]["ValveBiped.Bip01_R_Finger41"] = {} -- kleiner finger
yrp_poses["standing"]["report"]["ValveBiped.Bip01_R_Finger41"].ang = Angle(-20, -110, 0)
yrp_poses["standing"]["report"]["ValveBiped.Bip01_Head1"] = {}
yrp_poses["standing"]["report"]["ValveBiped.Bip01_Head1"].ang = Angle(0, 10, 0)
yrp_poses["standing"]["pointto"] = {}
yrp_poses["standing"]["pointto"]["ValveBiped.Bip01_R_UpperArm"] = {}
yrp_poses["standing"]["pointto"]["ValveBiped.Bip01_R_UpperArm"].ang = Angle(30, -90, 0)
yrp_poses["standing"]["pointto"]["ValveBiped.Bip01_R_Forearm"] = {}
yrp_poses["standing"]["pointto"]["ValveBiped.Bip01_R_Forearm"].ang = Angle(0, 0, 0)
yrp_poses["standing"]["pointto"]["ValveBiped.Bip01_R_Finger01"] = {} -- daumen
yrp_poses["standing"]["pointto"]["ValveBiped.Bip01_R_Finger01"].ang = Angle(0, 0, 0)
yrp_poses["standing"]["pointto"]["ValveBiped.Bip01_R_Finger11"] = {} -- zeige finger
yrp_poses["standing"]["pointto"]["ValveBiped.Bip01_R_Finger11"].ang = Angle(0, 0, 0)
yrp_poses["standing"]["pointto"]["ValveBiped.Bip01_R_Finger21"] = {} -- mittel finger
yrp_poses["standing"]["pointto"]["ValveBiped.Bip01_R_Finger21"].ang = Angle(0, -110, 0)
yrp_poses["standing"]["pointto"]["ValveBiped.Bip01_R_Finger31"] = {} -- heirats finger
yrp_poses["standing"]["pointto"]["ValveBiped.Bip01_R_Finger31"].ang = Angle(0, -110, 0)
yrp_poses["standing"]["pointto"]["ValveBiped.Bip01_R_Finger41"] = {} -- kleiner finger
yrp_poses["standing"]["pointto"]["ValveBiped.Bip01_R_Finger41"].ang = Angle(-20, -110, 0)
yrp_poses["standing"]["middlefinger"] = {}
yrp_poses["standing"]["middlefinger"]["ValveBiped.Bip01_R_UpperArm"] = {}
yrp_poses["standing"]["middlefinger"]["ValveBiped.Bip01_R_UpperArm"].ang = Angle(30, -90, 0)
yrp_poses["standing"]["middlefinger"]["ValveBiped.Bip01_R_Forearm"] = {}
yrp_poses["standing"]["middlefinger"]["ValveBiped.Bip01_R_Forearm"].ang = Angle(0, 0, 0)
yrp_poses["standing"]["middlefinger"]["ValveBiped.Bip01_R_Hand"] = {}
yrp_poses["standing"]["middlefinger"]["ValveBiped.Bip01_R_Hand"].ang = Angle(70, 0, 90)
yrp_poses["standing"]["middlefinger"]["ValveBiped.Bip01_R_Finger01"] = {} -- daumen
yrp_poses["standing"]["middlefinger"]["ValveBiped.Bip01_R_Finger01"].ang = Angle(0, 0, 0)
yrp_poses["standing"]["middlefinger"]["ValveBiped.Bip01_R_Finger11"] = {} -- zeige finger
yrp_poses["standing"]["middlefinger"]["ValveBiped.Bip01_R_Finger11"].ang = Angle(20, -90, 0)
yrp_poses["standing"]["middlefinger"]["ValveBiped.Bip01_R_Finger2"] = {} -- mittel finger
yrp_poses["standing"]["middlefinger"]["ValveBiped.Bip01_R_Finger2"].ang = Angle(0, 0, 0)
yrp_poses["standing"]["middlefinger"]["ValveBiped.Bip01_R_Finger31"] = {} -- heirats finger
yrp_poses["standing"]["middlefinger"]["ValveBiped.Bip01_R_Finger31"].ang = Angle(0, -90, 0)
yrp_poses["standing"]["middlefinger"]["ValveBiped.Bip01_R_Finger41"] = {} -- kleiner finger
yrp_poses["standing"]["middlefinger"]["ValveBiped.Bip01_R_Finger41"].ang = Angle(-20, -90, 0)
yrp_poses["standing"]["hololink"] = {}
yrp_poses["standing"]["hololink"]["ValveBiped.Bip01_R_UpperArm"] = {}
yrp_poses["standing"]["hololink"]["ValveBiped.Bip01_R_UpperArm"].ang = Angle(10, -45, 0)
yrp_poses["standing"]["hololink"]["ValveBiped.Bip01_R_Forearm"] = {}
yrp_poses["standing"]["hololink"]["ValveBiped.Bip01_R_Forearm"].ang = Angle(0, -45, 0)
yrp_poses["standing"]["hololink"]["ValveBiped.Bip01_R_Hand"] = {}
yrp_poses["standing"]["hololink"]["ValveBiped.Bip01_R_Hand"].ang = Angle(0, 0, 90)
yrp_poses["standing"]["hololink"]["ValveBiped.Bip01_Head1"] = {}
yrp_poses["standing"]["hololink"]["ValveBiped.Bip01_Head1"].ang = Angle(0, -30, -10)
yrp_poses["standing"]["comlink"] = {}
yrp_poses["standing"]["comlink"]["ValveBiped.Bip01_R_UpperArm"] = {}
yrp_poses["standing"]["comlink"]["ValveBiped.Bip01_R_UpperArm"].ang = Angle(45, -75, 0)
yrp_poses["standing"]["comlink"]["ValveBiped.Bip01_R_Forearm"] = {}
yrp_poses["standing"]["comlink"]["ValveBiped.Bip01_R_Forearm"].ang = Angle(-55, -95, 0)
yrp_poses["standing"]["comlink"]["ValveBiped.Bip01_R_Hand"] = {}
yrp_poses["standing"]["comlink"]["ValveBiped.Bip01_R_Hand"].ang = Angle(0, 0, 0)
yrp_poses["standing"]["comlink"]["ValveBiped.Bip01_Head1"] = {}
yrp_poses["standing"]["comlink"]["ValveBiped.Bip01_Head1"].ang = Angle(0, -22, -10)
yrp_poses["standing"]["typing"] = {}
yrp_poses["standing"]["typing"]["ValveBiped.Bip01_R_UpperArm"] = {}
yrp_poses["standing"]["typing"]["ValveBiped.Bip01_R_UpperArm"].ang = Angle(20, -45, 0)
yrp_poses["standing"]["typing"]["ValveBiped.Bip01_R_Forearm"] = {}
yrp_poses["standing"]["typing"]["ValveBiped.Bip01_R_Forearm"].ang = Angle(0, 0, -45)
yrp_poses["standing"]["typing"]["ValveBiped.Bip01_R_Hand"] = {}
yrp_poses["standing"]["typing"]["ValveBiped.Bip01_R_Hand"].ang = Angle(0, 15, 0)
yrp_poses["standing"]["typing"]["ValveBiped.Bip01_L_UpperArm"] = {}
yrp_poses["standing"]["typing"]["ValveBiped.Bip01_L_UpperArm"].ang = Angle(-20, -45, 0)
yrp_poses["standing"]["typing"]["ValveBiped.Bip01_L_Forearm"] = {}
yrp_poses["standing"]["typing"]["ValveBiped.Bip01_L_Forearm"].ang = Angle(0, 0, 45)
yrp_poses["standing"]["typing"]["ValveBiped.Bip01_L_Hand"] = {}
yrp_poses["standing"]["typing"]["ValveBiped.Bip01_L_Hand"].ang = Angle(0, 25, 0)
yrp_poses["standing"]["typing"]["ValveBiped.Bip01_Head1"] = {}
yrp_poses["standing"]["typing"]["ValveBiped.Bip01_Head1"].ang = Angle(0, -32, 0)
yrp_poses["standing"]["thinking"] = {}
yrp_poses["standing"]["thinking"]["ValveBiped.Bip01_L_UpperArm"] = {}
yrp_poses["standing"]["thinking"]["ValveBiped.Bip01_L_UpperArm"].ang = Angle(-20, -65, 0)
yrp_poses["standing"]["thinking"]["ValveBiped.Bip01_L_Forearm"] = {}
yrp_poses["standing"]["thinking"]["ValveBiped.Bip01_L_Forearm"].ang = Angle(55, -90, 0)
yrp_poses["standing"]["thinking"]["ValveBiped.Bip01_L_Hand"] = {}
yrp_poses["standing"]["thinking"]["ValveBiped.Bip01_L_Hand"].ang = Angle(0, 0, -15)
yrp_poses["standing"]["thinking"]["ValveBiped.Bip01_R_UpperArm"] = {}
yrp_poses["standing"]["thinking"]["ValveBiped.Bip01_R_UpperArm"].ang = Angle(20, -65, -60)
yrp_poses["standing"]["thinking"]["ValveBiped.Bip01_R_Forearm"] = {}
yrp_poses["standing"]["thinking"]["ValveBiped.Bip01_R_Forearm"].ang = Angle(40, -110, 30)
yrp_poses["standing"]["thinking"]["ValveBiped.Bip01_R_Hand"] = {}
yrp_poses["standing"]["thinking"]["ValveBiped.Bip01_R_Hand"].ang = Angle(0, 0, 15)
yrp_poses["standing"]["thinking"]["ValveBiped.Bip01_Head1"] = {}
yrp_poses["standing"]["thinking"]["ValveBiped.Bip01_Head1"].ang = Angle(0, 12, 0)
yrp_poses["standing"]["hip"] = {}
yrp_poses["standing"]["hip"]["ValveBiped.Bip01_L_UpperArm"] = {}
yrp_poses["standing"]["hip"]["ValveBiped.Bip01_L_UpperArm"].ang = Angle(-45, 0, -30)
yrp_poses["standing"]["hip"]["ValveBiped.Bip01_L_Forearm"] = {}
yrp_poses["standing"]["hip"]["ValveBiped.Bip01_L_Forearm"].ang = Angle(90, 0, 90)
yrp_poses["standing"]["hip"]["ValveBiped.Bip01_L_Hand"] = {}
yrp_poses["standing"]["hip"]["ValveBiped.Bip01_L_Hand"].ang = Angle(0, 45, -45)
yrp_poses["standing"]["hip"]["ValveBiped.Bip01_L_Thigh"] = {}
yrp_poses["standing"]["hip"]["ValveBiped.Bip01_L_Thigh"].ang = Angle(-6, 0, 0)
yrp_poses["standing"]["hip"]["ValveBiped.Bip01_R_UpperArm"] = {}
yrp_poses["standing"]["hip"]["ValveBiped.Bip01_R_UpperArm"].ang = Angle(45, 0, 20)
yrp_poses["standing"]["hip"]["ValveBiped.Bip01_R_Forearm"] = {}
yrp_poses["standing"]["hip"]["ValveBiped.Bip01_R_Forearm"].ang = Angle(-90, 0, -90)
yrp_poses["standing"]["hip"]["ValveBiped.Bip01_R_Hand"] = {}
yrp_poses["standing"]["hip"]["ValveBiped.Bip01_R_Hand"].ang = Angle(0, 45, 45)
yrp_poses["standing"]["hip"]["ValveBiped.Bip01_R_Thigh"] = {}
yrp_poses["standing"]["hip"]["ValveBiped.Bip01_R_Thigh"].ang = Angle(6, 0, 0)
yrp_poses["standing"]["hip"]["ValveBiped.Bip01_Head1"] = {}
yrp_poses["standing"]["hip"]["ValveBiped.Bip01_Head1"].ang = Angle(0, -6, 0)
yrp_poses["standing"]["coverears"] = {}
yrp_poses["standing"]["coverears"]["ValveBiped.Bip01_L_UpperArm"] = {}
yrp_poses["standing"]["coverears"]["ValveBiped.Bip01_L_UpperArm"].ang = Angle(-100, -10, -60)
yrp_poses["standing"]["coverears"]["ValveBiped.Bip01_L_Forearm"] = {}
yrp_poses["standing"]["coverears"]["ValveBiped.Bip01_L_Forearm"].ang = Angle(0, -110, 0)
yrp_poses["standing"]["coverears"]["ValveBiped.Bip01_L_Hand"] = {}
yrp_poses["standing"]["coverears"]["ValveBiped.Bip01_L_Hand"].ang = Angle(25, 40, -40)
yrp_poses["standing"]["coverears"]["ValveBiped.Bip01_R_UpperArm"] = {}
yrp_poses["standing"]["coverears"]["ValveBiped.Bip01_R_UpperArm"].ang = Angle(108, -10, 60)
yrp_poses["standing"]["coverears"]["ValveBiped.Bip01_R_Forearm"] = {}
yrp_poses["standing"]["coverears"]["ValveBiped.Bip01_R_Forearm"].ang = Angle(0, -110, 0)
yrp_poses["standing"]["coverears"]["ValveBiped.Bip01_R_Hand"] = {}
yrp_poses["standing"]["coverears"]["ValveBiped.Bip01_R_Hand"].ang = Angle(-25, 40, 40)
--[[
0		ValveBiped.Bip01_Pelvis
1       ValveBiped.Bip01_L_Thigh
2       ValveBiped.Bip01_L_Calf
3       ValveBiped.Bip01_L_Foot
4       ValveBiped.Bip01_L_Toe0
5       LeftAnkle
6       Leftkneelingow
7       LeftKneeUp
8       LeftUpLegRoll
9       LeftKneeRoll
10      ValveBiped.Bip01_R_Thigh
11      ValveBiped.Bip01_R_Calf
12      ValveBiped.Bip01_R_Foot
13      ValveBiped.Bip01_R_Toe0
14      RightAnkle
15      Rightkneelingow
16      RightKneeUp
17      RightUpLegRoll
18      RightKneeRoll
]]
local nang = Angle(0, 0, 0)
local nvec = Vector(0, 0, 0)
function YRPResetPoses(ply)
	for i = 0, 100 do
		ply["posesang"][i] = ply["posesang"][i] or nang
		ply["posesang"][i] = LerpAngle(12 * FrameTime(), ply["posesang"][i], nang)
		ply:ManipulateBoneAngles(i, ply["posesang"][i])
		ply["posespos"][i] = ply["posespos"][i] or nvec
		ply["posespos"][i] = LerpVector(12 * FrameTime(), ply["posespos"][i], nvec)
		ply:ManipulateBonePosition(i, ply["posespos"][i])
	end
end

function YRPDoPoses()
	for i, ply in pairs(player.GetAll()) do
		ply.yrpposeart = ply:GetYRPString("yrp_pose_art", "standing")
		ply.yrppose = ply:GetYRPString("yrp_pose", "salute")
		ply.yrpposestatus = ply.yrpposestatus or ""
		local weapon = ply:GetActiveWeapon()
		if IsValid(weapon) then
			if weapon:GetClass() ~= "yrp_poses" then
				ply.yrpposestatus = "reset"
			else
				local vel = ply:GetVelocity()
				vel = Vector(vel[1], vel[2], 0)
				if ply:IsSprinting() or not ply:IsOnGround() or vel:Length() > 110 then
					ply.yrpposestatus = "reset"
				elseif yrp_poses[ply.yrpposeart][ply.yrppose] then
					if ply:GetYRPBool("yrp_pose_status", false) then
						ply.yrpposestatus = "do"
					else
						ply.yrpposestatus = "reset"
					end
				elseif not strEmpty(ply.yrppose) then
					MsgC(Color(0, 255, 0), "missing pose: " .. tostring(ply.yrppose) .. "\n")
					ply.yrpposestatus = "reset"
				else
					ply.yrpposestatus = "reset"
				end
			end
		end

		if ply.oldposestatus ~= ply.yrpposestatus then
			ply.oldposestatus = ply.yrpposestatus
			ply.yrp_pose_delay = CurTime() + 0.6
			ply.yrp_pose_delay_update = 0.03
		elseif ply.yrp_pose_delay < CurTime() then
			ply.yrp_pose_delay_update = 0.3
		end

		if ply.yrp_pose_delay > CurTime() then
			ply["posesang"] = ply["posesang"] or {}
			ply["posespos"] = ply["posespos"] or {}
			if ply.yrpposestatus == "do" then
				for ii, v in pairs(yrp_poses[ply.yrpposeart][ply.yrppose]) do
					local boneID = ply:LookupBone(ii)
					if boneID and v.ang then
						ply["posesang"][boneID] = ply["posesang"][boneID] or Angle(0, 0, 0)
						ply["posesang"][boneID] = LerpAngle(32 * FrameTime(), ply["posesang"][boneID], v.ang)
					end

					if boneID and v.pos then
						ply["posespos"][boneID] = ply["posespos"][boneID] or Vector(0, 0, 0)
						ply["posespos"][boneID] = LerpVector(32 * FrameTime(), ply["posespos"][boneID], v.pos)
					end
				end
			end
		end

		ply.yrp_pose_delay_nw = ply.yrp_pose_delay_nw or 0
		if ply.yrp_pose_delay_nw < CurTime() then
			ply.yrp_pose_delay_nw = CurTime() + ply.yrp_pose_delay_update
			if ply.yrpposestatus == "do" then
				for ii, v in pairs(yrp_poses[ply.yrpposeart][ply.yrppose]) do
					local boneID = ply:LookupBone(ii)
					if boneID and v.ang then
						ply:ManipulateBoneAngles(boneID, ply["posesang"][boneID])
					end

					if boneID and v.pos then
						ply:ManipulateBonePosition(boneID, ply["posespos"][boneID])
					end
				end
			else
				YRPResetPoses(ply)
			end
		end
	end
end

hook.Add(
	"Think",
	"yrp_pose_think",
	function()
		if SERVER then
			YRPDoPoses()
		end
	end
)

if SERVER then
	YRP:AddNetworkString("nws_yrp_change_pose")
	net.Receive(
		"nws_yrp_change_pose",
		function(len, ply)
			local pose_art = net.ReadString()
			local pose = net.ReadString()
			if pose then
				ply:SetYRPBool("yrp_pose_status", false)
				ply:SetYRPString("yrp_pose_art", pose_art)
				ply:SetYRPString("yrp_pose", pose)
				timer.Simple(
					0.33,
					function()
						if IsValid(ply) then
							ply:SetYRPBool("yrp_pose_status", true)
						end
					end
				)
			end
		end
	)
end

function SWEP:Reload()
	self:SetWeaponHoldType(self.HoldType)
	if SERVER then
		local ply = self:GetOwner()
		ply:SetYRPBool("yrp_pose_status", false)
		YRPResetPoses(ply)
	end

	if CLIENT then
		self.delay = self.delay or 0
		if CurTime() < self.delay then return end
		self.delay = CurTime() + 1
		if input.IsShiftDown() and LocalPlayer():SteamID() == "76561198002066427" then
			if not YRPPanelAlive(self.config, "76561198002066427") then
				local ply = LocalPlayer()
				ply.yrp_ang = Angle(0, 0, 0)
				self.config = YRPCreateD("YFrame", nil, YRP:ctr(600), YRP:ctr(1000), 0, 0)
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
					local btn = YRPCreateD("YButton", self.config:GetContent(), YRP:ctr(500), YRP:ctr(50), 0, y * YRP:ctr(50 + 10))
					btn:SetText(name)
					btn.win = self.config
					function btn:DoClick()
						local win = YRPCreateD("YFrame", nil, YRP:ctr(800), YRP:ctr(800), YRP:ctr(800), YRP:ctr(800))
						win:SetTitle(name)
						win:MakePopup()
						win.pit = YRPCreateD("DNumSlider", win:GetContent(), YRP:ctr(700), YRP:ctr(50), 0, 0)
						win.pit:SetMin(-360)
						win.pit:SetMax(360)
						win.pit:SetValue(0)
						function win.pit:OnValueChanged(value)
							ply.yrp_ang.p = value
							local boneID = ply:LookupBone(name)
							if boneID then
								ply:ManipulateBoneAngles(boneID, ply.yrp_ang)
							end
						end

						win.yaw = YRPCreateD("DNumSlider", win:GetContent(), YRP:ctr(700), YRP:ctr(50), 0, YRP:ctr(50 + 10))
						win.yaw:SetMin(-360)
						win.yaw:SetMax(360)
						win.yaw:SetValue(0)
						function win.yaw:OnValueChanged(value)
							ply.yrp_ang.y = value
							local boneID = ply:LookupBone(name)
							if boneID then
								ply:ManipulateBoneAngles(boneID, ply.yrp_ang)
							end
						end

						win.rol = YRPCreateD("DNumSlider", win:GetContent(), YRP:ctr(700), YRP:ctr(50), 0, YRP:ctr(50 + 10 + 50 + 10))
						win.rol:SetMin(-360)
						win.rol:SetMax(360)
						win.rol:SetValue(0)
						function win.rol:OnValueChanged(value)
							ply.yrp_ang.r = value
							local boneID = ply:LookupBone(name)
							if boneID then
								ply:ManipulateBoneAngles(boneID, ply.yrp_ang)
							end
						end

						self.win:Remove()
					end

					y = y + 1
				end
			elseif YRPPanelAlive(self.config, "poses") then
				self.config:Remove()
			end
		else
			if not YRPPanelAlive(self.yrpposes, "poses2") then
				self.yrpposes = YRPCreateD("YFrame", nil, YRP:ctr(10), YRP:ctr(960), 0, 0)
				self.yrpposes:SetTitle("LID_poses")
				local x = 0
				local y = 0
				local maxy = 0
				local maxx = 0
				for namecategory, categorytab in pairs(yrp_poses) do
					local btn = YRPCreateD("YLabel", self.yrpposes:GetContent(), YRP:ctr(560), YRP:ctr(50), x * YRP:ctr(560 + 10), y * YRP:ctr(50 + 10))
					btn:SetText("LID_" .. namecategory)
					y = y + 1
					for name, values in pairs(categorytab) do
						local cBtn = YRPCreateD("YButton", self.yrpposes:GetContent(), YRP:ctr(560), YRP:ctr(50), x * YRP:ctr(560 + 10), y * YRP:ctr(50 + 10))
						cBtn:SetText("LID_" .. name)
						cBtn.win = self.yrpposes
						function cBtn:DoClick()
							net.Start("nws_yrp_change_pose")
							net.WriteString(namecategory)
							net.WriteString(name)
							net.SendToServer()
							if YRPPanelAlive(self.win, "poses3") then
								self.win:Close()
							end
						end

						y = y + 1
					end

					if maxy < y then
						maxy = y
					end

					x = x + 1
					y = 0
					if maxx < x then
						maxx = x
					end
				end

				self.yrpposes:SetSize(YRP:ctr(20) + maxx * YRP:ctr(560 + 10) + YRP:ctr(10), self.yrpposes:GetHeaderHeight() + YRP:ctr(10) + maxy * YRP:ctr(50 + 10) + YRP:ctr(20))
				self.yrpposes:Center()
				self.yrpposes:MakePopup()
			elseif YRPPanelAlive(self.yrpposes, "poses4") then
				self.yrpposes:Remove()
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
		ply:SetYRPBool("yrp_pose_status", true)
	end
end

function SWEP:SecondaryAttack()
	if SERVER then
		self:SetWeaponHoldType(self.HoldType)
		local ply = self:GetOwner()
		ply:SetYRPBool("yrp_pose_status", false)
	end
end
