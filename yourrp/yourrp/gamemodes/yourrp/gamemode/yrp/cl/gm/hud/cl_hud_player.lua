--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
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
hud["ra"] = 0
hud["hy"] = 0
function roundMoney(_money, round)
	if _money ~= nil then
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

function showIcon(str, material)
	surface.SetDrawColor(Color(255, 255, 255, 255))
	surface.SetMaterial(material)
	surface.DrawTexturedRect(anchorW(HudV(str .. "aw")) + YRP:ctr(HudV(str .. "px")) + YRP:ctr(30) - YRP:ctr(16), anchorH(HudV(str .. "ah")) + YRP:ctr(HudV(str .. "py")) + YRP:ctr(HudV(str .. "sh") / 2) - YRP:ctr(16), YRP:ctr(32), YRP:ctr(32))
end

local once = true
local tabs = {
	["spawnmenu.content_tab"] = "bool_props",
	["spawnmenu.category.npcs"] = "bool_npcs",
	--["spawnmenu.category.addons"] = "bool_Addons",
	["spawnmenu.category.weapons"] = "bool_weapons",
	["spawnmenu.category.postprocess"] = "bool_postprocess",
	--["spawnmenu.category.your_spawnlists"] = "bool_Your Spawnlists", --["spawnmenu.category.addon_spawnlists"] = "bool_Addon Spawnlists", --["spawnmenu.category.games"] = "bool_Games", --["spawnmenu.category.browse"] = "bool_Browse",
	["spawnmenu.category.entities"] = "bool_entities",
	["spawnmenu.category.vehicles"] = "bool_vehicles",
	--["spawnmenu.category.creations"] = "bool_Creations",
	["spawnmenu.category.dupes"] = "bool_dupes",
	["spawnmenu.category.saves"] = "bool_saves"
}

hook.Add(
	"SpawnMenuOpen",
	"yrp_spawn_menu_open",
	function()
		YRPOpenMenu()
		local lply = LocalPlayer()
		if not IsValid(lply) then return false end
		-- Fix tabsorting
		if once then
			once = false
			timer.Simple(
				0.2,
				function()
					if YRPPanelAlive(g_SpawnMenu, "g_SpawnMenu 1") then
						g_SpawnMenu:Close(true) -- close it after short time
						timer.Simple(
							0.1,
							function()
								if YRPPanelAlive(g_SpawnMenu, "g_SpawnMenu 2") and g_SpawnMenu.Open then
									g_SpawnMenu:Open() -- reopen with handling the tabs
									hook.Run("SpawnMenuOpen") -- reload the hook
								end
							end
						)
					end
				end
			)
		else -- Handling Tabs
			local allhidden = true -- for when all disabllowed
			local firsttab = nil
			-- Loop through all tabs of spawnmenu
			if YRPPanelAlive(g_SpawnMenu, "g_SpawnMenu 3") then
				for i, v in pairs(g_SpawnMenu.CreateMenu.Items) do
					local tab = v.Tab -- tab
					local text = tab:GetText() -- tab name
					for lstr, bstr in pairs(tabs) do
						-- if tabtext == tabletabtext
						if text == language.GetPhrase(lstr) then
							tab:SetVisible(LocalPlayer():GetYRPBool(bstr, false)) -- set visible if allowed to
							-- if allowed
							if LocalPlayer():GetYRPBool(bstr) then
								allhidden = false -- then disable hiding the whole element
								-- if not firsttab found
								if firsttab == nil then
									firsttab = lstr -- set it
								end
							end
						end
					end
				end

				-- Switch to allowed tab if on an unallowed one
				local text = g_SpawnMenu.CreateMenu:GetActiveTab():GetText() -- active tab of spawnmenu
				local changefirstpage = false
				for lstr, bstr in pairs(tabs) do
					-- if active tab text == table tab text
					if text and lstr and bstr and language.GetPhrase(text) == language.GetPhrase(lstr) and not lply:GetYRPBool(bstr) then
						changefirstpage = true -- then change tab
					end
				end

				-- change first tab page, because currently on unallowed
				if changefirstpage and firsttab then
					g_SpawnMenu:OpenCreationMenuTab("#" .. firsttab) -- changes to new tab page
				end

				-- Hide the whole element when all disallowed
				if allhidden then
					g_SpawnMenu.CreateMenu:SetVisible(false)
				else
					g_SpawnMenu.CreateMenu:SetVisible(true)
				end
			end
		end

		return LocalPlayer():GetYRPBool("bool_canusespawnmenu", false)
	end, hook.MONITOR_HIGH
)

hook.Add(
	"SpawnMenuClose",
	"yrp_spawn_menu_close",
	function()
		YRPCloseMenu()
	end, hook.MONITOR_HIGH
)

local contextMenuOpen = false
hook.Add(
	"ContextMenuOpen",
	"YRPOnContextMenuOpen",
	function()
		contextMenuOpen = true

		return LocalPlayer():GetYRPBool("bool_canusecontextmenu", false)
	end, hook.MONITOR_HIGH
)

hook.Add(
	"ContextMenuClose",
	"YRPOnContextMenuClose",
	function()
		contextMenuOpen = false
	end, hook.MONITOR_HIGH
)

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
		local isize = YRP:ctr(48)
		local ibr = YRP:ctr(10)
		local color = Color(255, 255, 255, 20)
		local x = ibr
		local y = ibr
		--[[ F1 ]]
		--
		if IsNotNilAndNotFalse(YRP:GetDesignIcon("help")) then
			surface.SetDrawColor(color)
			surface.SetMaterial(YRP:GetDesignIcon("help"))
			surface.DrawTexturedRect(x, y, isize, isize)
		end

		x = x + isize + ibr
		local text = "[" .. "F1" .. "] " .. YRP:trans("LID_help")
		sText(text, "Y_18_500", x, y + isize / 2, color, 0, 1)
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
		if color ~= nil and cur ~= nil and max ~= nil then
			if tonumber(cur) > tonumber(max) then
				cur = max
			end

			if HUD[dbV] == nil or HUD.refresh then
				HUD.count = HUD.count + 1
				HUD[dbV] = {}
				HUD[dbV].id = HUD.count
				HUD[dbV].delay = CurTime()
				HUD[dbV].x = anchorW(HudV(dbV .. "aw")) + YRP:ctr(HudV(dbV .. "px"))
				HUD[dbV].y = anchorH(HudV(dbV .. "ah")) + YRP:ctr(HudV(dbV .. "py"))
				HUD[dbV].w = YRP:ctr(HudV(dbV .. "sw"))
				HUD[dbV].barw = cur / max * HUD[dbV].w
				HUD[dbV].h = YRP:ctr(HudV(dbV .. "sh"))
				HUD[dbV].r = HUD[dbV].h / 2
			end

			if CurTime() > HUD[dbV].delay then
				HUD[dbV].delay = CurTime() + 1 / HUD.count * HUD[dbV].id * 0.1
				HUD[dbV].barw = cur / max * HUD[dbV].w
			end

			if tobool(HudV(dbV .. "tr")) then
				_r = YRP:ctr(HudV(dbV .. "sh")) / 2
			end

			draw.RoundedBox(_r, HUD[dbV].x, HUD[dbV].y, HUD[dbV].w, HUD[dbV].h, Color(HudV("colbgr"), HudV("colbgg"), HudV("colbgb"), HudV("colbga")))
			if tonumber(max) >= 0 then
				if not tobool(HudV(dbV .. "tr")) then
					draw.RoundedBox(_r, HUD[dbV].x, HUD[dbV].y, HUD[dbV].barw, HUD[dbV].h, color)
				else
					drawRoundedBoxStencil(_r, HUD[dbV].x, HUD[dbV].y, HUD[dbV].barw, HUD[dbV].h, color, YRP:ctr(HudV(dbV .. "sw")))
				end
			end

			local _st = {}
			if text ~= nil and HudV(dbV .. "tt") == 1 then
				_st.br = 10
				local _pw = 0
				if HudV(dbV .. "tx") == 0 then
					_pw = YRP:ctr(_st.br)
				elseif HudV(dbV .. "tx") == 1 then
					_pw = YRP:ctr(HudV(dbV .. "sw")) / 2
				elseif HudV(dbV .. "tx") == 2 then
					_pw = YRP:ctr(HudV(dbV .. "sw")) - YRP:ctr(_st.br)
				end

				local _ph = 0
				if HudV(dbV .. "ty") == 3 then
					_ph = YRP:ctr(_st.br)
				elseif HudV(dbV .. "ty") == 1 then
					_ph = YRP:ctr(HudV(dbV .. "sh")) / 2
				elseif HudV(dbV .. "ty") == 4 then
					_ph = YRP:ctr(HudV(dbV .. "sh")) - YRP:ctr(_st.br)
				end

				_st.x = anchorW(HudV(dbV .. "aw")) + YRP:ctr(HudV(dbV .. "px")) + _pw
				_st.y = anchorH(HudV(dbV .. "ah")) + YRP:ctr(HudV(dbV .. "py")) + _ph
				draw.SimpleText(text, dbV .. "sf", _st.x, _st.y, Color(255, 255, 255, 255), HudV(dbV .. "tx"), HudV(dbV .. "ty"), 1, Color(0, 0, 0, 255))
			end

			if icon ~= nil and HudV(dbV .. "it") == 1 then
				showIcon(dbV, icon)
			end
		end
	end
end

function drawHUDElementBr(dbV)
	if tobool(HudV(dbV .. "to")) and HUD[dbV] ~= nil then
		if not tobool(HudV(dbV .. "tr")) then
			drawRBoxBr2(0, HUD[dbV].x, HUD[dbV].y, HUD[dbV].w, HUD[dbV].h, Color(HudV("colbrr"), HudV("colbrg"), HudV("colbrb"), HudV("colbra")), 1)
		else
			drawRoundedBoxBR(HUD[dbV].r, HUD[dbV].x, HUD[dbV].y, HUD[dbV].w, HUD[dbV].h, Color(HudV("colbrr"), HudV("colbrg"), HudV("colbrb"), HudV("colbra")), 1)
		end
	end
end

function YRPHudThirdperson(ply, color)
	if YRPGetKeybind("view_zoom_in") and YRPGetKeybind("view_zoom_out") and (input.IsKeyDown(YRPGetKeybind("view_zoom_in")) or input.IsKeyDown(YRPGetKeybind("view_zoom_out"))) then
		ply.yrp_view_range = ply.yrp_view_range or 0
		ply.yrp_view_range_view = ply.yrp_view_range_view or 0
		local _3PText = ""
		if ply.yrp_view_range <= -200 then
			_3PText = YRP:trans("LID_fppr")
		elseif ply.yrp_view_range > -200 and ply.yrp_view_range < 0 then
			_3PText = YRP:trans("LID_fpp")
		elseif ply.yrp_view_range > 0 then
			_3PText = YRP:trans("LID_tpp")
		end

		draw.SimpleText(_3PText .. " ( " .. math.Round(ply.yrp_view_range, -1) .. " )", "Y_24_500", ScrW() / 2, YRP:ctr(2160 / 2 + 550), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
	end

	if YRPGetKeybind("view_up") and YRPGetKeybind("view_down") and (input.IsKeyDown(YRPGetKeybind("view_up")) or input.IsKeyDown(YRPGetKeybind("view_down"))) then
		draw.SimpleText(YRP:trans("LID_viewingheight") .. " ( " .. math.Round(ply.yrp_view_z, 0) .. " )", "Y_24_500", ScrW() / 2, YRP:ctr(2160 / 2 + 600), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
	end

	if YRPGetKeybind("view_right") and YRPGetKeybind("view_left") and (input.IsKeyDown(YRPGetKeybind("view_right")) or input.IsKeyDown(YRPGetKeybind("view_left"))) then
		draw.SimpleText(YRP:trans("LID_viewingposition") .. " ( " .. math.Round(ply.yrp_view_x, 0) .. " )", "Y_24_500", ScrW() / 2, YRP:ctr(2160 / 2 + 650), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
	end

	if YRPGetKeybind("view_spin_right") and YRPGetKeybind("view_spin_left") and (input.IsKeyDown(YRPGetKeybind("view_spin_right")) or input.IsKeyDown(YRPGetKeybind("view_spin_left"))) then
		draw.SimpleText(YRP:trans("LID_viewingangle") .. " ( " .. math.Round(ply.yrp_view_s, 0) .. "° )", "Y_24_500", ScrW() / 2, YRP:ctr(2160 / 2 + 700), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
	end
end

function client_toggled()
	return tobool(GetConVar("yrp_cl_hud"):GetInt())
end

function server_toggled(ply)
	return GetGlobalYRPBool("bool_yrp_hud", false)
end

function YRPHudPlayer(ply)
	if ply:GetHudDesignName() ~= "notloaded" then
		drawMenuInfo()
		if ply:Alive() and not contextMenuOpen then
			YRPHudThirdperson(ply)
		end
	else
		draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 100))
		draw.SimpleText(YRP:trans("LID_loading") .. ": HUD", "DermaDefault", ScrW2(), ScrH2(), Color(255, 255, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, YRP:ctr(1), Color(0, 0, 0, 255))
	end
end
