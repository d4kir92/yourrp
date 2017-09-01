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

  _windowInteract = createVGUI( "DFrame", nil, 830, 470 + 50 + 10, ScrW() - 160, ScrH() - 200 )
  local tmpTargetName = ""
  local tmpFirstName = ""
  local tmpSurName = ""
  for k, v in pairs ( player.GetAll() ) do
    if tostring( v:SteamID() ) == tostring( tmpTargetSteamID ) then
      tmpPly = v
      tmpTargetName = v:Nick()
      tmpFirstName = v:GetNWString( "FirstName" )
      tmpSurName = v:GetNWString( "SurName" )
      tmpGender = v:GetNWString( "Gender" )
    end
  end
  _windowInteract:SetTitle( lang.interactmenu )
  function _windowInteract:OnClose()
    gui.EnableScreenClicker( false )
    _windowInteract = nil
    _menuIsOpen = 0
  end
  function _windowInteract:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 240 ) )

    draw.RoundedBox( ctrW( 30 ), ctrW( 10 ), ctrW( 50 ), ctrW( 750 ), ctrW( 350 ), Color( 255, 255, 255, 200 ) )

    draw.SimpleText( lang.identifycard, "charTitle", ctrW( 10 + 10 ), ctrW( 60 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    draw.SimpleText( GetHostName(), "charTitle", ctrW( 10 + 10 ), ctrW( 60+35 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    draw.SimpleText( LocalPlayer():SteamID(), "charTitle", ctrW( 745 ), ctrW( 60 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )

    draw.SimpleText( lang.surname .. ":", "charHeader", ctrW( 280 ), ctrW( 60 + 70 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    draw.SimpleText( lang.firstname .. ":", "charHeader", ctrW( 280 ), ctrW( 60 + 140 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

    draw.SimpleText( tmpSurName, "charText", ctrW( 280 ), ctrW( 60 + 100 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

    draw.SimpleText( tmpFirstName, "charText", ctrW( 280 ), ctrW( 60 + 170 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

    draw.SimpleText( lang.gender .. ":", "charHeader", ctrW( 280 ), ctrW( 60 + 210 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    local gender = lang.other
    if tmpGender == "male" then
      gender = lang.male
    elseif tmpGender == "female" then
      gender = lang.female
    end
    draw.SimpleText( gender, "charText", ctrW( 280 ), ctrW( 60 + 240 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
  end

  local tmpAvatarI = createVGUI( "AvatarImage", _windowInteract, 256, 256, 10 + 10, 60 + 70 )
  timer.Simple( 0.1, function()
    if tmpAvatarI != NULL and tmpAvatarI != nil and tmpAvatarI:IsValid() then
      tmpAvatarI:SetPlayer( tmpPly, ctrW( 256 ) )
    end
  end)

  timer.Simple( 10, function()
    if tmpAvatarI != NULL and tmpAvatarI != nil and tmpAvatarI:IsValid() then
      tmpAvatarI:SetPlayer( tmpPly, ctrW( 256 ) )
    end
  end)

  local buttonTrade = createVGUI( "DButton", _windowInteract, 400, 50, 10, 410 )
  buttonTrade:SetText( lang.trade .. " (NOT AVAILABLE: InWork)" )

  if isInstructor then
    _windowInteract:SetSize( ctrW( 830 ), ctrW( 400 ) )
    _windowInteract:SetPos( ScrW()/2 - ctrW( 415 ), ScrH()/2 - ctrW( 200 ) )

    if promoteable then
      local buttonPromote = createVGUI( "DButton", _windowInteract, 400, 50, 420, 410 )
      buttonPromote:SetText( lang.promote .. ": " .. promoteName )
      function buttonPromote:DoClick()
        net.Start( "promotePlayer" )
          net.WriteString( tmpTargetSteamID )
        net.SendToServer()
        _windowInteract:Close()
      end
    end

    if demoteable then
      local buttonDemote = createVGUI( "DButton", _windowInteract, 400, 50, 420, 410 + 10 + 50 )
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
