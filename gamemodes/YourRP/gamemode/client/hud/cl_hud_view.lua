--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function HudView()
  local ply = LocalPlayer()
  local _eyeTrace = ply:GetEyeTrace()

  if _eyeTrace.Entity != nil and _eyeTrace.Entity != NULL then
  	if _eyeTrace.Entity:GetPos():Distance( ply:GetPos() ) > 100 then
  		return
  	end
  end
  if _eyeTrace.Entity != nil and _eyeTrace.Entity != NULL then
    if _eyeTrace.Entity:GetClass() == "prop_door_rotating" or _eyeTrace.Entity:GetClass() == "func_door" or _eyeTrace.Entity:GetClass() == "func_door_rotating" and ply:GetPos():Distance( _eyeTrace.Entity:GetPos() ) < 150 then
      draw.SimpleText( lang.presse, "sef", ScrW()/2, ScrH()/2 + 30, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      draw.SimpleText( lang.holde, "sef", ScrW()/2, ScrH()/2 + 45, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

      if _eyeTrace.Entity:GetNWString( "owner" ) != "" or _eyeTrace.Entity:GetNWString( "ownerGroup" ) != "" then
        draw.SimpleText( lang.owner .. ": " ..  _eyeTrace.Entity:GetNWString( "owner" ) .. _eyeTrace.Entity:GetNWString( "ownerGroup" ), "sef", ScrW()/2, ScrH()/2 + 60, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      end


    end
  end
end
