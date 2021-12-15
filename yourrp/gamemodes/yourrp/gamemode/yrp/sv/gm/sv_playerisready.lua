--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- #SENDISREADY #READY #PLAYERISREADY #ISREADY

util.AddNetworkString( "yrp_chat_ready" )

util.AddNetworkString( "askforstartdata" )
util.AddNetworkString( "sendstartdata" )
util.AddNetworkString( "receivedstartdata" )

local ostab = {}
ostab[0] = "windows"
ostab[1] = "linux"
ostab[2] = "osx"
ostab[3] = "other"

function YRPPlayerLoadedGame(ply)
	ply:SetNW2Bool( "PlayerLoadedGameStart", true)

	timer.Simple( 1, function()
		ply:YRPDesignLoadout( "PlayerLoadedGame" )
	end )

	ply:SetupCharID()

	ply:SetNW2Bool( "finishedloadingcharacter", true)

	YRPSendCharCount(ply)
	
	if IsValid(ply) and ply.KillSilent then
		if GetGlobalBool( "bool_character_system", true) then
			ply:KillSilent()
		else
			ply:Spawn()
		end
	end

	timer.Simple( 2, function()
		UpdateDarkRPTable(ply)
	end )

	ply:UserGroupLoadout()

	YRP.msg( "note", ">> " .. tostring(ply:YRPName() ) .. " finished loading." )

	ply:SetNW2Bool( "PlayerLoadedGameEnd", true)

	timer.Simple( 3, function()
		if !IsValid(ply) then return end

		if ply.DRPSendTeamsToPlayer and ply.DRPSendCategoriesToPlayer then
			ply:DRPSendTeamsToPlayer()
			ply:DRPSendCategoriesToPlayer()
		end
		
		if ply.DRPSendTeamsToPlayer == nil then
			YRP.msg( "error", "Function not found! DRPSendTeamsToPlayer" )
		end
		if ply.DRPSendCategoriesToPlayer == nil then
			YRP.msg( "error", "Function not found! DRPSendCategoriesToPlayer" )
		end
	end )

	return true
end

hook.Add( "Think", "yrp_loaded_game", function()
	for i, ply in pairs(player.GetAll() ) do
		if IsValid(ply) then
			if ply:GetNW2Bool( "finishedloadingcharacter", false) == true and ply:SteamID64() != nil and ply.yrploaded == nil then -- Only goes here, when a player fully loaded
				ply.yrploaded = true

				ply:SetNW2Bool( "finishedloading", true)

				if YRPOpenCharacterSelection != nil then
					YRPOpenCharacterSelection(ply)
				else
					YRP.msg( "error", "YRPOpenCharacterSelection is NIL" )
				end

				net.Start( "yrp_noti" )
					net.WriteString( "playerisready" )
					net.WriteString(ply:Nick() )
				net.Broadcast()

				ply:ChatPrint( "!help for help" )

				if os.time() != nil and YRP_SQL_INSERT_INTO != nil then
					YRP_SQL_INSERT_INTO( "yrp_logs", "string_timestamp, string_typ, string_source_steamid, string_value", "'" .. os.time() .. "' ,'LID_connections', '" .. ply:SteamID64() .. "', '" .. "connected" .. "'" )
				end
			end
		end
	end
end, hook.MONITOR_HIGH)

local function YRPReceivedReadyMessage( len, ply, tab )
	if !IsValid(ply) then
		YRP.msg( "error", "[yrp_player_is_ready] player is not valid: " .. tostring( ply ) )
		return
	end

	if ostab[tab.os] == nil then
		YRP.msg( "error", "[yrp_player_is_ready] OS is invalid: " .. tostring( tab.os ) )
		return
	end

	tab.os = ostab[tab.os]

	local OS = tab.os
	local Country = tab.country
	local Branch = tab.branch

	YRP.msg( "note", "RECEIVED Client Info:" .. ply:YRPName() .. ": " .. OS .. " ( " .. Branch .. " )" .. " " .. "[" .. Country .. "]" .. " len: " .. tostring( len ) )
	
	if ply:GetNW2Bool( "yrp_received_ready", false ) == false then
		ply:SetNW2Bool( "yrp_received_ready", true )

		local OS = tab.os
		local Country = tab.country
		local Branch = tab.branch
	
		ply:SetNW2String( "yrp_os", OS )
	
		if Country == nil then
			YRP.msg( "error", ply:YRPName() .. " Client is broken, Country = " .. tostring( Country ) )
			ply:Kick( "YOUR GAME IS BROKEN! PLEASE VERIFY DATA" )
		end
	
		ply:SetNW2String( "gmod_branch", Branch or "Unknown" )
		ply:SetNW2String( "yrp_country", Country or "Unknown" )
		ply:SetNW2Float( "uptime_current", os.clock() )

		MsgC( Color( 0, 0, 255 ), "###############################################################################" .. "\n" )--##########

		MsgC( Color( 0, 0, 255 ), ply:SteamName() .. " is using OS: " .. ply:GetNW2String( "yrp_os", "-" ) .. " ( " .. tostring( Branch ) .. " )" .. "\n" )
		MsgC( Color( 0, 0, 255 ), ply:SteamName() .. " is from Country: " .. YRPGetCountryName( Country, "IS READY" ) .. "\n" )

		MsgC( Color( 0, 0, 255 ), "###############################################################################" .. "\n" )--##########
	
		local country = string.lower( ply:GetNW2String( "yrp_country" ) )
		local countries = GetGlobalString( "text_whitelist_countries", "" )
		countries = string.Explode( ",", countries, false )
		if GetGlobalBool( "yrp_allowallcountries", false ) or table.Count( countries ) == 0 or ( countries[1] and strEmpty( countries[1] ) ) then
			-- ALL ALLOWED
		else
			local found = false
			for i, v in pairs( countries ) do
				if string.lower( v ) == country then
					found = true
				end
				if string.lower( v ) == "all" then
					found = true
				end
			end
			if !found then
				YRP.msg( "note", "[Whitelist Countries] " .. ply:RPName() .. " was kicked, wrong country ( " .. tostring( country ) .. " )" )
				YRP.msg( "note", "[Whitelist Countries] F8 -> General -> Allowed Countries" )
				ply:Kick( "NOT ALLOWED TO ENTER THIS SERVER, SORRY (:" )
				return false
			end
		end

		YRPPlayerLoadedGame( ply )
	end
end

local function YRPAddReadyStatusMsg( ply, msg )
	ply.tabreadystatus = ply.tabreadystatus or {}
	if !table.HasValue( ply.tabreadystatus, msg ) then
		table.insert( ply.tabreadystatus, msg )
	end
	ply:SetNW2String( "yrp_ready_status", table.concat( ply.tabreadystatus, ", " ) )
end

function YRPAskForStartData( data )
	for i, ply in pairs( player.GetAll() ) do
		if ply:SteamID() == data.networkid then
			if ply:GetNW2Bool( "yrp_received_ready", false ) == false then
				YRPAddReadyStatusMsg( ply, "Send" )
				ply.readycounter = ply.readycounter or 0
				ply.readycounter = ply.readycounter + 1

				if ply.readycounter >= 30 then
					MsgC( Color( 0, 255, 0 ), "[START] [" .. ply:SteamName() .. "] Ask for StartData" .. " - try #" .. ply.readycounter .. "\n" )
				end

				net.Start( "askforstartdata" )
				net.Send( ply )

				YRPAddReadyStatusMsg( ply, "Sended" )

				if !YRPIsDoubleInstalled() and ply:GetNW2Bool( "yrp_received_ready", false ) == false and ply.readycounter >= ( 360 / 3 ) and ply.readycounter <= ( 390 / 3 ) then
					local text = "[START] [STUCK]"
					text = text .. " Status: " .. ply:GetNW2String( "yrp_ready_status", "X" )
					text = text .. " Counter: " .. tostring( ply.readycounter )
					text = text .. " ply: " .. ply:YRPName()
					text = text .. " Ver.: " .. YRPGetVersionFull()
					text = text .. " collectionid: " .. YRPCollectionID()
					text = text .. " serverip: " .. GetGlobalString( "serverip", "0.0.0.0:27015" )
					text = text .. " DI: "	.. tostring( YRPIsDoubleInstalled() )
					text = text .. " plys: " .. #player.GetAll() .. "/" .. game.MaxPlayers()
					YRP.msg( "error", text )
				end

				timer.Simple( 3, function()
					if IsValid( ply ) then
						if ply:GetNW2Bool( "yrp_received_ready", false ) == false then
							if ply.readycounter >= 30 then
								MsgC( Color( 255, 255, 0 ), "[START] [" .. ply:SteamName() .. "] RETRY Ask for StartData" .. " - try #" .. ply.readycounter .. "\n" )
							end
							YRPAddReadyStatusMsg( ply, "RETRY" )
							YRPAskForStartData( data )
						end
					end
				end )
			end
		end
	end
end

gameevent.Listen( "OnRequestFullUpdate" )
hook.Add( "OnRequestFullUpdate", "yrp_OnRequestFullUpdate_ISREADY", function( data )
	YRPAskForStartData( data )
end)

net.Receive( "sendstartdata", function( len, ply )
	local osid = net.ReadUInt( 2 )
	local branch = net.ReadString()
	local country = net.ReadString()

	YRPAddReadyStatusMsg( ply, "Received" )

	if ply:GetNW2Bool( "yrp_received_ready", false ) == false then
		ply.readycounter = ply.readycounter or 0
		MsgC( Color( 0, 255, 0 ), "[START] [" .. ply:SteamName() .. "] RECEIVED StartData" .. " at try #" .. ply.readycounter .. "\n" )

		net.Start( "receivedstartdata" )
		net.Send( ply )

		YRPAddReadyStatusMsg( ply, "Once" )

		local tab = {}
		tab["os"] = osid
		tab["branch"] = branch
		tab["country"] = country

		if !YRPCheckReadyTable( tab ) then
			YRP.msg( "error", "[yrp_player_is_ready] Ready Table is broken! #" .. i )
			return
		end

		YRPAddReadyStatusMsg( ply, "DONE" )

		YRPReceivedReadyMessage( len, ply, tab )
	end
end )
