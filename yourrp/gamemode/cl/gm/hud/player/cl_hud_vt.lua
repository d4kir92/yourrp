--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function showVT( ply )
  if tonumber( HudV("vtto") ) == 1 and ply:GetNWBool( "voting", false ) then
    return true
  end
  return false
end

function hudVT( ply, color )
  if showVT( ply ) then
    drawRBox( 0, HudV("vtpx"), HudV("vtpy"), HudV("vtsw"), HudV("vtsh"), color )

    drawText( ply:GetNWString( "voteQuestion", "" ), "HudBars", HudV("vtpx") + HudV("vtsw")/2, HudV("vtpy") + HudV("vtsh")/4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    if ply:GetNWString( "voteStatus" ) != "yes" and ply:GetNWString( "voteStatus" ) != "no" then
      drawText( lang_string( "yes" ) .. " - [Picture Up] | " .. lang_string( "no" ) .. " - [Picture Down]", "vof", HudV("vtpx") + HudV("vtsw")/2, HudV("vtpy") + 2*(HudV("vtsh")/4), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    elseif ply:GetNWString( "voteStatus" ) == "yes" then
      drawText( lang_string( "yes" ), "vof", HudV("vtpx") + HudV("vtsw")/2, HudV("vtpy") + 2*(HudV("vtsh")/4), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    elseif ply:GetNWString( "voteStatus" ) == "no" then
      drawText( lang_string( "no" ), "vof", HudV("vtpx") + HudV("vtsw")/2, HudV("vtpy") + 2*(HudV("vtsh")/4), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    drawText( ply:GetNWInt( "voteCD", "" ), "vof", HudV("vtpx") + HudV("vtsw")/2, HudV("vtpy") + 3*(HudV("vtsh")/4), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end
end

function hudVTBR( ply )
  if showVT( ply ) then
    drawHUDElementBr( "vt" )
  end
end
