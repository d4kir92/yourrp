--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function createD( derma, parent, w, h, x, y )
  local tmpD = vgui.Create( derma, parent )
  if w != nil and h != nil then
    tmpD:SetSize( w, h )
  else
    printGM( "note", w .. " " .. h )
  end
  if x != nil and y != nil then
    tmpD:SetPos( x, y )
  else
    printGM( "note", x .. " " .. y )
  end
  return tmpD
end

g_yrp.colors = {}
g_yrp.colors.dbackground = Color( 0, 0, 0, 254 )
g_yrp.colors.dprimary = Color( 40, 40, 40, 255 )
g_yrp.colors.dprimaryBG = Color( 20, 20, 20, 255 )
g_yrp.colors.dsecondary = Color( 0, 33, 113, 255 )
g_yrp.colors.dsecondaryH = Color( 0, 33+50, 113+50, 255 )

function getMDMode()
  if tonumber( cl_db["mdpm"] ) == 0 then
    return "dark"
  elseif tonumber( cl_db["mdpm"] ) == 1 then
    return "light"
  end
  return -1
end

function colorH( colTab )
  local tmp = colTab
  local col = {}
  local def = 40
  for k, v in pairs( tmp ) do
    if tostring( k ) == "a" then
      col[k] = v
    else
  		col[k] = v + def
  		if col[k] > 255 then
  			col[k] = 255
  		end
    end
	end
	return Color( col.r, col.g, col.b, col.a )
end

function colorBG( colTab )
  local tmp = colTab
  local col = {}
  local def = 40
  for k, v in pairs( tmp ) do
    if tostring( k ) == "a" then
      col[k] = v
    else
  		col[k] = v - def
  		if col[k] < 0 then
  			col[k] = 0
  		end
    end
	end
	return Color( col.r, col.g, col.b, col.a )
end

function colorToMode( colTab )
  local tmp = colTab
  local col = {}
  local def = 40
  for k, v in pairs( tmp ) do
    if tostring( k ) == "a" then
      col[k] = v
    elseif getMDMode() == "light" then
  		col[k] = v + def
  		if col[k] > 255 then
  			col[k] = 255
  		end
    elseif getMDMode() == "dark" then
      col[k] = v - def
  		if col[k] < 0 then
  			col[k] = 0
  		end
    end
	end
	return Color( col.r, col.g, col.b, col.a )
end

function addMDColor( name, _color )
  g_yrp.colors[name] = _color
end

function getMDPCol()
	return Color( cl_db["mdpr"], cl_db["mdpg"], cl_db["mdpb"], cl_db["mdpa"] )
end

function getMDSCol()
	return Color( cl_db["mdsr"], cl_db["mdsg"], cl_db["mdsb"], cl_db["mdsa"] )
end

function getMDPColor()
	local tmp = getMDPCol()
  return colorToMode( tmp )
end

function getMDSColor()
	local tmp = getMDSCol()
  return colorToMode( tmp )
end

function addColor( string, r, g, b, a )
	g_yrp.colors[string] = {}
	g_yrp.colors[string].r = r
	g_yrp.colors[string].g = g
	g_yrp.colors[string].b = b
	g_yrp.colors[string].a = a
end

addColor( "epicBlue", 23, 113, 240, 100 )
addColor( "darkBG", 0, 0, 0, 200 )
addColor( "epicOrange", 255, 140, 0, 200 )

function GetFontSizes()
	local _fs = {}
	_fs[1] = 6
	_fs[2] = 8
	_fs[3] = 9
	_fs[4] = 10
	_fs[5] = 11
	_fs[6] = 12
	_fs[7] = 14
	_fs[8] = 18
	_fs[9] = 24
	_fs[10] = 30
	_fs[11] = 36
	_fs[12] = 48
	_fs[13] = 60
	_fs[14] = 72
	_fs[15] = 96
	return _fs
end

function drawRBox( r, x, y, w, h, col )
	draw.RoundedBox( ctr(r), ctr(x), ctr(y), ctr(w), ctr(h), col )
end

function drawRBoxBr( r, x, y, w, h, col, br )
	draw.RoundedBox( ctr(r), ctr(x-br), ctr(y-br), ctr(w+2*br-1), ctr(2*br), col )
  draw.RoundedBox( ctr(r), ctr(x-br), ctr(y+h-br), ctr(w+2*br-1), ctr(2*br), col )
  draw.RoundedBox( ctr(r), ctr(x-br), ctr(y), ctr(2*br), ctr(h), col )
  draw.RoundedBox( ctr(r), ctr(x+w-br), ctr(y), ctr(2*br), ctr(h), col )
end

function drawRBoxCr( x, y, size, col )
	draw.RoundedBox( ctr(size/2), ctr(x), ctr(y), ctr(size), ctr(size), col )
end

function drawText( text, font, x, y, col, ax, ay )
	draw.SimpleTextOutlined( text, font, ctr(x), ctr(y), col, ax, ay, 0.5, Color( 0, 0, 0 ) )
end

function createVGUI( art, parent, w, h, x, y )
  local tmp = vgui.Create( art, parent, nil )
  if w != nil and h != nil then
    tmp:SetSize( ctr(w), ctr(h) )
  end
  if x != nil and y != nil then
    tmp:SetPos( ctr(x), ctr(y) )
  end
  return tmp
end

function paintMDBackground( derma, pw, ph )
	if derma:IsHovered() then
		draw.RoundedBox( 0, 0, 0, pw, ph, g_yrp.colors.dsecondaryH )
	else
		draw.RoundedBox( 0, 0, 0, pw, ph, g_yrp.colors.dsecondary )
	end
end

function createMDMenu( parent, w, h, x, y )
	local tmp = createD( "DFrame", parent, w, h, x, y )
  tmp:SetTitle( "" )
  tmp.sites = {}
  tmp.cat = {}
  function tmp:AddCategory( cat )
    local tmpNr = #tmp.cat+1
    self.cat[tmpNr] = cat
    self.sites[cat] = {}
  end
  function tmp:AddSite( hook, site, cat, icon )
    local material = Material( icon )
    local tmpNr = #tmp.sites[cat] + 1
    self.sites[cat][tmpNr] = {}
    self.sites[cat][tmpNr].hook = hook
    self.sites[cat][tmpNr].site = site
    self.sites[cat][tmpNr].material = material
  end

	tmp.sitepanel = createD( "DPanel", tmp, (ScrH()*5)/4, ScrH() - ctr( 100 ), ScrW2() - ( (ScrH()*5)/4 )/2, ctr( 100 ) )
	function tmp.sitepanel:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, g_yrp.colors.dprimaryBG )
	end

	function tmp:SwitchToSite( _hook )
	  if self.site != nil then
	    self.site:Remove()
	  end
	  hook.Call( _hook )
	end

	function tmp:openMenu()
		self.menu = createD( "DPanel", self, ScrW(), ScrH(), 0, 0 )
		function self.menu:Paint( pw, ph )
			draw.RoundedBox( 0, 0, 0, pw, ph, g_yrp.colors.dbackground )
			draw.RoundedBox( 0, 0, 0, ctr( 500 ), ph, g_yrp.colors.dprimary )

			surface.SetDrawColor( 255, 255, 255, 255 )
	  	surface.SetMaterial( g_yrp.materials[g_yrp.design.mode].burger	)
	  	surface.DrawTexturedRect( ctr( 15+10 ), ctr( 15+10 ), ctr( 50 ), ctr( 50 ) )

			draw.SimpleTextOutlined( string.upper( lang_string( "menu" ) ), "HudBars", ctr( 100 ), ctr( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

			local x, y = gui.MousePos()
			if x > ctr( 500 ) then
				self:Remove()
			end
		end

		local posY = 100
		for k, v in pairs( self.cat ) do
			local tmpCat = createD("DPanel", self.menu, ctr( 480 ), ctr( 50 ), ctr( 10 ), ctr( posY ) )
			function tmpCat:Paint( pw, ph )
				draw.SimpleTextOutlined( string.upper( v ), "HudBars", ctr( 10 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
			end
			posY = posY + 50 + 10
			if self.sites[v] != nil then
				for l, w in pairs( self.sites[v] ) do
					local tmp2 = createD("DButton", self.menu, ctr( 480 ), ctr( 80 ), ctr( 10 ), ctr( posY ) )
					tmp2:SetText( "" )
					tmp2.hook = string.lower( w.hook )
					tmp2.site = string.upper( w.site )
					function tmp2:Paint( pw, ph )
						if tmp.cursite == self.site then
							draw.RoundedBox( 0, 0, 0, pw, ph, g_yrp.colors.dsecondaryH )
						else
							paintMDBackground( self, pw, ph )
						end

						if w.material != nil then
							surface.SetDrawColor( 255, 255, 255, 255 )
							surface.SetMaterial( w.material	)
							surface.DrawTexturedRect( ctr( 15 ), ctr( 15 ), ctr( 50 ), ctr( 50 ) )
						end

						draw.SimpleTextOutlined( string.upper( w.site ), "HudBars", ctr( 80 + 10 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
					end
					function tmp2:DoClick()
						tmp.cursite = self.site
						tmp:SwitchToSite( self.hook )
					end

					posY = posY + 80 + 10
				end
			end
		end
	end
	return tmp
end

function createMDSwitch( parent, w, h, x, y, opt1, opt2, _hook )
	local tmp = createD( "DButton", parent, w, h, x, y )
	tmp.opt1 = opt1
	tmp.opt2 = opt2
	if tonumber( cl_db["mdpm"] ) == 0 then
		tmp.value = "dark"
	elseif tonumber( cl_db["mdpm"] ) == 1 then
		tmp.value = "light"
	end
  tmp:SetText( "" )
	function tmp:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, g_yrp.colors.dsecondary )
		if tmp.value == opt1 then
			draw.RoundedBox( 0, 0, 0, pw/2, ph, g_yrp.colors.dsecondaryH )
		elseif tmp.value == opt2 then
			draw.RoundedBox( 0, pw/2, 0, pw/2, ph, g_yrp.colors.dsecondaryH )
		end
		draw.SimpleTextOutlined( lang_string( "dark" ), "HudBars", 1*(pw/4), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
		draw.SimpleTextOutlined( lang_string( "light" ), "HudBars", 3*(pw/4), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
	end
	function tmp:DoClick()
		if self.value == self.opt1 then
			self.value = self.opt2
		elseif self.value == self.opt2 then
			self.value = self.opt1
		end
		g_yrp.design.mode = tostring( self.value )

		if tostring( self.value ) == "dark" then
			dbUpdateHUD( "mdpm", 0 )
		elseif tostring( self.value ) == "light" then
			dbUpdateHUD( "mdpm", 1 )
		end

		addMDColor( "dprimary", getMDPColor() )
		addMDColor( "dprimaryBG", colorBG( getMDPColor() ) )

		addMDColor( "dsecondary", getMDSColor() )
		addMDColor( "dsecondaryH", colorH( getMDSColor() ) )

	end
	return tmp
end

function addPColorField( parent, col, x, y )
	local tmp = createD( "DButton", parent, ctr( 50 ), ctr( 50 ), x, y )
	tmp.color = col
	tmp:SetText( "" )
	function tmp:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, self.color )
		if self:IsHovered() then
			draw.SimpleTextOutlined( "X", "DermaDefault", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
		end
	end
	function tmp:DoClick()
		dbUpdateHUD( "mdpr", self.color.r )
		dbUpdateHUD( "mdpg", self.color.g )
		dbUpdateHUD( "mdpb", self.color.b )
		addMDColor( "dprimary", getMDPColor() )
		addMDColor( "dprimaryBG", colorBG( getMDPColor() ) )
	end
	return tmp
end

function addSColorField( parent, col, x, y )
	local tmp = createD( "DButton", parent, ctr( 50 ), ctr( 50 ), x, y )
	tmp.color = col
	tmp:SetText( "" )
	function tmp:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, self.color )
		if self:IsHovered() then
			draw.SimpleTextOutlined( "X", "DermaDefault", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
		end
	end
	function tmp:DoClick()
		dbUpdateHUD( "mdsr", self.color.r )
		dbUpdateHUD( "mdsg", self.color.g )
		dbUpdateHUD( "mdsb", self.color.b )
		addMDColor( "dsecondary", getMDSColor() )
		addMDColor( "dsecondaryH", colorH( getMDSColor() ) )
	end
	return tmp
end

function anchorW( num )
  if num == 0 then
    return 0
  elseif num == 1 then
    return ScrW2()
  elseif num == 2 then
    return ScrW()
  end
end

function anchorH( num )
  if num == 0 then
    return 0
  elseif num == 1 then
    return ScrH2()
  elseif num == 2 then
    return ScrH()
  end
end
