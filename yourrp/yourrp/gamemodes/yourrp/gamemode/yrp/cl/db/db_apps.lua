--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local _type = type
--[[ APP ]]
--
local APP = {}
function APP:Init()
	self:SetText("")
end

function APP:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0, 255))
	draw.SimpleTextOutlined("NO", "HudHintTextSmall", w / 2, h / 3, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctrb(1), Color(0, 0, 0, 255))
	draw.SimpleTextOutlined("ICON", "HudHintTextSmall", w / 2, h * 2 / 3, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctrb(1), Color(0, 0, 0, 255))
end

vgui.Register("YRPAPP", APP, "DButton")
function appSize()
	return 64
end

function addApp(app)
	if app == nil then
		YRP.msg("note", "[addApp] -> app is missing!")
	end

	if _type(app) == "table" then
		if app.PrintName == nil then
			YRP.msg("note", "[addApp] -> app.PrintName is missing!")
		end

		if app.ClassName == nil then
			YRP.msg("note", "[addApp] -> app.ClassName is missing!")
		end

		if app.OpenApp == nil then
			YRP.msg("note", "[addApp] -> function app:OpenApp is missing!")
		end

		YRP.msg("db", "[addApp] Add App: " .. tostring(app.PrintName) .. " [" .. tostring(app.ClassName) .. "]")
		list.Add("yrp_apps", app)
	else
		YRP.msg("note", "[addApp] -> Wrong Parameters!")
	end
end

function getAllApps()
	return list.Get("yrp_apps")
end

--yrp_apps
function createApp(app, parent, x, y)
	local _tmp = YRPCreateD("YRPAPP", parent, ctrb(64), ctrb(64), x, y)
	_tmp.tbl = app
	_tmp.oldpaint = _tmp.Paint
	function _tmp:Paint(pw, ph)
		if app.AppIcon == nil then
			self:oldpaint(pw, ph)
		else
			app:AppIcon(pw, ph)
		end
	end

	_tmp.olddoclick = _tmp.DoClick
	function _tmp:DoClick()
		if app.OpenApp == nil then
			self:olddoclick()
		else
			parent:ClearDisplay()
			if app.Fullscreen then
				parent:OpenFullscreen()
			end

			app:OpenApp(parent, 0, ctrb(40), parent:GetWide(), parent:GetTall() - ctrb(40 + 40))
		end
	end

	_tmp:Droppable("APP")

	return _tmp
end

--[[ Database ]]
--
local YRP_APPS = {}
local yrp_apps = {}
local dbfile = "yrp_apps/yrp_apps.json"
function YRPAppsMSG(msg)
	MsgC(Color(0, 255, 0), "[YourRP] [TUTORIALS] " .. msg .. "\n")
end

function YRPAppsCheckFile()
	if not file.Exists("yrp_apps", "DATA") then
		YRPAppsMSG("Created Apps Folder")
		file.CreateDir("yrp_apps")
	end

	if not file.Exists(dbfile, "DATA") then
		YRPAppsMSG("Created New Apps File")
		file.Write(dbfile, util.TableToJSON(YRP_APPS, true))
	end
end

function YRPAppsLoad()
	YRPAppsCheckFile()
	YRPAppsMSG("Load Apps")
	local fil = file.Read(dbfile, "DATA")
	if fil then
		yrp_apps = util.JSONToTable(fil)
	else
		YRP.msg("note", "APPS BROKEN?")
	end
end

function YRPAppsSave()
	YRPAppsCheckFile()
	YRPAppsMSG("Save Apps")
	file.Write(dbfile, util.TableToJSON(yrp_apps, true))
end

function changeAppPosition(cname, nr)
	yrp_apps[cname]["Position"] = nr
	YRPAppsSave()
end

function YRPGetAppAtPosition(pos)
	for i, v in pairs(yrp_apps) do
		if pos == v.Position then return v end
	end

	return nil
end

function getAllDBApps()
	for i, app in pairs(getAllApps()) do
		local _sel = yrp_apps[app.ClassName]
		if _sel == nil then
			local _pos = 1
			for id = 0, 200 do
				local _p = YRPGetAppAtPosition(id)
				if _p == nil then
					_pos = id
					break
				end
			end

			yrp_apps[tostring(app.ClassName)] = {}
			yrp_apps[tostring(app.ClassName)]["ClassName"] = tostring(app.ClassName)
			yrp_apps[tostring(app.ClassName)]["Position"] = _pos
		end
	end

	local apps = {}
	for i, app in pairs(yrp_apps) do
		local _app = nil
		for j, a in pairs(getAllApps()) do
			if a.ClassName == app.ClassName then
				_app = a
				_app.Position = app.Position
				break
			end
		end

		table.insert(apps, app.Position, _app)
	end

	return apps
end

function YRPCheckApps()
	YRPAppsLoad()
end

YRPCheckApps()