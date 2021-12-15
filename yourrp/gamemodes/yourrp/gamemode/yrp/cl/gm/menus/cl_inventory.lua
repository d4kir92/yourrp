--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

local inv = inv or {}
inv.open = false
inv.br = 10
inv.sp = 20
function YRPToggleInventory()
	if inv.win == nil then -- DEBUG
		YRPOpenInventory()
	else
		YRPCloseInventory()
	end
end

function YRPCloseInventory()
	inv.open = false

	if IsValid( YRPDropItem ) then
		YRPDropItem:Hide()
	end

	if inv.win != nil then
		surface.PlaySound( "ambient/materials/wood_creak4.wav" )
		inv.win:Remove()
		inv.win = nil
	end
end

function YRPItemSize()
	return YRP.ctr(100)
end

function YRPInventory()
	return inv.win
end

function YRPOpenInventory(target)
	if IsInventorySystemEnabled() and YRPIsNoMenuOpen() then
		inv.open = true

		surface.PlaySound( "ambient/materials/shuffle1.wav" )

		if IsValid(YRPDropItem) then
			YRPDropItem:Show()
		end

		local lply = LocalPlayer()

		inv.w = 5 * YRPItemSize() + 4 * YRP.ctr(inv.br) + 2 * YRP.ctr(inv.sp)
		inv.h = YRPItemSize() + 2 * YRP.ctr(inv.sp)

		lply.invx = ScrW() - YRP.ctr(50)
		lply.invy = ScrH() - (YRPItemSize() + YRP.ctr(60) )

		inv.win = createD( "DFrame", nil, inv.w, inv.h, ScrW() - inv.w - YRP.ctr(50), ScrH() - inv.h)
		inv.win:MakePopup()
		inv.win:SetTitle( "" )
		inv.win:ShowCloseButton(true)
		inv.win:SetDraggable(false)
		function inv.win:Paint(pw, ph)
			draw.RoundedBoxEx(12, 0, 0, pw, ph, lply:InterfaceValue( "YFrame", "NC" ), true, true, false, false)
		end

		net.Receive( "get_inventory", function(len)
			local storageID = net.ReadString()
			if pa(YRPInventory() ) then
				inv.storage = createD( "YStorage", inv.win, YRPItemSize() * 5 + YRP.ctr(inv.br) * 4, YRPItemSize(), YRP.ctr(inv.sp), YRP.ctr(inv.sp) )
				inv.storage:SetCols(5)
				inv.storage:SetStorageID(storageID)

				local nettab = net.ReadTable()
				if table.Count(nettab) > 0 and !target then
					local env = createD( "DFrame", nil, 4 * YRPItemSize() + 3 * YRP.ctr(inv.br) + 2 * YRP.ctr(inv.sp), 4 * YRPItemSize() + 3 * YRP.ctr(inv.br) + 2 * YRP.ctr(inv.sp) + YRP.ctr(50), 0, 0)
					env:MakePopup()
					env:Center()
					env:SetTitle( "" )
					function env:Paint(pw, ph)
						if !YRPInventory() then
							--self:Remove()
						end
						draw.RoundedBox(0, 0, 0, pw, ph, lply:InterfaceValue( "YFrame", "NC" ) )
						draw.SimpleText(YRP.lang_string( "LID_environment" ), "Y_18_500", YRP.ctr(20), YRP.ctr(30), Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					end
					local envsto = createD( "YStorage", env, YRPItemSize() * 4 + YRP.ctr(inv.br) * 3, YRPItemSize() * 4 + YRP.ctr(inv.br) * 3, YRP.ctr(inv.sp), YRP.ctr(50) + YRP.ctr(inv.sp) )
					envsto:SetStorageID(0, nettab)
				end
			end
		end)

		net.Start( "get_inventory" )
		net.SendToServer()
	end
end
YRPCloseInventory()

net.Receive( "yrp_open_storage", function(len)
	local lply = LocalPlayer()
	YRPOpenInventory(true)

	if pa(YRPInventory() ) then
		local wsuid = net.ReadString()
		local name = net.ReadString()
		
		local env = createD( "DFrame", nil, 4 * YRPItemSize() + 3 * YRP.ctr(inv.br) + 2 * YRP.ctr(inv.sp), 4 * YRPItemSize() + 3 * YRP.ctr(inv.br) + 2 * YRP.ctr(inv.sp) + YRP.ctr(50), 0, 0)
		env:MakePopup()
		env:Center()
		env:SetTitle( "" )
		function env:Paint(pw, ph)
			if !YRPInventory() then
				self:Remove()
			end
			draw.RoundedBox(0, 0, 0, pw, ph, lply:InterfaceValue( "YFrame", "NC" ) )
			draw.SimpleText(name, "Y_18_500", YRP.ctr(20), YRP.ctr(30), Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
		local storage = createD( "YStorage", env, YRPItemSize() * 4 + YRP.ctr(inv.br) * 3, YRPItemSize() * 4 + YRP.ctr(inv.br) * 3, YRP.ctr(inv.sp), YRP.ctr(50) + YRP.ctr(inv.sp) )
		storage:SetStorageID(wsuid)
	end
end)

YRPDropItem = YRPDropItem or createD( "DPanelList", nil, ScrW(), ScrH(), 0, 0)
function YRPDropItem:Paint(pw, ph)
	draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 255, 4) )
end
YRPDropItem:Hide()
YRPDropItem:Receiver( "yrp_slot", function( receiver, panels, bDoDrop, Command, x, y )
	if bDoDrop then
		local item = panels[1]

		local itemID = item.main:GetItemID()

		if itemID != nil then
			net.Start( "yrp_item_drop" )
				net.WriteString(itemID)
			net.SendToServer()
		end
	end
end, {})
