--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

yrp.colors.dbackground = Color( 0, 0, 0, 254 )
yrp.colors.dprimary = Color( 40, 40, 40, 255 )
yrp.colors.dprimaryBG = Color( 20, 20, 20, 255 )
yrp.colors.dsecondary = Color( 0, 33, 113, 255 )
yrp.colors.dsecondaryH = Color( 0, 33+50, 113+50, 255 )

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
  yrp.colors[name] = _color
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
