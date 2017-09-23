--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

include("shared.lua")

timer.Simple( 2, function()
  net.Start( "ATMPressPrev" )
  net.SendToServer()
end)

ent = ENT

ENT.name = {}
ENT.steamID = {}

function ENT:Draw()
  local ply = LocalPlayer()
  local eyeTrace = ply:GetEyeTrace()

  if self.display == nil then
    self.display = vgui.Create( "DFrame" )
    self.display:SetTitle( "" )
    self.display:SetSize( 1000, 1000 )
    self.display:ShowCloseButton( false )
    self.display:SetDraggable( false )
    self.display:SetPaintedManually( true )
    self.display.ent = self

    function self.display:Paint( pw, ph )
      local bankName = "YRP Bank [" .. ply:GetNWString( "moneyPre" ) .. ply:GetNWString("moneybank") .. ply:GetNWString( "moneyPost" ) .."]"
      if self.ent:GetNWString( "status" ) == "startup" then
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0 ) )
        draw.SimpleText( "..." .. lang.loading .. "...", "ATM_Header", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      elseif self.ent:GetNWString( "status" ) == "logo" then
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 255 ) )
        draw.SimpleText( lang.welcome .. "!", "ATM_Header", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      elseif self.ent:GetNWString( "status" ) == "home" then
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 255 ) )
        draw.SimpleText( bankName, "ATM_Header", 15, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

        draw.RoundedBox( 0, 0, 150, pw, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( lang.home, "ATM_Header", pw/2, 150+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, 0, 300, 400, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( lang.withdraw, "ATM_Normal", 200, 300+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, 0, 450, 400, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( lang.deposit, "ATM_Normal", 200, 450+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, 0, 600, 400, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( lang.transfer, "ATM_Normal", 200, 600+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      elseif self.ent:GetNWString( "status" ) == "withdraw" then
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 255 ) )
        draw.SimpleText( bankName, "ATM_Header", 15, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

        draw.RoundedBox( 0, 0, 150, pw, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( lang.withdraw, "ATM_Header", pw/2, 150+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, 0, 300, 400, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( ply:GetNWString( "moneyPre" ) .. "5" .. ply:GetNWString( "moneyPost" ), "ATM_Normal", 200, 300+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, 0, 450, 400, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( ply:GetNWString( "moneyPre" ) .. "10" .. ply:GetNWString( "moneyPost" ), "ATM_Normal", 200, 450+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, 0, 600, 400, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( ply:GetNWString( "moneyPre" ) .. "20" .. ply:GetNWString( "moneyPost" ), "ATM_Normal", 200, 600+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, 0, 850, 400, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( lang.back, "ATM_Normal", 200, 850+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, pw-400, 300, 400, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( ply:GetNWString( "moneyPre" ) .. "50" .. ply:GetNWString( "moneyPost" ), "ATM_Normal", pw-200, 300+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, pw-400, 450, 400, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( ply:GetNWString( "moneyPre" ) .. "100" .. ply:GetNWString( "moneyPost" ), "ATM_Normal", pw-200, 450+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, pw-400, 600, 400, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( lang.other, "ATM_Normal", pw-200, 600+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      elseif self.ent:GetNWString( "status" ) == "deposit" then
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 255 ) )
        draw.SimpleText( bankName, "ATM_Header", 15, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

        draw.RoundedBox( 0, 0, 150, pw, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( lang.deposit, "ATM_Header", pw/2, 150+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, 0, 300, 400, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( ply:GetNWString( "moneyPre" ) .. "5" .. ply:GetNWString( "moneyPost" ), "ATM_Normal", 200, 300+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, 0, 450, 400, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( ply:GetNWString( "moneyPre" ) .. "10" .. ply:GetNWString( "moneyPost" ), "ATM_Normal", 200, 450+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, 0, 600, 400, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( ply:GetNWString( "moneyPre" ) .. "20" .. ply:GetNWString( "moneyPost" ), "ATM_Normal", 200, 600+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, 0, 850, 400, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( lang.back, "ATM_Normal", 200, 850+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, pw-400, 300, 400, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( ply:GetNWString( "moneyPre" ) .. "50" .. ply:GetNWString( "moneyPost" ), "ATM_Normal", pw-200, 300+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, pw-400, 450, 400, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( ply:GetNWString( "moneyPre" ) .. "100" .. ply:GetNWString( "moneyPost" ), "ATM_Normal", pw-200, 450+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, pw-400, 600, 400, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( lang.other, "ATM_Normal", pw-200, 600+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      elseif self.ent:GetNWString( "status" ) == "transfer" then
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 255 ) )
        draw.SimpleText( bankName, "ATM_Header", 15, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

        draw.RoundedBox( 0, 0, 150, pw, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( lang.transfer, "ATM_Header", pw/2, 150+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        if self.ent:GetNWString( "name1" ) != "nil" then
          draw.RoundedBox( 0, 0, 300, 400, 100, Color( 255, 255, 255 ) )
          draw.SimpleText( self.ent:GetNWString( "name1", "EMPTY" ), "ATM_Name", 200, 300+50-20, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
          draw.SimpleText( self.ent:GetNWString( "steamID1", "EMPTY" ), "ATM_Name", 200, 300+50+20, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
        if self.ent:GetNWString( "name2" ) != "nil" then
          draw.RoundedBox( 0, 0, 450, 400, 100, Color( 255, 255, 255 ) )
          draw.SimpleText( self.ent:GetNWString( "name2", "EMPTY" ), "ATM_Name", 200, 450+50-20, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
          draw.SimpleText( self.ent:GetNWString( "steamID2", "EMPTY" ), "ATM_Name", 200, 450+50+20, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end

        draw.RoundedBox( 0, 0, 600, 400, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( lang.prevsite, "ATM_Normal", 200, 600+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, 0, 850, 400, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( lang.back, "ATM_Normal", 200, 850+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        if self.ent:GetNWString( "name3" ) != "nil" then
          draw.RoundedBox( 0, pw-400, 300, 400, 100, Color( 255, 255, 255 ) )
          draw.SimpleText( self.ent:GetNWString( "name3", "EMPTY" ), "ATM_Name", pw-200, 300+50-20, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
          draw.SimpleText( self.ent:GetNWString( "steamID3", "EMPTY" ), "ATM_Name", pw-200, 300+50+20, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
        if self.ent:GetNWString( "name4" ) != "nil" then
          draw.RoundedBox( 0, pw-400, 450, 400, 100, Color( 255, 255, 255 ) )
          draw.SimpleText( self.ent:GetNWString( "name4", "EMPTY" ), "ATM_Name", pw-200, 450+50-20, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
          draw.SimpleText( self.ent:GetNWString( "steamID4", "EMPTY" ), "ATM_Name", pw-200, 450+50+20, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end

        draw.RoundedBox( 0, pw-400, 600, 400, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( lang.nextsite, "ATM_Normal", pw-200, 600+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      elseif self.ent:GetNWString( "status" ) == "other" then
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 255 ) )
        draw.SimpleText( bankName, "ATM_Header", 15, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

        draw.RoundedBox( 0, 0, 150, pw, 100, Color( 255, 255, 255 ) )
        local otherText = ""
        local otherTextPos = lang.other
        if self.ent:GetNWString( "prevstatus" ) == "withdraw" then
          otherText = lang.withdraw
        elseif self.ent:GetNWString( "prevstatus" ) == "deposit" then
          otherText = lang.deposit
        elseif self.ent:GetNWString( "prevstatus" ) == "transfer" then
          otherText = lang.transfer
          otherTextPos = self.ent:GetNWString( "name", "ERROR" )
        end
        draw.SimpleText( otherText .. " > " .. otherTextPos, "ATM_Header", pw/2, 150+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, 300, 250, 400, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( ply:GetNWString( "moneyPre" ) .. self.ent:GetNWString("othermoney") .. ply:GetNWString( "moneyPost" ), "ATM_Normal", 500, 250+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, 750, 250, 100, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( "<", "ATM_Normal", 800, 250+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, 300, 400, 100, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( "1", "ATM_Normal", 350, 400+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, 450, 400, 100, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( "2", "ATM_Normal", 500, 400+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, 600, 400, 100, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( "3", "ATM_Normal", 650, 400+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, 300, 550, 100, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( "4", "ATM_Normal", 350, 550+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, 450, 550, 100, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( "5", "ATM_Normal", 500, 550+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, 600, 550, 100, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( "6", "ATM_Normal", 650, 550+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, 300, 700, 100, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( "7", "ATM_Normal", 350, 700+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, 450, 700, 100, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( "8", "ATM_Normal", 500, 700+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, 600, 700, 100, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( "9", "ATM_Normal", 650, 700+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, 750, 700, 100, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( "0", "ATM_Normal", 800, 700+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, 600, 850, 400, 100, Color( 255, 255, 255 ) )
        local _confirm = ""
        if self.ent:GetNWString( "prevstatus" ) == "withdraw" then
          _confirm = lang.withdraw
        elseif self.ent:GetNWString( "prevstatus" ) == "deposit" then
          _confirm = lang.deposit
        elseif self.ent:GetNWString( "prevstatus" ) == "transfer" then
          _confirm = lang.transfer
        end
        draw.SimpleText( _confirm, "ATM_Normal", 600 + 200, 850+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, 0, 850, 400, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( lang.back, "ATM_Normal", 200, 850+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      else
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 0, 0 ) )
        draw.SimpleText( bankName, "ATM_Header", 15, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

        draw.RoundedBox( 0, 0, 150, pw, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( lang.errorsite, "ATM_Header", pw/2, 150+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.SimpleText( "404", "ATM_Header", pw/2, ph/2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.SimpleText( "Please tell the DEVs", "ATM_Header", pw/2, ph/2 + 72 + 10, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        draw.RoundedBox( 0, 0, 850, 400, 100, Color( 255, 255, 255 ) )
        draw.SimpleText( lang.back, "ATM_Normal", 200, 850+50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      end
    end
  end

  if ply:GetPos():Distance( self:GetPos() ) < 2000 then
    self:DrawModel()

    local ang = self:GetAngles()
		local pos = self:GetPos() + ang:Up() * 53.7 + ang:Right() * 8 + ang:Forward() * 3.2
		local camAng = Angle(ang.p, ang.y, ang.r)

    camAng:RotateAroundAxis(camAng:Up(), 90)
		camAng:RotateAroundAxis(camAng:Forward(), 45)

    cam.Start3D2D( pos, camAng, 0.016 )
      self.display:PaintManual()
  	cam.End3D2D()
  end
end
