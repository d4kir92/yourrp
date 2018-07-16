--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

net.Receive("Connect_Settings_GroupsAndRoles", function(len)
	if pa(settingsWindow) then
		function settingsWindow.window.site:Paint(pw, ph)
			draw.RoundedBox(4, 0, 0, pw, ph, Color(0, 0, 0, 254))

			local tab = {}
			tab.w = pw
			tab.h = ph
			tab.x = pw / 2
			tab.y = ph / 2
			tab.text = "wip"
			DrawText(tab)
		end

		local PARENT = settingsWindow.window.site

		local cur_group = {}
		cur_group.cur = 0
		cur_group.par = 0

		function PARENT:OnRemove()
			net.Start("Disconnect_Settings_GroupsAndRoles")
				net.WriteString(cur_group.cur)
			net.SendToServer()
		end

		local gs = {}

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
				net.Start("settings_get_group_list")
					net.WriteString(cur_group.cur)
					net.WriteString(cur_group.par)
				net.SendToServer()
			end
		end

		gs.top = createD("DPanel", PARENT, ctr(480), ctr(60), ctr(80), ctr(20))
		function gs.top:Paint(pw, ph)
			local tab = {}
			tab.color = YRPGetColor("3")
			DrawPanel(self, tab)
			local tab2 = {}
			tab2.x = pw / 2
			tab2.y = ph / 2
			tab2.ax = 1
			tab2.ay = 1
			tab2.text = "groups"
			tab2.font = "mat1text"
			DrawText(tab2)
		end

		gs.add = createD("DButton", PARENT, ctr(60), ctr(60), ctr(560), ctr(20))
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

		gs.glist = createD("DPanel", PARENT, ctr(600), ctr(940), ctr(20), ctr(80))
		gs.gplist = createD("DPanelList", gs.glist, gs.glist:GetWide(), gs.glist:GetTall(), 0, 0)
		gs.gplist:EnableVerticalScrollbar(true)
		gs.gplist:SetSpacing(ctr(10))

		function CreateLineGroup(parent, group)
			gs.gplist[group.uniqueID] = gs.gplist[group.uniqueID] or {}
			gs.gplist[group.uniqueID] = createD("DPanel", parent, parent:GetWide() - ctr(20), ctr(120), 0, 0)
			for i, e in pairs(group) do
				if string.StartWith(i, "int_") then
					gs.gplist[group.uniqueID][i] = tonumber(e)
				else
					gs.gplist[group.uniqueID][i] = e
				end
			end
			local pnl = gs.gplist[group.uniqueID]
			function pnl:Paint(pw, ph)
				local tab = {}
				tab.color = YRPGetColor("2")
				DrawPanel(self, tab)
				local tab2 = {}
				tab2.x = ctr(40) + ph + ctr(20)
				tab2.y = ph * 1 / 4
				tab2.ax = 0
				tab2.ay = 1
				tab2.text = group.string_name .. " UID: " .. group.uniqueID
				tab2.font = "mat1text"
				DrawText(tab2)
				local tab3 = {}
				tab3.x = ctr(40) + ph + ctr(20)
				tab3.y = ph * 3 / 4
				tab3.ax = 0
				tab3.ay = 1
				tab3.text = "UP: " .. gs.gplist[group.uniqueID].int_up .. " DN: " .. gs.gplist[group.uniqueID].int_dn
				tab3.font = "mat1text"
				DrawText(tab3)
			end

			gs.gplist[group.uniqueID].ico = createD("DHTML", gs.gplist[group.uniqueID], gs.gplist[group.uniqueID]:GetTall() - ctr(20), gs.gplist[group.uniqueID]:GetTall() - ctr(20), ctr(60), ctr(10))
			local ico = gs.gplist[group.uniqueID].ico
			function ico:Paint(pw, ph)
				local tab = {}
				DrawPanel(self, tab)
			end

			gs.gplist[group.uniqueID].up = createD("DButton", gs.gplist[group.uniqueID], ctr(40), gs.gplist[group.uniqueID]:GetTall() / 2 - ctr(15), ctr(10), ctr(10))
			gs.gplist[group.uniqueID].up:SetText("")
			local up = gs.gplist[group.uniqueID].up
			function up:Paint(pw, ph)
				if gs.gplist[group.uniqueID].int_up != 0 then
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
				if gs.gplist[group.uniqueID].int_dn != 0 then
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

			gs.gplist[group.uniqueID].ch = createD("DButton", gs.gplist[group.uniqueID], ctr(40), ctr(40), gs.gplist[group.uniqueID]:GetWide() - ctr(50), gs.gplist[group.uniqueID]:GetTall() - ctr(50))
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
				net.Start("settings_get_group_list")
					net.WriteString(cur_group.cur)
					net.WriteString(gs.gplist[group.uniqueID].uniqueID)
				net.SendToServer()
			end

			parent:AddItem(gs.gplist[group.uniqueID])
		end
		net.Receive("settings_get_group_list", function(le)
			local groups = net.ReadTable()

			gs.gplist:Clear()

			cur_group.cur = tonumber(net.ReadString())
			cur_group.par = tonumber(net.ReadString())
			for i, group in pairs(groups) do
				CreateLineGroup(gs.gplist, group)
				group["int_position"] = tonumber(group["int_position"])
			end

			gs.gplist:SortByMember("int_position", true)
			gs.gplist:Rebuild()
		end)
		net.Start("settings_get_group_list")
			net.WriteString(cur_group.cur)
			net.WriteString(cur_group.par)
		net.SendToServer()

		net.Receive("settings_group_position_up", function(le)
			local uid = tonumber(net.ReadString())
			for i, group in pairs(gs.gplist:GetItems()) do
				if tonumber(group.uniqueID) == uid then
					group["int_position"] = group["int_position"] - 1
				end
				group["int_position"] = tonumber(group["int_position"])
			end
			gs.gplist:SortByMember("int_position", true)
			gs.gplist:Rebuild()
		end)
		net.Receive("settings_group_position_dn", function(le)
			local uid = tonumber(net.ReadString())
			for i, group in pairs(gs.gplist:GetItems()) do
				if tonumber(group.uniqueID) == uid then
					group["int_position"] = group["int_position"] + 1
				end
				group["int_position"] = tonumber(group["int_position"])
			end
			gs.gplist:SortByMember("int_position", true)
			gs.gplist:Rebuild()
		end)

		local rs = {}
		rs.top = createD("DPanel", PARENT, ctr(600), ctr(60), ctr(20), ctr(1040))

		rs.rlist = createD("DPanel", PARENT, ctr(600), ctr(940), ctr(20), ctr(1100))

		--[[
		bool_groupvoicechat	=	1
		bool_locked	=	0
		bool_removeable	=	1
		bool_whitelist	=	0
		int_parentgroup	=	0
		int_requiredlevel	=	1
		int_requirelevel	=	1
		int_uppergroup	=	0
		string_color	=	0,0,0
		string_ents	=
		string_icon	=
		string_name	=	GroupName
		string_requireusergroups	=	all
		string_sweps	=
		]]--
	end
end)

hook.Add( "open_server_groups_and_roles", "open_server_groups_and_roles", function()
	SaveLastSite()
	local w = settingsWindow.window.sitepanel:GetWide()
	local h = settingsWindow.window.sitepanel:GetTall()
	settingsWindow.window.site = createD("DPanel", settingsWindow.window.sitepanel, w, h, 0, 0)
	net.Start("Connect_Settings_GroupsAndRoles")
	net.SendToServer()
end)
