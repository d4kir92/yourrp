-- Networking
local NWSystem = 2
YRP_Global_Tables = YRP_Global_Tables or {}
YRPDEBUGGLOBAL = false
local c = {}
if SERVER then
	YRP:AddNetworkString("YRPSetGlobalYRPTable")
	YRP:AddNetworkString("YRPGetGlobalYRPTables")
end

function GetGlobalYRPTable(key, value)
	return YRP_Global_Tables[key] or value or {}
end

function SetGlobalYRPTable(key, value)
	if key and value and type(key) == "string" and type(value) == "table" then
		YRP_Global_Tables[key] = value
		if SERVER then
			net.Start("YRPSetGlobalYRPTable")
			net.WriteString(key)
			net.WriteTable(value)
			net.Broadcast()
		end
	else
		Msg(Color(0, 255, 0), ">>> SetGlobalYRPTable FAILED", key, value)
	end
end

if SERVER then
	net.Receive(
		"YRPGetGlobalYRPTables",
		function(len, ply)
			for key, value in pairs(YRP_Global_Tables) do
				if key and value and type(key) == "string" and type(value) == "table" then
					net.Start("YRPSetGlobalYRPTable")
					net.WriteString(key)
					net.WriteTable(value)
					net.Send(ply)
				end
			end
		end
	)
end

if CLIENT then
	net.Receive(
		"YRPSetGlobalYRPTable",
		function(len)
			local key = net.ReadString()
			local tab = net.ReadTable()
			SetGlobalYRPTable(key, tab)
		end
	)

	hook.Add(
		"PostGamemodeLoaded",
		"yrp_PostGamemodeLoaded_GlobalTable",
		function()
			timer.Simple(
				0.1,
				function()
					net.Start("YRPGetGlobalYRPTables")
					net.SendToServer()
				end
			)
		end
	)
end

-- OTHER (REDUCE SET NETWORKING)
function GetGlobalYRPAngle(index, value)
	if NWSystem == 1 then
		return GetGlobalAngle(index, value)
	else
		return GetGlobal2Angle(index, value)
	end
end

function SetGlobalYRPAngle(index, value)
	if GetGlobalYRPAngle(index) ~= value or value == Angle(0, 0, 0) then
		if NWSystem == 1 then
			SetGlobalAngle(index, value)
		else
			SetGlobal2Angle(index, value)
		end
	elseif YRPDEBUGGLOBAL then
		c["angle"] = c["angle"] or 0
		c["angle"] = c["angle"] + 1
	end
end

function GetGlobalYRPBool(index, value)
	if NWSystem == 1 then
		return GetGlobalBool(index)
	else
		return GetGlobal2Bool(index)
	end
end

function SetGlobalYRPBool(index, value)
	if GetGlobalYRPBool(index) ~= value or value == false then
		if NWSystem == 1 then
			SetGlobalBool(index, value)
		else
			SetGlobal2Bool(index, value)
		end
	elseif YRPDEBUGGLOBAL then
		c["bool"] = c["bool"] or 0
		c["bool"] = c["bool"] + 1
	end
end

function GetGlobalYRPEntity(index, value)
	if NWSystem == 1 then
		return GetGlobalEntity(index, value)
	else
		return GetGlobal2Entity(index, value)
	end
end

function SetGlobalYRPEntity(index, value)
	if GetGlobalYRPEntity(index) ~= value or value == NULL then
		if NWSystem == 1 then
			SetGlobalEntity(index, value)
		else
			SetGlobal2Entity(index, value)
		end
	elseif YRPDEBUGGLOBAL then
		c["entity"] = c["entity"] or 0
		c["entity"] = c["entity"] + 1
	end
end

function GetGlobalYRPFloat(index, value)
	if NWSystem == 1 then
		return tonumber(GetGlobalFloat(index, value))
	else
		return tonumber(GetGlobal2Float(index, value))
	end
end

function SetGlobalYRPFloat(index, value)
	value = tonumber(value)
	if math.abs(GetGlobalYRPFloat(index) - value) > 0.0001 or value == 0 then
		if NWSystem == 1 then
			SetGlobalFloat(index, value)
		else
			SetGlobal2Float(index, value)
		end
	elseif YRPDEBUGGLOBAL then
		c["float"] = c["float"] or 0
		c["float"] = c["float"] + 1
	end
end

function GetGlobalYRPInt(index, value)
	if NWSystem == 1 then
		return tonumber(GetGlobalInt(index, value))
	else
		return tonumber(GetGlobal2Int(index, value))
	end
end

function SetGlobalYRPInt(index, value)
	value = tonumber(value)
	if GetGlobalYRPInt(index) ~= value or value == 0 then
		if NWSystem == 1 then
			SetGlobalInt(index, value)
		else
			SetGlobal2Int(index, value)
		end
	elseif YRPDEBUGGLOBAL then
		c["int"] = c["int"] or 0
		c["int"] = c["int"] + 1
	end
end

function GetGlobalYRPString(index, value)
	if NWSystem == 1 then
		return tostring(GetGlobalString(index, value))
	else
		return tostring(GetGlobal2String(index, value))
	end
end

function SetGlobalYRPString(index, value)
	if index and index == "ServerName" then
		YRP:msg("error", "Someone tried to set ServerName")
	end

	if GetGlobalYRPString(index) ~= value or value == "" then
		if NWSystem == 1 then
			SetGlobalString(index, value)
		else
			SetGlobal2String(index, value)
		end
	elseif YRPDEBUGGLOBAL then
		c["string"] = c["string"] or 0
		c["string"] = c["string"] + 1
	end
end

function GetGlobalYRPVector(index, value)
	if NWSystem == 1 then
		return GetGlobalVector(index, value)
	else
		return GetGlobal2Vector(index, value)
	end
end

function SetGlobalYRPVector(index, value)
	if GetGlobalYRPVector(index) ~= value or value == Vector(0, 0, 0) then
		if NWSystem == 1 then
			SetGlobalVector(index, value)
		else
			SetGlobal2Vector(index, value)
		end
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
			MsgC(Color(0, 255, 0), "YRP - GLOBAL:\n")
			pTab(c)
		end

		if YRPDEBUGGLOBAL and v == YRPDEBUGGLOBAL_V then
			timer.Simple(1, ShowStatsLoop)
		end
	end

	ShowStatsLoop()
end
