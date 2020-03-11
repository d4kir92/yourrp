--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local config = {}

-- CONFIG --

-- List Width
config.w = 2200
-- List Height
config.h = 1400
-- BR
config.br = 20

-- CONFIG --



function CreateRolePreviewContent()
	local lply = LocalPlayer()



	local parent = CharacterMenu or RoleMenu



	local ew = YRP.ctr(config.w - 4 * 20) / 3



	-- Fake POPUP
	local win = createD("DPanel", parent, YRP.ctr(config.w), YRP.ctr(config.h), 0, 0)
	function win:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, lply:InterfaceValue("YFrame", "NC"))
	end
	win:Center()



	net.Receive("yrp_roleselection_getrole", function(len)
		local rol = net.ReadTable()
	

		-- TOP
		local descheader = createD("YLabel", win, YRP.ctr(config.w - 2 * 20), YRP.ctr(60), YRP.ctr(20), YRP.ctr(20))
		descheader:SetText(rol.string_name)



		-- LEFT
		local descheader = createD("YLabel", win, ew, YRP.ctr(60), YRP.ctr(20), YRP.ctr(20 + 60 + 20))
		descheader:SetText("LID_description")
		
		local descbg = createD("DPanel", win, ew, YRP.ctr(config.h - (20 + 60 + 20 + 60 + 20) - (60 + 20 + 60)), YRP.ctr(20), YRP.ctr(20 + 60 + 20 + 60))
		function descbg:Paint(pw, ph)
			hook.Run("YTextFieldPaint", self, pw, ph)
		end

		local desc = createD("RichText", win, ew -  YRP.ctr(20 + 20), YRP.ctr(config.h - (20 + 60 + 20 + 60 + 20) - (60 + 20 + 60) - 20 - 20), YRP.ctr(40), YRP.ctr(20 + 60 + 20 + 60 + 20))
		function desc:PerformLayout()
			if self.SetUnderlineFont != nil then
				self:SetUnderlineFont("Y_" .. 18 .. "_500")
			end
			self:SetFontInternal("Y_" .. 18 .. "_500")

			self:SetBGColor(Color(50, 50, 50))
			self:SetFGColor(Color(255, 255, 255))
		end
		desc:SetText(rol.string_description)

		local salaryheader = createD("YLabel", win, ew, YRP.ctr(60), YRP.ctr(20), YRP.ctr(config.h - 60 - 20 - 60))
		salaryheader:SetText("LID_salary")

		local salary = createD("YLabel", win, ew, YRP.ctr(60), YRP.ctr(20), YRP.ctr(config.h - 20 - 60))
		salary:SetText(MoneyFormat(rol.int_salary))
		function salary:Paint(pw, ph)
			hook.Run("YTextFieldPaint", self, pw, ph)
		end



		-- MID
		local pmsheader = createD("YLabel", win, ew, YRP.ctr(60), ew + 2 * YRP.ctr(20), YRP.ctr(20 + 60 + 20))
		pmsheader:SetText("LID_chooseyourplayermodel")

		local pmsbg = createD("YPanel", win, ew, YRP.ctr(config.h - 20 - 60 - 20 - 60 - 20), ew + 2 * YRP.ctr(20), YRP.ctr(20 + 60 + 20 + 60))
		function pmsbg:Paint(pw, ph)
			hook.Run("YTextFieldPaint", self, pw, ph)
		end

		local pms = createD("DModelPanel", win, ew, YRP.ctr(config.h - 20 - 60 - 20 - 60 - 20), ew + 2 * YRP.ctr(20), YRP.ctr(20 + 60 + 20 + 60))
		pms.models = string.Explode(",", rol.pms)
		lply:SetDString("charcreate_rpmid", 1)
		pms.id = lply:GetDString("charcreate_rpmid", 1)
		pms:SetCamPos( Vector( 50, 50, 50 ) )
		pms:SetLookAt( Vector( 0, 0, 40 ) )
		pms:SetFOV( 45 )
		pms:SetAnimated(true)
		pms.Angles = Angle(0, 0, 0)
		function pms:DragMousePress()
			self.PressX, self.PressY = gui.MousePos()
			self.Pressed = true
		end
		function pms:DragMouseRelease()
			self.Pressed = false
		end
		function pms:LayoutEntity( ent )
			if (self.bAnimated) then self:RunAnimation() end
			if (self.Pressed) then
				local mx, _ = gui.MousePos()
				self.Angles = self.Angles - Angle(0, (self.PressX or mx) - mx, 0)

				self.PressX, self.PressY = gui.MousePos()
				if ent != nil then
					ent:SetAngles(self.Angles)
				end
			end
		end
		if pms.models[1] != nil then
			pms:SetModel(pms.models[1])
		end

		local nextpm = createD("YButton", pms, YRP.ctr(60), YRP.ctr(60), pms:GetWide() - YRP.ctr(60 + 20), pms:GetTall() / 2 - YRP.ctr(30))
		nextpm:SetText(">")
		function nextpm:Paint(pw, ph)
			if pms.id + 1 <= table.Count(pms.models) then
				hook.Run("YButtonPaint", self, pw, ph)
			end
		end
		function nextpm:DoClick()
			if pms.id + 1 <= table.Count(pms.models) then
				pms.id = pms.id + 1
				pms:SetModel(pms.models[pms.id])
				lply:SetDString("charcreate_rpmid", pms.id)
			end
		end

		local prevpm = createD("YButton", pms, YRP.ctr(60), YRP.ctr(60), YRP.ctr(20), pms:GetTall() / 2 - YRP.ctr(30))
		prevpm:SetText("<")
		function prevpm:Paint(pw, ph)
			if pms.id - 1 > 0 then
				hook.Run("YButtonPaint", self, pw, ph)
			end
		end
		function prevpm:DoClick()
			if pms.id - 1 > 0 then
				pms.id = pms.id - 1
				pms:SetModel(pms.models[pms.id])
				lply:SetDString("charcreate_rpmid", pms.id)
			end
		end



		-- RIGHT
		local swepsheader = createD("YLabel", win, ew, YRP.ctr(60), ew * 2 + 3 * YRP.ctr(20), YRP.ctr(20 + 60 + 20))
		swepsheader:SetText("LID_equipment")

		local swepsbg = createD("YPanel", win, ew, YRP.ctr(config.h - 20 - 60 - 20 - 60 - 20 - 60 - 20 - 20 - 20 - 40), ew * 2 + 3 * YRP.ctr(20), YRP.ctr(20 + 60 + 20 + 60))
		function swepsbg:Paint(pw, ph)
			hook.Run("YTextFieldPaint", self, pw, ph)

			draw.SimpleText(GetSWEPPrintName(lply:GetDString("preview_swep", "NO SWEPs")), "Y_18_500", pw / 2, YRP.ctr(50), Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local sweps = createD("DModelPanel", win, ew, swepsbg:GetTall(), ew * 2 + 3 * YRP.ctr(20), YRP.ctr(20 + 60 + 20))
		sweps.models = string.Explode(",", rol.string_sweps)
		sweps.id = 1
		sweps:SetCamPos( Vector( 50, -50, 0 ) )
		sweps:SetLookAt( Vector( 0, 0, 0 ) )
		sweps:SetFOV( 45 )
		sweps:SetAnimated(true)
		sweps.Angles = Angle(0, 0, 0)
		function sweps:DragMousePress()
			self.PressX, self.PressY = gui.MousePos()
			self.Pressed = true
		end
		function sweps:DragMouseRelease()
			self.Pressed = false
		end
		function sweps:LayoutEntity( ent )
			if (self.bAnimated) then self:RunAnimation() end
			if (self.Pressed) then
				local mx, _ = gui.MousePos()
				self.Angles = self.Angles - Angle(0, (self.PressX or mx) - mx, 0)

				self.PressX, self.PressY = gui.MousePos()
				if ent != nil then
					ent:SetAngles(self.Angles)
				end
			end
		end
		if sweps.models[1] != nil then
			sweps:SetModel(GetSWEPWorldModel(sweps.models[1]))
			lply:SetDString("preview_swep", sweps.models[1])
		end

		local nextpm = createD("YButton", sweps, YRP.ctr(60), YRP.ctr(60), sweps:GetWide() - YRP.ctr(60 + 20), sweps:GetTall() / 2 - YRP.ctr(30))
		nextpm:SetText(">")
		function nextpm:Paint(pw, ph)
			if sweps.id + 1 <= table.Count(sweps.models) then
				hook.Run("YButtonPaint", self, pw, ph)
			end
		end
		function nextpm:DoClick()
			if sweps.id + 1 <= table.Count(sweps.models) then
				sweps.id = sweps.id + 1
				sweps:SetModel(GetSWEPWorldModel(sweps.models[sweps.id]))
				lply:SetDString("preview_swep", sweps.models[sweps.id])
			end
		end

		local prevpm = createD("YButton", sweps, YRP.ctr(60), YRP.ctr(60), YRP.ctr(20), sweps:GetTall() / 2 - YRP.ctr(30))
		prevpm:SetText("<")
		function prevpm:Paint(pw, ph)
			if sweps.id - 1 > 0 then
				hook.Run("YButtonPaint", self, pw, ph)
			end
		end
		function prevpm:DoClick()
			if sweps.id - 1 > 0 then
				sweps.id = sweps.id - 1
				sweps:SetModel(GetSWEPWorldModel(sweps.models[sweps.id]))
				lply:SetDString("preview_swep", sweps.models[sweps.id])
			end
		end

		local getrole = createD("YButton", win, ew, YRP.ctr(60), YRP.ctr(config.w) - ew - YRP.ctr(20), YRP.ctr(config.h) - 2 * YRP.ctr(60 + 20))
		getrole:SetText("LID_getrole")
		function getrole:DoClick()
			parent:Clear()

			CreateCharacterSettingsContent()
		end

		local back = createD("YButton", win, ew, YRP.ctr(60), YRP.ctr(config.w) - ew - YRP.ctr(20), YRP.ctr(config.h) - YRP.ctr(60 + 20))
		back:SetText("LID_back")
		function back:DoClick()
			win:Remove()
		end
	end)
	net.Start("yrp_roleselection_getrole")
		net.WriteString(lply:GetDString("charcreate_ruid", 0))
	net.SendToServer()
end

function CreateRoleSelectionContent()
	local lply = LocalPlayer()



	local parent = CharacterMenu or RoleMenu



	local site = createD("DPanel", parent, parent:GetWide(), parent:GetTall(), 0, 0)
	function site:Paint(pw, ph)
	end

	local win = createD("DPanel", site, YRP.ctr(config.w), YRP.ctr(config.h), 0, 0)
	function win:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, lply:InterfaceValue("YFrame", "NC"))
	end
	win:Center()

	-- List of Groups
	local list = createD("DPanelList", win, YRP.ctr(config.w - 2 * config.br), YRP.ctr(config.h - 2 * config.br), YRP.ctr(config.br), YRP.ctr(config.br))
	list:EnableVerticalScrollbar()
	list:SetSpacing(YRP.ctr(config.br))
	function list:Paint(pw, ph)
		--draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 255))
	end
	local sbar = list.VBar
	function sbar:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, lply:InterfaceValue("YFrame", "NC"))
	end
	function sbar.btnUp:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
	end
	function sbar.btnDown:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
	end
	function sbar.btnGrip:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, lply:InterfaceValue("YFrame", "HI"))
	end



	if LocalPlayer():GetDBool("cc", true) then -- for Character Creation
		local header = createD("DPanel", site, YRP.ctr(1000), YRP.ctr(100), site:GetWide() / 2 - YRP.ctr(500), YRP.ctr(200))
		function header:Paint(pw, ph)
			draw.SimpleText(YRP.lang_string("LID_chooseyourrole"), "Y_36_700", pw / 2, ph / 2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local btn = {}
		btn.w = 400
		btn.h = 50

		local back = createD("YButton", site, YRP.ctr(btn.w), YRP.ctr(btn.h), site:GetWide() / 2 - YRP.ctr(btn.w) / 2, ScH() - YRP.ctr(200))
		back:SetText("LID_back")
		function back:DoClick()
			parent:Clear()

			CreateFactionSelectionContent()
		end

		local debug = createD("DButton", site, 25, 25, 400, 0)
		function debug:DoClick()
			parent:Remove()
		end
	end



	-- Groups
	net.Receive("yrp_roleselection_getgroups", function(len)
		local gtab = net.ReadTable()

		local w = YRP.ctr(config.w - 2 * config.br)
		local h = YRP.ctr(100)

		for i, grp in pairs(gtab) do
			grp.uniqueID = tonumber(grp.uniqueID)
			
			-- Category Group
			local group = createD("YCollapsibleCategory", list, w, h, 0, 0)
			group:SetS(w, h)
			group:SetHeader(grp.string_name)
			group:SetIcon(grp.string_icon)
			group:SetList(list)
			group:SetHeaderColor(StringToColor(grp.string_color))
			group:SetContentColor(StringToColor(grp.string_color))
			group:SetGroupUID(grp.uniqueID)

			list:AddItem(group)
		end
	end)
	net.Start("yrp_roleselection_getgroups")
		net.WriteString(lply:GetDString("charcreate_fuid", "0"))
	net.SendToServer()
end