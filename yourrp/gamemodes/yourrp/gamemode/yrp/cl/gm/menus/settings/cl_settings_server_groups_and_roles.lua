--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

--#roles #groups #settings

net.Receive("Subscribe_Settings_GroupsAndRoles", function(len)
	local PARENT = GetSettingsSite()
	if pa(PARENT) then
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

		gs.bac = createD("YButton", PARENT, YRP.ctr(60), YRP.ctr(60), YRP.ctr(20), YRP.ctr(20))
		gs.bac:SetText("")
		function gs.bac:Paint(pw, ph)
			if cur_group.cur > 0 then
				local tab = {}
				tab.color = Color(255, 255, 0)
				DrawPanel(self, tab)
				local tab2 = {}
				tab2.x = pw / 2
				tab2.y = ph / 2
				tab2.ax = 1
				tab2.ay = 1
				tab2.text = "◀"
				tab2.font = "Y_18_500"
				DrawText(tab2)
			else
				local tab = {}
				tab.color = YRPGetColor("3")
				DrawPanel(self, tab)
			end
		end
		function gs.bac:DoClick()
			if cur_group.cur > 0 then
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
			tab2.font = "Y_18_500"
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

		gs.add = createD("YButton", PARENT, YRP.ctr(60), YRP.ctr(60), YRP.ctr(20 + 800 - 60), YRP.ctr(20))
		gs.add:SetText("+")
		function gs.add:Paint(pw, ph)
			hook.Run("YButtonAPaint", self, pw, ph)
		end
		function gs.add:DoClick()
			net.Start("settings_add_group")
				net.WriteString(cur_group.cur)
			net.SendToServer()
		end

		gs.glist = createD("DPanel", PARENT, YRP.ctr(800), YRP.ctr(840), YRP.ctr(20), YRP.ctr(80))
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
				TestHTML(gs.gplist[_uid].ico, gs.gplist[_uid].string_icon, false)
			end
		end)

		function CreateLineGroup(parent, group)
			group.uniqueID = tonumber(group.uniqueID)
			gs.gplist[group.uniqueID] = gs.gplist[group.uniqueID] or {}
			gs.gplist[group.uniqueID] = createD("YButton", parent, parent:GetWide() - YRP.ctr(20), YRP.ctr(120), 0, 0)
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
				tab2.font = "Y_18_500"
				tab2.lforce = false
				DrawText(tab2)

				--[[local tab3 = {}
				tab3.x = YRP.ctr(182)
				tab3.y = YRP.ctr(100)
				tab3.ax = 0
				tab3.ay = 4
				tab3.text = "POSITION: " .. group.int_position
				tab3.font = "Y_18_500"
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
			TestHTML(ico, group.string_icon, false)

			gs.gplist[group.uniqueID].up = createD("YButton", gs.gplist[group.uniqueID], YRP.ctr(40), YRP.ctr(40), YRP.ctr(10), YRP.ctr(10))
			gs.gplist[group.uniqueID].up:SetText("")
			local up = gs.gplist[group.uniqueID].up
			function up:Paint(pw, ph)
				if gs.gplist[group.uniqueID].int_position > 1 then
					hook.Run("YButtonPaint", self, pw, ph)

					if YRP.GetDesignIcon("64_angle-up") then
						surface.SetDrawColor(255, 255, 255, 255)
						surface.SetMaterial(YRP.GetDesignIcon("64_angle-up"))
						surface.DrawTexturedRect(0, 0, pw, ph)
					end
				end
			end
			function up:DoClick()
				net.Start("settings_group_position_up")
					net.WriteString(gs.gplist[group.uniqueID].uniqueID)
				net.SendToServer()
			end

			gs.gplist[group.uniqueID].dn = createD("YButton", gs.gplist[group.uniqueID], YRP.ctr(40), YRP.ctr(40), YRP.ctr(10), gs.gplist[group.uniqueID]:GetTall() - YRP.ctr(40 + 10))
			gs.gplist[group.uniqueID].dn:SetText("")
			local dn = gs.gplist[group.uniqueID].dn
			function dn:Paint(pw, ph)
				if gs.gplist[group.uniqueID].int_position < table.Count(gs.gplist.tab) then
					hook.Run("YButtonPaint", self, pw, ph)

					if YRP.GetDesignIcon("64_angle-down") then
						surface.SetDrawColor(255, 255, 255, 255)
						surface.SetMaterial(YRP.GetDesignIcon("64_angle-down"))
						surface.DrawTexturedRect(0, 0, pw, ph)
					end
				end
			end
			function dn:DoClick()
				net.Start("settings_group_position_dn")
					net.WriteString(gs.gplist[group.uniqueID].uniqueID)
				net.SendToServer()
			end

			gs.gplist[group.uniqueID].ch = createD("YButton", gs.gplist[group.uniqueID], YRP.ctr(40), YRP.ctr(40), gs.gplist[group.uniqueID]:GetWide() - YRP.ctr(66), gs.gplist[group.uniqueID]:GetTall() - YRP.ctr(60))
			gs.gplist[group.uniqueID].ch:SetText("")
			local ch = gs.gplist[group.uniqueID].ch
			surface.SetFont("Y_14_500")
			local text = YRP.lang_string("LID_undergroups") .. " ▶"
			local tw, _ = surface.GetTextSize(text)
			tw = tw + YRP.ctr(20)
			ch:SetWide(tw)
			ch:SetPos(gs.gplist[group.uniqueID]:GetWide() - tw - YRP.ctr(10 + 10), gs.gplist[group.uniqueID]:GetTall() - YRP.ctr(40 + 10))
			function ch:Paint(pw, ph)
				local tab = {}
				tab.color = Color(255, 255, 100)
				DrawPanel(self, tab)
				local tab2 = {}
				tab2.x = pw / 2
				tab2.y = ph / 2
				tab2.ax = 1
				tab2.ay = 1
				tab2.text = text
				tab2.font = "Y_14_500"
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
					group.uniqueID = tonumber(group.uniqueID)
					if group.uniqueID > 0 then
						CreateLineGroup(gs.gplist, group)
						group["int_position"] = tonumber(group["int_position"])
					end
				end

				gs.gplist:SortByMember("int_position", true)
				gs.gplist:Rebuild()
			end
		end)

		net.Start("settings_subscribe_grouplist")
			net.WriteString(cur_group.par)
		net.SendToServer()

		rs.top = createD("DPanel", PARENT, YRP.ctr(800-120), YRP.ctr(60), YRP.ctr(80), YRP.ctr(940))
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
				tab2.font = "Y_18_500"
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

		rs.bac = createD("YButton", PARENT, YRP.ctr(60), YRP.ctr(60), YRP.ctr(20), YRP.ctr(940))
		rs.bac:SetText("")
		function rs.bac:Paint(pw, ph)
			if wk(cur_role.pre) then
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
							tab2.font = "Y_18_500"
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
		end
		function rs.bac:DoClick()
			if wk(cur_role.pre) then
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
		end

		rs.add = createD("YButton", PARENT, YRP.ctr(60), YRP.ctr(60), YRP.ctr(20 + 800 - 60), YRP.ctr(940))
		rs.add:SetText("+")
		function rs.add:Paint(pw, ph)
			if rs.top.headername != nil then
				hook.Run("YButtonAPaint", self, pw, ph)
			end
		end
		function rs.add:DoClick()
			if rs.top.headername != nil and cur_role.gro != nil and cur_role.pre != nil then
				net.Start("settings_add_role")
					net.WriteString(cur_role.gro)
					net.WriteString(cur_role.pre)
				net.SendToServer()
			end
		end

		rs.rlist = createD("DPanel", PARENT, YRP.ctr(800), YRP.ctr(840), YRP.ctr(20), YRP.ctr(1000))
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

		net.Receive("settings_role_update_name", function(le)
			if pa(rs.rplist) then
				local _uid = tonumber(net.ReadString())
				local name = net.ReadString()
				rs.rplist[_uid].text = name
			end
		end)

		net.Receive("settings_role_update_color", function(le)
			if pa(rs) then
				local _uid = tonumber(net.ReadString())
				local color = net.ReadString()
				if isnumber(_uid) and rs.rplist[_uid] != nil then
					rs.rplist[_uid].string_color = stc(color)
				end
			end
		end)

		net.Receive("settings_role_update_icon", function(le)
			if pa(rs.rplist) then
				local _uid = tonumber(net.ReadString())
				local icon = net.ReadString()
				if pa(rs.rplist[_uid]) then
					rs.rplist[_uid].string_icon = icon
					rs.rplist[_uid].ico:SetHTML(GetHTMLImage(rs.rplist[_uid].string_icon, rs.rplist[_uid].ico:GetWide(), rs.rplist[_uid].ico:GetTall()))
					TestHTML(rs.rplist[_uid].ico, rs.rplist[_uid].string_icon, false)
				end
			end
		end)

		PARENT.ea = {}
		local ea = PARENT.ea

		ea.background = createD("DHorizontalScroller", PARENT, PARENT:GetWide() - YRP.ctr(860), PARENT:GetTall() - YRP.ctr(20 + 60 + 20), YRP.ctr(840), YRP.ctr(20 + 60))
		ea.background:SetOverlap(-YRP.ctr(20))
		--[[function ea.background:Paint(pw, ph)
			if ea.typ != nil then
				local tab = {}
				tab.color = Color(20, 20, 20, 255)
				DrawPanel(self, tab)
			end
		end]]

		ea.del = createD("YButton", PARENT, YRP.ctr(60), YRP.ctr(60), YRP.ctr(840), YRP.ctr(20))
		ea.del:SetText("-")
		function ea.del:Paint(pw, ph)
			if ea.typ != nil and tonumber(ea.tab.uniqueID) != 1 then
				hook.Run("YButtonRPaint", self, pw, ph)
			elseif ea.typ != nil then
				local tab = {}
				tab.color = YRPGetColor("3")
				DrawPanel(self, tab)
			end
		end
		function ea.del:DoClick()
			if ea.typ == "group" and tonumber(ea.tab.uniqueID) != 1 then
				local win = createD("YFrame", nil, YRP.ctr(660), YRP.ctr(300), 0, 0)
				win:SetHeaderHeight(YRP.ctr(100))
				win:Center()
				win:MakePopup()
				win:SetTitle(YRP.lang_string("LID_areyousure"))
				function win:Paint(pw, ph)
					hook.Run("YFramePaint", self, pw, ph)
				end
				local content = win:GetContent()
				function content:Paint(pw, ph)
					draw.SimpleText("Recursive", "DermaDefault",  YRP.ctr(60), YRP.ctr(50 + 20 + 25), Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end

				local recursive = createD("DCheckBox", win:GetContent(), YRP.ctr(50), YRP.ctr(50), 0, YRP.ctr(50 + 20))

				local _yes = createD("YButton", win:GetContent(), YRP.ctr(300), YRP.ctr(50), 0, 0)
				_yes:SetText(YRP.lang_string("LID_yes"))
				function _yes:DoClick()
					net.Start("settings_delete_group")
						net.WriteString(ea.tab.uniqueID)
						net.WriteBool(recursive:GetValue())
					net.SendToServer()

					ea.background:Clear()

					ea.typ = nil
					ea.tab = nil
					win:Close()
				end

				local _no = createD("YButton", win:GetContent(), YRP.ctr(300), YRP.ctr(50), YRP.ctr(320), 0)
				_no:SetText(YRP.lang_string("LID_no"))
				function _no:DoClick()
					win:Close()
				end
			elseif ea.typ == "role" and wk(ea.tab.uniqueID) and tonumber(ea.tab.uniqueID) != 1 then
				net.Start("settings_delete_role")
					net.WriteString(ea.tab.uniqueID)
				net.SendToServer()

				ea.background:Clear()

				ea.typ = nil
				ea.tab = nil
			end
		end

		ea.dup = createD("YButton", PARENT, YRP.ctr(60), YRP.ctr(60), YRP.ctr(900), YRP.ctr(20))
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
					tab2.font = "Y_18_500"
					DrawText(tab2)
				end
			elseif ea.typ != nil then
				local tab = {}
				tab.color = YRPGetColor("3")
				DrawPanel(self, tab)
			end
		end
		function ea.dup:DoClick()
			if ea.tab.uniqueID != nil and ea.tab.uniqueID != 1 then
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


		ea.top = createD("DPanel", PARENT, PARENT:GetWide() - YRP.ctr(980), YRP.ctr(60), YRP.ctr(960), YRP.ctr(20))
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
				if ea.typ == "role" and ea.tab.uniqueID != nil then
					tab2.text = tab2.text .. "       DarkRP-Job-Name: " .. ConvertToDarkRPJobName(ea.tab.string_name) .. "      RoleUID: " .. ea.tab.uniqueID
				elseif ea.typ == "group" and ea.tab.uniqueID != nil then
					tab2.text = tab2.text .. "       GroupUID: " .. ea.tab.uniqueID
				end
				tab2.font = "Y_18_500"
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
			if group.uniqueID > 0 then
				cur_group.edi = group.uniqueID

				ea.typ = "group"
				ea.tab = group

				ea[group.uniqueID] = ea[group.uniqueID] or {}

				ea.background:Clear()

				local col1 = createD("DPanelList", ea.background, YRP.ctr(1000), ea.background:GetTall() - YRP.ctr(40), YRP.ctr(20), YRP.ctr(20))
				col1:SetSpacing(YRP.ctr(20))

				local info = createD("YGroupBox", col1, YRP.ctr(1000), YRP.ctr(920), YRP.ctr(0), YRP.ctr(0))
				info:SetText("LID_general")
				function info:Paint(pw, ph)
					hook.Run("YGroupBoxPaint", self, pw, ph)
				end
				col1:AddItem(info)

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

				local desc = {}
				desc.parent = ea.info:GetContent()
				desc.uniqueID = group.uniqueID
				desc.header = "LID_description"
				desc.netstr = "update_group_string_description"
				desc.value = group.string_description
				desc.uniqueID = group.uniqueID
				desc.lforce = false
				desc.multiline = true
				desc.h = 140
				ea[group.uniqueID].desc = DTextBox(desc)

				DHr(hr)

				local othergroups = {}
				othergroups[0] = YRP.lang_string("LID_factions")
				for i, tab in pairs(groups) do
					tab.uniqueID = tonumber(tab.uniqueID)
					group.uniqueID = tonumber(group.uniqueID)
					if tab.uniqueID > 0 and tab.uniqueID != group.uniqueID then
						othergroups[tab.uniqueID] = tab.string_name --.. " [UID: " .. tab.uniqueID .. "]"
					end
				end

				if group.uniqueID > 1 then
					local parentgroup = {}
					parentgroup.parent = ea.info:GetContent()
					parentgroup.uniqueID = group.uniqueID
					parentgroup.header = "LID_parentgroup"
					parentgroup.netstr = "update_group_int_parentgroup"
					parentgroup.value = tonumber(group.int_parentgroup)
					parentgroup.uniqueID = group.uniqueID
					parentgroup.lforce = false
					parentgroup.choices = othergroups
					ea[group.uniqueID].parentgroup = YRPDComboBox(parentgroup)
				end

				DHr(hr)

				local iscp = {}
				iscp.parent = ea.info:GetContent()
				iscp.uniqueID = group.uniqueID
				iscp.header = "LID_iscp"
				iscp.netstr = "update_group_bool_iscp"
				iscp.value = group.bool_iscp
				iscp.uniqueID = group.uniqueID
				ea[group.uniqueID].iscp = YRPDCheckBox(iscp)



				local restriction = createD("YGroupBox", col1, YRP.ctr(1000), YRP.ctr(570), YRP.ctr(0), YRP.ctr(0))
				restriction:SetText("LID_restriction")
				function restriction:Paint(pw, ph)
					hook.Run("YGroupBoxPaint", self, pw, ph)
				end
				col1:AddItem(restriction)

				ea.background:AddPanel(col1)

				ea[group.uniqueID].restriction = restriction
				ea.restriction = ea[group.uniqueID].restriction

				hr.parent = ea.restriction:GetContent()

				if group.uniqueID > 1 then
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
						if ug.string_name != nil then
							ugs["ALL"]["choices"][string.upper(ug.string_name)] = ugs["ALL"]["choices"][string.upper(ug.string_name)] or {}
							ugs["ALL"]["choices"][string.upper(ug.string_name)].checked = table.HasValue(gugs, string.upper(ug.string_name))
						else
							YRP.msg("note", "WHATS THAT? #1")
							pFTab(ug)
						end
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
					ea[group.uniqueID].usergroups = YRPDCheckBoxes(usergroups)

					DHr(hr)
				end

				if group.uniqueID > 1 then
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

					DHr(hr)
				end

				if group.uniqueID > 1 then
					local whitelist = {}
					whitelist.parent = ea.restriction:GetContent()
					whitelist.uniqueID = group.uniqueID
					whitelist.header = "LID_useswhitelist"
					whitelist.netstr = "update_group_bool_whitelist"
					whitelist.value = group.bool_whitelist
					whitelist.uniqueID = group.uniqueID
					whitelist.lforce = false
					ea[group.uniqueID].whitelist = YRPDCheckBox(whitelist)

					DHr(hr)
				end

				if group.uniqueID != 1 then
					local locked = {}
					locked.parent = ea.restriction:GetContent()
					locked.uniqueID = group.uniqueID
					locked.header = "LID_locked"
					locked.netstr = "update_group_bool_locked"
					locked.value = group.bool_locked
					locked.uniqueID = group.uniqueID
					locked.lforce = false
					ea[group.uniqueID].locked = YRPDCheckBox(locked)

					DHr(hr)
					
					local visible = {}
					visible.parent = ea.restriction:GetContent()
					visible.uniqueID = group.uniqueID
					visible.header = YRP.lang_string("LID_visible") .. " (" .. YRP.lang_string("LID_charactercreation") .. ")"
					visible.netstr = "update_group_bool_visible_cc"
					visible.value = group.bool_visible_cc
					visible.uniqueID = group.uniqueID
					visible.lforce = false
					ea[group.uniqueID].visible = YRPDCheckBox(visible)

					DHr(hr)

					local visible2 = {}
					visible2.parent = ea.restriction:GetContent()
					visible2.uniqueID = group.uniqueID
					visible2.header = YRP.lang_string("LID_visible") .. " (" .. YRP.lang_string("LID_rolemenu") .. ")"
					visible2.netstr = "update_group_bool_visible_rm"
					visible2.value = group.bool_visible_rm
					visible2.uniqueID = group.uniqueID
					visible2.lforce = false
					ea[group.uniqueID].visible2 = YRPDCheckBox(visible2)
				end
			end
		end)

		function CreateLineRole(parent, role)
			role.uniqueID = tonumber(role.uniqueID)
			rs.rplist[role.uniqueID] = rs.rplist[role.uniqueID] or {}
			rs.rplist[role.uniqueID] = createD("YButton", parent, parent:GetWide() - YRP.ctr(20), YRP.ctr(120), 0, 0)
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
				tab2.font = "Y_18_500"
				tab2.lforce = false
				DrawText(tab2)

				--[[local tab3 = {}
				tab3.x = YRP.ctr(182)
				tab3.y = YRP.ctr(100)
				tab3.ax = 0
				tab3.ay = 4
				tab3.text = "POSITION: " .. role.int_position
				tab3.font = "Y_18_500"
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
			TestHTML(ico, role.string_icon, false)

			rs.rplist[role.uniqueID].up = createD("YButton", rs.rplist[role.uniqueID], YRP.ctr(40), YRP.ctr(40), YRP.ctr(10), YRP.ctr(10))
			rs.rplist[role.uniqueID].up:SetText("")
			local up = rs.rplist[role.uniqueID].up
			function up:Paint(pw, ph)
				if rs.rplist[role.uniqueID].int_position > 1 then
					hook.Run("YButtonPaint", self, pw, ph)

					if YRP.GetDesignIcon("64_angle-up") then
						surface.SetDrawColor(255, 255, 255, 255)
						surface.SetMaterial(YRP.GetDesignIcon("64_angle-up"))
						surface.DrawTexturedRect(0, 0, pw, ph)
					end
				end
			end
			function up:DoClick()
				net.Start("settings_role_position_up")
					net.WriteString(rs.rplist[role.uniqueID].uniqueID)
				net.SendToServer()
			end

			rs.rplist[role.uniqueID].dn = createD("YButton", rs.rplist[role.uniqueID], YRP.ctr(40), YRP.ctr(40), YRP.ctr(10), rs.rplist[role.uniqueID]:GetTall() - YRP.ctr(40 + 10))
			rs.rplist[role.uniqueID].dn:SetText("")
			local dn = rs.rplist[role.uniqueID].dn
			function dn:Paint(pw, ph)
				if rs.rplist[role.uniqueID].int_position < table.Count(rs.rplist.tab) then
					hook.Run("YButtonPaint", self, pw, ph)

					if YRP.GetDesignIcon("64_angle-down") then
						surface.SetDrawColor(255, 255, 255, 255)
						surface.SetMaterial(YRP.GetDesignIcon("64_angle-down"))
						surface.DrawTexturedRect(0, 0, pw, ph)
					end
				end
			end
			function dn:DoClick()
				net.Start("settings_role_position_dn")
					net.WriteString(rs.rplist[role.uniqueID].uniqueID)
				net.SendToServer()
			end

			rs.rplist[role.uniqueID].ch = createD("YButton", rs.rplist[role.uniqueID], YRP.ctr(40), YRP.ctr(40), rs.rplist[role.uniqueID]:GetWide() - YRP.ctr(66), rs.rplist[role.uniqueID]:GetTall() - YRP.ctr(60))
			rs.rplist[role.uniqueID].ch:SetText("")
			local ch = rs.rplist[role.uniqueID].ch
			local text = YRP.lang_string("LID_nextranks") .. " ▶"
			surface.SetFont("Y_14_500")
			local tw, _ = surface.GetTextSize(text)
			tw = tw + YRP.ctr(20)
			ch:SetWide(tw)
			ch:SetPos(rs.rplist[role.uniqueID]:GetWide() - tw - YRP.ctr(10 + 10), rs.rplist[role.uniqueID]:GetTall() - YRP.ctr(40 + 10))
			function ch:Paint(pw, ph)
				local tab = {}
				tab.color = Color(255, 255, 100)
				DrawPanel(self, tab)
				local tab2 = {}
				tab2.x = pw / 2
				tab2.y = ph / 2
				tab2.ax = 1
				tab2.ay = 1
				tab2.text = text
				tab2.font = "Y_14_500"
				DrawText(tab2)
			end
			function ch:DoClick()
				rs.rplist:ClearList()
				net.Start("settings_unsubscribe_rolelist")
					net.WriteString(cur_role.gro)
					net.WriteString(cur_role.pre)
				net.SendToServer()
				timer.Simple(0.1, function()
					if pa(rs.rplist) then
						net.Start("settings_subscribe_rolelist")
							net.WriteString(cur_role.gro)
							net.WriteString(rs.rplist[role.uniqueID].uniqueID)
						net.SendToServer()
					end
				end)
			end

			parent:AddItem(rs.rplist[role.uniqueID])
		end

		net.Receive("settings_subscribe_role", function(le)
			local role = net.ReadTable()
			local roles = net.ReadTable()
			local db_ugs = net.ReadTable()
			local db_groups = net.ReadTable()

			if !wk(db_groups) or !wk(db_ugs) or !wk(roles) or !wk(role) then
				return
			end

			role.uniqueID = tonumber(role.uniqueID)
			cur_role.gro = role.int_groupID
			cur_role.edi = role.uniqueID

			if !pa(ea) then
				YRP.msg("note", "Closed F8/Switched f8 site?")
				return
			end

			ea.typ = "role"
			ea.tab = role

			if role.uniqueID == nil then return end
			
			ea[role.uniqueID] = ea[role.uniqueID] or {}

			ea.background:Clear()

			local col1 = createD("DPanelList", ea.background, YRP.ctr(800), ea.background:GetTall() - YRP.ctr(40), YRP.ctr(20), YRP.ctr(20))
			col1:SetSpacing(YRP.ctr(20))

			local info = createD("YGroupBox", col1, YRP.ctr(800), YRP.ctr(866), YRP.ctr(20), YRP.ctr(20))
			info:SetText("LID_general")
			function info:Paint(pw, ph)
				hook.Run("YGroupBoxPaint", self, pw, ph)
			end
			col1:AddItem(info)

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

			--[[local idstructure = {}
			idstructure.parent = ea.info:GetContent()
			idstructure.uniqueID = role.uniqueID
			idstructure.header = YRP.lang_string("LID_idstructure") .. " (!D 1Dig., !L 1Let., !N 1Num.)"
			idstructure.netstr = "update_role_string_idstructure"
			idstructure.value = role.string_idstructure
			idstructure.uniqueID = role.uniqueID
			idstructure.lforce = false
			ea[role.uniqueID].idstructure = DTextBox(idstructure)

			DHr(hr)]]

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

			if role.uniqueID > 1 then
				local maxamount = {}
				maxamount.parent = ea.info:GetContent()
				maxamount.uniqueID = role.uniqueID
				maxamount.header = "LID_maxamount"
				maxamount.netstr = "update_role_int_maxamount"
				maxamount.value = tonumber(role.int_maxamount)
				maxamount.uniqueID = role.uniqueID
				maxamount.lforce = false
				maxamount.choices = maxa
				ea[role.uniqueID].maxamount = YRPDComboBox(maxamount)

				DHr(hr)
			end

			if role.uniqueID > 1 then
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

			if role.uniqueID > 1 then
				local grps = {}
				for i, tab in pairs(db_groups) do
					tab.uniqueID = tonumber(tab.uniqueID)
					if wk(tab.string_name) and wk(tab.uniqueID) and tab.uniqueID != -1 then
						grps[tab.uniqueID] = tab.string_name .. " [UID: " .. tab.uniqueID .. "]"
					end
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
				ea[role.uniqueID].int_groupID = YRPDComboBox(int_groupID)

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
			string_description.multiline = true
			string_description.h = 140
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
				if tab.uniqueID != role.uniqueID and tab.int_groupID == role.int_groupID then
					otherroles[tab.uniqueID] = tab.string_name --.. " [UID: " .. tab.uniqueID .. "]"
				end
			end

			if role.uniqueID > 1 then
				local prerole = {}
				prerole.parent = ea.info:GetContent()
				prerole.uniqueID = role.uniqueID
				prerole.header = YRP.lang_string("LID_prerole") .. " | " .. YRP.lang_string("LID_prerank")
				prerole.netstr = "update_role_int_prerole"
				prerole.value = tonumber(role.int_prerole)
				prerole.uniqueID = role.uniqueID
				prerole.lforce = false
				prerole.choices = otherroles
				ea[role.uniqueID].prerole = YRPDComboBox(prerole)

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
			ea[role.uniqueID].roleondeath = YRPDComboBox(roleondeath)

			ea.info:AutoSize(true)



			-- FLAGS
			local flags = createD("YGroupBox", col1, ea.info:GetWide(), YRP.ctr(800), YRP.ctr(20), ea.info.y + ea.info:GetTall() + YRP.ctr(20))
			flags:SetText("LID_flags")
			function flags:Paint(pw, ph)
				hook.Run("YGroupBoxPaint", self, pw, ph)
			end
			col1:AddItem(flags)

			ea.background:AddPanel(col1)

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
			ea[role.uniqueID].bool_instructor = YRPDCheckBox(bool_instructor)

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
						local line = createD("YButton", nil, YRP.ctr(800), YRP.ctr(50), 0, 0)
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

			local col2 = createD("DPanelList", ea.background, YRP.ctr(800), ea.background:GetTall() - YRP.ctr(40), YRP.ctr(20), YRP.ctr(20))
			col2:SetSpacing(YRP.ctr(20))

			local appearance = createD("YGroupBox", ea.background, YRP.ctr(800), YRP.ctr(800), YRP.ctr(840), YRP.ctr(20))
			appearance:SetText("LID_appearance")
			function appearance:Paint(pw, ph)
				hook.Run("YGroupBoxPaint", self, pw, ph)
			end
			col2:AddItem(appearance)

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
				net.Receive("get_all_playermodels", function(len)
					YRP.msg("note", "[get_all_playermodels] len: " .. len)
					local pms = net.ReadTable()

					local win = createD("YFrame", nil, YRP.ctr(1400), YRP.ctr(1400), 0, 0)
					win:SetHeaderHeight(YRP.ctr(100))
					win:SetTitle("LID_search")
					win:Center()
					win:MakePopup()

					local content = win:GetContent()
					win.add = createD("YButton", content, YRP.ctr(50), YRP.ctr(50), YRP.ctr(20), YRP.ctr(20))
					win.add:SetText("+")
					function win.add:DoClick()
						win:Close()

						local pmwin = createD("YFrame", nil, YRP.ctr(1400), YRP.ctr(1400), 0, 0)
						pmwin:SetHeaderHeight(YRP.ctr(100))
						pmwin:Center()
						pmwin:MakePopup()
						pmwin:SetTitle("")

						local pmcontent = pmwin:GetContent()

						pmwin.pms = {}
						pmwin.name = createD("DTextEntry", pmcontent, YRP.ctr(300), YRP.ctr(50), YRP.ctr(20 + 300 + 20 + 300 + 20 + 100), YRP.ctr(50 + 20))

						pmwin.float_min = createD("DNumberWang", pmcontent, YRP.ctr(200), YRP.ctr(50), YRP.ctr(20), YRP.ctr(210))
						pmwin.float_max = createD("DNumberWang", pmcontent, YRP.ctr(200), YRP.ctr(50), YRP.ctr(20 + 200 + 20), YRP.ctr(210))

						pmwin.float_min:SetMinMax(0.1, 100.0)
						pmwin.float_max:SetMinMax(0.1, 100.0)

						pmwin.float_min:SetValue(1.0)
						pmwin.float_max:SetValue(1.0)

						function pmwin.float_min:OnValueChange(val)
							val = tonumber(val)
							maxval = tonumber(pmwin.float_max:GetValue())
							if isnumber(val) and isnumber(maxval) and val > maxval then
								pmwin.float_max:SetValue(val)
							end
						end
						function pmwin.float_max:OnValueChange(val)
							val = tonumber(val)
							minval = tonumber(pmwin.float_min:GetValue())
							if isnumber(val) and isnumber(minval) and val < minval then
								pmwin.float_min:SetValue(val)
							end
						end

						pmwin.list = createD("DPanelList", pmcontent, pmcontent:GetWide() - YRP.ctr(40), pmcontent:GetTall() - YRP.ctr(20 + 50 + 20 + 300 + 20 + 20), YRP.ctr(20), YRP.ctr(300 + 20))
						pmwin.list:EnableVerticalScrollbar(true)
						pmwin.list:SetSpacing(10)
						function pmwin.list:RefreshList()
							self:Clear()
							for i, pm in pairs(pmwin.pms) do
								timer.Simple(i * 0.2, function()
									if pa(pmwin) and pa(pmwin.list) then
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
								end)
							end
						end

						function pmwin:Paint(pw, ph)
							hook.Run("YFramePaint", self, pw, ph)

							draw.SimpleText(YRP.lang_string("LID_name") .. ": ", "DermaDefault", YRP.ctr(20 + 300 + 20 + 300 + 20 + 120), YRP.ctr(150), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

							draw.SimpleText(YRP.lang_string("LID_minimumsize") .. ":", "DermaDefault", YRP.ctr(40), YRP.ctr(300), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
							draw.SimpleText(YRP.lang_string("LID_maximumsize") .. ":", "DermaDefault", YRP.ctr(40 + 200 + 20), YRP.ctr(300), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

							draw.SimpleText(YRP.lang_string("LID_models") .. ":", "DermaDefault", YRP.ctr(40), YRP.ctr(410), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
						end

						pmwin.selpm = createD("YButton", pmcontent, YRP.ctr(300), YRP.ctr(50), YRP.ctr(20), YRP.ctr(50 + 20))
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
								self.count = 0
								self.fcount = 0
								self.nothingfound = true
								self.px = 0
								self.py = 0
								self.sid = self.sid or 0
								self.sid = self.sid + 1
								self.searching = true
								for i, v in pairs(cl_pms) do
									if pa(pmsel) then
										if self.searching and string.find(string.lower(v.PrintName), pmsel.strsearch) or string.find(string.lower(v.ClassName), pmsel.strsearch) or string.find(string.lower(v.WorldModel), pmsel.strsearch) then
											self.nothingfound = false
											self.count = self.count + 1
											if self.count > pmsel.nr and self.count <= pmsel.nr + perpage then
												self.fcount = self.fcount + 1
												local d_pm = createD("DPanel", pmsel.dpl, size, size, self.px * space, self.py * space)
												d_pm:SetText("")
												d_pm.WorldModel = v.WorldModel
												d_pm.ClassName = v.ClassName
												d_pm.PrintName = v.PrintName
												function d_pm:Paint(pw, ph)
													local text = YRP.lang_string("LID_notadded")
													local col = Color(255, 255, 255)
													if table.HasValue(pmwin.pms, self.WorldModel) then
														col = Color(0, 255, 0)
														text = YRP.lang_string("LID_added")
													end
													draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, col)

													draw.SimpleText(text, "DermaDefault", pw / 2, ph * 0.05, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

													draw.SimpleText(self.PrintName, "DermaDefault", pw / 2, ph * 0.90, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
													draw.SimpleText(self.WorldModel, "DermaDefault", pw / 2, ph * 0.95, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
												end

												local msize = d_pm:GetTall() * 0.75
												local mbr = (d_pm:GetTall() - msize) / 2
												local my = d_pm:GetTall() * 0.10
												if v.WorldModel != "" then
													d_pm.model = createD("DModelPanel", d_pm, msize, msize, mbr, my)
													timer.Simple(0.1 * self.fcount, function()
														if pa(d_pm) then
															d_pm.model:SetModel(v.WorldModel)
														end
													end)
												else
													d_pm.model = createD("DPanel", d_pm, msize, msize, mbr, my)
													function d_pm.model:Paint(pw, ph)
														draw.RoundedBox(0, 0, 0, pw, ph, Color(80, 80, 80))
														draw.SimpleText("NO MODEL", "DermaDefault", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
													end
												end
												d_pm.btn = createD("YButton", d_pm, d_pm:GetWide(), d_pm:GetTall(), 0, 0)
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

												self.px = self.px + 1
												if self.px > x_max - 1 then
													self.px = 0
													self.py = self.py + 1
												end
											end
										end
									end
								end
								if self.fcount <= 0 then
									pmsel.nr = pmsel.nr - perpage
									if !self.nothingfound then
										self:RefreshPage()
									end
								end
							end
							function pmsel:Search(strsearch)
								strsearch = string.lower(strsearch)

								pmsel.strsearch = strsearch
								pmsel.nr = 0
								pmsel:RefreshPage()
							end

							pmsel.prev = createD("YButton", pmsel, YRP.ctr(200), YRP.ctr(50), ScW() / 2 - YRP.ctr(50 + 20) - YRP.ctr(200), ScH() - YRP.ctr(50 + 20))
							pmsel.prev:SetText("<")
							function pmsel.prev:DoClick()
								if pmsel.nr >= perpage then
									pmsel.nr = pmsel.nr - perpage
									pmsel:RefreshPage()
								end
							end

							pmsel.next = createD("YButton", pmsel, YRP.ctr(200), YRP.ctr(50), ScW() / 2 + YRP.ctr(50 + 20), ScH() - YRP.ctr(50 + 20))
							pmsel.next:SetText(">")
							function pmsel.next:DoClick()
								pmsel.nr = pmsel.nr + perpage
								pmsel:RefreshPage()
							end
							timer.Simple(1, function()
								if pa(pmsel) then
									pmsel:Search("")
								end
							end)

							pmsel.search = createD("DTextEntry", pmsel, ScW() - YRP.ctr(20 + 100 + 20), YRP.ctr(50), YRP.ctr(20 + 100), YRP.ctr(50 + 20))
							function pmsel.search:OnChange()
								pmsel:Search(self:GetText())
							end
						end

						pmwin.selnpm = createD("YButton", pmcontent, YRP.ctr(300), YRP.ctr(50), YRP.ctr(20 + 300 + 20), YRP.ctr(50 + 20))
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
								self.count = 0
								self.fcount = 0
								self.nothingfound = true
								self.px = 0
								self.py = 0
								for i, v in pairs(cl_pms) do
									if pa(pmsel) then
										if string.find(string.lower(v.PrintName), pmsel.strsearch) or string.find(string.lower(v.ClassName), pmsel.strsearch) or string.find(string.lower(v.WorldModel), pmsel.strsearch) then
											self.nothingfound = false
											self.count = self.count + 1
											if self.count > pmsel.nr and self.count <= pmsel.nr + perpage then
												self.fcount = self.fcount + 1
												local d_pm = createD("DPanel", pmsel.dpl, size, size, self.px * space, self.py * space)
												d_pm:SetText("")
												d_pm.WorldModel = v.WorldModel
												d_pm.ClassName = v.ClassName
												d_pm.PrintName = v.PrintName
												function d_pm:Paint(pw, ph)
													local text = YRP.lang_string("LID_notadded")
													local col = Color(255, 255, 255)
													if pmwin.pms != nil and table.HasValue(pmwin.pms, self.WorldModel) then
														col = Color(0, 255, 0)
														text = YRP.lang_string("LID_added")
													end
													draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, col)

													draw.SimpleText(text, "DermaDefault", pw / 2, ph * 0.05, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

													draw.SimpleText(self.PrintName, "DermaDefault", pw / 2, ph * 0.90, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
													draw.SimpleText(self.WorldModel, "DermaDefault", pw / 2, ph * 0.95, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
												end

												local msize = d_pm:GetTall() * 0.75
												local mbr = (d_pm:GetTall() - msize) / 2
												local my = d_pm:GetTall() * 0.10
												if v.WorldModel != "" then
													d_pm.model = createD("DModelPanel", d_pm, msize, msize, mbr, my)
													timer.Simple(0.1 * self.fcount, function()
														if pa(d_pm) then
															d_pm.model:SetModel(v.WorldModel)
														end
													end)
												else
													d_pm.model = createD("DPanel", d_pm, msize, msize, mbr, my)
													function d_pm.model:Paint(pw, ph)
														draw.RoundedBox(0, 0, 0, pw, ph, Color(80, 80, 80))
														draw.SimpleText("NO MODEL", "DermaDefault", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
													end
												end
												d_pm.btn = createD("YButton", d_pm, d_pm:GetWide(), d_pm:GetTall(), 0, 0)
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

												self.px = self.px + 1
												if self.px > x_max - 1 then
													self.px = 0
													self.py = self.py + 1
												end
											end
										end
									end
								end
								if self.fcount <= 0 then
									pmsel.nr = pmsel.nr - perpage
									if !self.nothingfound then
										self:RefreshPage()
									end
								end
							end
							function pmsel:Search(strsearch)
								strsearch = string.lower(strsearch)

								pmsel.strsearch = strsearch
								pmsel.nr = 0
								pmsel:RefreshPage()
							end

							pmsel.prev = createD("YButton", pmsel, YRP.ctr(200), YRP.ctr(50), ScW() / 2 - YRP.ctr(50 + 20) - YRP.ctr(200), ScH() - YRP.ctr(50 + 20))
							pmsel.prev:SetText("<")
							function pmsel.prev:DoClick()
								if pmsel.nr >= perpage then
									pmsel.nr = pmsel.nr - perpage
									pmsel:RefreshPage()
								end
							end

							pmsel.next = createD("YButton", pmsel, YRP.ctr(200), YRP.ctr(50), ScW() / 2 + YRP.ctr(50 + 20), ScH() - YRP.ctr(50 + 20))
							pmsel.next:SetText(">")
							function pmsel.next:DoClick()
								pmsel.nr = pmsel.nr + perpage
								pmsel:RefreshPage()
							end
							timer.Simple(1, function()
								if pa(pmsel) then
									pmsel:Search("")
								end
							end)

							pmsel.search = createD("DTextEntry", pmsel, ScW() - YRP.ctr(20 + 100 + 20), YRP.ctr(50), YRP.ctr(20 + 100), YRP.ctr(50 + 20))
							function pmsel.search:OnChange()
								pmsel:Search(self:GetText())
							end
						end

						pmwin.add = createD("YButton", pmcontent, YRP.ctr(200), YRP.ctr(50), pmcontent:GetWide() / 2 - YRP.ctr(200 / 2), pmcontent:GetTall() - YRP.ctr(50 + 20))
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
					function win.add:Paint(pw, ph)
						hook.Run("YButtonAPaint", self, pw, ph)
					end

					win.dpl = createD("DPanelList", content, content:GetWide() - YRP.ctr(20 * 2), content:GetTall() - YRP.ctr(20 + 50 + 20 + 20), YRP.ctr(20), YRP.ctr(20 + 50 + 20))
					win.dpl:EnableVerticalScrollbar(true)
					function win.dpl:Paint(pw, ph)
						draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255))
					end

					win.delay = 0.2
					win.i = 1
					win.etime = CurTime()
					win.searching = false
					function win:Paint(pw, ph)
						hook.Run("YFramePaint", self, pw, ph)
						if self.searching then
							if CurTime() > self.etime then
								if pms[self.i] != nil then
									local pm = pms[self.i]
									if pa(win.dpl) and string.find(string.lower(pm.string_name), self.searchstr) or string.find(string.lower(pm.string_models), self.searchstr) then
										local line = createD("YButton", nil, YRP.ctr(800), YRP.ctr(200), 0, 0)
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



										line.remove = createD("YButton", line, YRP.ctr(300), YRP.ctr(100), win.dpl:GetWide() - YRP.ctr(350), YRP.ctr(50))
										line.remove:SetText("LID_remove")
										function line.remove:DoClick()
											net.Start("rem_playermodel")
												net.WriteInt(pm.uniqueID, 32)
											net.SendToServer()
											line:Remove()
										end
										function line.remove:Paint(pw, ph)
											draw.RoundedBox(16, 0, 0, pw, ph, Color(255, 140, 140))
											draw.SimpleText(YRP.lang_string("LID_remove") .. " (" .. pm.uses .. " " .. "uses" .. ")", "DermaDefault", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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
									self.etime = CurTime() + self.delay
									self.i = self.i + 1
								else
									self.searching = false
								end
							end
						else
							self.i = 1
						end
					end
				
					function win:Search(strsearch)
						self.searchstr = string.lower(strsearch)

						self.searching = false

						self.i = 1
						self.dpl:Clear()
						self.searching = true
					end
					win:Search("")

					win.search = createD("DTextEntry", content, content:GetWide() - YRP.ctr(20 + 50 + 20 + 20), YRP.ctr(50), YRP.ctr(20 + 50 + 20), YRP.ctr(20))
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
			col2:AddItem(equipment)
			ea.background:AddPanel(col2)

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
					strsearch = string.lower(strsearch)

					self.dpl:Clear()
					for i, v in pairs(cl_sweps) do
						if string.find(string.lower(v.PrintName), strsearch) or string.find(string.lower(v.ClassName), strsearch) or string.find(string.lower(v.WorldModel), strsearch) then
							local d_swep = createD("YButton", nil, winswep.dpl:GetWide(), height / 4, 0, 0)
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
					strsearch = string.lower(strsearch)

					self.dpl:Clear()
					for i, v in pairs(cl_ndsweps) do
						if string.find(string.lower(v.PrintName), strsearch) or string.find(string.lower(v.ClassName), strsearch) or string.find(string.lower(v.WorldModel), strsearch) then
							local d_ndswep = createD("YButton", nil, winndswep.dpl:GetWide(), height / 4, 0, 0)
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
						strsearch = string.lower(strsearch)

						self.dpl:Clear()
						if strsearch != nil then
							for i, v in pairs(cl_licenses) do
								v.PrintName = v.PrintName or ""
								v.ClassName = v.ClassName or ""
								v.WorldModel = v.WorldModel or ""
								if string.find(string.lower(v.PrintName), strsearch) or string.find(string.lower(v.ClassName), strsearch) or string.find(string.lower(v.WorldModel), strsearch) then
									local d_licenses = createD("YButton", nil, winlicenses.dpl:GetWide(), height / 4, 0, 0)
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

			local col3 = createD("DPanelList", ea.background, YRP.ctr(800), ea.background:GetTall() - YRP.ctr(40), YRP.ctr(20), YRP.ctr(20))
			col3:SetSpacing(YRP.ctr(20))

			local restriction = createD("YGroupBox", ea.background, YRP.ctr(800), YRP.ctr(800), YRP.ctr(1660), YRP.ctr(20))
			restriction:SetText("LID_restriction")
			function restriction:Paint(pw, ph)
				hook.Run("YGroupBoxPaint", self, pw, ph)
			end
			col3:AddItem(restriction)
			ea.background:AddPanel(col3)

			ea[role.uniqueID].restriction = restriction
			ea.restriction = ea[role.uniqueID].restriction

			hr.parent = ea.restriction:GetContent()

			if role.uniqueID > 1 then
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
					if ug.string_name != nil then
						ugs["ALL"]["choices"][string.upper(ug.string_name)] = ugs["ALL"]["choices"][string.upper(ug.string_name)] or {}
						ugs["ALL"]["choices"][string.upper(ug.string_name)].checked = table.HasValue(gugs, string.upper(ug.string_name))
					else
						YRP.msg("note", "WHATS THAT? #2")
						pFTab(ug)
					end
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
				ea[role.uniqueID].usergroups = YRPDCheckBoxes(usergroups)

				DHr(hr)
			end

			if role.uniqueID > 1 then
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

				local securitylevel = {}
				securitylevel.parent = ea.restriction:GetContent()
				securitylevel.header = "LID_securitylevel"
				securitylevel.netstr = "update_role_int_securitylevel"
				securitylevel.value = role.int_securitylevel
				securitylevel.uniqueID = role.uniqueID
				securitylevel.lforce = false
				securitylevel.min = 0
				securitylevel.max = 10
				ea[role.uniqueID].securitylevel = DIntBox(securitylevel)

				DHr(hr)
			end

			DHr(hr)

			if role.uniqueID > 1 then
				local whitelist = {}
				whitelist.parent = ea.restriction:GetContent()
				whitelist.uniqueID = role.uniqueID
				whitelist.header = "LID_useswhitelist"
				whitelist.netstr = "update_role_bool_whitelist"
				whitelist.value = role.bool_whitelist
				whitelist.uniqueID = role.uniqueID
				whitelist.lforce = false
				ea[role.uniqueID].whitelist = YRPDCheckBox(whitelist)

				DHr(hr)
			end

			if role.uniqueID > 1 then
				local locked = {}
				locked.parent = ea.restriction:GetContent()
				locked.uniqueID = role.uniqueID
				locked.header = "LID_locked"
				locked.netstr = "update_role_bool_locked"
				locked.value = role.bool_locked
				locked.uniqueID = role.uniqueID
				locked.lforce = false
				ea[role.uniqueID].locked = YRPDCheckBox(locked)

				DHr(hr)
			end

			if role.uniqueID > 1 then
				local bool_canbeagent = {}
				bool_canbeagent.parent = ea.restriction:GetContent()
				bool_canbeagent.uniqueID = role.uniqueID
				bool_canbeagent.header = YRP.lang_string("LID_isagent")
				bool_canbeagent.netstr = "update_role_bool_canbeagent"
				bool_canbeagent.value = role.bool_canbeagent
				bool_canbeagent.uniqueID = role.uniqueID
				bool_canbeagent.lforce = false
				ea[role.uniqueID].bool_canbeagent = YRPDCheckBox(bool_canbeagent)

				DHr(hr)

				local visible = {}
				visible.parent = ea.restriction:GetContent()
				visible.uniqueID = role.uniqueID
				visible.header = YRP.lang_string("LID_visible") .. " (" .. YRP.lang_string("LID_charactercreation") .. ")"
				visible.netstr = "update_role_bool_visible_cc"
				visible.value = role.bool_visible_cc
				visible.uniqueID = role.uniqueID
				visible.lforce = false
				ea[role.uniqueID].visible = YRPDCheckBox(visible)

				DHr(hr)

				local visible2 = {}
				visible2.parent = ea.restriction:GetContent()
				visible2.uniqueID = role.uniqueID
				visible2.header = YRP.lang_string("LID_visible") .. " (" .. YRP.lang_string("LID_rolemenu") .. ")"
				visible2.netstr = "update_role_bool_visible_rm"
				visible2.value = role.bool_visible_rm
				visible2.uniqueID = role.uniqueID
				visible2.lforce = false
				ea[role.uniqueID].visible2 = YRPDCheckBox(visible2)

				DHr(hr)
			end

			if role.uniqueID > 1 then
				local bool_voteable = {}
				bool_voteable.parent = ea.restriction:GetContent()
				bool_voteable.uniqueID = role.uniqueID
				bool_voteable.header = "LID_voteable"
				bool_voteable.netstr = "update_role_bool_voteable"
				bool_voteable.value = role.bool_voteable
				bool_voteable.uniqueID = role.uniqueID
				bool_voteable.lforce = false
				ea[role.uniqueID].bool_voteable = YRPDCheckBox(bool_voteable)

				DHr(hr)
			end

			local bool_eventrole = {}
			bool_eventrole.parent = ea.restriction:GetContent()
			bool_eventrole.uniqueID = role.uniqueID
			bool_eventrole.header = "EVENT ROLE?"
			bool_eventrole.netstr = "update_role_bool_eventrole"
			bool_eventrole.value = role.bool_eventrole
			bool_eventrole.uniqueID = role.uniqueID
			bool_eventrole.lforce = false
			ea[role.uniqueID].bool_eventrole = YRPDCheckBox(bool_eventrole)

			DHr(hr)

			--[[local cooldown = {}
			cooldown.parent = ea.restriction:GetContent()
			cooldown.header = "LID_cooldown"
			cooldown.netstr = "update_role_int_cooldown"
			cooldown.value = role.int_cooldown
			cooldown.uniqueID = role.uniqueID
			cooldown.lforce = false
			cooldown.min = 0
			cooldown.max = 360
			ea[role.uniqueID].cooldown = DIntBox(cooldown)

			DHr(hr)]]

			local int_namelength = {}
			int_namelength.parent = ea.restriction:GetContent()
			int_namelength.header = "LID_namelength"
			int_namelength.netstr = "update_role_int_namelength"
			int_namelength.value = role.int_namelength
			int_namelength.uniqueID = role.uniqueID
			int_namelength.lforce = false
			int_namelength.min = 0
			int_namelength.max = 64
			ea[role.uniqueID].int_namelength = DIntBox(int_namelength)

			ea.restriction:AutoSize(true)

			local col4 = createD("DPanelList", ea.background, YRP.ctr(800), ea.background:GetTall() - YRP.ctr(40), YRP.ctr(20), YRP.ctr(20))
			col4:SetSpacing(YRP.ctr(20))

			local attributes = createD("YGroupBox", ea.background, YRP.ctr(800), YRP.ctr(1400), ea.restriction.x + ea.restriction:GetWide() + YRP.ctr(20), YRP.ctr(20))
			attributes:SetText("LID_attributes")
			function attributes:Paint(pw, ph)
				hook.Run("YGroupBoxPaint", self, pw, ph)
			end
			col4:AddItem(attributes)
			ea.background:AddPanel(col4)

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

			local abis = {"none", "mana", "force", "rage", "energy"}
			local tab_a = {}
			for i, v in pairs(abis) do
				tab_a[string.lower(v)] = YRP.lang_string("LID_" .. string.lower(v))
			end

			local string_ability = {}
			string_ability.parent = ea.attributes:GetContent()
			string_ability.uniqueID = role.uniqueID
			string_ability.header = YRP.lang_string("LID_ability")
			string_ability.netstr = "update_role_string_ability"
			string_ability.value = role.string_ability
			string_ability.uniqueID = role.uniqueID
			string_ability.lforce = false
			string_ability.choices = tab_a
			ea[role.uniqueID].string_ability = YRPDComboBox(string_ability)

			local ability = {}
			ability.parent = ea.attributes:GetContent()
			ability.uniqueID = role.uniqueID
			ability.header = YRP.lang_string("LID_ability")
			ability.netstr = "ab"
			ability.uniqueID = role.uniqueID
			ability.lforce = false

			ability.dnw = {}

			ability.dnw[1] = {}
			ability.dnw[1].value = role.int_ab
			ability.dnw[1].min = 1
			ability.dnw[1].max = GetMaxInt()
			ability.dnw[1].netstr = "update_role_" .. "int_" .. "ab"

			ability.dnw[2] = {}
			ability.dnw[2].value = role.int_abmax
			ability.dnw[2].min = 1
			ability.dnw[2].max = GetMaxInt()
			ability.dnw[2].netstr = "update_role_" .. "int_" .. "abmax"

			ability.color = Color(255, 255, 0)
			ability.color2 = Color(200, 200, 0)
			ability.color3 = Color(160, 160, 0)
			ea[role.uniqueID].ability = DAttributeBar(ability)

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

			DHr(hr)

			local dmgtypes = {
				"burn",
				"bullet",
				"energybeam"
			}
			for i, dmgtype in pairs(dmgtypes) do
				local d = {}
				d.parent = ea.attributes:GetContent()
				d.header = "LID_" .. "dmgtype_" .. dmgtype
				d.netstr = "update_role_float_" .. "dmgtype_" .. dmgtype
				d.value = role["float_" .. "dmgtype_" .. dmgtype] or 1.0
				d.uniqueID = role.uniqueID
				d.lforce = false
				d.min = -10.0
				d.max = 10.0
				ea[role.uniqueID][dmgtype] = DIntBox(d)
			end

			DHr(hr)

			if GetGlobalDBool("bool_hunger", false) then
				local bool_hunger = {}
				bool_hunger.parent = ea.attributes:GetContent()
				bool_hunger.uniqueID = role.uniqueID
				bool_hunger.header = "LID_hunger"
				bool_hunger.netstr = "update_role_bool_hunger"
				bool_hunger.value = role.bool_hunger
				bool_hunger.uniqueID = role.uniqueID
				ea[role.uniqueID].bool_hunger = YRPDCheckBox(bool_hunger)

				DHr(hr)
			end

			if GetGlobalDBool("bool_thirst", false) then
				local bool_thirst = {}
				bool_thirst.parent = ea.attributes:GetContent()
				bool_thirst.uniqueID = role.uniqueID
				bool_thirst.header = "LID_thirst"
				bool_thirst.netstr = "update_role_bool_thirst"
				bool_thirst.value = role.bool_thirst
				bool_thirst.uniqueID = role.uniqueID
				ea[role.uniqueID].bool_thirst = YRPDCheckBox(bool_thirst)

				DHr(hr)
			end

			if GetGlobalDBool("bool_stamina", false) then
				local bool_stamina = {}
				bool_stamina.parent = ea.attributes:GetContent()
				bool_stamina.uniqueID = role.uniqueID
				bool_stamina.header = "LID_stamina"
				bool_stamina.netstr = "update_role_bool_stamina"
				bool_stamina.value = role.bool_stamina
				bool_stamina.uniqueID = role.uniqueID
				ea[role.uniqueID].bool_stamina = YRPDCheckBox(bool_stamina)

				DHr(hr)
			end

			ea.attributes:AutoSize(true)
		end)

		net.Receive("settings_subscribe_rolelist", function(le)
			if pa(rs.rplist) then
				rs.rplist:ClearList()

				local roles = net.ReadTable()
				local headername = net.ReadString()
				rs.top.headername = headername

				local gro = net.ReadString()
				local pre = net.ReadString()

				if wk(gro) and wk(pre) then
					cur_role.gro = tonumber(gro)
					cur_role.pre = tonumber(pre)

					rs.rplist.tab = roles
					for i, role in pairs(roles) do
						CreateLineRole(rs.rplist, role)
						role["int_position"] = tonumber(role["int_position"])
					end

					rs.rplist:SortByMember("int_position", true)
					rs.rplist:Rebuild()
				end
			end
		end)
	end
end)

function OpenSettingsGroupsAndRoles()
	net.Start("Subscribe_Settings_GroupsAndRoles")
	net.SendToServer()
end