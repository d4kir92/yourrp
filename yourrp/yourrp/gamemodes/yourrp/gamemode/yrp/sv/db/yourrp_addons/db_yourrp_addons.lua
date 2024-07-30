--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
YRP = YRP or {}
local yrp_addons = {}
local HANDLER_YOURRP_ADDONS = {}
function RemFromHandler_YourRP_Addons(ply)
	table.RemoveByValue(HANDLER_YOURRP_ADDONS, ply)
end

function AddToHandler_YourRP_Addons(ply)
	if not table.HasValue(HANDLER_YOURRP_ADDONS, ply) then
		table.insert(HANDLER_YOURRP_ADDONS, ply)
	end
end

YRP:AddNetworkString("nws_yrp_connect_Settings_YourRP_Addons")
net.Receive(
	"nws_yrp_connect_Settings_YourRP_Addons",
	function(len, ply)
		if ply:CanAccess("bool_yourrp_addons") then
			AddToHandler_YourRP_Addons(ply)
			if table.Count(yrp_addons) == 0 then
				hook.Run("get_yourrp_addons")
			end

			net.Start("nws_yrp_connect_Settings_YourRP_Addons")
			net.WriteTable(yrp_addons)
			net.Send(ply)
		end
	end
)

YRP:AddNetworkString("nws_yrp_disconnect_Settings_YourRP_Addons")
net.Receive(
	"nws_yrp_disconnect_Settings_YourRP_Addons",
	function(len, ply)
		RemFromHandler_YourRP_Addons(ply)
	end
)

function YRP:AddYRPAddon(tab)
	YRP:msg("db", "Add YourRP Addon( " .. tostring(tab.name) .. " by " .. tostring(tab.author) .. " )")
	if type(tab) ~= "table" then
		YRP:msg("note", "[AddYRPAddon] invalid arguments!")

		return false
	end

	tab.name = tab.name or ""
	tab.author = tab.author or "NO AUTHOR"
	tab.description = tab.description or ""
	tab.icon = tab.icon or ""
	tab.workshopid = tab.workshopid or ""
	tab.discord = tab.discord or ""
	tab.settings = tab.settings or ""
	if strEmpty(tab.name) then
		YRP:msg("note", "[AddYRPAddon] [" .. tab.name .. "] name is wrong!")

		return false
	end

	if strEmpty(tab.author) then
		YRP:msg("note", "[AddYRPAddon] [" .. tab.name .. "] author is wrong!")

		return false
	end

	if not strEmpty(tab.workshopid) and not isnumber(tonumber(tab.workshopid)) then
		YRP:msg("note", "[AddYRPAddon] [" .. tab.name .. "] WorkshopID is wrong!")

		return false
	end

	if not strEmpty(tab.discord) and not string.find(tab.discord, "discord.gg", 1, true) then
		YRP:msg("note", "[AddYRPAddon] [" .. tab.name .. "] Discord link is wrong!")

		return false
	end

	if tab.name ~= "" then
		yrp_addons[tab.name .. " by " .. tab.author] = tab
		YRP:msg("db", "Added YourRP Addon( " .. tostring(tab.name) .. " by " .. tostring(tab.author) .. " )")

		return true
	end
end
