--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local inv = inv or {}
inv.open = false
inv.br = 10
inv.sp = 20
function YRPToggleInventory()
	-- DEBUG
	if inv.win == nil then
		YRPOpenInventory()
	else
		YRPCloseInventory()
	end
end

function YRPCloseInventory()
	inv.open = false
	if IsValid(YRPDropItem) then
		YRPDropItem:Hide()
	end

	if inv.win ~= nil then
		surface.PlaySound("ambient/materials/wood_creak4.wav")
		if inv.env then
			inv.env:Remove()
		end

		if inv.envstor then
			inv.envstor:Remove()
		end

		if inv.env2 then
			inv.env2:Remove()
		end

		if inv.envstor2 then
			inv.envstor2:Remove()
		end

		inv.win:Remove()
		inv.win = nil
	end
end

function YRPItemSize()
	return YRP:ctr(100)
end

function YRPInventory()
	return inv.win
end

YRPDropItem = YRPDropItem or YRPCreateD("DPanelList", nil, ScrW(), ScrH(), 0, 0)
function YRPDropItem:Paint(pw, ph)
end

--draw.RoundedBox(0, 0, 0, pw, ph, Color( 0, 0, 0, 0) )
YRPDropItem:Hide()
function YRPOpenInventory(target)
	if IsInventorySystemEnabled() and YRPIsNoMenuOpen() then
		inv.open = true
		surface.PlaySound("ambient/materials/shuffle1.wav")
		if IsValid(YRPDropItem) then
			YRPDropItem:Show()
		end

		local lply = LocalPlayer()
		inv.w = 5 * YRPItemSize() + 4 * YRP:ctr(inv.br) + 2 * YRP:ctr(inv.sp)
		inv.h = YRPItemSize() + 2 * YRP:ctr(inv.sp)
		lply.invx = ScrW() - YRP:ctr(50)
		lply.invy = ScrH() - (YRPItemSize() + YRP:ctr(60))
		inv.win = YRPCreateD("DFrame", nil, inv.w, inv.h, ScrW() - inv.w - YRP:ctr(50), ScrH() - inv.h)
		inv.win:MakePopup()
		inv.win:SetTitle("")
		inv.win:ShowCloseButton(false)
		inv.win:SetDraggable(false)
		function inv.win:Paint(pw, ph)
			draw.RoundedBoxEx(12, 0, 0, pw, ph, YRPInterfaceValue("YFrame", "NC"), true, true, false, false)
		end

		net.Receive(
			"nws_yrp_get_inventory",
			function(len)
				local storageID = net.ReadString()
				if YRPPanelAlive(YRPInventory(), "YRPInventory() 1") then
					inv.storage = YRPCreateD("YStorage", inv.win, YRPItemSize() * 5 + YRP:ctr(inv.br) * 4, YRPItemSize(), YRP:ctr(inv.sp), YRP:ctr(inv.sp))
					inv.storage:SetCols(5)
					inv.storage:SetStorageID(storageID)
					local nettab = net.ReadTable()
					if table.Count(nettab) > 0 and not target then
						inv.env = YRPCreateD("DFrame", nil, 4 * YRPItemSize() + 3 * YRP:ctr(inv.br) + 2 * YRP:ctr(inv.sp), 4 * YRPItemSize() + 3 * YRP:ctr(inv.br) + 2 * YRP:ctr(inv.sp) + YRP:ctr(50), 0, 0)
						inv.env:MakePopup()
						inv.env:Center()
						inv.env:SetTitle("")
						function inv.env:Paint(pw, ph)
							draw.RoundedBox(0, 0, 0, pw, ph, YRPInterfaceValue("YFrame", "NC"))
							draw.SimpleText(YRP:trans("LID_environment"), "Y_18_500", YRP:ctr(20), YRP:ctr(30), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
						end

						inv.envstor = YRPCreateD("YStorage", inv.env, YRPItemSize() * 4 + YRP:ctr(inv.br) * 3, YRPItemSize() * 4 + YRP:ctr(inv.br) * 3, YRP:ctr(inv.sp), YRP:ctr(50) + YRP:ctr(inv.sp))
						inv.envstor:SetStorageID(0, nettab)
					end
				end
			end
		)

		net.Start("nws_yrp_get_inventory")
		net.SendToServer()
	end
end

YRPCloseInventory()
net.Receive(
	"nws_yrp_open_storage",
	function(len)
		YRPOpenInventory(true)
		if YRPPanelAlive(YRPInventory(), "YRPInventory() 2") then
			local wsuid = net.ReadString()
			local name = net.ReadString()
			if inv and inv.env2 then
				inv.env2:Remove()
			end

			inv.env2 = YRPCreateD("DFrame", nil, 4 * YRPItemSize() + 3 * YRP:ctr(inv.br) + 2 * YRP:ctr(inv.sp), 4 * YRPItemSize() + 3 * YRP:ctr(inv.br) + 2 * YRP:ctr(inv.sp) + YRP:ctr(50), 0, 0)
			inv.env2:MakePopup()
			inv.env2:Center()
			inv.env2:SetTitle("")
			function inv.env2:Paint(pw, ph)
				if not YRPInventory() then
					self:Remove()
				end

				draw.RoundedBox(0, 0, 0, pw, ph, YRPInterfaceValue("YFrame", "NC"))
				draw.SimpleText(name, "Y_18_500", YRP:ctr(20), YRP:ctr(30), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end

			inv.envstor2 = YRPCreateD("YStorage", inv.env2, YRPItemSize() * 4 + YRP:ctr(inv.br) * 3, YRPItemSize() * 4 + YRP:ctr(inv.br) * 3, YRP:ctr(inv.sp), YRP:ctr(50) + YRP:ctr(inv.sp))
			inv.envstor2:SetStorageID(wsuid)
		end
	end
)

YRPDropItem:Receiver(
	"yrp_slot",
	function(receiver, panels, bDoDrop, Command, x, y)
		if bDoDrop then
			local item = panels[1]
			local itemID = item.main:GetItemID()
			if itemID ~= nil then
				net.Start("nws_yrp_item_drop")
				net.WriteString(itemID)
				net.SendToServer()
			end
		end
	end, {}
)
