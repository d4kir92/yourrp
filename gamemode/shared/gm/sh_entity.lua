--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local Entity = FindMetaTable( "Entity" )
function Entity:HasStorage()
  return self:GetNWBool( "hasinventory", false )
end

function Entity:StorageName()
  return self:GetNWString( "storagename", "" )
end
