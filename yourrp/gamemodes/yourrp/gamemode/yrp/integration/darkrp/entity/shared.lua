--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

local Entity = FindMetaTable( "Entity" )

AddCSLuaFile( "client.lua" )

if CLIENT then
	include( "client.lua" )
else
	include( "server.lua" )
end

function Entity:getDoorData()
	--Description: Internal function to get the door/vehicle data.
	if not self:isKeysOwnable() then
		return {}
	end

	self.DoorData = self.DoorData or {}

	self.DoorData.owner = nil

	local charid = self:GetNW2Int( "ownerCharID", 0)
	if ea(self:GetRPOwner() ) then
		self.DoorData.owner = self:GetRPOwner():UserID()
	elseif charid and charid > 0 then
		for i, v in pairs(player.GetAll() ) do
			if v:CharID() == charid then
				self.DoorData.owner = v:UserID()
			end
		end
	end

    return self.DoorData
end

function Entity:getDoorOwner()
	--Description: Get the owner of a door.
	return self:GetRPOwner()
end

function Entity:getKeysAllowedToOwn()
	--Description: The list of people of which the master door owner has added as allowed to own.
	YRPDarkrpNotFound( "getKeysAllowedToOwn()" )
	return {}
end

function Entity:getKeysCoOwners()
	--Description: The list of people who co-own the door.
	YRPDarkrpNotFound( "getKeysCoOwners()" )
	return {}
end

function Entity:getKeysDoorGroup()
	--Description: The door group of a door if it exists.
	--YRPDarkrpNotFound( "getKeysDoorGroup()" )
	return ""
end

function Entity:getKeysDoorTeams()
	--Description: The teams that are allowed to open this door.
	--YRPDarkrpNotFound( "getKeysDoorTeams()" )
	return {}
end

function Entity:getKeysNonOwnable()
	--Description: Whether ownability of this door/vehicle is disabled.
	--YRPDarkrpNotFound( "getKeysNonOwnable()" )
	return false
end

function Entity:getKeysTitle()
	--Description: Get the title of this door or vehicle.
	--YRPDarkrpNotFound( "getKeysTitle()" )
	return ""
end

function Entity:IsDoor()
	--Description: Whether this entity is considered a door in DarkRP.
	self:YRPIsDoor()
end

function Entity:isKeysAllowedToOwn(ply)
	--Description: Whether this player is allowed to co-own a door, as decided by the master door owner.
	YRPDarkrpNotFound( "isKeysAllowedToOwn(ply)" )
	return false
end

function Entity:isKeysOwnable()
	--Description: Whether this door can be bought.
	return self:GetNW2Bool( "bool_canbeowned", true)
end

function Entity:isKeysOwned()
	--Description: Whether this door is owned by someone.
	return self:GetNW2Bool( "bool_hasowner", false) == true
end

function Entity:isKeysOwnedBy(ply)
	--Description: Whether this door is owned or co-owned by this player
	return IsOwnedBy(ply, self)
end

function Entity:isMasterOwner(ply)
	--Description: Whether the player is the main owner of the door ( as opposed to a co-owner).
	YRPDarkrpNotFound( "isMasterOwner(ply)" )
	return false
end

function Entity:isMoneyBag()
	--Description: Whether this entity is a money bag
	YRPDarkrpNotFound( "isMoneyBag()" )
	return false
end

function Entity:Getowning_ent()
	--Description: Not darkrp
	return self:GetRPOwner()
end

if SERVER then
	function Entity:CPPISetOwner(ent)
		self:SetNWEntity( "cppiowner", ent)
	end
end

function Entity:CPPIGetOwner()
	return self:GetNWEntity( "cppiowner" )
end