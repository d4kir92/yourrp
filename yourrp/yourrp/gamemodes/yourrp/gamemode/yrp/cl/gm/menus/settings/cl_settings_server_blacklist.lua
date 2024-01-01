--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- #BLACKLISTSETTINGS
function BuildBlacklis(parent, tabBL, tab)
	parent:Clear()
	local lis = YRPCreateD("DListView", parent, parent:GetWide() - YRP.ctr(60 + 500), parent:GetTall() - YRP.ctr(140), YRP.ctr(20), YRP.ctr(20))
	lis:AddColumn("uniqueID"):SetFixedWidth(80)
	lis:AddColumn(YRP.trans("LID_name"))
	lis:AddColumn(YRP.trans("LID_value"))
	function lis:Think()
		if self.w ~= parent:GetWide() - YRP.ctr(60 + 500) or self.h ~= parent:GetTall() - YRP.ctr(40) or self.x ~= YRP.ctr(20) or self.y ~= YRP.ctr(20) then
			self.w = parent:GetWide() - YRP.ctr(60 + 500)
			self.h = parent:GetTall() - YRP.ctr(40)
			self.x = YRP.ctr(20)
			self.y = YRP.ctr(20)
			self:SetSize(self.w, self.h)
			self:SetPos(self.x, self.y)
		end
	end

	for k, bla in pairs(tabBL) do
		if tab == "LID_all" or tab == "LID_inventory" and bla.name == "inventory" or tab == "LID_chat" and bla.name == "chat" or tab == "LID_entities" and bla.name == "entities" or tab == "LID_props" and bla.name == "props" then
			lis:AddLine(bla.uniqueID, bla.name, bla.value)
		end
	end

	local btnAdd = YRPCreateD("YButton", parent, YRP.ctr(500), YRP.ctr(50), parent:GetWide() - YRP.ctr(20 + 500), YRP.ctr(20))
	btnAdd:SetText(YRP.trans("LID_addentry"))
	function btnAdd:DoClick()
		local AddFrame = YRPCreateD("YFrame", nil, YRP.ctr(500), YRP.ctr(500), 0, 0)
		AddFrame:Center()
		AddFrame:SetDraggable(true)
		AddFrame:SetTitle("LID_add")
		AddFrame:MakePopup()
		local CONTENT = AddFrame:GetContent()
		local addlis = YRPCreateD("DPanelList", CONTENT, CONTENT:GetWide(), CONTENT:GetTall(), 0, 0)
		local BLNameHeader = YRPCreateD("YLabel", CONTENT, CONTENT:GetWide(), YRP.ctr(50), 0, 0)
		BLNameHeader:SetText("LID_name")
		addlis:AddItem(BLNameHeader)
		local BLName = YRPCreateD("DComboBox", CONTENT, CONTENT:GetWide(), YRP.ctr(50), 0, 0)
		for k, v in pairs({"chat", "inventory", "entities", "props"}) do
			BLName:AddChoice(v, v)
		end

		addlis:AddItem(BLName)
		local HR = YRPCreateD("DPanel", CONTENT, CONTENT:GetWide(), YRP.ctr(20), 0, 0)
		function HR:Paint(pw, ph)
		end

		--
		addlis:AddItem(HR)
		local BLValueHeader = YRPCreateD("YLabel", CONTENT, CONTENT:GetWide(), YRP.ctr(50), 0, 0)
		BLValueHeader:SetText("LID_value")
		addlis:AddItem(BLValueHeader)
		local BLValue = YRPCreateD("DTextEntry", CONTENT, CONTENT:GetWide(), YRP.ctr(50), 0, 0)
		addlis:AddItem(BLValue)
		addlis:AddItem(HR)
		local BLAdd = YRPCreateD("DButton", CONTENT, CONTENT:GetWide(), YRP.ctr(50), 0, 0)
		BLAdd:SetText(YRP.trans("LID_add"))
		function BLAdd:DoClick()
			if BLName:GetOptionData(BLName:GetSelectedID()) ~= nil then
				net.Start("nws_yrp_blacklist_add")
				net.WriteString(BLName:GetOptionData(BLName:GetSelectedID()))
				net.WriteString(BLValue:GetText())
				net.SendToServer()
				net.Start("nws_yrp_blacklist_get")
				net.WriteString(tab)
				net.SendToServer()
			end

			AddFrame:Close()
		end

		addlis:AddItem(BLAdd)
	end

	function btnAdd:Think(pw, ph)
		if self.w ~= YRP.ctr(500) or self.h ~= YRP.ctr(50) or self.x ~= parent:GetWide() - YRP.ctr(20 + 500) or self.y ~= YRP.ctr(20) then
			self.w = YRP.ctr(500)
			self.h = YRP.ctr(50)
			self.x = parent:GetWide() - YRP.ctr(20 + 500)
			self.y = YRP.ctr(20)
			self:SetSize(self.w, self.h)
			self:SetPos(self.x, self.y)
		end
	end

	local btnRem = YRPCreateD("YButton", parent, YRP.ctr(500), YRP.ctr(50), parent:GetWide() - YRP.ctr(20 + 500), YRP.ctr(70))
	btnRem:SetText(YRP.trans("LID_removeentry"))
	function btnRem:DoClick()
		if lis:GetSelectedLine() ~= nil and lis:GetLine(lis:GetSelectedLine()):GetValue(1) ~= nil then
			net.Start("nws_yrp_blacklist_remove")
			net.WriteString(lis:GetLine(lis:GetSelectedLine()):GetValue(1))
			net.SendToServer()
			local nr = lis:GetLine(lis:GetSelectedLine()):GetValue(1)
			nr = tonumber(nr)
			for i, v in pairs(tabBL) do
				v.uniqueID = tonumber(v.uniqueID)
				if v.uniqueID == nr then
					table.RemoveByValue(tabBL, v)
				end
			end

			lis:RemoveLine(lis:GetSelectedLine())
		end
	end

	function btnRem:Paint(pw, ph)
		if lis:GetSelectedLine() ~= nil then
			hook.Run("YButtonRPaint", self, pw, ph)
		end
	end

	function btnRem:Think()
		if self.w ~= YRP.ctr(500) or self.h ~= YRP.ctr(50) or self.x ~= parent:GetWide() - YRP.ctr(20 + 500) or self.y ~= YRP.ctr(90) then
			self.w = YRP.ctr(500)
			self.h = YRP.ctr(50)
			self.x = parent:GetWide() - YRP.ctr(20 + 500)
			self.y = YRP.ctr(90)
			self:SetSize(self.w, self.h)
			self:SetPos(self.x, self.y)
		end
	end

	function lis:OnRemove()
		if YRPPanelAlive(btnAdd) then
			btnAdd:Remove()
		end

		if YRPPanelAlive(btnRem) then
			btnRem:Remove()
		end
	end
end

net.Receive(
	"nws_yrp_blacklist_get",
	function(len)
		local site = GetSettingsSite()
		if YRPPanelAlive(site) then
			site:Clear()
			local tabBL = net.ReadTable()
			local tab = net.ReadString()
			-- TABS
			local tabs = YRPCreateD("YTabs", site, site:GetWide(), site:GetTall(), 0, 0)
			function tabs:Think()
				self:SetSize(site:GetWide(), site:GetTall())
			end

			tabs:AddOption(
				"LID_all",
				function(parent)
					BuildBlacklis(parent, tabBL, "LID_all")
				end
			)

			tabs:AddOption(
				"LID_inventory",
				function(parent)
					BuildBlacklis(parent, tabBL, "LID_inventory")
				end
			)

			tabs:AddOption(
				"LID_chat",
				function(parent)
					BuildBlacklis(parent, tabBL, "LID_chat")
				end
			)

			tabs:AddOption(
				"LID_entities",
				function(parent)
					BuildBlacklis(parent, tabBL, "LID_entities")
				end
			)

			tabs:AddOption(
				"LID_props",
				function(parent)
					BuildBlacklis(parent, tabBL, "LID_props")
				end
			)

			tabs:GoToSite(tab)
		end
	end
)

function OpenSettingsBlacklist()
	net.Start("nws_yrp_blacklist_get")
	net.SendToServer()
end