--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local _sttext = ""

function showST( ply )
	if _sttext != "" then
		return true
	end
	return false
end

function hudST( ply, color )
	--Status
	_sttext = ""
	local _st_m = 0
	if ply:IsBleeding() then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string( "youarebleeding" )
		if _st_m < 3 then
			_st_m = 3
		end
	end
	if ply:GetNWBool( "cuffed" ) then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string( "cuffed" )
		if _st_m < 2 then
			_st_m = 2
		end
	end
	if ply:GetNWBool( "weaponlowered" ) then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string( "weaponlowered" )
		if _st_m < 1 then
			_st_m = 1
		end
	end
	if ply:GetNWFloat( "hunger", 100 ) < 20 then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string( "hungry" )
		if _st_m < 2 then
			_st_m = 2
		end
	end
	if ply:GetNWFloat( "thirst", 100 ) < 20.0 then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string( "thirsty" )
		if _st_m < 2 then
			_st_m = 2
		end
	end
	if ply:GetNWBool( "broken_leg_right", false ) then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string( "yourrightlegisbroken" )
		if _st_m < 2 then
			_st_m = 2
		end
	end
	if ply:GetNWBool( "broken_leg_left", false ) then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string( "yourleftlegisbroken" )
		if _st_m < 2 then
			_st_m = 2
		end
	end
	if ply:GetNWBool( "broken_arm_right", false ) then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string( "yourrightarmisbroken" )
		if _st_m < 2 then
			_st_m = 2
		end
	end
	if ply:GetNWBool( "broken_arm_left", false ) then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string( "yourleftarmisbroken" )
		if _st_m < 2 then
			_st_m = 2
		end
	end
	if ply:GetNWBool( "injail", false ) then
		if _sttext != "" then
			_sttext = _sttext .. ", "
		end
		_sttext = _sttext .. YRP.lang_string( "jail" ) .. ": " .. ply:GetNWInt( "jailtime", 0 )
		if _st_m < 2 then
			_st_m = 2
		end
	end
	local _st_c = Color( 0, 0, 0, 0 )
	if _st_m == 3 then
		_st_c = Color( 255, 0, 0, HudV( "colbga" ) )
	elseif _st_m == 2 then
		_st_c = Color( 255, 255, 0, HudV( "colbga" ) )
	elseif _st_m == 1 then
		_st_c = Color( 0, 255, 0, HudV( "colbga" ) )
	end
	if tonumber( HudV("stto") ) == 1 and showST( ply ) then
		drawHUDElement( "st", 1, 1, _sttext, nil, _st_c )
	end
end

function hudSTBR()
	if showST( ply ) then
		drawHUDElementBr( "st" )
	end
end
