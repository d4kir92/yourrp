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

local _pr = {}

local _adminonly = Material( "icon16/shield.png" )

function createRoleBox( rol, parent )
  local _rol = createD( "DPanel", parent, ctrb( 400 ), ctrb( 400 ), 0, 0 )
  function _rol:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 100 ) )
    drawRBBR( 0, 0, 0, pw, ph, Color( 0, 0, 0, 255 ), ctrb( 4 ) )
  end
  _rol.tbl = rol

  --[[ Role Playermodel ]]--
  _rol.pm = createD( "DModelPanel", _rol, _rol:GetWide(), _rol:GetTall(), 0, 0 )
  _rol.pm:SetModel( string.Explode( ",", _rol.tbl.playermodels )[1] or "" )

  --[[ Role Name ]]--
  _rol.rn = createD( "DPanel", _rol, _rol:GetWide(), ctrb( 60 ), 0, 0 )
  function _rol.rn:Paint( pw, ph )
    surfaceText( self:GetParent().tbl.roleID, "roleInfoHeader", pw/2, ph/2, Color( 255, 255, 255 ), 1, 1 )
  end

  --[[ Role MaxAmount ]]--
  if tonumber( rol.maxamount ) > 0 then
    _rol.ma = createD( "DPanel", _rol, _rol:GetWide(), ctrb( 60 ), 0, _rol:GetTall()-ctrb( 60 + 60 ) )
    function _rol.ma:Paint( pw, ph )
      local _br = 4
      pw = pw - 2*ctrb( 4 )
      ph = ph - 1*ctrb( 4 )

      --Background
      draw.RoundedBox( 0, ctrb( _br ), 0, pw, ph, Color( 255, 255, 255, 100 ) )

      --Maxamount
      draw.RoundedBox( 0, ctrb( _br ), 0, (rol.uses/rol.maxamount) * (pw), ph, Color( 255, 0, 0, 255 ) )
      surfaceText( self:GetParent().tbl.uses .. "/" .. self:GetParent().tbl.maxamount, "roleInfoHeader", pw/2, ph/2, Color( 255, 255, 255 ), 1, 1 )

      --BR
      drawRBBR( 0, ctrb( _br ), 0, pw, ph, Color( 0, 0, 0, 255 ), ctrb( 4 ) )
    end
  end

  --[[ Role Adminonly ]]--
  if tobool( rol.adminonly ) then -- and LocalPlayer():IsAdmin() and !LocalPlayer():IsSuperAdmin() then
    _rol.aoicon = 64
    _rol.ao = createD( "DPanel", _rol, ctrb( _rol.aoicon ), ctrb( _rol.aoicon ), _rol:GetWide()/2-ctrb( _rol.aoicon/2 ), _rol:GetTall()/2-ctrb( _rol.aoicon/2 ) )
    function _rol.ao:Paint( pw, ph )
      surface.SetDrawColor( 255, 255, 255, 255 )
      surface.SetMaterial( _adminonly	)
      surface.DrawTexturedRect( 0, 0, pw, ph )
    end
  end

  --[[ Role Button ]]--
  _rol.gr = createD( "DButton", _rol, _rol:GetWide(), ctrb( 60 ), 0, _rol:GetTall()-ctrb( 60 ) )
  function _rol.gr:Paint( pw, ph )
    local _br = 4
    pw = pw - 2*ctrb( 4 )
    ph = ph - 1*ctrb( 4 )

    local _color = Color( 255, 255, 100 )
    if self:IsHovered() then
      _color = Color( 255, 255, 0 )
    end
    draw.RoundedBox( 0, ctrb( _br ), 0, pw, ph, _color )
    surfaceText( lang_string( "moreinfo" ), "roleInfoHeader", pw/2, ph/2, Color( 255, 255, 255 ), 1, 1 )

    --BR
    drawRBBR( 0, ctrb( _br ), 0, pw, ph, Color( 0, 0, 0, 255 ), ctrb( 4 ) )
  end
  _rol.gr:SetText( "" )
  function _rol.gr:DoClick()
    local _pm = string.Explode( ",", rol.playermodels )
    _rm.infopm:SetModel( _pm[1] or "" )

    _rm.info.rolename = rol.roleID

    _rm.infodesc:SetText( "" )
    _rm.infodesc:SetFontInternal( "roleInfoText" )
    _rm.infodesc:InsertColorChange( 255, 255, 255, 255 )
    _rm.infodesc:AppendText( rol.description )

    _rm.infosweps:SetText( "" )
    _rm.infosweps:SetFontInternal( "roleInfoText" )
    _rm.infosweps:InsertColorChange( 255, 255, 255, 255 )
    _rm.infosweps:AppendText( string.Implode( ", ", string.Explode( ",", rol.sweps ) ) )

    _rm.info.rolesala = rol.salary
    _rm.info.roleswep = rol.sweps

    _rm.infobutton.rolename = rol.roleID
    _rm.infobutton.uniqueID = rol.uniqueID
  end

  if parent.AddPanel != nil then
    parent:AddPanel( _rol )
  end
end

function createBouncer( parent )
  local _bou = createD( "DPanel", parent, ctrb( 50 ), ctrb( 200 ), 0, 0 )
  function _bou:Paint( pw, ph )
    surfaceText( "➔", "roleInfoHeader", pw/2, ph/2, Color( 255, 255, 255 ), 1, 1 )
  end
  if parent.AddPanel != nil then
    parent:AddPanel( _bou )
  end
end

function addPreRole( rol, parent )
  _pr[rol.uniqueID] = parent
  local _tmp = createBouncer( parent )
  createRoleBox( rol, parent )
  getPreRole( rol.uniqueID, _pr[rol.uniqueID] )
end

function getPreRole( uid, parent )
  net.Receive( "get_rol_prerole", function( len )
    local _prerole = net.ReadTable()
    if _prerole.prerole != nil then
      addPreRole( _prerole, _pr[_prerole.prerole] )
    end
  end)

  net.Start( "get_rol_prerole" )
    net.WriteString( uid )
  net.SendToServer()
end

function addRole( rol, parent )
  createRoleBox( rol, parent )
  _pr[rol.uniqueID] = parent
  if rol.uniqueID != "1" then
    getPreRole( rol.uniqueID, _pr[rol.uniqueID] )
  end
end

function addRoleRow( rol, parent )
  local _rr = createD( "DHorizontalScroller", parent.content, parent:GetWide() - 2*ctrb( parent:GetSpacing() ), ctrb( 400 ), 0, 0 )
  _rr:SetOverlap( ctrb( -30 ) )
  function _rr:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 20 ) )
  end

  addRole( rol, _rr )

  parent:Add( _rr )
end

function getRoles( uid, parent )
  net.Receive( "get_grp_roles", function( len )
    local _roles = net.ReadTable()
    for i, rol in pairs( _roles ) do
      if rol.prerole == "-1" then
        addRoleRow( rol, parent )
      elseif rol.prerole == "1" then
        addRoleRow( rol, parent )
      end
    end
    --getGroups( uid, parent )
  end)

  net.Start( "get_grp_roles" )
    net.WriteString( uid )
  net.SendToServer()

  getGroups( uid, parent )
end

function addGroup( grp, parent )
  local _grp = createD( "DYRPCollapsibleCategory", parent, parent:GetWide() - ctrb( 40 ), ctrb( 200 ), ctrb( 0 ), ctrb( 0 ) )
  _grp:SetHeader( grp.groupID )
  _grp:SetSpacing( 30 )
  _grp.color = string.Explode( ",", grp.color )
  _grp.color = Color( _grp.color[1], _grp.color[2], _grp.color[3] )
  _grp.tbl = grp
  function _grp:PaintHeader( pw, ph )
    local _hl = 0
    if self.header:IsHovered() then
      _hl = 70
    end
    draw.RoundedBoxEx( ctrb( 30 ), 0, 0, pw, ph, Color( self.color.r + _hl, self.color.g + _hl, self.color.b + _hl ), true, true, !self:IsOpen(), !self:IsOpen() )
    surfaceText( self.tbl.groupID, "roleInfoHeader", ph/2, ph/2, Color( 255, 255, 255 ), 0, 1 )

    local _box = ctrb( 50 )
    local _dif = 50
    local _br = (ph - _box)/2
    local _tog = "▼"
    if self:IsOpen() then
      _tog = "▲"
    end
    draw.RoundedBox( 0, pw - _box - _br, _br, _box, _box, Color( self.color.r - _dif, self.color.g - _dif, self.color.b - _dif ) )
    surfaceText( _tog, "roleInfoHeader", pw - _box/2 - _br, _br + _box/2, Color( 255, 255, 255 ), 1, 1 )
  end
  function _grp:PaintContent( pw, ph )
    draw.RoundedBoxEx( ctrb( 30 ), 0, 0, pw, ph, Color( self.color.r+40, self.color.g+40, self.color.b+40 ), false, false, true, true )
  end
  _grp:SetHeaderHeight( ctrb( 100 ) )

  function _grp:DoClick()
    if self:IsOpen() then
      getRoles( grp.uniqueID, _grp )
    else
      self:ClearContent()
    end
  end

  if grp.uppergroup != "-1" then
    parent:Add( _grp )
  else
    parent:AddItem( _grp )
  end
  --parent:Rebuild()

  return _grp
end

function getGroups( uid, parent )
  net.Receive( "get_grps", function( len )
    local _groups = net.ReadTable()
    for i, grp in pairs( _groups ) do
      addGroup( grp, parent )
    end
  end)

  net.Start( "get_grps" )
    net.WriteString( uid )
  net.SendToServer()
end

function openRoleMenu()
  openMenu()

  _rm = createD( "DFrame", nil, BScrW(), ScrH(), 0, 0 )
  _rm:Center()
  _rm:ShowCloseButton( false )
  _rm:SetDraggable( false )
  _rm:SetTitle( lang_string( "rolemenu" ) )
  function _rm:Paint( pw, ph )
    --paintWindow( self, pw, ph, "" )
  end

  _rm.close = createD( "DButton", _rm, ctrb( 50), ctrb( 50 ), _rm:GetWide()-ctrb( 50+10 ), ctrb( 10 ) )
  _rm.close:SetText( "" )
  function _rm.close:Paint( pw, ph )
    self.color = Color( 255, 255, 255 )
    if self:IsHovered() then
      self.color = Color( 255, 255, 0 )
    end
    draw.RoundedBox( 0, 0, 0, pw, ph, self.color )
    surfaceText( "X", "roleInfoHeader", pw/2, ph/2, Color( 255, 255, 255 ), 1, 1 )
  end
  function _rm.close:DoClick()
    _rm:Close()
  end

  _rm.info = createD( "DPanel", _rm, ctrb( 800 ), ScrH() - ctrb( 60 ), BScrW() - ctrb( 10 ) - ctrb( 800 ), ctrb( 50 ) )
  _rm.info.rolename = lang_string( "none" )
  _rm.info.rolesala = lang_string( "none" )
  function _rm.info:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 180 ) )

    --[[ Role Appearance ]]--
    draw.RoundedBox( 0, 0, 0, pw, ctrb( 50 ), Color( 0, 255, 0, 255 ) )
    surfaceText( lang_string( "appearance" ), "roleInfoHeader", ctrb( 25 ), ctrb( 25 ), Color( 255, 255, 255 ), 0, 1 )
    --draw.RoundedBox( 0, 0, ctrb( 50 ), pw, pw, Color( 0, 0, 0, 200 ) )

    --[[ Role Name ]]--
    draw.RoundedBox( 0, 0, ctrb( 900 ), pw, ctrb( 50 ), Color( 0, 255, 0, 255 ) )
    surfaceText( lang_string( "role" ), "roleInfoHeader", ctrb( 25 ), ctrb( 900 + 25 ), Color( 255, 255, 255 ), 0, 1 )
    draw.RoundedBox( 0, 0, ctrb( 900+50 ), pw, ctrb( 50 ), Color( 0, 0, 0, 200 ) )
    surfaceText( self.rolename, "roleInfoText", ctrb( 25 ), ctrb( 900 + 50 + 25 ), Color( 255, 255, 255 ), 0, 1 )

    --[[ Role Description ]]--
    draw.RoundedBox( 0, 0, ctrb( 1050 ), pw, ctrb( 50 ), Color( 0, 255, 0, 255 ) )
    surfaceText( lang_string( "description" ), "roleInfoHeader", ctrb( 25 ), ctrb( 1050 + 25 ), Color( 255, 255, 255 ), 0, 1 )

    --[[ Role Equipment ]]--
    draw.RoundedBox( 0, 0, ctrb( 1450 ), pw, ctrb( 50 ), Color( 0, 255, 0, 255 ) )
    surfaceText( lang_string( "sweps" ), "roleInfoHeader", ctrb( 25 ), ctrb( 1450 + 25 ), Color( 255, 255, 255 ), 0, 1 )

    --[[ Role Salary ]]--
    draw.RoundedBox( 0, 0, ctrb( 1850 ), pw, ctrb( 50 ), Color( 0, 255, 0, 255 ) )
    surfaceText( lang_string( "salary" ), "roleInfoHeader", ctrb( 25 ), ctrb( 1850 + 25 ), Color( 255, 255, 255 ), 0, 1 )
    draw.RoundedBox( 0, 0, ctrb( 1850+50 ), pw, ctrb( 50 ), Color( 0, 0, 0, 200 ) )
    surfaceText( self.rolesala, "roleInfoText", ctrb( 25 ), ctrb( 1850 + 50 + 25 ), Color( 255, 255, 255 ), 0, 1 )
  end
  _rm.infopm = createD( "DModelPanel", _rm.info, ctrb( 800 ), ctrb( 800 ), 0, ctrb( 50 ) )

  _rm.infodesc = createD( "RichText", _rm.info, ctrb( 800 ), ctrb( 300 ), 0, ctrb( 1050+50 ) )
  function _rm.infodesc:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 200 ) )
  end

  _rm.infosweps = createD( "RichText", _rm.info, ctrb( 800 ), ctrb( 300 ), 0, ctrb( 1450+50 ) )
  function _rm.infosweps:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 200 ) )
  end

  _rm.infobutton = createD( "DButton", _rm.info, ctrb( 800-20 ), ctrb( 100 ), ctrb( 10 ), _rm.info:GetTall() - ctrb( 100+10 ) )
  _rm.infobutton:SetText( "" )
  _rm.infobutton.rolename = ""
  function _rm.infobutton:Paint( pw, ph )
    self.text = lang_string( "none" )
    self.color = Color( 255, 255, 255 )
    if self.rolename != "" then
      self.text = lang_string( "getrole" )
      if self:IsHovered() then
        self.color = Color( 255, 255, 0 )
      end
    end
    draw.RoundedBox( 0, 0, 0, pw, ph, self.color )
    surfaceText( self.text, "roleInfoHeader", pw/2, ph/2, Color( 255, 255, 255 ), 1, 1 )
  end
  function _rm.infobutton:DoClick()
    if self.uniqueID != nil then
      net.Start( "wantRole" )
        net.WriteInt( self.uniqueID, 16 )
      net.SendToServer()
      _rm:Close()
    end
  end

  _rm.pl = createD( "DPanelList", _rm, BScrW() - ctrb( 10+10+10 ) - ctrb( 800 ), ScrH() - ctrb( 60 ), ctrb( 10 ), ctrb( 50 ) )
  _rm.pl:EnableVerticalScrollbar( true )
  _rm.pl:SetSpacing( 10 )
  _rm.pl:SetNoSizing( true )

  function _rm.pl:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 180 ) )
  end

  getGroups( -1, _rm.pl )



  _rm:MakePopup()
end
