--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
net.Receive(
	"nws_yrp_connect_Settings_Realistic",
	function(len)
		local PARENT = GetSettingsSite()
		if YRPPanelAlive(PARENT) then
			function PARENT:OnRemove()
				net.Start("nws_yrp_disconnect_Settings_Realistic")
				net.SendToServer()
			end

			local REL = net.ReadTable()
			local br = YRP.ctr(20)
			local scroller = {}
			scroller.parent = PARENT
			scroller.x = br
			scroller.y = br
			scroller.w = PARENT:GetWide() - 2 * br
			scroller.h = PARENT:GetTall() - 2 * br
			local Scroller = DHorizontalScroller(scroller)
			local General = YRPCreateD("YGroupBox", Scroller, YRP.ctr(800), Scroller:GetTall(), 0, 0)
			General:SetText("LID_generalsettings")
			function General:Paint(pw, ph)
				hook.Run("YGroupBoxPaint", self, pw, ph)
			end

			Scroller:AddPanel(General)
			function Scroller:Paint(pw, ph)
				if self.w ~= PARENT:GetWide() or self.h ~= PARENT:GetTall() then
					self.w = PARENT:GetWide()
					self.w = PARENT:GetTall()
					self:SetSize(PARENT:GetWide() - YRP.ctr(2 * 20), PARENT:GetTall() - YRP.ctr(2 * 20))
					self:SetPos(YRP.ctr(20), YRP.ctr(20))
				end
			end

			local dhr = {}
			dhr.parent = General
			dhr.color = YRPGetColor("2")
			local bl = {}
			bl.parent = General
			bl.color = YRPGetColor("2")
			local ble = {}
			ble.parent = General
			ble.color = YRPGetColor("2")
			ble.brx = YRP.ctr(50)
			DBoolLine(bl, REL.bool_bonefracturing, "LID_bonefracturing", "nws_yrp_update_bool_bonefracturing")
			DFloatLine(ble, REL.float_bonechance_legs, "% " .. YRP.trans("LID_breakchancelegs"), "nws_yrp_update_float_bonechance_legs")
			DFloatLine(ble, REL.float_bonechance_arms, "% " .. YRP.trans("LID_breakchancearms"), "nws_yrp_update_float_bonechance_arms")
			DHR(dhr)
			DBoolLine(bl, REL.bool_bleeding, "LID_bleeding", "nws_yrp_update_bool_bleeding")
			DFloatLine(ble, REL.float_bleedingchance, "% " .. YRP.trans("LID_bleedingchance"), "nws_yrp_update_float_bleedingchance")
			DHR(dhr)
			DBoolLine(bl, REL.bool_slowing, "LID_slowing", "nws_yrp_update_bool_slowing")
			DFloatLine(ble, REL.float_slowingtime, "LID_slowingtime", "nws_yrp_update_float_slowingtime")
			DFloatLine(ble, REL.float_slowingfactor, "LID_slowingfactor", "nws_yrp_update_float_slowingfactor")
			DHR(dhr)
			DBoolLine(bl, REL.bool_custom_falldamage, "LID_customfalldamage", "nws_yrp_update_bool_custom_falldamage")
			DBoolLine(ble, REL.bool_custom_falldamage_percentage, "LID_percentage", "nws_yrp_update_bool_custom_falldamage_percentage")
			DFloatLine(ble, REL.float_custom_falldamage_muliplier, "LID_multiplier", "nws_yrp_update_float_custom_falldamage_muliplier")
			local Damage = YRPCreateD("YGroupBox", Scroller, YRP.ctr(1000), Scroller:GetTall(), 0, 0)
			Damage:SetText("LID_damagesettings")
			function Damage:Paint(pw, ph)
				hook.Run("YGroupBoxPaint", self, pw, ph)
			end

			Scroller:AddPanel(Damage)
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
			ble.brx = YRP.ctr(50)
			local dmg = DFloatLine(bl, Damage.dmg, "LID_damage", "")
			DHR(dhr)
			DHeader(bl, "LID_players")
			DBoolLine(bl, REL.bool_headshotdeadly_player, "LID_headshotisdeadly", "nws_yrp_update_bool_headshotdeadly_player")
			DFloatLine(ble, REL.float_hitfactor_player_head, YRP.trans("LID_hitfactor") .. " - " .. YRP.trans("LID_head"), "nws_yrp_update_float_hitfactor_player_head", nil, nil, dmg)
			DFloatLine(ble, REL.float_hitfactor_player_ches, YRP.trans("LID_hitfactor") .. " - " .. YRP.trans("LID_chest"), "nws_yrp_update_float_hitfactor_player_ches", nil, nil, dmg)
			DFloatLine(ble, REL.float_hitfactor_player_stom, YRP.trans("LID_hitfactor") .. " - " .. YRP.trans("LID_stomach"), "nws_yrp_update_float_hitfactor_player_stom", nil, nil, dmg)
			DFloatLine(ble, REL.float_hitfactor_player_arms, YRP.trans("LID_hitfactor") .. " - " .. YRP.trans("LID_arms"), "nws_yrp_update_float_hitfactor_player_arms", nil, nil, dmg)
			DFloatLine(ble, REL.float_hitfactor_player_legs, YRP.trans("LID_hitfactor") .. " - " .. YRP.trans("LID_legs"), "nws_yrp_update_float_hitfactor_player_legs", nil, nil, dmg)
			DHR(dhr)
			DHeader(bl, "LID_npcs")
			DBoolLine(bl, REL.bool_headshotdeadly_npc, "LID_headshotisdeadly", "nws_yrp_update_bool_headshotdeadly_npc")
			DFloatLine(ble, REL.float_hitfactor_npc_head, YRP.trans("LID_hitfactor") .. " - " .. YRP.trans("LID_head"), "nws_yrp_update_float_hitfactor_npc_head", nil, nil, dmg)
			DFloatLine(ble, REL.float_hitfactor_npc_ches, YRP.trans("LID_hitfactor") .. " - " .. YRP.trans("LID_chest"), "nws_yrp_update_float_hitfactor_npc_ches", nil, nil, dmg)
			DFloatLine(ble, REL.float_hitfactor_npc_stom, YRP.trans("LID_hitfactor") .. " - " .. YRP.trans("LID_stomach"), "nws_yrp_update_float_hitfactor_npc_stom", nil, nil, dmg)
			DFloatLine(ble, REL.float_hitfactor_npc_arms, YRP.trans("LID_hitfactor") .. " - " .. YRP.trans("LID_arms"), "nws_yrp_update_float_hitfactor_npc_arms", nil, nil, dmg)
			DFloatLine(ble, REL.float_hitfactor_npc_legs, YRP.trans("LID_hitfactor") .. " - " .. YRP.trans("LID_legs"), "nws_yrp_update_float_hitfactor_npc_legs", nil, nil, dmg)
			DHR(dhr)
			DFloatLine(ble, REL.float_hitfactor_entities, YRP.trans("LID_hitfactor") .. " - " .. YRP.trans("LID_entities"), "nws_yrp_update_float_hitfactor_entities", nil, nil, dmg)
			DFloatLine(ble, REL.float_hitfactor_vehicles, YRP.trans("LID_hitfactor") .. " - " .. YRP.trans("LID_vehicles"), "nws_yrp_update_float_hitfactor_vehicles", nil, nil, dmg)
		end
	end
)

function OpenSettingsRealistic()
	net.Start("nws_yrp_connect_Settings_Realistic")
	net.SendToServer()
end