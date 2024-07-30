--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
--#roles #groups #settings
net.Receive(
	"nws_yrp_subscribe_Settings_GroupsAndRoles",
	function(len)
		local PARENT = GetSettingsSite()
		if YRPPanelAlive(PARENT, "GAR 1") then
			local cur_group = {}
			cur_group.cur = 0
			cur_group.par = 0
			cur_group.edi = 0
			local cur_role = {}
			cur_role.gro = 0
			cur_role.pre = 0
			cur_role.edi = 0
			function PARENT:OnRemove()
				net.Start("nws_yrp_unsubscribe_Settings_GroupsAndRoles")
				net.WriteString(cur_group.cur)
				net.SendToServer()
			end

			PARENT.gs = {}
			local gs = PARENT.gs
			PARENT.rs = {}
			local rs = PARENT.rs
			gs.bac = YRPCreateD("YButton", PARENT, YRP:ctr(60), YRP:ctr(60), YRP:ctr(20), YRP:ctr(20))
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
					tab2.font = "Y_18_700"
					YRPDrawText(tab2)
				else
					local tab = {}
					tab.color = YRPGetColor("3")
					DrawPanel(self, tab)
				end
			end

			function gs.bac:DoClick()
				if cur_group.cur > 0 then
					gs.gplist:ClearList()
					net.Start("nws_yrp_settings_unsubscribe_grouplist")
					net.WriteString(cur_group.cur)
					net.SendToServer()
					net.Start("nws_yrp_settings_subscribe_grouplist")
					net.WriteString(cur_group.par)
					net.SendToServer()
				end
			end

			gs.top = YRPCreateD("DPanel", PARENT, YRP:ctr(800 - 120), YRP:ctr(60), YRP:ctr(80), YRP:ctr(20))
			function gs.top:Paint(pw, ph)
				local tab = {}
				tab.color = YRPGetColor("3")
				DrawPanel(self, tab)
				local tab2 = {}
				tab2.x = pw / 2
				tab2.y = ph / 2
				tab2.ax = 1
				tab2.ay = 1
				tab2.font = "Y_18_700"
				tab2.color = YRPGetColor("3")
				if self.group ~= nil then
					if self.group ~= "" then
						local inp = {}
						inp.group = self.group
						tab2.text = YRP:trans("LID_groupsof", inp)
					else
						tab2.text = YRP:trans("LID_factions")
					end
				else
					tab2.text = YRP:trans("LID_loading")
				end

				YRPDrawText(tab2)
			end

			gs.add = YRPCreateD("YButton", PARENT, YRP:ctr(60), YRP:ctr(60), YRP:ctr(20 + 800 - 60), YRP:ctr(20))
			gs.add:SetText("+")
			function gs.add:Paint(pw, ph)
				hook.Run("YButtonAPaint", self, pw, ph)
			end

			function gs.add:DoClick()
				net.Start("nws_yrp_settings_add_group")
				net.WriteString(cur_group.cur)
				net.SendToServer()
			end

			local listH = PARENT:GetTall() / 2 - 2 * YRP:ctr(30) - 3 * YRP:ctr(10)
			gs.glist = YRPCreateD("DPanel", PARENT, YRP:ctr(800), listH, YRP:ctr(20), YRP:ctr(20 + 60))
			gs.gplist = YRPCreateD("DPanelList", gs.glist, gs.glist:GetWide(), gs.glist:GetTall(), 0, 0)
			gs.gplist:EnableVerticalScrollbar(true)
			gs.gplist:SetSpacing(YRP:ctr(10))
			function gs.gplist:ClearList()
				gs.top.group = nil
				gs.gplist:Clear()
			end

			net.Receive(
				"nws_yrp_settings_group_update_name",
				function(le)
					local _uid = tonumber(net.ReadString())
					local name = net.ReadString()
					if YRPPanelAlive(gs.gplist, "GAR 2") and gs.gplist[_uid] and gs.gplist[_uid].text then
						gs.gplist[_uid].text = name
					end
				end
			)

			net.Receive(
				"nws_yrp_settings_group_update_color",
				function(le)
					local _uid = tonumber(net.ReadString())
					local color = net.ReadString()
					if IsNotNilAndNotFalse(gs) and gs.gplist and gs.gplist[_uid] and gs.gplist[_uid].string_color and isnumber(_uid) and gs.gplist[_uid] ~= nil then
						gs.gplist[_uid].string_color = stc(color)
					end
				end
			)

			net.Receive(
				"nws_yrp_settings_group_update_icon",
				function(le)
					local _uid = tonumber(net.ReadString())
					local icon = net.ReadString()
					if YRPPanelAlive(gs.gplist, "GAR 3") and gs.gplist and gs.gplist[_uid] and gs.gplist[_uid].string_icon then
						gs.gplist[_uid].string_icon = icon
						gs.gplist[_uid].ico:SetHTML(YRPGetHTMLImage(gs.gplist[_uid].string_icon, gs.gplist[_uid].ico:GetWide(), gs.gplist[_uid].ico:GetTall()))
						YRPTestHTML(gs.gplist[_uid].ico, gs.gplist[_uid].string_icon, false)
					end
				end
			)

			function CreateLineGroup(parent, group)
				group.uniqueID = tonumber(group.uniqueID)
				gs.gplist[group.uniqueID] = gs.gplist[group.uniqueID] or {}
				gs.gplist[group.uniqueID] = YRPCreateD("YButton", parent, parent:GetWide() - YRP:ctr(20), YRP:ctr(120), 0, 0)
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
					tab2.x = YRP:ctr(182)
					tab2.y = YRP:ctr(20)
					tab2.ax = 0
					tab2.ay = 0
					tab2.text = self.text
					tab2.font = "Y_18_700"
					tab2.lforce = false
					tab2.color = gs.gplist[group.uniqueID]["string_color"]
					YRPDrawText(tab2)
				end

				function pnl:DoClick()
					net.Start("nws_yrp_settings_subscribe_group")
					net.WriteString(group.uniqueID)
					net.SendToServer()
				end

				gs.gplist[group.uniqueID].ico = YRPCreateD("DHTML", gs.gplist[group.uniqueID], gs.gplist[group.uniqueID]:GetTall() - YRP:ctr(20), gs.gplist[group.uniqueID]:GetTall() - YRP:ctr(20), YRP:ctr(60), YRP:ctr(10))
				local ico = gs.gplist[group.uniqueID].ico
				function ico:Paint(pw, ph)
				end

				ico:SetHTML(YRPGetHTMLImage(group.string_icon, ico:GetWide(), ico:GetTall()))
				YRPTestHTML(ico, group.string_icon, false)
				gs.gplist[group.uniqueID].up = YRPCreateD("YButton", gs.gplist[group.uniqueID], YRP:ctr(40), YRP:ctr(40), YRP:ctr(10), YRP:ctr(10))
				gs.gplist[group.uniqueID].up:SetText("")
				local up = gs.gplist[group.uniqueID].up
				function up:Paint(pw, ph)
					if gs.gplist[group.uniqueID].int_position > 1 then
						hook.Run("YButtonPaint", self, pw, ph)
						if YRP:GetDesignIcon("64_angle-up") then
							surface.SetDrawColor(Color(255, 255, 255, 255))
							surface.SetMaterial(YRP:GetDesignIcon("64_angle-up"))
							surface.DrawTexturedRect(0, 0, pw, ph)
						end
					end
				end

				function up:DoClick()
					net.Start("nws_yrp_settings_group_position_up")
					net.WriteString(gs.gplist[group.uniqueID].uniqueID)
					net.SendToServer()
				end

				gs.gplist[group.uniqueID].dn = YRPCreateD("YButton", gs.gplist[group.uniqueID], YRP:ctr(40), YRP:ctr(40), YRP:ctr(10), gs.gplist[group.uniqueID]:GetTall() - YRP:ctr(40 + 10))
				gs.gplist[group.uniqueID].dn:SetText("")
				local dn = gs.gplist[group.uniqueID].dn
				function dn:Paint(pw, ph)
					if gs.gplist[group.uniqueID].int_position < table.Count(gs.gplist.tab) then
						hook.Run("YButtonPaint", self, pw, ph)
						if YRP:GetDesignIcon("64_angle-down") then
							surface.SetDrawColor(Color(255, 255, 255, 255))
							surface.SetMaterial(YRP:GetDesignIcon("64_angle-down"))
							surface.DrawTexturedRect(0, 0, pw, ph)
						end
					end
				end

				function dn:DoClick()
					net.Start("nws_yrp_settings_group_position_dn")
					net.WriteString(gs.gplist[group.uniqueID].uniqueID)
					net.SendToServer()
				end

				gs.gplist[group.uniqueID].ch = YRPCreateD("YButton", gs.gplist[group.uniqueID], YRP:ctr(40), YRP:ctr(40), gs.gplist[group.uniqueID]:GetWide() - YRP:ctr(66), gs.gplist[group.uniqueID]:GetTall() - YRP:ctr(60))
				gs.gplist[group.uniqueID].ch:SetText("")
				local ch = gs.gplist[group.uniqueID].ch
				surface.SetFont("Y_14_700")
				local text = YRP:trans("LID_undergroups") .. " ▶"
				local tw, _ = surface.GetTextSize(text)
				tw = tw + YRP:ctr(20)
				ch:SetWide(tw)
				ch:SetPos(gs.gplist[group.uniqueID]:GetWide() - tw - YRP:ctr(10 + 10), gs.gplist[group.uniqueID]:GetTall() - YRP:ctr(40 + 10))
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
					tab2.font = "Y_14_700"
					tab2.color = tab.color
					YRPDrawText(tab2)
				end

				function ch:DoClick()
					gs.gplist:ClearList()
					net.Start("nws_yrp_settings_unsubscribe_grouplist")
					net.WriteString(cur_group.cur)
					net.SendToServer()
					timer.Simple(
						0.01,
						function()
							if IsNotNilAndNotFalse(gs.gplist[group.uniqueID]) and IsNotNilAndNotFalse(gs.gplist[group.uniqueID].uniqueID) then
								net.Start("nws_yrp_settings_subscribe_grouplist")
								net.WriteString(gs.gplist[group.uniqueID].uniqueID)
								net.SendToServer()
							end
						end
					)
				end

				parent:AddItem(gs.gplist[group.uniqueID])
			end

			net.Receive(
				"nws_yrp_settings_subscribe_grouplist",
				function(le)
					if YRPPanelAlive(gs.gplist, "GAR 4") then
						gs.gplist:ClearList()
						local parentgroup = net.ReadTable()
						if parentgroup.uniqueID ~= nil then
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
				end
			)

			net.Start("nws_yrp_settings_subscribe_grouplist")
			net.WriteString(cur_group.par)
			net.SendToServer()
			local listH2 = PARENT:GetTall() / 2 - 2 * YRP:ctr(30) - 3 * YRP:ctr(10)
			rs.top = YRPCreateD("DPanel", PARENT, YRP:ctr(800 - 120), YRP:ctr(60), YRP:ctr(80), listH2 + YRP:ctr(20 + 60 + 20))
			function rs.top:Paint(pw, ph)
				if rs.top.headername ~= nil then
					local tab = {}
					tab.color = YRPGetColor("3")
					DrawPanel(self, tab)
					local tab2 = {}
					tab2.x = pw / 2
					tab2.y = ph / 2
					tab2.ax = 1
					tab2.ay = 1
					tab2.font = "Y_18_700"
					tab2.color = YRPGetColor("3")
					if self.headername ~= nil then
						local inp = {}
						inp.group = self.headername
						tab2.text = YRP:trans("LID_rolesof", inp)
					else
						tab2.text = YRP:trans("LID_loading")
					end

					YRPDrawText(tab2)
				end
			end

			rs.bac = YRPCreateD("YButton", PARENT, YRP:ctr(60), YRP:ctr(60), YRP:ctr(20), listH2 + YRP:ctr(20 + 60 + 20))
			rs.bac:SetText("")
			function rs.bac:Paint(pw, ph)
				if rs.top.headername ~= nil and IsNotNilAndNotFalse(cur_role.pre) then
					if cur_role.pre > 0 then
						local tab = {}
						tab.color = Color(255, 255, 0)
						DrawPanel(self, tab)
						local tab2 = {}
						tab2.x = pw / 2
						tab2.y = ph / 2
						tab2.ax = 1
						tab2.ay = 1
						tab2.text = "◀"
						tab2.font = "Y_18_700"
						YRPDrawText(tab2)
					else
						local tab = {}
						tab.color = YRPGetColor("3")
						DrawPanel(self, tab)
					end
				end
			end

			function rs.bac:DoClick()
				if IsNotNilAndNotFalse(cur_role.pre) and IsNotNilAndNotFalse(cur_role.gro) and cur_role.pre > 0 then
					rs.rplist:ClearList()
					net.Start("nws_yrp_settings_unsubscribe_rolelist")
					net.WriteString(cur_role.gro)
					net.WriteString(cur_role.pre)
					net.SendToServer()
					net.Start("nws_yrp_settings_subscribe_prerolelist")
					net.WriteString(cur_role.gro)
					net.WriteString(cur_role.pre)
					net.SendToServer()
				end
			end

			rs.add = YRPCreateD("YButton", PARENT, YRP:ctr(60), YRP:ctr(60), YRP:ctr(20 + 800 - 60), listH2 + YRP:ctr(20 + 60 + 20))
			rs.add:SetText("+")
			function rs.add:Paint(pw, ph)
				if rs.top.headername ~= nil then
					hook.Run("YButtonAPaint", self, pw, ph)
				end
			end

			function rs.add:DoClick()
				if rs.top.headername ~= nil and cur_role.gro ~= nil and cur_role.pre ~= nil then
					net.Start("nws_yrp_settings_add_role")
					net.WriteString(cur_role.gro)
					net.WriteString(cur_role.pre)
					net.SendToServer()
				end
			end

			rs.rlist = YRPCreateD("DPanel", PARENT, YRP:ctr(800), listH2, YRP:ctr(20), listH2 + 2 * YRP:ctr(20) + 2 * YRP:ctr(60))
			function rs.rlist:Paint(pw, ph)
				if rs.top.headername ~= nil then
					local tab = {}
					tab.color = Color(255, 255, 255, 255)
					DrawPanel(self, tab)
				end
			end

			rs.rplist = YRPCreateD("DPanelList", rs.rlist, rs.rlist:GetWide(), rs.rlist:GetTall(), 0, 0)
			rs.rplist:EnableVerticalScrollbar(true)
			rs.rplist:SetSpacing(YRP:ctr(10))
			function rs.rplist:ClearList()
				rs.top.headername = nil
				rs.rplist:Clear()
			end

			net.Receive(
				"nws_yrp_settings_role_update_name",
				function(le)
					if YRPPanelAlive(rs.rplist, "GAR 5") then
						local _uid = tonumber(net.ReadString())
						local name = net.ReadString()
						if IsNotNilAndNotFalse(rs.rplist[_uid]) then
							rs.rplist[_uid].text = name
						else
							YRP:msg("note", "[settings_role_update_name] index is invalid")
						end
					end
				end
			)

			net.Receive(
				"nws_yrp_settings_role_update_color",
				function(le)
					if IsNotNilAndNotFalse(rs) then
						local _uid = tonumber(net.ReadString())
						local color = net.ReadString()
						if isnumber(_uid) and rs.rplist[_uid] ~= nil then
							rs.rplist[_uid].string_color = stc(color)
						end
					end
				end
			)

			net.Receive(
				"nws_yrp_settings_role_update_icon",
				function(le)
					if YRPPanelAlive(rs.rplist, "GAR 6") then
						local _uid = tonumber(net.ReadString())
						local icon = net.ReadString()
						if YRPPanelAlive(rs.rplist[_uid], "GAR 7") then
							rs.rplist[_uid].string_icon = icon
							rs.rplist[_uid].ico:SetHTML(YRPGetHTMLImage(rs.rplist[_uid].string_icon, rs.rplist[_uid].ico:GetWide(), rs.rplist[_uid].ico:GetTall()))
							YRPTestHTML(rs.rplist[_uid].ico, rs.rplist[_uid].string_icon, false)
						end
					end
				end
			)

			PARENT.ea = {}
			local ea = PARENT.ea
			ea.background = YRPCreateD("DHorizontalScroller", PARENT, PARENT:GetWide() - YRP:ctr(860), PARENT:GetTall() - YRP:ctr(20 + 60 + 20), YRP:ctr(840), YRP:ctr(20 + 60))
			ea.background:SetOverlap(-YRP:ctr(20))
			--[[function ea.background:Paint(pw, ph)
			if ea.typ ~= nil then
				local tab = {}
				tab.color = Color(20, 20, 20, 255)
				DrawPanel(self, tab)
			end
		end]]
			ea.del = YRPCreateD("YButton", PARENT, YRP:ctr(60), YRP:ctr(60), YRP:ctr(840), YRP:ctr(20))
			ea.del:SetText("-")
			function ea.del:Paint(pw, ph)
				if ea.typ ~= nil and tonumber(ea.tab.uniqueID) ~= 1 then
					hook.Run("YButtonRPaint", self, pw, ph)
				elseif ea.typ ~= nil then
					local tab = {}
					tab.color = YRPGetColor("3")
					DrawPanel(self, tab)
				end
			end

			function ea.del:DoClick()
				if ea.typ == "group" and tonumber(ea.tab.uniqueID) ~= 1 then
					local win = YRPCreateD("YFrame", nil, YRP:ctr(660), YRP:ctr(300), 0, 0)
					win:SetHeaderHeight(YRP:ctr(100))
					win:Center()
					win:MakePopup()
					win:SetTitle(YRP:trans("LID_areyousure"))
					function win:Paint(pw, ph)
						hook.Run("YFramePaint", self, pw, ph)
					end

					local content = win:GetContent()
					function content:Paint(pw, ph)
						draw.SimpleText("Recursive" .. " - " .. "If checked, removes everything behind!", "DermaDefault", YRP:ctr(60), YRP:ctr(50 + 20 + 25), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					end

					local recursive = YRPCreateD("DCheckBox", win:GetContent(), YRP:ctr(50), YRP:ctr(50), 0, YRP:ctr(50 + 20))
					local _yes = YRPCreateD("YButton", win:GetContent(), YRP:ctr(300), YRP:ctr(50), 0, 0)
					_yes:SetText(YRP:trans("LID_yes"))
					function _yes:DoClick()
						if ea and ea.tab and ea.tab.uniqueID then
							net.Start("nws_yrp_settings_delete_group")
							net.WriteString(ea.tab.uniqueID)
							net.WriteBool(recursive:GetValue())
							net.SendToServer()
						end

						if ea and YRPEntityAlive(ea.background) and ea.background.Clear then
							ea.background:Clear()
						end

						if ea then
							ea.typ = nil
							ea.tab = nil
						end

						if win then
							win:Close()
						end
					end

					local _no = YRPCreateD("YButton", win:GetContent(), YRP:ctr(300), YRP:ctr(50), YRP:ctr(320), 0)
					_no:SetText(YRP:trans("LID_no"))
					function _no:DoClick()
						win:Close()
					end
				elseif ea.typ == "role" and IsNotNilAndNotFalse(ea.tab.uniqueID) and tonumber(ea.tab.uniqueID) ~= 1 then
					net.Start("nws_yrp_settings_delete_role")
					net.WriteString(ea.tab.uniqueID)
					net.SendToServer()
					ea.background:Clear()
					ea.typ = nil
					ea.tab = nil
				end
			end

			ea.dup = YRPCreateD("YButton", PARENT, YRP:ctr(60), YRP:ctr(60), YRP:ctr(900), YRP:ctr(20))
			ea.dup:SetText("")
			function ea.dup:Paint(pw, ph)
				if ea.typ ~= nil then
					if ea.tab.uniqueID ~= 1 then
						local tab = {}
						tab.color = Color(255, 255, 0, 255)
						DrawPanel(self, tab)
						local tab2 = {}
						tab2.w = pw
						tab2.h = ph
						tab2.x = YRP:ctr(20)
						tab2.y = ph / 2
						tab2.ax = 0
						tab2.text = "[ ]"
						tab2.font = "Y_18_700"
						YRPDrawText(tab2)
					end
				elseif ea.typ ~= nil then
					local tab = {}
					tab.color = YRPGetColor("3")
					DrawPanel(self, tab)
				end
			end

			function ea.dup:DoClick()
				if ea.tab and ea.tab.uniqueID ~= nil and ea.tab.uniqueID ~= 1 then
					if ea.typ == "group" then
						net.Start("nws_yrp_settings_duplicate_group")
						net.WriteString(ea.tab.uniqueID)
						net.SendToServer()
					elseif ea.typ == "role" then
						net.Start("nws_yrp_duplicated_role")
						net.WriteString(ea.tab.uniqueID)
						net.SendToServer()
					end
				end
			end

			ea.top = YRPCreateD("DPanel", PARENT, PARENT:GetWide() - YRP:ctr(980), YRP:ctr(60), YRP:ctr(960), YRP:ctr(20))
			function ea.top:Paint(pw, ph)
				if ea.typ ~= nil then
					local tab = {}
					tab.color = YRPGetColor("3")
					DrawPanel(self, tab)
					ea.tab.string_name = tostring(ea.tab.string_name)
					local tab2 = {}
					tab2.w = pw
					tab2.h = ph
					tab2.x = YRP:ctr(20)
					tab2.y = ph / 2
					tab2.ax = 0
					if ea.tab.uniqueID == 1 then
						tab2.text = "[MAIN] " .. YRP:trans("LID_" .. ea.typ) .. ": " .. ea.tab.string_name
					else
						tab2.text = YRP:trans("LID_" .. ea.typ) .. ": " .. ea.tab.string_name
					end

					local darkrpjobname = YRPConvertToDarkRPJobName(ea.tab.string_name)
					if ea.tab.string_identifier and not strEmpty(ea.tab.string_identifier) then
						darkrpjobname = ea.tab.string_identifier
					end

					if ea.typ == "role" and ea.tab.uniqueID ~= nil then
						tab2.text = tab2.text .. "       DarkRP-Job-Name: " .. string.upper(darkrpjobname) .. "      RoleUID: " .. ea.tab.uniqueID
					elseif ea.typ == "group" and ea.tab.uniqueID ~= nil then
						tab2.text = tab2.text .. "       GroupUID: " .. ea.tab.uniqueID
					end

					tab2.font = "Y_18_700"
					tab2.color = tab.color
					YRPDrawText(tab2)
				end
			end

			net.Receive(
				"nws_yrp_settings_subscribe_group",
				function(le)
					local group = net.ReadTable()
					local groups = net.ReadTable()
					local db_ugs = net.ReadTable()
					if YRPPanelAlive(ea.background, "GAR 8") then
						if group.uniqueID ~= nil then
							net.Start("nws_yrp_settings_subscribe_rolelist")
							net.WriteString(group.uniqueID)
							net.WriteString("0")
							net.SendToServer()
						end

						group.uniqueID = tonumber(group.uniqueID)
						if group.uniqueID and group.uniqueID > 0 then
							cur_group.edi = group.uniqueID
							ea.typ = "group"
							ea.tab = group
							ea[group.uniqueID] = ea[group.uniqueID] or {}
							ea.background:Clear()
							local col1 = YRPCreateD("DPanelList", ea.background, YRP:ctr(1000), ea.background:GetTall() - YRP:ctr(40), YRP:ctr(20), YRP:ctr(20))
							col1:SetSpacing(YRP:ctr(20))
							local info = YRPCreateD("YGroupBox", col1, YRP:ctr(1000), YRP:ctr(920), YRP:ctr(0), YRP:ctr(0))
							info:SetText("LID_general")
							function info:Paint(pw, ph)
								hook.Run("YGroupBoxPaint", self, pw, ph)
							end

							col1:AddItem(info)
							ea[group.uniqueID].info = info
							ea.info = ea[group.uniqueID].info
							function ea.info:OnRemove()
								if cur_group.edi ~= group.uniqueID then
									net.Start("nws_yrp_settings_unsubscribe_group")
									net.WriteString(group.uniqueID)
									net.SendToServer()
								end
							end

							local name = {}
							name.parent = ea.info:GetContent()
							name.uniqueID = group.uniqueID
							name.header = "LID_name"
							name.netstr = "nws_yrp_update_group_string_name"
							name.value = group.string_name
							name.uniqueID = group.uniqueID
							name.lforce = false
							ea[group.uniqueID].name = DTextBox(name)
							local hr = {}
							hr.h = YRP:ctr(16)
							hr.parent = ea.info:GetContent()
							DHr(hr)
							local color = {}
							color.parent = ea.info:GetContent()
							color.uniqueID = group.uniqueID
							color.header = "LID_color"
							color.netstr = "nws_yrp_update_group_string_color"
							color.value = group.string_color
							color.uniqueID = group.uniqueID
							color.lforce = false
							ea[group.uniqueID].color = DColor(color)
							DHr(hr)
							local icon = {}
							icon.parent = ea.info:GetContent()
							icon.uniqueID = group.uniqueID
							icon.header = "LID_icon"
							icon.netstr = "nws_yrp_update_group_string_icon"
							icon.value = group.string_icon
							icon.uniqueID = group.uniqueID
							icon.lforce = false
							ea[group.uniqueID].icon = DTextBox(icon)
							DHr(hr)
							local desc = {}
							desc.parent = ea.info:GetContent()
							desc.uniqueID = group.uniqueID
							desc.header = "LID_description"
							desc.netstr = "nws_yrp_update_group_string_description"
							desc.value = group.string_description
							desc.uniqueID = group.uniqueID
							desc.lforce = false
							desc.multiline = true
							desc.h = 140
							ea[group.uniqueID].desc = DTextBox(desc)
							DHr(hr)
							local othergroups = {}
							othergroups[0] = YRP:trans("LID_factions")
							for i, tab in pairs(groups) do
								tab.uniqueID = tonumber(tab.uniqueID)
								group.uniqueID = tonumber(group.uniqueID)
								if tab.uniqueID > 0 and tab.uniqueID ~= group.uniqueID then
									othergroups[tab.uniqueID] = tab.string_name --.. " [UID: " .. tab.uniqueID .. "]"
								end
							end

							if group.uniqueID > 1 then
								local parentgroup = {}
								parentgroup.parent = ea.info:GetContent()
								parentgroup.uniqueID = group.uniqueID
								parentgroup.header = "LID_parentgroup"
								parentgroup.netstr = "nws_yrp_update_group_int_parentgroup"
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
							iscp.netstr = "nws_yrp_update_group_bool_iscp"
							iscp.value = group.bool_iscp
							iscp.uniqueID = group.uniqueID
							ea[group.uniqueID].iscp = YRPDCheckBox(iscp)
							local restriction = YRPCreateD("YGroupBox", col1, YRP:ctr(1000), YRP:ctr(570), YRP:ctr(0), YRP:ctr(0))
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
									if ug.string_name ~= nil then
										ugs["ALL"]["choices"][string.upper(ug.string_name)] = ugs["ALL"]["choices"][string.upper(ug.string_name)] or {}
										ugs["ALL"]["choices"][string.upper(ug.string_name)].checked = table.HasValue(gugs, string.upper(ug.string_name))
									else
										YRP:msg("note", "WHATS THAT? #1")
										pFTab(ug)
									end
								end

								local usergroups = {}
								usergroups.parent = ea.restriction:GetContent()
								usergroups.uniqueID = group.uniqueID
								usergroups.header = "LID_usergroups"
								usergroups.netstr = "nws_yrp_update_group_string_usergroups"
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
								requireslevel.netstr = "nws_yrp_update_group_int_requireslevel"
								requireslevel.value = group.int_requireslevel
								requireslevel.uniqueID = group.uniqueID
								requireslevel.lforce = false
								requireslevel.min = 1
								requireslevel.max = 10000000
								ea[group.uniqueID].requireslevel = DIntBox(requireslevel)
								DHr(hr)
							end

							if group.uniqueID > 1 then
								local whitelist = {}
								whitelist.parent = ea.restriction:GetContent()
								whitelist.uniqueID = group.uniqueID
								whitelist.header = "LID_useswhitelist"
								whitelist.netstr = "nws_yrp_update_group_bool_whitelist"
								whitelist.value = group.bool_whitelist
								whitelist.uniqueID = group.uniqueID
								whitelist.lforce = false
								ea[group.uniqueID].whitelist = YRPDCheckBox(whitelist)
								DHr(hr)
							end

							if group.uniqueID ~= 1 then
								local locked = {}
								locked.parent = ea.restriction:GetContent()
								locked.uniqueID = group.uniqueID
								locked.header = "LID_locked"
								locked.netstr = "nws_yrp_update_group_bool_locked"
								locked.value = group.bool_locked
								locked.uniqueID = group.uniqueID
								locked.lforce = false
								ea[group.uniqueID].locked = YRPDCheckBox(locked)
								DHr(hr)
							end

							if group.uniqueID > 1 then
								local visible = {}
								visible.parent = ea.restriction:GetContent()
								visible.uniqueID = group.uniqueID
								visible.header = YRP:trans("LID_visible") .. " ( " .. YRP:trans("LID_charactercreation") .. " )"
								visible.netstr = "nws_yrp_update_group_bool_visible_cc"
								visible.value = group.bool_visible_cc
								visible.uniqueID = group.uniqueID
								visible.lforce = false
								ea[group.uniqueID].visible = YRPDCheckBox(visible)
							end

							DHr(hr)
							local visible2 = {}
							visible2.parent = ea.restriction:GetContent()
							visible2.uniqueID = group.uniqueID
							visible2.header = YRP:trans("LID_visible") .. " ( " .. YRP:trans("LID_rolemenu") .. " )"
							visible2.netstr = "nws_yrp_update_group_bool_visible_rm"
							visible2.value = group.bool_visible_rm
							visible2.uniqueID = group.uniqueID
							visible2.lforce = false
							ea[group.uniqueID].visible2 = YRPDCheckBox(visible2)
							local col2 = YRPCreateD("DPanelList", ea.background, YRP:ctr(800 + 24), ea.background:GetTall() - YRP:ctr(40), YRP:ctr(20), YRP:ctr(20))
							col2:EnableVerticalScrollbar(true)
							col2:SetSpacing(YRP:ctr(20))
							local sbar = col2.VBar
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

							local equipment = YRPCreateD("YGroupBox", ea.background, YRP:ctr(800), YRP:ctr(1250), 0, 0)
							equipment:SetText("LID_equipment")
							function equipment:Paint(pw, ph)
								hook.Run("YGroupBoxPaint", self, pw, ph)
							end

							col2:AddItem(equipment)
							ea.background:AddPanel(col2)
							ea[group.uniqueID].equipment = equipment
							ea.equipment = ea[group.uniqueID].equipment
							-- SWEPS
							local sweps = {}
							sweps.parent = ea.equipment:GetContent()
							sweps.uniqueID = group.uniqueID
							sweps.header = "LID_sweps"
							sweps.netstr = "nws_yrp_update_group_string_sweps"
							sweps.value = group.string_sweps
							sweps.uniqueID = group.uniqueID
							sweps.w = ea.equipment:GetContent():GetWide()
							sweps.h = YRP:ctr(325)
							sweps.doclick = function()
								local winswep = YRPCreateD("DFrame", nil, ScrW(), ScrH(), 0, 0)
								winswep:SetTitle("")
								winswep:Center()
								winswep:MakePopup()
								function winswep:Paint(pw, ph)
									draw.RoundedBox(0, 0, 0, pw, ph, Color(80, 80, 80, 255))
									draw.SimpleText(YRP:trans("LID_search") .. ": ", "DermaDefault", YRP:ctr(20 + 100), YRP:ctr(50 + 25), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
								end

								local allsweps = YRPGetSWEPsList()
								local cl_sweps = {}
								local count = 0
								for k, v in pairs(allsweps) do
									count = count + 1
									cl_sweps[count] = {}
									cl_sweps[count].WorldModel = v.WorldModel or ""
									cl_sweps[count].ClassName = v.ClassName or "NO CLASSNAME"
									cl_sweps[count].PrintName = v.PrintName or v.ClassName or "NO PRINTNAME"
								end

								winswep.dpl = YRPCreateD("DPanelList", winswep, ScrW() - YRP:ctr(20 * 2), ScrH() - YRP:ctr(100 + 20), YRP:ctr(20), YRP:ctr(100))
								winswep.dpl:EnableVerticalScrollbar(true)
								local height = ScrH() - YRP:ctr(100)
								function winswep:Search(strsearch)
									strsearch = string.lower(strsearch)
									strsearch = string.Replace(strsearch, "[", "")
									strsearch = string.Replace(strsearch, "]", "")
									strsearch = string.Replace(strsearch, "%", "")
									self.dpl:Clear()
									for i, v in pairs(cl_sweps) do
										if string.find(string.lower(v.PrintName), strsearch, 1, true) or string.find(string.lower(v.ClassName), strsearch, 1, true) or string.find(string.lower(v.WorldModel), strsearch, 1, true) then
											local d_swep = YRPCreateD("YButton", nil, winswep.dpl:GetWide(), height / 4, 0, 0)
											d_swep:SetText(v.PrintName)
											function d_swep:DoClick()
												net.Start("nws_yrp_settings_add_sweps")
												net.WriteInt(group.uniqueID, 32)
												net.WriteString(v.ClassName)
												net.SendToServer()
												winswep:Close()
											end

											if v.WorldModel ~= "" then
												d_swep.model = YRPCreateD("DModelPanel", d_swep, d_swep:GetTall(), d_swep:GetTall(), 0, 0)
												d_swep.model:SetModel(v.WorldModel)
											else
												d_swep.model = YRPCreateD("DPanel", d_swep, d_swep:GetTall(), d_swep:GetTall(), 0, 0)
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
								winswep.search = YRPCreateD("DTextEntry", winswep, ScrW() - YRP:ctr(20 + 100 + 20), YRP:ctr(50), YRP:ctr(20 + 100), YRP:ctr(50))
								function winswep.search:OnChange()
									winswep:Search(self:GetText())
								end
							end

							ea[group.uniqueID].sweps = DStringListBox(sweps)
							net.Receive(
								"nws_yrp_settings_get_sweps",
								function()
									local tab_pm = net.ReadTable()
									local cl_sweps = {}
									for i, v in pairs(tab_pm) do
										local swep = {}
										swep.uniqueID = i
										swep.string_models = GetSwepWorldModel(v)
										swep.string_classname = v
										swep.string_name = v
										swep.doclick = function()
											net.Start("nws_yrp_settings_rem_sweps")
											net.WriteInt(group.uniqueID, 32)
											net.WriteString(swep.string_classname)
											net.SendToServer()
										end

										swep.h = YRP:ctr(120)
										table.insert(cl_sweps, swep)
									end

									if ea[group.uniqueID].sweps.dpl.AddLines ~= nil then
										ea[group.uniqueID].sweps.dpl:AddLines(cl_sweps)
									end
								end
							)

							net.Start("nws_yrp_settings_get_sweps")
							net.WriteInt(group.uniqueID, 32)
							net.SendToServer()
							hr.parent = ea.equipment:GetContent()
							DHr(hr)
							-- Ammunation
							local ammobg = YRPCreateD("YPanel", col2, YRP:ctr(800), YRP:ctr(850), 0, 0)
							local ammoheader = YRPCreateD("YLabel", ammobg, YRP:ctr(800), YRP:ctr(50), 0, 0)
							ammoheader:SetText("LID_ammo")
							function ammoheader:Paint(pw, ph)
								draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
								draw.SimpleText(YRP:trans(self:GetText()), "Y_18_700", pw / 2, ph / 2, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
							end

							ammolist = YRPCreateD("DPanelList", ammobg, YRP:ctr(800 - 23 - 20), YRP:ctr(800), 0, YRP:ctr(50))
							ammolist:SetSpacing(2)
							ammolist:EnableVerticalScrollbar(true)
							local sbar2 = ammolist.VBar
							function sbar2:Paint(w, h)
								draw.RoundedBox(0, 0, 0, w, h, YRPInterfaceValue("YFrame", "NC"))
							end

							function sbar2.btnUp:Paint(w, h)
								draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
							end

							function sbar2.btnDown:Paint(w, h)
								draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
							end

							function sbar2.btnGrip:Paint(w, h)
								draw.RoundedBox(w / 2, 0, 0, w, h, YRPInterfaceValue("YFrame", "HI"))
							end

							local tammos = group.string_ammos or ""
							tammos = string.Explode(";", tammos)
							local ammos = {}
							for i, v in pairs(tammos) do
								local t = string.Split(v, ":")
								ammos[t[1]] = t[2]
							end

							function YRPUpdateAmmoAmountGroup()
								local tab = {}
								for i, v in pairs(ammos) do
									if tonumber(v) > 0 then
										table.insert(tab, i .. ":" .. v)
									end
								end

								local result = table.concat(tab, ";")
								net.Start("nws_yrp_update_group_string_ammos")
								net.WriteString(group.uniqueID)
								net.WriteString(result)
								net.SendToServer()
							end

							for i, v in pairs(game.GetAmmoTypes()) do
								local abg = YRPCreateD("YPanel", nil, YRP:ctr(800), YRP:ctr(50), 0, 0)
								local ahe = YRPCreateD("YLabel", abg, YRP:ctr(400), YRP:ctr(50), 0, 0)
								ahe:SetText(v)
								function ahe:Paint(pw, ph)
									draw.RoundedBox(0, 0, 0, pw, ph, Color(100, 100, 255))
									draw.SimpleText(self:GetText(), "Y_18_700", ph / 2, ph / 2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
								end

								local ava = YRPCreateD("DNumberWang", abg, YRP:ctr(400), YRP:ctr(50), YRP:ctr(400), 0)
								ava:SetDecimals(0)
								ava:SetMin(0)
								ava:SetMax(999)
								ava:SetValue(ammos[v] or 0)
								function ava:OnValueChanged(val)
									ammos[v] = math.Clamp(val, self:GetMin(), self:GetMax())
									YRPUpdateAmmoAmountGroup()
								end

								ammolist:AddItem(abg)
							end

							ea.equipment:AddItem(ammobg)
							ea.equipment:AutoSize(true)
						end
					end
				end
			)

			function CreateLineRole(parent, role)
				role.uniqueID = tonumber(role.uniqueID)
				rs.rplist[role.uniqueID] = rs.rplist[role.uniqueID] or {}
				rs.rplist[role.uniqueID] = YRPCreateD("YButton", parent, parent:GetWide() - YRP:ctr(20), YRP:ctr(120), 0, 0)
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
					tab2.x = YRP:ctr(182)
					tab2.y = YRP:ctr(20)
					tab2.ax = 0
					tab2.ay = 0
					tab2.text = self.text
					tab2.font = "Y_18_700"
					tab2.lforce = false
					tab2.color = rs.rplist[role.uniqueID]["string_color"]
					YRPDrawText(tab2)
				end

				function pnl:DoClick()
					net.Start("nws_yrp_settings_subscribe_role")
					net.WriteString(role.uniqueID .. "")
					net.SendToServer()
				end

				rs.rplist[role.uniqueID].ico = YRPCreateD("DHTML", rs.rplist[role.uniqueID], rs.rplist[role.uniqueID]:GetTall() - YRP:ctr(20), rs.rplist[role.uniqueID]:GetTall() - YRP:ctr(20), YRP:ctr(60), YRP:ctr(10))
				local ico = rs.rplist[role.uniqueID].ico
				function ico:Paint(pw, ph)
				end

				ico:SetHTML(YRPGetHTMLImage(role.string_icon, ico:GetWide(), ico:GetTall()))
				YRPTestHTML(ico, role.string_icon, false)
				rs.rplist[role.uniqueID].up = YRPCreateD("YButton", rs.rplist[role.uniqueID], YRP:ctr(40), YRP:ctr(40), YRP:ctr(10), YRP:ctr(10))
				rs.rplist[role.uniqueID].up:SetText("")
				local up = rs.rplist[role.uniqueID].up
				function up:Paint(pw, ph)
					if rs.rplist[role.uniqueID].int_position > 1 then
						hook.Run("YButtonPaint", self, pw, ph)
						if YRP:GetDesignIcon("64_angle-up") then
							surface.SetDrawColor(Color(255, 255, 255, 255))
							surface.SetMaterial(YRP:GetDesignIcon("64_angle-up"))
							surface.DrawTexturedRect(0, 0, pw, ph)
						end
					end
				end

				function up:DoClick()
					net.Start("nws_yrp_settings_role_position_up")
					net.WriteString(rs.rplist[role.uniqueID].uniqueID)
					net.SendToServer()
				end

				rs.rplist[role.uniqueID].dn = YRPCreateD("YButton", rs.rplist[role.uniqueID], YRP:ctr(40), YRP:ctr(40), YRP:ctr(10), rs.rplist[role.uniqueID]:GetTall() - YRP:ctr(40 + 10))
				rs.rplist[role.uniqueID].dn:SetText("")
				local dn = rs.rplist[role.uniqueID].dn
				function dn:Paint(pw, ph)
					if rs.rplist[role.uniqueID].int_position < table.Count(rs.rplist.tab) then
						hook.Run("YButtonPaint", self, pw, ph)
						if YRP:GetDesignIcon("64_angle-down") then
							surface.SetDrawColor(Color(255, 255, 255, 255))
							surface.SetMaterial(YRP:GetDesignIcon("64_angle-down"))
							surface.DrawTexturedRect(0, 0, pw, ph)
						end
					end
				end

				function dn:DoClick()
					net.Start("nws_yrp_settings_role_position_dn")
					net.WriteString(rs.rplist[role.uniqueID].uniqueID)
					net.SendToServer()
				end

				rs.rplist[role.uniqueID].ch = YRPCreateD("YButton", rs.rplist[role.uniqueID], YRP:ctr(40), YRP:ctr(40), rs.rplist[role.uniqueID]:GetWide() - YRP:ctr(66), rs.rplist[role.uniqueID]:GetTall() - YRP:ctr(60))
				rs.rplist[role.uniqueID].ch:SetText("")
				local ch = rs.rplist[role.uniqueID].ch
				local text = YRP:trans("LID_nextranks") .. " ▶"
				surface.SetFont("Y_14_700")
				local tw, _ = surface.GetTextSize(text)
				tw = tw + YRP:ctr(20)
				ch:SetWide(tw)
				ch:SetPos(rs.rplist[role.uniqueID]:GetWide() - tw - YRP:ctr(10 + 10), rs.rplist[role.uniqueID]:GetTall() - YRP:ctr(40 + 10))
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
					tab2.font = "Y_14_700"
					tab2.color = tab.color
					YRPDrawText(tab2)
				end

				function ch:DoClick()
					rs.rplist:ClearList()
					if cur_role.gro and cur_role.pre then
						net.Start("nws_yrp_settings_unsubscribe_rolelist")
						net.WriteString(cur_role.gro)
						net.WriteString(cur_role.pre)
						net.SendToServer()
					end

					timer.Simple(
						0.01,
						function()
							if cur_role.gro and rs and YRPPanelAlive(rs.rplist, "GAR 9") and rs.rplist[role.uniqueID] and rs.rplist[role.uniqueID].uniqueID then
								net.Start("nws_yrp_settings_subscribe_rolelist")
								net.WriteString(cur_role.gro)
								net.WriteString(rs.rplist[role.uniqueID].uniqueID)
								net.SendToServer()
							end
						end
					)
				end

				parent:AddItem(rs.rplist[role.uniqueID])
			end

			net.Receive(
				"nws_yrp_settings_subscribe_role",
				function(le)
					local role = net.ReadTable()
					local roles = net.ReadTable()
					local db_ugs = net.ReadTable()
					local db_groups = net.ReadTable()
					local db_huds = net.ReadTable()
					local db_hudmasks = net.ReadTable()
					if not IsNotNilAndNotFalse(db_groups) or not IsNotNilAndNotFalse(db_ugs) or not IsNotNilAndNotFalse(roles) or not IsNotNilAndNotFalse(role) then return end
					role.uniqueID = tonumber(role.uniqueID)
					cur_role.gro = role.int_groupID
					cur_role.edi = role.uniqueID
					if not ea then
						YRP:msg("note", "Closed F8/Switched f8 site?")

						return
					end

					ea.typ = "role"
					ea.tab = role
					if role.uniqueID == nil then return end
					ea[role.uniqueID] = ea[role.uniqueID] or {}
					ea.background:Clear()
					local col1 = YRPCreateD("DPanelList", ea.background, YRP:ctr(800 + 24), ea.background:GetTall() - YRP:ctr(40), YRP:ctr(20), YRP:ctr(20))
					col1:EnableVerticalScrollbar(true)
					col1:SetSpacing(YRP:ctr(20))
					local sbar3 = col1.VBar
					function sbar3:Paint(w, h)
						draw.RoundedBox(0, 0, 0, w, h, YRPInterfaceValue("YFrame", "NC"))
					end

					function sbar3.btnUp:Paint(w, h)
						draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
					end

					function sbar3.btnDown:Paint(w, h)
						draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
					end

					function sbar3.btnGrip:Paint(w, h)
						draw.RoundedBox(w / 2, 0, 0, w, h, YRPInterfaceValue("YFrame", "HI"))
					end

					local info = YRPCreateD("YGroupBox", col1, YRP:ctr(800), YRP:ctr(866), YRP:ctr(20), YRP:ctr(20))
					info:SetText("LID_general")
					function info:Paint(pw, ph)
						hook.Run("YGroupBoxPaint", self, pw, ph)
					end

					col1:AddItem(info)
					ea[role.uniqueID].info = info
					ea.info = ea[role.uniqueID].info
					function ea.info:OnRemove()
						if cur_role.edi ~= role.uniqueID then
							net.Start("nws_yrp_settings_unsubscribe_role")
							net.WriteString(role.uniqueID)
							net.SendToServer()
						end
					end

					local name = {}
					name.parent = ea.info:GetContent()
					name.uniqueID = role.uniqueID
					name.header = "LID_name"
					name.netstr = "nws_yrp_update_role_string_name"
					name.value = role.string_name
					name.uniqueID = role.uniqueID
					name.lforce = false
					ea[role.uniqueID].name = DTextBox(name)
					local hr = {}
					hr.h = YRP:ctr(16)
					hr.parent = ea.info:GetContent()
					DHr(hr)
					local identifier = {}
					identifier.parent = ea.info:GetContent()
					identifier.uniqueID = role.uniqueID
					identifier.header = "LID_identifier"
					identifier.netstr = "nws_yrp_update_role_string_identifier"
					identifier.value = role.string_identifier
					identifier.uniqueID = role.uniqueID
					identifier.lforce = false
					identifier.placeholder = "NO SPECIAL IDENTIFIER"
					identifier.hardmode = true
					ea[role.uniqueID].identifier = DTextBox(identifier)
					local ident = ea[role.uniqueID].identifier
					function ident:OnChange()
						role.string_identifier = self:GetText()
					end

					DHr(hr)
					local color = {}
					color.parent = ea.info:GetContent()
					color.uniqueID = role.uniqueID
					color.header = "LID_color"
					color.netstr = "nws_yrp_update_role_string_color"
					color.value = role.string_color
					color.uniqueID = role.uniqueID
					color.lforce = false
					ea[role.uniqueID].color = DColor(color)
					DHr(hr)
					local icon = {}
					icon.parent = ea.info:GetContent()
					icon.uniqueID = role.uniqueID
					icon.header = "LID_icon"
					icon.netstr = "nws_yrp_update_role_string_icon"
					icon.value = role.string_icon
					icon.uniqueID = role.uniqueID
					icon.lforce = false
					ea[role.uniqueID].icon = DTextBox(icon)
					DHr(hr)
					local maxa = {}
					maxa[0] = YRP:trans("LID_disabled")
					for i = 1, 128 do
						maxa[i] = i
					end

					if role.uniqueID > 1 then
						local maxamount = {}
						maxamount.parent = ea.info:GetContent()
						maxamount.uniqueID = role.uniqueID
						maxamount.header = "LID_maxamount"
						maxamount.netstr = "nws_yrp_update_role_int_maxamount"
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
						amountpercentage.netstr = "nws_yrp_update_role_int_amountpercentage"
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
							if IsNotNilAndNotFalse(tab.string_name) and IsNotNilAndNotFalse(tab.uniqueID) and tab.uniqueID ~= -1 then
								grps[tab.uniqueID] = tab.string_name .. " [UID: " .. tab.uniqueID .. "]"
							end
						end

						local int_groupID = {}
						int_groupID.parent = ea.info:GetContent()
						int_groupID.uniqueID = role.uniqueID
						int_groupID.header = "LID_group"
						int_groupID.netstr = "nws_yrp_update_role_int_groupID"
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
					string_description.netstr = "nws_yrp_update_role_string_description"
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
					salary.netstr = "nws_yrp_update_role_int_salary"
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
					salarytime.netstr = "nws_yrp_update_role_int_salarytime"
					salarytime.value = role.int_salarytime
					salarytime.uniqueID = role.uniqueID
					salarytime.lforce = false
					salarytime.min = 1
					salarytime.max = 9999
					ea[role.uniqueID].requireslevel = DIntBox(salarytime)
					DHr(hr)
					local otherroles = {}
					otherroles[0] = YRP:trans("LID_none")
					for i, tab in pairs(roles) do
						tab.uniqueID = tonumber(tab.uniqueID)
						if tab.uniqueID ~= role.uniqueID and tab.int_groupID == role.int_groupID then
							otherroles[tab.uniqueID] = tab.string_name --.. " [UID: " .. tab.uniqueID .. "]"
						end
					end

					if role.uniqueID > 1 then
						local prerole = {}
						prerole.parent = ea.info:GetContent()
						prerole.uniqueID = role.uniqueID
						prerole.header = YRP:trans("LID_prerole") .. " | " .. YRP:trans("LID_prerank")
						prerole.netstr = "nws_yrp_update_role_int_prerole"
						prerole.value = tonumber(role.int_prerole)
						prerole.uniqueID = role.uniqueID
						prerole.lforce = false
						prerole.choices = otherroles
						ea[role.uniqueID].prerole = YRPDComboBox(prerole)
						DHr(hr)
					end

					local rod_roles = {}
					rod_roles[0] = YRP:trans("LID_none")
					for i, tab in pairs(roles) do
						tab.uniqueID = tonumber(tab.uniqueID)
						rod_roles[tab.uniqueID] = tab.string_name --.. " [UID: " .. tab.uniqueID .. "]"
					end

					rod_roles[0] = YRP:trans("LID_none")
					local roleondeath = {}
					roleondeath.parent = ea.info:GetContent()
					roleondeath.uniqueID = role.uniqueID
					roleondeath.header = YRP:trans("LID_roleafterdeath")
					roleondeath.netstr = "nws_yrp_update_role_int_roleondeath"
					roleondeath.value = tonumber(role.int_roleondeath)
					roleondeath.uniqueID = role.uniqueID
					roleondeath.lforce = false
					roleondeath.choices = rod_roles
					ea[role.uniqueID].roleondeath = YRPDComboBox(roleondeath)
					ea.info:AutoSize(true)
					-- FLAGS
					local flags = YRPCreateD("YGroupBox", col1, ea.info:GetWide(), YRP:ctr(800), YRP:ctr(20), ea.info.y + ea.info:GetTall() + YRP:ctr(20))
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
					bool_instructor.netstr = "nws_yrp_update_role_bool_instructor"
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
					custom_flags.netstr = "nws_yrp_update_role_string_customflags"
					custom_flags.value = role.string_customflags
					custom_flags.uniqueID = role.uniqueID
					custom_flags.w = ea.flags:GetContent():GetWide()
					custom_flags.h = YRP:ctr(225)
					custom_flags.doclick = function()
						net.Receive(
							"nws_yrp_get_all_role_customflags",
							function()
								local cf = net.ReadTable()
								local win = YRPCreateD("DFrame", nil, YRP:ctr(800), YRP:ctr(800), 0, 0)
								win:SetTitle("")
								win:Center()
								win:MakePopup()
								win.dpl = YRPCreateD("DPanelList", win, YRP:ctr(800), YRP:ctr(750), 0, YRP:ctr(50))
								for i, flag in pairs(cf) do
									local line = YRPCreateD("YButton", nil, YRP:ctr(800), YRP:ctr(50), 0, 0)
									line:SetText(flag.string_name)
									function line:DoClick()
										net.Start("nws_yrp_add_role_flag")
										net.WriteInt(role.uniqueID, 32)
										net.WriteInt(flag.uniqueID, 32)
										net.SendToServer()
										win:Close()
									end

									win.dpl:AddItem(line)
								end
							end
						)

						net.Start("nws_yrp_get_all_role_customflags")
						net.SendToServer()
					end

					ea[role.uniqueID].custom_flags = DStringListBox(custom_flags)
					net.Receive(
						"nws_yrp_get_role_customflags",
						function()
							local tab_cf = net.ReadTable()
							for i, v in pairs(tab_cf) do
								v.doclick = function()
									net.Start("nws_yrp_rem_role_flag")
									net.WriteInt(role.uniqueID, 32)
									net.WriteInt(v.uniqueID, 32)
									net.SendToServer()
								end
							end

							if ea[role.uniqueID].custom_flags.dpl.AddLines ~= nil then
								ea[role.uniqueID].custom_flags.dpl:AddLines(tab_cf)
							end
						end
					)

					net.Start("nws_yrp_get_role_customflags")
					net.WriteInt(role.uniqueID, 32)
					net.SendToServer()
					ea.flags:AutoSize(true)
					local col2 = YRPCreateD("DPanelList", ea.background, YRP:ctr(800 + 24), ea.background:GetTall() - YRP:ctr(40), YRP:ctr(20), YRP:ctr(20))
					col2:EnableVerticalScrollbar(true)
					col2:SetSpacing(YRP:ctr(20))
					local sbar4 = col2.VBar
					function sbar4:Paint(w, h)
						draw.RoundedBox(0, 0, 0, w, h, YRPInterfaceValue("YFrame", "NC"))
					end

					function sbar4.btnUp:Paint(w, h)
						draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
					end

					function sbar4.btnDown:Paint(w, h)
						draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
					end

					function sbar4.btnGrip:Paint(w, h)
						draw.RoundedBox(w / 2, 0, 0, w, h, YRPInterfaceValue("YFrame", "HI"))
					end

					local appearance = YRPCreateD("YGroupBox", ea.background, YRP:ctr(800), YRP:ctr(800), YRP:ctr(840), YRP:ctr(20))
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
					playermodels.netstr = "nws_yrp_update_role_string_playermodels"
					playermodels.value = role.string_playermodels
					playermodels.uniqueID = role.uniqueID
					playermodels.w = ea.appearance:GetContent():GetWide()
					playermodels.h = YRP:ctr(425)
					playermodels.doclick = function()
						local pms = {}
						local win = YRPCreateD("YFrame", nil, YRP:ctr(1400), YRP:ctr(1400), 0, 0)
						win:SetHeaderHeight(YRP:ctr(100))
						win:SetTitle("LID_search")
						win:Center()
						win:MakePopup()
						local content = win:GetContent()
						win.add = YRPCreateD("YButton", content, YRP:ctr(50), YRP:ctr(50), YRP:ctr(20), YRP:ctr(20))
						win.add:SetText("+")
						function win.add:DoClick()
							win:Close()
							local lply = LocalPlayer()
							lply.yrpseltab = {}
							local pmwin = YRPCreateD("YFrame", nil, YRP:ctr(1400), YRP:ctr(1400), 0, 0)
							pmwin:SetHeaderHeight(YRP:ctr(100))
							pmwin:Center()
							pmwin:MakePopup()
							pmwin:SetTitle("")
							local pmcontent = pmwin:GetContent()
							pmwin.pms = {}
							pmwin.name = YRPCreateD("DTextEntry", pmcontent, YRP:ctr(300), YRP:ctr(50), YRP:ctr(20 + 300 + 20 + 300 + 20 + 100), YRP:ctr(50 + 20))
							pmwin.float_min = YRPCreateD("DNumberWang", pmcontent, YRP:ctr(200), YRP:ctr(50), YRP:ctr(20), YRP:ctr(210))
							pmwin.float_max = YRPCreateD("DNumberWang", pmcontent, YRP:ctr(200), YRP:ctr(50), YRP:ctr(20 + 200 + 20), YRP:ctr(210))
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

							pmwin.list = YRPCreateD("DPanelList", pmcontent, pmcontent:GetWide() - YRP:ctr(40), pmcontent:GetTall() - YRP:ctr(20 + 50 + 20 + 300 + 20 + 20), YRP:ctr(20), YRP:ctr(300 + 20))
							pmwin.list:EnableVerticalScrollbar(true)
							pmwin.list:SetSpacing(10)
							function pmwin.list:RefreshList()
								local lpl = LocalPlayer()
								if IsNotNilAndNotFalse(lpl.yrpseltab) and pmwin.list ~= nil and YRPPanelAlive(pmwin.list, "GAR 10") then
									pmwin.list:Clear()
									for i, pm in pairs(lpl.yrpseltab) do
										timer.Simple(
											i * 0.001,
											function()
												if IsNotNilAndNotFalse(pmwin) and YRPPanelAlive(pmwin.list, "GAR 11") then
													local line = YRPCreateD("DPanel", pmwin.list, YRP:ctr(200), YRP:ctr(64), 0, 0)
													line.pm = pm
													function line:Paint(pw, ph)
														draw.RoundedBox(ph / 2, 0, 0, pw, ph, Color(255, 255, 255, 255))
														draw.SimpleText(self.pm, "DermaDefault", ph + YRP:ctr(10), ph / 2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
													end

													line.dmp = YRPCreateD("DModelPanel", line, YRP:ctr(64), YRP:ctr(64), 0, 0)
													line.dmp:SetModel(pm)
													pmwin.list:AddItem(line)
												end
											end
										)
									end
								end
							end

							function pmwin:Paint(pw, ph)
								hook.Run("YFramePaint", self, pw, ph)
								draw.SimpleText(YRP:trans("LID_name") .. ": ", "DermaDefault", YRP:ctr(20 + 300 + 20 + 300 + 20 + 120), YRP:ctr(150), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
								draw.SimpleText(YRP:trans("LID_minimumsize") .. ":", "DermaDefault", YRP:ctr(40), YRP:ctr(300), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
								draw.SimpleText(YRP:trans("LID_maximumsize") .. ":", "DermaDefault", YRP:ctr(40 + 200 + 20), YRP:ctr(300), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
								draw.SimpleText(YRP:trans("LID_models") .. ":", "DermaDefault", YRP:ctr(40), YRP:ctr(410), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
							end

							pmwin.selpm = YRPCreateD("YButton", pmcontent, YRP:ctr(300), YRP:ctr(50), YRP:ctr(20), YRP:ctr(50 + 20))
							pmwin.selpm:SetText(YRP:trans("LID_playermodels"))
							function pmwin.selpm:DoClick()
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

								YRPOpenSelector(cl_pms, true, "worldmodel", pmwin.list.RefreshList)
							end

							pmwin.selnpm = YRPCreateD("YButton", pmcontent, YRP:ctr(300), YRP:ctr(50), YRP:ctr(20 + 300 + 20), YRP:ctr(50 + 20))
							pmwin.selnpm:SetText(YRP:trans("LID_othermodels"))
							function pmwin.selnpm:DoClick()
								local noneplayermodels = {}
								for _, addon in SortedPairsByMemberValue(engine.GetAddons(), "title") do
									if not addon.downloaded or not addon.mounted then continue end
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

								YRPOpenSelector(cl_pms, true, "worldmodel", pmwin.list.RefreshList)
							end

							pmwin.add = YRPCreateD("YButton", pmcontent, YRP:ctr(200), YRP:ctr(50), pmcontent:GetWide() / 2 - YRP:ctr(200 / 2), pmcontent:GetTall() - YRP:ctr(50 + 20))
							pmwin.add:SetText(YRP:trans("LID_add"))
							function pmwin.add:DoClick()
								if pmwin.WorldModel ~= "" then
									local lpl = LocalPlayer()
									lpl.yrpseltab = lpl.yrpseltab or {}
									local min = tonumber(pmwin.float_min:GetValue())
									local max = tonumber(pmwin.float_max:GetValue())
									net.Start("nws_yrp_add_playermodels")
									net.WriteInt(role.uniqueID, 32)
									net.WriteTable(lpl.yrpseltab)
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

						win.dpl = YRPCreateD("DPanelList", content, content:GetWide() - YRP:ctr(20 * 2), content:GetTall() - YRP:ctr(20 + 50 + 20 + 20), YRP:ctr(20), YRP:ctr(20 + 50 + 20))
						win.dpl:EnableVerticalScrollbar(true)
						function win.dpl:Paint(pw, ph)
							draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
						end

						win.delay = 0.02
						win.i = 1
						win.etime = CurTime()
						win.searching = false
						function win:Paint(pw, ph)
							hook.Run("YFramePaint", self, pw, ph)
							if self.searching then
								if CurTime() > self.etime then
									if pms[self.i] ~= nil then
										local pm = pms[self.i]
										self.searchstr = string.Replace(self.searchstr, "[", "")
										self.searchstr = string.Replace(self.searchstr, "]", "")
										self.searchstr = string.Replace(self.searchstr, "%", "")
										if YRPPanelAlive(win.dpl, "GAR 12") and string.find(string.lower(pm.string_name), self.searchstr, 1, true) or string.find(string.lower(pm.string_models), self.searchstr, 1, true) then
											local line = YRPCreateD("YButton", nil, YRP:ctr(800), YRP:ctr(200), 0, 0)
											line.string_name = pm.string_name
											line.models = string.Explode(",", pm.string_models)
											line:SetText("")
											function line:DoClick()
												net.Start("nws_yrp_add_role_playermodel")
												net.WriteInt(role.uniqueID, 32)
												net.WriteInt(pm.uniqueID, 32)
												net.SendToServer()
												win:Close()
											end

											function line:Paint(spw, sph)
												draw.RoundedBox(0, 0, 0, spw, sph, Color(140, 140, 140))
												draw.SimpleText(line.string_name, "DermaDefault", line:GetTall() + YRP:ctr(20), sph / 3, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
												draw.SimpleText(line.models[1], "DermaDefault", line:GetTall() + YRP:ctr(20), sph / 3 * 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
											end

											line.remove = YRPCreateD("YButton", line, YRP:ctr(300), YRP:ctr(100), win.dpl:GetWide() - YRP:ctr(350), YRP:ctr(50))
											line.remove:SetText("LID_remove")
											function line.remove:DoClick()
												function YRPNoDeletePMS()
												end

												--
												function YRPYesDeletePMS()
													net.Start("nws_yrp_rem_playermodel")
													net.WriteInt(pm.uniqueID, 32)
													net.SendToServer()
													line:Remove()
												end

												YRPAreYouSure(YRPYesDeletePMS, YRPNoDeletePMS)
											end

											function line.remove:Paint(spw, sph)
												draw.RoundedBox(16, 0, 0, pw, sph, Color(255, 140, 140))
												draw.SimpleText(YRP:trans("LID_remove") .. " ( " .. pm.uses .. " " .. "uses" .. " )", "DermaDefault", spw / 2, sph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
											end

											if line.models[1] ~= nil then
												line.model = YRPCreateD("DModelPanel", line, line:GetTall(), line:GetTall(), 0, 0)
												line.model:SetModel(line.models[1])
											else
												line.model = YRPCreateD("DPanel", line, line:GetTall(), line:GetTall(), 0, 0)
												function line.model:Paint(spw, sph)
													draw.RoundedBox(0, 0, 0, spw, sph, Color(80, 80, 80))
													draw.SimpleText("NO MODEL", "DermaDefault", spw / 2, sph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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
						win.search = YRPCreateD("DTextEntry", content, content:GetWide() - YRP:ctr(20 + 50 + 20 + 20), YRP:ctr(50), YRP:ctr(20 + 50 + 20), YRP:ctr(20))
						function win.search:OnChange()
							win:Search(self:GetText())
						end

						net.Receive(
							"nws_yrp_get_all_playermodels",
							function(l)
								if l > 128000 then
									YRP:msg("note", "[get_all_playermodels] len: " .. l)
								end

								local tab = net.ReadTable()
								table.insert(pms, tab)
								if YRPPanelAlive(win, "GAR 13") then
									win:Search(win:GetText())
								end
							end
						)

						net.Start("nws_yrp_get_all_playermodels")
						net.SendToServer()
					end

					ea[role.uniqueID].playermodels = DStringListBox(playermodels)
					net.Receive(
						"nws_yrp_get_role_playermodels",
						function()
							local tab_pm = net.ReadTable()
							for i, v in pairs(tab_pm) do
								v.doclick = function()
									net.Start("nws_yrp_rem_role_playermodel")
									net.WriteInt(role.uniqueID, 32)
									net.WriteInt(v.uniqueID, 32)
									net.SendToServer()
								end

								v.h = YRP:ctr(100)
							end

							if ea[role.uniqueID].playermodels.dpl.AddLines ~= nil then
								ea[role.uniqueID].playermodels.dpl:AddLines(tab_pm)
							end
						end
					)

					net.Start("nws_yrp_get_role_playermodels")
					net.WriteInt(role.uniqueID, 32)
					net.SendToServer()
					local bool_savebodygroups = {}
					bool_savebodygroups.parent = ea.appearance:GetContent()
					bool_savebodygroups.uniqueID = role.uniqueID
					bool_savebodygroups.header = "LID_savebodygroups"
					bool_savebodygroups.netstr = "nws_yrp_update_role_bool_savebodygroups"
					bool_savebodygroups.value = role.bool_savebodygroups
					bool_savebodygroups.uniqueID = role.uniqueID
					bool_savebodygroups.lforce = false
					ea[role.uniqueID].bool_savebodygroups = YRPDCheckBox(bool_savebodygroups)
					ea.appearance:AutoSize(true)
					local equipment = YRPCreateD("YGroupBox", ea.background, YRP:ctr(800), YRP:ctr(1250), ea.appearance.x, ea.appearance.y + ea.appearance:GetTall() + YRP:ctr(20))
					equipment:SetText("LID_equipment")
					function equipment:Paint(pw, ph)
						hook.Run("YGroupBoxPaint", self, pw, ph)
					end

					col2:AddItem(equipment)
					ea.background:AddPanel(col2)
					ea[role.uniqueID].equipment = equipment
					ea.equipment = ea[role.uniqueID].equipment
					if GetGlobalYRPBool("bool_weapon_system", true) then
						local info2 = YRPCreateD("DPanel", equipment, 100, 32, 0, 0)
						function info2:Paint(pw, ph)
							draw.SimpleText("First Go to F8 -> " .. YRP:trans("LID_administration") .. " -> " .. YRP:trans("LID_weaponsystem"), "Y_18_700", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						end

						equipment:AddItem(info2)
					end

					local sweps = {}
					sweps.parent = ea.equipment:GetContent()
					sweps.uniqueID = role.uniqueID
					if GetGlobalYRPBool("bool_weapon_system", true) then
						sweps.header = YRP:trans("LID_possiblesweps") .. ": Not Equipped => " .. YRP:trans("LID_weaponchest") .. ""
					else
						sweps.header = YRP:trans("LID_sweps")
					end

					sweps.netstr = "nws_yrp_update_role_string_sweps"
					sweps.value = role.string_sweps
					sweps.uniqueID = role.uniqueID
					sweps.w = ea.equipment:GetContent():GetWide()
					sweps.h = YRP:ctr(325)
					sweps.doclick = function()
						local lply = LocalPlayer()
						lply.yrpseltab = {}
						for i, v in pairs(string.Explode(",", role.string_sweps)) do
							if not table.HasValue(lply.yrpseltab) then
								table.insert(lply.yrpseltab, v)
							end
						end

						local allsweps = YRPGetSWEPsList()
						local cl_sweps = {}
						local count = 0
						for k, v in pairs(allsweps) do
							count = count + 1
							cl_sweps[count] = {}
							cl_sweps[count].WorldModel = v.WorldModel or ""
							cl_sweps[count].ClassName = v.ClassName or "NO CLASSNAME"
							cl_sweps[count].PrintName = v.PrintName or v.ClassName or "NO PRINTNAME"
						end

						function YRPAddSwepToRole()
							local lplayer = LocalPlayer()
							if role.uniqueID and lplayer.yrpseltab then
								net.Start("nws_yrp_add_role_swep")
								net.WriteInt(role.uniqueID, 32)
								net.WriteTable(lplayer.yrpseltab)
								net.SendToServer()
								role.string_sweps = table.concat(lplayer.yrpseltab, ",")
							elseif lplayer.yrpseltab and lplayer.yrpseltab[1] then
								MsgC(Color(0, 255, 0), "[YRPAddSwepToRole] " .. tostring(role.uniqueID) .. " " .. tostring(lplayer.yrpseltab[1]) .. "\n")
							else
								MsgC(Color(0, 255, 0), "[YRPAddSwepToRole] " .. tostring(role.uniqueID) .. " " .. tostring(lplayer.yrpseltab) .. "\n")
							end
						end

						YRPOpenSelector(cl_sweps, true, "classname", YRPAddSwepToRole)
					end

					ea[role.uniqueID].sweps = DStringListBox(sweps)
					net.Receive(
						"nws_yrp_get_role_sweps",
						function()
							local tab_pm = net.ReadTable()
							local cl_sweps = {}
							for i, v in pairs(tab_pm) do
								local swep = {}
								swep.uniqueID = i
								swep.string_models = GetSwepWorldModel(v)
								swep.string_classname = v
								swep.string_name = v
								swep.doclick = function()
									net.Start("nws_yrp_rem_role_swep")
									net.WriteInt(role.uniqueID, 32)
									net.WriteString(swep.string_classname)
									net.SendToServer()
									local tmp = {}
									for id, va in pairs(string.Explode(",", role.string_sweps)) do
										if va ~= swep.string_classname then
											table.insert(tmp, va)
										end
									end

									role.string_sweps = table.concat(tmp, ",")
								end

								swep.h = YRP:ctr(120)
								table.insert(cl_sweps, swep)
							end

							if ea[role.uniqueID].sweps.dpl.AddLines ~= nil then
								ea[role.uniqueID].sweps.dpl:AddLines(cl_sweps)
							end
						end
					)

					net.Start("nws_yrp_get_role_sweps")
					net.WriteInt(role.uniqueID, 32)
					net.SendToServer()
					hr.parent = ea.equipment:GetContent()
					DHr(hr)
					if GetGlobalYRPBool("bool_weapon_system", true) then
						local swepsonspawn = {}
						swepsonspawn.parent = ea.equipment:GetContent()
						swepsonspawn.uniqueID = role.uniqueID
						swepsonspawn.header = YRP:trans("LID_swepsatspawn") .. " (Equipped if slot is not full!)"
						swepsonspawn.netstr = "nws_yrp_update_role_string_sweps_onspawn"
						swepsonspawn.value = role.string_sweps_onspawn
						swepsonspawn.uniqueID = role.uniqueID
						swepsonspawn.w = ea.equipment:GetContent():GetWide()
						swepsonspawn.h = YRP:ctr(325)
						swepsonspawn.doclick = function()
							local lply = LocalPlayer()
							lply.yrpseltab = {}
							for i, v in pairs(string.Explode(",", role.string_sweps_onspawn)) do
								if not table.HasValue(lply.yrpseltab) then
									table.insert(lply.yrpseltab, v)
								end
							end

							local allsweps = YRPGetSWEPsList()
							local cl_sweps = {}
							local count = 0
							for k, v in pairs(allsweps) do
								count = count + 1
								cl_sweps[count] = {}
								cl_sweps[count].WorldModel = v.WorldModel or ""
								cl_sweps[count].ClassName = v.ClassName or "NO CLASSNAME"
								cl_sweps[count].PrintName = v.PrintName or v.ClassName or "NO PRINTNAME"
							end

							function YRPAddSwepToRoleOnSpawn()
								local lplayer = LocalPlayer()
								if role.uniqueID and lplayer.yrpseltab then
									net.Start("nws_yrp_add_role_swep_onspawn")
									net.WriteInt(role.uniqueID, 32)
									net.WriteTable(lplayer.yrpseltab)
									net.SendToServer()
									role.string_sweps_onspawn = table.concat(lplayer.yrpseltab, ",")
								elseif lplayer.yrpseltab and lplayer.yrpseltab[1] then
									MsgC(Color(0, 255, 0), "[YRPAddSwepToRoleOnSpawn] " .. tostring(role.uniqueID) .. " " .. tostring(lplayer.yrpseltab[1]) .. "\n")
								else
									MsgC(Color(0, 255, 0), "[YRPAddSwepToRoleOnSpawn] " .. tostring(role.uniqueID) .. " " .. tostring(lplayer.yrpseltab) .. "\n")
								end
							end

							YRPOpenSelector(cl_sweps, true, "classname", YRPAddSwepToRoleOnSpawn)
						end

						ea[role.uniqueID].swepsonspawn = DStringListBox(swepsonspawn)
						net.Receive(
							"nws_yrp_get_role_sweps_onspawn",
							function()
								local tab_pm = net.ReadTable()
								local cl_sweps = {}
								for i, v in pairs(tab_pm) do
									local swep = {}
									swep.uniqueID = i
									swep.string_models = GetSwepWorldModel(v.classname)
									swep.string_classname = v.classname
									swep.string_name = v.classname
									swep.slots = v
									swep.doclick = function()
										net.Start("nws_yrp_rem_role_swep_onspawn")
										net.WriteInt(role.uniqueID, 32)
										net.WriteString(swep.string_classname)
										net.SendToServer()
										local tmp = {}
										for id, va in pairs(string.Explode(",", role.string_sweps_onspawn)) do
											if va ~= swep.string_classname then
												table.insert(tmp, va)
											end
										end

										role.string_sweps_onspawn = table.concat(tmp, ",")
									end

									swep.h = YRP:ctr(120)
									table.insert(cl_sweps, swep)
								end

								if ea[role.uniqueID].swepsonspawn.dpl.AddLines ~= nil then
									ea[role.uniqueID].swepsonspawn.dpl:AddLines(cl_sweps)
								end
							end
						)

						net.Start("nws_yrp_get_role_sweps_onspawn")
						net.WriteInt(role.uniqueID, 32)
						net.SendToServer()
						hr.parent = ea.equipment:GetContent()
						DHr(hr)
					end

					-- Ammunation
					local ammobg = YRPCreateD("YPanel", col2, YRP:ctr(800), YRP:ctr(350), 0, 0)
					local ammoheader = YRPCreateD("YLabel", ammobg, YRP:ctr(800), YRP:ctr(50), 0, 0)
					ammoheader:SetText("LID_ammo")
					function ammoheader:Paint(pw, ph)
						draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
						draw.SimpleText(YRP:trans(self:GetText()), "Y_18_700", pw / 2, ph / 2, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					end

					ammolist = YRPCreateD("DPanelList", ammobg, YRP:ctr(800 - 23 - 20), YRP:ctr(300), 0, YRP:ctr(50))
					ammolist:SetSpacing(2)
					ammolist:EnableVerticalScrollbar(true)
					local sbar = ammolist.VBar
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

					local tammos = role.string_ammos or ""
					tammos = string.Explode(";", tammos)
					local ammos = {}
					for i, v in pairs(tammos) do
						local t = string.Split(v, ":")
						ammos[t[1]] = t[2]
					end

					function YRPUpdateAmmoAmountRole()
						local tab = {}
						for i, v in pairs(ammos) do
							if tonumber(v) > 0 then
								table.insert(tab, i .. ":" .. v)
							end
						end

						local result = table.concat(tab, ";")
						net.Start("nws_yrp_update_role_string_ammos")
						net.WriteString(role.uniqueID)
						net.WriteString(result)
						net.SendToServer()
					end

					for i, v in pairs(game.GetAmmoTypes()) do
						local abg = YRPCreateD("YPanel", nil, YRP:ctr(800), YRP:ctr(50), 0, 0)
						local ahe = YRPCreateD("YLabel", abg, YRP:ctr(400), YRP:ctr(50), 0, 0)
						ahe:SetText(v)
						function ahe:Paint(pw, ph)
							draw.RoundedBox(0, 0, 0, pw, ph, Color(100, 100, 255))
							draw.SimpleText(self:GetText(), "Y_18_700", ph / 2, ph / 2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
						end

						local ava = YRPCreateD("DNumberWang", abg, YRP:ctr(400), YRP:ctr(50), YRP:ctr(400), 0)
						ava:SetDecimals(0)
						ava:SetMin(0)
						ava:SetMax(999)
						ava:SetValue(ammos[v] or 0)
						function ava:OnValueChanged(val)
							ammos[v] = math.Clamp(val, self:GetMin(), self:GetMax())
							YRPUpdateAmmoAmountRole()
						end

						ammolist:AddItem(abg)
					end

					ea.equipment:AddItem(ammobg)
					DHr(hr)
					-- Licenses
					local licenses = {}
					licenses.parent = ea.equipment:GetContent()
					licenses.uniqueID = role.uniqueID
					licenses.header = "LID_licenses"
					licenses.netstr = "nws_yrp_update_role_string_licenses"
					licenses.value = role.string_licenses
					licenses.uniqueID = role.uniqueID
					licenses.w = ea.equipment:GetContent():GetWide()
					licenses.h = YRP:ctr(325)
					licenses.doclick = function()
						local winlicenses = YRPCreateD("DFrame", nil, ScrW(), ScrH(), 0, 0)
						winlicenses:SetTitle("")
						winlicenses:Center()
						winlicenses:MakePopup()
						function winlicenses:Paint(pw, ph)
							draw.RoundedBox(0, 0, 0, pw, ph, Color(80, 80, 80, 255))
							draw.SimpleText(YRP:trans("LID_search") .. ": ", "DermaDefault", YRP:ctr(20 + 100), YRP:ctr(50 + 25), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
						end

						net.Receive(
							"nws_yrp_get_all_licenses",
							function(l)
								local alllicenses = net.ReadTable()
								local cl_licenses = {}
								local count = 0
								for k, v in pairs(alllicenses) do
									count = count + 1
									cl_licenses[count] = {}
									cl_licenses[count].WorldModel = v.WorldModel or nil
									cl_licenses[count].ClassName = v.uniqueID
									cl_licenses[count].PrintName = v.name
								end

								if winlicenses then
									winlicenses.dpl = YRPCreateD("DPanelList", winlicenses, ScrW() - YRP:ctr(20 * 2), ScrH() - YRP:ctr(100 + 20), YRP:ctr(20), YRP:ctr(100))
									winlicenses.dpl:EnableVerticalScrollbar(true)
									local height = ScrH() - YRP:ctr(100)
									function winlicenses:Search(strsearch)
										strsearch = string.lower(strsearch)
										strsearch = string.Replace(strsearch, "[", "")
										strsearch = string.Replace(strsearch, "]", "")
										strsearch = string.Replace(strsearch, "%", "")
										self.dpl:Clear()
										if strsearch ~= nil then
											for i, v in pairs(cl_licenses) do
												v.PrintName = v.PrintName or ""
												v.ClassName = v.ClassName or ""
												v.WorldModel = v.WorldModel or ""
												if string.find(string.lower(v.PrintName), strsearch, 1, true) or string.find(string.lower(v.ClassName), strsearch, 1, true) or string.find(string.lower(v.WorldModel), strsearch, 1, true) then
													local d_licenses = YRPCreateD("YButton", nil, winlicenses.dpl:GetWide(), height / 4, 0, 0)
													d_licenses:SetText(v.PrintName)
													function d_licenses:DoClick()
														net.Start("nws_yrp_add_role_license")
														net.WriteInt(role.uniqueID, 32)
														net.WriteString(v.ClassName)
														net.SendToServer()
														winlicenses:Close()
													end

													if v.WorldModel ~= "" and v.WorldModel ~= nil then
														d_licenses.model = YRPCreateD("DModelPanel", d_licenses, d_licenses:GetTall(), d_licenses:GetTall(), 0, 0)
														d_licenses.model:SetModel(v.WorldModel)
													elseif v.WorldModel == "" then
														d_licenses.model = YRPCreateD("DPanel", d_licenses, d_licenses:GetTall(), d_licenses:GetTall(), 0, 0)
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
									winlicenses.search = YRPCreateD("DTextEntry", winlicenses, ScrW() - YRP:ctr(20 + 100 + 20), YRP:ctr(50), YRP:ctr(20 + 100), YRP:ctr(50))
									function winlicenses.search:OnChange()
										local searchtext = self:GetText()
										if searchtext ~= nil then
											winlicenses:Search(searchtext)
										end
									end
								end
							end
						)

						net.Start("nws_yrp_get_all_licenses")
						net.SendToServer()
					end

					ea[role.uniqueID].licenses = DStringListBox(licenses)
					net.Receive(
						"nws_yrp_get_role_licenses",
						function()
							local tab_li = net.ReadTable()
							local cl_licenses = {}
							for i, v in pairs(tab_li) do
								if istable(v) then
									local license = {}
									license.uniqueID = i
									license.string_models = ""
									license.string_classname = v.uniqueID
									license.string_name = v.string_name
									license.doclick = function()
										net.Start("nws_yrp_rem_role_license")
										net.WriteInt(role.uniqueID, 32)
										net.WriteString(license.string_classname)
										net.SendToServer()
									end

									license.h = YRP:ctr(120)
									table.insert(cl_licenses, license)
								end
							end

							if ea[role.uniqueID].licenses.dpl.AddLines ~= nil then
								ea[role.uniqueID].licenses.dpl:AddLines(cl_licenses)
							end
						end
					)

					net.Start("nws_yrp_get_role_licenses")
					net.WriteInt(role.uniqueID, 32)
					net.SendToServer()
					ea.equipment:AutoSize(true)
					local col3 = YRPCreateD("DPanelList", ea.background, YRP:ctr(800), ea.background:GetTall() - YRP:ctr(40), YRP:ctr(20), YRP:ctr(20))
					col3:EnableVerticalScrollbar(true)
					col3:SetSpacing(YRP:ctr(20))
					local sbar2 = col3.VBar
					function sbar2:Paint(w, h)
						draw.RoundedBox(0, 0, 0, w, h, YRPInterfaceValue("YFrame", "NC"))
					end

					function sbar2.btnUp:Paint(w, h)
						draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
					end

					function sbar2.btnDown:Paint(w, h)
						draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
					end

					function sbar2.btnGrip:Paint(w, h)
						draw.RoundedBox(w / 2, 0, 0, w, h, YRPInterfaceValue("YFrame", "HI"))
					end

					local restriction = YRPCreateD("YGroupBox", ea.background, YRP:ctr(800), YRP:ctr(1650), YRP:ctr(1660), YRP:ctr(20))
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
							if ug.string_name ~= nil then
								ugs["ALL"]["choices"][string.upper(ug.string_name)] = ugs["ALL"]["choices"][string.upper(ug.string_name)] or {}
								ugs["ALL"]["choices"][string.upper(ug.string_name)].checked = table.HasValue(gugs, string.upper(ug.string_name))
							else
								YRP:msg("note", "WHATS THAT? #2")
								pFTab(ug)
							end
						end

						local usergroups = {}
						usergroups.parent = ea.restriction:GetContent()
						usergroups.uniqueID = role.uniqueID
						usergroups.header = "LID_usergroups"
						usergroups.netstr = "nws_yrp_update_role_string_usergroups"
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
						requireslevel.netstr = "nws_yrp_update_role_int_requireslevel"
						requireslevel.value = role.int_requireslevel
						requireslevel.uniqueID = role.uniqueID
						requireslevel.lforce = false
						requireslevel.min = 1
						requireslevel.max = 10000000
						ea[role.uniqueID].requireslevel = DIntBox(requireslevel)
						DHr(hr)
					end

					if GetGlobalYRPBool("bool_building_system", false) then
						local securitylevel = {}
						securitylevel.parent = ea.restriction:GetContent()
						securitylevel.header = "LID_securitylevel"
						securitylevel.netstr = "nws_yrp_update_role_int_securitylevel"
						securitylevel.value = role.int_securitylevel
						securitylevel.uniqueID = role.uniqueID
						securitylevel.lforce = false
						securitylevel.min = 0
						securitylevel.max = 1000
						ea[role.uniqueID].securitylevel = DIntBox(securitylevel)
						DHr(hr)
					end

					if role.uniqueID > 1 then
						local whitelist = {}
						whitelist.parent = ea.restriction:GetContent()
						whitelist.uniqueID = role.uniqueID
						whitelist.header = "LID_useswhitelist"
						whitelist.netstr = "nws_yrp_update_role_bool_whitelist"
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
						locked.netstr = "nws_yrp_update_role_bool_locked"
						locked.value = role.bool_locked
						locked.uniqueID = role.uniqueID
						locked.lforce = false
						ea[role.uniqueID].locked = YRPDCheckBox(locked)
						DHr(hr)
					end

					local bool_canbeagent = {}
					bool_canbeagent.parent = ea.restriction:GetContent()
					bool_canbeagent.uniqueID = role.uniqueID
					bool_canbeagent.header = YRP:trans("LID_isagent")
					bool_canbeagent.netstr = "nws_yrp_update_role_bool_canbeagent"
					bool_canbeagent.value = role.bool_canbeagent
					bool_canbeagent.uniqueID = role.uniqueID
					bool_canbeagent.lforce = false
					ea[role.uniqueID].bool_canbeagent = YRPDCheckBox(bool_canbeagent)
					DHr(hr)
					if role.uniqueID > 1 then
						local visible = {}
						visible.parent = ea.restriction:GetContent()
						visible.uniqueID = role.uniqueID
						visible.header = YRP:trans("LID_visible") .. " ( " .. YRP:trans("LID_charactercreation") .. " )"
						visible.netstr = "nws_yrp_update_role_bool_visible_cc"
						visible.value = role.bool_visible_cc
						visible.uniqueID = role.uniqueID
						visible.lforce = false
						ea[role.uniqueID].visible = YRPDCheckBox(visible)
						DHr(hr)
					end

					local visible2 = {}
					visible2.parent = ea.restriction:GetContent()
					visible2.uniqueID = role.uniqueID
					visible2.header = YRP:trans("LID_visible") .. " ( " .. YRP:trans("LID_rolemenu") .. " )"
					visible2.netstr = "nws_yrp_update_role_bool_visible_rm"
					visible2.value = role.bool_visible_rm
					visible2.uniqueID = role.uniqueID
					visible2.lforce = false
					ea[role.uniqueID].visible2 = YRPDCheckBox(visible2)
					DHr(hr)
					if role.uniqueID > 1 then
						local bool_voteable = {}
						bool_voteable.parent = ea.restriction:GetContent()
						bool_voteable.uniqueID = role.uniqueID
						bool_voteable.header = "LID_voteable"
						bool_voteable.netstr = "nws_yrp_update_role_bool_voteable"
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
					bool_eventrole.netstr = "nws_yrp_update_role_bool_eventrole"
					bool_eventrole.value = role.bool_eventrole
					bool_eventrole.uniqueID = role.uniqueID
					bool_eventrole.lforce = false
					ea[role.uniqueID].bool_eventrole = YRPDCheckBox(bool_eventrole)
					DHr(hr)
					local int_namelength = {}
					int_namelength.parent = ea.restriction:GetContent()
					int_namelength.header = "LID_namelength"
					int_namelength.netstr = "nws_yrp_update_role_int_namelength"
					int_namelength.value = role.int_namelength
					int_namelength.uniqueID = role.uniqueID
					int_namelength.lforce = false
					int_namelength.min = 0
					int_namelength.max = 64
					ea[role.uniqueID].int_namelength = DIntBox(int_namelength)
					local abis = {"none", "mana", "force", "rage", "energy"}
					local tab_a = {}
					for i, v in pairs(abis) do
						tab_a[string.lower(v)] = YRP:trans("LID_" .. string.lower(v))
					end

					DHr(hr)
					local huds = {"serverdefault"}
					for i, v in pairs(db_huds) do
						table.insert(huds, v.name)
					end

					local string_hud = {}
					string_hud.parent = ea.restriction:GetContent()
					string_hud.uniqueID = role.uniqueID
					string_hud.header = YRP:trans("LID_hud")
					string_hud.netstr = "nws_yrp_update_role_string_hud"
					string_hud.value = role.string_hud
					string_hud.uniqueID = role.uniqueID
					string_hud.lforce = false
					string_hud.choices = huds
					ea[role.uniqueID].string_hud = YRPDComboBoxHUD(string_hud)
					DHr(hr)
					local hudmasks = {"serverdefault"}
					for i, v in pairs(db_hudmasks) do
						table.insert(hudmasks, v.name)
					end

					local string_hud_mask = {}
					string_hud_mask.parent = ea.restriction:GetContent()
					string_hud_mask.uniqueID = role.uniqueID
					string_hud_mask.header = "HUD Mask"
					string_hud_mask.netstr = "nws_yrp_update_role_string_hud_mask"
					string_hud_mask.value = role.string_hud_mask
					string_hud_mask.uniqueID = role.uniqueID
					string_hud_mask.lforce = false
					string_hud_mask.choices = hudmasks
					ea[role.uniqueID].string_hud_mask = YRPDComboBoxHUD(string_hud_mask)
					DHr(hr)
					-- Not droppable
					local ndsweps = {}
					ndsweps.parent = ea.restriction:GetContent()
					ndsweps.uniqueID = role.uniqueID
					ndsweps.header = "LID_ndsweps"
					ndsweps.netstr = "nws_yrp_update_role_string_ndsweps"
					ndsweps.value = role.string_ndsweps
					ndsweps.uniqueID = role.uniqueID
					ndsweps.w = ea.restriction:GetContent():GetWide()
					ndsweps.h = YRP:ctr(325)
					ndsweps.doclick = function()
						local winndswep = YRPCreateD("DFrame", nil, ScrW(), ScrH(), 0, 0)
						winndswep:SetTitle("")
						winndswep:Center()
						winndswep:MakePopup()
						function winndswep:Paint(pw, ph)
							draw.RoundedBox(0, 0, 0, pw, ph, Color(80, 80, 80, 255))
							draw.SimpleText(YRP:trans("LID_search") .. ": ", "DermaDefault", YRP:ctr(20 + 100), YRP:ctr(50 + 25), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
						end

						local allndsweps = YRPGetSWEPsList()
						local cl_ndsweps = {}
						local count = 0
						for k, v in pairs(allndsweps) do
							count = count + 1
							cl_ndsweps[count] = {}
							cl_ndsweps[count].WorldModel = v.WorldModel or ""
							cl_ndsweps[count].ClassName = v.ClassName or "NO CLASSNAME"
							cl_ndsweps[count].PrintName = v.PrintName or v.ClassName or "NO PRINTNAME"
						end

						winndswep.dpl = YRPCreateD("DPanelList", winndswep, ScrW() - YRP:ctr(20 * 2), ScrH() - YRP:ctr(100 + 20), YRP:ctr(20), YRP:ctr(100))
						winndswep.dpl:EnableVerticalScrollbar(true)
						local height = ScrH() - YRP:ctr(100)
						function winndswep:Search(strsearch)
							strsearch = string.lower(strsearch)
							strsearch = string.Replace(strsearch, "[", "")
							strsearch = string.Replace(strsearch, "]", "")
							strsearch = string.Replace(strsearch, "%", "")
							self.dpl:Clear()
							for i, v in pairs(cl_ndsweps) do
								if string.find(string.lower(v.PrintName), strsearch, 1, true) or string.find(string.lower(v.ClassName), strsearch, 1, true) or string.find(string.lower(v.WorldModel), strsearch, 1, true) then
									local d_ndswep = YRPCreateD("YButton", nil, winndswep.dpl:GetWide(), height / 4, 0, 0)
									d_ndswep:SetText(v.PrintName)
									function d_ndswep:DoClick()
										net.Start("nws_yrp_add_role_ndswep")
										net.WriteInt(role.uniqueID, 32)
										net.WriteString(v.ClassName)
										net.SendToServer()
										if winndswep and winndswep.Close then
											winndswep:Close()
										end
									end

									if v.WorldModel ~= "" then
										d_ndswep.model = YRPCreateD("DModelPanel", d_ndswep, d_ndswep:GetTall(), d_ndswep:GetTall(), 0, 0)
										d_ndswep.model:SetModel(v.WorldModel)
									else
										d_ndswep.model = YRPCreateD("DPanel", d_ndswep, d_ndswep:GetTall(), d_ndswep:GetTall(), 0, 0)
										function d_ndswep.model:Paint(pw, ph)
											draw.RoundedBox(0, 0, 0, pw, ph, Color(80, 80, 80))
											draw.SimpleText("NO MODEL", "DermaDefault", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
										end
									end

									if winndswep and winndswep.dpl then
										winndswep.dpl:AddItem(d_ndswep)
									end
								end
							end
						end

						winndswep:Search("")
						winndswep.search = YRPCreateD("DTextEntry", winndswep, ScrW() - YRP:ctr(20 + 100 + 20), YRP:ctr(50), YRP:ctr(20 + 100), YRP:ctr(50))
						function winndswep.search:OnChange()
							winndswep:Search(self:GetText())
						end
					end

					ea[role.uniqueID].ndsweps = DStringListBox(ndsweps)
					net.Receive(
						"nws_yrp_get_role_ndsweps",
						function()
							local tab_pm = net.ReadTable()
							local cl_ndsweps = {}
							for i, v in pairs(tab_pm) do
								local ndswep = {}
								ndswep.string_models = GetSwepWorldModel(v) or "notfound"
								ndswep.string_classname = v
								ndswep.string_name = v
								ndswep.doclick = function()
									net.Start("nws_yrp_rem_role_ndswep")
									net.WriteInt(role.uniqueID, 32)
									net.WriteString(ndswep.string_classname)
									net.SendToServer()
								end

								ndswep.h = YRP:ctr(120)
								table.insert(cl_ndsweps, ndswep)
							end

							if ea[role.uniqueID].ndsweps.dpl.AddLines ~= nil then
								ea[role.uniqueID].ndsweps.dpl:AddLines(cl_ndsweps)
							end
						end
					)

					net.Start("nws_yrp_get_role_ndsweps")
					net.WriteInt(role.uniqueID, 32)
					net.SendToServer()
					DHr(hr)
					-- Specializations
					local specializations = {}
					specializations.parent = ea.restriction:GetContent()
					specializations.uniqueID = role.uniqueID
					specializations.header = YRP:trans("LID_specializations") .. " Permission to give it"
					specializations.netstr = "nws_yrp_update_role_string_specializations"
					specializations.value = role.string_specializations
					specializations.uniqueID = role.uniqueID
					specializations.w = ea.restriction:GetContent():GetWide()
					specializations.h = YRP:ctr(325)
					specializations.doclick = function()
						local winspecializations = YRPCreateD("DFrame", nil, ScrW(), ScrH(), 0, 0)
						winspecializations:SetTitle("")
						winspecializations:Center()
						winspecializations:MakePopup()
						function winspecializations:Paint(pw, ph)
							draw.RoundedBox(0, 0, 0, pw, ph, Color(80, 80, 80, 255))
							draw.SimpleText(YRP:trans("LID_search") .. ": ", "DermaDefault", YRP:ctr(20 + 100), YRP:ctr(50 + 25), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
						end

						net.Receive(
							"nws_yrp_get_all_specializations",
							function(l)
								local allspecializations = net.ReadTable()
								local cl_specializations = {}
								local count = 0
								for k, v in pairs(allspecializations) do
									count = count + 1
									cl_specializations[count] = {}
									cl_specializations[count].WorldModel = v.WorldModel or nil
									cl_specializations[count].ClassName = v.uniqueID
									cl_specializations[count].PrintName = v.name
								end

								winspecializations.dpl = YRPCreateD("DPanelList", winspecializations, ScrW() - YRP:ctr(20 * 2), ScrH() - YRP:ctr(100 + 20), YRP:ctr(20), YRP:ctr(100))
								winspecializations.dpl:EnableVerticalScrollbar(true)
								local height = ScrH() - YRP:ctr(100)
								function winspecializations:Search(strsearch)
									strsearch = string.lower(strsearch)
									strsearch = string.Replace(strsearch, "[", "")
									strsearch = string.Replace(strsearch, "]", "")
									strsearch = string.Replace(strsearch, "%", "")
									self.dpl:Clear()
									if strsearch ~= nil then
										for i, v in pairs(cl_specializations) do
											v.PrintName = v.PrintName or ""
											v.ClassName = v.ClassName or ""
											v.WorldModel = v.WorldModel or ""
											if string.find(string.lower(v.PrintName), strsearch, 1, true) or string.find(string.lower(v.ClassName), strsearch, 1, true) or string.find(string.lower(v.WorldModel), strsearch, 1, true) then
												local d_specializations = YRPCreateD("YButton", nil, winspecializations.dpl:GetWide(), height / 4, 0, 0)
												d_specializations:SetText(v.PrintName)
												function d_specializations:DoClick()
													net.Start("nws_yrp_add_role_specialization")
													net.WriteInt(role.uniqueID, 32)
													net.WriteString(v.ClassName)
													net.SendToServer()
													winspecializations:Close()
												end

												if v.WorldModel ~= "" and v.WorldModel ~= nil then
													d_specializations.model = YRPCreateD("DModelPanel", d_specializations, d_specializations:GetTall(), d_specializations:GetTall(), 0, 0)
													d_specializations.model:SetModel(v.WorldModel)
												elseif v.WorldModel == "" then
													d_specializations.model = YRPCreateD("DPanel", d_specializations, d_specializations:GetTall(), d_specializations:GetTall(), 0, 0)
													function d_specializations.model:Paint(pw, ph)
														draw.RoundedBox(0, 0, 0, pw, ph, Color(80, 80, 80))
														draw.SimpleText("NO MODEL", "DermaDefault", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
													end
												end

												winspecializations.dpl:AddItem(d_specializations)
											end
										end
									end
								end

								winspecializations:Search("")
								winspecializations.search = YRPCreateD("DTextEntry", winspecializations, ScrW() - YRP:ctr(20 + 100 + 20), YRP:ctr(50), YRP:ctr(20 + 100), YRP:ctr(50))
								function winspecializations.search:OnChange()
									local searchtext = self:GetText()
									if searchtext ~= nil then
										winspecializations:Search(searchtext)
									end
								end
							end
						)

						net.Start("nws_yrp_get_all_specializations")
						net.SendToServer()
					end

					ea[role.uniqueID].specializations = DStringListBox(specializations)
					net.Receive(
						"nws_yrp_get_role_specializations",
						function()
							local tab_li = net.ReadTable()
							local cl_specializations = {}
							for i, v in pairs(tab_li) do
								if istable(v) then
									local specialization = {}
									specialization.uniqueID = i
									specialization.string_models = ""
									specialization.string_classname = v.uniqueID
									specialization.string_name = v.string_name
									specialization.doclick = function()
										net.Start("nws_yrp_rem_role_specialization")
										net.WriteInt(role.uniqueID, 32)
										net.WriteString(specialization.string_classname)
										net.SendToServer()
									end

									specialization.h = YRP:ctr(120)
									table.insert(cl_specializations, specialization)
								end
							end

							if ea[role.uniqueID].specializations.dpl.AddLines ~= nil then
								ea[role.uniqueID].specializations.dpl:AddLines(cl_specializations)
							end
						end
					)

					net.Start("nws_yrp_get_role_specializations")
					net.WriteInt(role.uniqueID, 32)
					net.SendToServer()
					ea.restriction:AutoSize(true)
					local col4 = YRPCreateD("DPanelList", ea.background, YRP:ctr(800), ea.background:GetTall() - YRP:ctr(40), YRP:ctr(20), YRP:ctr(20))
					col4:EnableVerticalScrollbar(true)
					col4:SetSpacing(YRP:ctr(20))
					local sbar5 = col4.VBar
					function sbar5:Paint(w, h)
						draw.RoundedBox(0, 0, 0, w, h, YRPInterfaceValue("YFrame", "NC"))
					end

					function sbar5.btnUp:Paint(w, h)
						draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
					end

					function sbar5.btnDown:Paint(w, h)
						draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
					end

					function sbar5.btnGrip:Paint(w, h)
						draw.RoundedBox(w / 2, 0, 0, w, h, YRPInterfaceValue("YFrame", "HI"))
					end

					local attributes = YRPCreateD("YGroupBox", ea.background, YRP:ctr(800), YRP:ctr(1400), ea.restriction.x + ea.restriction:GetWide() + YRP:ctr(20), YRP:ctr(20))
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
					health.uniqueID = role.uniqueID
					health.lforce = false
					health.dnw = {}
					health.dnw[1] = {}
					health.dnw[1].value = role.int_hp
					health.dnw[1].min = 1
					health.dnw[1].max = GetMaxInt()
					health.dnw[1].netstr = "nws_yrp_update_role_" .. "int_" .. "hp"
					health.dnw[2] = {}
					health.dnw[2].value = role.int_hpmax
					health.dnw[2].min = 1
					health.dnw[2].max = GetMaxInt()
					health.dnw[2].netstr = "nws_yrp_update_role_" .. "int_" .. "hpmax"
					health.dnw[3] = {}
					health.dnw[3].value = role.int_hpup
					health.dnw[3].min = -GetMaxInt()
					health.dnw[3].max = GetMaxInt()
					health.dnw[3].netstr = "nws_yrp_update_role_" .. "int_" .. "hpup"
					health.color = Color(0, 255, 0)
					health.color2 = Color(0, 200, 0)
					ea[role.uniqueID].health = DAttributeBar(health)
					hr.parent = ea.attributes:GetContent()
					DHr(hr)
					local armor = {}
					armor.parent = ea.attributes:GetContent()
					armor.uniqueID = role.uniqueID
					armor.header = "LID_armor"
					armor.uniqueID = role.uniqueID
					armor.lforce = false
					armor.dnw = {}
					armor.dnw[1] = {}
					armor.dnw[1].value = role.int_ar
					armor.dnw[1].min = 0
					armor.dnw[1].max = GetMaxInt()
					armor.dnw[1].netstr = "nws_yrp_update_role_" .. "int_" .. "ar"
					armor.dnw[2] = {}
					armor.dnw[2].value = role.int_armax
					armor.dnw[2].min = 1
					armor.dnw[2].max = GetMaxInt()
					armor.dnw[2].netstr = "nws_yrp_update_role_" .. "int_" .. "armax"
					armor.dnw[3] = {}
					armor.dnw[3].value = role.int_arup
					armor.dnw[3].min = -GetMaxInt()
					armor.dnw[3].max = GetMaxInt()
					armor.dnw[3].netstr = "nws_yrp_update_role_" .. "int_" .. "arup"
					armor.color = Color(0, 0, 255, 255)
					armor.color2 = Color(100, 100, 255)
					ea[role.uniqueID].armor = DAttributeBar(armor)
					DHr(hr)
					if GetGlobalYRPBool("bool_stamina", false) then
						local stamina = {}
						stamina.parent = ea.attributes:GetContent()
						stamina.uniqueID = role.uniqueID
						stamina.header = "LID_stamina"
						stamina.uniqueID = role.uniqueID
						stamina.lforce = false
						stamina.dnw = {}
						stamina.dnw[1] = {}
						stamina.dnw[1].value = role.int_st
						stamina.dnw[1].min = 1
						stamina.dnw[1].max = GetMaxInt()
						stamina.dnw[1].netstr = "nws_yrp_update_role_" .. "int_" .. "st"
						stamina.dnw[2] = {}
						stamina.dnw[2].value = role.int_stmax
						stamina.dnw[2].min = 1
						stamina.dnw[2].max = GetMaxInt()
						stamina.dnw[2].netstr = "nws_yrp_update_role_" .. "int_" .. "stmax"
						stamina.dnw[3] = {}
						stamina.dnw[3].value = role.float_stup
						stamina.dnw[3].min = -GetMaxFloat()
						stamina.dnw[3].max = GetMaxFloat()
						stamina.dnw[3].netstr = "nws_yrp_update_role_" .. "float_" .. "stup"
						stamina.dnw[4] = {}
						stamina.dnw[4].value = role.float_stdn
						stamina.dnw[4].min = -GetMaxFloat()
						stamina.dnw[4].max = GetMaxFloat()
						stamina.dnw[4].netstr = "nws_yrp_update_role_" .. "float_" .. "stdn"
						stamina.color = Color(255, 255, 0)
						stamina.color2 = Color(200, 200, 0)
						stamina.color3 = Color(160, 160, 0)
						ea[role.uniqueID].stamina = DAttributeBar(stamina)
						DHr(hr)
					end

					local tab_a2 = {}
					for i, v in pairs(abis) do
						tab_a2[string.lower(v)] = YRP:trans("LID_" .. string.lower(v))
					end

					local string_ability = {}
					string_ability.parent = ea.attributes:GetContent()
					string_ability.uniqueID = role.uniqueID
					string_ability.header = YRP:trans("LID_ability") .. " (for addons)"
					string_ability.netstr = "nws_yrp_update_role_string_ability"
					string_ability.value = role.string_ability
					string_ability.uniqueID = role.uniqueID
					string_ability.lforce = false
					string_ability.choices = tab_a2
					ea[role.uniqueID].string_ability = YRPDComboBox(string_ability)
					local ability = {}
					ability.parent = ea.attributes:GetContent()
					ability.uniqueID = role.uniqueID
					ability.header = YRP:trans("LID_ability")
					ability.uniqueID = role.uniqueID
					ability.lforce = false
					ability.dnw = {}
					ability.dnw[1] = {}
					ability.dnw[1].value = role.int_ab
					ability.dnw[1].min = 1
					ability.dnw[1].max = GetMaxInt()
					ability.dnw[1].netstr = "nws_yrp_update_role_" .. "int_" .. "ab"
					ability.dnw[2] = {}
					ability.dnw[2].value = role.int_abmax
					ability.dnw[2].min = 1
					ability.dnw[2].max = GetMaxInt()
					ability.dnw[2].netstr = "nws_yrp_update_role_" .. "int_" .. "abmax"
					ability.color = Color(255, 255, 0)
					ability.color2 = Color(200, 200, 0)
					ability.color3 = Color(160, 160, 0)
					ea[role.uniqueID].ability = DAttributeBar(ability)
					DHr(hr)
					local speedwalk = {}
					speedwalk.parent = ea.attributes:GetContent()
					speedwalk.header = "LID_walkspeed"
					speedwalk.netstr = "nws_yrp_update_role_int_speedwalk"
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
					speedrun.netstr = "nws_yrp_update_role_int_speedrun"
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
					powerjump.netstr = "nws_yrp_update_role_int_powerjump"
					powerjump.value = role.int_powerjump or -1
					powerjump.uniqueID = role.uniqueID
					powerjump.lforce = false
					powerjump.min = 1
					powerjump.max = 999999
					ea[role.uniqueID].powerjump = DIntBox(powerjump)
					DHr(hr)
					local dmgtypes = {"burn", "bullet", "energybeam"}
					for i, dmgtype in pairs(dmgtypes) do
						local d = {}
						d.parent = ea.attributes:GetContent()
						d.header = "LID_" .. "dmgtype_" .. dmgtype
						d.netstr = "nws_yrp_update_role_float_" .. "dmgtype_" .. dmgtype
						d.value = role["float_" .. "dmgtype_" .. dmgtype] or 1.0
						d.uniqueID = role.uniqueID
						d.lforce = false
						d.min = -10.0
						d.max = 10.0
						ea[role.uniqueID][dmgtype] = DIntBox(d)
					end

					DHr(hr)
					if GetGlobalYRPBool("bool_hunger", false) then
						local bool_hunger = {}
						bool_hunger.parent = ea.attributes:GetContent()
						bool_hunger.uniqueID = role.uniqueID
						bool_hunger.header = "LID_hunger"
						bool_hunger.netstr = "nws_yrp_update_role_bool_hunger"
						bool_hunger.value = role.bool_hunger
						bool_hunger.uniqueID = role.uniqueID
						ea[role.uniqueID].bool_hunger = YRPDCheckBox(bool_hunger)
						DHr(hr)
					end

					if GetGlobalYRPBool("bool_thirst", false) then
						local bool_thirst = {}
						bool_thirst.parent = ea.attributes:GetContent()
						bool_thirst.uniqueID = role.uniqueID
						bool_thirst.header = "LID_thirst"
						bool_thirst.netstr = "nws_yrp_update_role_bool_thirst"
						bool_thirst.value = role.bool_thirst
						bool_thirst.uniqueID = role.uniqueID
						ea[role.uniqueID].bool_thirst = YRPDCheckBox(bool_thirst)
						DHr(hr)
					end

					if GetGlobalYRPBool("bool_stamina", false) then
						local bool_stamina = {}
						bool_stamina.parent = ea.attributes:GetContent()
						bool_stamina.uniqueID = role.uniqueID
						bool_stamina.header = "LID_stamina"
						bool_stamina.netstr = "nws_yrp_update_role_bool_stamina"
						bool_stamina.value = role.bool_stamina
						bool_stamina.uniqueID = role.uniqueID
						ea[role.uniqueID].bool_stamina = YRPDCheckBox(bool_stamina)
						DHr(hr)
					end

					local plySpawn = {}
					plySpawn.parent = ea.attributes:GetContent()
					plySpawn.uniqueID = role.uniqueID
					plySpawn.header = "LID_playerspawn"
					plySpawn.netstr = "nws_yrp_update_role_string_playerspawn"
					plySpawn.value = role.string_playerspawn
					plySpawn.uniqueID = role.uniqueID
					plySpawn.lforce = false
					plySpawn.multiline = true
					plySpawn.h = 200
					plySpawn.testCode = function()
						if ea[role.uniqueID].plySpawn then
							local code = ea[role.uniqueID].plySpawn.DTextEntry:GetText()
							pcall(
								function(ply)
									RSPLY = ply or LocalPlayer()
									code = "local ply = RSPLY; " .. code
									local error = RunString(code, "[RS] [GroupsAndRoles] role:" .. role.uniqueID .. " code: " .. tostring(code), false)
									if type(error) == "string" then
										notification.AddLegacy("ERROR in PlayerSpawn: " .. tostring(error), NOTIFY_ERROR, 6)
									else
										notification.AddLegacy("WORKED for PlayerSpawn: " .. tostring(code), NOTIFY_GENERIC, 6)
									end

									RSPLY = nil
								end, LocalPlayer()
							)
						end
					end

					ea[role.uniqueID].plySpawn = DTextBox(plySpawn)
					ea.attributes:AutoSize(true)
				end
			)

			net.Receive(
				"nws_yrp_settings_subscribe_rolelist",
				function(le)
					if YRPPanelAlive(rs.rplist, "GAR 14") then
						rs.rplist:ClearList()
						local roles = net.ReadTable()
						local headername = net.ReadString()
						rs.top.headername = headername
						local gro = net.ReadString()
						local pre = net.ReadString()
						if IsNotNilAndNotFalse(gro) and IsNotNilAndNotFalse(pre) then
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
				end
			)
		end
	end
)

function OpenSettingsGroupsAndRoles()
	net.Start("nws_yrp_subscribe_Settings_GroupsAndRoles")
	net.SendToServer()
end
