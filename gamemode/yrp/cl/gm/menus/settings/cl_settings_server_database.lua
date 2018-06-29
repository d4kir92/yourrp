--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

net.Receive("Connect_Settings_Database", function(len)
	if pa(settingsWindow) then
		function settingsWindow.window.site:Paint(pw, ph)
			draw.RoundedBox(4, 0, 0, pw, ph, Color(0, 0, 0, 254))

			local wip = {}
			wip.text = "wip"
			wip.x = pw / 2
			wip.y = ph / 2
			wip.font = "mat1header"
			DrawText(wip)
		end

		local PARENT = settingsWindow.window.site

		function PARENT:OnRemove()
			net.Start("Disconnect_Settings_Database")
			net.SendToServer()
		end

		local NW_YRP = net.ReadTable()
		printTab(NW_YRP)
		local NW_YRP_RELATED = net.ReadTable()
		printTab(NW_YRP_RELATED)
		local NW_YRP_OTHER = net.ReadTable()
		printTab(NW_YRP_OTHER)
		local YRP_SQL = net.ReadTable()
		printTab(YRP_SQL)

		local br = ctr(20)
		local scroller = {}
		scroller.parent = PARENT
		scroller.x = br
		scroller.y = br
		scroller.w = BScrW() - 2 * br
		scroller.h = ScrH() - ctr(100) - 2 * br
		local Scroller = DHorizontalScroller(scroller)
		local yourrpdatabase = {}
		yourrpdatabase.parent = Scroller
		yourrpdatabase.x = 0
		yourrpdatabase.y = 0
		yourrpdatabase.w = ctr(1000)
		yourrpdatabase.h = Scroller:GetTall()
		yourrpdatabase.br = br / 2
		yourrpdatabase.name = "yourrpdatabase"
		local YourRPDatabase = DGroup(yourrpdatabase)
		local dhr = {}
		dhr.parent = YourRPDatabase
		dhr.color = YRPGetColor("2")
		local bl = {}
		bl.parent = YourRPDatabase
		bl.color = YRPGetColor("2")
		local ble = {}
		ble.parent = YourRPDatabase
		ble.color = YRPGetColor("2")
		ble.brx = ctr(50)

		local create = {}
		for i = 1, 6 do
			create[i] = {}
			create[i].name = i .. " " .. lang_string("hour")
			create[i].data = i
		end
		--DIntComboBoxBox(bl, create, "createbackupevery", "update_int_backup_create", tonumber(YRP_SQL.int_backup_create))

		local delete = {}
		for i = 1, 60 do
			delete[i] = {}
			delete[i].name = i .. " " .. lang_string("days")
			delete[i].data = i
		end
		--DIntComboBoxBox(bl, delete, "removebackolderthen", "update_int_backup_delete", tonumber(YRP_SQL.int_backup_delete))
		--Button make backup now

		DHR(dhr)

		local sqlmode = DIntComboBoxBox(bl, nil, "sqlmode", nil)
		if tonumber(YRP_SQL.int_mode) == 0 then
			sqlmode:AddChoice("SQLite", 0, true)
		else
			sqlmode:AddChoice("SQLite", 0)
		end
		if tonumber(YRP_SQL.int_mode) == 1 then
			sqlmode:AddChoice("MySQL (" .. lang_string("external") .. ")", 1, true)
		else
			sqlmode:AddChoice("MySQL (" .. lang_string("external") .. ")", 1)
		end

		DHR(dhr)

		local host = DStringBox(bl, YRP_SQL.string_host, "hostname", "update_string_host")
		local port = DIntBox(bl, YRP_SQL.int_port, "port", "update_int_port", 99999)
		local data = DStringBox(bl, YRP_SQL.database, "database", "update_string_database")
		local user = DStringBox(bl, YRP_SQL.username, "username", "update_string_username")
		local pass = DStringBox(bl, YRP_SQL.password, "password", "update_string_password")
		local change_to_sqlmode = createD("DButton", nil, YourRPDatabase:GetWide(), ctr(50), 0, 0)
		change_to_sqlmode:SetText("")
		function change_to_sqlmode:Paint(pw, ph)
			local tex, dat = sqlmode:GetSelected()
			surfaceButton(self, pw, ph, lang_string("changetosqlmode") .. ": " .. tex)
			dat = tonumber(dat)
			if dat == 0 then
				host:GetParent():SetSize(0, 0)
				port:GetParent():SetSize(0, 0)
				data:GetParent():SetSize(0, 0)
				user:GetParent():SetSize(0, 0)
				pass:GetParent():SetSize(0, 0)
			elseif dat == 1 then
				host:GetParent():SetSize(change_to_sqlmode:GetWide(), ctr(100))
				port:GetParent():SetSize(change_to_sqlmode:GetWide(), ctr(100))
				data:GetParent():SetSize(change_to_sqlmode:GetWide(), ctr(100))
				user:GetParent():SetSize(change_to_sqlmode:GetWide(), ctr(100))
				pass:GetParent():SetSize(change_to_sqlmode:GetWide(), ctr(100))
			end
			YourRPDatabase:Rebuild()
		end
		function change_to_sqlmode:DoClick()
			local _, dat = sqlmode:GetSelected()
			net.Start( "change_to_sql_mode" )
				net.WriteInt(dat, 32)
			net.SendToServer()
		end
		YourRPDatabase:AddItem(change_to_sqlmode)

		local yourrptables = {}
		yourrptables.parent = Scroller
		yourrptables.x = 0
		yourrptables.y = 0
		yourrptables.w = ctr(1000)
		yourrptables.h = Scroller:GetTall()
		yourrptables.br = br / 2
		yourrptables.name = "yourrptables"
		local YourRPTables = DGroup(yourrptables)
		YourRPTables:SetTall(YourRPTables:GetTall() - ctr(60))
		local dbtab = {}
		dbtab.parent = YourRPTables
		dbtab.color = YRPGetColor("2")
		local yrp_tabs = {}
		for i, tab in pairs(NW_YRP) do
			yrp_tabs[tab.name] = DBoolLine( dbtab, 0, tab.name, nil )
		end
		local _x, _y = YourRPTables:GetPos()
		local _w, _h = YourRPTables:GetSize()
		local _rem_and_change = createD("DButton", YourRPTables:GetParent(), YourRPTables:GetWide(), ctr(50), _x, _y + _h + ctr(10))
		_rem_and_change:SetText("")
		function _rem_and_change:Paint(pw, ph)
			surfaceButton(self, pw, ph, "droptablesandchangelevel")
		end
		function _rem_and_change:DoClick()
			local _nw_tab = {}
			local _count = 0
			for i, tab in pairs(yrp_tabs) do
				if tab:GetChecked() then
					_count = _count + 1
					_nw_tab[_count] = i
				end
			end

			local _window = createVGUI( "DFrame", nil, 430, 50 + 10 + 50 + 10, 0, 0 )
			_window:Center()
			_window:SetTitle( lang_string( "areyousure" ) )

			local _yesButton = createVGUI( "DButton", _window, 200, 50, 10, 60 )
			_yesButton:SetText( lang_string( "yes" ) )
			function _yesButton:DoClick()
				net.Start("yrp_drop_tables")
					net.WriteTable(_nw_tab)
				net.SendToServer()
				_window:Close()
			end

			local _noButton = createVGUI( "DButton", _window, 200, 50, 10 + 200 + 10, 60 )
			_noButton:SetText( lang_string( "no" ) )
			function _noButton:DoClick()
				_window:Close()
			end

			_window:MakePopup()
		end

		local yourrprelatedtables = {}
		yourrprelatedtables.parent = Scroller
		yourrprelatedtables.x = 0
		yourrprelatedtables.y = 0
		yourrprelatedtables.w = ctr(1000)
		yourrprelatedtables.h = Scroller:GetTall()
		yourrprelatedtables.br = br / 2
		yourrprelatedtables.name = "yourrprelatedtables"
		local YourRPRelatedTables = DGroup(yourrprelatedtables)
		YourRPRelatedTables:SetTall(YourRPRelatedTables:GetTall() - ctr(60))
		dbtab.parent = YourRPRelatedTables
		dbtab.color = YRPGetColor("2")
		local yrp_r_tabs = {}
		for i, tab in pairs(NW_YRP_RELATED) do
			yrp_r_tabs[tab.name] = DBoolLine( dbtab, 0, tab.name, nil )
		end
		local _rem_and_change2 = createD("DButton", YourRPRelatedTables:GetParent(), YourRPRelatedTables:GetWide(), ctr(50), _x, _y + _h + ctr(10))
		_rem_and_change2:SetText("")
		function _rem_and_change2:Paint(pw, ph)
			surfaceButton(self, pw, ph, "droptablesandchangelevel")
		end
		function _rem_and_change2:DoClick()
			local _nw_tab = {}
			local _count = 0
			for i, tab in pairs(yrp_r_tabs) do
				if tab:GetChecked() then
					_count = _count + 1
					_nw_tab[_count] = i
				end
			end

			local _window = createVGUI( "DFrame", nil, 430, 50 + 10 + 50 + 10, 0, 0 )
			_window:Center()
			_window:SetTitle( lang_string( "areyousure" ) )

			local _yesButton = createVGUI( "DButton", _window, 200, 50, 10, 60 )
			_yesButton:SetText( lang_string( "yes" ) )
			function _yesButton:DoClick()
				net.Start("yrp_drop_tables")
					net.WriteTable(_nw_tab)
				net.SendToServer()
				_window:Close()
			end

			local _noButton = createVGUI( "DButton", _window, 200, 50, 10 + 200 + 10, 60 )
			_noButton:SetText( lang_string( "no" ) )
			function _noButton:DoClick()
				_window:Close()
			end

			_window:MakePopup()
		end

		local othertables = {}
		othertables.parent = Scroller
		othertables.x = 0
		othertables.y = 0
		othertables.w = ctr(1000)
		othertables.h = Scroller:GetTall()
		othertables.br = br / 2
		othertables.name = "othertables"
		local OtherTables = DGroup(othertables)
		OtherTables:SetTall(OtherTables:GetTall() - ctr(60))
		dbtab.parent = OtherTables
		dbtab.color = YRPGetColor("2")
		local other_tabs = {}
		for i, tab in pairs(NW_YRP_OTHER) do
			other_tabs[tab.name] = DBoolLine( dbtab, 0, tab.name, nil )
		end
		local _rem_and_change3 = createD("DButton", OtherTables:GetParent(), OtherTables:GetWide(), ctr(50), _x, _y + _h + ctr(10))
		_rem_and_change3:SetText("")
		function _rem_and_change3:Paint(pw, ph)
			surfaceButton(self, pw, ph, "droptablesandchangelevel")
		end
		function _rem_and_change3:DoClick()
			local _nw_tab = {}
			local _count = 0
			for i, tab in pairs(other_tabs) do
				if tab:GetChecked() then
					_count = _count + 1
					_nw_tab[_count] = i
				end
			end

			local _window = createVGUI( "DFrame", nil, 430, 50 + 10 + 50 + 10, 0, 0 )
			_window:Center()
			_window:SetTitle( lang_string( "areyousure" ) )

			local _yesButton = createVGUI( "DButton", _window, 200, 50, 10, 60 )
			_yesButton:SetText( lang_string( "yes" ) )
			function _yesButton:DoClick()
				net.Start("yrp_drop_tables")
					net.WriteTable(_nw_tab)
				net.SendToServer()
				_window:Close()
			end

			local _noButton = createVGUI( "DButton", _window, 200, 50, 10 + 200 + 10, 60 )
			_noButton:SetText( lang_string( "no" ) )
			function _noButton:DoClick()
				_window:Close()
			end

			_window:MakePopup()
		end
	end
end)

hook.Add("open_server_database", "open_server_database", function()
	SaveLastSite()
	local w = settingsWindow.window.sitepanel:GetWide()
	local h = settingsWindow.window.sitepanel:GetTall()
	settingsWindow.window.site = createD("DPanel", settingsWindow.window.sitepanel, w, h, 0, 0)
	net.Start("Connect_Settings_Database")
	net.SendToServer()
end)
