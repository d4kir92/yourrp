--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--here you can change this, but it's dumb, because you can change it ingame
GM.Name = "DarkRP" -- Is for other addons detecting that the gamemode is "DarkRP" compatible
GM.BaseName = "YourRP" -- DO NOT CHANGE THIS, thanks

DeriveGamemode( "sandbox" )

-- >>> do NOT change this! (it can cause crashes!) <<<
GM.ShortName = "YRP"	--do NOT change this!
GM.Author = "D4KiR" --do NOT change this!
GM.Discord = "https://discord.gg/sEgNZxg" --do NOT change this!
GM.Email = GM.Discord --do NOT change this!
GM.Website = "https://sites.google.com/view/yrp" --do NOT change this!
GM.Youtube = "youtube.com/c/D4KiR" --do NOT change this!
GM.Twitter = "twitter.com/D4KIR" --do NOT change this!
GM.Help = "Create your rp you want to make!" --do NOT change this!
GM.dedicated = "-" --do NOT change this!
GM.Version = "0.9.161" --do NOT change this!
GM.VersionSort = "beta" --do NOT change this! --stable, beta, canary
GM.rpbase = "YourRP" --do NOT change this! <- this is not for server browser

function GetRPBase()
	return GAMEMODE.rpbase
end

VERSIONART = "github"
for i, wsi in pairs( engine.GetAddons() ) do
	if tostring( wsi.wsid ) == "1114204152" then
		VERSIONART = "workshop"
	end
end

function ChangeChannel( channel )
	if channel == "stable" or channel == "beta" or channel == "canary" then
		GAMEMODE.VersionSort = channel
		printGM( "gm", "Switched to " .. tostring( channel ) )
	else
		printGM( "error", "Switched to not available channel (" .. tostring( channel ) .. ")" )
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
	local _first = string.find( map, "_", 1, false )
	if _first != nil then
		map = string.sub( map, _first + 1 )
	end
	map = string.Explode( "_", map )
	local _new_map = {}
	for i, str in pairs( map ) do
		local _tab = string.Explode( "", str )
		local _insert = true
		for j, char in pairs( _tab ) do
			if isnumber( tonumber( char ) ) then
				_insert = false
				break
			end
		end
		if _insert then
			table.insert( _new_map, str )
		end
	end
	map = string.Implode( " ", _new_map )
	return string.upper( map )
end

function GetMapName()
	return game.GetMap()
end

function RSWU(str) -- Replace Space With Underline
	return string.Replace(str, " ", "_")
end

function GetMapNameDB()
	return string.lower(SQL_STR_IN(RSWU(game.GetMap())))
end

concommand.Add( "yrp_version", function( ply, cmd, args )
	hr_pre()
	local _text = "Gamemode - Version:\t" .. GAMEMODE.Version
	if IsYRPOutdated() == nil then
		_text = _text .. " (Checking)"
	elseif IsYRPOutdated() then
		_text = _text .. " (OUTDATED!)"
	end
	printGM( "gm", _text )
	hr_pos()
end )

concommand.Add( "yrp_status", function( ply, cmd, args )

	local _text = "Gamemode - Version:\t" .. GAMEMODE.Version
	if IsYRPOutdated() == nil then
		_text = _text .. " (Checking)"
	elseif IsYRPOutdated() then
		_text = _text .. " (OUTDATED!)"
	end

	hr_pre()
	printGM( "gm", "    Version:\t" .. GAMEMODE.Version )
	printGM( "gm", "    Channel:\t" .. string.upper( GAMEMODE.VersionSort ) )
	printGM( "gm", " Servername:\t" .. GetHostName() )
	printGM( "gm", "         IP:\t" .. game.GetIPAddress() )
	printGM( "gm", "        Map:\t" .. GetMapNameDB() )
	printGM( "gm", "    Players:\t" .. tostring( player.GetCount() ) .. "/" .. tostring( game.MaxPlayers() ) )
	hr_pos()
end )

function makeString( tab, str_len, cut )
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

concommand.Add( "yrp_players", function( ply, cmd, args )
	hr_pre()
	printGM( "gm", "Players:\t" .. tostring( player.GetCount() ) .. "/" .. tostring( game.MaxPlayers() ) )
	printGM( "gm", "ID   SteamID              Name                     Money")
	for i, pl in pairs( player.GetAll() ) do
		local _id = makeString( string.ToTable( pl:UserID() ), 4, false )
		local _steamid = makeString( string.ToTable( pl:SteamID() ), 20, false )
		local _name = makeString( string.ToTable( pl:YRPName() ), 24, true )
		local _money = makeString( string.ToTable( pl:GetNWString( "money" ) ), 12, false )
		local _str = string.format( "%s %s %s %s", _id, _steamid, _name, _money )
		printGM( "gm", _str)
	end
	hr_pos()
end )

concommand.Add( "yrp__help", function( ply, cmd, args )
	hr_pre()
	printGM( "note", "Shared Commands:" )
	printGM( "note", "yrp_status" )
	printGM( "note", "	Shows info" )
	printGM( "note", "yrp_version" )
	printGM( "note", "	Shows gamemode version" )
	printGM( "note", "yrp_players" )
	printGM( "note", "	Shows all players" )
	printGM( "note", "yrp_usergroup RPNAME UserGroup" )
	printGM( "note", "	Put a player with the RPNAME to the UserGroup" )
	hr_pos()

	hr_pre()
	printGM( "note", "Client Commands:" )
	printGM( "note", "yrp_cl_hud X" )
	printGM( "note", "	1: Shows hud, 0: Hide hud" )
	printGM( "note", "yrp_togglesettings" )
	printGM( "note", "	Toggle settings menu" )
	hr_pos()
end )

hook.Add("StartCommand", "NoJumpGuns", function( ply, cmd )
	if ply:GetNWBool( "bool_anti_bhop", false ) and !ply:GetNWBool( "canjump", false ) and ply:GetMoveType() != MOVETYPE_NOCLIP then
		cmd:RemoveKey(IN_JUMP)
	end
end)

if SERVER then
	util.AddNetworkString( "yrp_weaponlowering" )
end

if CLIENT then
	hook.Add( "CalcViewModelView", "yrp_weaponlowering_handler", function( wep, vm, oldPos, oldAng, pos, ang )
		local _ply = LocalPlayer()

		if wep:IsScripted() then
			local _speed = 2
			if _ply.lerp_ang_up == nil then
				_ply.lerp_ang_up = 0
			end
			if _ply:GetNWBool( "weaponlowered", true ) then
				_ply.lerp_ang_up = Lerp( _speed * FrameTime(), _ply.lerp_ang_up, 90 )
				if _ply.lerp_ang_up > 90 then
					_ply.lerp_ang_up = 90
				end
			else
				_ply.lerp_ang_up = Lerp( _speed * FrameTime(), _ply.lerp_ang_up, 0 )
				if _ply.lerp_ang_up < 0 then
					_ply.lerp_ang_up = 0
				end
			end
			pos = pos + ang:Right() * _ply.lerp_ang_up / 90 * 10 + ang:Forward() * 0 + ang:Up() * -_ply.lerp_ang_up / 90 * 2

			ang:RotateAroundAxis( ang:Up(), _ply.lerp_ang_up * 0.5 )
			ang:RotateAroundAxis( ang:Right(), -_ply.lerp_ang_up * 0.1 )
			--ang:RotateAroundAxis( ang:Forward(), -_ply.lerp_ang_up/2 )

			wep:SetPos( pos )
			wep:SetAngles( ang )
		end
	end)
end

if SERVER then
	function lowering_weapon( ply )
		if IsWeaponLoweringEnabled() then
			local _weapon = ply:GetActiveWeapon()
			if ea( _weapon ) then
				if _weapon:IsScripted() and ply:GetNWBool( "weaponlowered", true ) then
					ply:SetNWBool( "weaponlowered", false )
					_weapon:SetHoldType( _weapon:GetNWString( "swep_holdtype" ) )
					_weapon.HoldType = _weapon:GetNWString( "swep_holdtype" )
				else
					ply:SetNWBool( "weaponlowered", true )
					local _w_ht = _weapon:GetNWString( "swep_holdtype" )
					if _w_ht == "melee" or _w_ht == "melee2" or _w_ht == "pistol" or _w_ht == "grenade" or _w_ht == "rpg" or _w_ht == "slam" or _w_ht == "fist" or _w_ht == "knife" or _w_ht == "duel" or _w_ht == "camera" or _w_ht == "magic" or _w_ht == "revolver" then
						_weapon:SetHoldType( "normal" )
					elseif _w_ht == "smg" or _w_ht == "ar2" or _w_ht == "shotgun" or _w_ht == "physgun" or _w_ht == "crossbow" then
						_weapon:SetHoldType( "passive" )
					else
						_weapon:SetHoldType( "normal" )
					end
				end
			end
		end
	end

	hook.Add( "Tick", "yrp_weaponlowering_tick", function()
		if IsWeaponLoweringEnabled() then
			for k, ply in pairs( player.GetAll() ) do
				local _weapon = ply:GetActiveWeapon()
				if ea( _weapon ) then
					if _weapon:IsScripted() and ( ( ( ply:KeyDown( IN_SPEED ) and ply:KeyDown( IN_FORWARD ) ) or ply:KeyDown( IN_ATTACK ) or ply:KeyDown( IN_ATTACK2 ) ) and ply:GetNWBool( "weaponlowered", true ) ) then
						lowering_weapon( ply )
					end
				end
			end
		end
	end )

	net.Receive( "yrp_weaponlowering", function( len, ply )
		lowering_weapon( ply )
	end)
end

function IsEntityAlive( ply, uid )
	for i, ent in pairs( ents.GetAll() ) do
		if tostring( ent:GetNWString( "item_uniqueID", "" ) ) == tostring( uid ) and ent:GetRPOwner() == ply then
			return true, ent
		end
	end
	return false
end

if SERVER then
	util.AddNetworkString( "getServerVersion" )
	net.Receive( "getServerVersion", function( len, ply )
		net.Start( "getServerVersion" )
			net.WriteString( GAMEMODE.Version )
			net.WriteBool( game.IsDedicated() )
		net.Send( ply )
	end)

	local tmp = SQL_SELECT( "yrp_general", "text_gamemode_name", nil )
	if wk(tmp) then
		tmp = tmp[1]
		GM.BaseName = SQL_STR_OUT( tmp.text_gamemode_name )
	end

	util.AddNetworkString( "getGamemodename" )
	net.Receive( "getGamemodename", function( len, ply )
		net.Start("getGamemodename")
			net.WriteString( GAMEMODE.BaseName )
		net.Send(ply)
	end)
end

if CLIENT then
	net.Receive( "getGamemodename", function( len )
		GAMEMODE.BaseName = net.ReadString()
	end)

	timer.Simple( 1, function()
		net.Start( "getGamemodename" )
		net.SendToServer()
	end)
end

-- Multicore (Shared) enable:
RunConsoleCommand( "gmod_mcore_test", "1" )
RunConsoleCommand( "mat_queue_mode", "-1" )
RunConsoleCommand( "studio_queue_mode", "1" )
RunConsoleCommand( "r_hunkalloclightmaps", "0" )

-- Enable Errorlog
RunConsoleCommand( "lua_log_sv", "1" )

if CLIENT then
	-- Enable Errorlog
	RunConsoleCommand( "lua_log_cl", "1" )

	-- Multicore (Client) enable:
	RunConsoleCommand( "cl_threaded_bone_setup", "1" )
	RunConsoleCommand( "cl_threaded_client_leaf_system", "1" )
	RunConsoleCommand( "r_threaded_particles", "1" )
	RunConsoleCommand( "r_threaded_renderables", "1" )
	RunConsoleCommand( "r_threaded_client_shadow_manager", "1" )
	RunConsoleCommand( "r_queued_ropes", "1" )
elseif SERVER then
	-- "removes" voice icons
	RunConsoleCommand( "mp_show_voice_icons", "0" )
end
