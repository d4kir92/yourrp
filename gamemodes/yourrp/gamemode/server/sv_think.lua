--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

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

function GM:CanPlayerSuicide( ply )
  if ply:IsSuperAdmin() or ply:IsAdmin() then
    return true
  else
    return false
  end
end

local time = 0
timer.Create( "ServerThink", 1, 0, function()
  local _allPlayers = player.GetAll()

  for k, ply in pairs( _allPlayers ) do
    if !ply:GetNWBool( "inCombat" ) then
      --HealthReg
      if ply:GetNWInt( "GetHealthReg" ) != nil then
        ply:SetHealth( ply:Health() + ply:GetNWInt( "GetHealthReg" ) )
        if ply:Health() > ply:GetMaxHealth() then
          ply:SetHealth( ply:GetMaxHealth() )
        end
      end

      --ArmorReg
      if ply:GetNWInt( "GetArmorReg" ) != nil then
        ply:SetArmor( ply:Armor() + ply:GetNWInt( "GetArmorReg" ) )
        if ply:Armor() > ply:GetNWInt( "GetMaxArmor" ) then
          ply:SetArmor( ply:GetNWInt( "GetMaxArmor" ) )
        end
      end

      if ply:GetNWBool( "metabolism", false ) then
        if ply:GetNWInt( "hunger", 0 ) > 20 and time%4 == 0 then
          ply:SetHealth( ply:Health() + 1 )
          if ply:Health() > ply:GetMaxHealth() then
            ply:SetHealth( ply:GetMaxHealth() )
          end
        end
      end
    end

    if ply:GetNWBool( "metabolism", false ) then
      --Hunger
      ply:SetNWInt( "hunger", ply:GetNWInt( "hunger", 0 ) - 0.1 )
      if ply:GetNWInt( "hunger", 0 ) < 0 then
        ply:SetNWInt( "hunger", 0 )
      end
      if ply:GetNWInt( "hunger", 0 ) < 20 then
        ply:TakeDamage( ply:GetMaxHealth() / 100 )
      end

      --Thirst
      ply:SetNWInt( "thirst", ply:GetNWInt( "thirst", 0 ) - 0.2 )
      if ply:GetNWInt( "thirst", 0 ) < 0 then
        ply:SetNWInt( "thirst", 0 )
      end

      --Stamina
      if !ply:IsOnGround() or ply:KeyDown( IN_SPEED ) and ( ply:KeyDown( IN_FORWARD ) or ply:KeyDown( IN_BACK ) or ply:KeyDown( IN_MOVERIGHT ) or ply:KeyDown( IN_MOVELEFT ) ) then
        ply:SetNWInt( "stamina", ply:GetNWInt( "stamina", 0 ) - 2 )
        if ply:GetNWInt( "stamina", 0 ) < 0 then
          ply:SetNWInt( "stamina", 0 )
        end
      elseif ply:GetNWInt( "thirst", 0 ) > 20 then
        ply:SetNWInt( "stamina", ply:GetNWInt( "stamina", 0 ) + 1 )
        if ply:GetNWInt( "stamina", 0 ) > 100 then
          ply:SetNWInt( "stamina", 100 )
        end
      end
      if ply:GetNWInt( "stamina", 0 ) < 20 or ply:GetNWInt( "thirst", 0 ) < 20 then
        ply:SetRunSpeed( ply:GetNWInt( "speedrun", 0 )*0.5 )
        ply:SetWalkSpeed( ply:GetNWInt( "speedwalk", 0 )*0.5 )
      else
        ply:SetRunSpeed( ply:GetNWInt( "speedrun", 0 ) )
        ply:SetWalkSpeed( ply:GetNWInt( "speedwalk", 0 ) )
      end
    end

    --Jail
    if ply:GetNWBool( "inJail", false ) then
      ply:SetNWInt( "jailtime", ply:GetNWInt( "jailtime", 0 ) - 1 )
      if ply:GetNWInt( "jailtime", 0 ) <= 0 then
        cleanUpJail( ply )
      end
    end
  end

  if time % 120 == 0 then
    for k, ply in pairs( _allPlayers ) do
      if worked( ply:GetNWString( "money" ), "sv_think money fail" ) and worked( ply:GetNWInt( "capital" ), "sv_think capital fail" ) then
        local _m = ply:GetNWString( "money", -1 )
        local _money = tonumber( _m )
        local _c = ply:GetNWInt( "capital", -1 )
        local _capital = tonumber( _c )
        if _money != -1 and _capital != -1 then
          ply:SetNWString( "money", _money + _capital )
          ply:UpdateMoney()
        else
          ply:CheckMoney()
        end
      end
    end
  end

  if time % 300 == 0 then
    saveClients( "Auto-Save ( 5 min )" )
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
  --[[if listener:GetPos():Distance( talker:GetPos()) < 1000 then
    return true, true
  else
    return false, false
  end]]--
end

util.AddNetworkString( "yrp_player_say" )

function isChatCommand( string, command )
  if string != nil and command != nil then
    local size = string.len( string.lower( command ) )
    local slash = string.sub( string.lower( string ), 1, 1+size ) == "/" .. string.lower( command )
    local call = string.sub( string.lower( string ), 1, 1+size ) == "!" .. string.lower( command )
    if slash or call then
      return true
    else
      return false
    end
  end
  return false
end

function getPlayer( string )
  for k, ply in pairs( player.GetAll() ) do
    if string.find( string.lower( ply:Nick() ), string, 1, false ) then
      return ply
    end
  end
end

function printWarning( string )
  local table = {}
  table[1] = Color( 255, 0, 0 )
  table[2] = string
  net.Start( "yrp_player_say" )
    net.WriteTable( table )
  net.Broadcast()
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
    local _local = 1
    _playersay = {}

    if isChatCommand( text, "help" ) then
      sender:ChatPrint( "\n" )
      sender:ChatPrint( "[HELP]" )
      sender:ChatPrint( "me - Emote chat" )
      sender:ChatPrint( "yell - Yell locally" )
      sender:ChatPrint( "ooc or / - Out of character chat" )
      sender:ChatPrint( "looc or . - Local out of character chat" )
      sender:ChatPrint( "advert - Advert chat" )
      sender:ChatPrint( "dropweapon - Drops the current weapon" )
      sender:ChatPrint( "dropmoney AMOUNT - drop money to ground" )
      sender:ChatPrint( "roll - roll a number between 0 and 100" )
      sender:ChatPrint( "kill - suicide" )
      sender:ChatPrint( "" )
      return ""
    end

    if isChatCommand( text, "dropweapon" ) then
      local _weapon = sender:GetActiveWeapon()
      if _weapon != nil then
        sender:DropWeapon( _weapon )
      end
      return ""
    end

    if isChatCommand( text, "dropmoney" ) then
      local _table = string.Explode( " ", text )
      local _moneyAmount = tonumber( _table[2] )
      if isnumber( _moneyAmount ) then
        if sender:canAfford( _moneyAmount ) then
          local _money = ents.Create( "yrp_money" )
          sender:addMoney( -_moneyAmount )
          local tr = util.TraceHull( {
          	start = sender:GetPos() + sender:GetUp() * 74,
            endpos = sender:GetPos() + sender:GetUp() * 74 + sender:GetForward() * 64,
          	filter = sender,
          	mins = Vector( -10, -10, -10 ),
          	maxs = Vector( 10, 10, 10 ),
          	mask = MASK_SHOT_HULL
          } )
          if tr.Hit then
            local tr2 = util.TraceHull( {
            	start = sender:GetPos() + sender:GetUp() * 74,
              endpos = sender:GetPos() + sender:GetUp() * 74 - sender:GetForward() * 64,
            	filter = sender,
            	mins = Vector( -10, -10, -10 ),
            	maxs = Vector( 10, 10, 10 ),
            	mask = MASK_SHOT_HULL
            } )
            if tr2.Hit then
              _money:SetPos( sender:GetPos() + sender:GetUp() * 74 )
            else
              _money:SetPos( sender:GetPos() + sender:GetUp() * 74 - sender:GetForward() * 64 )
            end
          else
            _money:SetPos( sender:GetPos() + sender:GetUp() * 74 + sender:GetForward() * 64 )
          end
          _money:Spawn()
          _money:SetMoney( _moneyAmount )
          printGM( "note", sender:Nick() .. " dropped " .. _moneyAmount .. " money" )
          return ""
        else
          printGM( "note", sender:Nick() .. " can't afford to dropmoney (" .. _moneyAmount .. ")" )
        end
      else
        printGM( "note", "Failed dropmoney" )
      end
      boxString( "Command-FAILED", Color( 255, 0, 0 ), Color( 255, 255, 255 ) )
    end

    if isChatCommand( text, "kill" ) then
      sender:Kill()
      return ""
    end

    if isChatCommand( text, "tag" ) then
      if !sender:GetNWBool( "tag", false ) then
        sender:SetNWBool( "tag", true )
      else
        sender:SetNWBool( "tag", false )
      end
      return ""
    end

    if isChatCommand( text, "setmoney" ) then
      if sender:IsAdmin() or sender:IsSuperAdmin() then
        local _table = string.Explode( " ", text, false )
        local _name = _table[2]
        local _money = tonumber( _table[3] )
        if isnumber( _money ) then
          local ply = getPlayer( _name )
          ply:SetMoney( _money )
          printGM( "note", sender:Nick() .. " sets the money of " .. ply:Nick() .. " to " .. _money )
          return ""
        end
        boxString( "Command-FAILED", Color( 255, 0, 0 ), Color( 255, 255, 255 ) )
      else
        printGM( "note", sender:Nick() .. " tried to use setmoney!" )
      end
    end

    if isChatCommand( text, "addmoney" ) then
      if sender:IsAdmin() or sender:IsSuperAdmin() then
        local _table = string.Explode( " ", text, false )
        local _name = _table[2]
        local _money = tonumber( _table[3] )
        if isnumber( _money ) then
          local ply = getPlayer( _name )
          ply:addMoney( _money )
          return ""
        end
        boxString( "Command-FAILED", Color( 255, 0, 0 ), Color( 255, 255, 255 ) )
      else
        printGM( "note", sender:Nick() .. " tried to use addmoney!" )
      end
    end

    if !sender:Alive() then
      boxString( "DEAD", Color( 255, 0, 0 ), Color( 255, 255, 255 ) )
    end

    if isChatCommand( text, "roll" ) then
      _local = 1
      boxString( string.upper( lang.localchat ), Color( 0, 165, 255 ), Color( 0, 165, 255 ) )
      boxString( "ROLL", Color( 0, 165, 255 ), Color( 0, 165, 255 ) )
    elseif isChatCommand( text, "ooc" ) or isChatCommand( text, "/" ) then
      _local = 0
      boxString( string.upper( lang.globalchat ), Color( 255, 165, 0 ), Color( 255, 165, 0 ) )
    elseif isChatCommand( text, "looc" ) or isChatCommand( text, "." ) then
      _local = 1
      boxString( string.upper( lang.localchat ), Color( 255, 50, 0 ), Color( 255, 50, 0 ) )
    elseif isChatCommand( text, "advert" ) or isChatCommand( text, _advertname ) then
      _local = 0
      boxString( string.upper( lang.globalchat ), Color( 255, 255, 0 ), Color( 255, 255, 0 ) )
      boxString( string.upper( _advertname ), Color( 255, 255, 0 ), Color( 255, 50, 0 ) )
    end

    if isChatCommand( text, "me" ) then
      _local = 1
      boxString( string.upper( lang.localchat ), Color( 255, 165, 0 ), Color( 255, 165, 0 ) )
      --Group
      table.insert( _playersay, Color( 0, 255, 0 ) )
      table.insert( _playersay, string.upper( sender:GetNWString("groupName") ) .. " " )

      --Role
      table.insert( _playersay, Color( 0, 255, 0 ) )
      table.insert( _playersay, string.upper( sender:GetNWString("roleName") ) .. " " )

      --Nickname
      table.insert( _playersay, Color( 0, 255, 0 ) )
      table.insert( _playersay, sender:GetNWString( "rpname" ) )
    elseif isChatCommand( text, "yell" ) then
      _local = 1
      boxString( string.upper( lang.localchat ), Color( 255, 0, 0 ), Color( 255, 0, 0 ) )
      --Group
      table.insert( _playersay, Color( 255, 0, 0 ) )
      table.insert( _playersay, string.upper( sender:GetNWString("groupName") ) .. " " )

      --Role
      table.insert( _playersay, Color( 255, 0, 0 ) )
      table.insert( _playersay, string.upper( sender:GetNWString("roleName") ) .. " " )

      --Nickname
      table.insert( _playersay, Color( 255, 0, 0 ) )
      table.insert( _playersay, sender:GetNWString( "rpname" ) )
      table.insert( _playersay, ":\n" )
    elseif isChatCommand( text, "looc" ) or isChatCommand( text, "ooc" ) or isChatCommand( text, "/" ) or isChatCommand( text, "." ) then
      --UserGroup
      table.insert( _playersay, Color( 100, 100, 255 ) )
      table.insert( _playersay, string.upper( sender:GetUserGroup() ) .. " " )

      --Nick
      table.insert( _playersay, Color( 200, 200, 255 ) )
      table.insert( _playersay, sender:Nick() .. ": " )
      table.insert( _playersay, "\n" )
    elseif isChatCommand( text, "roll" ) then
      _local = 1
      --Group
      table.insert( _playersay, Color( 0, 165, 255 ) )
      table.insert( _playersay, string.upper( sender:GetNWString("groupName") ) .. " " )

      --Role
      table.insert( _playersay, Color( 0, 165, 255 ) )
      table.insert( _playersay, string.upper( sender:GetNWString("roleName") ) .. " " )

      --Nickname
      table.insert( _playersay, Color( 0, 165, 255 ) )
      table.insert( _playersay, sender:GetNWString( "rpname" ) .. " rolled " )
    elseif isChatCommand( text, "advert" ) then
      _local = 0
      --Group
      table.insert( _playersay, Color( 0, 255, 0 ) )
      table.insert( _playersay, string.upper( sender:GetNWString("groupName") ) .. " " )

      --Role
      table.insert( _playersay, Color( 0, 255, 0 ) )
      table.insert( _playersay, string.upper( sender:GetNWString("roleName") ) .. " " )

      --Nickname
      table.insert( _playersay, Color( 0, 255, 0 ) )
      table.insert( _playersay, sender:GetNWString( "rpname" ) .. ": " )
      table.insert( _playersay, "\n" )
    else
      _local = 1
      boxString( string.upper( lang.localchat ), Color( 0, 255, 0 ), Color( 0, 255, 0 ) )
      --Group
      table.insert( _playersay, Color( 0, 255, 0 ) )
      table.insert( _playersay, string.upper( sender:GetNWString("groupName") ) .. " " )

      --Role
      table.insert( _playersay, Color( 0, 255, 0 ) )
      table.insert( _playersay, string.upper( sender:GetNWString("roleName") ) .. " " )

      --Nickname
      table.insert( _playersay, Color( 0, 255, 0 ) )
      table.insert( _playersay, sender:GetNWString( "rpname" ) .. ": " )
      table.insert( _playersay, "\n" )
    end

    --Text
    table.insert( _playersay, Color( 255, 255, 255 ) )
    if isChatCommand( text, "me" ) then
      table.insert( _playersay, Color( 0, 255, 0 ) )
      table.insert( _playersay, string.sub( text, 4 ) )
    elseif isChatCommand( text, "yell" ) then
      table.insert( _playersay, Color( 255, 0, 0 ) )
      table.insert( _playersay, string.sub( text, 7 ) )
    elseif isChatCommand( text, "roll" ) then
      table.insert( _playersay, Color( 0, 165, 255 ) )
      table.insert( _playersay, tostring( math.Round( math.Rand( 0, 100 ) ) ) )
    elseif isChatCommand( text, "/" ) then
      table.insert( _playersay, string.sub( text, 3+1 ) )
    elseif isChatCommand( text, "." ) then
      table.insert( _playersay, string.sub( text, 3+1 ) )
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
