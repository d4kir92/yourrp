
net.Receive( "getBuildingInfo", function( len )
  local _door = net.ReadEntity()
  local _building = net.ReadInt( 16 )
  local _tmpBuilding = net.ReadTable()

  local ply = LocalPlayer()
  if _building != nil and _tmpBuilding != nil then
    if _tmpBuilding[1] != nil then
      if _tmpBuilding[1].ownerSteamID == "" and tonumber( _tmpBuilding[1].groupID ) == -1 then
        buyWindow( _building, _tmpBuilding[1].name, _tmpBuilding[1].price, _door )
      elseif _tmpBuilding[1].ownerSteamID == ply:SteamID() or _tmpBuilding[1].groupID != -1 then
        optionWindow( _building, _tmpBuilding[1].name, _tmpBuilding[1].price, _door )
      else
        printGM( "note", "fail" )
        _menuIsOpen = 0
      end
    else
      _menuIsOpen = 0
      printGM( "note", "getDoorInfo Table empty" )
    end
  else
    _menuIsOpen = 0
    printGM( "note", "getDoorInfo Receive: NIL" )
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

  local _doorWindow = createVGUI( "DFrame", nil, 800, 210, 0, 0 )
  _doorWindow:Center()
  _doorWindow:SetTitle( "" )
  function _doorWindow:Close()
    _menuIsOpen = 0
    _doorWindow:Remove()
  end
  function _doorWindow:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, yrpsettings.color.background )

    draw.SimpleText( "Buy Menu", "DermaDefault", calculateToResu( 10 ), calculateToResu( 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

    draw.SimpleText( "Name: " .. _name, "DermaDefault", calculateToResu( 10 ), calculateToResu( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    draw.SimpleText( "Price: " .. _price .. "€", "DermaDefault", calculateToResu( 10 ), calculateToResu( 50 + 30 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    draw.SimpleText( "Doors: " .. _doors, "DermaDefault", calculateToResu( 10 ), calculateToResu( 50 + 30 + 30 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

    draw.RoundedBox( 0, 0, calculateToResu( 210 ), pw, ph, Color( 255, 255, 0, 200 ) )
    draw.SimpleText( "Name:", "DermaDefault", calculateToResu( 10 ), calculateToResu( 220 ), Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    draw.SimpleText( "Building:", "DermaDefault", calculateToResu( 10 ), calculateToResu( 320 ), Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    draw.SimpleText( "Group:", "DermaDefault", calculateToResu( 10 ), calculateToResu( 420 ), Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    draw.SimpleText( "Price:", "DermaDefault", calculateToResu( 420 ), calculateToResu( 420 ), Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
  end

  local _buyButton = createVGUI( "DButton", _doorWindow, 400, 50, 10, 150 )
  _buyButton:SetText( "Buy " .. _name )
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
    _ButtonAddNew:SetText( "Add a new Building" )
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
          net.WriteInt( _price, 16 )
        net.SendToServer()
      end
    end

    _doorWindow:SetSize( calculateToResu( 830 ), calculateToResu( 510 ) )
    _doorWindow:Center()
  end

  _doorWindow:MakePopup()
end

function optionWindow( buildingID, name, price, door )
  local ply = LocalPlayer()
  local _buildingID = buildingID
  local _name = name
  local _price = price

  local _doorWindow = createVGUI( "DFrame", nil, 800, 270, 0, 0 )
  _doorWindow:Center()
  _doorWindow:SetTitle( "" )
  function _doorWindow:Close()
    _menuIsOpen = 0
    _doorWindow:Remove()
  end
  function _doorWindow:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, yrpsettings.color.background )

    draw.SimpleText( "Option Menu", "DermaDefault", calculateToResu( 10 ), calculateToResu( 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

    draw.SimpleText( "Name: " .. _name, "DermaDefault", calculateToResu( 10 ), calculateToResu( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    draw.SimpleText( "Group/Owner: " .. "€", "DermaDefault", calculateToResu( 10 ), calculateToResu( 50 + 30 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    draw.SimpleText( "Door-Level: " .. door:GetNWInt( "level", -1 ), "DermaDefault", calculateToResu( 10 ), calculateToResu( 50 + 30 + 30 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

    draw.RoundedBox( 0, 0, calculateToResu( 270 ), pw, ph, Color( 255, 255, 0, 200 ) )
    draw.SimpleText( "Name:", "DermaDefault", calculateToResu( 10 ), calculateToResu( 280 ), Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
  end

  local _ButtonUpgrade = createVGUI( "DButton", _doorWindow, 400, 50, 10, 150 )
  _ButtonUpgrade:SetText( "Upgrade Door (-100€) NOT AVAILABLE" )
  function _ButtonUpgrade:DoClick()
    /*net.Start( "wantHouse" )
      net.WriteInt( _buildingID, 16 )
    net.SendToServer()*/
    _doorWindow:Close()
  end

  if door:GetNWString( "ownerGroup" ) == "" then
    local _ButtonSell = createVGUI( "DButton", _doorWindow, 400, 50, 10, 210 )
    _ButtonSell:SetText( "Sell Apartment (+" .. _price/2 .. "€)" )
    function _ButtonSell:DoClick()
      net.Start( "sellBuilding" )
        net.WriteInt( _buildingID, 16 )
      net.SendToServer()
      _doorWindow:Close()
    end
  end

  local _ButtonKeyCreate = createVGUI( "DButton", _doorWindow, 400, 50, 420, 150 )
  _ButtonKeyCreate:SetText( "Create Key (-15€)" )
  function _ButtonKeyCreate:DoClick()
    net.Start( "createKey" )
      net.WriteInt( _buildingID, 16 )
    net.SendToServer()
    _doorWindow:Close()
  end

  local _ButtonKeyReset = createVGUI( "DButton", _doorWindow, 400, 50, 420, 210 )
  _ButtonKeyReset:SetText( "Reset Key (-15€)" )
  function _ButtonKeyReset:DoClick()
    /*net.Start( "upgradeDoor" )
      net.WriteInt( _buildingID, 16 )
    net.SendToServer()*/
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
    _buttonRemoveOwner:SetText( "Remove Owner" )
    function _buttonRemoveOwner:DoClick()
      net.Start( "removeOwner" )
        net.WriteInt( _buildingID, 16 )
      net.SendToServer()
      _doorWindow:Close()
    end


    _doorWindow:SetSize( calculateToResu( 830 ), calculateToResu( 370 ) )
    _doorWindow:Center()
  end

  _doorWindow:MakePopup()
end

function openDoorOptions( door, buildingID )
  _menuIsOpen = 1
  net.Start( "getBuildingInfo" )
    net.WriteEntity( door )
    net.WriteInt( buildingID, 16 )
  net.SendToServer()
end
