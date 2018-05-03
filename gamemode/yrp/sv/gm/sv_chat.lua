--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

util.AddNetworkString( "yrp_player_say" )

local paket = {}
paket.lokal = true
paket.command = "/test"
paket.text = "TESTTEXT"
paket.sender = "UNKNOWN"
paket.usergroup = "USER"

function is_chat_command( string, command )
  if string != nil and command != nil then
    local _size = string.len( string.lower( command ) )
    local _slash = string.sub( string.lower( string ), 1, 1+_size ) == "/" .. string.lower( command )
    local _call = string.sub( string.lower( string ), 1, 1+_size ) == "!" .. string.lower( command )
    if _slash or _call then
      paket.iscommand = true
      return true
    else
      paket.iscommand = false
      return false
    end
  end
  paket.iscommand = false
  return false
end

function get_player_by_name( string )
  for k, ply in pairs( player.GetAll() ) do
    if string.find( string.lower( ply:Nick() ), string.lower( string ), 1, false ) or string.find( string.lower( ply:RPName() ), string.lower( string ), 1, false ) or string.find( string.lower( ply:SteamName() ), string.lower( string ), 1, false ) then
      return ply
    end
  end
  return NULL
end

function print_warning( string )
  local _table = {}
  _table[1] = Color( 255, 0, 0 )
  _table[2] = string
  net.Start( "yrp_player_say" )
    net.WriteTable( _table )
  net.Broadcast()
end

function print_help( sender )
  sender:ChatPrint( "" )
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
  sender:ChatPrint( "sleep - sleep or wake up" )
  sender:ChatPrint( "tag_ug - show usergroup tag" )
  sender:ChatPrint( "tag_immortal - shows immortal tag" )
  sender:ChatPrint( "" )
  return ""
end


function roll_number( sender )
  local number = math.Round( math.Rand( 0, 100 ) )
  return number
end

function drop_weapon( sender )
  if ea( sender ) then
    local _weapon = sender:GetActiveWeapon()
    if _weapon != nil and PlayersCanDropWeapons() then
      sender:DropWeapon( _weapon )
    else
      printGM( "note", sender:YRPName() .. " drop weapon is disabled!" )
    end
  end
  return ""
end

function drop_money( sender, text )
  local _table = string.Explode( " ", text )
  local _money = tonumber( _table[2] )
  if isnumber( _money ) then
    local _moneyAmount = math.abs( _money )
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
  sender:ChatPrint( "Command-FAILED" )
end

function do_suicide( sender )
  sender:Kill()
  return ""
end

function show_tag_dev( sender )
  if !sender:GetNWBool( "tag_dev", false ) then
    sender:SetNWBool( "tag_dev", true )
  else
    sender:SetNWBool( "tag_dev", false )
  end
  return ""
end
function show_tag_ug( sender )
  if !sender:GetNWBool( "tag_ug", false ) then
    sender:SetNWBool( "tag_ug", true )
  else
    sender:SetNWBool( "tag_ug", false )
  end
  return ""
end
function show_tag_immortal( sender )
  if !sender:GetNWBool( "tag_immortal", false ) then
    sender:SetNWBool( "tag_immortal", true )
  else
    sender:SetNWBool( "tag_immortal", false )
  end
  return ""
end

function set_money( sender, text )
  if sender:HasAccess() then
    local _table = string.Explode( " ", text, false )
    local _name = _table[2]
    local _money = tonumber( _table[3] )
    if isnumber( _money ) then
      local ply = get_player_by_name( _name )
      ply:SetMoney( _money )
      printGM( "note", sender:Nick() .. " sets the money of " .. ply:Nick() .. " to " .. _money )
      return ""
    end
    sender:ChatPrint( "Command-FAILED" )
  else
    printGM( "note", sender:YRPName() .. " tried to use setmoney!" )
  end
end

function add_money( sender, text )
  if sender:HasAccess() then
    local _table = string.Explode( " ", text, false )
    local _name = _table[2]
    local _money = tonumber( _table[3] )
    if isnumber( _money ) then
      local _receiver = get_player_by_name( _name )
      if worked( _receiver, "money receiver not found!" ) then
        _receiver:addMoney( _money )
        return ""
      else
        sender:ChatPrint( "Command-FAILED NAME not found" )
      end
    end
  else
    printGM( "note", sender:Nick() .. " tried to use addmoney!" )
  end
end

function do_sleep( sender )
  if sender:GetNWBool( "ragdolled", false ) then
    DoUnRagdoll( sender )
  else
    DoRagdoll( sender )
  end
end

util.AddNetworkString( "set_chat_mode" )

net.Receive( "set_chat_mode", function( len, ply )
  local _str = net.ReadString() or "say"
  ply:SetNWString( "chat_mode", string.lower( _str ) )
end)

function unpack_paket( sender, text, iscommand )

  if string.find( text[1], "/", 1, false ) or string.find( text[1], "!", 1, false ) then
    --command
    local _start = 2
    local _end = string.find( text, " ", 1, false )
    if _end != nil then
      _end = _end -1
    end

    paket.command = string.sub( text, _start, _end )

    --text
    local _start_txt = _end or 0
    _start_txt = _start_txt + 2

    paket.text = string.sub( text, _start_txt )
  else
    paket.command = sender:GetNWString( "chat_mode", "say" )
    paket.text = text
  end

  paket.text_color = Color( 255, 255, 255 )

  if paket.command == "advert" then
    paket.command_color = Color( 255, 255, 0 )
    paket.text_color = Color( 255, 255, 0 )
  elseif paket.command == "me" then
    paket.command_color = Color( 0, 255, 0 )
    paket.text_color = Color( 0, 255, 0 )
  elseif paket.command == "say" then
    paket.command_color = Color( 100, 255, 100 )
    paket.text_color = Color( 255, 255, 255 )
  elseif paket.command == "ooc" or paket.command == "looc" then
    paket.command_color = Color( 100, 255, 100 )
  elseif paket.command == "admin" then
    paket.command_color = Color( 255, 255, 0 )
    paket.text_color = Color( 255, 255, 20 )
  elseif paket.command == "group" then
    paket.command_color = Color( 160, 160, 255 )
    paket.text_color = Color( 160, 160, 255 )
  elseif paket.command == "role" then
    paket.command_color = Color( 0, 255, 0 )
    paket.text_color = Color( 20, 255, 20 )
  elseif paket.command == "yell" then
    paket.command_color = Color( 255, 0, 0 )
    paket.text_color = Color( 255, 0, 0 )
  elseif paket.command == "roll" then
    paket.command_color = Color( 100, 100, 255 )
    paket.text_color = Color( 100, 100, 255 )
  else
    paket.command_color = Color( 255, 0, 0 )
  end

  paket.steamname = sender:SteamName()
  paket.rpname = sender:RPName()
  paket.usergroup = sender:GetUserGroup()
  paket.role = sender:GetNWString( "roleName" )
  paket.group = sender:GetNWString( "groupName" )
end

function GM:PlayerSay( sender, text, teamChat )

  unpack_paket( sender, text )

  paket.command = string.lower( paket.command )

  if paket.command == "ooc" or paket.command == "advert" then
    paket.lokal = false
  else
    paket.lokal = true
  end

  if paket.command == "help" then
    print_help( sender )
    return ""
  end

  if paket.command == "dropweapon" then
    drop_weapon( sender )
    return ""
  end

  if paket.command == "dropmoney" then
    drop_money( sender, text )
    return ""
  end

  if paket.command == "kill" then
    do_suicide( sender )
    return ""
  end

  if paket.command == "tag_dev" then
    show_tag_dev( sender )
    return ""
  end

  if paket.command == "tag_ug" then
    show_tag_ug( sender )
    return ""
  end

  if paket.command == "tag_immortal" then
    show_tag_immortal( sender )
    return ""
  end

  if paket.command == "setmoney" then
    set_money( sender, text )
    return ""
  end

  if paket.command == "addmoney" then
    add_money( sender, text )
    return ""
  end

  if paket.command == "sleep" then
    do_sleep( sender )
    return ""
  end

  local pk = {}
  pk.iscommand = paket.iscommand
  pk.command = paket.command
  pk.command_color = paket.command_color
  pk.text = paket.text
  pk.text_color = paket.text_color
  pk.lokal = paket.lokal
  pk.rpname = paket.rpname
  pk.steamname = paket.steamname
  pk.usergroup = paket.usergroup
  pk.rolename = paket.role
  pk.groupname = paket.group

  if paket.command == "roll" then
    pk.text = lang_string( "rolledpre" ) .. " " .. tostring( roll_number( sender ) ) .. " " .. lang_string( "rolledpos" ) .. "!"
  end

  if paket.command == "admin" then
    if sender:HasAccess() then
      for k, receiver in pairs( player.GetAll() ) do
        if receiver:HasAccess() then
          net.Start( "yrp_player_say" )
            net.WriteTable( pk )
          net.Send( receiver )
        end
      end
      return ""
    else
      return ""
    end
  end

  if paket.command == "group" then
    for k, receiver in pairs( player.GetAll() ) do
      if receiver:GetNWString( "groupName" ) == sender:GetNWString( "groupName" ) then
        net.Start( "yrp_player_say" )
          net.WriteTable( pk )
        net.Send( receiver )
      end
    end
    return ""
  end

  if paket.command == "role" then
    for k, receiver in pairs( player.GetAll() ) do
      if receiver:GetNWString( "roleName" ) == sender:GetNWString( "roleName" ) then
        net.Start( "yrp_player_say" )
          net.WriteTable( pk )
        net.Send( receiver )
      end
    end
    return ""
  end

  if !paket.lokal then
    net.Start( "yrp_player_say" )
      net.WriteTable( pk )
    net.Broadcast()
  elseif paket.lokal then
    for k, receiver in pairs( player.GetAll() ) do
      if sender:GetPos():Distance( receiver:GetPos() ) < 400 then
        net.Start( "yrp_player_say" )
          net.WriteTable( pk )
        net.Send( receiver )
      end
    end
  end
  return ""
end
