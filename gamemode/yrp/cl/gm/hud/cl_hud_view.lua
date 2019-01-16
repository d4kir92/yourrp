--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

function showOwner(eyeTrace)
	if eyeTrace.Entity:GetRPOwner() == LocalPlayer() then
		draw.SimpleTextOutlined(YRP.lang_string("LID_owner") .. ": " .. YRP.lang_string("LID_you"), "sef", ScrW() / 2, ScrH2() + ctr(750), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	elseif eyeTrace.Entity:GetRPOwner() != NULL then
		draw.SimpleTextOutlined(YRP.lang_string("LID_owner") .. ": " .. eyeTrace.Entity:GetRPOwner():RPName(), "sef", ScrW() / 2, ScrH2() + ctr(750), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	elseif eyeTrace.Entity:GetNWString("ownerRPName") != "" or eyeTrace.Entity:GetNWString("ownerGroup") != "" then
		draw.SimpleTextOutlined(YRP.lang_string("LID_owner") .. ": " ..	eyeTrace.Entity:GetNWString("ownerRPName", "") .. eyeTrace.Entity:GetNWString("ownerGroup", ""), "sef", ScrW() / 2, ScrH2() + ctr(750), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end
end

function HudView()
	local ply = LocalPlayer()
	local _eyeTrace = ply:GetEyeTrace()

	if ea(_eyeTrace.Entity) then
		if _eyeTrace.Entity:GetPos():Distance(ply:GetPos()) > 100 then
			return
		end

		if ply:GetNWBool("bool_building_system", false) and (_eyeTrace.Entity:GetClass() == "prop_door_rotating" or _eyeTrace.Entity:GetClass() == "func_door" or _eyeTrace.Entity:GetClass() == "func_door_rotating") and ply:GetPos():Distance(_eyeTrace.Entity:GetPos()) < 150 then
			local tab = {}
			tab["KEY"] = "[" .. string.upper(GetKeybindName("in_use")) .. "]"
			draw.SimpleTextOutlined(YRP.lang_string("LID_presstoopen", tab), "sef", ScrW() / 2, ScrH2() + ctr(650), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			local tab2 = {}
			tab2["KEY"] = "[" .. string.upper(GetKeybindName("menu_options_door")) .. "]"
			draw.SimpleTextOutlined(YRP.lang_string("LID_presstoopensettings", tab2), "sef", ScrW() / 2, ScrH2() + ctr(700), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			showOwner(_eyeTrace)
		elseif _eyeTrace.Entity:IsVehicle() and !ply:InVehicle() then
			local tab = {}
			tab["KEY"] = "[" .. string.upper(GetKeybindName("in_use")) .. "]"
			draw.SimpleTextOutlined(YRP.lang_string("LID_presstogetin", tab), "sef", ScrW() / 2, ScrH2() + ctr(650), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			if _eyeTrace.Entity:GetNWString("ownerRPName") == ply:Nick() then
				local tab2 = {}
				tab2["KEY"] = "[" .. string.upper(GetKeybindName("menu_options_vehicle")) .. "]"
				draw.SimpleTextOutlined(YRP.lang_string("LID_presstoopensettings", tab2), "sef", ScrW() / 2, ScrH2() + ctr(700), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			end
			showOwner(_eyeTrace)
		elseif _eyeTrace.Entity:IsPlayer() then
			if _eyeTrace.Entity:GetColor().a != 0 or !_eyeTrace.Entity:GetNWBool("cloaked") then
				local tab = {}
				tab["NAME"] = tostring(_eyeTrace.Entity:RPName())
				tab["KEY"] = "[" .. string.upper(GetKeybindName("in_use")) .. "]"
				draw.SimpleTextOutlined(YRP.lang_string("LID_presstointeractwith", tab), "sef", ScrW() / 2, ScrH2() + ctr(700), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			end
		elseif _eyeTrace.Entity:IsNPC() then
			if _eyeTrace.Entity:GetNWString("dealerID", "") != "" then
				draw.SimpleTextOutlined(_eyeTrace.Entity:GetNWString("name", ""), "sef", ScrW() / 2, ScrH2() + ctr(150), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
				local key = {}
				key["KEY"] = "[" .. string.upper(GetKeybindName("in_use")) .. "]"
				draw.SimpleTextOutlined(YRP.lang_string("LID_presstotrade", key), "sef", ScrW() / 2, ScrH2() + ctr(200), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			end
		elseif _eyeTrace.Entity:GetClass() == "yrp_clothing" and ply:GetPos():Distance(_eyeTrace.Entity:GetPos()) < 150 then
			local key = {}
			key["KEY"] = "[" .. string.upper(GetKeybindName("in_use")) .. "]"
			draw.SimpleTextOutlined(YRP.lang_string("LID_presstochangeyourclothes", key), "sef", ScrW() / 2, ScrH2() + ctr(650), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		elseif _eyeTrace.Entity:HasStorage() and ply:GetPos():Distance(_eyeTrace.Entity:GetPos()) < 150 then
			local key = {}
			key["KEY"] = "[" .. string.upper(GetKeybindName("in_use")) .. "]"
			key["NAME"] = _eyeTrace.Entity:StorageName()
			draw.SimpleTextOutlined(YRP.lang_string("LID_presstoopenname", key), "sef", ScrW() / 2, ScrH2() + ctr(700), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		elseif _eyeTrace.Entity:GetNWBool("yrp_has_use", false) then
			local text = "PRESS [" .. string.upper(GetKeybindName("in_use")) .. "]"
			if _eyeTrace.Entity:GetNWString("yrp_use_message", "") != "" then
				text = text .. ": " .. _eyeTrace.Entity:GetNWString("yrp_use_message", "")
			end
			draw.SimpleTextOutlined(text, "sef", ScrW() / 2, ScrH2() + ctr(700), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		end
		showOwner(_eyeTrace)
	end
end
