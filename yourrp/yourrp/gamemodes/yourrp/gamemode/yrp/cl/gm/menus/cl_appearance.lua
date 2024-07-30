--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local _appe = {}
_appe.r = {}
local _yrp_appearance = {}
local play = true
net.Receive(
	"nws_yrp_get_menu_bodygroups",
	function(len)
		local _tbl = net.ReadTable()
		if _tbl.string_playermodels ~= nil and YRPPanelAlive(_yrp_appearance.window, "_yrp_appearance.window") then
			local _skin = tonumber(_tbl.skin)
			local _pms = string.Explode(",", _tbl.string_playermodels)
			if YRPPanelAlive(_yrp_appearance.left, "_yrp_appearance.left") then
				if _yrp_appearance.left.GetChildren ~= nil then
					for i, child in pairs(_yrp_appearance.left:GetChildren()) do
						child:Remove()
					end
				end

				local _pmid = tonumber(_tbl.playermodelID)
				if _pmid > #_pms then
					_pmid = 1
				end

				local _pm = _pms[_pmid]
				if _pm == "" or _pm == " " then
					_pm = "models/player/skeleton.mdl"
				end

				if pm ~= "" then
					local _cbg = {}
					_cbg[1] = _tbl.bg0 or 0
					_cbg[2] = _tbl.bg1 or 0
					_cbg[3] = _tbl.bg2 or 0
					_cbg[4] = _tbl.bg3 or 0
					_cbg[5] = _tbl.bg4 or 0
					_cbg[6] = _tbl.bg5 or 0
					_cbg[7] = _tbl.bg6 or 0
					_cbg[8] = _tbl.bg7 or 0
					_cbg[9] = _tbl.bg8 or 0
					_cbg[10] = _tbl.bg9 or 0
					_cbg[11] = _tbl.bg10 or 0
					_cbg[12] = _tbl.bg11 or 0
					_cbg[13] = _tbl.bg12 or 0
					_cbg[14] = _tbl.bg13 or 0
					_cbg[15] = _tbl.bg14 or 0
					_cbg[16] = _tbl.bg15 or 0
					_cbg[17] = _tbl.bg16 or 0
					_cbg[18] = _tbl.bg17 or 0
					_cbg[19] = _tbl.bg18 or 0
					_cbg[20] = _tbl.bg19 or 0
					function _yrp_appearance.left:Paint(pw, ph)
					end

					--
					_appe.r.play = YRPCreateD("YButton", _yrp_appearance.left, YRP:ctr(100), YRP:ctr(100), ScW() / 4, ScrH() - YRP:ctr(200))
					_appe.r.play:SetText("")
					function _appe.r.play:Paint(pw, ph)
						local tab = {}
						tab.w = pw
						tab.h = ph
						tab.text = {}
						tab.text.text = ""
						YRPDrawButton(self, tab)
						local symbol = "pause"
						local color = Color(0, 255, 0)
						if not self:IsHovered() and play then
							symbol = "play"
							color = Color(0, 255, 0)
						elseif self:IsHovered() and not play then
							symbol = "play"
							color = Color(0, 255, 0)
						end

						YRP:DrawIcon(YRP:GetDesignIcon(symbol), pw, ph, 0, 0, color)
					end

					function _appe.r.play:DoClick()
						play = not play
					end

					_appe.r.pm = YRPCreateD("DModelPanel", _yrp_appearance.left, ScrH() - _yrp_appearance.window:GetHeaderHeight() - YRP:ctr(100), ScW() / 2, 0, 0)
					_appe.r.pm:SetModel(_pm)
					_appe.r.pm:SetAnimated(true)
					_appe.r.pm.Angles = Angle(0, 0, 0)
					function _appe.r.pm:DragMousePress()
						self.PressX, self.PressY = gui.MousePos()
						self.Pressed = true
					end

					function _appe.r.pm:DragMouseRelease()
						self.Pressed = false
					end

					function _appe.r.pm:LayoutEntity(ent)
						if self.Pressed then
							local mx = gui.MousePos()
							self.Angles = self.Angles - Angle(0, (self.PressX or mx) - mx, 0)
							self.PressX, self.PressY = gui.MousePos()
						elseif play then
							self.Angles = self.Angles + Angle(0, 0.1, 0)
						end

						ent:SetAngles(self.Angles)
						if self.bAnimated then
							self:RunAnimation()
						end
					end

					-- Playermodel changing
					local _tmpPM = YRPCreateD("DPanel", _yrp_appearance.left, ScrH2() - YRP:ctr(30), YRP:ctr(80), ScW() / 2, _yrp_appearance.window:GetHeaderHeight())
					_tmpPM.cur = _pmid
					_tmpPM.max = #_pms
					_tmpPM.name = YRP:trans("LID_appearance")
					function _tmpPM:Paint(pw, ph)
						hook.Run("YPanelPaint", self, pw, ph)
						draw.SimpleTextOutlined(self.name .. " ( " .. _tmpPM.cur .. "/" .. _tmpPM.max .. " )", "DermaDefault", YRP:ctr(60), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, YRP:ctr(1), Color(0, 0, 0, 255))
					end

					local _tmpPMUp = YRPCreateD("YButton", _tmpPM, YRP:ctr(50), YRP:ctr(80 / 2 - 4), YRP:ctr(2), YRP:ctr(2))
					_tmpPMUp:SetText("")
					_tmpPMUp.tab = {
						["text"] = "↑"
					}

					function _tmpPMUp:Paint(pw, ph)
						if _tmpPM.cur < _tmpPM.max then
							hook.Run("YButtonPaint", self, pw, ph, self.tab)
						end
					end

					function _tmpPMUp:DoClick()
						if _tmpPM.cur < _tmpPM.max then
							_tmpPM.cur = _tmpPM.cur + 1
						end

						net.Start("nws_yrp_inv_pm_up")
						net.WriteInt(_tmpPM.cur, 16)
						net.SendToServer()
						if _appe.r.pm.Entity then
							_appe.r.pm.Entity:SetModel(_pms[_tmpPM.cur])
						end
					end

					local _tmpPMDo = YRPCreateD("YButton", _tmpPM, YRP:ctr(50), YRP:ctr(80 / 2 - 4), YRP:ctr(2), YRP:ctr(2 + 40))
					_tmpPMDo:SetText("")
					_tmpPMDo.tab = {
						["text"] = "↓"
					}

					function _tmpPMDo:Paint(pw, ph)
						if _tmpPM.cur > 1 then
							hook.Run("YButtonPaint", self, pw, ph, self.tab)
						end
					end

					function _tmpPMDo:DoClick()
						if _tmpPM.cur > 1 then
							_tmpPM.cur = _tmpPM.cur - 1
						end

						net.Start("nws_yrp_inv_pm_do")
						net.WriteInt(_tmpPM.cur, 16)
						net.SendToServer()
						if _appe.r.pm.Entity then
							_appe.r.pm.Entity:SetModel(_pms[_tmpPM.cur])
						end
					end

					-- Skin changing
					if _appe.r.pm.Entity then
						_tbl.bgs = _appe.r.pm.Entity:GetBodyGroups()
					end

					local _tmpSkin = YRPCreateD("DPanel", _yrp_appearance.left, ScrH2() - YRP:ctr(30), YRP:ctr(80), ScW() / 2, YRP:ctr(200))
					_tmpSkin.cur = _skin --_appe.r.pm.Entity:GetSkin()
					if _appe.r.pm.Entity then
						_appe.r.pm.Entity:SetSkin(_tmpSkin.cur)
						_tmpSkin.max = _appe.r.pm.Entity:SkinCount()
					end

					_tmpSkin.name = YRP:trans("LID_skin")
					function _tmpSkin:Paint(pw, ph)
						hook.Run("YPanelPaint", self, pw, ph)
						draw.SimpleTextOutlined(self.name .. " ( " .. _tmpSkin.cur + 1 .. "/" .. _tmpSkin.max .. " )", "DermaDefault", YRP:ctr(60), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, YRP:ctr(1), Color(0, 0, 0, 255))
					end

					local _tmpSkinUp = YRPCreateD("YButton", _tmpSkin, YRP:ctr(50), YRP:ctr(80 / 2 - 4), YRP:ctr(2), YRP:ctr(2))
					_tmpSkinUp:SetText("")
					_tmpSkinUp.tab = {
						["text"] = "↑"
					}

					function _tmpSkinUp:Paint(pw, ph)
						if _tmpSkin.cur < _tmpSkin.max - 1 then
							hook.Run("YButtonPaint", self, pw, ph, self.tab)
						end
					end

					function _tmpSkinUp:DoClick()
						if _tmpSkin.cur < _tmpSkin.max - 1 then
							_tmpSkin.cur = _tmpSkin.cur + 1
						end

						net.Start("nws_yrp_inv_skin_up")
						net.WriteInt(_tmpSkin.cur, 16)
						net.SendToServer()
						if _appe.r.pm.Entity then
							_appe.r.pm.Entity:SetSkin(_tmpSkin.cur)
						end
					end

					local _tmpSkinDo = YRPCreateD("YButton", _tmpSkin, YRP:ctr(50), YRP:ctr(80 / 2 - 4), YRP:ctr(2), YRP:ctr(2 + 40))
					_tmpSkinDo:SetText("")
					_tmpSkinDo.tab = {
						["text"] = "↓"
					}

					function _tmpSkinDo:Paint(pw, ph)
						if _tmpSkin.cur > 0 then
							hook.Run("YButtonPaint", self, pw, ph, self.tab)
						end
					end

					function _tmpSkinDo:DoClick()
						if _tmpSkin.cur > 0 then
							_tmpSkin.cur = _tmpSkin.cur - 1
						end

						net.Start("nws_yrp_inv_skin_do")
						net.WriteInt(_tmpSkin.cur, 16)
						net.SendToServer()
						if YRPEntityAlive(_appe.r.pm.Entity) then
							_appe.r.pm.Entity:SetSkin(_tmpSkin.cur)
						end
					end

					-- Bodygroups changing
					if _tbl.bgs then
						for k, v in pairs(_tbl.bgs) do
							if _cbg[k] ~= nil then
								_cbg[k] = tonumber(_cbg[k])
								if _appe.r.pm.Entity then
									_appe.r.pm.Entity:SetBodygroup(k - 1, tonumber(_cbg[k]))
								end

								local _height = 80
								local _tmpBg = YRPCreateD("DPanel", _yrp_appearance.left, ScrH2() - YRP:ctr(30), YRP:ctr(_height), ScW() / 2, YRP:ctr(300) + k * YRP:ctr(_height + 2))
								_tmpBg.name = v.name
								_tmpBg.max = v.num
								_tmpBg.cur = _cbg[k]
								_tmpBg.id = v.id
								function _tmpBg:Paint(pw, ph)
									hook.Run("YPanelPaint", self, pw, ph)
									draw.SimpleTextOutlined(self.name .. " ( " .. _tmpBg.cur + 1 .. "/" .. _tmpBg.max .. " )", "DermaDefault", YRP:ctr(60), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, YRP:ctr(1), Color(0, 0, 0, 255))
								end

								_tmpBgUp = YRPCreateD("YButton", _tmpBg, YRP:ctr(50), YRP:ctr(_height / 2 - 4), YRP:ctr(2), YRP:ctr(2))
								_tmpBgUp:SetText("")
								_tmpBgUp.tab = {
									["text"] = "↑"
								}

								function _tmpBgUp:Paint(pw, ph)
									if _tmpBg.cur < _tmpBg.max - 1 then
										hook.Run("YButtonPaint", self, pw, ph, self.tab)
									end
								end

								function _tmpBgUp:DoClick()
									if _tmpBg.cur < _tmpBg.max - 1 then
										_tmpBg.cur = _tmpBg.cur + 1
									end

									net.Start("nws_yrp_inv_bg_up")
									net.WriteInt(_tmpBg.cur, 16)
									net.WriteInt(_tmpBg.id, 16)
									net.SendToServer()
									if _appe.r.pm.Entity then
										_appe.r.pm.Entity:SetBodygroup(_tmpBg.id, _tmpBg.cur)
									end
								end

								_tmpBgDo = YRPCreateD("YButton", _tmpBg, YRP:ctr(50), YRP:ctr(_height / 2 - 4), YRP:ctr(2), YRP:ctr(_height / 2 - 2))
								_tmpBgDo:SetText("")
								_tmpBgDo.tab = {
									["text"] = "↓"
								}

								function _tmpBgDo:Paint(pw, ph)
									if _tmpBg.cur > 0 then
										hook.Run("YButtonPaint", self, pw, ph, self.tab)
									end
								end

								function _tmpBgDo:DoClick()
									if _tmpBg.cur > 0 then
										_tmpBg.cur = _tmpBg.cur - 1
									end

									net.Start("nws_yrp_inv_bg_do")
									net.WriteInt(_tmpBg.cur, 16)
									net.WriteInt(_tmpBg.id, 16)
									net.SendToServer()
									if _appe.r.pm.Entity then
										_appe.r.pm.Entity:SetBodygroup(_tmpBg.id, _tmpBg.cur)
									end
								end
							end
						end
					end
				end
			end
		elseif YRPPanelAlive(_yrp_appearance.window, "_yrp_appearance.window 2") then
			function _yrp_appearance.window:Paint(pw, ph)
				hook.Run("YFramePaint", self, pw, ph)
				local tab = {}
				tab.x = pw / 2
				tab.y = ph / 2
				tab.font = "Y_22_500"
				tab.text = "Role Has No Playermodel!"
				YRPDrawText(tab)
			end
		end
	end
)

function YRPToggleAppearanceMenu()
	if YRPIsNoMenuOpen() then
		if GetGlobalYRPBool("bool_appearance_system", false) then
			open_appearance()
		end
	else
		close_appearance()
	end
end

function close_appearance()
	if _yrp_appearance.window ~= nil then
		YRPCloseMenu()
		_yrp_appearance.window:Remove()
		if _yrp_appearance.drop_panel ~= nil then
			_yrp_appearance.drop_panel:Remove()
		end

		_yrp_appearance.window = nil
	end
end

net.Receive(
	"nws_yrp_openAM",
	function(len)
		open_appearance()
	end
)

function open_appearance()
	YRPOpenMenu()
	_yrp_appearance.window = YRPCreateD("YFrame", nil, ScW(), ScrH(), 0, 0)
	_yrp_appearance.window:SetTitle("LID_appearance")
	_yrp_appearance.window:Center()
	_yrp_appearance.window:SetDraggable(false)
	_yrp_appearance.window:SetSizable(true)
	_yrp_appearance.window:SetHeaderHeight(YRP:ctr(100))
	function _yrp_appearance.window:OnClose()
		if YRPPanelAlive(_yrp_appearance.window, "_yrp_appearance.window 4") then
			_yrp_appearance.window:Remove()
		end
	end

	function _yrp_appearance.window:Paint(pw, ph)
		hook.Run("YFramePaint", self, pw, ph)
	end

	_yrp_appearance.left = YRPCreateD("DPanel", _yrp_appearance.window, ScW(), ScrH() - _yrp_appearance.window:GetHeaderHeight(), 0, _yrp_appearance.window:GetHeaderHeight())
	function _yrp_appearance.left:Paint(pw, ph)
	end

	--
	LocalPlayer().yrp_delay_apperance = LocalPlayer().yrp_delay_apperance or 0
	if LocalPlayer().yrp_delay_apperance < CurTime() then
		LocalPlayer().yrp_delay_apperance = CurTime() + 5
		net.Start("nws_yrp_get_menu_bodygroups")
		net.SendToServer()
	else
		LocalPlayer():PrintMessage(HUD_PRINTCENTER, "On Cooldown!")
	end

	_yrp_appearance.window:MakePopup()
end
