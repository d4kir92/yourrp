--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- #SENDISREADY #READY #PLAYERISREADY #ISREADY

local YRPHookInitPostEntity = false
local YRPHookInitPostEntityFAKE = false
local serverreceived = false

YRPWasReadySendToServer = YRPWasReadySendToServer or false

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
			
		if YRPWasReadySendToServer == false then
			YRP.msg("note", "[YRPSendIsReadyPingPong] SEND TO SERVER.")
			net.Start("yrp_player_is_ready")
				net.WriteTable(info)
			net.SendToServer()
			YRPWasReadySendToServer = true

			timer.Simple(13, function()
				if !IsValid(lply) then return end

				if lply:GetNW2Bool("yrp_received_ready", false) == false then
					YRPWasReadySendToServer = false
					YRP.msg("note", "[YRPSendIsReadyPingPong] Retry sending ready message...")
					YRPSendIsReadyPingPong()
				end
			end)
		end
	else
		YRP.msg( "error", "[YRPSendIsReadyPingPong] System/os not ready, retry. win " .. tostring(system.IsWindows) .. " os " .. tostring(os.clock) .. " country " .. tostring(system.GetCountry) )
		timer.Simple(0.01, function()
			YRPSendIsReadyPingPong()
		end)
	end
end

function YRPSendIsReady()
	if YRPHookInitPostEntity or YRPHookInitPostEntityFAKE then
		YRP.msg("note", "[YRPSendIsReady] START")
		
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

		YRP.msg("note", ">> Workshop Addons Done <<")

		YRP.LoadDesignIcon()
	else
		if hook.GetTable()["InitPostEntity"]["yrp_InitPostEntity_ISREADY"] == nil then
			timer.Simple( 33, function()
				YRPHookInitPostEntityFAKE = true
			end )
		else
			timer.Simple( 0.1, YRPSendIsReady )
		end
	end
end

hook.Add("PostGamemodeLoaded", "yrp_PostGamemodeLoaded_ISREADY", function()
	YRPSendIsReady()
end)

hook.Add("InitPostEntity", "yrp_InitPostEntity_ISREADY", function()
	YRPHookInitPostEntity = true
end)
