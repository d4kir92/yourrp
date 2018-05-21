--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local UGS = UGS or {}

local CURRENT_USERGROUP = nil

local DUGS = DUGS or {}

net.Receive( "Connect_Settings_UserGroup", function( len )
  local ug = net.ReadTable()
  CURRENT_USERGROUP = tonumber( ug.uniqueID )
  UGS[CURRENT_USERGROUP] = ug

  local PARENT = settingsWindow.window.site

  if pa( PARENT.ug ) then
    PARENT.ug:Remove()
  end

  PARENT.ug = createD( "DPanel", PARENT, ctr( 10+500+10+500+10+500+10 ), ctr( 1000 ), ctr( 10 + 500 + 10 ), ctr( 10 ) )
  function PARENT.ug:Paint( pw, ph )
    surfaceBox( 0, 0, pw, ph, Color( 255, 255, 255, 100 ) )
  end

  PARENT = PARENT.ug

  local NAME = createD( "DYRPPanelPlus", PARENT, ctr( 500 ), ctr( 100 ), ctr( 10 ), ctr( 10 ) )
  NAME:INITPanel( "DTextEntry" )
  NAME:SetHeader( lang_string( "name" ) )
  NAME:SetText( ug.name )
  function NAME.plus:OnChange()
    UGS[CURRENT_USERGROUP].name = self:GetText()
    net.Start( "usergroup_update_name" )
      net.WriteString( CURRENT_USERGROUP )
      net.WriteString( self:GetText() )
    net.SendToServer()
  end
  net.Receive( "usergroup_update_name", function( len )
    local name = net.ReadString()
    UGS[CURRENT_USERGROUP].name = name
    NAME:SetText( UGS[CURRENT_USERGROUP].name )
  end)

  local COLOR = createD( "DYRPPanelPlus", PARENT, ctr( 500 ), ctr( 100 ), ctr( 10 ), ctr( 10 + 100 + 10 ) )
  COLOR:INITPanel( "DButton" )
  COLOR:SetHeader( lang_string( "color" ) )
  COLOR.plus:SetText( "" )
  function COLOR.plus:Paint( pw, ph )
    surfaceButton( self, pw, ph, lang_string( "change" ), StringToColor( UGS[CURRENT_USERGROUP].color ) )
  end
  function COLOR.plus:DoClick()
    local window = createD( "DFrame", nil, ctr( 10 + 500 + 10 ), ctr( 50 + 10 + 500 + 10 ), 0, 0 )
    window:Center()
    window:MakePopup()
    window:SetTitle( "" )
    function window:Paint( pw, ph )
      surfaceWindow( self, pw, ph, lang_string( "color" ) )
      if !pa( PARENT ) then
        self:Remove()
      end
    end
    window.cm = createD( "DColorMixer", window, ctr( 500 ), ctr( 500 ), ctr( 10 ), ctr( 50 + 10 ) )
    function window.cm:ValueChanged( col )
      UGS[CURRENT_USERGROUP].color = TableToColorStr( col )
      net.Start( "usergroup_update_color" )
        net.WriteString( CURRENT_USERGROUP )
        net.WriteString( UGS[CURRENT_USERGROUP].color )
      net.SendToServer()
    end
  end

  local ICON = createD( "DYRPPanelPlus", PARENT, ctr( 500 ), ctr( 100 ), ctr( 10 ), ctr( 10 + 100 + 10 + 100 + 10 ) )
  ICON:INITPanel( "DTextEntry" )
  ICON:SetHeader( lang_string( "icon" ) )
  ICON:SetText( ug.icon )
  function ICON.plus:OnChange()
    UGS[CURRENT_USERGROUP].icon = self:GetText()
    net.Start( "usergroup_update_icon" )
      net.WriteString( CURRENT_USERGROUP )
      net.WriteString( self:GetText() )
    net.SendToServer()
  end
  net.Receive( "usergroup_update_icon", function( len )
    local icon = net.ReadString()
    UGS[CURRENT_USERGROUP].icon = icon
    ICON:SetText( UGS[CURRENT_USERGROUP].icon )
  end)
  net.Receive( "usergroup_update_color", function( len )
    local color = net.ReadString()
    UGS[CURRENT_USERGROUP].color = color
  end)
end)

function AddUG( tbl )
  local PARENT = settingsWindow.window.site

  UGS[tonumber( tbl.uniqueID )] = tbl

  DUGS[tonumber( tbl.uniqueID )] = createD( "DButton", PARENT.ugs, PARENT.ugs:GetWide(), ctr( 100 ), 0, 0 )
  local _ug = DUGS[tonumber( tbl.uniqueID )]
  _ug.uid = tonumber( tbl.uniqueID )
  _ug:SetText( "" )
  function _ug:Paint( pw, ph )
    self.color = StringToColor( UGS[self.uid].color )
    surfaceButton( self, pw, ph, string.upper( UGS[self.uid].name ), self.color, ph + ctr( 10 ), ph/2, 0, 1 )

    if UGS[tonumber( tbl.uniqueID )].icon == "" then
      surfaceBox( ctr( 4 ), ctr( 4 ), ph - ctr( 8 ), ph - ctr( 8 ), Color( 255, 255, 255, 255 ) )
    end
    if self.uid == tonumber( CURRENT_USERGROUP ) then
      surfaceSelected( self, pw, ph )
    end
  end
  function _ug:DoClick()
    if CURRENT_USERGROUP != nil then
      net.Start( "Disconnect_Settings_UserGroup" )
        net.WriteString( CURRENT_USERGROUP )
      net.SendToServer()
    end
    net.Start( "Connect_Settings_UserGroup" )
      net.WriteString( self.uid )
    net.SendToServer()
  end

  if UGS[tonumber( tbl.uniqueID )].icon != "" then
    local _icon = {}
    _icon.size = ctr( 100 - 16 )
    _icon.br = ctr( 8 )
    local html = createD( "HTML", _ug, _icon.size, _icon.size, _icon.br, _icon.br )
    html:SetHTML( GetHTMLImage( tbl.icon, _icon.size, _icon.size ) )
  end

  PARENT.ugs:AddItem( _ug )
end

function RemUG( uid )
  local PARENT = settingsWindow.window.site

  if CURRENT_USERGROUP != nil then
    net.Start( "Disconnect_Settings_UserGroup" )
      net.WriteString( CURRENT_USERGROUP )
    net.SendToServer()
  end

  DUGS[tonumber( uid )]:Remove()
end

net.Receive( "usergroup_rem", function( len )
  local uid = tonumber( net.ReadString() )
  if DUGS[uid] != nil then
    RemUG( uid )
  end
end)

net.Receive( "usergroup_add", function( len )
  local ugs = net.ReadTable()
  for i, ug in pairs( ugs ) do
    if DUGS[tonumber( ug.uniqueID )] == nil then
      AddUG( ug )
    end
  end
end)

net.Receive( "Connect_Settings_UserGroups", function( len )
  CURRENT_USERGROUP = nil

  local ply = LocalPlayer()
  local ugs = net.ReadTable()

  local PARENT = settingsWindow.window.site

  function PARENT:OnRemove()
    net.Start( "Disconnect_Settings_UserGroups" )
    net.SendToServer()
  end

  --[[ UserGroups Action Buttons ]]--
  local _ug_add = createD( "DButton", PARENT, ctr( 50 ), ctr( 50 ), ctr( 10 ), ctr( 10 ) )
  _ug_add:SetText( "" )
  function _ug_add:Paint( pw, ph )
    surfaceButton( self, pw, ph, "+", Color( 0, 255, 0, 255 ) )
  end
  function _ug_add:DoClick()
    net.Start( "usergroup_add" )
    net.SendToServer()
  end

  local _ug_rem = createD( "DButton", PARENT, ctr( 50 ), ctr( 50 ), ctr( 10 + 500 - 50 ), ctr( 10 ) )
  _ug_rem:SetText( "" )
  function _ug_rem:Paint( pw, ph )
    if CURRENT_USERGROUP != nil then
      surfaceButton( self, pw, ph, "-", Color( 255, 0, 0, 255 ) )
    end
  end
  function _ug_rem:DoClick()
    net.Start( "usergroup_rem" )
      net.WriteString( CURRENT_USERGROUP )
    net.SendToServer()
  end

  local _ugs_title = createD( "DPanel", PARENT, ctr( 500 ), ctr( 50 ), ctr( 10 ), ctr( 10 + 50 + 10 ) )
  function _ugs_title:Paint( pw, ph )
    surfacePanel( self, pw, ph, lang_string( "usergroup" ) )
  end

  --[[ UserGroupsList ]]--
  PARENT.ugs = createD( "DPanelList", PARENT, ctr( 500 ), ScrH() - ctr( 10 + 150 + 10 + 50 + 10 ), ctr( 10 ), ctr( 10 + 50 + 10 + 50 ) )
  function PARENT.ugs:Paint( pw, ph )
    surfaceBox( 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
  end

  for i, ug in pairs( ugs ) do
    AddUG( ug )
  end
end)

hook.Add( "open_server_usergroups", "open_server_usergroups", function()
  SaveLastSite()
  local ply = LocalPlayer()

  local w = settingsWindow.window.sitepanel:GetWide()
  local h = settingsWindow.window.sitepanel:GetTall()

  settingsWindow.window.site = createD( "DPanel", settingsWindow.window.sitepanel, w, h, 0, 0 )
  local _ug = string.lower( ply:GetUserGroup() )
  if _ug == "superadmin" or _ug == "owner" then
    function settingsWindow.window.site:Paint( pw, ph )
      draw.RoundedBox( 4, 0, 0, pw, ph, Color( 0, 0, 0, 254 ) )

      surfaceText( lang_string( "wip" ), "mat1text", pw/2, ph/2, Color( 255, 255, 255 ), 1, 1 )
    end

    net.Start( "Connect_Settings_UserGroups" )
    net.SendToServer()
  else
    F8RequireUG( lang_string( "restriction" ), "superadmin" )
  end
end)
