--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- #WHITELISTESETTINGS
local tabW = {}
local tabR = {}
local tabG = {}
local loadedR = false
local loadedG = false
local loadedW = false
function BuildWhitelis(parent, tab)
	if not YRPPanelAlive(parent) then
		YRP:msg("note", "[BuildWhitelis] failed! parent: " .. tostring(parent))
	end

	if loadedR and loadedG and loadedW and YRPPanelAlive(parent) then
		local lis = YRPCreateD("DListView", parent, parent:GetWide() - YRP:ctr(60 + 500), parent:GetTall() - YRP:ctr(140), YRP:ctr(20), YRP:ctr(20))
		lis:AddColumn("uniqueID"):SetFixedWidth(60)
		lis:AddColumn("SteamID"):SetFixedWidth(130)
		lis:AddColumn(YRP:trans("LID_nick"))
		lis:AddColumn(YRP:trans("LID_name"))
		lis:AddColumn(YRP:trans("LID_group"))
		lis:AddColumn(YRP:trans("LID_role"))
		lis:AddColumn(YRP:trans("LID_time")):SetFixedWidth(120)
		lis:AddColumn(YRP:trans("LID_status"))
		function lis:Think()
			if self.w ~= parent:GetWide() - YRP:ctr(60 + 500) or self.h ~= parent:GetTall() - YRP:ctr(40) or self.x ~= YRP:ctr(20) or self.y ~= YRP:ctr(20) then
				self.w = parent:GetWide() - YRP:ctr(60 + 500)
				self.h = parent:GetTall() - YRP:ctr(40)
				self.x = YRP:ctr(20)
				self.y = YRP:ctr(20)
				self:SetSize(self.w, self.h)
				self:SetPos(self.x, self.y)
			end
		end

		for k, whi in pairs(tabW) do
			tabW[k].uniqueID = tonumber(whi.uniqueID)
			tabW[k].roleID = tonumber(whi.roleID)
			tabW[k].groupID = tonumber(whi.groupID)
		end

		for l, rol in pairs(tabR) do
			tabR[l].uniqueID = tonumber(rol.uniqueID)
			tabR[l].int_groupID = tonumber(rol.int_groupID)
		end

		for m, grp in pairs(tabG) do
			tabG[m].uniqueID = tonumber(grp.uniqueID)
		end

		for k, whi in pairs(tabW) do
			if whi.roleID ~= nil then
				local found = false
				-- ROLE
				if whi.roleID and whi.roleID > 0 and (tab == "LID_all" or tab == "LID_roles") then
					for l, rol in pairs(tabR) do
						if found then
							break
						elseif rol.uniqueID == whi.roleID then
							for m, grp in pairs(tabG) do
								-- ROLE
								if grp.uniqueID == rol.int_groupID then
									lis:AddLine(whi.uniqueID, whi.SteamID, YRP_SQL_STR_OUT(whi.nick), whi.name, grp.string_name, rol.string_name, whi.date, whi.status)
									found = true
									break
								end
							end
						end
					end
				elseif whi.roleID and whi.roleID < 0 and whi.groupID > 0 and (tab == "LID_all" or tab == "LID_groups") then
					-- GROUP
					for m, grp in pairs(tabG) do
						if grp.uniqueID == whi.groupID then
							lis:AddLine(whi.uniqueID, whi.SteamID, YRP_SQL_STR_OUT(whi.nick), whi.name, grp.string_name, "-", whi.date, whi.status)
							found = true
							break
						end
					end
				elseif tab == "LID_all" then
					-- ALL
					lis:AddLine(whi.uniqueID, whi.SteamID, YRP_SQL_STR_OUT(whi.nick), whi.name, YRP:trans("LID_all"), YRP:trans("LID_all"), whi.date, whi.status)
					found = true
				else
					local rolname = "-"
					local grpname = "-"
					if whi.roleID > 0 then
						for l, rol in pairs(tabR) do
							if rol.uniqueID == whi.roleID then
								rolname = rol.string_name
								break
							end
						end
					end

					if whi.groupID > 0 then
						for m, grp in pairs(tabG) do
							if grp.uniqueID == whi.groupID then
								grpname = grp.string_name
							end
						end
					end

					if grpname == "-" and rolname == "-" then
						grpname = YRP:trans("LID_all")
						rolname = YRP:trans("LID_all")
					end

					if string.StartWith(whi.status, "Manually") and tab == "LID_manually" then
						lis:AddLine(whi.uniqueID, whi.SteamID, YRP_SQL_STR_OUT(whi.nick), whi.name, grpname, rolname, whi.date, whi.status)
						found = true
					elseif string.StartWith(whi.status, "Promoted") and tab == "LID_promote" then
						lis:AddLine(whi.uniqueID, whi.SteamID, YRP_SQL_STR_OUT(whi.nick), whi.name, grpname, rolname, whi.date, whi.status)
						found = true
					end
				end
			end
		end

		local btnAdd = YRPCreateD("YButton", parent, YRP:ctr(500), YRP:ctr(50), parent:GetWide() - YRP:ctr(20 + 500), YRP:ctr(20))
		btnAdd:SetText(YRP:trans("LID_addentry") .. " ( " .. YRP:trans("LID_role") .. " )")
		function btnAdd:DoClick()
			local _whitelisFrame = createVGUI("DFrame", nil, 400, 500, 0, 0)
			_whitelisFrame:Center()
			_whitelisFrame:ShowCloseButton(true)
			_whitelisFrame:SetDraggable(true)
			_whitelisFrame:SetTitle("Whitelist")
			local _whitelisComboBoxPlys = createVGUI("DComboBox", _whitelisFrame, 380, 50, 10, 100)
			for k, v in pairs(player.GetAll()) do
				_whitelisComboBoxPlys:AddChoice(v:Nick(), v:YRPSteamID())
			end

			local _whitelisComboBox = createVGUI("DComboBox", _whitelisFrame, 380, 50, 10, 200)
			for k, v in pairs(tabG) do
				_whitelisComboBox:AddChoice(v.string_name, v.uniqueID)
			end

			local _whitelisComboBox2 = createVGUI("DComboBox", _whitelisFrame, 380, 50, 10, 300)
			function _whitelisComboBox:OnSelect()
				_whitelisComboBox2:Clear()
				for k, v in pairs(tabR) do
					for l, w in pairs(tabG) do
						if _whitelisComboBox:GetOptionData(_whitelisComboBox:GetSelectedID()) == v.int_groupID then
							_whitelisComboBox2:AddChoice(v.string_name, v.uniqueID)
							break
						end
					end
				end
			end

			local _whitelisButton = createVGUI("DButton", _whitelisFrame, 380, 50, 10, 400)
			_whitelisButton:SetText(YRP:trans("LID_whitelistplayer"))
			function _whitelisButton:DoClick()
				if _whitelisComboBoxPlys:GetOptionData(_whitelisComboBoxPlys:GetSelectedID()) ~= nil then
					net.Start("nws_yrp_whitelistPlayer")
					local _cb1_id = _whitelisComboBoxPlys:GetSelectedID()
					local _cb2_id = _whitelisComboBox2:GetSelectedID()
					local _cb1_data = _whitelisComboBoxPlys:GetOptionData(_cb1_id)
					local _cb2_data = _whitelisComboBox2:GetOptionData(_cb2_id)
					if _cb1_data ~= nil and _cb2_data ~= nil then
						net.WriteString(_cb1_data)
						net.WriteInt(tonumber(_cb2_data), 16)
					end

					net.SendToServer()
				end

				lis:Remove()
				_whitelisFrame:Close()
			end

			function _whitelisFrame:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, get_dbg_col())
				draw.SimpleTextOutlined(YRP:trans("LID_player") .. ":", "Y_24_500", YRP:ctr(10), YRP:ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
				draw.SimpleTextOutlined(YRP:trans("LID_group") .. ":", "Y_24_500", YRP:ctr(10), YRP:ctr(85 + 65), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
				draw.SimpleTextOutlined(YRP:trans("LID_role") .. ":", "Y_24_500", YRP:ctr(10), YRP:ctr(185 + 65), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
			end

			_whitelisFrame:MakePopup()
		end

		function btnAdd:Think()
			if self.w ~= YRP:ctr(500) or self.h ~= YRP:ctr(50) or self.x ~= parent:GetWide() - YRP:ctr(20 + 500) or self.y ~= YRP:ctr(20) then
				self.w = YRP:ctr(500)
				self.h = YRP:ctr(50)
				self.x = parent:GetWide() - YRP:ctr(20 + 500)
				self.y = YRP:ctr(20)
				self:SetSize(self.w, self.h)
				self:SetPos(self.x, self.y)
			end
		end

		local btnGroup = YRPCreateD("YButton", parent, YRP:ctr(500), YRP:ctr(50), parent:GetWide() - YRP:ctr(20 + 500), YRP:ctr(90))
		btnGroup:SetText(YRP:trans("LID_addentry") .. " ( " .. YRP:trans("LID_group") .. " )")
		function btnGroup:DoClick()
			local _whitelisFrame = createVGUI("DFrame", nil, 400, 500, 0, 0)
			_whitelisFrame:Center()
			_whitelisFrame:ShowCloseButton(true)
			_whitelisFrame:SetDraggable(true)
			_whitelisFrame:SetTitle("Whitelist")
			local _whitelisComboBoxPlys = createVGUI("DComboBox", _whitelisFrame, 380, 50, 10, 100)
			for k, v in pairs(player.GetAll()) do
				_whitelisComboBoxPlys:AddChoice(v:Nick(), v:YRPSteamID())
			end

			local _whitelisComboBox = createVGUI("DComboBox", _whitelisFrame, 380, 50, 10, 200)
			for k, v in pairs(tabG) do
				_whitelisComboBox:AddChoice(v.string_name, v.uniqueID)
			end

			local _whitelisButton = createVGUI("DButton", _whitelisFrame, 380, 50, 10, 400)
			_whitelisButton:SetText(YRP:trans("LID_whitelistplayer"))
			function _whitelisButton:DoClick()
				if _whitelisComboBoxPlys:GetOptionData(_whitelisComboBoxPlys:GetSelectedID()) ~= nil and _whitelisComboBox:GetOptionData(_whitelisComboBox:GetSelectedID()) ~= nil then
					net.Start("nws_yrp_whitelistPlayerGroup")
					net.WriteString(_whitelisComboBoxPlys:GetOptionData(_whitelisComboBoxPlys:GetSelectedID()))
					net.WriteInt(_whitelisComboBox:GetOptionData(_whitelisComboBox:GetSelectedID()), 16)
					net.SendToServer()
				end

				lis:Remove()
				_whitelisFrame:Close()
			end

			function _whitelisFrame:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, get_dbg_col())
				draw.SimpleTextOutlined(YRP:trans("LID_player") .. ":", "Y_24_500", YRP:ctr(10), YRP:ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
				draw.SimpleTextOutlined(YRP:trans("LID_group") .. ":", "Y_24_500", YRP:ctr(10), YRP:ctr(85 + 65), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
			end

			_whitelisFrame:MakePopup()
		end

		function btnGroup:Think()
			if self.w ~= YRP:ctr(500) or self.h ~= YRP:ctr(50) or self.x ~= parent:GetWide() - YRP:ctr(20 + 500) or self.y ~= YRP:ctr(90) then
				self.w = YRP:ctr(500)
				self.h = YRP:ctr(50)
				self.x = parent:GetWide() - YRP:ctr(20 + 500)
				self.y = YRP:ctr(90)
				self:SetSize(self.w, self.h)
				self:SetPos(self.x, self.y)
			end
		end

		local btnAll = YRPCreateD("YButton", parent, YRP:ctr(500), YRP:ctr(50), parent:GetWide() - YRP:ctr(20 + 500), YRP:ctr(160))
		btnAll:SetText(YRP:trans("LID_addentry") .. " ( " .. YRP:trans("LID_all") .. " )")
		function btnAll:DoClick()
			local _whitelisFrame = createVGUI("DFrame", nil, 400, 500, 0, 0)
			_whitelisFrame:Center()
			_whitelisFrame:ShowCloseButton(true)
			_whitelisFrame:SetDraggable(true)
			_whitelisFrame:SetTitle("Whitelist")
			local _whitelisComboBoxPlys = createVGUI("DComboBox", _whitelisFrame, 380, 50, 10, 100)
			for k, v in pairs(player.GetAll()) do
				_whitelisComboBoxPlys:AddChoice(v:Nick(), v:YRPSteamID())
			end

			local _whitelisButton = createVGUI("DButton", _whitelisFrame, 380, 50, 10, 400)
			_whitelisButton:SetText(YRP:trans("LID_whitelistplayer"))
			function _whitelisButton:DoClick()
				if _whitelisComboBoxPlys:GetOptionData(_whitelisComboBoxPlys:GetSelectedID()) ~= nil then
					net.Start("nws_yrp_whitelistPlayerAll")
					net.WriteString(_whitelisComboBoxPlys:GetOptionData(_whitelisComboBoxPlys:GetSelectedID()))
					net.SendToServer()
				end

				lis:Remove()
				_whitelisFrame:Close()
			end

			function _whitelisFrame:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, get_dbg_col())
				draw.SimpleTextOutlined(YRP:trans("LID_player") .. ":", "Y_24_500", YRP:ctr(10), YRP:ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
			end

			_whitelisFrame:MakePopup()
		end

		function btnAll:Think(pw, ph)
			if self.w ~= YRP:ctr(500) or self.h ~= YRP:ctr(50) or self.x ~= parent:GetWide() - YRP:ctr(20 + 500) or self.y ~= YRP:ctr(160) then
				self.w = YRP:ctr(500)
				self.h = YRP:ctr(50)
				self.x = parent:GetWide() - YRP:ctr(20 + 500)
				self.y = YRP:ctr(160)
				self:SetSize(self.w, self.h)
				self:SetPos(self.x, self.y)
			end
		end

		local btnRem = YRPCreateD("YButton", parent, YRP:ctr(500), YRP:ctr(50), parent:GetWide() - YRP:ctr(20 + 500), YRP:ctr(230))
		btnRem:SetText(YRP:trans("LID_removeentry"))
		function btnRem:DoClick()
			if lis:GetSelectedLine() ~= nil then
				local uid = lis:GetLine(lis:GetSelectedLine()):GetValue(1)
				if uid ~= nil then
					net.Start("nws_yrp_whitelistPlayerRemove")
					net.WriteInt(uid, 16)
					net.SendToServer()
					for i, v in pairs(tabW) do
						if v.uniqueID == uid then
							tabW[i] = nil
						end
					end

					lis:RemoveLine(lis:GetSelectedLine())
				end
			end
		end

		function btnRem:Paint(pw, ph)
			if lis:GetSelectedLine() ~= nil then
				hook.Run("YButtonPaint", self, pw, ph)
			end
		end

		function btnRem:Think()
			if self.w ~= YRP:ctr(500) or self.h ~= YRP:ctr(50) or self.x ~= parent:GetWide() - YRP:ctr(20 + 500) or self.y ~= YRP:ctr(230) then
				self.w = YRP:ctr(500)
				self.h = YRP:ctr(50)
				self.x = parent:GetWide() - YRP:ctr(20 + 500)
				self.y = YRP:ctr(230)
				self:SetSize(self.w, self.h)
				self:SetPos(self.x, self.y)
			end
		end

		function lis:OnRemove()
			btnAdd:Remove()
			btnRem:Remove()
		end
	else
		timer.Simple(
			0.1,
			function()
				BuildWhitelis(parent, tab)
			end
		)
	end
end

net.Receive(
	"nws_yrp_getGroupsWhitelist",
	function(len)
		tabG = net.ReadTable()
		loadedG = true
	end
)

net.Receive(
	"nws_yrp_getRolesWhitelist",
	function(len)
		tabR = net.ReadTable()
		loadedR = true
	end
)

net.Receive(
	"nws_yrp_getRoleWhitelist_line",
	function(len)
		local PARENT = GetSettingsSite()
		if YRPPanelAlive(PARENT) then
			local site = PARENT
			local id = net.ReadString() or "0"
			id = tonumber(id)
			tabW[id] = net.ReadTable()
			if net.ReadBool() then
				loadedW = true
				-- TABS
				local tabs = YRPCreateD("YTabs", site, site:GetWide(), site:GetTall(), 0, 0)
				function tabs:Think()
					self:SetSize(site:GetWide(), site:GetTall())
				end

				tabs:AddOption(
					"LID_all",
					function(parent)
						BuildWhitelis(parent, "LID_all")
					end
				)

				tabs:AddOption(
					"LID_roles",
					function(parent)
						BuildWhitelis(parent, "LID_roles")
					end
				)

				tabs:AddOption(
					"LID_groups",
					function(parent)
						BuildWhitelis(parent, "LID_groups")
					end
				)

				tabs:AddOption(
					"LID_manually",
					function(parent)
						BuildWhitelis(parent, "LID_manually")
					end
				)

				tabs:AddOption(
					"LID_promote",
					function(parent)
						BuildWhitelis(parent, "LID_promote")
					end
				)

				tabs:GoToSite("LID_all")
			end
		end
	end
)

function OpenSettingsWhitelist()
	loadedR = false
	loadedG = false
	timer.Simple(
		0.1,
		function()
			net.Start("nws_yrp_getGroupsWhitelist")
			net.SendToServer()
		end
	)

	timer.Simple(
		0.2,
		function()
			net.Start("nws_yrp_getRolesWhitelist")
			net.SendToServer()
		end
	)

	timer.Simple(
		0.3,
		function()
			net.Start("nws_yrp_getRoleWhitelist")
			net.SendToServer()
		end
	)
end
