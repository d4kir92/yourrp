--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

function enough_space(ply, pos)
	local tr = {
		start = pos,
		endpos = pos,
		mins = Vector(-18, -18, 0),
		maxs = Vector(18, 18, 75),
		filter = ply
	}

	local hullTrace = util.TraceHull(tr)
	if !hullTrace.Hit then
		return true
	else
		return false
	end
end

function get_ground_pos(ply, pos)
	local tr = {
		start = pos,
		endpos = pos-Vector(0, 0, 9999),
		mins = Vector(-18, -18, 0),
		maxs = Vector(18, 18, 75)
	}

	local hullTrace = util.TraceHull(tr)
	if hullTrace.Hit then
		return hullTrace.HitPos + Vector(0, 0, 2)
	else
		return pos
	end
end

function tp_to(ply, pos)
	local _pos = Vector(pos[1], pos[2], pos[3])
	local _angle = Angle(0, 0, 0)
	local _tmpAngle = ply:EyeAngles() or ply:GetAngles()
	if ply:IsValid() then
		if ply:IsPlayer() then
			ply:SetEyeAngles(_angle)
		else
			ply:SetAngles(_angle)
		end
		if enough_space(ply, _pos + Vector(0, 0, 2)) then
			local __pos = get_ground_pos(ply, _pos + Vector(0, 0, 2))

			ply:SetPos(__pos)
			if ply:IsPlayer() then
				ply:SetEyeAngles(_tmpAngle)
			else
				ply:SetAngles(_tmpAngle)
			end
		else
			for i = 1, 3 do
				for j = 0, 360, 45 do
					_angle:RotateAroundAxis(ply:GetUp(), 45)
					local _enough_space = enough_space(ply, _pos + Vector(0, 0, 2) + _angle:Forward() * 44 * i)
					if _enough_space then
						local __pos = get_ground_pos(ply, _pos + Vector(0, 0, 2) + _angle:Forward() * 44 * i)
						ply:SetPos(__pos)
						if ply:IsPlayer() then
							ply:SetEyeAngles(_tmpAngle)
						else
							ply:SetAngles(_tmpAngle)
						end
						return
					end
				end
			end
		end
	end
end
