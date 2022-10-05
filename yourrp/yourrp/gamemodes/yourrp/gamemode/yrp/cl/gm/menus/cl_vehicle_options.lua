--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- #VEHICLEOPTIONS

local yrp_vehicle = {}

function YRPToggleVehicleOptions( vehicle, vehicleID)
	if YRPIsNoMenuOpen() and !PanelAlive(yrp_vehicle.window) then
		openVehicleOptions( vehicle, vehicleID)
	else
		closeVehicleOptions()
	end
end

function closeVehicleOptions()
	closeMenu()
	if PanelAlive(yrp_vehicle.window) then
		yrp_vehicle.window:Close()
		yrp_vehicle.window = nil
	end
end

net.Receive( "getVehicleInfo", function(len)
	if net.ReadBool() then
		local vehicle = net.ReadEntity()
		local _tmpVehicle = net.ReadTable()
		optionVehicleWindow( vehicle, _tmpVehicle)
	end
end)

function optionVehicleWindow( vehicle, vehicleTab)
	openMenu()
	local lply = LocalPlayer()

	yrp_vehicle.window = createVGUI( "YFrame", nil, 1090, 160, 0, 0)
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

	local ownercharid = vehicleTab[1].ownerCharID
	ownercharid = tonumber(ownercharid)
	local owner = ""
	for i, v in pairs(player.GetAll() ) do
		if v:CharID() == ownercharid then
			owner = v:RPName()
		end
	end

	yrp_vehicle.window:SetTitle(YRP.lang_string( "LID_owner" ) .. ": " .. owner)
	function yrp_vehicle.window:Paint(pw, ph)
		hook.Run( "YFramePaint", self, pw, ph)

		draw.RoundedBox(0, YRP.ctr(4), YRP.ctr(160), pw - YRP.ctr(8), YRP.ctr(70-4), Color( 255, 255, 0, 200) )
	end

	if lply:HasAccess() then
		local _buttonRemoveOwner = createVGUI( "DButton", yrp_vehicle.window, 530, 50, 545, 170)
		_buttonRemoveOwner:SetText( "" )
		function _buttonRemoveOwner:DoClick()
			net.Start( "removeVehicleOwner" )
				net.WriteString( vehicleTab[1].uniqueID)
			net.SendToServer()
			if PanelAlive(yrp_vehicle.window) then
				yrp_vehicle.window:Close()
			end
		end
		function _buttonRemoveOwner:Paint(pw, ph)
			surfaceButton(self, pw, ph, YRP.lang_string( "LID_removeowner" ) )
		end


		yrp_vehicle.window:SetSize(YRP.ctr(1090), YRP.ctr(230) )
		yrp_vehicle.window:Center()
	end

	yrp_vehicle.window:MakePopup()
end

function openVehicleOptions( vehicle, vehicleID)
	if NotNilAndNotFalse( vehicle) and NotNilAndNotFalse( vehicleID) then
		net.Start( "getVehicleInfo" )
			net.WriteEntity( vehicle)
			net.WriteString( vehicleID)
		net.SendToServer()
	end
end
