--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

function YRPSendIsReady()
	local info = {}
	info.iswindows = system.IsWindows()
	info.islinux = system.IsLinux()
	info.isosx = system.IsOSX()
	info.country = system.GetCountry()

	net.Start("yrp_player_is_ready")
		net.WriteTable(info)
	net.SendToServer()

	YRP.initLang()

	if tobool(get_tutorial("tut_welcome")) then
		openHelpMenu()
	end

	if !LocalPlayer():GetNW2Bool("isserverdedicated", false) then
		local warning = createD("YFrame", nil, ScrW(), ScrH(), 0, 0)
		warning:Center()
		warning:SetTitle("Warning - If you want to remove this, use a dedicated server")
		warning:SetHeaderHeight(ctr(100))
		warning:ShowCloseButton(false)
		function warning:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(40, 40, 40))
			hook.Run("YFramePaint", self, pw, ph)
			if LocalPlayer():GetNW2Bool("isserverdedicated", false) then
				self:Remove()
			end
		end

		warning.tick = 10

		warning.site = createD("DHTML", warning, ScrW() - ctr(200), ScrH() - ctr(100 + 100 + 60 + 20 + 60 + 20), ctr(100), ctr(100))
		warning.site:OpenURL("https://sites.google.com/view/gdsm/home")

		warning.openlink = createD("YButton", warning, ctr(400), ctr(60), warning:GetWide() / 2 - ctr(200), warning:GetTall() - ctr(60 + 20 + 60 + 100))
		warning.openlink:SetText("Open Website")
		function warning.openlink:Paint(pw, ph)
			hook.Run("YButtonPaint", self, pw, ph)
		end
		function warning.openlink:DoClick()
			gui.OpenURL("https://sites.google.com/view/gdsm/home")
		end

		warning.close = createD("YButton", warning, ctr(400), ctr(60), warning:GetWide() / 2 - ctr(200), warning:GetTall() - ctr(60 + 100))
		warning.close:SetText("Close")
		function warning.close:Paint(pw, ph)
			hook.Run("YButtonPaint", self, pw, ph)
		end
		function warning.close:DoClick()
			if warning.tick == 0 then
				warning:Close()
			end
		end

		timer.Create("yrp_warning_timer", 1, 0, function()
			if warning:IsValid() then
				warning.close:SetText(warning.tick)
				warning.tick = warning.tick - 1
				if warning.tick == 0 then
					if warning:IsValid() then
						warning.close:SetText("Close")
					end
					timer.Remove("yrp_warning_timer")
				end
			else
				timer.Remove("yrp_warning_timer")
			end
		end)
		warning:MakePopup()
	end

	timer.Simple(4, function()
		local _wsitems = engine.GetAddons()
		printGM("note", "[" .. #_wsitems .. " Workshop items]")
		printGM("note", " Nr.\tID\t\tName Mounted")

		for k, ws in pairs(_wsitems) do
			if !ws.mounted then
				printGM("note", "+[" .. k .. "]\t[" .. tostring(ws.wsid) .. "]\t[" .. tostring(ws.title) .. "] Mounting")
				game.MountGMA(tostring(ws.path))
			end
		end

		printGM("note", "Workshop Addons Done")
		playerfullready = true
	end)
end

function GM:InitPostEntity()
	printGM("note", "All entities are loaded.")

	YRPSendIsReady()
end
