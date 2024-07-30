--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local config = {}
-- CONFIG --
-- List Width
config.w = 2200
-- List Height
config.h = 1400
-- BR
config.br = 20
-- Header Height
config.hh = 80
-- CONFIG --
function YRPCreateCharacterSettingsContent()
	if LocalPlayer() == NULL then
		timer.Simple(1, YRPCreateCharacterSettingsContent)

		return
	end

	local parent = CharacterMenu or RoleMenu
	local ew = YRP:ctr(config.w - 4 * 20) / 3
	local site = YRPCreateD("DPanel", parent, parent:GetWide(), parent:GetTall(), 0, 0)
	function site:Paint(pw, ph)
	end

	local win = YRPCreateD("DPanel", site, YRP:ctr(config.w), YRP:ctr(config.h), 0, 0)
	function win:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, YRPInterfaceValue("YFrame", "NC"))
	end

	win:Center()
	-- DEBUG
	--[[local debug = YRPCreateD( "DButton", site, 25, 25, 400, 0)
	function debug:DoClick()
		parent:Remove()
	end]]
	local header = YRPCreateD("DPanel", site, YRP:ctr(1000), YRP:ctr(100), site:GetWide() / 2 - YRP:ctr(500), YRP:ctr(200))
	function header:Paint(pw, ph)
		draw.SimpleText(YRP:trans("LID_charactercreation"), "Y_36_500", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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
		parent:Clear()
		CreateRoleSelectionContent()
	end

	net.Receive(
		"nws_yrp_char_getrole",
		function(len)
			local rol = net.ReadTable()
			rol.int_namelength = tonumber(rol.int_namelength)
			-- TOP
			local descheader1 = YRPCreateD("YLabel", win, YRP:ctr(config.w - 2 * 20), YRP:ctr(config.hh), YRP:ctr(20), YRP:ctr(20))
			descheader1:SetText(rol.string_name)
			-- MID
			local pmsheader = YRPCreateD("YLabel", win, ew, YRP:ctr(config.hh), ew + 2 * YRP:ctr(20), YRP:ctr(20 + config.hh + 20))
			pmsheader:SetText("LID_character")
			local pmsbg = YRPCreateD("YPanel", win, ew, YRP:ctr(config.h - 520), ew + 2 * YRP:ctr(20), YRP:ctr(200))
			function pmsbg:Paint(pw, ph)
				hook.Run("YTextFieldPaint", self, pw, ph)
			end

			local pms = YRPCreateD("DModelPanel", win, pmsbg:GetWide(), pmsbg:GetTall(), ew + 2 * YRP:ctr(20), YRP:ctr(200))
			pms.models = string.Explode(",", tostring(rol.pms))
			pms:SetCamPos(Vector(50, 50, 50))
			pms:SetLookAt(Vector(0, 0, 40))
			pms:SetFOV(60)
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

			if pms.models[tonumber(LocalPlayer().charcreate_rpmid)] ~= nil then
				pms:SetModel(pms.models[tonumber(LocalPlayer().charcreate_rpmid)])
			end

			LocalPlayer().charcreate_name = ""
			LocalPlayer().charcreate_namelast = ""
			local confirm = YRPCreateD("YButton", win, ew, YRP:ctr(config.hh), ew + 2 * YRP:ctr(20), YRP:ctr(config.h - 100))
			confirm:SetText("LID_enteraname")
			function confirm:Paint(pw, ph)
				local tab = {}
				tab.color = YRPInterfaceValue("YButton", "NC")
				local nam = LocalPlayer().charcreate_name
				if rol.int_namelength == 0 then
					tab.color = Color(100, 255, 100)
					confirm:SetText("LID_confirm")
				elseif string.len(nam) > rol.int_namelength then
					tab.color = Color(255, 100, 100)
					confirm:SetText("LID_nameistolong")
				elseif string.len(nam) <= 0 then
					tab.color = Color(255, 255, 100)
					confirm:SetText("LID_nameistoshort")
				else
					tab.color = Color(100, 255, 100)
					confirm:SetText("LID_confirm")
				end

				hook.Run("YButtonPaint", self, pw, ph, tab)
			end

			function confirm:DoClick()
				local sname = LocalPlayer().charcreate_name
				if string.len(sname) <= rol.int_namelength and string.len(sname) > 0 or rol.int_namelength == 0 then
					local character = {}
					character.roleID = LocalPlayer().charcreate_ruid
					local name = LocalPlayer().charcreate_name
					if not strEmpty(LocalPlayer().charcreate_namelast) then
						name = name .. " " .. LocalPlayer().charcreate_namelast
					end

					character.rpname = name
					character.rpdescription = LocalPlayer().charcreate_desc
					character.playermodelID = LocalPlayer().charcreate_rpmid
					character.skin = 1
					character.bg = {}
					for i = 0, 19 do
						character.bg[i] = LocalPlayer()["charcreate_bg" .. i] or 0
					end

					character.birt = LocalPlayer().charcreate_birt
					character.bohe = LocalPlayer().charcreate_bohe or 0
					character.weig = LocalPlayer().charcreate_weig or 0
					character.nati = LocalPlayer().charcreate_nati
					character.create_eventchar = GetGlobalYRPBool("create_eventchar", false)
					net.Receive(
						"nws_yrp_create_own_character",
						function(nlen)
							local success = net.ReadBool()
							if success then
								if YRPPanelAlive(CharacterMenu, "CharacterMenu") then
									CharacterMenu:Remove()
								end

								YRPOpenCharacterSelection()
							else
								local pwin = YRPCreateD("YFrame", nil, 400, 200, 0, 0)
								pwin:SetTitle("LID_warning")
								pwin:Center()
								pwin:MakePopup()
								local invalid = net.ReadBool()
								pwin.warning = YRPCreateD("YLabel", pwin, 380, 200 - pwin:GetHeaderHeight() - 20, 10, pwin:GetHeaderHeight() + 10)
								if invalid then
									pwin.warning:SetText("RPNAME IS NIL, please talk to DEVELOPER")
								else
									pwin.warning:SetText("LID_nameisalreadyinuse")
								end
							end
						end
					)

					net.Start("nws_yrp_create_own_character")
					net.WriteTable(character)
					net.SendToServer()
				end
			end

			if rol.int_namelength > 0 then
				local name = YRPCreateD("DTextEntry", win, ew, YRP:ctr(config.hh), ew + 2 * YRP:ctr(20), YRP:ctr(config.h - 200) - YRP:ctr(config.hh) - YRP:ctr(20))
				name:SetText("")
				if name.SetPlaceholderText then
					name:SetPlaceholderText(YRP:trans("LID_enteryourfirstname"))
				end

				function name:PerformLayout()
					if self.SetUnderlineFont ~= nil then
						self:SetUnderlineFont("Y_18_500")
					end

					self:SetFontInternal("Y_18_500")
					self:SetFGColor(Color(255, 255, 255, 255))
					self:SetBGColor(Color(0, 0, 0, 255))
				end

				function name:OnChange()
					local nam = self:GetText()
					LocalPlayer().charcreate_name = nam
				end

				local surname = YRPCreateD("DTextEntry", win, ew, YRP:ctr(config.hh), ew + 2 * YRP:ctr(20), YRP:ctr(config.h - 200))
				surname:SetText("")
				if surname.SetPlaceholderText then
					surname:SetPlaceholderText(YRP:trans("LID_enteryoursurname"))
				end

				function surname:PerformLayout()
					if self.SetUnderlineFont ~= nil then
						self:SetUnderlineFont("Y_18_500")
					end

					self:SetFontInternal("Y_18_500")
					self:SetFGColor(Color(255, 255, 255, 255))
					self:SetBGColor(Color(0, 0, 0, 255))
				end

				function surname:OnChange()
					local nam = self:GetText()
					LocalPlayer().charcreate_namelast = nam
				end
			end

			-- LEFT
			if pms.Entity ~= nil then
				local bgs = pms.Entity:GetBodyGroups()
				local appeheader = YRPCreateD("YLabel", win, ew, YRP:ctr(config.hh), YRP:ctr(20), YRP:ctr(20 + config.hh + 20))
				appeheader:SetText("LID_appearance")
				local appe = YRPCreateD("DPanelList", win, ew, YRP:ctr(config.h - 2 * config.hh - 3 * config.br), YRP:ctr(20), YRP:ctr(20 + config.hh + 20 + config.hh))
				appe:EnableVerticalScrollbar()
				function appe:Paint(pw, ph)
					draw.RoundedBox(0, 0, 0, pw, ph, YRPInterfaceValue("YFrame", "BG"))
				end

				local sbar = appe.VBar
				function sbar:Paint(w, h)
					draw.RoundedBox(0, 0, 0, w, h, YRPInterfaceValue("YFrame", "NC"))
				end

				function sbar.btnUp:Paint(w, h)
					draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
				end

				function sbar.btnDown:Paint(w, h)
					draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
				end

				function sbar.btnGrip:Paint(w, h)
					draw.RoundedBox(w / 2, 0, 0, w, h, YRPInterfaceValue("YFrame", "HI"))
				end

				appe:SetSpacing(YRP:ctr(config.br))
				for _, bg in pairs(bgs) do
					LocalPlayer()["charcreate_bg" .. bg.id] = 0
					if table.Count(bg.submodels) > 1 then
						local pbg = YRPCreateD("DPanel", nil, ew, YRP:ctr(config.hh * 2), 0, 0)
						function pbg:Paint(pw, ph)
							draw.RoundedBox(0, 0, 0, pw, ph, YRPInterfaceValue("YFrame", "PC"))
							draw.SimpleText(LocalPlayer()["charcreate_bg" .. bg.id] + 1 .. "/" .. table.Count(bg.submodels) .. " " .. bg["name"], "Y_18_500", YRP:ctr(config.hh + config.br), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
						end

						local skinup = YRPCreateD("YButton", pbg, YRP:ctr(config.hh * 0.8), YRP:ctr(config.hh * 0.8), YRP:ctr(config.hh * 0.1), YRP:ctr(config.hh * 0.1))
						skinup:SetText("")
						function skinup:Paint(pw, ph)
							if LocalPlayer()["charcreate_bg" .. bg.id] + 1 < table.Count(bg.submodels) then
								hook.Run("YButtonPaint", self, pw, ph)
								surface.SetDrawColor(Color(255, 255, 255, 255))
								surface.SetMaterial(YRP:GetDesignIcon("64_angle-up"))
								surface.DrawTexturedRect(0, 0, pw, ph)
							end
						end

						function skinup:DoClick()
							if LocalPlayer()["charcreate_bg" .. bg.id] + 1 < table.Count(bg.submodels) then
								LocalPlayer()["charcreate_bg" .. bg.id] = LocalPlayer()["charcreate_bg" .. bg.id] + 1
								pms.Entity:SetBodygroup(bg.id, LocalPlayer()["charcreate_bg" .. bg.id])
							end
						end

						local skindn = YRPCreateD("YButton", pbg, YRP:ctr(config.hh * 0.8), YRP:ctr(config.hh * 0.8), YRP:ctr(config.hh * 0.1), YRP:ctr(config.hh + config.hh * 0.1))
						skindn:SetText("")
						function skindn:Paint(pw, ph)
							if LocalPlayer()["charcreate_bg" .. bg.id] > 0 then
								hook.Run("YButtonPaint", self, pw, ph)
								surface.SetDrawColor(Color(255, 255, 255, 255))
								surface.SetMaterial(YRP:GetDesignIcon("64_angle-down"))
								surface.DrawTexturedRect(0, 0, pw, ph)
							end
						end

						function skindn:DoClick()
							if LocalPlayer()["charcreate_bg" .. bg.id] > 0 then
								LocalPlayer()["charcreate_bg" .. bg.id] = LocalPlayer()["charcreate_bg" .. bg.id] - 1
								pms.Entity:SetBodygroup(bg.id, LocalPlayer()["charcreate_bg" .. bg.id])
							end
						end

						appe:AddItem(pbg)
					end
				end
			end

			-- RIGHT
			local lis = YRPCreateD("DPanelList", win, ew, YRP:ctr(config.h - config.br * 2 - config.hh - config.br), ew * 2 + 3 * YRP:ctr(20), YRP:ctr(120))
			lis:EnableVerticalScrollbar()
			function lis:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, YRPInterfaceValue("YFrame", "BG"))
			end

			local sbar = lis.VBar
			function sbar:Paint(w, h)
				draw.RoundedBox(0, 0, 0, w, h, YRPInterfaceValue("YFrame", "NC"))
			end

			function sbar.btnUp:Paint(w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
			end

			function sbar.btnDown:Paint(w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
			end

			function sbar.btnGrip:Paint(w, h)
				draw.RoundedBox(w / 2, 0, 0, w, h, YRPInterfaceValue("YFrame", "HI"))
			end

			local hr = YRPCreateD("DPanel", nil, ew, YRP:ctr(config.br), 0, 0)
			function hr:Paint(pw, ph)
			end

			-- Birthday
			if GetGlobalYRPBool("bool_characters_birthday", false) then
				local birtheader = YRPCreateD("YLabel", nil, ew, YRP:ctr(config.hh), ew * 2 + 3 * YRP:ctr(20), 0)
				birtheader:SetText("LID_birthday")
				lis:AddItem(birtheader)
				local birt = YRPCreateD("DTextEntry", nil, ew, YRP:ctr(config.hh), ew * 2 + 3 * YRP:ctr(20), 0)
				birt:SetText("")
				function birt:PerformLayout()
					if self.SetUnderlineFont ~= nil then
						self:SetUnderlineFont("Y_18_500")
					end

					self:SetFontInternal("Y_18_500")
					self:SetFGColor(Color(255, 255, 255, 255))
					self:SetBGColor(Color(0, 0, 0, 255))
				end

				function birt:OnChange()
					LocalPlayer().charcreate_birt = self:GetText()
				end

				lis:AddItem(birt)
				lis:AddItem(hr)
			end

			-- Bodyheight
			if GetGlobalYRPBool("bool_characters_bodyheight", false) then
				local boheheader = YRPCreateD("YLabel", nil, ew, YRP:ctr(config.hh), ew * 2 + 3 * YRP:ctr(20), 0)
				boheheader:SetText("LID_bodyheight")
				lis:AddItem(boheheader)
				local bohe = YRPCreateD("DNumberWang", nil, ew, YRP:ctr(config.hh), ew * 2 + 3 * YRP:ctr(20), 0)
				bohe:SetText("")
				bohe:SetFontInternal("Y_18_500")
				function bohe:OnChange()
					LocalPlayer().charcreate_bohe = self:GetText()
				end

				lis:AddItem(bohe)
				lis:AddItem(hr)
			end

			-- Weight
			if GetGlobalYRPBool("bool_characters_weight", false) then
				local weigheader = YRPCreateD("YLabel", nil, ew, YRP:ctr(config.hh), ew * 2 + 3 * YRP:ctr(20), 0)
				weigheader:SetText("LID_weight")
				lis:AddItem(weigheader)
				local weig = YRPCreateD("DNumberWang", nil, ew, YRP:ctr(config.hh), ew * 2 + 3 * YRP:ctr(20), 0)
				weig:SetText("")
				weig:SetFontInternal("Y_18_500")
				function weig:OnChange()
					LocalPlayer().charcreate_weig = self:GetText()
				end

				lis:AddItem(weig)
				lis:AddItem(hr)
			end

			-- Description
			local descheader = YRPCreateD("YLabel", nil, ew, YRP:ctr(config.hh), ew * 2 + 3 * YRP:ctr(20), 0)
			descheader:SetText("LID_description")
			lis:AddItem(descheader)
			local desc = YRPCreateD("DTextEntry", nil, ew, YRP:ctr(400), ew * 2 + 3 * YRP:ctr(20), 0)
			desc:SetMultiline(true)
			desc:SetText("")
			function desc:PerformLayout()
				if self.SetUnderlineFont ~= nil then
					self:SetUnderlineFont("Y_18_500")
				end

				self:SetFontInternal("Y_18_500")
				self:SetFGColor(Color(255, 255, 255, 255))
				self:SetBGColor(Color(0, 0, 0, 255))
			end

			function desc:OnChange()
				LocalPlayer().charcreate_desc = self:GetText()
			end

			lis:AddItem(desc)
		end
	)

	timer.Simple(
		0.2,
		function()
			net.Start("nws_yrp_char_getrole")
			net.WriteString(LocalPlayer().charcreate_ruid)
			net.SendToServer()
		end
	)
end
