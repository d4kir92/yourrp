--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local _rm = nil

function toggleRoleMenu()
  if isNoMenuOpen() then
    openRoleMenu()
  else
    closeRoleMenu()
  end
end

function closeRoleMenu()
  if _rm != nil then
    closeMenu()
    _rm:Remove()
    _rm = nil
  end
end

function addRole( rol, parent, x, y )
  local _r = createD( "DButton", parent, ctrb( 512 ), ctrb( 512 ), ctrb( x ), ctrb( y ) )
  _r:SetText( "" )
  function _r:Paint( pw, ph )
    paintButton( self, pw, ph, rol.roleID )
  end
  return _r
end

function addGroup( grp, parent, x, y )
  printTab( grp )
  local _g = createD( "DCollapsibleCategory", parent, getGoodW()-x-ctrb(20), ctrb( 400 ), ctrb( x ), ctrb( y ) )
  function _g:Paint( pw, ph )
    local _color = string.Explode( ",", grp.color )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( _color[1], _color[2], _color[3] ) )
  end
  _g:SetExpanded( 0 )
  _g:SetLabel( grp.groupID )
  function _g:OnToggle()
    if self:GetExpanded() then
      net.Receive( "get_grp_roles", function( len )
        local _roles = net.ReadTable()

        _g.content = vgui.Create( "DPanelList", _g )	// Make a list of items to add to our category ( collection of controls )
        _g.content:SetSpacing( 5 )							 // Set the spacing between items
        _g.content:EnableHorizontal( false )					// Only vertical items
        _g.content:EnableVerticalScrollbar( true )			 // Enable the scrollbar if ( the contents are too wide

        _g:SetContents( _g.content )					// Add DPanelList to our Collapsible Category

        for i, rol in pairs( _roles ) do
          local _r = addRole( rol, _g, 0, (i-1)*ctrb( 100 ) )
          _g.content:AddItem( _r )
        end
      end)
      net.Start( "get_grp_roles" )
        net.WriteString( grp.uniqueID )
      net.SendToServer()
    end
  end
  return _g
end

function openRoleMenu()
  openMenu()

  _rm = createD( "DFrame", nil, getGoodW(), ScrH(), 0, 0 )
  _rm:Center()
  _rm:ShowCloseButton( true )
  _rm:SetDraggable( true )
  _rm:SetTitle( lang_string( "rolemenu" ) )
  function _rm:Paint( pw, ph )
    paintWindow( self, pw, ph, "" )
  end

  _rm.sp = createD( "DPanelList", _rm, getGoodW() - ctrb( 20 ), ScrH() - ctrb( 60 ), ctrb( 10 ), ctrb( 50 ) )
  function _rm.sp:Paint( pw, ph )
    --draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 255, 200 ) )
  end
  _rm.sp:SetSpacing( 10 )							 // Set the spacing between items
  --_rm.sp:EnableHorizontal( true )					// Only vertical items
  --_rm.sp:EnableVerticalScrollbar( true )			 // Enable the scrollbar if ( the contents are too wide

  net.Receive( "get_all_grps_no_upper", function( len )
    local _no_upper = net.ReadTable()
    printTab( _no_upper )
    for i, grp in pairs( _no_upper ) do
      local _g = addGroup( grp, _rm.sp, 0, (i-1)*ctrb( 100 ) )
      _rm.sp:AddItem( _g )
    end
  end)

  net.Start( "get_all_grps_no_upper" )
  net.SendToServer()

  _rm:MakePopup()
end
