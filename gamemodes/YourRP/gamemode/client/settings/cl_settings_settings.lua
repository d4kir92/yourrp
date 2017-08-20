//Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

//cl_settings_settings.lua

function tabSettings( sheet )
  local clientPanel = vgui.Create( "DPanel", sheet )
  clientPanel.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, yrpsettings.color.background ) end
  sheet:AddSheet( "Menu Settings", clientPanel, "icon16/wrench.png" )
  function clientPanel:Paint()
    //drawBackground( 0, 0, clientPanel:GetWide(), clientPanel:GetTall(), calculateToResu( 0 ) )
  end
end
