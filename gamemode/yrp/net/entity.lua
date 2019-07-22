-- Networking
local ENTITY = FindMetaTable("Entity")

local ENTDELAY = 0.0001

-- STRING
if SERVER then
	util.AddNetworkString("SetDString")
end
function ENTITY:SetDString(key, value)
	value = tostring(value)
	if isstring(key) and value != "nil" then
		self.NWTAB = self.NWTAB or {}
		self.NWTAB["STRING"] = self.NWTAB["STRING"] or {}
		self.NWTAB["STRING"][key] = value
		if SERVER then
			net.Start("SetDString")
				net.WriteUInt(self:EntIndex(), 16)
				net.WriteString(key)
				net.WriteString(value)
			net.Broadcast()
		end
	end
end
if CLIENT then
	net.Receive("SetDString", function(len)
		local ENTINDEX = net.ReadUInt(16)
		local key = net.ReadString()
		local value = net.ReadString()
		local ENT = Entity(ENTINDEX)
		if ENT != NULL then
			ENT:SetDString(key, value)
		else
			timer.Simple(ENTDELAY, function()
				ENT = Entity(ENTINDEX)
				if ENT != NULL then
					ENT:SetDString(key, value)
				end
			end)
		end
	end)
end

function ENTITY:GetDString(key, value)
	self.NWTAB = self.NWTAB or {}
	self.NWTAB["STRING"] = self.NWTAB["STRING"] or {}
	return self.NWTAB["STRING"][key] or value
end

-- BOOL
if SERVER then
	util.AddNetworkString("SetDBool")
end
function ENTITY:SetDBool(key, value)
	if isstring(key) and isbool(value) then
		self.NWTAB = self.NWTAB or {}
		self.NWTAB["BOOL"] = self.NWTAB["BOOL"] or {}
		self.NWTAB["BOOL"][key] = value
		if SERVER then
			net.Start("SetDBool")
				net.WriteUInt(self:EntIndex(), 16)
				net.WriteString(key)
				net.WriteBool(value)
			net.Broadcast()
		end
	end
end
if CLIENT then
	net.Receive("SetDBool", function(len)
		local ENTINDEX = net.ReadUInt(16)
		local key = net.ReadString()
		local value = net.ReadBool()
		local ENT = Entity(ENTINDEX)
		if ENT != NULL then
			ENT:SetDBool(key, value)
		else
			timer.Simple(ENTDELAY, function()
				ENT = Entity(ENTINDEX)
				if ENT != NULL then
					ENT:SetDBool(key, value)
				end
			end)
		end
	end)
end

function ENTITY:GetDBool(key, value)
	self.NWTAB = self.NWTAB or {}
	self.NWTAB["BOOL"] = self.NWTAB["BOOL"] or {}
	return self.NWTAB["BOOL"][key] or value
end

-- INT
if SERVER then
	util.AddNetworkString("SetDInt")
end
function ENTITY:SetDInt(key, value)
	if isstring(key) and isnumber(tonumber(value)) then
		self.NWTAB = self.NWTAB or {}
		self.NWTAB["INT"] = self.NWTAB["INT"] or {}
		self.NWTAB["INT"][key] = value
		if SERVER then
			net.Start("SetDInt")
				net.WriteUInt(self:EntIndex(), 16)
				net.WriteString(key)
				net.WriteInt(value, 32)
			net.Broadcast()
		end
	else
		YRP.msg("note", "[SetDInt] " .. tostring(key) .. tostring(value))
	end
end
if CLIENT then
	net.Receive("SetDInt", function(len)
		local ENTINDEX = net.ReadUInt(16)
		local key = net.ReadString()
		local value = net.ReadInt(32)
		local ENT = Entity(ENTINDEX)
		if ENT != NULL then
			ENT:SetDInt(key, value)
		else
			timer.Simple(ENTDELAY, function()
				ENT = Entity(ENTINDEX)
				if ENT != NULL then
					ENT:SetDInt(key, value)
				end
			end)
		end
	end)
end

function ENTITY:GetDInt(key, value)
	self.NWTAB = self.NWTAB or {}
	self.NWTAB["INT"] = self.NWTAB["INT"] or {}
	return self.NWTAB["INT"][key] or value
end

-- FLOAT
if SERVER then
	util.AddNetworkString("SetDFloat")
end
function ENTITY:SetDFloat(key, value)
	if isstring(key) and isnumber(tonumber(value)) then
		self.NWTAB = self.NWTAB or {}
		self.NWTAB["FLOAT"] = self.NWTAB["FLOAT"] or {}
		self.NWTAB["FLOAT"][key] = value
		if SERVER then
			net.Start("SetDFloat")
				net.WriteUInt(self:EntIndex(), 16)
				net.WriteString(key)
				net.WriteFloat(value)
			net.Broadcast()
		end
	else
		YRP.msg("note", "[SetDFloat] " .. tostring(key) .. tostring(value))
	end
end
if CLIENT then
	net.Receive("SetDFloat", function(len)
		local ENTINDEX = net.ReadUInt(16)
		local key = net.ReadString()
		local value = net.ReadFloat()
		local ENT = Entity(ENTINDEX)
		if ENT != NULL then
			ENT:SetDFloat(key, value)
		else
			timer.Simple(ENTDELAY, function()
				ENT = Entity(ENTINDEX)
				if ENT != NULL then
					ENT:SetDFloat(key, value)
				end
			end)
		end
	end)
end

function ENTITY:GetDFloat(key, value)
	self.NWTAB = self.NWTAB or {}
	self.NWTAB["FLOAT"] = self.NWTAB["FLOAT"] or {}
	return self.NWTAB["FLOAT"][key] or value
end

-- ENTITY
if SERVER then
	util.AddNetworkString("SetDEntity")
end
function ENTITY:SetDEntity(key, value)
	if isstring(key) and isentity(value) then
		self.NWTAB = self.NWTAB or {}
		self.NWTAB["Entity"] = self.NWTAB["Entity"] or {}
		self.NWTAB["Entity"][key] = value
		if SERVER then
			net.Start("SetDEntity")
				net.WriteUInt(self:EntIndex(), 16)
				net.WriteString(key)
				net.WriteEntity(value)
			net.Broadcast()
		end
	else
		YRP.msg("note", "[SetDEntity] " .. tostring(key) .. tostring(value))
	end
end
if CLIENT then
	net.Receive("SetDEntity", function(len)
		local ENTINDEX = net.ReadUInt(16)
		local key = net.ReadString()
		local value = net.ReadEntity()
		local ENT = Entity(ENTINDEX)
		if ENT != NULL then
			ENT:SetDEntity(key, value)
		else
			timer.Simple(ENTDELAY, function()
				ENT = Entity(ENTINDEX)
				if ENT != NULL then
					ENT:SetDEntity(key, value)
				end
			end)
		end
	end)
end

function ENTITY:GetDEntity(key, value)
	self.NWTAB = self.NWTAB or {}
	self.NWTAB["Entity"] = self.NWTAB["Entity"] or {}
	return self.NWTAB["Entity"][key] or value
end
