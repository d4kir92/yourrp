--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

--here you can change this, but it's dumb, because you can change it ingame
GM.Name = "DarkRP" -- Is for other addons detecting that the gamemode is "DarkRP" compatible
GM.BaseName = "YourRP" -- DO NOT CHANGE THIS, thanks

DeriveGamemode( "sandbox" )

-- >>> do NOT change this! (it can cause crashes and more!) <<<
GM.ShortName = "YRP" -- do NOT change this!
GM.Author = "D4KiR" -- do NOT change this!
GM.Discord = "https://discord.gg/sEgNZxg" -- do NOT change this!
GM.Email = GM.Discord -- do NOT change this!
GM.Website = "" -- do NOT change this!
GM.Youtube = "youtube.com/c/D4KiR" -- do NOT change this!
GM.Twitter = "twitter.com/D4KIR" -- do NOT change this!
GM.Help = "Create your rp you want to make!" -- do NOT change this!
GM.dedicated = "-" -- do NOT change this!
GM.VersionStable = 0 -- do NOT change this!
GM.VersionBeta = 352 -- do NOT change this!
GM.VersionCanary = 707 -- do NOT change this!
GM.VersionBuild = 225 -- do NOT change this!
GM.Version = GM.VersionStable .. "." .. GM.VersionBeta .. "." .. GM.VersionCanary -- do NOT change this!
GM.VersionSort = "outdated" -- do NOT change this! --stable, beta, canary
GM.rpbase = "YourRP" -- do NOT change this! <- this is not for server browser
GM.ServerIsDedicated = game.IsDedicated()

local gmvs = GM.VersionStable
local gmvb = GM.VersionBeta
local gmvc = GM.VersionCanary
local gmbn = GM.VersionBuild

function YRPGetVersion()
	return gmvs .. "." .. gmvb .. "." .. gmvc
end

function YRPGetVersionFull()
	return YRPGetVersion() .. ":" .. gmbn
end

function GetRPBase()
	return GAMEMODE.rpbase
end

function GetBranch()
	local branch = jit.arch
	branch = string.Replace( branch, "x64", "64Bit" )
	branch = string.Replace( branch, "x86", "32Bit" )
	return branch
end

function YRPIsDoubleInstalled()
	return GetGlobalYRPBool( "yrp_double_installed", false )
end

if SERVER then
	local doubleinstalledpath = ""
	SetGlobalYRPString( "YRP_VERSIONART", "GITHUB" )

	for i, wsi in pairs( engine.GetAddons() ) do
		if tostring( wsi.wsid ) == "1114204152" then
			SetGlobalYRPString( "YRP_VERSIONART", "WORKSHOP" )

			if file.Exists( "gamemodes/yourrp/yourrp.txt", "MOD" ) then
				SetGlobalYRPBool( "yrp_double_installed", true )
				doubleinstalledpath = "yourrp"
			end
			if file.Exists( "gamemodes/militaryrp/militaryrp.txt", "MOD" ) then
				SetGlobalYRPBool( "yrp_double_installed", true )
				doubleinstalledpath = "militaryrp"
			end
			if file.Exists( "gamemodes/starwarsrp/starwarsrp.txt", "MOD" ) then
				SetGlobalYRPBool( "yrp_double_installed", true )
				doubleinstalledpath = "starwarsrp"
			end
		end
	end

	local delay = 0
	local count = 0
	local dir = 1
	hook.Remove( "Think", "yrp_double_installed" )
	hook.Add( "Think", "yrp_double_installed", function()
		if CurTime() < delay then
			return
		end
		delay = CurTime() + 1

		count = count + dir

		if count > 3 then
			dir = -1
			count = 20
		elseif count == 0 then
			dir = 1
		end

		if YRPIsDoubleInstalled() and dir == 1 then
			YRPHR( YRPColGreen() )
			MsgC( YRPColGreen(), "[YourRP] YourRP is DOUBLE installed!" .. "\n" )
			MsgC( YRPColGreen(), "[YourRP] Please REMOVE the folder: Server/garrysmod/gamemodes/" .. tostring( doubleinstalledpath ) .. " <-" .. "\n" )
			MsgC( YRPColGreen(), "[YourRP] You will not lose your Data (Data is saved in: Server/garrysmod/sv.db)" .. "\n" )
			YRPHR( YRPColGreen() )
		end
	end)
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
	map = string.Explode( "_", map)
	local _new_map = {}
	for i, str in pairs(map) do
		local _tab = string.Explode( "", str)
		local _insert = true
		for j, char in pairs(_tab) do
			if isnumber(tonumber( char) ) then
				_insert = false
				break
			end
		end
		if _insert then
			table.insert(_new_map, str)
		end
	end
	map = string.Implode( " ", _new_map)
	return string.upper(map)
end

function GetMapName()
	return game.GetMap()
end

function GetMapNameDB()
	local mapname = game.GetMap()
	mapname = string.Replace(mapname, "-", "_" )
	mapname = string.Replace(mapname, " ", "_" )
	return string.lower(mapname)
end

-- bool to number
function tonum( bo)
	if bo then
		return 1
	else
		return 0
	end
end

function StringToColor(str)
	if type(str) == "string" then
		local _col = string.Explode( ",", str)
		return Color(_col[1] or 0, _col[2] or 0, _col[3] or 0, _col[4] or 255)
	else
		return Color( 255, 0, 0, 255)
	end
end

function StringToPlayerVector(str)
	local color = StringToColor(str)
	return Vector( color.r / 255, color.g / 255, color.b / 255, color.a )
end

function StringToVector(str)
	if type(str) == "string" then
		local _vec = string.Explode( ",", str)
		return Vector(_vec[1] or 0, _vec[2] or 0, _vec[3] or 0)
	else
		return Vector(0, 0, 0)
	end
end

function StringToVector2(str)
	if type(str) == "string" then
		local _vec = string.Explode( ",", str)
		return Vector(_vec[1] or 0, _vec[2] or 0, _vec[3] or 0), Vector(_vec[4] or 0, _vec[5] or 0, _vec[6] or 0)
	else
		return Vector(0, 0, 0), Vector(0, 0, 0)
	end
end

function YRPSP()
	MsgC( "\n" )
end

function YRPHR( color )
	color = color or GetRealmColor()
	MsgC( color, "--------------------------------------------------------------------------------" .. "\n" )
end

function YRPMsg( text, color )
	color = color or GetRealmColor()
	MsgC( color, text, "\n" )
end

concommand.Add( "yrp_version", function(ply, cmd, args)
	local _text = "Gamemode-Version: " .. YRPGetVersionFull() .. " ( " .. string.upper( GAMEMODE.VersionSort ) .. " ) [" .. GetGlobalYRPString( "YRP_VERSIONART", "X" ) .. "]"
	local _color = YRPColGreen()
	if string.upper( GAMEMODE.VersionSort ) == "OUTDATED" then
		_color = YRPColGreen()
	end

	YRPHR( _color )
	YRPMsg( _text, _color )
	YRPHR( _color )
end)

concommand.Add( "yrp_status", function(ply, cmd, args)
	YRPHR()
	YRPMsg( string.format( "%14s %s", "Version:", YRPGetVersionFull() .. " ( " .. string.upper(GAMEMODE.VersionSort) .. " ) [" .. GetGlobalYRPString( "YRP_VERSIONART", "X" ) .. "]" ) )
	YRPMsg( string.format( "%14s %s", "Servername:", YRPGetHostName() ) )
	YRPMsg( string.format( "%14s %s", "IP:", game.GetIPAddress() ) )
	YRPMsg( string.format( "%14s %s", "Map:", GetMapNameDB() ) )
	YRPMsg( string.format( "%14s %s", "Players:", tostring(player.GetCount() ) .. "/" .. tostring(game.MaxPlayers() ) ) )
	YRPHR()
end)

concommand.Add( "yrp_maps", function(ply, cmd, args)
	YRPHR()
	YRPMsg( "[MAPS ON SERVER]" )
	local allmaps = file.Find( "maps/*.bsp", "GAME", "nameasc" )
	for i, map in pairs( allmaps) do
		local mapname = string.Replace(map, ".bsp", "" )
		YRPMsg(i .. "\t" .. mapname)
	end
	YRPHR()
end)

concommand.Add( "yrp_map", function(ply, cmd, args)
	YRPHR()
	YRPMsg( "[Changelevel]" )
	local allmaps = file.Find( "maps/*.bsp", "GAME", "nameasc" )
	for i, map in pairs( allmaps) do
		local mapname = string.Replace(map, ".bsp", "" )
		allmaps[i] = mapname
	end
	local id = tonumber( args[1])
	local map = allmaps[id]
	if map != nil then
		if SERVER then
			YRPMsg( "Changelevel to " .. map)
			RunConsoleCommand( "changelevel", map)
		else
			YRPMsg( "ONLY AVAILABLE ON SERVER" )
		end
	else
		YRPMsg( "ID OUT OF RANGE" )
	end
	YRPHR()
end)

function makeString(str, len)
	str = string.sub( str, 1, len )
	str = string.format( "%-" .. len .. "s", str )
	return str
end

concommand.Add( "yrp_players", function(ply, cmd, args)
	YRPHR( Color( 255, 255, 0 ) )
	local structure = "%-4s %-20s %-10s %-10s %-20s"
	MsgC( Color( 255, 255, 0 ), "Players:\t" .. tostring(player.GetCount() ) .. "/" .. tostring(game.MaxPlayers() ) .. "\n" )
	MsgC( Color( 255, 255, 0 ), string.format( structure,"ID", "SteamID", "Ready?", "OS", "Name" ) .. "\n" )
	MsgC( Color( 255, 255, 0 ), "--------------------------------------------------------------------------------" .. "\n" )
	for i, pl in pairs(player.GetAll() ) do
		local _id = 		makeString( pl:UserID(), 4 )
		local _steamid = 	makeString( pl:YRPSteamID(), 20 )
		local _ready = 		tostring( pl:GetYRPBool( "yrp_received_ready", false ) )
		local _os = 		makeString( pl:GetYRPString( "yrp_os" ), 10 )
		local _name = 		makeString( pl:YRPName(), 20 )
		local _str = string.format( structure, _id, _steamid, _ready, _os, _name )
		MsgC( Color( 255, 255, 0 ), _str .. "\n" )
	end
	YRPHR( Color( 255, 255, 0 ) )
end)

function PrintHelp()
	YRP.msg( "note", "Shared Commands:" )
	YRP.msg( "note", "yrp_status" )
	YRP.msg( "note", "	Shows info" )
	YRP.msg( "note", "yrp_version" )
	YRP.msg( "note", "	Shows gamemode version" )
	YRP.msg( "note", "yrp_players" )
	YRP.msg( "note", "	Shows all players" )
	YRP.msg( "note", "yrp_usergroup RPNAME UserGroup" )
	YRP.msg( "note", "	Put a player with the RPNAME to the UserGroup" )
	YRP.msg( "note", "yrp_maps" )
	YRP.msg( "note", "	Shows all maps on server" )
	YRP.msg( "note", "yrp_map ID" )
	YRP.msg( "note", "	Changelevel to map ID" )
	YRP.msg( "note", "yrp_collection / yrp_collectionid" )
	YRP.msg( "note", "	Shows servers collectionid" )

	YRP.msg( "note", "Client Commands:" )
	YRP.msg( "note", "yrp_cl_hud X" )
	YRP.msg( "note", "	1: Shows hud, 0: Hide hud" )
	YRP.msg( "note", "yrp_YRPToggleSettings" )
	YRP.msg( "note", "	Toggle settings menu" )

	YRP.msg( "note", "Server Commands:" )
	YRP.msg( "note", "yrp_givelicense NAME LICENSENAME" )
end

concommand.Add( "yrp_help", function(ply, cmd, args)
	PrintHelp()
end)

concommand.Add( "yrp__help", function(ply, cmd, args)
	PrintHelp()
end)

function YRPCollectionID()
	local collectionid = tonumber(GetGlobalYRPString( "text_server_collectionid", "0" ) )
	if collectionid and collectionid > 100000000 then
		return collectionid
	end
	return 0
end

function PrintCollectionID()
	YRP.msg( "note", "Server - CollectionID: " .. YRPCollectionID() )
end
concommand.Add( "yrp_collectionid", function(ply, cmd, args)
	PrintCollectionID()
end)
concommand.Add( "yrp_collection", function(ply, cmd, args)
	PrintCollectionID()
end)

function IsEntityAlive(ply, uid)
	for i, ent in pairs(ents.GetAll() ) do
		if tostring(ent:GetYRPInt( "item_uniqueID", "" ) ) == tostring(uid) and ent:GetRPOwner() == ply then
			return true, ent
		end
	end
	return false
end

if SERVER then
	util.AddNetworkString( "YRPGetServerInfo" )
	net.Receive( "YRPGetServerInfo", function(len, ply)
		local tab = {}
		tab.Version = GAMEMODE.Version
		tab.VersionStable = GAMEMODE.VersionStable
		tab.VersionBeta = GAMEMODE.VersionBeta
		tab.VersionCanary = GAMEMODE.VersionCanary
		tab.isdedicated = game.IsDedicated()
		net.Start( "YRPGetServerInfo" )
			net.WriteTable(tab)
		net.Send(ply)
	end)

	local tmp = YRP_SQL_SELECT( "yrp_general", "text_gamemode_name", nil)
	if wk(tmp) then
		tmp = tmp[1]
		GM.BaseName = tmp.text_gamemode_name
	end

	util.AddNetworkString( "YRPGetGamemodename" )
	net.Receive( "YRPGetGamemodename", function(len, ply)
		if GAMEMODE and GAMEMODE.BaseName then
			net.Start( "YRPGetGamemodename" )
				net.WriteString(GAMEMODE.BaseName)
			net.Send(ply)
		end
	end )
end

if CLIENT then
	net.Receive( "YRPGetGamemodename", function(len)
		GAMEMODE.BaseName = net.ReadString()
	end)

	timer.Simple( 1, function()
		net.Start( "YRPGetGamemodename" )
		net.SendToServer()
	end )
end

-- Multicore (Shared) enable:
RunConsoleCommand( "gmod_mcore_test", "1" )
RunConsoleCommand( "mat_queue_mode", "-1" )
RunConsoleCommand( "studio_queue_mode", "1" )
RunConsoleCommand( "r_hunkalloclightmaps", "0" )

if CLIENT then
	-- Multicore (Client) enable:
	RunConsoleCommand( "cl_threaded_bone_setup", "1" )
	RunConsoleCommand( "cl_threaded_client_leaf_system", "1" )
	RunConsoleCommand( "r_threaded_particles", "1" )
	RunConsoleCommand( "r_threaded_renderables", "1" )
	RunConsoleCommand( "r_threaded_client_shadow_manager", "1" )
	RunConsoleCommand( "r_queued_ropes", "1" )
	RunConsoleCommand( "M9KGasEffect", "0" )
elseif SERVER then
	-- "removes" voice icons
	RunConsoleCommand( "mp_show_voice_icons", "0" )
end

function GetAllDoors()
	local propDoors = ents.FindByClass( "prop_door" )
	local propDoorRs = ents.FindByClass( "prop_door_rotating" )
	local funcDoors = ents.FindByClass( "func_door" )
	local funcDoorRs = ents.FindByClass( "func_door_rotating" )

	local doors = {}
	for i, v in pairs(propDoors) do
		table.insert( doors, v)
	end
	for i, v in pairs(propDoorRs) do
		table.insert( doors, v)
	end
	for i, v in pairs(funcDoors) do
		table.insert( doors, v)
	end
	for i, v in pairs(funcDoorRs) do
		table.insert( doors, v)
	end
	return doors
end

function IsInTable(tab, val)
	if tab[val] != nil then
		return true
	else
		return false
	end
end

function IsInChannel(ply, cuid, skip)
	skip = skip or false

	if ply:GetYRPBool( "yrp_YRPToggleVoiceMenu", true ) == false then
		return false
	end

	local channel = GetGlobalYRPTable( "yrp_voice_channels", {})[cuid]
	if channel then
		local ug = ply:GetUserGroup()
		local grp = ply:GetGroupUID()
		local rol = ply:GetRoleUID()
		
		if !skip and ply:GetYRPBool( "yrp_voice_channel_mute_" .. channel.uniqueID, false) then
			return false
		end

		return IsInTable( channel.string_active_usergroups, ug) or IsInTable( channel.string_active_groups, grp) or IsInTable( channel.string_active_roles, rol) or IsInTable( channel.string_passive_usergroups, ug) or IsInTable( channel.string_passive_groups, grp) or IsInTable( channel.string_passive_roles, rol) or false
	else
		return false
	end
end

function IsActiveInChannel(ply, cuid, skip)
	skip = skip or false

	if ply:GetYRPBool( "yrp_YRPToggleVoiceMenu", true ) == false then
		return false
	end

	local channel = GetGlobalYRPTable( "yrp_voice_channels", {})[cuid]
	if channel then
		local ug = ply:GetUserGroup()
		local grp = ply:GetGroupUID()
		local rol = ply:GetRoleUID()

		if !skip and ply:GetYRPBool( "yrp_voice_channel_mutemic_" .. channel.uniqueID, true) then
			return false
		end
		return IsInTable( channel.string_active_usergroups, ug) or IsInTable( channel.string_active_groups, grp) or IsInTable( channel.string_active_roles, rol) or false
	else
		return false
	end
end

function YRPGetVoiceRangeText(ply)
	if IsValid(ply) then
		local ranges = {
			[0] = YRP.lang_string( "LID_whisper" ),
			[1] = YRP.lang_string( "LID_quiet" ),
			[2] = "",
			[3] = YRP.lang_string( "LID_noisy" ), 
			[4] = YRP.lang_string( "LID_yell" )
		}
		return ranges[ply:GetYRPInt( "voice_range", 2)]
	end
	return "PLY INVALID"
end

function YRPGetVoiceRange(ply)
	if IsValid(ply) then
		local ranges = {
			[0] = 80,
			[1] = 120,
			[2] = 250,
			[3] = 400, 
			[4] = GetGlobalYRPInt( "int_voice_max_range", 1)
		}
		return math.Clamp(ranges[ply:GetYRPInt( "voice_range", 2)], 0, GetGlobalYRPInt( "int_voice_max_range", 1) )
	else
		return 400
	end
end

function YRPIsInMaxVoiceRange(listener, talker)
	if IsValid(listener) and IsValid(talker) then
		local dist = listener:GetPos():Distance(talker:GetPos() )
		if wk( dist) and GetGlobalYRPInt( "int_voice_max_range", 1) then
			return dist <= tonumber(GetGlobalYRPInt( "int_voice_max_range", 1) )
		end
	end
	return false
end

function YRPIsInSpeakRange(listener, talker)
	if IsValid(listener) and IsValid(talker) then
		local dist = listener:GetPos():Distance(talker:GetPos() )
		if wk( dist) and YRPGetVoiceRange(talker) then
			return dist <= YRPGetVoiceRange(talker)
		end
	end
	return false
end

-- COLORFIX
if system.IsLinux() then
	_MsgC                       = _MsgC         or MsgC
	_ErrorNoHalt                = _ErrorNoHalt  or ErrorNoHalt

	local available_colors      = {
	Color( 0, 0, 0, 255 ),       Color(128, 0, 0),     Color( 0, 128, 0),
	Color(128, 128, 0),   Color( 0, 0, 128),     Color(128, 0, 128),
	Color( 0, 128, 128),   Color(192, 192, 192), Color(128, 128, 128),
	YRPColGreen(),     YRPColGreen(),     Color( 255, 255, 0),
	YRPColBlue(),     Color( 255, 0, 255),   Color( 0, 255, 255),
	Color( 255, 255, 255, 255 ), Color( 0, 0, 0, 255 ),       Color( 0, 0, 95),
	Color( 0, 0, 135),     Color( 0, 0, 175),     Color( 0, 0, 215),
	YRPColBlue(),     Color( 0, 95, 0),      Color( 0, 95, 95),
	Color( 0, 95, 135),    Color( 0, 95, 175),    Color( 0, 95, 215),
	Color( 0, 95, 255),    Color( 0, 135, 0),     Color( 0, 135, 95),
	Color( 0, 135, 135),   Color( 0, 135, 175),   Color( 0, 135, 215),
	Color( 0, 135, 255),   Color( 0, 175, 0),     Color( 0, 175, 95),
	Color( 0, 175, 135),   Color( 0, 175, 175),   Color( 0, 175, 215),
	Color( 0, 175, 255),   Color( 0, 215, 0),     Color( 0, 215, 95),
	Color( 0, 215, 135),   Color( 0, 215, 175),   Color( 0, 215, 215),
	Color( 0, 215, 255),   YRPColGreen(),     Color( 0, 255, 95),
	Color( 0, 255, 135),   Color( 0, 255, 175),   Color( 0, 255, 215),
	Color( 0, 255, 255),   Color(95, 0, 0),      Color(95, 0, 95),
	Color(95, 0, 135),    Color(95, 0, 175),    Color(95, 0, 215),
	Color(95, 0, 255),    Color(95, 95, 0),     Color(95, 95, 95),
	Color(95, 95, 135),   Color(95, 95, 175),   Color(95, 95, 215),
	Color(95, 95, 255),   Color(95, 135, 0),    Color(95, 135, 95),
	Color(95, 135, 135),  Color(95, 135, 175),  Color(95, 135, 215),
	Color(95, 135, 255),  Color(95, 175, 0),    Color(95, 175, 95),
	Color(95, 175, 135),  Color(95, 175, 175),  Color(95, 175, 215),
	Color(95, 175, 255),  Color(95, 215, 0),    Color(95, 215, 95),
	Color(95, 215, 135),  Color(95, 215, 175),  Color(95, 215, 215),
	Color(95, 215, 255),  Color(95, 255, 0),    Color(95, 255, 95),
	Color(95, 255, 135),  Color(95, 255, 175),  Color(95, 255, 215),
	Color(95, 255, 255),  Color(135, 0, 0),     Color(135, 0, 95),
	Color(135, 0, 135),   Color(135, 0, 175),   Color(135, 0, 215),
	Color(135, 0, 255),   Color(135, 95, 0),    Color(135, 95, 95),
	Color(135, 95, 135),  Color(135, 95, 175),  Color(135, 95, 215),
	Color(135, 95, 255),  Color(135, 135, 0),   Color(135, 135, 95),
	Color(135, 135, 135), Color(135, 135, 175), Color(135, 135, 215),
	Color(135, 135, 255), Color(135, 175, 0),   Color(135, 175, 95),
	Color(135, 175, 135), Color(135, 175, 175), Color(135, 175, 215),
	Color(135, 175, 255), Color(135, 215, 0),   Color(135, 215, 95),
	Color(135, 215, 135), Color(135, 215, 175), Color(135, 215, 215),
	Color(135, 215, 255), Color(135, 255, 0),   Color(135, 255, 95),
	Color(135, 255, 135), Color(135, 255, 175), Color(135, 255, 215),
	Color(135, 255, 255), Color(175, 0, 0),     Color(175, 0, 95),
	Color(175, 0, 135),   Color(175, 0, 175),   Color(175, 0, 215),
	Color(175, 0, 255),   Color(175, 95, 0),    Color(175, 95, 95),
	Color(175, 95, 135),  Color(175, 95, 175),  Color(175, 95, 215),
	Color(175, 95, 255),  Color(175, 135, 0),   Color(175, 135, 95),
	Color(175, 135, 135), Color(175, 135, 175), Color(175, 135, 215),
	Color(175, 135, 255), Color(175, 175, 0),   Color(175, 175, 95),
	Color(175, 175, 135), Color(175, 175, 175), Color(175, 175, 215),
	Color(175, 175, 255), Color(175, 215, 0),   Color(175, 215, 95),
	Color(175, 215, 135), Color(175, 215, 175), Color(175, 215, 215),
	Color(175, 215, 255), Color(175, 255, 0),   Color(175, 255, 95),
	Color(175, 255, 135), Color(175, 255, 175), Color(175, 255, 215),
	Color(175, 255, 255), Color(215, 0, 0),     Color(215, 0, 95),
	Color(215, 0, 135),   Color(215, 0, 175),   Color(215, 0, 215),
	Color(215, 0, 255),   Color(215, 95, 0),    Color(215, 95, 95),
	Color(215, 95, 135),  Color(215, 95, 175),  Color(215, 95, 215),
	Color(215, 95, 255),  Color(215, 135, 0),   Color(215, 135, 95),
	Color(215, 135, 135), Color(215, 135, 175), Color(215, 135, 215),
	Color(215, 135, 255), Color(215, 175, 0),   Color(215, 175, 95),
	Color(215, 175, 135), Color(215, 175, 175), Color(215, 175, 215),
	Color(215, 175, 255), Color(215, 215, 0),   Color(215, 215, 95),
	Color(215, 215, 135), Color(215, 215, 175), Color(215, 215, 215),
	Color(215, 215, 255), Color(215, 255, 0),   Color(215, 255, 95),
	Color(215, 255, 135), Color(215, 255, 175), Color(215, 255, 215),
	Color(215, 255, 255), YRPColGreen(),     Color( 255, 0, 95),
	Color( 255, 0, 135),   Color( 255, 0, 175),   Color( 255, 0, 215),
	Color( 255, 0, 255),   Color( 255, 95, 0),    Color( 255, 95, 95),
	Color( 255, 95, 135),  Color( 255, 95, 175),  Color( 255, 95, 215),
	Color( 255, 95, 255),  Color( 255, 135, 0),   Color( 255, 135, 95),
	Color( 255, 135, 135), Color( 255, 135, 175), Color( 255, 135, 215),
	Color( 255, 135, 255), Color( 255, 175, 0),   Color( 255, 175, 95),
	Color( 255, 175, 135), Color( 255, 175, 175), Color( 255, 175, 215),
	Color( 255, 175, 255), Color( 255, 215, 0),   Color( 255, 215, 95),
	Color( 255, 215, 135), Color( 255, 215, 175), Color( 255, 215, 215),
	Color( 255, 215, 255), Color( 255, 255, 0),   Color( 255, 255, 95),
	Color( 255, 255, 135), Color( 255, 255, 175), Color( 255, 255, 215),
	Color( 255, 255, 255, 255 ), Color(8, 8, 8),       Color(18, 18, 18),
	Color(28, 28, 28),    Color(38, 38, 38),    Color(48, 48, 48),
	Color(58, 58, 58),    Color(68, 68, 68),    Color(78, 78, 78),
	Color(88, 88, 88),    Color(98, 98, 98),    Color(108, 108, 108),
	Color(118, 118, 118), Color(128, 128, 128), Color(138, 138, 138),
	Color(148, 148, 148), Color(158, 158, 158), Color(168, 168, 168),
	Color(178, 178, 178), Color(188, 188, 188), Color(198, 198, 198),
	Color(208, 208, 208), Color(218, 218, 218), Color(228, 228, 228),
	Color(238, 238, 238)
	}

	local n_available_colors    = #available_colors
	local color_clear_sequence  = "\27[0m"
	local color_start_sequence  = "\27[38;5;"
	local background_sequence   = "\27[48;5;"

	local function color_id_from_color( col)
		local dist, windist, ri

		for i = 1, n_available_colors do
			local color = available_colors[i]

			dist = ( col.r - color.r)^2 + ( col.g - color.g)^2 + ( col.b - color.b)^2

			if i == 1 or dist < windist then
			windist = dist
			ri = i
			end
		end

		return tostring(ri - 1)
	end

	function print_colored(text, color, background_color, style)
		local color_sequence = color_clear_sequence

		if color != nil then
			if istable( color) then
			color_sequence = color_start_sequence .. color_id_from_color( color) .. "m"
			elseif isstring( color) then
			color_sequence = color
			end
		end

		if background_color != nil then
			if istable( background_color) then
			color_sequence = color_sequence .. background_sequence .. color_id_from_color( background_color) .. "m"
			elseif isstring( background_color) then
			color_sequence = color_sequence .. background_color
			end
		end

		if istable(style) then
			if style.bold == true then
			color_sequence = color_sequence .. "\27[1m"
			end

			if style.dim == true or style.dimmed == true then
			color_sequence = color_sequence .. "\27[2m"
			end

			if style.underline == true or style.underlined == true then
			color_sequence = color_sequence .. "\27[4m"
			end

			if style.blink == true then
			color_sequence = color_sequence .. "\27[5m"
			end

			if style.inverted == true or style.invert == true then
			color_sequence = color_sequence .. "\27[7m"
			end

			if style.hidden == true then
			color_sequence = color_sequence .. "\27[8m"
			end
		end

		Msg( color_sequence .. tostring(text) .. color_clear_sequence)
	end

	function MsgC(...)
		local this_sequence = color_clear_sequence

		for k, v in ipairs({ ... }) do
			if istable( v) then
			this_sequence = color_start_sequence .. color_id_from_color( v) .. "m"
			else
			print_colored(tostring( v), this_sequence)
			end
		end
	end

	function ErrorNoHalt(msg)
		Msg('\27[41;15m\27[1m')
		_ErrorNoHalt(msg)
		Msg( color_clear_sequence)
	end
end

function YRPGetHostName()
	if !strEmpty(GetGlobalYRPString( "text_server_name" ) ) then
		return GetGlobalYRPString( "text_server_name" )
	else
		return GetGlobalYRPString( "ServerName" )
	end
	return ""
end

function IsVoidCharEnabled()
	if VoidChar != nil then
		return true
	end
	return false
end

function YRPReplaceWithPlayerNames(text)
	local found = false
	for _, p in pairs(player.GetAll() ) do
		local s, e = string.find(string.lower(text), string.lower(p:RPName() ))
		if s then
			local pre = string.sub(text, 1, s - 1)
			local pos = string.sub(text, e + 1)
			text = pre .. p:RPName() .. pos
			found = true
		end
	end

	if !found then
		local test = string.Explode( " ", text )
		for i, str in pairs(test) do
			for _, p in pairs(player.GetAll() ) do
				if #str >= 5 and string.StartWith(string.lower(p:RPName() ), string.lower(str) ) then
					test[i] = p:RPName()
				end
			end
		end
		text = table.concat( test, " " )
	end

	return text
end

function YRP_RN(text)
	local cs, ce = string.find(text, "RN(", 1, true)
	if cs then
		local s, e = string.find(text, ")", cs, true)
		if e then
			local pre = string.sub(text, 1, cs - 1)
			local suf = string.sub(text, e + 1)
			local ex = string.sub(text, cs + 3, e - 1)

			ex = string.Explode( ",", ex)
			if ex[1] and ex[2] then
				local rn = math.random( tonumber( ex[1] ), tonumber( ex[2] ) )

				text = pre .. rn .. suf
			else
				local s1 = ex[1]
				local s2 = ex[2]
				MsgC( YRPColGreen(), "ROLL FAILED: " .. tostring( s1 ) .. " " .. tostring( s2 ) .. "\n" )
			end
		end
		return YRP_RN(text)
	end
	return text
end

function YRPChatReplaceCMDS(structure, ply, text)
	local result = structure

	local ugcolor = ply:GetUserGroupColor()
	result = string.Replace( result, "%UGCOLOR%", "Color( " .. ugcolor.r .. "," .. ugcolor.g .. "," .. ugcolor.b .. " )" )

	local rocolor = ply:GetRoleColor()
	result = string.Replace( result, "%ROCOLOR%", "Color( " .. rocolor.r .. "," .. rocolor.g .. "," .. rocolor.b .. " )" )

	if ply:GetYRPBool( "bool_chat" ) then
		result = string.Replace(result, "%USERGROUP%", string.upper(ply:GetUserGroup() ))
	else
		result = string.Replace(result, "[%USERGROUP%] ", "" )
		result = string.Replace(result, "[%USERGROUP%]", "" )
		result = string.Replace(result, "%USERGROUP% ", "" )
		result = string.Replace(result, "%USERGROUP%", "" )
	end

	result = string.Replace(result, "%STEAMNAME%", ply:SteamName() )
	result = string.Replace(result, "%RPNAME%", ply:RPName() )
	result = string.Replace(result, "%IDCARDID%", ply:IDCardID() )

	result = string.Replace(result, "%FACTION%", ply:GetFactionName() )
	result = string.Replace(result, "%GROUP%", ply:GetGroupName() )
	result = string.Replace(result, "%ROLE%", ply:GetRoleName() )

	local newtext = string.Explode( " ", text, false )
	if newtext[1] and #newtext[1] >= 4 then
		local target = GetPlayerByRPName( newtext[1] )
		if ea( target ) then
			result = string.Replace(result, "%TARGET%", target:RPName() )
			table.remove( newtext, 1 )
			if table.Count( newtext ) > 0 then
				text = table.concat( newtext, " " )
			end
		end
	end

	result = string.Replace(result, "%TEXT%", text)
	
	result = YRP_RN(result)

	local pk = {}
	while(!strEmpty(result) ) do
		local cs, ce = string.find(result, "Color(", 1, true)
		if cs == 1 then
			local s, e = string.find(result, ")", 1, true)
			if e then
				local color = string.sub(result, cs + 6, e - 1)
				color = string.Explode( ",", color)
				if isnumber(tonumber( color[1]) ) and isnumber(tonumber( color[2]) ) and isnumber(tonumber( color[3]) ) then
					table.insert(pk, Color( color[1] or 255, color[2] or 255, color[3] or 255) )

					result = string.sub(result, e + 1)
				else
					table.insert(pk, result)
					result = ""
				end
			else
				table.insert(pk, result)
				result = ""
			end
		elseif cs then
			local tex = string.sub(result, 1, cs - 1)
			
			table.insert(pk, tex)

			result = string.sub(result, cs)
		else
			table.insert(pk, result)
			result = ""
		end
	end

	return pk
end

-- ERROR LOGGING

-- CONFIG
local filename = "yrp/yrp_errors.json"
local deleteafter = 60 * 60 * 24
local url_cl = "https://docs.google.com/forms/u/0/d/e/1FAIpQLSdsvTPwNqIDBPE-UcJLcTaxR9dC0U7HcleQCxoVq-Aa2qk6eA/formResponse"
local url_sv = "https://docs.google.com/forms/u/0/d/e/1FAIpQLSecLLX255Pvm-uMPtgG-1deTdT5KJuAikz75mfZBbytbG93vg/formResponse"
-- CONFIG

local function YRPErrorMSG( msg, color )
	color = color or YRPColGreen()
	MsgC( color, "[COLLECT-ERRORS] " .. msg .. "\n" )
end

local YRPErrors = {}
local function YRPCheckErrorFile()
	if !file.Exists( "yrp", "DATA" ) then
		file.CreateDir( "yrp" )
	end
	if !file.Exists( filename, "DATA" ) then
		local tab = {}
		file.Write( filename, util.TableToJSON( tab, true ) )
	end
	local olderrors = util.JSONToTable( file.Read( filename, "DATA" ) )
	if olderrors then
		YRPErrors = olderrors
	end
end
YRPCheckErrorFile()

function YRPNewError(err)
	YRPCheckErrorFile()

	if YRPErrors then
		for i, v in pairs(YRPErrors) do
			if v.err and v.err == err then
				return false
			end
		end
	end
	return true
end

local function YRPSaveErrors()
	if YRPErrors != nil then
		YRPErrorMSG( "Saved Errors", YRPColGreen() )
		file.Write( filename, util.TableToJSON( YRPErrors, true ) )
	else
		YRPErrorMSG( "Failed to save Errors" )
		YRPCheckErrorFile()
		timer.Simple( 0.1, YRPSaveErrors )
	end
end

local function YRPSendError(tab, from)
	local entry = {}
	local posturl = ""

	if tab.buildnummer != gmbn then
		MsgC( YRPColGreen(), ">>> [YRPSendError] FAIL, ERROR IS OUTDATED" .. "\n" )
		YRPRemoveOutdatedErrors()
		return
	end

	if tab.realm == "SERVER" then
		-- err
		entry["entry.60824756"] = tostring(tab.err)

		-- trace
		entry["entry.881449865"] = tostring(tab.trace)

		-- ts
		entry["entry.1817954213"] = tostring(tab.ts)

		-- realm
		entry["entry.482867838"] = tostring(tab.realm)

		-- stable
		entry["entry.1564591854"] = tostring(gmvs)

		-- beta
		entry["entry.1746105951"] = tostring(gmvb)

		-- canary
		entry["entry.176860124"] = tostring(gmvc)

		-- build
		entry["entry.364587527"] = tostring(gmbn)

		posturl = url_sv
	elseif tab.realm == "CLIENT" then
		-- err
		entry["entry.1671624092"] = tostring(tab.err)

		-- trace
		entry["entry.1839792460"] = tostring(tab.trace)

		-- ts
		entry["entry.1069217162"] = tostring(tab.ts)

		-- realm
		entry["entry.507913261"] = tostring(tab.realm)

		-- stable
		entry["entry.933178868"] = tostring(gmvs)

		-- beta
		entry["entry.625348867"] = tostring(gmvb)

		-- canary
		entry["entry.1848121189"] = tostring(gmvc)

		-- build
		entry["entry.1699483827"] = tostring(gmbn)

		posturl = url_cl
	else
		MsgC( YRPColGreen(), ">>> [YRPSendError] FAIL! >> Realm: " .. tostring(tab.realm) .. "\n" )
		return
	end

	if GAMEMODE and YRPIsVersionSet and YRPIsVersionSet() and IsYRPOutdated != nil then
		if IsYRPOutdated() then
			MsgC( YRPColGreen(), "[YRPSendError] >> YourRP Is Outdated" .. "\n" )
		elseif YRPIsServerDedicated() and !string.StartWith( GetGlobalYRPString( "serverip", "0.0.0.0:27015" ), "0.0.0.0:" ) then
			--MsgC( YRPColGreen(), "[YRPSendError] [" .. tostring(from) .. "] >> " .. tostring(tab.err) .. "\n" )
			
			http.Post(posturl, entry,
			function( body, length, headers, code)
				if code == 200 then
					-- worked
					tab.sended = true
					YRPSaveErrors()
				else
					YRP.msg( "error", "[YRPSendError] failed: " .. "HTTP " .. tostring( code) )
				end
			end,
			function( failed )
				YRPErrorMSG( "[YRPSendError] failed: " .. tostring(failed) )
			end)
		end
	else
		timer.Simple(0.1, function()
			YRPSendError(tab, "RETRY" )
		end)
	end
end

function YRPRemoveOutdatedErrors()
	if YRPErrors and GAMEMODE then
		local TMPYRPErrors = {}
		local changed = false
		for i, v in pairs( YRPErrors ) do
			if v.buildnummer == nil then
				v.buildnummer = 0
				changed = true
			end
			if v.ts and os.time() - v.ts < deleteafter and v.buildnummer == gmbn then
				table.insert( TMPYRPErrors, v )
			else
				changed = true
			end
			if !v.sended then
				timer.Simple(10 * i, function()
					YRPSendError( v, "Was not sended" )
				end)
			end
		end
		if changed then
			YRPErrorMSG( "Found Outdated Errors", YRPColGreen() )
			if TMPYRPErrors then
				YRPErrors = TMPYRPErrors
			end
			YRPSaveErrors()
		else
			-- YRPErrorMSG( "No Outdated Errors found", YRPColGreen() )
		end
	else
		YRPErrorMSG( "Failed to remove outdated errors" )
		timer.Simple(0.01, YRPRemoveOutdatedErrors)
	end
end
timer.Simple(0.1, YRPRemoveOutdatedErrors)

function YRPAddError(err, trace, realm)
	local newerr = {}
	newerr.err = err
	newerr.trace = trace
	newerr.trace = newerr.trace .. "\n" .. "err: /yrp/ ".. tostring( string.find( err, "/yrp/", 1, true ) ) .. "      trace: /yrp/ " .. tostring( string.find( trace, "/yrp/", 1, true ) ) .. "      trace: [YourRP] " .. tostring( string.find( trace, "[YourRP]", 1, true ) )
	newerr.trace = newerr.trace .. "\n" .. "IP: " .. GetGlobalYRPString( "serverip", "0.0.0.0:27015" ) .. "      collectionid: " .. YRPCollectionID()
	newerr.ts = os.time()
	newerr.realm = realm
	newerr.sended = false
	newerr.buildnummer = gmbn
	table.insert(YRPErrors, newerr)

	YRPSendError(newerr, "NEW ERROR" )

	YRPSaveErrors()
end



function YRPAddLuaErrorHook()
	hook.Remove( "OnLuaError", "yrp_OnLuaError" )

	hook.Add( "OnLuaError", "yrp_OnLuaError", function(...)
		local tab = ...
		local err = tab.path
		local trace = tab.trace
		local realm = tab.realm

		local tabtrace = string.Explode( "\n", trace )
		local newtrace = {}
		for i, v in pairs( tabtrace ) do
			if string.find( v, "stack traceback:", 1, true ) or string.find( v, "lua/autorun/sh_d4_senderrors.lua", 1, true ) then
				
			else
				table.insert( newtrace, v )
			end
		end
		trace = table.concat( newtrace, "\n" )
		trace = string.Replace( trace, "\t", "" )

		--if err and trace and realm and ( string.find(err, "/yrp/" ) or string.find(trace, "/yrp/" ) ) and YRPNewError(err) then
		if err and trace and realm and ( string.find( err, "/yrp/", 1, true ) or string.find( trace, "/yrp/", 1, true ) or string.find( trace, "[YourRP]", 1, true ) ) and YRPNewError(err) then
			MsgC( YRPColGreen(), "[YRPAddError] >> Found a new ERROR" .. "\n" )
			YRPAddError(err, trace, realm)
		end
	end)
end
YRPAddLuaErrorHook()
timer.Simple( 10, YRPAddLuaErrorHook )



function YRPCheckReadyTable( tab )
	if !wk( tab ) then
		YRP.msg( "error", "[CheckReadyTable] Table INVALID: " .. tostring( tab ) )
		return false
	end
	if table.Count( tab ) != 4 then
		YRP.msg( "error", "[CheckReadyTable] Table is size: " .. table.Count( tab ) )
		return false
	end
	for i, v in pairs( tab ) do
		if v == nil then
			YRP.msg( "error", "[CheckReadyTable] Table-Entry is nil at index: " .. tostring( i ) )
			return false
		end
	end
	return true
end

if CLIENT then
	timer.Simple(1, function()
		YRPHR( Color( 255, 255, 0 ) )
		MsgC( Color( 255, 255, 0 ), "[GAME VERSION] Server: " .. GetGlobalYRPString( "serverversion", VERSION ) .. "\n" )
		MsgC( Color( 255, 255, 0 ), "[GAME VERSION] Client: " .. VERSION .. "\n" )
		YRPHR( Color( 255, 255, 0 ) )

		if GetGlobalYRPString( "serverversion", VERSION ) > VERSION then
			MsgC( YRPColGreen(), "YOUR GAME IS OUTDATED!" .. "\n" )
		elseif GetGlobalYRPString( "serverversion", VERSION ) < VERSION and BRANCH == "unknown" then
			MsgC( YRPColGreen(), "SERVER IS OUTDATED!" .. "\n" )
		else
			MsgC( YRPColGreen(), "YOUR GAME IS UP-To-Date!" .. "\n" )
		end
	end)
end

function YRPCleanUpName( name )
	if name then
		name = string.Replace( name, "'", "" )
	end
	return name
end

function GM:DarkRPFinishedLoading()
    -- GAMEMODE gets set after the last statement in the gamemode files is run. That is not the case in this hook
    GAMEMODE = GAMEMODE or GM
	
    --loadLanguages()
    --loadModules()
    --loadCustomDarkRPItems()
    hook.Call( "loadCustomDarkRPItems", self )
    hook.Call( "postLoadCustomDarkRPItems", self )
end
timer.Simple(0, function()
	GAMEMODE:DarkRPFinishedLoading()
end)

function YRPCheckDarkRP()
	if gmod and gmod.GetGamemode() then
		if gmod.GetGamemode().Name != "DarkRP" then
			YRP.msg( "note", "Modified Files Detected, DarkRP addons will not work with that." )
		end
	end

	timer.Simple( 1, YRPCheckDarkRP )
end
YRPCheckDarkRP()

--[[
local function Test()
	print("----")

	local c = 0
	for i, v in pairs( ents.GetAll() ) do
		if string.find( string.lower( v:GetClass() ), "c_baseflex", 1, true ) then
			c = c + 1
			print(c, v)
		end
	end
	print("total: " .. c)

	timer.Simple(2, Test)
end
Test()
]]

