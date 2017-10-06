--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

include("shared.lua")

function upgradeButton( mp, parent, w, h, x, y, item, _net, name )
  local tmp = createD( "DPanel", parent, w, h, x, y )
  function tmp:Paint( pw, ph )
    draw.RoundedBox( ctr( 10 ), 0, 0, pw, ph, Color( 100, 100, 100, 200 ) )

    draw.SimpleText( "lvl: " .. mp:GetNWInt( item, -1 ) .. "/" .. mp:GetNWInt( item .. "Max", -1 ) .. " " .. name, "HudBars", ctr( 10 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
  end
  local tmpBut = createD( "DButton", tmp, ctr( 200 ), h, w - ctr( 200 ), 0 )
  tmpBut:SetText( "" )
  function tmpBut:Paint( pw, ph )
    local cost = ( mp:GetNWInt( item ) * mp:GetNWInt( item .. "Cost" ) )
    if mp:GetNWInt( item ) < mp:GetNWInt( item .. "Max" ) then
      if self:IsHovered() then
        draw.RoundedBox( ctr( 10 ), 0, 0, pw, ph, Color( 255, 255, 0, 200 ) )
        draw.SimpleText( cost .. "€", "HudBars", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      else
        draw.RoundedBox( ctr( 10 ), 0, 0, pw, ph, Color( 255, 255, 255, 200 ) )
        draw.SimpleText( "Upgrade", "HudBars", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      end
    else
      draw.RoundedBox( ctr( 10 ), 0, 0, pw, ph, Color( 0, 255, 0, 200 ) )
      draw.SimpleText( "Max", "HudBars", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
  end
  function tmpBut:DoClick()
    net.Start( _net )
      net.WriteEntity( mp )
    net.SendToServer()
  end
end

local upgradeframe = nil
net.Receive( "getMoneyPrintMenu", function( len )
  local mp = net.ReadEntity()

  if upgradeframe == nil then
  	upgradeframe = createD( "DFrame", nil, ctr( 600 ), ctr( 600 ), 0, 0 )
  	upgradeframe:SetTitle( "" )
    upgradeframe:ShowCloseButton( false )
    function upgradeframe:Remove()
      upgradeframe = nil
    end
    function upgradeframe:Paint( pw, ph )
      draw.RoundedBox( ctr( 30 ), 0, 0, pw, ph, Color( 40, 40, 40, 200 ) )

      draw.SimpleText( "Money Printer", "HudBars", pw/2, ctr( 30 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    --CPU
    upgradeButton( mp, upgradeframe, ctr( 580 ), ctr( 60 ), ctr( 10 ), ctr( 60 ), "cpu", "upgradeCPU", "CPU" )

    --Cooler
    upgradeButton( mp, upgradeframe, ctr( 580 ), ctr( 60 ), ctr( 10 ), ctr( 60 + 70 ), "cooler", "upgradeCooler", "Cooler" )

    --Printer
    upgradeButton( mp, upgradeframe, ctr( 580 ), ctr( 60 ), ctr( 10 ), ctr( 60 + 140 ), "printer", "upgradePrinter", "Printer" )

    --Printer
    upgradeButton( mp, upgradeframe, ctr( 580 ), ctr( 60 ), ctr( 10 ), ctr( 60 + 210 ), "storage", "upgradeStorage", "Storage" )

    --Withdraw
    local moneyInfo = createD( "DPanel", upgradeframe, 180, 30, 10, 30+180 )
    function moneyInfo:Paint( pw, ph )
      draw.RoundedBox( ctr( 10 ), 0, 0, pw, ph, Color( 100, 100, 100, 200 ) )

      draw.SimpleText( mp:GetNWInt( "money", -1 ) .. "/" .. mp:GetNWInt( "moneyMax" , -1 ) .. " €", "HudBars", ctr( 10 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    end

  	local withdrawMoney = createD( "DButton", upgradeframe, ctr( 200 ), ctr( 60 ), ctr( 380 ), ctr( 410 ) )
    withdrawMoney:SetText( "" )
    function withdrawMoney:Paint( pw, ph )
      if self:IsHovered() then
        draw.RoundedBox( ctr( 10 ), 0, 0, pw, ph, Color( 255, 255, 0, 200 ) )
        draw.SimpleText( "Withdraw", "HudBars", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      else
        draw.RoundedBox( ctr( 10 ), 0, 0, pw, ph, Color( 255, 255, 255, 200 ) )
        draw.SimpleText( "Withdraw", "HudBars", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      end
    end
    function withdrawMoney:DoClick()
      net.Start( "withdrawMoney" )
        net.WriteEntity( mp )
      net.SendToServer()
    end

    --CLOSE
    local closeMenu = createD( "DButton", upgradeframe, 30, 30, 150-15, 300-30-10 )
    closeMenu:SetText( "" )
    function closeMenu:Paint( pw, ph )
      if self:IsHovered() then
        draw.RoundedBox( ctr( 10 ), 0, 0, pw, ph, Color( 255, 255, 0, 200 ) )
      else
        draw.RoundedBox( ctr( 10 ), 0, 0, pw, ph, Color( 255, 255, 255, 200 ) )
      end

      draw.SimpleText( "X", "HudBars", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    function closeMenu:DoClick()
      upgradeframe:Close()
    end

    upgradeframe:Center()

    upgradeframe:MakePopup()
  end
end)

function ENT:Draw()
  local ply = LocalPlayer()
  local dist = ply:GetPos():Distance( self:GetPos() )
  if dist < 2000 then
    self:DrawModel()
  end
end
