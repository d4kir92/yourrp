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
		ls_level_min:SetMin(1)
		ls_level_min:SetMax(9999999)
		ls_level_min:SetValue(setting.int_level_min)
		function ls_level_min:OnValueChanged(val)
			val = tonumber(val)
			local min = tonumber(self:GetMin())
			local max = tonumber(self:GetMax())
			if val >= min and val <= max then
				setting.int_level_min = val
				net.Start("update_ls_int_level_min")
					net.WriteString(val)
				net.SendToServer()
			elseif val < min then
				self:SetText(min)
				self:SetValue(min)
			elseif val > max then
				self:SetText(max)
				self:SetValue(max)
			end
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
			val = tonumber(val)
			local min = tonumber(self:GetMin())
			local max = tonumber(self:GetMax())
			if val >= min and val <= max then
				setting.int_level_max = val
				net.Start("update_ls_int_level_max")
					net.WriteString(val)
				net.SendToServer()
			elseif val < min then
				self:SetText(min)
				self:SetValue(min)
			elseif val > max then
				self:SetText(max)
				self:SetValue(max)
			end
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
			val = tonumber(val)
			local min = tonumber(self:GetMin())
			local max = tonumber(self:GetMax())
			if val >= min and val <= max then
				setting.int_level_start = val
				net.Start("update_ls_int_level_start")
					net.WriteString(val)
				net.SendToServer()
			elseif val < min then
				self:SetText(min)
				self:SetValue(min)
			elseif val > max then
				self:SetText(max)
				self:SetValue(max)
			end
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
			val = tonumber(val)
			local min = tonumber(self:GetMin())
			local max = tonumber(self:GetMax())
			if val >= min and val <= max then
				setting.float_multiplier = val
				net.Start("update_ls_float_multiplier")
					net.WriteString(val)
				net.SendToServer()
			elseif val < min then
				self:SetText(min)
				self:SetValue(min)
			elseif val > max then
				self:SetText(max)
				self:SetValue(max)
			end
		end
		GRP_LS:AddItem(ls_level_multiplier)

		DHr(hr)

		-- Levelup
		local xp_for_levelup_header = createD("YLabel", nil, GRP_LS:GetWide(), ctr(50), 0, 0)
		xp_for_levelup_header:SetText("LID_xpforlevelup")
		function xp_for_levelup_header:Paint(pw, ph)
			hook.Run("YLabelPaint", self, pw, ph)
		end
		GRP_LS:AddItem(xp_for_levelup_header)

		local ls_xp_for_levelup = createD("DNumberWang", nil, GRP_LS:GetWide(), ctr(50), 0, 0)
		ls_xp_for_levelup:SetMin(1)
		ls_xp_for_levelup:SetMax(999999)
		ls_xp_for_levelup:SetValue(setting.int_xp_for_levelup)
		function ls_xp_for_levelup:OnValueChanged(val)
			val = tonumber(val)
			local min = tonumber(self:GetMin())
			local max = tonumber(self:GetMax())
			if val >= min and val <= max then
				setting.int_xp_for_levelup = val
				net.Start("update_ls_int_xp_for_levelup")
					net.WriteString(val)
				net.SendToServer()
			elseif val < min then
				self:SetText(min)
				self:SetValue(min)
			elseif val > max then
				self:SetText(max)
				self:SetValue(max)
			end
		end
		GRP_LS:AddItem(ls_xp_for_levelup)

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

		-- XP Per Kill
		local xp_per_kill_header = createD("YLabel", nil, GRP_XP:GetWide(), ctr(50), 0, 0)
		xp_per_kill_header:SetText("LID_xpperkill")
		function xp_per_kill_header:Paint(pw, ph)
			hook.Run("YLabelPaint", self, pw, ph)
		end
		GRP_XP:AddItem(xp_per_kill_header)

		local ls_xp_per_kill = createD("DNumberWang", nil, GRP_XP:GetWide(), ctr(50), 0, 0)
		ls_xp_per_kill:SetMin(1)
		ls_xp_per_kill:SetMax(999999)
		ls_xp_per_kill:SetValue(setting.int_xp_per_kill)
		function ls_xp_per_kill:OnValueChanged(val)
			val = tonumber(val)
			local min = tonumber(self:GetMin())
			local max = tonumber(self:GetMax())
			if val >= min and val <= max then
				setting.int_xp_per_kill = val
				net.Start("update_ls_int_xp_per_kill")
					net.WriteString(val)
				net.SendToServer()
			elseif val < min then
				self:SetText(min)
				self:SetValue(min)
			elseif val > max then
				self:SetText(max)
				self:SetValue(max)
			end
		end
		GRP_XP:AddItem(ls_xp_per_kill)

		-- XP Per Minute
		local ls_xp_per_minute_header = createD("YLabel", nil, GRP_XP:GetWide(), ctr(50), 0, 0)
		ls_xp_per_minute_header:SetText("LID_xpperminute")
		function ls_xp_per_minute_header:Paint(pw, ph)
			hook.Run("YLabelPaint", self, pw, ph)
		end
		GRP_XP:AddItem(ls_xp_per_minute_header)

		local ls_xp_per_minute = createD("DNumberWang", nil, GRP_XP:GetWide(), ctr(50), 0, 0)
		ls_xp_per_minute:SetMin(1)
		ls_xp_per_minute:SetMax(999999)
		ls_xp_per_minute:SetValue(setting.int_xp_per_minute)
		function ls_xp_per_minute:OnValueChanged(val)
			val = tonumber(val)
			local min = tonumber(self:GetMin())
			local max = tonumber(self:GetMax())
			if val >= min and val <= max then
				setting.int_xp_per_minute = val
				net.Start("update_ls_int_xp_per_minute")
					net.WriteString(val)
				net.SendToServer()
			elseif val < min then
				self:SetText(min)
				self:SetValue(min)
			elseif val > max then
				self:SetText(max)
				self:SetValue(max)
			end
		end
		GRP_XP:AddItem(ls_xp_per_minute)

		-- XP Per Revive
		local ls_xp_per_revive_header = createD("YLabel", nil, GRP_XP:GetWide(), ctr(50), 0, 0)
		ls_xp_per_revive_header:SetText("LID_xpperrevive")
		function ls_xp_per_revive_header:Paint(pw, ph)
			hook.Run("YLabelPaint", self, pw, ph)
		end
		GRP_XP:AddItem(ls_xp_per_revive_header)

		local ls_xp_per_revive = createD("DNumberWang", nil, GRP_XP:GetWide(), ctr(50), 0, 0)
		ls_xp_per_revive:SetMin(1)
		ls_xp_per_revive:SetMax(999999)
		ls_xp_per_revive:SetValue(setting.int_xp_per_revive)
		function ls_xp_per_revive:OnValueChanged(val)
			val = tonumber(val)
			local min = tonumber(self:GetMin())
			local max = tonumber(self:GetMax())
			if val >= min and val <= max then
				setting.int_xp_per_revive = val
				net.Start("update_ls_int_xp_per_revive")
					net.WriteString(val)
				net.SendToServer()
			elseif val < min then
				self:SetText(min)
				self:SetValue(min)
			elseif val > max then
				self:SetText(max)
				self:SetValue(max)
			end
		end
		GRP_XP:AddItem(ls_xp_per_revive)

		GRP_XP:AutoSize()



		-- Diagramm
		local diagramm = createD("YLabel", Parent, ctr(1600), ctr(800), ctr(2060), ctr(20))
		diagramm:SetText("")
		function diagramm:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255))

			local br = ctr(100)
			local x = br
			local y = ph - br
			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawLine(x, y, pw - x, y)
			surface.DrawLine(x, y, x, ph - y)

			local min = tonumber(setting.int_level_min)
			local max = tonumber(setting.int_level_max)
			local multiplier = tonumber(setting.float_multiplier)
			local xp_for_levelup = tonumber(setting.int_xp_for_levelup)
			local coords = {}
			for i = min, max do
				coords[i] = math.pow(i, multiplier) + xp_for_levelup
			end

			local tab_count = tonumber(table.Count(coords))
			local xaxis = pw - 2 * br
			local xaxispart = xaxis / tab_count
			local yaxis = ph - 2 * br
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

					p1 = br + p1
					p2 = br + p2

					if i == min + 1 then
						draw.SimpleTextOutlined(coords[i - 1], "DermaDefault", br - ctr(10), p1, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
					end
					surface.DrawLine(x + xaxispart * (i - 2), p1, x + xaxispart * (i - 1), p2)
				end
			end

			local ymin = 0
			ymax = math.Round(ymax, 0)
			draw.SimpleTextOutlined(ymin, "DermaDefault", ctr(10), br + yaxis, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
			draw.SimpleTextOutlined(ymax, "DermaDefault", ctr(10), br, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
			draw.SimpleTextOutlined(YRP.lang_string("LID_xp"), "DermaDefault", ctr(10), br + yaxis / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))

			draw.SimpleTextOutlined(min, "DermaDefault", br, br + yaxis + br / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
			draw.SimpleTextOutlined(max, "DermaDefault", br + xaxis, br + yaxis + br / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
			draw.SimpleTextOutlined(YRP.lang_string("LID_level"), "DermaDefault", br + xaxis / 2, br + yaxis + br / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
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
