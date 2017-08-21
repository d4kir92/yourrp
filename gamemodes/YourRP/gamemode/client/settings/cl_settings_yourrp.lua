//Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

//cl_settings_server.lua

include( "cl_settings_yourrp_workshop.lua" )
include( "cl_settings_yourrp_wiki.lua" )
include( "cl_settings_yourrp_contact.lua" )
include( "cl_settings_yourrp_add_langu.lua" )

function tabYourRP( sheet )
  local ply = LocalPlayer()
  if ply:IsAdmin() or ply:IsSuperAdmin() then
    //Server Panel
    local serverPanel = vgui.Create( "DPanel", sheet )
    serverPanel.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, yrpsettings.color.background ) end
    sheet:AddSheet( "YourRP", serverPanel, "icon16/controller.png" )
    function serverPanel:Paint()
      draw.RoundedBox( 0, ctrW( 0 ), ctrW( 40 ), serverPanel:GetWide(), serverPanel:GetTall(), yrpsettings.color.background )
    end

    //Server Sheet
    local yourrpSheet = vgui.Create( "DPropertySheet", serverPanel )
    yourrpSheet:Dock( FILL )
    function yourrpSheet:Paint()
      //drawBackground( 0, 0, yourrpSheet:GetWide(), yourrpSheet:GetTall(), ctrW( 10 ) )
    end
    tabWorkshop( yourrpSheet )
    tabWiki( yourrpSheet )
    tabContact( yourrpSheet )
    tabLanguage( yourrpSheet )

    for k, v in pairs(yourrpSheet.Items) do
    	if (!v.Tab) then continue end

      v.Tab.Paint = function(self,w,h)
        if v.Tab == yourrpSheet:GetActiveTab() then
  		    draw.RoundedBox( 0, 0, 0, w, h, yrpsettings.color.background )
        else
          draw.RoundedBox( 0, 0, 0, w, h, yrpsettings.color.buttonInActive )
        end
      end
    end
  end
end
