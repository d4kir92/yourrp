--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

concommand.Add( "yrp__help", function( ply, cmd, args )
	printGMPre( "note", "concommands" )
  printGM( "note", "yrp_status - shows gamemode version" )
  printGMPos()

  printGMPre( "note", "convars" )
  printGM( "note", "yrp_cl_hud X - 1: shows hud, 0: hide hud" )
  printGMPos()
end )

concommand.Add( "yrp_status", function( ply, cmd, args )
	printGM( "note", "YourRP Version: " .. GAMEMODE.Version )
end )

function changeUserGroup( ply, cmd, args )
	local message = ""
	if args[2] != nil then
	  if !ply:IsPlayer() then
	    for k, v in pairs( player.GetAll() ) do
	      if string.find( string.lower( v:Nick() ), string.lower( args[1] ) ) then
	        v:SetUserGroup( args[2] )
	        printGM( "note", args[1] .. " is now the usergroup " .. args[2] )
	        return
	      end
	    end
	    printGM( "note", args[1] .. " not found." )
	  elseif ply:IsSuperAdmin() or ply:IPAddress() == "loopback" then
	    for k, v in pairs( player.GetAll() ) do
	      if string.lower( v:SteamName() ) == string.lower( args[1] ) then
	        v:SetUserGroup( args[2] )
	        printGM( "note", args[1] .. " is now the usergroup " .. args[2] )
	        return
	      end
	    end
	    printGM( "note", args[1] .. " not found." )
	  elseif ply:IsPlayer() then
	    message = ply:SteamName() .. " tried to give " .. args[1] .. " the usergroup " .. args[2] .. "."
	    printGM( "note", message )
	  end
	else
		printGM( "note", "not enough arguments" )
	end
end

concommand.Add( "yrp_usergroup", function( ply, cmd, args )
  changeUserGroup( ply, cmd, args )
end )
