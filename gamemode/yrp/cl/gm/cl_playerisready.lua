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
		OpenHelpMenu()
	end

	timer.Simple(4, function()
		local _wsitems = engine.GetAddons()
		printGM("note", "[" .. #_wsitems .. " Workshop items]")
		printGM("note", " Nr.\tID\t\tName Mounted")

		for k, ws in pairs(_wsitems) do
			if !ws.mounted then
				printGM("note", "+[" .. k .. "]\t[" .. tostring(ws.wsid) .. "]\t[" .. tostring(ws.title) .. "] Mounting")
				if IsValid(ws.path) then
					game.MountGMA(tostring(ws.path))
				else
					YRP.msg("note", "Path is not valid! [" .. tostring(ws.path) .. "]")
				end
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
