--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--cl_scoreboard.lua

local sb_groups = {}
net.Receive( "getScoreboardGroups", function()
	sb_groups = net.ReadTable()
end)
timer.Simple( 1, function()
	net.Start( "getScoreboardGroups" )
	net.SendToServer()
end)
timer.Simple( 6, function()
	net.Start( "getScoreboardGroups" )
	net.SendToServer()
end)

local scoreboard = {}

local elePos = {}
elePos.x = 0
elePos.y = 0

local _yrpIcon = Material( "yrp/yrp_icon" )
local _br = 40

function hasGroupPlayers( id )
	for k, ply in pairs( player.GetAll() ) do
		if tonumber( ply:GetNWString( "groupUniqueID" ) ) == tonumber( id ) then
			return true
		end
	end
	return false
end

function hasLowerGroupPlayers( id )
	for k, group in pairs( sb_groups ) do
		if tonumber( group.int_parentgroup ) == tonumber( id ) then
			if hasGroupPlayers( group.uniqueID ) then
				return true
			elseif hasLowerGroupPlayers( group.uniqueID ) then
				return true
			end
		end
	end
	return false
end

function hasGroupRowPlayers( id )
	for g, groups in pairs( sb_groups ) do
		if tonumber( groups.uniqueID ) == tonumber( id ) then
			if hasGroupPlayers( groups.uniqueID ) then
				return true
			else
				if hasLowerGroupPlayers( groups.uniqueID ) then
					return true
				end
			end
		end
	end
	return false
end

function notself( ply )
	if LocalPlayer() != ply then
		return true
	end
	return false
end

function drawGroupPlayers( id )
	for k, ply in pairs( player.GetAll() ) do
		if tonumber( id ) == tonumber( ply:GetNWString( "groupUniqueID" ) ) then
			local _tmpPly = createD( "DButton", _SBSP, BScrW() - ctr(400) - ctr( 110 ) - ctr( elePos.x ), ctr(128), ctr( elePos.x + 10 ), ctr( elePos.y ) )
			_tmpPly:SetText( "" )
			_tmpPly.gerade = k % 2
			_tmpPly.level = 1
			_tmpPly.rpname = ply:RPName() or ""
			_tmpPly.rolename = ply:GetRoleName()
			_tmpPly.groupname = ply:GetGroupName()
			_tmpPly.frags = ply:Frags()
			_tmpPly.deaths = ply:Deaths()
			_tmpPly.rank = ply:GetUserGroup() or ""
			_tmpPly.ping = ply:Ping() or ""
			_tmpPly.usergroup = ply:GetUserGroup() or ""
			_tmpPly.steamname = ply:SteamName() or ""
			_tmpPly.lang = ply:GetLanguageShort() or ""
			_tmpPly.language = ply:GetLanguage() or ""
			_tmpPly.money = ply:GetNWString( "money" )
			_tmpPly.moneybank = ply:GetNWString( "moneybank" )
			_tmpPly.os = ply:GetNWString( "yrp_os", "other" )
			local _pt = string.FormattedTime( ply:GetNWFloat( "uptime_current", 0 ) )
			if _pt.m < 10 then
				_pt.m = "0" .. _pt.m
			end
			if _pt.h < 10 then
				_pt.h = "0" .. _pt.h
			end
			_tmpPly.playtime = _pt.h .. ":" .. _pt.m

			local _tmp_p_ava = createD( "DPanel", _tmpPly, ctr( 128-8 ), ctr( 128-8 ), ctr( 4 ), ctr( 4 ) )
			_tmp_p_ava.Avatar = createD( "AvatarImage", _tmp_p_ava, ctr( 128-8 ), ctr( 128-8 ), 0, 0 )
			_tmp_p_ava.Avatar:SetPlayer( ply, ctr( 128-8 ) )
			_tmp_p_ava.Avatar:SetPaintedManually( true )
			function _tmp_p_ava:Paint( pw, ph )
				render.ClearStencil()
				render.SetStencilEnable( true )

					render.SetStencilWriteMask( 1 )
					render.SetStencilTestMask( 1 )

					render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )

					render.SetStencilFailOperation( STENCILOPERATION_INCR )
					render.SetStencilPassOperation( STENCILOPERATION_KEEP )
					render.SetStencilZFailOperation( STENCILOPERATION_KEEP )

					render.SetStencilReferenceValue( 1 )

					drawRoundedBox( ph/2, 0, 0, pw, ph, Color( 0, 0, 0, 255 ) )

					render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )

					self.Avatar:SetPaintedManually(false)
					self.Avatar:PaintManual()
					self.Avatar:SetPaintedManually(true)

				render.SetStencilEnable( false )
			end

			function _tmpPly:Paint( pw, ph )
				local _extra = 0
				if self.gerade == 0 then
					_extra = 50
				end
				if self:IsHovered() then
					if self.gerade == 1 then
					end
					draw.RoundedBoxEx( ph/2, 0, 0, pw, ph, Color( 255, 255, 0, 200 ), true, false, true, false )
				else
					draw.RoundedBoxEx( ph/2, 0, 0, pw, ph, Color( _extra, _extra, _extra, 200 ), true, false, true, false )
				end

				local _w = ctr( 128+16 )
				local namey = ph/4
				if !ply:GetNWBool( "bool_yrp_scoreboard_show_usergroup", false ) then
					namey = ph/2
				end
				draw.SimpleTextOutlined( self.rpname, "sef", _w, namey, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
				if ply:GetNWBool( "bool_yrp_scoreboard_show_usergroup", false ) then
					draw.SimpleTextOutlined( string.upper( self.rank ), "sef", _w, ph*3/4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
				end

				if ply:GetNWBool( "bool_yrp_scoreboard_show_rolename", false ) or ply:GetNWBool( "bool_yrp_scoreboard_show_groupname", false ) then
					_w = _w + ctr( 600 )
				end

				if ply:GetNWBool( "bool_yrp_scoreboard_show_rolename", false ) then
					local y = ph/4
					if !ply:GetNWBool( "bool_yrp_scoreboard_show_groupname", false ) then
						y = ph/2
					end
					draw.SimpleTextOutlined( self.rolename, "sef", _w, y, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
				end
				if ply:GetNWBool( "bool_yrp_scoreboard_show_groupname", false ) then
					local y = ph*3/4
					if !ply:GetNWBool( "bool_yrp_scoreboard_show_rolename", false ) then
						y = ph/2
					end
					draw.SimpleTextOutlined( self.groupname, "sef", _w, y, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
				end

				if ply:GetNWBool( "bool_yrp_scoreboard_show_frags", false ) or ply:GetNWBool( "bool_yrp_scoreboard_show_deaths", false ) then
					_w = _w + ctr( 600 )
				end

				if ply:GetNWBool( "bool_yrp_scoreboard_show_frags", false ) then
					local y = ph / 4
					if !ply:GetNWBool( "bool_yrp_scoreboard_show_deaths", false ) then
						y = ph / 2
					end
					draw.SimpleTextOutlined( self.frags, "sef", _w, y, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
				end
				if ply:GetNWBool( "bool_yrp_scoreboard_show_deaths", false ) then
					local y = ph * 3 / 4
					if !ply:GetNWBool( "bool_yrp_scoreboard_show_frags", false ) then
						y = ph / 2
					end
					draw.SimpleTextOutlined( self.deaths, "sef", _w, y, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
				end

				if ply:GetNWBool( "bool_yrp_scoreboard_show_language", false ) then
					local icon_size = ctr( 100 )
					_w = _w + ctr( 600 )
					DrawIcon( GetDesignIcon( self.lang ), icon_size * 1.49, icon_size, _w, ph / 2 - icon_size / 2, Color( 255, 255, 255, 255 ) )
					if self:IsHovered() then
						draw.SimpleTextOutlined( string.upper(self.lang), "sef", _w + ( icon_size * 1.49 ) / 2, ph / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
					end
				end

				if ply:GetNWBool( "bool_yrp_scoreboard_show_playtime", false ) then
					_w = _w + ctr( 500 )
					draw.SimpleTextOutlined( self.playtime, "sef", _w, ph / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
				end

				if ply:GetNWBool( "bool_yrp_scoreboard_show_operating_system", false ) then
					local icon_size = ctr( 100 )
					DrawIcon( GetDesignIcon( "os_" .. self.os ), icon_size, icon_size, pw - ctr( 150 ) - icon_size, ph/2 - icon_size/2, Color( 255, 255, 255, 255 ) )
				end
				draw.SimpleTextOutlined( self.ping, "sef", pw - ctr( 20 ), ph / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
			end

			function _tmpPly:DoClick()
				local _mx, _my = gui.MousePos()
				local _menu = createD( "DYRPMenu", nil, ctr( 500 ), ctr( 50 ), _mx - ctr( 25 ), _my - ctr( 25 ) )
				_menu:MakePopup()

				local osp = _menu:AddOption( lang_string( "openprofile" ), "icon16/page.png" )
				function osp:DoClick()
					ply:ShowProfile()
				end

				_menu:AddSpacer()

				local csid = _menu:AddOption( lang_string( "copysteamid" ), "icon16/page_copy.png" )
				function csid:DoClick()
					SetClipboardText( ply:SteamID() )
					_menu:Remove()
				end
				local csid64 = _menu:AddOption( lang_string( "copysteamid64" ), "icon16/page_copy.png" )
				function csid64:DoClick()
					SetClipboardText( ply:SteamID64() )
					_menu:Remove()
				end
				local crpname = _menu:AddOption( lang_string( "copyrpname" ), "icon16/page_copy.png" )
				function crpname:DoClick()
					SetClipboardText( ply:RPName() )
					_menu:Remove()
				end
				local csname = _menu:AddOption( lang_string( "copysteamname" ), "icon16/page_copy.png" )
				function csname:DoClick()
					SetClipboardText( ply:SteamName() )
					_menu:Remove()
				end
				_menu:AddSpacer()

				_menu:AddOption( "Language: " .. self.language, "icon16/map.png" )
				_menu:AddSpacer()

				if LocalPlayer():HasAccess() and notself( ply ) then
					local ban = _menu:AddOption( lang_string( "ban" ), "icon16/world_link.png" )
					function ban:DoClick()
						net.Start( "ply_ban" )
							net.WriteEntity( ply )
						net.SendToServer()
					end
					local kick = _menu:AddOption( lang_string( "kick" ), "icon16/world_go.png" )
					function kick:DoClick()
						net.Start( "ply_kick" )
							net.WriteEntity( ply )
						net.SendToServer()
					end
					_menu:AddSpacer()
				end

				if LocalPlayer():HasAccess() and notself( ply ) then
					local tpto = _menu:AddOption( lang_string( "tpto" ), "icon16/arrow_right.png" )
					function tpto:DoClick()
						net.Start( "tp_tpto" )
							net.WriteEntity( ply )
						net.SendToServer()
					end
					local bring = _menu:AddOption( lang_string( "bring" ), "icon16/arrow_redo.png" )
					function bring:DoClick()
						net.Start( "tp_bring" )
							net.WriteEntity( ply )
						net.SendToServer()
					end
				end

				if LocalPlayer():HasAccess() then
					if !ply:GetNWBool( "injail", false ) then
						local jail = _menu:AddOption( lang_string( "jail" ), "icon16/lock_go.png" )
						function jail:DoClick()
							net.Start( "tp_jail" )
								net.WriteEntity( ply )
							net.SendToServer()
							_menu:Remove()
						end
					else
						local unjail = _menu:AddOption( lang_string( "unjail" ), "icon16/lock_open.png" )
						function unjail:DoClick()
							net.Start( "tp_unjail" )
								net.WriteEntity( ply )
							net.SendToServer()
							_menu:Remove()
						end
					end
					_menu:AddSpacer()
				end

				if LocalPlayer():HasAccess() then
					if !ply:GetNWBool( "ragdolled", false ) then
						local ragdoll = _menu:AddOption( lang_string( "ragdoll" ), "icon16/user_red.png" )
						function ragdoll:DoClick()
							net.Start( "ragdoll" )
								net.WriteEntity( ply )
							net.SendToServer()
							_menu:Remove()
						end
					else
						local unragdoll = _menu:AddOption( lang_string( "unragdoll" ), "icon16/user_green.png" )
						function unragdoll:DoClick()
							net.Start( "unragdoll" )
								net.WriteEntity( ply )
							net.SendToServer()
							_menu:Remove()
						end
					end
					if !ply:IsFlagSet( FL_FROZEN ) then
						local freeze = _menu:AddOption( lang_string( "freeze" ), "icon16/user_suit.png" )
						function freeze:DoClick()
							net.Start( "freeze" )
								net.WriteEntity( ply )
							net.SendToServer()
							_menu:Remove()
						end
					else
						local unfreeze = _menu:AddOption( lang_string( "unfreeze" ), "icon16/user_gray.png" )
						function unfreeze:DoClick()
							net.Start( "unfreeze" )
								net.WriteEntity( ply )
							net.SendToServer()
							_menu:Remove()
						end
					end
				end

				if LocalPlayer():HasAccess() then
					if !ply:GetNWBool( "godmode", false ) then
						local god = _menu:AddOption( lang_string( "god" ), "icon16/star.png" )
						function god:DoClick()
							net.Start( "god" )
								net.WriteEntity( ply )
							net.SendToServer()
							_menu:Remove()
						end
					else
						local ungod = _menu:AddOption( lang_string( "ungod" ), "icon16/stop.png" )
						function ungod:DoClick()
							net.Start( "ungod" )
								net.WriteEntity( ply )
							net.SendToServer()
							_menu:Remove()
						end
					end
					if !ply:GetNWBool( "cloaked", false ) then
						local cloak = _menu:AddOption( lang_string( "cloak" ), "icon16/status_offline.png" )
						function cloak:DoClick()
							net.Start( "cloak" )
								net.WriteEntity( ply )
							net.SendToServer()
							_menu:Remove()
						end
					else
						local uncloak = _menu:AddOption( lang_string( "uncloak" ), "icon16/status_online.png" )
						function uncloak:DoClick()
							net.Start( "uncloak" )
								net.WriteEntity( ply )
							net.SendToServer()
							_menu:Remove()
						end
					end
					if !ply:GetNWBool( "blinded", false ) then
						local blind = _menu:AddOption( lang_string( "blind" ), "icon16/weather_sun.png" )
						function blind:DoClick()
							net.Start("blind")
								net.WriteEntity( ply )
							net.SendToServer()
							_menu:Remove()
						end
					else
						local unblind = _menu:AddOption( lang_string( "unblind" ), "icon16/weather_clouds.png" )
						function unblind:DoClick()
							net.Start( "unblind" )
								net.WriteEntity( ply )
							net.SendToServer()
							_menu:Remove()
						end
					end
					if !ply:IsOnFire() then
						local ignite = _menu:AddOption( lang_string( "ignite" ), "icon16/fire.png" )
						function ignite:DoClick()
							net.Start("ignite")
								net.WriteEntity( ply )
							net.SendToServer()
							_menu:Remove()
						end
					else
						local extinguish = _menu:AddOption( lang_string( "extinguish" ), "icon16/water.png" )
						function extinguish:DoClick()
							net.Start("extinguish")
								net.WriteEntity( ply )
							net.SendToServer()
							_menu:Remove()
						end
					end

					local slay = _menu:AddOption( lang_string( "slay" ), "icon16/delete.png" )
					function slay:DoClick()
						net.Start( "slay" )
							net.WriteEntity( ply )
						net.SendToServer()
						_menu:Remove()
					end
					local slap = _menu:AddOption( lang_string( "slap" ), "icon16/heart_delete.png" )
					function slap:DoClick()
						net.Start( "slap" )
							net.WriteEntity( ply )
						net.SendToServer()
					end
				end
			end

			elePos.y = elePos.y + 128
		end
	end
	--elePos.y = elePos.y + 10
end

function drawGroup( id, name, color, icon, iter )
	local ply = LocalPlayer()

	elePos.y = elePos.y + 10

	local starty = elePos.y
	local _color = string.Explode( ",", color )
	local _tmpPanel = createD( "DPanel", _SBSP, BScrW() - ctr(400) - ctr( 110 ) - ctr( elePos.x ), 9999, ctr( elePos.x ), ctr( elePos.y ) )
	_tmpPanel.color = Color( _color[1], _color[2], _color[3], 200 )
	function _tmpPanel:Paint(pw, ph)
		draw.RoundedBox( 0, 0, 0, pw, ph, self.color )
		draw.RoundedBox( 0, 0, 0, pw, ctr(50), Color(0,0,0,40) )
		local _x = ctr(10)
		if icon != "" then
			_x = ctr(50)
		end
		draw.SimpleTextOutlined( name, "sef", _x, ctr(25), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
	end

	if icon != "" then
		local ico = createD("DHTML", _tmpPanel, ctr(34), ctr(34), ctr(8), ctr(8))
		ico:SetHTML(GetHTMLImage(icon, ico:GetWide(), ico:GetTall()))
	end

	if hasGroupPlayers( id ) then
		elePos.y = elePos.y + 50
		local _tmpHeader = createD( "DPanel", _SBSP, BScrW() - ctr(400) - ctr( 110 ) - ctr( elePos.x ), ctr( 50 ), ctr( elePos.x ), ctr( elePos.y ) )
		_tmpHeader.color = Color( _color[1], _color[2], _color[3], 200 )
		function _tmpHeader:Paint( pw, ph )
			--draw.RoundedBox( 0, 0, 0, pw, ph, Color(0,0,0,100))
			--draw.SimpleTextOutlined( lang_string( "level" ), "sef", ctr( 10 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

			local _w = ctr( 128+16 )

			local str = lang_string( "name" )
			if ply:GetNWBool( "bool_yrp_scoreboard_show_usergroup", false ) then
				str = lang_string( "name" ) .. "/" .. lang_string( "usergroup" )
			end

			draw.SimpleTextOutlined( str, "sef", _w, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

			str = ""
			if ply:GetNWBool( "bool_yrp_scoreboard_show_rolename", false ) then
				str = lang_string( "role" )
			end
			if ply:GetNWBool( "bool_yrp_scoreboard_show_groupname", false ) then
				if str != "" then
					str = str .. "/"
				end
				str = str .. lang_string( "group" )
			end
			if ply:GetNWBool( "bool_yrp_scoreboard_show_rolename", false ) or ply:GetNWBool( "bool_yrp_scoreboard_show_groupname", false ) then
				_w = _w + ctr( 600 )
				draw.SimpleTextOutlined( str, "sef", _w, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
			end

			str = ""
			if ply:GetNWBool( "bool_yrp_scoreboard_show_frags", false ) then
				str = lang_string( "frags" )
			end
			if ply:GetNWBool( "bool_yrp_scoreboard_show_deaths", false ) then
				if str != "" then
					str = str .. "/"
				end
				str = str .. lang_string( "deaths" )
			end
			if ply:GetNWBool( "bool_yrp_scoreboard_show_frags", false ) or ply:GetNWBool( "bool_yrp_scoreboard_show_deaths", false ) then
				_w = _w + ctr( 600 )
				draw.SimpleTextOutlined( str, "sef", _w, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
			end

			if ply:GetNWBool( "bool_yrp_scoreboard_show_language", false ) then
				_w = _w + ctr( 600 )
				draw.SimpleTextOutlined( "Language", "sef", _w, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
			end

			if ply:GetNWBool( "bool_yrp_scoreboard_show_playtime", false ) then
				_w = _w + ctr( 500 )
				draw.SimpleTextOutlined( lang_string( "playtime" ), "sef", _w, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
			end

			if ply:GetNWBool( "bool_yrp_scoreboard_show_operating_system", false ) then
				draw.SimpleTextOutlined( lang_string( "os" ), "sef", pw - ctr( 150 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
			end

			draw.SimpleTextOutlined( lang_string( "ping" ), "sef", pw - ctr( 20 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
			--draw.SimpleTextOutlined( lang_string( "mute" ), "sef", pw - ctr( 100 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
		end
		elePos.y = elePos.y + 50
		drawGroupPlayers( id )
	end
	_tmpPanel:SetTall(elePos.y - starty)

	return _tmpPanel
end

function hasLowerGroup( id )
	for k, group in pairs( sb_groups ) do
		if tonumber( group.int_parentgroup ) == tonumber( id ) then
			return true
		end
	end
	return false
end

function drawLowerGroup( id, iter )
	for k, group in pairs( sb_groups ) do
		if tonumber( id ) == tonumber( group.uniqueID ) then
			local _tmpGroup = drawGroup( group.uniqueID, group.string_name, group.string_color, group.string_icon, iter )
			return _tmpGroup
		end
	end
end

function tryLowerGroup( id, iter )
	local tab = {}
	if hasLowerGroup( id ) and hasLowerGroupPlayers( id ) then
		elePos.x = elePos.x + 10
		for k, group in pairs( sb_groups ) do
			if tonumber( group.int_parentgroup ) == tonumber( id ) and (hasGroupPlayers(group.uniqueID) or hasLowerGroupPlayers( group.uniqueID )) then
				table.insert(tab, group)
			end
		end
	end
	for k, group in pairs(tab) do
		if k < #tab or #tab == 1 then
			elePos.y = elePos.y + 50
		end
		local tmp = drawLowerGroup( group.uniqueID, iter + 1 )
		tryLowerGroup( group.uniqueID, iter + 1 )
		elePos.y = elePos.y + 10
		local tmpX, tmpY = tmp:GetPos()
		tmp:SetSize( tmp:GetWide(), ctr( elePos.y ) - tmpY )
	end
end

function drawGroupRow( id )
	if hasGroupRowPlayers( id ) then
		for k, group in pairs( sb_groups ) do
			if tonumber( id ) == tonumber( group.uniqueID ) then
				elePos.y = elePos.y + 50
				local tmp = drawGroup( group.uniqueID, group.string_name, group.string_color, group.string_icon, 1 )
				tryLowerGroup( group.uniqueID, 1 )
				elePos.y = elePos.y + 10
				local tmpX, tmpY = tmp:GetPos()
				tmp:SetSize( tmp:GetWide(), ctr( elePos.y ) - tmpY )
			end
		end
	end
end

function drawGroups()
	local first = true
	elePos.y = elePos.y + 50
	for k, group in pairs( sb_groups ) do
		if tonumber( group.int_parentgroup ) == tonumber( 0 ) then
			if hasGroupRowPlayers( group.uniqueID ) then
				elePos.x = ctr( 10 )
				drawGroupRow( group.uniqueID )
				if !first then
					elePos.y = elePos.y + 10
				else
					first = false
				end
			end
		end
	end
end

function drawRest()
	local count = 0
	for k, pl in pairs(player.GetAll()) do
		if pl:GetNWString("groupName", "---") == "---" and pl:GetNWString("roleName", "---") == "---" then
			count = count + 1
		end
	end

	local ply = LocalPlayer()
	if count > 0 then
		elePos.y = elePos.y + 50

		local _tmpHeader = createD( "DPanel", _SBSP, BScrW() - ctr(400) - ctr( 110 ) - ctr( elePos.x ), ctr(200) + count * ctr(50), ctr( elePos.x ), ctr( elePos.y ) )
		_tmpHeader.color = Color(0, 0, 0)
		function _tmpHeader:Paint( pw, ph )
			draw.RoundedBox( 0, 0, 0, pw, ph, self.color )
			draw.SimpleTextOutlined( lang_string( "unassigned" ), "sef", ctr( 10 ), ctr(25), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
		end

		elePos.y = elePos.y + 50

		local _tmpHeader = createD( "DPanel", _SBSP, BScrW() - ctr(400) - ctr( 110 ) - ctr( elePos.x ), ctr( 50 ), ctr( elePos.x ), ctr( elePos.y ) )
		_tmpHeader.color = Color(0, 0, 0)
		function _tmpHeader:Paint( pw, ph )
			--draw.RoundedBox( 0, 0, 0, pw, ph, self.color )
			--draw.SimpleTextOutlined( lang_string( "level" ), "sef", ctr( 10 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

			local _w = ctr( 128+16 )

			local str = lang_string( "name" )
			if ply:GetNWBool( "bool_yrp_scoreboard_show_usergroup", false ) then
				str = lang_string( "name" ) .. "/" .. lang_string( "usergroup" )
			end

			draw.SimpleTextOutlined( str, "sef", _w, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

			str = ""
			if ply:GetNWBool( "bool_yrp_scoreboard_show_frags", false ) then
				str = lang_string( "frags" )
			end
			if ply:GetNWBool( "bool_yrp_scoreboard_show_deaths", false ) then
				if str != "" then
					str = str .. "/"
				end
				str = str .. lang_string( "deaths" )
			end
			if ply:GetNWBool( "bool_yrp_scoreboard_show_frags", false ) or ply:GetNWBool( "bool_yrp_scoreboard_show_deaths", false ) then
				_w = _w + ctr( 600 )
				draw.SimpleTextOutlined( str, "sef", _w, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
			end

			if ply:GetNWBool( "bool_yrp_scoreboard_show_language", false ) then
				_w = _w + ctr( 600 )
				draw.SimpleTextOutlined( "Language", "sef", _w, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
			end

			if ply:GetNWBool( "bool_yrp_scoreboard_show_playtime", false ) then
				_w = _w + ctr( 500 )
				draw.SimpleTextOutlined( lang_string( "playtime" ), "sef", _w, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
			end

			if ply:GetNWBool( "bool_yrp_scoreboard_show_operating_system", false ) then
				draw.SimpleTextOutlined( lang_string( "os" ), "sef", pw - ctr( 150 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
			end

			draw.SimpleTextOutlined( lang_string( "ping" ), "sef", pw - ctr( 20 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
			--draw.SimpleTextOutlined( lang_string( "mute" ), "sef", pw - ctr( 100 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
		end

		elePos.y = elePos.y + 64
		for k, pl in pairs(player.GetAll()) do
			if pl:GetNWString("groupName", "---") == "---" and pl:GetNWString("roleName", "---") == "---" then
				local _tmpPly = createD( "DButton", _SBSP, BScrW() - ctr(400) - ctr( 110 ) - ctr( elePos.x ), ctr( 128 ), ctr( elePos.x ), ctr( elePos.y ) )
				_tmpPly:SetText( "" )
				_tmpPly.gerade = k % 2
				_tmpPly.level = 1
				_tmpPly.rpname = pl:RPName() or ""
				_tmpPly.frags = pl:Frags()
				_tmpPly.deaths = pl:Deaths()
				_tmpPly.rank = pl:GetUserGroup() or ""
				_tmpPly.ping = pl:Ping() or ""
				_tmpPly.usergroup = pl:GetUserGroup() or ""
				_tmpPly.steamname = pl:SteamName() or ""
				_tmpPly.lang = pl:GetLanguageShort() or ""
				_tmpPly.language = pl:GetLanguage() or ""
				_tmpPly.money = pl:GetNWString( "money" )
				_tmpPly.moneybank = pl:GetNWString( "moneybank" )
				_tmpPly.os = pl:GetNWString( "yrp_os", "other" )
				local _pt = string.FormattedTime( pl:GetNWFloat( "uptime_current", 0 ) )
				if _pt.m < 10 then
					_pt.m = "0" .. _pt.m
				end
				if _pt.h < 10 then
					_pt.h = "0" .. _pt.h
				end
				_tmpPly.playtime = _pt.h .. ":" .. _pt.m

				local _tmp_p_ava = createD( "DPanel", _tmpPly, ctr( 128-8 ), ctr( 128-8 ), ctr( 4 ), ctr( 4 ) )
				_tmp_p_ava.Avatar = createD( "AvatarImage", _tmp_p_ava, ctr( 128-8 ), ctr( 128-8 ), 0, 0 )
				_tmp_p_ava.Avatar:SetPlayer( pl, ctr( 128-8 ) )
				_tmp_p_ava.Avatar:SetPaintedManually( true )
				function _tmp_p_ava:Paint( pw, ph )
					render.ClearStencil()
					render.SetStencilEnable( true )

						render.SetStencilWriteMask( 1 )
						render.SetStencilTestMask( 1 )

						render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )

						render.SetStencilFailOperation( STENCILOPERATION_INCR )
						render.SetStencilPassOperation( STENCILOPERATION_KEEP )
						render.SetStencilZFailOperation( STENCILOPERATION_KEEP )

						render.SetStencilReferenceValue( 1 )

						drawRoundedBox( ph/2, 0, 0, pw, ph, Color( 0, 0, 0, 255 ) )

						render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )

						self.Avatar:SetPaintedManually(false)
						self.Avatar:PaintManual()
						self.Avatar:SetPaintedManually(true)

					render.SetStencilEnable( false )
				end

				function _tmpPly:Paint( pw, ph )
					local _extra = 0
					if self.gerade == 0 then
						_extra = 50
					end
					if self:IsHovered() then
						if self.gerade == 1 then
						end
						draw.RoundedBoxEx( ph/2, 0, 0, pw, ph, Color( 255, 255, 0, 200 ), true, false, true, false )
					else
						draw.RoundedBoxEx( ph/2, 0, 0, pw, ph, Color( _extra, _extra, _extra, 200 ), true, false, true, false )
					end

					local _w = ctr( 128+16 )
					local namey = ph/4
					if !pl:GetNWBool( "bool_yrp_scoreboard_show_usergroup", false ) then
						namey = ph/2
					end
					draw.SimpleTextOutlined( self.rpname, "sef", _w, namey, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
					if pl:GetNWBool( "bool_yrp_scoreboard_show_usergroup", false ) then
						draw.SimpleTextOutlined( string.upper( self.rank ), "sef", _w, ph*3/4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
					end

					if pl:GetNWBool( "bool_yrp_scoreboard_show_frags", false ) or pl:GetNWBool( "bool_yrp_scoreboard_show_deaths", false ) then
						_w = _w + ctr( 600 )
					end

					if pl:GetNWBool( "bool_yrp_scoreboard_show_frags", false ) then
						local y = ph / 4
						if !pl:GetNWBool( "bool_yrp_scoreboard_show_deaths", false ) then
							y = ph / 2
						end
						draw.SimpleTextOutlined( self.frags, "sef", _w, y, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
					end
					if pl:GetNWBool( "bool_yrp_scoreboard_show_deaths", false ) then
						local y = ph * 3 / 4
						if !pl:GetNWBool( "bool_yrp_scoreboard_show_frags", false ) then
							y = ph / 2
						end
						draw.SimpleTextOutlined( self.deaths, "sef", _w, y, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
					end

					if pl:GetNWBool( "bool_yrp_scoreboard_show_language", false ) then
						local icon_size = ctr( 100 )
						_w = _w + ctr( 600 )
						DrawIcon( GetDesignIcon( self.lang ), icon_size * 1.49, icon_size, _w, ph / 2 - icon_size / 2, Color( 255, 255, 255, 255 ) )
						if self:IsHovered() then
							draw.SimpleTextOutlined( string.upper(self.lang), "sef", _w + ( icon_size * 1.49 ) / 2, ph / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
						end
					end

					if pl:GetNWBool( "bool_yrp_scoreboard_show_playtime", false ) then
						_w = _w + ctr( 500 )
						draw.SimpleTextOutlined( self.playtime, "sef", _w, ph / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
					end

					if pl:GetNWBool( "bool_yrp_scoreboard_show_operating_system", false ) then
						local icon_size = ctr( 100 )
						DrawIcon( GetDesignIcon( "os_" .. self.os ), icon_size, icon_size, pw - ctr( 150 ) - icon_size, ph/2 - icon_size/2, Color( 255, 255, 255, 255 ) )
					end
					draw.SimpleTextOutlined( self.ping, "sef", pw - ctr( 20 ), ph / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
				end

				function _tmpPly:DoClick()
					local _mx, _my = gui.MousePos()
					local _menu = createD( "DYRPMenu", nil, ctr( 500 ), ctr( 50 ), _mx - ctr( 25 ), _my - ctr( 25 ) )
					_menu:MakePopup()

					local osp = _menu:AddOption( lang_string( "openprofile" ), "icon16/page.png" )
					function osp:DoClick()
						pl:ShowProfile()
					end

					_menu:AddSpacer()

					local csid = _menu:AddOption( lang_string( "copysteamid" ), "icon16/page_copy.png" )
					function csid:DoClick()
						SetClipboardText( pl:SteamID() )
						_menu:Remove()
					end
					local csid64 = _menu:AddOption( lang_string( "copysteamid64" ), "icon16/page_copy.png" )
					function csid64:DoClick()
						SetClipboardText( pl:SteamID64() )
						_menu:Remove()
					end
					local crpname = _menu:AddOption( lang_string( "copyrpname" ), "icon16/page_copy.png" )
					function crpname:DoClick()
						SetClipboardText( pl:RPName() )
						_menu:Remove()
					end
					local csname = _menu:AddOption( lang_string( "copysteamname" ), "icon16/page_copy.png" )
					function csname:DoClick()
						SetClipboardText( pl:SteamName() )
						_menu:Remove()
					end
					_menu:AddSpacer()

					_menu:AddOption( "Language: " .. self.language, "icon16/map.png" )
					_menu:AddSpacer()

					if LocalPlayer():HasAccess() and notself( pl ) then
						local ban = _menu:AddOption( lang_string( "ban" ), "icon16/world_link.png" )
						function ban:DoClick()
							net.Start( "pl_ban" )
								net.WriteEntity( pl )
							net.SendToServer()
						end
						local kick = _menu:AddOption( lang_string( "kick" ), "icon16/world_go.png" )
						function kick:DoClick()
							net.Start( "pl_kick" )
								net.WriteEntity( pl )
							net.SendToServer()
						end
						_menu:AddSpacer()
					end

					if LocalPlayer():HasAccess() and notself( pl ) then
						local tpto = _menu:AddOption( lang_string( "tpto" ), "icon16/arrow_right.png" )
						function tpto:DoClick()
							net.Start( "tp_tpto" )
								net.WriteEntity( pl )
							net.SendToServer()
						end
						local bring = _menu:AddOption( lang_string( "bring" ), "icon16/arrow_redo.png" )
						function bring:DoClick()
							net.Start( "tp_bring" )
								net.WriteEntity( pl )
							net.SendToServer()
						end
					end

					if LocalPlayer():HasAccess() then
						if !pl:GetNWBool( "injail", false ) then
							local jail = _menu:AddOption( lang_string( "jail" ), "icon16/lock_go.png" )
							function jail:DoClick()
								net.Start( "tp_jail" )
									net.WriteEntity( pl )
								net.SendToServer()
								_menu:Remove()
							end
						else
							local unjail = _menu:AddOption( lang_string( "unjail" ), "icon16/lock_open.png" )
							function unjail:DoClick()
								net.Start( "tp_unjail" )
									net.WriteEntity( pl )
								net.SendToServer()
								_menu:Remove()
							end
						end
						_menu:AddSpacer()
					end

					if LocalPlayer():HasAccess() then
						if !pl:GetNWBool( "ragdolled", false ) then
							local ragdoll = _menu:AddOption( lang_string( "ragdoll" ), "icon16/user_red.png" )
							function ragdoll:DoClick()
								net.Start( "ragdoll" )
									net.WriteEntity( pl )
								net.SendToServer()
								_menu:Remove()
							end
						else
							local unragdoll = _menu:AddOption( lang_string( "unragdoll" ), "icon16/user_green.png" )
							function unragdoll:DoClick()
								net.Start( "unragdoll" )
									net.WriteEntity( pl )
								net.SendToServer()
								_menu:Remove()
							end
						end
						if !pl:IsFlagSet( FL_FROZEN ) then
							local freeze = _menu:AddOption( lang_string( "freeze" ), "icon16/user_suit.png" )
							function freeze:DoClick()
								net.Start( "freeze" )
									net.WriteEntity( pl )
								net.SendToServer()
								_menu:Remove()
							end
						else
							local unfreeze = _menu:AddOption( lang_string( "unfreeze" ), "icon16/user_gray.png" )
							function unfreeze:DoClick()
								net.Start( "unfreeze" )
									net.WriteEntity( pl )
								net.SendToServer()
								_menu:Remove()
							end
						end
					end

					if LocalPlayer():HasAccess() then
						if !pl:GetNWBool( "godmode", false ) then
							local god = _menu:AddOption( lang_string( "god" ), "icon16/star.png" )
							function god:DoClick()
								net.Start( "god" )
									net.WriteEntity( pl )
								net.SendToServer()
								_menu:Remove()
							end
						else
							local ungod = _menu:AddOption( lang_string( "ungod" ), "icon16/stop.png" )
							function ungod:DoClick()
								net.Start( "ungod" )
									net.WriteEntity( pl )
								net.SendToServer()
								_menu:Remove()
							end
						end
						if !pl:GetNWBool( "cloaked", false ) then
							local cloak = _menu:AddOption( lang_string( "cloak" ), "icon16/status_offline.png" )
							function cloak:DoClick()
								net.Start( "cloak" )
									net.WriteEntity( pl )
								net.SendToServer()
								_menu:Remove()
							end
						else
							local uncloak = _menu:AddOption( lang_string( "uncloak" ), "icon16/status_online.png" )
							function uncloak:DoClick()
								net.Start( "uncloak" )
									net.WriteEntity( pl )
								net.SendToServer()
								_menu:Remove()
							end
						end
						if !pl:GetNWBool( "blinded", false ) then
							local blind = _menu:AddOption( lang_string( "blind" ), "icon16/weather_sun.png" )
							function blind:DoClick()
								net.Start("blind")
									net.WriteEntity( pl )
								net.SendToServer()
								_menu:Remove()
							end
						else
							local unblind = _menu:AddOption( lang_string( "unblind" ), "icon16/weather_clouds.png" )
							function unblind:DoClick()
								net.Start( "unblind" )
									net.WriteEntity( pl )
								net.SendToServer()
								_menu:Remove()
							end
						end
						if !pl:IsOnFire() then
							local ignite = _menu:AddOption( lang_string( "ignite" ), "icon16/fire.png" )
							function ignite:DoClick()
								net.Start("ignite")
									net.WriteEntity( pl )
								net.SendToServer()
								_menu:Remove()
							end
						else
							local extinguish = _menu:AddOption( lang_string( "extinguish" ), "icon16/water.png" )
							function extinguish:DoClick()
								net.Start("extinguish")
									net.WriteEntity( pl )
								net.SendToServer()
								_menu:Remove()
							end
						end

						local slay = _menu:AddOption( lang_string( "slay" ), "icon16/delete.png" )
						function slay:DoClick()
							net.Start( "slay" )
								net.WriteEntity( pl )
							net.SendToServer()
							_menu:Remove()
						end
						local slap = _menu:AddOption( lang_string( "slap" ), "icon16/heart_delete.png" )
						function slap:DoClick()
							net.Start( "slap" )
								net.WriteEntity( pl )
							net.SendToServer()
						end
					end
				end

				elePos.y = elePos.y + 128
			end
		end
	end
end

function drawScoreboard()
	elePos.x = ctr( 10 )
	elePos.y = -100
	drawGroups()

	elePos.x = ctr( 10 )
	elePos.y = elePos.y + 20
	drawRest()
end

function BScrW()
	--[[ give ScrW() only when under 21:9 ]]--
	if ScrW() > ScrH() / 9 * 16 then
		return ctr( 3840 )
	else
		return ScrW()
	end
end

isScoreboardOpen = false
function scoreboard:show_sb()
	if LocalPlayer():GetNWBool( "bool_yrp_scoreboard", false ) then
		net.Start( "getScoreboardGroups" )
		net.SendToServer()

		isScoreboardOpen = true
		local _w = BScrW() - ctr( 400 )
		if _SBFrame == nil then
			local _w = BScrW() - ctr( 400 )
			_SBFrame = createD( "DFrame", nil, _w, ScrH(), 10, 10 )
			_SBFrame:SetTitle( "" )
			_SBFrame:ShowCloseButton( false )
			_SBFrame:SetDraggable( false )
			_SBFrame:Center()

			_SBFrame:MakePopup()

			local _mapPNG = getMapPNG()

			local _server_logo = LocalPlayer():GetNWString( "text_server_logo", "" )
			text_server_logo = GetHTMLImage( LocalPlayer():GetNWString( "text_server_logo", "" ), ctr( 256 ), ctr( 256 ) )

			function _SBFrame:Paint( pw, ph )
				draw.RoundedBox( 0, ctr( 256 ), ctr( _br ), pw - ctr( 256*2 ), ctr( 125 ), get_color( "epicBlue" ) )

				draw.RoundedBox( 0, ctr( _br ), ctr( 256 - _br ), pw - ctr( _br*2 ), ph, get_color( "darkBG" ) )

				draw.SimpleTextOutlined( GAMEMODE:GetGameDescription() .. " [" .. GetRPBase() .. "]", "ScoreBoardNormal", ctr( 256 + 20 ), ctr( 75 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
				draw.SimpleTextOutlined( GetHostName(), "ScoreBoardTitle", ctr( 256 + 20 ), ctr( 120 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

				draw.SimpleTextOutlined( lang_string( "map" ) .. ": " .. GetNiceMapName(), "ScoreBoardNormal", pw - ctr( 256 + 20 ), ctr( 75 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
				draw.SimpleTextOutlined( lang_string( "players" ) .. ": " .. #player.GetAll() .. "/" .. game.MaxPlayers(), "ScoreBoardNormal", pw - ctr( 256 + 20 ), ctr( 125 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

				if _server_logo == "" then
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( _yrpIcon	)
					surface.DrawTexturedRect( 0, ctr( 4 ), ctr( 256 ), ctr( 256 ) )
				end

				if _mapPNG != false then
					draw.RoundedBox( 0, pw-ctr( 256+8 ), 0, ctr( 256+8 ), ctr( 256+8 ), Color( 0, 0, 0, 255 ) )

					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( _mapPNG	)
					surface.DrawTexturedRect( pw-ctr( 256+4 ), ctr( 4 ), ctr( 256 ), ctr( 256 ) )
				else
					if _server_logo == "" then
						surface.SetDrawColor( 255, 255, 255, 255 )
						surface.SetMaterial( _yrpIcon	)
						surface.DrawTexturedRect( pw-ctr( 256+4 ), ctr( 4 ), ctr( 256 ), ctr( 256 ) )
					end
				end
			end

			if _server_logo != "" then
				local ServerLogo = createD( "DHTML", _SBFrame, ctr( 256 ), ctr( 256 ), 0, ctr( 4 ) )
				ServerLogo:SetHTML( text_server_logo )
				if _mapPNG == false then
					local ServerLogo2 = createD( "DHTML", _SBFrame, ctr( 256 ), ctr( 256 ), _SBFrame:GetWide()-ctr( 256+4 ), ctr( 4 ) )
					ServerLogo2:SetHTML( text_server_logo )
				end
			end

			_SBSP = createD( "DScrollPanel", _SBFrame, _w-ctr( 80 ), ScrH() - ctr( 256+48-50 ) - ctr( 10 ), ctr( 40 ), ctr( 256+48-50+10 ) )

			local _DPanelHeader = createD( "DPanel", _SBSP, ScrH(), ScrH(), 0, 0 )
			function _DPanelHeader:Paint( pw, ph )
				--draw.RoundedBox( 0, 0, 0, pw, ph, get_color( "darkBG" ) )
			end
		end
		drawScoreboard()
	end
end

function scoreboard:hide_sb()
	isScoreboardOpen = false
	if _SBFrame != nil then
		_SBFrame:Remove()
		_SBFrame = nil
		gui.EnableScreenClicker( false )
	end
end

function GM:ScoreboardShow()
	scoreboard:show_sb()
end

function GM:ScoreboardHide()
	if scoreboard != nil then
		 scoreboard:hide_sb()
	 end
end
