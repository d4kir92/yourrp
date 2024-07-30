--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
--#roles #rolesmenu #rolemenu #groups #factions
ROLEMENU = ROLEMENU or {}
ROLEMENU.open = false
local _info = nil
function YRPToggleRoleMenu()
	if not ROLEMENU.open and YRPIsNoMenuOpen() then
		OpenRoleMenu()
	else
		CloseRoleMenu()
	end
end

function CloseRoleMenu()
	ROLEMENU.open = false
	if ROLEMENU.window ~= nil then
		YRPCloseMenu()
		ROLEMENU.window:Remove()
		ROLEMENU.window = nil
	elseif _info ~= nil then
		YRPCloseMenu()
		_info:Remove()
		_info = nil
	end
end

local _pr = {}
local _adminonly = Material("icon16/shield.png")
local pmid = 1
function createRoleBox(rol, parent, mainparent)
	if rol ~= nil then
		local BR = 0
		local RW = YRP:ctr(600)
		local RH = YRP:ctr(150)
		local _rol = YRPCreateD("DPanel", parent, RW, RH, 0, 0)
		function _rol:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, YRPInterfaceValue("YFrame", "BG"))
			--drawRBBR(0, 0, 0, pw, ph, Color( 160, 160, 160, 255), 1)
		end

		_rol.tbl = rol
		-- Role Playermodel --
		local pm = _rol.tbl.pms[1] or {}
		if pm.string_model ~= nil and pm.string_model ~= "" then
			local p = YRPCreateD("DModelPanel", _rol, _rol:GetTall() - 2 * BR, _rol:GetTall() - 2 * BR, BR, BR)
			p:SetModel(pm.string_model)
			--local randsize = math.Rand(pm.float_size_min, pm.float_size_max)
			--p.Entity:SetModelScale(randsize, 0)
			if p.Entity:IsValid() then
				function p:LayoutEntity(ent)
					ent:SetSequence(ent:LookupSequence("menu_gman"))
					p:RunAnimation()

					return
				end

				local head = p.Entity:LookupBone("ValveBiped.Bip01_Head1")
				if head then
					local eyepos = p.Entity:GetBonePosition(head)
					if eyepos then
						p:SetLookAt(eyepos)
						p:SetCamPos(eyepos - Vector(-18, 0, 0)) -- Move cam in front of eyes
						p.Entity:SetEyeTarget(eyepos - Vector(-18, 0, 0))
					end
				end
			end
		end

		-- Role Name --
		_rol.rn = YRPCreateD("DPanel", _rol, _rol:GetWide(), RH, 0, 0)
		_rol.rn.rolename = _rol.rn:GetParent().tbl.string_name
		_rol.rn.rolecolor = StringToColor(_rol.rn:GetParent().tbl.string_color)
		function _rol.rn:Paint(pw, ph)
			draw.SimpleText(self.rolename, "Y_24_500", ph + YRP:ctr(10), ph / 3, Color(255, 255, 255, 255), 0, 1)
		end

		-- Role Salary --
		_rol.rs = YRPCreateD("DPanel", _rol, _rol:GetWide(), RH, 0, 0)
		_rol.rs.rolesalary = _rol.rs:GetParent().tbl.int_salary
		_rol.rs.rolecolor = StringToColor(_rol.rn:GetParent().tbl.string_color)
		function _rol.rs:Paint(pw, ph)
			draw.SimpleText(MoneyFormatRounded(self.rolesalary, 0), "Y_20_500", ph + YRP:ctr(10), ph / 3 * 2, Color(255, 255, 255, 255), 0, 1)
		end

		-- Role MaxAmount --
		if tonumber(rol.int_maxamount) > 0 then
			_rol.ma = YRPCreateD("DPanel", _rol, _rol:GetWide(), RH, 0, 0)
			function _rol.ma:Paint(pw, ph)
				local _br = 4
				pw = pw - 2 * YRP:ctr(4)
				ph = ph - 1 * YRP:ctr(4)
				--Background
				local w = 80
				local h = 40
				local br = 20
				draw.RoundedBox(4, pw - YRP:ctr(w + br), ph - YRP:ctr(h + br), YRP:ctr(w), YRP:ctr(h), Color(200, 200, 200, 60))
				--Maxamount
				--draw.RoundedBox(0, YRP:ctr(_br), 0, (rol.int_uses / rol.int_maxamount) * pw, ph, Color( 255, 0, 0, 255) )
				local color = Color(255, 255, 255, 255)
				if tonumber(rol.int_uses) == tonumber(rol.int_maxamount) then
					color = Color(0, 255, 0)
				end

				draw.SimpleText(self:GetParent().tbl.int_uses .. "/" .. self:GetParent().tbl.int_maxamount, "Y_20_500", pw - YRP:ctr(w / 2 + br), ph - YRP:ctr(h / 2 + br) * 1.1, color, 1, 1)
				--BR
				--drawRBBR(0, YRP:ctr(_br), 0, pw, ph, Color( 0, 0, 0, 255 ), YRP:ctr(4) )
			end
		end

		-- Role Button --
		_rol.gr = YRPCreateD("YButton", _rol, _rol:GetWide(), _rol:GetTall(), 0, 0)
		function _rol.gr:Paint(pw, ph)
			if self:IsHovered() then
				draw.RoundedBox(0, 0, 0, pw, ph, Color(80, 80, 80, 60))
			end
		end

		_rol.gr:SetText("")
		function _rol.gr:DoClick()
			pmid = 1
			ROLEMENU.pms:Clear()
			for i, pmtab in pairs(rol.pms) do
				local bgpm = YRPCreateD("DPanel", ROLEMENU.pms, YRP:ctr(200), YRP:ctr(400), (i - 1) * YRP:ctr(200), 0)
				bgpm.id = i
				function bgpm:Paint(pw, ph)
					if self.id == pmid then
						draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 10))
					end
				end

				local dmp = YRPCreateD("DModelPanel", bgpm, YRP:ctr(200), YRP:ctr(400), 0, 0)
				timer.Simple(
					i * 0.3,
					function()
						if IsValid(dmp) then
							dmp:SetModel(pmtab.string_model)
							local randsize = math.Rand(pmtab.float_size_min, pmtab.float_size_max)
							if IsNotNilAndNotFalse(dmp.Entity) then
								dmp.Entity:SetModelScale(randsize + 1, 0)
								dmp.Entity:SetPos(Vector(0, 0, -40))
							end
						end
					end
				)

				local bpm = YRPCreateD("DButton", dmp, YRP:ctr(200), YRP:ctr(400), 0, 0)
				bpm.id = i
				bpm:SetText("")
				function bpm:Paint(pw, ph)
				end

				--
				function bpm:DoClick()
					pmid = self.id
				end

				ROLEMENU.pms:AddPanel(bgpm)
			end

			ROLEMENU.info.rolename = rol.string_name
			ROLEMENU.info.rolecolor = rol.string_color
			ROLEMENU.infodesc:SetText("")
			if ROLEMENU.infodesc.SetUnderlineFont ~= nil then
				ROLEMENU.infodesc:SetUnderlineFont("Y_20_500")
			end

			ROLEMENU.infodesc:SetFontInternal("Y_20_500")
			ROLEMENU.infodesc:InsertColorChange(255, 255, 255, 255)
			ROLEMENU.infodesc:AppendText(rol.string_description)
			ROLEMENU.infosweps:SetText("")
			if ROLEMENU.infosweps.SetUnderlineFont ~= nil then
				ROLEMENU.infosweps:SetUnderlineFont("Y_20_500")
			end

			ROLEMENU.infosweps:SetFontInternal("Y_20_500")
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

		if parent.AddPanel ~= nil then
			parent:AddPanel(_rol)
		end
	end
end

function createBouncer(parent, mainparent)
	if parent:IsValid() and mainparent:IsValid() then
		parent:SetWide(mainparent:GetWide() - YRP:ctr(140))
		local _bou = YRPCreateD("DPanel", parent, YRP:ctr(50), YRP:ctr(200), 0, 0)
		function _bou:Paint(pw, ph)
			surfaceText("➔", "Y_24_500", pw / 2, ph / 2, Color(255, 255, 255, 255), 1, 1)
		end

		if parent.AddPanel ~= nil then
			parent:AddPanel(_bou)
		end
	end
end

function addPreRole(rol, parent, mainparent)
	_pr[rol.uniqueID] = parent
	local _tmp = createBouncer(parent, mainparent)
	createRoleBox(rol, parent, mainparent)
	getPreRole(rol.uniqueID, _pr[rol.uniqueID], mainparent)
end

function getPreRole(uid, parent, mainparent)
	net.Receive(
		"nws_yrp_get_rol_prerole",
		function(len)
			local _prerole = net.ReadTable()
			if _prerole.int_prerole ~= nil then
				addPreRole(_prerole, _pr[_prerole.int_prerole], mainparent)
			end
		end
	)

	net.Start("nws_yrp_get_rol_prerole")
	net.WriteString(uid)
	net.SendToServer()
end

function addRole(rol, parent, mainparent)
	createRoleBox(rol, parent, mainparent)
	_pr[rol.uniqueID] = parent
	getPreRole(rol.uniqueID, _pr[rol.uniqueID], mainparent)
end

function addRoleRow(rol, parent)
	if YRPPanelAlive(parent) then
		local RRW = YRP:ctr(600)
		local RRH = YRP:ctr(150)
		local _rr = YRPCreateD("DHorizontalScroller", parent.content, RRW, RRH, 0, 0) --parent:GetWide() - 2*YRP:ctr(parent:GetSpacing() ), YRP:ctr(400), 0, 0)
		_rr:SetOverlap(YRP:ctr(-30))
		function _rr:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 0))
		end

		addRole(rol, _rr, parent)
		parent:Add(_rr)
	end
end

function getRoles(uid, parent)
	net.Receive(
		"nws_yrp_get_grp_roles",
		function(len)
			local _roles = net.ReadTable()
			for i, rol in SortedPairsByMemberValue(_roles, "int_position") do
				if rol ~= nil and tonumber(rol.int_prerole) <= 0 then
					addRoleRow(rol, parent)
				end
			end
		end
	)

	--getGroups(uid, parent)
	net.Start("nws_yrp_get_grp_roles")
	net.WriteString(uid)
	net.SendToServer()
	getGroups(uid, parent)
end

function addGroup(grp, parent)
	if parent ~= NULL and YRPPanelAlive(parent) then
		local _grp = YRPCreateD("DYRPCollapsibleCategory", parent, parent:GetWide() - YRP:ctr(80), YRP:ctr(200), YRP:ctr(0), YRP:ctr(0))
		_grp:SetHeader(grp.string_name)
		_grp:SetSpacing(30)
		_grp.color = string.Explode(",", grp.string_color)
		_grp.color = Color(_grp.color[1], _grp.color[2], _grp.color[3])
		local headeralpha = YRPInterfaceValue("YButton", "HC").a
		local contentalpha = YRPInterfaceValue("YFrame", "BG").a
		local contentdarker = 8
		_grp.tbl = grp
		_grp.locked = tobool(grp.bool_locked)
		local BR = YRP:ctr(30)
		function _grp:PaintHeader(pw, ph)
			local _hl = 0
			if self.header:IsHovered() then
				_hl = 70
			end

			draw.RoundedBoxEx(0, 0, 0, pw, ph, Color(self.color.r + _hl, self.color.g + _hl, self.color.b + _hl, headeralpha), true, true, not self:IsOpen(), not self:IsOpen())
			local _x = ph / 2
			if strUrl(grp.string_icon) then
				_x = ph
			end

			local name = self.tbl.string_name
			if tonumber(self.tbl.int_parentgroup) == 0 then
				name = YRP:trans("LID_faction") .. ": " .. name
			end

			draw.SimpleText(name, "Y_24_500", _x, ph / 2, Color(255, 255, 255, 255), 0, 1)
			local _box = YRP:ctr(50)
			local _dif = 50
			local _br = (ph - _box) / 2
			local _tog = "▼"
			if self:IsOpen() then
				_tog = "▲"
			end

			draw.RoundedBox(0, pw - _box - _br, _br, _box, _box, Color(self.color.r - _dif, self.color.g - _dif, self.color.b - _dif, headeralpha))
			draw.SimpleText(_tog, "Y_24_500", pw - _box / 2 - _br, _br + _box / 2, Color(255, 255, 255, 255), 1, 1)
			if tobool(grp.bool_locked) then
				YRP:DrawIcon(YRP:GetDesignIcon("lock"), ph - YRP:ctr(8), ph - YRP:ctr(8), pw - 2 * ph, YRP:ctr(4), Color(255, 0, 0, 200))
			end
		end

		function _grp:PaintContent(pw, ph)
			draw.RoundedBoxEx(0, 0, 0, pw, ph, Color(self.color.r - contentdarker, self.color.g - contentdarker, self.color.b - contentdarker, contentalpha), false, false, true, true)
		end

		_grp:SetHeaderHeight(YRP:ctr(100))
		function _grp:DoClick()
			if not tobool(grp.bool_locked) then
				if self:IsOpen() then
					getRoles(grp.uniqueID, _grp)
				else
					self:ClearContent()
				end
			end
		end

		if strUrl(grp.string_icon) then
			_grp.icon = YRPCreateD("DHTML", _grp, _grp:GetTall() - 2 * BR, _grp:GetTall() - 2 * BR, BR, BR)
			_grp.icon:SetHTML(YRPGetHTMLImage(grp.string_icon, _grp.icon:GetWide(), _grp.icon:GetTall()))
		end

		if YRPPanelAlive(parent) then
			--if tostring(grp.int_parentgroup) ~= "0" then -- removed to make it work for under one by one
			-- first additem!
			if parent.AddItem then
				parent:AddItem(_grp)
			elseif parent.Add then
				parent:Add(_grp)
			else
				YRP:msg("error", "grp.int_parentgroup: " .. type(grp.int_parentgroup) .. " | " .. "parent.Add: " .. tostring(parent.Add))
			end
			--end
		else
			YRP:msg("note", "parent not valid")
		end

		if parent.Rebuild then
			parent:Rebuild()
		end

		return _grp
	else
		return NULL
	end
end

function getGroups(uid, parent)
	net.Receive(
		"nws_yrp_rolesmenu_get_groups",
		function(len)
			local _groups = net.ReadTable()
			local dg = nil -- Default Group
			for i, grp in SortedPairsByMemberValue(_groups, "int_position") do
				grp.uniqueID = tonumber(grp.uniqueID)
				local g = addGroup(grp, parent)
				if grp.uniqueID == 1 then
					dg = g
				end
			end

			timer.Simple(
				0.2,
				function()
					if IsNotNilAndNotFalse(dg) and IsNotNilAndNotFalse(dg.header) then
						dg.header:DoClick()
					end
				end
			)
		end
	)

	net.Start("nws_yrp_rolesmenu_get_groups")
	net.WriteString(uid)
	net.SendToServer()
end

function OpenRoleMenu()
	YRPOpenMenu()
	if GetGlobalYRPBool("bool_players_can_switch_role", false) then
		ROLEMENU.open = true
		ROLEMENU.window = YRPCreateD("YFrame", nil, BFW(), BFH(), BPX(), BPY())
		ROLEMENU.window:SetMinWidth(BFW())
		ROLEMENU.window:SetMinHeight(BFH())
		ROLEMENU.window:Center()
		ROLEMENU.window:Sizable(true)
		ROLEMENU.window:SetTitle("LID_rolemenu")
		ROLEMENU.window:SetHeaderHeight(50)
		ROLEMENU.window:SetBackgroundBlur(true)
		ROLEMENU.window.systime = SysTime()
		function ROLEMENU.window:Paint(pw, ph)
			Derma_DrawBackgroundBlur(self, self.systime)
			hook.Run("YFramePaint", self, pw, ph)
		end

		ROLEMENU.window:MakePopup()
		CreateRoleMenuContent(ROLEMENU.window.con)
	end
end

function CreateRoleMenuContent(parent)
	LocalPlayer().cc = false
	LocalPlayer().charcreate_fuid = LocalPlayer():GetFactionUniqueID()
	SetGlobalYRPBool("create_eventchar", false)
	RoleMenu = parent
	CreateRoleSelectionContent(parent)
end
