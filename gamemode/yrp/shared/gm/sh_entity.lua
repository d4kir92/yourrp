--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local Entity = FindMetaTable("Entity")
function Entity:HasStorage()
	return self:GetNWBool("hasinventory", false)
end

function Entity:StorageName()
	return self:GetNWString("storagename", "")
end

function Entity:IsWorldStorage()
	return self:GetNWString("isaworldstorage", false)
end

function Entity:ItemSizeW()
	return tonumber(self:GetNWString("item_size_w", nil))
end

function Entity:ItemSizeH()
	return tonumber(self:GetNWString("item_size_h", nil))
end
