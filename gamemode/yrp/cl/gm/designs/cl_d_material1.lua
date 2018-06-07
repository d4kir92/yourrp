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
_mat1.color["bg"]["dark"] = Color( 90, 90, 90 )
_mat1.color["bg"]["light"] = Color( 255, 255, 255 )

_mat1.color["br"] = {}
_mat1.color["br"]["dark"] = Color( 255, 255, 255 )
_mat1.color["br"]["light"] = Color( 0, 0, 0 )

_mat1.color["blue"] = {}
_mat1.color["blue"]["dark"] = Color( 0, 57, 203 )
_mat1.color["blue"]["light"] = Color( 118, 143, 255 )
_mat1.color["blue"]["1"] = Color( 46, 135, 255 )
_mat1.color["blue"]["2"] = Color( 26, 121, 255 )
_mat1.color["blue"]["3"] = Color( 13, 63, 135 )
_mat1.color["blue"]["4"] = Color( 90, 90, 90 )
_mat1.color["blue"]["5"] = Color( 51, 51, 51 )

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
  local _color_bar = _mat1.GetColor( "blue", "2" )
  local _color_bg = _mat1.color["bg"][InterfaceStyle()]
  local _color_br = _mat1.color["br"][InterfaceStyle()]
  if InterfaceTransparent() then
    if InterfaceStyle() == "dark" then
      _color_bar.a = 100
      _color_bg.a = 100
    else
      _color_bar.a = 100
      _color_bg.a = 20
    end
  else
    _color_bar.a = 255
    _color_bg.a = 255
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
  surfaceText( lang_string( _title ), "mat1header", ctr( 10 ), ctr( 25 ), Color( 255, 255, 255 ), 0, 1, 1 )
end

RegisterWindowFunction( _mat1.name, _mat1.DrawWindow )

function _mat1.DrawButton( btn, pw, ph, text, color, px, py, ax, ah )
  --[[ Vars ]]--
  local _text = text or ""

  --[[ Background ]]--
  local _color_bar = _mat1.GetColor( "blue", "2" )
  local _color_br = _mat1.GetColor( "br", InterfaceStyle() )
  if InterfaceTransparent() then
    _color_bar.a = 220
  else
    _color_bar.a = 255
  end
  if btn:IsHovered() then
    _color_bar = _mat1.GetColor( "blue", "1" )
  end
  local _color = color or _color_bar
  surfaceBox( 0, 0, pw, ph, _color )
  if InterfaceBorder() then
    local _br = 2
    surfaceBox( 0, 0, pw, ctr( _br ), _color_br )
    surfaceBox( 0, ph-ctr( _br ), pw, ctr( _br ), _color_br )

    surfaceBox( pw - ctr( _br ), ctr( _br ), ctr( _br ), ph - ctr( 2*_br ), _color_br )
    surfaceBox( 0, ctr( _br ), ctr( _br ), ph - ctr( 2*_br ), _color_br )
  end

  --[[ text ]]--
  surfaceText( lang_string( _text ), "mat1text", px or pw/2, py or ph/2, Color( 255, 255, 255 ), ax or 1, ay or 1, 1 )
end
RegisterButtonFunction( _mat1.name, _mat1.DrawButton )

function _mat1.DrawPanel( pnl, pw, ph, text, color, px, py, ax, ah )
  --[[ Vars ]]--
  local _text = text or ""

  --[[ Background ]]--
  local _color_bar = _mat1.GetColor( "blue", "2" )
  local _color_br = _mat1.GetColor( "br", InterfaceStyle() )
  if InterfaceTransparent() then
    _color_bar.a = 220
  else
    _color_bar.a = 255
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
  surfaceText( lang_string( _text ), "mat1text", px or pw/2, py or ph/2, color or Color( 255, 255, 255, 255 ), ax or 1, ay or 1, 1 )
end
RegisterPanelFunction( _mat1.name, _mat1.DrawPanel )
