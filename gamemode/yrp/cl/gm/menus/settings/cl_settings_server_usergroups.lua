--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local lply = LocalPlayer()

local UGS = UGS or {}

local CURRENT_USERGROUP = nil

local DUGS = DUGS or {}

local _icon = {}
_icon.size = YRP.ctr(100 - 16)
_icon.br = YRP.ctr(8)

net.Receive("Connect_Settings_UserGroup", function(len)
	local ug = net.ReadTable()
	CURRENT_USERGROUP = tonumber(ug.uniqueID)
	UGS[CURRENT_USERGROUP] = ug

	local PARENT = GetSettingsSite()

	if pa(PARENT.ug) then
		PARENT.ug:Remove()
	end

	PARENT.ug = createD("DHorizontalScroller", PARENT, PARENT:GetWide() - YRP.ctr(20 + 500 + 20), PARENT:GetTall(), YRP.ctr(20 + 500), YRP.ctr(0))

	PARENT.ugp = createD("DPanel", PARENT, YRP.ctr(3000), PARENT:GetTall(), 0, 0)
	function PARENT.ugp:Paint(pw, ph)
		--surfaceBox(0, 0, pw, ph, Color(255, 100, 100, 100))
	end
	PARENT.ug:AddPanel(PARENT.ugp)

	PARENT = PARENT.ugp

	-- NAME
	local NAME = createD("DYRPPanelPlus", PARENT, YRP.ctr(500), YRP.ctr(100), YRP.ctr(20), YRP.ctr(20))
	NAME:INITPanel("DTextEntry")
	NAME:SetHeader(YRP.lang_string("LID_name"))
	NAME:SetText(string.upper(ug.string_name))
	function NAME.plus:OnChange()
		UGS[CURRENT_USERGROUP].string_name = string.upper(self:GetText())
		net.Start("usergroup_update_string_name")
			net.WriteString(CURRENT_USERGROUP)
			net.WriteString(string.upper(self:GetText()))
		net.SendToServer()
	end
	net.Receive("usergroup_update_string_name", function(len2)
		local string_name = net.ReadString()
		UGS[CURRENT_USERGROUP].string_name = string.upper(string_name)
		NAME:SetText(string.upper(UGS[CURRENT_USERGROUP].string_name))
	end)

	-- COLOR
	local COLOR = createD("DYRPPanelPlus", PARENT, YRP.ctr(500), YRP.ctr(100), YRP.ctr(20), YRP.ctr(20 + 100 + 20))
	COLOR:INITPanel("YButton")
	COLOR:SetHeader(YRP.lang_string("LID_color"))
	COLOR.plus:SetText("LID_change")
	function COLOR.plus:Paint(pw, ph)
		if wk(UGS[CURRENT_USERGROUP]) then
			hook.Run("YButtonPaint", self, pw, ph)--surfaceButton(self, pw, ph, YRP.lang_string("LID_change"), StringToColor(UGS[CURRENT_USERGROUP].string_color))
		end
	end
	function COLOR.plus:DoClick()
		local window = createD("DFrame", nil, YRP.ctr(20 + 500 + 20), YRP.ctr(50 + 20 + 500 + 20), 0, 0)
		window:Center()
		window:MakePopup()
		window:SetTitle("")
		function window:Paint(pw, ph)
			surfaceWindow(self, pw, ph, YRP.lang_string("LID_color"))
			if !pa(PARENT) then
				self:Remove()
			end
		end
		window.cm = createD("DColorMixer", window, YRP.ctr(500), YRP.ctr(500), YRP.ctr(20), YRP.ctr(50 + 20))
		function window.cm:ValueChanged(col)
			UGS[CURRENT_USERGROUP].string_color = TableToColorStr(col)
			net.Start("usergroup_update_string_color")
				net.WriteString(CURRENT_USERGROUP)
				net.WriteString(UGS[CURRENT_USERGROUP].string_color)
			net.SendToServer()
		end
	end
	net.Receive("usergroup_update_string_color", function(len2)
		local color = net.ReadString()
		if wk(UGS[CURRENT_USERGROUP]) then
			UGS[CURRENT_USERGROUP].string_color = color
		end
	end)

	-- ICON
	UGS[CURRENT_USERGROUP].ICON = createD("DYRPPanelPlus", PARENT, YRP.ctr(500), YRP.ctr(100), YRP.ctr(20), YRP.ctr(20 + 100 + 20 + 100 + 20))
	local ICON = UGS[CURRENT_USERGROUP].ICON
	ICON:INITPanel("DTextEntry")
	ICON:SetHeader(YRP.lang_string("LID_icon"))
	ICON:SetText(ug.string_icon)
	function ICON.plus:OnChange()
		UGS[CURRENT_USERGROUP].string_icon = self:GetText()
		net.Start("usergroup_update_icon")
			net.WriteString(CURRENT_USERGROUP)
			net.WriteString(self:GetText())
		net.SendToServer()
	end
	net.Receive("usergroup_update_icon", function(len2)
		local string_icon = net.ReadString()
		UGS[CURRENT_USERGROUP].string_icon = string_icon
		ICON:SetText(UGS[CURRENT_USERGROUP].string_icon)

		local HTMLCODE = GetHTMLImage(UGS[CURRENT_USERGROUP].string_icon, _icon.size, _icon.size)
		local icon = UGS[tonumber(tbl.uniqueID)].icon
		if strEmpty(HTMLCODE) then
			icon:SetHTML("")
		else
			icon:SetHTML(HTMLCODE)
		end
		TestHTML(icon, UGS[CURRENT_USERGROUP].string_icon, false)
	end)

	-- SWEPS
	ug.string_sweps = string.Explode(",", ug.string_sweps)
	local tmp = {}
	for i, v in pairs(ug.string_sweps) do
		if v != nil and !strEmpty(v) then
			table.insert(tmp, v)
		end
	end
	ug.string_sweps = tmp

	local SWEPS = createD("DYRPPanelPlus", PARENT, YRP.ctr(500), YRP.ctr(50 + 500 + 50), YRP.ctr(20), YRP.ctr(20 + 100 + 20 + 100 + 20 + 100 + 20))
	SWEPS:INITPanel("DPanel")
	SWEPS:SetHeader(YRP.lang_string("LID_weapons"))
	SWEPS:SetText(ug.string_icon)
	function SWEPS.plus:Paint(pw, ph)
		surfaceBox(0, 0, pw, ph, Color(80, 80, 80, 255))
	end

	SWEPS.preview = createD("DModelPanel", SWEPS, YRP.ctr(500), YRP.ctr(500), YRP.ctr(0), YRP.ctr(50))
	if ug.string_sweps[1] != nil then
		SWEPS.preview:SetModel(GetSWEPWorldModel(ug.string_sweps[1]))
		SWEPS.preview.cur = 1
		SWEPS.preview.max = #ug.string_sweps
	else
		SWEPS.preview.cur = 0
		SWEPS.preview.max = 0
	end
	SWEPS.preview:SetLookAt(Vector(0, 0, 10))
	SWEPS.preview:SetCamPos(Vector(0, 0, 10) - Vector(-40, -20, -20))
	SWEPS.preview:SetAnimated(true)
	SWEPS.preview.Angles = Angle(0, 0, 0)
	function SWEPS.preview:DragMousePress()
		self.PressX, self.PressY = gui.MousePos()
		self.Pressed = true
	end
	function SWEPS.preview:DragMouseRelease()
		self.Pressed = false
	end
	function SWEPS.preview:LayoutEntity(ent)
		if (self.bAnimated) then self:RunAnimation() end
		if (self.Pressed) then
			local mx = gui.MousePos()
			self.Angles = self.Angles - Angle(0, (self.PressX or mx) - mx, 0)
			self.PressX, self.PressY = gui.MousePos()
			if ent != nil then
				ent:SetAngles(self.Angles)
			end
		end
	end
	function SWEPS.preview:PaintOver(pw, ph)
		if wk(UGS[CURRENT_USERGROUP]) then
			if self.oldcur != self.cur then
				self.oldcur = self.cur
				self:SetModel(GetSWEPWorldModel(UGS[CURRENT_USERGROUP].string_sweps[self.cur]))
			end
			surfaceText(self.cur .. "/" .. self.max, "Y_18_500", pw / 2, ph - YRP.ctr(30), Color(255, 255, 255), 1, 1)
			surfaceText(UGS[CURRENT_USERGROUP].string_sweps[self.cur] or "NOMODEL", "Y_18_500", pw / 2, ph - YRP.ctr(70), Color(255, 255, 255), 1, 1)
		end
	end

	SWEPS.preview.prev = createD("YButton", SWEPS.preview, YRP.ctr(50), YRP.ctr(50), YRP.ctr(0), YRP.ctr(500 - 50) / 2)
	SWEPS.preview.prev:SetText("")
	function SWEPS.preview.prev:Paint(pw, ph)
		if SWEPS.preview.cur > 1 then
			surfaceButton(self, pw, ph, YRP.lang_string("<"))
		end
	end
	function SWEPS.preview.prev:DoClick()
		if SWEPS.preview.cur > 1 then
			SWEPS.preview.cur = SWEPS.preview.cur - 1
		end
	end

	SWEPS.preview.next = createD("YButton", SWEPS.preview, YRP.ctr(50), YRP.ctr(50), YRP.ctr(500 - 50), YRP.ctr(500 - 50) / 2)
	SWEPS.preview.next:SetText("")
	function SWEPS.preview.next:Paint(pw, ph)
		if SWEPS.preview.cur < SWEPS.preview.max then
			surfaceButton(self, pw, ph, YRP.lang_string(">"))
		end
	end
	function SWEPS.preview.next:DoClick()
		if SWEPS.preview.cur < SWEPS.preview.max then
			SWEPS.preview.cur = SWEPS.preview.cur + 1
		end
	end

	SWEPS.button = createD("YButton", SWEPS, YRP.ctr(500), YRP.ctr(50), YRP.ctr(0), YRP.ctr(50 + 500))
	SWEPS.button:SetText("LID_change")
	function SWEPS.button:Paint(pw, ph)
		hook.Run("YButtonPaint", self, pw, ph)--surfaceButton(self, pw, ph, YRP.lang_string("LID_change"))
	end
	hook.Add("selector_usergroup_string_sweps", "selector_usergroup_string_sweps", function()
		local lply = LocalPlayer()
		if lply.global_working != nil then
			local string_sweps = lply.global_working
			if wk(string_sweps) then
				net.Start("usergroup_update_string_sweps")
					net.WriteString(CURRENT_USERGROUP)
					net.WriteString(string_sweps)
				net.SendToServer()
			end
		end
	end)
	function SWEPS.button:DoClick()
		OpenSelector(GetSWEPsList(), ug.string_sweps, "selector_usergroup_string_sweps")
	end

	net.Receive("usergroup_update_string_sweps", function(len2)
		if pa(SWEPS) then
			local string_sweps = net.ReadString()

			UGS[CURRENT_USERGROUP].string_sweps = string.Explode(",", string_sweps)
			local tmp2 = {}
			for i, v in pairs(ug.string_sweps) do
				if v != nil and !strEmpty(v) then
					table.insert(tmp2, v)
				end
			end
			UGS[CURRENT_USERGROUP].string_sweps = tmp2

			if UGS[CURRENT_USERGROUP].string_sweps[1] != "" then
				SWEPS.preview.cur = 1
				SWEPS.preview.max = #UGS[CURRENT_USERGROUP].string_sweps
				SWEPS.preview:SetModel(GetSWEPWorldModel(UGS[CURRENT_USERGROUP].string_sweps[1] or ""))
			else
				SWEPS.preview.cur = 0
				SWEPS.preview.max = 0
				SWEPS.preview:SetModel("")
			end
		end
	end)



	-- NONEDROPPABLESWEPS
	ug.string_nonesweps = string.Explode(",", ug.string_nonesweps)
	local tmp = {}
	for i, v in pairs(ug.string_nonesweps) do
		if v != nil and !strEmpty(v) then
			table.insert(tmp, v)
		end
	end
	ug.string_nonesweps = tmp

	local NONESWEPS = createD("DYRPPanelPlus", PARENT, YRP.ctr(500), YRP.ctr(50 + 500 + 50), YRP.ctr(20), YRP.ctr(20 + 100 + 20 + 100 + 20 + 100 + 20 + 500 + 50 + 50 + 20))
	NONESWEPS:INITPanel("DPanel")
	NONESWEPS:SetHeader(YRP.lang_string("LID_ndsweps"))
	NONESWEPS:SetText(ug.string_icon)
	function NONESWEPS.plus:Paint(pw, ph)
		surfaceBox(0, 0, pw, ph, Color(80, 80, 80, 255))
	end

	NONESWEPS.preview = createD("DModelPanel", NONESWEPS, YRP.ctr(500), YRP.ctr(500), YRP.ctr(0), YRP.ctr(50))
	if ug.string_nonesweps[1] != nil then
		NONESWEPS.preview:SetModel(GetSWEPWorldModel(ug.string_nonesweps[1]))
		NONESWEPS.preview.cur = 1
		NONESWEPS.preview.max = #ug.string_nonesweps
	else
		NONESWEPS.preview.cur = 0
		NONESWEPS.preview.max = 0
	end
	NONESWEPS.preview:SetLookAt(Vector(0, 0, 10))
	NONESWEPS.preview:SetCamPos(Vector(0, 0, 10) - Vector(-40, -20, -20))
	NONESWEPS.preview:SetAnimated(true)
	NONESWEPS.preview.Angles = Angle(0, 0, 0)
	function NONESWEPS.preview:DragMousePress()
		self.PressX, self.PressY = gui.MousePos()
		self.Pressed = true
	end
	function NONESWEPS.preview:DragMouseRelease()
		self.Pressed = false
	end
	function NONESWEPS.preview:LayoutEntity(ent)
		if (self.bAnimated) then self:RunAnimation() end
		if (self.Pressed) then
			local mx = gui.MousePos()
			self.Angles = self.Angles - Angle(0, (self.PressX or mx) - mx, 0)
			self.PressX, self.PressY = gui.MousePos()
			if ent != nil then
				ent:SetAngles(self.Angles)
			end
		end
	end
	function NONESWEPS.preview:PaintOver(pw, ph)
		if wk(UGS[CURRENT_USERGROUP]) then
			if self.oldcur != self.cur then
				self.oldcur = self.cur
				self:SetModel(GetSWEPWorldModel(UGS[CURRENT_USERGROUP].string_nonesweps[self.cur]))
			end
			surfaceText(self.cur .. "/" .. self.max, "Y_18_500", pw / 2, ph - YRP.ctr(30), Color(255, 255, 255), 1, 1)
			surfaceText(UGS[CURRENT_USERGROUP].string_nonesweps[self.cur] or "NOMODEL", "Y_18_500", pw / 2, ph - YRP.ctr(70), Color(255, 255, 255), 1, 1)
		end
	end

	NONESWEPS.preview.prev = createD("YButton", NONESWEPS.preview, YRP.ctr(50), YRP.ctr(50), YRP.ctr(0), YRP.ctr(500 - 50) / 2)
	NONESWEPS.preview.prev:SetText("")
	function NONESWEPS.preview.prev:Paint(pw, ph)
		if NONESWEPS.preview.cur > 1 then
			surfaceButton(self, pw, ph, YRP.lang_string("<"))
		end
	end
	function NONESWEPS.preview.prev:DoClick()
		if NONESWEPS.preview.cur > 1 then
			NONESWEPS.preview.cur = NONESWEPS.preview.cur - 1
		end
	end

	NONESWEPS.preview.next = createD("YButton", NONESWEPS.preview, YRP.ctr(50), YRP.ctr(50), YRP.ctr(500 - 50), YRP.ctr(500 - 50) / 2)
	NONESWEPS.preview.next:SetText("")
	function NONESWEPS.preview.next:Paint(pw, ph)
		if NONESWEPS.preview.cur < NONESWEPS.preview.max then
			surfaceButton(self, pw, ph, YRP.lang_string(">"))
		end
	end
	function NONESWEPS.preview.next:DoClick()
		if NONESWEPS.preview.cur < NONESWEPS.preview.max then
			NONESWEPS.preview.cur = NONESWEPS.preview.cur + 1
		end
	end

	NONESWEPS.button = createD("YButton", NONESWEPS, YRP.ctr(500), YRP.ctr(50), YRP.ctr(0), YRP.ctr(50 + 500))
	NONESWEPS.button:SetText("LID_change")
	function NONESWEPS.button:Paint(pw, ph)
		hook.Run("YButtonPaint", self, pw, ph)--surfaceButton(self, pw, ph, YRP.lang_string("LID_change"))
	end
	hook.Add("selector_usergroup_string_nonesweps", "selector_usergroup_string_nonesweps", function()
		local lply = LocalPlayer()
		if lply.global_working != nil then
			local string_nonesweps = lply.global_working
			if wk(string_nonesweps) then
				net.Start("usergroup_update_string_nonesweps")
					net.WriteString(CURRENT_USERGROUP)
					net.WriteString(string_nonesweps)
				net.SendToServer()
			end
		end
	end)
	function NONESWEPS.button:DoClick()
		OpenSelector(GetSWEPsList(), ug.string_nonesweps, "selector_usergroup_string_nonesweps")
	end

	net.Receive("usergroup_update_string_nonesweps", function(len2)
		if pa(NONESWEPS) then
			local string_nonesweps = net.ReadString()

			UGS[CURRENT_USERGROUP].string_nonesweps = string.Explode(",", string_nonesweps)
			local tmp2 = {}
			for i, v in pairs(ug.string_nonesweps) do
				if v != nil and !strEmpty(v) then
					table.insert(tmp2, v)
				end
			end
			UGS[CURRENT_USERGROUP].string_nonesweps = tmp2

			if UGS[CURRENT_USERGROUP].string_nonesweps[1] != "" then
				NONESWEPS.preview.cur = 1
				NONESWEPS.preview.max = #UGS[CURRENT_USERGROUP].string_nonesweps
				NONESWEPS.preview:SetModel(GetSWEPWorldModel(UGS[CURRENT_USERGROUP].string_nonesweps[1] or ""))
			else
				NONESWEPS.preview.cur = 0
				NONESWEPS.preview.max = 0
				NONESWEPS.preview:SetModel("")
			end
		end
	end)



	-- Licenses
	local LICENSES = createD("DYRPPanelPlus", PARENT, YRP.ctr(500), YRP.ctr(50 + 500), YRP.ctr(20 + 500 + 20), YRP.ctr(20))
	LICENSES:INITPanel("DPanelList")
	LICENSES:SetHeader(YRP.lang_string("LID_licenses"))
	LICENSES:SetText(ug.string_icon)
	function LICENSES.plus:Paint(pw, ph)
		surfaceBox(0, 0, pw, ph, Color(80, 80, 80, 255))
	end
	LICENSES.plus:EnableVerticalScrollbar(true)
	
	UGS[CURRENT_USERGROUP].string_licenses = string.Explode(",", UGS[CURRENT_USERGROUP].string_licenses)
	if table.HasValue(UGS[CURRENT_USERGROUP].string_licenses, "") then
		table.RemoveByValue(UGS[CURRENT_USERGROUP].string_licenses, "")
	end

	net.Receive("get_usergroup_licenses", function()
		local licenses = net.ReadTable()

		for i, lic in pairs(licenses) do
			local line = createD("DPanel", nil, 10, YRP.ctr(50), 0, 0)
			function line:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, Color(55, 55, 55))
				draw.SimpleText(SQL_STR_OUT(lic.name), "Y_14_500", ph + YRP.ctr(10), ph / 2, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
			local cb = createD("DCheckBox", line, YRP.ctr(50), YRP.ctr(50), 0, 0)
			if table.HasValue(UGS[CURRENT_USERGROUP].string_licenses, lic.uniqueID) then
				cb:SetChecked(true)
			end
			function cb:OnChange(bVal)
				if bVal then
					table.insert(UGS[CURRENT_USERGROUP].string_licenses, lic.uniqueID)
				else
					table.RemoveByValue(UGS[CURRENT_USERGROUP].string_licenses, lic.uniqueID)
				end

				local str = table.concat(UGS[CURRENT_USERGROUP].string_licenses, ",")

				net.Start("usergroup_update_string_licenses")
					net.WriteString(CURRENT_USERGROUP)
					net.WriteString(str)
				net.SendToServer()
			end
			
			LICENSES.plus:AddItem(line)
		end
	end)

	net.Start("get_usergroup_licenses")
	net.SendToServer()



	-- YTools
	local YTOOLS = createD("DYRPPanelPlus", PARENT, YRP.ctr(500), YRP.ctr(50 + 500), YRP.ctr(20 + 500 + 20), YRP.ctr(20 + 550 + 20))
	YTOOLS:INITPanel("DPanelList")
	YTOOLS:SetHeader(YRP.lang_string("LID_tools"))
	YTOOLS:SetText(ug.string_icon)
	function YTOOLS.plus:Paint(pw, ph)
		surfaceBox(0, 0, pw, ph, Color(80, 80, 80, 255))
	end
	YTOOLS.plus:EnableVerticalScrollbar(true)

	UGS[CURRENT_USERGROUP].string_tools = string.Explode(",", UGS[CURRENT_USERGROUP].string_tools)
	if table.HasValue(UGS[CURRENT_USERGROUP].string_tools, "") then
		table.RemoveByValue(UGS[CURRENT_USERGROUP].string_tools, "")
	end

	local line = createD("DPanel", nil, 10, YRP.ctr(50), 0, 0)
	function line:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(55, 55, 55))
		draw.SimpleText("all", "Y_14_500", ph + YRP.ctr(10), ph / 2, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	local cb = createD("DCheckBox", line, YRP.ctr(50), YRP.ctr(50), 0, 0)
	if table.HasValue(UGS[CURRENT_USERGROUP].string_tools, "all") then
		cb:SetChecked(true)
	end
	function cb:OnChange(bVal)
		if bVal then
			table.insert(UGS[CURRENT_USERGROUP].string_tools, "all")
		else
			table.RemoveByValue(UGS[CURRENT_USERGROUP].string_tools, "all")
		end

		local str = table.concat(UGS[CURRENT_USERGROUP].string_tools, ",")

		net.Start("usergroup_update_string_tools")
			net.WriteString(CURRENT_USERGROUP)
			net.WriteString(str)
		net.SendToServer()
	end
	YTOOLS.plus:AddItem(line)

	local tools = spawnmenu.GetTools()
	for i, cat in pairs(tools) do
		for j, cat2 in pairs(cat.Items) do
			for k, too in pairs(cat2) do
				if type(too) == "table" then
					too.ItemName = string.lower(too.ItemName)
					local line = createD("DPanel", nil, 10, YRP.ctr(50), 0, 0)
					function line:Paint(pw, ph)
						draw.RoundedBox(0, 0, 0, pw, ph, Color(55, 55, 55))
						draw.SimpleText(too.ItemName, "Y_14_500", ph + YRP.ctr(10), ph / 2, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					end
					local cb = createD("DCheckBox", line, YRP.ctr(50), YRP.ctr(50), 0, 0)
					if table.HasValue(UGS[CURRENT_USERGROUP].string_tools, too.ItemName) then
						cb:SetChecked(true)
					end
					function cb:OnChange(bVal)
						if bVal then
							table.insert(UGS[CURRENT_USERGROUP].string_tools, too.ItemName)
						else
							table.RemoveByValue(UGS[CURRENT_USERGROUP].string_tools, too.ItemName)
						end

						local str = table.concat(UGS[CURRENT_USERGROUP].string_tools, ",")

						net.Start("usergroup_update_string_tools")
							net.WriteString(CURRENT_USERGROUP)
							net.WriteString(str)
						net.SendToServer()
					end
					
					YTOOLS.plus:AddItem(line)
				end
			end
		end
	end
	local properties = {
		"ignite",
		"extinguish",
		"remover",
		"drive",
		"collision",
		"keepupright",
		"bodygroups",
		"gravity",
		"persist"
	}
	for i, v in pairs(properties) do
		local line = createD("DPanel", nil, 10, YRP.ctr(50), 0, 0)
		function line:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(55, 55, 55))
			draw.SimpleText(v, "Y_14_500", ph + YRP.ctr(10), ph / 2, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
		local cb = createD("DCheckBox", line, YRP.ctr(50), YRP.ctr(50), 0, 0)
		if table.HasValue(UGS[CURRENT_USERGROUP].string_tools, v) then
			cb:SetChecked(true)
		end
		function cb:OnChange(bVal)
			if bVal then
				table.insert(UGS[CURRENT_USERGROUP].string_tools, v)
			else
				table.RemoveByValue(UGS[CURRENT_USERGROUP].string_tools, v)
			end

			local str = table.concat(UGS[CURRENT_USERGROUP].string_tools, ",")

			net.Start("usergroup_update_string_tools")
				net.WriteString(CURRENT_USERGROUP)
				net.WriteString(str)
			net.SendToServer()
		end
		
		YTOOLS.plus:AddItem(line)
	end



	-- ENTITIES
	--[[
	ug.string_sents = string.Explode(";", ug.string_sents)

	ug.dstring_sents = {}
	ug.cur_sent = nil

	local ENTITIES = createD("DYRPPanelPlus", PARENT, YRP.ctr(500), YRP.ctr(50 + 500), YRP.ctr(20), YRP.ctr(20 + 100 + 20 + 100 + 20 + 100 + 20 + 600 + 20))
	ENTITIES:INITPanel("DPanelList")
	ENTITIES:SetHeader(YRP.lang_string("LID_entities") .. " [" .. YRP.lang_string("LID_wip") .. "]")
	ENTITIES:SetText(ug.string_icon)
	function ENTITIES.plus:Paint(pw, ph)
		surfaceBox(0, 0, pw, ph, Color(80, 80, 80, 255))
	end
	ENTITIES.plus:EnableVerticalScrollbar(true)

	function AddSENT(amount, cname)
		if amount != nil and cname != nil then
			cname = tostring(cname)
			amount = tonumber(amount)
			if ug.dstring_sents[cname] == nil then
				ug.dstring_sents[cname] = createD("YButton", ENTITIES.plus, ENTITIES.plus:GetWide(), YRP.ctr(100), 0, 0)
				local SENT = ug.dstring_sents[cname]
				SENT:SetText("")
				SENT.cname = cname
				SENT.amount = amount
				function SENT:Paint(pw, ph)
					surfaceButton(self, pw, ph, "[" .. self.amount .. "x] " .. self.cname, nil, YRP.ctr(50 + 10 + 10), ph / 2, 0, 1)
					if self.cname == ug.cur_sent then
						surfaceSelected(self, pw - YRP.ctr(50), ph, YRP.ctr(50))
					end
				end
				function SENT:DoClick()
					ug.cur_sent = self.cname
				end

				SENT.UP = createD("YButton", SENT, YRP.ctr(50), YRP.ctr(50), 0, 0)
				SENT.UP:SetText("")
				function SENT.UP:Paint(pw, ph)
					if SENT.amount < 100 then
						surfaceButton(self, pw, ph, "↑")
					end
				end
				function SENT.UP:DoClick()
					if SENT.amount < 100 then
						net.Start("usergroup_sent_up")
							net.WriteString(CURRENT_USERGROUP)
							net.WriteString(SENT.cname)
						net.SendToServer()
					end
				end
				net.Receive("usergroup_sent_up", function(len2)
					local string_sents = net.ReadString()
					string_sents = SENTSTable(string_sents)
					for cna, amo in pairs(string_sents) do
						ug.dstring_sents[cna].amount = tonumber(amo)
					end
				end)

				SENT.DN = createD("YButton", SENT, YRP.ctr(50), YRP.ctr(50), 0, YRP.ctr(50))
				SENT.DN:SetText("")
				function SENT.DN:Paint(pw, ph)
					if SENT.amount > 1 then
						surfaceButton(self, pw, ph, "↓")
					end
				end
				function SENT.DN:DoClick()
					if SENT.amount > 1 then
						net.Start("usergroup_sent_dn")
							net.WriteString(CURRENT_USERGROUP)
							net.WriteString(SENT.cname)
						net.SendToServer()
					end
				end
				net.Receive("usergroup_sent_dn", function(len2)
					local string_sents = net.ReadString()
					string_sents = SENTSTable(string_sents)
					for cna, amo in pairs(string_sents) do
						ug.dstring_sents[cna].amount = tonumber(amo)
					end
				end)

				ENTITIES.plus:AddItem(SENT)
			end
		end
	end

	for i, sent in pairs(ug.string_sents) do
		if sent != "" then
			sent = string.Explode(",", sent)
			AddSENT(sent[1], sent[2])
		end
	end

	ENTITIES.add = createD("YButton", PARENT, YRP.ctr(250), YRP.ctr(50), YRP.ctr(20), YRP.ctr(20 + 100 + 20 + 100 + 20 + 100 + 20 + 600 + 20 + 550))
	ENTITIES.add:SetText("")
	function ENTITIES.add:Paint(pw, ph)
		surfaceButton(self, pw, ph, "+", Color(0, 255, 0, 255))
	end
	function ENTITIES.add:DoClick()
		OpenSingleSelector(GetSENTsList(), "selector_usergroup_string_sents")
		hook.Add("selector_usergroup_string_sents", "selector_usergroup_string_sents", function()
			local sent = ply:GetDString("ClassName", "")

			net.Start("usergroup_add_sent")
				net.WriteString(CURRENT_USERGROUP)
				net.WriteString(sent)
			net.SendToServer()
		end)
	end
	net.Receive("usergroup_add_sent", function(len2)
		local string_sents = net.ReadString()
		string_sents = string.Explode(";", string_sents)
		for i, sent in pairs(string_sents) do
			sent = string.Explode(",", sent)
			AddSENT(sent[1], sent[2])
		end
	end)

	ENTITIES.rem = createD("YButton", PARENT, YRP.ctr(250), YRP.ctr(50), YRP.ctr(20 + 250), YRP.ctr(20 + 100 + 20 + 100 + 20 + 100 + 20 + 600 + 20 + 550))
	ENTITIES.rem:SetText("")
	function ENTITIES.rem:Paint(pw, ph)
		if ug.cur_sent != nil then
			surfaceButton(self, pw, ph, "-", Color(255, 0, 0, 255))
		end
	end
	function ENTITIES.rem:DoClick()
		if ug.cur_sent != nil then
			net.Start("usergroup_rem_sent")
				net.WriteString(CURRENT_USERGROUP)
				net.WriteString(ug.cur_sent)
			net.SendToServer()
		end
	end
	net.Receive("usergroup_rem_sent", function(len2)
		local cname = net.ReadString()
		ug.dstring_sents[cname]:Remove()
	end)
	]]



	local ACCESS = createD("YGroupBox", PARENT, YRP.ctr(800), ScrH() - YRP.ctr(100 + 10 + 10), YRP.ctr(20 + 500 + 20 + 500 + 20), YRP.ctr(20))
	ACCESS:SetText("LID_accesssettings")
	function ACCESS:Paint(pw, ph)
		hook.Run("YGroupBoxPaint", self, pw, ph)
	end
	ACCESS:AutoSize(true)

	function ACCESSAddCheckBox(name, lstr, color)
		local tmp = createD("DPanel", PARENT, YRP.ctr(800), YRP.ctr(50), 0, 0)
		function tmp:Paint(pw, ph)
			surfacePanel(self, pw, ph, YRP.lang_string(lstr), color, YRP.ctr(50 + 10), nil, 0, 1)
		end
		tmp.cb = createD("DCheckBox", tmp, YRP.ctr(50), YRP.ctr(50), 0, 0)
		tmp.cb:SetValue(ug[name])
		function tmp.cb:Paint(pw, ph)
			surfaceCheckBox(self, pw, ph, "done")
		end
		function tmp.cb:OnChange(bVal)
			if !self.serverside then
				net.Start("usergroup_update_" .. name)
					net.WriteString(CURRENT_USERGROUP)
					net.WriteString(btn(bVal))
				net.SendToServer()
			end
		end
		net.Receive("usergroup_update_" .. name, function(len2)
			local b = net.ReadString()
			if pa(tmp.cb) then
				tmp.cb.serverside = true
				tmp.cb:SetValue(b)
				tmp.cb.serverside = false
			end
		end)

		ACCESS:AddItem(tmp)
	end
	function ACCESSAddHr()
		local tmp = createD("DPanel", PARENT, YRP.ctr(800), YRP.ctr(4 + 4 + 4), 0, 0)
		function tmp:Paint(pw, ph)
			surfacePanel(self, pw, ph, "")
			surfaceBox(0, YRP.ctr(4), pw, YRP.ctr(4), Color(0, 0, 0, 255))
		end
		ACCESS:AddItem(tmp)
	end

	ACCESSAddCheckBox("bool_adminaccess", "LID_yrp_adminaccess", Color(255, 255, 0, 255))

	ACCESSAddHr()
	-- LID_usermanagement
	ACCESSAddCheckBox("bool_players", "LID_settings_players")
	ACCESSAddCheckBox("bool_whitelist", "LID_whitelist")

	ACCESSAddHr()
	-- LID_moderation
	ACCESSAddCheckBox("bool_status", "LID_settings_status")
	ACCESSAddCheckBox("bool_groupsandroles", "LID_settings_groupsandroles")
	ACCESSAddCheckBox("bool_map", "LID_settings_map")
	-- >> character 
	ACCESSAddCheckBox("bool_logs", "LID_logs")
	ACCESSAddCheckBox("bool_blacklist", "LID_blacklist")
	ACCESSAddCheckBox("bool_feedback", "LID_settings_feedback")

	ACCESSAddHr()
	-- LID_administration
	ACCESSAddCheckBox("bool_realistic", "LID_settings_realistic")
	ACCESSAddCheckBox("bool_shops", "LID_settings_shops")
	ACCESSAddCheckBox("bool_licenses", "LID_settings_licenses")
	ACCESSAddCheckBox("bool_usergroups", "LID_settings_usergroups", Color(255, 0, 0, 255))
	ACCESSAddCheckBox("bool_levelsystem", "LID_levelsystem")
	ACCESSAddCheckBox("bool_design", "LID_settings_design")
	ACCESSAddCheckBox("bool_scale", "LID_scale")
	ACCESSAddCheckBox("bool_money", "LID_money")
	
	ACCESSAddHr()
	-- LID_server
	ACCESSAddCheckBox("bool_general", "LID_settings_general")
	ACCESSAddCheckBox("bool_console", "LID_server_console", Color(255, 0, 0, 255))
	ACCESSAddCheckBox("bool_ac_database", "LID_settings_database", Color(255, 0, 0, 255))
	-- Socials [television.png]
	ACCESSAddCheckBox("bool_darkrp", "DarkRP", Color(255, 0, 0, 255))
	ACCESSAddCheckBox("bool_permaprops", "Perma Props", Color(255, 0, 0, 255))
	
	ACCESSAddHr()
	-- YourRP
	ACCESSAddCheckBox("bool_yourrp_addons", "LID_settings_yourrp_addons")

	local GAMEPLAY = createD("YGroupBox", PARENT, YRP.ctr(800), ScrH() - YRP.ctr(100 + 10 + 10), YRP.ctr(20 + 500 + 20 + 500 + 20 + 800 + 20), YRP.ctr(20))
	GAMEPLAY:SetText("LID_gameplayrestrictions")
	function GAMEPLAY:Paint(pw, ph)
		hook.Run("YGroupBoxPaint", self, pw, ph)
	end
	GAMEPLAY:AutoSize(true)

	function GAMEPLAYAddIntBox(name, lstr)
		local tmp = createD("DPanel", PARENT, GAMEPLAY:GetWide() - YRP.ctr(40), YRP.ctr(100), 0, 0)
		function tmp:Paint(pw, ph)
			--
		end

		tmp.lbl = createD("YLabel", tmp, tmp:GetWide(), YRP.ctr(50), 0, 0)
		tmp.lbl:SetText(lstr)

		tmp.cb = createD("DNumberWang", tmp, tmp:GetWide(), YRP.ctr(50), 0, YRP.ctr(50))
		tmp.cb:SetValue(ug[name])
		tmp.cb:SetMax(100)
		tmp.cb:SetMin(1)
		function tmp.cb:OnValueChanged(val)
			net.Start("usergroup_update_" .. name)
				net.WriteString(CURRENT_USERGROUP)
				net.WriteString(val)
			net.SendToServer()
		end

		GAMEPLAY:AddItem(tmp)
	end

	function GAMEPLAYAddCheckBox(name, lstr)
		local tmp = createD("DPanel", PARENT, YRP.ctr(800), YRP.ctr(50), 0, 0)
		function tmp:Paint(pw, ph)
			surfacePanel(self, pw, ph, YRP.lang_string(lstr), nil, YRP.ctr(50 + 10), nil, 0, 1)
		end
		tmp.cb = createD("DCheckBox", tmp, YRP.ctr(50), YRP.ctr(50), 0, 0)
		tmp.cb:SetValue(ug[name])
		function tmp.cb:Paint(pw, ph)
			surfaceCheckBox(self, pw, ph, "done")
		end
		function tmp.cb:OnChange(bVal)
			net.Start("usergroup_update_" .. name)
				net.WriteString(CURRENT_USERGROUP)
				net.WriteString(btn(bVal))
			net.SendToServer()
		end

		GAMEPLAY:AddItem(tmp)
	end
	function GAMEPLAYAddHr()
		local tmp = createD("DPanel", PARENT, YRP.ctr(800), YRP.ctr(4 + 4 + 4), 0, 0)
		function tmp:Paint(pw, ph)
			surfacePanel(self, pw, ph, "")
			surfaceBox(0, YRP.ctr(4), pw, YRP.ctr(4), Color(0, 0, 0, 255))
		end
		GAMEPLAY:AddItem(tmp)
	end
	GAMEPLAYAddCheckBox("bool_vehicles", "LID_gp_vehicles")
	GAMEPLAYAddCheckBox("bool_weapons", "LID_gp_weapons")
	GAMEPLAYAddCheckBox("bool_entities", "LID_gp_entities")
	GAMEPLAYAddCheckBox("bool_effects", "LID_gp_effects")
	GAMEPLAYAddCheckBox("bool_npcs", "LID_gp_npcs")
	GAMEPLAYAddCheckBox("bool_props", "LID_gp_props")
	GAMEPLAYAddCheckBox("bool_ragdolls", "LID_gp_ragdolls")
	GAMEPLAYAddCheckBox("bool_postprocess", "LID_gp_postprocess")
	GAMEPLAYAddCheckBox("bool_dupes", "LID_gp_dupes")
	GAMEPLAYAddCheckBox("bool_saves", "LID_gp_saves")
	GAMEPLAYAddHr()
	GAMEPLAYAddCheckBox("bool_noclip", "LID_gp_noclip")
	GAMEPLAYAddCheckBox("bool_flashlight", "LID_gp_flashlight")
	GAMEPLAYAddHr()
	GAMEPLAYAddCheckBox("bool_physgunpickup", "LID_gp_physgunpickup")
	GAMEPLAYAddCheckBox("bool_physgunpickupplayer", "LID_gp_physgunpickupplayers")
	GAMEPLAYAddCheckBox("bool_physgunpickupworld", "LID_gp_physgunpickupworld")
	GAMEPLAYAddCheckBox("bool_physgunpickupotherowner", "LID_gp_physgunpickupotherowner")
	GAMEPLAYAddCheckBox("bool_physgunpickupignoreblacklist", "LID_physgunpickupignoreblacklist")
	GAMEPLAYAddHr()
	GAMEPLAYAddCheckBox("bool_gravgunpunt", "LID_gravgunpunt")
	GAMEPLAYAddHr()
	GAMEPLAYAddCheckBox("bool_canseeteammatesonmap", "LID_gp_canseeteammatesonmap")
	GAMEPLAYAddCheckBox("bool_canseeenemiesonmap", "LID_gp_canseeenemiesonmap")
	GAMEPLAYAddHr()
	GAMEPLAYAddCheckBox("bool_canuseesp", "LID_gp_canuseesp")
	GAMEPLAYAddHr()
	GAMEPLAYAddCheckBox("bool_canusecontextmenu", "LID_gp_canusecontextmenu")
	GAMEPLAYAddCheckBox("bool_canusespawnmenu", "LID_gp_canusespawnmenu")

	GAMEPLAYAddHr()
	GAMEPLAYAddIntBox("int_characters_max", "LID_charactersmax")
end)

function AddUG(tbl)
	local PARENT = GetSettingsSite()

	UGS[tonumber(tbl.uniqueID)] = tbl

	DUGS[tonumber(tbl.uniqueID)] = createD("YButton", PARENT.ugs, PARENT.ugs:GetWide(), YRP.ctr(100), 0, 0)
	local _ug = DUGS[tonumber(tbl.uniqueID)]
	_ug.uid = tonumber(tbl.uniqueID)
	_ug:SetText("")
	function _ug:Paint(pw, ph)
		self.string_color = StringToColor(UGS[self.uid].string_color)
		local text = string.upper(UGS[self.uid].string_name) -- .. " " .. UGS[self.uid].int_position
		surfaceButton(self, pw, ph, text, self.string_color, ph + YRP.ctr(40 + 20), ph / 2, 0, 1, false)

		if strEmpty(UGS[tonumber(tbl.uniqueID)].string_icon) then
			surfaceBox(YRP.ctr(8) + YRP.ctr(40) + YRP.ctr(8), YRP.ctr(4), ph - YRP.ctr(8), ph - YRP.ctr(8), Color(255, 255, 255, 255))
		end
		if self.uid == tonumber(CURRENT_USERGROUP) then
			surfaceSelected(self, pw - YRP.ctr(40 + 8), ph, YRP.ctr(40 + 8))
		end
	end

	function _ug:DoClick()
		if CURRENT_USERGROUP != nil then
			net.Start("Disconnect_Settings_UserGroup")
				net.WriteString(CURRENT_USERGROUP)
			net.SendToServer()
		end
		net.Start("Connect_Settings_UserGroup")
			net.WriteString(self.uid)
		net.SendToServer()
	end

	local P = DUGS[tonumber(tbl.uniqueID)]
	P.int_position = tonumber(tbl.int_position)
	P.uniqueID = tonumber(tbl.uniqueID)

	local UP = createD("YButton", P, YRP.ctr(40), YRP.ctr(40), YRP.ctr(8), YRP.ctr(8))
	UP:SetText("")
	local up = UP
	function up:Paint(pw, ph)
		if P.int_position > 1 then
			hook.Run("YButtonPaint", self, pw, ph)

			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(YRP.GetDesignIcon("64_angle-up"))
			surface.DrawTexturedRect(0, 0, pw, ph)
		end
	end
	function up:DoClick()
		if P.int_position > 1 then
			net.Start("settings_usergroup_position_up")
				net.WriteString(P.uniqueID)
			net.SendToServer()
		end
	end

	local DO = createD("YButton", P, YRP.ctr(40), YRP.ctr(40), YRP.ctr(8), P:GetTall() - YRP.ctr(40 + 8))
	DO:SetText("")
	local dn = DO
	function dn:Paint(pw, ph)
		if P.int_position < table.Count(UGS) then
			hook.Run("YButtonPaint", self, pw, ph)

			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(YRP.GetDesignIcon("64_angle-down"))
			surface.DrawTexturedRect(0, 0, pw, ph)
		end
	end
	function dn:DoClick()
		if P.int_position < table.Count(UGS) then
			net.Start("settings_usergroup_position_dn")
				net.WriteString(P.uniqueID)
			net.SendToServer()
		end
	end

	--if !strEmpty(UGS[tonumber(tbl.uniqueID)].string_icon != "" then
		local HTMLCODE = GetHTMLImage(tbl.string_icon, _icon.size, _icon.size)
		UGS[tonumber(tbl.uniqueID)].icon = createD("DHTML", _ug, _icon.size, _icon.size, _icon.br + UP:GetWide() + _icon.br, _icon.br)
		local icon = UGS[tonumber(tbl.uniqueID)].icon
		if strEmpty(HTMLCODE) then
			icon:SetHTML("")
		else
			icon:SetHTML(HTMLCODE)
		end
		TestHTML(icon, tbl.string_icon, false)
	--end

	PARENT.ugs:AddItem(_ug)
end

function RemUG(uid)
	if CURRENT_USERGROUP != nil then
		net.Start("Disconnect_Settings_UserGroup")
			net.WriteString(CURRENT_USERGROUP)
		net.SendToServer()
	end

	DUGS[tonumber(uid)]:Remove()
end

net.Receive("usergroup_rem", function(len)
	local uid = tonumber(net.ReadString())
	if DUGS[uid] != nil then
		RemUG(uid)
	end
end)

net.Receive("usergroup_add", function(len)
	local ugs = net.ReadTable()
	for i, ug in SortedPairsByMemberValue(ugs, "int_position", false) do
		if DUGS[tonumber(ug.uniqueID)] == nil and tobool(ug.bool_removeable) then
			AddUG(ug)
		end
	end
end)

function UpdateUsergroupsList(ugs)
	local PARENT = GetSettingsSite()
	if pa(PARENT) then
		
		UGS = {}
		PARENT.ugs:Clear()

		for i, ug in SortedPairsByMemberValue(ugs, "int_position", false) do
			ug.int_position = tonumber(ug.int_position)
			if ug.int_position < 10 then
				if tobool(ug.bool_removeable) then
					AddUG(ug)
				end
			end
		end
		for i, ug in SortedPairsByMemberValue(ugs, "int_position", false) do
			if ug.int_position >= 10 then
				if tobool(ug.bool_removeable) then
					AddUG(ug)
				end
			end
		end
	end
end

net.Receive("UpdateUsergroupsList", function()
	_icon.size = YRP.ctr(100 - 16)
	_icon.br = YRP.ctr(8)

	local ugs = net.ReadTable()
	UpdateUsergroupsList(ugs)
end)

net.Receive("Connect_Settings_UserGroups", function(len)
	local PARENT = GetSettingsSite()
	if pa(PARENT) then		
		CURRENT_USERGROUP = nil

		local ugs = net.ReadTable()

		function PARENT:OnRemove()
			net.Start("Disconnect_Settings_UserGroups")
			net.SendToServer()
		end

		--[[ UserGroups Action Buttons ]]--
		local _ug_add = createD("YButton", PARENT, YRP.ctr(50), YRP.ctr(50), YRP.ctr(20), YRP.ctr(20))
		_ug_add:SetText("+")
		function _ug_add:Paint(pw, ph)
			hook.Run("YButtonAPaint", self, pw, ph) --surfaceButton(self, pw, ph, "+", Color(0, 255, 0, 255))
		end
		function _ug_add:DoClick()
			net.Start("usergroup_add")
			net.SendToServer()
		end
		
		local _ug_rem = createD("YButton", PARENT, YRP.ctr(50), YRP.ctr(50), YRP.ctr(20 + 500 - 50), YRP.ctr(20))
		_ug_rem:SetText("-")
		function _ug_rem:Paint(pw, ph)
			if wk(UGS[CURRENT_USERGROUP]) then
				if tobool(UGS[CURRENT_USERGROUP].bool_removeable) then
					hook.Run("YButtonRPaint", self, pw, ph)--surfaceButton(self, pw, ph, "-", Color(255, 0, 0, 255))
				end
			end
		end
		function _ug_rem:DoClick()
			if wk(UGS[CURRENT_USERGROUP]) then
				if tobool(UGS[CURRENT_USERGROUP].bool_removeable) then
					net.Start("usergroup_rem")
						net.WriteString(CURRENT_USERGROUP)
					net.SendToServer()
				end
			end
		end

		local _ugs_title = createD("DPanel", PARENT, YRP.ctr(500), YRP.ctr(50), YRP.ctr(20), YRP.ctr(20 + 50 + 20))
		function _ugs_title:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
			surfaceText(YRP.lang_string("LID_usergroups"), "Y_26_500", pw / 2, ph / 2, Color(0, 0, 0), 1, 1)
		end

		--[[ UserGroupsList ]]--
		PARENT.ugs = createD("DPanelList", PARENT, YRP.ctr(500), PARENT:GetTall() - YRP.ctr(2 * 20 + 120), YRP.ctr(20), YRP.ctr(20 + 50 + 20 + 50))
		function PARENT.ugs:Paint(pw, ph)
			surfaceBox(0, 0, pw, ph, Color(255, 255, 255, 255))
		end
		PARENT.ugs:EnableVerticalScrollbar(true)

		UpdateUsergroupsList(ugs)
	end
end)

function OpenSettingsUsergroups()
	net.Start("Connect_Settings_UserGroups")
	net.SendToServer()
end
