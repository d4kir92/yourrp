--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local yrp_door = {}
yrp_door.waitforanswer = false
function YRPToggleDoorOptions(door)
	if YRPIsNoMenuOpen() then
		YRPOpenDoorOptions(door)
	elseif not mouseVisible then
		YRPCloseDoorOptions()
	else
		YRP:msg("note", "Can't toggle door options")
	end
end

function YRPCloseDoorOptions()
	YRPCloseMenu()
	if yrp_door and YRPPanelAlive(yrp_door.window) and yrp_door.window.Close then
		yrp_door.window:Close()
		yrp_door.window = nil
	end
end

net.Receive(
	"nws_yrp_sendBuildingInfo",
	function(len)
		YRP:msg("note", "[DoorOptions] Got Date from Server")
		if yrp_door.waitforanswer then
			yrp_door.waitforanswer = false
			local door = net.ReadEntity()
			local tab = net.ReadTable()
			if IsNotNilAndNotFalse(tab) then
				local tabBuilding = tab["B"]
				local tabOwner = tab["O"]
				local tabGroup = tab["G"]
				if GetGlobalYRPBool("bool_building_system", false) then
					if YRPEntityAlive(door) then
						if LocalPlayer():GetYRPBool("bool_" .. "ishobo", false) then
							YRP:msg("note", "[Building] You are a HOBO")
							LocalPlayer():PrintMessage(HUD_PRINTCENTER, "[Building] You are a HOBO")
						elseif table.Count(tabOwner) > 0 or table.Count(tabGroup) > 0 then
							YRPDoorOptionWindow(door, tabBuilding, tabOwner, tabGroup)
						else
							YRPDoorBuyWindow(door, tabBuilding)
						end
					else
						YRP:msg("note", "[Building] Building not alive")
						LocalPlayer():PrintMessage(HUD_PRINTCENTER, "[Building] Building not alive")
					end
				else
					YRP:msg("note", "[Building] Building System Disabled")
					LocalPlayer():PrintMessage(HUD_PRINTCENTER, "[Building] Building System Disabled")
				end
			else
				YRP:msg("note", "getBuildingInfo net Table broken")
				LocalPlayer():PrintMessage(HUD_PRINTCENTER, "[Building] net Table broken")
			end
		else
			YRP:msg("note", "Got Door Data to late!")
		end
	end
)

function YRPDoorBuyWindow(door, tabBuilding)
	tabBuilding.bool_canbeowned = tobool(tabBuilding.bool_canbeowned)
	YRPOpenMenu()
	local lply = LocalPlayer()
	local _doors = 0
	local _tmpDoors = ents.FindByClass("prop_door_rotating")
	for k, v in pairs(_tmpDoors) do
		if tonumber(v:GetYRPString("buildingID", "-1")) == tonumber(tabBuilding.uniqueID) then
			_doors = _doors + 1
		end
	end

	local _tmpFDoors = ents.FindByClass("func_door")
	for k, v in pairs(_tmpFDoors) do
		if tonumber(v:GetYRPString("buildingID", "-1")) == tonumber(tabBuilding.uniqueID) then
			_doors = _doors + 1
		end
	end

	local _tmpFRDoors = ents.FindByClass("func_door_rotating")
	for k, v in pairs(_tmpFRDoors) do
		if tonumber(v:GetYRPString("buildingID", "-1")) == tonumber(tabBuilding.uniqueID) then
			_doors = _doors + 1
		end
	end

	local br = YRP:ctr(20)
	yrp_door.window = YRPCreateD("YFrame", nil, YRP:ctr(1100), YRP:ctr(760), 0, 0)
	if not lply:HasAccess("YRPDoorBuyWindow1") then
		yrp_door.window:SetTall(YRP:ctr(300))
	end

	yrp_door.window:SetHeaderHeight(YRP:ctr(100))
	yrp_door.window:Center()
	yrp_door.window:MakePopup()
	yrp_door.window:SetTitle("LID_buymenu")
	function yrp_door.window:Close()
		yrp_door.window:Remove()
		yrp_door.window = nil
	end

	yrp_door.window.systime = SysTime()
	function yrp_door.window:Paint(pw, ph)
		Derma_DrawBackgroundBlur(self, self.systime)
		hook.Run("YFramePaint", self, pw, ph)
	end

	function yrp_door.window:OnClose()
		YRPCloseMenu()
	end

	function yrp_door.window:OnRemove()
		YRPCloseMenu()
	end

	function yrp_door.window.con:Paint(pw, ph)
		draw.SimpleTextOutlined(YRP:trans("LID_name") .. ": " .. tabBuilding.name, "Y_24_500", br, br, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
		draw.SimpleTextOutlined(YRP:trans("LID_doors") .. ": " .. _doors, "Y_24_500", br, YRP:ctr(20 + 50), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
		if GetGlobalYRPBool("bool_canbeowned", true) and tabBuilding.bool_canbeowned then
			draw.SimpleTextOutlined(YRP:trans("LID_price") .. ": " .. GetGlobalYRPString("text_money_pre", "") .. tabBuilding.buildingprice .. GetGlobalYRPString("text_money_pos", ""), "Y_24_500", br, YRP:ctr(20 + 100), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
		end

		if tostring(door:GetYRPString("buildingID", "-1")) == "-1" then
			draw.SimpleTextOutlined("Loading IDs", "Y_18_500", pw - br, YRP:ctr(250), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
		else
			draw.SimpleTextOutlined("Building-ID: " .. door:GetYRPString("buildingID", "-1"), "Y_18_500", pw - br, YRP:ctr(250), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
			draw.SimpleTextOutlined("Door-ID: " .. door:GetYRPString("uniqueID", "-1"), "Y_18_500", pw - br, YRP:ctr(290), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
		end

		draw.RoundedBox(0, 0, YRP:ctr(200), pw, ph - YRP:ctr(200), Color(255, 255, 100, 200))
		draw.SimpleTextOutlined(YRP:trans("LID_name") .. ":", "Y_18_500", br, YRP:ctr(250), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
		draw.SimpleTextOutlined(YRP:trans("LID_building") .. ":", "Y_18_500", br, YRP:ctr(350), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
		if GetGlobalYRPBool("bool_canbeowned", true) and tabBuilding.bool_canbeowned then
			draw.SimpleTextOutlined(YRP:trans("LID_group") .. ":", "Y_18_500", br, YRP:ctr(450), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
			draw.SimpleTextOutlined(YRP:trans("LID_price") .. ":", "Y_18_500", br, YRP:ctr(550), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
		end

		if GetGlobalYRPBool("bool_canbeowned", true) then
			draw.SimpleTextOutlined(YRP:trans("LID_canbeowned"), "Y_18_500", pw - YRP:ctr(450 - 10) - br, YRP:ctr(475), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
		end

		draw.SimpleTextOutlined(YRP:trans("LID_securitylevel") .. ":", "Y_18_500", pw - YRP:ctr(500) - br, YRP:ctr(550), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
	end

	if GetGlobalYRPBool("bool_canbeowned", true) then
		local _buyButton = YRPCreateD("YButton", yrp_door.window.con, YRP:ctr(500), YRP:ctr(50), yrp_door.window.con:GetWide() - YRP:ctr(500) - br, br)
		_buyButton:SetText("LID_buy")
		function _buyButton:DoClick()
			if tabBuilding.bool_canbeowned then
				net.Start("nws_yrp_buyBuilding")
				net.WriteString(tabBuilding.uniqueID)
				net.SendToServer()
				if yrp_door.window.Close ~= nil then
					yrp_door.window:Close()
				end
			end
		end

		function _buyButton:Paint(pw, ph)
			if tabBuilding.bool_canbeowned then
				hook.Run("YButtonPaint", self, pw, ph)
			end
		end
	end

	if lply:HasAccess("YRPDoorBuyWindow2") then
		local _TextEntryName = YRPCreateD("DTextEntry", yrp_door.window.con, YRP:ctr(500), YRP:ctr(50), br, YRP:ctr(250))
		_TextEntryName:SetText(tabBuilding.name)
		function _TextEntryName:OnChange()
			tabBuilding.name = _TextEntryName:GetText()
			net.Start("nws_yrp_changeBuildingName")
			net.WriteString(tabBuilding.uniqueID)
			net.WriteString(tabBuilding.name)
			net.SendToServer()
		end

		local _ComboBoxHouseName = YRPCreateD("DComboBox", yrp_door.window.con, YRP:ctr(500), YRP:ctr(50), br, YRP:ctr(350))
		net.Start("nws_yrp_getBuildings")
		net.SendToServer()
		net.Receive(
			"nws_yrp_getBuildings",
			function()
				local _tmpBuildings = net.ReadTable()
				tabBuilding.uniqueID = tonumber(tabBuilding.uniqueID)
				if YRPPanelAlive(_ComboBoxHouseName, "_ComboBoxHouseName 1") then
					_ComboBoxHouseName.setup = true
					if _ComboBoxHouseName ~= NULL then
						for k, v in pairs(_tmpBuildings) do
							v.uniqueID = tonumber(v.uniqueID)
							if YRPPanelAlive(_ComboBoxHouseName, "_ComboBoxHouseName 2") then
								local isbuilding = false
								if v.uniqueID == tabBuilding.uniqueID then
									isbuilding = true
								end

								_ComboBoxHouseName:AddChoice(v.name .. " [" .. YRP:trans("LID_doors") .. ": " .. v.doors .. "] [BUID: " .. v.uniqueID .. "]", v.uniqueID, isbuilding)
							else
								break
							end
						end
					end

					_ComboBoxHouseName.setup = false
				end
			end
		)

		function _ComboBoxHouseName:OnSelect(index, value, data)
			local _tmpData = _ComboBoxHouseName:GetOptionData(index)
			if _tmpData ~= nil and not self.setup then
				tabBuilding.uniqueID = _ComboBoxHouseName:GetOptionData(index)
				net.Start("nws_yrp_changeBuildingID")
				net.WriteEntity(door)
				net.WriteString(tabBuilding.uniqueID)
				net.SendToServer()
				yrp_door.window:Close()
			end
		end

		local _ButtonAddNew = YRPCreateD("YButton", yrp_door.window.con, YRP:ctr(500), YRP:ctr(50), yrp_door.window.con:GetWide() - YRP:ctr(500) - br, YRP:ctr(350))
		_ButtonAddNew:SetText("LID_addanewbuilding")
		function _ButtonAddNew:DoClick()
			net.Start("nws_yrp_addnewbuilding")
			net.SendToServer()
			if YRPPanelAlive(yrp_door.window) then
				yrp_door.window:Close()
			end
		end

		if GetGlobalYRPBool("bool_canbeowned", true) then
			local _ComboBoxGroupName = YRPCreateD("DComboBox", yrp_door.window.con, YRP:ctr(500), YRP:ctr(50), br, YRP:ctr(450))
			net.Start("nws_yrp_getBuildingGroups")
			net.SendToServer()
			net.Receive(
				"nws_yrp_getBuildingGroups",
				function()
					local _tmpGroups = net.ReadTable()
					if YRPPanelAlive(_ComboBoxGroupName, "_ComboBoxHouseName 3") then
						for k, v in pairs(_tmpGroups) do
							if YRPPanelAlive(_ComboBoxGroupName, "_ComboBoxHouseName 4") then
								v.uniqueID = tonumber(v.uniqueID)
								if v.uniqueID == 0 then
									_ComboBoxGroupName:AddChoice(YRP:trans("LID_public"), v.uniqueID, false)
								else
									_ComboBoxGroupName:AddChoice(v.string_name, v.uniqueID, false)
								end
							else
								break
							end
						end
					end
				end
			)

			function _ComboBoxGroupName:OnSelect(index, value, data)
				local _tmpData = _ComboBoxGroupName:GetOptionData(index)
				if _tmpData ~= nil then
					net.Start("nws_yrp_setBuildingOwnerGroup")
					net.WriteString(tabBuilding.uniqueID)
					net.WriteInt(_tmpData, 32)
					net.SendToServer()
					yrp_door.window:Close()
				end
			end

			local _TextEntryPrice = YRPCreateD("DNumberWang", yrp_door.window.con, YRP:ctr(500), YRP:ctr(50), br, YRP:ctr(550))
			_TextEntryPrice:SetText(tabBuilding.buildingprice)
			function _TextEntryPrice:OnChange()
				tabBuilding.buildingprice = _TextEntryPrice:GetValue()
				if tabBuilding.buildingprice ~= nil then
					net.Start("nws_yrp_changeBuildingPrice")
					net.WriteString(tabBuilding.uniqueID)
					net.WriteString(tabBuilding.buildingprice)
					net.SendToServer()
				end
			end

			local function YRPUpdateDoorVisi()
				if tabBuilding.bool_canbeowned then
					_ComboBoxGroupName:Show()
					_TextEntryPrice:Show()
				else
					_ComboBoxGroupName:Hide()
					_TextEntryPrice:Hide()
				end
			end

			YRPUpdateDoorVisi()
			local cb_canbeowned = YRPCreateD("DCheckBox", yrp_door.window.con, YRP:ctr(50), YRP:ctr(50), yrp_door.window.con:GetWide() - YRP:ctr(500) - br, YRP:ctr(450))
			cb_canbeowned:SetValue(tabBuilding.bool_canbeowned)
			function cb_canbeowned:OnChange(bVal)
				tabBuilding.bool_canbeowned = bVal
				net.Start("nws_yrp_canBuildingBeOwned")
				net.WriteString(tabBuilding.uniqueID)
				net.WriteBool(tabBuilding.bool_canbeowned)
				net.SendToServer()
				YRPUpdateDoorVisi()
			end
		end

		local _TextEntrySL = YRPCreateD("DNumberWang", yrp_door.window.con, YRP:ctr(500), YRP:ctr(50), yrp_door.window.con:GetWide() - YRP:ctr(500) - br, YRP:ctr(550))
		_TextEntrySL:SetText(tabBuilding.int_securitylevel)
		function _TextEntrySL:OnChange()
			tabBuilding.int_securitylevel = _TextEntrySL:GetValue()
			if tabBuilding.int_securitylevel ~= nil then
				net.Start("nws_yrp_changeBuildingSL")
				net.WriteString(tabBuilding.uniqueID)
				net.WriteString(tabBuilding.int_securitylevel)
				net.SendToServer()
			end
		end

		yrp_door.window:Center()
	end
end

function YRPDoorOptionWindow(door, tabBuilding, tabOwner, tabGroup)
	local sh = 540
	YRPOpenMenu()
	local lply = LocalPlayer()
	local OWNER = false
	if door:GetYRPString("ownerGroup", "") == "" and door:GetYRPInt("ownerCharID", 0) == LocalPlayer():CharID() then
		OWNER = true
	end

	local _doors = 0
	local _tmpDoors = ents.FindByClass("prop_door_rotating")
	for k, v in pairs(_tmpDoors) do
		if tonumber(v:GetYRPString("buildingID", "-1")) == tonumber(tabBuilding.uniqueID) then
			_doors = _doors + 1
		end
	end

	local _tmpFDoors = ents.FindByClass("func_door")
	for k, v in pairs(_tmpFDoors) do
		if tonumber(v:GetYRPString("buildingID", "-1")) == tonumber(tabBuilding.uniqueID) then
			_doors = _doors + 1
		end
	end

	local _tmpFRDoors = ents.FindByClass("func_door_rotating")
	for k, v in pairs(_tmpFRDoors) do
		if tonumber(v:GetYRPString("buildingID", "-1")) == tonumber(tabBuilding.uniqueID) then
			_doors = _doors + 1
		end
	end

	yrp_door.window = YRPCreateD("YFrame", nil, YRP:ctr(1100), YRP:ctr(sh), 0, 0)
	if lply:HasAccess("YRPDoorOptionWindow1") then
		yrp_door.window:SetTall(YRP:ctr(sh + 240))
	end

	yrp_door.window:SetHeaderHeight(YRP:ctr(100))
	yrp_door.window:Center()
	yrp_door.window:MakePopup()
	yrp_door.window:SetTitle("LID_settings")
	function yrp_door.window:Close()
		yrp_door.window:Remove()
	end

	yrp_door.window.systime = SysTime()
	function yrp_door.window:Paint(pw, ph)
		Derma_DrawBackgroundBlur(self, self.systime)
		hook.Run("YFramePaint", self, pw, ph)
	end

	function yrp_door.window.con:Paint(pw, ph)
		draw.SimpleTextOutlined(YRP:trans("LID_name") .. ": " .. tabBuilding.name, "Y_18_500", YRP:ctr(20), YRP:ctr(20), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
		local owner = tabOwner.rpname or tabGroup.string_name
		draw.SimpleTextOutlined(YRP:trans("LID_owner") .. ": " .. owner, "Y_18_500", YRP:ctr(20), YRP:ctr(20 + 35), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
		draw.SimpleTextOutlined(YRP:trans("LID_doors") .. ": " .. _doors, "Y_18_500", YRP:ctr(20), YRP:ctr(20 + 70), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
		if OWNER then
			draw.SimpleTextOutlined(YRP:trans("LID_header"), "Y_18_500", pw - YRP:ctr(500 + 20), YRP:ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
			draw.SimpleTextOutlined(YRP:trans("LID_description"), "Y_18_500", pw - YRP:ctr(500 + 20), YRP:ctr(150), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
		end

		draw.RoundedBox(0, 0, YRP:ctr(220), pw, ph - YRP:ctr(460), Color(100, 255, 100, 200))
		local coownerIDs = door:GetYRPString("coownerCharIDs", "")
		if not strEmpty(coownerIDs) then
			local coowners = ""
			for i, v in pairs(string.Explode(",", coownerIDs)) do
				for x, p in pairs(player.GetAll()) do
					if p:CharID() == tonumber(v) then
						if not strEmpty(coowners) then
							coowners = coowners .. ", "
						end

						coowners = coowners .. p:RPName()
					end
				end
			end

			draw.SimpleTextOutlined(YRP:trans("LID_coowners") .. ": " .. coowners, "Y_18_500", YRP:ctr(20), YRP:ctr(370), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
		end

		draw.RoundedBox(0, 0, YRP:ctr(420), pw, ph - YRP:ctr(320), Color(255, 255, 100, 200))
		draw.SimpleTextOutlined(YRP:trans("LID_name") .. ":", "Y_18_500", YRP:ctr(20), YRP:ctr(470), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
		draw.SimpleTextOutlined(YRP:trans("LID_securitylevel") .. ":", "Y_18_500", YRP:ctr(540), YRP:ctr(570), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
		if YRPEntityAlive(door) then
			draw.SimpleTextOutlined("Building-ID: " .. door:GetYRPString("buildingID", "FAILED"), "Y_18_500", pw - YRP:ctr(20), YRP:ctr(470), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
			draw.SimpleTextOutlined("Door-ID: " .. door:GetYRPString("uniqueID", -1), "Y_18_500", pw - YRP:ctr(20), YRP:ctr(470 + 40), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
		end
	end

	function yrp_door.window:OnClose()
		YRPCloseMenu()
	end

	function yrp_door.window:OnRemove()
		YRPCloseMenu()
	end

	if OWNER then
		local _ButtonSell = YRPCreateD("YButton", yrp_door.window.con, YRP:ctr(500), YRP:ctr(50), YRP:ctr(20), YRP:ctr(150))
		_ButtonSell:SetText(YRP:trans("LID_sell") .. " (+" .. GetGlobalYRPString("text_money_pre", "") .. tabBuilding.buildingprice / 2 .. GetGlobalYRPString("text_money_pos", "") .. " )")
		function _ButtonSell:DoClick()
			net.Start("nws_yrp_sellBuilding")
			net.WriteString(tabBuilding.uniqueID)
			net.SendToServer()
			yrp_door.window:Remove()
		end

		local _header = YRPCreateD("DTextEntry", yrp_door.window.con, YRP:ctr(500), YRP:ctr(50), yrp_door.window.con:GetWide() - YRP:ctr(500 + 20), YRP:ctr(50))
		_header:SetText(tabBuilding.text_header)
		function _header:OnChange()
			tabBuilding.text_header = _header:GetText()
			net.Start("nws_yrp_changeBuildingHeader")
			net.WriteString(tabBuilding.uniqueID)
			net.WriteString(tabBuilding.text_header)
			net.SendToServer()
		end

		local _description = YRPCreateD("DTextEntry", yrp_door.window.con, YRP:ctr(500), YRP:ctr(50), yrp_door.window.con:GetWide() - YRP:ctr(500 + 20), YRP:ctr(150))
		_description:SetText(tabBuilding.text_description)
		function _description:OnChange()
			tabBuilding.text_description = _description:GetText()
			net.Start("nws_yrp_changeBuildingDescription")
			net.WriteString(tabBuilding.uniqueID)
			net.WriteString(tabBuilding.text_description)
			net.SendToServer()
		end

		local _ButtonAddCoownerCB = YRPCreateD("DComboBox", yrp_door.window.con, YRP:ctr(500), YRP:ctr(50), YRP:ctr(20), YRP:ctr(240))
		for i, v in pairs(player.GetAll()) do
			_ButtonAddCoownerCB:AddChoice(v:RPName(), v:CharID())
		end

		local _ButtonAddCoowner = YRPCreateD("YButton", yrp_door.window.con, YRP:ctr(500), YRP:ctr(50), yrp_door.window.con:GetWide() - YRP:ctr(500 + 20), YRP:ctr(240))
		_ButtonAddCoowner:SetText("LID_add")
		function _ButtonAddCoowner:DoClick()
			local _, val = _ButtonAddCoownerCB:GetSelected()
			if val then
				net.Start("nws_yrp_addCoownerBuilding")
				net.WriteString(tabBuilding.uniqueID)
				net.WriteString(val)
				net.SendToServer()
			end
		end

		local _ButtonRemoveAllCoowner = YRPCreateD("YButton", yrp_door.window.con, YRP:ctr(500), YRP:ctr(50), yrp_door.window.con:GetWide() - YRP:ctr(500 + 20), YRP:ctr(320))
		_ButtonRemoveAllCoowner:SetText("LID_removeall")
		function _ButtonRemoveAllCoowner:DoClick()
			net.Start("nws_yrp_removeAllCoownerBuilding")
			net.WriteString(tabBuilding.uniqueID)
			net.SendToServer()
		end
	end

	if lply:HasAccess("YRPDoorOptionWindow2") then
		local _TextEntryName = YRPCreateD("DTextEntry", yrp_door.window.con, YRP:ctr(500), YRP:ctr(50), YRP:ctr(20), YRP:ctr(470))
		_TextEntryName:SetText(tabBuilding.name)
		function _TextEntryName:OnChange()
			tabBuilding.name = _TextEntryName:GetText()
			net.Start("nws_yrp_changeBuildingName")
			net.WriteString(tabBuilding.uniqueID)
			net.WriteString(tabBuilding.name)
			net.SendToServer()
		end

		local _TextEntrySL = YRPCreateD("DNumberWang", yrp_door.window.con, YRP:ctr(500), YRP:ctr(50), YRP:ctr(540), YRP:ctr(570))
		_TextEntrySL:SetText(tabBuilding.int_securitylevel)
		function _TextEntrySL:OnChange()
			tabBuilding.int_securitylevel = _TextEntrySL:GetValue()
			if tabBuilding.int_securitylevel ~= nil then
				net.Start("nws_yrp_changeBuildingSL")
				net.WriteString(tabBuilding.uniqueID)
				net.WriteString(tabBuilding.int_securitylevel)
				net.SendToServer()
			end
		end

		local _buttonRemoveOwner = YRPCreateD("YButton", yrp_door.window.con, YRP:ctr(500), YRP:ctr(50), YRP:ctr(20), YRP:ctr(570))
		_buttonRemoveOwner:SetText("LID_removeowner")
		function _buttonRemoveOwner:DoClick()
			net.Start("nws_yrp_removeOwner")
			net.WriteString(tabBuilding.uniqueID)
			net.SendToServer()
			yrp_door.window:Remove()
		end

		yrp_door.window:Center()
	end
end

local id = 0
function YRPOpenDoorOptions(door)
	id = id + 1
	YRPCloseDoorOptions()
	if not yrp_door.waitforanswer then
		yrp_door.waitforanswer = true
		YRP:msg("note", "[DoorOptions] Wait for Server answer")
		net.Start("nws_yrp_getBuildingInfo")
		net.WriteEntity(door)
		net.SendToServer()
		local lid = id
		timer.Simple(
			14,
			function()
				if yrp_door.waitforanswer and lid == id then
					YRP:msg("note", "[DoorOptions] Waited to long for answer from Server")
					yrp_door.waitforanswer = false
				end
			end
		)
	end
end
