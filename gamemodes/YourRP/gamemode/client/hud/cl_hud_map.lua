//cl_hud_map.lua

mapopen = 0

map = {}

function getCoords()
  net.Start( "askCoords" )
    net.WriteEntity( LocalPlayer() )
  net.SendToServer()
end
getCoords()

function openSpawnMenu()
  mapWindow = vgui.Create( "DFrame" )
  mapWindow:SetTitle("")
  mapWindow:SetPos( 0, 0 )
  mapWindow:SetSize( ScrW(), ScrH() )
  mapWindow:ShowCloseButton( false )
  mapWindow:SetDraggable( false )
  function mapWindow:Paint()
    if map != nil then
      draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 0, 0, 0, 254 ) )           //mapWindow of Map

      local win = {}
      win.x = ( ( ScrW() / 2 ) - calculateToResu( 1000 ) / map.facX )
      win.y = ( ( ScrH() / 2 ) - calculateToResu( 1000 ) / map.facY )
      win.w = calculateToResu(2000) / map.facX
      win.h = calculateToResu(2000) / map.facY
      draw.RoundedBox( 0, win.x - calculateToResu(2), win.y - calculateToResu(2), win.w + calculateToResu( 4 ), win.h + calculateToResu( 4 ), Color( 255, 255, 0, 240 ) )
      draw.RoundedBox( 0, win.x, win.y, win.w, win.h, Color( 0, 0, 0, 255 ) )

      draw.SimpleText( "[M] - " .. "lang.map" .. ": " .. game.GetMap(), "HudBars", win.x + win.w/2, win.y - calculateToResu( 40 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

      local CamData = {}
      CamData.angles = Angle( 90, 90, 0 )
      CamData.origin = Vector( 0, 0, map.sizeUp )
      CamData.x = win.x
      CamData.y = win.y
      CamData.w = win.w
      CamData.h = win.h
      CamData.ortho = true
      CamData.ortholeft = map.sizeW
      CamData.orthoright = map.sizeE
      CamData.orthotop = map.sizeS
      CamData.orthobottom = map.sizeN

      render.ClearStencil()
      render.SetStencilEnable(true)
        render.SetStencilWriteMask(255)
        render.SetStencilTestMask(255)
        render.SetStencilReferenceValue(15)
        render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
        render.SetStencilZFailOperation(STENCILOPERATION_REPLACE)
        render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)

          render.SuppressEngineLighting( true )
          render.SetColorModulation( 0, 1, 0 )
          render.SetBlend( 0.5 )

          render.RenderView(CamData)

          render.SuppressEngineLighting( false )
  				render.SetColorModulation( 1, 1, 1 )
  				render.SetBlend( 1 )

        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)

      render.SetStencilEnable(false)

      local ply = {}
      ply.xMax = map.sizeX
      ply.yMax = map.sizeY
      if map.sizeW < 0 then
        ply.xtmp = ( LocalPlayer():GetPos().x - map.sizeW )
      else
        ply.xtmp = ( LocalPlayer():GetPos().x + map.sizeE )
      end
      if map.sizeS < 0 then
        ply.ytmp = ( LocalPlayer():GetPos().y - map.sizeS )
      else
        ply.ytmp = ( LocalPlayer():GetPos().y + map.sizeN )
      end
      ply.x = win.x + win.w * ( ply.xtmp / ply.xMax )
      ply.y = win.y + win.h - win.h * ( ply.ytmp / ply.yMax )

      draw.RoundedBox( calculateToResu(8), ply.x-calculateToResu(8), ply.y-calculateToResu(8), calculateToResu(16), calculateToResu(16), Color(40,40,40))
      draw.RoundedBox( calculateToResu(8), ply.x-calculateToResu(6), ply.y-calculateToResu(6), calculateToResu(12), calculateToResu(12), Color(255,10,10))

      draw.SimpleText( "lang.you", "DermaDefault", ply.x, ply.y-calculateToResu(24), Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

      if LocalPlayer():Team() == 6 or LocalPlayer():Team() == 7 or LocalPlayer():Team() == 8 then
        local tmpTributes = team.GetPlayers( 5 )
        for k, ply in pairs( tmpTributes ) do
          local tmpPly = {}
          tmpPly.xMax = map.sizeX
          tmpPly.yMax = map.sizeY
          if map.sizeW < 0 then
            tmpPly.xtmp = ( ply:GetPos().x - map.sizeW )
          else
            tmpPly.xtmp = ( ply:GetPos().x + map.sizeE )
          end
          if map.sizeS < 0 then
            tmpPly.ytmp = ( ply:GetPos().y - map.sizeS )
          else
            tmpPly.ytmp = ( ply:GetPos().y + map.sizeN )
          end
          tmpPly.x = win.x + win.w * ( tmpPly.xtmp / tmpPly.xMax )
          tmpPly.y = win.y + win.h - win.h * ( tmpPly.ytmp / tmpPly.yMax )

          draw.RoundedBox( calculateToResu(8), tmpPly.x-calculateToResu(8), tmpPly.y-calculateToResu(8), calculateToResu(16), calculateToResu(16), Color( 40, 40, 40, 200 ))
          draw.RoundedBox( calculateToResu(8), tmpPly.x-calculateToResu(6), tmpPly.y-calculateToResu(6), calculateToResu(12), calculateToResu(12), Color( 40, 40, 255, 200 ))

          draw.SimpleText( k, "DermaDefault", tmpPly.x, tmpPly.y-calculateToResu(24), Color(0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
        draw.RoundedBox( 0, win.x - calculateToResu(2), win.y - calculateToResu(2), win.w + calculateToResu( 4 ), win.h + calculateToResu( 4 ), Color( 0, 0, 255, 40 ) )
      end
    end
  end
end

net.Receive( "sendCoords", function()
  map = net.ReadTable()
  if mapopen == 1 then
    openSpawnMenu()
  end
end)
