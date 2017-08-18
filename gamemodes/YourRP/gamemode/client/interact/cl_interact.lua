
local tmpTargetSteamID = ""
function openInteractMenu( steamID )
  tmpTargetSteamID = steamID
  net.Start( "openInteractMenu" )
    net.WriteString( tmpTargetSteamID )
  net.SendToServer()
end

net.Receive( "openInteractMenu", function ()
  _menuIsOpen = 1
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
  _windowInteract:SetTitle( "Interact Menu" )
  function _windowInteract:OnClose()
    gui.EnableScreenClicker( false )
    _windowInteract = nil
    _menuIsOpen = 0
  end
  function _windowInteract:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 160 ) )
    draw.SimpleText( "Nick: " .. tmpTargetName .. " ( SteamID: " .. tmpTargetSteamID .. " )", "DermaDefault", calculateToResu( 10 ), calculateToResu( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    draw.SimpleText( "Name: " .. tmpSurName .. ", " .. tmpFirstName, "DermaDefault", calculateToResu( 10 ), calculateToResu( 80 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
  end

  local buttonTrade = createVGUI( "DButton", _windowInteract, 400, 50, 10, 120 )
  buttonTrade:SetText( "Trade (NOT AVAILABLE: InWork)" )

  if isInstructor then
    _windowInteract:SetSize( calculateToResu( 830 ), calculateToResu( 400 ) )
    _windowInteract:SetPos( ScrW()/2 - calculateToResu( 415 ), ScrH()/2 - calculateToResu( 200 ) )

    if promoteable then
      local buttonPromote = createVGUI( "DButton", _windowInteract, 400, 50, 420, 120 )
      buttonPromote:SetText( "Promote: " .. promoteName )
      function buttonPromote:DoClick()
        net.Start( "promotePlayer" )
          net.WriteString( tmpTargetSteamID )
        net.SendToServer()
        _windowInteract:Close()
      end
    end

    if demoteable then
      local buttonDemote = createVGUI( "DButton", _windowInteract, 400, 50, 420, 120 + 10 + 50 )
      buttonDemote:SetText( "Demote: " .. demoteName )
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
