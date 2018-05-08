--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

net.Receive( "getMoneyTab", function()
  local _tmpTable = net.ReadTable()

  local _moneyPre = createVGUI( "DTextEntry", settingsWindow.window.site, 100, 50, 10, 50 )
  function _moneyPre:OnChange()
    net.Start( "updateMoney" )
      net.WriteString( "moneypre" )
      net.WriteString( _moneyPre:GetText() )
    net.SendToServer()
  end

  local _moneyPos = createVGUI( "DTextEntry", settingsWindow.window.site, 100, 50, 900, 50 )
  function _moneyPos:OnChange()
    net.Start( "updateMoney" )
      net.WriteString( "moneypos" )
      net.WriteString( _moneyPos:GetText() )
    net.SendToServer()
  end

  local _moneyStart = createVGUI( "DNumberWang", settingsWindow.window.site, 100, 50, 10, 350 )
  _moneyStart:SetMax( 999999999999 )
  _moneyStart:SetMin( -9999 )
  function _moneyStart:OnChange()
    net.Start( "updateMoney" )
      net.WriteString( "moneystart" )
      net.WriteString( _moneyStart:GetText() )
    net.SendToServer()
  end

  _moneyPre:SetText( _tmpTable.moneypre )
  _moneyPos:SetText( _tmpTable.moneypos )
  _moneyStart:SetText( _tmpTable.moneystart )

  function settingsWindow.window.site:Paint( pw, ph )
    draw.RoundedBox( 4, 0, 0, pw, ph, get_dbg_col() )

    draw.SimpleTextOutlined( lang_string( "moneypre" ), "sef", ctr( 10 ), ctr( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color( 0, 0, 0 ) )

    draw.SimpleTextOutlined( lang_string( "moneypos" ), "sef", ctr( 900 ), ctr( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color( 0, 0, 0 ) )

    draw.SimpleTextOutlined( lang_string( "startmoney" ), "sef", ctr( 10 ), ctr( 350 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color( 0, 0, 0 ) )

    draw.SimpleTextOutlined( lang_string( "preview" ) .. ": " .. _moneyPre:GetText() .. _moneyStart:GetValue() .. _moneyPos:GetText(), "sef", ctr( 500 ), ctr( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color( 0, 0, 0 ) )
  end
end)

hook.Add( "open_server_money", "open_server_money", function()
  SaveLastSite()
  local ply = LocalPlayer()

  local w = settingsWindow.window.sitepanel:GetWide()
  local h = settingsWindow.window.sitepanel:GetTall()

  settingsWindow.window.site = createD( "DPanel", settingsWindow.window.sitepanel, w, h, 0, 0 )
  if ply:HasAccess() then
    net.Start( "getMoneyTab" )
    net.SendToServer()
  else
    F8RequireUG( lang_string( "money" ), "superadmin or admin" )
  end
end)
