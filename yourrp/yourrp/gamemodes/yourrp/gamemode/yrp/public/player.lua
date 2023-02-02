--Copyright (C) 2017-2023 D4KiR (https://www.gnu.org/licenses/gpl.txt)

--[[ Here are the public functions (FOR DEVELOPERS) ]]

AddCSLuaFile( "player/hud.lua" )
AddCSLuaFile( "player/interface.lua" )
include( "player/hud.lua" )
include( "player/interface.lua" )

--[[ Player Functions ]]--
local Player = FindMetaTable( "Player" )

function Player:GetRagdollEntity()
	return self:GetYRPEntity( "yrp_ragdoll", NULL )
end

function Player:Revive(pos)
	self.ignorespawnpoint = true
	self:Spawn()
	if pos then
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
	return self:GetYRPBool( "isafk", false)
end

function Player:DND()
	return self:GetYRPBool( "isdnd", false)
end

function Player:IDCardID()
	return self:GetYRPString( "idcardid", "" )
end

function Player:HasOS()
	if self:IsBot() then
		return true
	end
	return self:GetYRPString( "yrp_os", "" ) != ""
end

function Player:OS()
	if self:IsBot() then
		return "windows"
	end
	return self:GetYRPString( "yrp_os", "" )
end

function Player:HasLanguage()
	return self:GetYRPString( "client_lang", "" ) != ""
end

function Player:GetLanguage() -- The Language the player selected
	return self:YRPGetLanguage() -- return string
end

function Player:GetLanguageShort() -- The Language the player selected (shortkey)
	return self:YRPGetLanguageShort() -- return string
end

function Player:YRPGetCountryShort()
	return string.upper(self:GetYRPString( "yrp_country", "LOADING" ) )
end

function Player:YRPGetCountry() -- The Language the player selected
	return YRPGetCountryName(self:YRPGetCountryShort(), "YRPGetCountry" )
end

function Player:Slowed()
	return self:GetYRPBool( "slowed", false)
end

function Player:IsInCombat()
	return self:GetYRPBool( "inCombat", false)
end

--[[ Stats ]]--
function Player:GetMaxArmor()
	return tonumber(self:GetYRPInt( "MaxArmor", 100) )
end

function Player:GetMinLevel()
	return tonumber(self:GetYRPString( "int_level_min", "1" ) )
end

function Player:GetMaxLevel()
	return tonumber(self:GetYRPString( "int_level_max", "100" ) )
end

function Player:Stamina()
	return math.Round(self:GetYRPFloat( "GetCurStamina", 1), 2)
end

function Player:GetMaxStamina()
	return  math.Round(self:GetYRPFloat( "GetMaxStamina", 10), 2)
end

function Player:Hunger()
	return math.Round(self:GetYRPFloat( "hunger", 100.0), 1)
end

function Player:GetMaxHunger()
	return 100.0
end

function Player:Thirst()
	return math.Round(self:GetYRPFloat( "thirst", 100.0), 1)
end

function Player:GetMaxThirst()
	return 100.0
end

function Player:Permille()
	return math.Round(self:GetYRPFloat( "permille", 0.0), 1)
end

function Player:GetMaxPermille()
	return 4.0
end

function Player:Radiation()
	return math.Round(self:GetYRPFloat( "GetCurRadiation", 1), 1)
end

function Player:GetMaxRadiation()
	return math.Round(self:GetYRPFloat( "GetMaxRadiation", 100), 1)
end

function Player:SalaryTime()
	return self:GetYRPInt( "salarytime", 0)
end

function Player:NextSalaryTime()
	return self:GetYRPInt( "nextsalarytime", 0)
end

function Player:CurrentSalaryTime()
	return CurTime() + self:SalaryTime() - 1 - self:NextSalaryTime()
end

function Player:GetCastName()
	return YRP.lang_string(self:GetYRPString( "castname", "" ) )
end

function Player:CastTimeCurrent()
	return math.Round(self:GetYRPFloat( "castcur", 0.0), 1)
end

function Player:CastTimeMax()
	return math.Round(self:GetYRPFloat( "castmax", 1.0), 1)
end

function Player:Ability()
	return self:GetYRPInt( "GetCurAbility", 0)
end

function Player:GetMaxAbility()
	return self:GetYRPInt( "GetMaxAbility", 100)
end

function Player:IsBleeding()
	return self:GetYRPBool( "isbleeding", false)
end

function Player:IsCuffed()
	return self:GetYRPBool( "cuffed" )
end

function Player:IsHungry()
	return self:GetYRPFloat( "hunger", 100.0) < 20.0
end

function Player:IsThirsty()
	return self:GetYRPFloat( "thirst", 100.0) < 20.0
end

function Player:IsRightLegBroken()
	return self:GetYRPBool( "broken_leg_right", false)
end

function Player:IsLeftLegBroken()
	return self:GetYRPBool( "broken_leg_left", false)
end

function Player:IsRightArmBroken()
	return self:GetYRPBool( "broken_arm_right", false)
end

function Player:IsLeftArmBroken()
	return self:GetYRPBool( "broken_arm_left", false)
end

function Player:InJail()
	return self:GetYRPBool( "injail", false)
end

function Player:Condition()
	local _sttext = ""
	if self:IsBleeding() then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string( "LID_youarebleeding" )
	end
	if self:GetYRPBool( "cuffed" ) then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string( "LID_cuffed" )
	end
	if self:GetYRPFloat( "hunger", 100) < 20 then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string( "LID_hungry" )
	end
	if self:GetYRPFloat( "thirst", 100) < 20.0 then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string( "LID_thirsty" )
	end
	if self:GetYRPBool( "broken_leg_right", false) then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string( "LID_yourrightlegisbroken" )
	end
	if self:GetYRPBool( "broken_leg_left", false) then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string( "LID_yourleftlegisbroken" )
	end
	if self:GetYRPBool( "broken_arm_right", false) then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string( "LID_yourrightarmisbroken" )
	end
	if self:GetYRPBool( "broken_arm_left", false) then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string( "LID_yourleftarmisbroken" )
	end
	if self:GetYRPBool( "injail", false) then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string( "LID_jail" ) .. ": " .. self:GetYRPInt( "jailtime", 0)
	end
	return _sttext
end

function Player:CoordAngle()
	if CLIENT then
		return ( (math.Round(EyeAngles().y - 180, 0) * -1) - 90 ) % 360
	else
		return ( (math.Round(self:GetAngles().y - 180, 0) * -1) - 90 ) % 360
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
	if self:GetYRPString( "money", "0" ) != nil then
		return math.Round(tonumber(self:GetYRPString( "money", "0" ) ), 2) -- return float
	else
		return -1
	end
end

function Player:GetMoneyBank() -- Money that the bank is holding
	if self:GetYRPString( "moneybank", "0" ) != nil then
		return math.Round(tonumber(self:GetYRPString( "moneybank", "0" ) ), 2) -- return float
	else
		return -1
	end
end

function Player:Money()
	return self:GetMoney()
end

function Player:MoneyBank()
	return self:GetMoneyBank()
end

function Player:Salary()
	return tonumber(self:GetYRPString( "salary", "0" ) )
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
		return GetGlobalYRPString( "text_money_pre", "" ) .. string.point(money) .. GetGlobalYRPString( "text_money_pos", "" )
	end

	function MoneyFormatRounded(money, round)
		round = round or 1
		if round > 3 then
			round = 3
		elseif round < 0 then
			round = 0
		end
		money = tonumber(money)
		return GetGlobalYRPString( "text_money_pre", "" ) .. roundMoney(money, round) .. GetGlobalYRPString( "text_money_pos", "" )
	end
end

function Player:FormattedMoney()
	return GetGlobalYRPString( "text_money_pre", "" ) .. string.point(self:Money() ) .. GetGlobalYRPString( "text_money_pos", "" )
end

function Player:FormattedMoneyBank()
	return GetGlobalYRPString( "text_money_pre", "" ) .. string.point(self:MoneyBank() ) .. GetGlobalYRPString( "text_money_pos", "" )
end

function Player:FormattedSalary()
	return GetGlobalYRPString( "text_money_pre", "" ) .. string.point(self:Salary() ) .. GetGlobalYRPString( "text_money_pos", "" )
end

function Player:FormattedMoneyRounded(round)
	round = round or 1
	if round > 3 then
		round = 3
	elseif round < 0 then
		round = 0
	end
	return GetGlobalYRPString( "text_money_pre", "" ) .. roundMoney(self:Money(), round) .. GetGlobalYRPString( "text_money_pos", "" )
end

function Player:FormattedMoneyBankRounded(round)
	round = round or 1
	if round > 3 then
		round = 3
	elseif round < 0 then
		round = 0
	end
	return GetGlobalYRPString( "text_money_pre", "" ) .. roundMoney(self:MoneyBank(), round) .. GetGlobalYRPString( "text_money_pos", "" )
end

function Player:FormattedSalaryRounded(round)
	round = round or 1
	if round > 3 then
		round = 3
	elseif round < 0 then
		round = 0
	end
	return GetGlobalYRPString( "text_money_pre", "" ) .. roundMoney(self:Salary(), round) .. GetGlobalYRPString( "text_money_pos", "" )
end

function Player:AddMoney(money)
	self:addMoney(money)
end

function Player:AddMoneyBank(money)
	self:addMoneyBank(money)
end



--[[ Shop ]]--
function Player:HasStorageItem( uid )
	return self:YRPHasStorageItem( uid )
end



--[[ Character ]]--
function Player:Level()
	return tonumber(self:GetYRPString( "int_level", "1" ) )
end

function Player:XP()
	return tonumber(math.Round(self:GetYRPInt( "int_xp", "1" ), 0) )
end

function Player:XPForLevelUp()
	return tonumber(math.Round(self:GetYRPString( "int_xp_for_levelup", "10" ), 0) )
end

function Player:XPMultiplier()
	return tonumber(math.Round(self:GetYRPString( "float_multiplier", "1.5" ), 0) )
end

function Player:CalculateMaxXP(lvl)
	local exp = math.pow(lvl, self:XPMultiplier() )
	local res = math.Round(exp + self:XPForLevelUp(), 1)
	return tonumber(res)
end

function Player:GetMaxXP()
	return self:CalculateMaxXP(self:Level() )
end

function Player:MaxXP()
	return self:GetMaxXP()
end

--[[ Role ]]--
function Player:GetRoleColor() -- Group Color
	return self:YRPGetRoleColor() -- return Color(int r, int g, int b, int a)
end

function Player:GetRoleUID()
	return tonumber(self:GetYRPString( "roleUniqueID", "0" ) )
end

function Player:GetRoleCooldown()
	return tonumber(self:GetYRPInt( "int_role_cooldown", "1" ) )
end

function Player:GetRoleOnDeathRoleUID()
	return tonumber(self:GetYRPString( "int_roleondeath", "0" ) )
end

function Player:GetRoleName() -- Role Name / "Job" Name
	if self.YRPGetRoleName then
		local RoleName = self:YRPGetRoleName()
		if IsValid(self) then
			local prefix = self:GetYRPString( "spec_prefix", "" )
			local suffix = self:GetYRPString( "spec_suffix", "" )

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
	return "BROKEN"
end

function YRPAddToTable( tTab, sTab )
	for i, v in pairs( sTab ) do
		if !strEmpty( v ) then
			table.insert( tTab, v )
		end
	end
end

function Player:GetLicenseIDs()
	local LIDs1 = self:GetYRPString( "licenseIDs1", "" )
	local LIDs2 = self:GetYRPString( "licenseIDs2", "" )
	local LIDs3 = self:GetYRPString( "licenseIDs3", "" )

	if self.LIDs == nil or self.licenseIDsVersion != self:GetYRPInt( "licenseIDsVersion", 0 ) then
		self.licenseIDsVersion = self:GetYRPInt( "licenseIDsVersion", 0 )
		self.LIDs = {}
		YRPAddToTable( self.LIDs, string.Explode( ",", LIDs1 ) )
		YRPAddToTable( self.LIDs, string.Explode( ",", LIDs2 ) )
		YRPAddToTable( self.LIDs, string.Explode( ",", LIDs3 ) )
	end

	return self.LIDs
end

function Player:GetRoleSweps()
	return self:GetYRPString( "sweps", "" )
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
	return tonumber(self:YRPGetGroupUID() ) -- return X (number)
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
	if !strEmpty(self:GetYRPString( "usergroupDisplayname", "" ) ) then
		return self:GetYRPString( "usergroupDisplayname", "" )
	else
		return string.upper(self:GetUserGroup() )
	end
end
