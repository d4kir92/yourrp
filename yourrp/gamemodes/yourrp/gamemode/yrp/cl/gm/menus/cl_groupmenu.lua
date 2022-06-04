-- Group Menu

function YRPGetCharStatusByName( name )
	for i, v in pairs( player.GetAll() ) do
		if v:RPName() == name then
			return "Online"
		end
	end
	return "Offline"
end 

local GMENU = nil
function YRPToggleGroupMenu()
	if IsValid( GMENU ) then
		closeMenu()
		GMENU:Remove()
	elseif YRPIsNoMenuOpen() then
		openMenu()
		GMENU = createD( "YFrame", nil, 600, 600, 0, 0 )
		GMENU:SetTitle( string.format( "%s: %s", YRP.lang_string( "LID_group" ), LocalPlayer():GetGroupName() ) )
		GMENU:Center()
		GMENU:MakePopup()
		GMENU:SetSizable( true )



		-- LEFT
		GMENU.left = createD( "DPanel", GMENU, 200, 300, 0, 0 )
		GMENU.left:Dock( FILL )
		function GMENU.left:Paint( pw, ph )
			--
		end

		if LocalPlayer():GetYRPBool( "isInstructor" ) then
			GMENU.invite = createD( "YButton", GMENU.left, 36, 30, 0, 0 )
			GMENU.invite:Dock( TOP )
			GMENU.invite:SetText( "LID_invitetogroup" )
			function GMENU.invite:DoClick()
				local win = createD( "YFrame", nil, 400, 500, 0, 0 )
				win:SetTitle( "LID_invitetogroup" )
				win:Center()
				win:MakePopup()
				win:SetSizable( true )

				win.listheader = createD( "YLabel", win, 36, 30, 0, 0 )
				win.listheader:Dock( TOP )
				win.listheader:DockMargin( 0, 5, 0, 0 )
				win.listheader:SetText( "LID_players" )
				win.listheader.rad = 0

				win.list = createD( "DScrollPanel", win, 36, 30, 0, 0 )
				win.list:Dock( FILL )
				function win.list:Paint( pw, ph )
					draw.RoundedBox( 0, 0, 0, pw, ph, Color( 20, 20, 20 ) )
				end
				local sbar = win.list.VBar
				function sbar:Paint(w, h)
					draw.RoundedBox(0, 0, 0, w, h, YRPInterfaceValue( "YFrame", "NC" ) )
				end
				function sbar.btnUp:Paint(w, h)
					draw.RoundedBox(0, 0, 0, w, h, color_dark1 )
				end
				function sbar.btnDown:Paint(w, h)
					draw.RoundedBox(0, 0, 0, w, h, color_dark1 )
				end
				function sbar.btnGrip:Paint(w, h)
					draw.RoundedBox(w / 2, 0, 0, w, h, YRPInterfaceValue( "YFrame", "HI" ) )
				end

				for i, v in pairs( player.GetAll() ) do
					if LocalPlayer():GetGroupUID() != v:GetGroupUID() then
						local inv = createD( "YButton", win.list, 30, 30, 0, 0 )
						inv:Dock( TOP )
						inv:SetText( v:RPName() )
						function inv:DoClick()
							net.Start( "invitetogroup" )
								net.WriteString( v:CharID() )
							net.SendToServer()
							
							win:Remove()
						end
					end
				end
			end
		end

		GMENU.listheader = createD( "YLabel", GMENU.left, 36, 30, 0, 0 )
		GMENU.listheader:Dock( TOP )
		if LocalPlayer():GetYRPBool( "isInstructor" ) then
			GMENU.listheader:DockMargin( 0, 5, 0, 0 )
		end
		GMENU.listheader:SetText( "LID_members" )
		GMENU.listheader.rad = 0

		GMENU.list = createD( "DScrollPanel", GMENU.left, 36, 30, 0, 0 )
		GMENU.list:Dock( FILL )
		function GMENU.list:Paint( pw, ph )
			draw.RoundedBox( 0, 0, 0, pw, ph, Color( 20, 20, 20 ) )
		end
		local sbar = GMENU.list.VBar
		function sbar:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, YRPInterfaceValue( "YFrame", "NC" ) )
		end
		function sbar.btnUp:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, color_dark1 )
		end
		function sbar.btnDown:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, color_dark1 )
		end
		function sbar.btnGrip:Paint(w, h)
			draw.RoundedBox(w / 2, 0, 0, w, h, YRPInterfaceValue( "YFrame", "HI" ) )
		end



		-- RIGHT
		GMENU.right = createD( "DPanel", GMENU, 300, 300, 0, 0 )
		GMENU.right:Dock( RIGHT )
		GMENU.right:DockMargin( 5, 0, 0, 0 )
		function GMENU.right:Paint( pw, ph )
			--
		end

		GMENU.membername = createD( "YLabel", GMENU.right, 36, 30, 0, 0 )
		GMENU.membername:Dock( TOP )
		GMENU.membername:SetText( "LID_member" )
		GMENU.membername:Hide()

		GMENU.memberstatus = createD( "YLabel", GMENU.right, 36, 30, 0, 0 )
		GMENU.memberstatus:Dock( TOP )
		GMENU.memberstatus:DockMargin( 0, 5, 0, 0 )
		GMENU.memberstatus:SetText( "LID_status" )
		GMENU.memberstatus:Hide()

		GMENU.memberrole = createD( "YLabel", GMENU.right, 36, 30, 0, 0 )
		GMENU.memberrole:Dock( TOP )
		GMENU.memberrole:DockMargin( 0, 5, 0, 0 )
		GMENU.memberrole:SetText( "LID_role" )
		GMENU.memberrole:Hide()

		GMENU.specs = createD( "YButton", GMENU.right, 36, 30, 0, 0 )
		GMENU.specs:Dock( BOTTOM )
		GMENU.specs:DockMargin( 0, 5, 0, 0 )
		GMENU.specs:SetText( "LID_specializations" )
		GMENU.specs:Hide()
		function GMENU.specs:DoClick()
			if GMENU.charid then
				YRPOpenGiveSpec( GMENU.charid, LocalPlayer():GetRoleUID() )
			end
		end

		GMENU.demote = createD( "YButton", GMENU.right, 36, 30, 0, 0 )
		GMENU.demote:Dock( BOTTOM )
		GMENU.demote:DockMargin( 0, 5, 0, 0 )
		GMENU.demote:SetText( "LID_demote" )
		GMENU.demote:Hide()
		function GMENU.demote:DoClick()
			if GMENU.charid then
				net.Start( "demotePlayer" )
					net.WriteString( GMENU.charid )
				net.SendToServer()
			end
		end

		GMENU.promote = createD( "YButton", GMENU.right, 36, 30, 0, 0 )
		GMENU.promote:Dock( BOTTOM )
		GMENU.promote:DockMargin( 0, 5, 0, 0 )
		GMENU.promote:SetText( "LID_promote" )
		GMENU.promote:Hide()
		function GMENU.promote:DoClick()
			if GMENU.charid then
				net.Start( "promotePlayer" )
					net.WriteString( GMENU.charid )
				net.SendToServer()
			end
		end

		net.Receive( "yrp_group_getmember", function( len )
			local char = net.ReadTable()
			char.uniqueID = tonumber( char.uniqueID )
			if IsValid( GMENU ) then
				GMENU.charid = char.uniqueID

				GMENU.membername:SetText( string.format( "%s: %s", YRP.lang_string( "LID_name" ), char.name ) )
				GMENU.membername:Show()

				GMENU.memberstatus:SetText( string.format( "%s: %s", YRP.lang_string( "LID_status" ), YRPGetCharStatusByName( char.name ) ) )
				GMENU.memberstatus:Show()

				GMENU.memberrole:SetText( string.format( "%s: %s", YRP.lang_string( "LID_role" ), char.roleName ) )
				GMENU.memberrole:Show()

				if char.uniqueID != LocalPlayer():CharID() then
					if char.canspecs then
						GMENU.specs:Show()
					else
						GMENU.specs:Hide()
					end

					if char.candemote then
						GMENU.demote:Show()
					else
						GMENU.demote:Hide()
					end

					if char.canpromote then
						GMENU.promote:Show()
					else
						GMENU.promote:Hide()
					end
				else
					GMENU.specs:Hide()
					GMENU.demote:Hide()
					GMENU.promote:Hide()
				end
			end
		end )

		net.Receive( "yrp_group_getmembers", function( len )
			local members = net.ReadTable()
			if IsValid( GMENU ) then
				GMENU.list:Clear()
			end
			for i, v in pairs( members ) do
				if IsValid( GMENU ) then
					if v.rpname != "ID_RPNAME" and v.rpname != "BOTNAME" then
						local plline = createD( "YPanel", GMENU.list, 30, 30, 0, 0 )
						plline:Dock( TOP )
						plline:DockMargin( 0, 0, 0, 2 )

						plline.pl = createD( "YButton", plline, 30, 30, 0, 0 )
						plline.pl:Dock( FILL )
						plline.pl:SetText( v.rpname )
						plline.pl.rad = 0
						function plline.pl:DoClick()
							net.Start( "yrp_group_getmember" )
								net.WriteUInt( v.uniqueID, 24 )
							net.SendToServer()
						end

						if LocalPlayer():GetYRPBool( "isInstructor" ) then
							plline.del = createD( "YButton", plline, 30, 30, 0, 0 )
							plline.del:Dock( RIGHT )
							plline.del:SetText( "X" )
							function plline.del:Paint( pw, ph )
								local color = Color( 200, 160, 160, 255 )
								if self:IsHovered() then
									color = Color( 200, 0, 0, 255 )
								end
								draw.RoundedBox( 0, 0, 0, pw, ph, color )
								if YRP.GetDesignIcon( "64_trash" ) then
									surface.SetMaterial( YRP.GetDesignIcon( "64_trash" ) )
									surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
									surface.DrawTexturedRect( pw * 0.25, ph * 0.25, pw * 0.5, ph * 0.5 )
								end
							end
							function plline.del:DoClick()
								net.Start( "yrp_group_delmember" )
									net.WriteUInt( v.uniqueID, 24 )
								net.SendToServer()
							end
						end
					end
				end
			end
		end)

		net.Start( "yrp_group_getmembers" )
		net.SendToServer()
	end
end
