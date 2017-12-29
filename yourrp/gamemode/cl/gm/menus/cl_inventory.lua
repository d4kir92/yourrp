--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local _inv = {}
_inv.r = {}
local yrp_inventory = {}
yrp_inventory.isopen = false
yrp_inventory.cache_inv = {}
yrp_inventory.cache_inv_item = {}

function clearL()
  if yrp_inventory != nil then
    if yrp_inventory.left != nil then
      if yrp_inventory.left:GetChildren() != nil then
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
            if (istable(w))then
              for m, x in pairs( w ) do
                x:Remove()
              end
            else
              w:Remove()
            end
          end
        end
      end
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

local INV_W = 8
local INV_H = 8

function insert_env_in_slot( parent, tbl, w, h, x, y )
  if tbl != "-1" then

    local _w = tbl.w
    local _h = tbl.h
    local _model = tbl.Model
    local _pname = tbl.PrintName
    local _cname = tbl.ClassName
    local _cen = tbl.center

    local _bg = createD( "DPanel", parent, ctr(w*inv.size), ctr(h*inv.size), ctr( x ), ctr( y ) )
    local _tmp = createD( "DModelPanel", _bg, ctr(w*inv.size), ctr(h*inv.size), 0, 0 )
    _tmp.name = "Item"
    _tmp:SetModel( _model )
    _tmp:SetToolTip( "Name: " .. _pname .. "\n" .. "CName: " .. _cname .. "\n" .. "w: " .. _w .. "\n" .. "h: " .. _h )
    _tmp.tbl = tbl
    _tmp:Droppable( "ITEM" )

    local _center = _cen
    _center = string.Explode( " ", _center )
    local _cen = {}
    _cen.x = _center[1]
    _cen.y = _center[2]
    _cen.z = _center[3]

    local _sort = {}
    for axis, value in SortedPairsByValue( _cen, true ) do
      local tbl = {}
      tbl.axis = axis
      tbl.value = value
      table.insert( _sort, tbl )
    end

    _tmp:SetLookAt( Vector( _cen.x, _cen.y, _cen.z ) )
    _tmp:SetCamPos( Vector( _cen.x, _cen.y, _cen.z ) - Vector( 0, _w*6, 0 ) )	-- Move cam in front of eyes

    function _tmp:LayoutEntity( ent )
      return false
    end
    _tmp.PrintName = tbl.PrintName
    function _bg:Paint( pw, ph )
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 100, 100, 255, 40 ) )
    end
    function _tmp:PaintOver( pw, ph )
      --[[ Name ]]--
      if self:IsDragging() then
        draw.SimpleTextOutlined( self.PrintName, "DermaDefault", ctr( 10 ), ctr( 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, ctr( 1 ), Color( 0, 0, 0, 255 ))

        paintBr( pw, ph, Color( 18, 18, 18 ) )
      end
    end
    return _bg
  end
end

function add_eq_slot( field, w, h, x, y )
  local _tmp = createD( "DPanel", yrp_inventory.left, w, h, x, y )
  _tmp.name = "SLOT"
  _tmp._x = field
  _tmp._y = ""
  function _tmp:Paint( pw, ph )
    paintInv( self, pw, ph, "" )
  end

  _tmp:Receiver( "ITEM", function( receiver, tableOfDroppedPanels, isDropped, menuIndex, mouseX, mouseY )
    if isDropped then
      if receiver:IsHovered() then
        local _x, _y = receiver:GetPos()
        tableOfDroppedPanels[1]:SetPos( _x + ctr(  1 ), _y + ctr(  1 ) )
        net.Start( "item_move" )
          net.WriteString( receiver._x )
          net.WriteString( receiver._y )
          net.WriteString( tableOfDroppedPanels[1].tbl.uniqueID )
          net.WriteString( "eq" )
        net.SendToServer()
      end
    end
  end, {} )
end

function insert_eq_in_slot( slot, tbl, w, h, x, y )
  if tbl != "-1" and tbl != nil then

    local _w = tbl.w
    local _h = tbl.h
    local _model = tbl.Model
    local _pname = tbl.PrintName
    local _cname = tbl.ClassName
    local _cen = tbl.center

    local _bg = createD( "DPanel", yrp_inventory.left, w, h, x, y )

    local _tmp = createD( "DModelPanel", _bg, w, h, 0, 0 )
    _tmp.w = w
    _tmp.h = h
    _tmp.name = "Item"
    _tmp:SetModel( _model )
    _tmp:SetToolTip( "Name: " .. _pname .. "\n" .. "CName: " .. _cname .. "\n" .. "w: " .. _w .. "\n" .. "h: " .. _h )
    _tmp.tbl = tbl
    _tmp:Droppable( "ITEM" )

    local _center = _cen
    _center = string.Explode( " ", _center )
    local _cen = {}
    _cen.x = _center[1]
    _cen.y = _center[2]
    _cen.z = _center[3]

    local _sort = {}
    for axis, value in SortedPairsByValue( _cen, true ) do
      local tbl = {}
      tbl.axis = axis
      tbl.value = value
      table.insert( _sort, tbl )
    end

    _tmp:SetLookAt( Vector( _cen.x, _cen.y, _cen.z ) )
    _tmp:SetCamPos( Vector( _cen.x, _cen.y, _cen.z ) - Vector( 0, _w*6, 0 ) )	-- Move cam in front of eyes

    function _tmp:LayoutEntity( ent )
      return false
    end
    _tmp.PrintName = tbl.PrintName
    _tmp.ClassName = tbl.ClassName
    local _weapen = LocalPlayer():GetWeapon( tbl.ClassName )
    if _weapen != nil and _weapen != NULL then
      _tmp.ammotype = _weapen:GetPrimaryAmmoType()
      _tmp.sammotype = _weapen:GetSecondaryAmmoType()
    end
    function _bg:Paint( pw, ph  )
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 100, 100, 255, 40 ) )
    end
    function _tmp:PaintOver( pw, ph  )
      if self:IsDragging() then
        self:SetSize( ctr(self.tbl.w)*inv.size, ctr(self.tbl.h)*inv.size )
      else
        self:SetSize( self.w, self.h )
      end
      --[[ Name ]]--
      draw.SimpleTextOutlined( self.PrintName, "DermaDefault", ctr( 10 ), ctr( 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, ctr( 1 ), Color( 0, 0, 0, 255 ))

      --[[ AMMO ]]--
      draw.SimpleTextOutlined( LocalPlayer():GetAmmoCount( self.ammotype or 1 ), "DermaDefault", ctr( 10 ), ph - ctr( 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, ctr( 1 ), Color( 0, 0, 0, 255 ))
      draw.SimpleTextOutlined( LocalPlayer():GetAmmoCount( self.sammotype or 1 ), "DermaDefault", pw - ctr( 10 ), ph - ctr( 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, ctr( 1 ), Color( 0, 0, 0, 255 ))

      paintBr( pw, ph, Color( 18, 18, 18 ) )
    end
    return _bg
  end
end

net.Receive( "get_inventory", function( len )
  clearL()

  function yrp_inventory.left:Paint( pw, ph )
    paintPanel( self, pw, ph, Color( 0, 0, 0, 160 ) )
  end

  local _tbl = net.ReadTable()
  local _env = _tbl.env
  local _inv = _tbl.inv

  local _env_header = createD( "DPanel", yrp_inventory.left, ctr( 1050 ), ctr( 50 ), ctr( 10 ), ctr( 10 ) )
  function _env_header:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 100, 100, 255, 200 ) )

    draw.SimpleTextOutlined( lang_string( "nearbyitems" ), "DermaDefault", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr( 1 ), Color( 0, 0, 0, 255 ) )
  end

  local _env_panel = createD( "DScrollPanel", yrp_inventory.left, ctr( 1050 ), ctr( 780 ), ctr( 10 ), ctr( 10 + 50 ) )
  function _env_panel:Paint( pw, ph )
    paintBr( pw, ph, Color( 255, 255, 255, 255 ) )
  end

  --[[ ENV SLOTS ]]--
  yrp_inventory.cache_env = {}
  local _env_y = 10
  if _env != nil then
    for k, env_item in pairs( _env ) do
      yrp_inventory.cache_env[k] = createD( "DPanel", _env_panel, ctr( env_item.w*inv.size ), ctr( env_item.h*inv.size ), ctr( 10 ), ctr( _env_y ) )
      _env_y = _env_y + env_item.h*inv.size + 10
      local _tmp = yrp_inventory.cache_env[k]
      _tmp.name = "SLOT"
      _tmp._x = x
      _tmp._y = y
      function _tmp:Paint( pw, ph )
        --paintInv( self, pw, ph, "" )
      end

      _tmp:Receiver( "ITEM", function( receiver, tableOfDroppedPanels, isDropped, menuIndex, mouseX, mouseY )
        if isDropped then
          if receiver:IsHovered() then
            local _x, _y = receiver:GetPos()
            tableOfDroppedPanels[1]:SetPos( _x + ctr(  1 ), _y + ctr(  1 ) )
            receiver:SetSize( tableOfDroppedPanels[1]:GetSize() )
            net.Start( "item_move" )
              net.WriteString( receiver._x )
              net.WriteString( receiver._y )
              net.WriteString( tableOfDroppedPanels[1].tbl.uniqueID )
              net.WriteString( "nearby" )
            net.SendToServer()
          end
        end
      end, {} )
    end
  end

  --[[ INV SLOTS ]]--
  local _inv_header = createD( "DPanel", yrp_inventory.left, ctr( 1050 ), ctr( 50 ), ctr( 10 ), ctr( 840 + 10 ) )
  function _inv_header:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 100, 100, 255, 200 ) )

    draw.SimpleTextOutlined( lang_string( "inventory" ), "DermaDefault", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr( 1 ), Color( 0, 0, 0, 255 ) )
  end
  local _inv_panel = createD( "DScrollPanel", yrp_inventory.left, ctr( 1050 ), ctr( 1050 ), ctr( 10 ), ctr( 840 + 10 + 50 ) )
  function _inv_panel:Paint( pw, ph )
    paintBr( pw, ph, Color( 255, 255, 255, 255 ) )
  end
  yrp_inventory.cache_inv = {}
  for y = 1, INV_H do
    yrp_inventory.cache_inv[y] = {}
    for x = 1, INV_W do
      yrp_inventory.cache_inv[y][x] = createD( "DPanel", _inv_panel, ctr( inv.size ), ctr( inv.size ), ctr( 10 ) + ctr( (x-1)*inv.size ), ctr( 10 ) + ctr( (y-1)*inv.size ) )
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
            net.Start( "item_move" )
              net.WriteString( receiver._x )
              net.WriteString( receiver._y )
              net.WriteString( tableOfDroppedPanels[1].tbl.uniqueID )
              net.WriteString( "inv" )
            net.SendToServer()
          end
        end
      end, {} )
    end
  end

  --[[ EQ SLOTS ]]--
  add_eq_slot( "w1", ctr( 200 ), ctr( 200 ), ctr( 1090 ), ctr( 900 ) )
  add_eq_slot( "w2", ctr( 200 ), ctr( 200 ), ctr( 1300 ), ctr( 900 ) )
  add_eq_slot( "w3", ctr( 200 ), ctr( 200 ), ctr( 1510 ), ctr( 900 ) )
  add_eq_slot( "w4", ctr( 200 ), ctr( 200 ), ctr( 1720 ), ctr( 900 ) )
  add_eq_slot( "w5", ctr( 200 ), ctr( 200 ), ctr( 1930 ), ctr( 900 ) )

  --[[ ENV ITEMS ]]--
  local _env_items = {}
  _env_items.x = 10
  _env_items.y = 10
  if _env != nil then
    for k, env_item in pairs( _env ) do
      insert_env_in_slot( _env_panel, env_item, env_item.w, env_item.h, _env_items.x, _env_items.y )
      _env_items.y = _env_items.y + env_item.h*inv.size + 10
    end
  end

  --[[ INV ITEMS ]]--
  yrp_inventory.cache_inv_item = {}
  for y = 1, INV_H do
    yrp_inventory.cache_inv_item[y] = {}
    for x = 1, INV_W do
      if _inv != nil then
        if _inv["y"..y] != nil then
          if _inv["y"..y]["x"..x] != nil then
            if _inv["y"..y]["x"..x].item != "-1" then
              if istable(_inv["y"..y]["x"..x].item ) then

                local _tbl = _inv["y"..y]["x"..x].item

                local _w = _tbl.w
                local _h = _tbl.h
                local _model = _tbl.Model
                local _pname = _tbl.PrintName
                local _cname = _tbl.ClassName
                local _cen = _tbl.center

                yrp_inventory.cache_inv_item[y][x] = createD( "DPanel", _inv_panel, ctr( inv.size*_w ), ctr( inv.size*_h ), ctr( 10 ) + ctr( (x-1)*inv.size ), ctr( 10 ) + ctr( (y-1)*inv.size ) )
                yrp_inventory.cache_inv_item[y][x].item = createD( "DModelPanel", yrp_inventory.cache_inv_item[y][x], ctr( inv.size*_w ), ctr( inv.size*_h ), 0, 0 )
                local _bg2 = yrp_inventory.cache_inv_item[y][x]
                local _tmp2 = yrp_inventory.cache_inv_item[y][x].item
                _tmp2.name = "Item"
                _tmp2:SetModel( _model )
                _tmp2:SetToolTip( "Name: " .. _pname .. "\n" .. "CName: " .. _cname .. "\n" .. "w: " .. _w .. "\n" .. "h: " .. _h )
                _tmp2.tbl = _tbl
                _tmp2:Droppable( "ITEM" )

                local _center = _cen
                _center = string.Explode( ",", _center )
                local _cen = {}
                _cen.x = tonumber(_center[1])
                _cen.y = tonumber(_center[2])
                _cen.z = tonumber(_center[3])

                local _sort = {}
                for axis, value in SortedPairsByValue( _cen, true ) do
                  local _tbl = {}
                  _tbl.axis = axis
                  _tbl.value = value
                  table.insert( _sort, _tbl )
                end

                _tmp2:SetLookAt( Vector( _cen.x, _cen.y, _cen.z ) )
                _tmp2:SetCamPos( Vector( _cen.x, _cen.y, _cen.z ) - Vector( 0, _w*6, 0 ) )	-- Move cam in front of eyes

                function _tmp2:LayoutEntity( ent )
                  return false
                end
                _tmp2.PrintName = _tbl.PrintName
                function _bg2:Paint( pw, ph )
                  draw.RoundedBox( 0, ctr(2), ctr(2), pw-ctr(4), ph-ctr(4), Color( 100, 100, 255, 40 ) )
                end
                function _tmp2:PaintOver( pw, ph  )
                  --[[ Name ]]--

                  draw.SimpleTextOutlined( self.PrintName, "DermaDefault", ctr( 10 ), ctr( 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, ctr( 1 ), Color( 0, 0, 0, 255 ))

                  paintBr( pw, ph, Color( 18, 18, 18 ) )

                end
              end
            end
          end
        end
      end
    end
  end


  --[[ EQ ITEMS ]]--
  yrp_inventory.cache_inv_item["eq"] = {}
  if _inv != nil then
    if _inv["w1"] != nil then
      yrp_inventory.cache_inv_item["eq"]["w1"] = insert_eq_in_slot( "w1", _inv["w1"].item, ctr( 200 ), ctr( 200 ), ctr( 1090 ), ctr( 900 ) )
    end
    if _inv["w2"] != nil then
      yrp_inventory.cache_inv_item["eq"]["w2"] = insert_eq_in_slot( "w2", _inv["w2"].item, ctr( 200 ), ctr( 200 ), ctr( 1300 ), ctr( 900 ) )
    end
    if _inv["w3"] != nil then
      yrp_inventory.cache_inv_item["eq"]["w3"] = insert_eq_in_slot( "w3", _inv["w3"].item, ctr( 200 ), ctr( 200 ), ctr( 1510 ), ctr( 900 ) )
    end
    if _inv["w4"] != nil then
      yrp_inventory.cache_inv_item["eq"]["w4"] = insert_eq_in_slot( "w4", _inv["w4"].item, ctr( 200 ), ctr( 200 ), ctr( 1720 ), ctr( 900 ) )
    end
    if _inv["w5"] != nil then
      yrp_inventory.cache_inv_item["eq"]["w5"] = insert_eq_in_slot( "w5", _inv["w5"].item, ctr( 200 ), ctr( 200 ), ctr( 1930 ), ctr( 900 ) )
    end
  end
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
          net.Start( "item_move" )
            net.WriteString( "" )
            net.WriteString( "" )
            net.WriteString( tableOfDroppedPanels[1].tbl.uniqueID )
            net.WriteString( "drop" )
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
      --paintPanel( self, pw, ph )
      --paintBr( pw, ph, Color( 255, 0, 0, 255 ))
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

    net.Start( "get_inventory" )
    net.SendToServer()

    yrp_inventory.window:MakePopup()
  end
end
