--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

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
	return self:GetNW2Bool("isafk", false)
end

function Player:DND()
	return self:GetNW2Bool("isdnd", false)
end

function Player:IDCardID()
	return self:GetNW2String("idcardid", "")
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
	return tonumber(self:GetNW2Int("MaxArmor", 100))
end

function Player:GetMinLevel()
	return tonumber(self:GetNW2String("int_level_min", "1"))
end

function Player:GetMaxLevel()
	return tonumber(self:GetNW2String("int_level_max", "100"))
end

function Player:Stamina()
	return math.Round(self:GetNW2Float("GetCurStamina", 1), 2)
end

function Player:GetMaxStamina()
	return  math.Round(self:GetNW2Float("GetMaxStamina", 10), 2)
end

function Player:Hunger()
	return math.Round(self:GetNW2Float("hunger", 100.0), 1)
end

function Player:GetMaxHunger()
	return 100.0
end

function Player:Thirst()
	return math.Round(self:GetNW2Float("thirst", 100.0), 1)
end

function Player:GetMaxThirst()
	return 100.0
end

function Player:Permille()
	return math.Round(self:GetNW2Float("permille", 0.0), 1)
end

function Player:GetMaxPermille()
	return 4.0
end

function Player:Radiation()
	return math.Round(self:GetNW2Float("GetCurRadiation", 1), 1)
end

function Player:GetMaxRadiation()
	return math.Round(self:GetNW2Float("GetMaxRadiation", 100), 1)
end

function Player:SalaryTime()
	return self:GetNW2Int("salarytime", 0)
end

function Player:NextSalaryTime()
	return self:GetNW2Int("nextsalarytime", 0)
end

function Player:CurrentSalaryTime()
	return CurTime() + self:SalaryTime() - 1 - self:NextSalaryTime()
end

function Player:GetCastName()
	return YRP.lang_string(self:GetNW2String("castname", ""))
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
	return self:GetNW2Float("hunger", 100.0) < 20.0
end

function Player:IsThirsty()
	return self:GetNW2Float("thirst", 100.0) < 20.0
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

function Player:Drink(num, alc) -- Add num to thirst
	self:YRPDrink(num, alc)
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

function string.point(num)
	if num == nil then
		return num
	end

	if ( isnumber( num ) ) then
		num = string.format( "%f", num )
		num = string.match( num, "^(.-)%.?0*$" ) -- Remove trailing zeros
	end

	local k
	while true do
		num, k = string.gsub( num, "^(-?%d+)(%d%d%d)", "%1.%2" )
		if ( k == 0 ) then break end
	end
	return num
end

if CLIENT then
	function MoneyFormat(money)
		money = tonumber(money)
		return GetGlobalString("text_money_pre", "") .. string.point(money) .. GetGlobalString("text_money_pos", "")
	end

	function MoneyFormatRounded(money, round)
		round = round or 1
		if round > 3 then
			round = 3
		elseif round < 0 then
			round = 0
		end
		money = tonumber(money)
		return GetGlobalString("text_money_pre", "") .. roundMoney(money, round) .. GetGlobalString("text_money_pos", "")
	end
end

function Player:FormattedMoney()
	return GetGlobalString("text_money_pre", "") .. string.point(self:Money()) .. GetGlobalString("text_money_pos", "")
end

function Player:FormattedMoneyBank()
	return GetGlobalString("text_money_pre", "") .. string.point(self:MoneyBank()) .. GetGlobalString("text_money_pos", "")
end

function Player:FormattedSalary()
	return GetGlobalString("text_money_pre", "") .. string.point(self:Salary()) .. GetGlobalString("text_money_pos", "")
end

function Player:FormattedMoneyRounded(round)
	round = round or 1
	if round > 3 then
		round = 3
	elseif round < 0 then
		round = 0
	end
	return GetGlobalString("text_money_pre", "") .. roundMoney(self:Money(), round) .. GetGlobalString("text_money_pos", "")
end

function Player:FormattedMoneyBankRounded(round)
	round = round or 1
	if round > 3 then
		round = 3
	elseif round < 0 then
		round = 0
	end
	return GetGlobalString("text_money_pre", "") .. roundMoney(self:MoneyBank(), round) .. GetGlobalString("text_money_pos", "")
end

function Player:FormattedSalaryRounded(round)
	round = round or 1
	if round > 3 then
		round = 3
	elseif round < 0 then
		round = 0
	end
	return GetGlobalString("text_money_pre", "") .. roundMoney(self:Salary(), round) .. GetGlobalString("text_money_pos", "")
end

function Player:AddMoney(money)
	self:addMoney(money)
end

function Player:AddMoneyBank(money)
	self:addMoneyBank(money)
end

--[[ Character ]]--
function Player:Level()
	return tonumber(self:GetNW2String("int_level", "1"))
end

function Player:XP()
	return tonumber(math.Round(self:GetNW2Int("int_xp", "1"), 0))
end

function Player:XPForLevelUp()
	return tonumber(math.Round(self:GetNW2String("int_xp_for_levelup", "10"), 0))
end

function Player:XPMultiplier()
	return tonumber(math.Round(self:GetNW2String("float_multiplier", "1.5"), 0))
end

function Player:CalculateMaxXP(lvl)
	local exp = math.pow(lvl, self:XPMultiplier())
	local res = math.Round(exp + self:XPForLevelUp(), 1)
	return tonumber(res)
end

function Player:GetMaxXP()
	return self:CalculateMaxXP(self:Level())
end

function Player:MaxXP()
	return self:GetMaxXP()
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
	local RoleName = self:YRPGetRoleName()
	if IsValid(self) then
		local prefix = self:GetNW2String( "spec_prefix", "" )
		local suffix = self:GetNW2String( "spec_suffix", "" )

		if !strEmpty( prefix ) then
			RoleName = prefix .. " " .. RoleName
		end
		if !strEmpty( suffix ) then
			RoleName = RoleName .. " " .. suffix
		end
		return RoleName -- return string
	else
		return self:Nick()
	end
	return RoleName -- return string
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
function Player:GetFactionUID() -- Faction uniqueID
	return self:YRPGetFactionUID() -- return number
end
function Player:GetFactionUniqueID() -- Faction uniqueID
	return self:YRPGetFactionUID() -- return number
end

function Player:GetFactionName() -- Faction Name
	local FactionName = self:YRPGetFactionName()
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
	return GroupName -- return string
end

function Player:GetGroupColor() -- Group Color
	return self:YRPGetGroupColor() -- return Color(int r, int g, int b, int a)
end

--[[ Name ]]--
function Player:RPName() -- Character Name / Roleplay Name
	if IsValid(self) then
		local name = self:YRPRPName()
		return name -- return string
	else
		return self:Nick()
	end
end

--[[ UserGroup ]]--
function Player:GetUserGroupColor() -- UserGroup Color
	return self:YRPGetUserGroupColor() -- return Color(int r, int g, int b, int a)
end

function Player:GetUserGroupNice() -- UserGroup Display Name, displayname
	if !strEmpty(self:GetNW2String("usergroupDisplayname", "")) then
		return self:GetNW2String("usergroupDisplayname", "")
	else
		return string.upper(self:GetUserGroup())
	end
end