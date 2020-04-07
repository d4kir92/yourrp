--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- #SENDISREADY #READY #PLAYERISREADY #ISREADY

yrp_rToSv = yrp_rToSv or false

yrp_initpostentity = yrp_initpostentity or false
yrp_hookinitpostentity = yrp_hookinitpostentity or false

local d = d or 0

local serverreceived = false

function YRPSendIsReadyPingPong()	-- IMPORTANT
	local lply = LocalPlayer()

	local info = {}
	info.iswindows = system.IsWindows()
	info.islinux = system.IsLinux()
	info.isosx = system.IsOSX()
	info.country = system.GetCountry()
	
	local b, bb = net.BytesLeft()
	if b and b > 0 then
		YRP.msg("note", "Already running a net message, retry sending ready message.")
		timer.Simple(2, function()
			YRPSendIsReadyPingPong()
		end)
	else
		net.Start("yrp_player_is_ready")
			net.WriteTable(info)
		net.SendToServer()

		timer.Simple(20, function()
			if !lply:GetDBool("yrp_received_ready") then
				YRP.msg("note", "Retry sending ready message.")
				YRPSendIsReadyPingPong()
			end
		end)
	end
end

function YRPSendIsReady()
	if !yrp_rToSv then
		yrp_rToSv = true

		-- IMPORTANT
		YRPSendIsReadyPingPong()

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

		--TestYourRPContent()
	end
end

local YRP_COUNT = 0
local YRP_INIT = false
local YRP_NOINIT = false
hook.Add("Think", "yrp_think_ready", function()
	if yrp_rToSv then return end

	if YRP_INIT or YRP_NOINIT then
		if !yrp_rToSv then
			YRPSendIsReady()
		end
	elseif yrp_hookinitpostentity or yrp_initpostentity then
		YRP_INIT = true
	elseif d < CurTime() then
		d = CurTime() + 1
		YRP_COUNT = YRP_COUNT + 1
		if YRP_COUNT > 10 and wk(system.GetCountry()) then
			YRP_NOINIT = true
		end
	end
end)

hook.Add("InitPostEntity", "yrp_InitPostEntity_ready", function()
	printGM("note", "All entities are loaded.")

	yrp_hookinitpostentity = true
end)

function GM:InitPostEntity()
	printGM("note", "All Entities have initialized.")

	yrp_initpostentity = true
end

function printReadyError()
	local lply = LocalPlayer()

	local str = "yrp_received_ready: " .. tostring(LocalPlayer():GetDBool("yrp_received_ready", false))
	str = str .. " yrp_rToSv: " .. tostring(yrp_rToSv)
	str = str .. " loadedchars: " .. tostring(LocalPlayer():GetDBool("loadedchars", false))
	str = str .. " yrp_hookinitpostentity: " .. tostring(yrp_hookinitpostentity)
	str = str .. " yrp_initpostentity: " .. tostring(yrp_initpostentity)
	str = str .. " YRP_NOINIT: " .. tostring(YRP_NOINIT)
	str = str .. " ENTS: " .. tostring(lply:GetDInt("yrp_load_ent", 0))
	str = str .. " GLOS: " .. tostring(lply:GetDInt("yrp_load_glo", 0))
	str = str .. " dedi: " .. tostring(lply:GetDBool("isserverdedicated"))
	str = str .. " country: " .. tostring(system.GetCountry())
	str = str .. " YRP_COUNT: " .. tostring(YRP_COUNT)

	return str
end

local failed = failed or false
timer.Create("yrp_sendready", 120, 0, function()
	local lply = LocalPlayer()
	if !yrp_rToSv then
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