--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- #WHITELISTESETTINGS

function BuildWhitelist(parent, tabW, tabR, tabG, tab)
	local list = createD("DListView", parent, parent:GetWide() - YRP.ctr(60 + 500), parent:GetTall() - YRP.ctr(40), YRP.ctr(20), YRP.ctr(20))
	list:AddColumn("uniqueID"):SetFixedWidth(80)
	list:AddColumn("SteamID"):SetFixedWidth(130)
	list:AddColumn(YRP.lang_string("LID_nick"))
	list:AddColumn(YRP.lang_string("LID_name"))
	list:AddColumn(YRP.lang_string("LID_group"))
	list:AddColumn(YRP.lang_string("LID_role"))
	list:AddColumn(YRP.lang_string("LID_time")):SetFixedWidth(130)
	list:AddColumn(YRP.lang_string("LID_status"))

	for k, whi in pairs(tabW) do
		tabW[k].uniqueID = tonumber(whi.uniqueID)
		tabW[k].roleID = tonumber(whi.roleID)
		tabW[k].groupID = tonumber(whi.groupID)
	end
	for l, rol in pairs(tabR) do
		tabR[l].uniqueID = tonumber(rol.uniqueID)
		tabR[l].int_groupID = tonumber(rol.int_groupID)
	end
	for m, grp in pairs(tabG) do
		tabG[m].uniqueID = tonumber(grp.uniqueID)
	end

	for k, whi in pairs(tabW) do
		local found = false
		if whi.roleID > 0 and (tab == "LID_all" or tab == "LID_roles") then -- ROLE
			for l, rol in pairs(tabR) do
				if found then
					break
				elseif (rol.uniqueID == whi.roleID) then
					for m, grp in pairs(tabG) do
						if (grp.uniqueID == rol.int_groupID) then -- ROLE
							list:AddLine(whi.uniqueID, whi.SteamID, SQL_STR_OUT(whi.nick), SQL_STR_OUT(whi.name), grp.string_name, rol.string_name, whi.date, whi.status)
							found = true
							break
						end
					end
				end
			end
		elseif whi.roleID < 0 and whi.groupID > 0 and (tab == "LID_all" or tab == "LID_groups") then -- GROUP
			for m, grp in pairs(tabG) do
				if (grp.uniqueID == whi.groupID) then
					list:AddLine(whi.uniqueID, whi.SteamID, SQL_STR_OUT(whi.nick), SQL_STR_OUT(whi.name), grp.string_name, "-", whi.date, whi.status)
					found = true
					break
				end
			end
		elseif (tab == "LID_all") then -- ALL
			list:AddLine(whi.uniqueID, whi.SteamID, SQL_STR_OUT(whi.nick), SQL_STR_OUT(whi.name), YRP.lang_string("LID_all"), YRP.lang_string("LID_all"), whi.date, whi.status)
			found = true
		else
			local rolname = "-"
			local grpname = "-"
			if whi.roleID > 0 then
				for l, rol in pairs(tabR) do
					if (rol.uniqueID == whi.roleID) then
						rolname = rol.string_name
						break
					end
				end
			end
			if whi.groupID > 0 then
				for m, grp in pairs(tabG) do
					if (grp.uniqueID == whi.groupID) then
						grpname = grp.string_name
					end
				end
			end
			if grpname == "-" and rolname == "-" then
				grpname = YRP.lang_string("LID_all")
				rolname = YRP.lang_string("LID_all")
			end
			if string.StartWith(whi.status, "Manually") and tab == "LID_manually" then
				list:AddLine(whi.uniqueID, whi.SteamID, SQL_STR_OUT(whi.nick), SQL_STR_OUT(whi.name), grpname, rolname, whi.date, whi.status)
				found = true
			elseif string.StartWith(whi.status, "Promoted") and tab == "LID_promote" then
				list:AddLine(whi.uniqueID, whi.SteamID, SQL_STR_OUT(whi.nick), SQL_STR_OUT(whi.name), grpname, rolname, whi.date, whi.status)
				found = true
			end
		end
	end

	local btnAdd = createD("YButton", parent, YRP.ctr(500), YRP.ctr(50), ScW() - YRP.ctr(20 + 500), YRP.ctr(20))
	btnAdd:SetText(YRP.lang_string("LID_addentry") .. " (" .. YRP.lang_string("LID_role") .. ")")
	function btnAdd:DoClick()
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
		for k, v in pairs(tabG) do
			_whitelistComboBox:AddChoice(v.string_name, v.uniqueID)
		end

		local _whitelistComboBox2 = createVGUI("DComboBox", _whitelistFrame, 380, 50, 10, 300)
		function _whitelistComboBox:OnSelect()
			_whitelistComboBox2:Clear()
			for k, v in pairs(tabR) do
				for l, w in pairs(tabG) do
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
			list:Remove()
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
	function btnAdd:Paint(pw, ph)
		hook.Run("YButtonPaint", self, pw, ph)
	end

	local btnGroup = createD("YButton", parent, YRP.ctr(500), YRP.ctr(50), ScW() - YRP.ctr(20 + 500), YRP.ctr(90))
	btnGroup:SetText(YRP.lang_string("LID_addentry") .. " (" .. YRP.lang_string("LID_group") .. ")")
	function btnGroup:DoClick()
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
		for k, v in pairs(tabG) do
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
			list:Remove()
			_whitelistFrame:Close()
		end

		function _whitelistFrame:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, get_dbg_col())

			draw.SimpleTextOutlined(YRP.lang_string("LID_player") .. ":", "sef", YRP.ctr(10), YRP.ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
			draw.SimpleTextOutlined(YRP.lang_string("LID_group") .. ":", "sef", YRP.ctr(10), YRP.ctr(85+65), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		end

		_whitelistFrame:MakePopup()
	end
	function btnGroup:Paint(pw, ph)
		hook.Run("YButtonPaint", self, pw, ph)
	end

	local btnAll = createD("YButton", parent, YRP.ctr(500), YRP.ctr(50), ScW() - YRP.ctr(20 + 500), YRP.ctr(160))
	btnAll:SetText(YRP.lang_string("LID_addentry") .. " (" .. YRP.lang_string("LID_all") .. ")")
	function btnAll:DoClick()
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
			list:Remove()
			_whitelistFrame:Close()
		end

		function _whitelistFrame:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, get_dbg_col())

			draw.SimpleTextOutlined(YRP.lang_string("LID_player") .. ":", "sef", YRP.ctr(10), YRP.ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		end

		_whitelistFrame:MakePopup()
	end
	function btnAll:Paint(pw, ph)
		hook.Run("YButtonPaint", self, pw, ph)
	end

	local btnRem = createD("YButton", parent, YRP.ctr(500), YRP.ctr(50), ScW() - YRP.ctr(20 + 500), YRP.ctr(230))
	btnRem:SetText(YRP.lang_string("LID_removeentry"))
	function btnRem:DoClick()
		if list:GetSelectedLine() != nil then
			if list:GetLine(list:GetSelectedLine()):GetValue(1) != nil then
				net.Start("whitelistPlayerRemove")
					net.WriteInt(list:GetLine(list:GetSelectedLine()):GetValue(1) , 16)
				net.SendToServer()
				list:RemoveLine(list:GetSelectedLine())
			end
		end
	end
	function btnRem:Paint(pw, ph)
		if list:GetSelectedLine() != nil then
			hook.Run("YButtonPaint", self, pw, ph)
		end
	end

	function list:OnRemove()
		btnAdd:Remove()
		btnRem:Remove()
	end
end

net.Receive("getRoleWhitelist", function(len)
	if pa(settingsWindow.window) then
		function settingsWindow.window.site:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(40, 40, 40, 255))
		end

		local site = settingsWindow.window.site

		local tabW = net.ReadTable()
		local tabR = net.ReadTable()
		local tabG = net.ReadTable()

		-- TABS
		local tabs = createD("YTabs", site, site:GetWide(), site:GetTall(), 0, 0)

		tabs:AddOption("LID_all", function(parent)
			BuildWhitelist(parent, tabW, tabR, tabG, "LID_all")
		end)
		tabs:AddOption("LID_roles", function(parent)
			BuildWhitelist(parent, tabW, tabR, tabG, "LID_roles")
		end)
		tabs:AddOption("LID_groups", function(parent)
			BuildWhitelist(parent, tabW, tabR, tabG, "LID_groups")
		end)
		tabs:AddOption("LID_manually", function(parent)
			BuildWhitelist(parent, tabW, tabR, tabG, "LID_manually")
		end)
		tabs:AddOption("LID_promote", function(parent)
			BuildWhitelist(parent, tabW, tabR, tabG, "LID_promote")
		end)


		tabs:GoToSite("LID_all")		
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
