--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local fw = 860
local br = YRP.ctr(20)

function openCharacterCreation()
	if CharacterMenu == nil then
		openMenu()
		
		local win = createD("DFrame", nil, ScrW(), ScrH(), 0, 0)
		win:MakePopup()
		win:Center()
		win:SetTitle("")
		win:ShowCloseButton(true)
		win:SetDraggable(false)
		function win:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0))
		end
		
		win.bg = createD("DHTML", win, win:GetWide(), win:GetTall(), 0, 0)
		win.bg.url = ""

		win.blur = createD("DPanel", win, win:GetWide(), win:GetTall(), 0, 0)
		function win.blur:Paint(pw, ph)
			-- Blur Background
			Derma_DrawBackgroundBlur(self, 0)
			if win.bg.url != GetGlobalDString("text_character_background", "") then
				win.bg.url = GetGlobalDString("text_character_background", "")
				win.bg:SetHTML(GetHTMLImage(GetGlobalDString("text_character_background", ""), win:GetWide(), win:GetTall()))
			end
		end
		function win.blur:OnRemove()
			self:GetParent():Remove()
			CharacterMenu = nil
		end



		CharacterMenu = win.blur


		
		LocalPlayer():SetDBool("cc", true)
		CreateFactionSelectionContent()
	end
	LocalPlayer():SetDBool("loadedchars", true)
end

local _cs = {}

function toggleCharacterSelection()
	if YRPIsNoMenuOpen() then
		openCharacterSelection()
	else
		closeCharacterSelection()
	end
end

function closeCharacterSelection()
	if _cs.frame != nil and LocalPlayer():GetDBool("loadedchars", false) == true then
		closeMenu()
		_cs.frame:Remove()
		_cs.frame = nil
	end
end

local curChar = -1
local _cur = ""
local chars = {}
local loading = false
function LoadCharacters()
	YRP.msg("gm", "received characterlist")

	DONE_LOADING = DONE_LOADING or true

	local cache = {}

	curChar = tonumber(LocalPlayer():CharID())

	if pa(_cs.charactersBackground) then
		_cs.charactersBackground.text = ""
		if wk(chars) then
			_cs.character.amount = 0

			if #chars < 1 then
				if pa(_cs.frame) then
					_cs.frame:Close()
				end
				openCharacterCreation()
				return false
			end
			local y = 0
			for k, v in pairs(cache) do
				if wk(v.tmpChar.shadow) then
					v.tmpChar.shadow:Remove()
				end
				v.tmpChar:Remove()
			end
			for i = 1, #chars do
				if chars[i].char != nil then
					chars[i].char = chars[i].char or {}
					chars[i].role = chars[i].role or {}
					chars[i].group = chars[i].group or {}
					chars[i].faction = chars[i].faction or {}

					chars[i].char.uniqueID = tonumber(chars[i].char.uniqueID)
					chars[i].char.bool_archived = tobool(chars[i].char.bool_archived)
					
					if GetGlobalDBool("bool_characters_removeondeath", false) then
						if chars[i].char.bool_archived then
							continue
						end
					end

					_cs.character.amount = _cs.character.amount + 1

					cache[i] = {}
					cache[i].tmpChar = createD("YButton", nil, YRP.ctr(fw) - 2 * br, YRP.ctr(200), br, br + y * YRP.ctr(200) + y * br, 0)
					local tmpChar = cache[i].tmpChar
					tmpChar:SetText("")

					tmpChar.charid = chars[i].char.uniqueID or "UID INVALID"
					tmpChar.charid = tonumber(tmpChar.charid)
					tmpChar.rpname = chars[i].char.rpname or "RPNAME INVALID"
					tmpChar.level = chars[i].char.int_level or "-1"
					tmpChar.rolename = chars[i].role.string_name or "ROLE INVALID"
					tmpChar.factionID = chars[i].faction.string_name or "FACTION INVALID"
					tmpChar.factionIcon = chars[i].faction.string_icon or ""
					tmpChar.groupID = chars[i].group.string_name or "GROUP INVALID"
					tmpChar.map = SQL_STR_OUT(chars[i].char.map)
					tmpChar.playermodelID = LocalPlayer():GetDInt("pmid", 1)

					tmpChar.playermodels = string.Explode(",", chars[i].role.string_playermodels) or {}
					if tmpChar.playermodels == "" or tmpChar.playermodels == " " then
						tmpChar.playermodels = {}
					end

					tmpChar.playermodelsize = chars[i].role.playermodelsize
					tmpChar.skin = chars[i].char.skin
					tmpChar.bg0 = chars[i].char.bg0 or 0
					tmpChar.bg1 = chars[i].char.bg1 or 0
					tmpChar.bg2 = chars[i].char.bg2 or 0
					tmpChar.bg3 = chars[i].char.bg3 or 0
					tmpChar.bg4 = chars[i].char.bg4 or 0
					tmpChar.bg5 = chars[i].char.bg5 or 0
					tmpChar.bg6 = chars[i].char.bg6 or 0
					tmpChar.bg7 = chars[i].char.bg7 or 0
					tmpChar.bg8 = chars[i].char.bg8 or 0
					tmpChar.bg9 = chars[i].char.bg9 or 0
					tmpChar.bg10 = chars[i].char.bg10 or 0
					tmpChar.bg11 = chars[i].char.bg11 or 0
					tmpChar.bg12 = chars[i].char.bg12 or 0
					tmpChar.bg13 = chars[i].char.bg13 or 0
					tmpChar.bg14 = chars[i].char.bg14 or 0
					tmpChar.bg15 = chars[i].char.bg15 or 0
					tmpChar.bg16 = chars[i].char.bg16 or 0
					tmpChar.bg17 = chars[i].char.bg17 or 0
					tmpChar.bg18 = chars[i].char.bg18 or 0
					tmpChar.bg19 = chars[i].char.bg19 or 0

					tmpChar.grp = tmpChar.groupID
					tmpChar.fac = tmpChar.factionID
					if tmpChar.grp == tmpChar.fac then
						tmpChar.grp = ""
					end
					tmpChar.rol = tmpChar.rolename

					if IsLevelSystemEnabled() then
						tmpChar.rol = YRP.lang_string("LID_level") .. " " .. tmpChar.level .. "    " .. tmpChar.rol
					end

					function tmpChar:Paint(pw, ph)
						--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 1))
						if curChar == -1 then
							curChar = tonumber(LocalPlayer():CharID())
						end
						if curChar == self.charid then
							draw.RoundedBox(0, 0, 0, pw, ph, Color(100, 100, 255, 160))
						end
						if tmpChar:IsHovered() then
							draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 20))
						end

						local x = YRP.ctr(30)
						if !strEmpty(self.factionIcon) then
							x = ph
						end
						draw.SimpleText(self.rpname, "Y_32_500", x, YRP.ctr(35), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
						draw.SimpleText(self.fac, "Y_18_500", x, YRP.ctr(85), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
						draw.SimpleText(self.grp, "Y_18_500", x, YRP.ctr(125), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
						draw.SimpleText(self.rol, "Y_18_500", x, YRP.ctr(165), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

						if i > LocalPlayer():GetDInt("int_characters_max", 1) then
							draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 100, 100, 100))
							draw.SimpleText("X", "Y_72_500", pw / 2, ph / 2, Color(255, 255, 100, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						end
					end
					function tmpChar:DoClick()
						if i <= LocalPlayer():GetDInt("int_characters_max", 1) then
							curChar = tonumber(self.charid)
							_cur = self.rpname
							if self.playermodels != nil and LocalPlayer():GetDInt("pmid", 1) != nil then
								local _playermodel = self.playermodels[LocalPlayer():GetDInt("pmid", 1)] or nil
								if _playermodel != nil and _cs.charplayermodel != NULL and pa(_cs.charplayermodel) then
									if !strEmpty(_playermodel) then
										_cs.charplayermodel:SetModel(_playermodel)
									else
										_cs.charplayermodel:SetModel("models/player/skeleton.mdl")
									end
									if _cs.charplayermodel.Entity != nil then
										_cs.charplayermodel.Entity:SetModelScale(self.playermodelsize or 1)
										_cs.charplayermodel.Entity:SetSkin(self.skin)
										for bgx = 0, 19 do
											_cs.charplayermodel.Entity:SetBodygroup(bgx, self["bg" .. bgx])
										end
									end
								end
							else
								YRP.msg("note", "Character role has no playermodel!")
							end
						end
					end

					if !strEmpty(tmpChar.factionIcon) then
						local icon = createD("DHTML", tmpChar, tmpChar:GetTall() * 0.8, tmpChar:GetTall() * 0.8, tmpChar:GetTall() * 0.1, tmpChar:GetTall() * 0.1)
						icon:SetHTML(GetHTMLImage(tmpChar.factionIcon, icon:GetWide(), icon:GetTall()))
					end

					if chars[i].char.uniqueID == LocalPlayer():CharID() then--chars.plytab.CurrentCharacter then
						curChar = tonumber(LocalPlayer():CharID())
						tmpChar:DoClick()
					end

					_cs.characterList:AddItem(cache[i].tmpChar)

					y = y + 1
				end
			end
		end
	end

	LocalPlayer():SetDBool("loadedchars", true)

	if pa(_cs.frame) then
		_cs.frame:Show()
		_cs.frame:MakePopup()
	end
end
net.Receive("yrp_get_characters", function(len)
	local first = net.ReadBool()
	if first and pa(_cs.characterList) then
		chars = {}
		_cs.characterList:Clear()
	end
	local char = net.ReadTable()
	local last = net.ReadBool()
	table.insert(chars, char)
	if last then
		LoadCharacters()
	end
end)

function openCharacterSelection()
	if !loading then
		loading = true
		timer.Simple(0.3, function()
			loading = false
		end)
	else
		return
	end

	chars = {}

	_cs.character = {}
	_cs.character.amount = 0

	openMenu()

	if !pa(_cs.frame) then
		_cs.frame = createD("DFrame", nil, ScrW(), ScrH(), 0, 0)
		_cs.frame:Hide()
		_cs.frame:SetTitle("")
		_cs.frame:ShowCloseButton(false)
		_cs.frame:SetDraggable(false)
		_cs.frame:Center()
		function _cs.frame:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 255))
		end
		function _cs.frame:OnClose()
			closeMenu()
		end
		function _cs.frame:OnRemove()
			closeMenu()
		end

		_cs.frame.bg = createD("DHTML", _cs.frame, ScrW(), ScrH(), 0, 0)
		_cs.frame.bg.url = ""

		_cs.frame.bgcf = createD("DPanel", _cs.frame.bg, _cs.frame.bg:GetWide(), _cs.frame.bg:GetTall(), 0, 0)
		function _cs.frame.bgcf:Paint(pw, ph)
			-- Blur Background
			Derma_DrawBackgroundBlur(self, 0)

			-- Header of Menu
			draw.SimpleText(YRP.lang_string("LID_characterselection"), "Y_18_500", pw / 2, YRP.ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			-- Current Character Name
			draw.SimpleText(_cur, "Y_40_500", pw / 2, YRP.ctr(110), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			-- Get Newest Background for the Menu
			local oldurl = _cs.frame.bg.url
			local newurl = GetGlobalDString("text_character_background", "")
			if oldurl != newurl then
				_cs.frame.bg.url = newurl
				_cs.frame.bg:SetHTML(GetHTMLImage(newurl, ScrW(), ScrH())) -- url?
			end
		end

		-- Language Changer / LanguageChanger
		YRP.DChangeLanguage(_cs.frame, ScrW() - YRP.ctr(100 + 20), YRP.ctr(20), YRP.ctr(100))

		local border = YRP.ctr(50)
		_cs.charactersBackground = createD("DPanel", _cs.frame, YRP.ctr(fw), ScrH() - (2 * border), (ScrW() - ScW()) / 2 + border, border)
		_cs.charactersBackground.text = YRP.lang_string("LID_siteisloading")
		function _cs.charactersBackground:Paint(pw, ph)
			draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, LocalPlayer():InterfaceValue("YFrame", "NC"))

			-- Current and Max Count of Possible Characters
			local acur = _cs.character.amount or -1
			local amax = LocalPlayer():GetDInt("int_characters_max", 1)
			local color = Color(255, 255, 255, 255)
			if acur > amax then
				color = Color(255, 100, 100, 255)
			end
			draw.SimpleText(acur .. "/" .. amax, "Y_36_500", pw / 2, ph - YRP.ctr(60), color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			draw.SimpleText(self.text, "Y_36_500", pw / 2, YRP.ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		_cs.charplayermodel = createD("DModelPanel", _cs.frame, ScrH() - YRP.ctr(200), ScrH() - YRP.ctr(200), ScrW2() - (ScrH() - YRP.ctr(200)) / 2, 0)
		_cs.charplayermodel:SetModel("models/player/skeleton.mdl")
		_cs.charplayermodel:SetAnimated(true)
		_cs.charplayermodel.Angles = Angle(0, 0, 0)
		_cs.charplayermodel:RunAnimation()

		function _cs.charplayermodel:DragMousePress()
			self.PressX, self.PressY = gui.MousePos()
			self.Pressed = true
		end
		function _cs.charplayermodel:DragMouseRelease() self.Pressed = false end

		function _cs.charplayermodel:LayoutEntity(ent)

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

		_cs.characterList = createD("DPanelList", _cs.charactersBackground, YRP.ctr(fw) - 2 * br, ScrH() - (2 * border) - br - YRP.ctr(120), br, br)
		_cs.characterList:EnableVerticalScrollbar()
		_cs.characterList:SetSpacing(YRP.ctr(20))
		function _cs.characterList:Paint(pw, ph)
			--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 0, 0, 255))
		end
		local sbar = _cs.characterList.VBar
		function sbar:Paint(w, h)
			local lply = LocalPlayer()
			draw.RoundedBox(0, 0, 0, w, h, lply:InterfaceValue("YFrame", "NC"))
		end
		function sbar.btnUp:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
		end
		function sbar.btnDown:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
		end
		function sbar.btnGrip:Paint(w, h)
			local lply = LocalPlayer()
			draw.RoundedBox(w / 2, 0, 0, w, h, lply:InterfaceValue("YFrame", "HI"))
		end

		timer.Simple(0.1, function()
			YRP.msg("gm", "ask for characterlist")

			net.Start("yrp_get_characters")
			net.SendToServer()
		end)

		local deleteChar = createD("YButton", _cs.charactersBackground, YRP.ctr(80), YRP.ctr(80), br, _cs.characterList:GetTall() + YRP.ctr(40))
		deleteChar:SetText("")
		function deleteChar:Paint(pw, ph)
			hook.Run("YRemovePaint", self, pw, ph)
		end
		function deleteChar:DoClick()
			local _window = createVGUI("DFrame", nil, 430, 50 + 10 + 50 + 10, 0, 0)
			_window:Center()
			_window:SetTitle(YRP.lang_string("LID_areyousure"))

			local _yesButton = createVGUI("DButton", _window, 200, 50, 10, 60)
			_yesButton:SetText(YRP.lang_string("LID_yes"))
			function _yesButton:DoClick()

				net.Start("DeleteCharacter")
					net.WriteString(curChar)
				net.SendToServer()

				_window:Close()
			end

			local _noButton = createVGUI("DButton", _window, 200, 50, 10 + 200 + 10, 60)
			_noButton:SetText(YRP.lang_string("LID_no"))
			function _noButton:DoClick()
				_window:Close()
			end

			_window:MakePopup()
		end

		local button = {}
		local charactersCreate = createD("YButton", _cs.charactersBackground, YRP.ctr(80), YRP.ctr(80), _cs.characterList:GetWide() - YRP.ctr(40) - br, _cs.characterList:GetTall() + YRP.ctr(40))
		charactersCreate:SetText("")
		function charactersCreate:Paint(pw, ph)
			if _cs.character.amount < LocalPlayer():GetDInt("int_characters_max", 1) then
				hook.Run("YAddPaint", self, pw, ph)
			end
		end
		function charactersCreate:DoClick()
			if _cs.character.amount < LocalPlayer():GetDInt("int_characters_max", 1) then
				if pa(_cs.frame) then
					_cs.frame:Close()
				end
				openCharacterCreation()
			end
		end

		button.w = YRP.ctr(600)
		button.h = YRP.ctr(100)
		button.x = ScrW2() - button.w / 2
		button.y = ScrH() - button.h - border
		local charactersEnter = createD("YButton", _cs.frame, button.w, button.h, button.x, button.y)
		function charactersEnter:Paint(pw, ph)
			local tab = {}
			tab.text = math.Round(LocalPlayer():GetDInt("int_deathtimestamp_min", 0) - CurTime(), 0)
			if LocalPlayer():GetDInt("int_deathtimestamp_min", 0) <= CurTime() then
				tab.text = YRP.lang_string("LID_enterworld") -- .. " (" .. _cur .. ")"
			end
			if LocalPlayer() != nil and LocalPlayer():Alive() then
				tab.text = YRP.lang_string("LID_suicide") .. " (" .. LocalPlayer():RPName() .. ")"
				tab.color = Color(255, 100, 100, 255)
			end

			local hasdesign = hook.Run("YButtonPaint", self, pw, ph, tab)
			if !hasdesign then
				draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255))
				draw.SimpleTextOutlined(tab.text, "Y_24_500", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
			end
		end

		charactersEnter:SetText("")
		function charactersEnter:DoClick()
			if LocalPlayer() != nil and curChar != "-1" and LocalPlayer():GetDInt("int_deathtimestamp_min", 0) <= CurTime() then
				if LocalPlayer():Alive() then
					net.Start("LogOut")
					net.SendToServer()
				elseif curChar != nil then
					net.Start("EnterWorld")
						net.WriteString(curChar)
					net.SendToServer()
					if pa(_cs.frame) then
						_cs.frame:Close()
					end
				end
			end
		end
	end
end

net.Receive("openCharacterMenu", function(len, ply)
	timer.Simple(1, function()
		openCharacterSelection()
	end)
end)

net.Receive("OpenCharacterCreation", function(len, ply)
	timer.Simple(1, function()
		openCharacterCreation()
	end)
end)
