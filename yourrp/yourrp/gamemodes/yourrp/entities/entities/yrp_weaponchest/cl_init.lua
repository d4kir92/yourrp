--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
include("shared.lua")
function ENT:Draw()
	if LocalPlayer():GetPos():Distance(self:GetPos()) < 2000 then
		self:DrawModel()
	end
end

local function YRPGetSlotSWEP(art, id)
	local sweps = LocalPlayer():GetYRPString(art, "")
	local tab = string.Explode(",", sweps)
	if tab[id] and not strEmpty(tab[id]) then return tab[id] end

	return "LID_empty"
end

local function YRPGetModelOfSWEP(cname)
	for i, v in pairs(LocalPlayer():GetWeapons()) do
		if v and v:GetClass() == cname then return v:GetModel() end
	end

	for i, v in pairs(YRPGetSWEPsList()) do
		if v and v.ClassName == cname then return v.WorldModel end
	end

	return ""
end

local function YRPGetPrintNameOfSWEP(cname)
	for i, v in pairs(LocalPlayer():GetWeapons()) do
		if v and v:GetClass() == cname then return v:GetPrintName() end
	end

	for i, v in pairs(YRPGetSWEPsList()) do
		if v and v.ClassName == cname then return v.PrintName end
	end
	--"LID_empty"

	return cname
end

local win = nil
local w = 300
local h = 200
local function YRPCreateSlot(x, y, art, id)
	local slot = YRPCreateD("DPanel", nil, w + 50, h, x, y)
	function slot:Paint(pw, ph)
		draw.RoundedBox(3, 0, 0, pw, ph, Color(40, 40, 40))
	end

	slot.mdl = YRPCreateD("DModelPanel", slot, w, h, 0, 0)
	slot.mdl:SetModel("")
	slot.btn = YRPCreateD("DButton", slot.mdl, w, h, 0, 0)
	slot.btn:SetText("")
	function slot.btn:Paint(pw, ph)
		local cname = YRPGetSlotSWEP("slot_" .. art, id)
		local model = YRPGetModelOfSWEP(cname)
		local name = YRPGetPrintNameOfSWEP(cname)
		if model ~= nil and model ~= slot.oldmodel then
			slot.oldmodel = model
			slot.mdl:SetModel(model)
			slot.mdl:SetLookAt(Vector(0, 0, 0))
			slot.mdl:SetCamPos(Vector(0, 0, 0) - Vector(-40, 0, -20))
		end

		draw.SimpleText(YRP.trans("LID_" .. art), "Y_20_500", 10, 16, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(YRP.trans(name), "Y_20_500", pw - 10, 16, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		if cname and not strEmpty(cname) and cname ~= "LID_empty" and self:IsHovered() then
			local text = YRP.trans("LID_tostore")
			local font = "Y_40_500"
			local color = Color(160, 0, 0, 120)
			surface.SetFont(font)
			local sw, sh = surface.GetTextSize(text)
			sw = sw + 20
			sh = sh + 10
			draw.RoundedBox(3, pw / 2 - sw / 2, ph / 2 - sh / 2, sw, sh, color)
			draw.SimpleText(text, font, pw / 2, ph / 2, YRPTextColor(color), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	function slot.btn:DoClick()
		local cname = YRPGetSlotSWEP("slot_" .. art, id)
		if art and cname and cname ~= "LID_empty" then
			net.Start("nws_yrp_slot_swep_rem")
			net.WriteString(art)
			net.WriteString(cname)
			net.SendToServer()
		end
	end

	slot.btnlist = YRPCreateD("YButton", slot, 50, h, w, 0)
	slot.btnlist:SetText(">")
	function slot.btnlist:Paint(pw, ph)
		local cname = YRPGetSlotSWEP("slot_" .. art, id)
		if cname and (cname == "LID_empty" or strEmpty(cname)) then
			hook.Run("YButtonPaint", self, pw, ph)
		end
	end

	function slot.btnlist:DoClick()
		local cname = YRPGetSlotSWEP("slot_" .. art, id)
		if cname and (cname == "LID_empty" or strEmpty(cname)) then
			win:UpdateArtList(art)
		end
	end

	return slot
end

local function YRPCreateSWEP(x, y, art, cname)
	local slot = YRPCreateD("DPanel", nil, w, h, x, y)
	function slot:Paint(pw, ph)
		draw.RoundedBox(3, 0, 0, pw, ph, Color(40, 40, 40))
	end

	slot.mdl = YRPCreateD("DModelPanel", slot, w, h, 0, 0)
	slot.mdl:SetModel("")
	slot.btn = YRPCreateD("DButton", slot.mdl, w, h, 0, 0)
	slot.btn:SetText("")
	function slot.btn:Paint(pw, ph)
		local model = YRPGetModelOfSWEP(cname)
		local name = YRPGetPrintNameOfSWEP(cname)
		if model ~= nil and model ~= slot.oldmodel then
			slot.oldmodel = model
			slot.mdl:SetModel(model)
			slot.mdl:SetLookAt(Vector(0, 0, 0))
			slot.mdl:SetCamPos(Vector(0, 0, 0) - Vector(-40, 0, -20))
		end

		draw.SimpleText(YRP.trans("LID_" .. art), "Y_20_500", 10, 16, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(YRP.trans(name), "Y_20_500", pw - 10, 16, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		if self:IsHovered() then
			local text = YRP.trans("LID_equip")
			local font = "Y_40_500"
			local color = Color(0, 160, 0, 120)
			surface.SetFont(font)
			local sw, sh = surface.GetTextSize(text)
			sw = sw + 20
			sh = sh + 10
			draw.RoundedBox(3, pw / 2 - sw / 2, ph / 2 - sh / 2, sw, sh, color)
			draw.SimpleText(text, font, pw / 2, ph / 2, YRPTextColor(color), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	function slot.btn:DoClick()
		if art and cname then
			net.Start("nws_yrp_slot_swep_add")
			net.WriteString(art)
			net.WriteString(cname)
			net.SendToServer()
		end

		win:ClearList()
	end

	return slot
end

net.Receive(
	"nws_yrp_open_weaponchest",
	function(len)
		if win == nil then
			win = YRPCreateD("YFrame", nil, 30 + 300 + 50 + 12 + 300 + 12 + 30, ScrH(), 0, 0)
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
			win.slots = YRPCreateD("DPanelList", content, 300 + 50 + 12, content:GetTall(), 0, 0)
			win.slots:EnableVerticalScrollbar()
			win.slots:SetSpacing(10)
			function win.slots:Paint(pw, ph)
				draw.RoundedBox(3, 0, 0, pw, ph, Color(0, 0, 0, 20))
			end

			local sbar = win.slots.VBar
			function sbar:Paint(bw, bh)
				draw.RoundedBox(0, 0, 0, bw, bh, YRPInterfaceValue("YFrame", "NC"))
			end

			function sbar.btnUp:Paint(bw, bh)
				draw.RoundedBox(0, 0, 0, bw, bh, Color(60, 60, 60))
			end

			function sbar.btnDown:Paint(bw, bh)
				draw.RoundedBox(0, 0, 0, bw, bh, Color(60, 60, 60))
			end

			function sbar.btnGrip:Paint(bw, bh)
				draw.RoundedBox(w / 2, 0, 0, w, h, YRPInterfaceValue("YFrame", "HI"))
			end

			for i = 1, GetGlobalYRPInt("yrp_max_slots_primary", 0) do
				local slot = YRPCreateSlot(0, 0, "primary", i)
				win.slots:AddItem(slot)
				slots = slots + 1
			end

			for i = 1, GetGlobalYRPInt("yrp_max_slots_secondary", 0) do
				local slot = YRPCreateSlot(0, 0, "secondary", i)
				win.slots:AddItem(slot)
				slots = slots + 1
			end

			for i = 1, GetGlobalYRPInt("yrp_max_slots_sidearm", 0) do
				local slot = YRPCreateSlot(0, 0, "sidearm", i)
				win.slots:AddItem(slot)
				slots = slots + 1
			end

			for i = 1, GetGlobalYRPInt("yrp_max_slots_gadget", 0) do
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
			win.selectionlist = YRPCreateD("DPanelList", content, 300 + 12, sh, 400, 0)
			win.selectionlist:EnableVerticalScrollbar()
			win.selectionlist:SetSpacing(10)
			function win.selectionlist:Paint(pw, ph)
				draw.RoundedBox(3, 0, 0, pw, ph, Color(0, 0, 0, 20))
			end

			net.Receive(
				"nws_yrp_get_sweps_role_art",
				function(ilen)
					local tab = net.ReadTable()
					if YRPPanelAlive(win, "nws_yrp_get_sweps_role_art") then
						local none = true
						local alreadyinuse = LocalPlayer():GetWeapons()
						local disallowed = {}
						for i, v in pairs(alreadyinuse) do
							disallowed[v:GetClass()] = true
						end

						for i, v in pairs(tab) do
							if not disallowed[v] then
								local swep = YRPCreateSWEP(0, 0, win.art, v)
								win.selectionlist:AddItem(swep)
								none = false
							end
						end

						if none then
							local info = YRPCreateD("YLabel", nil, 300, h, 0, 0)
							info:SetText("LID_empty")
							win.selectionlist:AddItem(info)
						end
					end
				end
			)

			function win:ClearList()
				win.selectionlist:Clear()
			end

			function win:UpdateArtList(art)
				win.art = art
				win:ClearList()
				net.Start("nws_yrp_get_sweps_role_art")
				net.WriteString(win.art)
				net.SendToServer()
			end
			--win:UpdateArtList(win.art)
		end
	end
)