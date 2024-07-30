--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
--[[ Here are the public functions (FOR DEVELOPERS) ]]
function GTS(id)
	return YRP:trans("LID_" .. id)
end

function GetTranslation(id)
	return GTS(id)
end

function IsLevelSystemEnabled()
	return GetGlobalYRPBool("bool_level_system", true)
end

if SERVER then
	function TeleportToTheSpawnpoint(ply)
		YRPTeleportToSpawnpoint(ply, "public")
	end

	function TeleportToJailpoint(ply, time, police)
		teleportToJailpoint(ply, tim, police)
	end

	function TeleportToReleasepoint(ply)
		teleportToReleasepoint(ply)
	end
end
