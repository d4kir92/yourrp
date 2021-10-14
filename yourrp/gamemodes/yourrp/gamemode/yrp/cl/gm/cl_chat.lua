--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- #CHAT

yrpChat = yrpChat or {}

if pa(yrpChat.window) then
	-- Already chat created
else
	local yrp_chat_show = false

	local commands = {
		"/rpname [NAME] NEWNAME",
		"!rpname [NAME] NEWNAME",
		"/pm NAME MESSAGE",
		"!pm NAME MESSAGE",
		"/w NAME MESSAGE",
		"!w NAME MESSAGE",
		"/afk",
		"!afk",
		"/dnd",
		"!dnd",
		"/help",
		"!help",
		"/dropweapon",
		"!dropweapon",
		"/dropmoney AMOUNT",
		"!dropmoney AMOUNT"
	}

	local admincommands= {
		"/tag_ug",
		"!tag_ug",
		"/setmoney NAME AMOUNT",
		"!setmoney NAME AMOUNT",
		"/addxp NAME AMOUNT",
		"!addxp NAME AMOUNT",
		"/addlevel NAME AMOUNT",
		"!addlevel NAME AMOUNT",
		"/setlevel NAME AMOUNT",
		"!setlevel NAME AMOUNT",
		"/revive NAME",
		"!revive NAME",
		"/alert TEXT",
		"!alert TEXT",
		"/givelicense NAME LICENSENAME",
		"!givelicense NAME LICENSENAME"
	}

	local yrp_logo = Material("yrp/yrp_icon")

	local words = 0
	local _delay = 4
	local _delayText = 1
	local _fadeout = CurTime() + _delay
	local _fadeoutText = CurTime() + _delayText
	local chatclosedforkeybinds = true
	local _showChat = false
	local _showChatText = true
	local chatids = {}
	local oldchoices = {}
	local chatAlpha = 255
	local once = true

	local CHATMODE = "SAY"

	local BR = 10
	local H = 50

	function GetChatMode()
		return CHATMODE
	end

	function SetChatMode(mode)
		if type(mode) == "string" and pa(yrpChat) and pa(yrpChat.comboBox) then
			CHATMODE = string.upper(mode)
			yrpChat.comboBox:SetText(CHATMODE)
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
			if table.Count(ex) >= 4 then
				local isip = true
				for j, n in pairs(ex) do
					if isnumber(tonumber(n)) then
						if tonumber(n) > 255 then
							isip = false
							break
						end
					end
				end
				if isip then
					return true
				end
			end
		end

		return false
	end

	local function ChatBlacklisted(...)
		local tab = {...}
		local blacklist = GetGlobalTable("yrp_blacklist_chat", {})

		local str = ""
		for i, v in pairs(tab) do
			if isstring(v) then
				str = str .. v
			end
		end

		for i, black in pairs(blacklist) do
			if string.find(str, black.value) then
				return true
			end
		end

		return false
	end

	local function update_chat_choices()
		if pa(yrpChat.window) and yrpChat.comboBox != nil then
			yrpChat.comboBox:Clear()
			chatids = {}
			
			for i, v in pairs(GetGlobalTable("yrp_chat_channels")) do
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

	hook.Remove("Think", "yrp_think_chat_choices")
	hook.Add("Think", "yrp_think_chat_choices", function()
		if GetGlobalTable("yrp_chat_channels", {}) != oldchoices then
			oldchoices = GetGlobalTable("yrp_chat_channels", {})
			update_chat_choices()
		end
	end)

	hook.Remove("yrp_language_changed", "chat_language_changed")
	hook.Add("yrp_language_changed", "chat_language_changed", function()
		update_chat_choices()
	end)

	local function YRPIsChatOpen()
		return yrpChat._chatIsOpen
	end

	function ChatIsClosedForChat()
		return chatclosedforkeybinds or !GetGlobalBool("bool_yrp_chat", false)
	end

	counti = counti or 0
	counti = counti + 1

	local function YRPCheckChatVisible()
		if yrpChat.window != nil then
			if YRPIsChatOpen() then
				_fadeout = CurTime() + _delay
			end
			if _fadeoutText < _fadeout then
				_fadeoutText = _fadeout
			end
			if CurTime() > _fadeout and !yrpChat.writeField:HasFocus() and !yrpChat.comboBox:HasFocus() and !yrpChat.settings:HasFocus() then
				_showChat = false
			else
				_showChat = true
			end
			if CurTime() > _fadeoutText and !yrpChat.writeField:HasFocus() and !yrpChat.comboBox:HasFocus() and !yrpChat.settings:HasFocus() then
				_showChatText = false
				words = 0
			else
				_showChatText = true
			end
			if GetGlobalBool("bool_yrp_chat", false) == false then
				_showChat = false
			end
			if _showChat then
				chatAlpha = chatAlpha + 10
			else
				chatAlpha = chatAlpha - 10
			end
			if YRPScoreboard:IsVisible() or YRPScoreboard:IsVisible() then
				chatAlpha = 0
				yrpChat.window:SetVisible(false)
			else
				yrpChat.window:SetVisible(true)
				
				chatAlpha = math.Clamp(chatAlpha, 0, 255)
				
				--yrpChat.window:SetAlpha(chatAlpha)
				yrpChat.richText:SetVerticalScrollbarEnabled(_showChat)
				yrpChat.window.logo:SetAlpha(chatAlpha)
				yrpChat.writeField:SetAlpha(chatAlpha)
				yrpChat.comboBox:SetAlpha(chatAlpha)
				yrpChat.settings:SetAlpha(chatAlpha)

				yrpChat.richText:SetVisible(_showChatText)
			end
		end
	end

	function ChatAlpha()
		return chatAlpha
	end

	local function IsChatVisible()
		return _showChat
	end

	local function niceCommand(com)
		if com == "say" then
			return YRP.lang_string("LID_say")
		elseif com == "yell" then
			return YRP.lang_string("LID_yell")
		elseif com == "advert" then
			return YRP.lang_string("LID_advert")
		elseif com == "admin" then
			return YRP.lang_string("LID_admin")
		elseif com == "faction" then
			return YRP.lang_string("LID_faction")
		elseif com == "group" then
			return YRP.lang_string("LID_group")
		elseif com == "role" then
			return YRP.lang_string("LID_role")
		elseif com == "service" then
			return YRP.lang_string("LID_service")
		end
		return com
	end

	local function InitYRPChat()
		local lply = LocalPlayer()
		lply.yrp_timestamp = lply.yrp_timestamp or false
		if yrpChat.window == nil then
			yrpChat.window = createD("DFrame", nil, 100, 100, 100, 100)
			yrpChat.window:SetTitle("")
			yrpChat.window:ShowCloseButton(false)
			yrpChat.window:SetDraggable(false)

			yrpChat.richText = createD("RichText", yrpChat.window, 1, 1, 1, 1)
			yrpChat.richText:GotoTextEnd()
			function yrpChat.richText:Paint(pw, ph)
				if IsChatVisible() then
					draw.RoundedBox(0, 0, 0, pw, ph, LocalPlayer():InterfaceValue("Chat", "BG"))
				end
			end

			yrpChat.comboBox = createD("DComboBox", yrpChat.window, 1, 1, 1, 1)
			update_chat_choices()

			function yrpChat.comboBox:Paint(pw, ph)
				surface.SetDrawColor(Color(0, 0, 0, 0))
				surface.DrawRect(0, 0, pw, ph)
				self:SetTextColor(Color(255, 255, 255))
			end

			yrpChat.window.logo = createD("DHTML", yrpChat.window, YRP.ctr(H), YRP.ctr(H), 0, 0)

			function yrpChat.window:Paint(pw, ph)
				if IsChatVisible() then
					draw.RoundedBox(0, 0, 0, pw, ph, LocalPlayer():InterfaceValue("Chat", "FG"))

					if self.logo then
						if self.logo.svlogo != GetGlobalString("text_server_logo", "") then
							self.logo.svlogo = GetGlobalString("text_server_logo", "")
		
							if !strEmpty(GetGlobalString("text_server_logo", "")) then
								self.logo:SetHTML(GetHTMLImage(GetGlobalString("text_server_logo", ""), YRP.ctr(H), YRP.ctr(H)))
								self.logo:Show()
							else
								self.logo:Hide()
							end
						end
			
						if !self.logo:IsVisible() then
							surface.SetMaterial(yrp_logo)
							surface.SetDrawColor(255, 255, 255, 255)
							surface.DrawTexturedRect(YRP.ctr(BR), YRP.ctr(BR), YRP.ctr(H), YRP.ctr(H))
						end
					end

					local name = GetGlobalString("text_server_name", "")
					if strEmpty(name) then
						name = YRPGetHostName()
					end
					draw.SimpleText(name, "Y_16_500", pw / 2, YRP.ctr(BR + H / 2), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

					draw.SimpleText(player.GetCount() .. "/" .. game.MaxPlayers(), "Y_16_500", pw - YRP.ctr(BR), YRP.ctr(BR + H / 2), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

					local x, y = yrpChat.window:GetPos()
					local w, h = yrpChat.window:GetSize()

					local px = lply:HudValue("CH", "POSI_X")
					local py = lply:HudValue("CH", "POSI_Y")
					local sw = lply:HudValue("CH", "SIZE_W")
					local sh = lply:HudValue("CH", "SIZE_H")
					--YRP.msg("deb", "InitYRPChat x " .. x .. ", y " .. y .. ", w " .. w .. ", h " .. h .. ", px " .. px .. ", py " .. py .. ", sw " .. sw ..", sh " .. sh)
					if px != x or py != y or sw != w or sh != h then
						yrpChat.window:SetPos(px, py)
						yrpChat.window:SetSize(sw, sh)

						yrpChat.window.logo:SetPos(YRP.ctr(BR), YRP.ctr(BR))
						yrpChat.window.logo:SetSize(YRP.ctr(H), YRP.ctr(H))
				
						yrpChat.comboBox:SetPos(YRP.ctr(BR), sh - YRP.ctr(H + BR))
						yrpChat.comboBox:SetSize(YRP.ctr(120), YRP.ctr(H))

						yrpChat.writeField:SetPos(YRP.ctr(BR + 120), sh - YRP.ctr(H + BR))
						yrpChat.writeField:SetSize(sw - YRP.ctr(2 * BR + 120 + H + BR), YRP.ctr(H))

						yrpChat.richText:SetPos(YRP.ctr(BR), YRP.ctr(BR + H + BR))
						yrpChat.richText:SetSize(sw - YRP.ctr(2 * BR), sh - YRP.ctr(BR + H + BR + BR + H + BR))

						yrpChat.settings:SetPos(sw - YRP.ctr(BR + H), sh - YRP.ctr(H + BR))
						yrpChat.settings:SetSize(YRP.ctr(H), YRP.ctr(H))

						--yrpChat.tabs:SetPos(YRP.ctr(BR), YRP.ctr(BR))
						--yrpChat.tabs:SetSize(sw - YRP.ctr(2 * BR), YRP.ctr(H))
					end
					local _com = yrpChat.writeField:GetText()
					_com = string.upper(_com)
					local test = string.sub(_com, 3)
					if (string.StartWith(_com, "!S") or string.StartWith(_com, "/S")) and test != nil and chatids[test] != nil then
						yrpChat.writeField:SetText("")
						yrpChat.comboBox:ChooseOption(test)
					end
				else
					self:MoveToBack()
				end
			end

			function yrpChat.comboBox:OnSelect(index, value, data)
				SetChatMode(value)
				net.Start("set_chat_mode")
					net.WriteString(string.upper(value))
				net.SendToServer()
			end

			yrpChat.writeField = createD("DTextEntry", yrpChat.window, 1, 1, 1, 1)
			yrpChat.writeField:SetHistoryEnabled(true)
			function yrpChat.writeField:GetAutoComplete( text )
				local suggestions = {}
			
				for _, ply in ipairs( player.GetAll() ) do
					if string.StartWith(ply:RPName(), text) then
						table.insert(suggestions, ply:Nick())
					end
				end

				for _, cmd in pairs(commands) do
					if string.StartWith(cmd, text) then
						table.insert(suggestions, cmd)
					end
				end

				if LocalPlayer():HasAccess() then
					for _, cmd in pairs(admincommands) do
						if string.StartWith(cmd, text) then
							table.insert(suggestions, cmd)
						end
					end
				end

				return suggestions
			end

			function yrpChat.writeField:PerformLayout()
				local ts = LocalPlayer():HudValue("CH", "TS")
				if ts > 6 then
					if self.SetUnderlineFont != nil then
						self:SetUnderlineFont("Y_" .. ts .. "_500")
					end
					self:SetFontInternal("Y_" .. ts .. "_500")
				end

				self:SetTextColor(Color(40, 40, 40))
				self:SetFGColor(Color(0, 0, 0, 0))
				self:SetBGColor(Color(0, 0, 0, 0))
			end

			function yrpChat.writeField:Paint(pw, ph)
				surface.SetDrawColor(LocalPlayer():InterfaceValue("Chat", "BG"))
				surface.DrawRect(0, 0, yrpChat.writeField:GetWide(), yrpChat.writeField:GetTall())
				yrpChat.writeField:DrawTextEntryText(Color(255, 255, 255), Color(0, 0, 0, 0), Color(255, 255, 255))
				if !yrpChat.writeField:HasFocus() and !yrpChat.comboBox:HasFocus() and !yrpChat.comboBox:IsHovered() then
					timer.Simple(0.1, function()
						if pa(yrpChat.window) and !yrpChat.writeField:HasFocus() and !yrpChat.comboBox:HasFocus() and !yrpChat.comboBox:IsHovered() then
							--yrpChat.closeChatbox("NOT FOCUS ANYMORE")
						end
					end)
				end
			end

			function yrpChat.richText:PerformLayout()
				local ts = LocalPlayer().CH_TS or LocalPlayer():HudValue("CH", "TS")
				if ts != nil and ts > 6 then
					if self.SetUnderlineFont != nil then
						self:SetUnderlineFont("Y_" .. ts .. "_500")
					end
					self:SetFontInternal("Y_" .. ts .. "_500")
				end

				self:SetFGColor(Color(255, 255, 255))
				self:SetBGColor(Color(0, 0, 0, 0))
			end

			yrpChat.settings = createD("YButton", yrpChat.window, 10, 10, 10, 10)
			yrpChat.settings:SetText("")
			function yrpChat.settings:Paint(pw, ph)
				local w = pw - pw % 4
				local h = ph - ph % 4

				if YRP.GetDesignIcon("64_cog") ~= nil then
					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetMaterial(YRP.GetDesignIcon("64_cog"))
					surface.DrawTexturedRect((pw - w) / 2, (ph - h) / 2, w, h)
				end
			end
			function yrpChat.settings:DoClick()
				local win = createD("YFrame", nil, YRP.ctr(800), YRP.ctr(800), 0, 0)
				win:MakePopup()
				win:Center()
				win:SetTitle("LID_settings")

				local tila = createD("YLabel", win:GetContent(), YRP.ctr(350), YRP.ctr(50), YRP.ctr(50), YRP.ctr(0))
				tila:SetText("Timestamp")
				local ticb = createD("DCheckBox", win:GetContent(), YRP.ctr(50), YRP.ctr(50), YRP.ctr(0), YRP.ctr(0))
				ticb:SetChecked(lply.yrp_timestamp)
				function ticb:OnChange()
					lply.yrp_timestamp = !lply.yrp_timestamp
				end

				local tspn = createD("YLabel", win:GetContent(), YRP.ctr(400), YRP.ctr(50), YRP.ctr(0), YRP.ctr(100))
				tspn:SetText("LID_textsize")
				local tsnw = createD("DNumberWang", win:GetContent(), YRP.ctr(400), YRP.ctr(50), YRP.ctr(0), YRP.ctr(100 + 50))
				tsnw:SetValue(LocalPlayer().CH_TS or LocalPlayer():HudValue("CH", "TS"))
				tsnw:SetMin(10)
				tsnw:SetMax(64)
				function tsnw:OnValueChanged(val)
					LocalPlayer().CH_TS = tsnw:GetValue()
				end
			end

			yrpChat.writeField.OnKeyCode = function(self, code)
				if code == KEY_ESCAPE then
					yrpChat.closeChatbox("PRESSED ESCAPE")
					gui.HideGameUI()
				elseif code == KEY_ENTER then
					if !strEmpty(string.Trim(self:GetText())) then
						local tex = self:GetText()
						local text = ""
						for i = 0, 10 do
							timer.Simple(2 * i, function()
								if !strEmpty(string.Trim(tex)) then
									text = string.sub(tex, 1, 120)
									tex = string.sub(tex, 121)

									yrpChat.writeField:AddHistory( text )

									if string.StartWith(text, "!") or string.StartWith(text, "/") or string.StartWith(text, "@") then
										LocalPlayer():ConCommand("say \"".. text .. "\"")
									else
										LocalPlayer():ConCommand("say \"!" .. CHATMODE .. " " .. text .. "\"")
									end
								end
							end)
						end
					end
					yrpChat.closeChatbox("PRESSED ENTER")
				end
			end
			
			function yrpChat:openChatbox(bteam)
				if !pa(yrpChat.window) then
					notification.AddLegacy("[YourRP] [openChatbox] ChatBox Window broken", NOTIFY_ERROR, 10)
					yrp_chat_show = false
					return
				end
				if !yrp_chat_show then
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

			function yrpChat.closeChatbox(reason)
				if !pa(yrpChat.window) then
					notification.AddLegacy("[YourRP] [closeChatbox] ChatBox Window broken", NOTIFY_ERROR, 10)
					yrp_chat_show = false
					return
				end
				if yrp_chat_show then
					yrp_chat_show = false
					
					gui.EnableScreenClicker(false)
					
					yrpChat._chatIsOpen = false
					gamemode.Call("FinishChat")

					yrpChat.writeField:SetText("")
					gamemode.Call("ChatTextChanged", "")

					yrpChat.window:SetMouseInputEnabled(false)
					yrpChat.window:SetKeyboardInputEnabled(false)

					timer.Simple(0.1, function()
						chatclosedforkeybinds = true
					end)
				end
			end

			function YRPChatChangeTextColor(str, cstr, color)
				if string.StartWith(str, cstr .. ">") then
					str = string.Replace(str, cstr .. ">", "")
					yrpChat.richText:InsertColorChange(color.r, color.g, color.b, color.a)
					yrpChat.richText:AppendText(str)
				end
			end

			if oldAddText == nil then
				oldAddText = chat.AddText
			end
			function chat.AddText(...)
				if ContainsIp(...) or ChatBlacklisted(...) then return end
				local args = { ... }
				yrpChat.richText:AppendText("\n")

				_delay = 3
				if lply.yrp_timestamp and GetGlobalBool("bool_yrp_chat", false) then
					local clock = {}
					clock.sec = os.date("%S")
					clock.min = os.date("%M")
					clock.hours = os.date("%I")
					yrpChat.richText:InsertColorChange(200, 200, 255, 255)
					yrpChat.richText:AppendText(clock.hours .. ":" .. clock.min .. ":" .. clock.sec .. " ")
					yrpChat.richText:InsertColorChange(255, 255, 255, 255)
				end

				-- REMOVE CHAT COMMANDS
				for i, obj in pairs(args) do
					local t = string.lower(type(obj))
					if t == "string" then
						if (string.StartWith(obj, ": !") or string.StartWith(obj, ": /")) then
							YRP.msg("note", "HIDE COMMANDS: " .. tostring(obj))
							--return false
						end
					end
				end

				for i, obj in pairs(args) do
					local t = string.lower(type(obj))
					if t == "table" then
						if isnumber(tonumber(obj.r)) and isnumber(tonumber(obj.g)) and isnumber(tonumber(obj.b)) then
							yrpChat.richText:InsertColorChange(obj.r, obj.g, obj.b, 255)
						end
					elseif t == "string" then
						_delay = _delay + string.len(obj)
						local _text = string.Explode(" ", obj)
						for k, str in pairs(_text) do
							if !strEmpty(str) then
								words = words + 1
							end
							if k > 1 then
								yrpChat.richText:AppendText(" ")
							end

							local _l = {}
							_l.l_www = false
							_l.l_secure = false

							_l.l_start = string.find(str, "https://", 1)
							if _l.l_start != nil then
								_l.l_secure = true
							else
								_l.l_secure = false
								_l.l_start = string.find(str, "http://", 1)
								if _l.l_start == nil then
									_l.l_www = true
									_l.l_start = string.find(str, "www.", 1)
								else
									_l.l_start = string.find(str, ".")
									if _l.l_start != nil then
										_l.l_point = true
									end
								end
							end
							if _l.l_start != nil then

								_l.l_end = #str

								local _link = string.sub(str, _l.l_start, _l.l_end)
								if _l.l_www then
									_link = "https://" .. _link
								end
								if !strEmpty(_link) then
									if _l.l_secure then
										yrpChat.richText:InsertColorChange(200, 200, 255, 255)
									else
										yrpChat.richText:InsertColorChange(255, 100, 100, 255)
									end
									yrpChat.richText:InsertClickableTextStart(_link)	-- Make incoming text fire the "OpenWiki" value when clicked
									yrpChat.richText:AppendText(_link)
									yrpChat.richText:InsertClickableTextEnd()	-- End clickable text here
									yrpChat.richText:InsertColorChange(255, 255, 255, 255)

									function yrpChat.richText:ActionSignal(signalName, signalValue)
										if (signalName == "TextClicked") then
											if (signalValue == _link) then
												gui.OpenURL(_link)
											end
										end
									end
								end
							else
								if string.find(str, "<") then
									local nstr = string.Explode("<", str)
									for i, v in pairs(nstr) do
										YRPChatChangeTextColor(v, "red", 		Color(255, 0, 0, 255))
										YRPChatChangeTextColor(v, "green", 		Color(0, 255, 0, 255))
										YRPChatChangeTextColor(v, "blue", 		Color(0, 0, 255, 255))
										YRPChatChangeTextColor(v, "yellow", 	Color(255, 255, 0, 255))
										YRPChatChangeTextColor(v, "black", 		Color(0, 0, 0, 255))
										YRPChatChangeTextColor(v, "white", 		Color(255, 255, 255, 255))

										YRPChatChangeTextColor(v, "/red", 		Color(255, 255, 255, 255))
										YRPChatChangeTextColor(v, "/green", 	Color(255, 255, 255, 255))
										YRPChatChangeTextColor(v, "/blue", 		Color(255, 255, 255, 255))
										YRPChatChangeTextColor(v, "/yellow", 	Color(255, 255, 255, 255))
										YRPChatChangeTextColor(v, "/black", 	Color(255, 255, 255, 255))
										YRPChatChangeTextColor(v, "/white", 	Color(255, 255, 255, 255))
									end
								else
									yrpChat.richText:AppendText(str)
								end
							end
						end
					elseif t == "entity" and obj:IsPlayer() then
						local col = GAMEMODE:GetTeamColor(obj)
						if isnumber(tonumber(col.r)) and isnumber(tonumber(col.g)) and isnumber(tonumber(col.b)) then
							yrpChat.richText:InsertColorChange(col.r, col.g, col.b, 255)
							yrpChat.richText:AppendText(obj:Nick())
						end
					elseif t == "number" then
						yrpChat.richText:AppendText(obj)
						words = words + 1
					elseif t == "boolean" then
						YRP.msg("note", "chat.addtext (boolean): " .. tostring(obj))
					elseif t == "entity" and IsValid(obj) then
						YRP.msg("error", "chat.addtext (entity): " .. tostring(obj))
					elseif t == "player" then
						-- invalid players
						local col = GAMEMODE:GetTeamColor(obj)
						if isnumber(tonumber(col.r)) and isnumber(tonumber(col.g)) and isnumber(tonumber(col.b)) then
							yrpChat.richText:InsertColorChange(col.r, col.g, col.b, 255)
							yrpChat.richText:AppendText(obj:RPName())
						end
					elseif t == "entity" then
						-- invalid entities
						if obj.Nick then
							yrpChat.richText:AppendText(obj:Nick())
						elseif obj.GetName then
							yrpChat.richText:AppendText(obj:GetName())
						end
					elseif t == "panel" then
						--
					else
						YRP.msg("error", "chat.addtext TYPE: " .. t .. " obj: " .. tostring(obj))
					end
				end

				_delay = _delay / 10
				_delay = math.Clamp(_delay, 2, 30)

				_fadeoutText = CurTime() + math.Clamp(words * _delayText, 4, 60)

				yrpChat.richText:GotoTextEnd()
				oldAddText(...)
			end

			yrpChat.richText:GotoTextEnd()
			yrpChat.richText:GotoTextEnd()

			function YRPChatThink()
				if yrpChat.window != nil then
					YRPCheckChatVisible()
				end

				timer.Simple(0.01, YRPChatThink)
			end
			YRPChatThink()
		end
	end

	hook.Remove("PlayerBindPress", "yrp_overrideChatbind")
	hook.Add("PlayerBindPress", "yrp_overrideChatbind", function(ply, bind, pressed)
		if GetGlobalBool("bool_yrp_chat", false) then
			local bTeam = nil
			if bind == "messagemode" then
				bTeam = false
			elseif bind == "messagemode2" then
				bTeam = true
			else
				return
			end

			if pa(yrpChat.window) then
				yrpChat:openChatbox(bTeam)
			else
				notification.AddLegacy("[YourRP] [yrp_overrideChatbind] ChatBox Window broken", NOTIFY_ERROR, 10)
			end
			return true
		end
	end)

	hook.Remove("ChatText", "yrp_serverNotifications")
	hook.Add("ChatText", "yrp_serverNotifications", function(index, name, text, type)
		local lply = LocalPlayer()
		if lply:IsValid() and GetGlobalBool("bool_yrp_chat", false) then
			if type == "none" then
				if pa(yrpChat.richText) and lply:HasAccess() then
					notification.AddLegacy(text, NOTIFY_GENERIC, 6)
				end
			end
		else
			if type == "none" then
				return true
			end
			if type == "joinleave" then
				return true
			end
		end
	end)

	hook.Remove("HUDShouldDraw", "yrp_noMoreDefault")
	hook.Add("HUDShouldDraw", "yrp_noMoreDefault", function(name)
		local lply = LocalPlayer()
		if lply:IsValid() and GetGlobalBool("bool_yrp_chat", false) then
			if name == "CHudChat" then
				return false
			end
		end
	end)

	net.Receive("yrpsendanim", function()
		local ply = net.ReadEntity()
		local slot = net.ReadInt(32)
		local activity = net.ReadInt(32)
		local loop = net.ReadBool()

		if ply:IsValid() and wk(slot) and wk(activity) and wk(loop) then
			ply:AnimRestartGesture(slot, activity, loop)
		end
	end)

	net.Receive("yrpstopanim", function()
		local ply = net.ReadEntity()
		local slot = net.ReadInt(32)

		if ply:IsValid() and wk(slot) then
			ply:AnimResetGestureSlot(slot)
		end
	end)

	net.Receive("yrp_player_say", function(len)
		local sender = net.ReadEntity()
		local pk = net.ReadTable()

		for i, v in pairs(pk) do
			if isstring(v) then
				local s, e = string.find(v, "LID_")
				if s then
					local s2, e2 = string.find(v, ";")

					local lid = string.sub(v, s, s2 - 1)
					lid = string.Trim(lid)

					pk[i] = string.Replace(pk[i], lid, YRP.lang_string(lid))
					pk[i] = string.Replace(pk[i], ";", "")
				end
			end
		end

		if GetGlobalBool("bool_yrp_chat", false) then
			chat.AddText(unpack(pk))
		else
			chat.AddText(unpack(pk))
		end
		chat.PlaySound()
	end)



	net.Receive("yrp_ready_received", function(len)
		InitYRPChat()
		timer.Simple(2, function()
			_fadeout = CurTime() + 0.1
		end)
	end)
end

hook.Remove( "OnPlayerChat", "YRPHideCommands" )
hook.Add( "OnPlayerChat", "YRPHideCommands", function( ply, strText, bTeam, bDead )
	if string.StartWith(strText, "!") or string.StartWith(strText, "/") or string.StartWith(strText, "@") then
		if ply == LocalPlayer() then
			local channel = string.Explode( " ", strText, false )
			channel = channel[1] or ""
			channel = string.Replace( channel, "!", "")
			channel = string.Replace( channel, "/", "")
			channel = string.lower( channel )

			local ischannel = false
			for i, v in pairs( GetGlobalTable("yrp_chat_channels") ) do
				if string.lower( v.string_name ) == channel then
					ischannel = true
				end
			end

			if !ischannel then
				chat.AddText( Color(255, 255, 0), "Chat Message suppressed: " .. strText .. "" )
				YRP.msg("note", "HIDE COMMANDS: " .. tostring(strText))
			end
			return true
		end
	end
end )