--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--cl_settings_yourrp_contact.lua

function tabContact( sheet )
  local clientPanel = vgui.Create( "DPanel", sheet )
  clientPanel.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, yrp.colors.background ) end
  sheet:AddSheet( lang.contact, clientPanel, "icon16/user_comment.png" )
  function clientPanel:Paint()
    --draw.SimpleText( "Site is loading", "HudDefault", clientPanel:GetWide()/2, clientPanel:GetTall()/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    --drawBackground( 0, 0, clientPanel:GetWide(), clientPanel:GetTall(), ctrW( 0 ) )
  end

  local button = createVGUI( "DButton", clientPanel, 2070, 2070, 0, 0 )
  button:SetText( lang.contact .. " (Discord-Link)" )
  function button:DoClick()
    gui.OpenURL( "https://discord.gg/CXXDCMJ" )
  end
end
