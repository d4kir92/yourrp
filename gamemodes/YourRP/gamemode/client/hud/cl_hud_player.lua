//Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

_filterENTS = ents.GetAll()
local _filterTime = CurTime()
local CamDataMinimap = {}

local plyHealth = 100
local plyArmor = 100

local reload = {}

reload.nextP = 0
reload.nextPC = 0
reload.maxP = 0
reload.statusP = 0

reload.nextS = 0
reload.nextSC = 0
reload.maxS = 0
reload.statusS = 0

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
  local weapon = ply:GetActiveWeapon()
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
        plyHealth = Lerp( 10 * FrameTime(), plyHealth, ply:Health() )
        drawRBox( 0, cl_db["hpx"], cl_db["hpy"], cl_db["hpw"], cl_db["hph"], Color( 0, 0, 0, 200 ) )
        drawRBox( 0, cl_db["hpx"], cl_db["hpy"], ( plyHealth / ply:GetMaxHealth() ) * (cl_db["hpw"]), cl_db["hph"], Color( 255, 0, 0, 200 ) )
        drawText( math.Round( plyHealth, 0 ) .. "/" .. ply:GetMaxHealth() .. " | " .. math.Round( ( math.Round( plyHealth, 0 ) / ply:GetMaxHealth() ) * 100, 0 ) .. " %", "HudBars", cl_db["hpx"] + (cl_db["hpw"]/2), cl_db["hpy"] + (cl_db["hph"]/2), Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      end

      //Armor
      if tonumber( cl_db["art"] ) == 1 then
        plyArmor = Lerp( 10 * FrameTime(), plyArmor, ply:Armor() )
        drawRBox( 0, cl_db["arx"], cl_db["ary"], cl_db["arw"], cl_db["arh"], Color( 0, 0, 0, 200 ) )
        drawRBox( 0, cl_db["arx"], cl_db["ary"], ( ply:Armor() / ply:GetNWInt( "GetMaxArmor", 100 ) ) * cl_db["arw"], cl_db["arh"], Color( 0, 0, 255, 200 ) )
        drawText( math.Round( plyArmor, 0 ) .. "/" .. ply:GetNWInt( "GetMaxArmor", 100 ) .. " | " .. math.Round( ( math.Round( plyArmor, 0 ) / ply:GetNWInt( "GetMaxArmor", 100 ) ) * 100, 0 ) .. " %", "HudBars", cl_db["arx"] + (cl_db["arw"]/2), cl_db["ary"] + (cl_db["arh"]/2), Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      end

      //Weapon Primary
      if tonumber( cl_db["wpt"] ) == 1 then
        local wpx = calculateToResu( cl_db["wpx"] )
        local wpy = calculateToResu( cl_db["wpy"] )
        local wpw = calculateToResu( cl_db["wpw"] )
        local wph = calculateToResu( cl_db["wph"] )
        if weapon != NULL then
      		if weapon:GetMaxClip1() > -1 or ply:GetAmmoCount( weapon:GetPrimaryAmmoType() ) > -1 then
            draw.RoundedBox( 0, wpx, wpy, wpw, wph, Color( cl_db["colbgr"], cl_db["colbgg"], cl_db["colbgb"], cl_db["colbga"] ) )

            draw.RoundedBox( 0, wpx, wpy, wpw * weapon:Clip1() / weapon:GetMaxClip1(), wph, Color( 255, 255, 0 ) )
      			//Primary
      			reload.nextP = weapon:GetNextPrimaryFire()
      			reload.nextPC = reload.nextP - CurTime()
      			if reload.nextP > CurTime() and reload.statusP == 0 and ( reload.nextPC ) > 0.6 then
      				reload.statusP = 1
      				reload.maxP = reload.nextP - CurTime()
      			elseif reload.nextP < CurTime() and reload.statusP == 1 then
      				reload.statusP = 0
      			end
      			if reload.nextPC > reload.maxP then
      				reload.maxP = reload.nextPC
      			end

      			if reload.statusP == 1 then
      				draw.RoundedBox( 0, wpx, wpy, wpw * ( 1 - ( ( 1 / reload.maxP ) * reload.nextPC )), wph, Color( 255, 0, 0, 200 ) )
      				draw.SimpleText( math.Round( 100 * ( 1 - ( ( 1 / reload.maxP ) * reload.nextPC ) ) ) .. "%", "HudBars", wpx + ( wpw / 2 ), wpy + ( wph / 2 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      			elseif weapon:GetMaxClip1() > -1 then
      				draw.SimpleText( weapon:Clip1() .. "/" .. weapon:GetMaxClip1()  .. "|" .. ply:GetAmmoCount(weapon:GetPrimaryAmmoType()), "HudBars", wpx + ( wpw / 2 ), wpy + ( wph / 2 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      		  elseif ply:GetAmmoCount(weapon:GetPrimaryAmmoType()) > -1 then
              draw.SimpleText( ply:GetAmmoCount( weapon:GetPrimaryAmmoType() ), "HudBars", wpx + ( wpw / 2 ), wpy + ( wph / 2 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
          end
        end
      end

      //Weapon Secondary
      if tonumber( cl_db["wst"] ) == 1 then
        local wsx = calculateToResu( cl_db["wsx"] )
        local wsy = calculateToResu( cl_db["wsy"] )
        local wsw = calculateToResu( cl_db["wsw"] )
        local wsh = calculateToResu( cl_db["wsh"] )

        if weapon != NULL then
      		if ply:GetAmmoCount(weapon:GetSecondaryAmmoType()) > 0 then
            draw.RoundedBox( 0, wsx, wsy, wsw, wsh, Color( cl_db["colbgr"], cl_db["colbgg"], cl_db["colbgb"], cl_db["colbga"] ) )
      			//Secondary
      			draw.RoundedBox( 0, wsx, wsy, wsw, wsh, Color( 255, 255, 0, 255 ) )

      			reload.nextS = weapon:GetNextSecondaryFire()
      			reload.nextSC = reload.nextS - CurTime()
      			if reload.nextS > CurTime() and reload.statusS == 0 and ( reload.nextSC ) > 0.3 then
      				reload.statusS = 1
      				reload.maxS = reload.nextS - CurTime()
      			elseif reload.nextS < CurTime() and reload.statusS == 1 then
      				reload.statusS = 0
      			end
      			if reload.nextSC > reload.maxS then
      				reload.maxS = reload.nextSC
      			end

      			if reload.statusS == 1 then
      				draw.RoundedBox( 0, wsx, wsy, wsw * ( 1 - ( ( 1 / reload.maxS ) * reload.nextSC ) ), wsh, Color( 255, 0, 0, 200 ) )
      				draw.SimpleText( math.Round( 100 * ( 1 - ( ( 1 / reload.maxS ) * reload.nextSC ) ) ) .. "%", "HudBars", wsx + ( wsw / 2 ), wsy + ( wsh / 2 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      			else
      				draw.SimpleText( ply:GetAmmoCount(weapon:GetSecondaryAmmoType()), "HudBars", wsx + ( wsw / 2 ), wsy + ( wsh / 2 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
      			end
          end
    		end
      end

      //Weapon Name
      if tonumber( cl_db["wnt"] ) == 1 then
        if weapon != NULL then
          drawRBox( 0, cl_db["wnx"], cl_db["wny"], cl_db["wnw"], cl_db["wnh"], Color( cl_db["colbgr"], cl_db["colbgg"], cl_db["colbgb"], cl_db["colbga"] ) )
          drawText( weapon:GetPrintName(), "HudBars", cl_db["wnx"] + (cl_db["wnw"]/2), cl_db["wny"] + (cl_db["wnh"]/2), Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
      end

      //RoleID
      if tonumber( cl_db["rit"] ) == 1 then
        drawRBox( 0, cl_db["rix"], cl_db["riy"], cl_db["riw"], cl_db["rih"], Color( cl_db["colbgr"], cl_db["colbgg"], cl_db["colbgb"], cl_db["colbga"] ) )
        drawText( ply:GetNWString("groupName") .. " " .. ply:GetNWString("roleName"), "HudBars", cl_db["rix"] + (cl_db["riw"]/2), cl_db["riy"] + (cl_db["rih"]/2), Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      end

      //Minimap
      if tonumber( cl_db["mmt"] ) == 1 then
        if _filterTime + 20 < CurTime() then//alle 10 sekunden ents reinladen
          _filterTime = CurTime()
          _filterENTS = ents.GetAll()
        end
        local tr = util.TraceLine( {
        	start = ply:GetPos() + Vector( 0, 0, 16 ),
          endpos = ply:GetPos() + Vector( 0, 0, 4000 ),
        	filter = _filterENTS
        } )

      	CamDataMinimap.angles = Angle( 90, ply:EyeAngles().yaw, 0 )
        if tr.Hit then
          if tr.HitPos.z - ply:GetPos().z < 4000 and !tr.Entity:IsPlayer() and !tr.Entity:IsNPC() then
            local dist = 1400
        	  CamDataMinimap.origin = ply:GetPos() + Vector( 0, 0, tr.HitPos.z-ply:GetPos().z - 4 )
            CamDataMinimap.ortholeft = -dist * cl_db["mmw"] / 1000
          	CamDataMinimap.orthoright = dist * cl_db["mmw"] / 1000
          	CamDataMinimap.orthotop = -dist * cl_db["mmh"] / 1000
          	CamDataMinimap.orthobottom = dist * cl_db["mmh"] / 1000
          end
        else
          local dist = 6000
          CamDataMinimap.origin = ply:GetPos() + Vector( 0, 0, ply:GetPos().z + 4000 - ply:GetPos().z - 4 ) //+ Vector( 0, 0, 20000 )
          CamDataMinimap.ortholeft = -dist * cl_db["mmw"] / 1000
        	CamDataMinimap.orthoright = dist * cl_db["mmw"] / 1000
        	CamDataMinimap.orthotop = -dist * cl_db["mmh"] / 1000
        	CamDataMinimap.orthobottom = dist * cl_db["mmh"] / 1000
        end
      	CamDataMinimap.x = calculateToResu( cl_db["mmx"] )
      	CamDataMinimap.y = calculateToResu( cl_db["mmy"] )
      	CamDataMinimap.w = calculateToResu( cl_db["mmw"] )
      	CamDataMinimap.h = calculateToResu( cl_db["mmh"] )
        CamDataMinimap.ortho = true
        CamDataMinimap.drawviewmodel = false
      	render.RenderView( CamDataMinimap )

        minimap.point = 8
        drawRBoxCr( cl_db["mmx"] + (cl_db["mmw"]/2) - (minimap.point/2), cl_db["mmy"] + (cl_db["mmh"]/2) - (minimap.point/2), minimap.point, Color( 0, 0, 255, 200 ) )

        //Coords
        draw.SimpleText( math.Round( ply:GetPos().x, -1 ), "HudMinimap", calculateToResu( cl_db["mmx"] ) + ( calculateToResu( cl_db["mmw"] ) / 2 ), calculateToResu( cl_db["mmy"] ) + calculateToResu( cl_db["mmh"] - 20 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
        draw.SimpleText( ", " .. math.Round( ply:GetPos().y, -1 ), "HudMinimap", calculateToResu( cl_db["mmx"] ) + ( calculateToResu( cl_db["mmw"] ) / 2 ), calculateToResu( cl_db["mmy"] ) + calculateToResu( cl_db["mmh"] - 20 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
      end

      //Tooltip
      if tonumber( cl_db["ttt"] ) == 1 then
        drawRBox( 0, cl_db["ttx"], cl_db["tty"], cl_db["ttw"], cl_db["tth"], Color( cl_db["colbgr"], cl_db["colbgg"], cl_db["colbgb"], cl_db["colbga"] ) )
        drawText( lang.tooltip .. ":", "HudBars", cl_db["ttx"] + calculateToResu( 32 ), cl_db["tty"] + calculateToResu( 16 ), Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        drawText( "F2 - " .. lang.rolemenu, "HudBars", cl_db["ttx"] + calculateToResu( 32 ), cl_db["tty"] + calculateToResu( 80 ), Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        drawText( "F4 - " .. lang.buymenu, "HudBars", cl_db["ttx"] + calculateToResu( 32 ), cl_db["tty"] + calculateToResu( 144 ), Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        drawText( "F7 - " .. lang.settings, "HudBars", cl_db["ttx"] + calculateToResu( 32 ), cl_db["tty"] + calculateToResu( 208 ), Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        drawText( "B  - " .. lang.changeview, "HudBars", cl_db["ttx"] + calculateToResu( 32 ), cl_db["tty"] + calculateToResu( 272 ), Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        drawText( "M  - " .. lang.map, "HudBars", cl_db["ttx"] + calculateToResu( 32 ), cl_db["tty"] + calculateToResu( 336 ), Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
      end

      //Money
      if tonumber( cl_db["mot"] ) == 1 then
        drawRBox( 0, cl_db["mox"], cl_db["moy"], cl_db["mow"], cl_db["moh"], Color( cl_db["colbgr"], cl_db["colbgg"], cl_db["colbgb"], cl_db["colbga"] ) )
        local _money = tonumber( ply:GetNWInt( "money" ) )
        local _moneystring = ply:GetNWString( "moneyPre" ) .. roundMoney( _money, 1 ) .. ply:GetNWString( "moneyPost" )
        local _capital = tonumber( ply:GetNWInt( "capital" ) )
        if _capital > 0 then
          _moneystring = _moneystring .. " (+".. ply:GetNWString( "moneyPre" ) .. roundMoney( _capital, 1 ) .. ply:GetNWString( "moneyPost" ) .. ")"
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
          _3PText = lang.fpp
        elseif _thirdperson == 1 then
          _3PText = lang.fppr
        elseif _thirdperson == 2 then
          _3PText = lang.tpp
        end
        draw.SimpleText( _3PText, "DermaDefault", calculateToResu( 3840/2 ), calculateToResu( 2160/2 + 500 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
      end

      //Borders
      if tonumber( cl_db["hpt"] ) == 1 then
        drawRBoxBr( 0, cl_db["hpx"], cl_db["hpy"], cl_db["hpw"], cl_db["hph"], Color( cl_db["colbrr"], cl_db["colbrg"], cl_db["colbrb"], cl_db["colbra"] ), br )
      end
      if tonumber( cl_db["art"] ) == 1 then
        drawRBoxBr( 0, cl_db["arx"], cl_db["ary"], cl_db["arw"], cl_db["arh"], Color( cl_db["colbrr"], cl_db["colbrg"], cl_db["colbrb"], cl_db["colbra"] ), br )
      end
      if tonumber( cl_db["wst"] ) == 1 then
        if weapon != NULL then
          if ply:GetAmmoCount(weapon:GetSecondaryAmmoType()) > 0 then
            drawRBoxBr( 0, cl_db["wsx"], cl_db["wsy"], cl_db["wsw"], cl_db["wsh"], Color( cl_db["colbrr"], cl_db["colbrg"], cl_db["colbrb"], cl_db["colbra"] ), br )
          end
        end
      end
      if tonumber( cl_db["wpt"] ) == 1 then
        if weapon != NULL then
          if weapon:GetMaxClip1() > -1 or ply:GetAmmoCount(weapon:GetPrimaryAmmoType()) > -1 then
            drawRBoxBr( 0, cl_db["wpx"], cl_db["wpy"], cl_db["wpw"], cl_db["wph"], Color( cl_db["colbrr"], cl_db["colbrg"], cl_db["colbrb"], cl_db["colbra"] ), br )
          end
        end
      end
      if tonumber( cl_db["wnt"] ) == 1 then
        if weapon != NULL then
          drawRBoxBr( 0, cl_db["wnx"], cl_db["wny"], cl_db["wnw"], cl_db["wnh"], Color( cl_db["colbrr"], cl_db["colbrg"], cl_db["colbrb"], cl_db["colbra"] ), br )
        end
      end
      if tonumber( cl_db["rit"] ) == 1 then
      drawRBoxBr( 0, cl_db["rix"], cl_db["riy"], cl_db["riw"], cl_db["rih"], Color( cl_db["colbrr"], cl_db["colbrg"], cl_db["colbrb"], cl_db["colbra"] ), br )
      end
      if tonumber( cl_db["ttt"] ) == 1 then
        drawRBoxBr( 0, cl_db["ttx"], cl_db["tty"], cl_db["ttw"], cl_db["tth"], Color( cl_db["colbrr"], cl_db["colbrg"], cl_db["colbrb"], cl_db["colbra"] ), br )
      end
      if tonumber( cl_db["mot"] ) == 1 then
        drawRBoxBr( 0, cl_db["mox"], cl_db["moy"], cl_db["mow"], cl_db["moh"], Color( cl_db["colbrr"], cl_db["colbrg"], cl_db["colbrb"], cl_db["colbra"] ), br )
      end
      if tonumber( cl_db["mmt"] ) == 1 then
        drawRBoxBr( 0, cl_db["mmx"], cl_db["mmy"], cl_db["mmw"], cl_db["mmh"], Color( cl_db["colbrr"], cl_db["colbrg"], cl_db["colbrb"], cl_db["colbra"] ), br )
      end
    else
      drawRBox( 0, 0, 0, 3840, 2160, Color( 255, 0, 0, 100 ) )
      drawText( lang.dead .. "! " .. lang.respawning .. "...", "HudBars", 3840/2, 2160/2, Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
  end
end
