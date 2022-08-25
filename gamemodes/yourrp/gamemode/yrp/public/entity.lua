--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

--[[ Here are the public functions (FOR DEVELOPERS) ]]

--[[ Entity Functions ]]--
local Entity = FindMetaTable( "Entity" )

function Entity:GetRPOwner()
	return self:GetYRPEntity( "yrp_owner", NULL)
end

function Entity:YRPIsDoor()
	if self == NULL then return end
	return self:GetClass() == "prop_door_rotating" or self:GetClass() == "func_door" or self:GetClass() == "func_door_rotating"
end

function Entity:SecurityLevel()
	return self:GetYRPInt( "int_securitylevel", -1 )
end

function Entity:GetSecurityLevel()
	return self:SecurityLevel()
end
