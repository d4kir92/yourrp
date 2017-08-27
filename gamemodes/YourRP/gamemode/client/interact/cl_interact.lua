--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local tmpTargetSteamID = ""
function openInteractMenu( steamID )
  tmpTargetSteamID = steamID
  net.Start( "openInteractMenu" )
    net.WriteString( tmpTargetSteamID )
  net.SendToServer()
end

net.Receive( "openInteractMenu", function ()
  local isInstructor = net.ReadBool()

  local promoteable = net.ReadBool()
  local promoteName = net.ReadString()

  local demoteable = net.ReadBool()
  local demoteName = net.ReadString()

  _windowInteract = createVGUI( "DFrame", nil, 830, 400, ScrW() - 160, ScrH() - 200 )
  local tmpTargetName = ""
  local tmpFirstName = ""
  local tmpSurName = ""
  for k, v in pairs ( player.GetAll() ) do
    if tostring( v:SteamID() ) == tostring( tmpTargetSteamID ) then
      tmpTargetName = v:Nick()
      tmpFirstName = v:GetNWString( "FirstName" )
      tmpSurName = v:GetNWString( "SurName" )
    end
  end
  _windowInteract:SetTitle( lang.interactmenu )
  function _windowInteract:OnClose()
    gui.EnableScreenClicker( false )
    _windowInteract = nil
    _menuIsOpen = 0
  end
  function _windowInteract:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 160 ) )
    draw.SimpleText( lang.nick .. ": " .. tmpTargetName .. " ( SteamID: " .. tmpTargetSteamID .. " )", "SettingsNormal", ctrW( 10 ), ctrW( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    draw.SimpleText( lang.name .. ": " .. tmpSurName .. ", " .. tmpFirstName, "SettingsNormal", ctrW( 10 ), ctrW( 80 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
  end

  local buttonTrade = createVGUI( "DButton", _windowInteract, 400, 50, 10, 120 )
  buttonTrade:SetText( lang.trade .. " (NOT AVAILABLE: InWork)" )

  if isInstructor then
    _windowInteract:SetSize( ctrW( 830 ), ctrW( 400 ) )
    _windowInteract:SetPos( ScrW()/2 - ctrW( 415 ), ScrH()/2 - ctrW( 200 ) )

    if promoteable then
      local buttonPromote = createVGUI( "DButton", _windowInteract, 400, 50, 420, 120 )
      buttonPromote:SetText( lang.promote .. ": " .. promoteName )
      function buttonPromote:DoClick()
        net.Start( "promotePlayer" )
          net.WriteString( tmpTargetSteamID )
        net.SendToServer()
        _windowInteract:Close()
      end
    end

    if demoteable then
      local buttonDemote = createVGUI( "DButton", _windowInteract, 400, 50, 420, 120 + 10 + 50 )
      buttonDemote:SetText( lang.demote .. ": " .. demoteName )
      function buttonDemote:DoClick()
        net.Start( "demotePlayer" )
          net.WriteString( tmpTargetSteamID )
        net.SendToServer()
        _windowInteract:Close()
      end
    end
  end

  _windowInteract:Center()
  _windowInteract:MakePopup()
  gui.EnableScreenClicker( true )
end)
