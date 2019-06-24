--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local inv = {}
function ToggleInventory()
	if isNoMenuOpen() then
		OpenInventory()
	else
		CloseInventory()
	end
end

function CloseInventory()
	closeMenu()
	if inv.bag1 != nil then
		inv.bag1:Remove()
	end
end

itemsize = itemsize or 100

inv.bags = {}

function OpenInventory(target)
	openMenu()
	--[[inv.win = createD("YFrame", nil, tr(500), tr(500), 0, 0)
	inv.win:MakePopup()
	inv.win:SetTitle(YRP.lang_string("LID_inventory"))
	inv.win:SetHeaderHeight(tr(50))
	function inv.win:Paint(pw, ph)
		hook.Run("YFramePaint", self, pw, ph)
	end

	net.Start("get_inventory")
	net.SendToServer()
	]]--

	local BR = tr(20)

	local bgcolor = Color(40, 40, 40, 240)

	-- Bags
	inv.bag1 = vgui.Create("YBag")
	inv.bag1:SetVisible(false)
	inv.bag1:SetStorage(1)
	inv.bag1:MakePopup()

	timer.Simple(0.1, function()
		inv.bag1:SetPos(ScW() - inv.bag1:GetWide() - tr(20), ScH() - inv.bag1:GetTall() - tr(20))

		inv.bag1:SetVisible(true)
	end)
end
