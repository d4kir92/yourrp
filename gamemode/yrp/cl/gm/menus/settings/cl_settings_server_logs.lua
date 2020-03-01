--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- #logs

function BuildLogsSite()
	if pa(settingsWindow.window) then

		local site = settingsWindow.window.site

		-- TABS
		local tabs = createD("YTabs", site, site:GetWide(), site:GetTall(), 0, 0)

		tabs:AddOption("LID_kills", function(parent)
			--Buildlogs(parent, tabW, tabR, tabG, "LID_all")
		end)
		tabs:AddOption("LID_health", function(parent)
			--Buildlogs(parent, tabW, tabR, tabG, "LID_all")
		end)
		tabs:AddOption("LID_chat", function(parent)
			--Buildlogs(parent, tabW, tabR, tabG, "LID_roles")
		end)
		tabs:AddOption("LID_commands", function(parent)
			--Buildlogs(parent, tabW, tabR, tabG, "LID_groups")
		end)
		tabs:AddOption("LID_arrests", function(parent)
			--Buildlogs(parent, tabW, tabR, tabG, "LID_manually")
		end)
		tabs:AddOption("LID_connections", function(parent)
			--Buildlogs(parent, tabW, tabR, tabG, "LID_promote")
		end)
		tabs:AddOption("LID_whitelist", function(parent)
			--Buildlogs(parent, tabW, tabR, tabG, "LID_promote")
		end)
		tabs:AddOption("LID_spawns", function(parent)
			--Buildlogs(parent, tabW, tabR, tabG, "LID_promote")
		end)

		tabs:GoToSite("LID_kills")		
	end
end

hook.Add("open_server_logs", "open_server_logs", function()
	SaveLastSite()
	local ply = LocalPlayer()

	BuildLogsSite()
end)