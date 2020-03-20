--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local inv = inv or {}
inv.open = false
inv.br = 10
inv.sp = 20
function ToggleInventory()
	if inv.win == nil then -- DEBUG
		OpenInventory()
	else
		CloseInventory()
	end
end

function CloseInventory()
	inv.open = false
	if inv.win != nil then
		inv.win:Remove()
		inv.win = nil
	end
end

function ItemSize()
	return YRP.ctr(100)
end

function Inventory()
	return inv.win
end

function OpenInventory(target)
	if IsInventorySystemEnabled() then
		inv.open = true

		local lply = LocalPlayer()

		inv.w = 5 * ItemSize() + 4 * YRP.ctr(inv.br) + 2 * YRP.ctr(inv.sp)
		inv.h = ItemSize() + 2 * YRP.ctr(inv.sp)

		lply.invx = ScW() - YRP.ctr(50)
		lply.invy = ScH() - (ItemSize() + YRP.ctr(60))

		inv.win = createD("DFrame", nil, inv.w, inv.h, ScW() - inv.w - YRP.ctr(50), ScH() - inv.h)
		inv.win:MakePopup()
		inv.win:SetTitle("")
		inv.win:ShowCloseButton(false)
		function inv.win:Paint(pw, ph)
			draw.RoundedBoxEx(12, 0, 0, pw, ph, lply:InterfaceValue("YFrame", "NC"), true, true, false, false)
		end

		net.Receive("get_inventory", function(len)
			local storageID = net.ReadString()
			if pa(Inventory()) then
				inv.storage = createD("YStorage", inv.win, ItemSize() * 5 + YRP.ctr(inv.br) * 4, ItemSize(), YRP.ctr(inv.sp), YRP.ctr(inv.sp))
				inv.storage:SetCols(5)
				inv.storage:SetStorageID(storageID)

				local nettab = net.ReadTable()
				
				if table.Count(nettab) > 0 then
					local env = createD("DFrame", nil, 4 * ItemSize() + 3 * YRP.ctr(inv.br) + 2 * YRP.ctr(inv.sp), 4 * ItemSize() + 3 * YRP.ctr(inv.br) + 2 * YRP.ctr(inv.sp) + YRP.ctr(50), 0, 0)
					env:MakePopup()
					env:Center()
					env:SetTitle("")
					function env:Paint(pw, ph)
						if !Inventory() then
							self:Remove()
						end
						draw.RoundedBox(0, 0, 0, pw, ph, lply:InterfaceValue("YFrame", "NC"))
						draw.SimpleText(YRP.lang_string("LID_environment"), "Y_15_500", YRP.ctr(25), YRP.ctr(25), Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					end
					local envsto = createD("YStorage", env, ItemSize() * 4 + YRP.ctr(inv.br) * 3, ItemSize() * 4 + YRP.ctr(inv.br) * 3, YRP.ctr(inv.sp), YRP.ctr(50) + YRP.ctr(inv.sp))
					envsto:SetStorageID(0, nettab)
				end
			end
		end)

		net.Start("get_inventory")
		net.SendToServer()
	end
end
CloseInventory()

dropitem = dropitem or createD("DPanelList", nil, ScW(), ScH(), 0, 0)
function dropitem:Paint(pw, ph)
	--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 100, 100, 100))
end
dropitem:Receiver("yrp_slot",
function(receiver, panels, bDoDrop, Command, x, y)
	if bDoDrop then
		local item = panels[1]

		local itemID = item.main:GetItemID()

		if itemID != nil then
			net.Start("yrp_item_drop")
				net.WriteString(itemID)
			net.SendToServer()
		end
	end
end, {})