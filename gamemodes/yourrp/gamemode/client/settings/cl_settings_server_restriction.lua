--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--cl_settings_server_restriction.lua

function dbUpdateNet( dbName, dbSets, dbWhile )
  net.Start( "dbUpdate" )
    net.WriteString( dbName )
    net.WriteString( dbSets )
    net.WriteString( dbWhile )
  net.SendToServer()
end

function createCheckBox( _string, _x, _y, _nr, _value, _usergroup )
  _tmpRes[_value .. "tmp"] = createVGUI( "DPanel", settingsWindow.site, 400, 50, _x, _y )
  local _tmp = _tmpRes[_value .. "tmp"]
  function _tmp:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, yrp.colors.dsecondary )
    draw.SimpleTextOutlined( _string, "sef", ctrW( 5 + 40 + 10 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end

  _tmpRes[_value .. "tmpCB"] = createVGUI( "DCheckBox", settingsWindow.site, 40, 40, _x + 5, _y + 5 )
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
end

net.Receive( "getRistrictions", function( len )
  _tmpRestriction = net.ReadTable()

  local _restrictionListView = createD( "DListView", settingsWindow.site, ctr( 400 ), ctr( 1800 ), ctr( 10 ), ctr( 10 ) )
  _restrictionListView:AddColumn( "uniqueID" ):SetFixedWidth( ctrW( 0 ) )
  _restrictionListView:AddColumn( lang.usergroup ):SetFixedWidth( ctrW( 400 ) )

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
        createCheckBox( lang.vehicles, 420, 10, k, "vehicles", v.usergroup )
        createCheckBox( lang.weapons, 420, 70, k, "weapons", v.usergroup )
        createCheckBox( lang.entities, 420, 130, k, "entities", v.usergroup )
        createCheckBox( lang.effects, 420, 190, k, "effects", v.usergroup )
        createCheckBox( lang.npcs, 420, 250, k, "npcs", v.usergroup )
        createCheckBox( lang.props, 420, 310, k, "props", v.usergroup )
        createCheckBox( lang.ragdolls, 420, 370, k, "ragdolls", v.usergroup )
      end
    end
  end
end)

hook.Add( "open_server_restrictions", "open_server_restrictions", function()
  local ply = LocalPlayer()

  local w = settingsWindow.sitepanel:GetWide()
  local h = settingsWindow.sitepanel:GetTall()

  settingsWindow.site = createD( "DPanel", settingsWindow.sitepanel, w, h, 0, 0 )

  function settingsWindow.site:Paint( pw, ph )
    --draw.RoundedBox( 4, 0, 0, pw, ph, yrp.colors.dbackground )
  end

  net.Start( "getRistrictions" )
  net.SendToServer()
end)
