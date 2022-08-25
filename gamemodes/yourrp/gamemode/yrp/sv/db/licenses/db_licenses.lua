--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_licenses"

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "name", "TEXT DEFAULT 'UNNAMED'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "description", "TEXT DEFAULT '-'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "price", "TEXT DEFAULT '100'" )

function send_licenses( ply )
	local _all = YRP_SQL_SELECT( DATABASE_NAME, "*", nil )
	local _nm = _all
	if _nm == nil or _nm == false then
		_nm = {}
	end

	net.Start( "get_licenses" )
		net.WriteTable( _nm )
	net.Send( ply )
end

util.AddNetworkString( "get_all_licenses" )
net.Receive( "get_all_licenses", function(len, ply)
	local _all = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
	local _nm = _all
	if _nm == nil or _nm == false then
		_nm = {}
	end
	net.Start( "get_all_licenses" )
		net.WriteTable(_nm)
	net.Send(ply)
end)

util.AddNetworkString( "get_licenses" )
net.Receive( "get_licenses", function(len, ply)
	if ply:CanAccess( "bool_licenses" ) then
		send_licenses(ply)
	end
end)

function sendlicenses(ply)
	local _all = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
	local _nm = _all
	if _nm == nil or _nm == false then
		_nm = {}
	end
	net.Start( "getlicenses" )
		net.WriteTable(_nm)
	net.Send(ply)
end

util.AddNetworkString( "getlicenses" )
net.Receive( "getlicenses", function(len, ply)
	sendlicenses(ply)
end)

util.AddNetworkString( "license_add" )
net.Receive( "license_add", function(len, ply)
	local _new = YRP_SQL_INSERT_INTO(DATABASE_NAME, "name", "'new license'" )
	YRP.msg( "db", "Add new license: " .. tostring(_new) )

	send_licenses(ply)
end)

util.AddNetworkString( "license_rem" )
net.Receive( "license_rem", function(len, ply)
	local _uid = net.ReadString()
	local _new = YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = " .. _uid)
	YRP.msg( "db", "Removed license: " .. tostring(_uid) )

	send_licenses(ply)
end)

util.AddNetworkString( "edit_license_name" )
net.Receive( "edit_license_name", function(len, ply)
	local _uid = net.ReadString()
	local _new_name = net.ReadString()
	local _edit = YRP_SQL_UPDATE(DATABASE_NAME, {["name"] = _new_name}, "uniqueID = " .. _uid)
	YRP.msg( "db", "edit_license_name: " .. tostring(_new_name) )
end)

util.AddNetworkString( "edit_license_description" )
net.Receive( "edit_license_description", function(len, ply)
	local _uid = net.ReadString()
	local _new_description = net.ReadString()
	local _edit = YRP_SQL_UPDATE(DATABASE_NAME, {["description"] = _new_description}, "uniqueID = " .. _uid)
	YRP.msg( "db", "edit_license_description: " .. tostring(_new_description) )
end)

util.AddNetworkString( "edit_license_price" )
net.Receive( "edit_license_price", function(len, ply)
	local _uid = net.ReadString()
	local _new_price = net.ReadString()
	local _edit = YRP_SQL_UPDATE(DATABASE_NAME, {["price"] = _new_price}, "uniqueID = " .. _uid)
	YRP.msg( "db", "edit_license_price: " .. tostring(_new_price) )
end)

util.AddNetworkString( "get_all_licenses_simple" )
net.Receive( "get_all_licenses_simple", function(len, ply)
	local _all = YRP_SQL_SELECT(DATABASE_NAME, "name, uniqueID", nil)
	if _all == false or _all == nil then
		_all = {}
	end
	net.Start( "get_all_licenses_simple" )
		net.WriteTable(_all)
	net.Send(ply)
end)

util.AddNetworkString( "role_add_license" )
net.Receive( "role_add_license", function(len, ply)
	local _role_uid = net.ReadString()
	local _license_uid = net.ReadString()

	local _role = YRP_SQL_SELECT( "yrp_ply_roles", "licenseIDs", "uniqueID = " .. _role_uid)
	if _role != nil then
		_role = _role[1]
		local LIDs = {}
		if _role.licenseIDs != "" then
			LIDs = string.Explode( ",", _role.licenseIDs)
		end
		if !table.HasValue(LIDs, _license_uid) then
			table.insert(LIDs, _license_uid)
			LIDs = string.Implode( ",", LIDs)

			YRP_SQL_UPDATE( "yrp_ply_roles", {["licenseIDs"] = LIDs}, "uniqueID = " .. _role_uid)
		end
	end
end)

util.AddNetworkString( "role_rem_license" )
net.Receive( "role_rem_license", function(len, ply)
	local _role_uid = net.ReadString()
	local _license_uid = net.ReadString()

	local _role = YRP_SQL_SELECT( "yrp_ply_roles", "licenseIDs", "uniqueID = " .. _role_uid)
	if _role != nil then
		_role = _role[1]
		local LIDs = {}
		if _role.licenseIDs != "" then
			LIDs = string.Explode( ",", _role.licenseIDs)
		end

		if table.HasValue(LIDs, _license_uid) then
			table.RemoveByValue(LIDs, _license_uid)

			LIDs = string.Implode( ",", LIDs)

			YRP_SQL_UPDATE( "yrp_ply_roles", {["licenseIDs"] = LIDs}, "uniqueID = " .. _role_uid)
		end
	end
end)

local Player = FindMetaTable( "Player" )
function Player:AddLicense(license)
	license = tostring(license)
	if tonumber(license) != nil then
		local LIDs1 = self:GetYRPString( "licenseIDs1", "" )
		local LIDs2 = self:GetYRPString( "licenseIDs2", "" )
		local LIDs3 = self:GetYRPString( "licenseIDs3", "" )

		local LIDs = {}
		YRPAddToTable( LIDs, string.Explode( ",", LIDs1 ) )
		YRPAddToTable( LIDs, string.Explode( ",", LIDs2 ) )
		YRPAddToTable( LIDs, string.Explode( ",", LIDs3 ) )

		if !table.HasValue(LIDs, license) then
			table.insert(LIDs, license)
		end

		local SLIDs1 = ""
		local SLIDs2 = ""
		local SLIDs3 = ""
		for i, LID in pairs( LIDs ) do
			if string.len( SLIDs1 ) + 1 + string.len( LID ) <= 199 then -- 199 is maximum at string
				if strEmpty( SLIDs1 ) then
					SLIDs1 = SLIDs1 .. LID
				else
					SLIDs1 = SLIDs1 .. "," ..  LID
				end
			elseif string.len( SLIDs2 ) + 1 + string.len( LID ) <= 199 then
				if strEmpty( SLIDs2 ) then
					SLIDs2 = SLIDs2 .. LID
				else
					SLIDs2 = SLIDs2 .. "," ..  LID
				end
			elseif string.len( SLIDs3 ) + 1 + string.len( LID ) <= 199 then
				if strEmpty( SLIDs3 ) then
					SLIDs3 = SLIDs3 .. LID
				else
					SLIDs3 = SLIDs3 .. "," ..  LID
				end
			else
				YRP.msg( "error", "#1 HIT MAXIMUM LICENSE-IDS: " .. LID )
			end
		end

		self:SetYRPString( "licenseIDs1", tostring(SLIDs1) )
		self:SetYRPString( "licenseIDs2", tostring(SLIDs2) )
		self:SetYRPString( "licenseIDs3", tostring(SLIDs3) )
	end
end


function Player:RemoveLicense(license)
	license = tostring(license)
	if tonumber(license) != nil then
		local LIDs1 = self:GetYRPString( "licenseIDs1", "" )
		local LIDs2 = self:GetYRPString( "licenseIDs2", "" )
		local LIDs3 = self:GetYRPString( "licenseIDs3", "" )

		local LIDs = {}
		YRPAddToTable( LIDs, string.Explode( ",", LIDs1 ) )
		YRPAddToTable( LIDs, string.Explode( ",", LIDs2 ) )
		YRPAddToTable( LIDs, string.Explode( ",", LIDs3 ) )

		if !table.HasValue(LIDs, license) then
			table.RemoveByValue(LIDs, license)
		end

		local SLIDs1 = ""
		local SLIDs2 = ""
		local SLIDs3 = ""
		for i, LID in pairs( LIDs ) do
			if string.len( SLIDs1 ) + 1 + string.len( LID ) <= 199 then -- 199 is maximum at string
				if strEmpty( SLIDs1 ) then
					SLIDs1 = SLIDs1 .. LID
				else
					SLIDs1 = SLIDs1 .. "," ..  LID
				end
			elseif string.len( SLIDs2 ) + 1 + string.len( LID ) <= 199 then
				if strEmpty( SLIDs2 ) then
					SLIDs2 = SLIDs2 .. LID
				else
					SLIDs2 = SLIDs2 .. "," ..  LID
				end
			elseif string.len( SLIDs3 ) + 1 + string.len( LID ) <= 199 then
				if strEmpty( SLIDs3 ) then
					SLIDs3 = SLIDs3 .. LID
				else
					SLIDs3 = SLIDs3 .. "," ..  LID
				end
			else
				YRP.msg( "error", "#2 HIT MAXIMUM LICENSE-IDS: " .. LID )
			end
		end

		self:SetYRPString( "licenseIDs1", tostring(SLIDs1) )
		self:SetYRPString( "licenseIDs2", tostring(SLIDs2) )
		self:SetYRPString( "licenseIDs3", tostring(SLIDs3) )
	end
end

util.AddNetworkString( "GetLicenseName" )
net.Receive( "GetLicenseName", function(len, ply)
	local id = net.ReadInt(32)
	local lic = YRP_SQL_SELECT(DATABASE_NAME, "name", "uniqueID = '" .. id .. "'" )
	if wk(lic) then
		lic = lic[1]
		net.Start( "GetLicenseName" )
			net.WriteString(id)
			net.WriteString(lic.name)
		net.Send(ply)
	end
end)

function GetLicenseIDByName(lname)
	if lname == nil then
		YRP.msg( "note", "GetLicenseIDByName: " .. "NAME == " .. tostring(lname) )
		return nil
	end

	lname = lname
	lname = string.lower(lname)

	local tab = YRP_SQL_SELECT(DATABASE_NAME, "*" )
	local lid = nil

	if !wk(tab) then return nil end

	for i, lic in pairs(tab) do
		lic.name = lic.name
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

	YRP.msg( "gm", "Give " .. ply:RPName() .. " LicenseID " .. lid)

	ply:AddLicense(lid)

	ply:SetYRPInt( "licenseIDsVersion", ply:GetYRPInt( "licenseIDsVersion", 0 ) + 1 )
end

function RemoveLicense(ply, lid)
	if !IsValid(ply) then return end
	if !wk(lid) then return end

	YRP.msg( "gm", "Removed from " .. ply:RPName() .. " LicenseID " .. lid)

	ply:RemoveLicense(lid)
	ply:SetYRPInt( "licenseIDsVersion", ply:GetYRPInt( "licenseIDsVersion", 0 ) + 1 )
end
