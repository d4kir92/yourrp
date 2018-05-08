--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

net.Receive( "get_feedback", function()
  local ply = LocalPlayer()
  local _fbt = net.ReadTable()

  if settingsWindow.window != nil then
    function settingsWindow.window.site:Paint( w, h )
      surfaceText( lang_string( "feedback" ), "roleInfoHeader", ctr( 10 ), ctr( 10 + 25 ), Color( 255, 255, 255 ), 0, 1 )
    end

    local _fbl = createD( "DListView", settingsWindow.window.site, BScrW() - ctr( 20 ), ScrH() - ctr( 180 ), ctr( 10 ), ctr( 10 + 50 ) )
    _fbl:AddColumn( lang_string( "title" ) )
    _fbl:AddColumn( lang_string( "feedback" ) )
    _fbl:AddColumn( lang_string( "contact" ) )
    _fbl:AddColumn( "SteamID" )
    for i, row in pairs( _fbt ) do
      _fbl:AddLine( tostring( row.title ), tostring( row.feedback ), tostring( row.contact ), tostring( row.steamid ) )
    end
  end
end)

hook.Add( "open_server_feedback", "open_server_feedback", function()
  SaveLastSite()
  local ply = LocalPlayer()

  local w = settingsWindow.window.sitepanel:GetWide()
  local h = settingsWindow.window.sitepanel:GetTall()

  settingsWindow.window.site = createD( "DPanel", settingsWindow.window.sitepanel, w, h, 0, 0 )
  function settingsWindow.window.site:Paint( w, h )
    --
  end

  if ply:HasAccess() then
    net.Start( "get_feedback" )
    net.SendToServer()
  else
    F8RequireUG( lang_string( "feedback" ), "superadmin or admin" )
  end
end)
