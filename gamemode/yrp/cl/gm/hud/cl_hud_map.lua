--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

--cl_hud_map.lua

local map = {}

local _map = _map or {}
_map.open = false

function getCoords()
	net.Start("askCoords")
	net.SendToServer()
end

function toggleMap()
	if YRPIsNoMenuOpen() and !_map.open then
		_map.open = true
		openMenu()
		net.Start("askCoords")
		net.SendToServer()
	else
		_map.open = false
		closeMap()
	end
end

function closeMap()
	if _map.window != nil and _map.window != NULL then
		gui.EnableScreenClicker(false)
		closeMenu()
		_map.window:Remove()
		_map.window = nil
	end
end

local CamDataMap = {}
function openMap()
	local lply = LocalPlayer()
	if GetGlobalDBool("bool_map_system", false) then
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
				gui.EnableScreenClicker(!vgui.CursorVisible())
				self.tick = CurTime() + 0.4
			end
			if vgui.CursorVisible() then
				self:ShowCloseButton(true)
			else
				self:ShowCloseButton(false)
			end
			if map != nil then
				local ply = lply
				draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 254))					 --_map.window of Map

				local win = {}
				win.w, win.h = lowerToScreen(map.sizeX, map.sizeY)
				win.x = (ScrW() / 2) - (win.w / 2)
				win.y = (ScrH() / 2) - (win.h / 2)

				draw.RoundedBox(0, win.x - YRP.ctr(2), win.y - YRP.ctr(2), win.w + YRP.ctr(4), win.h + YRP.ctr(4), Color(255, 255, 0, 240))
				draw.RoundedBox(0, win.x, win.y, win.w, win.h, Color(0, 0, 0, 255))

				local _mapName = GetNiceMapName()

				local _testHeight = 4000
				local tr = util.TraceLine({
					start = ply:GetPos() + Vector(0, 0, 16),
					endpos = ply:GetPos() + Vector(0, 0, _testHeight),
					filter = _filterENTS
				})
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
				map_RT_mat = CreateMaterial("YRP_Map", "UnlitGeneric", { ["$basetexture"] = "YRP_Map" })
				local old_RT = render.GetRenderTarget()
				local old_w, old_h = ScrW(), ScrH()
				render.SetRenderTarget(map_RT)
					render.SetViewPort(win.x, win.y, win.w, win.h)

					render.Clear(0, 0, 0, 0)

						cam.Start2D()
							render.RenderView(CamDataMap)
						cam.End2D()

					render.SetViewPort(0, 0, old_w, old_h)
				render.SetRenderTarget(old_RT)

				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(map_RT_mat)
				surface.DrawTexturedRect(win.x, win.y, win.w, win.h)

				local plyPos = {}
				plyPos.xMax = map.sizeX
				plyPos.yMax = map.sizeY
				if map.sizeW < 0 then
					plyPos.xtmp = (lply:GetPos().x - map.sizeW)
				else
					plyPos.xtmp = (lply:GetPos().x + map.sizeE)
				end
				if map.sizeS < 0 then
					plyPos.ytmp = (lply:GetPos().y - map.sizeS)
				else
					plyPos.ytmp = (lply:GetPos().y + map.sizeN)
				end
				plyPos.x = win.x + win.w * (plyPos.xtmp / plyPos.xMax)
				plyPos.y = win.y + win.h - win.h * (plyPos.ytmp / plyPos.yMax)

				--You
				local x = plyPos.x
				local y = plyPos.y
				local w = YRP.ctr(50)
				local h = YRP.ctr(50)
				local rot = ply:EyeAngles().y - 90

				surface.SetDrawColor(100, 100, 255, 255)
				surface.SetMaterial(YRP.GetDesignIcon("navigation"))
				surface.DrawTexturedRectRotated(x, y, w, h, rot)
				draw.SimpleTextOutlined(YRP.lang_string("LID_you"), "sef", plyPos.x, plyPos.y-YRP.ctr(50), Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))

				--Coords
				draw.SimpleTextOutlined(math.Round(ply:GetPos().x, 0), "sef", ScrW() / 2, ScrH() - YRP.ctr(25), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
				draw.SimpleTextOutlined(", " .. math.Round(ply:GetPos().y, 0), "sef", ScrW() / 2, ScrH() - YRP.ctr(25), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))

				draw.SimpleTextOutlined("[M] - " .. YRP.lang_string("LID_map") .. ": " .. _mapName, "HudBars", YRP.ctr(10), YRP.ctr(10), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))

				if lply:GetDBool("bool_canseeteammatesonmap", false) or lply:GetDBool("bool_canseeenemiesonmap", false) then
					for k, pl in pairs(player.GetAll()) do
						if pl != lply and (pl:GetGroupName() == lply:GetGroupName() and lply:GetDBool("bool_canseeteammatesonmap", false)) or (pl:GetGroupName() != lply:GetGroupName() and lply:GetDBool("bool_canseeenemiesonmap", false)) then
							local tmp = {}
							tmp.xMax = map.sizeX
							tmp.yMax = map.sizeY
							if map.sizeW < 0 then
								tmp.xtmp = (pl:GetPos().x - map.sizeW)
							else
								tmp.xtmp = (pl:GetPos().x + map.sizeE)
							end
							if map.sizeS < 0 then
								tmp.ytmp = (pl:GetPos().y - map.sizeS)
							else
								tmp.ytmp = (pl:GetPos().y + map.sizeN)
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
							elseif pl:GetGroupName() != lply:GetGroupName() then
								pl_col = Color(255, 100, 100, 255)
							end
							surface.SetDrawColor(pl_col)
							surface.SetMaterial(YRP.GetDesignIcon("navigation"))
							surface.DrawTexturedRectRotated(ppx, ppy, psw, psh, prot)
							draw.SimpleTextOutlined(pl:Nick(), "sef", tmp.x, tmp.y - YRP.ctr(50), Color(0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
						end
					end
				end
			end
		end
		function _map.window:OnClose()
			map.open = false
			closeMenu()
		end
		function _map.window:OnRemove()
			map.open = false
			closeMenu()
		end
	else
		_info = createD("DFrame", nil, YRP.ctr(400), YRP.ctr(400), 0, 0)
		_info:SetTitle("")
		function _info:Paint(pw, ph)
			surfaceWindow(self, pw, ph, "map")
			surfaceText(YRP.lang_string("LID_disabled"), "mat1text", pw / 2, ph / 2, Color(255, 255, 255), 1, 1)
		end
		_info:MakePopup()
		_info:Center()
	end
end

net.Receive("sendCoords", function()
	if net.ReadBool() then
		map = net.ReadTable()
		openMap()
	else
		printGM("note", "wait for server coords")
	end
end)
