-- Networking
local ENTITY = FindMetaTable("Entity")

-- CUSTOM
YRP_NW_Ents = YRP_NW_Ents or {}

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
	if isnumber(entindex) and isstring(key) and value != "nil" then
		YRP_NW_Ents = YRP_NW_Ents or {}
		YRP_NW_Ents[entindex] = YRP_NW_Ents[entindex] or {}
		YRP_NW_Ents[entindex]["STRING"] = YRP_NW_Ents[entindex]["STRING"] or {}
		if YRP_NW_Ents[entindex]["STRING"][key] != value or YRP_NW_Ents[entindex]["STRING"][key] == nil then
			YRP_NW_Ents[entindex]["STRING"][key] = value
			if SERVER then
				SendDString(entindex, key, value)
			end
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
	YRP_NW_Ents = YRP_NW_Ents or {}
	YRP_NW_Ents[entindex] = YRP_NW_Ents[entindex] or {}
	YRP_NW_Ents[entindex]["STRING"] = YRP_NW_Ents[entindex]["STRING"] or {}
	local result = YRP_NW_Ents[entindex]["STRING"][key] or value
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
	if isnumber(entindex) and isstring(key) and isbool(value) then
		YRP_NW_Ents = YRP_NW_Ents or {}
		YRP_NW_Ents[entindex] = YRP_NW_Ents[entindex] or {}
		YRP_NW_Ents[entindex]["BOOL"] = YRP_NW_Ents[entindex]["BOOL"] or {}
		if YRP_NW_Ents[entindex]["BOOL"][key] != value or YRP_NW_Ents[entindex]["BOOL"][key] == nil then
			YRP_NW_Ents[entindex]["BOOL"][key] = value
			if SERVER then
				SendDBool(entindex, key, value)
			end
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
	YRP_NW_Ents = YRP_NW_Ents or {}
	YRP_NW_Ents[entindex] = YRP_NW_Ents[entindex] or {}
	YRP_NW_Ents[entindex]["BOOL"] = YRP_NW_Ents[entindex]["BOOL"] or {}
	local result = YRP_NW_Ents[entindex]["BOOL"][key] or value
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
	if isnumber(entindex) and isstring(key) and isnumber(tonumber(value)) then
		YRP_NW_Ents = YRP_NW_Ents or {}
		YRP_NW_Ents[entindex] = YRP_NW_Ents[entindex] or {}
		YRP_NW_Ents[entindex]["INT"] = YRP_NW_Ents[entindex]["INT"] or {}
		if YRP_NW_Ents[entindex]["INT"][key] != value or YRP_NW_Ents[entindex]["INT"][key] == nil then
			YRP_NW_Ents[entindex]["INT"][key] = tonumber(value)
			if SERVER then
				SendDInt(entindex, key, tonumber(value))
			end
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
	YRP_NW_Ents = YRP_NW_Ents or {}
	YRP_NW_Ents[entindex] = YRP_NW_Ents[entindex] or {}
	YRP_NW_Ents[entindex]["INT"] = YRP_NW_Ents[entindex]["INT"] or {}
	local result = YRP_NW_Ents[entindex]["INT"][key] or value
	return tonumber(result)
end
function ENTITY:GetDInt(key, value)
	local entindex = self:EntIndex()
	if self:IsValid() then
		return GetDInt(entindex, key, value)
	else
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
	if isnumber(entindex) and isstring(key) and isnumber(tonumber(value)) then
		YRP_NW_Ents = YRP_NW_Ents or {}
		YRP_NW_Ents[entindex] = YRP_NW_Ents[entindex] or {}
		YRP_NW_Ents[entindex]["FLOAT"] = YRP_NW_Ents[entindex]["FLOAT"] or {}
		if YRP_NW_Ents[entindex]["FLOAT"][key] != value or YRP_NW_Ents[entindex]["FLOAT"][key] == nil then
			YRP_NW_Ents[entindex]["FLOAT"][key] = value
			if SERVER then
				SendDFloat(entindex, key, value)
			end
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
	YRP_NW_Ents = YRP_NW_Ents or {}
	YRP_NW_Ents[entindex] = YRP_NW_Ents[entindex] or {}
	YRP_NW_Ents[entindex]["FLOAT"] = YRP_NW_Ents[entindex]["FLOAT"] or {}
	local result = YRP_NW_Ents[entindex]["FLOAT"][key] or value
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
	if isnumber(entindex) and isstring(key) and isentity(value) then
		YRP_NW_Ents = YRP_NW_Ents or {}
		YRP_NW_Ents[entindex] = YRP_NW_Ents[entindex] or {}
		YRP_NW_Ents[entindex]["ENTITY"] = YRP_NW_Ents[entindex]["ENTITY"] or {}
		if YRP_NW_Ents[entindex]["ENTITY"][key] != value or YRP_NW_Ents[entindex]["ENTITY"][key] == nil then
			YRP_NW_Ents[entindex]["ENTITY"][key] = value
			if SERVER then
				SendDEntity(entindex, key, value)
			end
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
	YRP_NW_Ents = YRP_NW_Ents or {}
	YRP_NW_Ents[entindex] = YRP_NW_Ents[entindex] or {}
	YRP_NW_Ents[entindex]["ENTITY"] = YRP_NW_Ents[entindex]["ENTITY"] or {}
	local result = YRP_NW_Ents[entindex]["ENTITY"][key] or value
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
	if isnumber(entindex) and isstring(key) and istable(value) then
		YRP_NW_Ents = YRP_NW_Ents or {}
		YRP_NW_Ents[entindex] = YRP_NW_Ents[entindex] or {}
		YRP_NW_Ents[entindex]["TABLE"] = YRP_NW_Ents[entindex]["TABLE"] or {}
		if YRP_NW_Ents[entindex]["TABLE"][key] != value or YRP_NW_Ents[entindex]["TABLE"][key] == nil then
			YRP_NW_Ents[entindex]["TABLE"][key] = value
			if SERVER then
				SendDTable(entindex, key, value)
			end
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
	YRP_NW_Ents = YRP_NW_Ents or {}
	YRP_NW_Ents[entindex] = YRP_NW_Ents[entindex] or {}
	YRP_NW_Ents[entindex]["TABLE"] = YRP_NW_Ents[entindex]["TABLE"] or {}
	local result = YRP_NW_Ents[entindex]["TABLE"][key] or value
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
	YRP_NW_Ents = YRP_NW_Ents or {}
	YRP_NW_Ents[entindex] = YRP_NW_Ents[entindex] or {}
	YRP_NW_Ents[entindex]["INIT"] = true
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
		---if !sending then
			--sending = true
			for j, ent in pairs(ents.GetAll()) do
				if ent.EntIndex != nil then
					local entindex = ent:EntIndex()
					YRP_NW_Ents = YRP_NW_Ents or {}
					YRP_NW_Ents[entindex] = YRP_NW_Ents[entindex] or {}
					YRP_NW_Ents[entindex]["BOOL"] = YRP_NW_Ents[entindex]["BOOL"] or {}
					YRP_NW_Ents[entindex]["STRING"] = YRP_NW_Ents[entindex]["STRING"] or {}
					YRP_NW_Ents[entindex]["INT"] = YRP_NW_Ents[entindex]["INT"] or {}
					YRP_NW_Ents[entindex]["FLOAT"] = YRP_NW_Ents[entindex]["FLOAT"] or {}
					YRP_NW_Ents[entindex]["TABLE"] = YRP_NW_Ents[entindex]["TABLE"] or {}

					ply:SetDInt("yrp_load_ent", 0)

					timer.Simple(1, function()
						ply:SetDInt("yrp_load_ent", 10)
						for i, v in pairs(YRP_NW_Ents[entindex]["BOOL"]) do
							SendDBool(entindex, i, v, ply)
						end
					end)

					timer.Simple(2, function()
						ply:SetDInt("yrp_load_ent", 30)
						for i, v in pairs(YRP_NW_Ents[entindex]["STRING"]) do
							SendDString(entindex, i, v, ply)
						end
					end)

					timer.Simple(3, function()
						ply:SetDInt("yrp_load_ent", 50)
						for i, v in pairs(YRP_NW_Ents[entindex]["INT"]) do
							SendDInt(entindex, i, v, ply)
						end
					end)

					timer.Simple(4, function()
						ply:SetDInt("yrp_load_ent", 70)
						for i, v in pairs(YRP_NW_Ents[entindex]["FLOAT"]) do
							SendDFloat(entindex, i, v, ply)
						end
					end)

					timer.Simple(5, function()
						ply:SetDInt("yrp_load_ent", 90)
						for i, v in pairs(YRP_NW_Ents[entindex]["TABLE"]) do
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
		--else
			-- IF SENDING ALREADY => Wait for finish*
			--timer.Simple(0.9, function()
				--SendDEntities(ply, funcname)
			--end)
		--end
	end

	net.Receive("request_dentites", function(len, ply)
		SendDEntities(ply, "request_dentites")
	end)
end

function RemoveFromEntTable( entindex )
	if !sending then
		if istable(YRP_NW_Ents[entindex]) then
			table.RemoveByValue(YRP_NW_Ents, entindex)
		end
	else
		timer.Simple(1, function()
			RemoveFromEntTable( entindex )
		end)
	end
end

function GM:EntityRemoved( ent )
	local entindex = ent:EntIndex()
	RemoveFromEntTable( entindex )
end