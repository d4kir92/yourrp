--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local yrp_vehicle = {}

function toggleVehicleOptions(vehicle, vehicleID)
	if YRPIsNoMenuOpen() then
		openVehicleOptions(vehicle, vehicleID)
	else
		closeVehicleOptions()
	end
end

function closeVehicleOptions()
	closeMenu()
	if yrp_vehicle.window != nil then
		yrp_vehicle.window:Close()
		yrp_vehicle.window = nil
	end
end

net.Receive("getVehicleInfo", function(len)
	if net.ReadBool() then
		local vehicle = net.ReadEntity()
		local _tmpVehicle = net.ReadTable()
		optionVehicleWindow(vehicle, _tmpVehicle)
	end
end)

function optionVehicleWindow(vehicle, vehicleTab)
	openMenu()
	local ply = LocalPlayer()

	yrp_vehicle.window = createVGUI("DFrame", nil, 1090, 160, 0, 0)
	yrp_vehicle.window:Center()
	yrp_vehicle.window:SetTitle("")
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


	function yrp_vehicle.window:Paint(pw, ph)
		surfaceWindow(self, pw, ph, YRP.lang_string("LID_settings"))

		draw.SimpleTextOutlined(YRP.lang_string("LID_owner") .. ": " .. owner, "Y_24_500", YRP.ctr(10), YRP.ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))

		draw.RoundedBox(0, YRP.ctr(4), YRP.ctr(160), pw - YRP.ctr(8), YRP.ctr(70-4), Color(255, 255, 0, 200))
	end

	if ply:HasAccess() then
		local _buttonRemoveOwner = createVGUI("DButton", yrp_vehicle.window, 530, 50, 545, 170)
		_buttonRemoveOwner:SetText("")
		function _buttonRemoveOwner:DoClick()
			net.Start("removeVehicleOwner")
				net.WriteInt(vehicleTab[1].uniqueID, 16)
			net.SendToServer()
			yrp_vehicle.window:Close()
		end
		function _buttonRemoveOwner:Paint(pw, ph)
			surfaceButton(self, pw, ph, YRP.lang_string("LID_removeowner"))
		end


		yrp_vehicle.window:SetSize(YRP.ctr(1090), YRP.ctr(230))
		yrp_vehicle.window:Center()
	end

	yrp_vehicle.window:MakePopup()
end

function openVehicleOptions(vehicle, vehicleID)
	if wk(vehicle) and wk(vehicleID) then
		net.Start("getVehicleInfo")
			net.WriteEntity(vehicle)
			net.WriteString(vehicleID)
		net.SendToServer()
	end
end
