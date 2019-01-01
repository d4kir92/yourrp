--Copyright (C) 2017-2018 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

function AddStatusLine(parent, cat, entry, str_id, color)
	local sl = createD("DPanel", parent, parent:GetWide(), ctr(50), 0, 0)
	local _t = {}
	_t[cat] = entry
	sl.text = YRP.lang_string(str_id, _t)
	function sl:Paint(pw, ph)
		local tab = {}
		tab.color = Color(color.r, color.g, color.b)
		tab.hovercolor = Color(color.r + 100, color.g + 100, color.b + 100)
		tab.text = {}
		tab.text.text = self.text
		tab.text.ax = 1
		tab.text.ay = 1
		tab.text.x = pw / 2
		tab.text.y = ph / 2
		tab.text.font = "mat1text"
		DrawButton(self, tab)
	end

	parent:AddItem(sl)
	return sl
end

net.Receive("Connect_Settings_Status", function(len)
	if pa(settingsWindow.window) then
		function settingsWindow.window.site:Paint(pw, ph)
			draw.RoundedBox(4, 0, 0, pw, ph, Color(0, 0, 0, 254))
		end

		local PARENT = settingsWindow.window.site

		function PARENT:OnRemove()
			net.Start("Disconnect_Settings_Status")
			net.SendToServer()
		end

		local TAB_YOURRP = net.ReadTable()
		local TAB_ROLES = net.ReadTable()
		local TAB_GROUPS = net.ReadTable()
		local TAB_MAP = net.ReadTable()

		local br = ctr(20)
		local scroller = {}
		scroller.parent = PARENT
		scroller.x = br
		scroller.y = br
		scroller.w = BScrW() - 2 * br
		scroller.h = ScrH() - ctr(100) - 2 * br
		local Scroller = DHorizontalScroller(scroller)

		local tab_yourrp = {}
		tab_yourrp.parent = Scroller
		tab_yourrp.x = 0
		tab_yourrp.y = 0
		tab_yourrp.w = ctr(800)
		tab_yourrp.h = Scroller:GetTall()
		tab_yourrp.br = br / 2
		tab_yourrp.name = "YourRP"
		local Group_YourRP = DGroup(tab_yourrp)
		for yourrpID, yourrp in pairs(TAB_YOURRP) do
			for str_id, color in pairs(yourrp) do
				AddStatusLine(Group_YourRP, "content", yourrpID, str_id, color)
			end
		end

		local tab_roles = {}
		tab_roles.parent = Scroller
		tab_roles.x = 0
		tab_roles.y = 0
		tab_roles.w = ctr(800)
		tab_roles.h = Scroller:GetTall()
		tab_roles.br = br / 2
		tab_roles.name = "LID_roles"
		local Group_Roles = DGroup(tab_roles)
		for roleID, role in pairs(TAB_ROLES) do
			for str_id, color in pairs(role) do
				AddStatusLine(Group_Roles, "role", roleID, str_id, color)
			end
		end

		local tab_groups = {}
		tab_groups.parent = Scroller
		tab_groups.x = 0
		tab_groups.y = 0
		tab_groups.w = ctr(800)
		tab_groups.h = Scroller:GetTall()
		tab_groups.br = br / 2
		tab_groups.name = "LID_groups"
		local Group_Groups = DGroup(tab_groups)
		for groupID, group in pairs(TAB_GROUPS) do
			for str_id, color in pairs(group) do
				AddStatusLine(Group_Groups, "group", groupID, str_id, color)
			end
		end

		local tab_map = {}
		tab_map.parent = Scroller
		tab_map.x = 0
		tab_map.y = 0
		tab_map.w = ctr(800)
		tab_map.h = Scroller:GetTall()
		tab_map.br = br / 2
		tab_map.name = "LID_map"
		local Group_Map = DGroup(tab_map)
		for mapID, map in pairs(TAB_MAP) do
			for str_id, color in pairs(map) do
				AddStatusLine(Group_Map, "map", mapID, str_id, color)
			end
		end

	end
end)

hook.Add("open_server_status", "open_server_status", function()
	SaveLastSite()
	local w = settingsWindow.window.sitepanel:GetWide()
	local h = settingsWindow.window.sitepanel:GetTall()
	settingsWindow.window.site = createD("DPanel", settingsWindow.window.sitepanel, w, h, 0, 0)
	net.Start("Connect_Settings_Status")
	net.SendToServer()
end)
