--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local inv = {}

function ToggleInventory()
  if isNoMenuOpen() then
    OpenInventory()
  else
    CloseInventory()
  end
end

function CloseInventory()
  if inv.window != nil then
    net.Start( "yrp_close_storages" )
    net.SendToServer()

    closeMenu()
    inv.window:Remove()
    inv.window = nil
  end
end

net.Receive( "openStorage", function( len )
  local ply = LocalPlayer()
  local _tabs = net.ReadTable()

  if inv.window == nil then
    inv.window = createD( "DFrame", nil, BScrW(), ScrH(), 0, 0 )
    inv.window:SetTitle( "" )
    inv.window:ShowCloseButton( true )
    inv.window:SetDraggable( false )
    inv.window:MakePopup()
    function inv.window:Paint( pw, ph )
      surfaceWindow( self, pw, ph, lang_string( "inventory" ) )
    end
    function inv.window:OnClose()
      CloseInventory()
    end

    --[[ Storage ScrollPanel ]]--
    inv.storages = createD( "DPanelList", inv.window, (BScrW()/2) - ctr( 20 ), ScrH() - ctr( 50 + 10 + 10 ), ctr( 10 ), ctr( 50 + 10 ) )
    inv.storages:EnableVerticalScrollbar( true )
    inv.storages:SetSpacing( 10 )
    function inv.storages:Paint( pw, ph )
      surfaceBox( 0, 0, pw, ph, Color( 0, 0, 0, 40 ) )
    end

    --[[ Surrounding Storage ]]--
    table.insert( _tabs, 0, GetSurroundingStorage( ply ) )

    --[[ Database Storages ]]--
    for i, stor in pairs( _tabs ) do
      --[[ Add Storage X ]]--
      local _tmp = createD( "DPanel", inv.storages, (BScrW()/2) - ctr( 20 ), ctr( 50 ) + ctr( 128 * stor.sizeh ), 0, 0 )
      function _tmp:Paint( pw, ph )
        --[[ Header ]]--
        surfaceBox( 0, 0, pw, ctr( 50 ), Color( 255, 255, 255, 250 ) )
        local _str = string.upper( lang_string( string.lower( stor.name ) ) ) -- .. " [DEBUG] UID: " .. stor.uniqueID
        surfaceText( _str, "SettingsHeader", ctr( 10 ), ctr( 50/2 ), Color( 255, 255, 255, 255 ), 0, 1 )
      end
      local _tmp2 = createD( "DPanel", _tmp, ctr( 128 * stor.sizew ), ctr( 128 * stor.sizeh ), 0, ctr( 50 ) )
      function _tmp2:Paint( pw, ph )
        --[[ Content]]--
        surfaceBox( 0, 0, pw, ph, Color( 0, 0, 255, 40 ) )
      end
      AddStorage( _tmp2, stor.uniqueID, stor.sizew, stor.sizeh )
      inv.storages:AddItem( _tmp )
    end

    --[[ Database Storages Items ]]--
    for i, stor in pairs( _tabs ) do
      if stor.uniqueID == 0 then

        local _stor = {}
        for y = 1, stor.sizeh do
          _stor[y] = {}
          for x = 1, stor.sizew do
            _stor[y][x] = {}
            _stor[y][x].value = ""
          end
        end

        local _items = GetSurroundingItems( ply )
        for _, item in pairs( _items ) do
          local _bool, _x, _y = FindPlace( _stor, item.sizew, item.sizeh )
          if _bool then
            for y = _y, _y+item.sizeh-1 do
              for x = _x, _x+item.sizew-1 do
                _stor[y][x].value = item.uniqueID
              end
            end
            item.posx = _x
            item.posy = _y
            AddItemToStorage( item )
          end
        end
        --IsEnoughSpace( stor, w, h, x, y )
      else
        net.Start( "getstorageitems" )
          net.WriteString( stor.uniqueID )
        net.SendToServer()
      end
    end
  end
end)

function OpenInventory()
  net.Start( "openStorage" )
  net.SendToServer()
end
