--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local Entity = FindMetaTable("Entity")

AddCSLuaFile("client.lua")

if CLIENT then
	include("client.lua")
else
	include("server.lua")
end

function Entity:getDoorData()
	--Description: Internal function to get the door/vehicle data.
	printGM("darkrp", "getDoorData()")
	printGM("darkrp", DarkRP._not)
	return {}
end

function Entity:getDoorOwner()
	--Description: Get the owner of a door.
	printGM("darkrp", "getDoorOwner()")
	printGM("darkrp", DarkRP._not)
	return NULL
end

function Entity:getKeysAllowedToOwn()
	--Description: The list of people of which the master door owner has added as allowed to own.
	printGM("darkrp", "getKeysAllowedToOwn()")
	printGM("darkrp", DarkRP._not)
	return {}
end

function Entity:getKeysCoOwners()
	--Description: The list of people who co-own the door.
	printGM("darkrp", "getKeysCoOwners()")
	printGM("darkrp", DarkRP._not)
	return {}
end

function Entity:getKeysDoorGroup()
	--Description: The door group of a door if it exists.
	printGM("darkrp", "getKeysDoorGroup()")
	printGM("darkrp", DarkRP._not)
	return ""
end

function Entity:getKeysDoorTeams()
	--Description: The teams that are allowed to open this door.
	printGM("darkrp", "getKeysDoorTeams()")
	printGM("darkrp", DarkRP._not)
	return {}
end

function Entity:getKeysNonOwnable()
	--Description: Whether ownability of this door/vehicle is disabled.
	printGM("darkrp", "getKeysNonOwnable()")
	printGM("darkrp", DarkRP._not)
	return false
end

function Entity:getKeysTitle()
	--Description: Get the title of this door or vehicle.
	printGM("darkrp", "getKeysTitle()")
	printGM("darkrp", DarkRP._not)
	return ""
end

function Entity:isDoor()
	--Description: Whether this entity is considered a door in DarkRP.
	printGM("darkrp", "isDoor()")
	printGM("darkrp", DarkRP._not)
	return false
end

function Entity:isKeysAllowedToOwn(ply)
	--Description: Whether this player is allowed to co-own a door, as decided by the master door owner.
	printGM("darkrp", "isKeysAllowedToOwn(ply)")
	printGM("darkrp", DarkRP._not)
	return false
end

function Entity:isKeysOwnable()
	--Description: Whether this door can be bought.
	printGM("darkrp", "isKeysOwnable()")
	printGM("darkrp", DarkRP._not)
	return false
end

function Entity:isKeysOwned()
	--Description: Whether this door is owned by someone.
	printGM("darkrp", "isKeysOwned()")
	printGM("darkrp", DarkRP._not)
	return false
end

function Entity:isKeysOwnedBy(ply)
	--Description: Whether this door is owned or co-owned by this player
	printGM("darkrp", "isKeysOwnedBy(ply)")
	printGM("darkrp", DarkRP._not)
	return false
end

function Entity:isMasterOwner(ply)
	--Description: Whether the player is the main owner of the door (as opposed to a co-owner).
	printGM("darkrp", "isMasterOwner(ply)")
	printGM("darkrp", DarkRP._not)
	return false
end

function Entity:isMoneyBag()
	--Description: Whether this entity is a money bag
	printGM("darkrp", "isMoneyBag()")
	printGM("darkrp", DarkRP._not)
	return false
end

function Entity:Getowning_ent()
	--Description: Not darkrp
	--printGM("darkrp", "Getowning_ent()")
	return self:GetRPOwner()
end

if SERVER then
	function Entity:CPPISetOwner(ent)
		self:SetDEntity("cppiowner", ent)
	end
end

function Entity:CPPIGetOwner()
	return self:GetDEntity("cppiowner")
end