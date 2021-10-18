--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- #SENDISREADY #READY #PLAYERISREADY #ISREADY

local serverreceived = false
local YRPRetryCurtime = 0

YRPReadyStuck = YRPReadyStuck or {}
YRPReadyStuckCounter = YRPReadyStuckCounter or 0

YRPReadyHook = YRPReadyHook or false

function YRPReadyAddEvent( msg )
	if !table.HasValue( YRPReadyStuck, msg ) then
		table.insert( YRPReadyStuck, msg )
	end
end

local function YRPReadyHR( col )
	MsgC( col, "-------------------------------------------------------------------------------" .. "\n" )
end

local function YRPReadyMSG( msg, col )
	col = col or Color( 255, 0, 0 )
	YRPReadyHR( col )
	MsgC( col, "> " .. msg .. "\n" )
	YRPReadyHR( col )
end

function YRPGetClientInfo()
	local info = {}
	info.iswindows = system.IsWindows()
	info.islinux = system.IsLinux()
	info.isosx = system.IsOSX()
	info.country = system.GetCountry()
	info.branch = GetBranch()
	info.uptime = os.clock()
	return info
end

function YRPSendIsReadyPingPong()	-- IMPORTANT
	YRPReadyAddEvent( "PingPong" )

	local lply = LocalPlayer()

	if !IsValid(lply) then
		YRPReadyAddEvent( "LocalPlayer INVALID #1" )
		timer.Simple( 0.1, YRPSendIsReadyPingPong )
	else
		if system.IsWindows and os.clock and system.GetCountry and GetBranch and os.clock() and system.GetCountry() and GetBranch() then
			YRPReadyAddEvent( "OSReady" )
			local info = YRPGetClientInfo()
			
			if lply:GetNW2Bool( "yrp_received_ready", false ) == false then
				YRPReadyAddEvent( "Sended" )
				net.Start("yrp_is_ready_player")
					net.WriteTable( info )
				net.SendToServer()
				YRPReadyMSG( "SEND READY MESSAGE TO SERVER.", Color( 0, 255, 0 ) )
				
				YRPRetryCurtime = CurTime() + 3
			else
				YRPReadyMSG( "Server received the ready message.", Color( 0, 255, 0 ) )
			end
		else
			YRPReadyAddEvent( "OSNOTReady" )
			YRP.msg( "error", ">>> [YRPSendIsReadyPingPong] System/os not ready, retry. win " .. tostring(system.IsWindows) .. " os " .. tostring(os.clock) .. " country " .. tostring(system.GetCountry) )
			timer.Simple( 0.1, YRPSendIsReadyPingPong )
		end
	end
end

local delay = 0
hook.Add( "Think", "YRP_RETRYSENDMESSAGE", function()
	if CurTime() < delay then
		return
	end
	delay = CurTime() + 4

	lply = LocalPlayer()

	if IsValid(lply) and lply:GetNW2Bool( "yrp_received_ready", false ) == false and YRPRetryCurtime < CurTime() then
		YRPReadyMSG( "Retry sending ready message..." )
		YRPReadyAddEvent( "Retry" )
		YRPReadyStuckCounter = YRPReadyStuckCounter + 1
		YRPSendIsReadyPingPong()
	elseif lply:GetNW2Bool( "yrp_received_ready", false ) == true then
		YRPReadyMSG( "Server received the ready message!", Color( 0, 255, 0 ) )
		hook.Remove( "Think", "YRP_RETRYSENDMESSAGE" )
	end
end )

function YRPSendIsReady()
	YRPReadyAddEvent( "SendIsReady" )
	YRPReadyMSG( "SETUP READY MESSAGE", Color( 0, 255, 0 ) )

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
end

hook.Add("InitPostEntity", "yrp_InitPostEntity_ISREADY", function()
	YRP.msg( "note", "InitPostEntity -> ISREADY" )

	YRPReadyHook = true

	YRPReadyAddEvent( "InitPostEntity" )

	YRPSendIsReady()
end)
