--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/specializations/gpl.txt)
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
local DATABASE_NAME = "yrp_specializations"
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "name", "TEXT DEFAULT 'UNNAMED'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "sweps", "TEXT DEFAULT ''")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "pms", "TEXT DEFAULT ''")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "prefix", "TEXT DEFAULT ''")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "suffix", "TEXT DEFAULT ''")
-- PMs
function YRPSendSpecPMs(uid, ply)
	local tab = YRP_SQL_SELECT(DATABASE_NAME, "pms", "uniqueID = '" .. uid .. "'")
	if IsNotNilAndNotFalse(tab) then
		tab = string.Explode(",", tab[1].pms)
	else
		tab = {}
	end

	local newtab = {}
	for i, v in pairs(tab) do
		if not table.HasValue(newtab, v) and not strEmpty(v) then
			table.insert(newtab, v)
		end
	end

	net.Start("nws_yrp_get_specialization_pms")
	net.WriteTable(newtab)
	net.Send(ply)
end

YRP:AddNetworkString("nws_yrp_get_specialization_pms")
net.Receive(
	"nws_yrp_get_specialization_pms",
	function(len, ply)
		local uid = net.ReadInt(32)
		YRPSendSpecPMs(uid, ply)
	end
)

YRP:AddNetworkString("nws_yrp_spec_add_pm")
net.Receive(
	"nws_yrp_spec_add_pm",
	function(len, ply)
		local uid = net.ReadInt(32)
		local pms = net.ReadTable()
		for i, pm in pairs(pms) do
			local tab = YRP_SQL_SELECT(DATABASE_NAME, "uniqueID, pms", "uniqueID = '" .. uid .. "'")
			if IsNotNilAndNotFalse(tab) then
				tab = tab[1]
			else
				tab = {}
			end

			local newtab = {}
			for id, v in pairs(string.Explode(",", tab.pms)) do
				if not table.HasValue(newtab, v) and not strEmpty(v) then
					table.insert(newtab, v)
				end
			end

			if not table.HasValue(newtab, pm) then
				table.insert(newtab, pm)
			end

			local newpms = table.concat(newtab, ",")
			YRP_SQL_UPDATE(
				DATABASE_NAME,
				{
					["pms"] = newpms
				}, "uniqueID = '" .. uid .. "'"
			)

			YRPSendSpecPMs(uid, ply)
		end
	end
)

YRP:AddNetworkString("nws_yrp_spec_rem_pm")
net.Receive(
	"nws_yrp_spec_rem_pm",
	function(len, ply)
		local uid = net.ReadInt(32)
		local pm = net.ReadString()
		local tab = YRP_SQL_SELECT(DATABASE_NAME, "uniqueID, pms", "uniqueID = '" .. uid .. "'")
		if IsNotNilAndNotFalse(tab) then
			tab = tab[1]
		else
			tab = {}
		end

		local newtab = {}
		for i, v in pairs(string.Explode(",", tab.pms)) do
			if not table.HasValue(newtab, v) and not strEmpty(v) then
				table.insert(newtab, v)
			end
		end

		if table.HasValue(newtab, pm) then
			table.RemoveByValue(newtab, pm)
		end

		local newpms = table.concat(newtab, ",")
		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["pms"] = newpms
			}, "uniqueID = '" .. uid .. "'"
		)

		YRPSendSpecPMs(uid, ply)
	end
)

-- SWEPS
function YRPSendSpecSWEPS(uid, ply)
	local tab = YRP_SQL_SELECT(DATABASE_NAME, "sweps", "uniqueID = '" .. uid .. "'")
	if IsNotNilAndNotFalse(tab) then
		tab = string.Explode(",", tab[1].sweps)
	else
		tab = {}
	end

	local newtab = {}
	for i, v in pairs(tab) do
		if not table.HasValue(newtab, v) and not strEmpty(v) then
			table.insert(newtab, v)
		end
	end

	net.Start("nws_yrp_get_specialization_sweps")
	net.WriteTable(newtab)
	net.Send(ply)
end

YRP:AddNetworkString("nws_yrp_get_specialization_sweps")
net.Receive(
	"nws_yrp_get_specialization_sweps",
	function(len, ply)
		local uid = net.ReadInt(32)
		YRPSendSpecSWEPS(uid, ply)
	end
)

YRP:AddNetworkString("nws_yrp_spec_add_swep")
net.Receive(
	"nws_yrp_spec_add_swep",
	function(len, ply)
		local uid = net.ReadInt(32)
		local sweps = net.ReadTable()
		for i, swep in pairs(sweps) do
			local tab = YRP_SQL_SELECT(DATABASE_NAME, "uniqueID, sweps", "uniqueID = '" .. uid .. "'")
			if IsNotNilAndNotFalse(tab) then
				tab = tab[1]
			else
				tab = {}
			end

			if tab.sweps then
				local newtab = {}
				for id, v in pairs(string.Explode(",", tab.sweps)) do
					if not table.HasValue(newtab, v) and not strEmpty(v) then
						table.insert(newtab, v)
					end
				end

				if not table.HasValue(newtab, swep) then
					table.insert(newtab, swep)
				end

				local newsweps = table.concat(newtab, ",")
				YRP_SQL_UPDATE(
					DATABASE_NAME,
					{
						["sweps"] = newsweps
					}, "uniqueID = '" .. uid .. "'"
				)

				YRPSendSpecSWEPS(uid, ply)
			end
		end
	end
)

YRP:AddNetworkString("nws_yrp_spec_rem_swep")
net.Receive(
	"nws_yrp_spec_rem_swep",
	function(len, ply)
		local uid = net.ReadInt(32)
		local swep = net.ReadString()
		local tab = YRP_SQL_SELECT(DATABASE_NAME, "uniqueID, sweps", "uniqueID = '" .. uid .. "'")
		if IsNotNilAndNotFalse(tab) then
			tab = tab[1]
		else
			tab = {}
		end

		local newtab = {}
		for i, v in pairs(string.Explode(",", tab.sweps)) do
			if not table.HasValue(newtab, v) and not strEmpty(v) then
				table.insert(newtab, v)
			end
		end

		if table.HasValue(newtab, swep) then
			table.RemoveByValue(newtab, swep)
		end

		local newsweps = table.concat(newtab, ",")
		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["sweps"] = newsweps
			}, "uniqueID = '" .. uid .. "'"
		)

		YRPSendSpecSWEPS(uid, ply)
	end
)

function send_specializations(ply)
	local _nm = GetAllSpecializations()
	net.Start("nws_yrp_get_specializations")
	net.WriteTable(_nm)
	net.Send(ply)
end

YRP:AddNetworkString("nws_yrp_get_all_specializations")
net.Receive(
	"nws_yrp_get_all_specializations",
	function(len, ply)
		local _all = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
		local _nm = _all
		if _nm == nil or _nm == false then
			_nm = {}
		end

		net.Start("nws_yrp_get_all_specializations")
		net.WriteTable(_nm)
		net.Send(ply)
	end
)

YRP:AddNetworkString("nws_yrp_get_specializations")
net.Receive(
	"nws_yrp_get_specializations",
	function(len, ply)
		if ply:CanAccess("bool_specializations") then
			send_specializations(ply)
		end
	end
)

function sendspecializations(ply)
	local _all = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
	local _nm = _all
	if _nm == nil or _nm == false then
		_nm = {}
	end

	net.Start("nws_yrp_getspecializations")
	net.WriteTable(_nm)
	net.Send(ply)
end

YRP:AddNetworkString("nws_yrp_getspecializations")
net.Receive(
	"nws_yrp_getspecializations",
	function(len, ply)
		sendspecializations(ply)
	end
)

YRP:AddNetworkString("nws_yrp_specialization_add")
net.Receive(
	"nws_yrp_specialization_add",
	function(len, ply)
		local _new = YRP_SQL_INSERT_INTO(DATABASE_NAME, "name", "'new specialization'")
		YRP:msg("db", "Add new specialization: " .. tostring(_new))
		send_specializations(ply)
	end
)

YRP:AddNetworkString("nws_yrp_specialization_rem")
net.Receive(
	"nws_yrp_specialization_rem",
	function(len, ply)
		local _uid = net.ReadString()
		local _new = YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = " .. _uid)
		YRP:msg("db", "Removed specialization: " .. tostring(_uid))
		send_specializations(ply)
	end
)

YRP:AddNetworkString("nws_yrp_edit_specialization_name")
net.Receive(
	"nws_yrp_edit_specialization_name",
	function(len, ply)
		local _uid = net.ReadString()
		local _new_name = net.ReadString()
		local _edit = YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["name"] = _new_name
			}, "uniqueID = " .. _uid
		)

		YRP:msg("db", "edit_specialization_name: " .. tostring(_new_name))
	end
)

YRP:AddNetworkString("nws_yrp_edit_specialization_prefix")
net.Receive(
	"nws_yrp_edit_specialization_prefix",
	function(len, ply)
		local _uid = net.ReadString()
		local _new_prefix = net.ReadString()
		local _edit = YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["prefix"] = _new_prefix
			}, "uniqueID = " .. _uid
		)

		YRP:msg("db", "edit_specialization_prefix: " .. tostring(_new_prefix))
	end
)

YRP:AddNetworkString("nws_yrp_edit_specialization_suffix")
net.Receive(
	"nws_yrp_edit_specialization_suffix",
	function(len, ply)
		local _uid = net.ReadString()
		local _new_suffix = net.ReadString()
		local _edit = YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["suffix"] = _new_suffix
			}, "uniqueID = " .. _uid
		)

		YRP:msg("db", "edit_specialization_suffix: " .. tostring(_new_suffix))
	end
)

YRP:AddNetworkString("nws_yrp_get_all_specializations_simple")
net.Receive(
	"nws_yrp_get_all_specializations_simple",
	function(len, ply)
		local _all = YRP_SQL_SELECT(DATABASE_NAME, "name, uniqueID", nil)
		if _all == false or _all == nil then
			_all = {}
		end

		net.Start("nws_yrp_get_all_specializations_simple")
		net.WriteTable(_all)
		net.Send(ply)
	end
)

YRP:AddNetworkString("nws_yrp_role_add_specialization")
net.Receive(
	"nws_yrp_role_add_specialization",
	function(len, ply)
		local _role_uid = net.ReadString()
		local _specialization_uid = net.ReadString()
		local _role = YRP_SQL_SELECT("yrp_ply_roles", "specializationIDs", "uniqueID = " .. _role_uid)
		if _role ~= nil then
			_role = _role[1]
			local _specializationIDs = {}
			if _role.specializationIDs ~= "" then
				_specializationIDs = string.Explode(",", _role.specializationIDs)
			end

			if not table.HasValue(_specializationIDs, _specialization_uid) then
				table.insert(_specializationIDs, _specialization_uid)
				_specializationIDs = string.Implode(",", _specializationIDs)
				YRP_SQL_UPDATE(
					"yrp_ply_roles",
					{
						["specializationIDs"] = _specializationIDs
					}, "uniqueID = " .. _role_uid
				)
			end
		end
	end
)

YRP:AddNetworkString("nws_yrp_role_rem_specialization")
net.Receive(
	"nws_yrp_role_rem_specialization",
	function(len, ply)
		local _role_uid = net.ReadString()
		local _specialization_uid = net.ReadString()
		local _role = YRP_SQL_SELECT("yrp_ply_roles", "specializationIDs", "uniqueID = " .. _role_uid)
		if _role ~= nil then
			_role = _role[1]
			local _specializationIDs = {}
			if _role.specializationIDs ~= "" then
				_specializationIDs = string.Explode(",", _role.specializationIDs)
			end

			if table.HasValue(_specializationIDs, _specialization_uid) then
				table.RemoveByValue(_specializationIDs, _specialization_uid)
				_specializationIDs = string.Implode(",", _specializationIDs)
				YRP_SQL_UPDATE(
					"yrp_ply_roles",
					{
						["specializationIDs"] = _specializationIDs
					}, "uniqueID = " .. _role_uid
				)
			end
		end
	end
)

local Player = FindMetaTable("Player")
function Player:AddSpecialization(specialization)
	specialization = tostring(specialization)
	if tonumber(specialization) ~= nil then
		local _specializationIDs = self:GetYRPString("specializationIDs", "")
		_specializationIDs = string.Explode(",", _specializationIDs)
		if not table.HasValue(_specializationIDs, specialization) then
			table.insert(_specializationIDs, specialization)
		end

		if table.HasValue(_specializationIDs, "") then
			table.RemoveByValue(_specializationIDs, "")
		end

		_specializationIDs = table.concat(_specializationIDs, ",")
		self:SetYRPString("specializationIDs", tostring(_specializationIDs))
		local ids = string.Explode(",", _specializationIDs)
		local lnames = {}
		for i, id in pairs(ids) do
			local spe = YRP_SQL_SELECT(DATABASE_NAME, "name", "uniqueID = '" .. id .. "'")
			if IsNotNilAndNotFalse(spe) then
				spe = spe[1]
				table.insert(lnames, spe.name)
			end
		end

		lnames = table.concat(lnames, ", ")
		self:SetYRPString("specializationNames", lnames)
	else
		YRP:msg("note", "[AddSpecialization] id is nil")
	end
end

function Player:RemoveSpecialization(specialization)
	specialization = tostring(specialization)
	if tonumber(specialization) ~= nil then
		local _specializationIDs = self:GetYRPString("specializationIDs", "")
		_specializationIDs = string.Explode(",", _specializationIDs)
		if table.HasValue(_specializationIDs, specialization) then
			table.RemoveByValue(_specializationIDs, specialization)
		end

		if table.HasValue(_specializationIDs, "") then
			table.RemoveByValue(_specializationIDs, "")
		end

		_specializationIDs = table.concat(_specializationIDs, ",")
		self:SetYRPString("specializationIDs", tostring(_specializationIDs))
		local ids = string.Explode(",", _specializationIDs)
		local lnames = {}
		for i, id in pairs(ids) do
			local spe = YRP_SQL_SELECT(DATABASE_NAME, "name", "uniqueID = '" .. id .. "'")
			if IsNotNilAndNotFalse(spe) then
				spe = spe[1]
				table.insert(lnames, spe.name)
			end
		end

		lnames = table.concat(lnames, ", ")
		self:SetYRPString("specializationNames", lnames)
	end
end

YRP:AddNetworkString("nws_yrp_getSpecializationName")
net.Receive(
	"nws_yrp_getSpecializationName",
	function(len, ply)
		local id = net.ReadInt(32)
		local spe = YRP_SQL_SELECT(DATABASE_NAME, "name", "uniqueID = '" .. id .. "'")
		if IsNotNilAndNotFalse(spe) then
			spe = spe[1]
			net.Start("nws_yrp_getSpecializationName")
			net.WriteString(id)
			net.WriteString(spe.name)
			net.Send(ply)
		end
	end
)

function GetSpecializationIDByName(lname)
	if lname == nil then
		YRP:msg("note", "GetSpecializationIDByName: " .. "name == " .. tostring(lname))

		return nil
	end

	lname = lname
	lname = string.lower(lname)
	local tab = YRP_SQL_SELECT(DATABASE_NAME, "*")
	local lid = nil
	if not IsNotNilAndNotFalse(tab) then return nil end
	for i, spe in pairs(tab) do
		spe.name = spe.name
		spe.name = string.lower(spe.name)
		if lname and spe.name and string.find(spe.name, lname, 1, true) then
			lid = spe.uniqueID
		end
	end

	if lid == nil then return "FAIL!" end

	return tonumber(lid)
end

function GiveSpecialization(ply, lid)
	if not IsValid(ply) then
		YRP:msg("note", "[GiveSpecialization] ply is invalid")

		return
	end

	if lid == nil then
		YRP:msg("note", "[GiveSpecialization] lid is nil")

		return
	end

	YRP:msg("gm", "Give " .. ply:RPName() .. " SpecializationID " .. lid)
	ply:AddSpecialization(lid)
	YRPGiveSpecs(ply)
end

function RemoveSpecialization(ply, lid)
	if not IsValid(ply) then return end
	if not IsNotNilAndNotFalse(lid) then return end
	YRP:msg("gm", "Removed from " .. ply:RPName() .. " SpecializationID " .. lid)
	ply:RemoveSpecialization(lid)
end

function GetAllSpecializations()
	local _all = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
	local _nm = _all
	if _nm == nil or _nm == false then
		_nm = {}
	end

	return _nm
end
