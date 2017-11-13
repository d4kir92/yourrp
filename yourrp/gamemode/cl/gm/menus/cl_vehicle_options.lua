--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

net.Receive( "getVehicleInfo", function( len )
  if net.ReadBool() then
    local vehicle = net.ReadEntity()
    local _tmpVehicle = net.ReadTable()
    optionVehicleWindow( vehicle, _tmpVehicle )
  end
end)

function optionVehicleWindow( vehicle, vehicleTab )
  local ply = LocalPlayer()

  local _vehicleWindow = createVGUI( "DFrame", nil, 800, 270, 0, 0 )
  _vehicleWindow:Center()
  _vehicleWindow:SetTitle( "" )
  function _vehicleWindow:Close()
    _vehicleWindow:Remove()
  end

  local owner = net.ReadString()


  function _vehicleWindow:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, g_yrp.colors.dbackground )

    draw.SimpleTextOutlined( lang_string( "settings" ), "sef", ctr( 10 ), ctr( 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )

    draw.SimpleTextOutlined( lang_string( "owner" ) .. ": " .. owner, "sef", ctr( 10 ), ctr( 50 + 30 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )

    draw.RoundedBox( 0, 0, ctr( 210 ), pw, ph, Color( 255, 255, 0, 200 ) )
  end

  local _ButtonKeyCreate = createVGUI( "DButton", _vehicleWindow, 400, 50, 10, 150 )
  _ButtonKeyCreate:SetText( lang_string( "createkey" ) .. " (-" .. ply:GetNWString( "moneyPre" ) .. "15" .. ply:GetNWString( "moneyPost" ) .. ")" )
  function _ButtonKeyCreate:DoClick()
    net.Start( "createVehicleKey" )
      net.WriteEntity( vehicle )
      net.WriteInt( vehicleTab[1].uniqueID, 16 )
    net.SendToServer()
    _vehicleWindow:Close()
  end

  local _ButtonKeyReset = createVGUI( "DButton", _vehicleWindow, 400, 50, 420, 150 )
  _ButtonKeyReset:SetText( lang_string( "resetkey" ) .. " (-" .. ply:GetNWString( "moneyPre" ) .. "15" .. ply:GetNWString( "moneyPost" ) .. ")" )
  function _ButtonKeyReset:DoClick()
    net.Start( "resetVehicleKey" )
      net.WriteEntity( vehicle )
      net.WriteInt( vehicleTab[1].uniqueID, 16 )
    net.SendToServer()
    _vehicleWindow:Close()
  end

  if ply:IsAdmin() or ply:IsSuperAdmin() then
    local _buttonRemoveOwner = createVGUI( "DButton", _vehicleWindow, 400, 50, 420, 220 )
    _buttonRemoveOwner:SetText( lang_string( "removeowner" ) )
    function _buttonRemoveOwner:DoClick()
      net.Start( "removeVehicleOwner" )
        net.WriteInt( vehicleTab[1].uniqueID, 16 )
      net.SendToServer()
      _vehicleWindow:Close()
    end


    _vehicleWindow:SetSize( ctr( 830 ), ctr( 280 ) )
    _vehicleWindow:Center()
  end

  _vehicleWindow:MakePopup()
end

function openVehicleOptions( vehicle, vehicleID )
  net.Start( "getVehicleInfo" )
    net.WriteEntity( vehicle )
    net.WriteString( vehicleID )
  net.SendToServer()
end
