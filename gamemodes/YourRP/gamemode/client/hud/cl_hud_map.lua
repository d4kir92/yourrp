--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

//cl_hud_map.lua

map = {}
function getCoords()
  net.Start( "askCoords" )
  net.SendToServer()
end

function openSpawnMenu()
  map.open = true
  mapWindow = vgui.Create( "DFrame" )
  mapWindow:SetTitle("")
  mapWindow:SetPos( 0, 0 )
  mapWindow:SetSize( ScrW(), ScrH() )
  mapWindow:ShowCloseButton( false )
  mapWindow:SetDraggable( false )
  function mapWindow:Paint()
    if map != nil then
      if map.facX != nil and map.facY != nil then
        local ply = LocalPlayer()
        draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 0, 0, 0, 254 ) )           //mapWindow of Map

        local win = {}
        win.x = ( ( ScrW() / 2 ) - ctrW( 1050 ) / map.facX )
        win.y = ( ( ScrH() / 2 ) - ctrW( 1050-25 ) / map.facY )
        win.w = ctrW(2100) / map.facX
        win.h = ctrW(2100) / map.facY
        draw.RoundedBox( 0, win.x - ctrW(2), win.y - ctrW(2), win.w + ctrW( 4 ), win.h + ctrW( 4 ), Color( 255, 255, 0, 240 ) )
        draw.RoundedBox( 0, win.x, win.y, win.w, win.h, Color( 0, 0, 0, 255 ) )

        local _mapName = string.Replace( string.upper( game.GetMap() ), "_", " " )
        draw.SimpleText( "[M] - " .. lang.map .. ": " .. _mapName, "HudBars", win.x + win.w/2, win.y - ctrW( 30 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        local tr = util.TraceLine( {
          start = ply:GetPos() + Vector( 0, 0, 1400 ),
          endpos = ply:GetPos() + Vector( 0, 0, 4000 ),
          filter = _filterENTS
        } )

        local CamDataMap = {}
        CamDataMap.angles = Angle( 90, 90, 0 )
        CamDataMap.origin = Vector( 0, 0, tr.HitPos.z )
        CamDataMap.x = 0
        CamDataMap.y = 0
        CamDataMap.w = win.w
        CamDataMap.h = win.h
        CamDataMap.ortho = true
        CamDataMap.ortholeft = map.sizeW
        CamDataMap.orthoright = map.sizeE
        CamDataMap.orthotop = map.sizeS
        CamDataMap.orthobottom = map.sizeN
        if false then
          CamDataMap.angles = Angle( 90, 90, 0 )
          CamDataMap.origin = Vector( 0, 0, map.sizeUp-64 )
          CamDataMap.x = 0
          CamDataMap.y = 0
          CamDataMap.w = win.w
          CamDataMap.h = win.h
          CamDataMap.ortho = true
          CamDataMap.ortholeft = map.sizeW
          CamDataMap.orthoright = map.sizeE
          CamDataMap.orthotop = map.sizeS
          CamDataMap.orthobottom = map.sizeN
        end

        local rendering_map = false
        local map_RT = GetRenderTarget( "YRP_Map", win.w, win.h, true )
        local map_RT_mat = CreateMaterial( "YRP_Map", "UnlitGeneric", { ["$basetexture"] = "YRP_Map" } )
        local old_RT = render.GetRenderTarget()
        local old_w, old_h = ScrW(), ScrH()
        render.SetRenderTarget( map_RT )
        render.SetViewPort( win.x, win.y, win.w, win.h )

        render.Clear( 0, 0, 0, 0 )

        cam.Start2D()
          rendering_map = true
          render.RenderView( CamDataMap )
          rendering_map = false
        cam.End2D()

        render.SetViewPort( 0, 0, old_w, old_h )
        render.SetRenderTarget( old_RT )
        surface.SetMaterial( map_RT_mat )
        surface.DrawTexturedRect( win.x, win.y, win.w, win.h )

        local plyPos = {}
        plyPos.xMax = map.sizeX
        plyPos.yMax = map.sizeY
        if map.sizeW < 0 then
          plyPos.xtmp = ( LocalPlayer():GetPos().x - map.sizeW )
        else
          plyPos.xtmp = ( LocalPlayer():GetPos().x + map.sizeE )
        end
        if map.sizeS < 0 then
          plyPos.ytmp = ( LocalPlayer():GetPos().y - map.sizeS )
        else
          plyPos.ytmp = ( LocalPlayer():GetPos().y + map.sizeN )
        end
        plyPos.x = win.x + win.w * ( plyPos.xtmp / plyPos.xMax )
        plyPos.y = win.y + win.h - win.h * ( plyPos.ytmp / plyPos.yMax )

        //You
        draw.RoundedBox( ctrW(8), plyPos.x-ctrW(8), plyPos.y-ctrW(8), ctrW(16), ctrW(16), Color(40,40,40))
        draw.RoundedBox( ctrW(8), plyPos.x-ctrW(6), plyPos.y-ctrW(6), ctrW(12), ctrW(12), Color(255,10,10))
        draw.SimpleText( lang.you, "SettingsNormal", plyPos.x, plyPos.y-ctrW(24), Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        //Coords
        draw.SimpleText( math.Round( ply:GetPos().x, 0 ), "SettingsNormal", ScrW()/2, ScrH() - ctrW( 25 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
        draw.SimpleText( ", " .. math.Round( ply:GetPos().y, 0 ), "SettingsNormal", ScrW()/2, ScrH() - ctrW( 25 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

        if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then
          for k, plys in pairs( player.GetAll() ) do
            if plys != LocalPlayer() then
              //Other players
              local tmpPly = {}
              tmpPly.xMax = map.sizeX
              tmpPly.yMax = map.sizeY
              if map.sizeW < 0 then
                tmpPly.xtmp = ( plys:GetPos().x - map.sizeW )
              else
                tmpPly.xtmp = ( plys:GetPos().x + map.sizeE )
              end
              if map.sizeS < 0 then
                tmpPly.ytmp = ( plys:GetPos().y - map.sizeS )
              else
                tmpPly.ytmp = ( plys:GetPos().y + map.sizeN )
              end
              tmpPly.x = win.x + win.w * ( tmpPly.xtmp / tmpPly.xMax )
              tmpPly.y = win.y + win.h - win.h * ( tmpPly.ytmp / tmpPly.yMax )

              //Draw
              draw.RoundedBox( ctrW(8), tmpPly.x-ctrW(8), tmpPly.y-ctrW(8), ctrW(16), ctrW(16), Color( 40, 40, 40, 200 ))
              draw.RoundedBox( ctrW(8), tmpPly.x-ctrW(6), tmpPly.y-ctrW(6), ctrW(12), ctrW(12), Color( 40, 40, 255, 200 ))
              draw.SimpleText( plys:Nick(), "SettingsNormal", tmpPly.x, tmpPly.y-ctrW(24), Color(0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            end
          end
        end
      end
    end
  end
  function mapWindow:OnClose()
    _menuIsOpen = 0
    map.open = false
  end
  function mapWindow:OnRemove()
    _menuIsOpen = 0
    map.open = false
  end
end

net.Receive( "sendCoords", function()
  if net.ReadBool() then
    map = net.ReadTable()
    openSpawnMenu()
  else
    printGM( "note", "wait for server coords" )
    _menuIsOpen = 0
  end
end)
