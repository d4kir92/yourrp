--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--cl_settings_server_money.lua

net.Receive( "getMoneyTab", function()
  local _tmpTable = net.ReadTable()

  local _moneyPre = createVGUI( "DTextEntry", sv_moneyPanel, 100, 50, 10, 40 )
  function _moneyPre:OnChange()
    net.Start( "updateMoney" )
      net.WriteString( "moneypre" )
      net.WriteString( _moneyPre:GetText() )
    net.SendToServer()
  end

  local _moneyPost = createVGUI( "DTextEntry", sv_moneyPanel, 100, 50, 10, 40 + 50 + 50 )
  function _moneyPost:OnChange()
    net.Start( "updateMoney" )
      net.WriteString( "moneypost" )
      net.WriteString( _moneyPost:GetText() )
    net.SendToServer()
  end

  local _moneyStart = createVGUI( "DTextEntry", sv_moneyPanel, 100, 50, 10, 40 + 50 + 50 + 50 + 50 )
  function _moneyStart:OnChange()
    net.Start( "updateMoney" )
      net.WriteString( "moneystart" )
      net.WriteString( _moneyStart:GetText() )
    net.SendToServer()
  end

  for k, v in pairs( _tmpTable ) do
    if v.name == "moneypre" then
      _moneyPre:SetText( v.value )
    elseif v.name == "moneypost" then
      _moneyPost:SetText( v.value )
    elseif v.name == "moneystart" then
      _moneyStart:SetText( v.value )
    end
  end
end)

function tabServerMoney( sheet )
  local ply = LocalPlayer()

  sv_moneyPanel = vgui.Create( "DPanel", sheet )
  sheet:AddSheet( lang.money, sv_moneyPanel, "icon16/money.png" )
  function sv_moneyPanel:Paint( pw, ph )
    draw.RoundedBox( 4, 0, 0, pw, ph, yrp.colors.background )

    draw.SimpleText( lang.moneypre, "sef", ctrW( 10 ), ctrW( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )

    draw.SimpleText( lang.moneypos, "sef", ctrW( 10 ), ctrW( 150 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )

    draw.SimpleText( lang.startmoney, "sef", ctrW( 10 ), ctrW( 250 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
  end

  net.Start( "getMoneyTab" )
  net.SendToServer()
end
