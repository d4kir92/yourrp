--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

function openCharacterCreation()
	if CharacterMenu == nil then
		openMenu()
		
		local win = createD("DFrame", nil, ScW(), ScH(), 0, 0)
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

local curChar = "-1"
local _cur = ""
function openCharacterSelection()
	local fw = 860
	local br = YRP.ctr(20)

	local character = {}
	character.amount = 0

	openMenu()

	local cache = {}

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

		_cs.frame.bg = createD("DHTML", _cs.frame, ScW(), ScH(), PosX(), 0)
		_cs.frame.bg.url = ""

		_cs.frame.bgcf = createD("DPanel", _cs.frame.bg, _cs.frame.bg:GetWide(), _cs.frame.bg:GetTall(), 0, 0)
		function _cs.frame.bgcf:Paint(pw, ph)
			-- Blur Background
			Derma_DrawBackgroundBlur(self, 0)

			-- Header of Menu
			draw.SimpleText(YRP.lang_string("LID_characterselection"), "Y_36_500", pw / 2, YRP.ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			-- Current Character Name
			draw.SimpleText(_cur, "Y_36_500", pw / 2, YRP.ctr(110), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			-- Get Newest Background for the Menu
			local oldurl = _cs.frame.bg.url
			local newurl = GetGlobalDString("text_character_background", "")
			if oldurl != newurl then
				_cs.frame.bg.url = newurl
				_cs.frame.bg:SetHTML(GetHTMLImage(newurl, ScW(), ScH())) -- url?
			end
		end

		-- Language Changer / LanguageChanger
		YRP.DChangeLanguage(_cs.frame, ScrW() - YRP.ctr(100 + 20), YRP.ctr(20), YRP.ctr(100))

		local border = YRP.ctr(50)
		local charactersBackground = createD("DPanel", _cs.frame, YRP.ctr(fw), ScrH() - (2 * border), (ScrW() - ScW()) / 2 + border, border)
		charactersBackground.text = YRP.lang_string("LID_siteisloading")
		function charactersBackground:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, LocalPlayer():InterfaceValue("YFrame", "HB"))

			-- Current and Max Count of Possible Characters
			local acur = character.amount or -1
			local amax = LocalPlayer():GetDInt("int_characters_max", 1)
			local color = Color(255, 255, 255, 255)
			if acur > amax then
				color = Color(255, 100, 100, 255)
			end
			draw.SimpleText(acur .. "/" .. amax, "Y_36_500", pw / 2, ph - YRP.ctr(60), color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			draw.SimpleText(self.text, "Y_36_500", pw / 2, YRP.ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local charplayermodel = createD("DModelPanel", _cs.frame, ScrH() - YRP.ctr(200), ScrH() - YRP.ctr(200), ScrW2() - (ScrH() - YRP.ctr(200)) / 2, 0)
		charplayermodel:SetModel("models/player/skeleton.mdl")
		charplayermodel:SetAnimated(true)
		charplayermodel.Angles = Angle(0, 0, 0)
		charplayermodel:RunAnimation()

		function charplayermodel:DragMousePress()
			self.PressX, self.PressY = gui.MousePos()
			self.Pressed = true
		end
		function charplayermodel:DragMouseRelease() self.Pressed = false end

		function charplayermodel:LayoutEntity(ent)

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

		local characterList = createD("DScrollPanel", charactersBackground, YRP.ctr(fw), ScrH() - (2 * border), 0, 0)

		net.Receive("yrp_get_characters", function(len)
			printGM("gm", "received characterlist")
			local _characters = net.ReadTable()

			DONE_LOADING = DONE_LOADING or true

			if pa(charactersBackground) then
				charactersBackground.text = ""
				if _characters != nil and pa(_characters) then
					character.amount = #_characters or 0
					character.amount = tonumber(character.amount)

					if #_characters < 1 then
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
					for i = 1, #_characters do
						if _characters[i].char != nil then
							cache[i] = {}
							cache[i].tmpChar = createD("YButton", characterList, YRP.ctr(fw) - 2 * br, YRP.ctr(200), br, br + y * YRP.ctr(200) + y * br, br)
							local tmpChar = cache[i].tmpChar
							tmpChar:SetText("")

							_characters[i].char = _characters[i].char or {}
							_characters[i].role = _characters[i].role or {}
							_characters[i].group = _characters[i].group or {}
							_characters[i].faction = _characters[i].faction or {}

							tmpChar.charid = _characters[i].char.uniqueID or "UID INVALID"
							tmpChar.rpname = _characters[i].char.rpname or "RPNAME INVALID"
							tmpChar.level = _characters[i].char.int_level or "-1"
							tmpChar.rolename = _characters[i].role.string_name or "ROLE INVALID"
							tmpChar.factionID = _characters[i].faction.string_name or "FACTION INVALID"
							tmpChar.factionIcon = _characters[i].faction.string_icon or ""
							tmpChar.groupID = _characters[i].group.string_name or "GROUP INVALID"
							tmpChar.map = SQL_STR_OUT(_characters[i].char.map)
							tmpChar.playermodelID = _characters[i].char.playermodelID

							tmpChar.playermodels = string.Explode(",", _characters[i].role.string_playermodels) or {}
							if tmpChar.playermodels == "" or tmpChar.playermodels == " " then
								tmpChar.playermodels = {}
							end

							tmpChar.playermodelsize = _characters[i].role.playermodelsize
							tmpChar.skin = _characters[i].char.skin
							tmpChar.bg0 = _characters[i].char.bg0 or 0
							tmpChar.bg1 = _characters[i].char.bg1 or 0
							tmpChar.bg2 = _characters[i].char.bg2 or 0
							tmpChar.bg3 = _characters[i].char.bg3 or 0
							tmpChar.bg4 = _characters[i].char.bg4 or 0
							tmpChar.bg5 = _characters[i].char.bg5 or 0
							tmpChar.bg6 = _characters[i].char.bg6 or 0
							tmpChar.bg7 = _characters[i].char.bg7 or 0
							tmpChar.bg8 = _characters[i].char.bg8 or 0
							tmpChar.bg9 = _characters[i].char.bg9 or 0
							tmpChar.bg10 = _characters[i].char.bg10 or 0
							tmpChar.bg11 = _characters[i].char.bg11 or 0
							tmpChar.bg12 = _characters[i].char.bg12 or 0
							tmpChar.bg13 = _characters[i].char.bg13 or 0
							tmpChar.bg14 = _characters[i].char.bg14 or 0
							tmpChar.bg15 = _characters[i].char.bg15 or 0
							tmpChar.bg16 = _characters[i].char.bg16 or 0
							tmpChar.bg17 = _characters[i].char.bg17 or 0
							tmpChar.bg18 = _characters[i].char.bg18 or 0
							tmpChar.bg19 = _characters[i].char.bg19 or 0

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
								if curChar == self.charid then
									draw.RoundedBox(0, 0, 0, pw, ph, Color(100, 100, 255, 160))
								end
								if tmpChar:IsHovered() then
									draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 20))
								end

								local x = 30
								if !strEmpty(self.factionIcon) then
									x = ph * 2
								end
								draw.SimpleText(self.rpname, "Y_32_700", YRP.ctr(x), YRP.ctr(35), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
								draw.SimpleText(self.fac, "Y_18_500", YRP.ctr(x), YRP.ctr(85), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
								draw.SimpleText(self.grp, "Y_18_500", YRP.ctr(x), YRP.ctr(125), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
								draw.SimpleText(self.rol, "Y_18_500", YRP.ctr(x), YRP.ctr(165), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

								if i > LocalPlayer():GetDInt("int_characters_max", 1) then
									draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 100, 100, 100))
									draw.SimpleText("X", "Y_72_500", pw / 2, ph / 2, Color(255, 255, 100, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
								end
							end
							function tmpChar:DoClick()
								if i <= LocalPlayer():GetDInt("int_characters_max", 1) then
									curChar = self.charid
									_cur = self.rpname
									if self.playermodels != nil and self.playermodelID != nil then
										local _playermodel = self.playermodels[tonumber(self.playermodelID)] or nil
										if _playermodel != nil and charplayermodel != NULL and pa(charplayermodel) then
											if !strEmpty(_playermodel) then
												charplayermodel:SetModel(_playermodel)
											else
												charplayermodel:SetModel("models / player / skeleton.mdl")
											end
											if charplayermodel.Entity != nil then
												charplayermodel.Entity:SetModelScale(self.playermodelsize or 1)
												charplayermodel.Entity:SetSkin(self.skin)
												for bgx = 0, 19 do
													charplayermodel.Entity:SetBodygroup(bgx, self["bg" .. bgx])
												end
											end
										end
									else
										printGM("note", "Character role has no playermodel!")
									end
								end
							end

							if !strEmpty(tmpChar.factionIcon) then
								local icon = createD("DHTML", tmpChar, tmpChar:GetTall() * 0.8, tmpChar:GetTall() * 0.8, tmpChar:GetTall() * 0.1, tmpChar:GetTall() * 0.1)
								icon:SetHTML(GetHTMLImage(tmpChar.factionIcon, icon:GetWide(), icon:GetTall()))
							end

							if _characters[i].char.uniqueID == _characters.plytab.CurrentCharacter then
								curChar = tmpChar.charid
								tmpChar:DoClick()
							end
							y = y + 1
						end
					end
				end
			end

			LocalPlayer():SetDBool("loadedchars", true)
		end)

		printGM("gm", "ask for characterlist")
		timer.Simple(0.1, function()
			net.Start("yrp_get_characters")
			net.SendToServer()
		end)

		local deleteChar = createD("YButton", characterList, YRP.ctr(80), YRP.ctr(80), br, characterList:GetTall() - YRP.ctr(80) - br)
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
		local charactersCreate = createD("YButton", characterList, YRP.ctr(80), YRP.ctr(80), characterList:GetWide() - YRP.ctr(80) - br, characterList:GetTall() - YRP.ctr(80) - br)
		charactersCreate:SetText("")
		function charactersCreate:Paint(pw, ph)
			if character.amount < LocalPlayer():GetDInt("int_characters_max", 1) then
				hook.Run("YAddPaint", self, pw, ph)
			end
		end
		function charactersCreate:DoClick()
			if character.amount < LocalPlayer():GetDInt("int_characters_max", 1) then
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

		_cs.frame:Show()
		
		LocalPlayer():SetDBool("loadedchars", true)
		_cs.frame:MakePopup()
	end
end

net.Receive("openCharacterMenu", function(len, ply)
	openCharacterSelection()
end)
