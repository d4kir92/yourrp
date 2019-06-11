--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local PANEL = {}

STORAGES = STORAGES or {}

local itemsize = 140

net.Receive("yrp_join_storage", function(len)
	local sto = net.ReadTable()
	sto.uniqueID = tonumber(sto.uniqueID)
	sto.int_size = tonumber(sto.int_size)

	local suid = sto.uniqueID
	local storage = STORAGES[suid]

	if storage != nil then
		local id = 0
		local reached = false
		for x = 0, 99 do
			for y = 0, 3 do
				id = id + 1
				if id <= sto.int_size then
					storage.slots[id] = createD("DScrollPanel", storage, tr(itemsize), tr(itemsize), tr(x * 10 + x * itemsize), tr(y * 10 + y * itemsize))
					local slot = storage.slots[id]
					slot.int_storage = suid
					slot.int_position = id
					function slot:Paint(pw, ph)
						draw.RoundedBox(6, 0, 0, pw, ph, Color(80, 80, 80, 255))
					end

					function slot:MoveItem()

					end

					slot:Receiver("yrp_item", function(receiver, panels, bDoDrop, Command, mx, my)
						if (bDoDrop) then
							local item = panels[1]
							net.Start("yrp_move_item")
								net.WriteString(receiver.int_storage)
								net.WriteInt(receiver.int_position, 16)
								net.WriteString(item.uid)
								net.WriteEntity(item.entity or NULL)
							net.SendToServer()
						end
					end)
				else
					local sx = x % 4
					if sx > 0 then
						x = x + 1
					end
					storage:SetWide(tr(itemsize * ((x - 1) + 1) + 10 * (x - 1)))
					storage:SetTall(tr(itemsize * 4 + 10 * 3))
					reached = true
					break
				end
			end
			if reached then
				break
			end
		end

		net.Start("yrp_get_items")
			net.WriteString(sto.uniqueID)
		net.SendToServer()
	end
end)

net.Receive("yrp_place_item", function(len, ply)
	local item = net.ReadTable()
	item.uniqueID = tonumber(item.uniqueID)
	item.int_storage = tonumber(item.int_storage)
	item.int_position = tonumber(item.int_position)

	local suid = item.int_storage
	local iuid = item.uniqueID
	local storage = STORAGES[suid]

	local test = createD("SpawnIcon", nil, tr(itemsize), tr(itemsize), 0, 0)
	test.int_storage = suid
	test.uid = iuid
	test:SetModel(item.text_worldmodel)
	function test:PaintOver(pw, ph)
		draw.SimpleText(item.text_printname, "Roboto12", pw / 2, ph - tr(20), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	test:Droppable("yrp_item")

	storage.slots[item.int_position]:AddItem(test)
end)

net.Receive("yrp_misplace_item", function(len, ply)
	local item = net.ReadTable()
	item.int_storage = tonumber(item.int_storage)
	item.int_position = tonumber(item.int_position)

	local suid = item.int_storage
	local storage = STORAGES[suid]

	storage.slots[item.int_position]:Clear()
end)

function PANEL:Paint(pw, ph)
	--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 0, 0, 100))
end

function PANEL:SetStorage(uid)
	uid = tonumber(uid)
	self.uid = uid
	self.slots = {}
	STORAGES[uid] = self
	net.Start("yrp_join_storage")
		net.WriteString(self.uid)
	net.SendToServer()
end

function PANEL:OnRemove()
	local suid = self.uid
	if suid != nil then
		net.Start("yrp_leave_storage")
			net.WriteString(suid)
		net.SendToServer()
	end
end

function PANEL:Init()
	self:SetText("")
end

vgui.Register("YStorage", PANEL, "DPanel")
