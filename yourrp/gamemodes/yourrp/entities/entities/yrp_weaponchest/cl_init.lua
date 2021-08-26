--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

include("shared.lua")

function ENT:Draw()
	if LocalPlayer():GetPos():Distance(self:GetPos()) < 2000 then
		self:DrawModel()
	end
end

local function YRPGetSlotSWEP(art, id)
	local sweps = LocalPlayer():GetNW2String(art, "")
	local tab = string.Explode(",", sweps)

	if tab[id] then
		return tab[id]
	end
	return "LID_empty"
end

local function YRPGetModelOfSWEP(cname)
	for i, v in pairs(LocalPlayer():GetWeapons()) do
		if v and v:GetClass() == cname then
			return v:GetModel()
		end
	end
	for i, v in pairs(GetSWEPsList()) do
		if v and v.ClassName == cname then
			return v.WorldModel
		end
	end
	return ""
end

local function YRPGetPrintNameOfSWEP(cname)
	for i, v in pairs(LocalPlayer():GetWeapons()) do
		if v and v:GetClass() == cname then
			return v:GetPrintName()
		end
	end
	for i, v in pairs(GetSWEPsList()) do
		if v and v.ClassName == cname then
			return v.PrintName
		end
	end
	return cname --"LID_empty"
end

local win = nil

local w = 300
local h = 200

local function YRPCreateSlot(x, y, art, id)
	local slot = createD("DPanel", nil, w + 50, h, x, y)
	function slot:Paint(pw, ph)
		draw.RoundedBox(3, 0, 0, pw, ph, Color(40, 40, 40))
	end

	slot.mdl = createD("DModelPanel", slot, w, h, 0, 0)
	slot.mdl:SetModel("")

	slot.btn = createD("DButton", slot.mdl, w, h, 0, 0)
	slot.btn:SetText("")
	function slot.btn:Paint(pw, ph)
		local cname = YRPGetSlotSWEP("slot_" .. art, id)
		local model = YRPGetModelOfSWEP(cname)
		local name = YRPGetPrintNameOfSWEP(cname)
		if model != nil and model != slot.oldmodel then
			slot.oldmodel = model
			slot.mdl:SetModel(model)

			slot.mdl:SetLookAt(Vector(0, 0, 0))
			slot.mdl:SetCamPos(Vector(0, 0, 0) - Vector(-40, 0, -20))
		end

		draw.SimpleText(YRP.lang_string("LID_" .. art), "Y_20_500", 10, 16, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(YRP.lang_string(name), "Y_20_500", pw - 10, 16, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end

	function slot.btn:DoClick()
		local cname = YRPGetSlotSWEP("slot_" .. art, id)
		if cname and cname != "LID_empty" then
			net.Start("yrp_slot_swep_rem")
				net.WriteString(art)
				net.WriteString(cname)
			net.SendToServer()
		end
	end

	slot.btnlist = createD("YButton", slot, 50, h, w, 0)
	slot.btnlist:SetText(">")
	function slot.btnlist:DoClick()
		win:UpdateArtList(art)
	end

	return slot
end

local function YRPCreateSWEP(x, y, art, cname)
	local slot = createD("DPanel", nil, w, h, x, y)
	function slot:Paint(pw, ph)
		draw.RoundedBox(3, 0, 0, pw, ph, Color(40, 40, 40))
	end

	slot.mdl = createD("DModelPanel", slot, w, h, 0, 0)
	slot.mdl:SetModel("")

	slot.btn = createD("DButton", slot.mdl, w, h, 0, 0)
	slot.btn:SetText("")
	function slot.btn:Paint(pw, ph)
		local model = YRPGetModelOfSWEP(cname)
		local name = YRPGetPrintNameOfSWEP(cname)
		if model != nil and model != slot.oldmodel then
			slot.oldmodel = model
			slot.mdl:SetModel(model)

			slot.mdl:SetLookAt(Vector(0, 0, 0))
			slot.mdl:SetCamPos(Vector(0, 0, 0) - Vector(-40, 0, -20))
		end

		draw.SimpleText(YRP.lang_string("LID_" .. art), "Y_20_500", 10, 16, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(YRP.lang_string(name), "Y_20_500", pw - 10, 16, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end

	function slot.btn:DoClick()
		net.Start("yrp_slot_swep_add")
			net.WriteString(art)
			net.WriteString(cname)
		net.SendToServer()
	end

	return slot
end

net.Receive("yrp_open_weaponchest", function(len)
	if win == nil then
		win = createD("YFrame", nil, 10 + 350 + 50 + 300 + 10, ScrH(), 0, 0)
		win:SetTitle("LID_weaponchest")
		win:Center()
		win:MakePopup()
		win.art = "primary"
	
		function win:OnRemove()
			win = nil
		end
		function win:OnClose()
			win = nil
		end

		local content = win:GetContent()

		local slots = 0

		-- SLOTS
		win.slots = createD("DPanelList", content, 300 + 50 + 12, content:GetTall(), 0, 0)
		win.slots:EnableVerticalScrollbar()
		win.slots:SetSpacing(10)
		function win.slots:Paint(pw, ph)
			draw.RoundedBox(3, 0, 0, pw, ph, Color(0, 0, 0, 20))
		end

		for i = 1, GetGlobalInt("yrp_max_slots_primary", 0) do
			local slot = YRPCreateSlot(0, 0, "primary", i)

			win.slots:AddItem(slot)
			slots = slots + 1
		end

		for i = 1, GetGlobalInt("yrp_max_slots_secondary", 0) do
			local slot = YRPCreateSlot(0, 0, "secondary", i)

			win.slots:AddItem(slot)
			slots = slots + 1
		end

		for i = 1, GetGlobalInt("yrp_max_slots_sidearms", 0) do
			local slot = YRPCreateSlot(0, 0, "sidearm", i)

			win.slots:AddItem(slot)
			slots = slots + 1
		end

		for i = 1, GetGlobalInt("yrp_max_slots_gadgets", 0) do
			local slot = YRPCreateSlot(0, 0, "gadget", i)

			win.slots:AddItem(slot)
			slots = slots + 1
		end

		local sh = math.Clamp(slots * (h + 10), 450, content:GetTall())
		sh = sh + 10
		win.slots:SetTall(sh)
		win:SetTall(sh + win:GetHeaderHeight())
		win:Center()



		-- List
		win.selectionlist = createD("DPanelList", content, 300 + 12, sh, 400, 0)
		win.selectionlist:EnableVerticalScrollbar()
		win.selectionlist:SetSpacing(10)
		function win.selectionlist:Paint(pw, ph)
			draw.RoundedBox(3, 0, 0, pw, ph, Color(0, 0, 0, 20))
		end

		net.Receive("yrp_get_sweps_role_art", function(len)
			local tab = net.ReadTable()
			for i, v in pairs(tab) do
				local swep = YRPCreateSWEP(0, 0, win.art, v)
				win.selectionlist:AddItem(swep)
			end
		end)

		function win:UpdateArtList(art)
			win.art = art
			win.selectionlist:Clear()
			net.Start("yrp_get_sweps_role_art")
				net.WriteString(win.art)
			net.SendToServer()
		end
		win:UpdateArtList(win.art)
	end
end)
