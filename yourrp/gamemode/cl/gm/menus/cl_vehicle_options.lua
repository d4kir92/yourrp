--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local yrp_vehicle = {}

function toggleVehicleOptions( vehicle, vehicleID )
  if isNoMenuOpen() then
    openVehicleOptions( vehicle, vehicleID )
  else
    closeVehicleOptions()
  end
end

function closeVehicleOptions()
  closeMenu()
  yrp_vehicle.window:Close()
  yrp_vehicle.window = nil
end

net.Receive( "getVehicleInfo", function( len )
  if net.ReadBool() then
    local vehicle = net.ReadEntity()
    local _tmpVehicle = net.ReadTable()
    optionVehicleWindow( vehicle, _tmpVehicle )
  end
end)

function optionVehicleWindow( vehicle, vehicleTab )
  openMenu()
  local ply = LocalPlayer()

  yrp_vehicle.window = createVGUI( "DFrame", nil, 1090, 160, 0, 0 )
  yrp_vehicle.window:Center()
  yrp_vehicle.window:SetTitle( "" )
  function yrp_vehicle.window:Close()
    yrp_vehicle.window:Remove()
  end
  function yrp_vehicle.window:OnClose()
    closeMenu()
  end
  function yrp_vehicle.window:OnRemove()
    closeMenu()
  end

  local owner = net.ReadString()


  function yrp_vehicle.window:Paint( pw, ph )
    paintWindow( self, pw, ph, lang_string( "settings" ) )

    draw.SimpleTextOutlined( lang_string( "owner" ) .. ": " .. owner, "sef", ctr( 10 ), ctr( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )

    draw.RoundedBox( 0, ctr( 4 ), ctr( 160 ), pw - ctr( 8 ), ctr( 70-4 ), Color( 255, 255, 0, 200 ) )
  end

  local _ButtonKeyCreate = createVGUI( "DButton", yrp_vehicle.window, 530, 50, 10, 100 )
  _ButtonKeyCreate:SetText( "" )
  function _ButtonKeyCreate:DoClick()
    net.Start( "createVehicleKey" )
      net.WriteEntity( vehicle )
      net.WriteInt( vehicleTab[1].uniqueID, 16 )
    net.SendToServer()
    yrp_vehicle.window:Close()
  end
  function _ButtonKeyCreate:Paint( pw, ph )
    paintButton( self, pw, ph, lang_string( "createkey" ) .. " (-" .. ply:GetNWString( "moneyPre" ) .. "15" .. ply:GetNWString( "moneyPost" ) .. ")" )
  end

  local _ButtonKeyReset = createVGUI( "DButton", yrp_vehicle.window, 530, 50, 545, 100 )
  _ButtonKeyReset:SetText( "" )
  function _ButtonKeyReset:DoClick()
    net.Start( "resetVehicleKey" )
      net.WriteEntity( vehicle )
      net.WriteInt( vehicleTab[1].uniqueID, 16 )
    net.SendToServer()
    yrp_vehicle.window:Close()
  end
  function _ButtonKeyReset:Paint( pw, ph )
    paintButton( self, pw, ph, lang_string( "resetkey" ) .. " (-" .. ply:GetNWString( "moneyPre" ) .. "15" .. ply:GetNWString( "moneyPost" ) .. ")" )
  end

  if ply:IsAdmin() or ply:IsSuperAdmin() then
    local _buttonRemoveOwner = createVGUI( "DButton", yrp_vehicle.window, 530, 50, 545, 170 )
    _buttonRemoveOwner:SetText( "" )
    function _buttonRemoveOwner:DoClick()
      net.Start( "removeVehicleOwner" )
        net.WriteInt( vehicleTab[1].uniqueID, 16 )
      net.SendToServer()
      yrp_vehicle.window:Close()
    end
    function _buttonRemoveOwner:Paint( pw, ph )
      paintButton( self, pw, ph, lang_string( "removeowner" ) )
    end


    yrp_vehicle.window:SetSize( ctr( 1090 ), ctr( 230 ) )
    yrp_vehicle.window:Center()
  end

  yrp_vehicle.window:MakePopup()
end

function openVehicleOptions( vehicle, vehicleID )
  net.Start( "getVehicleInfo" )
    net.WriteEntity( vehicle )
    net.WriteString( vehicleID )
  net.SendToServer()
end
