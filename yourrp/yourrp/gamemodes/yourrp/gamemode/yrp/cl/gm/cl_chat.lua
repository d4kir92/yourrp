--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local _type = type
-- #CHAT
yrpChat = yrpChat or {}
local yrp_chat_show = false
local commands = {"/rpname [NAME] NEWNAME", "!rpname [NAME] NEWNAME", "/pm NAME MESSAGE", "!pm NAME MESSAGE", "/w NAME MESSAGE", "!w NAME MESSAGE", "/afk", "!afk", "/dnd", "!dnd", "/help", "!help", "/dropweapon", "!dropweapon", "/dropmoney AMOUNT", "!dropmoney AMOUNT"}
local admincommands = {"/tag_ug", "!tag_ug", "/tag_tra", "!tag_tra", "/setmoney NAME AMOUNT", "!setmoney NAME AMOUNT", "/addxp NAME AMOUNT", "!addxp NAME AMOUNT", "/addlevel NAME AMOUNT", "!addlevel NAME AMOUNT", "/setlevel NAME AMOUNT", "!setlevel NAME AMOUNT", "!resetlevels true", "/resetlevels true", "/revive NAME", "!revive NAME", "/alert TEXT", "!alert TEXT", "/givelicense NAME LICENSENAME", "!givelicense NAME LICENSENAME"}
local yrp_logo = Material("yrp/yrp_icon")
local words = 0
local _delay = 4
local _fadeout = CurTime() + _delay
local chatclosedforkeybinds = true
local _showChat = false
local chatids = {}
local oldchoices = {}
local chatAlpha = 255
local CHATMODE = "SAY"
local BR = 8
local TOPBAR_H = 33
local BOTBAR_H = 36
local C_HE = Color(40, 130, 180, 255)
local C_BG = Color(46, 46, 46, 255)
local C_FG = Color(32, 32, 32, 255)
local function IsChatVisible()
	return _showChat
end

function GetChatMode()
	return CHATMODE
end

function SetChatMode(mode)
	if _type(mode) == "string" then
		CHATMODE = string.upper(mode)
		if IsNotNilAndNotFalse(yrpChat, "yrpChat") and YRPPanelAlive(yrpChat.comboBox, "yrpChat.comboBox") then
			yrpChat.comboBox:SetText(CHATMODE)
		end
	end
end

local function ContainsIp(...)
	local tab = {...}
	local str = ""
	for i, v in pairs(tab) do
		if isstring(v) then
			str = str .. v
		end
	end

	tab = string.Explode(" ", str)
	for i, v in pairs(tab) do
		local ex = string.Explode(".", v)
		if table.Count(ex) == 4 then
			local isip = true
			for j, n in pairs(ex) do
				if isnumber(tonumber(n)) then
					if tonumber(n) > 255 then
						isip = false
						break
					end
				else
					isip = false
					break
				end
			end

			if isip then return true end
		end
	end

	return false
end

local function ChatBlacklisted(...)
	local tab = {...}
	local blacklist = GetGlobalYRPTable("yrp_blacklist_chat", {})
	local str = ""
	for i, v in pairs(tab) do
		if isstring(v) then
			str = str .. v
		end
	end

	for i, black in pairs(blacklist) do
		if string.find(str, black.value, 1, true) then return true end
	end

	return false
end

local function update_chat_choices()
	if YRPPanelAlive(yrpChat.window, "yrpChat.window") and yrpChat.comboBox ~= nil then
		yrpChat.comboBox:Clear()
		chatids = {}
		for i, v in pairs(GetGlobalYRPTable("yrp_chat_channels")) do
			local enabled = tobool(v.bool_enabled)
			if enabled then
				local selected = false
				if CHATMODE == v.string_name then
					selected = true
				end

				yrpChat.comboBox:AddChoice(v.string_name, v.string_name, selected)
				chatids[v.string_name] = tonumber(v.uniqueID)
			end
		end
	end
end

hook.Add(
	"Think",
	"yrp_think_chat_choices",
	function()
		if GetGlobalYRPTable("yrp_chat_channels", {}) ~= oldchoices then
			oldchoices = GetGlobalYRPTable("yrp_chat_channels", {})
			update_chat_choices()
		end
	end
)

hook.Add(
	"yrp_language_changed",
	"chat_language_changed",
	function()
		update_chat_choices()
	end
)

function ChatIsClosedForChat()
	if chatclosedforkeybinds and YRPIsChatEnabled("chatclosedforchat") then
		return chatclosedforkeybinds
	else
		return true
	end
end

counti = counti or 0
counti = counti + 1
local function YRPCheckChatVisible()
	if yrpChat.window ~= nil then
		if CurTime() > _fadeout and not yrpChat.window:HasFocus() and not yrpChat.writeField:HasFocus() and not yrpChat.comboBox:HasFocus() and not yrpChat.settings:HasFocus() then
			_showChat = false
		else
			_showChat = true
		end

		if YRPIsChatEnabled("YRPCheckChatVisible") == false then
			_showChat = false
		end

		if IsChatVisible() then
			chatAlpha = chatAlpha + 10
		else
			chatAlpha = chatAlpha - 10
		end

		if YRPScoreboard:IsVisible() or YRPScoreboard:IsVisible() then
			chatAlpha = 0
			yrpChat.window:SetVisible(false)
			yrpChat.window:Hide()
		else
			yrpChat.window:SetVisible(true)
			yrpChat.window:Show()
			chatAlpha = math.Clamp(chatAlpha, 0, 255)
			--yrpChat.window:SetAlpha( chatAlpha)
			yrpChat.window.logo:SetAlpha(chatAlpha)
			yrpChat.writeField:SetAlpha(chatAlpha)
			yrpChat.comboBox:SetAlpha(chatAlpha)
			yrpChat.settings:SetAlpha(chatAlpha)
		end
	end
end

function ChatAlpha()
	return chatAlpha
end

local function YRPCreateText()
	local lply = LocalPlayer()
	local newtext = YRPCreateD("RichText", yrpChat.content:GetCanvas(), lply:HudValue("CH", "SIZE_W"), 50, 0, 0)
	newtext:SetMouseInputEnabled(false)
	newtext:Dock(TOP)
	newtext:SetVerticalScrollbarEnabled(false)
	function newtext:Paint(pw, ph)
	end

	--draw.RoundedBox(0, 0, 0, pw, ph, Color( 255,255,0,200) )
	function newtext:GetFontSize()
		local ts = LocalPlayer().CH_TS or LocalPlayer():HudValue("CH", "TS")
		if ts ~= nil then
			ts = tonumber(ts)
		end

		if ts > 6 then return ts end

		return 6
	end

	function newtext:GetFontInternal()
		local ts = self:GetFontSize()
		if ts and ts >= 6 then return "Y_" .. ts .. "_500" end

		return "Y_" .. 14 .. "_500"
	end

	function newtext:PerformLayout()
		local font = self:GetFontInternal()
		if font then
			if self.SetUnderlineFont ~= nil then
				self:SetUnderlineFont(font)
			end

			self:SetFontInternal(font)
		end

		self:SetFGColor(Color(255, 255, 255, 255))
		self:SetBGColor(Color(255, 255, 255, 0))
	end

	newtext:DockMargin(0, 0, 0, 4)
	newtext.text = ""
	function newtext:GetText()
		return newtext.text
	end

	newtext.OldAppendText = newtext.AppendText
	function newtext:AppendText(msg)
		newtext.text = newtext.text .. msg
		newtext:OldAppendText(msg)
	end

	newtext.OldInsertClickableTextStart = newtext.InsertClickableTextStart
	function newtext:InsertClickableTextStart(signal)
		newtext:SetMouseInputEnabled(true)
		newtext:OldInsertClickableTextStart(signal)
	end

	return newtext
end

local function InitYRPChat()
	if YRPIsChatEnabled("InitYRPChat") then
		local lply = LocalPlayer()
		lply.yrp_timestamp = lply.yrp_timestamp or false
		if yrpChat.window == nil then
			-- MAIN FRAME
			yrpChat.window = YRPCreateD("DFrame", nil, 100, 100, 100, 100)
			yrpChat.window:DockPadding(BR, BR, BR, BR)
			yrpChat.window:SetTitle("")
			yrpChat.window:ShowCloseButton(false)
			yrpChat.window:SetDraggable(false)
			function yrpChat.window:Paint(pw, ph)
				if IsChatVisible() then
					draw.RoundedBoxEx(5, 0, 0, pw, TOPBAR_H, C_HE, true, true, false, false)
					draw.RoundedBoxEx(5, 0, TOPBAR_H, pw, ph - TOPBAR_H, C_FG, false, false, true, true)
					if self.logo then
						if self.logo.svlogo ~= GetGlobalYRPString("text_server_logo", "") then
							self.logo.svlogo = GetGlobalYRPString("text_server_logo", "")
							if not strEmpty(GetGlobalYRPString("text_server_logo", "")) then
								self.logo:SetHTML(YRPGetHTMLImage(GetGlobalYRPString("text_server_logo", ""), TOPBAR_H - 2 * BR, TOPBAR_H - 2 * BR))
								self.logo:Show()
							else
								self.logo:Hide()
							end
						end

						if not self.logo:IsVisible() then
							surface.SetMaterial(yrp_logo)
							surface.SetDrawColor(Color(255, 255, 255, 255))
							surface.DrawTexturedRect(BR, BR, TOPBAR_H - 2 * BR, TOPBAR_H - 2 * BR)
						end
					end

					local x, y = yrpChat.window:GetPos()
					local w, h = yrpChat.window:GetSize()
					if lply.HudValue then
						local px = lply:HudValue("CH", "POSI_X")
						local py = lply:HudValue("CH", "POSI_Y")
						local sw = lply:HudValue("CH", "SIZE_W")
						local sh = lply:HudValue("CH", "SIZE_H")
						--YRP.msg( "deb", "InitYRPChat x " .. x .. ", y " .. y .. ", w " .. w .. ", h " .. h .. ", px " .. px .. ", py " .. py .. ", sw " .. sw ..", sh " .. sh)
						if px ~= x or py ~= y or sw ~= w or sh ~= h then
							yrpChat.window:SetPos(px, py)
							yrpChat.window:SetSize(sw, sh)
						end

						local _com = yrpChat.writeField:GetText()
						_com = string.upper(_com)
						local test = string.sub(_com, 3)
						if (string.StartWith(_com, "!S") or string.StartWith(_com, "/S")) and test ~= nil and chatids[test] ~= nil then
							yrpChat.writeField:SetText("")
							yrpChat.comboBox:ChooseOption(test)
						end
					end
				else
					self:MoveToBack()
				end
			end

			-- TOPBAR
			yrpChat.TopBar = YRPCreateD("DPanel", yrpChat.window, TOPBAR_H - 2 * BR, TOPBAR_H - 2 * BR, 0, 0)
			yrpChat.TopBar:DockMargin(0, 0, 0, BR)
			yrpChat.TopBar:Dock(TOP)
			function yrpChat.TopBar:Paint(pw, ph)
				if IsChatVisible() then
					local name = GetGlobalYRPString("text_server_name", "")
					if strEmpty(name) then
						name = YRPGetHostName()
					end

					draw.SimpleText(name, "Y_18_700", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					draw.SimpleText(player.GetCount() .. "/" .. game.MaxPlayers(), "Y_18_700", pw - BR, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
				end
			end

			-- BOTBAR
			yrpChat.BotBar = YRPCreateD("DPanel", yrpChat.window, BOTBAR_H - 2 * BR, BOTBAR_H - 2 * BR, 0, 0)
			yrpChat.BotBar:DockMargin(0, BR, 0, 0)
			yrpChat.BotBar:Dock(BOTTOM)
			function yrpChat.BotBar:Paint(pw, ph)
			end

			--draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 100))
			-- FILL
			yrpChat.content = YRPCreateD("DScrollPanel", yrpChat.window, 10, 10, 0, 0)
			yrpChat.content:Dock(FILL)
			yrpChat.content:DockMargin(0, BR, 0, 0)
			yrpChat.content.delay = 0
			yrpChat.content.oldy = 0
			function yrpChat.content:Paint(pw, ph)
				if IsChatVisible() then
					draw.RoundedBox(0, 0, 0, pw, ph, C_BG)
					self:SetAlpha(255)
				else
					self:SetAlpha(0)
				end

				if self.delay < CurTime() then
					self.delay = CurTime() + 0.01
					self.oldy = math.Clamp(Lerp(FrameTime() * 16, self.oldy, self:GetCanvas():GetTall()), 0, self:GetCanvas():GetTall())
				end

				if not vgui.CursorVisible() then
					self.VBar:AnimateTo(self.oldy, 0.5, 0, 0.5)
				end
			end

			local sbar = yrpChat.content.VBar
			function sbar:Paint(w, h)
				if IsChatVisible() then
					draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 10))
				end
			end

			function sbar.btnUp:Paint(w, h)
				--draw.RoundedBox(0, 0, 0, w, h, Color( 60, 60, 60 ) )
				if YRP.GetDesignIcon("64_angle-up") then
					surface.SetDrawColor(Color(255, 255, 255, 255))
					surface.SetMaterial(YRP.GetDesignIcon("64_angle-up"))
					surface.DrawTexturedRect(0, 0, w, h)
				end
			end

			function sbar.btnDown:Paint(w, h)
				--draw.RoundedBox(0, 0, 0, w, h, Color( 60, 60, 60 ) )
				if YRP.GetDesignIcon("64_angle-down") then
					surface.SetDrawColor(Color(255, 255, 255, 255))
					surface.SetMaterial(YRP.GetDesignIcon("64_angle-down"))
					surface.DrawTexturedRect(0, 0, w, h)
				end
			end

			function sbar.btnGrip:Paint(w, h)
				draw.RoundedBox(w / 2, 0, 0, w, h, Color(255, 255, 255, 160))
			end

			function yrpChat.content:GoToEnd()
			end

			--self.VBar:AnimateTo( self:GetTall(), 0.5, 0, 0.5 )
			-- TOPBAR CONTENT
			yrpChat.window.logo = YRPCreateD("DHTML", yrpChat.TopBar, TOPBAR_H - 2 * BR, TOPBAR_H - 2 * BR, 0, 0)
			-- BOTBAR CONTENT
			yrpChat.comboBox = YRPCreateD("DComboBox", yrpChat.BotBar, 70, BOTBAR_H - 2 * BR, 0, 0)
			yrpChat.comboBox:Dock(LEFT)
			yrpChat.comboBox:DockMargin(0, 0, BR, 0)
			update_chat_choices()
			function yrpChat.comboBox:Paint(pw, ph)
				surface.SetDrawColor(Color(255, 255, 255, 0))
				surface.DrawRect(0, 0, pw, ph)
				self:SetTextColor(Color(255, 255, 255, 255))
			end

			function yrpChat.comboBox:OnSelect(index, value, data)
				SetChatMode(value)
				net.Start("nws_yrp_set_chat_mode")
				net.WriteString(string.upper(value))
				net.SendToServer()
			end

			yrpChat.settings = YRPCreateD("YButton", yrpChat.BotBar, BOTBAR_H - 2 * BR, BOTBAR_H - 2 * BR, 0, 0)
			yrpChat.settings:Dock(RIGHT)
			yrpChat.settings:DockMargin(BR, 0, 0, 0)
			yrpChat.settings:SetText("")
			function yrpChat.settings:Paint(pw, ph)
				local w = pw - pw % 4
				local h = ph - ph % 4
				if YRP.GetDesignIcon("64_cog") ~= nil then
					surface.SetDrawColor(Color(255, 255, 255, 255))
					surface.SetMaterial(YRP.GetDesignIcon("64_cog"))
					surface.DrawTexturedRect((pw - w) / 2, (ph - h) / 2, w, h)
				end
			end

			function yrpChat.settings:DoClick()
				local win = YRPCreateD("YFrame", nil, 400, 400, 0, 0)
				win:MakePopup()
				win:Center()
				win:SetTitle("LID_settings")
				local tila = YRPCreateD("YLabel", win:GetContent(), 350, 25, 25, 0)
				tila:SetText("Timestamp")
				local ticb = YRPCreateD("DCheckBox", win:GetContent(), 25, 25, 0, 0)
				ticb:SetChecked(lply.yrp_timestamp)
				function ticb:OnChange()
					lply.yrp_timestamp = not lply.yrp_timestamp
				end

				local tspn = YRPCreateD("YLabel", win:GetContent(), 380, 25, 0, 50)
				tspn:SetText("LID_textsize")
				local tsnw = YRPCreateD("DNumberWang", win:GetContent(), 380, 25, 0, 50 + 25)
				tsnw:SetValue(LocalPlayer().CH_TS or LocalPlayer():HudValue("CH", "TS"))
				tsnw:SetMin(10)
				tsnw:SetMax(64)
				function tsnw:OnValueChanged(val)
					local v = tsnw:GetValue()
					if v >= 10 and v <= 64 then
						LocalPlayer().CH_TS = tsnw:GetValue()
					end
				end

				local dela = YRPCreateD("YLabel", win:GetContent(), 380, 25, 0, 125)
				dela:SetText("Chat Delay")
				local denw = YRPCreateD("DNumberWang", win:GetContent(), 380, 25, 0, 125 + 25)
				denw:SetValue(LocalPlayer():GetYRPInt("int_chatdelay", 4))
				denw:SetMin(1)
				denw:SetMax(50)
				function denw:OnValueChanged(val)
					local v = denw:GetValue()
					if v >= 1 and v <= 50 then
						net.Start("nws_yrp_chatdelay")
						net.WriteInt(v, 8)
						net.SendToServer()
					end
				end
			end

			yrpChat.writeField = YRPCreateD("DTextEntry", yrpChat.BotBar, 0, BOTBAR_H - 2 * BR, 0, 0)
			yrpChat.writeField:Dock(BOTTOM)
			yrpChat.writeField:SetHistoryEnabled(true)
			function yrpChat.writeField:GetAutoComplete(text)
				local suggestions = {}
				for _, ply in ipairs(player.GetAll()) do
					if string.StartWith(ply:RPName(), text) then
						table.insert(suggestions, ply:Nick())
					end
				end

				for _, cmd in pairs(commands) do
					if string.StartWith(cmd, text) then
						table.insert(suggestions, cmd)
					end
				end

				if LocalPlayer():HasAccess("chat1") then
					for _, cmd in pairs(admincommands) do
						if string.StartWith(cmd, text) then
							table.insert(suggestions, cmd)
						end
					end
				end

				return suggestions
			end

			function yrpChat.writeField:PerformLayout()
				local ts = LocalPlayer().CH_TS or LocalPlayer():HudValue("CH", "TS")
				if ts > 6 then
					if self.SetUnderlineFont ~= nil then
						self:SetUnderlineFont("Y_" .. ts .. "_500")
					end

					self:SetFontInternal("Y_" .. ts .. "_500")
				end

				self:SetTextColor(Color(40, 40, 40))
				self:SetFGColor(Color(255, 255, 255, 0))
				self:SetBGColor(Color(255, 255, 255, 0))
			end

			function yrpChat.writeField:Paint(pw, ph)
				surface.SetDrawColor(C_BG)
				surface.DrawRect(0, 0, yrpChat.writeField:GetWide(), yrpChat.writeField:GetTall())
				yrpChat.writeField:DrawTextEntryText(Color(255, 255, 255, 255), Color(255, 255, 255, 0), Color(255, 255, 255, 255))
				--if !yrpChat.writeField:HasFocus() and !yrpChat.comboBox:HasFocus() and !yrpChat.comboBox:IsHovered() then
				--timer.Simple(0.1, function()
				--if YRPPanelAlive(yrpChat.window, "test2424") and !yrpChat.writeField:HasFocus() and !yrpChat.comboBox:HasFocus() and !yrpChat.comboBox:IsHovered() then
				--yrpChat.closeChatbox( "NOT FOCUS ANYMORE" )
				--end
				--end)
				--end
			end

			yrpChat.writeField.OnKeyCode = function(self, code)
				if code == KEY_ESCAPE then
					yrpChat.closeChatbox("PRESSED ESCAPE")
					gui.HideGameUI()
				elseif code == KEY_ENTER then
					if not strEmpty(string.Trim(self:GetText())) then
						local tex = self:GetText()
						local text = ""
						for i = 0, 10 do
							timer.Simple(
								2 * i,
								function()
									if not strEmpty(string.Trim(tex)) then
										text = string.sub(tex, 1, 120)
										tex = string.sub(tex, 121)
										yrpChat.writeField:AddHistory(text)
										if string.StartWith(text, "!") or string.StartWith(text, "/") or string.StartWith(text, "@") then
											LocalPlayer():ConCommand("say \"" .. text .. "\"")
										else
											LocalPlayer():ConCommand("say \"!" .. CHATMODE .. " " .. text .. "\"")
										end
									end
								end
							)
						end
					end

					yrpChat.closeChatbox("PRESSED ENTER")
				end
			end

			function yrpChat:openChatbox(bteam)
				if not YRPPanelAlive(yrpChat.window, "yrpChat.window 2") then
					notification.AddLegacy("[YourRP] [openChatbox] ChatBox Window broken", NOTIFY_ERROR, 10)
					yrp_chat_show = false

					return
				end

				if not yrp_chat_show then
					yrp_chat_show = true
					yrpChat.window:MakePopup()
					yrpChat.comboBox:RequestFocus()
					yrpChat.writeField:RequestFocus()
					yrpChat._chatIsOpen = true
					gamemode.Call("StartChat", bteam)
					chatclosedforkeybinds = false
					once = false
				end
			end

			function yrpChat:closeChatbox(reason)
				if not YRPPanelAlive(yrpChat.window, "yrpChat.window 2") then
					notification.AddLegacy("[YourRP] [closeChatbox] ChatBox Window broken", NOTIFY_ERROR, 10)
					yrp_chat_show = false
					_fadeout = CurTime()

					return
				end

				if yrp_chat_show then
					yrp_chat_show = false
					_fadeout = CurTime()
					gui.EnableScreenClicker(false)
					yrpChat._chatIsOpen = false
					gamemode.Call("FinishChat")
					yrpChat.writeField:SetText("")
					gamemode.Call("ChatTextChanged", "")
					yrpChat.window:SetMouseInputEnabled(false)
					yrpChat.window:SetKeyboardInputEnabled(false)
					timer.Simple(
						0.1,
						function()
							chatclosedforkeybinds = true
						end
					)
				end
			end

			function YRPChatChangeYRPTextColor(newtext, str, cstr, color)
				if string.StartWith(str, cstr .. ">") then
					str = string.Replace(str, cstr .. ">", "")
					newtext:InsertColorChange(color.r, color.g, color.b, color.a)
					newtext:AppendText(str)
				end
			end

			if oldAddText == nil then
				oldAddText = chat.AddText
			end

			function chat.AddText(...)
				if ContainsIp(...) or ChatBlacklisted(...) then return end
				local args = {...}
				local last = args[#args]
				local istext = true
				if last and _type(last) == "string" and (string.EndsWith(last, ".jpeg") or string.EndsWith(last, ".jpg") or string.EndsWith(last, ".png") or string.EndsWith(last, ".gif")) then
					istext = false
				end

				if istext then
					local newtext = YRPCreateText()
					_delay = 3
					if lply.yrp_timestamp and YRPIsChatEnabled("chataddtext") then
						local clock = {}
						clock.sec = os.date("%S")
						clock.min = os.date("%M")
						clock.hours = os.date("%I")
						newtext:InsertColorChange(200, 200, 255, 255)
						newtext:AppendText(clock.hours .. ":" .. clock.min .. ":" .. clock.sec .. " ")
						newtext:InsertColorChange(255, 255, 255, 255)
					end

					-- REMOVE CHAT COMMANDS
					--[[for i, obj in pairs(args) do
						local t = string.lower(_type(obj))

						if t == "string" and string.StartWith(obj, ": !") or string.StartWith(obj, ": /") then
							YRP.msg("note", "HIDE COMMANDS: " .. tostring(obj))
							--return false
						end
					end]]
					for i, obj in pairs(args) do
						local t = string.lower(_type(obj))
						if t == "table" then
							if isnumber(tonumber(obj.r)) and isnumber(tonumber(obj.g)) and isnumber(tonumber(obj.b)) then
								newtext:InsertColorChange(obj.r, obj.g, obj.b, 255)
							end
						elseif t == "string" then
							_delay = _delay + string.len(obj)
							local _text = string.Explode(" ", obj)
							for k, str in pairs(_text) do
								if not strEmpty(str) then
									words = words + 1
								end

								if k > 1 then
									newtext:AppendText(" ")
								end

								local _l = {}
								_l.l_www = false
								_l.l_secure = false
								_l.l_start = string.find(str, "https://", 1, true)
								if _l.l_start ~= nil then
									_l.l_secure = true
								else
									_l.l_secure = false
									_l.l_start = string.find(str, "http://", 1, true)
									if _l.l_start == nil then
										_l.l_www = true
										_l.l_start = string.find(str, "www.", 1, true)
									else
										_l.l_start = string.find(str, ".", 1, true)
										if _l.l_start ~= nil then
											_l.l_point = true
										end
									end
								end

								if _l.l_start ~= nil then
									_l.l_end = #str
									local _link = string.sub(str, _l.l_start, _l.l_end)
									if _l.l_www then
										_link = "https://" .. _link
									end

									if not strEmpty(_link) then
										if _l.l_secure then
											newtext:InsertColorChange(200, 200, 255, 255)
										else
											newtext:InsertColorChange(255, 100, 100, 255)
										end

										newtext:InsertClickableTextStart(_link) -- Make incoming text fire the "OpenWiki" value when clicked
										newtext:AppendText(_link)
										newtext:InsertClickableTextEnd() -- End clickable text here
										newtext:InsertColorChange(255, 255, 255, 255)
										function newtext:ActionSignal(signalName, signalValue)
											if signalName == "TextClicked" and signalValue == _link then
												gui.OpenURL(_link)
											end
										end
									end
								else
									if string.find(str, "<", 1, true) then
										local nstr = string.Explode("<", str)
										for id, v in pairs(nstr) do
											YRPChatChangeYRPTextColor(newtext, v, "red", Color(255, 0, 0, 255))
											YRPChatChangeYRPTextColor(newtext, v, "green", Color(0, 255, 0, 255))
											YRPChatChangeYRPTextColor(newtext, v, "blue", Color(0, 0, 255, 255))
											YRPChatChangeYRPTextColor(newtext, v, "yellow", Color(255, 255, 0, 255))
											YRPChatChangeYRPTextColor(newtext, v, "black", Color(0, 0, 0, 255))
											YRPChatChangeYRPTextColor(newtext, v, "white", Color(255, 255, 255, 255))
											YRPChatChangeYRPTextColor(newtext, v, "/red", Color(255, 255, 255, 255))
											YRPChatChangeYRPTextColor(newtext, v, "/green", Color(255, 255, 255, 255))
											YRPChatChangeYRPTextColor(newtext, v, "/blue", Color(255, 255, 255, 255))
											YRPChatChangeYRPTextColor(newtext, v, "/yellow", Color(255, 255, 255, 255))
											YRPChatChangeYRPTextColor(newtext, v, "/black", Color(255, 255, 255, 255))
											YRPChatChangeYRPTextColor(newtext, v, "/white", Color(255, 255, 255, 255))
										end
									else
										newtext:AppendText(str)
									end
								end
							end
						elseif t == "entity" and obj:IsPlayer() then
							local col = GAMEMODE:GetTeamColor(obj)
							if isnumber(tonumber(col.r)) and isnumber(tonumber(col.g)) and isnumber(tonumber(col.b)) then
								yrpChat.richText:InsertColorChange(col.r, col.g, col.b, 255)
								newtext:AppendText(obj:Nick())
							end
						elseif t == "number" then
							newtext:AppendText(obj)
							words = words + 1
						elseif t == "player" then
							--YRP.msg( "note", "chat.addtext ( boolean): " .. tostring(obj) )
							--YRP.msg( "error", "chat.addtext (entity): " .. tostring(obj) )
							-- invalid players
							local col = GAMEMODE:GetTeamColor(obj)
							if isnumber(tonumber(col.r)) and isnumber(tonumber(col.g)) and isnumber(tonumber(col.b)) then
								newtext:InsertColorChange(col.r, col.g, col.b, 255)
								newtext:AppendText(obj:RPName())
							end
						elseif t == "entity" then
							-- invalid entities
							if obj.Nick then
								newtext:AppendText(obj:Nick())
							elseif obj.GetName then
								newtext:AppendText(obj:GetName())
							end
						elseif t ~= "boolean" and t ~= "entity" and t ~= "function" and t ~= "panel" then
							YRP.msg("error", "chat.addtext TYPE: " .. t .. " obj: " .. tostring(obj))
						end
					end

					_fadeout = CurTime() + LocalPlayer():GetYRPInt("int_chatdelay", 4)
					local ts = LocalPlayer().CH_TS or LocalPlayer():HudValue("CH", "TS")
					if ts > 0 then
						surface.SetFont("Y_" .. ts .. "_500")
					end

					local tx, _ = surface.GetTextSize(newtext.text)
					local rows = math.Clamp(math.ceil(tx / lply:HudValue("CH", "SIZE_W")), 1, 5)
					newtext:SetTall(rows * ts)
					yrpChat.content:GoToEnd()
					oldAddText(...)
				else
					local w = lply:HudValue("CH", "SIZE_W")
					--local h = lply:HudValue("CH", "SIZE_H")
					local newtext = YRPCreateText()
					if args[1] and _type(args[1]) == "table" then
						local col = args[1]
						newtext:InsertColorChange(col.r, col.g, col.b, 255)
					end

					if args[2] then
						newtext:AppendText(args[2])
					end

					local ts = LocalPlayer().CH_TS or LocalPlayer():HudValue("CH", "TS")
					if ts > 0 then
						surface.SetFont("Y_" .. ts .. "_500")
					end

					local tx, _ = surface.GetTextSize(newtext.text)
					local rows = math.Clamp(math.ceil(tx / lply:HudValue("CH", "SIZE_W")), 1, 5)
					newtext:SetTall(rows * ts)
					local img = YRPCreateD("HTML", yrpChat.content:GetCanvas(), w - 32, 250, 0, 0)
					img:SetParent(yrpChat.content)
					img:SetMouseInputEnabled(false)
					img:Dock(TOP)
					img:SetHTML(YRPGetHTMLImage(last, w - 32, 250))
					img:DockMargin(4, 0, 0, 4)
					img:SetEnabled(true)
				end
			end

			yrpChat.content:GoToEnd()
			yrpChat.content:GoToEnd()
			function YRPChatThink()
				if YRPPanelAlive(yrpChat.window, "yrpChat.window 3") then
					YRPCheckChatVisible()
					timer.Simple(0.01, YRPChatThink)
				end
			end

			YRPChatThink()
		end
	end
end

local function CheckIfRemoved()
	local wasremoved = false
	if YRPPanelAlive(yrpChat.window, "yrpChat.window 4") then
		yrpChat.window:Remove()
		yrpChat.window = nil
		wasremoved = true
		-- Already chat created
	end

	if not YRPPanelAlive(yrpChat.window, "yrpChat.window 5") then
		yrpChat = {}
	end

	if wasremoved and YRPIsChatEnabled("wasremoved") then
		InitYRPChat()
	end
end

timer.Simple(0, CheckIfRemoved)
hook.Add(
	"PlayerBindPress",
	"yrp_overrideChatbind",
	function(ply, bind, pressed)
		if YRPIsChatEnabled("PlayerBindPress") then
			local bTeam = nil
			if bind == "messagemode" then
				bTeam = false
			elseif bind == "messagemode2" then
				bTeam = true
			else
				return
			end

			if YRPPanelAlive(yrpChat.window, "yrpChat.window 6") then
				yrpChat:openChatbox(bTeam)
			else
				if not YRPPanelAlive(yrpChat.window, "yrpChat.window 7") and YRPIsChatEnabled("PlayerBindPress2") then
					InitYRPChat()
				end

				if not YRPPanelAlive(yrpChat.window, "yrpChat.window 8") and YRPIsChatEnabled("PlayerBindPress3") then
					notification.AddLegacy("[YourRP] [yrp_overrideChatbind] ChatBox Window broken", NOTIFY_ERROR, 10)
				end
			end

			return true
		end
	end
)

hook.Add(
	"ChatText",
	"yrp_serverNotifications",
	function(index, name, text, typ)
		local lply = LocalPlayer()
		if lply:IsValid() and YRPIsChatEnabled("ChatText") then
			if typ == "none" and YRPPanelAlive(yrpChat.content, "yrpChat.window 9") and lply:HasAccess("chat2") then
				notification.AddLegacy(text, NOTIFY_GENERIC, 6)
			end
		else
			if typ == "none" then return true end
			if typ == "joinleave" then return true end
		end
	end
)

hook.Add(
	"HUDShouldDraw",
	"yrp_noMoreDefault",
	function(name)
		local lply = LocalPlayer()
		if lply:IsValid() and YRPIsChatEnabled("HUDShouldDraw") and name == "CHudChat" then return false end
	end
)

net.Receive(
	"yrpsendanim",
	function()
		local ply = net.ReadEntity()
		local slot = net.ReadInt(32)
		local activity = net.ReadInt(32)
		local loop = net.ReadBool()
		if ply:IsValid() and IsNotNilAndNotFalse(slot) and IsNotNilAndNotFalse(activity) and IsNotNilAndNotFalse(loop) then
			ply:AnimRestartGesture(slot, activity, loop)
		end
	end
)

net.Receive(
	"yrpstopanim",
	function()
		local ply = net.ReadEntity()
		local slot = net.ReadInt(32)
		if ply:IsValid() and IsNotNilAndNotFalse(slot) then
			ply:AnimResetGestureSlot(slot)
		end
	end
)

net.Receive(
	"nws_yrp_player_say",
	function(len)
		local pk = net.ReadTable()
		for i, v in pairs(pk) do
			if isstring(v) then
				local s, _ = string.find(v, "LID_", 1, true)
				if s then
					local s2, _ = string.find(v, ";", 1, true)
					if s2 then
						local lid = string.sub(v, s, s2 - 1)
						lid = string.Trim(lid)
						pk[i] = string.Replace(pk[i], lid, YRP.trans(lid))
						pk[i] = string.Replace(pk[i], ";", "")
					end
				end
			end
		end

		chat.AddText(unpack(pk))
		chat.PlaySound()
	end
)

hook.Add(
	"OnPlayerChat",
	"YRPHideCommands",
	function(ply, strText, bTeam, bDead)
		if string.StartWith(strText, "!") or string.StartWith(strText, "/") or string.StartWith(strText, "@") then
			local channel = string.Explode(" ", strText, false)
			channel = channel[1] or ""
			channel = string.Replace(channel, "!", "")
			channel = string.Replace(channel, "/", "")
			channel = string.lower(channel)
			local ischannel = false
			for i, v in pairs(GetGlobalYRPTable("yrp_chat_channels")) do
				if string.lower(v.string_name) == channel then
					ischannel = true
				end
			end

			if not ischannel then
				YRP.msg("note", "HIDE COMMANDS: " .. tostring(strText))
			end

			return true
		end
	end
)