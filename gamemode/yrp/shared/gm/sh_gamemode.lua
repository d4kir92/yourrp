--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

--here you can change this, but it's dumb, because you can change it ingame
GM.Name = "DarkRP" -- Is for other addons detecting that the gamemode is "DarkRP" compatible
GM.BaseName = "YourRP" -- DO NOT CHANGE THIS, thanks

DeriveGamemode("sandbox")

-- >>> do NOT change this! (it can cause crashes and more!) <<<
GM.ShortName = "YRP"	--do NOT change this!
GM.Author = "D4KiR" --do NOT change this!
GM.Discord = "https://discord.gg/sEgNZxg" --do NOT change this!
GM.Email = GM.Discord --do NOT change this!
GM.Website = "https://sites.google.com/view/yrp" --do NOT change this!
GM.Youtube = "youtube.com/c/D4KiR" --do NOT change this!
GM.Twitter = "twitter.com/D4KIR" --do NOT change this!
GM.Help = "Create your rp you want to make!" --do NOT change this!
GM.dedicated = "-" --do NOT change this!
GM.VersionStable = 0 --do NOT change this!
GM.VersionBeta = 135 --do NOT change this!
GM.VersionCanary = 272 --do NOT change this!
GM.Version = GM.VersionStable .. "." .. GM.VersionBeta .. "." .. GM.VersionCanary --do NOT change this!
GM.VersionSort = "outdated" --do NOT change this! --stable, beta, canary
GM.rpbase = "YourRP" --do NOT change this! <- this is not for server browser
GM.ServerIsDedicated = game.IsDedicated()

function GetRPBase()
	return GAMEMODE.rpbase
end

VERSIONART = "github"
for i, wsi in pairs(engine.GetAddons()) do
	if tostring(wsi.wsid) == "1114204152" then
		VERSIONART = "workshop"
	end
end

function ChangeChannel(channel)
	if channel == "stable" or channel == "beta" or channel == "canary" then
		GAMEMODE.VersionSort = channel
		printGM("gm", "Switched to " .. tostring(channel))
	else
		printGM("error", "Switched to not available channel (" .. tostring(channel) .. ")")
	end
end

function GM:Initialize()
	self.BaseClass.Initialize(self)
end

function GM:GetGameDescription()
	return GAMEMODE.BaseName
end

function GetNiceMapName()
	local map = game.GetMap()
	local _first = string.find(map, "_", 1, false)
	if _first != nil then
		map = string.sub(map, _first + 1)
	end
	map = string.Explode("_", map)
	local _new_map = {}
	for i, str in pairs(map) do
		local _tab = string.Explode("", str)
		local _insert = true
		for j, char in pairs(_tab) do
			if isnumber(tonumber(char)) then
				_insert = false
				break
			end
		end
		if _insert then
			table.insert(_new_map, str)
		end
	end
	map = string.Implode(" ", _new_map)
	return string.upper(map)
end

function GetMapName()
	return game.GetMap()
end

function GetMapNameDB()
	return string.lower(SQL_STR_IN(game.GetMap()))
end

concommand.Add("yrp_version", function(ply, cmd, args)
	hr_pre("gm")
	local _text = "Gamemode - Version:\t" .. GAMEMODE.Version .. " (" .. string.upper(GAMEMODE.VersionSort) .. ")"
	printGM("gm", _text)
	hr_pos("gm")
end)

concommand.Add("yrp_status", function(ply, cmd, args)
	local _text = "Gamemode - Version:\t" .. GAMEMODE.Version
	if IsYRPOutdated() == nil then
		_text = _text .. " (Checking)"
	elseif IsYRPOutdated() then
		_text = _text .. " (OUTDATED!)"
	end

	hr_pre("gm")
	printGM("gm", "    Version: " .. GAMEMODE.Version)
	printGM("gm", "    Channel: " .. string.upper(GAMEMODE.VersionSort))
	printGM("gm", " Servername: " .. GetHostName())
	printGM("gm", "         IP: " .. game.GetIPAddress())
	printGM("gm", "        Map: " .. GetMapNameDB())
	printGM("gm", "    Players: " .. tostring(player.GetCount()) .. "/" .. tostring(game.MaxPlayers()))
	hr_pos("gm")
end)

concommand.Add("yrp_maps", function(ply, cmd, args)
	hr_pre("gm")
	printGM("gm", "[MAPS ON SERVER]")
	local allmaps = file.Find("maps/*.bsp", "GAME", "nameasc")
	for i, map in pairs(allmaps) do
		local mapname = string.Replace(map, ".bsp", "")
		printGM("gm", i .. "\t" .. mapname)
	end
	hr_pos("gm")
end)

concommand.Add("yrp_map", function(ply, cmd, args)
	hr_pre("gm")
	printGM("gm", "[Changelevel]")
	local allmaps = file.Find("maps/*.bsp", "GAME", "nameasc")
	for i, map in pairs(allmaps) do
		local mapname = string.Replace(map, ".bsp", "")
		allmaps[i] = mapname
	end
	local id = tonumber(args[1])
	local map = allmaps[id]
	if map != nil then
		if SERVER then
			printGM("gm", "Changelevel to " .. map)
			RunConsoleCommand("changelevel", map)
		else
			printGM("gm", "ONLY AVAILABLE ON SERVER")
		end
	else
		printGM("gm", "ID OUT OF RANGE")
	end
	hr_pos("gm")
end)

function makeString(tab, str_len, cut)
	local _result = ""
	for i = 1, str_len do
		if tab[i] != nil then
			_result = _result .. tab[i]
		elseif i >= str_len-3 and cut then
			_result = _result .. "."
		else
			_result = _result .. " "
		end
	end
	return _result
end

concommand.Add("yrp_players", function(ply, cmd, args)
	hr_pre("gm")
	printGM("gm", "Players:\t" .. tostring(player.GetCount()) .. "/" .. tostring(game.MaxPlayers()))
	printGM("gm", "ID   SteamID              Name                     Money")
	for i, pl in pairs(player.GetAll()) do
		local _id = makeString(string.ToTable(pl:UserID()), 4, false)
		local _steamid = makeString(string.ToTable(pl:SteamID()), 20, false)
		local _name = makeString(string.ToTable(pl:YRPName()), 24, true)
		local _money = makeString(string.ToTable(pl:GetDString("money", -1)), 12, false)
		local _str = string.format("%s %s %s %s", _id, _steamid, _name, _money)
		printGM("gm", _str)
	end
	hr_pos("gm")
end)

function PrintHelp()
	hr_pre("note")
	printGM("note", "Shared Commands:")
	printGM("note", "yrp_status")
	printGM("note", "	Shows info")
	printGM("note", "yrp_version")
	printGM("note", "	Shows gamemode version")
	printGM("note", "yrp_players")
	printGM("note", "	Shows all players")
	printGM("note", "yrp_usergroup RPNAME UserGroup")
	printGM("note", "	Put a player with the RPNAME to the UserGroup")
	printGM("note", "yrp_maps")
	printGM("note", "	Shows all maps on server")
	printGM("note", "yrp_map ID")
	printGM("note", "	Changelevel to map ID")
	printGM("note", "yrp_collection / yrp_collectionid")
	printGM("note", "	Shows servers collectionid")
	hr_pos("note")

	hr_pre("note")
	printGM("note", "Client Commands:")
	printGM("note", "yrp_cl_hud X")
	printGM("note", "	1: Shows hud, 0: Hide hud")
	printGM("note", "yrp_togglesettings")
	printGM("note", "	Toggle settings menu")
	hr_pos("note")
end

concommand.Add("yrp_help", function(ply, cmd, args)
	PrintHelp()
end)

concommand.Add("yrp__help", function(ply, cmd, args)
	PrintHelp()
end)

function PrintCollectionID()
	hr_pre("note")
	printGM("note", "Server - CollectionID: " .. YRPCollectionID())
	hr_pos("note")
end
concommand.Add("yrp_collectionid", function(ply, cmd, args)
	PrintCollectionID()
end)
concommand.Add("yrp_collection", function(ply, cmd, args)
	PrintCollectionID()
end)

hook.Add("StartCommand", "NoJumpGuns", function(ply, cmd)
	if GetGlobalDBool("bool_anti_bhop", false) and !ply:GetDBool("canjump", false) and ply:GetMoveType() != MOVETYPE_NOCLIP then
		cmd:RemoveKey(IN_JUMP)
	end
end)

function IsEntityAlive(ply, uid)
	for i, ent in pairs(ents.GetAll()) do
		if tostring(ent:GetDString("item_uniqueID", "")) == tostring(uid) and ent:GetRPOwner() == ply then
			return true, ent
		end
	end
	return false
end

if SERVER then
	util.AddNetworkString("GetServerInfo")
	net.Receive("GetServerInfo", function(len, ply)
		local tab = {}
		tab.Version = GAMEMODE.Version
		tab.VersionStable = GAMEMODE.VersionStable
		tab.VersionBeta = GAMEMODE.VersionBeta
		tab.VersionCanary = GAMEMODE.VersionCanary
		tab.isdedicated = game.IsDedicated()
		net.Start("GetServerInfo")
			net.WriteTable(tab)
		net.Send(ply)
	end)

	local tmp = SQL_SELECT("yrp_general", "text_gamemode_name", nil)
	if wk(tmp) then
		tmp = tmp[1]
		GM.BaseName = SQL_STR_OUT(tmp.text_gamemode_name)
	end

	util.AddNetworkString("getGamemodename")
	net.Receive("getGamemodename", function(len, ply)
		net.Start("getGamemodename")
			net.WriteString(GAMEMODE.BaseName)
		net.Send(ply)
	end)
end

if CLIENT then
	net.Receive("getGamemodename", function(len)
		GAMEMODE.BaseName = net.ReadString()
	end)

	timer.Simple(1, function()
		net.Start("getGamemodename")
		net.SendToServer()
	end)
end

-- Multicore (Shared) enable:
RunConsoleCommand("gmod_mcore_test", "1")
RunConsoleCommand("mat_queue_mode", "-1")
RunConsoleCommand("studio_queue_mode", "1")
RunConsoleCommand("r_hunkalloclightmaps", "0")

-- Enable Errorlog
RunConsoleCommand("lua_log_sv", "1")

if CLIENT then
	-- Enable Errorlog
	RunConsoleCommand("lua_log_cl", "1")

	-- Multicore (Client) enable:
	RunConsoleCommand("cl_threaded_bone_setup", "1")
	RunConsoleCommand("cl_threaded_client_leaf_system", "1")
	RunConsoleCommand("r_threaded_particles", "1")
	RunConsoleCommand("r_threaded_renderables", "1")
	RunConsoleCommand("r_threaded_client_shadow_manager", "1")
	RunConsoleCommand("r_queued_ropes", "1")
elseif SERVER then
	-- "removes" voice icons
	RunConsoleCommand("mp_show_voice_icons", "0")
end

-- Reconnect
--[[
if CLIENT then
	local lost_connection = false
	local recon_delay = CurTime() + 1
	local retry_sec = 10
	local recon_sec = 42
	local server_pong = CurTime() + retry_sec
	net.Receive("pingpong", function()
		server_pong = CurTime() + retry_sec
		lost_connection = false
	end)
	hook.Add("Think", "yrp_reconnect_think", function()
		if recon_delay < CurTime() then
			recon_delay = CurTime() + 1
			if CurTime() >= server_pong + recon_sec then
				lost_connection = true
				YRP.msg("note", "RETRY")
				RunConsoleCommand("retry")
			elseif CurTime() > server_pong then
				lost_connection = true
				local time = math.Round((server_pong + recon_sec) - CurTime(), 0)
				local tab = {}
				tab["SECONDS"] = time
				YRP.msg("note", YRP.lang_string("LID_lostconnection") .. "! " .. YRP.lang_string("LID_retryinxsec", tab))
			end
		end
	end)
	hook.Add("HUDPaint", "yrp_reconnect_hud", function()
		if lost_connection then
			local time = math.Round((server_pong + recon_sec) - CurTime(), 0)
			local tab = {}
			tab["SECONDS"] = time
			draw.SimpleText(YRP.lang_string("LID_lostconnection") .. "! " .. YRP.lang_string("LID_retryinxsec", tab), "YRP_36_500", ScrW() / 2, ScrH() / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end)
elseif SERVER then
	util.AddNetworkString("pingpong")

	timer.Create("yrp_pingpong", 5, 0, function()
		net.Start("pingpong")
		net.Broadcast()
	end)
end
]]
