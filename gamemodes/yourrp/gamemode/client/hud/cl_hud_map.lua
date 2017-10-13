--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--cl_hud_map.lua

local map = {}
function getCoords()
  net.Start( "askCoords" )
  net.SendToServer()
end

local CamDataMap = {}
function openSpawnMenu()
  map.open = true
  mapWindow = vgui.Create( "DFrame" )
  mapWindow:SetTitle("")
  mapWindow:SetPos( 0, 0 )
  mapWindow:SetSize( ScrW(), ScrH() )
  mapWindow:ShowCloseButton( false )
  mapWindow:SetDraggable( false )
  function mapWindow:Paint( pw, ph )
    if map != nil then
      if map.facX != nil and map.facY != nil then
        local ply = LocalPlayer()
        draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 0, 0, 0, 254 ) )           --mapWindow of Map

        local win = {}
        win.w, win.h = lowerToScreen( map.sizeX, map.sizeY )
        win.x = ( ScrW() / 2 ) - ( win.w / 2 )
        win.y = ( ScrH() / 2 ) - ( win.h / 2 )

        draw.RoundedBox( 0, win.x - ctrW(2), win.y - ctrW(2), win.w + ctrW( 4 ), win.h + ctrW( 4 ), Color( 255, 255, 0, 240 ) )
        draw.RoundedBox( 0, win.x, win.y, win.w, win.h, Color( 0, 0, 0, 255 ) )

        local _mapName = string.Replace( string.upper( game.GetMap() ), "_", " " )

        local _testHeight = 4000
        local tr = util.TraceLine( {
          start = ply:GetPos() + Vector( 0, 0, 16 ),
          endpos = ply:GetPos() + Vector( 0, 0, _testHeight ),
          filter = _filterENTS
        } )
        local _height = 0
        if tr.Hit then
          _height = tr.HitPos.z
        else
          _height = _testHeight
        end
        CamDataMap.angles = Angle( 90, 90, 0 )
        CamDataMap.origin = Vector( 0, 0, _height - 16 )
        CamDataMap.x = 0
        CamDataMap.y = 0
        CamDataMap.w = ScrW()
        CamDataMap.h = ScrH()
        CamDataMap.ortho = true
        CamDataMap.ortholeft = map.sizeW
        CamDataMap.orthoright = map.sizeE
        CamDataMap.orthotop = map.sizeS
        CamDataMap.orthobottom = map.sizeN

        map_RT = GetRenderTarget( "YRP_Map", win.w, win.h, true )
        map_RT_mat = CreateMaterial( "YRP_Map", "UnlitGeneric", { ["$basetexture"] = "YRP_Map" } )
        local old_RT = render.GetRenderTarget()
        local old_w, old_h = ScrW(), ScrH()
        render.SetRenderTarget( map_RT )
          render.SetViewPort( win.x, win.y, win.w, win.h )

          render.Clear( 0, 0, 0, 0 )

            cam.Start2D()
              render.RenderView( CamDataMap )
            cam.End2D()

          render.SetViewPort( 0, 0, old_w, old_h )
        render.SetRenderTarget( old_RT )

        surface.SetDrawColor( 255, 255, 255, 255 )
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

        --You
        draw.RoundedBox( ctrW(8), plyPos.x-ctrW(8), plyPos.y-ctrW(8), ctrW(16), ctrW(16), Color(40,40,40))
        draw.RoundedBox( ctrW(8), plyPos.x-ctrW(6), plyPos.y-ctrW(6), ctrW(12), ctrW(12), Color(255,10,10))
        draw.SimpleText( lang.you, "sef", plyPos.x, plyPos.y-ctrW(24), Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        --Coords
        draw.SimpleText( math.Round( ply:GetPos().x, 0 ), "sef", ScrW()/2, ScrH() - ctrW( 25 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
        draw.SimpleText( ", " .. math.Round( ply:GetPos().y, 0 ), "sef", ScrW()/2, ScrH() - ctrW( 25 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

        draw.SimpleText( "[M] - " .. lang.map .. ": " .. _mapName, "HudBars", ctrW( 10 ), ctrW( 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

        if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then
          for k, plys in pairs( player.GetAll() ) do
            if plys != LocalPlayer() then
              --Other players
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

              --Draw
              draw.RoundedBox( ctrW(8), tmpPly.x-ctrW(8), tmpPly.y-ctrW(8), ctrW(16), ctrW(16), Color( 40, 40, 40, 200 ))
              draw.RoundedBox( ctrW(8), tmpPly.x-ctrW(6), tmpPly.y-ctrW(6), ctrW(12), ctrW(12), Color( 40, 40, 255, 200 ))
              draw.SimpleText( plys:Nick(), "sef", tmpPly.x, tmpPly.y-ctrW(24), Color(0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            end
          end
        end
      end
    end
  end
  function mapWindow:OnClose()
    map.open = false
  end
  function mapWindow:OnRemove()
    map.open = false
  end
end

net.Receive( "sendCoords", function()
  if net.ReadBool() then
    map = net.ReadTable()
    openSpawnMenu()
  else
    printGM( "note", "wait for server coords" )
  end
end)
