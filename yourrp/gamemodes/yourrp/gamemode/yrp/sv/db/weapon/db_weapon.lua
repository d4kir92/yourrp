--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_weapon_options"
SQL_ADD_COLUMN(DATABASE_NAME, "slots_primary", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "slots_secondary", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "slots_sidearm", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "slots_gadget", "INT DEFAULT 2")

if SQL_SELECT(DATABASE_NAME, "*", "uniqueID == '1'") == nil then
	YRP.msg("db", "Set Default Weapon Settings")
	SQL_INSERT_INTO_DEFAULTVALUES(DATABASE_NAME)
end

function YRPSetWeaponSettings()
	local tab = SQL_SELECT(DATABASE_NAME, "*", nil)
	if wk(tab) then
		tab = tab[1]
		
		SetGlobalInt( "yrp_max_slots_primary", 		tonumber(tab.slots_primary) )
		SetGlobalInt( "yrp_max_slots_secondary", 	tonumber(tab.slots_secondary) )
		SetGlobalInt( "yrp_max_slots_sidearm",		tonumber(tab.slots_sidearm) )
		SetGlobalInt( "yrp_max_slots_gadget", 		tonumber(tab.slots_gadget) )
	end
end
YRPSetWeaponSettings()

util.AddNetworkString("yrp_set_slot_amount")
net.Receive("yrp_set_slot_amount", function(len, ply)
	if ply:CanAccess("bool_weapons") then
		local ar = net.ReadString()
		local va = net.ReadString()

		SQL_UPDATE(DATABASE_NAME, {[ar] = va}, "uniqueID = '1'")

		YRPSetWeaponSettings()
	end
end)



local DATABASE_NAME2 = "yrp_weapon_slots"
SQL_ADD_COLUMN(DATABASE_NAME2, "classname", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME2, "slot_primary", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME2, "slot_secondary", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME2, "slot_sidearm", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME2, "slot_gadget", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME2, "slot_no", "INT DEFAULT 0")

function YRPGetSlotsOfSWEP(cn)
	local tab = SQL_SELECT(DATABASE_NAME2, "*", "classname = '" .. cn .. "'")
	if wk(tab) then
		tab = tab[1]
		tab.slot_primary = tobool(tab.slot_primary)
		tab.slot_secondary = tobool(tab.slot_secondary)
		tab.slot_sidearm = tobool(tab.slot_sidearm)
		tab.slot_gadget = tobool(tab.slot_gadget)
		tab.slot_no = tobool(tab.slot_no)
	else
		SQL_INSERT_INTO(DATABASE_NAME2, "'" .. "classname" .. "'", "'" .. cn .. "'")
		return YRPGetSlotsOfSWEP(cn)
	end

	return tab
end

util.AddNetworkString("yrp_weapon_menu")
net.Receive("yrp_weapon_menu", function(len, ply)
	if ply:CanAccess("bool_weapons") then
		local tab = SQL_SELECT(DATABASE_NAME, "*", nil)
		if wk(tab) then
			tab = tab[1]
		else
			tab = {}
		end

		local tab2 = SQL_SELECT(DATABASE_NAME2, "*", nil)
		local tab2s = {}
		if wk(tab2) then
			for i, v in pairs(tab2) do
				tab2s[v.classname] = v
			end
		end

		net.Start("yrp_weapon_menu")
			net.WriteTable(tab)
			net.WriteTable(tab2s)
		net.Send(ply)
	end
end)

util.AddNetworkString("yrp_set_slot_weapon")
net.Receive("yrp_set_slot_weapon", function(len, ply)
	if ply:CanAccess("bool_weapons") then
		local cn = net.ReadString()
		local ar = net.ReadString()
		local bo = net.ReadBool()
		
		local tab = SQL_SELECT(DATABASE_NAME2, "*", "classname = '" .. cn .. "'")
		if wk(tab) then
			SQL_UPDATE(DATABASE_NAME2, {[ar] = tonum(bo)}, "classname = '" .. cn .. "'")
		else
			SQL_INSERT_INTO(DATABASE_NAME2, "'" .. "classname" .. "', '" .. ar .. "'", "'" .. cn .. "', '" .. tonum(bo) .. "'")
		end
	end
end)
