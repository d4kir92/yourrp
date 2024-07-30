--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local _type = type
local _tostring = tostring
local vm = {}
function CloseChatMenu()
	vm.win:Remove()
end

function YRPChatChannel(edit, uid)
	CloseChatMenu()
	local name = ""
	local mode = ""
	local structure = ""
	local structure2 = ""
	local enabled = 1
	local augs = {}
	local agrps = {}
	local arols = {}
	local pugs = {}
	local pgrps = {}
	local prols = {}
	local win = YRPCreateD("YFrame", nil, YRP:ctr(1600), YRP:ctr(1360), 0, 0)
	win:Center()
	win:MakePopup()
	if edit then
		win:SetTitle("LID_edit")
	else
		win:SetTitle("LID_add")
	end

	local CON = win:GetContent()
	-- NAME
	win.nameheader = YRPCreateD("YLabel", CON, YRP:ctr(760), YRP:ctr(50), YRP:ctr(0), YRP:ctr(0))
	win.nameheader:SetText("LID_name")
	win.name = YRPCreateD("DTextEntry", CON, YRP:ctr(760), YRP:ctr(50), YRP:ctr(0), YRP:ctr(50))
	function win.name:OnChange()
		name = win.name:GetText()
	end

	if edit and GetGlobalYRPTable("yrp_chat_channels")[uid] then
		name = GetGlobalYRPTable("yrp_chat_channels")[uid].string_name
		win.name:SetText(name)
	end

	-- MODE
	win.modeheader = YRPCreateD("YLabel", CON, YRP:ctr(760), YRP:ctr(50), YRP:ctr(800), YRP:ctr(0))
	win.modeheader:SetText("LID_mode")
	win.mode = YRPCreateD("DComboBox", CON, YRP:ctr(760), YRP:ctr(50), YRP:ctr(800), YRP:ctr(50))
	function win.mode:OnSelect(index, value, data)
		mode = data
		if YRPPanelAlive(win.structure2) then
			if mode == 6 then
				win.structure2header:Show()
				win.structure2:Show()
			else
				win.structure2header:Hide()
				win.structure2:Hide()
			end
		end
	end

	local modes = {{"LID_globalchat", 0}, {"LID_localchat", 1}, {"LID_faction", 2}, {"LID_group", 3}, {"LID_role", 4}, {"LID_usergroup", 5}, {"LID_whisper", 6}, {"LID_custom", 9},}
	for i, v in pairs(modes) do
		local selected = false
		if edit and GetGlobalYRPTable("yrp_chat_channels")[uid] then
			mode = tonumber(GetGlobalYRPTable("yrp_chat_channels")[uid].int_mode)
			if isnumber(mode) and v[2] == mode then
				selected = true
			end
		end

		win.mode:AddChoice(YRP:trans(v[1]), v[2], selected)
	end

	-- STRUCTURE
	win.structureheader = YRPCreateD("YLabel", CON, YRP:ctr(1600), YRP:ctr(50), YRP:ctr(0), YRP:ctr(150))
	win.structureheader:SetText("LID_structure")
	win.structure = YRPCreateD("DTextEntry", CON, YRP:ctr(1600), YRP:ctr(50), YRP:ctr(0), YRP:ctr(200))
	function win.structure:OnChange()
		structure = win.structure:GetText()
		if YRPPanelAlive(win.previewrich) then
			win.previewrich:UpdatePreview("structure")
		end
	end

	if edit and GetGlobalYRPTable("yrp_chat_channels")[uid] then
		structure = GetGlobalYRPTable("yrp_chat_channels")[uid].string_structure
		if isstring(structure) then
			win.structure:SetText(structure)
		end
	end

	-- RPName
	win.rpname = YRPCreateD("YButton", CON, YRP:ctr(300), YRP:ctr(50), YRP:ctr(0), YRP:ctr(250))
	win.rpname:SetText("LID_rpname")
	function win.rpname:DoClick()
		win.structure:SetText(win.structure:GetText() .. "%RPNAME%")
		structure = win.structure:GetText()
	end

	-- STEAMNAME
	win.steamname = YRPCreateD("YButton", CON, YRP:ctr(300), YRP:ctr(50), YRP:ctr(320), YRP:ctr(250))
	win.steamname:SetText("LID_steamname")
	function win.steamname:DoClick()
		win.structure:SetText(win.structure:GetText() .. "%STEAMNAME%")
		structure = win.structure:GetText()
	end

	-- USERGROUP
	win.usergroup = YRPCreateD("YButton", CON, YRP:ctr(300), YRP:ctr(50), YRP:ctr(640), YRP:ctr(250))
	win.usergroup:SetText("LID_usergroup")
	function win.usergroup:DoClick()
		win.structure:SetText(win.structure:GetText() .. "%USERGROUP%")
		structure = win.structure:GetText()
	end

	-- IDCARDID
	win.idcardid = YRPCreateD("YButton", CON, YRP:ctr(300), YRP:ctr(50), YRP:ctr(960), YRP:ctr(250))
	win.idcardid:SetText("LID_idcardid")
	function win.idcardid:DoClick()
		win.structure:SetText(win.structure:GetText() .. "%IDCARDID%")
		structure = win.structure:GetText()
	end

	-- FACTION
	win.faction = YRPCreateD("YButton", CON, YRP:ctr(300), YRP:ctr(50), YRP:ctr(0), YRP:ctr(310))
	win.faction:SetText("LID_faction")
	function win.faction:DoClick()
		win.structure:SetText(win.structure:GetText() .. "%FACTION%")
		structure = win.structure:GetText()
	end

	-- GROUP
	win.group = YRPCreateD("YButton", CON, YRP:ctr(300), YRP:ctr(50), YRP:ctr(320), YRP:ctr(310))
	win.group:SetText("LID_group")
	function win.group:DoClick()
		win.structure:SetText(win.structure:GetText() .. "%GROUP%")
		structure = win.structure:GetText()
	end

	-- ROLE
	win.role = YRPCreateD("YButton", CON, YRP:ctr(300), YRP:ctr(50), YRP:ctr(640), YRP:ctr(310))
	win.role:SetText("LID_role")
	function win.role:DoClick()
		win.structure:SetText(win.structure:GetText() .. "%ROLE%")
		structure = win.structure:GetText()
	end

	-- USERGROUPCOLOr
	win.rolecolor = YRPCreateD("YButton", CON, YRP:ctr(300), YRP:ctr(50), YRP:ctr(960), YRP:ctr(310))
	win.rolecolor:SetText(YRP:trans("LID_role") .. " ( " .. YRP:trans("LID_color") .. " )")
	function win.rolecolor:DoClick()
		win.structure:SetText(win.structure:GetText() .. "%ROCOLOR%")
		structure = win.structure:GetText()
	end

	-- TEXT
	win.text = YRPCreateD("YButton", CON, YRP:ctr(300), YRP:ctr(50), YRP:ctr(0), YRP:ctr(370))
	win.text:SetText("LID_text")
	function win.text:DoClick()
		win.structure:SetText(win.structure:GetText() .. "%TEXT%")
		structure = win.structure:GetText()
	end

	-- TARGET
	win.target = YRPCreateD("YButton", CON, YRP:ctr(300), YRP:ctr(50), YRP:ctr(320), YRP:ctr(370))
	win.target:SetText("LID_target")
	function win.target:DoClick()
		win.structure:SetText(win.structure:GetText() .. "%TARGET%")
		structure = win.structure:GetText()
	end

	-- USERGROUPCOLOr
	win.usergroupcolor = YRPCreateD("YButton", CON, YRP:ctr(620), YRP:ctr(50), YRP:ctr(640), YRP:ctr(370))
	win.usergroupcolor:SetText(YRP:trans("LID_usergroup") .. " ( " .. YRP:trans("LID_color") .. " )")
	function win.usergroupcolor:DoClick()
		win.structure:SetText(win.structure:GetText() .. "%UGCOLOR%")
		structure = win.structure:GetText()
	end

	-- STRUCTURE 2
	win.structure2header = YRPCreateD("YLabel", CON, YRP:ctr(1600), YRP:ctr(50), YRP:ctr(0), YRP:ctr(450))
	win.structure2header:SetText("BACK")
	win.structure2 = YRPCreateD("DTextEntry", CON, YRP:ctr(1600), YRP:ctr(50), YRP:ctr(0), YRP:ctr(500))
	function win.structure2:OnChange()
		structure2 = win.structure2:GetText()
		if YRPPanelAlive(win.previewrich) then
			win.previewrich:UpdatePreview("structure2")
		end
	end

	if edit and GetGlobalYRPTable("yrp_chat_channels")[uid] then
		structure2 = GetGlobalYRPTable("yrp_chat_channels")[uid].string_structure2
		if isstring(structure2) then
			win.structure2:SetText(structure2)
		end
	end

	if mode == 6 then
		win.structure2header:Show()
		win.structure2:Show()
	else
		win.structure2header:Hide()
		win.structure2:Hide()
	end

	-- enabled
	win.enabled = YRPCreateD("DCheckBox", CON, YRP:ctr(50), YRP:ctr(50), YRP:ctr(0), YRP:ctr(600))
	if edit and GetGlobalYRPTable("yrp_chat_channels")[uid] then
		win.enabled:SetChecked(tobool(GetGlobalYRPTable("yrp_chat_channels")[uid].bool_enabled))
	else
		win.enabled:SetChecked(true)
	end

	function win.enabled:OnChange(bVal)
		if bVal then
			enabled = 1
		else
			enabled = 0
		end
	end

	win.enabledname = YRPCreateD("YLabel", CON, YRP:ctr(250), YRP:ctr(50), YRP:ctr(50), YRP:ctr(600))
	win.enabledname:SetText("LID_enabled")
	win.preview = YRPCreateD("YLabel", CON, YRP:ctr(1600), YRP:ctr(50), YRP:ctr(0), YRP:ctr(700))
	win.preview:SetText("LID_preview")
	win.previewtext = YRPCreateD("DTextEntry", CON, YRP:ctr(1600), YRP:ctr(50), YRP:ctr(0), YRP:ctr(750))
	win.previewtext:SetText("")
	win.previewtext:SetPlaceholderText("Example Text")
	function win.previewtext:OnChange()
		if YRPPanelAlive(win.previewrich) then
			win.previewrich:UpdatePreview("previewtext")
		end
	end

	win.previewrich = YRPCreateD("RichText", CON, YRP:ctr(1600), YRP:ctr(200), YRP:ctr(0), YRP:ctr(800))
	win.previewrich:SetText(win.structure:GetText())
	function win.previewrich:UpdatePreview(from)
		if YRPPanelAlive(win.previewrich) and YRPPanelAlive(win.previewtext) then
			win.previewrich:SetText("")
			local pk = YRPChatReplaceCMDS(win.structure:GetText(), LocalPlayer(), YRPReplaceWithPlayerNames(win.previewtext:GetText()))
			if mode == 6 then
				win.previewrich:InsertColorChange(255, 255, 255, 255)
				win.previewrich:AppendText("Target chat:\n")
			end

			for i, v in pairs(pk) do
				if _type(v) == "string" then
					win.previewrich:AppendText(v)
				elseif _type(v) == "table" then
					win.previewrich:InsertColorChange(v.r, v.g, v.b, 255)
				else
					YRP:msg("note", "[previewrich] ELSE: " .. _tostring(_type(v)) .. " " .. _tostring(v))
				end
			end

			if mode == 6 then
				win.previewrich:AppendText("\n")
				if mode == 6 then
					win.previewrich:InsertColorChange(255, 255, 255, 255)
					win.previewrich:AppendText("Own chat:\n")
				end

				local pk2 = YRPChatReplaceCMDS(win.structure2:GetText(), LocalPlayer(), YRPReplaceWithPlayerNames(win.previewtext:GetText()))
				for i, v in pairs(pk2) do
					if _type(v) == "string" then
						win.previewrich:AppendText(v)
					elseif _type(v) == "table" then
						win.previewrich:InsertColorChange(v.r, v.g, v.b, 255)
					else
						YRP:msg("note", "[previewrich] ELSE: " .. _tostring(_type(v)) .. " " .. _tostring(v))
					end
				end
			end
		end

		if from == "INIT" then
			timer.Simple(
				0.5,
				function()
					if win and win.previewrich then
						win.previewrich:UpdatePreview(from)
					end
				end
			)
		end
	end

	win.previewrich:UpdatePreview("INIT")
	if edit then
		win.save = YRPCreateD("YButton", CON, YRP:ctr(760), YRP:ctr(50), 0, YRP:ctr(1170))
		win.save:SetText("LID_save")
		function win.save:Paint(pw, ph)
			hook.Run("YButtonAPaint", self, pw, ph)
		end

		function win.save:DoClick()
			net.Start("nws_yrp_chat_channel_save")
			net.WriteString(name or "")
			net.WriteString(mode or "")
			net.WriteString(structure or "")
			net.WriteString(structure2 or "")
			net.WriteString(enabled)
			net.WriteTable(augs)
			net.WriteTable(agrps)
			net.WriteTable(arols)
			net.WriteTable(pugs)
			net.WriteTable(pgrps)
			net.WriteTable(prols)
			net.WriteString(uid)
			net.SendToServer()
			win:Remove()
			timer.Simple(
				0.4,
				function()
					OpenChatMenu()
				end
			)
		end

		if GetGlobalYRPTable("yrp_chat_channels")[uid] and GetGlobalYRPTable("yrp_chat_channels")[uid]["bool_removeable"] then
			win.rem = YRPCreateD("YButton", CON, YRP:ctr(760), YRP:ctr(50), YRP:ctr(800), YRP:ctr(1170))
			win.rem:SetText("LID_remove")
			function win.rem:Paint(pw, ph)
				hook.Run("YButtonRPaint", self, pw, ph)
			end

			function win.rem:DoClick()
				net.Start("nws_yrp_chat_channel_rem")
				net.WriteString(uid)
				net.SendToServer()
				win:Remove()
				timer.Simple(
					0.4,
					function()
						OpenChatMenu()
					end
				)
			end
		end
	else
		win.add = YRPCreateD("YButton", CON, YRP:ctr(760), YRP:ctr(50), 0, YRP:ctr(1170))
		win.add:SetText("LID_add")
		function win.add:Paint(pw, ph)
			hook.Run("YButtonAPaint", self, pw, ph)
		end

		function win.add:DoClick()
			net.Start("nws_yrp_chat_channel_add")
			net.WriteString(name)
			net.WriteString(mode)
			net.WriteString(structure)
			net.WriteString(structure2)
			net.WriteString(enabled)
			net.WriteTable(augs)
			net.WriteTable(agrps)
			net.WriteTable(arols)
			net.WriteTable(pugs)
			net.WriteTable(pgrps)
			net.WriteTable(prols)
			net.SendToServer()
			win:Remove()
			timer.Simple(
				0.4,
				function()
					OpenChatMenu()
				end
			)
		end
	end
end

function OpenChatMenu()
	local lply = LocalPlayer()
	vm.win = YRPCreateD("YFrame", nil, YRP:ctr(1400), YRP:ctr(1600), 0, 0)
	vm.win:Center()
	vm.win:MakePopup()
	vm.win:SetTitle("LID_chat")
	local CONTENT = vm.win:GetContent()
	vm.win.list = YRPCreateD("DPanelList", CONTENT, CONTENT:GetWide(), CONTENT:GetTall() - YRP:ctr(50 + 20), 0, 0)
	vm.win.list:EnableVerticalScrollbar()
	vm.win.list:SetSpacing(YRP:ctr(10))
	local h = YRP:ctr(80)
	local pbr = YRP:ctr(20)
	for i, channel in pairs(GetGlobalYRPTable("yrp_chat_channels", {})) do
		if lply:HasAccess("OpenChatMenu1") or lply:GetYRPBool("bool_chat") then
			local line = YRPCreateD("DPanel", nil, CONTENT:GetWide(), h, 0, 0)
			function line:Paint(pw, ph)
			end

			local bg = YRPCreateD("DPanel", line, CONTENT:GetWide() - YRP:ctr(26), h, 0, 0)
			function bg:Paint(pw, ph)
				draw.RoundedBox(YRP:ctr(10), 0, 0, pw, ph, YRPInterfaceValue("YFrame", "PC"))
			end

			local status = YRPCreateD("DPanel", bg, h, h, 0, 0)
			function status:Paint(pw, ph)
				local color = Color(255, 0, 0, 255)
				if channel.bool_enabled == 1 then
					color = Color(0, 255, 0, 255)
				end

				draw.RoundedBox(ph / 2, 0, 0, pw, ph, color)
			end

			if lply:HasAccess("OpenChatMenu2") or lply:GetYRPBool("bool_chat") then
				local edit = YRPCreateD("DButton", bg, h, h, 0, 0)
				edit:SetText("")
				function edit:Paint(pw, ph)
					local br = YRP:ctr(8)
					if YRP:GetDesignIcon("edit") then
						surface.SetMaterial(YRP:GetDesignIcon("edit"))
						surface.SetDrawColor(Color(255, 255, 255, 255))
						surface.DrawTexturedRect(br, br, ph - 2 * br, ph - 2 * br)
					end
				end

				function edit:DoClick()
					YRPChatChannel(true, channel.uniqueID)
				end
			end

			local name = YRPCreateD("DPanel", bg, YRP:ctr(800), h, h + pbr, 0)
			function name:Paint(pw, ph)
				draw.SimpleText(channel.string_name, "Y_24_500", 0, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end

			vm.win.list:AddItem(line)
		end
	end

	if lply:HasAccess("OpenChatMenu3") or lply:GetYRPBool("bool_chat") then
		local size = YRP:ctr(50)
		vm.win.add = YRPCreateD("YButton", CONTENT, size, size, YRP:ctr(0), CONTENT:GetTall() - YRP:ctr(50))
		vm.win.add:SetText("+")
		function vm.win.add:Paint(pw, ph)
			hook.Run("YButtonAPaint", self, pw, ph)
		end

		function vm.win.add:DoClick()
			YRPChatChannel(false)
		end
	end
end

function YRPToggleChatMenu()
	if YRPPanelAlive(vm.win) then
		CloseChatMenu()
	elseif YRPIsNoMenuOpen() then
		OpenChatMenu()
	end
end
