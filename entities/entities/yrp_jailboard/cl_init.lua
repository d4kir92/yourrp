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
	if not windowOpen then
		local tmpJailList = net.ReadTable()
		windowOpen = true
		local window = createD("YFrame", nil, BFW(), BFH(), BPX(), BPY())
		window:SetHeaderHeight(YRP.ctr(100))
		window:SetTitle("LID_jail")
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
			hook.Run("YFramePaint", self, pw, ph)
		end

		local scrollpanel = createD("DScrollPanel", window:GetContent(), window:GetContent():GetWide() - YRP.ctr(40), window:GetContent():GetTall() - YRP.ctr(40), YRP.ctr(20), YRP.ctr(20))

		function scrollpanel:Paint(pw, ph)
			--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 100))
		end

		local _x = 0
		local _y = 0
		local s = {}
		s.w = 800
		s.h = 400

		for k, v in pairs(tmpJailList) do
			local dpanel = createVGUI("DPanel", scrollpanel, s.w, s.h, 0, 0)
			dpanel:SetText("")
			dpanel:SetPos(_x * YRP.ctr(s.w + 20), _y * YRP.ctr(s.h + 20))

			function dpanel:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 20))
				draw.SimpleTextOutlined(YRP.lang_string("LID_name") .. ": " .. v.nick, "sef", YRP.ctr(20), ph - YRP.ctr(190), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
				draw.SimpleTextOutlined(YRP.lang_string("LID_reason") .. ": " .. SQL_STR_OUT(v.reason), "sef", YRP.ctr(20), ph - YRP.ctr(140), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
				draw.SimpleTextOutlined(YRP.lang_string("LID_time") .. ": " .. v.time, "sef", YRP.ctr(20), ph - YRP.ctr(90), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			end

			local model = ""
			for j, p in pairs(player.GetAll()) do
				if p:SteamID() == v.SteamID then
					model = p:GetModel()
				end
			end
			if !strEmpty(model) then
				local dmodelpanel = createD("DModelPanel", dpanel, dpanel:GetTall() - YRP.ctr(50), dpanel:GetTall() - YRP.ctr(50), dpanel:GetWide() - (dpanel:GetTall() - YRP.ctr(50)), YRP.ctr(0))
				dmodelpanel:SetModel(model)
			end

			local _removeButton = createD("YButton", dpanel, YRP.ctr(s.w), YRP.ctr(50), 0, YRP.ctr(s.h) - YRP.ctr(50))
			_removeButton:SetText("LID_remove")
			_removeButton.uniqueID = v.uniqueID
			_removeButton.panel = dpanel
			_removeButton.SteamID = v.SteamID

			function _removeButton:DoClick()
				if self.uniqueID ~= nil and self.SteamID ~= nil then
					net.Start("dbRemJail")
						net.WriteString(self.uniqueID)
						net.WriteString(self.SteamID)
					net.SendToServer()
					dpanel:Remove()
					scrollpanel:Rebuild()
				else
					printGM("note", "uniqueID and SteamID is nil!")
				end
			end
			scrollpanel:AddItem(dpanel)

			_x = _x + 1

			if (_x - 1) * s.w >= window:GetContent():GetWide() then
				_y = _y + 1
				_x = 0
			end
		end

		local _tmpGroupID = net.ReadInt(32)

		if LocalPlayer():isCP() then
			local addButton = createVGUI("DButton", scrollpanel, s.w, s.h)
			addButton:SetText("")
			addButton:SetPos(_x * YRP.ctr(s.w + 20), _y * YRP.ctr(s.h + 20))

			function addButton:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 255, 0, 200))
				local _pl = 200
				local _ph = 50
				draw.RoundedBox(0, pw / 2 - YRP.ctr(_pl / 2), ph / 2 - YRP.ctr(_ph / 2), YRP.ctr(_pl), YRP.ctr(_ph), Color(0, 0, 0, 255))
				draw.RoundedBox(0, pw / 2 - YRP.ctr(_ph / 2), ph / 2 - YRP.ctr(_pl / 2), YRP.ctr(_ph), YRP.ctr(_pl), Color(0, 0, 0, 255))
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
					draw.SimpleTextOutlined(YRP.lang_string("LID_add"), "sef", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
				end

				function _add:DoClick()
					if _SteamID ~= nil then
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