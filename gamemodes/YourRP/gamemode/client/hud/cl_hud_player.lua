
local _filterENTS = ents.GetAll()
local _filterTime = CurTime()
local CamData = {}

local _showVoice = false
function GM:PlayerStartVoice( ply )
  if ply == LocalPlayer() then
    _showVoice = true
  end
end
function GM:PlayerEndVoice( ply )
  if ply == LocalPlayer() then
    _showVoice = false
  end
end

function roundMoney( money, round )
  if money > 1000 and money < 1000000 then
    return math.Round( money / 1000, round ) .. "K"
  elseif money > 1000000 and money < 1000000000 then
    return math.Round( money / 1000000, round ) .. "M"
  elseif money > 1000000000 then
    return math.Round( money / 1000000000, round ) .. "B"
  else
    return math.Round( money, round )
  end
end

local _tmp3P = 0
function HudPlayer()
  local ply = LocalPlayer()
  if cl_db["_load"] == 1 then
    local minimap = {}
    local br = 2

    if ply:Alive() then
      //Voice
      if _showVoice then
        drawText( "You are speaking", "HudBars", cl_db["vox"], cl_db["voy"], Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      end

      //Health
      if tonumber( cl_db["hpt"] ) == 1 then
        drawRBox( 0, cl_db["hpx"], cl_db["hpy"], cl_db["hpw"], cl_db["hph"], Color( 0, 0, 0, 200 ) )
        drawRBox( 0, cl_db["hpx"], cl_db["hpy"], ( LocalPlayer():Health() / LocalPlayer():GetMaxHealth() ) * (cl_db["hpw"]), cl_db["hph"], Color( 255, 0, 0, 200 ) )
        drawText( LocalPlayer():Health() .. "/" .. LocalPlayer():GetMaxHealth() .. " | " .. (LocalPlayer():Health()/LocalPlayer():GetMaxHealth())*100 .. " %", "HudBars", cl_db["hpx"] + (cl_db["hpw"]/2), cl_db["hpy"] + (cl_db["hph"]/2), Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      end

      //Armor
      if tonumber( cl_db["art"] ) == 1 then
        drawRBox( 0, cl_db["arx"], cl_db["ary"], cl_db["arw"], cl_db["arh"], Color( 0, 0, 0, 200 ) )
        drawRBox( 0, cl_db["arx"], cl_db["ary"], ( LocalPlayer():Armor() / ply:GetNWInt( "GetMaxArmor", 100 ) ) * cl_db["arw"], cl_db["arh"], Color( 0, 0, 255, 200 ) )
        drawText( LocalPlayer():Armor() .. "/" .. ply:GetNWInt( "GetMaxArmor", 100 ) .. " | " .. (LocalPlayer():Armor()/100)*100 .. " %", "HudBars", cl_db["arx"] + (cl_db["arw"]/2), cl_db["ary"] + (cl_db["arh"]/2), Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      end

      //RoleID
      if tonumber( cl_db["rit"] ) == 1 then
        drawRBox( 0, cl_db["rix"], cl_db["riy"], cl_db["riw"], cl_db["rih"], Color( 0, 0, 0, 200 ) )
        drawText( LocalPlayer():GetNWString("groupID") .. " " .. LocalPlayer():GetNWString("roleID"), "HudBars", cl_db["rix"] + (cl_db["riw"]/2), cl_db["riy"] + (cl_db["rih"]/2), Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      end

      //Minimap
      if tonumber( cl_db["mmt"] ) == 1 then
        if _filterTime + 10 < CurTime() then//alle 10 sekunden ents reinladen
          _filterTime = CurTime()
          _filterENTS = ents.GetAll()
        end
        local tr = util.TraceLine( {
        	start = LocalPlayer():GetPos() + Vector( 0, 0, 16 ),
          endpos = LocalPlayer():GetPos() + Vector( 0, 0, 4000 ),
        	filter = _filterENTS
        } )

      	CamData.angles = Angle( 90, LocalPlayer():EyeAngles().yaw, 0 )
        local _inBuilding = 0
        if tr.Hit then
          if tr.HitPos.z - LocalPlayer():GetPos().z < 4000 and !tr.Entity:IsPlayer() and !tr.Entity:IsNPC() then
            _inBuilding = 1
            local dist = 1400
        	  CamData.origin = LocalPlayer():GetPos() + Vector( 0, 0, tr.HitPos.z-LocalPlayer():GetPos().z - 4 )
            CamData.ortholeft = -dist * cl_db["mmw"] / 1000
          	CamData.orthoright = dist * cl_db["mmw"] / 1000
          	CamData.orthotop = -dist * cl_db["mmh"] / 1000
          	CamData.orthobottom = dist * cl_db["mmh"] / 1000
          end
        end
        if _inBuilding == 0 then
          local tr2 = util.TraceLine( {
          	start = LocalPlayer():GetPos(),
            endpos = LocalPlayer():GetPos() + Vector( 0, 0, 99999999999999999 ),
          	filter = LocalPlayer()
          } )
          local dist = 3000
          CamData.origin = LocalPlayer():GetPos() + Vector( 0, 0, tr2.HitPos.z-LocalPlayer():GetPos().z - 4 ) //+ Vector( 0, 0, 20000 )
          CamData.ortholeft = -dist * cl_db["mmw"] / 1000
        	CamData.orthoright = dist * cl_db["mmw"] / 1000
        	CamData.orthotop = -dist * cl_db["mmh"] / 1000
        	CamData.orthobottom = dist * cl_db["mmh"] / 1000
        end
      	CamData.x = calculateToResu( cl_db["mmx"] )
      	CamData.y = calculateToResu( cl_db["mmy"] )
      	CamData.w = calculateToResu( cl_db["mmw"] )
      	CamData.h = calculateToResu( cl_db["mmh"] )
        CamData.ortho = true
        CamData.drawviewmodel = false
      	render.RenderView( CamData )

        minimap.point = 8
        drawRBoxCr( cl_db["mmx"] + (cl_db["mmw"]/2) - (minimap.point/2), cl_db["mmy"] + (cl_db["mmh"]/2) - (minimap.point/2), minimap.point, Color( 0, 0, 255, 200 ) )
      end

      //Tooltip
      if tonumber( cl_db["ttt"] ) == 1 then
        drawRBox( 0, cl_db["ttx"], cl_db["tty"], cl_db["ttw"], cl_db["tth"], Color( 0, 0, 0, 200 ) )
        drawText( "Tooltip:", "HudBars", cl_db["ttx"] + calculateToResu( 32 ), cl_db["tty"] + calculateToResu( 16 ), Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        drawText( "F2 - Role Menu", "HudBars", cl_db["ttx"] + calculateToResu( 32 ), cl_db["tty"] + calculateToResu( 80 ), Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        drawText( "F4 - Buy Menu", "HudBars", cl_db["ttx"] + calculateToResu( 32 ), cl_db["tty"] + calculateToResu( 144 ), Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        drawText( "F7 - Settings", "HudBars", cl_db["ttx"] + calculateToResu( 32 ), cl_db["tty"] + calculateToResu( 208 ), Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        drawText( "B  - Change View", "HudBars", cl_db["ttx"] + calculateToResu( 32 ), cl_db["tty"] + calculateToResu( 272 ), Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        drawText( "M  - Map", "HudBars", cl_db["ttx"] + calculateToResu( 32 ), cl_db["tty"] + calculateToResu( 336 ), Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
      end

      //Money
      if tonumber( cl_db["mot"] ) == 1 then
        drawRBox( 0, cl_db["mox"], cl_db["moy"], cl_db["mow"], cl_db["moh"], Color( 0, 0, 0, 200 ) )
        local _money = tonumber( LocalPlayer():GetNWInt( "money" ) )
        local _moneystring = roundMoney( _money, 1 ) .. " €"
        local _capital = tonumber( LocalPlayer():GetNWInt( "capital" ) )
        if _capital > 0 then
          _moneystring = _moneystring .. " (+" .. roundMoney( _capital, 1 ) .. " €)"
        end
        drawText( _moneystring, "HudBars", cl_db["mox"] + (cl_db["mow"]/2), cl_db["moy"] + (cl_db["moh"]/2), Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      end

      //Thirdperson
      if _thirdperson != _tmp3P then
        _tmp3P = _thirdperson
        show3PInfo = 1
        timer.Simple( 3, function()
          show3PInfo = 0
        end)
      end
      if show3PInfo == 1 then
        local _3PText = ""
        if _thirdperson == 0 then
          _3PText = "View: Firstperson"
        elseif _thirdperson == 1 then
          _3PText = "View: Firstperson Realistic"
        elseif _thirdperson == 2 then
          _3PText = "View: Thirdperson"
        end
        draw.SimpleText( _3PText, "DermaDefault", calculateToResu( 3840/2 ), calculateToResu( 2160/2 + 500 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
      end

      //Borders
      if tonumber( cl_db["hpt"] ) == 1 then
        drawRBoxBr( 0, cl_db["hpx"], cl_db["hpy"], cl_db["hpw"], cl_db["hph"], Color( 255, 255, 0, 200 ), br )
      end
      if tonumber( cl_db["art"] ) == 1 then
        drawRBoxBr( 0, cl_db["arx"], cl_db["ary"], cl_db["arw"], cl_db["arh"], Color( 255, 255, 0, 200 ), br )
      end
      if tonumber( cl_db["rit"] ) == 1 then
      drawRBoxBr( 0, cl_db["rix"], cl_db["riy"], cl_db["riw"], cl_db["rih"], Color( 255, 255, 0, 200 ), br )
      end
      if tonumber( cl_db["ttt"] ) == 1 then
        drawRBoxBr( 0, cl_db["ttx"], cl_db["tty"], cl_db["ttw"], cl_db["tth"], Color( 255, 255, 0, 200 ), br )
      end
      if tonumber( cl_db["mot"] ) == 1 then
        drawRBoxBr( 0, cl_db["mox"], cl_db["moy"], cl_db["mow"], cl_db["moh"], Color( 255, 255, 0, 200 ), br )
      end
      if tonumber( cl_db["mmt"] ) == 1 then
        drawRBoxBr( 0, cl_db["mmx"], cl_db["mmy"], cl_db["mmw"], cl_db["mmh"], Color( 255, 255, 0, 200 ), br )
      end
    else
      drawRBox( 0, 0, 0, 3840, 2160, Color( 255, 0, 0, 100 ) )
      drawText( "Dead! Respawning ...", "HudBars", 3840/2, 2160/2, Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
  end
end
