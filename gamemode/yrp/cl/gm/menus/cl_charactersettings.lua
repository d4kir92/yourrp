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
		draw.SimpleText(YRP.lang_string("LID_charactercreation"), "Y_36_700", pw / 2, ph / 2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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
	

		-- TOP
		local descheader = createD("YLabel", win, YRP.ctr(config.w - 2 * 20), YRP.ctr(config.hh), YRP.ctr(20), YRP.ctr(20))
		descheader:SetText(rol.string_name)



		-- LEFT
		local wip = createD("YLabel", win, ew, YRP.ctr(config.h - config.hh - 3 * config.br), YRP.ctr(20), YRP.ctr(20 + config.hh + 20))
		wip:SetText("LID_wip")



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
			local name = lply:GetDString("charcreate_name", "")
			if string.len(name) > 32 then
				tab.color = Color(255, 100, 100)
				confirm:SetText("LID_nameistolong")
			elseif string.len(name) <= 0 then
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
			if string.len(name) <= 32 and string.len(name) > 0 then
				local character = {}
				character.roleID = lply:GetDString("charcreate_ruid")
				character.rpname = lply:GetDString("charcreate_name")
				character.rpdescription = lply:GetDString("charcreate_desc")
				character.gender = "male"
				character.playermodelID = lply:GetDString("charcreate_rpmid")
				character.skin = 1
				character.bg = {}
				for i = 0, 7 do
					character.bg[i] = 1
				end

				net.Start("CreateCharacter")
					net.WriteTable(character)
				net.SendToServer()

				CharacterMenu:Remove()
				openCharacterSelection()
			end
		end


		-- RIGHT
		local nameheader = createD("YLabel", win, ew, YRP.ctr(config.hh), ew * 2 + 3 * YRP.ctr(20), YRP.ctr(120))
		nameheader:SetText("LID_name")

		local name = createD("DTextEntry", win, ew, YRP.ctr(config.hh), ew * 2 + 3 * YRP.ctr(20), YRP.ctr(200))
		name:SetText("")
		function name:PerformLayout()
			if self.SetUnderlineFont != nil then
				self:SetUnderlineFont("Y_16_500")
			end
			self:SetFontInternal("Y_16_500")

			self:SetFGColor(Color(255, 255, 255))
			self:SetBGColor(Color(0, 0, 0))
		end
		function name:OnChange()
			lply:SetDString("charcreate_name", name:GetText())
		end

		local descheader = createD("YLabel", win, ew, YRP.ctr(config.hh), ew * 2 + 3 * YRP.ctr(20), YRP.ctr(300))
		descheader:SetText("LID_description")
		
		local desc = createD("DTextEntry", win, ew, YRP.ctr(config.h - 400), ew * 2 + 3 * YRP.ctr(20), YRP.ctr(380))
		desc:SetMultiline(true)
		desc:SetText("")
		function desc:PerformLayout()
			if self.SetUnderlineFont != nil then
				self:SetUnderlineFont("Y_16_500")
			end
			self:SetFontInternal("Y_16_500")

			self:SetFGColor(Color(255, 255, 255))
			self:SetBGColor(Color(0, 0, 0))
		end
		function desc:OnChange()
			lply:SetDString("charcreate_desc", name:GetText())
		end
	end)
	net.Start("yrp_char_getrole")
		net.WriteString(lply:GetDString("charcreate_ruid", 0))
	net.SendToServer()
end