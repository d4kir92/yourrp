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

function time_jail( ply )
  if ply:GetNWBool( "inJail", false ) then
    ply:SetNWInt( "jailtime", ply:GetNWInt( "jailtime", 0 ) - 1 )
    if ply:GetNWInt( "jailtime", 0 ) <= 0 then
      clean_up_jail( ply )
    end
  end
end

function check_salary( ply )
  if worked( ply:GetNWString( "money" ), "sv_think money fail" ) and worked( ply:GetNWInt( "capital" ), "sv_think capital fail" ) then
    if CurTime() >= ply:GetNWInt( "nextcapitaltime", 0 ) then
      ply:SetNWInt( "nextcapitaltime", CurTime() + ply:GetNWInt( "capitaltime" ) )

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

local _time = 0
timer.Create( "ServerThink", 1, 0, function()
  local _all_players = player.GetAll()

  for k, ply in pairs( _all_players ) do
    if !ply:GetNWBool( "inCombat" ) then
      reg_hp( ply )   --HealthReg
      reg_ar( ply )   --ArmorReg
      if ply:GetNWBool( "toggle_metabolism", false ) then
        if ply:GetNWInt( "hunger", 0 ) > 20 and _time%4 == 0 then
          reg_mb( ply ) --MetabolismReg (health up, when enough hunger)
        end
      end
    end

    if ply:GetNWBool( "toggle_hunger", false ) then
      con_hg( ply )
    end
    if ply:GetNWBool( "toggle_thirst", false ) then
      con_th( ply )
    end
    if ply:GetNWBool( "toggle_stamina", false ) then
      con_st( ply )
    end

    time_jail( ply )  --Jail

    check_salary( ply )
  end

  local _auto_save = 300
  if _time % _auto_save == 0 then
    save_clients( "Auto-Save ( " .. _auto_save .. " sec )" )
  end

  if _time >= 21600-30 then
    if _time >= 21600 then
      printGM( "gm", "Auto Reload" )
      timer.Simple( 1, function()
        game.ConsoleCommand( "changelevel " .. string.lower( game.GetMap() ) .. "\n" )
      end)
    else
      printGM( "gm", "Auto Reload in " .. 21600-_time .. " sec" )
    end
  end

  _time = _time + 1
end)
