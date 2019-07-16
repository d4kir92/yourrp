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
local pmid = 1
function createRoleBox(rol, parent, mainparent)
	if rol != nil then
		local _rol = createD("DPanel", parent, YRP.ctr(400), YRP.ctr(400), 0, 0)
		function _rol:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 10))
			drawRBBR(0, 0, 0, pw, ph, Color(0, 0, 0, 255), YRP.ctr(4))
		end
		_rol.tbl = rol

		-- Role Playermodel --
		local pm = _rol.tbl.pms[1] or {}
		if pm.string_model != nil and pm.string_model != "" then
			local p = createD("DModelPanel", _rol, _rol:GetWide(), _rol:GetTall(), 0, 0)
			p:SetModel(pm.string_model)
			local randsize = math.Rand(pm.float_size_min, pm.float_size_max)
			p.Entity:SetModelScale(randsize, 0)
		end

		-- Role Name --
		_rol.rn = createD("DPanel", _rol, _rol:GetWide(), YRP.ctr(60), 0, 0)
		_rol.rn.rolename = _rol.rn:GetParent().tbl.string_name
		_rol.rn.rolecolor = StringToColor(_rol.rn:GetParent().tbl.string_color)
		function _rol.rn:Paint(pw, ph)
			surfaceText(self.rolename, "roleInfoHeader", pw / 2, ph / 2, self.rolecolor, 1, 1)
		end

		-- Role MaxAmount --
		if tonumber(rol.int_maxamount) > 0 then
			_rol.ma = createD("DPanel", _rol, _rol:GetWide(), YRP.ctr(60), 0, _rol:GetTall() - YRP.ctr(60))
			function _rol.ma:Paint(pw, ph)
				local _br = 4
				pw = pw - 2 * YRP.ctr(4)
				ph = ph - 1 * YRP.ctr(4)

				--Background
				--draw.RoundedBox(0, YRP.ctr(_br), 0, pw, ph, Color(255, 255, 255, 100))

				--Maxamount
				--draw.RoundedBox(0, YRP.ctr(_br), 0, (rol.int_uses / rol.int_maxamount) * pw, ph, Color(255, 0, 0, 255))
				local color = Color(255, 255, 255)
				if tonumber(rol.int_uses) == tonumber(rol.int_maxamount) then
					color = Color(255, 0, 0)
				end
				surfaceText(self:GetParent().tbl.int_uses .. "/" .. self:GetParent().tbl.int_maxamount, "Roboto14B", pw - YRP.ctr(20), ph / 2, color, 2, 1)

				--BR
				--drawRBBR(0, YRP.ctr(_br), 0, pw, ph, Color(0, 0, 0, 255), YRP.ctr(4))
			end
		end

		-- Role Button --
		_rol.gr = createD("YButton", _rol, _rol:GetWide(), _rol:GetTall(), 0, 0)
		function _rol.gr:Paint(pw, ph)
			--hook.Run("YButtonPaint", self, pw, ph) -- surfaceButton(self, pw, ph, YRP.lang_string("LID_moreinformation"))
			if self:IsHovered() then
				draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 60))
			end
		end
		_rol.gr:SetText("")
		function _rol.gr:DoClick()
			pmid = 1
			_rm.pms:Clear()
			for i, pmtab in pairs(rol.pms) do
				local dmp = createD("DModelPanel", _rm.pms, YRP.ctr(400), YRP.ctr(400), -YRP.ctr(100) + (i - 1) * YRP.ctr(150), YRP.ctr(50))
				dmp:SetModel(pmtab.string_model)
				local randsize = math.Rand(pmtab.float_size_min, pmtab.float_size_max)
				dmp.Entity:SetModelScale(randsize, 0)

				local bpm = createD("DButton", dmp, YRP.ctr(200), YRP.ctr(400), YRP.ctr(100), YRP.ctr(0))
				bpm.id = i
				bpm:SetText("")
				function bpm:Paint(pw, ph)
					if self.id == pmid then
						draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 10))
					end
				end
				function bpm:DoClick()
					pmid = self.id
				end

				_rm.pms:AddPanel(dmp)
			end

			_rm.info.rolename = rol.string_name
			_rm.info.rolecolor = rol.string_color

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
	if parent:IsValid() and mainparent:IsValid() then
		parent:SetWide(mainparent:GetWide() - YRP.ctr(140))
		local _bou = createD("DPanel", parent, YRP.ctr(50), YRP.ctr(200), 0, 0)
		function _bou:Paint(pw, ph)
			surfaceText("➔", "roleInfoHeader", pw/2, ph/2, Color(255, 255, 255), 1, 1)
		end
		if parent.AddPanel != nil then
			parent:AddPanel(_bou)
		end
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
		local _rr = createD("DHorizontalScroller", parent.content, YRP.ctr(400), YRP.ctr(400), 0, 0) --parent:GetWide() - 2*YRP.ctr(parent:GetSpacing()), YRP.ctr(400), 0, 0)
		_rr:SetOverlap(YRP.ctr(-30))
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
		local _grp = createD("DYRPCollapsibleCategory", parent, parent:GetWide() - YRP.ctr(40), YRP.ctr(200), YRP.ctr(0), YRP.ctr(0))
		_grp:SetHeader(grp.string_name)
		_grp:SetSpacing(30)
		_grp.color = string.Explode(",", grp.string_color)
		_grp.color = Color(_grp.color[1], _grp.color[2], _grp.color[3])
		local headeralpha = 200
		local contentalpha = 100
		_grp.tbl = grp
		_grp.locked = tobool(grp.bool_locked)
		function _grp:PaintHeader(pw, ph)
			local _hl = 0
			if self.header:IsHovered() then
				_hl = 70
			end
			draw.RoundedBoxEx(YRP.ctr(30), 0, 0, pw, ph, Color(self.color.r + _hl, self.color.g + _hl, self.color.b + _hl, headeralpha), true, true, !self:IsOpen(), !self:IsOpen())
			local _x = ph / 2
			if grp.string_icon != "" then
				_x = YRP.ctr(10) + ph + YRP.ctr(10)
			end
			local name = self.tbl.string_name
			if tonumber(self.tbl.int_parentgroup) == 0 then
				name = YRP.lang_string("LID_faction") .. ": " .. name
			end
			surfaceText(name, "roleInfoHeader", _x, ph / 2, Color(255, 255, 255), 0, 1)

			local _box = YRP.ctr(50)
			local _dif = 50
			local _br = (ph - _box)/2
			local _tog = "▼"
			if self:IsOpen() then
				_tog = "▲"
			end
			draw.RoundedBox(0, pw - _box - _br, _br, _box, _box, Color(self.color.r - _dif, self.color.g - _dif, self.color.b - _dif, headeralpha))
			surfaceText(_tog, "roleInfoHeader", pw - _box / 2 - _br, _br + _box / 2, Color(255, 255, 255), 1, 1)
			if tobool(grp.bool_locked) then
				YRP.DrawIcon(YRP.GetDesignIcon("lock"), ph - YRP.ctr(8), ph - YRP.ctr(8), pw - 2 * ph, YRP.ctr(4), Color(255, 0, 0, 200))
			end
		end
		function _grp:PaintContent(pw, ph)
			draw.RoundedBoxEx(YRP.ctr(30), 0, 0, pw, ph, Color(self.color.r + 40, self.color.g + 40, self.color.b + 40, contentalpha), false, false, true, true)
		end
		_grp:SetHeaderHeight(YRP.ctr(100))

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
			_grp.icon = createD("DHTML", _grp, _grp:GetTall() - YRP.ctr(16), _grp:GetTall() - YRP.ctr(16), YRP.ctr(26), YRP.ctr(8))
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
		_rm = createD("YFrame", nil, FW(), FH(), PX(), PY())
		_rm:SetMinWidth(FW())
		_rm:SetMinHeight(FH())
		_rm:Center()
		_rm:Sizable(true)
		_rm:ShowCloseButton(true)
		_rm:SetTitle("LID_rolemenu")
		_rm:SetHeaderHeight(50)
		_rm:SetBackgroundBlur(true)
		_rm.systime = SysTime()
		function _rm.ChangedSize()
			_rm.pl:SetSize(_rm:GetWide() - _rm.info:GetWide() - 3 * YRP.ctr(20), _rm:GetTall() - _rm:GetHeaderHeight() - YRP.ctr(20 + 20))
			_rm.pl:SetPos(YRP.ctr(20), _rm:GetHeaderHeight() + YRP.ctr(20))

			for i, v in pairs(_rm.pl:GetChildren()) do
				v:SetWide(_rm:GetWide() - _rm.info:GetWide() - 3 * YRP.ctr(20))
			end

			_rm.info:SetSize(YRP.ctr(800), _rm:GetTall() - _rm:GetHeaderHeight() - YRP.ctr(20 + 20))
			_rm.info:SetPos(_rm:GetWide() - YRP.ctr(20) - YRP.ctr(800), _rm:GetHeaderHeight() + YRP.ctr(20))
		end
		function _rm:Paint(pw, ph)
			Derma_DrawBackgroundBlur(self, self.systime)
			hook.Run("YFramePaint", self, pw, ph) --surfaceWindow(self, pw, ph, YRP.lang_string("LID_rolemenu") .. " [PROTOTYPE]")
		end

		_rm.info = createD("DPanel", _rm, YRP.ctr(800), _rm:GetTall() - _rm:GetHeaderHeight() - YRP.ctr(20 + 20), _rm:GetWide() - YRP.ctr(20) - YRP.ctr(800), _rm:GetHeaderHeight() + YRP.ctr(20))
		_rm.info.rolename = YRP.lang_string("LID_none")
		_rm.info.rolesala = YRP.lang_string("LID_none")
		local headercolor = Color(40, 40, 40, 255)
		local contentcolor = Color(40, 40, 40, 100)
		function _rm.info:Paint(pw, ph)
			if _rm.info.rolename == YRP.lang_string("LID_none") then return end

			-- Role Appearance --
			draw.RoundedBox(0, 0, 0, pw, YRP.ctr(50), headercolor)
			surfaceText(YRP.lang_string("LID_appearance"), "roleInfoHeader", YRP.ctr(25), YRP.ctr(25), Color(255, 255, 255), 0, 1)
			draw.RoundedBox(0, 0, YRP.ctr(50), pw, YRP.ctr(400), contentcolor)

			-- Role Name --
			draw.RoundedBox(0, 0, YRP.ctr(500), pw, YRP.ctr(50), headercolor)
			surfaceText(YRP.lang_string("LID_role"), "roleInfoHeader", YRP.ctr(25), YRP.ctr(500 + 25), Color(255, 255, 255), 0, 1)
			draw.RoundedBox(0, 0, YRP.ctr(500 + 50), pw, YRP.ctr(50), contentcolor)
			surfaceText(self.rolename, "roleInfoText", YRP.ctr(25), YRP.ctr(500 + 50 + 25), Color(255, 255, 255), 0, 1)

			-- Role Description --
			draw.RoundedBox(0, 0, YRP.ctr(650), pw, YRP.ctr(50), headercolor)
			surfaceText(YRP.lang_string("LID_description"), "roleInfoHeader", YRP.ctr(25), YRP.ctr(650 + 25), Color(255, 255, 255), 0, 1)
			draw.RoundedBox(0, 0, YRP.ctr(650 + 50), pw, YRP.ctr(200), contentcolor)

			-- Role Equipment --
			draw.RoundedBox(0, 0, YRP.ctr(950), pw, YRP.ctr(50), headercolor)
			surfaceText(YRP.lang_string("LID_sweps"), "roleInfoHeader", YRP.ctr(25), YRP.ctr(950 + 25), Color(255, 255, 255), 0, 1)
			draw.RoundedBox(0, 0, YRP.ctr(950 + 50), pw, YRP.ctr(100), contentcolor)

			-- Role Salary --
			draw.RoundedBox(0, 0, YRP.ctr(1150), pw, YRP.ctr(50), headercolor)
			surfaceText(YRP.lang_string("LID_salary"), "roleInfoHeader", YRP.ctr(25), YRP.ctr(1150 + 25), Color(255, 255, 255), 0, 1)
			draw.RoundedBox(0, 0, YRP.ctr(1150 + 50), pw, YRP.ctr(50), contentcolor)
			surfaceText(formatMoney(self.rolesala, LocalPlayer()), "roleInfoText", YRP.ctr(25), YRP.ctr(1150 + 50 + 25), Color(255, 255, 255), 0, 1)
		end

		_rm.pms = createD("DHorizontalScroller", _rm.info, YRP.ctr(800), YRP.ctr(400), 0, YRP.ctr(50))
		_rm.pms:SetOverlap(100)

		_rm.infodesc = createD("RichText", _rm.info, YRP.ctr(800 - 20 - 20), YRP.ctr(200), YRP.ctr(20), YRP.ctr(650 + 50))
		function _rm.infodesc:Paint(pw, ph)
			if _rm.info.rolename == YRP.lang_string("LID_none") then return end
			--draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 200))
		end

		_rm.infosweps = createD("RichText", _rm.info, YRP.ctr(800 - 20 - 20), YRP.ctr(100), YRP.ctr(20), YRP.ctr(950 + 50))
		function _rm.infosweps:Paint(pw, ph)
			if _rm.info.rolename == YRP.lang_string("LID_none") then return end
			--draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 200))
		end

		_rm.infobutton = createD("YButton", _rm.info, YRP.ctr(800 - 2 * 20), YRP.ctr(100), YRP.ctr(20), _rm.info:GetTall() - YRP.ctr(100 + 20))
		_rm.infobutton:SetText("LID_becomerole")
		_rm.infobutton.rolename = ""
		function _rm.infobutton:Paint(pw, ph)
			if _rm.info.rolename == YRP.lang_string("LID_none") then return end
			hook.Run("YButtonPaint", self, pw, ph) -- surfaceButton(self, pw, ph, YRP.lang_string("LID_becomerole"))
		end
		function _rm.infobutton:DoClick()
			if self.uniqueID != nil then
				net.Start("wantRole")
					net.WriteInt(self.uniqueID, 16)
					net.WriteInt(pmid, 16)
				net.SendToServer()
				_rm:Close()
			end
		end

		-- Roles
		_rm.pl = createD("DPanelList", _rm, _rm:GetWide() - _rm.info:GetWide() - 3 * YRP.ctr(20), _rm:GetTall() - _rm:GetHeaderHeight() - YRP.ctr(20 + 20), YRP.ctr(20), _rm:GetHeaderHeight() + YRP.ctr(20))
		_rm.pl:EnableVerticalScrollbar(true)
		_rm.pl:SetSpacing(10)
		_rm.pl:SetNoSizing(true)

		function _rm.pl:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, contentcolor)
		end

		getGroups(0, _rm.pl)

		_rm:MakePopup()
	end
end
