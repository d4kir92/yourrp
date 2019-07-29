--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local PANEL = {}

itemsize = itemsize or 100

function PANEL:Paint(pw, ph)
	draw.RoundedBox(5, 0, 0, pw, ph, Color(255, 255, 255, 100))
end

function PANEL:SetFixed(b)
	self.fixed = b
end

function PANEL:GetFixed()
	return self.fixed
end

function PANEL:SetTyp(t)
	self.typ = t
end

function PANEL:SetModel(m)
	self.model:SetModel(m)
	self.model:SetWide(self:GetWide())
	self.model:SetTall(self:GetTall())
end

function PANEL:SetStorage(suid)
	self.suid = tonumber(suid)
end

local ITEMS = ITEMS or {}
function PANEL:DoClick()
	if self.suid != nil then
		ITEMS[self.suid] = self

		print("---------------------")
		print("self.suid", self.suid)
		print("ITEMS[self.suid].storage", ITEMS[self.suid].storage)
		pTab( ITEMS)
		if ITEMS[self.suid].storage == nil then
			print("IS NIL")
			net.Start("join_storage")
				net.WriteString(self.suid)
			net.SendToServer()
		else
			print("ELSE")
			ITEMS[self.suid].storage:Remove()
			ITEMS[self.suid].storage = nil
		end
	end
end

hook.Add("close_inventory", "yrp_close_inventory", function()
	for i, v in pairs(ITEMS) do
		if v.storage != nil then
			v.storage:Remove()
			v.storage = nil
		end
	end
end)

net.Receive("send_storage_content", function(len)
	local suid = tonumber(net.ReadString())
	local stor = net.ReadTable()

	ITEMS[suid] = ITEMS[suid] or {}

	ITEMS[suid].storage = createD("YStorage", nil, YRP.ctr(400), YRP.ctr(400), 0, 0)
	local st = ITEMS[suid].storage
	st:SetPos(ScW() - st:GetWide() - YRP.ctr(20), ScH() - st:GetTall() - ItemSize() - YRP.ctr(60))
	st:SetStorage(suid)

	function st:OnRemove()
		local s = self:GetStorage()
		if s != nil then
			net.Start("leave_storage")
				net.WriteString(s)
			net.SendToServer()
		end
	end
end)

function PANEL:Init()
	self.fixed = false
	self:SetTyp("item")

	self:SetText("")

	self.model = createD("SpawnIcon", self, self:GetWide(), self:GetTall(), 0, 0)
	function self.model:DoClick()
		self:GetParent():DoClick()
	end

	self:Droppable("yrp_slot")
end

vgui.Register("YItem", PANEL, "DButton")
