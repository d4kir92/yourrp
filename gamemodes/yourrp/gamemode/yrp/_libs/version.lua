--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

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

function YRPGetVersionValue( body, name)
	local keys = "*" .. name .. "*"
	local keye = "*/" .. name .. "*"
	local spos = string.find( body, keys, 1, false)
	if spos then
		local epos = string.find( body, keye, 1, false)
		if epos then
			return tonumber(string.sub( body, spos + string.len(keys) , epos - 1) )
		end
	end
	return 0
end

local test = {}
if CLIENT then
	net.Receive( "YRPGetServerInfo", function(len)
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

function YRPIsServerDedicated()
	return GetGlobalYRPBool( "isserverdedicated" )
end

function SetYRPChannel( from )
	if GAMEMODE != nil then
		if CLIENT then
			net.Start( "YRPGetServerInfo" )
			net.SendToServer()
		end
		http.Fetch( "https://docs.google.com/spreadsheets/d/e/2PACX-1vR3aN8b4y0qZbZBBQLkqBy4dKFzKCnPt4cOMp7ghUaq5Bzxf-BtlEc0fruUI18IK-csODjrK6wcpFCX/pubhtml?gid=0&single=true",
		function( body, len, headers, code)
			if body != nil then
				if code == 200 then
					local cs, ce = string.find( body, "VSTABLE" )
					if ce then
						body = string.sub( body, ce )
					end

					test["stable"] = {}
					test["stable"].stable = YRPGetVersionValue( body, "V" .. "STABLE" .. "STABLE" )
					test["stable"].beta = YRPGetVersionValue( body, "V" .. "STABLE" .. "BETA" )
					test["stable"].canary = YRPGetVersionValue( body, "V" .. "STABLE" .. "CANARY" )

					test["beta"] = {}
					test["beta"].stable = YRPGetVersionValue( body, "V" .. "BETA" .. "STABLE" )
					test["beta"].beta = YRPGetVersionValue( body, "V" .. "BETA" .. "BETA" )
					test["beta"].canary = YRPGetVersionValue( body, "V" .. "BETA" .. "CANARY" )

					test["canary"] = {}
					test["canary"].stable = YRPGetVersionValue( body, "V" .. "CANARY" .. "STABLE" )
					test["canary"].beta = YRPGetVersionValue( body, "V" .. "CANARY" .. "BETA" )
					test["canary"].canary = YRPGetVersionValue( body, "V" .. "CANARY" .. "CANARY" )

					for art, tab in pairs(test) do
						if tab.stable == GAMEMODE.VersionStable and tab.beta == GAMEMODE.VersionBeta and tab.canary == GAMEMODE.VersionCanary then
							YRP.msg( "gm", "Gamemode channel: " .. string.upper( art) )
							GAMEMODE.VersionSort = art
							break
						end
					end

					yrpversionisset = true
				else
					YRP.msg( "note", "SetYRPChannel Code: " .. code)
				end
			end
		end,
		function(error)
			YRP.msg( "note", "SetYRPChannel: " .. error)
			timer.Simple(1, function()
				SetYRPChannel( "RETRY ERROR" )
			end)
		end )
	else
		timer.Simple(2, function()
			SetYRPChannel( "RETRY GM" )
		end)
	end
end
SetYRPChannel( "Init" )

function YRPVersion()
	return GAMEMODE.Version .. ":" .. GAMEMODE.VersionBuild
end

function IsYRPOutdated()
	return yrpoutdated
end

function GetVersionColor()
	return GAMEMODE.versioncolor or Color( 255, 255, 255, 255 )
end

local on = {}
on.stable = -1
on.beta = -1
on.canary = -1

if CLIENT then
	-- CONFIG
	local check_window = 0
	-- CONFIG

	local once = false
	function VersionWindow()
		if once then return end
		once = true
		if check_window < CurTime() and LocalPlayer():HasAccess() then
			check_window = CurTime() + 5
			local frame = YRPCreateD( "YFrame", nil, YRP.ctr(1100), YRP.ctr(590), 0, 0)
			frame:Center()
			frame:SetHeaderHeight(YRP.ctr(100) )
			frame:SetTitle(YRP.lang_string( "LID_about" ) .. " ( " .. YRP.lang_string( "LID_visible" ) .. ": " .. YRP.lang_string( "LID_adminonly" ) .. " )" )
			function frame:Paint(pw, ph)
				if !IsYRPOutdated() then
					self:Remove()
				end
				hook.Run( "YFramePaint", self, pw, ph)
				--draw.RoundedBox(0, 0, 0, pw, ph, Color( 0, 0, 0, 200) )

				--surfaceWindow(self, pw, ph, YRP.lang_string( "LID_about" ) )
			end
			function frame.con:Paint(pw, ph)
				local tab = {}
				tab["yrp"] = "YourRP"
				draw.SimpleTextOutlined(YRP.lang_string( "LID_newyourrpversionavailable", tab), "Y_24_500", pw / 2, YRP.ctr(50), Color( 255, 255, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) )
				draw.SimpleTextOutlined(YRP.lang_string( "LID_currentversion" ) .. ":", "Y_24_500", pw / 2, YRP.ctr(100), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) )

				draw.SimpleTextOutlined(YRP.lang_string( "LID_client" ) .. ": ", "Y_24_500", pw / 2, YRP.ctr(150), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) )
				draw.SimpleTextOutlined(GAMEMODE.Version, "Y_24_500", pw / 2, YRP.ctr(150), GetVersionColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) )

				draw.SimpleTextOutlined( "( " .. string.upper(GAMEMODE.dedicated) .. " ) " .. YRP.lang_string( "LID_server" ) .. ": ", "Y_24_500", pw / 2, YRP.ctr(200), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) )
				draw.SimpleTextOutlined(GAMEMODE.VersionServer, "Y_24_500", pw / 2, YRP.ctr(200), GetVersionColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) )

				draw.SimpleTextOutlined(YRP.lang_string( "LID_workshopversion" ) .. ": ", "Y_24_500", pw / 2, YRP.ctr(300), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) )
				draw.SimpleTextOutlined(on.stable .. "." .. on.beta .. "." .. on.canary .. " ( " .. string.upper(GAMEMODE.VersionSort) .. " )", "Y_24_500", pw / 2, YRP.ctr(300), Color( 0, 255, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) )
			end

			local showChanges = YRPCreateD( "YButton", frame.con, YRP.ctr(500), YRP.ctr(80), frame.con:GetWide() / 2 - YRP.ctr(250), YRP.ctr(350) )
			showChanges:SetText( "LID_showchanges" )
			function showChanges:DoClick()
				gui.OpenURL( "http://steamcommunity.com/sharedfiles/filedetails/changelog/1114204152" )
			end
			function showChanges:Paint(pw, ph)
				hook.Run( "YButtonPaint", self, pw, ph)
			end

			frame:MakePopup()
		end
	end
end

local check = 0
function YRPCheckVersion(from)
	if GAMEMODE != nil then
		if YRPIsVersionSet() then
			if CurTime() < check then return end
			check = CurTime() + 1
			http.Fetch( "https://docs.google.com/spreadsheets/d/e/2PACX-1vR3aN8b4y0qZbZBBQLkqBy4dKFzKCnPt4cOMp7ghUaq5Bzxf-BtlEc0fruUI18IK-csODjrK6wcpFCX/pubhtml?gid=0&single=true",
			function( body, len, headers, code)
				if body != nil then
					if code == 200 then
						local serverart = string.upper(GAMEMODE.VersionSort)

						if serverart == "OUTDATED" then	
							GAMEMODE.versioncolor = YRPColGreen()	
							yrpoutdated = true	
							serverart = "CANARY"	
						else	
							yrpoutdated = false	
						end
						
						on.stable = YRPGetVersionValue( body, "V" .. serverart .. "STABLE" )
						on.beta = YRPGetVersionValue( body, "V" .. serverart .. "BETA" )
						on.canary = YRPGetVersionValue( body, "V" .. serverart .. "CANARY" )

						if on.stable == GAMEMODE.VersionStable and on.beta == GAMEMODE.VersionBeta and on.canary == GAMEMODE.VersionCanary then
							GAMEMODE.versioncolor = Color( 255, 255, 255, 255 )
							yrpoutdated = false
						else
							yrpoutdated = true
							GAMEMODE.versioncolor = YRPColGreen()
							if CLIENT then
								VersionWindow()
							end
						end
					else
						YRP.msg( "note", "[CheckVersion] CODE: " .. code)
					end
				end
			end,
				function(error)
					YRP.msg( "note", "[CheckVersion] ERROR: " .. error)
				end
			)
		else
			timer.Simple(4, function()
				SetYRPChannel( "CheckVersion" )
			end)
		end
	else
		timer.Simple(0.1, function()
			YRPCheckVersion( "retry GAMEMODE" )
		end)
	end
end

timer.Simple(1, function()
	YRPCheckVersion( "init" )
end)
