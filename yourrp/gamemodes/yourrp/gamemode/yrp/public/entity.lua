--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

--[[ Here are the public functions (FOR DEVELOPERS) ]]

--[[ Entity Functions ]]--
local Entity = FindMetaTable("Entity")

function Entity:GetRPOwner()
	return self:GetDEntity("yrp_owner", NULL)
end
