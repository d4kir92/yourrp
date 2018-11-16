--Copyright (C) 2017-2018 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

function hudThirdperson(ply, color)
	if input.IsKeyDown(get_keybind("view_zoom_in")) or input.IsKeyDown(get_keybind("view_zoom_out")) then
		local _3PText = ""
		if ply:GetNWInt("view_range", 0) <= -200 then
			_3PText = YRP.lang_string("fppr")
		elseif ply:GetNWInt("view_range", 0) > -200 and ply:GetNWInt("view_range", 0) < 0 then
			_3PText = YRP.lang_string("fpp")
		elseif ply:GetNWInt("view_range", 0) > 0 then
			_3PText = YRP.lang_string("tpp")
		end
		draw.SimpleTextOutlined(_3PText .. " (" .. math.Round(ply:GetNWInt("view_range", 0), -1) .. ")", "HudBars", ScrW()/2, ctr(2160/2 + 550), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end
	if input.IsKeyDown(get_keybind("view_up")) or input.IsKeyDown(get_keybind("view_down")) then
		draw.SimpleTextOutlined(YRP.lang_string("viewingheight") .. " (" .. math.Round(ply:GetNWInt("view_z", 0), 0) .. ")", "HudBars", ScrW()/2, ctr(2160/2 + 600), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end
	if input.IsKeyDown(get_keybind("view_right")) or input.IsKeyDown(get_keybind("view_left")) then
		draw.SimpleTextOutlined(YRP.lang_string("viewingposition") .. " (" .. math.Round(ply:GetNWInt("view_x", 0), 0) .. ")", "HudBars", ScrW()/2, ctr(2160/2 + 650), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end
	if input.IsKeyDown(get_keybind("view_spin_right")) or input.IsKeyDown(get_keybind("view_spin_left")) then
		draw.SimpleTextOutlined(YRP.lang_string("viewingangle") .. " (" .. math.Round(ply:GetNWInt("view_s", 0), 0) .. ")", "HudBars", ScrW()/2, ctr(2160/2 + 700), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end
end
