--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

net.Receive( "Connect_Settings_Realistic", function( len )
	if pa( settingsWindow ) then
		if pa( settingsWindow.window ) then
			function settingsWindow.window.site:Paint( pw, ph )
				draw.RoundedBox( 4, 0, 0, pw, ph, Color( 0, 0, 0, 254 ) )

				surfaceText( lang_string( "wip" ), "mat1text", pw/2, ph/2, Color( 255, 255, 255 ), 1, 1 )
			end

			local PARENT = settingsWindow.window.site

			function PARENT:OnRemove()
				net.Start( "Disconnect_Settings_Realistic" )
				net.SendToServer()
			end

			local REL = net.ReadTable()
			printTab( REL )

		end
	end
end)

hook.Add( "open_server_realistic", "open_server_realistic", function()
	SaveLastSite()
	local ply = LocalPlayer()

	local w = settingsWindow.window.sitepanel:GetWide()
	local h = settingsWindow.window.sitepanel:GetTall()

	settingsWindow.window.site = createD( "DPanel", settingsWindow.window.sitepanel, w, h, 0, 0 )

	net.Start( "Connect_Settings_Realistic" )
	net.SendToServer()
end)
