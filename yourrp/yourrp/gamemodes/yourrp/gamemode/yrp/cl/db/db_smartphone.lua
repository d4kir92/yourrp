--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local _type = type
local YRP_SMARTPHONE = {}
YRP_SMARTPHONE["color_back"] = Color(0, 0, 0, 255)
YRP_SMARTPHONE["color_case"] = Color(0, 0, 0, 255)
local yrp_smartphone = {}
local dbfile = "yrp_smartphone/yrp_smartphone.json"
function YRPSmartphoneMSG(msg, col)
	local color = col or Color(0, 255, 0)
	MsgC(color, "[YourRP] [SMARTPHONE] " .. msg .. "\n")
end

function YRPSmartphoneCheckFile()
	if not file.Exists("yrp_smartphone", "DATA") then
		YRPSmartphoneMSG("Created Tutorial Folder")
		file.CreateDir("yrp_smartphone")
	end

	if not file.Exists(dbfile, "DATA") then
		YRPSmartphoneMSG("Created New Tutorial File")
		file.Write(dbfile, util.TableToJSON(YRP_SMARTPHONE, true))
	end
end

function YRPSmartphoneLoad()
	YRPSmartphoneCheckFile()
	YRPSmartphoneMSG("Load Smartphone")
	if file.Exists(dbfile, "DATA") then
		yrp_smartphone = util.JSONToTable(file.Read(dbfile, "DATA"))
		for i, v in pairs(yrp_smartphone) do
			yrp_smartphone[i] = YRPTableToColor(v)
		end
	else
		YRPSmartphoneMSG("FAILED TO LOAD SMARTPHONE COLORS", Color(0, 255, 0))
	end
end

function YRPSmartphoneSave()
	YRPSmartphoneCheckFile()
	YRPSmartphoneMSG("Save Smartphone")
	file.Write(dbfile, util.TableToJSON(yrp_smartphone, true))
end

function setSpBackColor(color)
	yrp_smartphone["color_back"] = color
	YRPSmartphoneSave()
end

function YRPGetSpBackColor()
	if yrp_smartphone["color_back"] ~= nil and _type(yrp_smartphone["color_back"]) == "table" then
		return yrp_smartphone["color_back"]
	else
		return Color(255, 0, 0, 255)
	end
end

function setSpCaseColor(color)
	yrp_smartphone["color_case"] = color
	YRPSmartphoneSave()
end

function YRPGetSpCaseColor()
	if yrp_smartphone["color_case"] ~= nil and _type(yrp_smartphone["color_case"]) == "table" then
		return yrp_smartphone["color_case"]
	else
		return Color(255, 0, 0, 255)
	end
end

function YRPCheckSmartphone()
	YRPSmartphoneLoad()
end

YRPCheckSmartphone()