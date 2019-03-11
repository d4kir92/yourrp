--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local _rm = nil
local _info = nil

function toggleRoleMenu()
	if isNoMenuOpen() then
		openRoleMenu()
	else
		closeRoleMenu()
	end
end

function closeRoleMenu()
	if _rm != nil then
		closeMenu()
		_rm:Remove()
		_rm = nil
	elseif _info != nil then
		closeMenu()
		_info:Remove()
		_info = nil
	end
end

local _pr = {}

local _adminonly = Material("icon16/shield.png")

function createRoleBox(rol, parent, mainparent)
	if rol != nil then
		local _rol = createD("DPanel", parent, ctrb(400), ctrb(400), 0, 0)
		function _rol:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 100))
			drawRBBR(0, 0, 0, pw, ph, Color(0, 0, 0, 255), ctrb(4))
		end
		_rol.tbl = rol

		--[[ Role Playermodel ]]--
		_rol.pm = createD("DModelPanel", _rol, _rol:GetWide(), _rol:GetTall(), 0, 0)
		_rol.pm:SetModel(string.Explode(",", _rol.tbl.string_playermodels)[1] or "")

		--[[ Role Name ]]--
		_rol.rn = createD("DPanel", _rol, _rol:GetWide(), ctrb(60), 0, 0)
		function _rol.rn:Paint(pw, ph)
			surfaceText(self:GetParent().tbl.string_name, "roleInfoHeader", pw/2, ph/2, Color(255, 255, 255), 1, 1)
		end

		--[[ Role MaxAmount ]]--
		if tonumber(rol.int_maxamount) > 0 then
			_rol.ma = createD("DPanel", _rol, _rol:GetWide(), ctrb(60), 0, _rol:GetTall()-ctrb(60 + 60))
			function _rol.ma:Paint(pw, ph)
				local _br = 4
				pw = pw - 2*ctrb(4)
				ph = ph - 1*ctrb(4)

				--Background
				draw.RoundedBox(0, ctrb(_br), 0, pw, ph, Color(255, 255, 255, 100))

				--Maxamount
				draw.RoundedBox(0, ctrb(_br), 0, (rol.int_uses/rol.int_maxamount) * (pw), ph, Color(255, 0, 0, 255))
				surfaceText(self:GetParent().tbl.int_uses .. "/" .. self:GetParent().tbl.int_maxamount, "roleInfoHeader", pw/2, ph/2, Color(255, 255, 255), 1, 1)

				--BR
				drawRBBR(0, ctrb(_br), 0, pw, ph, Color(0, 0, 0, 255), ctrb(4))
			end
		end

		--[[ Role Adminonly ]]--
		if tobool(rol.bool_adminonly) then
			_rol.aoicon = 64
			_rol.ao = createD("DPanel", _rol, ctrb(_rol.aoicon), ctrb(_rol.aoicon), _rol:GetWide()/2-ctrb(_rol.aoicon/2), _rol:GetTall()/2-ctrb(_rol.aoicon/2))
			function _rol.ao:Paint(pw, ph)
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(_adminonly	)
				surface.DrawTexturedRect(0, 0, pw, ph)
			end
		end

		--[[ Role Button ]]--
		_rol.gr = createD("YButton", _rol, _rol:GetWide(), ctrb(60), 0, _rol:GetTall()-ctrb(60))
		function _rol.gr:Paint(pw, ph)
			hook.Run("YButtonPaint", self, pw, ph) -- surfaceButton(self, pw, ph, YRP.lang_string("LID_moreinformation"))
		end
		_rol.gr:SetText("LID_moreinformation")
		function _rol.gr:DoClick()
			local _pm = string.Explode(",", rol.string_playermodels)

			_rm.infopm:SetModel(_pm[1] or "")

			_rm.info.rolename = rol.string_name

			_rm.infodesc:SetText("")
			_rm.infodesc:SetFontInternal("roleInfoText")
			_rm.infodesc:InsertColorChange(255, 255, 255, 255)
			_rm.infodesc:AppendText(rol.string_description)

			_rm.infosweps:SetText("")
			_rm.infosweps:SetFontInternal("roleInfoText")
			_rm.infosweps:InsertColorChange(255, 255, 255, 255)
			_rm.infosweps:AppendText(string.Implode(", ", string.Explode(",", rol.string_sweps)))

			_rm.info.rolesala = rol.int_salary
			_rm.info.roleswep = rol.string_sweps

			_rm.infobutton.rolename = rol.string_name
			_rm.infobutton.uniqueID = rol.uniqueID
		end

		if parent.AddPanel != nil then
			parent:AddPanel(_rol)
		end
	end
end

function createBouncer(parent, mainparent)
	parent:SetWide(mainparent:GetWide() - ctrb(140))
	local _bou = createD("DPanel", parent, ctrb(50), ctrb(200), 0, 0)
	function _bou:Paint(pw, ph)
		surfaceText("➔", "roleInfoHeader", pw/2, ph/2, Color(255, 255, 255), 1, 1)
	end
	if parent.AddPanel != nil then
		parent:AddPanel(_bou)
	end
end

function addPreRole(rol, parent, mainparent)
	_pr[rol.uniqueID] = parent
	local _tmp = createBouncer(parent, mainparent)
	if tonumber(rol.bool_visible) == 1 then
		createRoleBox(rol, parent, mainparent)
		getPreRole(rol.uniqueID, _pr[rol.uniqueID], mainparent)
	end
end

function getPreRole(uid, parent, mainparent)
	net.Receive("get_rol_prerole", function(len)
		local _prerole = net.ReadTable()
		if _prerole.int_prerole != nil then
			addPreRole(_prerole, _pr[_prerole.int_prerole], mainparent)
		end
	end)

	net.Start("get_rol_prerole")
		net.WriteString(uid)
	net.SendToServer()
end

function addRole(rol, parent, mainparent)
	createRoleBox(rol, parent, mainparent)
	_pr[rol.uniqueID] = parent
	getPreRole(rol.uniqueID, _pr[rol.uniqueID], mainparent)
end

function addRoleRow(rol, parent)
	if pa(parent) then
		local _rr = createD("DHorizontalScroller", parent.content, ctrb(400), ctrb(400), 0, 0) --parent:GetWide() - 2*ctrb(parent:GetSpacing()), ctrb(400), 0, 0)
		_rr:SetOverlap(ctrb(-30))
		function _rr:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 120))
		end

		addRole(rol, _rr, parent)
		
		parent:Add(_rr)
	end
end

function getRoles(uid, parent)
	net.Receive("get_grp_roles", function(len)
		local _roles = net.ReadTable()

		for i, rol in pairs(_roles) do
			if !wk(rol.int_prerole) then
				YRP.msg("error", "getRoles(" .. tostring(uid) .. ", " .. tostring(parent) .. ") rol: " .. tostring(rol) .. " rol.int_prerole: " .. tostring(rol.int_prerole))
			elseif tonumber(rol.int_prerole) <= 0 then
				if tonumber(rol.bool_visible) == 1 then
					addRoleRow(rol, parent)
				end
			elseif tonumber(rol.int_prerole) >= 1 then
				--addRoleRow(rol, parent)
			end
		end
		--getGroups(uid, parent)
	end)

	net.Start("get_grp_roles")
		net.WriteString(uid)
	net.SendToServer()

	getGroups(uid, parent)
end

function addGroup(grp, parent)
	if parent != NULL and pa(parent) and tobool(grp.bool_visible) then
		local _grp = createD("DYRPCollapsibleCategory", parent, parent:GetWide() - ctrb(40), ctrb(200), ctrb(0), ctrb(0))
		_grp:SetHeader(grp.string_name)
		_grp:SetSpacing(30)
		_grp.color = string.Explode(",", grp.string_color)
		_grp.color = Color(_grp.color[1], _grp.color[2], _grp.color[3])
		_grp.tbl = grp
		_grp.locked = tobool(grp.bool_locked)
		function _grp:PaintHeader(pw, ph)
			local _hl = 0
			if self.header:IsHovered() then
				_hl = 70
			end
			draw.RoundedBoxEx(ctrb(30), 0, 0, pw, ph, Color(self.color.r + _hl, self.color.g + _hl, self.color.b + _hl), true, true, !self:IsOpen(), !self:IsOpen())
			local _x = ph / 2
			if grp.string_icon != "" then
				_x = ctr(10) + ph + ctr(10)
			end
			local name = self.tbl.string_name
			if tonumber(self.tbl.int_parentgroup) == 0 then
				name = YRP.lang_string("LID_faction") .. ": " .. name
			end
			surfaceText(name, "roleInfoHeader", _x, ph / 2, Color(255, 255, 255), 0, 1)

			local _box = ctrb(50)
			local _dif = 50
			local _br = (ph - _box)/2
			local _tog = "▼"
			if self:IsOpen() then
				_tog = "▲"
			end
			draw.RoundedBox(0, pw - _box - _br, _br, _box, _box, Color(self.color.r - _dif, self.color.g - _dif, self.color.b - _dif))
			surfaceText(_tog, "roleInfoHeader", pw - _box/2 - _br, _br + _box/2, Color(255, 255, 255), 1, 1)
			if tobool(grp.bool_locked) then
				YRP.DrawIcon(YRP.GetDesignIcon("lock"), ph - ctr(8), ph - ctr(8), pw - 2 * ph, ctr(4), Color(255, 0, 0, 200))
			end
		end
		function _grp:PaintContent(pw, ph)
			draw.RoundedBoxEx(ctrb(30), 0, 0, pw, ph, Color(self.color.r+40, self.color.g+40, self.color.b+40), false, false, true, true)
		end
		_grp:SetHeaderHeight(ctrb(100))

		function _grp:DoClick()
			if !tobool(grp.bool_locked) then
				if self:IsOpen() then
					getRoles(grp.uniqueID, _grp)
				else
					self:ClearContent()
				end
			end
		end

		if grp.string_icon != "" then
			_grp.icon = createD("DHTML", _grp, _grp:GetTall() - ctr(16), _grp:GetTall() - ctr(16), ctr(26), ctr(8))
			_grp.icon:SetHTML(GetHTMLImage(grp.string_icon, _grp.icon:GetWide(), _grp.icon:GetTall()))
		end

		if tostring(grp.int_parentgroup) != "0" then
			parent:Add(_grp)
		else
			parent:AddItem(_grp)
		end
		--parent:Rebuild()

		return _grp
	else
		return NULL
	end
end

function getGroups(uid, parent)
	net.Receive("get_grps", function(len)
		local _groups = net.ReadTable()
		for i, grp in SortedPairsByMemberValue(_groups, "int_position") do
			addGroup(grp, parent)
		end
	end)

	net.Start("get_grps")
		net.WriteString(uid)
	net.SendToServer()
end

function openRoleMenu()
	openMenu()
	if LocalPlayer():GetNW2Bool("bool_players_can_switch_role", false) then
		_rm = createD("YFrame", nil, ScW(), ScrH(), 0, 0)
		_rm:Center()
		_rm:ShowCloseButton(true)
		_rm:SetDraggable(false)
		_rm:SetTitle("LID_rolemenu")
		function _rm:Paint(pw, ph)
			hook.Run("YFramePaint", self, pw, ph) --surfaceWindow(self, pw, ph, YRP.lang_string("LID_rolemenu") .. " [PROTOTYPE]")
		end

		_rm.info = createD("DPanel", _rm, ctrb(800), ScrH() - ctrb(60), ScW() - ctrb(10) - ctrb(800), ctrb(50))
		_rm.info.rolename = YRP.lang_string("LID_none")
		_rm.info.rolesala = YRP.lang_string("LID_none")
		function _rm.info:Paint(pw, ph)
			if _rm.info.rolename == YRP.lang_string("LID_none") then return end
			draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 180))

			--[[ Role Appearance ]]--
			draw.RoundedBox(0, 0, 0, pw, ctrb(50), Color(0, 255, 0, 255))
			surfaceText(YRP.lang_string("LID_appearance"), "roleInfoHeader", ctrb(25), ctrb(25), Color(255, 255, 255), 0, 1)
			--draw.RoundedBox(0, 0, ctrb(50), pw, pw, Color(0, 0, 0, 200))

			--[[ Role Name ]]--
			draw.RoundedBox(0, 0, ctrb(900), pw, ctrb(50), Color(0, 255, 0, 255))
			surfaceText(YRP.lang_string("LID_role"), "roleInfoHeader", ctrb(25), ctrb(900 + 25), Color(255, 255, 255), 0, 1)
			draw.RoundedBox(0, 0, ctrb(900+50), pw, ctrb(50), Color(0, 0, 0, 200))
			surfaceText(self.rolename, "roleInfoText", ctrb(25), ctrb(900 + 50 + 25), Color(255, 255, 255), 0, 1)

			--[[ Role Description ]]--
			draw.RoundedBox(0, 0, ctrb(1050), pw, ctrb(50), Color(0, 255, 0, 255))
			surfaceText(YRP.lang_string("LID_description"), "roleInfoHeader", ctrb(25), ctrb(1050 + 25), Color(255, 255, 255), 0, 1)

			--[[ Role Equipment ]]--
			draw.RoundedBox(0, 0, ctrb(1450), pw, ctrb(50), Color(0, 255, 0, 255))
			surfaceText(YRP.lang_string("LID_sweps"), "roleInfoHeader", ctrb(25), ctrb(1450 + 25), Color(255, 255, 255), 0, 1)

			--[[ Role Salary ]]--
			draw.RoundedBox(0, 0, ctrb(1850), pw, ctrb(50), Color(0, 255, 0, 255))
			surfaceText(YRP.lang_string("LID_salary"), "roleInfoHeader", ctrb(25), ctrb(1850 + 25), Color(255, 255, 255), 0, 1)
			draw.RoundedBox(0, 0, ctrb(1850+50), pw, ctrb(50), Color(0, 0, 0, 200))
			surfaceText(self.rolesala, "roleInfoText", ctrb(25), ctrb(1850 + 50 + 25), Color(255, 255, 255), 0, 1)
		end
		_rm.infopm = createD("DModelPanel", _rm.info, ctrb(800), ctrb(800), 0, ctrb(50))

		_rm.infodesc = createD("RichText", _rm.info, ctrb(800), ctrb(300), 0, ctrb(1050+50))
		function _rm.infodesc:Paint(pw, ph)
			if _rm.info.rolename == YRP.lang_string("LID_none") then return end
			draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 200))
		end

		_rm.infosweps = createD("RichText", _rm.info, ctrb(800), ctrb(300), 0, ctrb(1450+50))
		function _rm.infosweps:Paint(pw, ph)
			if _rm.info.rolename == YRP.lang_string("LID_none") then return end
			draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 200))
		end

		_rm.infobutton = createD("YButton", _rm.info, ctrb(800-20), ctrb(100), ctrb(10), _rm.info:GetTall() - ctrb(100+10))
		_rm.infobutton:SetText("LID_getrole")
		_rm.infobutton.rolename = ""
		function _rm.infobutton:Paint(pw, ph)
			if _rm.info.rolename == YRP.lang_string("LID_none") then return end
			hook.Run("YButtonPaint", self, pw, ph) -- surfaceButton(self, pw, ph, YRP.lang_string("LID_getrole"))
		end
		function _rm.infobutton:DoClick()
			if self.uniqueID != nil then
				net.Start("wantRole")
					net.WriteInt(self.uniqueID, 16)
				net.SendToServer()
				_rm:Close()
			end
		end

		_rm.pl = createD("DPanelList", _rm, ScW() - ctrb(10+10+10) - ctrb(800), ScrH() - ctrb(60), ctrb(10), ctrb(50))
		_rm.pl:EnableVerticalScrollbar(true)
		_rm.pl:SetSpacing(10)
		_rm.pl:SetNoSizing(true)

		function _rm.pl:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 180))
		end

		getGroups(0, _rm.pl)



		_rm:MakePopup()
	else
		_info = createD("DFrame", nil, ctr(400), ctr(400), 0, 0)
		_info:SetTitle("")
		function _info:Paint(pw, ph)
			surfaceWindow(self, pw, ph, "rolemenu")
			surfaceText(YRP.lang_string("LID_disabled"), "mat1text", pw/2, ph/2, Color(255, 255, 255), 1, 1)
		end
		_info:MakePopup()
		_info:Center()
	end
end
