--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local HA = {}
HA.w = ScrW()
HA.space = ctr(20)

function HScrW()
	return HA.w
end

function BiggerThen16_9()
	if ScrW() > ScrH() / 9 * 16 then
		HA.w = ScrH() / 9 * 16
		return true
	else
		HA.w = ScrW()
		return false
	end
end

function ScreenFix()
	if BiggerThen16_9() then
		return (ScrW() - (ScrH() / 9 * 16)) / 2
	else
		return 0
	end
end

function PosX()
	return ScreenFix()
end

function ScW()
	if BiggerThen16_9() then
		return ScrW() - 2 * ScreenFix()
	else
		return ScrW()
	end
end

function ScH()
	return ScrH()
end

local Player = FindMetaTable("Player")
function Player:GetHudVal(element, art)
	local dbval = nil
	dbval = self:GetNWFloat("float_HUD_" .. element .. "_" .. art, 0.0)

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

function Player:GetHudBool(element, art)
	return self:GetNWBool("bool_HUD_" .. element .. "_" .. art, false)
end

net.Receive("get_design_settings", function(len)
	local lply = LocalPlayer()
	local setting = net.ReadTable()
	local HUDS = net.ReadTable()

	if pa(settingsWindow.window) then
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
			hudcustom:MakePopup()
			function hudcustom:Paint(pw, ph)
				--
			end

			local editarea = createD("DButton", hudcustom, ScW(), ScH(), 0, 0)
			editarea:SetText("")
			if BiggerThen16_9() then
				editarea:SetPos(PosX(), 0)
				editarea:SetWide(ScW())
			end
			editarea.space = HA.space
			editarea.hl = 5
			function editarea:Paint(pw, ph)
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
				win:SetMinWidth(40)
				win:SetMinHeight(20)
				win.saved = false
				win.w = win:GetWide()
				win.h = win:GetTall()
				function win:Paint(pw, ph)
					draw.RoundedBox(0, 0, 0, pw, ph, Color(40, 40, 40, 200))
					draw.SimpleText(YRP.lang_string(tab.name), "DermaDefault", ctr(36 + 8 + 8), ctr(20), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

					draw.RoundedBox(0, pw - ctr(8 + 16), ph - ctr(8 + 4), ctr(16), ctr(4), Color(255, 255, 255, 255))
					draw.RoundedBox(0, pw - ctr(8 + 4), ph - ctr(8 + 16), ctr(4), ctr(16), Color(255, 255, 255, 255))

					local tbr = {}
					tbr.r = 0
					tbr.w = pw
					tbr.h = ph
					tbr.x = 0
					tbr.y = 0
					tbr.color = Color(255, 255, 0, 255)
					HudBoxBr(tbr)

					local x, y = self:GetPos()
					local modx, mody = x % HA.space, y % HA.space

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
					end

					local w = pw
					local h = ph
					if self.w != self:GetWide() or self.h != self:GetTall() then

						w = w - w % HA.space
						h = h - h % HA.space
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

				win.setting = createD("DButton", win, ctr(36), ctr(36), ctr(4), ctr(4))
				win.setting:SetText("")
				function win.setting:DoClick()
					net.Receive("get_hud_element_settings", function(le)
						local eletab = net.ReadTable()
						local wx, wy = win:GetPos()
						local winset = createD("DFrame", nil, ctr(800), ctr(800), wx, wy)
						winset:MakePopup()
						winset:SetTitle("")
						function winset:Paint(pw, ph)
							draw.RoundedBox(0, 0, 0, pw, ph, Color(40, 40, 40, 200))
							draw.SimpleText(YRP.lang_string(tab.name), "DermaDefault", ctr(50), ctr(25), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

							local x, y = self:GetPos()
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

						winset.dpl = createD("DPanelList", winset, winset:GetWide() - ctr(20 + 20), winset:GetTall() - ctr(50 + 20 + 20), ctr(20), ctr(50 + 20))
						function winset:AddCheckBox(t)
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

							winset.dpl:AddItem(line)
						end

						local visi = {}
						visi.name = "LID_visible"
						visi.element = tab.element
						visi.art = "VISI"
						visi.value = eletab["bool_HUD_" .. tab.element .. "_VISI"]
						winset:AddCheckBox(visi)

						local roun = {}
						roun.name = "LID_rounded"
						roun.element = tab.element
						roun.art = "ROUN"
						roun.value = eletab["bool_HUD_" .. tab.element .. "_ROUN"]
						winset:AddCheckBox(roun)

						local icon = {}
						icon.name = "LID_icon"
						icon.element = tab.element
						icon.art = "ICON"
						icon.value = eletab["bool_HUD_" .. tab.element .. "_ICON"]
						winset:AddCheckBox(icon)

						local text = {}
						text.name = "LID_text"
						text.element = tab.element
						text.art = "TEXT"
						text.value = eletab["bool_HUD_" .. tab.element .. "_TEXT"]
						winset:AddCheckBox(text)

						local perc = {}
						perc.name = "LID_percentage"
						perc.element = tab.element
						perc.art = "PERC"
						perc.value = eletab["bool_HUD_" .. tab.element .. "_PERC"]
						winset:AddCheckBox(perc)

						local back = {}
						back.name = "LID_background"
						back.element = tab.element
						back.art = "BACK"
						back.value = eletab["bool_HUD_" .. tab.element .. "_BACK"]
						winset:AddCheckBox(back)

						local bord = {}
						bord.name = "LID_border"
						bord.element = tab.element
						bord.art = "BORD"
						bord.value = eletab["bool_HUD_" .. tab.element .. "_BORD"]
						winset:AddCheckBox(bord)

						--winset.textsize = createD("???", winset, ctr(50), ctr(50), ctr(20), ctr(50 + 20))
					end)
					net.Start("get_hud_element_settings")
						net.WriteString(tab.element)
					net.SendToServer()
				end
				function win.setting:Paint(pw, ph)
					local color = Color(255, 255, 255, 255)
					if self:IsHovered() then
						color = Color(255, 255, 0, 255)
					end
					draw.RoundedBox(ph / 2, 0, 0, pw, ph, color)

					YRP.DrawIcon(YRP.GetDesignIcon("settings"), ph - ctr(4), ph - ctr(4), ctr(2), ctr(2), Color(0, 0, 0))
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

			local MI = {}
			MI.element = "MI"
			MI.name = "LID_minimap"
			AddElement(MI)

			function editarea:DoClick()
				for i, child in pairs(self:GetChildren()) do
					child:Close()
				end
				hudcustom:Close()
			end
		end
		GRP_HUD:AddItem(hud_customize_btn)

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
