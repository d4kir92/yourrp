--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local winW = 2160
local winH = winW

local panH = 256+10+50+10+50+10

local swepList = {}

function addNewItem( parent, item )
  local ply = LocalPlayer()

  local _itemPanel = createVGUI( "DPanel", parent, 256, panH, swepList.x, swepList.y )
  _itemPanel.uniqueID = item.uniqueID
  function _itemPanel:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 200 ) )
    draw.SimpleText( item.PrintName, "weaponT", pw/2, ctrW( 256 - 15 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end

  local _itemModelPanel = createVGUI( "DModelPanel", _itemPanel, 256, 256, 0, 0 )
  _itemModelPanel:SetModel( item.WorldModel )
  if item.PrintName != nil then
    _itemPanel.PrintName = item.PrintName
  end
  if item.ClassName != nil then
    _itemPanel.ClassName = item.ClassName
  else
    _itemPanel.ClassName = ""
  end
  _itemModelPanel:SetLookAt( Vector( 0, 0, 0 ) )
  _itemModelPanel:SetCamPos( Vector( 0, 0, 0 ) + Vector( -20, 0, 15 ) )

  local _pricePanel = createVGUI( "DPanel", _itemPanel, 240, 50, 8, 256+10 )
  function _pricePanel:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
    draw.SimpleText( ply:GetNWString( "moneyPre" ) .. item.price .. ply:GetNWString( "moneyPost" ), "weaponT", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end

  local _itemAmountNumberWang = createVGUI( "DNumberWang", _itemPanel, 120, 50, 8, 256+10+50+10 )
  _itemAmountNumberWang:SetValue( 1 )

  local _itemBuyButton = createVGUI( "DButton", _itemPanel, 120, 50, 8+120, 256+10+50+10 )
  _itemBuyButton:SetText( "" )
  function _itemBuyButton:Paint( pw, ph )
    if _itemBuyButton:IsHovered() then
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 255 ) )
    else
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255 ) )
    end
    draw.SimpleText( lang.buy, "weaponT", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end
  function _itemBuyButton:DoClick()
    net.Start( "buyItem" )
      net.WriteString( "weapons" )
      net.WriteString( _itemPanel.uniqueID )
    net.SendToServer()
    _buyWindow:Close()
  end

  if ply:IsAdmin() or ply:IsSuperAdmin() then
    panH = 256+10+50+10+50+10+50+10
    _itemPanel:SetSize( ctrW( 256 ), ctrW( panH ) )

    local _removeButton = createVGUI( "DButton", _itemPanel, 240, 50, 8, 256+10+50+10+50+10 )
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

  swepList.x = swepList.x + 256 + 8
  if ctrW( swepList.x ) > ctrW( 1888 ) then
    swepList.y = swepList.y + ctrW( 10 ) + panH
    swepList.x = 0
  end
end

net.Receive( "getBuyList", function( len )
  if _weaponScrollPanel != nil then
    _weaponScrollPanel:Remove()
    if _addItemButton != nil then
      _addItemButton:Remove()
    end
  end
  local ply = LocalPlayer()
  local _tab = net.ReadString()
  local _list = net.ReadTable()

  swepList.x = 0
  swepList.y = 0
  _weaponScrollPanel = createVGUI( "DScrollPanel", _tabWeapon, winW-60, winH-60-50-30, swepList.x, swepList.y )
  for k, weapon in pairs ( _list ) do
    if weapon.PrintName != nil and !string.find( string.lower( weapon.PrintName ), "npc") and !string.find( string.lower( weapon.PrintName ), "base") and !string.find( string.lower( weapon.PrintName ), "ttt") then
      addNewItem( _weaponScrollPanel, weapon )
    end
  end
  if ply:IsAdmin() or ply:IsSuperAdmin() then
    _addItemButton = createVGUI( "DButton", _tabWeapon, 256, panH, swepList.x, swepList.y )
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
        PanelSelect:SetPos( ctrW( 0 ), ctrW( 45 ) )
        PanelSelect:SetText( "" )

        local _sweplist = weapons.GetList()
        local tmp2 = {}
        tmp2.WorldModel = "models/weapons/w_physics.mdl"
        tmp2.ClassName = "weapon_physcannon"
        tmp2.PrintName = "Gravity Gun"
        table.insert( _sweplist, tmp2 )
        local tmp3 = {}
        tmp3.WorldModel = "models/weapons/w_Physics.mdl"
        tmp3.ClassName = "weapon_physgun"
        tmp3.PrintName = "PHYSICS GUN"
        table.insert( _sweplist, tmp3 )

        for k, swep in pairs( _sweplist ) do
    			local icon = vgui.Create( "SpawnIcon" )
          icon:SetText( "" )
    			icon:SetModel( swep.WorldModel )
    			icon:SetSize( ctrW( 256 ), ctrW( 256 ) )
    			icon:SetTooltip( swep.PrintName )
          local _tmpName = createVGUI( "DButton", icon, 256, 256, 0, 0 )
          _tmpName:SetText( "" )
          function _tmpName:Paint( pw, ph )
            draw.SimpleText( swep.PrintName, "pmT", pw/2, ph-ctrW( 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
          end
          function _tmpName:DoClick()
            _AddItemModelPanel:SetModel( swep.WorldModel )
            addSwep.ClassName = swep.ClassName
            addSwep.PrintName = swep.PrintName
            addSwep.WorldModel = swep.WorldModel
            itemSelector:Close()
          end
    			PanelSelect:AddPanel( icon )
    		end
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
          net.WriteString( "weapons" )
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

  end

  local _buyTabs = createVGUI( "DPropertySheet", _buyWindow, winW, winH, 0, 0 )
  _buyTabs:Dock( FILL )
  function _buyTabs:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, yrp.colors.background )
  end

  _tabWeapon = vgui.Create( "DPanel", sheet )
  _tabWeapon.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 200 ) ) end
  _buyTabs:AddSheet( lang.weapons, _tabWeapon, "icon16/cart.png" )

  net.Start( "getBuyList" )
    net.WriteString( "weapons" )
  net.SendToServer()

  for k, v in pairs(_buyTabs.Items) do
  	if (!v.Tab) then continue end

    v.Tab.Paint = function(self,w,h)
      if v.Tab == _buyTabs:GetActiveTab() then
		    draw.RoundedBox( 0, 0, 0, w, h, yrp.colors.background )
      else
        draw.RoundedBox( 0, 0, 0, w, h, yrp.colors.buttonInActive )
      end
    end
  end

  _buyWindow:MakePopup()
end
