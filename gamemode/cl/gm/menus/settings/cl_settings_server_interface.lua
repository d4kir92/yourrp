--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

net.Receive( "get_interface_settings", function( len )
  local ply = LocalPlayer()
  local _tbl = net.ReadTable()

  if pa( settingsWindow.window ) then
    printTab( _tbl )
    local _parent = settingsWindow.window.site

    --[[ Color ]]--
    local _p_color = createD( "DPanel", _parent, ctr( 400 ), ctr( 50 ), ctr( 10 ), ctr( 110 ) )
    function _p_color:Paint( pw, ph )
      surfaceBox( 0, 0, pw, ph, Color( 100, 100, 255, 255 ) )
      surfaceText( lang_string( "color" ), "SettingsNormal", ctr( 10 ), ph/2, Color( 255, 255, 255 ), 0, 1 )
    end
    local _color = createD( "DComboBox", _parent, ctr( 400 ), ctr( 50 ), ctr( 10 ), ctr( 160 ) )
    local _colors = {}
    table.insert( _colors, "blue" )
    table.insert( _colors, "red" )
    table.insert( _colors, "green" )
    table.insert( _colors, "yellow" )
    table.insert( _colors, "brown" )
    table.insert( _colors, "orange" )
    table.insert( _colors, "purple" )
    for i, col in pairs( _colors ) do
      if col == _tbl.color then
        _color:AddChoice( string.upper( lang_string( col ) ), col, true )
      else
        _color:AddChoice( string.upper( lang_string( col ) ), col, false )
      end
    end

    --[[ Style ]]--
    local _p_style = createD( "DPanel", _parent, ctr( 400 ), ctr( 50 ), ctr( 10 ), ctr( 220 ) )
    function _p_style:Paint( pw, ph )
      surfaceBox( 0, 0, pw, ph, Color( 100, 100, 255, 255 ) )
      surfaceText( lang_string( "style" ), "SettingsNormal", ctr( 10 ), ph/2, Color( 255, 255, 255 ), 0, 1 )
    end
    local _style = createD( "DComboBox", _parent, ctr( 400 ), ctr( 50 ), ctr( 10 ), ctr( 270 ) )

    --[[ Rounded ]]--
    local _p_rounded = createD( "DPanel", _parent, ctr( 400 ), ctr( 50 ), ctr( 10 ), ctr( 330 ) )
    function _p_rounded:Paint( pw, ph )
      surfaceBox( 0, 0, pw, ph, Color( 100, 100, 255, 255 ) )
      surfaceText( lang_string( "rounded" ), "SettingsNormal", ctr( 10 ), ph/2, Color( 255, 255, 255 ), 0, 1 )
    end
    local _rounded = createD( "DCheckBox", _parent, ctr( 50 ), ctr( 50 ), ctr( 10 ), ctr( 380 ) )

    --[[ Transparent ]]--
    local _p_transparent = createD( "DPanel", _parent, ctr( 400 ), ctr( 50 ), ctr( 10 ), ctr( 440 ) )
    function _p_transparent:Paint( pw, ph )
      surfaceBox( 0, 0, pw, ph, Color( 100, 100, 255, 255 ) )
      surfaceText( lang_string( "transparent" ), "SettingsNormal", ctr( 10 ), ph/2, Color( 255, 255, 255 ), 0, 1 )
    end
    local _transparent = createD( "DCheckBox", _parent, ctr( 50 ), ctr( 50 ), ctr( 10 ), ctr( 490 ) )

    --[[ Design ]]--
    local _p_design = createD( "DPanel", _parent, ctr( 400 ), ctr( 50 ), ctr( 10 ), ctr( 550 ) )
    function _p_design:Paint( pw, ph )
      surfaceBox( 0, 0, pw, ph, Color( 100, 100, 255, 255 ) )
      surfaceText( lang_string( "design" ), "SettingsNormal", ctr( 10 ), ph/2, Color( 255, 255, 255 ), 0, 1 )
    end
    local _design = createD( "DComboBox", _parent, ctr( 400 ), ctr( 50 ), ctr( 10 ), ctr( 600 ) )
  end
end)

hook.Add( "open_server_interface", "open_server_interface", function()
  local ply = LocalPlayer()

  local w = settingsWindow.window.sitepanel:GetWide()
  local h = settingsWindow.window.sitepanel:GetTall()

  settingsWindow.window.site = createD( "DPanel", settingsWindow.window.sitepanel, w, h, 0, 0 )
  function settingsWindow.window.site:Paint( w, h )
    --[[ Left ]]--
    surfaceBox( 0, 0, w/2, h, Color( 0, 0, 0, 240 ) )
    surfaceText( lang_string( "interface" ), "SettingsHeader", ctr( 20 ), ctr( 10 ), Color( 255, 255, 255 ), 0, 0 )

    --[[ Right ]]--
    surfaceText( lang_string( "preview" ), "SettingsHeader", ScrW2() + ctr( 20 ), ctr( 10 ), Color( 255, 255, 255 ), 0, 0 )
  end

  local _dframe = createD( "DFrame", settingsWindow.window.site, ScrW2() - ctr( 200 ), ScrH2() - ctr( 200 ), ScrW2() + ctr( 100 ), ctr( 100 ) )
  _dframe:SetTitle( "" )
  function _dframe:Paint( pw, ph )
    paintWindow( self, pw, ph, lang_string( "dframe" ) )
  end

  local _dpanel = createD( "DPanel", _dframe, _dframe:GetWide() - ctr( 100 ), ctr( 200 ), ctr( 50 ), ctr( 50 ) )
  function _dpanel:Paint( pw, ph )
    paintPanel( self, pw, ph )
    surfaceText( lang_string( "dpanel" ), "SettingsNormal", pw/2, ph/2, Color( 255, 255, 255 ), 1, 1 )
  end

  local _dbutton = createD( "DButton", _dframe, ctr( 400 ), ctr( 50 ), ctr( 50 ), ctr( 50+200+10 ) )
  _dbutton:SetText( "" )
  function _dbutton:Paint( pw, ph )
    paintButton( self, pw, ph, lang_string( "dbutton" ) )
  end

  net.Start( "get_interface_settings" )
  net.SendToServer()
end)
