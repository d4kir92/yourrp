--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local UGS = UGS or {}
local CURRENT_USERGROUP = nil
local DUGS = DUGS or {}
local SW = 600
function YRPSortUGS(tab)
	local newtab = {}
	for i, ug in pairs(tab) do
		newtab[tonumber(ug.int_position)] = ug
	end

	return newtab
end

local _icon = {}
_icon.size = YRP:ctr(100 - 16)
_icon.br = YRP:ctr(8)
net.Receive(
	"nws_yrp_connect_Settings_UserGroup",
	function(len)
		local ug = net.ReadTable()
		if ug == nil then return end
		if ug.uniqueID == nil then return end
		CURRENT_USERGROUP = tonumber(ug.uniqueID)
		UGS[CURRENT_USERGROUP] = ug
		local w = 800
		local x = 20
		local PARENT = GetSettingsSite()
		if not YRPPanelAlive(PARENT) then return end
		if YRPPanelAlive(PARENT.ug) then
			PARENT.ug:Remove()
		end

		PARENT.ug = YRPCreateD("DHorizontalScroller", PARENT, PARENT:GetWide() - YRP:ctr(20 + SW + 20), PARENT:GetTall(), YRP:ctr(20 + SW), YRP:ctr(0))
		PARENT.ugp = YRPCreateD("DPanel", PARENT, YRP:ctr((w + 10) * 4), PARENT:GetTall(), 0, 0)
		function PARENT.ugp:Paint(pw, ph)
		end

		--draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 100, 100, 100) )
		PARENT.ug:AddPanel(PARENT.ugp)
		PARENT = PARENT.ugp
		-- NAME
		local NAME = YRPCreateD("DYRPPanelPlus", PARENT, YRP:ctr(w), YRP:ctr(100), YRP:ctr(x), YRP:ctr(20))
		NAME.strname = true
		NAME:INITPanel("DTextEntry")
		NAME:SetHeader(YRP:trans("LID_name"))
		NAME:SetText(string.upper(ug.string_name))
		function NAME.plus:OnChange()
			UGS[CURRENT_USERGROUP].string_name = string.upper(self:GetText())
			net.Start("nws_yrp_usergroup_update_string_name")
			net.WriteString(CURRENT_USERGROUP)
			net.WriteString(string.upper(self:GetText()))
			net.SendToServer()
		end

		net.Receive(
			"nws_yrp_usergroup_update_string_name",
			function(len2)
				local string_name = net.ReadString()
				if UGS and UGS[CURRENT_USERGROUP] then
					UGS[CURRENT_USERGROUP].string_name = string.upper(string_name)
					if YRPPanelAlive(NAME) then
						NAME:SetText(string.upper(UGS[CURRENT_USERGROUP].string_name))
					end
				end
			end
		)

		if tonumber(ug.bool_removeable) == 0 then
			NAME.plus:SetDisabled(true)
		end

		-- DISPLAYNAME
		local DISPLAYNAME = YRPCreateD("DYRPPanelPlus", PARENT, YRP:ctr(w), YRP:ctr(100), YRP:ctr(x), YRP:ctr(20 + 100 + 20))
		DISPLAYNAME.displayname = true
		DISPLAYNAME:INITPanel("DTextEntry")
		DISPLAYNAME:SetHeader(YRP:trans("LID_displayname"))
		DISPLAYNAME:SetText(ug.string_displayname)
		function DISPLAYNAME.plus:OnChange()
			UGS[CURRENT_USERGROUP].string_displayname = self:GetText()
			net.Start("nws_yrp_usergroup_update_string_displayname")
			net.WriteString(CURRENT_USERGROUP)
			net.WriteString(self:GetText())
			net.SendToServer()
		end

		net.Receive(
			"nws_yrp_usergroup_update_string_displayname",
			function(len2)
				local string_displayname = net.ReadString()
				if UGS and UGS[CURRENT_USERGROUP] then
					UGS[CURRENT_USERGROUP].string_displayname = string_displayname
					if IsValid(DISPLAYNAME) then
						DISPLAYNAME:SetText(UGS[CURRENT_USERGROUP].string_displayname)
					end
				end
			end
		)

		-- COLOR
		local COLOR = YRPCreateD("DYRPPanelPlus", PARENT, YRP:ctr(w), YRP:ctr(100), YRP:ctr(x), YRP:ctr(20 + 100 + 20 + 100 + 20))
		COLOR:INITPanel("YButton")
		COLOR:SetHeader(YRP:trans("LID_color"))
		COLOR.plus:SetText("LID_change")
		function COLOR.plus:Paint(pw, ph)
			if IsNotNilAndNotFalse(UGS[CURRENT_USERGROUP]) then
				hook.Run("YButtonPaint", self, pw, ph)
			end
		end

		function COLOR.plus:DoClick()
			local window = YRPCreateD("DFrame", nil, YRP:ctr(20 + 500 + 20), YRP:ctr(50 + 20 + 500 + 20), 0, 0)
			window:Center()
			window:MakePopup()
			window:SetTitle("")
			function window:Paint(pw, ph)
				surfaceWindow(self, pw, ph, YRP:trans("LID_color"))
				if not YRPPanelAlive(PARENT) then
					self:Remove()
				end
			end

			window.cm = YRPCreateD("DColorMixer", window, YRP:ctr(500), YRP:ctr(500), YRP:ctr(20), YRP:ctr(50 + 20))
			function window.cm:ValueChanged(col)
				UGS[CURRENT_USERGROUP].string_color = YRPTableToColorStr(col)
				net.Start("nws_yrp_usergroup_update_string_color")
				net.WriteString(CURRENT_USERGROUP)
				net.WriteString(UGS[CURRENT_USERGROUP].string_color)
				net.SendToServer()
			end
		end

		net.Receive(
			"nws_yrp_usergroup_update_string_color",
			function(len2)
				local color = net.ReadString()
				if UGS and UGS[CURRENT_USERGROUP] then
					UGS[CURRENT_USERGROUP].string_color = color
				end
			end
		)

		-- ICON
		UGS[CURRENT_USERGROUP].ICON = YRPCreateD("DYRPPanelPlus", PARENT, YRP:ctr(w), YRP:ctr(100), YRP:ctr(x), YRP:ctr(20 + 100 + 20 + 100 + 20 + 100 + 20))
		local ICON = UGS[CURRENT_USERGROUP].ICON
		ICON:INITPanel("DTextEntry")
		ICON:SetHeader(YRP:trans("LID_icon"))
		ICON:SetText(ug.string_icon)
		function ICON.plus:OnChange()
			UGS[CURRENT_USERGROUP].string_icon = self:GetText()
			net.Start("nws_yrp_usergroup_update_icon")
			net.WriteString(CURRENT_USERGROUP)
			net.WriteString(self:GetText())
			net.SendToServer()
			local _ug = DUGS[CURRENT_USERGROUP]
			_ug.UpdateIcon(CURRENT_USERGROUP, UGS[CURRENT_USERGROUP].string_icon)
		end

		-- SWEPS
		if type(ug.string_sweps) == "string" then
			ug.string_sweps = string.Explode(",", ug.string_sweps)
		end

		local tmp = {}
		for i, v in pairs(ug.string_sweps) do
			if v ~= nil and not strEmpty(v) then
				table.insert(tmp, v)
			end
		end

		ug.string_sweps = tmp
		local SWEPS = YRPCreateD("DYRPPanelPlus", PARENT, YRP:ctr(w), YRP:ctr(50 + 500 + 50), YRP:ctr(x), YRP:ctr(20 + 100 + 20 + 100 + 20 + 100 + 20 + 100 + 20))
		SWEPS:INITPanel("DPanel")
		SWEPS:SetHeader(YRP:trans("LID_weapons"))
		SWEPS:SetText(ug.string_icon)
		function SWEPS.plus:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(80, 80, 80, 255))
		end

		SWEPS.preview = YRPCreateD("DModelPanel", SWEPS, YRP:ctr(w), YRP:ctr(500), YRP:ctr(0), YRP:ctr(50))
		if ug.string_sweps[1] ~= nil then
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
			if self.bAnimated then
				self:RunAnimation()
			end

			if self.Pressed then
				local mx = gui.MousePos()
				self.Angles = self.Angles - Angle(0, (self.PressX or mx) - mx, 0)
				self.PressX, self.PressY = gui.MousePos()
				if ent ~= nil then
					ent:SetAngles(self.Angles)
				end
			end
		end

		function SWEPS.preview:PaintOver(pw, ph)
			if IsNotNilAndNotFalse(UGS[CURRENT_USERGROUP]) then
				if self.oldcur ~= self.cur then
					self.oldcur = self.cur
					if UGS[CURRENT_USERGROUP].string_sweps then
						self:SetModel(GetSWEPWorldModel(UGS[CURRENT_USERGROUP].string_sweps[self.cur]))
					end
				end

				surfaceText(self.cur .. "/" .. self.max, "Y_18_500", pw / 2, ph - YRP:ctr(30), Color(255, 255, 255, 255), 1, 1)
				if UGS[CURRENT_USERGROUP].string_sweps then
					surfaceText(UGS[CURRENT_USERGROUP].string_sweps[self.cur] or "NOMODEL", "Y_18_500", pw / 2, ph - YRP:ctr(70), Color(255, 255, 255, 255), 1, 1)
				end
			end
		end

		SWEPS.preview.prev = YRPCreateD("YButton", SWEPS.preview, YRP:ctr(50), YRP:ctr(50), YRP:ctr(0), YRP:ctr(500 - 50) / 2)
		SWEPS.preview.prev:SetText("")
		SWEPS.preview.prev.tab = {
			["text"] = "<"
		}

		function SWEPS.preview.prev:Paint(pw, ph)
			if SWEPS.preview.cur > 1 then
				hook.Run("YButtonPaint", self, pw, ph, self.tab)
			end
		end

		function SWEPS.preview.prev:DoClick()
			if SWEPS.preview.cur > 1 then
				SWEPS.preview.cur = SWEPS.preview.cur - 1
			end
		end

		SWEPS.preview.next = YRPCreateD("YButton", SWEPS.preview, YRP:ctr(50), YRP:ctr(50), YRP:ctr(w - 50), YRP:ctr(500 - 50) / 2)
		SWEPS.preview.next:SetText("")
		SWEPS.preview.next.tab = {
			["text"] = ">"
		}

		function SWEPS.preview.next:Paint(pw, ph)
			if SWEPS.preview.cur < SWEPS.preview.max then
				hook.Run("YButtonPaint", self, pw, ph, self.tab)
			end
		end

		function SWEPS.preview.next:DoClick()
			if SWEPS.preview.cur < SWEPS.preview.max then
				SWEPS.preview.cur = SWEPS.preview.cur + 1
			end
		end

		if type(UGS[CURRENT_USERGROUP].string_sweps) == "string" then
			UGS[CURRENT_USERGROUP].string_sweps = string.Explode(",", UGS[CURRENT_USERGROUP].string_sweps)
		end

		SWEPS.button = YRPCreateD("YButton", SWEPS, YRP:ctr(w), YRP:ctr(50), YRP:ctr(0), YRP:ctr(50 + 500))
		SWEPS.button:SetText("LID_change")
		function SWEPS.button:Paint(pw, ph)
			hook.Run("YButtonPaint", self, pw, ph)
		end

		function SWEPS.button:DoClick()
			local lply = LocalPlayer()
			lply.yrpseltab = {}
			if type(UGS[CURRENT_USERGROUP].string_sweps) == "string" then
				UGS[CURRENT_USERGROUP].string_sweps = string.Explode(",", UGS[CURRENT_USERGROUP].string_sweps)
			end

			if UGS[CURRENT_USERGROUP].string_sweps then
				for i, v in pairs(UGS[CURRENT_USERGROUP].string_sweps) do
					if not table.HasValue(lply.yrpseltab) then
						table.insert(lply.yrpseltab, v)
					end
				end
			end

			local allsweps = YRPGetSWEPsList()
			local cl_sweps = {}
			local count = 0
			for k, v in pairs(allsweps) do
				count = count + 1
				cl_sweps[count] = {}
				cl_sweps[count].WorldModel = v.WorldModel or ""
				cl_sweps[count].ClassName = v.ClassName or "NO CLASSNAME"
				cl_sweps[count].PrintName = v.PrintName or v.ClassName or "NO PRINTNAME"
			end

			function YRPAddSwepToUG()
				if UGS[CURRENT_USERGROUP] and lply.yrpseltab then
					net.Start("nws_yrp_usergroup_update_string_sweps")
					net.WriteString(UGS[CURRENT_USERGROUP].uniqueID)
					net.WriteTable(lply.yrpseltab)
					net.SendToServer()
					UGS[CURRENT_USERGROUP].string_sweps = lply.yrpseltab
				elseif lply.yrpseltab and lply.yrpseltab[1] then
					MsgC(Color(0, 255, 0), "[YRPAddSwepToUG] " .. tostring(UGS[CURRENT_USERGROUP]) .. " " .. tostring(lply.yrpseltab[1]) .. "\n")
				else
					MsgC(Color(0, 255, 0), "[YRPAddSwepToUG] " .. tostring(UGS[CURRENT_USERGROUP]) .. " " .. tostring(lply.yrpseltab) .. "\n")
				end
			end

			YRPOpenSelector(cl_sweps, true, "classname", YRPAddSwepToUG)
		end

		net.Receive(
			"nws_yrp_usergroup_update_string_sweps",
			function(len2)
				if YRPPanelAlive(SWEPS) then
					local string_sweps = net.ReadString()
					if type(UGS[CURRENT_USERGROUP].string_sweps) == "string" then
						UGS[CURRENT_USERGROUP].string_sweps = string.Explode(",", string_sweps)
					end

					local tmp4 = {}
					for i, v in pairs(ug.string_sweps) do
						if v ~= nil and not strEmpty(v) then
							table.insert(tmp4, v)
						end
					end

					UGS[CURRENT_USERGROUP].string_sweps = tmp4
					if UGS[CURRENT_USERGROUP].string_sweps[1] ~= "" then
						SWEPS.preview.cur = 1
						SWEPS.preview.max = #UGS[CURRENT_USERGROUP].string_sweps
						if UGS[CURRENT_USERGROUP].string_sweps then
							SWEPS.preview:SetModel(GetSWEPWorldModel(UGS[CURRENT_USERGROUP].string_sweps[1] or ""))
						end
					else
						SWEPS.preview.cur = 0
						SWEPS.preview.max = 0
						SWEPS.preview:SetModel("")
					end
				end
			end
		)

		-- NONEDROPPABLESWEPS
		if type(ug.string_nonesweps) == "string" then
			ug.string_nonesweps = string.Explode(",", ug.string_nonesweps)
		end

		local tmp2 = {}
		for i, v in pairs(ug.string_nonesweps) do
			if v ~= nil and not strEmpty(v) then
				table.insert(tmp2, v)
			end
		end

		ug.string_nonesweps = tmp2
		local NONESWEPS = YRPCreateD("DYRPPanelPlus", PARENT, YRP:ctr(w), YRP:ctr(50 + 500 + 50), YRP:ctr(x), YRP:ctr(20 + 100 + 20 + 100 + 20 + 100 + 20 + 500 + 50 + 50 + 20 + 100 + 20))
		NONESWEPS:INITPanel("DPanel")
		NONESWEPS:SetHeader(YRP:trans("LID_ndsweps"))
		NONESWEPS:SetText(ug.string_icon)
		function NONESWEPS.plus:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(80, 80, 80, 255))
		end

		NONESWEPS.preview = YRPCreateD("DModelPanel", NONESWEPS, YRP:ctr(w), YRP:ctr(500), YRP:ctr(0), YRP:ctr(50))
		if ug.string_nonesweps[1] ~= nil then
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
			if self.bAnimated then
				self:RunAnimation()
			end

			if self.Pressed then
				local mx = gui.MousePos()
				self.Angles = self.Angles - Angle(0, (self.PressX or mx) - mx, 0)
				self.PressX, self.PressY = gui.MousePos()
				if ent ~= nil then
					ent:SetAngles(self.Angles)
				end
			end
		end

		function NONESWEPS.preview:PaintOver(pw, ph)
			if IsNotNilAndNotFalse(UGS[CURRENT_USERGROUP]) then
				if self.oldcur ~= self.cur then
					self.oldcur = self.cur
					if UGS[CURRENT_USERGROUP].string_nonesweps then
						self:SetModel(GetSWEPWorldModel(UGS[CURRENT_USERGROUP].string_nonesweps[self.cur]))
					end
				end

				surfaceText(self.cur .. "/" .. self.max, "Y_18_500", pw / 2, ph - YRP:ctr(30), Color(255, 255, 255, 255), 1, 1)
				if UGS[CURRENT_USERGROUP].string_nonesweps then
					surfaceText(UGS[CURRENT_USERGROUP].string_nonesweps[self.cur] or "NOMODEL", "Y_18_500", pw / 2, ph - YRP:ctr(70), Color(255, 255, 255, 255), 1, 1)
				end
			end
		end

		NONESWEPS.preview.prev = YRPCreateD("YButton", NONESWEPS.preview, YRP:ctr(50), YRP:ctr(50), YRP:ctr(0), YRP:ctr(500 - 50) / 2)
		NONESWEPS.preview.prev:SetText("")
		NONESWEPS.preview.prev.tab = {
			["text"] = "<"
		}

		function NONESWEPS.preview.prev:Paint(pw, ph)
			if NONESWEPS.preview.cur > 1 then
				hook.Run("YButtonPaint", self, pw, ph, self.tab)
			end
		end

		function NONESWEPS.preview.prev:DoClick()
			if NONESWEPS.preview.cur > 1 then
				NONESWEPS.preview.cur = NONESWEPS.preview.cur - 1
			end
		end

		NONESWEPS.preview.next = YRPCreateD("YButton", NONESWEPS.preview, YRP:ctr(50), YRP:ctr(50), YRP:ctr(w - 50), YRP:ctr(500 - 50) / 2)
		NONESWEPS.preview.next:SetText("")
		NONESWEPS.preview.next.tab = {
			["text"] = ">"
		}

		function NONESWEPS.preview.next:Paint(pw, ph)
			if NONESWEPS.preview.cur < NONESWEPS.preview.max then
				hook.Run("YButtonPaint", self, pw, ph, self.tab)
			end
		end

		function NONESWEPS.preview.next:DoClick()
			if NONESWEPS.preview.cur < NONESWEPS.preview.max then
				NONESWEPS.preview.cur = NONESWEPS.preview.cur + 1
			end
		end

		NONESWEPS.button = YRPCreateD("YButton", NONESWEPS, YRP:ctr(w), YRP:ctr(50), YRP:ctr(0), YRP:ctr(50 + 500))
		NONESWEPS.button:SetText("LID_change")
		function NONESWEPS.button:Paint(pw, ph)
			hook.Run("YButtonPaint", self, pw, ph)
		end

		function NONESWEPS.button:DoClick()
			local lply = LocalPlayer()
			lply.yrpseltab = {}
			local allsweps = YRPGetSWEPsList()
			local cl_sweps = {}
			local count = 0
			local validate = {}
			for k, v in pairs(allsweps) do
				validate[v.ClassName] = true
				count = count + 1
				cl_sweps[count] = {}
				cl_sweps[count].WorldModel = v.WorldModel or ""
				cl_sweps[count].ClassName = v.ClassName or "NO CLASSNAME"
				cl_sweps[count].PrintName = v.PrintName or v.ClassName or "NO PRINTNAME"
			end

			if UGS[CURRENT_USERGROUP] and UGS[CURRENT_USERGROUP].string_nonesweps then
				for i, v in pairs(UGS[CURRENT_USERGROUP].string_nonesweps) do
					if not table.HasValue(lply.yrpseltab) and validate[v] then
						table.insert(lply.yrpseltab, v)
					end
				end
			end

			function YRPAddSwepToUGNone()
				local lplayer = LocalPlayer()
				if UGS[CURRENT_USERGROUP] and lplayer.yrpseltab then
					net.Start("nws_yrp_usergroup_update_string_nonesweps")
					net.WriteString(UGS[CURRENT_USERGROUP].uniqueID)
					net.WriteTable(lplayer.yrpseltab)
					net.SendToServer()
					UGS[CURRENT_USERGROUP].string_nonesweps = lplayer.yrpseltab
				elseif lplayer.yrpseltab and lplayer.yrpseltab[1] then
					MsgC(Color(0, 255, 0), "[YRPAddSwepToUGNone] " .. tostring(UGS[CURRENT_USERGROUP]) .. " " .. tostring(lplayer.yrpseltab[1]) .. "\n")
				else
					MsgC(Color(0, 255, 0), "[YRPAddSwepToUGNone] " .. tostring(UGS[CURRENT_USERGROUP]) .. " " .. tostring(lplayer.yrpseltab) .. "\n")
				end
			end

			YRPOpenSelector(cl_sweps, true, "classname", YRPAddSwepToUGNone)
		end

		net.Receive(
			"nws_yrp_usergroup_update_string_nonesweps",
			function(len2)
				if YRPPanelAlive(NONESWEPS) then
					local string_nonesweps = net.ReadString()
					if type(UGS[CURRENT_USERGROUP].string_nonesweps) == "string" then
						UGS[CURRENT_USERGROUP].string_nonesweps = string.Explode(",", string_nonesweps)
					end

					local tmp3 = {}
					for i, v in pairs(ug.string_nonesweps) do
						if v ~= nil and not strEmpty(v) then
							table.insert(tmp3, v)
						end
					end

					UGS[CURRENT_USERGROUP].string_nonesweps = tmp3
					if UGS[CURRENT_USERGROUP].string_nonesweps[1] ~= "" then
						NONESWEPS.preview.cur = 1
						NONESWEPS.preview.max = #UGS[CURRENT_USERGROUP].string_nonesweps
						if UGS[CURRENT_USERGROUP].string_nonesweps then
							NONESWEPS.preview:SetModel(GetSWEPWorldModel(UGS[CURRENT_USERGROUP].string_nonesweps[1] or ""))
						end
					else
						NONESWEPS.preview.cur = 0
						NONESWEPS.preview.max = 0
						NONESWEPS.preview:SetModel("")
					end
				end
			end
		)

		x = x + w + 10
		-- Licenses
		y = 20
		local LICENSES = YRPCreateD("DYRPPanelPlus", PARENT, YRP:ctr(w), YRP:ctr(50 + 500), YRP:ctr(x), YRP:ctr(y))
		LICENSES:INITPanel("DPanelList")
		LICENSES:SetHeader(YRP:trans("LID_licenses"))
		LICENSES:SetText(ug.string_icon)
		function LICENSES.plus:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(80, 80, 80, 255))
		end

		LICENSES.plus:EnableVerticalScrollbar(true)
		if type(UGS[CURRENT_USERGROUP].string_licenses) == "string" then
			UGS[CURRENT_USERGROUP].string_licenses = string.Explode(",", UGS[CURRENT_USERGROUP].string_licenses)
		end

		if table.HasValue(UGS[CURRENT_USERGROUP].string_licenses, "") then
			table.RemoveByValue(UGS[CURRENT_USERGROUP].string_licenses, "")
		end

		net.Receive(
			"nws_yrp_get_usergroup_licenses",
			function()
				local licenses = net.ReadTable()
				for i, lic in pairs(licenses) do
					local line4 = YRPCreateD("DPanel", nil, 10, YRP:ctr(50), 0, 0)
					function line4:Paint(pw, ph)
						draw.RoundedBox(0, 0, 0, pw, ph, Color(55, 55, 55))
						draw.SimpleText(lic.name, "Y_14_500", ph + YRP:ctr(10), ph / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					end

					local cb = YRPCreateD("DCheckBox", line4, YRP:ctr(50), YRP:ctr(50), 0, 0)
					if type(UGS[CURRENT_USERGROUP].string_licenses) == "string" then
						UGS[CURRENT_USERGROUP].string_licenses = string.Explode(",", UGS[CURRENT_USERGROUP].string_licenses)
					end

					if CURRENT_USERGROUP and UGS[CURRENT_USERGROUP] and table.HasValue(UGS[CURRENT_USERGROUP].string_licenses, lic.uniqueID) then
						cb:SetChecked(true)
					end

					function cb:OnChange(bVal)
						if CURRENT_USERGROUP and UGS[CURRENT_USERGROUP] and UGS[CURRENT_USERGROUP].string_licenses and type(UGS[CURRENT_USERGROUP].string_licenses) == "string" then
							UGS[CURRENT_USERGROUP].string_licenses = string.Explode(",", UGS[CURRENT_USERGROUP].string_licenses)
						end

						if UGS[CURRENT_USERGROUP].string_licenses then
							if bVal then
								table.insert(UGS[CURRENT_USERGROUP].string_licenses, lic.uniqueID)
							else
								table.RemoveByValue(UGS[CURRENT_USERGROUP].string_licenses, lic.uniqueID)
							end

							local str = table.concat(UGS[CURRENT_USERGROUP].string_licenses, ",")
							net.Start("nws_yrp_usergroup_update_string_licenses")
							net.WriteString(CURRENT_USERGROUP)
							net.WriteString(str)
							net.SendToServer()
						end
					end

					LICENSES.plus:AddItem(line4)
				end
			end
		)

		net.Start("nws_yrp_get_usergroup_licenses")
		net.SendToServer()
		-- YTools
		if tonumber(ug.bool_removeable) == 1 then
			y = y + 550 + 20
			local YTOOLS = YRPCreateD("DYRPPanelPlus", PARENT, YRP:ctr(w), YRP:ctr(50 + 500), YRP:ctr(x), YRP:ctr(y))
			YTOOLS:INITPanel("DPanelList")
			YTOOLS:SetHeader(YRP:trans("LID_tools"))
			YTOOLS:SetText(ug.string_icon)
			function YTOOLS.plus:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, Color(80, 80, 80, 255))
			end

			YTOOLS.plus:EnableVerticalScrollbar(true)
			if type(UGS[CURRENT_USERGROUP].string_tools) == "string" then
				UGS[CURRENT_USERGROUP].string_tools = string.Explode(",", UGS[CURRENT_USERGROUP].string_tools)
			end

			if table.HasValue(UGS[CURRENT_USERGROUP].string_tools, "") then
				table.RemoveByValue(UGS[CURRENT_USERGROUP].string_tools, "")
			end

			local line = YRPCreateD("DPanel", nil, 10, YRP:ctr(50), 0, 0)
			function line:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, Color(55, 55, 55))
				draw.SimpleText("all", "Y_14_500", ph + YRP:ctr(10), ph / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end

			local cb = YRPCreateD("DCheckBox", line, YRP:ctr(50), YRP:ctr(50), 0, 0)
			if table.HasValue(UGS[CURRENT_USERGROUP].string_tools, "all") then
				cb:SetChecked(true)
			end

			function cb:OnChange(bVal)
				if IsNotNilAndNotFalse(UGS[CURRENT_USERGROUP]) and UGS[CURRENT_USERGROUP].string_tools then
					if type(UGS[CURRENT_USERGROUP].string_tools) == "string" then
						UGS[CURRENT_USERGROUP].string_tools = string.Explode(",", UGS[CURRENT_USERGROUP].string_tools)
					end

					if bVal then
						table.insert(UGS[CURRENT_USERGROUP].string_tools, "all")
					else
						table.RemoveByValue(UGS[CURRENT_USERGROUP].string_tools, "all")
					end

					local str = table.concat(UGS[CURRENT_USERGROUP].string_tools, ",")
					net.Start("nws_yrp_usergroup_update_string_tools")
					net.WriteString(CURRENT_USERGROUP)
					net.WriteString(str)
					net.SendToServer()
				end
			end

			YTOOLS.plus:AddItem(line)
			local tools = spawnmenu.GetTools()
			for i, cat in pairs(tools) do
				for j, cat2 in pairs(cat.Items) do
					for k, too in pairs(cat2) do
						if type(too) == "table" then
							too.ItemName = string.lower(too.ItemName)
							local line2 = YRPCreateD("DPanel", nil, 10, YRP:ctr(50), 0, 0)
							function line2:Paint(pw, ph)
								draw.RoundedBox(0, 0, 0, pw, ph, Color(55, 55, 55))
								draw.SimpleText(language.GetPhrase(too.Text), "Y_14_500", ph + YRP:ctr(10), ph / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
							end

							local cb2 = YRPCreateD("DCheckBox", line2, YRP:ctr(50), YRP:ctr(50), 0, 0)
							if type(UGS[CURRENT_USERGROUP].string_tools) == "string" then
								UGS[CURRENT_USERGROUP].string_tools = string.Explode(",", UGS[CURRENT_USERGROUP].string_tools)
							end

							if table.HasValue(UGS[CURRENT_USERGROUP].string_tools, too.ItemName) then
								cb2:SetChecked(true)
							end

							function cb2:OnChange(bVal)
								if UGS[CURRENT_USERGROUP] and UGS[CURRENT_USERGROUP].string_tools then
									if bVal then
										table.insert(UGS[CURRENT_USERGROUP].string_tools, too.ItemName)
									else
										table.RemoveByValue(UGS[CURRENT_USERGROUP].string_tools, too.ItemName)
									end

									local str = table.concat(UGS[CURRENT_USERGROUP].string_tools, ",")
									net.Start("nws_yrp_usergroup_update_string_tools")
									net.WriteString(CURRENT_USERGROUP)
									net.WriteString(str)
									net.SendToServer()
								end
							end

							YTOOLS.plus:AddItem(line2)
						end
					end
				end
			end

			local properties = {"ignite", "extinguish", "remover", "drive", "collision", "keepupright", "bodygroups", "gravity", "persist"}
			for i, v in pairs(properties) do
				local line3 = YRPCreateD("DPanel", nil, 10, YRP:ctr(50), 0, 0)
				function line3:Paint(pw, ph)
					draw.RoundedBox(0, 0, 0, pw, ph, Color(55, 55, 55))
					draw.SimpleText(v, "Y_14_500", ph + YRP:ctr(10), ph / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end

				local cb3 = YRPCreateD("DCheckBox", line3, YRP:ctr(50), YRP:ctr(50), 0, 0)
				if table.HasValue(UGS[CURRENT_USERGROUP].string_tools, v) then
					cb3:SetChecked(true)
				end

				function cb3:OnChange(bVal)
					if UGS[CURRENT_USERGROUP] then
						if bVal then
							table.insert(UGS[CURRENT_USERGROUP].string_tools, v)
						else
							table.RemoveByValue(UGS[CURRENT_USERGROUP].string_tools, v)
						end

						local str = table.concat(UGS[CURRENT_USERGROUP].string_tools, ",")
						net.Start("nws_yrp_usergroup_update_string_tools")
						net.WriteString(CURRENT_USERGROUP)
						net.WriteString(str)
						net.SendToServer()
					end
				end

				YTOOLS.plus:AddItem(line3)
			end
		end

		-- Ammunation
		y = y + 550 + 20
		local ammobg = YRPCreateD("YPanel", PARENT, YRP:ctr(w), YRP:ctr(50 + 500), YRP:ctr(x), YRP:ctr(y))
		local ammoheader = YRPCreateD("YLabel", ammobg, YRP:ctr(w), YRP:ctr(50), 0, 0)
		ammoheader:SetText("LID_ammo")
		function ammoheader:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
			draw.SimpleText(YRP:trans(self:GetText()), "Y_18_700", pw / 2, ph / 2, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		ammolist = YRPCreateD("DPanelList", ammobg, YRP:ctr(w), YRP:ctr(500), 0, YRP:ctr(50))
		ammolist:SetSpacing(2)
		ammolist:EnableVerticalScrollbar(true)
		local sbar = ammolist.VBar
		function sbar:Paint(sw, sh)
			draw.RoundedBox(0, 0, 0, sw, sh, YRPInterfaceValue("YFrame", "NC"))
		end

		function sbar.btnUp:Paint(sw, sh)
			draw.RoundedBox(0, 0, 0, sw, sh, Color(60, 60, 60))
		end

		function sbar.btnDown:Paint(sw, sh)
			draw.RoundedBox(0, 0, 0, sw, sh, Color(60, 60, 60))
		end

		function sbar.btnGrip:Paint(sw, sh)
			draw.RoundedBox(sw / 2, 0, 0, sw, sh, YRPInterfaceValue("YFrame", "HI"))
		end

		local tammos = UGS[CURRENT_USERGROUP].string_ammos or ""
		tammos = string.Explode(";", tammos)
		local ammos = {}
		for i, v in pairs(tammos) do
			local t = string.Split(v, ":")
			ammos[t[1]] = t[2]
		end

		function YRPUpdateAmmoAmountUG()
			local tab = {}
			for i, v in pairs(ammos) do
				if tonumber(v) > 0 then
					table.insert(tab, i .. ":" .. v)
				end
			end

			local result = table.concat(tab, ";")
			if CURRENT_USERGROUP then
				net.Start("nws_yrp_usergroup_update_string_ammos")
				net.WriteString(CURRENT_USERGROUP)
				net.WriteString(result)
				net.SendToServer()
			end
		end

		for i, v in pairs(game.GetAmmoTypes()) do
			local abg = YRPCreateD("YPanel", nil, YRP:ctr(w), YRP:ctr(50), 0, 0)
			local ahe = YRPCreateD("YLabel", abg, YRP:ctr(w / 2), YRP:ctr(50), 0, 0)
			ahe:SetText(v)
			function ahe:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, Color(100, 100, 255))
				draw.SimpleText(self:GetText(), "Y_18_700", ph / 2, ph / 2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end

			local ava = YRPCreateD("DNumberWang", abg, YRP:ctr(w / 2), YRP:ctr(50), YRP:ctr(w / 2), 0)
			ava:SetDecimals(0)
			ava:SetMin(0)
			ava:SetMax(999)
			ava:SetValue(ammos[v] or 0)
			function ava:OnValueChanged(val)
				ammos[v] = math.Clamp(val, self:GetMin(), self:GetMax())
				YRPUpdateAmmoAmountUG()
			end

			ammolist:AddItem(abg)
		end

		x = x + w + 10
		local ACCESS = YRPCreateD("YGroupBox", PARENT, YRP:ctr(w), ScrH() - YRP:ctr(100 + 10 + 10), YRP:ctr(x), YRP:ctr(20))
		ACCESS:SetText("LID_accesssettings")
		function ACCESS:Paint(pw, ph)
			hook.Run("YGroupBoxPaint", self, pw, ph)
		end

		ACCESS:AutoSize(true)
		function ACCESSAddCheckBox(name, lstr, color)
			local tmp4 = YRPCreateD("DPanel", PARENT, YRP:ctr(800), YRP:ctr(50), 0, 0)
			function tmp4:Paint(pw, ph)
				surfacePanel(self, pw, ph, YRP:trans(lstr), color, YRP:ctr(50 + 10), nil, 0, 1)
			end

			tmp4.cb = YRPCreateD("DCheckBox", tmp4, YRP:ctr(50), YRP:ctr(50), 0, 0)
			tmp4.cb:SetValue(ug[name])
			function tmp4.cb:Paint(pw, ph)
				surfaceCheckBox(self, pw, ph, "done")
			end

			function tmp4.cb:OnChange(bVal)
				if not self.serverside then
					net.Start("nws_yrp_usergroup_update_" .. name)
					net.WriteString(CURRENT_USERGROUP)
					net.WriteString(btn(bVal))
					net.SendToServer()
				end
			end

			net.Receive(
				"nws_yrp_usergroup_update_" .. name,
				function(len2)
					local b = net.ReadString()
					if YRPPanelAlive(tmp4.cb) then
						tmp4.cb.serverside = true
						tmp4.cb:SetValue(b)
						tmp4.cb.serverside = false
					end
				end
			)

			ACCESS:AddItem(tmp4)
		end

		function ACCESSAddHr()
			local tmp5 = YRPCreateD("DPanel", PARENT, YRP:ctr(800), YRP:ctr(4 + 4 + 4), 0, 0)
			function tmp5:Paint(pw, ph)
				surfacePanel(self, pw, ph, "")
				draw.RoundedBox(0, 0, YRP:ctr(4), pw, YRP:ctr(4), Color(0, 0, 0, 255))
			end

			ACCESS:AddItem(tmp5)
		end

		if tonumber(ug.bool_removeable) == 1 then
			ACCESSAddCheckBox("bool_adminaccess", "LID_yrp_adminaccess", Color(255, 255, 0, 255))
			ACCESSAddHr()
		end

		ACCESSAddCheckBox("bool_chat", "LID_chat")
		ACCESSAddHr()
		if tonumber(ug.bool_removeable) == 1 then
			-- LID_usermanagement
			ACCESSAddCheckBox("bool_events", "LID_event")
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
			ACCESSAddCheckBox("bool_feedback", "LID_tickets")
			ACCESSAddHr()
			-- LID_administration
			ACCESSAddCheckBox("bool_realistic", "LID_settings_realistic")
			ACCESSAddCheckBox("bool_shops", "LID_settings_shops")
			ACCESSAddCheckBox("bool_licenses", "LID_settings_licenses")
			ACCESSAddCheckBox("bool_specializations", "LID_specializations")
			ACCESSAddCheckBox("bool_usergroups", "LID_settings_usergroups", Color(255, 0, 0, 255))
			ACCESSAddCheckBox("bool_levelsystem", "LID_levelsystem")
			ACCESSAddCheckBox("bool_design", "LID_settings_design")
			ACCESSAddCheckBox("bool_scale", "LID_scale")
			ACCESSAddCheckBox("bool_money", "LID_money")
			ACCESSAddCheckBox("bool_weaponsystem", "LID_weaponsystem")
			ACCESSAddHr()
			-- LID_server
			ACCESSAddCheckBox("bool_general", "LID_settings_general")
			ACCESSAddCheckBox("bool_ac_database", "LID_settings_database", Color(255, 0, 0, 255))
			-- Socials [television.png]
			ACCESSAddCheckBox("bool_darkrp", "DarkRP", Color(255, 0, 0, 255))
			ACCESSAddCheckBox("bool_permaprops", "Perma Props", Color(255, 0, 0, 255))
			-- Import
			ACCESSAddHr()
			ACCESSAddCheckBox("bool_import_darkrp", YRP:trans("LID_import") .. " DarkRP", Color(255, 255, 0, 255))
			-- YourRP
			ACCESSAddHr()
			ACCESSAddCheckBox("bool_yourrp_addons", "LID_settings_yourrp_addons")
		end

		x = x + w + 10
		local GAMEPLAY = YRPCreateD("YGroupBox", PARENT, YRP:ctr(w), ScrH() - YRP:ctr(100 + 10 + 10), YRP:ctr(x), YRP:ctr(20))
		GAMEPLAY:SetText("LID_gameplayrestrictions")
		function GAMEPLAY:Paint(pw, ph)
			hook.Run("YGroupBoxPaint", self, pw, ph)
		end

		GAMEPLAY:AutoSize(true)
		function GAMEPLAYAddIntBox(name, lstr)
			local tmp6 = YRPCreateD("DPanel", PARENT, GAMEPLAY:GetWide() - YRP:ctr(40), YRP:ctr(100), 0, 0)
			function tmp6:Paint(pw, ph)
			end

			--
			tmp6.lbl = YRPCreateD("YLabel", tmp6, tmp6:GetWide(), YRP:ctr(50), 0, 0)
			tmp6.lbl:SetText(lstr)
			tmp6.cb = YRPCreateD("DNumberWang", tmp6, tmp6:GetWide(), YRP:ctr(50), 0, YRP:ctr(50))
			tmp6.cb:SetValue(ug[name])
			tmp6.cb:SetMax(100)
			tmp6.cb:SetMin(1)
			function tmp6.cb:OnValueChanged(val)
				net.Start("nws_yrp_usergroup_update_" .. name)
				net.WriteString(CURRENT_USERGROUP)
				net.WriteString(val)
				net.SendToServer()
			end

			GAMEPLAY:AddItem(tmp6)
		end

		function GAMEPLAYAddCheckBox(name, lstr)
			local tmp7 = YRPCreateD("DPanel", PARENT, YRP:ctr(800), YRP:ctr(50), 0, 0)
			function tmp7:Paint(pw, ph)
				surfacePanel(self, pw, ph, YRP:trans(lstr), nil, YRP:ctr(50 + 10), nil, 0, 1)
			end

			tmp7.cb = YRPCreateD("DCheckBox", tmp7, YRP:ctr(50), YRP:ctr(50), 0, 0)
			tmp7.cb:SetValue(ug[name])
			function tmp7.cb:Paint(pw, ph)
				surfaceCheckBox(self, pw, ph, "done")
			end

			function tmp7.cb:OnChange(bVal)
				net.Start("nws_yrp_usergroup_update_" .. name)
				net.WriteString(CURRENT_USERGROUP)
				net.WriteString(btn(bVal))
				net.SendToServer()
			end

			GAMEPLAY:AddItem(tmp7)
		end

		function GAMEPLAYAddHr()
			local tmp8 = YRPCreateD("DPanel", PARENT, YRP:ctr(800), YRP:ctr(4 + 4 + 4), 0, 0)
			function tmp8:Paint(pw, ph)
				surfacePanel(self, pw, ph, "")
				draw.RoundedBox(0, 0, YRP:ctr(4), pw, YRP:ctr(4), Color(0, 0, 0, 255))
			end

			GAMEPLAY:AddItem(tmp8)
		end

		if tonumber(ug.bool_removeable) == 1 then
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
			GAMEPLAYAddCheckBox("bool_canusewarnsystem", "Can use WarnSystem")
			GAMEPLAYAddHr()
			GAMEPLAYAddCheckBox("bool_canusecontextmenu", "LID_gp_canusecontextmenu")
			GAMEPLAYAddCheckBox("bool_canusespawnmenu", "LID_gp_canusespawnmenu")
			GAMEPLAYAddHr()
		end

		GAMEPLAYAddCheckBox("bool_canseeteammatesonmap", "LID_gp_canseeteammatesonmap")
		GAMEPLAYAddCheckBox("bool_canseeenemiesonmap", "LID_gp_canseeenemiesonmap")
		GAMEPLAYAddHr()
		GAMEPLAYAddIntBox("int_characters_max", "LID_charactersmax")
		GAMEPLAYAddIntBox("int_charactersevent_max", YRP:trans("LID_charactersmax") .. " (EVENT)")
	end
)

function YRPAddUG(tbl)
	local PARENT = GetSettingsSite()
	if not YRPPanelAlive(PARENT) or not YRPPanelAlive(PARENT.uglist) then return end
	UGS[tonumber(tbl.uniqueID)] = tbl
	DUGS[tonumber(tbl.uniqueID)] = YRPCreateD("YButton", PARENT.uglist, PARENT.uglist:GetWide(), YRP:ctr(100), 0, 0)
	local _ug = DUGS[tonumber(tbl.uniqueID)]
	_ug.uid = tonumber(tbl.uniqueID)
	_ug:SetText("")
	_ug.tab = {
		["ax"] = 0,
		["ay"] = 1,
	}

	function _ug:Paint(pw, ph)
		self.string_color = StringToColor(UGS[self.uid].string_color)
		local text = string.upper(UGS[self.uid].string_name)
		if not strEmpty(UGS[self.uid].string_displayname) then
			text = text .. " " .. "( " .. tostring(UGS[self.uid].string_displayname) .. " )"
		end

		self.px = ph + YRP:ctr(40 + 20)
		self.py = ph / 2
		self.tab.color = self.string_color
		hook.Run("YButtonPaint", self, pw, ph, self.tab)
		draw.SimpleText(text, "Y_16_700", ph + YRP:ctr(40 + 20), ph / 2, YRPTextColor(self.string_color), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		if UGS[tonumber(tbl.uniqueID)].string_icon and strEmpty(UGS[tonumber(tbl.uniqueID)].string_icon) then
			draw.RoundedBox(0, YRP:ctr(8) + YRP:ctr(40) + YRP:ctr(8), YRP:ctr(4), ph - YRP:ctr(8), ph - YRP:ctr(8), Color(255, 255, 255, 255))
		end

		if self.uid == tonumber(CURRENT_USERGROUP) then
			local spw = pw - YRP:ctr(40 + 8)
			local sph = ph
			local px = YRP:ctr(40 + 8)
			local _br = 4
			local _w = 32
			local _h = 12
			--Outter
			draw.RoundedBox(0, px + YRP:ctr(_br), YRP:ctr(_br), YRP:ctr(_w), YRP:ctr(_h), Color(0, 0, 0, 255))
			draw.RoundedBox(0, px + YRP:ctr(_br), YRP:ctr(_br), YRP:ctr(_h), YRP:ctr(_w), Color(0, 0, 0, 255))
			draw.RoundedBox(0, px + YRP:ctr(_br), sph - YRP:ctr(_h) - YRP:ctr(_br), YRP:ctr(_w), YRP:ctr(_h), Color(0, 0, 0, 255))
			draw.RoundedBox(0, px + YRP:ctr(_br), sph - YRP:ctr(_w) - YRP:ctr(_br), YRP:ctr(_h), YRP:ctr(_w), Color(0, 0, 0, 255))
			draw.RoundedBox(0, px + spw - YRP:ctr(_w) - YRP:ctr(_br), YRP:ctr(_br), YRP:ctr(_w), YRP:ctr(_h), Color(0, 0, 0, 255))
			draw.RoundedBox(0, px + spw - YRP:ctr(_h) - YRP:ctr(_br), YRP:ctr(_br), YRP:ctr(_h), YRP:ctr(_w), Color(0, 0, 0, 255))
			draw.RoundedBox(0, px + spw - YRP:ctr(_w) - YRP:ctr(_br), sph - YRP:ctr(_h) - YRP:ctr(_br), YRP:ctr(_w), YRP:ctr(_h), Color(0, 0, 0, 255))
			draw.RoundedBox(0, px + spw - YRP:ctr(_h) - YRP:ctr(_br), sph - YRP:ctr(_w) - YRP:ctr(_br), YRP:ctr(_h), YRP:ctr(_w), Color(0, 0, 0, 255))
			_br = 8
			_w = 32 - 2 * 4
			_h = 12 - 2 * 4
			--Inner
			draw.RoundedBox(0, px + YRP:ctr(_br), YRP:ctr(_br), YRP:ctr(_w), YRP:ctr(_h), Color(255, 255, 255, 255))
			draw.RoundedBox(0, px + YRP:ctr(_br), YRP:ctr(_br), YRP:ctr(_h), YRP:ctr(_w), Color(255, 255, 255, 255))
			draw.RoundedBox(0, px + YRP:ctr(_br), sph - YRP:ctr(_h) - YRP:ctr(_br), YRP:ctr(_w), YRP:ctr(_h), Color(255, 255, 255, 255))
			draw.RoundedBox(0, px + YRP:ctr(_br), sph - YRP:ctr(_w) - YRP:ctr(_br), YRP:ctr(_h), YRP:ctr(_w), Color(255, 255, 255, 255))
			draw.RoundedBox(0, px + spw - YRP:ctr(_w) - YRP:ctr(_br), YRP:ctr(_br), YRP:ctr(_w), YRP:ctr(_h), Color(255, 255, 255, 255))
			draw.RoundedBox(0, px + spw - YRP:ctr(_h) - YRP:ctr(_br), YRP:ctr(_br), YRP:ctr(_h), YRP:ctr(_w), Color(255, 255, 255, 255))
			draw.RoundedBox(0, px + spw - YRP:ctr(_w) - YRP:ctr(_br), sph - YRP:ctr(_h) - YRP:ctr(_br), YRP:ctr(_w), YRP:ctr(_h), Color(255, 255, 255, 255))
			draw.RoundedBox(0, px + spw - YRP:ctr(_h) - YRP:ctr(_br), sph - YRP:ctr(_w) - YRP:ctr(_br), YRP:ctr(_h), YRP:ctr(_w), Color(255, 255, 255, 255))
		end
	end

	function _ug:DoClick()
		if CURRENT_USERGROUP ~= nil then
			net.Start("nws_yrp_disconnect_Settings_UserGroup")
			net.WriteString(CURRENT_USERGROUP)
			net.SendToServer()
		end

		net.Start("nws_yrp_connect_Settings_UserGroup")
		net.WriteString(self.uid)
		net.SendToServer()
	end

	local P = DUGS[tonumber(tbl.uniqueID)]
	P.int_position = tonumber(tbl.int_position)
	P.uniqueID = tonumber(tbl.uniqueID)
	local UP = YRPCreateD("YButton", P, YRP:ctr(40), YRP:ctr(40), YRP:ctr(8), YRP:ctr(8))
	UP:SetText("")
	local up = UP
	function up:Paint(pw, ph)
		if P.int_position > 3 then
			hook.Run("YButtonPaint", self, pw, ph)
			if YRP:GetDesignIcon("64_angle-up") then
				surface.SetDrawColor(Color(255, 255, 255, 255))
				surface.SetMaterial(YRP:GetDesignIcon("64_angle-up"))
				surface.DrawTexturedRect(0, 0, pw, ph)
			end
		end
	end

	function up:DoClick()
		if P.int_position > 1 then
			net.Start("nws_yrp_settings_usergroup_position_up")
			net.WriteString(P.uniqueID)
			net.SendToServer()
		end
	end

	local DO = YRPCreateD("YButton", P, YRP:ctr(40), YRP:ctr(40), YRP:ctr(8), P:GetTall() - YRP:ctr(40 + 8))
	DO:SetText("")
	local dn = DO
	function dn:Paint(pw, ph)
		if UGS and P.int_position > 2 and P.int_position < table.Count(UGS) then
			hook.Run("YButtonPaint", self, pw, ph)
			if YRP:GetDesignIcon("64_angle-down") then
				surface.SetDrawColor(Color(255, 255, 255, 255))
				surface.SetMaterial(YRP:GetDesignIcon("64_angle-down"))
				surface.DrawTexturedRect(0, 0, pw, ph)
			end
		end
	end

	function dn:DoClick()
		if P.int_position > 2 and P.int_position < table.Count(UGS) then
			net.Start("nws_yrp_settings_usergroup_position_dn")
			net.WriteString(P.uniqueID)
			net.SendToServer()
		end
	end

	DUGS[tonumber(tbl.uniqueID)].icon = YRPCreateD("DHTML", _ug, _icon.size, _icon.size, _icon.br + UP:GetWide() + _icon.br, _icon.br)
	function _ug.UpdateIcon(uid, strIcon)
		uid = tonumber(uid)
		local HTMLCODE = YRPGetHTMLImage(strIcon, _icon.size, _icon.size)
		local icon = DUGS[uid].icon
		if icon then
			if strEmpty(HTMLCODE) then
				icon:SetHTML("")
			else
				icon:SetHTML(HTMLCODE)
			end

			YRPTestHTML(icon, strIcon, false)
		end
	end

	_ug.UpdateIcon(tonumber(tbl.uniqueID), tbl.string_icon)
	if not tobool(UGS[tonumber(tbl.uniqueID)].bool_removeable) then
		local protsize = 24
		DUGS[tonumber(tbl.uniqueID)].iconprot = YRPCreateD("DPanel", _ug, protsize, protsize, 2, _ug:GetTall() / 2 - protsize / 2)
		DUGS[tonumber(tbl.uniqueID)].iconprot.Paint = function(self, pw, ph)
			if YRP:GetDesignIcon("security") then
				surface.SetDrawColor(Color(0, 0, 0, 255))
				surface.SetMaterial(YRP:GetDesignIcon("security"))
				surface.DrawTexturedRect(0, 0, pw, ph)
				if UGS[tonumber(tbl.uniqueID)].string_name == "yrp_usergroups" then
					surface.SetDrawColor(255, 255, 0, 255)
				else
					surface.SetDrawColor(255, 136, 0, 255)
				end

				surface.SetMaterial(YRP:GetDesignIcon("security"))
				surface.DrawTexturedRect(1, 1, pw - 2, ph - 2)
			end
		end
	end

	PARENT.uglist:AddItem(_ug)
end

function RemUG(uid)
	if CURRENT_USERGROUP ~= nil then
		net.Start("nws_yrp_disconnect_Settings_UserGroup")
		net.WriteString(CURRENT_USERGROUP)
		net.SendToServer()
	end

	DUGS[tonumber(uid)]:Remove()
end

net.Receive(
	"nws_yrp_usergroup_rem",
	function(len)
		local uid = tonumber(net.ReadString())
		if DUGS[uid] ~= nil then
			RemUG(uid)
		end
	end
)

net.Receive(
	"nws_yrp_usergroup_add",
	function(len)
		local ugtab = net.ReadTable()
		for i, ug in pairs(ugtab) do
			if DUGS[tonumber(ug.uniqueID)] == nil then
				YRPAddUG(ug)
			end
		end
	end
)

function UpdateUsergroupsList()
	N_UGS = YRPSortUGS(N_UGS)
	local PARENT = GetSettingsSite()
	if YRPPanelAlive(PARENT) and YRPPanelAlive(PARENT.uglist) then
		PARENT.uglist:Clear()
		UGS = {}
		for i = 1, #N_UGS do
			local ug = N_UGS[i]
			if ug then
				ug.int_position = tonumber(ug.int_position)
				YRPAddUG(ug)
			end
		end
	end
end

function YRPClearUGList()
	N_UGS = {}
end

function YRPAddToUGList(ug)
	table.insert(N_UGS, ug)
end

net.Receive(
	"nws_yrp_updateUsergroupsList",
	function()
		_icon.size = YRP:ctr(100 - 16)
		_icon.br = YRP:ctr(8)
		local ug = {}
		if net.ReadBool() then
			YRPClearUGList()
		end

		ug.uniqueID = net.ReadUInt(16)
		ug.string_name = net.ReadString()
		ug.string_color = net.ReadString()
		ug.string_icon = net.ReadString()
		ug.bool_removeable = net.ReadBool()
		ug.int_position = net.ReadUInt(8)
		YRPAddToUGList(ug)
		if net.ReadBool() then
			UpdateUsergroupsList()
		end
	end
)

net.Receive(
	"nws_yrp_connect_Settings_UserGroups",
	function(len)
		local ug = {}
		if net.ReadBool() then
			YRPClearUGList()
		end

		ug.uniqueID = net.ReadUInt(16)
		ug.string_name = net.ReadString()
		ug.string_color = net.ReadString()
		ug.string_icon = net.ReadString()
		ug.bool_removeable = net.ReadBool()
		ug.int_position = net.ReadUInt(8)
		YRPAddToUGList(ug)
		if net.ReadBool() then
			UpdateUsergroupsList()
		end
	end
)

function YRPOpenSettingsUsergroups()
	local PARENT = GetSettingsSite()
	if YRPPanelAlive(PARENT) then
		CURRENT_USERGROUP = nil
		function PARENT:OnRemove()
			net.Start("nws_yrp_disconnect_Settings_UserGroups")
			net.SendToServer()
		end

		--[[ UserGroups Action Buttons ]]
		--
		local _ug_add = YRPCreateD("YButton", PARENT, YRP:ctr(50), YRP:ctr(50), YRP:ctr(20), YRP:ctr(20))
		_ug_add:SetText("+")
		function _ug_add:Paint(pw, ph)
			hook.Run("YButtonAPaint", self, pw, ph)
		end

		function _ug_add:DoClick()
			net.Start("nws_yrp_usergroup_add")
			net.SendToServer()
		end

		local _ug_rem = YRPCreateD("YButton", PARENT, YRP:ctr(50), YRP:ctr(50), YRP:ctr(20 + SW - 50), YRP:ctr(20))
		_ug_rem:SetText("-")
		function _ug_rem:Paint(pw, ph)
			if IsNotNilAndNotFalse(UGS[CURRENT_USERGROUP]) then
				if tobool(UGS[CURRENT_USERGROUP].bool_removeable) then
					hook.Run("YButtonRPaint", self, pw, ph)
				else
					draw.RoundedBox(13, 0, 0, pw, ph, Color(100, 100, 100, 255))
					draw.SimpleText("X", "Y_14_700", pw / 2, ph / 2, Color(0, 255, 0), 1, 1)
				end
			end
		end

		function _ug_rem:DoClick()
			if IsNotNilAndNotFalse(UGS[CURRENT_USERGROUP]) then
				if tobool(UGS[CURRENT_USERGROUP].bool_removeable) then
					net.Start("nws_yrp_usergroup_rem")
					net.WriteString(CURRENT_USERGROUP)
					net.SendToServer()
				else
					local win = YRPCreateD("YFrame", nil, 400, 120, 0, 0)
					if UGS[CURRENT_USERGROUP].string_name == "yrp_usergroups" then
						win:SetTitle("Backup Usergroup!")
					else
						win:SetTitle("Protected Usergroup!")
					end

					win:Center()
					win:MakePopup()
				end
			end
		end

		local _ugs_title = YRPCreateD("DPanel", PARENT, YRP:ctr(SW), YRP:ctr(50), YRP:ctr(20), YRP:ctr(20 + 50 + 20))
		function _ugs_title:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
			surfaceText(YRP:trans("LID_usergroups"), "Y_26_500", pw / 2, ph / 2, Color(0, 0, 0, 255), 1, 1)
		end

		--[[ UserGroupsList ]]
		--
		PARENT.uglist = YRPCreateD("DPanelList", PARENT, YRP:ctr(SW), PARENT:GetTall() - YRP:ctr(2 * 20 + 120), YRP:ctr(20), YRP:ctr(20 + 50 + 20 + 50))
		function PARENT.uglist:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
		end

		PARENT.uglist:EnableVerticalScrollbar(true)
	end

	net.Start("nws_yrp_connect_Settings_UserGroups")
	net.SendToServer()
end

net.Receive(
	"nws_yrp_usergroup_update_icon",
	function(len2)
		local uid = tonumber(net.ReadString())
		local string_icon = net.ReadString()
		if UGS and UGS[uid] and DUGS[uid] then
			UGS[uid].string_icon = string_icon
			ICON:SetText(UGS[uid].string_icon)
			local _ug = DUGS[uid]
			_ug.UpdateIcon(uid, UGS[uid].string_icon)
		end
	end
)
