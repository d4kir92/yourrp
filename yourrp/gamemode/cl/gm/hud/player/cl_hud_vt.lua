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
    draw.RoundedBox( 0, _x, _y, ctr( HudV("vtsw") ), ctr( HudV("vtsh") ), color )

    local _x2 = _x + ctr( HudV( "vtsw" ) )/2
    draw.SimpleTextOutlined( ply:GetNWString( "voteQuestion", "" ), "HudBars", _x2, _y + ctr( HudV("vtsh") )/4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr( 2 ), Color( 0, 0, 0 ) )
    if ply:GetNWString( "voteStatus" ) != "yes" and ply:GetNWString( "voteStatus" ) != "no" then
      draw.SimpleTextOutlined( lang_string( "yes" ) .. " - [Picture Up] | " .. lang_string( "no" ) .. " - [Picture Down]", "vtsf", _x2, _y + 2*ctr( HudV("vtsh") )/4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr( 2 ), Color( 0, 0, 0 ) )
    elseif ply:GetNWString( "voteStatus" ) == "yes" then
      draw.SimpleTextOutlined( lang_string( "yes" ), "vtsf", _x2, _y + 2*ctr( HudV("vtsh") )/4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr( 2 ), Color( 0, 0, 0 ) )
    elseif ply:GetNWString( "voteStatus" ) == "no" then
      draw.SimpleTextOutlined( lang_string( "no" ), "vtsf", _x2, _y + 2*ctr( HudV("vtsh") )/4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr( 2 ), Color( 0, 0, 0 ) )
    end
    draw.SimpleTextOutlined( ply:GetNWInt( "voteCD", "Loading" ), "vtsf", _x2, _y + 3*ctr( HudV("vtsh") )/4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr( 2 ), Color( 0, 0, 0 ) )
  end
end

function hudVTBR( ply )
  if showVT( ply ) then
    drawHUDElementBr( "vt" )
  end
end
