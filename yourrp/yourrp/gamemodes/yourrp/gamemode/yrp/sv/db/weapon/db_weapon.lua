--Copyright (C) 2017-2025 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
local DATABASE_NAME = "yrp_weapon_options"
function YRPSetWeaponSettings()
	local tab = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
	if IsNotNilAndNotFalse(tab) then
		tab = tab[1]
		SetGlobalYRPInt("yrp_max_slots_primary", tonumber(tab.slots_primary))
		SetGlobalYRPInt("yrp_max_slots_secondary", tonumber(tab.slots_secondary))
		SetGlobalYRPInt("yrp_max_slots_sidearm", tonumber(tab.slots_sidearm))
		SetGlobalYRPInt("yrp_max_slots_gadget", tonumber(tab.slots_gadget))
	end
end

hook.Add(
	"YRP_SQLDBREADY_GAMEPLAY",
	"yrp_weapon_options",
	function()
		YRP_SQL_ADD_COLUMN(DATABASE_NAME, "slots_primary", "INT DEFAULT 1")
		YRP_SQL_ADD_COLUMN(DATABASE_NAME, "slots_secondary", "INT DEFAULT 1")
		YRP_SQL_ADD_COLUMN(DATABASE_NAME, "slots_sidearm", "INT DEFAULT 1")
		YRP_SQL_ADD_COLUMN(DATABASE_NAME, "slots_gadget", "INT DEFAULT 2")
		timer.Simple(
			0,
			function()
				if YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'") == nil then
					YRP:msg("db", "Set Default Weapon Settings")
					YRP_SQL_INSERT_INTO_DEFAULTVALUES(DATABASE_NAME)
				end

				YRPSetWeaponSettings()
			end
		)
	end
)

YRP:AddNetworkString("nws_yrp_set_slot_amount")
net.Receive(
	"nws_yrp_set_slot_amount",
	function(len, ply)
		if ply:CanAccess("bool_weapons") then
			local ar = net.ReadString()
			local va = net.ReadString()
			YRP_SQL_UPDATE(
				DATABASE_NAME,
				{
					[ar] = va
				}, "uniqueID = '1'"
			)

			YRPSetWeaponSettings()
		end
	end
)

local DATABASE_NAME2 = "yrp_weapon_slots"
hook.Add(
	"YRP_SQLDBREADY_GAMEPLAY",
	"yrp_weapon_slots",
	function()
		YRP_SQL_ADD_COLUMN(DATABASE_NAME2, "classname", "TEXT DEFAULT ''")
		YRP_SQL_ADD_COLUMN(DATABASE_NAME2, "slot_primary", "INT DEFAULT 0")
		YRP_SQL_ADD_COLUMN(DATABASE_NAME2, "slot_secondary", "INT DEFAULT 0")
		YRP_SQL_ADD_COLUMN(DATABASE_NAME2, "slot_sidearm", "INT DEFAULT 0")
		YRP_SQL_ADD_COLUMN(DATABASE_NAME2, "slot_gadget", "INT DEFAULT 0")
		YRP_SQL_ADD_COLUMN(DATABASE_NAME2, "slot_no", "INT DEFAULT 0")
	end
)

function YRPGetSlotsOfSWEP(cn)
	local tab = YRP_SQL_SELECT(DATABASE_NAME2, "*", "classname = '" .. cn .. "'")
	if IsNotNilAndNotFalse(tab) then
		tab = tab[1]
		tab.slot_primary = tobool(tab.slot_primary)
		tab.slot_secondary = tobool(tab.slot_secondary)
		tab.slot_sidearm = tobool(tab.slot_sidearm)
		tab.slot_gadget = tobool(tab.slot_gadget)
		tab.slot_no = tobool(tab.slot_no)
	else
		YRP_SQL_INSERT_INTO(DATABASE_NAME2, "classname", "" .. YRP_SQL_STR_IN(cn) .. "")

		return YRPGetSlotsOfSWEP(cn)
	end

	return tab
end

YRP:AddNetworkString("nws_yrp_weapon_menu")
YRP:AddNetworkString("nws_yrp_weapon_menu_weapon")
net.Receive(
	"nws_yrp_weapon_menu",
	function(len, ply)
		if ply:CanAccess("bool_weapons") then
			local tab = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
			if IsNotNilAndNotFalse(tab) then
				tab = tab[1]
			else
				tab = {}
			end

			local tab2 = YRP_SQL_SELECT(DATABASE_NAME2, "*", nil)
			local tab2s = {}
			if IsNotNilAndNotFalse(tab2) then
				for i, v in pairs(tab2) do
					tab2s[v.classname] = v
				end
			end

			net.Start("nws_yrp_weapon_menu")
			net.WriteTable(tab)
			net.Send(ply)
			for i, v in pairs(tab2s) do
				net.Start("nws_yrp_weapon_menu_weapon")
				net.WriteTable(v)
				net.Send(ply)
			end
		end
	end
)

YRP:AddNetworkString("nws_yrp_set_slot_weapon")
net.Receive(
	"nws_yrp_set_slot_weapon",
	function(len, ply)
		if ply:CanAccess("bool_weapons") then
			local cn = net.ReadString()
			local ar = net.ReadString()
			local bo = net.ReadBool()
			local tab = YRP_SQL_SELECT(DATABASE_NAME2, "*", "classname = '" .. cn .. "'")
			if IsNotNilAndNotFalse(tab) then
				YRP_SQL_UPDATE(
					DATABASE_NAME2,
					{
						[ar] = tonum(bo)
					}, "classname = " .. YRP_SQL_STR_IN(cn) .. ""
				)
			else
				if ar == nil then
					YRP:msg("db", "Missing ART in nws_yrp_set_slot_weapon")

					return
				end

				if cn == nil then
					YRP:msg("db", "Missing ClassName in nws_yrp_set_slot_weapon")

					return
				end

				YRP_SQL_INSERT_INTO(DATABASE_NAME2, "classname, " .. ar .. "", "" .. YRP_SQL_STR_IN(cn) .. ", '" .. tonum(bo) .. "'")
			end
		end
	end
)
