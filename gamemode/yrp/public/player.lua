--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

--[[ Here are the public functions (FOR DEVELOPERS) ]]

AddCSLuaFile("player/hud.lua")
AddCSLuaFile("player/interface.lua")
include("player/hud.lua")
include("player/interface.lua")

--[[ Player Functions ]]--
local Player = FindMetaTable("Player")

function Player:Revive(pos)
	self.ignorespawnpoint = true
	self:Spawn()
	if wk(pos) then
		self:SetPos(pos)
	end
end

function IsPlayerIntroductionEnabled()
	return false -- GetGlobalDBool("bool_players_need_to_introduce", false)
end

function Player:IsUnknown()
	if CLIENT and IsPlayerIntroductionEnabled() and self != LocalPlayer() then
		return true
	end
	return false
end

function Player:Battery()
	local battery = system.BatteryPower()
	if battery > 100 then
		battery = 100
	end
	return battery
end

function Player:GetMaxBattery()
	return 100
end

function Player:AFK()
	return self:GetDBool("isafk", false)
end

function Player:DND()
	return self:GetDBool("isdnd", false)
end

function Player:IDCardID()
	return self:GetDString("idcardid", "Unknown")
end

function Player:GetLanguage() -- The Language the player selected
	return self:YRPGetLanguage() -- return string
end

function Player:GetLanguageShort() -- The Language the player selected (shortkey)
	return self:YRPGetLanguageShort() -- return string
end

function Player:GetCountryShort()
	return string.upper(self:GetDString("yrp_country", "LOADING"))
end

function Player:GetCountry() -- The Language the player selected
	return GetCountryName(self:GetCountryShort())
end

function Player:Slowed()
	return self:GetDBool("slowed", false)
end

function Player:IsInCombat()
	return self:GetDBool("inCombat", false)
end

--[[ Stats ]]--
function Player:GetMaxArmor()
	return tonumber(self:GetDInt("MaxArmor", 100))
end

function Player:GetMinLevel()
	return tonumber(self:GetDString("int_level_min", "1"))
end

function Player:GetMaxLevel()
	return tonumber(self:GetDString("int_level_max", "100"))
end

function Player:Stamina()
	return self:GetDInt("GetCurStamina", 1)
end

function Player:GetMaxStamina()
	return self:GetDInt("GetMaxStamina", 10)
end

function Player:Hunger()
	return math.Round(self:GetDFloat("hunger", 100.0), 1)
end

function Player:GetMaxHunger()
	return 100.0
end

function Player:Thirst()
	return math.Round(self:GetDFloat("thirst", 100.0), 1)
end

function Player:GetMaxThirst()
	return 100.0
end

function Player:SalaryTime()
	return self:GetDInt("salarytime", 0)
end

function Player:NextSalaryTime()
	return self:GetDInt("nextsalarytime", 0)
end

function Player:GetCastName()
	return YRP.lang_string(self:GetDString("castname", ""))
end

function Player:CastTimeCurrent()
	return math.Round(self:GetDFloat("castcur", 0.0), 1)
end

function Player:CastTimeMax()
	return math.Round(self:GetDFloat("castmax", 1.0), 1)
end

function Player:Ability()
	return self:GetDInt("GetCurAbility", 0)
end

function Player:GetMaxAbility()
	return self:GetDInt("GetMaxAbility", 100)
end

function Player:IsBleeding()
	return self:GetDBool("isbleeding", false)
end

function Player:IsCuffed()
	return self:GetDBool("cuffed")
end

function Player:IsHungry()
	return self:GetDFloat("hunger", 100.0) < 20.0
end

function Player:IsThirsty()
	return self:GetDFloat("thirst", 100.0) < 20.0
end

function Player:IsRightLegBroken()
	return self:GetDBool("broken_leg_right", false)
end

function Player:IsLeftLegBroken()
	return self:GetDBool("broken_leg_left", false)
end

function Player:IsRightArmBroken()
	return self:GetDBool("broken_arm_right", false)
end

function Player:IsLeftArmBroken()
	return self:GetDBool("broken_arm_left", false)
end

function Player:InJail()
	return self:GetDBool("injail", false)
end

function Player:Condition()
	local _sttext = ""
	if self:IsBleeding() then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string("LID_youarebleeding")
	end
	if self:GetDBool("cuffed") then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string("LID_cuffed")
	end
	if self:GetDFloat("hunger", 100) < 20 then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string("LID_hungry")
	end
	if self:GetDFloat("thirst", 100) < 20.0 then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string("LID_thirsty")
	end
	if self:GetDBool("broken_leg_right", false) then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string("LID_yourrightlegisbroken")
	end
	if self:GetDBool("broken_leg_left", false) then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string("LID_yourleftlegisbroken")
	end
	if self:GetDBool("broken_arm_right", false) then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string("LID_yourrightarmisbroken")
	end
	if self:GetDBool("broken_arm_left", false) then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string("LID_yourleftarmisbroken")
	end
	if self:GetDBool("injail", false) then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string("LID_jail") .. ": " .. self:GetDInt("jailtime", 0)
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
	return math.Round(tonumber(self:GetDString("money", "0")), 2) -- return float
end

function Player:GetMoneyBank() -- Money that the bank is holding
	return math.Round(tonumber(self:GetDString("moneybank", "0")), 2) -- return float
end

function Player:Money()
	return self:GetMoney()
end

function Player:MoneyBank()
	return self:GetMoneyBank()
end

function Player:Salary()
	return tonumber(self:GetDString("salary", "0"))
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
		return GetGlobalDString("text_money_pre", "") .. string.point(money) .. GetGlobalDString("text_money_pos", "")
	end

	function MoneyFormatRounded(money, round)
		round = round or 1
		if round > 3 then
			round = 3
		elseif round < 0 then
			round = 0
		end
		money = tonumber(money)
		return GetGlobalDString("text_money_pre", "") .. roundMoney(money, round) .. GetGlobalDString("text_money_pos", "")
	end
end

function Player:FormattedMoney()
	return GetGlobalDString("text_money_pre", "") .. string.point(self:Money()) .. GetGlobalDString("text_money_pos", "")
end

function Player:FormattedMoneyBank()
	return GetGlobalDString("text_money_pre", "") .. string.point(self:MoneyBank()) .. GetGlobalDString("text_money_pos", "")
end

function Player:FormattedSalary()
	return GetGlobalDString("text_money_pre", "") .. string.point(self:Salary()) .. GetGlobalDString("text_money_pos", "")
end

function Player:FormattedMoneyRounded(round)
	round = round or 1
	if round > 3 then
		round = 3
	elseif round < 0 then
		round = 0
	end
	return GetGlobalDString("text_money_pre", "") .. roundMoney(self:Money(), round) .. GetGlobalDString("text_money_pos", "")
end

function Player:FormattedMoneyBankRounded(round)
	round = round or 1
	if round > 3 then
		round = 3
	elseif round < 0 then
		round = 0
	end
	return GetGlobalDString("text_money_pre", "") .. roundMoney(self:MoneyBank(), round) .. GetGlobalDString("text_money_pos", "")
end

function Player:FormattedSalaryRounded(round)
	round = round or 1
	if round > 3 then
		round = 3
	elseif round < 0 then
		round = 0
	end
	return GetGlobalDString("text_money_pre", "") .. roundMoney(self:Salary(), round) .. GetGlobalDString("text_money_pos", "")
end

function Player:AddMoney(money)
	self:addMoney(money)
end

function Player:AddMoneyBank(money)
	self:addMoneyBank(money)
end

--[[ Character ]]--
function Player:Level()
	return tonumber(self:GetDString("int_level", "1"))
end

function Player:XP()
	return tonumber(math.Round(self:GetDString("int_xp", "1"), 0))
end

function Player:XPForLevelUp()
	return tonumber(math.Round(self:GetDString("int_xp_for_levelup", "10"), 0))
end

function Player:XPMultiplier()
	return tonumber(math.Round(self:GetDString("float_multiplier", "1.5"), 0))
end

function Player:GetMaxXP()
	local exp = math.pow(self:Level(), self:XPMultiplier())
	local res = math.Round(exp + self:XPForLevelUp(), 1)
	return tonumber(res)
end

--[[ Role ]]--
function Player:GetRoleColor() -- Group Color
	return self:YRPGetRoleColor() -- return Color(int r, int g, int b, int a)
end

function Player:GetRoleUID()
	return tonumber(self:GetDString("roleUniqueID", "0"))
end

function Player:GetRoleCooldown()
	return tonumber(self:GetDInt("int_role_cooldown", "1"))
end

function Player:GetRoleOnDeathRoleUID()
	return tonumber(self:GetDString("int_roleondeath", "0"))
end

function Player:GetRoleName() -- Role Name / "Job" Name
	local RoleName = self:YRPGetRoleName()
	if self:IsUnknown() then
		RoleName = "Unknown"
	end
	return RoleName -- return string
end

function Player:GetLicenseIDs()
	return self:GetDString("licenseIDs", "")
end

function Player:GetLicenseNames()
	return self:GetDString("licenseNames", "")
end

function Player:GetRoleSweps()
	return self:GetDString("sweps", "")
end

--[[ Faction ]]--
function Player:GetFactionUniqueID() -- Faction uniqueID
	return self:YRPGetFactionUID() -- return number
end

function Player:GetFactionName() -- Faction Name
	local FactionName = self:YRPGetFactionName()
	if self:IsUnknown() then
		FactionName = "Unknown"
	end
	return FactionName -- return string
end

function Player:GetFactionColor() -- Faction Color
	return self:YRPGetFactionColor() -- return Color(int r, int g, int b, int a)
end

--[[ Group ]]--
function Player:GetGroupUID() -- Group UID
	return tonumber(self:YRPGetGroupUID()) -- return X (number)
end

function Player:GetGroupName() -- Group Name / "Category" Name
	local GroupName = self:YRPGetGroupName()
	if self:IsUnknown() then
		GroupName = "Unknown"
	end
	return GroupName -- return string
end

function Player:GetGroupColor() -- Group Color
	return self:YRPGetGroupColor() -- return Color(int r, int g, int b, int a)
end

--[[ Name ]]--
function Player:RPName() -- Character Name / Roleplay Name
	local name = self:YRPRPName()
	if self:IsUnknown() then
		name = "Unknown"
	end
	return name -- return string
end

--[[ UserGroup ]]--
function Player:GetUserGroupColor() -- UserGroup Color
	return self:YRPGetUserGroupColor() -- return Color(int r, int g, int b, int a)
end
