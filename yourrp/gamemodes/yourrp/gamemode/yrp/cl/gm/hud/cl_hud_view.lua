--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

function showOwner(eyeTrace)
	if GetGlobalBool("bool_yrp_showowner", true) then
		if eyeTrace.Entity:GetOwner() != nil and eyeTrace.Entity:GetOwner() != NULL then
			draw.SimpleText(YRP.lang_string("LID_owner") .. ": " .. tostring(eyeTrace.Entity:GetOwner()), "Y_24_500", ScrW() / 2, ScrH2() + YRP.ctr(750), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		else
			if eyeTrace.Entity:GetRPOwner() == LocalPlayer() then
				draw.SimpleText(YRP.lang_string("LID_owner") .. ": " .. YRP.lang_string("LID_you"), "Y_24_500", ScrW() / 2, ScrH2() + YRP.ctr(750), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			elseif eyeTrace.Entity:GetRPOwner() != NULL and eyeTrace.Entity:GetRPOwner():IsPlayer() then
				draw.SimpleText(YRP.lang_string("LID_owner") .. ": " .. eyeTrace.Entity:GetRPOwner():RPName(), "Y_24_500", ScrW() / 2, ScrH2() + YRP.ctr(750), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			elseif !strEmpty(eyeTrace.Entity:GetNW2String("ownerRPName", "")) or !strEmpty(eyeTrace.Entity:GetNW2String("ownerGroup", "")) then
				local groupname = eyeTrace.Entity:GetNW2String("ownerGroup", "")
				if string.lower(groupname) == "public" then
					groupname = YRP.lang_string("LID_public")
				end
				draw.SimpleText(YRP.lang_string("LID_owner") .. ": " ..	eyeTrace.Entity:GetNW2String("ownerRPName", "") .. groupname, "Y_24_500", ScrW() / 2, ScrH2() + YRP.ctr(750), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			end
		end
	end
end

function showSecurityLevel(door)
	if door:GetNW2Int("int_securitylevel", 0) > 0 and GetGlobalBool("bool_show_securitylevel", true) then
		draw.SimpleText(YRP.lang_string("LID_securitylevel") .. ": " ..	door:GetNW2Int("int_securitylevel", 0), "Y_24_500", ScrW() / 2, ScrH2() + YRP.ctr(800), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end
end

function HudView()
	local lply = LocalPlayer()
	local _eyeTrace = lply:GetEyeTrace()
	local ent = _eyeTrace.Entity
	if ea(ent) then
		local plypos = lply:GetPos()
		local entpos = ent:WorldSpaceCenter()
		if entpos == Vector(0, 0, 0) then
			entpos = ent:GetPos()
		end
		if entpos:Distance(plypos) > GetGlobalInt("int_door_distance", 200) then
			return
		end
		if GetGlobalBool("bool_building_system", false) and ent:IsDoor() and plypos:Distance(entpos) < GetGlobalInt("int_door_distance", 200) then
			local tab = {}
			tab["KEY"] = "[" .. string.upper(GetKeybindName("in_use")) .. "]"
			draw.SimpleText(YRP.lang_string("LID_presstoopen", tab), "Y_24_500", ScrW() / 2, ScrH2() + YRP.ctr(650), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			local canbeowned = ent:GetNW2Bool("bool_canbeowned", false)
			if canbeowned or lply:HasAccess() then
				local tab2 = {}
				tab2["KEY"] = "[" .. string.upper(GetKeybindName("menu_options_door")) .. "]"
				draw.SimpleText(YRP.lang_string("LID_presstoopensettings", tab2), "Y_24_500", ScrW() / 2, ScrH2() + YRP.ctr(700), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
				showOwner(_eyeTrace)
				showSecurityLevel(ent)
			end
		elseif ent:IsVehicle() and !lply:InVehicle() then
			local tab = {}
			tab["KEY"] = "[" .. string.upper(GetKeybindName("in_use")) .. "]"
			draw.SimpleText(YRP.lang_string("LID_presstogetin", tab), "Y_24_500", ScrW() / 2, ScrH2() + YRP.ctr(650), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			if ent:GetNW2String("ownerRPName") == lply:Nick() then
				local tab2 = {}
				tab2["KEY"] = "[" .. string.upper(GetKeybindName("menu_options_vehicle")) .. "]"
				draw.SimpleText(YRP.lang_string("LID_presstoopensettings", tab2), "Y_24_500", ScrW() / 2, ScrH2() + YRP.ctr(700), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			end
			showOwner(_eyeTrace)
		elseif ent:IsPlayer() then
			if ent:GetColor().a != 0 or !ent:GetNW2Bool("cloaked") then
				local plycol = ent:GetColor()
				local tab = {}
				tab["NAME"] = tostring(ent:RPName())
				tab["KEY"] = "[" .. string.upper(GetKeybindName("menu_interact")) .. "]"
				--draw.SimpleText(YRP.lang_string("LID_presstointeractwith", tab), "Y_24_500", ScrW() / 2, ScrH2() + YRP.ctr(700), Color(255, 255, 255, plycol.a), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			end
		elseif ent:IsNPC() then
			if ent:IsDealer() then
				draw.SimpleText(ent:GetNW2String("name", ""), "Y_24_500", ScrW() / 2, ScrH2() + YRP.ctr(150), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
				local key = {}
				key["KEY"] = "[" .. string.upper(GetKeybindName("in_use")) .. "]"
				draw.SimpleText(YRP.lang_string("LID_presstotrade", key), "Y_24_500", ScrW() / 2, ScrH2() + YRP.ctr(200), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			end
		elseif ent:GetClass() == "yrp_clothing" and plypos:Distance(entpos) < 150 then
			local key = {}
			key["KEY"] = "[" .. string.upper(GetKeybindName("in_use")) .. "]"
			draw.SimpleText(YRP.lang_string("LID_presstochangeyourclothes", key), "Y_24_500", ScrW() / 2, ScrH2() + YRP.ctr(650), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		elseif ent:HasStorage() and plypos:Distance(entpos) < 150 then
			local key = {}
			key["KEY"] = "[" .. string.upper(GetKeybindName("in_use")) .. "]"
			key["NAME"] = ent:StorageName()
			draw.SimpleText(YRP.lang_string("LID_presstoopenname", key), "Y_24_500", ScrW() / 2, ScrH2() + YRP.ctr(700), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		elseif ent:GetNW2Bool("yrp_has_use", false) then
			local text = "PRESS [" .. string.upper(GetKeybindName("in_use")) .. "]"
			if ent:GetNW2String("yrp_use_message", "") != "" then
				text = text .. ": " .. ent:GetNW2String("yrp_use_message", "")
			end
			draw.SimpleText(text, "Y_24_500", ScrW() / 2, ScrH2() + YRP.ctr(700), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		end
		if !ent:IsPlayer() then
			showOwner(_eyeTrace)
		end
	end
end
