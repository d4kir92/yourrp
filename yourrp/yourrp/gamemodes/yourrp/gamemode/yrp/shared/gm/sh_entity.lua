--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local Entity = FindMetaTable("Entity")
function Entity:HasStorage()
	return self:GetYRPBool("hasinventory", false)
end

function Entity:StorageName()
	return self:GetYRPString("storagename", "")
end

function Entity:IsWorldStorage()
	return self:GetYRPString("isaworldstorage", false)
end

function Entity:ItemSizeW()
	return tonumber(self:GetYRPString("item_size_w", nil))
end

function Entity:ItemSizeH()
	return tonumber(self:GetYRPString("item_size_h", nil))
end

function Entity:IsDealer()
	return self:GetClass() == "yrp_dealer"
end
