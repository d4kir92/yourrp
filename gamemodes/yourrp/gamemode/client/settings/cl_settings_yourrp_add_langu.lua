--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--cl_settings_yourrp_add_langu.lua

function tabLanguage( sheet )
  local clientPanel = vgui.Create( "DPanel", sheet )
  clientPanel.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, yrp.colors.background ) end
  sheet:AddSheet( "Add Language", clientPanel, "icon16/comment_add.png" )
  function clientPanel:Paint()
    --draw.SimpleText( "Site is loading", "HudDefault", clientPanel:GetWide()/2, clientPanel:GetTall()/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    --drawBackground( 0, 0, clientPanel:GetWide(), clientPanel:GetTall(), ctrW( 0 ) )
  end

  local form = vgui.Create( "HTML", clientPanel )
  form:SetSize( ctrW( 2070 ), ctrW( 2070 - 80 ) )
  form:SetPos( ctrW( 5 ), ctrW( 5 + 80 ) )
  form:OpenURL( "https://docs.google.com/document/d/e/2PACX-1vRrbPJkC5Eel86Hw9AeFTMCgebee1Ep2zB73jKV07-aMf4mSkcGiIdNXXdJ_wYPWguzWbrrPQ9OwV6B/pub" )

  local button = vgui.Create( "DButton", clientPanel )
  button:SetSize( ctrW( 2070 ), ctrW( 160 ) )
  button:SetPos( ctrW( 5 ), ctrW( 5 ) )
  button:SetText( "Open Discord link in browser" )
  function button:DoClick()
    gui.OpenURL( "https://discord.gg/CXXDCMJ" )
  end
end
