--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local PANEL = {}

function PANEL:SetHeader(txt)
	self._htext = txt
end

function PANEL:SetIcon(ico)
	self._icon = ico
end

function PANEL:Paint(pw, ph)
	draw.RoundedBox(0, 0, 0, pw, ph, self._ccol)
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

function PANEL:Init()
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
		draw.RoundedBox(0, 0, 0, pw, ph, base._hcol)

		local x = 0
		if !strEmpty(base._icon) then
			x = ph + YRP.ctr(20)
			if self.ico != base._icon then
				self.ico = base._icon
				base.icon:SetHTML(GetHTMLImage(self.ico, ph * 0.8, ph * 0.8))		
			end
		else
			x = ph / 2
		end

		draw.SimpleText(base._htext, "Y_34_700", x, ph / 2, TextColor(base._hcol), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	function self.btn:DoClick()
		base._open = !base._open
		if base._open then
			net.Receive("yrp_roleselection_getcontent", function(len)
				local roltab = net.ReadTable()
				local grptab = net.ReadTable()
				
				local rw = 660
				local rh = 160
				local x = 0
				local y = 0
				for i, rol in pairs(roltab) do
					local w = rw
					local h = rh
					local rlist = createD("DPanel", nil, 10, YRP.ctr(h), 0, 0)
					function rlist:Paint(pw, ph)
						--draw.RoundedBox(ph / 2, 0, 0, pw, ph, Color(0, 0, 255))
					end

					local r = createD("DPanel", rlist, YRP.ctr(w), YRP.ctr(h), 0, 0)
					function r:Paint(pw, ph)
						draw.RoundedBox(ph / 2, 0, 0, pw, ph, StringToColor(rol.string_color))
						draw.SimpleText(rol.string_name, "Y_18_700", ph + YRP.ctr(20), ph / 3, TextColor(StringToColor(rol.string_color)), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
						draw.SimpleText(MoneyFormat(rol.int_salary), "Y_18_700", ph + YRP.ctr(20), ph / 3 * 2, TextColor(StringToColor(rol.string_color)), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					end

					local pm = createD("YModelPanel", r, YRP.ctr(h), YRP.ctr(h), 0, 0)
					rol.pms = string.Explode(",", rol.pms)
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

					local btn = createD("DButton", r, r:GetWide(), r:GetTall(), 0, 0)
					btn:SetText("")
					function btn:Paint(pw, ph)

					end
					function btn:DoClick()
						lply:SetDString("charcreate_ruid", rol.uniqueID)

						CreateRolePreviewContent()
					end

					base.con:AddItem(rlist)
				end
				
				local gw = base._w - 2 * YRP.ctr(20) - base.con.VBar:GetWide()
				local gh = base._h
				for i, grp in pairs(grptab) do
					local w = gw
					local h = gh
					local group = createD("YCollapsibleCategory", base.con, w, h, 0, 0)
					group:SetS(w, h)
					group:SetHeader(grp.string_name)
					group:SetIcon(grp.string_icon)
					group:SetList(base.con)
					group:SetHeaderColor(StringToColor(grp.string_color))
					group:SetContentColor(StringToColor(grp.string_color))
					group:SetGroupUID(grp.uniqueID)

					base.con:AddItem(group)
				end

				base.con:Rebuild()
				base._list:Rebuild()

				local h = rh * 3.5
				if base.con:GetCanvas():GetTall() < h then
					h = base.con:GetCanvas():GetTall()
					h = math.Clamp(h, YRP.ctr(100), YRP.ctr(999))
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
	self.icon = createD("DHTML", self.btn, YRP.ctr(100) * 0.8, YRP.ctr(100) * 0.8, YRP.ctr(10), YRP.ctr(10))
end

vgui.Register("YCollapsibleCategory", PANEL, "DPanel")
