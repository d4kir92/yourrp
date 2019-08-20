-- Networking
local ENTITY = FindMetaTable("Entity")

local ENTDELAY = 0.05

-- STRING
if SERVER then
	util.AddNetworkString("SetDString")
	function ENTITY:SendDString(key, value)
		net.Start("SetDString")
			net.WriteUInt(self:EntIndex(), 16)
			net.WriteString(key)
			net.WriteString(value)
		net.Broadcast()
	end
end
function ENTITY:SetDString(key, value)
	value = tostring(value)
	if isstring(key) and value != "nil" then
		self.NWTAB = self.NWTAB or {}
		self.NWTAB["STRING"] = self.NWTAB["STRING"] or {}
		self.NWTAB["STRING"][key] = value
		if SERVER then
			self:SendDString(key, value)
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
	if self != NULL then
		self.NWTAB = self.NWTAB or {}
		self.NWTAB["STRING"] = self.NWTAB["STRING"] or {}
		return self.NWTAB["STRING"][key] or value
	else
		return ""
	end
end

-- BOOL
if SERVER then
	util.AddNetworkString("SetDBool")
	function ENTITY:SendDBool(key, value)
		net.Start("SetDBool")
			net.WriteUInt(self:EntIndex(), 16)
			net.WriteString(key)
			net.WriteBool(value)
		net.Broadcast()
	end
end
function ENTITY:SetDBool(key, value)
	if isstring(key) and isbool(value) then
		self.NWTAB = self.NWTAB or {}
		self.NWTAB["BOOL"] = self.NWTAB["BOOL"] or {}
		self.NWTAB["BOOL"][key] = value
		if SERVER then
			self:SendDBool(key, value)
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
	if self != NULL then
	  self.NWTAB = self.NWTAB or {}
		self.NWTAB["BOOL"] = self.NWTAB["BOOL"] or {}
		local result = self.NWTAB["BOOL"][key]
		if isbool(result) then
			return result
		else
			return value
		end
	else
		return false
	end
end

-- INT
if SERVER then
	util.AddNetworkString("SetDInt")
	function ENTITY:SendDInt(key, value)
		net.Start("SetDInt")
			net.WriteUInt(self:EntIndex(), 16)
			net.WriteString(key)
			net.WriteInt(value, 32)
		net.Broadcast()
	end
end
function ENTITY:SetDInt(key, value)
	if isstring(key) and isnumber(tonumber(value)) then
		self.NWTAB = self.NWTAB or {}
		self.NWTAB["INT"] = self.NWTAB["INT"] or {}
		self.NWTAB["INT"][key] = value
		if SERVER then
			self:SendDInt(key, value)
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
	if self != NULL then
	  self.NWTAB = self.NWTAB or {}
		self.NWTAB["INT"] = self.NWTAB["INT"] or {}
		return self.NWTAB["INT"][key] or value
	else
		return -1
	end
end

-- FLOAT
if SERVER then
	util.AddNetworkString("SetDFloat")
	function ENTITY:SendDFloat(key, value)
		net.Start("SetDFloat")
			net.WriteUInt(self:EntIndex(), 16)
			net.WriteString(key)
			net.WriteFloat(value)
		net.Broadcast()
	end
end
function ENTITY:SetDFloat(key, value)
	if isstring(key) and isnumber(tonumber(value)) then
		self.NWTAB = self.NWTAB or {}
		self.NWTAB["FLOAT"] = self.NWTAB["FLOAT"] or {}
		self.NWTAB["FLOAT"][key] = value
		if SERVER then
			self:SendDFloat(key, value)
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
	if self != NULL then
	  self.NWTAB = self.NWTAB or {}
		self.NWTAB["FLOAT"] = self.NWTAB["FLOAT"] or {}
		return self.NWTAB["FLOAT"][key] or value
	else
		return -1.0
	end
end

-- ENTITY
if SERVER then
	util.AddNetworkString("SetDEntity")
	function ENTITY:SendDEntity(key, value)
		net.Start("SetDEntity")
			net.WriteUInt(self:EntIndex(), 16)
			net.WriteString(key)
			net.WriteEntity(value)
		net.Broadcast()
	end
end
function ENTITY:SetDEntity(key, value)
	if isstring(key) and isentity(value) then
		self.NWTAB = self.NWTAB or {}
		self.NWTAB["ENTITY"] = self.NWTAB["ENTITY"] or {}
		self.NWTAB["ENTITY"][key] = value
		if SERVER then
			self:SendDEntity(key, value)
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
	if self != NULL then
	  self.NWTAB = self.NWTAB or {}
		self.NWTAB["TABLE"] = self.NWTAB["TABLE"] or {}
		return self.NWTAB["TABLE"][key] or value
	else
		return NULL
	end
end

-- TABLE
if SERVER then
	util.AddNetworkString("SetDTable")
	function ENTITY:SendDTable(key, value)
		net.Start("SetDTable")
			net.WriteUInt(self:EntIndex(), 16)
			net.WriteString(key)
			net.WriteTable(value)
		net.Broadcast()
	end
end
function ENTITY:SetDTable(key, value)
	if isstring(key) and istable(value) then
		self.NWTAB = self.NWTAB or {}
		self.NWTAB["TABLE"] = self.NWTAB["TABLE"] or {}
		self.NWTAB["TABLE"][key] = value
		if SERVER then
			self:SendDTable(key, value)
		end
	else
		YRP.msg("note", "[SetDTable] " .. tostring(key) .. tostring(value))
	end
end
if CLIENT then
	net.Receive("SetDTable", function(len)
		local ENTINDEX = net.ReadUInt(16)
		local key = net.ReadString()
		local value = net.ReadTable()
		local ENT = Entity(ENTINDEX)
		if ENT != NULL then
			ENT:SetDTable(key, value)
		else
			timer.Simple(ENTDELAY, function()
				ENT = Entity(ENTINDEX)
				if ENT != NULL then
					ENT:SetDTable(key, value)
				end
			end)
		end
	end)
end

function ENTITY:GetDTable(key, value)
	if self != NULL then
	  self.NWTAB = self.NWTAB or {}
		self.NWTAB["TABLE"] = self.NWTAB["TABLE"] or {}
		return self.NWTAB["TABLE"][key] or value
	else
		return NULL
	end
end

-- INIT
if SERVER then
	util.AddNetworkString("request_dentites")

	function SendDEntities(ply)
		for j, ent in pairs(ents.GetAll()) do
			ent.NWTAB = ent.NWTAB or {}
			ent.NWTAB["BOOL"] = ent.NWTAB["BOOL"] or {}
			for i, v in pairs(ent.NWTAB["BOOL"]) do
				ent:SendDBool(i, v)
			end
			ent.NWTAB["STRING"] = ent.NWTAB["STRING"] or {}
			for i, v in pairs(ent.NWTAB["STRING"]) do
				ent:SendDString(i, v)
			end
			ent.NWTAB["INT"] = ent.NWTAB["INT"] or {}
			for i, v in pairs(ent.NWTAB["INT"]) do
				ent:SendDInt(i, v)
			end
			ent.NWTAB["FLOAT"] = ent.NWTAB["FLOAT"] or {}
			for i, v in pairs(ent.NWTAB["FLOAT"]) do
				ent:SendDFloat(i, v)
			end
		end
	end
	net.Receive("request_dentites", function(len, ply)
		SendDEntities(ply)
	end)
end
