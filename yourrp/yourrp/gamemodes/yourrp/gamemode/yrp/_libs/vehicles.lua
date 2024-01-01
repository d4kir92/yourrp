--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
function get_vehicles_custom(s_list, s_custom)
	local _custom_list = list.Get(s_list)
	for k, v in pairs(_custom_list) do
		v.Custom = s_custom
		v.WorldModel = v.WorldModel or v.Model or ""
		if s_list == "simfphys_vehicles" then
			v.ClassName = k or ""
		else
			v.ClassName = v.ClassName or v.Class or ""
		end

		v.PrintName = v.PrintName or v.Name or ""
		v.Skin = v.Skin or "-1"
	end

	return _custom_list
end

function get_all_vehicles()
	local _getVehicles = list.Get("Vehicles")
	local _simfphys = get_vehicles_custom("simfphys_vehicles", "simfphys")
	for k, v in pairs(_simfphys) do
		table.insert(_getVehicles, v)
	end

	local _scars = get_vehicles_custom("SCarVehicles", "scars")
	for k, v in pairs(_scars) do
		table.insert(_getVehicles, v)
	end

	local _swvehicles = get_vehicles_custom("SWVehicles", "swvehicles")
	for k, v in pairs(_swvehicles) do
		table.insert(_getVehicles, v)
	end

	local _halovehicles = get_vehicles_custom("HaloVehicles", "halo")
	for k, v in pairs(_halovehicles) do
		table.insert(_getVehicles, v)
	end

	local vehicles = {}
	local count = 0
	for k, v in pairs(_getVehicles) do
		count = count + 1
		vehicles[count] = {}
		vehicles[count].WorldModel = v.WorldModel or v.Model or v.EntModel or ""
		vehicles[count].ClassName = v.ClassName or v.Class or ""
		vehicles[count].PrintName = v.PrintName or v.Name or ""
		if v.EMV ~= nil then
			vehicles[count].Skin = v.Skin or v.EMV.Skin or "-1"
		else
			vehicles[count].Skin = v.Skin or "-1"
		end

		vehicles[count].Custom = v.Custom or ""
		vehicles[count].KeyValues = v.KeyValues or {}
	end

	return vehicles
end