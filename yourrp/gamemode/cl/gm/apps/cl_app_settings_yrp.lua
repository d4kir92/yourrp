--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local APP = {}
APP.PrintName = "YourRP Settings"
APP.LangName = "settings"
APP.ClassName = "yrp_settings"

APP.Icon = Material( "yrp/yrp_icon.png" )

function APP:AppIcon( pw, ph )
  surface.SetDrawColor( 255, 255, 255, 255 )
  surface.SetMaterial( self.Icon	)
  surface.DrawTexturedRect( 0, 0, pw, ph )

  --draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 255 ) )
end

function APP:OpenApp( display, x, y, w, h )
  openSettings()
  closeSP()
end

addApp( APP )
