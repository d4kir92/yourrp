--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- #SENDISREADY #READY #PLAYERISREADY #ISREADY

local YRPReady = false
local YRPReadyFake = false

local YRPStartDataStatus = "WAITING"
local YRPStartDataTab = {}
local YRPRetryCounter = 0

local YRPReceivedStartData = false
local langonce = true

function YRPGetYRPStartDataStatus()
	return YRPStartDataStatus
end

function YRPGetYRPRetryCounter()
	return YRPRetryCounter
end

function YRPGetYRPReceivedStartData()
	return YRPReceivedStartData
end

function YRPGetYRPReady()
	return YRPReady
end

local function YRPReadyHR( col )
	MsgC( col, "--------------------------------------------------------------------------------" .. "\n" )
end

local function YRPReadyMSG( msg, col )
	col = col or Color( 255, 100, 100 )
	YRPReadyHR( col )
	MsgC( col, "> " .. msg .. "\n" )
	YRPReadyHR( col )
end

function YRPGetClientInfo()
	local info = {}
	if system.IsWindows() then
		info.os = 0
	elseif system.IsLinux() then
		info.os = 1
	elseif system.IsOSX() then
		info.os = 2
	else
		info.os = 3
	end
	info.country = system.GetCountry()
	info.branch = GetBranch()
	return info
end

local function YRPAddReadyStatusMsg( msg )
	YRPStartDataTab = YRPStartDataTab or {}
	if !table.HasValue( YRPStartDataTab, msg ) then
		table.insert( YRPStartDataTab, msg )
	end
	YRPStartDataStatus = table.concat( YRPStartDataTab, ", " )
end

function YRPSendAskData( from )
	YRPRetryCounter = YRPRetryCounter + 1
	if CurTime() <= 0 then
		YRPAddReadyStatusMsg( "CurTime() is <= 0" )
		YRPHR( Color( 255, 0, 0 ) )
		MsgC( Color( 255, 0, 0 ), "[START] CurTime() <= 0, Retry..." .. "\n" )
		YRPHR( Color( 255, 0, 0 ) )

		YRP.msg( "error", "[START] Curtime is <= 0" )
		timer.Simple( 0.01, function()
			YRPSendAskData( from )
		end )
	else
		local info = YRPGetClientInfo()

		YRPAddReadyStatusMsg( "Send" )
		
		net.Start( "sendstartdata" )
			net.WriteUInt( info.os, 2 )
			net.WriteString( info.branch )
			net.WriteString( info.country )
		net.SendToServer()

		MsgC( Color( 0, 255, 0 ), "[START] Sended StartData" .. "\n" )

		timer.Simple( 1, function()
			if YRPReceivedStartData then
				--
			elseif YRPReceivedStartData == false then
				YRPAddReadyStatusMsg( "SERVER NOT RECEIVED -> RETRY" )
				local text = "[START] Server not received the StartData, retry..."
				MsgC( Color( 255, 255, 0 ), text .. "\n" )
			end
		end )

		if langonce then
			langonce = false
			YRP.initLang()
		end
	end
end

net.Receive( "askforstartdata", function( len )
	if YRPReady or YRPReadyFake then
		local from = net.ReadString()

		YRPSendAskData( from )
	elseif !YRPReady then
		YRPAddReadyStatusMsg( "MAP IS LOADING!" )
		YRP.msg( "note", "MAP IS LOADING!" )
	end
end )

net.Receive( "YRPReceivedStartData", function( len )
	YRPReceivedStartData = true
	YRPHR( Color( 0, 255, 0 ) )
	MsgC( Color( 0, 255, 0 ), "[START] Server RECEIVED StartData" .. "\n" )

	YRPAddReadyStatusMsg( "SERVER RESPONDED" )
	YRPHR( Color( 0, 255, 0 ) )

	YRP.initLang()
end )

hook.Add( "InitPostEntity", "YRP_INITPOSTENTITY", function()
	YRP.msg( "note", "ALL ENTITIES ARE LOADED! #1" )
	YRPAddReadyStatusMsg( "ALL ENTITIES ARE LOADED! #1" )
	YRPReady = true
	YRPSendAskData( "HOOK InitPostEntity" )
end )

function GM:InitPostEntity()
	YRP.msg( "note", "ALL ENTITIES ARE LOADED! #2" )
	YRPAddReadyStatusMsg( "ALL ENTITIES ARE LOADED! #2" )
	YRPReady = true
	YRPSendAskData( "GM InitPostEntity" )
end

timer.Simple( 60, function()
	YRPAddReadyStatusMsg( "FAKE LOADED!" )
	YRPReadyFake = true
end )
