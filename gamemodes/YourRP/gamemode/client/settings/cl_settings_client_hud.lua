//cl_settings_client_hud.lua

function createDerma( art, parent, w, h, x, y )
  tmpDerma = vgui.Create( art, parent )
  tmpDerma:SetSize( calculateToResu(w), calculateToResu(h) )
  tmpDerma:SetPos( calculateToResu(x), calculateToResu(y) )
  return tmpDerma
end

function changeHudElement( parent, tmpx, tmpy, tmpw, tmph, tmpt, textPre )
  local ply = LocalPlayer()
  local frame = createDerma( "DFrame", parent, cl_db[tmpw], cl_db[tmph], cl_db[tmpx], cl_db[tmpy] )
  frame:SetTitle( "" )
  frame:ShowCloseButton( false )
  frame:SetSizable( true )
  frame:SetMinHeight( calculateToResu( 40 ) )
  frame:SetMinWidth( calculateToResu( 200 ) )

  function frame:Paint( pw, ph )
    drawRBox( 0, 0, 0, pw*2, ph*2, Color( 0, 0, 0, 120 ) )
    drawRBox( 0, 0, 0, pw*2, 50, Color( 0, 0, 255, 200 ) )

    drawRBox( 0, pw*2 - 20, ph*2 - 20, 20, 20, Color( 0, 255, 0, 200 ) )

    drawText( textPre, "HudBars", pw, ph, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

    if frame:IsHovered() then

      local tw, th = frame:GetSize()
      if tw != calculateToResu( cl_db[tmpw] ) or th != calculateToResu( cl_db[tmph] ) then
        cl_db[tmpw] = (tw*2) - (tw*2)%20
        cl_db[tmph] = (th*2) - (th*2)%20
        frame:SetSize( calculateToResu( cl_db[tmpw] ), calculateToResu( cl_db[tmph] ) )
        updateDBHud( tmpw, cl_db[tmpw] )
        updateDBHud( tmph, cl_db[tmph] )
      end

      local x, y = frame:GetPos()
      if x != calculateToResu( cl_db[tmpx] ) or y != calculateToResu( cl_db[tmpy] ) then
        local w, h = frame:GetSize()
        local outside = false
        if x+w > ScrW() then
          frame:SetPos( ScrW()-w, y )
          outside = true
        elseif y+h > ScrH() then
          frame:SetPos( x, ScrH()-h )
          outside = true
        elseif x < 0 then
          frame:SetPos( 0, y )
          outside = true
        elseif y < 0 then
          frame:SetPos( x, 0 )
          outside = true
        end
        if !outside then
          cl_db[tmpx] = (x*2) - (x*2)%20
          cl_db[tmpy] = (y*2) - (y*2)%20
          frame:SetPos( calculateToResu( cl_db[tmpx] ), calculateToResu( cl_db[tmpy] ) )
          updateDBHud( tmpx, cl_db[tmpx] )
          updateDBHud( tmpy, cl_db[tmpy] )
        end
      end
    end
  end

  local tmpToggle = createDerma( "DCheckBox", frame, 30, 30, 10, 10 )
  local tmpToggleChecked = -1
  if tonumber( cl_db[tmpt] ) == 0 then
    tmpToggleChecked = false
  elseif tonumber( cl_db[tmpt] ) == 1 then
    tmpToggleChecked = true
  end
  tmpToggle:SetChecked( tmpToggleChecked )
  function tmpToggle:OnChange( bVal )
  	if ( bVal ) then
      cl_db[tmpt] = 1
  		updateDBHud( tmpt, cl_db[tmpt] )
  	else
      cl_db[tmpt] = 0
  		updateDBHud( tmpt, cl_db[tmpt] )
  	end
  end
end

function tabClientHud( sheet )
  local ply = LocalPlayer()

  local cl_hudPanel = vgui.Create( "DPanel", sheet )
  sheet:AddSheet( "Hud", cl_hudPanel, "icon16/photo.png" )
  function cl_hudPanel:Paint( w, h )
    //draw.RoundedBox( 0, 0, 0, sv_generalPanel:GetWide(), sv_generalPanel:GetTall(), yrpsettings.color.panel )
  end

  local changeHudButton = createDerma( "DButton", cl_hudPanel, 400, 50, 0, 0 )
  changeHudButton:SetText( "change HUD" )
  function changeHudButton:DoClick()
    settingsWindow:Close()

    local changeHudWindow = createDerma( "DFrame", nil, 3840, 2160, 0, 0 )
    changeHudWindow:SetDraggable( false )
    changeHudWindow:SetTitle( "" )
    changeHudWindow:ShowCloseButton( false )
    function changeHudWindow:Paint( w, h )
      local gridSize = 20
      drawRBox( 0, 0, 0, ScrW()*2, ScrH()*2, Color( 0, 0, 0, 120 ) )
      for i=1, 3840/gridSize do
        if i%(3840/gridSize/2) == 0 then
          drawRBox( 0, (i*gridSize)-2, 0, 4, 2160, Color( 255, 255, 0, 60 ) )
        elseif i%10 == 1 then
            drawRBox( 0, (i*gridSize)-2, 0, 4, 2160, Color( 0, 0, 255, 50 ) )
        else
          drawRBox( 0, (i*gridSize)-2, 0, 4, 2160, Color( 255, 255, 255, 20 ) )
        end
      end

      for i=1, 2160/gridSize do
        if i%(2160/gridSize/2) == 0 then
          drawRBox( 0, 0, (i*gridSize)-2, 3840, 4, Color( 255, 255, 0, 60 ) )
        elseif i%10 == 9 then
          drawRBox( 0, 0, (i*gridSize)-2, 3840, 4, Color( 0, 0, 255, 50 ) )
        else
          drawRBox( 0, 0, (i*gridSize)-2, 3840, 4, Color( 255, 255, 255, 20 ) )
        end
      end
    end

    local changeHudWindowCloseButton = createDerma( "DButton", changeHudWindow, 3840, 2160, 0, 0 )
    changeHudWindowCloseButton:SetText( "" )
    function changeHudWindowCloseButton:DoClick()
      changeHudWindow:Close()
    end
    function changeHudWindowCloseButton:Paint( pw, ph )
      draw.SimpleText( "Click on empty space to Close", "DermaDefault", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

      draw.SimpleText( "Want to move a hud element? Drag with mouse the blue boxes", "DermaDefault", pw/2, ph/2+20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      draw.SimpleText( "Want to resize a hud element? go with mouse over the green box, then hold click and move mouse", "DermaDefault", pw/2, ph/2+40, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    changeHudElement( changeHudWindow, "mmx", "mmy", "mmw", "mmh", "mmt", "Minimap" )
    changeHudElement( changeHudWindow, "hpx", "hpy", "hpw", "hph", "hpt", "Health" )
    changeHudElement( changeHudWindow, "arx", "ary", "arw", "arh", "art", "Armor" )
    changeHudElement( changeHudWindow, "rix", "riy", "riw", "rih", "rit", "RoleID" )
    changeHudElement( changeHudWindow, "ttx", "tty", "ttw", "tth", "ttt", "Tooltip" )
    changeHudElement( changeHudWindow, "mox", "moy", "mow", "moh", "mot", "Money" )

    changeHudWindow:MakePopup()
  end

  local resetHudButton = createDerma( "DButton", cl_hudPanel, 400, 50, 0, 50 + 10 )
  resetHudButton:SetText( "Reset HUD" )
  function resetHudButton:DoClick()
    local _window = createVGUI( "DFrame", nil, 430, 50 + 10 + 50 + 10, 0, 0 )
    _window:Center()
    _window:SetTitle( "Are you sure?" )

    local _yesButton = createVGUI( "DButton", _window, 200, 50, 10, 60 )
    _yesButton:SetText( "Yes" )
    function _yesButton:DoClick()
      resetHud()
      _window:Close()
    end

    local _noButton = createVGUI( "DButton", _window, 200, 50, 10 + 200 + 10, 60 )
    _noButton:SetText( "No" )
    function _noButton:DoClick()
      _window:Close()
    end

    _window:MakePopup()
  end
end
