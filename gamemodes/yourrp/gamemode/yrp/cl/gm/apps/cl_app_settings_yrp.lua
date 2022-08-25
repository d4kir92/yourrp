--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

local APP = {}
APP.PrintName = "YourRP Settings"
APP.LangName = "settings"
APP.ClassName = "yrp_settings"

APP.Icon = Material( "yrp/yrp_icon.png" )

function APP:AppIcon(pw, ph)
	surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
	surface.SetMaterial(self.Icon	)
	surface.DrawTexturedRect(0, 0, pw, ph)

	--draw.RoundedBox(0, 0, 0, pw, ph, YRPColBlue() )
end

function APP:OpenApp( display, x, y, w, h)
	F8OpenSettings()
	closeSP()
end

addApp(APP)
