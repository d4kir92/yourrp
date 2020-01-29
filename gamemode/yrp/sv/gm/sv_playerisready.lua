--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- #SENDISREADY #READY #PLAYERISREADY #ISREADY

function PlayerLoadedGame(ply)
	printGM("note", tostring(ply:YRPName()) .. " finished loading.")
	local tab = net.ReadTable()
	local OS_Windows = tab.iswindows
	local OS_Linux = tab.islinux
	local OS_OSX = tab.isosx
	local Country = tab.country

	if open_character_selection != nil then
		open_character_selection(ply)
	end

	if OS_Windows then
		ply:SetDString("yrp_os", "windows")
	elseif OS_Linux then
		ply:SetDString("yrp_os", "linux")
	elseif OS_OSX then
		ply:SetDString("yrp_os", "osx")
	else
		ply:SetDString("yrp_os", "other")
	end

	ply:SetDString("yrp_country", Country or "Unknown")

	-- YRP Chat?
	local _chat = SQL_SELECT("yrp_general", "bool_yrp_chat", "uniqueID = 1")
	if _chat != nil and _chat != false then
		_chat = _chat[1]
		ply:SetDBool("bool_yrp_chat", tobool(_chat.yrp_chat))
	end

	ply:SetDBool("isserverdedicated", game.IsDedicated())

	if IsValid(ply) and ply.KillSilent then
		ply:KillSilent()
	end

	SendDGlobals(ply)

	ply:DesignLoadout("PlayerLoadedGame")
	ply:SendTeamsToPlayer()
	
	ply:SetDBool("finishedloadingcharacter", true)

	SendDEntities(ply, "PlayerLoadedGame")

	ply:SetDBool("finishedloading", true)

	timer.Simple(6, function()
		net.Start("yrp_noti")
			net.WriteString("playerisready")
			net.WriteString(ply:Nick())
		net.Broadcast()
	end)
end

util.AddNetworkString("yrp_player_is_ready")
net.Receive("yrp_player_is_ready", function(len, ply)
	if ply:IsValid() then
		PlayerLoadedGame(ply)
	else
		YRP.msg("error", "[yrp_player_is_ready] failed! [" .. tostring(ply:YRPName()) .. "] [" .. tostring(ply:SteamID()) .. "]")
	end
end)
