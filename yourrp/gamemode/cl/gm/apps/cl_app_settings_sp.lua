--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local APP = {}
APP.PrintName = "SP Settings"
APP.LangName = "settings"
APP.ClassName = "sp_settings"

APP.Icon = Material( "vgui/yrp/dark_settings.png" )

function APP:AppIcon( pw, ph )
  surface.SetDrawColor( 255, 255, 255, 255 )
  surface.SetMaterial( self.Icon	)
  surface.DrawTexturedRect( 0, 0, pw, ph )

  --draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 255 ) )
end

function drawText( text, font, x, y, color, ax, ay )
  surface.SetFont( font )

  local _tw, _th = surface.GetTextSize( text )
  if ax == 1 then
    x = x - _tw/2
  elseif ax == 2 then
    x = x - _tw
  end
  if ay == 1 then
    y = y - _th/2
  elseif ay == 2 then
    y = y - _th
  end
  surface.SetTextPos( x, y )

  surface.SetTextColor( color )
  surface.DrawText( text )
end

function APP:OpenApp( display, x, y, w, h )
  local _tmp = createD( "DPanel", display, w, h, x, y )
  function _tmp:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 200, 200, 200, 255 ) )

    draw.RoundedBox( 0, 0, 0, pw, ctrb( 60 ), Color( 40, 40, 40, 255 ) )
    drawText( lang_string( "settings" ), "apph1", ctrb( 10 ), ctrb( 30 ), Color( 255, 255, 255 ), 0, 1 )
  end

  _tmp.colors = createD( "DButton", display, w, ctrb( 60 ), x, y + ctrb( 60 ) )
  _tmp.colors:SetText( "" )
  function _tmp.colors:Paint( pw, ph )
    if self:IsHovered() then
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 200, 255 ) )
    else
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
    end
    drawText( lang_string( "colorsettings" ), "apph1", pw/2, ph/2, Color( 0, 0, 0 ), 1, 1 )
  end
  function _tmp.colors:DoClick()
    _tmp.menu_color = createD( "DPanel", display, w, h, x, y )
    function _tmp.menu_color:Paint( pw, ph )
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 200, 200, 200, 255 ) )

      draw.RoundedBox( 0, 0, 0, pw, ctrb( 60 ), Color( 40, 40, 40, 255 ) )
      drawText( lang_string( "colorsettings" ), "apph1", ctrb( 10 ), ctrb( 30 ), Color( 255, 255, 255 ), 0, 1 )
    end
    local Mixer = createD( "DColorMixer", _tmp.menu_color, w, w, 0, ctrb( 60 ) )
    Mixer:SetPalette( true )
    Mixer:SetAlphaBar( true )
    Mixer:SetWangs( true )
    Mixer:SetColor( getSpCaseColor() )
    function Mixer:ValueChanged( col )
      local _str_col = col.r .. "," .. col.g .. "," .. col.b .. "," .. col.a
      setSpCaseColor( _str_col )
    end
  end
end

addApp( APP )
