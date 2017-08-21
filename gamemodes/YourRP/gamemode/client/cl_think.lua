//Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

//cl_think.lua

local chatisopen = 0
_menuIsOpen = 0
_thirdperson = 0
local _thirdpersonC = 0
local keyCooldown = 0.08
local pressedKey = CurTime() + keyCooldown
local _lastkey = nil
local GUIToggled = false
ch_attack1 = 0

local keys = {}
keys["_hold"] = 0

function useFunction( string )
	if string == nil then
		return
	end
	local ply = LocalPlayer()
	local eyeTrace = ply:GetEyeTrace()

	if chatisopen == 0 then
		if string == "scoreboard" and isScoreboardOpen then
			gui.EnableScreenClicker( true )
		elseif string == "openRoleMenu" then
			if roleMenuWindow != nil then
				roleMenuWindow:Remove()
				roleMenuWindow = nil
				_menuIsOpen = 0
			elseif _menuIsOpen == 0 then
				_menuIsOpen = 1
				openRoleMenu()
			end
		elseif string == "openBuyMenu" then
			if _buyWindow != nil then
				_buyWindow:Remove()
				_buyWindow = nil
				_menuIsOpen = 0
			elseif _menuIsOpen == 0 then
				_menuIsOpen = 1
				openBuyMenu()
			end
		elseif string == "openSettings" then
			if settingsWindow != nil then
				settingsWindow:Remove()
				settingsWindow = nil
				_menuIsOpen = 0
			elseif _menuIsOpen == 0 then
				_menuIsOpen = 1
				openSettings()
			end
		elseif string == "ViewChange" then
			_thirdpersonC = _thirdpersonC + 1
			if _thirdpersonC > 2 then
				_thirdpersonC = 0
			end

			if _thirdpersonC == 0 then
				_thirdperson = 0
			elseif _thirdpersonC == 1 then
				_thirdperson = 1
			elseif _thirdpersonC == 2 then
				_thirdperson = 2
			end
		elseif string == "openMap" then
			if mapWindow != nil then
				mapWindow:Remove()
				mapWindow = nil
				_menuIsOpen = 0
			elseif _menuIsOpen == 0 then
				_menuIsOpen = 1
				net.Start( "askCoords")
					net.WriteEntity( LocalPlayer() )
				net.SendToServer()
			end
		elseif string == "openInteractMenu" then
			if eyeTrace.Entity:IsPlayer() then
				if _windowInteract != nil then
					_windowInteract:Remove()
					_windowInteract = nil
					_menuIsOpen = 0
				elseif _menuIsOpen == 0 then
					_menuIsOpen = 1
					openInteractMenu( eyeTrace.Entity:SteamID() )
				end
			/*else
				if _windowInteract != nil then
					_windowInteract:Close()
					_windowInteract = nil
					_menuIsOpen = 0
				else
					_menuIsOpen = 1
					openInteractMenu( "STEAM_0:1:20900349" )
				end*/
			end
		elseif string == "openDoorOptions" then
			if eyeTrace.Entity:GetClass() == "prop_door_rotating" or eyeTrace.Entity:GetClass() == "func_door" or eyeTrace.Entity:GetClass() == "func_door_rotating" then
				if _doorWindow != nil and keys["_hold"] == 0 then
					keys["_hold"] = 1
					_doorWindow:Remove()
					_doorWindow = nil
					_menuIsOpen = 0
					timer.Simple( 1, function()
						keys["_hold"] = 0
					end)
				elseif _doorWindow == nil and keys["_hold"] == 0 then
					keys["_hold"] = 1
					_menuIsOpen = 1
					openDoorOptions( eyeTrace.Entity, eyeTrace.Entity:GetNWInt( "buildingID" ) )
					timer.Simple( 1, function()
						keys["_hold"] = 0
					end)
				end
			end
		elseif string == "F3Toggle" then
			GUIToggled = not GUIToggled
			gui.EnableScreenClicker( GUIToggled )
			_menuIsOpen = 0
		end
	end
end

function keyDown( key, string, string2 )
	local ply = LocalPlayer()
	if keys[tostring(key)] == nil then
		keys[tostring(key)] = false
	end
	if ply:KeyDown(key) and !keys[tostring(key)] then
		keys[tostring(key)] = true
		timer.Simple( 0.2, function()
			if ply:KeyDown(key) then
				if string2 != nil then
					useFunction( string2 )
				end
			else
				if string != nil then
					useFunction( string )
				end
			end
			keys[tostring(key)] = false
		end)
	end
end

function keyPressed( key, string, string2 )
	if keys[tostring(key)] == nil then
		keys[tostring(key)] = false
	end
	if input.IsKeyDown(key) and !keys[tostring(key)] then
		keys[tostring(key)] = true
		timer.Simple( 0.2, function()
			if input.IsKeyDown(key) then
				if string2 != nil then
					useFunction( string2 )
				end
			else
				if string != nil then
					useFunction( string )
				end
			end
			keys[tostring(key)] = false
		end)
	end
end

function KeyPress()
	keyDown( IN_ATTACK2, "scoreboard", nil )

	keyPressed( KEY_F2, "openRoleMenu", nil )
	keyPressed( KEY_F4, "openBuyMenu", nil )
	keyPressed( KEY_F7, "openSettings", nil )

	keyPressed( KEY_F3, "F3Toggle", nil )

	keyPressed( KEY_B, "ViewChange", nil )

	keyPressed( KEY_M, "openMap", nil )

	keyPressed( KEY_E, "openInteractMenu", "openDoorOptions" )
end
hook.Add( "Think", "Thinker", KeyPress)

hook.Add( "StartChat", "HasStartedTyping", function( isTeamChat )
	chatisopen = 1
end )

hook.Add( "FinishChat", "ClientFinishTyping", function()
	chatisopen = 0
end )

local _savePos = Vector( 0, 0, 0 )
_lookAtEnt = nil
local function yrpCalcView( ply, pos, angles, fov )
	if ply:Alive() then
		if ply:GetActiveWeapon() != nil then
			local weapon = ply:GetActiveWeapon()
			if weapon != NULL then
				if weapon:GetClass() != nil then
					local _weaponName = string.lower( tostring( ply:GetActiveWeapon():GetClass() ) )
					if !string.find( _weaponName, "lightsaber", 0, false ) then
						local view = {}
						if ply:Alive() and ply:GetModel() != "models/player.mdl" and !ply:InVehicle() then
							if ply:LookupBone( "ValveBiped.Bip01_Head1" ) != nil then
								pos2 = ply:GetBonePosition( ply:LookupBone( "ValveBiped.Bip01_Head1" ) ) + ( angles:Forward() * 12 * ply:GetModelScale() )
							end
							if _thirdperson == 2 then
								local dist = 150 * ply:GetModelScale()

								local _tmpThick = 12
								local tr = util.TraceHull( {
									start = pos - ( angles:Forward() * 1 ),
									endpos = pos - ( angles:Forward() * dist ),
									filter = {LocalPlayer(),LocalPlayer():GetActiveWeapon()},
									mins = Vector( -_tmpThick, -_tmpThick, -_tmpThick ),
									maxs = Vector( _tmpThick, _tmpThick, _tmpThick ),
									mask = MASK_SHOT_HULL
								} )
								if( tr.HitPos:Distance( pos ) < dist - 1 ) and !tr.HitNonWorld then
									dist = tr.HitPos:Distance( pos )
								end
								if ply:LookupBone( "ValveBiped.Bip01_Head1" ) != nil then
									view.origin = ply:GetBonePosition( ply:LookupBone( "ValveBiped.Bip01_Head1" ) ) - ( angles:Forward() * dist ) + Vector( 0, 0, 16*ply:GetModelScale() )
									_savePos = view.origin
									view.angles = angles
									view.fov = fov
									view.drawviewer = true
									return view
								else
									view.origin = ply:GetPos() - ( angles:Forward() * dist ) + Vector( 0, 0, 16*ply:GetModelScale() )
									_savePos = view.origin
									view.angles = angles
									view.fov = fov
									view.drawviewer = true
									return view
								end
							elseif _thirdperson == 0 then
								//Disabled
							elseif _thirdperson == 1 then
								if ply:LookupBone( "ValveBiped.Bip01_Head1" ) != nil then
									pos2 = ply:GetBonePosition( ply:LookupBone( "ValveBiped.Bip01_Head1" ) ) + ( angles:Forward() * 10 * ply:GetModelScale() ) + ( angles:Up() * 10 * ply:GetModelScale() )
									view.origin = pos2
									_savePos = pos2
									view.angles = angles
									view.fov = fov
									view.drawviewer = true

									return view
								end
							end
						else
							//Disabled
						end
					else
						//LocalPlayer():PrintMessage( HUD_PRINTTALK, _weaponName )
					end
				end
			end
		end
	end
end
hook.Add( "CalcView", "MyCalcView", yrpCalcView )

function showPlayermodel()
	if _thirdperson == 0 then
		return false
	else
		return true
	end
end
hook.Add( "ShouldDrawLocalPlayer", "ShowPlayermodel", showPlayermodel )
//PrintTable( hook.GetTable() )
