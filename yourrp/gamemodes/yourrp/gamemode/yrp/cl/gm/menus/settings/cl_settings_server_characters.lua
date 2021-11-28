--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

net.Receive("setting_characters", function(len)
	local PARENT = GetSettingsSite()
	if pa(PARENT) then
		local tab = net.ReadTable()

		local charlist = createD("DListView", PARENT, PARENT:GetWide(), PARENT:GetTall(), 0, 0)
		charlist:AddColumn("SteamID")
		charlist:AddColumn(YRP.lang_string("LID_name"))
		charlist:AddColumn(YRP.lang_string("LID_idcardid"))
		charlist:AddColumn(YRP.lang_string("LID_description"))
		charlist:AddColumn(YRP.lang_string("LID_group"))
		charlist:AddColumn(YRP.lang_string("LID_role"))
		charlist:AddColumn(YRP.lang_string("LID_money")):SetFixedWidth(80)
		charlist:AddColumn(YRP.lang_string("LID_money") .. " (BANK)"):SetFixedWidth(80)
		charlist:AddColumn(YRP.lang_string("LID_level")):SetFixedWidth(50)
		charlist:AddColumn(YRP.lang_string("LID_event")):SetFixedWidth(50)
		charlist:AddColumn("Archived"):SetFixedWidth(50)

		for n, y in pairs(tab) do
			if y.SteamID != "BOT" then
				local event = tobool(y.bool_eventchar)
				local archi = tobool(y.bool_archived)
				local descr = ""
				if y.rpdescription and y.rpdescription != "nil" then
					descr = tostring(y.rpdescription)
				end
				descr = descr

				charlist:AddLine(y.SteamID, y.rpname, y.text_idcardid, descr, y.groupID, y.roleID, y.money, y.moneybank, y.int_level, event, archi)
			end
		end

		function charlist:OnRowRightClick(lineID, line)
			local _tmpSteamID = line:GetValue(1)
			local ply = nil
			for i, v in pairs(player.GetAll()) do
				if v:SteamID() == _tmpSteamID then
					ply = v
					break
				end
			end

			local tmpX, tmpY = gui.MousePos()
			tmpX = tmpX - YRP.ctr(4)
			tmpY = tmpY - YRP.ctr(4)
			local _tmpPanel = createVGUI("DPanel", nil, 400 + 10 + 10, 10 + 50 + 10, tmpX * 2 - 10, tmpY * 2 - 10)
			_tmpPanel:SetPos(tmpX, tmpY)
			_tmpPanel.ready = false
			timer.Simple(0.2, function()
				_tmpPanel.ready = true
			end)

			local _buttonGetSteamID = createVGUI("DButton", _tmpPanel, 400, 50, 10, 10)
			_buttonGetSteamID:SetText( "SteamID" )
			function _buttonGetSteamID:DoClick()
				SetClipboardText( line:GetValue(1) )
			end

			function _tmpPanel:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, get_ds_col())
				if !_tmpPanel:IsHovered() and !_buttonGetSteamID:IsHovered() and _tmpPanel.ready == true then
					_tmpPanel:Remove()
				end
			end
			_tmpPanel:MakePopup()
		end
	end
end)

function OpenSettingsCharacters()
	net.Start("setting_characters")
	net.SendToServer()
end
