--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local _inv = {}
_inv.r = {}
local yrp_inventory = {}
yrp_inventory.isopen = false
yrp_inventory.cache_inv = {}
yrp_inventory.cache_inv_item = {}

function clearL()
  for k, v in pairs( yrp_inventory.left:GetChildren() ) do
    v:Remove()
  end

  for k, v in pairs( yrp_inventory.cache_inv ) do
    for l, w in pairs( v ) do
      w:Remove()
    end
  end

  for k, v in pairs( yrp_inventory.cache_inv_item ) do
    for l, w in pairs( v ) do
      w:Remove()
    end
  end
end

net.Receive( "get_menu_bodygroups", function( len )
  clearL()

  local _tbl = net.ReadTable()
  local _cbg = {}
  _cbg[1] = tonumber( _tbl.bg0 )
  _cbg[2] = tonumber( _tbl.bg1 )
  _cbg[3] = tonumber( _tbl.bg2 )
  _cbg[4] = tonumber( _tbl.bg3 )
  _cbg[5] = tonumber( _tbl.bg4 )
  _cbg[6] = tonumber( _tbl.bg5 )
  _cbg[7] = tonumber( _tbl.bg6 )
  _cbg[8] = tonumber( _tbl.bg7 )

  function yrp_inventory.left:Paint( pw, ph )
    paintPanel( self, pw, ph )
    draw.SimpleTextOutlined( lang_string( "appearance" ), "HudBars", pw/2, ctr( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr( 1 ), Color( 0, 0, 0, 255 ) )
  end

  _inv.r.pm = createD( "DModelPanel", yrp_inventory.left, ScrH2() - ctr( 30 ), ScrH2() - ctr( 30 ), 0, 0 )
  _inv.r.pm:SetModel( LocalPlayer():GetModel() )
  _inv.r.pm:SetAnimated( true )
  _inv.r.pm.Angles = Angle( 0, 0, 0 )
  _inv.r.pm:RunAnimation()

  function _inv.r.pm:DragMousePress()
		self.PressX, self.PressY = gui.MousePos()
		self.Pressed = true
	end
  function _inv.r.pm:DragMouseRelease() self.Pressed = false end

	function _inv.r.pm:LayoutEntity( ent )

		if ( self.bAnimated ) then self:RunAnimation() end

		if ( self.Pressed ) then
			local mx, my = gui.MousePos()
			self.Angles = self.Angles - Angle( 0, ( self.PressX or mx ) - mx, 0 )

			self.PressX, self.PressY = gui.MousePos()
      if ent != nil then
  	    ent:SetAngles( self.Angles )
      end
    end
	end

  _tbl.bgs = _inv.r.pm.Entity:GetBodyGroups()

  for k, v in pairs( _tbl.bgs ) do
    if k <= 8 then
      _inv.r.pm.Entity:SetBodygroup( k-1, _cbg[k])
      local _height = 80
      local _tmpBg = createD( "DPanel", yrp_inventory.left, ScrH2() - ctr( 30 ), ctr( _height ), ctr( 10 ), ScrH2() - ctr( 30 ) + (k-1) * ctr( _height+2 ) )
      _tmpBg.name = v.name
      _tmpBg.max = v.num
      _tmpBg.cur = _cbg[k]
      _tmpBg.id = v.id
      function _tmpBg:Paint( pw, ph )
        paintPanel( self, pw, ph )
        draw.SimpleTextOutlined( self.name .. " (" .. _tmpBg.cur+1 .. "/" .. _tmpBg.max .. ")", "DermaDefault", ctr( 60 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, ctr( 1 ), Color( 0, 0, 0, 255 ) )
      end
      _tmpBgUp = createD( "DButton", _tmpBg, ctr( 50 ), ctr( _height/2 - 2 ), ctr( 1 ), ctr( 1 ) )
      _tmpBgUp:SetText( "" )
      function _tmpBgUp:Paint( pw, ph )
        if _tmpBg.cur >= _tmpBg.max-1 then

        else
          paintButton( self, pw, ph, "↑" )
        end
      end
      function _tmpBgUp:DoClick()
        if _tmpBg.cur < _tmpBg.max-1 then
          _tmpBg.cur = _tmpBg.cur + 1
        end
        net.Start( "inv_bg_up" )
          net.WriteInt( _tmpBg.cur, 16 )
          net.WriteInt( _tmpBg.id, 16 )
        net.SendToServer()
        _inv.r.pm.Entity:SetBodygroup( _tmpBg.id, _tmpBg.cur )
      end

      _tmpBgDo = createD( "DButton", _tmpBg, ctr( 50 ), ctr( _height/2 - 2 ), ctr( 1 ), ctr( _height/2 - 1 ) )
      _tmpBgDo:SetText( "" )
      function _tmpBgDo:Paint( pw, ph )
        if _tmpBg.cur > 0 then
          paintButton( self, pw, ph, "↓" )
        else

        end
      end
      function _tmpBgDo:DoClick()
        if _tmpBg.cur > 0 then
          _tmpBg.cur = _tmpBg.cur - 1
        end
        net.Start( "inv_bg_do" )
          net.WriteInt( _tmpBg.cur, 16 )
          net.WriteInt( _tmpBg.id, 16 )
        net.SendToServer()
        _inv.r.pm.Entity:SetBodygroup( _tmpBg.id, _tmpBg.cur )
      end
    end
  end

end)

function showAttributes()
  clearL()

  function yrp_inventory.left:Paint( pw, ph )
    paintPanel( self, pw, ph )

    draw.SimpleTextOutlined( lang_string( "attributes" ) .. " <- LATER!", "HudBars", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr( 1 ), Color( 0, 0, 0, 255 ) )
  end
end

local inv = {}
inv.size = 128

net.Receive( "get_inventory", function( len )
  clearL()

  function yrp_inventory.left:Paint( pw, ph )
    paintPanel( self, pw, ph )

    --draw.SimpleTextOutlined( lang_string( "attributes" ) .. " <- LATER!", "HudBars", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr( 1 ), Color( 0, 0, 0, 255 ) )
  end

  local _inv = net.ReadTable()
  --PrintTable( _inv )

  --[[ INV SLOTS ]]--
  yrp_inventory.cache_inv = {}
  for y = 1, 8 do
    yrp_inventory.cache_inv[y] = {}
    for x = 1, 8 do
      yrp_inventory.cache_inv[y][x] = createD( "DPanel", yrp_inventory.left, ctr( inv.size ), ctr( inv.size ), ctr( 10 ) + ctr( (x-1)*inv.size ), ctr( 10 ) + ctr( (y-1)*inv.size ) )
      local _tmp = yrp_inventory.cache_inv[y][x]
      _tmp.name = "SLOT"
      _tmp._x = x
      _tmp._y = y
      function _tmp:Paint( pw, ph )
        paintInv( self, pw, ph, "" )
      end

      _tmp:Receiver( "ITEM", function( receiver, tableOfDroppedPanels, isDropped, menuIndex, mouseX, mouseY )
        if isDropped then
          if receiver:IsHovered() then
            local _x, _y = receiver:GetPos()
            tableOfDroppedPanels[1]:SetPos( _x + ctr(  1 ), _y + ctr(  1 ) )
            --tableOfDroppedPanels[1]:SetParent( receiver )
            --tableOfDroppedPanels[1]:SetParent( yrp_inventory.left )
            net.Start( "item_move" )
              net.WriteString( receiver._x )
              net.WriteString( receiver._y )
              net.WriteString( tableOfDroppedPanels[1].tbl.uniqueID )
            net.SendToServer()
          end
        end
      end, {} )
    end
  end

  yrp_inventory.cache_inv["eq"] = {}
  yrp_inventory.cache_inv["eq"].w1 = createD( "DPanel", yrp_inventory.left, ctr( 200 ), ctr( 200 ), ctr( 20 ), ctr( 20 + 1050 ) )
  local _w1 = yrp_inventory.cache_inv["eq"].w1
  function _w1:Paint( pw, ph )
    paintInv( self, pw, ph, "", lang_string( "weapon" ) )
  end
  _w1._x = "w1"
  _w1._y = "w1"
  _w1:Receiver( "ITEM", function( receiver, tableOfDroppedPanels, isDropped, menuIndex, mouseX, mouseY )
    if isDropped then
      if receiver:IsHovered() then
        local _x, _y = receiver:GetPos()
        tableOfDroppedPanels[1]:SetPos( _x + ctr(  1 ), _y + ctr(  1 ) )
        --tableOfDroppedPanels[1]:SetParent( receiver )
        --tableOfDroppedPanels[1]:SetParent( yrp_inventory.left )
        net.Start( "item_move" )
          net.WriteString( receiver._x )
          net.WriteString( receiver._y )
          net.WriteString( tableOfDroppedPanels[1].tbl.uniqueID )
        net.SendToServer()
      end
    end
  end, {} )

  --[[ INV ITEMS ]]--
  yrp_inventory.cache_inv_item = {}
  for y = 1, 8 do
    yrp_inventory.cache_inv_item[y] = {}
    for x = 1, 8 do
      if _inv["f_y"..y]["f_x"..x].ClassName != "[EMPTY]" and !isnumber(tonumber(_inv["f_y"..y]["f_x"..x].ClassName)) then
        local _w = _inv["f_y"..y]["f_x"..x].i_w
        local _h = _inv["f_y"..y]["f_x"..x].i_h

        yrp_inventory.cache_inv_item[y][x] = createD( "DModelPanel", yrp_inventory.left, ctr( inv.size*_w ), ctr( inv.size*_h ), ctr( 10 ) + ctr( (x-1)*inv.size ), ctr( 10 ) + ctr( (y-1)*inv.size ) )

        local _tmp2 = yrp_inventory.cache_inv_item[y][x]
        _tmp2.name = "Item"
        _tmp2:SetModel( _inv["f_y"..y]["f_x"..x].Model )
        _tmp2:SetToolTip( "Name: " .. _inv["f_y"..y]["f_x"..x].PrintName .. "\n" .. "CName: " .. _inv["f_y"..y]["f_x"..x].ClassName .. "\n" .. "w: " .. _inv["f_y"..y]["f_x"..x].i_w .. "\n" .. "h: " .. _inv["f_y"..y]["f_x"..x].i_h )
        _tmp2.tbl = _inv["f_y"..y]["f_x"..x]
        _tmp2:Droppable( "ITEM" )

        local _center = _inv["f_y"..y]["f_x"..x].i_center
        _center = string.Explode( " ", _center )
        local _cen = {}
        _cen.x = _center[1]
        _cen.y = _center[2]
        _cen.z = _center[3]

        local _sort = {}
        for axis, value in SortedPairsByValue( _cen, true ) do
          local _tbl = {}
          _tbl.axis = axis
          _tbl.value = value
          table.insert( _sort, _tbl )
        end

        _tmp2:SetLookAt( Vector( _cen.x, _cen.y, _cen.z ) )
        _tmp2:SetCamPos( Vector( _cen.x, _cen.y, _cen.z ) - Vector( 0, _inv["f_y"..y]["f_x"..x].i_w*6, 0 ) )	-- Move cam in front of eyes

        function _tmp2:LayoutEntity( ent )
          return false
        end
        function _tmp2:PaintOver( pw, ph  )
          draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 255, 0, 4 ) )
          paintBr( pw, ph, Color( 255, 255, 255 ) )
        end
      end
    end
  end

  --[[
  _inv.r.pm = createD( "DModelPanel", yrp_inventory.left, ScrH2() - ctr( 30 ), ScrH2() - ctr( 30 ), 0, 0 )
  _inv.r.pm:SetModel( LocalPlayer():GetModel() )
  _inv.r.pm:SetAnimated( true )
  _inv.r.pm.Angles = Angle( 0, 0, 0 )
  _inv.r.pm:RunAnimation()

  function _inv.r.pm:DragMousePress()
		self.PressX, self.PressY = gui.MousePos()
		self.Pressed = true
	end
  function _inv.r.pm:DragMouseRelease() self.Pressed = false end

	function _inv.r.pm:LayoutEntity( ent )

		if ( self.bAnimated ) then self:RunAnimation() end

		if ( self.Pressed ) then
			local mx, my = gui.MousePos()
			self.Angles = self.Angles - Angle( 0, ( self.PressX or mx ) - mx, 0 )

			self.PressX, self.PressY = gui.MousePos()
      if ent != nil then
  	    ent:SetAngles( self.Angles )
      end
    end
	end


  local _tbl = net.ReadTable()
  --PrintTable( _tbl )
  ]]--
  --[[
  _inv.r.helm = createD( "DPanel", yrp_inventory.left, ctr( 200 ), ctr( 200 ), ctr( 20 ), ctr( 20 ) )
  function _inv.r.helm:Paint( pw, ph )
    paintInv( self, pw, ph, _tbl.helm.PrintName, lang_string( "helm" ) )
  end

  _inv.r.shoulders = createD( "DPanel", yrp_inventory.left, ctr( 200 ), ctr( 200 ), ctr( 20 ), ctr( 20 + 200 + 10 ) )
  function _inv.r.shoulders:Paint( pw, ph )
    paintInv( self, pw, ph, _tbl.shoulders.PrintName, lang_string( "shoulders" ) )
  end

  _inv.r.cap = createD( "DPanel", yrp_inventory.left, ctr( 200 ), ctr( 200 ), ctr( 20 ), ctr( 20 + 420 ) )
  function _inv.r.cap:Paint( pw, ph )
    paintInv( self, pw, ph, _tbl.cap.PrintName, lang_string( "cap" ) )
  end

  _inv.r.chest = createD( "DPanel", yrp_inventory.left, ctr( 200 ), ctr( 200 ), ctr( 20 ), ctr( 20 + 630 ) )
  function _inv.r.chest:Paint( pw, ph )
    paintInv( self, pw, ph, _tbl.chest.PrintName, lang_string( "chest" ) )
  end

  _inv.r.gloves = createD( "DPanel", yrp_inventory.left, ctr( 200 ), ctr( 200 ), ScrH2() - ctr( 30+200 ), ctr( 20 ) )
  function _inv.r.gloves:Paint( pw, ph )
    paintInv( self, pw, ph, _tbl.gloves.PrintName, lang_string( "gloves" ) )
  end

  _inv.r.belt = createD( "DPanel", yrp_inventory.left, ctr( 200 ), ctr( 200 ), ScrH2() - ctr( 30+200 ), ctr( 20 + 200 + 10 ) )
  function _inv.r.belt:Paint( pw, ph )
    paintInv( self, pw, ph, _tbl.belt.PrintName, lang_string( "belt" ) )
  end

  _inv.r.pants = createD( "DPanel", yrp_inventory.left, ctr( 200 ), ctr( 200 ), ScrH2() - ctr( 30+200 ), ctr( 20 + 420 ) )
  function _inv.r.pants:Paint( pw, ph )
    paintInv( self, pw, ph, _tbl.pants.PrintName, lang_string( "pants" ) )
  end

  _inv.r.boots = createD( "DPanel", yrp_inventory.left, ctr( 200 ), ctr( 200 ), ScrH2() - ctr( 30+200 ), ctr( 20 + 630 ) )
  function _inv.r.boots:Paint( pw, ph )
    paintInv( self, pw, ph, _tbl.boots.PrintName, lang_string( "boots" ) )
  end

  _inv.r.backpack = createD( "DPanel", yrp_inventory.left, ctr( 200 ), ctr( 200 ), ctr( 20 ), ctr( 20 + 840 ) )
  function _inv.r.backpack:Paint( pw, ph )
    paintInv( self, pw, ph, _tbl.backpack.PrintName, lang_string( "backpack" ) )
  end
  ]]--
  --[[

  _inv.r.weaponP2 = createD( "DPanel", yrp_inventory.left, ctr( 200 ), ctr( 200 ), ctr( 20+205 ), ctr( 20 + 1050 ) )
  function _inv.r.weaponP2:Paint( pw, ph )
    paintInv( self, pw, ph, _tbl.weaponp2.PrintName, lang_string( "weapon" ) )
  end

  _inv.r.weaponS = createD( "DPanel", yrp_inventory.left, ctr( 200 ), ctr( 200 ), ctr( 20+410 ), ctr( 20 + 1050 ) )
  function _inv.r.weaponS:Paint( pw, ph )
    paintInv( self, pw, ph, _tbl.weapons.PrintName, lang_string( "weapon" ) )
  end

  _inv.r.weaponM = createD( "DPanel", yrp_inventory.left, ctr( 200 ), ctr( 200 ), ctr( 20+615 ), ctr( 20 + 1050 ) )
  function _inv.r.weaponM:Paint( pw, ph )
    paintInv( self, pw, ph, _tbl.weaponm.PrintName, lang_string( "weapon" ) )
  end

  _inv.r.weaponG = createD( "DPanel", yrp_inventory.left, ctr( 200 ), ctr( 200 ), ctr( 20+820 ), ctr( 20 + 1050 ) )
  function _inv.r.weaponG:Paint( pw, ph )
    paintInv( self, pw, ph, _tbl.weapong.PrintName, lang_string( "weapon" ) )
  end

  _inv.r.wp1 = createD( "DModelPanel", yrp_inventory.left, ctr( 200 ), ctr( 200 ), ctr( 20 ), ctr( 20 + 1050 ) )
  _inv.r.wp1:SetModel( _tbl.weaponp1.Model )
  _inv.r.wp1:SetLookAt( Vector( 0, 0, 5 ) )
  _inv.r.wp1:SetCamPos( Vector( 0, 0, 5 )-Vector( -25, 0, 0 ) )

  _inv.r.wp2 = createD( "DModelPanel", yrp_inventory.left, ctr( 200 ), ctr( 200 ), ctr( 20 + 205 ), ctr( 20 + 1050 ) )
  _inv.r.wp2:SetModel( _tbl.weaponp2.Model )
  _inv.r.wp2:SetLookAt( Vector( 0, 0, 5 ) )
  _inv.r.wp2:SetCamPos( Vector( 0, 0, 5 )-Vector( -25, 0, 0 ) )

  _inv.r.ws = createD( "DModelPanel", yrp_inventory.left, ctr( 200 ), ctr( 200 ), ctr( 20 + 410 ), ctr( 20 + 1050 ) )
  _inv.r.ws:SetModel( _tbl.weapons.Model )
  _inv.r.ws:SetLookAt( Vector( 0, 0, 5 ) )
  _inv.r.ws:SetCamPos( Vector( 0, 0, 5 )-Vector( -25, 0, 0 ) )

  _inv.r.wm = createD( "DModelPanel", yrp_inventory.left, ctr( 200 ), ctr( 200 ), ctr( 20 + 615 ), ctr( 20 + 1050 ) )
  _inv.r.wm:SetModel( _tbl.weaponm.Model )
  _inv.r.wm:SetLookAt( Vector( 0, 0, 5 ) )
  _inv.r.wm:SetCamPos( Vector( 0, 0, 5 )-Vector( -25, 0, 0 ) )

  _inv.r.wg = createD( "DModelPanel", yrp_inventory.left, ctr( 200 ), ctr( 200 ), ctr( 20 + 820 ), ctr( 20 + 1050 ) )
  _inv.r.wg:SetModel( _tbl.weapong.Model )
  _inv.r.wg:SetLookAt( Vector( 0, 0, 5 ) )
  _inv.r.wg:SetCamPos( Vector( 0, 0, 5 )-Vector( -25, 0, 0 ) )
  ]]--
end)

function close_inventory()
  closeMenu()
  yrp_inventory.window:Close()
  yrp_inventory.isopen = false
  yrp_inventory.drop_panel:Remove()
end

function open_inventory()
  if yrp_inventory.isopen then
    close_inventory()
    return false
  elseif isNoMenuOpen() then
    openMenu()
    yrp_inventory.isopen = true

    yrp_inventory.drop_panel = createD( "DPanel", nil, ScrW(), ScrH(), 0, 0 )
    yrp_inventory.drop_panel:Receiver( "ITEM", function( receiver, tableOfDroppedPanels, isDropped, menuIndex, mouseX, mouseY )
      if isDropped then
        if receiver:IsHovered() then
          tableOfDroppedPanels[1]:Remove()
          net.Start( "item_drop" )
            net.WriteString( tableOfDroppedPanels[1].tbl.uniqueID )
          net.SendToServer()
        end
      end
    end, {})
    function yrp_inventory.drop_panel:Paint( pw, ph )
      --
    end

    yrp_inventory.window = createD( "DFrame", nil, ScrH(), ScrH(), 0, 0 )
    yrp_inventory.window:SetTitle( "" )
    yrp_inventory.window:Center()
    yrp_inventory.window:SetDraggable( false )
    yrp_inventory.window:ShowCloseButton( false )
    yrp_inventory.window:SetSizable( true )
    function yrp_inventory.window:OnClose()
      yrp_inventory.window:Remove()
    end
    function yrp_inventory.window:Paint( pw, ph )
      --paintWindow( self, pw, ph, lang_string( "inventory" ) )
    end
    function yrp_inventory.window:OnClose()
      closeMenu()
    end
    function yrp_inventory.window:OnRemove()
      closeMenu()
    end

    yrp_inventory.left = createD( "DPanel", yrp_inventory.window, ScrH() - ctr( 10 ), ScrH() - ctr( 200 ), 0, ctr( 100 ) )
    function yrp_inventory.left:Paint( pw, ph )
      paintPanel( self, pw, ph )
    end

    yrp_inventory.tabInv = createD( "DButton", yrp_inventory.window, ctr( 300 ), ctr( 80 ), ctr( 0 ), ctr( 20 ) )
    yrp_inventory.tabInv:SetText( "" )
    function yrp_inventory.tabInv:Paint( pw, ph )
      paintButton( self, pw, ph, lang_string( "inventory" ) )
    end
    function yrp_inventory.tabInv:DoClick()
      net.Start( "get_inventory" )
      net.SendToServer()
    end

    yrp_inventory.tabBody = createD( "DButton", yrp_inventory.window, ctr( 300 ), ctr( 80 ), ctr( 310 ), ctr( 20 ) )
    yrp_inventory.tabBody:SetText( "" )
    function yrp_inventory.tabBody:Paint( pw, ph )
      paintButton( self, pw, ph, lang_string( "appearance" ) )
    end
    function yrp_inventory.tabBody:DoClick()
      net.Start( "get_menu_bodygroups" )
      net.SendToServer()
    end

    yrp_inventory.tabAtr = createD( "DButton", yrp_inventory.window, ctr( 300 ), ctr( 80 ), ctr( 620 ), ctr( 20 ) )
    yrp_inventory.tabAtr:SetText( "" )
    function yrp_inventory.tabAtr:Paint( pw, ph )
      paintButton( self, pw, ph, lang_string( "attributes" ) )
    end
    function yrp_inventory.tabAtr:DoClick()
      showAttributes()
    end

    --net.Start( "get_inventory" )
    --net.SendToServer()

    yrp_inventory.window:MakePopup()
  end
end
