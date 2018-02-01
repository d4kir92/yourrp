--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

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
hud["st"] = 0

local reload = {}

reload.nextP = 0
reload.nextPC = 0
reload.maxP = 0
reload.statusP = 0

reload.nextS = 0
reload.nextSC = 0
reload.maxS = 0
reload.statusS = 0

function roundMoney( _money, round )
  if _money != nil then
    local money = tonumber( _money )
    if money > 1000 and money < 1000000 then
      return math.Round( money / 1000, round ) .. "K"
    elseif money > 1000000 and money < 1000000000 then
      return math.Round( money / 1000000, round ) .. "M"
    elseif money > 1000000000 then
      return math.Round( money / 1000000000, round ) .. "B"
    elseif money > 1000000000000 then
      return math.Round( money / 1000000000000, round ) .. "T"
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
  local _r = 0
  if tobool( HudV( dbV .. "to" ) ) then

    if cur != nil and max != nil then
      hud[dbV] = Lerp( 10 * FrameTime(), hud[dbV], cur )
    end
    if tobool( HudV( dbV .. "tr" ) ) then
      _r = ctr( HudV( dbV .. "sh" ) )/2
    end
    draw.RoundedBox( _r, anchorW( HudV( dbV .. "aw" ) ) + ctr( HudV( dbV .. "px" ) ), anchorH( HudV( dbV .. "ah" ) ) + ctr( HudV( dbV .. "py" ) ), ctr( HudV( dbV .. "sw" ) ), ctr( HudV( dbV .. "sh" ) ), Color( HudV("colbgr"), HudV("colbgg"), HudV("colbgb"), HudV("colbga") ) )
    if color != nil and cur != nil and max != nil then
      if tonumber( max ) >= 0 then
        if tonumber(cur) > tonumber(max) then
          cur = max
        end
        if !tobool( HudV( dbV .. "tr" ) ) then
          draw.RoundedBox( _r, anchorW( HudV( dbV .. "aw" ) ) + ctr( HudV(dbV .. "px") ), anchorH( HudV( dbV .. "ah" ) ) + ctr( HudV(dbV .. "py") ), ( hud[dbV] / max ) * ( ctr( HudV(dbV .. "sw") ) ), ctr( HudV(dbV .. "sh") ), color )
        else
          drawRoundedBoxStencil( _r, anchorW( HudV( dbV .. "aw" ) ) + ctr( HudV(dbV .. "px") ), anchorH( HudV( dbV .. "ah" ) ) + ctr( HudV(dbV .. "py") ), ( hud[dbV] / max ) * ( ctr( HudV(dbV .. "sw") ) ), ctr( HudV(dbV .. "sh") ), color, ctr( HudV(dbV .. "sw") ) )
        end
      end
    end

    local _st = {}
    if text != nil and HudV( dbV .. "tt" ) == 1 then
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
  end
end

function drawHUDElementBr( dbV )
  if tobool( HudV( dbV .. "to" ) ) then
    if !tobool( HudV( dbV .. "tr" ) ) then
      drawRBoxBr( 0, ctrF( ScrH() ) * anchorW( HudV( dbV .. "aw" ) ) + HudV( dbV .. "px" ), ctrF( ScrH() ) * anchorH( HudV( dbV .. "ah" ) ) + HudV( dbV .. "py" ), HudV( dbV .. "sw" ), HudV( dbV .. "sh" ), Color( HudV("colbrr"), HudV("colbrg"), HudV("colbrb"), HudV("colbra") ), ctr( 4 ) )
    else
      _r = ctr( HudV( dbV .. "sh" ) )/2

      local _br = {}
      _br.r = _r
      _br.x = anchorW( HudV( dbV .. "aw" ) ) + ctr( HudV(dbV .. "px") )
      _br.y = anchorH( HudV( dbV .. "ah" ) ) + ctr( HudV(dbV .. "py") )
      _br.w = ctr( HudV(dbV .. "sw") )
      _br.h = ctr( HudV(dbV .. "sh") )

      drawRoundedBoxBR( _br.r, _br.x, _br.y, _br.w, _br.h, Color( HudV("colbrr"), HudV("colbrg"), HudV("colbrb"), HudV("colbra") ), 1 )
    end
  end
end

local delay = 0

function HudPlayer()
  local ply = LocalPlayer()
  local weapon = ply:GetActiveWeapon()
  if is_hud_db_loaded() then
    local br = 2

    if ply:Alive() then
      if !contextMenuOpen then

        if GetConVar( "yrp_cl_hud" ):GetInt() == 1 and LocalPlayer():GetNWBool( "toggle_hud", false ) then

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
            local _mstext = math.Round( ( math.Round( ply:GetNWInt( "GetCurStamina", 0 ), 0 ) / ply:GetNWInt( "GetMaxStamina", 0 ) ) * 100, 0 ) .. "%"
            drawHUDElement( "ms", ply:GetNWInt( "GetCurStamina", 0 ), ply:GetNWInt( "GetMaxStamina", 0 ), _mstext, stamina, Color( 150, 150, 60, _alpha ) )
          end

          --Mana
          local _matext = ply:GetNWInt( "GetCurAbility", 0 ) .. "/" .. ply:GetNWInt( "GetMaxAbility", 100 ) .. "|" .. math.Round( ( math.Round( ply:GetNWInt( "GetCurAbility", 0 ), 0 ) / ply:GetNWInt( "GetMaxAbility", 100 ) ) * 100, 0 ) .. "%"
          drawHUDElement( "ma", ply:GetNWInt( "GetCurAbility", 0 ), ply:GetNWInt( "GetMaxAbility", 100 ), _matext, mana, Color( 58, 143, 255, _alpha ) )

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
          local _pre = ply:GetNWString( "moneyPre", "" )
          local _pos = ply:GetNWString( "moneyPost", "" )
          _money = roundMoney( _money, 1 )
          local _motext = _pre .. tostring(_money) .. _pos
          local _salary = tonumber( ply:GetNWInt( "salary", 0 ) )
          if _salary > 0 then
            _motext = _motext .. " (+".. ply:GetNWString( "moneyPre" ) .. roundMoney( _salary, 1 ) .. ply:GetNWString( "moneyPost" ) .. ")"
            _salaryMin = CurTime() + ply:GetNWInt( "salarytime" ) - 1 - ply:GetNWInt( "nextsalarytime" )
            _salaryMax = ply:GetNWInt( "salarytime" )
          else
            _salaryMin = 1
            _salaryMax = 1
          end
          drawHUDElement( "mo", _salaryMin, _salaryMax, _motext, money, Color( 33, 108, 42, _alpha ) )

          --XP
          local _xptext = "" --lang_string( "level" ) .. " " .. 1 .. " (" .. 0 .. "%) " ..
          _xptext = ply:GetNWString( "groupName" ) .. " " .. ply:GetNWString( "roleName" )
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
            _wntext = weapon:GetPrintName() or ""
          end
          drawHUDElement( "wn", nil, nil, _wntext, nil, nil )

          --Minimap
          if tonumber( HudV("mmto") ) == 1 then
            if !tobool(HudV( "mm" .. "tr" )) then
              draw.RoundedBox( 0, anchorW( HudV("mmaw") ) + ctr( HudV("mmpx") ), anchorH( HudV("mmah") ) + ctr( HudV("mmpy") ), ctr( HudV("mmsw") ), ctr( HudV("mmsh") ), Color( 0, 0, 0, _alpha ) )
            else
              drawRoundedBox( 0, anchorW( HudV("mmaw") ) + ctr( HudV("mmpx") ), anchorH( HudV("mmah") ) + ctr( HudV("mmpy") ), ctr( HudV("mmsw") ), ctr( HudV("mmsh") ), Color( 0, 0, 0, _alpha ) )
            end
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

                  local _m_w = ctr( HudV("mmsw") )
                  local _m_h = ctr( HudV("mmsh") )

                  local _m_x = anchorW( HudV( "mmaw" ) ) + ctr( HudV("mmpx") ) + _m_w/2
                  local _m_y = anchorH( HudV( "mmah" ) ) + ctr( HudV("mmpy") ) + _m_h/2
                  --STENCIL
                  render.ClearStencil()
                	render.SetStencilEnable( true )
                		render.SetStencilWriteMask( 255 )
                		render.SetStencilTestMask( 255 )
                		render.SetStencilReferenceValue( 25 )
                		render.SetStencilFailOperation( STENCIL_REPLACE )

                    if tobool(HudV( "mm" .. "tr" )) then
                      surface.SetDrawColor( 0, 0, 0, 200 )
                    	draw.NoTexture()

                    	drawCircle( _m_x, _m_y, _m_w/2, 64 )
                    else
                  		draw.RoundedBox( 0, anchorW( HudV( "mmaw" ) ) + ctr( HudV("mmpx") ), anchorH( HudV( "mmah" ) ) + ctr(HudV("mmpy")), ctr(HudV("mmsw")), ctr(HudV("mmsh")), Color( 255, 255, 255 ) )
                    end
                		render.SetStencilCompareFunction( STENCIL_EQUAL )

                    surface.SetDrawColor( 255, 255, 255, 255 )
                    surface.SetMaterial( minimap_RT_mat )
                    surface.DrawTexturedRect( anchorW( HudV( "mmaw" ) ) + ctr(HudV("mmpx")) + ctr(HudV("mmsw")/2) - plyPos.x, anchorH( HudV( "mmah" ) ) + ctr(HudV("mmpy"))  +ctr(HudV("mmsh")/2)- plyPos.y, mm.w, mm.h )
                  render.SetStencilEnable( false )

                  if !tobool(HudV( "mm" .. "tr" )) then
                    drawRBoxBr( 0, ctrF( ScrH() ) * anchorW( HudV( "mm" .. "aw" ) ) + HudV( "mm" .. "px" ), ctrF( ScrH() ) * anchorH( HudV( "mm" .. "ah" ) ) + HudV( "mm" .. "py" ), HudV( "mm" .. "sw" ), HudV( "mm" .. "sh" ), Color( HudV("colbrr"), HudV("colbrg"), HudV("colbrb"), HudV("colbra") ), ctr( 4 ) )
                  else
                    render.ClearStencil()
                  	render.SetStencilEnable( true )
                  		render.SetStencilWriteMask( 255 )
                  		render.SetStencilTestMask( 255 )
                  		render.SetStencilReferenceValue( 25 )
                  		render.SetStencilFailOperation( STENCIL_REPLACE )

                      surface.SetDrawColor( 0, 0, 0, 200 )
                    	draw.NoTexture()
                    	drawCircle( _m_x, _m_y, _m_w/2*0.99, 64 )

                  		render.SetStencilCompareFunction( STENCIL_NOTEQUAL )

                      surface.SetDrawColor( Color( HudV("colbrr"), HudV("colbrg"), HudV("colbrb"), HudV("colbra") ) )
                    	draw.NoTexture()
                    	drawCircle( _m_x, _m_y, _m_w/2*1.01, 64 )
                    render.SetStencilEnable( false )
                  end
                end
              else
                getCoordsMM()
              end
            end

            minimap.point = 8
            drawRBoxCr( ctrF(ScrH()) * anchorW( HudV( "mmaw" ) ) + HudV("mmpx") + (HudV("mmsw")/2) - (minimap.point/2), ctrF(ScrH()) * anchorH( HudV( "mmah" ) ) + HudV("mmpy") + (HudV("mmsh")/2) - (minimap.point/2), minimap.point, Color( 0, 0, 255, 200 ) )

            --Coords
            local _st = {}
            if HudV( "mm" .. "tt" ) == 1 then
              _st.br = 10
              local _pw = 0
              if HudV( "mm" .. "tx" ) == 0 then
                _pw = ctr( _st.br )
              elseif HudV( "mm" .. "tx" ) == 1 then
                _pw = ctr( HudV( "mm" .. "sw" ) ) / 2
              elseif HudV( "mm" .. "tx" ) == 2 then
                _pw = ctr( HudV( "mm" .. "sw" ) ) - ctr( _st.br )
              end
              local _ph = 0
              if HudV( "mm" .. "ty" ) == 3 then
                _ph = ctr( _st.br )
              elseif HudV( "mm" .. "ty" ) == 1 then
                _ph = ctr( HudV( "mm" .. "sh" ) ) / 2
              elseif HudV( "mm" .. "ty" ) == 4 then
                _ph = ctr( HudV( "mm" .. "sh" ) ) - ctr( _st.br )
              end
              _st.x = anchorW( HudV( "mm" .. "aw" ) ) + ctr( HudV( "mm" .. "px" ) ) + _pw
              _st.y = anchorH( HudV( "mm" .. "ah" ) ) + ctr( HudV( "mm" .. "py" ) ) + _ph
              draw.SimpleTextOutlined( math.Round( ply:GetPos().x, -1 ) .. ", " .. math.Round( ply:GetPos().y, -1 ), "HudBars", _st.x, _st.y, Color( 255, 255, 255, 255 ), HudV( "mmtx" ), HudV( "mmty" ), 1, Color( 0, 0, 0 ) )
            end
          end

        end

        --Status
        local _sttext = ""
        local _st_m = 0
        if ply:IsBleeding() then
          if _sttext != "" then
            _sttext = _sttext .. ", "
          end
          _sttext = _sttext .. lang_string( "youarebleeding" )
          if _st_m < 3 then
            _st_m = 3
          end
        end
        if ply:GetNWBool( "cuffed" ) then
          if _sttext != "" then
            _sttext = _sttext .. ", "
          end
          _sttext = _sttext .. lang_string( "cuffed" )
          if _st_m < 2 then
            _st_m = 2
          end
        end
        if ply:GetNWBool( "weaponlowered" ) then
          if _sttext != "" then
            _sttext = _sttext .. ", "
          end
          _sttext = _sttext .. lang_string( "weaponlowered" )
          if _st_m < 1 then
            _st_m = 1
          end
        end
        if ply:GetNWInt( "hunger", 100 ) < 20 then
          if _sttext != "" then
            _sttext = _sttext .. ", "
          end
          _sttext = _sttext .. lang_string( "hungry" )
          if _st_m < 2 then
            _st_m = 2
          end
        end
        if ply:GetNWInt( "thirst", 100 ) < 20 then
          if _sttext != "" then
            _sttext = _sttext .. ", "
          end
          _sttext = _sttext .. lang_string( "thirsty" )
          if _st_m < 2 then
            _st_m = 2
          end
        end
        if ply:GetNWBool( "inJail", false ) then
          if _sttext != "" then
            _sttext = _sttext .. ", "
          end
          _sttext = _sttext .. lang_string( "jail" ) .. ": " .. ply:GetNWInt( "jailtime", 0 )
          if _st_m < 2 then
            _st_m = 2
          end
        end
        local _st_c = Color( 0, 0, 0, 0 )
        if _st_m == 3 then
          _st_c = Color( 255, 0, 0, HudV( "colbga" ) )
        elseif _st_m == 2 then
          _st_c = Color( 255, 255, 0, HudV( "colbga" ) )
        elseif _st_m == 1 then
          _st_c = Color( 0, 255, 0, HudV( "colbga" ) )
        end
        if tonumber( HudV("stto") ) == 1 and _sttext != "" then
          drawHUDElement( "st", 1, 1, _sttext, nil, _st_c )
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

        drawHUDElementBr( "mo" )
        drawHUDElementBr( "hp" )
        drawHUDElementBr( "ar" )
        drawHUDElementBr( "xp" )
        if ply:GetNWBool( "toggle_stamina", false ) then
          drawHUDElementBr( "ms" )
        end
        drawHUDElementBr( "wn" )
        drawHUDElementBr( "wp" )
        if weapon != NULL then
          if ply:GetAmmoCount(weapon:GetSecondaryAmmoType()) > 0 then
            drawHUDElementBr( "ws" )
          end
        end
        if ply:GetNWBool( "toggle_thirst", false ) then
          drawHUDElementBr( "mt" )
        end
        if ply:GetNWBool( "toggle_hunger", false ) then
          drawHUDElementBr( "mh" )
        end
        if ply:GetNWBool( "casting", false ) then
          drawHUDElementBr( "ca" )
        end
        if _sttext != "" then
          drawHUDElementBr( "st" )
        end
        drawHUDElementBr( "ma" )

        --Thirdperson
        if input.IsKeyDown( get_keybind( "view_zoom_in" ) ) or input.IsKeyDown( get_keybind( "view_zoom_out" ) ) then
          local _3PText = ""
          if ply:GetNWInt( "view_range", 0 ) <= -200 then
            _3PText = lang_string( "fppr" )
          elseif ply:GetNWInt( "view_range", 0 ) > -200 and ply:GetNWInt( "view_range", 0 ) < 0 then
            _3PText = lang_string( "fpp" )
          elseif ply:GetNWInt( "view_range", 0 ) > 0 then
            _3PText = lang_string( "tpp" )
          end
          draw.SimpleTextOutlined( _3PText .. " ( " .. math.Round( ply:GetNWInt( "view_range", 0 ), -1 ) .. " )", "HudBars", ScrW()/2, ctr( 2160/2 + 550 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
        end
        if input.IsKeyDown( get_keybind( "view_up" ) ) or input.IsKeyDown( get_keybind( "view_down" ) ) then
          draw.SimpleTextOutlined( lang_string( "viewingheight" ) .. " ( " .. math.Round( ply:GetNWInt( "view_z", 0 ), 0 ) .. " )", "HudBars", ScrW()/2, ctr( 2160/2 + 600 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
        end
        if input.IsKeyDown( get_keybind( "view_right" ) ) or input.IsKeyDown( get_keybind( "view_left" ) ) then
          draw.SimpleTextOutlined( lang_string( "viewingposition" ) .. " ( " .. math.Round( ply:GetNWInt( "view_x", 0 ), 0 ) .. " )", "HudBars", ScrW()/2, ctr( 2160/2 + 650 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
        end
        if input.IsKeyDown( get_keybind( "view_spin_right" ) ) or input.IsKeyDown( get_keybind( "view_spin_left" ) ) then
          draw.SimpleTextOutlined( lang_string( "viewingangle" ) .. " ( " .. math.Round( ply:GetNWInt( "view_s", 0 ), 0 ) .. " )", "HudBars", ScrW()/2, ctr( 2160/2 + 700 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
        end
      end
    else
      drawRBox( 0, 0, 0, ScrW() * ctrF( ScrH() ), ScrH() * ctrF( ScrH() ), Color( 255, 0, 0, 100 ) )
      draw.SimpleTextOutlined( lang_string( "dead" ) .. "! " .. lang_string( "respawning" ) .. "...", "HudBars", ScrW()/2, ScrH()/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    end
  else
    draw.SimpleTextOutlined( "Loading HUD", "DermaDefault", ScrW2(), ScrH2(), Color( 255, 255, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr( 1 ), Color( 0, 0, 0, 255 ) )
    --printGM( "note", "Try to reload hud database" )
    loadDatabaseHUD()
  end
end
