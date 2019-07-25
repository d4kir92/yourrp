-- Networking
NWGlobal = NWGlobal or {}

-- BOOL
if SERVER then
	util.AddNetworkString("SetGlobalDBool")
end
function SetGlobalDBool(index, bool)
	NWGlobal["BOOL"] = NWGlobal["BOOL"] or {}
	NWGlobal["BOOL"][index] = bool
	if SERVER then
		net.Start("SetGlobalDBool")
			net.WriteString(index)
			net.WriteBool(bool)
		net.Broadcast()
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
end
function SetGlobalDString(index, str)
	NWGlobal["STRING"] = NWGlobal["STRING"] or {}
	NWGlobal["STRING"][index] = str
	if SERVER then
		net.Start("SetGlobalDString")
			net.WriteString(index)
			net.WriteString(str)
		net.Broadcast()
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
end
function SetGlobalDInt(index, int)
	NWGlobal["INT"] = NWGlobal["INT"] or {}
	NWGlobal["INT"][index] = int
	if SERVER then
		net.Start("SetGlobalDInt")
			net.WriteString(index)
			net.WriteInt(int, 32)
		net.Broadcast()
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
end
function SetGlobalDFloat(index, flo)
	NWGlobal["FLOAT"] = NWGlobal["FLOAT"] or {}
	NWGlobal["FLOAT"][index] = flo
	if SERVER then
		net.Start("SetGlobalDFloat")
			net.WriteString(index)
			net.WriteFloat(flo)
		net.Broadcast()
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
