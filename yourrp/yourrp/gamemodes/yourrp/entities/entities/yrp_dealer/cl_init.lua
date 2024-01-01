--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
include('shared.lua')
net.Receive(
	"nws_yrp_open_buy_menu",
	function(len)
		local id = net.ReadString()
		YRPOpenBuyMenu(id)
	end
)

function ENT:Draw()
	if LocalPlayer():GetPos():Distance(self:GetPos()) > 2800 then return end
	self:DrawModel()
end

function ENT:SetRagdollBones(bIn)
	self.m_bRagdollSetup = bIn
end