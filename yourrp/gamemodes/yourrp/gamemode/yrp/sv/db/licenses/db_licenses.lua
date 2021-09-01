--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_licenses"

SQL_ADD_COLUMN(DATABASE_NAME, "name", "TEXT DEFAULT 'UNNAMED'")
SQL_ADD_COLUMN(DATABASE_NAME, "description", "TEXT DEFAULT '-'")
SQL_ADD_COLUMN(DATABASE_NAME, "price", "TEXT DEFAULT '100'")

--db_drop_table(DATABASE_NAME)
--db_is_empty(DATABASE_NAME)

function send_licenses(ply)
	local _all = SQL_SELECT(DATABASE_NAME, "*", nil)
	local _nm = _all
	if _nm == nil or _nm == false then
		_nm = {}
	end
	net.Start("get_licenses")
		net.WriteTable(_nm)
	net.Send(ply)
end

util.AddNetworkString("get_all_licenses")
net.Receive("get_all_licenses", function(len, ply)
	local _all = SQL_SELECT(DATABASE_NAME, "*", nil)
	local _nm = _all
	if _nm == nil or _nm == false then
		_nm = {}
	end
	net.Start("get_all_licenses")
		net.WriteTable(_nm)
	net.Send(ply)
end)

util.AddNetworkString("get_licenses")
net.Receive("get_licenses", function(len, ply)
	if ply:CanAccess("bool_licenses") then
		send_licenses(ply)
	end
end)

function sendlicenses(ply)
	local _all = SQL_SELECT(DATABASE_NAME, "*", nil)
	local _nm = _all
	if _nm == nil or _nm == false then
		_nm = {}
	end
	net.Start("getlicenses")
		net.WriteTable(_nm)
	net.Send(ply)
end

util.AddNetworkString("getlicenses")
net.Receive("getlicenses", function(len, ply)
	sendlicenses(ply)
end)

util.AddNetworkString("license_add")
net.Receive("license_add", function(len, ply)
	local _new = SQL_INSERT_INTO(DATABASE_NAME, "name", "'new license'")
	YRP.msg("db", "Add new license: " .. tostring(_new))

	send_licenses(ply)
end)

util.AddNetworkString("license_rem")
net.Receive("license_rem", function(len, ply)
	local _uid = net.ReadString()
	local _new = SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = " .. _uid)
	YRP.msg("db", "Removed license: " .. tostring(_uid))

	send_licenses(ply)
end)

util.AddNetworkString("edit_license_name")
net.Receive("edit_license_name", function(len, ply)
	local _uid = net.ReadString()
	local _new_name = SQL_STR_IN(net.ReadString())
	local _edit = SQL_UPDATE(DATABASE_NAME, "name = '" .. _new_name .. "'", "uniqueID = " .. _uid)
	YRP.msg("db", "edit_license_name: " .. tostring(SQL_STR_OUT(_new_name)))
end)

util.AddNetworkString("edit_license_description")
net.Receive("edit_license_description", function(len, ply)
	local _uid = net.ReadString()
	local _new_description = SQL_STR_IN(net.ReadString())
	local _edit = SQL_UPDATE(DATABASE_NAME, "description = '" .. _new_description .. "'", "uniqueID = " .. _uid)
	YRP.msg("db", "edit_license_description: " .. tostring(SQL_STR_OUT(_new_description)))
end)

util.AddNetworkString("edit_license_price")
net.Receive("edit_license_price", function(len, ply)
	local _uid = net.ReadString()
	local _new_price = SQL_STR_IN(net.ReadString())
	local _edit = SQL_UPDATE(DATABASE_NAME, "price = " .. _new_price, "uniqueID = " .. _uid)
	YRP.msg("db", "edit_license_price: " .. tostring(SQL_STR_OUT(_new_price)))
end)

util.AddNetworkString("get_all_licenses_simple")
net.Receive("get_all_licenses_simple", function(len, ply)
	local _all = SQL_SELECT(DATABASE_NAME, "name, uniqueID", nil)
	if _all == false or _all == nil then
		_all = {}
	end
	net.Start("get_all_licenses_simple")
		net.WriteTable(_all)
	net.Send(ply)
end)

util.AddNetworkString("role_add_license")
net.Receive("role_add_license", function(len, ply)
	local _role_uid = net.ReadString()
	local _license_uid = net.ReadString()

	local _role = SQL_SELECT("yrp_ply_roles", "licenseIDs", "uniqueID = " .. _role_uid)
	if _role != nil then
		_role = _role[1]
		local _licenseIDs = {}
		if _role.licenseIDs != "" then
			_licenseIDs = string.Explode(",", _role.licenseIDs)
		end
		if !table.HasValue(_licenseIDs, _license_uid) then
			table.insert(_licenseIDs, _license_uid)
			_licenseIDs = string.Implode(",", _licenseIDs)

			SQL_UPDATE("yrp_ply_roles", "licenseIDs = '" .. _licenseIDs .. "'" ,"uniqueID = " .. _role_uid)
		end
	end
end)

util.AddNetworkString("role_rem_license")
net.Receive("role_rem_license", function(len, ply)
	local _role_uid = net.ReadString()
	local _license_uid = net.ReadString()

	local _role = SQL_SELECT("yrp_ply_roles", "licenseIDs", "uniqueID = " .. _role_uid)
	if _role != nil then
		_role = _role[1]
		local _licenseIDs = {}
		if _role.licenseIDs != "" then
			_licenseIDs = string.Explode(",", _role.licenseIDs)
		end

		if table.HasValue(_licenseIDs, _license_uid) then
			table.RemoveByValue(_licenseIDs, _license_uid)

			_licenseIDs = string.Implode(",", _licenseIDs)

			SQL_UPDATE("yrp_ply_roles", "licenseIDs = '" .. _licenseIDs .. "'" ,"uniqueID = " .. _role_uid)
		end
	end
end)

local Player = FindMetaTable("Player")
function Player:AddLicense(license)
	license = tostring(license)
	if tonumber(license) != nil then
		local _licenseIDs = self:GetNW2String("licenseIDs", "")

		_licenseIDs = string.Explode(",", _licenseIDs)
		if !table.HasValue(_licenseIDs, license) then
			table.insert(_licenseIDs, license)
		end
		if table.HasValue(_licenseIDs, "") then
			table.RemoveByValue(_licenseIDs, "")
		end
		_licenseIDs = string.Implode(",", _licenseIDs)

		self:SetNW2String("licenseIDs", tostring(_licenseIDs))

		local ids = string.Explode(",", _licenseIDs)
		local lnames = {}
		for i, id in pairs(ids) do
			local lic = SQL_SELECT(DATABASE_NAME, "name", "uniqueID = '" .. id .. "'")
			if wk(lic) then
				lic = lic[1]
				table.insert(lnames, lic.name)
			end
		end
		lnames = table.concat(lnames, ", ")
		self:SetNW2String("licenseNames", lnames)
	end
end

function Player:RemoveLicense(license)
	license = tostring(license)
	if tonumber(license) != nil then
		local _licenseIDs = self:GetNW2String("licenseIDs", "")

		_licenseIDs = string.Explode(",", _licenseIDs)
		if table.HasValue(_licenseIDs, license) then
			table.RemoveByValue(_licenseIDs, license)
		end
		if table.HasValue(_licenseIDs, "") then
			table.RemoveByValue(_licenseIDs, "")
		end
		_licenseIDs = string.Implode(",", _licenseIDs)
		
		self:SetNW2String("licenseIDs", tostring(_licenseIDs))

		local ids = string.Explode(",", _licenseIDs)
		local lnames = {}
		for i, id in pairs(ids) do
			local lic = SQL_SELECT(DATABASE_NAME, "name", "uniqueID = '" .. id .. "'")
			if wk(lic) then
				lic = lic[1]
				table.insert(lnames, lic.name)
			end
		end
		lnames = table.concat(lnames, ", ")
		self:SetNW2String("licenseNames", lnames)
	end
end

util.AddNetworkString("GetLicenseName")
net.Receive("GetLicenseName", function(len, ply)
	local id = net.ReadInt(32)
	local lic = SQL_SELECT(DATABASE_NAME, "name", "uniqueID = '" .. id .. "'")
	if wk(lic) then
		lic = lic[1]
		net.Start("GetLicenseName")
			net.WriteString(id)
			net.WriteString(lic.name)
		net.Send(ply)
	end
end)

function GetLicenseIDByName(lname)
	if lname == nil then
		YRP.msg("note", "GetLicenseIDByName: " .. "NAME == " .. tostring(lname))
		return nil
	end

	lname = SQL_STR_IN(lname)
	lname = string.lower(lname)

	local tab = SQL_SELECT(DATABASE_NAME, "*")
	local lid = nil

	if !wk(tab) then return nil end

	for i, lic in pairs(tab) do
		lic.name = SQL_STR_OUT(lic.name)
		lic.name = string.lower(lic.name)

		if lname and lic.name and string.find(lic.name, lname) then
			lid = lic.uniqueID
		end
	end

	if lid == nil then
		return "FAIL!"
	end
	return tonumber(lid)
end

function GiveLicense(ply, lid)
	if !IsValid(ply) then return end
	if !wk(lid) then return end

	YRP.msg("gm", "Give " .. ply:RPName() .. " LicenseID " .. lid)

	ply:AddLicense(lid)
end

function RemoveLicense(ply, lid)
	if !IsValid(ply) then return end
	if !wk(lid) then return end

	YRP.msg("gm", "Removed from " .. ply:RPName() .. " LicenseID " .. lid)

	ply:RemoveLicense(lid)
end