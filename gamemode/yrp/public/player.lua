--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

--[[ Here are the public functions (FOR DEVELOPERS) ]]

AddCSLuaFile("player/hud.lua")
AddCSLuaFile("player/interface.lua")
include("player/hud.lua")
include("player/interface.lua")

--[[ Player Functions ]]--
local Player = FindMetaTable("Player")

function Player:AFK()
	return self:GetNWBool("isafk", false)
end

function Player:DND()
	return self:GetNWBool("isdnd", false)
end

function Player:GetLanguage() -- The Language the player selected
	return self:YRPGetLanguage() -- return string
end

function Player:GetLanguageShort() -- The Language the player selected (shortkey)
	return self:YRPGetLanguageShort() -- return string
end

function Player:GetCountryShort()
	return string.upper(self:GetNWString("yrp_country", "LOADING"))
end

function Player:GetCountry() -- The Language the player selected
	return GetCountryName(self:GetCountryShort())
end

function Player:Slowed()
	return self:GetNWBool("slowed", false)
end

function Player:IsInCombat()
	return self:GetNWBool("inCombat", false)
end

--[[ Stats ]]--
function Player:GetMaxArmor()
	return self:GetNWInt("MaxArmor", 1)
end

function Player:GetMinLevel()
	return tonumber(self:GetNWString("int_level_min", "1"))
end

function Player:GetMaxLevel()
	return tonumber(self:GetNWString("int_level_max", "100"))
end

function Player:Stamina()
	return self:GetNWInt("GetCurStamina", 1)
end

function Player:GetMaxStamina()
	return self:GetNWInt("GetMaxStamina", 10)
end

function Player:Hunger()
	return self:GetNWFloat("hunger", 100.0)
end

function Player:GetMaxHunger()
	return 100.0
end

function Player:Thirst()
	return self:GetNWFloat("thirst", 100.0)
end

function Player:GetMaxThirst()
	return 100.0
end

function Player:SalaryTime()
	return self:GetNWInt("salarytime", 0)
end

function Player:NextSalaryTime()
	return self:GetNWInt("nextsalarytime", 0)
end

function Player:GetCastName()
	return self:GetNWString("castname", "")
end

function Player:CastTimeCurrent()
	return math.Round(self:GetNWFloat("castcur", 0.0), 1)
end

function Player:CastTimeMax()
	return math.Round(self:GetNWFloat("castmax", 1.0), 1)
end

function Player:Ability()
	return self:GetNWInt("GetCurAbility", 0)
end

function Player:GetMaxAbility()
	return self:GetNWInt("GetMaxAbility", 100)
end

function Player:Condition()
	local _sttext = ""
	if self:IsBleeding() then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string("LID_youarebleeding")
	end
	if self:GetNWBool("cuffed") then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string("LID_cuffed")
	end
	if self:GetNWFloat("hunger", 100) < 20 then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string("LID_hungry")
	end
	if self:GetNWFloat("thirst", 100) < 20.0 then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string("LID_thirsty")
	end
	if self:GetNWBool("broken_leg_right", false) then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string("LID_yourrightlegisbroken")
	end
	if self:GetNWBool("broken_leg_left", false) then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string("LID_yourleftlegisbroken")
	end
	if self:GetNWBool("broken_arm_right", false) then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string("LID_yourrightarmisbroken")
	end
	if self:GetNWBool("broken_arm_left", false) then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string("LID_yourleftarmisbroken")
	end
	if self:GetNWBool("injail", false) then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string("LID_jail") .. ": " .. self:GetNWInt("jailtime", 0)
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
	return math.Round(tonumber(self:GetNWString("money", "0")), 2) -- return float
end

function Player:GetMoneyBank() -- Money that the bank is holding
	return math.Round(tonumber(self:GetNWString("moneybank", "0")), 2) -- return float
end

function Player:Money()
	return self:GetMoney()
end

function Player:MoneyBank()
	return self:GetMoneyBank()
end

function Player:Salary()
	return tonumber(self:GetNWString("salary", "0"))
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
		return ply:GetNWString("text_money_pre", "[LOADING PRE]") .. string.point(money) .. ply:GetNWString("text_money_pos", "[LOADING POS]")
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
		return ply:GetNWString("text_money_pre", "[LOADING PRE]") .. roundMoney(money, round) .. ply:GetNWString("text_money_pos", "[LOADING POS]")
	end
end

function Player:FormattedMoney()
	return self:GetNWString("text_money_pre", "[LOADING PRE]") .. string.point(self:Money()) .. self:GetNWString("text_money_pos", "[LOADING POS]")
end

function Player:FormattedMoneyBank()
	return self:GetNWString("text_money_pre", "[LOADING PRE]") .. string.point(self:MoneyBank()) .. self:GetNWString("text_money_pos", "[LOADING POS]")
end

function Player:FormattedSalary()
	return self:GetNWString("text_money_pre", "[LOADING PRE]") .. string.point(self:Salary()) .. self:GetNWString("text_money_pos", "[LOADING POS]")
end

function Player:FormattedMoneyRounded(round)
	round = round or 1
	if round > 3 then
		round = 3
	elseif round < 0 then
		round = 0
	end
	return self:GetNWString("text_money_pre", "[LOADING PRE]") .. roundMoney(self:Money(), round) .. self:GetNWString("text_money_pos", "[LOADING POS]")
end

function Player:FormattedMoneyBankRounded(round)
	round = round or 1
	if round > 3 then
		round = 3
	elseif round < 0 then
		round = 0
	end
	return self:GetNWString("text_money_pre", "[LOADING PRE]") .. roundMoney(self:MoneyBank(), round) .. self:GetNWString("text_money_pos", "[LOADING POS]")
end

function Player:FormattedSalaryRounded(round)
	round = round or 1
	if round > 3 then
		round = 3
	elseif round < 0 then
		round = 0
	end
	return self:GetNWString("text_money_pre", "[LOADING PRE]") .. roundMoney(self:Salary(), round) .. self:GetNWString("text_money_pos", "[LOADING POS]")
end

--[[ Character ]]--
function Player:Level()
	return tonumber(self:GetNWString("int_level", "1"))
end

function Player:XP()
	return tonumber(math.Round(self:GetNWString("int_xp", "1"), 0))
end

function Player:GetMaxXP()
	return tonumber(math.Round(math.pow(self:Level(), 1.5), 0)) + 100
end

--[[ Role ]]--
function Player:GetRoleUID()
	return tonumber(self:GetNWString("roleUniqueID", "0"))
end

function Player:GetRoleCooldown()
	return tonumber(self:GetNWInt("int_role_cooldown", "1"))
end

function Player:GetRoleOnDeathRoleUID()
	return tonumber(self:GetNWString("int_roleondeath", "0"))
end

function Player:GetRoleName() -- Role Name / "Job" Name
	return self:YRPGetRoleName() -- return string
end

function Player:GetLicenseIDs()
	return self:GetNWString("licenseIDs", "")
end

function Player:GetLicenseNames()
	return self:GetNWString("licenseNames", "")
end

function Player:GetRoleSweps()
	return self:GetNWString("sweps", "")
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
