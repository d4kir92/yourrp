--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- #CHAT

function ContainsIp(...)
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

function ChatBlacklisted(...)
	local tab = {...}
	local blacklist = GetGlobalDTable("yrp_blacklist_chat", {})

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

local yrpChat = {}

local _delay = 4
local _fadeout = CurTime() + _delay
local _chatIsOpen = false
local chatclosedforkeybinds = true
_showChat = true

function update_chat_choices()
	if yrpChat.comboBox != nil then
		yrpChat.comboBox:Clear()
		yrpChat.comboBox:AddChoice(YRP.lang_string("LID_general") .. " /GENERAL", "general", false)
		yrpChat.comboBox:AddChoice(YRP.lang_string("LID_ooc") .. " /OOC", "ooc", false)
		yrpChat.comboBox:AddChoice(YRP.lang_string("LID_looc") .. " /LOOC", "looc", false)
		yrpChat.comboBox:AddChoice(YRP.lang_string("LID_say") .. " /SAY", "say", true)
		yrpChat.comboBox:AddChoice(YRP.lang_string("LID_advert") .. " /ADVERT", "advert", false)
		yrpChat.comboBox:AddChoice(YRP.lang_string("LID_yell") .. " /YELL", "yell", false)
		yrpChat.comboBox:AddChoice(YRP.lang_string("LID_me") .. " /ME", "me", false)
		yrpChat.comboBox:AddChoice(YRP.lang_string("LID_admin") .. " /ADMIN", "admin", false)
		yrpChat.comboBox:AddChoice(YRP.lang_string("LID_group") .. " /GROUP", "group", false)
		yrpChat.comboBox:AddChoice(YRP.lang_string("LID_role") .. " /ROLE", "role", false)
		yrpChat.comboBox:AddChoice(YRP.lang_string("LID_service") .. " /SERVICE", "service", false)
		yrpChat.comboBox:AddChoice(YRP.lang_string("LID_faction") .. " /FACTION", "faction", false)
	end
end

hook.Add("yrp_language_changed", "chat_language_changed", function()
	update_chat_choices()
end)

function IsChatOpen()
	return _chatIsOpen
end

function ChatIsClosedForChat()
	return chatclosedforkeybinds
end

local chatAlpha = 0
function checkChatVisible()
	if yrpChat.window != nil then
		if _chatIsOpen then
			_fadeout = CurTime() + _delay
		end
		if CurTime() > _fadeout and !yrpChat.writeField:HasFocus() then
			_showChat = false
		else
			_showChat = true
		end
		lply = LocalPlayer()
		if GetGlobalDBool("bool_yrp_chat", false) == false then
			_showChat = false
		end
		if _showChat then
			chatAlpha = chatAlpha + 0.1
		else
			chatAlpha = chatAlpha - 0.01
		end
		if chatAlpha < 0 then
			chatAlpha = 0
			yrpChat.richText:SetVisible(_showChat)
			yrpChat.writeField:SetVisible(_showChat)
			yrpChat.comboBox:SetVisible(_showChat)
		elseif chatAlpha > 1 then
			chatAlpha = 1
			yrpChat.richText:SetVisible(_showChat)
			yrpChat.writeField:SetVisible(_showChat)
			yrpChat.comboBox:SetVisible(_showChat)
		end
	end
end

function ChatAlpha()
	return chatAlpha
end

function IsChatVisible()
	return _showChat
end

function isFullyCommand(com, iscom, iscom2)
	if com == "/" .. iscom .. " " or com == "!" .. iscom .. " " or com == "/" .. string.lower(iscom2) .. " " or com == "!" .. string.lower(iscom2) .. " " then
		return true
	end
	return false
end

function niceCommand(com)
	if com == "say" then
		return YRP.lang_string("LID_say")
	elseif com == "yell" then
		return YRP.lang_string("LID_yell")
	elseif com == "advert" then
		return GetGlobalDString("text_chat_advert", YRP.lang_string("LID_advert"))
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

function InitYRPChat()
	if yrpChat.window == nil then
		yrpChat.window = createD("DFrame", nil, 100, 100, 100, 100)
		yrpChat.window:SetTitle("")
		yrpChat.window:ShowCloseButton(false)
		yrpChat.window:SetDraggable(false)

		yrpChat.richText = createD("RichText", yrpChat.window, 1, 1, 1, 1)
		yrpChat.richText:GotoTextEnd()

		yrpChat.comboBox = createD("DComboBox", yrpChat.window, 1, 1, 1, 1)
		update_chat_choices()

		function yrpChat.window:Paint(pw, ph)
			local lply = LocalPlayer()
			checkChatVisible()
			if _showChat then
				local x, y = yrpChat.window:GetPos()
				local w, h = yrpChat.window:GetSize()

				local px = lply:HudValue("CH", "POSI_X")
				local py = lply:HudValue("CH", "POSI_Y")
				local sw = lply:HudValue("CH", "SIZE_W")
				local sh = lply:HudValue("CH", "SIZE_H")
				--printGM("deb", "InitYRPChat x " .. x .. ", y " .. y .. ", w " .. w .. ", h " .. h .. ", px " .. px .. ", py " .. py .. ", sw " .. sw ..", sh " .. sh)
				if px != x or py != y or sw != w or sh != h then
					yrpChat.window:SetPos(px, py)
					yrpChat.window:SetSize(sw, sh)

					yrpChat.comboBox:SetPos(YRP.ctr(10), sh - YRP.ctr(40 + 10))
					yrpChat.comboBox:SetSize(YRP.ctr(140), YRP.ctr(40))

					yrpChat.writeField:SetPos(YRP.ctr(10 + 140), sh - YRP.ctr(40 + 10))
					yrpChat.writeField:SetSize(sw - YRP.ctr(2 * 10 + 140), YRP.ctr(40))

					yrpChat.richText:SetPos(YRP.ctr(10), YRP.ctr(10))
					yrpChat.richText:SetSize(sw - YRP.ctr(2 * 10), sh - YRP.ctr(2 * 10 + 40 + 10))
				end
				local _com = yrpChat.writeField:GetText()
				if isFullyCommand(_com, "sgeneral", YRP.lang_string("LID_general")) then
					yrpChat.writeField:SetText("")
					yrpChat.comboBox:ChooseOption(YRP.lang_string("LID_general"), 1)
				elseif isFullyCommand(_com, "sooc", YRP.lang_string("LID_ooc")) then
					yrpChat.writeField:SetText("")
					yrpChat.comboBox:ChooseOption(YRP.lang_string("LID_ooc"), 2)
				elseif isFullyCommand(_com, "slooc", YRP.lang_string("LID_looc")) then
					yrpChat.writeField:SetText("")
					yrpChat.comboBox:ChooseOption(YRP.lang_string("LID_looc"), 3)
				elseif isFullyCommand(_com, "ssay", YRP.lang_string("LID_say")) then
					yrpChat.writeField:SetText("")
					yrpChat.comboBox:ChooseOption(YRP.lang_string("LID_say"), 4)
				elseif isFullyCommand(_com, "sme", YRP.lang_string("LID_me")) then
					yrpChat.writeField:SetText("")
					yrpChat.comboBox:ChooseOption(YRP.lang_string("LID_me"), 7)
				elseif isFullyCommand(_com, "syell", YRP.lang_string("LID_yell")) then
					yrpChat.writeField:SetText("")
					yrpChat.comboBox:ChooseOption(YRP.lang_string("LID_yell"), 6)
				elseif isFullyCommand(_com, "sadvert", YRP.lang_string("LID_advert")) then
					yrpChat.writeField:SetText("")
					yrpChat.comboBox:ChooseOption(YRP.lang_string("LID_advert"), 5)
				elseif isFullyCommand(_com, "sadmin", YRP.lang_string("LID_admin")) then
					yrpChat.writeField:SetText("")
					yrpChat.comboBox:ChooseOption(YRP.lang_string("LID_admin"), 8)
				elseif isFullyCommand(_com, "sgroup", YRP.lang_string("LID_group")) then
					yrpChat.writeField:SetText("")
					yrpChat.comboBox:ChooseOption(YRP.lang_string("LID_group"), 9)
				elseif isFullyCommand(_com, "srole", YRP.lang_string("LID_role")) then
					yrpChat.writeField:SetText("")
					yrpChat.comboBox:ChooseOption(YRP.lang_string("LID_role"), 10)
				elseif isFullyCommand(_com, "sservice", YRP.lang_string("LID_service")) then
					yrpChat.writeField:SetText("")
					yrpChat.comboBox:ChooseOption(YRP.lang_string("LID_service"), 11)
				elseif isFullyCommand(_com, "sfaction", YRP.lang_string("LID_faction")) then
					yrpChat.writeField:SetText("")
					yrpChat.comboBox:ChooseOption(YRP.lang_string("LID_faction"), 12)
				end
			end
		end

		function yrpChat.comboBox:OnSelect(index, value, data)
			net.Start("set_chat_mode")
				net.WriteString(string.lower(data))
			net.SendToServer()
		end

		yrpChat.writeField = createVGUI("DTextEntry", yrpChat.window, 1, 1, 1, 1)

		function yrpChat.richText:PerformLayout()
			local ts = LocalPlayer():HudValue("CH", "TS")
			if ts > 0 then
				if self.SetUnderlineFont != nil then
					self:SetUnderlineFont("Y_" .. ts .. "_700")
				end
				self:SetFontInternal("Y_" .. ts .. "_700")
			end
		end

		yrpChat.writeField.OnKeyCodeTyped = function(self, code)
			if code == KEY_ESCAPE then
				yrpChat.closeChatbox()
				gui.HideGameUI()
			elseif code == KEY_ENTER then
				if !strEmpty(string.Trim(self:GetText())) then
					LocalPlayer():ConCommand("say \"" .. self:GetText() .. "\"")
				end
				yrpChat.closeChatbox()
			end
		end
		function yrpChat:openChatbox(bteam)
			yrpChat.window:MakePopup()
			yrpChat.writeField:RequestFocus()

			_chatIsOpen = true
			gamemode.Call("StartChat")

			yrpChat.richText:SetVisible(true)
			yrpChat.writeField:SetVisible(true)
			yrpChat.comboBox:SetVisible(true)

			chatclosedforkeybinds = false
		end

		function yrpChat.closeChatbox()

			yrpChat.window:SetMouseInputEnabled(false)
			yrpChat.window:SetKeyboardInputEnabled(false)
			gui.EnableScreenClicker(false)

			_chatIsOpen = false
			gamemode.Call("FinishChat")

			yrpChat.writeField:SetText("")
			gamemode.Call("ChatTextChanged", "")

			timer.Simple(0.1, function()
				chatclosedforkeybinds = true
			end)
		end

		local oldAddText = chat.AddText
		function chat.AddText(...)
			if ContainsIp(...) or ChatBlacklisted(...) then return end
			local yrp = false
			local args = { ... }
			yrpChat.richText:AppendText("\n")
			_delay = 3
			for i, obj in pairs(args) do
				local t = string.lower(type(obj))
				if t == "boolean" and i == 1 then
					yrp = true
				elseif t == "table" then
					if isnumber(tonumber(obj.r)) and isnumber(tonumber(obj.g)) and isnumber(tonumber(obj.b)) then
						yrpChat.richText:InsertColorChange(obj.r, obj.g, obj.b, 255)
					end
				elseif t == "string" then
					_delay = _delay + string.len(obj)
					local _text = string.Explode(" ", obj)
					for k, str in pairs(_text) do
						if k > 1 then
							yrpChat.richText:AppendText(" ")
						end

						local _l = {}
						_l.l_start = string.find(str, "https://", 1)
						if _l.l_start != nil then
							_l.l_secure = true
						else
							_l.l_secure = false
							_l.l_start = string.find(str, "http://", 1)
							if _l.l_start == nil then
								_l.l_www = true
								_l.l_start = string.find(str, "www.", 1)
							end
						end

						if _l.l_start != nil then

							_l.l_end = #str

							local _link = string.sub(str, _l.l_start, _l.l_end)
							if _l.l_www then
								_link = "https://" .. _link
							end
							if !strEmpty(_link) and yrp then
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
							yrpChat.richText:AppendText(str)
						end
					end
				elseif t == "entity" and obj:IsPlayer() then
					local col = GAMEMODE:GetTeamColor(obj)
					if isnumber(tonumber(obj.r)) and isnumber(tonumber(obj.g)) and isnumber(tonumber(obj.b)) then
						yrpChat.richText:InsertColorChange(col.r, col.g, col.b, 255)
						yrpChat.richText:AppendText(obj:Nick())
					end
				elseif t == "player" and obj:IsPlayer() then
					local col = GAMEMODE:GetTeamColor(obj)
					if isnumber(tonumber(obj.r)) and isnumber(tonumber(obj.g)) and isnumber(tonumber(obj.b)) then
						yrpChat.richText:InsertColorChange(col.r, col.g, col.b, 255)
						yrpChat.richText:AppendText(obj:Nick())
					end
				elseif t == "number" then
					yrpChat.richText:AppendText(obj)
				else
					YRP.msg("error", "TYPE: " .. t .. " obj: " .. tostring(obj))
				end
			end

			_delay = _delay / 10
			_delay = math.Clamp(_delay, 2, 30)
			_fadeout = CurTime() + _delay

			yrpChat.richText:GotoTextEnd()
			oldAddText (...)
		end

		LocalPlayer():ConCommand("say \"" .. "!help" .. "\"")

		yrpChat.richText:GotoTextEnd()
		yrpChat.richText:GotoTextEnd()

		timer.Simple(4, function()
			yrpChat.richText:GotoTextEnd()
		end)
	else
		--[[timer.Simple(1, function()
			printGM("error", "Chat creation failed! " .. tostring(yrpChat) .. " " .. tostring(yrpChat.window) .. "." )
			InitYRPChat()
		end)]]
	end
end

timer.Create("yrp_init_chat", 1, 0, function()
	local lply = LocalPlayer()
	if lply:IsValid() and lply:GetDBool("finishedloading", false) and LocalPlayer():GetDString("string_hud_design", "notloaded") != "notloaded" then
		InitYRPChat()
		timer.Remove("yrp_init_chat")
	end
end)

hook.Add("PlayerBindPress", "yrp_overrideChatbind", function(ply, bind, pressed)
	if GetGlobalDBool("bool_yrp_chat", false) then
		local bTeam = nil
		if bind == "messagemode" then
			bTeam = false
		elseif bind == "messagemode2" then
			bTeam = true
		else
			return
		end

		if yrpChat.window != nil then
			yrpChat:openChatbox(bTeam)
		end
		return true
	end
end)

hook.Add("ChatText", "yrp_serverNotifications", function(index, name, text, type)
	local lply = LocalPlayer()
	if lply:IsValid() and GetGlobalDBool("bool_yrp_chat", false) then
		if type == "joinleave" or type == "none" then
			if pa(yrpChat.richText) then
				yrpChat.richText:AppendText(text.."\n")
			end
		end
	end
end)

hook.Add("HUDShouldDraw", "noMoreDefault", function(name)
	local lply = LocalPlayer()
	if lply:IsValid() and GetGlobalDBool("bool_yrp_chat", false) then
		if name == "CHudChat" then
			return false
		end
	end
end)

net.Receive("sendanim", function()
	local ply = net.ReadEntity()
	local slot = net.ReadInt(32)
	local activity = net.ReadInt(32)
	local loop = net.ReadBool()

	if ply:IsValid() and wk(slot) and wk(activity) and wk(loop) then
		ply:AnimRestartGesture(slot, activity, loop)
	end
end)

net.Receive("stopanim", function()
	local ply = net.ReadEntity()
	local slot = net.ReadInt(32)

	if ply:IsValid() and wk(slot) then
		ply:AnimResetGestureSlot(slot)
	end
end)

net.Receive("yrp_player_say", function(len)
	local _tmp = net.ReadTable()
	local _write = false

	if _tmp.command == "say" or _tmp.command == "yell" or _tmp.command == "advert" or _tmp.command == "general" or _tmp.command == "ooc" or _tmp.command == "looc" or _tmp.command == "me" or _tmp.command == "roll" or _tmp.command == "admin" or _tmp.command == "faction" or _tmp.command == "group" or _tmp.command == "role" or _tmp.command == "service" then
		_write = true

		_tmp.status = ""
		if _tmp.afk then
			_tmp.status = "<AFK>"
		end
		if _tmp.dnd then
			_tmp.status = "<DND>"
		end

		_tmp.name = ""
		if _tmp.command != "roll" then
			if !strEmpty(_tmp.factionname) then
				_tmp.name = _tmp.name .. "[" .. _tmp.factionname .. "] "
			end
			if !strEmpty(_tmp.groupname) and _tmp.groupname != _tmp.factionname then
				_tmp.name = _tmp.name .. _tmp.groupname .. " "
			end
			if !strEmpty(_tmp.idcardid) then
				_tmp.name = _tmp.name .. _tmp.idcardid .. " "
			end
			if !strEmpty(_tmp.rolename) then
				_tmp.name = _tmp.name .. _tmp.rolename .. " "
			end
			_tmp.name = _tmp.name .. _tmp.rpname
		end
	end

	local _usergroup = false
	if _tmp.command == "ooc" or _tmp.command == "looc" or _tmp.command == "admin" then
		_usergroup = true
		_tmp.name = _tmp.steamname
	end

	if true then
		local _unpack = {}

		_tmp._lokal = ""
		_tmp.lokal_color = Color(255, 100, 100)
		if !_tmp.lokal then
			_tmp._lokal = YRP.lang_string("LID_globalchat")
			_tmp.lokal_color = Color(255, 165, 0)

			table.insert(_unpack, _tmp.lokal_color)
			table.insert(_unpack, "[")
			table.insert(_unpack, string.upper(_tmp._lokal))
			table.insert(_unpack, "]")

			table.insert(_unpack, " ")

			if _usergroup then
				if !strEmpty(_tmp.usergroup) then
					table.insert(_unpack, _tmp.usergroup_color)
					table.insert(_unpack, "[")
					table.insert(_unpack, string.upper(_tmp.usergroup))
					table.insert(_unpack, "]")

					table.insert(_unpack, " ")
				end
			end
		end

		if !_tmp.isyrpcommand then
			table.insert(_unpack, Color(255, 0, 0))
			table.insert(_unpack, "[")
			table.insert(_unpack, YRP.lang_string("LID_command"))
			table.insert(_unpack, "]")
			table.insert(_unpack, " ")
		end

		if _tmp.command != "me" and _tmp.command != "roll" then
			table.insert(_unpack, _tmp.command_color)
			table.insert(_unpack, "[")
			table.insert(_unpack, string.upper(	niceCommand(_tmp.command)))
			table.insert(_unpack, "]")
			table.insert(_unpack, " ")
		end

		table.insert(_unpack, Color(255, 0, 0))
		table.insert(_unpack, _tmp.status)

		table.insert(_unpack, _tmp.command_color)
		table.insert(_unpack, _tmp.name)

		if _tmp.command != "me" and _tmp.command != "roll" then
			table.insert(_unpack, ":\n")
		elseif _tmp.command != "roll" then
			table.insert(_unpack, " ")
		end

		table.insert(_unpack, _tmp.text_color)
		table.insert(_unpack, tostring(_tmp.text))

		chat.AddText(true, unpack(_unpack))
		chat.PlaySound()
	end
end)
