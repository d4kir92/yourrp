--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

net.Receive("get_levelsystem_settings", function(len)
	local lply = LocalPlayer()
	local setting = net.ReadTable()

	if pa(settingsWindow.window) then
		function settingsWindow.window.site:Paint(pw, ph)
			surfaceBox(0, 0, pw, ph, Color(0, 0, 0, 254))
		end

		local Parent = settingsWindow.window.site

		local GRP_LS = {}
		GRP_LS.parent = Parent
		GRP_LS.x = ctr(20)
		GRP_LS.y = ctr(20)
		GRP_LS.w = ctr(1000)
		GRP_LS.h = ctr(530)
		GRP_LS.br = ctr(20)
		GRP_LS.color = Color(255, 255, 255)
		GRP_LS.bgcolor = Color(80, 80, 80)
		GRP_LS.name = "LID_levelsystem"
		GRP_LS = DGroup(GRP_LS)

		-- MIN
		local ls_level_min_header = createD("YLabel", nil, GRP_LS:GetWide(), ctr(50), 0, 0)
		ls_level_min_header:SetText("LID_minimumlevel")
		function ls_level_min_header:Paint(pw, ph)
			hook.Run("YLabelPaint", self, pw, ph)
		end
		GRP_LS:AddItem(ls_level_min_header)

		local ls_level_min = createD("DNumberWang", nil, GRP_LS:GetWide(), ctr(50), 0, 0)
		ls_level_min:SetMin(0)
		ls_level_min:SetMax(9999999)
		ls_level_min:SetValue(setting.int_level_min)
		function ls_level_min:OnValueChanged(val)
			setting.int_level_min = val
		end
		GRP_LS:AddItem(ls_level_min)

		local hr = {}
		hr.h = ctr(16)
		hr.parent = GRP_LS
		DHr(hr)

		-- MAX
		local ls_level_max_header = createD("YLabel", nil, GRP_LS:GetWide(), ctr(50), 0, 0)
		ls_level_max_header:SetText("LID_maximumlevel")
		function ls_level_max_header:Paint(pw, ph)
			hook.Run("YLabelPaint", self, pw, ph)
		end
		GRP_LS:AddItem(ls_level_max_header)

		local ls_level_max = createD("DNumberWang", nil, GRP_LS:GetWide(), ctr(50), 0, 0)
		ls_level_max:SetMin(1)
		ls_level_max:SetMax(10000000)
		ls_level_max:SetValue(setting.int_level_max)
		function ls_level_max:OnValueChanged(val)
			setting.int_level_max = val
		end
		GRP_LS:AddItem(ls_level_max)

		DHr(hr)

		-- START
		local ls_level_start_header = createD("YLabel", nil, GRP_LS:GetWide(), ctr(50), 0, 0)
		ls_level_start_header:SetText("LID_startlevel")
		function ls_level_start_header:Paint(pw, ph)
			hook.Run("YLabelPaint", self, pw, ph)
		end
		GRP_LS:AddItem(ls_level_start_header)

		local ls_level_start = createD("DNumberWang", nil, GRP_LS:GetWide(), ctr(50), 0, 0)
		ls_level_start:SetMin(0)
		ls_level_start:SetMax(9999999)
		ls_level_start:SetValue(setting.int_level_start)
		function ls_level_start:OnValueChanged(val)
			setting.int_level_start = val
		end
		GRP_LS:AddItem(ls_level_start)

		DHr(hr)

		-- Multiplier
		local ls_level_multiplier_header = createD("YLabel", nil, GRP_LS:GetWide(), ctr(50), 0, 0)
		ls_level_multiplier_header:SetText("LID_multiplier")
		function ls_level_multiplier_header:Paint(pw, ph)
			hook.Run("YLabelPaint", self, pw, ph)
		end
		GRP_LS:AddItem(ls_level_multiplier_header)

		local ls_level_multiplier = createD("DNumberWang", nil, GRP_LS:GetWide(), ctr(50), 0, 0)
		ls_level_multiplier:SetNumeric(true)
		ls_level_multiplier:SetDecimals(3)
		ls_level_multiplier:SetMin(1.0)
		ls_level_multiplier:SetMax(2.0)
		ls_level_multiplier:SetValue(setting.float_multiplier)
		function ls_level_multiplier:OnValueChanged(val)
			setting.float_multiplier = val
		end
		GRP_LS:AddItem(ls_level_multiplier)

		GRP_LS:AutoSize()



		local GRP_XP = {}
		GRP_XP.parent = Parent
		GRP_XP.x = ctr(1040)
		GRP_XP.y = ctr(20)
		GRP_XP.w = ctr(1000)
		GRP_XP.h = ctr(530)
		GRP_XP.br = ctr(20)
		GRP_XP.color = Color(255, 255, 255)
		GRP_XP.bgcolor = Color(80, 80, 80)
		GRP_XP.name = "LID_levelsystem"
		GRP_XP = DGroup(GRP_XP)

		-- Levelup
		local xp_for_levelup_header = createD("YLabel", nil, GRP_XP:GetWide(), ctr(50), 0, 0)
		xp_for_levelup_header:SetText("LID_xpforlevelup")
		function xp_for_levelup_header:Paint(pw, ph)
			hook.Run("YLabelPaint", self, pw, ph)
		end
		GRP_XP:AddItem(xp_for_levelup_header)

		GRP_XP:AutoSize()



		-- Diagramm
		local diagramm = createD("YLabel", Parent, ctr(1600), ctr(800), ctr(2060), ctr(20))
		diagramm:SetText("")
		function diagramm:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255))

			local x = ctr(60)
			local y = ph - ctr(60)
			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawLine(x, y, pw - x, y)
			surface.DrawLine(x, y, x, ph - y)

			local min = tonumber(setting.int_level_min)
			local max = tonumber(setting.int_level_max)
			local multiplier = tonumber(setting.float_multiplier)
			local coords = {}
			for i = min, max do
				coords[i] = math.pow(i, multiplier) + 100
			end

			local tab_count = tonumber(table.Count(coords))
			local xaxis = pw - ctr(120)
			local xaxispart = xaxis / tab_count
			local yaxis = ph - ctr(120)
			local ymax = coords[table.Count(coords)] or 1
			local ymulti = yaxis / ymax

			surface.SetDrawColor(0, 0, 255, 255)
			for i, v in pairs(coords) do
				if i > min then
					local p1 = coords[i - 1]
					local p2 = coords[i]
					p1 = p1 * ymulti
					p2 = p2 * ymulti

					p1 = yaxis - p1
					p2 = yaxis - p2

					p1 = ctr(60) + p1
					p2 = ctr(60) + p2

					if i == min + 1 then
						draw.SimpleTextOutlined(coords[i - 1], "DermaDefault", ctr(30), p1, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
					end
					surface.DrawLine(x + xaxispart * (i - 1), p1, x + xaxispart * i, p2)
				end
			end

			local ymin = 0
			ymax = math.Round(ymax, 0)
			draw.SimpleTextOutlined(ymin, "DermaDefault", ctr(30), ctr(60) + yaxis, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
			draw.SimpleTextOutlined(ymax, "DermaDefault", ctr(30), ctr(60), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
			draw.SimpleTextOutlined(YRP.lang_string("LID_xp"), "DermaDefault", ctr(30), ctr(60) + yaxis / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))

			draw.SimpleTextOutlined(min, "DermaDefault", ctr(60), ctr(60) + yaxis + ctr(30), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
			draw.SimpleTextOutlined(max, "DermaDefault", ctr(60) + xaxis, ctr(60) + yaxis + ctr(30), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
			draw.SimpleTextOutlined(YRP.lang_string("LID_level"), "DermaDefault", ctr(60) + xaxis / 2, ctr(60) + yaxis + ctr(30), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
		end
	end
end)

hook.Add("open_server_levelsystem", "open_server_levelsystem", function()
	SaveLastSite()

	local w = settingsWindow.window.sitepanel:GetWide()
	local h = settingsWindow.window.sitepanel:GetTall()

	settingsWindow.window.site = createD("DPanel", settingsWindow.window.sitepanel, w, h, 0, 0)

	net.Start("get_levelsystem_settings")
	net.SendToServer()
end)
