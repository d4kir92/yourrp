--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
surface.CreateFont(
	"Saira_60",
	{
		font = "Saira",
		extended = true,
		size = 60,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false
	}
)

surface.CreateFont(
	"Saira_100",
	{
		font = "Saira SemiBold",
		extended = true,
		size = 100,
		weight = 1000,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false
	}
)

local yrp_logo = Material("yrp/yrp_icon")
function YRPGetCharBGNotFound()
	return YRPGetKeybindName("menu_settings") .. " >> " .. YRP:trans("LID_server") .. " >> " .. YRP:trans("LID_general") .. " >> " .. YRP:trans("LID_character_background") .. " (enter a weblink to an image)"
end

local isEventChar = false
local fw = 860
local br = YRP:ctr(20)
local trashicon = ""
local DefaultCharBR = 0
local DefaultCharW = 0
local DefaultCharH = 0
function YRPUpdateCharValues()
	DefaultCharBR = ScrW() * 0.04
	DefaultCharW = ScrW() * 0.24 * 2 + DefaultCharBR
	DefaultCharH = ScrH() * 0.8
	DefaultCharPanelW = DefaultCharW / 2 - DefaultCharBR / 2
end

function YRPOpenCharacterCreation(from)
	if IsVoidCharEnabled() or not GetGlobalYRPBool("bool_character_system", true) then return end
	if CharacterMenu == nil then
		YRPOpenMenu()
		local win = YRPCreateD("DFrame", nil, ScrW(), ScrH(), 0, 0)
		win:MakePopup()
		win:Center()
		win:SetTitle("")
		win:ShowCloseButton(true)
		win:SetDraggable(false)
		function win:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(40, 40, 40)) -- Dark Background - Character Creation
		end

		win.bg = YRPCreateD("DHTML", win, win:GetWide(), win:GetTall(), 0, 0)
		win.bg.url = ""
		win.blur = YRPCreateD("DPanel", win, win:GetWide(), win:GetTall(), 0, 0)
		function win.blur:Paint(pw, ph)
			-- Blur Background
			Derma_DrawBackgroundBlur(self, 0)
			if win.bg.url ~= GetGlobalYRPString("text_character_background", "") then
				win.bg.url = GetGlobalYRPString("text_character_background", "")
				win.bg:SetHTML(YRPGetHTMLImage(GetGlobalYRPString("text_character_background", ""), win:GetWide(), win:GetTall()))
			end
		end

		function win.blur:OnRemove()
			self:GetParent():Remove()
			CharacterMenu = nil
		end

		CharacterMenu = win.blur
		LocalPlayer().cc = true
		CreateFactionSelectionContent()
	end
end

local CharMenu = {}
function YRPToggleCharacterSelection()
	if YRPIsNoMenuOpen() then
		YRPOpenCharacterSelection()
	elseif LocalPlayer():Alive() then
		YRPCloseCharacterSelection()
	end
end

function YRPCloseCharacterSelection()
	if CharMenu.frame ~= nil and LocalPlayer():Alive() then
		YRPCloseMenu()
		CharMenu.frame:Remove()
		CharMenu.frame = nil
	end
end

local curChar = -1
local validchar = false
local _cur = ""
local chars = {}
local loading = false
function YRPLoadCharacters()
	--YRP:msg( "gm", "received characterlist" )
	if not IsVoidCharEnabled() and GetGlobalYRPBool("bool_character_system", true) then
		trashicon = YRP:GetDesignIcon("64_trash")
		local cache = {}
		if LocalPlayer().CharID then
			curChar = tonumber(LocalPlayer():CharID())
		else
			curChar = -1
		end

		if YRPPanelAlive(CharMenu.charactersBackground, "CharMenu.charactersBackground") then
			CharMenu.charactersBackground.text = ""
			if IsNotNilAndNotFalse(chars) then
				CharMenu.character.amount = 0
				CharMenu.character.amountevent = 0
				if #chars < 1 then
					if YRPPanelAlive(CharMenu.frame, "CharMenu.frame") then
						CharMenu.frame:Close()
					end

					SetGlobalYRPBool("create_eventchar", false)
					YRPOpenCharacterCreation("#char < 1, not event char")

					return false
				end

				local y = 0
				for k, v in pairs(cache) do
					if IsNotNilAndNotFalse(v.tmpChar.shadow) then
						v.tmpChar.shadow:Remove()
					end

					v.tmpChar:Remove()
				end

				local cni = 0
				local cei = 0
				for i = 1, #chars do
					if chars[i].char ~= nil then
						chars[i].char = chars[i].char or {}
						chars[i].role = chars[i].role or {}
						chars[i].group = chars[i].group or {}
						chars[i].faction = chars[i].faction or {}
						chars[i].char.uniqueID = tonumber(chars[i].char.uniqueID)
						chars[i].char.bool_archived = tobool(chars[i].char.bool_archived)
						chars[i].char.bool_eventchar = tobool(chars[i].char.bool_eventchar)
						if GetGlobalYRPBool("bool_characters_removeondeath", false) and chars[i].char.bool_archived then continue end
						if chars[i].char.bool_eventchar then
							CharMenu.character.amountevent = CharMenu.character.amountevent + 1
							cei = cei + 1
						else
							CharMenu.character.amount = CharMenu.character.amount + 1
							cni = cni + 1
						end

						cache[i] = {}
						local psw = YRP:ctr(fw) - 2 * br
						local psh = YRP:ctr(200)
						local px = 0
						local py = 0
						if YRP_CharDesign == "horizontalnew" then
							psw = YRP:ctr(350 * 2)
							psh = YRP:ctr(600 * 2)
							px = 0
							py = 0
						elseif YRP_CharDesign == "default" then
							YRPUpdateCharValues()
							psw = DefaultCharW
							psh = DefaultCharH
							px = 0
							py = 0
						end

						cache[i].tmpChar = YRPCreateD("YButton", nil, psw, psh, px, py)
						local tmpChar = cache[i].tmpChar
						tmpChar:SetText("")
						tmpChar.charid = chars[i].char.uniqueID or "UID INVALID"
						tmpChar.charid = tonumber(tmpChar.charid)
						tmpChar.rpname = chars[i].char.rpname or "RPNAME INVALID"
						tmpChar.level = chars[i].char.int_level or "-1"
						tmpChar.rolename = chars[i].role.string_name or "ROLE INVALID"
						tmpChar.health = chars[i].role.int_hpmax or 0
						tmpChar.armor = chars[i].role.int_armax or 0
						tmpChar.factionID = chars[i].faction.string_name or "FACTION INVALID"
						tmpChar.factionIcon = chars[i].faction.string_icon or ""
						tmpChar.groupname = chars[i].group.string_name or "GROUP INVALID"
						tmpChar.map = chars[i].char.map
						tmpChar.playermodelID = chars[i].char.playermodelID or 1
						tmpChar.playermodelID = tonumber(tmpChar.playermodelID)
						tmpChar.bool_eventchar = chars[i].char.bool_eventchar
						tmpChar.playermodels = {}
						if not strEmpty(chars[i].role.string_playermodels) then
							tmpChar.playermodels = string.Explode(",", chars[i].role.string_playermodels)
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
						tmpChar.grp = tmpChar.groupname
						tmpChar.fac = tmpChar.factionID
						if tmpChar.grp == tmpChar.fac then
							tmpChar.grp = ""
						end

						tmpChar.rol = tmpChar.rolename
						if IsLevelSystemEnabled() then
							tmpChar.rol = YRP:trans("LID_level") .. " " .. tmpChar.level .. "    " .. tmpChar.rol
						end

						tmpChar.cni = cni
						if YRP_CharDesign == "horizontalnew" then
							function tmpChar:YRPIsHovered()
								return tmpChar.btnishovered or tmpChar.mdlishovered or self:IsHovered()
							end

							function tmpChar:Paint(pw, ph)
								draw.RoundedBox(0, 0, 0, pw, ph, Color(51, 51, 51, 200))
								draw.SimpleText(self.rpname, "Saira_60", pw / 2, YRP:ctr(100), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
								if self.cni > LocalPlayer():GetYRPInt("int_characters_max", 1) then
									draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 100, 100, 10))
									draw.SimpleText("X", "Y_72_500", pw / 2, ph / 2, Color(255, 255, 100, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
								end

								if tmpChar:YRPIsHovered() then
									draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 10))
								end
							end

							local mdlsize = tmpChar:GetTall() - YRP:ctr(100)
							tmpChar.charplayermodel = YRPCreateD("DModelPanel", tmpChar, mdlsize, mdlsize, tmpChar:GetWide() / 2 - mdlsize / 2, YRP:ctr(100))
							tmpChar.charplayermodel:SetModel("models/player/skeleton.mdl")
							tmpChar.charplayermodel:SetAnimated(true)
							tmpChar.charplayermodel.Angles = Angle(0, 0, 0)
							function tmpChar.charplayermodel:DragMousePress()
								self.PressX, self.PressY = gui.MousePos()
								self.Pressed = true
							end

							function tmpChar.charplayermodel:DragMouseRelease()
								self.Pressed = false
							end

							function tmpChar.charplayermodel:LayoutEntity(ent)
								local _playermodel = tmpChar.playermodels[tmpChar.playermodelID] or nil
								if _playermodel == nil or strEmpty(_playermodel) then
									_playermodel = "models/player/skeleton.mdl"
								end

								if self.pm ~= _playermodel then
									self.pm = _playermodel
									tmpChar.charplayermodel:SetModel(self.pm)
								end

								if self.bAnimated and self.RunAnimation then
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

							function tmpChar.charplayermodel:PaintOver(pw, ph)
								if self:IsHovered() then
									tmpChar.mdlishovered = true
								else
									tmpChar.mdlishovered = false
								end
							end

							local button = {}
							button.w = YRP:ctr(200 * 2)
							button.h = YRP:ctr(36 * 2)
							button.x = tmpChar:GetWide() / 2 - button.w / 2
							button.y = tmpChar:GetTall() / 2 - button.h / 2
							local charactersEnter = YRPCreateD("YButton", tmpChar, button.w, button.h, button.x, button.y)
							function charactersEnter:Paint(pw, ph)
								if self:IsHovered() then
									tmpChar.btnishovered = true
								else
									tmpChar.btnishovered = false
								end

								if tmpChar.bool_eventchar then
									draw.SimpleText("EVENT CHARACTER", "Y_24_500", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
								else
									if IsValid(LocalPlayer()) then
										local t = {}
										t.text = math.Round(LocalPlayer():GetYRPInt("int_deathtimestamp_min", 0) - CurTime(), 0)
										if LocalPlayer():GetYRPInt("int_deathtimestamp_min", 0) <= CurTime() then
											t.text = YRP:trans("LID_play") -- .. " ( " .. _cur .. " )"
										end

										if (tmpChar:YRPIsHovered() or self:IsHovered()) and not tmpChar.charplayermodel.Pressed then
											if LocalPlayer():Alive() then
												t.text = YRP:trans("LID_close") .. " ( " .. LocalPlayer():RPName() .. " )"
												t.color = Color(255, 100, 100, 255)
												self:SetText(t.text)
												hook.Run("YButtonRPaint", self, pw, ph)
											else
												self:SetText(t.text)
												hook.Run("YButtonAPaint", self, pw, ph)
											end
										end
									end
								end
							end

							charactersEnter:SetText("")
							function charactersEnter:DoClick()
								if not tmpChar.bool_eventchar and LocalPlayer() ~= nil and tonumber(tmpChar.charid) ~= "-1" and LocalPlayer():GetYRPInt("int_deathtimestamp_min", 0) <= CurTime() then
									if LocalPlayer():Alive() then
										YRPCloseCharacterSelection()
									elseif tonumber(tmpChar.charid) ~= nil then
										net.Start("nws_yrp_EnterWorld")
										net.WriteString(tmpChar.charid)
										net.SendToServer()
										if YRPPanelAlive(CharMenu.frame, "CharMenu.frame 2") then
											CharMenu.frame:Close()
										end
									end
								end
							end

							local deletesize = YRP:ctr(40)
							local deletebr = YRP:ctr(20)
							local deleteChar = YRPCreateD("YButton", tmpChar, deletesize, deletesize, tmpChar:GetWide() - deletesize - deletebr, deletebr)
							deleteChar:SetText("")
							function deleteChar:Paint(pw, ph)
								--hook.Run( "YRemovePaint", self, pw, ph)
								local color = Color(160, 160, 160, 255)
								if self:IsHovered() then
									color = Color(255, 255, 255, 255)
								end

								if trashicon then
									surface.SetMaterial(trashicon)
									surface.SetDrawColor(color)
									surface.DrawTexturedRect(0, 0, pw, ph)
								end
							end

							function deleteChar:DoClick()
								local _window = createVGUI("DFrame", nil, 430, 50 + 10 + 50 + 10, 0, 0)
								_window:Center()
								_window:SetTitle(YRP:trans("LID_areyousure"))
								local _yesButton = createVGUI("DButton", _window, 200, 50, 10, 60)
								_yesButton:SetText(YRP:trans("LID_yes"))
								function _yesButton:DoClick()
									if IsNotNilAndNotFalse(tmpChar.charid) then
										net.Start("nws_yrp_delete_own_character")
										net.WriteString(tmpChar.charid)
										net.SendToServer()
									else
										notification.AddLegacy("CHAR ID is invalid", NOTIFY_GENERIC, 5)
									end

									_window:Close()
								end

								local _noButton = createVGUI("DButton", _window, 200, 50, 10 + 200 + 10, 60)
								_noButton:SetText(YRP:trans("LID_no"))
								function _noButton:DoClick()
									_window:Close()
								end

								_window:MakePopup()
							end
						elseif YRP_CharDesign == "default" then
							function tmpChar:YRPIsHovered()
								return tmpChar.btnishovered or tmpChar.mdlishovered or self:IsHovered()
							end

							local posx = ScrW() * 0.01
							local tabw = ScrW() * 0.075
							local tabh = ScrH() * 0.03
							tmpChar.id = i
							function tmpChar:Paint(pw, ph)
								draw.RoundedBox(50, 4, 4, pw / 2 - DefaultCharBR / 2, ph, Color(0, 0, 0, 40))
								draw.RoundedBox(50, 0, 0, pw / 2 - DefaultCharBR / 2, ph, YRPCPP())
								draw.RoundedBox(50, pw / 2 + DefaultCharBR / 2 + 4, 4, pw / 2 - DefaultCharBR / 2, ph, Color(0, 0, 0, 40))
								draw.RoundedBox(50, pw / 2 + DefaultCharBR / 2, 0, pw / 2 - DefaultCharBR / 2, ph, YRPCPP())
								local py2 = ScrH() * 0.03
								draw.SimpleText(self.rpname, "Y_52_700", DefaultCharPanelW / 2, py2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
								if IsLevelSystemEnabled() then
									py2 = py2 + tabh * 2
									draw.SimpleText(YRP:trans("LID_level") .. ": ", "Y_30_500", posx, py2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
									draw.SimpleText(self.level, "Y_30_500", posx + tabw, py2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
									local barbr = ScrW() * 0.04
									local barw = DefaultCharPanelW - posx - tabw - posx - barbr
									local barh = math.Round(ScrH() * 0.014)
									barh = barh - barh % 3
									local barr = barh / 2
									local barx = posx + tabw + barbr
									local bary = py2 - barr
									if IsNotNilAndNotFalse(chars[self.id]) then
										local cur = tonumber(chars[self.id].char.int_xp)
										local max = LocalPlayer():CalculateMaxXP(tonumber(chars[self.id].char.int_level))
										if cur > max then
											cur = max
										end

										draw.RoundedBox(barr, barx, bary, barw, barh, YRPCPD())
										draw.RoundedBox(barr, barx, bary, barw * cur / max, barh, Color(53, 152, 219, 255))
									end
								end

								py2 = py2 + tabh * 2
								draw.SimpleText(YRP:trans("LID_role") .. ": ", "Y_30_500", posx, py2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
								draw.SimpleText(self.rolename, "Y_30_500", posx + tabw, py2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
								py2 = py2 + tabh
								draw.SimpleText(YRP:trans("LID_group") .. ": ", "Y_30_500", posx, py2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
								draw.SimpleText(self.groupname, "Y_30_500", posx + tabw, py2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
								py2 = py2 + tabh * 2
								draw.SimpleText(YRP:trans("LID_health") .. ": ", "Y_30_500", posx, py2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
								draw.SimpleText(self.health, "Y_30_500", posx + tabw, py2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
								py2 = py2 + tabh
								draw.SimpleText(YRP:trans("LID_armor") .. ": ", "Y_30_500", posx, py2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
								draw.SimpleText(self.armor, "Y_30_500", posx + tabw, py2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
								if self.cni > LocalPlayer():GetYRPInt("int_characters_max", 1) then
									draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 100, 100, 10))
									draw.SimpleText("X", "Y_72_500", pw / 2, ph / 2, Color(255, 255, 100, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
								end

								if tmpChar:YRPIsHovered() then
									draw.RoundedBox(50, 0, 0, pw / 2 - DefaultCharBR / 2, ph, Color(255, 255, 255, 10))
									draw.RoundedBox(50, pw / 2 + DefaultCharBR / 2, 0, pw / 2 - DefaultCharBR / 2, ph, Color(255, 255, 255, 10))
								end
							end

							function tmpChar:DoClick()
								curChar = tonumber(self.charid)
							end

							tmpChar.charplayermodel = YRPCreateD("DModelPanel", tmpChar, DefaultCharH, DefaultCharH, DefaultCharW - (DefaultCharW / 2 - DefaultCharBR / 2) / 2 - DefaultCharH / 2, 0)
							tmpChar.charplayermodel:SetModel("models/player/skeleton.mdl")
							tmpChar.charplayermodel:SetAnimated(true)
							tmpChar.charplayermodel.Angles = Angle(0, 0, 0)
							function tmpChar.charplayermodel:DragMousePress()
								self.PressX, self.PressY = gui.MousePos()
								self.Pressed = true
							end

							function tmpChar.charplayermodel:DragMouseRelease()
								self.Pressed = false
							end

							function tmpChar.charplayermodel:LayoutEntity(ent)
								local _playermodel = tmpChar.playermodels[tmpChar.playermodelID] or nil
								if _playermodel == nil or strEmpty(_playermodel) then
									_playermodel = "models/player/skeleton.mdl"
								end

								if self.pm ~= _playermodel then
									self.pm = _playermodel
									tmpChar.charplayermodel:SetModel(self.pm)
								end

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

							function tmpChar.charplayermodel:PaintOver(pw, ph)
								if self:IsHovered() then
									tmpChar.mdlishovered = true
								else
									tmpChar.mdlishovered = false
								end
							end

							local deletesize = YRP:ctr(40)
							local deletebr = YRP:ctr(40)
							local deleteChar = YRPCreateD("YButton", tmpChar, deletesize, deletesize, tmpChar:GetWide() - deletesize - deletebr, deletebr)
							deleteChar:SetText("")
							function deleteChar:Paint(pw, ph)
								--hook.Run( "YRemovePaint", self, pw, ph)
								local color = Color(160, 160, 160, 255)
								if self:IsHovered() then
									color = Color(255, 255, 255, 255)
								end

								if trashicon then
									surface.SetMaterial(trashicon)
									surface.SetDrawColor(color)
									surface.DrawTexturedRect(0, 0, pw, ph)
								end
							end

							function deleteChar:DoClick()
								local _window = createVGUI("DFrame", nil, 430, 50 + 10 + 50 + 10, 0, 0)
								_window:Center()
								_window:SetTitle(YRP:trans("LID_areyousure"))
								local _yesButton = createVGUI("DButton", _window, 200, 50, 10, 60)
								_yesButton:SetText(YRP:trans("LID_yes"))
								function _yesButton:DoClick()
									if IsNotNilAndNotFalse(tmpChar.charid) then
										net.Start("nws_yrp_delete_own_character")
										net.WriteString(tmpChar.charid)
										net.SendToServer()
									else
										notification.AddLegacy("CHAR ID is invalid", NOTIFY_GENERIC, 5)
									end

									if _window then
										_window:Close()
									end
								end

								local _noButton = createVGUI("DButton", _window, 200, 50, 10 + 200 + 10, 60)
								_noButton:SetText(YRP:trans("LID_no"))
								function _noButton:DoClick()
									_window:Close()
								end

								_window:MakePopup()
							end
						else
							if YRP_CharDesign ~= "horizontalnew" then
								tmpChar.mdl = YRPCreateD("DModelPanel", tmpChar, tmpChar:GetTall(), tmpChar:GetTall(), 0, 0)
								local pm = tmpChar.playermodels[tmpChar.playermodelID]
								if strEmpty(pm) then
									pm = "models/player/skeleton.mdl"
								end

								tmpChar.mdl:SetModel(pm)
								function tmpChar.mdl:LayoutEntity(ent)
									ent:SetSequence(ent:LookupSequence("menu_gman"))
									tmpChar.mdl:RunAnimation()

									return
								end

								if tmpChar.mdl.Entity then
									local head = tmpChar.mdl.Entity:LookupBone("ValveBiped.Bip01_Head1")
									if head then
										local eyepos = tmpChar.mdl.Entity:GetBonePosition(head)
										if eyepos then
											eyepos:Add(Vector(0, 0, 3)) -- Move up slightly
											tmpChar.mdl:SetLookAt(eyepos)
											tmpChar.mdl:SetCamPos(eyepos - Vector(-20, 0, 0)) -- Move cam in front of eyes
											tmpChar.mdl.Entity:SetEyeTarget(eyepos - Vector(-20, 0, 0))
										end
									end
								end

								function tmpChar:Paint(pw, ph)
									if curChar == -1 then
										curChar = tonumber(LocalPlayer():CharID())
									end

									if tmpChar.bool_eventchar then
										if curChar == self.charid then
											draw.RoundedBox(0, 0, 0, pw, ph, Color(100, 100, 255, 160))
										end

										if tmpChar:IsHovered() then
											draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 20))
										end

										local x = ph + YRP:ctr(30)
										draw.SimpleText(YRP:trans("LID_event") .. ": " .. self.rpname, "Y_32_500", x, YRP:ctr(35), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
										draw.SimpleText(self.fac, "Y_18_500", x, YRP:ctr(85), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
										draw.SimpleText(self.grp, "Y_18_500", x, YRP:ctr(125), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
										draw.SimpleText(self.rol, "Y_18_500", x, YRP:ctr(165), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
										if cei > LocalPlayer():GetYRPInt("int_charactersevent_max", 1) then
											draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 100, 100, 10))
											draw.SimpleText("X", "Y_72_500", pw / 2, ph / 2, Color(255, 255, 100, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
										end
									else
										if curChar == self.charid then
											draw.RoundedBox(0, 0, 0, pw, ph, Color(100, 100, 255, 160))
										end

										if tmpChar:IsHovered() then
											draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 20))
										end

										local x = ph + YRP:ctr(30)
										draw.SimpleText(self.rpname, "Y_32_500", x, YRP:ctr(35), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
										draw.SimpleText(self.fac, "Y_18_500", x, YRP:ctr(85), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
										draw.SimpleText(self.grp, "Y_18_500", x, YRP:ctr(125), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
										draw.SimpleText(self.rol, "Y_18_500", x, YRP:ctr(165), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
										if self.cni > LocalPlayer():GetYRPInt("int_characters_max", 1) then
											draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 100, 100, 10))
											draw.SimpleText("X", "Y_72_500", pw / 2, ph / 2, Color(255, 255, 100, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
										end
									end
								end

								function tmpChar:DoClick()
									isEventChar = self.bool_eventchar
									if self.cni <= LocalPlayer():GetYRPInt("int_characters_max", 1) then
										curChar = tonumber(self.charid)
										_cur = self.rpname
										if self.playermodels ~= nil and self.playermodelID ~= nil then
											local _playermodel = self.playermodels[self.playermodelID] or nil
											if _playermodel ~= nil and CharMenu.charplayermodel ~= NULL and YRPPanelAlive(CharMenu.charplayermodel, "CharMenu.charplayermodel") then
												if not strEmpty(_playermodel) then
													CharMenu.charplayermodel:SetModel(_playermodel)
												else
													CharMenu.charplayermodel:SetModel("models/player/skeleton.mdl")
												end

												if CharMenu.charplayermodel.Entity ~= nil then
													CharMenu.charplayermodel.Entity:SetModelScale(self.playermodelsize or 1)
													CharMenu.charplayermodel.Entity:SetSkin(self.skin)
													for bgx = 0, 19 do
														CharMenu.charplayermodel.Entity:SetBodygroup(bgx, self["bg" .. bgx])
													end
												end
											end
										else
											YRP:msg("note", "Character role has no playermodel!")
										end
									end
								end

								if not strEmpty(tmpChar.factionIcon) and tmpChar.factionIcon ~= "http://www.famfamfam.com/lab/icons/silk/icons/group.png" and tmpChar.icon == nil then
									tmpChar.icon = YRPCreateD("DHTML", tmpChar, tmpChar:GetTall() * 0.8, tmpChar:GetTall() * 0.8, tmpChar:GetWide() - tmpChar:GetTall() * 0.9, tmpChar:GetTall() * 0.1)
									tmpChar.icon:SetHTML(YRPGetHTMLImage(tmpChar.factionIcon, tmpChar.icon:GetWide(), tmpChar.icon:GetTall()))
								end
							end
						end

						if chars[i].char.uniqueID == LocalPlayer():CharID() then
							curChar = tonumber(LocalPlayer():CharID())
							tmpChar:DoClick()
						end

						if CharMenu.characterList.AddItem then
							CharMenu.characterList:AddItem(cache[i].tmpChar)
						else
							CharMenu.characterList:AddPanel(cache[i].tmpChar)
						end

						y = y + 1
					end

					i = i + 1
				end

				if YRP_CharDesign == "horizontalnew" then
					psw = YRP:ctr(350 * 2)
					psh = YRP:ctr(600 * 2)
					local px = 0
					local py = 0
					if CharMenu.character.amount < LocalPlayer():GetYRPInt("int_characters_max", 1) then
						local addChar = YRPCreateD("YButton", nil, psw, psh, px, py)
						addChar:SetText("")
						function addChar:Paint(pw, ph)
							if CharMenu.character.amount < LocalPlayer():GetYRPInt("int_characters_max", 1) then
								draw.RoundedBox(0, 0, 0, pw, ph, Color(51, 51, 51, 200))
								local sw = pw - 2 * YRP:ctr(180)
								local breite = YRP:ctr(50)
								if YRP:GetDesignIcon("add") ~= nil then
									draw.RoundedBox(breite / 2, pw / 2 - breite / 2, ph / 2 - sw / 2, breite, sw, Color(102, 102, 102, 255))
									draw.RoundedBox(breite / 2, pw / 2 - sw / 2, ph / 2 - breite / 2, sw, breite, Color(102, 102, 102, 255))
								end
							end
						end

						function addChar:DoClick()
							isEventChar = self.bool_eventchar
							if CharMenu.character.amount < LocalPlayer():GetYRPInt("int_characters_max", 1) then
								if YRPPanelAlive(CharMenu.frame, "CharMenu.frame 1") then
									CharMenu.frame:Close()
								end

								SetGlobalYRPBool("create_eventchar", false)
								YRPOpenCharacterCreation("add char, not event char")
							end
						end

						if CharMenu.characterList.AddItem then
							CharMenu.characterList:AddItem(addChar)
						else
							CharMenu.characterList:AddPanel(addChar)
						end
					end

					if CharMenu.character.amountevent < LocalPlayer():GetYRPInt("int_charactersevent_max", 1) then
						local addCharEvent = YRPCreateD("YButton", nil, psw, psh, px, py)
						addCharEvent:SetText("")
						function addCharEvent:Paint(pw, ph)
							if CharMenu.character.amountevent and CharMenu.character.amountevent < LocalPlayer():GetYRPInt("int_charactersevent_max", 1) then
								draw.RoundedBox(0, 0, 0, pw, ph, Color(51, 51, 51, 200))
								draw.SimpleText(YRP:trans("LID_event"), "Y_30_700", pw / 2, YRP:ctr(300), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
								local sw = pw - 2 * YRP:ctr(180)
								local breite = YRP:ctr(50)
								if YRP:GetDesignIcon("add") ~= nil then
									draw.RoundedBox(breite / 2, pw / 2 - breite / 2, ph / 2 - sw / 2, breite, sw, Color(102, 102, 102, 255))
									draw.RoundedBox(breite / 2, pw / 2 - sw / 2, ph / 2 - breite / 2, sw, breite, Color(102, 102, 102, 255))
								end
							end
						end

						function addCharEvent:DoClick()
							if CharMenu.character.amountevent < LocalPlayer():GetYRPInt("int_charactersevent_max", 1) then
								if YRPPanelAlive(CharMenu.frame, "CharMenu.frame 2") then
									CharMenu.frame:Close()
								end

								SetGlobalYRPBool("create_eventchar", true)
								YRPOpenCharacterCreation("add char, event char")
							end
						end

						if CharMenu.characterList.AddItem then
							CharMenu.characterList:AddItem(addCharEvent)
						else
							CharMenu.characterList:AddPanel(addCharEvent)
						end
					end
				elseif YRP_CharDesign == "default" then
					YRPUpdateCharValues()
					psw = DefaultCharW
					psh = DefaultCharH
					local px = 0
					local py = 0
					if CharMenu.character.amount < LocalPlayer():GetYRPInt("int_characters_max", 1) then
						local addChar = YRPCreateD("YButton", nil, psw, psh, px, py)
						addChar:SetText("")
						function addChar:Paint(pw, ph)
							if CharMenu.character.amount < LocalPlayer():GetYRPInt("int_characters_max", 1) then
								draw.RoundedBox(50, 0, 0, pw, ph, Color(51, 51, 51, 200))
								local sw = pw - 2 * YRP:ctr(180)
								local sh = ph - 2 * YRP:ctr(180)
								local breite = YRP:ctr(50)
								if YRP:GetDesignIcon("add") ~= nil then
									draw.RoundedBox(breite / 2, pw / 2 - breite / 2, ph / 2 - sh / 2, breite, sh, Color(102, 102, 102, 255))
									draw.RoundedBox(breite / 2, pw / 2 - sw / 2, ph / 2 - breite / 2, sw, breite, Color(102, 102, 102, 255))
								end
							end
						end

						function addChar:DoClick()
							isEventChar = self.bool_eventchar
							if CharMenu.character.amount < LocalPlayer():GetYRPInt("int_characters_max", 1) then
								if YRPPanelAlive(CharMenu.frame, "CharMenu.frame 3") then
									CharMenu.frame:Close()
								end

								SetGlobalYRPBool("create_eventchar", false)
								YRPOpenCharacterCreation("add char, not event char")
							end
						end

						if CharMenu.characterList.AddItem then
							CharMenu.characterList:AddItem(addChar)
						else
							CharMenu.characterList:AddPanel(addChar)
						end
					end

					if CharMenu.character.amountevent < LocalPlayer():GetYRPInt("int_charactersevent_max", 1) then
						local addCharEvent = YRPCreateD("YButton", nil, psw, psh, px, py)
						addCharEvent:SetText("")
						function addCharEvent:Paint(pw, ph)
							if CharMenu.character.amountevent and CharMenu.character.amountevent < LocalPlayer():GetYRPInt("int_charactersevent_max", 1) then
								draw.RoundedBox(50, 0, 0, pw, ph, Color(51, 51, 51, 200))
								draw.SimpleText(YRP:trans("LID_event"), "Y_30_700", pw / 2, YRP:ctr(100), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
								local sw = pw - 2 * YRP:ctr(180)
								local sh = ph - 2 * YRP:ctr(180)
								local breite = YRP:ctr(50)
								if YRP:GetDesignIcon("add") ~= nil then
									draw.RoundedBox(breite / 2, pw / 2 - breite / 2, ph / 2 - sh / 2, breite, sh, Color(102, 102, 102, 255))
									draw.RoundedBox(breite / 2, pw / 2 - sw / 2, ph / 2 - breite / 2, sw, breite, Color(102, 102, 102, 255))
								end
							end
						end

						function addCharEvent:DoClick()
							if CharMenu.character.amountevent < LocalPlayer():GetYRPInt("int_charactersevent_max", 1) then
								if YRPPanelAlive(CharMenu.frame, "CharMenu.frame 4") then
									CharMenu.frame:Close()
								end

								SetGlobalYRPBool("create_eventchar", true)
								YRPOpenCharacterCreation("add char, event char")
							end
						end

						if CharMenu.characterList.AddItem then
							CharMenu.characterList:AddItem(addCharEvent)
						else
							CharMenu.characterList:AddPanel(addCharEvent)
						end
					end
				end
			end
		end

		if YRPPanelAlive(CharMenu.characterList, "CharMenu.characterList") and CharMenu.characterList.GetCanvas and CharMenu.characterList:GetWide() > CharMenu.characterList:GetCanvas():GetWide() then
			--CharMenu.characterList:SetWide(CharMenu.characterList:GetCanvas():GetWide() ) -- breaks vertical
			local _, py = CharMenu.characterList:GetPos()
			CharMenu.characterList:SetPos(CharMenu.charactersBackground:GetWide() / 2 - CharMenu.characterList:GetWide() / 2, py)
		end

		if CharMenu and YRPPanelAlive(CharMenu.frame, "CharMenu.frame 5") then
			CharMenu.frame:Show()
			CharMenu.frame:MakePopup()
		end
	end
end

net.Receive(
	"nws_yrp_received_chars",
	function(len)
		net.Start("nws_yrp_received_chars")
		net.SendToServer()
	end
)

net.Receive(
	"nws_yrp_get_characters",
	function(len)
		local first = net.ReadBool()
		if first and YRPPanelAlive(CharMenu.characterList, "CharMenu.characterList") and CharMenu.characterList.Clear then
			chars = {}
			CharMenu.characterList:Clear()
		end

		local char = net.ReadTable()
		local last = net.ReadBool()
		table.insert(chars, char)
		if last then
			YRPLoadCharacters()
		end
	end
)

function YRPGetCharacters()
	net.Start("nws_yrp_get_characters")
	net.SendToServer()
end

YRP_LogOut = YRP_LogOut or false
local logout = false
local logoutts = 0
local logoutpos
hook.Add(
	"HUDPaint",
	"yrp_logout",
	function()
		if GetGlobalYRPBool("bool_character_system") and not IsVoidCharEnabled() then
			if logoutts > CurTime() then
				if not logoutpos:IsEqualTol(LocalPlayer():GetPos(), 50) or LocalPlayer():IsInCombat() then
					logoutts = 0
					logout = false
				end

				draw.SimpleText(string.format("%s (%0.1f%s)", YRP:trans("LID_logout"), logoutts - CurTime(), string.lower(string.sub(YRP:trans("LID_seconds"), 1, 1))), "Y_30_700", ScrW() / 2, ScrH() * 0.25, Color(255, 255, 255, 255), 1, 1)
			elseif logout then
				logout = false
				net.Start("nws_yrp_LogOut")
				net.SendToServer()
			end
		end
	end
)

function YRPOCS(force)
	if IsVoidCharEnabled() or not GetGlobalYRPBool("bool_character_system", true) then return end
	if CharMenu and YRPPanelAlive(CharMenu.characterList, "CharMenu.characterList 2") and CharMenu.characterList.Clear then
		CharMenu.characterList:Clear()
	end

	if not loading then
		loading = true
		timer.Simple(
			0.3,
			function()
				loading = false
			end
		)
	else
		return
	end

	chars = {}
	CharMenu.character = {}
	CharMenu.character.amount = 0
	CharMenu.character.amountevent = 0
	YRPOpenMenu()
	if not YRPPanelAlive(CharMenu.frame, "CharMenu.frame 1") then
		YRP_CharDesign = string.lower(GetGlobalYRPString("text_character_design"))
		function CharMenu.logic()
			if YRP_CharDesign ~= string.lower(GetGlobalYRPString("text_character_design")) then
				YRP_CharDesign = string.lower(GetGlobalYRPString("text_character_design"))
				if CharMenu.frame and CharMenu.frame:IsVisible() then
					YRPCloseMenu()
					CharMenu.frame:Remove()
					CharMenu.frame = nil
					YRPOCS()
				end
			end

			timer.Simple(1, CharMenu.logic)
		end

		CharMenu.logic()
		CharMenu.frame = YRPCreateD("DFrame", nil, ScrW(), ScrH(), 0, 0)
		if YRP_CharDesign == "vertical" then
			CharMenu.frame:Hide()
			CharMenu.frame:SetTitle("")
			CharMenu.frame:ShowCloseButton(false)
			CharMenu.frame:SetDraggable(false)
			CharMenu.frame:Center()
			function CharMenu.frame:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, Color(40, 40, 40, 255)) -- Dark Background - Character Selection [vertical]
			end

			function CharMenu.frame:OnClose()
				YRPCloseMenu()
			end

			function CharMenu.frame:OnRemove()
				YRPCloseMenu()
			end

			CharMenu.frame.bg = YRPCreateD("DHTML", CharMenu.frame, ScrW(), ScrH(), 0, 0)
			CharMenu.frame.bg.url = ""
			CharMenu.frame.bgcf = YRPCreateD("DPanel", CharMenu.frame.bg, CharMenu.frame.bg:GetWide(), CharMenu.frame.bg:GetTall(), 0, 0)
			function CharMenu.frame.bgcf:Paint(pw, ph)
				-- Blur Background
				Derma_DrawBackgroundBlur(self, 0)
				-- Header of Menu
				draw.SimpleText(YRP:trans("LID_characterselection"), "Y_18_500", pw / 2, YRP:ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				-- Current Character Name
				draw.SimpleText(_cur, "Y_40_500", pw / 2, YRP:ctr(110), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				local aecur = CharMenu.character.amountevent or -1
				local aemax = LocalPlayer():GetYRPInt("int_charactersevent_max", 1)
				if aecur < aemax then
					draw.SimpleText(YRP:trans("LID_event"), "Y_30_700", pw / 2 - YRP:ctr(480), ph - YRP:ctr(180), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end

				-- Get Newest Background for the Menu
				if IsNotNilAndNotFalse(CharMenu) and YRPPanelAlive(CharMenu.frame) then
					local oldurl = CharMenu.frame.bg.url
					local newurl = GetGlobalYRPString("text_character_background", "")
					if oldurl ~= newurl then
						CharMenu.frame.bg.url = newurl
						CharMenu.frame.bg:SetHTML(YRPGetHTMLImage(newurl, ScrW(), ScrH())) -- url?
					end

					if newurl and strEmpty(newurl) and YRPGetCharBGNotFound then
						draw.SimpleText(YRPGetCharBGNotFound(), "Y_26_500", pw / 2, ph / 5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					end
				end
			end

			-- Language Changer / LanguageChanger
			YRP:DChangeLanguage(CharMenu.frame, ScrW() - YRP:ctr(32 * 5.6 + 20), YRP:ctr(20), YRP:ctr(32), true)
			local border = YRP:ctr(50)
			CharMenu.charactersBackground = YRPCreateD("DPanel", CharMenu.frame, YRP:ctr(fw), ScrH() - (2 * border), (ScrW() - ScW()) / 2 + border, border)
			CharMenu.charactersBackground.text = YRP:trans("LID_siteisloading")
			function CharMenu.charactersBackground:Paint(pw, ph)
				local color = YRPInterfaceValue("YFrame", "NC")
				draw.RoundedBox(YRP:ctr(10), 0, 0, pw, ph, Color(color.r, color.g, color.b, 100))
				local acur = CharMenu.character.amount or -1
				local amax = LocalPlayer():GetYRPInt("int_characters_max", 1)
				local acolor = Color(255, 255, 255, 255)
				if acur > amax then
					acolor = Color(255, 100, 100, 255)
				end

				local aecur = CharMenu.character.amountevent or -1
				local aemax = LocalPlayer():GetYRPInt("int_charactersevent_max", 1)
				local aecolor = Color(255, 255, 255, 255)
				if aecur > aemax then
					aecolor = Color(255, 100, 100, 255)
				end

				-- Current and Max Count of Possible Characters
				if aemax > 0 then
					draw.SimpleText(acur .. "/" .. amax, "Y_36_500", YRP:ctr(20), ph - YRP:ctr(50), acolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				else
					draw.SimpleText(acur .. "/" .. amax, "Y_36_500", pw / 2, ph - YRP:ctr(50), acolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end

				-- Current and Max Count of Possible Characters
				if aemax > 0 then
					draw.SimpleText(YRP:trans("LID_event") .. ": " .. aecur .. "/" .. aemax, "Y_36_500", pw - YRP:ctr(20), ph - YRP:ctr(50), aecolor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
				end

				draw.SimpleText(self.text, "Y_36_500", pw / 2, YRP:ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			local cmdlbr = 60
			local size = ScrH() - 2 * YRP:ctr(cmdlbr)
			CharMenu.charplayermodel = YRPCreateD("DModelPanel", CharMenu.frame, size, size, ScrW2() - size * 0.48, YRP:ctr(cmdlbr))
			CharMenu.charplayermodel:SetModel("models/player/skeleton.mdl")
			CharMenu.charplayermodel:SetAnimated(true)
			CharMenu.charplayermodel.Angles = Angle(0, 0, 0)
			function CharMenu.charplayermodel:DragMousePress()
				self.PressX, self.PressY = gui.MousePos()
				self.Pressed = true
			end

			function CharMenu.charplayermodel:DragMouseRelease()
				self.Pressed = false
			end

			function CharMenu.charplayermodel:LayoutEntity(ent)
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

			local mn, mx = CharMenu.charplayermodel.Entity:GetRenderBounds()
			local psize = 0
			psize = math.max(psize, math.abs(mn.x) + math.abs(mx.x))
			psize = math.max(psize, math.abs(mn.y) + math.abs(mx.y))
			psize = math.max(psize, math.abs(mn.z) + math.abs(mx.z))
			CharMenu.charplayermodel:SetFOV(45)
			CharMenu.charplayermodel:SetCamPos(Vector(psize, psize, psize))
			CharMenu.charplayermodel:SetLookAt((mn + mx) * 0.5)
			CharMenu.characterList = YRPCreateD("DPanelList", CharMenu.charactersBackground, YRP:ctr(fw) - 2 * br, ScrH() - (2 * border) - br - YRP:ctr(120), br, br)
			CharMenu.characterList:EnableVerticalScrollbar()
			CharMenu.characterList:SetSpacing(YRP:ctr(20))
			function CharMenu.characterList:Paint(pw, ph)
			end

			--draw.RoundedBox(0, 0, 0, pw, ph, Color( 255, 0, 0, 255) )
			local sbar = CharMenu.characterList.VBar
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

			local button = {}
			button.w = YRP:ctr(600)
			button.h = YRP:ctr(100)
			button.x = ScrW2() - button.w / 2
			button.y = ScrH() - button.h - border
			local charactersEnter = YRPCreateD("YButton", CharMenu.frame, button.w, button.h, button.x, button.y)
			function charactersEnter:Paint(pw, ph)
				if isEventChar then
					draw.SimpleText("EVENT CHARACTER", "Y_24_500", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				else
					local tab = {}
					tab.text = math.Round(LocalPlayer():GetYRPInt("int_deathtimestamp_min", 0) - CurTime(), 0)
					if LocalPlayer():GetYRPInt("int_deathtimestamp_min", 0) <= CurTime() then
						tab.text = YRP:trans("LID_play") -- .. " ( " .. _cur .. " )"
					end

					if LocalPlayer() ~= nil and LocalPlayer():Alive() then
						tab.text = YRP:trans("LID_close")
						tab.color = Color(255, 100, 100, 255)
					end

					local hasdesign = hook.Run("YButtonAPaint", self, pw, ph, tab)
					if not hasdesign then
						draw.RoundedBox(10, 0, 0, pw, ph, Color(255, 255, 255, 255))
						draw.SimpleTextOutlined(tab.text, "Y_24_500", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
					end
				end
			end

			charactersEnter:SetText("")
			function charactersEnter:DoClick()
				if not isEventChar and LocalPlayer() ~= nil and curChar ~= "-1" and LocalPlayer():GetYRPInt("int_deathtimestamp_min", 0) <= CurTime() then
					if LocalPlayer():Alive() then
						YRPCloseCharacterSelection()
					elseif curChar ~= nil then
						net.Start("nws_yrp_EnterWorld")
						net.WriteString(curChar)
						net.SendToServer()
						if YRPPanelAlive(CharMenu.frame, "CharMenu.frame 6") then
							CharMenu.frame:Close()
						end
					end
				end
			end

			local px, py = charactersEnter:GetPos()
			local deleteChar = YRPCreateD("YButton", CharMenu.frame, YRP:ctr(100), YRP:ctr(100), px + br + button.w, py)
			deleteChar:SetText("")
			function deleteChar:Paint(pw, ph)
				hook.Run("YRemovePaint", self, pw, ph)
			end

			function deleteChar:DoClick()
				local _window = createVGUI("DFrame", nil, 430, 50 + 10 + 50 + 10, 0, 0)
				_window:Center()
				_window:SetTitle(YRP:trans("LID_areyousure"))
				local _yesButton = createVGUI("DButton", _window, 200, 50, 10, 60)
				_yesButton:SetText(YRP:trans("LID_yes"))
				function _yesButton:DoClick()
					net.Start("nws_yrp_delete_own_character")
					net.WriteString(curChar)
					net.SendToServer()
					_window:Close()
				end

				local _noButton = createVGUI("DButton", _window, 200, 50, 10 + 200 + 10, 60)
				_noButton:SetText(YRP:trans("LID_no"))
				function _noButton:DoClick()
					_window:Close()
				end

				_window:MakePopup()
			end

			local charactersCreate = YRPCreateD("YButton", CharMenu.frame, YRP:ctr(100), YRP:ctr(100), px - br - YRP:ctr(100), py)
			charactersCreate:SetText("")
			function charactersCreate:Paint(pw, ph)
				if CharMenu.character.amount < LocalPlayer():GetYRPInt("int_characters_max", 1) then
					hook.Run("YAddPaint", self, pw, ph)
				end
			end

			function charactersCreate:DoClick()
				if CharMenu.character.amount < LocalPlayer():GetYRPInt("int_characters_max", 1) then
					if YRPPanelAlive(CharMenu.frame) then
						CharMenu.frame:Close()
					end

					SetGlobalYRPBool("create_eventchar", false)
					YRPOpenCharacterCreation("create char, not event char")
				end
			end

			local charactersCreateEvent = YRPCreateD("YButton", CharMenu.frame, YRP:ctr(100), YRP:ctr(100), px - br - YRP:ctr(210), py)
			charactersCreateEvent:SetText("")
			function charactersCreateEvent:Paint(pw, ph)
				if CharMenu.character.amountevent < LocalPlayer():GetYRPInt("int_charactersevent_max", 1) then
					hook.Run("YAddPaint", self, pw, ph)
				end
			end

			function charactersCreateEvent:DoClick()
				if CharMenu.character.amountevent < LocalPlayer():GetYRPInt("int_charactersevent_max", 1) then
					if YRPPanelAlive(CharMenu.frame) then
						CharMenu.frame:Close()
					end

					SetGlobalYRPBool("create_eventchar", true)
					YRPOpenCharacterCreation("create char, event char")
				end
			end
		elseif YRP_CharDesign == "horizontal" then
			-- Horizontal
			CharMenu.frame:Hide()
			CharMenu.frame:SetTitle("")
			CharMenu.frame:ShowCloseButton(false)
			CharMenu.frame:SetDraggable(false)
			CharMenu.frame:Center()
			function CharMenu.frame:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, Color(40, 40, 40, 255)) -- Dark Background - Character Selection [horizontal]
			end

			function CharMenu.frame:OnClose()
				YRPCloseMenu()
			end

			function CharMenu.frame:OnRemove()
				YRPCloseMenu()
			end

			CharMenu.frame.bg = YRPCreateD("DHTML", CharMenu.frame, ScrW(), ScrH(), 0, 0)
			CharMenu.frame.bg.url = ""
			CharMenu.frame.bgcf = YRPCreateD("DPanel", CharMenu.frame.bg, CharMenu.frame.bg:GetWide(), CharMenu.frame.bg:GetTall(), 0, 0)
			function CharMenu.frame.bgcf:Paint(pw, ph)
				-- Blur Background
				Derma_DrawBackgroundBlur(self, 0)
				-- Header of Menu
				draw.SimpleText(YRP:trans("LID_characterselection"), "Y_18_500", pw / 2, YRP:ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				-- Current Character Name
				draw.SimpleText(_cur, "Y_40_500", pw / 2, YRP:ctr(110), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				-- Get Newest Background for the Menu
				local oldurl = CharMenu.frame.bg.url
				local newurl = GetGlobalYRPString("text_character_background", "")
				if oldurl ~= newurl then
					CharMenu.frame.bg.url = newurl
					CharMenu.frame.bg:SetHTML(YRPGetHTMLImage(newurl, ScrW(), ScrH())) -- url?
				end

				if newurl and strEmpty(newurl) and YRPGetCharBGNotFound then
					draw.SimpleText(YRPGetCharBGNotFound(), "Y_26_500", pw / 2, ph / 5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end

				local acur = CharMenu.character.amount or -1
				local amax = LocalPlayer():GetYRPInt("int_characters_max", 1)
				local aecur = CharMenu.character.amountevent or -1
				local aemax = LocalPlayer():GetYRPInt("int_charactersevent_max", 1)
				-- Current and Max Count of Possible Characters
				local color = Color(255, 255, 255)
				draw.SimpleText(acur .. "/" .. amax, "Y_36_500", pw - br - YRP:ctr(100), ph - br - YRP:ctr(200) - br - YRP:ctr(100), color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				-- Current and Max Count of Possible Characters
				if aemax > 0 then
					draw.SimpleText(YRP:trans("LID_event") .. ": " .. aecur .. "/" .. aemax, "Y_36_500", pw - br - YRP:ctr(600), ph - br - YRP:ctr(200) - br - YRP:ctr(100), color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			end

			-- Language Changer / LanguageChanger
			YRP:DChangeLanguage(CharMenu.frame, ScrW() - YRP:ctr(32 * 5.6 + 20), YRP:ctr(20), YRP:ctr(32), true)
			CharMenu.charactersBackground = YRPCreateD("DPanel", CharMenu.frame, ScrW() - (2 * br), YRP:ctr(200) + (2 * br), br, ScrH() - YRP:ctr(200) - 2 * br - br)
			CharMenu.charactersBackground.text = YRP:trans("LID_siteisloading")
			function CharMenu.charactersBackground:Paint(pw, ph)
				local colo = YRPInterfaceValue("YFrame", "NC")
				draw.RoundedBox(YRP:ctr(10), 0, 0, pw, ph, Color(colo.r, colo.g, colo.b, 120))
				draw.SimpleText(self.text, "Y_36_500", pw / 2, YRP:ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			local size = ScrH() - br - br - YRP:ctr(200) - br - br - br - YRP:ctr(100) - br - br
			CharMenu.charplayermodel = YRPCreateD("DModelPanel", CharMenu.frame, size, size, ScrW2() - size / 2, br)
			CharMenu.charplayermodel:SetModel("models/player/skeleton.mdl")
			CharMenu.charplayermodel:SetAnimated(true)
			CharMenu.charplayermodel.Angles = Angle(0, 0, 0)
			function CharMenu.charplayermodel:DragMousePress()
				self.PressX, self.PressY = gui.MousePos()
				self.Pressed = true
			end

			function CharMenu.charplayermodel:DragMouseRelease()
				self.Pressed = false
			end

			function CharMenu.charplayermodel:LayoutEntity(ent)
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

			CharMenu.characterList = YRPCreateD("DHorizontalScroller", CharMenu.charactersBackground, CharMenu.charactersBackground:GetWide() - 2 * br, CharMenu.charactersBackground:GetTall() - 2 * br, br, br)
			--CharMenu.characterList:EnableVerticalScrollbar()
			CharMenu.characterList:SetOverlap(-YRP:ctr(20))
			function CharMenu.characterList:Paint(pw, ph)
			end

			--draw.RoundedBox(0, 0, 0, pw, ph, Color( 255, 0, 0, 255) )
			local button = {}
			button.w = YRP:ctr(600)
			button.h = YRP:ctr(100)
			button.x = ScrW2() - button.w / 2
			button.y = ScrH() - br - YRP:ctr(200) - br - br - br - button.h
			local charactersEnter = YRPCreateD("YButton", CharMenu.frame, button.w, button.h, button.x, button.y)
			function charactersEnter:Paint(pw, ph)
				if isEventChar then
					draw.SimpleText("EVENT CHARACTER", "Y_24_500", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				else
					local tab = {}
					tab.text = math.Round(LocalPlayer():GetYRPInt("int_deathtimestamp_min", 0) - CurTime(), 0)
					if LocalPlayer():GetYRPInt("int_deathtimestamp_min", 0) <= CurTime() then
						tab.text = YRP:trans("LID_play") -- .. " ( " .. _cur .. " )"
					end

					if LocalPlayer() ~= nil and LocalPlayer():Alive() then
						tab.text = YRP:trans("LID_close")
						tab.color = Color(255, 100, 100, 255)
					end

					local hasdesign = hook.Run("YButtonAPaint", self, pw, ph, tab)
					if not hasdesign then
						draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
						draw.SimpleTextOutlined(tab.text, "Y_24_500", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
					end
				end
			end

			charactersEnter:SetText("")
			function charactersEnter:DoClick()
				if not isEventChar and LocalPlayer() ~= nil and curChar ~= "-1" and LocalPlayer():GetYRPInt("int_deathtimestamp_min", 0) <= CurTime() then
					if LocalPlayer():Alive() then
						YRPCloseCharacterSelection()
						YRPCloseCharacterSelection()
					elseif curChar ~= nil then
						net.Start("nws_yrp_EnterWorld")
						net.WriteString(curChar)
						net.SendToServer()
						if YRPPanelAlive(CharMenu.frame) then
							CharMenu.frame:Close()
						end
					end
				end
			end

			local px, py = charactersEnter:GetPos()
			local deleteChar = YRPCreateD("YButton", CharMenu.frame, YRP:ctr(100), YRP:ctr(100), px + br + button.w, py)
			deleteChar:SetText("")
			function deleteChar:Paint(pw, ph)
				hook.Run("YRemovePaint", self, pw, ph)
			end

			function deleteChar:DoClick()
				local _window = createVGUI("DFrame", nil, 430, 50 + 10 + 50 + 10, 0, 0)
				_window:Center()
				_window:SetTitle(YRP:trans("LID_areyousure"))
				local _yesButton = createVGUI("DButton", _window, 200, 50, 10, 60)
				_yesButton:SetText(YRP:trans("LID_yes"))
				function _yesButton:DoClick()
					net.Start("nws_yrp_delete_own_character")
					net.WriteString(curChar)
					net.SendToServer()
					_window:Close()
					YRPCloseCharacterSelection()
					YRPOCS()
				end

				local _noButton = createVGUI("DButton", _window, 200, 50, 10 + 200 + 10, 60)
				_noButton:SetText(YRP:trans("LID_no"))
				function _noButton:DoClick()
					_window:Close()
				end

				_window:MakePopup()
			end

			local charactersCreate = YRPCreateD("YButton", CharMenu.frame, YRP:ctr(100), YRP:ctr(100), px - br - YRP:ctr(100), py)
			charactersCreate:SetText("")
			function charactersCreate:Paint(pw, ph)
				if CharMenu.character.amount < LocalPlayer():GetYRPInt("int_characters_max", 1) then
					hook.Run("YAddPaint", self, pw, ph)
				end
			end

			function charactersCreate:DoClick()
				if CharMenu.character.amount < LocalPlayer():GetYRPInt("int_characters_max", 1) then
					if YRPPanelAlive(CharMenu.frame) then
						CharMenu.frame:Close()
					end

					SetGlobalYRPBool("create_eventchar", false)
					YRPOpenCharacterCreation("create char, no event char")
				end
			end

			local charactersCreateEvent = YRPCreateD("YButton", CharMenu.frame, YRP:ctr(100), YRP:ctr(100), px - br - YRP:ctr(210), py)
			charactersCreateEvent:SetText("")
			function charactersCreateEvent:Paint(pw, ph)
				if CharMenu.character.amountevent < LocalPlayer():GetYRPInt("int_charactersevent_max", 1) then
					hook.Run("YAddPaint", self, pw, ph)
				end
			end

			function charactersCreateEvent:DoClick()
				if CharMenu.character.amountevent < LocalPlayer():GetYRPInt("int_charactersevent_max", 1) then
					if YRPPanelAlive(CharMenu.frame) then
						CharMenu.frame:Close()
					end

					SetGlobalYRPBool("create_eventchar", true)
					YRPOpenCharacterCreation("create char, event char")
				end
			end
		elseif YRP_CharDesign == "horizontalnew" then
			-- HorizontalNEW
			CharMenu.frame:Hide()
			CharMenu.frame:SetTitle("")
			CharMenu.frame:ShowCloseButton(false)
			CharMenu.frame:SetDraggable(false)
			CharMenu.frame:Center()
			function CharMenu.frame:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, Color(40, 40, 40, 255)) -- Dark Background - Character Selection [horizontalnew]
			end

			function CharMenu.frame:OnClose()
				YRPCloseMenu()
			end

			function CharMenu.frame:OnRemove()
				YRPCloseMenu()
			end

			CharMenu.frame.bg = YRPCreateD("DHTML", CharMenu.frame, ScrW(), ScrH(), 0, 0)
			CharMenu.frame.bg.url = ""
			CharMenu.frame.bgcf = YRPCreateD("DPanel", CharMenu.frame.bg, CharMenu.frame.bg:GetWide(), CharMenu.frame.bg:GetTall(), 0, 0)
			function CharMenu.frame.bgcf:Paint(pw, ph)
				-- Blur Background
				Derma_DrawBackgroundBlur(self, 0)
				-- Get Newest Background for the Menu
				local oldurl = CharMenu.frame.bg.url
				local newurl = GetGlobalYRPString("text_character_background", "")
				if oldurl ~= newurl then
					CharMenu.frame.bg.url = newurl
					CharMenu.frame.bg:SetHTML(YRPGetHTMLImage(newurl, ScrW(), ScrH())) -- url?
				end

				if newurl and strEmpty(newurl) and YRPGetCharBGNotFound then
					draw.SimpleText(YRPGetCharBGNotFound(), "Y_26_500", pw / 2, ph / 5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end

				-- Current and Max Count of Possible Characters
				local acur = CharMenu.character.amount or -1
				local amax = LocalPlayer():GetYRPInt("int_characters_max", 1)
				local acolor = Color(255, 255, 255, 255)
				if acur > amax then
					acolor = Color(255, 100, 100, 255)
				end

				draw.SimpleText(acur .. "/" .. amax, "Y_36_500", pw / 2, ph - YRP:ctr(300), acolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				-- Current and Max Count of Possible Event Characters
				local aecur = CharMenu.character.amountevent or -1
				local aemax = LocalPlayer():GetYRPInt("int_charactersevent_max", 1)
				local aecolor = Color(255, 255, 255, 255)
				if aecur > aemax then
					aecolor = Color(255, 100, 100, 255)
				end

				if aemax > 0 then
					draw.SimpleText(YRP:trans("LID_event") .. ": " .. aecur .. "/" .. aemax, "Y_36_500", pw / 2, ph - YRP:ctr(200), aecolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			end

			-- Language Changer / LanguageChanger
			YRP:DChangeLanguage(CharMenu.frame, ScrW() - YRP:ctr(32 * 5.6 + 20), YRP:ctr(20), YRP:ctr(32), true)
			local iconsize = YRP:ctr(120 * 2)
			local iconbr = YRP:ctr(30)
			CharMenu.charactersHeader = YRPCreateD("YPanel", CharMenu.frame, ScrW(), iconsize + iconbr, 0, 0)
			CharMenu.charactersHeader.logo = YRPCreateD("DHTML", CharMenu.frame, iconsize, iconsize + iconbr, 0, 0)
			CharMenu.charactersHeader.matlogo = Material("yrp/yrpicon.png")
			CharMenu.charactersHeader.br = iconbr
			function CharMenu.charactersHeader:Paint(pw, ph)
				--draw.RoundedBox(0, 0, 0, pw, ph, Color(51, 51, 51, 255) )
				if self.logo then
					if self.logo.svlogo ~= GetGlobalYRPString("text_server_logo", "") then
						self.logo.svlogo = GetGlobalYRPString("text_server_logo", "")
						if not strEmpty(GetGlobalYRPString("text_server_logo", "")) then
							self.logo:SetHTML(YRPGetHTMLImage(GetGlobalYRPString("text_server_logo", ""), iconsize, iconsize))
							self.logo:Show()
						else
							self.logo:Hide()
						end
					end

					if not self.logo:IsVisible() and yrp_logo then
						surface.SetMaterial(yrp_logo)
						surface.SetDrawColor(Color(255, 255, 255, 255))
						surface.DrawTexturedRect(iconbr, iconbr, iconsize, iconsize)
					elseif self.matlogo then
						surface.SetMaterial(self.matlogo)
						surface.SetDrawColor(Color(255, 255, 255, 255))
						surface.DrawTexturedRect(self.br, self.br, ph - 2 * self.br, ph - 2 * self.br)
					end
				end

				draw.SimpleText(YRPGetHostName(), "Saira_100", ph + 1 * self.br, ph / 2, Color(23, 107, 225), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end

			local charw = YRP:ctr(3 * 350 * 2 + 2 * 200)
			CharMenu.charactersBackground = YRPCreateD("DPanel", CharMenu.frame, charw, ScrH() - YRP:ctr(600 + 360), ScrW() / 2 - charw / 2, YRP:ctr(600))
			CharMenu.charactersBackground.text = YRP:trans("LID_siteisloading")
			function CharMenu.charactersBackground:Paint(pw, ph)
				draw.SimpleText(self.text, "Y_36_500", pw / 2, YRP:ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			CharMenu.characterList = YRPCreateD("DHorizontalScroller", CharMenu.charactersBackground, CharMenu.charactersBackground:GetWide(), CharMenu.charactersBackground:GetTall(), 0, 0)
			--CharMenu.characterList:EnableVerticalScrollbar()
			CharMenu.characterList:SetOverlap(-YRP:ctr(200))
			function CharMenu.characterList:Paint(pw, ph)
			end

			--draw.RoundedBox(0, 0, 0, pw, ph, Color( 255, 0, 0, 255) )
			CharMenu.characterList.OffsetX = 0
			local arrowbtnsize = YRP:ctr(128)
			CharMenu.prevChar = YRPCreateD("YButton", CharMenu.frame, arrowbtnsize, arrowbtnsize, ScrW() / 2 - charw / 2 - YRP:ctr(100 + 100), YRP:ctr(600) + CharMenu.charactersBackground:GetTall() / 2 - YRP:ctr(100 / 2))
			CharMenu.prevChar:SetText("")
			function CharMenu.prevChar:Paint(pw, ph)
				if CharMenu.characterList.OffsetX > 0 then
					--hook.Run( "YButtonPaint", self, pw, ph)
					local color = Color(255, 255, 255, 255)
					if self:IsHovered() then
						color = YRPInterfaceValue("YButton", "NC")
					end

					if YRP:GetDesignIcon("64_angle-right") ~= nil then
						surface.SetMaterial(YRP:GetDesignIcon("64_angle-left"))
						surface.SetDrawColor(color)
						surface.DrawTexturedRect(br, ph / 2 - (pw - 2 * br) / 2, pw - 2 * br, pw - 2 * br)
					end
				end
			end

			function CharMenu.prevChar:DoClick()
				CharMenu.characterList.OffsetX = CharMenu.characterList.OffsetX - YRP:ctr(350 * 2 + 200)
				if CharMenu.characterList.OffsetX <= 0 then
					CharMenu.characterList.OffsetX = 0
				end

				CharMenu.characterList:SetScroll(CharMenu.characterList.OffsetX)
			end

			CharMenu.nextChar = YRPCreateD("YButton", CharMenu.frame, arrowbtnsize, arrowbtnsize, ScrW() / 2 + charw / 2 + arrowbtnsize, YRP:ctr(600) + CharMenu.charactersBackground:GetTall() / 2 - YRP:ctr(100 / 2))
			CharMenu.nextChar:SetText("")
			function CharMenu.nextChar:Paint(pw, ph)
				if CharMenu.characterList.OffsetX < CharMenu.characterList:GetCanvas():GetWide() - CharMenu.characterList:GetWide() then
					--hook.Run( "YButtonPaint", self, pw, ph)
					local color = Color(255, 255, 255, 255)
					if self:IsHovered() then
						color = YRPInterfaceValue("YButton", "NC")
					end

					if YRP:GetDesignIcon("64_angle-right") ~= nil then
						surface.SetMaterial(YRP:GetDesignIcon("64_angle-right"))
						surface.SetDrawColor(color)
						surface.DrawTexturedRect(br, ph / 2 - (pw - 2 * br) / 2, pw - 2 * br, pw - 2 * br)
					end
				end
			end

			function CharMenu.nextChar:DoClick()
				CharMenu.characterList.OffsetX = CharMenu.characterList.OffsetX + YRP:ctr(350 * 2 + 200)
				if CharMenu.characterList.OffsetX >= CharMenu.characterList:GetCanvas():GetWide() - CharMenu.characterList:GetWide() then
					CharMenu.characterList.OffsetX = CharMenu.characterList:GetCanvas():GetWide() - CharMenu.characterList:GetWide()
				end

				CharMenu.characterList:SetScroll(CharMenu.characterList.OffsetX)
			end
		elseif YRP_CharDesign == "default" then
			CharMenu.frame:Hide()
			CharMenu.frame:SetTitle("")
			--CharMenu.frame:ShowCloseButton(false)
			CharMenu.frame:SetDraggable(false)
			CharMenu.frame:Center()
			function CharMenu.frame:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, Color(40, 40, 40, 255)) -- Dark Background - Character Selection [horizontalnew]
			end

			function CharMenu.frame:OnClose()
				YRPCloseMenu()
			end

			function CharMenu.frame:OnRemove()
				YRPCloseMenu()
			end

			CharMenu.frame.bg = YRPCreateD("DHTML", CharMenu.frame, ScrW(), ScrH(), 0, 0)
			CharMenu.frame.bg.url = ""
			CharMenu.frame.bgcf = YRPCreateD("DPanel", CharMenu.frame.bg, CharMenu.frame.bg:GetWide(), CharMenu.frame.bg:GetTall(), 0, 0)
			function CharMenu.frame.bgcf:Paint(pw, ph)
				-- Blur Background
				Derma_DrawBackgroundBlur(self, 0)
				-- Get Newest Background for the Menu
				local oldurl = CharMenu.frame.bg.url
				local newurl = GetGlobalYRPString("text_character_background", "")
				if oldurl ~= newurl then
					CharMenu.frame.bg.url = newurl
					CharMenu.frame.bg:SetHTML(YRPGetHTMLImage(newurl, ScrW(), ScrH())) -- url?
				end

				if newurl and strEmpty(newurl) and YRPGetCharBGNotFound then
					draw.SimpleText(YRPGetCharBGNotFound(), "Y_26_500", pw / 2, ph / 20, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end

				-- Current and Max Count of Possible Characters
				local acur = CharMenu.character.amount or -1
				local amax = LocalPlayer():GetYRPInt("int_characters_max", 1)
				local acolor = Color(255, 255, 255, 255)
				if acur > amax then
					acolor = Color(255, 100, 100, 255)
				end

				draw.SimpleText(acur .. "/" .. amax, "Y_36_500", pw / 2 + DefaultCharW / 2 + YRP:ctr(10), ph - YRP:ctr(100), acolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				-- Current and Max Count of Possible Event Characters
				local aecur = CharMenu.character.amountevent or -1
				local aemax = LocalPlayer():GetYRPInt("int_charactersevent_max", 1)
				local aecolor = Color(255, 255, 255, 255)
				if aecur > aemax then
					aecolor = Color(255, 100, 100, 255)
				end

				if aemax > 0 then
					draw.SimpleText(YRP:trans("LID_event") .. ": " .. aecur .. "/" .. aemax, "Y_36_500", pw / 2 + DefaultCharW / 2 + YRP:ctr(10), ph - YRP:ctr(40), aecolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end
			end

			-- Language Changer / LanguageChanger
			YRP:DChangeLanguage(CharMenu.frame, ScrW() - YRP:ctr(32 * 5.6 + 20), YRP:ctr(20), YRP:ctr(32), true)
			YRPUpdateCharValues()
			local charw = DefaultCharW
			local charh = DefaultCharH
			CharMenu.charactersBackground = YRPCreateD("DPanel", CharMenu.frame, charw, charh, ScrW() / 2 - charw / 2, ScrH() / 2 - charh / 2)
			CharMenu.charactersBackground.text = YRP:trans("LID_siteisloading")
			function CharMenu.charactersBackground:Paint(pw, ph)
				draw.SimpleText(self.text, "Y_36_500", pw / 2, YRP:ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			CharMenu.characterList = YRPCreateD("DHorizontalScroller", CharMenu.charactersBackground, charw, charh, 0, 0)
			CharMenu.characterList.OffsetX = 0
			--CharMenu.characterList:EnableVerticalScrollbar()
			CharMenu.characterList:SetOverlap(-YRP:ctr(200))
			function CharMenu.characterList:Paint(pw, ph)
				--draw.RoundedBox(0, 0, 0, pw, ph, Color( 255, 0, 0, 255) )
				if CharMenu.characterList.OffsetX then
					testid = CharMenu.characterList.OffsetX / (charw + YRP:ctr(200))
					testid = math.Round(testid)
					testid = testid + 1
					if chars[testid] and chars[testid].char and not chars[testid].char.bool_eventchar then
						validchar = true
						curChar = chars[testid].char.uniqueID
						curCharName = chars[testid].char.rpname
					else
						validchar = false
					end
				end
			end

			function CharMenu.characterList.btnLeft:Paint(w, h)
			end

			--draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 100, 0 ) )
			function CharMenu.characterList.btnLeft:IsDown()
				return false
			end

			function CharMenu.characterList.btnRight:Paint(w, h)
			end

			--draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 100, 200 ) )
			function CharMenu.characterList.btnRight:IsDown()
				return false
			end

			function CharMenu.characterList:OnMouseWheeled(delta)
				if delta > 0 then
					CharMenu.characterList.OffsetX = CharMenu.characterList.OffsetX - (charw + YRP:ctr(200))
				else
					CharMenu.characterList.OffsetX = CharMenu.characterList.OffsetX + (charw + YRP:ctr(200))
				end

				if CharMenu.characterList.OffsetX <= 0 then
					CharMenu.characterList.OffsetX = 0
				end

				if CharMenu.characterList.OffsetX >= CharMenu.characterList:GetCanvas():GetWide() - CharMenu.characterList:GetWide() then
					CharMenu.characterList.OffsetX = CharMenu.characterList:GetCanvas():GetWide() - CharMenu.characterList:GetWide()
				end

				CharMenu.characterList:SetScroll(CharMenu.characterList.OffsetX)
			end

			local arrowbtnsize = YRP:ctr(128)
			CharMenu.prevChar = YRPCreateD("YButton", CharMenu.frame, arrowbtnsize, arrowbtnsize, ScrW() / 2 - DefaultCharW / 2, ScrH() - arrowbtnsize)
			CharMenu.prevChar:SetText("")
			function CharMenu.prevChar:Paint(pw, ph)
				if CharMenu.characterList.OffsetX > 0 then
					--hook.Run( "YButtonPaint", self, pw, ph)
					local color = Color(255, 255, 255, 255)
					if self:IsHovered() then
						color = YRPInterfaceValue("YButton", "NC")
					end

					if YRP:GetDesignIcon("64_angle-right") ~= nil then
						surface.SetMaterial(YRP:GetDesignIcon("64_angle-left"))
						surface.SetDrawColor(color)
						surface.DrawTexturedRect(br, ph / 2 - (pw - 2 * br) / 2, pw - 2 * br, pw - 2 * br)
					end
				end
			end

			function CharMenu.prevChar:DoClick()
				CharMenu.characterList.OffsetX = CharMenu.characterList.OffsetX - (charw + YRP:ctr(200))
				if CharMenu.characterList.OffsetX <= 0 then
					CharMenu.characterList.OffsetX = 0
				end

				CharMenu.characterList:SetScroll(CharMenu.characterList.OffsetX)
			end

			CharMenu.nextChar = YRPCreateD("YButton", CharMenu.frame, arrowbtnsize, arrowbtnsize, ScrW() / 2 + DefaultCharW / 2 - arrowbtnsize, ScrH() - arrowbtnsize)
			CharMenu.nextChar:SetText("")
			function CharMenu.nextChar:Paint(pw, ph)
				if CharMenu.characterList.OffsetX < CharMenu.characterList:GetCanvas():GetWide() - CharMenu.characterList:GetWide() then
					--hook.Run( "YButtonPaint", self, pw, ph)
					local color = Color(255, 255, 255, 255)
					if self:IsHovered() then
						color = YRPInterfaceValue("YButton", "NC")
					end

					if YRP:GetDesignIcon("64_angle-right") ~= nil then
						surface.SetMaterial(YRP:GetDesignIcon("64_angle-right"))
						surface.SetDrawColor(color)
						surface.DrawTexturedRect(br, ph / 2 - (pw - 2 * br) / 2, pw - 2 * br, pw - 2 * br)
					end
				end
			end

			function CharMenu.nextChar:DoClick()
				CharMenu.characterList.OffsetX = CharMenu.characterList.OffsetX + (charw + YRP:ctr(200))
				if CharMenu.characterList.OffsetX >= CharMenu.characterList:GetCanvas():GetWide() - CharMenu.characterList:GetWide() then
					CharMenu.characterList.OffsetX = CharMenu.characterList:GetCanvas():GetWide() - CharMenu.characterList:GetWide()
				end

				CharMenu.characterList:SetScroll(CharMenu.characterList.OffsetX)
			end

			local bw = ScrW() * 0.14
			local bh = ScrH() * 0.05
			local charactersEnter = YRPCreateD("YButton", CharMenu.frame, bw, bh, ScrW() / 2 - bw / 2, ScrH() - bh - ScrH() * 0.01)
			function charactersEnter:Paint(pw, ph)
				local tab = {}
				local text = math.Round(LocalPlayer():GetYRPInt("int_deathtimestamp_min", 0) - CurTime(), 0)
				tab.color = Color(38, 222, 129)
				if LocalPlayer():GetYRPInt("int_deathtimestamp_min", 0) <= CurTime() and validchar then
					text = YRP:trans("LID_play") -- .. " ( " .. curCharName .. " )"
				else
					text = ""
				end

				if LocalPlayer() ~= nil and LocalPlayer():Alive() then
					text = YRP:trans("LID_close")
					tab.color = Color(120, 0, 0, 255)
				end

				if not strEmpty(text) then
					hook.Run("YButtonAPaint", self, pw, ph, tab)
					draw.SimpleText(text, "Y_26_700", pw / 2, ph / 2, YRPTextColor(tab.color), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			end

			charactersEnter:SetText("")
			function charactersEnter:DoClick()
				if LocalPlayer() ~= nil and validchar and curChar > -1 and LocalPlayer():GetYRPInt("int_deathtimestamp_min", 0) <= CurTime() then
					if LocalPlayer():Alive() then
						YRPCloseCharacterSelection()
					elseif curChar ~= nil then
						net.Start("nws_yrp_EnterWorld")
						net.WriteString(curChar)
						net.SendToServer()
						if YRPPanelAlive(CharMenu.frame) then
							CharMenu.frame:Close()
						end
					end
				end
			end
		end
	end
end

function YRPOpenCharacterSelection(force)
	if not force and LocalPlayer():Alive() then
		logoutpos = LocalPlayer():GetPos()
		logoutts = CurTime() + GetGlobalYRPInt("int_logouttime", 3)
		logout = true
		YRP_LogOut = true
	else
		YRPOCS(force)
		YRPGetCharacters()
	end
end

net.Receive(
	"nws_yrp_LogOut",
	function(len)
		if GetGlobalYRPBool("bool_character_system") and not IsVoidCharEnabled() then
			YRPOpenCharacterSelection()
			timer.Simple(
				0.3,
				function()
					YRP_LogOut = false
				end
			)
		end
	end
)

net.Receive(
	"YRPOpenCharacterMenu",
	function(len, ply)
		timer.Simple(
			1,
			function()
				YRPOpenCharacterSelection(true)
			end
		)
	end
)

net.Receive(
	"nws_yrp_YRPOpenCharacterCreation",
	function(len, ply)
		timer.Simple(
			1,
			function()
				SetGlobalYRPBool("create_eventchar", false)
				YRPOpenCharacterCreation("server force YRPOpenCharacterCreation")
			end
		)
	end
)
