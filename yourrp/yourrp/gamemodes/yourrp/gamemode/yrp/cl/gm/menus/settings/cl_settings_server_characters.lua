local YRPCharList = nil
--Copyright (C) 2017-2025 D4KiR (https://www.gnu.org/licenses/gpl.txt)
net.Receive(
	"nws_yrp_setting_characters",
	function(len)
		local PARENT = GetSettingsSite()
		if YRPPanelAlive(PARENT) and YRPPanelAlive(YRPCharList) then
			local tab = net.ReadTable()
			if tab.SteamID ~= "BOT" then
				local event = tobool(tab.bool_eventchar)
				local archi = tobool(tab.bool_archived)
				local descr = ""
				if tab.rpdescription and tab.rpdescription ~= "nil" then
					descr = tostring(tab.rpdescription)
				end

				descr = descr or ""
				if YRPPanelAlive(YRPCharList) and YRPCharList.AddLine then
					YRPCharList:AddLine(tab.uniqueID, tab.SteamID, tab.rpname, tab.text_idcardid, descr, tab.groupID, tab.roleID, tab.money, tab.moneybank, tab.int_level, event, archi)
				end
			end
		end
	end
)

local _tmpPanel = nil
function OpenSettingsCharacters()
	local PARENT = GetSettingsSite()
	if YRPPanelAlive(PARENT) then
		YRPCharList = YRPCreateD("DListView", PARENT, PARENT:GetWide(), PARENT:GetTall(), 0, 0)
		YRPCharList:AddColumn(YRP:trans("LID_id")):SetFixedWidth(50)
		YRPCharList:AddColumn("SteamID")
		YRPCharList:AddColumn(YRP:trans("LID_name"))
		YRPCharList:AddColumn(YRP:trans("LID_idcardid"))
		YRPCharList:AddColumn(YRP:trans("LID_description"))
		YRPCharList:AddColumn(YRP:trans("LID_group"))
		YRPCharList:AddColumn(YRP:trans("LID_role"))
		YRPCharList:AddColumn(YRP:trans("LID_money")):SetFixedWidth(80)
		YRPCharList:AddColumn(YRP:trans("LID_money") .. " (BANK)"):SetFixedWidth(80)
		YRPCharList:AddColumn(YRP:trans("LID_level")):SetFixedWidth(50)
		YRPCharList:AddColumn(YRP:trans("LID_event")):SetFixedWidth(50)
		YRPCharList:AddColumn("Archived"):SetFixedWidth(50)
		net.Receive(
			"nws_yrp_character_delete",
			function(len)
				if YRPCharList then
					local id = net.ReadString()
					for i, v in pairs(YRPCharList:GetLines()) do
						if v:GetValue(1) == id then
							YRPCharList:RemoveLine(v:GetID())
							if _tmpPanel then
								_tmpPanel:Remove()
							end
						end
					end
				end
			end
		)

		function YRPCharList:OnRowRightClick(lineID, line)
			local tmpX, tmpY = gui.MousePos()
			tmpX = tmpX - YRP:ctr(4)
			tmpY = tmpY - YRP:ctr(4)
			_tmpPanel = createVGUI("DPanel", nil, 400 + 10 + 10, 10 + 50 + 10 + 50 + 10, tmpX * 2 - 10, tmpY * 2 - 10)
			_tmpPanel:SetPos(tmpX, tmpY)
			_tmpPanel.ready = false
			timer.Simple(
				0.2,
				function()
					_tmpPanel.ready = true
				end
			)

			local _buttonGetSteamID = createVGUI("DButton", _tmpPanel, 400, 50, 10, 10)
			_buttonGetSteamID:SetText("SteamID")
			function _buttonGetSteamID:DoClick()
				SetClipboardText(line:GetValue(2))
				_tmpPanel:Remove()
			end

			local _btnDeleteCharacter = createVGUI("DButton", _tmpPanel, 400, 50, 10, 70)
			_btnDeleteCharacter:SetText("DELETE CHARACTER")
			function _btnDeleteCharacter:DoClick()
				net.Start("nws_yrp_character_delete")
				net.WriteString(line:GetValue(1))
				net.SendToServer()
			end

			function _tmpPanel:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, get_ds_col())
				if not _tmpPanel:IsHovered() and not _buttonGetSteamID:IsHovered() and not _btnDeleteCharacter:IsHovered() and _tmpPanel.ready == true then
					_tmpPanel:Remove()
				end
			end

			_tmpPanel:MakePopup()
		end

		net.Start("nws_yrp_setting_characters")
		net.SendToServer()
	end
end
