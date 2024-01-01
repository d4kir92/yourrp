--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
--cl_think.lua
local _cmdpre = "[COMMAND] "
local _cmdsv = "This command is adminonly/serversided!"
concommand.Add(
	"yrp_usergroup",
	function(ply, cmd, args)
		YRP.msg("note", _cmdpre .. _cmdsv)
	end
)

local chatisopen = false
_thirdperson = 0
local _thirdpersonC = 0
local _lastkey = nil
ch_attack1 = 0
function YRPIsChatOpen()
	return chatisopen or false
end

function YRPIsConsoleOpen()
	return gui.IsConsoleVisible()
end

function YRPIsMainMenuOpen()
	return gui.IsGameUIVisible()
end

local wasgroup = false
hook.Add(
	"StartChat",
	"yrp_startchat",
	function(isTeamChat)
		chatisopen = true
		net.Start("nws_yrp_startchat")
		net.SendToServer()
		if isTeamChat then
			wasgroup = true
			SetChatMode("GROUP")
		elseif wasgroup then
			wasgroup = false
			SetChatMode("SAY")
		end
	end
)

hook.Add(
	"FinishChat",
	"yrp_finishchat",
	function()
		chatisopen = false
		net.Start("nws_yrp_finishchat")
		net.SendToServer()
	end
)

local keys = {}
keys["_hold"] = 0
hook.Add(
	"HUDWeaponPickedUp",
	"yrp_translate_weaponname",
	function(wep)
		if wep.LanguageString ~= nil then
			wep.PrintName = YRP.trans(wep.LanguageString)
		end
	end
)

function GM:PlayerSwitchWeapon(ply, oldWeapon, newWeapon)
	-- Change language
	if newWeapon.LanguageString ~= nil then
		newWeapon.PrintName = YRP.trans(newWeapon.LanguageString)
	end
end

function YRPCloseAllMenues()
	YRPCloseCombinedMenu()
	CloseHelpMenu()
	CloseEmotesMenu()
	closeTicketMenu()
	closeCharMenu()
	closeKeybindsMenu()
	YRPCloseCharacterSelection()
	close_appearance()
	YRPCloseInventory()
	CloseRoleMenu()
	YRPCloseBuyMenu()
	F8CloseSettings()
	closeMap()
	closeInteractMenu()
	closeSP()
	if yrpChat and yrpChat.closeChatbox then
		yrpChat.closeChatbox("CLOSE ALL")
	end
end

function YRPUseFunction(str)
	if str == nil then return end
	local lply = LocalPlayer()
	local eyeTrace = lply:GetEyeTrace()
	if str == "close_all" then
		YRPCloseAllMenues()
	end

	if not YRPIsChatOpen() and not YRPIsConsoleOpen() and not YRPIsMainMenuOpen() then
		--Menues
		if str == "openSP" then
			openSP()
		elseif str == "closeSP" then
			closeSP()
		elseif str == "YRPToggleEmotesMenu" then
			YRPToggleEmotesMenu()
		elseif str == "YRPToggleLawsMenu" then
			YRPToggleLawsMenu()
		elseif str == "openCharacterMenu" then
			done_tutorial("tut_cs")
			YRPToggleCharacterSelection()
		elseif str == "openAppearance" then
			YRPToggleAppearanceMenu()
		elseif str == "openInventory" then
			done_tutorial("tut_mi")
			YRPToggleInventory()
		elseif str == "openSettings" then
			done_tutorial("tut_ms")
			YRPToggleSettings()
		elseif str == "openMap" then
			done_tutorial("tut_tma")
			YRPToggleMap()
		elseif str == "openInteractMenu" then
			YRPToggleInteractMenu()
		elseif str == "voice_mute" then
			net.Start("nws_yrp_mute_voice")
			net.SendToServer()
		elseif str == "voice_range_up" then
			net.Start("nws_yrp_voice_range_up")
			net.SendToServer()
		elseif str == "voice_range_dn" then
			net.Start("nws_yrp_voice_range_dn")
			net.SendToServer()
		elseif str == "voice_menu" then
			if input.IsShiftDown() then
				YRPToggleVoiceMenu()
			elseif input.IsKeyDown(KEY_LALT) then
				NextVoiceChannel()
			else
				net.Start("nws_yrp_ToggleVoiceMenu")
				net.SendToServer()
			end
		elseif str == "chat_menu" then
			YRPToggleChatMenu()
		elseif str == "macro_menu" then
			YRPToggleMacroMenu()
		elseif str == "menu_group" then
			YRPToggleGroupMenu()
		elseif str == "openOptions" then
			if eyeTrace.Entity ~= NULL then
				if eyeTrace.Entity:GetClass() == "prop_door_rotating" or eyeTrace.Entity:GetClass() == "func_door" or eyeTrace.Entity:GetClass() == "func_door_rotating" then
					YRPToggleDoorOptions(eyeTrace.Entity)
				elseif eyeTrace.Entity:IsVehicle() then
					YRPToggleVehicleOptions(eyeTrace.Entity, eyeTrace.Entity:GetYRPInt("item_uniqueID"))
				end
			end
		elseif str == "dropitem" and not YRPMouseVisible() then
			--Inventory
			local _weapon = LocalPlayer():GetActiveWeapon()
			if _weapon ~= NULL then
				local _pname = _weapon:GetPrintName() or _weapon.PrintName or YRP.trans("LID_weapon")
				local tab = {}
				tab["ITEM"] = _pname
				local cannotbedropped = YRP.trans("LID_cannotbedropped", tab)
				local hasbeendropped = YRP.trans("LID_hasbeendropped", tab)
				if _weapon.notdropable == nil then
					net.Receive(
						"nws_yrp_dropswep",
						function(len)
							local _b = net.ReadBool()
							if _b then
								notification.AddLegacy(hasbeendropped, 0, 3)
							else
								notification.AddLegacy(cannotbedropped, 0, 3)
							end
						end
					)

					net.Start("nws_yrp_dropswep")
					net.SendToServer()
				else
					notification.AddLegacy(cannotbedropped, 0, 3)
				end
			end
		elseif str == "toggle_mouse" then
			--Mouse changer
			done_tutorial("tut_tmo")
			gui.EnableScreenClicker(not vgui.CursorVisible())
		elseif str == "vyes" and not YRPMouseVisible() then
			net.Start("nws_yrp_voteYes")
			net.SendToServer()
		elseif str == "vno" and not YRPMouseVisible() then
			net.Start("nws_yrp_voteNo")
			net.SendToServer()
		elseif string.StartWith(str, "m_") then
			str = string.Replace(str, "m_", "")
			local uid = tonumber(str)
			UseMacro(uid)
		elseif GetGlobalYRPBool("bool_yrp_combined_menu", false) then
			local id = 0
			if str == "OpenHelpMenu" and GetGlobalYRPBool("bool_yrp_help_menu", false) then
				done_tutorial("tut_f1info", 10)
				id = 1
			elseif str == "OpenRoleMenu" and GetGlobalYRPBool("bool_yrp_role_menu", false) then
				id = 2
			elseif str == "OpenBuyMenu" and GetGlobalYRPBool("bool_yrp_buy_menu", false) then
				id = 3
			elseif str == "openCharMenu" and GetGlobalYRPBool("bool_yrp_char_menu", false) then
				id = 4
			elseif str == "openKeybindsMenu" and GetGlobalYRPBool("bool_yrp_keybinds_menu", false) then
				id = 5
			elseif str == "openTicketMenu" and GetGlobalYRPBool("bool_yrp_tickets_menu", false) then
				done_tutorial("tut_feedback")
				id = 6
			end

			if id > 0 then
				YRPToggleCombinedMenu(id)
			end
		elseif not GetGlobalYRPBool("bool_yrp_combined_menu", false) then
			if str == "OpenHelpMenu" and GetGlobalYRPBool("bool_yrp_help_menu", false) then
				done_tutorial("tut_welcome")
				done_tutorial("tut_feedback")
				done_tutorial("tut_f1info", 10)
				YRPToggleHelpMenu()
			elseif str == "OpenRoleMenu" and GetGlobalYRPBool("bool_yrp_role_menu", false) then
				done_tutorial("tut_mr")
				YRPToggleRoleMenu()
			elseif str == "OpenBuyMenu" and GetGlobalYRPBool("bool_yrp_buy_menu", false) then
				done_tutorial("tut_mb")
				YRPToggleBuyMenu()
			elseif str == "openTicketMenu" and GetGlobalYRPBool("bool_yrp_tickets_menu", false) then
				YRPToggleTicketMenu()
			elseif str == "openCharMenu" and GetGlobalYRPBool("bool_yrp_char_menu", false) then
				YRPToggleCharMenu()
			elseif str == "openKeybindsMenu" and GetGlobalYRPBool("bool_yrp_keybinds_menu", false) then
				YRPToggleKeybindsMenu()
			end

			if str == "OpenRoleMenu" and not GetGlobalYRPBool("bool_yrp_role_menu", false) then
				DarkRP.toggleF4Menu()
			end
		end
	end
end

function YRPKeyDown(key, str, distance)
	local lply = LocalPlayer()
	local plyTrace = lply:GetEyeTrace()
	local _return = false
	if distance ~= nil and plyTrace.Entity:GetPos():Distance(ply:GetPos()) > distance then
		_return = true
	end

	if not _return then
		if keys[tostring(key)] == nil then
			keys[tostring(key)] = false
		end

		if lply:KeyDown(key) and not keys[tostring(key)] then
			keys[tostring(key)] = true
			timer.Simple(
				0.2,
				function()
					if str ~= nil then
						YRPUseFunction(str)
					end

					keys[tostring(key)] = false
				end
			)
		end
	end
end

function YRPKeyPressed(key, str, distance)
	if key == nil then return end
	if ChatIsClosedForChat and ChatIsClosedForChat() then
		local lply = LocalPlayer()
		if IsValid(lply) and IsNotNilAndNotFalse(lply.GetEyeTrace) then
			local plyTrace = lply:GetEyeTrace()
			local _return = false
			if plyTrace and distance and YRPEntityAlive(plyTrace.Entity) and plyTrace.Entity:GetPos():Distance(lply:GetPos()) > distance then
				_return = true
			end

			if not _return and key then
				if keys[tostring(key)] == nil then
					keys[tostring(key)] = false
				end

				key = tonumber(key)
				if key and input.IsKeyDown(key) and not keys[tostring(key)] then
					keys[tostring(key)] = true
					timer.Simple(
						0.14,
						function()
							if str ~= nil then
								YRPUseFunction(str)
							end

							keys[tostring(key)] = false
						end
					)
				end
			end
		end
	end
end

local afktime = CurTime()
local _view_delay = true
local blink_delay = 0
local setup = false
local hudFail = hudFail or false
function YRPKeyPress()
	local lply = LocalPlayer()
	lply.yrp_view_range = lply.yrp_view_range or 0
	lply.yrp_view_range_view = lply.yrp_view_range_view or 0
	lply.yrp_view_z = lply.yrp_view_z or 0
	lply.yrp_view_x = lply.yrp_view_x or 0
	lply.yrp_view_s = lply.yrp_view_s or 0
	lply.yrp_view_z_c = lply.yrp_view_z_c or 0
	lply.yrp_view_x_c = lply.yrp_view_x_c or 0
	lply.yrp_view_s_c = lply.yrp_view_s_c or 0
	if not setup then
		setup = true
		lply.yrp_view_range = 0
		lply.yrp_view_range_view = 0
		lply.yrp_view_z = 0
		lply.yrp_view_x = 0
		lply.yrp_view_s = 0
		lply.yrp_view_z_c = 0
		lply.yrp_view_x_c = 0
		lply.yrp_view_s_c = 0
	else
		if lply:IsInCombat() and CurTime() > blink_delay and not system.HasFocus() then
			blink_delay = CurTime() + 1
			system.FlashWindow()
		end

		if lply:AFK() then
			local afk = true
			for i = 107, 113 do
				if input.IsMouseDown(i) then
					afk = false
					break
				end
			end

			if afk then
				for i = 0, 159 do
					if lply:KeyDown(i) then
						afk = false
						break
					end
				end
			end

			if not afk then
				net.Start("nws_yrp_notafk")
				net.SendToServer()
			end
		else
			for i = 107, 113 do
				if input.IsMouseDown(i) then
					afktime = CurTime()
				end
			end

			for i = 0, 159 do
				if lply:KeyDown(i) then
					afktime = CurTime()
				end
			end

			-- AFKTIME
			if afktime + 300 < CurTime() then
				net.Start("nws_yrp_setafk")
				net.SendToServer()
			end
		end

		if not vgui.CursorVisible() then
			if YRPGetKeybind("view_switch") and input.IsKeyDown(YRPGetKeybind("view_switch")) then
				-- When toggle view
				if _view_delay then
					_view_delay = false
					timer.Simple(
						0.16,
						function()
							_view_delay = true
						end
					)

					if tonumber(lply.yrp_view_range_view) > 0 then
						lply.yrp_view_range_view = 0
					else
						local _old_view = lply.yrp_view_range_old or 0
						if _old_view > 0 then
							lply.yrp_view_range_view = _old_view
						else
							lply.yrp_view_range_view = tonumber(GetGlobalYRPString("text_view_distance", "200"))
						end
					end

					lply.yrp_view_range = lply.yrp_view_range_view
				end
			else
				-- smoothing
				if tonumber(lply.yrp_view_range) < tonumber(lply.yrp_view_range_view) then
					lply.yrp_view_range = lply.yrp_view_range + lply.yrp_view_range_view / 16
				else
					if YRPGetKeybind("view_zoom_out") and input.IsKeyDown(YRPGetKeybind("view_zoom_out")) then
						done_tutorial("tut_vo", 5)
						lply.yrp_view_range_view = lply.yrp_view_range_view + 1
						if tonumber(lply.yrp_view_range_view) > tonumber(GetGlobalYRPString("text_view_distance", "200")) then
							lply.yrp_view_range_view = tonumber(GetGlobalYRPString("text_view_distance", "200"))
						end

						lply.yrp_view_range_old = lply.yrp_view_range_view
					elseif YRPGetKeybind("view_zoom_in") and input.IsKeyDown(YRPGetKeybind("view_zoom_in")) then
						done_tutorial("tut_vi", 5)
						lply.yrp_view_range_view = lply.yrp_view_range_view - 1
						if tonumber(lply.yrp_view_range_view) < -200 then
							lply.yrp_view_range_view = -200
						end

						lply.yrp_view_range_old = lply.yrp_view_range_view
					end

					lply.yrp_view_range = lply.yrp_view_range_view
				end
			end

			-- Up and down
			if YRPGetKeybind("view_up") and input.IsKeyDown(YRPGetKeybind("view_up")) then
				lply.yrp_view_z_c = lply.yrp_view_z_c + 0.1
			elseif YRPGetKeybind("view_down") and input.IsKeyDown(YRPGetKeybind("view_down")) then
				lply.yrp_view_z_c = lply.yrp_view_z_c - 0.1
			end

			if tonumber(lply.yrp_view_z_c) > 100 then
				lply.yrp_view_z_c = 100
			elseif tonumber(lply.yrp_view_z_c) < -100 then
				lply.yrp_view_z_c = -100
			end

			if tonumber(lply.yrp_view_z_c) < 3 and tonumber(lply.yrp_view_z_c) > -3 then
				lply.yrp_view_z = 0
			else
				lply.yrp_view_z = lply.yrp_view_z_c
			end

			-- Left and right
			if YRPGetKeybind("view_right") and input.IsKeyDown(YRPGetKeybind("view_right")) then
				lply.yrp_view_x_c = lply.yrp_view_x_c + 0.1
			elseif YRPGetKeybind("view_left") and input.IsKeyDown(YRPGetKeybind("view_left")) then
				lply.yrp_view_x_c = lply.yrp_view_x_c - 0.1
			end

			if tonumber(lply.yrp_view_x_c) > 300 then
				lply.yrp_view_x_c = 300
			elseif tonumber(lply.yrp_view_x_c) < -300 then
				lply.yrp_view_x_c = -300
			end

			if tonumber(lply.yrp_view_x_c) < 3 and tonumber(lply.yrp_view_x_c) > -3 then
				lply.yrp_view_x = 0
			else
				lply.yrp_view_x = lply.yrp_view_x_c
			end

			-- spin right and spin left
			if YRPGetKeybind("view_spin_right") and input.IsKeyDown(YRPGetKeybind("view_spin_right")) then
				lply.yrp_view_s_c = lply.yrp_view_s_c + 0.4
			elseif YRPGetKeybind("view_spin_left") and input.IsKeyDown(YRPGetKeybind("view_spin_left")) then
				lply.yrp_view_s_c = lply.yrp_view_s_c - 0.4
			end

			if tonumber(lply.yrp_view_s_c) > 360 or tonumber(lply.yrp_view_s_c) < -360 then
				lply.yrp_view_s_c = 0
			end

			if tonumber(lply.yrp_view_s_c) < 6 and tonumber(lply.yrp_view_s_c) > -6 then
				lply.yrp_view_s = 0
			else
				lply.yrp_view_s = lply.yrp_view_s_c
			end
		end
	end

	YRPKeyPressed(KEY_ESCAPE, "close_all")
	YRPKeyPressed(KEY_F1, "OpenHelpMenu")
	YRPKeyPressed(KEY_F7, "openTicketMenu")
	YRPKeyPressed(YRPGetKeybind("menu_char"), "openCharMenu")
	YRPKeyPressed(YRPGetKeybind("menu_keybinds"), "openKeybindsMenu")
	YRPKeyPressed(YRPGetKeybind("menu_emotes"), "YRPToggleEmotesMenu")
	YRPKeyPressed(YRPGetKeybind("menu_laws"), "YRPToggleLawsMenu")
	YRPKeyPressed(YRPGetKeybind("menu_settings"), "openSettings")
	YRPKeyPressed(YRPGetKeybind("menu_inventory"), "openInventory")
	YRPKeyPressed(YRPGetKeybind("menu_appearance"), "openAppearance")
	YRPKeyPressed(YRPGetKeybind("menu_character_selection"), "openCharacterMenu")
	YRPKeyPressed(YRPGetKeybind("menu_role"), "OpenRoleMenu")
	YRPKeyPressed(YRPGetKeybind("menu_buy"), "OpenBuyMenu")
	YRPKeyPressed(YRPGetKeybind("menu_interact"), "openInteractMenu", GetGlobalYRPInt("int_door_distance", 200))
	YRPKeyPressed(YRPGetKeybind("menu_options_door"), "openOptions", GetGlobalYRPInt("int_door_distance", 200))
	YRPKeyPressed(YRPGetKeybind("menu_options_vehicle"), "openOptions", GetGlobalYRPInt("int_door_distance", 200))
	YRPKeyPressed(YRPGetKeybind("toggle_map"), "openMap")
	YRPKeyPressed(YRPGetKeybind("toggle_mouse"), "toggle_mouse")
	--YRPKeyPressed(KEY_PAGEUP, "vyes" )
	--YRPKeyPressed(KEY_PAGEDOWN, "vno" )
	YRPKeyPressed(YRPGetKeybind("drop_item"), "dropitem")
	YRPKeyPressed(KEY_UP, "openSP")
	YRPKeyPressed(KEY_DOWN, "closeSP")
	YRPKeyPressed(YRPGetKeybind("voice_mute"), "voice_mute")
	YRPKeyPressed(YRPGetKeybind("voice_range_up"), "voice_range_up")
	YRPKeyPressed(YRPGetKeybind("voice_range_dn"), "voice_range_dn")
	YRPKeyPressed(YRPGetKeybind("voice_menu"), "voice_menu")
	YRPKeyPressed(YRPGetKeybind("chat_menu"), "chat_menu")
	YRPKeyPressed(YRPGetKeybind("menu_group"), "menu_group")
	if GetGlobalYRPBool("bool_yrp_macro_menu", false) then
		YRPKeyPressed(YRPGetKeybind("macro_menu"), "macro_menu")
	end

	for i = 1, 49 do
		if YRPGetKeybind("m_" .. i) ~= 0 then
			YRPKeyPressed(YRPGetKeybind("m_" .. i), "m_" .. i)
		end
	end
end

hook.Add("Think", "Thinker", YRPKeyPress)
local _savePos = Vector(0, 0, 0)
_lookAtEnt = nil
local PLAYER = FindMetaTable("Player")
function TauntCamera()
	local CAM = {}
	CAM.ShouldDrawLocalPlayer = function(self, pl, on) return true end
	CAM.CalcView = function(self, view, pl, on) return true end
	CAM.CreateMove = function(self, cmd, pl, on) return true end

	return CAM
end

PLAYER.TauntCam = TauntCamera()
-- #THIRDPERSON
local oldang = Angle(0, 0, 0)
function YRP_CalcView(lply, pos, angles, fov)
	if angles ~= nil then
		lply.yrp_view_range = lply.yrp_view_range or 0
		lply.yrp_view_range_view = lply.yrp_view_range_view or 0
		lply.yrp_view_z = lply.yrp_view_z or 0
		lply.yrp_view_x = lply.yrp_view_x or 0
		lply.yrp_view_s = lply.yrp_view_s or 0
		lply.yrp_view_z_c = lply.yrp_view_z_c or 0
		lply.yrp_view_x_c = lply.yrp_view_x_c or 0
		lply.yrp_view_s_c = lply.yrp_view_s_c or 0
		--and !lply:IsPlayingTaunt() then
		if lply:Alive() then
			local view = {}
			if lply:AFK() and (oldang.p + 1 < angles.p and oldang.p - 1 < angles.p) or (oldang.y + 1 < angles.y and oldang.y - 1 < angles.y) or (oldang.r + 1 < angles.r and oldang.r - 1 < angles.r) then
				net.Start("nws_yrp_notafk")
				net.SendToServer()
			end

			oldang = angles
			local disablethirdperson = false
			local weapon = lply:GetActiveWeapon()
			if weapon ~= NULL and weapon:GetClass() ~= nil then
				local _weaponName = string.lower(tostring(lply:GetActiveWeapon():GetClass()))
				if _weaponName ~= "yrp_lightsaber_base" and string.find(_weaponName, "lightsaber", 1, true) then
					disablethirdperson = true
				end
			end

			local _view_range = lply.yrp_view_range or 0
			if _view_range < 0 then
				_view_range = 0
			end

			if lply:IsPlayingTaunt() then
				disablethirdperson = false
				_view_range = 200
			end

			local dist = _view_range * lply:GetModelScale()
			if lply:GetModel() ~= "models/player.mdl" and not lply:InVehicle() and not disablethirdperson and GetGlobalYRPBool("bool_thirdperson", false) then
				if lply:LookupBone("ValveBiped.Bip01_Head1") ~= nil then
					pos2 = lply:GetBonePosition(lply:LookupBone("ValveBiped.Bip01_Head1")) + (angles:Forward() * 12 * lply:GetModelScale())
				end

				if lply:GetMoveType() == MOVETYPE_NOCLIP and lply:GetModel() == "models/crow.mdl" then
					local _tmpThick = 4
					local _minDistFor = 8
					local _minDistBac = 40
					if dist > 0 then
						view.drawviewer = true
					else
						view.drawviewer = false
					end

					view.origin = pos - (angles:Forward() * dist) - Vector(0, 0, 58)
					view.angles = angles
					view.fov = fov

					return view
				else
					--if _thirdperson == 2 then
					if tonumber(lply.yrp_view_range or 0) > 0 then
						if lply:LookupBone("ValveBiped.Bip01_Head1") ~= nil then
							local _head = lply:GetPos().z + lply:OBBMaxs().z
							pos.z = _head
						end

						--Thirdperson
						dist = lply.yrp_view_range * lply:GetModelScale()
						local _tmpThick = 4
						local _minDistFor = 2
						local _minDistBac = 40
						angles = angles + Angle(0, lply.yrp_view_s, 0)
						local _pos_change = angles:Up() * lply.yrp_view_z + angles:Right() * lply.yrp_view_x
						local tr = util.TraceHull(
							{
								start = pos - angles:Forward() * _minDistFor,
								endpos = pos - (angles:Forward() * dist) + _pos_change,
								filter = function(ent)
									if ent:GetCollisionGroup() == 20 then
										return false
									elseif ent == LocalPlayer() then
										return false
									elseif ent == weapon then
										return false
									end

									return true
								end,
								mins = Vector(-_tmpThick, -_tmpThick, -_tmpThick),
								maxs = Vector(_tmpThick, _tmpThick, _tmpThick),
								mask = MASK_SHOT_HULL
							}
						)

						if tr.HitPos:Distance(pos) < dist and not tr.HitNonWorld then
							dist = tr.HitPos:Distance(pos) -- _tmpThick
						end

						if tr.Hit and tr.HitPos:Distance(pos) > _minDistBac then
							view.origin = tr.HitPos
							_savePos = view.origin
							view.angles = angles
							view.fov = fov
							view.drawviewer = true

							return view
						elseif tr.Hit and tr.HitPos:Distance(pos) <= _minDistBac then
							view.origin = pos
							view.angles = angles
							view.fov = fov
							view.drawviewer = false

							return view
						else
							view.origin = pos - (angles:Forward() * dist) + _pos_change
							view.angles = angles
							view.fov = fov
							view.drawviewer = true

							return view
						end
					elseif tonumber(lply.yrp_view_range) <= -200 then
						local _tmpThick = 16
						local _head = lply:LookupBone("ValveBiped.Bip01_Head1")
						if YRPWORKED(_head, "_head failed @cl_think.lua") then
							local tr = util.TraceHull(
								{
									start = lply:GetBonePosition(_head) + angles:Forward() * 4,
									endpos = lply:GetBonePosition(_head) - angles:Forward() * 4,
									filter = {LocalPlayer(), weapon},
									mins = Vector(-_tmpThick, -_tmpThick, -_tmpThick),
									maxs = Vector(_tmpThick, _tmpThick, _tmpThick),
									mask = MASK_SHOT_HULL
								}
							)

							if not tr.Hit then
								pos2 = lply:GetBonePosition(_head) + (angles:Forward() * 5 * lply:GetModelScale()) - Vector(0, 0, 1.4) * lply:GetModelScale() + (angles:Up() * 6 * lply:GetModelScale())
								view.origin = pos2
								_savePos = pos2
								view.angles = angles
								view.fov = fov
								view.drawviewer = true

								return view
							else
								view.origin = pos
								view.angles = angles
								view.fov = fov
								view.drawviewer = false

								return view
							end
						else
							view.origin = pos
							view.angles = angles
							view.fov = fov
							view.drawviewer = false

							return view
						end
					end
				end
			end
		else
			local entindex = lply:GetYRPInt("ent_ragdollindex")
			if entindex then
				local ent = Entity(entindex)
				if IsValid(ent) then
					pos = ent:GetPos() + Vector(0, 0, 64) - angles:Forward() * 100
				end

				local view = {}
				view.origin = pos
				view.angles = angles
				view.fov = fov
				view.drawviewer = true

				return view
			end
		end
	end
end

if hook.GetTable()["CalcView"] and hook.GetTable()["CalcView"]["AV7View"] then
	hook.Remove("CalcView", "AV7View") -- breaks thirdperson, must be removed!
end

if hook.GetTable()["CalcView"] == nil or (hook.GetTable()["CalcView"] and hook.GetTable()["CalcView"]["YOURRP_ThirdPerson_CalcView"] == nil) then
	hook.Add("CalcView", "YOURRdP_ThirdPerson_CalcView", YRP_CalcView)
end

function GM:ShouldDrawLocalPlayer(pl)
end

-- NOTHING
jobByCmd = jobByCmd or {}
-- FOR CLIENTS
net.Receive(
	"nws_yrp_send_jobs",
	function(len)
		local tab = net.ReadTable()
		for id, name in pairs(tab) do
			_G[string.upper(name)] = tonumber(id)
		end
	end
)

-- FOR CLIENTS
-- full jobs data
net.Receive(
	"nws_yrp_Send_DarkRP_Jobs",
	function(len)
		local teamTab = {}
		teamTab.admin = net.ReadUInt(2)
		teamTab.candemote = net.ReadBool()
		teamTab.category = net.ReadString()
		teamTab.color = net.ReadColor()
		teamTab.command = net.ReadString()
		teamTab.description = net.ReadString()
		teamTab.fake = net.ReadBool()
		teamTab.hasLicense = net.ReadBool()
		teamTab.int_groupID = net.ReadUInt(16)
		teamTab.max = net.ReadUInt(8)
		teamTab.model = net.ReadTable()
		teamTab.name = net.ReadString()
		teamTab.salary = net.ReadUInt(16)
		teamTab.team = net.ReadUInt(16)
		teamTab.uniqueID = net.ReadUInt(16)
		teamTab.vote = net.ReadBool()
		teamTab.weapons = net.ReadTable()
		local teamcolor = teamTab.color
		local teamuid = tonumber(teamTab.uniqueID)
		local teamname = teamTab.name
		if not strEmpty(teamTab.identifier) then
			teamname = teamTab.identifier
		end

		_G[teamTab.command] = teamuid
		if teamuid and teamname then
			RPExtraTeams[teamuid] = teamTab
			jobByCmd[teamTab.command] = teamuid
			--table.insert(RPExtraTeams, teamTab) -- old
			team.SetUp(teamuid, teamname, teamcolor)
		end
	end
)

CATEGORIES = CATEGORIES or {}
CATEGORIES.jobs = CATEGORIES.jobs or {}
CATEGORIES.entities = CATEGORIES.entities or {}
CATEGORIES.shipments = CATEGORIES.shipments or {}
CATEGORIES.weapons = CATEGORIES.weapons or {}
CATEGORIES.ammo = CATEGORIES.ammo or {}
CATEGORIES.vehicles = CATEGORIES.vehicles or {}
net.Receive(
	"nws_yrp_Send_DarkRP_Categories",
	function(len)
		local catTab = {}
		catTab.uniqueID = net.ReadUInt(16)
		catTab.name = net.ReadString()
		catTab.categorises = net.ReadString()
		catTab.startExpanded = net.ReadBool()
		catTab.color = net.ReadColor()
		catTab.sortOrder = net.ReadUInt(7)
		catTab = YRPConvertToDarkRPCategory(catTab, "jobs")
		--CATEGORIES.jobs[catname] = catTab -- ipairs not working with that
		table.insert(CATEGORIES.jobs, catTab)
	end
)

net.Receive(
	"nws_yrp_Combine_DarkRPTables",
	function(len)
		local TEMPRPExtraTeams = {}
		for i, v in pairs(RPExtraTeams) do
			if v.fake == false then
				TEMPRPExtraTeams[tonumber(i)] = v
			end
		end

		RPExtraTeams = TEMPRPExtraTeams
		for i, cat in pairs(CATEGORIES.jobs) do
			cat.members = {}
			for id, role in pairs(RPExtraTeams) do
				if role and cat and role.int_groupID == cat.uniqueID then
					table.insert(cat.members, role)
				end
			end
		end

		hook.Run("bKeypads.ConfigUpdated")
		hook.Run("PostGamemodeLoaded")
		if GAMEMODE.DarkRPFinishedLoading then
			GAMEMODE:DarkRPFinishedLoading()
		end
	end
)