--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local config = {}
-- CONFIG --
-- List Width
config.w = 2200
-- List Height
config.h = 1400
-- BR
config.br = 20
-- CONFIG --
local menue = nil
function CreateRolePreviewContent()
	local parent = CharacterMenu or RoleMenu
	if not YRPPanelAlive(parent) then
		YRP:msg("note", "[CreateRolePreviewContent] failed to get Parent")

		return
	end

	local nw = YRP:ctr(config.w)
	local nh = YRP:ctr(config.h)
	if not LocalPlayer().cc then
		nw = parent:GetWide()
		nh = parent:GetTall()
	end

	local ew = (nw - YRP:ctr(4 * 20)) / 3
	local hh = 80
	if YRPPanelAlive(menue) then
		menue:Hide()
	end

	-- Fake POPUP
	local win = YRPCreateD("DPanel", parent, nw, nh, 0, 0)
	function win:Paint(pw, ph)
		local color = YRPInterfaceValue("YFrame", "NC")
		if color then
			draw.RoundedBox(YRP:ctr(10), 0, 0, pw, ph, color)
		end
	end

	win:Center()
	net.Receive(
		"nws_yrp_roleselection_getrole",
		function(len)
			local rol = net.ReadTable()
			LocalPlayer().rolepreview = true
			-- TOP
			local descheader1 = YRPCreateD("YLabel", win, nw - YRP:ctr(2 * 20), YRP:ctr(hh), YRP:ctr(20), YRP:ctr(20))
			descheader1:SetText(rol.string_name)
			-- LEFT
			local descheader2 = YRPCreateD("YLabel", win, ew, YRP:ctr(hh), YRP:ctr(20), YRP:ctr(20 + hh + 20))
			descheader2:SetText("LID_description")
			local descbg = YRPCreateD("DPanel", win, ew, nh - YRP:ctr(20 + hh + 20 + hh + 20 + hh + 20 + hh), YRP:ctr(20), YRP:ctr(20 + hh + 20 + hh))
			function descbg:Paint(pw, ph)
				hook.Run("YTextFieldPaint", self, pw, ph)
			end

			local desc = YRPCreateD("RichText", win, ew - YRP:ctr(20 + 20), nh - YRP:ctr(20 + hh + 20 + hh + 20 + hh + 20 + hh + 20 + 20), YRP:ctr(40), YRP:ctr(20 + hh + 20 + hh + 20))
			function desc:PerformLayout()
				if self.SetUnderlineFont ~= nil then
					self:SetUnderlineFont("Y_18_500")
				end

				self:SetFontInternal("Y_18_500")
				self:SetBGColor(Color(50, 50, 50))
				self:SetFGColor(Color(255, 255, 255, 255))
			end

			desc:SetText(tostring(rol.string_description))
			if tonumber(rol.int_salary) > 0 then
				local salaryheader = YRPCreateD("YLabel", win, ew, YRP:ctr(hh), YRP:ctr(20), nh - YRP:ctr(hh + 20 + hh))
				salaryheader:SetText("LID_salary")
				local salary = YRPCreateD("YLabel", win, ew, YRP:ctr(hh), YRP:ctr(20), nh - YRP:ctr(20 + hh))
				salary:SetText(MoneyFormat(rol.int_salary))
				function salary:Paint(pw, ph)
					hook.Run("YTextFieldPaint", self, pw, ph)
				end
			else
				descbg:SetTall(nh - YRP:ctr(20 + hh + 20 + hh + 20))
				desc:SetTall(nh - YRP:ctr(20 + hh + 20 + hh + 20 + 20))
			end

			-- MID
			local pmsheader = YRPCreateD("YLabel", win, ew, YRP:ctr(hh), ew + 2 * YRP:ctr(20), YRP:ctr(20 + hh + 20))
			pmsheader:SetText("LID_chooseyourplayermodel")
			local pmsbg = YRPCreateD("YPanel", win, ew, nh - YRP:ctr(20 + hh + 20 + hh + 20), ew + 2 * YRP:ctr(20), YRP:ctr(20 + hh + 20 + hh))
			function pmsbg:Paint(pw, ph)
				hook.Run("YTextFieldPaint", self, pw, ph)
			end

			local pms = YRPCreateD("DModelPanel", win, ew, nh - YRP:ctr(20 + hh + 20 + hh + 20), ew + 2 * YRP:ctr(20), YRP:ctr(20 + hh + 20 + hh))
			pms.models = string.Explode(",", rol.pms)
			LocalPlayer().charcreate_rpmid = 1
			pms.id = LocalPlayer().charcreate_rpmid
			pms:SetCamPos(Vector(80, 0, 40))
			pms:SetLookAt(Vector(0, 0, 40))
			pms:SetFOV(45)
			pms:SetAnimated(true)
			pms.Angles = Angle(0, 0, 0)
			function pms:DragMousePress()
				self.PressX, self.PressY = gui.MousePos()
				self.Pressed = true
			end

			function pms:DragMouseRelease()
				self.Pressed = false
			end

			function pms:LayoutEntity(ent)
				if self.bAnimated then
					self:RunAnimation()
				end

				if self.Pressed then
					local mx, _ = gui.MousePos()
					self.Angles = self.Angles - Angle(0, (self.PressX or mx) - mx, 0)
					self.PressX, self.PressY = gui.MousePos()
					if ent ~= nil then
						ent:SetAngles(self.Angles)
					end
				end
			end

			function pms:OnMouseWheeled(scrollDelta)
				self.zoom = self.zoom or 80
				self.zoom = self.zoom + scrollDelta
				pms:SetCamPos(Vector(self.zoom, 0, 40))
			end

			if pms.models[1] ~= nil then
				pms:SetModel(pms.models[1])
			end

			local nextpm = YRPCreateD("YButton", pms, YRP:ctr(64), YRP:ctr(64), pms:GetWide() - YRP:ctr(64 + 20), YRP:ctr(450))
			nextpm:SetText("")
			function nextpm:Paint(pw, ph)
				if pms.id + 1 <= table.Count(pms.models) and YRP:GetDesignIcon("64_angle-right") then
					surface.SetDrawColor(Color(255, 255, 255, 255))
					surface.SetMaterial(YRP:GetDesignIcon("64_angle-right"))
					surface.DrawTexturedRect(0, 0, pw, ph)
				end
			end

			function nextpm:DoClick()
				if pms.id + 1 <= table.Count(pms.models) then
					pms.id = pms.id + 1
					pms:SetModel(pms.models[pms.id])
					LocalPlayer().charcreate_rpmid = pms.id
				end
			end

			local prevpm = YRPCreateD("YButton", pms, YRP:ctr(64), YRP:ctr(64), YRP:ctr(20), YRP:ctr(450))
			prevpm:SetText("")
			function prevpm:Paint(pw, ph)
				if pms.id - 1 > 0 and YRP:GetDesignIcon("64_angle-left") then
					surface.SetDrawColor(Color(255, 255, 255, 255))
					surface.SetMaterial(YRP:GetDesignIcon("64_angle-left"))
					surface.DrawTexturedRect(0, 0, pw, ph)
				end
			end

			function prevpm:DoClick()
				if pms.id - 1 > 0 then
					pms.id = pms.id - 1
					pms:SetModel(pms.models[pms.id])
					LocalPlayer().charcreate_rpmid = pms.id
				end
			end

			-- RIGHT
			local swepsheader = YRPCreateD("YLabel", win, ew, YRP:ctr(hh), ew * 2 + 3 * YRP:ctr(20), YRP:ctr(20 + hh + 20))
			swepsheader:SetText("LID_equipment")
			local swepsbg = YRPCreateD("YPanel", win, ew, nh - YRP:ctr(20 + hh + 20 + hh + 20 + hh + 20 + 20 + hh), ew * 2 + 3 * YRP:ctr(20), YRP:ctr(20 + hh + 20 + hh))
			function swepsbg:Paint(pw, ph)
				hook.Run("YTextFieldPaint", self, pw, ph)
				draw.SimpleText(GetSWEPPrintName(LocalPlayer().preview_swep or "NO SWEPS"), "Y_18_500", pw / 2, YRP:ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			local sweps = YRPCreateD("DModelPanel", win, ew, nh - YRP:ctr(20 + hh + 20 + hh + 20 + hh + 20 + 20 + hh), ew * 2 + 3 * YRP:ctr(20), YRP:ctr(20 + hh + 20 + hh))
			sweps.models = string.Explode(",", rol.string_sweps)
			sweps.id = 1
			sweps:SetCamPos(Vector(50, 0, 0))
			sweps:SetLookAt(Vector(0, 0, 0))
			sweps:SetFOV(45)
			sweps:SetAnimated(true)
			sweps.Angles = Angle(0, 90, 0)
			function sweps:DragMousePress()
				self.PressX, self.PressY = gui.MousePos()
				self.Pressed = true
			end

			function sweps:DragMouseRelease()
				self.Pressed = false
			end

			function sweps:LayoutEntity(ent)
				if self.bAnimated then
					self:RunAnimation()
				end

				if self.Pressed then
					local mx, _ = gui.MousePos()
					self.Angles = self.Angles - Angle(0, (self.PressX or mx) - mx, 0)
					self.PressX, self.PressY = gui.MousePos()
					if ent ~= nil then
						ent:SetAngles(self.Angles)
					end
				end
			end

			function sweps:OnMouseWheeled(scrollDelta)
				self.zoom = self.zoom or 50
				self.zoom = self.zoom + scrollDelta
				sweps:SetCamPos(Vector(self.zoom, 0, 0))
			end

			if sweps.models[1] ~= nil then
				sweps:SetModel(GetSWEPWorldModel(sweps.models[1]))
				LocalPlayer().preview_swep = sweps.models[1]
			end

			local nextpm2 = YRPCreateD("YButton", sweps, YRP:ctr(64), YRP:ctr(64), sweps:GetWide() - YRP:ctr(64 + 20), YRP:ctr(450))
			nextpm2:SetText("")
			function nextpm2:Paint(pw, ph)
				if sweps.id + 1 <= table.Count(sweps.models) and YRP:GetDesignIcon("64_angle-right") then
					surface.SetDrawColor(Color(255, 255, 255, 255))
					surface.SetMaterial(YRP:GetDesignIcon("64_angle-right"))
					surface.DrawTexturedRect(0, 0, pw, ph)
				end
			end

			function nextpm2:DoClick()
				if sweps.id + 1 <= table.Count(sweps.models) then
					sweps.id = sweps.id + 1
					sweps:SetModel(GetSWEPWorldModel(sweps.models[sweps.id]))
					LocalPlayer().preview_swep = sweps.models[sweps.id]
				end
			end

			local prevpm2 = YRPCreateD("YButton", sweps, YRP:ctr(64), YRP:ctr(64), YRP:ctr(20), YRP:ctr(450))
			prevpm2:SetText("")
			function prevpm2:Paint(pw, ph)
				if sweps.id - 1 > 0 and YRP:GetDesignIcon("64_angle-left") then
					surface.SetDrawColor(Color(255, 255, 255, 255))
					surface.SetMaterial(YRP:GetDesignIcon("64_angle-left"))
					surface.DrawTexturedRect(0, 0, pw, ph)
				end
			end

			function prevpm2:DoClick()
				if sweps.id - 1 > 0 then
					sweps.id = sweps.id - 1
					sweps:SetModel(GetSWEPWorldModel(sweps.models[sweps.id]))
					LocalPlayer().preview_swep = sweps.models[sweps.id]
				end
			end

			if GetGlobalYRPBool("bool_players_can_switch_role", false) or LocalPlayer().cc then
				local getrole = YRPCreateD("YButton", win, ew, YRP:ctr(hh), nw - ew - YRP:ctr(20), nh - 2 * YRP:ctr(hh + 20))
				getrole:SetText("LID_getrole")
				function getrole:DoClick()
					if LocalPlayer().cc then
						if YRPPanelAlive(parent) then
							parent:Clear()
						end

						YRPCreateCharacterSettingsContent()
					else
						local bgs = {}
						for i = 0, 19 do
							bgs[i] = LocalPlayer()["charcreate_bg" .. i]
						end

						net.Start("nws_yrp_want_role_char")
						net.WriteInt(LocalPlayer().charcreate_ruid, 16)
						net.WriteInt(LocalPlayer().charcreate_rpmid, 16)
						net.WriteTable(bgs)
						net.SendToServer()
						YRPCloseCombinedMenu()
						CloseRoleMenu()
					end
				end
			end

			local back = YRPCreateD("YButton", win, ew, YRP:ctr(hh), nw - ew - YRP:ctr(20), nh - YRP:ctr(hh + 20))
			back:SetText("LID_back")
			function back:Paint(pw, ph)
				if LocalPlayer().rolepreview then
					hook.Run("YButtonRPaint", self, pw, ph)
				end
			end

			function back:DoClick()
				if LocalPlayer().rolepreview then
					if YRPPanelAlive(menue) then
						menue:Show()
					end

					win:Remove()
					LocalPlayer().rolepreview = false
				end
			end
		end
	)

	timer.Simple(
		0.2,
		function()
			if LocalPlayer().charcreate_ruid ~= nil then
				net.Start("nws_yrp_roleselection_getrole")
				net.WriteString(LocalPlayer().charcreate_ruid)
				net.SendToServer()
			else
				yrpmsg(">>> FAIL yrp_roleselection_getrole")
			end
		end
	)
end

function CreateRoleSelectionContent(PARENT)
	if LocalPlayer() == NULL then
		yrpmsg(">>> FAIL CreateRoleSelectionContent")

		return
	end

	local parent = PARENT or CharacterMenu or RoleMenu
	LocalPlayer().rolepreview = false
	local SW = nil
	local SH = nil
	if LocalPlayer().cc then
		SW = YRP:ctr(config.w)
		SH = YRP:ctr(config.h)
	else
		SW = parent:GetWide()
		SH = parent:GetTall()
		if parent.GetContent ~= nil then
			SW = parent:GetContent():GetWide()
			SH = parent:GetContent():GetTall()
		end
	end

	local site = YRPCreateD("DPanel", parent, ScrW(), ScrH(), 0, 0)
	function site:Paint(pw, ph)
		if not LocalPlayer().cc and self:GetWide() ~= parent:GetWide() then
			SW = parent:GetWide()
			SH = parent:GetTall()
			self:SetSize(SW, SH)
		end
	end

	local win = YRPCreateD("DPanel", site, SW, SH, 0, 0)
	function win:Paint(pw, ph)
		draw.RoundedBox(YRP:ctr(10), 0, 0, pw, ph, YRPInterfaceValue("YFrame", "BG"))
		if win:GetWide() ~= SW then
			win:SetWide(SW)
		end

		win:Center()
	end

	win:Center()
	menue = win
	-- List of Groups
	local lis = YRPCreateD("DPanelList", win, win:GetWide() - YRP:ctr(2 * config.br), win:GetTall() - YRP:ctr(2 * config.br), YRP:ctr(config.br), YRP:ctr(config.br))
	lis:EnableVerticalScrollbar()
	lis:SetSpacing(YRP:ctr(config.br))
	function lis:Paint(pw, ph)
		--draw.RoundedBox(0, 0, 0, pw, ph, Color( 0, 255, 0 ) )
		if lis:GetWide() ~= win:GetWide() - YRP:ctr(2 * config.br) then
			lis:SetWide(win:GetWide() - YRP:ctr(2 * config.br))
		end
	end

	local sbar = lis.VBar
	function sbar:Paint(w, h)
		if LocalPlayer().InterfaceValue and YRPInterfaceValue("YFrame", "NC") then
			draw.RoundedBox(0, 0, 0, w, h, YRPInterfaceValue("YFrame", "NC"))
		end
	end

	function sbar.btnUp:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
	end

	function sbar.btnDown:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
	end

	function sbar.btnGrip:Paint(w, h)
		if LocalPlayer().InterfaceValue and YRPInterfaceValue("YFrame", "HI") then
			draw.RoundedBox(w / 2, 0, 0, w, h, YRPInterfaceValue("YFrame", "HI"))
		end
	end

	-- for Character Creation
	if LocalPlayer().cc then
		local header = YRPCreateD("DPanel", site, YRP:ctr(1000), YRP:ctr(100), site:GetWide() / 2 - YRP:ctr(500), YRP:ctr(200))
		function header:Paint(pw, ph)
			draw.SimpleText(YRP:trans("LID_chooseyourrole"), "Y_36_500", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local btn = {}
		btn.w = 500
		btn.h = 75
		local back = YRPCreateD("YButton", site, YRP:ctr(btn.w), YRP:ctr(btn.h), site:GetWide() / 2 - YRP:ctr(btn.w) / 2, ScH() - YRP:ctr(200))
		back:SetText("LID_back")
		function back:Paint(pw, ph)
			hook.Run("YButtonRPaint", self, pw, ph)
		end

		function back:DoClick()
			if not LocalPlayer().onefaction and (not LocalPlayer().rolepreview and LocalPlayer():GetYRPInt("char_count", 0) > 0) then
				if YRPPanelAlive(parent) then
					parent:Clear()
				end

				CreateFactionSelectionContent()
			elseif LocalPlayer().onefaction then
				if YRPPanelAlive(parent) then
					parent:Remove()
				end

				YRPOpenCharacterSelection()
			else
				if YRPPanelAlive(parent) then
					parent:Clear()
				end

				CreateFactionSelectionContent()
			end
		end
	end

	-- Groups
	net.Receive(
		"nws_yrp_roleselection_getgroups",
		function(len)
			if YRPPanelAlive(lis) then
				local gtab = net.ReadTable()
				local factioncount = tonumber(net.ReadString())
				local w = lis:GetWide() -- YRP:ctr(2 * config.br)
				local h = YRP:ctr(100)
				for i, grp in SortedPairsByMemberValue(gtab, "int_position") do
					grp.uniqueID = tonumber(grp.uniqueID)
					if YRPPanelAlive(lis) then
						-- Category Group
						local group = YRPCreateD("YCollapsibleCategory", lis, w, h, 0, 0)
						group:SetS(w, h)
						group:SetHeader(grp.string_name)
						group:SetIcon(grp.string_icon)
						group:SetList(lis)
						group:SetHeaderColor(StringToColor(grp.string_color))
						group:SetContentColor(StringToColor(grp.string_color))
						group:SetGroupUID(grp.uniqueID)
						group:SetFixedHeight(lis:GetTall() * 2)
						function group:Think()
							w = lis:GetWide()
							if w ~= self:GetWide() then
								self:SetWide(w)
							end
						end

						if not LocalPlayer().cc and GetGlobalYRPBool("bool_players_can_switch_faction", false) and factioncount > 1 then
							local changefaction = YRPCreateD("YButton", group, YRP:ctr(500), group:GetTall() - 2 * YRP:ctr(20), group:GetWide() - YRP:ctr(500 + 20), YRP:ctr(20))
							changefaction:SetText("LID_changefaction")
							function changefaction:Think()
								local px, _ = self:GetPos()
								if px ~= group:GetWide() - YRP:ctr(500 + 20) then
									self:SetPos(group:GetWide() - YRP:ctr(500 + 20), YRP:ctr(20))
								end
							end

							function changefaction:DoClick()
								LocalPlayer().cc = false
								menue:Hide()
								CreateFactionSelectionContent()
							end
						end

						lis:AddItem(group)
						group.btn:DoClick()
					else
						break
					end
				end
			end
		end
	)

	net.Start("nws_yrp_roleselection_getgroups")
	net.WriteString(LocalPlayer().charcreate_fuid)
	net.SendToServer()
end
