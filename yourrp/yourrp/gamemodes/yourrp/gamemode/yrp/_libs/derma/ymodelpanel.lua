--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local PANEL = {}
function PANEL:LayoutEntity(ent)
end

--
function PANEL:Init()
	self.panel = vgui.Create("DModelPanel", self)
	self.panel:SetPaintedManually(true)
	function self.panel:LayoutEntity(ent)
		PANEL:LayoutEntity(ent)
	end

	self.Entity = self.panel.Entity
end

function PANEL:PerformLayout()
	self.panel:SetSize(self:GetWide(), self:GetTall())
end

function PANEL:GetModel()
	return self.panel:GetModel()
end

function PANEL:SetModel(mdl)
	self.panel:SetModel(mdl)
	self.Entity = self.panel.Entity
end

function PANEL:SetLookAt(...)
	self.panel:SetLookAt(...)
end

function PANEL:SetCamPos(...)
	self.panel:SetCamPos(...)
end

function PANEL:Paint(w, h)
	render.SetStencilWriteMask(0xFF)
	render.SetStencilTestMask(0xFF)
	render.SetStencilReferenceValue(0)
	-- render.SetStencilCompareFunction( STENCIL_ALWAYS )
	render.SetStencilPassOperation(STENCIL_KEEP)
	-- render.SetStencilFailOperation( STENCIL_KEEP )
	render.SetStencilZFailOperation(STENCIL_KEEP)
	render.ClearStencil()
	render.SetStencilEnable(true)
	render.SetStencilReferenceValue(1)
	render.SetStencilCompareFunction(STENCIL_NEVER)
	render.SetStencilFailOperation(STENCIL_REPLACE)
	draw.NoTexture()
	surface.SetDrawColor(Color(0, 0, 0, 255))
	local diameter = h / 2
	YRPDrawCircle(diameter, diameter, diameter, math.max(w, h))
	render.SetStencilCompareFunction(STENCIL_EQUAL)
	render.SetStencilFailOperation(STENCIL_KEEP)
	self.panel:PaintManual()
	render.SetStencilEnable(false)
end

vgui.Register("YModelPanel", PANEL, "PANEL")