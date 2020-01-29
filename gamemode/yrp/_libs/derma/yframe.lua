--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local PANEL = {}

function PANEL:GetLanguageChanger()
	return self._lc or true
end

function PANEL:SetLanguageChanger(b)
	self._lc = b
end

function PANEL:GetHeaderHeight()
	return self._headerheight or 24
end

function PANEL:SetHeaderHeight(num)
	if isnumber(num) then
		self._headerheight = num
	else
		printGM("note", "SetHeaderHeight | num is not a number: " .. tostring(num) .. "!")
	end
	self:UpdateSize()
end

function PANEL:GetBorder()
	return self._headerheight
end

function PANEL:SetBorder(b)
	self._border = b
end

function PANEL:SetCloseButton( bShow )
	self._cb = bShow
end

function PANEL:OnMousePressed()
	local screenX, screenY = self:LocalToScreen( 0, 0 )

	if ( self.m_bSizable && gui.MouseX() > ( screenX + self:GetWide() - 20 ) && gui.MouseY() > ( screenY + self:GetTall() - 20 ) ) then
		self.Sizing = { gui.MouseX() - self:GetWide(), gui.MouseY() - self:GetTall() }
		self:MouseCapture( true )
		return
	end

	if ( self:GetDraggable() && gui.MouseY() < ( screenY + self:GetHeaderHeight() ) ) then
		self.Dragging = { gui.MouseX() - self.x, gui.MouseY() - self.y }
		self:MouseCapture( true )
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

function PANEL:Sizable(b)
	self.btnMaxim:SetDisabled(!b)

	local panel = self
	function self.btnMaxim.DoClick()
		panel.fullscreen = !panel.fullscreen or false

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
	local br = YRP.ctr(self._border)
	local header = self:GetHeaderHeight()
	local pw = self:GetWide()
	local ph = self:GetTall()
	self.con:SetSize(pw - 2 * br, ph - header - 2 * br)
	self.con:SetPos(br, header + br)
end

function PANEL:OnSizeChanged(pw, ph)
	self:UpdateSize()
end

function PANEL:GetContent()
	return self.con
end

function PANEL:Paint(pw, ph)
	hook.Run("YFramePaint", self, pw, ph)
end

function PANEL:Init()
	if self._lc == nil then
		self._lc = true
	end
	if self._cb == nil then
		self._cb = true
	end

	self._headerheight = 24
	self._border = 20

	self:ShowCloseButton(false)

	self.close = createD("YButton", self, self:GetHeaderHeight() * 0.6, self:GetHeaderHeight() * 0.6, self:GetWide() - self:GetHeaderHeight() * 0.8, self:GetHeaderHeight() * 0.2)
	self.close:SetText("X")
	self.close.main = self
	function self.close:Paint(pw, ph)
		hook.Run("YClosePaint", self, pw, ph)
	end
	function self.close:DoClick()
		self.main:Close()
	end

	self.langu = YRP.DChangeLanguage(self, self:GetWide() - YRP.ctr(60 * 1.4903 + 20 + 60 + 20), YRP.ctr(20), YRP.ctr(60), true)

	self.con = createD("YPanel", self, 10, 10, 0, 0)
	function self.con:Paint(pw, ph)
	end

	self.sw = self:GetWide()
	self.sh = self:GetTall()
	self.px, self.py = self:GetPos()

	self:UpdateSize()
end

function PANEL:Think()
	if IsValid(self.langu) and self.langu != nil and self._lc != nil then
		self.langu:SetVisible(self._lc)
	end
	if self.close != nil and self._cb != nil then
		self.close:SetVisible(self._cb)
	end

	if self.sw != self:GetWide() or self.sh != self:GetTall() then
		self.sw = self:GetWide()
		self.sh = self:GetTall()

		self.close:SetSize(self:GetHeaderHeight() * 0.6, self:GetHeaderHeight() * 0.6)
		self.close:SetPos(self:GetWide() - self:GetHeaderHeight() * 0.8, self:GetHeaderHeight() * 0.2)

		if IsValid(self.langu) then
			self.langu:SetSize(self:GetHeaderHeight() * 0.6 * 1.4903, self:GetHeaderHeight() * 0.6)
			self.langu:SetPos(self:GetWide() - self:GetHeaderHeight() * 0.6 * 1.4903 - self:GetHeaderHeight() * 0.8 - self:GetHeaderHeight() * 0.2, self:GetHeaderHeight() * 0.2)
		end
	end

	local mousex = math.Clamp( gui.MouseX(), 1, ScrW() - 1 )
	local mousey = math.Clamp( gui.MouseY(), 1, ScrH() - 1 )

	if ( self.Dragging ) then

		local x = mousex - self.Dragging[1]
		local y = mousey - self.Dragging[2]

		-- Lock to screen bounds if screenlock is enabled
		if ( self:GetScreenLock() ) then

			x = math.Clamp( x, 0, ScrW() - self:GetWide() )
			y = math.Clamp( y, 0, ScrH() - self:GetTall() )

		end

		self:SetPos( x, y )

	end

	if ( self.Sizing ) then

		local x = mousex - self.Sizing[1]
		local y = mousey - self.Sizing[2]
		local px, py = self:GetPos()

		if ( x < self.m_iMinWidth ) then x = self.m_iMinWidth elseif ( x > ScrW() - px && self:GetScreenLock() ) then x = ScrW() - px end
		if ( y < self.m_iMinHeight ) then y = self.m_iMinHeight elseif ( y > ScrH() - py && self:GetScreenLock() ) then y = ScrH() - py end

		self:SetSize( x, y )
		self:SetCursor( "sizenwse" )

		return
	end

	local screenX, screenY = self:LocalToScreen( 0, 0 )

	if ( self.Hovered && self.m_bSizable && mousex > ( screenX + self:GetWide() - 20 ) && mousey > ( screenY + self:GetTall() - 20 ) ) then

		self:SetCursor( "sizenwse" )
		return

	end

	if ( self.Hovered && self:GetDraggable() && mousey < ( screenY + self:GetHeaderHeight() ) ) then
		self:SetCursor( "sizeall" )
		return
	end

	self:SetCursor( "arrow" )

	-- Don't allow the frame to go higher than 0
	if ( self.y < 0 ) then
		self:SetPos( self.x, 0 )
	end

end

vgui.Register("YFrame", PANEL, "DFrame")
