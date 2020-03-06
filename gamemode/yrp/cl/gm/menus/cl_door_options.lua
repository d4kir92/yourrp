--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local yrp_door = {}

function toggleDoorOptions(door)
	if YRPIsNoMenuOpen() then
		openDoorOptions(door)
	elseif !mouseVisible then
		closeDoorOptions()
	end
end

function closeDoorOptions()
	closeMenu()
	yrp_door.window:Close()
	yrp_door.window = nil
end

net.Receive("getBuildingInfo", function(len)
	local door = net.ReadEntity()
	local tabBuilding = net.ReadTable()
	local tabOwner = net.ReadTable()
	local tabGroup = net.ReadTable()

	if GetGlobalDBool("bool_building_system", false) then
		if ea(door) then
			if table.Count(tabOwner) > 0 or table.Count(tabGroup) > 0 then
				optionWindow(door, tabBuilding, tabOwner, tabGroup)
			else
				buyWindow(door, tabBuilding)
			end
		end
	else
		printGM("note", "getDoorInfo Receive: NIL")
	end
end)

function buyWindow(door, tabBuilding)
	tabBuilding.bool_canbeowned = tobool(tabBuilding.bool_canbeowned)
	openMenu()
	local ply = LocalPlayer()

	local _doors = 0
	local _tmpDoors = ents.FindByClass("prop_door_rotating")
	for k, v in pairs(_tmpDoors) do
		if tonumber(v:GetDString("buildingID", "-1")) == tonumber(tabBuilding.uniqueID) then
			_doors = _doors + 1
		end
	end
	local _tmpFDoors = ents.FindByClass("func_door")
	for k, v in pairs(_tmpFDoors) do
		if tonumber(v:GetDString("buildingID", "-1")) == tonumber(tabBuilding.uniqueID) then
			_doors = _doors + 1
		end
	end
	local _tmpFRDoors = ents.FindByClass("func_door_rotating")
	for k, v in pairs(_tmpFRDoors) do
		if tonumber(v:GetDString("buildingID", "-1")) == tonumber(tabBuilding.uniqueID) then
			_doors = _doors + 1
		end
	end

	local br = YRP.ctr(20)
	yrp_door.window = createD("YFrame", nil, YRP.ctr(1100), YRP.ctr(760), 0, 0)
	if !ply:HasAccess() then
		yrp_door.window:SetTall(YRP.ctr(300))
	end
	yrp_door.window:SetHeaderHeight(YRP.ctr(100))
	yrp_door.window:Center()
	yrp_door.window:MakePopup()
	yrp_door.window:SetTitle("LID_buymenu")
	function yrp_door.window:Close()
		yrp_door.window:Remove()
	end
	yrp_door.window.systime = SysTime()
	function yrp_door.window:Paint(pw, ph)
		Derma_DrawBackgroundBlur(self, self.systime)
		hook.Run("YFramePaint", self, pw, ph)
	end
	function yrp_door.window:OnClose()
		closeMenu()
	end
	function yrp_door.window:OnRemove()
		closeMenu()
	end
	function yrp_door.window.con:Paint(pw, ph)
		draw.SimpleTextOutlined(YRP.lang_string("LID_name") .. ": " .. tabBuilding.name, "sef", br, br, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_price") .. ": " .. GetGlobalDString("text_money_pre", "") .. tabBuilding.buildingprice .. GetGlobalDString("text_money_pos", ""), "sef", br, YRP.ctr(20 + 50), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_doors") .. ": " .. _doors, "sef", br, YRP.ctr(20 + 100), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))

		draw.RoundedBox(0, 0, YRP.ctr(200), pw, ph - YRP.ctr(200), Color(255, 255, 100, 200))
		draw.SimpleTextOutlined(YRP.lang_string("LID_name") .. ":", "Y_18_500", br, YRP.ctr(250), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_building") .. ":", "Y_18_500", br, YRP.ctr(350), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_group") .. ":", "Y_18_500", br, YRP.ctr(450), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_price") .. ":", "Y_18_500", br, YRP.ctr(550), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_canbeowned") .. ":", "Y_18_500", pw - YRP.ctr(450 - 10) - br, YRP.ctr(475), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_securitylevel") .. ":", "Y_18_500", pw - YRP.ctr(500) - br, YRP.ctr(550), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))

		if tostring(door:GetDString("buildingID", "-1")) == "-1" then
			draw.SimpleTextOutlined("Loading IDs", "Y_18_500", pw - br, YRP.ctr(250), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
		else
			draw.SimpleTextOutlined("Building-ID: " .. door:GetDString("buildingID", "-1"), "Y_18_500", pw - br, YRP.ctr(250), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
			draw.SimpleTextOutlined("Door-ID: " .. door:GetDString("uniqueID", "-1"), "Y_18_500", pw - br, YRP.ctr(290), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
		end
	end

	local _buyButton = createD("YButton", yrp_door.window.con, YRP.ctr(500), YRP.ctr(50), yrp_door.window.con:GetWide() - YRP.ctr(500) - br, br)
	_buyButton:SetText("LID_buy")
	function _buyButton:DoClick()
		if tabBuilding.bool_canbeowned then
			net.Start("buyBuilding")
				net.WriteString(tabBuilding.uniqueID)
			net.SendToServer()
			if yrp_door.window.Close != nil then
				yrp_door.window:Close()
			end
		end
	end
	function _buyButton:Paint(pw, ph)
		if tabBuilding.bool_canbeowned then
			hook.Run("YButtonPaint", self, pw, ph)
		end
	end

	if ply:HasAccess() then
		local _TextEntryName = createD("DTextEntry", yrp_door.window.con, YRP.ctr(500), YRP.ctr(50), br, YRP.ctr(250))
		_TextEntryName:SetText(tabBuilding.name)
		function _TextEntryName:OnChange()
			tabBuilding.name = _TextEntryName:GetText()
			net.Start("changeBuildingName")
				net.WriteString(tabBuilding.uniqueID)
				net.WriteString(tabBuilding.name)
			net.SendToServer()
		end

		local _ComboBoxHouseName = createD("DComboBox", yrp_door.window.con, YRP.ctr(500), YRP.ctr(50), br, YRP.ctr(350))
		net.Start("getBuildings")
		net.SendToServer()

		net.Receive("getBuildings", function()
			local _tmpBuildings = net.ReadTable()

			if _ComboBoxHouseName != NULL then
				for k, v in pairs(_tmpBuildings) do
					if pa(_ComboBoxHouseName) then
						_ComboBoxHouseName:AddChoice(v.name .. " [" .. YRP.lang_string("LID_doors") .. ": " .. v.doors .. "] [BUID: " .. v.uniqueID .. "]", v.uniqueID, false)
					else
						break
					end
				end
			end
		end)
		function _ComboBoxHouseName:OnSelect(index, value, data)
			local _tmpData = _ComboBoxHouseName:GetOptionData(index)
			if _tmpData != nil then
				tabBuilding.uniqueID = _ComboBoxHouseName:GetOptionData(index)
				net.Start("changeBuildingID")
					net.WriteEntity(door)
					net.WriteString(tabBuilding.uniqueID)
				net.SendToServer()
				yrp_door.window:Close()
			end
		end

		local _ButtonAddNew = createD("YButton", yrp_door.window.con, YRP.ctr(500), YRP.ctr(50), yrp_door.window.con:GetWide() - YRP.ctr(500) - br, YRP.ctr(350))
		_ButtonAddNew:SetText("LID_addanewbuilding")
		function _ButtonAddNew:DoClick()
			net.Start("addnewbuilding")
			net.SendToServer()
			yrp_door.window:Close()
		end

		local _ComboBoxGroupName = createD("DComboBox", yrp_door.window.con, YRP.ctr(500), YRP.ctr(50), br, YRP.ctr(450))
		net.Start("getBuildingGroups")
		net.SendToServer()

		net.Receive("getBuildingGroups", function()
			local _tmpGroups = net.ReadTable()

			if pa(_ComboBoxGroupName) then
				for k, v in pairs(_tmpGroups) do
					if pa(_ComboBoxGroupName) then
						v.uniqueID = tonumber(v.uniqueID)
						if v.uniqueID == 0 then
							_ComboBoxGroupName:AddChoice(YRP.lang_string("LID_public"), v.uniqueID, false)
						else
							_ComboBoxGroupName:AddChoice(v.string_name, v.uniqueID, false)
						end
					else
						break
					end
				end
			end
		end)
		function _ComboBoxGroupName:OnSelect(index, value, data)
			local _tmpData = _ComboBoxGroupName:GetOptionData(index)
			if _tmpData != nil then
				net.Start("setBuildingOwnerGroup")
					net.WriteString(tabBuilding.uniqueID)
					net.WriteInt(_tmpData, 32)
				net.SendToServer()
				yrp_door.window:Close()
			end
		end

		local _TextEntryPrice = createD("DNumberWang", yrp_door.window.con, YRP.ctr(500), YRP.ctr(50), br, YRP.ctr(550))
		_TextEntryPrice:SetText(tabBuilding.buildingprice)
		function _TextEntryPrice:OnChange()
			tabBuilding.buildingprice = _TextEntryPrice:GetValue()
			if tabBuilding.buildingprice != nil then
				net.Start("changeBuildingPrice")
					net.WriteString(tabBuilding.uniqueID)
					net.WriteString(tabBuilding.buildingprice)
				net.SendToServer()
			end
		end

		local _TextEntrySL = createD("DNumberWang", yrp_door.window.con, YRP.ctr(500), YRP.ctr(50), yrp_door.window.con:GetWide() - YRP.ctr(500) - br, YRP.ctr(550))
		_TextEntrySL:SetText(tabBuilding.int_securitylevel)
		function _TextEntrySL:OnChange()
			tabBuilding.int_securitylevel = _TextEntrySL:GetValue()
			if tabBuilding.int_securitylevel != nil then
				net.Start("changeBuildingSL")
					net.WriteString(tabBuilding.uniqueID)
					net.WriteString(tabBuilding.int_securitylevel)
				net.SendToServer()
			end
		end

		local cb_canbeowned = createD("DCheckBox", yrp_door.window.con, YRP.ctr(50), YRP.ctr(50), yrp_door.window.con:GetWide() - YRP.ctr(500) - br, YRP.ctr(450))
		cb_canbeowned:SetValue(tabBuilding.bool_canbeowned)
		function cb_canbeowned:OnChange(bVal)
			tabBuilding.bool_canbeowned = bVal
			net.Start("CanBuildingBeOwned")
				net.WriteString(tabBuilding.uniqueID)
				net.WriteBool(tabBuilding.bool_canbeowned)
			net.SendToServer()
		end

		yrp_door.window:Center()
	end
end

function optionWindow(door, tabBuilding, tabOwner, tabGroup)
	openMenu()
	local ply = LocalPlayer()

	local OWNER = false
	if door:GetDString("ownerGroup", "") == "" and tonumber(door:GetDString("ownerCharID")) == tonumber(LocalPlayer():CharID()) then
		OWNER = true
	end

	local _doors = 0
	local _tmpDoors = ents.FindByClass("prop_door_rotating")
	for k, v in pairs(_tmpDoors) do
		if tonumber(v:GetDString("buildingID", "-1")) == tonumber(tabBuilding.uniqueID) then
			_doors = _doors + 1
		end
	end
	local _tmpFDoors = ents.FindByClass("func_door")
	for k, v in pairs(_tmpFDoors) do
		if tonumber(v:GetDString("buildingID", "-1")) == tonumber(tabBuilding.uniqueID) then
			_doors = _doors + 1
		end
	end
	local _tmpFRDoors = ents.FindByClass("func_door_rotating")
	for k, v in pairs(_tmpFRDoors) do
		if tonumber(v:GetDString("buildingID", "-1")) == tonumber(tabBuilding.uniqueID) then
			_doors = _doors + 1
		end
	end

	yrp_door.window = createD("YFrame", nil, YRP.ctr(1100), YRP.ctr(580), 0, 0)
	if !ply:HasAccess() then
		yrp_door.window:SetTall(YRP.ctr(340))
	end
	yrp_door.window:SetHeaderHeight(YRP.ctr(100))
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
		draw.SimpleTextOutlined(YRP.lang_string("LID_name") .. ": " .. tabBuilding.name, "sef", YRP.ctr(20), YRP.ctr(20), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_doors") .. ": " .. _doors, "sef", YRP.ctr(20), YRP.ctr(20 + 100), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		local owner = tabOwner.rpname or tabGroup.string_name
		draw.SimpleTextOutlined(YRP.lang_string("LID_owner") .. ": " .. owner, "sef", YRP.ctr(20), YRP.ctr(20 + 50), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))

		if OWNER then
			draw.SimpleTextOutlined(YRP.lang_string("LID_header"), "Y_18_500", pw - YRP.ctr(500 + 20), YRP.ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
			draw.SimpleTextOutlined(YRP.lang_string("LID_description"), "Y_18_500", pw - YRP.ctr(500 + 20), YRP.ctr(150), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
			--draw.SimpleTextOutlined(YRP.lang_string("LID_doorlevel") .. ": " .. door:GetDString("level", -1), "sef", YRP.ctr(10), YRP.ctr(150), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		end

		draw.RoundedBox(0, 0, YRP.ctr(220), pw, ph - YRP.ctr(220), Color(255, 255, 100, 200))
		draw.SimpleTextOutlined(YRP.lang_string("LID_name") .. ":", "Y_18_500", YRP.ctr(20), YRP.ctr(270), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_securitylevel") .. ":", "Y_18_500", YRP.ctr(540), YRP.ctr(370), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))

		draw.SimpleTextOutlined("Building-ID: " .. door:GetDString("buildingID", "FAILED"), "Y_18_500", pw - YRP.ctr(20), YRP.ctr(270), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined("Door-ID: " .. door:GetDString("uniqueID", -1), "Y_18_500", pw - YRP.ctr(20), YRP.ctr(270 + 40), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
	end
	function yrp_door.window:OnClose()
		closeMenu()
	end
	function yrp_door.window:OnRemove()
		closeMenu()
	end

	--[[
	local _ButtonUpgrade = createVGUI("YButton", yrp_door.window, 400, 50, 10, 200)
	_ButtonUpgrade:SetText(YRP.lang_string("LID_upgradedoor") .. " (-" .. GetGlobalDString("text_money_pre", "") .. "100" .. GetGlobalDString("text_money_pos", "") .. ") NOT AVAILABLE")
	function _ButtonUpgrade:DoClick()
		net.Start("wantHouse")
			net.WriteInt(tabBuilding.uniqueID, 16)
		net.SendToServer()
		yrp_door.window:Close()
	end
	]]--

	if OWNER then
		local _ButtonSell = createD("YButton", yrp_door.window.con, YRP.ctr(500), YRP.ctr(50), YRP.ctr(20), YRP.ctr(150))
		_ButtonSell:SetText(YRP.lang_string("LID_sell") .. " (+" .. GetGlobalDString("text_money_pre", "") .. tabBuilding.buildingprice / 2 .. GetGlobalDString("text_money_pos", "") .. ")")
		function _ButtonSell:DoClick()
			net.Start("sellBuilding")
				net.WriteString(tabBuilding.uniqueID)
			net.SendToServer()
			yrp_door.window:Remove()
		end
		--function _ButtonSell:Paint(pw, ph)
			--surfaceButton(self, pw, ph, YRP.lang_string("LID_sell") .. " (+" .. GetGlobalDString("text_money_pre", "") .. _price / 2 .. GetGlobalDString("text_money_pos", "") .. ")")
		--end

		local _header = createD("DTextEntry", yrp_door.window.con, YRP.ctr(500), YRP.ctr(50), yrp_door.window.con:GetWide() - YRP.ctr(500 + 20), YRP.ctr(50))
		_header:SetText(SQL_STR_OUT(tabBuilding.text_header))
		function _header:OnChange()
			tabBuilding.text_header = _header:GetText()
			net.Start("changeBuildingHeader")
				net.WriteString(tabBuilding.uniqueID)
				net.WriteString(tabBuilding.text_header)
			net.SendToServer()
		end

		local _description = createD("DTextEntry", yrp_door.window.con, YRP.ctr(500), YRP.ctr(50), yrp_door.window.con:GetWide() - YRP.ctr(500 + 20), YRP.ctr(150))
		_description:SetText(SQL_STR_OUT(tabBuilding.text_description))
		function _description:OnChange()
			tabBuilding.text_description = _description:GetText()
			net.Start("changeBuildingDescription")
				net.WriteString(tabBuilding.uniqueID)
				net.WriteString(tabBuilding.text_description)
			net.SendToServer()
		end
	end

	if ply:HasAccess() then
		local _TextEntryName = createD("DTextEntry", yrp_door.window.con, YRP.ctr(500), YRP.ctr(50), YRP.ctr(20), YRP.ctr(270))
		_TextEntryName:SetText(SQL_STR_OUT(tabBuilding.name))
		function _TextEntryName:OnChange()
			tabBuilding.name = _TextEntryName:GetText()
			net.Start("changeBuildingName")
				net.WriteString(tabBuilding.uniqueID)
				net.WriteString(tabBuilding.name)
			net.SendToServer()
		end

		local _TextEntrySL = createD("DNumberWang", yrp_door.window.con, YRP.ctr(500), YRP.ctr(50), YRP.ctr(540), YRP.ctr(370))
		_TextEntrySL:SetText(tabBuilding.int_securitylevel)
		function _TextEntrySL:OnChange()
			tabBuilding.int_securitylevel = _TextEntrySL:GetValue()
			if tabBuilding.int_securitylevel != nil then
				net.Start("changeBuildingSL")
					net.WriteString(tabBuilding.uniqueID)
					net.WriteString(tabBuilding.int_securitylevel)
				net.SendToServer()
			end
		end

		local _buttonRemoveOwner = createD("YButton", yrp_door.window.con, YRP.ctr(500), YRP.ctr(50), YRP.ctr(20), YRP.ctr(370))
		_buttonRemoveOwner:SetText("LID_removeowner")
		function _buttonRemoveOwner:DoClick()
			net.Start("removeOwner")
				net.WriteString(tabBuilding.uniqueID)
			net.SendToServer()
			yrp_door.window:Remove()
		end

		yrp_door.window:Center()
	end
end

function openDoorOptions(door)
	net.Start("getBuildingInfo")
		net.WriteEntity(door)
	net.SendToServer()
end
