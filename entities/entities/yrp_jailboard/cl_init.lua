--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

include("shared.lua")

function ENT:Draw()
	local ply = LocalPlayer()
	local eyeTrace = ply:GetEyeTrace()

	if ply:GetPos():Distance(self:GetPos()) < 2000 then
		self:DrawModel()
	end
end

local windowOpen = false

net.Receive("openLawBoard", function(len)
	if !windowOpen then
		local tmpJailList = net.ReadTable()
		windowOpen = true
		local window = createD("DFrame", nil, ScW(), ScrH(), 0, 0)
		window:SetTitle("")
		window:Center()
		function window:OnClose()
			window:Remove()
			closeMenu()
		end
		function window:OnRemove()
			windowOpen = false
			closeMenu()
		end
		function window:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 250))
			draw.SimpleTextOutlined(YRP.lang_string("LID_jail"), "sef", YRP.ctr(10), YRP.ctr(25), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))

			draw.SimpleTextOutlined(YRP.lang_string("LID_access"), "sef", YRP.ctr(600), YRP.ctr(25), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		end

		local _tmpGroups = net.ReadTable()
		local _tmpGeneral = net.ReadTable()
		local _gAccess = -1
		if worked(_tmpGeneral, "_tmpGeneral failed") then
			_gAccess = tonumber(_tmpGeneral[1].access_jail)
		end
		if LocalPlayer():HasAccess() then
			local _access = createD("DComboBox", window, YRP.ctr(300), YRP.ctr(50), YRP.ctr(610), 0)
			_access:AddChoice("-", -1, false)
			for k, v in pairs(_tmpGroups) do
				local _hasaccess = false
				if tonumber(v.uniqueID) == tonumber(_gAccess) then
					_hasaccess = true
				end
				_access:AddChoice(v.string_name, v.uniqueID, _hasaccess)
			end
			function _access:OnSelect(index, value, data)
				net.Start("db_jailaccess")
					net.WriteString("yrp_general")
					net.WriteString("access_jail = " .. data)
				net.SendToServer()
			end
		end


		local scrollpanel = createD("DScrollPanel", window, ScW() - YRP.ctr(20), ScrH() - YRP.ctr(50+10+10), YRP.ctr(10), YRP.ctr(50+10))
		function scrollpanel:Paint(pw, ph)
			--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 100))
		end

		local _x = 0
		local _y = 0
		local _size = 800
		for k, v in pairs(tmpJailList) do
			local dpanel = createVGUI("DPanel", scrollpanel, _size, _size, 0, 0)
			dpanel:SetText("")
			dpanel:SetPos(_x*YRP.ctr(_size+10), _y*YRP.ctr(_size+60+10))
			function dpanel:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 255, 200))

				draw.SimpleTextOutlined(YRP.lang_string("LID_name") .. ": " .. v.nick, "sef", pw/2, ph - YRP.ctr(125), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
				draw.SimpleTextOutlined(YRP.lang_string("LID_reason") .. ": " .. SQL_STR_OUT(v.reason), "sef", pw/2, ph - YRP.ctr(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
				draw.SimpleTextOutlined(YRP.lang_string("LID_time") .. ": " .. v.time, "sef", pw/2, ph - YRP.ctr(25), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			end
			scrollpanel:AddItem(dpanel)

			local _removeButton = createD("DButton", scrollpanel, YRP.ctr(_size), YRP.ctr(50), 0, 0)
			_removeButton:SetText("")
			_removeButton.uniqueID = v.uniqueID
			_removeButton.panel = dpanel

			_removeButton.steamID = v.steamID

			function _removeButton:Paint(pw, ph)
				surfaceButton(self, pw, ph,YRP.lang_string("LID_remove"))
			end
			function _removeButton:DoClick()
				if self.uniqueID != nil and self.steamID != nil then
					net.Start("dbRemJail")
						net.WriteString(self.uniqueID)
						net.WriteString(self.steamID)
					net.SendToServer()
					self.panel:Remove()
					self:Remove()
				else
					printGM("note", "uniqueID and steamID is nil!")
				end
			end

			_removeButton:SetPos(_x*YRP.ctr(_size+10), _y*YRP.ctr(_size+70) + YRP.ctr(_size))

			_x = _x + 1
			if (_x-1)*_size >= ScW() then
				_y = _y + 1
				_x = 0
			end
		end

		local _tmpGroupID = net.ReadInt(32)
		if _gAccess == _tmpGroupID then
			local addButton = createVGUI("DButton", scrollpanel, _size, _size)
			addButton:SetText("")
			addButton:SetPos(_x*YRP.ctr(_size+10), _y*YRP.ctr(_size+70))
			function addButton:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 255, 0, 200))

				local _pl = 200
				local _ph = 50
				draw.RoundedBox(0, pw/2 - YRP.ctr(_pl/2), ph/2 - YRP.ctr(_ph/2), YRP.ctr(_pl), YRP.ctr(_ph), Color(0, 0, 0, 255))
				draw.RoundedBox(0, pw/2 - YRP.ctr(_ph/2), ph/2 - YRP.ctr(_pl/2), YRP.ctr(_ph), YRP.ctr(_pl), Color(0, 0, 0, 255))
			end
			scrollpanel:AddItem(addButton)
			function addButton:DoClick()
				local _SteamID = nil
				local _nick = ""
				local addWindow = createVGUI("DFrame", nil, 400, 420, 0, 0)
				addWindow:SetTitle("")
				addWindow:Center()
				function addWindow:Paint(pw, ph)
					draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 250))

					draw.SimpleTextOutlined(YRP.lang_string("LID_add"), "sef", YRP.ctr(10), YRP.ctr(25), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))

					draw.SimpleTextOutlined(YRP.lang_string("LID_player"), "sef", YRP.ctr(10), YRP.ctr(100), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))

					draw.SimpleTextOutlined(YRP.lang_string("LID_reason"), "sef", YRP.ctr(10), YRP.ctr(200), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))

					draw.SimpleTextOutlined(YRP.lang_string("LID_timeinsec"), "sef", YRP.ctr(10), YRP.ctr(300), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
				end

				local _player = createVGUI("DComboBox", addWindow, 380, 50, 10, 100)
				for k, v in pairs(player.GetAll()) do
					_player:AddChoice(v:RPName(), v:SteamID())
				end
				function _player:OnSelect(index, value, data)
					_SteamID = data
					_nick = value
				end

				local _reason = createVGUI("DTextEntry", addWindow, 380, 50, 10, 200)

				local _time = createVGUI("DNumberWang", addWindow, 380, 50, 10, 300)

				local _add = createVGUI("DButton", addWindow, 380, 50, 10, 360)
				_add:SetText("")
				function _add:Paint(pw, ph)
					draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 255, 0, 255))
					draw.SimpleTextOutlined(YRP.lang_string("LID_add"), "sef", pw/2, ph/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
				end
				function _add:DoClick()
					if _SteamID != nil then
						local _insert = "'" .. _SteamID .. "', '" .. SQL_STR_IN(_reason:GetText()) .. "', " .. db_int(_time:GetValue()) .. ", '" .. SQL_STR_IN(_nick) .. "'"
						net.Start("dbAddJail")
							net.WriteString("yrp_jail")
							net.WriteString("SteamID, reason, time, nick")
							net.WriteString(_insert)

							net.WriteString(_SteamID)
						net.SendToServer()
					end
				end

				window:Close()

				addWindow:MakePopup()
			end
		end

		window:MakePopup()
	end
end)
