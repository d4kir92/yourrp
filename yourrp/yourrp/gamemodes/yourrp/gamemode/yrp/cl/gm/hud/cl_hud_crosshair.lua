--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local _hl2Weapons = {}
table.insert(_hl2Weapons, "weapon_357")
table.insert(_hl2Weapons, "weapon_alyxgun")
table.insert(_hl2Weapons, "weapon_annabelle")
table.insert(_hl2Weapons, "weapon_ar2")
table.insert(_hl2Weapons, "weapon_brickbat")
table.insert(_hl2Weapons, "weapon_bugbait")
table.insert(_hl2Weapons, "weapon_crossbow")
table.insert(_hl2Weapons, "weapon_crowbar")
table.insert(_hl2Weapons, "weapon_frag")
table.insert(_hl2Weapons, "weapon_physgun")
table.insert(_hl2Weapons, "weapon_physcannon")
table.insert(_hl2Weapons, "weapon_pistol")
table.insert(_hl2Weapons, "weapon_rpg")
table.insert(_hl2Weapons, "weapon_shotgun")
table.insert(_hl2Weapons, "weapon_smg1")
table.insert(_hl2Weapons, "weapon_striderbuster")
table.insert(_hl2Weapons, "weapon_stunstick")
table.insert(_hl2Weapons, "weapon_slam")
function isHl2Weapon(weapon)
	if weapon == NULL then return false end
	if table.HasValue(_hl2Weapons, weapon:GetClass()) then return true end

	return false
end

local alphaFade = 1
local reloading = 0
local aimdownsights = 0
local ch_attack1 = 1
local ch_attack1_old = 1
local oldx = ScrW() / 2
local oldy = ScrH() / 2
function YRPHudCrosshair()
	local lply = LocalPlayer()
	if lply:Alive() and GetGlobalYRPBool("bool_yrp_crosshair", false) and not contextMenuOpen then
		local weapon = lply:GetActiveWeapon()
		if weapon ~= NULL and weapon and (weapon.DrawCrosshair or isHl2Weapon(weapon)) then
			local nextPrimary = weapon:GetNextPrimaryFire()
			if nextPrimary <= CurTime() + 0.1 and lply:KeyDown(IN_ATTACK) then
				ch_attack1 = ch_attack1 + 2
			else
				ch_attack1 = ch_attack1 - 1
			end

			if lply:KeyDown(IN_RELOAD) and aimdownsights == 0 then
				alphaFade = 0
				aimdownsights = 1
				timer.Simple(
					weapon:GetNextPrimaryFire() - CurTime(),
					function()
						aimdownsights = 0
					end
				)
			end

			if lply:KeyDown(IN_ATTACK2) and reloading == 0 then
				alphaFade = 0
				reloading = 1
				timer.Simple(
					weapon:GetNextPrimaryFire() - CurTime(),
					function()
						reloading = 0
					end
				)
			end

			if lply:KeyDown(IN_SPEED) and lply:KeyDown(IN_FORWARD) and reloading == 0 then
				alphaFade = alphaFade - 0.05
				if alphaFade < 0.5 then
					alphaFade = 0.5
				end

				ch_attack1 = ch_attack1 + 2
				if ch_attack1 < 0 then
					ch_attack1 = 0
				elseif ch_attack1 > 20 then
					ch_attack1 = 20
				end
			elseif reloading == 0 then
				alphaFade = alphaFade + 0.1
				if alphaFade > 1 then
					alphaFade = 1
				end
			end

			if math.Clamp then
				ch_attack1 = math.Clamp(ch_attack1, 0, 6)
			else
				ch_attack1 = 1
			end

			ch_attack1_old = Lerp(7 * FrameTime(), ch_attack1_old, ch_attack1)
			if lply:GetHudDesignName() ~= "notloaded" and lply:Alive() then
				if weapon:GetNWBool("Ironsights") then
					alphaFade = 0

					return
				end

				-- Render Errors break this, restart game fix that
				local ptr = lply:GetEyeTrace().HitPos:ToScreen()
				local cx, cy = ptr.x, ptr.y
				oldx = Lerp(8 * FrameTime(), oldx, cx)
				oldy = Lerp(8 * FrameTime(), oldy, cy)
				local gap = 8 / 2
				if ch_attack1_old >= 1 then
					gap = gap * ch_attack1_old
				end

				local sw = 10
				local sh = 1
				surface.SetDrawColor(0, 0, 0, 255 * alphaFade)
				local br = 1
				surface.DrawRect(oldx - sw - gap - br, oldy - sh / 2 - br, sw + 2 * br, sh + 2 * br)
				surface.DrawRect(oldx + gap - br, oldy - sh / 2 - br, sw + 2 * br, sh + 2 * br)
				surface.DrawRect(oldx - sh / 2 - br, oldy - sw - gap - br, sh + 2 * br, sw + 2 * br)
				surface.DrawRect(oldx - sh / 2 - br, oldy + gap - br, sh + 2 * br, sw + 2 * br)
				surface.SetDrawColor(255, 255, 255, 255 * alphaFade)
				surface.DrawRect(oldx - sw - gap, oldy - sh / 2, sw, sh)
				surface.DrawRect(oldx + gap, oldy - sh / 2, sw, sh)
				surface.DrawRect(oldx - sh / 2, oldy - sw - gap, sh, sw)
				surface.DrawRect(oldx - sh / 2, oldy + gap, sh, sw)
			end
		end
	end
end