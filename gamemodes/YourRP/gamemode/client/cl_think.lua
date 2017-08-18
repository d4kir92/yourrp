//cl_think.lua

local chatisopen = 0
_menuIsOpen = 0
_thirdperson = 0
local _thirdpersonC = 0
local keyCooldown = 0.2
local pressedKey = CurTime() + keyCooldown
local _lastkey = nil

function KeyPress()
	local ply = LocalPlayer()
	local eyeTrace = ply:GetEyeTrace()

	if pressedKey < CurTime() then
		pressedKey = CurTime() + keyCooldown

		if input.IsKeyDown(KEY_E) and chatisopen == 0 and _menuIsOpen == 0 and eyeTrace.Entity:GetClass() == "prop_door_rotating" then
			_lastkey = KEY_E
		elseif input.IsKeyDown(KEY_E) and chatisopen == 0 and _menuIsOpen == 0 then

			if eyeTrace.Entity:IsPlayer() then
				openInteractMenu( eyeTrace.Entity:SteamID() )
			//else
				//openInteractMenu( "STEAM_0:1:20900349" )
			end
		elseif input.IsKeyDown(KEY_F2) and _menuIsOpen == 0 then
			openRoleMenu()
		elseif input.IsKeyDown(KEY_F2) and _menuIsOpen == 1 then
			if roleMenuWindow != nil then
				roleMenuWindow:Close()
			end
		elseif input.IsKeyDown(KEY_F4) and _menuIsOpen == 0 then
			_menuIsOpen = 1
			openBuyMenu()
		elseif input.IsKeyDown(KEY_F4) and _menuIsOpen == 1 then
			if _buyWindow != nil then
				_buyWindow:Close()
			end
		elseif input.IsKeyDown(KEY_F7) and _menuIsOpen == 0 then
			_menuIsOpen = 1
			openSettings()
		elseif input.IsKeyDown(KEY_F7) and _menuIsOpen == 1 then
			if settingsWindow != nil then
				settingsWindow:Close()
			end
		elseif input.IsKeyDown(KEY_B) and chatisopen == 0 and _menuIsOpen == 0 then
				_thirdpersonC = _thirdpersonC + 1
				if _thirdpersonC > 2 then
					_thirdpersonC = 0
				end

				if _thirdpersonC == 0 then
					_thirdperson = 4
					timer.Simple( 0.3, function()
						_thirdperson = 0
					end)
				elseif _thirdpersonC == 1 then
					_thirdperson = 1
				elseif _thirdpersonC == 2 then
					_thirdperson = 3
					timer.Simple( 0.3, function()
						_thirdperson = 2
					end)
				end
		elseif input.IsKeyDown( KEY_M ) and chatisopen == 0 then
			if mapopen == 0 then
				mapopen = 1
				net.Start( "askCoords")
			    net.WriteEntity( LocalPlayer() )
			  net.SendToServer()
			else
				mapopen = 0
				mapWindow:Remove()
			end
		end
	else
		if pressedKey - (keyCooldown/2) < CurTime() then
			if input.IsKeyDown( KEY_E ) and _menuIsOpen == 0 then
				if _lastkey == KEY_E then

					openDoorOptions( eyeTrace.Entity, eyeTrace.Entity:GetNWInt( "buildingID" ) )
				end
			else
				_lastkey = nil
			end
		end
	end
end
hook.Add( "Think", "Thinker", KeyPress)

hook.Add( "StartChat", "HasStartedTyping", function( isTeamChat )
	chatisopen = 1
end )

hook.Add( "FinishChat", "ClientFinishTyping", function()
	chatisopen = 0
end )

local _savePos = Vector( 0, 0, 0 )
local function yrpCalcView( ply, pos, angles, fov )
	if ply:Alive() then
		if ply:GetActiveWeapon() != nil then
			local weapon = ply:GetActiveWeapon()
			if weapon.ClassName != nil then
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
								start = pos,
								endpos = pos - ( angles:Forward() * dist ),
								filter = LocalPlayer(),
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
							end
						elseif _thirdperson == 0 then
							//Disabled
						elseif _thirdperson == 3 then
							if ply:LookupBone( "ValveBiped.Bip01_Head1" ) != nil then
								_savePos = LerpVector( 10 * FrameTime(), _savePos, ply:GetBonePosition( ply:LookupBone( "ValveBiped.Bip01_Head1" ) ) - ( angles:Forward() * 100 * ply:GetModelScale() ) + Vector( 0, 0, 16*ply:GetModelScale() ) )
								view.origin = _savePos
								view.angles = angles
								view.fov = fov
								view.drawviewer = true
								return view
							end
						elseif _thirdperson == 4 then
							if ply:LookupBone( "ValveBiped.Bip01_Head1" ) != nil then
								_savePos = LerpVector( 10 * FrameTime(), _savePos, pos2 )
								view.origin = _savePos
								view.angles = angles
								view.fov = fov
								view.drawviewer = true
								return view
							end
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
