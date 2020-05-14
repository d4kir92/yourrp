--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local Entity = FindMetaTable("Entity")

function Entity:addKeysAllowedToOwn(ply)
	--Description: Make this player allowed to co-own the door or vehicle.
	YRP.msg("darkrp", "addKeysAllowedToOwn(ply)")
	YRP.msg("darkrp", DarkRP._not)
end

function Entity:addKeysDoorOwner(ply)
	--Description: Make this player a co-owner of the door.
	YRP.msg("darkrp", "addKeysDoorOwner(ply)")
	YRP.msg("darkrp", DarkRP._not)
end

function Entity:addKeysDoorTeam(team)
	--Description: Allow a team to lock/unlock a door..
	YRP.msg("darkrp", "addKeysDoorTeam(team)")
	YRP.msg("darkrp", DarkRP._not)
end

function Entity:doorIndex()
	--Description: Get the door index of a door. Use this to store door
	--						 information in the database.
	YRP.msg("darkrp", "doorIndex()")

	return self:GetDInt("uniqueID", -1)
end

function Entity:isLocked()
	--Description: Whether this door/vehicle is locked.
	YRP.msg("darkrp", "isLocked()")
	YRP.msg("darkrp", DarkRP._not)
	return false
end

function Entity:keysLock()
	--Description: Lock this door or vehicle.
	YRP.msg("darkrp", "keysLock()")
	YRP.msg("darkrp", DarkRP._not)
end

function Entity:keysOwn(ply)
	--Description: Make the player the master owner of the door
	YRP.msg("darkrp", "keysOwn(ply)")
	YRP.msg("darkrp", DarkRP._not)
end

function Entity:keysUnLock()
	--Description: Unlock this door or vehicle.
	YRP.msg("darkrp", "keysUnLock()")
	YRP.msg("darkrp", DarkRP._not)
end

function Entity:keysUnOwn(ply)
	--Description: Make this player unown the door/vehicle.
	YRP.msg("darkrp", "keysUnOwn(ply)")
	YRP.msg("darkrp", DarkRP._not)
end

function Entity:removeAllKeysAllowedToOwn()
	--Description: Disallow all people from owning the door.
	YRP.msg("darkrp", "removeAllKeysAllowedToOwn()")
	YRP.msg("darkrp", DarkRP._not)
end

function Entity:removeAllKeysDoorTeams()
	--Description: Disallow all teams from locking/unlocking a door.
	YRP.msg("darkrp", "removeAllKeysDoorTeams()")
	YRP.msg("darkrp", DarkRP._not)
end

function Entity:removeAllKeysExtraOwners()
	--Description: Remove all co-owners from a door.
	YRP.msg("darkrp", "removeAllKeysExtraOwners()")
	YRP.msg("darkrp", DarkRP._not)
end

function Entity:removeKeysAllowedToOwn(ply)
	--Description: Remove a player from being allowed to co-own a door.
	YRP.msg("darkrp", "removeKeysAllowedToOwn(ply)")
	YRP.msg("darkrp", DarkRP._not)
end

function Entity:removeKeysDoorOwner(ply)
	--Description: Remove this player as co-owner
	YRP.msg("darkrp", "removeKeysDoorOwner(ply)")
	YRP.msg("darkrp", DarkRP._not)
end

function Entity:removeKeysDoorTeam(team)
	--Description: Disallow a team from locking/unlocking a door.
	YRP.msg("darkrp", "removeKeysDoorTeam(team)")
	YRP.msg("darkrp", DarkRP._not)
end

function Entity:setDoorGroup(group)
	--Description: Set the door group of a door.
	YRP.msg("darkrp", "setDoorGroup(group)")
	YRP.msg("darkrp", DarkRP._not)
end

function Entity:setKeysNonOwnable(ownable)
	--Description: Set whether this door or vehicle is ownable or not.
	YRP.msg("darkrp", "setKeysNonOwnable(ownable)")
	YRP.msg("darkrp", DarkRP._not)
end

function Entity:setKeysTitle(title)
	--Description: Set the title of a door or vehicle.
	YRP.msg("darkrp", "setKeysTitle(title)")
	YRP.msg("darkrp", DarkRP._not)
end
