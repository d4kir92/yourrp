--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

net.Receive( "Connect_Settings_Database", function(len)
	local PARENT = GetSettingsSite()
	if pa(PARENT) then
		function PARENT:OnRemove()
			net.Start( "Disconnect_Settings_Database" )
			net.SendToServer()
		end

		local TAB_YRP = net.ReadTable()
		local TAB_YRP_RELATED = net.ReadTable()
		local TAB_YRP_OTHER = net.ReadTable()
		local YRP_SQL = net.ReadTable()

		local br = YRP.ctr(20)
		local scroller = {}
		scroller.parent = PARENT
		scroller.x = br
		scroller.y = br
		scroller.w = PARENT:GetWide() - 2 * br
		scroller.h = PARENT:GetTall() - 2 * br
		local Scroller = DHorizontalScroller(scroller)



		local yourrpdatabase = YRPCreateD( "YGroupBox", Scroller, YRP.ctr(1000), Scroller:GetTall(), 0, 0)
		yourrpdatabase:SetText( "LID_yourrpdatabase" )
		function yourrpdatabase:Paint(pw, ph)
			hook.Run( "YGroupBoxPaint", self, pw, ph)
		end
		Scroller:AddPanel(yourrpdatabase)

		Scroller.YourRPDatabase = yourrpdatabase
		local yrp_db = Scroller.YourRPDatabase:GetContent()
		local dhr = {}
		dhr.parent = yrp_db
		dhr.color = YRPGetColor( "2" )
		local bl = {}
		bl.parent = yrp_db
		bl.color = YRPGetColor( "2" )
		local ble = {}
		ble.parent = yrp_db
		ble.color = YRPGetColor( "2" )
		ble.brx = YRP.ctr(50)

		local sqlmode = DIntComboBoxBox( bl, nil, "LID_sqlmode", nil)
		if tonumber(YRP_SQL.int_mode) == 0 then
			sqlmode:AddChoice( "SQLite", 0, true)
		else
			sqlmode:AddChoice( "SQLite", 0)
		end
		if tonumber(YRP_SQL.int_mode) == 1 then
			sqlmode:AddChoice( "MySQL ( " .. YRP.lang_string( "LID_external" ) .. " )", 1, true)
		else
			sqlmode:AddChoice( "MySQL ( " .. YRP.lang_string( "LID_external" ) .. " )", 1)
		end

		DHR( dhr)

		yrp_db.host = DStringBox( bl, YRP_SQL.string_host, "LID_hostname", "update_string_host" )
		yrp_db.port = OLDDIntBox( bl, YRP_SQL.int_port, "LID_port", "update_int_port", 99999)
		yrp_db.data = DStringBox( bl, YRP_SQL.string_database, "LID_database", "update_string_database" )
		yrp_db.user = DStringBox( bl, YRP_SQL.string_username, "LID_username", "update_string_username" )
		yrp_db.pass = DStringBox( bl, YRP_SQL.string_password, "LID_password", "update_string_password" )
		yrp_db.change_to_sqlmode = YRPCreateD( "DButton", nil, yrp_db:GetWide(), YRP.ctr(50), 0, 0)

		yrp_db:AddItem(yrp_db.change_to_sqlmode)

		local create = {}
		for i = 1, 6 do
			create[i] = {}
			local vals = {}
			vals["amount"] = i
			if i > 1 then
				create[i].name = YRP.lang_string( "LID_xhours", vals)
				create[i].data = i
			else
				create[i].name = YRP.lang_string( "LID_1hour", vals)
				create[i].data = i
			end
		end
		yrp_db.crea = DIntComboBoxBox( bl, create, "LID_createbackupevery", "update_int_backup_create", tonumber(YRP_SQL.int_backup_create) )

		local delete = {}
		for i = 1, 180 do
			delete[i] = {}
			local vals = {}
			vals["amount"] = i
			if i > 1 then
				delete[i].name = YRP.lang_string( "LID_xdays", vals)
				delete[i].data = i
			else
				delete[i].name = YRP.lang_string( "LID_1day", vals)
				delete[i].data = i
			end
		end
		yrp_db.dele = DIntComboBoxBox( bl, delete, "LID_removebackupolderthen", "update_int_backup_delete", tonumber(YRP_SQL.int_backup_delete) )
		yrp_db.createbackupnow = YRPCreateD( "DButton", nil, yrp_db:GetWide(), YRP.ctr(50), 0, 0)
		yrp_db.createbackupnow:SetText( "" )
		function yrp_db.createbackupnow:Paint(pw, ph)
			surfaceButton(self, pw, ph, YRP.lang_string( "LID_createbackupnow" ) .. " ( data/yrp_backups/)" )
		end
		function yrp_db.createbackupnow:DoClick()
			net.Start( "makebackup" )
			net.SendToServer()
		end
		yrp_db:AddItem(yrp_db.createbackupnow)

		yrp_db.change_to_sqlmode:SetText( "" )
		function yrp_db.change_to_sqlmode:Paint(pw, ph)
			local tex, dat = sqlmode:GetSelected()
			surfaceButton(self, pw, ph, YRP.lang_string( "LID_changetosqlmode" ) .. ": " .. tex)
			dat = tonumber( dat)
			if dat == 0 then
				yrp_db.host:GetParent():SetSize(0, 0)
				yrp_db.port:GetParent():SetSize(0, 0)
				yrp_db.data:GetParent():SetSize(0, 0)
				yrp_db.user:GetParent():SetSize(0, 0)
				yrp_db.pass:GetParent():SetSize(0, 0)
				yrp_db.crea:GetParent():SetSize(yrp_db.change_to_sqlmode:GetWide(), YRP.ctr(100) )
				yrp_db.dele:GetParent():SetSize(yrp_db.change_to_sqlmode:GetWide(), YRP.ctr(100) )
				yrp_db.createbackupnow:SetSize(yrp_db.change_to_sqlmode:GetWide(), YRP.ctr(50) )
				Scroller.YourRPTables:GetParent():SetSize(yrp_db:GetParent():GetWide(), YRP.ctr(100) )
				Scroller.YourRPRelatedTables:GetParent():SetSize(yrp_db:GetParent():GetWide(), YRP.ctr(100) )
				Scroller:SetOverlap(-9)
			elseif dat == 1 then
				yrp_db.host:GetParent():SetSize(yrp_db.change_to_sqlmode:GetWide(), YRP.ctr(100) )
				yrp_db.port:GetParent():SetSize(yrp_db.change_to_sqlmode:GetWide(), YRP.ctr(100) )
				yrp_db.data:GetParent():SetSize(yrp_db.change_to_sqlmode:GetWide(), YRP.ctr(100) )
				yrp_db.user:GetParent():SetSize(yrp_db.change_to_sqlmode:GetWide(), YRP.ctr(100) )
				yrp_db.pass:GetParent():SetSize(yrp_db.change_to_sqlmode:GetWide(), YRP.ctr(100) )
				yrp_db.crea:GetParent():SetSize(0, 0)
				yrp_db.dele:GetParent():SetSize(0, 0)
				yrp_db.createbackupnow:SetSize(0, 0)
				Scroller.YourRPTables:GetParent():SetSize(0, 0)
				Scroller.YourRPRelatedTables:GetParent():SetSize(0, 0)
				Scroller:SetOverlap(-3)
			end
			Scroller:InvalidateLayout(true)
			yrp_db:Rebuild()
		end
		function yrp_db.change_to_sqlmode:DoClick()
			local _, dat = sqlmode:GetSelected()
			net.Start( "change_to_sql_mode" )
				net.WriteInt( dat, 32)
			net.SendToServer()
		end

		DHR( dhr)

		local restartServer = YRPCreateD( "DButton", yourrpdatabase.parent, YRP.ctr(400), YRP.ctr(50), YRP.ctr(3000), YRP.ctr(900) )
		restartServer:SetText( "RESTART SERVER" )
		function restartServer:DoClick()
			net.Start( "yrp_restartserver" )
			net.SendToServer()
		end
		Scroller.YourRPDatabase:AddItem(restartServer)



		local yourrptables = YRPCreateD( "YGroupBox", Scroller, YRP.ctr(1000), Scroller:GetTall() - YRP.ctr(60), 0, 0)
		yourrptables:SetText( "LID_yourrptables" )
		function yourrptables:Paint(pw, ph)
			hook.Run( "YGroupBoxPaint", self, pw, ph)
		end
		Scroller:AddPanel(yourrptables)

		Scroller.YourRPTables = yourrptables:GetContent()
		Scroller.YourRPTables:SetTall(Scroller.YourRPTables:GetTall() - YRP.ctr(60) )
		local dbtab = {}
		dbtab.parent = Scroller.YourRPTables
		dbtab.color = YRPGetColor( "2" )
		local yrp_tabs = {}
		for i, tab in pairs(TAB_YRP) do
			yrp_tabs[tab.name] = DBoolLine( dbtab, 0, tab.name, nil)
		end
		local _x, _y = Scroller.YourRPTables:GetPos()
		local _w, _h = Scroller.YourRPTables:GetSize()
		local _rem_and_change = YRPCreateD( "DButton", Scroller.YourRPTables:GetParent(), Scroller.YourRPTables:GetWide(), YRP.ctr(50), _x, _y + _h + YRP.ctr(10) )
		_rem_and_change:SetText( "" )
		yourrptables:AddItem(_rem_and_change)
		function _rem_and_change:Paint(pw, ph)
			surfaceButton(self, pw, ph, YRP.lang_string( "LID_droptablesandchangelevel" ) )
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

			local _window = createVGUI( "DFrame", nil, 430, 50 + 10 + 50 + 10, 0, 0)
			_window:Center()
			_window:SetTitle(YRP.lang_string( "LID_areyousure" ) )

			local _yesButton = createVGUI( "DButton", _window, 200, 50, 10, 60)
			_yesButton:SetText(YRP.lang_string( "LID_yes" ) )
			function _yesButton:DoClick()
				net.Start( "yrp_drop_tables" )
					net.WriteTable(_nw_tab)
				net.SendToServer()
				_window:Close()
			end

			local _noButton = createVGUI( "DButton", _window, 200, 50, 10 + 200 + 10, 60)
			_noButton:SetText(YRP.lang_string( "LID_no" ) )
			function _noButton:DoClick()
				_window:Close()
			end

			_window:MakePopup()
		end



		local yourrprelatedtables = YRPCreateD( "YGroupBox", Scroller, YRP.ctr(1000), Scroller:GetTall(), 0, 0)
		yourrprelatedtables:SetText( "LID_yourrprelatedtables" )
		function yourrprelatedtables:Paint(pw, ph)
			hook.Run( "YGroupBoxPaint", self, pw, ph)
		end
		Scroller:AddPanel(yourrprelatedtables)

		Scroller.YourRPRelatedTables = yourrprelatedtables:GetContent()
		Scroller.YourRPRelatedTables:SetTall(Scroller.YourRPRelatedTables:GetTall() - YRP.ctr(60) )
		dbtab.parent = Scroller.YourRPRelatedTables
		dbtab.color = YRPGetColor( "2" )
		local yrp_r_tabs = {}
		for i, tab in pairs(TAB_YRP_RELATED) do
			yrp_r_tabs[tab.name] = DBoolLine( dbtab, 0, tab.name, nil)
		end
		local _rem_and_change2 = YRPCreateD( "DButton", Scroller.YourRPRelatedTables:GetParent(), Scroller.YourRPRelatedTables:GetWide(), YRP.ctr(50), _x, _y + _h + YRP.ctr(10) )
		_rem_and_change2:SetText( "" )
		yourrprelatedtables:AddItem(_rem_and_change2)
		function _rem_and_change2:Paint(pw, ph)
			surfaceButton(self, pw, ph, YRP.lang_string( "LID_droptablesandchangelevel" ) )
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

			local _window = createVGUI( "DFrame", nil, 430, 50 + 10 + 50 + 10, 0, 0)
			_window:Center()
			_window:SetTitle(YRP.lang_string( "LID_areyousure" ) )

			local _yesButton = createVGUI( "DButton", _window, 200, 50, 10, 60)
			_yesButton:SetText(YRP.lang_string( "LID_yes" ) )
			function _yesButton:DoClick()
				net.Start( "yrp_drop_tables" )
					net.WriteTable(_nw_tab)
				net.SendToServer()
				_window:Close()
			end

			local _noButton = createVGUI( "DButton", _window, 200, 50, 10 + 200 + 10, 60)
			_noButton:SetText(YRP.lang_string( "LID_no" ) )
			function _noButton:DoClick()
				_window:Close()
			end

			_window:MakePopup()
		end



		local othertables = YRPCreateD( "YGroupBox", Scroller, YRP.ctr(1000), Scroller:GetTall(), 0, 0)
		othertables:SetText( "LID_othertables" )
		function othertables:Paint(pw, ph)
			hook.Run( "YGroupBoxPaint", self, pw, ph)
		end
		Scroller:AddPanel(othertables)

		local OtherTables = othertables:GetContent()
		OtherTables:SetTall(OtherTables:GetTall() - YRP.ctr(60) )
		dbtab.parent = OtherTables
		dbtab.color = YRPGetColor( "2" )
		local other_tabs = {}
		for i, tab in pairs(TAB_YRP_OTHER) do
			other_tabs[tab.name] = DBoolLine( dbtab, 0, tab.name, nil)
		end
		local _rem_and_change3 = YRPCreateD( "DButton", OtherTables:GetParent(), OtherTables:GetWide(), YRP.ctr(50), _x, _y + _h + YRP.ctr(10) )
		_rem_and_change3:SetText( "" )
		othertables:AddItem(_rem_and_change3)
		function _rem_and_change3:Paint(pw, ph)
			surfaceButton(self, pw, ph, YRP.lang_string( "LID_droptablesandchangelevel" ) )
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

			local _window = createVGUI( "DFrame", nil, 430, 50 + 10 + 50 + 10, 0, 0)
			_window:Center()
			_window:SetTitle(YRP.lang_string( "LID_areyousure" ) )

			local _yesButton = createVGUI( "DButton", _window, 200, 50, 10, 60)
			_yesButton:SetText(YRP.lang_string( "LID_yes" ) )
			function _yesButton:DoClick()
				net.Start( "yrp_drop_tables" )
					net.WriteTable(_nw_tab)
				net.SendToServer()
				_window:Close()
			end

			local _noButton = createVGUI( "DButton", _window, 200, 50, 10 + 200 + 10, 60)
			_noButton:SetText(YRP.lang_string( "LID_no" ) )
			function _noButton:DoClick()
				_window:Close()
			end

			_window:MakePopup()
		end
	end
end)

function OpenSettingsDatabase()
	net.Start( "Connect_Settings_Database" )
	net.SendToServer()
end
