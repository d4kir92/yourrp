--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local _settings = {}
_settings.name = "Settings"

function drawSettingsApp( pw, ph )
  draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 200 ) )
end

_settings.paint = drawSettingsApp

addApp( _settings )


--das
