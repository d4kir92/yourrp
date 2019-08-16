--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

net.Receive("Subscribe_Settings_GroupsAndRoles", function(len)
	if pa(settingsWindow) and pa(settingsWindow.window) then
		function settingsWindow.window.site:Paint(pw, ph)
			draw.RoundedBox(4, 0, 0, pw, ph, Color(0, 0, 0, 254))
		end

		local PARENT = settingsWindow.window.site

		local cur_group = {}
		cur_group.cur = 0
		cur_group.par = 0
		cur_group.edi = 0

		local cur_role = {}
		cur_role.gro = 0
		cur_role.pre = 0
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

		gs.bac = createD("DButton", PARENT, YRP.ctr(60), YRP.ctr(60), YRP.ctr(20), YRP.ctr(20))
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

		gs.top = createD("DPanel", PARENT, YRP.ctr(800-120), YRP.ctr(60), YRP.ctr(80), YRP.ctr(20))
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
					tab2.text = YRP.lang_string("LID_groupsof", inp)
				else
					tab2.text = YRP.lang_string("LID_factions")
				end
			else
				tab2.text = YRP.lang_string("LID_loading")
			end
			DrawText(tab2)
		end

		gs.add = createD("DButton", PARENT, YRP.ctr(60), YRP.ctr(60), YRP.ctr(20 + 800 - 60), YRP.ctr(20))
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

		gs.glist = createD("DPanel", PARENT, YRP.ctr(800), YRP.ctr(940), YRP.ctr(20), YRP.ctr(80))
		gs.gplist = createD("DPanelList", gs.glist, gs.glist:GetWide(), gs.glist:GetTall(), 0, 0)
		gs.gplist:EnableVerticalScrollbar(true)
		gs.gplist:SetSpacing(YRP.ctr(10))
		function gs.gplist:ClearList()
			gs.top.group = nil
			gs.gplist:Clear()
		end

		net.Receive("settings_group_update_name", function(le)
			if pa(gs.gplist) then
				local _uid = tonumber(net.ReadString())
				local name = net.ReadString()
				gs.gplist[_uid].text = name
			end
		end)

		net.Receive("settings_group_update_color", function(le)
			if pa(gs) then
				local _uid = tonumber(net.ReadString())
				local color = net.ReadString()
				if isnumber(_uid) and gs.gplist[_uid] != nil then
					gs.gplist[_uid].string_color = stc(color)
				end
			end
		end)

		net.Receive("settings_group_update_icon", function(le)
			if pa(gs.gplist) then
				local _uid = tonumber(net.ReadString())
				local icon = net.ReadString()
				gs.gplist[_uid].string_icon = icon
				gs.gplist[_uid].ico:SetHTML(GetHTMLImage(gs.gplist[_uid].string_icon, gs.gplist[_uid].ico:GetWide(), gs.gplist[_uid].ico:GetTall()))
			end
		end)

		function CreateLineGroup(parent, group)
			group.uniqueID = tonumber(group.uniqueID)
			gs.gplist[group.uniqueID] = gs.gplist[group.uniqueID] or {}
			gs.gplist[group.uniqueID] = createD("DButton", parent, parent:GetWide() - YRP.ctr(20), YRP.ctr(120), 0, 0)
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

				self.text = self.text or group.string_name --.. " [UID: " .. group.uniqueID .. "]"
				local tab2 = {}
				tab2.x = YRP.ctr(182)
				tab2.y = YRP.ctr(20)
				tab2.ax = 0
				tab2.ay = 0
				tab2.text = self.text
				tab2.font = "mat1text"
				tab2.lforce = false
				DrawText(tab2)

				--[[local tab3 = {}
				tab3.x = YRP.ctr(182)
				tab3.y = YRP.ctr(100)
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

			gs.gplist[group.uniqueID].ico = createD("DHTML", gs.gplist[group.uniqueID], gs.gplist[group.uniqueID]:GetTall() - YRP.ctr(20), gs.gplist[group.uniqueID]:GetTall() - YRP.ctr(20), YRP.ctr(60), YRP.ctr(10))
			local ico = gs.gplist[group.uniqueID].ico
			function ico:Paint(pw, ph)
			end
			ico:SetHTML(GetHTMLImage(group.string_icon, ico:GetWide(), ico:GetTall()))

			gs.gplist[group.uniqueID].up = createD("DButton", gs.gplist[group.uniqueID], YRP.ctr(40), gs.gplist[group.uniqueID]:GetTall() / 2 - YRP.ctr(15), YRP.ctr(10), YRP.ctr(10))
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

			gs.gplist[group.uniqueID].dn = createD("DButton", gs.gplist[group.uniqueID], YRP.ctr(40), gs.gplist[group.uniqueID]:GetTall() / 2 - YRP.ctr(15), YRP.ctr(10), gs.gplist[group.uniqueID]:GetTall() / 2 + YRP.ctr(5))
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

			gs.gplist[group.uniqueID].ch = createD("DButton", gs.gplist[group.uniqueID], YRP.ctr(40), YRP.ctr(40), gs.gplist[group.uniqueID]:GetWide() - YRP.ctr(66), gs.gplist[group.uniqueID]:GetTall() - YRP.ctr(60))
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

		rs.top = createD("DPanel", PARENT, YRP.ctr(800-120), YRP.ctr(60), YRP.ctr(80), YRP.ctr(1040))
		function rs.top:Paint(pw, ph)
			if rs.top.headername != nil then
				local tab = {}
				tab.color = YRPGetColor("3")
				DrawPanel(self, tab)
				local tab2 = {}
				tab2.x = pw / 2
				tab2.y = ph / 2
				tab2.ax = 1
				tab2.ay = 1
				tab2.font = "mat1text"
				if self.headername != nil then
					local inp = {}
					inp.group = self.headername
					tab2.text = YRP.lang_string("LID_rolesof", inp)
				else
					tab2.text = YRP.lang_string("LID_loading")
				end
				DrawText(tab2)
			end
		end

		rs.bac = createD("DButton", PARENT, YRP.ctr(60), YRP.ctr(60), YRP.ctr(20), YRP.ctr(1040))
		rs.bac:SetText("")
		function rs.bac:Paint(pw, ph)
			if cur_role.pre > 0 then
			--[[if rs.rplist.tab != nil then
				if rs.rplist.tab[1] != nil then
					if tonumber(rs.rplist.tab[1].int_prerole) > 0 then
					]]--
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
						--[[
					end
				end
				]]--
			else
				local tab = {}
				tab.color = YRPGetColor("3")
				DrawPanel(self, tab)
			end
		end
		function rs.bac:DoClick()
			if cur_role.pre > 0 then
				rs.rplist:ClearList()
				net.Start("settings_unsubscribe_rolelist")
					net.WriteString(cur_role.gro)
					net.WriteString(cur_role.pre)
				net.SendToServer()
				net.Start("settings_subscribe_prerolelist")
					net.WriteString(cur_role.gro)
					net.WriteString(cur_role.pre)
				net.SendToServer()
			end
		end

		rs.add = createD("DButton", PARENT, YRP.ctr(60), YRP.ctr(60), YRP.ctr(20 + 800 - 60), YRP.ctr(1040))
		rs.add:SetText("")
		function rs.add:Paint(pw, ph)
			if rs.top.headername != nil then
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
			if rs.top.headername != nil then
				net.Start("settings_add_role")
					net.WriteString(cur_role.gro)
					net.WriteString(cur_role.pre)
				net.SendToServer()
			end
		end

		rs.rlist = createD("DPanel", PARENT, YRP.ctr(800), YRP.ctr(940), YRP.ctr(20), YRP.ctr(1100))
		function rs.rlist:Paint(pw, ph)
			if rs.top.headername != nil then
				local tab = {}
				tab.color = Color(255, 255, 255)
				DrawPanel(self, tab)
			end
		end
		rs.rplist = createD("DPanelList", rs.rlist, rs.rlist:GetWide(), rs.rlist:GetTall(), 0, 0)
		rs.rplist:EnableVerticalScrollbar(true)
		rs.rplist:SetSpacing(YRP.ctr(10))
		function rs.rplist:ClearList()
			rs.top.headername = nil
			rs.rplist:Clear()
		end

		PARENT.ea = {}
		local ea = PARENT.ea

		ea.background = createD("DPanel", PARENT, ScrW() - YRP.ctr(860), ScrH() - YRP.ctr(200), YRP.ctr(840), YRP.ctr(80))
		function ea.background:Paint(pw, ph)
			if ea.typ != nil then
				local tab = {}
				tab.color = Color(20, 20, 20, 255)
				DrawPanel(self, tab)
			end
		end

		ea.del = createD("DButton", PARENT, YRP.ctr(60), YRP.ctr(60), YRP.ctr(840), YRP.ctr(20))
		ea.del:SetText("")
		function ea.del:Paint(pw, ph)
			if ea.typ != nil and tonumber(ea.tab.uniqueID) != 1 then
				local tab = {}
				tab.color = Color(80, 80, 80)
				DrawPanel(self, tab)

				local tab2 = {}
				tab2.w = pw
				tab2.h = ph
				tab2.x = YRP.ctr(20)
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
			if ea.typ == "group" and tonumber(ea.tab.uniqueID) != 1 then
				net.Start("settings_delete_group")
					net.WriteString(ea.tab.uniqueID)
				net.SendToServer()
				for i, pnl in pairs(ea.background:GetChildren()) do
					pnl:Remove()
				end
				ea.typ = nil
				ea.tab = nil
			elseif ea.typ == "role" and wk(ea.tab.uniqueID) and tonumber(ea.tab.uniqueID) != 1 then
				net.Start("settings_delete_role")
					net.WriteString(ea.tab.uniqueID)
				net.SendToServer()
				for i, pnl in pairs(ea.background:GetChildren()) do
					pnl:Remove()
				end
				ea.typ = nil
				ea.tab = nil
			end
		end

		ea.dup = createD("DButton", PARENT, YRP.ctr(60), YRP.ctr(60), YRP.ctr(900), YRP.ctr(20))
		ea.dup:SetText("")
		function ea.dup:Paint(pw, ph)
			if ea.typ != nil then
				if ea.tab.uniqueID != 1 then
					local tab = {}
					tab.color = Color(255, 255, 0, 255)
					DrawPanel(self, tab)

					local tab2 = {}
					tab2.w = pw
					tab2.h = ph
					tab2.x = YRP.ctr(20)
					tab2.y = ph / 2
					tab2.ax = 0
					tab2.text = "[ ]"
					tab2.font = "mat1text"
					DrawText(tab2)
				end
			elseif ea.typ != nil then
				local tab = {}
				tab.color = YRPGetColor("3")
				DrawPanel(self, tab)
			end
		end
		function ea.dup:DoClick()
			if ea.tab.uniqueID != 1 then
				if ea.typ == "group" then
					net.Start("duplicated_group")
						net.WriteString(ea.tab.uniqueID)
					net.SendToServer()
				elseif ea.typ == "role" then
					net.Start("duplicated_role")
						net.WriteString(ea.tab.uniqueID)
					net.SendToServer()
				end
			end
		end


		ea.top = createD("DPanel", PARENT, ScrW() - YRP.ctr(980), YRP.ctr(60), YRP.ctr(960), YRP.ctr(20))
		function ea.top:Paint(pw, ph)
			if ea.typ != nil then
				local tab = {}
				tab.color = YRPGetColor("3")
				DrawPanel(self, tab)

				local tab2 = {}
				tab2.w = pw
				tab2.h = ph
				tab2.x = YRP.ctr(20)
				tab2.y = ph / 2
				tab2.ax = 0
				if ea.tab.uniqueID == 1 then
					tab2.text = "[MAIN] " .. YRP.lang_string("LID_" .. ea.typ) .. ": " .. tostring(ea.tab.string_name)
				else
					tab2.text = YRP.lang_string("LID_" .. ea.typ) .. ": " .. tostring(ea.tab.string_name)
				end
				tab2.font = "mat1text"
				DrawText(tab2)
			end
		end

		net.Receive("settings_subscribe_group", function(le)
			local group = net.ReadTable()
			local groups = net.ReadTable()
			local db_ugs = net.ReadTable()

			if group.uniqueID != nil then
				net.Start("settings_subscribe_rolelist")
					net.WriteString(group.uniqueID)
					net.WriteString("0")
				net.SendToServer()
			end

			group.uniqueID = tonumber(group.uniqueID)
			cur_group.edi = group.uniqueID

			ea.typ = "group"
			ea.tab = group

			for i, pnl in pairs(ea.background:GetChildren()) do
				pnl:Remove()
			end

			ea[group.uniqueID] = ea[group.uniqueID] or {}



			local info = createD("YGroupBox", ea.background, YRP.ctr(1000), YRP.ctr(540), YRP.ctr(20), YRP.ctr(20))
			info:SetText("LID_general")
			function info:Paint(pw, ph)
				hook.Run("YGroupBoxPaint", self, pw, ph)
			end

			ea[group.uniqueID].info = info
			ea.info = ea[group.uniqueID].info
			function ea.info:OnRemove()
				if cur_group.edi != group.uniqueID then
					net.Start("settings_unsubscribe_group")
						net.WriteString(group.uniqueID)
					net.SendToServer()
				end
			end

			local name = {}
			name.parent = ea.info:GetContent()
			name.uniqueID = group.uniqueID
			name.header = "LID_name"
			name.netstr = "update_group_string_name"
			name.value = group.string_name
			name.uniqueID = group.uniqueID
			name.lforce = false
			ea[group.uniqueID].name = DTextBox(name)

			local hr = {}
			hr.h = YRP.ctr(16)
			hr.parent = ea.info:GetContent()
			DHr(hr)

			local color = {}
			color.parent = ea.info:GetContent()
			color.uniqueID = group.uniqueID
			color.header = "LID_color"
			color.netstr = "update_group_string_color"
			color.value = group.string_color
			color.uniqueID = group.uniqueID
			color.lforce = false
			ea[group.uniqueID].color = DColor(color)

			DHr(hr)

			local icon = {}
			icon.parent = ea.info:GetContent()
			icon.uniqueID = group.uniqueID
			icon.header = "LID_icon"
			icon.netstr = "update_group_string_icon"
			icon.value = group.string_icon
			icon.uniqueID = group.uniqueID
			icon.lforce = false
			ea[group.uniqueID].icon = DTextBox(icon)

			DHr(hr)

			local othergroups = {}
			othergroups[0] = YRP.lang_string("LID_factions")
			for i, tab in pairs(groups) do
				othergroups[tab.uniqueID] = tab.string_name --.. " [UID: " .. tab.uniqueID .. "]"
			end

			if group.uniqueID != 1 then
				local parentgroup = {}
				parentgroup.parent = ea.info:GetContent()
				parentgroup.uniqueID = group.uniqueID
				parentgroup.header = "LID_parentgroup"
				parentgroup.netstr = "update_group_int_parentgroup"
				parentgroup.value = group.int_parentgroup
				parentgroup.uniqueID = group.uniqueID
				parentgroup.lforce = false
				parentgroup.choices = othergroups
				ea[group.uniqueID].parentgroup = DComboBox(parentgroup)
			end



			local restriction = createD("YGroupBox", ea.background, YRP.ctr(1000), YRP.ctr(570), YRP.ctr(1040), YRP.ctr(20))
			restriction:SetText("LID_restriction")
			function restriction:Paint(pw, ph)
				hook.Run("YGroupBoxPaint", self, pw, ph)
			end

			ea[group.uniqueID].restriction = restriction
			ea.restriction = ea[group.uniqueID].restriction

			if group.uniqueID != 1 then
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
					ugs["ALL"]["choices"][string.upper(ug.string_name)] = ugs["ALL"]["choices"][string.upper(ug.string_name)] or {}
					ugs["ALL"]["choices"][string.upper(ug.string_name)].checked = table.HasValue(gugs, string.upper(ug.string_name))
				end

				local usergroups = {}
				usergroups.parent = ea.restriction:GetContent()
				usergroups.uniqueID = group.uniqueID
				usergroups.header = "LID_usergroups"
				usergroups.netstr = "update_group_string_usergroups"
				usergroups.value = group.string_usergroups
				usergroups.uniqueID = group.uniqueID
				usergroups.lforce = false
				usergroups.choices = ugs
				ea[group.uniqueID].usergroups = DCheckBoxes(usergroups)
			end

			hr.parent = ea.restriction:GetContent()
			DHr(hr)

			if group.uniqueID != 1 then
				local requireslevel = {}
				requireslevel.parent = ea.restriction:GetContent()
				requireslevel.header = "LID_requireslevel"
				requireslevel.netstr = "update_group_int_requireslevel"
				requireslevel.value = group.int_requireslevel
				requireslevel.uniqueID = group.uniqueID
				requireslevel.lforce = false
				requireslevel.min = 1
				requireslevel.max = 100
				ea[group.uniqueID].requireslevel = DIntBox(requireslevel)
			end

			DHr(hr)

			local groupvoicechat = {}
			groupvoicechat.parent = ea.restriction:GetContent()
			groupvoicechat.uniqueID = group.uniqueID
			groupvoicechat.header = "LID_canusegroupvoicechat"
			groupvoicechat.netstr = "update_group_bool_groupvoicechat"
			groupvoicechat.value = group.bool_groupvoicechat
			groupvoicechat.uniqueID = group.uniqueID
			groupvoicechat.lforce = false
			ea[group.uniqueID].groupvoicechat = DCheckBox(groupvoicechat)

			DHr(hr)

			if group.uniqueID != 1 then
				local whitelist = {}
				whitelist.parent = ea.restriction:GetContent()
				whitelist.uniqueID = group.uniqueID
				whitelist.header = "LID_useswhitelist"
				whitelist.netstr = "update_group_bool_whitelist"
				whitelist.value = group.bool_whitelist
				whitelist.uniqueID = group.uniqueID
				whitelist.lforce = false
				ea[group.uniqueID].whitelist = DCheckBox(whitelist)

				DHr(hr)

				local locked = {}
				locked.parent = ea.restriction:GetContent()
				locked.uniqueID = group.uniqueID
				locked.header = "LID_locked"
				locked.netstr = "update_group_bool_locked"
				locked.value = group.bool_locked
				locked.uniqueID = group.uniqueID
				locked.lforce = false
				ea[group.uniqueID].locked = DCheckBox(locked)

				DHr(hr)

				local visible = {}
				visible.parent = ea.restriction:GetContent()
				visible.uniqueID = group.uniqueID
				visible.header = "LID_visible"
				visible.netstr = "update_group_bool_visible"
				visible.value = group.bool_visible
				visible.uniqueID = group.uniqueID
				visible.lforce = false
				ea[group.uniqueID].visible = DCheckBox(visible)
			end
		end)

		function CreateLineRole(parent, role)
			role.uniqueID = tonumber(role.uniqueID)
			rs.rplist[role.uniqueID] = rs.rplist[role.uniqueID] or {}
			rs.rplist[role.uniqueID] = createD("DButton", parent, parent:GetWide() - YRP.ctr(20), YRP.ctr(120), 0, 0)
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

				self.text = self.text or role.string_name --.. " [UID: " .. role.uniqueID .. "]"
				local tab2 = {}
				tab2.x = YRP.ctr(182)
				tab2.y = YRP.ctr(20)
				tab2.ax = 0
				tab2.ay = 0
				tab2.text = self.text
				tab2.font = "mat1text"
				tab2.lforce = false
				DrawText(tab2)

				--[[local tab3 = {}
				tab3.x = YRP.ctr(182)
				tab3.y = YRP.ctr(100)
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

			rs.rplist[role.uniqueID].ico = createD("DHTML", rs.rplist[role.uniqueID], rs.rplist[role.uniqueID]:GetTall() - YRP.ctr(20), rs.rplist[role.uniqueID]:GetTall() - YRP.ctr(20), YRP.ctr(60), YRP.ctr(10))
			local ico = rs.rplist[role.uniqueID].ico
			function ico:Paint(pw, ph)
			end
			ico:SetHTML(GetHTMLImage(role.string_icon, ico:GetWide(), ico:GetTall()))

			rs.rplist[role.uniqueID].up = createD("DButton", rs.rplist[role.uniqueID], YRP.ctr(40), rs.rplist[role.uniqueID]:GetTall() / 2 - YRP.ctr(15), YRP.ctr(10), YRP.ctr(10))
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

			rs.rplist[role.uniqueID].dn = createD("DButton", rs.rplist[role.uniqueID], YRP.ctr(40), rs.rplist[role.uniqueID]:GetTall() / 2 - YRP.ctr(15), YRP.ctr(10), rs.rplist[role.uniqueID]:GetTall() / 2 + YRP.ctr(5))
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

			rs.rplist[role.uniqueID].ch = createD("DButton", rs.rplist[role.uniqueID], YRP.ctr(40), YRP.ctr(40), rs.rplist[role.uniqueID]:GetWide() - YRP.ctr(66), rs.rplist[role.uniqueID]:GetTall() - YRP.ctr(60))
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
					net.WriteString(cur_role.gro)
					net.WriteString(cur_role.pre)
				net.SendToServer()
				timer.Simple(0.1, function()
					net.Start("settings_subscribe_rolelist")
						net.WriteString(cur_role.gro)
						net.WriteString(rs.rplist[role.uniqueID].uniqueID)
					net.SendToServer()
				end)
			end

			parent:AddItem(rs.rplist[role.uniqueID])
		end

		net.Receive("settings_subscribe_role", function(le)
			local role = net.ReadTable()
			local roles = net.ReadTable()
			local db_ugs = net.ReadTable()
			local db_groups = net.ReadTable()

			role.uniqueID = tonumber(role.uniqueID)
			cur_role.gro = role.int_groupID
			cur_role.edi = role.uniqueID

			ea.typ = "role"
			ea.tab = role

			if wk(ea.background) then
				for i, pnl in pairs(ea.background:GetChildren()) do
					pnl:Remove()
				end
			end

			ea[role.uniqueID] = ea[role.uniqueID] or {}



			local info = createD("YGroupBox", ea.background, YRP.ctr(800), YRP.ctr(866), YRP.ctr(20), YRP.ctr(20))
			info:SetText("LID_general")
			function info:Paint(pw, ph)
				hook.Run("YGroupBoxPaint", self, pw, ph)
			end

			ea[role.uniqueID].info = info
			ea.info = ea[role.uniqueID].info
			function ea.info:OnRemove()
				if cur_role.edi != role.uniqueID then
					net.Start("settings_unsubscribe_role")
						net.WriteString(role.uniqueID)
					net.SendToServer()
				end
			end

			local name = {}
			name.parent = ea.info:GetContent()
			name.uniqueID = role.uniqueID
			name.header = "LID_name"
			name.netstr = "update_role_string_name"
			name.value = role.string_name
			name.uniqueID = role.uniqueID
			name.lforce = false
			ea[role.uniqueID].name = DTextBox(name)

			local hr = {}
			hr.h = YRP.ctr(16)
			hr.parent = ea.info:GetContent()
			DHr(hr)

			local color = {}
			color.parent = ea.info:GetContent()
			color.uniqueID = role.uniqueID
			color.header = "LID_color"
			color.netstr = "update_role_string_color"
			color.value = role.string_color
			color.uniqueID = role.uniqueID
			color.lforce = false
			ea[role.uniqueID].color = DColor(color)

			DHr(hr)

			local icon = {}
			icon.parent = ea.info:GetContent()
			icon.uniqueID = role.uniqueID
			icon.header = "LID_icon"
			icon.netstr = "update_role_string_icon"
			icon.value = role.string_icon
			icon.uniqueID = role.uniqueID
			icon.lforce = false
			ea[role.uniqueID].icon = DTextBox(icon)

			DHr(hr)

			local maxa = {}
			maxa[0] = YRP.lang_string("LID_disabled")
			for i = 1, 128 do
				maxa[i] = i
			end

			if role.uniqueID != 1 then
				local maxamount = {}
				maxamount.parent = ea.info:GetContent()
				maxamount.uniqueID = role.uniqueID
				maxamount.header = "LID_maxamount"
				maxamount.netstr = "update_role_int_maxamount"
				maxamount.value = tonumber(role.int_maxamount)
				maxamount.uniqueID = role.uniqueID
				maxamount.lforce = false
				maxamount.choices = maxa
				ea[role.uniqueID].maxamount = DComboBox(maxamount)

				DHr(hr)
			end

			if role.uniqueID != 1 then
				local amountpercentage = {}
				amountpercentage.parent = ea.info:GetContent()
				amountpercentage.header = "LID_amountpercentage"
				amountpercentage.netstr = "update_role_int_amountpercentage"
				amountpercentage.value = role.int_amountpercentage
				amountpercentage.uniqueID = role.uniqueID
				amountpercentage.lforce = false
				amountpercentage.min = 0
				amountpercentage.max = 100
				ea[role.uniqueID].amountpercentage = DIntBox(amountpercentage)

				DHr(hr)
			end

			if role.uniqueID != 1 then
				local grps = {}
				for i, tab in pairs(db_groups) do
					grps[i] = tab.string_name --.. " [UID: " .. tab.uniqueID .. "]"
				end

				local int_groupID = {}
				int_groupID.parent = ea.info:GetContent()
				int_groupID.uniqueID = role.uniqueID
				int_groupID.header = "LID_group"
				int_groupID.netstr = "update_role_int_groupID"
				int_groupID.value = tonumber(role.int_groupID)
				int_groupID.uniqueID = role.uniqueID
				int_groupID.lforce = false
				int_groupID.choices = grps
				ea[role.uniqueID].int_groupID = DComboBox(int_groupID)

				DHr(hr)
			end

			local string_description = {}
			string_description.parent = ea.info:GetContent()
			string_description.uniqueID = role.uniqueID
			string_description.header = "LID_description"
			string_description.netstr = "update_role_string_description"
			string_description.value = role.string_description
			string_description.uniqueID = role.uniqueID
			string_description.lforce = false
			ea[role.uniqueID].string_description = DTextBox(string_description)

			DHr(hr)

			local salary = {}
			salary.parent = ea.info:GetContent()
			salary.header = "LID_salary"
			salary.netstr = "update_role_int_salary"
			salary.value = role.int_salary
			salary.uniqueID = role.uniqueID
			salary.lforce = false
			salary.min = 0
			salary.max = GetMaxInt()
			ea[role.uniqueID].salary = DIntBox(salary)

			DHr(hr)

			local salarytime = {}
			salarytime.parent = ea.info:GetContent()
			salarytime.header = "LID_timesalary"
			salarytime.netstr = "update_role_int_salarytime"
			salarytime.value = role.int_salarytime
			salarytime.uniqueID = role.uniqueID
			salarytime.lforce = false
			salarytime.min = 1
			salarytime.max = 9999
			ea[role.uniqueID].requireslevel = DIntBox(salarytime)

			DHr(hr)

			local otherroles = {}
			otherroles[0] = YRP.lang_string("LID_none")
			for i, tab in pairs(roles) do
				tab.uniqueID = tonumber(tab.uniqueID)
				if tab.uniqueID != role.uniqueID then
					otherroles[tab.uniqueID] = tab.string_name --.. " [UID: " .. tab.uniqueID .. "]"
				end
			end

			if role.uniqueID != 1 then
				local prerole = {}
				prerole.parent = ea.info:GetContent()
				prerole.uniqueID = role.uniqueID
				prerole.header = YRP.lang_string("LID_prerole") .. " | " .. YRP.lang_string("LID_prerank")
				prerole.netstr = "update_role_int_prerole"
				prerole.value = tonumber(role.int_prerole)
				prerole.uniqueID = role.uniqueID
				prerole.lforce = false
				prerole.choices = otherroles
				ea[role.uniqueID].prerole = DComboBox(prerole)

				DHr(hr)
			end

			local rod_roles = {}
			rod_roles[0] = YRP.lang_string("LID_none")
			for i, tab in pairs(roles) do
				tab.uniqueID = tonumber(tab.uniqueID)
				rod_roles[tab.uniqueID] = tab.string_name --.. " [UID: " .. tab.uniqueID .. "]"
			end
			rod_roles[0] = YRP.lang_string("LID_none")

			local roleondeath = {}
			roleondeath.parent = ea.info:GetContent()
			roleondeath.uniqueID = role.uniqueID
			roleondeath.header = YRP.lang_string("LID_roleafterdeath")
			roleondeath.netstr = "update_role_int_roleondeath"
			roleondeath.value = tonumber(role.int_roleondeath)
			roleondeath.uniqueID = role.uniqueID
			roleondeath.lforce = false
			roleondeath.choices = rod_roles
			ea[role.uniqueID].roleondeath = DComboBox(roleondeath)

			ea.info:AutoSize(true)



			-- FLAGS
			local flags = createD("YGroupBox", ea.background, ea.info:GetWide(), YRP.ctr(800), YRP.ctr(20), ea.info.y + ea.info:GetTall() + YRP.ctr(20))
			flags:SetText("LID_flags")
			function flags:Paint(pw, ph)
				hook.Run("YGroupBoxPaint", self, pw, ph)
			end

			ea[role.uniqueID].flags = flags
			ea.flags = ea[role.uniqueID].flags

			local bool_instructor = {}
			bool_instructor.parent = ea.flags:GetContent()
			bool_instructor.uniqueID = role.uniqueID
			bool_instructor.header = "LID_isinstructor"
			bool_instructor.netstr = "update_role_bool_instructor"
			bool_instructor.value = role.bool_instructor
			bool_instructor.uniqueID = role.uniqueID
			bool_instructor.lforce = false
			ea[role.uniqueID].bool_instructor = DCheckBox(bool_instructor)

			hr.parent = ea.flags:GetContent()
			DHr(hr)

			local custom_flags = {}
			custom_flags.parent = ea.flags:GetContent()
			custom_flags.uniqueID = role.uniqueID
			custom_flags.header = "LID_customflags"
			custom_flags.netstr = "update_role_string_customflags"
			custom_flags.value = role.string_customflags
			custom_flags.uniqueID = role.uniqueID
			custom_flags.w = ea.flags:GetContent():GetWide()
			custom_flags.h = YRP.ctr(225)
			custom_flags.doclick = function()
				net.Receive("get_all_role_customflags", function()
					local cf = net.ReadTable()

					local win = createD("DFrame", nil, YRP.ctr(800), YRP.ctr(800), 0, 0)
					win:SetTitle("")
					win:Center()
					win:MakePopup()

					win.dpl = createD("DPanelList", win, YRP.ctr(800), YRP.ctr(750), 0, YRP.ctr(50))
					for i, flag in pairs(cf) do
						local line = createD("DButton", nil, YRP.ctr(800), YRP.ctr(50), 0, 0)
						line:SetText(flag.string_name)
						function line:DoClick()
							net.Start("add_role_flag")
								net.WriteInt(role.uniqueID, 32)
								net.WriteInt(flag.uniqueID, 32)
							net.SendToServer()
							win:Close()
						end

						win.dpl:AddItem(line)
					end
				end)
				net.Start("get_all_role_customflags")
				net.SendToServer()
			end
			ea[role.uniqueID].custom_flags = DStringListBox(custom_flags)
			net.Receive("get_role_customflags", function()
				local tab_cf = net.ReadTable()
				for i, v in pairs(tab_cf) do
					v.doclick = function()
						net.Start("rem_role_flag")
							net.WriteInt(role.uniqueID, 32)
							net.WriteInt(v.uniqueID, 32)
						net.SendToServer()
					end
				end
				if ea[role.uniqueID].custom_flags.dpl.AddLines != nil then
					ea[role.uniqueID].custom_flags.dpl:AddLines(tab_cf)
				end
			end)
			net.Start("get_role_customflags")
				net.WriteInt(role.uniqueID, 32)
			net.SendToServer()

			ea.flags:AutoSize(true)



			local appearance = createD("YGroupBox", ea.background, YRP.ctr(800), YRP.ctr(800), YRP.ctr(840), YRP.ctr(20))
			appearance:SetText("LID_appearance")
			function appearance:Paint(pw, ph)
				hook.Run("YGroupBoxPaint", self, pw, ph)
			end

			ea[role.uniqueID].appearance = appearance
			ea.appearance = ea[role.uniqueID].appearance

			local playermodels = {}
			playermodels.parent = ea.appearance:GetContent()
			playermodels.uniqueID = role.uniqueID
			playermodels.header = "LID_playermodels"
			playermodels.netstr = "update_role_string_playermodels"
			playermodels.value = role.string_playermodels
			playermodels.uniqueID = role.uniqueID
			playermodels.w = ea.appearance:GetContent():GetWide()
			playermodels.h = YRP.ctr(425)
			playermodels.doclick = function()
				net.Receive("get_all_playermodels", function()
					local pms = net.ReadTable()

					local win = createD("DFrame", nil, YRP.ctr(800), YRP.ctr(800), 0, 0)
					win:SetTitle("")
					win:Center()
					win:MakePopup()
					function win:Paint(pw, ph)
						draw.RoundedBox(0, 0, 0, pw, ph, Color(80, 80, 80, 255))
						draw.SimpleText(YRP.lang_string("LID_search") .. ": ", "DermaDefault", YRP.ctr(20 + 150), YRP.ctr(50 + 20 + 25), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
					end

					win.add = createD("DButton", win, YRP.ctr(50), YRP.ctr(50), YRP.ctr(20), YRP.ctr(50 + 20))
					win.add:SetText("+")
					function win.add:DoClick()
						win:Close()

						local pmwin = createD("DFrame", nil, YRP.ctr(800), YRP.ctr(800), 0, 0)
						pmwin:Center()
						pmwin:MakePopup()
						pmwin:SetTitle("")
						pmwin.pms = {}
						pmwin.name = createD("DTextEntry", pmwin, YRP.ctr(200), YRP.ctr(50), YRP.ctr(20 + 200 + 20 + 200 + 20 + 100), YRP.ctr(50 + 20))

						pmwin.float_min = createD("DNumberWang", pmwin, YRP.ctr(200), YRP.ctr(50), YRP.ctr(20), YRP.ctr(200))
						pmwin.float_max = createD("DNumberWang", pmwin, YRP.ctr(200), YRP.ctr(50), YRP.ctr(20 + 200 + 20), YRP.ctr(200))

						pmwin.float_min:SetMinMax(0.1, 100.0)
						pmwin.float_max:SetMinMax(0.1, 100.0)

						pmwin.float_min:SetValue(1.0)
						pmwin.float_max:SetValue(1.0)

						function pmwin.float_min:OnValueChange(val)
							val = tonumber(val)
							maxval = tonumber(pmwin.float_max:GetValue())
							if isnumber(val) and isnumber(maxval) then
								if val > maxval then
									pmwin.float_max:SetValue(val)
								end
							end
						end
						function pmwin.float_max:OnValueChange(val)
							val = tonumber(val)
							minval = tonumber(pmwin.float_min:GetValue())
							if isnumber(val) and isnumber(minval) then
								if val < minval then
									pmwin.float_min:SetValue(val)
								end
							end
						end

						pmwin.list = createD("DPanelList", pmwin, pmwin:GetWide() - YRP.ctr(40), YRP.ctr(400), YRP.ctr(20), YRP.ctr(300))
						pmwin.list:EnableVerticalScrollbar(true)
						pmwin.list:SetSpacing(10)
						function pmwin.list:RefreshList()
							self:Clear()
							for i, pm in pairs(pmwin.pms) do
								local line = createD("DPanel", pmwin.list, YRP.ctr(200), YRP.ctr(64), 0, 0)
								line.pm = pm
								function line:Paint(pw, ph)
									draw.RoundedBox(ph / 2, 0, 0, pw, ph, Color(255, 255, 255))
									draw.SimpleText(self.pm, "DermaDefault", ph + YRP.ctr(10), ph / 2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
								end

								line.dmp = createD("DModelPanel", line, YRP.ctr(64), YRP.ctr(64), 0, 0)
								line.dmp:SetModel(pm)

								pmwin.list:AddItem(line)
							end
						end

						function pmwin:Paint(pw, ph)
							draw.RoundedBox(0, 0, 0, pw, ph, Color(80, 80, 80, 255))

							draw.SimpleText(YRP.lang_string("LID_name") .. ": ", "DermaDefault", YRP.ctr(20 + 200 + 20 + 200 + 20 + 100), YRP.ctr(50 + 20 + 25), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

							draw.SimpleText(YRP.lang_string("LID_minimumsize") .. ":", "DermaDefault", YRP.ctr(20), YRP.ctr(200), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

							draw.SimpleText(YRP.lang_string("LID_maximumsize") .. ":", "DermaDefault", YRP.ctr(20 + 200 + 20), YRP.ctr(200), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

							draw.SimpleText(YRP.lang_string("LID_models") .. ":", "DermaDefault", YRP.ctr(20), YRP.ctr(300), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
						end

						pmwin.selpm = createD("DButton", pmwin, YRP.ctr(200), YRP.ctr(50), YRP.ctr(20), YRP.ctr(50 + 20))
						pmwin.selpm:SetText(YRP.lang_string("LID_playermodels"))
						function pmwin.selpm:DoClick()
							local height = ScH() - YRP.ctr(50 + 20 + 50 + 20 + 20 + 50 + 20)
							local fx = ScW() - YRP.ctr(20 + 20)
							local br = YRP.ctr(10)
							local size = (height - 2 * br) / 3
							local space = size + br
							local x_max = fx / space - fx / space % 1
							local perpage = x_max * 3

							local pmsel = createD("DFrame", nil, ScrW(), ScrH(), 0, 0)
							pmsel:SetTitle("")
							pmsel:Center()
							pmsel:MakePopup()
							pmsel.nr = 0
							function pmsel:Paint(pw, ph)
								draw.RoundedBox(0, 0, 0, pw, ph, Color(80, 80, 80, 255))
								draw.SimpleText(YRP.lang_string("LID_search") .. ": ", "DermaDefault", YRP.ctr(20 + 100), YRP.ctr(50 + 20 + 25), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

								draw.SimpleText(YRP.lang_string("LID_page") .. ": " .. ((pmsel.nr / perpage) + 1), "DermaDefault", ScrW() / 2, ScrH() - YRP.ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
							end

							local allvalidmodels = player_manager.AllValidModels()
							local cl_pms = {}
							local c = 0
							for k, v in pairs(allvalidmodels) do
								c = c + 1
								cl_pms[c] = {}
								cl_pms[c].WorldModel = v
								cl_pms[c].ClassName = v
								cl_pms[c].PrintName = player_manager.TranslateToPlayerModelName(v)
							end

							pmsel.dpl = createD("DPanel", pmsel, ScrW() - YRP.ctr(20 * 2), height, YRP.ctr(20), YRP.ctr(50 + 20 + 50 + 20))
							function pmsel.dpl:Paint(pw, ph)
								draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 120))
							end
							--pmsel.dpl:EnableVerticalScrollbar(true)
							--pmsel.dpl:SetSpacing(10)
							function pmsel:RefreshPage()
								pmsel.dpl:Clear()
								local count = 0
								local fcount = 0
								local nothingfound = true
								local px = 0
								local py = 0

								for i, v in pairs(cl_pms) do
									if string.find(string.lower(v.PrintName), pmsel.strsearch) or string.find(string.lower(v.ClassName), pmsel.strsearch) or string.find(string.lower(v.WorldModel), pmsel.strsearch) then
										nothingfound = false
										count = count + 1
										if count > pmsel.nr and count <= pmsel.nr + perpage then
											fcount = fcount + 1
											local d_pm = createD("DPanel", pmsel.dpl, size, size, px * space, py * space)
											d_pm:SetText("")
											d_pm.WorldModel = v.WorldModel
											d_pm.ClassName = v.ClassName
											d_pm.PrintName = v.PrintName
											function d_pm:Paint(pw, ph)
												local text = YRP.lang_string("LID_notadded")
												local color = Color(255, 255, 255)
												if table.HasValue(pmwin.pms, self.WorldModel) then
													color = Color(0, 255, 0)
													text = YRP.lang_string("LID_added")
												end
												draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, color)

												draw.SimpleText(text, "DermaDefault", pw / 2, ph * 0.05, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

												draw.SimpleText(self.PrintName, "DermaDefault", pw / 2, ph * 0.90, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
												draw.SimpleText(self.WorldModel, "DermaDefault", pw / 2, ph * 0.95, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
											end

											local msize = d_pm:GetTall() * 0.75
											local mbr = (d_pm:GetTall() - msize) / 2
											local my = d_pm:GetTall() * 0.10
											if v.WorldModel != "" then
												d_pm.model = createD("DModelPanel", d_pm, msize, msize, mbr, my)
												d_pm.model:SetModel(v.WorldModel)
											else
												d_pm.model = createD("DPanel", d_pm, msize, msize, mbr, my)
												function d_pm.model:Paint(pw, ph)
													draw.RoundedBox(0, 0, 0, pw, ph, Color(80, 80, 80))
													draw.SimpleText("NO MODEL", "DermaDefault", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
												end
											end
											d_pm.btn = createD("DButton", d_pm, d_pm:GetWide(), d_pm:GetTall(), 0, 0)
											d_pm.btn:SetText("")
											function d_pm.btn:DoClick()
												if !table.HasValue(pmwin.pms, v.WorldModel) then
													table.insert(pmwin.pms, v.WorldModel)
												elseif table.HasValue(pmwin.pms, v.WorldModel) then
													table.RemoveByValue(pmwin.pms, v.WorldModel)
												end
												pmwin.list:RefreshList()
											end
											function d_pm.btn:Paint(pw, ph)

											end

											px = px + 1
											if px > x_max - 1 then
												px = 0
												py = py + 1
											end
										end
									end
								end
								if fcount <= 0 then
									pmsel.nr = pmsel.nr - perpage
									if !nothingfound then
										self:RefreshPage()
									end
								end
							end
							function pmsel:Search(strsearch)
								pmsel.strsearch = strsearch
								pmsel.nr = 0
								pmsel:RefreshPage()
							end

							pmsel.prev = createD("DButton", pmsel, YRP.ctr(200), YRP.ctr(50), ScW() / 2 - YRP.ctr(50 + 20) - YRP.ctr(200), ScH() - YRP.ctr(50 + 20))
							pmsel.prev:SetText("<")
							function pmsel.prev:DoClick()
								if pmsel.nr >= perpage then
									pmsel.nr = pmsel.nr - perpage
									pmsel:RefreshPage()
								end
							end

							pmsel.next = createD("DButton", pmsel, YRP.ctr(200), YRP.ctr(50), ScW() / 2 + YRP.ctr(50 + 20), ScH() - YRP.ctr(50 + 20))
							pmsel.next:SetText(">")
							function pmsel.next:DoClick()
								pmsel.nr = pmsel.nr + perpage
								pmsel:RefreshPage()
							end
							pmsel:Search("")

							pmsel.search = createD("DTextEntry", pmsel, ScW() - YRP.ctr(20 + 100 + 20), YRP.ctr(50), YRP.ctr(20 + 100), YRP.ctr(50 + 20))
							function pmsel.search:OnChange()
								pmsel:Search(self:GetText())
							end
						end

						pmwin.selnpm = createD("DButton", pmwin, YRP.ctr(200), YRP.ctr(50), YRP.ctr(20 + 200 + 20), YRP.ctr(50 + 20))
						pmwin.selnpm:SetText(YRP.lang_string("LID_othermodels"))
						function pmwin.selnpm:DoClick()
							local height = ScH() - YRP.ctr(50 + 20 + 50 + 20 + 20 + 50 + 20)
							local fx = ScW() - YRP.ctr(20 + 20)
							local br = YRP.ctr(10)
							local size = (height - 3 * br) / 4
							local space = size + br
							local x_max = fx / space - fx / space % 1
							local perpage = x_max * 4

							local pmsel = createD("DFrame", nil, ScrW(), ScrH(), 0, 0)
							pmsel:SetTitle("")
							pmsel:Center()
							pmsel:MakePopup()
							pmsel.nr = 0
							function pmsel:Paint(pw, ph)
								draw.RoundedBox(0, 0, 0, pw, ph, Color(80, 80, 80, 255))
								draw.SimpleText(YRP.lang_string("LID_search") .. ": ", "DermaDefault", YRP.ctr(20 + 100), YRP.ctr(50 + 20 + 25), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

								draw.SimpleText(YRP.lang_string("LID_page") .. ": " .. ((pmsel.nr / perpage) + 1), "DermaDefault", ScrW() / 2, ScrH() - YRP.ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
							end

							local noneplayermodels = {}
							for _, addon in SortedPairsByMemberValue(engine.GetAddons(), "title") do
								if (!addon.downloaded or !addon.mounted) then continue end
								AddToTabRecursive(noneplayermodels, "models/", addon.title, "*.mdl")
							end
							local cl_pms = {}
							local c = 0
							for k, v in pairs(noneplayermodels) do
								c = c + 1
								cl_pms[c] = {}
								cl_pms[c].WorldModel = v
								cl_pms[c].ClassName = v
								cl_pms[c].PrintName = v
							end

							pmsel.dpl = createD("DPanel", pmsel, ScrW() - YRP.ctr(20 * 2), height, YRP.ctr(20), YRP.ctr(50 + 20 + 50 + 20))
							function pmsel.dpl:Paint(pw, ph)
								draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 120))
							end
							--pmsel.dpl:EnableVerticalScrollbar(true)
							--pmsel.dpl:SetSpacing(10)
							function pmsel:RefreshPage()
								pmsel.dpl:Clear()
								local count = 0
								local fcount = 0
								local nothingfound = true
								local px = 0
								local py = 0

								for i, v in pairs(cl_pms) do
									if string.find(string.lower(v.PrintName), pmsel.strsearch) or string.find(string.lower(v.ClassName), pmsel.strsearch) or string.find(string.lower(v.WorldModel), pmsel.strsearch) then
										nothingfound = false
										count = count + 1
										if count > pmsel.nr and count <= pmsel.nr + perpage then
											fcount = fcount + 1
											local d_pm = createD("DPanel", pmsel.dpl, size, size, px * space, py * space)
											d_pm:SetText("")
											d_pm.WorldModel = v.WorldModel
											d_pm.ClassName = v.ClassName
											d_pm.PrintName = v.PrintName
											function d_pm:Paint(pw, ph)
												local text = YRP.lang_string("LID_notadded")
												local color = Color(255, 255, 255)
												if table.HasValue(pmwin.pms, self.WorldModel) then
													color = Color(0, 255, 0)
													text = YRP.lang_string("LID_added")
												end
												draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, color)

												draw.SimpleText(text, "DermaDefault", pw / 2, ph * 0.05, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

												draw.SimpleText(self.PrintName, "DermaDefault", pw / 2, ph * 0.90, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
												draw.SimpleText(self.WorldModel, "DermaDefault", pw / 2, ph * 0.95, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
											end

											local msize = d_pm:GetTall() * 0.75
											local mbr = (d_pm:GetTall() - msize) / 2
											local my = d_pm:GetTall() * 0.10
											if v.WorldModel != "" then
												d_pm.model = createD("DModelPanel", d_pm, msize, msize, mbr, my)
												d_pm.model:SetModel(v.WorldModel)
											else
												d_pm.model = createD("DPanel", d_pm, msize, msize, mbr, my)
												function d_pm.model:Paint(pw, ph)
													draw.RoundedBox(0, 0, 0, pw, ph, Color(80, 80, 80))
													draw.SimpleText("NO MODEL", "DermaDefault", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
												end
											end
											d_pm.btn = createD("DButton", d_pm, d_pm:GetWide(), d_pm:GetTall(), 0, 0)
											d_pm.btn:SetText("")
											function d_pm.btn:DoClick()
												if !table.HasValue(pmwin.pms, v.WorldModel) then
													table.insert(pmwin.pms, v.WorldModel)
												elseif table.HasValue(pmwin.pms, v.WorldModel) then
													table.RemoveByValue(pmwin.pms, v.WorldModel)
												end
												pmwin.list:RefreshList()
											end
											function d_pm.btn:Paint(pw, ph)

											end

											px = px + 1
											if px > x_max - 1 then
												px = 0
												py = py + 1
											end
										end
									end
								end
								if fcount <= 0 then
									pmsel.nr = pmsel.nr - perpage
									if !nothingfound then
										self:RefreshPage()
									end
								end
							end
							function pmsel:Search(strsearch)
								pmsel.strsearch = strsearch
								pmsel.nr = 0
								pmsel:RefreshPage()
							end

							pmsel.prev = createD("DButton", pmsel, YRP.ctr(200), YRP.ctr(50), ScW() / 2 - YRP.ctr(50 + 20) - YRP.ctr(200), ScH() - YRP.ctr(50 + 20))
							pmsel.prev:SetText("<")
							function pmsel.prev:DoClick()
								if pmsel.nr >= perpage then
									pmsel.nr = pmsel.nr - perpage
									pmsel:RefreshPage()
								end
							end

							pmsel.next = createD("DButton", pmsel, YRP.ctr(200), YRP.ctr(50), ScW() / 2 + YRP.ctr(50 + 20), ScH() - YRP.ctr(50 + 20))
							pmsel.next:SetText(">")
							function pmsel.next:DoClick()
								pmsel.nr = pmsel.nr + perpage
								pmsel:RefreshPage()
							end
							pmsel:Search("")

							pmsel.search = createD("DTextEntry", pmsel, ScW() - YRP.ctr(20 + 100 + 20), YRP.ctr(50), YRP.ctr(20 + 100), YRP.ctr(50 + 20))
							function pmsel.search:OnChange()
								pmsel:Search(self:GetText())
							end
						end

						pmwin.add = createD("DButton", pmwin, YRP.ctr(200), YRP.ctr(50), pmwin:GetWide() / 2 - YRP.ctr(200 / 2), pmwin:GetTall() - YRP.ctr(50 + 20))
						pmwin.add:SetText(YRP.lang_string("LID_add"))
						function pmwin.add:DoClick()
							if pmwin.WorldModel != "" then
								local min = tonumber(pmwin.float_min:GetValue())
								local max = tonumber(pmwin.float_max:GetValue())
								net.Start("add_playermodels")
									net.WriteInt(role.uniqueID, 32)
									net.WriteTable(pmwin.pms)
									net.WriteString(pmwin.name:GetText())
									net.WriteString(min)
									net.WriteString(max)
								net.SendToServer()
								pmwin:Close()
						end
						end
					end

					win.dpl = createD("DPanelList", win, YRP.ctr(800) - YRP.ctr(20 * 2), YRP.ctr(800) - YRP.ctr(50 + 20 + 50 + 20 + 20), YRP.ctr(20), YRP.ctr(50 + 20 + 50 + 20))
					win.dpl:EnableVerticalScrollbar(true)
					function win.dpl:Paint(pw, ph)
						draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255))
					end

					function win:Search(strsearch)
						self.dpl:Clear()
						for i, pm in pairs(pms) do
							if string.find(string.lower(pm.string_name), strsearch) or string.find(string.lower(pm.string_models), strsearch) then
								local line = createD("DButton", nil, YRP.ctr(800), YRP.ctr(200), 0, 0)
								line.string_name = pm.string_name
								line.models = string.Explode(",", pm.string_models)
								line:SetText("")
								function line:DoClick()
									net.Start("add_role_playermodel")
										net.WriteInt(role.uniqueID, 32)
										net.WriteInt(pm.uniqueID, 32)
									net.SendToServer()
									win:Close()
								end
								function line:Paint(pw, ph)
									draw.RoundedBox(0, 0, 0, pw, ph, Color(140, 140, 140))
									draw.SimpleText(line.string_name, "DermaDefault", line:GetTall() + YRP.ctr(20), ph / 3, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
									draw.SimpleText(line.models[1], "DermaDefault", line:GetTall() + YRP.ctr(20), ph / 3 * 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
								end

								if line.models[1] != nil then
									line.model = createD("DModelPanel", line, line:GetTall(), line:GetTall(), 0, 0)
									line.model:SetModel(line.models[1])
								else
									line.model = createD("DPanel", line, line:GetTall(), line:GetTall(), 0, 0)
									function line.model:Paint(pw, ph)
										draw.RoundedBox(0, 0, 0, pw, ph, Color(80, 80, 80))
										draw.SimpleText("NO MODEL", "DermaDefault", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
									end
								end

								win.dpl:AddItem(line)
							end
						end
					end
					win:Search("")

					win.search = createD("DTextEntry", win, win:GetWide() - YRP.ctr(20 + 150 + 20), YRP.ctr(50), YRP.ctr(20 + 150), YRP.ctr(50 + 20))
					function win.search:OnChange()
						win:Search(self:GetText())
					end
				end)
				net.Start("get_all_playermodels")
				net.SendToServer()
			end
			ea[role.uniqueID].playermodels = DStringListBox(playermodels)
			net.Receive("get_role_playermodels", function()
				local tab_pm = net.ReadTable()
				for i, v in pairs(tab_pm) do
					v.doclick = function()
						net.Start("rem_role_playermodel")
							net.WriteInt(role.uniqueID, 32)
							net.WriteInt(v.uniqueID, 32)
						net.SendToServer()
					end
					v.h = YRP.ctr(100)
				end
				if ea[role.uniqueID].playermodels.dpl.AddLines != nil then
					ea[role.uniqueID].playermodels.dpl:AddLines(tab_pm)
				end
			end)
			net.Start("get_role_playermodels")
				net.WriteInt(role.uniqueID, 32)
			net.SendToServer()

			ea.appearance:AutoSize(true)



			local equipment = createD("YGroupBox", ea.background, YRP.ctr(800), YRP.ctr(1250), ea.appearance.x,  ea.appearance.y + ea.appearance:GetTall() + YRP.ctr(20))
			equipment:SetText("LID_equipment")
			function equipment:Paint(pw, ph)
				hook.Run("YGroupBoxPaint", self, pw, ph)
			end

			ea[role.uniqueID].equipment = equipment
			ea.equipment = ea[role.uniqueID].equipment

			local sweps = {}
			sweps.parent = ea.equipment:GetContent()
			sweps.uniqueID = role.uniqueID
			sweps.header = "LID_sweps"
			sweps.netstr = "update_role_string_sweps"
			sweps.value = role.string_sweps
			sweps.uniqueID = role.uniqueID
			sweps.w = ea.equipment:GetContent():GetWide()
			sweps.h = YRP.ctr(325)
			sweps.doclick = function()
				local winswep = createD("DFrame", nil, ScrW(), ScrH(), 0, 0)
				winswep:SetTitle("")
				winswep:Center()
				winswep:MakePopup()
				function winswep:Paint(pw, ph)
					draw.RoundedBox(0, 0, 0, pw, ph, Color(80, 80, 80, 255))
					draw.SimpleText(YRP.lang_string("LID_search") .. ": ", "DermaDefault", YRP.ctr(20 + 100), YRP.ctr(50 + 25), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
				end

				local allsweps = GetSWEPsList()
				local cl_sweps = {}
				local count = 0
				for k, v in pairs(allsweps) do
					count = count + 1
					cl_sweps[count] = {}
					cl_sweps[count].WorldModel = v.WorldModel or ""
					cl_sweps[count].ClassName = v.ClassName or "NO CLASSNAME"
					cl_sweps[count].PrintName = v.PrintName or v.ClassName or "NO PRINTNAME"
				end

				winswep.dpl = createD("DPanelList", winswep, ScrW() - YRP.ctr(20 * 2), ScrH() - YRP.ctr(100 + 20), YRP.ctr(20), YRP.ctr(100))
				winswep.dpl:EnableVerticalScrollbar(true)
				local height = ScrH() - YRP.ctr(100)
				function winswep:Search(strsearch)
					self.dpl:Clear()
					for i, v in pairs(cl_sweps) do
						if string.find(string.lower(v.PrintName), strsearch) or string.find(string.lower(v.ClassName), strsearch) or string.find(string.lower(v.WorldModel), strsearch) then
							local d_swep = createD("DButton", nil, winswep.dpl:GetWide(), height / 4, 0, 0)
							d_swep:SetText(v.PrintName)
							function d_swep:DoClick()
								net.Start("add_role_swep")
									net.WriteInt(role.uniqueID, 32)
									net.WriteString(v.ClassName)
								net.SendToServer()
								winswep:Close()
							end

							if v.WorldModel != "" then
								d_swep.model = createD("DModelPanel", d_swep, d_swep:GetTall(), d_swep:GetTall(), 0, 0)
								d_swep.model:SetModel(v.WorldModel)
							else
								d_swep.model = createD("DPanel", d_swep, d_swep:GetTall(), d_swep:GetTall(), 0, 0)
								function d_swep.model:Paint(pw, ph)
									draw.RoundedBox(0, 0, 0, pw, ph, Color(80, 80, 80))
									draw.SimpleText("NO MODEL", "DermaDefault", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
								end
							end

							winswep.dpl:AddItem(d_swep)
						end
					end
				end
				winswep:Search("")

				winswep.search = createD("DTextEntry", winswep, ScrW() - YRP.ctr(20 + 100 + 20), YRP.ctr(50), YRP.ctr(20 + 100), YRP.ctr(50))
				function winswep.search:OnChange()
					winswep:Search(self:GetText())
				end
			end
			ea[role.uniqueID].sweps = DStringListBox(sweps)
			net.Receive("get_role_sweps", function()
				local tab_pm = net.ReadTable()
				local cl_sweps = {}
				for i, v in pairs(tab_pm) do
					local swep = {}
					swep.uniqueID = i
					swep.string_models = GetSwepWorldModel(v)
					swep.string_classname = v
					swep.string_name = v
					swep.doclick = function()
						net.Start("rem_role_swep")
							net.WriteInt(role.uniqueID, 32)
							net.WriteString(swep.string_classname)
						net.SendToServer()
					end
					swep.h = YRP.ctr(120)
					table.insert(cl_sweps, swep)
				end
				if ea[role.uniqueID].sweps.dpl.AddLines != nil then
					ea[role.uniqueID].sweps.dpl:AddLines(cl_sweps)
				end
			end)
			net.Start("get_role_sweps")
				net.WriteInt(role.uniqueID, 32)
			net.SendToServer()

			hr.parent = ea.equipment:GetContent()
			DHr(hr)

			-- Not droppable
			local ndsweps = {}
			ndsweps.parent = ea.equipment:GetContent()
			ndsweps.uniqueID = role.uniqueID
			ndsweps.header = "LID_ndsweps"
			ndsweps.netstr = "update_role_string_ndsweps"
			ndsweps.value = role.string_ndsweps
			ndsweps.uniqueID = role.uniqueID
			ndsweps.w = ea.equipment:GetContent():GetWide()
			ndsweps.h = YRP.ctr(325)
			ndsweps.doclick = function()
				local winndswep = createD("DFrame", nil, ScrW(), ScrH(), 0, 0)
				winndswep:SetTitle("")
				winndswep:Center()
				winndswep:MakePopup()
				function winndswep:Paint(pw, ph)
					draw.RoundedBox(0, 0, 0, pw, ph, Color(80, 80, 80, 255))
					draw.SimpleText(YRP.lang_string("LID_search") .. ": ", "DermaDefault", YRP.ctr(20 + 100), YRP.ctr(50 + 25), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
				end

				local allndsweps = GetSWEPsList()
				local cl_ndsweps = {}
				local count = 0
				for k, v in pairs(allndsweps) do
					count = count + 1
					cl_ndsweps[count] = {}
					cl_ndsweps[count].WorldModel = v.WorldModel or ""
					cl_ndsweps[count].ClassName = v.ClassName or "NO CLASSNAME"
					cl_ndsweps[count].PrintName = v.PrintName or v.ClassName or "NO PRINTNAME"
				end

				winndswep.dpl = createD("DPanelList", winndswep, ScrW() - YRP.ctr(20 * 2), ScrH() - YRP.ctr(100 + 20), YRP.ctr(20), YRP.ctr(100))
				winndswep.dpl:EnableVerticalScrollbar(true)
				local height = ScrH() - YRP.ctr(100)
				function winndswep:Search(strsearch)
					self.dpl:Clear()
					for i, v in pairs(cl_ndsweps) do
						if string.find(string.lower(v.PrintName), strsearch) or string.find(string.lower(v.ClassName), strsearch) or string.find(string.lower(v.WorldModel), strsearch) then
							local d_ndswep = createD("DButton", nil, winndswep.dpl:GetWide(), height / 4, 0, 0)
							d_ndswep:SetText(v.PrintName)
							function d_ndswep:DoClick()
								net.Start("add_role_ndswep")
									net.WriteInt(role.uniqueID, 32)
									net.WriteString(v.ClassName)
								net.SendToServer()
								winndswep:Close()
							end

							if v.WorldModel != "" then
								d_ndswep.model = createD("DModelPanel", d_ndswep, d_ndswep:GetTall(), d_ndswep:GetTall(), 0, 0)
								d_ndswep.model:SetModel(v.WorldModel)
							else
								d_ndswep.model = createD("DPanel", d_ndswep, d_ndswep:GetTall(), d_ndswep:GetTall(), 0, 0)
								function d_ndswep.model:Paint(pw, ph)
									draw.RoundedBox(0, 0, 0, pw, ph, Color(80, 80, 80))
									draw.SimpleText("NO MODEL", "DermaDefault", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
								end
							end

							winndswep.dpl:AddItem(d_ndswep)
						end
					end
				end
				winndswep:Search("")

				winndswep.search = createD("DTextEntry", winndswep, ScrW() - YRP.ctr(20 + 100 + 20), YRP.ctr(50), YRP.ctr(20 + 100), YRP.ctr(50))
				function winndswep.search:OnChange()
					winndswep:Search(self:GetText())
				end
			end
			ea[role.uniqueID].ndsweps = DStringListBox(ndsweps)
			net.Receive("get_role_ndsweps", function()
				local tab_pm = net.ReadTable()
				local cl_ndsweps = {}
				for i, v in pairs(tab_pm) do
					local ndswep = {}
					ndswep.string_models = GetSwepWorldModel(v) or "notfound"
					ndswep.string_classname = v
					ndswep.string_name = v
					ndswep.doclick = function()
						net.Start("rem_role_ndswep")
							net.WriteInt(role.uniqueID, 32)
							net.WriteString(ndswep.string_classname)
						net.SendToServer()
					end
					ndswep.h = YRP.ctr(120)
					table.insert(cl_ndsweps, ndswep)
				end
				if ea[role.uniqueID].ndsweps.dpl.AddLines != nil then
					ea[role.uniqueID].ndsweps.dpl:AddLines(cl_ndsweps)
				end
			end)
			net.Start("get_role_ndsweps")
				net.WriteInt(role.uniqueID, 32)
			net.SendToServer()

			hr.parent = ea.equipment:GetContent()
			DHr(hr)

			-- Licenses
			local licenses = {}
			licenses.parent = ea.equipment:GetContent()
			licenses.uniqueID = role.uniqueID
			licenses.header = "LID_licenses"
			licenses.netstr = "update_role_string_licenses"
			licenses.value = role.string_licenses
			licenses.uniqueID = role.uniqueID
			licenses.w = ea.equipment:GetContent():GetWide()
			licenses.h = YRP.ctr(325)
			licenses.doclick = function()
				local winlicenses = createD("DFrame", nil, ScrW(), ScrH(), 0, 0)
				winlicenses:SetTitle("")
				winlicenses:Center()
				winlicenses:MakePopup()
				function winlicenses:Paint(pw, ph)
					draw.RoundedBox(0, 0, 0, pw, ph, Color(80, 80, 80, 255))
					draw.SimpleText(YRP.lang_string("LID_search") .. ": ", "DermaDefault", YRP.ctr(20 + 100), YRP.ctr(50 + 25), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
				end

				net.Receive("get_all_licenses", function(l)
					local alllicenses = net.ReadTable()
					local cl_licenses = {}
					local count = 0
					for k, v in pairs(alllicenses) do
						count = count + 1
						cl_licenses[count] = {}
						cl_licenses[count].WorldModel = v.WorldModel or nil
						cl_licenses[count].ClassName = v.uniqueID
						cl_licenses[count].PrintName = SQL_STR_OUT(v.name)
					end

					winlicenses.dpl = createD("DPanelList", winlicenses, ScrW() - YRP.ctr(20 * 2), ScrH() - YRP.ctr(100 + 20), YRP.ctr(20), YRP.ctr(100))
					winlicenses.dpl:EnableVerticalScrollbar(true)
					local height = ScrH() - YRP.ctr(100)
					function winlicenses:Search(strsearch)
						self.dpl:Clear()
						if strsearch != nil then
							for i, v in pairs(cl_licenses) do
								v.PrintName = v.PrintName or ""
								v.ClassName = v.ClassName or ""
								v.WorldModel = v.WorldModel or ""
								if string.find(string.lower(v.PrintName), strsearch) or string.find(string.lower(v.ClassName), strsearch) or string.find(string.lower(v.WorldModel), strsearch) then
									local d_licenses = createD("DButton", nil, winlicenses.dpl:GetWide(), height / 4, 0, 0)
									d_licenses:SetText(v.PrintName)
									function d_licenses:DoClick()
										net.Start("add_role_license")
											net.WriteInt(role.uniqueID, 32)
											net.WriteString(v.ClassName)
										net.SendToServer()
										winlicenses:Close()
									end

									if v.WorldModel != "" and v.WorldModel != nil then
										d_licenses.model = createD("DModelPanel", d_licenses, d_licenses:GetTall(), d_licenses:GetTall(), 0, 0)
										d_licenses.model:SetModel(v.WorldModel)
									elseif v.WorldModel == "" then
										d_licenses.model = createD("DPanel", d_licenses, d_licenses:GetTall(), d_licenses:GetTall(), 0, 0)
										function d_licenses.model:Paint(pw, ph)
											draw.RoundedBox(0, 0, 0, pw, ph, Color(80, 80, 80))
											draw.SimpleText("NO MODEL", "DermaDefault", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
										end
									end

									winlicenses.dpl:AddItem(d_licenses)
								end
							end
						end
					end
					winlicenses:Search("")

					winlicenses.search = createD("DTextEntry", winlicenses, ScrW() - YRP.ctr(20 + 100 + 20), YRP.ctr(50), YRP.ctr(20 + 100), YRP.ctr(50))
					function winlicenses.search:OnChange()
						local searchtext = self:GetText()
						if searchtext != nil then
							winlicenses:Search(searchtext)
						end
					end
				end)
				net.Start("get_all_licenses")
				net.SendToServer()
			end
			ea[role.uniqueID].licenses = DStringListBox(licenses)
			net.Receive("get_role_licenses", function()
				local tab_li = net.ReadTable()
				local cl_licenses = {}
				for i, v in pairs(tab_li) do
					if istable(v) then
						local license = {}
						license.uniqueID = i
						license.string_models = ""
						license.string_classname = v.uniqueID
						license.string_name = SQL_STR_OUT(v.string_name)
						license.doclick = function()
							net.Start("rem_role_license")
								net.WriteInt(role.uniqueID, 32)
								net.WriteString(license.string_classname)
							net.SendToServer()
						end
						license.h = YRP.ctr(120)
						table.insert(cl_licenses, license)
					end
				end
				if ea[role.uniqueID].licenses.dpl.AddLines != nil then
					ea[role.uniqueID].licenses.dpl:AddLines(cl_licenses)
				end
			end)
			net.Start("get_role_licenses")
				net.WriteInt(role.uniqueID, 32)
			net.SendToServer()

			ea.equipment:AutoSize(true)



			local restriction = createD("YGroupBox", ea.background, YRP.ctr(800), YRP.ctr(800), YRP.ctr(1660), YRP.ctr(20))
			restriction:SetText("LID_restriction")
			function restriction:Paint(pw, ph)
				hook.Run("YGroupBoxPaint", self, pw, ph)
			end

			ea[role.uniqueID].restriction = restriction
			ea.restriction = ea[role.uniqueID].restriction

			hr.parent = ea.restriction:GetContent()

			if role.uniqueID != 1 then
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
					ugs["ALL"]["choices"][string.upper(ug.string_name)] = ugs["ALL"]["choices"][string.upper(ug.string_name)] or {}
					ugs["ALL"]["choices"][string.upper(ug.string_name)].checked = table.HasValue(gugs, string.upper(ug.string_name))
				end

				local usergroups = {}
				usergroups.parent = ea.restriction:GetContent()
				usergroups.uniqueID = role.uniqueID
				usergroups.header = "LID_usergroups"
				usergroups.netstr = "update_role_string_usergroups"
				usergroups.value = role.string_usergroups
				usergroups.uniqueID = role.uniqueID
				usergroups.lforce = false
				usergroups.choices = ugs
				ea[role.uniqueID].usergroups = DCheckBoxes(usergroups)

				DHr(hr)
			end

			if role.uniqueID != 1 then
				local requireslevel = {}
				requireslevel.parent = ea.restriction:GetContent()
				requireslevel.header = "LID_requireslevel"
				requireslevel.netstr = "update_role_int_requireslevel"
				requireslevel.value = role.int_requireslevel
				requireslevel.uniqueID = role.uniqueID
				requireslevel.lforce = false
				requireslevel.min = 1
				requireslevel.max = 100
				ea[role.uniqueID].requireslevel = DIntBox(requireslevel)

				DHr(hr)
			end

			local bool_voiceglobal = {}
			bool_voiceglobal.parent = ea.restriction:GetContent()
			bool_voiceglobal.uniqueID = role.uniqueID
			bool_voiceglobal.header = "LID_canuseglobalvoicechat"
			bool_voiceglobal.netstr = "update_role_bool_voiceglobal"
			bool_voiceglobal.value = role.bool_voiceglobal
			bool_voiceglobal.uniqueID = role.uniqueID
			bool_voiceglobal.lforce = false
			ea[role.uniqueID].bool_voiceglobal = DCheckBox(bool_voiceglobal)

			DHr(hr)

			if role.uniqueID != 1 then
				local whitelist = {}
				whitelist.parent = ea.restriction:GetContent()
				whitelist.uniqueID = role.uniqueID
				whitelist.header = "LID_useswhitelist"
				whitelist.netstr = "update_role_bool_whitelist"
				whitelist.value = role.bool_whitelist
				whitelist.uniqueID = role.uniqueID
				whitelist.lforce = false
				ea[role.uniqueID].whitelist = DCheckBox(whitelist)

				DHr(hr)
			end

			if role.uniqueID != 1 then
				local locked = {}
				locked.parent = ea.restriction:GetContent()
				locked.uniqueID = role.uniqueID
				locked.header = "LID_locked"
				locked.netstr = "update_role_bool_locked"
				locked.value = role.bool_locked
				locked.uniqueID = role.uniqueID
				locked.lforce = false
				ea[role.uniqueID].locked = DCheckBox(locked)

				DHr(hr)
			end

			if role.uniqueID != 1 then
				local visible = {}
				visible.parent = ea.restriction:GetContent()
				visible.uniqueID = role.uniqueID
				visible.header = "LID_visible"
				visible.netstr = "update_role_bool_visible"
				visible.value = role.bool_visible
				visible.uniqueID = role.uniqueID
				visible.lforce = false
				ea[role.uniqueID].visible = DCheckBox(visible)

				DHr(hr)
			end

			if role.uniqueID != 1 then
				local bool_voteable = {}
				bool_voteable.parent = ea.restriction:GetContent()
				bool_voteable.uniqueID = role.uniqueID
				bool_voteable.header = "LID_voteable"
				bool_voteable.netstr = "update_role_bool_voteable"
				bool_voteable.value = role.bool_voteable
				bool_voteable.uniqueID = role.uniqueID
				bool_voteable.lforce = false
				ea[role.uniqueID].bool_voteable = DCheckBox(bool_voteable)

				DHr(hr)
			end

			local cooldown = {}
			cooldown.parent = ea.restriction:GetContent()
			cooldown.header = "LID_cooldown"
			cooldown.netstr = "update_role_int_cooldown"
			cooldown.value = role.int_cooldown
			cooldown.uniqueID = role.uniqueID
			cooldown.lforce = false
			cooldown.min = 0
			cooldown.max = 360
			ea[role.uniqueID].cooldown = DIntBox(cooldown)

			ea.restriction:AutoSize(true)



			local attributes = createD("YGroupBox", ea.background, YRP.ctr(800), YRP.ctr(1000), ea.restriction.x, ea.restriction.y + ea.restriction:GetTall() + YRP.ctr(20))
			attributes:SetText("LID_attributes")
			function attributes:Paint(pw, ph)
				hook.Run("YGroupBoxPaint", self, pw, ph)
			end

			ea[role.uniqueID].attributes = attributes
			ea.attributes = ea[role.uniqueID].attributes

			local health = {}
			health.parent = ea.attributes:GetContent()
			health.uniqueID = role.uniqueID
			health.header = "LID_health"
			health.netstr = "hp"
			health.uniqueID = role.uniqueID
			health.lforce = false

			health.dnw = {}

			health.dnw[1] = {}
			health.dnw[1].value = role.int_hp
			health.dnw[1].min = 1
			health.dnw[1].max = GetMaxInt()
			health.dnw[1].netstr = "update_role_" .. "int_" .. "hp"

			health.dnw[2] = {}
			health.dnw[2].value = role.int_hpmax
			health.dnw[2].min = 1
			health.dnw[2].max = GetMaxInt()
			health.dnw[2].netstr = "update_role_" .. "int_" .. "hpmax"

			health.dnw[3] = {}
			health.dnw[3].value = role.int_hpup
			health.dnw[3].min = -GetMaxInt()
			health.dnw[3].max = GetMaxInt()
			health.dnw[3].netstr = "update_role_" .. "int_" .. "hpup"

			health.color = Color(0, 255, 0)
			health.color2 = Color(100, 255, 100)
			ea[role.uniqueID].health = DAttributeBar(health)

			hr.parent = ea.attributes:GetContent()
			DHr(hr)

			local armor = {}
			armor.parent = ea.attributes:GetContent()
			armor.uniqueID = role.uniqueID
			armor.header = "LID_armor"
			armor.netstr = "ar"
			armor.uniqueID = role.uniqueID
			armor.lforce = false

			armor.dnw = {}

			armor.dnw[1] = {}
			armor.dnw[1].value = role.int_ar
			armor.dnw[1].min = 0
			armor.dnw[1].max = GetMaxInt()
			armor.dnw[1].netstr = "update_role_" .. "int_" .. "ar"

			armor.dnw[2] = {}
			armor.dnw[2].value = role.int_armax
			armor.dnw[2].min = 1
			armor.dnw[2].max = GetMaxInt()
			armor.dnw[2].netstr = "update_role_" .. "int_" .. "armax"

			armor.dnw[3] = {}
			armor.dnw[3].value = role.int_arup
			armor.dnw[3].min = -GetMaxInt()
			armor.dnw[3].max = GetMaxInt()
			armor.dnw[3].netstr = "update_role_" .. "int_" .. "arup"

			armor.color = Color(0, 0, 255)
			armor.color2 = Color(100, 100, 255)
			ea[role.uniqueID].armor = DAttributeBar(armor)

			DHr(hr)

			local stamina = {}
			stamina.parent = ea.attributes:GetContent()
			stamina.uniqueID = role.uniqueID
			stamina.header = "LID_stamina"
			stamina.netstr = "st"
			stamina.uniqueID = role.uniqueID
			stamina.lforce = false

			stamina.dnw = {}

			stamina.dnw[1] = {}
			stamina.dnw[1].value = role.int_st
			stamina.dnw[1].min = 1
			stamina.dnw[1].max = GetMaxInt()
			stamina.dnw[1].netstr = "update_role_" .. "int_" .. "st"

			stamina.dnw[2] = {}
			stamina.dnw[2].value = role.int_stmax
			stamina.dnw[2].min = 1
			stamina.dnw[2].max = GetMaxInt()
			stamina.dnw[2].netstr = "update_role_" .. "int_" .. "stmax"

			stamina.dnw[3] = {}
			stamina.dnw[3].value = role.float_stup
			stamina.dnw[3].min = -GetMaxFloat()
			stamina.dnw[3].max = GetMaxFloat()
			stamina.dnw[3].netstr = "update_role_" .. "float_" .. "stup"

			stamina.dnw[4] = {}
			stamina.dnw[4].value = role.float_stdn
			stamina.dnw[4].min = -GetMaxFloat()
			stamina.dnw[4].max = GetMaxFloat()
			stamina.dnw[4].netstr = "update_role_" .. "float_" .. "stdn"

			stamina.color = Color(255, 255, 0)
			stamina.color2 = Color(200, 200, 0)
			stamina.color3 = Color(160, 160, 0)
			ea[role.uniqueID].stamina = DAttributeBar(stamina)

			DHr(hr)

			local speedwalk = {}
			speedwalk.parent = ea.attributes:GetContent()
			speedwalk.header = "LID_walkspeed"
			speedwalk.netstr = "update_role_int_speedwalk"
			speedwalk.value = role.int_speedwalk or -1
			speedwalk.uniqueID = role.uniqueID
			speedwalk.lforce = false
			speedwalk.min = 1
			speedwalk.max = 999999
			ea[role.uniqueID].speedwalk = DIntBox(speedwalk)

			DHr(hr)

			local speedrun = {}
			speedrun.parent = ea.attributes:GetContent()
			speedrun.header = "LID_runspeed"
			speedrun.netstr = "update_role_int_speedrun"
			speedrun.value = role.int_speedrun or -1
			speedrun.uniqueID = role.uniqueID
			speedrun.lforce = false
			speedrun.min = 1
			speedrun.max = 999999
			ea[role.uniqueID].speedrun = DIntBox(speedrun)

			DHr(hr)

			local powerjump = {}
			powerjump.parent = ea.attributes:GetContent()
			powerjump.header = "LID_jumppower"
			powerjump.netstr = "update_role_int_powerjump"
			powerjump.value = role.int_powerjump or -1
			powerjump.uniqueID = role.uniqueID
			powerjump.lforce = false
			powerjump.min = 1
			powerjump.max = 999999
			ea[role.uniqueID].powerjump = DIntBox(powerjump)

			ea.attributes:AutoSize(true)
		end)

		net.Receive("settings_subscribe_rolelist", function(le)
			if pa(rs.rplist) then
				rs.rplist:ClearList()

				local roles = net.ReadTable()
				local headername = net.ReadString()
				rs.top.headername = headername

				cur_role.gro = tonumber(net.ReadString())
				cur_role.pre = tonumber(net.ReadString())

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
