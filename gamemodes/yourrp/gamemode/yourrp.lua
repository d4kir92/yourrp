--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--yourrp.lua

local PLAYER = FindMetaTable( "Player" )

function PLAYER:SteamName()
  return self:GetName()
end

function PLAYER:RPName()
  return self:GetNWString( "SurName", "" ) .. ", " .. self:GetNWString( "FirstName", "" )
end

function PLAYER:Nick()
  return self:SteamName() .. " [" .. self:RPName() .. "]"
end
