--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function btn( bool )
	if bool then
		return 1
	else
		return 0
	end
end

function ggT( _num1, _num2 )
	local _ggt = _num1 % _num2
	while ( _ggt != 0 ) do
		_num1 = _num2
		_num2 = _ggt

		_ggt = _num1 % _num2
	end
	return _num2
end

function getResolutionRatio()
	local _ggt = ggT( ScrW(), ScrH() )
	return ScrW()/_ggt, ScrH()/_ggt
end

function getPictureRatio( w, h )
	local _ggt = ggT( w, h )
	return w/_ggt, h/_ggt
end

function lowerToScreen( w, h )
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

function ctrF( tmpNumber )
	tmpNumber = 2160/tmpNumber
	return math.Round( tmpNumber, 8 )
end

function ctr( input )
	if input != nil then
		return math.Round( (tonumber(input) / 2160) * ScrH(), 0 )
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

function fontr( fontsize )
	if !under1080p() then
		return ctr( fontsize )
	else
		return fontsize
	end
end

function ctrb( input )
	if input != nil then
		if !under1080p() then
			return ctr( input )
		else
			return input/2
		end
	else
		return -1
	end
end

function ScrW2()
	return ( ScrW() / 2 )
end

function ScrH2()
	return ( ScrH() / 2 )
end

function formatMoney( money, ply )
	if CLIENT then
		return ply:GetNWString( "text_money_pre" ).. money .. ply:GetNWString( "text_money_pos" )
	else
		return "[FAILED]" .. money .. "[FAILED]"
	end
end

function getTblX( nr, max )
	return nr % max
end

function getTblY( nr, max )
	return ( nr / max ) - ( 1 / max ) * ( nr % max )
end
