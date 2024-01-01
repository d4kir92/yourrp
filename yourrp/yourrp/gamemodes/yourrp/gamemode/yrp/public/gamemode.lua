--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
--[[ Here are the public functions (FOR DEVELOPERS) ]]
--[[ Gamemode functions ]]
--
if SERVER then
	function GM:IsAutomaticServerReloadingEnabled()
		return YRPIsAutomaticServerReloadingEnabled()
	end
end

function IsInventorySystemEnabled()
	return GetGlobalYRPBool("bool_inventory_system", false)
end