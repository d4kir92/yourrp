--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local ply = LocalPlayer()

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

	local PARENT = settingsWindow.window.site

	if pa(PARENT.ug) then
		PARENT.ug:Remove()
	end

	PARENT.ug = createD("DPanel", PARENT, ScrW() - YRP.ctr(20 + 500 + 20), ScrH() - YRP.ctr(100 + 10 + 10), YRP.ctr(20 + 500), YRP.ctr(0))
	function PARENT.ug:Paint(pw, ph)
		--surfaceBox(0, 0, pw, ph, Color(255, 255, 255, 100))
	end

	PARENT = PARENT.ug

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
	COLOR:INITPanel("DButton")
	COLOR:SetHeader(YRP.lang_string("LID_color"))
	COLOR.plus:SetText("")
	function COLOR.plus:Paint(pw, ph)
		if wk(UGS[CURRENT_USERGROUP]) then
			surfaceButton(self, pw, ph, YRP.lang_string("LID_change"), StringToColor(UGS[CURRENT_USERGROUP].string_color))
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
		UGS[CURRENT_USERGROUP].string_color = color
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

	SWEPS.preview.prev = createD("DButton", SWEPS.preview, YRP.ctr(50), YRP.ctr(50), YRP.ctr(0), YRP.ctr(500 - 50) / 2)
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

	SWEPS.preview.next = createD("DButton", SWEPS.preview, YRP.ctr(50), YRP.ctr(50), YRP.ctr(500 - 50), YRP.ctr(500 - 50) / 2)
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

	SWEPS.button = createD("DButton", SWEPS, YRP.ctr(500), YRP.ctr(50), YRP.ctr(0), YRP.ctr(50 + 500))
	SWEPS.button:SetText("")
	function SWEPS.button:Paint(pw, ph)
		surfaceButton(self, pw, ph, YRP.lang_string("LID_change"))
	end
	hook.Add("selector_usergroup_string_sweps", "selector_usergroup_string_sweps", function()
		ply = LocalPlayer()
		if ply.global_working != nil then
			local string_sweps = ply.global_working
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
				ug.dstring_sents[cname] = createD("DButton", ENTITIES.plus, ENTITIES.plus:GetWide(), YRP.ctr(100), 0, 0)
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

				SENT.UP = createD("DButton", SENT, YRP.ctr(50), YRP.ctr(50), 0, 0)
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

				SENT.DN = createD("DButton", SENT, YRP.ctr(50), YRP.ctr(50), 0, YRP.ctr(50))
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

	ENTITIES.add = createD("DButton", PARENT, YRP.ctr(250), YRP.ctr(50), YRP.ctr(20), YRP.ctr(20 + 100 + 20 + 100 + 20 + 100 + 20 + 600 + 20 + 550))
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

	ENTITIES.rem = createD("DButton", PARENT, YRP.ctr(250), YRP.ctr(50), YRP.ctr(20 + 250), YRP.ctr(20 + 100 + 20 + 100 + 20 + 100 + 20 + 600 + 20 + 550))
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



	local ACCESS = createD("YGroupBox", PARENT, YRP.ctr(800), ScrH() - YRP.ctr(100 + 10 + 10), YRP.ctr(20 + 500 + 20), YRP.ctr(20))
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

	local GAMEPLAY = createD("YGroupBox", PARENT, YRP.ctr(800), ScrH() - YRP.ctr(100 + 10 + 10), YRP.ctr(20 + 500 + 20 + 800 + 20), YRP.ctr(20))
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
	GAMEPLAYAddHr()
	GAMEPLAYAddCheckBox("bool_noclip", "LID_gp_noclip")
	GAMEPLAYAddCheckBox("bool_removetool", "LID_gp_removetool")
	GAMEPLAYAddCheckBox("bool_dynamitetool", "LID_gp_dynamitetool")
	GAMEPLAYAddCheckBox("bool_creatortool", "LID_gp_creatortool")
	GAMEPLAYAddCheckBox("bool_customfunctions", "LID_gp_customfunctions")
	GAMEPLAYAddCheckBox("bool_ignite", "LID_gp_ignite")
	GAMEPLAYAddCheckBox("bool_drive", "LID_gp_drive")
	GAMEPLAYAddCheckBox("bool_flashlight", "LID_gp_flashlight")
	GAMEPLAYAddHr()
	GAMEPLAYAddCheckBox("bool_collision", "LID_gp_collision")
	GAMEPLAYAddCheckBox("bool_gravity", "LID_gp_gravity")
	GAMEPLAYAddCheckBox("bool_keepupright", "LID_gp_keepupright")
	GAMEPLAYAddCheckBox("bool_bodygroups", "LID_gp_bodygroups")
	GAMEPLAYAddHr()
	GAMEPLAYAddCheckBox("bool_physgunpickup", "LID_gp_physgunpickup")
	GAMEPLAYAddCheckBox("bool_physgunpickupplayer", "LID_gp_physgunpickupplayers")
	GAMEPLAYAddCheckBox("bool_physgunpickupworld", "LID_gp_physgunpickupworld")
	GAMEPLAYAddCheckBox("bool_physgunpickupotherowner", "LID_gp_physgunpickupotherowner")
	GAMEPLAYAddHr()
	GAMEPLAYAddCheckBox("bool_canseeteammatesonmap", "LID_gp_canseeteammatesonmap")
	GAMEPLAYAddCheckBox("bool_canseeenemiesonmap", "LID_gp_canseeenemiesonmap")
	GAMEPLAYAddHr()
	GAMEPLAYAddCheckBox("bool_canseefrequency", "LID_canseefrequencys")
	GAMEPLAYAddHr()
	GAMEPLAYAddCheckBox("bool_canuseesp", "LID_gp_canuseesp")
	GAMEPLAYAddHr()
	GAMEPLAYAddCheckBox("bool_canusecontextmenu", "LID_gp_canusecontextmenu")
	GAMEPLAYAddCheckBox("bool_canusespawnmenu", "LID_gp_canusespawnmenu")

	GAMEPLAYAddHr()
	GAMEPLAYAddIntBox("int_characters_max", "LID_charactersmax")
end)

function AddUG(tbl)
	local PARENT = settingsWindow.window.site

	UGS[tonumber(tbl.uniqueID)] = tbl

	DUGS[tonumber(tbl.uniqueID)] = createD("DButton", PARENT.ugs, PARENT.ugs:GetWide(), YRP.ctr(100), 0, 0)
	local _ug = DUGS[tonumber(tbl.uniqueID)]
	_ug.uid = tonumber(tbl.uniqueID)
	_ug:SetText("")
	function _ug:Paint(pw, ph)
		self.string_color = StringToColor(UGS[self.uid].string_color)
		surfaceButton(self, pw, ph, string.upper(UGS[self.uid].string_name), self.string_color, ph + YRP.ctr(40 + 20), ph / 2, 0, 1, false)

		if strEmpty(UGS[tonumber(tbl.uniqueID)].string_icon) then
			surfaceBox(YRP.ctr(8) + YRP.ctr(40) + YRP.ctr(8), YRP.ctr(4), ph - YRP.ctr(8), ph - YRP.ctr(8), Color(255, 255, 255, 255))
		end
		if self.uid == tonumber(CURRENT_USERGROUP) then
			surfaceSelected(self, pw - YRP.ctr(40), ph, YRP.ctr(40))
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

	local UP = createD("DButton", P, YRP.ctr(40), P:GetTall() / 2 - YRP.ctr(15), YRP.ctr(10), YRP.ctr(10))
	UP:SetText("")
	local up = UP
	function up:Paint(pw, ph)
		if P.int_position > 2 then
			local tab = {}
			tab.r = pw / 2
			tab.color = Color(255, 255, 100)
			DrawPanel(self, tab)
			local tab2 = {}
			tab2.x = pw / 2
			tab2.y = ph / 2
			tab2.ax = 1
			tab2.ay = 1
			tab2.text = "▲"
			tab2.font = "Y_18_500"
			DrawText(tab2)
		end
	end
	function up:DoClick()
		if P.int_position > 2 then
			net.Start("settings_usergroup_position_up")
				net.WriteString(P.uniqueID)
			net.SendToServer()
		end
	end

	local DO = createD("DButton", P, YRP.ctr(40), P:GetTall() / 2 - YRP.ctr(15), YRP.ctr(10), P:GetTall() / 2 + YRP.ctr(5))
	DO:SetText("")
	local dn = DO
	function dn:Paint(pw, ph)
		if P.int_position <= table.Count(UGS) then
			local tab = {}
			tab.r = pw / 2
			tab.color = Color(255, 255, 100)
			DrawPanel(self, tab)
			local tab2 = {}
			tab2.x = pw / 2
			tab2.y = ph / 2
			tab2.ax = 1
			tab2.ay = 1
			tab2.text = "▼"
			tab2.font = "Y_18_500"
			DrawText(tab2)
		end
	end
	function dn:DoClick()
		if P.int_position <= table.Count(UGS) then
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
	if pa(settingsWindow) then
		local PARENT = settingsWindow.window.site
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
end

net.Receive("UpdateUsergroupsList", function()
	_icon.size = YRP.ctr(100 - 16)
	_icon.br = YRP.ctr(8)

	local ugs = net.ReadTable()
	UpdateUsergroupsList(ugs)
end)

net.Receive("Connect_Settings_UserGroups", function(len)
	if pa(settingsWindow) then
		if settingsWindow.window != nil then

			CURRENT_USERGROUP = nil

			local ugs = net.ReadTable()

			local PARENT = settingsWindow.window.site

			function PARENT:OnRemove()
				net.Start("Disconnect_Settings_UserGroups")
				net.SendToServer()
			end

			--[[ UserGroups Action Buttons ]]--
			local _ug_add = createD("DButton", PARENT, YRP.ctr(50), YRP.ctr(50), YRP.ctr(20), YRP.ctr(20))
			_ug_add:SetText("")
			function _ug_add:Paint(pw, ph)
				surfaceButton(self, pw, ph, "+", Color(0, 255, 0, 255))
			end
			function _ug_add:DoClick()
				net.Start("usergroup_add")
				net.SendToServer()
			end

			local _ug_rem = createD("DButton", PARENT, YRP.ctr(50), YRP.ctr(50), YRP.ctr(20 + 500 - 50), YRP.ctr(20))
			_ug_rem:SetText("")
			function _ug_rem:Paint(pw, ph)
				if wk(UGS[CURRENT_USERGROUP]) then
					if tobool(UGS[CURRENT_USERGROUP].bool_removeable) then
						surfaceButton(self, pw, ph, "-", Color(255, 0, 0, 255))
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
			PARENT.ugs = createD("DPanelList", PARENT, YRP.ctr(500), ScrH() - YRP.ctr(20 + 150 + 20 + 50 + 20), YRP.ctr(20), YRP.ctr(20 + 50 + 20 + 50))
			function PARENT.ugs:Paint(pw, ph)
				surfaceBox(0, 0, pw, ph, Color(255, 255, 255, 255))
			end
			PARENT.ugs:EnableVerticalScrollbar(true)

			UpdateUsergroupsList(ugs)
		end
	end
end)

hook.Add("open_server_usergroups", "open_server_usergroups", function()
	SaveLastSite()
	if pa(settingsWindow) then
		net.Start("Connect_Settings_UserGroups")
		net.SendToServer()
	end
end)
