--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- #SENDISREADY #READY #PLAYERISREADY #ISREADY

util.AddNetworkString("yrp_ready_received")

function PlayerLoadedGame(ply, tab)
	ply:SetNW2Bool("PlayerLoadedGameStart", true)

	local OS_Windows = tab.iswindows
	local OS_Linux = tab.islinux
	local OS_OSX = tab.isosx
	local Country = tab.country
	local Branch = tab.branch
	--local UpTime = tab.uptime

	if OS_Windows then
		ply:SetNW2String("yrp_os", "windows")
	elseif OS_Linux then
		ply:SetNW2String("yrp_os", "linux")
	elseif OS_OSX then
		ply:SetNW2String("yrp_os", "osx")
	else
		ply:SetNW2String("yrp_os", "other")
	end
	ply:SetNW2String("gmod_branch", Branch or "Unknown")
	ply:SetNW2String("yrp_country", Country or "Unknown")
	ply:SetNW2Float("uptime_current", os.clock())

	-- YRP Chat?
	local _chat = SQL_SELECT("yrp_general", "bool_yrp_chat", "uniqueID = 1")
	if _chat != nil and _chat != false then
		_chat = _chat[1]
		ply:SetNW2Bool("bool_yrp_chat", tobool(_chat.yrp_chat))
	end

	ply:YRPDesignLoadout("PlayerLoadedGame")

	local plyT = ply:GetPlyTab()
	if wk(plyT) then
		plyT.CurrentCharacter = tonumber(plyT.CurrentCharacter)
		if plyT.CurrentCharacter != -1 then
			ply:SetNW2Int("yrp_charid", tonumber(plyT.CurrentCharacter))
		end
	end

	ply:SetNW2Bool("finishedloadingcharacter", true)

	YRPSendCharCount(ply)
	
	if IsValid(ply) and ply.KillSilent then
		if GetGlobalBool("bool_character_system", true) then
			ply:KillSilent()
		else
			ply:Spawn()
		end
	end

	UpdateDarkRPTable(ply)

	ply:UserGroupLoadout()

	YRP.msg("note", ">> " .. tostring(ply:YRPName()) .. " finished loading.")

	ply:SetNW2Bool("PlayerLoadedGameEnd", true)

	net.Start("yrp_ready_received")
	net.Send(ply)
end

hook.Add("Think", "yrp_loaded_game", function()
	for i, ply in pairs(player.GetAll()) do
		if IsValid(ply) then
			if ply:GetNW2Bool("finishedloadingcharacter", false) == true and ply:SteamID64() != nil and ply.yrploaded == nil then -- Only goes here, when a player fully loaded
				ply.yrploaded = true

				ply:SetNW2Bool("finishedloading", true)

				if YRPOpenCharacterSelection != nil then
					YRPOpenCharacterSelection(ply)
				else
					YRP.msg("error", "YRPOpenCharacterSelection is NIL")
				end

				net.Start("yrp_noti")
					net.WriteString("playerisready")
					net.WriteString(ply:Nick())
				net.Broadcast()

				ply:ChatPrint("!help for help")

				if os.time() != nil and SQL_INSERT_INTO != nil then
					SQL_INSERT_INTO("yrp_logs", "string_timestamp, string_typ, string_source_steamid, string_value", "'" .. os.time() .. "' ,'LID_connections', '" .. ply:SteamID64() .. "', '" .. "connected" .. "'")
				end
			end
		end
	end
end, hook.MONITOR_HIGH)

util.AddNetworkString("yrp_player_is_ready")
net.Receive("yrp_player_is_ready", function(len, ply)
	local tab = net.ReadTable()

	if !IsValid(ply) then
		YRP.msg( "error", "[yrp_player_is_ready] player is not valid: " .. tostring( ply ) )
		return
	end

	if ply:GetNW2Bool("yrp_received_ready", false) == false then
		ply:SetNW2Bool("yrp_received_ready", true)
		PlayerLoadedGame(ply, tab)
	else
		YRP.msg( "note", "[yrp_player_is_ready] Already got the ready message" )
	end
end)
