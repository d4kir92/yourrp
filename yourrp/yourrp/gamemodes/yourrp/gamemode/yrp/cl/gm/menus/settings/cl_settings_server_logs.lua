--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- #logs
function GetPlayerBySteamID(steamid)
	for i, ply in pairs(player.GetAll()) do
		if ply:SteamID() == steamid or ply:SteamID64() == steamid then return ply end
	end

	return NULL
end

function BuildLogs(parent, typ)
	parent.list = YRPCreateD("DPanelList", parent, parent:GetWide(), parent:GetTall(), 0, 0)
	parent.list:EnableVerticalScrollbar()
	net.Start("nws_yrp_get_logs")
	net.WriteString(typ)
	net.SendToServer()
	net.Receive(
		"nws_yrp_get_logs",
		function(len)
			if YRPPanelAlive(parent) then
				local tab = net.ReadTable()
				for i, v in pairs(tab) do
					local source = GetPlayerBySteamID(v.string_source_steamid)
					local target = GetPlayerBySteamID(v.string_target_steamid)
					if IsNotNilAndNotFalse(source) then
						local line = YRPCreateD("YPanel", nil, parent:GetWide(), YRP:ctr(50))
						local ts = YRPCreateD("YLabel", line, YRP:ctr(500), line:GetTall(), 0, 0)
						ts:SetText(os.date("%H:%M:%S - %d/%m/%Y", tonumber(v.string_timestamp)))
						if typ == "LID_chat" then
							local rt = YRPCreateD("RichText", line, parent:GetWide() - YRP:ctr(500), line:GetTall(), YRP:ctr(500), 0)
							function rt:PerformLayout()
								if self.SetUnderlineFont ~= nil then
									self:SetUnderlineFont("Y_18_500")
								end

								self:SetFontInternal("Y_18_500")
								self:SetBGColor(Color(0, 0, 0, 255))
							end

							function rt:ActionSignal(signalName, signalValue)
								if signalName == "TextClicked" then
									if (signalValue == v.string_source_steamid) and source:IsPlayer() then
										source:ShowProfile()
									elseif signalValue == v.string_target_steamid then
										target:ShowProfile()
									end
								end
							end

							if IsNotNilAndNotFalse(v.string_source_steamid) then
								rt:InsertColorChange(100, 100, 255, 255)
								rt:InsertClickableTextStart(tostring(v.string_source_steamid))
							else
								rt:InsertColorChange(255, 100, 100, 255)
								rt:AppendText("Missing Source SteamID")
							end

							if source.RPName ~= nil then
								rt:AppendText(source:RPName())
							else
								rt:AppendText(tostring(v.string_source_steamid))
							end

							rt:InsertClickableTextEnd()
							rt:InsertColorChange(255, 255, 255, 255)
							rt:AppendText(": " .. tostring(v.string_value))
						elseif typ == "LID_connections" then
							local rt = YRPCreateD("RichText", line, parent:GetWide() - YRP:ctr(500), line:GetTall(), YRP:ctr(500), 0)
							function rt:PerformLayout()
								self.m_FontName = "Y_18_500"
								if self.SetUnderlineFont ~= nil then
									self:SetUnderlineFont("Y_18_500")
								end

								self:SetFontInternal("Y_18_500")
								self:SetBGColor(Color(0, 0, 0, 255))
							end

							function rt:ActionSignal(signalName, signalValue)
								if signalName == "TextClicked" then
									if source ~= nil and (signalValue == v.string_source_steamid) and source:IsPlayer() then
										source:ShowProfile()
									elseif signalValue == v.string_target_steamid then
										target:ShowProfile()
									end
								end
							end

							if IsNotNilAndNotFalse(v.string_source_steamid) then
								rt:InsertColorChange(100, 100, 255, 255)
								rt:InsertClickableTextStart(tostring(v.string_source_steamid))
							else
								rt:InsertColorChange(255, 100, 100, 255)
								rt:AppendText("Missing Source SteamID")
							end

							if source.RPName ~= nil then
								rt:AppendText(source:RPName())
							else
								rt:AppendText(tostring(v.string_source_steamid))
							end

							rt:InsertClickableTextEnd()
							rt:InsertColorChange(255, 255, 255, 255)
							rt:AppendText(" " .. tostring(v.string_value))
						elseif typ == "LID_kills" then
							local rt = YRPCreateD("RichText", line, parent:GetWide() - YRP:ctr(500), line:GetTall(), YRP:ctr(500), 0)
							function rt:PerformLayout()
								self.m_FontName = "Y_18_500"
								if self.SetUnderlineFont ~= nil then
									self:SetUnderlineFont("Y_18_500")
								end

								self:SetFontInternal("Y_18_500")
								self:SetBGColor(Color(0, 0, 0, 255))
							end

							function rt:ActionSignal(signalName, signalValue)
								if signalName == "TextClicked" then
									if (signalValue == v.string_source_steamid) and source:IsPlayer() then
										source:ShowProfile()
									elseif signalValue == v.string_target_steamid then
										if IsValid(target) then
											target:ShowProfile()
										end
									end
								end
							end

							if IsNotNilAndNotFalse(v.string_source_steamid) then
								rt:InsertColorChange(100, 100, 255, 255)
								rt:InsertClickableTextStart(tostring(v.string_source_steamid))
							else
								rt:InsertColorChange(255, 100, 100, 255)
								rt:AppendText("Missing Source SteamID")
							end

							if source.RPName then
								rt:AppendText(source:RPName())
							else
								rt:AppendText(tostring(v.string_source_steamid))
							end

							rt:InsertClickableTextEnd()
							rt:InsertColorChange(255, 255, 255, 255)
							rt:AppendText(" " .. "killed" .. " ")
							rt:InsertColorChange(100, 100, 255, 255)
							if target.RPName then
								rt:AppendText(target:RPName())
							else
								rt:InsertClickableTextStart(v.string_target_steamid)
								rt:AppendText(v.string_target_steamid)
							end

							rt:InsertClickableTextEnd()
						elseif typ == "LID_whitelist" then
							local rt = YRPCreateD("RichText", line, parent:GetWide() - YRP:ctr(500), line:GetTall(), YRP:ctr(500), 0)
							function rt:PerformLayout()
								self.m_FontName = "Y_18_500"
								if self.SetUnderlineFont ~= nil then
									self:SetUnderlineFont("Y_18_500")
								end

								self:SetFontInternal("Y_18_500")
								self:SetBGColor(Color(0, 0, 0, 255))
							end

							function rt:ActionSignal(signalName, signalValue)
								if (signalName == "TextClicked") and IsValid(target) then
									if (signalValue == v.string_source_steamid) and source:IsPlayer() then
										source:ShowProfile()
									elseif signalValue == v.string_target_steamid then
										target:ShowProfile()
									end
								end
							end

							if IsNotNilAndNotFalse(v.string_source_steamid) then
								rt:InsertColorChange(100, 100, 255, 255)
								rt:InsertClickableTextStart(tostring(v.string_source_steamid))
							else
								rt:InsertColorChange(255, 100, 100, 255)
								rt:AppendText("Missing Source SteamID")
							end

							if source.RPName then
								rt:AppendText(source:RPName())
							else
								rt:AppendText(tostring(v.string_source_steamid))
							end

							rt:InsertClickableTextEnd()
							rt:InsertColorChange(255, 255, 255, 255)
							rt:AppendText(" " .. "whitelisted" .. " ")
							if IsNotNilAndNotFalse(v.string_source_steamid) then
								rt:InsertColorChange(100, 100, 255, 255)
								rt:InsertClickableTextStart(tostring(v.string_target_steamid))
								rt:InsertClickableTextEnd()
							elseif target.RPName then
								rt:AppendText(target:RPName())
							end

							rt:InsertColorChange(255, 255, 255, 255)
							rt:AppendText(" [" .. tostring(v.string_value) .. "] ")
						elseif typ == "LID_spawns" then
							local rt = YRPCreateD("RichText", line, parent:GetWide() - YRP:ctr(500), line:GetTall(), YRP:ctr(500), 0)
							function rt:PerformLayout()
								self.m_FontName = "Y_18_500"
								if self.SetUnderlineFont ~= nil then
									self:SetUnderlineFont("Y_18_500")
								end

								self:SetFontInternal("Y_18_500")
								self:SetBGColor(Color(0, 0, 0, 255))
							end

							function rt:ActionSignal(signalName, signalValue)
								if signalName == "TextClicked" then
									if (signalValue == v.string_source_steamid) and source:IsPlayer() then
										source:ShowProfile()
									elseif signalValue == v.string_target_steamid then
										target:ShowProfile()
									end
								end
							end

							if IsNotNilAndNotFalse(v.string_source_steamid) then
								rt:InsertColorChange(100, 100, 255, 255)
								rt:InsertClickableTextStart(tostring(v.string_source_steamid))
							else
								rt:InsertColorChange(255, 100, 100, 255)
								rt:AppendText("Missing Source SteamID")
							end

							if source.RPName then
								rt:AppendText(source:RPName())
							else
								rt:AppendText(tostring(v.string_source_steamid))
							end

							rt:InsertClickableTextEnd()
							if IsNotNilAndNotFalse(v.string_value) then
								rt:InsertColorChange(255, 255, 255, 255)
								rt:AppendText(" " .. v.string_value)
							else
								rt:InsertColorChange(255, 100, 100, 255)
								rt:AppendText("Missing VALUE")
							end
						elseif typ == "LID_health" then
							local rt = YRPCreateD("RichText", line, parent:GetWide() - YRP:ctr(500), line:GetTall(), YRP:ctr(500), 0)
							function rt:PerformLayout()
								self.m_FontName = "Y_18_500"
								if self.SetUnderlineFont ~= nil then
									self:SetUnderlineFont("Y_18_500")
								end

								self:SetFontInternal("Y_18_500")
								self:SetBGColor(Color(0, 0, 0, 255))
							end

							function rt:ActionSignal(signalName, signalValue)
								if signalName == "TextClicked" then
									if (signalValue == v.string_source_steamid) and source:IsPlayer() then
										source:ShowProfile()
									elseif (signalValue == v.string_target_steamid) and target:IsPlayer() then
										target:ShowProfile()
									end
								end
							end

							if source.RPName then
								if IsNotNilAndNotFalse(v.string_source_steamid) then
									rt:InsertColorChange(100, 100, 255, 255)
									rt:InsertClickableTextStart(tostring(v.string_source_steamid))
								else
									rt:InsertColorChange(255, 100, 100, 255)
									rt:AppendText("Missing Source SteamID")
								end

								if source.RPName then
									rt:AppendText(source:RPName())
								else
									rt:AppendText(tostring(v.string_source_steamid))
								end

								rt:InsertClickableTextEnd()
								rt:InsertColorChange(255, 255, 255, 255)
								rt:AppendText(" does " .. tostring(v.string_value) .. " damage to ")
								rt:InsertColorChange(100, 100, 255, 255)
								rt:InsertClickableTextStart(tostring(v.string_target_steamid))
								if target.RPName then
									rt:AppendText(target:RPName())
								else
									rt:AppendText(tostring(v.string_target_steamid))
								end

								rt:InsertClickableTextEnd()
							else
								rt:InsertColorChange(100, 100, 255, 255)
								rt:AppendText(tostring(v.string_alttarget))
								rt:InsertColorChange(255, 255, 255, 255)
								rt:AppendText(" does " .. tostring(v.string_value) .. " damage to ")
								rt:InsertColorChange(100, 100, 255, 255)
								rt:InsertClickableTextStart(tostring(v.string_target_steamid))
								if target.RPName then
									rt:AppendText(target:RPName())
								else
									rt:AppendText(tostring(v.string_target_steamid))
								end

								rt:InsertClickableTextEnd()
							end
						elseif typ == "LID_health" then
							local rt = YRPCreateD("RichText", line, parent:GetWide() - YRP:ctr(500), line:GetTall(), YRP:ctr(500), 0)
							function rt:PerformLayout()
								self.m_FontName = "Y_18_500"
								if self.SetUnderlineFont ~= nil then
									self:SetUnderlineFont("Y_18_500")
								end

								self:SetFontInternal("Y_18_500")
								self:SetBGColor(Color(0, 0, 0, 255))
							end

							function rt:ActionSignal(signalName, signalValue)
								if signalName == "TextClicked" then
									if (signalValue == v.string_source_steamid) and source:IsPlayer() then
										source:ShowProfile()
									elseif (signalValue == v.string_target_steamid) and target:IsPlayer() then
										target:ShowProfile()
									end
								end
							end

							if IsNotNilAndNotFalse(v.string_source_steamid) then
								rt:InsertColorChange(100, 100, 255, 255)
								rt:InsertClickableTextStart(tostring(v.string_source_steamid))
							else
								rt:InsertColorChange(255, 100, 100, 255)
								rt:AppendText("Missing Source SteamID")
							end

							if source.RPName then
								rt:AppendText(source:RPName())
							else
								rt:AppendText(tostring(v.string_source_steamid))
							end

							rt:InsertClickableTextEnd()
							rt:InsertColorChange(255, 255, 255, 255)
							rt:AppendText(" arrested ")
							rt:InsertColorChange(100, 100, 255, 255)
							rt:InsertClickableTextStart(v.string_target_steamid)
							if target.RPName then
								rt:AppendText(target:RPName())
							else
								rt:AppendText(v.string_target_steamid)
							end

							rt:InsertClickableTextEnd()
						end

						parent.list:AddItem(line)
					end
				end
			end
		end
	)
end

function BuildLogsSite()
	local PARENT = GetSettingsSite()
	if YRPPanelAlive(PARENT) then
		-- TABS
		local tabs = YRPCreateD("YTabs", PARENT, PARENT:GetWide(), PARENT:GetTall(), 0, 0)
		tabs:AddOption(
			"LID_kills",
			function(parent)
				BuildLogs(parent, "LID_kills")
			end
		)

		tabs:AddOption(
			"LID_health",
			function(parent)
				BuildLogs(parent, "LID_health")
			end
		)

		tabs:AddOption(
			"LID_chat",
			function(parent)
				BuildLogs(parent, "LID_chat")
			end
		)

		tabs:AddOption(
			"LID_arrests",
			function(parent)
				BuildLogs(parent, "LID_arrests")
			end
		)

		tabs:AddOption(
			"LID_connections",
			function(parent)
				BuildLogs(parent, "LID_connections")
			end
		)

		tabs:AddOption(
			"LID_whitelist",
			function(parent)
				BuildLogs(parent, "LID_whitelist")
			end
		)

		tabs:AddOption(
			"LID_spawns",
			function(parent)
				BuildLogs(parent, "LID_spawns")
			end
		)

		tabs:GoToSite("LID_kills")
	end
end

function OpenSettingsLogs()
	BuildLogsSite()
end
