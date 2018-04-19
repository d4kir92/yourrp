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

    --[[ Surrounding ]]--
    inv.sur_tab = GetSurroundingStorage( ply )

    -- Header
    inv.sur_header = createD( "DPanel", inv.window, ctr(128*8) + ctr( 25 ), ctr( 50 ), ctr( 10 ), ctr( 50 + 10 ) )
    function inv.sur_header:Paint( pw, ph )
      local _str = string.upper( lang_string( string.lower( inv.sur_tab.name ) ) ) -- .. " [DEBUG] UID: " .. stor.uniqueID
      surfacePanel( self, pw, ph, _str )
    end

    -- DPanelList
    inv.sur_pl = createD( "DPanelList", inv.window, ctr( 128 * 8 + 25 ), ScrH2() - ctr( 50 + 10 + 50 + 10 ), ctr( 10 ), ctr( 50 + 10 + 50 ) )
    inv.sur_pl:EnableVerticalScrollbar( true )
    inv.sur_pl:SetSpacing( 10 )
    function inv.sur_pl:Paint( pw, ph )
      surfaceBox( 0, 0, pw, ph, Color( 0, 0, 0, 80 ) )
    end
    inv.sur_content = createD( "DPanel", nil, ctr( 128 * inv.sur_tab.sizew ), ctr( 128 * inv.sur_tab.sizeh ), 0, 0 )
    inv.sur_items = {}
    function inv.sur_content:Paint( pw, ph )
      surfaceBox( 0, 0, pw, ph, Color( 0, 0, 0, 80 ) )
      local _new = GetSurroundingItems( ply )
      if #_new != #inv.sur_items then
        UpdateSurroundingStorage( _new )
      end
    end
    inv.sur_pl:AddItem( inv.sur_content )
    function UpdateSurroundingStorage( tab )
      RemoveStorage( inv.sur_content, 0 )
      inv.sur_tab = GetSurroundingStorage( ply )
      AddStorage( inv.sur_content, inv.sur_tab.uniqueID, inv.sur_tab.sizew, inv.sur_tab.sizeh )
      inv.sur_pl:Rebuild()

      inv.sur_items = tab
      inv._stor = {}
      for y = 1, inv.sur_tab.sizeh do
        inv._stor[y] = {}
        for x = 1, inv.sur_tab.sizew do
          inv._stor[y][x] = {}
          inv._stor[y][x].value = ""
        end
      end
      for _, item in pairs( inv.sur_items ) do
        local _bool, _x, _y = FindPlace( inv._stor, item.sizew, item.sizeh )
        if _bool then
          for y = _y, _y+item.sizeh-1 do
            for x = _x, _x+item.sizew-1 do
              inv._stor[y][x].value = item.uniqueID
            end
          end
          item.posx = _x
          item.posy = _y
          AddItemToStorage( item )
        end
      end
      --PrintStorage( inv._stor )
    end
    UpdateSurroundingStorage( GetSurroundingItems( ply ) )

    --[[ Database Storages ]]--
    -- Header
    local _stor = _tabs[1]
    if _stor != nil then
      inv.sur_header = createD( "DPanel", inv.window, ctr(128*8) + ctr( 25 ), ctr( 50 ), ctr( 10 ), ScrH2() )
      function inv.sur_header:Paint( pw, ph )
        local _str = string.upper( _stor.name ) -- .. " [DEBUG] UID: " .. stor.uniqueID
        surfacePanel( self, pw, ph, _str )
      end

      -- DPanelList
      inv.storages = createD( "DPanelList", inv.window, ctr( 128 * 8 + 25 ), ScrH2() - ctr( 10 + 50 ), ctr( 10 ), ScrH2() + ctr( 50 ) )
      inv.storages:EnableVerticalScrollbar( true )
      inv.storages:SetSpacing( 10 )
      function inv.storages:Paint( pw, ph )
        surfaceBox( 0, 0, pw, ph, Color( 0, 0, 0, 80 ) )
      end

      local _tmp2 = createD( "DPanel", inv.sur_header, ctr( 128 * _stor.sizew ), ctr( 128 * _stor.sizeh ), 0, ctr( 50 ) )
      function _tmp2:Paint( pw, ph )
        -- Content
        surfaceBox( 0, 0, pw, ph, Color( 0, 0, 0, 80 ) )
      end
      AddStorage( _tmp2, _stor.uniqueID, _stor.sizew, _stor.sizeh )
      inv.storages:AddItem( _tmp2 )

      net.Start( "getstorageitems" )
        net.WriteString( _stor.uniqueID )
      net.SendToServer()
    else
      inv.sur_pl:SetSize( inv.sur_pl:GetWide(), ScrH() - ctr( 50 + 10 + 50 + 10 ) )
    end
  end
end)

function OpenInventory()
  if LocalPlayer():GetNWBool( "toggle_inventory", false ) then
    net.Start( "openStorage" )
    net.SendToServer()
  end
end
