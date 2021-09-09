--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local HANDLER_STATUS = {}

function RemFromHandler_Console(ply)
	table.RemoveByValue(HANDLER_STATUS, ply)
	YRP.msg("gm", ply:YRPName() .. " disconnected from Console")
end

function AddToHandler_Console(ply)
	if !table.HasValue(HANDLER_STATUS, ply) then
		table.insert(HANDLER_STATUS, ply)
		YRP.msg("gm", ply:YRPName() .. " connected to Console")
	else
		YRP.msg("gm", ply:YRPName() .. " already connected to Console")
	end
end

util.AddNetworkString("Connect_Settings_Console")
net.Receive("Connect_Settings_Console", function(len, ply)
	if ply:CanAccess("bool_console") then
		AddToHandler_Console(ply)

		net.Start("Connect_Settings_Console")
		net.Send(ply)
	end
end)

util.AddNetworkString("Disconnect_Settings_Console")
net.Receive("Disconnect_Settings_Console", function(len, ply)
	RemFromHandler_Console(ply)
end)

util.AddNetworkString("get_console_line")
function AddToFakeServerConsole(str)
	for i, pl in pairs(HANDLER_STATUS) do
		net.Start("get_console_line")
			net.WriteString(str)
		net.Send(pl)
	end
end

util.AddNetworkString("send_console_command")
net.Receive("send_console_command", function(len, ply)
	local command = net.ReadString()
	if ply:HasAccess() and command != "" then
		YRP.msg("note", ply:YRPName() .. " send command: " .. command)
		game.ConsoleCommand(command .. "\n")
	end
end)
