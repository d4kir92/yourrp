
function openBuyMenu()
  _buyWindow = createVGUI( "DFrame", nil, 2000, 2000, 0, 0 )
  _buyWindow:SetTitle( "Buy Menu" )
  _buyWindow:Center()
  function _buyWindow:OnClose()
    _menuIsOpen = 0
  end

  local _buyTabs = createVGUI( "DPropertySheet", _buyWindow, 2000, 2000, 0, 0 )
  _buyTabs:Dock( FILL )

  local _tabWeapon = vgui.Create( "DPanel", sheet )
  _tabWeapon.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 128, 255 ) ) end
  _buyTabs:AddSheet( "Weapon", _tabWeapon, "icon16/cart.png" )

  local _tabAmmo = vgui.Create( "DPanel", sheet )
  _tabAmmo.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 128, 255 ) ) end
  _buyTabs:AddSheet( "Ammo", _tabAmmo, "icon16/cart.png" )

  local _tabProps = vgui.Create( "DPanel", sheet )
  _tabProps.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 128, 255 ) ) end
  _buyTabs:AddSheet( "Props", _tabProps, "icon16/cart.png" )

  local _tabEnts = vgui.Create( "DPanel", sheet )
  _tabEnts.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 128, 255 ) ) end
  _buyTabs:AddSheet( "Electronics", _tabEnts, "icon16/cart.png" )

  local _tabMeta = vgui.Create( "DPanel", sheet )
  _tabMeta.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 128, 255 ) ) end
  _buyTabs:AddSheet( "Metabolism", _tabMeta, "icon16/cart.png" )

  local _tabMarket = vgui.Create( "DPanel", sheet )
  _tabMarket.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 128, 255 ) ) end
  _buyTabs:AddSheet( "Marketplace", _tabMarket, "icon16/cart.png" )

  _buyWindow:MakePopup()
end
