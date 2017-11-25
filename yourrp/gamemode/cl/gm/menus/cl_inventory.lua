--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local _inv = {}
_inv.r = {}

function clearR()
  for k, v in pairs( yrp_inventory.right:GetChildren() ) do
    v:Remove()
  end
end

net.Receive( "get_menu_bodygroups", function( len )
  clearR()

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

  function yrp_inventory.right:Paint( pw, ph )
    paintPanel( self, pw, ph )
    draw.SimpleTextOutlined( lang_string( "appearance" ), "HudBars", pw/2, ctr( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr( 1 ), Color( 0, 0, 0, 255 ) )
  end

  _inv.r.pm = createD( "DModelPanel", yrp_inventory.right, ScrH2() - ctr( 30 ), ScrH2() - ctr( 30 ), 0, 0 )
  _inv.r.pm:SetModel( LocalPlayer():GetModel() )

  _tbl.bgs = _inv.r.pm.Entity:GetBodyGroups()

  for k, v in pairs( _tbl.bgs ) do
    if k <= 8 then
      _inv.r.pm.Entity:SetBodygroup( k-1, _cbg[k])
      local _tmpBg = createD( "DPanel", yrp_inventory.right, ScrH2() - ctr( 30 ), ctr( 100 ), ctr( 10 ), ScrH2() - ctr( 30 ) + (k-1) * ctr( 110 ) )
      _tmpBg.name = v.name
      _tmpBg.max = v.num
      _tmpBg.cur = _cbg[k]
      _tmpBg.id = v.id
      function _tmpBg:Paint( pw, ph )
        paintPanel( self, pw, ph )
        draw.SimpleTextOutlined( self.name .. " (" .. _tmpBg.cur+1 .. "/" .. _tmpBg.max .. ")", "DermaDefault", ctr( 60 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, ctr( 1 ), Color( 0, 0, 0, 255 ) )
      end
      _tmpBgUp = createD( "DButton", _tmpBg, ctr( 50 ), ctr( 50 ), 0, 0 )
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

      _tmpBgDo = createD( "DButton", _tmpBg, ctr( 50 ), ctr( 50 ), 0, ctr( 50 ) )
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

function showCharacter()
  clearR()

  function yrp_inventory.right:Paint( pw, ph )
    paintPanel( self, pw, ph )

    draw.SimpleTextOutlined( lang_string( "character" ), "HudBars", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr( 1 ), Color( 0, 0, 0, 255 ) )
  end
end

function showAttributes()
  clearR()

  function yrp_inventory.right:Paint( pw, ph )
    paintPanel( self, pw, ph )

    draw.SimpleTextOutlined( lang_string( "attributes" ), "HudBars", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr( 1 ), Color( 0, 0, 0, 255 ) )
  end
end

local inv = {}
inv.size = 128

net.Receive( "get_inventory", function( len )
  if yrp_inventory.cache_inv != nil then
    for k, v in pairs( yrp_inventory.cache_inv ) do
      v:Remove()
    end
  end
  local _inv = net.ReadTable()
  yrp_inventory.cache_inv = yrp_inventory.cache_inv or {}
  for x = 1, 8 do
    yrp_inventory.cache_inv[x] = yrp_inventory.cache_inv[x] or {}
    for y = 1, 8 do
      yrp_inventory.cache_inv[x][y] = createD( "DPanel", yrp_inventory.left, ctr( inv.size ), ctr( inv.size ), ctr( 10 ) + ctr( (x-1)*inv.size ), ctr( 10 ) + ctr( (y-1)*inv.size ) )
      local _tmp = yrp_inventory.cache_inv[x][y]
      function _tmp:Paint( pw, ph )
        paintInv( self, pw, ph, _inv["f_x"..x]["f_y"..y].PrintName )
      end
    end
  end
end)

function open_inventory()
  openMenu()
  yrp_inventory = yrp_inventory or {}
  yrp_inventory.window = createD( "DFrame", nil, ScrH(), ScrH(), 0, 0 )
  yrp_inventory.window:SetTitle( "" )
  yrp_inventory.window:Center()
  yrp_inventory.window:SetDraggable( true )
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

  --[[ LEFT SIDE ]]--
  yrp_inventory.left = createD( "DPanel", yrp_inventory.window, ScrH2() - ctr( 10 ), ScrH() - ctr( 200 ), 0, ctr( 100 ) )
  function yrp_inventory.left:Paint( pw, ph )
    paintPanel( self, pw, ph )

    draw.SimpleTextOutlined( "IN WORK", "HudBars", pw/2, ctr( 1500 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr( 1 ), Color( 0, 0, 0, 255 ) )
  end

  net.Start( "get_inventory" )
  net.SendToServer()

  yrp_inventory.tabInv = createD( "DButton", yrp_inventory.window, ctr( 300 ), ctr( 80 ), 0, ctr( 20 ) )
  yrp_inventory.tabInv:SetText( "" )
  function yrp_inventory.tabInv:Paint( pw, ph )
    paintButton( self, pw, ph, lang_string( "inventory" ) )
  end

  --[[ RIGHT SIDE ]]--
  yrp_inventory.right = createD( "DPanel", yrp_inventory.window, ScrH2() - ctr( 10 ), ScrH() - ctr( 200 ), ScrH2() + ctr( 10 ), ctr( 100 ) )
  function yrp_inventory.right:Paint( pw, ph )
    paintPanel( self, pw, ph )

    draw.SimpleTextOutlined( "IN WORK", "HudBars", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr( 1 ), Color( 0, 0, 0, 255 ) )
  end

  yrp_inventory.tabChar = createD( "DButton", yrp_inventory.window, ctr( 300 ), ctr( 80 ), ScrH2() + ctr( 10 ), ctr( 20 ) )
  yrp_inventory.tabChar:SetText( "" )
  function yrp_inventory.tabChar:Paint( pw, ph )
    paintButton( self, pw, ph, lang_string( "character" ) )
  end
  function yrp_inventory.tabChar:DoClick()
    showCharacter()
  end

  yrp_inventory.tabBody = createD( "DButton", yrp_inventory.window, ctr( 300 ), ctr( 80 ), ScrH2() + ctr( 320 ), ctr( 20 ) )
  yrp_inventory.tabBody:SetText( "" )
  function yrp_inventory.tabBody:Paint( pw, ph )
    paintButton( self, pw, ph, lang_string( "appearance" ) )
  end
  function yrp_inventory.tabBody:DoClick()
    net.Start( "get_menu_bodygroups" )
    net.SendToServer()
  end

  yrp_inventory.tabAtr = createD( "DButton", yrp_inventory.window, ctr( 300 ), ctr( 80 ), ScrH2() + ctr( 630 ), ctr( 20 ) )
  yrp_inventory.tabAtr:SetText( "" )
  function yrp_inventory.tabAtr:Paint( pw, ph )
    paintButton( self, pw, ph, lang_string( "attributes" ) )
  end
  function yrp_inventory.tabAtr:DoClick()
    showAttributes()
  end

  yrp_inventory.window:MakePopup()
end
