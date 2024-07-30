local PANEL = {}
local PlayerVoicePanels = {}
local br = YRP:ctr(5)
local sw = YRP:ctr(680)
local sh = YRP:ctr(128)
local px = ScrW() - sw + br
local py = 2.5 * sh
local iconsize = sh - 2 * br
local circlesize = 10
function PANEL:UpdateValues()
	br = YRP:ctr(5)
	sw = YRP:ctr(680)
	sh = YRP:ctr(128)
	px = ScrW() - sw + br
	py = 2.5 * sh
	iconsize = sh - 2 * br
end

function PANEL:Init()
	self:UpdateValues()
	--[[
	self.Avatar = vgui.Create( "AvatarImage", self )
	self.Avatar:SetPos( br, br)
	self.Avatar:SetSize( iconsize, iconsize )
	]]
	self.mdl = vgui.Create("DModelPanel", self)
	self.mdl:SetPos(br, br)
	self.mdl:SetSize(iconsize, iconsize)
	function self.mdl:LayoutEntity(ent)
		ent:SetSequence(ent:LookupSequence("menu_gman"))
		self:RunAnimation()

		return
	end

	self.PlayerName = vgui.Create("DLabel", self)
	self.PlayerName:SetFont("Y_24_500")
	self.PlayerName:SetSize(sw - br - sh - br - br, sh / 2 - 2 * br)
	self.PlayerName:SetPos(sh + br, br)
	self.PlayerName:SetTextColor(Color(255, 255, 255, 255))
	self.Channels = vgui.Create("DLabel", self)
	self.Channels:SetFont("Y_20_500")
	self.Channels:SetSize(sw - br - sh - br - br, sh / 2 - 2 * br)
	self.Channels:SetPos(sh + br, sh / 2 + br)
	self.Channels:SetTextColor(Color(255, 255, 255, 255))
	self.Color = Color(255, 255, 255, 0)
	self:SetSize(sw, sh)
	self:DockPadding(4, 4, 4, 4)
	self:DockMargin(2, 2, 2, 2)
	self:Dock(BOTTOM)
end

function PANEL:Setup(ply)
	if not IsValid(ply) then return end
	self:UpdateValues()
	yrp_VoicePanelList:SetPos(px, py)
	yrp_VoicePanelList:SetSize(sw, ScrH() - 5 * sh)
	if GetGlobalYRPBool("bool_voice_module") then
		self.ply = ply
		if ply and ply.IDCardID and GetGlobalYRPBool("bool_voice_idcardid", false) then
			if ply.RPName then
				self.PlayerName:SetText(ply:IDCardID() .. " " .. ply:RPName())
			else
				self.PlayerName:SetText(ply:IDCardID() .. " " .. ply:Nick())
			end
		end

		local channels = {}
		for i, v in pairs(GetGlobalYRPTable("yrp_voice_channels")) do
			if IsActiveInChannel(ply, v.uniqueID) and (IsInChannel(LocalPlayer(), v.uniqueID) or IsActiveInChannel(LocalPlayer(), v.uniqueID)) then
				table.insert(channels, v.string_name)
			end
		end

		local text = ""
		if table.Count(channels) > 0 then
			text = table.concat(channels, ", ")
		else
			if GetGlobalYRPBool("bool_voice_module_locally") then
				text = YRP:trans("LID_environment")
			else
				self:Remove()
			end
		end

		self.Channels:SetText(text)
		--self.Avatar:SetPlayer( ply )
		self.mdl:SetModel(ply:GetModel())
		if self.mdl.Entity and YRPEntityAlive(self.mdl.Entity) then
			local head = self.mdl.Entity:LookupBone("ValveBiped.Bip01_Head1")
			if head then
				local eyepos = self.mdl.Entity:GetBonePosition(head) + Vector(0, 0, 3)
				if eyepos then
					eyepos:Add(Vector(0, 0, 2)) -- Move up slightly
					self.mdl:SetLookAt(eyepos)
					self.mdl:SetCamPos(eyepos - Vector(-16, 0, 0)) -- Move cam in front of eyes
					self.mdl.Entity:SetEyeTarget(eyepos - Vector(-16, 0, 0))
				end
			end
		end

		self.Color = team.GetColor(ply:Team())
		self:InvalidateLayout()
	end
end

function PANEL:Paint(w, h)
	--self:UpdateValues()
	if not IsValid(self.ply) then return end
	local vol = self.ply:VoiceVolume()
	draw.RoundedBox(br, 0, 0, w, h, Color(0, vol * 255, 0, 240))
	if YRP:GetDesignIcon("circle") and self.ply.GetFactionColor then
		surface.SetDrawColor(self.ply:GetFactionColor())
		surface.SetMaterial(YRP:GetDesignIcon("circle"))
		surface.DrawTexturedRect(br, br, circlesize, circlesize)
	end
	--draw.RoundedBox( br, br, br, iconsize, iconsize, self.ply:GetFactionColor() )
end

function PANEL:Think()
	if IsValid(self.ply) and self.ply.RPName then
		if GetGlobalYRPBool("bool_voice_idcardid", false) and self.ply.IDCardID then
			self.PlayerName:SetText(self.ply:IDCardID() .. " " .. self.ply:RPName())
		else
			self.PlayerName:SetText(self.ply:RPName())
		end
	end

	if self.fadeAnim then
		self.fadeAnim:Run()
	end
end

function PANEL:FadeOut(anim, delta, data)
	if anim.Finished then
		if IsValid(PlayerVoicePanels[self.ply]) then
			PlayerVoicePanels[self.ply]:Remove()
			PlayerVoicePanels[self.ply] = nil

			return
		end

		return
	end

	self:SetAlpha(255 - (255 * delta))
end

derma.DefineControl("VoiceNotifyYRP", "", PANEL, "DPanel")
hook.Add(
	"PlayerStartVoice",
	"YRP_VOICE_MODULE_PlayerStartVoice",
	function(ply)
		if not GetGlobalYRPBool("bool_voice_module") then return end
		if not IsValid(yrp_VoicePanelList) then return end
		if not IsValid(ply) then return end
		-- There'd be an exta one if voice_loopback is on, so remove it.
		GAMEMODE:PlayerEndVoice(ply)
		if IsValid(PlayerVoicePanels[ply]) then
			if PlayerVoicePanels[ply].fadeAnim then
				PlayerVoicePanels[ply].fadeAnim:Stop()
				PlayerVoicePanels[ply].fadeAnim = nil
			end

			PlayerVoicePanels[ply]:SetAlpha(255)

			return
		end

		local pnl = yrp_VoicePanelList:Add("VoiceNotifyYRP")
		pnl:Setup(ply)
		PlayerVoicePanels[ply] = pnl
	end
)

local function VoiceClean()
	for k, v in pairs(PlayerVoicePanels) do
		if not IsValid(k) then
			GAMEMODE:PlayerEndVoice(k)
		end
	end
end

timer.Create("VoiceClean", 10, 0, VoiceClean)
hook.Add(
	"PlayerEndVoice",
	"YRP_VOICE_MODULE_PlayerEndVoice",
	function(ply)
		if not GetGlobalYRPBool("bool_voice_module") then return end
		if IsValid(PlayerVoicePanels[ply]) then
			if PlayerVoicePanels[ply].fadeAnim then return end
			PlayerVoicePanels[ply].fadeAnim = Derma_Anim("FadeOut", PlayerVoicePanels[ply], PlayerVoicePanels[ply].FadeOut)
			PlayerVoicePanels[ply].fadeAnim:Start(2)
		end
	end
)

local function YRPCreateVoiceVGUI()
	if YRPPanelAlive(yrp_VoicePanelList, "yrp_VoicePanelList") then
		yrp_VoicePanelList:Remove()
	end

	yrp_VoicePanelList = vgui.Create("DPanel")
	yrp_VoicePanelList:ParentToHUD()
	yrp_VoicePanelList:SetPos(px, py)
	yrp_VoicePanelList:SetSize(sw, ScrH() - 5 * sh)
	if yrp_VoicePanelList.SetPaintBackground then
		yrp_VoicePanelList:SetPaintBackground(false)
	end
end

hook.Add("InitPostEntity", "YRPCreateVoiceVGUI", YRPCreateVoiceVGUI)
