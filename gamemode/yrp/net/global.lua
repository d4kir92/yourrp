-- Networking

YRP_NW_Globals = YRP_NW_Globals or {}
YRP_QUEUE_Globals = YRP_QUEUE_Globals or {}

-- Delay when traffic
local NETDELAY = 0.002

-- Delay when no traffic but wrong entry
local RETDELAY = 0.001

-- BOOL
if SERVER then
	YRP_QUEUE_Globals["BOOL"] = YRP_QUEUE_Globals["BOOL"] or {}
	util.AddNetworkString("SetGlobalDBool")

	function SendGlobalDBool(index, bo, ply)
		if table.HasValue(YRP_QUEUE_Globals["BOOL"], index) then
			table.RemoveByValue(YRP_QUEUE_Globals["BOOL"], index)
			table.insert(YRP_QUEUE_Globals["BOOL"], 1, index)
		else
			table.insert(YRP_QUEUE_Globals["BOOL"], index)
		end

		if net.BytesLeft() == nil and net.BytesWritten() == nil then
			-- If no traffic
			if index == YRP_QUEUE_Globals["BOOL"][1] then
				net.Start("SetGlobalDBool")
					net.WriteString(index)
					net.WriteBool(bo)
				if IsValid(ply) then
					net.Send(ply)
				else
					net.Broadcast()
				end
				table.RemoveByValue(YRP_QUEUE_Globals["BOOL"], index)
			else
				-- RETRY if not first entry
				timer.Simple(RETDELAY, function()
					SendGlobalDBool(index, bo, ply)
				end)
			end
		else
			-- RETRY later when no traffic
			timer.Simple(NETDELAY, function()
				SendGlobalDBool(index, bo, ply)
			end)
		end
	end
end
function SetGlobalDBool(index, bo)
	if index != nil or bo != nil then
		YRP_NW_Globals["BOOL"] = YRP_NW_Globals["BOOL"] or {}
		if YRP_NW_Globals["BOOL"][index] != bo or YRP_NW_Globals["BOOL"][index] == nil then
			YRP_NW_Globals["BOOL"][index] = bo
			if SERVER then
				SendGlobalDBool(index, bo)
			end
		end
	else
		YRP.msg("error", "SetGlobalDBool index " .. tostring(index) .. " bo " .. tostring(bo))
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
	YRP_QUEUE_Globals["STRING"] = YRP_QUEUE_Globals["STRING"] or {}
	util.AddNetworkString("SetGlobalDString")

	function SendGlobalDString(index, str, ply)
		if table.HasValue(YRP_QUEUE_Globals["STRING"], index) then
			table.RemoveByValue(YRP_QUEUE_Globals["STRING"], index)
			table.insert(YRP_QUEUE_Globals["STRING"], 1, index)
		else
			table.insert(YRP_QUEUE_Globals["STRING"], index)
		end

		if net.BytesLeft() == nil and net.BytesWritten() == nil then
			-- If no traffic
			if index == YRP_QUEUE_Globals["STRING"][1] then
				net.Start("SetGlobalDString")
					net.WriteString(index)
					net.WriteString(str)
				if IsValid(ply) then
					net.Send(ply)
				else
					net.Broadcast()
				end
				table.RemoveByValue(YRP_QUEUE_Globals["STRING"], index)
			else
				-- RETRY if not first entry
				timer.Simple(RETDELAY, function()
					SendGlobalDString(index, str, ply)
				end)
			end
		else
			-- RETRY later when no traffic
			timer.Simple(NETDELAY, function()
				SendGlobalDString(index, str, ply)
			end)
		end
	end
end
function SetGlobalDString(index, str)
	if index != nil or str != nil then
		YRP_NW_Globals["STRING"] = YRP_NW_Globals["STRING"] or {}
		if YRP_NW_Globals["STRING"][index] != str or YRP_NW_Globals["STRING"][index] == nil then
			YRP_NW_Globals["STRING"][index] = str
			if SERVER then
				SendGlobalDString(index, str)
			end
		end
	else
		YRP.msg("error", "SetGlobalDString index " .. tostring(index) .. " str " .. tostring(str))
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
	YRP_QUEUE_Globals["INT"] = YRP_QUEUE_Globals["INT"] or {}
	util.AddNetworkString("SetGlobalDInt")

	function SendGlobalDInt(index, int, ply)
		if table.HasValue(YRP_QUEUE_Globals["INT"], index) then
			table.RemoveByValue(YRP_QUEUE_Globals["INT"], index)
			table.insert(YRP_QUEUE_Globals["INT"], 1, index)
		else
			table.insert(YRP_QUEUE_Globals["INT"], index)
		end

		if net.BytesLeft() == nil and net.BytesWritten() == nil then
			-- If no traffic
			if index == YRP_QUEUE_Globals["INT"][1] then
				net.Start("SetGlobalDInt")
					net.WriteString(index)
					net.WriteInt(int, 32)
				if IsValid(ply) then
					net.Send(ply)
				else
					net.Broadcast()
				end
				table.RemoveByValue(YRP_QUEUE_Globals["INT"], index)
			else
				-- RETRY if not first entry
				timer.Simple(RETDELAY, function()
					SendGlobalDInt(index, int, ply)
				end)
			end
		else
			-- RETRY later when no traffic
			timer.Simple(NETDELAY, function()
				SendGlobalDInt(index, int, ply)
			end)
		end
	end
end
function SetGlobalDInt(index, int)
	if index != nil or int != nil then
		YRP_NW_Globals["INT"] = YRP_NW_Globals["INT"] or {}
		if YRP_NW_Globals["INT"][index] != int or YRP_NW_Globals["INT"][index] == nil then
			YRP_NW_Globals["INT"][index] = tonumber(int)
			if SERVER then
				SendGlobalDInt(index, int)
			end
		end
	else
		YRP.msg("error", "SetGlobalDInt index " .. tostring(index) .. " int " .. tostring(int))
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
	YRP_QUEUE_Globals["FLOAT"] = YRP_QUEUE_Globals["FLOAT"] or {}
	util.AddNetworkString("SetGlobalDFloat")

	function SendGlobalDFloat(index, flo, ply)
		if table.HasValue(YRP_QUEUE_Globals["FLOAT"], index) then
			table.RemoveByValue(YRP_QUEUE_Globals["FLOAT"], index)
			table.insert(YRP_QUEUE_Globals["FLOAT"], 1, index)
		else
			table.insert(YRP_QUEUE_Globals["FLOAT"], index)
		end

		if net.BytesLeft() == nil and net.BytesWritten() == nil then
			-- If no traffic
			if index == YRP_QUEUE_Globals["FLOAT"][1] then
				net.Start("SetGlobalDFloat")
					net.WriteString(index)
					net.WriteFloat(flo)
				if IsValid(ply) then
					net.Send(ply)
				else
					net.Broadcast()
				end
				table.RemoveByValue(YRP_QUEUE_Globals["FLOAT"], index)
			else
				-- RETRY if not first entry
				timer.Simple(RETDELAY, function()
					SendGlobalDFloat(index, flo, ply)
				end)
			end
		else
			-- RETRY later when no traffic
			timer.Simple(NETDELAY, function()
				SendGlobalDFloat(index, flo, ply)
			end)
		end
	end
end
function SetGlobalDFloat(index, flo)
	if index != nil or flo != nil then
		YRP_NW_Globals["FLOAT"] = YRP_NW_Globals["FLOAT"] or {}
		if YRP_NW_Globals["FLOAT"][index] != flo or YRP_NW_Globals["FLOAT"][index] == nil then
			YRP_NW_Globals["FLOAT"][index] = flo
			if SERVER then
				SendGlobalDFloat(index, flo)
			end
		end
	else
		YRP.msg("error", "SetGlobalDFloat index " .. tostring(index) .. " flo " .. tostring(flo))
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
	YRP_QUEUE_Globals["TABLE"] = YRP_QUEUE_Globals["TABLE"] or {}
	util.AddNetworkString("SetGlobalDTable")

	function SendGlobalDTable(index, tab, ply)
		if table.HasValue(YRP_QUEUE_Globals["TABLE"], index) then
			table.RemoveByValue(YRP_QUEUE_Globals["TABLE"], index)
			table.insert(YRP_QUEUE_Globals["TABLE"], 1, index)
		else
			table.insert(YRP_QUEUE_Globals["TABLE"], index)
		end

		if net.BytesLeft() == nil and net.BytesWritten() == nil then
			-- If no traffic
			if index == YRP_QUEUE_Globals["TABLE"][1] then
				net.Start("SetGlobalDTable")
					net.WriteString(index)
					net.WriteTable(tab)
				if IsValid(ply) then
					net.Send(ply)
				else
					net.Broadcast()
				end
				table.RemoveByValue(YRP_QUEUE_Globals["TABLE"], index)
			else
				-- RETRY if not first entry
				timer.Simple(RETDELAY, function()
					SendGlobalDTable(index, tab, ply)
				end)
			end
		else
			-- RETRY later when no traffic
			timer.Simple(NETDELAY, function()
				SendGlobalDTable(index, tab, ply)
			end)
		end
	end
end
function SetGlobalDTable(index, tab)
	if index != nil or tab != nil then
		YRP_NW_Globals["TABLE"] = YRP_NW_Globals["TABLE"] or {}
		if YRP_NW_Globals["TABLE"][index] != tab or YRP_NW_Globals["TABLE"][index] == nil then
			YRP_NW_Globals["TABLE"][index] = tab
			if SERVER then
				SendGlobalDTable(index, tab)
			end
		end
	else
		YRP.msg("error", "SetGlobalDTable index " .. tostring(index) .. " tab " .. tostring(tab))
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
		ply:SetDInt("yrp_load_glo", 0)
		YRP_NW_Globals["BOOL"] = YRP_NW_Globals["BOOL"] or {}
		YRP_NW_Globals["STRING"] = YRP_NW_Globals["STRING"] or {}
		YRP_NW_Globals["INT"] = YRP_NW_Globals["INT"] or {}
		YRP_NW_Globals["FLOAT"] = YRP_NW_Globals["FLOAT"] or {}
		YRP_NW_Globals["TABLE"] = YRP_NW_Globals["TABLE"] or {}

		local interval = 4
		local ti = 0

		timer.Simple(ti, function()
			for i, v in pairs(YRP_NW_Globals["BOOL"]) do
				SendGlobalDBool(i, v, ply)
			end
			ply:SetDInt("yrp_load_glo", 15)
		end)
		
		ti = ti + interval
		timer.Simple(ti, function()
			for i, v in pairs(YRP_NW_Globals["STRING"]) do
				SendGlobalDString(i, v, ply)
			end
			ply:SetDInt("yrp_load_glo", 30)
		end)

		ti = ti + interval
		timer.Simple(ti, function()
			for i, v in pairs(YRP_NW_Globals["INT"]) do
				SendGlobalDInt(i, v, ply)
			end
			ply:SetDInt("yrp_load_glo", 45)
		end)

		ti = ti + interval
		timer.Simple(ti, function()
			for i, v in pairs(YRP_NW_Globals["FLOAT"]) do
				SendGlobalDFloat(i, v, ply)
			end
			ply:SetDInt("yrp_load_glo", 60)
		end)

		ti = ti + interval
		timer.Simple(ti, function()
			for i, v in pairs(YRP_NW_Globals["TABLE"]) do
				SendGlobalDTable(i, v, ply)
			end
			ply:SetDInt("yrp_load_glo", 75)
		end)

		ti = ti + interval
		timer.Simple(ti, function()
			ply:SetDInt("yrp_load_glo", 100)

			sending = false
		end)
	end
end
