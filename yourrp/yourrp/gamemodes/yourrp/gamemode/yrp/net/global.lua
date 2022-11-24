-- Networking

YRP_Global_Tables = YRP_Global_Tables or {}

YRPDEBUGGLOBAL = false

local c = {}

if SERVER then
	util.AddNetworkString( "YRPSetGlobalYRPTable" )
	util.AddNetworkString( "YRPGetGlobalYRPTables" )
end

function GetGlobalYRPTable( key, value )
	return YRP_Global_Tables[key] or value or {}
end

function SetGlobalYRPTable( key, value )
	if type(key) == "string" and type( value) == "table" then
		YRP_Global_Tables[key] = value
		if SERVER then
			net.Start( "YRPSetGlobalYRPTable" )
				net.WriteString(key)
				net.WriteTable( value )
			net.Broadcast()
		end
	else
		Msg(Color( 0, 255, 0 ), ">>> SetGlobalYRPTable FAILED", key, value)
	end
end

if SERVER then
	net.Receive( "YRPGetGlobalYRPTables", function(len, ply)
		for key, value in pairs(YRP_Global_Tables) do
			net.Start( "YRPSetGlobalYRPTable" )
				net.WriteString(key)
				net.WriteTable( value )
			net.Send(ply)
		end
	end)
end

if CLIENT then
	net.Receive( "YRPSetGlobalYRPTable", function(len)
		local key = net.ReadString()
		local tab = net.ReadTable()

		SetGlobalYRPTable( key, tab )
	end)

	hook.Add( "PostGamemodeLoaded", "yrp_PostGamemodeLoaded_GlobalTable", function()
		timer.Simple(0.1, function()
			net.Start( "YRPGetGlobalYRPTables" )
			net.SendToServer()
		end)
	end)
end

-- OTHER (REDUCE SET NETWORKING)
function GetGlobalYRPAngle( index, value )
	return GetGlobalAngle( index, value )
end

function SetGlobalYRPAngle( index, value )
	if GetGlobalYRPAngle( index ) != value or value == Angle( 0, 0, 0 ) then
		return SetGlobalAngle( index, value )
	elseif YRPDEBUGGLOBAL then
		c["angle"] = c["angle"] or 0
		c["angle"] = c["angle"] + 1
	end
end



function GetGlobalYRPBool( index, value )
	return GetGlobalBool( index )
end

function SetGlobalYRPBool( index, value )
	if GetGlobalYRPBool( index ) != value or value == false then
		return SetGlobalBool( index, value )
	elseif YRPDEBUGGLOBAL then
		c["bool"] = c["bool"] or 0
		c["bool"] = c["bool"] + 1
	end
end



function GetGlobalYRPEntity( index, value )
	return GetGlobalEntity( index, value )
end

function SetGlobalYRPEntity( index, value )
	if GetGlobalYRPEntity( index ) != value or value == NULL then
		return SetGlobalEntity( index, value )
	elseif YRPDEBUGGLOBAL then
		c["entity"] = c["entity"] or 0
		c["entity"] = c["entity"] + 1
	end
end



function GetGlobalYRPFloat( index, value )
	return tonumber( GetGlobalFloat( index, value ) )
end

function SetGlobalYRPFloat( index, value )
	value = tonumber( value )
	if math.abs( GetGlobalYRPFloat( index ) - value ) > 0.0001 or value == 0 then
		return SetGlobalFloat( index, value )
	elseif YRPDEBUGGLOBAL then
		c["float"] = c["float"] or 0
		c["float"] = c["float"] + 1
	end
end



function GetGlobalYRPInt( index, value )
	return tonumber( GetGlobalInt( index, value ) )
end

function SetGlobalYRPInt( index, value )
	value = tonumber( value )
	if GetGlobalYRPInt( index ) != value or value == 0 then
		return SetGlobalInt( index, value )
	elseif YRPDEBUGGLOBAL then
		c["int"] = c["int"] or 0
		c["int"] = c["int"] + 1
	end
end



function GetGlobalYRPString( index, value )
	return GetGlobalString( index, value )
end

function SetGlobalYRPString( index, value )
	if GetGlobalYRPString( index ) != value or value == "" then
		return SetGlobalString( index, value )
	elseif YRPDEBUGGLOBAL then
		c["string"] = c["string"] or 0
		c["string"] = c["string"] + 1
	end
end



function GetGlobalYRPVector( index, value )
	return GetGlobalVector( index, value )
end

function SetGlobalYRPVector( index, value )
	if GetGlobalYRPVector( index ) != value or value == Vector( 0, 0, 0 ) then
		return SetGlobalVector( index, value )
	elseif YRPDEBUGGLOBAL then
		c["vector"] = c["vector"] or 0
		c["vector"] = c["vector"] + 1
	end
end

if YRPDEBUGGLOBAL then
	YRPDEBUGGLOBAL_V = YRPDEBUGGLOBAL_V or 0
	YRPDEBUGGLOBAL_V = YRPDEBUGGLOBAL_V + 1

	local v = YRPDEBUGGLOBAL_V

	local function ShowStatsLoop()
		if pTab then
			MsgC( Color( 0, 255, 0 ), "YRP - GLOBAL:\n")
			pTab(c)
		end
		if YRPDEBUGGLOBAL and v == YRPDEBUGGLOBAL_V then
			timer.Simple(1, ShowStatsLoop)
		end
	end
	ShowStatsLoop()
end
