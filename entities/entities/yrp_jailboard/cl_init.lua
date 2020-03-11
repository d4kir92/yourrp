--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)
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
	if not windowOpen and LocalPlayer():isCP() then
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

		window.tabs = createD("YTabs", window:GetContent(), window:GetContent():GetWide(), window:GetContent():GetTall(), 0, 0)

		window.tabs:AddOption("LID_prisoners", function(parent)
			local scrollpanel = createD("DScrollPanel", parent, parent:GetWide() - YRP.ctr(40), parent:GetTall() - YRP.ctr(90), YRP.ctr(20), YRP.ctr(90))
			function scrollpanel:Paint(pw, ph)
				--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 100))
			end
			scrollpanel.selected = 0
			scrollpanel.p = nil


			-- ADD
			local addButton = createD("YButton", parent, YRP.ctr(50), YRP.ctr(50), YRP.ctr(20), YRP.ctr(20))
			addButton:SetText("+")
			function addButton:DoClick()
				local _SteamID = nil
				local _nick = ""
				local _Cell = nil
				local addWindow = createVGUI("YFrame", nil, 800, 820, 0, 0)
				addWindow:SetHeaderHeight(YRP.ctr(100))
				addWindow:SetTitle("LID_add")
				addWindow:Center()

				function addWindow:Paint(pw, ph)
					hook.Run("YFramePaint", self, pw, ph)
				end
				local content = addWindow:GetContent()
				function content:Paint(pw, ph)
					draw.SimpleTextOutlined(YRP.lang_string("LID_player"), "sef", YRP.ctr(10), YRP.ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
					draw.SimpleTextOutlined(YRP.lang_string("LID_cell"), "sef", YRP.ctr(10), YRP.ctr(150), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
					draw.SimpleTextOutlined(YRP.lang_string("LID_note"), "sef", YRP.ctr(10), YRP.ctr(250), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
					draw.SimpleTextOutlined(YRP.lang_string("LID_timeinsec"), "sef", YRP.ctr(10), YRP.ctr(350), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
				end

				local _player = createVGUI("DComboBox", addWindow:GetContent(), 380, 50, 10, 50)
				for k, v in pairs(player.GetAll()) do
					_player:AddChoice(v:RPName(), v:SteamID())
				end
				function _player:OnSelect(index, value, data)
					_SteamID = data
					_nick = value
				end

				local _cell = createVGUI("DComboBox", addWindow:GetContent(), 380, 50, 10, 150)
				for k, v in pairs(GetGlobalDTable("yrp_jailpoints")) do
					_cell:AddChoice(v.name, v.uniqueID)
				end
				function _cell:OnSelect(index, value, data)
					_Cell = data
				end

				local _reason = createVGUI("DTextEntry", addWindow:GetContent(), 380, 50, 10, 250)
				local _time = createVGUI("DNumberWang", addWindow:GetContent(), 380, 50, 10, 350)
				local _add = createVGUI("YButton", addWindow:GetContent(), 380, 50, 10, 420)
				_add:SetText("LID_add")

				function _add:DoClick()
					if _SteamID != nil and _Cell != nil then
						local _insert = "'" .. _SteamID .. "', '" .. SQL_STR_IN(_reason:GetText()) .. "', " .. db_int(_time:GetValue()) .. ", '" .. SQL_STR_IN(_nick) .. "', '" .. _Cell .. "'"
						net.Start("dbAddJail")
							net.WriteString("yrp_jail")
							net.WriteString("SteamID, reason, time, nick, cell")
							net.WriteString(_insert)
							net.WriteString(_SteamID)
						net.SendToServer()

						net.Start("AddJailNote")
							net.WriteString(_SteamID)
							net.WriteString(_reason:GetText())
						net.SendToServer()
					end
				end

				window:Close()
				addWindow:MakePopup()
			end
			function addButton:Paint(pw, ph)
				local tab = {}
				tab.color = Color(100, 255, 100)
				hook.Run("YButtonPaint", self, pw, ph, tab)
			end



			-- REMOVE
			local remBtn = createD("YButton", parent, YRP.ctr(50), YRP.ctr(50), YRP.ctr(90), YRP.ctr(20))
			remBtn:SetText("-")
			function remBtn:DoClick()
				if scrollpanel.selected > 0 then
					net.Start("dbRemJail")
					net.WriteString(scrollpanel.selected)
					net.SendToServer()
					scrollpanel.items[scrollpanel.selected]:Remove()
					scrollpanel.selected = 0
				end
			end
			function remBtn:Paint(pw, ph)
				if scrollpanel.selected > 0 then
					local tab = {}
					tab.color = Color(255, 100, 100)
					hook.Run("YButtonPaint", self, pw, ph, tab)
				end
			end



			-- JAIL
			local jailBtn = createD("YButton", parent, YRP.ctr(200), YRP.ctr(50), YRP.ctr(160), YRP.ctr(20))
			jailBtn:SetText("LID_jail")
			function jailBtn:DoClick()
				if scrollpanel.selected > 0 then
					local target = nil
					for i, p in pairs(player.GetAll()) do
						if p:SteamID() == scrollpanel.p.SteamID then
							target = p
							break
						end
					end

					if target != nil then
						net.Start("jail")
							net.WriteEntity(target)
						net.SendToServer()
					end
				end
			end
			function jailBtn:Paint(pw, ph)
				if scrollpanel.selected > 0 then
					local tab = {}
					tab.color = Color(255, 100, 100)
					hook.Run("YButtonPaint", self, pw, ph, tab)
				end
			end



			-- UNJAIL
			local unjailBtn = createD("YButton", parent, YRP.ctr(200), YRP.ctr(50), YRP.ctr(380), YRP.ctr(20))
			unjailBtn:SetText("LID_unjail")
			function unjailBtn:DoClick()
				if scrollpanel.selected > 0 then
					local target = nil
					for i, p in pairs(player.GetAll()) do
						if p:SteamID() == scrollpanel.p.SteamID then
							target = p
							break
						end
					end

					if target != nil then
						net.Start("unjail")
							net.WriteEntity(target)
						net.SendToServer()
						window:Close()
					end
				end
			end
			function unjailBtn:Paint(pw, ph)
				if scrollpanel.selected > 0 then
					local tab = {}
					tab.color = Color(100, 255, 100)
					hook.Run("YButtonPaint", self, pw, ph, tab)
				end
			end



			local _x = 0
			local _y = 0
			local s = {}
			s.w = 800
			s.h = 400

			for k, v in pairs(tmpJailList) do
				v.uniqueID = tonumber(v.uniqueID)
				local dpanel = createVGUI("DButton", scrollpanel, s.w, s.h, 0, 0)
				dpanel.uniqueID = v.uniqueID
				dpanel:SetText("")
				dpanel.sp = scrollpanel
				dpanel:SetPos(_x * YRP.ctr(s.w + 20), _y * YRP.ctr(s.h + 20))
				function dpanel:DoClick()
					self.sp.p = v
					self.sp.selected = v.uniqueID
				end

				function dpanel:Paint(pw, ph)
					local color = Color(100, 100, 255, 100)
					if scrollpanel.selected == v.uniqueID then
						color = Color(255, 255, 100, 100)
					end
					draw.RoundedBox(0, 0, 0, pw, ph, color)
					draw.SimpleTextOutlined(YRP.lang_string("LID_name") .. ": " .. v.nick, "Y_25_500", YRP.ctr(20), YRP.ctr(45), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
					draw.SimpleTextOutlined(YRP.lang_string("LID_cell") .. ": " .. SQL_STR_OUT(v.cellname), "sef", YRP.ctr(20), YRP.ctr(95), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))	
					draw.SimpleTextOutlined(YRP.lang_string("LID_note") .. ": " .. SQL_STR_OUT(v.reason), "sef", YRP.ctr(20), YRP.ctr(145), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))	
					draw.SimpleTextOutlined(YRP.lang_string("LID_time") .. ": " .. v.time, "sef", YRP.ctr(20), ph - YRP.ctr(45), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
				end

				local model = ""
				for j, p in pairs(player.GetAll()) do
					if p:SteamID() == v.SteamID then
						model = p:GetModel()
					end
				end
				if !strEmpty(model) then
					local dmodelpanel = createD("DModelPanel", dpanel, dpanel:GetTall() - YRP.ctr(20), dpanel:GetTall() - YRP.ctr(20), dpanel:GetWide() - (dpanel:GetTall() - YRP.ctr(20)), YRP.ctr(10))
					dmodelpanel:SetModel(model)
				end

				scrollpanel:AddItem(dpanel)
				scrollpanel.items = scrollpanel.items or {}
				scrollpanel.items[v.uniqueID] = dpanel

				_x = _x + 1

				if (_x - 1) * s.w >= window:GetContent():GetWide() then
					_y = _y + 1
					_x = 0
				end
			end
		end)

		window.tabs:AddOption("LID_records", function(parent)
			-- PlayerListHeader
			local p = createD("YLabel", parent, YRP.ctr(800), YRP.ctr(50), YRP.ctr(20), YRP.ctr(20))
			p:SetText(YRP.lang_string("LID_players"))
			-- PlayerList
			local plist = createD("DScrollPanel", parent, p:GetWide(), YRP.ctr(800), YRP.ctr(20), YRP.ctr(20 + 50))
			function plist:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, Color(40, 40, 40, 255))
			end
			plist.btn = 0
			plist.ply = NULL
			-- RIGHT
			plist.notes = createD("YPanel", parent, YRP.ctr(1000), YRP.ctr(1000), YRP.ctr(20 + 800 + 20), YRP.ctr(20))
			plist.notes.curnote = 0
			function plist.notes:Paint(pw, ph)

			end
			function plist.notes:UpdatePlayerNotes()
				self:Clear()
				self.addNote = createD("YButton", self, YRP.ctr(50), YRP.ctr(50), YRP.ctr(0), YRP.ctr(0))
				self.addNote:SetText("+")
				function self.addNote:Paint(pw, ph)
					local tab = {}
					tab.color = Color(100, 255, 100)
					hook.Run("YButtonPaint", self, pw, ph, tab)
				end
				function self.addNote:DoClick()
					local win = createD("YFrame", nil, YRP.ctr(400), YRP.ctr(400), 0, 0)
					win:SetTitle("")
					win:SetHeaderHeight(YRP.ctr(100))
					win:Center()
					win:MakePopup()

					local content = win:GetContent()

					win.text = createD("DTextEntry", content, content:GetWide(), YRP.ctr(50), 0, 0)

					win.send = createD("YButton", content, content:GetWide(), YRP.ctr(50), 0, YRP.ctr(50))
					win.send:SetText("LID_send")
					function win.send:DoClick()
						net.Start("AddJailNote")
							net.WriteString(plist.ply:SteamID())
							net.WriteString(win.text:GetText())
						net.SendToServer()

						plist.notes:UpdatePlayerNotes()
						win:Close()
					end
				end

				self.remNote = createD("YButton", self, YRP.ctr(50), YRP.ctr(50), self:GetWide() - YRP.ctr(50), YRP.ctr(0))
				self.remNote:SetText("-")
				function self.remNote:Paint(pw, ph)
					if plist.notes.curnote > 0 then
						local tab = {}
						tab.color = Color(255, 100, 100)
						hook.Run("YButtonPaint", self, pw, ph, tab)
					end
				end
				function self.remNote:DoClick()
					if plist.notes.curnote > 0 then
						net.Start("RemoveJailNote")
							net.WriteString(plist.notes.curnote)
						net.SendToServer()

						plist.notes:UpdatePlayerNotes()
					end
				end

				self.nlist = createD("DScrollPanel", self, self:GetWide(), self:GetTall() - YRP.ctr(50), 0, YRP.ctr(50))
				function self.nlist:Paint(pw, ph)
					--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 40, 40, 255))
				end

				net.Start("getPlayerNotes")
					net.WriteEntity(plist.ply)
				net.SendToServer()
			end
			net.Receive("getPlayerNotes", function()
				local par = plist.notes
				local notes = net.ReadTable()
				for i, note in pairs(notes) do
					note.uniqueID = tonumber(note.uniqueID)
					local n = createD("YButton", par.nlist, par:GetWide(), YRP.ctr(50), 0, YRP.ctr(50) * (i - 1))
					n:SetText(note.note)
					function n:Paint(pw, ph)
						local tab = {}
						tab.color = Color(100, 100, 255, 255)
						if note.uniqueID == par.curnote then
							tab.color = Color(255, 255, 100, 255)
						end
						hook.Run("YButtonPaint", self, pw, ph, tab)
					end
					function n:DoClick()
						par.curnote = note.uniqueID
					end
				end
			end)
			-- PlayerLines
			for i, v in pairs(player.GetAll()) do
				local pline = createD("YButton", plist, p:GetWide(), YRP.ctr(50), 0, YRP.ctr(50) * (i - 1))
				pline:SetText(v:RPName())
				function pline:Paint(pw, ph)
					local color = Color(120, 120, 120, 255)
					if plist.btn == self then
						color = Color(255, 255, 100, 255)
					elseif self:IsHovered() then
						color = Color(255, 255, 255, 255)
					end
					draw.RoundedBox(0, 0, 0, pw, ph, color)
					draw.SimpleText(self:GetText(), "Y_18_500", YRP.ctr(20), ph / 2, Color(0, 0, 0, 255), 0, 1)
				end
				function pline:DoClick()
					plist.btn = self
					plist.ply = v
					plist.notes:UpdatePlayerNotes()
				end

				plist:Add(pline)
			end

			-- Playerinfo
			local pinfo = createD("YPanel", parent, YRP.ctr(800), YRP.ctr(800), YRP.ctr(20), YRP.ctr(890))
			function pinfo:Paint(pw, ph)
				if plist.ply:IsPlayer() then
					local scale = self:GetWide() / GetGlobalDInt("int_" .. "background" .. "_w", 100)
					drawIDCard(plist.ply, scale, 0, 0)
				end
			end

			local btnVerwarnungUp = createVGUI("YButton", parent, 50, 50, 20, 1310)
			btnVerwarnungUp:SetText("⮝")
			function btnVerwarnungUp:DoClick()
				if plist.ply:IsPlayer() then
					net.Start("warning_up")
						net.WriteEntity(plist.ply)
					net.SendToServer()
				end
			end
			local btnVerwarnungDn = createVGUI("YButton", parent, 50, 50, 20, 1360)
			btnVerwarnungDn:SetText("⮟")
			function btnVerwarnungDn:DoClick()
				if plist.ply:IsPlayer() then
					net.Start("warning_dn")
						net.WriteEntity(plist.ply)
					net.SendToServer()
				end
			end
			local btnVerwarnung = createVGUI("YLabel", parent, 450, 100, 70, 1310)
			btnVerwarnung:SetText("")
			function btnVerwarnung:Paint(pw, ph)
				if plist.ply:IsPlayer() then
					hook.Run("YLabelPaint", self, pw, ph)
					btnVerwarnung:SetText(YRP.lang_string("LID_warnings") .. ": " .. plist.ply:GetDInt("int_warnings", -1))
				end
			end

			local btnVerstoesseUp = createVGUI("YButton", parent, 50, 50, 20, 1430)
			btnVerstoesseUp:SetText("⮝")
			function btnVerstoesseUp:DoClick()
				if plist.ply:IsPlayer() then
					net.Start("violation_up")
						net.WriteEntity(plist.ply)
					net.SendToServer()
				end
			end
			local btnVerstoesseDn = createVGUI("YButton", parent, 50, 50, 20, 1480)
			btnVerstoesseDn:SetText("⮟")
			function btnVerstoesseDn:DoClick()
				if plist.ply:IsPlayer() then
					net.Start("violation_dn")
						net.WriteEntity(plist.ply)
					net.SendToServer()
				end
			end
			local btnVerstoesse = createVGUI("YLabel", parent, 450, 100, 70, 1430)
			btnVerstoesse:SetText("")
			function btnVerstoesse:Paint(pw, ph)
				if plist.ply:IsPlayer() then
					hook.Run("YLabelPaint", self, pw, ph)
					btnVerstoesse:SetText(YRP.lang_string("LID_violations") .. ": " .. plist.ply:GetDInt("int_violations", -1))
				end
			end

			local btnArrests = createVGUI("YLabel", parent, 450, 100, 70, 1550)
			btnArrests:SetText("")
			function btnArrests:Paint(pw, ph)
				if plist.ply:IsPlayer() then
					hook.Run("YLabelPaint", self, pw, ph)
					btnArrests:SetText(YRP.lang_string("LID_arrests") .. ": " .. plist.ply:GetDInt("int_arrests", -1))
				end
			end

		end)

		window.tabs:GoToSite("LID_prisoners")

		window:MakePopup()
	end
end)