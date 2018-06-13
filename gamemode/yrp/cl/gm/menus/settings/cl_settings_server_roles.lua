--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local _w = 500
local _br = 10
local _lbr = 5

local groupID = ""
local groupUniqueID = -1

local _start_role = ""

local _i = Material( "icon16/information.png" )
function addInfoBox( parent, x, y, help )
  local tmp = createD( "DPanel", parent, ctr( 40 ), ctr( 40 ), x, y )
  function tmp:Paint( pw, ph )
    --surfaceBox( 0, 0, pw, ph, Color( 255, 0, 0 ) )
    surface.SetDrawColor( 255, 255, 255, 255 )
  	surface.SetMaterial( _i	)
  	surface.DrawTexturedRect( ctr( 4 ), ctr( 4 ), pw - ctr( 8 ), ph - ctr( 8 ) )
  end
  tmp:SetTooltip( help )
  return tmp
end

function addButton( w, h, x, y, parent )
  local tmp = createVGUI( "DButton", parent, w, h, x, y )
  tmp:SetText( "" )
  return tmp
end

function addDPanel( parent, w, h, x, y, string, dbTable, help )
  local color = Color( 100, 100, 255, 200 )
  if dbTable == "yrp_roles" then
    color = Color( 100, 255, 100, 200 )
  end
  local tmp = createVGUI( "DPanel", parent, w, h, x, y )
  function tmp:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, color )
    draw.SimpleTextOutlined( string, "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end
  local tmp2 = addInfoBox( tmp, ctr(w)-ctr( 40 ), 0, help )
  return tmp
end

function addDTextEntry( parent, w, h, x, y, string )
  local tmp = createVGUI( "DTextEntry", parent, w, h, x, y )
  if string != nil then
    tmp:SetText( string )
  else
    tmp:SetText( "failed")
  end
  return tmp
end

function addDBTextEntry( parent, w, h, x, y, stringPanel, stringTextEntry, tmpTable, dbTable, dbSets, dbWhile, help )
  local tmp = addDPanel( parent, w, h/2, x, y, stringPanel, dbTable, help )

  local tmp2 = addDTextEntry( parent, w, h/2, x, y + h/2, stringTextEntry )
  function tmp2:OnChange()
    tmpTable[dbSets] = db_sql_str( tmp2:GetText() )
    net.Start( "dbUpdate" )
      net.WriteString( dbTable )
      net.WriteString( dbSets .. " = '" .. tmpTable[dbSets] .. "'" )
      net.WriteString( dbWhile )
    net.SendToServer()
  end
end

function addDTextEntryBig( parent, w, h, x, y, string )
  local tmp = createVGUI( "DTextEntry", parent, w, h, x, y )
  if string != nil then
    tmp:SetText( string )
  else
    tmp:SetText( "failed")
  end
  return tmp
end

function addDBTextEntryBig( parent, w, h, x, y, stringPanel, stringTextEntry, tmpTable, dbTable, dbSets, dbWhile, help )
  local tmp = addDPanel( parent, w, 40, x, y, stringPanel, dbTable, help )

  local tmp2 = addDTextEntryBig( parent, w, h-40, x, y + 40, stringTextEntry )
  tmp2:SetMultiline( true )
  function tmp2:OnChange()
    local tmp = string.Replace( tmp2:GetText(), "\n", " " )
    tmp = string.Replace( tmp, "\'", "´" )
    tmp = string.Replace( tmp, "\"", "´´" )
    tmpTable[dbSets] = tmp
    net.Start( "dbUpdate" )
      net.WriteString( dbTable )
      net.WriteString( dbSets .. " = '" .. tmp .. "'" )
      net.WriteString( dbWhile )
    net.SendToServer()
  end
end

function addDCheckBox( parent, w, h, x, y, checked )
  local tmp = createVGUI( "DCheckBox", parent, w, h, x, y )
  local tmpBool = false
  if tonumber( checked ) == 1 then
    tmpBool = true
  end
  tmp:SetValue( tmpBool )
  return tmp
end

function addDBCheckBox( parent, w, h, x, y, stringPanel, checked, tmpTable, dbTable, dbSets, dbWhile, help )
  local tmp = addDPanel( parent, w - h, h, x+h, y, stringPanel, dbTable, help )

  local tmp2 = addDCheckBox( parent, h, h, x, y, checked )
  function tmp2:OnChange( bVal )
    local tmpNumb = 0
    if bVal then
      tmpNumb = 1
    end
    tmpTable[dbSets] = tmpNumb
    net.Start( "dbUpdate" )
      net.WriteString( dbTable )
      net.WriteString( dbSets .. " = " .. tmpTable[dbSets] .. "" )
      net.WriteString( dbWhile )
    net.SendToServer()
  end
end

function addDBLicenses( parent, w, h, x, y, stringPanel, checked, tmpTable, dbTable, dbSets, dbWhile, help )
  local tmp = createD( "DYRPPanelPlus", parent, ctr(w), ctr(h), ctr(x), ctr(y) )
  tmp.header:SetTall( ctr( h/2 ) )
  tmp.header.color = Color( 100, 255, 100, 200 )
  tmp:INITPanel( "DButton" )
  tmp:SetHeader( lang_string( "licenses" ) )
  tmp.plus:SetText( "" )
  function tmp.plus:Paint( pw, ph )
    self.color = Color( 255, 255, 255 )
    if self:IsHovered() then
      self.color = Color( 255, 255, 0 )
    end
    draw.RoundedBox( 0, 0, 0, pw, ph, self.color )
    surfaceText( lang_string( "change" ), "roleInfoHeader", pw/2, ph/2, Color( 255, 255, 255 ), 1, 1 )
  end
  function tmp.plus:DoClick()
    net.Receive( "get_role_licenses", function( len )
      local _licenses = net.ReadTable()
      local _role_licenses = string.Explode( ",", tmpTable.licenseIDs )

      local _lic = createD( "DFrame", nil, ctrb( 600 ), ctrb( 650 ), 0, 0 )
      _lic:SetTitle( "" )
      _lic:MakePopup()
      _lic:Center()
      function _lic:Paint( pw, ph )
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 200 ) )
      end

      _lic.pl = createD( "DPanelList", _lic, ctrb( 580 ), ctrb( 580 ), ctrb( 10 ), ctrb( 60 ) )
      _lic.pl:SetSpacing( 4 )
      function _lic.pl:Paint( pw, ph )
        --draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 0, 0, 200 ) )
      end

      for i, licence in pairs( _licenses ) do
        local _p = createD( "DPanel", _lic.pl, ctrb( 580 ), ctrb( 50 ), 0, 0 )
        function _p:Paint( pw, ph )
          draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 200 ) )

          surfaceText( SQL_STR_OUT( licence.name ), "roleInfoHeader", ph + ctrb( 10 ), ph/2, Color( 255, 255, 255 ), 0, 1 )
        end
        _lic.pl:AddItem( _p )

        _p.cb = createD( "DCheckBox", _p, ctrb( 50 ), ctrb( 50 ), 0, 0 )
        if table.HasValue( _role_licenses, licence.uniqueID ) then
          _p.cb:SetChecked( true )
        end
        function _p.cb:OnChange( bVal )
          if ( bVal ) then
            net.Start( "role_add_license" )
              net.WriteString( tmpTable.uniqueID )
              net.WriteString( licence.uniqueID )
            net.SendToServer()
          else
            net.Start( "role_rem_license" )
              net.WriteString( tmpTable.uniqueID )
              net.WriteString( licence.uniqueID )
            net.SendToServer()
          end
        end
      end
    end)
    net.Start( "get_role_licenses" )
    net.SendToServer()
  end
  local tmp2 = addInfoBox( tmp, ctr(w)-ctr(40), 0, help )
  return tmp
end


function toColor( string )
  local colorTable = string.Explode( ",", string )
  return Color( colorTable[1], colorTable[2], colorTable[3] )
end

function addDColorMixer( parent, w, h, x, y, color )
  local tmp = createVGUI( "DColorMixer", parent, w, h, x, y )
  tmp:SetPalette( true )
  tmp:SetAlphaBar( true )
  tmp:SetWangs( true )
  tmp:SetColor( toColor( color ) )
  return tmp
end

function addDBColorMixer( parent, w, h, x, y, color, tmpTable, dbTable, dbSets, dbWhile )
  local tmp = addDColorMixer( parent, w, h, x, y, color )
  function tmp:ValueChanged()
    local tmpColor = tmp:GetColor()
    tmpTable[dbSets] = tostring( tmpColor.r ) .. "," .. tostring( tmpColor.g ) .. "," .. tostring( tmpColor.b )
    net.Start( "dbUpdate" )
      net.WriteString( dbTable )
      net.WriteString( dbSets .. " = '" .. tmpTable[dbSets] .. "'" )
      net.WriteString( dbWhile )
    net.SendToServer()
  end
end

function addDComboBox( parent, w, h, x, y, table, value1, value2, uniqueID, string, _select )
  local tmp = createVGUI( "DComboBox", parent, w, h/2, x, y + h/2 )
  tmp:AddChoice( lang_string( "no" ) .. " " .. string, -1, false )
  local tmpFound = false
  for k, v in pairs( table ) do
    local tmpBool = false
    if _select == v[value2] then
      tmpBool = true
      tmpFound = true
    end
    tmp:AddChoice( v[value1], v[value2], tmpBool )
  end
  if !tmpFound then
    tmp:ChooseOptionID( 1 )
  end
  return tmp
end

function addDBComboBox( parent, w, h, x, y, string, table, value1, value2, tmpTable, dbTable, dbSets, dbWhile, help )
  local tmp = addDPanel( parent, w, h/2, x, y, string, dbTable, help )

  local tmp2 = addDComboBox( parent, w, h, x, y, table, value1, value2, tmpTable.uniqueID, string, tmpTable[dbSets] )
  function tmp2.OnSelect( test, index, value, data )
    tmpTable[dbSets] = data
    net.Start( "dbUpdate" )
      net.WriteString( dbTable )
      net.WriteString( dbSets .. " = " .. tmpTable[dbSets] .. "" )
      net.WriteString( dbWhile )
    net.SendToServer()
  end
end

function addDNumberWang( parent, w, h, x, y, table )
  local tmp = createVGUI( "DNumberWang", parent, w, h, x, y )
  tmp:SetMax( 999999999999 )
  tmp:SetMin( -1 )

  tmp:SetValue( table )

  return tmp
end

function addDBNumberWang( parent, w, h, x, y, string, table, tmpTable, dbTable, dbSets, dbWhile, min, max, help )
  local tmp = addDPanel( parent, w, h/2, x, y, string, dbTable, help )

  local tmp2 = addDNumberWang( parent, w, h/2, x, y + h/2, table )
  tmp2:SetMin( min or -1 )
  tmp2:SetMax( max or 999999999999 )

  function tmp2:OnValueChanged( val )
    if isnumber( val ) then
      if val >= self:GetMin() and val <= self:GetMax() then
        tmpTable[dbSets] = val
        net.Start( "dbUpdate" )
          net.WriteString( dbTable )
          net.WriteString( dbSets .. " = " .. tmpTable[dbSets] .. "" )
          net.WriteString( dbWhile )
        net.SendToServer()
      end
    end
  end
end

function pmIsFromRole( id, playermodel )
  local tmpTable = string.Explode( ",", yrp_roles_dbTable[id].playermodels )
  for k, v in pairs( tmpTable ) do
    if string.lower( tostring( v ) ) == string.lower( tostring( playermodel ) ) then
      return true
    end
  end

  return false
end

function updatePlayermodels( table, id, uniqueID )
  local tmpString = ""
  for k, v in pairs( table ) do
    if v.selected then
      if tmpString == "" then
        tmpString = v.model
      else
        tmpString = tmpString .. "," .. v.model
      end
    end
  end
  yrp_roles_dbTable[id].playermodels = tmpString
  net.Start( "dbUpdate" )
    net.WriteString( "yrp_roles" )
    net.WriteString( "playermodels = '" .. tmpString .. "'" )
    net.WriteString( "uniqueID = " .. uniqueID )
  net.SendToServer()
end

local function AddToTabRecursive( tab, folder, path, wildcard )
	local files, folders = file.Find( folder .. "*", path )
	for k, v in pairs( files ) do
		if ( !string.EndsWith( v, ".mdl" ) ) then continue end
		table.insert( tab, folder .. v )
	end

	for k, v in pairs( folders ) do
		AddToTabRecursive( tab, folder .. v .. "/", path, wildcard )
	end
end

function addDBPlayermodel( parent, id, uniqueID, size, help )
  local tmp = addDPanel( parent, 800, 50, 0, 90, lang_string( "roleplayermodel" ), "yrp_roles", help )

  local pms = combineStringTables( yrp_roles_dbTable[id].playermodels, yrp_roles_dbTable[id].playermodelsnone )
  local changepm = 1

  local background = createVGUI( "DPanel", parent, 800, 800, 0, 140 )
  function background:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 10 ) )
    if pms[changepm] != "" and pms[changepm] != nil then
      draw.SimpleTextOutlined( string.upper( player_manager.TranslateToPlayerModelName( pms[changepm] ) ), "sef", pw/2, ctr( 20 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    end
    if #pms > 1 then
      draw.SimpleTextOutlined( changepm .. "/" .. #pms, "sef", pw/2, ctr( 60 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    end
  end

  local modelpanel = createVGUI( "DModelPanel", parent, 720, 720, 40, 90+80 )
  if pms[changepm] != "" and pms[changepm] != nil then
    modelpanel:SetModel( pms[changepm] )
    if modelpanel.Entity != nil then
      modelpanel.Entity:SetModelScale( size, 0 )
    end
  end

  local buttonback = createVGUI( "DButton", parent, 80, 80, 0, 140+400-40 )
  buttonback:SetText( "" )
  function buttonback:Paint( pw, ph )
    if changepm > 1 then
      if buttonback:IsHovered() then
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 100 ) )
      else
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 100 ) )
      end
      draw.SimpleTextOutlined( "<", "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    end
  end
  function buttonback:DoClick()
    if changepm > 1 then
      changepm = changepm - 1
      modelpanel:SetModel( pms[changepm] )
    end
  end

  local buttonforward = createVGUI( "DButton", parent, 80, 80, 800-80, 140+400-40 )
  buttonforward:SetText( "" )
  function buttonforward:Paint( pw, ph )
    if changepm < #pms then
      if buttonforward:IsHovered() then
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 100 ) )
      else
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 100 ) )
      end
      draw.SimpleTextOutlined( ">", "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    end
  end
  function buttonforward:DoClick()
    if #pms > changepm then
      changepm = changepm + 1
      modelpanel:SetModel( pms[changepm] )
    end
  end

  local buttonchange = createVGUI( "DButton", parent, 390, 50, 0, 140 + 800 - 50 )
  buttonchange:SetText( "" )
  function buttonchange:Paint( pw, ph )
    if modelpanel.Entity != nil then
      if yrp_roles_dbTable[id] != nil then
        modelpanel.Entity:SetModelScale( yrp_roles_dbTable[id].playermodelsize, 0 )
      end
    end
    if buttonchange:IsHovered() then
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 200 ) )
    else
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 255, 0, 200 ) )
    end
    draw.SimpleTextOutlined( lang_string( "change" ), "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end
  function buttonchange:DoClick()
    local playermodels = player_manager.AllValidModels()
    local tmpTable = {}
    local count = 0
    for k, v in pairs( playermodels ) do
      count = count + 1
      tmpTable[count] = {}
      tmpTable[count].WorldModel = v
      tmpTable[count].ClassName = v
      tmpTable[count].PrintName = player_manager.TranslateToPlayerModelName( v )
    end

    _globalWorking = yrp_roles_dbTable[id].playermodels

    hook.Add( "closeRolePlayermodels", "yrp_close_playermodel_selector", function()
      if settingsWindow.window != nil then
        if settingsWindow.window.site != nil then
          yrp_roles_dbTable[id].playermodels = _globalWorking
          pms = combineStringTables( yrp_roles_dbTable[id].playermodels, yrp_roles_dbTable[id].playermodelsnone )
          changepm = 1
          if modelpanel != nil and modelpanel != NULL then
            local _model = pms[changepm] or ""
            modelpanel:SetModel( _model )
          end
        end
      end
    end)

    openSelector( tmpTable, "yrp_roles", "playermodels", "uniqueID = " .. uniqueID, "closeRolePlayermodels" )
  end

  local buttonchange2 = createVGUI( "DButton", parent, 390, 50, 410, 140 + 800 - 50 )
  buttonchange2:SetText( "" )
  function buttonchange2:Paint( pw, ph )
    if modelpanel.Entity != nil then
      if yrp_roles_dbTable[id] != nil then
        modelpanel.Entity:SetModelScale( yrp_roles_dbTable[id].playermodelsize, 0 )
      end
    end
    if self:IsHovered() then
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 200 ) )
    else
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 200 ) )
    end
    draw.SimpleTextOutlined( lang_string( "noneplayermodels" ), "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end
  function buttonchange2:DoClick()
    local playermodels = {}
    for _, addon in SortedPairsByMemberValue( engine.GetAddons(), "title" ) do
      if ( !addon.downloaded || !addon.mounted ) then continue end
      AddToTabRecursive( playermodels, "models/", addon.title, "*.mdl" )
  	end

    local tmpTable = {}
    local count = 0
    for k, v in pairs( playermodels ) do
      count = count + 1
      tmpTable[count] = {}
      tmpTable[count].WorldModel = v
      tmpTable[count].ClassName = v
      tmpTable[count].PrintName = v
    end

    _globalWorking = yrp_roles_dbTable[id].playermodelsnone

    hook.Add( "closeRolePlayermodels2", "yrp_close_playermodel_selector2", function()
      if settingsWindow != nil then
        if settingsWindow.window != nil then
          if settingsWindow.window.site != nil then
            yrp_roles_dbTable[id].playermodelsnone = _globalWorking
            pms = combineStringTables( yrp_roles_dbTable[id].playermodels, yrp_roles_dbTable[id].playermodelsnone )
            changepm = 1
            if modelpanel != nil and modelpanel != NULL then
              local _model = pms[changepm] or ""
              modelpanel:SetModel( _model )
            end
          end
        end
      end
    end)

    openSelector( tmpTable, "yrp_roles", "playermodelsnone", "uniqueID = " .. uniqueID, "closeRolePlayermodels2" )
  end
  return modelpanel
end

function getWorldModel( ClassName )
  local sweps = weapons.GetList()

  local _weaplist = list.Get( "Weapon" )
  for k, v in pairs( _weaplist ) do
    table.insert( sweps, v )
  end
  for k, v in pairs( sweps ) do
    if v.WorldModel == nil then
      v.WorldModel = v.Model or ""
    end
    if v.PrintName == nil then
      v.PrintName = v.Name or ""
    end
    if v.ClassName == nil then
      v.ClassName = v.Class or ""
    end

    if tostring( v.ClassName ) == tostring( ClassName ) then
      if v.WorldModel != nil then
        return v.WorldModel
      end
    end
  end
  return ""
end

function addDBSwep( parent, id, uniqueID, help )
  local tmp = addDPanel( parent, 800, 50, 810, 90, lang_string( "rolesweps" ), "yrp_roles", help )

  local sws = string.Explode( ",", yrp_roles_dbTable[id].sweps )
  local changesw = 1

  local background = createVGUI( "DPanel", parent, 800, 800, 810, 140 )
  function background:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 10 ) )
    draw.SimpleTextOutlined( sws[changesw], "sef", pw/2, ctr( 20 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    if #sws > 1 then
      draw.SimpleTextOutlined( changesw .. "/" .. #sws, "sef", pw/2, ctr( 60 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    end
  end

  local modelpanel = createVGUI( "DModelPanel", background, 720, 720, 40, 80 )
  local worldmodel = getWorldModel( sws[changesw] )
  modelpanel:SetModel( worldmodel )
  if worldmodel != "" and modelpanel.Entity != nil then
    modelpanel.Entity:SetModelScale( 1, 0 )
    modelpanel:SetLookAt( Vector(0,0,0) )
    modelpanel:SetCamPos( Vector(0,-30,15))
  end

  local buttonback = createVGUI( "DButton", background, 80, 80, 0, 400-40 )
  buttonback:SetText( "" )
  function buttonback:Paint( pw, ph )
    if changesw > 1 then
      if buttonback:IsHovered() then
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 100 ) )
      else
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 100 ) )
      end
      draw.SimpleTextOutlined( "<", "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    end
  end
  function buttonback:DoClick()
    if changesw > 1 then
      changesw = changesw - 1
      local worldmodel = getWorldModel( sws[changesw] )
      modelpanel:SetModel( worldmodel )
      if worldmodel != "" and modelpanel.Entity != nil then
        modelpanel.Entity:SetModelScale( 1, 0 )
        modelpanel:SetLookAt( Vector(0,0,0) )
        modelpanel:SetCamPos( Vector(0,-30,15))
      end
    end
  end

  local buttonforward = createVGUI( "DButton", background, 80, 80, 800-80, 400-40 )
  buttonforward:SetText( "" )
  function buttonforward:Paint( pw, ph )
    if changesw < #sws then
      if buttonforward:IsHovered() then
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 100 ) )
      else
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 100 ) )
      end
      draw.SimpleTextOutlined( ">", "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    end
  end
  function buttonforward:DoClick()
    if #sws > changesw then
      changesw = changesw + 1
      local worldmodel = getWorldModel( sws[changesw] )
      modelpanel:SetModel( worldmodel )
      if worldmodel != "" and modelpanel.Entity != nil then
        modelpanel.Entity:SetModelScale( 1, 0 )
        modelpanel:SetLookAt( Vector(0,0,0) )
        modelpanel:SetCamPos( Vector(0,-30,15))
      end
    end
  end

  local buttonchange = createVGUI( "DButton", background, 400, 50, 400-200, 800 - 50 )
  buttonchange:SetText( "" )
  function buttonchange:Paint( pw, ph )
    if buttonchange:IsHovered() then
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 200 ) )
    else
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 255, 0, 200 ) )
    end
    draw.SimpleTextOutlined( lang_string( "change" ), "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end
  function buttonchange:DoClick()
    local swepsL = weapons.GetList()
    local _weaplist = list.Get( "Weapon" )

    for k, v in pairs( _weaplist ) do
      if v.Category == "Half-Life 2" or string.find( v.ClassName, "weapon_physgun" ) then
        table.insert( swepsL, v )
      end
    end
    if yrp_roles_dbTable != nil then
      _globalWorking = yrp_roles_dbTable[id].sweps
    end
    hook.Add( "closeRoleSweps", "crs", function()
      if yrp_roles_dbTable != nil then
        if yrp_roles_dbTable[id] != nil then
          yrp_roles_dbTable[id].sweps = _globalWorking
          sws = string.Explode( ",", yrp_roles_dbTable[id].sweps )
          changesw = 1

          local worldmodel = getWorldModel( sws[changesw] )
          if pa( modelpanel) then
            modelpanel:SetModel( worldmodel )
            if modelpanel.Entity != nil then
              modelpanel.Entity:SetModelScale( 1, 0 )
            end
            modelpanel:SetLookAt( Vector( 0, 0, 0 ) )
            modelpanel:SetCamPos( Vector( 0, -30, 15 ) )
          end
        end
      end
    end)

    openSelector( swepsL, "yrp_roles", "sweps", "uniqueID = " .. uniqueID, "closeRoleSweps" )
  end
  return modelpanel
end

function addDBAmmo( parent, id, uniqueID, help )
  local tmp = addDPanel( parent, 400, 50, 1620, 90, lang_string( "roleammunation" ), "yrp_roles", help )

  local sws = string.Explode( ",", yrp_roles_dbTable[id].ammunation )
  local changesw = 1

  local background = createVGUI( "DPanel", parent, 400, 800, 1620, 140 )
  function background:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 10 ) )

    draw.SimpleText( "(" .. string.upper( lang_string( "wip" ) ) .. ")", "DermaDefault", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end

  local modelpanel = createVGUI( "DModelPanel", background, 320, 720, 40, 80 )
  local worldmodel = getWorldModel( sws[changesw] )
  modelpanel:SetModel( worldmodel )
  if worldmodel != "" and modelpanel.Entity != nil then
    modelpanel.Entity:SetModelScale( 1, 0 )
    modelpanel:SetLookAt( Vector(0,0,0) )
    modelpanel:SetCamPos( Vector(0,-30,15))
  end

  local buttonback = createVGUI( "DButton", background, 80, 800, 0, 0 )
  buttonback:SetText( "" )
  function buttonback:Paint( pw, ph )
    if changesw > 1 then
      if buttonback:IsHovered() then
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 100 ) )
      else
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 100 ) )
      end
      draw.SimpleTextOutlined( "<", "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    end
  end
  function buttonback:DoClick()
    if changesw > 1 then
      changesw = changesw - 1
      local worldmodel = getWorldModel( sws[changesw] )
      modelpanel:SetModel( worldmodel )
      if worldmodel != "" and modelpanel.Entity != nil then
        modelpanel.Entity:SetModelScale( 1, 0 )
        modelpanel:SetLookAt( Vector(0,0,0) )
        modelpanel:SetCamPos( Vector(0,-30,15))
      end
    end
  end

  local buttonforward = createVGUI( "DButton", background, 80, 800, 400-80, 0 )
  buttonforward:SetText( "" )
  function buttonforward:Paint( pw, ph )
    if changesw < #sws then
      if buttonforward:IsHovered() then
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 100 ) )
      else
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 100 ) )
      end
      draw.SimpleTextOutlined( ">", "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    end
  end
  function buttonforward:DoClick()
    if #sws > changesw then
      changesw = changesw + 1
      local worldmodel = getWorldModel( sws[changesw] )
      modelpanel:SetModel( worldmodel )
      if worldmodel != "" and modelpanel.Entity != nil then
        modelpanel.Entity:SetModelScale( 1, 0 )
        modelpanel:SetLookAt( Vector(0,0,0) )
        modelpanel:SetCamPos( Vector(0,-30,15))
      end
    end
  end

  local buttonchange = createVGUI( "DButton", background, 200, 40, 200-100, 800 - 40 )
  buttonchange:SetText( "" )
  function buttonchange:Paint( pw, ph )
    if buttonchange:IsHovered() then
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 100 ) )
    else
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 100 ) )
    end
    draw.SimpleTextOutlined( "(" .. string.upper( lang_string( "wip" ) ) .. ")", "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end
  function buttonchange:DoClick()

  end
  return modelpanel
end

function unselectAll()
  if yrp_roles_dbTable != nil then
    for k, v in pairs( yrp_roles_dbTable ) do
      v.selected = false
    end
  end
  if yrp_groups_dbTable != nil then
    for k, v in pairs( yrp_groups_dbTable ) do
      v.selected = false
    end
  end
end

function getCurrentRole()
  local id = -1
  if yrp_roles_dbTable != nil then
    for k, v in pairs( yrp_roles_dbTable ) do
      if v.selected then
        id = v.uniqueID
      end
    end
  end
  return id
end

function getCurrentGroup()
  local id = -1
  if yrp_groups_dbTable != nil then
    for k, v in pairs( yrp_groups_dbTable ) do
      if v.selected then
        id = v.uniqueID
      end
    end
  end
  return id
end

function deleteDBGroup()
  local tmp = -1
  for k, v in pairs( yrp_groups_dbTable ) do
    if v.selected and tonumber( v.removeable ) == 1 then
      tmp = k
      net.Start( "removeDBGroup" )
        net.WriteString( v.uniqueID )
      net.SendToServer()
      break
    end
  end
  local count = 0
  for k, v in pairs( yrp_groups ) do
    v:SetPos( 0, (count) * ctr( 40 ) )
    if k == tmp then
      v:Remove()
    else
      count = count + 1
    end
  end
end

function deleteDBRole()
  local tmp = -1
  for k, v in pairs( yrp_roles_dbTable ) do
    if v.selected and tonumber( v.removeable ) == 1 then
      tmp = k
      net.Start( "removeDBRole" )
        net.WriteString( v.uniqueID )
        net.WriteString( groupUniqueID )
      net.SendToServer()
      break
    end
  end
  local count = 0
  for k, v in pairs( yrp_roles ) do
    if v != NULL then
      v:SetPos( 0, (count) * ctr( 40 ) )
      if k == tmp then
        v:Remove()
      else
        count = count + 1
      end
    end
  end
end

function dupDBGroup( uniqueID )
  if uniqueID != -1 then
    net.Start( "dupDBGroup" )
      net.WriteString( uniqueID )
    net.SendToServer()
  else
    printGM( "note", "no role selected!" )
  end
end

function dupDBRole( groupID, uniqueID )
  if uniqueID != -1 then
    net.Start( "dupDBRole" )
      net.WriteString( groupID )
      net.WriteString( uniqueID )
    net.SendToServer()
  else
    printGM( "note", "no role selected!" )
  end
end

function addDBRole( groupID )
  if tonumber( groupID ) != -1 then
    net.Start( "addDBRole" )
      net.WriteString( groupID )
    net.SendToServer()
  else
    printGM( "note", "no group selected!" )
  end
end

function addDBGroup()
  net.Start( "addDBGroup" )
  net.SendToServer()
end

function addDBBar( parent, w, h, x, y, string, color, dbTable, tmpmin, tmpmax, tmpreg, dbTable, dbMin, dbMax, dbReg, dbWhile, tmpreg2, dbReg2, help )

  local tmin = tmpmin or 1
  local tmax = tmpmax or 1
  local treg = tmpreg or 1
  local treg2 = tmpreg2
  local _color1 = Color( color.r, color.g, color.b, 125 )
  local _color2 = Color( color.r, color.g, color.b, 255 )
  local tmp = createVGUI( "DPanel", parent, w, 2*(h/3), x, y )
  local reg = 0
  local tmpSec = 0
  function tmp:Paint( pw, ph )
    if CurTime() > tmpSec then
      tmpSec = CurTime() + 1
      reg = reg + 1
      if reg * tmpreg > tonumber( tmax ) then
        reg = 0
      end
    end

    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 10 ) )

    draw.RoundedBox( 0, 0, 0, pw * ( tmin / tmax ), ph, _color1 )

    draw.RoundedBox( 0, 0, ph-ph/4, pw * ( reg*treg / tmax ), ph/4, _color2 )

    draw.SimpleTextOutlined( string, "sef", pw/2, 1 * (ph/4), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    local _text = tmin .. "/" .. tmax .. "(" .. treg
    if treg2 != nil then
      _text = _text .. "/" .. treg2
    end
    _text = _text .. ")"
    draw.SimpleTextOutlined( _text, "sef", pw/2, 3 * (ph/4), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end

  local _ele = 3
  if treg2 != nil then
    _ele = 4
  end

  local tmp2 = addDNumberWang( parent, w/_ele, h/3, x, y + h - (h/3), tmin )
  local tmp3 = addDNumberWang( parent, w/_ele, h/3, x + w/_ele, y + h - (h/3), tmax )
  tmp3:SetMin( 1 )

  function tmp2:OnValueChanged( val )
    tmin = val
    if tonumber( tmin ) > tonumber( tmax ) then
      tmax = tmin
      tmp3:SetValue( tmax )
    end
    net.Start( "dbUpdate" )
      net.WriteString( dbTable )
      net.WriteString( dbMin .. " = " .. tmin .. "" )
      net.WriteString( dbWhile )
    net.SendToServer()
  end

  function tmp3:OnValueChanged( val )
    tmax = val
    if tonumber( tmax ) < self:GetMin() then
      self:SetValue( 1 )
    end
    if tonumber( tmax ) < tonumber( tmin ) then
      tmin = tmax
      tmp2:SetValue( tmin )
    end
    net.Start( "dbUpdate" )
      net.WriteString( dbTable )
      net.WriteString( dbMax .. " = " .. tmax .. "" )
      net.WriteString( dbWhile )
    net.SendToServer()
  end

  local tmp4 = addDNumberWang( parent, w/_ele, h/3, x + 2*(w/_ele), y + h - (h/3), treg )
  function tmp4:OnValueChanged( val )
    treg = val

    net.Start( "dbUpdate" )
      net.WriteString( dbTable )
      net.WriteString( dbReg .. " = " .. treg .. "" )
      net.WriteString( dbWhile )
    net.SendToServer()
  end

  if treg2 != nil then
    local tmp5 = addDNumberWang( parent, w/_ele, h/3, x + 3*(w/_ele), y + h - (h/3), treg2 )
    function tmp5:OnValueChanged( val )
      treg2 = val

      net.Start( "dbUpdate" )
        net.WriteString( dbTable )
        net.WriteString( dbReg2 .. " = " .. treg2 .. "" )
        net.WriteString( dbWhile )
      net.SendToServer()
    end
  end
  local tmp6 = addInfoBox( tmp, ctr(w)-ctr(40), 0, help )
  return tmp
end

net.Receive( "yrp_roles", function( len )
  if yrp_roles != nil then
    for k, v in pairs( yrp_roles ) do
      v:Remove()
    end
  end
  yrp_roles = {}
  yrp_roles_dbTable = net.ReadTable()

  for k, v in pairs( yrp_roles_dbTable ) do
    if settingsWindow != nil then
      v.selected = false
      yrp_roles[k] = addButton( _w, 40, 0, (k-1)*40, settingsWindow.window.site )
      local tmp = yrp_roles[k]
      tmp.uniqueID = v.uniqueID
      tmp.groupID = v.groupID
      tmp.id = k
      function tmp:Paint( pw, ph )
        if tmp:IsHovered() then
          draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 165, 0, 200 ) )
        elseif yrp_roles_dbTable[self.id].selected then
          draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 200 ) )
        else
          draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 200 ) )
        end
        local _pre = ""
        if tonumber( yrp_roles_dbTable[k].removeable ) == 0 then
          _start_role = v
          _pre = "(" .. lang_string( "default" ) .. ") "
        end
        draw.SimpleTextOutlined( _pre .. yrp_roles_dbTable[k].roleID, "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      end
      tmp.uniqueID = v.uniqueID
      function tmp:DoClick()
        unselectAll()
        yrp_roles_dbTable[self.id].selected = true

        if groupsInfo != nil then
          groupsInfo:Remove()
          groupsInfo = nil
        end
        if rolesInfo != nil then
          rolesInfo:Remove()
          rolesInfo = nil
        end

        rolesInfo = createVGUI( "DPanel", settingsWindow.window.site, 2100, 2100, _lbr + _w + _br, 5 )
        function rolesInfo:Paint( pw, ph )
          draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 0 ) )
        end

        --1.Spalte
        addDBTextEntry( rolesInfo, 800, 80, 0, 0, lang_string( "rolename" ), v.roleID, yrp_roles_dbTable[k], "yrp_roles", "roleID", "uniqueID = " .. tmp.uniqueID .. "", "Name of the role" )
        addDBPlayermodel( rolesInfo, self.id, tmp.uniqueID, v.playermodelsize, "Multiple playermodels, that the player can select" )
        addDBNumberWang( rolesInfo, 800, 80, 0, 950, lang_string( "roleplayermodelsize" ), v.playermodelsize, yrp_roles_dbTable[k], "yrp_roles", "playermodelsize", "uniqueID = " .. tmp.uniqueID .. "", 0.01, 999, "Set the playermodel size of this role" )
        addDBBar( rolesInfo, 800, 120, 0, 1040, lang_string( "rolehealth" ), Color( 255, 0, 0 ), "yrp_roles", v.hp, v.hpmax, v.hpreg, "yrp_roles", "hp", "hpmax", "hpreg", "uniqueID = " .. tmp.uniqueID .. "", nil, nil, "set the starting health / max health / regeneration of health" )
        addDBBar( rolesInfo, 800, 120, 0, 1170, lang_string( "rolearmor" ), Color( 0, 255, 0 ), "yrp_roles", v.ar, v.armax, v.arreg, "yrp_roles", "ar", "armax", "arreg", "uniqueID = " .. tmp.uniqueID .. "", nil, nil, "set the starting armor / max armor / regeneration of armor" )
        addDBBar( rolesInfo, 800, 120, 0, 1300, lang_string( "stamina" ), Color( 255, 255, 0 ), "yrp_roles", v.st, v.stmax, v.stregup, "yrp_roles", "st", "stmax", "stregup", "uniqueID = " .. tmp.uniqueID .. "", v.stregdn, "stregdn", "set the starting stamina / max stamina / regeneration of stamina" )
        -- in work WIP addDBBar( rolesInfo, 800, 120, 0, 1430, lang_string( "abilitybar" ) .. " (" .. string.upper( lang_string( "wip" ) ) .. ")", Color( 0, 0, 255 ), "yrp_roles", v.ab, v.abmax, v.abreg, "yrp_roles", "ab", "abmax", "abreg", "uniqueID = " .. tmp.uniqueID .. "" )
        addDBNumberWang( rolesInfo, 800, 80, 0, 1560, lang_string( "rolewalkspeed" ), v.speedwalk, yrp_roles_dbTable[k], "yrp_roles", "speedwalk", "uniqueID = " .. tmp.uniqueID .. "", 0, nil, "set the walkspeed (KEY: W)" )
        addDBNumberWang( rolesInfo, 800, 80, 0, 1650, lang_string( "rolerunspeed" ), v.speedrun, yrp_roles_dbTable[k], "yrp_roles", "speedrun", "uniqueID = " .. tmp.uniqueID .. "", 0, nil, "set the runspeed (KEY: W+SPRINT)" )
        addDBNumberWang( rolesInfo, 800, 80, 0, 1740, lang_string( "rolejumppower" ), v.powerjump, yrp_roles_dbTable[k], "yrp_roles", "powerjump", "uniqueID = " .. tmp.uniqueID .. "", 0, nil, "set the jump power (KEY: JUMP), how high he can jump" )

        --2.Spalte
        addDBNumberWang( rolesInfo, 800, 80, 810, 0, lang_string( "rolemaxamount" ) .. " (-1 = " .. lang_string( "disabled" ) .. ")", v.maxamount, yrp_roles_dbTable[k], "yrp_roles", "maxamount", "uniqueID = " .. tmp.uniqueID .. "", -1, game.MaxPlayers(), "how many players can get the role" )
        addDBSwep( rolesInfo, self.id, tmp.uniqueID, "the starting sweps" )
        addDBNumberWang( rolesInfo, 800, 80, 810, 950, lang_string( "rolesalary" ), v.salary, yrp_roles_dbTable[k], "yrp_roles", "salary", "uniqueID = " .. tmp.uniqueID .. "", 0, 999999999999, "how much the player will get, when salary is ready" )
        addDBNumberWang( rolesInfo, 800, 80, 810, 1040, lang_string( "rolesalarytime" ) .. " (" .. lang_string( "timeinsec" ) .. ")", v.salarytime, yrp_roles_dbTable[k], "yrp_roles", "salarytime", "uniqueID = " .. tmp.uniqueID .. "", 1, 999999999999, "how long they need to wait to get salary" )
        addDBTextEntryBig( rolesInfo, 800, 250, 810, 1130, lang_string( "roledescription" ), v.description, yrp_roles_dbTable[k], "yrp_roles", "description", "uniqueID = " .. tmp.uniqueID .. "", "role description" )
        addDBCheckBox( rolesInfo, 800, 40, 810, 1390, lang_string( "voteable" ), v.voteable, yrp_roles_dbTable[k], "yrp_roles", "voteable", "uniqueID = " .. tmp.uniqueID .. "", "if the role is voteable, via role menu" )
        addDBCheckBox( rolesInfo, 800, 40, 810, 1440, lang_string( "roleinstructor" ), v.instructor, yrp_roles_dbTable[k], "yrp_roles", "instructor", "uniqueID = " .. tmp.uniqueID .. "", "intructor can promote/demote other roles, that are below him" )
        addDBCheckBox( rolesInfo, 800, 40, 810, 1490, lang_string( "roleadminonly" ), v.adminonly, yrp_roles_dbTable[k], "yrp_roles", "adminonly", "uniqueID = " .. tmp.uniqueID .. "", "if only admins can get this role" )
        addDBCheckBox( rolesInfo, 800, 40, 810, 1540, lang_string( "rolewhitelist" ), v.whitelist, yrp_roles_dbTable[k], "yrp_roles", "whitelist", "uniqueID = " .. tmp.uniqueID .. "", "if the role need to be whitelisted for a player" )
        addDBCheckBox( rolesInfo, 800, 40, 810, 1590, lang_string( "rolevoiceglobal" ), v.voiceglobal, yrp_roles_dbTable[k], "yrp_roles", "voiceglobal", "uniqueID = " .. tmp.uniqueID .. "", "if the role can speak over the whole server" )
        addDBCheckBox( rolesInfo, 800, 40, 810, 1640, lang_string( "canbeagent" ), v.canbeagent, yrp_roles_dbTable[k], "yrp_roles", "canbeagent", "uniqueID = " .. tmp.uniqueID .. "", "if he can get a hitman/agent" )
        addDBCheckBox( rolesInfo, 800, 40, 810, 1690, lang_string( "iscivil" ), v.iscivil, yrp_roles_dbTable[k], "yrp_roles", "iscivil", "uniqueID = " .. tmp.uniqueID .. "", "if the role is for civil protection" )
        addDBLicenses( rolesInfo, 800, 80, 810, 1740, lang_string( "licenses" ), v.lincenseIDs, yrp_roles_dbTable[k], "yrp_roles", "licenseIDs", "uniqueID = " .. tmp.uniqueID .. "", "role licenses for shops" )

        if !table.HasValue( yrp_roles_dbTable, _start_role ) then
          table.insert( yrp_roles_dbTable, _start_role )
        end

        addDBComboBox( rolesInfo, 800, 80, 810, 1830, lang_string( "roleprerole" ), yrp_roles_dbTable, "roleID", "uniqueID", yrp_roles_dbTable[k], "yrp_roles", "prerole", "uniqueID = " .. tmp.uniqueID .. "", "here you need to select the role below you (lower role), needed for instructor" )

        if tonumber( yrp_roles_dbTable[k].removeable ) == 1 then
          addDBComboBox( rolesInfo, 1610, 80, 0, 1920, lang_string( "rolegroup" ), yrp_groups_dbTable, "groupID", "uniqueID", yrp_roles_dbTable[k], "yrp_roles", "groupID", "uniqueID = " .. tmp.uniqueID .. "", "which group it is in" )
        end

        --3.Spalte
        --addDBAmmo( rolesInfo, self.id, tmp.uniqueID )
      end
      if tmp != nil and rolesList != NULL and rolesList.AddItem != nil then
        rolesList:AddItem( tmp )
      end
    end
  end
end)

net.Receive( "yrp_groups", function( len )
  if yrp_groups != nil then
    for k, v in pairs( yrp_groups ) do
      v:Remove()
    end
  end
  yrp_groups = {}
  yrp_groups_dbTable = net.ReadTable()
  for k, v in pairs( yrp_groups_dbTable ) do
    if pa( settingsWindow.window.site ) then
      v.selected = false
      yrp_groups[k] = addButton( _w, 40, 0, (k-1)*40, settingsWindow.window.site )
      local tmp = yrp_groups[k]
      tmp.uniqueID = v.uniqueID
      tmp.groupID = v.groupID
      tmp.id = k
      function tmp:Paint( pw, ph )
        if self:IsHovered() then
          draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 165, 0, 200 ) )
        elseif yrp_groups_dbTable[self.id].selected then
          draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 200 ) )
        else
          draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 200 ) )
        end
        local _pre = ""
        if tonumber( yrp_groups_dbTable[k].removeable ) == 0 then
          _pre = "(" .. lang_string( "default" ) .. ") "
        end
        draw.RoundedBox( 0, 0, 0, ph, ph, toColor( yrp_groups_dbTable[k].color ) )
        draw.SimpleTextOutlined( _pre .. yrp_groups_dbTable[k].groupID, "sef", ph+_lbr, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      end
      function tmp:DoClick()
        groupUniqueID = v.uniqueID
        unselectAll()
        yrp_groups_dbTable[self.id].selected = true
        net.Start( "yrp_roles" )
          net.WriteString( tmp.uniqueID )
        net.SendToServer()

        groupID = yrp_groups_dbTable[tmp.id].groupID

        if groupsInfo != nil then
          groupsInfo:Remove()
          groupsInfo = nil
        end
        if rolesInfo != nil then
          rolesInfo:Remove()
          rolesInfo = nil
        end

        groupsInfo = createVGUI( "DPanel", settingsWindow.window.site, 1700, 1700, _lbr + _w + _br, 5 )
        function groupsInfo:Paint( pw, ph )
          draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 0 ) )
        end

        addDBTextEntry( groupsInfo, 800, 80, 0, 0, lang_string( "groupname" ), v.groupID, yrp_groups_dbTable[k], "yrp_groups", "groupID", "uniqueID = " .. tmp.uniqueID .. "", "Name of the group" )

        addDBColorMixer( groupsInfo, 800, 800, 0, 80 + _br, v.color, yrp_groups_dbTable[k], "yrp_groups", "color", "uniqueID = " .. tmp.uniqueID .. "" )

        if tonumber( yrp_groups_dbTable[k].removeable ) == 1 then
          addDBComboBox( groupsInfo, 800, 80, 0, 90 + 800 + _br, lang_string( "uppergroup" ), yrp_groups_dbTable, "groupID", "uniqueID", yrp_groups_dbTable[k], "yrp_groups", "uppergroup", "uniqueID = " .. tmp.uniqueID .. "", "the group, where this group is inside" )
        end
      end
      groupsList:AddItem( tmp )
    end
  end

  -- First Group View
  yrp_groups[1]:DoClick()
end)

net.Receive( "setting_getroles", function( len )
  function settingsWindow.window.site:Paint()
    --draw.RoundedBox( 0, 0, 0, sv_rolesPanel:GetWide(), sv_rolesPanel:GetTall(), _yrp.colors.panel )
  end

  -- GROUPS -- GROUPS -- GROUPS -- GROUPS -- GROUPS -- GROUPS -- GROUPS
  local groupsAdd = addButton( 50, 50, _lbr, _lbr, settingsWindow.window.site )
  function groupsAdd:Paint( pw, ph )
    if groupsAdd:IsHovered() then
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 200 ) )
    else
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 200 ) )
    end
    draw.SimpleTextOutlined( "+", "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end
  function groupsAdd:DoClick()
    addDBGroup()
  end

  local groupsDup = addButton( _w - 50 - _br - 50 - _br, 50, _lbr + 50 + _br, _lbr, settingsWindow.window.site )
  function groupsDup:Paint( pw, ph )
    if groupsDup:IsHovered() then
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 200 ) )
    else
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 200 ) )
    end
    draw.SimpleTextOutlined( lang_string( "duplicate" ), "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end
  function groupsDup:DoClick()
    dupDBGroup( getCurrentGroup() )
  end

  local groupsRem = addButton( 50, 50, _lbr + _w - 50, _lbr, settingsWindow.window.site )
  function groupsRem:Paint( pw, ph )
    if groupsRem:IsHovered() then
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 200 ) )
    else
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 200 ) )
    end
    draw.SimpleTextOutlined( "-", "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end
  function groupsRem:DoClick()
    deleteDBGroup()
  end

  local groupsHeader = createVGUI( "DPanel", settingsWindow.window.site, _w, 40, 5, 65 )
  function groupsHeader:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 100, 100, 255, 200 ) )
    draw.SimpleTextOutlined( lang_string( "groups" ), "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end

  local _group_height = 820
  groupsList = createVGUI( "DScrollPanel", settingsWindow.window.site, _w, _group_height-40, 5, 65+40 )
  function groupsList:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 200 ) )
  end

  net.Start( "yrp_groups" )
  net.SendToServer()

  -- ROLES -- ROLES -- ROLES -- ROLES -- ROLES -- ROLES -- ROLES -- ROLES
  local _roles_height = _group_height + 80
  local rolesAdd = addButton( 50, 50, _lbr, _roles_height, settingsWindow.window.site )
  function rolesAdd:Paint( pw, ph )
    if rolesAdd:IsHovered() then
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 200 ) )
    else
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 200 ) )
    end
    draw.SimpleTextOutlined( "+", "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end
  function rolesAdd:DoClick()
    addDBRole( groupUniqueID )
  end

  local rolesDup = addButton( _w - 50 - _br - 50 - _br, 50, _lbr + 50 + _br, _roles_height, settingsWindow.window.site )
  function rolesDup:Paint( pw, ph )
    if rolesDup:IsHovered() then
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 200 ) )
    else
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 200 ) )
    end
    draw.SimpleTextOutlined( lang_string( "duplicate" ), "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end
  function rolesDup:DoClick()
    dupDBRole( groupUniqueID, getCurrentRole() )
  end

  local rolesRem = addButton( 50, 50, _lbr + _w - 50, _roles_height, settingsWindow.window.site )
  function rolesRem:Paint( pw, ph )
    if rolesRem:IsHovered() then
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 200 ) )
    else
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 200 ) )
    end
    draw.SimpleTextOutlined( "-", "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end
  function rolesRem:DoClick()
    deleteDBRole()
  end

  local rolesHeader = createD( "DPanel", settingsWindow.window.site, ctr( _w ), ctr( 40 ), ctr( 10 ), ctr( _roles_height + 60 ) )
  function rolesHeader:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 100, 255, 100, 200 ) )
    draw.SimpleTextOutlined( groupID .. " - " .. lang_string( "roles" ), "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end

  local _r_l = {}
  _r_l.w = ctr( _w )
  _r_l.h = ScrH() - ctr( _roles_height + 200+10 )

  rolesList = createD( "DScrollPanel", settingsWindow.window.site, _r_l.w, _r_l.h, ctr( 10 ), ctr( _roles_height + 60 + 40 ) )
  function rolesList:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 200 ) )
  end
end)

hook.Add( "open_server_roles", "open_server_roles", function()
  SaveLastSite()
  local ply = LocalPlayer()

  local w = settingsWindow.window.sitepanel:GetWide()
  local h = settingsWindow.window.sitepanel:GetTall()

  settingsWindow.window.site = createD( "DPanel", settingsWindow.window.sitepanel, w, h, 0, 0 )
  settingsWindow.window.site.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0 ) ) end

  net.Start( "setting_getroles" )
  net.SendToServer()
end)
