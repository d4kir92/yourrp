--Copyright (C) 2017-2018 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local batterylife = Material("icon16/phone.png")

function hudBL(ply, color)
	local _bl = system.BatteryPower()
	if _bl < 100 then
		local _bltext = math.Round((math.Round(_bl, 0) / 100) * 100, 0) .. "%"

		_bl = _bl/100
		color = Color(255-255*(_bl), 255*(_bl), 0, 200)

		drawHUDElement("bl", _bl*100, 100, _bltext, batterylife, color)
	end
end

function hudBLBR()
	local _bl = system.BatteryPower()
	if _bl < 100 then
		drawHUDElementBr("bl")
	end
end
