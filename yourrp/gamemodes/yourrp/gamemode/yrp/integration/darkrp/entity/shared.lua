--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local Entity = FindMetaTable("Entity")

AddCSLuaFile("client.lua")

if CLIENT then
	include("client.lua")
else
	include("server.lua")
end

function Entity:getDoorData()
	--Description: Internal function to get the door/vehicle data.
	YRP.msg("darkrp", "getDoorData()")
	YRP.msg("darkrp", DarkRP._not)
	return {}
end

function Entity:getDoorOwner()
	--Description: Get the owner of a door.
	YRP.msg("darkrp", "getDoorOwner()")
	YRP.msg("darkrp", DarkRP._not)
	return NULL
end

function Entity:getKeysAllowedToOwn()
	--Description: The list of people of which the master door owner has added as allowed to own.
	YRP.msg("darkrp", "getKeysAllowedToOwn()")
	YRP.msg("darkrp", DarkRP._not)
	return {}
end

function Entity:getKeysCoOwners()
	--Description: The list of people who co-own the door.
	YRP.msg("darkrp", "getKeysCoOwners()")
	YRP.msg("darkrp", DarkRP._not)
	return {}
end

function Entity:getKeysDoorGroup()
	--Description: The door group of a door if it exists.
	YRP.msg("darkrp", "getKeysDoorGroup()")
	YRP.msg("darkrp", DarkRP._not)
	return ""
end

function Entity:getKeysDoorTeams()
	--Description: The teams that are allowed to open this door.
	YRP.msg("darkrp", "getKeysDoorTeams()")
	YRP.msg("darkrp", DarkRP._not)
	return {}
end

function Entity:getKeysNonOwnable()
	--Description: Whether ownability of this door/vehicle is disabled.
	YRP.msg("darkrp", "getKeysNonOwnable()")
	YRP.msg("darkrp", DarkRP._not)
	return false
end

function Entity:getKeysTitle()
	--Description: Get the title of this door or vehicle.
	YRP.msg("darkrp", "getKeysTitle()")
	YRP.msg("darkrp", DarkRP._not)
	return ""
end

function Entity:isDoor()
	--Description: Whether this entity is considered a door in DarkRP.
	if self == NULL then return end
	return self:GetClass() == "prop_door_rotating" or self:GetClass() == "func_door" or self:GetClass() == "func_door_rotating"
end

function Entity:isKeysAllowedToOwn(ply)
	--Description: Whether this player is allowed to co-own a door, as decided by the master door owner.
	YRP.msg("darkrp", "isKeysAllowedToOwn(ply)")
	YRP.msg("darkrp", DarkRP._not)
	return false
end

function Entity:isKeysOwnable()
	--Description: Whether this door can be bought.
	return GetGlobalDBool("bool_building_system", false)
end

function Entity:isKeysOwned()
	--Description: Whether this door is owned by someone.
	return self:GetDBool("bool_hasowner", false) == true
end

function Entity:isKeysOwnedBy(ply)
	--Description: Whether this door is owned or co-owned by this player
	return IsOwnedBy(ply, self)
end

function Entity:isMasterOwner(ply)
	--Description: Whether the player is the main owner of the door (as opposed to a co-owner).
	YRP.msg("darkrp", "isMasterOwner(ply)")
	YRP.msg("darkrp", DarkRP._not)
	return false
end

function Entity:isMoneyBag()
	--Description: Whether this entity is a money bag
	YRP.msg("darkrp", "isMoneyBag()")
	YRP.msg("darkrp", DarkRP._not)
	return false
end

function Entity:Getowning_ent()
	--Description: Not darkrp
	--YRP.msg("darkrp", "Getowning_ent()")
	return self:GetRPOwner()
end

if SERVER then
	function Entity:CPPISetOwner(ent)
		self:SetNWEntity("cppiowner", ent)
	end
end

function Entity:CPPIGetOwner()
	return self:GetNWEntity("cppiowner")
end