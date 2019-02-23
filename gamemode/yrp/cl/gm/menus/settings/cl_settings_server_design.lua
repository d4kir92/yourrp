--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local boxspace = ctr(20)

local Player = FindMetaTable("Player")
function Player:GetHudVal(element, art)
	local dbval = nil
	dbval = self:GetNWFloat("float_HUD_" .. element .. "_" .. art, -1.0)

	local ret = dbval

	if art == "POSI_X" or  art == "SIZE_W" then
		ret = ret * ScW()
	else
		ret = ret * ScH()
	end

	if art == "POSI_X" and BiggerThen16_9() then
		ret = ret + PosX()
	end
	return math.Round(ret, 0)
end

function Player:GetHudValue(element, art)
	return self:GetHudVal(element, art)
end

function Player:GetHudColor(element, art)
	local dbval = self:GetNWString("color_HUD_" .. element .. "_" .. art, "255, 0, 0")
	local ret = string.Explode(",", dbval)
	return Color(ret[1], ret[2], ret[3], ret[4] or 255)
end

function Player:GetHudInt(element, art)
	local dbval = self:GetNWInt("int_HUD_" .. element .. "_" .. art, -1)
	return tonumber(dbval)
end

function Player:GetHudBool(element, art)
	return self:GetNWBool("bool_HUD_" .. element .. "_" .. art, false)
end

net.Receive("get_design_settings", function(len)
	local lply = LocalPlayer()
	local setting = net.ReadTable()
	local HUDS = net.ReadTable()
	local INTERFACES = net.ReadTable()

	if pa(settingsWindow.window) then
		settingsWindow.window.site:SetWide(ctr(20 + 1000 + 20 + 1000 + 20))
		function settingsWindow.window.site:Paint(pw, ph)
			surfaceBox(0, 0, pw, ph, Color(0, 0, 0, 254))
		end

		local Parent = settingsWindow.window.site
		local GRP_HUD = {}
		GRP_HUD.parent = Parent
		GRP_HUD.x = ctr(20)
		GRP_HUD.y = ctr(20)
		GRP_HUD.w = ctr(1000)
		GRP_HUD.h = ctr(530)
		GRP_HUD.br = ctr(20)
		GRP_HUD.color = Color(255, 255, 255)
		GRP_HUD.bgcolor = Color(80, 80, 80)
		GRP_HUD.name = "LID_hud"
		GRP_HUD = DGroup(GRP_HUD)

		-- HUD Design
		local hud_design_bg = createD("DPanel", nil, GRP_HUD:GetWide(), ctr(100), 0, 0)
		function hud_design_bg:Paint(pw, ph)
			--
		end
		local hud_design_header = createD("DPanel", hud_design_bg, hud_design_bg:GetWide(), ctr(50), 0, 0)
		function hud_design_header:Paint(pw, ph)
			draw.SimpleText(YRP.lang_string("LID_design"), "DermaDefault", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		local hud_design_choice = createD("DComboBox", hud_design_bg, hud_design_bg:GetWide(), ctr(50), 0, ctr(50))
		for i, design in pairs(HUDS) do
			local selected = false
			if design.name == setting.string_hud_design then
				selected = true
			end
			local name = design.name .. " by " .. design.author
			if tonumber(design.progress) < 100 then
				name = name .. " (" .. design.progress .. "% " .. YRP.lang_string("LID_done") .. ")"
			end
			hud_design_choice:AddChoice(name, design.name, selected)
		end
		function hud_design_choice:OnSelect(panel, index, value)
			net.Start("change_hud_design")
				net.WriteString(value)
			net.SendToServer()
		end
		GRP_HUD:AddItem(hud_design_bg)

		local hr = {}
		hr.h = ctr(16)
		hr.parent = GRP_HUD
		DHr(hr)

		-- HUD Customize
		local hud_customize_btn = createD("DButton", nil, GRP_HUD:GetWide(), ctr(50), 0, ctr(50))
		hud_customize_btn:SetText("")
		function hud_customize_btn:Paint(pw, ph)
			local color = Color(255, 255, 255)
			if self:IsHovered() then
				color = Color(255, 255, 100)
			end
			draw.RoundedBox(0, 0, 0, pw, ph, color)
			draw.SimpleText(YRP.lang_string("LID_customize"), "DermaDefault", pw / 2, ph / 2, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		function hud_customize_btn:DoClick()
			CloseSettings()

			local hudcustom = createD("DFrame", nil, ScrW(), ScrH(), 0, 0)
			hudcustom:SetTitle("")
			--hudcustom:MakePopup()
			function hudcustom:Paint(pw, ph)
				--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 0, 0))
			end

			local editarea = createD("DButton", hudcustom, ScW(), ScH(), 0, 0)
			editarea:SetText("")
			if BiggerThen16_9() then
				editarea:SetPos(PosX(), 0)
				editarea:SetWide(ScW())
			end
			editarea.space = boxspace
			editarea.hl = 5
			editarea["windows"] = {}
			editarea["settingswindows"] = {}
			function editarea:Paint(pw, ph)
				-- draw.SimpleText(table.Count(editarea["settingswindows"]), "DermaDefault", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				if table.Count(editarea["settingswindows"]) == 0 then
					-- X
					local count = 0
					for x = 0, ScW(), self.space do
						local color = Color(255, 255, 255, 160)

						-- X L
						if count % self.hl == 0 and x < ScW() / 2 then
							color = Color(0, 0, 0, 160)
						end

						-- X R
						if count % self.hl == ScW() / self.space % self.hl and x > ScW() / 2 then
							color = Color(0, 0, 0, 160)
						end

						-- X C
						if count % self.hl == ScW() / 2 / self.space % self.hl then
							color = Color(0, 255, 0, 255)
						end

						-- X Center
						if ScW() / 2 == x then
							color = Color(0, 0, 255, 255)
						end

						draw.RoundedBox(0, x-1, 0, 2, ph, color)
						count = count + 1
					end

					-- Y
					count = 0
					for y = 0, ScH(), self.space do
						local color = Color(255, 255, 255, 160)

						-- Y U
						if count % self.hl == 0 and y < ScH() / 2 then
							color = Color(0, 0, 0, 160)
						end

						-- Y D
						if count % self.hl == ScH() / self.space % self.hl and y > ScH() / 2 then
							color = Color(0, 0, 0, 160)
						end

						-- Y C
						if count % self.hl == ScH() / 2 / self.space % self.hl then
							color = Color(0, 255, 0, 255)
						end

						-- Y Center
						if ScH() / 2 == y then
							color = Color(0, 0, 255, 255)
						end

						draw.RoundedBox(0, 0, y-1, pw, 2, color)
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

								local br = ctr(10)
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
				local sw = lply:GetHudVal(tab.element, "SIZE_W")
				local sh = lply:GetHudVal(tab.element, "SIZE_H")
				local px = lply:GetHudVal(tab.element, "POSI_X")
				local py = lply:GetHudVal(tab.element, "POSI_Y")
				local win = createD("DFrame", editarea, sw, sh, px, py)
				win:SetTitle("")
				win:SetDraggable(true)
				win:ShowCloseButton(false)
				win:SetSizable(true)
				win:SetMinWidth(10)
				win:SetMinHeight(10)
				win.saved = false
				win.w = win:GetWide()
				win.h = win:GetTall()
				win.visible = true
				table.insert(editarea["windows"], win)
				function win:Paint(pw, ph)
					if win.visible then
						local alpha = 255
						if table.Count(editarea["settingswindows"]) > 0 then
							alpha = 100
						end
						-- Background
						draw.RoundedBox(0, 0, 0, pw, ph, Color(40, 40, 40, alpha-40))

						-- Corner
						draw.RoundedBox(0, pw - ctr(8 + 16), ph - ctr(8 + 4), ctr(16), ctr(4), Color(255, 255, 255, alpha))
						draw.RoundedBox(0, pw - ctr(8 + 4), ph - ctr(8 + 16), ctr(4), ctr(16), Color(255, 255, 255, alpha))

						-- Center
						local w = ctr(16)
						local h = ctr(4)
						local space = ctr(8)
						draw.RoundedBox(0, space, ph / 2 - h / 2, w, h, Color(255, 255, 255, alpha))
						draw.RoundedBox(0, pw / 2 - h / 2, space, h, w, Color(255, 255, 255, alpha))
						draw.RoundedBox(0, pw - (space + w), ph / 2 - h / 2, w, h, Color(255, 255, 255, alpha))
						draw.RoundedBox(0, pw / 2 - h / 2, ph - (space + w), h, w, Color(255, 255, 255, alpha))

						-- Dragbar
						draw.RoundedBox(0, 0, 0, pw, ctr(50), Color(0, 0, 255, alpha - 40))

						-- Name
						draw.SimpleText(YRP.lang_string(tab.name), "DermaDefault", ctr(36 + 8 + 8), ctr(20), Color(255, 255, 255, alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

						-- Border
						local tbr = {}
						tbr.r = 0
						tbr.w = pw
						tbr.h = ph
						tbr.x = 0
						tbr.y = 0
						tbr.color = Color(255, 255, 0, alpha)
						HudBoxBr(tbr)

						local x, y = self:GetPos()
						local modx, mody = x % boxspace, y % boxspace

						if !self:IsDragging() or !self.saved then
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
							elseif modx != 0 or mody != 0 then
								self.saved = false
								x = x - modx
								y = y - mody
								win:SetPos(x, y)
							elseif !self.saved then
								self.saved = true
								local _x = (x - ScreenFix()) / ScW()
								net.Start("update_hud_x")
									net.WriteString(tab.element)
									net.WriteFloat(_x)
								net.SendToServer()

								local _y = y / ScH()
								net.Start("update_hud_y")
									net.WriteString(tab.element)
									net.WriteFloat(_y)
								net.SendToServer()
							end

							local w = pw
							local h = ph
							if self.w != self:GetWide() or self.h != self:GetTall() then

								w = w - w % boxspace
								h = h - h % boxspace
								if w >= win:GetMinWidth() then
									win:SetWide(w)

									local _w = w / ScW()
									net.Start("update_hud_w")
										net.WriteString(tab.element)
										net.WriteFloat(_w)
									net.SendToServer()
								end

								if h >= win:GetMinHeight() then
									win:SetTall(h)

									local _h = h / ScH()
									net.Start("update_hud_h")
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

				win.setting = createD("DButton", win, ctr(36), ctr(36), ctr(4), ctr(4))
				win.setting:SetText("")
				function win.setting:DoClick()
					net.Receive("get_hud_element_settings", function(le)
						local eletab = net.ReadTable()
						local wx, wy = win:GetPos()

						win.visible = false

						win.winset = createD("DFrame", nil, ctr(800), ctr(800), wx, wy)
						win.winset:MakePopup()
						win.winset:SetTitle("")
						win.winset:Center()
						table.insert(editarea["settingswindows"], win.winset)
						function win.winset:Paint(pw, ph)
							draw.RoundedBox(0, 0, 0, pw, ph, Color(40, 40, 40, 200))
							draw.SimpleText(YRP.lang_string(tab.name), "DermaDefault", ctr(50), ctr(25), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

							local x, y = self:GetPos()
							local mx, my = gui.MousePos()
							if input.IsMouseDown(MOUSE_FIRST) then
								if mx < x or mx > x + pw or my < y or my > y + ph then
									local childrens = win.winset.dpl:GetItems()
									local open = false
									for i, item in pairs(childrens) do
										if item.cb != nil then
											if item.cb:IsMenuOpen() then
												open = true
											end
										end
									end
									if !open then
										win.winset:Close()
									end
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
							elseif modx != 0 or mody != 0 then
								self:SetPos(x, y)
							end
						end
						function win.winset:OnRemove()
							if win.visible != nil then
								win.visible = true
							end
							table.RemoveByValue(editarea["settingswindows"], win.winset)
						end

						win.winset.dpl = createD("DPanelList", win.winset, win.winset:GetWide() - ctr(20 + 20), win.winset:GetTall() - ctr(50 + 20 + 20), ctr(20), ctr(50 + 20))
						function win.winset:AddCheckBox(t)
							local line = createD("DPanel", nil, ctr(400), ctr(50), 0, 0)
							function line:Paint(pw, ph)
								draw.SimpleText(YRP.lang_string(t.name), "DermaDefault", ph + ctr(20), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
							end

							local cb = createD("DCheckBox", line, ctr(50), ctr(50), 0, 0)
							cb:SetValue(t.value)
							function cb:OnChange(bVal)
								net.Start("update_hud_bool")
									net.WriteString(t.element)
									net.WriteString(t.art)
									net.WriteBool(bVal)
								net.SendToServer()
							end

							win.winset.dpl:AddItem(line)
						end
						function win.winset:AddTextPosition(t)
							local line = createD("DPanel", nil, ctr(400), ctr(50), 0, 0)
							function line:Paint(pw, ph)
								draw.SimpleText(YRP.lang_string(t.name), "DermaDefault", ph + ctr(20), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
							end

							local btn = createD("DButton", line, ctr(50), ctr(50), 0, 0)
							btn:SetText("")
							function btn:DoClick()
								local mx, my = gui.MousePos()
								local tp = createD("DFrame", nil, ctr(300), ctr(350), mx, my)
								tp:SetTitle("")
								tp:MakePopup()
								function tp:Paint(pw, ph)
									draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 200))
									local x, y = self:GetPos()
									local modx, mody = x % boxspace, y % boxspace
									if !self:IsDragging() then
										if x + self:GetWide() > ScW() + PosX() then
											self:SetPos(ScW() + PosX() - self:GetWide(), y)
										elseif x < PosX() then
											self:SetPos(PosX(), y)
										elseif y + self:GetTall() > ScH() then
											self:SetPos(x, ScH() - self:GetTall())
										elseif y < 0 then
											self:SetPos(x, 0)
										elseif modx != 0 or mody != 0 then
											x = x - modx
											y = y - mody
											self:SetPos(x, y)
										end
									end
								end

								for y = 0, 3 do
									for x = 0, 3 do
										local id = x .. "," .. y
										local tp_btn = createD("DButton", tp, ctr(100), ctr(100), x * ctr(100), y * ctr(100) + ctr(50))
										tp_btn:SetText("")
										function tp_btn:Paint(pw, ph)
											local bw = pw - ctr(8)
											local bh = ph - ctr(8)
											local bx = ctr(8) / 2
											local by = ctr(8) / 2
											local _w = bw - ctr(8)
											local _h = bh - ctr(8)
											local _x = bx + ctr(8) / 2
											local _y = by + ctr(8) / 2
											local _size = ctr(20)
											draw.RoundedBox(0, bx, by, bw, bh, Color(255, 255, 255))
											draw.RoundedBox(_h / 2, _x + (_w - _size) / 2 * x, _y + (_h - _size) / 2 * y, _size, _size, Color(0, 0, 0))
										end
										function tp_btn:DoClick()
											net.Start("update_hud_text_position")
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
								local color = Color(255, 255, 255)
								if self:IsHovered() then
									color = Color(255, 255, 0, 255)
								end
								draw.RoundedBox(0, 0, 0, pw, ph, color)

								local ax = lply:GetHudInt(tab.element, "AX")
								local ay = lply:GetHudInt(tab.element, "AY")
								if ay == 3 then
									ay = 0
								elseif ay == 4 then
									ay = 2
								end
								local _w = pw - ctr(8)
								local _h = ph - ctr(8)
								local _x = ctr(8) / 2
								local _y = ctr(8) / 2
								local _size = ctr(20)
								draw.RoundedBox(_h / 2, _x + (_w - _size) / 2 * ax, _y + (_h - _size) / 2 * ay, _size, _size, Color(0, 0, 0))
							end

							win.winset.dpl:AddItem(line)
						end
						function win.winset:AddComboBox(t)
							local line = createD("DPanel", nil, ctr(400), ctr(50), 0, 0)
							function line:Paint(pw, ph)
								draw.SimpleText(YRP.lang_string(t.name), "DermaDefault", ctr(200 + 20), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
							end

							line.cb = createD("DComboBox", line, ctr(200), ctr(50), 0, 0)
							line.cb:SetSortItems(false)
							for i, choice in pairs(t.choices) do
								local selected = false
								if choice == t.value then
									selected = true
								end
								line.cb:AddChoice(choice, choice, selected)
							end
							function line.cb:OnSelect(index, value, data)
								net.Start("update_hud_ts")
									net.WriteString(t.element)
									net.WriteInt(data, 8)
								net.SendToServer()
							end

							win.winset.dpl:AddItem(line)
						end

						function win.winset:AddColorMixer(t)
							local line = createD("DPanel", nil, ctr(400), ctr(50), 0, 0)
							function line:Paint(pw, ph)
								draw.SimpleText(YRP.lang_string(t.name), "DermaDefault", ph + ctr(20), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
							end

							t.color = lply:GetHudColor(t.element, t.art)

							local btn = createD("DButton", line, ctr(50), ctr(50), 0, 0)
							btn:SetText("")
							function btn:Paint(pw, ph)
								draw.RoundedBox(ph / 2, 0, 0, pw, ph, t.color)
							end
							function btn:DoClick()
								-- ColorMixer
								local cmwin = createD("DFrame", nil, ctr(400 + 20 + 20), ctr(450 + 20 + 20), 0, 0)
								cmwin:SetTitle("")
								cmwin:Center()
								cmwin:MakePopup()
								function cmwin:Paint(pw, ph)
									local x, y = self:GetPos()
									local mx, my = gui.MousePos()
									if input.IsMouseDown(MOUSE_FIRST) then
										if mx < x or mx > x + pw or my < y or my > y + ph then
											cmwin:Close()
										end
									end
								end

								cmwin.cm = createD("DColorMixer", cmwin, ctr(400), ctr(400), ctr(20), ctr(50 + 20))
								cmwin.cm:SetColor(t.color)
								function cmwin.cm:ValueChanged(col)
									t.color = col
									net.Start("update_hud_color")
										net.WriteString(t.element)
										net.WriteString(t.art)
										net.WriteString("" .. col.r .. "," .. col.g .. "," .. col.b .. "," .. col.a .. "")
									net.SendToServer()
								end
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

						local textposi = {}
						textposi.name = "LID_textposition"
						textposi.element = tab.element
						win.winset:AddTextPosition(textposi)

						local textsize = {}
						textsize.name = "LID_textsize"
						textsize.element = tab.element
						textsize.choices = GetFontSizeTable()
						textsize.value = lply:GetHudInt(tab.element, "TS")
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
					end)
					if table.Count(editarea["settingswindows"]) == 0 then
						net.Start("get_hud_element_settings")
							net.WriteString(tab.element)
						net.SendToServer()
					end
				end
				function win.setting:Paint(pw, ph)
					if win.visible then
						local alpha = 255
						local color = Color(255, 255, 255, alpha)
						if self:IsHovered() then
							color = Color(255, 255, 0, alpha)
						end
						draw.RoundedBox(ph / 2, 0, 0, pw, ph, color)

						YRP.DrawIcon(YRP.GetDesignIcon("settings"), ph - ctr(4), ph - ctr(4), ctr(2), ctr(2), Color(0, 0, 0, alpha))
					end
				end

				win:MakePopup()
				return win
			end

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

			--[[
			local MI = {}
			MI.element = "MI"
			MI.name = "LID_minimap"
			AddElement(MI)
			]]--

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
		GRP_HUD:AddItem(hud_customize_btn)

		DHr(hr)

		-- HUD Reset Settings
		local hud_reset_settings = createD("DButton", nil, GRP_HUD:GetWide(), ctr(50), 0, ctr(50))
		hud_reset_settings:SetText("")
		function hud_reset_settings:Paint(pw, ph)
			local color = Color(255, 255, 255)
			if self:IsHovered() then
				color = Color(255, 255, 100)
			end
			draw.RoundedBox(0, 0, 0, pw, ph, color)
			draw.SimpleText(YRP.lang_string("LID_settodefault"), "DermaDefault", pw / 2, ph / 2, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		function hud_reset_settings:DoClick()
			CloseSettings()

			function YesFunction()
				net.Start("reset_hud_settings")
				net.SendToServer()
			end
			AreYouSure(YesFunction)
		end
		GRP_HUD:AddItem(hud_reset_settings)



		-- Interface
		local GRP_IF = {}
		GRP_IF.parent = Parent
		GRP_IF.x = ctr(20 + 1000 + 20)
		GRP_IF.y = ctr(20)
		GRP_IF.w = ctr(1000)
		GRP_IF.h = ctr(1600)
		GRP_IF.br = ctr(20)
		GRP_IF.color = Color(255, 255, 255)
		GRP_IF.bgcolor = Color(80, 80, 80)
		GRP_IF.name = "LID_interface"
		GRP_IF = DGroup(GRP_IF)
		GRP_IF.cif = {}

		-- IF Design
		local if_design_bg = createD("DPanel", nil, GRP_IF:GetWide(), ctr(100), 0, 0)
		function if_design_bg:Paint(pw, ph)
			--
		end
		local if_design_header = createD("DPanel", if_design_bg, if_design_bg:GetWide(), ctr(50), 0, 0)
		function if_design_header:Paint(pw, ph)
			draw.SimpleText(YRP.lang_string("LID_design"), "DermaDefault", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		local if_design_choice = createD("DComboBox", if_design_bg, if_design_bg:GetWide(), ctr(50), 0, ctr(50))
		for i, design in pairs(INTERFACES) do
			local selected = false
			if design.name == setting.string_interface_design then
				selected = true
				net.Start("get_interface_settings")
					net.WriteString(design.name)
				net.SendToServer()
			end
			local name = design.name .. " by " .. design.author
			if tonumber(design.progress) < 100 then
				name = name .. " (" .. design.progress .. "% " .. YRP.lang_string("LID_done") .. ")"
			end
			if_design_choice:AddChoice(name, design.name, selected)
		end
		function if_design_choice:OnSelect(panel, index, value)
			net.Start("change_interface_design")
				net.WriteString(value)
			net.SendToServer()
			net.Start("get_interface_settings")
				net.WriteString(value)
			net.SendToServer()
		end
		GRP_IF:AddItem(if_design_bg)

		net.Receive("get_interface_settings", function(len)
			for i, ele in pairs(GRP_IF.cif) do
				ele:Remove()
			end

			local iftab = net.ReadTable()
			for i, ift in pairs(iftab) do
				if string.find(ift.name, "color") then
					local _start, _end = string.find(ift.name, "_Y")
					local name = "LID_" .. string.lower("color_" .. string.sub(ift.name, _start + 1))

					local color = StringToColor(ift.value)

					local ycol = createD("DPanel", nil, ctr(200), ctr(50), 0, 0)
					function ycol:Paint(pw, ph)
						draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
						draw.SimpleText(YRP.lang_string(name), "DermaDefault", ph + ctr(20), ph / 2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					end

					ycol.cm = createD("YColorMenuButton", ycol, ctr(50), ctr(50), 0, 0)
					ycol.cm:SetColor(color)
					function ycol.cm:ColorChanged(col)
						net.Start("update_interface_color")
							net.WriteString(ift.name)
							net.WriteString(ColorToString(col))
						net.SendToServer()
					end

					table.insert(GRP_IF.cif, ycol)
					GRP_IF:AddItem(ycol)
				end
			end
		end)

		local pv_win = createD("YFrame", Parent, ctr(1000), ctr(1000), ctr(20 + 1000 + 20 + 1000 + 20 + 20), ctr(120))
		pv_win:SetTitle("LID_window")
		function pv_win:Paint(pw, ph)
			hook.Run("YFramePaint", self, pw, ph)
			self:MoveToFront()
		end
		pv_win:SetHeaderHeight(ctr(100))
		pv_win:MakePopup()

		local pv_btn = createD("YButton", pv_win, ctr(300), ctr(100), ctr(20), ctr(100 + 20))
		pv_btn:SetText("LID_button")
		function pv_btn:Paint(pw, ph)
			local tab = {}
			tab.text = YRP.lang_string(self:GetText())
			if self:IsDown() then
				tab.text = tab.text .. " (" .. YRP.lang_string("LID_pressed") .. ")"
			elseif self:IsHovered() then
				tab.text = tab.text .. " (" .. YRP.lang_string("LID_hovered") .. ")"
			end
			hook.Run("YButtonPaint", self, pw, ph, tab)
		end

		local pv_lbl = createD("YLabel", pv_win, ctr(300), ctr(100), ctr(20 + 300 + 20), ctr(100 + 20))
		pv_lbl:SetText("LID_label")
		function pv_lbl:Paint(pw, ph)
			hook.Run("YLabelPaint", self, pw, ph)
		end
	end
end)

hook.Add("open_server_design", "open_server_design", function()
	SaveLastSite()

	local w = settingsWindow.window.sitepanel:GetWide()
	local h = settingsWindow.window.sitepanel:GetTall()

	settingsWindow.window.site = createD("DPanel", settingsWindow.window.sitepanel, w, h, 0, 0)

	net.Start("get_design_settings")
	net.SendToServer()
end)
