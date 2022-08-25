--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- #BLACKLISTSETTINGS

function BuildBlacklist(parent, tabBL, tab)
	parent:Clear()
	local list = YRPCreateD( "DListView", parent, parent:GetWide() - YRP.ctr(60 + 500), parent:GetTall() - YRP.ctr(140), YRP.ctr(20), YRP.ctr(20) )
	list:AddColumn( "uniqueID" ):SetFixedWidth(80)
	list:AddColumn(YRP.lang_string( "LID_name" ) )
	list:AddColumn(YRP.lang_string( "LID_value" ) )
	function list:Think()
		if self.w != parent:GetWide() - YRP.ctr(60 + 500) or self.h != parent:GetTall() - YRP.ctr(40) or self.x != YRP.ctr(20) or self.y != YRP.ctr(20) then
			self.w = parent:GetWide() - YRP.ctr(60 + 500)
			self.h = parent:GetTall() - YRP.ctr(40)
			self.x = YRP.ctr(20)
			self.y = YRP.ctr(20)

			self:SetSize(self.w, self.h)
			self:SetPos(self.x, self.y)
		end
	end

	for k, bla in pairs(tabBL) do
		local found = false
		if tab == "LID_all" or tab == "LID_inventory" and bla.name == "inventory" or tab == "LID_chat" and bla.name == "chat" or tab == "LID_entities" and bla.name == "entities" then
			list:AddLine( bla.uniqueID, bla.name, bla.value)
		end
	end

	local btnAdd = YRPCreateD( "YButton", parent, YRP.ctr(500), YRP.ctr(50), parent:GetWide() - YRP.ctr(20 + 500), YRP.ctr(20) )
	btnAdd:SetText(YRP.lang_string( "LID_addentry" ) )
	function btnAdd:DoClick()
		local AddFrame = YRPCreateD( "YFrame", nil, YRP.ctr(500), YRP.ctr(500), 0, 0)
		AddFrame:Center()
		AddFrame:SetDraggable(true)
		AddFrame:SetTitle( "LID_add" )
		AddFrame:MakePopup()

		local CONTENT = AddFrame:GetContent()

		local addlist = YRPCreateD( "DPanelList", CONTENT, CONTENT:GetWide(), CONTENT:GetTall(), 0, 0) 



		local BLNameHeader = YRPCreateD( "YLabel", CONTENT, CONTENT:GetWide(), YRP.ctr(50), 0, 0)
		BLNameHeader:SetText( "LID_name" )
		addlist:AddItem(BLNameHeader)

		local BLName = YRPCreateD( "DComboBox", CONTENT, CONTENT:GetWide(), YRP.ctr(50), 0, 0)
		for k, v in pairs({"chat", "inventory", "entities"}) do
			BLName:AddChoice( v, v)
		end
		addlist:AddItem(BLName)



		local HR = YRPCreateD( "DPanel", CONTENT, CONTENT:GetWide(), YRP.ctr(20), 0, 0)
		function HR:Paint(pw, ph)
			--
		end
		addlist:AddItem(HR)



		local BLValueHeader = YRPCreateD( "YLabel", CONTENT, CONTENT:GetWide(), YRP.ctr(50), 0, 0)
		BLValueHeader:SetText( "LID_value" )
		addlist:AddItem(BLValueHeader)

		local BLValue = YRPCreateD( "DTextEntry", CONTENT, CONTENT:GetWide(), YRP.ctr(50), 0, 0)
		addlist:AddItem(BLValue)



		addlist:AddItem(HR)



		local BLAdd = YRPCreateD( "DButton", CONTENT, CONTENT:GetWide(), YRP.ctr(50), 0, 0)
		BLAdd:SetText(YRP.lang_string( "LID_add" ) )
		function BLAdd:DoClick()
			if BLName:GetOptionData(BLName:GetSelectedID() ) != nil then
				net.Start( "yrp_blacklist_add" )
					net.WriteString(BLName:GetOptionData(BLName:GetSelectedID() ))
					net.WriteString(BLValue:GetText() )
				net.SendToServer()

				net.Start( "yrp_blacklist_get" )
					net.WriteString(tab)
				net.SendToServer()
			end
			AddFrame:Close()
		end
		addlist:AddItem(BLAdd)
	end
	function btnAdd:Think(pw, ph)
		if self.w != YRP.ctr(500) or self.h != YRP.ctr(50) or self.x != parent:GetWide() - YRP.ctr(20 + 500) or self.y != YRP.ctr(20) then
			self.w = YRP.ctr(500)
			self.h = YRP.ctr(50)
			self.x = parent:GetWide() - YRP.ctr(20 + 500)
			self.y = YRP.ctr(20)

			self:SetSize(self.w, self.h)
			self:SetPos(self.x, self.y)
		end
	end

	local btnRem = YRPCreateD( "YButton", parent, YRP.ctr(500), YRP.ctr(50), parent:GetWide() - YRP.ctr(20 + 500), YRP.ctr(70) )
	btnRem:SetText(YRP.lang_string( "LID_removeentry" ) )
	function btnRem:DoClick()
		if list:GetSelectedLine() != nil then
			if list:GetLine(list:GetSelectedLine() ):GetValue(1) != nil then
				net.Start( "yrp_blacklist_remove" )
					net.WriteString(list:GetLine(list:GetSelectedLine() ):GetValue(1) )
				net.SendToServer()

				local nr = list:GetLine(list:GetSelectedLine() ):GetValue(1)
				nr = tonumber(nr)
				for i, v in pairs(tabBL) do
					v.uniqueID = tonumber( v.uniqueID)
					if v.uniqueID == nr then
						table.RemoveByValue(tabBL, v)
					end
				end
				list:RemoveLine(list:GetSelectedLine() )
			end
		end
	end
	function btnRem:Paint(pw, ph)
		if list:GetSelectedLine() != nil then
			hook.Run( "YButtonRPaint", self, pw, ph)
		end
	end
	function btnRem:Think()
		if self.w != YRP.ctr(500) or self.h != YRP.ctr(50) or self.x != parent:GetWide() - YRP.ctr(20 + 500) or self.y != YRP.ctr(90) then
			self.w = YRP.ctr(500)
			self.h = YRP.ctr(50)
			self.x = parent:GetWide() - YRP.ctr(20 + 500)
			self.y = YRP.ctr(90)

			self:SetSize(self.w, self.h)
			self:SetPos(self.x, self.y)
		end
	end

	function list:OnRemove()
		if pa( btnAdd) then
			btnAdd:Remove()
		end
		if pa( btnRem) then
			btnRem:Remove()
		end
	end
end

net.Receive( "yrp_blacklist_get", function(len)
	local site = GetSettingsSite()

	if pa(site) then

		site:Clear()

		local tabBL = net.ReadTable()
		local tab = net.ReadString()
	
		-- TABS
		local tabs = YRPCreateD( "YTabs", site, site:GetWide(), site:GetTall(), 0, 0)
		function tabs:Think()
			self:SetSize(site:GetWide(), site:GetTall() )
		end

		tabs:AddOption( "LID_all", function(parent)
			BuildBlacklist(parent, tabBL, "LID_all" )
		end)
		tabs:AddOption( "LID_inventory", function(parent)
			BuildBlacklist(parent, tabBL, "LID_inventory" )
		end)
		tabs:AddOption( "LID_chat", function(parent)
			BuildBlacklist(parent, tabBL, "LID_chat" )
		end)
		tabs:AddOption( "LID_entities", function(parent)
			BuildBlacklist(parent, tabBL, "LID_entities" )
		end)

		tabs:GoToSite(tab)
	end
end)

function OpenSettingsBlacklist()
	local lply = LocalPlayer()

	net.Start( "yrp_blacklist_get" )
	net.SendToServer()
end
