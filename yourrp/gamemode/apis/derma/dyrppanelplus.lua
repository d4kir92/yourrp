--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local PANEL = {}

function PANEL:Init()
  self.header = createD( "DPanel", self, self:GetWide(), ctr( 50 ), 0, 0 )
  self.header.text = "UNNAMED"
  function self:SetHeader( text )
    self.header.text = text
  end
  self.header.color = Color( 255, 255, 255, 255 )
  function self.header:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, self.color )
    surfaceText( db_out_str( self.text ), "SettingsNormal", pw/2, ph/2, Color( 255, 255, 255 ), 1, 1 )
  end
end

function PANEL:INITPanel( derma )
  self.plus = createD( derma, self, self:GetWide(), self:GetTall() - self.header:GetTall(), 0, self.header:GetTall() )
  function self:SetText( text )
    self.plus:SetText( text )
  end
end

function PANEL:Think()
  if self.header:GetWide() != self:GetWide() then
    self.header:SetWide( self:GetWide() )
  end
  if self.plus:GetWide() != self:GetWide() then
    self.plus:SetWide( self:GetWide() )
  end

  if self.plus:GetTall() != self:GetTall() - self.header:GetTall() then
    self.plus:SetTall( self:GetTall() - self.header:GetTall() )
  end

  local _px, _py = self.plus:GetPos()
  if _py != self.header:GetTall() then
    print("RESPOSITING")
    self.plus:SetPos( 0, self.header:GetTall() )
  end
end

function PANEL:Paint( w, h )
  draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 0, 0 ) )
end


vgui.Register( "DYRPPanelPlus", PANEL, "Panel" )
