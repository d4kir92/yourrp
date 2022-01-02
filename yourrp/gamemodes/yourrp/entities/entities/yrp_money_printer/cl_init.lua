--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

include( "shared.lua" )

function moneyPrinterButton(mp, parent, w, h, x, y, item, _net, name, _up, _full)
	local lply = LocalPlayer()
	local tmp = createD( "DPanel", parent, w, h, x, y)
	function tmp:Paint(pw, ph)
		draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, Color(0, 0, 0, 200) )

		draw.RoundedBox(0, 0, 0, (mp:GetNW2Int(item, -1) / mp:GetNW2Int(item .. "Max", -1) ) * YRP.ctr(540) , ph, Color(0, 0, 255, 200) )

		draw.SimpleTextOutlined(mp:GetNW2Int(item, -1) .. "/" .. mp:GetNW2Int(item .. "Max", -1) .. " " .. name, "Y_24_500", YRP.ctr(10), ph/2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
	end
	local tmpBut = createD( "DButton", tmp, YRP.ctr(220), h, w - YRP.ctr(220), 0)
	tmpBut:SetText( "" )
	function tmpBut:Paint(pw, ph)
		local cost = mp:GetNW2Int(item .. "Cost" )
		if mp:GetNW2Int(item, 0) < mp:GetNW2Int(item .. "Max", 0) then
			if self:IsHovered() then
				draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, Color(255, 255, 0, 200) )
				draw.SimpleTextOutlined(formatMoney( cost, ply), "Y_24_500", pw/2, ph/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
			else
				draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, Color(255, 255, 255, 200) )
				draw.SimpleTextOutlined(_up, "Y_24_500", pw/2, ph/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
			end
		else
			draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, Color(0, 255, 0, 200) )
			draw.SimpleTextOutlined(_full, "Y_24_500", pw/2, ph/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
		end
	end
	function tmpBut:DoClick()
		net.Start(_net)
			net.WriteEntity(mp)
		net.SendToServer()
	end
end

function tempInfo(mp, parent, w, h, x, y)
	local tmp = createD( "DPanel", parent, w, h, x, y)
	function tmp:Paint(pw, ph)
		draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, Color(0, 0, 0, 200) )

		draw.RoundedBox(0, 0, 0, (mp:GetNW2Float( "temp", 0.0) / mp:GetNW2Float( "tempMax", 0.0) ) * YRP.ctr(540) , ph, Color(0, 0, 255, 200) )

		draw.SimpleTextOutlined(math.Round(tonumber(mp:GetNW2Float( "temp", 0.0) ),2) .. " °C", "Y_24_500", YRP.ctr(10), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
	end
end

local upgradeframe = nil
net.Receive( "getMoneyPrintMenu", function(len)
	local lply = LocalPlayer()

	local mp = net.ReadEntity()

	if upgradeframe == nil then
		upgradeframe = createD( "DFrame", nil, YRP.ctr(800), YRP.ctr(900), 0, 0)
		upgradeframe:SetTitle( "" )
		upgradeframe:ShowCloseButton(false)
		function upgradeframe:Remove()
			upgradeframe = nil
		end
		function upgradeframe:Paint(pw, ph)
			draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, Color(40, 40, 40, 200) )
			draw.SimpleTextOutlined(YRP.lang_string( "LID_money_printer" ) .. "[" .. mp:EntIndex() .. "]", "Y_24_500", pw/2, YRP.ctr(30), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
		end

		--CPU
		moneyPrinterButton(mp, upgradeframe, YRP.ctr(800 - 2 * 20), YRP.ctr(60), YRP.ctr(20), YRP.ctr(60), "cpu", "upgradeCPU",YRP.lang_string( "LID_cpu" ),YRP.lang_string( "LID_upgrade" ),YRP.lang_string( "LID_max" ) )

		--Cooler
		moneyPrinterButton(mp, upgradeframe, YRP.ctr(800 - 2 * 20), YRP.ctr(60), YRP.ctr(20), YRP.ctr(60 + 70), "cooler", "upgradeCooler",YRP.lang_string( "LID_cooler" ),YRP.lang_string( "LID_upgrade" ),YRP.lang_string( "LID_max" ) )

		--Printer
		moneyPrinterButton(mp, upgradeframe, YRP.ctr(800 - 2 * 20), YRP.ctr(60), YRP.ctr(20), YRP.ctr(60 + 140), "printer", "upgradePrinter",YRP.lang_string( "LID_printer" ),YRP.lang_string( "LID_upgrade" ),YRP.lang_string( "LID_max" ) )

		--Printer
		if !GetGlobalBool( "bool_money_printer_spawn_money", false) then
			moneyPrinterButton(mp, upgradeframe, YRP.ctr(800 - 2 * 20), YRP.ctr(60), YRP.ctr(20), YRP.ctr(60 + 220), "storage", "upgradeStorage",YRP.lang_string( "LID_storage" ),YRP.lang_string( "LID_upgrade" ),YRP.lang_string( "LID_max" ) )
		end

		--Fuel
		moneyPrinterButton(mp, upgradeframe, YRP.ctr(800 - 2 * 20), YRP.ctr(60), YRP.ctr(20), YRP.ctr(60 + 380), "fuel", "fuelUP",YRP.lang_string( "LID_fuel" ),YRP.lang_string( "LID_fuelup" ),YRP.lang_string( "LID_full" ) )

		--HP
		moneyPrinterButton(mp, upgradeframe, YRP.ctr(800 - 2 * 20), YRP.ctr(60), YRP.ctr(20), YRP.ctr(60 + 450), "hp", "repairMP", YRP.lang_string( "LID_health" ), YRP.lang_string( "LID_repair" ), "" )

		--Temperatur
		tempInfo(mp, upgradeframe, YRP.ctr(800 - 2 * 20), YRP.ctr(60), YRP.ctr(20), YRP.ctr(60 + 520) )

		--gather
		local moneyInfo = createD( "DPanel", upgradeframe, YRP.ctr(800 - 2 * 20), YRP.ctr(60), YRP.ctr(20), YRP.ctr(60 + 690) )
		function moneyInfo:Paint(pw, ph)
			if !GetGlobalBool( "bool_money_printer_spawn_money", false) then
				draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, Color(0, 0, 0, 200) )

				draw.RoundedBox(0, 0, 0, (mp:GetNW2Int( "money", -1) / mp:GetNW2Int( "moneyMax", -1) ) * YRP.ctr(360) , ph, Color(0, 0, 255, 200) )

				draw.SimpleTextOutlined(formatMoney(mp:GetNW2Int( "money", -1), ply) .. "/" .. formatMoney(mp:GetNW2Int( "moneyMax" , -1), ply), "Y_24_500", YRP.ctr(10), ph/2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
			end
		end

		local gatherMoney = createD( "DButton", moneyInfo, YRP.ctr(220), YRP.ctr(60), YRP.ctr(540), YRP.ctr(0) )
		gatherMoney:SetText( "" )
		function gatherMoney:Paint(pw, ph)
			if !GetGlobalBool( "bool_money_printer_spawn_money", false) then
				if self:IsHovered() then
					draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, Color(255, 255, 0, 200) )
					draw.SimpleTextOutlined(YRP.lang_string( "LID_gather" ), "Y_24_500", pw/2, ph/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
				else
					draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, Color(255, 255, 255, 200) )
					draw.SimpleTextOutlined(YRP.lang_string( "LID_gather" ), "Y_24_500", pw/2, ph/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
				end
			end
		end
		function gatherMoney:DoClick()
			if !GetGlobalBool( "bool_money_printer_spawn_money", false) then
				net.Start( "withdrawMoney" )
					net.WriteEntity(mp)
				net.SendToServer()
			end
		end

		--Working
		local workingB = createD( "DButton", upgradeframe, YRP.ctr(360), YRP.ctr(60), YRP.ctr(20), YRP.ctr(820) )
		workingB:SetText( "" )
		function workingB:Paint(pw, ph)
			local working =YRP.lang_string( "LID_off" )
			if mp:GetNW2Bool( "working" ) then
				working =YRP.lang_string( "LID_on" )
			end
			if self:IsHovered() then
				draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, Color(255, 255, 0, 200) )
				draw.SimpleTextOutlined(YRP.lang_string( "LID_toggle" ), "Y_24_500", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
			else
				if mp:GetNW2Bool( "working" ) then
					draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, Color(0, 255, 0, 200) )
				else
					draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, Color(255, 0, 0, 200) )
				end
				draw.SimpleTextOutlined(working, "Y_24_500", pw/2, ph/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
			end
		end
		function workingB:DoClick()
			net.Start( "startMoneyPrinter" )
				net.WriteEntity(mp)
			net.SendToServer()
		end

		--CLOSE
		local closeMenu = createD( "DButton", upgradeframe, YRP.ctr(200), YRP.ctr(60), YRP.ctr(800-200-20), YRP.ctr(900-60-20) )
		closeMenu:SetText( "" )
		function closeMenu:Paint(pw, ph)
			if self:IsHovered() then
				draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, Color(255, 255, 0, 200) )
			else
				draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, Color(255, 255, 255, 200) )
			end

			draw.SimpleTextOutlined( "X", "Y_24_500", pw/2, ph/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
		end
		function closeMenu:DoClick()
			upgradeframe:Close()
		end

		upgradeframe:Center()

		upgradeframe:MakePopup()
	end
end)

function ENT:Draw()
	local lply = LocalPlayer()
	local dist = lply:GetPos():Distance(self:GetPos() )
	if dist < 2800 then
		self:DrawModel()
	end
end
