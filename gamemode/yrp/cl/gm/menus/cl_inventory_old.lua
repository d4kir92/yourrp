--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local inv = {}
inv.open = false
function ToggleInventory()
	if !inv.open then -- DEBUG
		OpenInventory()
	else
		CloseInventory()
	end
end

function CloseInventory()
	inv.open = false
	if inv.bags != nil then
		inv.bags:Remove()
		hook.Call("close_inventory")
	end
end

function ItemSize()
	return YRP.ctr(100)
end

function OpenInventory(target)
	inv.open = true
	if IsInventorySystemEnabled() then
		if inv.bags != nil then
			charid = LocalPlayer():CharID()
			inv.bags:Remove()
			inv.bags = nil
		end

		if inv.bags == nil then
			inv.bags = createD("DPanel", nil, 5 * ItemSize() + YRP.ctr(6 * 20), ItemSize() + YRP.ctr(20 + 20), ScW() - (5 * ItemSize() + YRP.ctr(7 * 20)), ScH() - (ItemSize() + YRP.ctr(20 + 20)))
			inv.bags:MakePopup()
			function inv.bags:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, Color(40, 40, 40, 250))
			end

			for i = 0, 5 do
				inv.bags["bag" .. i] = createD("YSlot", inv.bags, ItemSize(), ItemSize(), inv.bags:GetWide() - ItemSize() - YRP.ctr(20) - i * (ItemSize() + YRP.ctr(20)), YRP.ctr(20))
				local slot = inv.bags["bag" .. i]
				slot:AddAllowed("bag")
				slot:RemoveAllowed("item")
				slot:SetSlot("bag" .. i)
			end
		end
	end
end
