--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local _type = type
local MaterialBlur = Material("pp/blurscreen.png", "noclamp")
function YRPDrawRectBlur(pnl, px, py, sw, sh, blur)
	render.ClearStencil()
	render.SetStencilEnable(true)
	render.SetStencilReferenceValue(1)
	render.SetStencilTestMask(1)
	render.SetStencilWriteMask(1)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
	render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
	render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
	render.SetStencilZFailOperation(STENCILOPERATION_REPLACE)
	surface.SetDrawColor(Color(255, 255, 255, 255))
	draw.NoTexture()
	surface.DrawRect(px, py, sw, sh)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
	render.SetStencilFailOperation(STENCILOPERATION_KEEP)
	render.SetStencilPassOperation(STENCILOPERATION_KEEP)
	render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
	local x, y = pnl:LocalToScreen(0, 0)
	surface.SetDrawColor(Color(255, 255, 255, 255))
	surface.SetMaterial(MaterialBlur)
	for i = 1, 3 do
		MaterialBlur:SetFloat("$blur", (i / 3) * blur)
		MaterialBlur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
	end

	render.SetStencilEnable(false)
end

local steps = 3
--local multiplier = 6
local mat = Material("pp/blurscreen")
mat:SetFloat("$blur", 3)
mat:Recompute()
local function DrawBlur(r, px, py, sw, sh, alpha)
	alpha = alpha or 100
	alpha = math.Clamp(alpha, 0, 100)
	if alpha > 0 then
		render.ClearStencil()
		render.SetStencilEnable(true)
		render.SetStencilWriteMask(255)
		render.SetStencilTestMask(255)
		render.SetStencilReferenceValue(1)
		render.SetStencilCompareFunction(STENCIL_ALWAYS)
		render.SetStencilPassOperation(STENCIL_REPLACE)
		render.SetStencilFailOperation(STENCIL_KEEP)
		render.SetStencilZFailOperation(STENCIL_KEEP)
		draw.RoundedBox(r, px, py, sw, sh, Color(50, 50, 50, 10))
		render.SetStencilCompareFunction(STENCIL_EQUAL)
		render.SetStencilPassOperation(STENCIL_KEEP)
		render.SetMaterial(mat)
		for i = 1, steps do
			mat:SetFloat("$blur", (i / steps) * 6)
			mat:Recompute()
			render.UpdateScreenEffectTexture()
			render.DrawScreenQuad()
		end

		draw.RoundedBox(r, 0, 0, ScrW(), ScrH(), Color(50, 50, 50, alpha))
		render.SetStencilEnable(false)
	end
end

function YRPDrawRectBlurHUD(r, px, py, sw, sh, alpha)
	DrawBlur(r, px, py, sw, sh, alpha)
end

function YRPDrawText(tab)
	if _type(tab) == "table" then
		tab = tab or {}
		tab.x = tab.x or 0
		tab.y = tab.y or 0
		tab.color = tab.color or Color(255, 255, 255, 255)
		tab.br = tab.br or 1
		tab.brcolor = tab.brcolor or Color(0, 0, 0, 255)
		tab.ax = tab.ax or 1
		tab.ay = tab.ay or 1
		tab.text = tab.text or "NoText"
		if tab.lforce or tab.lforce == nil then
			tab.text = YRP:trans(tab.text)
		end

		tab.font = tab.font or "Y_14_700"
		draw.SimpleText(tab.text, tab.font, tab.x, tab.y, YRPTextColor(tab.color), tab.ax, tab.ay)
	end
end

function DrawPanel(panel, tab)
	tab = tab or {}
	tab.r = tab.r or 0
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.w = tab.w or panel:GetWide()
	tab.h = tab.h or panel:GetTall()
	tab.color = tab.color or Color(255, 255, 255, 255)
	draw.RoundedBox(tab.r, tab.x, tab.y, tab.w, tab.h, tab.color)
end

function DHorizontalScroller(tab)
	tab = tab or {}
	tab.parent = tab.parent or nil
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.w = tab.w or 100
	tab.h = tab.h or 100
	tab.br = tab.br or 10
	tab.color = tab.color or Color(255, 0, 0, 0)
	local dhorizontalscroller = YRPCreateD("DHorizontalScroller", tab.parent, tab.w, tab.h, tab.x, tab.y)
	function dhorizontalscroller:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, tab.color)
	end

	dhorizontalscroller:SetOverlap(-tab.br)

	return dhorizontalscroller
end

function DGroup(tab)
	tab = tab or {}
	tab.parent = tab.parent or nil
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.w = tab.w or 100
	tab.h = tab.h or 100
	tab.br = tab.br or 0
	tab.color = tab.color or Color(255, 255, 255, 255)
	tab.bgcolor = tab.bgcolor or Color(80, 80, 80)
	tab.name = tab.name or "Unnamed Header"
	local dgroup = {}
	dgroup.header = YRPCreateD("DPanel", tab.parent, tab.w, tab.h, tab.x, tab.y)
	function dgroup.header:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, tab.color)
		ph = YRP:ctr(50)
		local text = {}
		text.text = tab.name
		text.x = pw / 2
		text.y = ph / 2
		text.font = "Y_22_500"
		text.color = Color(0, 0, 0, 255)
		text.br = 0
		text.ax = 1
		text.ay = 1
		YRPDrawText(text)
	end

	dgroup.content = YRPCreateD("DPanelList", dgroup.header, tab.w - 2 * tab.br, tab.h - 1 * tab.br - YRP:ctr(50), tab.br, YRP:ctr(50))
	dgroup.content:EnableVerticalScrollbar(true)
	function dgroup.content:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, tab.bgcolor)
	end

	if tab.parent ~= nil then
		if tab.parent.AddPanel ~= nil then
			tab.parent:AddPanel(dgroup.header)
		elseif tab.parent.AddItem ~= nil then
			tab.parent:AddItem(dgroup.header)
		end
	end

	function dgroup.content:AutoSize()
		dgroup.content.height = 0
		for i, child in pairs(dgroup.content:GetItems()) do
			dgroup.content.height = dgroup.content.height + child:GetTall()
		end

		dgroup.header:SetTall(dgroup.content.height + YRP:ctr(50 + 20))
		dgroup.content:SetTall(dgroup.content.height)
	end

	return dgroup.content
end

function DName(tab)
	tab = tab or {}
	tab.parent = tab.parent or nil
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.w = tab.w or YRP:ctr(50)
	tab.h = tab.h or YRP:ctr(50)
	tab.br = tab.br or 0
	tab.color = tab.color or Color(255, 255, 255, 255)
	tab.bgcolor = tab.bgcolor or Color(80, 80, 80)
	tab.name = tab.name or "Unnamed"
	local dname = YRPCreateD("DPanel", tab.parent, tab.w, tab.h, tab.x, tab.y)
	function dname:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, tab.color)
		local text = {}
		text.text = YRP:trans(tab.name)
		text.x = YRP:ctr(10)
		text.y = ph / 2
		text.font = "Y_18_500"
		text.color = Color(255, 255, 255, 255)
		text.br = 1
		text.ax = 0
		YRPDrawText(text)
	end

	if tab.parent ~= nil then
		tab.parent:AddItem(dname)
	end

	return dname
end

function DIntComboBoxBox(tab, choices, name, netstr, selected)
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent ~= nil then
		tab.w = tab.w or tab.parent:GetWide() or 300
	else
		tab.w = tab.w or 300
	end

	tab.h = tab.h or YRP:ctr(100)
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color(255, 255, 255, 255)
	local dintcomboboxbox = {}
	dintcomboboxbox.line = YRPCreateD("DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x)
	function dintcomboboxbox.line:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, tab.color)
		local text = {}
		text.text = YRP:trans(name) .. ":"
		text.x = YRP:ctr(10)
		text.y = ph / 4
		text.font = "Y_18_500"
		text.color = Color(255, 255, 255, 255)
		text.br = 1
		text.ax = 0
		YRPDrawText(text)
	end

	dintcomboboxbox.dcombobox = YRPCreateD("DComboBox", dintcomboboxbox.line, tab.w, tab.h / 2, tab.brx, tab.h / 2)
	dintcomboboxbox.dcombobox:SetSortItems(false)
	dintcomboboxbox.dcombobox.serverside = false
	if choices ~= nil then
		for i, choice in pairs(choices) do
			local _sel = false
			if selected == choice.data then
				_sel = true
			end

			dintcomboboxbox.dcombobox:AddChoice(choice.name, choice.data, _sel)
		end
	end

	function dintcomboboxbox.dcombobox:OnSelect(index, value, data)
		if netstr ~= nil then
			net.Start(netstr)
			net.WriteInt(data, 32)
			net.SendToServer()
		end
	end

	if tab.parent ~= nil then
		tab.parent:AddItem(dintcomboboxbox.line)
	end

	return dintcomboboxbox.dcombobox
end

function DBoolLine(tab, value, str, netstr)
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent ~= nil then
		tab.w = tab.w or tab.parent:GetWide() or 100
	else
		tab.w = tab.w or 100
	end

	tab.h = tab.h or YRP:ctr(50)
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color(255, 255, 255, 255)
	tab.brx = tab.brx or 0
	local dboolline = {}
	dboolline.line = YRPCreateD("DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x)
	function dboolline.line:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, tab.color)
		local text = {}
		text.text = YRP:trans(str)
		text.x = tab.brx + tab.h + YRP:ctr(10)
		text.y = ph / 2
		text.font = "Y_22_500"
		text.color = Color(0, 0, 0, 255)
		text.br = 0
		text.ax = 0
		YRPDrawText(text)
	end

	dboolline.dcheckbox = YRPCreateD("DCheckBox", dboolline.line, tab.h, tab.h, tab.brx, 0)
	dboolline.dcheckbox:SetValue(value)
	function dboolline.dcheckbox:Paint(pw, ph)
		surfaceCheckBox(self, ph, ph, "done")
	end

	dboolline.dcheckbox.serverside = false
	if netstr ~= nil then
		function dboolline.dcheckbox:OnChange(bVal)
			if not self.serverside and netstr ~= "" then
				net.Start(netstr)
				net.WriteBool(bVal)
				net.SendToServer()
			end
		end

		net.Receive(
			netstr,
			function(len)
				local b = btn(net.ReadString())
				if YRPPanelAlive(dboolline.dcheckbox, "dboolline.dcheckbox") then
					dboolline.dcheckbox.serverside = true
					dboolline.dcheckbox:SetValue(b)
					dboolline.dcheckbox.serverside = false
				end
			end
		)
	end

	if tab.parent ~= nil then
		tab.parent:AddItem(dboolline.line)
	end

	return dboolline.dcheckbox
end

function DFloatLine(tab, value, name, netstr, max, min, dmg)
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent ~= nil then
		tab.w = tab.w or tab.parent:GetWide() or 300
	else
		tab.w = tab.w or 300
	end

	tab.h = tab.h or YRP:ctr(50)
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color(255, 255, 255, 255)
	tab.brx = tab.brx or 0
	local dfloatline = {}
	dfloatline.line = YRPCreateD("DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x)
	function dfloatline.line:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, tab.color)
		local text = {}
		text.text = YRP:trans(name)
		text.x = tab.brx + YRP:ctr(200) + YRP:ctr(10)
		text.y = ph / 2
		text.font = "Y_22_500"
		text.color = Color(0, 0, 0, 255)
		text.br = 0
		text.ax = 0
		YRPDrawText(text)
		if dmg ~= nil and dfloatline.dnumberwang ~= nil then
			local DMG = {}
			DMG.text = dmg:GetValue() * dfloatline.dnumberwang:GetValue() .. " " .. YRP:trans("LID_damage")
			DMG.x = pw - YRP:ctr(10)
			DMG.y = ph / 2
			DMG.font = "Y_22_500"
			DMG.color = Color(0, 0, 0, 255)
			DMG.br = 0
			DMG.ax = 2
			YRPDrawText(DMG)
		end
	end

	dfloatline.dnumberwang = YRPCreateD("DNumberWang", dfloatline.line, YRP:ctr(200), tab.h, tab.brx, 0)
	dfloatline.dnumberwang:SetMax(max or 100)
	dfloatline.dnumberwang:SetMin(min or 0)
	dfloatline.dnumberwang:SetDecimals(6)
	dfloatline.dnumberwang:SetValue(value)
	dfloatline.dnumberwang.serverside = false
	function dfloatline.dnumberwang:OnChange()
		local val = self:GetValue()
		if val >= self:GetMin() then
			if val <= self:GetMax() then
				if not self.serverside and netstr ~= "" then
					net.Start(netstr)
					net.WriteFloat(val)
					net.SendToServer()
				end
			else
				dfloatline.dnumberwang:SetText(self:GetMax())
			end
		else
			dfloatline.dnumberwang:SetText(self:GetMin())
		end
	end

	net.Receive(
		netstr,
		function(len)
			local f = net.ReadFloat()
			if YRPPanelAlive(dfloatline.dnumberwang, "dfloatline.dnumberwang") then
				dfloatline.dnumberwang.serverside = true
				dfloatline.dnumberwang:SetValue(f)
				dfloatline.dnumberwang.serverside = false
			end
		end
	)

	if tab.parent ~= nil then
		tab.parent:AddItem(dfloatline.line)
	end

	return dfloatline.dnumberwang
end

function OLDDIntBox(tab, value, name, netstr, max, min)
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent ~= nil then
		tab.w = tab.w or tab.parent:GetWide() or 300
	else
		tab.w = tab.w or 300
	end

	tab.h = tab.h or YRP:ctr(100)
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color(255, 255, 255, 255)
	local dintline = {}
	dintline.line = YRPCreateD("DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x)
	function dintline.line:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, tab.color)
		local text = {}
		text.text = YRP:trans(name) .. ":"
		text.x = YRP:ctr(10)
		text.y = ph / 4
		text.font = "Y_18_500"
		text.color = Color(255, 255, 255, 255)
		text.br = 1
		text.ax = 0
		YRPDrawText(text)
	end

	dintline.dnumberwang = YRPCreateD("DNumberWang", dintline.line, tab.w, tab.h / 2, tab.brx, tab.h / 2)
	dintline.dnumberwang:SetMax(max or 100)
	dintline.dnumberwang:SetMin(min or 0)
	dintline.dnumberwang:SetDecimals(0)
	dintline.dnumberwang:SetValue(value)
	dintline.dnumberwang.serverside = false
	function dintline.dnumberwang:OnChange()
		local val = self:GetValue()
		if val >= self:GetMin() then
			if val <= self:GetMax() then
				if not self.serverside and netstr ~= "" then
					net.Start(netstr)
					net.WriteInt(val, 32)
					net.SendToServer()
				end
			else
				dintline.dnumberwang:SetText(self:GetMax())
			end
		else
			dintline.dnumberwang:SetText(self:GetMin())
		end
	end

	net.Receive(
		netstr,
		function(len)
			local f = net.ReadInt(32)
			if YRPPanelAlive(dintline.dnumberwang, "dintline.dnumberwang") then
				dintline.dnumberwang.serverside = true
				dintline.dnumberwang:SetValue(f)
				dintline.dnumberwang.serverside = false
			end
		end
	)

	if tab.parent ~= nil then
		tab.parent:AddItem(dintline.line)
	end

	return dintline.dnumberwang
end

function DStringBox(tab, str, name, netstr)
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent ~= nil then
		tab.w = tab.w or tab.parent:GetWide() or 300
	else
		tab.w = tab.w or 300
	end

	tab.h = tab.h or YRP:ctr(100)
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color(255, 255, 255, 255)
	str = str or ""
	local dstringline = {}
	dstringline.line = YRPCreateD("DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x)
	function dstringline.line:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, tab.color)
		local text = {}
		text.text = YRP:trans(name) .. ":"
		text.x = YRP:ctr(10)
		text.y = ph / 4
		text.font = "Y_18_500"
		text.color = Color(255, 255, 255, 255)
		text.br = 1
		text.ax = 0
		YRPDrawText(text)
	end

	dstringline.dtextentry = YRPCreateD("DTextEntry", dstringline.line, tab.w, tab.h / 2, tab.brx, tab.h / 2)
	dstringline.dtextentry:SetText(str)
	dstringline.dtextentry.serverside = false
	function dstringline.dtextentry:OnChange()
		net.Start(netstr)
		net.WriteString(self:GetText())
		net.SendToServer()
	end

	net.Receive(
		netstr,
		function(len)
			local t = net.ReadString()
			if YRPPanelAlive(dstringline.dtextentry, "dstringline.dtextentry") then
				dstringline.dtextentry.serverside = true
				dstringline.dtextentry:SetText(t)
				dstringline.dtextentry.serverside = false
			end
		end
	)

	if tab.parent ~= nil then
		tab.parent:AddItem(dstringline.line)
	end

	return dstringline.dtextentry
end

function DHR(tab)
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent ~= nil then
		tab.w = tab.w or tab.parent:GetWide() or 100
	else
		tab.w = tab.w or 100
	end

	tab.h = tab.h or YRP:ctr(30)
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color(255, 255, 255, 255)
	local hr = YRPCreateD("DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x)
	function hr:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, tab.color)
		draw.RoundedBox(0, 0, ph / 3, pw, ph / 3, Color(0, 0, 0, 255))
	end

	if tab.parent ~= nil then
		tab.parent:AddItem(hr)
	end

	return hr
end

function DHeader(tab, header)
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent ~= nil then
		tab.w = tab.w or tab.parent:GetWide() or 100
	else
		tab.w = tab.w or 100
	end

	tab.h = tab.h or YRP:ctr(50)
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color(255, 255, 255, 255)
	local hea = YRPCreateD("DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x)
	function hea:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, tab.color)
		local head = {}
		head.text = YRP:trans(header)
		head.x = YRP:ctr(10)
		head.y = ph / 2
		head.font = "Y_22_500"
		head.color = Color(0, 0, 0, 255)
		head.br = 0
		head.ax = 0
		YRPDrawText(head)
	end

	if tab.parent ~= nil then
		tab.parent:AddItem(hea)
	end

	return hea
end
