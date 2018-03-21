--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local APP = {}

function APP:Init()

end

function APP:Paint( w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 0, 0, 255 ) )
end

vgui.Register( "YRPAPP", APP, "DButton" )

function appSize()
  return 100
end

local yrp_apps = {}

function addApp( derma )
  table.insert( yrp_apps, derma )
end

function getAllApps()
  return yrp_apps
end
