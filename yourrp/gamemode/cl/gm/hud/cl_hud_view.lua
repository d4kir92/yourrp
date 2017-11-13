--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function showOwner( eyeTrace )
  if eyeTrace.Entity:GetNWString( "ownerRPName" ) != "" or eyeTrace.Entity:GetNWString( "ownerGroup" ) != "" then
    draw.SimpleTextOutlined( lang_string( "owner" ) .. ": " ..  eyeTrace.Entity:GetNWString( "ownerRPName" ) .. eyeTrace.Entity:GetNWString( "ownerGroup" ), "sef", ScrW()/2, ScrH2() + ctr( 300 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end
end

function HudView()
  local ply = LocalPlayer()
  local _eyeTrace = ply:GetEyeTrace()

  if _eyeTrace.Entity != nil and _eyeTrace.Entity != NULL then
  	if _eyeTrace.Entity:GetPos():Distance( ply:GetPos() ) > 180 then
  		return
  	end
  end
  if _eyeTrace.Entity != nil and _eyeTrace.Entity != NULL then
    if ply:GetNWBool( "toggle_building", false ) and _eyeTrace.Entity:GetClass() == "prop_door_rotating" or _eyeTrace.Entity:GetClass() == "func_door" or _eyeTrace.Entity:GetClass() == "func_door_rotating" and ply:GetPos():Distance( _eyeTrace.Entity:GetPos() ) < 150 then
      draw.SimpleTextOutlined( lang_string( "pressepre" ) .. " [E] " .. lang_string( "pressepos" ), "sef", ScrW()/2, ScrH2() + ctr( 200 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( lang_string( "holdepre" ) .. " [T] " .. lang_string( "holdepos" ), "sef", ScrW()/2, ScrH2() + ctr( 250 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      showOwner( _eyeTrace )
    elseif _eyeTrace.Entity:IsVehicle() and !ply:InVehicle() then
      draw.SimpleTextOutlined( lang_string( "pressevehpre" ) .. " [E] " .. lang_string( "pressevehpos" ), "sef", ScrW()/2, ScrH2() + ctr( 200 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( lang_string( "holdevehpre" ) .. " [T] " .. lang_string( "holdevehpos" ), "sef", ScrW()/2, ScrH2() + ctr( 250 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      showOwner( _eyeTrace )
    end
  end
end
