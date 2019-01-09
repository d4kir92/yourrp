--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

--[[ Here are the public functions (FOR DEVELOPERS) ]]

--[[ Player Functions ]]--
local Player = FindMetaTable("Player")

function Player:GetLanguage() -- The Language the player selected
	return self:YRPGetLanguage() -- return string
end

function Player:GetLanguageShort() -- The Language the player selected (shortkey)
	return self:YRPGetLanguageShort() -- return string
end

function Player:Slowed()
	return self:GetNWBool("slowed", false)
end

--[[ Stats ]]--
function Player:GetMaxArmor()
	return self:GetNWInt("MaxArmor", 1)
end

function Player:Level()
	return self:GetNWInt("Level", 1)
end

function Player:GetMaxLevel()
	return self:GetNWInt("MaxLevel", 10)
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
	return ((math.Round(self:GetAngles().y - 180, 0) * -1) - 90 ) % 360
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
	return tonumber(self:GetNWString("money", "0")) -- return float
end

function Player:GetMoneyBank() -- Money that the bank is holding
	return tonumber(self:GetNWString("moneybank", "0")) -- return float
end

function Player:Money()
	return self:GetMoney()
end

function Player:MoneyBank()
	return self:GetMoneyBank()
end

function Player:FormattedMoney()
	return self:GetNWString("text_money_pre", "[LOADING PRE]") .. roundMoney(self:Money(), 1) .. self:GetNWString("text_money_pos", "[LOADING POS]")
end

function Player:Salary()
	return tonumber(self:GetNWString("salary", "0"))
end

function Player:FormattedSalary()
	return self:GetNWString("text_money_pre", "[LOADING PRE]") .. roundMoney(self:Salary(), 1) .. self:GetNWString("text_money_pos", "[LOADING POS]")
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
