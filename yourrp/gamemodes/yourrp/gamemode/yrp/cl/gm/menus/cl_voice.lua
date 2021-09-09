--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

local colr = Color(200, 0, 0)
local colg = Color(0, 200, 0)

local vm = {}

function CloseVoiceMenu()
	vm.win:Remove()
end

function YRPVoiceChannel(edit, uid)
	CloseVoiceMenu()

	local name = ""
	local hear = false

	local augs = {}
	local agrps = {}
	local arols = {}

	local pugs = {}
	local pgrps = {}
	local prols = {}

	local win = createD("YFrame", nil, YRP.ctr(1600), YRP.ctr(1210), 0, 0)
	win:Center()
	win:MakePopup()
	if edit then
		win:SetTitle("LID_edit")
	else
		win:SetTitle("LID_add")
	end

	local CON = win:GetContent()

	-- NAME
	win.nameheader = createD("YLabel", CON, YRP.ctr(760), YRP.ctr(50), YRP.ctr(0), YRP.ctr(0))
	win.nameheader:SetText("LID_name")

	win.name = createD("DTextEntry", CON, YRP.ctr(760), YRP.ctr(50), YRP.ctr(0), YRP.ctr(50))
	function win.name:OnChange()
		name = win.name:GetText()
	end
	if edit then
		name = GetGlobalTable("yrp_voice_channels")[uid].string_name
		win.name:SetText(name)
	end
	
	-- Defaults
	win.defaultsheader = createD("YLabel", CON, YRP.ctr(760), YRP.ctr(50), YRP.ctr(800), YRP.ctr(0))
	win.defaultsheader:SetText(YRP.lang_string("LID_defaults"))

	win.defaultsbg = createD("DPanel", CON, YRP.ctr(760), YRP.ctr(50), YRP.ctr(800), YRP.ctr(50))
	function win.defaultsbg:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(20, 20, 20))
	end
	win.defaults = createD("DPanelList", CON, YRP.ctr(760), YRP.ctr(50), YRP.ctr(800), YRP.ctr(50))
	win.defaults:EnableVerticalScrollbar()

	-- Hear?
	local line = createD("DPanel", nil, YRP.ctr(40), YRP.ctr(40), 0, 0)
	function line:Paint(pw, ph)
		draw.SimpleText(YRP.lang_string("LID_hearq"), "Y_14_500", YRP.ctr(40 + 20), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	line.cb = createD("DCheckBox", line, YRP.ctr(40), YRP.ctr(40), 0, 0)
	function line.cb:OnChange(bVal)
		hear = bVal
	end
	
	if edit then
		hear = GetGlobalTable("yrp_voice_channels")[uid].int_hear
		if hear then
			line.cb:SetChecked(hear)
		end
	end
	win.defaults:AddItem(line)



	-- ACTIVE --
	-- USERGROUPS
	win.augsheader = createD("YLabel", CON, YRP.ctr(760), YRP.ctr(50), YRP.ctr(0), YRP.ctr(150))
	win.augsheader:SetText("[" .. YRP.lang_string("LID_active") .. "] " .. YRP.lang_string("LID_usergroups"))

	win.augsbg = createD("DPanel", CON, YRP.ctr(760), YRP.ctr(200), YRP.ctr(0), YRP.ctr(200))
	function win.augsbg:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(20, 20, 20))
	end
	win.augs = createD("DPanelList", CON, YRP.ctr(760), YRP.ctr(200), YRP.ctr(0), YRP.ctr(200))
	win.augs:EnableVerticalScrollbar()
	net.Receive("yrp_vm_get_active_usergroups", function(len)
		local taugs = net.ReadTable()

		for i, ug in pairs(taugs) do
			local line = createD("DPanel", nil, YRP.ctr(40), YRP.ctr(40), 0, 0)
			function line:Paint(pw, ph)
				draw.SimpleText(string.upper(ug.string_name), "Y_14_500", YRP.ctr(40 + 20), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end

			line.cb = createD("DCheckBox", line, YRP.ctr(40), YRP.ctr(40), 0, 0)
			function line.cb:OnChange(bVal)
				if bVal then
					table.insert(augs, ug.string_name)
				else
					table.RemoveByValue(augs, ug.string_name)
				end
			end
			if edit then
				if GetGlobalTable("yrp_voice_channels")[uid]["string_active_usergroups"][ug.string_name] then
					line.cb:SetChecked(true)
					table.insert(augs, ug.string_name)
				end
			end

			if pa(win) and pa(win.augs) then
				win.augs:AddItem(line)
			end
		end
	end)
	net.Start("yrp_vm_get_active_usergroups")
	net.SendToServer()

	-- GROUPS
	win.agrpsheader = createD("YLabel", CON, YRP.ctr(760), YRP.ctr(50), YRP.ctr(0), YRP.ctr(450))
	win.agrpsheader:SetText("[" .. YRP.lang_string("LID_active") .. "] " .. YRP.lang_string("LID_groups"))

	win.agrpsbg = createD("DPanel", CON, YRP.ctr(760), YRP.ctr(200), YRP.ctr(0), YRP.ctr(500))
	function win.agrpsbg:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(20, 20, 20))
	end
	win.agrps = createD("DPanelList", CON, YRP.ctr(760), YRP.ctr(200), YRP.ctr(0), YRP.ctr(500))
	win.agrps:EnableVerticalScrollbar()
	net.Receive("yrp_vm_get_active_groups", function(len)
		local tagrps = net.ReadTable()

		for i, ug in pairs(tagrps) do
			local line = createD("DPanel", nil, YRP.ctr(40), YRP.ctr(40), 0, 0)
			function line:Paint(pw, ph)
				draw.SimpleText(string.upper(ug.string_name), "Y_14_500", YRP.ctr(40 + 20), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end

			line.cb = createD("DCheckBox", line, YRP.ctr(40), YRP.ctr(40), 0, 0)
			function line.cb:OnChange(bVal)
				if bVal then
					table.insert(agrps, ug.uniqueID)
				else
					table.RemoveByValue(agrps, ug.uniqueID)
				end
			end
			if edit then
				if GetGlobalTable("yrp_voice_channels")[uid]["string_active_groups"][tonumber(ug.uniqueID)] then
					line.cb:SetChecked(true)
					table.insert(agrps, ug.uniqueID)
				end
			end

			if pa(win) and pa(win.agrps) then
				win.agrps:AddItem(line)
			end
		end
	end)
	net.Start("yrp_vm_get_active_groups")
	net.SendToServer()

	-- ROLES
	win.arolsheader = createD("YLabel", CON, YRP.ctr(760), YRP.ctr(50), YRP.ctr(0), YRP.ctr(750))
	win.arolsheader:SetText("[" .. YRP.lang_string("LID_active") .. "] " .. YRP.lang_string("LID_roles"))

	win.arolsbg = createD("DPanel", CON, YRP.ctr(760), YRP.ctr(200), YRP.ctr(0), YRP.ctr(800))
	function win.arolsbg:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(20, 20, 20))
	end
	win.arols = createD("DPanelList", CON, YRP.ctr(760), YRP.ctr(200), YRP.ctr(0), YRP.ctr(800))
	win.arols:EnableVerticalScrollbar()
	net.Receive("yrp_vm_get_active_roles", function(len)
		local tarols = net.ReadTable()

		for i, ug in pairs(tarols) do
			local line = createD("DPanel", nil, YRP.ctr(40), YRP.ctr(40), 0, 0)
			function line:Paint(pw, ph)
				draw.SimpleText(string.upper(ug.string_name), "Y_14_500", YRP.ctr(40 + 20), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end

			line.cb = createD("DCheckBox", line, YRP.ctr(40), YRP.ctr(40), 0, 0)
			function line.cb:OnChange(bVal)
				if bVal then
					table.insert(arols, ug.uniqueID)
				else
					table.RemoveByValue(arols, ug.uniqueID)
				end
			end
			if edit then
				if GetGlobalTable("yrp_voice_channels")[uid]["string_active_roles"][tonumber(ug.uniqueID)] then
					line.cb:SetChecked(true)
					table.insert(arols, ug.uniqueID)
				end
			end
			
			if pa(win) and pa(win.arols) then
				win.arols:AddItem(line)
			end
		end
	end)
	net.Start("yrp_vm_get_active_roles")
	net.SendToServer()



	-- PASSIVE --
	-- USERGROUPS
	win.pugsheader = createD("YLabel", CON, YRP.ctr(760), YRP.ctr(50), YRP.ctr(800), YRP.ctr(150))
	win.pugsheader:SetText("[" .. YRP.lang_string("LID_passive") .. "] " .. YRP.lang_string("LID_usergroups"))

	win.pugsbg = createD("DPanel", CON, YRP.ctr(760), YRP.ctr(200), YRP.ctr(800), YRP.ctr(200))
	function win.pugsbg:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(20, 20, 20))
	end
	win.pugs = createD("DPanelList", CON, YRP.ctr(760), YRP.ctr(200), YRP.ctr(800), YRP.ctr(200))
	win.pugs:EnableVerticalScrollbar()
	net.Receive("yrp_vm_get_passive_usergroups", function(len)
		local tpugs = net.ReadTable()

		for i, ug in pairs(tpugs) do
			local line = createD("DPanel", nil, YRP.ctr(40), YRP.ctr(40), 0, 0)
			function line:Paint(pw, ph)
				draw.SimpleText(string.upper(ug.string_name), "Y_14_500", YRP.ctr(40 + 20), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end

			line.cb = createD("DCheckBox", line, YRP.ctr(40), YRP.ctr(40), 0, 0)
			function line.cb:OnChange(bVal)
				if bVal then
					table.insert(pugs, ug.string_name)
				else
					table.RemoveByValue(pugs, ug.string_name)
				end
			end
			if edit then
				if GetGlobalTable("yrp_voice_channels")[uid]["string_passive_usergroups"][ug.string_name] then
					line.cb:SetChecked(true)
					table.insert(pugs, ug.string_name)
				end
			end

			if pa(win) and pa(win.pugs) then
				win.pugs:AddItem(line)	
			end
		end
	end)
	net.Start("yrp_vm_get_passive_usergroups")
	net.SendToServer()

	-- GROUPS
	win.pgrpsheader = createD("YLabel", CON, YRP.ctr(760), YRP.ctr(50), YRP.ctr(800), YRP.ctr(450))
	win.pgrpsheader:SetText("[" .. YRP.lang_string("LID_passive") .. "] " .. YRP.lang_string("LID_groups"))

	win.pgrpsbg = createD("DPanel", CON, YRP.ctr(760), YRP.ctr(200), YRP.ctr(800), YRP.ctr(500))
	function win.pgrpsbg:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(20, 20, 20))
	end
	win.pgrps = createD("DPanelList", CON, YRP.ctr(760), YRP.ctr(200), YRP.ctr(800), YRP.ctr(500))
	win.pgrps:EnableVerticalScrollbar()
	net.Receive("yrp_vm_get_passive_groups", function(len)
		local tpgrps = net.ReadTable()

		for i, ug in pairs(tpgrps) do
			local line = createD("DPanel", nil, YRP.ctr(40), YRP.ctr(40), 0, 0)
			function line:Paint(pw, ph)
				draw.SimpleText(string.upper(ug.string_name), "Y_14_500", YRP.ctr(40 + 20), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end

			line.cb = createD("DCheckBox", line, YRP.ctr(40), YRP.ctr(40), 0, 0)
			function line.cb:OnChange(bVal)
				if bVal then
					table.insert(pgrps, ug.uniqueID)
				else
					table.RemoveByValue(pgrps, ug.uniqueID)
				end
			end
			if edit then
				if GetGlobalTable("yrp_voice_channels")[uid]["string_passive_groups"][tonumber(ug.uniqueID)] then
					line.cb:SetChecked(true)
					table.insert(pgrps, ug.uniqueID)
				end
			end

			if pa(win) and pa(win.pgrps) then
				win.pgrps:AddItem(line)
			end
		end
	end)
	net.Start("yrp_vm_get_passive_groups")
	net.SendToServer()

	-- ROLES
	win.prolsheader = createD("YLabel", CON, YRP.ctr(760), YRP.ctr(50), YRP.ctr(800), YRP.ctr(750))
	win.prolsheader:SetText("[" .. YRP.lang_string("LID_passive") .. "] " .. YRP.lang_string("LID_roles"))

	win.prolsbg = createD("DPanel", CON, YRP.ctr(760), YRP.ctr(200), YRP.ctr(800), YRP.ctr(800))
	function win.prolsbg:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(20, 20, 20))
	end
	win.prols = createD("DPanelList", CON, YRP.ctr(760), YRP.ctr(200), YRP.ctr(800), YRP.ctr(800))
	win.prols:EnableVerticalScrollbar()
	net.Receive("yrp_vm_get_passive_roles", function(len)
		local tprols = net.ReadTable()

		for i, ug in pairs(tprols) do
			local line = createD("DPanel", nil, YRP.ctr(40), YRP.ctr(40), 0, 0)
			function line:Paint(pw, ph)
				draw.SimpleText(string.upper(ug.string_name), "Y_14_500", YRP.ctr(40 + 20), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end

			line.cb = createD("DCheckBox", line, YRP.ctr(40), YRP.ctr(40), 0, 0)
			function line.cb:OnChange(bVal)
				if bVal then
					table.insert(prols, ug.uniqueID)
				else
					table.RemoveByValue(prols, ug.uniqueID)
				end
			end
			if edit then
				if GetGlobalTable("yrp_voice_channels")[uid]["string_passive_roles"][tonumber(ug.uniqueID)] then
					line.cb:SetChecked(true)
					table.insert(prols, ug.uniqueID)
				end
			end

			if pa(win) and pa(win.prols) then
				win.prols:AddItem(line)
			end
		end
	end)
	net.Start("yrp_vm_get_passive_roles")
	net.SendToServer()

	if edit then
		win.save = createD("YButton", CON, YRP.ctr(760), YRP.ctr(50), 0, YRP.ctr(1020))
		win.save:SetText("LID_save")
		function win.save:Paint(pw, ph)
			hook.Run("YButtonAPaint", self, pw, ph)
		end
		function win.save:DoClick()
			net.Start("yrp_voice_channel_save")
				net.WriteString(name)
				net.WriteBool(hear)

				net.WriteTable(augs)
				net.WriteTable(agrps)
				net.WriteTable(arols)

				net.WriteTable(pugs)
				net.WriteTable(pgrps)
				net.WriteTable(prols)

				net.WriteString(uid)
			net.SendToServer()

			win:Remove()
			timer.Simple(0.4, function()
				OpenVoiceMenu()
			end)
		end

		win.rem = createD("YButton", CON, YRP.ctr(760), YRP.ctr(50), YRP.ctr(800), YRP.ctr(1020))
		win.rem:SetText("LID_remove")
		function win.rem:Paint(pw, ph)
			hook.Run("YButtonRPaint", self, pw, ph)
		end
		function win.rem:DoClick()
			net.Start("yrp_voice_channel_rem")
				net.WriteString(uid)
			net.SendToServer()

			win:Remove()
			timer.Simple(0.4, function()
				OpenVoiceMenu()
			end)
		end
	else
		win.add = createD("YButton", CON, YRP.ctr(760), YRP.ctr(50), 0, YRP.ctr(1020))
		win.add:SetText("LID_add")
		function win.add:Paint(pw, ph)
			hook.Run("YButtonAPaint", self, pw, ph)
		end
		function win.add:DoClick()
			net.Start("yrp_voice_channel_add")
				net.WriteString(name)
				net.WriteBool(hear)

				net.WriteTable(augs)
				net.WriteTable(agrps)
				net.WriteTable(arols)

				net.WriteTable(pugs)
				net.WriteTable(pgrps)
				net.WriteTable(prols)
			net.SendToServer()

			win:Remove()
			timer.Simple(0.4, function()
				OpenVoiceMenu()
			end)
		end
	end
end

function OpenVoiceMenu()
	local lply = LocalPlayer()

	vm.win = createD("YFrame", nil, YRP.ctr(1400), YRP.ctr(1600), 0, 0)
	vm.win:Center()
	vm.win:MakePopup()
	vm.win:SetTitle("LID_voicechat")

	local CONTENT = vm.win:GetContent()

	-- HEADER
	vm.win.listheader = createD("DPanel", CONTENT, CONTENT:GetWide(), YRP.ctr(50 + 20), 0, 0)
	function vm.win.listheader:Paint(pw, ph)
		draw.SimpleText(YRP.lang_string("LID_name"), "Y_20_500", YRP.ctr(100), ph / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(lply:GetNW2Int("yrp_voice_channel_active_mic", 0) .. "/" .. "1", "Y_20_500", YRP.ctr(1190), ph / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(lply:GetNW2Int("yrp_voice_channel_passive_voice", 0), "Y_20_500", YRP.ctr(1290), ph / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	-- LIST
	vm.win.list = createD("DPanelList", CONTENT, CONTENT:GetWide(), CONTENT:GetTall() - YRP.ctr(50 + 20), 0, YRP.ctr(50 + 20))
	vm.win.list:EnableVerticalScrollbar()
	vm.win.list:SetSpacing(YRP.ctr(10))

	local h = YRP.ctr(80)
	local pbr = YRP.ctr(20)
	for i, channel in SortedPairsByMemberValue(GetGlobalTable("yrp_voice_channels", {}), "int_position") do
		if IsInChannel(lply, channel.uniqueID, true) or lply:HasAccess() then
			local line = createD("DPanel", nil, CONTENT:GetWide(), h, 0, 0)
			function line:Paint(pw, ph)
			end

			local bg = createD("DPanel", line, CONTENT:GetWide() - YRP.ctr(26), h, 0, 0)
			function bg:Paint(pw, ph)
				draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, lply:InterfaceValue("YFrame", "PC"))
			end

			local status = createD("DPanel", bg, h, h, 0, 0)
			function status:Paint(pw, ph)
				local color = Color(255, 100, 100, 255)
				if IsActiveInChannel(lply, channel.uniqueID, true) then
					color = Color(100, 255, 100, 255)
				elseif IsInChannel(lply, channel.uniqueID, true) then
					color = Color(100, 100, 255, 255)
				end
				draw.RoundedBox(ph / 2, 0, 0, pw, ph, color)
			end

			if lply:HasAccess() then
				local edit = createD("DButton", bg, h , h, 0, 0)
				edit:SetText("")
				function edit:Paint(pw, ph)
					local br = YRP.ctr(8)
					if YRP.GetDesignIcon("edit") then
						surface.SetMaterial( YRP.GetDesignIcon("edit") )
						surface.SetDrawColor( 255, 255, 255, 255 )
						surface.DrawTexturedRect(br, br, ph - 2 * br, ph - 2 * br)
					end
				end
				function edit:DoClick()
					YRPVoiceChannel(true, channel.uniqueID)
				end
			end

			local name = createD("DPanel", bg, YRP.ctr(800), h, h + pbr, 0)
			function name:Paint(pw, ph)
				draw.SimpleText(channel.string_name, "Y_24_500", 0, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end

			

			if IsActiveInChannel(lply, channel.uniqueID, true) then
				local mutemic = createD("YButton", bg, h, h, bg:GetWide() - h * 2 - YRP.ctr(20), 0)
				mutemic:SetText("")
				function mutemic:Paint(pw, ph)
					local color = colg
					if lply:GetNW2Bool("yrp_voice_channel_mutemic_" .. channel.uniqueID, true) then
						color = colr
					end
					draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, color)

					local br = YRP.ctr(8)
					if YRP.GetDesignIcon("mic") then
						surface.SetMaterial( YRP.GetDesignIcon("mic") )
						surface.SetDrawColor( 255, 255, 255, 255 )
						surface.DrawTexturedRect(br, br, ph - 2 * br, ph - 2 * br)
					end
				end
				function mutemic:DoClick()
					net.Start("mutemic_channel")
						net.WriteString(channel.uniqueID)
					net.SendToServer()
				end
			end

			if IsInChannel(lply, channel.uniqueID, true) then
				local mute = createD("YButton", bg, h, h, bg:GetWide() - h, 0)
				mute:SetText("")
				function mute:Paint(pw, ph)
					local icon = "64_volume-up"
					local color = colg
					if lply:GetNW2Bool("yrp_voice_channel_mute_" .. channel.uniqueID, false) then
						icon = "64_volume-mute"
						color = colr
					end
					draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, color)

					local br = YRP.ctr(8)
					if YRP.GetDesignIcon(icon) then
						surface.SetMaterial(YRP.GetDesignIcon(icon))
						surface.SetDrawColor( 255, 255, 255, 255 )
						surface.DrawTexturedRect(br, br, ph - 2 * br, ph - 2 * br)
					end
				end
				function mute:DoClick()
					net.Start("mute_channel")
						net.WriteString(channel.uniqueID)
					net.SendToServer()
				end
			end

			if lply:HasAccess() then
				local dn = createD("YButton", bg, h, h, bg:GetWide() - 3 * h - 2 * YRP.ctr(20), 0)
				dn:SetText("")
				function dn:Paint(pw, ph)
					if channel.int_position < table.Count(GetGlobalTable("yrp_voice_channels", {})) - 1 then
						local color = lply:InterfaceValue("YButton", "NC")
						draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, color)

						local br = YRP.ctr(8)
						if YRP.GetDesignIcon("64_angle-down") then
							surface.SetMaterial(YRP.GetDesignIcon("64_angle-down"))
							surface.SetDrawColor( 255, 255, 255, 255 )
							surface.DrawTexturedRect(br, br, ph - 2 * br, ph - 2 * br)
						end
					end
				end
				function dn:DoClick()
					CloseVoiceMenu()
					net.Start("channel_dn")
						net.WriteString(channel.uniqueID)
					net.SendToServer()
				end

				local up = createD("YButton", bg, h, h, bg:GetWide() - 4 * h - 3 * YRP.ctr(20), 0)
				up:SetText("")
				function up:Paint(pw, ph)
					if channel.int_position > 0 then
						local color = lply:InterfaceValue("YButton", "NC")
						draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, color)

						local br = YRP.ctr(8)
						if YRP.GetDesignIcon("64_angle-up") then
							surface.SetMaterial(YRP.GetDesignIcon("64_angle-up"))
							surface.SetDrawColor( 255, 255, 255, 255 )
							surface.DrawTexturedRect(br, br, ph - 2 * br, ph - 2 * br)
						end
					end
				end
				function up:DoClick()
					CloseVoiceMenu()
					net.Start("channel_up")
						net.WriteString(channel.uniqueID)
					net.SendToServer()
				end
			end

			vm.win.list:AddItem(line)
		end
	end

	if lply:HasAccess() then
		local size = YRP.ctr(50)
		vm.win.add = createD("YButton", CONTENT, size, size, YRP.ctr(0), CONTENT:GetTall() - YRP.ctr(50))
		vm.win.add:SetText("+")
		function vm.win.add:Paint(pw, ph)
			hook.Run("YButtonAPaint", self, pw, ph)
		end
		function vm.win.add:DoClick()
			YRPVoiceChannel(false)
		end
	end

	local size = YRP.ctr(50)
	vm.win.muteall = createD("YButton", CONTENT, size, size, CONTENT:GetWide() - size, CONTENT:GetTall() - YRP.ctr(50))
	vm.win.muteall:SetText("+")
	function vm.win.muteall:Paint(pw, ph)
		local icon = "64_volume-up"
		local color = colg
		if lply:GetNW2Bool("mute_channel_all", false) then
			icon = "64_volume-mute"
			color = colr
		end
		draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, color)
		
		local br = YRP.ctr(8)
		if YRP.GetDesignIcon(icon) then
			surface.SetMaterial(YRP.GetDesignIcon(icon))
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawTexturedRect(br, br, ph - 2 * br, ph - 2 * br)
		end
	end
	function vm.win.muteall:DoClick()
		net.Start("mute_channel_all")
		net.SendToServer()
	end

	--[[vm.win.mutemicall = createD("YButton", CONTENT, size, size, CONTENT:GetWide() - size - YRP.ctr(10) - size, CONTENT:GetTall() - YRP.ctr(50))
	vm.win.mutemicall:SetText("+")
	function vm.win.mutemicall:Paint(pw, ph)
		local color = colg
		if lply:GetNW2Bool("mutemic_channel_all", false) then
			color = colr
		end
		draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, color)

		local br = YRP.ctr(8)
		if YRP.GetDesignIcon("mic") then
			surface.SetMaterial( YRP.GetDesignIcon("mic") )
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawTexturedRect(br, br, ph - 2 * br, ph - 2 * br)
		end
	end
	function vm.win.mutemicall:DoClick()
		net.Start("mutemic_channel_all")
		net.SendToServer()
	end]]
end

net.Receive("channel_dn", function(len)
	OpenVoiceMenu()
end)

net.Receive("channel_up", function(len)
	OpenVoiceMenu()
end)

function ToggleVoiceMenu()
	if GetGlobalBool("bool_voice", false) then
		if pa(vm.win) then
			surface.PlaySound("npc/metropolice/vo/off2.wav")
			CloseVoiceMenu()
		elseif YRPIsNoMenuOpen() then
			surface.PlaySound("npc/metropolice/vo/on2.wav")
			OpenVoiceMenu()
		end
	end
end

function NextVoiceChannel()
	net.Start("yrp_next_voice_channel")
	net.SendToServer()
end