--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function AddDBLine( parent, tab )
	local tmp = createD( "DPanel", parent, ctr(1000), ctr(50), 0, 0 )
	function tmp:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 255 ) )
		local info = {}
		info.text = tab.name
		info.x = ctr(10)
		info.y = ph / 2
		info.ax = 0
		info.font = "mat1text"
		DrawText(info)
	end

	tmp.droptable = createD( "DButton", tmp, ctr(300), ctr(50), tmp:GetWide() - ctr(300), 0 )
	tmp.droptable:SetText( "" )
	tmp.droptable.tab = tab
	function tmp.droptable:Paint( pw, ph )
		surfaceButton( self, pw, ph, "remove")
	end
	function tmp.droptable:DoClick()
		net.Start("yrp_drop_table")
			net.WriteString(self.tab.name)
		net.SendToServer()
	end

	parent:AddItem( tmp )
	return tmp
end

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
		--DIntComboBoxBox(bl, YRP_SQL.mode, "sqlmode", "update_sqlmode")
		DHR(dhr)
		DStringBox(bl, YRP_SQL.string_host, "hostname", "update_string_host")
		DIntBox(bl, YRP_SQL.int_port, "port", "update_int_port", 99999)
		DStringBox(bl, YRP_SQL.database, "database", "update_string_database")
		DStringBox(bl, YRP_SQL.username, "username", "update_string_username")
		DStringBox(bl, YRP_SQL.password, "password", "update_string_password")
		--Button change to mode
		DHR(dhr)
		--DIntComboBoxBox(bl, YRP_SQL.password, "createbackupevery", "update_string_create_backup")
		--DIntComboBoxBox(bl, YRP_SQL.password, "removebackupafter", "update_string_remove_backup")
		--Button make backup now
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
