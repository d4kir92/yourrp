--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--cl_charakter.lua

net.Receive( "openCharakterMenu", function( len, ply )
  openCharakterMenu()
end)

local tmpNAME = nil
local tmpGENDER = lang.male

local sendSurname = ""
local sendFirstname = ""
local sendGender = "male"

function openCharakterMenu()
  _menuIsOpen = 1
  local w = 800
  local h = 680
  local window = createVGUI( "DFrame", nil, w, h, ( ScrW() * ctrF( ScrH() ) / 2 ) - w/2, 2160/2 - h/2 )
  window:ShowCloseButton( false )
  window:SetDraggable( false )
  window:SetTitle( "" )
  function window:OnRemove()
    window = nil
  end
  function window:OnClose()
    window:Remove()
  end
  function window:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 240 ) )

    draw.SimpleText( "Language:", "charText", pw - ctrW( 300 ) - ctrW( 10 ), ctrW( 15 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )

    draw.SimpleText( lang.firstname .. " " .. lang.surname, "charText", ctrW( 25 ), ctrW( 25 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

    draw.RoundedBox( ctrW( 30 ), ctrW( 25 ), ctrW( 25+200 ), ctrW( 750 ), ctrW( 350 ), Color( 255, 255, 255, 200 ) )

    draw.SimpleText( lang.identifycard, "charTitle", ctrW( 35 ), ctrW( 25+210 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    draw.SimpleText( GetHostName(), "charTitle", ctrW( 35 ), ctrW( 25+210+35 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    draw.SimpleText( LocalPlayer():SteamID(), "charTitle", ctrW( 765 ), ctrW( 25+210 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )

    draw.SimpleText( lang.surname .. ":", "charHeader", ctrW( 300 ), ctrW( 25+280 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    draw.SimpleText( lang.firstname .. ":", "charHeader", ctrW( 300 ), ctrW( 25+350 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    if tmpNAME != nil then
      local tmpNAMETable = string.Split( tmpNAME, " " )
      if tmpNAMETable[3] != nil then
        if tmpNAMETable[3] != nil and tmpNAMETable[3] != "" then
          sendSurname = tmpNAMETable[3]
          draw.SimpleText( tmpNAMETable[3], "charText", ctrW( 300 ), ctrW( 25+310 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        else
          draw.SimpleText( lang.surname, "charText", ctrW( 300 ), ctrW( 25+310 ), Color( 255, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        end

        if tmpNAMETable[2] != nil and tmpNAMETable[2] != "" then
          sendFirstname = tmpNAMETable[1] .. " " .. tmpNAMETable[2]
          draw.SimpleText( tmpNAMETable[1] .. " " .. tmpNAMETable[2], "charText", ctrW( 300 ), ctrW( 25+380 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        else
          draw.SimpleText( lang.firstname, "charText", ctrW( 300 ), ctrW( 25+380 ), Color( 255, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        end
      else
        if tmpNAMETable[2] != nil and tmpNAMETable[2] != "" then
          sendSurname = tmpNAMETable[2]
          draw.SimpleText( tmpNAMETable[2], "charText", ctrW( 300 ), ctrW( 25+310 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        else
          draw.SimpleText( lang.surname, "charText", ctrW( 300 ), ctrW( 25+310 ), Color( 255, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        end

        if tmpNAMETable[1] != nil and tmpNAMETable[1] != "" then
          sendFirstname = tmpNAMETable[1]
          draw.SimpleText( tmpNAMETable[1], "charText", ctrW( 300 ), ctrW( 25+380 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        else
          draw.SimpleText( lang.firstname, "charText", ctrW( 300 ), ctrW( 25+380 ), Color( 255, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        end
      end
    else
      draw.SimpleText( lang.surname, "charText", ctrW( 300 ), ctrW( 25+310 ), Color( 255, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
      draw.SimpleText( lang.firstname, "charText", ctrW( 300 ), ctrW( 25+380 ), Color( 255, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    end

    draw.SimpleText( lang.gender .. ":", "charHeader", ctrW( 300 ), ctrW( 25+420 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    draw.SimpleText( tmpGENDER, "charText", ctrW( 300 ), ctrW( 25+450 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
  end

  local textentryName = createVGUI( "DTextEntry", window, 750, 50, 25, 60 )
  function textentryName:OnChange()
    tmpNAME = textentryName:GetText()
  end

  local comboboxGender = createVGUI( "DComboBox", window, 750, 50, 25, 120 )
  comboboxGender:AddChoice( lang.male, "male", true )
  comboboxGender:AddChoice( lang.female, "female", false )
  comboboxGender:AddChoice( lang.other, "other", false )
  function comboboxGender:OnSelect( index, value, data )
    tmpGENDER = value
    sendGender = data
  end

  local tmpAvatar = createVGUI( "AvatarImage", window, 256, 256, 25+10, 310 )
  timer.Simple( 1, function()
    if window != nil then
      if LocalPlayer() != nil then
        tmpAvatar:SetPlayer( LocalPlayer(), ctrW( 256 ) )
      end
    end
  end)

  timer.Simple( 2, function()
    if window != nil then
      if LocalPlayer() != nil then
        tmpAvatar:SetPlayer( LocalPlayer(), ctrW( 256 ) )
      end
    end
  end)

  timer.Simple( 10, function()
    if window != nil then
      if LocalPlayer() != nil then
        tmpAvatar:SetPlayer( LocalPlayer(), ctrW( 256 ) )
      end
    end
  end)

  local confirmButton = createVGUI( "DButton", window, 200, 50, 800/2-200/2, 600 )
  confirmButton:SetText( "" )
  function confirmButton:Paint( pw, ph )
    if confirmButton:IsHovered() then
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 240 ) )
    else
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 240 ) )
    end
    draw.SimpleText( lang.confirm, "charText", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end
  function confirmButton:DoClick()
    net.Start( "setPlayerValues" )
      net.WriteString( sendSurname )
      net.WriteString( sendFirstname )
      net.WriteString( sendGender )
    net.SendToServer()
    _menuIsOpen = 0
    window:Close()
  end

  local Langu = createVGUI( "DComboBox", window, 300, 50, w-300-5, 5 )
  Langu:SetValue( lang.lang )
  Langu:AddChoice("[AUTOMATIC]", "auto")
  for k, v in pairs( lang.all ) do
    Langu:AddChoice( v.ineng .. "/" .. v.lang, v.short )
  end
  Langu.OnSelect = function( panel, index, value, data )
    changeLang(data)
  end

  window:MakePopup()
end
