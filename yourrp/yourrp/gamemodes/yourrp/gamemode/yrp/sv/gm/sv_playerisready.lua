--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- #SENDISREADY #READY #PLAYERISREADY #ISREADY

util.AddNetworkString( "yrp_chat_ready" )

util.AddNetworkString( "sendstartdata" )
util.AddNetworkString( "receivedstartdata" )

util.AddNetworkString( "sendserverdata" )
util.AddNetworkString( "receivedserverdata" )

net.Receive( "receivedserverdata", function( len, ply )
	ply.receivedserverdata = true
	MsgC( Color( 0, 255, 0 ), "[LOADING] SENDED SERVER DATA", "\n" )
end )

local function YRPPlayerLoadedGame( ply )
	ply:SetupCharID()

	ply:SetYRPBool( "finishedloadingcharacter", true)

	YRPSendCharCount( ply )
	
	ply:UserGroupLoadout()

	if IsValid(ply) and ply.KillSilent then
		if GetGlobalYRPBool( "bool_character_system", true) then
			ply:Spawn()
			ply:KillSilent()
		else
			ply:Spawn()
		end
	end

	YRP.msg( "note", ">> " .. tostring( ply:YRPName() ) .. " finished loading." )

	timer.Simple( 6, function()
		if !IsValid(ply) then return end
		UpdateDarkRPTable(ply)

		if ply.DRPSendTeamsToPlayer and ply.DRPSendCategoriesToPlayer then
			ply:DRPSendTeamsToPlayer()
			ply:DRPSendCategoriesToPlayer()
		else
			if ply.DRPSendTeamsToPlayer == nil then
				YRP.msg( "error", "Function not found! DRPSendTeamsToPlayer" )
			end
			if ply.DRPSendCategoriesToPlayer == nil then
				YRP.msg( "error", "Function not found! DRPSendCategoriesToPlayer" )
			end
		end
	end )

	timer.Simple( 12, function()
		if !IsValid(ply) then return end

		--MsgC( Color( 255, 255, 255, 255 ), "[LOADING] SEND SERVER DATA", "\n" )

		net.Start( "sendserverdata" )
		net.Send( ply )

		timer.Simple( 12, function()
			if !IsValid(ply) then return end
			
			if !ply.receivedserverdata then
				MsgC( Color( 255, 255, 0 ), "[LOADING] FAILED SEND SERVER DATA: " .. ply:Nick(), "\n" )
				YRPPlayerLoadedGame( ply )
			end
		end )
	end )

	return true
end

local function YRPStartSendingData( ply )
	ply.receivedserverdata = false
	YRPPlayerLoadedGame( ply )
end

local function YRPCheckFinishLoading()
	for i, ply in pairs( player.GetAll() ) do
		if IsValid( ply ) then
			if ply.yrploaded == nil and ply:SteamID() != nil and ply:GetYRPBool( "finishedloadingcharacter", false) == true then -- Only goes here, when a player fully loaded
				ply.yrploaded = true

				ply:SetYRPBool( "finishedloading", true)

				if YRPCLIENTOpenCharacterSelection != nil then
					if !ply:IsBot() then
						YRPCLIENTOpenCharacterSelection(ply)
					end
				else
					YRP.msg( "error", "YRPCLIENTOpenCharacterSelection is NIL" )
				end

				net.Start( "yrp_noti" )
					net.WriteString( "playerisready" )
					net.WriteString( ply:Nick() )
				net.Broadcast()

				ply:ChatPrint( "!help for help" )

				if os.time() != nil and YRP_SQL_INSERT_INTO != nil then
					YRP_SQL_INSERT_INTO( "yrp_logs", "string_timestamp, string_typ, string_source_steamid, string_value", "'" .. os.time() .. "' ,'LID_connections', '" .. ply:SteamID() .. "', '" .. "connected" .. "'" )
				end
			end
		end
	end
end

local function YRPCheckFinishLoadingLoop()
	local succ, err = pcall(YRPCheckFinishLoading)
	if err then
		YRPMsg(err)
	end

	timer.Simple( 0.1, YRPCheckFinishLoadingLoop )
end
YRPCheckFinishLoadingLoop()

local function YRPReceivedReadyMessage( len, ply, tab )
	if !IsValid(ply) then
		YRP.msg( "error", "[LOADING] player is not valid: " .. tostring( ply ) )
		return
	end
	
	local ostab = {}
	ostab[0] = "windows"
	ostab[1] = "linux"
	ostab[2] = "osx"
	ostab[3] = "other"

	if ostab[tab.os] == nil then
		YRP.msg( "error", "[LOADING] OS is invalid: " .. tostring( tab.os ) )
		return
	end

	tab.os = ostab[tab.os]

	local OS = tab.os
	local Country = tab.country
	local Branch = tab.branch
	local Beta = tab.beta
	
	ply:SetYRPString( "yrp_os", OS )

	if Country == nil then
		YRP.msg( "error", ply:YRPName() .. " Client is broken, Country = " .. tostring( Country ) )
		ply:Kick( "YOUR GAME IS BROKEN! PLEASE VERIFY DATA" )
	end

	ply:SetYRPString( "gmod_beta", Beta or "unknown" )
	ply:SetYRPString( "gmod_branch", Branch or "unknown" )
	ply:SetYRPString( "yrp_country", Country or "unknown" )
	ply:SetYRPFloat( "uptime_current", os.clock() )

	MsgC( Color( 0, 0, 255, 255 ), "###############################################################################" .. "\n" )--##########

	MsgC( Color( 0, 0, 255, 255 ), ply:SteamName() .. " is using OS: " .. ply:GetYRPString( "yrp_os", "-" ) .. " ( " .. tostring( Branch ) .. " )" .. "\n" )
	MsgC( Color( 0, 0, 255, 255 ), ply:SteamName() .. " is from Country: " .. YRPGetCountryName( Country, "IS READY" ) .. "\n" )
	if ply:GetYRPString( "gmod_beta", "unknown" ) != "unknown" then
		MsgC( Color( 0, 0, 255, 255 ), ply:SteamName() .. " is using GMod BETA: " .. ply:GetYRPString( "gmod_beta", "unknown" ) .. "\n" )
	end

	MsgC( Color( 0, 0, 255, 255 ), "###############################################################################" .. "\n" )--##########

	YRPStartSendingData( ply )
end

net.Receive( "sendstartdata", function( len, ply )
	local osid = net.ReadUInt( 2 )
	local branch = net.ReadString()
	local country = net.ReadString()
	local beta = net.ReadString()

	net.Start( "receivedstartdata" )
	net.Send( ply )

	--MsgC( Color( 255, 255, 255, 255 ), "[LOADING] CLIENT -> SERVER: Start Data", "\n" )

	local tab = {}
	tab["os"] = osid
	tab["branch"] = branch
	tab["country"] = country
	tab["beta"] = beta
	
	if !YRPCheckReadyTable( tab ) then
		YRP.msg( "error", "[LOADING] Ready Table is broken! #" .. ply.readycounter )
		return
	end

	if not ply.receivedstartdata then
		ply.receivedstartdata = true
		MsgC( Color( 0, 255, 0 ), "[LOADING] CLIENT -> SERVER: Start Data [ACCEPTED]", "\n" )

		YRPReceivedReadyMessage( len, ply, tab )
	end
end )
