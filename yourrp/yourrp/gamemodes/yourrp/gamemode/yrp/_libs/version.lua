--Copyright (C) 2017-2025 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local _sv_outdated = nil
local _cl_outdated = nil
local _version_client = {}
local _version_server = {}
local yrpoutdated = false
local yrpversionisset = false
function YRPIsVersionSet()
	return yrpversionisset
end

local _version_online = {}
function YRPOnlineVersion()
	return _version_online
end

function YRPGetVersionValue(body, name)
	local keys = "*" .. name .. "*"
	local keye = "*/" .. name .. "*"
	local spos = string.find(body, keys, 1, true)
	if spos then
		local epos = string.find(body, keye, 1, true)
		if epos then return tonumber(string.sub(body, spos + string.len(keys), epos - 1)) end
	end

	return 0
end

if CLIENT then
	net.Receive(
		"YRPGetServerInfo",
		function(len)
			local tab = net.ReadTable()
			GAMEMODE.VersionServer = tostring(tab.Version) .. ":" .. tostring(tab.VersionBuild)
			GAMEMODE.ServerIsDedicated = tab.isdedicated
			if GAMEMODE.ServerIsDedicated then
				GAMEMODE.dedicated = "dedicated"
			else
				GAMEMODE.dedicated = "local"
			end
		end
	)
end

function YRPIsServerDedicated()
	return GetGlobalYRPBool("isserverdedicated")
end

function YRPGetVersionNumbers()
end

function SetYRPChannel(from)
	if GAMEMODE ~= nil then
		if CLIENT then
			net.Start("YRPGetServerInfo")
			net.SendToServer()
		end

		http.Fetch(
			"https://docs.google.com/spreadsheets/d/1UDF4f7ypJPdklQiz9y4KIU_s3EvjVAlaIk2ullezTCM",
			function(body, len, headers, code)
				if body ~= nil then
					if code == 200 then
						local cs, ce = string.find(body, "VSTABLE", 1, true)
						if ce then
							body = string.sub(body, cs - 1)
						end

						local tab = {}
						tab.stable = 0
						tab.beta = 0
						tab.canary = 0
						tab.build = 0
						local s = string.find(body, "*X", 1, true)
						local e = string.find(body, "/X", 1, true)
						if s and e then
							local version = string.sub(body, s + 2, e - 1)
							local t = string.Explode(".", version)
							tab.stable = tonumber(t[1])
							tab.beta = tonumber(t[2])
							tab.canary = tonumber(t[3])
							tab.build = tonumber(t[4])
						end

						if tab.stable == GAMEMODE.VersionStable and tab.beta == GAMEMODE.VersionBeta and tab.canary == GAMEMODE.VersionCanary and tab.build == GAMEMODE.VersionBuild then
							YRP:msg("gm", "Gamemode channel: " .. string.upper("stable"))
							GAMEMODE.VersionSort = "stable"
						end

						yrpversionisset = true
					else
						YRP:msg("note", "SetYRPChannel Code: " .. code)
					end
				end
			end,
			function(error)
				YRP:msg("note", "SetYRPChannel: " .. error)
				timer.Simple(
					1,
					function()
						SetYRPChannel("RETRY ERROR")
					end
				)
			end
		)
	else
		timer.Simple(
			2,
			function()
				SetYRPChannel("RETRY GM")
			end
		)
	end
end

SetYRPChannel("Init")
function YRPVersion()
	return GAMEMODE.Version .. ":" .. GAMEMODE.VersionBuild
end

function IsYRPOutdated()
	return yrpoutdated
end

function YRPGetVersionColor()
	return GAMEMODE.versioncolor or Color(255, 255, 255, 255)
end

local on = {}
on.stable = -1
on.beta = -1
on.canary = -1
on.build = -1
if CLIENT then
	-- CONFIG
	local check_window = 0
	-- CONFIG
	local once = false
	function VersionWindow()
		if once then return end
		once = true
		if check_window < CurTime() and LocalPlayer():HasAccess("version") then
			check_window = CurTime() + 5
			local frame = YRPCreateD("YFrame", nil, YRP:ctr(1100), YRP:ctr(590), 0, 0)
			frame:Center()
			frame:SetHeaderHeight(YRP:ctr(100))
			frame:SetTitle(YRP:trans("LID_about") .. " ( " .. YRP:trans("LID_visible") .. ": " .. YRP:trans("LID_adminonly") .. " )")
			function frame:Paint(pw, ph)
				if not IsYRPOutdated() then
					self:Remove()
				end

				hook.Run("YFramePaint", self, pw, ph)
			end

			function frame.con:Paint(pw, ph)
				local tab = {}
				tab["yrp"] = "YourRP"
				draw.SimpleTextOutlined(YRP:trans("LID_newyourrpversionavailable", tab), "Y_24_500", pw / 2, YRP:ctr(50), Color(255, 255, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				draw.SimpleTextOutlined(YRP:trans("LID_currentversion") .. ":", "Y_24_500", pw / 2, YRP:ctr(100), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				draw.SimpleTextOutlined(YRP:trans("LID_client") .. ": ", "Y_24_500", pw / 2, YRP:ctr(150), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				draw.SimpleTextOutlined(GAMEMODE.Version .. ":" .. GAMEMODE.VersionBuild, "Y_24_500", pw / 2, YRP:ctr(150), YRPGetVersionColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				draw.SimpleTextOutlined("( " .. string.upper(GAMEMODE.dedicated) .. " ) " .. YRP:trans("LID_server") .. ": ", "Y_24_500", pw / 2, YRP:ctr(200), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				draw.SimpleTextOutlined(GAMEMODE.VersionServer, "Y_24_500", pw / 2, YRP:ctr(200), YRPGetVersionColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				if GetGlobalYRPString("YRP_VERSIONART", "X") == "workshop" then
					draw.SimpleTextOutlined(YRP:trans("LID_workshopversion") .. ": ", "Y_24_500", pw / 2, YRP:ctr(300), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				else
					draw.SimpleTextOutlined(YRP:trans("LID_githubversion") .. ": ", "Y_24_500", pw / 2, YRP:ctr(300), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				end

				if on then
					draw.SimpleTextOutlined(on.stable .. "." .. on.beta .. "." .. on.canary .. ":" .. on.build .. " ( " .. string.upper(GAMEMODE.VersionSort) .. " )", "Y_24_500", pw / 2, YRP:ctr(300), Color(0, 255, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				end
			end

			local showChanges = YRPCreateD("YButton", frame.con, YRP:ctr(500), YRP:ctr(80), frame.con:GetWide() / 2 - YRP:ctr(250), YRP:ctr(350))
			showChanges:SetText("LID_showchanges")
			function showChanges:DoClick()
				gui.OpenURL("http://steamcommunity.com/sharedfiles/filedetails/changelog/1114204152")
			end

			function showChanges:Paint(pw, ph)
				hook.Run("YButtonPaint", self, pw, ph)
			end

			frame:MakePopup()
		end
	end
end

local yrp_check = yrp_check or 0
function YRPCheckVersion(from)
	if not YRPIsVersionSet() then
		timer.Simple(
			1,
			function()
				YRPCheckVersion("retry Version not set")
			end
		)

		return
	end

	if GAMEMODE == nil then
		timer.Simple(
			0.1,
			function()
				YRPCheckVersion("retry GAMEMODE")
			end
		)

		return
	end

	if CurTime() < yrp_check then return end
	yrp_check = CurTime() + 60
	http.Fetch(
		"https://docs.google.com/spreadsheets/d/1UDF4f7ypJPdklQiz9y4KIU_s3EvjVAlaIk2ullezTCM",
		function(body, len, headers, code)
			if body ~= nil then
				if code == 200 then
					local serverart = string.upper(GAMEMODE.VersionSort or "outdated")
					if serverart == "OUTDATED" then
						GAMEMODE.versioncolor = Color(0, 255, 0)
						yrpoutdated = true
						serverart = "CANARY"
					else
						yrpoutdated = false
					end

					local s = string.find(body, "*X", 1, true)
					local e = string.find(body, "/X", 1, true)
					if s and e then
						local version = string.sub(body, s + 2, e - 1)
						local t = string.Explode(".", version)
						on.stable = tonumber(t[1])
						on.beta = tonumber(t[2])
						on.canary = tonumber(t[3])
						on.build = tonumber(t[4])
					end

					if on.stable == GAMEMODE.VersionStable and on.beta == GAMEMODE.VersionBeta and on.canary == GAMEMODE.VersionCanary and on.build == GAMEMODE.VersionBuild then
						GAMEMODE.versioncolor = Color(255, 255, 255, 255)
						yrpoutdated = false
					else
						yrpoutdated = true
						GAMEMODE.versioncolor = Color(0, 255, 0)
						if CLIENT then
							VersionWindow()
						else
							if GetGlobalYRPString("YRP_VERSIONART", "X") == "workshop" then
								MsgC(Color(255, 255, 0), "[CheckVersion] YOURRP IS OUTDATED, PLEASE RESTART SERVER", "\n")
							else
								MsgC(Color(255, 255, 0), "[CheckVersion] YOURRP IS OUTDATED, PLEASE DOWNLOAD LATEST AND RESTART SERVER", "\n")
							end

							MsgC(Color(255, 0, 0), string.format("[CheckVersion] NEW VERSION: %s.%s.%s:%s OLD VERSION: %s.%s.%s:%s", on.stable, on.beta, on.canary, on.build, GAMEMODE.VersionStable, GAMEMODE.VersionBeta, GAMEMODE.VersionCanary, GAMEMODE.VersionBuild), "\n")
						end
					end
				else
					YRP:msg("note", "[CheckVersion] CODE: " .. code)
				end
			else
				YRP:msg("note", "[CheckVersion] BODY not found")
			end
		end,
		function(error)
			YRP:msg("note", "[CheckVersion] ERROR: " .. error)
		end
	)
end

timer.Simple(
	1,
	function()
		YRPCheckVersion("init")
	end
)
