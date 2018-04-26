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
      inv.db_header = createD( "DPanel", inv.window, ctr(128*8) + ctr( 25 ), ctr( 50 ), ctr( 10 ), ScrH2() )
      function inv.db_header:Paint( pw, ph )
        local _str = string.upper( _stor.name )
        surfacePanel( self, pw, ph, _str )
      end
      if ply:HasAccess() then
        inv.db_remove = createD( "DButton", inv.db_header, ctr( 300 ), ctr( 50 ), ctr( 128*8 + 25 - 300 ), 0 )
        inv.db_remove:SetText( "" )
        inv.db_remove.uid = _stor.uniqueID
        function inv.db_remove:Paint( pw, ph )
          if self.uid != "" then
            surfaceButton( self, pw, ph, string.upper( lang_string( "remove" ) ), Color( 200, 0, 0 ) )
          end
        end
        function inv.db_remove:DoClick()
          if self.uid != "" then
            net.Start( "remove_storage" )
              net.WriteString( self.uid )
            net.SendToServer()
            inv.window:Close()
          end
        end
      end

      -- DPanelList
      inv.storages = createD( "DPanelList", inv.window, ctr( 128 * 8 + 25 ), ScrH2() - ctr( 10 + 50 ), ctr( 10 ), ScrH2() + ctr( 50 ) )
      inv.storages:EnableVerticalScrollbar( true )
      inv.storages:SetSpacing( 10 )
      function inv.storages:Paint( pw, ph )
        surfaceBox( 0, 0, pw, ph, Color( 0, 0, 0, 80 ) )
      end

      local _tmp2 = createD( "DPanel", inv.db_header, ctr( 128 * _stor.sizew ), ctr( 128 * _stor.sizeh ), 0, ctr( 50 ) )
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

    --[[ Backpacks ]]--
    local _bps = {}
    _bps.bpheader = createD( "DPanel", inv.window, ctr( 128*8 ) + ctr( 25 ), ctr( 50 ), ctr( 10 ) + ctr( 128*8 ) + ctr( 25 ) + ctr( 10 ), ctr( 50 + 10 ) )
    function _bps.bpheader:Paint( pw, ph )
      local _str = string.upper( lang_string( "backpack" ) )
      surfacePanel( self, pw, ph, _str )
    end

    _bps.bpstorage = createD( "DPanel", inv.window, ctr( 128*8 ) + ctr( 25 ), ctr( 128*4.5 ), ctr( 10 ) + ctr( 128*8 ) + ctr( 25 ) + ctr( 10 ), ctr( 50 + 10 + 50 ) )
    function _bps.bpstorage:Paint( pw, ph )
      -- Content
      surfaceBox( 0, 0, pw, ph, Color( 0, 0, 0, 80 ) )
    end

    _bps.backpack = createD( "DPanel", inv.window, ctr( 128 * 1 ), ctr( 128 * 1 ), ctr( 128*8 + 25 + 10 + 10 ), ScrH() - ctr( 128 + 10 ) )
    function _bps.backpack:Paint( pw, ph )
      surfaceBox( 0, 0, pw, ph, Color( 0, 0, 0, 80 ) )
      drawRBBR( 0, 0, 0, pw, ph, Color( 0, 0, 0 ), ctr( 4 ) )
    end
    net.Receive( "update_slot_backpack", function( len )
      local _s = net.ReadTable()
      AddStorage( _bps.backpack, _s.uniqueID, _s.sizew, _s.sizeh, "eqbp1" )
      net.Start( "getstorageitems" )
        net.WriteString( _s.uniqueID )
      net.SendToServer()

      net.Receive( "update_backpack", function( len )
        local _bo = net.ReadBool()
        if _bo then
          local _s_bp = net.ReadTable()
          AddStorage( _bps.bpstorage, _s_bp.uniqueID, _s_bp.sizew, _s_bp.sizeh )

          net.Start( "getstorageitems" )
            net.WriteString( _s_bp.uniqueID )
          net.SendToServer()
        else
          local _stor = _bps.bpstorage
          RemoveStorage( _stor, _stor.uid )
        end
      end)
      net.Start( "update_backpack" )
      net.SendToServer()
    end)
    net.Start( "update_slot_backpack" )
    net.SendToServer()

    _bps.bag1 = createD( "DPanel", inv.window, ctr( 128 * 1 ), ctr( 128 * 1 ), ctr( 128*8 + 25 + 10 + 10 + 138*1 ), ScrH() - ctr( 128 + 10 ) )
    _bps.bag2 = createD( "DPanel", inv.window, ctr( 128 * 1 ), ctr( 128 * 1 ), ctr( 128*8 + 25 + 10 + 10 + 138*2 ), ScrH() - ctr( 128 + 10 ) )
    _bps.bag3 = createD( "DPanel", inv.window, ctr( 128 * 1 ), ctr( 128 * 1 ), ctr( 128*8 + 25 + 10 + 10 + 138*3 ), ScrH() - ctr( 128 + 10 ) )
    _bps.bag4 = createD( "DPanel", inv.window, ctr( 128 * 1 ), ctr( 128 * 1 ), ctr( 128*8 + 25 + 10 + 10 + 138*4 ), ScrH() - ctr( 128 + 10 ) )

    --[[ EQUIPMENT ]]--
    local _eq = {}
    -- LEFT
    _eq.helm = createD( "DPanel", inv.window, ctr( 128 * 1 ), ctr( 128 * 1 ), ctr( 128*16 + 10 + 10 + 10 ), ctr( 50 + 10 ) )

    _eq.necklace = createD( "DPanel", inv.window, ctr( 128 * 1 ), ctr( 128 * 1 ), ctr( 128*16 + 10 + 10 + 10 ), ctr( 50 + 10 + 138*1 ) )

    _eq.shoulders = createD( "DPanel", inv.window, ctr( 128 * 1 ), ctr( 128 * 1 ), ctr( 128*16 + 10 + 10 + 10 ), ctr( 50 + 10 + 138*2 ) )

    _eq.cap = createD( "DPanel", inv.window, ctr( 128 * 1 ), ctr( 128 * 1 ), ctr( 128*16 + 10 + 10 + 10 ), ctr( 50 + 10 + 138*3 ) )

    _eq.chest = createD( "DPanel", inv.window, ctr( 128 * 1 ), ctr( 128 * 1 ), ctr( 128*16 + 10 + 10 + 10 ), ctr( 50 + 10 + 138*4 ) )

    _eq.shirt = createD( "DPanel", inv.window, ctr( 128 * 1 ), ctr( 128 * 1 ), ctr( 128*16 + 10 + 10 + 10 ), ctr( 50 + 10 + 138*5 ) )

    _eq.tabard = createD( "DPanel", inv.window, ctr( 128 * 1 ), ctr( 128 * 1 ), ctr( 128*16 + 10 + 10 + 10 ), ctr( 50 + 10 + 138*6 ) )

    _eq.bracelet = createD( "DPanel", inv.window, ctr( 128 * 1 ), ctr( 128 * 1 ), ctr( 128*16 + 10 + 10 + 10 ), ctr( 50 + 10 + 138*7 ) )

    -- RIGHT
    _eq.gloves = createD( "DPanel", inv.window, ctr( 128 * 1 ), ctr( 128 * 1 ), ctr( 128*16 + 10 + 10 + 10 + 1000 ), ctr( 50 + 10 ) )

    _eq.belt = createD( "DPanel", inv.window, ctr( 128 * 1 ), ctr( 128 * 1 ), ctr( 128*16 + 10 + 10 + 10 + 1000 ), ctr( 50 + 10 + 138*1 ) )

    _eq.pants = createD( "DPanel", inv.window, ctr( 128 * 1 ), ctr( 128 * 1 ), ctr( 128*16 + 10 + 10 + 10 + 1000 ), ctr( 50 + 10 + 138*2 ) )

    _eq.boots = createD( "DPanel", inv.window, ctr( 128 * 1 ), ctr( 128 * 1 ), ctr( 128*16 + 10 + 10 + 10 + 1000 ), ctr( 50 + 10 + 138*3 ) )

    _eq.ring1 = createD( "DPanel", inv.window, ctr( 128 * 1 ), ctr( 128 * 1 ), ctr( 128*16 + 10 + 10 + 10 + 1000 ), ctr( 50 + 10 + 138*4 ) )

    _eq.ring2 = createD( "DPanel", inv.window, ctr( 128 * 1 ), ctr( 128 * 1 ), ctr( 128*16 + 10 + 10 + 10 + 1000 ), ctr( 50 + 10 + 138*5 ) )

    _eq.trinket1 = createD( "DPanel", inv.window, ctr( 128 * 1 ), ctr( 128 * 1 ), ctr( 128*16 + 10 + 10 + 10 + 1000 ), ctr( 50 + 10 + 138*6 ) )

    _eq.trinket2 = createD( "DPanel", inv.window, ctr( 128 * 1 ), ctr( 128 * 1 ), ctr( 128*16 + 10 + 10 + 10 + 1000 ), ctr( 50 + 10 + 138*7 ) )

    -- Weapons
    _eq.pweapon1 = createD( "DPanel", inv.window, ctr( 128 * ITEM_MAXW ), ctr( 128 * ITEM_MAXH ), ctr( 128*16 + 10 + 10 + 10 ), ctr( 50 + 10 + 138*8 ) )

    _eq.pweapon2 = createD( "DPanel", inv.window, ctr( 128 * ITEM_MAXW ), ctr( 128 * ITEM_MAXH ), ctr( 128*16 + 10 + 10 + 10 ), ctr( 50 + 10 + 138*8 + 10 + 128*ITEM_MAXH ) )

    _eq.sweapon1 = createD( "DPanel", inv.window, ctr( 128 * 4 ), ctr( 128 * 2 ), ctr( 128*16 + 10 + 10 + 10 + 10 + 128*ITEM_MAXW ), ctr( 50 + 10 + 138*8 ) )

    _eq.sweapon2 = createD( "DPanel", inv.window, ctr( 128 * 4 ), ctr( 128 * 2 ), ctr( 128*16 + 10 + 10 + 10 + 10 + 128*ITEM_MAXW ), ctr( 50 + 10 + 138*8 + 10 + 128*2 ) )

    _eq.sgrenade = createD( "DPanel", inv.window, ctr( 128 * 2 ), ctr( 128 * 2 ), ctr( 128*16 + 10 + 10 + 10 + 10 + 128*ITEM_MAXW ), ctr( 50 + 10 + 138*8 + 10 + 128*2 + 10 + 128*2 ) )
  end
end)

function OpenInventory()
  if LocalPlayer():GetNWBool( "toggle_inventory", false ) then
    net.Start( "openStorage" )
    net.SendToServer()
  end
end
