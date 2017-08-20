//Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local time = 0
timer.Create( "ServerThink", 1, 0, function()
  local _allPlayers = player.GetAll()

  for k, ply in pairs( _allPlayers ) do
    if !ply:GetNWBool( "inCombat" ) then
      //HealthReg
      if ply:GetNWInt( "GetHealthReg" ) != nil then
        ply:SetHealth( ply:Health() + ply:GetNWInt( "GetHealthReg" ) )
        if ply:Health() > ply:GetMaxHealth() then
          ply:SetHealth( ply:GetMaxHealth() )
        end
      end

      //ArmorReg
      if ply:GetNWInt( "GetArmorReg" ) != nil then
        ply:SetArmor( ply:Armor() + ply:GetNWInt( "GetArmorReg" ) )
        if ply:Armor() > ply:GetNWInt( "GetMaxArmor" ) then
          ply:SetArmor( ply:GetNWInt( "GetMaxArmor" ) )
        end
      end
    end
  end

  if time % 60 == 0 then
    for k, ply in pairs( _allPlayers ) do
      ply:SetNWInt( "money", ply:GetNWInt( "money" ) + ply:GetNWInt( "capital" ) )
    end
  end

  if time % 300 == 0 then
    saveClients( "Auto-Save ( 5 min )" )
  end

  if time % 1800 == 0 then
    roleCheck( "Auto-Check ( 30 min )" )
  end

  if time >= 21600-30 then
    if time >= 21600 then
      printGM( "gm", "Auto Reload" )
      timer.Simple( 1, function()
        game.ConsoleCommand( "changelevel " .. string.lower( game.GetMap() ) .. "\n" )
      end)
    else
      printGM( "gm", "Auto Reload in " .. 21600-time .. " sec" )
    end
  end

  time = time + 1
end)

function GM:EntityTakeDamage( target, dmginfo )
	if target:IsPlayer() then
		target:SetNWBool( "inCombat", true )
    if timer.Exists( target:Nick() .. " outOfCombat" ) then
      timer.Remove( target:Nick() .. " outOfCombat" )
    end
    timer.Create( target:Nick() .. " outOfCombat", 6, 1, function()
      target:SetNWBool( "inCombat", false )
      timer.Remove( target:Nick() .. " outOfCombat" )
    end)
	end
end

function GM:PlayerCanHearPlayersVoice( listener, talker )
  return true, true
  /*if listener:GetPos():Distance( talker:GetPos()) < 1000 then
    return true, true
  else
    return false, false
  end*/
end

util.AddNetworkString( "yrp_player_say" )

function isChatCommand( string, command )
  local size = string.len( string.lower( command ) )
  local slash = string.sub( string.lower( string ), 1, 1+size ) == "/" .. string.lower( command )
  local call = string.sub( string.lower( string ), 1, 1+size ) == "!" .. string.lower( command )
  if slash or call then
    return true
  else
    return false
  end
end

function getPlayer( string )
  for k, ply in pairs( player.GetAll() ) do
    if string.find( string.lower( ply:Nick() ), string, 1, false ) then
      return ply
    end
  end
end

function boxString( string, color, colorBox )
  if _playersay != nil then
    table.insert( _playersay, colorBox )
    table.insert( _playersay, "[" )

    table.insert( _playersay, color )
    table.insert( _playersay, string )

    table.insert( _playersay, colorBox )
    table.insert( _playersay, "] " )
  end
end

function GM:PlayerSay( sender, text, teamChat )
  if text != "" then
    local _allPlayers = player.GetAll()
    local _local = 0
    _playersay = {}

    if isChatCommand( text, "drop" ) then
      local _weapon = sender:GetActiveWeapon()
      if _weapon != nil then
        sender:DropWeapon( _weapon )
      end
      return ""
    end

    if isChatCommand( text, "setmoney" ) then
      local _table = string.Explode( " ", text, false )
      local _name = _table[2]
      local _money = tonumber( _table[3] )
      if isnumber( _money ) then
        local ply = getPlayer( _name )
        ply:setMoney( _money )
        return ""
      end
      boxString( "Command-FAILED", Color( 255, 0, 0 ), Color( 255, 255, 255 ) )
    end

    if isChatCommand( text, "addmoney" ) then
      local _table = string.Explode( " ", text, false )
      local _name = _table[2]
      local _money = tonumber( _table[3] )
      if isnumber( _money ) then
        local ply = getPlayer( _name )
        ply:addMoney( _money )
        return ""
      end
      boxString( "Command-FAILED", Color( 255, 0, 0 ), Color( 255, 255, 255 ) )
    end

    if !sender:Alive() then
      boxString( "DEAD", Color( 255, 0, 0 ), Color( 255, 255, 255 ) )
    end

    if isChatCommand( text, "ooc" ) then
      boxString( "OOC", Color( 255, 165, 0 ), Color( 255, 165, 0 ) )
    elseif isChatCommand( text, "looc" ) then
      _local = 1
      boxString( "LOOC", Color( 255, 50, 0 ), Color( 255, 50, 0 ) )
    elseif isChatCommand( text, "advert" ) or isChatCommand( text, _advertname ) then
      boxString( string.upper( _advertname ), Color( 255, 255, 0 ), Color( 255, 50, 0 ) )
    end

    if isChatCommand( text, "me" ) then
      //Group
      table.insert( _playersay, Color( 255, 165, 0 ) )
      table.insert( _playersay, string.upper( sender:GetNWString("groupName") ) .. " " )

      //Role
      table.insert( _playersay, Color( 0, 255, 0 ) )
      table.insert( _playersay, string.upper( sender:GetNWString("roleName") ) .. " " )

      //Nickname
      table.insert( _playersay, Color( 0, 255, 0 ) )
      table.insert( _playersay, sender:GetNWString( "FirstName" ) .. " " .. sender:GetNWString( "SurName" ) )
    elseif isChatCommand( text, "looc" ) or isChatCommand( text, "ooc" ) then
      //UserGroup
      table.insert( _playersay, Color( 100, 100, 255 ) )
      table.insert( _playersay, string.upper( sender:GetUserGroup() ) .. " " )

      //Nick
      table.insert( _playersay, Color( 200, 200, 255 ) )
      table.insert( _playersay, sender:Nick() .. ": " )
    else
      //Group
      table.insert( _playersay, Color( 0, 255, 0 ) )
      table.insert( _playersay, string.upper( sender:GetNWString("groupName") ) .. " " )

      //Role
      table.insert( _playersay, Color( 0, 255, 0 ) )
      table.insert( _playersay, string.upper( sender:GetNWString("roleName") ) .. " " )

      //Nickname
      table.insert( _playersay, Color( 0, 255, 0 ) )
      table.insert( _playersay, sender:GetNWString( "FirstName" ) .. " " .. sender:GetNWString( "SurName" ) .. ": " )
    end

    //Text
    table.insert( _playersay, Color( 255, 255, 255 ) )
    if isChatCommand( text, "me" ) then
      table.insert( _playersay, Color( 0, 255, 0 ) )
      table.insert( _playersay, string.sub( text, 4 ) )
    elseif isChatCommand( text, "ooc" ) then
      table.insert( _playersay, string.sub( text, 5+1 ) )
    elseif isChatCommand( text, "looc" ) then
      table.insert( _playersay, string.sub( text, 6+1 ) )
    elseif isChatCommand( text, "advert" ) then
      table.insert( _playersay, Color( 255, 255, 0 ) )
      table.insert( _playersay, string.sub( text, 8+1 ) )
    elseif isChatCommand( text, _advertname ) then
      table.insert( _playersay, Color( 255, 255, 0 ) )
      table.insert( _playersay, string.sub( text, 1+string.len(_advertname)+1+1 ) )
    else
      table.insert( _playersay, text )
    end

    if _local == 1 then
      for k, receiver in pairs( _allPlayers ) do
        if sender:GetPos():Distance( receiver:GetPos() ) < 2000 then
          net.Start( "yrp_player_say" )
            net.WriteTable( _playersay )
          net.Send( receiver )
        end
      end
    else
      net.Start( "yrp_player_say" )
        net.WriteTable( _playersay )
      net.Broadcast()
    end
  end
  return ""
end
