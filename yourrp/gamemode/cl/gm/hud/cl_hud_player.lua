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
hud["mo"] = 0

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
  surface.DrawTexturedRect( anchorW( HudV(string .. "aw") ) + ctr( HudV(string .. "px") ) + ctr( 30 ) - ctr( 16 ), anchorH( HudV(string .. "ah") ) + ctr( HudV(string .. "py") ) + ctr( HudV(string .. "sh")/2 ) - ctr( 16 ), ctr( 32 ), ctr( 32 ) )
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
    draw.RoundedBox( 0, anchorW( HudV( dbV .. "aw" ) ) + ctr( HudV( dbV .. "px" ) ), anchorH( HudV( dbV .. "ah" ) ) + ctr( HudV( dbV .. "py" ) ), ctr( HudV( dbV .. "sw" ) ), ctr( HudV( dbV .. "sh" ) ), Color( HudV("colbgr"), HudV("colbgg"), HudV("colbgb"), HudV("colbga") ) )
    if color != nil and cur != nil and max != nil then
      draw.RoundedBox( 0, anchorW( HudV( dbV .. "aw" ) ) + ctr( HudV(dbV .. "px") ), anchorH( HudV( dbV .. "ah" ) ) + ctr( HudV(dbV .. "py") ), ( hud[dbV] / max ) * ( ctr( HudV(dbV .. "sw") ) ), ctr( HudV(dbV .. "sh") ), color )
    end

    if text != nil and HudV( dbV .. "tt" ) == 1 then
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

    if icon != nil and HudV( dbV .. "it" ) == 1  then
      showIcon( dbV, icon )
    end

    drawRBoxBr( 0, ctrF( ScrH() ) * anchorW( HudV( dbV .. "aw" ) ) + HudV( dbV .. "px" ), ctrF( ScrH() ) * anchorH( HudV( dbV .. "ah" ) ) + HudV( dbV .. "py" ), HudV( dbV .. "sw" ), HudV( dbV .. "sh" ), Color( HudV("colbrr"), HudV("colbrg"), HudV("colbrb"), HudV("colbra") ), ctr( 4 ) )
  end
end

local delay = 0

local _tmp3P = 0
function HudPlayer()
  local ply = LocalPlayer()
  local weapon = ply:GetActiveWeapon()
  if is_hud_db_loaded() then
    local br = 2

    if ply:Alive() then
      if !contextMenuOpen then
        --Voice
        if _showVoice then
          draw.SimpleTextOutlined( lang_string( "youarespeaking" ), "HudBars", ScrW2(), ctr( 500 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
        end

        --Health
        local _hptext = math.Round( ply:Health(), 0 ) .. "/" .. ply:GetMaxHealth() .. "|" .. math.Round( ( math.Round( ply:Health(), 0 ) / ply:GetMaxHealth() ) * 100, 0 ) .. "%"
        drawHUDElement( "hp", ply:Health(), ply:GetMaxHealth(), _hptext, health, Color( 150, 52, 52, _alpha ) )

        --Armor
        local _artext = math.Round( ply:Armor(), 0 ) .. "/" .. ply:GetNWInt( "GetMaxArmor", 1 ) .. "|" .. math.Round( ( math.Round( ply:Armor(), 0 ) / ply:GetNWInt( "GetMaxArmor", 1 ) ) * 100, 0 ) .. "%"
        drawHUDElement( "ar", ply:Armor(), ply:GetNWInt( "GetMaxArmor" ), _artext, armor, Color( 52, 150, 72, _alpha ) )

        --Hunger
        if ply:GetNWBool( "toggle_hunger", false ) then
          local _mhtext = math.Round( ( math.Round( ply:GetNWInt( "hunger", 0 ), 0 ) / 100 ) * 100, 0 ) .. "%"
          drawHUDElement( "mh", ply:GetNWInt( "hunger", 0 ), 100, _mhtext, hunger, Color( 150, 88, 52, _alpha ) )
        end

        --Thirst
        if ply:GetNWBool( "toggle_thirst", false ) then
          local _mttext = math.Round( ( math.Round( ply:GetNWInt( "thirst", 0 ), 0 ) / 100 ) * 100, 0 ) .. "%"
          drawHUDElement( "mt", ply:GetNWInt( "thirst", 0 ), 100, _mttext, thirst, Color( 52, 70, 150, _alpha ) )
        end

        --Stamina
        if ply:GetNWBool( "toggle_stamina", false ) then
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
        local _money = tonumber( ply:GetNWString( "money", "0" ) )
        local _motext = ply:GetNWString( "moneyPre", "" ) .. roundMoney( _money, 1 ) .. ply:GetNWString( "moneyPost", "" )
        local _capital = tonumber( ply:GetNWInt( "capital", 0 ) )
        if _capital > 0 then
          _motext = _motext .. " (+".. ply:GetNWString( "moneyPre" ) .. roundMoney( _capital, 1 ) .. ply:GetNWString( "moneyPost" ) .. ")"
        end
        local _capitalMin = nil
        local _capitalMax = nil
        if _capital > 0 then
          _capitalMin = CurTime() + ply:GetNWInt( "capitaltime" ) - 1 - ply:GetNWInt( "nextcapitaltime" )
          _capitalMax = ply:GetNWInt( "capitaltime" )
        end
        drawHUDElement( "mo", _capitalMin, _capitalMax, _motext, money, Color( 33, 108, 42, _alpha ) )

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
        if tonumber( HudV("mmto") ) == 1 then
          draw.RoundedBox( 0, anchorW( HudV("mmaw") ) + ctr( HudV("mmpx") ), anchorH( HudV("mmah") ) + ctr( HudV("mmpy") ), ctr( HudV("mmsw") ), ctr( HudV("mmsh") ), Color( 0, 0, 0, _alpha ) )
          if minimap != nil then
            if playerfullready == true and minimap.facX != nil and minimap.facY != nil then
              local win = {}
              win.w = ctr( HudV("mmsw") )
              win.h = ctr( HudV("mmsh") )
              win.x = ctr( HudV("mmpx") )
              win.y = ctr( HudV("mmpy") )

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

              		draw.RoundedBox( 0, anchorW( HudV( "mmaw" ) ) + ctr( HudV("mmpx") ), anchorH( HudV( "mmah" ) ) + ctr(HudV("mmpy")), ctr(HudV("mmsw")), ctr(HudV("mmsh")), Color( 255, 255, 255 ) )

              		render.SetStencilCompareFunction( STENCIL_EQUAL )

                  surface.SetDrawColor( 255, 255, 255, 255 )
                  surface.SetMaterial( minimap_RT_mat )
                  surface.DrawTexturedRect( anchorW( HudV( "mmaw" ) ) + ctr(HudV("mmpx")) + ctr(HudV("mmsw")/2) - plyPos.x, anchorH( HudV( "mmah" ) ) + ctr(HudV("mmpy"))  +ctr(HudV("mmsh")/2)- plyPos.y, mm.w, mm.h )
                render.SetStencilEnable( false )

                drawRBoxBr( 0, ctrF( ScrH() ) * anchorW( HudV( "mm" .. "aw" ) ) + HudV( "mm" .. "px" ), ctrF( ScrH() ) * anchorH( HudV( "mm" .. "ah" ) ) + HudV( "mm" .. "py" ), HudV( "mm" .. "sw" ), HudV( "mm" .. "sh" ), Color( HudV("colbrr"), HudV("colbrg"), HudV("colbrb"), HudV("colbra") ), ctr( 4 ) )
              end
            else
              getCoordsMM()
            end
          end

          minimap.point = 8
          drawRBoxCr( ctrF(ScrH()) * anchorW( HudV( "mmaw" ) ) + HudV("mmpx") + (HudV("mmsw")/2) - (minimap.point/2), ctrF(ScrH()) * anchorH( HudV( "mmah" ) ) + HudV("mmpy") + (HudV("mmsh")/2) - (minimap.point/2), minimap.point, Color( 0, 0, 255, 200 ) )

          --Coords
          if HudV( "mm" .. "it" ) == 1 then
            draw.SimpleTextOutlined( math.Round( ply:GetPos().x, -1 ) .. ",", "HudBars", anchorW( HudV( "mmaw" ) ) + ctr( HudV("mmpx") ) + ( ctr( HudV("mmsw") ) / 2 ), anchorH( HudV( "mmah" ) ) + ctr( HudV("mmpy") ) + ctr( HudV("mmsh") - 20 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
            draw.SimpleTextOutlined( " " .. math.Round( ply:GetPos().y, -1 ), "HudBars", anchorW( HudV( "mmaw" ) ) + ctr( HudV("mmpx") ) + ( ctr( HudV("mmsw") ) / 2 ), anchorH( HudV( "mmah" ) ) + ctr( HudV("mmpy") ) + ctr( HudV("mmsh") - 20 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
          end
        end

        --Tooltip
        if tonumber( HudV("ttto") ) == 1 then
          local _abstand = ctr( HudV("ttsf") ) * 3.5
          drawHUDElement( "tt", nil, nil, nil, nil, nil )

          draw.SimpleTextOutlined( lang_string( "tooltip" ) .. ":", "ttsf", ctr( HudV("ttpx") ) + ctr( 32 ), ctr( HudV("ttpy") ) + ctr( 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( "[" .. string.upper( input.GetKeyName( get_keybind( "menu_character_selection" ) ) ) .. "] " .. lang_string( "characterselection" ), "ttsf", ctr( HudV("ttpx") ) + ctr( 32 ), ctr( HudV("ttpy") ) + ctr( 10 + 1*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( "[" .. string.upper( input.GetKeyName( get_keybind( "menu_role" ) ) ) .. "] " .. lang_string( "rolemenu" ), "ttsf", ctr( HudV("ttpx") ) + ctr( 32 ), ctr( HudV("ttpy") ) + ctr( 10 ) + ctr( 2*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( "[" .. string.upper( input.GetKeyName( get_keybind( "menu_buy" ) ) ) .. "] " .. lang_string( "buymenu" ), "ttsf", ctr( HudV("ttpx") ) + ctr( 32 ), ctr( HudV("ttpy") ) + ctr( 10 ) + ctr( 3*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( "[" .. string.upper( input.GetKeyName( get_keybind( "menu_settings" ) ) ) .. "] " .. lang_string( "settings" ), "ttsf", ctr( HudV("ttpx") ) + ctr( 32 ), ctr( HudV("ttpy") ) + ctr( 10 ) + ctr( 4*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( "[" .. string.upper( input.GetKeyName( get_keybind( "toggle_mouse" ) ) ) .. "] " .. lang_string( "guimouse" ), "ttsf", ctr( HudV("ttpx") ) + ctr( 32 ), ctr( HudV("ttpy") ) + ctr( 10 ) + ctr( 5*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( "[" .. string.upper( input.GetKeyName( get_keybind( "toggle_view" ) ) ) .. "] " .. lang_string( "changeview" ), "ttsf", ctr( HudV("ttpx") ) + ctr( 32 ), ctr( HudV("ttpy") ) + ctr( 10 ) + ctr( 6*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( "[" .. string.upper( input.GetKeyName( get_keybind( "toggle_map" ) ) ) .. "] " .. lang_string( "map" ), "ttsf", ctr( HudV("ttpx") ) + ctr( 32 ), ctr( HudV("ttpy") ) + ctr( 10 ) + ctr( 7*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( "[" .. string.upper( input.GetKeyName( get_keybind( "menu_inventory" ) ) ) .. "] " .. lang_string( "inventory" ), "ttsf", ctr( HudV("ttpx") ) + ctr( 32 ), ctr( HudV("ttpy") ) + ctr( 10 ) + ctr( 8*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
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
          _sttext = _sttext .. lang_string( "jail" ) .. ": " .. ply:GetNWInt( "jailtime", 0 )
          _showStatus = true
        end
        if tonumber( HudV("stto") ) == 1 and _sttext != "" then
          drawHUDElement( "st", nil, nil, _sttext, nil, nil )
        end

        --Voting
        if tonumber( HudV("vtto") ) == 1 and ply:GetNWBool( "voting", false ) then
          drawRBox( 0, HudV("vtpx"), HudV("vtpy"), HudV("vtsw"), HudV("vtsh"), Color( 0, 0, 0, _alpha ) )

          drawText( ply:GetNWString( "voteQuestion", "" ), "HudBars", HudV("vtpx") + HudV("vtsw")/2, HudV("vtpy") + HudV("vtsh")/4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
          if ply:GetNWString( "voteStatus" ) != "yes" and ply:GetNWString( "voteStatus" ) != "no" then
            drawText( lang_string( "yes" ) .. " - [Picture Up] | " .. lang_string( "no" ) .. " - [Picture Down]", "vof", HudV("vtpx") + HudV("vtsw")/2, HudV("vtpy") + 2*(HudV("vtsh")/4), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
          elseif ply:GetNWString( "voteStatus" ) == "yes" then
            drawText( lang_string( "yes" ), "vof", HudV("vtpx") + HudV("vtsw")/2, HudV("vtpy") + 2*(HudV("vtsh")/4), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
          elseif ply:GetNWString( "voteStatus" ) == "no" then
            drawText( lang_string( "no" ), "vof", HudV("vtpx") + HudV("vtsw")/2, HudV("vtpy") + 2*(HudV("vtsh")/4), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
          end
          drawText( ply:GetNWInt( "voteCD", "" ), "vof", HudV("vtpx") + HudV("vtsw")/2, HudV("vtpy") + 3*(HudV("vtsh")/4), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
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
            _3PText = lang_string( "fpp" )
          elseif _thirdperson == 1 then
            _3PText = lang_string( "fppr" )
          elseif _thirdperson == 2 then
            _3PText = lang_string( "tpp" )
          end
          draw.SimpleTextOutlined( _3PText, "HudBars", ScrW()/2, ctr( 2160/2 + 550 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
        end
      end
    else
      drawRBox( 0, 0, 0, ScrW() * ctrF( ScrH() ), ScrH() * ctrF( ScrH() ), Color( 255, 0, 0, 100 ) )
      draw.SimpleTextOutlined( lang_string( "dead" ) .. "! " .. lang_string( "respawning" ) .. "...", "HudBars", ScrW()/2, ScrH()/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    end
  else
    printGM( "note", "Try to reload hud database" )
    loadDatabaseHUD()
  end
end
