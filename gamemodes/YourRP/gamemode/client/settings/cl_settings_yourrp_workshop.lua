//Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

//cl_settings_yourrp_wiki.lua

function tabWorkshop( sheet )
  local clientPanel = vgui.Create( "DPanel", sheet )
  clientPanel.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, yrpsettings.color.background ) end
  sheet:AddSheet( lang.workshop, clientPanel, "icon16/layout_content.png" )
  function clientPanel:Paint()
    draw.SimpleText( "Site is loading", "HudDefault", clientPanel:GetWide()/2, clientPanel:GetTall()/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    //drawBackground( 0, 0, clientPanel:GetWide(), clientPanel:GetTall(), calculateToResu( 0 ) )
  end

  local form = vgui.Create( "HTML", clientPanel )
  form:SetSize( calculateToResu( 2070 ), calculateToResu( 2070 ) )
  form:SetPos( calculateToResu( 5 ), calculateToResu( 5 ) )
  form:OpenURL( "http://steamcommunity.com/sharedfiles/filedetails/?id=1114204152" )
end
