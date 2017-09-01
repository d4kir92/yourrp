--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--cl_settings_yourrp_contact.lua

function tabContact( sheet )
  local clientPanel = vgui.Create( "DPanel", sheet )
  clientPanel.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, yrp.colors.background ) end
  sheet:AddSheet( lang.contact, clientPanel, "icon16/user_comment.png" )
  function clientPanel:Paint()
    draw.SimpleText( "Site is loading", "HudDefault", clientPanel:GetWide()/2, clientPanel:GetTall()/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    --drawBackground( 0, 0, clientPanel:GetWide(), clientPanel:GetTall(), ctrW( 0 ) )
  end

  local form = vgui.Create( "HTML", clientPanel )
  form:SetSize( ctrW( 2070 ), ctrW( 2070 - 80 ) )
  form:SetPos( ctrW( 5 ), ctrW( 5 + 80 ) )
  form:OpenURL( "https://docs.google.com/forms/d/e/1FAIpQLSeoMbfL9x5By1rZFtk6ZaPJYrN-j9GBCB1F0u4BpPfGrnMVlw/viewform?usp=sf_link" )

  local button = vgui.Create( "DButton", clientPanel )
  button:SetSize( ctrW( 2070 ), ctrW( 80 ) )
  button:SetPos( ctrW( 5 ), ctrW( 5 ) )
  button:SetText( "Live Support Click me! (Discord)" )
  function button:DoClick()
    gui.OpenURL( "https://discord.gg/CXXDCMJ" )
  end
end
