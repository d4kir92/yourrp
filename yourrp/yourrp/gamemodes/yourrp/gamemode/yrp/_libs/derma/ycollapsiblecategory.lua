--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local _type = type
local PANEL = {}
local w = 10
local h = 10
net.Receive(
	"nws_yrp_want_role",
	function(len, ply)
		local result = net.ReadString()
		if result == "worked" then
			CreateRolePreviewContent()
		else
			local popup = YRPCreateD("YFrame", nil, YRP.ctr(800), YRP.ctr(120 + 20 + 60 + 20 + 20 + 100), 0, 0)
			popup:Center()
			popup:MakePopup()
			popup:SetTitle(YRP.trans(result))
			local ok = YRPCreateD("YLabel", popup:GetContent(), YRP.ctr(760), YRP.ctr(120), popup:GetContent():GetWide() / 2 - YRP.ctr(760 / 2), popup:GetContent():GetTall() - YRP.ctr(60 + 20 + 120))
			ok:SetText(YRP.trans(result))
			local ok2 = YRPCreateD("YButton", popup:GetContent(), YRP.ctr(400), YRP.ctr(60), popup:GetContent():GetWide() / 2 - YRP.ctr(400 / 2), popup:GetContent():GetTall() - YRP.ctr(60))
			ok2:SetText(YRP.trans("LID_ok"))
			function ok2:DoClick()
				popup:Close()
			end
		end
	end
)

function PANEL:SetHeader(txt)
	self._htext = txt
end

function PANEL:SetIcon(ico)
	self._icon = ico
end

function PANEL:Paint(pw, ph)
	draw.RoundedBoxEx(YRP.ctr(14), 0, YRP.ctr(10), YRP.ctr(20), ph - YRP.ctr(10), self._ccol, false, false, true, false) --self._ccol)
	draw.RoundedBoxEx(YRP.ctr(14), YRP.ctr(10), YRP.ctr(10), pw - 1 * YRP.ctr(10), ph - 1 * YRP.ctr(10), YRPInterfaceValue("YFrame", "NC"), false, false, false, true) --self._ccol)
end

function PANEL:SetList(lis)
	self._lis = lis
end

function PANEL:SetS(sw, sh)
	self._w = sw
	self._h = sh
	self:SetSize(sw, sh)
	self.btn:SetSize(sw, sh)
	self.con:SetSize(sw - 2 * YRP.ctr(20) - self.con.VBar:GetWide(), sh - 2 * YRP.ctr(20))
	self.con:SetPos(YRP.ctr(20), YRP.ctr(20))
end

function PANEL:SetHeaderColor(col)
	self._hcol = col
end

function PANEL:SetContentColor(col)
	self._ccol = col
end

function PANEL:SetGroupUID(uid)
	self._guid = uid
end

function PANEL:SetFixedHeight(sh)
	self._fh = sh
end

local NEXTS = {}
local color1 = Color(0, 0, 0, 10)
function PANEL:Init()
	local this = self
	self:SetText("")
	self._open = false
	local base = self
	self._hcol = Color(0, 255, 0)
	self._ccol = Color(0, 255, 0)
	self._htext = ""
	-- CON
	self.con = YRPCreateD("DPanelList", self, 10, 10, 0, 10)
	self.con:EnableVerticalScrollbar()
	self.con:SetSpacing(YRP.ctr(20))
	function self.con:Paint(pw, ph)
	end

	--draw.RoundedBox(0, 0, 0, pw, ph, Color( 0, 0, 255, 255 ) )
	local sbar = self.con.VBar
	function sbar:Paint(sw, sh)
		draw.RoundedBox(0, 0, 0, sw, sh, YRPInterfaceValue("YFrame", "NC"))
	end

	function sbar.btnUp:Paint(sw, sh)
		draw.RoundedBox(0, 0, 0, sw, sh, Color(60, 60, 60))
	end

	function sbar.btnDown:Paint(sw, sh)
		draw.RoundedBox(0, 0, 0, sw, sh, Color(60, 60, 60))
	end

	function sbar.btnGrip:Paint(sw, sh)
		draw.RoundedBox(w / 2, 0, 0, w, h, YRPInterfaceValue("YFrame", "HI"))
	end

	-- BTN
	self.btn = YRPCreateD("DButton", self, 10, 10, 0, 0)
	self.btn:SetText("")
	function self.btn:Paint(pw, ph)
		draw.RoundedBoxEx(YRP.ctr(10), 0, 0, YRP.ctr(20), ph, base._hcol, true, false, false, false)
		draw.RoundedBoxEx(YRP.ctr(10), YRP.ctr(10), 0, pw - YRP.ctr(10), ph, YRPInterfaceValue("YFrame", "PC"), false, true, false, false)
		local x = 0
		if not strEmpty(base._icon) then
			x = ph + YRP.ctr(10)
			if self.ico ~= base._icon then
				self.ico = base._icon
				base.icon:SetHTML(YRPGetHTMLImage(self.ico, ph - 2 * YRP.ctr(20), ph - 2 * YRP.ctr(20)))
			end
		else
			x = ph / 2
		end

		draw.SimpleText(base._htext, "Y_" .. math.Clamp(math.Round(ph - 2 * YRP.ctr(20), 0), 4, 100) .. "_500", x, ph / 2, YRPTextColor(YRPInterfaceValue("YFrame", "PC")), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	net.Receive(
		"nws_yrp_get_next_ranks",
		function(len)
			local rols = net.ReadTable()
			local nex = NEXTS[tonumber(rols[1].int_prerole)]
			local rlis = nex.rlis
			if not YRPPanelAlive(rlis, "rlis") then
				YRP.msg("note", "rlis invalid")

				return
			end

			local lis = YRPCreateD("DPanelList", nil, YRP.ctr(w + 80 + 30), YRP.ctr(h), 0, 0)
			lis:EnableVerticalScrollbar()
			rlis:AddPanel(lis)
			local sBar = lis.VBar
			function sBar:Paint(sw, sh)
				draw.RoundedBox(0, 0, 0, sw, sh, YRPInterfaceValue("YFrame", "NC"))
			end

			function sBar.btnUp:Paint(sw, sh)
				draw.RoundedBox(0, 0, 0, sw, sh, Color(60, 60, 60))
			end

			function sBar.btnDown:Paint(sw, sh)
				draw.RoundedBox(0, 0, 0, sw, sh, Color(60, 60, 60))
			end

			function sBar.btnGrip:Paint(sw, sh)
				draw.RoundedBox(w / 2, 0, 0, sw, sh, YRPInterfaceValue("YFrame", "HI"))
			end

			for i, r in pairs(rols) do
				r.bool_eventrole = tobool(r.bool_eventrole)
				if r.bool_eventrole == GetGlobalYRPBool("create_eventchar", false) then
					AddRole(rlis, r, w, h, lis)
				end
			end
		end
	)

	function AddRole(rlis, rol, sw, sh, lis)
		rol.uniqueID = tonumber(rol.uniqueID)
		if _type(rol.string_usergroups) ~= "table" then
			rol.string_usergroups = string.Explode(",", rol.string_usergroups)
		end

		rol.bool_visible_cc = tobool(rol.bool_visible_cc)
		rol.bool_visible_rm = tobool(rol.bool_visible_rm)
		rol.bool_locked = tobool(rol.bool_locked)
		rol.int_requireslevel = tonumber(rol.int_requireslevel)
		rol.int_uses = tonumber(rol.int_uses)
		rol.int_maxamount = tonumber(rol.int_maxamount)
		rol.int_prerole = tonumber(rol.int_prerole)
		local r = YRPCreateD("DPanel", nil, YRP.ctr(sw) + YRP.ctr(80), YRP.ctr(sh), 0, 0)
		function r:Paint(pw, ph)
		end

		--draw.RoundedBox(0, 0, 0, pw, ph, Color( 0, 255, 0 ) )
		local bg = YRPCreateD("DPanel", r, YRP.ctr(sw), YRP.ctr(sh), 0, 0)
		function bg:Paint(pw, ph)
			draw.RoundedBoxEx(YRP.ctr(10), 0, 0, YRP.ctr(20), ph, StringToColor(rol.string_color), true, false, true, false)
			draw.RoundedBoxEx(YRP.ctr(10), YRP.ctr(10), 0, pw - YRP.ctr(10), ph, YRPInterfaceValue("YFrame", "PC"), false, true, false, true)
			local diameter = ph - 2 * YRP.ctr(10)
			draw.RoundedBox(diameter / 2, YRP.ctr(18), YRP.ctr(8), diameter + YRP.ctr(4), diameter + YRP.ctr(4), StringToColor(rol.string_color))
			draw.RoundedBox(diameter / 2, YRP.ctr(20), YRP.ctr(10), diameter, diameter, YRPInterfaceValue("YFrame", "PC"))
			draw.SimpleText(rol.string_name, "Y_26_500", ph + YRP.ctr(20), ph / 3, YRPTextColor(YRPInterfaceValue("YFrame", "PC")), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			if tonumber(rol.int_salary) > 0 then
				draw.SimpleText(MoneyFormat(rol.int_salary), "Y_20_500", ph + YRP.ctr(20), ph / 3 * 2, YRPTextColor(YRPInterfaceValue("YFrame", "PC")), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end

			if rol.int_maxamount > 0 then
				local radius = ph / 2 - 1 * YRP.ctr(10)
				local x = pw - ph / 2
				local y = ph / 2
				radius = ph / 2 - YRP.ctr(10)
				if self.circ == nil then
					local ang = rol.int_uses / rol.int_maxamount * 360
					self.circbg = circleBorder(x, y, radius, 32, 0, 360)
					table.insert(
						self.circbg,
						{
							x = x,
							y = y
						}
					)

					self.circ2bg = circleBorder(x, y, radius - YRP.ctr(10), 32, 0, 360)
					table.insert(
						self.circ2bg,
						{
							x = x,
							y = y
						}
					)

					self.circ = circleBorder(x, y, radius, 32, 0, ang)
					table.insert(
						self.circ,
						{
							x = x,
							y = y
						}
					)

					self.circ2 = circleBorder(x, y, radius - YRP.ctr(10), 32, 0, ang)
					table.insert(
						self.circ2,
						{
							x = x,
							y = y
						}
					)
				else
					-- Background
					render.ClearStencil()
					render.SetStencilEnable(true)
					render.SetStencilWriteMask(99)
					render.SetStencilTestMask(99)
					render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
					render.SetStencilFailOperation(STENCILOPERATION_INCR)
					render.SetStencilPassOperation(STENCILOPERATION_KEEP)
					render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
					surface.SetDrawColor(YRPInterfaceValue("YFrame", "PC"))
					surface.DrawPoly(self.circ2bg)
					render.SetStencilReferenceValue(12)
					render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NOTEQUAL)
					surface.SetDrawColor(YRPInterfaceValue("YFrame", "BG"))
					surface.DrawPoly(self.circbg)
					render.SetStencilEnable(false)
					-- Circle
					render.ClearStencil()
					render.SetStencilEnable(true)
					render.SetStencilWriteMask(99)
					render.SetStencilTestMask(99)
					render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
					render.SetStencilFailOperation(STENCILOPERATION_INCR)
					render.SetStencilPassOperation(STENCILOPERATION_KEEP)
					render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
					surface.SetDrawColor(YRPInterfaceValue("YFrame", "PC"))
					surface.DrawPoly(self.circ2)
					render.SetStencilReferenceValue(12)
					render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NOTEQUAL)
					surface.SetDrawColor(Color(100, 255, 100, 100))
					surface.DrawPoly(self.circ)
					render.SetStencilEnable(false)
				end

				draw.SimpleText(rol.int_uses .. "/" .. rol.int_maxamount, "Y_" .. 20 .. "_500", pw - ph / 2, ph / 2, YRPTextColor(YRPInterfaceValue("YFrame", "PC")), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end

		local diameter = YRP.ctr(h) - 2 * YRP.ctr(10)
		if _type(rol.pms) ~= "table" and _type(rol.pms) == "string" then
			rol.pms = string.Explode(",", rol.pms)
		end

		if _type(rol.pms) == "table" and not strEmpty(rol.pms[1]) then
			local pm = YRPCreateD("YModelPanel", bg, diameter, diameter, YRP.ctr(20), YRP.ctr(10))
			pm:SetModel(rol.pms[1])
			if pm.panel and pm.panel.Entity and pm.panel.Entity:IsValid() then
				function pm.panel:LayoutEntity(ent)
					ent:SetSequence(ent:LookupSequence("menu_gman"))
					pm.panel:RunAnimation()

					return
				end

				local head = pm.panel.Entity:LookupBone("ValveBiped.Bip01_Head1")
				if head then
					local eyepos = pm.panel.Entity:GetBonePosition(head)
					if eyepos then
						pm.panel:SetLookAt(eyepos)
						pm.panel:SetCamPos(eyepos - Vector(-20, 0, 0))
						pm.panel.Entity:SetEyeTarget(eyepos - Vector(-20, 0, 0))
					end
				end
			end
		end

		local btn = YRPCreateD("DButton", bg, bg:GetWide(), bg:GetTall(), 0, 0)
		btn:SetText("")
		function btn:Paint(pw, ph)
			if rol.int_prerole == 0 and (not rol.bool_locked or LocalPlayer():HasAccess("CollapseCategory1")) and rol.int_requireslevel <= LocalPlayer():Level() and self:IsHovered() then
				draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, Color(255, 255, 255, 10))
			end

			if rol.bool_locked or rol.int_requireslevel > LocalPlayer():Level() then
				YRP.DrawIcon(YRP.GetDesignIcon("lock"), ph - 2 * YRP.ctr(40), ph - 2 * YRP.ctr(40), YRP.ctr(50), YRP.ctr(40), Color(255, 100, 100))
				if rol.int_requireslevel > LocalPlayer():Level() then
					draw.SimpleText(string.sub(YRP.trans("LID_level"), 1, 3) .. ". " .. rol.int_requireslevel, "Y_24_500", ph / 2 + YRP.ctr(10), ph / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			end
		end

		function btn:DoClick()
			rol.int_prerole = tonumber(rol.int_prerole)
			if (not rol.bool_locked or LocalPlayer():HasAccess("CollapseCategory2")) and rol.int_requireslevel <= LocalPlayer():Level() then
				LocalPlayer().charcreate_ruid = rol.uniqueID
				timer.Simple(
					0.2,
					function()
						net.Start("nws_yrp_want_role")
						net.WriteString(rol.uniqueID)
						net.SendToServer()
					end
				)
			end
		end

		local nex = YRPCreateD("DButton", r, YRP.ctr(80), YRP.ctr(h), r:GetWide() - YRP.ctr(80), 0)
		nex:SetText("")
		function nex:Paint(pw, ph)
			if self:IsHovered() then
				draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 20))
			end

			local br = YRP.ctr(10)
			if YRP.GetDesignIcon("64_angle-right") ~= nil then
				surface.SetMaterial(YRP.GetDesignIcon("64_angle-right"))
				surface.SetDrawColor(Color(255, 255, 255, 255))
				surface.DrawTexturedRect(br, ph / 2 - (pw - 2 * br) / 2, pw - 2 * br, pw - 2 * br)
			end
		end

		nex.lis = lis
		nex.rlis = rlis
		nex.base = r
		NEXTS[rol.uniqueID] = nex
		function nex:DoClick()
			net.Start("nws_yrp_get_next_ranks")
			net.WriteString(rol.uniqueID)
			net.SendToServer()
			if YRPPanelAlive(self.rlis, "self.rlis") then
				local remove = false
				for i, v in pairs(self.rlis.Panels) do
					if YRPPanelAlive(v, "rlis.Panels") then
						if v.GetName and v:GetName() == "DPanelList" then
							if remove then
								v:Remove()
							else
								for j, pw in pairs(v:GetItems()) do
									if pw == self.base then
										remove = true
										break
									end
								end
							end
						else
							if v == self.base then
								remove = true
							elseif remove then
								v:Remove()
							end
						end
					end
				end
			end
		end

		net.Receive(
			"nws_yrp_hasnext_ranks",
			function(len)
				local ruid = net.ReadString()
				local b = net.ReadBool()
				ruid = tonumber(ruid)
				local nextP = NEXTS[ruid]
				if YRPPanelAlive(nextP, "nextP") then
					if not b then
						nextP:Remove()
					else
						nextP:Show()
					end
				end
			end
		)

		net.Start("nws_yrp_hasnext_ranks")
		net.WriteString(rol.uniqueID)
		net.SendToServer()
		if YRPPanelAlive(lis, "lis 1") then
			lis:AddItem(r)
		elseif YRPPanelAlive(rlis, "rlis 1") then
			rlis:AddPanel(r)
		end
	end

	function self.RebuildContent()
		local roltab = this.roltab or {}
		local grptab = this.grptab or {}
		base.con:Clear()
		if YRPPanelAlive(base, "base") then
			local rw = 800
			local rh = 160
			for i, rol in SortedPairsByMemberValue(roltab, "int_position") do
				if _type(rol.string_usergroups) ~= "table" then
					rol.string_usergroups = string.Explode(",", rol.string_usergroups)
				else
					rol.string_usergroups = {}
				end

				rol.bool_visible_cc = tobool(rol.bool_visible_cc)
				rol.bool_visible_rm = tobool(rol.bool_visible_rm)
				rol.bool_locked = tobool(rol.bool_locked)
				rol.int_uses = tonumber(rol.int_uses)
				rol.int_maxamount = tonumber(rol.int_maxamount)
				rol.int_prerole = tonumber(rol.int_prerole)
				rol.bool_eventrole = tobool(rol.bool_eventrole)
				-- Restrictions
				if table.Count(rol.string_usergroups) > 0 and not table.HasValue(rol.string_usergroups, "ALL") and not table.HasValue(rol.string_usergroups, string.upper(LocalPlayer():GetUserGroup())) then continue end
				if LocalPlayer().cc == true and not rol.bool_visible_cc then
					continue
				elseif LocalPlayer().cc == false and not rol.bool_visible_rm then
					continue
				end

				if GetGlobalYRPBool("create_eventchar", false) and not tobool(rol.bool_eventrole) then continue end
				if tonumber(rol.int_prerole) == 0 then
					w = rw
					h = rh
					local rlis = YRPCreateD("DHorizontalScroller", nil, 10, YRP.ctr(h), 0, 0)
					function rlis:Paint(pw, ph)
						draw.RoundedBox(0, 0, 0, pw, ph, color1)
					end

					base.con:AddItem(rlis)
					AddRole(rlis, rol, w, h)
				end
			end

			local gw = base._w - 2 * YRP.ctr(20) - base.con.VBar:GetWide()
			local gh = base._h
			for i, grp in SortedPairsByMemberValue(grptab, "int_position") do
				local sw = gw
				local sh = gh
				grp.bool_visible_cc = tobool(grp.bool_visible_cc)
				grp.bool_visible_rm = tobool(grp.bool_visible_rm)
				if LocalPlayer().cc == true and not grp.bool_visible_cc then
					continue
				elseif LocalPlayer().cc == false and not grp.bool_visible_rm then
					continue
				end

				local group = YRPCreateD("YCollapsibleCategory", base.con, sw, sh, 0, 0)
				group:SetS(sw, sh)
				group:SetHeader(grp.string_name)
				group:SetIcon(grp.string_icon)
				group:SetList(base.con)
				group:SetHeaderColor(StringToColor(grp.string_color))
				group:SetContentColor(StringToColor(grp.string_color))
				group:SetGroupUID(grp.uniqueID)
				if YRPPanelAlive(base.con, "base.con") then
					base.con:AddItem(group)
				else
					group:Remove()
					break
				end
			end

			base.con:Rebuild()
			base._lis:Rebuild()
			local sh = rh * 3.5
			if base.con:GetCanvas():GetTall() < sh then
				sh = base.con:GetCanvas():GetTall()
				sh = math.Clamp(sh, YRP.ctr(999), YRP.ctr(1999))
				if base._fh then
					sh = base._fh
				end

				sh = YRP.ctr(sh)
				base:SetTall(sh + YRP.ctr(100 + 2 * 20))
				base.btn:SetTall(YRP.ctr(100))
				base.con:SetTall(sh)
				base.con:SetPos(YRP.ctr(20), YRP.ctr(100) + YRP.ctr(20))
				base.con:Rebuild()
				base._lis:Rebuild()
			else
				sh = rh * 3.5
				if base._fh then
					sh = base._fh
				end

				sh = YRP.ctr(sh)
				base:SetTall(sh)
				base.btn:SetTall(YRP.ctr(100))
				base.con:SetTall(sh - YRP.ctr(100) - 2 * YRP.ctr(20))
				base.con:SetPos(YRP.ctr(20), YRP.ctr(100) + YRP.ctr(20))
				base.con:Rebuild()
				base._lis:Rebuild()
			end
		end
	end

	function self.btn:DoClick()
		base._open = not base._open
		this.roltab = {}
		this.grptab = {}
		if base._open then
			net.Receive(
				"nws_yrp_roleselection_getcontent_role",
				function(len)
					local rol = net.ReadTable()
					if rol and this.roltab then
						table.insert(this.roltab, rol)
						this:RebuildContent()
					end
				end
			)

			net.Receive(
				"nws_yrp_roleselection_getcontent_group",
				function(len)
					local grp = net.ReadTable()
					if grp and this.grptab then
						table.insert(this.grptab, grp)
						this.RebuildContent()
					end
				end
			)

			if base._guid then
				net.Start("nws_yrp_roleselection_getcontent")
				net.WriteString(base._guid)
				net.SendToServer()
			else
				YRP.msg("note", "ycollapsiblecategory error, base._guid")
			end
		else
			base:SetTall(YRP.ctr(100))
			base.btn:SetTall(YRP.ctr(100))
			base.con:SetTall(0)
			base.con:SetPos(0, 0)
			base.con:Clear()
			base.con:Rebuild()
			base._lis:Rebuild()
		end
	end

	-- ICON
	self.icon = YRPCreateD("DHTML", self.btn, YRP.ctr(100) - 2 * YRP.ctr(20), YRP.ctr(100) - 2 * YRP.ctr(20), YRP.ctr(30), YRP.ctr(20))
end

vgui.Register("YCollapsibleCategory", PANEL, "DPanel")