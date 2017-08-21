//Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

//cl_settings_client.lua

include( "cl_settings_client_charakter.lua" )
include( "cl_settings_client_hud.lua" )

function tabClient( sheet )
  local clientPanel = vgui.Create( "DPanel", sheet )
  clientPanel.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, yrpsettings.color.background ) end
  sheet:AddSheet( lang.client, clientPanel, "icon16/user.png" )
  function clientPanel:Paint()
    draw.RoundedBox( 0, calculateToResu( 0 ), calculateToResu( 40 ), clientPanel:GetWide(), clientPanel:GetTall(), yrpsettings.color.background )
  end

  //Server Sheet
  local clientSheet = vgui.Create( "DPropertySheet", clientPanel )
  clientSheet:Dock( FILL )
  function clientSheet:Paint()
    //drawBackground( 0, 0, serverSheet:GetWide(), serverSheet:GetTall(), calculateToResu( 10 ) )
  end

  tabClientChar( clientSheet )
  tabClientHud( clientSheet )

  for k, v in pairs(clientSheet.Items) do
    if (!v.Tab) then continue end

    v.Tab.Paint = function(self,w,h)
      if v.Tab == clientSheet:GetActiveTab() then
        draw.RoundedBox( 0, 0, 0, w, h, yrpsettings.color.background )
      else
        draw.RoundedBox( 0, 0, 0, w, h, yrpsettings.color.buttonInActive )
      end
    end
  end
end
