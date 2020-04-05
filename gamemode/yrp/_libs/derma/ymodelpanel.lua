--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local function DrawSpecial( x, y, radius, seg )
	local cir = {}
	table.insert( cir, { x = x, y = y } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		if math.sin( a ) <= 0 then
			table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius } )
		else
			table.insert( cir, {x = x + radius, y = 0 } )
			table.insert( cir, {x = x + radius, y = y + radius } )
		end
	end
	local a = math.rad( 0 )
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius } )
	surface.DrawPoly( cir )
end

local PANEL = {}

function PANEL:Init()
	self.panel = vgui.Create( "DModelPanel", self ) -- The magic of changing 1 line of code is amazing
	self.panel:SetPaintedManually( true )
end

function PANEL:PerformLayout()
	self.panel:SetSize( self:GetWide(), self:GetTall() )
end

function PANEL:SetModel(mdl)
	self.panel:SetModel(mdl)
end

function PANEL:Paint( w, h )
	render.ClearStencil()
	render.SetStencilEnable( true )

	render.SetStencilWriteMask( 1 )
	render.SetStencilTestMask( 1 )

	render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
	render.SetStencilPassOperation( STENCILOPERATION_ZERO )
	render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
	render.SetStencilReferenceValue( 1 )

	draw.NoTexture()
	surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
	--DrawSpecial( w / 2, h / 2, h / 2 + 1, math.max(w, h) )
	local diameter = h / 2
	drawCircle(diameter, diameter, diameter, math.max(w, h))

	render.SetStencilFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilReferenceValue( 1 )

	self.panel:PaintManual()

	render.SetStencilEnable(false)
	render.ClearStencil()
end
 
vgui.Register("YModelPanel", PANEL, "PANEL")
