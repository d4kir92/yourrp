--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local colr = Color(170, 0, 0)
local colg = Color(0, 200, 0)
local colb = Color(100, 100, 255)
local vm = {}
vm.adminmode = false
function YRPCloseVoiceMenu()
	vm.win:Remove()
end

function YRPVoiceChannel(edit, uid)
	YRPCloseVoiceMenu()
	local name = ""
	local hear = false
	local augs = {}
	local agrps = {}
	local arols = {}
	local pugs = {}
	local pgrps = {}
	local prols = {}
	local win = YRPCreateD("YFrame", nil, YRP.ctr(1600), YRP.ctr(1210), 0, 0)
	function win:Paint(pw, ph)
		YRPDrawRectBlurHUD(5, 0, 0, pw, ph, 255)
	end

	win:Center()
	win:MakePopup()
	if edit then
		win:SetTitle("LID_edit")
	else
		win:SetTitle("LID_add")
	end

	local CON = win:GetContent()
	-- NAME
	win.nameheader = YRPCreateD("YLabel", CON, YRP.ctr(760), YRP.ctr(50), YRP.ctr(0), YRP.ctr(0))
	win.nameheader:SetText("LID_name")
	win.name = YRPCreateD("DTextEntry", CON, YRP.ctr(760), YRP.ctr(50), YRP.ctr(0), YRP.ctr(50))
	function win.name:OnChange()
		name = win.name:GetText()
	end

	if edit and GetGlobalYRPTable("yrp_voice_channels")[uid] then
		name = GetGlobalYRPTable("yrp_voice_channels")[uid].string_name
		win.name:SetText(name)
	end

	-- Defaults
	win.defaultsheader = YRPCreateD("YLabel", CON, YRP.ctr(760), YRP.ctr(50), YRP.ctr(800), YRP.ctr(0))
	win.defaultsheader:SetText(YRP.trans("LID_defaults"))
	win.defaultsbg = YRPCreateD("DPanel", CON, YRP.ctr(760), YRP.ctr(50), YRP.ctr(800), YRP.ctr(50))
	function win.defaultsbg:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(20, 20, 20))
	end

	win.defaults = YRPCreateD("DPanelList", CON, YRP.ctr(760), YRP.ctr(50), YRP.ctr(800), YRP.ctr(50))
	win.defaults:EnableVerticalScrollbar()
	-- Hear?
	local line = YRPCreateD("DPanel", nil, YRP.ctr(40), YRP.ctr(40), 0, 0)
	function line:Paint(pw, ph)
		draw.SimpleText(YRP.trans("LID_hearq"), "Y_14_500", YRP.ctr(40 + 20), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	line.cb = YRPCreateD("DCheckBox", line, YRP.ctr(40), YRP.ctr(40), 0, 0)
	function line.cb:OnChange(bVal)
		hear = bVal
	end

	if edit and GetGlobalYRPTable("yrp_voice_channels")[uid] then
		hear = GetGlobalYRPTable("yrp_voice_channels")[uid].int_hear
		if hear then
			line.cb:SetChecked(hear)
		end
	end

	win.defaults:AddItem(line)
	-- ACTIVE --
	-- USERGROUPS
	win.augsheader = YRPCreateD("YLabel", CON, YRP.ctr(760), YRP.ctr(50), YRP.ctr(0), YRP.ctr(150))
	win.augsheader:SetText("[" .. YRP.trans("LID_active") .. "] " .. YRP.trans("LID_usergroups"))
	win.augsbg = YRPCreateD("DPanel", CON, YRP.ctr(760), YRP.ctr(200), YRP.ctr(0), YRP.ctr(200))
	function win.augsbg:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(20, 20, 20))
	end

	win.augs = YRPCreateD("DPanelList", CON, YRP.ctr(760), YRP.ctr(200), YRP.ctr(0), YRP.ctr(200))
	win.augs:EnableVerticalScrollbar()
	net.Receive(
		"nws_yrp_vm_get_active_usergroups",
		function(len)
			local taugs = net.ReadTable()
			for i, ug in pairs(taugs) do
				local vline = YRPCreateD("DPanel", nil, YRP.ctr(40), YRP.ctr(40), 0, 0)
				function vline:Paint(pw, ph)
					draw.SimpleText(string.upper(ug.string_name), "Y_14_500", YRP.ctr(40 + 20), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end

				vline.cb = YRPCreateD("DCheckBox", vline, YRP.ctr(40), YRP.ctr(40), 0, 0)
				function vline.cb:OnChange(bVal)
					if bVal then
						table.insert(augs, ug.string_name)
					else
						table.RemoveByValue(augs, ug.string_name)
					end
				end

				if edit and GetGlobalYRPTable("yrp_voice_channels")[uid] and GetGlobalYRPTable("yrp_voice_channels")[uid]["string_active_usergroups"][ug.string_name] then
					vline.cb:SetChecked(true)
					table.insert(augs, ug.string_name)
				end

				if YRPPanelAlive(win) and YRPPanelAlive(win.augs) then
					win.augs:AddItem(vline)
				end
			end
		end
	)

	net.Start("nws_yrp_vm_get_active_usergroups")
	net.SendToServer()
	-- GROUPS
	win.agrpsheader = YRPCreateD("YLabel", CON, YRP.ctr(760), YRP.ctr(50), YRP.ctr(0), YRP.ctr(450))
	win.agrpsheader:SetText("[" .. YRP.trans("LID_active") .. "] " .. YRP.trans("LID_groups"))
	win.agrpsbg = YRPCreateD("DPanel", CON, YRP.ctr(760), YRP.ctr(200), YRP.ctr(0), YRP.ctr(500))
	function win.agrpsbg:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(20, 20, 20))
	end

	win.agrps = YRPCreateD("DPanelList", CON, YRP.ctr(760), YRP.ctr(200), YRP.ctr(0), YRP.ctr(500))
	win.agrps:EnableVerticalScrollbar()
	net.Receive(
		"nws_yrp_vm_get_active_groups",
		function(len)
			local tagrps = net.ReadTable()
			for i, ug in pairs(tagrps) do
				local vline = YRPCreateD("DPanel", nil, YRP.ctr(40), YRP.ctr(40), 0, 0)
				function vline:Paint(pw, ph)
					draw.SimpleText(string.upper(ug.string_name), "Y_14_500", YRP.ctr(40 + 20), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end

				vline.cb = YRPCreateD("DCheckBox", vline, YRP.ctr(40), YRP.ctr(40), 0, 0)
				function vline.cb:OnChange(bVal)
					if bVal then
						table.insert(agrps, ug.uniqueID)
					else
						table.RemoveByValue(agrps, ug.uniqueID)
					end
				end

				if edit and GetGlobalYRPTable("yrp_voice_channels")[uid] and GetGlobalYRPTable("yrp_voice_channels")[uid]["string_active_groups"][tonumber(ug.uniqueID)] then
					vline.cb:SetChecked(true)
					table.insert(agrps, ug.uniqueID)
				end

				if YRPPanelAlive(win) and YRPPanelAlive(win.agrps) then
					win.agrps:AddItem(vline)
				end
			end
		end
	)

	net.Start("nws_yrp_vm_get_active_groups")
	net.SendToServer()
	-- ROLES
	win.arolsheader = YRPCreateD("YLabel", CON, YRP.ctr(760), YRP.ctr(50), YRP.ctr(0), YRP.ctr(750))
	win.arolsheader:SetText("[" .. YRP.trans("LID_active") .. "] " .. YRP.trans("LID_roles"))
	win.arolsbg = YRPCreateD("DPanel", CON, YRP.ctr(760), YRP.ctr(200), YRP.ctr(0), YRP.ctr(800))
	function win.arolsbg:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(20, 20, 20))
	end

	win.arols = YRPCreateD("DPanelList", CON, YRP.ctr(760), YRP.ctr(200), YRP.ctr(0), YRP.ctr(800))
	win.arols:EnableVerticalScrollbar()
	net.Receive(
		"nws_yrp_vm_get_active_roles",
		function(len)
			local tarols = net.ReadTable()
			for i, ug in pairs(tarols) do
				local vline = YRPCreateD("DPanel", nil, YRP.ctr(40), YRP.ctr(40), 0, 0)
				function vline:Paint(pw, ph)
					draw.SimpleText(string.upper(ug.string_name), "Y_14_500", YRP.ctr(40 + 20), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end

				vline.cb = YRPCreateD("DCheckBox", vline, YRP.ctr(40), YRP.ctr(40), 0, 0)
				function vline.cb:OnChange(bVal)
					if bVal then
						table.insert(arols, ug.uniqueID)
					else
						table.RemoveByValue(arols, ug.uniqueID)
					end
				end

				if edit and GetGlobalYRPTable("yrp_voice_channels")[uid] and GetGlobalYRPTable("yrp_voice_channels")[uid]["string_active_roles"][tonumber(ug.uniqueID)] then
					vline.cb:SetChecked(true)
					table.insert(arols, ug.uniqueID)
				end

				if YRPPanelAlive(win) and YRPPanelAlive(win.arols) then
					win.arols:AddItem(vline)
				end
			end
		end
	)

	net.Start("nws_yrp_vm_get_active_roles")
	net.SendToServer()
	-- PASSIVE --
	-- USERGROUPS
	win.pugsheader = YRPCreateD("YLabel", CON, YRP.ctr(760), YRP.ctr(50), YRP.ctr(800), YRP.ctr(150))
	win.pugsheader:SetText("[" .. YRP.trans("LID_passive") .. "] " .. YRP.trans("LID_usergroups"))
	win.pugsbg = YRPCreateD("DPanel", CON, YRP.ctr(760), YRP.ctr(200), YRP.ctr(800), YRP.ctr(200))
	function win.pugsbg:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(20, 20, 20))
	end

	win.pugs = YRPCreateD("DPanelList", CON, YRP.ctr(760), YRP.ctr(200), YRP.ctr(800), YRP.ctr(200))
	win.pugs:EnableVerticalScrollbar()
	net.Receive(
		"nws_yrp_vm_get_passive_usergroups",
		function(len)
			local tpugs = net.ReadTable()
			for i, ug in pairs(tpugs) do
				local vline = YRPCreateD("DPanel", nil, YRP.ctr(40), YRP.ctr(40), 0, 0)
				function vline:Paint(pw, ph)
					draw.SimpleText(string.upper(ug.string_name), "Y_14_500", YRP.ctr(40 + 20), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end

				vline.cb = YRPCreateD("DCheckBox", vline, YRP.ctr(40), YRP.ctr(40), 0, 0)
				function vline.cb:OnChange(bVal)
					if bVal then
						table.insert(pugs, ug.string_name)
					else
						table.RemoveByValue(pugs, ug.string_name)
					end
				end

				if edit and GetGlobalYRPTable("yrp_voice_channels")[uid] and GetGlobalYRPTable("yrp_voice_channels")[uid]["string_passive_usergroups"][ug.string_name] then
					vline.cb:SetChecked(true)
					table.insert(pugs, ug.string_name)
				end

				if YRPPanelAlive(win) and YRPPanelAlive(win.pugs) then
					win.pugs:AddItem(vline)
				end
			end
		end
	)

	net.Start("nws_yrp_vm_get_passive_usergroups")
	net.SendToServer()
	-- GROUPS
	win.pgrpsheader = YRPCreateD("YLabel", CON, YRP.ctr(760), YRP.ctr(50), YRP.ctr(800), YRP.ctr(450))
	win.pgrpsheader:SetText("[" .. YRP.trans("LID_passive") .. "] " .. YRP.trans("LID_groups"))
	win.pgrpsbg = YRPCreateD("DPanel", CON, YRP.ctr(760), YRP.ctr(200), YRP.ctr(800), YRP.ctr(500))
	function win.pgrpsbg:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(20, 20, 20))
	end

	win.pgrps = YRPCreateD("DPanelList", CON, YRP.ctr(760), YRP.ctr(200), YRP.ctr(800), YRP.ctr(500))
	win.pgrps:EnableVerticalScrollbar()
	net.Receive(
		"nws_yrp_vm_get_passive_groups",
		function(len)
			local tpgrps = net.ReadTable()
			for i, ug in pairs(tpgrps) do
				local vline = YRPCreateD("DPanel", nil, YRP.ctr(40), YRP.ctr(40), 0, 0)
				function vline:Paint(pw, ph)
					draw.SimpleText(string.upper(ug.string_name), "Y_14_500", YRP.ctr(40 + 20), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end

				vline.cb = YRPCreateD("DCheckBox", vline, YRP.ctr(40), YRP.ctr(40), 0, 0)
				function vline.cb:OnChange(bVal)
					if bVal then
						table.insert(pgrps, ug.uniqueID)
					else
						table.RemoveByValue(pgrps, ug.uniqueID)
					end
				end

				if edit and GetGlobalYRPTable("yrp_voice_channels")[uid] and GetGlobalYRPTable("yrp_voice_channels")[uid]["string_passive_groups"][tonumber(ug.uniqueID)] then
					vline.cb:SetChecked(true)
					table.insert(pgrps, ug.uniqueID)
				end

				if YRPPanelAlive(win) and YRPPanelAlive(win.pgrps) then
					win.pgrps:AddItem(vline)
				end
			end
		end
	)

	net.Start("nws_yrp_vm_get_passive_groups")
	net.SendToServer()
	-- ROLES
	win.prolsheader = YRPCreateD("YLabel", CON, YRP.ctr(760), YRP.ctr(50), YRP.ctr(800), YRP.ctr(750))
	win.prolsheader:SetText("[" .. YRP.trans("LID_passive") .. "] " .. YRP.trans("LID_roles"))
	win.prolsbg = YRPCreateD("DPanel", CON, YRP.ctr(760), YRP.ctr(200), YRP.ctr(800), YRP.ctr(800))
	function win.prolsbg:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(20, 20, 20))
	end

	win.prols = YRPCreateD("DPanelList", CON, YRP.ctr(760), YRP.ctr(200), YRP.ctr(800), YRP.ctr(800))
	win.prols:EnableVerticalScrollbar()
	net.Receive(
		"nws_yrp_vm_get_passive_roles",
		function(len)
			local tprols = net.ReadTable()
			for i, ug in pairs(tprols) do
				local vline = YRPCreateD("DPanel", nil, YRP.ctr(40), YRP.ctr(40), 0, 0)
				function vline:Paint(pw, ph)
					draw.SimpleText(string.upper(ug.string_name), "Y_14_500", YRP.ctr(40 + 20), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end

				vline.cb = YRPCreateD("DCheckBox", vline, YRP.ctr(40), YRP.ctr(40), 0, 0)
				function vline.cb:OnChange(bVal)
					if bVal then
						table.insert(prols, ug.uniqueID)
					else
						table.RemoveByValue(prols, ug.uniqueID)
					end
				end

				if edit and GetGlobalYRPTable("yrp_voice_channels")[uid] and GetGlobalYRPTable("yrp_voice_channels")[uid]["string_passive_roles"][tonumber(ug.uniqueID)] then
					vline.cb:SetChecked(true)
					table.insert(prols, ug.uniqueID)
				end

				if YRPPanelAlive(win) and YRPPanelAlive(win.prols) then
					win.prols:AddItem(vline)
				end
			end
		end
	)

	net.Start("nws_yrp_vm_get_passive_roles")
	net.SendToServer()
	if edit then
		win.save = YRPCreateD("YButton", CON, YRP.ctr(760), YRP.ctr(50), 0, YRP.ctr(1020))
		win.save:SetText("LID_save")
		function win.save:Paint(pw, ph)
			hook.Run("YButtonAPaint", self, pw, ph)
		end

		function win.save:DoClick()
			net.Start("nws_yrp_voice_channel_save")
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
			timer.Simple(
				0.4,
				function()
					YRPOpenVoiceMenu()
				end
			)
		end

		win.rem = YRPCreateD("YButton", CON, YRP.ctr(760), YRP.ctr(50), YRP.ctr(800), YRP.ctr(1020))
		win.rem:SetText("LID_remove")
		function win.rem:Paint(pw, ph)
			hook.Run("YButtonRPaint", self, pw, ph)
		end

		function win.rem:DoClick()
			net.Start("nws_yrp_voice_channel_rem")
			net.WriteString(uid)
			net.SendToServer()
			win:Remove()
			timer.Simple(
				0.4,
				function()
					YRPOpenVoiceMenu()
				end
			)
		end
	else
		win.add = YRPCreateD("YButton", CON, YRP.ctr(760), YRP.ctr(50), 0, YRP.ctr(1020))
		win.add:SetText("LID_add")
		function win.add:Paint(pw, ph)
			hook.Run("YButtonAPaint", self, pw, ph)
		end

		function win.add:DoClick()
			net.Start("nws_yrp_voice_channel_add")
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
			timer.Simple(
				0.4,
				function()
					YRPOpenVoiceMenu()
				end
			)
		end
	end
end

function YRPUpdateVoiceList()
	local lply = LocalPlayer()
	local CONTENT = vm.win:GetContent()
	vm.win.list:Clear()
	if lply:GetYRPBool("yrp_ToggleVoiceMenu", true) then
		local h = YRP.ctr(66)
		local pbr = YRP.ctr(10)
		for i, channel in SortedPairsByMemberValue(GetGlobalYRPTable("yrp_voice_channels", {}), "int_position") do
			if IsInChannel(lply, channel.uniqueID, true) or (vm.adminmode and lply:HasAccess("YRPUpdateVoiceList1")) then
				local line = YRPCreateD("DPanel", nil, CONTENT:GetWide(), h, 0, 0)
				function line:Paint(pw, ph)
				end

				local bg = YRPCreateD("DPanel", line, CONTENT:GetWide() - YRP.ctr(26), h, 0, 0)
				function bg:Paint(pw, ph)
					YRPDrawRectBlurHUD(YRP.ctr(10), 0, 0, pw, ph, 255) --draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, YRPInterfaceValue( "YFrame", "PC" ) )
				end

				local status = YRPCreateD("DPanel", bg, h, h, 0, 0)
				function status:Paint(pw, ph)
					local color = colr
					if IsActiveInChannel(lply, channel.uniqueID, true) then
						color = colg
					elseif IsInChannel(lply, channel.uniqueID, true) then
						color = colb
					end

					draw.RoundedBox(ph / 2, 0, 0, pw, ph, color)
				end

				if vm.adminmode and lply:HasAccess("YRPUpdateVoiceList2") then
					local edit = YRPCreateD("DButton", bg, h, h, 0, 0)
					edit:SetText("")
					function edit:Paint(pw, ph)
						local br = YRP.ctr(8)
						if YRP.GetDesignIcon("edit") then
							surface.SetMaterial(YRP.GetDesignIcon("edit"))
							surface.SetDrawColor(Color(255, 255, 255, 255))
							surface.DrawTexturedRect(br, br, ph - 2 * br, ph - 2 * br)
						end
					end

					function edit:DoClick()
						YRPVoiceChannel(true, channel.uniqueID)
					end
				end

				local name = YRPCreateD("DPanel", bg, YRP.ctr(800), h, h + pbr, 0)
				function name:Paint(pw, ph)
					draw.SimpleText(channel.string_name, "Y_24_500", 0, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end

				if IsActiveInChannel(lply, channel.uniqueID, true) then
					local br = YRP.ctr(8)
					local mutemic = YRPCreateD("YButton", bg, h * 2 + br, h, bg:GetWide() - h * 3 - YRP.ctr(20), 0)
					mutemic:SetText("")
					function mutemic:Paint(pw, ph)
						local color = colg
						if lply:GetYRPBool("yrp_voice_channel_mutemic_" .. channel.uniqueID, true) then
							color = colr
						end

						draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, color)
						local pabr = YRP.ctr(8)
						if YRP.GetDesignIcon("mic") then
							surface.SetMaterial(YRP.GetDesignIcon("mic"))
							surface.SetDrawColor(Color(255, 255, 255, 255))
							surface.DrawTexturedRect(pabr, pabr, ph - 2 * pabr, ph - 2 * pabr)
						end

						draw.SimpleText("+", "Y_24_700", pw / 2, ph / 2 - 1, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						if YRP.GetDesignIcon("volume_up") then
							surface.SetMaterial(YRP.GetDesignIcon("volume_up"))
							surface.SetDrawColor(Color(255, 255, 255, 255))
							surface.DrawTexturedRect(pabr + ph + pabr, pabr, ph - 2 * pabr, ph - 2 * pabr)
						end
					end

					function mutemic:DoClick()
						if not lply:GetYRPBool("yrp_voice_channel_mutemic_" .. channel.uniqueID, false) or (lply:GetYRPBool("yrp_voice_channel_mutemic_" .. channel.uniqueID, false) and lply:GetYRPInt("yrp_voice_channel_active_mic", 0) < GetGlobalYRPInt("int_max_channels_active", 1)) then
							net.Start("nws_yrp_mutemic_channel")
							net.WriteString(channel.uniqueID)
							net.SendToServer()
						end
					end
				end

				if IsInChannel(lply, channel.uniqueID, true) then
					local mute = YRPCreateD("YButton", bg, h, h, bg:GetWide() - h, 0)
					mute:SetText("")
					function mute:Paint(pw, ph)
						local icon = "64_volume-up"
						local color = colg
						if lply:GetYRPBool("yrp_voice_channel_mute_" .. channel.uniqueID, false) then
							icon = "64_volume-mute"
							color = colr
						end

						draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, color)
						local br = YRP.ctr(8)
						if YRP.GetDesignIcon(icon) then
							surface.SetMaterial(YRP.GetDesignIcon(icon))
							surface.SetDrawColor(Color(255, 255, 255, 255))
							surface.DrawTexturedRect(br, br, ph - 2 * br, ph - 2 * br)
						end
					end

					function mute:DoClick()
						if not lply:GetYRPBool("yrp_voice_channel_mute_" .. channel.uniqueID, false) or (lply:GetYRPBool("yrp_voice_channel_mute_" .. channel.uniqueID, false) and lply:GetYRPInt("yrp_voice_channel_passive_voice", 0) < GetGlobalYRPInt("int_max_channels_passive", 3)) then
							net.Start("nws_yrp_mute_channel")
							net.WriteString(channel.uniqueID)
							net.SendToServer()
						end
					end
				end

				if vm.adminmode and lply:HasAccess("YRPUpdateVoiceList3") then
					local dn = YRPCreateD("YButton", bg, h, h, bg:GetWide() - 4 * h - 2 * YRP.ctr(20), 0)
					dn:SetText("")
					function dn:Paint(pw, ph)
						if channel.int_position < table.Count(GetGlobalYRPTable("yrp_voice_channels", {})) - 1 then
							local color = YRPInterfaceValue("YButton", "NC")
							draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, color)
							local br = YRP.ctr(8)
							if YRP.GetDesignIcon("64_angle-down") then
								surface.SetMaterial(YRP.GetDesignIcon("64_angle-down"))
								surface.SetDrawColor(Color(255, 255, 255, 255))
								surface.DrawTexturedRect(br, br, ph - 2 * br, ph - 2 * br)
							end
						end
					end

					function dn:DoClick()
						YRPCloseVoiceMenu()
						net.Start("nws_yrp_channel_dn")
						net.WriteString(channel.uniqueID)
						net.SendToServer()
					end

					local up = YRPCreateD("YButton", bg, h, h, bg:GetWide() - 5 * h - 3 * YRP.ctr(20), 0)
					up:SetText("")
					function up:Paint(pw, ph)
						if channel.int_position > 0 then
							local color = YRPInterfaceValue("YButton", "NC")
							draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, color)
							local br = YRP.ctr(8)
							if YRP.GetDesignIcon("64_angle-up") then
								surface.SetMaterial(YRP.GetDesignIcon("64_angle-up"))
								surface.SetDrawColor(Color(255, 255, 255, 255))
								surface.DrawTexturedRect(br, br, ph - 2 * br, ph - 2 * br)
							end
						end
					end

					function up:DoClick()
						YRPCloseVoiceMenu()
						net.Start("nws_yrp_channel_up")
						net.WriteString(channel.uniqueID)
						net.SendToServer()
					end
				end

				vm.win.list:AddItem(line)
			end
		end
	end
end

function YRPOpenVoiceMenu()
	local lply = LocalPlayer()
	vm.win = YRPCreateD("YFrame", nil, YRP.ctr(1200), YRP.ctr(1400), 0, 0)
	function vm.win:Paint(pw, ph)
		YRPDrawRectBlurHUD(5, 0, 0, pw, ph, 255)
		if self.toggle ~= lply:GetYRPBool("yrp_ToggleVoiceMenu", true) then
			self.toggle = lply:GetYRPBool("yrp_ToggleVoiceMenu", true)
			YRPUpdateVoiceList()
		end

		if not self.toggle then
			draw.SimpleText(string.Replace(YRP.trans("LID_presskeytoenablevoicemenu"), "KEY", YRPGetKeybindName("voice_menu")), "Y_30_500", pw / 2, ph / 2, YRPInterfaceValue("YFrame", "HT"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local hh = 24
		if self.GetHeaderHeight ~= nil then
			hh = self:GetHeaderHeight()
		end

		draw.SimpleText(YRP.trans(self:GetTitle()), "Y_18_500", hh / 2, hh / 2, YRPInterfaceValue("YFrame", "HT"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	vm.win:SetLanguageChanger(false)
	vm.win:Center()
	vm.win:MakePopup()
	vm.win:SetTitle("LID_voicechat")
	local CONTENT = vm.win:GetContent()
	-- HEADER
	vm.win.listheader = YRPCreateD("DPanel", CONTENT, CONTENT:GetWide(), YRP.ctr(50 + 20), 0, 0)
	function vm.win.listheader:Paint(pw, ph)
		if lply:GetYRPBool("yrp_ToggleVoiceMenu", true) then
			draw.SimpleText(YRP.trans("LID_name"), "Y_20_500", YRP.ctr(80), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(lply:GetYRPInt("yrp_voice_channel_active_mic", 0) .. "/" .. GetGlobalYRPInt("int_max_channels_active", 1), "Y_20_500", YRP.ctr(990), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(lply:GetYRPInt("yrp_voice_channel_passive_voice", 0) .. "/" .. GetGlobalYRPInt("int_max_channels_passive", 3), "Y_20_500", YRP.ctr(1100), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	-- LIST
	vm.win.list = YRPCreateD("DPanelList", CONTENT, CONTENT:GetWide(), CONTENT:GetTall() - YRP.ctr(40 + 20 + 50 + 20), 0, YRP.ctr(50 + 20))
	vm.win.list:EnableVerticalScrollbar()
	vm.win.list:SetSpacing(YRP.ctr(10))
	local sbar = vm.win.list.VBar
	function sbar:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, YRPInterfaceValue("YFrame", "NC"))
	end

	function sbar.btnUp:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
	end

	function sbar.btnDown:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
	end

	function sbar.btnGrip:Paint(w, h)
		draw.RoundedBox(w / 2, 0, 0, w, h, YRPInterfaceValue("YFrame", "HI"))
	end

	YRPUpdateVoiceList()
	if lply:HasAccess("YRPOpenVoiceMenu1") then
		local size = YRP.ctr(50)
		-- ADMIN MODE
		vm.win.showall = YRPCreateD("DCheckBox", CONTENT, size, size, YRP.ctr(0), CONTENT:GetTall() - YRP.ctr(50))
		vm.win.showall:SetChecked(vm.adminmode)
		function vm.win.showall:OnChange()
			vm.adminmode = not vm.adminmode
			if vm.win.maxactive and vm.win.maxpassive then
				if vm.adminmode then
					vm.win.maxactive:Show()
					vm.win.maxpassive:Show()
					vm.win.add:Show()
				else
					vm.win.maxactive:Hide()
					vm.win.maxpassive:Hide()
					vm.win.add:Hide()
				end
			end

			YRPUpdateVoiceList()
		end

		vm.win.add = YRPCreateD("YButton", CONTENT, size, size, YRP.ctr(260), CONTENT:GetTall() - YRP.ctr(50))
		vm.win.add:SetText("+")
		function vm.win.add:Paint(pw, ph)
			hook.Run("YButtonAPaint", self, pw, ph)
		end

		function vm.win.add:DoClick()
			YRPVoiceChannel(false)
		end

		if not vm.adminmode or not lply:HasAccess("YRPOpenVoiceMenu2") then
			vm.win.add:Hide()
		end

		vm.win.showalllabel = YRPCreateD("DLabel", CONTENT, YRP.ctr(200), size, YRP.ctr(40 + 20), CONTENT:GetTall() - YRP.ctr(50))
		vm.win.showalllabel:SetText("")
		function vm.win.showalllabel:Paint(pw, ph)
			draw.SimpleText(YRP.trans("LID_adminmode"), "Y_16_700", 0, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

		-- MAX ACTIVE
		vm.win.maxactive = YRPCreateD("DNumSlider", CONTENT, YRP.ctr(380), size, YRP.ctr(40 + 20 + 40 + 20 + 200 + 20), CONTENT:GetTall() - YRP.ctr(50))
		vm.win.maxactive:SetText(YRP.trans("LID_maxactive"))
		vm.win.maxactive:SetDecimals(0)
		vm.win.maxactive:SetMinMax(0, 10)
		vm.win.maxactive:SetValue(GetGlobalYRPInt("int_max_channels_active", 1))
		function vm.win.maxactive:OnValueChanged(value)
			net.Start("nws_yrp_voice_set_max_active")
			net.WriteString(math.floor(value, self:GetDecimals()))
			net.SendToServer()
		end

		-- MAX Passive
		vm.win.maxpassive = YRPCreateD("DNumSlider", CONTENT, YRP.ctr(380), size, YRP.ctr(40 + 20 + 40 + 20 + 200 + 20 + 350 + 20), CONTENT:GetTall() - YRP.ctr(50))
		vm.win.maxpassive:SetText(YRP.trans("LID_maxpassive"))
		vm.win.maxpassive:SetDecimals(0)
		vm.win.maxpassive:SetMinMax(0, 10)
		vm.win.maxpassive:SetValue(GetGlobalYRPInt("int_max_channels_passive", 3))
		function vm.win.maxpassive:OnValueChanged(value)
			net.Start("nws_yrp_voice_set_max_passive")
			net.WriteString(math.floor(value, self:GetDecimals()))
			net.SendToServer()
		end

		if not vm.adminmode or not lply:HasAccess("YRPOpenVoiceMenu3") then
			vm.win.maxactive:Hide()
			vm.win.maxpassive:Hide()
		end
	end

	local size = YRP.ctr(50)
	vm.win.muteall = YRPCreateD("YButton", CONTENT, size, size, CONTENT:GetWide() - size, CONTENT:GetTall() - YRP.ctr(50))
	vm.win.muteall:SetText("+")
	function vm.win.muteall:Paint(pw, ph)
		local icon = "64_volume-up"
		local color = colg
		if lply:GetYRPBool("mute_channel_all", false) then
			icon = "64_volume-mute"
			color = colr
		end

		draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, color)
		local br = YRP.ctr(8)
		if YRP.GetDesignIcon(icon) then
			surface.SetMaterial(YRP.GetDesignIcon(icon))
			surface.SetDrawColor(Color(255, 255, 255, 255))
			surface.DrawTexturedRect(br, br, ph - 2 * br, ph - 2 * br)
		end
	end

	function vm.win.muteall:DoClick()
		net.Start("nws_yrp_mute_channel_all")
		net.SendToServer()
	end
end

net.Receive(
	"nws_yrp_channel_dn",
	function(len)
		YRPOpenVoiceMenu()
	end
)

net.Receive(
	"nws_yrp_channel_up",
	function(len)
		YRPOpenVoiceMenu()
	end
)

function YRPToggleVoiceMenu()
	if GetGlobalYRPBool("bool_voice", false) then
		if YRPPanelAlive(vm.win) then
			surface.PlaySound("npc/metropolice/vo/off2.wav")
			YRPCloseVoiceMenu()
		elseif YRPIsNoMenuOpen() then
			surface.PlaySound("npc/metropolice/vo/on2.wav")
			YRPOpenVoiceMenu()
		end
	end
end

function NextVoiceChannel()
	net.Start("nws_yrp_next_voice_channel")
	net.SendToServer()
end