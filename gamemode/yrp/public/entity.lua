--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

--[[ Here are the public functions (FOR DEVELOPERS) ]]

--[[ Entity Functions ]]--
local Entity = FindMetaTable("Entity")

function Entity:GetRPOwner()
	return self:GetNWEntity("yrp_owner")
end
