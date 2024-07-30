--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
DarkRP = DarkRP or {}
DarkRP.disabledDefaults = DarkRP.disabledDefaults or {}
DarkRP.disabledDefaults.modules = DarkRP.disabledDefaults.modules or {}
DarkRP.hooks = {}
function DarkRP.stub()
end

function DarkRP.hookStub()
end

DarkRP.disabledDefaults["modules"] = {
	["afk"] = true,
	["chatsounds"] = false,
	["events"] = false,
	["fpp"] = false,
	["hitmenu"] = false,
	["hud"] = false,
	["hungermod"] = true,
	["playerscale"] = false,
	["sleep"] = false,
}

DarkRP.disabledDefaults["jobs"] = {
	["chief"] = false,
	["citizen"] = false,
	["cook"] = false, --Hungermod only
	["cp"] = false,
	["gangster"] = false,
	["gundealer"] = false,
	["hobo"] = false,
	["mayor"] = false,
	["medic"] = false,
	["mobboss"] = false,
}

DarkRP.disabledDefaults["shipments"] = {
	["AK47"] = false,
	["Desert eagle"] = false,
	["Fiveseven"] = false,
	["Glock"] = false,
	["M4"] = false,
	["Mac 10"] = false,
	["MP5"] = false,
	["P228"] = false,
	["Pump shotgun"] = false,
	["Sniper rifle"] = false,
}

DarkRP.disabledDefaults["entities"] = {
	["Drug lab"] = false,
	["Gun lab"] = false,
	["Money printer"] = false,
	["Microwave"] = false, --Hungermod only
	["Tip Jar"] = false,
}

DarkRP.disabledDefaults["vehicles"] = {}
DarkRP.disabledDefaults["food"] = {
	["Banana"] = false,
	["Bunch of bananas"] = false,
	["Melon"] = false,
	["Glass bottle"] = false,
	["Pop can"] = false,
	["Plastic bottle"] = false,
	["Milk"] = false,
	["Bottle 1"] = false,
	["Bottle 2"] = false,
	["Bottle 3"] = false,
	["Orange"] = false,
}

DarkRP.disabledDefaults["doorgroups"] = {
	["Cops and Mayor only"] = false,
	["Gundealer only"] = false,
}

DarkRP.disabledDefaults["ammo"] = {
	["Pistol ammo"] = false,
	["Rifle ammo"] = false,
	["Shotgun ammo"] = false,
}

DarkRP.disabledDefaults["agendas"] = {
	["Gangster's agenda"] = false,
	["Police agenda"] = false,
}

DarkRP.disabledDefaults["groupchat"] = {
	[1] = false, -- Police group chat (mayor, cp, chief and/or your custom CP teams)
	[2] = false, -- Group chat between gangsters and the mobboss
	[3] = false,
}

DarkRP.disabledDefaults["hitmen"] = {
	["mobboss"] = false,
}

DarkRP.disabledDefaults["demotegroups"] = {
	["Cops"] = false,
	["Gangsters"] = false,
}

DarkRP.disabledDefaults["workarounds"] = {
	["os.date() Windows crash"] = false,
	["SkidCheck"] = false,
	["nil SteamID64 and AccountID local server fix"] = false,
	["Cam function descriptive errors"] = false,
	["Error on edict limit"] = false,
	["Durgz witty sayings"] = false,
	["ULX /me command"] = false,
	["gm_save"] = false,
	["rp_downtown_v4c_v2 rooftop spawn"] = false,
	["White flashbang flashes"] = false,
	["APAnti"] = false,
	["Wire field generator exploit fix"] = false,
	["Door tool class fix"] = false,
	["Constraint crash exploit fix"] = false,
	["Deprecated console commands"] = false,
	["disable CAC"] = false,
}

function YRPDarkrpNotFound(name)
	YRP:msg("darkrp", "[MISSING] " .. name)
end

AddCSLuaFile("darkrp/fn.lua")
AddCSLuaFile("darkrp/darkrp/shared.lua")
AddCSLuaFile("darkrp/gamemode/shared.lua")
AddCSLuaFile("darkrp/player/shared.lua")
AddCSLuaFile("darkrp/entity/shared.lua")
AddCSLuaFile("darkrp/config/config.lua")
AddCSLuaFile("darkrp/drawfunction.lua")
--AddCSLuaFile( "darkrp/scoreboard/sh_scoreboard.lua" )
include("darkrp/fn.lua")
include("darkrp/darkrp/shared.lua")
include("darkrp/gamemode/shared.lua")
include("darkrp/player/shared.lua")
include("darkrp/entity/shared.lua")
include("darkrp/config/config.lua")
--include( "darkrp/scoreboard/sh_scoreboard.lua" )
if CLIENT then
	include("darkrp/drawfunction.lua")
end

local Vector = FindMetaTable("Vector")
function Vector:isInSight(filter, ply)
	--Description: Decides whether the vector could be seen by the player if they
	--						 were to look at it.
	ply = ply or LocalPlayer()
	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = self
	trace.filter = filter
	trace.mask = -1
	local TheTrace = util.TraceLine(trace)

	return not TheTrace.Hit, TheTrace.HitPos
end

-- Neurotec fix
if SERVER then
	include("neurotanks/sv_fix.lua")
end

-- NETWORKING
local tab_darkrp = {}
function SetDarkRPTab(tab)
	tab_darkrp = tab
end

function GetDarkRPVar(name, var)
	local value = tab_darkrp[name]
	if value ~= nil then
		return value
	else
		return var
	end
	--YRP:msg( "note", "[GetDarkRPVar] FAIL " .. tostring(name) .. ", " .. tostring( var) )
end

function UpdateDarkRP(tab)
	for i, v in pairs(tab) do
		if type(v) == "function" then
			continue
		elseif type(v) == "table" then
			UpdateDarkRP(v)
		elseif type(v) == "boolean" then
			tab[i] = GetDarkRPVar("bool_" .. i, v)
		end
	end
end

net.Receive(
	"nws_yrp_update_yrp_darkrp",
	function(len)
		local tab = net.ReadTable()
		SetDarkRPTab(tab)
		UpdateDarkRP(DarkRP)
	end
)

function AddExtraTeam(...)
end
--
