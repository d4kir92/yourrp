--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

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
		  GAMEMODE.Name = tmp[1].name_gamemode
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

--do NOT change this! (it can cause crashes!)
GM.ShortName = "YRP"	--do NOT change this!
GM.Author = "D4KiR" --do NOT change this!
GM.Discord = "https://discord.gg/sEgNZxg" --do NOT change this!
GM.Email = GM.Discord --do NOT change this!
GM.Website = "youtube.com/c/D4KiR" --do NOT change this!
GM.Twitter = "twitter.com/D4KIR" --do NOT change this!
GM.Help = "Create your rp you want to make!" --do NOT change this!
GM.dedicated = "-" --do NOT change this!
GM.Version = "0.9.4.3" --do NOT change this!
GM.VersionSort = "unstable" --do NOT change this!
GM.rpbase = "YourRP" --do NOT change this!

RunConsoleCommand( "gmod_mcore_test", "1" )
RunConsoleCommand( "mat_queue_mode", "-1" )
RunConsoleCommand( "studio_queue_mode", "1" )
RunConsoleCommand( "r_hunkalloclightmaps", "0" )

if CLIENT then
	RunConsoleCommand( "cl_threaded_bone_setup", "1" )
	RunConsoleCommand( "cl_threaded_client_leaf_system", "1" )
	RunConsoleCommand( "r_threaded_particles", "1" )
	RunConsoleCommand( "r_threaded_renderables", "1" )
	RunConsoleCommand( "r_queued_ropes", "1" )

  RunConsoleCommand( "r_threaded_client_shadow_manager", "1" )
end
