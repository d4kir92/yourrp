--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )
--[[
local metaPly = FindMetaTable( "Player" )

function metaPly:SteamName()
  return self:GetName()
end

function metaPly:RPName()
  return self:GetNWString( "SurName" ) .. ", " .. self:GetNWString( "FirstName" )
end

function metaPly:Nick()
  return self:SteamName() .. " [" .. self:RPName() .. "]"
end
]]--
