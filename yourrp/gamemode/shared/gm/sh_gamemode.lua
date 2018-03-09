--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--here you can change this, but it's dumb, because you can change it ingame
GM.Name = "YourRP" --it also do nothing here, because the database overwrite it

DeriveGamemode( "sandbox" )

function GM:Initialize()
	self.BaseClass.Initialize(self)
end

function GM:GetGameDescription()
	return GAMEMODE.Name
end

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
			pos = pos + ang:Right() * _ply.lerp_ang_up/90*10 + ang:Forward() * 0 + ang:Up() * -_ply.lerp_ang_up/90*2

			ang:RotateAroundAxis( ang:Up(), _ply.lerp_ang_up*0.5 )
			ang:RotateAroundAxis( ang:Right(), -_ply.lerp_ang_up*0.1 )
			--ang:RotateAroundAxis( ang:Forward(), -_ply.lerp_ang_up/2 )

			wep:SetPos( pos )
			wep:SetAngles( ang )
		end
	end)
end

if SERVER then

	function lowering_weapon( ply )
		if ply != NULL then
			local _weapon = ply:GetActiveWeapon()
			if _weapon != NULL then
				if _weapon:IsScripted() then
				  if ply:GetNWBool( "weaponlowered", true ) then
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
	end

	hook.Add( "Tick", "KeyDown_Test", function()
		for k, ply in pairs( player.GetAll() ) do
			local _weapon = ply:GetActiveWeapon()
			if _weapon != NULL then
				if _weapon:IsScripted() then
					if ( ( ply:KeyDown( IN_SPEED ) and ply:KeyDown( IN_FORWARD ) ) or ply:KeyDown( IN_ATTACK ) or ply:KeyDown( IN_ATTACK2 ) ) and ply:GetNWBool( "weaponlowered", true ) then
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

if SERVER then
	util.AddNetworkString( "getServerVersion" )
	net.Receive( "getServerVersion", function( len, ply )
		net.Start( "getServerVersion" )
			net.WriteString( GAMEMODE.Version )
			net.WriteBool( game.IsDedicated() )
		net.Send( ply )
	end)

  util.AddNetworkString( "getGamemodename" )
	timer.Simple( 4, function()
	  local tmp = db_select( "yrp_general", "name_gamemode", nil )
		if tmp != false and tmp != nil then
		  GAMEMODE.Name = db_out_str( tmp[1].name_gamemode )
		end
	end)
end

if CLIENT then
  timer.Simple( 1, function()
    net.Start( "getGamemodename" )
    net.SendToServer()
  end)

  net.Receive( "getGamemodename", function( len, ply )
    GAMEMODE.Name = net.ReadString()
  end)
end

-- >>> do NOT change this! (it can cause crashes!) <<<
GM.ShortName = "YRP"	--do NOT change this!
GM.Author = "D4KiR" --do NOT change this!
GM.Discord = "https://discord.gg/sEgNZxg" --do NOT change this!
GM.Email = GM.Discord --do NOT change this!
GM.Website = "youtube.com/c/D4KiR" --do NOT change this!
GM.Twitter = "twitter.com/D4KIR" --do NOT change this!
GM.Help = "Create your rp you want to make!" --do NOT change this!
GM.dedicated = "-" --do NOT change this!
GM.Version = "V.:" .. " " .. "0.9.40" --do NOT change this!
GM.VersionSort = "BETA" --do NOT change this! --stable, beta, canary
GM.rpbase = "YourRP" --do NOT change this! <- this is not for server browser

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
elseif SERVER then
	-- "removes" voice icons
	RunConsoleCommand( "mp_show_voice_icons", "0" )
end
