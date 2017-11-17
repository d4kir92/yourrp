--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

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
  yrp_inventory.tabInv = createD( "DButton", yrp_inventory.window, ctr( 300 ), ctr( 80 ), 0, ctr( 20 ) )
  yrp_inventory.tabInv:SetText( "" )
  function yrp_inventory.tabInv:Paint( pw, ph )
    paintButton( self, pw, ph, lang_string( "inventory" ) )
  end

  yrp_inventory.inv = createD( "DPanel", yrp_inventory.window, ScrH2() - ctr( 10 ), ScrH() - ctr( 200 ), 0, ctr( 100 ) )
  function yrp_inventory.inv:Paint( pw, ph )
    paintPanel( self, pw, ph )

    draw.SimpleTextOutlined( "IN WORK", "HudBars", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr( 1 ), Color( 0, 0, 0, 255 ) )
  end

  --[[ RIGHT SIDE ]]--
  yrp_inventory.tabChar = createD( "DButton", yrp_inventory.window, ctr( 300 ), ctr( 80 ), ScrH2() + ctr( 10 ), ctr( 20 ) )
  yrp_inventory.tabChar:SetText( "" )
  function yrp_inventory.tabChar:Paint( pw, ph )
    paintButton( self, pw, ph, lang_string( "character" ) )
  end

  yrp_inventory.char = createD( "DPanel", yrp_inventory.window, ScrH2() - ctr( 10 ), ScrH() - ctr( 200 ), ScrH2() + ctr( 10 ), ctr( 100 ) )
  function yrp_inventory.char:Paint( pw, ph )
    paintPanel( self, pw, ph )

    draw.SimpleTextOutlined( "IN WORK", "HudBars", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr( 1 ), Color( 0, 0, 0, 255 ) )
  end

  yrp_inventory.tabBody = createD( "DButton", yrp_inventory.window, ctr( 300 ), ctr( 80 ), ScrH2() + ctr( 320 ), ctr( 20 ) )
  yrp_inventory.tabBody:SetText( "" )
  function yrp_inventory.tabBody:Paint( pw, ph )
    paintButton( self, pw, ph, lang_string( "appearance" ) )
  end

  yrp_inventory.tabChar = createD( "DButton", yrp_inventory.window, ctr( 300 ), ctr( 80 ), ScrH2() + ctr( 630 ), ctr( 20 ) )
  yrp_inventory.tabChar:SetText( "" )
  function yrp_inventory.tabChar:Paint( pw, ph )
    paintButton( self, pw, ph, lang_string( "attributes" ) )
  end

  yrp_inventory.window:MakePopup()
end
