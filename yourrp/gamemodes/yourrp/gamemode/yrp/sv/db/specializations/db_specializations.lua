--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/specializations/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_specializations"

SQL_ADD_COLUMN(DATABASE_NAME, "name", "TEXT DEFAULT 'UNNAMED'")
SQL_ADD_COLUMN(DATABASE_NAME, "sweps", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "prefix", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "suffix", "TEXT DEFAULT ''")
--db_drop_table(DATABASE_NAME)

function YRPSendSpecSWEPS(uid, ply)
	local tab = SQL_SELECT(DATABASE_NAME, "sweps", "uniqueID = '" .. uid .. "'")
	if wk(tab) then
		tab = string.Explode( ",", tab[1].sweps )
	else
		tab = {}
	end
	local newtab = {}
	for i, v in pairs(tab) do
		if !table.HasValue( newtab, v ) and !strEmpty(v) then
			table.insert( newtab, v )
		end
	end

	net.Start("get_specialization_sweps")
		net.WriteTable(newtab)
	net.Send(ply)
end

util.AddNetworkString("get_specialization_sweps")
net.Receive("get_specialization_sweps", function(len, ply)
	local uid = net.ReadInt(32)
	YRPSendSpecSWEPS(uid, ply)
end)

util.AddNetworkString("spec_add_swep")
net.Receive("spec_add_swep", function(len, ply)
	local uid = net.ReadInt(32)
	local sweps = net.ReadTable()

	for i, swep in pairs( sweps ) do
		local tab = SQL_SELECT(DATABASE_NAME, "uniqueID, sweps", "uniqueID = '" .. uid .. "'")
		if wk(tab) then
			tab = tab[1]
		else
			tab = {}
		end
		local newtab = {}
		for i, v in pairs(string.Explode(",", tab.sweps)) do
			if !table.HasValue( newtab, v ) and !strEmpty(v) then
				table.insert( newtab, v )
			end
		end
		if !table.HasValue( newtab, swep ) then
			table.insert( newtab, swep )
		end

		local newsweps = table.concat( newtab, "," )

		SQL_UPDATE(DATABASE_NAME, {["sweps"] = newsweps}, "uniqueID = '" .. uid .. "'")
		YRPSendSpecSWEPS(uid, ply)
	end
end)

util.AddNetworkString("spec_rem_swep")
net.Receive("spec_rem_swep", function(len, ply)
	local uid = net.ReadInt(32)
	local swep = net.ReadString()

	local tab = SQL_SELECT(DATABASE_NAME, "uniqueID, sweps", "uniqueID = '" .. uid .. "'")
	if wk(tab) then
		tab = tab[1]
	else
		tab = {}
	end
	local newtab = {}
	for i, v in pairs(string.Explode(",", tab.sweps)) do
		if !table.HasValue( newtab, v ) and !strEmpty(v) then
			table.insert( newtab, v )
		end
	end
	if table.HasValue( newtab, swep ) then
		table.RemoveByValue( newtab, swep )
	end

	local newsweps = table.concat( newtab, "," )

	SQL_UPDATE(DATABASE_NAME, {["sweps"] = newsweps}, "uniqueID = '" .. uid .. "'")
	YRPSendSpecSWEPS(uid, ply)
end)

function send_specializations(ply)
	local _all = SQL_SELECT(DATABASE_NAME, "*", nil)
	local _nm = _all
	if _nm == nil or _nm == false then
		_nm = {}
	end
	net.Start("get_specializations")
		net.WriteTable(_nm)
	net.Send(ply)
end

util.AddNetworkString("get_all_specializations")
net.Receive("get_all_specializations", function(len, ply)
	local _all = SQL_SELECT(DATABASE_NAME, "*", nil)
	local _nm = _all
	if _nm == nil or _nm == false then
		_nm = {}
	end
	net.Start("get_all_specializations")
		net.WriteTable(_nm)
	net.Send(ply)
end)

util.AddNetworkString("get_specializations")
net.Receive("get_specializations", function(len, ply)
	if ply:CanAccess("bool_specializations") then
		send_specializations(ply)
	end
end)

function sendspecializations(ply)
	local _all = SQL_SELECT(DATABASE_NAME, "*", nil)
	local _nm = _all
	if _nm == nil or _nm == false then
		_nm = {}
	end
	net.Start("getspecializations")
		net.WriteTable(_nm)
	net.Send(ply)
end

util.AddNetworkString("getspecializations")
net.Receive("getspecializations", function(len, ply)
	sendspecializations(ply)
end)

util.AddNetworkString("specialization_add")
net.Receive("specialization_add", function(len, ply)
	local _new = SQL_INSERT_INTO(DATABASE_NAME, "name", "'new specialization'")
	YRP.msg("db", "Add new specialization: " .. tostring(_new))

	send_specializations(ply)
end)

util.AddNetworkString("specialization_rem")
net.Receive("specialization_rem", function(len, ply)
	local _uid = net.ReadString()
	local _new = SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = " .. _uid)
	YRP.msg("db", "Removed specialization: " .. tostring(_uid))

	send_specializations(ply)
end)

util.AddNetworkString("edit_specialization_name")
net.Receive("edit_specialization_name", function(len, ply)
	local _uid = net.ReadString()
	local _new_name = net.ReadString()
	local _edit = SQL_UPDATE(DATABASE_NAME, {["name"] = _new_name}, "uniqueID = " .. _uid)
	YRP.msg("db", "edit_specialization_name: " .. tostring(_new_name))
end)

util.AddNetworkString("edit_specialization_prefix")
net.Receive("edit_specialization_prefix", function(len, ply)
	local _uid = net.ReadString()
	local _new_prefix = net.ReadString()
	local _edit = SQL_UPDATE(DATABASE_NAME, {["prefix"] = _new_prefix}, "uniqueID = " .. _uid)
	YRP.msg("db", "edit_specialization_prefix: " .. tostring(_new_prefix))
end)

util.AddNetworkString("edit_specialization_suffix")
net.Receive("edit_specialization_suffix", function(len, ply)
	local _uid = net.ReadString()
	local _new_suffix = net.ReadString()
	local _edit = SQL_UPDATE(DATABASE_NAME, {["suffix"] = _new_suffix}, "uniqueID = " .. _uid)
	YRP.msg("db", "edit_specialization_suffix: " .. tostring(_new_suffix))
end)

util.AddNetworkString("get_all_specializations_simple")
net.Receive("get_all_specializations_simple", function(len, ply)
	local _all = SQL_SELECT(DATABASE_NAME, "name, uniqueID", nil)
	if _all == false or _all == nil then
		_all = {}
	end
	net.Start("get_all_specializations_simple")
		net.WriteTable(_all)
	net.Send(ply)
end)

util.AddNetworkString("role_add_specialization")
net.Receive("role_add_specialization", function(len, ply)
	local _role_uid = net.ReadString()
	local _specialization_uid = net.ReadString()

	local _role = SQL_SELECT("yrp_ply_roles", "specializationIDs", "uniqueID = " .. _role_uid)
	if _role != nil then
		_role = _role[1]
		local _specializationIDs = {}
		if _role.specializationIDs != "" then
			_specializationIDs = string.Explode(",", _role.specializationIDs)
		end
		if !table.HasValue(_specializationIDs, _specialization_uid) then
			table.insert(_specializationIDs, _specialization_uid)
			_specializationIDs = string.Implode(",", _specializationIDs)

			SQL_UPDATE("yrp_ply_roles", {["specializationIDs"] = _specializationIDs} ,"uniqueID = " .. _role_uid)
		end
	end
end)

util.AddNetworkString("role_rem_specialization")
net.Receive("role_rem_specialization", function(len, ply)
	local _role_uid = net.ReadString()
	local _specialization_uid = net.ReadString()

	local _role = SQL_SELECT("yrp_ply_roles", "specializationIDs", "uniqueID = " .. _role_uid)
	if _role != nil then
		_role = _role[1]
		local _specializationIDs = {}
		if _role.specializationIDs != "" then
			_specializationIDs = string.Explode(",", _role.specializationIDs)
		end

		if table.HasValue(_specializationIDs, _specialization_uid) then
			table.RemoveByValue(_specializationIDs, _specialization_uid)

			_specializationIDs = string.Implode(",", _specializationIDs)

			SQL_UPDATE("yrp_ply_roles", {["specializationIDs"] = _specializationIDs} ,"uniqueID = " .. _role_uid)
		end
	end
end)

local Player = FindMetaTable("Player")
function Player:AddSpecialization(specialization)
	specialization = tostring(specialization)
	if tonumber(specialization) != nil then
		local _specializationIDs = self:GetNW2String("specializationIDs", "")

		_specializationIDs = string.Explode(",", _specializationIDs)
		if !table.HasValue(_specializationIDs, specialization) then
			table.insert(_specializationIDs, specialization)
		end
		if table.HasValue(_specializationIDs, "") then
			table.RemoveByValue(_specializationIDs, "")
		end
		_specializationIDs = string.Implode(",", _specializationIDs)

		self:SetNW2String("specializationIDs", tostring(_specializationIDs))

		local ids = string.Explode(",", _specializationIDs)
		local lnames = {}
		for i, id in pairs(ids) do
			local spe = SQL_SELECT(DATABASE_NAME, "name", "uniqueID = '" .. id .. "'")
			if wk(spe) then
				spe = spe[1]
				table.insert(lnames, spe.name)
			end
		end
		lnames = table.concat(lnames, ", ")
		self:SetNW2String("specializationNames", lnames)
	end
end

function Player:RemoveSpecialization(specialization)
	specialization = tostring(specialization)
	if tonumber(specialization) != nil then
		local _specializationIDs = self:GetNW2String("specializationIDs", "")

		_specializationIDs = string.Explode(",", _specializationIDs)
		if table.HasValue(_specializationIDs, specialization) then
			table.RemoveByValue(_specializationIDs, specialization)
		end
		if table.HasValue(_specializationIDs, "") then
			table.RemoveByValue(_specializationIDs, "")
		end
		_specializationIDs = string.Implode(",", _specializationIDs)
		
		self:SetNW2String("specializationIDs", tostring(_specializationIDs))

		local ids = string.Explode(",", _specializationIDs)
		local lnames = {}
		for i, id in pairs(ids) do
			local spe = SQL_SELECT(DATABASE_NAME, "name", "uniqueID = '" .. id .. "'")
			if wk(spe) then
				spe = spe[1]
				table.insert(lnames, spe.name)
			end
		end
		lnames = table.concat(lnames, ", ")
		self:SetNW2String("specializationNames", lnames)
	end
end

util.AddNetworkString("GetSpecializationName")
net.Receive("GetSpecializationName", function(len, ply)
	local id = net.ReadInt(32)
	local spe = SQL_SELECT(DATABASE_NAME, "name", "uniqueID = '" .. id .. "'")
	if wk(spe) then
		spe = spe[1]
		net.Start("GetSpecializationName")
			net.WriteString(id)
			net.WriteString(spe.name)
		net.Send(ply)
	end
end)

function GetSpecializationIDByName(lname)
	if lname == nil then
		YRP.msg("note", "GetSpecializationIDByName: " .. "NAME == " .. tostring(lname))
		return nil
	end

	lname = lname
	lname = string.lower(lname)

	local tab = SQL_SELECT(DATABASE_NAME, "*")
	local lid = nil

	if !wk(tab) then return nil end

	for i, spe in pairs(tab) do
		spe.name = spe.name
		spe.name = string.lower(spe.name)

		if lname and spe.name and string.find(spe.name, lname) then
			lid = spe.uniqueID
		end
	end

	if lid == nil then
		return "FAIL!"
	end
	return tonumber(lid)
end

function GiveSpecialization(ply, lid)
	if !IsValid(ply) then return end
	if !wk(lid) then return end

	YRP.msg("gm", "Give " .. ply:RPName() .. " SpecializationID " .. lid)

	ply:AddSpecialization(lid)
end

function RemoveSpecialization(ply, lid)
	if !IsValid(ply) then return end
	if !wk(lid) then return end

	YRP.msg("gm", "Removed from " .. ply:RPName() .. " SpecializationID " .. lid)

	ply:RemoveSpecialization(lid)
end
