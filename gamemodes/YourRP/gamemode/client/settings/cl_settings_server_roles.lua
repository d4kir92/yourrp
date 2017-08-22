//Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

//cl_settings_server_roles.lua

function tabServerRoles( sheet )
  local ply = LocalPlayer()

  local widee = ctrW( 1760 )

  local sv_rolesPanel = vgui.Create( "DPanel", sheet )
  sv_rolesPanel.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0 ) ) end
  sheet:AddSheet( lang.roles, sv_rolesPanel, "icon16/group_gear.png" )
  function sv_rolesPanel:Paint()
    //draw.RoundedBox( 0, 0, 0, sv_rolesPanel:GetWide(), sv_rolesPanel:GetTall(), yrpsettings.color.panel )
  end

  //############################################################################
  //Groups
  local sv_rolesGroups = vgui.Create( "DListView", sv_rolesPanel )

  sv_rolesGroups.DSP = vgui.Create( "DScrollPanel", sv_rolesPanel )

  sv_rolesGroups.panelName = vgui.Create( "DPanel", sv_rolesGroups.DSP )
  sv_rolesGroups.TextEntryName = vgui.Create( "DTextEntry", sv_rolesGroups.DSP )

  sv_rolesGroups.panelFarbe = vgui.Create( "DPanel", sv_rolesGroups.DSP )
  sv_rolesGroups.DRGBPicker = vgui.Create( "DRGBPicker", sv_rolesGroups.DSP )
  sv_rolesGroups.DColorCube = vgui.Create( "DColorCube", sv_rolesGroups.DSP )

  sv_rolesGroups.panelOberGruppe = vgui.Create( "DPanel", sv_rolesGroups.DSP )
  sv_rolesGroups.DComboBox = vgui.Create( "DComboBox", sv_rolesGroups.DSP )

  sv_rolesGroups.panelFriendlyFire = vgui.Create( "DPanel", sv_rolesGroups.DSP )
  sv_rolesGroups.DCheckBox = vgui.Create( "DCheckBox", sv_rolesGroups.DSP )

  sv_rolesGroups.table = {}
  sv_rolesGroups.tableLines = {}
  //############################################################################

  //############################################################################
  //Roles
  local sv_rolesRoles = vgui.Create( "DListView", sv_rolesPanel )
  sv_rolesRoles.buttonAddRole = vgui.Create( "DButton", sv_rolesPanel )
  sv_rolesRoles.buttonRemoveRole = vgui.Create( "DButton", sv_rolesPanel )

  sv_rolesRoles.DSP = vgui.Create( "DScrollPanel", sv_rolesPanel )

  sv_rolesRoles.panelName = vgui.Create( "DPanel", sv_rolesRoles.DSP )
  sv_rolesRoles.TextEntryName = vgui.Create( "DTextEntry", sv_rolesRoles.DSP )

  sv_rolesRoles.panelFarbe = vgui.Create( "DPanel", sv_rolesRoles.DSP )
  sv_rolesRoles.DRGBPicker = vgui.Create( "DRGBPicker", sv_rolesRoles.DSP )
  sv_rolesRoles.DColorCube = vgui.Create( "DColorCube", sv_rolesRoles.DSP )

  sv_rolesRoles.panelPlayermodel = vgui.Create( "DPanel", sv_rolesRoles.DSP )
  sv_rolesRoles.DButtonPlayermodel = vgui.Create( "DButton", sv_rolesRoles.DSP )
  sv_rolesRoles.DModelPanelPlayermodel = vgui.Create( "DModelPanel", sv_rolesRoles.DSP )
  sv_rolesRoles.TextEntryPlayermodelsize = vgui.Create( "DTextEntry", sv_rolesRoles.DSP )

  sv_rolesRoles.panelDescription = vgui.Create( "DPanel", sv_rolesRoles.DSP )
  sv_rolesRoles.TextEntryDescription = vgui.Create( "DTextEntry", sv_rolesRoles.DSP )

  sv_rolesRoles.panelCapital = vgui.Create( "DPanel", sv_rolesRoles.DSP )
  sv_rolesRoles.TextEntryCapital = vgui.Create( "DTextEntry", sv_rolesRoles.DSP )

  sv_rolesRoles.panelAmountMax = vgui.Create( "DPanel", sv_rolesRoles.DSP )
  sv_rolesRoles.TextEntryAmountMax = vgui.Create( "DTextEntry", sv_rolesRoles.DSP )

  sv_rolesRoles.panelHP = vgui.Create( "DPanel", sv_rolesRoles.DSP )
  sv_rolesRoles.TextEntryHP = vgui.Create( "DTextEntry", sv_rolesRoles.DSP )
  sv_rolesRoles.panelHPmax = vgui.Create( "DPanel", sv_rolesRoles.DSP )
  sv_rolesRoles.TextEntryHPmax = vgui.Create( "DTextEntry", sv_rolesRoles.DSP )
  sv_rolesRoles.panelHPreg = vgui.Create( "DPanel", sv_rolesRoles.DSP )
  sv_rolesRoles.TextEntryHPreg = vgui.Create( "DTextEntry", sv_rolesRoles.DSP )

  sv_rolesRoles.panelAR = vgui.Create( "DPanel", sv_rolesRoles.DSP )
  sv_rolesRoles.TextEntryAR = vgui.Create( "DTextEntry", sv_rolesRoles.DSP )
  sv_rolesRoles.panelARmax = vgui.Create( "DPanel", sv_rolesRoles.DSP )
  sv_rolesRoles.TextEntryARmax = vgui.Create( "DTextEntry", sv_rolesRoles.DSP )
  sv_rolesRoles.panelARreg = vgui.Create( "DPanel", sv_rolesRoles.DSP )
  sv_rolesRoles.TextEntryARreg = vgui.Create( "DTextEntry", sv_rolesRoles.DSP )

  sv_rolesRoles.panelSpeedWalk = vgui.Create( "DPanel", sv_rolesRoles.DSP )
  sv_rolesRoles.TextEntrySpeedWalk = vgui.Create( "DTextEntry", sv_rolesRoles.DSP )

  sv_rolesRoles.panelSpeedRun = vgui.Create( "DPanel", sv_rolesRoles.DSP )
  sv_rolesRoles.TextEntrySpeedRun = vgui.Create( "DTextEntry", sv_rolesRoles.DSP )

  sv_rolesRoles.panelJumpPower = vgui.Create( "DPanel", sv_rolesRoles.DSP )
  sv_rolesRoles.TextEntryJumpPower = vgui.Create( "DTextEntry", sv_rolesRoles.DSP )

  sv_rolesRoles.panelPreRole = vgui.Create( "DPanel", sv_rolesRoles.DSP )
  sv_rolesRoles.DComboBoxPreRole = vgui.Create( "DComboBox", sv_rolesRoles.DSP )

  sv_rolesRoles.panelInstructor = vgui.Create( "DPanel", sv_rolesRoles.DSP )
  sv_rolesRoles.DCheckBoxInstructor = vgui.Create( "DCheckBox", sv_rolesRoles.DSP )

  sv_rolesRoles.panelGroup = vgui.Create( "DPanel", sv_rolesRoles.DSP )
  sv_rolesRoles.DComboBoxGroup = vgui.Create( "DComboBox", sv_rolesRoles.DSP )

  sv_rolesRoles.panelSWEPS = vgui.Create( "DPanel", sv_rolesRoles.DSP )
  sv_rolesRoles.DButtonSWEPS = vgui.Create( "DButton", sv_rolesRoles.DSP )

  sv_rolesRoles.panelAdminOnly = vgui.Create( "DPanel", sv_rolesRoles.DSP )
  sv_rolesRoles.DCheckBoxAdminOnly = vgui.Create( "DCheckBox", sv_rolesRoles.DSP )

  sv_rolesRoles.panelWhitelist = vgui.Create( "DPanel", sv_rolesRoles.DSP )
  sv_rolesRoles.DCheckBoxWhitelist = vgui.Create( "DCheckBox", sv_rolesRoles.DSP )

  sv_rolesRoles.table = {}
  sv_rolesRoles.tableLines = {}
  //############################################################################

  //############################################################################
  //changer
  function changePanel( tmpPanel, w, h, x, y, header )
    tmpPanel:SetSize( w, h )
    tmpPanel:SetPos( x, y )
    function tmpPanel:Paint()
      draw.RoundedBox( 0, 0, 0, tmpPanel:GetWide(), tmpPanel:GetTall(), Color( 100, 255, 100, 100 ) )
      draw.SimpleText( header, "SettingsNormal", ctrW( 25 ), ctrW( 25 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    end
  end

  function changeTextEntry( tmpTextEntry, w, h, x, y, rowIndex, text, util )
    tmpTextEntry:SetSize( w, h )
    tmpTextEntry:SetPos( x, y + ctrW( 50 ) )
    function tmpTextEntry:OnChange()
      sv_rolesRoles.table[rowIndex][text] = tmpTextEntry:GetText()
      net.Start( util )
        net.WriteInt( sv_rolesRoles.table[sv_rolesRoles:GetSelectedLine()].uniqueID, 16 )
        net.WriteString( sv_rolesRoles.table[rowIndex][text] )
      net.SendToServer()
    end
    tmpTextEntry:SetText( sv_rolesRoles.table[rowIndex][text] )
  end

  function changeCheckBox( checkbox, size, x, y, tableValue, util )
    checkbox:SetSize( size, size )
    checkbox:SetPos( x, y )
    checkbox:SetChecked( sv_rolesRoles.table[sv_rolesRoles:GetSelectedLine()][tableValue] )
    function checkbox:OnChange( bVal )
      local tmpVal = 0
      if ( bVal ) then
        tmpVal = 1
      else
        tmpVal = 0
      end
      net.Start( util )
        net.WriteInt( sv_rolesRoles.table[sv_rolesRoles:GetSelectedLine()].uniqueID, 16 )
        net.WriteInt( tmpVal, 4 )
      net.SendToServer()
      sv_rolesRoles.table[sv_rolesRoles:GetSelectedLine()][tableValue] = tmpVal
    end
  end

  function changeComboBox( combobox, w, h, x, y, nilValue, rowIndex, tableValue, util )
    combobox:SetSize( w, h )
    combobox:SetPos( x, y )

    combobox:Clear()
    combobox:AddChoice( nilValue, -1 )

    if tableValue == "groupID" then
      for k, v in pairs ( sv_rolesGroups.table ) do
        combobox:AddChoice( v[tableValue], v.uniqueID )
      end
      for k, v in pairs( sv_rolesGroups.table ) do
        if v.uniqueID == sv_rolesRoles.table[rowIndex][tableValue] then
          combobox:ChooseOption( v[tableValue], v.uniqueID )
          break
        end
      end

      function combobox:OnSelect( index, value, data )
        if data != nil then
          net.Start( util )
            net.WriteInt( sv_rolesRoles.table[rowIndex].uniqueID, 16 )
            net.WriteInt( data, 16 )
          net.SendToServer()
          sv_rolesRoles.table[rowIndex][tableValue] = data
        end
      end
    elseif tableValue == "prerole" then
      net.Start( "getAllRoles" )
      net.SendToServer()

      net.Receive( "getAllRoles", function()
        local _allRoles = net.ReadTable()
        for k, v in pairs ( _allRoles ) do
          for l, w in pairs ( sv_rolesGroups.table ) do
            if tonumber( v.groupID ) == tonumber( w.uniqueID ) then
              combobox:AddChoice( w.groupID .. " " .. v.roleID, v.uniqueID )
            end
          end
        end
        for k, v in pairs( _allRoles ) do
          if tonumber( v.uniqueID ) == tonumber( sv_rolesRoles.table[rowIndex][tableValue] ) then
            for l, w in pairs ( sv_rolesGroups.table ) do
              if tonumber( v.groupID ) == tonumber( w.uniqueID ) then
                combobox:ChooseOption( w.groupID .. " " .. v.roleID, v.uniqueID )
                return
              end
            end
          else
            combobox:ChooseOption( nilValue, -1 )
          end
        end
      end)
      function combobox:OnSelect( index, value, data )
        if data != nil then
          net.Start( util )
            net.WriteInt( sv_rolesRoles.table[rowIndex].uniqueID, 16 )
            net.WriteInt( data, 16 )
          net.SendToServer()
          sv_rolesRoles.table[rowIndex][tableValue] = data
        end
      end
    end
  end
  //############################################################################

  local sv_rolesGroupsButtonAdd = vgui.Create( "DButton", sv_rolesPanel )
  local sv_rolesGroupsButtonRemove = vgui.Create( "DButton", sv_rolesPanel )

  sv_rolesGroupsButtonAdd:SetSize( ctrW( 240 ), ctrW( 50 ) )
  sv_rolesGroupsButtonAdd:SetPos( ctrW( 5 ), ctrW( 0 ) )
  sv_rolesGroupsButtonAdd:SetText( "+ " .. lang.newgroup )
  function sv_rolesGroupsButtonAdd:DoClick()
    net.Start( "newGroup" )
    net.SendToServer()
  end

  sv_rolesGroupsButtonRemove:SetSize( ctrW( 50 ), ctrW( 50 ) )
  sv_rolesGroupsButtonRemove:SetPos( ctrW( 5 + 240 + 10 ), ctrW( 0 ) )
  sv_rolesGroupsButtonRemove:SetText("-")
  function sv_rolesGroupsButtonRemove:DoClick()
    if sv_rolesGroups:GetSelectedLine() != nil then
      net.Start( "removeGroup" )
        net.WriteInt( sv_rolesGroups.table[sv_rolesGroups:GetSelectedLine()].uniqueID, 16 )
      net.SendToServer()
    end
  end

  sv_rolesGroups:SetSize( ctrW( 300 ), ctrW( 550 ) )
  sv_rolesGroups:SetPos( ctrW( 5 ), ctrW( 50 + 10 ) )
  sv_rolesGroups:SetMultiSelect( false )

  sv_rolesGroups:AddColumn( lang.groups )

  net.Start( "getGroups" )
  net.SendToServer()

  net.Receive( "getGroups", function()
    if sv_rolesGroups:GetLines() != nil then
      for k, v in pairs( sv_rolesGroups:GetLines() ) do
        sv_rolesGroups:RemoveLine( k )
      end
      sv_rolesGroups.table = net.ReadTable()
      for k, v in pairs( sv_rolesGroups.table ) do
        if v.removeable == "0" then
          sv_rolesGroups.tableLines[k] = sv_rolesGroups:AddLine( "(" .. lang.startgroup .. ") " .. v.groupID )
        else
          sv_rolesGroups.tableLines[k] = sv_rolesGroups:AddLine( v.groupID )
        end

        local tmpColor = string.Explode( ",", sv_rolesGroups.table[k].color )
        sv_rolesGroups.table[k].color = {}
        sv_rolesGroups.table[k].color.r = tmpColor[1]
        sv_rolesGroups.table[k].color.g = tmpColor[2]
        sv_rolesGroups.table[k].color.b = tmpColor[3]

        sv_rolesGroups.DColorCube:SetColor( Color( sv_rolesGroups.table[k].color.r, sv_rolesGroups.table[k].color.g, sv_rolesGroups.table[k].color.b ) )

        if k == #sv_rolesGroups.table then
          sv_rolesGroups:SelectItem( sv_rolesGroups:GetLine( k ) )
        end
      end
    end
  end)

  sv_rolesGroups.DSP:SetSize( ctrW( 2000 ), ctrW( 2000 ) )
  sv_rolesGroups.DSP:SetPos( ctrW( 5 + 300 + 10 ), ctrW( 0 ) )
  function sv_rolesGroups.DSP:Paint()
    draw.RoundedBox( 0, 0, 0, 4000, 4000, Color( 0, 0, 255, 10 ) )
  end

  sv_rolesGroups.TextEntryName:SetSize( widee, ctrW( 50 ) )
  sv_rolesGroups.TextEntryName:SetPos( ctrW( 0 ), ctrW( 50 ) )
  function sv_rolesGroups.TextEntryName:OnChange()
    net.Start( "updateGroupName" )
      net.WriteInt( sv_rolesGroups.table[sv_rolesGroups:GetSelectedLine()].uniqueID, 16 )
      net.WriteString( sv_rolesGroups.TextEntryName:GetText() )
    net.SendToServer()

    local newText = sv_rolesGroups.TextEntryName:GetText()
    for id, pnl in pairs( sv_rolesGroups.tableLines[sv_rolesGroups:GetSelectedLine()].Columns ) do
      if sv_rolesGroups.table[sv_rolesGroups:GetSelectedLine()].removeable == "0" then
        pnl:SetText( "(" .. lang.startgroup .. ") " .. newText )
        sv_rolesGroups.table[sv_rolesGroups:GetSelectedLine()].groupID = newText
      else
        pnl:SetText( newText )
        sv_rolesGroups.table[sv_rolesGroups:GetSelectedLine()].groupID = newText
      end
    end
  end

  sv_rolesGroups.DRGBPicker:SetSize( ctrW( 0 ), ctrW( 400 ) )
  sv_rolesGroups.DRGBPicker:SetPos( ctrW( 800 + 10 ), ctrW( 150 + 50 ) )

  function sv_rolesGroups.DRGBPicker:OnChange( col )
    local h = ColorToHSV( col )
    local _, s, v = ColorToHSV( sv_rolesGroups.DColorCube:GetRGB() )
    col = HSVToColor( h, s, v )
    sv_rolesGroups.DColorCube:SetColor( col )
    net.Start( "updateGroupColor" )
      net.WriteInt( sv_rolesGroups.table[sv_rolesGroups:GetSelectedLine()].uniqueID, 16 )
      net.WriteString( col.r .. "," .. col.g .. "," .. col.b )
      sv_rolesGroups.table[sv_rolesGroups:GetSelectedLine()].color.r = col.r
      sv_rolesGroups.table[sv_rolesGroups:GetSelectedLine()].color.g = col.g
      sv_rolesGroups.table[sv_rolesGroups:GetSelectedLine()].color.b = col.b
    net.SendToServer()
  end

  sv_rolesGroups.DColorCube:SetSize( ctrW( 800 ), ctrW( 400 ) )
  sv_rolesGroups.DColorCube:SetPos( ctrW( 0 ), ctrW( 150 + 50 ) )
  function sv_rolesGroups.DColorCube:OnUserChanged( col )
    net.Start( "updateGroupColor" )
      net.WriteInt( sv_rolesGroups.table[sv_rolesGroups:GetSelectedLine()].uniqueID, 16 )
      net.WriteString( col.r .. "," .. col.g .. "," .. col.b )
      sv_rolesGroups.table[sv_rolesGroups:GetSelectedLine()].color.r = col.r
      sv_rolesGroups.table[sv_rolesGroups:GetSelectedLine()].color.g = col.g
      sv_rolesGroups.table[sv_rolesGroups:GetSelectedLine()].color.b = col.b
    net.SendToServer()
  end

  sv_rolesGroups.DComboBox:SetSize( ctrW( 400 ), ctrW( 50 ) )
  sv_rolesGroups.DComboBox:SetPos( ctrW( 0 ), ctrW( 0 + 200 + 450 + 50 ) )
  function sv_rolesGroups.DComboBox:OnSelect( index, value, data )
    if data != nil then
      net.Start("updateUpperGroup")
        net.WriteInt( sv_rolesGroups.table[sv_rolesGroups:GetSelectedLine()].uniqueID, 16 )
        net.WriteInt( data, 16 )
      net.SendToServer()
      sv_rolesGroups.table[sv_rolesGroups:GetSelectedLine()].uppergroup = data
    end
  end

  sv_rolesGroups.panelFriendlyFire:SetSize( widee, ctrW( 50 ) )
  sv_rolesGroups.panelFriendlyFire:SetPos( ctrW( 0 ), ctrW( 0 + 750 + 50 ) )
  function sv_rolesGroups.panelFriendlyFire:Paint()
    draw.RoundedBox( 0, 0, 0, sv_rolesGroups.panelFriendlyFire:GetWide(), sv_rolesGroups.panelFriendlyFire:GetTall(), Color( 100, 100, 255, 100 ) )
    draw.SimpleText( lang.friendlyfire, "SettingsNormal", ctrW( 25 ), ctrW( 25 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
  end

  sv_rolesGroups.DCheckBox:SetSize( ctrW( 30 ), ctrW( 30 ) )
  sv_rolesGroups.DCheckBox:SetPos( ctrW( 0 ), ctrW( 800 + 50 ) )
  function sv_rolesGroups.DCheckBox:OnChange( bVal )
    local tmpVal = 0
    if ( bVal ) then
      tmpVal = 1
    else
      tmpVal = 0
    end
    net.Start("updateFriendlyFire")
      net.WriteInt( sv_rolesGroups.table[sv_rolesGroups:GetSelectedLine()].uniqueID, 16 )
      net.WriteInt( tmpVal, 4 )
    net.SendToServer()
    sv_rolesGroups.table[sv_rolesGroups:GetSelectedLine()].friendlyfire = tmpVal
  end
  //############################################################################

  //############################################################################
  //ROLES
  sv_rolesRoles:SetSize( ctrW( 300 ), ctrW( 1240 ) )
  sv_rolesRoles:SetPos( ctrW( 5 ), ctrW( 700 + 10 ) )
  sv_rolesRoles:SetMultiSelect( false )

  sv_rolesRoles:AddColumn( lang.roles )

  sv_rolesRoles.buttonAddRole:SetSize( ctrW( 240 ), ctrW( 50 ) )
  sv_rolesRoles.buttonAddRole:SetPos( ctrW( 5 ), ctrW( 700 - 50 ) )
  sv_rolesRoles.buttonAddRole:SetText( "+ " .. lang.newrole )
  function sv_rolesRoles.buttonAddRole:DoClick()
    net.Start( "newRole" )
      net.WriteInt( _SelectedGroupID, 16 )
    net.SendToServer()
  end

  sv_rolesRoles.buttonRemoveRole:SetSize( ctrW( 50 ), ctrW( 50 ) )
  sv_rolesRoles.buttonRemoveRole:SetPos( ctrW( 5 + 240 + 10 ), ctrW( 700 - 50 ) )
  sv_rolesRoles.buttonRemoveRole:SetText("-")
  function sv_rolesRoles.buttonRemoveRole:DoClick()
    if sv_rolesRoles:GetSelectedLine() != nil then
      net.Start( "removeRole" )
        net.WriteInt( _SelectedGroupID, 16 )
        net.WriteInt( sv_rolesRoles.table[sv_rolesRoles:GetSelectedLine()].uniqueID, 16 )
      net.SendToServer()
    end
  end

  /*net.Start( "getRoles" )
    net.WriteInt( -1, 16 )
  net.SendToServer()*/

  net.Receive( "getRoles", function()
    for k, v in pairs( sv_rolesRoles:GetLines() ) do
      sv_rolesRoles:RemoveLine( k )
    end

    sv_rolesRoles.table = net.ReadTable()
    if sv_rolesRoles.table != nil then
      for k, v in pairs( sv_rolesRoles.table ) do
        if v.removeable == "0" then
          sv_rolesRoles.tableLines[k] = sv_rolesRoles:AddLine( "(" .. lang.startrole .. ") " .. v.roleID )
        else
          sv_rolesRoles.tableLines[k] = sv_rolesRoles:AddLine( v.roleID )
        end

        local tmpColor = string.Explode( ",", sv_rolesRoles.table[k].color )
        sv_rolesRoles.table[k].color = {}
        sv_rolesRoles.table[k].color.r = tmpColor[1]
        sv_rolesRoles.table[k].color.g = tmpColor[2]
        sv_rolesRoles.table[k].color.b = tmpColor[3]

        sv_rolesRoles.DColorCube:SetColor( Color( sv_rolesRoles.table[k].color.r, sv_rolesRoles.table[k].color.g, sv_rolesRoles.table[k].color.b ) )

        /*if k == #sv_rolesRoles.table then
          sv_rolesRoles:SelectItem( sv_rolesRoles:GetLine( k ) )
        end*/
      end
    end
  end)

  sv_rolesRoles.DSP:SetSize( widee, ctrW( 1950 ) )
  sv_rolesRoles.DSP:SetPos( ctrW( 5 + 300 + 10 ), ctrW( 0 ) )
  function sv_rolesRoles.DSP:Paint()
    draw.RoundedBox( 0, 0, 0, sv_rolesRoles.DSP:GetWide(), sv_rolesRoles.DSP:GetTall(), Color( 100, 100, 255, 10 ) )
  end

  sv_rolesRoles.DRGBPicker:SetSize( ctrW( 50 ), ctrW( 400 ) )
  sv_rolesRoles.DRGBPicker:SetPos( ctrW( 800 + 10 ), ctrW( 150 + 50 ) )

  function sv_rolesRoles.DRGBPicker:OnChange( col )
    local h = ColorToHSV( col )
    local _, s, v = ColorToHSV( sv_rolesRoles.DColorCube:GetRGB() )
    col = HSVToColor( h, s, v )
    sv_rolesRoles.DColorCube:SetColor( col )
    net.Start( "updateRoleColor" )
      net.WriteInt( sv_rolesRoles.table[sv_rolesRoles:GetSelectedLine()].uniqueID, 16 )
      net.WriteString( col.r .. "," .. col.g .. "," .. col.b )
      sv_rolesRoles.table[sv_rolesRoles:GetSelectedLine()].color.r = col.r
      sv_rolesRoles.table[sv_rolesRoles:GetSelectedLine()].color.g = col.g
      sv_rolesRoles.table[sv_rolesRoles:GetSelectedLine()].color.b = col.b
    net.SendToServer()
  end

  sv_rolesRoles.DColorCube:SetSize( ctrW( 800 ), ctrW( 400 ) )
  sv_rolesRoles.DColorCube:SetPos( ctrW( 0 ), ctrW( 150 + 50 ) )
  function sv_rolesRoles.DColorCube:OnUserChanged( col )
    net.Start( "updateRoleColor" )
      net.WriteInt( sv_rolesRoles.table[sv_rolesRoles:GetSelectedLine()].uniqueID, 16 )
      net.WriteString( col.r .. "," .. col.g .. "," .. col.b )
      sv_rolesRoles.table[sv_rolesRoles:GetSelectedLine()].color.r = col.r
      sv_rolesRoles.table[sv_rolesRoles:GetSelectedLine()].color.g = col.g
      sv_rolesRoles.table[sv_rolesRoles:GetSelectedLine()].color.b = col.b
    net.SendToServer()
  end

  function sv_rolesGroups:OnRowSelected( rowIndex, row )
    _SelectedGroupID = sv_rolesGroups.table[rowIndex].uniqueID
    net.Start( "getRoles" )
      net.WriteInt( sv_rolesGroups.table[rowIndex].uniqueID, 16 )
    net.SendToServer()

    sv_rolesGroups.DSP:SetVisible( true )

    sv_rolesRoles.DSP:SetVisible( false )

    sv_rolesRoles:ClearSelection()

    sv_rolesGroups.panelName:SetSize( widee, ctrW( 50 ) )
    sv_rolesGroups.panelName:SetPos( ctrW( 0 ), ctrW( 0 ) )
    function sv_rolesGroups.panelName:Paint()
      draw.RoundedBox( 0, 0, 0, sv_rolesGroups.panelName:GetWide(), sv_rolesGroups.panelName:GetTall(), Color( 100, 100, 255, 100 ) )
      draw.SimpleText( lang.groupname, "SettingsNormal", ctrW( 25 ), ctrW( 25 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    end
    sv_rolesGroups.TextEntryName:SetText( sv_rolesGroups.table[rowIndex].groupID )

    sv_rolesGroups.panelFarbe:SetSize( widee, ctrW( 50 ) )
    sv_rolesGroups.panelFarbe:SetPos( ctrW( 0 ), ctrW( 150 ) )
    function sv_rolesGroups.panelFarbe:Paint()
      draw.RoundedBox( 0, 0, 0, sv_rolesGroups.panelFarbe:GetWide(), sv_rolesGroups.panelFarbe:GetTall(), Color( 100, 100, 255, 100 ) )
      draw.SimpleText( lang.groupcolor, "SettingsNormal", ctrW( 25 ), ctrW( 25 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    end
    sv_rolesGroups.DColorCube:SetColor( Color( sv_rolesGroups.table[rowIndex].color.r, sv_rolesGroups.table[rowIndex].color.g, sv_rolesGroups.table[rowIndex].color.b ) )

    sv_rolesGroups.panelOberGruppe:SetSize( widee, ctrW( 50 ) )
    sv_rolesGroups.panelOberGruppe:SetPos( ctrW( 0 ), ctrW( 650 ) )
    function sv_rolesGroups.panelOberGruppe:Paint()
      draw.RoundedBox( 0, 0, 0, sv_rolesGroups.panelOberGruppe:GetWide(), sv_rolesGroups.panelOberGruppe:GetTall(), Color( 100, 100, 255, 100 ) )
      draw.SimpleText( lang.uppergroup, "SettingsNormal", ctrW( 25 ), ctrW( 25 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    end
    sv_rolesGroups.DComboBox:Clear()
    sv_rolesGroups.DComboBox:AddChoice( "No Group", -1 )
    for k, v in pairs( sv_rolesGroups.table ) do
      if v.uniqueID != sv_rolesGroups.table[rowIndex].uniqueID then
        sv_rolesGroups.DComboBox:AddChoice( v.groupID, v.uniqueID )
      end
    end
    for k, v in pairs( sv_rolesGroups.table ) do
      if v.uniqueID == sv_rolesGroups.table[rowIndex].uppergroup then
        sv_rolesGroups.DComboBox:ChooseOption( v.groupID, v.uniqueID )
      end
    end
  end

  function sv_rolesRoles:OnRowSelected( rowIndex, row )
    sv_rolesGroups.DSP:SetVisible( false )

    sv_rolesRoles.DSP:SetVisible( true )

    sv_rolesGroups:ClearSelection()

    //##########################################################################
    //Name
    changePanel( sv_rolesRoles.panelName, widee, ctrW( 50 ), ctrW( 0 ), ctrW( 0 ), lang.rolename )
    changeTextEntry( sv_rolesRoles.TextEntryName, widee, ctrW( 50 ), ctrW( 0 ), ctrW( 0 ), rowIndex, "roleID", "updateRoleName" )
    function sv_rolesRoles.TextEntryName:OnChange()
      net.Start( "updateRoleName" )
        net.WriteInt( sv_rolesRoles.table[sv_rolesRoles:GetSelectedLine()].uniqueID, 16 )
        net.WriteString( sv_rolesRoles.TextEntryName:GetText() )
      net.SendToServer()

      local newText = sv_rolesRoles.TextEntryName:GetText()
      for id, pnl in pairs( sv_rolesRoles.tableLines[sv_rolesRoles:GetSelectedLine()].Columns ) do
        if sv_rolesRoles.table[sv_rolesRoles:GetSelectedLine()].removeable == "0" then
          pnl:SetText( "(" .. lang.startrole .. ") " .. newText )
          sv_rolesRoles.table[sv_rolesRoles:GetSelectedLine()].roleID = newText
        else
          pnl:SetText( newText )
          sv_rolesRoles.table[sv_rolesRoles:GetSelectedLine()].roleID = newText
        end
      end
    end
    //##########################################################################

    sv_rolesRoles.panelFarbe:SetSize( widee, ctrW( 50 ) )
    sv_rolesRoles.panelFarbe:SetPos( ctrW( 0 ), ctrW( 150 ) )
    function sv_rolesRoles.panelFarbe:Paint()
      draw.RoundedBox( 0, 0, 0, sv_rolesRoles.panelFarbe:GetWide(), sv_rolesRoles.panelFarbe:GetTall(), Color( 100, 255, 100, 100 ) )
      draw.SimpleText( lang.rolecolor, "SettingsNormal", ctrW( 25 ), ctrW( 25 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    end
    sv_rolesRoles.DColorCube:SetColor( Color( sv_rolesRoles.table[rowIndex].color.r, sv_rolesRoles.table[rowIndex].color.g, sv_rolesRoles.table[rowIndex].color.b ) )

    sv_rolesRoles.panelPlayermodel:SetSize( widee, ctrW( 50 ) )
    sv_rolesRoles.panelPlayermodel:SetPos( ctrW( 0 ), ctrW( 650 ) )
    function sv_rolesRoles.panelPlayermodel:Paint()
      draw.RoundedBox( 0, 0, 0, sv_rolesRoles.panelPlayermodel:GetWide(), sv_rolesRoles.panelPlayermodel:GetTall(), Color( 100, 255, 100, 100 ) )
      draw.SimpleText( lang.roleplayermodel .. " | " .. lang.roleplayermodelsize .. " (" .. lang.default .. ": 1)", "SettingsNormal", ctrW( 25 ), ctrW( 25 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    end

    sv_rolesRoles.DModelPanelPlayermodel:SetSize( ctrW( 128 ), ctrW( 128 ) )
    sv_rolesRoles.DModelPanelPlayermodel:SetPos( ctrW( 0 ), ctrW( 700 ) )

    sv_rolesRoles.DButtonPlayermodel:SetSize( ctrW( 128 ), ctrW( 128 ) )
    sv_rolesRoles.DButtonPlayermodel:SetPos( ctrW( 128 ), ctrW( 700 ) )
    sv_rolesRoles.DButtonPlayermodel:SetText( "" )
    function sv_rolesRoles.DButtonPlayermodel:Paint()
      draw.RoundedBox( 0, 0, 0, sv_rolesRoles.DButtonPlayermodel:GetWide(), sv_rolesRoles.DButtonPlayermodel:GetTall(), Color( 255, 255, 255, 100 ) )
      draw.SimpleText( lang.change, "SettingsNormal", sv_rolesRoles.DButtonPlayermodel:GetWide()/2, sv_rolesRoles.DButtonPlayermodel:GetTall()/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    function sv_rolesRoles.DButtonPlayermodel:DoClick()
      modelSelector = vgui.Create( "DFrame" )
      modelSelector:SetSize( ctrW( 2000 ), ctrW( 2000 ) )
      modelSelector:SetPos( ScrW2() - ctrW( 2000/2 ), ScrH2() - ctrW( 2000/2 ) )
      modelSelector:SetTitle( lang.modelchange )

      local PanelSelect = vgui.Create( "DPanelSelect", modelSelector )
      PanelSelect:SetSize( ctrW( 2000 ), ctrW( 2000 - 45 ) )
      PanelSelect:SetPos( ctrW( 0 ), ctrW( 45 ) )

      for name, model in SortedPairs( player_manager.AllValidModels() ) do
  			local icon = vgui.Create( "SpawnIcon" )
  			icon:SetModel( model )
  			icon:SetSize( ctrW( 128 ), ctrW( 128 ) )
  			icon:SetTooltip( name )
  			icon.playermodel = name
        local _tmpName = createVGUI( "DPanel", icon, 128, 22, 0, 128-22 )
        function _tmpName:Paint( pw, ph )
          draw.SimpleText( icon.playermodel, "pmT", ctrW( 5 ), ph-ctrW( 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        end
  			PanelSelect:AddPanel( icon, { cl_playermodel = name } )
  		end
      modelSelector:MakePopup()
      function PanelSelect:OnActivePanelChanged( old, new )
        timer.Simple( 0.1, function()
          local model = LocalPlayer():GetInfo( "cl_playermodel" )
    			local modelname = player_manager.TranslatePlayerModel( model )
          sv_rolesRoles.DModelPanelPlayermodel:SetModel(modelname)
          if sv_rolesRoles.DModelPanelPlayermodel.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) then
            local headpos = sv_rolesRoles.DModelPanelPlayermodel.Entity:GetBonePosition( sv_rolesRoles.DModelPanelPlayermodel.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) )
            sv_rolesRoles.DModelPanelPlayermodel:SetLookAt( headpos )
            sv_rolesRoles.DModelPanelPlayermodel:SetCamPos( headpos-Vector( -26, 0, 0 ) )
          else
            sv_rolesRoles.DModelPanelPlayermodel:SetLookAt( Vector(0,0,64) )
            sv_rolesRoles.DModelPanelPlayermodel:SetCamPos( Vector(0,0,64)-Vector( -26, 0, 0 ) )
          end
          net.Start( "updateRolePlayermodel" )
            net.WriteInt(  sv_rolesRoles.table[rowIndex].uniqueID, 16 )
            sv_rolesRoles.table[rowIndex].playermodel = modelname
            net.WriteString( modelname )
          net.SendToServer()
        end)
        modelSelector:Close()
      end
      sv_rolesRoles.DModelPanelPlayermodel:SetModel(sv_rolesRoles.table[rowIndex].playermodel)
      if sv_rolesRoles.DModelPanelPlayermodel.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) then
        local headpos = sv_rolesRoles.DModelPanelPlayermodel.Entity:GetBonePosition( sv_rolesRoles.DModelPanelPlayermodel.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) )
        sv_rolesRoles.DModelPanelPlayermodel:SetLookAt( headpos )
        sv_rolesRoles.DModelPanelPlayermodel:SetCamPos( headpos-Vector( -26, 0, 0 ) )
      else
        sv_rolesRoles.DModelPanelPlayermodel:SetLookAt( Vector(0,0,64) )
        sv_rolesRoles.DModelPanelPlayermodel:SetCamPos( Vector(0,0,64)-Vector( -26, 0, 0 ) )
      end
    end

    function sv_rolesRoles.DModelPanelPlayermodel:LayoutEntity( Entity ) return end

    if sv_rolesRoles.table[rowIndex].playermodel != nil then
      sv_rolesRoles.DModelPanelPlayermodel:SetModel( sv_rolesRoles.table[rowIndex].playermodel )
      if sv_rolesRoles.DModelPanelPlayermodel.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) then
        local headpos = sv_rolesRoles.DModelPanelPlayermodel.Entity:GetBonePosition( sv_rolesRoles.DModelPanelPlayermodel.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) )
        sv_rolesRoles.DModelPanelPlayermodel:SetLookAt( headpos )
        sv_rolesRoles.DModelPanelPlayermodel:SetCamPos( headpos-Vector( -26, 0, 0 ) )
      else
        sv_rolesRoles.DModelPanelPlayermodel:SetLookAt( Vector(0,0,64) )
        sv_rolesRoles.DModelPanelPlayermodel:SetCamPos( Vector(0,0,64)-Vector( -26, 0, 0 ) )
      end
    end

    changeTextEntry( sv_rolesRoles.TextEntryPlayermodelsize, widee - ctrW( 256 + 32 ), ctrW( 50 ), ctrW( 256 ), ctrW( 650 ), rowIndex, "playermodelsize", "updateRolePlayermodelsize" )
    //##########################################################################

    //##########################################################################
    //Description
    changePanel( sv_rolesRoles.panelDescription, widee, ctrW( 50 ), ctrW( 0 ), ctrW( 900 ), lang.roledescription )
    changeTextEntry( sv_rolesRoles.TextEntryDescription, widee, ctrW( 50 ), ctrW( 0 ), ctrW( 900 ), rowIndex, "description", "updateRoleDescription" )
    //##########################################################################

    //##########################################################################
    //Capital
    changePanel( sv_rolesRoles.panelCapital, widee, ctrW( 50 ), ctrW( 0 ), ctrW( 1050 ), lang.rolesalary )
    changeTextEntry( sv_rolesRoles.TextEntryCapital, widee, ctrW( 50 ), ctrW( 0 ), ctrW( 1050 ), rowIndex, "capital", "updateRoleCapital" )
    //##########################################################################

    //##########################################################################
    //MaxAmount
    changePanel( sv_rolesRoles.panelAmountMax, widee, ctrW( 50 ), ctrW( 0 ), ctrW( 1200 ), lang.rolemaxamount .. " (" .. lang.default .. ": -1 (" .. lang.disabled .. "))" )
    changeTextEntry( sv_rolesRoles.TextEntryAmountMax, widee, ctrW( 50 ), ctrW( 0 ), ctrW( 1200 ), rowIndex, "maxamount", "updateRoleMaxAmount" )
    //##########################################################################

    //##########################################################################
    //HP
    changePanel( sv_rolesRoles.panelHP, ctrW( 400 ), ctrW( 50 ), ctrW( 0 ), ctrW( 1350 ), lang.rolehealth )
    changeTextEntry( sv_rolesRoles.TextEntryHP, ctrW( 400 ), ctrW( 50 ), ctrW( 0 ), ctrW( 1350 ), rowIndex, "hp", "updateRoleHp" )

    changePanel( sv_rolesRoles.panelHPmax, ctrW( 400 ), ctrW( 50 ), ctrW( 400+10 ), ctrW( 1350 ), lang.rolemaxhealth )
    changeTextEntry( sv_rolesRoles.TextEntryHPmax, ctrW( 400 ), ctrW( 50 ), ctrW( 400+10 ), ctrW( 1350 ), rowIndex, "hpmax", "updateRoleHpMax" )

    changePanel( sv_rolesRoles.panelHPreg, ctrW( 400 ), ctrW( 50 ), ctrW( 800+20 ), ctrW( 1350 ), lang.rolehealthreg )
    changeTextEntry( sv_rolesRoles.TextEntryHPreg, ctrW( 400 ), ctrW( 50 ), ctrW( 800+20 ), ctrW( 1350 ), rowIndex, "hpreg", "updateRoleHpReg" )
    //##########################################################################

    //##########################################################################
    //AR
    changePanel( sv_rolesRoles.panelAR, ctrW( 400 ), ctrW( 50 ), ctrW( 0 ), ctrW( 1500 ), lang.rolearmor )
    changeTextEntry( sv_rolesRoles.TextEntryAR, ctrW( 400 ), ctrW( 50 ), ctrW( 0 ), ctrW( 1500 ), rowIndex, "ar", "updateRoleAr" )

    changePanel( sv_rolesRoles.panelARmax, ctrW( 400 ), ctrW( 50 ), ctrW( 400+10 ), ctrW( 1500 ), lang.rolemaxarmor )
    changeTextEntry( sv_rolesRoles.TextEntryARmax, ctrW( 400 ), ctrW( 50 ), ctrW( 400+10 ), ctrW( 1500 ), rowIndex, "armax", "updateRoleArMax" )

    changePanel( sv_rolesRoles.panelARreg, ctrW( 400 ), ctrW( 50 ), ctrW( 800+20 ), ctrW( 1500 ), lang.rolearmorreg )
    changeTextEntry( sv_rolesRoles.TextEntryARreg, ctrW( 400 ), ctrW( 50 ), ctrW( 800+20 ), ctrW( 1500 ), rowIndex, "arreg", "updateRoleArReg" )
    //##########################################################################

    //##########################################################################
    //Walk
    changePanel( sv_rolesRoles.panelSpeedWalk, widee, ctrW( 50 ), ctrW( 0 ), ctrW( 1650 ), lang.rolewalkspeed .. " (" .. lang.roleplayshort .. "-" .. lang.default .. ": 150)" )
    changeTextEntry( sv_rolesRoles.TextEntrySpeedWalk, widee, ctrW( 50 ), ctrW( 0 ), ctrW( 1650 ), rowIndex, "speedwalk", "updateRoleSpeedWalk" )
    //##########################################################################

    //##########################################################################
    //Run
    changePanel( sv_rolesRoles.panelSpeedRun, widee, ctrW( 50 ), ctrW( 0 ), ctrW( 1800 ), lang.rolerunspeed .. " (" .. lang.roleplayshort .. "-" .. lang.default .. ": 240)" )
    changeTextEntry( sv_rolesRoles.TextEntrySpeedRun, widee, ctrW( 50 ), ctrW( 0 ), ctrW( 1800 ), rowIndex, "speedrun", "updateRoleSpeedRun" )
    //##########################################################################

    //##########################################################################
    //JumpPower
    changePanel( sv_rolesRoles.panelJumpPower, widee, ctrW( 50 ), ctrW( 0 ), ctrW( 1950 ), lang.rolejumppower .. " (" .. lang.roleplayshort .. "-" .. lang.default .. ": 200)" )
    changeTextEntry( sv_rolesRoles.TextEntryJumpPower, widee, ctrW( 50 ), ctrW( 0 ), ctrW( 1950 ), rowIndex, "powerjump", "updateRolePowerJump" )
    //##########################################################################

    //##########################################################################
    //prerole
    changePanel( sv_rolesRoles.panelPreRole, widee, ctrW( 50 ), ctrW( 0 ), ctrW( 2100 ), lang.roleprerole )
    changeComboBox( sv_rolesRoles.DComboBoxPreRole, widee, ctrW( 50 ), ctrW( 0 ), ctrW( 2100+50 ), "No Pre Role", rowIndex, "prerole", "updateRolePreRole" )
    //##########################################################################

    //##########################################################################
    //instructor
    changePanel( sv_rolesRoles.panelInstructor, widee, ctrW( 50 ), ctrW( 0 ), ctrW( 2250 ), lang.roleinstructor )
    changeCheckBox( sv_rolesRoles.DCheckBoxInstructor, ctrW( 30 ), ctrW( 0 ), ctrW( 2300 ), "instructor", "updateRoleInstructor")
    //##########################################################################

    //##########################################################################
    //Role Group
    changePanel( sv_rolesRoles.panelGroup, widee, ctrW( 50 ), ctrW( 0 ), ctrW( 2400 ), lang.rolegroup )
    changeComboBox( sv_rolesRoles.DComboBoxGroup, widee, ctrW( 50 ), ctrW( 0 ), ctrW( 2400+50 ), "", rowIndex, "groupID", "updateRoleGroup" )
    //##########################################################################

    //##########################################################################
    //Role SWEPS
    changePanel( sv_rolesRoles.panelSWEPS, widee, ctrW( 50 ), ctrW( 0 ), ctrW( 2550 ), lang.rolesweps )
    sv_rolesRoles.DButtonSWEPS:SetSize( ctrW( 300 ), ctrW( 50 ) )
    sv_rolesRoles.DButtonSWEPS:SetPos( ctrW( 0 ), ctrW( 2600 ) )
    sv_rolesRoles.DButtonSWEPS:SetText( "" )
    function sv_rolesRoles.DButtonSWEPS:Paint()
      draw.RoundedBox( 0, 0, 0, sv_rolesRoles.DButtonSWEPS:GetWide(), sv_rolesRoles.DButtonSWEPS:GetTall(), Color( 255, 255, 255, 100 ) )
      draw.SimpleText( lang.openswepmenu, "SettingsNormal", sv_rolesRoles.DButtonSWEPS:GetWide()/2, sv_rolesRoles.DButtonSWEPS:GetTall()/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    function sv_rolesRoles.DButtonSWEPS:DoClick()
      swepMenu = createVGUI( "DFrame", nil, 2000, 2000, ScrW()/2 * ctrF( ScrH() ) - 2000/2, 2160/2 - 2000/2 )
      swepMenu:SetTitle( lang.swepmenu )

      //PrintTable( weapons.GetList() )
      local roleSwepList = string.Explode( ",", sv_rolesRoles.table[rowIndex].sweps )
      local swepList = {}
      swepList.x = 0
      swepList.y = 50

      local roleSwepScrollBar = createVGUI( "DScrollPanel", swepMenu, 2000-60, 2000-60, swepList.x, swepList.y )
      for k, weapon in pairs ( weapons.GetList() ) do
        if !string.find( string.lower( weapon.ClassName ), "npc") and !string.find( string.lower( weapon.ClassName ), "base") and !string.find( string.lower( weapon.ClassName ), "ttt") then
          local model3D = createVGUI( "DModelPanel", roleSwepScrollBar, 256, 256, swepList.x, swepList.y )
          if weapon.WorldModel != nil then
            model3D:SetModel( weapon.WorldModel )
            model3D:SetLookAt( Vector( 0, 0, 0 ) )
            model3D:SetCamPos( Vector( 0, 0, 0 ) + Vector( -30, 0, 20 ) )
          end
          if weapon.PrintName != nil then
            model3D.PrintName = weapon.PrintName
          end
          if weapon.ClassName != nil then
            model3D.ClassName = weapon.ClassName
          else
            model3D.ClassName = ""
          end

          model3D.button = vgui.Create( "DButton", model3D )
          model3D.button:SetSize( model3D:GetSize() )
          model3D.button:SetPos( 0, 0 )
          model3D.button:SetText( "" )
          function model3D.button:Paint( w, h )
            if table.HasValue( roleSwepList, weapon.ClassName ) then
              draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 255, 0, 60 ) )
              draw.SimpleText( lang.added, "SettingsNormal", w/2, ctrW( 20 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            else
              draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 60 ) )
              draw.SimpleText( lang.notadded, "SettingsNormal", w/2, ctrW( 20 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            end
            draw.SimpleText( model3D.ClassName, "weaponT", w/2, h - ctrW( 18 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            draw.SimpleText( model3D.PrintName, "weaponT", w/2, h - ctrW( 36+6 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
          end
          function model3D.button:DoClick()
            if table.HasValue( roleSwepList, model3D.ClassName ) then
              table.RemoveByValue( roleSwepList, model3D.ClassName )
            else
              table.insert( roleSwepList, model3D.ClassName )
            end

            sv_rolesRoles.table[rowIndex].sweps = ""
            for k, v in pairs( roleSwepList ) do
              if v != "" and v != nil then
                sv_rolesRoles.table[rowIndex].sweps = sv_rolesRoles.table[rowIndex].sweps .. v .. ","
              end
            end
            net.Start( "updateRoleSweps" )
              net.WriteInt(  sv_rolesRoles.table[rowIndex].uniqueID, 16 )
              net.WriteString( sv_rolesRoles.table[rowIndex].sweps )
            net.SendToServer()
          end

          swepList.x = swepList.x + 256 + 16

          if ctrW( swepList.x ) > ctrW( 1888 ) then
            swepList.y = swepList.y + 256 + 16
            swepList.x = 0
          end
        end
      end
      swepMenu:MakePopup()
    end
    //##########################################################################

    //##########################################################################
    //adminonly
    changePanel( sv_rolesRoles.panelAdminOnly, widee, ctrW( 50 ), ctrW( 0 ), ctrW( 2700 ), lang.roleadminonly )
    changeCheckBox( sv_rolesRoles.DCheckBoxAdminOnly, ctrW( 30 ), ctrW( 0 ), ctrW( 2750 ), "adminonly", "updateRoleAdminonly")
    //##########################################################################

    //##########################################################################
    //whitelist
    changePanel( sv_rolesRoles.panelWhitelist, widee, ctrW( 50 ), ctrW( 0 ), ctrW( 2850 ), lang.rolewhitelist )
    changeCheckBox( sv_rolesRoles.DCheckBoxWhitelist, ctrW( 30 ), ctrW( 0 ), ctrW( 2900 ), "whitelist", "updateRoleWhitelist")
    //##########################################################################
  end
  //############################################################################

  sv_rolesRoles:SelectFirstItem()
end
