--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--cl_think.lua

local _cmdpre = "[COMMAND] "
local _cmdsv = "This command is adminonly/serversided!"
concommand.Add( "yrp_usergroup", function( ply, cmd, args )
	printGM( "note", _cmdpre .. _cmdsv )
end )

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

hook.Add( "HUDWeaponPickedUp", "yrp_translate_weaponname", function( wep )
	if wep.LanguageString != nil then
		wep.PrintName = lang_string( wep.LanguageString )
	end
end)

function GM:PlayerSwitchWeapon( ply, oldWeapon, newWeapon )
	--[[ Change language ]]--
	if newWeapon.LanguageString != nil then
		newWeapon.PrintName = lang_string( newWeapon.LanguageString )
	end
end


function useFunction( string )
	if string == nil then
		return
	end
	local ply = LocalPlayer()
	local eyeTrace = ply:GetEyeTrace()

	if !isChatOpen() and !isConsoleOpen() and !isMainMenuOpen() then
		--Menues
		if string == "openSP" then
			openSP()
		elseif string == "closeSP" then
			closeSP()
		elseif string == "openHelpMenu" then
			done_tutorial( "tut_feedback" )
			done_tutorial( "tut_f1info", 10 )
			toggleHelpMenu()
		elseif string == "ToggleEmotesMenu" then
			ToggleEmotesMenu()
		elseif string == "openFeedbackMenu" then
			toggleFeedbackMenu()
		elseif string == "openCharMenu" then
			done_tutorial( "tut_cs" )
			toggleCharacterSelection()
		elseif string == "openAppearance" then
			toggleAppearanceMenu()
		elseif string == "openInventory" then
			done_tutorial( "tut_mi" )
			ToggleInventory()
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
			if eyeTrace.Entity != NULL then
				if eyeTrace.Entity:GetClass() == "prop_door_rotating" or eyeTrace.Entity:GetClass() == "func_door" or eyeTrace.Entity:GetClass() == "func_door_rotating" then
					toggleDoorOptions( eyeTrace.Entity )
				elseif eyeTrace.Entity:IsVehicle() then
					toggleVehicleOptions( eyeTrace.Entity, eyeTrace.Entity:GetNWInt( "item_uniqueID" ) )
				end
			end

		--When scoreboard open, enable mouse
		elseif string == "scoreboard" and isScoreboardOpen then
			gui.EnableScreenClicker( true )

		--Inventory
		elseif string == "dropitem" and !mouseVisible() then
			local _weapon = LocalPlayer():GetActiveWeapon()
			if _weapon != NULL then
				local _pname = _weapon:GetPrintName() or _weapon.PrintName or lang_string( "weapon" )
				if _weapon.notdropable == nil then
					net.Receive( "dropswep", function( len )
						local _b = net.ReadBool()
						if _b then
							notification.AddLegacy( _pname .. " " .. lang_string( "hasbeendropped" ), 0, 3 )
						else
							notification.AddLegacy( _pname .. " " .. string.lower( lang_string( "cannotbedropped" ) ), 0, 3 )
						end
					end)
					net.Start( "dropswep" )
					net.SendToServer()
				else
					notification.AddLegacy( _pname .. " " .. string.lower( lang_string( "cannotbedropped" ) ), 0, 3 )
				end
			end

		--Weapon Lowering
		elseif string == "weaponlowering" and !mouseVisible() then
			net.Start( "yrp_weaponlowering" )
			net.SendToServer()

		--Mouse changer
		elseif string == "F11Toggle" then
			done_tutorial( "tut_tmo" )
			gui.EnableScreenClicker( !vgui.CursorVisible() )

		elseif string == "vyes" and !mouseVisible() then
			net.Start( "voteYes" )
			net.SendToServer()
		elseif string == "vno" and !mouseVisible() then
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
		if ea( plyTrace.Entity ) then
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
LocalPlayer():SetNWInt( "view_range_view", 0 )

LocalPlayer():SetNWInt( "view_z", 0 )
LocalPlayer():SetNWInt( "view_x", 0 )
LocalPlayer():SetNWInt( "view_s", 0 )

local _view_delay = true
function KeyPress()
	local ply = LocalPlayer()
	if isNoMenuOpen() then
		if input.IsKeyDown( get_keybind( "view_switch" ) ) then
			--[[ When toggle view ]]--
			if _view_delay then
				_view_delay = false
				timer.Simple( 0.16, function()
					_view_delay = true
				end)

				if tonumber( ply:GetNWInt( "view_range_view", 0 ) ) > 0 then
					ply:SetNWInt( "view_range_view", 0 )
				else
					local _old_view = tonumber( LocalPlayer():GetNWInt( "view_range_old", 0 ) )
					if _old_view > 0 then
						ply:SetNWInt( "view_range_view", _old_view )
					else
						ply:SetNWInt( "view_range_view", tonumber( LocalPlayer():GetNWString( "text_view_distance", "0" ) ) )
					end
				end

				ply:SetNWInt( "view_range", ply:GetNWInt( "view_range_view" ) )
			end
		else
			--[[ smoothing ]]--
			if tonumber( ply:GetNWInt( "view_range", 0 ) ) < tonumber( ply:GetNWInt( "view_range_view", 0 ) ) then
				ply:SetNWInt( "view_range", ply:GetNWInt( "view_range" ) + ply:GetNWInt( "view_range_view" )/16 )
			else

				if input.IsKeyDown( get_keybind( "view_zoom_out" ) ) then
					done_tutorial( "tut_vo", 5 )

					ply:SetNWInt( "view_range_view", ply:GetNWInt( "view_range_view" ) + 1 )

					if tonumber( ply:GetNWInt( "view_range_view" ) ) > tonumber( ply:GetNWString( "text_view_distance", "0" ) ) then
						ply:SetNWInt( "view_range_view", tonumber( ply:GetNWString( "text_view_distance", "0" ) ) )
					end
					ply:SetNWInt( "view_range_old", ply:GetNWInt( "view_range_view" ) )
				elseif input.IsKeyDown( get_keybind( "view_zoom_in" ) ) then
					done_tutorial( "tut_vi", 5 )

					ply:SetNWInt( "view_range_view", ply:GetNWInt( "view_range_view" ) - 1 )

					if tonumber( ply:GetNWInt( "view_range_view", 0 ) ) < -200 then
						ply:SetNWInt( "view_range_view", -200 )
					end
					ply:SetNWInt( "view_range_old", ply:GetNWInt( "view_range_view" ) )
				end
				ply:SetNWInt( "view_range", ply:GetNWInt( "view_range_view" ) )
			end
		end

		--[[ Up and down ]]--
		if input.IsKeyDown( get_keybind( "view_up" ) ) then
			ply:SetNWInt( "view_z_c", ply:GetNWInt( "view_z_c" ) + 0.1 )
		elseif input.IsKeyDown( get_keybind( "view_down" ) ) then
			ply:SetNWInt( "view_z_c", ply:GetNWInt( "view_z_c" ) - 0.1 )
		end
		if tonumber( ply:GetNWInt( "view_z_c" ) ) > 100 then
			ply:SetNWInt( "view_z_c", 100 )
		elseif tonumber( ply:GetNWInt( "view_z_c" ) ) < -100 then
			ply:SetNWInt( "view_z_c", -100 )
		end
		if tonumber( ply:GetNWInt( "view_z_c" ) ) < 3 and tonumber( ply:GetNWInt( "view_z_c" ) ) > -3 then
			ply:SetNWInt( "view_z", 0 )
		else
			ply:SetNWInt( "view_z", ply:GetNWInt( "view_z_c" ) )
		end

		--[[ Left and right ]]--
		if input.IsKeyDown( get_keybind( "view_right" ) ) then
			ply:SetNWInt( "view_x_c", ply:GetNWInt( "view_x_c" ) + 0.1 )
		elseif input.IsKeyDown( get_keybind( "view_left" ) ) then
			ply:SetNWInt( "view_x_c", ply:GetNWInt( "view_x_c" ) - 0.1 )
		end
		if tonumber( ply:GetNWInt( "view_x_c" ) ) > 300 then
			ply:SetNWInt( "view_x_c", 300 )
		elseif tonumber( ply:GetNWInt( "view_x_c" ) ) < -300 then
			ply:SetNWInt( "view_x_c", -300 )
		end
		if tonumber( ply:GetNWInt( "view_x_c" ) ) < 3 and tonumber( ply:GetNWInt( "view_x_c" ) ) > -3 then
			ply:SetNWInt( "view_x", 0 )
		else
			ply:SetNWInt( "view_x", ply:GetNWInt( "view_x_c" ) )
		end

		--[[ spin right and spin left ]]--
		if input.IsKeyDown( get_keybind( "view_spin_right" ) ) then
			ply:SetNWInt( "view_s_c", ply:GetNWInt( "view_s_c" ) + 0.4 )
		elseif input.IsKeyDown( get_keybind( "view_spin_left" ) ) then
			ply:SetNWInt( "view_s_c", ply:GetNWInt( "view_s_c" ) - 0.4 )
		end
		if tonumber( ply:GetNWInt( "view_s_c" ) ) > 360 or tonumber( ply:GetNWInt( "view_s_c" ) ) < -360 then
			ply:SetNWInt( "view_s_c", 0 )
		end
		if tonumber( ply:GetNWInt( "view_s_c" ) ) < 6 and tonumber( ply:GetNWInt( "view_s_c" ) ) > -6 then
			ply:SetNWInt( "view_s", 0 )
		else
			ply:SetNWInt( "view_s", ply:GetNWInt( "view_s_c" ) )
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
	keyPressed( KEY_F7, "openFeedbackMenu", nil, nil )

	keyPressed( get_keybind("menu_emotes"), "ToggleEmotesMenu", nil, nil )

	keyPressed( get_keybind("menu_settings"), "openSettings", nil, nil )

	keyPressed( get_keybind("menu_inventory"), "openInventory", nil, nil )
	keyPressed( get_keybind("menu_appearance"), "openAppearance", nil, nil )

	keyPressed( get_keybind("menu_character_selection"), "openCharMenu", nil, nil )
	keyPressed( get_keybind("menu_role"), "openRoleMenu", nil, nil )
	keyPressed( get_keybind("menu_buy"), "openBuyMenu", nil, nil )

	keyPressed( KEY_E, "openInteractMenu", nil, 100 )

	keyPressed( get_keybind("menu_options_door"), "openOptions", nil, 100 )
	keyPressed( get_keybind("menu_options_vehicle"), "openOptions", nil, 100 )

	keyPressed( get_keybind("toggle_map"), "openMap", nil, nil )

	keyPressed( get_keybind("toggle_mouse"), "F11Toggle", nil, nil )

	keyPressed( KEY_PAGEUP, "vyes", nil )
	keyPressed( KEY_PAGEDOWN, "vno", nil )

	keyPressed( get_keybind("drop_item"), "dropitem", nil, nil )

	keyPressed( get_keybind("weaponlowering"), "weaponlowering", nil, nil )

	keyPressed( KEY_UP, "openSP", nil )
	keyPressed( KEY_DOWN, "closeSP", nil )
end
hook.Add( "Think", "Thinker", KeyPress)

local _savePos = Vector( 0, 0, 0 )
_lookAtEnt = nil
_drawViewmodel = false

local function yrpCalcView( ply, pos, angles, fov )
	if ply:Alive() and !ply:IsPlayingTaunt() then
		local weapon = ply:GetActiveWeapon()
		if weapon != NULL then
			if weapon:GetClass() != nil then
				local _weaponName = string.lower( tostring( ply:GetActiveWeapon():GetClass() ) )
				if !string.find( _weaponName, "lightsaber", 0, false ) and !ply:GetNWBool( "istaunting", false ) then
					local view = {}

					if ply:Alive() and ply:GetModel() != "models/player.mdl" and !ply:InVehicle() then
						if ply:LookupBone( "ValveBiped.Bip01_Head1" ) != nil then
							pos2 = ply:GetBonePosition( ply:LookupBone( "ValveBiped.Bip01_Head1" ) ) + ( angles:Forward() * 12 * ply:GetModelScale() )
						end
						if ply:GetMoveType() == MOVETYPE_NOCLIP and ply:GetModel() == "models/crow.mdl" then
							local _view_range = ply:GetNWInt( "view_range", 0 )
							if _view_range < 0 then
								_view_range = 0
							end
							local dist = _view_range * ply:GetModelScale()

							local _tmpThick = 4
							local _minDistFor = 8
							local _minDistBac = 40
							if dist > 0 then
								_drawViewmodel = true
							else
								_drawViewmodel = false
							end
							view.origin = pos - ( angles:Forward() * dist ) - Vector( 0, 0, 58 )
							view.angles = angles
							view.fov = fov
							return view
						else
						--if _thirdperson == 2 then

							if tonumber( ply:GetNWInt( "view_range", 0 ) ) > 0 then
								if ply:LookupBone( "ValveBiped.Bip01_Head1" ) != nil then
									local _head = ply:GetPos().z + ply:OBBMaxs().z
									pos.z = _head
								end
								--Thirdperson
								local dist = ply:GetNWInt( "view_range", 0 ) * ply:GetModelScale()

								local _tmpThick = 4
								local _minDistFor = 8
								local _minDistBac = 40
								angles = angles + Angle( 0, ply:GetNWInt( "view_s" ), 0 )
								local _pos_change = angles:Up() * ply:GetNWInt( "view_z" ) + angles:Right() * ply:GetNWInt( "view_x" )

									--ply:GetNWInt( "view_s" )

								local tr = util.TraceHull( {
									start = pos + angles:Forward() * _minDistFor,
									endpos = pos - ( angles:Forward() * dist ) + _pos_change,
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
									view.origin = pos - ( angles:Forward() * dist ) + _pos_change
									view.angles = angles
									view.fov = fov
									_drawViewmodel = true
									return view
								end
							elseif tonumber( ply:GetNWInt( "view_range", 0 ) ) > -200 and tonumber( ply:GetNWInt( "view_range", 0 ) ) <= 0 then
								--Disabled
								_drawViewmodel = false
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
hook.Add( "CalcView", "MyCalcView", yrpCalcView )

function showPlayermodel()
	if _drawViewmodel or LocalPlayer():IsPlayingTaunt() then
		return true
	else
		return false
	end
end
hook.Add( "ShouldDrawLocalPlayer", "ShowPlayermodel", showPlayermodel )
