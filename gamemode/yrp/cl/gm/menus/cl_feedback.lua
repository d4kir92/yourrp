--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- #TICKET

TICKET = TICKET or {}
TICKET.open = false

function toggleTicketMenu()
	if !TICKET.open and YRPIsNoMenuOpen() then
		openTicketMenu()
	else
		closeTicketMenu()
	end
end

function closeTicketMenu()
	TICKET.open = false
	if TICKET.window != nil then
		closeMenu()
		TICKET.window:Remove()
		TICKET.window = nil
	elseif pa(TICKET.content) and pa(TICKET.content:GetParent()) then
		if TICKET.content:GetParent().Close != nil then
			TICKET.content:GetParent():Close()
		end
	end
end

local _url = "https://docs.google.com/forms/d/e/1FAIpQLSd2uI9qa5CCk3s-l4TtOVMca-IXn6boKhzx-gUrPFks1YCKjA/formResponse"

function openTicketMenu()
	openMenu()

	TICKET.open = true
	TICKET.window = createD("YFrame", nil, BFW(), BFH(), BPX(), BPY())
	TICKET.window:Center()
	TICKET.window:SetTitle("LID_sendticket")
	TICKET.window:SetHeaderHeight(YRP.ctr(100))
	function TICKET.window:OnClose()
		closeMenu()
	end
	function TICKET.window:OnRemove()
		closeMenu()
	end
	TICKET.window.systime = SysTime()
	function TICKET.window:Paint(pw, ph)
		Derma_DrawBackgroundBlur(self, self.systime)
		hook.Run("YFramePaint", self, pw, ph)
	end
	TICKET.window:MakePopup()

	CreateTicketContent(TICKET.window.con)
end

function CreateTicketContent(parent)
	TICKET.content = parent

	TICKET.discord = createD("YButton", TICKET.content, YRP.ctr(800), YRP.ctr(50), YRP.ctr(20), YRP.ctr(20))
	TICKET.discord:SetText("LID_getlivesupport")
	function TICKET.discord:Paint(pw, ph)
		hook.Run("YButtonPaint", self, pw, ph) -- surfaceButton(self, pw, ph, YRP.lang_string("LID_getlivesupport"))
	end
	function TICKET.discord:DoClick()
		gui.OpenURL("https://discord.gg/sEgNZxg")
	end

	TICKET.titleP = createD("DPanel", TICKET.content, TICKET.content:GetWide() - YRP.ctr(40), YRP.ctr(50), YRP.ctr(20), YRP.ctr(170))
	function TICKET.titleP:Paint(pw, ph)
		surfaceText(YRP.lang_string("LID_title"), "Y_25_700", YRP.ctr(0), ph / 2, Color(255, 255, 255), 0, 1)
	end
	TICKET.titleT = createD("DTextEntry", TICKET.content, TICKET.content:GetWide() - YRP.ctr(40), YRP.ctr(50), YRP.ctr(20), YRP.ctr(220))

	TICKET.ticketP = createD("DPanel", TICKET.content, TICKET.content:GetWide() - YRP.ctr(40), YRP.ctr(50), YRP.ctr(20), YRP.ctr(300))
	function TICKET.ticketP:Paint(pw, ph)
		surfaceText(YRP.lang_string("LID_ticket") .. " (" .. YRP.lang_string("LID_problems") .. ", " .. YRP.lang_string("LID_suggestions") .. ", ...)", "Y_25_700", YRP.ctr(0), ph/2, Color(255, 255, 255), 0, 1)
	end
	TICKET.ticketT = createD("DTextEntry", TICKET.content, TICKET.content:GetWide() - YRP.ctr(40), YRP.ctr(500), YRP.ctr(20), YRP.ctr(350))
	TICKET.ticketT:SetMultiline(true)

	TICKET.contactP = createD("DPanel", TICKET.content, TICKET.content:GetWide() - YRP.ctr(40), YRP.ctr(50), YRP.ctr(20), YRP.ctr(900))
	function TICKET.contactP:Paint(pw, ph)
		surfaceText(YRP.lang_string("LID_contact") .. " (" .. YRP.lang_string("LID_notrequired") .. ")", "Y_25_700", YRP.ctr(0), ph/2, Color(255, 255, 255), 0, 1)
	end
	TICKET.contactT = createD("DTextEntry", TICKET.content, TICKET.content:GetWide() - YRP.ctr(40), YRP.ctr(50), YRP.ctr(20), YRP.ctr(950))

	TICKET.send = createD("YButton", TICKET.content, YRP.ctr(600), YRP.ctr(50), YRP.ctr(20), YRP.ctr(1050))
	TICKET.send:SetText("LID_sendticket")
	function TICKET.send:Paint(pw, ph)
		hook.Run("YButtonPaint", self, pw, ph) -- surfaceButton(self, pw, ph, string.upper(YRP.lang_string("LID_sendticket")))
	end
	function TICKET.send:DoClick()
		YRP.msg("gm", "send ticket")

		if TICKET.titleT:GetText() != "" or TICKET.ticketT:GetText() != "" or TICKET.contactT:GetText() != "" then
			local entry = {}
			entry["entry.1141598078"] = TICKET.titleT:GetText() or "FAILED"
			entry["entry.761186932"] = TICKET.ticketT:GetText() or "FAILED"
			entry["entry.1633448754"] = TICKET.contactT:GetText() or "FAILED"
			entry["entry.1109864644"] = LocalPlayer():SteamID() or "FAILED"

			http.Post(_url, entry, function(result)
				if result then

				end
			end, function(failed)
				YRP.msg("error", "Ticket: " .. tostring(failed))
			end)

			local _net_table = {}
			_net_table.title = TICKET.titleT:GetText() or "FAILED"
			_net_table.feedback = TICKET.ticketT:GetText() or "FAILED"
			_net_table.contact = TICKET.contactT:GetText() or "FAILED"
			_net_table.steamid = LocalPlayer():SteamID() or "FAILED"
			_net_table.steamname = LocalPlayer():SteamName() or "FAILED"
			_net_table.rpname = LocalPlayer():RPName() or "FAILED"
			net.Start("add_ticket")
				net.WriteTable(_net_table)
			net.SendToServer()
		end

		closeTicketMenu()
	end
end
