--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local _mat1 = {}
_mat1.author = "D4KiR"
_mat1.name = "Material Design 1"
RegisterDesign( _mat1 )

function _mat1.GetAlpha()
  if InterfaceTransparent() then
    return 200
  else
    return 255
  end
end

_mat1.color = {}

_mat1.color["bg"] = {}
_mat1.color["bg"]["dark"] = Color( 30, 30, 30 )
_mat1.color["bg"]["light"] = Color( 255, 255, 255 )

_mat1.color["br"] = {}
_mat1.color["br"]["dark"] = Color( 255, 255, 255 )
_mat1.color["br"]["light"] = Color( 0, 0, 0 )

_mat1.color["blue"] = {}
_mat1.color["blue"]["dark"] = Color( 0, 57, 203 )
_mat1.color["blue"]["light"] = Color( 118, 143, 255 )

_mat1.color["red"] = {}
_mat1.color["red"]["dark"] = Color( 155, 0, 0 )
_mat1.color["red"]["light"] = Color( 255, 81, 49 )

_mat1.color["green"] = {}
_mat1.color["green"]["dark"] = Color( 0, 150, 36 )
_mat1.color["green"]["light"] = Color( 94, 252, 130 )

_mat1.color["yellow"] = {}
_mat1.color["yellow"]["dark"] = Color( 199, 165, 0 )
_mat1.color["yellow"]["light"] = Color( 255, 255, 82 )

_mat1.color["brown"] = {}
_mat1.color["brown"]["dark"] = Color( 27, 0, 0 )
_mat1.color["brown"]["light"] = Color( 106, 79, 75 )

_mat1.color["orange"] = {}
_mat1.color["orange"]["dark"] = Color( 196, 60, 0 )
_mat1.color["orange"]["light"] = Color( 255, 158, 64 )

_mat1.color["purple"] = {}
_mat1.color["purple"]["dark"] = Color( 114, 0, 202 )
_mat1.color["purple"]["light"] = Color( 226, 84, 255 )

function _mat1.GetColor( color, style )
  return _mat1.color[color][style]
end

function _mat1.DrawWindow( window, pw, ph, title )
  --[[ Vars ]]--
  local _title = title or ""

  --[[ Background ]]--
  local _color_bar = _mat1.color[InterfaceColor()][InterfaceStyle()]
  local _color_bg = _mat1.color["bg"][InterfaceStyle()]
  local _color_br = _mat1.color["br"][InterfaceStyle()]
  if InterfaceTransparent() then
    if InterfaceStyle() == "dark" then
      _color_bar.a = 240
      _color_bg.a = 240
    else
      _color_bar.a = 240
      _color_bg.a = 40
    end
  end
  surfaceBox( 0, 0, pw, ctr( 50 ), _color_bar )
  surfaceBox( 0, ctr( 50 ), pw, ph - ctr( 50 ), _color_bg )
  if InterfaceBorder() then
    local _br = 2
    surfaceBox( 0, 0, pw, ctr( _br ), _color_br )
    surfaceBox( 0, ph-ctr( _br ), pw, ctr( _br ), _color_br )

    surfaceBox( pw - ctr( _br ), ctr( _br ), ctr( _br ), ph - ctr( 2*_br ), _color_br )
    surfaceBox( 0, ctr( _br ), ctr( _br ), ph - ctr( 2*_br ), _color_br )
  end

  --[[ Title ]]--
  surfaceText( _title, "mat1header", ctr( 10 ), ctr( 25 ), Color( 255, 255, 255 ), 0, 1 )
end

RegisterWindowFunction( _mat1.name, _mat1.DrawWindow )

function _mat1.DrawButton( btn, pw, ph, text )
  --[[ Vars ]]--
  local _text = text or ""

  --[[ Background ]]--
  local _color_bar = _mat1.GetColor( InterfaceColor(), InterfaceStyle() )
  local _color_br = _mat1.GetColor( "br", InterfaceStyle() )
  if InterfaceTransparent() then
    _color_bar.a = 220
  end
  local _hovered = 0
  if btn:IsHovered() then
    _hovered = 40
  end
  surfaceBox( 0, 0, pw, ph, Color( _color_bar.r + _hovered, _color_bar.g + _hovered, _color_bar.b + _hovered, _color_bar.a  ) )
  if InterfaceBorder() then
    local _br = 2
    surfaceBox( 0, 0, pw, ctr( _br ), _color_br )
    surfaceBox( 0, ph-ctr( _br ), pw, ctr( _br ), _color_br )

    surfaceBox( pw - ctr( _br ), ctr( _br ), ctr( _br ), ph - ctr( 2*_br ), _color_br )
    surfaceBox( 0, ctr( _br ), ctr( _br ), ph - ctr( 2*_br ), _color_br )
  end

  --[[ text ]]--
  surfaceText( _text, "mat1text", pw/2, ph/2, Color( 255, 255, 255 ), 1, 1 )
end
RegisterButtonFunction( _mat1.name, _mat1.DrawButton )

function _mat1.DrawPanel( pnl, pw, ph, text )
  --[[ Vars ]]--
  local _text = text or ""

  --[[ Background ]]--
  local _color_bar = _mat1.GetColor( InterfaceColor(), InterfaceStyle() )
  local _color_br = _mat1.GetColor( "br", InterfaceStyle() )
  if InterfaceTransparent() then
    _color_bar.a = 220
  end
  surfaceBox( 0, 0, pw, ph,_color_bar )
  if InterfaceBorder() then
    local _br = 2
    surfaceBox( 0, 0, pw, ctr( _br ), _color_br )
    surfaceBox( 0, ph-ctr( _br ), pw, ctr( _br ), _color_br )

    surfaceBox( pw - ctr( _br ), ctr( _br ), ctr( _br ), ph - ctr( 2*_br ), _color_br )
    surfaceBox( 0, ctr( _br ), ctr( _br ), ph - ctr( 2*_br ), _color_br )
  end

  --[[ text ]]--
  surfaceText( _text, "mat1text", pw/2, ph/2, Color( 255, 255, 255 ), 1, 1 )
end
RegisterPanelFunction( _mat1.name, _mat1.DrawPanel )
