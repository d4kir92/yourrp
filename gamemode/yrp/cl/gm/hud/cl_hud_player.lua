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
	surface.DrawTexturedRect(anchorW(HudV(string .. "aw")) + ctr(HudV(string .. "px")) + ctr(30) - ctr(16), anchorH(HudV(string .. "ah")) + ctr(HudV(string .. "py")) + ctr(HudV(string .. "sh")/2) - ctr(16), ctr(32), ctr(32))
end

local contextMenuOpen = false
hook.Add("OnContextMenuOpen", "OnContextMenuOpen", function()
	contextMenuOpen = true
end)

hook.Add("OnContextMenuClose", "OnContextMenuClose", function()
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
		local isize = ctr(48)
		local ibr = ctr(10)
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
				HUD[dbV].x = anchorW(HudV(dbV .. "aw")) + ctr(HudV(dbV .. "px"))
				HUD[dbV].y = anchorH(HudV(dbV .. "ah")) + ctr(HudV(dbV .. "py"))
				HUD[dbV].w = ctr(HudV(dbV .. "sw"))
				HUD[dbV].barw = cur / max * HUD[dbV].w
				HUD[dbV].h = ctr(HudV(dbV .. "sh"))
				HUD[dbV].r = HUD[dbV].h / 2
			end
			if CurTime() > HUD[dbV].delay then
				HUD[dbV].delay = CurTime() + 1 / HUD.count * HUD[dbV].id * 0.1
				HUD[dbV].barw = cur / max * HUD[dbV].w
			end

			if tobool(HudV(dbV .. "tr")) then
				_r = ctr(HudV(dbV .. "sh")) / 2
			end
			draw.RoundedBox(_r, HUD[dbV].x, HUD[dbV].y, HUD[dbV].w, HUD[dbV].h, Color(HudV("colbgr"), HudV("colbgg"), HudV("colbgb"), HudV("colbga")))
			if tonumber(max) >= 0 then
				if !tobool(HudV(dbV .. "tr")) then
					draw.RoundedBox(_r, HUD[dbV].x, HUD[dbV].y, HUD[dbV].barw, HUD[dbV].h, color)
				else
					drawRoundedBoxStencil(_r, HUD[dbV].x, HUD[dbV].y, HUD[dbV].barw, HUD[dbV].h, color, ctr(HudV(dbV .. "sw")))
				end
			end

			local _st = {}
			if text != nil and HudV(dbV .. "tt") == 1 then
				_st.br = 10
				local _pw = 0
				if HudV(dbV .. "tx") == 0 then
					_pw = ctr(_st.br)
				elseif HudV(dbV .. "tx") == 1 then
					_pw = ctr(HudV(dbV .. "sw")) / 2
				elseif HudV(dbV .. "tx") == 2 then
					_pw = ctr(HudV(dbV .. "sw")) - ctr(_st.br)
				end
				local _ph = 0
				if HudV(dbV .. "ty") == 3 then
					_ph = ctr(_st.br)
				elseif HudV(dbV .. "ty") == 1 then
					_ph = ctr(HudV(dbV .. "sh")) / 2
				elseif HudV(dbV .. "ty") == 4 then
					_ph = ctr(HudV(dbV .. "sh")) - ctr(_st.br)
				end
				_st.x = anchorW(HudV(dbV .. "aw")) + ctr(HudV(dbV .. "px")) + _pw
				_st.y = anchorH(HudV(dbV .. "ah")) + ctr(HudV(dbV .. "py")) + _ph
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
		if ply:GetNWInt("view_range", 0) <= -200 then
			_3PText = YRP.lang_string("LID_fppr")
		elseif ply:GetNWInt("view_range", 0) > -200 and ply:GetNWInt("view_range", 0) < 0 then
			_3PText = YRP.lang_string("LID_fpp")
		elseif ply:GetNWInt("view_range", 0) > 0 then
			_3PText = YRP.lang_string("LID_tpp")
		end
		draw.SimpleTextOutlined(_3PText .. " (" .. math.Round(ply:GetNWInt("view_range", 0), -1) .. ")", "HudBars", ScrW()/2, ctr(2160/2 + 550), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end
	if input.IsKeyDown(get_keybind("view_up")) or input.IsKeyDown(get_keybind("view_down")) then
		draw.SimpleTextOutlined(YRP.lang_string("LID_viewingheight") .. " (" .. math.Round(ply:GetNWInt("view_z", 0), 0) .. ")", "HudBars", ScrW()/2, ctr(2160/2 + 600), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end
	if input.IsKeyDown(get_keybind("view_right")) or input.IsKeyDown(get_keybind("view_left")) then
		draw.SimpleTextOutlined(YRP.lang_string("LID_viewingposition") .. " (" .. math.Round(ply:GetNWInt("view_x", 0), 0) .. ")", "HudBars", ScrW()/2, ctr(2160/2 + 650), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end
	if input.IsKeyDown(get_keybind("view_spin_right")) or input.IsKeyDown(get_keybind("view_spin_left")) then
		draw.SimpleTextOutlined(YRP.lang_string("LID_viewingangle") .. " (" .. math.Round(ply:GetNWInt("view_s", 0), 0) .. ")", "HudBars", ScrW()/2, ctr(2160/2 + 700), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end
end

function client_toggled()
	return tobool(GetConVar("yrp_cl_hud"):GetInt())
end

function server_toggled(ply)
	return ply:GetNWBool("bool_yrp_hud", false)
end

function HudPlayer(ply)
	if ply:GetNWString("string_hud_design", "notloaded") != "notloaded" then
		drawMenuInfo()

		if ply:Alive() then
			if !contextMenuOpen then
				hudThirdperson(ply)
			end
		else
			drawRBox(0, 0, 0, ScrW() * ctrF(ScrH()), ScrH() * ctrF(ScrH()), Color(255, 0, 0, 100))
			draw.SimpleTextOutlined(YRP.lang_string("LID_dead") .. "! " .. YRP.lang_string("LID_respawning") .. "...", "HudBars", ScrW2(), ScrH2(), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		end

		if ply:GetNWBool("bool_lockdown", false) then
			local lockdown = "[" .. string.upper(YRP.lang_string("LID_lockdown")) .. "]"
			draw.SimpleTextOutlined(lockdown .. " " .. ply:GetNWString("string_lockdowntext", "") .. " " .. lockdown, "Roboto30B", ScrW() / 2, ScrH() / 2 - ctr(800), Color(255, 100, 100, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		end
	else
		draw.SimpleTextOutlined(YRP.lang_string("LID_loading") .. ": HUD", "DermaDefault", ScrW2(), ScrH2(), Color(255, 255, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr(1), Color(0, 0, 0, 255))
	end
end
