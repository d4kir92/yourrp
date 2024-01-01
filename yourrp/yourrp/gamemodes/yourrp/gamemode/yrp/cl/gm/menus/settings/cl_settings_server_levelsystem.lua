--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
net.Receive(
	"nws_yrp_get_levelsystem_settings",
	function(len)
		local setting = net.ReadTable()
		local PARENT = GetSettingsSite()
		if YRPPanelAlive(PARENT) then
			local GRP_LS = YRPCreateD("YGroupBox", PARENT, YRP.ctr(1000), YRP.ctr(530), YRP.ctr(20), YRP.ctr(20))
			GRP_LS:SetText("LID_levelsystem")
			function GRP_LS:Paint(pw, ph)
				hook.Run("YGroupBoxPaint", self, pw, ph)
			end

			GRP_LS:AutoSize(true)
			-- MIN
			local ls_level_min_header = YRPCreateD("YLabel", nil, GRP_LS:GetWide(), YRP.ctr(50), 0, 0)
			ls_level_min_header:SetText("LID_minimumlevel")
			function ls_level_min_header:Paint(pw, ph)
				hook.Run("YLabelPaint", self, pw, ph)
			end

			GRP_LS:AddItem(ls_level_min_header)
			local ls_level_min = YRPCreateD("DNumberWang", nil, GRP_LS:GetWide(), YRP.ctr(50), 0, 0)
			ls_level_min:SetMin(1)
			ls_level_min:SetMax(9999999)
			ls_level_min:SetValue(setting.int_level_min)
			function ls_level_min:OnValueChanged(val)
				val = tonumber(val)
				local min = tonumber(self:GetMin())
				local max = tonumber(self:GetMax())
				if val >= min and val <= max then
					setting.int_level_min = val
					net.Start("nws_yrp_update_ls_int_level_min")
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
			hr.h = YRP.ctr(16)
			hr.parent = GRP_LS
			DHr(hr)
			-- MAX
			local ls_level_max_header = YRPCreateD("YLabel", nil, GRP_LS:GetWide(), YRP.ctr(50), 0, 0)
			ls_level_max_header:SetText("LID_maximumlevel")
			function ls_level_max_header:Paint(pw, ph)
				hook.Run("YLabelPaint", self, pw, ph)
			end

			GRP_LS:AddItem(ls_level_max_header)
			local ls_level_max = YRPCreateD("DNumberWang", nil, GRP_LS:GetWide(), YRP.ctr(50), 0, 0)
			ls_level_max:SetMin(1)
			ls_level_max:SetMax(10000000)
			ls_level_max:SetValue(setting.int_level_max)
			function ls_level_max:OnValueChanged(val)
				val = tonumber(val)
				local min = tonumber(self:GetMin())
				local max = tonumber(self:GetMax())
				if val >= min and val <= max then
					setting.int_level_max = val
					net.Start("nws_yrp_update_ls_int_level_max")
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
			local ls_level_start_header = YRPCreateD("YLabel", nil, GRP_LS:GetWide(), YRP.ctr(50), 0, 0)
			ls_level_start_header:SetText("LID_startlevel")
			function ls_level_start_header:Paint(pw, ph)
				hook.Run("YLabelPaint", self, pw, ph)
			end

			GRP_LS:AddItem(ls_level_start_header)
			local ls_level_start = YRPCreateD("DNumberWang", nil, GRP_LS:GetWide(), YRP.ctr(50), 0, 0)
			ls_level_start:SetMin(0)
			ls_level_start:SetMax(9999999)
			ls_level_start:SetValue(setting.int_level_start)
			function ls_level_start:OnValueChanged(val)
				val = tonumber(val)
				local min = tonumber(self:GetMin())
				local max = tonumber(self:GetMax())
				if val >= min and val <= max then
					setting.int_level_start = val
					net.Start("nws_yrp_update_ls_int_level_start")
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
			local ls_level_multiplier_header = YRPCreateD("YLabel", nil, GRP_LS:GetWide(), YRP.ctr(50), 0, 0)
			ls_level_multiplier_header:SetText("LID_multiplier")
			function ls_level_multiplier_header:Paint(pw, ph)
				hook.Run("YLabelPaint", self, pw, ph)
			end

			GRP_LS:AddItem(ls_level_multiplier_header)
			local ls_level_multiplier = YRPCreateD("DNumberWang", nil, GRP_LS:GetWide(), YRP.ctr(50), 0, 0)
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
					net.Start("nws_yrp_update_ls_float_multiplier")
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
			local xp_for_levelup_header = YRPCreateD("YLabel", nil, GRP_LS:GetWide(), YRP.ctr(50), 0, 0)
			xp_for_levelup_header:SetText("LID_xpforlevelup")
			function xp_for_levelup_header:Paint(pw, ph)
				hook.Run("YLabelPaint", self, pw, ph)
			end

			GRP_LS:AddItem(xp_for_levelup_header)
			local ls_xp_for_levelup = YRPCreateD("DNumberWang", nil, GRP_LS:GetWide(), YRP.ctr(50), 0, 0)
			ls_xp_for_levelup:SetMin(1)
			ls_xp_for_levelup:SetMax(999999)
			ls_xp_for_levelup:SetValue(setting.int_xp_for_levelup)
			function ls_xp_for_levelup:OnValueChanged(val)
				val = tonumber(val)
				local min = tonumber(self:GetMin())
				local max = tonumber(self:GetMax())
				if val >= min and val <= max then
					setting.int_xp_for_levelup = val
					net.Start("nws_yrp_update_ls_int_xp_for_levelup")
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
			local GRP_XP = YRPCreateD("YGroupBox", PARENT, YRP.ctr(1000), YRP.ctr(530), YRP.ctr(1040), YRP.ctr(20))
			GRP_XP:SetText("LID_levelsystem")
			function GRP_XP:Paint(pw, ph)
				hook.Run("YGroupBoxPaint", self, pw, ph)
			end

			GRP_XP:AutoSize(true)
			-- XP Per Kill
			local xp_per_kill_header = YRPCreateD("YLabel", nil, GRP_XP:GetWide(), YRP.ctr(50), 0, 0)
			xp_per_kill_header:SetText("LID_xpperkill")
			function xp_per_kill_header:Paint(pw, ph)
				hook.Run("YLabelPaint", self, pw, ph)
			end

			GRP_XP:AddItem(xp_per_kill_header)
			local ls_xp_per_kill = YRPCreateD("DNumberWang", nil, GRP_XP:GetWide(), YRP.ctr(50), 0, 0)
			ls_xp_per_kill:SetMin(1)
			ls_xp_per_kill:SetMax(999999)
			ls_xp_per_kill:SetValue(setting.int_xp_per_kill)
			function ls_xp_per_kill:OnValueChanged(val)
				val = tonumber(val)
				local min = tonumber(self:GetMin())
				local max = tonumber(self:GetMax())
				if val >= min and val <= max then
					setting.int_xp_per_kill = val
					net.Start("nws_yrp_update_ls_int_xp_per_kill")
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
			local ls_xp_per_minute_header = YRPCreateD("YLabel", nil, GRP_XP:GetWide(), YRP.ctr(50), 0, 0)
			ls_xp_per_minute_header:SetText("LID_xpperminute")
			function ls_xp_per_minute_header:Paint(pw, ph)
				hook.Run("YLabelPaint", self, pw, ph)
			end

			GRP_XP:AddItem(ls_xp_per_minute_header)
			local ls_xp_per_minute = YRPCreateD("DNumberWang", nil, GRP_XP:GetWide(), YRP.ctr(50), 0, 0)
			ls_xp_per_minute:SetMin(1)
			ls_xp_per_minute:SetMax(999999)
			ls_xp_per_minute:SetValue(setting.int_xp_per_minute)
			function ls_xp_per_minute:OnValueChanged(val)
				val = tonumber(val)
				local min = tonumber(self:GetMin())
				local max = tonumber(self:GetMax())
				if val >= min and val <= max then
					setting.int_xp_per_minute = val
					net.Start("nws_yrp_update_ls_int_xp_per_minute")
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
			local ls_xp_per_revive_header = YRPCreateD("YLabel", nil, GRP_XP:GetWide(), YRP.ctr(50), 0, 0)
			ls_xp_per_revive_header:SetText("LID_xpperrevive")
			function ls_xp_per_revive_header:Paint(pw, ph)
				hook.Run("YLabelPaint", self, pw, ph)
			end

			GRP_XP:AddItem(ls_xp_per_revive_header)
			local ls_xp_per_revive = YRPCreateD("DNumberWang", nil, GRP_XP:GetWide(), YRP.ctr(50), 0, 0)
			ls_xp_per_revive:SetMin(1)
			ls_xp_per_revive:SetMax(999999)
			ls_xp_per_revive:SetValue(setting.int_xp_per_revive)
			function ls_xp_per_revive:OnValueChanged(val)
				val = tonumber(val)
				local min = tonumber(self:GetMin())
				local max = tonumber(self:GetMax())
				if val >= min and val <= max then
					setting.int_xp_per_revive = val
					net.Start("nws_yrp_update_ls_int_xp_per_revive")
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
			-- Diagramm
			local diagramm = YRPCreateD("YLabel", PARENT, YRP.ctr(1600), YRP.ctr(800), YRP.ctr(2060), YRP.ctr(20))
			diagramm:SetText("")
			function diagramm:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
				local br = YRP.ctr(100)
				local x = br
				local y = ph - br
				surface.SetDrawColor(Color(0, 0, 0, 255))
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
				local ymax = coords[tab_count - 1] or 1
				local ymulti = yaxis / ymax
				surface.SetDrawColor(0, 0, 255, 255)
				for i, v in pairs(coords) do
					if i < max then
						local p1 = coords[i]
						local p2 = coords[i + 1]
						p1 = p1 * ymulti
						p2 = p2 * ymulti
						p1 = yaxis - p1
						p2 = yaxis - p2
						p1 = br + p1
						p2 = br + p2
						if i == min then
							draw.SimpleTextOutlined(coords[i], "DermaDefault", br - YRP.ctr(10), p1, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						end

						surface.DrawLine(x + xaxispart * i, p1, x + xaxispart * (i + 1), p2)
					end
				end

				local ymin = 0
				ymax = math.Round(ymax, 0)
				draw.SimpleTextOutlined(ymin, "DermaDefault", YRP.ctr(10), br + yaxis, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				draw.SimpleTextOutlined(ymax, "DermaDefault", YRP.ctr(10), br, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				draw.SimpleTextOutlined(YRP.trans("LID_xp"), "DermaDefault", YRP.ctr(10), br + yaxis / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				draw.SimpleTextOutlined(min, "DermaDefault", br, br + yaxis + br / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				draw.SimpleTextOutlined(max, "DermaDefault", br + xaxis, br + yaxis + br / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				draw.SimpleTextOutlined(YRP.trans("LID_level"), "DermaDefault", br + xaxis / 2, br + yaxis + br / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
			end
		end
	end
)

function OpenSettingsLevelsystem()
	net.Start("nws_yrp_get_levelsystem_settings")
	net.SendToServer()
end