--Copyright (C) 2017-2018 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local reload = {}

reload.nextP = 0
reload.nextPC = 0
reload.maxP = 0
reload.statusP = 0

function hudWP(ply, color, weapon)
	--Weapon Primary
	if weapon != NULL then
		if weapon:GetMaxClip1() > -1 or ply:GetAmmoCount(weapon:GetPrimaryAmmoType()) > -1 then
			--Primary
			reload.nextP = weapon:GetNextPrimaryFire()
			reload.nextPC = reload.nextP - CurTime()
			if reload.nextP > CurTime() and reload.statusP == 0 and (reload.nextPC) > 0.6 then
				reload.statusP = 1
				reload.maxP = reload.nextP - CurTime()
			elseif reload.nextP < CurTime() and reload.statusP == 1 then
				reload.statusP = 0
			end
			if reload.nextPC > reload.maxP then
				reload.maxP = reload.nextPC
			end

			local _wptext = ""
			if reload.statusP == 1 then
				_wptext = math.Round(100 * (1 - ((1 / reload.maxP) * reload.nextPC))) .. "%"
			elseif weapon:GetMaxClip1() > -1 then
				_wptext = weapon:Clip1() .. "/" .. weapon:GetMaxClip1()	.. "|" .. ply:GetAmmoCount(weapon:GetPrimaryAmmoType())
			elseif ply:GetAmmoCount(weapon:GetPrimaryAmmoType()) > -1 then
				_wptext = ply:GetAmmoCount(weapon:GetPrimaryAmmoType())
			end

			drawHUDElement("wp", weapon:Clip1(), weapon:GetMaxClip1(), _wptext, nil, color)
		end
	end
end

function hudWPBR(ply)
	drawHUDElementBr("wp")
end
