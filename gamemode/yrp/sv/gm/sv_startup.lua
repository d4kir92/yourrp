--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

function YRPSetupDoors()
	timer.Simple(3, function()
		check_map_doors()
	end)
end

function YRPSetupCoords()
	timer.Simple(4, function()
		get_map_coords()
	end)
end

hook.Add("InitPostEntity", "yrp_InitPostEntity_doors_and_coords", function()
	YRP.msg("note", "InitPostEntity()")

	YRPSetupDoors()
	YRPSetupCoords()
end)
