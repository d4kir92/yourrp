-- Networking
local ENTITY = FindMetaTable("Entity")

ENTS = ENTS or {}

local ENTDELAY = 0.05

-- STRING
if SERVER then
	util.AddNetworkString("SetDString")
	function SendDString(entindex, key, value, ply)
		net.Start("SetDString")
			net.WriteUInt(entindex, 16)
			net.WriteString(key)
			net.WriteString(value)
		if IsValid(ply) then
			net.Send(ply)
		else
			net.Broadcast()
		end
	end
end
function SetDString(entindex, key, value)
	value = tostring(value)
	if isstring(key) and value != "nil" then
		ENTS[entindex] = ENTS[entindex] or {}
		ENTS[entindex]["STRING"] = ENTS[entindex]["STRING"] or {}
		ENTS[entindex]["STRING"][key] = value
		if SERVER then
			SendDString(entindex, key, value)
		end
	end
end
function ENTITY:SetDString(key, value)
	local entindex = self:EntIndex()
	SetDString(entindex, key, value)
end
if CLIENT then
	net.Receive("SetDString", function(len)
		local entindex = net.ReadUInt(16)
		local key = net.ReadString()
		local value = net.ReadString()
		SetDString(entindex, key, value)
	end)
end
function GetDString(entindex, key, value)
	ENTS[entindex] = ENTS[entindex] or {}
	ENTS[entindex]["STRING"] = ENTS[entindex]["STRING"] or {}
	local result = ENTS[entindex]["STRING"][key] or value
	return tostring(result)
end
function ENTITY:GetDString(key, value)
	local entindex = self:EntIndex()
	return GetDString(entindex, key, value)
end

-- BOOL
if SERVER then
	util.AddNetworkString("SetDBool")
	function SendDBool(entindex, key, value, ply)
		net.Start("SetDBool")
			net.WriteUInt(entindex, 16)
			net.WriteString(key)
			net.WriteBool(value)
		if IsValid(ply) then
			net.Send(ply)
		else
			net.Broadcast()
		end
	end
end
function SetDBool(entindex, key, value)
	if isstring(key) and isbool(value) then
		ENTS[entindex] = ENTS[entindex] or {}
		ENTS[entindex]["BOOL"] = ENTS[entindex]["BOOL"] or {}
		ENTS[entindex]["BOOL"][key] = value
		if SERVER then
			SendDBool(entindex, key, value)
		end
	end
end
function ENTITY:SetDBool(key, value)
	local entindex = self:EntIndex()
	SetDBool(entindex, key, value)
end
if CLIENT then
	net.Receive("SetDBool", function(len)
		local entindex = net.ReadUInt(16)
		local key = net.ReadString()
		local value = net.ReadBool()
		SetDBool(entindex, key, value)
	end)
end
function GetDBool(entindex, key, value)
	ENTS[entindex] = ENTS[entindex] or {}
	ENTS[entindex]["BOOL"] = ENTS[entindex]["BOOL"] or {}
	local result = ENTS[entindex]["BOOL"][key] or value
	return tobool(result)
end
function ENTITY:GetDBool(key, value)
	local entindex = self:EntIndex()
	local result = GetDBool(entindex, key, value)
	if isbool(result) then
		return result
	else
		return value
	end
end

-- INT
if SERVER then
	util.AddNetworkString("SetDInt")
	function SendDInt(entindex, key, value, ply)
		net.Start("SetDInt")
			net.WriteUInt(entindex, 16)
			net.WriteString(key)
			net.WriteInt(value, 32)
		if IsValid(ply) then
			net.Send(ply)
		else
			net.Broadcast()
		end
	end
end
function SetDInt(entindex, key, value)
	if isstring(key) and isnumber(tonumber(value)) then
		ENTS[entindex] = ENTS[entindex] or {}
		ENTS[entindex]["INT"] = ENTS[entindex]["INT"] or {}
		ENTS[entindex]["INT"][key] = tonumber(value)
		if SERVER then
			SendDInt(entindex, key, tonumber(value))
		end
	else
		YRP.msg("note", "[SetDInt] " .. tostring(key) .. tostring(value))
	end
end
function ENTITY:SetDInt(key, value)
	local entindex = self:EntIndex()
	SetDInt(entindex, key, value)
end
if CLIENT then
	net.Receive("SetDInt", function(len)
		local entindex = net.ReadUInt(16)
		local key = net.ReadString()
		local value = net.ReadInt(32)
		SetDInt(entindex, key, value)
	end)
end
function GetDInt(entindex, key, value)
	ENTS[entindex] = ENTS[entindex] or {}
	ENTS[entindex]["INT"] = ENTS[entindex]["INT"] or {}
	local result = ENTS[entindex]["INT"][key] or value
	return tonumber(result)
end
function ENTITY:GetDInt(key, value)
	local entindex = self:EntIndex()
	if self:IsValid() then
		return GetDInt(entindex, key, value)
	else
		YRP.msg("note", "[GetDInt] ELSE")
		return value
	end
end

-- FLOAT
if SERVER then
	util.AddNetworkString("SetDFloat")
	function SendDFloat(entindex, key, value, ply)
		net.Start("SetDFloat")
			net.WriteUInt(entindex, 16)
			net.WriteString(key)
			net.WriteFloat(value)
		if IsValid(ply) then
			net.Send(ply)
		else
			net.Broadcast()
		end
	end
end
function SetDFloat(entindex, key, value)
	if isstring(key) and isnumber(tonumber(value)) then
		ENTS[entindex] = ENTS[entindex] or {}
		ENTS[entindex]["FLOAT"] = ENTS[entindex]["FLOAT"] or {}
		ENTS[entindex]["FLOAT"][key] = value
		if SERVER then
			SendDFloat(entindex, key, value)
		end
	else
		YRP.msg("note", "[SetDFloat] " .. tostring(key) .. tostring(value))
	end
end
function ENTITY:SetDFloat(key, value)
	local entindex = self:EntIndex()
	SetDFloat(entindex, key, value)
end
if CLIENT then
	net.Receive("SetDFloat", function(len)
		local entindex = net.ReadUInt(16)
		local key = net.ReadString()
		local value = net.ReadFloat()
		SetDFloat(entindex, key, value)
	end)
end
function GetDFloat(entindex, key, value, d)
	ENTS[entindex] = ENTS[entindex] or {}
	ENTS[entindex]["FLOAT"] = ENTS[entindex]["FLOAT"] or {}
	local result = ENTS[entindex]["FLOAT"][key] or value
	if d != nil then
		result = math.Round(tonumber(result), d)
	end
	return tonumber(result)
end
function ENTITY:GetDFloat(key, value, d)
	local entindex = self:EntIndex()
	if self:IsValid() then
		return GetDFloat(entindex, key, value, d)
	else
		return -1.0
	end
end

-- ENTITY
if SERVER then
	util.AddNetworkString("SetDEntity")
	function SendDEntity(entindex, key, value, ply)
		net.Start("SetDEntity")
			net.WriteUInt(entindex, 16)
			net.WriteString(key)
			net.WriteEntity(value)
		if IsValid(ply) then
			net.Send(ply)
		else
			net.Broadcast()
		end
	end
end
function SetDEntity(entindex, key, value)
	if isstring(key) and isentity(value) then
		ENTS[entindex] = ENTS[entindex] or {}
		ENTS[entindex]["ENTITY"] = ENTS[entindex]["ENTITY"] or {}
		ENTS[entindex]["ENTITY"][key] = value
		if SERVER then
			SendDEntity(entindex, key, value)
		end
	else
		YRP.msg("note", "[SetDEntity] " .. tostring(key) .. tostring(value))
	end
end
function ENTITY:SetDEntity(key, value)
	local entindex = self:EntIndex()
	SetDEntity(entindex, key, value)
end
if CLIENT then
	net.Receive("SetDEntity", function(len)
		local entindex = net.ReadUInt(16)
		local key = net.ReadString()
		local value = net.ReadEntity()
		SetDEntity(entindex, key, value)
	end)
end
function GetDEntity(entindex, key, value)
	ENTS[entindex] = ENTS[entindex] or {}
	ENTS[entindex]["ENTITY"] = ENTS[entindex]["ENTITY"] or {}
	local result = ENTS[entindex]["ENTITY"][key] or value
	return result
end
function ENTITY:GetDEntity(key, value)
	local entindex = self:EntIndex()
	if self:IsValid() then
		return GetDEntity(entindex, key, value)
	else
		return value
	end
end

-- TABLE
if SERVER then
	util.AddNetworkString("SetDTable")
	function SendDTable(entindex, key, value, ply)
		net.Start("SetDTable")
			net.WriteUInt(entindex, 16)
			net.WriteString(key)
			net.WriteTable(value)
		if IsValid(ply) then
			net.Send(ply)
		else
			net.Broadcast()
		end
	end
end
function SetDTable(entindex, key, value)
	if isstring(key) and istable(value) then
		ENTS[entindex] = ENTS[entindex] or {}
		ENTS[entindex]["TABLE"] = ENTS[entindex]["TABLE"] or {}
		ENTS[entindex]["TABLE"][key] = value
		if SERVER then
			SendDTable(entindex, key, value)
		end
	else
		YRP.msg("note", "[SetDTable] " .. tostring(key) .. tostring(value))
	end
end
function ENTITY:SetDTable(key, value)
	local entindex = self:EntIndex()
	SetDTable(entindex, key, value)
end
if CLIENT then
	net.Receive("SetDTable", function(len)
		local entindex = net.ReadUInt(16)
		local key = net.ReadString()
		local value = net.ReadTable()
		SetDTable(entindex, key, value)
	end)
end
function GetDTable(entindex, key, value)
	ENTS[entindex] = ENTS[entindex] or {}
	ENTS[entindex]["TABLE"] = ENTS[entindex]["TABLE"] or {}
	local result = ENTS[entindex]["TABLE"][key] or value
	return result
end
function ENTITY:GetDTable(key, value)
	local entindex = self:EntIndex()
	if self:IsValid() then
		return GetDTable(entindex, key, value)
	else
		return value
	end
end

-- INIT
function SetDInit(entindex)
	ENTS[entindex] = ENTS[entindex] or {}
	ENTS[entindex]["INIT"] = true
end
function ENTITY:SetDInit(key, value)
	local entindex = self:EntIndex()
	SetDInit(entindex, key, value)
end
if SERVER then
	util.AddNetworkString("SetDInit")
	function SendDInit(entindex, ply)
		net.Start("SetDInit")
			net.WriteUInt(entindex, 16)
		if IsValid(ply) then
			net.Send(ply)
		else
			net.Broadcast()
		end
	end
end
if CLIENT then
	net.Receive("SetDInit", function(len)
		local entindex = net.ReadUInt(16)
		SetDInit(entindex)
	end)
end

local sending = false
if SERVER then
	util.AddNetworkString("request_dentites")

	function SendDEntities(ply, funcname)
		sending = true
		for j, ent in pairs(ents.GetAll()) do
			if ent.EntIndex != nil then
				local entindex = ent:EntIndex()
				ENTS[entindex] = ENTS[entindex] or {}
				ENTS[entindex]["BOOL"] = ENTS[entindex]["BOOL"] or {}
				ENTS[entindex]["STRING"] = ENTS[entindex]["STRING"] or {}
				ENTS[entindex]["INT"] = ENTS[entindex]["INT"] or {}
				ENTS[entindex]["FLOAT"] = ENTS[entindex]["FLOAT"] or {}
				ENTS[entindex]["TABLE"] = ENTS[entindex]["TABLE"] or {}

				ply:SetDInt("yrp_load_ent", 0)

				timer.Simple(1, function()
					--print(ply, ENTS, entindex)
					ply:SetDInt("yrp_load_ent", 10)
					for i, v in pairs(ENTS[entindex]["BOOL"]) do
						SendDBool(entindex, i, v, ply)
					end
				end)

				timer.Simple(2, function()
					ply:SetDInt("yrp_load_ent", 30)
					for i, v in pairs(ENTS[entindex]["STRING"]) do
						SendDString(entindex, i, v, ply)
					end
				end)

				timer.Simple(3, function()
					ply:SetDInt("yrp_load_ent", 50)
					for i, v in pairs(ENTS[entindex]["INT"]) do
						SendDInt(entindex, i, v, ply)
					end
				end)

				timer.Simple(4, function()
					ply:SetDInt("yrp_load_ent", 70)
					for i, v in pairs(ENTS[entindex]["FLOAT"]) do
						SendDFloat(entindex, i, v, ply)
					end
				end)

				timer.Simple(5, function()
					ply:SetDInt("yrp_load_ent", 90)
					for i, v in pairs(ENTS[entindex]["TABLE"]) do
						SendDTable(entindex, i, v, ply)
					end
				end)

				timer.Simple(6, function()
					SendDInit(entindex, ply)
					ply:SetDInt("yrp_load_ent", 100)
					
					sending = false
				end)
			end
		end
	end
	net.Receive("request_dentites", function(len, ply)
		SendDEntities(ply, "request_dentites")
	end)
end

function RemoveFromEntTable( ent )
	if !sending then
		local entindex = ent:EntIndex()
		ENTS[entindex] = nil
	else
		timer.Simple(1, function()
			RemoveFromEntTable( ent )
		end)
	end
end

function GM:EntityRemoved( ent )
	RemoveFromEntTable( ent )
end