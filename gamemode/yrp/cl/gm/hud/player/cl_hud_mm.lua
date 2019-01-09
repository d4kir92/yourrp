--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local CamDataMinimap = {}

local rendering_map = false

local minimap = {}
local _rendered = false
local _minimapDistanceOld = 0
local CamDataMiniMap = {}
function getCoordsMM()
	net.Start("askCoordsMM")
	net.SendToServer()
end

net.Receive("sendCoordsMM", function()
	local _bool = net.ReadBool()
	if _bool then
		minimap = net.ReadTable()
	else
		printGM("note", "wait for server coords")
	end
end)

local delay = 0

function hudMM(ply, color)
	--Minimap
	if tonumber(HudV("mmto")) == 1 then
		if !tobool(HudV("mm" .. "tr")) then
			draw.RoundedBox(0, anchorW(HudV("mmaw")) + ctr(HudV("mmpx")), anchorH(HudV("mmah")) + ctr(HudV("mmpy")), ctr(HudV("mmsw")), ctr(HudV("mmsh")), Color(0, 0, 0, _alpha))
		else
			drawRoundedBox(0, anchorW(HudV("mmaw")) + ctr(HudV("mmpx")), anchorH(HudV("mmah")) + ctr(HudV("mmpy")), ctr(HudV("mmsw")), ctr(HudV("mmsh")), Color(0, 0, 0, _alpha))
		end
		if minimap != nil then
			if playerfullready == true and minimap.facX != nil and minimap.facY != nil then
				local win = {}
				win.w = ctr(HudV("mmsw"))
				win.h = ctr(HudV("mmsh"))
				win.x = ctr(HudV("mmpx"))
				win.y = ctr(HudV("mmpy"))

				_filterENTS = ents.GetAll()
				local _testHeight = 400
				local tr = util.TraceLine({
					start = ply:GetPos() + Vector(0, 0, 16),
					endpos = ply:GetPos() + Vector(0, 0, _testHeight),
					filter = _filterENTS
				})
				local _minimapDistance = math.Round(math.abs(ply:GetPos().z))
				local _distance = math.Round(math.abs(_minimapDistance - _minimapDistanceOld))

				if CurTime() > delay and _rendered then
					delay = CurTime() + 1
					if tr.Hit then
						delay = CurTime() + 1

						_minimapDistanceOld = _minimapDistance
						_rendered = false
					elseif _distance > 64 then
						delay = CurTime() + 1

						_minimapDistanceOld = _minimapDistance
						_rendered = false
					end
				end

				if !_rendered or minimap_RT_mat == nil and minimap.sizeX != nil then
					local _height = 0
					if tr.Hit then
						_height = tr.HitPos.z
					else
						_height = _testHeight
					end
					CamDataMiniMap.angles = Angle(90, 90, 0)
					CamDataMiniMap.origin = Vector(0, 0, _height - 16)
					CamDataMiniMap.x = 0
					CamDataMiniMap.y = 0
					CamDataMiniMap.w = minimap.sizeX
					CamDataMiniMap.h = minimap.sizeY
					CamDataMiniMap.ortho = true
					CamDataMiniMap.ortholeft = minimap.sizeW
					CamDataMiniMap.orthoright = minimap.sizeE
					CamDataMiniMap.orthotop = minimap.sizeS
					CamDataMiniMap.orthobottom = minimap.sizeN

					minimap_RT = GetRenderTarget("YRP_MiniMap", ScrW(), ScrH(), true)
					minimap_RT_mat = CreateMaterial("YRP_MiniMap", "UnlitGeneric", { ["$basetexture"] = "YRP_MiniMap" })
					local old_RT = render.GetRenderTarget()
					local old_w, old_h = ScrW(), ScrH()
					render.SetRenderTarget(minimap_RT)
						render.SetViewPort(0, 0, ScrW(), ScrH())

						render.Clear(0, 0, 0, 0)

							cam.Start2D()
								render.RenderView(CamDataMiniMap)
							cam.End2D()

						render.SetViewPort(0, 0, old_w, old_h)
					render.SetRenderTarget(old_RT)

					_rendered = true
				elseif minimap_RT_mat != nil and _rendered then
					local plyPos = {}
					plyPos.xMax = minimap.sizeX
					plyPos.yMax = minimap.sizeY
					local mm = {}
					mm.w, mm.h = lowerToScreen(minimap.sizeX, minimap.sizeY)
					if minimap.sizeW < 0 then
						plyPos.xtmp = (LocalPlayer():GetPos().x - minimap.sizeW)
					else
						plyPos.xtmp = (LocalPlayer():GetPos().x + minimap.sizeE)
					end
					if minimap.sizeS < 0 then
						plyPos.ytmp = (LocalPlayer():GetPos().y - minimap.sizeS)
					else
						plyPos.ytmp = (LocalPlayer():GetPos().y + minimap.sizeN)
					end
					plyPos.x = 0 + mm.w * (plyPos.xtmp / plyPos.xMax)
					plyPos.y = 0 + mm.h - mm.h * (plyPos.ytmp / plyPos.yMax)

					local _m_w = ctr(HudV("mmsw"))
					local _m_h = ctr(HudV("mmsh"))

					local _m_x = anchorW(HudV("mmaw")) + ctr(HudV("mmpx")) + _m_w/2
					local _m_y = anchorH(HudV("mmah")) + ctr(HudV("mmpy")) + _m_h/2
					--STENCIL
					render.ClearStencil()
					render.SetStencilEnable(true)
						render.SetStencilWriteMask(255)
						render.SetStencilTestMask(255)
						render.SetStencilReferenceValue(25)
						render.SetStencilFailOperation(STENCIL_REPLACE)

						if tobool(HudV("mm" .. "tr")) then
							surface.SetDrawColor(0, 0, 0, 200)
							draw.NoTexture()

							drawCircle(_m_x, _m_y, _m_w/2, 64)
						else
							draw.RoundedBox(0, anchorW(HudV("mmaw")) + ctr(HudV("mmpx")), anchorH(HudV("mmah")) + ctr(HudV("mmpy")), ctr(HudV("mmsw")), ctr(HudV("mmsh")), Color(255, 255, 255))
						end
						render.SetStencilCompareFunction(STENCIL_EQUAL)

						surface.SetDrawColor(255, 255, 255, 255)
						surface.SetMaterial(minimap_RT_mat)
						surface.DrawTexturedRect(anchorW(HudV("mmaw")) + ctr(HudV("mmpx")) + ctr(HudV("mmsw")/2) - plyPos.x, anchorH(HudV("mmah")) + ctr(HudV("mmpy"))	+ctr(HudV("mmsh")/2)- plyPos.y, mm.w, mm.h)
					render.SetStencilEnable(false)

					if !tobool(HudV("mm" .. "tr")) then
						drawRBoxBr(0, ctrF(ScrH()) * anchorW(HudV("mm" .. "aw")) + HudV("mm" .. "px"), ctrF(ScrH()) * anchorH(HudV("mm" .. "ah")) + HudV("mm" .. "py"), HudV("mm" .. "sw"), HudV("mm" .. "sh"), Color(HudV("colbrr"), HudV("colbrg"), HudV("colbrb"), HudV("colbra")), ctr(4))
					else
						render.ClearStencil()
						render.SetStencilEnable(true)
							render.SetStencilWriteMask(255)
							render.SetStencilTestMask(255)
							render.SetStencilReferenceValue(25)
							render.SetStencilFailOperation(STENCIL_REPLACE)

							surface.SetDrawColor(0, 0, 0, 200)
							draw.NoTexture()
							drawCircle(_m_x, _m_y, _m_w/2*0.99, 64)

							render.SetStencilCompareFunction(STENCIL_NOTEQUAL)

							surface.SetDrawColor(Color(HudV("colbrr"), HudV("colbrg"), HudV("colbrb"), HudV("colbra")))
							draw.NoTexture()
							drawCircle(_m_x, _m_y, _m_w/2*1.01, 64)
						render.SetStencilEnable(false)
					end
				end
			else
				getCoordsMM()
			end
		end

		minimap.point = 8
		drawRBoxCr(ctrF(ScrH()) * anchorW(HudV("mmaw")) + HudV("mmpx") + (HudV("mmsw")/2) - (minimap.point/2), ctrF(ScrH()) * anchorH(HudV("mmah")) + HudV("mmpy") + (HudV("mmsh")/2) - (minimap.point/2), minimap.point, Color(0, 0, 255, 200))

		local x = ctrF(ScrH()) * anchorW(HudV("mmaw")) + ctr(HudV("mmpx") + (HudV("mmsw")/2))
		local y = ctrF(ScrH()) * anchorH(HudV("mmah")) + ctr(HudV("mmpy") + (HudV("mmsh")/2))
		local w = ctr(50)
		local h = ctr(50)
		local rot = ply:EyeAngles().y - 90

		surface.SetDrawColor(100, 100, 255, 255)
		surface.SetMaterial(YRP.GetDesignIcon("navigation"))
		surface.DrawTexturedRectRotated(x, y, w, h, rot)

		--Coords
		local _st = {}
		if HudV("mm" .. "tt") == 1 then
			_st.br = 10
			local _pw = 0
			if HudV("mm" .. "tx") == 0 then
				_pw = ctr(_st.br)
			elseif HudV("mm" .. "tx") == 1 then
				_pw = ctr(HudV("mm" .. "sw")) / 2
			elseif HudV("mm" .. "tx") == 2 then
				_pw = ctr(HudV("mm" .. "sw")) - ctr(_st.br)
			end
			local _ph = 0
			if HudV("mm" .. "ty") == 3 then
				_ph = ctr(_st.br)
			elseif HudV("mm" .. "ty") == 1 then
				_ph = ctr(HudV("mm" .. "sh")) / 2
			elseif HudV("mm" .. "ty") == 4 then
				_ph = ctr(HudV("mm" .. "sh")) - ctr(_st.br)
			end
			_st.x = anchorW(HudV("mm" .. "aw")) + ctr(HudV("mm" .. "px")) + _pw
			_st.y = anchorH(HudV("mm" .. "ah")) + ctr(HudV("mm" .. "py")) + _ph
			draw.SimpleTextOutlined(math.Round(ply:GetPos().x, -1) .. ", " .. math.Round(ply:GetPos().y, -1), "HudBars", _st.x, _st.y, Color(255, 255, 255, 255), HudV("mmtx"), HudV("mmty"), 1, Color(0, 0, 0))
		end
	end
end
