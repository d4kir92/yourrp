--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--[[ Here are the public functions (FOR DEVELOPERS) ]]

--[[ Player Functions ]]--
local Player = FindMetaTable( "Player" )

function Player:GetLanguage() -- The Language the player selected
	return self:YRPGetLanguage() -- return string
end

function Player:GetLanguageShort() -- The Language the player selected (shortkey)
	return self:YRPGetLanguageShort() -- return string
end

function Player:Slowed()
	return self:GetNWBool("slowed", false)
end

--[[ Metabolism ]]--
function Player:Eat( num ) -- Add num to hunger
	self:YRPEat( num )
end

function Player:Drink( num ) -- Add num to thirst
	self:YRPDrink( num )
end

--[[ Money ]]--
function Player:GetMoney() -- Money that the character is holding
	return self:YRPGetMoney() -- return float
end

function Player:GetMoneyBank() -- Money that the bank is holding
	return self:YRPGetMoneyBank() -- return float
end

--[[ Role ]]--
function Player:GetRoleName() -- Role Name / "Job" Name
	return self:YRPGetRoleName() -- return string
end

--[[ Faction ]]--
function Player:GetFactionName() -- Faction Name
	return self:YRPGetFactionName() -- return string
end

function Player:GetFactionColor() -- Faction Color
	return self:YRPGetFactionColor() -- return Color( int r, int g, int b, int a )
end

--[[ Group ]]--
function Player:GetGroupName() -- Group Name / "Category" Name
	return self:YRPGetGroupName() -- return string
end

function Player:GetGroupColor() -- Group Color
	return self:YRPGetGroupColor() -- return Color( int r, int g, int b, int a )
end

--[[ Name ]]--
function Player:RPName() -- Character Name / Roleplay Name
	return self:YRPRPName() -- return string
end
