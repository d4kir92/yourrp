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

function isChatOpen()
	return chatisopen or false
end

function isConsoleOpen()
	return gui.IsConsoleVisible()
end

function isMainMenuOpen()
	return gui.IsGameUIVisible()
end

hook.Add( "StartChat", "HasStartedTyping", function( isTeamChat )
	chatisopen = true
end )

hook.Add( "FinishChat", "ClientFinishTyping", function()
	chatisopen = false
end )

local keys = {}
keys["_hold"] = 0

hook.Add( "OnSpawnMenuOpen", "yrp_spawn_menu_open", function()
	openMenu()
end)

hook.Add( "OnSpawnMenuClose", "yrp_spawn_menu_close", function()
	closeMenu()
end)

function useFunction( string )
	if string == nil then
		return
	end
	local ply = LocalPlayer()
	local eyeTrace = ply:GetEyeTrace()

	if !isChatOpen() and !isConsoleOpen() and !isMainMenuOpen() then
		//Menues
		if string == "openHelpMenu" then
			toggleHelpMenu()
		elseif string == "openCharMenu" then
			done_tutorial( "tut_cs" )
			toggleCharacterSelection()
		elseif string == "openInventory" then
			done_tutorial( "tut_mi" )
			toggle_inventory()
		elseif string == "openRoleMenu" then
			done_tutorial( "tut_mr" )
			toggleRoleMenu()
		elseif string == "openBuyMenu" then
			done_tutorial( "tut_mb" )
			toggleBuyMenu()
		elseif string == "openSettings" then
			done_tutorial( "tut_ms" )
			toggleSettings()
		elseif string == "openMap" then
			done_tutorial( "tut_tma" )
			toggleMap()
		elseif string == "openInteractMenu" then
			toggleInteractMenu()
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

		//When scoreboard open, enable mouse
		elseif string == "scoreboard" and isScoreboardOpen then
			gui.EnableScreenClicker( true )

		//Inventory
		elseif string == "dropitem" then
			net.Start( "drop_item" )
			net.SendToServer()

		//Mouse changer
		elseif string == "F11Toggle" then
			done_tutorial( "tut_tmo" )
			gui.EnableScreenClicker( !vgui.CursorVisible() )

		elseif string == "vyes" then
			net.Start( "voteYes" )
			net.SendToServer()
		elseif string == "vno" then
			net.Start( "voteNo" )
			net.SendToServer()
		elseif string == "scoreboard" and isScoreboardOpen then
			gui.EnableScreenClicker( true )
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

local clicked = false

function get_speak_channel_name( id )
	if id == 0 then
		return lang_string( "speaklocal" )
	elseif id == 1 then
		return lang_string( "speakgroup" )
	elseif id == 2 then
		return lang_string( "speakglobal" )
	end
end

LocalPlayer():SetNWInt( "view_range", 0 )
function KeyPress()
	local ply = LocalPlayer()
	if isNoMenuOpen() then
		if input.IsKeyDown( get_keybind( "view_zoom_out" ) ) then
			done_tutorial( "tut_vo", 5 )

			ply:SetNWInt( "view_range", ply:GetNWInt( "view_range" ) + 1 )

			if tonumber( ply:GetNWInt( "view_range" ) ) > tonumber( ply:GetNWInt( "view_distance", 0 ) ) then
				ply:SetNWInt( "view_range", tonumber( ply:GetNWInt( "view_distance", 0 ) ) )
			end
		elseif input.IsKeyDown( get_keybind( "view_zoom_in" ) ) then
			done_tutorial( "tut_vi", 5 )

			ply:SetNWInt( "view_range", ply:GetNWInt( "view_range" ) - 1 )

			if ply:GetNWInt( "view_range" ) < -100 then
				ply:SetNWInt( "view_range", -100 )
			end
		end

		if !chatisopen then
			if input.IsKeyDown( get_keybind("speak_next") ) and !clicked then
				done_tutorial( "tut_sn" )
				clicked = true
				net.Start( "press_speak_next" )
				net.SendToServer()

				timer.Simple( 0.4, function()
					clicked = false
					notification.AddLegacy( get_speak_channel_name( LocalPlayer():GetNWInt( "speak_channel" ) ), NOTIFY_GENERIC, 3 )
				end)
			end

			if input.IsKeyDown( get_keybind("speak_prev") ) and !clicked then
				done_tutorial( "tut_sp" )
				clicked = true
				net.Start( "press_speak_prev" )
				net.SendToServer()

				timer.Simple( 0.4, function()
					clicked = false
					notification.AddLegacy( get_speak_channel_name( LocalPlayer():GetNWInt( "speak_channel" ) ), NOTIFY_GENERIC, 3 )
				end)
			end
		end
	end

	keyDown( IN_ATTACK2, "scoreboard", nil, nil )

	keyPressed( KEY_F1, "openHelpMenu", nil, nil )

	keyPressed( get_keybind("menu_settings"), "openSettings", nil, nil )

	keyPressed( get_keybind("menu_inventory"), "openInventory", nil, nil )

	keyPressed( get_keybind("menu_character_selection"), "openCharMenu", nil, nil )
	keyPressed( get_keybind("menu_role"), "openRoleMenu", nil, nil )
	keyPressed( get_keybind("menu_buy"), "openBuyMenu", nil, nil )

	keyPressed( KEY_E, "openInteractMenu", nil, 100 )

	keyPressed( get_keybind("menu_options_door"), nil, "openOptions", 100 )
	keyPressed( get_keybind("menu_options_vehicle"), nil, "openOptions", 100 )

	keyPressed( get_keybind("toggle_map"), "openMap", nil, nil )

	keyPressed( get_keybind("toggle_mouse"), "F11Toggle", nil, nil )

	keyPressed( KEY_PAGEUP, "vyes", nil )
	keyPressed( KEY_PAGEDOWN, "vno", nil )

	keyPressed( get_keybind("drop_item"), "dropitem", nil, nil )
end
hook.Add( "Think", "Thinker", KeyPress)

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
							--if _thirdperson == 2 then
							if ply:GetNWInt( "view_range", 0 ) > 0 then
								--Thirdperson
								local dist = ply:GetNWInt( "view_range", 0 ) * ply:GetModelScale()

								local _tmpThick = 4
								local _minDistFor = 8
								local _minDistBac = 40
								local tr = util.TraceHull( {
									start = pos + angles:Forward() * _minDistFor,
								endpos = pos - ( angles:Forward() * dist ) + Vector( 0, 0, ply:GetNWInt( "view_range", 0 )/3*ply:GetModelScale()),
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
									view.origin = pos - ( angles:Forward() * dist ) + Vector( 0, 0, ply:GetNWInt( "view_range", 0 )/3*ply:GetModelScale())
									view.angles = angles
									view.fov = fov
									_drawViewmodel = true
									return view
								end
							elseif ply:GetNWInt( "view_range", 0 ) > -50 and ply:GetNWInt( "view_range", 0 ) <= 0 then
								--Disabled
								view.origin = pos
								view.angles = angles
								view.fov = fov
								view.drawviewer = false
								_drawViewmodel = false
								return view
							else
								--Firstperson realistic
								local dist = ply:GetNWInt( "view_range", 0 ) * ply:GetModelScale()

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
										pos2 = ply:GetBonePosition( _head ) + ( angles:Forward() * 5 * ply:GetModelScale() ) - Vector( 0, 0, 1.4 ) * ply:GetModelScale() + ( angles:Up() * 6 * ply:GetModelScale() )
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
	if _drawViewmodel == false then
		return false
	else
		return true
	end
end
hook.Add( "ShouldDrawLocalPlayer", "ShowPlayermodel", showPlayermodel )
