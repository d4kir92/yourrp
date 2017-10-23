--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

_filterENTS = ents.GetAll()
local _filterTime = CurTime()
local CamDataMinimap = {}

local hud = {}
hud["hp"] = 100
hud["ar"] = 100
hud["mh"] = 100
hud["mt"] = 100
hud["ms"] = 100
hud["ma"] = 100
hud["ca"] = 0
hud["xp"] = 0
hud["wp"] = 0
hud["ws"] = 0

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

function roundMoney( _money, round )
  if _money != nil then
    local money = tonumber( _money )
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
end

local hunger = Material( "icon16/cake.png" )
local thirst = Material( "icon16/cup.png" )
local health = Material( "icon16/heart.png" )
local armor = Material( "icon16/shield.png" )
local stamina = Material( "icon16/lightning.png" )
local money = Material( "icon16/money.png" )
local xp = Material( "icon16/user.png" )
local mana = Material( "icon16/wand.png" )
local cast = Material( "icon16/hourglass.png" )

function showIcon( string, material )
  surface.SetDrawColor( 255, 255, 255, 255 )
  surface.SetMaterial( material	)
  surface.DrawTexturedRect( anchorW( cl_db[string .. "aw"] ) + ctr( cl_db[string .. "px"] ) + ctr( 30 ) - ctr( 16 ), anchorH( cl_db[string .. "ah"] ) + ctr( cl_db[string .. "py"] ) + ctr( cl_db[string .. "sh"]/2 ) - ctrW( 16 ), ctrW( 32 ), ctrW( 32 ) )
end

local contextMenuOpen = false
hook.Add( "OnContextMenuOpen", "OnContextMenuOpen", function()
  contextMenuOpen = true
end)

hook.Add( "OnContextMenuClose", "OnContextMenuClose", function()
  contextMenuOpen = false
end)

local rendering_map = false

local minimap = {}
local _rendered = false
local _minimapDistanceOld = 0
local CamDataMiniMap = {}
function getCoordsMM()
  net.Start( "askCoordsMM" )
  net.SendToServer()
end

net.Receive( "sendCoordsMM", function()
  local _bool = net.ReadBool()
  if _bool then
    minimap = net.ReadTable()
  else
    printGM( "note", "wait for server coords" )
  end
end)

local _alpha = 200
function drawHUDElement( dbV, cur, max, text, icon, color )
  if tobool( HudV( dbV .. "to" ) ) then
    if cur != nil and max != nil then
      hud[dbV] = Lerp( 10 * FrameTime(), hud[dbV], cur )
    end
    draw.RoundedBox( 0, anchorW( HudV( dbV .. "aw" ) ) + ctr( HudV( dbV .. "px" ) ), anchorH( HudV( dbV .. "ah" ) ) + ctr( HudV( dbV .. "py" ) ), ctr( HudV( dbV .. "sw" ) ), ctr( HudV( dbV .. "sh" ) ), Color( cl_db["colbgr"], cl_db["colbgg"], cl_db["colbgb"], cl_db["colbga"] ) )
    if color != nil then
      draw.RoundedBox( 0, anchorW( HudV( dbV .. "aw" ) ) + ctr( cl_db[dbV .. "px"] ), anchorH( HudV( dbV .. "ah" ) ) + ctr( cl_db[dbV .. "py"] ), ( hud[dbV] / max ) * ( ctr( cl_db[dbV .. "sw"] ) ), ctr( cl_db[dbV .. "sh"] ), color )
    end

    if text != nil then
      local _st = {}
      _st.br = 10
      local _pw = 0
      if HudV( dbV .. "tx" ) == 0 then
        _pw = ctr( _st.br )
      elseif HudV( dbV .. "tx" ) == 1 then
        _pw = ctr( HudV( dbV .. "sw" ) ) / 2
      elseif HudV( dbV .. "tx" ) == 2 then
        _pw = ctr( HudV( dbV .. "sw" ) ) - ctr( _st.br )
      end
      local _ph = 0
      if HudV( dbV .. "ty" ) == 3 then
        _ph = ctr( _st.br )
      elseif HudV( dbV .. "ty" ) == 1 then
        _ph = ctr( HudV( dbV .. "sh" ) ) / 2
      elseif HudV( dbV .. "ty" ) == 4 then
        _ph = ctr( HudV( dbV .. "sh" ) ) - ctr( _st.br )
      end
      _st.x = anchorW( HudV( dbV .. "aw" ) ) + ctr( HudV( dbV .. "px" ) ) + _pw
      _st.y = anchorH( HudV( dbV .. "ah" ) ) + ctr( HudV( dbV .. "py" ) ) + _ph
      draw.SimpleTextOutlined( text, dbV .. "sf", _st.x, _st.y, Color( 255, 255, 255, 255 ), HudV( dbV .. "tx" ), HudV( dbV .. "ty" ), 1, Color( 0, 0, 0 ) )
    end

    if icon != nil then
      showIcon( dbV, icon )
    end

    drawRBoxBr( 0, ctrF( ScrH() ) * anchorW( HudV( dbV .. "aw" ) ) + HudV( dbV .. "px" ), ctrF( ScrH() ) * anchorH( HudV( dbV .. "ah" ) ) + HudV( dbV .. "py" ), HudV( dbV .. "sw" ), HudV( dbV .. "sh" ), Color( cl_db["colbrr"], cl_db["colbrg"], cl_db["colbrb"], cl_db["colbra"] ), ctr( 4 ) )
  end
end

local delay = 0

local _tmp3P = 0
function HudPlayer()
  local ply = LocalPlayer()
  local weapon = ply:GetActiveWeapon()
  if cl_db["_loaded"] then
    local br = 2

    if ply:Alive() then
      if !contextMenuOpen then
        --Voice
        if _showVoice then
          draw.SimpleTextOutlined( lang.youarespeaking, "HudBars", ScrW2(), ctr( 500 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
        end

        --Health
        local _hptext = math.Round( ply:Health(), 0 ) .. "/" .. ply:GetMaxHealth() .. "|" .. math.Round( ( math.Round( ply:Health(), 0 ) / ply:GetMaxHealth() ) * 100, 0 ) .. "%"
        drawHUDElement( "hp", ply:Health(), ply:GetMaxHealth(), _hptext, health, Color( 150, 52, 52, _alpha ) )

        --Armor
        local _artext = math.Round( ply:Armor(), 0 ) .. "/" .. ply:GetNWInt( "GetMaxArmor", 1 ) .. "|" .. math.Round( ( math.Round( ply:Armor(), 0 ) / ply:GetNWInt( "GetMaxArmor", 1 ) ) * 100, 0 ) .. "%"
        drawHUDElement( "ar", ply:Armor(), ply:GetNWInt( "GetMaxArmor" ), _artext, armor, Color( 52, 150, 72, _alpha ) )

        if ply:GetNWBool( "metabolism", false ) then
          --Hunger
          local _mhtext = math.Round( ( math.Round( ply:GetNWInt( "hunger", 0 ), 0 ) / 100 ) * 100, 0 ) .. "%"
          drawHUDElement( "mh", ply:GetNWInt( "hunger", 0 ), 100, _mhtext, hunger, Color( 150, 88, 52, _alpha ) )

          --Thirst
          local _mttext = math.Round( ( math.Round( ply:GetNWInt( "thirst", 0 ), 0 ) / 100 ) * 100, 0 ) .. "%"
          drawHUDElement( "mt", ply:GetNWInt( "thirst", 0 ), 100, _mttext, thirst, Color( 52, 70, 150, _alpha ) )

          --Stamina
          local _mstext = math.Round( ( math.Round( ply:GetNWInt( "stamina", 0 ), 0 ) / 100 ) * 100, 0 ) .. "%"
          drawHUDElement( "ms", ply:GetNWInt( "stamina", 0 ), 100, _mstext, stamina, Color( 150, 150, 60, _alpha ) )
        end

        --Mana
        local _matext = math.Round( ( math.Round( ply:GetNWInt( "mana", 0 ), 0 ) / 100 ) * 100, 0 ) .. "%"
        drawHUDElement( "ma", ply:GetNWInt( "mana", 0 ), 100, _matext, mana, Color( 58, 143, 255, _alpha ) )

        --Cast
        if ply:GetNWBool( "casting", false ) then
          local _catext = ply:GetNWString( "castName", "" ) .. " (" .. math.Round( ( math.Round( ply:GetNWInt( "castCur", 1 ), 0 ) / ply:GetNWInt( "castMax", 1 ) ) * 100, 0 ) .. "%)"
          drawHUDElement( "ca", ply:GetNWInt( "castCur", 1 ), ply:GetNWInt( "castMax", 1 ), _catext, cast, Color( 132, 116, 188, _alpha ) )
        else
          ply:SetNWInt( "castCur", 0 )
          plyCast = 0
        end

        --Money
        local _money = tonumber( ply:GetNWString( "money", "" ) )
        local _motext = ply:GetNWString( "moneyPre", "" ) .. roundMoney( _money, 1 ) .. ply:GetNWString( "moneyPost", "" )
        local _capital = tonumber( ply:GetNWInt( "capital", 0 ) )
        if _capital > 0 then
          _motext = _motext .. " (+".. ply:GetNWString( "moneyPre" ) .. roundMoney( _capital, 1 ) .. ply:GetNWString( "moneyPost" ) .. ")"
        end
        drawHUDElement( "mo", nil, nil, _motext, money, nil )

        --XP
        local _xptext = "lvl " .. 1 .. " (" .. 0 .. "%) " .. ply:GetNWString( "groupName" ) .. " " .. ply:GetNWString( "roleName" )
        drawHUDElement( "xp", 0, 100, _xptext, xp, Color( 181, 255, 107, _alpha ) )

        --Weapon Primary
        if weapon != NULL then
      		if weapon:GetMaxClip1() > -1 or ply:GetAmmoCount( weapon:GetPrimaryAmmoType() ) > -1 then
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

            local _wptext = ""
      			if reload.statusP == 1 then
      				_wptext = math.Round( 100 * ( 1 - ( ( 1 / reload.maxP ) * reload.nextPC ) ) ) .. "%"
      			elseif weapon:GetMaxClip1() > -1 then
      				_wptext = weapon:Clip1() .. "/" .. weapon:GetMaxClip1()  .. "|" .. ply:GetAmmoCount(weapon:GetPrimaryAmmoType())
      		  elseif ply:GetAmmoCount(weapon:GetPrimaryAmmoType()) > -1 then
              _wptext = ply:GetAmmoCount( weapon:GetPrimaryAmmoType() )
            end

            drawHUDElement( "wp", weapon:Clip1(), weapon:GetMaxClip1(), _wptext, nil, Color( 255, 255, 0, _alpha ) )
          end
        end

        --Weapon Secondary
        if weapon != NULL then
      		if ply:GetAmmoCount(weapon:GetSecondaryAmmoType()) > 0 then
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

            local _wstext = ""
      			if reload.statusS == 1 then
      				_wstext = math.Round( 100 * ( 1 - ( ( 1 / reload.maxS ) * reload.nextSC ) ) ) .. "%"
      			else
      				_wstext = ply:GetAmmoCount(weapon:GetSecondaryAmmoType())
      			end
            drawHUDElement( "ws", ply:GetAmmoCount(weapon:GetSecondaryAmmoType()), ply:GetAmmoCount(weapon:GetSecondaryAmmoType()), _wstext, nil, Color( 255, 255, 0, _alpha ) )
          end
    		end

        --Weapon Name
        local _wntext = ""
        if weapon != nil and weapon != NULL then
          _wntext = weapon.PrintName or ""
        end
        drawHUDElement( "wn", nil, nil, _wntext, nil, nil )

        --Minimap
        if tonumber( cl_db["mmto"] ) == 1 then
          draw.RoundedBox( 0, anchorW( cl_db["mmaw"] ) + ctr( cl_db["mmpx"] ), anchorH( cl_db["mmah"] ) + ctr( cl_db["mmpy"] ), ctr( cl_db["mmsw"] ), ctr( cl_db["mmsh"] ), Color( 0, 0, 0, _alpha ) )
          if minimap != nil then
            if playerfullready == true and minimap.facX != nil and minimap.facY != nil then
              local win = {}
              win.w = ctr( cl_db["mmsw"] )
              win.h = ctr( cl_db["mmsh"] )
              win.x = ctr( cl_db["mmpx"] )
              win.y = ctr( cl_db["mmpy"] )

              _filterENTS = ents.GetAll()
              local _testHeight = 400
              local tr = util.TraceLine( {
                start = ply:GetPos() + Vector( 0, 0, 16 ),
                endpos = ply:GetPos() + Vector( 0, 0, _testHeight ),
                filter = _filterENTS
              } )
              local _minimapDistance = math.Round( math.abs( ply:GetPos().z ) )
              local _distance = math.Round( math.abs( _minimapDistance - _minimapDistanceOld ) )

              if CurTime() > delay and _rendered then
                delay = CurTime() + 1
                if tr.Hit then
                  delay = CurTime() + 1

                  _minimapDistanceOld = _minimapDistance
                  _rendered = false
                elseif _distance > 64 then
                  delay = CurTime() + 1

                  _minimapDistanceOld = _minimapDistance
                  _rendered = false
                end
              end

              if !_rendered or minimap_RT_mat == nil and minimap.sizeX != nil then
                local _height = 0
                if tr.Hit then
                  _height = tr.HitPos.z
                else
                  _height = _testHeight
                end
                CamDataMiniMap.angles = Angle( 90, 90, 0 )
                CamDataMiniMap.origin = Vector( 0, 0, _height - 16 )
                CamDataMiniMap.x = 0
                CamDataMiniMap.y = 0
                CamDataMiniMap.w = minimap.sizeX
                CamDataMiniMap.h = minimap.sizeY
                CamDataMiniMap.ortho = true
                CamDataMiniMap.ortholeft = minimap.sizeW
                CamDataMiniMap.orthoright = minimap.sizeE
                CamDataMiniMap.orthotop = minimap.sizeS
                CamDataMiniMap.orthobottom = minimap.sizeN

                minimap_RT = GetRenderTarget( "YRP_MiniMap", ScrW(), ScrH(), true )
                minimap_RT_mat = CreateMaterial( "YRP_MiniMap", "UnlitGeneric", { ["$basetexture"] = "YRP_MiniMap" } )
                local old_RT = render.GetRenderTarget()
                local old_w, old_h = ScrW(), ScrH()
                render.SetRenderTarget( minimap_RT )
                  render.SetViewPort( 0, 0, ScrW(), ScrH() )

                  render.Clear( 0, 0, 0, 0 )

                    cam.Start2D()
                      render.RenderView( CamDataMiniMap )
                    cam.End2D()

                  render.SetViewPort( 0, 0, old_w, old_h )
                render.SetRenderTarget( old_RT )

                _rendered = true
              elseif minimap_RT_mat != nil and _rendered then
                local plyPos = {}
                plyPos.xMax = minimap.sizeX
                plyPos.yMax = minimap.sizeY
                local mm = {}
                mm.w, mm.h = lowerToScreen( minimap.sizeX, minimap.sizeY )
                if minimap.sizeW < 0 then
                  plyPos.xtmp = ( LocalPlayer():GetPos().x - minimap.sizeW )
                else
                  plyPos.xtmp = ( LocalPlayer():GetPos().x + minimap.sizeE )
                end
                if minimap.sizeS < 0 then
                  plyPos.ytmp = ( LocalPlayer():GetPos().y - minimap.sizeS )
                else
                  plyPos.ytmp = ( LocalPlayer():GetPos().y + minimap.sizeN )
                end
                plyPos.x = 0 + mm.w * ( plyPos.xtmp / plyPos.xMax )
                plyPos.y = 0 + mm.h - mm.h * ( plyPos.ytmp / plyPos.yMax )

                --STENCIL
                render.ClearStencil()
              	render.SetStencilEnable( true )
              		render.SetStencilWriteMask( 255 )
              		render.SetStencilTestMask( 255 )
              		render.SetStencilReferenceValue( 25 )
              		render.SetStencilFailOperation( STENCIL_REPLACE )

              		draw.RoundedBox( 0, anchorW( HudV( "mmaw" ) ) + ctr( cl_db["mmpx"] ), anchorH( HudV( "mmah" ) ) + ctr(cl_db["mmpy"]), ctr(cl_db["mmsw"]), ctr(cl_db["mmsh"]), Color( 255, 255, 255 ) )

              		render.SetStencilCompareFunction( STENCIL_EQUAL )

                  surface.SetDrawColor( 255, 255, 255, 255 )
                  surface.SetMaterial( minimap_RT_mat )
                  surface.DrawTexturedRect( anchorW( HudV( "mmaw" ) ) + ctr(cl_db["mmpx"]) + ctr(cl_db["mmsw"]/2) - plyPos.x, anchorH( HudV( "mmah" ) ) + ctr(cl_db["mmpy"])  +ctr(cl_db["mmsh"]/2)- plyPos.y, mm.w, mm.h )
                render.SetStencilEnable( false )

                drawRBoxBr( 0, ctrF( ScrH() ) * anchorW( HudV( "mm" .. "aw" ) ) + HudV( "mm" .. "px" ), ctrF( ScrH() ) * anchorH( HudV( "mm" .. "ah" ) ) + HudV( "mm" .. "py" ), HudV( "mm" .. "sw" ), HudV( "mm" .. "sh" ), Color( 0, 0, 0, 255 ), ctr( 4 ) )
              end
            else
              getCoordsMM()
            end
          end

          minimap.point = 8
          drawRBoxCr( ctrF(ScrH()) * anchorW( HudV( "mmaw" ) ) + cl_db["mmpx"] + (cl_db["mmsw"]/2) - (minimap.point/2), ctrF(ScrH()) * anchorH( HudV( "mmah" ) ) + cl_db["mmpy"] + (cl_db["mmsh"]/2) - (minimap.point/2), minimap.point, Color( 0, 0, 255, 200 ) )

          --Coords
          draw.SimpleTextOutlined( math.Round( ply:GetPos().x, -1 ) .. ",", "HudBars", anchorW( HudV( "mmaw" ) ) + ctrW( cl_db["mmpx"] ) + ( ctrW( cl_db["mmsw"] ) / 2 ), anchorH( HudV( "mmah" ) ) + ctrW( cl_db["mmpy"] ) + ctrW( cl_db["mmsh"] - 20 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( " " .. math.Round( ply:GetPos().y, -1 ), "HudBars", anchorW( HudV( "mmaw" ) ) + ctrW( cl_db["mmpx"] ) + ( ctrW( cl_db["mmsw"] ) / 2 ), anchorH( HudV( "mmah" ) ) + ctrW( cl_db["mmpy"] ) + ctrW( cl_db["mmsh"] - 20 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
        end

        --Tooltip
        if tonumber( cl_db["ttto"] ) == 1 then
          local _abstand = ctr( cl_db["ttsf"] ) * 3.5
          drawHUDElement( "tt", nil, nil, nil, nil, nil )

          draw.SimpleTextOutlined( lang.tooltip .. ":", "ttsf", ctr( cl_db["ttpx"] ) + ctr( 32 ), ctr( cl_db["ttpy"] ) + ctr( 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( "F2 - " .. lang.characterselection, "ttsf", ctr( cl_db["ttpx"] ) + ctr( 32 ), ctr( cl_db["ttpy"] ) + ctr( 10 + 1*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( "F3 - " .. lang.rolemenu, "ttsf", ctr( cl_db["ttpx"] ) + ctrW( 32 ), ctr( cl_db["ttpy"] ) + ctr( 10 ) + ctr( 2*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( "F4 - " .. lang.buymenu, "ttsf", ctr( cl_db["ttpx"] ) + ctrW( 32 ), ctr( cl_db["ttpy"] ) + ctr( 10 ) + ctr( 3*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( "F7  - " .. lang.settings, "ttsf", ctr( cl_db["ttpx"] ) + ctrW( 32 ), ctr( cl_db["ttpy"] ) + ctr( 10 ) + ctr( 4*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( "F11  - " .. lang.guimouse, "ttsf", ctr( cl_db["ttpx"] ) + ctrW( 32 ), ctr( cl_db["ttpy"] ) + ctr( 10 ) + ctr( 5*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( "B  - " .. lang.changeview, "ttsf", ctr( cl_db["ttpx"] ) + ctrW( 32 ), ctr( cl_db["ttpy"] ) + ctr( 10 ) + ctr( 6*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( "M  - " .. lang.map, "ttsf", ctr( cl_db["ttpx"] ) + ctrW( 32 ), ctr( cl_db["ttpy"] ) + ctr( 10 ) + ctr( 7*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( "H  - " .. "Eat Food (later consumable)", "ttsf", ctr( cl_db["ttpx"] ) + ctrW( 32 ), ctr( cl_db["ttpy"] ) + ctr( 10 ) + ctr( 8*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( "T  - " .. "Drink Water (later consumable)", "ttsf", ctr( cl_db["ttpx"] ) + ctrW( 32 ), ctr( cl_db["ttpy"] ) + ctr( 10 ) + ctr( 9*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
        end

        --Status
        local _sttext = ""
        local _showStatus = false
        if ply:GetNWBool( "cuffed" ) then
          if _sttext != "" then
            _sttext = _sttext .. ", "
          end
          _sttext = _sttext .. "Cuffed"
          _showStatus = true
        end
        if ply:GetNWInt( "hunger", 100 ) < 20 then
          if _sttext != "" then
            _sttext = _sttext .. ", "
          end
          _sttext = _sttext .. "Hungry"
          _showStatus = true
        end
        if ply:GetNWInt( "thirst", 100 ) < 20 then
          if _sttext != "" then
            _sttext = _sttext .. ", "
          end
          _sttext = _sttext .. "Thirsty"
          _showStatus = true
        end
        if ply:GetNWBool( "inJail", false ) then
          if _sttext != "" then
            _sttext = _sttext .. ", "
          end
          _sttext = _sttext .. lang.jail .. ": " .. ply:GetNWInt( "jailtime", 0 )
          _showStatus = true
        end
        if tonumber( cl_db["stto"] ) == 1 and _sttext != "" then
          drawHUDElement( "st", nil, nil, _sttext, nil, nil )
        end

        --Voting
        if tonumber( cl_db["vtto"] ) == 1 and ply:GetNWBool( "voting", false ) then
          drawRBox( 0, cl_db["vtpx"], cl_db["vtpy"], cl_db["vtsw"], cl_db["vtsh"], Color( 0, 0, 0, _alpha ) )

          drawText( ply:GetNWString( "voteQuestion", "" ), "HudBars", cl_db["vtpx"] + cl_db["vtsw"]/2, cl_db["vtpy"] + cl_db["vtsh"]/4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
          if ply:GetNWString( "voteStatus" ) != "yes" and ply:GetNWString( "voteStatus" ) != "no" then
            drawText( lang.yes .. " - [Picture Up] | " .. lang.no .. " - [Picture Down]", "vof", cl_db["vtpx"] + cl_db["vtsw"]/2, cl_db["vtpy"] + 2*(cl_db["vtsh"]/4), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
          elseif ply:GetNWString( "voteStatus" ) == "yes" then
            drawText( lang.yes, "vof", cl_db["vtpx"] + cl_db["vtsw"]/2, cl_db["vtpy"] + 2*(cl_db["vtsh"]/4), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
          elseif ply:GetNWString( "voteStatus" ) == "no" then
            drawText( lang.no, "vof", cl_db["vtpx"] + cl_db["vtsw"]/2, cl_db["vtpy"] + 2*(cl_db["vtsh"]/4), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
          end
          drawText( ply:GetNWInt( "voteCD", "" ), "vof", cl_db["vtpx"] + cl_db["vtsw"]/2, cl_db["vtpy"] + 3*(cl_db["vtsh"]/4), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
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
          draw.SimpleTextOutlined( _3PText, "HudBars", ScrW()/2, ctrW( 2160/2 + 500 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
        end
      end
    else
      drawRBox( 0, 0, 0, ScrW() * ctrF( ScrH() ), ScrH() * ctrF( ScrH() ), Color( 255, 0, 0, 100 ) )
      draw.SimpleTextOutlined( lang.dead .. "! " .. lang.respawning .. "...", "HudBars", ScrW()/2, ScrH()/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    end
  end
end
