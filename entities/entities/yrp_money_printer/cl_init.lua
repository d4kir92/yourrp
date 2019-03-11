--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

include("shared.lua")

function moneyPrinterButton(mp, parent, w, h, x, y, item, _net, name, _up, _full)
	local ply = LocalPlayer()
	local tmp = createD("DPanel", parent, w, h, x, y)
	function tmp:Paint(pw, ph)
		draw.RoundedBox(ctr(10), 0, 0, pw, ph, Color(0, 0, 0, 200))

		draw.RoundedBox(0, 0, 0, (mp:GetNW2Int(item, -1) / mp:GetNW2Int(item .. "Max", -1)) * ctr(360) , ph, Color(0, 0, 255, 200))

		draw.SimpleTextOutlined(mp:GetNW2Int(item, -1) .. "/" .. mp:GetNW2Int(item .. "Max", -1) .. " " .. name, "HudBars", ctr(10), ph/2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end
	local tmpBut = createD("DButton", tmp, ctr(220), h, w - ctr(220), 0)
	tmpBut:SetText("")
	function tmpBut:Paint(pw, ph)
		local cost = mp:GetNW2Int(item .. "Cost")
		if mp:GetNW2Int(item) < mp:GetNW2Int(item .. "Max") then
			if self:IsHovered() then
				draw.RoundedBox(ctr(10), 0, 0, pw, ph, Color(255, 255, 0, 200))
				draw.SimpleTextOutlined(formatMoney(cost, ply), "HudBars", pw/2, ph/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			else
				draw.RoundedBox(ctr(10), 0, 0, pw, ph, Color(255, 255, 255, 200))
				draw.SimpleTextOutlined(_up, "HudBars", pw/2, ph/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			end
		else
			draw.RoundedBox(ctr(10), 0, 0, pw, ph, Color(0, 255, 0, 200))
			draw.SimpleTextOutlined(_full, "HudBars", pw/2, ph/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		end
	end
	function tmpBut:DoClick()
		net.Start(_net)
			net.WriteEntity(mp)
		net.SendToServer()
	end
end

local upgradeframe = nil
net.Receive("getMoneyPrintMenu", function(len)
	local ply = LocalPlayer()

	local mp = net.ReadEntity()

	if upgradeframe == nil then
		upgradeframe = createD("DFrame", nil, ctr(600), ctr(600), 0, 0)
		upgradeframe:SetTitle("")
		upgradeframe:ShowCloseButton(false)
		function upgradeframe:Remove()
			upgradeframe = nil
		end
		function upgradeframe:Paint(pw, ph)
			draw.RoundedBox(ctr(30), 0, 0, pw, ph, Color(40, 40, 40, 200))

			draw.SimpleTextOutlined(YRP.lang_string("LID_money_printer"), "HudBars", pw/2, ctr(30), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		end

		--CPU
		moneyPrinterButton(mp, upgradeframe, ctr(580), ctr(60), ctr(10), ctr(60), "cpu", "upgradeCPU",YRP.lang_string("LID_cpu"),YRP.lang_string("LID_upgrade"),YRP.lang_string("LID_max"))

		--Cooler
		moneyPrinterButton(mp, upgradeframe, ctr(580), ctr(60), ctr(10), ctr(60 + 70), "cooler", "upgradeCooler",YRP.lang_string("LID_cooler"),YRP.lang_string("LID_upgrade"),YRP.lang_string("LID_max"))

		--Printer
		moneyPrinterButton(mp, upgradeframe, ctr(580), ctr(60), ctr(10), ctr(60 + 140), "printer", "upgradePrinter",YRP.lang_string("LID_printer"),YRP.lang_string("LID_upgrade"),YRP.lang_string("LID_max"))

		--Printer
		moneyPrinterButton(mp, upgradeframe, ctr(580), ctr(60), ctr(10), ctr(60 + 210), "storage", "upgradeStorage",YRP.lang_string("LID_storage"),YRP.lang_string("LID_upgrade"),YRP.lang_string("LID_max"))

		--Fuel
		moneyPrinterButton(mp, upgradeframe, ctr(580), ctr(60), ctr(10), ctr(60 + 280), "fuel", "fuelUP",YRP.lang_string("LID_fuel"),YRP.lang_string("LID_fuelup"),YRP.lang_string("LID_full"))

		--gather
		local moneyInfo = createD("DPanel", upgradeframe, ctr(580), ctr(60), ctr(10), ctr(60 + 390))
		function moneyInfo:Paint(pw, ph)
			draw.RoundedBox(ctr(10), 0, 0, pw, ph, Color(0, 0, 0, 200))

			draw.RoundedBox(0, 0, 0, (mp:GetNW2Int("money", -1) / mp:GetNW2Int("moneyMax", -1)) * ctr(360) , ph, Color(0, 0, 255, 200))

			draw.SimpleTextOutlined(formatMoney(mp:GetNW2Int("money", -1), ply) .. "/" .. formatMoney(mp:GetNW2Int("moneyMax" , -1), ply), "HudBars", ctr(10), ph/2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		end

		local gatherMoney = createD("DButton", moneyInfo, ctr(220), ctr(60), ctr(360), ctr(0))
		gatherMoney:SetText("")
		function gatherMoney:Paint(pw, ph)
			if self:IsHovered() then
				draw.RoundedBox(ctr(10), 0, 0, pw, ph, Color(255, 255, 0, 200))
				draw.SimpleTextOutlined(YRP.lang_string("LID_gather"), "HudBars", pw/2, ph/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			else
				draw.RoundedBox(ctr(10), 0, 0, pw, ph, Color(255, 255, 255, 200))
				draw.SimpleTextOutlined(YRP.lang_string("LID_gather"), "HudBars", pw/2, ph/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			end
		end
		function gatherMoney:DoClick()
			net.Start("withdrawMoney")
				net.WriteEntity(mp)
			net.SendToServer()
		end

		--Working
		local workingB = createD("DButton", upgradeframe, ctr(360), ctr(60), ctr(10), ctr(520))
		workingB:SetText("")
		function workingB:Paint(pw, ph)
			local working =YRP.lang_string("LID_off")
			if mp:GetNW2Bool("working") then
				working =YRP.lang_string("LID_on")
			end
			if self:IsHovered() then
				draw.RoundedBox(ctr(10), 0, 0, pw, ph, Color(255, 255, 0, 200))
				draw.SimpleTextOutlined(YRP.lang_string("LID_toggle"), "HudBars", pw/2, ph/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			else
				if mp:GetNW2Bool("working") then
					draw.RoundedBox(ctr(10), 0, 0, pw, ph, Color(0, 255, 0, 200))
				else
					draw.RoundedBox(ctr(10), 0, 0, pw, ph, Color(255, 0, 0, 200))
				end
				draw.SimpleTextOutlined(working, "HudBars", pw/2, ph/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			end
		end
		function workingB:DoClick()
			net.Start("startMoneyPrinter")
				net.WriteEntity(mp)
			net.SendToServer()
		end

		--CLOSE
		local closeMenu = createD("DButton", upgradeframe, ctr(200), ctr(60), ctr(600-200-10), ctr(600-60-20))
		closeMenu:SetText("")
		function closeMenu:Paint(pw, ph)
			if self:IsHovered() then
				draw.RoundedBox(ctr(10), 0, 0, pw, ph, Color(255, 255, 0, 200))
			else
				draw.RoundedBox(ctr(10), 0, 0, pw, ph, Color(255, 255, 255, 200))
			end

			draw.SimpleTextOutlined("X", "HudBars", pw/2, ph/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		end
		function closeMenu:DoClick()
			upgradeframe:Close()
		end

		upgradeframe:Center()

		upgradeframe:MakePopup()
	end
end)

function ENT:Draw()
	local ply = LocalPlayer()
	local dist = ply:GetPos():Distance(self:GetPos())
	if dist < 2000 then
		self:DrawModel()
	end
end
