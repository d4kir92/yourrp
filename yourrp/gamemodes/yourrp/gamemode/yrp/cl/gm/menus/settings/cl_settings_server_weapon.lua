--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local DBTab = {}

local function YRPWeaponSlotNum(parent, x, y, lid, smin, smax, sart, sval)
	local slider = createD("DNumSlider", parent, 400, 50, x, y)
	slider:SetText(YRP.lang_string(lid))
	slider:SetDecimals(0)
	slider:SetMinMax( smin, smax )
	slider:SetValue( sval )
	function slider:OnValueChanged( value )
		net.Start("yrp_set_slot_amount")
			net.WriteString(sart)
			net.WriteString(math.Round(value, self:GetDecimals()))
		net.SendToServer()
	end
end

local function YRPWeaponSlotCB(parent, x, y, classname, art, sval)
	local cb = createD("DCheckBox", parent, 40, 40, x, y)
	cb:SetChecked(sval)
	function cb:OnChange( bVal )
		net.Start("yrp_set_slot_weapon")
			net.WriteString(classname)
			net.WriteString(art)
			net.WriteBool(bVal)
		net.SendToServer()
	end
end

net.Receive("yrp_weapon_menu", function(len)
	local lply = LocalPlayer()

	local PARENT = GetSettingsSite()

	-- SLOT Settings
	DBTab = net.ReadTable()

	-- parent, x, y, lid, smin, smax, sart, sval
	YRPWeaponSlotNum(PARENT, 10, 10, 	"LID_primaryslots", 	1, 5, "slots_primary", 		DBTab.slots_primary)
	YRPWeaponSlotNum(PARENT, 10, 70, 	"LID_secondaryslots", 	1, 5, "slots_secondary", 	DBTab.slots_secondary)
	YRPWeaponSlotNum(PARENT, 10, 130, 	"LID_sidearmslots", 	1, 5, "slots_sidearms", 	DBTab.slots_sidearms)
	YRPWeaponSlotNum(PARENT, 10, 190, 	"LID_gadgetslots", 		1, 5, "slots_gadgets", 		DBTab.slots_gadgets)



	-- Weapon Settings
	DBTab2 = net.ReadTable()

	local allsweps = GetSWEPsList()
	local cl_sweps = {}
	local count = 0
	for k, v in pairs(allsweps) do
		count = count + 1
		cl_sweps[count] = {}
		cl_sweps[count].WorldModel = v.WorldModel or ""
		cl_sweps[count].ClassName = v.ClassName or "NO CLASSNAME"
		cl_sweps[count].PrintName = v.PrintName or v.ClassName or "NO PRINTNAME"
	end

	local header = createD("DPanel", PARENT, PARENT:GetWide() - 10 - 500 - 10 - 10, 50, 10 + 400 + 10, 10)
	function header:Paint(pw, ph)
		local color = Color(80, 80, 80)
		draw.RoundedBox(3, 0, 0, pw, ph, color)
		draw.SimpleText(YRP.lang_string("LID_name"), "Y_16_700", ph / 2, ph / 2, TextColor(color), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		
		draw.SimpleText(YRP.lang_string("LID_primary"), 	"Y_16_700", pw - 60 - 120 * 3 + 8, ph / 2, TextColor(color), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(YRP.lang_string("LID_secondary"), 	"Y_16_700", pw - 60 - 120 * 2 + 8, ph / 2, TextColor(color), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(YRP.lang_string("LID_sidearm"), 	"Y_16_700", pw - 60 - 120 * 1 + 8, ph / 2, TextColor(color), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(YRP.lang_string("LID_gadget"), 		"Y_16_700", pw - 60 - 120 * 0 + 8, ph / 2, TextColor(color), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local list = createD("DPanelList", PARENT, PARENT:GetWide() - 10 - 500 - 10 - 10, PARENT:GetTall() - 10 - 10, 10 + 400 + 10, 10 + 50)
	list:EnableVerticalScrollbar()

	for i, swep in SortedPairsByMemberValue(cl_sweps, "ClassName") do
		local weapon = createD("DLabel", nil, list:GetWide(), 40, 0, 0)
		weapon:SetText("")
		function weapon:Paint(pw, ph)
			local color = Color(40, 40, 40)
			draw.RoundedBox(3, 0, 0, pw, ph, color)
			draw.SimpleText(swep.PrintName, "Y_16_700", ph / 2, ph / 2, TextColor(color), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

		if DBTab2[swep.ClassName] == nil then
			DBTab2[swep.ClassName] = {}
			DBTab2[swep.ClassName].slot_primary = 0
			DBTab2[swep.ClassName].slot_secondary = 0
			DBTab2[swep.ClassName].slot_sidearm = 0
			DBTab2[swep.ClassName].slot_gadget = 0
		end

		-- parent, x, y, classname, sval
		YRPWeaponSlotCB(weapon, weapon:GetWide() - 60 - 120 * 3 - 12, 0, swep.ClassName, "slot_primary", 	DBTab2[swep.ClassName].slot_primary)
		YRPWeaponSlotCB(weapon, weapon:GetWide() - 60 - 120 * 2 - 12, 0, swep.ClassName, "slot_secondary", 	DBTab2[swep.ClassName].slot_secondary)
		YRPWeaponSlotCB(weapon, weapon:GetWide() - 60 - 120 * 1 - 12, 0, swep.ClassName, "slot_sidearm",	DBTab2[swep.ClassName].slot_sidearm)
		YRPWeaponSlotCB(weapon, weapon:GetWide() - 60 - 120 * 0 - 12, 0, swep.ClassName, "slot_gadget", 	DBTab2[swep.ClassName].slot_gadget)

		list:AddItem(weapon)
	end
end)

function OpenSettingsWeaponSystem()
	net.Start("yrp_weapon_menu")
	net.SendToServer()
end
