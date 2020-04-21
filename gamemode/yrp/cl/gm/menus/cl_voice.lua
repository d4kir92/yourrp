--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local vm = {}

function CloseVoiceMenu()
	vm.win:Remove()
end

function OpenVoiceMenu()
	local lply = LocalPlayer()

	vm.win = createD("YFrame", nil, YRP.ctr(1400), YRP.ctr(1000), 0, 0)
	vm.win:Center()
	vm.win:MakePopup()
	vm.win:SetTitle("LID_voicechat")

	local CONTENT = vm.win:GetContent()

	if lply:HasAccess() then
		local size = vm.win:GetHeaderHeight() - 2 * YRP.ctr(4)
		vm.win.add = createD("YButton", vm.win, size, size, CONTENT:GetWide() - YRP.ctr(240), YRP.ctr(4))
		vm.win.add:SetText("+")
		function vm.win.add:Paint(pw, ph)
			hook.Run("YButtonAPaint", self, pw, ph)
		end
		function vm.win.add:DoClick()
			CloseVoiceMenu()

			local name = ""

			local augs = {}
			local agrps = {}
			local arols = {}

			local pugs = {}
			local pgrps = {}
			local prols = {}

			local win = createD("YFrame", nil, YRP.ctr(1600), YRP.ctr(1210), 0, 0)
			win:Center()
			win:MakePopup()
			win:SetTitle("LID_add")

			local CON = win:GetContent()

			-- NAME
			win.nameheader = createD("YLabel", CON, YRP.ctr(760), YRP.ctr(50), YRP.ctr(0), YRP.ctr(0))
			win.nameheader:SetText("LID_name")

			win.name = createD("DTextEntry", CON, YRP.ctr(760), YRP.ctr(50), YRP.ctr(0), YRP.ctr(50))
			function win.name:OnChange()
				name = win.name:GetText()
			end


			-- AKTIVE --
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

					win.augs:AddItem(line)
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

					win.agrps:AddItem(line)
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

					win.arols:AddItem(line)
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

					win.pugs:AddItem(line)
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

					win.pgrps:AddItem(line)
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

					win.prols:AddItem(line)
				end
			end)
			net.Start("yrp_vm_get_passive_roles")
			net.SendToServer()

			win.add = createD("YButton", CON, YRP.ctr(760), YRP.ctr(50), 0, YRP.ctr(1020))
			win.add:SetText("LID_add")
			function win.add:Paint(pw, ph)
				hook.Run("YButtonAPaint", self, pw, ph)
			end
			function win.add:DoClick()
				net.Start("yrp_voice_channel_add")
					net.WriteString(name)

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

	vm.win.list = createD("DPanelList", CONTENT, CONTENT:GetWide(), CONTENT:GetTall(), 0, 0)
	vm.win.list:EnableVerticalScrollbar()
	vm.win.list:SetSpacing(YRP.ctr(10))

	local h = YRP.ctr(60)
	local br = YRP.ctr(20)
	for i, channel in pairs(GetGlobalDTable("yrp_voice_channels", {})) do
		local line = createD("DPanel", nil, CONTENT:GetWide(), h, 0, 0)
		function line:Paint(pw, ph)
			draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, lply:InterfaceValue("YFrame", "PC"))
		end

		local status = createD("DPanel", line, h, h, 0, 0)
		function status:Paint(pw, ph)
			local color = Color(255, 0, 0, 255)
			if IsAktiveInChannel(lply, channel) then
				color = Color(0, 255, 0, 255)
			elseif IsInChannel(lply, channel) then
				color = Color(255, 165, 0, 255)
			end
			draw.RoundedBox(ph / 2, 0, 0, pw, ph, color)
		end

		local status = createD("DButton", line, h , h, 0, 0)
		status:SetText("")
		function status:Paint(pw, ph)
			local br = YRP.ctr(10)
			surface.SetMaterial( YRP.GetDesignIcon("edit") )
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawTexturedRect(br, br, ph - 2 * br, ph - 2 * br)
		end
		function status:DoClick()
			local win = createD("YFrame", nil, YRP.ctr(400), YRP.ctr(200), 0, 0)
			win:Center()
			win:MakePopup()
			win:SetTitle("LID_remove")

			local CON = win:GetContent()

			win.rem = createD("YButton", CON, YRP.ctr(260), YRP.ctr(50), 0, 0)
			win.rem:SetText("LID_remove")
			function win.rem:Paint(pw, ph)
				hook.Run("YButtonRPaint", self, pw, ph)
			end
			function win.rem:DoClick()
				win:Remove()

				line:Remove()

				net.Start("yrp_voice_channel_rem")
					net.WriteString(channel.uniqueID)
				net.SendToServer()
			end
		end

		local name = createD("DPanel", line, YRP.ctr(400), h, h + br, 0)
		function name:Paint(pw, ph)
			draw.SimpleText(channel.string_name, "Y_18_500", 0, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

		if IsInChannel(lply, channel, true) then
			if IsAktiveInChannel(lply, channel, true) then
				local mutemic = createD("YButton", line, h, h, line:GetWide() - h * 2 - YRP.ctr(20 + 34), 0)
				mutemic:SetText("")
				function mutemic:Paint(pw, ph)
					local color = Color(0, 255, 0)
					if lply:GetDBool("yrp_voice_channel_mutemic_" .. channel.uniqueID, false) then
						color = Color(255, 0, 0)
					end
					draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, color)

					local br = YRP.ctr(10)
					surface.SetMaterial( YRP.GetDesignIcon("voice") )
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.DrawTexturedRect(br, br, ph - 2 * br, ph - 2 * br)
				end
				function mutemic:DoClick()
					net.Start("mutemic_channel")
						net.WriteString(channel.uniqueID)
					net.SendToServer()
				end
			end

			local mute = createD("YButton", line, h, h, line:GetWide() - h - YRP.ctr(34), 0)
			mute:SetText("")
			function mute:Paint(pw, ph)
				local color = Color(0, 255, 0)
				if lply:GetDBool("yrp_voice_channel_mute_" .. channel.uniqueID, false) then
					color = Color(255, 0, 0)
				end
				draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, color)

				local br = YRP.ctr(10)
				surface.SetMaterial(YRP.GetDesignIcon("64_volume-up"))
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.DrawTexturedRect(br, br, ph - 2 * br, ph - 2 * br)
			end
			function mute:DoClick()
				net.Start("mute_channel")
					net.WriteString(channel.uniqueID)
				net.SendToServer()
			end
		end
		
		vm.win.list:AddItem(line)
	end
end

function ToggleVoiceMenu()
	if pa(vm.win) then
		CloseVoiceMenu()
	else
		OpenVoiceMenu()
	end
end