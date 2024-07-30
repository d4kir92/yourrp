--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- #VEHICLEOPTIONS
local yrp_vehicle = {}
function YRPToggleVehicleOptions(vehicle, vehicleID)
	if YRPIsNoMenuOpen() and not YRPPanelAlive(yrp_vehicle.window) then
		openVehicleOptions(vehicle, vehicleID)
	else
		closeVehicleOptions()
	end
end

function closeVehicleOptions()
	YRPCloseMenu()
	if YRPPanelAlive(yrp_vehicle.window) then
		yrp_vehicle.window:Close()
		yrp_vehicle.window = nil
	end
end

net.Receive(
	"nws_yrp_getVehicleInfo",
	function(len)
		if net.ReadBool() then
			local vehicle = net.ReadEntity()
			local _tmpVehicle = net.ReadTable()
			optionVehicleWindow(vehicle, _tmpVehicle)
		end
	end
)

function optionVehicleWindow(vehicle, vehicleTab)
	YRPOpenMenu()
	local lply = LocalPlayer()
	yrp_vehicle.window = createVGUI("YFrame", nil, 1090, 160, 0, 0)
	yrp_vehicle.window:Center()
	yrp_vehicle.window:SetTitle("")
	function yrp_vehicle.window:Close()
		yrp_vehicle.window:Remove()
	end

	function yrp_vehicle.window:OnClose()
		YRPCloseMenu()
	end

	function yrp_vehicle.window:OnRemove()
		YRPCloseMenu()
	end

	local ownercharid = vehicleTab[1].ownerCharID
	ownercharid = tonumber(ownercharid)
	local owner = ""
	for i, v in pairs(player.GetAll()) do
		if v:CharID() == ownercharid then
			owner = v:RPName()
		end
	end

	yrp_vehicle.window:SetTitle(YRP:trans("LID_owner") .. ": " .. owner)
	function yrp_vehicle.window:Paint(pw, ph)
		hook.Run("YFramePaint", self, pw, ph)
		draw.RoundedBox(0, YRP:ctr(4), YRP:ctr(160), pw - YRP:ctr(8), YRP:ctr(70 - 4), Color(255, 255, 0, 200))
	end

	if lply:HasAccess("optionVehicleWindow") or (vehicle:GetRPOwner() and LocalPlayer() == vehicle:GetRPOwner()) then
		local _buttonRemoveOwner = createVGUI("YButton", yrp_vehicle.window, 530, 50, 545, 170)
		_buttonRemoveOwner:SetText("")
		function _buttonRemoveOwner:DoClick()
			net.Start("nws_yrp_removeVehicleOwner")
			net.WriteString(vehicleTab[1].uniqueID)
			net.SendToServer()
			if YRPPanelAlive(yrp_vehicle.window) then
				yrp_vehicle.window:Close()
			end
		end

		_buttonRemoveOwner.tab = {
			["text"] = YRP:trans("LID_removeowner")
		}

		function _buttonRemoveOwner:Paint(pw, ph)
			hook.Run("YButtonPaint", self, pw, ph, self.tab)
		end

		yrp_vehicle.window:SetSize(YRP:ctr(1090), YRP:ctr(230))
		yrp_vehicle.window:Center()
	end

	yrp_vehicle.window:MakePopup()
end

function openVehicleOptions(vehicle, vehicleID)
	if IsNotNilAndNotFalse(vehicle) and IsNotNilAndNotFalse(vehicleID) then
		net.Start("nws_yrp_getVehicleInfo")
		net.WriteEntity(vehicle)
		net.WriteString(vehicleID)
		net.SendToServer()
	end
end
