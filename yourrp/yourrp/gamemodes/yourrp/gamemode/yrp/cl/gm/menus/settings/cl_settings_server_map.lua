--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
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
	if tostring(_mapPNG) == "Material [___error]" then return false end

	return _mapPNG
end

function getCopyMapPNG()
	local _mapName = GetMapNameDB()
	local _mapPicturePath = "maps/" .. _mapName .. ".png"
	local _mapPictureDesti = _mapPicturePath
	local _mapPNG = Material("../maps/no_image.png", "noclamp smooth")
	if file.Exists(_mapPicturePath, "GAME") then
		if not file.Exists("maps", "DATA") then
			file.CreateDir("maps")
		end

		file.Write(_mapPicturePath, file.Read(_mapPicturePath, "GAME"))
		if file.Exists(_mapPicturePath, "DATA") then
			_mapPNG = Material("../data/" .. _mapPicturePath, "noclamp smooth")
		end
	else
		_mapPicturePath = "maps/thumb/" .. _mapName .. ".png"
		if file.Exists(_mapPicturePath, "GAME") then
			if not file.Exists("maps", "DATA") then
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

net.Receive(
	"nws_yrp_getMapSite",
	function(len)
		local PARENT = GetSettingsSite()
		if YRPPanelAlive(PARENT) then
			if len > 512000 then
				YRP.msg("note", "getMapList - len: " .. len .. "/" .. "512000 (len is to big)")
			end

			local tabs = YRPCreateD("YTabs", PARENT, PARENT:GetWide(), PARENT:GetTall(), 0, 0)
			tabs:SetTabWide(540)
			function tabs:Think()
				if YRPPanelAlive(PARENT) then
					self:SetSize(PARENT:GetWide(), PARENT:GetTall())
				end
			end

			PARENT.maptabs = tabs
			-- GROUPS AND ROLES
			tabs:AddOption(
				"LID_groupspawnpoints",
				function(parent)
					net.Start("nws_yrp_getMapTab")
					net.WriteString("groupspawnpoints")
					net.SendToServer()
				end
			)

			tabs:AddOption(
				"LID_rolespawnpoints",
				function(parent)
					net.Start("nws_yrp_getMapTab")
					net.WriteString("rolespawnpoints")
					net.SendToServer()
				end
			)

			-- SHOPS
			tabs:AddOption(
				"LID_dealers",
				function(parent)
					net.Start("nws_yrp_getMapTab")
					net.WriteString("dealers")
					net.SendToServer()
				end
			)

			tabs:AddOption(
				"LID_storagepoints",
				function(parent)
					net.Start("nws_yrp_getMapTab")
					net.WriteString("storagepoints")
					net.SendToServer()
				end
			)

			-- JAIL
			tabs:AddOption(
				"LID_jailpoint",
				function(parent)
					net.Start("nws_yrp_getMapTab")
					net.WriteString("jailpoints")
					net.SendToServer()
				end
			)

			tabs:AddOption(
				"LID_releasepoint",
				function(parent)
					net.Start("nws_yrp_getMapTab")
					net.WriteString("releasepoints")
					net.SendToServer()
				end
			)

			-- OTHER THINGS
			tabs:AddOption(
				"LID_other",
				function(parent)
					net.Start("nws_yrp_getMapTab")
					net.WriteString("other")
					net.SendToServer()
				end
			)

			tabs:GoToSite("LID_groupspawnpoints")
		end
	end
)

-- #F8Map
net.Receive(
	"nws_yrp_getMapTab",
	function(len)
		local lply = LocalPlayer()
		local tab = net.ReadString()
		local dbTab = net.ReadTable()
		local dbGrp = net.ReadTable()
		local dbRol = net.ReadTable()
		local PARENT = GetSettingsSite()
		if not YRPPanelAlive(PARENT) then return end
		if not YRPPanelAlive(PARENT.maptabs) then return end
		local parent = PARENT.maptabs.site
		if not IsNotNilAndNotFalse(parent) or not YRPPanelAlive(parent) then return end
		parent:Clear()
		local mapList = YRPCreateD("DListView", parent, parent:GetWide() - YRP.ctr(660), parent:GetTall() - YRP.ctr(140), YRP.ctr(20), YRP.ctr(20))
		mapList:AddColumn("uniqueID"):SetFixedWidth(YRP.ctr(120))
		mapList:AddColumn(YRP.trans("LID_position")):SetFixedWidth(YRP.ctr(600))
		mapList:AddColumn(YRP.trans("LID_angle")):SetFixedWidth(YRP.ctr(500))
		mapList:AddColumn(YRP.trans("LID_type")):SetFixedWidth(YRP.ctr(600))
		mapList:AddColumn(YRP.trans("LID_name"))
		function mapList:Think()
			if self.w ~= parent:GetWide() - YRP.ctr(660) or self.h ~= parent:GetTall() - YRP.ctr(140) or self.x ~= YRP.ctr(20) or self.y ~= YRP.ctr(20) then
				self.w = parent:GetWide() - YRP.ctr(660)
				self.h = parent:GetTall() - YRP.ctr(140)
				self.x = YRP.ctr(20)
				self.y = YRP.ctr(20)
				self:SetSize(self.w, self.h)
				self:SetPos(self.x, self.y)
			end
		end

		for k, v in pairs(dbTab) do
			mapList:AddLine(v.uniqueID, v.position, v.angle, v.type, v.name)
		end

		local PY = 20
		-- ADD
		--if tab == "groupspawnpoints" or tab == "rolespawnpoints" or tab == "dealers" or tab == "storagepoints" then
		local btnAdd = YRPCreateD("YButton", parent, YRP.ctr(600), YRP.ctr(50), parent:GetWide() - YRP.ctr(620), YRP.ctr(PY))
		btnAdd:SetText(YRP.trans("LID_add"))
		btnAdd.py = YRP.ctr(PY)
		function btnAdd:DoClick()
			if tab == "groupspawnpoints" or tab == "rolespawnpoints" or tab == "dealers" or tab == "storagepoints" then
				local addWin = YRPCreateD("YFrame", nil, YRP.ctr(800), YRP.ctr(800), 0, 0)
				addWin:SetHeaderHeight(YRP.ctr(100))
				addWin:Center()
				addWin:MakePopup()
				addWin:SetTitle("")
				if tab == "groupspawnpoints" then
					addWin.type = "GroupSpawnpoint"
				elseif tab == "rolespawnpoints" then
					addWin.type = "RoleSpawnpoint"
				elseif tab == "dealers" then
					addWin.type = "dealer"
				elseif tab == "storagepoints" then
					addWin.type = "Storagepoint"
					addWin.name = "NewStoragepoint"
				end

				local content = addWin:GetContent()
				local Y = 0
				if tab == "groupspawnpoints" or tab == "rolespawnpoints" then
					addWin.addGrpHeader = YRPCreateD("YLabel", content, YRP.ctr(760), YRP.ctr(50), YRP.ctr(0), YRP.ctr(Y))
					Y = Y + 50
					addWin.addGrpHeader:SetText("LID_group")
					addWin.addGrp = YRPCreateD("DComboBox", content, YRP.ctr(760), YRP.ctr(50), YRP.ctr(0), YRP.ctr(Y))
					Y = Y + 50
					for k, v in pairs(dbGrp) do
						addWin.addGrp:AddChoice(v.string_name, v.uniqueID)
					end

					function addWin.addGrp:OnSelect(index, value, data)
						if tab == "groupspawnpoints" then
							addWin.linkID = data
						end

						if addWin.addRol then
							addWin.addRol:Clear()
							for k, r in pairs(dbRol) do
								if r.int_groupID == data then
									addWin.addRol:AddChoice(r.string_name, r.uniqueID)
								end
							end
						end
					end

					Y = Y + 50
				end

				if tab == "rolespawnpoints" then
					addWin.addRolHeader = YRPCreateD("YLabel", content, YRP.ctr(760), YRP.ctr(50), YRP.ctr(0), YRP.ctr(Y))
					Y = Y + 50
					addWin.addRolHeader:SetText("LID_role")
					addWin.addRol = YRPCreateD("DComboBox", content, YRP.ctr(760), YRP.ctr(50), YRP.ctr(0), YRP.ctr(Y))
					Y = Y + 50
					function addWin.addRol:OnSelect(index, value, data)
						if tab == "rolespawnpoints" then
							addWin.linkID = data
						end
					end

					Y = Y + 50
				end

				if tab == "storagepoints" then
					addWin.addNameHeader = YRPCreateD("YLabel", content, YRP.ctr(760), YRP.ctr(50), YRP.ctr(0), YRP.ctr(Y))
					Y = Y + 50
					addWin.addNameHeader:SetText("LID_name")
					addWin.addName = YRPCreateD("DTextEntry", content, YRP.ctr(760), YRP.ctr(50), YRP.ctr(0), YRP.ctr(Y))
					Y = Y + 50
					addWin.addName:SetText(addWin.name)
					function addWin.addName:OnChange()
						addWin.name = self:GetText()
					end

					Y = Y + 50
				end

				local addBtn = YRPCreateD("YButton", content, YRP.ctr(760), YRP.ctr(50), YRP.ctr(0), YRP.ctr(Y))
				addBtn:SetText(YRP.trans("LID_add"))
				function addBtn:DoClick()
					local addPos = string.Explode(" ", tostring(lply:GetPos()))
					local addAng = string.Explode(" ", tostring(lply:GetAngles()))
					if addWin.linkID ~= nil then
						if tab == "groupspawnpoints" or tab == "rolespawnpoints" then
							net.Start("nws_yrp_dbInsertIntoMap")
							net.WriteString("yrp_" .. GetMapNameDB())
							net.WriteString("position, angle, linkID, type")
							local addStr = "'" .. tonumber(addPos[1]) .. "," .. tonumber(addPos[2]) .. "," .. tonumber(addPos[3] + 4) .. "', '" .. tonumber(addAng[1]) .. "," .. tonumber(addAng[2]) .. "," .. tonumber(addAng[3]) .. "', " .. tostring(addWin.linkID) .. ", '" .. addWin.type .. "'"
							net.WriteString(addStr)
							net.SendToServer()
						end
					elseif tab == "dealers" then
						net.Start("nws_yrp_dealer_add")
						net.SendToServer()
					elseif tab == "storagepoints" then
						net.Start("nws_yrp_dbInsertIntoMap")
						net.WriteString("yrp_" .. GetMapNameDB())
						net.WriteString("position, angle, name, type")
						local addStr = "'" .. tonumber(addPos[1]) .. "," .. tonumber(addPos[2]) .. "," .. tonumber(addPos[3] + 4) .. "', '" .. tonumber(addAng[1]) .. "," .. tonumber(addAng[2]) .. "," .. tonumber(addAng[3]) .. "', " .. YRP_SQL_STR_IN(tostring(addWin.name)) .. ", '" .. addWin.type .. "'"
						net.WriteString(addStr)
						net.SendToServer()
					end

					net.Start("nws_yrp_getMapTab")
					net.WriteString(tab)
					net.SendToServer()
					addWin:Close()
				end

				function addBtn:Paint(pw, ph)
					hook.Run("YButtonPaint", self, pw, ph)
				end
			end
		end

		function btnAdd:Paint(pw, ph)
			if tab == "groupspawnpoints" or tab == "rolespawnpoints" or tab == "dealers" or tab == "storagepoints" then
				hook.Run("YButtonPaint", self, pw, ph)
			end
		end

		function btnAdd:Think()
			if self.w ~= YRP.ctr(600) or self.h ~= YRP.ctr(50) or self.x ~= parent:GetWide() - YRP.ctr(620) or self.y ~= self.py then
				self.w = YRP.ctr(600)
				self.h = YRP.ctr(50)
				self.x = parent:GetWide() - YRP.ctr(620)
				self.y = self.py
				self:SetSize(self.w, self.h)
				self:SetPos(self.x, self.y)
			end
		end

		PY = PY + 50 + 20
		--end
		-- DELETE
		local btnDelete = YRPCreateD("YButton", parent, YRP.ctr(600), YRP.ctr(50), parent:GetWide() - YRP.ctr(620), YRP.ctr(PY))
		btnDelete:SetText(YRP.trans("LID_deleteentry"))
		btnDelete.py = YRP.ctr(PY)
		function btnDelete:DoClick()
			if mapList:GetSelectedLine() ~= nil then
				net.Start("nws_yrp_removeMapEntry")
				net.WriteString(mapList:GetLine(mapList:GetSelectedLine()):GetValue(1))
				net.SendToServer()
				mapList:RemoveLine(mapList:GetSelectedLine())
			end
		end

		function btnDelete:Paint(pw, ph)
			if mapList:GetSelectedLine() ~= nil then
				local t = {}
				t.color = Color(255, 100, 100, 255)
				hook.Run("YButtonPaint", self, pw, ph, t)
			end
		end

		function btnDelete:Think()
			if self.w ~= YRP.ctr(600) or self.h ~= YRP.ctr(50) or self.x ~= parent:GetWide() - YRP.ctr(620) or self.y ~= self.py then
				self.w = YRP.ctr(600)
				self.h = YRP.ctr(50)
				self.x = parent:GetWide() - YRP.ctr(620)
				self.y = self.py
				self:SetSize(self.w, self.h)
				self:SetPos(self.x, self.y)
			end
		end

		PY = PY + 50 + 20
		-- YRPTeleportToPoint
		local btnTeleport = YRPCreateD("YButton", parent, YRP.ctr(600), YRP.ctr(50), parent:GetWide() - YRP.ctr(620), YRP.ctr(PY))
		btnTeleport:SetText(YRP.trans("LID_tpto"))
		btnTeleport.py = YRP.ctr(PY)
		function btnTeleport:DoClick()
			if mapList:GetSelectedLine() ~= nil then
				net.Start("nws_yrp_teleportto")
				net.WriteString(mapList:GetLine(mapList:GetSelectedLine()):GetValue(1))
				net.SendToServer()
			end
		end

		function btnTeleport:Paint(pw, ph)
			if mapList:GetSelectedLine() ~= nil then
				local t = {}
				t.color = Color(255, 255, 100, 255)
				hook.Run("YButtonPaint", self, pw, ph, t)
			end
		end

		function btnTeleport:Think()
			if self.w ~= YRP.ctr(600) or self.h ~= YRP.ctr(50) or self.x ~= parent:GetWide() - YRP.ctr(620) or self.y ~= self.py then
				self.w = YRP.ctr(600)
				self.h = YRP.ctr(50)
				self.x = parent:GetWide() - YRP.ctr(620)
				self.y = self.py
				self:SetSize(self.w, self.h)
				self:SetPos(self.x, self.y)
			end
		end
	end
)

function OpenSettingsMap()
	net.Start("nws_yrp_getMapSite")
	net.SendToServer()
end