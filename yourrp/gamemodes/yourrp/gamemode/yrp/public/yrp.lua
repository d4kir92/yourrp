--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

--[[ Here are the public functions (FOR DEVELOPERS) ]]

function GTS(id)
	return YRP.lang_string("LID_" .. id)
end

function GetTranslation(id)
	return GTS(id)
end

function IsLevelSystemEnabled()
	return GetGlobalDBool("bool_level_system", true)
end

if SERVER then
	function TelportToSpawnpoint(ply)
		teleportToSpawnpoint(ply)
	end

	function TeleportToJailpoint(ply, time, police)
		teleportToJailpoint(ply, tim, police)
	end

	function TeleportToReleasepoint(ply)
		teleportToReleasepoint(ply)
	end
end