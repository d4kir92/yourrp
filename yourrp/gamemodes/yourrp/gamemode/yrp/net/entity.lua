-- Networking
local ENTITY = FindMetaTable("Entity")

-- CUSTOM
YRP_NW_Ents = YRP_NW_Ents or {}
--YRP_NW_EntsIDs = YRP_NW_EntsIDs or {}

YRP_QUEUE_Ents = YRP_QUEUE_Ents or {}

-- Delay when traffic
local NETDELAY = 0.005

-- Delay when no traffic but wrong entry
local RETDELAY = 0.003

-- STRING
if SERVER then
	YRP_QUEUE_Ents["STRING"] = YRP_QUEUE_Ents["STRING"] or {}
	util.AddNetworkString("SetDString")

	function YRPSendDString(entindex, key, value, ply)
		if table.HasValue(YRP_QUEUE_Ents["STRING"], key) then
			table.RemoveByValue(YRP_QUEUE_Ents["STRING"], key)
			table.insert(YRP_QUEUE_Ents["STRING"], 1, key)
		else
			table.insert(YRP_QUEUE_Ents["STRING"], key)
		end

		if entindex == nil then
			table.RemoveByValue(YRP_QUEUE_Ents["STRING"], key)
			return
		end

		if net.BytesLeft() == nil and net.BytesWritten() == nil then
			-- If no traffic
			if key == YRP_QUEUE_Ents["STRING"][1] then
				net.Start("SetDString")
					net.WriteUInt(entindex, 16)
					net.WriteString(key)
					net.WriteString(value)
				if IsValid(ply) then
					net.Send(ply)
				else
					net.Broadcast()
				end
				table.RemoveByValue(YRP_QUEUE_Ents["STRING"], key)
			else
				-- RETRY if not first entry
				timer.Simple(RETDELAY, function()
					YRPSendDString(entindex, key, value, ply)
				end)
			end
		else
			-- RETRY later when no traffic
			timer.Simple(NETDELAY, function()
				YRPSendDString(entindex, key, value, ply)
			end)
		end
	end
end
function SetDString(entindex, key, value)
	value = tostring(value)
	if isnumber(entindex) and isstring(key) and value != "nil" then
		YRP_NW_Ents = YRP_NW_Ents or {}
		YRP_NW_Ents[entindex] = YRP_NW_Ents[entindex] or {}
		--YRP_NW_EntsIDs[entindex] = YRP_NW_Ents[entindex]
		YRP_NW_Ents[entindex]["STRING"] = YRP_NW_Ents[entindex]["STRING"] or {}
		if YRP_NW_Ents[entindex]["STRING"][key] != value or YRP_NW_Ents[entindex]["STRING"][key] == nil then
			YRP_NW_Ents[entindex]["STRING"][key] = value
			if SERVER then
				YRPSendDString(entindex, key, value)
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
	--YRP_NW_EntsIDs[entindex] = YRP_NW_Ents[entindex]
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
	YRP_QUEUE_Ents["BOOL"] = YRP_QUEUE_Ents["BOOL"] or {}
	util.AddNetworkString("SetDBool")

	function YRPSendDBool(entindex, key, value, ply)
		if table.HasValue(YRP_QUEUE_Ents["BOOL"], key) then
			table.RemoveByValue(YRP_QUEUE_Ents["BOOL"], key)
			table.insert(YRP_QUEUE_Ents["BOOL"], 1, key)
		else
			table.insert(YRP_QUEUE_Ents["BOOL"], key)
		end

		if entindex == nil then
			table.RemoveByValue(YRP_QUEUE_Ents["BOOL"], key)
			return
		end

		if net.BytesLeft() == nil and net.BytesWritten() == nil then
			-- If no traffic
			if key == YRP_QUEUE_Ents["BOOL"][1] then
				net.Start("SetDBool")
					net.WriteUInt(entindex, 16)
					net.WriteString(key)
					net.WriteBool(value)
				if IsValid(ply) then
					net.Send(ply)
				else
					net.Broadcast()
				end
				table.RemoveByValue(YRP_QUEUE_Ents["BOOL"], key)
			else
				-- RETRY if not first entry
				timer.Simple(RETDELAY, function()
					YRPSendDBool(entindex, key, value, ply)
				end)
			end
		else
			-- RETRY later when no traffic
			timer.Simple(NETDELAY, function()
				YRPSendDBool(entindex, key, value, ply)
			end)
		end
	end
end
function SetDBool(entindex, key, value)
	if isnumber(entindex) and isstring(key) and isbool(value) then
		YRP_NW_Ents = YRP_NW_Ents or {}
		YRP_NW_Ents[entindex] = YRP_NW_Ents[entindex] or {}
		--YRP_NW_EntsIDs[entindex] = YRP_NW_Ents[entindex]
		YRP_NW_Ents[entindex]["BOOL"] = YRP_NW_Ents[entindex]["BOOL"] or {}
		if YRP_NW_Ents[entindex]["BOOL"][key] != value or YRP_NW_Ents[entindex]["BOOL"][key] == nil then
			YRP_NW_Ents[entindex]["BOOL"][key] = value
			if SERVER then
				YRPSendDBool(entindex, key, value)
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
	--YRP_NW_EntsIDs[entindex] = YRP_NW_Ents[entindex]
	YRP_NW_Ents[entindex]["BOOL"] = YRP_NW_Ents[entindex]["BOOL"] or {}
	local result = YRP_NW_Ents[entindex]["BOOL"][key]
	if isbool(result) then
		return result
	elseif isbool(value) then
		return value
	else
		return false
	end
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
	YRP_QUEUE_Ents["INT"] = YRP_QUEUE_Ents["INT"] or {}
	util.AddNetworkString("SetDInt")

	function YRPSendDInt(entindex, key, value, ply)
		if table.HasValue(YRP_QUEUE_Ents["INT"], key) then
			table.RemoveByValue(YRP_QUEUE_Ents["INT"], key)
			table.insert(YRP_QUEUE_Ents["INT"], 1, key)
		else
			table.insert(YRP_QUEUE_Ents["INT"], key)
		end

		if entindex == nil then
			table.RemoveByValue(YRP_QUEUE_Ents["INT"], key)
			return
		end

		if net.BytesLeft() == nil and net.BytesWritten() == nil then
			-- If no traffic
			if key == YRP_QUEUE_Ents["INT"][1] then
				net.Start("SetDInt")
					net.WriteUInt(entindex, 16)
					net.WriteString(key)
					net.WriteInt(value, 32)
				if IsValid(ply) then
					net.Send(ply)
				else
					net.Broadcast()
				end
				table.RemoveByValue(YRP_QUEUE_Ents["INT"], key)
			else
				-- RETRY if not first entry
				timer.Simple(RETDELAY, function()
					YRPSendDInt(entindex, key, value, ply)
				end)
			end
		else
			-- RETRY later when no traffic
			timer.Simple(NETDELAY, function()
				YRPSendDInt(entindex, key, value, ply)
			end)
		end
	end
end
function SetDInt(entindex, key, value)
	if isnumber(entindex) and isstring(key) and isnumber(tonumber(value)) then
		YRP_NW_Ents = YRP_NW_Ents or {}
		YRP_NW_Ents[entindex] = YRP_NW_Ents[entindex] or {}
		--YRP_NW_EntsIDs[entindex] = YRP_NW_Ents[entindex]
		YRP_NW_Ents[entindex]["INT"] = YRP_NW_Ents[entindex]["INT"] or {}
		if YRP_NW_Ents[entindex]["INT"][key] != value or YRP_NW_Ents[entindex]["INT"][key] == nil then
			YRP_NW_Ents[entindex]["INT"][key] = tonumber(value)
			if SERVER then
				YRPSendDInt(entindex, key, tonumber(value))
			end
		end
	else
		YRP.msg("note", "[SetDInt] FAILED " .. tostring(key) .. " " .. tostring(value))
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
	--YRP_NW_EntsIDs[entindex] = YRP_NW_Ents[entindex]
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
	YRP_QUEUE_Ents["FLOAT"] = YRP_QUEUE_Ents["FLOAT"] or {}
	util.AddNetworkString("SetDFloat")

	function YRPSendDFloat(entindex, key, value, ply)
		if table.HasValue(YRP_QUEUE_Ents["FLOAT"], key) then
			table.RemoveByValue(YRP_QUEUE_Ents["FLOAT"], key)
			table.insert(YRP_QUEUE_Ents["FLOAT"], 1, key)
		else
			table.insert(YRP_QUEUE_Ents["FLOAT"], key)
		end

		if entindex == nil then
			table.RemoveByValue(YRP_QUEUE_Ents["FLOAT"], key)
			return
		end

		if net.BytesLeft() == nil and net.BytesWritten() == nil then
			-- If no traffic
			if key == YRP_QUEUE_Ents["FLOAT"][1] then
				net.Start("SetDFloat")
					net.WriteUInt(entindex, 16)
					net.WriteString(key)
					net.WriteFloat(value)
				if IsValid(ply) then
					net.Send(ply)
				else
					net.Broadcast()
				end
				table.RemoveByValue(YRP_QUEUE_Ents["FLOAT"], key)
			else
				-- RETRY if not first entry
				timer.Simple(RETDELAY, function()
					YRPSendDFloat(entindex, key, value, ply)
				end)
			end
		else
			-- RETRY later when no traffic
			timer.Simple(NETDELAY, function()
				YRPSendDFloat(entindex, key, value, ply)
			end)
		end
	end
end
function SetDFloat(entindex, key, value, range)
	if isnumber(entindex) and isstring(key) and wk(value) and isnumber(tonumber(value)) then
		value = tonumber(value)

		YRP_NW_Ents = YRP_NW_Ents or {}
		YRP_NW_Ents[entindex] = YRP_NW_Ents[entindex] or {}
		--YRP_NW_EntsIDs[entindex] = YRP_NW_Ents[entindex]
		YRP_NW_Ents[entindex]["FLOAT"] = YRP_NW_Ents[entindex]["FLOAT"] or {}
		if YRP_NW_Ents[entindex]["FLOAT"][key] == nil or YRP_NW_Ents[entindex]["FLOAT"][key] != value then
			YRP_NW_Ents[entindex]["FLOAT"][key] = value
			if SERVER then
				if range then
					for i, p in pairs(player.GetAll()) do
						if ents.GetByIndex( entindex ) then
							local ent = ents.GetByIndex( entindex )
							local dist = p:GetPos():Distance(ent:GetPos())
							if dist <= range then
								YRPSendDFloat(entindex, key, value, p)
							end
						end
					end
				else
					YRPSendDFloat(entindex, key, value)
				end
			end
		end
	else
		YRP.msg("note", "[SetDFloat] FAILED " .. tostring(key) .. tostring(value))
	end
end
function ENTITY:SetDFloat(key, value, range)
	local entindex = self:EntIndex()
	SetDFloat(entindex, key, value, range)
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
	--YRP_NW_EntsIDs[entindex] = YRP_NW_Ents[entindex]
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
	YRP_QUEUE_Ents["ENTITY"] = YRP_QUEUE_Ents["ENTITY"] or {}
	util.AddNetworkString("SetDEntity")

	function YRPSendDEntity(entindex, key, value, ply)
		if table.HasValue(YRP_QUEUE_Ents["ENTITY"], key) then
			table.RemoveByValue(YRP_QUEUE_Ents["ENTITY"], key)
			table.insert(YRP_QUEUE_Ents["ENTITY"], 1, key)
		else
			table.insert(YRP_QUEUE_Ents["ENTITY"], key)
		end

		if entindex == nil then
			table.RemoveByValue(YRP_QUEUE_Ents["ENTITY"], key)
			return
		end

		if net.BytesLeft() == nil and net.BytesWritten() == nil then
			-- If no traffic
			if key == YRP_QUEUE_Ents["ENTITY"][1] then
				net.Start("SetDEntity")
					net.WriteUInt(entindex, 16)
					net.WriteString(key)
					net.WriteEntity(value)
				if IsValid(ply) then
					net.Send(ply)
				else
					net.Broadcast()
				end
				table.RemoveByValue(YRP_QUEUE_Ents["ENTITY"], key)
			else
				-- RETRY if not first entry
				timer.Simple(RETDELAY, function()
					YRPSendDEntity(entindex, key, value, ply)
				end)
			end
		else
			-- RETRY later when no traffic
			timer.Simple(NETDELAY, function()
				YRPSendDEntity(entindex, key, value, ply)
			end)
		end
	end
end
function SetDEntity(entindex, key, value)
	if isnumber(entindex) and isstring(key) and isentity(value) then
		YRP_NW_Ents = YRP_NW_Ents or {}
		YRP_NW_Ents[entindex] = YRP_NW_Ents[entindex] or {}
		--YRP_NW_EntsIDs[entindex] = YRP_NW_Ents[entindex]
		YRP_NW_Ents[entindex]["ENTITY"] = YRP_NW_Ents[entindex]["ENTITY"] or {}
		if YRP_NW_Ents[entindex]["ENTITY"][key] != value or YRP_NW_Ents[entindex]["ENTITY"][key] == nil then
			YRP_NW_Ents[entindex]["ENTITY"][key] = value
			if SERVER then
				YRPSendDEntity(entindex, key, value)
			end
		end
	else
		YRP.msg("note", "[SetDEntity] FAILED " .. tostring(key) .. tostring(value))
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
	--YRP_NW_EntsIDs[entindex] = YRP_NW_Ents[entindex]
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
	YRP_QUEUE_Ents["TABLE"] = YRP_QUEUE_Ents["TABLE"] or {}
	util.AddNetworkString("SetDTable")

	function YRPSendDTable(entindex, key, value, ply)
		if table.HasValue(YRP_QUEUE_Ents["TABLE"], key) then
			table.RemoveByValue(YRP_QUEUE_Ents["TABLE"], key)
			table.insert(YRP_QUEUE_Ents["TABLE"], 1, key)
		else
			table.insert(YRP_QUEUE_Ents["TABLE"], key)
		end

		if entindex == nil then
			table.RemoveByValue(YRP_QUEUE_Ents["TABLE"], key)
			return
		end

		if net.BytesLeft() == nil and net.BytesWritten() == nil then
			-- If no traffic
			if key == YRP_QUEUE_Ents["TABLE"][1] then
				net.Start("SetDTable")
					net.WriteUInt(entindex, 16)
					net.WriteString(key)
					net.WriteTable(value)
				if IsValid(ply) then
					net.Send(ply)
				else
					net.Broadcast()
				end
				table.RemoveByValue(YRP_QUEUE_Ents["TABLE"], key)
			else
				-- RETRY if not first entry
				timer.Simple(RETDELAY, function()
					YRPSendDTable(entindex, key, value, ply)
				end)
			end
		else
			-- RETRY later when no traffic
			timer.Simple(NETDELAY, function()
				YRPSendDTable(entindex, key, value, ply)
			end)
		end
	end
end
function SetDTable(entindex, key, value)
	if isnumber(entindex) and isstring(key) and istable(value) then
		YRP_NW_Ents = YRP_NW_Ents or {}
		YRP_NW_Ents[entindex] = YRP_NW_Ents[entindex] or {}
		--YRP_NW_EntsIDs[entindex] = YRP_NW_Ents[entindex]
		YRP_NW_Ents[entindex]["TABLE"] = YRP_NW_Ents[entindex]["TABLE"] or {}
		if YRP_NW_Ents[entindex]["TABLE"][key] != value or YRP_NW_Ents[entindex]["TABLE"][key] == nil then
			YRP_NW_Ents[entindex]["TABLE"][key] = value
			if SERVER then
				YRPSendDTable(entindex, key, value)
			end
		end
	else
		YRP.msg("note", "[SetDTable] FAILED " .. tostring(key) .. tostring(value))
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
	--YRP_NW_EntsIDs[entindex] = YRP_NW_Ents[entindex]
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
	--YRP_NW_EntsIDs[entindex] = YRP_NW_Ents[entindex]
	YRP_NW_Ents[entindex]["INIT"] = true
end
function ENTITY:SetDInit(key, value)
	local entindex = self:EntIndex()
	SetDInit(entindex, key, value)
end
if SERVER then
	util.AddNetworkString("SetDInit")
	function YRPSendDInit(entindex, ply)
		if entindex != nil then
			net.Start("SetDInit")
				net.WriteUInt(entindex, 16)
			if IsValid(ply) then
				net.Send(ply)
			else
				net.Broadcast()
			end
		end
	end
end
if CLIENT then
	net.Receive("SetDInit", function(len)
		local entindex = net.ReadUInt(16)
		SetDInit(entindex)
	end)
end

if SERVER then
	local c = 0

	function SendDEntities(ply, funcname)
		local interval = 2
		local ti = 1

		YRP_NW_Ents = YRP_NW_Ents or {}

		for j, ent in pairs(ents.GetAll()) do
			if ent.EntIndex != nil then
				local entindex = ent:EntIndex()
				if YRP_NW_Ents[entindex] then
					YRP_NW_Ents[entindex] = YRP_NW_Ents[entindex] or {}
					--YRP_NW_EntsIDs[entindex] = YRP_NW_Ents[entindex]
					YRP_NW_Ents[entindex]["BOOL"] = YRP_NW_Ents[entindex]["BOOL"] or {}
					YRP_NW_Ents[entindex]["STRING"] = YRP_NW_Ents[entindex]["STRING"] or {}
					YRP_NW_Ents[entindex]["INT"] = YRP_NW_Ents[entindex]["INT"] or {}
					YRP_NW_Ents[entindex]["FLOAT"] = YRP_NW_Ents[entindex]["FLOAT"] or {}
					YRP_NW_Ents[entindex]["TABLE"] = YRP_NW_Ents[entindex]["TABLE"] or {}
				end
			end
		end

		ply:SetDInt("yrp_load_ent", 0)

		timer.Simple(ti, function()
			for j, ent in pairs(ents.GetAll()) do
				if ent.EntIndex != nil then
					local entindex = ent:EntIndex()
					if YRP_NW_Ents[entindex] then
						YRP_NW_Ents[entindex] = YRP_NW_Ents[entindex] or {}
						--YRP_NW_EntsIDs[entindex] = YRP_NW_Ents[entindex]
						YRP_NW_Ents[entindex]["BOOL"] = YRP_NW_Ents[entindex]["BOOL"] or {}
						if table.Count(YRP_NW_Ents[entindex]["BOOL"]) > 0 then
							for i, v in pairs(YRP_NW_Ents[entindex]["BOOL"]) do
								YRPSendDBool(entindex, i, v, ply)
							end
						end
					end
				end
			end
			ply:SetDInt("yrp_load_ent", 10)
		end)
		ti = ti + interval
		timer.Simple(ti, function()
			for j, ent in pairs(ents.GetAll()) do
				if ent.EntIndex != nil then
					local entindex = ent:EntIndex()
					if YRP_NW_Ents[entindex] then
						YRP_NW_Ents[entindex] = YRP_NW_Ents[entindex] or {}
						--YRP_NW_EntsIDs[entindex] = YRP_NW_Ents[entindex]
						YRP_NW_Ents[entindex]["STRING"] = YRP_NW_Ents[entindex]["STRING"] or {}
						if table.Count(YRP_NW_Ents[entindex]["STRING"]) > 0 then
							for i, v in pairs(YRP_NW_Ents[entindex]["STRING"]) do
								YRPSendDString(entindex, i, v, ply)
							end
						end
					end
				end
			end
			ply:SetDInt("yrp_load_ent", 30)
		end)
		ti = ti + interval
		timer.Simple(ti, function()
			for j, ent in pairs(ents.GetAll()) do
				if ent.EntIndex != nil then
					local entindex = ent:EntIndex()
					if YRP_NW_Ents[entindex] then
						YRP_NW_Ents[entindex] = YRP_NW_Ents[entindex] or {}
						--YRP_NW_EntsIDs[entindex] = YRP_NW_Ents[entindex]
						YRP_NW_Ents[entindex]["INT"] = YRP_NW_Ents[entindex]["INT"] or {}
						if table.Count(YRP_NW_Ents[entindex]["INT"]) > 0 then
							for i, v in pairs(YRP_NW_Ents[entindex]["INT"]) do
								if i != "yrp_load_glo" and i != "yrp_load_ent" then
									YRPSendDInt(entindex, i, v, ply)
								end
							end
						end
					end
				end
			end
			ply:SetDInt("yrp_load_ent", 50)
		end)
		ti = ti + interval
		timer.Simple(ti, function()
			for j, ent in pairs(ents.GetAll()) do
				if ent.EntIndex != nil then
					local entindex = ent:EntIndex()
					if YRP_NW_Ents[entindex] then
						YRP_NW_Ents[entindex] = YRP_NW_Ents[entindex] or {}
						--YRP_NW_EntsIDs[entindex] = YRP_NW_Ents[entindex]
						YRP_NW_Ents[entindex]["FLOAT"] = YRP_NW_Ents[entindex]["FLOAT"] or {}
						if table.Count(YRP_NW_Ents[entindex]["FLOAT"]) > 0 then
							for i, v in pairs(YRP_NW_Ents[entindex]["FLOAT"]) do
								YRPSendDFloat(entindex, i, v, ply)
							end
						end
					end
				end
			end
			ply:SetDInt("yrp_load_ent", 70)
		end)
		ti = ti + interval
		timer.Simple(ti, function()
			for j, ent in pairs(ents.GetAll()) do
				if ent.EntIndex != nil then
					local entindex = ent:EntIndex()
					if YRP_NW_Ents[entindex] then
						YRP_NW_Ents[entindex] = YRP_NW_Ents[entindex] or {}
						--YRP_NW_EntsIDs[entindex] = YRP_NW_Ents[entindex]
						YRP_NW_Ents[entindex]["TABLE"] = YRP_NW_Ents[entindex]["TABLE"] or {}
						if table.Count(YRP_NW_Ents[entindex]["TABLE"]) > 0 then
							for i, v in pairs(YRP_NW_Ents[entindex]["TABLE"]) do
								YRPSendDTable(entindex, i, v, ply)
							end
						end
					end
				end
			end
			ply:SetDInt("yrp_load_ent", 90)
		end)

		timer.Simple(ti, function()
			YRPSendDInit(entindex, ply)
			ply:SetDInt("yrp_load_ent", 100)
		end)
	end
end

function YRPRemoveFromEntTable( entindex )
	if entindex == nil then
		YRP.msg("error", "[YRPRemoveFromEntTable] ERROR! entindex == nil!")
		return
	end
	if istable(YRP_NW_Ents[entindex]) then
		timer.Simple(1, function()
			if !ea(Entity(entindex)) then
				YRP_NW_Ents[entindex] = nil
			end
		end)
	end
end

hook.Add("EntityRemoved", "YRP_EntityRemoved", function( ent )
	local entindex = ent:EntIndex()
	YRPRemoveFromEntTable( entindex )
end)
