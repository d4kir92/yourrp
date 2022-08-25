-- Networking

local ENTITY = FindMetaTable( "Entity" )

YRPDEBUGENTITY = false

local c = {}

-- ANGLE
function ENTITY:GetYRPAngle( key, value )
	if IsValid( self ) then
		return self:GetNW2Angle( key, value )
	end
	return Angle( 0, 0, 0 )
end
function ENTITY:SetYRPAngle( key, value )
	if self:GetYRPAngle( key ) != value or value == Angle( 0, 0, 0 ) then
		self:SetNW2Angle( key, value )
	elseif YRPDEBUGENTITY then
		c["angle"] = c["angle"] or 0
		c["angle"] = c["angle"] + 1
	end
end

-- BOOL
function ENTITY:GetYRPBool( key, value )
	if IsValid( self ) then
		return tobool( self:GetNW2Bool( key, value ) )
	end
	return false
end
function ENTITY:SetYRPBool( key, value )
	if self:GetYRPBool( key ) != value or value == false then
		self:SetNW2Bool( key, value )
	elseif YRPDEBUGENTITY then
		c["bool"] = c["bool"] or 0
		c["bool"] = c["bool"] + 1
	end
end

-- ENTITY
function ENTITY:GetYRPEntity( key, value )
	if IsValid( self ) then
		return self:GetNW2Entity( key, value )
	end
	return NULL
end
function ENTITY:SetYRPEntity( key, value )
	if self:GetYRPEntity( key ) != value or value == NULL then
		self:SetNW2Entity( key, value )
	elseif YRPDEBUGENTITY then
		c["entity"] = c["entity"] or 0
		c["entity"] = c["entity"] + 1
	end
end

-- FLOAT
function ENTITY:GetYRPFloat( key, value )
	if IsValid( self ) then
		return tonumber( self:GetNW2Float( key, value ) )
	end
	return -1.0
end
function ENTITY:SetYRPFloat( key, value )
	if math.abs( self:GetYRPFloat( key ) - value ) > 0.0001 or value == 0 then
		self:SetNW2Float( key, tonumber( value ) )
	elseif YRPDEBUGENTITY then
		c["float"] = c["float"] or 0
		c["float"] = c["float"] + 1
	end
end

-- INT
function ENTITY:GetYRPInt( key, value )
	if IsValid( self ) then
		return tonumber( self:GetNW2Int( key, value ) )
	end
	return -1
end
function ENTITY:SetYRPInt( key, value )
	if self:GetYRPInt( key ) != value or value == 0 then
		self:SetNW2Int( key, tonumber( value ) )
	elseif YRPDEBUGENTITY then
		c["int"] = c["int"] or 0
		c["int"] = c["int"] + 1
	end
end

-- STRING
function ENTITY:GetYRPString( key, value )
	if IsValid( self ) then
		return tostring( self:GetNW2String( key, value ) )
	end
	return ""
end
function ENTITY:SetYRPString( key, value )
	if self:GetYRPString( key ) != value or value == "" then
		self:SetNW2String( key, tostring( value ) )
	elseif YRPDEBUGENTITY then
		c["string"] = c["string"] or 0
		c["string"] = c["string"] + 1
	end
end

-- Vector
function ENTITY:GetYRPVector( key, value )
	if IsValid( self ) then
		return self:GetNW2Vector( key, value )
	end
	return Vector( 0, 0, 0 )
end
function ENTITY:SetYRPVector( key, value )
	if self:GetYRPVector( key ) != value or value == Vector( 0, 0, 0 ) then
		self:SetNW2Vector( key, value )
	elseif YRPDEBUGENTITY then
		c["vector"] = c["vector"] or 0
		c["vector"] = c["vector"] + 1
	end
end

if YRPDEBUGENTITY then
	YRPDEBUGENTITY_V = YRPDEBUGENTITY_V or 0
	YRPDEBUGENTITY_V = YRPDEBUGENTITY_V + 1

	local v = YRPDEBUGENTITY_V

	local function ShowStatsLoop()
		if pTab then
			MsgC( YRPColGreen(), "YRP - ENTITY:\n")
			pTab(c)
		end
		if YRPDEBUGENTITY and v == YRPDEBUGENTITY_V then
			timer.Simple(1, ShowStatsLoop)
		end
	end
	ShowStatsLoop()
end
