--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local _groups = {}
local _roles = {}
net.Receive( "getMapList", function( len )
	local _tmpBool = net.ReadBool()

	local ply = LocalPlayer()

	if !_tmpBool and pa(settingsWindow) then
		local _tmpTable = net.ReadTable()
		_groups = net.ReadTable()
		_roles = net.ReadTable()
		_dealers = net.ReadTable()

		function settingsWindow.window.site:Paint( pw, ph )
			draw.RoundedBox( 4, 0, 0, pw, ph, get_dbg_col() )
		end

		local _mapName = createD( "DPanel", settingsWindow.window.site, BScrW() - ctr( 20 + 256 ), ctr( 256 ), ctr( 10 + 256 ), ctr( 10 ) )
		function _mapName:Paint( pw, ph )
			draw.RoundedBox( 0, 0,0, pw, ph, get_dp_col() )
			draw.SimpleTextOutlined( lang_string( "map" ) .. ": " .. GetMapNameDB(), "sef", ctr( 10 ), ctr( 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
		end

		local _mapPanel = createD( "DPanel", settingsWindow.window.site, ctr( 256 ), ctr( 256 ), ctr( 10 ), ctr( 10 ) )
		local _mapPNG = getMapPNG()
		function _mapPanel:Paint( pw, ph )
			if _mapPNG != false then
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( _mapPNG	)
				surface.DrawTexturedRect( 0, 0, ctr( 256 ), ctr( 256 ) )
			end
		end

		_mapListView = createD( "DListView", settingsWindow.window.site, BScrW() - ctr( 20 + 10 + 700 ), ScrH() - ctr( 180 + 256 + 20 ), ctr( 10 ), ctr( 10 + 256 + 10 ) )
		_mapListView:AddColumn( "uniqueID" )
		_mapListView:AddColumn( lang_string( "position" ) )
		_mapListView:AddColumn( lang_string( "angle" ) )
		_mapListView:AddColumn( lang_string( "type" ) )
		_mapListView:AddColumn( lang_string( "name" ) )

		local _buttonDelete = createD( "DButton", settingsWindow.window.site, ctr( 700 ), ctr( 50 ), BScrW() - ctr( 10 + 700 ), ctr( 10+256+10 ) )
		_buttonDelete:SetText( "" )
		function _buttonDelete:DoClick()
			if _mapListView:GetSelectedLine() != nil then
				net.Start( "removeMapEntry" )
					net.WriteString( _mapListView:GetLine(_mapListView:GetSelectedLine()):GetValue( 1 ) )
				net.SendToServer()
				_mapListView:RemoveLine(	_mapListView:GetSelectedLine() )
			end
		end
		function _buttonDelete:Paint( pw, ph )
			if _mapListView:GetSelectedLine() != nil then
				surfaceButton( self, pw, ph, lang_string( "deleteentry" ), Color( 255, 0, 0 ) )
			end
		end

		local _buttonTeleport = createD( "DButton", settingsWindow.window.site, ctr( 700 ), ctr( 50 ), BScrW() - ctr( 10 + 700 ), ctr( 336 ) )
		_buttonTeleport:SetText( "" )
		function _buttonTeleport:DoClick()
			if _mapListView:GetSelectedLine() != nil then
				net.Start( "teleportto" )
					net.WriteString( _mapListView:GetLine(_mapListView:GetSelectedLine()):GetValue( 1 ) )
				net.SendToServer()
				settingsWindow.window:Remove()
			end
		end
		function _buttonTeleport:Paint( pw, ph )
			if _mapListView:GetSelectedLine() != nil then
				surfaceButton( self, pw, ph, lang_string( "tpto" ) )
			end
		end

		local _buttonAddGroupSpawnPoint = createD( "DButton", settingsWindow.window.site, ctr( 700 ), ctr( 50 ), BScrW() - ctr( 10 + 700 ), ctr( 396 ) )
		_buttonAddGroupSpawnPoint:SetText( "" )
		function _buttonAddGroupSpawnPoint:DoClick()
			local tmpFrame = createD( "DFrame", nil, ctr( 1200 ), ctr( 290 ), 0, 0 )
			tmpFrame:Center()
			tmpFrame:SetTitle( "" )
			function tmpFrame:Paint( pw, ph )
				draw.RoundedBox( 0, 0,0, pw, ph, get_dbg_col() )
				draw.SimpleTextOutlined( lang_string( "groupspawnpointcreator" ), "sef", ctr( 10 ), ctr( 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
				draw.SimpleTextOutlined( lang_string( "creategroupspawnpoint" ), "sef", ctr( 10 ), ctr( 60 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
				draw.SimpleTextOutlined( lang_string( "selectgroup" ) .. ":", "sef", ctr( 10 ), ctr( 110 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
			end

			local tmpGroup = createD( "DComboBox", tmpFrame, ctr( 400 ), ctr( 50 ), ctr( 10 ), ctr( 170 ) )
			for k, v in pairs( _groups ) do
				tmpGroup:AddChoice( v.string_name, v.uniqueID )
			end

			local tmpButton = createD( "DButton", tmpFrame, ctr( 400 ), ctr( 50 ), ctr( 600-200 ), ctr( 230 ) )
			tmpButton:SetText( lang_string( "add" ) )
			function tmpButton:DoClick()
				local tmpPos = string.Explode( " ", tostring( ply:GetPos() ) )
				local tmpAng = string.Explode( " ", tostring( ply:GetAngles() ) )
				local tmpGroupID = tostring( tmpGroup:GetOptionData( tmpGroup:GetSelectedID() ) )
				if tmpGroupID != nil then
					net.Start( "dbInsertIntoMap" )
						net.WriteString( "yrp_" .. GetMapNameDB() )
						net.WriteString( "position, angle, linkID, type" )
						local tmpString = "'" .. tonumber( tmpPos[1] ) .. "," .. tonumber( tmpPos[2] ) .. "," .. tonumber( tmpPos[3] + 4 ) .. "', '" .. tonumber( tmpAng[1] ) .. "," .. tonumber( tmpAng[2] ) .. "," .. tonumber( tmpAng[3] ) .. "', " .. tostring( tmpGroupID ) .. ", 'GroupSpawnpoint'"
						net.WriteString( tmpString )
					net.SendToServer()
				end

				_mapListView:Clear()
				net.Start( "getMapList" )
				net.SendToServer()
				tmpFrame:Close()
			end

			tmpFrame:MakePopup()
		end
		function _buttonAddGroupSpawnPoint:Paint( pw, ph )
			surfaceButton( self, pw, ph, lang_string( "addgroupspawnpoint" ) )
		end

		local _buttonAddRoleSpawnPoint = createD( "DButton", settingsWindow.window.site, ctr( 700 ), ctr( 50 ), BScrW() - ctr( 10 + 700 ), ctr( 456 ) )
		_buttonAddRoleSpawnPoint:SetText( "" )
		function _buttonAddRoleSpawnPoint:DoClick()
			local tmpFrame = createD( "DFrame", nil, ctr( 1200 ), ctr( 290 ), 0, 0 )
			tmpFrame:Center()
			tmpFrame:SetTitle( "" )
			function tmpFrame:Paint( pw, ph )
				draw.RoundedBox( 0, 0,0, pw, ph, get_dbg_col() )
				draw.SimpleTextOutlined( lang_string( "rolespawnpointcreator" ), "sef", ctr( 10 ), ctr( 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
				draw.SimpleTextOutlined( lang_string( "createrolespawnpoint" ), "sef", ctr( 10 ), ctr( 60 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
				draw.SimpleTextOutlined( lang_string( "selectrole" ) .. ":", "sef", ctr( 10 ), ctr( 110 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
			end

			local tmpRole = createD( "DComboBox", tmpFrame, ctr( 400 ), ctr( 50 ), ctr( 10 ), ctr( 170 ) )
			for k, v in pairs( _roles ) do
				for l, w in pairs( _groups ) do
					if tonumber( v.groupID ) == tonumber( w.uniqueID ) then
						tmpRole:AddChoice( "[" .. w.string_name .. "] " .. v.roleID, v.uniqueID )
						break
					end
				end
			end

			local tmpButton = createD( "DButton", tmpFrame, ctr( 400 ), ctr( 50 ), ctr( 600-200 ), ctr( 230 ) )
			tmpButton:SetText( lang_string( "add" ) )
			function tmpButton:DoClick()
				local tmpRoleID = tostring( tmpRole:GetOptionData( tmpRole:GetSelectedID() ) )
				if tmpRoleID != nil then
					net.Start( "dbInsertIntoMap" )
						net.WriteString( "yrp_" .. GetMapNameDB() )
						net.WriteString( "position, angle, linkID, type" )
						local tmpPos = string.Explode( " ", tostring( ply:GetPos() ) )
						local tmpAng = string.Explode( " ", tostring( ply:GetAngles() ) )
						local tmpString = "'" .. tonumber( tmpPos[1] ) .. "," .. tonumber( tmpPos[2] ) .. "," .. tonumber( tmpPos[3] + 4 ) .. "', '" .. tonumber( tmpAng[1] ) .. "," .. tonumber( tmpAng[2] ) .. "," .. tonumber( tmpAng[3] ) .. "', " .. tmpRoleID .. ", 'RoleSpawnpoint'"
						net.WriteString( tmpString )
					net.SendToServer()

					_mapListView:Clear()
					net.Start( "getMapList" )
					net.SendToServer()
					tmpFrame:Close()
				end
			end

			tmpFrame:MakePopup()
		end
		function _buttonAddRoleSpawnPoint:Paint( pw, ph )
			surfaceButton( self, pw, ph, lang_string( "addrolespawnpoint" ) )
		end

		local _buttonAddJailPoint = createD( "DButton", settingsWindow.window.site, ctr( 700 ), ctr( 50 ), BScrW() - ctr( 10 + 700 ), ctr( 516 ) )
		_buttonAddJailPoint:SetText( "" )
		function _buttonAddJailPoint:DoClick()
			net.Start( "dbInsertIntoMap" )
				net.WriteString( "yrp_" .. GetMapNameDB() )
				net.WriteString( "position, angle, type" )
				local tmpPos = string.Explode( " ", tostring( ply:GetPos() ) )
				local tmpAng = string.Explode( " ", tostring( ply:GetAngles() ) )
				local tmpString = "'" .. tonumber( tmpPos[1] ) .. "," .. tonumber( tmpPos[2] ) .. "," .. tonumber( tmpPos[3] + 4 ) .. "', '" .. tonumber( tmpAng[1] ) .. "," .. tonumber( tmpAng[2] ) .. "," .. tonumber( tmpAng[3] ) .. "', 'jailpoint'"
				net.WriteString( tmpString )
			net.SendToServer()

			_mapListView:Clear()
			net.Start( "getMapList" )
			net.SendToServer()
		end
		function _buttonAddJailPoint:Paint( pw, ph )
			surfaceButton( self, pw, ph, lang_string( "addjailpoint" ) )
		end

		local _buttonAddReleasePoint = createD( "DButton", settingsWindow.window.site, ctr( 700 ), ctr( 50 ), BScrW() - ctr( 10 + 700 ), ctr( 576 ) )
		_buttonAddReleasePoint:SetText( "" )
		function _buttonAddReleasePoint:DoClick()
			net.Start( "dbInsertIntoMap" )
				net.WriteString( "yrp_" .. GetMapNameDB() )
				net.WriteString( "position, angle, type" )
				local tmpPos = string.Explode( " ", tostring( ply:GetPos() ) )
				local tmpAng = string.Explode( " ", tostring( ply:GetAngles() ) )
				local tmpString = "'" .. tonumber( tmpPos[1] ) .. "," .. tonumber( tmpPos[2] ) .. "," .. tonumber( tmpPos[3] + 4 ) .. "', '" .. tonumber( tmpAng[1] ) .. "," .. tonumber( tmpAng[2] ) .. "," .. tonumber( tmpAng[3] ) .. "', 'releasepoint'"
				net.WriteString( tmpString )
			net.SendToServer()

			_mapListView:Clear()
			net.Start( "getMapList" )
			net.SendToServer()
		end
		function _buttonAddReleasePoint:Paint( pw, ph )
			surfaceButton( self, pw, ph, lang_string( "addjailfreepoint" ) )
		end

		local _buttonAddDealer = createD( "DButton", settingsWindow.window.site, ctr( 700 ), ctr( 50 ), BScrW() - ctr( 10 + 700 ), ctr( 636 ) )
		_buttonAddDealer:SetText( "" )
		function _buttonAddDealer:DoClick()
			net.Start( "dealer_add" )
			net.SendToServer()

			_mapListView:Clear()
			net.Start( "getMapList" )
			net.SendToServer()
		end
		function _buttonAddDealer:Paint( pw, ph )
			surfaceButton( self, pw, ph, lang_string( "add" ) .. " [" .. lang_string( "dealer" ) .. "]" )
		end

		local _buttonAddStoragepoint = createD( "DButton", settingsWindow.window.site, ctr( 700 ), ctr( 50 ), BScrW() - ctr( 10 + 700 ), ctr( 696 ) )
		_buttonAddStoragepoint:SetText( "" )
		function _buttonAddStoragepoint:DoClick()
			local tmpFrame = createD( "DFrame", nil, ctr( 1200 ), ctr( 290 ), 0, 0 )
			tmpFrame:Center()
			tmpFrame:SetTitle( "" )
			function tmpFrame:Paint( pw, ph )
				draw.RoundedBox( 0, 0,0, pw, ph, get_dbg_col() )
				draw.SimpleTextOutlined( lang_string( "storagepoint" ), "sef", ctr( 10 ), ctr( 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
				draw.SimpleTextOutlined( lang_string( "name" ) .. ":", "sef", ctr( 10 ), ctr( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
			end

			local tmpName = createD( "DTextEntry", tmpFrame, ctr( 400 ), ctr( 50 ), ctr( 10 ), ctr( 100 ) )

			local tmpButton = createD( "DButton", tmpFrame, ctr( 400 ), ctr( 50 ), ctr( 600-200 ), ctr( 230 ) )
			tmpButton:SetText( lang_string( "add" ) )
			function tmpButton:DoClick()
				net.Start( "dbInsertIntoMap" )
					net.WriteString( "yrp_" .. GetMapNameDB() )
					net.WriteString( "position, angle, name, type" )
					local tmpPos = string.Explode( " ", tostring( ply:GetPos() ) )
					local tmpAng = string.Explode( " ", tostring( ply:GetAngles() ) )
					local tmpString = "'" .. tonumber( tmpPos[1] ) .. "," .. tonumber( tmpPos[2] ) .. "," .. tonumber( tmpPos[3] + 4 ) .. "', '" .. tonumber( tmpAng[1] ) .. "," .. tonumber( tmpAng[2] ) .. "," .. tonumber( tmpAng[3] ) .. "', '" .. tmpName:GetText() .. "', 'Storagepoint'"
					net.WriteString( tmpString )
				net.SendToServer()

				_mapListView:Clear()
				net.Start( "getMapList" )
				net.SendToServer()
				tmpFrame:Close()
			end

			tmpFrame:MakePopup()
		end
		function _buttonAddStoragepoint:Paint( pw, ph )
			surfaceButton( self, pw, ph, lang_string( "add" ) .. " [" .. lang_string( "storagepoint" ) .. "]" )
		end

		for k, v in pairs( _tmpTable ) do
			if tostring( v.type ) == "dealer" then
				for i, dealer in pairs( _dealers ) do
					if tonumber( dealer.uniqueID ) == tonumber( v.linkID ) then
						if pa( _mapListView ) then
							_mapListView:AddLine(v.uniqueID, v.position, v.angle, v.type, dealer.name)
						end
						break
					end
				end
			elseif tostring( v.type ) == "GroupSpawnpoint" then
				for l, w in pairs( _groups ) do
					if tostring( v.linkID ) == tostring( w.uniqueID ) then
						if pa( _mapListView ) then
							_mapListView:AddLine( v.uniqueID, v.position, v.angle, v.type, w.groupID )
						end
						break
					end
				end
			elseif tostring( v.type ) == "RoleSpawnpoint" then
				for l, w in pairs( _roles ) do
					if tostring( v.linkID ) == tostring( w.uniqueID ) then
						if pa( _mapListView ) then
							_mapListView:AddLine( v.uniqueID, v.position, v.angle, v.type, w.roleID )
						end
						break
					end
				end
			else
				if pa( _mapListView ) then
					_mapListView:AddLine( v.uniqueID, v.position, v.angle, v.type, v.name )
				end
			end
		end
	end
end)

function mapPNG()
	local _mapName = GetMapNameDB()
	local _map_png = _mapName .. ".png"

	local _mapPNG = Material( "../maps/no_image.png", "noclamp smooth" )

	local _pre = "../"
	local _maps = "maps/"
	local _data = "data/maps/"
	local _mapthumb = "maps/thumb/"

	if file.Exists( _maps .. _map_png, "GAME" ) then
		_mapPNG = Material( _pre .. _maps .. _map_png, "noclamp smooth" )
		return _mapPNG
	elseif file.Exists( _data .. _map_png, "GAME" ) then
		_mapPNG = Material( _pre .. _data .. _map_png, "noclamp smooth" )
		return _mapPNG
	elseif file.Exists( _mapthumb .. _map_png, "GAME" ) then
		_mapPNG = Material( _pre .. _mapthumb .. _map_png, "noclamp smooth" )
		return _mapPNG
	end
	return false
end

function getMapPNG()
	local _mapPNG = mapPNG()
	if tostring( _mapPNG ) == "Material [___error]" then
		return false
	end
	return _mapPNG
end

function getCopyMapPNG()
	local _mapName = GetMapNameDB()
	local _mapPicturePath = "maps/" .. _mapName .. ".png"
	local _mapPictureDesti = _mapPicturePath

	local _mapPNG = Material( "../maps/no_image.png", "noclamp smooth" )
	if file.Exists( _mapPicturePath, "GAME" ) then
		if !file.Exists( "maps", "DATA" ) then
			file.CreateDir( "maps" )
		end
		file.Write( _mapPicturePath, file.Read( _mapPicturePath, "GAME" ) )
		if file.Exists( _mapPicturePath, "DATA" ) then
			_mapPNG =	Material( "../data/" .. _mapPicturePath, "noclamp smooth" )
		end
	else
		_mapPicturePath = "maps/thumb/" .. _mapName .. ".png"
		if file.Exists( _mapPicturePath, "GAME" ) then
			if !file.Exists( "maps", "DATA" ) then
				file.CreateDir( "maps" )
			end
			file.Write( _mapPictureDesti, file.Read( _mapPicturePath, "GAME" ) )
			if file.Exists( _mapPictureDesti, "DATA" ) then
				_mapPNG = Material( "../data/" .. _mapPictureDesti, "noclamp smooth" )
			end
		end
	end
	return _mapPNG
end

hook.Add( "open_server_map", "open_server_map", function()
	SaveLastSite()

	local w = settingsWindow.window.sitepanel:GetWide()
	local h = settingsWindow.window.sitepanel:GetTall()

	settingsWindow.window.site = createD( "DPanel", settingsWindow.window.sitepanel, w, h, 0, 0 )

	net.Start( "getMapList" )
	net.SendToServer()
end)
