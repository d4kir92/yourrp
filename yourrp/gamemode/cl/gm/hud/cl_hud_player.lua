--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

_filterENTS = ents.GetAll()
local _filterTime = CurTime()

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
hud["bl"] = 0

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

include( "player/cl_hud_hp.lua" )
include( "player/cl_hud_ar.lua" )
include( "player/cl_hud_ma.lua" )
include( "player/cl_hud_mh.lua" )
include( "player/cl_hud_mt.lua" )
include( "player/cl_hud_ms.lua" )
include( "player/cl_hud_ca.lua" )
include( "player/cl_hud_mo.lua" )
include( "player/cl_hud_xp.lua" )
include( "player/cl_hud_wn.lua" )
include( "player/cl_hud_wp.lua" )
include( "player/cl_hud_ws.lua" )
include( "player/cl_hud_mm.lua" )
include( "player/cl_hud_st.lua" )
include( "player/cl_hud_vt.lua" )
include( "player/cl_hud_bl.lua" )

include( "player/cl_hud_thirdperson.lua" )

function client_toggled()
  return tobool( GetConVar( "yrp_cl_hud" ):GetInt() )
end

function server_toggled( ply )
  return ply:GetNWBool( "toggle_hud", false )
end

function HudPlayer( ply )
  local weapon = ply:GetActiveWeapon()
  if is_hud_db_loaded() then
    local br = 2

    if ply:Alive() then
      if !contextMenuOpen then
        if client_toggled() then
          --[[ Hud Bars ]]--
          if server_toggled( ply ) then
            hudHP( ply, Color( 150, 52, 52, _alpha ) )
            hudAR( ply, Color( 52, 150, 72, _alpha ) )

            hudMO( ply, Color( 33, 108, 42, _alpha ) )
            hudXP( ply, Color( 181, 255, 107, _alpha ) )

            hudWN( ply, Color( 181, 255, 107, _alpha ), weapon )
            hudWP( ply, Color( 255, 255, 100, _alpha ), weapon )
            hudWS( ply, Color( 255, 255, 100, _alpha ), weapon )

            hudMM( ply, Color( 0, 0, 0 ) )
          end
          hudMA( ply, Color( 58, 143, 255, _alpha ) )

          hudMH( ply, Color( 150, 88, 52, _alpha ) )
          hudMT( ply, Color( 52, 70, 150, _alpha ) )
          hudMS( ply, Color( 150, 150, 60, _alpha ) )

          hudCA( ply, Color( 132, 116, 188, _alpha ) )

          hudVT( ply, Color( 0, 0, 0, _alpha ) )
          hudST( ply, Color( 0, 0, 0, _alpha ) )

          hudBL( ply, Color( 0, 0, 0, _alpha ) )

          --[[ Hud Borders ]]--
          if server_toggled( ply ) then
            hudHPBR( ply )
            hudARBR( ply )

            hudMOBR( ply )
            hudXPBR( ply )

            hudWNBR( ply )
            hudWPBR( ply )
            hudWSBR( ply, weapon )
          end
          hudMABR( ply )

          hudMHBR( ply )
          hudMTBR( ply )
          hudMSBR( ply )

          hudCABR( ply )

          hudVTBR( ply )
          hudSTBR( ply )

          hudBLBR( ply )
        end

        --[[ Extras ]]--
        hudThirdperson( ply )
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
