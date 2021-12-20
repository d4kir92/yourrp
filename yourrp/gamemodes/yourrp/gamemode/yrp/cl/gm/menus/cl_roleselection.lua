--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

local config = {}

-- CONFIG --

-- List Width
config.w = 2200
-- List Height
config.h = 1400
-- BR
config.br = 20

-- CONFIG --



local menu = nil



function CreateRolePreviewContent()
	local parent = CharacterMenu or RoleMenu

	if !pa(parent) then
		YRP.msg( "note", "[CreateRolePreviewContent] failed to get Parent" )
		return
	end

	local nw = YRP.ctr( config.w)
	local nh = YRP.ctr( config.h)
	if !LocalPlayer().cc then
		nw = parent:GetWide()
		nh = parent:GetTall()
	end
	local ew = (nw - YRP.ctr(4 * 20) ) / 3
	local hh = 80



	if pa(menu) then
		menu:Hide()
	end



	-- Fake POPUP
	local win = createD( "DPanel", parent, nw, nh, 0, 0)
	function win:Paint(pw, ph)
		local color = LocalPlayer():InterfaceValue( "YFrame", "NC" )
		if color then
			draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, color)
		end
	end
	win:Center()



	net.Receive( "yrp_roleselection_getrole", function(len)
		local rol = net.ReadTable()
	
		LocalPlayer().rolepreview = true
	


		-- TOP
		local descheader = createD( "YLabel", win, nw - YRP.ctr(2 * 20), YRP.ctr(hh), YRP.ctr(20), YRP.ctr(20) )
		descheader:SetText(rol.string_name)



		-- LEFT
		local descheader = createD( "YLabel", win, ew, YRP.ctr(hh), YRP.ctr(20), YRP.ctr(20 + hh + 20) )
		descheader:SetText( "LID_description" )
		
		local descbg = createD( "DPanel", win, ew, nh - YRP.ctr(20 + hh + 20 + hh + 20 + hh + 20 + hh), YRP.ctr(20), YRP.ctr(20 + hh + 20 + hh) )
		function descbg:Paint(pw, ph)
			hook.Run( "YTextFieldPaint", self, pw, ph)
		end

		local desc = createD( "RichText", win, ew - YRP.ctr(20 + 20), nh - YRP.ctr(20 + hh + 20 + hh + 20 + hh + 20 + hh + 20 + 20), YRP.ctr(40), YRP.ctr(20 + hh + 20 + hh + 20) )
		function desc:PerformLayout()
			if self.SetUnderlineFont != nil then
				self:SetUnderlineFont( "Y_18_500" )
			end
			self:SetFontInternal( "Y_18_500" )

			self:SetBGColor(Color(50, 50, 50) )
			self:SetFGColor(Color(255, 255, 255) )
		end
		desc:SetText(tostring(rol.string_description) )

		if tonumber(rol.int_salary) > 0 then
			local salaryheader = createD( "YLabel", win, ew, YRP.ctr(hh), YRP.ctr(20), nh - YRP.ctr(hh + 20 + hh) )
			salaryheader:SetText( "LID_salary" )

			local salary = createD( "YLabel", win, ew, YRP.ctr(hh), YRP.ctr(20), nh - YRP.ctr(20 + hh) )
			salary:SetText( MoneyFormat(rol.int_salary) )
			function salary:Paint(pw, ph)
				hook.Run( "YTextFieldPaint", self, pw, ph)
			end
		else
			descbg:SetTall( nh - YRP.ctr(20 + hh + 20 + hh + 20) )
			desc:SetTall( nh - YRP.ctr(20 + hh + 20 + hh + 20 + 20) )
		end



		-- MID
		local pmsheader = createD( "YLabel", win, ew, YRP.ctr(hh), ew + 2 * YRP.ctr(20), YRP.ctr(20 + hh + 20) )
		pmsheader:SetText( "LID_chooseyourplayermodel" )

		local pmsbg = createD( "YPanel", win, ew, nh - YRP.ctr(20 + hh + 20 + hh + 20), ew + 2 * YRP.ctr(20), YRP.ctr(20 + hh + 20 + hh) )
		function pmsbg:Paint(pw, ph)
			hook.Run( "YTextFieldPaint", self, pw, ph)
		end

		local pms = createD( "DModelPanel", win, ew, nh - YRP.ctr(20 + hh + 20 + hh + 20), ew + 2 * YRP.ctr(20), YRP.ctr(20 + hh + 20 + hh) )
		pms.models = string.Explode( ",", rol.pms)
		LocalPlayer().charcreate_rpmid = 1
		pms.id = LocalPlayer().charcreate_rpmid
		pms:SetCamPos( Vector( 80, 0, 40 ) )
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
		function pms:OnMouseWheeled(scrollDelta)
			self.zoom = self.zoom or 80
			self.zoom = self.zoom + scrollDelta
			pms:SetCamPos( Vector( self.zoom, 0, 40 ) )
		end

		if pms.models[1] != nil then
			pms:SetModel(pms.models[1])
		end

		local nextpm = createD( "YButton", pms, YRP.ctr(64), YRP.ctr(64), pms:GetWide() - YRP.ctr(64 + 20), YRP.ctr(450) )
		nextpm:SetText( "" )
		function nextpm:Paint(pw, ph)
			if pms.id + 1 <= table.Count(pms.models) then
				--draw.SimpleText(self:GetText(), "Y_30_500", pw / 2, ph / 2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)--hook.Run( "YButtonPaint", self, pw, ph)
				
				if YRP.GetDesignIcon( "64_angle-right" ) then
					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetMaterial( YRP.GetDesignIcon( "64_angle-right" ) )
					surface.DrawTexturedRect(0, 0, pw, ph)
				end
			end
		end
		function nextpm:DoClick()
			if pms.id + 1 <= table.Count(pms.models) then
				pms.id = pms.id + 1
				pms:SetModel(pms.models[pms.id])
				LocalPlayer().charcreate_rpmid = pms.id
			end
		end

		local prevpm = createD( "YButton", pms, YRP.ctr(64), YRP.ctr(64), YRP.ctr(20), YRP.ctr(450) )
		prevpm:SetText( "" )
		function prevpm:Paint(pw, ph)
			if pms.id - 1 > 0 then
				--draw.SimpleText(self:GetText(), "Y_30_500", pw / 2, ph / 2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)--hook.Run( "YButtonPaint", self, pw, ph)
				
				if YRP.GetDesignIcon( "64_angle-left" ) then
					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetMaterial( YRP.GetDesignIcon( "64_angle-left" ) )
					surface.DrawTexturedRect(0, 0, pw, ph)
				end
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
		local swepsheader = createD( "YLabel", win, ew, YRP.ctr(hh), ew * 2 + 3 * YRP.ctr(20), YRP.ctr(20 + hh + 20) )
		swepsheader:SetText( "LID_equipment" )

		local swepsbg = createD( "YPanel", win, ew, nh - YRP.ctr(20 + hh + 20 + hh + 20 + hh + 20 + 20 + hh), ew * 2 + 3 * YRP.ctr(20), YRP.ctr(20 + hh + 20 + hh) )
		function swepsbg:Paint(pw, ph)
			hook.Run( "YTextFieldPaint", self, pw, ph)

			draw.SimpleText(GetSWEPPrintName(LocalPlayer().preview_swep or "NO SWEPS" ), "Y_18_500", pw / 2, YRP.ctr(50), Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local sweps = createD( "DModelPanel", win, ew, nh - YRP.ctr(20 + hh + 20 + hh + 20 + hh + 20 + 20 + hh), ew * 2 + 3 * YRP.ctr(20), YRP.ctr(20 + hh + 20 + hh) )
		sweps.models = string.Explode( ",", rol.string_sweps)
		sweps.id = 1
		sweps:SetCamPos( Vector( 50, 0, 0 ) )
		sweps:SetLookAt( Vector( 0, 0, 0 ) )
		sweps:SetFOV( 45 )
		sweps:SetAnimated(true)
		sweps.Angles = Angle(0, 90, 0)
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
		function sweps:OnMouseWheeled(scrollDelta)
			self.zoom = self.zoom or 50
			self.zoom = self.zoom + scrollDelta
			sweps:SetCamPos( Vector( self.zoom, 0, 0 ) )
		end
		if sweps.models[1] != nil then
			sweps:SetModel(GetSWEPWorldModel(sweps.models[1]) )
			LocalPlayer().preview_swep = sweps.models[1]
		end

		local nextpm = createD( "YButton", sweps, YRP.ctr(64), YRP.ctr(64), sweps:GetWide() - YRP.ctr(64 + 20), YRP.ctr(450) )
		nextpm:SetText( "" )
		function nextpm:Paint(pw, ph)
			if sweps.id + 1 <= table.Count(sweps.models) then
				--draw.SimpleText(self:GetText(), "Y_30_500", pw / 2, ph / 2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)--hook.Run( "YButtonPaint", self, pw, ph)
				
				if YRP.GetDesignIcon( "64_angle-right" ) then
					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetMaterial( YRP.GetDesignIcon( "64_angle-right" ) )
					surface.DrawTexturedRect(0, 0, pw, ph)
				end
			end
		end
		function nextpm:DoClick()
			if sweps.id + 1 <= table.Count(sweps.models) then
				sweps.id = sweps.id + 1
				sweps:SetModel(GetSWEPWorldModel(sweps.models[sweps.id]) )
				LocalPlayer().preview_swep = sweps.models[sweps.id]
			end
		end

		local prevpm = createD( "YButton", sweps, YRP.ctr(64), YRP.ctr(64), YRP.ctr(20), YRP.ctr(450) )
		prevpm:SetText( "" )
		function prevpm:Paint(pw, ph)
			if sweps.id - 1 > 0 then
				--draw.SimpleText(self:GetText(), "Y_30_500", pw / 2, ph / 2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)--hook.Run( "YButtonPaint", self, pw, ph)
				
				if YRP.GetDesignIcon( "64_angle-left" ) then
					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetMaterial( YRP.GetDesignIcon( "64_angle-left" ) )
					surface.DrawTexturedRect(0, 0, pw, ph)
				end
			end
		end
		function prevpm:DoClick()
			if sweps.id - 1 > 0 then
				sweps.id = sweps.id - 1
				sweps:SetModel(GetSWEPWorldModel(sweps.models[sweps.id]) )
				LocalPlayer().preview_swep = sweps.models[sweps.id]
			end
		end

		if GetGlobalBool( "bool_players_can_switch_role", false) or LocalPlayer().cc then
			local getrole = createD( "YButton", win, ew, YRP.ctr(hh), nw - ew - YRP.ctr(20), nh - 2 * YRP.ctr(hh + 20) )
			getrole:SetText( "LID_getrole" )
			function getrole:DoClick()
				if LocalPlayer().cc then
					if pa(parent) then
						parent:Clear()
					end

					YRPCreateCharacterSettingsContent()
				else
					net.Start( "wantRole" )
						net.WriteInt(LocalPlayer().charcreate_ruid, 16)
						net.WriteInt(LocalPlayer().charcreate_rpmid, 16)
					net.SendToServer()
					CloseCombinedMenu()
					CloseRoleMenu()
				end
			end
		end

		local back = createD( "YButton", win, ew, YRP.ctr(hh), nw - ew - YRP.ctr(20), nh - YRP.ctr(hh + 20) )
		back:SetText( "LID_back" )
		function back:Paint(pw, ph)
			if LocalPlayer().rolepreview then
				hook.Run( "YButtonRPaint", self, pw, ph)
			end
		end
		function back:DoClick()
			if LocalPlayer().rolepreview then
				if pa(menu) then
					menu:Show()
				end
				win:Remove()
				LocalPlayer().rolepreview = false
			end
		end
	end)

	timer.Simple(0.2, function()

		if LocalPlayer().charcreate_ruid != nil then
			net.Start( "yrp_roleselection_getrole" )
				net.WriteString(LocalPlayer().charcreate_ruid)
			net.SendToServer()
		else
			yrpmsg( ">>> FAIL yrp_roleselection_getrole" )
		end
	end)
end



function CreateRoleSelectionContent(PARENT)
	if LocalPlayer() == NULL then
		yrpmsg( ">>> FAIL CreateRoleSelectionContent" )
		return
	end


	local parent = PARENT or CharacterMenu or RoleMenu
	


	LocalPlayer().rolepreview = false



	local SW = nil
	local SH = nil
	if LocalPlayer().cc then
		SW = YRP.ctr( config.w)
		SH = YRP.ctr( config.h)
	else
		SW = parent:GetWide()
		SH = parent:GetTall()
		if parent.GetContent != nil then
			SW = parent:GetContent():GetWide()
			SH = parent:GetContent():GetTall()
		end
	end

	
	local site = createD( "DPanel", parent, ScrW(), ScrH(), 0, 0)
	function site:Paint(pw, ph)
		if !LocalPlayer().cc then
			if self:GetWide() != parent:GetWide() then
				SW = parent:GetWide()
				SH = parent:GetTall()
				self:SetSize(SW, SH)
			end
		end
	end

	local win = createD( "DPanel", site, SW, SH, 0, 0)
	function win:Paint(pw, ph)
		draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, LocalPlayer():InterfaceValue( "YFrame", "BG" ) )

		if win:GetWide() != SW then
			win:SetWide(SW)
		end
		win:Center()
	end
	win:Center()

	menu = win

	-- List of Groups
	local list = createD( "DPanelList", win, win:GetWide() - YRP.ctr(2 * config.br), win:GetTall() - YRP.ctr(2 * config.br), YRP.ctr( config.br), YRP.ctr( config.br) )
	list:EnableVerticalScrollbar()
	list:SetSpacing(YRP.ctr( config.br) )
	function list:Paint(pw, ph)
		--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 0, 0) )
		if list:GetWide() != win:GetWide() - YRP.ctr(2 * config.br) then
			list:SetWide(win:GetWide() - YRP.ctr(2 * config.br) )
		end
	end
	local sbar = list.VBar
	function sbar:Paint(w, h)
		if LocalPlayer().InterfaceValue and LocalPlayer():InterfaceValue( "YFrame", "NC" ) then
			draw.RoundedBox(0, 0, 0, w, h, LocalPlayer():InterfaceValue( "YFrame", "NC" ) )
		end
	end
	function sbar.btnUp:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60) )
	end
	function sbar.btnDown:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60) )
	end
	function sbar.btnGrip:Paint(w, h)
		if LocalPlayer().InterfaceValue and LocalPlayer():InterfaceValue( "YFrame", "HI" ) then
			draw.RoundedBox(w / 2, 0, 0, w, h, LocalPlayer():InterfaceValue( "YFrame", "HI" ) )
		end
	end



	if LocalPlayer().cc then -- for Character Creation
		local header = createD( "DPanel", site, YRP.ctr(1000), YRP.ctr(100), site:GetWide() / 2 - YRP.ctr(500), YRP.ctr(200) )
		function header:Paint(pw, ph)
			draw.SimpleText(YRP.lang_string( "LID_chooseyourrole" ), "Y_36_500", pw / 2, ph / 2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local btn = {}
		btn.w = 500
		btn.h = 75

		local back = createD( "YButton", site, YRP.ctr( btn.w), YRP.ctr( btn.h), site:GetWide() / 2 - YRP.ctr( btn.w) / 2, ScH() - YRP.ctr(200) )
		back:SetText( "LID_back" )
		function back:Paint(pw, ph)
			hook.Run( "YButtonRPaint", self, pw, ph)
		end
		function back:DoClick()
			if !LocalPlayer().onefaction and (!LocalPlayer().rolepreview and LocalPlayer():GetNW2Int( "char_count", 0) > 0) then
				if pa(parent) then
					parent:Clear()
				end

				CreateFactionSelectionContent()
			elseif LocalPlayer().onefaction then
				if pa(parent) then
					parent:Remove()
				end
				openCharacterSelection()
			else
				if pa(parent) then
					parent:Clear()
				end

				CreateFactionSelectionContent()
			end
		end
	end



	-- Groups
	net.Receive( "yrp_roleselection_getgroups", function(len)
		if pa(list) then
			local gtab = net.ReadTable()

			local factioncount = tonumber(net.ReadString() )

			local w = list:GetWide() -- YRP.ctr(2 * config.br)
			local h = YRP.ctr(100)

			for i, grp in pairs(gtab) do
				grp.uniqueID = tonumber(grp.uniqueID)
				
				if pa(list) then
					-- Category Group
					local group = createD( "YCollapsibleCategory", list, w, h, 0, 0)
					group:SetS(w, h)
					group:SetHeader(grp.string_name)
					group:SetIcon(grp.string_icon)
					group:SetList(list)
					group:SetHeaderColor(StringToColor(grp.string_color) )
					group:SetContentColor(StringToColor(grp.string_color) )
					group:SetGroupUID(grp.uniqueID)
					group:SetFixedHeight(list:GetTall() * 2)
					function group:Think()
						w = list:GetWide()
						if w != self:GetWide() then
							self:SetWide(w)
						end
					end

					if !LocalPlayer().cc and GetGlobalBool( "bool_players_can_switch_faction", false) and factioncount > 1 then
						local changefaction = createD( "YButton", group, YRP.ctr(500), group:GetTall() - 2 * YRP.ctr(20), group:GetWide() - YRP.ctr(500 + 20), YRP.ctr(20) )
						changefaction:SetText( "LID_changefaction" )
						function changefaction:Think()
							local px, py = self:GetPos()
							if px != group:GetWide() - YRP.ctr(500 + 20) then
								self:SetPos(group:GetWide() - YRP.ctr(500 + 20), YRP.ctr(20) )
							end
						end
						function changefaction:DoClick()
							LocalPlayer().cc = false
							menu:Hide()
							CreateFactionSelectionContent()
						end
					end

					list:AddItem(group)

					group.btn:DoClick()
				else
					break
				end
			end
		end
	end)
	net.Start( "yrp_roleselection_getgroups" )
		net.WriteString(LocalPlayer().charcreate_fuid)
	net.SendToServer()
end
