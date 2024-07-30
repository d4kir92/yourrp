--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- #TICKET
TICKET = TICKET or {}
TICKET.open = false
function YRPToggleTicketMenu()
	if not TICKET.open and YRPIsNoMenuOpen() then
		openTicketMenu()
	else
		closeTicketMenu()
	end
end

function closeTicketMenu()
	TICKET.open = false
	if TICKET.window ~= nil then
		YRPCloseMenu()
		TICKET.window:Remove()
		TICKET.window = nil
	elseif YRPPanelAlive(TICKET.content) and YRPPanelAlive(TICKET.content:GetParent()) then
		if TICKET.content:GetParent().Close ~= nil then
			TICKET.content:GetParent():Close()
		end
	end

	YRPCloseCombinedMenu()
end

local _url = "https://docs.google.com/forms/d/e/1FAIpQLSd2uI9qa5CCk3s-l4TtOVMca-IXn6boKhzx-gUrPFks1YCKjA/formResponse"
function openTicketMenu()
	YRPOpenMenu()
	TICKET.open = true
	TICKET.window = YRPCreateD("YFrame", nil, BFW(), BFH(), BPX(), BPY())
	TICKET.window:Center()
	TICKET.window:SetTitle("LID_sendticket")
	TICKET.window:SetHeaderHeight(YRP:ctr(100))
	function TICKET.window:OnClose()
		YRPCloseMenu()
	end

	function TICKET.window:OnRemove()
		YRPCloseMenu()
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
	TICKET.discord = YRPCreateD("YButton", TICKET.content, YRP:ctr(800), YRP:ctr(50), YRP:ctr(20), YRP:ctr(20))
	TICKET.discord:SetText("LID_getlivesupport")
	function TICKET.discord:Paint(pw, ph)
		hook.Run("YButtonPaint", self, pw, ph)
	end

	function TICKET.discord:DoClick()
		gui.OpenURL("https://discord.gg/sEgNZxg")
	end

	TICKET.titleP = YRPCreateD("DPanel", TICKET.content, TICKET.content:GetWide() - YRP:ctr(40), YRP:ctr(50), YRP:ctr(20), YRP:ctr(170))
	function TICKET.titleP:Paint(pw, ph)
		surfaceText(YRP:trans("LID_title"), "Y_25_500", YRP:ctr(0), ph / 2, Color(255, 255, 255, 255), 0, 1)
	end

	TICKET.titleT = YRPCreateD("DTextEntry", TICKET.content, TICKET.content:GetWide() - YRP:ctr(40), YRP:ctr(50), YRP:ctr(20), YRP:ctr(220))
	TICKET.ticketP = YRPCreateD("DPanel", TICKET.content, TICKET.content:GetWide() - YRP:ctr(40), YRP:ctr(50), YRP:ctr(20), YRP:ctr(300))
	function TICKET.ticketP:Paint(pw, ph)
		surfaceText(YRP:trans("LID_ticket") .. " ( " .. YRP:trans("LID_problems") .. ", " .. YRP:trans("LID_suggestions") .. ", ...)", "Y_25_500", YRP:ctr(0), ph / 2, Color(255, 255, 255, 255), 0, 1)
	end

	TICKET.ticketT = YRPCreateD("DTextEntry", TICKET.content, TICKET.content:GetWide() - YRP:ctr(40), YRP:ctr(500), YRP:ctr(20), YRP:ctr(350))
	TICKET.ticketT:SetMultiline(true)
	TICKET.contactP = YRPCreateD("DPanel", TICKET.content, TICKET.content:GetWide() - YRP:ctr(40), YRP:ctr(50), YRP:ctr(20), YRP:ctr(900))
	function TICKET.contactP:Paint(pw, ph)
		surfaceText(YRP:trans("LID_contact") .. " ( " .. YRP:trans("LID_notrequired") .. " )", "Y_25_500", YRP:ctr(0), ph / 2, Color(255, 255, 255, 255), 0, 1)
	end

	TICKET.contactT = YRPCreateD("DTextEntry", TICKET.content, TICKET.content:GetWide() - YRP:ctr(40), YRP:ctr(50), YRP:ctr(20), YRP:ctr(950))
	TICKET.send = YRPCreateD("YButton", TICKET.content, YRP:ctr(600), YRP:ctr(50), YRP:ctr(20), YRP:ctr(1050))
	TICKET.send:SetText("LID_sendticket")
	function TICKET.send:Paint(pw, ph)
		hook.Run("YButtonPaint", self, pw, ph)
	end

	function TICKET.send:DoClick()
		YRP:msg("gm", "send ticket")
		if TICKET.titleT:GetText() ~= "" or TICKET.ticketT:GetText() ~= "" or TICKET.contactT:GetText() ~= "" then
			local entry = {}
			entry["entry.1141598078"] = TICKET.titleT:GetText() or "FAILED"
			entry["entry.761186932"] = TICKET.ticketT:GetText() or "FAILED"
			entry["entry.1633448754"] = TICKET.contactT:GetText() or "FAILED"
			entry["entry.1109864644"] = LocalPlayer():YRPSteamID() or "FAILED"
			local _net_table = {}
			_net_table.title = TICKET.titleT:GetText() or "FAILED"
			_net_table.feedback = TICKET.ticketT:GetText() or "FAILED"
			_net_table.contact = TICKET.contactT:GetText() or "FAILED"
			_net_table.steamid = LocalPlayer():YRPSteamID() or "FAILED"
			_net_table.steamname = LocalPlayer():SteamName() or "FAILED"
			_net_table.rpname = LocalPlayer():RPName() or "FAILED"
			net.Start("nws_yrp_add_ticket")
			net.WriteTable(_net_table)
			net.SendToServer()
			notification.AddLegacy("TICKET SENDED", 0, 3)
		end

		closeTicketMenu()
	end
end
