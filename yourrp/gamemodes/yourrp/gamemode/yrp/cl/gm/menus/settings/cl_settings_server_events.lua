--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local EVENT = {}

net.Receive("setting_events", function(len)
	local PARENT = GetSettingsSite()

	if pa(PARENT) then
		local sw = PARENT:GetWide() / 3
		local sh = PARENT:GetTall() / 3



		-- Event Chars
		EVENT.EventChars = createD("DListView", PARENT, sw, sh * 2 - YRP.ctr(100), 0, YRP.ctr(100) + sh)
		EVENT.EventChars:AddColumn(YRP.lang_string("LID_name"))
		EVENT.EventChars:AddColumn("Event Character ID"):SetFixedWidth(120)
		EVENT.EventChars:AddColumn("Event Character NAME")
		net.Receive("yrp_get_event_chars", function(len)
			local tab = net.ReadTable()

			EVENT.EventChars:Clear()

			if tab.string_chars then
				local ctab = string.Explode(";", tab.string_chars)
				for n, chartab in pairs(ctab) do
					chartab = string.Explode(",", chartab)
					local rpname = chartab[1]
					for i, v in pairs(player.GetAll()) do
						if v:SteamID() == chartab[1] then
							rpname = v:RPName()
						end
					end
					EVENT.EventChars:AddLine(rpname, chartab[2], chartab[3])
				end
			end
		end)

		EVENT.AddChar = createD("YButton", PARENT, YRP.ctr(300), YRP.ctr(60), YRP.ctr(20), sh + YRP.ctr(20))
		EVENT.AddChar:SetText("Add Char")
		function EVENT.AddChar:Paint(pw, ph)
			if EVENT.EventList and EVENT.EventList:GetSelectedLine() then
				hook.Run("YButtonAPaint", self, pw, ph)
			end
		end
		function EVENT.AddChar:DoClick()
			if EVENT.EventList and EVENT.EventList:GetSelectedLine() then
				local Frame = createD("YFrame", nil, YRP.ctr(500), YRP.ctr(500), 0, 0)
				Frame:SetTitle("Add Char")
				Frame:Center()
				Frame:MakePopup()

				Frame.Char = createD("DComboBox", Frame, YRP.ctr(300), YRP.ctr(60), Frame:GetWide() / 2 - YRP.ctr(300 / 2), Frame:GetTall() - YRP.ctr(60 + 20 + 60 + 20))
				net.Receive("yrp_event_get_chars", function()
					local tab = net.ReadTable()
					Frame.Char:Clear()
					for i, v in pairs(tab) do
						Frame.Char:AddChoice(v.rpname, v.uniqueID)
					end
				end)

				Frame.Player = createD("DComboBox", Frame, YRP.ctr(300), YRP.ctr(60), Frame:GetWide() / 2 - YRP.ctr(300 / 2), Frame:GetTall() - YRP.ctr(60 + 20 + 60 + 20 + 60 + 20 + 60 + 20))
				for i, v in pairs(player.GetAll()) do
					Frame.Player:AddChoice(v:RPName(), v:SteamID())
				end
				function Frame.Player:OnSelect(index, rpname, steamid)
					net.Start("yrp_event_get_chars")
						net.WriteString(steamid)
					net.SendToServer()
				end

				Frame.Add = createD("YButton", Frame, YRP.ctr(300), YRP.ctr(60), Frame:GetWide() / 2 - YRP.ctr(300 / 2), Frame:GetTall() - YRP.ctr(60 + 20))
				Frame.Add:SetText("LID_add")
				function Frame.Add:DoClick()
					local uid = EVENT.EventList:GetLine(EVENT.EventList:GetSelectedLine()):GetValue(1)
					local _, steamid = Frame.Player:GetSelected()
					local charname, charuid = Frame.Char:GetSelected()
					if Frame.Char:GetSelected() then
						net.Start("yrp_event_char_add")
							net.WriteString(uid)
							net.WriteString(steamid)
							net.WriteString(charuid)
							net.WriteString(charname)
						net.SendToServer()
					end

					Frame:Close()
				end
			end
		end

		EVENT.RemoveChar = createD("YButton", PARENT, YRP.ctr(300), YRP.ctr(60), YRP.ctr(20 + 300 + 20), sh + YRP.ctr(20))
		EVENT.RemoveChar:SetText("Remove Char")
		function EVENT.RemoveChar:Paint(pw, ph)
			if EVENT.EventChars:GetSelectedLine() then
				hook.Run("YButtonRPaint", self, pw, ph)
			end
		end
		function EVENT.RemoveChar:DoClick()
			if EVENT.EventChars:GetSelectedLine() then
				local euid = EVENT.EventList:GetLine(EVENT.EventList:GetSelectedLine()):GetValue(1)
				local cuid = EVENT.EventChars:GetLine(EVENT.EventChars:GetSelectedLine()):GetValue(2)

				net.Start("yrp_event_char_remove")
					net.WriteString(euid)
					net.WriteString(cuid)
				net.SendToServer()
			end
		end

		

		-- Events
		EVENT.AddEvent = createD("YButton", PARENT, YRP.ctr(300), YRP.ctr(60), YRP.ctr(20), YRP.ctr(20))
		EVENT.AddEvent:SetText("Add Event")
		function EVENT.AddEvent:Paint(pw, ph)
			hook.Run("YButtonAPaint", self, pw, ph)
		end
		function EVENT.AddEvent:DoClick()
			local Frame = createD("YFrame", nil, YRP.ctr(500), YRP.ctr(300), 0, 0)
			Frame:SetTitle("Add Event")
			Frame:Center()
			Frame:MakePopup()

			Frame.Name = createD("DTextEntry", Frame, YRP.ctr(300), YRP.ctr(60), Frame:GetWide() / 2 - YRP.ctr(300 / 2), Frame:GetTall() - YRP.ctr(60 + 20 + 60 + 20))

			Frame.Add = createD("YButton", Frame, YRP.ctr(300), YRP.ctr(60), Frame:GetWide() / 2 - YRP.ctr(300 / 2), Frame:GetTall() - YRP.ctr(60 + 20))
			Frame.Add:SetText("LID_add")
			function Frame.Add:DoClick()
				net.Start("yrp_event_add")
					net.WriteString(Frame.Name:GetText())
				net.SendToServer()

				Frame:Close()
			end
		end

		EVENT.RemoveEvent = createD("YButton", PARENT, YRP.ctr(300), YRP.ctr(60), YRP.ctr(20 + 300 + 20), YRP.ctr(20))
		EVENT.RemoveEvent:SetText("Remove Event")
		function EVENT.RemoveEvent:Paint(pw, ph)
			if EVENT.EventList:GetSelectedLine() then
				hook.Run("YButtonRPaint", self, pw, ph)
			end
		end
		function EVENT.RemoveEvent:DoClick()
			if EVENT.EventList:GetSelectedLine() then
				local uid = EVENT.EventList:GetLine(EVENT.EventList:GetSelectedLine()):GetValue(1)

				net.Start("yrp_event_remove")
					net.WriteString(uid)
				net.SendToServer()
			end
		end

		EVENT.StartEvent = createD("YButton", PARENT, YRP.ctr(300), YRP.ctr(60), YRP.ctr(20 + 300 + 20 + 300 + 20), YRP.ctr(20))
		EVENT.StartEvent:SetText("Start Event")
		function EVENT.StartEvent:Paint(pw, ph)
			if EVENT.EventList:GetSelectedLine() and !GetGlobalDBool("yrp_event_running", false) then
				hook.Run("YButtonAPaint", self, pw, ph)
			end
		end
		function EVENT.StartEvent:DoClick()
			if EVENT.EventList:GetSelectedLine() then
				F8CloseSettings()

				local uid = EVENT.EventList:GetLine(EVENT.EventList:GetSelectedLine()):GetValue(1)

				net.Start("yrp_event_start")
					net.WriteString(uid)
				net.SendToServer()
			end
		end

		EVENT.EndEvent = createD("YButton", PARENT, YRP.ctr(300), YRP.ctr(60), YRP.ctr(20 + 300 + 20 + 300 + 20 + 300 + 20), YRP.ctr(20))
		EVENT.EndEvent:SetText("End Event")
		function EVENT.EndEvent:Paint(pw, ph)
			if EVENT.EventList:GetSelectedLine() and GetGlobalDBool("yrp_event_running", false) then
				hook.Run("YButtonRPaint", self, pw, ph)
			end
		end
		function EVENT.EndEvent:DoClick()
			if EVENT.EventList:GetSelectedLine() then
				F8CloseSettings()

				local uid = EVENT.EventList:GetLine(EVENT.EventList:GetSelectedLine()):GetValue(1)

				net.Start("yrp_event_end")
					net.WriteString(uid)
				net.SendToServer()
			end
		end

		EVENT.EventList = createD("DListView", PARENT, sw, sh - YRP.ctr(100), 0, YRP.ctr(100))
		EVENT.EventList:AddColumn(YRP.lang_string("LID_id")):SetFixedWidth(80)
		EVENT.EventList:AddColumn(YRP.lang_string("LID_name"))
		function EVENT.EventList:OnRowSelected(rowIndex, row)
			local uid = EVENT.EventList:GetLine(EVENT.EventList:GetSelectedLine()):GetValue(1)

			net.Start("yrp_get_event_chars")
				net.WriteString(uid)
			net.SendToServer()
		end

		net.Receive("yrp_get_events", function(len)
			local tab = net.ReadTable()

			if wk(tab) then
				EVENT.EventList:Clear()

				for n, event in pairs(tab) do
					EVENT.EventList:AddLine(event.uniqueID, event.string_eventname)
				end
			end
		end)
		net.Start("yrp_get_events")
		net.SendToServer()
	end
end)

function OpenSettingsEvents()
	net.Start("setting_events")
	net.SendToServer()
end
