--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
include("shared.lua")
local renw = 240
local renh = 200
local tarw = renw * 4
local tarh = renh * 4
function ENT:Draw()
	if LocalPlayer():GetPos():Distance(self:GetPos()) < 2000 then
		self:DrawModel()
		if self.camera == NULL or self.camera == nil then
			for i, ent in pairs(ents.GetAll()) do
				if ent:GetClass() == "yrp_rt_camera" and ent.monitor == nil then
					ent.monitor = self
					self.camera = ent
					break
				end
			end
		end

		local monitor = self
		local camera = self.camera
		local monpos = monitor:GetPos() + monitor:GetUp() * -7.1 + monitor:GetForward() * 12 + monitor:GetRight() * -1.2
		local monang = monitor:GetAngles()
		monang:RotateAroundAxis(monang:Right(), -13)
		monang:RotateAroundAxis(monang:Up(), 90)
		monang:RotateAroundAxis(monang:Forward(), 90)
		if LocalPlayer():GetPos():Distance(self:GetPos()) < 300 and self.camera ~= NULL and self.camera ~= nil then
			local index = self:EntIndex()
			local campos = camera:GetPos() + camera:GetForward() * 4
			local camang = camera:GetAngles()
			self.map_RT = GetRenderTarget("YRP_RT_CAM_" .. index, tarw, tarh, true)
			if self.map_RT_mat == nil then
				self.map_RT_mat = CreateMaterial(
					"YRP_RT_CAM_" .. index,
					"UnlitGeneric",
					{
						["$basetexture"] = "YRP_RT_CAM_" .. index
					}
				)
			end

			self.delay = self.delay or 0
			if self.delay < CurTime() then
				self.delay = CurTime() + 1
				render.PushRenderTarget(self.map_RT)
				cam.Start2D()
				camera:SetNoDraw(true)
				local CamData = {}
				CamData.angles = camang
				CamData.origin = campos
				CamData.x = 0
				CamData.y = 0
				CamData.w = tarw
				CamData.h = tarh
				CamData.fov = 120
				CamData.viewid = VIEW_MONITOR
				render.RenderView(CamData)
				cam.End2D()
				camera:SetNoDraw(false)
				render.PopRenderTarget()
			end

			if self.map_RT_mat ~= nil then
				cam.Start3D2D(monpos, monang, 0.1)
				surface.SetDrawColor(Color(255, 255, 255, 255))
				surface.SetMaterial(self.map_RT_mat)
				surface.DrawTexturedRect(-renw / 2, -renh / 2, renw, renh)
				cam.End3D2D()
			end
		else
			cam.Start3D2D(monpos, monang, 0.1)
			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawRect(-renw / 2, -renh / 2, renw, renh)
			cam.End3D2D()
		end
	end
end
