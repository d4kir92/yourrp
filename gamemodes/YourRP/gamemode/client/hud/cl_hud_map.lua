//cl_hud_map.lua

map = {}
function getCoords()
  net.Start( "askCoords" )
    net.WriteEntity( LocalPlayer() )
  net.SendToServer()
end

function openSpawnMenu()
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
        win.x = ( ( ScrW() / 2 ) - calculateToResu( 1050 ) / map.facX )
        win.y = ( ( ScrH() / 2 ) - calculateToResu( 1050-25 ) / map.facY )
        win.w = calculateToResu(2100) / map.facX
        win.h = calculateToResu(2100) / map.facY
        draw.RoundedBox( 0, win.x - calculateToResu(2), win.y - calculateToResu(2), win.w + calculateToResu( 4 ), win.h + calculateToResu( 4 ), Color( 255, 255, 0, 240 ) )
        draw.RoundedBox( 0, win.x, win.y, win.w, win.h, Color( 0, 0, 0, 255 ) )

        local _mapName = string.Replace( string.upper( game.GetMap() ), "_", " " )
        draw.SimpleText( "[M] - Map: " .. _mapName, "HudBars", win.x + win.w/2, win.y - calculateToResu( 30 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        local tr = util.TraceLine( {
          start = ply:GetPos() + Vector( 0, 0, 1400 ),
          endpos = ply:GetPos() + Vector( 0, 0, 4000 ),
          filter = _filterENTS
        } )

        local CamDataMap = {}
        CamDataMap.angles = Angle( 90, 90, 0 )
        CamDataMap.origin = Vector( 0, 0, tr.HitPos.z )
        CamDataMap.x = win.x
        CamDataMap.y = win.y
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
          CamDataMap.x = win.x
          CamDataMap.y = win.y
          CamDataMap.w = win.w
          CamDataMap.h = win.h
          CamDataMap.ortho = true
          CamDataMap.ortholeft = map.sizeW
          CamDataMap.orthoright = map.sizeE
          CamDataMap.orthotop = map.sizeS
          CamDataMap.orthobottom = map.sizeN
        end

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

            render.RenderView( CamDataMap )

            render.SuppressEngineLighting( false )
    				render.SetColorModulation( 1, 1, 1 )
    				render.SetBlend( 1 )

            render.SuppressEngineLighting( true )

          render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)

        render.SetStencilEnable(false)

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
        draw.RoundedBox( calculateToResu(8), plyPos.x-calculateToResu(8), plyPos.y-calculateToResu(8), calculateToResu(16), calculateToResu(16), Color(40,40,40))
        draw.RoundedBox( calculateToResu(8), plyPos.x-calculateToResu(6), plyPos.y-calculateToResu(6), calculateToResu(12), calculateToResu(12), Color(255,10,10))
        draw.SimpleText( "YOU", "DermaDefault", plyPos.x, plyPos.y-calculateToResu(24), Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        //Coords
        draw.SimpleText( math.Round( ply:GetPos().x, 0 ), "DermaDefault", ScrW()/2, ScrH() - calculateToResu( 25 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
        draw.SimpleText( ", " .. math.Round( ply:GetPos().y, 0 ), "DermaDefault", ScrW()/2, ScrH() - calculateToResu( 25 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

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
              draw.RoundedBox( calculateToResu(8), tmpPly.x-calculateToResu(8), tmpPly.y-calculateToResu(8), calculateToResu(16), calculateToResu(16), Color( 40, 40, 40, 200 ))
              draw.RoundedBox( calculateToResu(8), tmpPly.x-calculateToResu(6), tmpPly.y-calculateToResu(6), calculateToResu(12), calculateToResu(12), Color( 40, 40, 255, 200 ))
              draw.SimpleText( plys:Nick(), "DermaDefault", tmpPly.x, tmpPly.y-calculateToResu(24), Color(0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            end
          end
        end
      end
    end
  end
  function mapWindow:OnClose()
    _menuIsOpen = 0
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
