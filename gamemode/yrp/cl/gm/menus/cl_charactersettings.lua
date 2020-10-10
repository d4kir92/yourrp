--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

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



function CreateCharacterSettingsContent()
	local lply = LocalPlayer()



	local parent = CharacterMenu or RoleMenu



	local ew = YRP.ctr(config.w - 4 * 20) / 3



	local site = createD("DPanel", parent, parent:GetWide(), parent:GetTall(), 0, 0)
	function site:Paint(pw, ph)
	end

	local win = createD("DPanel", site, YRP.ctr(config.w), YRP.ctr(config.h), 0, 0)
	function win:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, lply:InterfaceValue("YFrame", "NC"))
	end
	win:Center()
	


	-- DEBUG
	--[[local debug = createD("DButton", site, 25, 25, 400, 0)
	function debug:DoClick()
		parent:Remove()
	end]]



	local header = createD("DPanel", site, YRP.ctr(1000), YRP.ctr(100), site:GetWide() / 2 - YRP.ctr(500), YRP.ctr(200))
	function header:Paint(pw, ph)
		draw.SimpleText(YRP.lang_string("LID_charactercreation"), "Y_36_500", pw / 2, ph / 2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local btn = {}
	btn.w = 500
	btn.h = 75
	local back = createD("YButton", site, YRP.ctr(btn.w), YRP.ctr(btn.h), site:GetWide() / 2 - YRP.ctr(btn.w) / 2, ScH() - YRP.ctr(200))
	back:SetText("LID_back")
	function back:Paint(pw, ph)
		hook.Run("YButtonRPaint", self, pw, ph)
	end
	function back:DoClick()
		parent:Clear()

		CreateRoleSelectionContent()
	end
	


	net.Receive("yrp_char_getrole", function(len)
		local rol = net.ReadTable()
		rol.int_namelength = tonumber(rol.int_namelength)

		-- TOP
		local descheader = createD("YLabel", win, YRP.ctr(config.w - 2 * 20), YRP.ctr(config.hh), YRP.ctr(20), YRP.ctr(20))
		descheader:SetText(rol.string_name)



		-- MID
		local pmsheader = createD("YLabel", win, ew, YRP.ctr(config.hh), ew + 2 * YRP.ctr(20), YRP.ctr(20 + config.hh + 20))
		pmsheader:SetText("LID_character")

		local pmsbg = createD("YPanel", win, ew, YRP.ctr(config.h - 320), ew + 2 * YRP.ctr(20), YRP.ctr(200))
		function pmsbg:Paint(pw, ph)
			hook.Run("YTextFieldPaint", self, pw, ph)
		end

		local pms = createD("DModelPanel", win, ew, YRP.ctr(config.h - 320), ew + 2 * YRP.ctr(20), YRP.ctr(200))
		pms.models = string.Explode(",", rol.pms)
		pms:SetCamPos( Vector( 50, 50, 50 ) )
		pms:SetLookAt( Vector( 0, 0, 40 ) )
		pms:SetFOV( 50 )
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
		if pms.models[tonumber(lply:GetDString("charcreate_rpmid", pms.id))] != nil then
			pms:SetModel(pms.models[tonumber(lply:GetDString("charcreate_rpmid", pms.id))])
		end

		lply:SetDString("charcreate_name", "")
		local confirm = createD("YButton", win, ew, YRP.ctr(config.hh), ew + 2 * YRP.ctr(20), YRP.ctr(config.h - 100))
		confirm:SetText("LID_enteraname")
		function confirm:Paint(pw, ph)
			local tab = {}
			tab.color = lply:InterfaceValue("YButton", "NC")
			local nam = lply:GetDString("charcreate_name", "")
			if rol.int_namelength == 0 then
				tab.color = Color(100, 255, 100)
				confirm:SetText("LID_confirm")
			elseif string.len(nam) > rol.int_namelength then
				tab.color = Color(255, 100, 100)
				confirm:SetText("LID_nameistolong")
			elseif string.len(nam) <= 0 then
				tab.color = Color(255, 255, 100)
				confirm:SetText("LID_enteraname")
			else
				tab.color = Color(100, 255, 100)
				confirm:SetText("LID_confirm")
			end
			hook.Run("YButtonPaint", self, pw, ph, tab)
		end
		function confirm:DoClick()
			local name = lply:GetDString("charcreate_name", "")
			if string.len(name) <= rol.int_namelength and string.len(name) > 0 or rol.int_namelength == 0 then
				local character = {}
				character.roleID = lply:GetDString("charcreate_ruid")
				character.rpname = lply:GetDString("charcreate_name")
				character.rpdescription = lply:GetDString("charcreate_desc")
				character.gender = "male"
				character.playermodelID = lply:GetDString("charcreate_rpmid")
				character.skin = 1
				character.bg = {}
				for i = 0, 19 do
					character.bg[i] = lply:GetDInt("charcreate_bg" .. i, 0)
				end

				character.birt = lply:GetDString("charcreate_birt")
				character.bohe = lply:GetDString("charcreate_bohe")
				character.weig = lply:GetDString("charcreate_weig")
				character.nati = lply:GetDString("charcreate_nati")

				net.Start("CreateCharacter")
					net.WriteTable(character)
				net.SendToServer()

				CharacterMenu:Remove()
				openCharacterSelection()
			end
		end


		
		-- LEFT
		if pms.Entity != nil then
			local bgs = pms.Entity:GetBodyGroups()
			local appeheader = createD("YLabel", win, ew, YRP.ctr(config.hh), YRP.ctr(20), YRP.ctr(20 + config.hh + 20))
			appeheader:SetText("LID_appearance")
			local appe = createD("DPanelList", win, ew, YRP.ctr(config.h - 2 * config.hh - 3 * config.br), YRP.ctr(20), YRP.ctr(20 + config.hh + 20 + config.hh))
			appe:EnableVerticalScrollbar()
			function appe:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, lply:InterfaceValue("YFrame", "BG"))
			end
			local sbar = appe.VBar
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
				draw.RoundedBox(w / 2, 0, 0, w, h, lply:InterfaceValue("YFrame", "HI"))
			end
			appe:SetSpacing(YRP.ctr(config.br))

			for _, bg in pairs(bgs) do
				lply:SetDInt("charcreate_bg" .. bg.id, 0)
				if table.Count(bg.submodels) > 1 then
					local pbg = createD("DPanel", nil, ew, YRP.ctr(config.hh * 2), 0, 0)
					function pbg:Paint(pw, ph)
						draw.RoundedBox(0, 0, 0, pw, ph, lply:InterfaceValue("YFrame", "PC"))
						draw.SimpleText(lply:GetDInt("charcreate_bg" .. bg.id, 0) + 1 .. "/" .. table.Count(bg.submodels) .. " " .. bg["name"], "Y_18_500", YRP.ctr(config.hh + config.br), ph / 2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					end

					local skinup = createD("YButton", pbg, YRP.ctr(config.hh * 0.8), YRP.ctr(config.hh * 0.8), YRP.ctr(config.hh * 0.1), YRP.ctr(config.hh * 0.1))
					skinup:SetText("")
					function skinup:Paint(pw, ph)
						if lply:GetDInt("charcreate_bg" .. bg.id, 0) + 1 < table.Count(bg.submodels) then
							hook.Run("YButtonPaint", self, pw, ph)

							surface.SetDrawColor(255, 255, 255, 255)
							surface.SetMaterial(YRP.GetDesignIcon("64_angle-up"))
							surface.DrawTexturedRect(0, 0, pw, ph)
						end
					end
					function skinup:DoClick()
						if lply:GetDInt("charcreate_bg" .. bg.id, 0) + 1 < table.Count(bg.submodels) then
							lply:SetDInt("charcreate_bg" .. bg.id, lply:GetDInt("charcreate_bg" .. bg.id, 0) + 1)
							pms.Entity:SetBodygroup(bg.id, lply:GetDInt("charcreate_bg" .. bg.id, 0))
						end
					end

					local skindn = createD("YButton", pbg, YRP.ctr(config.hh * 0.8), YRP.ctr(config.hh * 0.8), YRP.ctr(config.hh * 0.1), YRP.ctr(config.hh + config.hh * 0.1))
					skindn:SetText("")
					function skindn:Paint(pw, ph)
						if lply:GetDInt("charcreate_bg" .. bg.id, 0) > 0 then
							hook.Run("YButtonPaint", self, pw, ph)

							surface.SetDrawColor(255, 255, 255, 255)
							surface.SetMaterial(YRP.GetDesignIcon("64_angle-down"))
							surface.DrawTexturedRect(0, 0, pw, ph)
						end
					end
					function skindn:DoClick()
						if lply:GetDInt("charcreate_bg" .. bg.id, 0) > 0 then
							lply:SetDInt("charcreate_bg" .. bg.id, lply:GetDInt("charcreate_bg" .. bg.id, 0) - 1)
							pms.Entity:SetBodygroup(bg.id, lply:GetDInt("charcreate_bg" .. bg.id, 0))
						end
					end

					appe:AddItem(pbg)
				end
			end
		end



		-- RIGHT
		local list = createD("DPanelList", win, ew, YRP.ctr(config.h - config.br * 2 - config.hh - config.br), ew * 2 + 3 * YRP.ctr(20), YRP.ctr(120))
		list:EnableVerticalScrollbar()
		function list:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, lply:InterfaceValue("YFrame", "BG"))
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
			draw.RoundedBox(w / 2, 0, 0, w, h, lply:InterfaceValue("YFrame", "HI"))
		end

		local hr = createD("DPanel", nil, ew, YRP.ctr(config.br), 0, 0)
		function hr:Paint(pw, ph)
		end
	
		if rol.int_namelength > 0 then
			local nameheader = createD("YLabel", nil, ew, YRP.ctr(config.hh), ew * 2 + 3 * YRP.ctr(20), YRP.ctr(120))
			nameheader:SetText("LID_name")
			list:AddItem(nameheader)
	
			local name = createD("DTextEntry", nil, ew, YRP.ctr(config.hh), ew * 2 + 3 * YRP.ctr(20), YRP.ctr(200))
			name:SetText("")
			function name:PerformLayout()
				if self.SetUnderlineFont != nil then
					self:SetUnderlineFont("Y_18_500")
				end
				self:SetFontInternal("Y_18_500")

				self:SetFGColor(Color(255, 255, 255))
				self:SetBGColor(Color(0, 0, 0))
			end
			function name:OnChange()
				local nam = self:GetText()
				lply:SetDString("charcreate_name", nam)
				if #nam > rol.int_namelength then
					--name:SetText(string.sub(nam, 1, rol.int_namelength))
				end
			end
			list:AddItem(name)

			list:AddItem(hr)
		end

		-- Birthday
		if GetGlobalDBool("bool_characters_birthday", false) then
			local birtheader = createD("YLabel", nil, ew, YRP.ctr(config.hh), ew * 2 + 3 * YRP.ctr(20), 0)
			birtheader:SetText("LID_birthday")
			list:AddItem(birtheader)

			local birt = createD("DTextEntry", nil, ew, YRP.ctr(config.hh), ew * 2 + 3 * YRP.ctr(20), 0)
			birt:SetText("")
			function birt:PerformLayout()
				if self.SetUnderlineFont != nil then
					self:SetUnderlineFont("Y_18_500")
				end
				self:SetFontInternal("Y_18_500")

				self:SetFGColor(Color(255, 255, 255))
				self:SetBGColor(Color(0, 0, 0))
			end
			function birt:OnChange()
				lply:SetDString("charcreate_birt", self:GetText())
			end
			list:AddItem(birt)
			list:AddItem(hr)
		end
		
		-- Bodyheight
		if GetGlobalDBool("bool_characters_bodyheight", false) then
			local boheheader = createD("YLabel", nil, ew, YRP.ctr(config.hh), ew * 2 + 3 * YRP.ctr(20), 0)
			boheheader:SetText("LID_bodyheight")
			list:AddItem(boheheader)

			local bohe = createD("DNumberWang", nil, ew, YRP.ctr(config.hh), ew * 2 + 3 * YRP.ctr(20), 0)
			bohe:SetText("")
			bohe:SetFontInternal("Y_18_500")
			function bohe:OnChange()
				lply:SetDString("charcreate_bohe", self:GetText())
			end
			list:AddItem(bohe)
			list:AddItem(hr)
		end

		-- Weight
		if GetGlobalDBool("bool_characters_weight", false) then
			local weigheader = createD("YLabel", nil, ew, YRP.ctr(config.hh), ew * 2 + 3 * YRP.ctr(20), 0)
			weigheader:SetText("LID_weight")
			list:AddItem(weigheader)

			local weig = createD("DNumberWang", nil, ew, YRP.ctr(config.hh), ew * 2 + 3 * YRP.ctr(20), 0)
			weig:SetText("")
			weig:SetFontInternal("Y_18_500")
			function weig:OnChange()
				lply:SetDString("charcreate_weig", self:GetText())
			end
			list:AddItem(weig)
			list:AddItem(hr)
		end

		-- Nationality
		if GetGlobalDBool("bool_characters_nationality", false) then
			local natiheader = createD("YLabel", nil, ew, YRP.ctr(config.hh), ew * 2 + 3 * YRP.ctr(20), 0)
			natiheader:SetText("LID_nationality")
			list:AddItem(natiheader)

			local nati = createD("DComboBox", nil, ew, YRP.ctr(config.hh), ew * 2 + 3 * YRP.ctr(20), 0)
			nati:SetText("")
			nati:SetFontInternal("Y_18_500")
			function nati:OnChange()
				lply:SetDString("charcreate_nati", self:GetText())
			end
			local text_nationalities = string.Explode(",", GetGlobalDString("text_nationalities", ""))
			for i, v in pairs(text_nationalities) do
				nati:AddChoice(v, v, false)
			end

			list:AddItem(nati)
			list:AddItem(hr)
		end

		-- Description
		local descheader = createD("YLabel", nil, ew, YRP.ctr(config.hh), ew * 2 + 3 * YRP.ctr(20), 0)
		descheader:SetText("LID_description")
		list:AddItem(descheader)

		local desc = createD("DTextEntry", nil, ew, YRP.ctr(400), ew * 2 + 3 * YRP.ctr(20), 0)
		desc:SetMultiline(true)
		desc:SetText("")
		function desc:PerformLayout()
			if self.SetUnderlineFont != nil then
				self:SetUnderlineFont("Y_18_500")
			end
			self:SetFontInternal("Y_18_500")

			self:SetFGColor(Color(255, 255, 255))
			self:SetBGColor(Color(0, 0, 0))
		end
		function desc:OnChange()
			lply:SetDString("charcreate_desc", self:GetText())
		end
		list:AddItem(desc)
	end)
	net.Start("yrp_char_getrole")
		net.WriteString(lply:GetDString("charcreate_ruid", 0))
	net.SendToServer()
end