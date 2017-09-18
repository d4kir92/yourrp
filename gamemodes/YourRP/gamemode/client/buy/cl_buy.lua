--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local winW = 2160
local winH = winW

local itemW = 400
local panH = itemW+60+60+10

local swepList = {}

function addNewItem( parent, item, tab )
  local ply = LocalPlayer()

  itemW = 400
  panH = itemW+60+60+10

  local _itemPanel = createVGUI( "DPanel", parent, itemW, panH, swepList.x, swepList.y )
  _itemPanel.uniqueID = item.uniqueID
  function _itemPanel:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 200 ) )
    draw.SimpleText( item.PrintName, "weaponT", pw/2, ctrW( itemW - 15 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end

  local _itemModelPanel = {}
  if item.WorldModel != "" then
    _itemModelPanel = createVGUI( "SpawnIcon", _itemPanel, itemW-40, itemW-40, 20, 0 )
    _itemModelPanel:SetModel( item.WorldModel )
  end
  if item.PrintName != nil then
    _itemPanel.PrintName = item.PrintName
  end
  if item.ClassName != nil then
    _itemPanel.ClassName = item.ClassName
  else
    _itemPanel.ClassName = ""
  end
  --_itemModelPanel:SetLookAt( Vector( 0, 0, 0 ) )
  --_itemModelPanel:SetCamPos( Vector( 0, 0, 0 ) + Vector( -20, 0, 15 ) )

  local _pricePanel = createVGUI( "DPanel", _itemPanel, itemW-2*8, 50, 8, itemW+10 )
  function _pricePanel:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
    draw.SimpleText( ply:GetNWString( "moneyPre" ) .. item.price .. ply:GetNWString( "moneyPost" ), "weaponT", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end

  local _itemAmountNumberWang = createVGUI( "DNumberWang", _itemPanel, (itemW/3)-8, 50, 8, itemW+10+50+10 )
  _itemAmountNumberWang:SetValue( 1 )

  local _itemBuyButton = createVGUI( "DButton", _itemPanel, 2*(itemW/3)-8, 50, itemW/3, itemW+10+50+10 )
  _itemBuyButton:SetText( "" )
  function _itemBuyButton:Paint( pw, ph )
    if _itemBuyButton:IsHovered() then
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 255 ) )
    else
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255 ) )
    end
    draw.SimpleText( "x " .. lang.buy, "weaponT", 5, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
  end
  function _itemBuyButton:DoClick()
    net.Start( "buyItem" )
      net.WriteString( tab )
      net.WriteString( _itemPanel.uniqueID )
    net.SendToServer()
    --_buyWindow:Close()
  end

  if ply:IsAdmin() or ply:IsSuperAdmin() then
    panH = itemW+10+50+10+50+10+50+10
    _itemPanel:SetSize( ctrW( itemW ), ctrW( panH ) )

    local _removeButton = createVGUI( "DButton", _itemPanel, itemW - 2*8, 50, 8, itemW+10+50+10+50+10 )
    _removeButton:SetText( "" )
    function _removeButton:Paint( pw, ph )
      if _removeButton:IsHovered() then
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 255 ) )
      else
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 0, 0, 255 ) )
      end
      draw.SimpleText( lang.removeitem, "weaponT", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    function _removeButton:DoClick()
      local frame = createVGUI( "DFrame", nil, 630, 120, 0, 0 )
      frame:Center()
      frame:SetTitle( lang.areyousure )
      function frame:Paint( pw, ph )
        draw.RoundedBox( 0, 0, 0, pw, ph, yrp.colors.background2 )
      end

      frame:MakePopup()

      local yes = createVGUI( "DButton", frame, 300, 50, 10, 60 )
      yes:SetText( lang.yes )
      function yes:DoClick()
        net.Start( "removeBuyItem" )
          net.WriteString( _itemPanel.uniqueID )
        net.SendToServer()
        _itemPanel:Remove()
        frame:Close()
      end

      local no = createVGUI( "DButton", frame, 300, 50, 10 + 300 + 10, 60 )
      no:SetText( lang.no )
      function no:DoClick()
        frame:Close()
      end
    end
  end

  swepList.x = swepList.x + itemW + 8
  if ctrW( swepList.x ) > ctrW( 1888 ) then
    swepList.y = swepList.y + ctrW( 10 ) + panH
    swepList.x = 0
  end

  return _itemPanel
end

net.Receive( "getBuyList", function( len )
  if _buyScrollPanel != nil then
    _buyScrollPanel:Remove()
  end
  local ply = LocalPlayer()
  local _tab = net.ReadString()
  local _list = net.ReadTable()

  local _parent = _tabWeapon
  if _tab == "weapon" then
    _parent = _tabWeapon
  elseif _tab == "entities" then
    _parent = _tabEntities
  elseif _tab == "vehicles" then
    _parent = _tabVehicles
  end

  swepList.x = 0
  swepList.y = 0

  local _buyScrollPanel = createVGUI( "DScrollPanel", _parent, winW-60, winH-60-50-30, swepList.x, swepList.y )
  _buyScrollPanel:Clear()

  for k, item in SortedPairsByMemberValue( _list, "PrintName", false ) do
    if item.PrintName != nil and !string.find( string.lower( item.PrintName ), "npc") and !string.find( string.lower( item.PrintName ), "base") and !string.find( string.lower( item.PrintName ), "ttt") then
      addNewItem( _buyScrollPanel, item, _tab )
    end
  end
  if ply:IsAdmin() or ply:IsSuperAdmin() then
    _addItemButton = createVGUI( "DButton", _buyScrollPanel, itemW, panH, swepList.x, swepList.y )
    _addItemButton:SetText( "" )
    function _addItemButton:Paint( pw, ph )
      if _addItemButton:IsHovered() then
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 255 ) )
      else
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 255, 0, 255 ) )
      end
      draw.RoundedBox( 0, pw/2 - ctrW( 16 ), ph/2 - ctrW( 128-32 ), ctrW( 32 ), ctrW( 256-64 ), Color( 0, 0, 0, 255 ) )
      draw.RoundedBox( 0, pw/2 - ctrW( 128-32 ), ph/2 - ctrW( 16 ), ctrW( 256-64 ), ctrW( 32 ), Color( 0, 0, 0, 255 ) )
    end
    function _addItemButton:DoClick()
      local addSwep = {}
      addSwep.PrintName = lang.noitemselected .. "!"
      local _windowAddItem = createVGUI( "DFrame", nil, 512, 50+500+10+50+10+50+10+30+50+10, 0, 0 )
      _windowAddItem:SetTitle( lang.additem )
      _windowAddItem:ShowCloseButton( true )
      _windowAddItem:SetDraggable( true )
      function _windowAddItem:Paint( pw, ph )
        draw.RoundedBox( 0, 0, 0, pw, ph, yrp.colors.background2 )

        draw.SimpleText( lang.price .. ":", "weaponT", ctrW( 8 ), ph - ctrW( 135 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
      end

      local _AddItemPanel = createVGUI( "DPanel", _windowAddItem, 500, 500, 6, 50 )
      function _AddItemPanel:Paint( pw, ph )
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 10 ) )

        draw.SimpleText( addSwep.PrintName, "weaponT", pw/2, ph - ctrW( 30 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      end

      local _AddItemModelPanel = createVGUI( "SpawnIcon", _AddItemPanel, 500, 500, 0, 0 )
      _AddItemModelPanel:SetModel( "" )

      local _AddItemSWEP = createVGUI( "DButton", _windowAddItem, 500, 50, 6, 50+500+10 )
      _AddItemSWEP:SetText( "" )
      function _AddItemSWEP:Paint( pw, ph )
        if _AddItemSWEP:IsHovered() then
          draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 255 ) )
        else
          draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
        end
        draw.SimpleText( lang.selectitem, "weaponT", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      end
      function _AddItemSWEP:DoClick()
        local itemSelector = vgui.Create( "DFrame" )
        itemSelector:SetSize( ctrW( 2000 ), ctrW( 2000 ) )
        itemSelector:SetPos( ScrW2() - ctrW( 2000/2 ), ScrH2() - ctrW( 2000/2 ) )
        itemSelector:SetTitle( lang.itemMenu )
        function itemSelector:Paint( pw, ph )
          draw.RoundedBox( 0, 0, 0, pw, ph, yrp.colors.background2 )
        end

        local PanelSelect = vgui.Create( "DPanelSelect", itemSelector )
        PanelSelect:SetSize( ctrW( 2000 ), ctrW( 2000 - 45 ) )
        PanelSelect:SetPos( ctrW( 10 ), ctrW( 100 ) )
        PanelSelect:SetText( "" )

        local _itemlist = {}
        if _tab == "weapons" then
          local _sweplist = weapons.GetList()
          local _weaplist = list.Get( "Weapon" )
          for k, v in pairs( _weaplist ) do
            table.insert( _sweplist, v )
          end
          _itemlist = _sweplist
        elseif _tab == "entities" then
          local _sentlist = list.Get( "SpawnableEntities" )
          _itemlist = _sentlist
        elseif _tab == "vehicles" then
          local _vehicleslist = list.Get( "Vehicles" )
          _itemlist = _vehicleslist
        end

        local itemsearch = createVGUI( "DTextEntry", itemSelector, 2000 - 20, 40, 10, 50 )
        function showResult()
          PanelSelect:Clear()
          local _cat = nil
          if tab == "vehicles" then
            _cat = "Category"
          end

          local _count = 0
          for k, item in SortedPairsByMemberValue( _itemlist, _cat, false ) do
            if _tab == "vehicles" then
              item.PrintName = item.Name or ""
              item.ClassName = item.Class or ""
              item.WorldModel = item.Model or ""
            end
            if string.find( string.lower( item.WorldModel or "XXXXXXXXX" ), itemsearch:GetText() ) or string.find( string.lower( item.PrintName or "XXXXXXXXX" ), itemsearch:GetText() ) or string.find( string.lower( item.ClassName or "XXXXXXXXX" ), itemsearch:GetText() ) then
              timer.Simple( _count/1000, function()
                if item.WorldModel == nil then
                  item.WorldModel = item.Model or ""
                end
                if item.ClassName == nil then
                  item.ClassName = item.Class or ""
                end
                if item.PrintName == nil then
                  item.PrintName = item.Name or ""
                end

                local icon = vgui.Create( "SpawnIcon" )
                icon:SetText( "" )
                icon:SetModel( item.WorldModel )
                icon:SetSize( ctrW( 256 ), ctrW( 256 ) )
                icon:SetTooltip( item.PrintName )
                local _tmpName = createVGUI( "DButton", icon, 256, 256, 10, 10 )
                _tmpName:SetText( "" )
                function _tmpName:Paint( pw, ph )
                  draw.SimpleText( item.PrintName, "pmT", pw/2, ph-ctrW( 35 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                end
                function _tmpName:DoClick()
                  _AddItemModelPanel:SetModel( item.WorldModel )
                  addSwep.ClassName = item.ClassName
                  addSwep.PrintName = item.PrintName
                  addSwep.WorldModel = item.WorldModel or ""
                  itemSelector:Close()
                end
          			PanelSelect:AddPanel( icon )
              end)
            end
            _count = _count + 1
      		end
        end

        function itemsearch:OnChange()
          showResult()
        end
        showResult()

        itemSelector:MakePopup()
      end

      local _AddItemPrice = createVGUI( "DNumberWang", _windowAddItem, 500, 50, 6, 50+500+10+50+10+30 )
      _AddItemPrice:SetValue( 100 )
      _AddItemPrice:SetMin( 0 )
      _AddItemPrice:SetMax( 1000000000 )
      addSwep.price = _AddItemPrice:GetValue()
      function _AddItemPrice:OnValueChanged( val )
        addSwep.price = val
      end

      local _AddItemAdd = createVGUI( "DButton", _windowAddItem, 500, 50, 6, 50+500+10+50+10+30+50+10 )
      _AddItemAdd:SetText( "" )
      function _AddItemAdd:Paint( pw, ph )
        if _AddItemAdd:IsHovered() then
          draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 255 ) )
        else
          draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
        end
        draw.SimpleText( lang.additem, "weaponT", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      end
      function _AddItemAdd:DoClick()
        net.Start( "addNewBuyItem" )
          net.WriteString( _tab )
          net.WriteString( addSwep.ClassName )
          net.WriteString( addSwep.PrintName )
          net.WriteString( addSwep.WorldModel )
          net.WriteString( addSwep.price )
        net.SendToServer()
        _windowAddItem:Close()
      end

      _windowAddItem:MakePopup()
      _windowAddItem:SetPos( ScrW()/2 - _windowAddItem:GetWide()/2, ScrH()/2 - _windowAddItem:GetTall()/2 )
    end
  end
end)

function openBuyMenu()
  _menuIsOpen = 1
  _buyWindow = createVGUI( "DFrame", nil, winW, winH, 0, 0 )
  _buyWindow:SetTitle( lang.buymenu )
  _buyWindow:Center()
  function _buyWindow:OnClose()
    _menuIsOpen = 0
    _buyWindow:Remove()
  end
  function _buyWindow:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, yrp.colors.background )
  end

  local Langu = createVGUI( "DComboBox", _buyWindow, 400, 50, 1400, 0 )
  Langu:SetValue( lang.lang )
  Langu:AddChoice( "[AUTOMATIC]", "auto" )
  for k, v in pairs( lang.all ) do
    Langu:AddChoice( v.ineng .. "/" .. v.lang, v.short )
  end
  Langu.OnSelect = function( panel, index, value, data )
    changeLang(data)
  end

  local _buyTabs = createVGUI( "DPropertySheet", _buyWindow, winW, winH, 0, 0 )
  _buyTabs:Dock( FILL )
  function _buyTabs:Paint( pw, ph )

  end

  _tabWeapon = vgui.Create( "DPanel", sheet )
  _tabWeapon.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 200 ) ) end
  _buyTabs:AddSheet( lang.weapons, _tabWeapon, "icon16/cart.png" )

  _tabEntities = vgui.Create( "DPanel", sheet )
  _tabEntities.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 200 ) ) end
  _buyTabs:AddSheet( lang.entities, _tabEntities, "icon16/cart.png" )

  _tabVehicles = vgui.Create( "DPanel", sheet )
  _tabVehicles.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 200 ) ) end
  _buyTabs:AddSheet( lang.vehicles, _tabVehicles, "icon16/cart.png" )

  for k, v in pairs( _buyTabs.Items ) do
  	if (!v.Tab) then continue end
    if k == 1 then
      v[k] = "weapons"
    elseif k == 2 then
      v[k] = "entities"
    elseif k == 3 then
      v[k] = "vehicles"
    end

    v.Tab.Paint = function(self,w,h)
      if v.Tab == _buyTabs:GetActiveTab() then
		    draw.RoundedBox( 0, 0, 0, w, h, yrp.colors.background )
        if v.selected != v[k] then
          v.selected = v[k]
          if v[k] == "weapons" then
            net.Start( "getBuyList" )
              net.WriteString( "weapons" )
            net.SendToServer()
          elseif v[k] == "entities" then
            net.Start( "getBuyList" )
              net.WriteString( "entities" )
            net.SendToServer()
          elseif v[k] == "vehicles" then
            net.Start( "getBuyList" )
              net.WriteString( "vehicles" )
            net.SendToServer()
          end
        end
      else
        draw.RoundedBox( 0, 0, 0, w, h, yrp.colors.buttonInActive )
      end
    end
  end

  _buyWindow:MakePopup()
end
