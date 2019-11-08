-- Networking
NWGlobal = NWGlobal or {}

-- BOOL
if SERVER then
	util.AddNetworkString("SetGlobalDBool")
	function SendGlobalDBool(index, bo, ply)
		net.Start("SetGlobalDBool")
			net.WriteString(index)
			net.WriteBool(bo)
		if IsValid(ply) then
			net.Send(ply)
		else
			net.Broadcast()
		end
	end
end
function SetGlobalDBool(index, bo)
	NWGlobal["BOOL"] = NWGlobal["BOOL"] or {}
	NWGlobal["BOOL"][index] = bo
	if SERVER then
		SendGlobalDBool(index, bo)
	end
end
if CLIENT then
	net.Receive("SetGlobalDBool", function(len)
		local index = net.ReadString()
		local value = net.ReadBool()
		SetGlobalDBool(index, value)
	end)
end

function GetGlobalDBool(index, def)
	NWGlobal["BOOL"] = NWGlobal["BOOL"] or {}
	local result = NWGlobal["BOOL"][index]
	if isbool(result) then
		return result
	elseif isbool(def) then
		return def
	else
		return false
	end
end

-- STRING
if SERVER then
	util.AddNetworkString("SetGlobalDString")
	function SendGlobalDString(index, str, ply)
		net.Start("SetGlobalDString")
			net.WriteString(index)
			net.WriteString(str)
		if IsValid(ply) then
			net.Send(ply)
		else
			net.Broadcast()
		end
	end
end
function SetGlobalDString(index, str)
	NWGlobal["STRING"] = NWGlobal["STRING"] or {}
	NWGlobal["STRING"][index] = str
	if SERVER then
		SendGlobalDString(index, str)
	end
end
if CLIENT then
	net.Receive("SetGlobalDString", function(len)
		local index = net.ReadString()
		local value = net.ReadString()
		SetGlobalDString(index, value)
	end)
end

function GetGlobalDString(index, def)
	NWGlobal["STRING"] = NWGlobal["STRING"] or {}
	local result = NWGlobal["STRING"][index]
	return result or def
end

-- INT
if SERVER then
	util.AddNetworkString("SetGlobalDInt")
	function SendGlobalDInt(index, int, ply)
		net.Start("SetGlobalDInt")
			net.WriteString(index)
			net.WriteInt(int, 32)
		if IsValid(ply) then
			net.Send(ply)
		else
			net.Broadcast()
		end
	end
end
function SetGlobalDInt(index, int)
	NWGlobal["INT"] = NWGlobal["INT"] or {}
	NWGlobal["INT"][index] = int
	if SERVER then
		SendGlobalDInt(index, int)
	end
end
if CLIENT then
	net.Receive("SetGlobalDInt", function(len)
		local index = net.ReadString()
		local value = net.ReadInt(32)
		SetGlobalDInt(index, value)
	end)
end

function GetGlobalDInt(index, def)
	NWGlobal["INT"] = NWGlobal["INT"] or {}
	local result = NWGlobal["INT"][index]
	return result or def
end

-- FLOAT
if SERVER then
	util.AddNetworkString("SetGlobalDFloat")
	function SendGlobalDFloat(index, flo, ply)
		net.Start("SetGlobalDFloat")
			net.WriteString(index)
			net.WriteFloat(flo)
		if IsValid(ply) then
			net.Send(ply)
		else
			net.Broadcast()
		end
	end
end
function SetGlobalDFloat(index, flo)
	NWGlobal["FLOAT"] = NWGlobal["FLOAT"] or {}
	NWGlobal["FLOAT"][index] = flo
	if SERVER then
		SendGlobalDFloat(index, flo)
	end
end
if CLIENT then
	net.Receive("SetGlobalDFloat", function(len)
		local index = net.ReadString()
		local value = net.ReadFloat()
		SetGlobalDFloat(index, value)
	end)
end

function GetGlobalDFloat(index, def)
	NWGlobal["FLOAT"] = NWGlobal["FLOAT"] or {}
	local result = NWGlobal["FLOAT"][index]
	return result or def
end

-- TABLE
if SERVER then
	util.AddNetworkString("SetGlobalDTable")
	function SendGlobalDTable(index, tab, ply)
		net.Start("SetGlobalDTable")
			net.WriteString(index)
			net.WriteTable(tab)
		if IsValid(ply) then
			net.Send(ply)
		else
			net.Broadcast()
		end
	end
end
function SetGlobalDTable(index, tab)
	NWGlobal["TABLE"] = NWGlobal["TABLE"] or {}
	NWGlobal["TABLE"][index] = tab
	if SERVER then
		SendGlobalDTable(index, tab)
	end
end
if CLIENT then
	net.Receive("SetGlobalDTable", function(len)
		local index = net.ReadString()
		local value = net.ReadTable()
		SetGlobalDTable(index, value)
	end)
end

function GetGlobalDTable(index, def)
	NWGlobal["TABLE"] = NWGlobal["TABLE"] or {}
	local result = NWGlobal["TABLE"][index]
	return result or def or {}
end

-- INIT
if SERVER then
	util.AddNetworkString("request_dglobals")

	function SendDGlobals(ply)
		NWGlobal["BOOL"] = NWGlobal["BOOL"] or {}
		for i, v in pairs(NWGlobal["BOOL"]) do
			SendGlobalDBool(i, v, ply)
		end
		NWGlobal["STRING"] = NWGlobal["STRING"] or {}
		for i, v in pairs(NWGlobal["STRING"]) do
			SendGlobalDString(i, v, ply)
		end
		NWGlobal["INT"] = NWGlobal["INT"] or {}
		for i, v in pairs(NWGlobal["INT"]) do
			SendGlobalDInt(i, v, ply)
		end
		NWGlobal["FLOAT"] = NWGlobal["FLOAT"] or {}
		for i, v in pairs(NWGlobal["FLOAT"]) do
			SendGlobalDFloat(i, v, ply)
		end
		NWGlobal["TABLE"] = NWGlobal["TABLE"] or {}
		for i, v in pairs(NWGlobal["TABLE"]) do
			SendGlobalDTable(i, v, ply)
		end
	end
	net.Receive("request_dglobals", function(len, ply)
		SendDGlobals(ply)
	end)
end
