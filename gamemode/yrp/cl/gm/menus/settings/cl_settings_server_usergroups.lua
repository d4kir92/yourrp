--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

net.Receive( "GetSettingsUserGroups", function( len )
  local NETUSERGROUPS = net.ReadTable()
  printTab( NETUSERGROUPS )

  local PARENT = settingsWindow.window.site

  --[[ UserGroups Action Buttons ]]--
  local _ug_add = createD( "DButton", PARENT, ctr( 50 ), ctr( 50 ), ctr( 10 ), ctr( 10 ) )
  _ug_add:SetText( "" )
  function _ug_add:Paint( pw, ph )
    surfaceButton( self, pw, ph, "+", Color( 0, 255, 0, 255 ) )
  end

  local _ug_rem = createD( "DButton", PARENT, ctr( 50 ), ctr( 50 ), ctr( 10 + 500 - 50 ), ctr( 10 ) )
  _ug_rem:SetText( "" )
  function _ug_rem:Paint( pw, ph )
    surfaceButton( self, pw, ph, "-", Color( 255, 0, 0, 255 ) )
  end

  --[[ UserGroupsList ]]--
  local _ugs = createD( "DPanelList", PARENT, ctr( 500 ), ScrH() - ctr( 10 + 150 + 10 ), ctr( 10 ), ctr( 10 + 50 ) )
  function _ugs:Paint( pw, ph )
    surfaceBox( 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
  end

  for i, ug in pairs( NETUSERGROUPS ) do
    local _ug = createD( "DButton", _ugs, _ugs:GetWide(), ctr( 100 ), 0, 0 )
    _ug:SetText( "" )
    _ug.color = StringToColor( ug.color )
    _ug.mat = Material( "icon16/magnifier.png" )
    function _ug:Paint( pw, ph )
      surfaceButton( self, pw, ph, ug.name, self.color, ph + ctr( 10 ), ph/2, 0, 1 )

      surfaceBox( ctr( 4 ), ctr( 4 ), ph - ctr( 8 ), ph - ctr( 8 ), Color( 255, 255, 255, 255 ) )
      surface.SetDrawColor( 255, 255, 255, 255 )
    	surface.SetMaterial( self.mat )
    	surface.DrawTexturedRect( ctr( 8 ), ctr( 8 ), ph - ctr( 16 ), ph - ctr( 16 ) )
    end

    _ugs:AddItem( _ug )
  end
end)

hook.Add( "open_server_usergroups", "open_server_usergroups", function()
  SaveLastSite()
  local ply = LocalPlayer()

  local w = settingsWindow.window.sitepanel:GetWide()
  local h = settingsWindow.window.sitepanel:GetTall()

  settingsWindow.window.site = createD( "DPanel", settingsWindow.window.sitepanel, w, h, 0, 0 )
  local _ug = string.lower( ply:GetUserGroup() )
  if _ug == "superadmin" or _ug == "owner" then
    function settingsWindow.window.site:Paint( pw, ph )
      draw.RoundedBox( 4, 0, 0, pw, ph, Color( 0, 0, 0, 254 ) )

      surfaceText( lang_string( "wip" ), "mat1text", pw/2, ph/2, Color( 255, 255, 255 ), 1, 1 )
    end

    net.Start( "GetSettingsUserGroups" )
    net.SendToServer()
  else
    F8RequireUG( lang_string( "restriction" ), "superadmin" )
  end
end)
