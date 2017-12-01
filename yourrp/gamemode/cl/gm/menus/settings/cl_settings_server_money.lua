--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

net.Receive( "getMoneyTab", function()
  local _tmpTable = net.ReadTable()

  local _moneyPre = createVGUI( "DTextEntry", settingsWindow.site, 100, 50, 10, 40 )
  function _moneyPre:OnChange()
    net.Start( "updateMoney" )
      net.WriteString( "moneypre" )
      net.WriteString( _moneyPre:GetText() )
    net.SendToServer()
  end

  local _moneyPost = createVGUI( "DTextEntry", settingsWindow.site, 100, 50, 10, 40 + 50 + 50 )
  function _moneyPost:OnChange()
    net.Start( "updateMoney" )
      net.WriteString( "moneypost" )
      net.WriteString( _moneyPost:GetText() )
    net.SendToServer()
  end

  local _moneyStart = createVGUI( "DTextEntry", settingsWindow.site, 100, 50, 10, 40 + 50 + 50 + 50 + 50 )
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

hook.Add( "open_server_money", "open_server_money", function()
  local ply = LocalPlayer()

  local w = settingsWindow.sitepanel:GetWide()
  local h = settingsWindow.sitepanel:GetTall()

  settingsWindow.site = createD( "DPanel", settingsWindow.sitepanel, w, h, 0, 0 )

  function settingsWindow.site:Paint( pw, ph )
    draw.RoundedBox( 4, 0, 0, pw, ph, get_dbg_col() )

    draw.SimpleTextOutlined( lang_string( "moneypre" ), "sef", ctr( 10 ), ctr( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color( 0, 0, 0 ) )

    draw.SimpleTextOutlined( lang_string( "moneypos" ), "sef", ctr( 10 ), ctr( 150 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color( 0, 0, 0 ) )

    draw.SimpleTextOutlined( lang_string( "startmoney" ), "sef", ctr( 10 ), ctr( 250 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color( 0, 0, 0 ) )
  end

  net.Start( "getMoneyTab" )
  net.SendToServer()
end)
