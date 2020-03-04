--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- #SENDISREADY #READY #PLAYERISREADY #ISREADY

rToSv = rToSv or false

initpostentity = initpostentity or false
hookinitpostentity = hookinitpostentity or false

local d = d or 0

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

local count = 0
local init = false
local noinit = false
hook.Add("Think", "yrp_think_ready", function()
	if rToSv then return end

	if init or noinit then
		if !rToSv then
			YRPSendIsReady()
		end
	elseif hookinitpostentity or initpostentity then
		init = true
	elseif d < CurTime() then
		d = CurTime() + 1
		count = count + 1
		if count > 4 and wk(system.GetCountry()) then
			noinit = true
		end
	end
end)

hook.Add("InitPostEntity", "yrp_InitPostEntity_ready", function()
	printGM("note", "All entities are loaded.")

	hookinitpostentity = true
end)

function GM:InitPostEntity()
	printGM("note", "All Entities have initialized.")

	initpostentity = true
end

function printReadyError()
	local lply = LocalPlayer()

	local str = "finishedloading: " .. tostring(LocalPlayer():GetDBool("finishedloading", false))
	str = str .. " rToSv: " .. tostring(rToSv)
	str = str .. " loadedchars: " .. tostring(LocalPlayer():GetDBool("loadedchars", false))
	str = str .. " hookinitpostentity: " .. tostring(hookinitpostentity)
	str = str .. " initpostentity: " .. tostring(initpostentity)
	str = str .. " noinit: " .. tostring(noinit)
	str = str .. " ENTS: " .. tostring(lply:GetDInt("yrp_load_ent", 0))
	str = str .. " GLOS: " .. tostring(lply:GetDInt("yrp_load_glo", 0))
	str = str .. " dedi: " .. tostring(lply:GetDBool("isserverdedicated", false))
	str = str .. " country: " .. tostring(system.GetCountry())
	str = str .. " count: " .. tostring(count)

	return str
end

local failed = failed or false
timer.Create("yrp_sendready", 120, 0, function()
	local lply = LocalPlayer()
	if !rToSv then
		failed = true
		if lply:GetDInt("yrp_load_ent", 0) == 100 and lply:GetDInt("yrp_load_glo", 0) == 100 then
			YRP.msg("error", "SEND IS READY FAILED " .. printReadyError())
			YRPSendIsReady()
		else
			YRP.msg("error", "SEND IS READY FAILED 2 " .. printReadyError())
		end
	else
		if failed then
			--YRP.msg("error", "SEND IS READY WORKED ERROR: " .. printReadyError())
		else
			YRP.msg("note", "SEND IS READY WORKED")
			timer.Remove("yrp_sendready")
		end
	end
end)