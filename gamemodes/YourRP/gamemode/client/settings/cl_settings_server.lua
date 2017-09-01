--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--cl_settings_server.lua

include( "cl_settings_server_general.lua" )
include( "cl_settings_server_questions.lua" )
include( "cl_settings_server_roles.lua" )
include( "cl_settings_server_give.lua" )
include( "cl_settings_server_map.lua" )
include( "cl_settings_server_money.lua" )
include( "cl_settings_server_whitelist.lua" )
include( "cl_settings_server_moneysystem.lua" )
include( "cl_settings_server_restriction.lua" )
--include( "cl_settings_server_jailsystem.lua" )

function tabServer( sheet )
  local ply = LocalPlayer()
  if ply:IsAdmin() or ply:IsSuperAdmin() then
    --Server Panel
    local serverPanel = vgui.Create( "DPanel", sheet )
    serverPanel.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, yrp.colors.background ) end
    sheet:AddSheet( lang.server, serverPanel, "icon16/server.png" )
    function serverPanel:Paint()
      draw.RoundedBox( 0, ctrW( 0 ), ctrW( 40 ), serverPanel:GetWide(), serverPanel:GetTall(), yrp.colors.background )
    end

    --Server Sheet
    local serverSheet = vgui.Create( "DPropertySheet", serverPanel )
    serverSheet:Dock( FILL )
    function serverSheet:Paint()
      --drawBackground( 0, 0, serverSheet:GetWide(), serverSheet:GetTall(), ctrW( 10 ) )
    end
    tabServerGeneral( serverSheet )
    tabServerQuestions( serverSheet )
    tabServerRoles( serverSheet )
    tabServerMoney( serverSheet )
    tabServerGive( serverSheet )
    tabServerMap( serverSheet )
    tabServerWhitelist( serverSheet )
    tabServerRestriction( serverSheet )
    --tabServerJailSystem( serverSheet )

    --##############################################################################
    --Server: DLCs System Tab
    --[[
    local sv_dlcsPanel = vgui.Create( "DPanel", serverSheet )
    sv_dlcsPanel.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0 ) ) end
    serverSheet:AddSheet( "DLCs", sv_dlcsPanel, "icon16/brick_add.png" )
    ]]--
    --##############################################################################

    for k, v in pairs(serverSheet.Items) do
    	if (!v.Tab) then continue end

      v.Tab.Paint = function(self,w,h)
        if v.Tab == serverSheet:GetActiveTab() then
  		    draw.RoundedBox( 0, 0, 0, w, h, yrp.colors.background )
        else
          draw.RoundedBox( 0, 0, 0, w, h, yrp.colors.buttonInActive )
        end
      end
    end
  end
end
