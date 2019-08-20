--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

include('shared.lua')

net.Receive("open_buy_menu", function(len)
	local id = net.ReadString()
	OpenBuyMenu(id)
end)

function ENT:Draw()
	if LocalPlayer():GetPos():Distance(self:GetPos()) > 2800 then return end
	self:DrawModel()
end

function ENT:SetRagdollBones(bIn)
	self.m_bRagdollSetup = bIn
end
