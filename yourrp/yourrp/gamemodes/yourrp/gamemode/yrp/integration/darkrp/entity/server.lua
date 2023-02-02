--Copyright (C) 2017-2023 D4KiR (https://www.gnu.org/licenses/gpl.txt)

local Entity = FindMetaTable( "Entity" )

function Entity:addKeysAllowedToOwn(ply)
	--Description: Make this player allowed to co-own the door or vehicle.
	--YRPDarkrpNotFound( "addKeysAllowedToOwn(ply)" )
end

function Entity:addKeysDoorOwner(ply)
	--Description: Make this player a co-owner of the door.
	--YRPDarkrpNotFound( "addKeysDoorOwner(ply)" )
end

function Entity:addKeysDoorTeam(team)
	--Description: Allow a team to lock/unlock a door..
	--YRPDarkrpNotFound( "addKeysDoorTeam( " .. tostring(team) .. " )" )
end

function Entity:doorIndex()
	--Description: Get the door index of a door. Use this to store door
	--						 information in the database.
	return self:GetYRPInt( "uniqueID", -1)
end

function Entity:isLocked()
	--Description: Whether this door/vehicle is locked.
	local locked = self:GetSaveTable().m_bLocked
	return locked
end

function Entity:keysLock()
	if EntityAlive( self ) then
		self:Fire( "Lock" )
	end
end

function Entity:keysOwn(ply)
	--Description: Make the player the master owner of the door
	--YRPDarkrpNotFound( "keysOwn(ply)" )
end

function Entity:keysUnLock()
	if EntityAlive( self ) then
		self:Fire( "Unlock" )
	end
end

function Entity:keysUnOwn(ply)
	--Description: Make this player unown the door/vehicle.
	--YRPDarkrpNotFound( "keysUnOwn(ply)" )
end

function Entity:removeAllKeysAllowedToOwn()
	--Description: Disallow all people from owning the door.
	--YRPDarkrpNotFound( "removeAllKeysAllowedToOwn()" )
end

function Entity:removeAllKeysDoorTeams()
	--Description: Disallow all teams from locking/unlocking a door.
	--YRPDarkrpNotFound( "removeAllKeysDoorTeams()" )
end

function Entity:removeAllKeysExtraOwners()
	--Description: Remove all co-owners from a door.
	--YRPDarkrpNotFound( "removeAllKeysExtraOwners()" )
end

function Entity:removeKeysAllowedToOwn(ply)
	--Description: Remove a player from being allowed to co-own a door.
	--YRPDarkrpNotFound( "removeKeysAllowedToOwn(ply)" )
end

function Entity:removeKeysDoorOwner(ply)
	--Description: Remove this player as co-owner
	--YRPDarkrpNotFound( "removeKeysDoorOwner(ply)" )
end

function Entity:removeKeysDoorTeam(team)
	--Description: Disallow a team from locking/unlocking a door.
	--YRPDarkrpNotFound( "removeKeysDoorTeam( " .. tostring(team) .. " )" )
end

function Entity:setDoorGroup(group)
	--Description: Set the door group of a door.
	--YRPDarkrpNotFound( "setDoorGroup( " .. tostring(group) .. " )" )
end

function Entity:setKeysNonOwnable(ownable)
	--Description: Set whether this door or vehicle is ownable or not.
	--YRPDarkrpNotFound( "setKeysNonOwnable( " .. tostring(ownable) .. " )" )
end

function Entity:setKeysTitle(title)
	--Description: Set the title of a door or vehicle.
	--YRPDarkrpNotFound( "setKeysTitle( " .. tostring(title) .. " )" )
end
