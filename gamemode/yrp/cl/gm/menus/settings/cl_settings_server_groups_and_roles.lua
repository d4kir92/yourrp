--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

net.Receive("Subscribe_Settings_GroupsAndRoles", function(len)
	if pa(settingsWindow) then
		function settingsWindow.window.site:Paint(pw, ph)
			draw.RoundedBox(4, 0, 0, pw, ph, Color(0, 0, 0, 254))
		end

		local PARENT = settingsWindow.window.site

		local cur_group = {}
		cur_group.cur = 0
		cur_group.par = 0
		cur_group.edi = 0

		local cur_role = {}
		cur_role.cur = 0
		cur_role.par = 0
		cur_role.edi = 0

		function PARENT:OnRemove()
			net.Start("Unsubscribe_Settings_GroupsAndRoles")
				net.WriteString(cur_group.cur)
			net.SendToServer()
		end

		PARENT.gs = {}
		local gs = PARENT.gs

		PARENT.rs = {}
		local rs = PARENT.rs

		gs.bac = createD("DButton", PARENT, ctr(60), ctr(60), ctr(20), ctr(20))
		gs.bac:SetText("")
		function gs.bac:Paint(pw, ph)
			if cur_group.cur == cur_group.par then
				local tab = {}
				tab.color = YRPGetColor("3")
				DrawPanel(self, tab)
			else
				local tab = {}
				tab.color = Color(255, 255, 0)
				DrawPanel(self, tab)
				local tab2 = {}
				tab2.x = pw / 2
				tab2.y = ph / 2
				tab2.ax = 1
				tab2.ay = 1
				tab2.text = "◀"
				tab2.font = "mat1text"
				DrawText(tab2)
			end
		end
		function gs.bac:DoClick()
			if cur_group.cur != cur_group.par then
				gs.gplist:ClearList()
				net.Start("settings_unsubscribe_grouplist")
					net.WriteString(cur_group.cur)
				net.SendToServer()
				net.Start("settings_subscribe_grouplist")
					net.WriteString(cur_group.par)
				net.SendToServer()
			end
		end

		gs.top = createD("DPanel", PARENT, ctr(800-120), ctr(60), ctr(80), ctr(20))
		function gs.top:Paint(pw, ph)
			local tab = {}
			tab.color = YRPGetColor("3")
			DrawPanel(self, tab)
			local tab2 = {}
			tab2.x = pw / 2
			tab2.y = ph / 2
			tab2.ax = 1
			tab2.ay = 1
			tab2.font = "mat1text"
			if self.group != nil then
				if self.group != "" then
					local inp = {}
					inp.group = self.group
					tab2.text = lang_string("groupsof", inp)
				else
					tab2.text = lang_string("maingroups")
				end
			else
				tab2.text = lang_string("loading")
			end
			DrawText(tab2)
		end

		gs.add = createD("DButton", PARENT, ctr(60), ctr(60), ctr(20 + 800 - 60), ctr(20))
		gs.add:SetText("")
		function gs.add:Paint(pw, ph)
			local tab = {}
			tab.color = Color(0, 255, 0)
			DrawPanel(self, tab)
			local tab2 = {}
			tab2.x = pw / 2
			tab2.y = ph / 2
			tab2.ax = 1
			tab2.ay = 1
			tab2.text = "+"
			tab2.font = "mat1text"
			DrawText(tab2)
		end
		function gs.add:DoClick()
			net.Start("settings_add_group")
				net.WriteString(cur_group.cur)
			net.SendToServer()
		end

		gs.glist = createD("DPanel", PARENT, ctr(800), ctr(940), ctr(20), ctr(80))
		gs.gplist = createD("DPanelList", gs.glist, gs.glist:GetWide(), gs.glist:GetTall(), 0, 0)
		gs.gplist:EnableVerticalScrollbar(true)
		gs.gplist:SetSpacing(ctr(10))
		function gs.gplist:ClearList()
			gs.top.group = nil
			gs.gplist:Clear()
		end

		net.Receive("settings_group_update_name", function(le)
			if pa(gs) then
				local _uid = tonumber(net.ReadString())
				local name = net.ReadString()
				gs.gplist[_uid].text = name
			end
		end)

		net.Receive("settings_group_update_color", function(le)
			if pa(gs) then
				local _uid = tonumber(net.ReadString())
				local color = net.ReadString()
				gs.gplist[_uid].string_color = stc(color)
			end
		end)

		net.Receive("settings_group_update_icon", function(le)
			if pa(gs.gplist) then
				local _uid = tonumber(net.ReadString())
				local icon = net.ReadString()
				gs.gplist[_uid].string_icon = icon
				gs.gplist[_uid].ico:SetHTML( GetHTMLImage( gs.gplist[_uid].string_icon, gs.gplist[_uid].ico:GetWide(), gs.gplist[_uid].ico:GetTall() ) )
			end
		end)

		function CreateLineGroup(parent, group)
			group.uniqueID = tonumber(group.uniqueID)
			gs.gplist[group.uniqueID] = gs.gplist[group.uniqueID] or {}
			gs.gplist[group.uniqueID] = createD("DButton", parent, parent:GetWide() - ctr(20), ctr(120), 0, 0)
			gs.gplist[group.uniqueID]:SetText("")
			for i, e in pairs(group) do
				if string.StartWith(i, "int_") then
					gs.gplist[group.uniqueID][i] = tonumber(e)
				elseif string.StartWith(i, "string_color") then
					gs.gplist[group.uniqueID][i] = stc(e)
				else
					gs.gplist[group.uniqueID][i] = e
				end
			end
			local pnl = gs.gplist[group.uniqueID]
			function pnl:Paint(pw, ph)
				local tab = {}
				tab.color = gs.gplist[group.uniqueID]["string_color"]
				DrawPanel(self, tab)

				self.text = self.text or group.string_name .. " [UID: " .. group.uniqueID .. "]"
				local tab2 = {}
				tab2.x = ctr(182)
				tab2.y = ctr(20)
				tab2.ax = 0
				tab2.ay = 0
				tab2.text = self.text
				tab2.font = "mat1text"
				tab2.lforce = false
				DrawText(tab2)

				--[[local tab3 = {}
				tab3.x = ctr(182)
				tab3.y = ctr(100)
				tab3.ax = 0
				tab3.ay = 4
				tab3.text = "POSITION: " .. group.int_position
				tab3.font = "mat1text"
				DrawText(tab3)]]
			end
			function pnl:DoClick()
				net.Start("settings_subscribe_group")
					net.WriteString(group.uniqueID)
				net.SendToServer()
			end

			gs.gplist[group.uniqueID].ico = createD("DHTML", gs.gplist[group.uniqueID], gs.gplist[group.uniqueID]:GetTall() - ctr(20), gs.gplist[group.uniqueID]:GetTall() - ctr(20), ctr(60), ctr(10))
			local ico = gs.gplist[group.uniqueID].ico
			function ico:Paint(pw, ph)
			end
			ico:SetHTML( GetHTMLImage( group.string_icon, ico:GetWide(), ico:GetTall() ) )

			gs.gplist[group.uniqueID].up = createD("DButton", gs.gplist[group.uniqueID], ctr(40), gs.gplist[group.uniqueID]:GetTall() / 2 - ctr(15), ctr(10), ctr(10))
			gs.gplist[group.uniqueID].up:SetText("")
			local up = gs.gplist[group.uniqueID].up
			function up:Paint(pw, ph)
				if gs.gplist[group.uniqueID].int_position > 1 then
					local tab = {}
					tab.color = Color(255, 255, 0)
					DrawPanel(self, tab)
					local tab2 = {}
					tab2.x = pw / 2
					tab2.y = ph / 2
					tab2.ax = 1
					tab2.ay = 1
					tab2.text = "▲"
					tab2.font = "mat1text"
					DrawText(tab2)
				end
			end
			function up:DoClick()
				net.Start("settings_group_position_up")
					net.WriteString(gs.gplist[group.uniqueID].uniqueID)
				net.SendToServer()
			end

			gs.gplist[group.uniqueID].dn = createD("DButton", gs.gplist[group.uniqueID], ctr(40), gs.gplist[group.uniqueID]:GetTall() / 2 - ctr(15), ctr(10), gs.gplist[group.uniqueID]:GetTall() / 2 + ctr(5))
			gs.gplist[group.uniqueID].dn:SetText("")
			local dn = gs.gplist[group.uniqueID].dn
			function dn:Paint(pw, ph)
				if gs.gplist[group.uniqueID].int_position < table.Count(gs.gplist.tab) then
					local tab = {}
					tab.color = Color(255, 255, 0)
					DrawPanel(self, tab)
					local tab2 = {}
					tab2.x = pw / 2
					tab2.y = ph / 2
					tab2.ax = 1
					tab2.ay = 1
					tab2.text = "▼"
					tab2.font = "mat1text"
					DrawText(tab2)
				end
			end
			function dn:DoClick()
				net.Start("settings_group_position_dn")
					net.WriteString(gs.gplist[group.uniqueID].uniqueID)
				net.SendToServer()
			end

			gs.gplist[group.uniqueID].ch = createD("DButton", gs.gplist[group.uniqueID], ctr(40), ctr(40), gs.gplist[group.uniqueID]:GetWide() - ctr(66), gs.gplist[group.uniqueID]:GetTall() - ctr(60))
			gs.gplist[group.uniqueID].ch:SetText("")
			local ch = gs.gplist[group.uniqueID].ch
			function ch:Paint(pw, ph)
				local tab = {}
				tab.color = Color(255, 255, 0)
				DrawPanel(self, tab)
				local tab2 = {}
				tab2.x = pw / 2
				tab2.y = ph / 2
				tab2.ax = 1
				tab2.ay = 1
				tab2.text = "▶"
				tab2.font = "mat1text"
				DrawText(tab2)
			end
			function ch:DoClick()
				gs.gplist:ClearList()
				net.Start("settings_unsubscribe_grouplist")
					net.WriteString(cur_group.cur)
				net.SendToServer()
				timer.Simple(0.1, function()
					net.Start("settings_subscribe_grouplist")
						net.WriteString(gs.gplist[group.uniqueID].uniqueID)
					net.SendToServer()
				end)
			end

			parent:AddItem(gs.gplist[group.uniqueID])
		end
		net.Receive("settings_subscribe_grouplist", function(le)
			if pa(gs.gplist) then
				gs.gplist:ClearList()

				local parentgroup = net.ReadTable()

				if parentgroup.uniqueID != nil then
					gs.top.group = parentgroup.string_name
				else
					gs.top.group = ""
				end

				local groups = net.ReadTable()

				cur_group.cur = tonumber(net.ReadString())
				cur_group.par = tonumber(net.ReadString())
				gs.gplist.tab = groups
				for i, group in pairs(groups) do
					CreateLineGroup(gs.gplist, group)
					group["int_position"] = tonumber(group["int_position"])
				end

				gs.gplist:SortByMember("int_position", true)
				gs.gplist:Rebuild()
			end
		end)

		net.Start("settings_subscribe_grouplist")
			net.WriteString(cur_group.par)
		net.SendToServer()

		--[[
		rs.top = createD("DPanel", PARENT, ctr(800), ctr(60), ctr(20), ctr(1040))
		function rs.top:Paint(pw, ph)
			if rs.top.group != nil then
				local tab = {}
				tab.color = YRPGetColor("3")
				DrawPanel(self, tab)
				local tab2 = {}
				tab2.x = pw / 2
				tab2.y = ph / 2
				tab2.ax = 1
				tab2.ay = 1
				tab2.font = "mat1text"
				if self.group != nil then
					if self.group != "" then
						local inp = {}
						inp.group = self.group
						tab2.text = "[" .. lang_string("wip") .. "] " .. lang_string("rolesof", inp)
					end
				else
					tab2.text = lang_string("loading")
				end
				DrawText(tab2)
			end
		end

		rs.add = createD("DButton", PARENT, ctr(60), ctr(60), ctr(20 + 800 - 60), ctr(1040))
		rs.add:SetText("")
		function rs.add:Paint(pw, ph)
			if rs.top.group != nil then
				local tab = {}
				tab.color = Color(0, 255, 0)
				DrawPanel(self, tab)
				local tab2 = {}
				tab2.x = pw / 2
				tab2.y = ph / 2
				tab2.ax = 1
				tab2.ay = 1
				tab2.text = "+"
				tab2.font = "mat1text"
				DrawText(tab2)
			end
		end
		function rs.add:DoClick()
			if rs.top.group != nil then
				net.Start("settings_add_role")
					net.WriteString(cur_role.cur)
				net.SendToServer()
			end
		end

		rs.rlist = createD("DPanel", PARENT, ctr(800), ctr(940), ctr(20), ctr(1100))
		function rs.rlist:Paint(pw, ph)
			if rs.top.group != nil then
				local tab = {}
				tab.color = Color(255, 255, 255)
				DrawPanel(self, tab)
			end
		end
		rs.rplist = createD("DPanelList", rs.rlist, rs.rlist:GetWide(), rs.rlist:GetTall(), 0, 0)
		rs.rplist:EnableVerticalScrollbar(true)
		rs.rplist:SetSpacing(ctr(10))
		function rs.rplist:ClearList()
			rs.top.group = nil
			rs.rplist:Clear()
		end
		]]--

		PARENT.ea = {}
		local ea = PARENT.ea

		ea.background = createD("DPanel", PARENT, ScrW() - ctr(860), ScrH() - ctr(200), ctr(840), ctr(80))
		function ea.background:Paint(pw, ph)
			if ea.typ != nil then
				local tab = {}
				tab.color = YRPGetColor("4")
				DrawPanel(self, tab)
			end
		end

		ea.del = createD("DButton", PARENT, ctr(60), ctr(60), ctr(840), ctr(20))
		ea.del:SetText("")
		function ea.del:Paint(pw, ph)
			if ea.typ != nil and tobool(ea.tab.bool_removeable) then
				local tab = {}
				tab.color = Color(255, 0, 0, 255)
				DrawPanel(self, tab)

				local tab2 = {}
				tab2.w = pw
				tab2.h = ph
				tab2.x = ctr(20)
				tab2.y = ph / 2
				tab2.ax = 0
				tab2.text = "-"
				tab2.font = "mat1text"
				DrawText(tab2)
			elseif ea.typ != nil then
				local tab = {}
				tab.color = YRPGetColor("3")
				DrawPanel(self, tab)
			end
		end
		function ea.del:DoClick()
			if ea.typ == "group" and tobool(ea.tab.bool_removeable) then
				net.Start("settings_delete_group")
					net.WriteString(ea.tab.uniqueID)
				net.SendToServer()
				for i, pnl in pairs(ea.background:GetChildren()) do
					pnl:Remove()
				end
				ea.typ = nil
				ea.tab = nil
			end
		end

		ea.dup = createD("DButton", PARENT, ctr(60), ctr(60), ctr(900), ctr(20))
		ea.dup:SetText("")
		function ea.dup:Paint(pw, ph)
			if ea.typ != nil and false then
				local tab = {}
				tab.color = Color(255, 255, 0, 255)
				DrawPanel(self, tab)

				local tab2 = {}
				tab2.w = pw
				tab2.h = ph
				tab2.x = ctr(20)
				tab2.y = ph / 2
				tab2.ax = 0
				tab2.text = "[ ]"
				tab2.font = "mat1text"
				DrawText(tab2)
			elseif ea.typ != nil then
				local tab = {}
				tab.color = YRPGetColor("3")
				DrawPanel(self, tab)
			end
		end

		ea.top = createD("DPanel", PARENT, ScrW() - ctr(980), ctr(60), ctr(960), ctr(20))
		function ea.top:Paint(pw, ph)
			if ea.typ != nil then
				local tab = {}
				tab.color = YRPGetColor("3")
				DrawPanel(self, tab)

				local tab2 = {}
				tab2.w = pw
				tab2.h = ph
				tab2.x = ctr(20)
				tab2.y = ph / 2
				tab2.ax = 0
				tab2.text = lang_string(ea.typ) .. ": " .. tostring(ea.tab.string_name)
				tab2.font = "mat1text"
				DrawText(tab2)
			end
		end

		net.Receive("settings_subscribe_group", function(le)
			local group = net.ReadTable()
			local groups = net.ReadTable()
			local db_ugs = net.ReadTable()

			net.Start("settings_subscribe_rolelist")
				net.WriteString(group.uniqueID)
			net.SendToServer()

			group.uniqueID = tonumber(group.uniqueID)
			cur_group.edi = group.uniqueID

			ea.typ = "group"
			ea.tab = group

			for i, pnl in pairs(ea.background:GetChildren()) do
				pnl:Remove()
			end

			ea[group.uniqueID] = ea[group.uniqueID] or {}

			local info = {}
			info.parent = ea.background
			info.x = ctr(20)
			info.y = ctr(20)
			info.w = ctr(1000)
			info.h = ctr(530)
			info.br = ctr(20)
			info.color = Color( 255, 255, 255 )
			info.bgcolor = Color( 80, 80, 80 )
			info.name = "general"
			ea[group.uniqueID].info = DGroup(info)
			ea.info = ea[group.uniqueID].info
			function ea.info:OnRemove()
				if cur_group.edi != group.uniqueID then
					net.Start("settings_unsubscribe_group")
						net.WriteString(group.uniqueID)
					net.SendToServer()
				end
			end

			local name = {}
			name.parent = ea.info
			name.uniqueID = group.uniqueID
			name.header = "name"
			name.netstr = "update_group_string_name"
			name.value = group.string_name
			name.uniqueID = group.uniqueID
			name.lforce = false
			ea[group.uniqueID].name = DTextBox(name)

			local hr = {}
			hr.h = ctr(20)
			hr.parent = ea.info
			DHr(hr)

			local color = {}
			color.parent = ea.info
			color.uniqueID = group.uniqueID
			color.header = "color"
			color.netstr = "update_group_string_color"
			color.value = group.string_color
			color.uniqueID = group.uniqueID
			color.lforce = false
			ea[group.uniqueID].color = DColor(color)

			DHr(hr)

			local icon = {}
			icon.parent = ea.info
			icon.uniqueID = group.uniqueID
			icon.header = "icon"
			icon.netstr = "update_group_string_icon"
			icon.value = group.string_icon
			icon.uniqueID = group.uniqueID
			icon.lforce = false
			ea[group.uniqueID].icon = DTextBox(icon)

			DHr(hr)

			local othergroups = {}
			othergroups[0] = lang_string("maingroup")
			for i, tab in pairs(groups) do
				othergroups[tab.uniqueID] = tab.string_name .. " [UID: " .. tab.uniqueID .. "]"
			end

			local parentgroup = {}
			parentgroup.parent = ea.info
			parentgroup.uniqueID = group.uniqueID
			parentgroup.header = "parentgroup"
			parentgroup.netstr = "update_group_int_parentgroup"
			parentgroup.value = group.int_parentgroup
			parentgroup.uniqueID = group.uniqueID
			parentgroup.lforce = false
			parentgroup.choices = othergroups
			ea[group.uniqueID].parentgroup = DComboBox(parentgroup)

			local restriction = {}
			restriction.parent = ea.background
			restriction.x = ctr(1040)
			restriction.y = ctr(20)
			restriction.w = ctr(1000)
			restriction.h = ctr(570)
			restriction.br = ctr(20)
			restriction.color = Color( 255, 255, 255 )
			restriction.bgcolor = Color( 80, 80, 80 )
			restriction.name = "restriction"
			ea[group.uniqueID].restriction = DGroup(restriction)
			ea.restriction = ea[group.uniqueID].restriction

			local gugs = string.Explode(",", group.string_usergroups)

			local ugs = {}
			ugs["ALL"] = {}
			ugs["ALL"].checked = table.HasValue(gugs, "ALL")
			ugs["ALL"]["choices"] = {}
			for i, pl in pairs(player.GetAll()) do
				ugs["ALL"]["choices"][string.upper(pl:GetUserGroup())] = ugs["ALL"]["choices"][string.upper(pl:GetUserGroup())] or {}
				ugs["ALL"]["choices"][string.upper(pl:GetUserGroup())].checked = table.HasValue(gugs, string.upper(pl:GetUserGroup()))
			end

			for i, ug in pairs(db_ugs) do
				ugs["ALL"]["choices"][string.upper(ug.name)] = ugs["ALL"]["choices"][string.upper(ug.name)] or {}
				ugs["ALL"]["choices"][string.upper(ug.name)].checked = table.HasValue(gugs, string.upper(ug.name))
			end

			local usergroups = {}
			usergroups.parent = ea.restriction
			usergroups.uniqueID = group.uniqueID
			usergroups.header = "usergroups"
			usergroups.netstr = "update_group_string_usergroups"
			usergroups.value = group.string_usergroups
			usergroups.uniqueID = group.uniqueID
			usergroups.lforce = false
			usergroups.choices = ugs
			ea[group.uniqueID].usergroups = DCheckBoxes(usergroups)

			hr.parent = ea.restriction
			DHr(hr)

			local requireslevel = {}
			requireslevel.parent = ea.restriction
			requireslevel.uniqueID = group.uniqueID
			requireslevel.header = "requireslevel"
			requireslevel.netstr = "update_group_int_requireslevel"
			requireslevel.value = group.int_requireslevel
			requireslevel.uniqueID = group.uniqueID
			requireslevel.lforce = false
			requireslevel.min = 1
			requireslevel.max = 100
			ea[group.uniqueID].requireslevel = DIntBox(requireslevel)

			DHr(hr)

			local groupvoicechat = {}
			groupvoicechat.parent = ea.restriction
			groupvoicechat.uniqueID = group.uniqueID
			groupvoicechat.header = "canusegroupvoicechat"
			groupvoicechat.netstr = "update_group_bool_groupvoicechat"
			groupvoicechat.value = group.bool_groupvoicechat
			groupvoicechat.uniqueID = group.uniqueID
			groupvoicechat.lforce = false
			ea[group.uniqueID].groupvoicechat = DCheckBox(groupvoicechat)

			DHr(hr)

			local whitelist = {}
			whitelist.parent = ea.restriction
			whitelist.uniqueID = group.uniqueID
			whitelist.header = "useswhitelist"
			whitelist.netstr = "update_group_bool_whitelist"
			whitelist.value = group.bool_whitelist
			whitelist.uniqueID = group.uniqueID
			whitelist.lforce = false
			ea[group.uniqueID].whitelist = DCheckBox(whitelist)

			DHr(hr)

			local locked = {}
			locked.parent = ea.restriction
			locked.uniqueID = group.uniqueID
			locked.header = "locked"
			locked.netstr = "update_group_bool_locked"
			locked.value = group.bool_locked
			locked.uniqueID = group.uniqueID
			locked.lforce = false
			ea[group.uniqueID].locked = DCheckBox(locked)

			DHr(hr)

			local visible = {}
			visible.parent = ea.restriction
			visible.uniqueID = group.uniqueID
			visible.header = "visible"
			visible.netstr = "update_group_bool_visible"
			visible.value = group.bool_visible
			visible.uniqueID = group.uniqueID
			visible.lforce = false
			ea[group.uniqueID].visible = DCheckBox(visible)
		end)

		function CreateLineRole(parent, role)
			role.uniqueID = tonumber(role.uniqueID)
			rs.rplist[role.uniqueID] = rs.rplist[role.uniqueID] or {}
			rs.rplist[role.uniqueID] = createD("DButton", parent, parent:GetWide() - ctr(20), ctr(120), 0, 0)
			rs.rplist[role.uniqueID]:SetText("")
			for i, e in pairs(role) do
				if string.StartWith(i, "int_") then
					rs.rplist[role.uniqueID][i] = tonumber(e)
				elseif string.StartWith(i, "string_color") then
					rs.rplist[role.uniqueID][i] = stc(e)
				else
					rs.rplist[role.uniqueID][i] = e
				end
			end
			local pnl = rs.rplist[role.uniqueID]
			function pnl:Paint(pw, ph)
				local tab = {}
				tab.color = rs.rplist[role.uniqueID]["string_color"]
				DrawPanel(self, tab)

				self.text = self.text or role.string_name .. " [UID: " .. role.uniqueID .. "]"
				local tab2 = {}
				tab2.x = ctr(182)
				tab2.y = ctr(20)
				tab2.ax = 0
				tab2.ay = 0
				tab2.text = self.text
				tab2.font = "mat1text"
				tab2.lforce = false
				DrawText(tab2)

				--[[local tab3 = {}
				tab3.x = ctr(182)
				tab3.y = ctr(100)
				tab3.ax = 0
				tab3.ay = 4
				tab3.text = "POSITION: " .. role.int_position
				tab3.font = "mat1text"
				DrawText(tab3)]]
			end
			function pnl:DoClick()
				net.Start("settings_subscribe_role")
					net.WriteString(role.uniqueID)
				net.SendToServer()
			end

			rs.rplist[role.uniqueID].ico = createD("DHTML", rs.rplist[role.uniqueID], rs.rplist[role.uniqueID]:GetTall() - ctr(20), rs.rplist[role.uniqueID]:GetTall() - ctr(20), ctr(60), ctr(10))
			local ico = rs.rplist[role.uniqueID].ico
			function ico:Paint(pw, ph)
			end
			ico:SetHTML( GetHTMLImage( role.string_icon, ico:GetWide(), ico:GetTall() ) )

			rs.rplist[role.uniqueID].up = createD("DButton", rs.rplist[role.uniqueID], ctr(40), rs.rplist[role.uniqueID]:GetTall() / 2 - ctr(15), ctr(10), ctr(10))
			rs.rplist[role.uniqueID].up:SetText("")
			local up = rs.rplist[role.uniqueID].up
			function up:Paint(pw, ph)
				if rs.rplist[role.uniqueID].int_position > 1 then
					local tab = {}
					tab.color = Color(255, 255, 0)
					DrawPanel(self, tab)
					local tab2 = {}
					tab2.x = pw / 2
					tab2.y = ph / 2
					tab2.ax = 1
					tab2.ay = 1
					tab2.text = "▲"
					tab2.font = "mat1text"
					DrawText(tab2)
				end
			end
			function up:DoClick()
				net.Start("settings_role_position_up")
					net.WriteString(rs.rplist[role.uniqueID].uniqueID)
				net.SendToServer()
			end

			rs.rplist[role.uniqueID].dn = createD("DButton", rs.rplist[role.uniqueID], ctr(40), rs.rplist[role.uniqueID]:GetTall() / 2 - ctr(15), ctr(10), rs.rplist[role.uniqueID]:GetTall() / 2 + ctr(5))
			rs.rplist[role.uniqueID].dn:SetText("")
			local dn = rs.rplist[role.uniqueID].dn
			function dn:Paint(pw, ph)
				if rs.rplist[role.uniqueID].int_position < table.Count(rs.rplist.tab) then
					local tab = {}
					tab.color = Color(255, 255, 0)
					DrawPanel(self, tab)
					local tab2 = {}
					tab2.x = pw / 2
					tab2.y = ph / 2
					tab2.ax = 1
					tab2.ay = 1
					tab2.text = "▼"
					tab2.font = "mat1text"
					DrawText(tab2)
				end
			end
			function dn:DoClick()
				net.Start("settings_role_position_dn")
					net.WriteString(rs.rplist[role.uniqueID].uniqueID)
				net.SendToServer()
			end

			--[[
			rs.rplist[role.uniqueID].ch = createD("DButton", rs.rplist[role.uniqueID], ctr(40), ctr(40), rs.rplist[role.uniqueID]:GetWide() - ctr(66), rs.rplist[role.uniqueID]:GetTall() - ctr(60))
			rs.rplist[role.uniqueID].ch:SetText("")
			local ch = rs.rplist[role.uniqueID].ch
			function ch:Paint(pw, ph)
				local tab = {}
				tab.color = Color(255, 255, 0)
				DrawPanel(self, tab)
				local tab2 = {}
				tab2.x = pw / 2
				tab2.y = ph / 2
				tab2.ax = 1
				tab2.ay = 1
				tab2.text = "▶"
				tab2.font = "mat1text"
				DrawText(tab2)
			end
			function ch:DoClick()
				rs.rplist:ClearList()
				net.Start("settings_unsubscribe_rolelist")
					net.WriteString(cur_role.cur)
				net.SendToServer()
				timer.Simple(0.1, function()
					net.Start("settings_subscribe_rolelist")
						net.WriteString(rs.rplist[role.uniqueID].uniqueID)
					net.SendToServer()
				end)
			end
			]]--

			parent:AddItem(rs.rplist[role.uniqueID])
		end

		net.Receive("settings_subscribe_role", function(le)
			local role = net.ReadTable()
			local roles = net.ReadTable()
			local db_ugs = net.ReadTable()

			role.uniqueID = tonumber(role.uniqueID)

			--net.Start("settings_subscribe_rolelist")
				--net.WriteString(role.uniqueID)
			--net.SendToServer()

			role.uniqueID = tonumber(role.uniqueID)
			cur_role.edi = role.uniqueID

			ea.typ = "role"
			ea.tab = role

			for i, pnl in pairs(ea.background:GetChildren()) do
				pnl:Remove()
			end

			ea[role.uniqueID] = ea[role.uniqueID] or {}

			local info = {}
			info.parent = ea.background
			info.x = ctr(20)
			info.y = ctr(20)
			info.w = ctr(1000)
			info.h = ctr(530)
			info.br = ctr(20)
			info.color = Color( 255, 255, 255 )
			info.bgcolor = Color( 80, 80, 80 )
			info.name = "general"
			ea[role.uniqueID].info = DGroup(info)
			ea.info = ea[role.uniqueID].info
			function ea.info:OnRemove()
				if cur_role.edi != role.uniqueID then
					net.Start("settings_unsubscribe_role")
						net.WriteString(role.uniqueID)
					net.SendToServer()
				end
			end

			local name = {}
			name.parent = ea.info
			name.uniqueID = role.uniqueID
			name.header = "name"
			name.netstr = "update_role_string_name"
			name.value = role.string_name
			name.uniqueID = role.uniqueID
			name.lforce = false
			ea[role.uniqueID].name = DTextBox(name)

			local hr = {}
			hr.h = ctr(20)
			hr.parent = ea.info
			DHr(hr)

			local color = {}
			color.parent = ea.info
			color.uniqueID = role.uniqueID
			color.header = "color"
			color.netstr = "update_role_string_color"
			color.value = role.string_color
			color.uniqueID = role.uniqueID
			color.lforce = false
			ea[role.uniqueID].color = DColor(color)

			DHr(hr)

			local icon = {}
			icon.parent = ea.info
			icon.uniqueID = role.uniqueID
			icon.header = "icon"
			icon.netstr = "update_role_string_icon"
			icon.value = role.string_icon
			icon.uniqueID = role.uniqueID
			icon.lforce = false
			ea[role.uniqueID].icon = DTextBox(icon)

			DHr(hr)

			local otherroles = {}
			otherroles[0] = lang_string("none")
			for i, tab in pairs(roles) do
				print(tab.uniqueID, role.uniqueID)
				tab.uniqueID = tonumber(tab.uniqueID)
				if tab.uniqueID != role.uniqueID then
					otherroles[tab.uniqueID] = tab.string_name .. " [UID: " .. tab.uniqueID .. "]"
				end
			end

			local prerole = {}
			prerole.parent = ea.info
			prerole.uniqueID = role.uniqueID
			prerole.header = "prerole"
			prerole.netstr = "update_role_int_prerole"
			prerole.value = role.int_prerole
			prerole.uniqueID = role.uniqueID
			prerole.lforce = false
			prerole.choices = otherroles
			ea[role.uniqueID].prerole = DComboBox(prerole)

			local restriction = {}
			restriction.parent = ea.background
			restriction.x = ctr(1040)
			restriction.y = ctr(20)
			restriction.w = ctr(1000)
			restriction.h = ctr(570)
			restriction.br = ctr(20)
			restriction.color = Color( 255, 255, 255 )
			restriction.bgcolor = Color( 80, 80, 80 )
			restriction.name = "restriction"
			ea[role.uniqueID].restriction = DGroup(restriction)
			ea.restriction = ea[role.uniqueID].restriction

			local gugs = string.Explode(",", role.string_usergroups)

			local ugs = {}
			ugs["ALL"] = {}
			ugs["ALL"].checked = table.HasValue(gugs, "ALL")
			ugs["ALL"]["choices"] = {}
			for i, pl in pairs(player.GetAll()) do
				ugs["ALL"]["choices"][string.upper(pl:GetUserGroup())] = ugs["ALL"]["choices"][string.upper(pl:GetUserGroup())] or {}
				ugs["ALL"]["choices"][string.upper(pl:GetUserGroup())].checked = table.HasValue(gugs, string.upper(pl:GetUserGroup()))
			end

			for i, ug in pairs(db_ugs) do
				ugs["ALL"]["choices"][string.upper(ug.name)] = ugs["ALL"]["choices"][string.upper(ug.name)] or {}
				ugs["ALL"]["choices"][string.upper(ug.name)].checked = table.HasValue(gugs, string.upper(ug.name))
			end

			local usergroups = {}
			usergroups.parent = ea.restriction
			usergroups.uniqueID = role.uniqueID
			usergroups.header = "usergroups"
			usergroups.netstr = "update_role_string_usergroups"
			usergroups.value = role.string_usergroups
			usergroups.uniqueID = role.uniqueID
			usergroups.lforce = false
			usergroups.choices = ugs
			ea[role.uniqueID].usergroups = DCheckBoxes(usergroups)

			hr.parent = ea.restriction
			DHr(hr)

			local requireslevel = {}
			requireslevel.parent = ea.restriction
			requireslevel.uniqueID = role.uniqueID
			requireslevel.header = "requireslevel"
			requireslevel.netstr = "update_role_int_requireslevel"
			requireslevel.value = role.int_requireslevel
			requireslevel.uniqueID = role.uniqueID
			requireslevel.lforce = false
			requireslevel.min = 1
			requireslevel.max = 100
			ea[role.uniqueID].requireslevel = DIntBox(requireslevel)

			DHr(hr)

			local whitelist = {}
			whitelist.parent = ea.restriction
			whitelist.uniqueID = role.uniqueID
			whitelist.header = "useswhitelist"
			whitelist.netstr = "update_role_bool_whitelist"
			whitelist.value = role.bool_whitelist
			whitelist.uniqueID = role.uniqueID
			whitelist.lforce = false
			ea[role.uniqueID].whitelist = DCheckBox(whitelist)

			DHr(hr)

			local locked = {}
			locked.parent = ea.restriction
			locked.uniqueID = role.uniqueID
			locked.header = "locked"
			locked.netstr = "update_role_bool_locked"
			locked.value = role.bool_locked
			locked.uniqueID = role.uniqueID
			locked.lforce = false
			ea[role.uniqueID].locked = DCheckBox(locked)

			DHr(hr)

			local visible = {}
			visible.parent = ea.restriction
			visible.uniqueID = role.uniqueID
			visible.header = "visible"
			visible.netstr = "update_role_bool_visible"
			visible.value = role.bool_visible
			visible.uniqueID = role.uniqueID
			visible.lforce = false
			ea[role.uniqueID].visible = DCheckBox(visible)
		end)

		net.Receive("settings_subscribe_rolelist", function(le)
			if pa(rs.rplist) then
				rs.rplist:ClearList()

				local parentrole = net.ReadTable()
				if parentrole.uniqueID != nil then
					rs.top.group = parentrole.string_name
				else
					rs.top.group = ""
				end

				local roles = net.ReadTable()

				cur_role.cur = tonumber(net.ReadString())
				cur_role.par = tonumber(net.ReadString())
				rs.rplist.tab = roles
				for i, role in pairs(roles) do
					CreateLineRole(rs.rplist, role)
					role["int_position"] = tonumber(role["int_position"])
				end

				rs.rplist:SortByMember("int_position", true)
				rs.rplist:Rebuild()
			end
		end)
	end
end)

hook.Add("open_server_groups_and_roles", "open_server_groups_and_roles", function()
	SaveLastSite()
	local w = settingsWindow.window.sitepanel:GetWide()
	local h = settingsWindow.window.sitepanel:GetTall()
	settingsWindow.window.site = createD("DPanel", settingsWindow.window.sitepanel, w, h, 0, 0)
	net.Start("Subscribe_Settings_GroupsAndRoles")
	net.SendToServer()
end)
