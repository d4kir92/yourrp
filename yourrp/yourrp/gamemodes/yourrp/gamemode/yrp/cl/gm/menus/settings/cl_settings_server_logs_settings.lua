--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- #logs
function BuildLogsSettings(parent, typ)
	parent.list = YRPCreateD("DPanelList", parent, parent:GetWide(), parent:GetTall(), 0, 0)
	parent.list:EnableVerticalScrollbar()
	net.Start("nws_yrp_get_logs_settings")
	--net.WriteString(typ)
	net.SendToServer()
	net.Receive(
		"nws_yrp_get_logs_settings",
		function(len)
			local tab = net.ReadTable()
			if YRPPanelAlive(parent) then
				for i, v in pairs(tab) do
					local line = YRPCreateD("YPanel", nil, parent:GetWide(), YRP.ctr(60))
					local ts = YRPCreateD("YLabel", line, YRP.ctr(500), line:GetTall(), 0, 0)
					ts:SetText(os.date("%H:%M:%S - %d/%m/%Y", tonumber(v.string_timestamp)))
					if typ == "LID_settings" then
						local rt = YRPCreateD("RichText", line, parent:GetWide() - YRP.ctr(500), line:GetTall(), YRP.ctr(500), 0)
						function rt:PerformLayout()
							if self.SetUnderlineFont ~= nil then
								self:SetUnderlineFont("Y_18_500")
							end

							self:SetFontInternal("Y_18_500")
							self:SetBGColor(Color(0, 0, 0, 255))
						end

						rt:AppendText(v.string_text)
					end

					parent.list:AddItem(line)
				end
			end
		end
	)
end

function BuildLogsSiteSettings()
	local PARENT = GetSettingsSite()
	if YRPPanelAlive(PARENT) then
		-- TABS
		local tabs = YRPCreateD("YTabs", PARENT, PARENT:GetWide(), PARENT:GetTall(), 0, 0)
		tabs:AddOption(
			"LID_settings",
			function(parent)
				BuildLogsSettings(parent, "LID_settings")
			end
		)

		tabs:GoToSite("LID_settings")
	end
end

function OpenSettingsLogsSettings()
	BuildLogsSiteSettings()
end