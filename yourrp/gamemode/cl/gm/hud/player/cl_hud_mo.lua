--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local money = Material( "icon16/money.png" )

function hudMO( ply, color )
  --Money
  local _money = tonumber( ply:GetNWString( "money" ) )
  local _pre = ply:GetNWString( "moneyPre", "" )
  local _pos = ply:GetNWString( "moneyPost", "" )
  _money = roundMoney( _money, 1 )
  local _motext = _pre .. tostring(_money) .. _pos
  local _salary = tonumber( ply:GetNWString( "salary" ) )
  if _salary > 0 then
    _motext = _motext .. " (+".. ply:GetNWString( "moneyPre" ) .. roundMoney( _salary, 1 ) .. ply:GetNWString( "moneyPost" ) .. ")"
    _salaryMin = CurTime() + ply:GetNWInt( "salarytime" ) - 1 - ply:GetNWInt( "nextsalarytime" )
    _salaryMax = ply:GetNWInt( "salarytime" )
  else
    _salaryMin = 1
    _salaryMax = 1
  end
  drawHUDElement( "mo", _salaryMin, _salaryMax, _motext, money, color )
end

function hudMOBR()
  drawHUDElementBr( "mo" )
end
