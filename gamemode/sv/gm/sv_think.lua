--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

hook.Add( "PlayerStartTaunt", "yrp_taunt_start", function( ply, act, length )
	ply:SetNWBool( "taunting", true )
	timer.Simple( length, function()
		ply:SetNWBool( "taunting", false )
	end)
end)

util.AddNetworkString( "client_lang" )
net.Receive( "client_lang", function( len, ply )
  local _lang = net.ReadString()
  printGM( "note", ply:YRPName() .. " using language: " .. string.upper( _lang ) )
  ply:SetNWString( "client_lang", _lang or "NONE" )
end)

function reg_hp( ply )
  if ply:GetNWInt( "GetHealthReg" ) != nil then
    ply:Heal( ply:GetNWInt( "GetHealthReg" ) )
    if ply:Health() > ply:GetMaxHealth() then
      ply:SetHealth( ply:GetMaxHealth() )
    end
  end
end

function reg_ar( ply )
  if ply:GetNWInt( "GetArmorReg" ) != nil then
    ply:SetArmor( ply:Armor() + ply:GetNWInt( "GetArmorReg" ) )
    if ply:Armor() > ply:GetNWInt( "GetMaxArmor" ) then
      ply:SetArmor( ply:GetNWInt( "GetMaxArmor" ) )
    end
  end
end

function reg_mb( ply )
  ply:SetHealth( ply:Health() + 1 )
  if ply:Health() > ply:GetMaxHealth() then
    ply:SetHealth( ply:GetMaxHealth() )
  end
end

function con_hg( ply )
  ply:SetNWInt( "hunger", ply:GetNWInt( "hunger", 0 ) - 0.1 )
  if ply:GetNWInt( "hunger", 0 ) < 0 then
    ply:SetNWInt( "hunger", 0 )
  end
  if ply:GetNWInt( "hunger", 0 ) < 20 then
    ply:TakeDamage( ply:GetMaxHealth() / 100 )
  end
end

function con_th( ply )
  ply:SetNWInt( "thirst", ply:GetNWInt( "thirst", 0 ) - 0.2 )
  if ply:GetNWInt( "thirst", 0 ) < 0 then
    ply:SetNWInt( "thirst", 0 )
  end
end

function con_st( ply )
  if ply:GetMoveType() != MOVETYPE_NOCLIP and !ply:IsOnGround() or ply:KeyDown( IN_SPEED ) and ( ply:KeyDown( IN_FORWARD ) or ply:KeyDown( IN_BACK ) or ply:KeyDown( IN_MOVERIGHT ) or ply:KeyDown( IN_MOVELEFT ) ) and !ply:InVehicle() then
    ply:SetNWInt( "GetCurStamina", ply:GetNWInt( "GetCurStamina", 0 ) - ( ply:GetNWInt( "stamindown", 1 ) ) )
    if ply:GetNWInt( "GetCurStamina", 0 ) < 0 then
      ply:SetNWInt( "GetCurStamina", 0 )
    end
  elseif ply:GetNWInt( "thirst", 0 ) > 20 then
    ply:SetNWInt( "GetCurStamina", ply:GetNWInt( "GetCurStamina", 0 ) + ply:GetNWInt( "staminup", 1 ) )
    if ply:GetNWInt( "GetCurStamina", 0 ) > ply:GetNWInt( "GetMaxStamina", 100 ) then
      ply:SetNWInt( "GetCurStamina", ply:GetNWInt( "GetMaxStamina", 100 ) )
    end
  end
  if ply:GetNWInt( "GetCurStamina", 0 ) < 20 or ply:GetNWInt( "thirst", 0 ) < 20 then
    ply:SetRunSpeed( ply:GetNWInt( "speedrun", 0 )*0.6 )
    ply:SetWalkSpeed( ply:GetNWInt( "speedwalk", 0 )*0.6 )
    ply:SetCanWalk( false )
  else
    ply:SetRunSpeed( ply:GetNWInt( "speedrun", 0 ) )
    ply:SetWalkSpeed( ply:GetNWInt( "speedwalk", 0 ) )
    ply:SetCanWalk( true )
  end
end

function broken( ply )
  if ply:GetNWBool( "broken_leg_left" ) and ply:GetNWBool( "broken_leg_right" ) then
    --[[ Both legs broken ]]--
    ply:SetRunSpeed( ply:GetNWInt( "speedrun", 0 )*0.5 )
    ply:SetWalkSpeed( ply:GetNWInt( "speedwalk", 0 )*0.5 )
    ply:SetCanWalk( false )
  elseif ply:GetNWBool( "broken_leg_left" ) or ply:GetNWBool( "broken_leg_right" ) then
    --[[ One leg broken ]]--
    ply:SetRunSpeed( ply:GetNWInt( "speedrun", 0 )*0.25 )
    ply:SetWalkSpeed( ply:GetNWInt( "speedwalk", 0 )*0.25 )
    ply:SetCanWalk( false )
  else
    ply:SetRunSpeed( ply:GetNWInt( "speedrun", 0 ) )
    ply:SetWalkSpeed( ply:GetNWInt( "speedwalk", 0 ) )
    ply:SetCanWalk( true )
  end
end

function reg_ab( ply )
  ply:SetNWInt( "GetCurAbility", ply:GetNWInt( "GetCurAbility", 0 ) + ply:GetNWInt( "GetRegAbility", 1 ) )

  if ply:GetNWInt( "GetCurAbility" ) > ply:GetNWInt( "GetMaxAbility" ) then
    ply:SetNWInt( "GetCurAbility", ply:GetNWInt( "GetMaxAbility" ) )
  elseif ply:GetNWInt( "GetCurAbility" ) < 0 then
    ply:SetNWInt( "GetCurAbility", 0 )
  end
end

function time_jail( ply )
  if ply:GetNWBool( "inJail", false ) then
    ply:SetNWInt( "jailtime", ply:GetNWInt( "jailtime", 0 ) - 1 )
    if ply:GetNWInt( "jailtime", 0 ) <= 0 then
      clean_up_jail( ply )
    end
  end
end

function check_salary( ply )
  if worked( ply:GetNWString( "money" ), "sv_think money fail" ) and worked( ply:GetNWString( "salary" ), "sv_think salary fail" ) then
    if CurTime() >= ply:GetNWInt( "nextsalarytime", 0 ) and ply:HasCharacterSelected() and ply:Alive() then
      ply:SetNWInt( "nextsalarytime", CurTime() + ply:GetNWInt( "salarytime" ) )

      local _m = ply:GetNWString( "money", "FAILED" )
      local _ms = ply:GetNWString( "salary", "FAILED" )
      if _m == "FAILED" or _ms == "FAILED" then
        printGM( "error", "_m or _ms failed " .. _m .. " " .. _ms )
        return false
      end
      local _money = tonumber( _m )
      local _salary = tonumber( _ms )
      if _money != nil and _salary != nil then
        ply:SetNWString( "money", _money + _salary )
        ply:UpdateMoney()
      else
        printGM( "error", "CheckMoney in check_salary [ money: " .. tostring( _money ) .. " salary: " .. tostring( _salary ) .. " ]" )
        ply:CheckMoney()
      end
    end
  end
end

function checkNPC( uid )
  for j, npc in pairs( ents.GetAll() ) do
    if npc:IsNPC() then
      if npc:GetNWString( "dealerID", "FAILED" ) == tostring( uid ) then
        return true
      end
    end
  end
  return false
end

local _time = 0
timer.Create( "ServerThink", 1, 0, function()
  local _all_players = player.GetAll()

  for k, ply in pairs( _all_players ) do
    ply:addSecond()

    if ply:GetNWBool( "loaded", false ) then
      if !ply:GetNWBool( "inCombat" ) then
        ply:CheckHeal()

        reg_hp( ply )   --HealthReg
        reg_ar( ply )   --ArmorReg
        if ply:GetNWBool( "toggle_metabolism", false ) then
          if ply:GetNWInt( "hunger", 0 ) > 20 and _time%4 == 0 then
            reg_mb( ply ) --MetabolismReg (health up, when enough hunger)
          end
        end
      end

      if ply:IsBleeding() then
        local effect = EffectData()
        effect:SetOrigin( ply:GetPos() - ply:GetBleedingPosition() )
        effect:SetScale( 1 )
        util.Effect( "bloodimpact", effect )
        ply:TakeDamage( 0.5, ply, ply )
      end

      if ply:GetNWBool( "toggle_hunger", false ) then
        --con_hg( ply )
      end
      if ply:GetNWBool( "toggle_thirst", false ) then
        --con_th( ply )
      end
      if ply:GetNWBool( "toggle_stamina", false ) then
        con_st( ply )
      end

      reg_ab( ply )
      time_jail( ply )
      check_salary( ply )
      broken( ply )
    end
  end

  if _time % 10 == 0 then
		if !game.IsDedicated() then
			PrintMessage( HUD_PRINTCENTER, "Please use a dedicated server, for the best experience!" )
		end

    for i, ply in pairs( _all_players ) do
      if ply:GetRoleName() == nil and ply:Alive() then
        if !ply:IsBot() then
          ply:KillSilent()
        end
      end
    end
    local _dealers = db_select( "yrp_dealers", "*", "map = '" .. db_sql_str2( string.lower( game.GetMap() ) ) .. "'" )
    if _dealers != nil then
      for i, dealer in pairs( _dealers ) do
        if dealer.uniqueID != "-1" then
          if !checkNPC( dealer.uniqueID ) then
            local _del = db_select( "yrp_" .. db_sql_str2( string.lower( game.GetMap() ) ), "*", "type = 'dealer' AND linkID = '" .. dealer.uniqueID .. "'" )
            if _del != nil then
              printGM( "gm", "DEALER [" .. dealer.name .. "] NOT ALIVE, reviving!" )
              _del = _del[1]
              local _dealer = ents.Create( "yrp_dealer" )
              _dealer:SetNWString( "dealerID", dealer.uniqueID )
              _dealer:SetNWString( "name", dealer.name )
              local _pos = string.Explode( ",", _del.position )
              _pos = Vector( _pos[1], _pos[2], _pos[3] )
              _dealer:SetPos( _pos )
              local _ang = string.Explode( ",", _del.angle )
              _ang = Angle( 0, _ang[2], 0 )
              _dealer:SetAngles( _ang )
              _dealer:SetModel( dealer.WorldModel )
              _dealer:Spawn()

							local sequence = _dealer.Entity:LookupSequence("idle_all_01")
							_dealer.Entity:ResetSequence(sequence)
							timer.Simple( 2, function()
								if _dealer != nil then
									if _dealer.Entity != NULL then
										local sequence2 = _dealer.Entity:LookupSequence("idle_all_01")
										_dealer.Entity:ResetSequence(sequence2)
									end
								end
							end)
            end
          end
        end
      end
    end
  end

  local _auto_save = 300
  if _time % _auto_save == 0 then
    local _mod = _time%60
    local _left = _time/60 - _mod
    save_clients( "Auto-Save ( Uptime: " .. _left .. " " .. lang_string( "minutes" ) .. " )" )
  end

  local _changelevel = 21600
  if _time >= _changelevel-30 then
    if _time >= _changelevel then
      printGM( "gm", "Auto Reload" )
      timer.Simple( 1, function()
        game.ConsoleCommand( "changelevel " .. db_sql_str2( string.lower( game.GetMap() ) ) .. "\n" )
      end)
    else
      printGM( "gm", "Auto Reload in " .. _changelevel-_time .. " sec" )
    end
  end

  _time = _time + 1
end)
