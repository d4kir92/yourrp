--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local money = Material("icon16/money.png")

function hudMO(ply, color)
	--Money
	local _money = tonumber(ply:GetNWString("money", "-1"))
	local _pre = ply:GetNWString("text_money_pre", "[LOADING PRE]")
	local _pos = ply:GetNWString("text_money_pos", "[LOADING POS]")
	_money = roundMoney(_money, 1)
	local _motext = _pre .. tostring(_money) .. _pos
	local _salary = tonumber(ply:GetNWString("salary", "-1"))
	if _salary != nil then
		if tonumber(_salary) > 0 then
			_motext = _motext .. " (+" .. ply:GetNWString("text_money_pre") .. roundMoney(_salary, 1) .. ply:GetNWString("text_money_pos") .. ")"
			_salaryMin = CurTime() + ply:GetNWInt("salarytime") - 1 - ply:GetNWInt("nextsalarytime")
			_salaryMax = ply:GetNWInt("salarytime")
		else
			_salaryMin = 1
			_salaryMax = 1
		end
		drawHUDElement("mo", _salaryMin, _salaryMax, _motext, money, color)
	end
end

function hudMOBR()
	drawHUDElementBr("mo")
end
