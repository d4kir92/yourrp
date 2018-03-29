--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function dbUpdateNet( dbName, dbSets, dbWhile )
  net.Start( "dbUpdate" )
    net.WriteString( dbName )
    net.WriteString( dbSets )
    net.WriteString( dbWhile )
  net.SendToServer()
end

function createCheckBox( _string, _x, _y, _nr, _value, _usergroup )
  _tmpRes[_value .. "tmp"] = createVGUI( "DPanel", settingsWindow.window.site, 900, 50, _x, _y )
  local _tmp = _tmpRes[_value .. "tmp"]
  function _tmp:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, get_ds_col() )
    draw.SimpleTextOutlined( _string, "sef", ctr( 5 + 40 + 10 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end

  _tmpRes[_value .. "tmpCB"] = createVGUI( "DCheckBox", settingsWindow.window.site, 40, 40, _x + 5, _y + 5 )
  local _tmpCB = _tmpRes[_value .. "tmpCB"]
  _tmpCB:SetValue( tobool( _tmpRestriction[_nr][_value] ) )
  function _tmpCB:OnChange( bVal )
    if ( bVal ) then
      _tmpRestriction[_nr][_value] = 1
      dbUpdateNet( "yrp_restrictions", _value .. " = " .. _tmpRestriction[_nr][_value], "usergroup = '" .. _usergroup .. "'" )
    else
      _tmpRestriction[_nr][_value] = 0
      dbUpdateNet( "yrp_restrictions", _value .. " = " .. _tmpRestriction[_nr][_value], "usergroup = '" .. _usergroup .. "'" )
    end
  end
  return _tmp
end

function createDeleteButton( text, _x, _y, _list, id )
  local _rb = createD( "DButton", settingsWindow.window.site, ctr( 800 ), ctr( 50 ), _x, _y  )
  _rb:SetText( "" )
  function _rb:Paint( pw, ph )
    paintButton( self, pw, ph, lang_string( "remove" ) .. " (" .. text .. ")" )
  end
  function _rb:DoClick()
    net.Start( "remove_res_usergroup" )
      net.WriteString( text )
    net.SendToServer()

    for k, v in pairs( _tmpRes ) do
      v:Remove()
    end

    net.Start( "getRistrictions" )
    net.SendToServer()
  end

  return _rb
end

net.Receive( "getRistrictions", function( len )
  if _restrictionListView != nil then
    _restrictionListView:Remove()
  end
  _tmpRestriction = net.ReadTable()

  local _restrictionListView = createD( "DListView", settingsWindow.window.site, ctr( 400 ), ctr( 1800 ), ctr( 10 ), ctr( 10 ) )
  _restrictionListView:AddColumn( "uniqueID" ):SetFixedWidth( ctr( 0 ) )
  _restrictionListView:AddColumn( lang_string( "usergroup" ) )

  for k, v in pairs( _tmpRestriction ) do
    _restrictionListView:AddLine( v.uniqueID, v.usergroup )
  end

  _tmpRes = {}
  function _restrictionListView:OnRowSelected( rowIndex, row )
    for k, v in pairs( _tmpRes ) do
      v:Remove()
    end
    for k, v in pairs( _tmpRestriction ) do
      if k == rowIndex then
        _tmpRes[1] = createCheckBox( lang_string( "vehicles" ), 420, 10, k, "vehicles", v.usergroup )
        _tmpRes[2] = createCheckBox( lang_string( "weapons" ), 420, 70, k, "weapons", v.usergroup )
        _tmpRes[3] = createCheckBox( lang_string( "entities" ), 420, 130, k, "entities", v.usergroup )
        _tmpRes[4] = createCheckBox( lang_string( "effects" ), 420, 190, k, "effects", v.usergroup )
        _tmpRes[5] = createCheckBox( lang_string( "npcs" ), 420, 250, k, "npcs", v.usergroup )
        _tmpRes[6] = createCheckBox( lang_string( "props" ), 420, 310, k, "props", v.usergroup )
        _tmpRes[7] = createCheckBox( lang_string( "ragdolls" ), 420, 370, k, "ragdolls", v.usergroup )
        _tmpRes[8] = createCheckBox( lang_string( "noclip" ), 420, 430, k, "noclip", v.usergroup )

        _tmpRes[9] = createCheckBox( lang_string( "canuseremovetool" ), 420, 490, k, "canuseremovetool", v.usergroup )
        _tmpRes[10] = createCheckBox( lang_string( "canusephysgunpickup" ), 420, 550, k, "canusephysgunpickup", v.usergroup )
        _tmpRes[11] = createCheckBox( lang_string( "canusedynamitetool" ), 420, 610, k, "canusedynamitetool", v.usergroup )

        if v.usergroup != "superadmin" and v.usergroup != "admin" and v.usergroup != "owner" then
          _tmpRes[12] = createDeleteButton( v.usergroup, 210, 360, _restrictionListView, k )
        end
      end
    end
  end
end)

hook.Add( "open_server_restrictions", "open_server_restrictions", function()
  local ply = LocalPlayer()

  local w = settingsWindow.window.sitepanel:GetWide()
  local h = settingsWindow.window.sitepanel:GetTall()

  settingsWindow.window.site = createD( "DPanel", settingsWindow.window.sitepanel, w, h, 0, 0 )

  function settingsWindow.window.site:Paint( pw, ph )
    --draw.RoundedBox( 4, 0, 0, pw, ph, get_dbg_col() )
  end

  net.Start( "getRistrictions" )
  net.SendToServer()
end)
