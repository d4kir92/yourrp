--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- #WHITELISTESETTINGS

net.Receive("getRoleWhitelist", function(len)
	if pa(settingsWindow.window) then
		function settingsWindow.window.site:Paint(pw, ph)
			--draw.RoundedBox(4, 0, 0, pw, ph, get_dbg_col())
			surfaceText(YRP.lang_string("LID_whitelist"), "roleInfoHeader", YRP.ctr(10), YRP.ctr(10 + 25), Color(255, 255, 255), 0, 1)
		end

		local _tmpWhiteList = net.ReadTable()
		local _tmpRoleList = net.ReadTable()
		local _tmpGroupList = net.ReadTable()

		local _whitelistListView = createD("DListView", settingsWindow.window.site, ScW() - YRP.ctr(20 + 10 + 500), ScrH() - YRP.ctr(180), YRP.ctr(10), YRP.ctr(10 + 50))
		_whitelistListView:AddColumn("uniqueID"):SetFixedWidth(YRP.ctr(200))
		_whitelistListView:AddColumn("SteamID"):SetFixedWidth(YRP.ctr(260))
		_whitelistListView:AddColumn(YRP.lang_string("LID_nick"))
		_whitelistListView:AddColumn(YRP.lang_string("LID_name"))
		_whitelistListView:AddColumn(YRP.lang_string("LID_group"))
		_whitelistListView:AddColumn(YRP.lang_string("LID_role"))
		_whitelistListView:AddColumn(YRP.lang_string("LID_time")):SetFixedWidth(YRP.ctr(260))
		_whitelistListView:AddColumn(YRP.lang_string("LID_status"))

		for k, v in pairs(_tmpWhiteList) do
			for l, w in pairs(_tmpRoleList) do
				if (w.uniqueID == v.roleID) then
					for m, x in pairs(_tmpGroupList) do
						if (x.uniqueID == w.int_groupID) then
							_whitelistListView:AddLine(v.uniqueID, v.SteamID, SQL_STR_OUT(v.nick), SQL_STR_OUT(v.name), x.string_name, w.string_name, v.date, v.status)
							break
						end
					end
					break
				elseif v.roleID == "-1" then
					for m, x in pairs(_tmpGroupList) do
						if (x.uniqueID == v.groupID) then
							_whitelistListView:AddLine(v.uniqueID, v.SteamID, SQL_STR_OUT(v.nick), SQL_STR_OUT(v.name), x.string_name, "", v.date, v.status)
							break
						elseif v.groupID == "-1" then
							_whitelistListView:AddLine(v.uniqueID, v.SteamID, SQL_STR_OUT(v.nick), SQL_STR_OUT(v.name), YRP.lang_string("LID_all"), YRP.lang_string("LID_all"), v.date, v.status)
							break
						end
					end
					break
				end
			end
		end

		local _buttonAdd = createD("YButton", settingsWindow.window.site, YRP.ctr(500), YRP.ctr(50), ScW() - YRP.ctr(10 + 500), YRP.ctr(60))
		_buttonAdd:SetText(YRP.lang_string("LID_addentry") .. " (" .. YRP.lang_string("LID_role") .. ")")
		function _buttonAdd:DoClick()
			local _whitelistFrame = createVGUI("DFrame", nil, 400, 500, 0, 0)
			_whitelistFrame:Center()
			_whitelistFrame:ShowCloseButton(true)
			_whitelistFrame:SetDraggable(true)
			_whitelistFrame:SetTitle("Whitelist")

			local _whitelistComboBoxPlys = createVGUI("DComboBox", _whitelistFrame, 380, 50, 10, 100)
			for k, v in pairs(player.GetAll()) do
				_whitelistComboBoxPlys:AddChoice(v:Nick(), v:SteamID())
			end

			local _whitelistComboBox = createVGUI("DComboBox", _whitelistFrame, 380, 50, 10, 200)
			for k, v in pairs(_tmpGroupList) do
				_whitelistComboBox:AddChoice(v.string_name, v.uniqueID)
			end

			local _whitelistComboBox2 = createVGUI("DComboBox", _whitelistFrame, 380, 50, 10, 300)
			function _whitelistComboBox:OnSelect()
				_whitelistComboBox2:Clear()
				for k, v in pairs(_tmpRoleList) do
					for l, w in pairs(_tmpGroupList) do
						if (_whitelistComboBox:GetOptionData(_whitelistComboBox:GetSelectedID()) == v.int_groupID) then
							_whitelistComboBox2:AddChoice(v.string_name, v.uniqueID)
							break
						end
					end
				end
			end

			local _whitelistButton = createVGUI("DButton", _whitelistFrame, 380, 50, 10, 400)
			_whitelistButton:SetText(YRP.lang_string("LID_whitelistplayer"))
			function _whitelistButton:DoClick()
				if _whitelistComboBoxPlys:GetOptionData(_whitelistComboBoxPlys:GetSelectedID()) != nil then
					net.Start("whitelistPlayer")
						local _cb1_id = _whitelistComboBoxPlys:GetSelectedID()
						local _cb2_id = _whitelistComboBox2:GetSelectedID()
						local _cb1_data = _whitelistComboBoxPlys:GetOptionData(_cb1_id)
						local _cb2_data = _whitelistComboBox2:GetOptionData(_cb2_id)
						if _cb1_data != nil and _cb2_data != nil then
							net.WriteString(_cb1_data)
							net.WriteInt(tonumber(_cb2_data), 16)
						end
					net.SendToServer()
				end
				_whitelistListView:Remove()
				_whitelistFrame:Close()
			end

			function _whitelistFrame:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, get_dbg_col())

				draw.SimpleTextOutlined(YRP.lang_string("LID_player") .. ":", "sef", YRP.ctr(10), YRP.ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
				draw.SimpleTextOutlined(YRP.lang_string("LID_group") .. ":", "sef", YRP.ctr(10), YRP.ctr(85+65), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
				draw.SimpleTextOutlined(YRP.lang_string("LID_role") .. ":", "sef", YRP.ctr(10), YRP.ctr(185+65), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
			end

			_whitelistFrame:MakePopup()
		end
		function _buttonAdd:Paint(pw, ph)
			hook.Run("YButtonPaint", self, pw, ph)
		end

		local _buttonAddGroup = createD("YButton", settingsWindow.window.site, YRP.ctr(500), YRP.ctr(50), ScW() - YRP.ctr(10 + 500), YRP.ctr(120))
		_buttonAddGroup:SetText(YRP.lang_string("LID_addentry") .. " (" .. YRP.lang_string("LID_group") .. ")")
		function _buttonAddGroup:DoClick()
			local _whitelistFrame = createVGUI("DFrame", nil, 400, 500, 0, 0)
			_whitelistFrame:Center()
			_whitelistFrame:ShowCloseButton(true)
			_whitelistFrame:SetDraggable(true)
			_whitelistFrame:SetTitle("Whitelist")

			local _whitelistComboBoxPlys = createVGUI("DComboBox", _whitelistFrame, 380, 50, 10, 100)
			for k, v in pairs(player.GetAll()) do
				_whitelistComboBoxPlys:AddChoice(v:Nick(), v:SteamID())
			end

			local _whitelistComboBox = createVGUI("DComboBox", _whitelistFrame, 380, 50, 10, 200)
			for k, v in pairs(_tmpGroupList) do
				_whitelistComboBox:AddChoice(v.string_name, v.uniqueID)
			end

			local _whitelistButton = createVGUI("DButton", _whitelistFrame, 380, 50, 10, 400)
			_whitelistButton:SetText(YRP.lang_string("LID_whitelistplayer"))
			function _whitelistButton:DoClick()
				if _whitelistComboBoxPlys:GetOptionData(_whitelistComboBoxPlys:GetSelectedID()) != nil then
					net.Start("whitelistPlayerGroup")
						net.WriteString(_whitelistComboBoxPlys:GetOptionData(_whitelistComboBoxPlys:GetSelectedID()))
						net.WriteInt(_whitelistComboBox:GetOptionData(_whitelistComboBox:GetSelectedID()), 16)
					net.SendToServer()
				end
				_whitelistListView:Remove()
				_whitelistFrame:Close()
			end

			function _whitelistFrame:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, get_dbg_col())

				draw.SimpleTextOutlined(YRP.lang_string("LID_player") .. ":", "sef", YRP.ctr(10), YRP.ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
				draw.SimpleTextOutlined(YRP.lang_string("LID_group") .. ":", "sef", YRP.ctr(10), YRP.ctr(85+65), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
			end

			_whitelistFrame:MakePopup()
		end
		function _buttonAddGroup:Paint(pw, ph)
			hook.Run("YButtonPaint", self, pw, ph)
		end

		local _buttonAddAll = createD("YButton", settingsWindow.window.site, YRP.ctr(500), YRP.ctr(50), ScW() - YRP.ctr(10 + 500), YRP.ctr(180))
		_buttonAddAll:SetText(YRP.lang_string("LID_addentry") .. " (" .. YRP.lang_string("LID_all") .. ")")
		function _buttonAddAll:DoClick()
			local _whitelistFrame = createVGUI("DFrame", nil, 400, 500, 0, 0)
			_whitelistFrame:Center()
			_whitelistFrame:ShowCloseButton(true)
			_whitelistFrame:SetDraggable(true)
			_whitelistFrame:SetTitle("Whitelist")

			local _whitelistComboBoxPlys = createVGUI("DComboBox", _whitelistFrame, 380, 50, 10, 100)
			for k, v in pairs(player.GetAll()) do
				_whitelistComboBoxPlys:AddChoice(v:Nick(), v:SteamID())
			end

			local _whitelistButton = createVGUI("DButton", _whitelistFrame, 380, 50, 10, 400)
			_whitelistButton:SetText(YRP.lang_string("LID_whitelistplayer"))
			function _whitelistButton:DoClick()
				if _whitelistComboBoxPlys:GetOptionData(_whitelistComboBoxPlys:GetSelectedID()) != nil then
					net.Start("whitelistPlayerAll")
						net.WriteString(_whitelistComboBoxPlys:GetOptionData(_whitelistComboBoxPlys:GetSelectedID()))
					net.SendToServer()
				end
				_whitelistListView:Remove()
				_whitelistFrame:Close()
			end

			function _whitelistFrame:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, get_dbg_col())

				draw.SimpleTextOutlined(YRP.lang_string("LID_player") .. ":", "sef", YRP.ctr(10), YRP.ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
			end

			_whitelistFrame:MakePopup()
		end
		function _buttonAddAll:Paint(pw, ph)
			hook.Run("YButtonPaint", self, pw, ph)
		end

		local _buttonRem = createD("YButton", settingsWindow.window.site, YRP.ctr(500), YRP.ctr(50), ScW() - YRP.ctr(10 + 500), YRP.ctr(240))
		_buttonRem:SetText(YRP.lang_string("LID_removeentry"))
		function _buttonRem:DoClick()
			if _whitelistListView:GetSelectedLine() != "" and _whitelistListView:GetSelectedLine() != nil then
				if _whitelistListView:GetLine(_whitelistListView:GetSelectedLine()):GetValue(1) != nil then
					net.Start("whitelistPlayerRemove")
						net.WriteInt(_whitelistListView:GetLine(_whitelistListView:GetSelectedLine()):GetValue(1) , 16)
					net.SendToServer()
					_whitelistListView:RemoveLine(_whitelistListView:GetSelectedLine())
				end
			end
		end
		function _buttonRem:Paint(pw, ph)
			hook.Run("YButtonPaint", self, pw, ph)
		end

		function _whitelistListView:OnRemove()
			_buttonAdd:Remove()
			_buttonRem:Remove()
		end
	end
end)

hook.Add("open_server_whitelist", "open_server_whitelist", function()
	SaveLastSite()
	local ply = LocalPlayer()

	local w = settingsWindow.window.sitepanel:GetWide()
	local h = settingsWindow.window.sitepanel:GetTall()

	settingsWindow.window.site = createD("DPanel", settingsWindow.window.sitepanel, w, h, 0, 0)

	net.Start("getRoleWhitelist")
	net.SendToServer()
end)
