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
	draw.SimpleTextOutlined( lang_string( tab.text ), tab.font, tab.x, tab.y, tab.color, tab.ax, tab.ay, tab.br, tab.brcolor )
end

function DHorizontalScroller( tab )
	tab = tab or {}
	tab.parent = tab.parent or nil
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.w = tab.w or 100
	tab.h = tab.h or 100
	tab.br = tab.br or 10
	tab.color = tab.color or Color( 255, 0, 0, 0 )
	local dhorizontalscroller = createD( "DHorizontalScroller", tab.parent, tab.w, tab.h, tab.x, tab.y )
	function dhorizontalscroller:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, tab.color )
	end
	dhorizontalscroller:SetOverlap( -tab.br )

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
		text.x = pw / 2
		text.y = ph / 2
		text.font = "mat1header"
		text.color = Color( 0, 0, 0, 255 )
		text.br = 0
		DrawText( text )
	end

	dgroup.content = createD( "DPanelList", dgroup.header, tab.w - 2 * tab.br, tab.h - 2 * tab.br - ctr( 50 ), tab.x + tab.br, tab.y + tab.br + ctr( 50 ) )
	function dgroup.content:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, tab.bgcolor )
	end

	if tab.parent != nil then
		if tab.parent.AddPanel != nil then
			tab.parent:AddPanel( dgroup.header )
		else
			tab.parent:AddItem( dgroup.header )
		end
	end
	return dgroup.content
end

function DName( tab )
	tab = tab or {}
	tab.parent = tab.parent or nil
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.w = tab.w or ctr( 50 )
	tab.h = tab.h or ctr( 50 )
	tab.br = tab.br or 0
	tab.color = tab.color or Color( 255, 255, 255 )
	tab.bgcolor = tab.bgcolor or Color( 80, 80, 80 )
	tab.name = tab.name or "Unnamed"
	local dname = createD( "DPanel", tab.parent, tab.w, tab.h, tab.x, tab.y )
	function dname:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, tab.color )
		local text = {}
		text.text = lang_string( tab.name )
		text.x = ctr(10)
		text.y = ph / 2
		text.font = "mat1text"
		text.color = Color( 255, 255, 255, 255 )
		text.br = 1
		text.ax = 0
		DrawText( text )
	end

	if tab.parent != nil then
		tab.parent:AddItem( dname )
	end
	return dname
end

function DIntComboBoxBox( tab, choices, name, netstr, selected )
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent != nil then
		tab.w = tab.w or tab.parent:GetWide() or 300
	else
		tab.w = tab.w or 300
	end
	tab.h = tab.h or ctr( 100 )
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color( 255, 255, 255 )

	local dintcomboboxbox = {}

	dintcomboboxbox.line = createD( "DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x )
	function dintcomboboxbox.line:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, tab.color )
		local text = {}
		text.text = lang_string( name ) .. ":"
		text.x = ctr( 10 )
		text.y = ph / 4
		text.font = "mat1text"
		text.color = Color( 255, 255, 255, 255 )
		text.br = 1
		text.ax = 0
		DrawText( text )
	end

	dintcomboboxbox.dcombobox = createD( "DComboBox", dintcomboboxbox.line, tab.w, tab.h / 2, tab.brx, tab.h / 2 )
	dintcomboboxbox.dcombobox.serverside = false
	if choices != nil then
		for i, choice in pairs(choices) do
			local _sel = false
			if selected == choice.data then
				_sel = true
			end
			dintcomboboxbox.dcombobox:AddChoice( choice.name, choice.data, _sel )
		end
	end
	function dintcomboboxbox.dcombobox:OnSelect( index, value, data )
		if netstr != nil then
			net.Start( netstr )
				net.WriteInt( data, 32 )
			net.SendToServer()
		end
	end

	if tab.parent != nil then
		tab.parent:AddItem( dintcomboboxbox.line )
	end
	return dintcomboboxbox.dcombobox
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
		text.y = ph / 2
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
	if netstr != nil then
		function dboolline.dcheckbox:OnChange( bVal )
			if !self.serverside and netstr != "" then
				net.Start( netstr )
					net.WriteBool( bVal )
				net.SendToServer()
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
	end

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
		text.y = ph / 2
		text.font = "mat1header"
		text.color = Color( 0, 0, 0, 255 )
		text.br = 0
		text.ax = 0
		DrawText( text )

		if dmg != nil and dfloatline.dnumberwang != nil then
			local DMG = {}
			DMG.text = dmg:GetValue() * dfloatline.dnumberwang:GetValue() .. " " .. lang_string( "damage" )
			DMG.x = pw - ctr( 10 )
			DMG.y = ph / 2
			DMG.font = "mat1header"
			DMG.color = Color( 0, 0, 0, 255 )
			DMG.br = 0
			DMG.ax = 2
			DrawText( DMG )
		end
	end

	dfloatline.dnumberwang = createD( "DNumberWang", dfloatline.line, ctr( 200 ), tab.h, tab.brx, 0 )
	dfloatline.dnumberwang:SetMax( max or 100 )
	dfloatline.dnumberwang:SetMin( min or 0 )
	dfloatline.dnumberwang:SetDecimals( 6 )
	dfloatline.dnumberwang:SetValue( value )
	dfloatline.dnumberwang.serverside = false
	function dfloatline.dnumberwang:OnChange()
		local val = self:GetValue()
		if val >= self:GetMin() then
			if val <= self:GetMax() then
				if !self.serverside and netstr != "" then
					net.Start( netstr )
						net.WriteFloat( val )
					net.SendToServer()
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

function DIntBox( tab, value, name, netstr, max, min )
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent != nil then
		tab.w = tab.w or tab.parent:GetWide() or 300
	else
		tab.w = tab.w or 300
	end
	tab.h = tab.h or ctr( 100 )
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color( 255, 255, 255 )

	local dintline = {}

	dintline.line = createD( "DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x )
	function dintline.line:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, tab.color )
		local text = {}
		text.text = lang_string( name ) .. ":"
		text.x = ctr( 10 )
		text.y = ph / 4
		text.font = "mat1text"
		text.color = Color( 255, 255, 255, 255 )
		text.br = 1
		text.ax = 0
		DrawText( text )
	end

	dintline.dnumberwang = createD( "DNumberWang", dintline.line, tab.w, tab.h / 2, tab.brx, tab.h / 2 )
	dintline.dnumberwang:SetMax(max or 100)
	dintline.dnumberwang:SetMin(min or 0)
	dintline.dnumberwang:SetDecimals(0)
	dintline.dnumberwang:SetValue( value )
	dintline.dnumberwang.serverside = false
	function dintline.dnumberwang:OnChange()
		local val = self:GetValue()
		if val >= self:GetMin() then
			if val <= self:GetMax() then
				if !self.serverside and netstr != "" then
					net.Start(netstr)
						net.WriteInt(val, 32)
					net.SendToServer()
				end
			else
				dintline.dnumberwang:SetText( self:GetMax() )
			end
		else
			dintline.dnumberwang:SetText( self:GetMin() )
		end
	end
	net.Receive( netstr, function( len )
		local f = net.ReadInt(32)
		if pa( dintline.dnumberwang ) then
			dintline.dnumberwang.serverside = true
			dintline.dnumberwang:SetValue( f )
			dintline.dnumberwang.serverside = false
		end
	end)

	if tab.parent != nil then
		tab.parent:AddItem( dintline.line )
	end
	return dintline.dnumberwang
end

function DStringBox( tab, str, name, netstr )
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent != nil then
		tab.w = tab.w or tab.parent:GetWide() or 300
	else
		tab.w = tab.w or 300
	end
	tab.h = tab.h or ctr( 100 )
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color( 255, 255, 255 )

	str = str or ""

	local dstringline = {}

	dstringline.line = createD( "DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x )
	function dstringline.line:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, tab.color )
		local text = {}
		text.text = lang_string( name ) .. ":"
		text.x = ctr( 10 )
		text.y = ph / 4
		text.font = "mat1text"
		text.color = Color( 255, 255, 255, 255 )
		text.br = 1
		text.ax = 0
		DrawText( text )

		if dmg != nil and dstringline.dtextentry != nil then
			local DMG = {}
			DMG.text = dmg:GetValue() * dstringline.dtextentry:GetValue() .. " " .. lang_string( "damage" )
			DMG.x = pw - ctr( 10 )
			DMG.y = ph / 2
			DMG.font = "mat1header"
			DMG.color = Color( 0, 0, 0, 255 )
			DMG.br = 1
			DMG.ax = 2
			DrawText( DMG )
		end
	end

	dstringline.dtextentry = createD( "DTextEntry", dstringline.line, tab.w, tab.h / 2, tab.brx, tab.h / 2 )
	dstringline.dtextentry:SetText( str )
	dstringline.dtextentry.serverside = false
	function dstringline.dtextentry:OnChange()
		net.Start( netstr )
			net.WriteString( self:GetText() )
		net.SendToServer()
	end
	net.Receive( netstr, function( len )
		local t = net.ReadString()
		if pa( dstringline.dtextentry ) then
			dstringline.dtextentry.serverside = true
			dstringline.dtextentry:SetText( t )
			dstringline.dtextentry.serverside = false
		end
	end)

	if tab.parent != nil then
		tab.parent:AddItem( dstringline.line )
	end
	return dstringline.dtextentry
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
		draw.RoundedBox( 0, 0, ph / 3, pw, ph / 3, Color( 0, 0, 0, 255 ) )
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
		head.y = ph / 2
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
