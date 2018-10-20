--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function showVT( ply )
	if tonumber( HudV("vtto") ) == 1 and ply:GetNWBool( "voting", false ) then
		return true
	end
	return false
end

function hudVT( ply, color )
	if showVT( ply ) then
		local _x = anchorW( HudV("vtaw") ) + ctr( HudV("vtpx") )
		local _y = anchorW( HudV("vtah") ) + ctr( HudV("vtpy") )
		--draw.RoundedBox( 0, _x, _y, ctr( HudV("vtsw") ), ctr( HudV("vtsh") ), color )
		if !tobool( HudV( "vt" .. "tr" ) ) then
			draw.RoundedBox( 0, anchorW( HudV( "vt" .. "aw" ) ) + ctr( HudV("vt" .. "px") ), anchorH( HudV( "vt" .. "ah" ) ) + ctr( HudV("vt" .. "py") ), ctr( HudV("vt" .. "sw") ), ctr( HudV("vt" .. "sh") ), color )
		else
			drawRoundedBoxStencil( ctr( HudV("vt" .. "sh") ), anchorW( HudV( "vt" .. "aw" ) ) + ctr( HudV("vt" .. "px") ), anchorH( HudV( "vt" .. "ah" ) ) + ctr( HudV("vt" .. "py") ), ctr( HudV("vt" .. "sw") ), ctr( HudV("vt" .. "sh") ), color, ctr( HudV("vt" .. "sw") ) )
		end

		local _x2 = _x + ctr( HudV( "vtsw" ) )/2
		draw.SimpleTextOutlined( YRP.lang_string( "wantstherolepre" ) .. " " .. ply:GetNWString( "voteName", "" ) .. " " .. YRP.lang_string( "wantstherolemid" ) .. " " .. ply:GetNWString( "voteRole", "" ) .. " " .. YRP.lang_string( "wantstherolepos" ), "HudBars", _x2, _y + ctr( HudV("vtsh") )/4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr( 2 ), Color( 0, 0, 0 ) )
		if ply:GetNWString( "voteStatus" ) != "yes" and ply:GetNWString( "voteStatus" ) != "no" then
			draw.SimpleTextOutlined( YRP.lang_string( "yes" ) .. " - [Picture Up] | " .. YRP.lang_string( "no" ) .. " - [Picture Down]", "vtsf", _x2, _y + 2*ctr( HudV("vtsh") )/4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr( 2 ), Color( 0, 0, 0 ) )
		elseif ply:GetNWString( "voteStatus" ) == "yes" then
			draw.SimpleTextOutlined( YRP.lang_string( "yes" ), "vtsf", _x2, _y + 2*ctr( HudV("vtsh") )/4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr( 2 ), Color( 0, 0, 0 ) )
		elseif ply:GetNWString( "voteStatus" ) == "no" then
			draw.SimpleTextOutlined( YRP.lang_string( "no" ), "vtsf", _x2, _y + 2*ctr( HudV("vtsh") )/4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr( 2 ), Color( 0, 0, 0 ) )
		end
		draw.SimpleTextOutlined( ply:GetNWInt( "voteCD", "Loading" ), "vtsf", _x2, _y + 3*ctr( HudV("vtsh") )/4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr( 2 ), Color( 0, 0, 0 ) )
	end
end

function hudVTBR( ply )
	if showVT( ply ) then
		drawHUDElementBr( "vt" )
	end
end
