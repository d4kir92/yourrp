--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local _bm = {}

function toggleBuyMenu()
  if isNoMenuOpen() then
    openBuyMenu()
  else
    closeBuyMenu()
  end
end

function closeBuyMenu()
  if _bm.window != nil then
    closeMenu()
    _bm.window:Remove()
    _bm.window = nil
  end
end

function createShopItem( item )
  local _w = 800
  local _h = 400
  local _i = createD( "DPanel", nil, ctrb( _w ), ctrb( _h ), 0, 0 )
  function _i:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
  end
  _i.item = item
  if item.WorldModel != nil then
    if item.WorldModel == "" then
      --
    else
      _i.model = createD( "DModelPanel", _i, ctrb( _w ), ctrb( _h ), ctrb( 0 ), ctrb( 0 ) )
      _i.model:SetModel( item.WorldModel )
      if _i.model.Entity != NULL then
        local _height = 0
        local _range = 0
        if item.type == "weapons" then
          _height = 10
          _range = 40
        elseif item.type == "vehicles" then
          _height = 50
          _range = 200
        elseif item.type == "entities" then
          height = 30
          _range = 30
        end
        _i.model:SetLookAt( Vector( 0, 0, _height ) )
        _i.model:SetCamPos( Vector( 0, 0, _height ) - Vector( -_range, 0, 0 ) )
      end
    end
  end

  if item.name != nil then
    _i.name = createD( "DPanel", _i, ctrb( _w ), ctrb( 50 ), 0, 0 )
    _i.name.name = db_out_str( item.name )
    if item.type == "licenses" then
      _i.name.name = lang_string( "license" ) .. ": " .. _i.name.name
    end
    function _i.name:Paint( pw, ph )
      surfaceText( self.name, "roleInfoHeader", pw/2, ph/2, Color( 255, 255, 255 ), 1, 1 )
    end
  end
  if item.price != nil then
    _i.price = createD( "DPanel", _i, ctrb( _w ), ctrb( 50 ), 0, ctrb( 300 ) )
    function _i.price:Paint( pw, ph )
      surfaceText( formatMoney( LocalPlayer(), item.price ), "roleInfoHeader", pw/2, ph/2, Color( 255, 255, 255 ), 1, 1 )
    end
  end
  if tonumber( item.permanent ) == 1 then
    _i.price = createD( "DPanel", _i, ctrb( _w ), ctrb( 50 ), 0, ctrb( 50 ) )
    function _i.price:Paint( pw, ph )
      surfaceText( "[" .. lang_string( "permanent" ) .. "]", "roleInfoHeader", pw/2, ph/2, Color( 255, 255, 255 ), 1, 1 )
    end
  end

  if LocalPlayer():HasLicense( item.licenseID ) then
    _i.buy = createD( "DButton", _i, ctrb( _w/2 ), ctrb( 50 ), ctrb( _w/2 ), ctrb( 350 ) )
    _i.buy:SetText( "" )
    _i.buy.item = item
    function _i.buy:Paint( pw, ph )
      local _color = Color( 0, 255, 0 )
      if !LocalPlayer():canAfford( item.price ) then
        _color = Color( 255, 0, 0 )
      end
      if self:IsHovered() then
        _color = Color( 255, 255, 0 )
      end
      draw.RoundedBox( 0, 0, 0, pw, ph, _color )
      surfaceText( lang_string( "buy" ), "roleInfoHeader", pw/2, ph/2, Color( 255, 255, 255 ), 1, 1 )
    end
    function _i.buy:DoClick()
      net.Start( "item_buy" )
        net.WriteTable( self.item )
      net.SendToServer()
      closeBuyMenu()
    end
  else
    _i.require = createD( "DPanel", _i, ctrb( _w ), ctrb( 50 ), ctrb( 0 ), ctrb( 350 ) )
    function _i.require:Paint( pw, ph )
      local _color = Color( 255, 0, 0 )
      draw.RoundedBox( 0, 0, 0, pw, ph, _color )
      surfaceText( lang_string( "requirespre" ) .. " " .. lang_string( "license" ) .. " " .. lang_string( "requirespos" ), "roleInfoHeader", pw/2, ph/2, Color( 255, 255, 255 ), 1, 1 )
    end
  end
  return _i
end

function createStorageItem( item, duid )
  local _w = 800
  local _h = 400
  local _i = createD( "DPanel", nil, ctrb( _w ), ctrb( _h ), 0, 0 )
  function _i:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
  end
  _i.item = item
  if item.WorldModel != nil then
    if item.WorldModel == "" then
      --
    else
      _i.model = createD( "DModelPanel", _i, ctrb( _w ), ctrb( _h ), ctrb( 0 ), ctrb( 0 ) )
      _i.model:SetModel( item.WorldModel )
      if _i.model.Entity != NULL then
        local _height = 0
        local _range = 0
        if item.type == "weapons" then
          _height = 10
          _range = 40
        elseif item.type == "vehicles" then
          _height = 50
          _range = 200
        elseif item.type == "entities" then
          height = 30
          _range = 30
        end
        _i.model:SetLookAt( Vector( 0, 0, _height ) )
        _i.model:SetCamPos( Vector( 0, 0, _height ) - Vector( -_range, 0, 0 ) )
      end
    end
  end

  if item.name != nil then
    _i.name = createD( "DPanel", _i, ctrb( _w ), ctrb( 50 ), 0, 0 )
    _i.name.name = db_out_str( item.name )
    function _i.name:Paint( pw, ph )
      surfaceText( self.name, "roleInfoHeader", pw/2, ph/2, Color( 255, 255, 255 ), 1, 1 )
    end
  end

  _i.spawn = createD( "DButton", _i, ctrb( _w ), ctrb( 50 ), ctrb( 0 ), ctrb( 350 ) )
  _i.spawn:SetText( "" )
  _i.spawn.item = item
  _i.spawn.action = 0
  _i.spawn.name = "tospawn"
  if IsEntityAlive( item.uniqueID ) then
    _i.spawn.action = 1
    _i.spawn.name = "tostore"
  end
  function _i.spawn:Paint( pw, ph )
    local _color = Color( 0, 255, 0 )
    if !LocalPlayer():canAfford( item.price ) then
      _color = Color( 255, 0, 0 )
    end
    if self:IsHovered() then
      _color = Color( 255, 255, 0 )
    end
    draw.RoundedBox( 0, 0, 0, pw, ph, _color )
    surfaceText( lang_string( self.name ), "roleInfoHeader", pw/2, ph/2, Color( 255, 255, 255 ), 1, 1 )
  end
  function _i.spawn:DoClick()
    if self.action == 0 then
      net.Start( "item_spawn" )
        net.WriteTable( self.item )
        net.WriteString( duid )
      net.SendToServer()
    elseif self.action == 1 then
      net.Start( "item_despawn" )
        net.WriteTable( self.item )
      net.SendToServer()
    end
    closeBuyMenu()
  end

  return _i
end

local _mat_set = Material( "vgui/yrp/light_settings.png" )

net.Receive( "shop_get_tabs", function( len )
  openMenu()

  local _dealer = net.ReadTable()
  local _dealer_uid = _dealer.uniqueID
  local _tabs = net.ReadTable()

  _bm.window = createD( "DFrame", nil, BScrW(), ScrH(), 0, 0 )
  _bm.window.dUID = _dealer_uid
  _bm.window:SetTitle( "" )
  _bm.window:Center()
  _bm.window:ShowCloseButton( false )
  _bm.window:SetDraggable( false )
  function _bm.window:OnClose()
    closeMenu()
  end
  function _bm.window:OnRemove()
    closeMenu()
  end
  function _bm.window:Paint( pw, ph )
    surfaceText( _dealer.name, "roleInfoHeader", ctrb( 25 ), ctrb( 25 ), Color( 255, 255, 255 ), 0, 1 )
  end

  _bm.close = createD( "DButton", _bm.window, ctrb( 50), ctrb( 50 ), _bm.window:GetWide()-ctrb( 50+10 ), ctrb( 10 ) )
  _bm.close:SetText( "" )
  function _bm.close:Paint( pw, ph )
    self.color = Color( 255, 255, 255 )
    if self:IsHovered() then
      self.color = Color( 255, 255, 0 )
    end
    draw.RoundedBox( 0, 0, 0, pw, ph, self.color )
    surfaceText( "X", "roleInfoHeader", pw/2, ph/2, Color( 255, 255, 255 ), 1, 1 )
  end
  function _bm.close:DoClick()
    if _bm.window != nil then
      _bm.window:Close()
    end
  end

  --[[ Settings ]]--
  if LocalPlayer():HasAccess() then
    _bm.settings = createD( "DButton", _bm.window, ctrb( 50 ), ctrb( 50 ), _bm.window:GetWide()-ctrb( 50+10+50+10 ), ctrb( 10 ) )
    _bm.settings:SetText( "" )
    function _bm.settings:Paint( pw, ph )
      local _br = 4
      self.color = Color( 255, 255, 255 )
      if self:IsHovered() then
        self.color = Color( 255, 255, 0 )
      end
      draw.RoundedBox( 0, 0, 0, pw, ph, self.color )
      surface.SetDrawColor( 255, 255, 255, 255 )
      surface.SetMaterial( _mat_set	)
      surface.DrawTexturedRect( ctr(_br), ctr(_br), pw-ctr(2*_br), ph-ctr(2*_br) )
    end
    function _bm.settings:DoClick()
      net.Receive( "dealer_settings", function( len )
        local _set = createD( "DFrame", nil, ctrb( 600 ), ctrb( 60+110+110+110 ), 0, 0 )
        _set:SetTitle( "" )
        _set:Center()
        _set:MakePopup()
        function _set:Paint( pw, ph )
          if !pa(_bm.window) then
            self:Remove()
          end
          draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 200 ) )
        end

        _set.name = createD( "DYRPPanelPlus", _set, ctrb( 580 ), ctrb( 100 ), ctrb( 10 ), ctrb( 60 ) )
        _set.name:INITPanel( "DTextEntry" )
        _set.name:SetHeader( lang_string( "name" ) )
        _set.name:SetText( _dealer.name )
        function _set.name.plus:OnChange()
          _dealer.name = self:GetText()
          net.Start( "dealer_edit_name" )
            net.WriteString( _dealer.uniqueID )
            net.WriteString( _dealer.name )
          net.SendToServer()
        end

        _set.name = createD( "DYRPPanelPlus", _set, ctrb( 580 ), ctrb( 100 ), ctrb( 10 ), ctrb( 170 ) )
        _set.name:INITPanel( "DButton" )
        _set.name:SetHeader( lang_string( "appearance" ) )
        _set.name.plus:SetText( "" )
        function _set.name.plus:Paint( pw, ph )
          self.color = Color( 200, 200, 200 )
          if self:IsHovered() then
            self.color = Color( 200, 200, 0 )
          end
          draw.RoundedBox( 0, 0, 0, pw, ph, self.color )
          surfaceText( lang_string( "change" ), "roleInfoHeader", pw/2, ph/2, Color( 255, 255, 255 ), 1, 1 )
        end
        function _set.name.plus:DoClick()
          local playermodels = player_manager.AllValidModels()
          local tmpTable = {}
          local count = 0
          for k, v in pairs( playermodels ) do
            count = count + 1
            tmpTable[count] = {}
            tmpTable[count].WorldModel = v
            tmpTable[count].ClassName = v
            tmpTable[count].PrintName = player_manager.TranslateToPlayerModelName( v )
          end
          _globalWorking = _dealer.WorldModel
          hook.Add( "close_dealer_worldmodel", "close_dealer_worldmodel_hook", function()
            _dealer.WorldModel = LocalPlayer():GetNWString( "WorldModel" )

            net.Start( "dealer_edit_worldmodel" )
              net.WriteString( _dealer.uniqueID )
              net.WriteString( _dealer.WorldModel )
            net.SendToServer()
          end)
          openSingleSelector( tmpTable, "close_dealer_worldmodel" )
        end

        local _storages = net.ReadTable()
        _set.storagepoint = createD( "DYRPPanelPlus", _set, ctrb( 580 ), ctrb( 100 ), ctrb( 10 ), ctrb( 280 ) )
        _set.storagepoint:INITPanel( "DComboBox" )
        _set.storagepoint:SetHeader( lang_string( "storagepoint" ) )
        for i, storage in pairs( _storages ) do
          local _sp = false
          if tonumber( storage.uniqueID ) == tonumber( _dealer.storagepoints ) then
            _sp = true
          end
          _set.storagepoint.plus:AddChoice( storage.name, storage.uniqueID, _sp )
        end
        function _set.storagepoint.plus:OnSelect( index, value, data )
          net.Start( "dealer_edit_storagepoints" )
            net.WriteString( _dealer.uniqueID )
            net.WriteString( data )
          net.SendToServer()
        end
      end)

      net.Start( "dealer_settings" )
      net.SendToServer()
    end
  end

  --[[ Shop ]]--
  _bm.shop = createD( "DPanelList", _bm.window, BScrW() - ctrb( 10+10 ), ScrH() - ctrb( 50 + 10 + 60 + 10 ), ctrb( 10 ), ctrb( 50 + 10 + 60 ) )
  _bm.shop:EnableVerticalScrollbar( false )
  _bm.shop:SetSpacing( 10 )
  _bm.shop:SetNoSizing( false )
  function _bm.shop:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 100, 100, 100, 240 ) )
  end

  _bm.tabs = createD( "DYRPTabs", _bm.window, BScrW() - ctrb( 10+10 ), ctrb( 60 ), ctrb( 10 ), ctrb( 50 + 10 ) )
  _bm.tabs:SetSelectedColor( Color( 100, 100, 100, 240 ) )
  _bm.tabs:SetUnselectedColor( Color( 0, 0, 0, 240 ) )

  for i, tab in pairs( _tabs ) do
    local _tab = _bm.tabs:AddTab( db_out_str( tab.name ), tab.uniqueID )
    function _tab:GetCategories()
      net.Receive( "shop_get_categories", function( len )
        local _uid = net.ReadString()
        local _cats = net.ReadTable()

        _bm.shop:Clear()

        for j, cat in pairs( _cats ) do
          local _cat = createD( "DYRPCollapsibleCategory", _bm.shop, _bm.shop:GetWide(), ctrb( 100 ), 0, 0 )
          _cat.uid = cat.uniqueID
          _cat:SetHeaderHeight( ctrb( 100 ) )
          _cat:SetHeader( db_out_str( cat.name ) )
          _cat:SetSpacing( 30 )
          _cat.color = Color( 100, 100, 255 )
          _cat.color2 = Color( 50, 50, 255 )
          function _cat:DoClick()
            if self:IsOpen() then
              net.Receive( "shop_get_items", function( len )
                local _items = net.ReadTable()
                for k, item in pairs( _items ) do
                  local _item = createShopItem( item )
                  self:Add( _item )
                end
              end)
              net.Start( "shop_get_items" )
                net.WriteString( self.uid )
              net.SendToServer()
            else
              self:ClearContent()
            end
          end

          _bm.shop:AddItem( _cat )
          _bm.shop:Rebuild()
        end
        if LocalPlayer():HasAccess() then
          local _remove = createD( "DButton", _cat, ctr( 400 ), ctr( 100 ), 0, 0 )
          _remove:SetText( "" )
          _remove.uid = _uid
          function _remove:Paint( pw, ph )
            draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 0, 0 ) )
            surfaceText( lang_string( "remove" ) .. " [" .. lang_string( "tab" ) .. "] => " .. db_out_str( tab.name ), "roleInfoHeader", pw/2, ph/2, Color( 255, 255, 255 ), 1, 1 )
          end
          function _remove:DoClick()
            net.Start( "dealer_rem_tab" )
              net.WriteString( _dealer_uid )
              net.WriteString( self.uid )
            net.SendToServer()
            _bm.window:Close()
          end
          _bm.shop:AddItem( _remove )
          _bm.shop:Rebuild()
        end
      end)
      net.Start( "shop_get_categories" )
        net.WriteString( _tab.tbl )
      net.SendToServer()
    end
    function _tab:Click()
      _tab.GetCategories()
    end

    local _tab2 = _bm.tabs:AddTab( lang_string( "mystorage" ) .. ": " .. db_out_str( tab.name ), tab.uniqueID )
    function _tab2:GetCategories()
      net.Receive( "shop_get_categories", function( len )
        local _uid = net.ReadString()
        local _cats = net.ReadTable()

        _bm.shop:Clear()

        for j, cat in pairs( _cats ) do
          local _cat = createD( "DYRPCollapsibleCategory", _bm.shop, _bm.shop:GetWide(), ctrb( 100 ), 0, 0 )
          _cat.uid = cat.uniqueID
          _cat:SetHeaderHeight( ctrb( 100 ) )
          _cat:SetHeader( db_out_str( cat.name ) )
          _cat:SetSpacing( 30 )
          _cat.color = Color( 100, 100, 255 )
          _cat.color2 = Color( 50, 50, 255 )
          function _cat:DoClick()
            if self:IsOpen() then
              net.Receive( "shop_get_items_storage", function( len )
                local _items = net.ReadTable()
                for k, item in pairs( _items ) do
                  local _item = createStorageItem( item, _dealer_uid )
                  self:Add( _item )
                end
              end)
              net.Start( "shop_get_items_storage" )
                net.WriteString( self.uid )
              net.SendToServer()
            else
              self:ClearContent()
            end
          end

          _bm.shop:AddItem( _cat )
          _bm.shop:Rebuild()
        end
      end)
      net.Start( "shop_get_categories" )
        net.WriteString( _tab.tbl )
      net.SendToServer()
    end
    function _tab2:Click()
      _tab2.GetCategories()
    end

    if i == 1 then
      _tab.GetCategories()
    end
  end

  if LocalPlayer():HasAccess() then
    _bm.addtab = createD( "DButton", _bm.tabs, ctr( 80 ), ctr( 60 ), 0, 0 )
    _bm.addtab:SetText( "" )
    _bm.addtab:SetPos( 0, 0 )
    function _bm.addtab:Paint( pw, ph )
      local _posx = self:GetPos()
      local _x = math.Round( _bm.tabs.tabx, 0 ) + ctr( 4 )
      if _x != _posx then
        self:SetPos( _x, 0 )
      end

      local _color = Color( 0, 255, 0, 255 )
      if self:IsHovered() then
        _color = Color( 255, 255, 0, 255 )
      end
      draw.RoundedBoxEx( ph/2, 0, 0, pw, ph, _color, true, true )
      surfaceText( "+", "roleInfoHeader", pw/2, ph/2, Color( 255, 255, 255 ), 1, 1 )
    end
    function _bm.addtab:DoClick()
      local _tmp = createD( "DFrame", nil, ctr( 420 ), ctr( 50+10+100+10+50+10 ), 0, 0 )
      function _tmp:Paint( pw, ph )
        if !pa(_bm.tabs) then
          self:Remove()
        end
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 200 ) )
      end
      _tmp:SetTitle( "" )
      _tmp:Center()
      _tmp:MakePopup()

      _tmp.tabs = createD( "DYRPPanelPlus", _tmp, ctr( 400 ), ctr( 100 ), ctr( 10 ), ctr( 50 + 10 ) )
      _tmp.tabs:INITPanel( "DComboBox" )
      _tmp.tabs:SetHeader( lang_string( "tabs" ) )

      net.Receive( "shop_get_all_tabs", function( len )
        local _tabs = net.ReadTable()
        for i, tab in pairs( _tabs ) do
          _tmp.tabs.plus:AddChoice( db_out_str( tab.name ), tab.uniqueID )
        end
      end)

      net.Start( "shop_get_all_tabs" )
      net.SendToServer()

      _tmp.addtab = createD( "DButton", _tmp, ctr( 400 ), ctr( 50 ), ctr( 10 ), ctr( 50 + 10 + 100 + 10 ) )
      _tmp.addtab:SetText( "" )
      function _tmp.addtab:Paint( pw, ph )
        local _color = Color( 255, 255, 255, 255 )
        if self:IsHovered() then
          _color = Color( 255, 255, 0, 255 )
        end
        draw.RoundedBox( 0, 0, 0, pw, ph, _color )
        surfaceText( lang_string( "add" ), "roleInfoHeader", pw/2, ph/2, Color( 255, 255, 255 ), 1, 1 )
      end
      function _tmp.addtab:DoClick()
        local _name, _uid = _tmp.tabs.plus:GetSelected()
        if _uid != nil then
          net.Start( "dealer_add_tab" )
            net.WriteString( _bm.window.dUID )
            net.WriteString( _uid )
          net.SendToServer()
        end
        self:GetParent():Close()
        _bm.window:Close()
      end
    end
  end

  _bm.window:MakePopup()
end)

function openBuyMenu()
  openMenu()
  net.Start( "shop_get_tabs" )
    net.WriteString( "1" )
  net.SendToServer()
end
