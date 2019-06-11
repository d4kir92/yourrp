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
	if inv.win != nil then
		inv.win:Remove()
	end
end

local itemsize = 140
function OpenInventory(target)
	openMenu()
	inv.win = createD("YFrame", nil, ScW(), ScH(), PosX(), 0)
	inv.win:MakePopup()
	inv.win:SetTitle(YRP.lang_string("LID_inventory"))
	inv.win:SetHeaderHeight(tr(50))
	function inv.win:Paint(pw, ph)
		--hook.Run("YFramePaint", self, pw, ph)
	end

	net.Start("get_inventory")
	net.SendToServer()

	local BR = tr(20)
	local br = tr(10)
	local EW = tr(940)
	local EH = tr(itemsize * 4) + 3 * br + 2 * BR

	local TH = ScH() - BR - BR - EH - BR

	local bgcolor = Color(40, 40, 40, 240)

	-- BOT
	inv.drop1 = createD("DPanel", inv.win, EW, EH, BR, ScH() - EH - BR)
	function inv.drop1:Paint(pw, ph)
		draw.RoundedBox(10, 0, 0, pw, ph, bgcolor)
	end

	inv.storages = createD("YStorage", inv.win, EW * 2, EH, BR + EW + BR, ScH() - EH - BR)
	function inv.storages:Paint(pw, ph)
		draw.RoundedBox(10, 0, 0, pw, ph, bgcolor)
	end
	inv.storage1 = createD("YStorage", inv.storages, tr(1200), tr(400), BR, BR)
	inv.storage1:SetStorage(1)

	inv.dropa = createD("DPanel", inv.win, EW, EH, BR + EW + BR + EW * 2 + BR, ScH() - EH - BR)
	function inv.dropa:Paint(pw, ph)
		draw.RoundedBox(10, 0, 0, pw, ph, bgcolor)
	end

	-- TOP
	inv.char = createD("DPanel", inv.win, EW, TH, BR, BR)
	function inv.char:Paint(pw, ph)
		draw.RoundedBox(10, 0, 0, pw, ph, bgcolor)
	end

	inv.target = createD("DPanel", inv.win, EW * 2, TH, BR + EW + BR, BR)
	function inv.target:Paint(pw, ph)
		draw.RoundedBox(10, 0, 0, pw, ph, bgcolor)
	end

	inv.info = createD("DPanel", inv.win, EW, TH, BR + EW + BR + EW * 2 + BR, BR)
	function inv.info:Paint(pw, ph)
		draw.RoundedBox(10, 0, 0, pw, ph, bgcolor)
	end

	if target == nil then
		-- Surrounding
		net.Receive("get_surrounding_items", function(len)
			local tar = inv.target
			tar.slots = {}

			local id = 0
			for x = 0, 8 do
				for y = 0, 8 do
					id = id + 1

					tar.slots[id] = createD("DScrollPanel", tar, tr(itemsize), tr(itemsize), tr(20) + tr(x * 10 + x * itemsize), tr(20) + tr(y * 10 + y * itemsize))
					local slot = tar.slots[id]
					slot.int_storage = 0
					slot.int_position = id
					function slot:Paint(pw, ph)
						draw.RoundedBox(6, 0, 0, pw, ph, Color(80, 80, 80, 255))
					end

					function slot:MoveItem()

					end

					slot:Receiver("yrp_item", function(receiver, panels, bDoDrop, Command, mx, my)
						if (bDoDrop) then
							local item = panels[1]
							if item.int_storage != nil then
								net.Start("yrp_move_to_world")
									net.WriteString(item.int_storage)
									net.WriteString(item.uid)
								net.SendToServer()
							end
						end
					end)
				end
			end

			local items = net.ReadTable()
			local id = 0
			for i, item in pairs(items) do
				local test = createD("SpawnIcon", nil, tr(itemsize), tr(itemsize), 0, 0)
				test.uid = 0
				test.entity = item
				if item:IsValid() and item.GetModel != nil and !strEmpty(item:GetModel()) then
					id = id + 1
					test:SetModel(item:GetModel())
					function test:PaintOver(pw, ph)
						if !self:IsValid() then
							self:Remove()
						elseif self.entity:IsValid() then
							draw.SimpleText(self.entity.PrintName or self.entity.ClassName or self.entity:GetClass(), "Roboto12", pw / 2, ph - tr(20), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						else
							self:Remove()
						end
					end
					test:Droppable("yrp_item")
					tar.slots[id]:AddItem(test)
				else
					test:Remove()
				end
			end
		end)
		net.Start("get_surrounding_items")
		net.SendToServer()
	end
end
