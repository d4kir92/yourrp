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
  --printTab( rol )
  --[[ Role Content ]]--
  local _r = createD( "DPanel", parent, ctrb( 400 ), ctrb( 400 ), x, y )
  function _r:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
    drawRBoxBr( 0, 0, 0, pw*2, ph*2, Color( 0, 0, 0 ), 2 )
  end

  --[[ Role Model ]]--
  _r.model = createD( "DModelPanel", _r, ctrb( 400 ), ctrb( 400 ), 0, 0 )
  _r.model.model = string.Explode( ",", rol.playermodels )
  _r.model.model = _r.model.model[1]
  _r.model:SetModel( _r.model.model )

  --[[ Role Name ]] --
  _r.name = createD( "DPanel", _r, ctrb( 400 ), ctrb( 50 ), 0, 0 )
  function _r.name:Paint( pw, ph )
    surfaceText( rol.roleID, "HudBars", pw/2, ph/2, Color( 255, 255, 255, 255 ), 1, 1 )
  end

  if tonumber( rol.maxamount ) > 0 then
    --[[ Role Maxamount ]] --
    _r.maxamount = createD( "DPanel", _r, ctrb( 400-4 ), ctrb( 50 ), ctrb( 2 ), ctrb( 300-2 ) )
    function _r.maxamount:Paint( pw, ph )
      self.color = Color( 0, 255, 0 )
      if rol.uses == rol.maxamount then
        self.color = Color( 255, 0, 0 )
      end
      draw.RoundedBox( 0, 0, 0, pw*rol.uses/rol.maxamount, ph, self.color )
      drawRBoxBr( 0, 0, 0, pw*2, ph*2, Color( 0, 0, 0 ), 2 )
      surfaceText( rol.uses .. "/" .. rol.maxamount, "HudBars", pw/2, ph/2, Color( 255, 255, 255, 255 ), 1, 1 )
    end
  end

  --[[ Role Button ]]--
  _r.button = createD( "DButton", _r, ctrb( 400-4 ), ctrb( 50 ), ctrb( 2 ), ctrb( 350-2 ) )
  _r.button:SetText( "" )
  function _r.button:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 0, 0 ) )
  end

  return _r
end

function addGroup( grp, parent, x, y )
  --printTab( grp )
  --[[ Group Content ]]--
  local _g = createD( "DPanelList", parent, getGoodW()-x-ctrb(20), ctrb( 100 ), x, y )
  _g:SetSpacing( 10 )
  grp.color = string.Explode( ",", grp.color )
  _g.color = Color( grp.color[1], grp.color[2], grp.color[3] )
  function _g:Paint( pw, ph )
    local _dif = 80
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( self.color.r-_dif, self.color.g-_dif, self.color.b-_dif ) )
  end

  --[[ Group Collapse Button ]]--
  _g.button = createD( "DButton", _g, getGoodW()-x-ctrb(20), ctrb( 100 ), 0, 0 )
  _g.button.color = _g.color
  _g.button:SetText( "" )
  function _g.button:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, self.color )
    surfaceText( grp.groupID, "HudBars", ph/2, ph/2, Color( 255, 255, 255, 255 ), 0, 1 )
  end
  _g.button.open = false
  function _g.button:DoClick()

    if !self.open then
      getRoles( grp.uniqueID, _g, parent )
      getGroups( grp.uniqueID, _g, parent )
    else
      _g:SetSize( _g:GetWide(), _g.button:GetTall() )
      parent:Rebuild()
    end
    self.open = !self.open
  end

  return _g
end

function getRoles( uid, parent, grandparent )
  net.Receive( "get_grp_roles", function( len )
    local _roles = net.ReadTable()
    addRoles( _roles, parent )
    parent:Rebuild()
    grandparent:Rebuild()
  end)

  net.Start( "get_grp_roles" )
    net.WriteString( uid )
  net.SendToServer()
end

function addRoles( rols, parent )
  for i, rol in pairs( rols ) do
    local _r = addRole( rol, parent, ctrb( 10 ), parent.button:GetTall() + (i-1)*ctrb( 400+10 ) )
    parent:AddItem( _r )
    parent:SetSize( parent:GetWide(), parent:GetTall() + ctrb( 400+10 ) )
  end
end

function getGroups( uid, parent, grandparent )
  net.Receive( "get_grps", function( len )
    local _groups = net.ReadTable()
    addGroups( _groups, parent )
    parent:Rebuild()
    grandparent:Rebuild()
  end)

  net.Start( "get_grps" )
    net.WriteString( uid )
  net.SendToServer()
end

function addGroups( grps, parent )
  for i, grp in pairs( grps ) do
    local _g = addGroup( grp, parent, 0, parent:GetTall() + (i-1)*ctrb( 100+10 ) )
    parent:AddItem( _g )
    parent:SetSize( parent:GetWide(), parent:GetTall() + ctrb( 100+10 ) )
  end
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
  _rm.sp:SetSpacing( 10 )

  _rm.sp.name = "HAUPT"

  function _rm.sp:Paint( pw, ph )
    --draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 200 ) )
  end

  getGroups( -1, _rm.sp, _rm.sp )

  _rm:MakePopup()
end
