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

playerready = false
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
g_yrp.versionCol = Color( 255, 255, 255, 255 )
function hudVersion()
	if g_yrp.outdated == nil then
		testVersion()
	end
	local _singleplayer = ""
	if game.SinglePlayer() then
		_singleplayer = "Singleplayer"
	end
	draw.SimpleTextOutlined( _singleplayer .. " (" .. GAMEMODE.dedicated .. " Server) " .. "V.: " .. GAMEMODE.Version, "HudVersion", ScrW() - ctr( 70 ), ctr( 60 ), g_yrp.versionCol, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
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
