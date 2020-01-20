--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- #SENDISREADY

local rToSv = rToSv or false

function YRPSendIsReady()
	if !rToSv then
		rToSv = true

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
	end
end

local hookinitpostentity = false
hook.Add("InitPostEntity", "yrp_InitPostEntity", function()
	printGM("note", "All entities are loaded.")

	hookinitpostentity = true

	YRPSendIsReady()
	timer.Simple(1, function()
		YRPSendIsReady()
	end)
end)

local initpostentity = false
function GM:InitPostEntity()
	printGM("note", "All Entities have initialized.")

	initpostentity = true

	YRPSendIsReady()
	timer.Simple(1, function()
		YRPSendIsReady()
	end)
end

function printReadyError()
	return "rToSv: " .. tostring(rToSv) .. " LOADED_CHARS: " .. tostring(LOADED_CHARS) .. " hookinitpostentity: " .. tostring(hookinitpostentity) .. " initpostentity: " .. tostring(initpostentity)
end

timer.Simple(30, function()
	if !rToSv then
		YRP.msg("error", "SEND IS READY FAILED " .. printReadyError())
		YRPSendIsReady()
	else
		YRP.msg("note", "SEND IS READY WORKED " .. printReadyError())
	end
end)