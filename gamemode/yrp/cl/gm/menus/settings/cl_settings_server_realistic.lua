--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

net.Receive("Connect_Settings_Realistic", function(len)
	if pa(settingsWindow) then
		function settingsWindow.window.site:Paint(pw, ph)
			draw.RoundedBox(4, 0, 0, pw, ph, Color(0, 0, 0, 254))
		end

		local PARENT = settingsWindow.window.site

		function PARENT:OnRemove()
			net.Start("Disconnect_Settings_Realistic")
			net.SendToServer()
		end

		local REL = net.ReadTable()
		local br = ctr(20)
		local scroller = {}
		scroller.parent = PARENT
		scroller.x = br
		scroller.y = br
		scroller.w = BScrW() - 2 * br
		scroller.h = ScrH() - ctr(100) - 2 * br
		local Scroller = DHorizontalScroller(scroller)
		local general = {}
		general.parent = Scroller
		general.x = 0
		general.y = 0
		general.w = ctr(800)
		general.h = Scroller:GetTall()
		general.br = br / 2
		general.name = "generalsettings"
		local General = DGroup(general)
		local dhr = {}
		dhr.parent = General
		dhr.color = YRPGetColor("2")
		local bl = {}
		bl.parent = General
		bl.color = YRPGetColor("2")
		local ble = {}
		ble.parent = General
		ble.color = YRPGetColor("2")
		ble.brx = ctr(50)
		DBoolLine(bl, REL.bool_bonefracturing, "bonefracturing", "update_bool_bonefracturing")
		DFloatLine(ble, REL.float_bonechance_legs, "% " .. lang_string("breakchancelegs"), "update_float_bonechance_legs")
		DFloatLine(ble, REL.float_bonechance_arms, "% " .. lang_string("breakchancearms"), "update_float_bonechance_arms")
		DHR(dhr)
		DBoolLine(bl, REL.bool_bleeding, "bleeding", "update_bool_bleeding")
		DFloatLine(ble, REL.float_bleedingchance, "% " .. lang_string("bleedingchance"), "update_float_bleedingchance")
		DHR(dhr)
		DBoolLine(bl, REL.bool_custom_falldamage, "customfalldamage", "update_bool_custom_falldamage")
		DBoolLine(ble, REL.bool_custom_falldamage_percentage, "percentage", "update_bool_custom_falldamage_percentage")
		DFloatLine(ble, REL.float_custom_falldamage_muliplier, "multiplier", "update_float_custom_falldamage_muliplier")
		local damage = {}
		damage.parent = Scroller
		damage.x = 0
		damage.y = 0
		damage.w = ctr(1000)
		damage.h = Scroller:GetTall()
		damage.br = br / 2
		damage.name = "damagesettings"
		local Damage = DGroup(damage)
		Damage.dmg = 1
		dhr = {}
		dhr.parent = Damage
		dhr.color = YRPGetColor("2")
		bl = {}
		bl.parent = Damage
		bl.color = YRPGetColor("2")
		ble = {}
		ble.parent = Damage
		ble.color = YRPGetColor("2")
		ble.brx = ctr(50)
		local dmg = DFloatLine(bl, Damage.dmg, "damage", "")
		DHR(dhr)
		DHeader(bl, "players")
		DBoolLine(bl, REL.bool_headshotdeadly_player, "headshotisdeadly", "update_bool_headshotdeadly_player")
		DFloatLine(ble, REL.float_hitfactor_player_head, lang_string("hitfactor") .. " - " .. lang_string("head"), "update_float_hitfactor_player_head", nil, nil, dmg)
		DFloatLine(ble, REL.float_hitfactor_player_ches, lang_string("hitfactor") .. " - " .. lang_string("chest"), "update_float_hitfactor_player_ches", nil, nil, dmg)
		DFloatLine(ble, REL.float_hitfactor_player_stom, lang_string("hitfactor") .. " - " .. lang_string("stomach"), "update_float_hitfactor_player_stom", nil, nil, dmg)
		DFloatLine(ble, REL.float_hitfactor_player_arms, lang_string("hitfactor") .. " - " .. lang_string("arms"), "update_float_hitfactor_player_arms", nil, nil, dmg)
		DFloatLine(ble, REL.float_hitfactor_player_legs, lang_string("hitfactor") .. " - " .. lang_string("legs"), "update_float_hitfactor_player_legs", nil, nil, dmg)
		DHR(dhr)
		DHeader(bl, "npcs")
		DBoolLine(bl, REL.bool_headshotdeadly_npc, "headshotisdeadly", "update_bool_headshotdeadly_npc")
		DFloatLine(ble, REL.float_hitfactor_npc_head, lang_string("hitfactor") .. " - " .. lang_string("head"), "update_float_hitfactor_npc_head", nil, nil, dmg)
		DFloatLine(ble, REL.float_hitfactor_npc_ches, lang_string("hitfactor") .. " - " .. lang_string("chest"), "update_float_hitfactor_npc_ches", nil, nil, dmg)
		DFloatLine(ble, REL.float_hitfactor_npc_stom, lang_string("hitfactor") .. " - " .. lang_string("stomach"), "update_float_hitfactor_npc_stom", nil, nil, dmg)
		DFloatLine(ble, REL.float_hitfactor_npc_arms, lang_string("hitfactor") .. " - " .. lang_string("arms"), "update_float_hitfactor_npc_arms", nil, nil, dmg)
		DFloatLine(ble, REL.float_hitfactor_npc_legs, lang_string("hitfactor") .. " - " .. lang_string("legs"), "update_float_hitfactor_npc_legs", nil, nil, dmg)
		DHR(dhr)
		DFloatLine(ble, REL.float_hitfactor_entities, lang_string("hitfactor") .. " - " .. lang_string("entities"), "update_float_hitfactor_entities", nil, nil, dmg)
		DFloatLine(ble, REL.float_hitfactor_vehicles, lang_string("hitfactor") .. " - " .. lang_string("vehicles"), "update_float_hitfactor_vehicles", nil, nil, dmg)
	end
end)

hook.Add("open_server_realistic", "open_server_realistic", function()
	SaveLastSite()
	local w = settingsWindow.window.sitepanel:GetWide()
	local h = settingsWindow.window.sitepanel:GetTall()
	settingsWindow.window.site = createD("DPanel", settingsWindow.window.sitepanel, w, h, 0, 0)
	net.Start("Connect_Settings_Realistic")
	net.SendToServer()
end)
