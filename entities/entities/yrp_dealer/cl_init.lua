--Copyright (C) 2017-2018 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

include('shared.lua')

function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:SetRagdollBones(bIn)
	self.m_bRagdollSetup = bIn
end
