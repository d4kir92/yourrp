--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local setupdoors = false
function YRPSetupDoors()
	if setupdoors == false then
		setupdoors = true
		timer.Simple(
			2.5,
			function()
				YRPCheckMapDoors()
			end
		)
	end
end

local setupcoords = false
function YRPSetupCoords()
	if setupcoords == false then
		setupcoords = true
		timer.Simple(
			4,
			function()
				YRPGetMapCoords()
			end
		)
	end
end

hook.Add(
	"InitPostEntity",
	"yrp_InitPostEntity_doors_and_coords",
	function()
		YRPSetupDoors()
		YRPSetupCoords()
	end
)

timer.Simple(
	40,
	function()
		YRPSetupDoors()
		YRPSetupCoords()
	end
)
