--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

include("shared.lua")

local renw = 240
local renh = 200

local tarw = renw * 4
local tarh = renh * 4

local scrw = ScH() * 2.4 --renw * 4
local scrh = ScH() * 2 --renh * 4

function ENT:Draw()
	if LocalPlayer():GetPos():Distance(self:GetPos()) < 2000 then
		self:DrawModel()

		if self.camera == NULL or self.camera == nil then
			for i, ent in pairs(ents.GetAll()) do
				if ent:GetClass() == "yrp_rt_camera" then
					if ent.monitor == nil then
						ent.monitor = self
						self.camera = ent
						break
					end
				end
			end
		end
		if LocalPlayer():GetPos():Distance(self:GetPos()) < 300 then
			local monitor = self
			local monpos = monitor:GetPos() + monitor:GetUp() * -7.1 + monitor:GetForward() * 12 + monitor:GetRight() * -1.2
			local monang = monitor:GetAngles()

			monang:RotateAroundAxis(monang:Right(), -13)
			monang:RotateAroundAxis(monang:Up(), 90)
			monang:RotateAroundAxis(monang:Forward(), 90)

			cam.Start3D2D(monpos, monang, 0.1)
				surface.SetDrawColor(255, 255, 255, 10)
				surface.DrawRect(-renw / 2, -renh / 2, renw, renh)
			cam.End3D2D()

			if self.camera != NULL and self.camera != nil then
				local camera = self.camera
				local campos = camera:GetPos() + camera:GetForward() * 4
				local camang = camera:GetAngles()

				local index = self:EntIndex()

				self.map_RT = GetRenderTarget("YRP_RT_CAM" .. index, tarw, tarh, true)
				self.map_RT_mat = CreateMaterial("YRP_RT_CAM" .. index, "UnlitGeneric", { ["$basetexture"] = "YRP_RT_CAM" .. index })
				self.old_RT = render.GetRenderTarget()

				self.delay = self.delay or 0
				if self.delay < CurTime() then
					self.delay = CurTime() + 0.5

					render.SetRenderTarget(self.map_RT)
					--render.Clear(0, 0, 0, 0, true, true)
					cam.Start2D()
						--render.SetViewPort(0, 0, scrw, scrh)
						local CamData = {}
						CamData.angles = camang
						CamData.origin = campos
						CamData.x = 0
						CamData.y = 0
						CamData.w = scrw
						CamData.h = scrh
						CamData.fov = 130
						render.RenderView( CamData )
						--render.SetViewPort(0, 0, ScW(), ScH())
					cam.End2D()
					render.SetRenderTarget(self.old_RT)
				else
					cam.Start3D2D(monpos, monang, 0.1)
						surface.SetDrawColor(255, 255, 255, 255)
						surface.SetMaterial(self.map_RT_mat)
						surface.DrawTexturedRect(-renw / 2, -renh / 2, renw, renh)
					cam.End3D2D()
				end
			end
		end
	end
end
