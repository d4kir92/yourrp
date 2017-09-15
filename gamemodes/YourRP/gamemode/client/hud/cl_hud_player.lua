--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

_filterENTS = ents.GetAll()
local _filterTime = CurTime()
local CamDataMinimap = {}

local plyHealth = 100
local plyArmor = 100
local plyHunger = 100
local plyThirst = 100
local plyStamina = 100
local plyMana = 100
local plyCast = 0

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

local food = Material( "icon16/cookie.png" )
local drink = Material( "icon16/drink.png" )
local health = Material( "icon16/heart.png" )
local armor = Material( "icon16/shield.png" )
local stamina = Material( "icon16/lightning.png" )
local money = Material( "icon16/money.png" )
local role = Material( "icon16/user.png" )

function showIcon( string, material )
  surface.SetDrawColor( 255, 255, 255, 255 )
  surface.SetMaterial( material	)
  surface.DrawTexturedRect( ctrW( cl_db[string .. "x"] ) + ctrW( 30 ) - ctrW( 16 ), ctrW( cl_db[string .. "y"] ) + ctrW( cl_db[string .. "h"]/2 ) - ctrW( 16 ), ctrW( 32 ), ctrW( 32 ) )
end

local _tmp3P = 0
function HudPlayer()
  local ply = LocalPlayer()
  local weapon = ply:GetActiveWeapon()
  if cl_db["_load"] == 1 then
    local minimap = {}
    local br = 2

    if ply:Alive() then
      --Voice
      if _showVoice then
        drawText( lang.youarespeaking, "vof", cl_db["vox"], cl_db["voy"], Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      end

      --Health
      if tonumber( cl_db["hpt"] ) == 1 then
        plyHealth = Lerp( 10 * FrameTime(), plyHealth, ply:Health() )
        drawRBox( 0, cl_db["hpx"], cl_db["hpy"], cl_db["hpw"], cl_db["hph"], Color( cl_db["colbgr"], cl_db["colbgg"], cl_db["colbgb"], cl_db["colbga"] ) )
        drawRBox( 0, cl_db["hpx"], cl_db["hpy"], ( plyHealth / ply:GetMaxHealth() ) * (cl_db["hpw"]), cl_db["hph"], Color( 255, 0, 0, 200 ) )
        drawText( math.Round( plyHealth, 0 ) .. "/" .. ply:GetMaxHealth() .. "|" .. math.Round( ( math.Round( plyHealth, 0 ) / ply:GetMaxHealth() ) * 100, 0 ) .. "%", "hpf", cl_db["hpx"] + (cl_db["hpw"]/2), cl_db["hpy"] + (cl_db["hph"]/2), Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        showIcon( "hp", health )
      end

      --Armor
      if tonumber( cl_db["art"] ) == 1 then
        plyArmor = Lerp( 10 * FrameTime(), plyArmor, ply:Armor() )
        drawRBox( 0, cl_db["arx"], cl_db["ary"], cl_db["arw"], cl_db["arh"], Color( cl_db["colbgr"], cl_db["colbgg"], cl_db["colbgb"], cl_db["colbga"] ) )
        drawRBox( 0, cl_db["arx"], cl_db["ary"], ( ply:Armor() / ply:GetNWInt( "GetMaxArmor", 100 ) ) * cl_db["arw"], cl_db["arh"], Color( 0, 255, 0, 200 ) )
        drawText( math.Round( plyArmor, 0 ) .. "/" .. ply:GetNWInt( "GetMaxArmor", 100 ) .. "|" .. math.Round( ( math.Round( plyArmor, 0 ) / ply:GetNWInt( "GetMaxArmor", 100 ) ) * 100, 0 ) .. "%", "arf", cl_db["arx"] + (cl_db["arw"]/2), cl_db["ary"] + (cl_db["arh"]/2), Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        showIcon( "ar", armor )
      end

      --Weapon Primary
      if tonumber( cl_db["wpt"] ) == 1 then
        local wpx = ctrW( cl_db["wpx"] )
        local wpy = ctrW( cl_db["wpy"] )
        local wpw = ctrW( cl_db["wpw"] )
        local wph = ctrW( cl_db["wph"] )
        if weapon != NULL then
      		if weapon:GetMaxClip1() > -1 or ply:GetAmmoCount( weapon:GetPrimaryAmmoType() ) > -1 then
            draw.RoundedBox( 0, wpx, wpy, wpw, wph, Color( cl_db["colbgr"], cl_db["colbgg"], cl_db["colbgb"], cl_db["colbga"] ) )

            draw.RoundedBox( 0, wpx, wpy, wpw * weapon:Clip1() / weapon:GetMaxClip1(), wph, Color( 255, 255, 0 ) )
      			--Primary
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
      				draw.SimpleText( math.Round( 100 * ( 1 - ( ( 1 / reload.maxP ) * reload.nextPC ) ) ) .. "%", "wpf", wpx + ( wpw / 2 ), wpy + ( wph / 2 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      			elseif weapon:GetMaxClip1() > -1 then
      				draw.SimpleText( weapon:Clip1() .. "/" .. weapon:GetMaxClip1()  .. "|" .. ply:GetAmmoCount(weapon:GetPrimaryAmmoType()), "wpf", wpx + ( wpw / 2 ), wpy + ( wph / 2 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      		  elseif ply:GetAmmoCount(weapon:GetPrimaryAmmoType()) > -1 then
              draw.SimpleText( ply:GetAmmoCount( weapon:GetPrimaryAmmoType() ), "wpf", wpx + ( wpw / 2 ), wpy + ( wph / 2 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
          end
        end
      end

      --Weapon Secondary
      if tonumber( cl_db["wst"] ) == 1 then
        local wsx = ctrW( cl_db["wsx"] )
        local wsy = ctrW( cl_db["wsy"] )
        local wsw = ctrW( cl_db["wsw"] )
        local wsh = ctrW( cl_db["wsh"] )

        if weapon != NULL then
      		if ply:GetAmmoCount(weapon:GetSecondaryAmmoType()) > 0 then
            draw.RoundedBox( 0, wsx, wsy, wsw, wsh, Color( cl_db["colbgr"], cl_db["colbgg"], cl_db["colbgb"], cl_db["colbga"] ) )
      			--Secondary
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
      				draw.SimpleText( math.Round( 100 * ( 1 - ( ( 1 / reload.maxS ) * reload.nextSC ) ) ) .. "%", "wsf", wsx + ( wsw / 2 ), wsy + ( wsh / 2 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      			else
      				draw.SimpleText( ply:GetAmmoCount(weapon:GetSecondaryAmmoType()), "wsf", wsx + ( wsw / 2 ), wsy + ( wsh / 2 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
      			end
          end
    		end
      end

      --Weapon Name
      if tonumber( cl_db["wnt"] ) == 1 then
        if weapon != NULL then
          drawRBox( 0, cl_db["wnx"], cl_db["wny"], cl_db["wnw"], cl_db["wnh"], Color( cl_db["colbgr"], cl_db["colbgg"], cl_db["colbgb"], cl_db["colbga"] ) )
          drawText( weapon:GetPrintName(), "wnf", cl_db["wnx"] + (cl_db["wnw"]/2), cl_db["wny"] + (cl_db["wnh"]/2), Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
      end

      --RoleID
      if tonumber( cl_db["rit"] ) == 1 then
        drawRBox( 0, cl_db["rix"], cl_db["riy"], cl_db["riw"], cl_db["rih"], Color( cl_db["colbgr"], cl_db["colbgg"], cl_db["colbgb"], cl_db["colbga"] ) )
        drawText( ply:GetNWString("groupName") .. " " .. ply:GetNWString("roleName"), "rif", cl_db["rix"] + (cl_db["riw"]/2), cl_db["riy"] + (cl_db["rih"]/2), Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        showIcon( "ri", role )
      end

      --Minimap
      if tonumber( cl_db["mmt"] ) == 1 then
        drawRBox( 0, cl_db["mmx"], cl_db["mmy"], cl_db["mmw"], cl_db["mmh"], Color( cl_db["colbgr"], cl_db["colbgg"], cl_db["colbgb"], cl_db["colbga"] ) )
        if _filterTime + 20 < CurTime() then--alle 10 sekunden ents reinladen
          _filterTime = CurTime()
          _filterENTS = ents.GetAll()
        end
        local tr = util.TraceLine( {
        	start = ply:GetPos() + Vector( 0, 0, 16 ),
          endpos = ply:GetPos() + Vector( 0, 0, 4000 ),
        	filter = _filterENTS
        } )

        local rendering_map = false
        local map_RT = GetRenderTarget( "YRP_Minimap", ctrW( cl_db["mmw"] ), ctrW( cl_db["mmh"] ), true )
        local map_RT_mat = CreateMaterial( "YRP_Minimap", "UnlitGeneric", { ["$basetexture"] = "YRP_Minimap" } )
        local old_RT = render.GetRenderTarget()
        local old_w, old_h = ScrW(), ScrH()
        render.SetRenderTarget( map_RT )
        render.SetViewPort( ctrW( cl_db["mmx"] ), ctrW( cl_db["mmy"] ), ctrW( cl_db["mmw"] ), ctrW( cl_db["mmh"] ) )

        render.Clear( 0, 0, 0, 0 )

      	CamDataMinimap.angles = Angle( 90, ply:EyeAngles().yaw, 0 )
        if tr.Hit and !tr.Entity:IsPlayer() and !tr.Entity:IsNPC() then
          local dist = 1400
      	  CamDataMinimap.origin = ply:GetPos() + Vector( 0, 0, tr.HitPos.z-ply:GetPos().z - 4 )
          CamDataMinimap.ortholeft = -dist * cl_db["mmw"] / 1000
        	CamDataMinimap.orthoright = dist * cl_db["mmw"] / 1000
        	CamDataMinimap.orthotop = -dist * cl_db["mmh"] / 1000
        	CamDataMinimap.orthobottom = dist * cl_db["mmh"] / 1000
        else
          local dist = 6000
          CamDataMinimap.origin = ply:GetPos() + Vector( 0, 0, ply:GetPos().z + 4000 - ply:GetPos().z - 4 ) --+ Vector( 0, 0, 20000 )
          CamDataMinimap.ortholeft = -dist * cl_db["mmw"] / 1000
        	CamDataMinimap.orthoright = dist * cl_db["mmw"] / 1000
        	CamDataMinimap.orthotop = -dist * cl_db["mmh"] / 1000
        	CamDataMinimap.orthobottom = dist * cl_db["mmh"] / 1000
        end
      	CamDataMinimap.x = 0
      	CamDataMinimap.y = 0
      	CamDataMinimap.w = cl_db["mmw"]
      	CamDataMinimap.h = cl_db["mmh"]
        CamDataMinimap.ortho = true
        CamDataMinimap.drawviewmodel = false

        cam.Start2D()
        	rendering_map = true
          render.RenderView( CamDataMinimap )
          rendering_map = false
        cam.End2D()

        render.SetViewPort( 0, 0, old_w, old_h )
        render.SetRenderTarget( old_RT )
        surface.SetMaterial( map_RT_mat )
        surface.DrawTexturedRect( ctrW( cl_db["mmx"] ), ctrW( cl_db["mmy"] ), ctrW( cl_db["mmw"] ), ctrW( cl_db["mmh"] ) )

        minimap.point = 8
        drawRBoxCr( cl_db["mmx"] + (cl_db["mmw"]/2) - (minimap.point/2), cl_db["mmy"] + (cl_db["mmh"]/2) - (minimap.point/2), minimap.point, Color( 0, 0, 255, 200 ) )

        --Coords
        draw.SimpleText( math.Round( ply:GetPos().x, -1 ) .. ",", "mmf", ctrW( cl_db["mmx"] ) + ( ctrW( cl_db["mmw"] ) / 2 ), ctrW( cl_db["mmy"] ) + ctrW( cl_db["mmh"] - 20 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
        draw.SimpleText( " " .. math.Round( ply:GetPos().y, -1 ), "mmf", ctrW( cl_db["mmx"] ) + ( ctrW( cl_db["mmw"] ) / 2 ), ctrW( cl_db["mmy"] ) + ctrW( cl_db["mmh"] - 20 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
      end

      --Tooltip
      if tonumber( cl_db["ttt"] ) == 1 then
        local _abstand = 40
        drawRBox( 0, cl_db["ttx"], cl_db["tty"], cl_db["ttw"], cl_db["tth"], Color( cl_db["colbgr"], cl_db["colbgg"], cl_db["colbgb"], cl_db["colbga"] ) )
        drawText( lang.tooltip .. ":", "ttf", cl_db["ttx"] + ctrW( 32 ), cl_db["tty"] + 10, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        drawText( "F2 - " .. lang.rolemenu, "ttf", cl_db["ttx"] + ctrW( 32 ), cl_db["tty"] + 10 + 1*_abstand, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        drawText( "F3 - " .. lang.guimouse, "ttf", cl_db["ttx"] + ctrW( 32 ), cl_db["tty"] + 10 + 2*_abstand, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        drawText( "F4 - " .. lang.buymenu, "ttf", cl_db["ttx"] + ctrW( 32 ), cl_db["tty"] + 10 + 3*_abstand, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        drawText( "F7  - " .. lang.settings, "ttf", cl_db["ttx"] + ctrW( 32 ), cl_db["tty"] + 10 + 4*_abstand, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        drawText( "B  - " .. lang.changeview, "ttf", cl_db["ttx"] + ctrW( 32 ), cl_db["tty"] + 10 + 5*_abstand, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        drawText( "M  - " .. lang.map, "ttf", cl_db["ttx"] + ctrW( 32 ), cl_db["tty"] + 10 + 6*_abstand, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        drawText( "H  - " .. "Eat Food", "ttf", cl_db["ttx"] + ctrW( 32 ), cl_db["tty"] + 10 + 7*_abstand, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        drawText( "T  - " .. "Drink Water", "ttf", cl_db["ttx"] + ctrW( 32 ), cl_db["tty"] + 10 + 8*_abstand, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
      end

      --Money
      if tonumber( cl_db["mot"] ) == 1 then
        drawRBox( 0, cl_db["mox"], cl_db["moy"], cl_db["mow"], cl_db["moh"], Color( cl_db["colbgr"], cl_db["colbgg"], cl_db["colbgb"], cl_db["colbga"] ) )
        local _money = tonumber( ply:GetNWInt( "money" ) )
        local _moneystring = ply:GetNWString( "moneyPre" ) .. roundMoney( _money, 1 ) .. ply:GetNWString( "moneyPost" )
        local _capital = tonumber( ply:GetNWInt( "capital" ) )
        if _capital > 0 then
          _moneystring = _moneystring .. " (+".. ply:GetNWString( "moneyPre" ) .. roundMoney( _capital, 1 ) .. ply:GetNWString( "moneyPost" ) .. ")"
        end
        drawText( _moneystring, "mof", cl_db["mox"] + (cl_db["mow"]/2), cl_db["moy"] + (cl_db["moh"]/2), Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        showIcon( "mo", money )
      end

      if ply:GetNWBool( "metabolism", false ) then
        --Hunger
        if tonumber( cl_db["mht"] ) == 1 then
          plyHunger = Lerp( 10 * FrameTime(), plyHunger, ply:GetNWInt( "hunger", 0 ) )
          drawRBox( 0, cl_db["mhx"], cl_db["mhy"], cl_db["mhw"], cl_db["mhh"], Color( cl_db["colbgr"], cl_db["colbgg"], cl_db["colbgb"], cl_db["colbga"] ) )
          drawRBox( 0, cl_db["mhx"], cl_db["mhy"], ( plyHunger / 100 ) * (cl_db["mhw"]), cl_db["mhh"], Color( 255, 69, 0, 200 ) )
          drawText( math.Round( ( math.Round( plyHunger, 0 ) / 100 ) * 100, 0 ) .. "%", "mhf", cl_db["mhx"] + (cl_db["mhw"]/2), cl_db["mhy"] + (cl_db["mhh"]/2), Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        	showIcon( "mh", food )
        end

        --Thirst
        if tonumber( cl_db["mtt"] ) == 1 then
          plyThirst = Lerp( 10 * FrameTime(), plyThirst, ply:GetNWInt( "thirst", 0 ) )
          drawRBox( 0, cl_db["mtx"], cl_db["mty"], cl_db["mtw"], cl_db["mth"], Color( cl_db["colbgr"], cl_db["colbgg"], cl_db["colbgb"], cl_db["colbga"] ) )
          drawRBox( 0, cl_db["mtx"], cl_db["mty"], ( plyThirst / 100 ) * cl_db["mtw"], cl_db["mth"], Color( 0, 0, 255, 200 ) )
          drawText( math.Round( ( math.Round( plyThirst, 0 ) / 100 ) * 100, 0 ) .. "%", "mtf", cl_db["mtx"] + (cl_db["mtw"]/2), cl_db["mty"] + (cl_db["mth"]/2), Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

          showIcon( "mt", drink )
        end

        --Stamina
        if tonumber( cl_db["mst"] ) == 1 then
          plyStamina = Lerp( 10 * FrameTime(), plyStamina, ply:GetNWInt( "stamina", 0 ) )
          drawRBox( 0, cl_db["msx"], cl_db["msy"], cl_db["msw"], cl_db["msh"], Color( cl_db["colbgr"], cl_db["colbgg"], cl_db["colbgb"], cl_db["colbga"] ) )
          drawRBox( 0, cl_db["msx"], cl_db["msy"], ( plyStamina / 100 ) * cl_db["msw"], cl_db["msh"], Color( 255, 255, 0, 200 ) )
          drawText( math.Round( ( math.Round( plyStamina, 0 ) / 100 ) * 100, 0 ) .. "%", "msf", cl_db["msx"] + (cl_db["msw"]/2), cl_db["msy"] + (cl_db["msh"]/2), Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

          showIcon( "ms", stamina )
        end
      end

      --Mana
      if tonumber( cl_db["mat"] ) == 1 then
        plyMana = Lerp( 10 * FrameTime(), plyMana, ply:GetNWInt( "mana", 0 ) )
        drawRBox( 0, cl_db["max"], cl_db["may"], cl_db["maw"], cl_db["mah"], Color( cl_db["colbgr"], cl_db["colbgg"], cl_db["colbgb"], cl_db["colbga"] ) )
        drawRBox( 0, cl_db["max"], cl_db["may"], ( plyMana / ply:GetNWInt( "mana", 0 ) ) * cl_db["maw"], cl_db["mah"], Color( 255, 255, 0, 200 ) )
        drawText( math.Round( ( math.Round( plyMana, 0 ) / ply:GetNWInt( "mana", 1 ) ) * 100, 0 ) .. "%", "maf", cl_db["max"] + (cl_db["maw"]/2), cl_db["may"] + (cl_db["mah"]/2), Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        --showIcon( "ma", stamina )
      end

      --Cast
      if tonumber( cl_db["cat"] ) == 1 and ply:GetNWBool( "casting", false ) then
        plyCast = Lerp( 10 * FrameTime(), plyCast, ply:GetNWInt( "castCur", 0 ) )
        drawRBox( 0, cl_db["cax"], cl_db["cay"], cl_db["caw"], cl_db["cah"], Color( cl_db["colbgr"], cl_db["colbgg"], cl_db["colbgb"], cl_db["colbga"] ) )
        drawRBox( 0, cl_db["cax"], cl_db["cay"], ( plyCast / ply:GetNWInt( "castMax", 0 ) ) * cl_db["caw"], cl_db["cah"], Color( 255, 255, 0, 200 ) )
        drawText( ply:GetNWString( "castName", "" ) .. " (" .. math.Round( ( math.Round( plyCast, 0 ) / ply:GetNWInt( "castMax", 0 ) ) * 100, 0 ) .. "%)", "caf", cl_db["cax"] + (cl_db["caw"]/2), cl_db["cay"] + (cl_db["cah"]/2), Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        --showIcon( "ca", stamina )
      else
        ply:SetNWInt( "castCur", 0 )
        plyCast = 0
      end

      --Status
      local _status = ""
      local _showStatus = false
      if ply:GetNWBool( "cuffed" ) then
        if _status != "" then
          _status = _status .. ", "
        end
        _status = _status .. "Cuffed"
        _showStatus = true
      end
      if ply:GetNWInt( "hunger", 100 ) < 20 then
        if _status != "" then
          _status = _status .. ", "
        end
        _status = _status .. "Hungry"
        _showStatus = true
      end
      if ply:GetNWInt( "thirst", 100 ) < 20 then
        if _status != "" then
          _status = _status .. ", "
        end
        _status = _status .. "Thirsty"
        _showStatus = true
      end
      if ply:GetNWBool( "inJail", false ) then
        if _status != "" then
          _status = _status .. ", "
        end
        _status = _status .. lang.jail .. ": " .. ply:GetNWInt( "jailtime", 0 )
        _showStatus = true
      end
      if tonumber( cl_db["stt"] ) == 1 and _status != "" then
        drawRBox( 0, cl_db["stx"], cl_db["sty"], cl_db["stw"], cl_db["sth"], Color( cl_db["colbgr"], cl_db["colbgg"], cl_db["colbgb"], cl_db["colbga"] ) )
        drawText( _status, "stf", cl_db["stx"] + (cl_db["stw"]/2), cl_db["sty"] + (cl_db["sth"]/2), Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        --showIcon( "st", stamina )
      end

      --Voting
      if tonumber( cl_db["vtt"] ) == 1 and ply:GetNWBool( "voting", false ) then
        drawRBox( 0, cl_db["vtx"], cl_db["vty"], cl_db["vtw"], cl_db["vth"], Color( cl_db["colbgr"], cl_db["colbgg"], cl_db["colbgb"], cl_db["colbga"] ) )

        drawText( ply:GetNWString( "voteQuestion", "" ), "vof", cl_db["vtx"] + cl_db["vtw"]/2, cl_db["vty"] + cl_db["vth"]/4, Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        if ply:GetNWString( "voteStatus" ) != "yes" and ply:GetNWString( "voteStatus" ) != "no" then
          drawText( lang.yes .. " - [Picture Up] | " .. lang.no .. " - [Picture Down]", "vof", cl_db["vtx"] + cl_db["vtw"]/2, cl_db["vty"] + 2*(cl_db["vth"]/4), Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        elseif ply:GetNWString( "voteStatus" ) == "yes" then
          drawText( lang.yes, "vof", cl_db["vtx"] + cl_db["vtw"]/2, cl_db["vty"] + 2*(cl_db["vth"]/4), Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        elseif ply:GetNWString( "voteStatus" ) == "no" then
          drawText( lang.no, "vof", cl_db["vtx"] + cl_db["vtw"]/2, cl_db["vty"] + 2*(cl_db["vth"]/4), Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
        drawText( ply:GetNWInt( "voteCD", "" ), "vof", cl_db["vtx"] + cl_db["vtw"]/2, cl_db["vty"] + 3*(cl_db["vth"]/4), Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      end

      --Thirdperson
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
        draw.SimpleText( _3PText, "sef", ScrW()/2, ctrW( 2160/2 + 500 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
      end

      --Borders
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
      if ply:GetNWBool( "metabolism", false ) then
        if tonumber( cl_db["mht"] ) == 1 then
          drawRBoxBr( 0, cl_db["mhx"], cl_db["mhy"], cl_db["mhw"], cl_db["mhh"], Color( cl_db["colbrr"], cl_db["colbrg"], cl_db["colbrb"], cl_db["colbra"] ), br )
        end
        if tonumber( cl_db["mtt"] ) == 1 then
          drawRBoxBr( 0, cl_db["mtx"], cl_db["mty"], cl_db["mtw"], cl_db["mth"], Color( cl_db["colbrr"], cl_db["colbrg"], cl_db["colbrb"], cl_db["colbra"] ), br )
        end
        if tonumber( cl_db["mst"] ) == 1 then
          drawRBoxBr( 0, cl_db["msx"], cl_db["msy"], cl_db["msw"], cl_db["msh"], Color( cl_db["colbrr"], cl_db["colbrg"], cl_db["colbrb"], cl_db["colbra"] ), br )
        end
      end
      if tonumber( cl_db["cbt"] ) == 1 and _showChat then
        drawRBoxBr( 0, cl_db["cbx"], cl_db["cby"], cl_db["cbw"], cl_db["cbh"], Color( cl_db["colbrr"], cl_db["colbrg"], cl_db["colbrb"], cl_db["colbra"] ), br )
      end

      if tonumber( cl_db["mat"] ) == 1 then
        drawRBoxBr( 0, cl_db["max"], cl_db["may"], cl_db["maw"], cl_db["mah"], Color( cl_db["colbrr"], cl_db["colbrg"], cl_db["colbrb"], cl_db["colbra"] ), br )
      end
      if tonumber( cl_db["cat"] ) == 1 and ply:GetNWBool( "casting", false ) then
        drawRBoxBr( 0, cl_db["cax"], cl_db["cay"], cl_db["caw"], cl_db["cah"], Color( cl_db["colbrr"], cl_db["colbrg"], cl_db["colbrb"], cl_db["colbra"] ), br )
      end
      if tonumber( cl_db["stt"] ) == 1 and _showStatus then
        drawRBoxBr( 0, cl_db["stx"], cl_db["sty"], cl_db["stw"], cl_db["sth"], Color( cl_db["colbrr"], cl_db["colbrg"], cl_db["colbrb"], cl_db["colbra"] ), br )
      end
    else
      drawRBox( 0, 0, 0, ScrW() * ctrF( ScrH() ), ScrH() * ctrF( ScrH() ), Color( 255, 0, 0, 100 ) )
      drawText( lang.dead .. "! " .. lang.respawning .. "...", "HudBars", ScrW()/2 * ctrF( ScrH() ), ScrH()/2 * ctrF( ScrH() ), Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
  end
end
