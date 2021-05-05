--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local EVENT = {}

net.Receive("setting_events", function(len)
	local PARENT = GetSettingsSite()

	if pa(PARENT) then
		local sw = PARENT:GetWide() / 3
		local sh = PARENT:GetTall() / 3



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

		--[[EVENT.StartEvent = createD("YButton", PARENT, YRP.ctr(300), YRP.ctr(60), YRP.ctr(20 + 300 + 20 + 300 + 20), YRP.ctr(20))
		EVENT.StartEvent:SetText("Start Event")
		function EVENT.StartEvent:Paint(pw, ph)
			hook.Run("YButtonAPaint", self, pw, ph)
		end

		EVENT.EndEvent = createD("YButton", PARENT, YRP.ctr(300), YRP.ctr(60), YRP.ctr(20 + 300 + 20 + 300 + 20 + 300 + 20), YRP.ctr(20))
		EVENT.EndEvent:SetText("End Event")
		function EVENT.EndEvent:Paint(pw, ph)
			hook.Run("YButtonRPaint", self, pw, ph)
		end]]

		EVENT.EventList = createD("DListView", PARENT, sw, sh - YRP.ctr(100), 0, YRP.ctr(100))
		EVENT.EventList:AddColumn(YRP.lang_string("LID_id")):SetFixedWidth(80)
		EVENT.EventList:AddColumn(YRP.lang_string("LID_name"))

		net.Receive("yrp_get_events", function(len)
			local tab = net.ReadTable()

			if wk(tab) then
				EVENT.EventList:Clear()

				for n, event in pairs(tab) do
					EVENT.EventList:AddLine(event.uniqueID, event.string_eventname)
				end
			end
		end)



		-- Event Chars
		EVENT.EventChars = createD("DListView", PARENT, sw, sh * 2 - YRP.ctr(100), 0, YRP.ctr(100) + sh)
		EVENT.EventChars:AddColumn(YRP.lang_string("LID_name"))
		EVENT.EventChars:AddColumn("Event Character ID"):SetFixedWidth(120)
		EVENT.EventChars:AddColumn("Event Character NAME")

		net.Receive("yrp_get_event_chars", function(len)
			local tab = net.ReadTable()

			for n, char in pairs(player.GetAll()) do
				EventChars:AddLine(char:SteamName(), char:CharID(), char:RPName())
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
