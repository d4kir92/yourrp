--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
--cl_hud_map.lua
local map = {}
local _map = _map or {}
_map.open = false
function getCoords()
	net.Start("nws_yrp_askCoords")
	net.SendToServer()
end

function YRPToggleMap()
	if YRPIsNoMenuOpen() and not _map.open then
		_map.open = true
		YRPOpenMenu()
		net.Start("nws_yrp_askCoords")
		net.SendToServer()
	else
		_map.open = false
		closeMap()
	end
end

function closeMap()
	if _map.window ~= nil and _map.window ~= NULL then
		gui.EnableScreenClicker(false)
		YRPCloseMenu()
		_map.window:Remove()
		_map.window = nil
	end
end

local CamDataMap = {}
function openMap()
	local lply = LocalPlayer()
	if GetGlobalYRPBool("bool_map_system", false) then
		map.open = true
		_map.window = vgui.Create("DFrame")
		_map.window:SetTitle("")
		_map.window:SetPos(0, 0)
		_map.window:SetSize(ScrW(), ScrH())
		_map.window:ShowCloseButton(false)
		_map.window:SetDraggable(false)
		_map.window.tick = CurTime()
		function _map.window:Paint(pw, ph)
			if self.tick < CurTime() and input.IsMouseDown(MOUSE_RIGHT) or input.IsMouseDown(MOUSE_MIDDLE) then
				gui.EnableScreenClicker(not vgui.CursorVisible())
				self.tick = CurTime() + 0.4
			end

			if vgui.CursorVisible() then
				self:ShowCloseButton(true)
			else
				self:ShowCloseButton(false)
			end

			if map ~= nil then
				draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 254)) --_map.window of Map
				local win = {}
				win.w, win.h = lowerToScreen(map.sizeX, map.sizeY)
				win.x = (ScrW() / 2) - (win.w / 2)
				win.y = (ScrH() / 2) - (win.h / 2)
				draw.RoundedBox(0, win.x - YRP.ctr(2), win.y - YRP.ctr(2), win.w + YRP.ctr(4), win.h + YRP.ctr(4), Color(255, 255, 0, 240))
				draw.RoundedBox(0, win.x, win.y, win.w, win.h, Color(0, 0, 0, 255))
				local _mapName = GetNiceMapName()
				local _testHeight = 4000
				local tr = util.TraceLine(
					{
						start = lply:GetPos() + Vector(0, 0, 16),
						endpos = lply:GetPos() + Vector(0, 0, _testHeight),
						filter = _filterENTS
					}
				)

				local _height = 0
				if tr.Hit then
					_height = tr.HitPos.z
				else
					_height = _testHeight
				end

				CamDataMap.angles = Angle(90, 90, 0)
				CamDataMap.origin = Vector(0, 0, _height - 16)
				CamDataMap.x = 0
				CamDataMap.y = 0
				CamDataMap.w = ScrW()
				CamDataMap.h = ScrH()
				CamDataMap.ortho = true
				CamDataMap.ortholeft = map.sizeW
				CamDataMap.orthoright = map.sizeE
				CamDataMap.orthotop = map.sizeS
				CamDataMap.orthobottom = map.sizeN
				map_RT = GetRenderTarget("YRP_Map", win.w, win.h, true)
				map_RT_mat = CreateMaterial(
					"YRP_Map",
					"UnlitGeneric",
					{
						["$basetexture"] = "YRP_Map"
					}
				)

				local old_RT = render.GetRenderTarget()
				local old_w, old_h = ScrW(), ScrH()
				render.SetRenderTarget(map_RT)
				render.SetViewPort(win.x, win.y, win.w, win.h)
				render.Clear(0, 0, 0, 0)
				cam.Start2D()
				if CamDataMap then
					render.RenderView(CamDataMap)
				end

				cam.End2D()
				render.SetViewPort(0, 0, old_w, old_h)
				render.SetRenderTarget(old_RT)
				surface.SetDrawColor(Color(255, 255, 255, 255))
				surface.SetMaterial(map_RT_mat)
				surface.DrawTexturedRect(win.x, win.y, win.w, win.h)
				local plyPos = {}
				plyPos.xMax = map.sizeX
				plyPos.yMax = map.sizeY
				if map.sizeW < 0 then
					plyPos.xtmp = lply:GetPos().x - map.sizeW
				else
					plyPos.xtmp = lply:GetPos().x + map.sizeE
				end

				if map.sizeS < 0 then
					plyPos.ytmp = lply:GetPos().y - map.sizeS
				else
					plyPos.ytmp = lply:GetPos().y + map.sizeN
				end

				plyPos.x = win.x + win.w * (plyPos.xtmp / plyPos.xMax)
				plyPos.y = win.y + win.h - win.h * (plyPos.ytmp / plyPos.yMax)
				local nulPos = {}
				nulPos.xMax = map.sizeX
				nulPos.yMax = map.sizeY
				if map.sizeW < 0 then
					nulPos.xtmp = 0 - map.sizeW
				else
					nulPos.xtmp = 0 + map.sizeE
				end

				if map.sizeS < 0 then
					nulPos.ytmp = 0 - map.sizeS
				else
					nulPos.ytmp = 0 + map.sizeN
				end

				nulPos.x = win.x + win.w * (nulPos.xtmp / nulPos.xMax)
				nulPos.y = win.y + win.h - win.h * (nulPos.ytmp / nulPos.yMax)
				local gridcolor = Color(50, 50, 50)
				local fixc = 0
				for y = nulPos.y - YRP.ctr(300), 0, -YRP.ctr(200) do
					fixc = fixc + 1
				end

				local c = 0
				for y = nulPos.y, win.h, YRP.ctr(200) do
					local color = gridcolor
					if y == nulPos.y then
						color = Color(150, 50, 50)
					end

					draw.RoundedBox(0, win.x, y, win.w, YRP.ctr(2), color)
				end

				for y = nulPos.y, 0, -YRP.ctr(200) do
					local color = gridcolor
					if y == nulPos.y then
						color = Color(150, 50, 50)
					end

					draw.RoundedBox(0, win.x, y, win.w, YRP.ctr(2), color)
				end

				for y = nulPos.y - YRP.ctr(100), 0, -YRP.ctr(200) do
					draw.SimpleText(math.abs(c - fixc) + 1, "Y_24_500", win.x + YRP.ctr(20), y, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					c = c + 1
				end

				for y = nulPos.y - YRP.ctr(100), win.h, YRP.ctr(200) do
					draw.SimpleText(c, "Y_24_500", win.x + YRP.ctr(20), y, Color(200, 200, 200, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					c = c + 1
				end

				local fixc2 = 0
				for x = nulPos.x - YRP.ctr(300), win.x, -YRP.ctr(200) do
					fixc2 = fixc2 + 1
				end

				local c2 = 0
				local let = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}
				for x = nulPos.x, win.x + win.w, YRP.ctr(200) do
					local color = gridcolor
					if x == nulPos.x then
						color = Color(150, 50, 50)
					end

					draw.RoundedBox(0, x, win.y, YRP.ctr(2), win.h, color)
				end

				for x = nulPos.x, win.x, -YRP.ctr(200) do
					local color = gridcolor
					if x == nulPos.x then
						color = Color(150, 50, 50)
					end

					draw.RoundedBox(0, x, win.y, YRP.ctr(2), win.h, color)
				end

				for x = nulPos.x - YRP.ctr(100), win.x, -YRP.ctr(200) do
					draw.SimpleText(let[math.abs(c2 - fixc2) + 1], "Y_24_500", x, win.y + YRP.ctr(20), Color(200, 200, 200, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					c2 = c2 + 1
				end

				for x = nulPos.x + YRP.ctr(100), win.x + win.w, YRP.ctr(200) do
					draw.SimpleText(let[c2], "Y_24_500", x, win.y + YRP.ctr(20), Color(200, 200, 200, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					c2 = c2 + 1
				end

				--draw.SimpleText(win.x .. " |  ||| " ..nulPos.x .. " | " .. win.w, "Y_14_500", ScrW2(), ScrH2(), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				--You
				local x = plyPos.x
				local y = plyPos.y
				local w = YRP.ctr(50)
				local h = YRP.ctr(50)
				local rot = lply:EyeAngles().y - 90
				surface.SetDrawColor(100, 100, 255, 255)
				surface.SetMaterial(YRP.GetDesignIcon("navigation"))
				surface.DrawTexturedRectRotated(x, y, w, h, rot)
				draw.SimpleText(YRP.trans("LID_you"), "Y_24_500", plyPos.x, plyPos.y - YRP.ctr(50), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				--Coords
				draw.SimpleText(math.Round(lply:GetPos().x, -1), "Y_24_500", ScrW() / 2, ScrH() - YRP.ctr(25), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				draw.SimpleText(", " .. math.Round(lply:GetPos().y, -1), "Y_24_500", ScrW() / 2, ScrH() - YRP.ctr(25), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				draw.SimpleText("[M] - " .. YRP.trans("LID_map") .. ": " .. _mapName, "Y_24_500", YRP.ctr(10), YRP.ctr(10), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
				if lply:GetYRPBool("bool_canseeteammatesonmap", false) or lply:GetYRPBool("bool_canseeenemiesonmap", false) then
					for k, pl in pairs(player.GetAll()) do
						if pl ~= lply and (pl:GetGroupName() == lply:GetGroupName() and lply:GetYRPBool("bool_canseeteammatesonmap", false)) or (pl:GetGroupName() ~= lply:GetGroupName() and lply:GetYRPBool("bool_canseeenemiesonmap", false)) then
							local tmp = {}
							tmp.xMax = map.sizeX
							tmp.yMax = map.sizeY
							if map.sizeW < 0 then
								tmp.xtmp = pl:GetPos().x - map.sizeW
							else
								tmp.xtmp = pl:GetPos().x + map.sizeE
							end

							if map.sizeS < 0 then
								tmp.ytmp = pl:GetPos().y - map.sizeS
							else
								tmp.ytmp = pl:GetPos().y + map.sizeN
							end

							tmp.x = win.x + win.w * (tmp.xtmp / tmp.xMax)
							tmp.y = win.y + win.h - win.h * (tmp.ytmp / tmp.yMax)
							--Draw
							local ppx = tmp.x
							local ppy = tmp.y
							local psw = YRP.ctr(50)
							local psh = YRP.ctr(50)
							local prot = pl:EyeAngles().y - 90
							local pl_col = Color(100, 100, 255, 255)
							if pl:GetGroupName() == lply:GetGroupName() then
								pl_col = Color(100, 255, 100, 255)
							elseif pl:GetGroupName() ~= lply:GetGroupName() then
								pl_col = Color(255, 100, 100, 255)
							end

							surface.SetDrawColor(pl_col)
							surface.SetMaterial(YRP.GetDesignIcon("navigation"))
							surface.DrawTexturedRectRotated(ppx, ppy, psw, psh, prot)
							draw.SimpleText(pl:Nick(), "Y_24_500", tmp.x, tmp.y - YRP.ctr(50), Color(0, 0, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						end
					end
				end
			end
		end

		function _map.window:OnClose()
			map.open = false
			YRPCloseMenu()
		end

		function _map.window:OnRemove()
			map.open = false
			YRPCloseMenu()
		end
	end
end

net.Receive(
	"nws_yrp_sendCoords",
	function()
		if net.ReadBool() then
			map = net.ReadTable()
			openMap()
		else
			YRP.msg("note", "wait for server coords")
		end
	end
)