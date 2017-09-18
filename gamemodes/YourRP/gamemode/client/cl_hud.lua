--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--cl_hud.lua

CreateConVar( "yrp_cl_hud", 1, {}, "" )
--##############################################################################
--Resolution Change
hook.Add( "Initialize", "Resolution Change", function()
	vgui.CreateFromTable {
		Base = "Panel",
		PerformLayout = function()
			hook.Run( "ResolutionChanged", ScrW(), ScrH() )
		end
	} : ParentToHUD()
end )

hook.Add( "ResolutionChanged", "Resolution Change", function( w, h )
	local rw, rh = getResolutionRatio()
	printGM( "user", "Changed Resolution to " .. w .. "x" .. h .. " (" .. rw .. ":" .. rh .. ")" )
	changeFontSize()
end )
--##############################################################################

--##############################################################################
local hide = {
	CHudHealth = true,
	CHudBattery = true,
	CHudAmmo = true,
	CHudSecondaryAmmo = true,
	CHudCrosshair = true
}

function GM:DrawDeathNotice( x, y )
	--No Kill Feed
end

playerready = 0
hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if g_VoicePanelList != nil then
		g_VoicePanelList:SetVisible( false )
	end
	if ( hide[ name ] ) then return false end
end )
--##############################################################################

--##############################################################################
--includes
include( "hud/cl_hud_map.lua" )
include( "hud/cl_hud_player.lua" )
include( "hud/cl_hud_view.lua" )
include( "hud/cl_hud_crosshair.lua" )
--##############################################################################

--##############################################################################
function hudVersion()
	local versionCol = Color( 0, 255, 0, 255 )
	if yrp.outdated then
		versionCol = Color( 255, 0, 0, 255 )
	end
	draw.SimpleText( "V.: " .. GAMEMODE.Version, "HudVersion", ScrW() - ctrW( 70 ), ctrW( 60 ), versionCol, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
end
--##############################################################################

settingsopen = 0

--##############################################################################
hook.Add( "HUDPaint", "CustomHud", function( )

	if GetConVar( "yrp_cl_hud" ):GetInt() == 1 then
		HudPlayer()
		HudCrosshair()

		HudView()
	end

	hudVersion()
end)
--##############################################################################
