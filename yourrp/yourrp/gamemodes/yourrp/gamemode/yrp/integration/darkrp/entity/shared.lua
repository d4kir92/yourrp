--Copyright (C) 2017-2023 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local Entity = FindMetaTable("Entity")
AddCSLuaFile("client.lua")

if CLIENT then
	include("client.lua")
else
	include("server.lua")
end

function Entity:getDoorData()
	--Description: Internal function to get the door/vehicle data.
	if not self:isKeysOwnable() then return {} end
	self.DoorData = self.DoorData or {}
	self.DoorData.owner = nil
	local charid = self:GetYRPInt("ownerCharID", 0)

	if EntityAlive(self:GetRPOwner()) then
		self.DoorData.owner = self:GetRPOwner():UserID()
	elseif charid and charid > 0 then
		for i, v in pairs(player.GetAll()) do
			if v:CharID() == charid then
				self.DoorData.owner = v:UserID()
			end
		end
	end

	return self.DoorData
end

function Entity:getDoorOwner()
	return self:GetRPOwner()
end

--Description: Get the owner of a door.
function Entity:getKeysAllowedToOwn()
	--Description: The list of people of which the master door owner has added as allowed to own.
	YRPDarkrpNotFound("getKeysAllowedToOwn()")

	return {}
end

function Entity:getKeysCoOwners()
	--Description: The list of people who co-own the door.
	YRPDarkrpNotFound("getKeysCoOwners()")

	return {}
end

function Entity:getKeysDoorGroup()
	return ""
end

--Description: The door group of a door if it exists.
--YRPDarkrpNotFound( "getKeysDoorGroup()" )
function Entity:getKeysDoorTeams()
	return {}
end

--Description: The teams that are allowed to open this door.
--YRPDarkrpNotFound( "getKeysDoorTeams()" )
function Entity:getKeysNonOwnable()
	return false
end

--Description: Whether ownability of this door/vehicle is disabled.
--YRPDarkrpNotFound( "getKeysNonOwnable()" )
function Entity:getKeysTitle()
	return ""
end

--Description: Get the title of this door or vehicle.
--YRPDarkrpNotFound( "getKeysTitle()" )
function Entity:IsDoor()
	--Description: Whether this entity is considered a door in DarkRP.
	self:YRPIsDoor()
end

function Entity:isDoor()
	--Description: Whether this entity is considered a door in DarkRP.
	self:IsDoor()
end

function Entity:isKeysAllowedToOwn(ply)
	--Description: Whether this player is allowed to co-own a door, as decided by the master door owner.
	YRPDarkrpNotFound("isKeysAllowedToOwn(ply)")

	return false
end

function Entity:isKeysOwnable()
	return self:GetYRPBool("bool_canbeowned", true)
end

--Description: Whether this door can be bought.
function Entity:isKeysOwned()
	return self:GetYRPBool("bool_hasowner", false) == true
end

--Description: Whether this door is owned by someone.
function Entity:isKeysOwnedBy(ply)
	return IsOwnedBy(ply, self)
end

--Description: Whether this door is owned or co-owned by this player
function Entity:isMasterOwner(ply)
	--Description: Whether the player is the main owner of the door ( as opposed to a co-owner).
	YRPDarkrpNotFound("isMasterOwner(ply)")

	return false
end

function Entity:isMoneyBag()
	--Description: Whether this entity is a money bag
	YRPDarkrpNotFound("isMoneyBag()")

	return false
end

function Entity:Getowning_ent()
	return self:GetRPOwner()
end

--Description: Not darkrp
if SERVER then
	function Entity:CPPISetOwner(ent)
		self:SetYRPEntity("cppiowner", ent)
	end
end

function Entity:CPPIGetOwner()
	return self:GetYRPEntity("cppiowner")
end