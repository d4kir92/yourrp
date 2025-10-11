--Copyright (C) 2017-2025 D4KiR (https://www.gnu.org/licenses/gpl.txt)
if SERVER then
	hook.Add(
		"PostGamemodeLoaded",
		"yrp_PostGamemodeLoaded",
		function()
			RunConsoleCommand("sv_hibernate_think", 1)
			timer.Simple(
				2,
				function()
					MsgC(Color(255, 255, 0), ">>> Server is online <<<" .. "\t\t\tYourRP Version: " .. YRPGetVersionFull() .. "\n")
				end
			)

			timer.Simple(10, YRPSendServerInfo)
		end
	)
end
