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
        if _tmpBuilding.ownerCharID == "" and tonumber( _tmpBuilding.groupID ) == -1 then
          buyWindow( _building, _tmpBuilding.name, _tmpBuilding.buildingprice, _door )
        elseif _tmpBuilding.ownerCharID == ply:CharID() or _tmpBuilding.groupID != -1 then
          optionWindow( _building, _tmpBuilding.name, _tmpBuilding.buildingprice, _door, owner )
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
end)

function buyWindow( buildingID, name, price, door )
  openMenu()
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

  _doorWindow = createVGUI( "DFrame", nil, 1090, 210, 0, 0 )
  _doorWindow:Center()
  _doorWindow:SetTitle( "" )
  function _doorWindow:Close()
    _doorWindow:Remove()
  end
  function _doorWindow:Paint( pw, ph )
    paintWindow( self, pw, ph, lang_string( "buymenu" ) )

    draw.SimpleTextOutlined( lang_string( "name" ) .. ": " .. _name, "sef", ctr( 10 ), ctr( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "price" ) .. ": " .. ply:GetNWString( "moneyPre" ) .. _price .. ply:GetNWString( "moneyPost" ), "sef", ctr( 10 ), ctr( 100 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "doors" ) .. ": " .. _doors, "sef", ctr( 10 ), ctr( 150 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )

    draw.RoundedBox( 0, ctr( 4 ), ctr( 210 ), pw - ctr( 8 ), ctr( 530 - 210 - 4 ), Color( 255, 255, 0, 200 ) )
    draw.SimpleTextOutlined( lang_string( "name" ) .. ":", "sef", ctr( 10 ), ctr( 220 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "building" ) .. ":", "sef", ctr( 10 ), ctr( 320 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "group" ) .. ":", "sef", ctr( 10 ), ctr( 420 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "price" ) .. ":", "sef", ctr( 545 ), ctr( 420 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
  end
  function _doorWindow:OnClose()
    closeMenu()
  end
  function _doorWindow:OnRemove()
    closeMenu()
  end

  local _buyButton = createVGUI( "DButton", _doorWindow, 530, 50, 545, 150 )
  _buyButton:SetText( "" )
  function _buyButton:DoClick()
    net.Start( "buyBuilding" )
      net.WriteInt( _buildingID, 16 )
    net.SendToServer()
    _doorWindow:Close()
  end
  function _buyButton:Paint( pw, ph )
    paintButton( self, pw, ph, lang_string( "buybuildingpre" ) .. " " .. _name .. " " .. lang_string( "buybuildingpos" ) )
  end

  if ply:IsAdmin() or ply:IsSuperAdmin() then
    local _TextEntryName = createVGUI( "DTextEntry", _doorWindow, 530, 50, 10, 270 )
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

    local _ComboBoxHouseName = createVGUI( "DComboBox", _doorWindow, 530, 50, 10, 370 )
    net.Start( "getBuildings" )
    net.SendToServer()

    net.Receive( "getBuildings", function()
      local _tmpBuildings = net.ReadTable()
      
      if _ComboBoxHouseName != NULL then
        for k, v in pairs( _tmpBuildings ) do
          _ComboBoxHouseName:AddChoice( v.name, v.uniqueID, false )
        end
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

    local _ButtonAddNew = createVGUI( "DButton", _doorWindow, 530, 50, 545, 370 )
    _ButtonAddNew:SetText( "" )
    function _ButtonAddNew:DoClick()

    end
    function _ButtonAddNew:Paint( pw, ph )
      paintButton( self, pw, ph, lang_string( "addanewbuilding" ) )
    end

    local _ComboBoxGroupName = createVGUI( "DComboBox", _doorWindow, 530, 50, 10, 470 )
    net.Start( "getBuildingGroups" )
    net.SendToServer()

    net.Receive( "getBuildingGroups", function()
      local _tmpGroups = net.ReadTable()

      if _ComboBoxGroupName != NULL then
        for k, v in pairs( _tmpGroups ) do
          _ComboBoxGroupName:AddChoice( v.groupID, v.uniqueID, false )
        end
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

    local _TextEntryPrice = createVGUI( "DTextEntry", _doorWindow, 530, 50, 545, 470 )
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

    _doorWindow:SetSize( ctr( 1090 ), ctr( 530 ) )
    _doorWindow:Center()
  end

  _doorWindow:MakePopup()
end

function optionWindow( buildingID, name, price, door, owner )
  openMenu()
  local ply = LocalPlayer()
  local _buildingID = buildingID
  local _name = name
  local _price = price

  local _doorWindow = createVGUI( "DFrame", nil, 1090, 320, 0, 0 )
  _doorWindow:Center()
  _doorWindow:SetTitle( "" )
  function _doorWindow:Close()
    _doorWindow:Remove()
  end
  function _doorWindow:Paint( pw, ph )
    paintWindow( self, pw, ph, lang_string( "settings" ) )
    --draw.RoundedBox( 0, 0, 0, pw, ph, get_dbg_col() )

    draw.SimpleTextOutlined( lang_string( "name" ) .. ": " .. _name, "sef", ctr( 10 ), ctr( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "owner" ) .. ": " .. owner, "sef", ctr( 10 ), ctr( 100 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    --draw.SimpleTextOutlined( lang_string( "doorlevel" ) .. ": " .. door:GetNWInt( "level", -1 ), "sef", ctr( 10 ), ctr( 150 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )

    draw.RoundedBox( 0, ctr( 4 ), ctr( 320 ), pw - ctr( 8 ), ctr( 460 - 320 - 4 ), Color( 255, 255, 0, 200 ) )
    draw.SimpleTextOutlined( lang_string( "name" ) .. ":", "sef", ctr( 10 ), ctr( 350 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
  end
  function _doorWindow:OnClose()
    closeMenu()
  end
  function _doorWindow:OnRemove()
    closeMenu()
  end

  --[[
  local _ButtonUpgrade = createVGUI( "DButton", _doorWindow, 400, 50, 10, 200 )
  _ButtonUpgrade:SetText( lang_string( "upgradedoor" ) .. " (-" .. ply:GetNWString( "moneyPre" ) .. "100" .. ply:GetNWString( "moneyPost" ) .. ") NOT AVAILABLE" )
  function _ButtonUpgrade:DoClick()
    net.Start( "wantHouse" )
      net.WriteInt( _buildingID, 16 )
    net.SendToServer()
    _doorWindow:Close()
  end
  ]]--

  if door:GetNWString( "ownerGroup" ) == "" then
    local _ButtonSell = createVGUI( "DButton", _doorWindow, 530, 50, 10, 260 )
    _ButtonSell:SetText( "" )
    function _ButtonSell:DoClick()
      net.Start( "sellBuilding" )
        net.WriteInt( _buildingID, 16 )
      net.SendToServer()
      _doorWindow:Close()
    end
    function _ButtonSell:Paint( pw, ph )
      paintButton( self, pw, ph, lang_string( "sellbuildingpre" ) .. " " .. _name .. " " .. lang_string( "sellbuildingpos" ) .. " (+" .. ply:GetNWString( "moneyPre" ) .. _price/2 .. ply:GetNWString( "moneyPost" ) .. ")" )
    end
  end

  local _ButtonKeyCreate = createVGUI( "DButton", _doorWindow, 530, 50, 545, 200 )
  _ButtonKeyCreate:SetText( "" )
  function _ButtonKeyCreate:DoClick()
    net.Start( "createKey" )
      net.WriteEntity( door )
      net.WriteInt( _buildingID, 16 )
    net.SendToServer()
    _doorWindow:Close()
  end
  function _ButtonKeyCreate:Paint( pw, ph )
    paintButton( self, pw, ph, lang_string( "createkey" ) .. " (-" .. ply:GetNWString( "moneyPre" ) .. "15" .. ply:GetNWString( "moneyPost" ) .. ")" )
  end

  local _ButtonKeyReset = createVGUI( "DButton", _doorWindow, 530, 50, 545, 260 )
  _ButtonKeyReset:SetText( "" )
  function _ButtonKeyReset:DoClick()
    net.Start( "resetKey" )
      net.WriteEntity( door )
      net.WriteInt( _buildingID, 16 )
    net.SendToServer()
    _doorWindow:Close()
  end
  function _ButtonKeyReset:Paint( pw, ph )
    paintButton( self, pw, ph, lang_string( "resetkey" ) .. " (-" .. ply:GetNWString( "moneyPre" ) .. "15" .. ply:GetNWString( "moneyPost" ) .. ")" )
  end

  if ply:IsAdmin() or ply:IsSuperAdmin() then
    local _TextEntryName = createVGUI( "DTextEntry", _doorWindow, 530, 50, 10, 400 )
    _TextEntryName:SetText( name )
    function _TextEntryName:OnChange()
      local _newName = _TextEntryName:GetText()
      _name = _newName
      net.Start( "changeBuildingName" )
        net.WriteInt( _buildingID, 16 )
        net.WriteString( _newName )
      net.SendToServer()
    end

    local _buttonRemoveOwner = createVGUI( "DButton", _doorWindow, 530, 50, 545, 400 )
    _buttonRemoveOwner:SetText( "" )
    function _buttonRemoveOwner:DoClick()
      net.Start( "removeOwner" )
        net.WriteInt( _buildingID, 16 )
      net.SendToServer()
      _doorWindow:Close()
    end
    function _buttonRemoveOwner:Paint( pw, ph )
      paintButton( self, pw, ph, lang_string( "removeowner" ) )
    end


    _doorWindow:SetSize( ctr( 1090 ), ctr( 460 ) )
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
