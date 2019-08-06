--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

net.Receive("setting_players", function(len)
	if pa(settingsWindow.window) then
		function settingsWindow.window.site:Paint(pw, ph)
			--draw.RoundedBox(4, 0, 0, pw, ph, get_dbg_col())
			surfaceText(YRP.lang_string("LID_players"), "roleInfoHeader", YRP.ctr(10), YRP.ctr(10 + 25), Color(255, 255, 255), 0, 1)
		end

		local _giveListView = createD("DListView", settingsWindow.window.site, ScW() - YRP.ctr(20), ScrH() - YRP.ctr(180), YRP.ctr(10), YRP.ctr(10 + 50))
		_giveListView:AddColumn("SteamID")
		_giveListView:AddColumn(YRP.lang_string("LID_nick"))
		_giveListView:AddColumn(YRP.lang_string("LID_name"))
		_giveListView:AddColumn(YRP.lang_string("LID_group"))
		_giveListView:AddColumn(YRP.lang_string("LID_role"))
		_giveListView:AddColumn(YRP.lang_string("LID_money"))

		for n, y in pairs(player.GetAll()) do
			_giveListView:AddLine(y:SteamID(), y:SteamName(), y:RPName(), y:GetDString("groupName"), y:GetDString("roleName"), y:GetDInt("money"))
		end

		function _giveListView:OnRowRightClick(lineID, line)
			local _tmpSteamID = line:GetValue(1)
			local tmpX, tmpY = gui.MousePos()
			tmpX = tmpX - YRP.ctr(4)
			tmpY = tmpY - YRP.ctr(4)
			local _tmpPanel = createVGUI("DPanel", nil, 400 + 10 + 10, 10 + 50 + 10, tmpX * 2 - 10, tmpY * 2 - 10)
			_tmpPanel:SetPos(tmpX, tmpY)
			_tmpPanel.ready = false
			timer.Simple(0.2, function()
				_tmpPanel.ready = true
			end)

			local _buttonRole = createVGUI("DButton", _tmpPanel, 400, 50, 10, 10)
			_buttonRole:SetText(YRP.lang_string("LID_giverole"))
			function _buttonRole:DoClick()
				local _giveFrame = createVGUI("DFrame", nil, 400, 305, 0, 0)
				_giveFrame:Center()
				_giveFrame:ShowCloseButton(true)
				_giveFrame:SetDraggable(true)
				_giveFrame:SetTitle(YRP.lang_string("LID_giverole"))

				local _giveComboBox = createVGUI("DComboBox", _giveFrame, 380, 50, 10, 85)

				net.Receive("give_getGroTab", function(le)
					if pa(_giveComboBox) then
						local _tmpGroupList = net.ReadTable()
						for k, v in pairs(_tmpGroupList) do
							_giveComboBox:AddChoice(v.string_name, v.uniqueID)
						end
					end
				end)
				net.Start("give_getGroTab")
				net.SendToServer()

				local _giveComboBox2 = createVGUI("DComboBox", _giveFrame, 380, 50, 10, 185)
				function _giveComboBox:OnSelect(panel, index, value)
					if pa(_giveComboBox2) then
						_giveComboBox2:Clear()
						net.Start("give_getRolTab")
							net.WriteString(tostring(value))
						net.SendToServer()
						net.Receive("give_getRolTab", function(le)
							local _tmpRolTab = net.ReadTable()
							for k, v in pairs(_tmpRolTab) do
								_giveComboBox2:AddChoice(v.string_name, v.uniqueID)
							end
						end)
					end
				end

				local _giveButton = createVGUI("DButton", _giveFrame, 380, 50, 10, 185 + 60)
				_giveButton:SetText(YRP.lang_string("LID_give"))
				function _giveButton:DoClick()
					if isnumber(tonumber(_giveComboBox2:GetOptionData(_giveComboBox2:GetSelectedID()))) then
						net.Start("giveRole")
							net.WriteString(_tmpSteamID)
							net.WriteInt(_giveComboBox2:GetOptionData(_giveComboBox2:GetSelectedID()), 16)
						net.SendToServer()
						_giveFrame:Close()
					end
				end

				function _giveFrame:Paint(pw, ph)
					draw.RoundedBox(0, 0, 0, pw, ph, get_dbg_col())

					draw.SimpleTextOutlined(YRP.lang_string("LID_group") .. ":", "sef", YRP.ctr(10), YRP.ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
					draw.SimpleTextOutlined(YRP.lang_string("LID_role") .. ":", "sef", YRP.ctr(10), YRP.ctr(85 + 65), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
				end

				_giveFrame:MakePopup()
			end

			function _tmpPanel:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, get_ds_col())
				if !_tmpPanel:IsHovered() and !_buttonRole:IsHovered() and _tmpPanel.ready == true then
					_tmpPanel:Remove()
				end
			end
			_tmpPanel:MakePopup()
		end
	end
end)

hook.Add("open_server_give", "open_server_give", function()
	SaveLastSite()

	local w = settingsWindow.window.sitepanel:GetWide()
	local h = settingsWindow.window.sitepanel:GetTall()

	settingsWindow.window.site = createD("DPanel", settingsWindow.window.sitepanel, w, h, 0, 0)

	net.Start("setting_players")
	net.SendToServer()
end)
