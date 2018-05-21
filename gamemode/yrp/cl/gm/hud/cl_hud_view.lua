--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function showOwner( eyeTrace )
  if eyeTrace.Entity:GetNWString( "ownerRPName" ) != "" or eyeTrace.Entity:GetNWString( "ownerGroup" ) != "" then
    draw.SimpleTextOutlined( lang_string( "owner" ) .. ": " ..  eyeTrace.Entity:GetNWString( "ownerRPName", "" ) .. eyeTrace.Entity:GetNWString( "ownerGroup", "" ), "sef", ScrW()/2, ScrH2() + ctr( 750 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end
end

function HudView()
  local ply = LocalPlayer()
  local _eyeTrace = ply:GetEyeTrace()

  if ea( _eyeTrace.Entity ) then
  	if _eyeTrace.Entity:GetPos():Distance( ply:GetPos() ) > 100 then
  		return
  	end
    if ply:GetNWBool( "toggle_building", false ) and ( _eyeTrace.Entity:GetClass() == "prop_door_rotating" or _eyeTrace.Entity:GetClass() == "func_door" or _eyeTrace.Entity:GetClass() == "func_door_rotating" ) and ply:GetPos():Distance( _eyeTrace.Entity:GetPos() ) < 150 then
      draw.SimpleTextOutlined( lang_string( "pressepre" ) .. " [" .. string.upper( GetKeybindName( "in_use" ) ) .. "] " .. lang_string( "pressepos" ), "sef", ScrW()/2, ScrH2() + ctr( 650 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( lang_string( "holdepre" ) .. " [" .. string.upper( GetKeybindName( "menu_options_door" ) ) .. "] " .. lang_string( "holdepos" ), "sef", ScrW()/2, ScrH2() + ctr( 700 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      showOwner( _eyeTrace )
    elseif _eyeTrace.Entity:IsVehicle() and !ply:InVehicle() then
      draw.SimpleTextOutlined( lang_string( "pressevehpre" ) .. " [" .. string.upper( GetKeybindName( "in_use" ) ) .. "] " .. lang_string( "pressevehpos" ), "sef", ScrW()/2, ScrH2() + ctr( 650 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      if _eyeTrace.Entity:GetNWString( "ownerRPName" ) == ply:Nick() then
        draw.SimpleTextOutlined( lang_string( "holdevehpre" ) .. " [" .. string.upper( GetKeybindName( "menu_options_vehicle" ) ) .. "] " .. lang_string( "holdevehpos" ), "sef", ScrW()/2, ScrH2() + ctr( 700 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      end
      showOwner( _eyeTrace )
    elseif _eyeTrace.Entity:IsPlayer() then
      draw.SimpleTextOutlined( lang_string( "pressplypre" ) .. " [" .. string.upper( GetKeybindName( "in_use" ) ) .. "] " .. lang_string( "pressplymid" ) .. " " .. tostring( _eyeTrace.Entity:RPName() ) .. " " .. lang_string( "pressplypos" ), "sef", ScrW()/2, ScrH2() + ctr( 700 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    elseif _eyeTrace.Entity:IsNPC() then
      if _eyeTrace.Entity:GetNWString( "dealerID", "" ) != "" then
        draw.SimpleTextOutlined( _eyeTrace.Entity:GetNWString( "name", "" ), "sef", ScrW()/2, ScrH2() + ctr( 150 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
        draw.SimpleTextOutlined( lang_string( "totradepre" ) .. " [" .. string.upper( GetKeybindName( "in_use" ) ) .. "] " .. lang_string( "totradepos" ), "sef", ScrW()/2, ScrH2() + ctr( 200 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      end
    elseif _eyeTrace.Entity:GetClass() == "yrp_clothing" and ply:GetPos():Distance( _eyeTrace.Entity:GetPos() ) < 150 then
      draw.SimpleTextOutlined( lang_string( "toappearancepre" ) .. " [" .. string.upper( GetKeybindName( "in_use" ) ) .. "] " .. lang_string( "toappearancepos" ), "sef", ScrW()/2, ScrH2() + ctr( 650 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      showOwner( _eyeTrace )
    elseif _eyeTrace.Entity:HasStorage() and ply:GetPos():Distance( _eyeTrace.Entity:GetPos() ) < 150 then
      draw.SimpleTextOutlined( _eyeTrace.Entity:StorageName(), "sef", ScrW()/2, ScrH2() + ctr( 650 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( lang_string( "openstoragepre" ) .. " [" .. string.upper( GetKeybindName( "in_use" ) ) .. "] " .. lang_string( "openstoragepos" ), "sef", ScrW()/2, ScrH2() + ctr( 700 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      showOwner( _eyeTrace )
    end
  end
end
