--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

util.AddNetworkString( "restartServer" )
util.AddNetworkString( "updateServer" )
util.AddNetworkString( "cancelRestartServer" )

util.AddNetworkString( "get_workshop_collection" )
net.Receive( "get_workshop_collection", function( len, ply )
  local _wscnr = SQL_SELECT( "yrp_general", "collection", nil )
  if _wscnr != nil then
    _wscnr = _wscnr[1].collection
  end
  local _wsc = engine.GetAddons()
  net.Start( "get_workshop_collection" )
    net.WriteString( _wscnr )
    net.WriteTable( _wsc )
  net.Send( ply )
end)

--Restart Server
net.Receive( "restartServer", function( len, ply )
  print("RunConsoleCommand(_restart)")
  RunConsoleCommand( "_restart" )
end)

net.Receive( "updateServer", function( len, ply )
  local _tmpString = net.ReadString()
  local _result = SQL_UPDATE( "yrp_general", "name_gamemode = '" .. db_in_str( _tmpString ) .. "'" )
  if worked( _result, "name_gamemode failed" ) then
  end
  local countdown = net.ReadInt( 16 )
  timer.Create( "timerRestartServer", 1, 0, function()
		local message = "Updating Server in " .. countdown .. " seconds"
		if countdown == 0 then
			message = "Server is updating."
		end
    if countdown > 10 then
      if (countdown%10) == 0 then
        PrintMessage( HUD_PRINTCENTER, message )
        printGM( "server", message )
      end
    elseif countdown <= 10 then
      PrintMessage( HUD_PRINTCENTER, message )
      printGM( "server", message )
    end
    countdown = countdown - 1
    if countdown == -1 then
      timer.Remove( "timerRestartServer" )
      game.ConsoleCommand( "changelevel " .. db_sql_str2( string.lower( game.GetMap() ) ) .. "\n" )
    end
  end)
end)

net.Receive( "cancelRestartServer", function( len, ply )
  timer.Remove( "timerRestartServer" )
  local message = "Restart Server CANCELED!"
  PrintMessage( HUD_PRINTCENTER, message )
  printGM( "server", message )
end)

util.AddNetworkString( "yrp_eat" )
util.AddNetworkString( "yrp_drink" )

net.Receive( "yrp_eat", function( len, ply )
  ply:SetNWInt( "hunger", ply:GetNWInt( "hunger", 0 ) + 20 )
  if ply:GetNWInt( "hunger", 0 ) > 100 then
    ply:SetNWInt( "hunger", 100 )
  end
end)

net.Receive( "yrp_drink", function( len, ply )
  ply:SetNWInt( "thirst", ply:GetNWInt( "thirst", 0 ) + 20 )
  if ply:GetNWInt( "thirst", 0 ) > 100 then
    ply:SetNWInt( "thirst", 100 )
  end
end)

concommand.Add( "yrp_status", function( ply, cmd, args )
	printGM( "note", "YourRP Version: " .. GAMEMODE.Version )
end )

function changeUserGroup( ply, cmd, args )
	local message = ""
	if args[2] != nil then
	  if !ply:IsPlayer() then
	    for k, v in pairs( player.GetAll() ) do
	      if string.find( string.lower( v:Nick() ), string.lower( args[1] ) ) or string.find( string.lower( v:SteamName() ), string.lower( args[1] ) ) then
	        v:SetUserGroup( args[2] )
	        printGM( "note", args[1] .. " is now the usergroup " .. args[2] )
	        return
	      end
	    end
	    printGM( "note", args[1] .. " not found." )
	  elseif ply:HasAccess() or ply:IPAddress() == "loopback" then
	    for k, v in pairs( player.GetAll() ) do
	      if string.find( string.lower( v:Nick() ), string.lower( args[1] ) ) or string.find( string.lower( v:SteamName() ), string.lower( args[1] ) ) then
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
