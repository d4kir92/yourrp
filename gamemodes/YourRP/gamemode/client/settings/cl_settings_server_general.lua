//cl_settings_server_general.lua

local _advertname = "NULL"
function tabServerGeneral( sheet )
  local ply = LocalPlayer()

  local sv_generalPanel = vgui.Create( "DPanel", sheet )
  sheet:AddSheet( "General", sv_generalPanel, "icon16/server_database.png" )

  local sv_generalName = vgui.Create( "DTextEntry", sv_generalPanel )
  local sv_generalStartMoney = vgui.Create( "DTextEntry", sv_generalPanel )
  local sv_generalAdvert = vgui.Create( "DTextEntry", sv_generalPanel )

  local oldGamemodename = ""
  local startmoney = -1
  local oldstartmoney = -1
  function sv_generalPanel:Paint()
    //draw.RoundedBox( 0, 0, 0, sv_generalPanel:GetWide(), sv_generalPanel:GetTall(), yrpsettings.color.panel )
    draw.SimpleText( "Gamemode Name:", "SettingsNormal", calculateToResu( 300 - 10 ), calculateToResu( 5 + 25 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
    if oldGamemodename != sv_generalName:GetText() then
      draw.SimpleText( "you need to restart Server!", "SettingsNormal", calculateToResu( 300 + 400 + 10 ), calculateToResu( 5 + 25 ), Color( 255, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    end
    draw.SimpleText( "Start Money:", "SettingsNormal", calculateToResu( 300 - 10 ), calculateToResu( 5 + 25 + 50 + 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
    draw.SimpleText( "Advert Channelname:", "SettingsNormal", calculateToResu( 300 - 10 ), calculateToResu( 5 + 25 + 50 + 10 + 50 + 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
  end

  sv_generalName:SetPos( calculateToResu( 300 ), calculateToResu( 5 ) )
  sv_generalName:SetSize( calculateToResu( 400 ), calculateToResu( 50 ) )
  sv_generalName:SetText( GAMEMODE.Name )

  net.Start("dbGetGeneral")
  net.SendToServer()

  net.Receive( "dbGetGeneral", function()
    local tmpTable = net.ReadTable()
    for k, v in pairs( tmpTable ) do
      if v.name == "gamemodename" then
        GAMEMODE.Name = v.value
        oldGamemodename = v.value
        if sv_generalName != nil then
          sv_generalName:SetText( GAMEMODE.Name )
        end
      elseif v.name == "startmoney" then
        startmoney = v.value
        oldstartmoney = v.value
        if sv_generalStartMoney != nil then
          sv_generalStartMoney:SetText( startmoney )
        end
      elseif v.name == "advert" then
        _advertname = v.value
        if sv_generalAdvert != nil then
          sv_generalAdvert:SetText( tostring( _advertname ) )
        end
      end
    end
  end)

  sv_generalStartMoney:SetPos( calculateToResu( 300 ), calculateToResu( 5 + 50 + 10 ) )
  sv_generalStartMoney:SetSize( calculateToResu( 400 ), calculateToResu( 50 ) )

  sv_generalAdvert:SetPos( calculateToResu( 300 ), calculateToResu( 5 + 50 + 10 + 50 + 10 ) )
  sv_generalAdvert:SetSize( calculateToResu( 400 ), calculateToResu( 50 ) )
  sv_generalAdvert:SetText( _advertname )
  function sv_generalAdvert:OnChange()
    net.Start( "updateAdvert" )
      net.WriteString( sv_generalAdvert:GetText() )
    net.SendToServer()
  end

  local sv_generalRestartTime = vgui.Create( "DNumSlider", sv_generalPanel )
  sv_generalRestartTime:SetPos( calculateToResu( 10 ), calculateToResu( 5 + 50 + 10 + 50 + 10 + 50 + 10 ) )
  sv_generalRestartTime:SetSize( calculateToResu( 1800 ), calculateToResu( 50 ) )
  sv_generalRestartTime:SetText( "Restart Time" )
  sv_generalRestartTime:SetMin( 3 )
  sv_generalRestartTime:SetMax( 60 )
  sv_generalRestartTime:SetDecimals( 0 )
  net.Start( "selectGeneral" )
    net.WriteString( "restart_time" )
  net.SendToServer()
  net.Receive( "selectGeneral", function()
    local tmp = net.ReadString()
    if tmp == "restart_time" then
      if sv_generalRestartTime != nil then
        local _restartTime = tonumber( net.ReadString() )
        if _restartTime != nil then
          sv_generalRestartTime:SetValue( _restartTime )
        end
      end
    end
  end)
  function sv_generalRestartTime:OnValueChanged( value )
    net.Start( "updateGeneral" )
      net.WriteString( tostring( math.Round( value ) ) )
      net.WriteString( "restart_time" )
    net.SendToServer()
  end

  local sv_generalRestartServer = vgui.Create( "DButton", sv_generalPanel )
  sv_generalRestartServer:SetSize( calculateToResu( 200 ), calculateToResu( 50 ) )
  sv_generalRestartServer:SetPos( calculateToResu( 5 ), calculateToResu( 5 + 50 + 10 + 50 + 10 + 50 + 10 + 50 + 10 ) )
  sv_generalRestartServer:SetText( "Restart Server")
  function sv_generalRestartServer:Paint()
    local color = Color( 255, 0, 0, 200 )
    if sv_generalRestartServer:IsHovered() then
      color = Color( 255, 255, 0, 200 )
    end
    draw.RoundedBox( calculateToResu( 10 ), 0, 0, sv_generalRestartServer:GetWide(), sv_generalRestartServer:GetTall(), color )
  end
  function sv_generalRestartServer:DoClick()
    if sv_generalName != nil then
      net.Start( "restartServer" )
        GAMEMODE.Name = sv_generalName:GetText()
        net.WriteString( GAMEMODE.Name )
        startmoney = tonumber( sv_generalStartMoney:GetText() )
        net.WriteInt( startmoney, 16 )
        net.WriteInt( math.Round( sv_generalRestartTime:GetValue() ), 16 )
      net.SendToServer()
    end
    settingsWindow:Close()
  end

  local sv_generalRestartServerCancel = vgui.Create( "DButton", sv_generalPanel )
  sv_generalRestartServerCancel:SetSize( calculateToResu( 260 ), calculateToResu( 50 ) )
  sv_generalRestartServerCancel:SetPos( calculateToResu( 5 + 200 + 10 ), calculateToResu( 5 + 50 + 10 + 50 + 10 + 50 + 10 + 50 + 10 ) )
  sv_generalRestartServerCancel:SetText( "Cancel Restart Server")
  function sv_generalRestartServerCancel:Paint()
    local color = Color( 0, 255, 0, 200 )
    if sv_generalRestartServerCancel:IsHovered() then
      color = Color( 255, 255, 0, 200 )
    end
    draw.RoundedBox( calculateToResu( 10 ), 0, 0, sv_generalRestartServerCancel:GetWide(), sv_generalRestartServerCancel:GetTall(), color )
  end
  function sv_generalRestartServerCancel:DoClick()
    net.Start( "cancelRestartServer" )
    net.SendToServer()
    settingsWindow:Close()
  end
end
