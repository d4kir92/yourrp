--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

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
		ply:SetNWString("yrp_os", "windows")
	elseif OS_Linux then
		ply:SetNWString("yrp_os", "linux")
	elseif OS_OSX then
		ply:SetNWString("yrp_os", "osx")
	else
		ply:SetNWString("yrp_os", "other")
	end

	ply:SetNWString("yrp_country", Country or "Unknown")

	-- YRP Chat?
	local _chat = SQL_SELECT("yrp_general", "bool_yrp_chat", "uniqueID = 1")
	if _chat != nil and _chat != false then
		_chat = _chat[1]
		ply:SetNWBool("bool_yrp_chat", tobool(_chat.yrp_chat))
	end

	ply:SetNWBool("isserverdedicated", game.IsDedicated())

	ply:SetNWBool("finishedloading", true)

	ply:KillSilent()

	net.Start("yrp_noti")
		net.WriteString("playerisready")
		net.WriteString(ply:Nick())
	net.Broadcast()
end

util.AddNetworkString("yrp_player_is_ready")
net.Receive("yrp_player_is_ready", function(len, ply)
	if ply:IsValid() then
		PlayerLoadedGame(ply)
	else
		YRP.msg("error", "[yrp_player_is_ready] failed! [" .. tostring(ply:YRPName()) .. "] [" .. tostring(ply:SteamID()) .. "]")
	end
end)
