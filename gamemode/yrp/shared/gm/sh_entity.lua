--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local Entity = FindMetaTable("Entity")
function Entity:HasStorage()
	return self:GetNW2Bool("hasinventory", false)
end

function Entity:StorageName()
	return self:GetNW2String("storagename", "")
end

function Entity:IsWorldStorage()
	return self:GetNW2String("isaworldstorage", false)
end

function Entity:ItemSizeW()
	return tonumber(self:GetNW2String("item_size_w", nil))
end

function Entity:ItemSizeH()
	return tonumber(self:GetNW2String("item_size_h", nil))
end
