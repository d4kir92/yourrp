--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local yrp_door = {}

function toggleDoorOptions(door)
	if isNoMenuOpen() then
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
	if net.ReadBool() then
		local _door = net.ReadEntity()
		local _building = net.ReadString()
		local _tmpBuilding = net.ReadTable()
		local owner = net.ReadString()
		local header = net.ReadString()
		local description = net.ReadString()

		local ply = LocalPlayer()
		if ply:GetNW2Bool("bool_building_system", false) then
			if _building != nil and _tmpBuilding != nil then
				if (_tmpBuilding.ownerCharID == "" or _tmpBuilding.ownerCharID == " ") and tonumber(_tmpBuilding.groupID) == -1 then
					buyWindow(_building, _tmpBuilding.name, _tmpBuilding.buildingprice, _door)
				elseif _tmpBuilding.ownerCharID == ply:CharID() or _tmpBuilding.groupID != -1 then
					optionWindow(_building, _tmpBuilding.name, _tmpBuilding.buildingprice, _door, owner, header, description)
				else
					printGM("note", "fail")
				end
			else
				printGM("note", "getDoorInfo Table empty")
			end
		else
			printGM("note", "getDoorInfo Receive: NIL")
		end
	end
end)

function buyWindow(buildingID, name, price, door)
	openMenu()
	local ply = LocalPlayer()
	local _buildingID = buildingID
	local _name = name
	local _price = price

	local _doors = 0
	local _tmpDoors = ents.FindByClass("prop_door_rotating")
	for k, v in pairs(_tmpDoors) do
		if tonumber(v:GetNW2String("buildingID", "-1")) == tonumber(_buildingID) then
			_doors = _doors + 1
		end
	end
	local _tmpFDoors = ents.FindByClass("func_door")
	for k, v in pairs(_tmpFDoors) do
		if tonumber(v:GetNW2String("buildingID", "-1")) == tonumber(_buildingID) then
			_doors = _doors + 1
		end
	end
	local _tmpFRDoors = ents.FindByClass("func_door_rotating")
	for k, v in pairs(_tmpFRDoors) do
		if tonumber(v:GetNW2String("buildingID", "-1")) == tonumber(_buildingID) then
			_doors = _doors + 1
		end
	end

	yrp_door.window = createD("YFrame", nil, YRP.ctr(2180), YRP.ctr(420), 0, 0)
	yrp_door.window:Center()
	yrp_door.window:SetTitle("LID_buymenu")
	function yrp_door.window:Close()
		yrp_door.window:Remove()
	end
	function yrp_door.window:Paint(pw, ph)
		hook.Run("YFramePaint", self, pw, ph)

		draw.SimpleTextOutlined(YRP.lang_string("LID_name") .. ": " .. _name, "sef", YRP.ctr(10), YRP.ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_price") .. ": " .. ply:GetNW2String("text_money_pre") .. _price .. ply:GetNW2String("text_money_pos"), "sef", YRP.ctr(10), YRP.ctr(100), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_doors") .. ": " .. _doors, "sef", YRP.ctr(10), YRP.ctr(150), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))

		draw.RoundedBox(0, YRP.ctr(4), YRP.ctr(210), pw - YRP.ctr(8), YRP.ctr(530 - 210 - 4), Color(255, 255, 0, 200))
		draw.SimpleTextOutlined(YRP.lang_string("LID_name") .. ":", "sef", YRP.ctr(10), YRP.ctr(220), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_building") .. ":", "sef", YRP.ctr(10), YRP.ctr(320), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_group") .. ":", "sef", YRP.ctr(10), YRP.ctr(420), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_price") .. ":", "sef", YRP.ctr(545), YRP.ctr(420), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))

		if tostring(door:GetNW2String("buildingID", "-1")) == "-1" then
			draw.SimpleTextOutlined("Loading IDs", "sef", pw - YRP.ctr(10), YRP.ctr(220), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		else
			draw.SimpleTextOutlined("Building-ID: " .. door:GetNW2String("buildingID", "-1"), "sef", pw - YRP.ctr(10), YRP.ctr(220), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
			draw.SimpleTextOutlined("Door-ID: " .. door:GetNW2String("uniqueID", "-1"), "sef", pw - YRP.ctr(10), YRP.ctr(280), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		end
	end
	function yrp_door.window:OnClose()
		closeMenu()
	end
	function yrp_door.window:OnRemove()
		closeMenu()
	end

	local _buyButton = createVGUI("DButton", yrp_door.window, 530, 50, 545, 150)
	_buyButton:SetText("")
	function _buyButton:DoClick()
		net.Start("buyBuilding")
			net.WriteString(_buildingID)
		net.SendToServer()
		if yrp_door.window.Close != nil then
			yrp_door.window:Close()
		end
	end
	function _buyButton:Paint(pw, ph)
		surfaceButton(self, pw, ph, YRP.lang_string("LID_buy"))
	end

	if ply:HasAccess() then
		local _TextEntryName = createVGUI("DTextEntry", yrp_door.window, 530, 50, 10, 270)
		_TextEntryName:SetText(name)
		function _TextEntryName:OnChange()
			local _newName = _TextEntryName:GetText()
			_name = _newName
			net.Start("changeBuildingName")
				net.WriteString(_buildingID)
				net.WriteString(_newName)
			net.SendToServer()
		end

		local _ComboBoxHouseName = createVGUI("DComboBox", yrp_door.window, 530, 50, 10, 370)
		net.Start("getBuildings")
		net.SendToServer()

		net.Receive("getBuildings", function()
			local _tmpBuildings = net.ReadTable()

			if _ComboBoxHouseName != NULL then
				for k, v in pairs(_tmpBuildings) do
					if pa(_ComboBoxHouseName) then
						_ComboBoxHouseName:AddChoice(v.name, v.uniqueID, false)
					else
						break
					end
				end
			end
		end)
		function _ComboBoxHouseName:OnSelect(index, value, data)
			local _tmpData = _ComboBoxHouseName:GetOptionData(index)
			if _tmpData != nil then
				_buildingID = _ComboBoxHouseName:GetOptionData(index)
				net.Start("changeBuildingID")
					net.WriteEntity(door)
					net.WriteString(_buildingID)
				net.SendToServer()
				yrp_door.window:Close()
			end
		end

		local _ButtonAddNew = createVGUI("DButton", yrp_door.window, 530, 50, 545, 370)
		_ButtonAddNew:SetText("")
		function _ButtonAddNew:DoClick()

		end
		function _ButtonAddNew:Paint(pw, ph)
			surfaceButton(self, pw, ph, YRP.lang_string("LID_addanewbuilding"))
		end

		local _ComboBoxGroupName = createVGUI("DComboBox", yrp_door.window, 530, 50, 10, 470)
		net.Start("getBuildingGroups")
		net.SendToServer()

		net.Receive("getBuildingGroups", function()
			local _tmpGroups = net.ReadTable()

			if _ComboBoxGroupName != NULL then
				for k, v in pairs(_tmpGroups) do
					if pa(_ComboBoxGroupName) then
						_ComboBoxGroupName:AddChoice(v.string_name, v.uniqueID, false)
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
					net.WriteString(_buildingID)
					net.WriteInt(_tmpData, 32)
				net.SendToServer()
				yrp_door.window:Close()
			end
		end

		local _TextEntryPrice = createVGUI("DTextEntry", yrp_door.window, 530, 50, 545, 470)
		_TextEntryPrice:SetText(_price)
		function _TextEntryPrice:OnChange()
			_price = _TextEntryPrice:GetText()
			if _price != nil then
				net.Start("changeBuildingPrice")
					net.WriteString(_buildingID)
					net.WriteString(_price)
				net.SendToServer()
			end
		end

		yrp_door.window:SetSize(YRP.ctr(1090), YRP.ctr(530))
		yrp_door.window:Center()
	end

	yrp_door.window:MakePopup()
end

function optionWindow(buildingID, name, price, door, owner, header, description)
	openMenu()
	local ply = LocalPlayer()
	local _buildingID = buildingID
	local _name = name
	local _price = price

	yrp_door.window = createD("YFrame", nil, YRP.ctr(2180), YRP.ctr(640), 0, 0)
	yrp_door.window:Center()
	yrp_door.window:SetTitle("LID_settings")
	function yrp_door.window:Close()
		yrp_door.window:Remove()
	end
	function yrp_door.window:Paint(pw, ph)
		hook.Run("YFramePaint", self, pw, ph)

		draw.SimpleTextOutlined(YRP.lang_string("LID_name") .. ": " .. _name, "sef", YRP.ctr(10), YRP.ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_owner") .. ": " .. owner, "sef", YRP.ctr(10), YRP.ctr(100), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		--draw.SimpleTextOutlined(YRP.lang_string("LID_doorlevel") .. ": " .. door:GetNW2String("level", -1), "sef", YRP.ctr(10), YRP.ctr(150), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))

		draw.RoundedBox(0, YRP.ctr(4), YRP.ctr(320), pw - YRP.ctr(8), YRP.ctr(460 - 320 - 4), Color(255, 255, 0, 200))
		draw.SimpleTextOutlined(YRP.lang_string("LID_name") .. ":", "sef", YRP.ctr(10), YRP.ctr(350), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))

		draw.SimpleTextOutlined("Building-ID: " .. door:GetNW2String("buildingID", "FAILED"), "sef", pw - YRP.ctr(10), YRP.ctr(320), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined("Door-ID: " .. door:GetNW2String("uniqueID", -1), "sef", pw - YRP.ctr(10), YRP.ctr(380), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
	end
	function yrp_door.window:OnClose()
		closeMenu()
	end
	function yrp_door.window:OnRemove()
		closeMenu()
	end

	--[[
	local _ButtonUpgrade = createVGUI("DButton", yrp_door.window, 400, 50, 10, 200)
	_ButtonUpgrade:SetText(YRP.lang_string("LID_upgradedoor") .. " (-" .. ply:GetNW2String("text_money_pre").. "100" .. ply:GetNW2String("text_money_pos") .. ") NOT AVAILABLE")
	function _ButtonUpgrade:DoClick()
		net.Start("wantHouse")
			net.WriteInt(_buildingID, 16)
		net.SendToServer()
		yrp_door.window:Close()
	end
	]]--

	if door:GetNW2String("ownerGroup") == "" then
		local _ButtonSell = createVGUI("DButton", yrp_door.window, 530, 50, 10, 260)
		_ButtonSell:SetText("")
		function _ButtonSell:DoClick()
			net.Start("sellBuilding")
				net.WriteString(_buildingID)
			net.SendToServer()
			yrp_door.window:Remove()
		end
		function _ButtonSell:Paint(pw, ph)
			surfaceButton(self, pw, ph, YRP.lang_string("LID_sell") .. " (+" .. ply:GetNW2String("text_money_pre") .. _price / 2 .. ply:GetNW2String("text_money_pos") .. ")")
		end
	end

	local _header = createVGUI("DTextEntry", yrp_door.window, 530, 50, 550, 200)
	_header:SetText(header)
	function _header:OnChange()
		local _newName = _header:GetText()
		net.Start("changeBuildingHeader")
			net.WriteString(_buildingID)
			net.WriteString(_newName)
		net.SendToServer()
	end

	local _description = createVGUI("DTextEntry", yrp_door.window, 530, 50, 550, 260)
	_description:SetText(description)
	function _description:OnChange()
		local _newName = _description:GetText()
		net.Start("changeBuildingDescription")
			net.WriteString(_buildingID)
			net.WriteString(_newName)
		net.SendToServer()
	end

	if ply:HasAccess() then
		local _TextEntryName = createVGUI("DTextEntry", yrp_door.window, 530, 50, 10, 400)
		_TextEntryName:SetText(name)
		function _TextEntryName:OnChange()
			local _newName = _TextEntryName:GetText()
			_name = _newName
			net.Start("changeBuildingName")
				net.WriteString(_buildingID)
				net.WriteString(_newName)
			net.SendToServer()
		end

		local _buttonRemoveOwner = createVGUI("DButton", yrp_door.window, 530, 50, 545, 400)
		_buttonRemoveOwner:SetText("")
		function _buttonRemoveOwner:DoClick()
			net.Start("removeOwner")
				net.WriteString(_buildingID)
			net.SendToServer()
			yrp_door.window:Remove()
		end
		function _buttonRemoveOwner:Paint(pw, ph)
			surfaceButton(self, pw, ph, YRP.lang_string("LID_removeowner"))
		end


		yrp_door.window:SetSize(YRP.ctr(1090), YRP.ctr(460))
		yrp_door.window:Center()
	end

	yrp_door.window:MakePopup()
end

function openDoorOptions(door)
	net.Start("getBuildingInfo")
		net.WriteEntity(door)
	net.SendToServer()
end
