--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local _groups = {}
local _roles = {}
net.Receive("getMapList", function(len)
	if wk(settingsWindow.window) then
		if len > 512000 then
			printGM("note", "getMapList - len: " .. len .. "/" .. "512000 (len is to big)")
		else
			printGM("gm", "getMapList - len: " .. len .. "/" .. "512000")
		end
		local ply = LocalPlayer()
		if pa(settingsWindow.window) then
			local _tmpTable = net.ReadTable()
			_dealers = net.ReadTable()

			function settingsWindow.window.site:Paint(pw, ph)
				draw.RoundedBox(4, 0, 0, pw, ph, get_dbg_col())
			end

			local _mapName = createD("DPanel", settingsWindow.window.site, ScW() - YRP.ctr(20 + 256), YRP.ctr(256), YRP.ctr(10 + 256), YRP.ctr(10))
			function _mapName:Paint(pw, ph)
				draw.RoundedBox(0, 0,0, pw, ph, get_dp_col())
				draw.SimpleTextOutlined(YRP.lang_string("LID_map") .. ": " .. GetMapNameDB(), "sef", YRP.ctr(10), YRP.ctr(10), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
			end

			local _mapPanel = createD("DPanel", settingsWindow.window.site, YRP.ctr(256), YRP.ctr(256), YRP.ctr(10), YRP.ctr(10))
			local _mapPNG = getMapPNG()
			function _mapPanel:Paint(pw, ph)
				if _mapPNG != false then
					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetMaterial(_mapPNG	)
					surface.DrawTexturedRect(0, 0, YRP.ctr(256), YRP.ctr(256))
				end
			end

			_mapListView = createD("DListView", settingsWindow.window.site, ScW() - YRP.ctr(20 + 10 + 700), ScrH() - YRP.ctr(180 + 256 + 20), YRP.ctr(10), YRP.ctr(10 + 256 + 10))
			_mapListView:AddColumn("uniqueID")
			_mapListView:AddColumn(YRP.lang_string("LID_position"))
			_mapListView:AddColumn(YRP.lang_string("LID_angle"))
			_mapListView:AddColumn(YRP.lang_string("LID_type"))
			_mapListView:AddColumn(YRP.lang_string("LID_name"))

			local _buttonDelete = createD("YButton", settingsWindow.window.site, YRP.ctr(700), YRP.ctr(50), ScW() - YRP.ctr(10 + 700), YRP.ctr(10+256+10))
			_buttonDelete:SetText(YRP.lang_string("LID_deleteentry"))
			function _buttonDelete:DoClick()
				if _mapListView:GetSelectedLine() != nil then
					net.Start("removeMapEntry")
						net.WriteString(_mapListView:GetLine(_mapListView:GetSelectedLine()):GetValue(1))
					net.SendToServer()
					_mapListView:RemoveLine(	_mapListView:GetSelectedLine())
				end
			end
			function _buttonDelete:Paint(pw, ph)
				if _mapListView:GetSelectedLine() != nil then
					hook.Run("YButtonPaint", self, pw, ph)
				end
			end

			local _buttonTeleport = createD("YButton", settingsWindow.window.site, YRP.ctr(700), YRP.ctr(50), ScW() - YRP.ctr(10 + 700), YRP.ctr(336))
			_buttonTeleport:SetText(YRP.lang_string("LID_tpto"))
			function _buttonTeleport:DoClick()
				if _mapListView:GetSelectedLine() != nil then
					net.Start("teleportto")
						net.WriteString(_mapListView:GetLine(_mapListView:GetSelectedLine()):GetValue(1))
					net.SendToServer()
					settingsWindow.window:Remove()
				end
			end
			function _buttonTeleport:Paint(pw, ph)
				if _mapListView:GetSelectedLine() != nil then
					hook.Run("YButtonPaint", self, pw, ph)
				end
			end

			local _buttonAddGroupSpawnPoint = createD("YButton", settingsWindow.window.site, YRP.ctr(700), YRP.ctr(50), ScW() - YRP.ctr(10 + 700), YRP.ctr(396))
			_buttonAddGroupSpawnPoint:SetText(YRP.lang_string("LID_addgroupspawnpoint"))
			function _buttonAddGroupSpawnPoint:DoClick()
				local tmpFrame = createD("DFrame", nil, YRP.ctr(1200), YRP.ctr(290), 0, 0)
				tmpFrame:Center()
				tmpFrame:SetTitle("")
				function tmpFrame:Paint(pw, ph)
					draw.RoundedBox(0, 0,0, pw, ph, get_dbg_col())
					draw.SimpleTextOutlined(YRP.lang_string("LID_selectgroup") .. ":", "sef", YRP.ctr(10), YRP.ctr(110), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
				end

				local tmpGroup = createD("DComboBox", tmpFrame, YRP.ctr(400), YRP.ctr(50), YRP.ctr(10), YRP.ctr(170))
				for k, v in pairs(_groups) do
					tmpGroup:AddChoice(v.string_name, v.uniqueID)
				end

				local tmpButton = createD("YButton", tmpFrame, YRP.ctr(400), YRP.ctr(50), YRP.ctr(600-200), YRP.ctr(230))
				tmpButton:SetText(YRP.lang_string("LID_add"))
				function tmpButton:DoClick()
					local tmpPos = string.Explode(" ", tostring(ply:GetPos()))
					local tmpAng = string.Explode(" ", tostring(ply:GetAngles()))
					local tmpGroupID = tmpGroup:GetOptionData(tmpGroup:GetSelectedID())
					if tmpGroupID != nil then
						net.Start("dbInsertIntoMap")
							net.WriteString("yrp_" .. GetMapNameDB())
							net.WriteString("position, angle, linkID, type")
							local tmpString = "'" .. tonumber(tmpPos[1]) .. "," .. tonumber(tmpPos[2]) .. "," .. tonumber(tmpPos[3] + 4) .. "', '" .. tonumber(tmpAng[1]) .. "," .. tonumber(tmpAng[2]) .. "," .. tonumber(tmpAng[3]) .. "', " .. tostring(tmpGroupID) .. ", 'GroupSpawnpoint'"
							net.WriteString(tmpString)
						net.SendToServer()
					end

					_mapListView:Clear()
					net.Start("getMapList")
					net.SendToServer()
					tmpFrame:Close()
				end
				function tmpButton:Paint(pw, ph)
					hook.Run("YButtonPaint", self, pw, ph)
				end

				tmpFrame:MakePopup()
			end
			function _buttonAddGroupSpawnPoint:Paint(pw, ph)
				hook.Run("YButtonPaint", self, pw, ph)
			end

			local _buttonAddRoleSpawnPoint = createD("YButton", settingsWindow.window.site, YRP.ctr(700), YRP.ctr(50), ScW() - YRP.ctr(10 + 700), YRP.ctr(456))
			_buttonAddRoleSpawnPoint:SetText(YRP.lang_string("LID_addrolespawnpoint"))
			function _buttonAddRoleSpawnPoint:DoClick()
				local tmpFrame = createD("YFrame", nil, YRP.ctr(1200), YRP.ctr(290), 0, 0)
				tmpFrame:Center()
				tmpFrame:SetTitle("")
				function tmpFrame:Paint(pw, ph)
					draw.RoundedBox(0, 0,0, pw, ph, get_dbg_col())
					draw.SimpleTextOutlined(YRP.lang_string("LID_selectrole") .. ":", "sef", YRP.ctr(10), YRP.ctr(110), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
				end

				local tmpRole = createD("DComboBox", tmpFrame, YRP.ctr(400), YRP.ctr(50), YRP.ctr(10), YRP.ctr(170))
				for k, v in pairs(_roles) do
					for l, w in pairs(_groups) do
						if tonumber(v.int_groupID) == tonumber(w.uniqueID) then
							tmpRole:AddChoice("[" .. w.string_name .. "] " .. v.string_name, v.uniqueID)
							break
						end
					end
				end

				local tmpButton = createD("YButton", tmpFrame, YRP.ctr(400), YRP.ctr(50), YRP.ctr(600-200), YRP.ctr(230))
				tmpButton:SetText(YRP.lang_string("LID_add"))
				function tmpButton:DoClick()
					local tmpRoleID = tmpRole:GetOptionData(tmpRole:GetSelectedID())
					if tmpRoleID != nil then
						net.Start("dbInsertIntoMap")
							net.WriteString("yrp_" .. GetMapNameDB())
							net.WriteString("position, angle, linkID, type")
							local tmpPos = string.Explode(" ", tostring(ply:GetPos()))
							local tmpAng = string.Explode(" ", tostring(ply:GetAngles()))
							local tmpString = "'" .. tonumber(tmpPos[1]) .. "," .. tonumber(tmpPos[2]) .. "," .. tonumber(tmpPos[3] + 4) .. "', '" .. tonumber(tmpAng[1]) .. "," .. tonumber(tmpAng[2]) .. "," .. tonumber(tmpAng[3]) .. "', " .. tmpRoleID .. ", 'RoleSpawnpoint'"
							net.WriteString(tmpString)
						net.SendToServer()

						_mapListView:Clear()
						net.Start("getMapList")
						net.SendToServer()
						tmpFrame:Close()
					end
				end
				function tmpButton:Paint(pw, ph)
					hook.Run("YButtonPaint", self, pw, ph)
				end

				tmpFrame:MakePopup()
			end
			function _buttonAddRoleSpawnPoint:Paint(pw, ph)
				hook.Run("YButtonPaint", self, pw, ph)
			end

			local _buttonAddJailPoint = createD("YButton", settingsWindow.window.site, YRP.ctr(700), YRP.ctr(50), ScW() - YRP.ctr(10 + 700), YRP.ctr(516))
			_buttonAddJailPoint:SetText(YRP.lang_string("LID_addjailpoint"))
			function _buttonAddJailPoint:DoClick()
				net.Start("dbInsertIntoMap")
					net.WriteString("yrp_" .. GetMapNameDB())
					net.WriteString("position, angle, type")
					local tmpPos = string.Explode(" ", tostring(ply:GetPos()))
					local tmpAng = string.Explode(" ", tostring(ply:GetAngles()))
					local tmpString = "'" .. tonumber(tmpPos[1]) .. "," .. tonumber(tmpPos[2]) .. "," .. tonumber(tmpPos[3] + 4) .. "', '" .. tonumber(tmpAng[1]) .. "," .. tonumber(tmpAng[2]) .. "," .. tonumber(tmpAng[3]) .. "', 'jailpoint'"
					net.WriteString(tmpString)
				net.SendToServer()

				_mapListView:Clear()
				net.Start("getMapList")
				net.SendToServer()
			end
			function _buttonAddJailPoint:Paint(pw, ph)
				hook.Run("YButtonPaint", self, pw, ph)
			end

			local _buttonAddReleasePoint = createD("YButton", settingsWindow.window.site, YRP.ctr(700), YRP.ctr(50), ScW() - YRP.ctr(10 + 700), YRP.ctr(576))
			_buttonAddReleasePoint:SetText("LID_addjailreleasepoint")
			function _buttonAddReleasePoint:DoClick()
				net.Start("dbInsertIntoMap")
					net.WriteString("yrp_" .. GetMapNameDB())
					net.WriteString("position, angle, type")
					local tmpPos = string.Explode(" ", tostring(ply:GetPos()))
					local tmpAng = string.Explode(" ", tostring(ply:GetAngles()))
					local tmpString = "'" .. tonumber(tmpPos[1]) .. "," .. tonumber(tmpPos[2]) .. "," .. tonumber(tmpPos[3] + 4) .. "', '" .. tonumber(tmpAng[1]) .. "," .. tonumber(tmpAng[2]) .. "," .. tonumber(tmpAng[3]) .. "', 'releasepoint'"
					net.WriteString(tmpString)
				net.SendToServer()

				_mapListView:Clear()
				net.Start("getMapList")
				net.SendToServer()
			end
			function _buttonAddReleasePoint:Paint(pw, ph)
				hook.Run("YButtonPaint", self, pw, ph)
			end

			local _buttonAddDealer = createD("YButton", settingsWindow.window.site, YRP.ctr(700), YRP.ctr(50), ScW() - YRP.ctr(10 + 700), YRP.ctr(636))
			_buttonAddDealer:SetText(YRP.lang_string("LID_add") .. " [" .. YRP.lang_string("LID_dealer") .. "]")
			function _buttonAddDealer:DoClick()
				net.Start("dealer_add")
				net.SendToServer()

				_mapListView:Clear()
				net.Start("getMapList")
				net.SendToServer()
			end
			function _buttonAddDealer:Paint(pw, ph)
				hook.Run("YButtonPaint", self, pw, ph)
			end

			local _buttonAddStoragepoint = createD("YButton", settingsWindow.window.site, YRP.ctr(700), YRP.ctr(50), ScW() - YRP.ctr(10 + 700), YRP.ctr(696))
			_buttonAddStoragepoint:SetText(YRP.lang_string("LID_add") .. " [" .. YRP.lang_string("LID_storagepoint") .. "]")
			function _buttonAddStoragepoint:DoClick()
				local tmpFrame = createD("DFrame", nil, YRP.ctr(1200), YRP.ctr(290), 0, 0)
				tmpFrame:Center()
				tmpFrame:SetTitle("")
				function tmpFrame:Paint(pw, ph)
					draw.RoundedBox(0, 0,0, pw, ph, get_dbg_col())
					draw.SimpleTextOutlined(YRP.lang_string("LID_storagepoint"), "sef", YRP.ctr(10), YRP.ctr(10), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
					draw.SimpleTextOutlined(YRP.lang_string("LID_name") .. ":", "sef", YRP.ctr(10), YRP.ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
				end

				local tmpName = createD("DTextEntry", tmpFrame, YRP.ctr(400), YRP.ctr(50), YRP.ctr(10), YRP.ctr(100))

				local tmpButton = createD("YButton", tmpFrame, YRP.ctr(400), YRP.ctr(50), YRP.ctr(600-200), YRP.ctr(230))
				tmpButton:SetText(YRP.lang_string("LID_add"))
				function tmpButton:DoClick()
					net.Start("dbInsertIntoMap")
						net.WriteString("yrp_" .. GetMapNameDB())
						net.WriteString("position, angle, name, type")
						local tmpPos = string.Explode(" ", tostring(ply:GetPos()))
						local tmpAng = string.Explode(" ", tostring(ply:GetAngles()))
						local tmpString = "'" .. tonumber(tmpPos[1]) .. "," .. tonumber(tmpPos[2]) .. "," .. tonumber(tmpPos[3] + 4) .. "', '" .. tonumber(tmpAng[1]) .. "," .. tonumber(tmpAng[2]) .. "," .. tonumber(tmpAng[3]) .. "', '" .. tmpName:GetText() .. "', 'Storagepoint'"
						net.WriteString(tmpString)
					net.SendToServer()

					_mapListView:Clear()
					net.Start("getMapList")
					net.SendToServer()
					tmpFrame:Close()
				end
				function tmpButton:Paint(pw, ph)
					hook.Run("YButtonPaint", self, pw, ph)
				end

				tmpFrame:MakePopup()
			end
			function _buttonAddStoragepoint:Paint(pw, ph)
				hook.Run("YButtonPaint", self, pw, ph)
			end

			for k, v in pairs(_tmpTable) do
				local found = false
				if tostring(v.type) == "dealer" then
					for i, dealer in pairs(_dealers) do
						if tonumber(dealer.uniqueID) == tonumber(v.linkID) then
							if pa(_mapListView) then
								_mapListView:AddLine(v.uniqueID, v.position, v.angle, v.type, dealer.name)
								found = true
							end
							break
						end
					end
				elseif tostring(v.type) == "GroupSpawnpoint" then
					for l, w in pairs(_groups) do
						if tostring(v.linkID) == tostring(w.uniqueID) then
							if pa(_mapListView) then
								_mapListView:AddLine(v.uniqueID, v.position, v.angle, v.type, w.string_name)
								found = true
							end
							break
						end
					end
				elseif tostring(v.type) == "RoleSpawnpoint" then
					for l, w in pairs(_roles) do
						if tostring(v.linkID) == tostring(w.uniqueID) then
							if pa(_mapListView) then
								_mapListView:AddLine(v.uniqueID, v.position, v.angle, v.type, w.string_name)
								found = true
							end
							break
						end
					end
				end
				if !found and pa(_mapListView) then
					if v.type != "Storagepoint" then
						_mapListView:AddLine(v.uniqueID, v.position, v.angle, v.type, "[NOT FOUND] " .. v.name)
					else
						_mapListView:AddLine(v.uniqueID, v.position, v.angle, v.type, v.name)
					end
				end
			end
		end
	end
end)

function mapPNG()
	local _mapName = GetMapNameDB()
	local _map_png = _mapName .. ".png"

	local _mapPNG = Material("../maps/no_image.png", "noclamp smooth")

	local _pre = "../"
	local _maps = "maps/"
	local _data = "data/maps/"
	local _mapthumb = "maps/thumb/"

	if file.Exists(_maps .. _map_png, "GAME") then
		_mapPNG = Material(_pre .. _maps .. _map_png, "noclamp smooth")
		return _mapPNG
	elseif file.Exists(_data .. _map_png, "GAME") then
		_mapPNG = Material(_pre .. _data .. _map_png, "noclamp smooth")
		return _mapPNG
	elseif file.Exists(_mapthumb .. _map_png, "GAME") then
		_mapPNG = Material(_pre .. _mapthumb .. _map_png, "noclamp smooth")
		return _mapPNG
	end
	return false
end

function getMapPNG()
	local _mapPNG = mapPNG()
	if tostring(_mapPNG) == "Material [___error]" then
		return false
	end
	return _mapPNG
end

function getCopyMapPNG()
	local _mapName = GetMapNameDB()
	local _mapPicturePath = "maps/" .. _mapName .. ".png"
	local _mapPictureDesti = _mapPicturePath

	local _mapPNG = Material("../maps/no_image.png", "noclamp smooth")
	if file.Exists(_mapPicturePath, "GAME") then
		if !file.Exists("maps", "DATA") then
			file.CreateDir("maps")
		end
		file.Write(_mapPicturePath, file.Read(_mapPicturePath, "GAME"))
		if file.Exists(_mapPicturePath, "DATA") then
			_mapPNG =	Material("../data/" .. _mapPicturePath, "noclamp smooth")
		end
	else
		_mapPicturePath = "maps/thumb/" .. _mapName .. ".png"
		if file.Exists(_mapPicturePath, "GAME") then
			if !file.Exists("maps", "DATA") then
				file.CreateDir("maps")
			end
			file.Write(_mapPictureDesti, file.Read(_mapPicturePath, "GAME"))
			if file.Exists(_mapPictureDesti, "DATA") then
				_mapPNG = Material("../data/" .. _mapPictureDesti, "noclamp smooth")
			end
		end
	end
	return _mapPNG
end

local gar = {}

function GetMapList()
	if gar.g and gar.r then
		net.Start("getMapList")
		net.SendToServer()
	end
end

hook.Add("open_server_map", "open_server_map", function()
	SaveLastSite()

	local w = settingsWindow.window.sitepanel:GetWide()
	local h = settingsWindow.window.sitepanel:GetTall()

	settingsWindow.window.site = createD("DPanel", settingsWindow.window.sitepanel, w, h, 0, 0)

	gar.g = false
	gar.r = false

	net.Receive("getMapListGroups", function(len)
		local entries = tonumber(net.ReadString())
		local id = tonumber(net.ReadString())
		_groups[id] = net.ReadTable()
		if id == entries then
			gar.g = true
		end
		GetMapList()
	end)
	net.Start("getMapListGroups")
	net.SendToServer()

	net.Receive("getMapListRoles", function(len)
		local entries = tonumber(net.ReadString())
		local id = tonumber(net.ReadString())
		_roles[id] = net.ReadTable()
		if id == entries then
			gar.r = true
		end
		GetMapList()
	end)
	net.Start("getMapListRoles")
	net.SendToServer()
end)
