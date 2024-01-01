--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local Entity = FindMetaTable("Entity")
function Entity:addKeysAllowedToOwn(ply)
end

--Description: Make this player allowed to co-own the door or vehicle.
--YRPDarkrpNotFound( "addKeysAllowedToOwn(ply)" )
function Entity:addKeysDoorOwner(ply)
end

--Description: Make this player a co-owner of the door.
--YRPDarkrpNotFound( "addKeysDoorOwner(ply)" )
function Entity:addKeysDoorTeam(team)
end

--Description: Allow a team to lock/unlock a door..
--YRPDarkrpNotFound( "addKeysDoorTeam( " .. tostring(team) .. " )" )
function Entity:doorIndex()
	return self:GetYRPInt("uniqueID", -1)
end

--Description: Get the door index of a door. Use this to store door
--						 information in the database.
function Entity:isLocked()
	--Description: Whether this door/vehicle is locked.
	local locked = self:GetSaveTable().m_bLocked

	return locked
end

function Entity:keysLock()
	if YRPEntityAlive(self) then
		self:Fire("Lock")
	end
end

function Entity:keysOwn(ply)
end

--Description: Make the player the master owner of the door
--YRPDarkrpNotFound( "keysOwn(ply)" )
function Entity:keysUnLock()
	if YRPEntityAlive(self) then
		self:Fire("Unlock")
	end
end

function Entity:keysUnOwn(ply)
end

--Description: Make this player unown the door/vehicle.
--YRPDarkrpNotFound( "keysUnOwn(ply)" )
function Entity:removeAllKeysAllowedToOwn()
end

--Description: Disallow all people from owning the door.
--YRPDarkrpNotFound( "removeAllKeysAllowedToOwn()" )
function Entity:removeAllKeysDoorTeams()
end

--Description: Disallow all teams from locking/unlocking a door.
--YRPDarkrpNotFound( "removeAllKeysDoorTeams()" )
function Entity:removeAllKeysExtraOwners()
end

--Description: Remove all co-owners from a door.
--YRPDarkrpNotFound( "removeAllKeysExtraOwners()" )
function Entity:removeKeysAllowedToOwn(ply)
end

--Description: Remove a player from being allowed to co-own a door.
--YRPDarkrpNotFound( "removeKeysAllowedToOwn(ply)" )
function Entity:removeKeysDoorOwner(ply)
end

--Description: Remove this player as co-owner
--YRPDarkrpNotFound( "removeKeysDoorOwner(ply)" )
function Entity:removeKeysDoorTeam(team)
end

--Description: Disallow a team from locking/unlocking a door.
--YRPDarkrpNotFound( "removeKeysDoorTeam( " .. tostring(team) .. " )" )
function Entity:setDoorGroup(group)
end

--Description: Set the door group of a door.
--YRPDarkrpNotFound( "setDoorGroup( " .. tostring(group) .. " )" )
function Entity:setKeysNonOwnable(ownable)
end

--Description: Set whether this door or vehicle is ownable or not.
--YRPDarkrpNotFound( "setKeysNonOwnable( " .. tostring(ownable) .. " )" )
function Entity:setKeysTitle(title)
end
--Description: Set the title of a door or vehicle.
--YRPDarkrpNotFound( "setKeysTitle( " .. tostring(title) .. " )" )