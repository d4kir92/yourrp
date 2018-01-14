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
	CHudCrosshair = true,
	CHudVoiceStatus = false
}

function GM:DrawDeathNotice( x, y )
	--No Kill Feed
end

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

Material("voice/icntlk_pl"):SetFloat("$alpha", 0)

local _showVoice = false
function GM:PlayerStartVoice( ply )
  if ply == LocalPlayer() then
    _showVoice = true
  end
end
function GM:PlayerEndVoice( ply )
  if ply == LocalPlayer() then
    _showVoice = false
  end
end

--##############################################################################
function hudVersion()
	if !version_tested() then
		testVersion()
	else
		local _singleplayer = ""
		if game.SinglePlayer() then
			_singleplayer = "Singleplayer"
		end

		--[[ Version Color ]]--
		local _color1 = version_color() or Color( 0, 0, 0, 255 )
		local _color2 = Color( 0, 0, 0, 255 )
		local _alpha = 10
		if input.IsKeyDown(KEY_F12) or input.IsKeyDown(KEY_F5) or is_version_outdated() then
			_alpha = 255
		end
		_color1.a = _alpha
		_color2.a = _alpha

		local _text = tostring( _singleplayer ) .. " (" .. GAMEMODE.dedicated .. " Server) " .. GAMEMODE.Version .. " " .. string.upper( tostring( GAMEMODE.VersionSort ) )
		draw.SimpleTextOutlined( _text, "HudVersion", ScrW() - ctr( 70 ), ctr( 60 ), _color1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, ctr( 1 ), _color2 )
	end
end
--##############################################################################

--##############################################################################
hook.Add( "HUDPaint", "CustomHud", function( )
	HudPlayer()
	HudCrosshair()

	HudView()

	--Voice
	if _showVoice then
		local _voice_text = lang_string( "youarespeaking" ) .. " ("
		if LocalPlayer():GetNWInt( "speak_channel", -1 ) == 1 then
			_voice_text = _voice_text .. lang_string( "speakgroup" )
		elseif LocalPlayer():GetNWInt( "speak_channel", -1 ) == 2 then
			_voice_text = _voice_text .. lang_string( "speakglobal" )
		else
			_voice_text = _voice_text .. lang_string( "speaklocal" )
		end
		_voice_text = _voice_text .. ")"

		draw.SimpleTextOutlined( _voice_text, "HudBars", ScrW2(), ctr( 500 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
	end

	if tobool( get_tutorial( "tut_hudhelp" ) ) then
		draw.SimpleTextOutlined( "[YourRP] " .. lang_string( "helppre" ) .. " [F1] " .. lang_string( "helppos" ), "HudBars", ScrW2(), ctr( 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
	end

	hudVersion()
end)
--##############################################################################
