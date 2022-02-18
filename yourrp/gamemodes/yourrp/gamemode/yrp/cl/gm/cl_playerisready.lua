--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- #SENDISREADY #READY #PLAYERISREADY #ISREADY

yrpstartedsending = yrpstartedsending or false
yrpreceivedstartdata = yrpreceivedstartdata or false
yrpreceivedserverdata = yrpreceivedserverdata or false

function YRPReceivedStartData()
	return yrpreceivedstartdata
end

function YRPReceivedServerData()
	return yrpreceivedserverdata
end

local function YRPGetClientInfo()
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
	info.beta = BRANCH or "unknown"

	return info
end

net.Receive( "receivedstartdata", function( len )
	MsgC( Color( 0, 255, 0 ), "[LOADING] SERVER -> CLIENT: Server Received Start Data", "\n" )
	yrpreceivedstartdata = true
end)

local function YRPSendAskData( from )
	local info = YRPGetClientInfo()

	net.Start( "sendstartdata" )
		net.WriteUInt( info.os, 2 )
		net.WriteString( info.branch )
		net.WriteString( info.country )
		net.WriteString( info.beta )
	net.SendToServer()

	MsgC( Color( 255, 255, 255 ), "[LOADING] Sended StartData", "\n" )

	timer.Simple( 8, function()
		if !yrpreceivedstartdata then
			MsgC( Color( 255, 255, 0 ), "[LOADING] Retry Send StartData", "\n" )
			YRPSendAskData( "RETRY" )
		end
	end )
end

local function YRPStartSendingStartData( from )
	if !yrpstartedsending then
		yrpstartedsending = true
		YRPSendAskData( from )

		YRP.initLang()
	end
end

hook.Add( "InitPostEntity", "YRP_INITPOSTENTITY", function()
	YRPStartSendingStartData( "HOOK InitPostEntity" )
end )

function GM:InitPostEntity()
	YRPStartSendingStartData( "GM InitPostEntity" )
end

net.Receive( "sendserverdata", function( len )
	if !yrpreceivedserverdata then
		yrpreceivedserverdata = true

		net.Start( "receivedserverdata" )
		net.SendToServer()
	end
end )