--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

--[[ Here are the public functions (FOR DEVELOPERS) ]]

function GTS(id)
	return YRP.lang_string("LID_" .. id)
end

function GetTranslation(id)
	return GTS(id)
end

function IsLevelSystemEnabled()
	return GetGlobalDBool("bool_level_system", false)
end

if SERVER then
	function TelportToSpawnpoint(ply)
		teleportToSpawnpoint(ply)
	end

	function TeleportToJailpoint(ply, time)
		teleportToJailpoint(ply, tim)
	end

	function TeleportToReleasepoint(ply)
		teleportToReleasepoint(ply)
	end
end