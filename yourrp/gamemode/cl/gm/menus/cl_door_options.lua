--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

net.Receive( "getBuildingInfo", function( len )
  if net.ReadBool() then
    local _door = net.ReadEntity()
    local _building = net.ReadInt( 16 )
    local _tmpBuilding = net.ReadTable()
    local owner = net.ReadString()

    local ply = LocalPlayer()
    if ply:GetNWBool( "toggle_building", false ) then
      if _building != nil and _tmpBuilding != nil then
        if _tmpBuilding[1] != nil then
          if _tmpBuilding[1].ownerCharID == "" and tonumber( _tmpBuilding[1].groupID ) == -1 then
            buyWindow( _building, _tmpBuilding[1].name, _tmpBuilding[1].buildingprice, _door )
          elseif _tmpBuilding[1].ownerCharID == ply:CharID() or _tmpBuilding[1].groupID != -1 then
            optionWindow( _building, _tmpBuilding[1].name, _tmpBuilding[1].buildingprice, _door, owner )
          else
            printGM( "note", "fail" )
          end
        else
          printGM( "note", "getDoorInfo Table empty" )
        end
      else
        printGM( "note", "getDoorInfo Receive: NIL" )
      end
    end
  end
end)

function buyWindow( buildingID, name, price, door )
  local ply = LocalPlayer()
  local _buildingID = buildingID
  local _name = name
  local _price = price

  local _doors = 0
  local _tmpDoors = ents.FindByClass( "prop_door_rotating" )
  for k, v in pairs( _tmpDoors ) do
    if tonumber( v:GetNWInt( "buildingID" ) ) == tonumber( _buildingID ) then
      _doors = _doors + 1
    end
  end
  local _tmpFDoors = ents.FindByClass( "func_door" )
  for k, v in pairs( _tmpFDoors ) do
    if tonumber( v:GetNWInt( "buildingID" ) ) == tonumber( _buildingID ) then
      _doors = _doors + 1
    end
  end
  local _tmpFRDoors = ents.FindByClass( "func_door_rotating" )
  for k, v in pairs( _tmpFRDoors ) do
    if tonumber( v:GetNWInt( "buildingID" ) ) == tonumber( _buildingID ) then
      _doors = _doors + 1
    end
  end

  _doorWindow = createVGUI( "DFrame", nil, 800, 210, 0, 0 )
  _doorWindow:Center()
  _doorWindow:SetTitle( "" )
  function _doorWindow:Close()
    _doorWindow:Remove()
  end
  function _doorWindow:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, g_yrp.colors.dbackground )

    draw.SimpleTextOutlined( lang_string( "buymenu" ), "sef", ctr( 10 ), ctr( 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )

    draw.SimpleTextOutlined( lang_string( "name" ) .. ": " .. _name, "sef", ctr( 10 ), ctr( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "price" ) .. ": " .. ply:GetNWString( "moneyPre" ) .. _price .. ply:GetNWString( "moneyPost" ), "sef", ctr( 10 ), ctr( 50 + 30 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "doors" ) .. ": " .. _doors, "sef", ctr( 10 ), ctr( 50 + 30 + 30 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )

    draw.RoundedBox( 0, 0, ctr( 210 ), pw, ph, Color( 255, 255, 0, 200 ) )
    draw.SimpleTextOutlined( lang_string( "name" ) .. ":", "sef", ctr( 10 ), ctr( 220 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "building" ) .. ":", "sef", ctr( 10 ), ctr( 320 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "group" ) .. ":", "sef", ctr( 10 ), ctr( 420 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "price" ) .. ":", "sef", ctr( 420 ), ctr( 420 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
  end

  local _buyButton = createVGUI( "DButton", _doorWindow, 400, 50, 10, 150 )
  _buyButton:SetText( lang_string( "buybuildingpre" ) .. " " .. _name .. " " .. lang_string( "buybuildingpos" ) )
  function _buyButton:DoClick()
    net.Start( "buyBuilding" )
      net.WriteInt( _buildingID, 16 )
    net.SendToServer()
    _doorWindow:Close()
  end

  if ply:IsAdmin() or ply:IsSuperAdmin() then
    local _TextEntryName = createVGUI( "DTextEntry", _doorWindow, 400, 50, 10, 250 )
    _TextEntryName:SetText( name )
    function _TextEntryName:OnChange()
      local _newName = _TextEntryName:GetText()
      _name = _newName
      _buyButton:SetText( "Buy " .. _newName )
      net.Start( "changeBuildingName" )
        net.WriteInt( _buildingID, 16 )
        net.WriteString( _newName )
      net.SendToServer()
    end

    local _ComboBoxHouseName = createVGUI( "DComboBox", _doorWindow, 400, 50, 10, 350 )
    net.Start( "getBuildings" )
    net.SendToServer()

    net.Receive( "getBuildings", function()
      local _tmpBuildings = net.ReadTable()

      for k, v in pairs( _tmpBuildings ) do
        _ComboBoxHouseName:AddChoice( v.name, v.uniqueID, false )
      end
    end)
    function _ComboBoxHouseName:OnSelect( index, value, data )
      local _tmpData = _ComboBoxHouseName:GetOptionData( index )
      if _tmpData != nil then
        _buildingID = _ComboBoxHouseName:GetOptionData( index )
        net.Start( "changeBuildingID" )
          net.WriteEntity( door )
          net.WriteInt( _buildingID, 16 )
        net.SendToServer()
        _doorWindow:Close()
      end
    end

    local _ButtonAddNew = createVGUI( "DButton", _doorWindow, 400, 50, 420, 350 )
    _ButtonAddNew:SetText( lang_string( "addanewbuilding" ) )
    function _ButtonAddNew:DoClick()

    end

    local _ComboBoxGroupName = createVGUI( "DComboBox", _doorWindow, 400, 50, 10, 450 )
    net.Start( "getBuildingGroups" )
    net.SendToServer()

    net.Receive( "getBuildingGroups", function()
      local _tmpGroups = net.ReadTable()

      for k, v in pairs( _tmpGroups ) do
        _ComboBoxGroupName:AddChoice( v.groupID, v.uniqueID, false )
      end
    end)
    function _ComboBoxGroupName:OnSelect( index, value, data )
      local _tmpData = _ComboBoxGroupName:GetOptionData( index )
      if _tmpData != nil then
        net.Start( "setBuildingOwnerGroup" )
          net.WriteInt( _buildingID, 16 )
          net.WriteInt( _tmpData, 16 )
        net.SendToServer()
        _doorWindow:Close()
      end
    end

    local _TextEntryPrice = createVGUI( "DTextEntry", _doorWindow, 400, 50, 420, 450 )
    _TextEntryPrice:SetText( _price )
    function _TextEntryPrice:OnChange()
      _price = _TextEntryPrice:GetText()
      if _price != nil then
        net.Start( "changeBuildingPrice" )
          net.WriteInt( _buildingID, 16 )
          net.WriteString( _price )
        net.SendToServer()
      end
    end

    _doorWindow:SetSize( ctr( 830 ), ctr( 510 ) )
    _doorWindow:Center()
  end

  _doorWindow:MakePopup()
end

function optionWindow( buildingID, name, price, door, owner )
  local ply = LocalPlayer()
  local _buildingID = buildingID
  local _name = name
  local _price = price

  local _doorWindow = createVGUI( "DFrame", nil, 800, 270, 0, 0 )
  _doorWindow:Center()
  _doorWindow:SetTitle( "" )
  function _doorWindow:Close()
    _doorWindow:Remove()
  end
  function _doorWindow:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, g_yrp.colors.dbackground )

    draw.SimpleTextOutlined( lang_string( "settings" ), "sef", ctr( 10 ), ctr( 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )

    draw.SimpleTextOutlined( lang_string( "name" ) .. ": " .. _name, "sef", ctr( 10 ), ctr( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "owner" ) .. ": " .. owner, "sef", ctr( 10 ), ctr( 50 + 30 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "doorlevel" ) .. ": " .. door:GetNWInt( "level", -1 ), "sef", ctr( 10 ), ctr( 50 + 30 + 30 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )

    draw.RoundedBox( 0, 0, ctr( 270 ), pw, ph, Color( 255, 255, 0, 200 ) )
    draw.SimpleTextOutlined( lang_string( "name" ) .. ":", "sef", ctr( 10 ), ctr( 280 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
  end

  local _ButtonUpgrade = createVGUI( "DButton", _doorWindow, 400, 50, 10, 150 )
  _ButtonUpgrade:SetText( lang_string( "upgradedoor" ) .. " (-" .. ply:GetNWString( "moneyPre" ) .. "100" .. ply:GetNWString( "moneyPost" ) .. ") NOT AVAILABLE" )
  function _ButtonUpgrade:DoClick()
    --[[net.Start( "wantHouse" )
      net.WriteInt( _buildingID, 16 )
    net.SendToServer()]]--
    _doorWindow:Close()
  end

  if door:GetNWString( "ownerGroup" ) == "" then
    local _ButtonSell = createVGUI( "DButton", _doorWindow, 400, 50, 10, 210 )
    _ButtonSell:SetText( lang_string( "sellbuildingpre" ) .. " " .. _name .. " " .. lang_string( "sellbuildingpos" ) .. " (+" .. ply:GetNWString( "moneyPre" ) .. _price/2 .. ply:GetNWString( "moneyPost" ) .. ")" )
    function _ButtonSell:DoClick()
      net.Start( "sellBuilding" )
        net.WriteInt( _buildingID, 16 )
      net.SendToServer()
      _doorWindow:Close()
    end
  end

  local _ButtonKeyCreate = createVGUI( "DButton", _doorWindow, 400, 50, 420, 150 )
  _ButtonKeyCreate:SetText( lang_string( "createkey" ) .. " (-" .. ply:GetNWString( "moneyPre" ) .. "15" .. ply:GetNWString( "moneyPost" ) .. ")" )
  function _ButtonKeyCreate:DoClick()
    net.Start( "createKey" )
      net.WriteEntity( door )
      net.WriteInt( _buildingID, 16 )
    net.SendToServer()
    _doorWindow:Close()
  end

  local _ButtonKeyReset = createVGUI( "DButton", _doorWindow, 400, 50, 420, 210 )
  _ButtonKeyReset:SetText( lang_string( "resetkey" ) .. " (-" .. ply:GetNWString( "moneyPre" ) .. "15" .. ply:GetNWString( "moneyPost" ) .. ")" )
  function _ButtonKeyReset:DoClick()
    net.Start( "resetKey" )
      net.WriteEntity( door )
      net.WriteInt( _buildingID, 16 )
    net.SendToServer()
    _doorWindow:Close()
  end

  if ply:IsAdmin() or ply:IsSuperAdmin() then
    local _TextEntryName = createVGUI( "DTextEntry", _doorWindow, 400, 50, 10, 310 )
    _TextEntryName:SetText( name )
    function _TextEntryName:OnChange()
      local _newName = _TextEntryName:GetText()
      _name = _newName
      net.Start( "changeBuildingName" )
        net.WriteInt( _buildingID, 16 )
        net.WriteString( _newName )
      net.SendToServer()
    end

    local _buttonRemoveOwner = createVGUI( "DButton", _doorWindow, 400, 50, 420, 310 )
    _buttonRemoveOwner:SetText( lang_string( "removeowner" ) )
    function _buttonRemoveOwner:DoClick()
      net.Start( "removeOwner" )
        net.WriteInt( _buildingID, 16 )
      net.SendToServer()
      _doorWindow:Close()
    end


    _doorWindow:SetSize( ctr( 830 ), ctr( 370 ) )
    _doorWindow:Center()
  end

  _doorWindow:MakePopup()
end

function openDoorOptions( door, buildingID )
  net.Start( "getBuildingInfo" )
    net.WriteEntity( door )
    net.WriteInt( buildingID, 16 )
  net.SendToServer()
end
