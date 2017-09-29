--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

include("shared.lua")

function ENT:Draw()
  local ply = LocalPlayer()
  local eyeTrace = ply:GetEyeTrace()

  if ply:GetPos():Distance( self:GetPos() ) < 2000 then
    self:DrawModel()
  end
end

local windowOpen = false

net.Receive( "openLawBoard", function( len )
  if !windowOpen then
    local tmpJailList = net.ReadTable()
    windowOpen = true
    local window = createVGUI( "DFrame", nil, ScrH(), ScrH(), 0, 0 )
    window:SetSize( ScrH(), ScrH() )
    window:SetTitle( "" )
    window:Center()
    function window:OnClose()
      window:Remove()
    end
    function window:OnRemove()
      windowOpen = false
    end
    function window:Paint( pw, ph )
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 250 ) )
      draw.SimpleText( lang.jail, "sef", ctrW( 10 ), ctrW( 25 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

      draw.SimpleText( lang.access, "sef", ctrW( 600 ), ctrW( 25 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
    end

    local _tmpGroups = net.ReadTable()
    local _tmpGeneral = net.ReadTable()
    local _gAccess = -1
    for k, v in pairs( _tmpGeneral ) do
      if v.name == "jailaccess" then
        _gAccess = tonumber( v.value )
        break
      end
    end
    if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then
      local _access = createVGUI( "DComboBox", window, 300, 50, 610, 0 )
      _access:AddChoice( "-", -1, false )
      for k, v in pairs( _tmpGroups ) do
        local _hasaccess = false
        if tonumber( v.uniqueID ) == _gAccess then
          _hasaccess = true
        end
        _access:AddChoice( v.groupID, v.uniqueID, _hasaccess )
      end
      function _access:OnSelect( index, value, data )
        net.Start( "dbUpdate" )
          net.WriteString( "yrp_general" )
          net.WriteString( "value = " .. data )
          net.WriteString( "name = '" .. "jailaccess" .. "'" )
        net.SendToServer()
      end
    end


    local scrollpanel = createVGUI( "DScrollPanel", window )
    scrollpanel:SetSize( ScrH() - ctrW( 20 ), ScrH() - ctrW( 60 ) )
    scrollpanel:SetPos( ctrW( 10 ), ctrW( 50 ) )
    function scrollpanel:Paint( pw, ph )
      --draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 100 ) )
    end

    local _x = 0
    local _y = 0
    for k, v in pairs( tmpJailList ) do
      local dpanel = createVGUI( "DPanel", scrollpanel, 400, 400, 0, 0 )
      dpanel:SetText( "" )
      dpanel:SetPos( _x*ctrW( 410 ), _y*ctrW( 410 ) )
      function dpanel:Paint( pw, ph )
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 255, 200 ) )

        draw.SimpleText( lang.name .. ": " .. v.nick, "sef", pw/2, ph - ctrW( 125 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.SimpleText( lang.reason .. ": " .. v.reason, "sef", pw/2, ph - ctrW( 75 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.SimpleText( lang.time .. ": " .. v.time, "sef", pw/2, ph - ctrW( 25 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      end
      scrollpanel:AddItem( dpanel )
      _x = _x + 1
      if _x > 4 then
        _y = _y + 1
        _x = 0
      end
    end

    local _tmpGroupID = net.ReadInt( 16 )
    if _gAccess == _tmpGroupID then
      local addButton = createVGUI( "DButton", scrollpanel, 400, 400 )
      addButton:SetText( "" )
      addButton:SetPos( _x*ctrW( 410 ), _y*ctrW( 410 ) )
      function addButton:Paint( pw, ph )
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 255, 0, 200 ) )

        local _pl = 200
        local _ph = 50
        draw.RoundedBox( 0, pw/2 - ctrW( _pl/2 ), ph/2 - ctrW( _ph/2 ), ctrW( _pl ), ctrW( _ph ), Color( 0, 0, 0, 255 ) )
        draw.RoundedBox( 0, pw/2 - ctrW( _ph/2 ), ph/2 - ctrW( _pl/2 ), ctrW( _ph ), ctrW( _pl ), Color( 0, 0, 0, 255 ) )
      end
      scrollpanel:AddItem( addButton )
      function addButton:DoClick()
        local _SteamID = nil
        local _nick = ""
        local addWindow = createVGUI( "DFrame", nil, 400, 420, 0, 0 )
        addWindow:SetTitle( "" )
        addWindow:Center()
        function addWindow:Paint( pw, ph )
          draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 250 ) )

          draw.SimpleText( lang.add, "sef", ctrW( 10 ), ctrW( 25 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

          draw.SimpleText( lang.player, "sef", ctrW( 10 ), ctrW( 100 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )

          draw.SimpleText( lang.reason, "sef", ctrW( 10 ), ctrW( 200 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )

          draw.SimpleText( lang.timeinsec, "sef", ctrW( 10 ), ctrW( 300 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
        end

        local _player = createVGUI( "DComboBox", addWindow, 380, 50, 10, 100 )
        for k, v in pairs( player.GetAll() ) do
          _player:AddChoice( v:RPName(), v:SteamID() )
        end
        function _player:OnSelect( index, value, data )
          _SteamID = data
          _nick = value
        end

        local _reason = createVGUI( "DTextEntry", addWindow, 380, 50, 10, 200 )

        local _time = createVGUI( "DNumberWang", addWindow, 380, 50, 10, 300 )

        local _add = createVGUI( "DButton", addWindow, 380, 50, 10, 360 )
        _add:SetText( "" )
        function _add:Paint( pw, ph )
          draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 255, 0, 255 ) )
          draw.SimpleText( lang.add, "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
        function _add:DoClick()
          if _SteamID != nil then
            local _insert = "'" .. _SteamID .. "', '" .. _reason:GetText() .. "', " .. _time:GetValue() .. ", '" .. _nick .. "'"
            net.Start( "dbAddJail" )
              net.WriteString( "yrp_jail" )
              net.WriteString( "SteamID, reason, time, nick" )
              net.WriteString( _insert )

              net.WriteString( _SteamID )
            net.SendToServer()
          end
        end

        window:Close()

        addWindow:MakePopup()
      end
    end

    window:MakePopup()
  end
end)
