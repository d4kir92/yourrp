--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local Player = FindMetaTable("Player")
function Player:drawHitInfo()
end

--Description: Start drawing the hit information above a hitman.
--
function Player:drawPlayerInfo()
end

--Description: Draw player info above a player's head (name, health job). Override this function to disable or change drawing behaviour in DarkRP.
--
function Player:drawWantedInfo()
end

--Description: Draw the wanted info above a player's head. Override this to disable or change the drawing of wanted info above players' heads.
--
function Player:getPreferredJobModel(teamNr)
	--Description: Draw the wanted info above a player's head. Override this to disable or change the drawing of wanted info above players' heads.
	YRPDarkrpNotFound("getPreferredJobModel( " .. tostring(teamNr) .. " )")

	return ""
end

function Player:isInRoom()
	--Description: Whether the player is in the same room as the LocalPlayer.
	local tracedata = {}
	tracedata.start = LocalPlayer():GetShootPos()
	tracedata.endpos = self:GetShootPos()
	local trace = util.TraceLine(tracedata)

	return not trace.HitWorld
end

function Player:stopHitInfo()
end

--Description: Stop drawing the hit information above a hitman.
--
local keyNames
function input.KeyNameToNumber(str)
	if not keyNames then
		keyNames = {}
		for i = 1, 107 do
			keyNames[input.GetKeyName(i)] = i
		end
	end

	return keyNames[str]
end