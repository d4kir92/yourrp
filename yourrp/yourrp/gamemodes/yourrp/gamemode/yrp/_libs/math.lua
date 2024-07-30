--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- Screen
local HA = {}
HA.w = 0
function HScrW()
	return ScrW()
end

function BiggerThen16_9()
	if ScrW() > ScrH() / 9 * 16 then
		HA.w = ScrH() / 9 * 16

		return true
	else
		HA.w = ScrW()

		return false
	end
end

function ScreenFix()
	if BiggerThen16_9() then
		return (ScrW() - (ScrH() / 9 * 16)) / 2
	else
		return 0
	end
end

function PosX()
	return ScreenFix()
end

function ScW()
	if BiggerThen16_9() then
		return ScrW() - 2 * ScreenFix()
	else
		return ScrW()
	end
end

function ScH()
	return ScrH()
end

-- Frame Settings
local fw = 2400
local fh = 1600
function FW()
	return YRP:ctr(fw)
end

function FH()
	return YRP:ctr(fh)
end

function PX()
	return ScrW() / 2 - YRP:ctr(fw) / 2
end

function PY()
	return ScrH() / 2 - YRP:ctr(fh) / 2
end

function BFW()
	if BiggerThen16_9() then
		return ScrH() * 16 / 9 - YRP:ctr(400)
	else
		return ScrW() - YRP:ctr(400)
	end
end

function BFH()
	return ScrH() - YRP:ctr(200)
end

function BPX()
	return ScrW() / 2 - BFW() / 2
end

function BPY()
	return ScrH() / 2 - BFH() / 2
end

-- Datatypes
function GetMaxInt()
	return 999999999
end

-- "Max" Int Value
function GetMaxFloat()
	return 999999999.0
end

-- "Max" Int Value
function btn(bool)
	if bool then
		return 1
	else
		return 0
	end
end

function ggT(_num1, _num2)
	local _ggt = _num1 % _num2
	while _ggt ~= 0 do
		_num1 = _num2
		_num2 = _ggt
		_ggt = _num1 % _num2
	end

	return _num2
end

function getResolutionRatio()
	local _ggt = ggT(ScrW(), ScrH())

	return ScrW() / _ggt, ScrH() / _ggt
end

function getPictureRatio(w, h)
	local _ggt = ggT(w, h)

	return w / _ggt, h / _ggt
end

function lowerToScreen(w, h)
	local tmpW = w
	local tmpH = h
	if w > ScrW() then
		local per = tmpW / ScrW()
		tmpW = tmpW / per
		tmpH = tmpH / per
	end

	if tmpH > ScrH() then
		local per = tmpH / ScrH()
		tmpW = tmpW / per
		tmpH = tmpH / per
	end

	return tmpW, tmpH
end

function ctrF(tmpNumber)
	tmpNumber = 2160 / tmpNumber

	return math.Round(tmpNumber, 8)
end

YRP = YRP or {}
function YRP:ctr(input)
	if input ~= nil then
		return math.Round((tonumber(input) / 2160) * ScrH(), 0)
	else
		return -1
	end
end

function under1080p()
	if ScrH() < 1080 then
		return true
	else
		return false
	end
end

function YRP:fonttr(fontsize)
	if not under1080p() then
		return YRP:ctr(fontsize)
	else
		return fontsize
	end
end

function ctrb(input)
	if input ~= nil then
		if not under1080p() then
			return YRP:ctr(input)
		else
			return input / 2
		end
	else
		return -1
	end
end

function ScrW2()
	return ScrW() / 2
end

function ScrH2()
	return ScrH() / 2
end

function formatMoney(money)
	if IsNotNilAndNotFalse(money) then
		return GetGlobalYRPString("text_money_pre", "") .. money .. GetGlobalYRPString("text_money_pos", "")
	else
		return "[FAILED: formatMoney]"
	end
end

function getTblX(nr, max)
	return nr % max
end

function getTblY(nr, max)
	return (nr / max) - (1 / max) * (nr % max)
end
