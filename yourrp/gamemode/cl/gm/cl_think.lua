--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--cl_think.lua

local chatisopen = false
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

	if !chatisopen then
		if string == "scoreboard" and isScoreboardOpen then
			gui.EnableScreenClicker( true )
		elseif string == "openCharMenu" and isNoMenuOpen() then
			openCharacterSelection()
		elseif string == "openInventory" then
			if yrp_inventory != nil then
				yrp_inventory.window:Remove()
				yrp_inventory = nil
			elseif isNoMenuOpen() then
				open_inventory()
			end
		elseif string == "openRoleMenu" then
			if roleMenuWindow != nil then
				roleMenuWindow:Remove()
				roleMenuWindow = nil
			elseif isNoMenuOpen() then
				openRoleMenu()
			end
		elseif string == "openBuyMenu" then
			if _buyWindow != nil then
				_buyWindow:Remove()
				_buyWindow = nil
			elseif isNoMenuOpen() then
				openBuyMenu()
			end
		elseif string == "openSettings" then
			if settingsWindow != nil then
				settingsWindow:Remove()
				settingsWindow = nil
			elseif isNoMenuOpen() then
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
			elseif isNoMenuOpen() then
				net.Start( "askCoords")
					net.WriteEntity( LocalPlayer() )
				net.SendToServer()
			end
		elseif string == "openInteractMenu" then
			if eyeTrace.Entity:IsPlayer() then
				if _windowInteract != nil then
					_windowInteract:Remove()
					_windowInteract = nil
					gui.EnableScreenClicker( false )
				elseif isNoMenuOpen() then
					openInteractMenu( eyeTrace.Entity:SteamID() )
				end
				--[[
			else
				if _windowInteract != nil then
					_windowInteract:Remove()
					_windowInteract = nil
					gui.EnableScreenClicker( false )
				else
					openInteractMenu( "STEAM_0:1:20900349" )
				end
				]]--
			end
		elseif string == "openOptions" then
			if eyeTrace.Entity:GetClass() == "prop_door_rotating" or eyeTrace.Entity:GetClass() == "func_door" or eyeTrace.Entity:GetClass() == "func_door_rotating" then
				if _doorWindow != nil and keys["_hold"] == 0 then
					keys["_hold"] = 1
					_doorWindow:Remove()
					_doorWindow = nil
					timer.Simple( 1, function()
						keys["_hold"] = 0
					end)
				elseif _doorWindow == nil and keys["_hold"] == 0 then
					keys["_hold"] = 1
					openDoorOptions( eyeTrace.Entity, eyeTrace.Entity:GetNWInt( "buildingID" ) )
					timer.Simple( 1, function()
						keys["_hold"] = 0
					end)
				end
			elseif eyeTrace.Entity:IsVehicle() then
				if _vehicleWindow != nil and keys["_hold"] == 0 then
					keys["_hold"] = 1
					_vehicleWindow:Remove()
					_vehicleWindow = nil
					timer.Simple( 1, function()
						keys["_hold"] = 0
					end)
				elseif _vehicleWindow == nil and keys["_hold"] == 0 then
					keys["_hold"] = 1
					openVehicleOptions( eyeTrace.Entity, eyeTrace.Entity:GetNWInt( "vehicleID" ) )
					timer.Simple( 1, function()
						keys["_hold"] = 0
					end)
				end
			end
		elseif string == "F11Toggle" then
			GUIToggled = not GUIToggled
			gui.EnableScreenClicker( GUIToggled )
		elseif string == "eat" then
			net.Start( "yrp_eat" )
			net.SendToServer()
		elseif string == "drink" then
			net.Start( "yrp_drink" )
			net.SendToServer()
		elseif string == "vyes" then
			net.Start( "voteYes" )
			net.SendToServer()
		elseif string == "vno" then
			net.Start( "voteNo" )
			net.SendToServer()
		end
	end
end

function keyDown( key, string, string2, distance )
	local ply = LocalPlayer()
	local plyTrace = ply:GetEyeTrace()
	local _return = false
	if distance != nil then
		if plyTrace.Entity:GetPos():Distance( ply:GetPos() ) > distance then
			_return = true
		end
	end
	if !_return then
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
end

function keyPressed( key, string, string2, distance )
	local ply = LocalPlayer()
	local plyTrace = ply:GetEyeTrace()
	local _return = false
	if distance != nil then
		if plyTrace.Entity != nil and plyTrace.Entity != NULL then
			if plyTrace.Entity:GetPos():Distance( ply:GetPos() ) > distance then
				_return = true
			end
		end
	end
	if !_return then
		if keys[tostring(key)] == nil then
			keys[tostring(key)] = false
		end
		if input.IsKeyDown(key) and !keys[tostring(key)] then
			keys[tostring(key)] = true
			timer.Simple( 0.14, function()
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
end

function KeyPress()
	keyDown( IN_ATTACK2, "scoreboard", nil, nil )

	keyPressed( get_keybind("menu_settings"), "openSettings", nil, nil )

	keyPressed( get_keybind("menu_inventory"), "openInventory", nil, nil )

	keyPressed( get_keybind("menu_character_selection"), "openCharMenu", nil, nil )
	keyPressed( get_keybind("menu_role"), "openRoleMenu", nil, nil )
	keyPressed( get_keybind("menu_buy"), "openBuyMenu", nil, nil )

	keyPressed( KEY_E, "openInteractMenu", nil, 100 )

	keyPressed( get_keybind("menu_options_door"), nil, "openOptions", 100 )
	keyPressed( get_keybind("menu_options_vehicle"), nil, "openOptions", 100 )

	keyPressed( get_keybind("toggle_view"), "ViewChange", nil, nil )
	keyPressed( get_keybind("toggle_map"), "openMap", nil, nil )

	keyPressed( get_keybind("toggle_mouse"), "F11Toggle", nil, nil )

	keyPressed( KEY_PAGEUP, "vyes", nil )
	keyPressed( KEY_PAGEDOWN, "vno", nil )
end
hook.Add( "Think", "Thinker", KeyPress)

hook.Add( "StartChat", "HasStartedTyping", function( isTeamChat )
	chatisopen = true
end )

hook.Add( "FinishChat", "ClientFinishTyping", function()
	chatisopen = false
end )

local _savePos = Vector( 0, 0, 0 )
_lookAtEnt = nil
_drawViewmodel = false
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
								--Thirdperson
								local dist = 170 * ply:GetModelScale()

								local _tmpThick = 4
								local _minDistFor = 8
								local _minDistBac = 40
								local tr = util.TraceHull( {
									start = pos + angles:Forward() * _minDistFor,
									endpos = pos - ( angles:Forward() * dist ) + Vector( 0, 0, 16*ply:GetModelScale()),
									filter = {LocalPlayer(),weapon},
									mins = Vector( -_tmpThick, -_tmpThick, -_tmpThick ),
									maxs = Vector( _tmpThick, _tmpThick, _tmpThick ),
									mask = MASK_SHOT_HULL
								} )

								if tr.HitPos:Distance( pos ) < dist and !tr.HitNonWorld then
									dist = tr.HitPos:Distance( pos ) -- _tmpThick
								end

								if tr.Hit and tr.HitPos:Distance( pos ) > _minDistBac then
									view.origin = tr.HitPos
									_savePos = view.origin
									view.angles = angles
									view.fov = fov
									_drawViewmodel = true
									return view
								elseif tr.Hit and tr.HitPos:Distance( pos ) <= _minDistBac then
									view.origin = pos
									view.angles = angles
									view.fov = fov
									_drawViewmodel = false
									return view
								else
									view.origin = pos - ( angles:Forward() * dist ) + Vector( 0, 0, 16*ply:GetModelScale())
									view.angles = angles
									view.fov = fov
									_drawViewmodel = true
									return view
								end
							elseif _thirdperson == 0 then
								--Disabled
							elseif _thirdperson == 1 then
								--Firstperson realistic
								local dist = 170 * ply:GetModelScale()

								local _tmpThick = 16
								local _head = ply:LookupBone( "ValveBiped.Bip01_Head1" )

								if worked( _head, "_head failed @cl_think.lua" ) then
									local tr = util.TraceHull( {
										start = ply:GetBonePosition( _head ) + angles:Forward() * 4,
										endpos = ply:GetBonePosition( _head ) - angles:Forward() * 4,
										filter = {LocalPlayer(),weapon},
										mins = Vector( -_tmpThick, -_tmpThick, -_tmpThick ),
										maxs = Vector( _tmpThick, _tmpThick, _tmpThick ),
										mask = MASK_SHOT_HULL
									} )

									if !tr.Hit then
										pos2 = ply:GetBonePosition( _head ) + ( angles:Forward() * 10 * ply:GetModelScale() ) + ( angles:Up() * 16 * ply:GetModelScale() )
										view.origin = pos2
										_savePos = pos2
										view.angles = angles
										view.fov = fov
										_drawViewmodel = true

										return view
									else
										view.origin = pos
										view.angles = angles
										view.fov = fov
										_drawViewmodel = false
										return view
									end
								else
									view.origin = pos
									view.angles = angles
									view.fov = fov
									_drawViewmodel = false
									return view
								end
							end
						else
							--Disabled
						end
					else
						--LocalPlayer():PrintMessage( HUD_PRINTTALK, _weaponName )
					end
				end
			end
		end
	end
end
hook.Add( "CalcView", "MyCalcView", yrpCalcView )

function showPlayermodel()
	if _thirdperson == 0 or _drawViewmodel == false then
		return false
	else
		return true
	end
end
hook.Add( "ShouldDrawLocalPlayer", "ShowPlayermodel", showPlayermodel )
