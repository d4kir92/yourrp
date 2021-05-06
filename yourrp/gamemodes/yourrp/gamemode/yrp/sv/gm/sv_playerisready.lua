--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- #SENDISREADY #READY #PLAYERISREADY #ISREADY

local c = 0
function PlayerLoadedGame(ply)
	c = c + 1

	local tab = net.ReadTable()
	local OS_Windows = tab.iswindows
	local OS_Linux = tab.islinux
	local OS_OSX = tab.isosx
	local Country = tab.country
	local Branch = tab.branch
	--local UpTime = tab.uptime

	if OS_Windows then
		ply:SetDString("yrp_os", "windows")
	elseif OS_Linux then
		ply:SetDString("yrp_os", "linux")
	elseif OS_OSX then
		ply:SetDString("yrp_os", "osx")
	else
		ply:SetDString("yrp_os", "other")
	end
	ply:SetDString("gmod_branch", Branch or "Unknown")
	ply:SetDString("yrp_country", Country or "Unknown")
	ply:SetDFloat("uptime_current", os.clock())

	-- YRP Chat?
	local _chat = SQL_SELECT("yrp_general", "bool_yrp_chat", "uniqueID = 1")
	if _chat != nil and _chat != false then
		_chat = _chat[1]
		ply:SetDBool("bool_yrp_chat", tobool(_chat.yrp_chat))
	end

	ply:SetDBool("isserverdedicated", game.IsDedicated())

	ply:DesignLoadout("PlayerLoadedGame")

	local plyT = ply:GetPlyTab()
	if wk(plyT) then
		plyT.CurrentCharacter = tonumber(plyT.CurrentCharacter)
		if plyT.CurrentCharacter != -1 then
			ply:SetDInt("yrp_charid", tonumber(plyT.CurrentCharacter))
		end
	end

	SendDGlobals(ply)
	SendDEntities(ply, "PlayerLoadedGame")

	ply:SendTeamsToPlayer()
	
	ply:SetDBool("finishedloadingcharacter", true)

	if IsValid(ply) and ply.KillSilent then
		ply:KillSilent()
	end

	UpdateDarkRPTable(ply)

	YRP.msg("note", ">> " .. tostring(ply:YRPName()) .. " finished loading.")-- Count: " ..  c)
end

hook.Add("Think", "yrp_loaded_game", function()
	for i, ply in pairs(player.GetAll()) do
		if IsValid(ply) then
			if ply:GetDInt("yrp_load_glo", 0) == 100 and ply:GetDInt("yrp_load_ent", 0) == 100 and ply:SteamID64() != nil and ply.yrploaded == nil then -- Only goes here, when a player fully loaded
				ply.yrploaded = true

				ply:SetDBool("finishedloading", true)

				if open_character_selection != nil then
					open_character_selection(ply)
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
end)

util.AddNetworkString("yrp_player_is_ready")
net.Receive("yrp_player_is_ready", function(len, ply)
	if ply:IsValid() then
		ply:SetDBool("yrp_received_ready", true)
		PlayerLoadedGame(ply)
	else
		YRP.msg("error", "[yrp_player_is_ready] failed! [" .. tostring(ply:YRPName()) .. "] [" .. tostring(ply:SteamID()) .. "]")
	end
end)
