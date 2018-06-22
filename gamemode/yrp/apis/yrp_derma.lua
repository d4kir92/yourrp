--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function DrawText( tab )
	tab = tab or {}
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color( 255, 255, 255 )
	tab.br = tab.br or 1
	tab.brcolor = tab.brcolor or Color( 0, 0, 0 )
	tab.ax = tab.ax or 1
	tab.ay = tab.ay or 1
	tab.text = tab.text or "NoText"
	tab.font = tab.font or "DermaDefault"
	draw.SimpleTextOutlined( tab.text, tab.font, tab.x, tab.y, tab.color, tab.ax, tab.ay, tab.br, tab.brcolor )
end

function DHorizontalScroller( tab )
	tab = tab or {}
	tab.parent = tab.parent or nil
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.w = tab.w or 100
	tab.h = tab.h or 100
	tab.color = tab.color or Color( 255, 0, 0, 0 )
	local dhorizontalscroller = createD( "DHorizontalScroller", tab.parent, tab.w, tab.h, tab.x, tab.y )
	function dhorizontalscroller:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, tab.color )
	end

	return dhorizontalscroller
end

function DGroup( tab )
	tab = tab or {}
	tab.parent = tab.parent or nil
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.w = tab.w or 100
	tab.h = tab.h or 100
	tab.br = tab.br or 0
	tab.color = tab.color or Color( 255, 255, 255 )
	tab.bgcolor = tab.bgcolor or Color( 80, 80, 80 )
	tab.name = tab.name or "Unnamed Header"
	local dgroup = {}
	dgroup.header = createD( "DPanel", tab.parent, tab.w, tab.h, tab.x, tab.y )
	function dgroup.header:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, tab.color )
		ph = ctr( 50 )
		local text = {}
		text.text = lang_string( tab.name )
		text.x = pw/2
		text.y = ph/2
		text.font = "mat1header"
		text.color = Color( 0, 0, 0, 255 )
		text.br = 0
		DrawText( text )
	end

	dgroup.content = createD( "DPanelList", tab.parent, tab.w - 2*tab.br, tab.h - 2*tab.br - ctr( 50 ), tab.x + tab.br, tab.y + tab.br + ctr( 50 ) )
	function dgroup.content:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, tab.bgcolor )
	end

	return dgroup.content
end

function DBoolLine( tab, value, str, netstr )
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent != nil then
		tab.w = tab.w or tab.parent:GetWide() or 100
	else
		tab.w = tab.w or 100
	end
	tab.h = tab.h or ctr( 50 )
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color( 255, 255, 255 )
	tab.brx = tab.brx or 0

	local dboolline = {}

	dboolline.line = createD( "DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x )
	function dboolline.line:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, tab.color )
		local text = {}
		text.text = lang_string( str )
		text.x = tab.brx + tab.h + ctr( 10 )
		text.y = ph/2
		text.font = "mat1header"
		text.color = Color( 0, 0, 0, 255 )
		text.br = 0
		text.ax = 0
		DrawText( text )
	end

	dboolline.dcheckbox = createD( "DCheckBox", dboolline.line, tab.h, tab.h, tab.brx, 0 )
	dboolline.dcheckbox:SetValue( value )
	function dboolline.dcheckbox:Paint( pw, ph )
		surfaceCheckBox( self, ph, ph, "done" )
	end
	dboolline.dcheckbox.serverside = false
	function dboolline.dcheckbox:OnChange( bVal )
		if !self.serverside then
			if netstr != "" then
				net.Start( netstr )
					net.WriteBool( bVal )
				net.SendToServer()
			end
		end
	end
	net.Receive( netstr, function( len )
		local b = btn( net.ReadString() )
		if pa( dboolline.dcheckbox ) then
			dboolline.dcheckbox.serverside = true
			dboolline.dcheckbox:SetValue( b )
			dboolline.dcheckbox.serverside = false
		end
	end)

	if tab.parent != nil then
		tab.parent:AddItem( dboolline.line )
	end
	return dboolline.dcheckbox
end

function DFloatLine( tab, value, name, netstr, max, min, dmg )
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent != nil then
		tab.w = tab.w or tab.parent:GetWide() or 300
	else
		tab.w = tab.w or 300
	end
	tab.h = tab.h or ctr( 50 )
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color( 255, 255, 255 )
	tab.brx = tab.brx or 0

	local dfloatline = {}

	dfloatline.line = createD( "DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x )
	function dfloatline.line:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, tab.color )
		local text = {}
		text.text = lang_string( name )
		text.x = tab.brx + ctr( 200 ) + ctr( 10 )
		text.y = ph/2
		text.font = "mat1header"
		text.color = Color( 0, 0, 0, 255 )
		text.br = 0
		text.ax = 0
		DrawText( text )

		if dmg != nil then
			if dmg:GetValue() != nil and dfloatline.dnumberwang != nil then
				local DMG = {}
				DMG.text = dmg:GetValue() * dfloatline.dnumberwang:GetValue() .. " " .. lang_string( "damage" )
				DMG.x = pw - ctr( 10 )
				DMG.y = ph/2
				DMG.font = "mat1header"
				DMG.color = Color( 0, 0, 0, 255 )
				DMG.br = 0
				DMG.ax = 2
				DrawText( DMG )
			end
		end
	end

	dfloatline.dnumberwang = createD( "DNumberWang", dfloatline.line, ctr( 200 ), tab.h, tab.brx, 0 )
	dfloatline.dnumberwang:SetMax( max or 100 )
	dfloatline.dnumberwang:SetMin( min or 0 )
	dfloatline.dnumberwang:SetDecimals( 6 )
	dfloatline.dnumberwang:SetValue( value )
	dfloatline.dnumberwang.serverside = false
	function dfloatline.dnumberwang:OnChange()
		local value = self:GetValue()
		if value >= self:GetMin() then
			if value <= self:GetMax() then
				if !self.serverside then
					if netstr != "" then
						net.Start( netstr )
							net.WriteFloat( value )
						net.SendToServer()
					end
				end
			else
				dfloatline.dnumberwang:SetText( self:GetMax() )
			end
		else
			dfloatline.dnumberwang:SetText( self:GetMin() )
		end
	end
	net.Receive( netstr, function( len )
		local f = net.ReadFloat()
		if pa( dfloatline.dnumberwang ) then
			dfloatline.dnumberwang.serverside = true
			dfloatline.dnumberwang:SetValue( f )
			dfloatline.dnumberwang.serverside = false
		end
	end)

	if tab.parent != nil then
		tab.parent:AddItem( dfloatline.line )
	end
	return dfloatline.dnumberwang
end

function DHR( tab )
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent != nil then
		tab.w = tab.w or tab.parent:GetWide() or 100
	else
		tab.w = tab.w or 100
	end
	tab.h = tab.h or ctr( 30 )
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color( 255, 255, 255 )

	local hr = createD( "DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x )
	function hr:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, tab.color )
		draw.RoundedBox( 0, 0, ph/3, pw, ph/3, Color( 0, 0, 0, 255 ) )
	end

	if tab.parent != nil then
		tab.parent:AddItem( hr )
	end
	return hr
end

function DHeader( tab, header )
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent != nil then
		tab.w = tab.w or tab.parent:GetWide() or 100
	else
		tab.w = tab.w or 100
	end
	tab.h = tab.h or ctr( 50 )
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color( 255, 255, 255 )

	local hea = createD( "DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x )
	function hea:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, tab.color )
		local head = {}
		head.text = lang_string( header )
		head.x = ctr( 10 )
		head.y = ph/2
		head.font = "mat1header"
		head.color = Color( 0, 0, 0, 255 )
		head.br = 0
		head.ax = 0
		DrawText( head )
	end

	if tab.parent != nil then
		tab.parent:AddItem( hea )
	end
	return hea
end
