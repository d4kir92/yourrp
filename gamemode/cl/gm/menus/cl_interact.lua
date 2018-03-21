--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local tmpTargetSteamID = ""
function toggleInteractMenu()
  local ply = LocalPlayer()
	local eyeTrace = ply:GetEyeTrace()
  if eyeTrace.Entity:IsPlayer() and isNoMenuOpen() then
    openInteractMenu( eyeTrace.Entity:SteamID() )
  else
    closeInteractMenu()
  end
end

function closeInteractMenu()
  if _windowInteract != nil then
    closeMenu()
    _windowInteract:Remove()
    _windowInteract = nil
  end
end

function openInteractMenu( SteamID )
  if SteamID != nil then
    openMenu()
    tmpTargetSteamID = SteamID
    net.Start( "openInteractMenu" )
      net.WriteString( tmpTargetSteamID )
    net.SendToServer()
  end
end

net.Receive( "openInteractMenu", function ()
  local isInstructor = net.ReadBool()

  local promoteable = net.ReadBool()
  local promoteName = net.ReadString()

  local demoteable = net.ReadBool()
  local demoteName = net.ReadString()

  _windowInteract = createVGUI( "DFrame", nil, 1090, 470 + 50 + 10, ScrW() - 160, ScrH() - 200 )
  function _windowInteract:OnClose()
    closeMenu()
  end
  function _windowInteract:OnRemove()
    closeMenu()
  end
  local tmpTargetName = ""
  local tmpRPName = ""
  for k, v in pairs ( player.GetAll() ) do
    if tostring( v:SteamID() ) == tostring( tmpTargetSteamID ) then
      tmpPly = v
      tmpTargetName = v:Nick()
      tmpRPName = v:RPName()
      tmpGender = v:GetNWString( "Gender" )
    end
  end
  _windowInteract:SetTitle( lang_string( "interactmenu" ) )

  function _windowInteract:Paint( pw, ph )
    paintWindow( self, pw, ph, "")

    draw.RoundedBox( ctr( 30 ), ctr( 10 ), ctr( 50 ), ctr( 750 ), ctr( 350 ), Color( 255, 255, 255, 200 ) )

    draw.SimpleTextOutlined( lang_string( "identifycard" ), "charTitle", ctr( 10 + 10 ), ctr( 60 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( GetHostName(), "charTitle", ctr( 10 + 10 ), ctr( 60+35 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( LocalPlayer():SteamID(), "charTitle", ctr( 745 ), ctr( 60 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )

    draw.SimpleTextOutlined( lang_string( "name" ) .. ":", "charHeader", ctr( 280 ), ctr( 60 + 70 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )

    draw.SimpleTextOutlined( tmpRPName, "charText", ctr( 280 ), ctr( 60 + 100 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )

    draw.SimpleTextOutlined( lang_string( "gender" ) .. ":", "charHeader", ctr( 280 ), ctr( 60 + 210 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    local gender = lang_string( "other" )
    if tmpGender == "male" then
      gender = lang_string( "male" )
    elseif tmpGender == "female" then
      gender = lang_string( "female" )
    end
    draw.SimpleTextOutlined( gender, "charText", ctr( 280 ), ctr( 60 + 240 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
  end

  local tmpAvatarI = createVGUI( "AvatarImage", _windowInteract, 256, 256, 10 + 10, 60 + 70 )
  timer.Simple( 0.1, function()
    if tmpAvatarI != NULL and tmpAvatarI != nil and tmpAvatarI:IsValid() then
      tmpAvatarI:SetPlayer( tmpPly, ctr( 256 ) )
    end
  end)

  timer.Simple( 10, function()
    if tmpAvatarI != NULL and tmpAvatarI != nil and tmpAvatarI:IsValid() then
      tmpAvatarI:SetPlayer( tmpPly, ctr( 256 ) )
    end
  end)

  local buttonTrade = createVGUI( "DButton", _windowInteract, 530, 50, 10, 410 )
  buttonTrade:SetText( "" )
  function buttonTrade:Paint( pw, ph )
    paintButton( self, pw, ph, lang_string( "trade" ) .. " (in future update)" )
  end

  if isInstructor then
    if promoteable then
      local buttonPromote = createVGUI( "DButton", _windowInteract, 530, 50, 545, 410 )
      buttonPromote:SetText( "" )
      function buttonPromote:DoClick()
        net.Start( "promotePlayer" )
          net.WriteString( tmpTargetSteamID )
        net.SendToServer()
        _windowInteract:Close()
      end
      function buttonPromote:Paint( pw, ph )
        paintButton( self, pw, ph, lang_string( "promote" ) .. ": " .. promoteName )
      end
    end

    if demoteable then
      local buttonDemote = createVGUI( "DButton", _windowInteract, 530, 50, 545, 410 + 10 + 50 )
      buttonDemote:SetText( "" )
      function buttonDemote:DoClick()
        net.Start( "demotePlayer" )
          net.WriteString( tmpTargetSteamID )
        net.SendToServer()
        _windowInteract:Close()
      end
      function buttonDemote:Paint( pw, ph )
        paintButton( self, pw, ph, lang_string( "demote" ) .. ": " .. demoteName )
      end
    end
  end

  _windowInteract:Center()
  _windowInteract:MakePopup()
  gui.EnableScreenClicker( true )
end)
