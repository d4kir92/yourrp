--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

include('shared.lua')

function ENT:Draw()
	self:DrawModel()
	self.delay = self.delay or CurTime()
	if input.IsKeyDown(KEY_E) and self.delay < CurTime() then
		self.delay = CurTime() + 0.4
		OpenBuyMenu(self:GetDString("dealerID", "-1"))
	end
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:SetRagdollBones(bIn)
	self.m_bRagdollSetup = bIn
end
