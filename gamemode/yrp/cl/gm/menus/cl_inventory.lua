--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local inv = {}
function ToggleInventory()
	if !inv.open then
		OpenInventory()
	else
		CloseInventory()
	end
end

function CloseInventory()
	inv.open = false
	if inv.bags != nil then
		inv.bags:Remove()
	end
end

itemsize = itemsize or 100

function OpenInventory(target)
	inv.open = true

	inv.bags = createD("DPanel", nil, YRP.ctr(5 * 80 + 6 * 20), YRP.ctr(20 + 80 + 20), ScW() - YRP.ctr(5 * 80 + 7 * 20), ScH() - YRP.ctr(20 + 80 + 20))
	inv.bags:MakePopup()
	function inv.bags:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(40, 40, 40, 250))
	end

	for i = 0, 5 do
		inv.bags["bag" .. i] = createD("YSlot", inv.bags, YRP.ctr(80), YRP.ctr(80), inv.bags:GetWide() - YRP.ctr(80 + 20) - i * YRP.ctr(80 + 20), YRP.ctr(20))
		local slot = inv.bags["bag" .. i]
		slot:AddAllowed("bag")
		slot:RemoveAllowed("item")
		slot:SetSlot("bag" .. i)
	end

	--[[local test = createD("YItem", nil, YRP.ctr(80), YRP.ctr(80), 0, 0)
	test:SetText("BAG 1")
	test:SetFixed(true)
	inv.bags["bag" .. 0]:AddItem(test)

	local test2 = createD("YItem", nil, YRP.ctr(80), YRP.ctr(80), 0, 0)
	test2:SetText("BAG 2")
	test2:SetTyp("bag")
	inv.bags["bag" .. 1]:AddItem(test2)

	local test3 = createD("YItem", nil, YRP.ctr(80), YRP.ctr(80), 0, 0)
	test3:SetText("BAG 3")
	test3:SetTyp("bag")
	inv.bags["bag" .. 2]:AddItem(test3)
	]]--

	-- Bags
	--[[
	inv.bag1 = vgui.Create("YBag")
	inv.bag1:SetVisible(false)
	inv.bag1:SetStorage(1)
	inv.bag1:MakePopup()

	timer.Simple(0.1, function()
		inv.bag1:SetPos(ScW() - inv.bag1:GetWide() - YRP.ctr(20), ScH() - inv.bag1:GetTall() - YRP.ctr(20))

		inv.bag1:SetVisible(true)
	end)
	]]
end
