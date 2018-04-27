--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local yrp_door = {}

function toggleDoorOptions( door )
  if isNoMenuOpen() then
    openDoorOptions( door )
  elseif !mouseVisible then
    closeDoorOptions()
  end
end

function closeDoorOptions()
  closeMenu()
  yrp_door.window:Close()
  yrp_door.window = nil
end

net.Receive( "getBuildingInfo", function( len )
  if net.ReadBool() then
    local _door = net.ReadEntity()
    local _building = net.ReadString()
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
    if tonumber( v:GetNWString( "buildingID", "-1" ) ) == tonumber( _buildingID ) then
      _doors = _doors + 1
    end
  end
  local _tmpFDoors = ents.FindByClass( "func_door" )
  for k, v in pairs( _tmpFDoors ) do
    if tonumber( v:GetNWString( "buildingID", "-1" ) ) == tonumber( _buildingID ) then
      _doors = _doors + 1
    end
  end
  local _tmpFRDoors = ents.FindByClass( "func_door_rotating" )
  for k, v in pairs( _tmpFRDoors ) do
    if tonumber( v:GetNWString( "buildingID", "-1" ) ) == tonumber( _buildingID ) then
      _doors = _doors + 1
    end
  end

  yrp_door.window = createVGUI( "DFrame", nil, 1090, 210, 0, 0 )
  yrp_door.window:Center()
  yrp_door.window:SetTitle( "" )
  function yrp_door.window:Close()
    yrp_door.window:Remove()
  end
  function yrp_door.window:Paint( pw, ph )
    surfaceWindow( self, pw, ph, lang_string( "buymenu" ) )

    draw.SimpleTextOutlined( lang_string( "name" ) .. ": " .. _name, "sef", ctr( 10 ), ctr( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "price" ) .. ": " .. ply:GetNWString( "moneyPre" ) .. _price .. ply:GetNWString( "moneyPost" ), "sef", ctr( 10 ), ctr( 100 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "doors" ) .. ": " .. _doors, "sef", ctr( 10 ), ctr( 150 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )

    draw.RoundedBox( 0, ctr( 4 ), ctr( 210 ), pw - ctr( 8 ), ctr( 530 - 210 - 4 ), Color( 255, 255, 0, 200 ) )
    draw.SimpleTextOutlined( lang_string( "name" ) .. ":", "sef", ctr( 10 ), ctr( 220 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "building" ) .. ":", "sef", ctr( 10 ), ctr( 320 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "group" ) .. ":", "sef", ctr( 10 ), ctr( 420 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "price" ) .. ":", "sef", ctr( 545 ), ctr( 420 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )

    if tostring( door:GetNWString( "buildingID", "-1" ) ) == "-1" then
      draw.SimpleTextOutlined( "Loading IDs", "sef", pw - ctr( 10 ), ctr( 220 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    else
      draw.SimpleTextOutlined( "Building-ID: " .. door:GetNWString( "buildingID", "-1" ), "sef", pw - ctr( 10 ), ctr( 220 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( "Door-ID: " .. door:GetNWString( "uniqueID", "-1" ), "sef", pw - ctr( 10 ), ctr( 280 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    end
  end
  function yrp_door.window:OnClose()
    closeMenu()
  end
  function yrp_door.window:OnRemove()
    closeMenu()
  end

  local _buyButton = createVGUI( "DButton", yrp_door.window, 530, 50, 545, 150 )
  _buyButton:SetText( "" )
  function _buyButton:DoClick()
    net.Start( "buyBuilding" )
      net.WriteString( _buildingID )
    net.SendToServer()
    if yrp_door.window.Close != nil then
      yrp_door.window:Close()
    end
  end
  function _buyButton:Paint( pw, ph )
    surfaceButton( self, pw, ph, lang_string( "buybuildingpre" ) .. " " .. _name .. " " .. lang_string( "buybuildingpos" ) )
  end

  if ply:HasAccess() then
    local _TextEntryName = createVGUI( "DTextEntry", yrp_door.window, 530, 50, 10, 270 )
    _TextEntryName:SetText( name )
    function _TextEntryName:OnChange()
      local _newName = _TextEntryName:GetText()
      _name = _newName
      _buyButton:SetText( "Buy " .. _newName )
      net.Start( "changeBuildingName" )
        net.WriteString( _buildingID )
        net.WriteString( _newName )
      net.SendToServer()
    end

    local _ComboBoxHouseName = createVGUI( "DComboBox", yrp_door.window, 530, 50, 10, 370 )
    net.Start( "getBuildings" )
    net.SendToServer()

    net.Receive( "getBuildings", function()
      local _tmpBuildings = net.ReadTable()

      if _ComboBoxHouseName != NULL then
        for k, v in pairs( _tmpBuildings ) do
          if pa( _ComboBoxHouseName ) then
            _ComboBoxHouseName:AddChoice( v.name, v.uniqueID, false )
          else
            break
          end
        end
      end
    end)
    function _ComboBoxHouseName:OnSelect( index, value, data )
      local _tmpData = _ComboBoxHouseName:GetOptionData( index )
      if _tmpData != nil then
        _buildingID = _ComboBoxHouseName:GetOptionData( index )
        net.Start( "changeBuildingID" )
          net.WriteEntity( door )
          net.WriteString( _buildingID )
        net.SendToServer()
        yrp_door.window:Close()
      end
    end

    local _ButtonAddNew = createVGUI( "DButton", yrp_door.window, 530, 50, 545, 370 )
    _ButtonAddNew:SetText( "" )
    function _ButtonAddNew:DoClick()

    end
    function _ButtonAddNew:Paint( pw, ph )
      surfaceButton( self, pw, ph, lang_string( "addanewbuilding" ) )
    end

    local _ComboBoxGroupName = createVGUI( "DComboBox", yrp_door.window, 530, 50, 10, 470 )
    net.Start( "getBuildingGroups" )
    net.SendToServer()

    net.Receive( "getBuildingGroups", function()
      local _tmpGroups = net.ReadTable()

      if _ComboBoxGroupName != NULL then
        for k, v in pairs( _tmpGroups ) do
          if pa( _ComboBoxGroupName ) then
            _ComboBoxGroupName:AddChoice( v.groupID, v.uniqueID, false )
          else
            break
          end
        end
      end
    end)
    function _ComboBoxGroupName:OnSelect( index, value, data )
      local _tmpData = _ComboBoxGroupName:GetOptionData( index )
      if _tmpData != nil then
        net.Start( "setBuildingOwnerGroup" )
          net.WriteString( _buildingID )
          net.WriteInt( _tmpData, 16 )
        net.SendToServer()
        yrp_door.window:Close()
      end
    end

    local _TextEntryPrice = createVGUI( "DTextEntry", yrp_door.window, 530, 50, 545, 470 )
    _TextEntryPrice:SetText( _price )
    function _TextEntryPrice:OnChange()
      _price = _TextEntryPrice:GetText()
      if _price != nil then
        net.Start( "changeBuildingPrice" )
          net.WriteString( _buildingID )
          net.WriteString( _price )
        net.SendToServer()
      end
    end

    yrp_door.window:SetSize( ctr( 1090 ), ctr( 530 ) )
    yrp_door.window:Center()
  end

  yrp_door.window:MakePopup()
end

function optionWindow( buildingID, name, price, door, owner )
  openMenu()
  local ply = LocalPlayer()
  local _buildingID = buildingID
  local _name = name
  local _price = price

  yrp_door.window = createVGUI( "DFrame", nil, 1090, 320, 0, 0 )
  yrp_door.window:Center()
  yrp_door.window:SetTitle( "" )
  function yrp_door.window:Close()
    yrp_door.window:Remove()
  end
  function yrp_door.window:Paint( pw, ph )
    surfaceWindow( self, pw, ph, lang_string( "settings" ) )
    --draw.RoundedBox( 0, 0, 0, pw, ph, get_dbg_col() )

    draw.SimpleTextOutlined( lang_string( "name" ) .. ": " .. _name, "sef", ctr( 10 ), ctr( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "owner" ) .. ": " .. owner, "sef", ctr( 10 ), ctr( 100 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    --draw.SimpleTextOutlined( lang_string( "doorlevel" ) .. ": " .. door:GetNWString( "level", -1 ), "sef", ctr( 10 ), ctr( 150 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )

    draw.RoundedBox( 0, ctr( 4 ), ctr( 320 ), pw - ctr( 8 ), ctr( 460 - 320 - 4 ), Color( 255, 255, 0, 200 ) )
    draw.SimpleTextOutlined( lang_string( "name" ) .. ":", "sef", ctr( 10 ), ctr( 350 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )

    draw.SimpleTextOutlined( "Building-ID: " .. door:GetNWString( "buildingID", "FAILED" ), "sef", pw - ctr( 10 ), ctr( 320 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "Door-ID: " .. door:GetNWString( "uniqueID", -1 ), "sef", pw - ctr( 10 ), ctr( 380 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
  end
  function yrp_door.window:OnClose()
    closeMenu()
  end
  function yrp_door.window:OnRemove()
    closeMenu()
  end

  --[[
  local _ButtonUpgrade = createVGUI( "DButton", yrp_door.window, 400, 50, 10, 200 )
  _ButtonUpgrade:SetText( lang_string( "upgradedoor" ) .. " (-" .. ply:GetNWString( "moneyPre" ) .. "100" .. ply:GetNWString( "moneyPost" ) .. ") NOT AVAILABLE" )
  function _ButtonUpgrade:DoClick()
    net.Start( "wantHouse" )
      net.WriteInt( _buildingID, 16 )
    net.SendToServer()
    yrp_door.window:Close()
  end
  ]]--

  if door:GetNWString( "ownerGroup" ) == "" then
    local _ButtonSell = createVGUI( "DButton", yrp_door.window, 530, 50, 10, 260 )
    _ButtonSell:SetText( "" )
    function _ButtonSell:DoClick()
      net.Start( "sellBuilding" )
        net.WriteString( _buildingID )
      net.SendToServer()
      yrp_door.window:Close()
    end
    function _ButtonSell:Paint( pw, ph )
      surfaceButton( self, pw, ph, lang_string( "sellbuildingpre" ) .. " " .. _name .. " " .. lang_string( "sellbuildingpos" ) .. " (+" .. ply:GetNWString( "moneyPre" ) .. _price/2 .. ply:GetNWString( "moneyPost" ) .. ")" )
    end
  end

  if ply:HasAccess() then
    local _TextEntryName = createVGUI( "DTextEntry", yrp_door.window, 530, 50, 10, 400 )
    _TextEntryName:SetText( name )
    function _TextEntryName:OnChange()
      local _newName = _TextEntryName:GetText()
      _name = _newName
      net.Start( "changeBuildingName" )
        net.WriteString( _buildingID )
        net.WriteString( _newName )
      net.SendToServer()
    end

    local _buttonRemoveOwner = createVGUI( "DButton", yrp_door.window, 530, 50, 545, 400 )
    _buttonRemoveOwner:SetText( "" )
    function _buttonRemoveOwner:DoClick()
      net.Start( "removeOwner" )
        net.WriteString( _buildingID )
      net.SendToServer()
      yrp_door.window:Close()
    end
    function _buttonRemoveOwner:Paint( pw, ph )
      surfaceButton( self, pw, ph, lang_string( "removeowner" ) )
    end


    yrp_door.window:SetSize( ctr( 1090 ), ctr( 460 ) )
    yrp_door.window:Center()
  end

  yrp_door.window:MakePopup()
end

function openDoorOptions( door )
  net.Start( "getBuildingInfo" )
    net.WriteEntity( door )
  net.SendToServer()
end
