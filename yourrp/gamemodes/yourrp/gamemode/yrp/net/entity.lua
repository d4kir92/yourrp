-- Networking

local ENTITY = FindMetaTable( "Entity" )

YRPDEBUGENTITY = false

local c = {}

-- ANGLE
function ENTITY:GetYRPAngle( key, value )
	return self:GetNWAngle( key, value )
end
function ENTITY:SetYRPAngle( key, value )
	if self:GetYRPAngle( key ) != value or value == Angle( 0, 0, 0 ) then
		self:SetNWAngle( key, value )
	elseif YRPDEBUGENTITY then
		c["angle"] = c["angle"] or 0
		c["angle"] = c["angle"] + 1
	end
end

-- BOOL
function ENTITY:GetYRPBool( key, value )
	return tobool( self:GetNWBool( key, value ) )
end
function ENTITY:SetYRPBool( key, value )
	if self:GetYRPBool( key ) != value or value == false then
		self:SetNWBool( key, value )
	elseif YRPDEBUGENTITY then
		c["bool"] = c["bool"] or 0
		c["bool"] = c["bool"] + 1
	end
end

-- ENTITY
function ENTITY:GetYRPEntity( key, value )
	return self:GetNWEntity( key, value )
end
function ENTITY:SetYRPEntity( key, value )
	if self:GetYRPEntity( key ) != value or value == NULL then
		self:SetNWEntity( key, value )
	elseif YRPDEBUGENTITY then
		c["entity"] = c["entity"] or 0
		c["entity"] = c["entity"] + 1
	end
end

-- FLOAT
function ENTITY:GetYRPFloat( key, value )
	return tonumber( self:GetNWFloat( key, value ) )
end
function ENTITY:SetYRPFloat( key, value )
	if math.abs( self:GetYRPFloat( key ) - value ) > 0.0001 or value == 0 then
		self:SetNWFloat( key, tonumber( value ) )
	elseif YRPDEBUGENTITY then
		c["float"] = c["float"] or 0
		c["float"] = c["float"] + 1
	end
end

-- INT
function ENTITY:GetYRPInt( key, value )
	return tonumber( self:GetNWInt( key, value ) )
end
function ENTITY:SetYRPInt( key, value )
	if self:GetYRPInt( key ) != value or value == 0 then
		self:SetNWInt( key, tonumber( value ) )
	elseif YRPDEBUGENTITY then
		c["int"] = c["int"] or 0
		c["int"] = c["int"] + 1
	end
end

-- STRING
function ENTITY:GetYRPString( key, value )
	return tostring( self:GetNWString( key, value ) )
end
function ENTITY:SetYRPString( key, value )
	if self:GetYRPString( key ) != value or value == "" then
		self:SetNWString( key, tostring( value ) )
	elseif YRPDEBUGENTITY then
		c["string"] = c["string"] or 0
		c["string"] = c["string"] + 1
	end
end

-- Vector
function ENTITY:GetYRPVector( key, value )
	return self:GetNWVector( key, value )
end
function ENTITY:SetYRPVector( key, value )
	if self:GetYRPVector( key ) != value or value == Vector( 0, 0, 0 ) then
		self:SetNWVector( key, value )
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
			MsgC( Color( 0, 255, 0 ), "YRP - ENTITY:\n")
			pTab(c)
		end
		if YRPDEBUGENTITY and v == YRPDEBUGENTITY_V then
			timer.Simple(1, ShowStatsLoop)
		end
	end
	ShowStatsLoop()
end
