--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local boxspace = YRP.ctr(20)
local tx, ty = 0
local visible = true
local cur_delay = CurTime()
local cur_alpha = 255
net.Receive(
	"nws_yrp_get_design_settings",
	function(len)
		local lply = LocalPlayer()
		local setting = net.ReadTable()
		local HUDS = net.ReadTable()
		local INTERFACES = net.ReadTable()
		local hud_profiles = net.ReadTable()
		local PARENT = GetSettingsSite()
		if YRPPanelAlive(PARENT) then
			local GRP_HUD = YRPCreateD("YGroupBox", PARENT, YRP.ctr(1000), YRP.ctr(1600), YRP.ctr(20), YRP.ctr(20))
			GRP_HUD:SetText("LID_hud")
			function GRP_HUD:Paint(pw, ph)
				hook.Run("YGroupBoxPaint", self, pw, ph)
			end

			-- HUD Design
			local hud_design_bg = YRPCreateD("DPanel", nil, GRP_HUD:GetWide(), YRP.ctr(100), 0, 0)
			function hud_design_bg:Paint(pw, ph)
			end

			--
			local hud_design_header = YRPCreateD("DPanel", hud_design_bg, hud_design_bg:GetWide(), YRP.ctr(50), 0, 0)
			function hud_design_header:Paint(pw, ph)
				draw.SimpleText(YRP.trans("LID_design"), "DermaDefault", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			local hud_design_choice = YRPCreateD("DComboBox", hud_design_bg, hud_design_bg:GetWide(), YRP.ctr(50), 0, YRP.ctr(50))
			for i, design in pairs(HUDS) do
				local selected = false
				if design.name == setting.string_hud_design then
					selected = true
				end

				local name = design.name .. " by " .. design.author
				if tonumber(design.progress) < 100 then
					name = name .. " ( " .. design.progress .. "% " .. YRP.trans("LID_done") .. " )"
				end

				hud_design_choice:AddChoice(name, design.name, selected)
			end

			function hud_design_choice:OnSelect(panel, index, value)
				net.Start("nws_yrp_change_hud_design")
				net.WriteString(value)
				net.SendToServer()
			end

			GRP_HUD:AddItem(hud_design_bg)
			local hr = {}
			hr.h = YRP.ctr(16)
			hr.parent = GRP_HUD
			DHr(hr)
			-- HUD Customize
			function Customize()
				F8CloseSettings()
				local hudcustom = YRPCreateD("DFrame", nil, ScrW(), ScrH(), 0, 0)
				hudcustom:SetTitle("")
				--hudcustom:MakePopup()
				function hudcustom:Paint(pw, ph)
				end

				--draw.RoundedBox(0, 0, 0, pw, ph, Color( 0, 255, 0 ) )
				local editarea = YRPCreateD("DButton", hudcustom, ScW(), ScH(), 0, 0)
				editarea:SetText("")
				if BiggerThen16_9() then
					editarea:SetPos(PosX(), 0)
					editarea:SetWide(ScW())
				end

				editarea.hl = 5
				editarea["windows"] = {}
				editarea["settingswindows"] = {}
				function editarea:Paint(pw, ph)
					-- draw.SimpleText(table.Count(editarea["settingswindows"]), "DermaDefault", pw / 2, ph / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					if table.Count(editarea["settingswindows"]) == 0 then
						local cx, cy = input.GetCursorPos()
						if cur_delay < CurTime() then
							cur_delay = CurTime() + 0.1
							if cx ~= tx or cy ~= ty or input.IsMouseDown(MOUSE_FIRST) then
								tx = cx
								ty = cy
								visible = true
							else
								visible = false
							end
						end

						if visible then
							cur_alpha = cur_alpha + 12
						else
							cur_alpha = cur_alpha - 6
						end

						cur_alpha = math.Clamp(cur_alpha, 0, 255)
						-- X
						local count = 0
						for x = 0, ScW(), boxspace do
							local color = Color(255, 255, 255, 160)
							-- X L
							if count % self.hl == 0 and x < ScW() / 2 then
								color = Color(0, 0, 0, 160)
							end

							-- X R
							if count % self.hl == ScW() / boxspace % self.hl and x > ScW() / 2 then
								color = Color(0, 0, 0, 160)
							end

							-- X C
							if count % self.hl == ScW() / 2 / boxspace % self.hl then
								color = Color(0, 255, 0, 255)
							end

							-- X Center
							if ScW() / 2 == x then
								color = Color(0, 0, 255, 255)
							end

							color.a = cur_alpha
							draw.RoundedBox(0, x - 1, 0, 2, ph, color)
							count = count + 1
						end

						-- Y
						count = 0
						for y = 0, ScH(), boxspace do
							local color = Color(255, 255, 255, 160)
							-- Y U
							if count % self.hl == 0 and y < ScH() / 2 then
								color = Color(0, 0, 0, 160)
							end

							-- Y D
							if count % self.hl == ScH() / boxspace % self.hl and y > ScH() / 2 then
								color = Color(0, 0, 0, 160)
							end

							-- Y C
							if count % self.hl == ScH() / 2 / boxspace % self.hl then
								color = Color(0, 255, 0, 255)
							end

							-- Y Center
							if ScH() / 2 == y then
								color = Color(0, 0, 255, 255)
							end

							color.a = cur_alpha
							draw.RoundedBox(0, 0, y - 1, pw, 2, color)
							count = count + 1
						end
					else
						render.ClearStencil()
						render.SetStencilEnable(true)
						render.SetStencilWriteMask(99)
						render.SetStencilTestMask(99)
						render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
						render.SetStencilFailOperation(STENCILOPERATION_INCR)
						render.SetStencilPassOperation(STENCILOPERATION_KEEP)
						render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
						for i, window in pairs(editarea["windows"]) do
							for j, settingswindow in pairs(editarea["settingswindows"]) do
								if window.winset == settingswindow then
									local x, y = window:GetPos()
									local w, h = window:GetSize()
									local br = YRP.ctr(10)
									draw.RoundedBox(0, x - br, y - br, w + 2 * br, h + 2 * br, Color(255, 0, 0, 255))
								end
							end
						end

						render.SetStencilReferenceValue(1)
						render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NOTEQUAL)
						draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 254))
						render.SetStencilEnable(false)
					end
				end

				function AddElement(tab)
					local sw = lply:HudValue(tab.element, "SIZE_W")
					local sh = lply:HudValue(tab.element, "SIZE_H")
					local px = lply:HudValue(tab.element, "POSI_X")
					local py = lply:HudValue(tab.element, "POSI_Y")
					--YRP.msg( "note", "element: " .. tab.element " x: "..  px .. " y: " .. py .. " w: " .. sw .. " h: " .. sh)
					local win = YRPCreateD("DFrame", editarea, sw, sh, px, py)
					win:SetTitle("")
					win:SetDraggable(true)
					win:ShowCloseButton(false)
					win:SetSizable(true)
					win:SetMinWidth(10)
					win:SetMinHeight(10)
					win.saved = true
					win.w = win:GetWide()
					win.h = win:GetTall()
					win.visible = true
					table.insert(editarea["windows"], win)
					function win:Paint(pw, ph)
						if win.visible then
							-- Background
							draw.RoundedBox(0, 0, 0, pw, ph, Color(40, 40, 40, math.Clamp(cur_alpha, 0, 200)))
							-- Corner
							draw.RoundedBox(0, pw - YRP.ctr(8 + 16), ph - YRP.ctr(8 + 4), YRP.ctr(16), YRP.ctr(4), Color(255, 255, 255, cur_alpha))
							draw.RoundedBox(0, pw - YRP.ctr(8 + 4), ph - YRP.ctr(8 + 16), YRP.ctr(4), YRP.ctr(16), Color(255, 255, 255, cur_alpha))
							-- Center
							local w = YRP.ctr(16)
							local h = YRP.ctr(4)
							local space = YRP.ctr(8)
							draw.RoundedBox(0, space, ph / 2 - h / 2, w, h, Color(255, 255, 255, cur_alpha))
							draw.RoundedBox(0, pw / 2 - h / 2, space, h, w, Color(255, 255, 255, cur_alpha))
							draw.RoundedBox(0, pw - (space + w), ph / 2 - h / 2, w, h, Color(255, 255, 255, cur_alpha))
							draw.RoundedBox(0, pw / 2 - h / 2, ph - (space + w), h, w, Color(255, 255, 255, cur_alpha))
							-- Dragbar
							draw.RoundedBox(0, 0, 0, pw, YRP.ctr(50), Color(0, 0, 255, math.Clamp(cur_alpha, 0, 200)))
							-- Name
							draw.SimpleText(YRP.trans(tab.name), "DermaDefault", YRP.ctr(36 + 8 + 8), YRP.ctr(20), Color(255, 255, 255, cur_alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
							-- Border
							local tbr = {}
							tbr.r = 0
							tbr.w = pw
							tbr.h = ph
							tbr.x = 0
							tbr.y = 0
							tbr.color = Color(255, 255, 0, cur_alpha)
							HudBoxBr(tbr)
							local x, y = self:GetPos()
							local modx, mody = x % boxspace, y % boxspace
							if not self:IsDragging() or not self.saved then
								if x + self:GetWide() > ScW() + PosX() then
									self.saved = false
									win:SetPos(ScW() + PosX() - self:GetWide(), y)
								elseif x < PosX() then
									self.saved = false
									win:SetPos(PosX(), y)
								elseif y + self:GetTall() > ScH() then
									self.saved = false
									win:SetPos(x, ScH() - self:GetTall())
								elseif y < 0 then
									self.saved = false
									win:SetPos(x, 0)
								elseif modx ~= 0 or mody ~= 0 then
									self.saved = false
									x = x - modx
									y = y - mody
									win:SetPos(x, y)
								elseif not self.saved then
									self.saved = true
									local _x = (x - ScreenFix()) / ScW()
									net.Start("nws_yrp_update_hud_x")
									net.WriteString(tab.element)
									net.WriteFloat(_x)
									net.SendToServer()
									local _y = y / ScH()
									net.Start("nws_yrp_update_hud_y")
									net.WriteString(tab.element)
									net.WriteFloat(_y)
									net.SendToServer()
								end

								local psw = pw
								local psh = ph
								if self.w ~= self:GetWide() or self.h ~= self:GetTall() then
									psw = psw - psw % boxspace
									psh = psh - psh % boxspace
									if psw >= win:GetMinWidth() then
										win:SetWide(psw)
										local _w = psw / ScW()
										net.Start("nws_yrp_update_hud_w")
										net.WriteString(tab.element)
										net.WriteFloat(_w)
										net.SendToServer()
									end

									if psh >= win:GetMinHeight() then
										win:SetTall(psh)
										local _h = psh / ScH()
										net.Start("nws_yrp_update_hud_h")
										net.WriteString(tab.element)
										net.WriteFloat(_h)
										net.SendToServer()
									end

									self.w = self:GetWide()
									self.h = self:GetTall()
								end
							end
						end
					end

					win.setting = YRPCreateD("DButton", win, YRP.ctr(36), YRP.ctr(36), YRP.ctr(4), YRP.ctr(4))
					win.setting:SetText("")
					function win.setting:DoClick()
						net.Receive(
							"nws_yrp_get_hud_element_settings",
							function(le)
								if win then
									local eletab = net.ReadTable()
									local wx, wy = win:GetPos()
									win.visible = false
									win.winset = YRPCreateD("DFrame", nil, YRP.ctr(900), YRP.ctr(900), wx, wy)
									win.winset:MakePopup()
									win.winset:SetTitle("")
									win.winset:Center()
									table.insert(editarea["settingswindows"], win.winset)
									function win.winset:Paint(pw, ph)
										draw.RoundedBox(0, 0, 0, pw, ph, Color(40, 40, 40, 200))
										draw.SimpleText(YRP.trans(tab.name), "DermaDefault", YRP.ctr(50), YRP.ctr(25), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
										local x, y = self:GetPos()
										local mx, my = gui.MousePos()
										if input.IsMouseDown(MOUSE_FIRST) and (mx < x or mx > x + pw or my < y or my > y + ph) and YRPPanelAlive(win.winset.dpl) then
											local childrens = win.winset.dpl:GetItems()
											local open = false
											for i, item in pairs(childrens) do
												if item.cb ~= nil and item.cb:IsMenuOpen() then
													open = true
												end
											end

											if not open then
												win.winset:Close()
											end
										end

										if x + self:GetWide() > ScW() + PosX() then
											self:SetPos(ScW() + PosX() - self:GetWide(), y)
										elseif x < PosX() then
											self:SetPos(PosX(), y)
										elseif y + self:GetTall() > ScH() then
											self:SetPos(x, ScH() - self:GetTall())
										elseif y < 0 then
											self:SetPos(x, 0)
										elseif modx ~= 0 or mody ~= 0 then
											self:SetPos(x, y)
										end
									end

									function win.winset:OnRemove()
										if win.visible ~= nil then
											win.visible = true
										end

										table.RemoveByValue(editarea["settingswindows"], win.winset)
									end

									win.winset.dpl = YRPCreateD("DPanelList", win.winset, win.winset:GetWide() - YRP.ctr(20 + 20), win.winset:GetTall() - YRP.ctr(50 + 20 + 20), YRP.ctr(20), YRP.ctr(50 + 20))
									function win.winset:AddCheckBox(t)
										local line = YRPCreateD("DPanel", nil, YRP.ctr(400), YRP.ctr(50), 0, 0)
										function line:Paint(pw, ph)
											draw.SimpleText(YRP.trans(t.name), "DermaDefault", ph + YRP.ctr(20), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
										end

										local cb = YRPCreateD("DCheckBox", line, YRP.ctr(50), YRP.ctr(50), 0, 0)
										cb:SetValue(t.value)
										function cb:OnChange(bVal)
											net.Start("nws_yrp_update_hud_bool")
											net.WriteString(t.element)
											net.WriteString(t.art)
											net.WriteBool(bVal)
											net.SendToServer()
										end

										win.winset.dpl:AddItem(line)
									end

									function win.winset:AddTextPosition(t)
										local line = YRPCreateD("DPanel", nil, YRP.ctr(400), YRP.ctr(50), 0, 0)
										function line:Paint(pw, ph)
											draw.SimpleText(YRP.trans(t.name), "DermaDefault", ph + YRP.ctr(20), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
										end

										local btn = YRPCreateD("DButton", line, YRP.ctr(50), YRP.ctr(50), 0, 0)
										btn:SetText("")
										function btn:DoClick()
											local mx, my = gui.MousePos()
											local tp = YRPCreateD("DFrame", nil, YRP.ctr(300), YRP.ctr(350), mx, my)
											tp:SetTitle("")
											tp:MakePopup()
											function tp:Paint(pw, ph)
												draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 200))
												local x, y = self:GetPos()
												local modx2, mody2 = x % boxspace, y % boxspace
												if not self:IsDragging() then
													if x + self:GetWide() > ScW() + PosX() then
														self:SetPos(ScW() + PosX() - self:GetWide(), y)
													elseif x < PosX() then
														self:SetPos(PosX(), y)
													elseif y + self:GetTall() > ScH() then
														self:SetPos(x, ScH() - self:GetTall())
													elseif y < 0 then
														self:SetPos(x, 0)
													elseif modx2 ~= 0 or mody2 ~= 0 then
														x = x - modx2
														y = y - mody2
														self:SetPos(x, y)
													end
												end
											end

											for y = 0, 3 do
												for x = 0, 3 do
													--local id = x .. "," .. y
													local tp_btn = YRPCreateD("DButton", tp, YRP.ctr(100), YRP.ctr(100), x * YRP.ctr(100), y * YRP.ctr(100) + YRP.ctr(50))
													tp_btn:SetText("")
													function tp_btn:Paint(pw, ph)
														local bw = pw - YRP.ctr(8)
														local bh = ph - YRP.ctr(8)
														local bx = YRP.ctr(8) / 2
														local by = YRP.ctr(8) / 2
														local _w = bw - YRP.ctr(8)
														local _h = bh - YRP.ctr(8)
														local _x = bx + YRP.ctr(8) / 2
														local _y = by + YRP.ctr(8) / 2
														local _size = YRP.ctr(20)
														draw.RoundedBox(0, bx, by, bw, bh, Color(255, 255, 255, 255))
														draw.RoundedBox(_h / 2, _x + (_w - _size) / 2 * x, _y + (_h - _size) / 2 * y, _size, _size, Color(0, 0, 0, 255))
													end

													function tp_btn:DoClick()
														net.Start("nws_yrp_update_hud_text_position")
														net.WriteString(t.element)
														net.WriteInt(x, 4)
														net.WriteInt(y, 4)
														net.SendToServer()
														tp:Close()
													end
												end
											end
										end

										function btn:Paint(pw, ph)
											local color = Color(255, 255, 255, 255)
											if self:IsHovered() then
												color = Color(255, 255, 0, 255)
											end

											draw.RoundedBox(0, 0, 0, pw, ph, color)
											local ax = lply:HudValue(tab.element, "AX")
											local ay = lply:HudValue(tab.element, "AY")
											if ay == 3 then
												ay = 0
											elseif ay == 4 then
												ay = 2
											end

											local _w = pw - YRP.ctr(8)
											local _h = ph - YRP.ctr(8)
											local _x = YRP.ctr(8) / 2
											local _y = YRP.ctr(8) / 2
											local _size = YRP.ctr(20)
											draw.RoundedBox(_h / 2, _x + (_w - _size) / 2 * ax, _y + (_h - _size) / 2 * ay, _size, _size, Color(0, 0, 0, 255))
										end

										win.winset.dpl:AddItem(line)
									end

									function win.winset:AddComboBox(t)
										local line = YRPCreateD("DPanel", nil, YRP.ctr(400), YRP.ctr(50), 0, 0)
										function line:Paint(pw, ph)
											draw.SimpleText(YRP.trans(t.name), "DermaDefault", YRP.ctr(200 + 20), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
										end

										line.cb = YRPCreateD("DComboBox", line, YRP.ctr(200), YRP.ctr(50), 0, 0)
										line.cb:SetSortItems(false)
										for i, choice in pairs(t.choices) do
											local selected = false
											if choice == t.value then
												selected = true
											end

											line.cb:AddChoice(choice, choice, selected)
										end

										function line.cb:OnSelect(index, value, data)
											net.Start("nws_yrp_update_hud_ts")
											net.WriteString(t.element)
											net.WriteInt(data, 8)
											net.SendToServer()
										end

										win.winset.dpl:AddItem(line)
									end

									function win.winset:AddColorMixer(t)
										local line = YRPCreateD("DPanel", nil, YRP.ctr(400), YRP.ctr(50), 0, 0)
										function line:Paint(pw, ph)
											draw.SimpleText(YRP.trans(t.name), "DermaDefault", ph + YRP.ctr(20), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
										end

										t.color = lply:HudValue(t.element, t.art)
										local btn = YRPCreateD("DButton", line, YRP.ctr(50), YRP.ctr(50), 0, 0)
										btn:SetText("")
										function btn:Paint(pw, ph)
											draw.RoundedBox(ph / 2, 0, 0, pw, ph, t.color)
										end

										function btn:DoClick()
											-- ColorMixer
											local cmwin = YRPCreateD("DFrame", nil, YRP.ctr(400 + 20 + 20), YRP.ctr(450 + 20 + 20), 0, 0)
											cmwin:SetTitle("")
											cmwin:Center()
											cmwin:MakePopup()
											function cmwin:Paint(pw, ph)
												local x, y = self:GetPos()
												local mx, my = gui.MousePos()
												if input.IsMouseDown(MOUSE_FIRST) and (mx < x or mx > x + pw or my < y or my > y + ph) then
													cmwin:Close()
												end
											end

											cmwin.cm = YRPCreateD("DColorMixer", cmwin, YRP.ctr(400), YRP.ctr(400), YRP.ctr(20), YRP.ctr(50 + 20))
											cmwin.cm:SetColor(t.color)
											function cmwin.cm:ValueChanged(col)
												t.color = col
												net.Start("nws_yrp_update_hud_color")
												net.WriteString(t.element)
												net.WriteString(t.art)
												net.WriteString("" .. col.r .. "," .. col.g .. "," .. col.b .. "," .. col.a .. "")
												net.SendToServer()
											end
										end

										win.winset.dpl:AddItem(line)
									end

									function win.winset:AddTextBox(t)
										local line = YRPCreateD("DPanel", nil, YRP.ctr(500), YRP.ctr(50), 0, 0)
										function line:Paint(pw, ph)
											draw.SimpleText(YRP.trans(t.name), "DermaDefault", YRP.ctr(420), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
										end

										local cb = YRPCreateD("DTextEntry", line, YRP.ctr(400), YRP.ctr(50), 0, 0)
										cb:SetText(t.value)
										function cb:OnTextChanged()
											net.Start("nws_yrp_update_hud_text")
											net.WriteString(t.element)
											net.WriteString(self:GetText())
											net.SendToServer()
										end

										win.winset.dpl:AddItem(line)
									end

									local visi = {}
									visi.name = "LID_visible"
									visi.element = tab.element
									visi.art = "VISI"
									visi.value = eletab["bool_HUD_" .. tab.element .. "_VISI"]
									win.winset:AddCheckBox(visi)
									local roun = {}
									roun.name = "LID_rounded"
									roun.element = tab.element
									roun.art = "ROUN"
									roun.value = eletab["bool_HUD_" .. tab.element .. "_ROUN"]
									win.winset:AddCheckBox(roun)
									local icon = {}
									icon.name = "LID_icon"
									icon.element = tab.element
									icon.art = "ICON"
									icon.value = eletab["bool_HUD_" .. tab.element .. "_ICON"]
									win.winset:AddCheckBox(icon)
									local text = {}
									text.name = "LID_text"
									text.element = tab.element
									text.art = "TEXT"
									text.value = eletab["bool_HUD_" .. tab.element .. "_TEXT"]
									win.winset:AddCheckBox(text)
									local perc = {}
									perc.name = "LID_percentage"
									perc.element = tab.element
									perc.art = "PERC"
									perc.value = eletab["bool_HUD_" .. tab.element .. "_PERC"]
									win.winset:AddCheckBox(perc)
									local back = {}
									back.name = "LID_background"
									back.element = tab.element
									back.art = "BACK"
									back.value = eletab["bool_HUD_" .. tab.element .. "_BACK"]
									win.winset:AddCheckBox(back)
									local bord = {}
									bord.name = "LID_border"
									bord.element = tab.element
									bord.art = "BORD"
									bord.value = eletab["bool_HUD_" .. tab.element .. "_BORD"]
									win.winset:AddCheckBox(bord)
									local extr = {}
									extr.name = "LID_extra"
									extr.element = tab.element
									extr.art = "EXTR"
									extr.value = eletab["bool_HUD_" .. tab.element .. "_EXTR"]
									win.winset:AddCheckBox(extr)
									local textposi = {}
									textposi.name = "LID_textposition"
									textposi.element = tab.element
									win.winset:AddTextPosition(textposi)
									local textsize = {}
									textsize.name = "LID_textsize"
									textsize.element = tab.element
									textsize.choices = GetFontSizeTable()
									textsize.value = lply:HudValue(tab.element, "TS")
									win.winset:AddComboBox(textsize)
									local colorbar = {}
									colorbar.name = "LID_barcolor"
									colorbar.element = tab.element
									colorbar.art = "BA"
									win.winset:AddColorMixer(colorbar)
									local colortext = {}
									colortext.name = "LID_textcolor"
									colortext.element = tab.element
									colortext.art = "TE"
									win.winset:AddColorMixer(colortext)
									local colortextborder = {}
									colortextborder.name = "LID_textbordercolor"
									colortextborder.element = tab.element
									colortextborder.art = "TB"
									win.winset:AddColorMixer(colortextborder)
									local colorbackground = {}
									colorbackground.name = "LID_backgroundcolor"
									colorbackground.element = tab.element
									colorbackground.art = "BG"
									win.winset:AddColorMixer(colorbackground)
									local colorborder = {}
									colorborder.name = "LID_bordercolor"
									colorborder.element = tab.element
									colorborder.art = "BR"
									win.winset:AddColorMixer(colorborder)
									if eletab["text_HUD_" .. tab.element .. "_CTEX"] then
										local text2 = {}
										text2.name = "LID_text"
										text2.element = tab.element
										text2.art = "text"
										text2.value = eletab["text_HUD_" .. tab.element .. "_CTEX"]
										win.winset:AddTextBox(text2)
									end
								end
							end
						)

						if table.Count(editarea["settingswindows"]) == 0 then
							net.Start("nws_yrp_get_hud_element_settings")
							--net.WriteString(tab.element)
							net.SendToServer()
						end
					end

					function win.setting:Paint(pw, ph)
						if win.visible then
							local color = Color(255, 255, 255, cur_alpha)
							if self:IsHovered() then
								color = Color(255, 255, 0, cur_alpha)
							end

							draw.RoundedBox(ph / 2, 0, 0, pw, ph, color)
							YRP.DrawIcon(YRP.GetDesignIcon("settings"), ph - YRP.ctr(4), ph - YRP.ctr(4), YRP.ctr(2), YRP.ctr(2), Color(0, 0, 0, cur_alpha))
						end
					end

					win:MakePopup()

					return win
				end

				for i = 1, 10 do
					local BOX = {}
					BOX.element = "BOX" .. i
					BOX.name = YRP.trans("LID_box") .. " " .. i
					AddElement(BOX)
				end

				local AV = {}
				AV.element = "AV"
				AV.name = "LID_avatar"
				AddElement(AV)
				local PM = {}
				PM.element = "PM"
				PM.name = "LID_model"
				AddElement(PM)
				local CR = {}
				CR.element = "CR"
				CR.name = "LID_realtime"
				AddElement(CR)
				local CC = {}
				CC.element = "CC"
				CC.name = "LID_playtime"
				AddElement(CC)
				local HP = {}
				HP.element = "HP"
				HP.name = "LID_healthbar"
				AddElement(HP)
				local AR = {}
				AR.element = "AR"
				AR.name = "LID_armorbar"
				AddElement(AR)
				local XP = {}
				XP.element = "XP"
				XP.name = "LID_experiencebar"
				AddElement(XP)
				local MO = {}
				MO.element = "MO"
				MO.name = "LID_moneybar"
				AddElement(MO)
				local SA = {}
				SA.element = "SA"
				SA.name = "LID_salary"
				AddElement(SA)
				local RO = {}
				RO.element = "RO"
				RO.name = "LID_rolename"
				AddElement(RO)
				local ST = {}
				ST.element = "ST"
				ST.name = "LID_staminabar"
				AddElement(ST)
				local CH = {}
				CH.element = "CH"
				CH.name = "LID_chatbox"
				AddElement(CH)
				local HU = {}
				HU.element = "HU"
				HU.name = "LID_hungerbar"
				AddElement(HU)
				local TH = {}
				TH.element = "TH"
				TH.name = "LID_thirstbar"
				AddElement(TH)
				local AL = {}
				AL.element = "AL"
				AL.name = "LID_permille"
				AddElement(AL)
				local CA = {}
				CA.element = "CA"
				CA.name = "LID_castbar"
				AddElement(CA)
				local AB = {}
				AB.element = "AB"
				AB.name = "LID_abilitybar"
				AddElement(AB)
				local WP = {}
				WP.element = "WP"
				WP.name = "LID_weaponprimarybar"
				AddElement(WP)
				local WS = {}
				WS.element = "WS"
				WS.name = "LID_weaponsecondarybar"
				AddElement(WS)
				local WN = {}
				WN.element = "WN"
				WN.name = "LID_weaponnamebar"
				AddElement(WN)
				local BA = {}
				BA.element = "BA"
				BA.name = "LID_batterybar"
				AddElement(BA)
				local CON = {}
				CON.element = "CON"
				CON.name = "LID_conditionbar"
				AddElement(CON)
				local PE = {}
				PE.element = "PE"
				PE.name = "LID_performance"
				AddElement(PE)
				local NE = {}
				NE.element = "NE"
				NE.name = "LID_network"
				AddElement(NE)
				local COM = {}
				COM.element = "COM"
				COM.name = "LID_compass"
				AddElement(COM)
				local LO = {}
				LO.element = "LO"
				LO.name = "LID_lockdown"
				AddElement(LO)
				local NA = {}
				NA.element = "NA"
				NA.name = "LID_name"
				AddElement(NA)
				local ID = {}
				ID.element = "ID"
				ID.name = "LID_id"
				AddElement(ID)
				local SL = {}
				SL.element = "SL"
				SL.name = "LID_serverlogo"
				AddElement(SL)
				local SN = {}
				SN.element = "SN"
				SN.name = "LID_hostname"
				AddElement(SN)
				local RA = {}
				RA.element = "RA"
				RA.name = "LID_radiation"
				AddElement(RA)
				local VO = {}
				VO.element = "VO"
				VO.name = "LID_voice"
				AddElement(VO)
				function editarea:DoClick()
					if table.Count(editarea["settingswindows"]) == 0 then
						for i, child in pairs(self:GetChildren()) do
							child:Close()
						end

						hudcustom:Close()
					else
						for i, window in pairs(editarea["settingswindows"]) do
							window:Remove()
						end
					end
				end
			end

			--, 12, 16, 20}
			local gridsizes = {10}
			for i, size in pairs(gridsizes) do
				local hud_x = YRPCreateD("DButton", nil, GRP_HUD:GetWide(), YRP.ctr(50), 0, YRP.ctr(50))
				hud_x:SetText("")
				function hud_x:Paint(pw, ph)
					local color = Color(255, 255, 255, 255)
					if self:IsHovered() then
						color = Color(255, 255, 100)
					end

					draw.RoundedBox(0, 0, 0, pw, ph, color)
					draw.SimpleText(YRP.trans("LID_customize") .. " ( " .. YRP.trans("LID_gridsize") .. " " .. size .. " )", "DermaDefault", pw / 2, ph / 2, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end

				function hud_x:DoClick()
					boxspace = YRP.ctr(size)
					Customize()
				end

				GRP_HUD:AddItem(hud_x)
			end

			DHr(hr)
			local lbl_profiles = YRPCreateD("YLabel", nil, YRP.ctr(100), YRP.ctr(50), 0, 0)
			lbl_profiles:SetText("LID_profile")
			GRP_HUD:AddItem(lbl_profiles)
			local cb_profiles = YRPCreateD("DComboBox", nil, YRP.ctr(100), YRP.ctr(50), 0, 0)
			GRP_HUD:AddItem(cb_profiles)
			for i, v in pairs(hud_profiles) do
				local selected = false
				if GetGlobalYRPString("string_hud_profile", "") == v.value then
					selected = true
				end

				cb_profiles:AddChoice(v.value, v.value, selected)
			end

			function cb_profiles:OnSelect(index, text, data)
				local profile_name = data
				net.Start("nws_yrp_change_to_hud_profile")
				net.WriteString(profile_name)
				net.SendToServer()
			end

			-- HUD Reset Settings
			local hud_reset_settings = YRPCreateD("DButton", nil, GRP_HUD:GetWide(), YRP.ctr(50), 0, YRP.ctr(50))
			hud_reset_settings:SetText("")
			function hud_reset_settings:Paint(pw, ph)
				local color = Color(255, 255, 255, 255)
				if self:IsHovered() then
					color = Color(255, 255, 100)
				end

				draw.RoundedBox(0, 0, 0, pw, ph, color)
				draw.SimpleText(YRP.trans("LID_settodefault"), "DermaDefault", pw / 2, ph / 2, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			function hud_reset_settings:DoClick()
				F8CloseSettings()
				function YesFunction()
					net.Start("nws_yrp_reset_hud_settings")
					net.SendToServer()
				end

				YRPAreYouSure(YesFunction)
			end

			GRP_HUD:AddItem(hud_reset_settings)
			local GRP_IF = YRPCreateD("YGroupBox", PARENT, YRP.ctr(1000), YRP.ctr(1600), YRP.ctr(20 + 1000 + 20), YRP.ctr(20))
			GRP_IF:SetText("LID_interface")
			function GRP_IF:Paint(pw, ph)
				hook.Run("YGroupBoxPaint", self, pw, ph)
			end

			GRP_IF.cif = {}
			-- IF Design
			local if_font_bg = YRPCreateD("DPanel", nil, GRP_IF:GetWide(), YRP.ctr(100), 0, 0)
			function if_font_bg:Paint(pw, ph)
			end

			--
			local if_font_header = YRPCreateD("DPanel", if_font_bg, if_font_bg:GetWide(), YRP.ctr(50), 0, 0)
			function if_font_header:Paint(pw, ph)
				draw.SimpleText(YRP.trans("LID_font"), "DermaDefault", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			local if_font_choice = YRPCreateD("DComboBox", if_font_bg, if_font_bg:GetWide(), YRP.ctr(50), 0, YRP.ctr(50))
			for i, fo in pairs(YRP.GetFonts()) do
				local selected = false
				if fo.name == YRP.GetFont() then
					selected = true
				end

				local name = fo.name
				if_font_choice:AddChoice(name, name, selected)
			end

			function if_font_choice:OnSelect(panel, index, value)
				net.Start("nws_yrp_update_font")
				net.WriteString(value)
				net.SendToServer()
			end

			GRP_IF:AddItem(if_font_bg)
			local if_design_bg = YRPCreateD("DPanel", nil, GRP_IF:GetWide(), YRP.ctr(100), 0, 0)
			function if_design_bg:Paint(pw, ph)
			end

			--
			local if_design_header = YRPCreateD("DPanel", if_design_bg, if_design_bg:GetWide(), YRP.ctr(50), 0, 0)
			function if_design_header:Paint(pw, ph)
				draw.SimpleText(YRP.trans("LID_design"), "DermaDefault", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			local if_design_choice = YRPCreateD("DComboBox", if_design_bg, if_design_bg:GetWide(), YRP.ctr(50), 0, YRP.ctr(50))
			for i, design in pairs(INTERFACES) do
				local selected = false
				if design.name == setting.string_interface_design then
					selected = true
					net.Start("nws_yrp_get_interface_settings")
					net.WriteString(design.name)
					net.SendToServer()
				end

				local name = design.name .. " by " .. design.author
				if tonumber(design.progress) < 100 then
					name = name .. " ( " .. design.progress .. "% " .. YRP.trans("LID_done") .. " )"
				end

				if_design_choice:AddChoice(name, design.name, selected)
			end

			function if_design_choice:OnSelect(panel, index, value)
				net.Start("nws_yrp_change_interface_design")
				net.WriteString(value)
				net.SendToServer()
				net.Start("nws_yrp_get_interface_settings")
				net.WriteString(value)
				net.SendToServer()
			end

			GRP_IF:AddItem(if_design_bg)
			local spacer = YRPCreateD("DPanel", nil, if_design_bg:GetWide(), YRP.ctr(50), 0, 0)
			function spacer:Paint(pw, ph)
			end

			--
			GRP_IF:AddItem(spacer)
			net.Receive(
				"nws_yrp_get_interface_settings",
				function(le)
					if YRPPanelAlive(GRP_IF) then
						for i, ele in pairs(GRP_IF.cif) do
							ele:Remove()
						end

						-- HeaderHeight
						local if_hh = YRPCreateD("DYRPNumberWang", nil, YRP.ctr(800), YRP.ctr(100), 0, YRP.ctr(600))
						if_hh:SetHeader(YRP.trans("LID_headerheight"))
						if_hh.numberwang:SetMin(50)
						if_hh.numberwang:SetMax(150)
						if_hh.numberwang:SetValue(GetGlobalYRPInt("int_headerheight", 100))
						function if_hh.numberwang:OnValueChanged(val)
							val = tonumber(val)
							val = math.Clamp(val, 50, 150)
							net.Start("nws_yrp_change_headerheight")
							net.WriteString(val)
							net.SendToServer()
						end

						table.insert(GRP_IF.cif, if_hh)
						GRP_IF:AddItem(if_hh)
						local reset_interface = YRPCreateD("YButton", nil, YRP.ctr(100), YRP.ctr(50), 0, 0)
						reset_interface:SetText("LID_reset")
						function reset_interface:DoClick()
							net.Start("nws_yrp_reset_interface_design")
							net.SendToServer()
						end

						function reset_interface:Paint(pw, ph)
							local tab = {}
							tab.color = Color(0, 255, 0)
							hook.Run("YButtonPaint", self, pw, ph, tab)
						end

						table.insert(GRP_IF.cif, reset_interface)
						GRP_IF:AddItem(reset_interface)
						local iftab = net.ReadTable()
						for i, ift in pairs(iftab) do
							if string.find(ift.name, "color", 1, true) then
								local _start, _end = string.find(ift.name, "_Y", 1, true)
								if _start then
									local name = "LID_" .. string.lower("color_" .. string.sub(ift.name, _start + 1))
									local color = StringToColor(ift.value)
									local ycol = YRPCreateD("DPanel", nil, YRP.ctr(200), YRP.ctr(50), 0, 0)
									function ycol:Paint(pw, ph)
										draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
										draw.SimpleText(YRP.trans(name), "DermaDefault", ph + YRP.ctr(20), ph / 2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
									end

									ycol.cm = YRPCreateD("YColorMenuButton", ycol, YRP.ctr(50), YRP.ctr(50), 0, 0)
									ycol.cm:SetColor(color)
									function ycol.cm:ColorChanged(col)
										net.Start("nws_yrp_update_interface_color")
										net.WriteString(ift.name)
										net.WriteString(YRPColorToString(col))
										net.SendToServer()
									end

									table.insert(GRP_IF.cif, ycol)
									GRP_IF:AddItem(ycol)
								else
									local _s, _e = string.find(ift.name, "Chat", 1, true)
									local name = string.sub(ift.name, _s)
									local color = StringToColor(ift.value)
									local ycol = YRPCreateD("DPanel", nil, YRP.ctr(200), YRP.ctr(50), 0, 0)
									function ycol:Paint(pw, ph)
										draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
										draw.SimpleText(YRP.trans(name), "DermaDefault", ph + YRP.ctr(20), ph / 2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
									end

									ycol.cm = YRPCreateD("YColorMenuButton", ycol, YRP.ctr(50), YRP.ctr(50), 0, 0)
									ycol.cm:SetColor(color)
									function ycol.cm:ColorChanged(col)
										net.Start("nws_yrp_update_interface_color")
										net.WriteString(ift.name)
										net.WriteString(YRPColorToString(col))
										net.SendToServer()
									end

									table.insert(GRP_IF.cif, ycol)
									GRP_IF:AddItem(ycol)
								end
							end
						end
					end
				end
			)

			local pv_win = YRPCreateD("YFrame", PARENT, YRP.ctr(1000), YRP.ctr(1000), ScrW() - YRP.ctr(1000 + 20), YRP.ctr(120))
			pv_win:SetTitle("LID_window")
			function pv_win:Paint(pw, ph)
				hook.Run("YFramePaint", self, pw, ph)
				self:MoveToFront()
			end

			pv_win:SetHeaderHeight(YRP.ctr(100))
			pv_win:MakePopup()
			local pv_btn = YRPCreateD("YButton", pv_win:GetContent(), YRP.ctr(300), YRP.ctr(100), YRP.ctr(20), YRP.ctr(20))
			pv_btn:SetText("LID_button")
			function pv_btn:Paint(pw, ph)
				local tab = {}
				tab.text = YRP.trans(self:GetText())
				if self:IsDown() then
					tab.text = tab.text .. " ( " .. YRP.trans("LID_pressed") .. " )"
				elseif self:IsHovered() then
					tab.text = tab.text .. " ( " .. YRP.trans("LID_hovered") .. " )"
				end

				hook.Run("YButtonPaint", self, pw, ph, tab)
			end

			local pv_lbl = YRPCreateD("YLabel", pv_win:GetContent(), YRP.ctr(300), YRP.ctr(100), YRP.ctr(20 + 300 + 20), YRP.ctr(20))
			pv_lbl:SetText("LID_label")
			function pv_lbl:Paint(pw, ph)
				hook.Run("YLabelPaint", self, pw, ph)
			end

			local pv_add = YRPCreateD("YButton", pv_win:GetContent(), YRP.ctr(80), YRP.ctr(80), YRP.ctr(20), YRP.ctr(20 + 80 + 20 + 20))
			pv_add:SetText("LID_button")
			function pv_add:Paint(pw, ph)
				hook.Run("YAddPaint", self, pw, ph)
			end

			local pv_remove = YRPCreateD("YButton", pv_win:GetContent(), YRP.ctr(80), YRP.ctr(80), YRP.ctr(20 + 80 + 20), YRP.ctr(20 + 80 + 20 + 20))
			pv_remove:SetText("LID_button")
			function pv_remove:Paint(pw, ph)
				hook.Run("YRemovePaint", self, pw, ph)
			end

			local pv_groupbox = YRPCreateD("YGroupBox", pv_win:GetContent(), YRP.ctr(400), YRP.ctr(400), YRP.ctr(20), YRP.ctr(20 + 80 + 20 + 80 + 20 + 20))
			pv_groupbox:SetText("LID_groupbox")
			function pv_groupbox:Paint(pw, ph)
				hook.Run("YGroupBoxPaint", self, pw, ph)
			end
		end
	end
)

function OpenSettingsDesign()
	net.Start("nws_yrp_get_design_settings")
	net.SendToServer()
end