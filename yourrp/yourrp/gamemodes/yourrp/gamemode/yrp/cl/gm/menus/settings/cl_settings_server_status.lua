--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
function AddStatusLine(parent, cat, entry, str_id, color)
	local sl = YRPCreateD("DPanel", parent, parent:GetWide(), YRP:ctr(50), 0, 0)
	local _t = {}
	_t[cat] = entry
	sl.text = YRP:trans(str_id, _t)
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
		tab.text.font = "Y_18_500"
		YRPDrawButton(self, tab)
	end

	parent:AddItem(sl)

	return sl
end

net.Receive(
	"nws_yrp_connect_Settings_Status",
	function(len)
		local PARENT = GetSettingsSite()
		if YRPPanelAlive(PARENT) then
			function PARENT:OnRemove()
				net.Start("nws_yrp_disconnect_Settings_Status")
				net.SendToServer()
			end

			local TAB_YOURRP = net.ReadTable()
			local TAB_ROLES = net.ReadTable()
			local TAB_GROUPS = net.ReadTable()
			local TAB_MAP = net.ReadTable()
			local br = YRP:ctr(20)
			local scroller = {}
			scroller.parent = PARENT
			scroller.x = br
			scroller.y = br
			scroller.w = PARENT:GetWide() - 2 * br
			scroller.h = PARENT:GetTall() - 2 * br
			local Scroller = DHorizontalScroller(scroller)
			local Group_YourRP = YRPCreateD("YGroupBox", Scroller, YRP:ctr(800), Scroller:GetTall(), 0, 0)
			Group_YourRP:SetText("YourRP")
			function Group_YourRP:Paint(pw, ph)
				hook.Run("YGroupBoxPaint", self, pw, ph)
			end

			Scroller:AddPanel(Group_YourRP)
			for yourrpID, yourrp in pairs(TAB_YOURRP) do
				for str_id, color in pairs(yourrp) do
					AddStatusLine(Group_YourRP:GetContent(), "content", yourrpID, str_id, color)
				end
			end

			local Group_Roles = YRPCreateD("YGroupBox", Scroller, YRP:ctr(800), Scroller:GetTall(), 0, 0)
			Group_Roles:SetText("LID_roles")
			function Group_Roles:Paint(pw, ph)
				hook.Run("YGroupBoxPaint", self, pw, ph)
			end

			Scroller:AddPanel(Group_Roles)
			for roleID, role in pairs(TAB_ROLES) do
				for str_id, color in pairs(role) do
					AddStatusLine(Group_Roles, "role", roleID, str_id, color)
				end
			end

			local Group_Groups = YRPCreateD("YGroupBox", Scroller, YRP:ctr(800), Scroller:GetTall(), 0, 0)
			Group_Groups:SetText("LID_groups")
			function Group_Groups:Paint(pw, ph)
				hook.Run("YGroupBoxPaint", self, pw, ph)
			end

			Scroller:AddPanel(Group_Groups)
			for groupID, group in pairs(TAB_GROUPS) do
				for str_id, color in pairs(group) do
					AddStatusLine(Group_Groups, "group", groupID, str_id, color)
				end
			end

			local Group_Map = YRPCreateD("YGroupBox", Scroller, YRP:ctr(800), Scroller:GetTall(), 0, 0)
			Group_Map:SetText("LID_map")
			function Group_Map:Paint(pw, ph)
				hook.Run("YGroupBoxPaint", self, pw, ph)
			end

			Scroller:AddPanel(Group_Map)
			for mapID, map in pairs(TAB_MAP) do
				for str_id, color in pairs(map) do
					AddStatusLine(Group_Map, "map", mapID, str_id, color)
				end
			end
		end
	end
)

function OpenSettingsStatus()
	net.Start("nws_yrp_connect_Settings_Status")
	net.SendToServer()
end
