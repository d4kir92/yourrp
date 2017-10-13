--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--cl_settings_server_roles.lua

local _w = 500
local _br = 10
local _lbr = 5

local groupID = ""
local groupUniqueID = -1

function addButton( w, h, x, y, parent )
  local tmp = createVGUI( "DButton", parent, w, h, x, y )
  tmp:SetText( "" )
  return tmp
end

function addDPanel( parent, w, h, x, y, string, dbTable )
  local color = Color( 100, 100, 255, 200 )
  if dbTable == "yrp_roles" then
    color = Color( 100, 255, 100, 200 )
  end
  local tmp = createVGUI( "DPanel", parent, w, h, x, y )
  function tmp:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, color )
    draw.SimpleText( string, "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end
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

function addDBTextEntry( parent, w, h, x, y, stringPanel, stringTextEntry, tmpTable, dbTable, dbSets, dbWhile )
  local tmp = addDPanel( parent, w, h/2, x, y, stringPanel, dbTable )

  local tmp2 = addDTextEntry( parent, w, h/2, x, y + h/2, stringTextEntry )
  function tmp2:OnChange()
    tmpTable[dbSets] = tmp2:GetText()
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

function addDBTextEntryBig( parent, w, h, x, y, stringPanel, stringTextEntry, tmpTable, dbTable, dbSets, dbWhile )
  local tmp = addDPanel( parent, w, 40, x, y, stringPanel, dbTable )

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

function addDBCheckBox( parent, w, h, x, y, stringPanel, checked, tmpTable, dbTable, dbSets, dbWhile )
  local tmp = addDPanel( parent, w - h, h, x+h, y, stringPanel, dbTable )

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
  tmp:AddChoice( lang.no .. " " .. string, -1, false )
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

function addDBComboBox( parent, w, h, x, y, string, table, value1, value2, tmpTable, dbTable, dbSets, dbWhile )
  local tmp = addDPanel( parent, w, h/2, x, y, string, dbTable )

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
  tmp:SetMin( 0 )

  tmp:SetValue( table )

  return tmp
end

function addDBNumberWang( parent, w, h, x, y, string, table, tmpTable, dbTable, dbSets, dbWhile )
  local tmp = addDPanel( parent, w, h/2, x, y, string, dbTable )

  local tmp2 = addDNumberWang( parent, w, h/2, x, y + h/2, table )

  function tmp2:OnValueChanged( val )
    tmpTable[dbSets] = val
    net.Start( "dbUpdate" )
      net.WriteString( dbTable )
      net.WriteString( dbSets .. " = " .. tmpTable[dbSets] .. "" )
      net.WriteString( dbWhile )
    net.SendToServer()
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

function addDBPlayermodel( parent, id, uniqueID, size )
  local pms = string.Explode( ",", yrp_roles_dbTable[id].playermodels )
  local changepm = 1

  local background = createVGUI( "DPanel", parent, 800, 800, 0, 90 )
  function background:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 10 ) )
    if pms[changepm] != "" and pms[changepm] != nil then
      draw.SimpleText( string.upper( player_manager.TranslateToPlayerModelName( pms[changepm] ) ), "sef", pw/2, ctrW( 20 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    if #pms > 1 then
      draw.SimpleText( changepm .. "/" .. #pms, "sef", pw/2, ctrW( 60 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
  end

  local modelpanel = createVGUI( "DModelPanel", parent, 720, 720, 40, 90+80 )
  if pms[changepm] != "" and pms[changepm] != nil then
    modelpanel:SetModel( pms[changepm] )
    if modelpanel.Entity != nil then
      modelpanel.Entity:SetModelScale( size, 0 )
    end
  end

  local buttonback = createVGUI( "DButton", parent, 80, 800, 0, 90 )
  buttonback:SetText( "" )
  function buttonback:Paint( pw, ph )
    if changepm > 1 then
      if buttonback:IsHovered() then
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 100 ) )
      else
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 100 ) )
      end
      draw.SimpleText( "<", "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
  end
  function buttonback:DoClick()
    if changepm > 1 then
      changepm = changepm - 1
      modelpanel:SetModel( pms[changepm] )
    end
  end

  local buttonforward = createVGUI( "DButton", parent, 80, 800, 800-80, 90 )
  buttonforward:SetText( "" )
  function buttonforward:Paint( pw, ph )
    if changepm < #pms then
      if buttonforward:IsHovered() then
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 100 ) )
      else
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 100 ) )
      end
      draw.SimpleText( ">", "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
  end
  function buttonforward:DoClick()
    if #pms > changepm then
      changepm = changepm + 1
      modelpanel:SetModel( pms[changepm] )
    end
  end

  local buttonchange = createVGUI( "DButton", parent, 200, 40, 400-100, 90 + 800 - 40 )
  buttonchange:SetText( "" )
  function buttonchange:Paint( pw, ph )
    if modelpanel.Entity != nil then
      if yrp_roles_dbTable[id] != nil then
        modelpanel.Entity:SetModelScale( yrp_roles_dbTable[id].playermodelsize, 0 )
      end
    end
    if buttonchange:IsHovered() then
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 100 ) )
    else
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 100 ) )
    end
    draw.SimpleText( lang.change, "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
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

    hook.Add( "closeRolePlayermodels", "crs", function()
      yrp_roles_dbTable[id].playermodels = _globalWorking
      pms = string.Explode( ",", yrp_roles_dbTable[id].playermodels )
      changepm = 1
      modelpanel:SetModel( pms[changepm] )
    end)

    openSelector( tmpTable, "yrp_roles", "playermodels", "uniqueID = " .. uniqueID, "closeRolePlayermodels" )
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

function addDBSwep( parent, id, uniqueID )
  local sws = string.Explode( ",", yrp_roles_dbTable[id].sweps )
  local changesw = 1

  local background = createVGUI( "DPanel", parent, 800, 800, 810, 90 )
  function background:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 10 ) )
    draw.SimpleText( sws[changesw], "sef", pw/2, ctrW( 20 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    if #sws > 1 then
      draw.SimpleText( changesw .. "/" .. #sws, "sef", pw/2, ctrW( 60 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
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

  local buttonback = createVGUI( "DButton", background, 80, 800, 0, 0 )
  buttonback:SetText( "" )
  function buttonback:Paint( pw, ph )
    if changesw > 1 then
      if buttonback:IsHovered() then
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 100 ) )
      else
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 100 ) )
      end
      draw.SimpleText( "<", "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
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

  local buttonforward = createVGUI( "DButton", background, 80, 800, 800-80, 0 )
  buttonforward:SetText( "" )
  function buttonforward:Paint( pw, ph )
    if changesw < #sws then
      if buttonforward:IsHovered() then
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 100 ) )
      else
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 100 ) )
      end
      draw.SimpleText( ">", "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
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

  local buttonchange = createVGUI( "DButton", background, 200, 40, 400-100, 800 - 40 )
  buttonchange:SetText( "" )
  function buttonchange:Paint( pw, ph )
    if buttonchange:IsHovered() then
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 100 ) )
    else
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 100 ) )
    end
    draw.SimpleText( lang.change, "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end
  function buttonchange:DoClick()
    local swepsL = weapons.GetList()
    local _weaplist = list.Get( "Weapon" )

    for k, v in pairs( _weaplist ) do
      if v.Category == "Half-Life 2" or string.find( v.ClassName, "weapon_physgun" ) then
        table.insert( swepsL, v )
      end
    end
    _globalWorking = yrp_roles_dbTable[id].sweps

    hook.Add( "closeRoleSweps", "crs", function()
      yrp_roles_dbTable[id].sweps = _globalWorking
      sws = string.Explode( ",", yrp_roles_dbTable[id].sweps )
      changesw = 1

      local worldmodel = getWorldModel( sws[changesw] )
      if modelpanel != NULL then
        modelpanel:SetModel( worldmodel )
        if modelpanel.Entity != nil then
          modelpanel.Entity:SetModelScale( 1, 0 )
        end
        modelpanel:SetLookAt( Vector( 0, 0, 0 ) )
        modelpanel:SetCamPos( Vector( 0, -30, 15 ) )
      end
    end)

    openSelector( swepsL, "yrp_roles", "sweps", "uniqueID = " .. uniqueID, "closeRoleSweps" )
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
    v:SetPos( 0, (count) * ctrW( 40 ) )
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
    v:SetPos( 0, (count) * ctrW( 40 ) )
    if k == tmp then
      v:Remove()
    else
      count = count + 1
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

function addDBBar( parent, w, h, x, y, string, color, dbTable, tmpmin, tmpmax, tmpreg, dbTable, dbMin, dbMax, dbReg, dbWhile )
  local _color1 = Color( color.r, color.g, color.b, 125 )
  local _color2 = Color( color.r, color.g, color.b, 255 )
  local tmp = createVGUI( "DPanel", parent, w, 2*(h/3), x, y )
  local reg = 0
  local tmpSec = 0
  function tmp:Paint( pw, ph )
    if CurTime() > tmpSec then
      tmpSec = CurTime() + 1
      reg = reg + 1
      if reg * tmpreg > tonumber( tmpmax ) then
        reg = 0
      end
    end

    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 10 ) )

    draw.RoundedBox( 0, 0, 0, pw * ( tmpmin / tmpmax ), ph, _color1 )

    draw.RoundedBox( 0, 0, ph-ph/4, pw * ( reg*tmpreg / tmpmax ), ph/4, _color2 )

    draw.SimpleText( string, "sef", pw/2, 1 * (ph/4), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    draw.SimpleText( tmpmin .. "/" .. tmpmax .. "(" .. tmpreg .. ")", "sef", pw/2, 3 * (ph/4), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end

  local tmp2 = addDNumberWang( parent, w/3, h/3, x, y + h - (h/3), tmpmin )
  local tmp3 = addDNumberWang( parent, w/3, h/3, x + w/3, y + h - (h/3), tmpmax )

  function tmp2:OnValueChanged( val )
    tmpmin = val
    if tonumber( tmpmin ) > tonumber( tmpmax ) then
      tmpmax = tmpmin
      tmp3:SetValue( tmpmax )
    end
    net.Start( "dbUpdate" )
      net.WriteString( dbTable )
      net.WriteString( dbMin .. " = " .. tmpmin .. "" )
      net.WriteString( dbWhile )
    net.SendToServer()
  end

  function tmp3:OnValueChanged( val )
    tmpmax = val
    if tonumber( tmpmax ) < tonumber( tmpmin ) then
      tmpmin = tmpmax
      tmp2:SetValue( tmpmin )
    end
    net.Start( "dbUpdate" )
      net.WriteString( dbTable )
      net.WriteString( dbMax .. " = " .. tmpmax .. "" )
      net.WriteString( dbWhile )
    net.SendToServer()
  end

  local tmp4 = addDNumberWang( parent, w/3, h/3, x + 2*(w/3), y + h - (h/3), tmpreg )
  function tmp4:OnValueChanged( val )
    tmpreg = val

    net.Start( "dbUpdate" )
      net.WriteString( dbTable )
      net.WriteString( dbReg .. " = " .. tmpreg .. "" )
      net.WriteString( dbWhile )
    net.SendToServer()
  end
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
    v.selected = false
    yrp_roles[k] = addButton( _w, 40, 0, (k-1)*40, settingsWindow.site )
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
        _pre = "(" .. lang.startrole .. ") "
      end
      draw.SimpleText( _pre .. yrp_roles_dbTable[k].roleID, "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
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

      rolesInfo = createVGUI( "DPanel", settingsWindow.site, 1700, 1700, _lbr + _w + _br, 5 )
      function rolesInfo:Paint( pw, ph )
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 0 ) )
      end

      --1.Spalte
      addDBTextEntry( rolesInfo, 800, 80, 0, 0, lang.rolename, v.roleID, yrp_roles_dbTable[k], "yrp_roles", "roleID", "uniqueID = " .. tmp.uniqueID .. "" )
      addDBPlayermodel( rolesInfo, self.id, tmp.uniqueID, v.playermodelsize )
      addDBNumberWang( rolesInfo, 800, 80, 0, 900, lang.roleplayermodelsize, v.playermodelsize, yrp_roles_dbTable[k], "yrp_roles", "playermodelsize", "uniqueID = " .. tmp.uniqueID .. "" )
      addDBBar( rolesInfo, 800, 120, 0, 990, lang.rolehealth, Color( 255, 0, 0 ), "yrp_roles", v.hp, v.hpmax, v.hpreg, "yrp_roles", "hp", "hpmax", "hpreg", "uniqueID = " .. tmp.uniqueID .. "" )
      addDBBar( rolesInfo, 800, 120, 0, 1120, lang.rolearmor, Color( 0, 255, 0 ), "yrp_roles", v.ar, v.armax, v.arreg, "yrp_roles", "ar", "armax", "arreg", "uniqueID = " .. tmp.uniqueID .. "" )
      addDBNumberWang( rolesInfo, 800, 80, 0, 1250, lang.rolewalkspeed, v.speedwalk, yrp_roles_dbTable[k], "yrp_roles", "speedwalk", "uniqueID = " .. tmp.uniqueID .. "" )
      addDBNumberWang( rolesInfo, 800, 80, 0, 1340, lang.rolerunspeed, v.speedrun, yrp_roles_dbTable[k], "yrp_roles", "speedrun", "uniqueID = " .. tmp.uniqueID .. "" )
      addDBNumberWang( rolesInfo, 800, 80, 0, 1430, lang.rolejumppower, v.powerjump, yrp_roles_dbTable[k], "yrp_roles", "powerjump", "uniqueID = " .. tmp.uniqueID .. "" )

      --2.Spalte
      addDBTextEntry( rolesInfo, 800, 80, 810, 0, lang.rolemaxamount, v.maxamount, yrp_roles_dbTable[k], "yrp_roles", "maxamount", "uniqueID = " .. tmp.uniqueID .. "" )
      addDBSwep( rolesInfo, self.id, tmp.uniqueID )
      addDBNumberWang( rolesInfo, 800, 80, 810, 900, lang.rolesalary, v.capital, yrp_roles_dbTable[k], "yrp_roles", "capital", "uniqueID = " .. tmp.uniqueID .. "" )
      addDBTextEntryBig( rolesInfo, 800, 250, 810, 990, lang.roledescription, v.description, yrp_roles_dbTable[k], "yrp_roles", "description", "uniqueID = " .. tmp.uniqueID .. "" )
      --addDBCheckBox( rolesInfo, 800, 40, 810, 1250, lang.voteable, v.voteable, yrp_roles_dbTable[k], "yrp_roles", "voteable", "uniqueID = " .. tmp.uniqueID .. "" )
      addDBCheckBox( rolesInfo, 800, 40, 810, 1250, lang.roleinstructor, v.instructor, yrp_roles_dbTable[k], "yrp_roles", "instructor", "uniqueID = " .. tmp.uniqueID .. "" )
      addDBCheckBox( rolesInfo, 800, 40, 810, 1300, lang.roleadminonly, v.adminonly, yrp_roles_dbTable[k], "yrp_roles", "adminonly", "uniqueID = " .. tmp.uniqueID .. "" )
      addDBCheckBox( rolesInfo, 800, 40, 810, 1350, lang.rolewhitelist, v.whitelist, yrp_roles_dbTable[k], "yrp_roles", "whitelist", "uniqueID = " .. tmp.uniqueID .. "" )
      addDBComboBox( rolesInfo, 800, 80, 810, 1400, lang.roleprerole, yrp_roles_dbTable, "roleID", "uniqueID", yrp_roles_dbTable[k], "yrp_roles", "prerole", "uniqueID = " .. tmp.uniqueID .. "" )

      if tonumber( yrp_roles_dbTable[k].removeable ) == 1 then
        addDBComboBox( rolesInfo, 1610, 80, 0, 1540, lang.rolegroup, yrp_groups_dbTable, "groupID", "uniqueID", yrp_roles_dbTable[k], "yrp_roles", "groupID", "uniqueID = " .. tmp.uniqueID .. "" )
      end
    end
    if tmp != nil then
      rolesList:AddItem( tmp )
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
    v.selected = false
    yrp_groups[k] = addButton( _w, 40, 0, (k-1)*40, settingsWindow.site )
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
        _pre = "(" .. lang.startgroup .. ") "
      end
      draw.RoundedBox( 0, 0, 0, ph, ph, toColor( yrp_groups_dbTable[k].color ) )
      draw.SimpleText( _pre .. yrp_groups_dbTable[k].groupID, "sef", ph+_lbr, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
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

      groupsInfo = createVGUI( "DPanel", settingsWindow.site, 1700, 1700, _lbr + _w + _br, 5 )
      function groupsInfo:Paint( pw, ph )
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 0 ) )
      end

      addDBTextEntry( groupsInfo, 800, 80, 0, 0, lang.groupname, v.groupID, yrp_groups_dbTable[k], "yrp_groups", "groupID", "uniqueID = " .. tmp.uniqueID .. "" )

      addDBColorMixer( groupsInfo, 800, 800, 0, 80 + _br, v.color, yrp_groups_dbTable[k], "yrp_groups", "color", "uniqueID = " .. tmp.uniqueID .. "" )

      if tonumber( yrp_groups_dbTable[k].removeable ) == 1 then
        addDBComboBox( groupsInfo, 800, 80, 0, 90 + 800 + _br, lang.uppergroup, yrp_groups_dbTable, "groupID", "uniqueID", yrp_groups_dbTable[k], "yrp_groups", "uppergroup", "uniqueID = " .. tmp.uniqueID .. "" )
      end
    end
    groupsList:AddItem( tmp )
  end

  -- First Group View
  yrp_groups[1]:DoClick()
end)

hook.Add( "open_server_roles", "open_server_roles", function()
  local ply = LocalPlayer()

  local w = settingsWindow.sitepanel:GetWide()
  local h = settingsWindow.sitepanel:GetTall()

  settingsWindow.site = createD( "DPanel", settingsWindow.sitepanel, w, h, 0, 0 )
  settingsWindow.site.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0 ) ) end

  function settingsWindow.site:Paint()
    --draw.RoundedBox( 0, 0, 0, sv_rolesPanel:GetWide(), sv_rolesPanel:GetTall(), yrp.colors.panel )
  end

  -- GROUPS -- GROUPS -- GROUPS -- GROUPS -- GROUPS -- GROUPS -- GROUPS
  local groupsAdd = addButton( 50, 50, _lbr, _lbr, settingsWindow.site )
  function groupsAdd:Paint( pw, ph )
    if groupsAdd:IsHovered() then
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 200 ) )
    else
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 200 ) )
    end
    draw.SimpleText( "+", "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end
  function groupsAdd:DoClick()
    addDBGroup()
  end

  local groupsDup = addButton( _w - 50 - _br - 50 - _br, 50, _lbr + 50 + _br, _lbr, settingsWindow.site )
  function groupsDup:Paint( pw, ph )
    if groupsDup:IsHovered() then
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 200 ) )
    else
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 200 ) )
    end
    draw.SimpleText( lang.duplicate, "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end
  function groupsDup:DoClick()
    dupDBGroup( getCurrentGroup() )
  end

  local groupsRem = addButton( 50, 50, _lbr + _w - 50, _lbr, settingsWindow.site )
  function groupsRem:Paint( pw, ph )
    if groupsRem:IsHovered() then
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 200 ) )
    else
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 200 ) )
    end
    draw.SimpleText( "-", "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end
  function groupsRem:DoClick()
    deleteDBGroup()
  end

  local groupsHeader = createVGUI( "DPanel", settingsWindow.site, _w, 40, 5, 65 )
  function groupsHeader:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 100, 100, 255, 200 ) )
    draw.SimpleText( lang.groups, "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end

  groupsList = createVGUI( "DScrollPanel", settingsWindow.site, _w, 500-40, 5, 65+40 )
  function groupsList:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 200 ) )
  end

  net.Start( "yrp_groups" )
  net.SendToServer()

  -- ROLES -- ROLES -- ROLES -- ROLES -- ROLES -- ROLES -- ROLES -- ROLES
  local rolesAdd = addButton( 50, 50, _lbr, 600, settingsWindow.site )
  function rolesAdd:Paint( pw, ph )
    if rolesAdd:IsHovered() then
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 200 ) )
    else
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 200 ) )
    end
    draw.SimpleText( "+", "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end
  function rolesAdd:DoClick()
    addDBRole( groupUniqueID )
  end

  local rolesDup = addButton( _w - 50 - _br - 50 - _br, 50, _lbr + 50 + _br, 600, settingsWindow.site )
  function rolesDup:Paint( pw, ph )
    if rolesDup:IsHovered() then
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 200 ) )
    else
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 200 ) )
    end
    draw.SimpleText( lang.duplicate, "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end
  function rolesDup:DoClick()
    dupDBRole( groupUniqueID, getCurrentRole() )
  end

  local rolesRem = addButton( 50, 50, _lbr + _w - 50, 600, settingsWindow.site )
  function rolesRem:Paint( pw, ph )
    if rolesRem:IsHovered() then
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 200 ) )
    else
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 200 ) )
    end
    draw.SimpleText( "-", "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end
  function rolesRem:DoClick()
    deleteDBRole()
  end

  local rolesHeader = createVGUI( "DPanel", settingsWindow.site, _w, 40, 5, 660 )
  function rolesHeader:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 100, 255, 100, 200 ) )
    draw.SimpleText( groupID .. " - " .. lang.roles, "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end

  rolesList = createVGUI( "DScrollPanel", settingsWindow.site, _w, 1200-40, 5, 660+40 )
  function rolesList:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 200 ) )
  end
end)
