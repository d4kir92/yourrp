//cl_settings_yourrp_contact.lua

function tabContact( sheet )
  local clientPanel = vgui.Create( "DPanel", sheet )
  clientPanel.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, yrpsettings.color.background ) end
  sheet:AddSheet( "Contact", clientPanel, "icon16/user_comment.png" )
  function clientPanel:Paint()
    draw.SimpleText( "Site is loading", "HudDefault", clientPanel:GetWide()/2, clientPanel:GetTall()/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    //drawBackground( 0, 0, clientPanel:GetWide(), clientPanel:GetTall(), calculateToResu( 0 ) )
  end

  local form = vgui.Create( "HTML", clientPanel )
  form:SetSize( calculateToResu( 2070 ), calculateToResu( 2070 - 80 ) )
  form:SetPos( calculateToResu( 5 ), calculateToResu( 5 + 80 ) )
  form:OpenURL( "https://docs.google.com/forms/d/e/1FAIpQLSeoMbfL9x5By1rZFtk6ZaPJYrN-j9GBCB1F0u4BpPfGrnMVlw/viewform?usp=sf_link" )

  local button = vgui.Create( "DButton", clientPanel )
  button:SetSize( calculateToResu( 2070 ), calculateToResu( 80 ) )
  button:SetPos( calculateToResu( 5 ), calculateToResu( 5 ) )
  button:SetText( "Live Support Click me! (Discord)" )
  function button:DoClick()
    gui.OpenURL( "https://discord.gg/7cADpmC" )
  end
end
