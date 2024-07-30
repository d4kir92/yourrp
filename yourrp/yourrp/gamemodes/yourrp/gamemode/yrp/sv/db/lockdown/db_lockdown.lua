--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
local DATABASE_NAME = "yrp_lockdown"
--YRP_SQL_DROP_TABLE(DATABASE_NAME)
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_lockdowntext", "TEXT DEFAULT 'LockdownText'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_lockdown", "INT DEFAULT '0'")
if YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'") == nil then
	YRP_SQL_INSERT_INTO(DATABASE_NAME, "string_lockdowntext", "'LockdownText'")
end

local Player = FindMetaTable("Player")
function Player:LockdownLoadout()
	--YRP:msg( "gm", self:SteamName() .. " LockdownLoadout" )
	local lockdown = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'")
	if IsNotNilAndNotFalse(lockdown) then
		lockdown = lockdown[1]
		lockdown.bool_lockdown = tobool(lockdown.bool_lockdown)
		for i, pl in pairs(player.GetAll()) do
			pl:SetYRPBool("bool_lockdown", lockdown.bool_lockdown)
			pl:SetYRPString("string_lockdowntext", lockdown.string_lockdowntext)
		end
	else
		YRP:msg("note", "Database for Lockdown is broken, is it removed from database?")
	end
end

YRP:AddNetworkString("nws_yrp_set_lockdowntext")
net.Receive(
	"nws_yrp_set_lockdowntext",
	function(len, ply)
		local string_lockdowntext = net.ReadString()
		string_lockdowntext = string_lockdowntext
		YRP:msg("db", "Changed lockdowntext to: " .. string_lockdowntext)
		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["string_lockdowntext"] = string_lockdowntext
			}, "uniqueID = '1'"
		)

		for i, pl in pairs(player.GetAll()) do
			pl:LockdownLoadout()
		end
	end
)

local alarms = {}
function AddLockDownAlarm(alarm, name, enabled)
	name = name or alarm
	enabled = enabled or true
	local entry = {}
	entry.sound = alarm
	entry.name = name
	entry.enabled = enabled
	table.insert(alarms, entry)
	SetGlobalYRPTable("lockdown_alarms", alarms)
end

AddLockDownAlarm([[ambient\alarms\alarm_citizen_loop1.wav]], "alarm_citizen_loop1")
AddLockDownAlarm([[ambient\alarms\alarm1.wav]], "alarm1")
AddLockDownAlarm([[ambient\alarms\apc_alarm_loop1.wav]], "apc_alarm_loop1")
AddLockDownAlarm([[ambient\alarms\citadel_alert_loop2.wav]], "citadel_alert_loop2")
AddLockDownAlarm([[ambient\alarms\city_siren_loop2.wav]], "city_siren_loop2")
function GetAlarmSounds()
	return alarms
end

function StartGetRandomAlarm(tries)
	local counter = 0
	local alarm = nil
	while counter < tries do
		counter = counter + 1
		alarm = GetRandomAlarm()
		if alarm.enabled then break end
	end

	return alarm
end

function GetRandomAlarm()
	return table.Random(alarms)
end

YRP:AddNetworkString("nws_yrp_update_lockdown_alarms")
net.Receive(
	"nws_yrp_update_lockdown_alarms",
	function(len, ply)
		local name = net.ReadString()
		local checked = net.ReadBool()
		for i, e in pairs(alarms) do
			if e.name == name then
				e.enabled = checked
			end
		end

		SetGlobalYRPTable("lockdown_alarms", alarms)
	end
)

_G["LOCKDOWN_ENTITIES"] = _G["LOCKDOWN_ENTITIES"] or {}
function AddToLockdownSpeakers(ent)
	table.insert(_G["LOCKDOWN_ENTITIES"], ent)
end

function RemoveFromLockdownSpeakers(ent)
	table.RemoveByValue(_G["LOCKDOWN_ENTITIES"], ent)
end

YRP:AddNetworkString("nws_yrp_set_lockdown")
net.Receive(
	"nws_yrp_set_lockdown",
	function(len, ply)
		local bool_lockdown = net.ReadBool()
		int_lockdown = tonum(bool_lockdown)
		YRP:msg("db", "Changed bool_lockdown to: " .. tostring(int_lockdown))
		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["bool_lockdown"] = int_lockdown
			}, "uniqueID = '1'"
		)

		for i, pl in pairs(player.GetAll()) do
			pl:LockdownLoadout()
		end

		if bool_lockdown then
			SetGlobalYRPBool("DarkRP_LockDown", true)
			-- LOCKDOWN START
			YRP:msg("note", ply:RPName() .. " started a lockdown!")
			sound.Add(
				{
					name = "sound_lockdown",
					channel = CHAN_AUTO,
					volume = 1.0,
					level = 80,
					pitch = {95, 110},
					sound = StartGetRandomAlarm(table.Count(alarms) * 2).sound
				}
			)

			for i, speaker in pairs(_G["LOCKDOWN_ENTITIES"]) do
				speaker:EmitSound("sound_lockdown")
			end

			local buildings = YRP_SQL_SELECT("yrp_" .. GetMapNameDB() .. "_buildings", "*", "name != '" .. "Building" .. "'")
			local lockdoors = {}
			if IsNotNilAndNotFalse(buildings) then
				for i, v in pairs(buildings) do
					if tobool(v.bool_lockdown) then
						table.insert(lockdoors, tonumber(v.uniqueID))
					end
				end

				local doors = GetAllDoors()
				for i, door in pairs(doors) do
					local buid = tonumber(door:GetYRPString("buildingID", "-1"))
					if table.HasValue(lockdoors, buid) then
						door:Fire("Close")
						door:Fire("Lock")
					end
				end
			end
		else
			SetGlobalYRPBool("DarkRP_LockDown", false)
			--LOCKDOWN END
			YRP:msg("note", ply:RPName() .. " stopped the lockdown!")
			for i, speaker in pairs(_G["LOCKDOWN_ENTITIES"]) do
				speaker:StopSound("sound_lockdown")
			end

			local buildings = YRP_SQL_SELECT("yrp_" .. GetMapNameDB() .. "_buildings", "*", "name != '" .. "Building" .. "'")
			local lockdoors = {}
			if IsNotNilAndNotFalse(buildings) then
				for i, v in pairs(buildings) do
					if tobool(v.bool_lockdown) then
						table.insert(lockdoors, tonumber(v.uniqueID))
					end
				end

				local doors = GetAllDoors()
				for i, door in pairs(doors) do
					local buid = tonumber(door:GetYRPString("buildingID", "-1"))
					if table.HasValue(lockdoors, buid) then
						door:Fire("Unlock")
						door:Fire("Open")
					end
				end
			end
		end
	end
)
