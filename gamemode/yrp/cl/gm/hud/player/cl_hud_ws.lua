--Copyright (C) 2017-2018 Arno Zura (https://www.gnu.org/licenses/gpl.txt )

local reload = {}

reload.nextS = 0
reload.nextSC = 0
reload.maxS = 0
reload.statusS = 0

function hudWS(ply, color, weapon )
	if weapon != NULL then
		if ply:GetAmmoCount(weapon:GetSecondaryAmmoType()) > 0 then
			reload.nextS = weapon:GetNextSecondaryFire()
			reload.nextSC = reload.nextS - CurTime()
			if reload.nextS > CurTime() and reload.statusS == 0 and (reload.nextSC ) > 0.3 then
				reload.statusS = 1
				reload.maxS = reload.nextS - CurTime()
			elseif reload.nextS < CurTime() and reload.statusS == 1 then
				reload.statusS = 0
			end
			if reload.nextSC > reload.maxS then
				reload.maxS = reload.nextSC
			end

			local _wstext = ""
			if reload.statusS == 1 then
				_wstext = math.Round(100 * (1 - ((1 / reload.maxS ) * reload.nextSC ) ) ) .. "%"
			else
				_wstext = ply:GetAmmoCount(weapon:GetSecondaryAmmoType())
			end
			drawHUDElement("ws", ply:GetAmmoCount(weapon:GetSecondaryAmmoType()), ply:GetAmmoCount(weapon:GetSecondaryAmmoType()), _wstext, nil, color )
		end
	end
end

function hudWSBR(ply, weapon )
	if weapon != NULL then
		if ply:GetAmmoCount(weapon:GetSecondaryAmmoType()) > 0 then
			drawHUDElementBr("ws" )
		end
	end
end
