--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local PANEL = {}

function PANEL:Init()
  self.header = createD( "DPanel", self, self:GetWide(), ctr( 50 ), 0, 0 )
  self.header.text = "UNNAMED"
  function self:SetHeader( text )
    self.header.text = text
  end
  function self.header:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255 ) )
    surfaceText( db_out_str( self.text ), "SettingsNormal", pw/2, ph/2, Color( 255, 255, 255 ), 1, 1 )
  end

  self.textentry = createD( "DTextEntry", self, self:GetWide(), self:GetTall() - self.header:GetTall(), 0, ctr( 50 ) )
  function self:SetText( text )
    self.textentry:SetText( text )
  end
end

function PANEL:Think()
  if self.header:GetWide() != self:GetWide() then
    self.header:SetWide( self:GetWide() )
  end
  if self.textentry:GetWide() != self:GetWide() then
    self.textentry:SetWide( self:GetWide() )
  end

  if self.textentry:GetTall() != self:GetTall() - self.header:GetTall() then
    self.textentry:SetTall( self:GetTall() - self.header:GetTall() )
  end

  if self.textentry:GetPos() != self:GetPos() + ctr( 50 ) then
    self.textentry:SetPos( 0, self:GetPos() + ctr( 50 ) )
  end
end

function PANEL:Paint( w, h )
  draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 0, 0 ) )
end


vgui.Register( "DYRPTextEntry", PANEL, "Panel" )
