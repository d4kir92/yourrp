--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

function YRPSetupDoors()
	timer.Simple(1.5, function()
		YRPCheckMapDoors()
	end)
end

function YRPSetupCoords()
	timer.Simple(4, function()
		YRPGetMapDoors()
	end)
end

hook.Add( "InitPostEntity", "yrp_InitPostEntity_doors_and_coords", function()
	--YRP.msg( "note", "InitPostEntity()" )

	YRPSetupDoors()
	YRPSetupCoords()
end)
