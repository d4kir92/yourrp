--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function ggT( _num1, _num2 )
  local _ggt = _num1 % _num2
  while ( _ggt != 0 ) do
    _num1 = _num2
    _num2 = _ggt

    _ggt = _num1 % _num2
  end
  return _num2
end

function getResolutionRatio()
  local _ggt = ggT( ScrW(), ScrH() )
  return ScrW()/_ggt, ScrH()/_ggt
end

function getPictureRatio( w, h )
  local _ggt = ggT( w, h )
  return w/_ggt, h/_ggt
end

function lowerToScreen( w, h )
  local tmpW = w
  local tmpH = h
  if w > ScrW() then
    local per = tmpW / ScrW()
    tmpW = tmpW / per
    tmpH = tmpH / per
  end
  if tmpH > ScrH() then
    local per = tmpH / ScrH()
    tmpW = tmpW / per
    tmpH = tmpH / per
  end
  return tmpW, tmpH
end

function ctrF( tmpNumber )
  tmpNumber = 2160/tmpNumber
  return math.Round( tmpNumber, 8 )
end

function ctr( tmpNumber )
  if isnumber( tonumber( tmpNumber ) ) and tmpNumber != nil then
    tmpNumber = 2160/tmpNumber
    local _screen_h = ScrH() or 0
    return math.Round( _screen_h/tmpNumber )
  else
    return -1
  end
end

function ScrW2()
  return ( ScrW() / 2 )
end

function ScrH2()
  return ( ScrH() / 2 )
end

function formatMoney( ply, money )
  return ply:GetNWString( "moneyPre" ) .. money .. ply:GetNWString( "moneyPost" )
end
