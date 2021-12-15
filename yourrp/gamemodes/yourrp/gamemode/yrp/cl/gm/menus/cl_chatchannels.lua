--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

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

	local win = createD( "YFrame", nil, YRP.ctr(1600), YRP.ctr(1360), 0, 0)
	win:Center()
	win:MakePopup()
	if edit then
		win:SetTitle( "LID_edit" )
	else
		win:SetTitle( "LID_add" )
	end

	local CON = win:GetContent()

	-- NAME
	win.nameheader = createD( "YLabel", CON, YRP.ctr(760), YRP.ctr(50), YRP.ctr(0), YRP.ctr(0) )
	win.nameheader:SetText( "LID_name" )

	win.name = createD( "DTextEntry", CON, YRP.ctr(760), YRP.ctr(50), YRP.ctr(0), YRP.ctr(50) )
	function win.name:OnChange()
		name = win.name:GetText()
	end
	if edit then
		name = GetGlobalTable( "yrp_chat_channels" )[uid].string_name
		win.name:SetText(name)
	end

	-- MODE
	win.modeheader = createD( "YLabel", CON, YRP.ctr(760), YRP.ctr(50), YRP.ctr(800), YRP.ctr(0) )
	win.modeheader:SetText( "LID_mode" )

	win.mode = createD( "DComboBox", CON, YRP.ctr(760), YRP.ctr(50), YRP.ctr(800), YRP.ctr(50) )
	function win.mode:OnSelect(index, value, data)		
		mode = data
		if pa( win.structure2 ) then
			if mode == 6 then
				win.structure2header:Show()
				win.structure2:Show()
			else
				win.structure2header:Hide()
				win.structure2:Hide()
			end
		end
	end
	local modes = {
		{"LID_globalchat", 0},
		{"LID_localchat", 1},
		{"LID_faction", 2},
		{"LID_group", 3},
		{"LID_role", 4},
		{"LID_usergroup", 5},
		{"LID_whisper", 6},
		{"LID_custom", 9},
	}
	for i, v in pairs(modes) do
		local selected = false
		if edit then
			mode = tonumber(GetGlobalTable( "yrp_chat_channels" )[uid].int_mode)
			if isnumber(mode) and v[2] == mode then
				selected = true
			end
		end
		win.mode:AddChoice(YRP.lang_string( v[1]), v[2], selected)
	end


	-- STRUCTURE
	win.structureheader = createD( "YLabel", CON, YRP.ctr(1600), YRP.ctr(50), YRP.ctr(0), YRP.ctr(150) )
	win.structureheader:SetText( "LID_structure" )

	win.structure = createD( "DTextEntry", CON, YRP.ctr(1600), YRP.ctr(50), YRP.ctr(0), YRP.ctr(200) )
	function win.structure:OnChange()
		structure = win.structure:GetText()
		if pa(win.previewrich) then
			win.previewrich:Think()
		end
	end
	if edit then
		structure = GetGlobalTable( "yrp_chat_channels" )[uid].string_structure
		if isstring(structure) then
			win.structure:SetText(structure)
		end
	end
	-- RPName
	win.rpname = createD( "YButton", CON, YRP.ctr(300), YRP.ctr(50), YRP.ctr(0), YRP.ctr(250) )
	win.rpname:SetText( "LID_rpname" )
	function win.rpname:DoClick()
		win.structure:SetText(win.structure:GetText() .. "%RPNAME%" )
		structure = win.structure:GetText()
	end
	-- STEAMNAME
	win.steamname = createD( "YButton", CON, YRP.ctr(300), YRP.ctr(50), YRP.ctr(320), YRP.ctr(250) )
	win.steamname:SetText( "LID_steamname" )
	function win.steamname:DoClick()
		win.structure:SetText(win.structure:GetText() .. "%STEAMNAME%" )
		structure = win.structure:GetText()
	end
	-- USERGROUP
	win.usergroup = createD( "YButton", CON, YRP.ctr(300), YRP.ctr(50), YRP.ctr(640), YRP.ctr(250) )
	win.usergroup:SetText( "LID_usergroup" )
	function win.usergroup:DoClick()
		win.structure:SetText(win.structure:GetText() .. "%USERGROUP%" )
		structure = win.structure:GetText()
	end
	-- IDCARDID
	win.idcardid = createD( "YButton", CON, YRP.ctr(300), YRP.ctr(50), YRP.ctr(960), YRP.ctr(250) )
	win.idcardid:SetText( "LID_idcardid" )
	function win.idcardid:DoClick()
		win.structure:SetText(win.structure:GetText() .. "%IDCARDID%" )
		structure = win.structure:GetText()
	end

	-- FACTION
	win.faction = createD( "YButton", CON, YRP.ctr(300), YRP.ctr(50), YRP.ctr(0), YRP.ctr(310) )
	win.faction:SetText( "LID_faction" )
	function win.faction:DoClick()
		win.structure:SetText(win.structure:GetText() .. "%FACTION%" )
		structure = win.structure:GetText()
	end
	-- GROUP
	win.group = createD( "YButton", CON, YRP.ctr(300), YRP.ctr(50), YRP.ctr(320), YRP.ctr(310) )
	win.group:SetText( "LID_group" )
	function win.group:DoClick()
		win.structure:SetText(win.structure:GetText() .. "%GROUP%" )
		structure = win.structure:GetText()
	end
	-- ROLE
	win.role = createD( "YButton", CON, YRP.ctr(300), YRP.ctr(50), YRP.ctr(640), YRP.ctr(310) )
	win.role:SetText( "LID_role" )
	function win.role:DoClick()
		win.structure:SetText(win.structure:GetText() .. "%ROLE%" )
		structure = win.structure:GetText()
	end

	-- USERGROUPCOLOr
	win.rolecolor = createD( "YButton", CON, YRP.ctr(300), YRP.ctr(50), YRP.ctr(960), YRP.ctr(310) )
	win.rolecolor:SetText(YRP.lang_string( "LID_role" ) .. " ( " .. YRP.lang_string( "LID_color" ) .. " )" )
	function win.rolecolor:DoClick()
		win.structure:SetText(win.structure:GetText() .. "%ROCOLOR%" )
		structure = win.structure:GetText()
	end
	
	-- TEXT
	win.text = createD( "YButton", CON, YRP.ctr(300), YRP.ctr(50), YRP.ctr(0), YRP.ctr(370) )
	win.text:SetText( "LID_text" )
	function win.text:DoClick()
		win.structure:SetText(win.structure:GetText() .. "%TEXT%" )
		structure = win.structure:GetText()
	end

	-- TARGET
	win.target = createD( "YButton", CON, YRP.ctr(300), YRP.ctr(50), YRP.ctr(320), YRP.ctr(370) )
	win.target:SetText( "LID_target" )
	function win.target:DoClick()
		win.structure:SetText(win.structure:GetText() .. "%TARGET%" )
		structure = win.structure:GetText()
	end

	-- USERGROUPCOLOr
	win.usergroupcolor = createD( "YButton", CON, YRP.ctr(620), YRP.ctr(50), YRP.ctr(640), YRP.ctr(370) )
	win.usergroupcolor:SetText(YRP.lang_string( "LID_usergroup" ) .. " ( " .. YRP.lang_string( "LID_color" ) .. " )" )
	function win.usergroupcolor:DoClick()
		win.structure:SetText(win.structure:GetText() .. "%UGCOLOR%" )
		structure = win.structure:GetText()
	end

	-- STRUCTURE 2
	win.structure2header = createD( "YLabel", CON, YRP.ctr(1600), YRP.ctr(50), YRP.ctr(0), YRP.ctr(450) )
	win.structure2header:SetText( "BACK" )

	win.structure2 = createD( "DTextEntry", CON, YRP.ctr(1600), YRP.ctr(50), YRP.ctr(0), YRP.ctr(500) )
	function win.structure2:OnChange()
		structure2 = win.structure2:GetText()
		if pa(win.previewrich) then
			win.previewrich:Think()
		end
	end
	if edit then
		structure2 = GetGlobalTable( "yrp_chat_channels" )[uid].string_structure2
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
	win.enabled = createD( "DCheckBox", CON, YRP.ctr(50), YRP.ctr(50), YRP.ctr(0), YRP.ctr(600) )
	if edit then
		win.enabled:SetChecked(tobool(GetGlobalTable( "yrp_chat_channels" )[uid].bool_enabled) )
	else
		win.enabled:SetChecked(true)
	end
	function win.enabled:OnChange( bVal)
		if bVal then
			enabled = 1
		else
			enabled = 0
		end
	end
	win.enabledname = createD( "YLabel", CON, YRP.ctr(250), YRP.ctr(50), YRP.ctr(50), YRP.ctr(600) )
	win.enabledname:SetText( "LID_enabled" )
	


	win.preview = createD( "YLabel", CON, YRP.ctr(1600), YRP.ctr(50), YRP.ctr(0), YRP.ctr(700) )
	win.preview:SetText( "LID_preview" )

	win.previewtext = createD( "DTextEntry", CON, YRP.ctr(1600), YRP.ctr(50), YRP.ctr(0), YRP.ctr(750) )
	win.previewtext:SetText( "" )
	win.previewtext:SetPlaceholderText( "Example Text" )
	function win.previewtext:OnChange()
		if pa(win.previewrich) then
			win.previewrich:Think()
		end
	end

	win.previewrich = createD( "RichText", CON, YRP.ctr(1600), YRP.ctr(200), YRP.ctr(0), YRP.ctr(800) )
	win.previewrich:SetText(win.structure:GetText() )

	function win.previewrich:Think()
		if pa(win.previewrich) and pa(win.previewtext) then
			win.previewrich:SetText( "" )
			local pk = YRPChatReplaceCMDS(win.structure:GetText(), LocalPlayer(), YRPReplaceWithPlayerNames(win.previewtext:GetText() ))
			if mode == 6 then
				win.previewrich:InsertColorChange(255, 255, 255, 255)
				win.previewrich:AppendText( "Target chat:\n" )
			end
			for i, v in pairs(pk) do
				if type( v) == "string" then
					win.previewrich:AppendText( v)
				elseif type( v) == "table" then
					win.previewrich:InsertColorChange( v.r, v.g, v.b, 255)
				else
					YRP.msg( "note", "[previewrich] ELSE: " .. tostring(type( v) ) .. " " .. tostring( v) )
				end
			end

			if mode == 6 then
				win.previewrich:AppendText( "\n" )
				if mode == 6 then
					win.previewrich:InsertColorChange(255, 255, 255, 255)
					win.previewrich:AppendText( "Own chat:\n" )
				end
				local pk2 = YRPChatReplaceCMDS(win.structure2:GetText(), LocalPlayer(), YRPReplaceWithPlayerNames(win.previewtext:GetText() ))
				for i, v in pairs(pk2) do
					if type( v) == "string" then
						win.previewrich:AppendText( v)
					elseif type( v) == "table" then
						win.previewrich:InsertColorChange( v.r, v.g, v.b, 255)
					else
						YRP.msg( "note", "[previewrich] ELSE: " .. tostring(type( v) ) .. " " .. tostring( v) )
					end
				end
			end
		end
	end
	win.previewrich:Think()

	if edit then
		win.save = createD( "YButton", CON, YRP.ctr(760), YRP.ctr(50), 0, YRP.ctr(1170) )
		win.save:SetText( "LID_save" )
		function win.save:Paint(pw, ph)
			hook.Run( "YButtonAPaint", self, pw, ph)
		end
		function win.save:DoClick()
			net.Start( "yrp_chat_channel_save" )
				net.WriteString(name or "" )
				net.WriteString(mode or "" )
				net.WriteString(structure or "" )
				net.WriteString(structure2 or "" )

				net.WriteString(enabled)

				net.WriteTable( augs)
				net.WriteTable( agrps)
				net.WriteTable( arols)

				net.WriteTable(pugs)
				net.WriteTable(pgrps)
				net.WriteTable(prols)

				net.WriteString(uid)
			net.SendToServer()

			win:Remove()
			timer.Simple(0.4, function()
				OpenChatMenu()
			end)
		end

		if GetGlobalTable( "yrp_chat_channels" )[uid]["bool_removeable"] then
			win.rem = createD( "YButton", CON, YRP.ctr(760), YRP.ctr(50), YRP.ctr(800), YRP.ctr(1170) )
			win.rem:SetText( "LID_remove" )
			function win.rem:Paint(pw, ph)
				hook.Run( "YButtonRPaint", self, pw, ph)
			end
			function win.rem:DoClick()
				net.Start( "yrp_chat_channel_rem" )
					net.WriteString(uid)
				net.SendToServer()

				win:Remove()
				timer.Simple(0.4, function()
					OpenChatMenu()
				end)
			end
		end
	else
		win.add = createD( "YButton", CON, YRP.ctr(760), YRP.ctr(50), 0, YRP.ctr(1170) )
		win.add:SetText( "LID_add" )
		function win.add:Paint(pw, ph)
			hook.Run( "YButtonAPaint", self, pw, ph)
		end
		function win.add:DoClick()
			net.Start( "yrp_chat_channel_add" )
				net.WriteString(name)
				net.WriteString(mode)
				net.WriteString(structure)
				net.WriteString(structure2)

				net.WriteString(enabled)

				net.WriteTable( augs)
				net.WriteTable( agrps)
				net.WriteTable( arols)

				net.WriteTable(pugs)
				net.WriteTable(pgrps)
				net.WriteTable(prols)
			net.SendToServer()

			win:Remove()
			timer.Simple(0.4, function()
				OpenChatMenu()
			end)
		end
	end
end

function OpenChatMenu()
	local lply = LocalPlayer()

	vm.win = createD( "YFrame", nil, YRP.ctr(1400), YRP.ctr(1600), 0, 0)
	vm.win:Center()
	vm.win:MakePopup()
	vm.win:SetTitle( "LID_chat" )

	local CONTENT = vm.win:GetContent()

	vm.win.list = createD( "DPanelList", CONTENT, CONTENT:GetWide(), CONTENT:GetTall() - YRP.ctr(50 + 20), 0, 0)
	vm.win.list:EnableVerticalScrollbar()
	vm.win.list:SetSpacing(YRP.ctr(10) )

	local h = YRP.ctr(80)
	local pbr = YRP.ctr(20)
	for i, channel in pairs(GetGlobalTable( "yrp_chat_channels", {}) ) do
		if lply:HasAccess() then
			local line = createD( "DPanel", nil, CONTENT:GetWide(), h, 0, 0)
			function line:Paint(pw, ph)
			end

			local bg = createD( "DPanel", line, CONTENT:GetWide() - YRP.ctr(26), h, 0, 0)
			function bg:Paint(pw, ph)
				draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, lply:InterfaceValue( "YFrame", "PC" ) )
			end

			local status = createD( "DPanel", bg, h, h, 0, 0)
			function status:Paint(pw, ph)
				local color = Color(255, 0, 0, 255)
				if channel.bool_enabled == 1 then
					color = Color(0, 255, 0, 255)
				end
				draw.RoundedBox(ph / 2, 0, 0, pw, ph, color)
			end

			if lply:HasAccess() then
				local edit = createD( "DButton", bg, h , h, 0, 0)
				edit:SetText( "" )
				function edit:Paint(pw, ph)
					local br = YRP.ctr(8)
					if YRP.GetDesignIcon( "edit" ) then
						surface.SetMaterial( YRP.GetDesignIcon( "edit" ) )
						surface.SetDrawColor( 255, 255, 255, 255 )
						surface.DrawTexturedRect( br, br, ph - 2 * br, ph - 2 * br)
					end
				end
				function edit:DoClick()
					YRPChatChannel(true, channel.uniqueID)
				end
			end

			local name = createD( "DPanel", bg, YRP.ctr(800), h, h + pbr, 0)
			function name:Paint(pw, ph)
				draw.SimpleText( channel.string_name, "Y_24_500", 0, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end

			vm.win.list:AddItem(line)
		end
	end

	if lply:HasAccess() then
		local size = YRP.ctr(50)
		vm.win.add = createD( "YButton", CONTENT, size, size, YRP.ctr(0), CONTENT:GetTall() - YRP.ctr(50) )
		vm.win.add:SetText( "+" )
		function vm.win.add:Paint(pw, ph)
			hook.Run( "YButtonAPaint", self, pw, ph)
		end
		function vm.win.add:DoClick()
			YRPChatChannel(false)
		end
	end
end

function ToggleChatMenu()
	if pa( vm.win) then
		CloseChatMenu()
	elseif YRPIsNoMenuOpen() then
		OpenChatMenu()
	end
end
