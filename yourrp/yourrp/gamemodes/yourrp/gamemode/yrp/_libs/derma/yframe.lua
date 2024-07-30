--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local PANEL = {}
function PANEL:GetLanguageChanger()
	return self._lc or true
end

function PANEL:SetLanguageChanger(b)
	self._lc = b
end

function PANEL:GetHeaderHeight()
	return self._headerheight
end

function PANEL:SetHeaderHeight(num)
	if isnumber(num) then
		self._headerheight = num
	else
		YRP:msg("note", "SetHeaderHeight | num is not a number: " .. tostring(num) .. "!")
	end

	self:DockPadding(5, num + 5, 5, 5)
	self:InternalUpdateSize()
	self:UpdateSize()
end

function PANEL:GetBorder()
	return self._headerheight
end

function PANEL:SetBorder(b)
	self._border = b
	self:InternalUpdateSize()
	self:UpdateSize()
end

function PANEL:SetCloseButton(bShow)
	self._cb = bShow
end

function PANEL:OnMousePressed()
	local screenX, screenY = self:LocalToScreen(0, 0)
	if self.m_bSizable and gui.MouseX() > (screenX + self:GetWide() - 20) and gui.MouseY() > (screenY + self:GetTall() - 20) then
		self.Sizing = {gui.MouseX() - self:GetWide(), gui.MouseY() - self:GetTall()}
		self:MouseCapture(true)

		return
	end

	if self:GetDraggable() and gui.MouseY() < (screenY + self:GetHeaderHeight()) then
		self.Dragging = {gui.MouseX() - self.x, gui.MouseY() - self.y}
		self:MouseCapture(true)

		return
	end
end

PANEL._text = "Window"
function PANEL:GetTitle()
	return self._text
end

function PANEL:SetTitle(str)
	self._text = str
	self.lblTitle:SetText("")
end

function PANEL:FullScreen()
	return PANEL.fullscreen or false
end

function PANEL:ChangedSize()
end

function PANEL:CanMaximise()
	self.canmiximise = true
	self.btnmax:SetVisible(true)
end

function PANEL:SetMaximised(b, von)
	if von ~= nil then
		if b ~= nil then
			self.maximised = b
		else
			self.maximised = not self.maximised
		end

		if self.maximised then
			self:SetPos(0, 0)
			self:SetSize(ScrW(), ScrH())
		else
			self:SetSize(BFW(), BFH())
			self:Center()
		end

		self:InternalUpdateSize()
		self:UpdateSize()
	end
end

function PANEL:Sizable(b)
	self.btnMaxim:SetDisabled(not b)
	local panel = self
	function self.btnMaxim.DoClick()
		panel.fullscreen = not panel.fullscreen or false
		if panel.fullscreen then
			panel:SetSize(ScW(), ScH())
			panel:Center()
		else
			panel:SetSize(panel:GetMinWidth(), panel:GetMinHeight())
			panel:Center()
		end

		panel:ChangedSize()
	end

	self:SetSizable(b)
end

function PANEL:UpdateSize()
end

function PANEL:InternalUpdateSize()
	local br = YRP:ctr(self._border)
	local header = self:GetHeaderHeight()
	local pw = self:GetWide()
	local ph = self:GetTall()
	if self.con then
		self.con:SetSize(pw - 2 * br - 2, ph - header - 2 * br)
		self.con:SetPos(br, header + br)
	end

	if self.close then
		self.close:SetSize(self:GetHeaderHeight() * 0.6, self:GetHeaderHeight() * 0.6)
		self.close:SetPos(self:GetWide() - self:GetHeaderHeight() * 0.8, self:GetHeaderHeight() * 0.2)
	end

	if self.langu then
		self.langu:SetTall(self:GetHeaderHeight() * 0.6)
		self.langu:SetPos(self:GetWide() - self.langu:GetWide() - self:GetHeaderHeight() * 1.0, self:GetHeaderHeight() * 0.2)
	end

	if self.UpdateCustomeSize then
		self:UpdateCustomeSize()
	end

	self:ChangedSize()
end

function PANEL:OnSizeChanged(pw, ph)
	self:InternalUpdateSize()
	self:UpdateSize()
end

function PANEL:GetContent()
	return self.con
end

function PANEL:Paint(pw, ph)
	hook.Run("YFramePaint", self, pw, ph)
end

function PANEL:Init()
	self.maximised = false
	if self._lc == nil then
		self._lc = true
	end

	if self._cb == nil then
		self._cb = true
	end

	self:SetHeaderHeight(YRP:ctr(GetGlobalYRPInt("int_headerheight", 100)))
	self._border = 20
	self:ShowCloseButton(false)
	self.close = YRPCreateD("YButton", self, self:GetHeaderHeight() * 0.6, self:GetHeaderHeight() * 0.6, self:GetWide() - self:GetHeaderHeight() * 0.8, self:GetHeaderHeight() * 0.2)
	self.close:SetText("X")
	self.close.main = self
	function self.close:Paint(pw, ph)
		hook.Run("YClosePaint", self, pw, ph)
	end

	function self.close:DoClick()
		self.main:Close()
	end

	self.btnmax = YRPCreateD("YButton", self, self:GetHeaderHeight() * 0.6, self:GetHeaderHeight() * 0.6, self:GetWide() - self:GetHeaderHeight() * 0.8, self:GetHeaderHeight() * 0.2)
	self.btnmax:SetText("[ ]")
	self.btnmax.main = self
	self.btnmax:SetVisible(self.maximised)
	function self.btnmax:Paint(pw, ph)
		hook.Run("YMaxPaint", self, pw, ph)
	end

	function self.btnmax:DoClick()
		self.main:SetMaximised(nil, "BTN")
	end

	self.langu = YRP:DChangeLanguage(self, self:GetWide() - self:GetHeaderHeight() * 0.3 * 5.6, self:GetHeaderHeight() * 0.7 / 2, self:GetHeaderHeight() * 0.3, true)
	self.con = YRPCreateD("YPanel", self, 1000, 1000, 0, 0)
	function self.con:Paint(pw, ph)
	end

	--draw.RoundedBox(0, 0, 0, pw, ph, Color( 0, 255, 0 ) )
	self.sw = self:GetWide()
	self.sh = self:GetTall()
	self.px, self.py = self:GetPos()
	self:InternalUpdateSize()
	self:UpdateSize()
end

function PANEL:Think()
	if self._headerheight ~= YRP:ctr(GetGlobalYRPInt("int_headerheight", 100)) then
		self._headerheight = YRP:ctr(GetGlobalYRPInt("int_headerheight", 100))
		self:InternalUpdateSize()
		self:UpdateSize()
	end

	if IsValid(self.langu) and self.langu ~= nil and self._lc ~= nil then
		self.langu:SetVisible(self._lc)
	end

	if self.close ~= nil and self._cb ~= nil then
		self.close:SetVisible(self._cb)
	end

	if self.sw ~= self:GetWide() or self.sh ~= self:GetTall() then
		self.sw = self:GetWide()
		self.sh = self:GetTall()
		self.close:SetSize(self:GetHeaderHeight() * 0.6, self:GetHeaderHeight() * 0.6)
		self.close:SetPos(self:GetWide() - self:GetHeaderHeight() * 0.8, self:GetHeaderHeight() * 0.2)
		if self.canmiximise then
			self.btnmax:SetSize(self:GetHeaderHeight() * 0.6, self:GetHeaderHeight() * 0.6)
			self.btnmax:SetPos(self.close:GetPos() - self.btnmax:GetWide() - YRP:ctr(20), self:GetHeaderHeight() * 0.2)
			if IsValid(self.langu) then
				self.langu:SetTall(self:GetHeaderHeight() * 0.3)
				self.langu:SetPos(self.btnmax:GetPos() - self.langu:GetWide() - YRP:ctr(20), self:GetHeaderHeight() * 0.7 / 2)
			end
		else
			if IsValid(self.langu) then
				self.langu:SetTall(self:GetHeaderHeight() * 0.3)
				self.langu:SetPos(self:GetWide() - self.langu:GetWide() - self:GetHeaderHeight() * 0.8 - self:GetHeaderHeight() * 0.2, self:GetHeaderHeight() * 0.7 / 2)
			end
		end
	end

	local mousex = math.Clamp(gui.MouseX(), 1, ScrW() - 1)
	local mousey = math.Clamp(gui.MouseY(), 1, ScrH() - 1)
	if self.Dragging then
		local x = mousex - self.Dragging[1]
		local y = mousey - self.Dragging[2]
		-- Lock to screen bounds if screenlock is enabled
		if self:GetScreenLock() then
			x = math.Clamp(x, 0, ScrW() - self:GetWide())
			y = math.Clamp(y, 0, ScrH() - self:GetTall())
		end

		self:SetPos(x, y)
	end

	if self.Sizing then
		local x = mousex - self.Sizing[1]
		local y = mousey - self.Sizing[2]
		local px, py = self:GetPos()
		if x < self.m_iMinWidth then
			x = self.m_iMinWidth
		elseif x > ScrW() - px and self:GetScreenLock() then
			x = ScrW() - px
		end

		if y < self.m_iMinHeight then
			y = self.m_iMinHeight
		elseif y > ScrH() - py and self:GetScreenLock() then
			y = ScrH() - py
		end

		self:SetSize(x, y)
		self:SetCursor("sizenwse")

		return
	end

	local screenX, screenY = self:LocalToScreen(0, 0)
	if self.Hovered and self.m_bSizable and mousex > (screenX + self:GetWide() - 20) and mousey > (screenY + self:GetTall() - 20) then
		self:SetCursor("sizenwse")

		return
	end

	if self.Hovered and self:GetDraggable() and mousey < (screenY + self:GetHeaderHeight()) then
		self:SetCursor("sizeall")

		return
	end

	self:SetCursor("arrow")
	-- Don't allow the frame to go higher than 0
	if self.y < 0 then
		self:SetPos(self.x, 0)
	end
end

vgui.Register("YFrame", PANEL, "DFrame")
