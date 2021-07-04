-- Networking

YRP_Global_Tables = YRP_Global_Tables or {}

if SERVER then
	util.AddNetworkString("YRPSetGlobalTable")
	util.AddNetworkString("YRPGetGlobalTables")
end

function GetGlobalTable(key, value)
	return YRP_Global_Tables[key] or value or {}
end

function SetGlobalTable(key, value)
	if type(key) == "string" and type(value) == "table" then
		YRP_Global_Tables[key] = value
		if SERVER then
			net.Start("YRPSetGlobalTable")
				net.WriteString(key)
				net.WriteTable(value)
			net.Broadcast()
		end
	else
		Msg(Color(255, 0, 0), ">>> SetGlobalTable FAILED", key, value)
	end
end

if SERVER then
	net.Receive("YRPGetGlobalTables", function(len, ply)
		for key, value in pairs(YRP_Global_Tables) do
			net.Start("YRPSetGlobalTable")
				net.WriteString(key)
				net.WriteTable(value)
			net.Send(ply)
		end
	end)
end

if CLIENT then
	net.Receive("YRPSetGlobalTable", function(len)
		local key = net.ReadString()
		local tab = net.ReadTable()

		SetGlobalTable(key, tab)
	end)

	hook.Add("PostGamemodeLoaded", "yrp_PostGamemodeLoaded_GlobalTable", function()
		net.Start("YRPGetGlobalTables")
		net.SendToServer()
	end)

	timer.Simple(2, function()
		net.Start("YRPGetGlobalTables")
		net.SendToServer()
	end)
end

