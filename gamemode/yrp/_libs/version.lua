--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local _sv_outdated = nil
local _cl_outdated = nil
local _version_client = {}
local _version_server = {}

local _version_online = {}
function YRPOnlineVersion()
	return _version_online
end

function GetValue(body, name)
	local keys = "*" .. name .. "*"
	local keye = "*/" .. name .. "*"
	local spos = string.find(body, keys, 1, false)
	local epos = string.find(body, keye, 1, false)
	return tonumber(string.sub(body, spos + string.len(keys) , epos - 1))
end

local test = {}
if CLIENT then
	net.Receive("GetServerInfo", function(len)
		local tab = net.ReadTable()

		GAMEMODE.VersionServer = tostring(tab.Version)
		GAMEMODE.ServerIsDedicated = tab.isdedicated
		if GAMEMODE.ServerIsDedicated then
			GAMEMODE.dedicated = "dedicated"
		else
			GAMEMODE.dedicated = "local"
		end
	end)
end

function IsServerDedicated()
	return GAMEMODE.ServerIsDedicated
end

function SetYRPChannel()
	if GAMEMODE != nil then
		if CLIENT then
			net.Start("GetServerInfo")
			net.SendToServer()
		end
		http.Fetch("https://docs.google.com/spreadsheets/d/1ImHeLchvq2D_1DJHrHepF3WuncxIU4N431pzXOLNr8M/edit?usp=sharing",
		function(body, len, headers, code)
			if body != nil then
				test["stable"] = {}
				test["stable"].stable = GetValue(body, "V" .. "STABLE" .. "STABLE")
				test["stable"].beta = GetValue(body, "V" .. "STABLE" .. "BETA")
				test["stable"].canary = GetValue(body, "V" .. "STABLE" .. "CANARY")

				test["beta"] = {}
				test["beta"].stable = GetValue(body, "V" .. "BETA" .. "STABLE")
				test["beta"].beta = GetValue(body, "V" .. "BETA" .. "BETA")
				test["beta"].canary = GetValue(body, "V" .. "BETA" .. "CANARY")

				test["canary"] = {}
				test["canary"].stable = GetValue(body, "V" .. "CANARY" .. "STABLE")
				test["canary"].beta = GetValue(body, "V" .. "CANARY" .. "BETA")
				test["canary"].canary = GetValue(body, "V" .. "CANARY" .. "CANARY")

				for art, tab in pairs(test) do
					if tab.stable == GAMEMODE.VersionStable and tab.beta == GAMEMODE.VersionBeta and tab.canary == GAMEMODE.VersionCanary then
						printGM("gm", "Gamemode channel: " .. string.upper(art))
						GAMEMODE.VersionSort = art
						break
					end
				end
				GAMEMODE.VersionSortWasSet = true
			end
		end,
			function(error)
				printGM("note", "SetYRPChannel: " .. error)
				timer.Simple(1, function()
					SetYRPChannel()
				end)
			end
		)
	else
		timer.Simple(2, function()
			SetYRPChannel()
		end)
	end
end
SetYRPChannel()

function YRPVersion()
	return GAMEMODE.Version
end

function IsYRPOutdated()
	return GAMEMODE.isoutdated or false
end

function GetVersionColor()
	return GAMEMODE.versioncolor or Color(255, 255, 0)
end

local on = {}
on.stable = -1
on.beta = -1
on.canary = -1

if CLIENT then
	local check_window = 0
	function VersionWindow()
		if CurTime() < check_window then return end
		check_window = CurTime() + 5
		local frame = createVGUI("YFrame", nil, 1200, 570, 0, 0)
		frame:Center()
		frame:SetTitle("LID_about")
		function frame:Paint(pw, ph)
			if !IsYRPOutdated() then
				self:Remove()
			end
			hook.Run("YFramePaint", self, pw, ph)
			--draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 200))

			--surfaceWindow(self, pw, ph, YRP.lang_string("LID_about"))

			draw.SimpleTextOutlined("Language:", "HudBars", ctr(400), ctr(50 + 30), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			local tab = {}
			tab["yrp"] = "YourRP"
			draw.SimpleTextOutlined(YRP.lang_string("LID_newyourrpversionavailable", tab), "HudBars", pw / 2, ctr(140), Color(255, 255, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			draw.SimpleTextOutlined(YRP.lang_string("LID_currentversion") .. ":", "HudBars", pw / 2, ctr(215), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))

			draw.SimpleTextOutlined(YRP.lang_string("LID_client") .. ": ", "HudBars", pw / 2, ctr(265), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			draw.SimpleTextOutlined(GAMEMODE.Version, "HudBars", pw / 2, ctr(265), GetVersionColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))

			draw.SimpleTextOutlined("(" .. string.upper(GAMEMODE.dedicated) .. ") " .. YRP.lang_string("LID_server") .. ": ", "HudBars", pw / 2, ctr(315), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			draw.SimpleTextOutlined(GAMEMODE.VersionServer, "HudBars", pw / 2, ctr(315), GetVersionColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))

			draw.SimpleTextOutlined(YRP.lang_string("LID_workshopversion") .. ": ", "HudBars", pw / 2, ctr(415), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			draw.SimpleTextOutlined(on.stable .. "." .. on.beta .. "." .. on.canary .. " (" .. string.upper(GAMEMODE.VersionSort) .. ")", "HudBars", pw / 2, ctr(415), Color(0, 255, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		end

		local _langu = YRP.DChangeLanguage(frame, ctr(400 + 10), ctr(60), ctr(72))

		local showChanges = createVGUI("YButton", frame, 520, 80, 0, 0)
		showChanges:SetText("LID_showchanges")
		function showChanges:DoClick()
			gui.OpenURL("http://steamcommunity.com/sharedfiles/filedetails/changelog/1114204152")
		end
		function showChanges:Paint(pw, ph)
			hook.Run("YButtonPaint", self, pw, ph) -- surfaceButton(self, pw, ph, YRP.lang_string("LID_showchanges"))
		end

		if LocalPlayer():HasAccess() then
			if VERSIONART == "workshop" then
				local restartServer = createVGUI("DPanel", frame, 520, 80, 0, 0)
				restartServer:SetText("")
				function restartServer:DoClick()
					net.Start("restartServer")
					net.SendToServer()
				end
				function restartServer:Paint(pw, ph)
					surfacePanel(self, pw, ph, "Restart server, for update.") --YRP.lang_string("LID_updateserver"))
				end
				restartServer:SetPos(ctr(600 + 10), ctr(460))
			else
				local download_latest_git = createVGUI("YButton", frame, 520, 80, 0, 0)
				download_latest_git:SetText("LID_downloadlatestversion")
				function download_latest_git:DoClick()
					gui.OpenURL("https://github.com/d4kir92/GMOD-YourRP-unstable")
				end
				function download_latest_git:Paint(pw, ph)
					hook.Run("YButtonPaint", self, pw, ph) -- surfaceButton(self, pw, ph, YRP.lang_string("LID_downloadlatestversion"))
				end
				download_latest_git:SetPos(ctr(600 + 10), ctr(460))
			end
			showChanges:SetPos(ctr(600-520-10), ctr(460))
		else
			showChanges:SetPos(ctr(600-230), ctr(460))
		end

		frame:MakePopup()
	end
end

local check = 0
function YRPCheckVersion()
	if GAMEMODE != nil then
		if GAMEMODE.VersionSortWasSet then
			if CurTime() < check then return end
			check = CurTime() + 1
			http.Fetch("https://docs.google.com/spreadsheets/d/1ImHeLchvq2D_1DJHrHepF3WuncxIU4N431pzXOLNr8M/edit?usp=sharing",
			function(body, len, headers, code)
				if body != nil then
					local serverart = string.upper(GAMEMODE.VersionSort)

					if serverart == "OUTDATED" then
						GAMEMODE.versioncolor = Color(255, 0, 0)
						GAMEMODE.isoutdated = true
						if CLIENT then
							VersionWindow()
						end
						serverart = "CANARY"
					else
						GAMEMODE.isoutdated = false
					end

					on.stable = GetValue(body, "V" .. serverart .. "STABLE")
					on.beta = GetValue(body, "V" .. serverart .. "BETA")
					on.canary = GetValue(body, "V" .. serverart .. "CANARY")

					if on.stable == GAMEMODE.VersionStable and on.beta == GAMEMODE.VersionBeta and on.canary == GAMEMODE.VersionCanary then
						GAMEMODE.versioncolor = Color(0, 255, 0)
					else
						GAMEMODE.versioncolor = Color(255, 0, 0)
						if CLIENT then
							VersionWindow()
						end
					end
				end
			end,
				function(error)
					--
				end
			)
		else
			timer.Simple(4, function()
				SetYRPChannel()
			end)
		end
	else
		timer.Simple(5, function()
			YRPCheckVersion()
		end)
	end
end
YRPCheckVersion()
