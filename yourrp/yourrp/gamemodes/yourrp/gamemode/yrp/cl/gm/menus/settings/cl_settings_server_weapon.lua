--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local DBTab = {}
local DBTab2 = {}
local cbs = {}
local function YRPWeaponSlotNum(parent, x, y, lid, smin, smax, sart, sval)
	local slider = YRPCreateD("DNumSlider", parent, 400, 50, x, y)
	slider:SetText(YRP.trans(lid))
	slider:SetDecimals(0)
	slider:SetMinMax(smin, smax)
	slider:SetValue(sval)
	function slider:OnValueChanged(value)
		net.Start("nws_yrp_set_slot_amount")
		net.WriteString(sart)
		net.WriteString(math.floor(value, self:GetDecimals()))
		net.SendToServer()
	end

	return slider
end

local function YRPWeaponSlotCB(parent, x, y, cname, art, sval)
	local cb = YRPCreateD("DCheckBox", parent, 30, 30, x + 5, y + 5)
	cb:SetChecked(sval)
	function cb:OnChange(bVal)
		if art == "slot_no" and bVal then
			if cbs[cname].pr:GetChecked() == true then
				cbs[cname].pr:SetChecked(false)
				cbs[cname].pr:OnChange(false)
			end

			if cbs[cname].se:GetChecked() == true then
				cbs[cname].se:SetChecked(false)
				cbs[cname].se:OnChange(false)
			end

			if cbs[cname].si:GetChecked() == true then
				cbs[cname].si:SetChecked(false)
				cbs[cname].si:OnChange(false)
			end

			if cbs[cname].ga:GetChecked() == true then
				cbs[cname].ga:SetChecked(false)
				cbs[cname].ga:OnChange(false)
			end
		elseif bVal then
			if cbs[cname].no:GetChecked() == true then
				cbs[cname].no:SetChecked(false)
				cbs[cname].no:OnChange(false)
			end
		end

		DBTab2[cname][art] = tonum(bVal)
		net.Start("nws_yrp_set_slot_weapon")
		net.WriteString(cname)
		net.WriteString(art)
		net.WriteBool(bVal)
		net.SendToServer()
	end

	return cb
end

local function YRPWeaponNoEntry(cname)
	if DBTab2[cname] and DBTab2[cname].slot_primary == 0 and DBTab2[cname].slot_secondary == 0 and DBTab2[cname].slot_sidearm == 0 and DBTab2[cname].slot_gadget == 0 and DBTab2[cname].slot_no == 0 then return true end

	return false
end

local cou = 0
net.Receive(
	"nws_yrp_weapon_menu_weapon",
	function(len)
		local weapon = net.ReadTable()
		DBTab2[weapon.classname] = weapon
		cou = cou + 1
		local c = cou
		timer.Simple(
			0.1,
			function()
				if c == cou then
					YRPWeaponUpdateList()
				end
			end
		)
	end
)

net.Receive(
	"nws_yrp_weapon_menu",
	function(len)
		local spacer = 80
		local PARENT = GetSettingsSite()
		-- SLOT Settings
		DBTab = net.ReadTable()
		-- parent, x, y, lid, smin, smax, sart, sval
		YRPWeaponSlotNum(PARENT, 10, 10, "LID_primaryslots", 1, 5, "slots_primary", DBTab.slots_primary)
		YRPWeaponSlotNum(PARENT, 10, 70, "LID_secondaryslots", 1, 5, "slots_secondary", DBTab.slots_secondary)
		YRPWeaponSlotNum(PARENT, 10, 130, "LID_sidearmslots", 1, 5, "slots_sidearm", DBTab.slots_sidearm)
		YRPWeaponSlotNum(PARENT, 10, 190, "LID_gadgetslots", 1, 5, "slots_gadget", DBTab.slots_gadget)
		local allsweps = YRPGetSWEPsList()
		local cl_sweps = {}
		local count = 0
		for k, v in pairs(allsweps) do
			count = count + 1
			cl_sweps[count] = {}
			cl_sweps[count].WorldModel = v.WorldModel or ""
			cl_sweps[count].ClassName = v.ClassName or "NO CLASSNAME"
			cl_sweps[count].PrintName = v.PrintName or v.ClassName or "NO PRINTNAME"
		end

		local sw = 640
		local searc = YRPCreateD("DTextEntry", PARENT, sw, 30, 400 + 10, 10)
		searc:SetPlaceholderText("Enter Weapon Name (Example: food, drink, physgun, ...)")
		function searc:OnTextChanged()
			YRPWeaponUpdateList()
		end

		local header = YRPCreateD("DPanel", PARENT, sw, 30, 400 + 10, 10 + 30)
		function header:Paint(pw, ph)
			local color = Color(80, 80, 80)
			draw.RoundedBox(3, 0, 0, pw, ph, color)
			draw.SimpleText(YRP.trans("LID_name"), "Y_16_700", ph / 2, ph / 2, YRPTextColor(color), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(YRP.trans("LID_primary"), "Y_16_700", pw - 60 - spacer * 4 + 8, ph / 2, YRPTextColor(color), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(YRP.trans("LID_secondary"), "Y_16_700", pw - 60 - spacer * 3 + 8, ph / 2, YRPTextColor(color), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(YRP.trans("LID_sidearm"), "Y_16_700", pw - 60 - spacer * 2 + 8, ph / 2, YRPTextColor(color), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(YRP.trans("LID_gadget"), "Y_16_700", pw - 60 - spacer * 1 + 8, ph / 2, YRPTextColor(color), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(YRP.trans("LID_noslot"), "Y_16_700", pw - 60 - spacer * 0 + 8, ph / 2, YRPTextColor(color), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local lis = YRPCreateD("DPanelList", PARENT, sw, PARENT:GetTall() - 10 - 30 - 30 - 10, 400 + 10, 10 + 30 + 30)
		lis:EnableVerticalScrollbar()
		lis:SetSpacing(2)
		function lis:Paint(pw, ph)
			local color = Color(120, 120, 120)
			draw.RoundedBox(0, 0, 0, pw, ph, color)
		end

		function YRPWeaponUpdateList()
			lis:Clear()
			for i, swep in SortedPairsByMemberValue(cl_sweps, "PrintName") do
				local searcstr = string.lower(searc:GetText())
				searcstr = string.Replace(searcstr, "[", "")
				searcstr = string.Replace(searcstr, "]", "")
				searcstr = string.Replace(searcstr, "%", "")
				if string.find(string.lower(swep.PrintName), searcstr, 1, true) or string.find(string.lower(swep.ClassName), searcstr, 1, true) then
					local weapon = YRPCreateD("DLabel", nil, lis:GetWide(), 40, 0, 0)
					weapon:SetText("")
					function weapon:Paint(pw, ph)
						local color = Color(40, 160, 40)
						if DBTab2[swep.ClassName].slot_no == 1 then
							color = Color(20, 20, 20)
						end

						if YRPWeaponNoEntry(swep.ClassName) then
							color = Color(160, 0, 0)
						end

						draw.RoundedBox(3, 0, 0, pw, ph, color)
						local text = swep.PrintName
						if strEmpty(text) then
							text = "ClassName: " .. swep.ClassName
						end

						if string.find(string.lower(swep.ClassName), "base", 1, true) or string.find(string.lower(swep.PrintName), "base", 1, true) then
							text = text .. " [MAYBE A BASE]"
						end

						draw.SimpleText(text, "Y_16_700", ph / 2, ph / 2, YRPTextColor(color), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					end

					if DBTab2[swep.ClassName] == nil then
						DBTab2[swep.ClassName] = {}
						DBTab2[swep.ClassName].slot_primary = 0
						DBTab2[swep.ClassName].slot_secondary = 0
						DBTab2[swep.ClassName].slot_sidearm = 0
						DBTab2[swep.ClassName].slot_gadget = 0
						DBTab2[swep.ClassName].slot_no = 0
					end

					DBTab2[swep.ClassName].slot_primary = tonumber(DBTab2[swep.ClassName].slot_primary)
					DBTab2[swep.ClassName].slot_secondary = tonumber(DBTab2[swep.ClassName].slot_secondary)
					DBTab2[swep.ClassName].slot_sidearm = tonumber(DBTab2[swep.ClassName].slot_sidearm)
					DBTab2[swep.ClassName].slot_gadget = tonumber(DBTab2[swep.ClassName].slot_gadget)
					DBTab2[swep.ClassName].slot_no = tonumber(DBTab2[swep.ClassName].slot_no)
					-- parent, x, y, cname, art, sval
					cbs[swep.ClassName] = {}
					cbs[swep.ClassName].pr = YRPWeaponSlotCB(weapon, weapon:GetWide() - 60 - spacer * 4 - 12, 0, swep.ClassName, "slot_primary", DBTab2[swep.ClassName].slot_primary)
					cbs[swep.ClassName].se = YRPWeaponSlotCB(weapon, weapon:GetWide() - 60 - spacer * 3 - 12, 0, swep.ClassName, "slot_secondary", DBTab2[swep.ClassName].slot_secondary)
					cbs[swep.ClassName].si = YRPWeaponSlotCB(weapon, weapon:GetWide() - 60 - spacer * 2 - 12, 0, swep.ClassName, "slot_sidearm", DBTab2[swep.ClassName].slot_sidearm)
					cbs[swep.ClassName].ga = YRPWeaponSlotCB(weapon, weapon:GetWide() - 60 - spacer * 1 - 12, 0, swep.ClassName, "slot_gadget", DBTab2[swep.ClassName].slot_gadget)
					cbs[swep.ClassName].no = YRPWeaponSlotCB(weapon, weapon:GetWide() - 60 - spacer * 0 - 12, 0, swep.ClassName, "slot_no", DBTab2[swep.ClassName].slot_no)
					lis:AddItem(weapon)
				end
			end
		end

		YRPWeaponUpdateList()
	end
)

function OpenSettingsWeaponSystem()
	net.Start("nws_yrp_weapon_menu")
	net.SendToServer()
end