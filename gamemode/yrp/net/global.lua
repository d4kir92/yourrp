-- Networking

YRP_NW_Globals = YRP_NW_Globals or {}

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
	YRP_NW_Globals["BOOL"] = YRP_NW_Globals["BOOL"] or {}
	if YRP_NW_Globals["BOOL"][index] != bo or YRP_NW_Globals["BOOL"][index] == nil then
		YRP_NW_Globals["BOOL"][index] = bo
		if SERVER then
			SendGlobalDBool(index, bo)
		end
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
	YRP_NW_Globals["BOOL"] = YRP_NW_Globals["BOOL"] or {}
	local result = YRP_NW_Globals["BOOL"][index]
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
	YRP_NW_Globals["STRING"] = YRP_NW_Globals["STRING"] or {}
	if YRP_NW_Globals["STRING"][index] != str or YRP_NW_Globals["STRING"][index] == nil then
		YRP_NW_Globals["STRING"][index] = str
		if SERVER then
			SendGlobalDString(index, str)
		end
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
	YRP_NW_Globals["STRING"] = YRP_NW_Globals["STRING"] or {}
	local result = YRP_NW_Globals["STRING"][index]
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
	YRP_NW_Globals["INT"] = YRP_NW_Globals["INT"] or {}
	if YRP_NW_Globals["INT"][index] != int or YRP_NW_Globals["INT"][index] == nil then
		YRP_NW_Globals["INT"][index] = tonumber(int)
		if SERVER then
			SendGlobalDInt(index, int)
		end
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
	YRP_NW_Globals["INT"] = YRP_NW_Globals["INT"] or {}
	local result = YRP_NW_Globals["INT"][index]
	result = result or def
	return tonumber(result)
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
	YRP_NW_Globals["FLOAT"] = YRP_NW_Globals["FLOAT"] or {}
	if YRP_NW_Globals["FLOAT"][index] != flo or YRP_NW_Globals["FLOAT"][index] == nil then
		YRP_NW_Globals["FLOAT"][index] = flo
		if SERVER then
			SendGlobalDFloat(index, flo)
		end
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
	YRP_NW_Globals["FLOAT"] = YRP_NW_Globals["FLOAT"] or {}
	local result = YRP_NW_Globals["FLOAT"][index]
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
	YRP_NW_Globals["TABLE"] = YRP_NW_Globals["TABLE"] or {}
	if YRP_NW_Globals["TABLE"][index] != tab or YRP_NW_Globals["TABLE"][index] == nil then
		YRP_NW_Globals["TABLE"][index] = tab
		if SERVER then
			SendGlobalDTable(index, tab)
		end
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
	YRP_NW_Globals["TABLE"] = YRP_NW_Globals["TABLE"] or {}
	local result = YRP_NW_Globals["TABLE"][index]
	return result or def or {}
end

-- INIT
local sending = false
if SERVER then
	function SendDGlobals(ply)
		--if !sending then
			--sending = true

			ply:SetDInt("yrp_load_glo", 0)
			YRP_NW_Globals["BOOL"] = YRP_NW_Globals["BOOL"] or {}
			YRP_NW_Globals["STRING"] = YRP_NW_Globals["STRING"] or {}
			YRP_NW_Globals["INT"] = YRP_NW_Globals["INT"] or {}
			YRP_NW_Globals["FLOAT"] = YRP_NW_Globals["FLOAT"] or {}
			YRP_NW_Globals["TABLE"] = YRP_NW_Globals["TABLE"] or {}
		
			timer.Simple(1, function()
				for i, v in pairs(YRP_NW_Globals["BOOL"]) do
					SendGlobalDBool(i, v, ply)
				end
				ply:SetDInt("yrp_load_glo", 10)
			end)

			timer.Simple(2, function()
				for i, v in pairs(YRP_NW_Globals["STRING"]) do
					SendGlobalDString(i, v, ply)
				end
				ply:SetDInt("yrp_load_glo", 25)
			end)

			timer.Simple(3, function()
				for i, v in pairs(YRP_NW_Globals["INT"]) do
					SendGlobalDInt(i, v, ply)
				end
				ply:SetDInt("yrp_load_glo", 50)
			end)

			timer.Simple(4, function()
				for i, v in pairs(YRP_NW_Globals["FLOAT"]) do
					SendGlobalDFloat(i, v, ply)
				end
				ply:SetDInt("yrp_load_glo", 75)
			end)

			timer.Simple(5, function()
				for i, v in pairs(YRP_NW_Globals["TABLE"]) do
					SendGlobalDTable(i, v, ply)
				end
				ply:SetDInt("yrp_load_glo", 95)
			end)

			timer.Simple(6, function()
				ply:SetDInt("yrp_load_glo", 100)

				sending = false
			end)
		--else
			--timer.Simple(0.9, function()
				--SendDGlobals(ply)
			--end)
		--end
	end
end
