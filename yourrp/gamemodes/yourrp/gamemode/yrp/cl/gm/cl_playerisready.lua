--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- #SENDISREADY #READY #PLAYERISREADY #ISREADY

yrp_rToSv = yrp_rToSv or false

yrp_initpostentity = yrp_initpostentity or false
yrp_hookinitpostentity = yrp_hookinitpostentity or false

local d = d or 0

local serverreceived = false

local YRP_COUNT = 0
local YRP_INIT = false
local YRP_NOINIT = false
YRPWasReadySendToServer = YRPWasReadySendToServer or false

function WasReadySendToServer()
	return YRPWasReadySendToServer
end

function YRPSendIsReadyPingPong()	-- IMPORTANT
	local lply = LocalPlayer()

	if system.IsWindows and os.clock and system.GetCountry then
		local info = {}
		info.iswindows = system.IsWindows()
		info.islinux = system.IsLinux()
		info.isosx = system.IsOSX()
		info.country = system.GetCountry()
		info.branch = GetBranch()
		info.uptime = os.clock()
		
		local b, bb = net.BytesLeft()
		local w, ww = net.BytesWritten()
		if b and b > 0 and w and w > 0 then
			YRP.msg("note", "[YRPSendIsReadyPingPong] Already running a net message, retry sending ready message.")
			YRPSendIsReadyPingPong()
		else
			YRP.msg("note", "[YRPSendIsReadyPingPong] SEND TO SERVER.")
			net.Start("yrp_player_is_ready")
				net.WriteTable(info)
			net.SendToServer()
			YRPWasReadySendToServer = true

			timer.Simple(3.9, function()
				if !IsValid(lply) then return end

				if !lply:GetNW2Bool("yrp_received_ready") then
					YRP.msg("note", "[YRPSendIsReadyPingPong] >> Retry sending ready message <<")
					YRPSendIsReadyPingPong()
				end
			end)
		end
	else
		YRP.msg("note", "[YRPSendIsReadyPingPong] System/os not ready, retry.")
		timer.Simple(0.001, function()
			YRPSendIsReadyPingPong()
		end)
	end
end

function YRPSendIsReady()
	if !yrp_rToSv then
		yrp_rToSv = true

		YRP.msg("note", "[YRPSendIsReady]")

		-- IMPORTANT
		YRPSendIsReadyPingPong()

		YRP.initLang()

		local _wsitems = engine.GetAddons()
		YRP.msg("note", "[" .. #_wsitems .. " Workshop items]")
		YRP.msg("note", " Nr.\tID\t\tName Mounted")

		for k, ws in pairs(_wsitems) do
			if !ws.mounted then
				YRP.msg("note", "+[" .. k .. "]\t[" .. tostring(ws.wsid) .. "]\t[" .. tostring(ws.title) .. "] Mounting")
				if IsValid(ws.path) then
					game.MountGMA(tostring(ws.path))
				else
					YRP.msg("note", "Path is not valid! [" .. tostring(ws.path) .. "]")
				end
			end
		end

		YRP.msg("note", "Workshop Addons Done")

		YRP.LoadDesignIcon()
	end
end

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
end, hook.MONITOR_HIGH)

hook.Add("InitPostEntity", "yrp_InitPostEntity_ready", function()
	--YRP.msg("note", "All entities are loaded.")

	yrp_hookinitpostentity = true
end)

function GM:InitPostEntity()
	--YRP.msg("note", "All Entities have initialized.")

	yrp_initpostentity = true
end

