--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

ROLEMENU = ROLEMENU or {}
ROLEMENU.open = false
local _info = nil

function ToggleRoleMenu()
	if !ROLEMENU.open and isNoMenuOpen() then
		OpenRoleMenu()
	else
		CloseRoleMenu()
	end
end

function CloseRoleMenu()
	ROLEMENU.open = false
	if ROLEMENU.window != nil then
		closeMenu()
		ROLEMENU.window:Remove()
		ROLEMENU.window = nil
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
		local BR = 0
		local RW = YRP.ctr(600)
		local RH = YRP.ctr(150)
		local _rol = createD("DPanel", parent, RW, RH, 0, 0)
		function _rol:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(40, 40, 40, 255))
			--drawRBBR(0, 0, 0, pw, ph, Color(160, 160, 160, 255), 1)
		end
		_rol.tbl = rol

		-- Role Playermodel --
		local pm = _rol.tbl.pms[1] or {}
		if pm.string_model != nil and pm.string_model != "" then
			local p = createD("DModelPanel", _rol, _rol:GetTall() - 2 * BR, _rol:GetTall() - 2 * BR, BR, BR)
			p:SetModel(pm.string_model)
			--local randsize = math.Rand(pm.float_size_min, pm.float_size_max)
			--p.Entity:SetModelScale(randsize, 0)

			if p.Entity:IsValid() then
				function p:LayoutEntity( ent )
					ent:SetSequence( ent:LookupSequence("menu_gman") )
					p:RunAnimation()
					return
				end

				local head = p.Entity:LookupBone( "ValveBiped.Bip01_Head1" )
				if head then
					local eyepos = p.Entity:GetBonePosition( head )
					if eyepos then
						p:SetLookAt( eyepos )
						p:SetCamPos( eyepos-Vector( -18, 0, 0 ) )	-- Move cam in front of eyes
						p.Entity:SetEyeTarget( eyepos-Vector( -18, 0, 0 ) )
					end
				end
			end
		end

		-- Role Name --
		_rol.rn = createD("DPanel", _rol, _rol:GetWide(), RH, 0, 0)
		_rol.rn.rolename = _rol.rn:GetParent().tbl.string_name
		_rol.rn.rolecolor = StringToColor(_rol.rn:GetParent().tbl.string_color)
		function _rol.rn:Paint(pw, ph)
			draw.SimpleText(self.rolename, "Y_24_700", ph + YRP.ctr(10), ph / 3, Color(255, 255, 255), 0, 1)
		end

		-- Role Salary --
		_rol.rs = createD("DPanel", _rol, _rol:GetWide(), RH, 0, 0)
		_rol.rs.rolesalary = _rol.rs:GetParent().tbl.int_salary
		_rol.rs.rolecolor = StringToColor(_rol.rn:GetParent().tbl.string_color)
		function _rol.rs:Paint(pw, ph)
			draw.SimpleText(MoneyFormatRounded(self.rolesalary, 0), "Y_20_700", ph + YRP.ctr(10), ph / 3 * 2, Color(255, 255, 255, 255), 0, 1)
		end

		-- Role MaxAmount --
		if tonumber(rol.int_maxamount) > 0 then
			_rol.ma = createD("DPanel", _rol, _rol:GetWide(), RH, 0, 0)
			function _rol.ma:Paint(pw, ph)
				local _br = 4
				pw = pw - 2 * YRP.ctr(4)
				ph = ph - 1 * YRP.ctr(4)

				--Background
				local w = 80
				local h = 40
				local br = 20
				draw.RoundedBox(4, pw - YRP.ctr(w + br), ph - YRP.ctr(h + br), YRP.ctr(w), YRP.ctr(h), Color(200, 200, 200, 60))

				--Maxamount
				--draw.RoundedBox(0, YRP.ctr(_br), 0, (rol.int_uses / rol.int_maxamount) * pw, ph, Color(255, 0, 0, 255))
				local color = Color(255, 255, 255)
				if tonumber(rol.int_uses) == tonumber(rol.int_maxamount) then
					color = Color(255, 0, 0)
				end
				draw.SimpleText(self:GetParent().tbl.int_uses .. "/" .. self:GetParent().tbl.int_maxamount, "Y_20_700", pw - YRP.ctr(w / 2 + br), ph - YRP.ctr(h / 2 + br) * 1.1, color, 1, 1)

				--BR
				--drawRBBR(0, YRP.ctr(_br), 0, pw, ph, Color(0, 0, 0, 255), YRP.ctr(4))
			end
		end

		-- Role Button --
		_rol.gr = createD("YButton", _rol, _rol:GetWide(), _rol:GetTall(), 0, 0)
		function _rol.gr:Paint(pw, ph)
			--hook.Run("YButtonPaint", self, pw, ph) -- surfaceButton(self, pw, ph, YRP.lang_string("LID_moreinformation"))
			if self:IsHovered() then
				draw.RoundedBox(0, 0, 0, pw, ph, Color(80, 80, 80, 60))
			end
		end
		_rol.gr:SetText("")
		function _rol.gr:DoClick()
			pmid = 1
			ROLEMENU.pms:Clear()
			for i, pmtab in pairs(rol.pms) do
				local bgpm = createD("DPanel", ROLEMENU.pms, YRP.ctr(200), YRP.ctr(400), (i - 1) * YRP.ctr(200), 0)
				bgpm.id = i
				function bgpm:Paint(pw, ph)
					if self.id == pmid then
						draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 10))
					end
				end

				local dmp = createD("DModelPanel", bgpm, YRP.ctr(200), YRP.ctr(400), 0, 0)
				dmp:SetModel(pmtab.string_model)
				local randsize = math.Rand(pmtab.float_size_min, pmtab.float_size_max)
				if wk(dmp.Entity) then
					dmp.Entity:SetModelScale(randsize + 1, 0)
					dmp.Entity:SetPos(Vector(0, 0, - 40))
				end

				local bpm = createD("DButton", dmp, YRP.ctr(200), YRP.ctr(400), 0, 0)
				bpm.id = i
				bpm:SetText("")
				function bpm:Paint(pw, ph)
					--
				end
				function bpm:DoClick()
					pmid = self.id
				end

				ROLEMENU.pms:AddPanel(bgpm)
			end

			ROLEMENU.info.rolename = rol.string_name
			ROLEMENU.info.rolecolor = rol.string_color

			ROLEMENU.infodesc:SetText("")
			ROLEMENU.infodesc:SetFontInternal("roleInfoText")
			ROLEMENU.infodesc:InsertColorChange(255, 255, 255, 255)
			ROLEMENU.infodesc:AppendText(rol.string_description)

			ROLEMENU.infosweps:SetText("")
			ROLEMENU.infosweps:SetFontInternal("roleInfoText")
			ROLEMENU.infosweps:InsertColorChange(255, 255, 255, 255)
			ROLEMENU.infosweps:AppendText(string.Implode(", ", string.Explode(",", rol.string_sweps)))

			ROLEMENU.info.rolesala = rol.int_salary
			ROLEMENU.info.roleswep = rol.string_sweps

			ROLEMENU.infobutton.rolename = rol.string_name
			ROLEMENU.infobutton.uniqueID = rol.uniqueID
		end

		if tonumber(rol.uniqueID) == 1 then
			_rol.gr:DoClick()
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
			surfaceText("➔", "roleInfoHeader", pw / 2, ph / 2, Color(255, 255, 255), 1, 1)
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
		local RRW = YRP.ctr(600)
		local RRH = YRP.ctr(150)
		local _rr = createD("DHorizontalScroller", parent.content, RRW, RRH, 0, 0) --parent:GetWide() - 2*YRP.ctr(parent:GetSpacing()), YRP.ctr(400), 0, 0)
		_rr:SetOverlap(YRP.ctr(-30))
		function _rr:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 0))
		end

		addRole(rol, _rr, parent)

		parent:Add(_rr)
	end
end

function getRoles(uid, parent)
	net.Receive("get_grp_roles", function(len)
		local _roles = net.ReadTable()

		for i, rol in pairs(_roles) do
			if rol != nil and tonumber(rol.int_prerole) <= 0 and tonumber(rol.bool_visible) == 1 then
				addRoleRow(rol, parent)
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
		local _grp = createD("DYRPCollapsibleCategory", parent, parent:GetWide() - YRP.ctr(80), YRP.ctr(200), YRP.ctr(0), YRP.ctr(0))
		_grp:SetHeader(grp.string_name)
		_grp:SetSpacing(30)
		_grp.color = string.Explode(",", grp.string_color)
		_grp.color = Color(_grp.color[1], _grp.color[2], _grp.color[3])
		local headeralpha = 255
		local contentalpha = 255
		_grp.tbl = grp
		_grp.locked = tobool(grp.bool_locked)
		local BR = YRP.ctr(30)
		function _grp:PaintHeader(pw, ph)
			local _hl = 0
			if self.header:IsHovered() then
				_hl = 70
			end
			draw.RoundedBoxEx(0, 0, 0, pw, ph, Color(self.color.r + _hl, self.color.g + _hl, self.color.b + _hl, headeralpha), true, true, !self:IsOpen(), !self:IsOpen())
			local _x = ph / 2
			if grp.string_icon != "" then
				_x = ph
			end
			local name = self.tbl.string_name
			if tonumber(self.tbl.int_parentgroup) == 0 then
				name = YRP.lang_string("LID_faction") .. ": " .. name
			end
			draw.SimpleText(name, "roleInfoHeader", _x, ph / 2, Color(255, 255, 255), 0, 1)

			local _box = YRP.ctr(50)
			local _dif = 50
			local _br = (ph - _box) / 2
			local _tog = "▼"
			if self:IsOpen() then
				_tog = "▲"
			end
			draw.RoundedBox(0, pw - _box - _br, _br, _box, _box, Color(self.color.r - _dif, self.color.g - _dif, self.color.b - _dif, headeralpha))
			draw.SimpleText(_tog, "roleInfoHeader", pw - _box / 2 - _br, _br + _box / 2, Color(255, 255, 255), 1, 1)
			if tobool(grp.bool_locked) then
				YRP.DrawIcon(YRP.GetDesignIcon("lock"), ph - YRP.ctr(8), ph - YRP.ctr(8), pw - 2 * ph, YRP.ctr(4), Color(255, 0, 0, 200))
			end
		end
		function _grp:PaintContent(pw, ph)
			draw.RoundedBoxEx(0, 0, 0, pw, ph, Color(self.color.r - 200, self.color.g - 200, self.color.b - 200, contentalpha), false, false, true, true)
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

		if tonumber(grp.uniqueID) == 1 then
			_grp.header:DoClick()
		end

		if grp.string_icon != "" then
			_grp.icon = createD("DHTML", _grp, _grp:GetTall() - 2 * BR, _grp:GetTall() - 2 * BR, BR, BR)
			_grp.icon:SetHTML(GetHTMLImage(grp.string_icon, _grp.icon:GetWide(), _grp.icon:GetTall()))
		end

		if pa(parent) then
			if tostring(grp.int_parentgroup) != "0" and parent.Add then
				parent:Add(_grp)
			elseif parent.AddItem then
				parent:AddItem(_grp)
			else
				YRP.msg("error", "grp.int_parentgroup: " .. type(grp.int_parentgroup) .. " | " .. "parent.Add: " .. tostring(parent.Add))
			end
		end

		if parent.Rebuild then
			--parent:Rebuild()
		end

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

function OpenRoleMenu()
	openMenu()
	if GetGlobalDBool("bool_players_can_switch_role", false) then
		ROLEMENU.open = true
		ROLEMENU.window = createD("YFrame", nil, BFW(), BFH(), BPX(), BPY())
		ROLEMENU.window:SetMinWidth(BFW())
		ROLEMENU.window:SetMinHeight(BFH())
		ROLEMENU.window:Center()
		ROLEMENU.window:Sizable(true)
		ROLEMENU.window:SetTitle("LID_rolemenu")
		ROLEMENU.window:SetHeaderHeight(50)
		ROLEMENU.window:SetBackgroundBlur(true)
		ROLEMENU.window.systime = SysTime()
		--[[function ROLEMENU.window.ChangedSize()
			ROLEMENU.window.pl:SetSize(self:GetWide() - ROLEMENU.window.info:GetWide() - 3 * YRP.ctr(20), self:GetTall() - self:GetHeaderHeight() - YRP.ctr(20 + 20))
			ROLEMENU.window.pl:SetPos(YRP.ctr(20), self:GetHeaderHeight() + YRP.ctr(20))

			for i, v in pairs(ROLEMENU.window.pl:GetChildren()) do
				v:SetWide(self:GetWide() - ROLEMENU.window.info:GetWide() - 3 * YRP.ctr(20))
			end

			ROLEMENU.window.info:SetSize(YRP.ctr(800), self:GetTall() - self:GetHeaderHeight() - YRP.ctr(20 + 20))
			ROLEMENU.window.info:SetPos(self:GetWide() - YRP.ctr(20) - YRP.ctr(800), self:GetHeaderHeight() + YRP.ctr(20))
		end]]
		function ROLEMENU.window:Paint(pw, ph)
			Derma_DrawBackgroundBlur(self, self.systime)
			hook.Run("YFramePaint", self, pw, ph) --surfaceWindow(self, pw, ph, YRP.lang_string("LID_ROLEMENU.window") .. " [PROTOTYPE]")
		end

		ROLEMENU.window:MakePopup()

		CreateRoleMenuContent(ROLEMENU.window.con)
	end
end

function CreateRoleMenuContent(parent)
	ROLEMENU.content = parent
	ROLEMENU.info = createD("DPanel", ROLEMENU.content, YRP.ctr(800), ROLEMENU.content:GetTall() - YRP.ctr(20 + 20), ROLEMENU.content:GetWide() - YRP.ctr(20) - YRP.ctr(800), YRP.ctr(20))
	ROLEMENU.info.rolename = YRP.lang_string("LID_none")
	ROLEMENU.info.rolesala = YRP.lang_string("LID_none")
	local headercolor = Color(40, 40, 40, 255)
	local contentcolor = Color(40, 40, 40, 100)
	function ROLEMENU.info:Paint(pw, ph)
		if ROLEMENU.info.rolename == YRP.lang_string("LID_none") then return end

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

	ROLEMENU.pms = createD("DHorizontalScroller", ROLEMENU.info, YRP.ctr(800), YRP.ctr(400), 0, YRP.ctr(50))
	ROLEMENU.pms:SetOverlap(-10)

	ROLEMENU.infodesc = createD("RichText", ROLEMENU.info, YRP.ctr(800 - 20 - 20), YRP.ctr(200), YRP.ctr(20), YRP.ctr(650 + 50))
	function ROLEMENU.infodesc:Paint(pw, ph)
		if ROLEMENU.info.rolename == YRP.lang_string("LID_none") then return end
		--draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 200))
	end

	ROLEMENU.infosweps = createD("RichText", ROLEMENU.info, YRP.ctr(800 - 20 - 20), YRP.ctr(100), YRP.ctr(20), YRP.ctr(950 + 50))
	function ROLEMENU.infosweps:Paint(pw, ph)
		if ROLEMENU.info.rolename == YRP.lang_string("LID_none") then return end
		--draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 200))
	end

	ROLEMENU.infobutton = createD("YButton", ROLEMENU.info, YRP.ctr(800 - 2 * 20), YRP.ctr(100), YRP.ctr(20), ROLEMENU.info:GetTall() - YRP.ctr(100 + 20))
	ROLEMENU.infobutton:SetText("LID_becomerole")
	ROLEMENU.infobutton.rolename = ""
	function ROLEMENU.infobutton:Paint(pw, ph)
		if ROLEMENU.info.rolename == YRP.lang_string("LID_none") then return end
		hook.Run("YButtonPaint", self, pw, ph) -- surfaceButton(self, pw, ph, YRP.lang_string("LID_becomerole"))
	end
	function ROLEMENU.infobutton:DoClick()
		if self.uniqueID != nil then
			net.Start("wantRole")
				net.WriteInt(self.uniqueID, 16)
				net.WriteInt(pmid, 16)
			net.SendToServer()
			ROLEMENU.content:GetParent():Close()
		end
	end

	-- Roles
	ROLEMENU.pl = createD("DPanelList", ROLEMENU.content, ROLEMENU.content:GetWide() - ROLEMENU.info:GetWide() - 3 * YRP.ctr(20), ROLEMENU.content:GetTall() - YRP.ctr(20 + 20), YRP.ctr(20), YRP.ctr(20))
	ROLEMENU.pl:EnableVerticalScrollbar(true)
	ROLEMENU.pl:SetSpacing(10)
	--ROLEMENU.pl:SetNoSizing(true)

	function ROLEMENU.pl:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, contentcolor)
	end

	getGroups(0, ROLEMENU.pl)
end
