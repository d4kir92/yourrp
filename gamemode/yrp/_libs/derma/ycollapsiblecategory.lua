--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local PANEL = {}

local w = 10
local h = 10

function PANEL:SetHeader(txt)
	self._htext = txt
end

function PANEL:SetIcon(ico)
	self._icon = ico
end

function PANEL:Paint(pw, ph)
	draw.RoundedBoxEx(YRP.ctr(14), 0, YRP.ctr(10), YRP.ctr(20), ph - YRP.ctr(10), self._ccol, false, false, true, false)--self._ccol)
	draw.RoundedBoxEx(YRP.ctr(14), YRP.ctr(10), YRP.ctr(10), pw - 1 * YRP.ctr(10), ph - 1 * YRP.ctr(10), lply:InterfaceValue("YFrame", "NC"), false, false, false, true)--self._ccol)
end

function PANEL:SetList(list)
	self._list = list
end

function PANEL:SetS(w, h)
	self._w = w
	self._h = h
	self:SetSize(w, h)
	self.btn:SetSize(w, h)
	self.con:SetSize(w - 2 * YRP.ctr(20) - self.con.VBar:GetWide(), h - 2 * YRP.ctr(20))
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

function PANEL:SetFixedHeight(h)
	self._fh = h
end

local NEXTS = {}

function PANEL:Init()
	local lply = LocalPlayer()
	self:SetText("")

	self._open = false

	local base = self

	self._hcol = Color(255, 0, 0)
	self._ccol = Color(255, 0, 0)

	self._htext = ""

	-- CON
	self.con = createD("DPanelList", self, 10, 10, 0, 10)
	self.con:EnableVerticalScrollbar()
	self.con:SetSpacing(YRP.ctr(20))
	function self.con:Paint(pw, ph)
		--draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 255))
	end
	local sbar = self.con.VBar
	function sbar:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, lply:InterfaceValue("YFrame", "NC"))
	end
	function sbar.btnUp:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
	end
	function sbar.btnDown:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
	end
	function sbar.btnGrip:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, lply:InterfaceValue("YFrame", "HI"))
	end

	-- BTN
	self.btn = createD("DButton", self, 10, 10, 0, 0)
	self.btn:SetText("")
	function self.btn:Paint(pw, ph)
		draw.RoundedBoxEx(YRP.ctr(10), 0, 0, YRP.ctr(20), ph, base._hcol, true, false, false, false)
		draw.RoundedBoxEx(YRP.ctr(10), YRP.ctr(10), 0, pw - YRP.ctr(10), ph, lply:InterfaceValue("YFrame", "PC"), false, true, false, false)

		local x = 0
		if !strEmpty(base._icon) then
			x = ph + YRP.ctr(10)
			if self.ico != base._icon then
				self.ico = base._icon
				base.icon:SetHTML(GetHTMLImage(self.ico, ph - 2 * YRP.ctr(20), ph - 2 * YRP.ctr(20)))		
			end
		else
			x = ph / 2
		end

		draw.SimpleText(base._htext, "Y_" .. math.Clamp(math.Round(ph - 2 * YRP.ctr(20), 0), 4, 100) .. "_700", x, ph / 2, TextColor(lply:InterfaceValue("YFrame", "PC")), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	net.Receive("get_next_ranks", function(len)
		local rols = net.ReadTable()

		local nex = NEXTS[tonumber(rols[1].int_prerole)]
		local rlist = nex.rlist

		local list = createD("DPanelList", nil, YRP.ctr(w + 80 + 30), YRP.ctr(h), 0, 0)
		list:EnableVerticalScrollbar()
		rlist:AddPanel(list)

		local sbar = list.VBar
		function sbar:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, lply:InterfaceValue("YFrame", "NC"))
		end
		function sbar.btnUp:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
		end
		function sbar.btnDown:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
		end
		function sbar.btnGrip:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, lply:InterfaceValue("YFrame", "HI"))
		end

		for i, r in pairs(rols) do
			if i == 1 then
				AddRole(rlist, r, w, h, list)
			else
				AddRole(rlist, r, w, h, list)
			end
		end
	end)

	function AddRole(rlist, rol, w, h, list)
		rol.uniqueID = tonumber(rol.uniqueID)
		if type(rol.string_usergroups) != "table" then
			rol.string_usergroups = string.Explode(",", rol.string_usergroups)
		end
		rol.bool_visible_cc = tobool(rol.bool_visible_cc)
		rol.bool_visible_rm = tobool(rol.bool_visible_rm)
		rol.bool_locked = tobool(rol.bool_locked)
		rol.int_uses = tonumber(rol.int_uses)
		rol.int_maxamount = tonumber(rol.int_maxamount)
		rol.int_prerole = tonumber(rol.int_prerole)

		local r = createD("DPanel", nil, YRP.ctr(w) + YRP.ctr(80), YRP.ctr(h), 0, 0)
		function r:Paint(pw, ph)
			--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 0, 0))
		end
	
		local bg = createD("DPanel", r, YRP.ctr(w), YRP.ctr(h), 0, 0)
		function bg:Paint(pw, ph)
			draw.RoundedBoxEx(YRP.ctr(10), 0, 0, YRP.ctr(20), ph, StringToColor(rol.string_color), true, false, true, false)
			draw.RoundedBoxEx(YRP.ctr(10), YRP.ctr(10), 0, pw - YRP.ctr(10), ph, lply:InterfaceValue("YFrame", "PC"), false, true, false, true)

			local diameter = ph - 2 * YRP.ctr(10)
			draw.RoundedBox(diameter / 2, YRP.ctr(18), YRP.ctr(8), diameter + YRP.ctr(4), diameter + YRP.ctr(4), StringToColor(rol.string_color))
			draw.RoundedBox(diameter / 2, YRP.ctr(20), YRP.ctr(10), diameter, diameter, lply:InterfaceValue("YFrame", "PC"))

			draw.SimpleText(rol.string_name, "Y_26_700", ph + YRP.ctr(20), ph / 3, TextColor(lply:InterfaceValue("YFrame", "PC")), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(MoneyFormat(rol.int_salary), "Y_20_500", ph + YRP.ctr(20), ph / 3 * 2, TextColor(lply:InterfaceValue("YFrame", "PC")), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			if rol.int_maxamount > 0 then
				local radius = ph / 2 - 1 * YRP.ctr(10)
				local rcol = StringToColor(rol.string_color)

				local x = pw - ph / 2
				local y = ph / 2
				local radius = ph / 2 - YRP.ctr(10)
				if self.circ == nil then
					local ang = rol.int_uses / rol.int_maxamount * 360

					self.circbg = circleBorder(x, y, radius, 32, 0, 360)
					table.insert(self.circbg, {x = x, y = y})
					self.circ2bg = circleBorder(x, y, radius - YRP.ctr(10), 32, 0, 360)
					table.insert(self.circ2bg, {x = x, y = y})

					self.circ = circleBorder(x, y, radius, 32, 0, ang)
					table.insert(self.circ, {x = x, y = y})
					self.circ2 = circleBorder(x, y, radius - YRP.ctr(10), 32, 0, ang)
					table.insert(self.circ2, {x = x, y = y})
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

					surface.SetDrawColor(lply:InterfaceValue("YFrame", "PC"))
					surface.DrawPoly(self.circ2bg)

					render.SetStencilReferenceValue(1)
					render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NOTEQUAL)

					surface.SetDrawColor(lply:InterfaceValue("YFrame", "BG"))
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

					surface.SetDrawColor(lply:InterfaceValue("YFrame", "PC"))
					surface.DrawPoly(self.circ2)

					render.SetStencilReferenceValue(1)
					render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NOTEQUAL)

					surface.SetDrawColor(Color(100, 255, 100, 100))
					surface.DrawPoly(self.circ)

					render.SetStencilEnable(false)
				end

				draw.SimpleText(rol.int_uses .. "/" .. rol.int_maxamount, "Y_" .. 20 .. "_700", pw - ph / 2, ph / 2, TextColor(lply:InterfaceValue("YFrame", "PC")), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end

		local diameter = YRP.ctr(h) - 2 * YRP.ctr(10)
		local pm = createD("YModelPanel", bg, diameter, diameter, YRP.ctr(20), YRP.ctr(10))
		if type(rol.pms) != "table" and type(rol.pms) == "string" then
			rol.pms = string.Explode(",", rol.pms)
		end
		if type(rol.pms) == "table" then
			if !strEmpty(rol.pms[1]) then
				pm:SetModel(rol.pms[1])
				if pm.panel.Entity:IsValid() then
					function pm.panel:LayoutEntity( ent )
						ent:SetSequence( ent:LookupSequence("menu_gman") )
						pm.panel:RunAnimation()
						return
					end

					local head = pm.panel.Entity:LookupBone( "ValveBiped.Bip01_Head1" )
					if head then
						local eyepos = pm.panel.Entity:GetBonePosition( head )
						if eyepos then
							pm.panel:SetLookAt( eyepos )
							pm.panel:SetCamPos( eyepos-Vector( -20, 0, 0 ) )	-- Move cam in front of eyes
							pm.panel.Entity:SetEyeTarget( eyepos-Vector( -20, 0, 0 ) )
						end
					end
				end
			end
		end

		local btn = createD("DButton", bg, bg:GetWide(), bg:GetTall(), 0, 0)
		btn:SetText("")
		function btn:Paint(pw, ph)
			if rol.int_prerole == 0 and (!rol.bool_locked or lply:HasAccess()) then
				if self:IsHovered() then
					draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, Color(255, 255, 255, 10))
				end
			end
			if rol.bool_locked then
				YRP.DrawIcon(YRP.GetDesignIcon("lock"), ph - 2 * YRP.ctr(40), ph - 2 * YRP.ctr(40), YRP.ctr(50), YRP.ctr(40), TextColor(StringToColor(rol.string_color)))
			end
		end
		function btn:DoClick()
			rol.int_prerole = tonumber(rol.int_prerole)
			if rol.int_prerole == 0 and (!rol.bool_locked or lply:HasAccess()) then
				lply:SetDString("charcreate_ruid", rol.uniqueID)

				CreateRolePreviewContent()
			end
		end

		local nex = createD("DButton", r, YRP.ctr(80), YRP.ctr(h), r:GetWide() - YRP.ctr(80), 0)
		nex:SetText("")
		function nex:Paint(pw, ph)
			if self:IsHovered() then
				draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 20))
			end
			local br = YRP.ctr(10)
			surface.SetMaterial(YRP.GetDesignIcon("keyboard_arrow_right"))
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRect(br, ph / 2 - (pw - 2 * br) / 2, pw - 2 * br, pw - 2 * br)
		end
		nex.list = list
		nex.rlist = rlist
		nex.base = r
		NEXTS[rol.uniqueID] = nex
		function nex:DoClick()
			
			net.Start("get_next_ranks")
				net.WriteString(rol.uniqueID)
			net.SendToServer()
			
			if pa(self.rlist) then
				local remove = false
				for i, v in pairs(self.rlist.Panels) do	
					if pa(v) then
						if v.GetName and v:GetName() == "DPanelList" then
							if remove then
								v:Remove()
							else
								for j, w in pairs(v:GetItems()) do
									if w == self.base then
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

		net.Receive("yrp_hasnext_ranks", function(len)
			local b = net.ReadBool()
			if !b then
				nex:Remove()
			else
				nex:Show()
			end
		end)
		net.Start("yrp_hasnext_ranks")
			net.WriteString(rol.uniqueID)
		net.SendToServer()
			
		if pa(list) then
			list:AddItem(r)
		elseif pa(rlist) then
			rlist:AddPanel(r)
		end
	end

	function self.btn:DoClick()
		base._open = !base._open
		if base._open then
			net.Receive("yrp_roleselection_getcontent", function(len)
				local roltab = net.ReadTable()
				local grptab = net.ReadTable()
				
				if pa(base) then
					local rw = 660
					local rh = 160
					for i, rol in pairs(roltab) do
						rol.string_usergroups = string.Explode(",", rol.string_usergroups)
						rol.bool_visible_cc = tobool(rol.bool_visible_cc)
						rol.bool_visible_rm = tobool(rol.bool_visible_rm)
						rol.bool_locked = tobool(rol.bool_locked)
						rol.int_uses = tonumber(rol.int_uses)
						rol.int_maxamount = tonumber(rol.int_maxamount)
						rol.int_prerole = tonumber(rol.int_prerole)

						-- Restrictions
						if !table.HasValue(rol.string_usergroups, "ALL") then
							if !table.HasValue(rol.string_usergroups, string.upper(lply:GetUserGroup())) then
								continue
							end
						end

						if LocalPlayer():GetDBool("cc", true) == true and !rol.bool_visible_cc then
							continue
						elseif LocalPlayer():GetDBool("cc", false) == false and !rol.bool_visible_rm then
							continue
						end

						if rol.int_prerole == 0 then
							w = rw
							h = rh
							local rlist = createD("DHorizontalScroller", nil, 10, YRP.ctr(h), 0, 0)
							function rlist:Paint(pw, ph)
								draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 10))
							end

							base.con:AddItem(rlist)

							AddRole(rlist, rol, w, h)

							--[[rol.uniqueID = tonumber(rol.uniqueID)
							for i, nextrol in pairs(roltab) do
								nextrol.int_prerole = tonumber(nextrol.int_prerole)
								if nextrol.int_prerole == rol.uniqueID then
									--pTab(nextrol)
								end
							end]]
						end
					end
					
					local gw = base._w - 2 * YRP.ctr(20) - base.con.VBar:GetWide()
					local gh = base._h
					for i, grp in pairs(grptab) do
						local w = gw
						local h = gh

						grp.bool_visible_cc = tobool(grp.bool_visible_cc)
						grp.bool_visible_rm = tobool(grp.bool_visible_rm)

						if LocalPlayer():GetDBool("cc", true) == true and !grp.bool_visible_cc then
							continue
						elseif LocalPlayer():GetDBool("cc", false) == false and !grp.bool_visible_rm then
							continue
						end

						local group = createD("YCollapsibleCategory", base.con, w, h, 0, 0)
						group:SetS(w, h)
						group:SetHeader(grp.string_name)
						group:SetIcon(grp.string_icon)
						group:SetList(base.con)
						group:SetHeaderColor(StringToColor(grp.string_color))
						group:SetContentColor(StringToColor(grp.string_color))
						group:SetGroupUID(grp.uniqueID)

						if pa(base.con) then
							base.con:AddItem(group)
						else
							group:Remove()
							break
						end
					end

					base.con:Rebuild()
					base._list:Rebuild()

					local h = rh * 3.5
					if base.con:GetCanvas():GetTall() < h then
						h = base.con:GetCanvas():GetTall()
						h = math.Clamp(h, YRP.ctr(320), YRP.ctr(999))
						if base._fh then
							h = base._fh
						end
						h = YRP.ctr(h)

						base:SetTall(h + YRP.ctr(100 + 2 * 20))
						base.btn:SetTall(YRP.ctr(100))
						base.con:SetTall(h)
						base.con:SetPos(YRP.ctr(20), YRP.ctr(100) + YRP.ctr(20))
					
						base.con:Rebuild()
						base._list:Rebuild()
					else
						h = rh * 3.5
						if base._fh then
							h = base._fh
						end
						h = YRP.ctr(h)

						base:SetTall(h)
						base.btn:SetTall(YRP.ctr(100))
						base.con:SetTall(h - YRP.ctr(100) - 2 * YRP.ctr(20))
						base.con:SetPos(YRP.ctr(20), YRP.ctr(100) + YRP.ctr(20))
						
						base.con:Rebuild()
						base._list:Rebuild()
					end

					-- FullSize
					--[[
					h = base.con:GetCanvas():GetTall()
					base:SetTall(h + YRP.ctr(100 + 2 * 20))
					base.btn:SetTall(YRP.ctr(100))
					base.con:SetTall(h)
					base.con:SetPos(YRP.ctr(20), YRP.ctr(100) + YRP.ctr(20))

					base.con:Rebuild()
					base._list:Rebuild()]]
				end
			end)
			net.Start("yrp_roleselection_getcontent")
				net.WriteString(base._guid)
			net.SendToServer()
		else
			base:SetTall(YRP.ctr(100))
			base.btn:SetTall(YRP.ctr(100))
			base.con:SetTall(0)
			base.con:SetPos(0, 0)

			base.con:Clear()

			base.con:Rebuild()
			base._list:Rebuild()
		end
	end

	-- ICON
	self.icon = createD("DHTML", self.btn, YRP.ctr(100) - 2 * YRP.ctr(20), YRP.ctr(100) - 2 * YRP.ctr(20), YRP.ctr(30), YRP.ctr(20))
end

vgui.Register("YCollapsibleCategory", PANEL, "DPanel")
