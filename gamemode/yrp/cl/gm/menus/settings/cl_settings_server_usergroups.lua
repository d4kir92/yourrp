--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local ply = LocalPlayer()

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

  PARENT.ug = createD( "DPanel", PARENT, ScrW() - ctr( 20 + 500 + 20 ), ScrH() - ctr( 100 + 10 + 10 ), ctr( 20 + 500 ), ctr( 0 ) )
  function PARENT.ug:Paint( pw, ph )
    --surfaceBox( 0, 0, pw, ph, Color( 255, 255, 255, 100 ) )
  end

  PARENT = PARENT.ug

  -- NAME
  local NAME = createD( "DYRPPanelPlus", PARENT, ctr( 500 ), ctr( 100 ), ctr( 20 ), ctr( 20 ) )
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

  -- COLOR
  local COLOR = createD( "DYRPPanelPlus", PARENT, ctr( 500 ), ctr( 100 ), ctr( 20 ), ctr( 20 + 100 + 20 ) )
  COLOR:INITPanel( "DButton" )
  COLOR:SetHeader( lang_string( "color" ) )
  COLOR.plus:SetText( "" )
  function COLOR.plus:Paint( pw, ph )
    surfaceButton( self, pw, ph, lang_string( "change" ), StringToColor( UGS[CURRENT_USERGROUP].color ) )
  end
  function COLOR.plus:DoClick()
    local window = createD( "DFrame", nil, ctr( 20 + 500 + 20 ), ctr( 50 + 20 + 500 + 20 ), 0, 0 )
    window:Center()
    window:MakePopup()
    window:SetTitle( "" )
    function window:Paint( pw, ph )
      surfaceWindow( self, pw, ph, lang_string( "color" ) )
      if !pa( PARENT ) then
        self:Remove()
      end
    end
    window.cm = createD( "DColorMixer", window, ctr( 500 ), ctr( 500 ), ctr( 20 ), ctr( 50 + 20 ) )
    function window.cm:ValueChanged( col )
      UGS[CURRENT_USERGROUP].color = TableToColorStr( col )
      net.Start( "usergroup_update_color" )
        net.WriteString( CURRENT_USERGROUP )
        net.WriteString( UGS[CURRENT_USERGROUP].color )
      net.SendToServer()
    end
  end
  net.Receive( "usergroup_update_color", function( len )
    local color = net.ReadString()
    UGS[CURRENT_USERGROUP].color = color
  end)

  -- ICON
  local ICON = createD( "DYRPPanelPlus", PARENT, ctr( 500 ), ctr( 100 ), ctr( 20 ), ctr( 20 + 100 + 20 + 100 + 20 ) )
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

  -- SWEPS
  ug.sweps = string.Explode( ",", ug.sweps )

  local SWEPS = createD( "DYRPPanelPlus", PARENT, ctr( 500 ), ctr( 50 + 500 + 50 ), ctr( 20 ), ctr( 20 + 100 + 20 + 100 + 20 + 100 + 20 ) )
  SWEPS:INITPanel( "DPanel" )
  SWEPS:SetHeader( lang_string( "weapons" ) .. " [" .. lang_string( "wip" ) .. "]" )
  SWEPS:SetText( ug.icon )
  function SWEPS.plus:Paint( pw, ph )
    surfaceBox( 0, 0, pw, ph, Color( 80, 80, 80, 255 ) )
  end

  SWEPS.preview = createD( "DModelPanel", SWEPS, ctr( 500 ), ctr( 500 ), ctr( 0 ), ctr( 50 ) )
  if ug.sweps[1] != "" then
    SWEPS.preview:SetModel( GetSWEPWorldModel( ug.sweps[1] ) )
    SWEPS.preview.cur = 1
    SWEPS.preview.max = #ug.sweps
  else
    SWEPS.preview.cur = 0
    SWEPS.preview.max = 0
  end
  SWEPS.preview:SetLookAt( Vector( 0, 0, 10 ) )
  SWEPS.preview:SetCamPos( Vector( 0, 0, 10 ) - Vector( -40, -20, -20 ) )
  SWEPS.preview:SetAnimated( true )
  SWEPS.preview.Angles = Angle( 0, 0, 0 )
  function SWEPS.preview:DragMousePress()
		self.PressX, self.PressY = gui.MousePos()
		self.Pressed = true
	end
  function SWEPS.preview:DragMouseRelease()
    self.Pressed = false
  end
  function SWEPS.preview:LayoutEntity( ent )
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
  function SWEPS.preview:PaintOver( pw, ph )
    if self.oldcur != self.cur then
      self.oldcur = self.cur
      self:SetModel( GetSWEPWorldModel( UGS[CURRENT_USERGROUP].sweps[self.cur] ) )
    end
    surfaceText( self.cur .. "/" .. self.max, "mat1text", pw/2, ph - ctr( 25 ), Color( 255, 255, 255 ), 1, 1 )
  end

  SWEPS.preview.prev = createD( "DButton", SWEPS.preview, ctr( 50 ), ctr( 50 ), ctr( 0 ), ctr( 500 - 50 )/2 )
  SWEPS.preview.prev:SetText( "" )
  function SWEPS.preview.prev:Paint( pw, ph )
    if SWEPS.preview.cur > 1 then
      surfaceButton( self, pw, ph, lang_string( "<" ) )
    end
  end
  function SWEPS.preview.prev:DoClick()
    if SWEPS.preview.cur > 1 then
      SWEPS.preview.cur = SWEPS.preview.cur - 1
    end
  end

  SWEPS.preview.next = createD( "DButton", SWEPS.preview, ctr( 50 ), ctr( 50 ), ctr( 500 - 50 ), ctr( 500 - 50 )/2 )
  SWEPS.preview.next:SetText( "" )
  function SWEPS.preview.next:Paint( pw, ph )
    if SWEPS.preview.cur < SWEPS.preview.max then
      surfaceButton( self, pw, ph, lang_string( ">" ) )
    end
  end
  function SWEPS.preview.next:DoClick()
    if SWEPS.preview.cur < SWEPS.preview.max then
      SWEPS.preview.cur = SWEPS.preview.cur + 1
    end
  end

  SWEPS.button = createD( "DButton", SWEPS, ctr( 500 ), ctr( 50 ), ctr( 0 ), ctr( 50 + 500 ) )
  SWEPS.button:SetText( "" )
  function SWEPS.button:Paint( pw, ph )
    surfaceButton( self, pw, ph, lang_string( "change" ) )
  end
  function SWEPS.button:DoClick()
    OpenSelector( GetSWEPsList(), ug.sweps, "selector_usergroup_sweps" )
    hook.Add( "selector_usergroup_sweps", "selector_usergroup_sweps", function()
      local sweps = ply:GetNWString( "global_working", "" )

      net.Start( "usergroup_update_sweps" )
        net.WriteString( CURRENT_USERGROUP )
        net.WriteString( sweps )
      net.SendToServer()
    end)
  end

  net.Receive( "usergroup_update_sweps", function( len )
    local sweps = net.ReadString()
    UGS[CURRENT_USERGROUP].sweps = string.Explode( ",", sweps )
    if UGS[CURRENT_USERGROUP].sweps[1] != "" then
      SWEPS.preview.cur = 1
      SWEPS.preview.max = #UGS[CURRENT_USERGROUP].sweps
      SWEPS.preview:SetModel( GetSWEPWorldModel( UGS[CURRENT_USERGROUP].sweps[1] or "" ) )
    else
      SWEPS.preview.cur = 0
      SWEPS.preview.max = 0
      SWEPS.preview:SetModel( "" )
    end
  end)

  -- ENTITIES
  ug.sents = string.Explode( ";", ug.sents )

  ug.dsents = {}
  ug.cur_sent = nil

  local ENTITIES = createD( "DYRPPanelPlus", PARENT, ctr( 500 ), ctr( 50 + 500 ), ctr( 20 ), ctr( 20 + 100 + 20 + 100 + 20 + 100 + 20 + 600 + 20 ) )
  ENTITIES:INITPanel( "DPanelList" )
  ENTITIES:SetHeader( lang_string( "entities" ) .. " [" .. lang_string( "wip" ) .. "]" )
  ENTITIES:SetText( ug.icon )
  function ENTITIES.plus:Paint( pw, ph )
    surfaceBox( 0, 0, pw, ph, Color( 80, 80, 80, 255 ) )
  end
  ENTITIES.plus:EnableVerticalScrollbar( true )

  function AddSENT( amount, cname )
    if amount != nil and cname != nil then
      cname = tostring( cname )
      amount = tonumber( amount )
      if ug.dsents[cname] == nil then
        ug.dsents[cname] = createD( "DButton", ENTITIES.plus, ENTITIES.plus:GetWide(), ctr( 100 ), 0, 0 )
        local SENT = ug.dsents[cname]
        SENT:SetText( "" )
        SENT.cname = cname
        SENT.amount = amount
        function SENT:Paint( pw, ph )
          surfaceButton( self, pw, ph, "[" .. self.amount .. "x] " .. self.cname, nil, ctr( 50 + 10 + 10 ), ph/2, 0, 1 )
          if self.cname == ug.cur_sent then
            surfaceSelected( self, pw - ctr( 50 ), ph, ctr( 50 ) )
          end
        end
        function SENT:DoClick()
          ug.cur_sent = self.cname
        end

        SENT.UP = createD( "DButton", SENT, ctr( 50 ), ctr( 50 ), 0, 0 )
        SENT.UP:SetText( "" )
        function SENT.UP:Paint( pw, ph )
          if SENT.amount < 100 then
            surfaceButton( self, pw, ph, "↑" )
          end
        end
        function SENT.UP:DoClick()
          if SENT.amount < 100 then
            net.Start( "usergroup_sent_up" )
              net.WriteString( CURRENT_USERGROUP )
              net.WriteString( SENT.cname )
            net.SendToServer()
          end
        end
        net.Receive( "usergroup_sent_up", function( len )
          local sents = net.ReadString()
          sents = SENTSTable( sents )
          for cname, amount in pairs( sents ) do
            ug.dsents[cname].amount = tonumber( amount )
          end
        end)

        SENT.DN = createD( "DButton", SENT, ctr( 50 ), ctr( 50 ), 0, ctr( 50 ) )
        SENT.DN:SetText( "" )
        function SENT.DN:Paint( pw, ph )
          if SENT.amount > 1 then
            surfaceButton( self, pw, ph, "↓" )
          end
        end
        function SENT.DN:DoClick()
          if SENT.amount > 1 then
            net.Start( "usergroup_sent_dn" )
              net.WriteString( CURRENT_USERGROUP )
              net.WriteString( SENT.cname )
            net.SendToServer()
          end
        end
        net.Receive( "usergroup_sent_dn", function( len )
          local sents = net.ReadString()
          sents = SENTSTable( sents )
          for cname, amount in pairs( sents ) do
            ug.dsents[cname].amount = tonumber( amount )
          end
        end)

        ENTITIES.plus:AddItem( SENT )
      end
    end
  end

  for i, sent in pairs( ug.sents ) do
    if sent != "" then
      sent = string.Explode( ",", sent )
      AddSENT( sent[1], sent[2] )
    end
  end

  ENTITIES.add = createD( "DButton", PARENT, ctr( 250 ), ctr( 50 ), ctr( 20 ), ctr( 20 + 100 + 20 + 100 + 20 + 100 + 20 + 600 + 20 + 550 ) )
  ENTITIES.add:SetText( "" )
  function ENTITIES.add:Paint( pw, ph )
    surfaceButton( self, pw, ph, "+", Color( 0, 255, 0, 255 ) )
  end
  function ENTITIES.add:DoClick()
    OpenSingleSelector( GetSENTsList(), "selector_usergroup_sents" )
    hook.Add( "selector_usergroup_sents", "selector_usergroup_sents", function()
      local sent = ply:GetNWString( "ClassName", "" )

      net.Start( "usergroup_add_sent" )
        net.WriteString( CURRENT_USERGROUP )
        net.WriteString( sent )
      net.SendToServer()
    end)
  end
  net.Receive( "usergroup_add_sent", function( len )
    local sents = net.ReadString()
    sents = string.Explode( ";", sents )
    for i, sent in pairs( sents ) do
      sent = string.Explode( ",", sent )
      AddSENT( sent[1], sent[2] )
    end
  end)

  ENTITIES.rem = createD( "DButton", PARENT, ctr( 250 ), ctr( 50 ), ctr( 20 + 250 ), ctr( 20 + 100 + 20 + 100 + 20 + 100 + 20 + 600 + 20 + 550 ) )
  ENTITIES.rem:SetText( "" )
  function ENTITIES.rem:Paint( pw, ph )
    if ug.cur_sent != nil then
      surfaceButton( self, pw, ph, "-", Color( 255, 0, 0, 255 ) )
    end
  end
  function ENTITIES.rem:DoClick()
    if ug.cur_sent != nil then
      net.Start( "usergroup_rem_sent" )
        net.WriteString( CURRENT_USERGROUP )
        net.WriteString( ug.cur_sent )
      net.SendToServer()
    end
  end
  net.Receive( "usergroup_rem_sent", function( len )
    local cname = net.ReadString()
    ug.dsents[cname]:Remove()
  end)

  local ACCESS = createD( "DYRPPanelPlus", PARENT, ctr( 800 ), ScrH() - ctr( 100 + 10 + 10 ), ctr( 20 + 500 + 20 ), ctr( 20 ) )
  ACCESS:INITPanel( "DPanelList" )
  ACCESS:SetHeader( lang_string( "accesssettings" ) )
  function ACCESS.plus:Paint( pw, ph )
    surfaceBox( 0, 0, pw, ph, Color( 80, 80, 80, 255 ) )
  end
  ACCESS.plus:EnableVerticalScrollbar( true )

  function ACCESSAddCheckBox( name, lstr, color )
    local tmp = createD( "DPanel", PARENT, ctr( 800 ), ctr( 50 ), 0, 0 )
    function tmp:Paint( pw, ph )
      surfacePanel( self, pw, ph, lang_string( lstr ), color, ctr( 50 + 10 ), nil, 0, 1 )
    end
    tmp.cb = createD( "DCheckBox", tmp, ctr( 50 ), ctr( 50 ), 0, 0 )
    tmp.cb:SetValue( ug[name] )
    function tmp.cb:Paint( pw, ph )
      surfaceCheckBox( self, pw, ph, "done" )
    end
    function tmp.cb:OnChange( bVal )
      net.Start( "usergroup_update_" .. name )
        net.WriteString( CURRENT_USERGROUP )
        net.WriteString( btn( bVal ) )
      net.SendToServer()
    end

    ACCESS.plus:AddItem( tmp )
  end
  function ACCESSAddHr()
    local tmp = createD( "DPanel", PARENT, ctr( 800 ), ctr( 4+4+4 ), 0, 0 )
    function tmp:Paint( pw, ph )
      surfacePanel( self, pw, ph, "" )
      surfaceBox( 0, ctr( 4 ), pw, ctr( 4 ), Color( 0, 0, 0, 255 ) )
    end
    ACCESS.plus:AddItem( tmp )
  end
  ACCESSAddCheckBox( "adminaccess", "yrp_adminaccess", Color( 255, 255, 0, 255 ) )
  ACCESSAddHr()
  ACCESSAddCheckBox( "general", "settings_general" )
  ACCESSAddCheckBox( "interface", "settings_surface" )
  ACCESSAddCheckBox( "realistic", "settings_realistic" )
  ACCESSAddCheckBox( "money", "settings_money" )
  ACCESSAddCheckBox( "licenses", "settings_licenses" )
  ACCESSAddCheckBox( "shops", "settings_shops" )
  ACCESSAddCheckBox( "map", "settings_map" )
  ACCESSAddHr()
  ACCESSAddCheckBox( "feedback", "settings_feedback" )
  ACCESSAddHr()
  ACCESSAddCheckBox( "usergroups", "settings_usergroups", Color( 255, 0, 0, 255 ) )
  ACCESSAddCheckBox( "groupsandroles", "settings_groupsandroles" )
  ACCESSAddCheckBox( "players", "settings_players" )

  local GAMEPLAY = createD( "DYRPPanelPlus", PARENT, ctr( 800 ), ScrH() - ctr( 100 + 10 + 10 ), ctr( 20 + 500 + 20 + 800 + 20 ), ctr( 20 ) )
  GAMEPLAY:INITPanel( "DPanelList" )
  GAMEPLAY:SetHeader( lang_string( "gameplayrestrictions" ) )
  function GAMEPLAY.plus:Paint( pw, ph )
    surfaceBox( 0, 0, pw, ph, Color( 80, 80, 80, 255 ) )
  end
  GAMEPLAY.plus:EnableVerticalScrollbar( true )

  function GAMEPLAYAddCheckBox( name, lstr )
    local tmp = createD( "DPanel", PARENT, ctr( 800 ), ctr( 50 ), 0, 0 )
    function tmp:Paint( pw, ph )
      surfacePanel( self, pw, ph, lang_string( lstr ), nil, ctr( 50 + 10 ), nil, 0, 1 )
    end
    tmp.cb = createD( "DCheckBox", tmp, ctr( 50 ), ctr( 50 ), 0, 0 )
    tmp.cb:SetValue( ug[name] )
    function tmp.cb:Paint( pw, ph )
      surfaceCheckBox( self, pw, ph, "done" )
    end
    function tmp.cb:OnChange( bVal )
      net.Start( "usergroup_update_" .. name )
        net.WriteString( CURRENT_USERGROUP )
        net.WriteString( btn( bVal ) )
      net.SendToServer()
    end

    GAMEPLAY.plus:AddItem( tmp )
  end
  function GAMEPLAYAddHr()
    local tmp = createD( "DPanel", PARENT, ctr( 800 ), ctr( 4+4+4 ), 0, 0 )
    function tmp:Paint( pw, ph )
      surfacePanel( self, pw, ph, "" )
      surfaceBox( 0, ctr( 4 ), pw, ctr( 4 ), Color( 0, 0, 0, 255 ) )
    end
    GAMEPLAY.plus:AddItem( tmp )
  end
  GAMEPLAYAddCheckBox( "vehicles", "gp_vehicles" )
  GAMEPLAYAddCheckBox( "weapons", "gp_weapons" )
  GAMEPLAYAddCheckBox( "entities", "gp_entities" )
  GAMEPLAYAddCheckBox( "effects", "gp_effects" )
  GAMEPLAYAddCheckBox( "npcs", "gp_npcs" )
  GAMEPLAYAddCheckBox( "props", "gp_props" )
  GAMEPLAYAddCheckBox( "ragdolls", "gp_ragdolls" )
  GAMEPLAYAddHr()
  GAMEPLAYAddCheckBox( "noclip", "gp_noclip" )
  GAMEPLAYAddCheckBox( "removetool", "gp_removetool" )
  GAMEPLAYAddCheckBox( "dynamitetool", "gp_dynamitetool" )
  GAMEPLAYAddCheckBox( "ignite", "gp_ignite" )
  GAMEPLAYAddCheckBox( "drive", "gp_drive" )
  GAMEPLAYAddHr()
  GAMEPLAYAddCheckBox( "collision", "gp_collision" )
  GAMEPLAYAddCheckBox( "gravity", "gp_gravity" )
  GAMEPLAYAddCheckBox( "keepupright", "gp_keepupright" )
  GAMEPLAYAddCheckBox( "bodygroups", "gp_bodygroups" )
  GAMEPLAYAddHr()
  GAMEPLAYAddCheckBox( "physgunpickup", "gp_physgunpickup" )
  GAMEPLAYAddCheckBox( "physgunpickupplayer", "gp_physgunpickupplayers" )
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
    surfaceButton( self, pw, ph, string.upper( UGS[self.uid].name ), self.color, ph + ctr( 20 ), ph/2, 0, 1 )

    if UGS[tonumber( tbl.uniqueID )].icon == "" then
      surfaceBox( ctr( 4 ), ctr( 4 ), ph - ctr( 8 ), ph - ctr( 8 ), Color( 255, 255, 255, 255 ) )
    end
    if self.uid == tonumber( CURRENT_USERGROUP ) then
      surfaceSelected( self, pw - ph, ph, ph )
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
    if DUGS[tonumber( ug.uniqueID )] == nil and tobool( ug.removeable ) then
      AddUG( ug )
    end
  end
end)

net.Receive( "Connect_Settings_UserGroups", function( len )
  if pa( settingsWindow ) then
    if pa( settingsWindow.window ) then
      function settingsWindow.window.site:Paint( pw, ph )
        draw.RoundedBox( 4, 0, 0, pw, ph, Color( 0, 0, 0, 254 ) )

        surfaceText( lang_string( "wip" ), "mat1text", pw - ctr( 400 ), ph - ctr( 100 ), Color( 255, 255, 255 ), 1, 1 )
      end

      CURRENT_USERGROUP = nil

      local ugs = net.ReadTable()

      local PARENT = settingsWindow.window.site

      function PARENT:OnRemove()
        net.Start( "Disconnect_Settings_UserGroups" )
        net.SendToServer()
      end

      --[[ UserGroups Action Buttons ]]--
      local _ug_add = createD( "DButton", PARENT, ctr( 50 ), ctr( 50 ), ctr( 20 ), ctr( 20 ) )
      _ug_add:SetText( "" )
      function _ug_add:Paint( pw, ph )
        surfaceButton( self, pw, ph, "+", Color( 0, 255, 0, 255 ) )
      end
      function _ug_add:DoClick()
        net.Start( "usergroup_add" )
        net.SendToServer()
      end

      local _ug_rem = createD( "DButton", PARENT, ctr( 50 ), ctr( 50 ), ctr( 20 + 500 - 50 ), ctr( 20 ) )
      _ug_rem:SetText( "" )
      function _ug_rem:Paint( pw, ph )
        if CURRENT_USERGROUP != nil then
          if tobool( UGS[CURRENT_USERGROUP].removeable ) then
            surfaceButton( self, pw, ph, "-", Color( 255, 0, 0, 255 ) )
          end
        end
      end
      function _ug_rem:DoClick()
        if CURRENT_USERGROUP != nil then
          if tobool( UGS[CURRENT_USERGROUP].removeable ) then
            net.Start( "usergroup_rem" )
              net.WriteString( CURRENT_USERGROUP )
            net.SendToServer()
          end
        end
      end

      local _ugs_title = createD( "DPanel", PARENT, ctr( 500 ), ctr( 50 ), ctr( 20 ), ctr( 20 + 50 + 20 ) )
      function _ugs_title:Paint( pw, ph )
        surfacePanel( self, pw, ph, lang_string( "usergroup" ) )
      end

      --[[ UserGroupsList ]]--
      PARENT.ugs = createD( "DPanelList", PARENT, ctr( 500 ), ScrH() - ctr( 20 + 150 + 20 + 50 + 20 ), ctr( 20 ), ctr( 20 + 50 + 20 + 50 ) )
      function PARENT.ugs:Paint( pw, ph )
        surfaceBox( 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
      end
      PARENT.ugs:EnableVerticalScrollbar( true )

      for i, ug in pairs( ugs ) do
        if tobool( ug.removeable ) then
          AddUG( ug )
        end
      end
    end
  end
end)

hook.Add( "open_server_usergroups", "open_server_usergroups", function()
  SaveLastSite()
  if pa( settingsWindow ) then
    if pa( settingsWindow.window ) then
      local w = settingsWindow.window.sitepanel:GetWide()
      local h = settingsWindow.window.sitepanel:GetTall()

      settingsWindow.window.site = createD( "DPanel", settingsWindow.window.sitepanel, w, h, 0, 0 )

      net.Start( "Connect_Settings_UserGroups" )
      net.SendToServer()
    end
  end
end)
