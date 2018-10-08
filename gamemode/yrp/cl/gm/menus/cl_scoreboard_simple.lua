--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local sbs = {}
sbs.icons = {}
sbs.icons.yrp = Material( "yrp/yrp_icon" )

function CloseSBS()
	SetIsScoreboardOpen(false)
	if pa(sbs.frame) then
		sbs.frame:Remove()
		sbs.frame = nil
	end
end

local elePos = {}
elePos.x = 0
elePos.y = 0

function OpenSBS()
	if sbs.frame == nil then
		SetIsScoreboardOpen(true)
		sbs.frame = createD("DFrame", nil, BScrW(), ScrH(), 0, 0)
		sbs.frame:SetDraggable(false)
		sbs.frame:ShowCloseButton(false)
		sbs.frame:MakePopup()

		local _mapPNG = getMapPNG()

		local _server_logo = LocalPlayer():GetNWString( "text_server_logo", "" )
		text_server_logo = GetHTMLImage( LocalPlayer():GetNWString( "text_server_logo", "" ), ctr( 256 ), ctr( 256 ) )

		function sbs.frame:Paint( pw, ph )
			draw.RoundedBox( 0, 0, 0, pw, ph, Color(0, 0, 0, 100))

			draw.RoundedBox( 0, ctr(256), ctr(128-50), pw-ctr(512), ctr(100), Color(0, 0, 255, 100))

			draw.SimpleTextOutlined( GAMEMODE:GetGameDescription() .. " [" .. GetRPBase() .. "]", "ScoreBoardNormal", ctr( 256 + 20 ), ctr( 128-20 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
			draw.SimpleTextOutlined( GetHostName(), "ScoreBoardTitle", ctr( 256 + 20 ), ctr(128 + 20), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

			draw.SimpleTextOutlined( lang_string( "map" ) .. ": " .. GetNiceMapName(), "ScoreBoardNormal", pw - ctr( 256 + 20 ), ctr( 128-20 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
			draw.SimpleTextOutlined( lang_string( "players" ) .. ": " .. #player.GetAll() .. "/" .. game.MaxPlayers(), "ScoreBoardNormal", pw - ctr( 256 + 20 ), ctr( 128 + 20 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

			if _server_logo == "" then
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( sbs.icons.yrp	)
				surface.DrawTexturedRect( 0, ctr( 4 ), ctr( 256 ), ctr( 256 ) )
			end

			if _mapPNG != false then
				draw.RoundedBox( 0, pw-ctr( 256 + 8 ), 0, ctr( 256 + 8 ), ctr( 256 + 8 ), Color( 0, 0, 0, 255 ) )

				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( _mapPNG	)
				surface.DrawTexturedRect( pw-ctr( 256 + 4 ), ctr( 4 ), ctr( 256 ), ctr( 256 ) )
			else
				if _server_logo == "" then
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( sbs.icons.yrp	)
					surface.DrawTexturedRect( pw-ctr( 256 + 4 ), ctr( 4 ), ctr( 256 ), ctr( 256 ) )
				end
			end
		end

		if _server_logo != "" then
			local ServerLogo = createD( "DHTML", sbs.frame, ctr( 256 ), ctr( 256 ), 0, ctr( 4 ) )
			ServerLogo:SetHTML( text_server_logo )
			if _mapPNG == false then
				local ServerLogo2 = createD( "DHTML", sbs.frame, ctr( 256 ), ctr( 256 ), sbs.frame:GetWide() - ctr( 256 + 4 ), ctr( 4 ) )
				ServerLogo2:SetHTML( text_server_logo )
			end
		end

		sbs.header = createD( "DPanel", sbs.frame, BScrW(), ctr(64), 0, ctr(256 + 10))
		function sbs.header:Paint(pw, ph)
			local pl = LocalPlayer()
			draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 100))

			local x = 128 + 10
			local naugname = lang_string("name") .. "/" .. lang_string("usergroup")
			if !pl:GetNWBool( "bool_yrp_scoreboard_show_usergroup", false ) then
				naugname = lang_string("name")
			end
			draw.SimpleTextOutlined(naugname, "sef", ctr(x), ph / 2, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
			x = x + 700

			if pl:GetNWBool( "bool_yrp_scoreboard_show_rolename", false ) or pl:GetNWBool( "bool_yrp_scoreboard_show_groupname", false ) then
				local rgname = lang_string("role") .. "/" .. lang_string("group")
				if !pl:GetNWBool( "bool_yrp_scoreboard_show_rolename", false ) then
					rgname = lang_string("group")
				elseif !pl:GetNWBool( "bool_yrp_scoreboard_show_groupname", false ) then
					rgname = lang_string("role")
				end
				draw.SimpleTextOutlined(rgname, "sef", ctr(x), ph / 2, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				x = x + 700
			end

			if pl:GetNWBool( "bool_yrp_scoreboard_show_frags", false ) or pl:GetNWBool( "bool_yrp_scoreboard_show_deaths", false ) then
				local fdname = lang_string("frags") .. "/" .. lang_string("deaths")
				if !pl:GetNWBool( "bool_yrp_scoreboard_show_frags", false ) then
					fdname = lang_string("deaths")
				elseif !pl:GetNWBool( "bool_yrp_scoreboard_show_deaths", false ) then
					fdname = lang_string("frags")
				end
				draw.SimpleTextOutlined(fdname, "sef", ctr(x), ph / 2, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				x = x + 400
			end

			draw.SimpleTextOutlined("Language", "sef", ctr(x), ph / 2, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
			x = x + 300

			draw.SimpleTextOutlined(lang_string("playtime"), "sef", ctr(x), ph / 2, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
			x = x + 300

			if pl:GetNWBool( "bool_yrp_scoreboard_show_operating_system", false ) then
				draw.SimpleTextOutlined(lang_string("os"), "sef", ctr(x), ph / 2, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				x = x + 300
			end

			draw.SimpleTextOutlined(lang_string("ping"), "sef", ctr(x), ph / 2, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
		end

		sbs.stab = createD( "DPanelList", sbs.frame, BScrW(), ScrH() - ctr(512 + 64), 0, ctr(256 + 10 + 64))

		local allplys = player.GetAll()
		local rplys = {}
		local uplys = {}
		for i, pl in pairs(allplys) do
			pl["group"] = pl:GetGroupName()
			if pl:GetGroupName() != "NO GROUP SELECTED" then
				table.insert(rplys, pl)
			else
				table.insert(uplys, pl)
			end
		end
		for i, pl in SortedPairsByMemberValue(rplys, "group") do
			local _p = createD( "DButton", sbs.stab, BScrW(), ctr(128), 0, 0)
			_p:SetText("")
			function _p:DoClick()
				OpenPlayerOptions(pl)
			end
			_p.col = i % 2 * 100
			_p.color = pl:GetGroupColor()
			if _p.color.r >= 240 then
				_p.color = Color(_p.color.r - 20, _p.color.g - 20, _p.color.b - 20, 100)
			else
				_p.color = Color(_p.color.r + 20, _p.color.g + 20, _p.color.b + 20, 100)
			end

			_p.pt = string.FormattedTime( pl:GetNWFloat( "uptime_current", 0 ) )
			if _p.pt.m < 10 then
				_p.pt.m = "0" .. _p.pt.m
			end
			if _p.pt.h < 10 then
				_p.pt.h = "0" .. _p.pt.h
			end
			_p.playtime = _p.pt.h .. ":" .. _p.pt.m
			_p.os = pl:GetNWString( "yrp_os", "other" )
			_p.lang = pl:GetLanguageShort()

			function _p:Paint(pw, ph)
				if !pl:IsValid() then
					self:Remove()
				else
					self.bg = self.color
					if self:IsHovered() then
						self.bg = Color(255, 255, 0, 200)
					end
					draw.RoundedBox(ph / 2, 0, 0, pw + ph / 2, ph, self.bg)

					local x = 128 + 10
					if true then
						local nay = ph / 4 * 1
						local ugy = ph / 4 * 3
						if !pl:GetNWBool( "bool_yrp_scoreboard_show_usergroup", false ) then
							nay = ph / 2
						end
						draw.SimpleTextOutlined(pl:RPName(), "sef", ctr(x), nay, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						if pl:GetNWBool( "bool_yrp_scoreboard_show_usergroup", false ) then
							draw.SimpleTextOutlined(string.upper(pl:GetUserGroup()), "sef", ctr(x), ugy, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						end
						x = x + 700
					end

					if pl:GetNWBool( "bool_yrp_scoreboard_show_rolename", false ) or pl:GetNWBool( "bool_yrp_scoreboard_show_groupname", false ) then
						local ry = ph / 4 * 1
						local gy = ph / 4 * 3
						if !pl:GetNWBool( "bool_yrp_scoreboard_show_rolename", false ) then
							gy = ph / 2
						elseif !pl:GetNWBool( "bool_yrp_scoreboard_show_groupname", false ) then
							ry = ph / 2
						end
						if pl:GetNWBool( "bool_yrp_scoreboard_show_rolename", false ) then
							draw.SimpleTextOutlined(pl:GetRoleName(), "sef", ctr(x), ry, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						end
						if pl:GetNWBool( "bool_yrp_scoreboard_show_groupname", false ) then
							local grpname = pl:GetGroupName()
							if pl:GetFactionName() != pl:GetGroupName() then
								grpname = "[" .. pl:GetFactionName() .. "] " .. grpname
							end
							draw.SimpleTextOutlined(grpname, "sef", ctr(x), gy, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						end
						x = x + 700
					end

					if pl:GetNWBool( "bool_yrp_scoreboard_show_frags", false ) or pl:GetNWBool( "bool_yrp_scoreboard_show_deaths", false ) then
						local fy = ph / 4 * 1
						local dy = ph / 4 * 3
						if !pl:GetNWBool( "bool_yrp_scoreboard_show_frags", false ) then
							dy = ph / 2
						elseif !pl:GetNWBool( "bool_yrp_scoreboard_show_deaths", false ) then
							fy = ph / 2
						end
						if pl:GetNWBool( "bool_yrp_scoreboard_show_frags", false ) then
							draw.SimpleTextOutlined(pl:Frags(), "sef", ctr(x), fy, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						end
						if pl:GetNWBool( "bool_yrp_scoreboard_show_deaths", false ) then
							draw.SimpleTextOutlined(pl:Deaths(), "sef", ctr(x), dy, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						end
						x = x + 400
					end

					if pl:GetNWBool( "bool_yrp_scoreboard_show_language", false ) then
						local icon_size = ctr( 100 )
						DrawIcon(GetDesignIcon( self.lang ), icon_size * 1.49, icon_size, ctr(x), ph / 2 - icon_size / 2, Color( 255, 255, 255, 255 ) )
						if self:IsHovered() then
							draw.SimpleTextOutlined(string.upper(self.lang), "sef", ctr(x) + icon_size / 2, ph / 2, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						end
						x = x + 300
					end

					if pl:GetNWBool( "bool_yrp_scoreboard_show_playtime", false ) then
						draw.SimpleTextOutlined(self.playtime, "sef", ctr(x), ph / 2, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						x = x + 300
					end

					if pl:GetNWBool( "bool_yrp_scoreboard_show_operating_system", false ) then
						local icon_size = ctr( 100 )
						DrawIcon( GetDesignIcon( "os_" .. self.os ), icon_size, icon_size, ctr(x), (ph - icon_size) / 2, Color( 255, 255, 255, 255 ) )
						if self:IsHovered() then
							draw.SimpleTextOutlined(string.upper(self.os), "sef", ctr(x), ph / 2, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						end
						x = x + 300
					end

					draw.SimpleTextOutlined(pl:Ping(), "sef", ctr(x), ph / 2, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				end
			end

			_p.avap = createD( "DPanel", _p, ctr( 128-8 ), ctr( 128-8 ), ctr( 4 ), ctr( 4 ) )
			_p.avap.Avatar = createD( "AvatarImage", _p.avap, ctr( 128-8 ), ctr( 128-8 ), 0, 0 )
			_p.avap.Avatar:SetPlayer( pl, ctr( 128-8 ) )
			_p.avap.Avatar:SetPaintedManually( true )
			function _p.avap:Paint( pw, ph )
				render.ClearStencil()
				render.SetStencilEnable( true )

					render.SetStencilWriteMask( 1 )
					render.SetStencilTestMask( 1 )

					render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )

					render.SetStencilFailOperation( STENCILOPERATION_INCR )
					render.SetStencilPassOperation( STENCILOPERATION_KEEP )
					render.SetStencilZFailOperation( STENCILOPERATION_KEEP )

					render.SetStencilReferenceValue( 1 )

					drawRoundedBox( ph / 2, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )

					render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )

					self.Avatar:SetPaintedManually(false)
					self.Avatar:PaintManual()
					self.Avatar:SetPaintedManually(true)

				render.SetStencilEnable( false )
			end

			sbs.stab:AddItem(_p)
			--sbs.stab:Rebuild()
		end

		if #uplys > 0 then
			sbs.hr = createD( "DPanel", sbs.frame, BScrW(), ctr(64), 0, ctr(256 + 10))
			function sbs.hr:Paint(pw, ph)
			end
			sbs.stab:AddItem(sbs.hr)

			sbs.charsel = createD( "DPanel", sbs.frame, BScrW(), ctr(64), 0, ctr(256 + 10))
			function sbs.charsel:Paint(pw, ph)
				local pl = LocalPlayer()
				draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 100))

				local x = 128 + 10
				draw.SimpleTextOutlined(lang_string("characterselection"), "sef", ctr(x), ph / 2, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
			end
			sbs.stab:AddItem(sbs.charsel)

			sbs.header2 = createD( "DPanel", sbs.frame, BScrW(), ctr(64), 0, ctr(256 + 10))
			function sbs.header2:Paint(pw, ph)
				local pl = LocalPlayer()
				draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 100))

				local x = 128 + 10
				local naugname = lang_string("name")
				draw.SimpleTextOutlined(naugname, "sef", ctr(x), ph / 2, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				x = x + 700

				if pl:GetNWBool( "bool_yrp_scoreboard_show_rolename", false ) or pl:GetNWBool( "bool_yrp_scoreboard_show_groupname", false ) then
					x = x + 700
				end

				if pl:GetNWBool( "bool_yrp_scoreboard_show_frags", false ) or pl:GetNWBool( "bool_yrp_scoreboard_show_deaths", false ) then
					x = x + 400
				end

				draw.SimpleTextOutlined("Language", "sef", ctr(x), ph / 2, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				x = x + 300

				draw.SimpleTextOutlined(lang_string("playtime"), "sef", ctr(x), ph / 2, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				x = x + 300

				if pl:GetNWBool( "bool_yrp_scoreboard_show_operating_system", false ) then
					draw.SimpleTextOutlined(lang_string("os"), "sef", ctr(x), ph / 2, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
					x = x + 300
				end

				draw.SimpleTextOutlined(lang_string("ping"), "sef", ctr(x), ph / 2, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
			end
			sbs.stab:AddItem(sbs.header2)

			for i, pl in SortedPairsByMemberValue(uplys, "group") do
				local _p = createD( "DButton", sbs.stab, BScrW(), ctr(128), 0, 0)
				_p:SetText("")
				function _p:DoClick()
					OpenPlayerOptions(pl)
				end
				_p.col = i % 2 * 100
				_p.color = Color(255, 255, 255, 255)
				if _p.color.r >= 240 then
					_p.color = Color(_p.color.r - 20, _p.color.g - 20, _p.color.b - 20, 100)
				else
					_p.color = Color(_p.color.r + 20, _p.color.g + 20, _p.color.b + 20, 100)
				end

				_p.pt = string.FormattedTime( pl:GetNWFloat( "uptime_current", 0 ) )
				if _p.pt.m < 10 then
					_p.pt.m = "0" .. _p.pt.m
				end
				if _p.pt.h < 10 then
					_p.pt.h = "0" .. _p.pt.h
				end
				_p.playtime = _p.pt.h .. ":" .. _p.pt.m
				_p.os = pl:GetNWString( "yrp_os", "other" )
				_p.lang = pl:GetLanguageShort()

				function _p:Paint(pw, ph)
					if !pl:IsValid() then
						self:Remove()
					else
						local lply = LocalPlayer()
						self.bg = self.color
						if self:IsHovered() then
							self.bg = Color(255, 255, 0, 200)
						end
						draw.RoundedBox(ph / 2, 0, 0, pw + ph / 2, ph, self.bg)

						local x = 128 + 10
						if true then
							local nay = ph / 4 * 1
							local ugy = ph / 4 * 3
							if !lply:GetNWBool( "bool_yrp_scoreboard_show_usergroup", false ) then
								nay = ph / 2
							end
							draw.SimpleTextOutlined(pl:RPName(), "sef", ctr(x), nay, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
							if pl:GetNWBool( "bool_yrp_scoreboard_show_usergroup", false ) then
								draw.SimpleTextOutlined(string.upper(pl:GetUserGroup()), "sef", ctr(x), ugy, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
							end
							x = x + 700
						end

						if lply:GetNWBool( "bool_yrp_scoreboard_show_rolename", false ) or lply:GetNWBool( "bool_yrp_scoreboard_show_groupname", false ) then
							x = x + 700
						end

						if lply:GetNWBool( "bool_yrp_scoreboard_show_frags", false ) or lply:GetNWBool( "bool_yrp_scoreboard_show_deaths", false ) then
							x = x + 400
						end

						if lply:GetNWBool( "bool_yrp_scoreboard_show_language", false ) then
							local icon_size = ctr( 100 )
							DrawIcon(GetDesignIcon( self.lang ), icon_size * 1.49, icon_size, ctr(x), ph / 2 - icon_size / 2, Color( 255, 255, 255, 255 ) )
							if self:IsHovered() then
								draw.SimpleTextOutlined(string.upper(self.lang), "sef", ctr(x) + icon_size / 2, ph / 2, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
							end
							x = x + 300
						end

						if lply:GetNWBool( "bool_yrp_scoreboard_show_playtime", false ) then
							draw.SimpleTextOutlined(self.playtime, "sef", ctr(x), ph / 2, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
							x = x + 300
						end

						if lply:GetNWBool( "bool_yrp_scoreboard_show_operating_system", false ) then
							local icon_size = ctr( 100 )
							DrawIcon( GetDesignIcon( "os_" .. self.os ), icon_size, icon_size, ctr(x), (ph - icon_size) / 2, Color( 255, 255, 255, 255 ) )
							if self:IsHovered() then
								draw.SimpleTextOutlined(string.upper(self.os), "sef", ctr(x), ph / 2, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
							end
							x = x + 300
						end

						draw.SimpleTextOutlined(pl:Ping(), "sef", ctr(x), ph / 2, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
					end
				end

				_p.avap = createD( "DPanel", _p, ctr( 128-8 ), ctr( 128-8 ), ctr( 4 ), ctr( 4 ) )
				_p.avap.Avatar = createD( "AvatarImage", _p.avap, ctr( 128-8 ), ctr( 128-8 ), 0, 0 )
				_p.avap.Avatar:SetPlayer( pl, ctr( 128-8 ) )
				_p.avap.Avatar:SetPaintedManually( true )
				function _p.avap:Paint( pw, ph )
					render.ClearStencil()
					render.SetStencilEnable( true )

						render.SetStencilWriteMask( 1 )
						render.SetStencilTestMask( 1 )

						render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )

						render.SetStencilFailOperation( STENCILOPERATION_INCR )
						render.SetStencilPassOperation( STENCILOPERATION_KEEP )
						render.SetStencilZFailOperation( STENCILOPERATION_KEEP )

						render.SetStencilReferenceValue( 1 )

						drawRoundedBox( ph / 2, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )

						render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )

						self.Avatar:SetPaintedManually(false)
						self.Avatar:PaintManual()
						self.Avatar:SetPaintedManually(true)

					render.SetStencilEnable( false )
				end

				sbs.stab:AddItem(_p)
				--sbs.stab:Rebuild()
			end
		end
	end
end
