--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function reg_hp( ply )
  if ply:GetNWInt( "GetHealthReg" ) != nil then
    ply:SetHealth( ply:Health() + ply:GetNWInt( "GetHealthReg" ) )
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
    ply:SetNWInt( "GetCurStamina", ply:GetNWInt( "GetCurStamina", 0 ) - ( ply:GetNWInt( "GetRegStamina", 1 )*2 ) )
    if ply:GetNWInt( "GetCurStamina", 0 ) < 0 then
      ply:SetNWInt( "GetCurStamina", 0 )
    end
  elseif ply:GetNWInt( "thirst", 0 ) > 20 then
    ply:SetNWInt( "GetCurStamina", ply:GetNWInt( "GetCurStamina", 0 ) + ply:GetNWInt( "GetRegStamina", 1 ) )
    if ply:GetNWInt( "GetCurStamina", 0 ) > ply:GetNWInt( "GetMaxStamina", 100 ) then
      ply:SetNWInt( "GetCurStamina", ply:GetNWInt( "GetMaxStamina", 100 ) )
    end
  end
  if ply:GetNWInt( "GetCurStamina", 0 ) < 20 or ply:GetNWInt( "thirst", 0 ) < 20 then
    ply:SetRunSpeed( ply:GetNWInt( "speedrun", 0 )*0.5 )
    ply:SetWalkSpeed( ply:GetNWInt( "speedwalk", 0 )*0.5 )
  else
    ply:SetRunSpeed( ply:GetNWInt( "speedrun", 0 ) )
    ply:SetWalkSpeed( ply:GetNWInt( "speedwalk", 0 ) )
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
  if worked( ply:GetNWString( "money" ), "sv_think money fail" ) and worked( ply:GetNWInt( "salary" ), "sv_think salary fail" ) then
    if CurTime() >= ply:GetNWInt( "nextsalarytime", 0 ) then
      ply:SetNWInt( "nextsalarytime", CurTime() + ply:GetNWInt( "salarytime" ) )

      local _m = ply:GetNWString( "money", -1 )
      local _money = tonumber( _m )
      local _c = ply:GetNWInt( "salary", -1 )
      local _salary = tonumber( _c )
      if _money != nil and _salary != nil then
        if _money != -1 and _salary != -1 then
          ply:SetNWString( "money", _money + _salary )
          ply:UpdateMoney()
        else
          ply:CheckMoney()
        end
      else
        printGM( "error", "FAIL @check_salary" )
      end
    end
  end
end

local _time = 0
timer.Create( "ServerThink", 1, 0, function()
  local _all_players = player.GetAll()

  for k, ply in pairs( _all_players ) do
    if !ply:GetNWBool( "inCombat" ) then
      ply:SetNWFloat( "uptime_current", ply:getuptimecurrent() )
      ply:SetNWFloat( "uptime_total", ply:getuptimetotal() )
      ply:SetNWFloat( "uptime_server", os.clock() )
      ply:addSecond()

      reg_hp( ply )   --HealthReg
      reg_ar( ply )   --ArmorReg
      if ply:GetNWBool( "toggle_metabolism", false ) then
        if ply:GetNWInt( "hunger", 0 ) > 20 and _time%4 == 0 then
          reg_mb( ply ) --MetabolismReg (health up, when enough hunger)
        end
      end
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

    time_jail( ply )  --Jail

    check_salary( ply )
  end

  if _time % 10 == 0 then
    for k, ply in pairs( _all_players ) do
      if ply:GetRoleName() == nil and ply:Alive() then
        ply:KillSilent()
      end
    end
  end

  local _auto_save = 300
  if _time % _auto_save == 0 then
    save_clients( "Auto-Save ( " .. _auto_save .. " sec )" )
  end

  if _time >= 21600-30 then
    if _time >= 21600 then
      printGM( "gm", "Auto Reload" )
      timer.Simple( 1, function()
        game.ConsoleCommand( "changelevel " .. db_sql_str2( string.lower( game.GetMap() ) ) .. "\n" )
      end)
    else
      printGM( "gm", "Auto Reload in " .. 21600-_time .. " sec" )
    end
  end

  _time = _time + 1
end)
