-- Networking
local NWSystem = 2
local ENTITY = FindMetaTable("Entity")
YRPDEBUGENTITY = false
local c = {}
-- ANGLE
function ENTITY:GetYRPAngle(key, value)
	if IsValid(self) then
		if NWSystem == 1 then
			return self:GetNWAngle(key, value)
		else
			return self:GetNW2Angle(key, value)
		end
	end

	return Angle(0, 0, 0)
end

function ENTITY:SetYRPAngle(key, value)
	if IsValid(self) then
		if self:GetYRPAngle(key) ~= value or value == Angle(0, 0, 0) then
			if NWSystem == 1 then
				self:SetNWAngle(key, value)
			else
				self:SetNW2Angle(key, value)
			end
		elseif YRPDEBUGENTITY then
			c["angle"] = c["angle"] or 0
			c["angle"] = c["angle"] + 1
		end
	end
end

-- BOOL
function ENTITY:GetYRPBool(key, value)
	if IsValid(self) then
		if NWSystem == 1 then
			return tobool(self:GetNWBool(key, value))
		else
			return tobool(self:GetNW2Bool(key, value))
		end
	end

	return false
end

function ENTITY:SetYRPBool(key, value)
	if IsValid(self) then
		if self:GetYRPBool(key) ~= value or value == false then
			if NWSystem == 1 then
				self:SetNWBool(key, value)
			else
				self:SetNW2Bool(key, value)
			end
		elseif YRPDEBUGENTITY then
			c["bool"] = c["bool"] or 0
			c["bool"] = c["bool"] + 1
		end
	end
end

-- ENTITY
function ENTITY:GetYRPEntity(key, value)
	if IsValid(self) then
		if NWSystem == 1 then
			return self:GetNWEntity(key, value)
		else
			return self:GetNW2Entity(key, value)
		end
	end

	return NULL
end

function ENTITY:SetYRPEntity(key, value)
	if IsValid(self) then
		if self:GetYRPEntity(key) ~= value or value == NULL then
			if NWSystem == 1 then
				self:SetNWEntity(key, value)
			else
				self:SetNW2Entity(key, value)
			end
		elseif YRPDEBUGENTITY then
			c["entity"] = c["entity"] or 0
			c["entity"] = c["entity"] + 1
		end
	end
end

-- FLOAT
function ENTITY:GetYRPFloat(key, value)
	if IsValid(self) then
		if NWSystem == 1 then
			return tonumber(self:GetNWFloat(key, value))
		else
			return tonumber(self:GetNW2Float(key, value))
		end
	end

	return -1.0
end

function ENTITY:SetYRPFloat(key, value)
	if IsValid(self) then
		if math.abs(self:GetYRPFloat(key) - value) > 0.0001 or value == -1.0 or value == 0.0 then
			if NWSystem == 1 then
				self:SetNWFloat(key, tonumber(value))
			else
				self:SetNW2Float(key, tonumber(value))
			end
		elseif YRPDEBUGENTITY then
			c["float"] = c["float"] or 0
			c["float"] = c["float"] + 1
		end
	end
end

-- INT
function ENTITY:GetYRPInt(key, value)
	if IsValid(self) then
		if NWSystem == 1 then
			return tonumber(self:GetNWInt(key, value))
		else
			return tonumber(self:GetNW2Int(key, value))
		end
	end

	return -1
end

function ENTITY:SetYRPInt(key, value)
	if IsValid(self) then
		if self:GetYRPInt(key) ~= value or value == -1 or value == 0 then
			if NWSystem == 1 then
				self:SetNWInt(key, tonumber(value))
			else
				self:SetNW2Int(key, tonumber(value))
			end
		elseif YRPDEBUGENTITY then
			c["int"] = c["int"] or 0
			c["int"] = c["int"] + 1
		end
	end
end

-- STRING
function ENTITY:GetYRPString(key, value)
	if IsValid(self) then
		if NWSystem == 1 then
			return tostring(self:GetNWString(key, value))
		else
			return tostring(self:GetNW2String(key, value))
		end
	end

	return ""
end

function ENTITY:SetYRPString(key, value)
	if IsValid(self) then
		if self:GetYRPString(key) ~= value or value == "" and string.lower(key) ~= "usergroup" then
			if NWSystem == 1 then
				self:SetNWString(key, tostring(value))
			else
				self:SetNW2String(key, tostring(value))
			end
		elseif YRPDEBUGENTITY then
			c["string"] = c["string"] or 0
			c["string"] = c["string"] + 1
		end
	end
end

-- Vector
function ENTITY:GetYRPVector(key, value)
	if IsValid(self) then
		if NWSystem == 1 then
			return self:GetNWVector(key, value)
		else
			return self:GetNW2Vector(key, value)
		end
	end

	return Vector(0, 0, 0)
end

function ENTITY:SetYRPVector(key, value)
	if IsValid(self) then
		if self:GetYRPVector(key) ~= value or value == Vector(0, 0, 0) then
			if NWSystem == 1 then
				self:SetNWVector(key, value)
			else
				self:SetNW2Vector(key, value)
			end
		elseif YRPDEBUGENTITY then
			c["vector"] = c["vector"] or 0
			c["vector"] = c["vector"] + 1
		end
	end
end

if YRPDEBUGENTITY then
	YRPDEBUGENTITY_V = YRPDEBUGENTITY_V or 0
	YRPDEBUGENTITY_V = YRPDEBUGENTITY_V + 1
	local v = YRPDEBUGENTITY_V
	local function ShowStatsLoop()
		if pTab then
			MsgC(Color(0, 255, 0), "YRP - ENTITY:\n")
			pTab(c)
		end

		if YRPDEBUGENTITY and v == YRPDEBUGENTITY_V then
			timer.Simple(1, ShowStatsLoop)
		end
	end

	ShowStatsLoop()
end