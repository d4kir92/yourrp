--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

--[[ Here are the public functions (FOR DEVELOPERS) ]]

AddCSLuaFile("player/hud.lua")
AddCSLuaFile("player/interface.lua")
include("player/hud.lua")
include("player/interface.lua")

--[[ Player Functions ]]--
local Player = FindMetaTable("Player")

function Player:AFK()
	return self:GetNW2Bool("isafk", false)
end

function Player:DND()
	return self:GetNW2Bool("isdnd", false)
end

function Player:GetLanguage() -- The Language the player selected
	return self:YRPGetLanguage() -- return string
end

function Player:GetLanguageShort() -- The Language the player selected (shortkey)
	return self:YRPGetLanguageShort() -- return string
end

function Player:GetCountryShort()
	return string.upper(self:GetNW2String("yrp_country", "LOADING"))
end

function Player:GetCountry() -- The Language the player selected
	return GetCountryName(self:GetCountryShort())
end

function Player:Slowed()
	return self:GetNW2Bool("slowed", false)
end

function Player:IsInCombat()
	return self:GetNW2Bool("inCombat", false)
end

--[[ Stats ]]--
function Player:GetMaxArmor()
	return self:GetNW2Int("MaxArmor", 1)
end

function Player:GetMinLevel()
	return tonumber(self:GetNW2String("int_level_min", "1"))
end

function Player:GetMaxLevel()
	return tonumber(self:GetNW2String("int_level_max", "100"))
end

function Player:Stamina()
	return self:GetNW2Int("GetCurStamina", 1)
end

function Player:GetMaxStamina()
	return self:GetNW2Int("GetMaxStamina", 10)
end

function Player:Hunger()
	return self:GetNW2Float("hunger", 100.0)
end

function Player:GetMaxHunger()
	return 100.0
end

function Player:Thirst()
	return self:GetNW2Float("thirst", 100.0)
end

function Player:GetMaxThirst()
	return 100.0
end

function Player:SalaryTime()
	return self:GetNW2Int("salarytime", 0)
end

function Player:NextSalaryTime()
	return self:GetNW2Int("nextsalarytime", 0)
end

function Player:GetCastName()
	return self:GetNW2String("castname", "")
end

function Player:CastTimeCurrent()
	return math.Round(self:GetNW2Float("castcur", 0.0), 1)
end

function Player:CastTimeMax()
	return math.Round(self:GetNW2Float("castmax", 1.0), 1)
end

function Player:Ability()
	return self:GetNW2Int("GetCurAbility", 0)
end

function Player:GetMaxAbility()
	return self:GetNW2Int("GetMaxAbility", 100)
end

function Player:IsBleeding()
	return self:GetNW2Bool("isbleeding", false)
end

function Player:IsCuffed()
	return self:GetNW2Bool("cuffed")
end

function Player:IsHungry()
	return (self:GetNW2Float("hunger", 100.0) < 20.0)
end

function Player:IsThirsty()
	return (self:GetNW2Float("thirst", 100.0) < 20.0)
end

function Player:IsRightLegBroken()
	return self:GetNW2Bool("broken_leg_right", false)
end

function Player:IsLeftLegBroken()
	return self:GetNW2Bool("broken_leg_left", false)
end

function Player:IsRightArmBroken()
	return self:GetNW2Bool("broken_arm_right", false)
end

function Player:IsLeftArmBroken()
	return self:GetNW2Bool("broken_arm_left", false)
end

function Player:InJail()
	return self:GetNW2Bool("injail", false)
end

function Player:Condition()
	local _sttext = ""
	if self:IsBleeding() then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string("LID_youarebleeding")
	end
	if self:GetNW2Bool("cuffed") then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string("LID_cuffed")
	end
	if self:GetNW2Float("hunger", 100) < 20 then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string("LID_hungry")
	end
	if self:GetNW2Float("thirst", 100) < 20.0 then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string("LID_thirsty")
	end
	if self:GetNW2Bool("broken_leg_right", false) then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string("LID_yourrightlegisbroken")
	end
	if self:GetNW2Bool("broken_leg_left", false) then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string("LID_yourleftlegisbroken")
	end
	if self:GetNW2Bool("broken_arm_right", false) then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string("LID_yourrightarmisbroken")
	end
	if self:GetNW2Bool("broken_arm_left", false) then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string("LID_yourleftarmisbroken")
	end
	if self:GetNW2Bool("injail", false) then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string("LID_jail") .. ": " .. self:GetNW2Int("jailtime", 0)
	end
	return _sttext
end

function Player:CoordAngle()
	if CLIENT then
		return ((math.Round(EyeAngles().y - 180, 0) * -1) - 90 ) % 360
	else
		return ((math.Round(self:GetAngles().y - 180, 0) * -1) - 90 ) % 360
	end
end

--[[ Metabolism ]]--
function Player:Eat(num) -- Add num to hunger
	self:YRPEat(num)
end

function Player:Drink(num) -- Add num to thirst
	self:YRPDrink(num)
end

--[[ Money ]]--
function Player:GetMoney() -- Money that the character is holding
	return math.Round(tonumber(self:GetNW2String("money", "0")), 2) -- return float
end

function Player:GetMoneyBank() -- Money that the bank is holding
	return math.Round(tonumber(self:GetNW2String("moneybank", "0")), 2) -- return float
end

function Player:Money()
	return self:GetMoney()
end

function Player:MoneyBank()
	return self:GetMoneyBank()
end

function Player:Salary()
	return tonumber(self:GetNW2String("salary", "0"))
end

function string.point(number)
	if ( isnumber( number ) ) then
		number = string.format( "%f", number )
		number = string.match( number, "^(.-)%.?0*$" ) -- Remove trailing zeros
	end
	local k
	while true do
		number, k = string.gsub( number, "^(-?%d+)(%d%d%d)", "%1.%2" )
		if ( k == 0 ) then break end
	end
	return number
end

if CLIENT then
	function MoneyFormat(money)
		money = tonumber(money)
		local ply = LocalPlayer()
		return ply:GetNW2String("text_money_pre", "[LOADING PRE]") .. string.point(money) .. ply:GetNW2String("text_money_pos", "[LOADING POS]")
	end

	function MoneyFormatRounded(money, round)
		round = round or 1
		if round > 3 then
			round = 3
		elseif round < 0 then
			round = 0
		end
		money = tonumber(money)
		local ply = LocalPlayer()
		return ply:GetNW2String("text_money_pre", "[LOADING PRE]") .. roundMoney(money, round) .. ply:GetNW2String("text_money_pos", "[LOADING POS]")
	end
end

function Player:FormattedMoney()
	return self:GetNW2String("text_money_pre", "[LOADING PRE]") .. string.point(self:Money()) .. self:GetNW2String("text_money_pos", "[LOADING POS]")
end

function Player:FormattedMoneyBank()
	return self:GetNW2String("text_money_pre", "[LOADING PRE]") .. string.point(self:MoneyBank()) .. self:GetNW2String("text_money_pos", "[LOADING POS]")
end

function Player:FormattedSalary()
	return self:GetNW2String("text_money_pre", "[LOADING PRE]") .. string.point(self:Salary()) .. self:GetNW2String("text_money_pos", "[LOADING POS]")
end

function Player:FormattedMoneyRounded(round)
	round = round or 1
	if round > 3 then
		round = 3
	elseif round < 0 then
		round = 0
	end
	return self:GetNW2String("text_money_pre", "[LOADING PRE]") .. roundMoney(self:Money(), round) .. self:GetNW2String("text_money_pos", "[LOADING POS]")
end

function Player:FormattedMoneyBankRounded(round)
	round = round or 1
	if round > 3 then
		round = 3
	elseif round < 0 then
		round = 0
	end
	return self:GetNW2String("text_money_pre", "[LOADING PRE]") .. roundMoney(self:MoneyBank(), round) .. self:GetNW2String("text_money_pos", "[LOADING POS]")
end

function Player:FormattedSalaryRounded(round)
	round = round or 1
	if round > 3 then
		round = 3
	elseif round < 0 then
		round = 0
	end
	return self:GetNW2String("text_money_pre", "[LOADING PRE]") .. roundMoney(self:Salary(), round) .. self:GetNW2String("text_money_pos", "[LOADING POS]")
end

--[[ Character ]]--
function Player:Level()
	return tonumber(self:GetNW2String("int_level", "1"))
end

function Player:XP()
	return tonumber(math.Round(self:GetNW2String("int_xp", "1"), 0))
end

function Player:GetMaxXP()
	return tonumber(math.Round(math.pow(self:Level(), 1.5), 0)) + 100
end

--[[ Role ]]--
function Player:GetRoleColor() -- Group Color
	return self:YRPGetRoleColor() -- return Color(int r, int g, int b, int a)
end

function Player:GetRoleUID()
	return tonumber(self:GetNW2String("roleUniqueID", "0"))
end

function Player:GetRoleCooldown()
	return tonumber(self:GetNW2Int("int_role_cooldown", "1"))
end

function Player:GetRoleOnDeathRoleUID()
	return tonumber(self:GetNW2String("int_roleondeath", "0"))
end

function Player:GetRoleName() -- Role Name / "Job" Name
	return self:YRPGetRoleName() -- return string
end

function Player:GetLicenseIDs()
	return self:GetNW2String("licenseIDs", "")
end

function Player:GetLicenseNames()
	return self:GetNW2String("licenseNames", "")
end

function Player:GetRoleSweps()
	return self:GetNW2String("sweps", "")
end

--[[ Faction ]]--
function Player:GetFactionUniqueID() -- Faction uniqueID
	return self:YRPGetFactionUID() -- return number
end

function Player:GetFactionName() -- Faction Name
	return self:YRPGetFactionName() -- return string
end

function Player:GetFactionColor() -- Faction Color
	return self:YRPGetFactionColor() -- return Color(int r, int g, int b, int a)
end

--[[ Group ]]--
function Player:GetGroupName() -- Group Name / "Category" Name
	return self:YRPGetGroupName() -- return string
end

function Player:GetGroupColor() -- Group Color
	return self:YRPGetGroupColor() -- return Color(int r, int g, int b, int a)
end

--[[ Name ]]--
function Player:RPName() -- Character Name / Roleplay Name
	return self:YRPRPName() -- return string
end

--[[ UserGroup ]]--
function Player:GetUserGroupColor() -- UserGroup Color
	return self:YRPGetUserGroupColor() -- return Color(int r, int g, int b, int a)
end
