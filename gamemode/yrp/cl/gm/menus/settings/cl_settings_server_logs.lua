--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- #logs

function GetPlayerBySteamID64(steamid64)
	for i, ply in pairs(player.GetAll()) do
		if ply:SteamID64() == steamid64 then
			return ply
		end
	end
	return NULL
end

function BuildLogs(parent, typ)
	parent.list = createD("DPanelList", parent, parent:GetWide(), parent:GetTall(), 0, 0)
	parent.list:EnableVerticalScrollbar()

	net.Start("yrp_get_logs")
		net.WriteString(typ)
	net.SendToServer()

	net.Receive("yrp_get_logs", function(len)
		local tab = net.ReadTable()
		if pa(parent) then
			for i, v in pairs(tab) do
				local source = GetPlayerBySteamID64(v.string_source_steamid)
				local target = GetPlayerBySteamID64(v.string_target_steamid)
				if source != NULL then
					local line = createD("YPanel", nil, parent:GetWide(), YRP.ctr(50))



					local ts = createD("YLabel", line, YRP.ctr(400), line:GetTall(), 0, 0)
					ts:SetText(os.date("%H:%M:%S - %d/%m/%Y", tonumber(v.string_timestamp)))



					if typ == "LID_chat" then
						local rt = createD("RichText", line, parent:GetWide() - YRP.ctr(400), line:GetTall(), YRP.ctr(400), 0)
						function rt:PerformLayout()
							if self.SetUnderlineFont != nil then
								self:SetUnderlineFont("Y_18_500")
							end
							self:SetFontInternal("Y_18_500")
							self:SetBGColor(Color(0, 0, 0))
						end
						function rt:ActionSignal(signalName, signalValue)
							if ( signalName == "TextClicked" ) then
								if ( signalValue == v.string_source_steamid ) and source:IsPlayer() then
									gui.OpenURL(source:ShowProfile()) 
								elseif ( signalValue == v.string_target_steamid ) then
									gui.OpenURL(target:ShowProfile()) 
								end
							end
						end

						rt:InsertColorChange(100, 100, 255, 255)
						rt:InsertClickableTextStart(v.string_source_steamid)
						rt:AppendText(source:RPName())
						rt:InsertClickableTextEnd()

						rt:InsertColorChange(255, 255, 255, 255)
						rt:AppendText(": " .. SQL_STR_OUT(v.string_value))
					elseif typ == "LID_connections" then
						local rt = createD("RichText", line, parent:GetWide() - YRP.ctr(400), line:GetTall(), YRP.ctr(400), 0)
						function rt:PerformLayout()
							self.m_FontName = "Y_18_500"
							if self.SetUnderlineFont != nil then
								self:SetUnderlineFont("Y_18_500")
							end
							self:SetFontInternal("Y_18_500")
							self:SetBGColor(Color(0, 0, 0))
						end
						function rt:ActionSignal(signalName, signalValue)
							if ( signalName == "TextClicked" ) then
								if ( signalValue == v.string_source_steamid ) and source:IsPlayer() then
									gui.OpenURL(source:ShowProfile()) 
								elseif ( signalValue == v.string_target_steamid ) then
									gui.OpenURL(target:ShowProfile()) 
								end
							end
						end

						rt:InsertColorChange(100, 100, 255, 255)
						rt:InsertClickableTextStart(v.string_source_steamid)
						rt:AppendText(source:RPName())
						rt:InsertClickableTextEnd()

						rt:InsertColorChange(255, 255, 255, 255)
						rt:AppendText(" " .. SQL_STR_OUT(v.string_value))
					elseif typ == "LID_kills" then
						local rt = createD("RichText", line, parent:GetWide() - YRP.ctr(400), line:GetTall(), YRP.ctr(400), 0)
						function rt:PerformLayout()
							self.m_FontName = "Y_18_500"
							if self.SetUnderlineFont != nil then
								self:SetUnderlineFont("Y_18_500")
							end
							self:SetFontInternal("Y_18_500")
							self:SetBGColor(Color(0, 0, 0))
						end
						function rt:ActionSignal(signalName, signalValue)
							if ( signalName == "TextClicked" ) then
								if ( signalValue == v.string_source_steamid ) and source:IsPlayer() then
									gui.OpenURL(source:ShowProfile()) 
								elseif ( signalValue == v.string_target_steamid ) then
									gui.OpenURL(target:ShowProfile()) 
								end
							end
						end

						rt:InsertColorChange(100, 100, 255, 255)
						rt:InsertClickableTextStart(v.string_source_steamid)
						rt:AppendText(source:RPName())
						rt:InsertClickableTextEnd()

						rt:InsertColorChange(255, 255, 255, 255)
						rt:AppendText(" " .. "killed" .. " ")

						rt:InsertColorChange(100, 100, 255, 255)
						rt:InsertClickableTextStart(v.string_target_steamid)
						if target.RPName then
							rt:AppendText(target:RPName())
						else
							rt:AppendText(v.string_target_steamid)
						end
						rt:InsertClickableTextEnd()
					elseif typ == "LID_whitelist" then
						local rt = createD("RichText", line, parent:GetWide() - YRP.ctr(400), line:GetTall(), YRP.ctr(400), 0)
						function rt:PerformLayout()
							self.m_FontName = "Y_18_500"
							if self.SetUnderlineFont != nil then
								self:SetUnderlineFont("Y_18_500")
							end
							self:SetFontInternal("Y_18_500")
							self:SetBGColor(Color(0, 0, 0))
						end
						function rt:ActionSignal(signalName, signalValue)
							if ( signalName == "TextClicked" ) then
								if ( signalValue == v.string_source_steamid ) and source:IsPlayer() then
									gui.OpenURL(source:ShowProfile()) 
								elseif ( signalValue == v.string_target_steamid ) then
									gui.OpenURL(target:ShowProfile()) 
								end
							end
						end

						rt:InsertColorChange(100, 100, 255, 255)
						rt:InsertClickableTextStart(v.string_source_steamid)
						rt:AppendText(source:RPName())
						rt:InsertClickableTextEnd()

						rt:InsertColorChange(255, 255, 255, 255)
						rt:AppendText(" " .. "whitelisted" .. " ")

						rt:InsertColorChange(100, 100, 255, 255)
						rt:InsertClickableTextStart(v.string_target_steamid)
						if target.RPName then
							rt:AppendText(target:RPName())
						else
							rt:AppendText(v.string_target_steamid)
						end
						rt:InsertClickableTextEnd()

						rt:InsertColorChange(255, 255, 255, 255)
						rt:AppendText(" [" .. SQL_STR_OUT(v.string_value) .. "] ")
					end
					


					parent.list:AddItem(line)
				end
			end
		end
	end)
end

function BuildLogsSite()
	if pa(settingsWindow.window) then

		local site = settingsWindow.window.site

		-- TABS
		local tabs = createD("YTabs", site, site:GetWide(), site:GetTall(), 0, 0)

		tabs:AddOption("LID_kills", function(parent)
			BuildLogs(parent, "LID_kills")
		end)
		--[[tabs:AddOption("LID_health", function(parent)
			--BuildLogs(parent, tabW, tabR, tabG, "LID_all")
		end)]]
		tabs:AddOption("LID_chat", function(parent)
			BuildLogs(parent, "LID_chat")
		end)
		--[[tabs:AddOption("LID_commands", function(parent)
			BuildLogs(parent, "LID_commands")
		end)]]
		--[[tabs:AddOption("LID_arrests", function(parent)
			--BuildLogs(parent, tabW, tabR, tabG, "LID_manually")
		end)]]
		tabs:AddOption("LID_connections", function(parent)
			BuildLogs(parent, "LID_connections")
		end)
		tabs:AddOption("LID_whitelist", function(parent)
			BuildLogs(parent, "LID_whitelist")
		end)
		--[[tabs:AddOption("LID_spawns", function(parent)
			--BuildLogs(parent, tabW, tabR, tabG, "LID_promote")
		end)]]

		tabs:GoToSite("LID_kills")		
	end
end

hook.Add("open_server_logs", "open_server_logs", function()
	SaveLastSite()
	local ply = LocalPlayer()

	BuildLogsSite()
end)
