--Copyright (C) 2017-2018 Arno Zura (https://www.gnu.org/licenses/gpl.txt )

function showOwner(eyeTrace )
	if eyeTrace.Entity:GetRPOwner() == LocalPlayer() then
		draw.SimpleTextOutlined(YRP.lang_string("owner" ) .. ": " .. YRP.lang_string("you" ), "sef", ScrW()/2, ScrH2() + ctr(750 ), Color(255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0 ) )
	elseif eyeTrace.Entity:GetRPOwner() != NULL then
		draw.SimpleTextOutlined(YRP.lang_string("owner" ) .. ": " .. eyeTrace.Entity:GetRPOwner():RPName(), "sef", ScrW()/2, ScrH2() + ctr(750 ), Color(255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0 ) )
	elseif eyeTrace.Entity:GetNWString("ownerRPName" ) != "" or eyeTrace.Entity:GetNWString("ownerGroup" ) != "" then
		draw.SimpleTextOutlined(YRP.lang_string("owner" ) .. ": " ..	eyeTrace.Entity:GetNWString("ownerRPName", "" ) .. eyeTrace.Entity:GetNWString("ownerGroup", "" ), "sef", ScrW()/2, ScrH2() + ctr(750 ), Color(255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0 ) )
	end
end

function HudView()
	local ply = LocalPlayer()
	local _eyeTrace = ply:GetEyeTrace()

	if ea(_eyeTrace.Entity ) then
		if _eyeTrace.Entity:GetPos():Distance(ply:GetPos() ) > 100 then
			return
		end

		if ply:GetNWBool("bool_building_system", false ) and (_eyeTrace.Entity:GetClass() == "prop_door_rotating" or _eyeTrace.Entity:GetClass() == "func_door" or _eyeTrace.Entity:GetClass() == "func_door_rotating" ) and ply:GetPos():Distance(_eyeTrace.Entity:GetPos() ) < 150 then
			draw.SimpleTextOutlined(YRP.lang_string("pressepre" ) .. " [" .. string.upper(GetKeybindName("in_use" ) ) .. "] " .. YRP.lang_string("pressepos" ), "sef", ScrW()/2, ScrH2() + ctr(650 ), Color(255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0 ) )
			draw.SimpleTextOutlined(YRP.lang_string("holdepre" ) .. " [" .. string.upper(GetKeybindName("menu_options_door" ) ) .. "] " .. YRP.lang_string("holdepos" ), "sef", ScrW()/2, ScrH2() + ctr(700 ), Color(255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0 ) )
			showOwner(_eyeTrace )
		elseif _eyeTrace.Entity:IsVehicle() and !ply:InVehicle() then
			draw.SimpleTextOutlined(YRP.lang_string("pressevehpre" ) .. " [" .. string.upper(GetKeybindName("in_use" ) ) .. "] " .. YRP.lang_string("pressevehpos" ), "sef", ScrW()/2, ScrH2() + ctr(650 ), Color(255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0 ) )
			if _eyeTrace.Entity:GetNWString("ownerRPName" ) == ply:Nick() then
				draw.SimpleTextOutlined(YRP.lang_string("holdevehpre" ) .. " [" .. string.upper(GetKeybindName("menu_options_vehicle" ) ) .. "] " .. YRP.lang_string("holdevehpos" ), "sef", ScrW()/2, ScrH2() + ctr(700 ), Color(255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0 ) )
			end
			showOwner(_eyeTrace )
		elseif _eyeTrace.Entity:IsPlayer() then
			if _eyeTrace.Entity:GetColor().a != 0 or !_eyeTrace.Entity:GetNWBool("cloaked" ) then
				draw.SimpleTextOutlined(YRP.lang_string("pressplypre" ) .. " [" .. string.upper(GetKeybindName("in_use" ) ) .. "] " .. YRP.lang_string("pressplymid" ) .. " " .. tostring(_eyeTrace.Entity:RPName() ) .. " " .. YRP.lang_string("pressplypos" ), "sef", ScrW()/2, ScrH2() + ctr(700 ), Color(255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0 ) )
			end
		elseif _eyeTrace.Entity:IsNPC() then
			if _eyeTrace.Entity:GetNWString("dealerID", "" ) != "" then
				draw.SimpleTextOutlined(_eyeTrace.Entity:GetNWString("name", "" ), "sef", ScrW()/2, ScrH2() + ctr(150 ), Color(255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0 ) )
				draw.SimpleTextOutlined(YRP.lang_string("totradepre" ) .. " [" .. string.upper(GetKeybindName("in_use" ) ) .. "] " .. YRP.lang_string("totradepos" ), "sef", ScrW()/2, ScrH2() + ctr(200 ), Color(255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0 ) )
			end
		elseif _eyeTrace.Entity:GetClass() == "yrp_clothing" and ply:GetPos():Distance(_eyeTrace.Entity:GetPos() ) < 150 then
			draw.SimpleTextOutlined(YRP.lang_string("toappearancepre" ) .. " [" .. string.upper(GetKeybindName("in_use" ) ) .. "] " .. YRP.lang_string("toappearancepos" ), "sef", ScrW()/2, ScrH2() + ctr(650 ), Color(255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0 ) )
		elseif _eyeTrace.Entity:HasStorage() and ply:GetPos():Distance(_eyeTrace.Entity:GetPos() ) < 150 then
			draw.SimpleTextOutlined(_eyeTrace.Entity:StorageName(), "sef", ScrW()/2, ScrH2() + ctr(650 ), Color(255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0 ) )
			draw.SimpleTextOutlined(YRP.lang_string("openstoragepre" ) .. " [" .. string.upper(GetKeybindName("in_use" ) ) .. "] " .. YRP.lang_string("openstoragepos" ), "sef", ScrW()/2, ScrH2() + ctr(700 ), Color(255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0 ) )
		elseif _eyeTrace.Entity:GetNWBool("yrp_has_use", false ) then
			local text = "PRESS [" .. string.upper(GetKeybindName("in_use" ) ) .. "]"
			if _eyeTrace.Entity:GetNWString("yrp_use_message", "" ) != "" then
				text = text .. ": " .. _eyeTrace.Entity:GetNWString("yrp_use_message", "" )
			end
			draw.SimpleTextOutlined(text, "sef", ScrW()/2, ScrH2() + ctr(700 ), Color(255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0 ) )
		end
		showOwner(_eyeTrace )
	end
end
