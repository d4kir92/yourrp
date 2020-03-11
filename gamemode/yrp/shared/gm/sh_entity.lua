--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local Entity = FindMetaTable("Entity")
function Entity:HasStorage()
	return self:GetDBool("hasinventory", false)
end

function Entity:StorageName()
	return self:GetDString("storagename", "")
end

function Entity:IsWorldStorage()
	return self:GetDString("isaworldstorage", false)
end

function Entity:ItemSizeW()
	return tonumber(self:GetDString("item_size_w", nil))
end

function Entity:ItemSizeH()
	return tonumber(self:GetDString("item_size_h", nil))
end
