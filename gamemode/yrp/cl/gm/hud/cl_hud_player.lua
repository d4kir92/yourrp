--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

_filterENTS = ents.GetAll()
local _filterTime = CurTime()

local hud = {}
hud["hp"] = 100
hud["ar"] = 100
hud["mh"] = 100
hud["mt"] = 100
hud["ms"] = 100
hud["ma"] = 100
hud["ca"] = 0
hud["xp"] = 0
hud["wp"] = 0
hud["ws"] = 0
hud["mo"] = 0
hud["st"] = 0
hud["bl"] = 0
hud["rt"] = 0

function roundMoney(_money, round)
	if _money != nil then
		local money = tonumber(_money)
		if money >= 1000 and money < 1000000 then
			return math.Round(money / 1000, round) .. "K"
		elseif money >= 1000000 and money < 1000000000 then
			return math.Round(money / 1000000, round) .. "M"
		elseif money >= 1000000000 then
			return math.Round(money / 1000000000, round) .. "B"
		elseif money >= 1000000000000 then
			return math.Round(money / 1000000000000, round) .. "T"
		else
			return math.Round(money, round)
		end
	end
end

function showIcon(string, material)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(material)
	surface.DrawTexturedRect(anchorW(HudV(string .. "aw")) + YRP.ctr(HudV(string .. "px")) + YRP.ctr(30) - YRP.ctr(16), anchorH(HudV(string .. "ah")) + YRP.ctr(HudV(string .. "py")) + YRP.ctr(HudV(string .. "sh")/2) - YRP.ctr(16), YRP.ctr(32), YRP.ctr(32))
end

hook.Add("SpawnMenuOpen", "yrp_spawn_menu_open", function()
	openMenu()
	return LocalPlayer():GetDBool("bool_canusespawnmenu", false)
end)

hook.Add("SpawnMenuClose", "yrp_spawn_menu_close", function()
	closeMenu()
end)

local contextMenuOpen = false
hook.Add("ContextMenuOpen", "OnContextMenuOpen", function()
	contextMenuOpen = true
	return LocalPlayer():GetDBool("bool_canusecontextmenu", false)
end)

hook.Add("ContextMenuClose", "OnContextMenuClose", function()
	contextMenuOpen = false
end)

function sText(text, font, x, y, color, ax, ay)
	surface.SetFont(font)

	local _, h = surface.GetTextSize(text)

	local _ax = 0
	local _ay = 0

	if ay == 1 then
		_ay = h / 2
	end

	surface.SetTextColor(color or Color(255, 255, 255, 255))
	surface.SetTextPos(x - _ax, y - _ay)
	surface.DrawText(text)
end

function drawMenuInfo()
	if get_tutorial("tut_f1info") then
		local isize = YRP.ctr(48)
		local ibr = YRP.ctr(10)
		local color = Color(255, 255, 255, 20)

		local x = ibr
		local y = ibr

		--[[ F1 ]]--
		surface.SetDrawColor(color)
		surface.SetMaterial(YRP.GetDesignIcon("help")	)
		surface.DrawTexturedRect(x, y, isize, isize)
		x = x + isize + ibr
		local text = "[" .. "F1" .. "] " .. YRP.lang_string("LID_help")
		sText(text, "mat1text", x, y + isize / 2, color, 0, 1)
	end
end

local _alpha = 130
local HUD = {}
HUD.count = 0
HUD.refresh = false

function HudRefreshEnable()
	HUD.refresh = true
end

function HudRefreshDisable()
	HUD.refresh = false
end

function drawHUDElement(dbV, cur, max, text, icon, color)
	if tobool(HudV(dbV .. "to")) then
		local _r = 0
		if color != nil and cur != nil and max != nil then
			if tonumber(cur) > tonumber(max) then
				cur = max
			end
			if HUD[dbV] == nil or HUD.refresh then
				HUD.count = HUD.count + 1
				HUD[dbV] = {}
				HUD[dbV].id = HUD.count
				HUD[dbV].delay = CurTime()
				HUD[dbV].x = anchorW(HudV(dbV .. "aw")) + YRP.ctr(HudV(dbV .. "px"))
				HUD[dbV].y = anchorH(HudV(dbV .. "ah")) + YRP.ctr(HudV(dbV .. "py"))
				HUD[dbV].w = YRP.ctr(HudV(dbV .. "sw"))
				HUD[dbV].barw = cur / max * HUD[dbV].w
				HUD[dbV].h = YRP.ctr(HudV(dbV .. "sh"))
				HUD[dbV].r = HUD[dbV].h / 2
			end
			if CurTime() > HUD[dbV].delay then
				HUD[dbV].delay = CurTime() + 1 / HUD.count * HUD[dbV].id * 0.1
				HUD[dbV].barw = cur / max * HUD[dbV].w
			end

			if tobool(HudV(dbV .. "tr")) then
				_r = YRP.ctr(HudV(dbV .. "sh")) / 2
			end
			draw.RoundedBox(_r, HUD[dbV].x, HUD[dbV].y, HUD[dbV].w, HUD[dbV].h, Color(HudV("colbgr"), HudV("colbgg"), HudV("colbgb"), HudV("colbga")))
			if tonumber(max) >= 0 then
				if !tobool(HudV(dbV .. "tr")) then
					draw.RoundedBox(_r, HUD[dbV].x, HUD[dbV].y, HUD[dbV].barw, HUD[dbV].h, color)
				else
					drawRoundedBoxStencil(_r, HUD[dbV].x, HUD[dbV].y, HUD[dbV].barw, HUD[dbV].h, color, YRP.ctr(HudV(dbV .. "sw")))
				end
			end

			local _st = {}
			if text != nil and HudV(dbV .. "tt") == 1 then
				_st.br = 10
				local _pw = 0
				if HudV(dbV .. "tx") == 0 then
					_pw = YRP.ctr(_st.br)
				elseif HudV(dbV .. "tx") == 1 then
					_pw = YRP.ctr(HudV(dbV .. "sw")) / 2
				elseif HudV(dbV .. "tx") == 2 then
					_pw = YRP.ctr(HudV(dbV .. "sw")) - YRP.ctr(_st.br)
				end
				local _ph = 0
				if HudV(dbV .. "ty") == 3 then
					_ph = YRP.ctr(_st.br)
				elseif HudV(dbV .. "ty") == 1 then
					_ph = YRP.ctr(HudV(dbV .. "sh")) / 2
				elseif HudV(dbV .. "ty") == 4 then
					_ph = YRP.ctr(HudV(dbV .. "sh")) - YRP.ctr(_st.br)
				end
				_st.x = anchorW(HudV(dbV .. "aw")) + YRP.ctr(HudV(dbV .. "px")) + _pw
				_st.y = anchorH(HudV(dbV .. "ah")) + YRP.ctr(HudV(dbV .. "py")) + _ph
				draw.SimpleTextOutlined(text, dbV .. "sf", _st.x, _st.y, Color(255, 255, 255, 255), HudV(dbV .. "tx"), HudV(dbV .. "ty"), 1, Color(0, 0, 0))
			end

			if icon != nil and HudV(dbV .. "it") == 1	then
				showIcon(dbV, icon)
			end
		end
	end
end

function drawHUDElementBr(dbV)
	if tobool(HudV(dbV .. "to")) and HUD[dbV] != nil then
		if !tobool(HudV(dbV .. "tr")) then
			drawRBoxBr2(0, HUD[dbV].x, HUD[dbV].y, HUD[dbV].w, HUD[dbV].h, Color(HudV("colbrr"), HudV("colbrg"), HudV("colbrb"), HudV("colbra")), 1)
		else
			drawRoundedBoxBR(HUD[dbV].r, HUD[dbV].x, HUD[dbV].y, HUD[dbV].w, HUD[dbV].h, Color(HudV("colbrr"), HudV("colbrg"), HudV("colbrb"), HudV("colbra")), 1)
		end
	end
end

function hudThirdperson(ply, color)
	if input.IsKeyDown(get_keybind("view_zoom_in")) or input.IsKeyDown(get_keybind("view_zoom_out")) then
		local _3PText = ""
		if ply.view_range <= -200 then
			_3PText = YRP.lang_string("LID_fppr")
		elseif ply.view_range > -200 and ply.view_range < 0 then
			_3PText = YRP.lang_string("LID_fpp")
		elseif ply.view_range > 0 then
			_3PText = YRP.lang_string("LID_tpp")
		end
		draw.SimpleTextOutlined(_3PText .. " (" .. math.Round(ply.view_range, -1) .. ")", "HudBars", ScrW() / 2, YRP.ctr(2160 / 2 + 550), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end
	if input.IsKeyDown(get_keybind("view_up")) or input.IsKeyDown(get_keybind("view_down")) then
		draw.SimpleTextOutlined(YRP.lang_string("LID_viewingheight") .. " (" .. math.Round(ply.view_z, 0) .. ")", "HudBars", ScrW() / 2, YRP.ctr(2160 / 2 + 600), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end
	if input.IsKeyDown(get_keybind("view_right")) or input.IsKeyDown(get_keybind("view_left")) then
		draw.SimpleTextOutlined(YRP.lang_string("LID_viewingposition") .. " (" .. math.Round(ply.view_x, 0) .. ")", "HudBars", ScrW() / 2, YRP.ctr(2160 / 2 + 650), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end
	if input.IsKeyDown(get_keybind("view_spin_right")) or input.IsKeyDown(get_keybind("view_spin_left")) then
		draw.SimpleTextOutlined(YRP.lang_string("LID_viewingangle") .. " (" .. math.Round(ply.view_s, 0) .. ")", "HudBars", ScrW() / 2, YRP.ctr(2160 / 2 + 700), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end
end

function client_toggled()
	return tobool(GetConVar("yrp_cl_hud"):GetInt())
end

function server_toggled(ply)
	return GetGlobalDBool("bool_yrp_hud", false)
end

function HudPlayer(ply)
	if ply:GetDString("string_hud_design", "notloaded") != "notloaded" then
		drawMenuInfo()

		if ply:Alive() then
			if !contextMenuOpen then
				hudThirdperson(ply)
			end
		end
	else
		draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_loading") .. ": HUD", "DermaDefault", ScrW2(), ScrH2(), Color(255, 255, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, YRP.ctr(1), Color(0, 0, 0, 255))
	end
end
