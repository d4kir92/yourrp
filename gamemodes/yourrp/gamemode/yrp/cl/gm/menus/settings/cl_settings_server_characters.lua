--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

net.Receive( "setting_characters", function(len)
	local PARENT = GetSettingsSite()
	if pa(PARENT) and pa(YRPCharList) then
		local tab = net.ReadTable()

		--for n, y in pairs(tab) do
			if tab.SteamID != "BOT" then
				local event = tobool(tab.bool_eventchar)
				local archi = tobool(tab.bool_archived)
				local descr = ""
				if tab.rpdescription and tab.rpdescription != "nil" then
					descr = tostring(tab.rpdescription)
				end
				descr = descr

				YRPCharList:AddLine(tab.SteamID, tab.rpname, tab.text_idcardid, descr, tab.groupID, tab.roleID, tab.money, tab.moneybank, tab.int_level, event, archi)
			end
		--end
	end
end)

function OpenSettingsCharacters()
	local PARENT = GetSettingsSite()
	if pa(PARENT) then
		YRPCharList = YRPCreateD( "DListView", PARENT, PARENT:GetWide(), PARENT:GetTall(), 0, 0)
		YRPCharList:AddColumn( "SteamID" )
		YRPCharList:AddColumn(YRP.lang_string( "LID_name" ) )
		YRPCharList:AddColumn(YRP.lang_string( "LID_idcardid" ) )
		YRPCharList:AddColumn(YRP.lang_string( "LID_description" ) )
		YRPCharList:AddColumn(YRP.lang_string( "LID_group" ) )
		YRPCharList:AddColumn(YRP.lang_string( "LID_role" ) )
		YRPCharList:AddColumn(YRP.lang_string( "LID_money" ) ):SetFixedWidth(80)
		YRPCharList:AddColumn(YRP.lang_string( "LID_money" ) .. " (BANK)" ):SetFixedWidth(80)
		YRPCharList:AddColumn(YRP.lang_string( "LID_level" ) ):SetFixedWidth(50)
		YRPCharList:AddColumn(YRP.lang_string( "LID_event" ) ):SetFixedWidth(50)
		YRPCharList:AddColumn( "Archived" ):SetFixedWidth(50)

		function YRPCharList:OnRowRightClick(lineID, line)
			local _tmpSteamID = line:GetValue(1)
			local ply = nil
			for i, v in pairs(player.GetAll() ) do
				if v:YRPSteamID() == _tmpSteamID then
					ply = v
					break
				end
			end

			local tmpX, tmpY = gui.MousePos()
			tmpX = tmpX - YRP.ctr(4)
			tmpY = tmpY - YRP.ctr(4)
			local _tmpPanel = createVGUI( "DPanel", nil, 400 + 10 + 10, 10 + 50 + 10, tmpX * 2 - 10, tmpY * 2 - 10)
			_tmpPanel:SetPos(tmpX, tmpY)
			_tmpPanel.ready = false
			timer.Simple(0.2, function()
				_tmpPanel.ready = true
			end)

			local _buttonGetSteamID = createVGUI( "DButton", _tmpPanel, 400, 50, 10, 10)
			_buttonGetSteamID:SetText( "SteamID" )
			function _buttonGetSteamID:DoClick()
				SetClipboardText( line:GetValue(1) )
			end

			function _tmpPanel:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, get_ds_col() )
				if !_tmpPanel:IsHovered() and !_buttonGetSteamID:IsHovered() and _tmpPanel.ready == true then
					_tmpPanel:Remove()
				end
			end
			_tmpPanel:MakePopup()
		end

		net.Start( "setting_characters" )
		net.SendToServer()
	end
end
